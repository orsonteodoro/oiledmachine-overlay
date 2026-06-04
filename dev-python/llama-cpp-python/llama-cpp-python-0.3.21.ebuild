# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="sensitive-data untrusted-data"

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="scikit-build-core"
PYTHON_COMPAT=( "python3_"{8..13} )

LLAMA_CPP_COMMIT="f53577432541bb9edc1588c4ef45c66bf07e4468"

inherit cflags-hardened dep-prepare distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/abetlen/llama-cpp-python.git"
	FALLBACK_COMMIT="d2bcbac46605f11d382426dd88d67e8b5c124cd7" # Apr 26, 2026
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/abetlen/llama-cpp-python/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/ggml-org/llama.cpp/archive/${LLAMA_CPP_COMMIT}.tar.gz
	-> llama.cpp-${LLAMA_CPP_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="Python bindings for llama.cpp"
HOMEPAGE="
	https://github.com/abetlen/llama-cpp-python
	https://pypi.org/project/llama-cpp-python
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
all dev server test
ebuild_revision_2
"
REQUIRED_USE="
	all? (
		dev
		server
		test
	)
"
RDEPEND+="
	>=dev-python/diskcache-5.6.1[${PYTHON_USEDEP}]
	>=dev-python/jinja2-2.11.3[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.20.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.5.0[${PYTHON_USEDEP}]
	server? (
		(
			>=dev-python/starlette-context-0.3.6[${PYTHON_USEDEP}]
			<dev-python/starlette-context-0.4[${PYTHON_USEDEP}]
		)
		>=dev-python/fastapi-0.100.0[${PYTHON_USEDEP}]
		>=dev-python/pydantic-settings-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
		>=dev-python/sse-starlette-1.6.1[${PYTHON_USEDEP}]
		>=dev-python/uvicorn-0.22.0[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/scikit-build-core-0.9.2[pyproject(+)]
	dev? (
		>=dev-python/httpx-0.24.1[${PYTHON_USEDEP}]
		>=dev-python/mkdocs-1.4.3[${PYTHON_USEDEP}]
		>=dev-python/mkdocstrings-0.22.0[${PYTHON_USEDEP},python(+)]
		>=dev-python/mkdocs-material-9.1.18[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.4.0[${PYTHON_USEDEP}]
		>=dev-python/twine-4.0.2[${PYTHON_USEDEP}]
		>=dev-util/ruff-0.15.7
	)
	test? (
		(
			>=dev-python/starlette-context-0.3.6[${PYTHON_USEDEP}]
			<dev-python/starlette-context-0.4[${PYTHON_USEDEP}]
		)
		>=dev-python/fastapi-0.100.0[${PYTHON_USEDEP}]
		>=dev-python/httpx-0.24.1[${PYTHON_USEDEP}]
		>=dev-python/pydantic-settings-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.4.0[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.10[${PYTHON_USEDEP}]
		>=dev-python/sse-starlette-1.6.1[${PYTHON_USEDEP}]
		>=sci-ml/huggingface-hub-0.23.0[${PYTHON_USEDEP}]
	)
"
DOCS=( "CHANGELOG.md" "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() {
	default
	cflags-hardened_append
}

src_prepare() {
	default
	dep_prepare_mv "${WORKDIR}/llama.cpp-${LLAMA_CPP_COMMIT}" "${S}/vendor/llama.cpp"
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE.md"
	rm -rf "${ED}/usr/lib/"*"/site-packages/"{"lib"*,"bin","include"} || true
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
