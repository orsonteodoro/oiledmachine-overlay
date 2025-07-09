# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="develop"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/aboutcode-org/urlpy.git"
	FALLBACK_COMMIT="c4fdb3843594ba7a212100adeb45ae8c9b62c33b" # Apr 28, 2020
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/aboutcode-org/urlpy/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Simple URL parsing, canonicalization and equivalence"
HOMEPAGE="
	https://github.com/aboutcode-org/urlpy
	https://pypi.org/project/urlpy
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
RDEPEND+="
	dev-python/publicsuffix2[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.rst" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "version=\"0.5\"" "${S}/setup.py" \
			|| die "QA:  Bump version"
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
