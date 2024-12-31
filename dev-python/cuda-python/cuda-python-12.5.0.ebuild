# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1

KEYWORDS="~amd64"
SRC_URI="
https://github.com/NVIDIA/cuda-python/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="Python bindings for CUDA"
HOMEPAGE="
https://github.com/NVIDIA/cuda-python
https://pypi.org/project/cuda-python
"
LICENSE="
	NVIDIA-CUDA-Python
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
RDEPEND+="
	>=x11-drivers/nvidia-drivers-450.80.02
	|| (
		=dev-util/nvidia-cuda-toolkit-12.5*
		=dev-util/nvidia-cuda-toolkit-12.4*
		=dev-util/nvidia-cuda-toolkit-12.3*
		=dev-util/nvidia-cuda-toolkit-12.2*
		=dev-util/nvidia-cuda-toolkit-12.1*
		=dev-util/nvidia-cuda-toolkit-12.0*
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/cython-3.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.21.1[${PYTHON_USEDEP}]
	>=dev-python/pyclibrary-0.1.7[${PYTHON_USEDEP}]
	>=dev-python/versioneer-0.29[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-6.2.4[${PYTHON_USEDEP}]
		>=dev-python/pytest-benchmark-3.4.1[${PYTHON_USEDEP}]
	)
"
DOCS=( )

src_unpack() {
	unpack ${A}
}

python_test() {
	${EPYTHON} -m pytest
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
