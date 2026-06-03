# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/fake-useragent/fake-useragent.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/fake-useragent/fake-useragent/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Up-to-date simple useragent faker with real world database"
HOMEPAGE="
	https://github.com/fake-useragent/fake-useragent
	https://pypi.org/project/fake-useragent
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" converter"
RDEPEND+="
	>=dev-python/attrs-25.3.0[${PYTHON_USEDEP}]
	>=dev-python/black-25.1.0[${PYTHON_USEDEP}]
	>=dev-python/build-1.2.2_p1[${PYTHON_USEDEP}]
	>=dev-python/cachetools-5.5.0[${PYTHON_USEDEP}]
	>=dev-python/chardet-5.2.0[${PYTHON_USEDEP}]
	>=dev-python/click-8.1.8[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.4.6[${PYTHON_USEDEP}]
	>=dev-python/coverage-7.8.0[${PYTHON_USEDEP}]
	>=dev-python/distlib-0.3.9[${PYTHON_USEDEP}]
	>=dev-python/exceptiongroup-1.2.2[${PYTHON_USEDEP}]
	>=dev-python/fastjsonschema-2.21.1[${PYTHON_USEDEP}]
	>=dev-python/filelock-3.17.0[${PYTHON_USEDEP}]
	>=dev-python/importlib-resources-6.5.2[${PYTHON_USEDEP}]
	>=dev-python/iniconfig-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/isort-5.13.2[${PYTHON_USEDEP}]
	>=dev-python/mypy-extensions-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-24.2[${PYTHON_USEDEP}]
	>=dev-python/pathspec-0.12.1[${PYTHON_USEDEP}]
	>=dev-python/pep517-0.13.1[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-4.3.6[${PYTHON_USEDEP}]
	>=dev-python/pluggy-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/py-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-3.2.3[${PYTHON_USEDEP}]
	>=dev-python/pyproject-api-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/pyproject-hooks-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/pytest-8.3.5[${PYTHON_USEDEP}]
	>=dev-python/pytest-cov-6.0.0[${PYTHON_USEDEP}]
	>=dev-python/ruff-0.11.4[${PYTHON_USEDEP}]
	>=dev-python/six-1.17.0[${PYTHON_USEDEP}]
	>=dev-python/tomli-2.2.1[${PYTHON_USEDEP}]
	>=dev-python/tox-4.14.1[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.13.2[${PYTHON_USEDEP}]
	>=dev-python/validate-pyproject-0.24.1[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-20.25.1[${PYTHON_USEDEP}]
	>=dev-python/zipp-3.21.0[${PYTHON_USEDEP}]
	converter? (
		>=dev-python/ua-parser-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/ua-parser-builtins-0.18.0_p1[${PYTHON_USEDEP}]
		>=dev-python/ua-parser-rs-0.1.2[${PYTHON_USEDEP}]
		>=dev-python/requests-2.32.3[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-77.0[${PYTHON_USEDEP}]
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
	dodoc "AUTHORS"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
