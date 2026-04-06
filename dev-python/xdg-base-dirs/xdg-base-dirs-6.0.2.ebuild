# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/srstevenson/xdg-base-dirs.git"
	FALLBACK_COMMIT="8b68e200d9be0e58eef205ac8f63e35fed878a43" # Oct 10, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/srstevenson/xdg-base-dirs/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Variables defined by the XDG Base Directory Specification"
HOMEPAGE="
	https://github.com/srstevenson/xdg-base-dirs
	https://pypi.org/project/xdg-base-dirs
"
LICENSE="
	ISC
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/poetry-core-1.0.0[${PYTHON_USEDEP}]
	dev? (
		>=dev-python/mypy-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/poethepoet-0.22.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.2.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-4.0.0[${PYTHON_USEDEP}]
		>=dev-util/ruff-0.1.6
	)

"
DOCS=( "README.md" )

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
