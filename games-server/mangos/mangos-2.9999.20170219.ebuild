# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils git-2 cmake-utils

DESCRIPTION="MaNGOS Two for The Wrath of the Lich King (WOTLK) 3.3.5a Client"
HOMEPAGE="https://www.getmangos.eu/"
LICENSE="GPL-2+"
SLOT="2"
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
	EGIT_SOURCEDIR="${WORKDIR}"
	EGIT_REPO_URI="https://github.com/mangostwo/server.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="7caa83ae2d0e910e571821a7d2c6caeb6a99a8d4"
	git-2_src_unpack

	EGIT_SOURCEDIR="${WORKDIR}/dep"
	EGIT_REPO_URI="https://github.com/mangos/mangosDeps.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="417d9a70a5c81803dcb525a180d3b561966251b8"
	git-2_src_unpack

	EGIT_SOURCEDIR="${WORKDIR}/src/realmd"
	EGIT_REPO_URI="https://github.com/mangos/realmd.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="4e06acb429161113014adbe5e3f4cb8276f43db4"
	git-2_src_unpack

	EGIT_SOURCEDIR="${WORKDIR}/src/modules/Eluna"
	EGIT_REPO_URI="https://github.com/ElunaLuaEngine/Eluna.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="a4a6ee223302e93e29c1e39dd30d5e2fdddd1850"
	git-2_src_unpack

	EGIT_SOURCEDIR="${WORKDIR}/src/modules/SD3"
	EGIT_REPO_URI="https://github.com/mangos/ScriptDev3.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="7cc878bd6307b099715f4fa6ae6054280f299dc2"
	git-2_src_unpack

	EGIT_SOURCEDIR="${WORKDIR}/src/tools/Extractor_projects"
	EGIT_REPO_URI="https://github.com/mangos/Extractor_projects.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="5ebd47842c0d36fb267c84ed33646631b7eb084e"
	git-2_src_unpack
}

src_prepare() {
	#epatch "${FILESDIR}/mangos-0-vmap-assembler.patch"
	#epatch "${FILESDIR}/mangos-2-movemap-generator.patch"

	epatch "${FILESDIR}/mangos-0.9999.20170222-algorithm-header.patch"
	epatch "${FILESDIR}/mangos-0.9999.20170222-ace-task_t-header.patch"

	epatch "${FILESDIR}/mangos-0.9999.20170222-transform-cast.patch"

	epatch_user
}

src_configure(){
	local mycmakeargs=(
		-DCONF_DIR=/etc/mangos/2
		-DCMAKE_INSTALL_PREFIX=/usr/games/bin/mangos/2
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
		mycmakeargs+=( -DUSE_SCRIPTPCH=1 )
		mycmakeargs+=( -DPCH=1 )
	else
		mycmakeargs+=( -DUSE_COREPCH=0 )
		mycmakeargs+=( -DUSE_SCRIPTPCH=0 )
		mycmakeargs+=( -DPCH=0 )
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
