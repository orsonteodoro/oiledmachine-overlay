# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )

inherit cmake python-any-r1

SRC_URI="
https://github.com/Dobiasd/frugally-deep/archive/refs/tags/v${PV/_/-}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${PV/_/-}"

DESCRIPTION="Header-only library for using Keras (TensorFlow) models in C++."
HOMEPAGE="
https://github.com/Dobiasd/frugally-deep
"
LICENSE="MIT"
RESTRICT=""
SLOT="0/$(ver_cut 1-2 ${PV})"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="double-precision test"
# U 22.04
RDEPEND="
	>=dev-cpp/eigen-3.4.0
	>=dev-cpp/FunctionalPlus-0.2.22
	>=dev-cpp/nlohmann_json-3.10.5
"
BDEPEND="
	>=dev-util/cmake-3.22.1
	>=sys-devel/gcc-11.2.0
	test? (
		>=dev-cpp/doctest-2.4.11
	)
"
DOCS=( README.md )

pkg_setup() {
	use test && python_setup
}

src_configure() {
	local mycmakeargs=(
		-DFDEEP_BUILD_UNITTEST=$(usex test)
		-DFDEEP_USE_TOOLCHAIN=ON
		-DFDEEP_USE_DOUBLE=$(usex double-precision)
	)
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-META:  created-ebuild
