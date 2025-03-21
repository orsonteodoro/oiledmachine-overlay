# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="Fast discrete cosine transforms for PyTorch"
HOMEPAGE="
	https://pypi.org/project/dctorch
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.22.3[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.8.0[${PYTHON_USEDEP}]
	')
	>=sci-ml/pytorch-1.11.0[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/poetry-core-1.0.0[${PYTHON_USEDEP}]
		dev? (
			>=dev-python/black-22.3.0[${PYTHON_USEDEP}]
		)
	')
"
DOCS=( )

src_unpack() {
	unpack ${A}
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
