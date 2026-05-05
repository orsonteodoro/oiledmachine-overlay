# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# F44

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{12..14} )
DISTUTILS_SINGLE_IMPL=1

inherit meson distutils-r1 web-kernel-config

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://gitlab.gnome.org/World/secrets.git"
	FALLBACK_COMMIT="17161044e611107b176438ebb8f0be81d33a804e" # Feb 22, 2026
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
#	KEYWORDS="~amd64" # Not finished yet
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
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" dev wayland X"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| (
		wayland
		X
	)
"
TRASH="
"
RDEPEND+="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/pykeepass-4.1.0[${PYTHON_USEDEP}]
		>=dev-python/pyotp-2.6.0[${PYTHON_USEDEP}]
		dev-python/validators[${PYTHON_USEDEP}]
		>=dev-python/zxcvbn-rs-py-0.2.0[${PYTHON_USEDEP}]
		|| (
			dev-python/PyKCS11[${PYTHON_USEDEP}]
			dev-python/pykcs11[${PYTHON_USEDEP}]
		)
		dev-python/python-yubico[${PYTHON_USEDEP}]
		>=dev-python/pygobject-3.52[${PYTHON_USEDEP}]
		>=dev-python/pykeepass-4.1.1[${PYTHON_USEDEP}]
	')
	>=dev-libs/gobject-introspection-1.66.0[${PYTHON_SINGLE_USEDEP}]
	>=dev-libs/glib-2.73.1
	>=gui-libs/gtksourceview-5.0
	>=gui-libs/gtk-4.15.3[wayland?,X?]
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

	# All password processing packages
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

src_install() {
	docinto "licenses"
	dodoc "LICENSE"
	meson_src_install
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
