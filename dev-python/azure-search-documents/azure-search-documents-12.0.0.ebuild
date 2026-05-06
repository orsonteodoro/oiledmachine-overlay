# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/azure_search_documents-${PV}"
# Use this to reduce the download time and to simplify requirements search
SRC_URI="
https://files.pythonhosted.org/packages/59/dc/bb4db263381aa5b29414e280a8535a343d877a3831a501ef39332174c85c/azure_search_documents-${PV}.tar.gz
"

DESCRIPTION="Azure AI Search client library for Python"
HOMEPAGE="
	https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/search/azure-search-documents
	https://pypi.org/project/azure-search-documents
"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
"
# The distro's MIT template does not contain the all rights reserved clause.
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
	>=dev-python/azure-core-1.37.0[${PYTHON_USEDEP}]
	>=dev-python/isodate-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.6.0[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-77.0.3[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"
DOCS=( "CHANGELOG.md" "README.md" "TROUBLESHOOTING.md" )

src_unpack() {
	unpack ${A}
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
