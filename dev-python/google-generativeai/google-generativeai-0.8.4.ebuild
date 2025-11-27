# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="deprecated-generative-ai-python"

DISTUTILS_USE_PEP517="setuptools"
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( "python3_"{10..12} )

inherit abseil-cpp distutils-r1 protobuf

KEYWORDS="amd64 arm arm64 x86"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
https://github.com/google/generative-ai-python/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz
"

DESCRIPTION="Google Generative AI High level API client library and tools"
HOMEPAGE="
	https://github.com/google-gemini/deprecated-generative-ai-python
	https://pypi.org/project/google-generativeai/
"
LICENSE="Apache-2.0"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0"
IUSE="test"
RDEPEND="
	>=dev-python/google-auth-2.15.0[${PYTHON_USEDEP}]
	dev-python/google-api-core[${PYTHON_USEDEP}]
	dev-python/google-api-python-client[${PYTHON_USEDEP}]
	dev-python/protobuf[${PYTHON_USEDEP}]
	dev-python/protobuf:=
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	~dev-python/google-ai-generativelanguage-0.6.15[${PYTHON_USEDEP}]
"
DOCS=( "README.md" )

python_configure() {
	if has_version "dev-libs/protobuf:3/3.12" ; then
		ABSEIL_CPP_SLOT="20200225"
		PROTOBUF_CPP_SLOT="3"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_3[@]}" )
	elif has_version "dev-libs/protobuf:3/3.21" ; then
		ABSEIL_CPP_SLOT="20220623"
		PROTOBUF_CPP_SLOT="3"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_3[@]}" )
	elif has_version "dev-libs/protobuf:4/4.25" ; then
		ABSEIL_CPP_SLOT="20240116"
		PROTOBUF_CPP_SLOT="4"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_4[@]}" )
	elif has_version "dev-libs/protobuf:5/5.29" ; then
		ABSEIL_CPP_SLOT="20240722"
		PROTOBUF_CPP_SLOT="5"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_5[@]}" )
	elif has_version "dev-libs/protobuf:6/6.33" ; then
		ABSEIL_CPP_SLOT="20250512"
		PROTOBUF_CPP_SLOT="6"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_6[@]}" )
	fi
	abseil-cpp_python_configure
	protobuf_python_configure
}
