# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN}-api"

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{8..11} )

inherit distutils-r1

EGIT_COMMIT="9eefac4a2ef94b71c407dfd5d997dad451547181"
KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"
SRC_URI="
https://github.com/Kaggle/kaggle-api/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}-gh-${EGIT_COMMIT:0:7}.tar.gz
"
#mirror://pypi/${PN:0:1}/${PN}/${PN}-${PV}.tar.gz

DESCRIPTION="The Official Kaggle API"
HOMEPAGE="https://github.com/Kaggle/kaggle-api"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
RDEPEND+="
	>=dev-python/six-1.10[${PYTHON_USEDEP}]
	>=dev-python/certifi-2023.7.22[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.5.3[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.15.1[${PYTHON_USEDEP}]
	dev-python/bleach[${PYTHON_USEDEP}]
	dev-python/python-slugify[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]

	dev-python/charset-normalizer[${PYTHON_USEDEP}]
	dev-python/idna[${PYTHON_USEDEP}]
	dev-python/text-unidecode[${PYTHON_USEDEP}]
	dev-python/webencodings[${PYTHON_USEDEP}]
"
DEPEND+="
	${DEPEND}
"
BDEPEND+="
	doc? (
		dev-python/alabaster[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"
DOCS=( "CHANGELOG.md" "README.md" )
PATCHES=(
)

src_unpack() {
	unpack ${A}
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
	einstalldocs
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
