# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="Godot Engine - Multi-platform 2D and 3D game engine"
HOMEPAGE="http://godotengine.org"
SRC_URI="https://github.com/godotengine/godot/archive/${PV}-stable.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gamepad"

RDEPEND="dev-lang/python:2.7
	 media-libs/mesa
	 dev-libs/openssl
         gamepad? ( dev-libs/libevdev virtual/libudev )
         virtual/pkgconfig
         media-libs/freetype
         media-sound/pulseaudio
         dev-util/scons
         x11-libs/libXinerama
	 x11-libs/libX11
	 "
DEPEND="${RDEPEND}"

S="${WORKDIR}/godot-${PV}-stable"

src_prepare() {
	eapply_user
}

src_compile() {
	scons platform=x11 || die
}

src_install() {
	mkdir -p "${D}/usr/bin"
	cp "${S}/bin"/godot.*.tools.* "${D}/usr/bin"/

	PROG=$(ls "${D}/usr/bin"/godot.*.tools.*)
	PROG_BN=$(basename ${PROG})

	cd "${D}/usr/bin"
	ln -s "${PROG_BN}" "godot"
	mkdir -p "${D}/usr/share/godot"
	cp -r "${S}/demos"  "${D}/usr/share/godot"

	cp "${S}/godot_icon.png" "${D}/usr/share/godot"
	make_desktop_entry "/usr/bin/godot" "Godot" "${ROOT}/usr/share/godot/godot_icon.png" "Development;IDE"
}
