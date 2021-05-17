# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See CMakeLists.txt for versioning
EAPI=7

inherit eutils cmake-utils multilib-minimal

DESCRIPTION="The Caesium compression library written in C"
HOMEPAGE="https://github.com/Lymphatus/libcaesium"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0/$(ver_cut 1-3 ${PV})"
RDEPEND+=" >=media-libs/mozjpeg-4.0[${MULTILIB_USEDEP}]
	 >=app-arch/zopfli-1.0.2[${MULTILIB_USEDEP}]"
DEPEND+=" ${RDEPEND}"
SRC_URI="
https://github.com/Lymphatus/libcaesium/archive/${PV}.tar.gz
	-> ${P}.tar.gz"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${PV}"
PATCHES=( "${FILESDIR}/${PN}-0.5.2-cmake-fixes.patch" )

src_prepare() {
	cmake-utils_src_prepare
	multilib_copy_sources
}

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/"$(get_libdir)
	)
	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
}

multilib_src_install() {
	cmake-utils_src_install
}
