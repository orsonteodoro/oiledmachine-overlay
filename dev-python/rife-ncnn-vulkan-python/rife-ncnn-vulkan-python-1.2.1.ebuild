# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
GLSLANG_COMMIT="86ff4bca1ddc7e2262f119c16e7228d0efb67610"
LIBWEBP_COMMIT="5abb55823bb6196a918dd87202b2f32bbaff4c18"
NCNN_COMMIT="b4ba207c18d3103d6df890c0e3a97b469b196b26"
RIFE_NCNN_VULKAN_COMMIT_1="c806e66490679aebc1b4a6832985e004fd552f46" # Mar 3, 2022
RIFE_NCNN_VULKAN_COMMIT_2="a7532fc3f9f8f008cd6eecd6f2ffe2a9698e0cf7" # Oct 23, 2022
PYBIND11_COMMIT="70a58c577eaf067748c2ec31bfd0b0a614cffba6"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit dep-prepare distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/media2x/rife-ncnn-vulkan-python.git"
	FALLBACK_COMMIT="577234096d2a337897fea0d0d39a0864d2665d5e" # Oct 29, 2022
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
#https://github.com/nihui/rife-ncnn-vulkan/archive/${RIFE_NCNN_VULKAN_COMMIT_1}.tar.gz
#	-> rife-ncnn-vulkan-${RIFE_NCNN_VULKAN_COMMIT_1:0:7}.tar.gz
	SRC_URI="
https://github.com/media2x/rife-ncnn-vulkan-python/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/nihui/rife-ncnn-vulkan/archive/${RIFE_NCNN_VULKAN_COMMIT_2}.tar.gz
	-> rife-ncnn-vulkan-${RIFE_NCNN_VULKAN_COMMIT_2:0:7}.tar.gz
https://github.com/webmproject/libwebp/archive/${LIBWEBP_COMMIT}.tar.gz
	-> libwebp-${LIBWEBP_COMMIT:0:7}.tar.gz
https://github.com/Tencent/ncnn/archive/${NCNN_COMMIT}.tar.gz
	-> ncnn-${NCNN_COMMIT:0:7}.tar.gz
https://github.com/KhronosGroup/glslang/archive/${GLSLANG_COMMIT}.tar.gz
	-> glslang-${GLSLANG_COMMIT:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT}.tar.gz
	-> pybind11-${PYBIND11_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="A Python FFI of nihui/rife-ncnn-vulkan achieved with SWIG"
HOMEPAGE="
	https://github.com/media2x/rife-ncnn-vulkan-python
	https://pypi.org/project/rife-ncnn-vulkan-python
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" ebuild-revision-1"
RDEPEND+="
	virtual/pillow[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.9
	>=dev-python/setuptools-40.8.0[${PYTHON_USEDEP}]
	dev-python/cmake-build-extension[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"
DOCS=( "README.md" )
PATCHES=(
)

gen_git_tag() {
	local path="${1}"
	local tag_name="${2}"
einfo "Generating tag start for ${path}"
	pushd "${path}" >/dev/null 2>&1 || die
		git init || die
		git config user.email "name@example.com" || die
		git config user.name "John Doe" || die
		touch dummy || die
		git add dummy || die
		#git add -f * || die
		git commit -m "Dummy" || die
		git tag ${tag_name} || die
	popd >/dev/null 2>&1 || die
einfo "Generating tag done"
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		#dep_prepare_mv "${WORKDIR}/rife-ncnn-vulkan-${RIFE_NCNN_VULKAN_COMMIT_1}/models" "${S}/rife_ncnn_vulkan_python/rife-ncnn-vulkan"
		dep_prepare_mv "${WORKDIR}/rife-ncnn-vulkan-${RIFE_NCNN_VULKAN_COMMIT_2}" "${S}/rife_ncnn_vulkan_python/rife-ncnn-vulkan"
		dep_prepare_mv "${WORKDIR}/ncnn-${NCNN_COMMIT}" "${S}/rife_ncnn_vulkan_python/rife-ncnn-vulkan/src/ncnn"
		dep_prepare_mv "${WORKDIR}/glslang-${GLSLANG_COMMIT}" "${S}/rife_ncnn_vulkan_python/rife-ncnn-vulkan/src/ncnn/glslang"
		dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT}" "${S}/rife_ncnn_vulkan_python/rife-ncnn-vulkan/src/ncnn/python/pybind11"
		dep_prepare_mv "${WORKDIR}/libwebp-${LIBWEBP_COMMIT}" "${S}/rife_ncnn_vulkan_python/rife-ncnn-vulkan/src/libwebp"

		gen_git_tag "${S}/rife_ncnn_vulkan_python" "v${PV}"
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
