# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

#ytdb db dump 2015-04-08
EAPI=5
inherit eutils subversion git-r3

DESCRIPTION="YTDB CMaNGOS Two database for The Wrath of the Lich King (WOTLK) 3.3.5a Client"
HOMEPAGE="http://ytdb.ru/"
LICENSE=""
SLOT="2"
KEYWORDS="~amd64 ~x86"
RDEPEND="
	>=virtual/mysql-5.1.0
"
DEPEND="${RDEPEND}
        app-arch/p7zip"
S="${WORKDIR}"
IUSE="mangos cmangos"

src_unpack() {
	ESVN_REPO_URI="http://svn2.assembla.com/svn/ytdbase/Mangos/Wotlk/R65"
	ESVN_STORE_DIR="${WORKDIR}"
	ESVN_REVISION="444"
	subversion_src_unpack
	7z e "${WORKDIR}/YTDB_0.14.8_R650_cMaNGOS_R12867_SD2_R3121_ACID_R320_RuDB_R65.7z"
}

src_prepare() {
	epatch_user
}

src_install() {
	for engine in $IUSE
	do
		if use $engine; then
			mkdir -p "${D}/usr/share/$engine/${SLOT}"
			cp -R "${WORKDIR}"/* "${D}/usr/share/$engine/${SLOT}"
			cp "${FILESDIR}/install-ytdb-mangos.sh" "${D}/usr/share/$engine/${SLOT}"
			fperms 0755 "/usr/share/$engine/${SLOT}/install-ytdb-mangos.sh"
		fi
	done
}

pkg_config() {
	einfo "Enter type of database operation (new, safe_update, unsafe_update):"
        read TYPE
        einfo "Enter server type (mangos, cmangos):"
        read ENGINE
	einfo "Enter the mangos db prefix:"
	read PREFIX
	einfo "Enter the mysql admin username:"
	read USERNAME
	einfo "Enter the mysql admin password:"
	read -s
        ${ROOT}/usr/share/${ENGINE}/2/newinstall-${PV}-ytdb-mangos.sh $PREFIX $USERNAME $REPLY $ENGINE $SLOT $TYPE
	einfo "Your mysql databases are ${PREFIX}_characters, ${PREFIX}_realmd, ${PREFIX}_mangos, and ${PREFIX}_scriptdev2."
	unset REPLY
}

pkg_postinst() {
	einfo ""
	einfo "Use emerge --config =${P} to install a new cmangos db with game content."
	einfo ""
	einfo "ACID is not included.  Emerge acid:2 if you want it."
	einfo ""
}
