# Copyright 2023-2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10,11} )

inherit distutils-r1

if [[ "${PV}" =~ 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/miguelgrinberg/Flask-HTTPAuth.git"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-${PV}"
	IUSE+=" fallback-commit"
else
	SRC_URI="
https://github.com/miguelgrinberg/Flask-HTTPAuth/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Simple extension that provides Basic, Digest and Token HTTP authentication for Flask routes"
HOMEPAGE="https://github.com/miguelgrinberg/Flask-HTTPAuth"
LICENSE="
	MIT
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
DEPEND+="
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-42
	dev-python/wheel
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/asgiref[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( AUTHORS CHANGES.md docs/index.rst README.md )

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"

src_unpack() {
	if [[ "${PV}" =~ 9999 ]] ; then
		use fallback-commit && EGIT_COMMIT="4d01283dff804b6eb92961f3a5188031476861b2"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = '1.6'" "${S}/setup.cfg" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc LICENSE
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
