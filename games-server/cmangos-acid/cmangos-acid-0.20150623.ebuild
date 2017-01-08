# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils git-r3

DESCRIPTION="ACID CMaNGOS Zero database for the Classic (Vanilla) 1.12.1/2/3 Client"
HOMEPAGE="http://www.scriptdev2.com/forums/6-ACID-Development"
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
	EGIT_REPO_URI="https://github.com/ACID-Scripts/Classic.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="71ada93d37d78f0ec488555d6bb8f54a99534dfd"
	git-r3_fetch
	git-r3_checkout
}

src_prepare() {
	eapply_user
}

src_install() {
	mkdir -p "${D}/usr/share/cmangos/0/sql/acid"
	cp -R "${WORKDIR}"/* "${D}/usr/share/cmangos/0/sql/acid"
}

pkg_config() {
	einfo "Enter the mangos db prefix:"
	read PREFIX
	einfo "Enter the mysql admin username:"
	read USERNAME
	einfo "Enter the mysql admin password:"
	read -s

	mysql --user="${USERNAME}" --password="${REPLY}" ${PREFIX}_mangos < ${ROOT}/usr/share/cmangos/0/sql/acid/acid_classic.sql

	einfo "ACID committed changes."
	unset REPLY
}

pkg_postinst() {
	einfo ""
	einfo "Use emerge --config =${P} to update acid."
	einfo ""
}



