# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=26

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX26[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX26[@]/llvm_slot_}
)

inherit cflags-hardened cmake libcxx-slot libstdcxx-slot
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)"

DESCRIPTION="Hyprland graphics / resource utilities"
HOMEPAGE="https://github.com/hyprwm/hyprgraphics"
SRC_URI="https://github.com/hyprwm/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE+="
ebuild_revision_1
"
RDEPEND="
	>=gnome-base/librsvg-2.61.4
	>=gui-libs/hyprutils-0.1.1[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	gui-libs/hyprutils:=
	>=x11-libs/libdrm-2.4.131
	>=x11-libs/pango-1.57.1
	>=media-libs/libglvnd-1.7.0
	media-libs/libheif[${LIBSTDCXX_USEDEP_LTS}]
	media-libs/libheif:=
	>=media-libs/libjpeg-turbo-3.1.4.1
	media-libs/libjpeg-turbo:=
	>=media-libs/libjxl-0.11.2[${LIBSTDCXX_USEDEP_LTS}]
	media-libs/libjxl:=
	media-libs/libspng
	>=media-libs/libwebp-1.6.0
	media-libs/libwebp:=
	>=sys-apps/file-5.47
	>=x11-libs/cairo-1.18.4
	>=x11-libs/pixman-0.46.4
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-4.3.1
	virtual/pkgconfig
"

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	cflags-hardened_append
	cmake_src_configure
}
