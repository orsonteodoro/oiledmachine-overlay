# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# cerebras_cloud_sdk
# cohere
# google-cloud-aiplatform
# groq
# mistralai
# pydantic_extra_types
# trafilatura

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/instructor-ai/instructor/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Structured outputs for LLMs"
HOMEPAGE="
	https://github.com/instructor-ai/instructor
	https://pypi.org/project/instructor
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
anthropic cerebras_cloud_sdk cohere diskcache doc examples fastapi fireworks-ai
google-cloud-aiplatform google-generativeai groq jsonref litellm mistralai
pandas pydantic_extra_types redis tabulate test-docs vertexai xmltodict
"
REQUIRED_USE="
	anthropic? (
		xmltodict
	)
	google-generativeai? (
		jsonref
	)
	test-docs? (
		anthropic
		cerebras_cloud_sdk
		cohere
		diskcache
		fireworks-ai
		groq
		mistralai
		pandas
		redis
		fastapi
		litellm
		pydantic_extra_types
		tabulate
		xmltodict
	)
	vertexai? (
		google-cloud-aiplatform
		jsonref
	)
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/openai-1.45.0[${PYTHON_USEDEP}]
		>=dev-python/pydantic-2.8.0[${PYTHON_USEDEP}]
		>=dev-python/docstring-parser-0.16[${PYTHON_USEDEP}]
		>=dev-python/typer-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/rich-13.7.0[${PYTHON_USEDEP}]
		>=dev-python/aiohttp-3.9.1[${PYTHON_USEDEP}]
		>=dev-python/tenacity-9.0.0[${PYTHON_USEDEP}]
		>=dev-python/pydantic-core-2.18.0[${PYTHON_USEDEP}]
		>=dev-python/jiter-0.5.0[${PYTHON_USEDEP}]
		>=dev-python/jinja2-3.1.4[${PYTHON_USEDEP}]
		anthropic? (
			>=dev-python/anthropic-0.34.0[${PYTHON_USEDEP}]
		)
		cerebras_cloud_sdk? (
			>=dev-python/cerebras_cloud_sdk-1.5.0[${PYTHON_USEDEP}]
		)
		cohere? (
			>=dev-python/cohere-5.1.8[${PYTHON_USEDEP}]
		)
		diskcache? (
			>=dev-python/diskcache-5.6.3[${PYTHON_USEDEP}]
		)
		examples? (
			>=dev-python/openai-1.1.0[${PYTHON_USEDEP}]
			>=dev-python/pyright-1.1.360[${PYTHON_USEDEP}]
			>=dev-util/ruff-0.1.7
			dev-python/pydantic[${PYTHON_USEDEP}]
			dev-python/docstring-parser[${PYTHON_USEDEP}]
			dev-python/rich[${PYTHON_USEDEP}]
			dev-python/aiohttp[${PYTHON_USEDEP}]
			dev-python/typer[${PYTHON_USEDEP}]
			dev-python/cohere[${PYTHON_USEDEP}]
			dev-python/trafilatura[${PYTHON_USEDEP}]
		)
		fastapi? (
			>=dev-python/fastapi-0.109.2[${PYTHON_USEDEP}]
		)
		fireworks-ai? (
			>=dev-python/fireworks-ai-0.15.4[${PYTHON_USEDEP}]
		)
		google-cloud-aiplatform? (
			>=dev-python/google-cloud-aiplatform-1.53.0[${PYTHON_USEDEP}]
		)
		google-generativeai? (
			>=dev-python/google-generativeai-0.8.2[${PYTHON_USEDEP}]
		)
		groq? (
			>=dev-python/groq-0.4.2[${PYTHON_USEDEP}]
		)
		jsonref? (
			>=dev-python/jsonref-1.1.0[${PYTHON_USEDEP}]
		)
		litellm? (
			>=dev-python/litellm-1.35.31[${PYTHON_USEDEP}]
		)
		mistralai? (
			>=dev-python/mistralai-1.0.3[${PYTHON_USEDEP}]
		)
		pandas? (
			>=dev-python/pandas-2.2.0[${PYTHON_USEDEP}]
		)
		pydantic_extra_types? (
			>=dev-python/pydantic_extra_types-2.6.0[${PYTHON_USEDEP}]
		)
		redis? (
			>=dev-python/redis-5.0.1[${PYTHON_USEDEP}]
		)
		tabulate? (
			>=dev-python/tabulate-0.9.0[${PYTHON_USEDEP}]
		)
		test-docs? (
			>=dev-python/graphviz-0.20.3[${PYTHON_USEDEP}]
			>=dev-python/phonenumbers-8.13.33[${PYTHON_USEDEP}]
			>=dev-python/sqlmodel-0.0.22[${PYTHON_USEDEP}]
			>=dev-python/trafilatura-1.12.2[${PYTHON_USEDEP}]
			>=dev-python/pydub-0.25.1[${PYTHON_USEDEP}]
		)
		xmltodict? (
			>=dev-python/xmltodict-0.13.0[${PYTHON_USEDEP}]
		)
	')
	examples? (
		>=dev-vcs/pre-commit-3.5.0[${PYTHON_SINGLE_USEDEP}]
		sci-ml/datasets[${PYTHON_SINGLE_USEDEP}]
	)
	test-docs? (
		>=sci-ml/datasets-3.0.1[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/poetry-core[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		doc? (
			dev-python/mkdocs[${PYTHON_USEDEP}]
			dev-python/mkdocs-minify-plugin[${PYTHON_USEDEP}]
			dev-python/mkdocs-jupyter[${PYTHON_USEDEP}]
			dev-python/mkdocs-redirects[${PYTHON_USEDEP}]
			dev-python/mkdocstrings[${PYTHON_USEDEP}]
			dev-python/mkdocstrings-python[${PYTHON_USEDEP}]
			media-gfx/cairosvg[${PYTHON_USEDEP}]
			virtual/pillow[${PYTHON_USEDEP}]
		)
	')
"
DOCS=( "README.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
