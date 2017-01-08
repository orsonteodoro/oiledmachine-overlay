# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils git-r3

DESCRIPTION="MaNGOS Two database for The Wrath of the Lich King (WOTLK) 3.3.5a Client"
HOMEPAGE="https://www.getmangos.eu/"
LICENSE="GPL-2"
SLOT="2"
KEYWORDS="amd64"
RDEPEND="
	>=dev-libs/boost-1.49
	>=dev-db/mysql-5.1.0
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
	EGIT_REPO_URI="https://github.com/mangostwo/database.git"
	EGIT_BRANCH="Rel20_Newbuild"
	EGIT_COMMIT="71c21edb987931a4fa936235c9660b1bced8de39"
	git-r3_fetch
	git-r3_checkout
}

src_prepare() {
	epatch_user
}

src_install() {
	mkdir -p "${D}/usr/share/mangos/2"
	cp -R "${WORKDIR}"/* "${D}/usr/share/mangos/2"
	cp "${FILESDIR}/newinstall.sh" "${D}/usr/share/mangos/2"
	cp "${FILESDIR}/applymicroupdate-2-0.sh" "${D}/usr/share/mangos/0"
	fperms 0755 "/usr/share/mangos/2/newinstall.sh"
	fperms 0755 "/usr/share/mangos/2/applymicroupdate-2-0.sh"
}

pkg_config() {
	einfo "Enter the mangos db prefix:"
	read PREFIX
	einfo "Enter the mysql admin username:"
	read USERNAME
	einfo "Enter the mysql admin password:"
	read -s
	${ROOT}/usr/share/mangos/2/newinstall.sh $PREFIX $USERNAME $REPLY
	einfo "Your mysql databases are ${PREFIX}_characters, ${PREFIX}_realmd, and ${PREFIX}_mangos."
	${ROOT}/usr/share/mangos/2/applymicroupdate-2-0.sh $PREFIX $USERNAME $REPLY
	unset REPLY
}

pkg_postinst() {
	einfo ""
	einfo "Use /usr/share/mangos/2/newinstall.sh to install a new mangos db with game content or"
	einfo "use emerge --config =${P}."
	einfo ""
	einfo "Database updates are provided by applymicroupdate-2-0.sh script."
	einfo ""
}
