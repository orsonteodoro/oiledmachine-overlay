# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..14} ) # Upstream list up to 3.7, but gnome-extra/secrets requires 12-14

inherit distutils-r1 pypi


if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/kitsunix/pyHIBP.git"
	FALLBACK_COMMIT="2e023fc1c589550a8479a3bbf8f93ba99e758deb" # Mar 28, 2021
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/pyHIBP-${PV}"
	SRC_URI="
https://github.com/kitsunix/pyHIBP/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A Python interface to Troy Hunt's 'Have I Been Pwned?' (HIBP) public API"
HOMEPAGE="
	https://gitlab.com/kitsunix/pyHIBP
	https://pypi.org/project/pyhibp
"
LICENSE="
	AGPL-3+
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
RDEPEND+="
	>=dev-python/requests-2.20.0[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		dev-python/check-manifest[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/tox[${PYTHON_USEDEP}]
	)
"
DOCS=( "CHANGELOG.md" "README.md" )

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
