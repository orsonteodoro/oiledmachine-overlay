# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils git-r3 cmake-utils flag-o-matic

DESCRIPTION="CMaNGOS Zero for the Classic (Vanilla) 1.12.1/2/3 Client"
HOMEPAGE="https://www.getmangos.eu/"
LICENSE="GPL-2+"
SLOT="0"
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

IUSE="pch sd2 eluna database"

S="${WORKDIR}"

pkg_setup() {
	if [ -x /usr/bin/gcc-5* ] ; then
		ewarn "If you upgrade gcc from 4 to 5, make sure you re-emerge boost"
	fi
}

src_unpack() {
	EGIT_CHECKOUT_DIR="${WORKDIR}"
	EGIT_REPO_URI="https://github.com/cmangos/mangos-classic.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="1a296847f5eb077de79eddf3591e6c457176a637"
	git-r3_fetch
	git-r3_checkout

	if use sd2; then
		EGIT_CHECKOUT_DIR="${WORKDIR}/src/bindings/sd2"
		EGIT_REPO_URI="https://github.com/scriptdev2/scriptdev2-classic.git"
		EGIT_BRANCH="master"
		EGIT_COMMIT="1ca93aa64023de662ff25ba8f10af230ae165b16"
		git-r3_fetch
		git-r3_checkout
	fi
	if use eluna; then
		EGIT_CHECKOUT_DIR="${WORKDIR}/src/bindings/eluna"
		EGIT_REPO_URI="https://github.com/ElunaLuaEngine/ElunaMangosClassic.git"
		EGIT_BRANCH="master"
		EGIT_COMMIT="cd816aed92e9a68461dee8fc6a2319f46f9cf1a5"
		git-r3_fetch
		git-r3_checkout
	fi
}

src_prepare() {
	epatch "${FILESDIR}/cmangos-0.20170221-cmake-location.patch"

	eapply_user
}

src_configure() {
	#append-cxxflags -D_GLIBCXX_USE_CXX11_ABI=0

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
