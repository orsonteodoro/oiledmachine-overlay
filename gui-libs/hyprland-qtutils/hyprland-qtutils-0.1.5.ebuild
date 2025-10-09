# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libstdcxx-compat
GCC_COMPAT=(
	# Support -std=c++23, required for #include <print> support >= GCC 14
	${LIBSTDCXX_COMPAT_STDCXX23[@]}
)
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)"

inherit cmake libstdcxx-slot

KEYWORDS="amd64"
SRC_URI="https://github.com/hyprwm/${PN}/archive/refs/tags/v${PV}/v${PV}.tar.gz -> ${P}.gh.tar.gz"

DESCRIPTION="Hyprland QT/qml utility apps"
HOMEPAGE="https://github.com/hyprwm/hyprland-qtutils"
LICENSE="BSD"
SLOT="0"
RDEPEND="
	dev-qt/qtbase:6[${LIBSTDCXX_USEDEP_LTS}]
	dev-qt/qtbase:=
	dev-qt/qtdeclarative:6[${LIBSTDCXX_USEDEP_LTS}]
	dev-qt/qtdeclarative:=
	dev-qt/qtwayland:6[${LIBSTDCXX_USEDEP_LTS}]
	dev-qt/qtwayland:=
	gui-libs/hyprutils[${LIBSTDCXX_USEDEP}]
	gui-libs/hyprutils:=
	gui-libs/hyprland-qt-support[${LIBSTDCXX_USEDEP}]
	gui-libs/hyprland-qt-support:=
	kde-frameworks/qqc2-desktop-style:6
	sys-apps/pciutils
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
