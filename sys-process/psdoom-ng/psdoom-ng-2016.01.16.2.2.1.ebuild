EAPI=5
inherit eutils autotools

DESCRIPTION="psdoom-ng"
HOMEPAGE="https://github.com/orsonteodoro/psdoom-ng"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
RDEPEND="
	>=media-libs/libsdl-1.1.3
	media-libs/sdl-mixer
"
IUSE="psdoom-wads cloudfoundry"
SRC_URI="https://github.com/chocolate-doom/chocolate-doom/archive/chocolate-doom-${PV:11}.tar.gz"

S="${WORKDIR}/chocolate-doom-chocolate-doom-${PV:11}"
src_unpack() {
	unpack "chocolate-doom-${PV:11}.tar.gz"
	cd "${S}"
	epatch "${FILESDIR}"/psdoom-ng-${PVR}.patch
	if use psdoom-wads; then
		wget -O psdoom-data.tar.gz "http://downloads.sourceforge.net/project/psdoom/psdoom-data/2000.05.03/psdoom-2000.05.03-data.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fpsdoom%2Ffiles%2Fpsdoom-data%2F2000.05.03%2F&ts=1452812220&use_mirror=tcpdiag"
		sha1sum psdoom-data.tar.gz | grep "b300e250ae366097e562ecd9dda03bf70559cf67" &>/dev/null
		if [[ "$?" != "0" ]]; then
			die "wads checksum failed"
		else
			tar -xvf "psdoom-data.tar.gz"
		fi
	fi
}
src_prepare() {
	eautoreconf || die
}
src_configure(){
	econf $(use_enable cloudfoundry) \
          || die
}
src_compile() {
	emake || die
}
src_test() {
	true
}
src_install() {
	emake DESTDIR="${D}" install
	mkdir -p "${D}/usr/share/psdoom-ng"
	if use psdoom-wads; then
		cp "${S}"/psdoom-data/psdoom1.wad "${D}"/usr/share/psdoom-ng/
		cp "${S}"/psdoom-data/psdoom2.wad "${D}"/usr/share/psdoom-ng/
		cp "${S}"/psdoom-data/README "${D}"/usr/share/psdoom-ng/README.wad
	fi
}
pkg_postinst() {
	true
}
