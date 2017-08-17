# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils git-2 cmake-utils

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

IUSE="tools pch sd2 eluna soap system-ace database"
REQUIRED_USE="!system-ace"

S="${WORKDIR}"

src_unpack() {
	EGIT_SOURCEDIR="${WORKDIR}"
	EGIT_REPO_URI="https://github.com/mangosone/server.git"
	#EGIT_BRANCH="release20"
	EGIT_BRANCH="master"
	#EGIT_COMMIT="19b599cae1cdb9580a8558c4ca9ce29ac1492a83"
	#try to repair 0.20 release
	EGIT_COMMIT="32306361ea9b9a93602c69c8541d834193086afe"
	git-2_src_unpack

	EGIT_SOURCEDIR="${WORKDIR}/dep"
	EGIT_REPO_URI="https://github.com/mangos/mangosDeps.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="e5d23bfee52c08188a59598cafb93ba06199ec87"
	git-2_src_unpack

	EGIT_SOURCEDIR="${WORKDIR}/src/realmd"
	EGIT_REPO_URI="https://github.com/mangos/realmd.git"
	EGIT_BRANCH="master"
	#EGIT_COMMIT="bb734144ff9312f519b67892c4f7ef0835c69429"
	EGIT_COMMIT="15df5d42ae03cabe9cebfbd7534df8af4f739ecb"
	git-2_src_unpack

	EGIT_SOURCEDIR="${WORKDIR}/src/modules/Eluna"
	EGIT_REPO_URI="https://github.com/ElunaLuaEngine/Eluna.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="3aba229ceeb138d403e93f0277c803791068bbf1"
	git-2_src_unpack

	EGIT_SOURCEDIR="${WORKDIR}/src/tools/Extractor_projects"
	EGIT_REPO_URI="https://github.com/mangos/Extractor_projects.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT=""
	git-2_src_unpack

}

src_prepare() {
	epatch "${FILESDIR}/mangos-0-vmap-assembler.patch"
	epatch "${FILESDIR}/mangos-0-movemap-generator.patch"
	epatch "${FILESDIR}/mangos-1.20-realmd-revision-header.patch"

	epatch_user
}

src_configure(){
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
