# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="opentelemetry_exporter_otlp_proto_http"

DISTUTILS_USE_PEP517="hatchling"
PROTOBUF_CPP_SLOT="5"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit abseil-cpp distutils-r1 protobuf pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="OpenTelemetry Collector Protobuf over HTTP Exporter"
HOMEPAGE="
	https://github.com/open-telemetry/opentelemetry-python/tree/main/exporter/opentelemetry-exporter-otlp-proto-http
	https://pypi.org/project/opentelemetry-exporter-otlp-proto-http
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="${PROTOBUF_CPP_SLOT}/"$(ver_cut "1-2" "${PV}") # Use PYTHONPATH for multislot package
IUSE+="
gcp-auth test
ebuild_revision_3
"
RDEPEND+="
	>=dev-python/googleapis-common-protos-1.52[${PYTHON_USEDEP}]
	>=dev-python/opentelemetry-api-${PV}:${PROTOBUF_CPP_SLOT}
	dev-python/opentelemetry-api:=
	>=dev-python/opentelemetry-proto-${PV}:${PROTOBUF_CPP_SLOT}
	dev-python/opentelemetry-proto:=
	>=dev-python/opentelemetry-sdk-${PV}:${PROTOBUF_CPP_SLOT}
	dev-python/opentelemetry-sdk:=
	>=dev-python/opentelemetry-exporter-otlp-proto-common-${PV}:${PROTOBUF_CPP_SLOT}
	dev-python/opentelemetry-exporter-otlp-proto-common:=
	>=dev-python/requests-2.7[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.5.0[${PYTHON_USEDEP}]
	gcp-auth? (
		>=dev-python/opentelemetry-exporter-credential-provider-gcp-0.59_beta0:${PROTOBUF_CPP_SLOT}
		dev-python/opentelemetry-exporter-credential-provider-gcp:=
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	test? (
		~dev-python/asgiref-3.7.2[${PYTHON_USEDEP}]
		~dev-python/certifi-2024.7.4[${PYTHON_USEDEP}]
		~dev-python/charset-normalizer-3.3.2[${PYTHON_USEDEP}]
		~dev-python/googleapis-common-protos-1.70.0[${PYTHON_USEDEP}]
		~dev-python/idna-3.7[${PYTHON_USEDEP}]
		~dev-python/iniconfig-2.0.0[${PYTHON_USEDEP}]
		~dev-python/packaging-24.0[${PYTHON_USEDEP}]
		~dev-python/pluggy-1.6.0[${PYTHON_USEDEP}]
		dev-python/protobuf:${PROTOBUF_CPP_SLOT}[${PYTHON_USEDEP}]
		dev-python/protobuf:=
		~dev-python/py-cpuinfo-9.0.0[${PYTHON_USEDEP}]
		~dev-python/pytest-7.4.4[${PYTHON_USEDEP}]
		~dev-python/pyyaml-6.0.1[${PYTHON_USEDEP}]
		~dev-python/requests-2.32.3[${PYTHON_USEDEP}]
		~dev-python/responses-0.24.1[${PYTHON_USEDEP}]
		~dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
		~dev-python/typing_extensions-4.12.0[${PYTHON_USEDEP}]
		~dev-python/urllib3-2.2.2[${PYTHON_USEDEP}]
		~dev-python/wrapt-1.16.0[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.rst" )

src_unpack() {
	unpack ${A}
}

python_configure() {
	if has_version "dev-libs/protobuf:5/5.29" ; then
		ABSEIL_CPP_SLOT="20240722"
		PROTOBUF_CPP_SLOT="5"
		PROTOBUF_PYTHON_SLOT="${PROTOBUF_PYTHON_SLOT_5}"
	fi
	abseil-cpp_python_configure
	protobuf_python_configure
}

src_install() {
	distutils-r1_src_install
	insinto "/usr/lib/opentelemetry/${PROTOBUF_CPP_SLOT}/share/doc/${P}/licenses"
	doins "LICENSE"
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
