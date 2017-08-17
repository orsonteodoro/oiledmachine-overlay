# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils git-r3

DESCRIPTION="CMaNGOS TBC database for The Burning Crusade (TBC) Client"
HOMEPAGE="https://github.com/cmangos/tbc-db"
LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~amd64 ~x86"
RDEPEND="
	>=virtual/mysql-5.1.0
	acid? ( games-server/acid )
"
IUSE="acid"
S="${WORKDIR}"

src_unpack() {
	EGIT_CHECKOUT_DIR="${WORKDIR}"
	EGIT_REPO_URI="https://github.com/cmangos/tbc-db.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="9f28c559b155a9ac9a560f499f757017b20bd227"
	git-r3_fetch
	git-r3_checkout
}

DB_TRIPLET="2684-1451-1472"

src_install() {
	mkdir -p "${D}/usr/share/cmangos/${SLOT}"
	cp -R "${WORKDIR}"/* "${D}/usr/share/cmangos/${SLOT}"
	cp "${FILESDIR}/install-cmangos-db.sh" "${D}/usr/share/cmangos/${SLOT}"
	fperms 0755 "/usr/share/cmangos/${SLOT}/install-cmangos-db.sh"
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

        ${ROOT}/usr/share/cmangos/${SLOT}/install-cmangos-db.sh $PREFIX $USERNAME $REPLY $TYPE

	einfo "Your mysql databases are ${PREFIX}_characters, ${PREFIX}_realmd, ${PREFIX}_mangos, and ${PREFIX}_scriptdev2."
	unset REPLY
}

pkg_postinst() {
	einfo ""
	einfo "Use emerge --config =${P} to install a new cmangos db with game content."
	einfo ""
	einfo "ACID is not included.  Emerge acid:${SLOT} if you want it."
	einfo ""
}



