# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 22.04

PYTHON_COMPAT=( "python3_10" ) # CI only tests with 3.10

inherit cmake python-any-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV/_/-}"
SRC_URI="
https://github.com/Dobiasd/frugally-deep/archive/refs/tags/v${PV/_/-}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Header-only library for using Keras (TensorFlow) models in C++."
HOMEPAGE="
https://github.com/Dobiasd/frugally-deep
"
LICENSE="MIT"
RESTRICT="test" # Not tested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE="double-precision test"
RDEPEND="
	>=dev-cpp/eigen-3.4.0
	>=dev-cpp/FunctionalPlus-0.2.23
	>=dev-cpp/nlohmann_json-3.11.3
"
BDEPEND="
	>=dev-build/cmake-3.22.1
	test? (
		>=dev-cpp/doctest-2.4.11
		>=sci-libs/tensorflow-2.15.0
	)
	|| (
		>=sys-devel/gcc-4.9
		>=sys-devel/clang-3.7
	)
"
DOCS=( "README.md" )

pkg_setup() {
	use test && python_setup
}

src_configure() {
	local mycmakeargs=(
		-DFDEEP_BUILD_UNITTEST=$(usex test)
		-DFDEEP_USE_DOUBLE=$(usex double-precision)
		-DFDEEP_USE_TOOLCHAIN=ON
	)
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-META:  created-ebuild
