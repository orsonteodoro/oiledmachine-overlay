# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils git-r3 cmake-utils toolchain-funcs versionator

DESCRIPTION="TrinityCore for Legion (LG) Client"
HOMEPAGE="http://www.trinitycore.org/"
LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~x86"
RDEPEND="
	>=dev-libs/boost-1.49
	>=virtual/mysql-5.1.0
	>=dev-libs/openssl-1.0
	>=sys-libs/zlib-1.2.7
	>=net-libs/zeromq-2.2.6
	database? ( virtual/trinitycore-db:${SLOT} )
"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-5.1.0
	>=dev-util/cmake-2.8.9
       "

#gcc-4.9.4 has bugged regex_compiler.h

IUSE="+servers tools pch scripts database"

S="${WORKDIR}"

pkg_setup() {
	#put in here for those that use ebuild command
	grep -r -e "std::bitset<1 << (8 \* sizeof(_CharT))>" /usr/lib/gcc/*/*/include/g++-*/bits/regex_compiler.h
	BUGGED="$?"

	if [[ "${BUGGED}" == "0" ]] ; then
		if [ -x /usr/bin/gcc-5* ]; then
			true
		elif [ -x /usr/bin/gcc-6* ]; then
			true
		else
			die "regex_compiler.h is bugged.  Emerge and gcc-config switch to >= gcc 5.1.0 or backport patch.  The patch is commit ec42ae9cd9aa343e82395d901e30d19a5da5bf38 or revision 211143.  The second patch is maybe commit 4f6fa3026c5db251d9bbe1563c1acb148efd052c or revision 218322."
		fi
	fi
}

src_unpack() {
	EGIT_CHECKOUT_DIR="${WORKDIR}"
	EGIT_REPO_URI="https://github.com/TrinityCore/TrinityCore.git"
	#EGIT_BRANCH="6.x"
	EGIT_BRANCH="master"
	EGIT_COMMIT="53e15de4bfef27a137e1a9c3d3c0e4d5d771695f"
	git-r3_fetch
	git-r3_checkout
}

src_configure(){
	local mycmakeargs=(
		-DCONF_DIR=/etc/trinitycore/6
		-DCMAKE_INSTALL_PREFIX=/usr/games/bin/trinitycore/6
	)
	if use scripts; then
		mycmakeargs+=( -DSCRIPTS=1 )
	fi
	if use tools; then
		mycmakeargs+=( -DTOOLS=1 )
	fi
	if use servers; then
		mycmakeargs+=( -DSERVERS=1 )
	fi
	if use pch; then
		mycmakeargs+=( -DUSE_COREPCH=1 )
		mycmakeargs+=( -DUSE_SCRIPTPCH=1 )
	else
		mycmakeargs+=( -DUSE_COREPCH=0 )
		mycmakeargs+=( -DUSE_SCRIPTPCH=0 )
	fi

	cmake-utils_src_configure
}

src_prepare() {
	epatch_user
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
