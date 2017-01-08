# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils git-r3

DESCRIPTION="SkyFire database for the Cataclysm (CATA) 4.0.6a Client"
HOMEPAGE="http://www.projectskyfire.org/"
LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64"
RDEPEND="
	>=dev-libs/boost-1.49
	>=dev-db/mysql-5.1.0
	>=dev-util/cmake-2.8.9
	>=dev-libs/openssl-1.0
	>=sys-devel/gcc-4.7.2
	>=sys-libs/zlib-1.2.7
	>=net-libs/zeromq-2.2.6
	app-arch/bzip2
"
IUSE=""

S="${WORKDIR}"

src_unpack() {
	EGIT_CHECKOUT_DIR="${WORKDIR}"
	EGIT_REPO_URI="https://github.com/SkyFireArchives/SkyFireDB.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="027527c4a2a2ebfdfba239c7ed931064871bac93"
	git-r3_fetch
	git-r3_checkout
}

src_prepare() {
	epatch_user
}

src_install() {
	mkdir -p "${D}/usr/share/skyfire/4"
	cp -R "${WORKDIR}"/* "${D}/usr/share/skyfire/4"
}
