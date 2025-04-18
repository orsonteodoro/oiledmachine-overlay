# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# fastapi-cli
# griffe-typingdoc
# pydantic-ai
# pydantic-extra-types
# markdown-include-variants
# mdx-include
# mkdocs-macros-plugin
# types-ujson
# types-orjson

DISTUTILS_USE_PEP517="pdm-backend"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/fastapi/fastapi.git"
	FALLBACK_COMMIT="7128971f1d61e2e1e6f220a5f66baa925b635278" # Jan 30, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/fastapi/fastapi/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A modern, fast (high-performance), web framework for building APIs with Python"
HOMEPAGE="
	https://github.com/fastapi/fastapi
	https://pypi.org/project/fastapi
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" all dev doc standard test translations"
# Missing standard USE flag for uvicorn.
UVICORN_RDEPEND="
	(
		(
			!=dev-python/uvloop-0.15.0
			!=dev-python/uvloop-0.15.1
			>=dev-python/uvloop-0.14.0[${PYTHON_USEDEP}]
		)
		>=dev-python/httptools-0.6.3[${PYTHON_USEDEP}]
		>=dev-python/python-dotenv-0.13[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
		>=dev-python/uvicorn-0.12.0[${PYTHON_USEDEP},standard(+)]
		>=dev-python/watchfiles-0.13[${PYTHON_USEDEP}]
		>=dev-python/websockets-10.4[${PYTHON_USEDEP}]
	)
"
FASTAPI_CLI_RDEPEND="
	(
		${UVICORN_RDEPEND}
		>=dev-python/fastapi-cli-0.0.5[${PYTHON_USEDEP},standard(+)]
	)
"
RDEPEND+="
	(
		!=dev-python/pydantic-1.8
		!=dev-python/pydantic-1.8.1
		!=dev-python/pydantic-2.0.0
		!=dev-python/pydantic-2.0.1
		!=dev-python/pydantic-2.1.0
		>=dev-python/pydantic-1.7.4[${PYTHON_USEDEP}]
		<dev-python/pydantic-3.0.0[${PYTHON_USEDEP}]
	)
	>=dev-python/starlette-0.40.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.8.0[${PYTHON_USEDEP}]
	all? (
		${FASTAPI_CLI_RDEPEND}
		${UVICORN_RDEPEND}
		(
			>=dev-python/ujson-4.0.1[${PYTHON_USEDEP}]
			!=dev-python/ujson-4.0.2[${PYTHON_USEDEP}]
			!=dev-python/ujson-4.1.0[${PYTHON_USEDEP}]
			!=dev-python/ujson-4.2.0[${PYTHON_USEDEP}]
			!=dev-python/ujson-4.3.0[${PYTHON_USEDEP}]
			!=dev-python/ujson-5.0.0[${PYTHON_USEDEP}]
			!=dev-python/ujson-5.1.0[${PYTHON_USEDEP}]
		)
		>=dev-python/email-validator-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/httpx-0.23.0[${PYTHON_USEDEP}]
		>=dev-python/itsdangerous-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/jinja2-3.1.5[${PYTHON_USEDEP}]
		>=dev-python/orjson-3.2.1[${PYTHON_USEDEP}]
		>=dev-python/pydantic-extra-types-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/pydantic-settings-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/python-multipart-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.3.1[${PYTHON_USEDEP}]
	)
	standard? (
		${FASTAPI_CLI_RDEPEND}
		${UVICORN_RDEPEND}
		>=dev-python/email-validator-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/httpx-0.23.0[${PYTHON_USEDEP}]
		>=dev-python/jinja2-3.1.5[${PYTHON_USEDEP}]
		>=dev-python/python-multipart-0.0.18[${PYTHON_USEDEP}]
	)
	translations? (
		>=dev-python/pydantic-ai-0.0.30[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-vcs/pre-commit-2.17.0
		dev-python/playwright-bin
	)
	doc? (
		(
			>=dev-python/mkdocstrings-0.26.1[${PYTHON_USEDEP},python(+)]
			>=dev-python/mkdocstrings-python-0.5.2[${PYTHON_USEDEP}]
		)
		>=dev-python/black-25.1.0[${PYTHON_USEDEP}]
		>=dev-python/griffe-typingdoc-0.2.7[${PYTHON_USEDEP}]
		>=dev-python/jieba-0.42.1[${PYTHON_USEDEP}]
		>=dev-python/markdown-include-variants-0.0.4[${PYTHON_USEDEP}]
		>=dev-python/mdx-include-1.4.1[${PYTHON_USEDEP}]
		>=dev-python/mkdocs-macros-plugin-1.3.7[${PYTHON_USEDEP}]
		>=dev-python/mkdocs-material-9.6.1[${PYTHON_USEDEP}]
		>=dev-python/mkdocs-redirects-1.2.1[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.3.1[${PYTHON_USEDEP}]
		>=dev-python/typer-0.12.5[${PYTHON_USEDEP}]
		>=media-gfx/cairosvg-2.7.1[${PYTHON_USEDEP}]
		>=virtual/pillow-11.1.0[${PYTHON_USEDEP}]
	)
	test? (
		(
			>=dev-python/passlib-1.7.2[${PYTHON_USEDEP},bcrypt(+)]
			dev-python/bcrypt[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/anyio-3.2.1[${PYTHON_USEDEP},trio(+)]
			>=dev-python/trio-0.26.1[${PYTHON_USEDEP}]
		)
		>=dev-python/coverage-6.5.0[${PYTHON_USEDEP},toml(+)]
		>=dev-python/dirty-equals-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/flask-1.1.2[${PYTHON_USEDEP}]
		>=dev-python/inline-snapshot-0.19.3[${PYTHON_USEDEP}]
		>=dev-python/mypy-1.8.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.1.3[${PYTHON_USEDEP}]
		>=dev-python/pyjwt-2.8.0[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.3.1[${PYTHON_USEDEP}]
		>=dev-python/sqlmodel-0.0.23[${PYTHON_USEDEP}]
		>=dev-python/types-ujson-5.10.0.20240515[${PYTHON_USEDEP}]
		>=dev-python/types-orjson-3.6.2[${PYTHON_USEDEP}]
		doc? (
			>=dev-python/httpx-0.23.0[${PYTHON_USEDEP}]
			>=dev-util/ruff-0.9.4
		)
	)
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
