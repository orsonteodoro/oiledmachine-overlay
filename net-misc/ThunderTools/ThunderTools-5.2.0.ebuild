# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( "python3_"{10..12} )

inherit cmake python-single-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/rdkcentral/ThunderTools.git"
	FALLBACK_COMMIT="0efdfe97e363892d387ba07b43be07a05512c222" # Mar 19, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-R${PV}"
	SRC_URI="
https://github.com/rdkcentral/ThunderTools/archive/refs/tags/R${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Thunder (aka WPEFramework)"
HOMEPAGE="
	https://github.com/rdkcentral/ThunderTools
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/jsonref[${PYTHON_USEDEP}]
	')
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-build/cmake-3.15
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

src_configure() {
	local mycmakeargs=(
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	docinto "licenses"
	dodoc "COPYING"
	dodoc "LICENSE"
	dodoc "NOTICE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
