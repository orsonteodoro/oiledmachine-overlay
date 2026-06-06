# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/encode/httpx.git"
	FALLBACK_COMMIT="26d48e0634e6ee9cdc0533996db289ce4b430177" # Dec 6, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/encode/httpx/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A next generation HTTP client for Python. 🦋"
HOMEPAGE="
	https://github.com/encode/httpx
	https://pypi.org/project/httpx
"
LICENSE="
	BSD
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
brotli chardet cli doc http2 pypi socks test zstd
"
RDEPEND+="
	dev-python/certifi[${PYTHON_USEDEP}]
	=dev-python/httpcore-1*[${PYTHON_USEDEP}]
	dev-python/httpcore:=
	dev-python/anyio[${PYTHON_USEDEP}]
	dev-python/idna[${PYTHON_USEDEP}]
	brotli? (
		$(python_gen_cond_dep '
			dev-python/brotli[${PYTHON_USEDEP}]
		' python3_{10..12})
		$(python_gen_cond_dep '
			dev-python/brotlicffi[${PYTHON_USEDEP}]
		' pypy3_11)
	)
	cli? (
		=dev-python/click-8*[${PYTHON_USEDEP}]
		=dev-python/pygments-2*[${PYTHON_USEDEP}]

		>=dev-python/rich-10[${PYTHON_USEDEP}]
		<dev-python/rich-14[${PYTHON_USEDEP}]
	)
	http2? (
		>=dev-python/h2-3[${PYTHON_USEDEP}]
		<dev-python/h2-5[${PYTHON_USEDEP}]
	)
	socks? (
		=dev-python/socksio-1*[${PYTHON_USEDEP}]
	)
	zstd? (
		>=dev-python/zstandard-0.18.0[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/hatchling[${PYTHON_USEDEP}]
	dev-python/hatch-fancy-pypi-readme[${PYTHON_USEDEP}]
	doc? (
		~dev-python/mkdocs-1.6.1[${PYTHON_USEDEP}]
		~dev-python/mkautodoc-0.2.0[${PYTHON_USEDEP}]
		~dev-python/mkdocs-material-9.5.47[${PYTHON_USEDEP}]
	)
	pypi? (
		~dev-python/build-1.2.2_p1[${PYTHON_USEDEP}]
		~dev-python/twine-6.0.1[${PYTHON_USEDEP}]
	)
	test? (
		chardet? (
			~dev-python/chardet-5.2.0[${PYTHON_USEDEP}]
		)
		~dev-python/coverage-7.6.1[${PYTHON_USEDEP},toml(+)]
		~dev-python/cryptography-44.0.0[${PYTHON_USEDEP}]
		~dev-python/mypy-1.13.0[${PYTHON_USEDEP}]
		~dev-python/pytest-8.3.4[${PYTHON_USEDEP}]
		~dev-python/ruff-0.8.1[${PYTHON_USEDEP}]
		~dev-python/trio-0.27.0[${PYTHON_USEDEP}]
		~dev-python/trio-typing-0.10.0[${PYTHON_USEDEP}]
		~dev-python/trustme-1.2.0[${PYTHON_USEDEP}]
		~dev-python/uvicorn-0.32.1[${PYTHON_USEDEP}]
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

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
