# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="Universal-NCNN-upscaler-python"
MY_PV="${PV//./-}"
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="pdm-backend"
PYTHON_COMPAT=( "python3_"{10..13} )

GLSLANG_COMMIT="86ff4bca1ddc7e2262f119c16e7228d0efb67610"
NCNN_COMMIT="b4ba207c18d3103d6df890c0e3a97b469b196b26"
PYBIND11_COMMIT_1="8b48ff878c168b51fe5ef7b8c728815b9e1a9857"
PYBIND11_COMMIT_2="70a58c577eaf067748c2ec31bfd0b0a614cffba6"

inherit dep-prepare distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/TNTwise/Universal-NCNN-upscaler-python.git"
	FALLBACK_COMMIT="7e88aba5717509020dece7d280e5d64318f5b732" # 2024-10-09
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
	SRC_URI="
https://github.com/TNTwise/Universal-NCNN-upscaler-python/archive/refs/tags/${MY_PV}.tar.gz
	-> ${P}.tar.gz

https://github.com/Tencent/ncnn/archive/${NCNN_COMMIT}.tar.gz
	-> ncnn-${NCNN_COMMIT:0:7}.tar.gz
https://github.com/KhronosGroup/glslang/archive/${GLSLANG_COMMIT}.tar.gz
	-> glslang-${GLSLANG_COMMIT:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_1}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_1:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_2}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_2:0:7}.tar.gz
	"
fi

DESCRIPTION="Python bindings for upscaling using neural networks and Vulkan"
HOMEPAGE="
	https://github.com/TNTwise/Universal-NCNN-upscaler-python
"
LICENSE="
	(
		Apache-2.0
		BSD
		BSD-2
		custom
		GPL-3
		MIT
	)
	(
		BSD
		BSD-2
		ZLIB
	)
	BSD
	GPL-3
"
# Apache-2 BSD BSD-2 custom GPL-3 MIT - glslang
# BSD - pybind11
# BSD BSD-2 ZLIB - ncnn
RESTRICT="mirror test"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
dev test
ebuild_revision_1
"
RDEPEND+="
	$(python_gen_cond_dep '
		virtual/pillow[${PYTHON_USEDEP}]
	')
	media-libs/opencv[${PYTHON_SINGLE_USEDEP},python]
	media-libs/vulkan-drivers
	media-libs/vulkan-loader
"
DEPEND+="
	${RDEPEND}
	dev-util/vulkan-headers
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev? (
			dev-python/mypy[${PYTHON_USEDEP}]
			dev-util/ruff
		)
		test? (
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-cov[${PYTHON_USEDEP}]
			dev-python/scikit-image[${PYTHON_USEDEP}]
		)
	')
	dev? (
		dev-vcs/pre-commit[${PYTHON_SINGLE_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT_1}" "${S}/src/pybind11"
		dep_prepare_mv "${WORKDIR}/ncnn-${NCNN_COMMIT}" "${S}/src/upscale-ncnn-vulkan/src/ncnn"
		dep_prepare_mv "${WORKDIR}/glslang-${GLSLANG_COMMIT}" "${S}/src/upscale-ncnn-vulkan/src/ncnn/glslang"
		dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT_2}" "${S}/src/upscale-ncnn-vulkan/src/ncnn/python/pybind11"
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
