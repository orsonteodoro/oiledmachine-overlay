# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data"

CHKL_TIMESTAMPS=(
	"dev-libs/libffi-9999"
)

inherit cflags-hardened chkl secure-version meson-multilib

if [[ "${PV}" =~ "9999" ]]; then
	FALLBACK_COMMIT="165504a90edd7d6e51dd42d11f9dd0e8c9384609"
	EGIT_REPO_URI="https://gitlab.freedesktop.org/wayland/wayland.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/wayland/${PN}/-/releases/${PV}/downloads/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

DESCRIPTION="Wayland protocol libraries"
HOMEPAGE="https://wayland.freedesktop.org/ https://gitlab.freedesktop.org/wayland/wayland"

LICENSE="MIT doc? ( Apache-2.0 OFL-1.1 )"
SLOT="0"
IUSE+=" doc test selinux"
RESTRICT="!test? ( test )"

BDEPEND="
	~dev-util/wayland-scanner-${PV}
	virtual/pkgconfig
	doc? (
		app-text/doxygen
		app-text/mdbook
		app-text/xmlto
		media-gfx/graphviz
	)
"
DEPEND="
	>=dev-libs/libffi-${LIBFFI_PV}:=[${MULTILIB_USEDEP}]
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-wayland:* )
"

src_unpack() {
	if [[ "${PV}" =~ "9999" ]]; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	local emesonargs=(
		$(meson_native_use_bool doc documentation)
		$(meson_native_true dtd_validation)
		-Dlibraries=true
		-Dscanner=false
		$(meson_use test tests)
	)
	meson_src_configure
}

src_test() {
	# We set it on purpose to only a short subdir name, as socket paths are
	# created in there, which are 108 byte limited. With this it hopefully
	# barely fits to the limit with /var/tmp/portage/${CATEGORY}/${PF}/temp/x
	export XDG_RUNTIME_DIR="${T}"/x
	mkdir "${XDG_RUNTIME_DIR}" || die
	chmod 0700 "${XDG_RUNTIME_DIR}" || die

	multilib-minimal_src_test
}

src_install() {
	meson-multilib_src_install

	if use doc; then
		mv "${ED}"/usr/share/doc/{${PN}/Wayland,${PF}/html} || die
		rmdir "${ED}"/usr/share/doc/${PN} || die
	fi
}
