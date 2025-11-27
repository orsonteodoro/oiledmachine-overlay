# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="opentelemetry_exporter_otlp_proto_grpc"

DISTUTILS_USE_PEP517="hatchling"
PROTOBUF_CPP_SLOT="5"
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
SLOT="${PROTOBUF_CPP_SLOT}/$(ver_cut 1-2 ${PV})" # Use PYTHONPATH for multislot package
IUSE+="
ebuild_revision_1
"
RDEPEND+="
	>=dev-python/googleapis-common-protos-1.57[${PYTHON_USEDEP}]
	>=dev-python/grpcio-1.63.2:${PROTOBUF_CPP_SLOT}[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.6.0[${PYTHON_USEDEP}]
	~dev-python/opentelemetry-api-${PV}:${PROTOBUF_CPP_SLOT}[${PYTHON_USEDEP}]
	dev-python/opentelemetry-api:=
	~dev-python/opentelemetry-exporter-otlp-proto-common-${PV}:${PROTOBUF_CPP_SLOT}[${PYTHON_USEDEP}]
	dev-python/opentelemetry-exporter-otlp-proto-common:=
	~dev-python/opentelemetry-proto-${PV}:${PROTOBUF_CPP_SLOT}[${PYTHON_USEDEP}]
	dev-python/opentelemetry-proto:=
	~dev-python/opentelemetry-sdk-${PV}:${PROTOBUF_CPP_SLOT}[${PYTHON_USEDEP}]
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
	insinto "/usr/lib/opentelemetry/${PROTOBUF_CPP_SLOT}/share/doc/${P}/licenses"
	doins "LICENSE"
#
# All OpenTelemetry Python packages will be moved
#
# from /usr/lib/${EPYTHON}/site-packages to
# to   /usr/lib/opentelemetry/${PROTOBUF_CPP_SLOT}/lib/${EPYTHON}/site-packages
#
# or base dir change
#
# from /usr
# to   /usr/lib/opentelemetry/${PROTOBUF_CPP_SLOT}
#
# This is to allow 1.27.0 used in LTS packages from being not disrupted by
# 1.38.0 rolling packages.
#
# See also opentelemetry.eclass
#
}

python_install_all() {
	distutils-r1_python_install_all
	dodir "/usr/lib/opentelemetry/${PROTOBUF_CPP_SLOT}/lib"
	mv \
		"${ED}/usr/lib/python"* \
		"${ED}/usr/lib/opentelemetry/${PROTOBUF_CPP_SLOT}/lib" \
		|| die

	dodir "/usr/lib/opentelemetry/${PROTOBUF_CPP_SLOT}/share/doc"
	mv \
		"${ED}/usr/share/doc/${PN}-${PV}" \
		"${ED}/usr/lib/opentelemetry/${PROTOBUF_CPP_SLOT}/share/doc" \
		|| die
}
