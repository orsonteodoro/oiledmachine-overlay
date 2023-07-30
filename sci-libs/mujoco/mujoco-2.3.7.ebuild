# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO:
# Fix/test examples USE flag.  See CI settings:  https://github.com/deepmind/mujoco/blob/2.3.3/.github/workflows/build.yml
# Fix/test simulate USE flag.  See CI settings.
# Update LICENSE variable for vendored third party libs

# The dev-python/mujoco is for python bindings
# The sci-libs/mujoco is for native bindings

EAPI=8

DISTUTILS_USE_PEP517="standalone"
PYTHON_COMPAT=( python3_11 )

inherit cmake python-r1

EGIT_ABSEIL_CPP_COMMIT="c2435f8342c2d0ed8101cb43adfd605fdc52dca2"
EGIT_BENCHMARK_COMMIT="d572f4777349d43653b21d6c2fc63020ab326db2"
EGIT_CCD_COMMIT="7931e764a19ef6b21b443376c699bbc9c6d4fba8"
EGIT_EIGEN3_COMMIT="211c5dfc6741a5570ad007983c113ef4d144f9f3"
EGIT_GLFW_COMMIT="7482de6071d21db77a7236155da44c172a7f6c9e"
EGIT_GOOGLETEST_COMMIT="b796f7d44681514f58a683a3a71ff17c94edb0c1"
EGIT_LODEPNG_COMMIT="b4ed2cd7ecf61d29076169b49199371456d4f90b"
EGIT_MUJOCO_COMMIT="95a07e85ccaf31a7daabfb2f34f376e75534881d"
EGIT_PYBIND11_COMMIT="8a099e44b3d5f85b20f05828d919d2332a8de841"
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
# U 22.04
# Some versions are from CI
DEPEND+="
	${PYTHON_DEPS}
	>=dev-python/absl-py-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.25.1[${PYTHON_USEDEP}]
	>=dev-python/pyopengl-3.1.7[${PYTHON_USEDEP}]
	dev-python/pyglfw[${PYTHON_USEDEP}]
"
RDEPEND+="
	${DEPEND}
"
# TODO: package:
# sphinx_reredirects
# sphinx-favicon
# sphinx-toolbox
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-util/cmake-3.16
	doc? (
		>=dev-python/furo-2022.9.29[${PYTHON_USEDEP}]
		>=dev-python/jinja-2.11.3[${PYTHON_USEDEP}]
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
S="${WORKDIR}/${P}"
RESTRICT="mirror test"
PATCHES=(
	"${FILESDIR}/${PN}-2.3.7-use-local-tarballs.patch"
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
	exeinto "/usr/$(get_libdir)/mujoco_plugin"
	doexe "${BUILD_DIR}/$(get_libdir)/libelasticity.so"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
