# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils git-r3

DESCRIPTION="Classic DB CMaNGOS Zero database for the Classic (Vanilla) 1.12.1/2/3 Client"
HOMEPAGE="https://github.com/classicdb"
LICENSE="GPL-2"
SLOT="0"
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
	EGIT_REPO_URI="https://github.com/classicdb/database.git"
	EGIT_BRANCH="classic"
	EGIT_COMMIT="25284abc5eb009774d5840da9ef747b7505635a3"
	git-r3_fetch
	git-r3_checkout
}

src_install() {
	mkdir -p "${D}/usr/share/cmangos/0"
	cp -R "${WORKDIR}"/* "${D}/usr/share/cmangos/0"
	cp "${FILESDIR}/newinstall-0.sh" "${D}/usr/share/cmangos/0"
	cp "${FILESDIR}/existinginstall-0.sh" "${D}/usr/share/cmangos/0"
	fperms 0755 "/usr/share/cmangos/0/newinstall-0.sh"
	fperms 0755 "/usr/share/cmangos/0/existinginstall-0.sh"
}

pkg_config() {
	einfo "Enter the mangos db prefix:"
	read PREFIX
	einfo "Enter the mysql admin username:"
	read USERNAME
	einfo "Enter the mysql admin password:"
	read -s

        ${ROOT}/usr/share/cmangos/0/newinstall-0.sh $PREFIX $USERNAME $REPLY

	einfo "Your mysql databases are ${PREFIX}_characters, ${PREFIX}_realmd, ${PREFIX}_mangos, and ${PREFIX}_scriptdev2."
	unset REPLY
}

pkg_postinst() {
	einfo ""
	einfo "Use emerge --config =${P} to install a new cmangos db with game content."
	einfo ""
	einfo "Existing installs should use the existinginstall script in /usr/share/cmangos/0."
	einfo ""
	einfo "ACID is not included.  Emerge cmangos-acid:0 if you want it."
	einfo ""
}



