# Copyright open-overlay 2015 by Alex
EAPI=5
inherit eutils autotools

DESCRIPTION="Libmpq is a library for reading MPQ files (archives used by Blizzard) which can be easily used in applications."
HOMEPAGE="https://libmpq.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
DEPEND="
	sys-libs/zlib
	app-arch/bzip2
	dev-lang/python:2.7
"
SRC_URI="mirror://sourceforge/g3d/G3D-${PV}-source.zip"
RDEPEND="${DEPEND}"
IUSE=""

S="${WORKDIR}/libmpq-debian-0.4.2-svn288-1"
src_unpack() {
	unpack "${A}"
}
src_prepare() {
	eautoreconf
	econf
}
src_compile() {
	emake
}
src_install() {
	emake DESTDIR="${D}" install
}
