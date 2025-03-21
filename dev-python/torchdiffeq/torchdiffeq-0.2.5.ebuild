# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # Upstream listed up to 3.6

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="Differentiable Ordinary Differential Equation (ODE) solvers with full GPU support and O(1)-memory backpropagation"
HOMEPAGE="
	https://github.com/rtqichen/torchdiffeq
	https://pypi.org/project/torchdiffeq
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/scipy-1.4.0[${PYTHON_USEDEP}]
	')
	>=sci-ml/pytorch-1.5.0[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
