# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# sphinx-new-tab-link

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/marcelotduarte/cx_Freeze.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN/-/_}-${PV}"
	SRC_URI="
https://github.com/marcelotduarte/cx_Freeze/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Create standalone executables from Python scripts"
HOMEPAGE="
	https://github.com/marcelotduarte/cx_Freeze
	https://pypi.org/project/cx-Freeze
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev doc"
RDEPEND+="
	>=dev-python/filelock-3.12.3[${PYTHON_USEDEP}]
	>=dev-python/packaging-24[${PYTHON_USEDEP}]
	>=dev-python/setuptools-65.6.3[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
	' python3_10)
	dev-python/console[${PYTHON_USEDEP}]
	dev-util/patchelf
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/build-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/cibuildwheel-2.22.0[${PYTHON_USEDEP}]
		>=dev-util/bump-my-version-0.26.1[${PYTHON_USEDEP}]
		>=dev-vcs/pre-commit-3.5.0[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/furo-2024.8.6[${PYTHON_USEDEP}]
		>=dev-python/myst-parser-3.0.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-7.1.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-new-tab-link-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-tabs-3.4.5[${PYTHON_USEDEP}]
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
	dodoc "LICENSE.md"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
