# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils git-r3 cmake-utils

DESCRIPTION="CMaNGOS Zero for the Classic (Vanilla) 1.12.1/2/3 Client"
HOMEPAGE="https://www.getmangos.eu/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
RDEPEND="
	dev-libs/ace
	dev-cpp/tbb
	>=dev-libs/boost-1.49
	>=virtual/mysql-5.1.0
	>=dev-util/cmake-2.8.9
	>=dev-libs/openssl-1.0
	>=sys-devel/gcc-4.7.2
	>=sys-libs/zlib-1.2.7
	>=net-libs/zeromq-2.2.6
	app-arch/bzip2
	virtual/cmangos-db:0
"
IUSE="pch sd2 eluna"

S="${WORKDIR}"

src_unpack() {
	EGIT_CHECKOUT_DIR="${WORKDIR}"
	EGIT_REPO_URI="https://github.com/cmangos/mangos-classic.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="b43302c3f43569187d90d12477aaad4d000516d7"
	git-r3_fetch
	git-r3_checkout
	eapply "${FILESDIR}/mangos-4-cmake-location.patch"

	if use sd2; then
		EGIT_CHECKOUT_DIR="${WORKDIR}/src/bindings/sd2"
		EGIT_REPO_URI="https://github.com/scriptdev2/scriptdev2-classic.git"
		EGIT_BRANCH="master"
		EGIT_COMMIT="2514f61417dc0b1a72c94355d958ac28a7230658"
		git-r3_fetch
		git-r3_checkout
	fi
	if use eluna; then
		EGIT_CHECKOUT_DIR="${WORKDIR}/src/bindings/eluna"
		EGIT_REPO_URI="https://github.com/ElunaLuaEngine/ElunaMangosClassic.git"
		EGIT_BRANCH="master"
		EGIT_COMMIT="38a921e92be5861ace72dbc2a77bedf6bb66f04c"
		git-r3_fetch
		git-r3_checkout
	fi
}

src_prepare() {
	eapply_user
}

src_configure() {
	local mycmakeargs=(
		-DCONF_DIR=/etc/cmangos/0
		-DCMAKE_INSTALL_PREFIX=/usr/games/bin/cmangos/0
		-DTBB_USE_EXTERNAL=1
		-DACE_USE_EXTERNAL=1
	)
	if use sd2; then
		mycmakeargs+=( -DINCLUDE_BINDINGS_DIR=sd2 )
	fi
	if use eluna; then
		mycmakeargs+=( -DINCLUDE_BINDINGS_DIR=eluna )
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
	fperms 0755 "/usr/games/bin/cmangos/0/bin/run-mangosd"
	mkdir -p "${D}/usr/share/cmangos/0/sql"
	mkdir -p "${D}/usr/share/cmangos/0/sql/sd2"
	cp -R "${WORKDIR}"/sql/* "${D}/usr/share/cmangos/0/sql"
	cp -R "${WORKDIR}"/src/bindings/sd2/sql/* "${D}/usr/share/cmangos/0/sql/sd2"
}

pkg_postinst() {
	echo ""
	echo "Use cmangos-db to install the databases."
	echo ""
}
