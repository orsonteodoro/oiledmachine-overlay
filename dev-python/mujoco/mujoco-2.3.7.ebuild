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

DISTUTILS_USE_PEP517="no"
EGIT_ABSEIL_CPP_COMMIT="c2435f8342c2d0ed8101cb43adfd605fdc52dca2"
EGIT_BENCHMARK_COMMIT="2dd015dfef425c866d9a43f2c67d8b52d709acb6"
EGIT_CCD_COMMIT="7931e764a19ef6b21b443376c699bbc9c6d4fba8"
EGIT_EIGEN3_COMMIT="211c5dfc6741a5570ad007983c113ef4d144f9f3"
EGIT_GLFW_COMMIT="7482de6071d21db77a7236155da44c172a7f6c9e"
EGIT_GOOGLETEST_COMMIT="b796f7d44681514f58a683a3a71ff17c94edb0c1"
EGIT_LODEPNG_COMMIT="b4ed2cd7ecf61d29076169b49199371456d4f90b"
EGIT_MUJOCO_COMMIT="c9246e1f5006379d599e0bcddf159a8616d31441"
EGIT_PYBIND11_COMMIT="8a099e44b3d5f85b20f05828d919d2332a8de841"
EGIT_QHULL_COMMIT="0c8fc90d2037588024d9964515c1e684f6007ecc"
EGIT_TINYOBJLOADER_COMMIT="1421a10d6ed9742f5b2c1766d22faa6cfbc56248"
EGIT_TINYXML2_COMMIT="9a89766acc42ddfa9e7133c7d81a5bda108a0ade"
PYTHON_COMPAT=( "python3_11" ) # Upstream only tests with 3.11 for this version.

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
S_PROJ="${WORKDIR}/${P}"
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

DESCRIPTION="Python bindings for MuJoCo (Multi-Joint dynamics with Contact), \
a general purpose physics simulator."
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
RESTRICT="
	mirror
	test
"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc +test ebuild_revision_1"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
"
RDEPEND+="
	${PYTHON_DEPS}
	>=dev-python/absl-py-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.25.1[${PYTHON_USEDEP}]
	>=dev-python/pyopengl-3.1.7[${PYTHON_USEDEP}]
	>=sci-physics/mujoco-${PV}:${SLOT}
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
		>=dev-python/sphinx-copybutton-0.5.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-favicon-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-reredirects-0.0.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-toolbox-3.4.0[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-katex-0.9.4[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-youtube-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/wheel-0.40.0[${PYTHON_USEDEP}]
	)
"
_PATCHES=(
	"${FILESDIR}/${PN}-2.3.7-use-local-tarballs.patch"
	"${FILESDIR}/${PN}-2.3.7-mkdir-dist.patch"
)

#distutils_enable_sphinx "doc"

src_unpack() {
	unpack ${P}.tar.gz
}

src_prepare() {
	eapply ${_PATCHES[@]}
	cp -a "${S}/simulate" "${S}/python/mujoco" || die
	S="${WORKDIR}/${P}/python"
	distutils-r1_src_prepare
}

python_configure() {
	export MUJOCO_PATH="${ESYSROOT}/usr"
	export MUJOCO_PLUGIN_PATH="${ESYSROOT}/usr/$(get_libdir)/mujuco_plugin"
	addpredict /proc/self/comm
	PYTHONPATH="${S_PROJ}:${PYTHONPATH}" \
	${EPYTHON} mujoco/codegen/generate_enum_traits.py \
		> mujoco/enum_traits.h \
		|| die
	PYTHONPATH="${S_PROJ}:${PYTHONPATH}" \
	${EPYTHON} mujoco/codegen/generate_function_traits.py \
		> mujoco/function_traits.h \
		|| die
}

python_compile() {
	${EPYTHON} setup.py build || die
}

fix_permissions() {
einfo "Fixing permissions"
	local path
	for path in $(find "${ED}" -type f -not -path "*/include/*") ; do
		[[ -L "${path}" ]] && continue
		local is_exe=0
		local out=$(file "${path}")
		if [[ "${out}" =~ "Python script" ]] ; then
			is_exe=1
		elif [[ "${out}" =~ "ELF "("32"|"64")"-bit LSB shared object" ]] ; then
			is_exe=1
		fi
		if (( ${is_exe} == 1 )) ; then
			local path=$(echo "${path}" | sed -e "s|^${ED}||g")
			fperms 0755 "${path}"
		fi
	done
}

src_install() {
	distutils-r1_src_install
	rm -rf "${ED}/usr/share/doc/mujoco-${PV}/README.md" || die
	install_impl() {
einfo "Installing for ${EPYTHON}"
		python_moduleinto ${PN}
		local arch=$(ls -1 "${S_PROJ}/python/build" \
			| head -n 1 \
			| cut -f 2 -d "-")
		local os_prefix=$(ls -1 "${S_PROJ}/python/build" \
			| head -n 1 \
			| cut -f 1 -d "-" \
			| cut -f 2 -d ".")
		local pyver=${EPYTHON/python}
		python_domodule "${S}/build/lib.${os_prefix}-${arch}-${pyver}/mujoco/"*
	}
	python_foreach_impl install_impl
	fix_permissions
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
