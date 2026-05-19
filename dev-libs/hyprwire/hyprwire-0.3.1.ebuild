# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

CXX_STANDARD=23

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX23[@]}
)
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)"

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX23[@]/llvm_slot_}
)
LIBCXX_USEDEP_LTS="llvm_slot_skip(+)"

inherit cmake libcxx-slot libstdcxx-slot

if [[ "${PV}" =~ "9999" ]]; then
	EGIT_REPO_URI="https://github.com/hyprwm/${PN^}.git"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="https://github.com/hyprwm/${PN^}/archive/refs/tags/v${PV}/v${PV}.tar.gz -> ${P}.gh.tar.gz"
fi

DESCRIPTION="A fast and consistent wire protocol for IPC"
HOMEPAGE="https://github.com/hyprwm/hyprwire"
LICENSE="BSD"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE="test"
RDEPEND="
	>=gui-libs/hyprutils-0.11.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	gui-libs/hyprutils:=
	>=dev-libs/libffi-3.5.2
	x11-libs/pixman
	>=dev-libs/pugixml-1.15[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
	dev-libs/pugixml:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.19
	dev-cpp/gtest[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
	dev-cpp/gtest:=
	virtual/pkgconfig
"
DOCS=( "README.md" )

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
