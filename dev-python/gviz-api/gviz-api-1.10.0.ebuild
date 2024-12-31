# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # Upstream listed up to 3.10

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/google/google-visualization-python.git"
	FALLBACK_COMMIT="ba6fddfb24846f3d0c9d8b33cb3c9f777792ed3d" # Oct 13, 2021
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="ba6fddfb24846f3d0c9d8b33cb3c9f777792ed3d"
	S="${WORKDIR}/google-visualization-python-${EGIT_COMMIT}"
	SRC_URI="
https://github.com/google/google-visualization-python/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Python API for Google Visualization"
HOMEPAGE="
	https://github.com/google/google-visualization-python
	https://pypi.org/project/gviz-api
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"
DOCS=( "README.rst" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "version=\"1.10.0\"," "${S}/setup.py" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "COPYRIGHT"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
