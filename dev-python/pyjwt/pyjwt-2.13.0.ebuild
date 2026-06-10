# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..14} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/jpadilla/pyjwt.git"
	FALLBACK_COMMIT="7144e4534c34810f4525dc4578a32addd8212cff" # May 21, 2026
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/jpadilla/pyjwt/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="JSON Web Token implementation in Python"
HOMEPAGE="
	https://github.com/jpadilla/pyjwt
	https://pypi.org/project/PyJWT
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" crypto dev doc test"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/typing-extensions-4.0[${PYTHON_USEDEP}]
	' python3_10)
	crypto? (
		>=dev-python/cryptography-3.4.0[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-77.0.3[${PYTHON_USEDEP}]
	dev? (
		~dev-python/coverage-7.10.7[${PYTHON_USEDEP},toml(+)]
		>=dev-python/cryptography-3.4.0[${PYTHON_USEDEP}]
		$(python_gen_any_dep '
			dev-vcs/pre-commit[${PYTHON_SINGLE_USEDEP}]
		')

		>=dev-python/pytest-8.4.2[${PYTHON_USEDEP}]
		<dev-python/pytest-9.0.0[${PYTHON_USEDEP}]

		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		dev-python/zope-interface[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		dev-python/zope-interface[${PYTHON_USEDEP}]
	)
	test? (
		~dev-python/coverage-7.10.7[${PYTHON_USEDEP},toml(+)]
		>=dev-python/pytest-8.4.2[${PYTHON_USEDEP}]
		<dev-python/pytest-9.0.0[${PYTHON_USEDEP}]
	)
"
DOCS=( "CHANGELOG.rst" "README.rst" )

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

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
