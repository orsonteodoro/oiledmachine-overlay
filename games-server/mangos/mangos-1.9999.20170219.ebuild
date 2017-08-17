# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils git-r3 cmake-utils

DESCRIPTION="MaNGOS One for The Burning Crusade (TBC) 2.4.3 Client"
HOMEPAGE="https://www.getmangos.eu/"
LICENSE="GPL-2+"
SLOT="1"
KEYWORDS="~amd64 ~x86"
RDEPEND="
	>=dev-libs/boost-1.49
	>=virtual/mysql-5.1.0
	>=dev-libs/openssl-1.0
	>=sys-libs/zlib-1.2.7
	app-arch/bzip2
	system-ace? ( dev-libs/ace )
	database? ( virtual/mangos-db:${SLOT} )
"
DEPEND="${RDEPEND}
	dev-vcs/git
	>=sys-devel/gcc-4.7.2
	>=dev-util/cmake-2.8.9
       "

IUSE="tools pch sd3 eluna playerbots soap system-ace database"
REQUIRED_USE="!playerbots !system-ace"

S="${WORKDIR}"

src_unpack() {
	EGIT_CHECKOUT_DIR="${WORKDIR}"
	EGIT_REPO_URI="https://github.com/mangosone/server.git"
	#EGIT_BRANCH="release20"
	EGIT_BRANCH="master"
	EGIT_COMMIT="c9565d70c8f2de3a3919e8c48430d9044717266a"
	git-r3_fetch
	git-r3_checkout
}

src_prepare() {
	#epatch "${FILESDIR}/mangos-0-vmap-assembler.patch"
	#epatch "${FILESDIR}/mangos-0-movemap-generator.patch"

	#epatch "${FILESDIR}/mangos-1.9999.20170219-creature-header.patch"
	epatch "${FILESDIR}/mangos-0.9999.20170222-missing-headers-1.patch"
	epatch "${FILESDIR}/mangos-0.9999.20170222-log-header.patch"
	epatch "${FILESDIR}/mangos-0.9999.20170222-objectguid-header.patch"
	epatch "${FILESDIR}/mangos-0.9999.20170222-player-header-1.patch"
	epatch "${FILESDIR}/mangos-0.9999.20170222-player-header-2.patch"
	epatch "${FILESDIR}/mangos-0.9999.20170222-progressbar-header-1.patch"
	epatch "${FILESDIR}/mangos-0.9999.20170222-progressbar-header-2.patch"
	epatch "${FILESDIR}/mangos-0.9999.20170222-lootmgr.patch"
	epatch "${FILESDIR}/mangos-0.9999.20170222-gameobject-header.patch"

	epatch "${FILESDIR}/mangos-0.9999.20170222-algorithm-header.patch"

	epatch "${FILESDIR}/mangos-0.9999.20170222-transform-cast.patch"

	eapply_user
}

src_configure(){
	append-cflags --no-warnings
	append-cxxflags --no-warnings -std=c++11 -Wno-narrowing -Wno-deprecated-register

	local mycmakeargs=(
		-DCONF_DIR=/etc/mangos/1
		-DCMAKE_INSTALL_PREFIX=/usr/games/bin/mangos/1
	)
	if use system-ace ; then
		mycmakeargs+=( -DACE_USE_EXTERNAL=1 )
	else
		mycmakeargs+=( -DACE_USE_EXTERNAL=0 )
	fi
	if use eluna; then
		mycmakeargs+=( -DSCRIPT_LIB_ELUNA=1 )
	else
		mycmakeargs+=( -DSCRIPT_LIB_ELUNA=0 )
	fi
	if use sd3; then
		mycmakeargs+=( -DSCRIPT_LIB_SD3=1 )
	else
		mycmakeargs+=( -DSCRIPT_LIB_SD3=0 )
	fi
	if use tools; then
		mycmakeargs+=( -DBUILD_TOOLS=1 )
	else
		mycmakeargs+=( -DBUILD_TOOLS=0 )
	fi
	if use pch; then
		mycmakeargs+=( -DUSE_COREPCH=1 )
		#mycmakeargs+=( -DUSE_SCRIPTPCH=1 )
		mycmakeargs+=( -DPCH=1 )
		sed -i -e "s|PCH ON|PCH ON|g" CMakeLists.txt
	else
		mycmakeargs+=( -DUSE_COREPCH=0 )
		#mycmakeargs+=( -DUSE_SCRIPTPCH=0 )
		mycmakeargs+=( -DPCH=0 )
		sed -i -e "s|PCH ON|PCH OFF|g" CMakeLists.txt
	fi
	if use playerbots; then
		mycmakeargs+=( -DPLAYERBOTS=1 )
		append-cppflags -I${WORKDIR}/mangos-${PV}_build/src/shared/CMakeFiles
	else
		mycmakeargs+=( -DPLAYERBOTS=0 )
	fi
	if use soap; then
		mycmakeargs+=( -DSOAP=1 )
	else
		mycmakeargs+=( -DSOAP=0 )
	fi

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_test() {
	cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install
}
