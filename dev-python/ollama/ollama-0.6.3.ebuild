# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{11..14} )

inherit pypi secure-version secure-version-python distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/ollama/ollama-python.git"
	FALLBACK_COMMIT="8785556559ec1d045d27a1ba9d9cc7330c3d3cb1"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-python-${PV}"
	SRC_URI="
https://github.com/ollama/ollama-python/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Ollama Python library"
HOMEPAGE="
	https://ollama.com
	https://github.com/ollama/ollama-python
	https://pypi.org/project/ollama
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # Untested
SLOT="0"
IUSE+=" dev"
RDEPEND+="
	$(secure-version_gen_python_depends)
	>=dev-python/anyio-4.5.2[${PYTHON_USEDEP}]
	>=dev-python/certifi-${PYTHON_CERTIFI_PV}[${PYTHON_USEDEP}]
	>=dev-python/h11-0.14.0[${PYTHON_USEDEP}]
	>=dev-python/httpcore-1.0.7[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.28.1[${PYTHON_USEDEP}]
	>=dev-python/idna-3.10[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.10.6[${PYTHON_USEDEP}]
	>=dev-python/sniffio-1.3.1[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.12.2[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	dev-python/hatchling[${PYTHON_USEDEP}]
	dev? (
		>=dev-python/pytest-8.3.4[${PYTHON_USEDEP}]
		>=dev-python/pytest-anyio-0.24.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-5.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-httpserver-1.1.0[${PYTHON_USEDEP}]
		>=dev-util/ruff-0.9.1
	)
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
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
