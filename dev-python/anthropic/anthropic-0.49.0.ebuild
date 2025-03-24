# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( "python3_"{11..12} )
DISTUTILS_USE_PEP517="hatchling"

inherit distutils-r1 pypi

KEYWORDS="amd64 arm arm64 x86"

DESCRIPTION="The official Python library for the anthropic API"
HOMEPAGE="
	https://github.com/anthropics/anthropic-sdk-python
	https://pypi.org/project/anthropic/
"
LICENSE="MIT"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0"
IUSE="bedrock dev test vertex"
RDEPEND="
	>=dev-python/anyio-3.5.0[${PYTHON_USEDEP}]
	>=dev-python/distro-1.7.0[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.23.0[${PYTHON_USEDEP}]
	>=dev-python/jiter-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/pydantic-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/sniffio-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.10[${PYTHON_USEDEP}]
	bedrock? (
		>=dev-python/boto3-1.28.57[${PYTHON_USEDEP}]
		>=dev-python/botocore-1.31.57[${PYTHON_USEDEP}]
	)
	vertex? (
		>=dev-python/google-auth-2[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	dev? (
		>=dev-python/boto3-stubs-1[${PYTHON_USEDEP}]
		>=dev-python/dirty-equals-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/importlib-metadata-6.7.0[${PYTHON_USEDEP}]
		>=dev-python/mypy-1.14.1[${PYTHON_USEDEP}]
		>=dev-python/nest-asyncio-1.6.0[${PYTHON_USEDEP}]
		>=dev-python/nox-2023.4.22[${PYTHON_USEDEP}]
		>=dev-python/pyright-1.1.359[${PYTHON_USEDEP}]
		>=dev-python/pytest-8.3.3[${PYTHON_USEDEP}]
		>=dev-python/pytest-asyncio-0.24.0[${PYTHON_USEDEP}]
		>=dev-python/respx-0.22.0[${PYTHON_USEDEP}]
		>=dev-python/rich-13.7.1[${PYTHON_USEDEP}]
		>=dev-python/time-machine-2.9.0[${PYTHON_USEDEP}]
		>=dev-util/ruff-0.9.4[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

distutils_enable_tests "pytest"
