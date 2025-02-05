# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# psycopg2-binary

MY_PN="pgvector-python"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/pgvector/pgvector-python.git"
	FALLBACK_COMMIT="d24839b48f78059b2732f8dfb398fc1ffc8070cc" # Oct 26, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${PV}"
	SRC_URI="
https://github.com/pgvector/pgvector-python/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="pgvector support for Python"
HOMEPAGE="
	https://github.com/pgvector/pgvector-python
	https://pypi.org/project/pgvector
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
# Missing asyncio USE flag
SQLALCHEMY_RDEPEND="
	dev-python/greenlet[${PYTHON_USEDEP}]
"
RDEPEND+="
	${SQLALCHEMY_RDEPEND}
	>=dev-python/sqlalchemy-2[${PYTHON_USEDEP},asyncio(+)]
	>=dev-python/sqlmodel-0.0.12[${PYTHON_USEDEP}]
	dev-python/asyncpg[${PYTHON_USEDEP}]
	dev-python/django[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/peewee[${PYTHON_USEDEP}]
	dev-python/psycopg:2[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
DOCS=( "CHANGELOG.md" "README.md" )

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
	dodoc "LICENSE.txt"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
