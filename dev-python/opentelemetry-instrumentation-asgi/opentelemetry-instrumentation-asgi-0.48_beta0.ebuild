# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See dev-python/opentelemetry-semantic-conventions for version correspondence

MY_PN="opentelemetry_instrumentation_asgi"
MY_PV="${PV/_beta/b}"

DISTUTILS_USE_PEP517="hatchling"
OPENTELEMETRY_PV="1.27.0"
PROTOBUF_CPP_SLOT="3"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

DESCRIPTION="ASGI instrumentation for OpenTelemetry"
HOMEPAGE="
	https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-asgi
	https://pypi.org/project/opentelemetry-instrumentation-asgi
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/${OPENTELEMETRY_PV}"
IUSE+=" instruments test"
RDEPEND+="
	>=dev-python/asgiref-3.0[${PYTHON_USEDEP}]
	~dev-python/opentelemetry-api-${OPENTELEMETRY_PV}:${PROTOBUF_CPP_SLOT}[${PYTHON_USEDEP}]
	dev-python/opentelemetry-api:=
	~dev-python/opentelemetry-instrumentation-${PV}:${SLOT}[${PYTHON_USEDEP}]
	dev-python/opentelemetry-instrumentation:=
	~dev-python/opentelemetry-semantic-conventions-${PV}:${SLOT}[${PYTHON_USEDEP}]
	dev-python/opentelemetry-semantic-conventions:=
	~dev-python/opentelemetry-util-http-${PV}:${SLOT}[${PYTHON_USEDEP}]
	dev-python/opentelemetry-util-http:=
	instruments? (
		>=dev-python/asgiref-3.0[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	test? (
		>=dev-python/asgiref-3.7.2[${PYTHON_USEDEP}]
		>=dev-python/deprecated-1.2.14[${PYTHON_USEDEP}]
		>=dev-python/importlib-metadata-6.11.0[${PYTHON_USEDEP}]
		>=dev-python/iniconfig-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/packaging-24.0[${PYTHON_USEDEP}]
		>=dev-python/pluggy-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/py-cpuinfo-9.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.4.4[${PYTHON_USEDEP}]
		>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.9.2[${PYTHON_USEDEP}]
		>=dev-python/wrapt-1.16.0[${PYTHON_USEDEP}]
		>=dev-python/zipp-3.19.2[${PYTHON_USEDEP}]
	)
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
