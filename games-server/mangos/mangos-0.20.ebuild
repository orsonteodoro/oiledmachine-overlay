# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils git-r3 cmake-utils flag-o-matic

DESCRIPTION="MaNGOS Zero for the Classic (Vanilla) 1.12.1/2/3 Client"
HOMEPAGE="https://www.getmangos.eu/"
LICENSE="GPL-2+"
SLOT="0"
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
	EGIT_CHECKOUT_DIR="${WORKDIR}"
	EGIT_REPO_URI="https://github.com/mangoszero/server.git"
	#EGIT_BRANCH="release20"
	EGIT_BRANCH="master"
	#EGIT_COMMIT="fd103ef7e7581d2573c17531d13ef074dfea1b2c"
	EGIT_COMMIT="1eb0c33e699a4a65f0d301d1d924df14d6dfff51"
	git-r3_fetch
	git-r3_checkout
}

src_prepare() {
	epatch "${FILESDIR}/mangos-0-vmap-assembler.patch"
	epatch "${FILESDIR}/mangos-0-movemap-generator.patch"
	epatch "${FILESDIR}/mangos-0.20-bihwrap.h.patch"
	epatch "${FILESDIR}/mangos-0.20-cxx11-compat-1.patch"

	eapply_user
}

src_configure(){
	append-cflags -std=gnu99 --no-warnings
	append-cxxflags --no-warnings -std=c++11 -Wno-narrowing -Wno-deprecated-register
	#c++11 broken fstream
	#gnu99

	local mycmakeargs=(
		-DCONF_DIR=/etc/mangos/0
		-DCMAKE_INSTALL_PREFIX=/usr/games/bin/mangos/0
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
		#mycmakeargs+=( -DUSE_SCRIPTPCH=1 )
		mycmakeargs+=( -DPCH=1 )
		sed -i -e "s|PCH ON|PCH ON|g" CMakeLists.txt
	else
		mycmakeargs+=( -DUSE_COREPCH=0 )
		#mycmakeargs+=( -DUSE_SCRIPTPCH=0 )
		mycmakeargs+=( -DPCH=0 )
		sed -i -e "s|PCH ON|PCH OFF|g" CMakeLists.txt
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
