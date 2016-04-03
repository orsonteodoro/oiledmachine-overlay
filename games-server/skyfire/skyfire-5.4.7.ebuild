EAPI=5
inherit eutils git-r3 cmake-utils

DESCRIPTION="SkyFire for the Mists of Pandaria (MOP) Client"
HOMEPAGE="http://www.projectskyfire.org/"
LICENSE="GPL-2"
SLOT="5"
KEYWORDS="amd64"
RDEPEND="
	>=dev-libs/ace-5.8.3
	>=dev-libs/boost-1.49
	>=dev-db/mysql-5.1.0
	>=dev-util/cmake-2.8.9
	>=dev-libs/openssl-0.9.8o
	>=sys-devel/gcc-4.7.2
	>=sys-libs/zlib-1.2.7
	>=net-libs/zeromq-2.2.6
"
SRC_URI="https://github.com/ProjectSkyfire/SkyFire.548/archive/${PV}.tar.gz"
IUSE="+servers tools pch scripts"

S="${WORKDIR}/SkyFire.548-${PV}"
src_unpack() {
	unpack "${A}"
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
