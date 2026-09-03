# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{10..14} )

CHKL_TIMESTAMPS=(
	"app-arch/brotli-9999"
)

inherit chkl distutils-r1 secure-version pypi

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="1f1d989bb5744efe8b94f6aefb643b8dee95f71f"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/Zaczero/pkgs.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
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
SLOT="0"
IUSE+=" dev"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=app-arch/brotli-'${BROTLI_PV}':=[${PYTHON_USEDEP}]
	' python3_{10..14})
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
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

python_configure_all() {
	chkl_check_many_timestamps
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
