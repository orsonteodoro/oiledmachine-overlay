# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils git-r3 cmake-utils

DESCRIPTION="SkyFire for the Mists of Pandaria (MOP) Client"
HOMEPAGE="http://www.projectskyfire.org/"
LICENSE="GPL-3+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
RDEPEND="
	>=dev-libs/ace-5.8.3
	>=virtual/mysql-5.1.0
	>=dev-libs/openssl-1.0.0
	>=sys-libs/zlib-1.2.7
	sys-libs/readline
	app-arch/bzip2
"
DEPEND="${RDEPEND}
	dev-vcs/git
	>=sys-devel/gcc-4.7.2
	>=dev-util/cmake-2.8.9
	"
IUSE="+servers tools pch scripts"

S="${WORKDIR}"

src_unpack() {
	EGIT_CHECKOUT_DIR="${WORKDIR}"
	EGIT_REPO_URI="https://github.com/ProjectSkyfire/SkyFire.548.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="7775943f0d53d0318b3ec294dd1a0778c6ddc24d"
	git-r3_fetch
	git-r3_checkout
}

src_prepare() {
	epatch "${FILESDIR}/skyfire-5.4.8-world-header.patch"
	eapply_user
}

src_configure(){
	local mycmakeargs=(
                -DCONF_DIR=/etc/skyfire/5
                -DCMAKE_INSTALL_PREFIX=/usr/games/bin/skyfire/5
	)
	if use scripts; then
		mycmakeargs+=( -DSCRIPTS=1 )
	else
		mycmakeargs+=( -DSCRIPTS=0 )
	fi
	if use tools; then
		mycmakeargs+=( -DTOOLS=1 )
	else
		mycmakeargs+=( -DTOOLS=0 )
	fi
	if use servers; then
		mycmakeargs+=( -DSERVERS=1 )
	else
		mycmakeargs+=( -DSERVERS=0 )
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

src_compile() {
	cmake-utils_src_compile
}

src_test() {
	cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install
}
