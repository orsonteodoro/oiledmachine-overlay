# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="microsoft-authentication-library-for-python"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="dev"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/AzureAD/microsoft-authentication-library-for-python.git"
	FALLBACK_COMMIT="b92b4f18cb176231ae494639d24aeb19bd457d73" # Mar 11, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${PV}"
	SRC_URI="
https://github.com/AzureAD/microsoft-authentication-library-for-python/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Microsoft Authentication Library (MSAL) for Python"
HOMEPAGE="
	https://github.com/AzureAD/microsoft-authentication-library-for-python
	https://pypi.org/project/msal
"
LICENSE="
	all-rights-reserved
	MIT
"
# The distro's MIT license template does not contain the all rights reserved clause.
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc"
RDEPEND+="
	(
		>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
		<dev-python/requests-3[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/pyjwt-1.0.0[${PYTHON_USEDEP},crypto]
		<dev-python/pyjwt-3[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/cryptography-2.5[${PYTHON_USEDEP}]
		<dev-python/cryptography-47[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	doc? (
		dev-python/furo[${PYTHON_USEDEP}]
		dev-python/sphinx-paramlinks[${PYTHON_USEDEP}]
	)
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

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
