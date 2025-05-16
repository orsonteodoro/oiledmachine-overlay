# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# blockbuster
# grandalf
# langsmith
# pytest-watcher
# types-pyyaml
# types-jinja2

MY_PN="${PN/-/_}"

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="pdm-backend"
PYTHON_COMPAT=( "python3_"{11..13} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="LangChain Core contains the base abstractions that power the rest of the LangChain ecosystem"
HOMEPAGE="
	https://github.com/langchain-ai/langchain/tree/master/libs/core
	https://pypi.org/project/langchain-core
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev lint test typing"
RDEPEND+="
	$(python_gen_cond_dep '
		(
			!=dev-python/tenacity-8.4.0
			>=dev-python/tenacity-8.1.0[${PYTHON_USEDEP}]
		)
		>=dev-python/langsmith-0.1.126[${PYTHON_USEDEP}]
		>=dev-python/jsonpatch-1.33[${PYTHON_USEDEP}]
		>=dev-python/pydantic-2.7.4[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.3[${PYTHON_USEDEP}]
		>=dev-python/packaging-23.2[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.7[${PYTHON_USEDEP}]
	')
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev? (
			>=dev-python/grandalf-0.8[${PYTHON_USEDEP}]
			>=dev-python/jupyter-1.0.0[${PYTHON_USEDEP}]
			>=dev-python/setuptools-67.6.1[${PYTHON_USEDEP}]
		)
		lint? (
			>=dev-util/ruff-0.11.2[${PYTHON_USEDEP}]
		)
		test? (
			>=dev-python/blockbuster-1.5.18[${PYTHON_USEDEP}]
			>=dev-python/freezegun-1.2.2[${PYTHON_USEDEP}]
			>=dev-python/grandalf-0.8[${PYTHON_USEDEP}]
			>=dev-python/pytest-8[${PYTHON_USEDEP}]
			>=dev-python/pytest-asyncio-0.21.1[${PYTHON_USEDEP}]
			>=dev-python/pytest-mock-3.10.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-socket-0.7.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-watcher-0.3.4[${PYTHON_USEDEP}]
			>=dev-python/pytest-xdist-3.6.1[${PYTHON_USEDEP}]
			>=dev-python/responses-0.25.0[${PYTHON_USEDEP}]
			>=dev-python/syrupy-4.0.2[${PYTHON_USEDEP}]
		)
		typing? (
			>=dev-python/mypy-1.10[${PYTHON_USEDEP}]
			>=dev-python/types-pyyaml-6.0.12.2[${PYTHON_USEDEP}]
			>=dev-python/types-requests-2.28.11.5[${PYTHON_USEDEP}]
		)
	')
	test? (
		$(python_gen_cond_dep '
			dev-python/pytest-benchmark[${PYTHON_USEDEP}]
			dev-python/pytest-codspeed[${PYTHON_USEDEP}]
		')
		$(python_gen_cond_dep '
			>=dev-python/numpy-1.26.4[${PYTHON_USEDEP}]
		' python3_{10,11})
		$(python_gen_cond_dep '
			>=dev-python/numpy-2.1.0[${PYTHON_USEDEP}]
		' python3_13)
		dev-python/langchain-tests[${PYTHON_SINGLE_USEDEP}]
	)
	typing? (
		dev-python/langchain-text-splitters[${PYTHON_SINGLE_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	unpack ${A}
}

src_install() {
	distutils-r1_src_install
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
