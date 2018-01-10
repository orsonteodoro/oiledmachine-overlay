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
IUSE="static debug"

RDEPEND="media-libs/libtheora
         media-libs/libvorbis
         media-libs/libogg"
DEPEND="${RDEPEND}
        dev-util/premake:5"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	cp "${FILESDIR}/buildcpp.lua" "${S}"

	premake5 --file=buildcpp.lua gmake

	eapply_user

	multilib_copy_sources
}

multilib_src_compile() {
	mydebug="release"
	if use debug ; then
		mydebug="debug"
	fi
	mystatic="shared"
	if use static; then
		mystatic="static"
	fi

	cd build/
	emake config=${mydebug}${mystatic}lib || die
}

multilib_src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi
	mystatic="Shared"
	if use static; then
		mystatic="Static"
	fi

	cd "build/bin/${mydebug}${mystatic}Lib"

	mkdir -p "${D}/usr/$(get_libdir)"
	cp -a libtheoraplay.so "${D}/usr/$(get_libdir)" || die
}
