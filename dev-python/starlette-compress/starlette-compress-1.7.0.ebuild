# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{10..14} "pypy3_11" )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/Zaczero/pkgs.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/pkgs-starlette-compress-${PV}/starlette-compress"
	SRC_URI="
https://github.com/Zaczero/pkgs/archive/refs/tags/starlette-compress/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Compression middleware for Starlette - supporting ZStd, Brotli, and GZip"
HOMEPAGE="
	https://github.com/Zaczero/pkgs/tree/starlette-compress/main/starlette-compress
	https://pypi.org/project/starlette-compress
"
LICENSE="
	0BSD
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" dev"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=app-arch/brotli-1.0[${PYTHON_USEDEP}]
	' python3_{10..14})
	$(python_gen_cond_dep '
		>=dev-python/brotlicffi-1.0[${PYTHON_USEDEP}]
	' pypy3_11)
	$(python_gen_cond_dep '
		>=dev-python/zstandard-0.15[${PYTHON_USEDEP}]
	' python3_{10..13})
	dev-python/starlette[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		dev-python/brotlicffi[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/httpx[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/trio[${PYTHON_USEDEP}]
		dev-python/uvloop[${PYTHON_USEDEP}]
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

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
