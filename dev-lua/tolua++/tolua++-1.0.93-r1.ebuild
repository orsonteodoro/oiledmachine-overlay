# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit eutils toolchain-funcs git-r3 cmake-utils

MY_P=${P/pp/++}

DESCRIPTION="A tool to integrate C/C++ code with Lua"
HOMEPAGE="http://www.codenix.com/~tolua/"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE="static-libs urho3d debug"

RESTRICT="fetch"

RDEPEND="dev-lang/lua:5.2"
DEPEND="${RDEPEND}
	dev-util/cmake
	sys-apps/util-linux"

S=${WORKDIR}/${MY_P}

src_unpack() {
        EGIT_REPO_URI="https://github.com/waltervn/toluapp.git"
        EGIT_BRANCH="master"
        EGIT_COMMIT="51831803cdd0ddf72d9ccd54f6b111cf839ea157"
        git-r3_fetch
        git-r3_checkout
}

src_prepare() {
	if use urho3d ; then
		eapply "${FILESDIR}"/tolua++-1.0.93-urho3d-1.patch || die "failed to add urho3d extension 1"
	fi
	if use static-libs; then
		true
	else
		sed -i -e "s|add_library(libtolua++|add_library(libtolua++ SHARED|" src/lib/CMakeLists.txt
	fi

	eapply_user

	cmake-utils_src_prepare
}

src_configure() {
        local mycmakeargs=( )

	if ! use debug ; then
		mycmakeargs+=( -DTOLUA_RELEASE=1 )
	fi

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	#cmake-utils_src_install
	mkdir -p "${D}/usr/bin"
	mkdir -p "${D}/usr/include"
	mkdir -p "${D}/usr/$(get_libdir)"
	cd "${WORKDIR}/tolua++-1.0.93_build/bin"
	cp "tolua++" "${D}/usr/bin" || die

	cd "${WORKDIR}/tolua++-1.0.93_build/lib"
	if use static-libs; then
		cp "libtolua++.a" "${D}/usr/$(get_libdir)" || die
	else
		cp "libtolua++.so" "${D}/usr/$(get_libdir)" || die
	fi

	cd "${WORKDIR}/tolua++-1.0.93/include"
	cp "tolua++.h" "${D}/usr/include" || die

	cd "${WORKDIR}/tolua++-1.0.93"
	dodoc README
}
