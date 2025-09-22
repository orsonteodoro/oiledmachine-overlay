# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Kept for Orchestrator support

DESCRIPTION="Godot metapackage"
KEYWORDS="~amd64 ~riscv ~x86"
SLOT_MAJ="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJ}/$(ver_cut 1-2 ${PV})"
IUSE="
+demos -export-templates
"
RDEPEND="
	!dev-games/godot
	dev-games/godot-editor:${SLOT}
	demos? (
		dev-games/godot-demo-projects:${PV%%.*}
	)
	export-templates? (
		dev-games/godot-export-templates-bin:${SLOT}
	)
"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
