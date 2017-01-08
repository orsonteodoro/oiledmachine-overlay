# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils git-2 cmake-utils

DESCRIPTION="MaNGOS Three for Cataclysm (CATA) 4.3.4 Client"
HOMEPAGE="https://www.getmangos.eu/"
LICENSE="GPL-2"
SLOT="3"
KEYWORDS="amd64"
RDEPEND="
	>=dev-libs/boost-1.49
	>=virtual/mysql-5.1.0
	>=dev-util/cmake-2.8.9
	>=dev-libs/openssl-1.0
	>=sys-devel/gcc-4.7.2
	>=sys-libs/zlib-1.2.7
	>=net-libs/zeromq-2.2.6
	app-arch/bzip2
"
IUSE="tools pch sd2 eluna"
S="${WORKDIR}"

src_unpack() {
	EGIT_SOURCEDIR="${WORKDIR}"
	EGIT_REPO_URI="https://github.com/mangosthree/server.git"
	EGIT_BRANCH="Rel20_Newbuild"
	EGIT_COMMIT="f0a64685e0a53804ff5efbc9af0e7c40f2aeb093"
	git-2_src_unpack

	EGIT_SOURCEDIR="${WORKDIR}/src/modules/Eluna"
	EGIT_REPO_URI="https://github.com/ElunaLuaEngine/Eluna.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="5f6417663e395987585466ab62f4fbce7d0a7ba3" #3.20
	#EGIT_COMMIT="9fe397aaf5d89e754467df8a4821e2057d66d9a8" #2.20
	git-2_src_unpack

	epatch "${FILESDIR}/mangos-0-vmap-assembler.patch"
	epatch "${FILESDIR}/mangos-3-object-1.patch"
	epatch "${FILESDIR}/mangos-3-object-2.patch"
	epatch "${FILESDIR}/mangos-3-object-3.patch"
	epatch "${FILESDIR}/mangos-3-object-4-header.patch"
	epatch "${FILESDIR}/mangos-3-object-4-source.patch"
	epatch "${FILESDIR}/mangos-3-log-header.patch"
	epatch "${FILESDIR}/mangos-3-log-source.patch"
	epatch "${FILESDIR}/mangos-3-opcodes.patch"
	epatch "${FILESDIR}/mangos-3-shareddefines.patch"
	epatch "${FILESDIR}/mangos-3-player.patch"
	epatch "${FILESDIR}/mangos-3-objectmgr-header-1.patch"
	epatch "${FILESDIR}/mangos-3-objectmgr-header-2.patch"
	epatch "${FILESDIR}/mangos-3-objectmgr-header-3.patch"
	epatch "${FILESDIR}/mangos-3-objectmgr-source-1.patch"
	epatch "${FILESDIR}/mangos-3-objectmgr-source-2.patch"
	epatch "${FILESDIR}/mangos-3-objectmgr-source-3.patch"
	epatch "${FILESDIR}/mangos-3-common-1.patch"
	epatch "${FILESDIR}/mangos-3-common-2.patch"
	epatch "${FILESDIR}/mangos-3-level2-1.patch"
	epatch "${FILESDIR}/mangos-3-detournavmesh.patch"
	epatch "${FILESDIR}/mangos-3-detournavmeshbuilder.patch"
	epatch "${FILESDIR}/mangos-3-stormlib-cmakelists.patch"
	#epatch "${FILESDIR}/mangos-3-recast-cmakelist.patch"
	epatch "${FILESDIR}/mangos-3-movemap-generator-2.patch"
	epatch "${FILESDIR}/mangos-3-eluna-globalmethods.patch"
	epatch "${FILESDIR}/mangos-3-util-source.patch"
	epatch "${FILESDIR}/mangos-3-util-header.patch"
	epatch "${FILESDIR}/mangos-3-unit-1.patch"
	epatch "${FILESDIR}/mangos-3-unit-2.patch"
	epatch "${FILESDIR}/mangos-3-dbcstore.patch"
	epatch "${FILESDIR}/mangos-3-gridnotifiersimpl.patch"
	epatch "${FILESDIR}/mangos-3-gridnotifiers.patch"
}

src_prepare() {
	epatch_user
}

src_configure() {
	local mycmakeargs=(
		-DCONF_DIR=/etc/mangos/3
		-DCMAKE_INSTALL_PREFIX=/usr/games/bin/mangos/3
	)
	#if use eluna; then
	#	mycmakeargs+=( -DSCRIPT_LIB_ELUNA=1 )
	#else
		mycmakeargs+=( -DSCRIPT_LIB_ELUNA=0 )
	#fi
	if use sd2; then
		mycmakeargs+=( -DSCRIPT_LIB_SD2=1 )
	else
		mycmakeargs+=( -DSCRIPT_LIB_SD2=0 )
	fi
	if use tools; then
		mycmakeargs+=( -DBUILD_TOOLS=1 )
	else
		mycmakeargs+=( -DBUILD_TOOLS=0 )
	fi
	if use pch; then
		mycmakeargs+=( -DUSE_COREPCH=1 )
		mycmakeargs+=( -DUSE_SCRIPTPCH=1 )
		mycmakeargs+=( -DPCH=1 )
	else
		mycmakeargs+=( -DUSE_COREPCH=0 )
		mycmakeargs+=( -DUSE_SCRIPTPCH=0 )
		mycmakeargs+=( -DPCH=0 )
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
