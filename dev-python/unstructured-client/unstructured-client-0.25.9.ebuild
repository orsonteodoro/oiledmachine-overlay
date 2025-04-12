# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="unstructured-python-client"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/Unstructured-IO/unstructured-python-client.git"
	FALLBACK_COMMIT="f773b0d1a17412c3025d0ca2c7feec7c5ab49c6e" # Sep 18, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${PV}"
	SRC_URI="
https://github.com/Unstructured-IO/unstructured-python-client/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A Python client for the Unstructured hosted API"
HOMEPAGE="
	https://github.com/Unstructured-IO/unstructured-python-client
	https://pypi.org/project/unstructured-client
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
RDEPEND+="
	>=dev-python/certifi-2023.7.22[${PYTHON_USEDEP}]
	>=dev-python/charset-normalizer-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-3.1[${PYTHON_USEDEP}]
	>=dev-python/dataclasses-json-0.6.4[${PYTHON_USEDEP}]
	>=dev-python/deepdiff-6.0[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.27.0[${PYTHON_USEDEP}]
	>=dev-python/idna-3.4[${PYTHON_USEDEP}]
	>=dev-python/jsonpath-python-1.0.6[${PYTHON_USEDEP}]
	>=dev-python/marshmallow-3.19.0[${PYTHON_USEDEP}]
	>=dev-python/mypy-extensions-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/nest-asyncio-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-23.1[${PYTHON_USEDEP}]
	>=dev-python/pypdf-4.0[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.31.0[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.16.0[${PYTHON_USEDEP}]
	>=dev-python/typing-inspect-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.7.1[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.26.18[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/pylint-3.1.0[${PYTHON_USEDEP}]
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
	dodoc "LICENSE.md"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
