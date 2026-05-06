# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..14} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/azure_core-${PV}"
# Use this to reduce the download time and to simplify requirements search
SRC_URI="
https://files.pythonhosted.org/packages/ce/d9/6f5972b44761277394527a3a76af5ae2ef82fc5f20ce351abf0c826eca67/azure_core-${PV}.tar.gz
"

DESCRIPTION="Azure Core shared client library for Python"
HOMEPAGE="
	https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/core/azure-core
	https://pypi.org/project/azure-core
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" aio tracing"
RDEPEND+="
	>=dev-python/requests-2.21.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.6.0[${PYTHON_USEDEP}]
	aio? (
		>=dev-python/aiohttp-3.0[${PYTHON_USEDEP}]
	)
	tracing? (
		=dev-python/opentelemetry-api-1.26*[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-77.0.3[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"
DOCS=( "CHANGELOG.md" "CLIENT_LIBRARY_DEVELOPER.md" "ENVIRONMENT_VARIABLES.md" "README.md" "TROUBLESHOOTING.md" )

src_unpack() {
	unpack ${A}
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
