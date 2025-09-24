# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

STATUS="stable"

if [[ "${PV}" =~ "99999999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_COMMIT="HEAD"
	EGIT_REPO_URI="https://github.com/godotengine/godot-demo-projects.git"
	FALLBACK_COMMIT="5557b10cfa514101fb168c8ff2239594d7d34cff" # Mar 07, 2025
	inherit git-r3
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
else
	# The latest release
	FALLBACK_COMMIT="5557b10cfa514101fb168c8ff2239594d7d34cff" # Mar 07, 2025
	FN_DEST="${PN}-${FALLBACK_COMMIT:0:7}.tar.gz"
	KEYWORDS="~amd64 ~riscv ~x86"
	S="${WORKDIR}/${PN}-${FALLBACK_COMMIT}"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		SRC_URI="
https://github.com/godotengine/${PN}/archive/${FALLBACK_COMMIT}.tar.gz
			-> ${FN_DEST}
		"
	else
		SRC_URI="
https://github.com/godotengine/${PN}/archive/refs/tags/$(ver_cut 1-2 ${PV})-${FALLBACK_COMMIT:0:7}.tar.gz
			-> ${FN_DEST}
		"
	fi
fi

DESCRIPTION="Demonstration and Template Projects"
HOMEPAGE="
http://godotengine.org
https://github.com/godotengine/godot-demo-projects
"
LICENSE="MIT"
SLOT_MAJ=$(ver_cut "1-2" "${PV}")
SLOT="${SLOT_MAJ}/${PV}"
IUSE+="
ebuild_revision_2
"
RDEPEND="
	!dev-games/godot
"

pkg_setup() {
ewarn "Do not emerge this directly use dev-games/godot-meta instead."
}

src_unpack() {
	if [[ "${PV}" =~ "99999999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
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
	insinto "/usr/share/godot/${SLOT_MAJ}/godot-demo-projects"
	doins -r "${S}/"*
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
