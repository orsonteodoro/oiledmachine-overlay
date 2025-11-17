# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# dev-python/opentelemetry-semantic-conventions for version correspondence

MY_PN="opentelemetry_instrumentation"
MY_PV="${PV/_beta/b}"

DISTUTILS_USE_PEP517="hatchling"
OPENTELEMETRY_PV="1.27.0"
PROTOBUF_CPP_SLOT="3"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

DESCRIPTION="Instrumentation Tools & Auto Instrumentation for OpenTelemetry Python"
HOMEPAGE="
	https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/opentelemetry-instrumentation
	https://pypi.org/project/opentelemetry-instrumentation
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="${PROTOBUF_CPP_SLOT}/${OPENTELEMETRY_PV%.*}"
IUSE+="
test
ebuild_revision_2
"
RDEPEND+="
	>=dev-python/setuptools-16.0[${PYTHON_USEDEP}]
	>=dev-python/wrapt-1.0.0[${PYTHON_USEDEP}]
	<dev-python/wrapt-2.0.0[${PYTHON_USEDEP}]
	~dev-python/opentelemetry-api-${OPENTELEMETRY_PV}:${PROTOBUF_CPP_SLOT}[${PYTHON_USEDEP}]
	dev-python/opentelemetry-api:=
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

	rm -rf "${ED}/usr/bin" || true
	dodir "/usr/bin"
	dosym \
		"/usr/lib/python-exec/python-exec2" \
		"/usr/lib/opentelemetry/${PROTOBUF_CPP_SLOT}/bin/opentelemetry-instrument/bin/opentelemetry-bootstrap"
	dosym \
		"/usr/lib/python-exec/python-exec2" \
		"/usr/lib/opentelemetry/${PROTOBUF_CPP_SLOT}/bin/opentelemetry-instrument/opentelemetry-instrument"
}
