# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO:
# Fix/test examples USE flag.  See CI settings:  https://github.com/deepmind/mujoco/blob/2.3.3/.github/workflows/build.yml
# Fix/test simulate USE flag.  See CI settings.
# Update LICENSE variable for vendored third party libs

EAPI=8

DISTUTILS_USE_PEP517="standalone"
PYTHON_COMPAT=( python3_{8..11} )
inherit cmake python-r1

DESCRIPTION="Multi-Joint dynamics with Contact. A general purpose physics \
simulator."
HOMEPAGE="
https://mujoco.org/
https://github.com/deepmind/mujoco
"
LICENSE="
	Apache-2.0
	doc? (
		CC-BY-4.0
	)
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc +examples hardened python +simulate +test"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
"
DEPEND+="
	${PYTHON_DEPS}
	dev-python/absl-py[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pyglfw[${PYTHON_USEDEP}]
	dev-python/pyopengl[${PYTHON_USEDEP}]
"
RDEPEND+="
	${DEPEND}
"
# TODO: package:
# sphinx_reredirects
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-util/cmake-3.16
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_reredirects[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
"
PDEPEND+="
	python? (
		dev-python/mujoco[${PYTHON_USEDEP}]
	)
"

EGIT_ABSEIL_CPP_COMMIT="c8a2f92586fe9b4e1aff049108f5db8064924d8e"
EGIT_BENCHMARK_COMMIT="d572f4777349d43653b21d6c2fc63020ab326db2"
EGIT_CCD_COMMIT="7931e764a19ef6b21b443376c699bbc9c6d4fba8"
EGIT_EIGEN3_COMMIT="3460f3558e7b469efb8a225894e21929c8c77629"
EGIT_GLFW_COMMIT="7482de6071d21db77a7236155da44c172a7f6c9e"
EGIT_GOOGLETEST_COMMIT="b796f7d44681514f58a683a3a71ff17c94edb0c1"
EGIT_LODEPNG_COMMIT="b4ed2cd7ecf61d29076169b49199371456d4f90b"
EGIT_MUJOCO_COMMIT="95a07e85ccaf31a7daabfb2f34f376e75534881d"
EGIT_PYBIND11_COMMIT="0bd8896a4010f2d91b2340570c24fa08606ec406"
EGIT_QHULL_COMMIT="0c8fc90d2037588024d9964515c1e684f6007ecc"
EGIT_TINYOBJLOADER_COMMIT="1421a10d6ed9742f5b2c1766d22faa6cfbc56248"
EGIT_TINYXML2_COMMIT="9a89766acc42ddfa9e7133c7d81a5bda108a0ade"

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
"
S="${WORKDIR}/${P}"
RESTRICT="mirror test"
PATCHES=(
	"${FILESDIR}/${PN}-2.3.3-use-local-tarballs.patch"
)

#distutils_enable_sphinx "doc"

pkg_setup() {
	python_setup
}

src_configure() {
	local mycmakeargs=(
		-DMUJOCO_BUILD_EXAMPLES=$(usex examples "ON" "OFF")
		-DMUJOCO_BUILD_SIMULATE=$(usex simulate "ON" "OFF")
		-DMUJOCO_BUILD_TESTS=$(usex test "ON" "OFF")
		-DMUJOCO_TEST_PYTHON_UTIL=$(usex test "ON" "OFF")
	)

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
	exeinto /usr/$(get_libdir)/mujoco_plugin
	doexe "${BUILD_DIR}"/$(get_libdir)/libelasticity.so
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
