# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# In the pyproject.toml it says "Pre-Alpha" not beta.  Typically b means beta.

if [[ "${PV}" =~ "_p" ]] ; then
	MY_PV="$(ver_cut 1-3 ${PV})$(ver_cut 4 ${PV})$(ver_cut 6 ${PV})"
else
	MY_PV="${PV}"
fi
MY_P="${PN}-${MY_PV}"

DISTUTILS_USE_PEP517="flit"
PYTHON_COMPAT=( "python3_11" ) # Upstream lists only 3.10 ; Still needs test

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/pradyunsg/sphinx-theme-builder.git"
	FALLBACK_COMMIT="0ab51536e250d14b511481e1afaa1fc249000ba4" # Mar 27, 2023
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_P}"
	SRC_URI="
https://github.com/pradyunsg/sphinx-theme-builder/archive/refs/tags/${MY_PV}.tar.gz
	-> ${MY_P}.tar.gz
	"
fi

DESCRIPTION="Clean up the public namespace of your package!"
HOMEPAGE="
	https://github.com/pradyunsg/sphinx-theme-builder
	https://pypi.org/project/sphinx-theme-builder/
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc"
RDEPEND+="
	dev-python/pyproject-metadata[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/nodeenv[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	' python3_10)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/flit-core[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/furo[${PYTHON_USEDEP}]
		dev-python/myst-parser[${PYTHON_USEDEP}]
		dev-python/sphinx-copybutton[${PYTHON_USEDEP}]
		dev-python/sphinx-inline-tabs[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = \"0.2.0dev2\"" "${S}/sphinx_theme_builder/__init__.py" \
			|| die "QA:  Bump version"
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
