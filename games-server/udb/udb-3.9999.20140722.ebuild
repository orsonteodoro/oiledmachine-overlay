# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils subversion git-r3

DESCRIPTION="UDB CMaNGOS Three database for Cataclysm (CATA) 4.3.4 Client"
HOMEPAGE="http://udb.no-ip.org/"
LICENSE="GPL-2+"
SLOT="3"
KEYWORDS="~amd64 ~x86"
RDEPEND="
	>=virtual/mysql-5.1.0
"
S="${WORKDIR}"
IUSE="mangos cmangos"

src_unpack() {
	EGIT_CHECKOUT_DIR="${WORKDIR}"
	EGIT_REPO_URI="https://github.com/UDB-434/Database.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="3d2ceffbd9b44482cd0ba70ce6ed387291fbb62b"
	git-r3_fetch
	git-r3_checkout
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
			cp "${FILESDIR}/install-udb.sh" "${D}/usr/share/$engine/${SLOT}"
			fperms 0755 "/usr/share/$engine/${SLOT}/install-udb.sh"
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
        ${ROOT}/usr/share/${ENGINE}/${SLOT}/install-udb.sh $PREFIX $USERNAME $REPLY $SLOT $TYPE
	einfo "Your mysql databases are ${PREFIX}_characters, ${PREFIX}_realmd, ${PREFIX}_mangos, and ${PREFIX}_scriptdev2."
	unset REPLY
}

pkg_postinst() {
	einfo ""
	einfo "Use emerge --config =${P} for new install or update."
	einfo ""
	einfo "ACID is not included.  Emerge acid:${SLOT} if you want it."
	einfo ""
}
