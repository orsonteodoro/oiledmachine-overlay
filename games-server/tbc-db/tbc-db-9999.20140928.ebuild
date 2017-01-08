# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

#tbc-db db dump 2014-09-14
EAPI=5
inherit eutils subversion git-r3

DESCRIPTION="TBC-DB CMaNGOS One database for The Burning Crusade (TBC) 2.4.3 Client"
HOMEPAGE="http://udb.no-ip.org/"
LICENSE="GPL-2"
SLOT="1"
KEYWORDS="amd64"
RDEPEND="
	>=dev-libs/boost-1.49
	>=virtual/mysql-5.1.0
	>=dev-util/cmake-2.8.9
	>=dev-libs/openssl-1.0
	>=sys-devel/gcc-4.7.2
	>=sys-libs/zlib-1.2.7
	>=net-libs/zeromq-2.2.6
	app-arch/bzip2
"
IUSE=""
S="${WORKDIR}"

src_unpack() {
	EGIT_CHECKOUT_DIR="${WORKDIR}"
	EGIT_REPO_URI="https://github.com/TBC-DB/Database.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="a74bb53d4d12526ec9750b1a8562120c33552432"
	git-r3_fetch
	git-r3_checkout
}

src_prepare() {
	epatch_user
}

src_install() {
	mkdir -p "${D}/usr/share/cmangos/1"
	cp -R "${WORKDIR}"/* "${D}/usr/share/cmangos/1"
	cp "${FILESDIR}/newinstall-1-tbcdb.sh" "${D}/usr/share/cmangos/1"
	cp "${FILESDIR}/existinginstall-1-tbcdb.sh" "${D}/usr/share/cmangos/1"
	fperms 0755 "/usr/share/cmangos/1/newinstall-1-tbcdb.sh"
	fperms 0755 "/usr/share/cmangos/1/existinginstall-1-tbcdb.sh"
}

pkg_config() {
	einfo "Enter the mangos db prefix:"
	read PREFIX
	einfo "Enter the mysql admin username:"
	read USERNAME
	einfo "Enter the mysql admin password:"
	read -s

        ${ROOT}/usr/share/cmangos/1/newinstall-1-tbcdb.sh $PREFIX $USERNAME $REPLY

	einfo "Your mysql databases are ${PREFIX}_characters, ${PREFIX}_realmd, ${PREFIX}_mangos, and ${PREFIX}_scriptdev2."
	unset REPLY
}

pkg_postinst() {
	einfo ""
	einfo "Use emerge --config =${P} to install a new cmangos db with game content."
	einfo ""
	einfo "Existing installs should use the existinginstall script in /usr/share/cmangos/1."
	einfo ""
	einfo "ACID is not included.  Emerge cmangos-acid:1 if you want it."
	einfo ""
}
