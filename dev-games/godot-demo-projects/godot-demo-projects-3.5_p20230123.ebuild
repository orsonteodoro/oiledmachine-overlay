# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

STATUS="stable"

if [[ "${PV}" =~ "9999" ]] ; then
	inherit git-r3
	S="${WORKDIR}/${P}"
else
	# The latest release
	EGIT_COMMIT_DEMOS_STABLE="9e68af38d9f2712572ee079879d0a752990a36e7"
	FN_DEST="${PN}-${EGIT_COMMIT_DEMOS_STABLE:0:7}.tar.gz"
	SRC_URI="
https://github.com/godotengine/${PN}/archive/refs/tags/$(ver_cut 1-2 ${PV})-${EGIT_COMMIT_DEMOS_STABLE:0:7}.tar.gz
		-> ${FN_DEST}
	"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT_DEMOS_STABLE}"
fi

DESCRIPTION="Demonstration and Template Projects"
HOMEPAGE="
http://godotengine.org
https://github.com/godotengine/godot-demo-projects
"
LICENSE="MIT"
KEYWORDS="~amd64 ~riscv ~x86"
SLOT_MAJ="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJ}/$(ver_cut 1-2 ${PV})"
RDEPEND="
	!dev-games/godot
"

pkg_setup() {
ewarn
ewarn "Do not emerge this directly use dev-games/godot-meta instead."
ewarn
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		EGIT_REPO_URI="https://github.com/godotengine/godot-demo-projects.git"
		EGIT_BRANCH="3.5"
		EGIT_COMMIT="HEAD"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() { :; }
src_compile() { :; }

src_install() {
	insinto /usr/share/godot${SLOT_MAJ}/godot-demo-projects
	doins -r "${S}"/*
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
