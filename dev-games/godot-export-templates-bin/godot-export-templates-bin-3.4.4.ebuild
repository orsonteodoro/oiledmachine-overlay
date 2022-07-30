# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Godot export templates"
# Many licenses because of assets (e.g. artwork, fonts) and third party libraries
LICENSE="
	all-rights-reserved
	Apache-2.0
	BitstreamVera
	Boost-1.0
	BSD
	BSD-2
	CC-BY-4.0
	FTL
	ISC
	LGPL-2.1
	MIT
	MPL-2.0
	OFL-1.1
	openssl
	Unlicense
	ZLIB
"

# thirdparty/misc/curl_hostcheck.c - all-rights-reserved MIT # \
#   The MIT license does not have all rights reserved but the source does

# thirdparty/bullet/BulletCollision - zlib all-rights-reserved # \
#   The ZLIB license does not have all rights reserved but the source does

# thirdparty/bullet/BulletDynamics - all-rights-reserved || ( LGPL-2.1 BSD )

# thirdparty/libpng/arm/palette_neon_intrinsics.c - all-rights-reserved libpng # \
#   libpng license does not contain all rights reserved, but this source does

KEYWORDS="~amd64"
HOMEPAGE="https://godotengine.org"
IUSE="standard mono"
REQUIRED_USE="|| ( standard mono )"
SLOT_MAJ="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJ}/$(ver_cut 1-2 ${PV})"
RESTRICT="binchecks"
if [[ "AUPDATE" == "1" ]] ; then
	SRC_URI="
		https://downloads.tuxfamily.org/godotengine/3.4.4/mono/Godot_v3.4.4-stable_mono_export_templates.tpz
		https://downloads.tuxfamily.org/godotengine/3.4.4/Godot_v3.4.4-stable_export_templates.tpz
	"
else
	SRC_URI="
		mono? (
			https://downloads.tuxfamily.org/godotengine/3.4.4/mono/Godot_v3.4.4-stable_mono_export_templates.tpz
		)
		standard? (
			https://downloads.tuxfamily.org/godotengine/3.4.4/Godot_v3.4.4-stable_export_templates.tpz
		)
	"
fi

src_unpack() {
	# skip unpack
	mkdir -p "${S}" || die
}

src_install() {
	insinto /usr/share/godot/${SLOT_MAJ}/prebuilt-export-templates
	use mono && doins $(realpath "${DISTDIR}/Godot_v3.4.4-stable_mono_export_templates.tpz")
	use standard && doins $(realpath "${DISTDIR}/Godot_v3.4.4-stable_export_templates.tpz")
}
