# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See CMakeLists.txt for versoning
EAPI=7
DESCRIPTION="The Caesium compression library written in C"
HOMEPAGE="https://github.com/Lymphatus/libcaesium"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
inherit eutils cmake-utils multilib-minimal
EGIT_COMMIT="bc971e6023a5b29b235d50d560c8feea8f31df3d"
SRC_URI=\
"https://github.com/Lymphatus/libcaesium/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
SLOT="0/${PV}"
RDEPEND=">=media-libs/mozjpeg-3.3.1[${MULTILIB_USEDEP}]
	 >=app-arch/zopfli-1.0.2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
RESTRICT="mirror"
S=${WORKDIR}/"${PN}-${EGIT_COMMIT}"

PATCHES=( "${FILESDIR}/libcaesium-0.5.0_p20191223-cmake-fixes.patch" )

src_prepare() {
	cmake-utils_src_prepare
	multilib_copy_sources
}

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}"/usr/$(get_libdir)
	)
	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
}

multilib_src_install() {
	cmake-utils_src_install
}

