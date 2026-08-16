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
PYTHON_COMPAT=( "python3_"{10..14} )

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
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" all dev doc doc-tests github-actions standard standard-no-fastapi-cloud-cli test translations"
REQUIRED_USE="
	dev? (
		doc
		test
		translations
	)
	test? (
		doc-tests
	)
"
# Distro is missing standard USE flag for uvicorn, assuming oiledmachine-overlay
# ebuild.
UVICORN_RDEPEND="
	>=dev-python/uvicorn-0.12.0[${PYTHON_USEDEP},standard]
"
FASTAPI_CLI_RDEPEND="
	(
		${UVICORN_RDEPEND}
		>=dev-python/fastapi-cli-0.0.32[${PYTHON_USEDEP},standard(+)]
	)
"
RDEPEND+="
	>=dev-python/annotated-doc-0.0.2[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.9.0[${PYTHON_USEDEP}]
	>=dev-python/starlette-0.46.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.8.0[${PYTHON_USEDEP}]
	>=dev-python/typing-inspection-0.4.2[${PYTHON_USEDEP}]
	all? (
		${FASTAPI_CLI_RDEPEND}
		${UVICORN_RDEPEND}
		>=dev-python/email-validator-2.0.0[${PYTHON_USEDEP}]

		>=dev-python/httpx-0.23.0[${PYTHON_USEDEP}]
		<dev-python/httpx-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/itsdangerous-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/jinja2-3.1.5[${PYTHON_USEDEP}]
		>=dev-python/pydantic-extra-types-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/pydantic-settings-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/python-multipart-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.3.1[${PYTHON_USEDEP}]
	)
	github-actions? (
		>=dev-python/httpx-0.27.0[${PYTHON_USEDEP}]
		<dev-python/httpx-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/pydantic-2.9.0[${PYTHON_USEDEP}]
		<dev-python/pydantic-3.0.0[${PYTHON_USEDEP}]

		>=dev-python/pydantic-settings-2.1.0[${PYTHON_USEDEP}]
		<dev-python/pydantic-settings-3.0.0[${PYTHON_USEDEP}]

		>=dev-python/pygithub-2.3.0[${PYTHON_USEDEP}]
		<dev-python/pygithub-3.0.0[${PYTHON_USEDEP}]

		>=dev-python/pyyaml-5.3.1[${PYTHON_USEDEP}]
		<dev-python/pyyaml-7.0.0[${PYTHON_USEDEP}]

		>=dev-python/smokeshow-0.5.0[${PYTHON_USEDEP}]
	)
	standard-no-fastapi-cloud-cli? (
		${UVICORN_RDEPEND}
		>=dev-python/fastapi-cli-0.0.32[${PYTHON_USEDEP},standard-no-fastapi-cloud-cli]

		>=dev-python/httpx-0.23.0[${PYTHON_USEDEP}]
		<dev-python/httpx-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/jinja2-3.1.5[${PYTHON_USEDEP}]
		>=dev-python/python-multipart-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/email-validator-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/pydantic-settings-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/pydantic-extra-types-2.0.0[${PYTHON_USEDEP}]
	)
	standard? (
		${FASTAPI_CLI_RDEPEND}
		${UVICORN_RDEPEND}
		>=dev-python/email-validator-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/fastar-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/httpx-0.23.0[${PYTHON_USEDEP}]
		>=dev-python/jinja2-3.1.5[${PYTHON_USEDEP}]
		>=dev-python/python-multipart-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/pydantic-extra-types-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/pydantic-settings-2.0.0[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/playwright-bin-1.57.0[${PYTHON_USEDEP}]
		>=dev-python/prek-0.2.22[${PYTHON_USEDEP}]
		>=dev-python/zizmor-1.23.1[${PYTHON_USEDEP}]
	)
	doc? (
		(
			>=dev-python/mkdocstrings-1.0.3[${PYTHON_USEDEP},python(+)]
			>=dev-python/mkdocstrings-python-1.16.2[${PYTHON_USEDEP}]
			>=dev-python/mkdocs-material-9.5[${PYTHON_USEDEP}]
			>=dev-python/mkdocs-redirects-1.2.1[${PYTHON_USEDEP}]
		)
		>=dev-python/black-25.1.0[${PYTHON_USEDEP}]
		>=dev-python/griffe-typingdoc-0.3.0[${PYTHON_USEDEP}]
		>=dev-python/griffe-warnings-deprecated-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/jieba-0.42.1[${PYTHON_USEDEP}]
		>=dev-python/markdown-include-variants-0.0.8[${PYTHON_USEDEP}]

		>=dev-python/mdx-include-1.4.1[${PYTHON_USEDEP}]
		<dev-python/mdx-include-2.0.0[${PYTHON_USEDEP}]

		>=dev-python/python-slugify-8.0.4[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.3.1[${PYTHON_USEDEP}]
		<dev-python/pyyaml-7.0.0[${PYTHON_USEDEP}]

		>=dev-python/typer-0.21.1[${PYTHON_USEDEP}]
		>=dev-python/zensical-0.0.42[${PYTHON_USEDEP}]
		>=media-gfx/cairosvg-2.8.2[${PYTHON_USEDEP}]
		>=virtual/pillow-11.3.0[${PYTHON_USEDEP}]
	)
	test? (
		(
			>=dev-python/anyio-3.2.1[${PYTHON_USEDEP},trio(+)]
			<dev-python/anyio-5.0.0[${PYTHON_USEDEP},trio(+)]

			>=dev-python/trio-0.26.1[${PYTHON_USEDEP}]
		)
		>=dev-python/coverage-7.13[${PYTHON_USEDEP},toml(+)]
		<dev-python/coverage-8.0[${PYTHON_USEDEP},toml(+)]

		>=dev-python/dirty-equals-0.9.0[${PYTHON_USEDEP}]

		>=dev-python/flask-3.0.0[${PYTHON_USEDEP}]
		<dev-python/flask-4.0.0[${PYTHON_USEDEP}]

		>=dev-python/inline-snapshot-0.21.1[${PYTHON_USEDEP}]
		>=dev-python/mypy-1.14.1[${PYTHON_USEDEP}]
		>=dev-python/pwdlib-0.2.1[${PYTHON_USEDEP},argon2]
		>=dev-python/pytest-9.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-codspeed-4.3.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-sugar-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-pytest-timeout-2.4.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-2.5.0[${PYTHON_USEDEP},psutil]
		>=dev-python/pyjwt-2.9.0[${PYTHON_USEDEP}]

		>=dev-python/pyyaml-5.3.1[${PYTHON_USEDEP}]
		<dev-python/pyyaml-7.0.0[${PYTHON_USEDEP}]

		>=dev-python/sqlmodel-0.0.23[${PYTHON_USEDEP}]

		>=dev-python/strawberry-graphql-0.200.0[${PYTHON_USEDEP}]
		<dev-python/strawberry-graphql-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/ty-0.0.25[${PYTHON_USEDEP}]
		>=dev-python/typer-0.24.1[${PYTHON_USEDEP}]

		>=dev-python/a2wsgi-1.9.0[${PYTHON_USEDEP}]
		<=dev-python/a2wsgi-2.0.0[${PYTHON_USEDEP}]
	)
	doc-tests? (
		>=dev-python/httpx-0.23.0[${PYTHON_USEDEP}]
		<dev-python/httpx-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/httpx2-2.0.0[${PYTHON_USEDEP}]
		>=dev-util/ruff-0.14.14
	)
	translations? (
		>=dev-python/gitpython-3.1.46[${PYTHON_USEDEP}]
		>=dev-python/pydantic-ai-0.4.10[${PYTHON_USEDEP}]
		>=dev-python/pygithub-2.8.1[${PYTHON_USEDEP}]
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
