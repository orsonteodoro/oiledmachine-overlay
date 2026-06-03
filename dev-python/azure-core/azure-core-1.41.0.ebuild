# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..14} "pypy3_11" )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/azure_core-${PV}"
# Use this to reduce the download time and to simplify requirements search
SRC_URI="
https://files.pythonhosted.org/packages/a6/f3/b416179e408990df5db0d516283022dde0f5d0111d98c1a848e41853e81c/azure_core-${PV}.tar.gz
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
IUSE+=" aio dev tracing"
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
	dev? (
		dev-python/trio[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			<dev-python/aiohttp-3.8.6[${PYTHON_USEDEP}]
		' pypy3_11)
		$(python_gen_cond_dep '
			dev-python/aiohttp[${PYTHON_USEDEP}]
		' python3_{10..14})
		dev-python/pytest-trio[${PYTHON_USEDEP}]
		dev-python/azure-storage-blob[${PYTHON_USEDEP}]
		dev-python/azure-data-tables[${PYTHON_USEDEP}]
		~dev-python/opentelemetry-sdk-1.26[${PYTHON_USEDEP}]
		>=dev-python/opentelemetry-instrumentation-requests-0.50_beta0[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
	)
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
