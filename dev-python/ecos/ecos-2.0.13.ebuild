# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="ecos-python"

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/fchollet/namex.git"
	FALLBACK_COMMIT="0e09150bb86f666d4f0f5b6ce41c4e54b746681f" # Feb 6, 2024
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	ECOS_COMMIT="5d3aa62ef437e41c0314b4a16427d5d06a90b7e6"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${PV}"
	SRC_URI="
https://github.com/embotech/ecos-python/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/embotech/ecos/archive/${ECOS_COMMIT}.tar.gz
	-> ecos-${ECOS_COMMIT:0:7}.tar.gz

	"
fi

DESCRIPTION="A Python interface for the Embedded Conic Solver (ECOS)"
HOMEPAGE="
	https://github.com/embotech/ecos-python
	https://pypi.org/project/ecos
"
LICENSE="
	GPL-3 GPL-3+
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
RDEPEND+="
	>=dev-python/numpy-1.6[${PYTHON_USEDEP}]
	>=dev-python/scipy-0.9[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/numpy-1.6[${PYTHON_USEDEP}]
	dev-python/oldest-supported-numpy[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "version = '2.0.13'," "${S}/setup.py" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
		rm -rf "${S}/ecos"
		mv \
			"${WORKDIR}/ecos-${ECOS_COMMIT}" \
			"${S}/ecos" \
			|| die
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
