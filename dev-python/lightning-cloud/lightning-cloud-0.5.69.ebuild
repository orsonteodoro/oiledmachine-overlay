# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..11} )

inherit abseil-cpp distutils-r1 protobuf pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="Lightning Cloud"
HOMEPAGE="
	https://pypi.org/project/lightning-cloud
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
ebuild_revision_1
"
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/boto3[${PYTHON_USEDEP}]
		dev-python/click[${PYTHON_USEDEP}]
		dev-python/fastapi[${PYTHON_USEDEP}]
		|| (
			dev-python/protobuf:3.12[${PYTHON_USEDEP}]
			dev-python/protobuf:4.21[${PYTHON_USEDEP}]
			dev-python/protobuf:4.25[${PYTHON_USEDEP}]
			dev-python/protobuf:5.29[${PYTHON_USEDEP}]
			dev-python/protobuf:6.33[${PYTHON_USEDEP}]
		)
		dev-python/protobuf:=
		dev-python/pyjwt[${PYTHON_USEDEP}]
		dev-python/python-multipart[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/rich[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/urllib3[${PYTHON_USEDEP}]
		dev-python/uvicorn[${PYTHON_USEDEP}]
		dev-python/websocket-client[${PYTHON_USEDEP}]
	')
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	')
"
DOCS=( "README.md" )

src_unpack() {
	unpack ${A}
}

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

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
