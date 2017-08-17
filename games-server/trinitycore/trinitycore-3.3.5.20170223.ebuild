# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils git-r3 cmake-utils

DESCRIPTION="TrinityCore for the Wrath of the Lich King (WOTLK) Client"
HOMEPAGE="http://www.trinitycore.org/"
LICENSE="GPL-2+"
SLOT="2"
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
	>=sys-devel/gcc-4.7.2
	>=dev-util/cmake-2.8.9
       "

IUSE="+servers tools pch scripts database"

S="${WORKDIR}"

src_unpack() {
	EGIT_CHECKOUT_DIR="${WORKDIR}"
	EGIT_REPO_URI="https://github.com/TrinityCore/TrinityCore.git"
	EGIT_BRANCH="3.3.5"
	EGIT_COMMIT="9934a43e0948b6dfd46bd549e6a1c7028c40e22d"
	git-r3_fetch
	git-r3_checkout
}

src_configure(){
	local mycmakeargs=(
		-DCONF_DIR=/etc/trinitycore/3
		-DCMAKE_INSTALL_PREFIX=/usr/games/bin/trinitycore/3
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
