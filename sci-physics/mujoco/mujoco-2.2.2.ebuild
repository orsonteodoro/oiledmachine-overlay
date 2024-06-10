# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 22.04

# TODO: package:
# dev-python/pandoc
# sphinxcontrib-katex
# sphinxcontrib-youtube
# sphinx-reredirects

# The dev-python/mujoco is for python bindings
# The sci-physics/mujoco is for native bindings

# For commits, see
# https://github.com/google-deepmind/mujoco/blob/2.2.2/cmake/MujocoDependencies.cmake
# https://github.com/google-deepmind/mujoco/blob/2.2.2/python/mujoco/CMakeLists.txt#L194
# https://github.com/google-deepmind/mujoco/blob/2.2.2/sample/cmake/SampleDependencies.cmake#L33

DISTUTILS_USE_PEP517="standalone"
EGIT_ABSEIL_CPP_COMMIT="8c0b94e793a66495e0b1f34a5eb26bd7dc672db0"
EGIT_BENCHMARK_COMMIT="d845b7b3a27d54ad96280a29d61fa8988d4fddcf"
EGIT_CCD_COMMIT="7931e764a19ef6b21b443376c699bbc9c6d4fba8"
EGIT_EIGEN_COMMIT="34780d8bd13d0af0cf17a22789ef286e8512594d"  # cmake/MujocoDependencies.cmake
EGIT_EIGEN_PY_COMMIT="b02c384ef4e8eba7b8bdef16f9dc6f8f4d6a6b2b" # python/mujoco/CMakeLists.txt
EGIT_GLFW_COMMIT="7d5a16ce714f0b5f4efa3262de22e4d948851525"
EGIT_GOOGLETEST_COMMIT="58d77fa8070e8cec2dc1ed015d66b454c8d78850"
EGIT_LODEPNG_COMMIT="b4ed2cd7ecf61d29076169b49199371456d4f90b"
EGIT_MUJOCO_COMMIT="9b694103e66a60ba602630cba528c50058328117"
EGIT_PYBIND11_COMMIT="6df86934c258d8cd99acf192f6d3f4d1289b5d68"
EGIT_QHULL_COMMIT="3df027b91202cf179f3fba3c46eebe65bbac3790"
EGIT_TINYOBJLOADER_COMMIT="1421a10d6ed9742f5b2c1766d22faa6cfbc56248"
EGIT_TINYXML2_COMMIT="1dee28e51f9175a31955b9791c74c430fe13dc82"
PYTHON_COMPAT=( "python3_10" )
X86_CPU_FLAGS=(
	avx
)

inherit cmake python-r1

KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
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
https://gitlab.com/libeigen/eigen/-/archive/${EGIT_EIGEN_COMMIT}/eigen-${EGIT_EIGEN_COMMIT}.tar.gz
	-> eigen-${EGIT_EIGEN_COMMIT}.tar.gz
https://gitlab.com/libeigen/eigen/-/archive/${EGIT_EIGEN_PY_COMMIT}/eigen-${EGIT_EIGEN_PY_COMMIT}.tar.gz
	-> eigen-${EGIT_EIGEN_PY_COMMIT}.tar.gz
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
"

DESCRIPTION="Multi-Joint dynamics with Contact. A general purpose physics \
simulator."
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
	>=dev-python/numpy-1.21.5[${PYTHON_USEDEP}]
	dev-python/absl-py[${PYTHON_USEDEP}]
	dev-python/pyglfw[${PYTHON_USEDEP}]
	dev-python/pyopengl[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-build/cmake-3.15
	doc? (
		>=dev-python/jinja-2.11.3[${PYTHON_USEDEP}]
		>=dev-python/jq-1.2.2[${PYTHON_USEDEP}]
		>=dev-python/markupsafe-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/nbsphinx-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/pandoc-1.0.2[${PYTHON_USEDEP}]
		>=dev-python/pygments-2.7.4[${PYTHON_USEDEP}]
		>=dev-python/sphinx-4.5.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-reredirects-0.0.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx_rtd_theme-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-katex-0.8.6[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-youtube-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/wheel-0.37.1[${PYTHON_USEDEP}]
	)
"
PDEPEND+="
	python? (
		>=dev-python/mujoco-${PV}:${SLOT}
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-2.2.2-use-local-tarballs.patch"
)

#distutils_enable_sphinx "doc"

pkg_setup() {
	python_setup
}

src_unpack() {
	unpack ${P}.tar.gz
}

src_configure() {
einfo "DISTDIR:  ${DISTDIR}"
	export _DISTDIR="${DISTDIR}"
	local mycmakeargs=(
		-DMUJOCO_BUILD_EXAMPLES=$(usex examples "ON" "OFF")
		-DMUJOCO_BUILD_SIMULATE=$(usex simulate "ON" "OFF")
		-DMUJOCO_BUILD_TESTS=$(usex test "ON" "OFF")
		-DMUJOCO_ENABLE_AVX=$(usex cpu_flags_x86_avx "ON" "OFF")
		-DMUJOCO_ENABLE_AVX_INTRINSICS=$(usex asm $(usex cpu_flags_x86_avx ON OFF) OFF)
		-DMUJOCO_TEST_PYTHON_UTIL=$(usex test "ON" "OFF")
	)

	if use examples || use simulate ; then
		mycmakeargs+=(
			-DMUJOCO_ENABLE_RPATH=OFF
		)
	fi

	if tc-is-clang ; then
		mycmakeargs+=(
			-DMUJOCO_HARDEN:BOOL=$(usex hardened "ON" "OFF")
		)
	else
		mycmakeargs+=(
			-DMUJOCO_HARDEN:BOOL=OFF
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
