# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

#psdb db dump 2015-05-19
EAPI=5
inherit eutils subversion git-r3 versionator

DESCRIPTION="PSDB CMaNGOS Two database for The Wrath of the Lich King (WOTLK) 3.3.5a Client"
HOMEPAGE="http://project-silvermoon.forumotion.com/"
LICENSE=""
SLOT="2"
KEYWORDS="~amd64 ~x86"
RDEPEND="
	>=virtual/mysql-5.1.0
"
S="${WORKDIR}"
IUSE="mangos cmangos"

MY_V="$(get_version_component_range 2)"

src_unpack() {
	ESVN_REPO_URI="http://subversion.assembla.com/svn/psmdb_wotlk"
	ESVN_STORE_DIR="${WORKDIR}"
	ESVN_REVISION="${MY_V}"
	subversion_src_unpack
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
			cp "${FILESDIR}/install-psdb.sh" "${D}/usr/share/$engine/${SLOT}"
			fperms 0755 "/usr/share/$engine/${SLOT}/install-psdb.sh"
		fi
	done
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

        ${ROOT}/usr/share/cmangos/${SLOT}/install-psdb.sh $PREFIX $USERNAME $REPLY $TYPE

	einfo "Your mysql databases are ${PREFIX}_characters, ${PREFIX}_realmd, ${PREFIX}_mangos, and ${PREFIX}_scriptdev2."
	unset REPLY
}

pkg_postinst() {
	einfo ""
	einfo "Use emerge --config =${P} for new install or update."
	einfo ""
	einfo "ACID is not included.  Emerge cmangos-acid:2 if you want it."
	einfo ""
}
