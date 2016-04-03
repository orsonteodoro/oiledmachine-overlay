#udb 2014-07-22
EAPI=5
inherit eutils subversion git-r3

DESCRIPTION="UDB CMaNGOS Three database for Cataclysm (CATA) 4.3.4 Client"
HOMEPAGE="http://udb.no-ip.org/"
LICENSE="GPL-2"
SLOT="3"
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
	EGIT_CHECKOUT_DIR="${WORKDIR}"
	EGIT_REPO_URI="https://github.com/UDB-434/Database.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="3d2ceffbd9b44482cd0ba70ce6ed387291fbb62b"
	git-r3_fetch
	git-r3_checkout
}
src_install() {
	mkdir -p "${D}/usr/share/cmangos/3"
	cp -R "${WORKDIR}"/* "${D}/usr/share/cmangos/3"
	cp "${FILESDIR}/newinstall-3-udb.sh" "${D}/usr/share/cmangos/3"
	cp "${FILESDIR}/existinginstall-3-udb.sh" "${D}/usr/share/cmangos/3"
	fperms 0755 "/usr/share/cmangos/3/newinstall-3-udb.sh"
	fperms 0755 "/usr/share/cmangos/3/existinginstall-3-udb.sh"
}
pkg_config() {
	einfo "Enter the mangos db prefix:"
	read PREFIX
	einfo "Enter the mysql admin username:"
	read USERNAME
	einfo "Enter the mysql admin password:"
	read -s

        ${ROOT}/usr/share/cmangos/3/newinstall-3-udb.sh $PREFIX $USERNAME $REPLY

	einfo "Your mysql databases are ${PREFIX}_characters, ${PREFIX}_realmd, ${PREFIX}_mangos, and ${PREFIX}_scriptdev2."
	unset REPLY
}
pkg_postinst() {
	einfo ""
	einfo "Use emerge --config =${P} to install a new cmangos db with game content."
	einfo ""
	einfo "Existing installs should use the existinginstall script in /usr/share/cmangos/3."
	einfo ""
	einfo "ACID is not included.  Emerge cmangos-acid:3 if you want it."
	einfo ""
}
