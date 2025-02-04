# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="opentelemetry_instrumentation_fastapi"
MY_PV="${PV/_beta/b}"

DISTUTILS_USE_PEP517="hatchling"
OPENTELEMETRY_PV="1.27.0"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

DESCRIPTION="OpenTelemetry FastAPI Instrumentation"
HOMEPAGE="
	https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-fastapi
	https://pypi.org/project/opentelemetry-instrumentation-fastapi
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/${OPENTELEMETRY_PV}"
IUSE+=" instruments"
RDEPEND+="
	~dev-python/opentelemetry-api-${OPENTELEMETRY_PV}[${PYTHON_USEDEP}]
	~dev-python/opentelemetry-instrumentation-${PV}:${SLOT}[${PYTHON_USEDEP}]
	~dev-python/opentelemetry-instrumentation-asgi-${PV}:${SLOT}[${PYTHON_USEDEP}]
	~dev-python/opentelemetry-semantic-conventions-${PV}:${SLOT}[${PYTHON_USEDEP}]
	~dev-python/opentelemetry-util-http-${PV}:${SLOT}[${PYTHON_USEDEP}]
	instruments? (
		>=dev-python/fastapi-0.58[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.rst" )

src_unpack() {
	unpack ${A}
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
