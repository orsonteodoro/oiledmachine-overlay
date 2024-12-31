# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/Soheil-ab/Cellular-Traces-NYC.git"
	FALLBACK_COMMIT="ac6717b5f113bf899344e91ffc57e472daf29954"
	inherit git-r3
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${P}"
	SRC_URI="
		FIXME
	"
fi

DESCRIPTION="Cellular Traces Collected in New York City for different scenarios"
HOMEPAGE="
	https://github.com/Soheil-ab/Cellular-Traces-2018
"
LICENSE="all-rights-reserved" # No explicit license
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "

unpack_live() {
	use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
	git-r3_fetch
	git-r3_checkout
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		unpack_live
	else
		unpack ${A}
	fi
}

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	insinto "/usr/share/${PN}"
	doins -r *
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
