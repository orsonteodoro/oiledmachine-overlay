# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="generative-ai-python"

DISTUTILS_USE_PEP517="setuptools"
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1

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
