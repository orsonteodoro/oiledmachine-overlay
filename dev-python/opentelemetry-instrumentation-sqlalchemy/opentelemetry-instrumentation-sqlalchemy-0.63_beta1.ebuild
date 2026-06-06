# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See dev-python/opentelemetry-semantic-conventions for version correspondence

MY_PN="opentelemetry_instrumentation_sqlalchemy"
MY_PV="${PV/_beta/b}"

DISTUTILS_USE_PEP517="hatchling"
OPENTELEMETRY_PV="1.42.1"
PROTOBUF_CPP_SLOT="5"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

DESCRIPTION="OpenTelemetry SQLAlchemy instrumentation"
HOMEPAGE="
	https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-sqlalchemy
	https://pypi.org/project/opentelemetry-instrumentation-sqlalchemy
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
	~dev-python/opentelemetry-api-${OPENTELEMETRY_PV}:${PROTOBUF_CPP_SLOT}[${PYTHON_USEDEP}]
	dev-python/opentelemetry-api:=
	~dev-python/opentelemetry-instrumentation-${PV}:${SLOT}[${PYTHON_USEDEP}]
	dev-python/opentelemetry-instrumentation:=
	~dev-python/opentelemetry-semantic-conventions-${PV}:${SLOT}[${PYTHON_USEDEP}]
	dev-python/opentelemetry-semantic-conventions:=

	>=dev-python/packaging-21.0[${PYTHON_USEDEP}]
	>=dev-python/wrapt-1.11.2[${PYTHON_USEDEP}]

	instruments? (
		>=dev-python/sqlalchemy-1.0.0[${PYTHON_USEDEP}]
		<dev-python/sqlalchemy-2.1.0[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	test? (
		~dev-python/aiosqlite-0.20.0[${PYTHON_USEDEP}]
		~dev-python/asgiref-3.8.1[${PYTHON_USEDEP}]
		~dev-python/deprecated-1.2.14[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			~dev-python/greenlet-3.3.1[${PYTHON_USEDEP}]
		' python3_{10..13})
		~dev-python/iniconfig-2.0.0[${PYTHON_USEDEP}]
		~dev-python/packaging-24.1[${PYTHON_USEDEP}]
		~dev-python/pluggy-1.6.0[${PYTHON_USEDEP}]
		~dev-python/pytest-7.4.4[${PYTHON_USEDEP}]
		~dev-python/sqlalchemy-2.0.36[${PYTHON_USEDEP}]
		~dev-python/typing_extensions-4.12.2[${PYTHON_USEDEP}]
		~dev-python/wrapt-1.16.0[${PYTHON_USEDEP}]
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
