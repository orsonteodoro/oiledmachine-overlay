# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libstdcxx-compat
GCC_COMPAT=(
	# Support -std=c++23, required for #include <print> support >= GCC 14
	${LIBSTDCXX_COMPAT_STDCXX23[@]}
)

inherit cmake libstdcxx-slot

DESCRIPTION="QML style provider for hypr* Qt apps"
HOMEPAGE="https://github.com/hyprwm/hyprland-qt-support"
SRC_URI="https://github.com/hyprwm/${PN}/archive/refs/tags/v${PV}/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"

SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	dev-qt/qtbase:6[${LIBSTDCXX_USEDEP}]
	dev-qt/qtbase:=
	dev-qt/qtdeclarative:6[${LIBSTDCXX_USEDEP}]
	dev-qt/qtdeclarative:=
	>=dev-libs/hyprlang-0.6.0[${LIBSTDCXX_USEDEP}]
	dev-libs/hyprlang:=
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DINSTALL_QML_PREFIX="${EPFREIX}/$(get_libdir)/qt6/qml"
	)

	cmake_src_configure
}
