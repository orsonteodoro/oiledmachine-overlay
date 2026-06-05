# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # Open WebUI requests 3.12 but chromadb needs importlib-resources

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/python/importlib_resources.git"
	FALLBACK_COMMIT="78c697d65ae8517bd64d40c62d2085902d82b237" # Apr 11, 2026
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/python/importlib_resources/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Backport of the importlib.resources module"
HOMEPAGE="
	https://github.com/python/importlib_resources
	https://pypi.org/project/importlib-resources
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" check cover doc enabler test type"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/zipp-3.1.0[${PYTHON_USEDEP}]
	' python3_9)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	check? (
		>=dev-python/pytest-checkdocs-2.14[${PYTHON_USEDEP}]
		>=dev-python/pytest-ruff-0.2.1[${PYTHON_USEDEP}]
	)
	cover? (
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/sphinx-3.5[${PYTHON_USEDEP}]
		>=dev-python/jaraco-packaging-9.3[${PYTHON_USEDEP}]
		>=dev-python/rst-linker-1.9[${PYTHON_USEDEP}]
		dev-python/furo[${PYTHON_USEDEP}]
		dev-python/sphinx-lint[${PYTHON_USEDEP}]

		>=dev-python/jaraco-tidelift-1.4[${PYTHON_USEDEP}]
	)
	enabler? (
		>=dev-python/pytest-enabler-3.4[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pytest-6[${PYTHON_USEDEP}]
		!=dev-python/pytest-8.1*[${PYTHON_USEDEP}]

		>=dev-python/zipp-3.17[${PYTHON_USEDEP}]
		>=dev-python/jaraco-test-5.4[${PYTHON_USEDEP}]
	)
	type? (
		$(python_gen_cond_dep '
			>=dev-python/pytest-mypy-1.0.1[${PYTHON_USEDEP}]
		' python3_{10..12})
	)
"
DOCS=( "NEWS.rst" "README.rst" )

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
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
