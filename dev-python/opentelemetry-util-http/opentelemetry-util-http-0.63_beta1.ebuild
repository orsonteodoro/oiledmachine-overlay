# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="opentelemetry_util_http"
MY_PV="${PV/_beta/b}"

DISTUTILS_USE_PEP517="hatchling"
OPENTELEMETRY_PV="1.42.1"
PROTOBUF_CPP_SLOT="5"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

DESCRIPTION="Web util for OpenTelemetry"
HOMEPAGE="
	https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/util/opentelemetry-util-http
	https://pypi.org/project/opentelemetry-util-http
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="${PROTOBUF_CPP_SLOT}/"$(ver_cut "1-2" "${OPENTELEMETRY_PV}")
IUSE+="
test
ebuild_revision_2
"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	test? (
		~dev-python/asgiref-3.8.1[${PYTHON_USEDEP}]
		~dev-python/deprecated-1.2.14[${PYTHON_USEDEP}]
		~dev-python/iniconfig-2.0.0[${PYTHON_USEDEP}]
		~dev-python/packaging-24.0[${PYTHON_USEDEP}]
		~dev-python/pluggy-1.6.0[${PYTHON_USEDEP}]
		~dev-python/py-cpuinfo-9.0.0[${PYTHON_USEDEP}]
		~dev-python/pytest-7.4.4[${PYTHON_USEDEP}]
		~dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
		~dev-python/typing_extensions-4.12.2[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.rst" )

src_unpack() {
	unpack ${A}
}

src_install() {
	distutils-r1_src_install
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
