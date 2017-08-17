# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils versionator

DESCRIPTION="TrinityCore database for the Warlords of Draenor (WOD) 6.04 Client"
HOMEPAGE="http://www.trinitycore.org/"
LICENSE="GPL-2"
SLOT="5"
KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/TrinityCore/TrinityCore/archive/$(get_version_component_range 1-3)/$(get_version_component_range 4).tar.gz"
RDEPEND="
	>=virtual/mysql-5.1.0
"
IUSE=""

S="${WORKDIR}"

src_unpack() {
	unpack "${A}"
}

src_prepare() {
	eapply_user
}

src_install() {
	mkdir -p "${D}/usr/share/trinitycore/${SLOT}"
	cp -R "${WORKDIR}"/TrinityCore-TDB$(get_version_component_range 1-3)-$(get_version_component_range 4)/* "${D}/usr/share/trinitycore/${SLOT}"
	rm -rf "${D}/usr/share/trinitycore/${SLOT}"/{src,dep,*cmake,CMakeLists.txt,contrib}
	rm $(find "${D}/usr/share/trinitycore/${SLOT}/doc" -not -name "GPL-2.0.txt" -type f)
	cp "${FILESDIR}/install-trinitycore-db.sh" "${D}/usr/share/trinitycore/${SLOT}"
	fperms 0755 "/usr/share/trinitycore/${SLOT}/install-trinitycore-db.sh"
}

pkg_config() {
	einfo "Enter type of database operation (new, safe_update, unsafe_update):"
        read TYPE
	einfo "Enter the mangos db prefix:"
	read PREFIX
	einfo "Enter the mysql admin username:"
	read USERNAME
	einfo "Enter the mysql admin password:"
	read -s
        ${ROOT}/usr/share/trinitycore/${SLOT}/install-trinitycore-db.sh $PREFIX $USERNAME $REPLY $ENGINE $SLOT $TYPE
	einfo "Your mysql databases are ${PREFIX}_characters, ${PREFIX}_auth, ${PREFIX}_world, and ${PREFIX}_scriptdev2."
	unset REPLY
}

pkg_postinst() {
	einfo ""
	einfo "Use emerge --config =${P} for a new install or update."
	einfo ""
	einfo "ACID is not included.  Emerge acid:${SLOT} if you want it."
	einfo ""
}



