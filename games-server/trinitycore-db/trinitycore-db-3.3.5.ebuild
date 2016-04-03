EAPI=5
inherit eutils git-r3

DESCRIPTION="TrinityCore database for the Mists of Pandaria (MOP) 4.0.6a Client"
HOMEPAGE="http://www.trinitycore.org/"
LICENSE="GPL-2"
SLOT="3"
KEYWORDS="amd64"
RESTRICT="fetch"
SRC_URI=""
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

SFDB_URI="http://www.trinitycore.org/f/files/category/1-database/"
SRC_URI=""

check_tarballs_available() {
        local uri=$1; shift
        local dl= unavailable=
        for dl in "${@}"; do
                [[ ! -f "${DISTDIR}/${dl}" ]] && unavailable+=" ${dl}"
        done
 
        if [[ -n "${unavailable}" ]]; then
                if [[ -z ${_check_tarballs_available_once} ]]; then
                        einfo
                        einfo "TrinityCore requires you to download the needed files manually."
                        einfo
                        _check_tarballs_available_once=1
                fi
                einfo "Download the following files:"
                for dl in ${unavailable}; do
                        einfo "  ${dl}"
                done
                einfo "at '${uri}'"
                einfo
                einfo "After you downloaded the DB you need to extract the"
                einfo "${dl} file from the downloaded file and move it into ${DISTDIR}"
                einfo
        fi
}
 
pkg_nofetch() {
        local distfiles=( $(eval "echo \${$(echo AT_${ARCH/-/_})}") )
        check_tarballs_available "${SFDB_URI}" "${distfiles[@]}"
}


src_unpack() {
	unpack "${A}"
}
src_install() {
	mkdir -p "${D}/usr/share/trinitycore/5"
	cp -R "${WORKDIR}"/* "${D}/usr/share/trinitycore/5"
}
