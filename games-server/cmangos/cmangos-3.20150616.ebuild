# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils git-r3 cmake-utils

DESCRIPTION="CMaNGOS Three for Cataclysm (CATA) 4.3.4 Client"
HOMEPAGE="https://www.getmangos.eu/"
LICENSE="GPL-2+"
SLOT="3"
KEYWORDS="~amd64 ~x86"
RDEPEND="
	dev-libs/ace
	dev-cpp/tbb
	>=dev-libs/boost-1.49
	>=virtual/mysql-5.1.0
	>=dev-libs/openssl-1.0
	>=sys-libs/zlib-1.2.7
	database? ( virtual/cmangos-db:${SLOT} )
"
DEPEND="${RDEPEND}
	dev-vcs/git
	>=sys-devel/gcc-4.7.2
	>=dev-util/cmake-2.8.9
       "

IUSE="pch sd2 database"
S="${WORKDIR}"

pkg_setup() {
	if [ -x /usr/bin/gcc-5* ] ; then
		ewarn "If you upgrade gcc from 4 to 5, make sure you re-emerge boost"
	fi
}

src_unpack() {
	EGIT_CHECKOUT_DIR="${WORKDIR}"
	EGIT_REPO_URI="https://github.com/cmangos/mangos-cata.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="25f81faa9bfc21aab8f0dc38c4c5c3d983b4e015"
	git-r3_fetch
	git-r3_checkout

	if use sd2; then
		EGIT_CHECKOUT_DIR="${WORKDIR}/src/bindings/sd2"
		EGIT_REPO_URI="https://github.com/scriptdev2/scriptdev2-cata.git"
		EGIT_BRANCH="master"
		EGIT_COMMIT="03f1ceefac0420e5ee2fb6e316c7d6d196c3e66f"
		git-r3_fetch
		git-r3_checkout
	fi
}

src_prepare() {
	epatch "${FILESDIR}/mangos-4-cmake-location.patch"
	epatch "${FILESDIR}/cmangos-3.20150616-missing-headers.patch"

	eapply_user
}

src_configure(){
	local mycmakeargs=(
		-DCONF_DIR=/etc/cmangos/3
		-DCMAKE_INSTALL_PREFIX=/usr/games/bin/cmangos/3
		-DTBB_USE_EXTERNAL=1
		-DACE_USE_EXTERNAL=1
	)
	if use sd2; then
		mycmakeargs+=( -DINCLUDE_BINDINGS_DIR=sd2 )
	fi
	if use pch; then
		mycmakeargs+=( -DPCH=1 )
	else
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
	fperms 0755 "/usr/games/bin/cmangos/3/bin/run-mangosd"
	mkdir -p "${D}/usr/share/cmangos/3/sql"
	mkdir -p "${D}/usr/share/cmangos/3/sql/sd2"
	cp -R "${WORKDIR}"/sql/* "${D}/usr/share/cmangos/3/sql"
	cp -R "${WORKDIR}"/src/bindings/sd2/sql/* "${D}/usr/share/cmangos/3/sql/sd2"
}

pkg_postinst() {
	echo ""
	echo "Use cmangos-db-3 to install the databases."
	echo ""
}
