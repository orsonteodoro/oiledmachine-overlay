# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${PN/-/_}-${PV}"
SRC_URI="
https://github.com/georgkrause/language_data/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="An optional supplement to \`langcodes\` that stores names and statistics of languages"
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

python_configure() {
	git init || die
	touch dummy || die
	git config user.email "name@example.com" || die
	git config user.name "John Doe" || die
	git add dummy || die
	git commit -m "Dummy" || die
	git tag v${PV} || die
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
