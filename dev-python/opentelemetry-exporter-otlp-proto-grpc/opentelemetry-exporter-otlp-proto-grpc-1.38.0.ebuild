# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="opentelemetry_exporter_otlp_proto_grpc"

DISTUTILS_USE_PEP517="hatchling"
PROTOBUF_SLOT="5"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="OpenTelemetry Collector Protobuf over gRPC Exporter"
HOMEPAGE="
	https://github.com/open-telemetry/opentelemetry-python/tree/main/exporter/opentelemetry-exporter-otlp-proto-grpc
	https://pypi.org/project/opentelemetry-exporter-otlp-proto-grpc
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="${PROTOBUF_SLOT}/${PV}" # Use PYTHONPATH for multislot package
IUSE+=" "
RDEPEND+="
	>=dev-python/googleapis-common-protos-1.57[${PYTHON_USEDEP}]
	>=dev-python/grpcio-1.63.2:${PROTOBUF_SLOT}[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.6.0[${PYTHON_USEDEP}]
	~dev-python/opentelemetry-api-${PV}[${PYTHON_USEDEP}]
	dev-python/opentelemetry-api:=
	~dev-python/opentelemetry-exporter-otlp-proto-common-${PV}[${PYTHON_USEDEP}]
	dev-python/opentelemetry-exporter-otlp-proto-common:=
	~dev-python/opentelemetry-proto-${PV}[${PYTHON_USEDEP}]
	dev-python/opentelemetry-proto:=
	~dev-python/opentelemetry-sdk-${PV}[${PYTHON_USEDEP}]
	dev-python/opentelemetry-sdk:=
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
die "QA:  FIXME:  Change install location"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
