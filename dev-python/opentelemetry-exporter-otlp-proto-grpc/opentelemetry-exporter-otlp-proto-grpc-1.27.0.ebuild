# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="opentelemetry_exporter_otlp_proto_grpc"

DISTUTILS_USE_PEP517="hatchling"
PROTOBUF_SLOT="3"
PYTHON_COMPAT=( "python3_"{10..12} )

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
	>=dev-python/deprecated-1.2.6[${PYTHON_USEDEP}]
	>=dev-python/googleapis-common-protos-1.52[${PYTHON_USEDEP}]
	>=dev-python/grpcio-1.0.0:${PROTOBUF_SLOT}[${PYTHON_USEDEP}]
	dev-python/grpcio:=
	~dev-python/opentelemetry-api-${PV}:${PROTOBUF_SLOT}[${PYTHON_USEDEP}]
	dev-python/opentelemetry-api:=
	~dev-python/opentelemetry-exporter-otlp-proto-common-${PV}:${PROTOBUF_SLOT}[${PYTHON_USEDEP}]
	dev-python/opentelemetry-exporter-otlp-proto-common:=
	~dev-python/opentelemetry-proto-${PV}:${PROTOBUF_SLOT}[${PYTHON_USEDEP}]
	dev-python/opentelemetry-proto:=
	~dev-python/opentelemetry-sdk-${PV}:${PROTOBUF_SLOT}[${PYTHON_USEDEP}]
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
#
# All OpenTelemetry Python packages will be moved
#
# from /usr/lib/${EPYTHON}/site-packages to
# to   /usr/lib/opentelemetry/${PROTOBUF_SLOT}/lib/${EPYTHON}/site-packages
#
# or base dir change
#
# from /usr
# to   /usr/lib/opentelemetry/${PROTOBUF_SLOT}
#
# This is to allow 1.27.0 used in LTS packages from being not disrupted by
# 1.38.0 rolling packages.
#
# To handle multslot OpenTelemetry Python do
# EPYTHON="python3.11"
# PROTOBUF_SLOT="3"
# # Add both multislot OpenTelemetry and multislot grpcio to PYTHONPATH
# PYTHONPATH="/usr/lib/opentelemetry/${PROTOBUF_SLOT}/lib/${EPYTHON}/site-packages:/usr/lib/grpc/${PROTOBUF_SLOT}/lib/${EPYTHON}/site-packages:${PYTHONPATH}"
# <appname>
# # or put in wrapper script
#
die "QA:  FIXME:  Change install location"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
