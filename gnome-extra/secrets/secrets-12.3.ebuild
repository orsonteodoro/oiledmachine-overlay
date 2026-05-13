# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO:
# Reduce the database lock timeout to 30 seconds.

# This ebuild used AI inference to help assist in customization.
# The AI solution was modified with a human solution instead.
# Some patches contain AI generated code.
# The ebuild contains AI synthetic data.

# F44

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{12..14} )
DISTUTILS_SINGLE_IMPL=1

inherit gnome2-utils meson distutils-r1 optfeature web-kernel-config xdg

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://gitlab.gnome.org/World/secrets.git"
	FALLBACK_COMMIT="17161044e611107b176438ebb8f0be81d33a804e" # Feb 22, 2026
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://gitlab.gnome.org/World/secrets/-/archive/${PV}/${P}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Manage your passwords"
HOMEPAGE="
	https://apps.gnome.org/Secrets/
	https://gitlab.gnome.org/World/secrets
"
LICENSE="
	GPL-3
	hibp? (
		Have-I-Been-Pwned-Privacy-Policy
		Have-I-Been-Pwned-Terms-of-Use
	)
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
# hibp is default ON/opt-in but disabled by default in this ebuild to prevent
# the possibility of 3rdparty snooping, data collection, and degraded password
# complexity.
# Upstream uses -safe-symbols by default.
IUSE+="
dev hibp +safe-symbols wayland X
ebuild_revision_11
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| (
		wayland
		X
	)
"
RDEPEND+="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/pygobject-3.52[${PYTHON_USEDEP}]
		>=dev-python/pykeepass-4.1.1[${PYTHON_USEDEP}]
		>=dev-python/pyotp-2.6.0[${PYTHON_USEDEP}]
		>=dev-python/zxcvbn-rs-py-0.2.0[${PYTHON_USEDEP}]
		dev-python/PyKCS11[${PYTHON_USEDEP}]
		dev-python/python-yubico[${PYTHON_USEDEP}]
		dev-python/pycryptodome[${PYTHON_USEDEP}]
		dev-python/validators[${PYTHON_USEDEP}]
		hibp? (
			dev-python/pyhibp[${PYTHON_USEDEP}]
		)
	')
	>=dev-libs/glib-2.73.1[introspection]
	>=dev-libs/gobject-introspection-1.66.0[${PYTHON_SINGLE_USEDEP}]
	>=gui-libs/gtk-4.15.3[introspection,wayland?,X?]
	>=gui-libs/gtksourceview-5.0[introspection]
	>=gui-libs/libadwaita-1.8_beta[introspection]
	dev? (
		dev-python/mypy
		dev-util/ruff
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/meson-1.7
"
DOCS=( "CHANGELOG.md" "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-12.3-fix-pyproject.patch"
	"${FILESDIR}/${PN}-12.3-optionalize-hibp.patch"
	"${FILESDIR}/${PN}-12.3-reduce-database-lock-time.patch"
	"${FILESDIR}/${PN}-12.3-change-default-password-generator-length.patch"
	"${FILESDIR}/${PN}-12.3-enable-numbers-as-default-for-password-generator.patch"
	"${FILESDIR}/${PN}-12.3-symbol-set-change-and-enable-symbols-by-default.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
	web-kernel-config_setup
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

python_prepare() {
	sed -i \
		-e "s|Cryptodome.Cipher|Crypto.Cipher|g" \
		-e "s|Cryptodome.Random|Crypto.Random|g" \
		"gsecrets/utils.py" || die
	local hibp_support=$(usex hibp "True" "False")
	sed -i \
		-e "s|@HIBP_SUPPORT@|${hibp_support}|g" \
		"data/gtk/database_settings_dialog.ui" \
		"gsecrets/widgets/database_settings_dialog.py" \
		|| die
	local safe_symbols=$(usex safe-symbols "True" "False")
	sed -i \
		-e "s|@GSECRETS_SAFE_SYMBOLS@|${safe_symbols}|g" \
		"gsecrets/password_generator.py" \
		|| die
}

# @FUNCTION: has_all_hardening_flags
# @DESCRIPTION:
# Check each package individually for compiler hardening requirements.
has_all_hardening_flags() {
	local pkg="${1}"
	local F
	F=(
		"-O2"
		"-fno-delete-null-pointer-checks"
		"-fstrict-flex-arrays=3"
		"-ftrivial-auto-var-init=zero"
		"-fzero-call-used-regs=all"
		"-fwrapv"
	)

	local found_count=0
	local f
	for f in "${F[@]}" ; do
		if grep -q -e "${f}" "/var/db/pkg/${pkg}-"*"/CFLAGS" 2>/dev/null ; then
			found_count=$(( ${found_count} + 1 ))
		fi
	done

	# Transient execution CPU vulnerability mitigations
	# ID = Information Disclosure
	# CE = Code Execution
	local found_count_id_mitigation=0
	if [[ "${tags}" =~ "sensitive-data" ]] ; then
		F=(
			"-fcf-protection=full"
			"-fhardened"
			"-mbranch-protection=pac-ret+bti"
			"-mbranch-protection=standard"
			"-mharden-sls=all"
			"-mretpoline"
			"-mindirect-branch=thunk"
			"-mindirect-branch=thunk-extern"
			"-mindirect-branch=thunk-inline"
			"-mfunction-return=thunk"
			"-mfunction-return=thunk-extern"
			"-mfunction-return=thunk-inline"
		)
		for f in "${F[@]}" ; do
			if grep -q -e "${f}" "/var/db/pkg/${pkg}-"*"/CFLAGS" 2>/dev/null ; then
				found_count_id_mitigation=$(( ${found_count_id_mitigation} + 1 ))
			fi
		done
	fi

	if [[ "${tags}" =~ "sensitive-data" ]] ; then
		if (( ${found_count} == 6 && ${found_count_id_mitigation} >= 1 )) ; then
			return 0
		fi
	else
		if (( ${found_count} == 6 )) ; then
			return 0
		fi
	fi
	return 1
}

# @FUNCTION: verify_compiler_flags_hardening
# @DESCRIPTION:
# Check compiler hardening requirements.
verify_compiler_flags_hardening() {
	local L1=(
		"unconditional:gui-libs/gtk:sensitive-data,untrusted-data"

	# All input deps

	# All password processing or password data path packages
		"unconditional:dev-libs/libtomcrypt:sensitive-data,untrusted-data"
		"unconditional:dev-python/argon2-cffi-bindings:sensitive-data,untrusted-data"
		"unconditional:dev-python/argon2-cffi:sensitive-data,untrusted-data"
		"unconditional:dev-python/pycryptodome:sensitive-data,untrusted-data"
		"unconditional:dev-python/pygobject:sensitive-data"
		"unconditional:dev-python/PyKCS11:sensitive-data"
		"unconditional:dev-python/zxcvbn-rs-py:sensitive-data"

	# All deps used for possible text/image rendering, text processing
		"unconditional:dev-libs/glib:attack-surface-risk,sensitive-data"
		"unconditional:media-libs/harfbuzz:sensitive-data,untrusted-data"
		"unconditional:media-libs/libglvnd:untrusted-data"								# RDEPEND of mesa
		"unconditional:media-libs/mesa:attack-surface-risk,sensitive-data,untrusted-data"
		"unconditional:x11-libs/gdk-pixbuf:sensitive-data,untrusted-data"
		"unconditional:x11-libs/pango:sensitive-data,untrusted-data"
		"unconditional:x11-libs/cairo:sensitive-data,untrusted-data"

	# All Wayland deps
		"wayland:dev-libs/wayland:attack-surface-risk,manual"

	# All X11 deps
		"X:x11-base/xorg-server:sensitive-data"
		"X:x11-libs/libxcb:sensitive-data"
		"X:x11-libs/libxkbcommon:sensitive-data"
		"X:x11-libs/libX11:sensitive-data"
	)

	local row
	for row in "${L1[@]}" ; do
		local u=$(echo "${row}" | cut -f 1 -d ":")
		local p=$(echo "${row}" | cut -f 2 -d ":")
		local tag=$(echo "${row}" | cut -f 3 -d ":")
		if [[ "${tag}" =~ "manual" ]] ; then
			if [[ "${u}" == "unconditional" ]] ; then
ewarn "The package ${p} must be manually security-critical hardened using per-package package.env.  Use the hardening flags from the build log."
			elif use "${u}" && ! has_all_hardening_flags "${p}" ; then
ewarn "The package ${p} must be manually security-critical hardened using per-package package.env.  Use the hardening flags from the build log."
			fi
		elif [[ "${u}" == "unconditional" ]] ; then
			local repo=$(cat "/var/db/pkg/${p}-"*"/repository" | sed -e "/oiledmachine-overlay/d" | head -n 1)
			if ! grep -q -e "oiledmachine-overlay" "${ESYSROOT}/var/db/pkg/${p}-"*"/repository" ; then
ewarn "The package ${p}::${repo} may not be security-critical hardened.  Use the ${p}::oiledmachine-overlay ebuild instead."
			fi
		elif use "${u}" ; then
			if ! grep -q -e "oiledmachine-overlay" "${ESYSROOT}/var/db/pkg/${p}-"*"/repository" ; then
				local repo=$(cat "/var/db/pkg/${p}-"*"/repository" | sed -e "/oiledmachine-overlay/d" | head -n 1)
ewarn "The package ${p}::${repo} may not be security-critical hardened.  Use the ${p}::oiledmachine-overlay ebuild instead."
			fi
		fi
	done

	local L2=(
		"dev-libs/weston"
		"gui-liri/liri-shell"
		"gui-wm/cage"
		"gui-wm/cagebreak"
		"gui-wm/dwl"
		"gui-wm/kiwmi"
		"gui-wm/hyprland"
		"gui-wm/labwc"
		"gui-wm/mangowc"
		"gui-wm/miracle-wm"
		"gui-wm/newm"
		"gui-wm/niri"
		"gui-wm/river"
		"gui-wm/sway"
		"gui-wm/waybox"
		"gui-wm/wayfire"
		"kde-plasma/kwin"
		"x11-wm/enlightenment"
		"x11-wm/mutter"
	)

	if use wayland ; then
		local found_compositor=0
		local x
		for x in "${L2[@]}" ; do
			if has_version "${x}" ; then
				found_compositor=1
ewarn "${x} must use security-critical hardened ebuilds or per-package package.env hardening.  Use the hardening flags from the build log."
			fi
		done

		if (( ${found_compositor} == 0 )) ; then
ewarn "Wayland compositors must use security-critical hardened ebuilds or per-package package.env hardening.  Use the hardening flags from the build log."
		fi
	fi

ewarn "Packages that interact with ${PN} (e.g. password managers, clipboard managers) must use security-critical hardened ebuilds or per-package package.env hardening.  Use the hardening flags from the build log."
}

src_configure() {
	verify_compiler_flags_hardening
	local emesonargs=()
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	docinto "licenses"
	dodoc "LICENSE"
	meson_src_install
	python_fix_shebang "${ED}/usr/bin/${PN}"
	python_optimize
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_pkg_postinst
einfo
einfo "Password length recommendations"
einfo
einfo "| Use cases                | Password length       | Format                                         |"
einfo "| ---                      | ---                   | ---                                            |"
einfo "| Burner / throwaway login | 16-20+                | The built in key generator                     |"
einfo "| Social media login       | 20+                   | The built in key generator                     |"
einfo "| Archives                 | 25+                   | The built in key generator                     |"
einfo "| Master password          | 25+ (6-7 words min)   | Your own collection of words that no one knows |"
einfo
einfo "Tip:  Do not abuse the reduce password length button!  The ebuild default is 20 characters for social media."
einfo "Tip:  Do not abuse the + button for save lock timeout!  The default is 1 minute to mitigate a cold boot attack."
einfo "Tip:  Don't FAFO!"
einfo
einfo "AI accelerated Q-Day is forecasted to be as early as 2029 (3-4) years from now."
einfo
einfo "Recommendations for Q-Day mitigation"
einfo
einfo "The password length does not need to change but the algorithm used or"
einfo "properties need to be properly selected now for the rollover into Q-Day"
einfo "against \"Harvest Now, Decrypt Later\" threat actors."
einfo
einfo "| Type       | Pre Q-Day example             | Attack  | Quantum cracking mitigation                                     | Use cases                                      |"
einfo "| ---        | ---                           | ---     | ---                                                             | ---                                            |"
einfo "| Asymmetric | ECDH                          | Shor    | Switch to a post-quantum algorithm (e.g. ML-KEM, SLH-DSA)       | Secure messaging handshake, digital signatures |"
einfo "| Symmetric  | AES-128                       | Grover  | Double key length (e.g. AES-128 -> AES-256,                     | Archives                                       |"
einfo "|            | aes-xts-plain64 [256-bit key] |         | aes-xts-plain64 [256-bit key] -> aes-xts-plain64 [512-bit key]) | Full disk encryption                           |"
einfo "| Hash       | SHA-256                       | Grover  | Double key length (e.g. SHA-256 -> SHA-512)                     | LUKS2 integrity                                |"
einfo "| KDF        | PBKDF2                        | Grover  | Switch to a memory-hard algorithm (e.g. Argon2id, Argon2d)      | LUKS2 keys, kdbx, user database tables         |"
einfo
einfo "Pausible deniablibilty is estimated to be lower security score than"
einfo "LUKS2 at or beyond Q-Day, but it still retains human weakness factor."
einfo
        optfeature_header "Install optional packages:"
        optfeature "DMA attack mitigation for USB4 (USB-C) and USB keyboard snooping mitigation against an evil maid attack" "sys-apps/usbguard"
        optfeature "DMA attack mitigation for Thunderbolt" "sys-apps/bolt"
	# TODO: Add PCIe DMA attack hotplug mitigation suggestion
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_pkg_postrm
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive, 12.3, 20260505)
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive, 12.3, 20260507)
# Copy-paste password:  pass
# Default enable numbers for password generator defaults:  pass
# Default enable symbols for password generator defaults:  pass
# HIBP disable:  pass
# KeePassXC kdbx import:  pass
# New database creation:  pass
# Open new password database:  pass
# Password verify:  pass
# Safe symbols:  pass
