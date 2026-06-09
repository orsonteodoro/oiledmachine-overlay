# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{10..14} )

inherit distutils-r1 pypi
inherit cro

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/ninoseki/uv-dynamic-versioning.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/ninoseki/uv-dynamic-versioning/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Dynamic versioning based on VCS tags for uv/hatch project"
HOMEPAGE="
	https://github.com/ninoseki/uv-dynamic-versioning
	https://pypi.org/project/uv-dynamic-versioning
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" dev"
RDEPEND+="
	$(cro dev-python/dunamai 1.26 '[${PYTHON_USEDEP}]')
	$(cro dev-python/hatchling 1.26 '[${PYTHON_USEDEP}]')
	$(cro dev-python/jinja2 3.0 '[${PYTHON_USEDEP}]')
	$(cro dev-python/tomlkit 0.13 '[${PYTHON_USEDEP}]')
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		$(cro dev-python/gitpython 3.1.46 '[${PYTHON_USEDEP}]')
		$(cro dev-vcs/pre-commit 4.5.1 '[${PYTHON_USEDEP}]')
		$(cro dev-python/pytest-pretty 1.3.0 '[${PYTHON_USEDEP}]')
		$(cro dev-python/pytest-randomly 4.0.1 '[${PYTHON_USEDEP}]')
		$(cro dev-python/pytest 9.0.2 '[${PYTHON_USEDEP}]')
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
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
