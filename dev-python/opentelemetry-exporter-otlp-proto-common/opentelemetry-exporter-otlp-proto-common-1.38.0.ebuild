# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="opentelemetry_exporter_otlp_proto_common"

DISTUTILS_USE_PEP517="hatchling"
PROTOBUF_CPP_SLOT="5"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="OpenTelemetry Protobuf encoding"
HOMEPAGE="
	https://github.com/open-telemetry/opentelemetry-python/tree/main/exporter/opentelemetry-exporter-otlp-proto-common
	https://pypi.org/project/opentelemetry-exporter-otlp-proto-common
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="${PROTOBUF_CPP_SLOT}/$(ver_cut 1-2 ${PV})" # Use PYTHONPATH for multislot package
IUSE+=" test"
RDEPEND+="
	~dev-python/opentelemetry-proto-${PV}:${PROTOBUF_CPP_SLOT}[${PYTHON_USEDEP}]
	dev-python/opentelemetry-proto:=
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	test? (
		>=dev-python/asgiref-3.7.2[${PYTHON_USEDEP}]
		>=dev-python/importlib-metadata-6.11.0[${PYTHON_USEDEP}]
		>=dev-python/iniconfig-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/packaging-24.0[${PYTHON_USEDEP}]
		>=dev-python/pluggy-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/protobuf-5.26.1:5[${PYTHON_USEDEP}]
		dev-python/protobuf:=
		>=dev-python/py-cpuinfo-9.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.4.4[${PYTHON_USEDEP}]
		>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.10.0[${PYTHON_USEDEP}]
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
