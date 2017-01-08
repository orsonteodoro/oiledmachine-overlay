# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils multilib-minimal multilib-build

DESCRIPTION="Theoraplay"
HOMEPAGE=""
COMMIT="fb533bb8633e"
SRC_URI="https://hg.icculus.org/icculus/theoraplay/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="zlib"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libtheora
         media-libs/libvorbis
         media-libs/ogg"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	eapply_user
	multilib_copy_sources
}

multilib_src_compile() {
	mycflags="-m64"
	if use abi_x86_64 ; then
		mycflags="-m64"
	fi
	if use abi_x86_64 ; then
		mycflags="-m32"
	fi
	gcc ${mycflags} -fPIC -c theoraplay.c
	gcc ${mycflags} -shared -o libtheoraplay.so theoraplay.o -logg -lvorbis -ltheoradec -pthread
}

multilib_src_install() {
	mkdir -p "${D}/usr/$(get_libdir)"
	cp -a libtheoraplay.so "${D}/usr/$(get_libdir)"
}
