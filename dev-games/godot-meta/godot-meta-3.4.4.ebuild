# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Godot metapackage"
KEYWORDS="~amd64 ~x86"
IUSE_EXPORT_TEMPLATES="android dedicated-server headless-server ios javascript
linux32 +linux64 linux-mono linux-server macos mingw32 mingw64"
IUSE="${IUSE_EXPORT_TEMPLATES} +demos -export-templates"
SLOT_MAJ="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJ}/$(ver_cut 1-2 ${PV})"
RDEPEND="
	dev-games/godot-editor:${SLOT}
	android? (
		dev-games/godot-template-android:${SLOT}
	)
	dedicated-server? (
		dev-games/godot-dedicated-server:${SLOT}
	)
	demos? (
		dev-games/godot-demo-projects:${SLOT}
	)
	headless-server? (
		dev-games/godot-headless-server:${SLOT}
	)
	ios? (
		dev-games/godot-template-ios:${SLOT}
	)
	javascript? (
		dev-games/godot-template-javascript:${SLOT}
	)
	linux32? (
		dev-games/godot-template-linux32:${SLOT}
	)
	linux64? (
		dev-games/godot-template-linux64:${SLOT}
	)
	linux-mono? (
		dev-games/godot-template-linux-mono:${SLOT}
	)
	macos? (
		dev-games/godot-template-macos:${SLOT}
	)
	mingw32? (
		dev-games/godot-template-mingw32:${SLOT}
	)
	mingw64? (
		dev-games/godot-template-mingw64:${SLOT}
	)
"
