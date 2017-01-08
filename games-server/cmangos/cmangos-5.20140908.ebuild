# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils git-r3 cmake-utils

DESCRIPTION="CMaNGOS Four for the Warlords of Draenor (WOD) 6.x Client"
HOMEPAGE="https://www.getmangos.eu/"
LICENSE="GPL-2"
SLOT="5"
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
"
IUSE="pch"

S="${WORKDIR}"

src_unpack() {
	EGIT_CHECKOUT_DIR="${WORKDIR}"
	EGIT_REPO_URI="https://github.com/cmangos/cmangos-wod.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="0df869c4ed0c0a3e843e44a93856b7a6b0d54ba8"
	git-r3_fetch
	git-r3_checkout
	eapply "${FILESDIR}/mangos-4-cmake-location.patch"
}

src_prepare() {
	eapply_user
}

src_configure() {
	local mycmakeargs=(
		-DCONF_DIR=/etc/cmangos/5
		-DCMAKE_INSTALL_PREFIX=/usr/games/bin/cmangos/5
		-DTBB_USE_EXTERNAL=1
		-DACE_USE_EXTERNAL=1
	)
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
	fperms 0755 "/usr/games/bin/cmangos/5/bin/run-mangosd"
	mkdir -p "${D}/usr/share/cmangos/5/sql"
	cp -R "${WORKDIR}"/sql/* "${D}/usr/share/cmangos/5/sql"
}

pkg_postinst() {
	echo ""
	echo "Use cmangos-db-5 to install the databases."
	echo ""
}
