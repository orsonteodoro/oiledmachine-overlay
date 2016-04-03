EAPI=5
inherit eutils git-r3

DESCRIPTION="MaNGOS Zero database for the Classic (Vanilla) 1.12.1/2/3 Client"
HOMEPAGE="https://www.getmangos.eu/"
LICENSE="GPL-2"
SLOT="0"
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
	EGIT_REPO_URI="https://github.com/mangoszero/database.git"
	EGIT_BRANCH="release20"
	EGIT_COMMIT="a74238504f5b09b1b20cd67c4d168ec0e8a247ab"
	git-r3_fetch
	git-r3_checkout
}
src_install() {
	mkdir -p "${D}/usr/share/mangos/0"
	cp -R "${WORKDIR}"/* "${D}/usr/share/mangos/0"
	cp "${FILESDIR}/newinstall.sh" "${D}/usr/share/mangos/0"
	cp "${FILESDIR}/applymicroupdate-0-0.sh" "${D}/usr/share/mangos/0"
	fperms 0755 "/usr/share/mangos/0/newinstall.sh"
	fperms 0755 "/usr/share/mangos/0/applymicroupdate-0-0.sh"
}
pkg_config() {
	einfo "Enter the mangos db prefix:"
	read PREFIX
	einfo "Enter the mysql admin username:"
	read USERNAME
	einfo "Enter the mysql admin password:"
	read -s
	${ROOT}/usr/share/mangos/0/newinstall.sh $PREFIX $USERNAME $REPLY
	einfo "Your mysql databases are ${PREFIX}_characters, ${PREFIX}_realmd, and ${PREFIX}_mangos."
	${ROOT}/usr/share/mangos/0/applymicroupdate-0-0.sh $PREFIX $USERNAME $REPLY
	unset REPLY
}
pkg_postinst() {
	einfo ""
	einfo "Use /usr/share/mangos/0/newinstall.sh to install a new mangos db with game content or"
	einfo "use emerge --config =${P}."
	einfo ""
	einfo "Database updates are provided by applymicroupdate-0-0.sh script."
	einfo ""
}
