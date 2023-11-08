# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Godot metapackage"
KEYWORDS="~amd64 ~riscv ~x86"
SLOT_MAJ="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJ}/$(ver_cut 1-2 ${PV})"
IUSE_EXPORT_TEMPLATES="
android dedicated-server headless-server ios ios-plugins javascript linux32
+linux64 macos mingw32 mingw64 prebuilt-export-templates
"
IUSE=" ${IUSE_EXPORT_TEMPLATES} +demos -export-templates"
REQUIRED_USE="
	!dedicated-server
	!headless-server
	!ios-plugins
"
#		dev-games/godot-demo-projects:${PV%%.*}/$(ver_cut 1-2 ${PV})
RDEPEND="
	!dev-games/godot
	dev-games/godot-editor:${SLOT}
	android? (
		dev-games/godot-export-templates-android:${SLOT}
	)
	dedicated-server? (
		dev-games/godot-dedicated-server:${SLOT}
	)
	demos? (
		=dev-games/godot-demo-projects-9999
	)
	headless-server? (
		dev-games/godot-headless-server:${SLOT}
	)
	ios? (
		dev-games/godot-export-templates-ios:${SLOT}
	)
	ios-plugins? (
		def-games/godot-ios-plugins:${SLOT}
	)
	javascript? (
		dev-games/godot-export-templates-javascript:${SLOT}
	)
	linux32? (
		dev-games/godot-export-templates-linux32:${SLOT}
	)
	linux64? (
		dev-games/godot-export-templates-linux64:${SLOT}
	)
	macos? (
		dev-games/godot-export-templates-macos:${SLOT}
	)
	mingw32? (
		dev-games/godot-export-templates-mingw32:${SLOT}
	)
	mingw64? (
		dev-games/godot-export-templates-mingw64:${SLOT}
	)
	prebuilt-export-templates? (
		dev-games/godot-export-templates-bin:${SLOT}
	)
"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
