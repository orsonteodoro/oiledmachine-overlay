# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO:
# Fix/test examples USE flag.  See CI settings:  https://github.com/deepmind/mujoco/blob/2.3.2/.github/workflows/build.yml
# Fix/test simulate USE flag.  See CI settings.
# Update LICENSE variable for vendored third party libs

EAPI=8

DISTUTILS_USE_SETUPTOOLS="bdepend"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

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
IUSE+=" doc +test r1"
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
	>=dev-util/cmake-3.15
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_reredirects[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
"

EGIT_ABSEIL_CPP_COMMIT="78f9680225b9792c26dfdd99d0bd26c96de53dd4"
EGIT_BENCHMARK_COMMIT="0d98dba29d66e93259db7daa53a9327df767a415"
EGIT_CCD_COMMIT="7931e764a19ef6b21b443376c699bbc9c6d4fba8"
EGIT_EIGEN_COMMIT="3147391d946bb4b6c68edd901f2add6ac1f31f8c"  # cmake/MujocoDependencies.cmake
EGIT_EIGEN_PY_COMMIT="b02c384ef4e8eba7b8bdef16f9dc6f8f4d6a6b2b" # python/mujoco/CMakeLists.txt
EGIT_GLFW_COMMIT="7482de6071d21db77a7236155da44c172a7f6c9e"
EGIT_GOOGLETEST_COMMIT="e2239ee6043f73722e7aa812a459f54a28552929"
EGIT_LODEPNG_COMMIT="48e5364ef48ec2408f44c727657ac1b6703185f8"
EGIT_MUJOCO_COMMIT="95a07e85ccaf31a7daabfb2f34f376e75534881d"
EGIT_PYBIND11_COMMIT="a8f1a5567608f346bdba293b3d062a288ee16cd4"
EGIT_QHULL_COMMIT="3df027b91202cf179f3fba3c46eebe65bbac3790"
EGIT_TINYOBJLOADER_COMMIT="1421a10d6ed9742f5b2c1766d22faa6cfbc56248"
EGIT_TINYXML2_COMMIT="1dee28e51f9175a31955b9791c74c430fe13dc82"

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
S_PROJ="${WORKDIR}/${P}"
S="${WORKDIR}/${P}"
RESTRICT="mirror test"

#distutils_enable_sphinx "doc"

src_prepare() {
	eapply "${FILESDIR}/${PN}-2.2.0-use-local-tarballs.patch"
	eapply "${FILESDIR}/${PN}-2.3.2-mkdir-dist.patch"
	cp -a "${S}/cmake" "${S}/python" || die
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
	local path
	for path in $(find "${ED}" -type f) ; do
		local is_exe=0
		if file "${path}" | grep -q -e "Python script" ; then
			is_exe=1
		elif file "${path}" | grep -q -E -e "ELF (32|64)-bit LSB shared object" ; then
			is_exe=1
		fi
		fperms 0755 $(echo "${path}" | sed -e "s|^${ED}||g")
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
