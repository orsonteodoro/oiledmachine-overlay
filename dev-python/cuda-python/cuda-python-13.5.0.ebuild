# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# cuda-core
# cuda-pathfinder
# cuda-bindings

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{11..15} )

CCCL_COMMIT="ba8eb88fb78254a07112e60d4e74cac84038fac8"

inherit cython dep-prepare secure-version distutils-r1

#KEYWORDS="~amd64" # Deps need to be packaged
SRC_URI="
https://github.com/NVIDIA/cuda-python/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/NVIDIA/cccl/archive/${CCCL_COMMIT}.tar.gz
	-> cccl-${CCCL_COMMIT:0:7}.tar.gz
"
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="Python bindings for CUDA"
HOMEPAGE="
https://github.com/NVIDIA/cuda-python
https://pypi.org/project/cuda-python
"
LICENSE="
	all-rights-reserved
	Apache-2.0
"
# The distro's Apache-2.0 license template doesn't contain all rights reserved.
RESTRICT="mirror"
SLOT="0"
IUSE+="
doc
ebuild_revision_1
"
RDEPEND+="
	>=dev-python/cuda-bindings-13.5.0[${PYTHON_USEDEP}]
	>=dev-python/cuda-core-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/cuda-pathfinder-1.1[${PYTHON_USEDEP}]
	virtual/cuda:=
	|| (
		=virtual/cuda-13*
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/cython-${CYTHON_PV}:${CYTHON_SLOT}=[${PYTHON_USEDEP}]
	>=dev-python/setuptools-80.0.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-8[${PYTHON_USEDEP}]
	!=dev-python/setuptools-scm-10.1*
	dev-python/wheel[${PYTHON_USEDEP}]
	virtual/numpy[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/cython-${CYTHON_PV}:${CYTHON_SLOT}=[${PYTHON_USEDEP}]
		dev-python/myst-parser[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/numpydoc[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/pydata-sphinx-theme[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		<dev-python/sphinx-8.2.0[${PYTHON_USEDEP}]
		dev-python/sphinx-copybutton[${PYTHON_USEDEP}]
		dev-python/myst-nb[${PYTHON_USEDEP}]
		dev-python/enum_tools[${PYTHON_USEDEP}]
		dev-python/sphinx-toolbox[${PYTHON_USEDEP}]
		dev-python/pyclibrary[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/nvidia-sphinx-theme[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	unpack ${A}
	dep_prepare_mv "${WORKDIR}/cccl-${CCCL_COMMIT}" "${S}/cuda_core/third_party/cccl"
}

python_configure() {
	cython_python_configure
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
