# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..14} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/googleapis/python-genai.git"
	FALLBACK_COMMIT="5d0dff81c26c041e2f30936421e5e6ed9c3a8412" # May 28, 2026
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/googleapis/python-genai/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="GenAI Python SDK"
HOMEPAGE="
	https://github.com/googleapis/python-genai
	https://googleapis.github.io/python-genai/
	https://pypi.org/project/google-genai
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" aiohttp local-tokenizer mypy pyopenssl"
REQUIREMENTS_TXT="
	>=dev-python/absl-py-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/annotated-types-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/anyio-4.8.0[${PYTHON_USEDEP}]
	>=dev-python/cachetools-5.5.0[${PYTHON_USEDEP}]
	>=dev-python/certifi-2024.8.30[${PYTHON_USEDEP}]
	>=dev-python/charset-normalizer-3.4.0[${PYTHON_USEDEP}]
	>=dev-python/coverage-7.6.9[${PYTHON_USEDEP}]
	>=dev-python/distro-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.28.1[${PYTHON_USEDEP}]
	>=dev-python/google-auth-2.47.0[${PYTHON_USEDEP}]
	>=dev-python/idna-3.10[${PYTHON_USEDEP}]
	>=dev-python/iniconfig-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-24.2[${PYTHON_USEDEP}]
	>=dev-python/pluggy-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/py-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-modules-0.4.1[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.12.0[${PYTHON_USEDEP}]
	>=dev-python/pydantic-core-2.41.1[${PYTHON_USEDEP}]
	>=dev-python/pytest-8.3.4[${PYTHON_USEDEP}]
	>=dev-python/pytest-asyncio-0.25.0[${PYTHON_USEDEP}]
	>=dev-python/pytest-cov-6.0.0[${PYTHON_USEDEP}]
	>=dev-python/pytest-xdist-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.32.4[${PYTHON_USEDEP}]
	>=dev-python/rsa-4.9[${PYTHON_USEDEP}]
	>=dev-python/tenacity-8.2.3[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.14.1[${PYTHON_USEDEP}]
	>=dev-python/urllib3-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/websockets-16.0[${PYTHON_USEDEP}]
	>=dev-python/mcp-1.14.0[${PYTHON_USEDEP}]
	>=virtual/pillow-11.0.0[${PYTHON_USEDEP}]
	local-tokenizer? (
		>=dev-python/sentencepiece-0.2.0[${PYTHON_USEDEP}]
		dev-python/protobuf[${PYTHON_USEDEP}]
	)
	pyopenssl? (
		>=dev-python/pyopenssl-24.2.1[${PYTHON_USEDEP}]
	)
"
RDEPEND+="
	(
		>=dev-python/anyio-4.8.0[${PYTHON_USEDEP}]
		<dev-python/anyio-5.0.0[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/google-auth-2.48.1[${PYTHON_USEDEP},requests(+)]
		<dev-python/google-auth-3.0.0[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/httpx-0.28.1[${PYTHON_USEDEP}]
		<dev-python/httpx-1.0.0[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/pydantic-2.9.0[${PYTHON_USEDEP}]
		<dev-python/pydantic-3.0.0[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/requests-2.28.1[${PYTHON_USEDEP}]
		<dev-python/requests-3.0.0[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/tenacity-8.2.3[${PYTHON_USEDEP}]
		<dev-python/tenacity-9.2.0[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/websockets-13.0.0[${PYTHON_USEDEP}]
		<dev-python/websockets-17.0[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/typing-extensions-4.14.0[${PYTHON_USEDEP}]
		<dev-python/typing-extensions-5.0.0[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/distro-1.7.0[${PYTHON_USEDEP}]
		<dev-python/distro-2[${PYTHON_USEDEP}]
	)
	dev-python/sniffio[${PYTHON_USEDEP}]
	aiohttp? (
		>=dev-python/aiohttp-3.10.11[${PYTHON_USEDEP}]
		<dev-python/aiohttp-4.0.0[${PYTHON_USEDEP}]
	)
	local-tokenizer? (
		>=dev-python/sentencepiece-0.2.0[${PYTHON_USEDEP}]
		dev-python/protobuf[${PYTHON_USEDEP}]
	)
	pyopenssl? (
		>=dev-python/pyopenssl-24.2.1[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/twine-6.1.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-24.2[${PYTHON_USEDEP}]
	>=dev-python/pkginfo-1.12.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	mypy? (
		${REQUIREMENTS_TXT}
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
