# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The last release was 4 years ago, so live is used.

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="65bab7582ce14c55cdeec2244c65ea23039c9e6f"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/uiri/toml.git"
	IUSE+=" fallback-commit"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	inherit pypi
	SRC_URI="
https://github.com/uiri/toml/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A Python library for TOML"
HOMEPAGE="
	https://github.com/uiri/toml
	https://pypi.org/project/toml
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
test
"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	test? (
		dev-python/codecov[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.rst" )
PATCHES=(
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}
