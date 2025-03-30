# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/explosion/spacy-legacy/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="🕸️ Legacy architectures and other registered spaCy v3.x functions for backwards-compatibility"
HOMEPAGE="
	https://github.com/explosion/spacy-legacy
	https://pypi.org/project/spacy-legacy
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev? (
			>=dev-python/pytest-5.0.1[${PYTHON_USEDEP}]
		)
	')
	dev? (
		dev-python/wandb[${PYTHON_SINGLE_USEDEP}]
	)
"
PDEPEND+="
	>=dev-python/spacy-3.1.0[${PYTHON_SINGLE_USEDEP}]
"
DOCS=( "README.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
