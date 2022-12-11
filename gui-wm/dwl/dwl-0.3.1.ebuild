# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic savedconfig toolchain-funcs desktop

DESCRIPTION="dwm for Wayland"
HOMEPAGE="https://github.com/djpohly/dwl"
SRC_URI="https://github.com/djpohly/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC0-1.0 GPL-3 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="somebar X"

RDEPEND="
	dev-libs/libinput
	dev-libs/wayland
	gui-libs/wlroots:0/15[X(-)?]
	x11-libs/libxkbcommon
	X? ( x11-libs/libxcb )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/wayland-protocols
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_prepare() {
	default
	use somebar && eapply "${FILESDIR}/${PN}-0.3.1-wayland-ipc.patch"

	restore_config config.h
}

src_configure() {
	export PKG_CONFIG="$(tc-getPKG_CONFIG)"
	use X && append-cppflags -DXWAYLAND
	tc-export CC
}

src_install() {
	emake PREFIX="${ED}/usr" install

	domenu "${FILESDIR}"/dwl.desktop

	einstalldocs

	save_config config.h
}
