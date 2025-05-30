# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 22.04
# Some versions are from CI

# TODO package:
# sphinx_reredirects
# sphinx-favicon
# sphinx-toolbox

# The dev-python/mujoco is for python bindings
# The sci-physics/mujoco is for native bindings

# For commits, see
# https://github.com/google-deepmind/mujoco/blob/3.1.5/cmake/MujocoDependencies.cmake
# https://github.com/google-deepmind/mujoco/blob/3.1.5/python/mujoco/CMakeLists.txt#L194
# https://github.com/google-deepmind/mujoco/blob/3.1.5/sample/cmake/SampleDependencies.cmake#L33

DISTUTILS_USE_PEP517="standalone"
EGIT_ABSEIL_CPP_COMMIT="d7aaad83b488fd62bd51c81ecf16cd938532cc0a"
EGIT_BENCHMARK_COMMIT="e45585a4b8e75c28479fa4107182c28172799640"
EGIT_CCD_COMMIT="7931e764a19ef6b21b443376c699bbc9c6d4fba8"
EGIT_CEREALLIB_COMMIT="ebef1e929807629befafbb2918ea1a08c7194554"
EGIT_EIGEN3_COMMIT="2a9055b50ed22101da7d77e999b90ed50956fe0b"
EGIT_GLFW_COMMIT="7482de6071d21db77a7236155da44c172a7f6c9e"
EGIT_GLMLIB_COMMIT="89e52e327d7a3ae61eb402850ba36ac4dd111987"
EGIT_GOOGLETEST_COMMIT="f8d7d77c06936315286eb55f8de22cd23c188571"
EGIT_LODEPNG_COMMIT="b4ed2cd7ecf61d29076169b49199371456d4f90b"
EGIT_MARCHINGCUBECPP_COMMIT="f03a1b3ec29b1d7d865691ca8aea4f1eb2c2873d"
EGIT_MUJOCO_COMMIT="e001975f083e769898811763c4c887afb52523c2"
EGIT_PYBIND11_COMMIT="3e9dfa2866941655c56877882565e7577de6fc7b"
EGIT_QHULL_COMMIT="0c8fc90d2037588024d9964515c1e684f6007ecc"
EGIT_SDFLIB_COMMIT="1927bee6bb8225258a39c8cbf14e18a4d50409ae"
EGIT_SPDLOGLIB_COMMIT="eb3220622e73a4889eee355ffa37972b3cac3df5"
EGIT_TINYOBJLOADER_COMMIT="1421a10d6ed9742f5b2c1766d22faa6cfbc56248"
EGIT_TINYXML2_COMMIT="9a89766acc42ddfa9e7133c7d81a5bda108a0ade"
PYTHON_COMPAT=( "python3_11" )
X86_CPU_FLAGS=(
	avx
)

inherit cmake python-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/deepmind/mujoco/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz

https://github.com/abseil/abseil-cpp/archive/${EGIT_ABSEIL_CPP_COMMIT}.tar.gz
	-> abseil-cpp-${EGIT_ABSEIL_CPP_COMMIT}.tar.gz
https://github.com/danfis/libccd/archive/${EGIT_CCD_COMMIT}.tar.gz
	-> libccd-${EGIT_CCD_COMMIT}.tar.gz
https://github.com/deepmind/mujoco/archive/${EGIT_MUJOCO_COMMIT}.tar.gz
	-> mujoco-${EGIT_MUJOCO_COMMIT}.tar.gz
https://gitlab.com/libeigen/eigen/-/archive/${EGIT_EIGEN3_COMMIT}/eigen-${EGIT_EIGEN3_COMMIT}.tar.gz
	-> eigen-${EGIT_EIGEN3_COMMIT}.tar.gz
https://github.com/glfw/glfw/archive/${EGIT_GLFW_COMMIT}.tar.gz
	-> glfw-${EGIT_GLFW_COMMIT}.tar.gz
https://github.com/google/benchmark/archive/${EGIT_BENCHMARK_COMMIT}.tar.gz
	-> benchmark-${EGIT_BENCHMARK_COMMIT}.tar.gz
https://github.com/google/googletest/archive/${EGIT_GOOGLETEST_COMMIT}.tar.gz
	-> googletest-${EGIT_GOOGLETEST_COMMIT}.tar.gz
https://github.com/leethomason/tinyxml2/archive/${EGIT_TINYXML2_COMMIT}.tar.gz
	-> tinyxml2-${EGIT_TINYXML2_COMMIT}.tar.gz
https://github.com/lvandeve/lodepng/archive/${EGIT_LODEPNG_COMMIT}.tar.gz
	-> lodepng-${EGIT_LODEPNG_COMMIT}.tar.gz
https://github.com/pybind/pybind11/archive/${EGIT_PYBIND11_COMMIT}.tar.gz
	-> pybind11-${EGIT_PYBIND11_COMMIT}.tar.gz
https://github.com/qhull/qhull/archive/${EGIT_QHULL_COMMIT}.tar.gz
	-> qhull-${EGIT_QHULL_COMMIT}.tar.gz
https://github.com/tinyobjloader/tinyobjloader/archive/${EGIT_TINYOBJLOADER_COMMIT}.tar.gz
	-> tinyobjloader-${EGIT_TINYOBJLOADER_COMMIT}.tar.gz
https://github.com/aparis69/MarchingCubeCpp/archive/${EGIT_MARCHINGCUBECPP_COMMIT}.tar.gz
	-> marchingcubecpp-${EGIT_MARCHINGCUBECPP_COMMIT}.tar.gz
https://github.com/UPC-ViRVIG/SdfLib/archive/${EGIT_SDFLIB_COMMIT}.tar.gz
	-> sdflib-${EGIT_SDFLIB_COMMIT}.tar.gz
https://github.com/g-truc/glm/archive/${EGIT_GLMLIB_COMMIT}.tar.gz
	-> glm_lib-${EGIT_GLMLIB_COMMIT}.tar.gz
https://github.com/gabime/spdlog/archive/${EGIT_SPDLOGLIB_COMMIT}.tar.gz
	-> spdlog_lib-${EGIT_SPDLOGLIB_COMMIT}.tar.gz
https://github.com/USCiLab/cereal/archive/${EGIT_CEREALLIB_COMMIT}.tar.gz
	-> cereal_lib-${EGIT_CEREALLIB_COMMIT}.tar.gz
"

DESCRIPTION="MuJoCo (Multi-Joint dynamics with Contact) is a general purpose \
physics simulator."
HOMEPAGE="
https://mujoco.org/
https://github.com/deepmind/mujoco
"

LICENSE_THIRD_PARTY="
	(
		Apache-2.0
		BSD
	)
	(
		(
			MPL-2.0
			|| (
				LGPL-3+
				GPL-2+
			)
		)
		Apache-2.0
		BSD
		GPL-2
		LGPL-2.1
		minpack
		MPL-2.0
		|| (
			LGPL-2.1
			LGPL-2.1+
		)
	)
	(
		BSD
		LGPL-3
		GPL-3
	)
	Apache-2.0
	BSD
	Qhull
	MIT
	ZLIB
"
LICENSE="
	${LICENSE_THIRD_PARTY}
	Apache-2.0
	doc? (
		CC-BY-4.0
	)
"
# Apache-2.0 - abseil-cpp
# Apache-2.0 BSD - benchmark
# Apache-2.0, BSD, ^^ ( LGPL-2.1 LGPL-2.1+ ), minpack, MPL-2.0, GPL-2, LGPL-2.1, ( MPL-2.0 || ( LGPL-3+ GPL-2+ )) - eigen
# BSD - googletest
# BSD - pybind11
# BSD, LGPL-3, GPL-3 - libccd
# custom, Qhull - Qhull
# MIT - tinyobjloader
# ZLIB - lodepng
# ZLIB - GLFW
# ZLIB - tinyxml2
RESTRICT="mirror test"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${X86_CPU_FLAGS[@]/#/cpu_flags_x86_}
+asm doc +examples hardened python +simulate +test
"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
"
RDEPEND+="
	${PYTHON_DEPS}
	>=dev-python/absl-py-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.25.1[${PYTHON_USEDEP}]
	>=dev-python/pyopengl-3.1.7[${PYTHON_USEDEP}]
	dev-python/pyglfw[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-build/cmake-3.16
	doc? (
		>=dev-python/furo-2022.9.29[${PYTHON_USEDEP}]
		>=dev-python/jinja2-2.11.3[${PYTHON_USEDEP}]
		>=dev-python/jq-1.4.1[${PYTHON_USEDEP}]
		>=dev-python/markupsafe-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/nbsphinx-0.9.1[${PYTHON_USEDEP}]
		>=dev-python/pandoc-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/pygments-2.15.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-4.5.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-reredirects-0.0.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-copybutton-0.5.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-favicon-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-toolbox-3.4.0[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-katex-0.9.4[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-youtube-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/wheel-0.40.0[${PYTHON_USEDEP}]
	)
"
PDEPEND+="
	python? (
		>=dev-python/mujoco-${PV}:${SLOT}
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-3.1.5-use-local-tarballs.patch"
)

#distutils_enable_sphinx "doc"

pkg_setup() {
	python_setup
}

src_unpack() {
	unpack ${P}.tar.gz
}

src_configure() {
	local mycmakeargs=(
		-DMUJOCO_BUILD_EXAMPLES=$(usex examples "ON" "OFF")
		-DMUJOCO_BUILD_SIMULATE=$(usex simulate "ON" "OFF")
		-DMUJOCO_BUILD_TESTS=$(usex test "ON" "OFF")
		-DMUJOCO_ENABLE_AVX=$(usex cpu_flags_x86_avx "ON" "OFF")
		-DMUJOCO_ENABLE_AVX_INTRINSICS=$(usex asm $(usex cpu_flags_x86_avx "ON" "OFF") "OFF")
		-DMUJOCO_TEST_PYTHON_UTIL=$(usex test "ON" "OFF")
	)

	if use examples || use simulate ; then
		mycmakeargs+=(
			-DMUJOCO_ENABLE_RPATH="OFF"
		)
	fi

	if tc-is-clang ; then
		mycmakeargs+=(
			-DMUJOCO_HARDEN:BOOL=$(usex hardened "ON" "OFF")
		)
	else
		mycmakeargs+=(
			-DMUJOCO_HARDEN:BOOL="OFF"
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install
	exeinto "/usr/$(get_libdir)/mujoco_plugin"
	doexe "${BUILD_DIR}/$(get_libdir)/libelasticity.so"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
