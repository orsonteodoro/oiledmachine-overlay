# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHKL_TIMESTAMPS=(
	"dev-libs/expat-9999"
)

if [[ ${PV} = *9999* ]]; then
	# Same as wayland ebuild
	FALLBACK_COMMIT="5a819837646842aa74cb0a1b3c74d2fe14694ac6"
	EGIT_REPO_URI="https://gitlab.freedesktop.org/wayland/wayland.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/wayland/wayland/-/releases/${PV}/downloads/wayland-${PV}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
	S="${WORKDIR}/wayland-${PV}"
fi
inherit chkl meson secure-version

DESCRIPTION="wayland-scanner tool"
HOMEPAGE="https://wayland.freedesktop.org/ https://gitlab.freedesktop.org/wayland/wayland"

LICENSE="MIT"
SLOT="0"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	!<dev-libs/wayland-${PV}
	>=dev-libs/expat-${EXPAT_PV}
"
DEPEND="${RDEPEND}"

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

src_configure() {
	chkl_check_many_timestamps
	local emesonargs=(
		-Ddocumentation=false
		-Ddtd_validation=false
		-Dlibraries=false
		-Dscanner=true
		-Dtests=false
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	mv "${ED}"/usr/$(get_libdir)/pkgconfig "${ED}"/usr/share/pkgconfig
}
