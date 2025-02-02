# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
FALLBACK_COMMIT="aead1e4db9890f12fc029ca57b9732aa16c62915" # Mar 13, 2022
PYTHON_COMPAT=( "python3_"{10..13} ) # Upstream tests up to 3.6

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/sean2077/jsonpath-python.git"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${FALLBACK_COMMIT}"
	SRC_URI="
https://github.com/sean2077/jsonpath-python/archive/${FALLBACK_COMMIT}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A more powerful JSONPath implementation in modern python"
HOMEPAGE="
	https://github.com/sean2077/jsonpath-python
	https://pypi.org/project/jsonpath-python
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
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
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
