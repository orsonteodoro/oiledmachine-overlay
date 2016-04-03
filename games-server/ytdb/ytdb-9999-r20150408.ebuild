#ytdb db dump 2015-04-08
EAPI=5
inherit eutils subversion git-r3

DESCRIPTION="YTDB CMaNGOS Two database for The Wrath of the Lich King (WOTLK) 3.3.5a Client"
HOMEPAGE="http://ytdb.ru/"
LICENSE="GPL-2"
SLOT="2"
KEYWORDS="amd64"
RDEPEND="
	app-arch/p7zip
	>=dev-libs/boost-1.49
	>=virtual/mysql-5.1.0
	>=dev-util/cmake-2.8.9
	>=dev-libs/openssl-1.0
	>=sys-devel/gcc-4.7.2
	>=sys-libs/zlib-1.2.7
	>=net-libs/zeromq-2.2.6
	app-arch/bzip2
"
S="${WORKDIR}"
src_unpack() {
	ESVN_REPO_URI="http://svn2.assembla.com/svn/ytdbase/Mangos/Wotlk/R65"
	ESVN_STORE_DIR="${WORKDIR}"
	ESVN_REVISION="444"
	subversion_src_unpack
	7z e "${WORKDIR}/YTDB_0.14.8_R650_cMaNGOS_R12867_SD2_R3121_ACID_R320_RuDB_R65.7z"
}
src_install() {
	mkdir -p "${D}/usr/share/cmangos/2"
	cp -R "${WORKDIR}"/* "${D}/usr/share/cmangos/2"
	cp "${FILESDIR}/newinstall-2-ytdb.sh" "${D}/usr/share/cmangos/2"
	cp "${FILESDIR}/existinginstall-2-ytdb.sh" "${D}/usr/share/cmangos/2"
	fperms 0755 "/usr/share/cmangos/2/newinstall-2-ytdb.sh"
	fperms 0755 "/usr/share/cmangos/2/existinginstall-2-ytdb.sh"
}
pkg_config() {
	einfo "Enter the mangos db prefix:"
	read PREFIX
	einfo "Enter the mysql admin username:"
	read USERNAME
	einfo "Enter the mysql admin password:"
	read -s

        ${ROOT}/usr/share/cmangos/2/newinstall-2-ytdb.sh $PREFIX $USERNAME $REPLY

	einfo "Your mysql databases are ${PREFIX}_characters, ${PREFIX}_realmd, ${PREFIX}_mangos, and ${PREFIX}_scriptdev2."
	unset REPLY
}
pkg_postinst() {
	einfo ""
	einfo "Use emerge --config =${P} to install a new cmangos db with game content."
	einfo ""
	einfo "Existing installs should use the existinginstall script in /usr/share/cmangos/2."
	einfo ""
	einfo "ACID is not included.  Emerge cmangos-acid:2 if you want it."
	einfo ""
}
