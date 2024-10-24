# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/georgkrause/language_data/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Create, fill a temporary directory"
HOMEPAGE="
	https://github.com/georgkrause/language_data
	https://pypi.org/project/language_data
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
RDEPEND+="
	>=dev-python/marisa-trie-0.7.7[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-60[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-8.0[${PYTHON_USEDEP}]

	dev-python/build[${PYTHON_USEDEP}]
	dev-python/twine[${PYTHON_USEDEP}]

	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
"
DOCS=( "CHANGELOG.md" "README.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
