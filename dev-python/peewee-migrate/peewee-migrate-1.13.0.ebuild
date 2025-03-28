# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# pytest-mypy

MY_PN="${PN/-/_}"

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="develop"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/klen/peewee_migrate.git"
	FALLBACK_COMMIT="c0dd3090b849eebc2e52485f9e1af2a26e47f369" # Jul 17, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${PV}"
	SRC_URI="
https://github.com/klen/peewee_migrate/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Simple migration engine for Peewee"
HOMEPAGE="
	https://github.com/klen/peewee_migrate
	https://pypi.org/project/peewee-migrate
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
RDEPEND+="
	>=dev-python/peewee-3[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/poetry-core-1.0[${PYTHON_USEDEP}]
	dev? (
		>=dev-python/psycopg-2.9.5:2[${PYTHON_USEDEP}]
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-mypy[${PYTHON_USEDEP}]
		dev-util/ruff
		$(python_gen_any_dep '
			dev-vcs/pre-commit[${PYTHON_SINGLE_USEDEP}]
		')
	)
"
DOCS=( "Changelog" "README.rst" )

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
