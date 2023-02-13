# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Cellular Traces Collected in New York City for different scenarios"
HOMEPAGE="
https://github.com/Soheil-ab/Cellular-Traces-2018
"
LICENSE="all-rights-reserved" # No explicit license
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" fallback-commit"
SRC_URI=""
S="${WORKDIR}/${P}"
RESTRICT="mirror"

src_unpack() {
	EGIT_REPO_URI="https://github.com/Soheil-ab/Cellular-Traces-NYC.git"
	EGIT_BRANCH="master"
	if use fallback-commit ; then
		EGIT_COMMIT="ac6717b5f113bf899344e91ffc57e472daf29954"
	else
		EGIT_COMMIT="HEAD"
	fi
	git-r3_fetch
	git-r3_checkout
}

src_configure() { :; }
src_compile() { :; }
src_install() {
	insinto /usr/share/${PN}
	doins -r *
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
