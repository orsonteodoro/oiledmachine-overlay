# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See dev-python/opentelemetry-semantic-conventions for version correspondence

MY_PN="opentelemetry_instrumentation_httpx"
MY_PV="${PV/_beta/b}"

DISTUTILS_USE_PEP517="hatchling"
OPENTELEMETRY_PV="1.42.1"
PROTOBUF_CPP_SLOT="5"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

DESCRIPTION="OpenTelemetry HTTPX Instrumentation"
HOMEPAGE="
	https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-httpx
	https://pypi.org/project/opentelemetry-instrumentation-httpx
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="${PROTOBUF_CPP_SLOT}/"$(ver_cut "1-2" "${OPENTELEMETRY_PV}")
IUSE+="
instruments test
ebuild_revision_1
"
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

	>=dev-python/wrapt-1.0.0[${PYTHON_USEDEP}]
	<dev-python/wrapt-3.0.0[${PYTHON_USEDEP}]

	instruments? (
		>=dev-python/httpx-0.18.0[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	test? (
		~dev-python/anyio-4.3.0[${PYTHON_USEDEP}]
		~dev-python/asgiref-3.8.1[${PYTHON_USEDEP}]
		~dev-python/certifi-2024.7.4[${PYTHON_USEDEP}]
		~dev-python/exceptiongroup-1.2.0[${PYTHON_USEDEP}]
		~dev-python/h11-0.16[${PYTHON_USEDEP}]
		~dev-python/httpcore-1.0.9[${PYTHON_USEDEP}]
		~dev-python/httpx-0.28.1[${PYTHON_USEDEP}]
		~dev-python/idna-3.7[${PYTHON_USEDEP}]
		~dev-python/iniconfig-2.0.0[${PYTHON_USEDEP}]
		~dev-python/packaging-24.0[${PYTHON_USEDEP}]
		~dev-python/pluggy-1.6.0[${PYTHON_USEDEP}]
		~dev-python/py-cpuinfo-9.0.0[${PYTHON_USEDEP}]
		~dev-python/pytest-7.4.4[${PYTHON_USEDEP}]
		~dev-python/respx-0.22.0[${PYTHON_USEDEP}]
		~dev-python/sniffio-1.3.1[${PYTHON_USEDEP}]
		~dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
		~dev-python/typing-extensions-4.12.2[${PYTHON_USEDEP}]
		~dev-python/zipp-3.19.2[${PYTHON_USEDEP}]

		>=dev-python/wrapt-2.1.2[${PYTHON_USEDEP}]
		<dev-python/wrapt-1.17.3[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.rst" )

src_unpack() {
	unpack ${A}
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
