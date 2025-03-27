# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# randomize
# sphinx-markdown-tables

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_11" )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/kubernetes-client/python.git"
	FALLBACK_COMMIT="bc4fd671bfa702007e090ae3ae28bf28bc9c3a6e" # Feb 18, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/python-${PV}"
	SRC_URI="
https://github.com/kubernetes-client/python/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Official Python client library for kubernetes"
HOMEPAGE="
	https://github.com/kubernetes-client/python
	https://pypi.org/project/kubernetes
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" adal test"
RDEPEND+="
	(
		>=dev-python/websocket-client-0.32.0[${PYTHON_USEDEP}]
		!=dev-python/websocket-client-0.40.0
		!=dev-python/websocket-client-0.41*
		!=dev-python/websocket-client-0.42*
	)
	>=dev-python/certifi-14.05.14[${PYTHON_USEDEP}]
	>=dev-python/durationpy-0.7[${PYTHON_USEDEP}]
	>=dev-python/google-auth-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/oauthlib-3.2.2[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.5.3[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.4.1[${PYTHON_USEDEP}]
	>=dev-python/setuptools-21.0.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.24.2[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests-oauthlib[${PYTHON_USEDEP}]
	adal? (
		>=dev-python/adal-1.0.2[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	test? (
		>=dev-python/coverage-4.0.3[${PYTHON_USEDEP}]
		>=dev-python/nose-1.3.7[${PYTHON_USEDEP}]
		>=dev-python/pluggy-0.3.1[${PYTHON_USEDEP}]
		>=dev-python/randomize-0.13[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.4[${PYTHON_USEDEP}]
		dev-python/autopep8[${PYTHON_USEDEP}]
		dev-python/isort[${PYTHON_USEDEP}]
		dev-python/pycodestyle[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/recommonmark[${PYTHON_USEDEP}]
		dev-python/sphinx-markdown-tables[${PYTHON_USEDEP}]
	)
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

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
