# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=23

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX23[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX23[@]/llvm_slot_}
)

inherit cmake libcxx-slot libstdcxx-slot

if [[ "${PV}" =~ "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hyprwm/${PN^}.git"
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/hyprwm/${PN^}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Hyprland GUI utilities, successor to hyprland-qtutils"
HOMEPAGE="https://github.com/hyprwm/hyprland-guiutils"
LICENSE="BSD"
SLOT="0/"$(ver_cut "1-2" "${PV}")
RDEPEND="
	!gui-libs/hyprland-qtutils
	gui-libs/aquamarine[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=gui-libs/hyprtoolkit-0.4.0
	>=gui-libs/hyprutils-0.2.4[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	gui-libs/hyprutils:=
	dev-libs/glib:2
	dev-libs/glib:=
	>=dev-libs/hyprlang-0.6.0
	dev-libs/hyprlang[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-libs/hyprlang:=
	dev-libs/hyprgraphics[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-libs/hyprgraphics:=
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/libxkbcommon
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
	libcxx-slot_verify
	libstdcxx-slot_verify
}
