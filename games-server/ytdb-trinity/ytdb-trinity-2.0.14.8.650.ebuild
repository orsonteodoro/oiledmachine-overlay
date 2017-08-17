# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

#ytdb db dump 2015-04-08
EAPI=5
inherit eutils subversion git-r3

DESCRIPTION="YTDB Trinity Two database for The Wrath of the Lich King (WOTLK) 3.3.5a Client"
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

src_unpack() {
	ESVN_REPO_URI="http://svn2.assembla.com/svn/ytdbase/Trinity/Wotlk/R65"
	ESVN_STORE_DIR="${WORKDIR}"
	ESVN_REVISION="444"
	subversion_src_unpack
	7z e "${WORKDIR}/YTDB_0.14.8_R650_TC_R23345_TDBAI_335_RuDB_R65.7z"
}

src_prepare() {
	epatch_user
}

src_install() {
	mkdir -p "${D}/usr/share/trinitycore/${SLOT}"
	cp -R "${WORKDIR}"/* "${D}/usr/share/trinitycore/${SLOT}"
	cp "${FILESDIR}/install-ytdb-trinity.sh" "${D}/usr/share/trinitycore/${SLOT}"
	fperms 0755 "/usr/share/trinitycore/${SLOT}/install-ytdb-trinity.sh"
}

pkg_config() {
	einfo "Enter type of database operation (new, safe_update, unsafe_update):"
        read TYPE
        #einfo "Enter server type (mangos, cmangos):"
        ENGINE="trinitycore"
	einfo "Enter the trinity db prefix:"
	read PREFIX
	einfo "Enter the mysql admin username:"
	read USERNAME
	einfo "Enter the mysql admin password:"
	read -s
        ${ROOT}/usr/share/${ENGINE}/${SLOT}/install-ytdb-trinity.sh $PREFIX $USERNAME $REPLY $ENGINE $SLOT $TYPE
	einfo "Your mysql databases are ${PREFIX}_characters, ${PREFIX}_auth, ${PREFIX}_world, and ${PREFIX}_scriptdev2."
	unset REPLY
}

pkg_postinst() {
	einfo ""
	einfo "Use emerge --config =${P} to install a new trinity db with game content."
	einfo ""
	einfo "ACID is not included.  Emerge acid:2 if you want it."
	einfo ""
}
