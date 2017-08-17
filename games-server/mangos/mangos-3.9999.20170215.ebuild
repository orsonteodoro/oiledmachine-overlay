# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils git-2 cmake-utils

DESCRIPTION="MaNGOS Three for Cataclysm (CATA) 4.3.4 Client"
HOMEPAGE="https://www.getmangos.eu/"
LICENSE="GPL-2+"
SLOT="3"
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

IUSE="tools pch sd3 eluna soap playerbots system-ace database"
REQUIRED_USE="!system-ace"

S="${WORKDIR}"

src_unpack() {
	EGIT_SOURCEDIR="${WORKDIR}"
	EGIT_REPO_URI="https://github.com/mangosthree/server.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="4cb9853921b5c663fcefa0088e2f053e73424b5f"
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

	EGIT_SOURCEDIR="${WORKDIR}/src/modules/SD3"
	EGIT_REPO_URI="https://github.com/mangos/ScriptDev3.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="af021823bebb054f99ebfb1ca3a612f29c1aa6dc"
	git-2_src_unpack
}

src_prepare() {
	if false; then
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
	fi

	epatch "${FILESDIR}/mangos-0.9999.20170222-algorithm-header.patch"
	#epatch "${FILESDIR}/mangos-0.9999.20170222-ace-task_t-header.patch"

	epatch "${FILESDIR}/mangos-0.9999.20170222-transform-cast.patch"

	epatch_user
}

src_configure() {
	local mycmakeargs=(
		-DCONF_DIR=/etc/mangos/3
		-DCMAKE_INSTALL_PREFIX=/usr/games/bin/mangos/3
	)
	if use system-ace ; then
		mycmakeargs+=( -DACE_USE_EXTERNAL=1 )
	else
		mycmakeargs+=( -DACE_USE_EXTERNAL=0 )
	fi
	#if use eluna; then
	#	mycmakeargs+=( -DSCRIPT_LIB_ELUNA=1 )
	#else
		mycmakeargs+=( -DSCRIPT_LIB_ELUNA=0 )
	#fi
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
