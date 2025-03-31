# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# editor
# pre-commit-hooks

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-${PV}"
	EGIT_REPO_URI="https://github.com/magmax/python-inquirer.git"
	FALLBACK_COMMIT="a2479ecfc31b074ec1b43faa15f7fc7960a42f6b" # Jun 14, 2024
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm64"
	SRC_URI="
mirror://pypi/${PN:0:1}/${PN}/${PN}-${PV}.tar.gz
	"
fi
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="Collection of common interactive command line user interfaces, based on Inquirer.js"
HOMEPAGE="
	https://github.com/magmax/python-inquirer
	https://pypi.org/project/inquirer
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev doc test"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/poetry-core-1.0.0[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	dev? (
		$(python_gen_any_dep '
			>=dev-python/pre-commit-hooks-4.3.0[${PYTHON_SINGLE_USEDEP}]
			>=dev-vcs/pre-commit-2.17.0[${PYTHON_SINGLE_USEDEP}]
		')
		>=dev-python/bandit-1.7.4[${PYTHON_USEDEP}]
		>=dev-python/flake8-6.1.0[${PYTHON_USEDEP}]
		>=dev-python/flake8-docstrings-1.6.0[${PYTHON_USEDEP}]
		>=dev-python/furo-2022.9.29[${PYTHON_USEDEP}]
		>=dev-python/isort-5.10.1[${PYTHON_USEDEP}]
		>=dev-python/pexpect-4.8.0[${PYTHON_USEDEP}]
		>=dev-python/pyupgrade-2.31.1[${PYTHON_USEDEP}]
		>=dev-python/safety-2.3.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-5.3.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-autobuild-2021.3.14[${PYTHON_USEDEP}]

		dev-python/black[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]

		dev-python/coverage[${PYTHON_USEDEP}]

		>=dev-python/blessed-1.19.0
		>=dev-python/editor-1.6.0
		>=dev-python/readchar-3.0.6
	)
	doc? (
		>=dev-python/furo-2024.1.29[${PYTHON_USEDEP}]
		>=dev-python/myst_parser-3.0.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-7.2.5[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/pytest
	)
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "version = \"3.2.5\"" "${S}/pyproject.toml" \
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
