# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN//-/_}"

DISTUTILS_USE_PEP517="setuptools"
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( "python3_"{10..13} )

inherit abseil-cpp distutils-r1 protobuf

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
	https://files.pythonhosted.org/packages/11/d1/48fe5d7a43d278e9f6b5ada810b0a3530bbeac7ed7fcbcd366f932f05316/google_ai_generativelanguage-0.6.15.tar.gz
"

DESCRIPTION="Google AI Generative Language API client library"
HOMEPAGE="
	https://github.com/googleapis/google-cloud-python/tree/main/packages/google-ai-generativelanguage
	https://pypi.org/project/google-ai-generativelanguage/
"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"
RESTRICT="
	!test? (
		test
	)
"
RDEPEND="
	(
		!=dev-python/google-api-core-2.0*
		!=dev-python/google-api-core-2.1*
		!=dev-python/google-api-core-2.2*
		!=dev-python/google-api-core-2.3*
		!=dev-python/google-api-core-2.4*
		!=dev-python/google-api-core-2.5*
		!=dev-python/google-api-core-2.6*
		!=dev-python/google-api-core-2.7*
		!=dev-python/google-api-core-2.8*
		!=dev-python/google-api-core-2.9*
		!=dev-python/google-api-core-2.10*
		>=dev-python/google-api-core-1.34.1[${PYTHON_USEDEP},grpc]
		<dev-python/google-api-core-3.0.0[${PYTHON_USEDEP}]
	)
	(
		!=dev-python/google-auth-2.24.0
		!=dev-python/google-auth-2.25.0
		>=dev-python/google-auth-2.14.1[${PYTHON_USEDEP}]
		<dev-python/google-auth-3.0.0[${PYTHON_USEDEP}]
	)
	(
		$(python_gen_cond_dep '
			(
				>=dev-python/proto-plus-1.22.3[${PYTHON_USEDEP}]
				<dev-python/proto-plus-2.0.0[${PYTHON_USEDEP}]
			)
		' python3_{10,11,12})
		$(python_gen_cond_dep '
			(
				>=dev-python/proto-plus-1.25.0[${PYTHON_USEDEP}]
				<dev-python/proto-plus-2.0.0[${PYTHON_USEDEP}]
			)
		' python3_13)
	)
	(
		|| (
			dev-python/protobuf:4.21[${PYTHON_USEDEP}]
			dev-python/protobuf:4.25[${PYTHON_USEDEP}]
			dev-python/protobuf:5.29[${PYTHON_USEDEP}]
			dev-python/protobuf:6.33[${PYTHON_USEDEP}]
		)
		dev-python/protobuf:=
	)
"
DOCS=( "README.rst" )

python_configure() {
	if has_version "dev-libs/protobuf:3/3.21" ; then
		ABSEIL_CPP_SLOT="20211102"
		PROTOBUF_CPP_SLOT="3"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_3[@]}" )
	elif has_version "dev-libs/protobuf:4/4.25" ; then
		ABSEIL_CPP_SLOT="20240116"
		PROTOBUF_CPP_SLOT="4"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4[@]}" )
	elif has_version "dev-libs/protobuf:5/5.29" ; then
		ABSEIL_CPP_SLOT="20240722"
		PROTOBUF_CPP_SLOT="5"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_5[@]}" )
	else
		ABSEIL_CPP_SLOT="20211102"
		PROTOBUF_CPP_SLOT="3"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_3[@]}" )
	fi
	abseil-cpp_python_configure
	protobuf_python_configure
}
