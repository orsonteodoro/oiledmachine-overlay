# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libstdcxx-compat

GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX26[@]}
)

inherit cmake libstdcxx-slot
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)"

DESCRIPTION="Hyprland graphics / resource utilities"
HOMEPAGE="https://github.com/hyprwm/hyprgraphics"
SRC_URI="https://github.com/hyprwm/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	gnome-base/librsvg
	>=gui-libs/hyprutils-0.1.1[${LIBSTDCXX_USEDEP}]
	gui-libs/hyprutils[${LIBSTDCXX_USEDEP}]
	gui-libs/hyprutils:=
	x11-libs/pango
	media-libs/libheif[${LIBSTDCXX_USEDEP_LTS}]
	media-libs/libheif:=
	media-libs/libjpeg-turbo:=
	media-libs/libjxl[${LIBSTDCXX_USEDEP_LTS}]
	media-libs/libjxl:=
	media-libs/libspng
	media-libs/libwebp:=
	sys-apps/file
	x11-libs/cairo
	x11-libs/pixman
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-build/cmake
	virtual/pkgconfig
"

pkg_setup() {
	libstdcxx-slot_verify
}
