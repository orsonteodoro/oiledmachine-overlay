# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )
MY_PN="${PN/-/_}"

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/nexB/rust-inspector.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${PV}"
	SRC_URI="
mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz
	"
fi

DESCRIPTION="A scancode plugin to extract symbols and dependencies found in Rust binaries"
HOMEPAGE="
	https://github.com/nexB/rust-inspector
	https://pypi.org/project/rust-inspector
"
LICENSE="
	Apache-2.0
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev doc test"
RDEPEND+="
	>=dev-python/lief-0.15.1[${PYTHON_USEDEP}]
	>=dev-python/symbolic-10.2.1[${PYTHON_USEDEP}]
	dev-python/commoncode[${PYTHON_USEDEP}]
	dev-python/plugincode[${PYTHON_USEDEP}]
	dev-python/typecode[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-50[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-6[${PYTHON_USEDEP},toml]
	dev-python/wheel[${PYTHON_USEDEP}]

	dev? (
		>=dev-util/scancode-toolkit-32.3.0[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/doc8-0.11.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-5.0.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-rtd-theme-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-reredirects-0.1.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-rtd-dark-mode-1.3.0[${PYTHON_USEDEP}]
		dev-python/sphinx-autobuild[${PYTHON_USEDEP}]
		dev-python/sphinx-copybutton[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pytest-6[${PYTHON_USEDEP}]
		!=dev-python/pytest-7.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-2[${PYTHON_USEDEP}]
		>=dev-python/aboutcode-toolkit-7.0.2[${PYTHON_USEDEP}]
		>=dev-python/pycodestyle-2.8.0[${PYTHON_USEDEP}]
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/isort[${PYTHON_USEDEP}]
		dev-python/twine[${PYTHON_USEDEP}]
		dev-util/scancode-toolkit[${PYTHON_USEDEP}]
	)
"
DOCS=( "AUTHORS.rst" "CHANGELOG.rst" "README.rst" )

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
	dodoc "apache-2.0.LICENSE" "NOTICE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
