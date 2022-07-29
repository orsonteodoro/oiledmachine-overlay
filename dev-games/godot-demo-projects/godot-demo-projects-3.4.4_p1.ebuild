# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

STATUS="stable"

DESCRIPTION="Demonstration and Template Projects"
HOMEPAGE="
http://godotengine.org
https://github.com/godotengine/godot-demo-projects
"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT_MAJ="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJ}/$(ver_cut 1-2 ${PV})"

# latest release
EGIT_COMMIT_DEMOS_STABLE="b0d4a7cb8ad6c592c94606fdf968b6614b162808"
FN_DEST="${PN}-${EGIT_COMMIT_DEMOS_STABLE:0:7}.tar.gz"
SRC_URI="
https://github.com/godotengine/${PN}/archive/refs/tags/3.4-${EGIT_COMMIT_DEMOS_STABLE:0:7}.tar.gz
	-> ${FN_DEST}
"

S="${WORKDIR}/${PN}-${EGIT_COMMIT_DEMOS_STABLE}"

src_configure() { :; }
src_compile() { :; }

src_install() {
	insinto /usr/share/godot${SLOT_MAJ}/godot-demo-projects
	doins -r "${S}"/*
}
