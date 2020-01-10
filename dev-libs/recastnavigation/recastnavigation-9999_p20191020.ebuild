# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Navigation-mesh Toolset for Games"
HOMEPAGE="https://github.com/memononen/recastnavigation"
LICENSE="zlib"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
SLOT="0/${PV}"
IUSE="debug demo examples static test"
inherit cmake-multilib multilib-minimal
RDEPEND="demo? ( media-libs/libsdl2[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-8.0"
inherit eutils toolchain-funcs
EGIT_COMMIT="57610fa6ef31b39020231906f8c5d40eaa8294ae"
SRC_URI="\
https://github.com/${PN}/${PN}/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
PATCHES=( "${FILESDIR}/recastnavigation-9999-custom-cmake-multilib-path.patch" )

pkg_setup() {
	GCC_V=$(gcc-fullversion)
	if ver_test ${GCC_V} -lt "8.0" ; then
		die "You need at least gcc 8.0 to compile."
	fi
}

src_configure() {
	mycmakeargs=(
		-DRECASTNAVIGATION_DEMO=$(usex demo)
		-DRECASTNAVIGATION_TESTS=$(usex test)
		-DRECASTNAVIGATION_EXAMPLES=$(usex examples)
		-DRECASTNAVIGATION_STATIC=$(usex static)
	)
	cmake-multilib_src_configure
}

src_compile() {
	cmake-multilib_src_compile
}

src_install() {
	cmake-multilib_src_install
}
