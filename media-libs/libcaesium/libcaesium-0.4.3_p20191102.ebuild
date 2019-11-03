# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# See CMakeLists.txt for versoning
EAPI=7
DESCRIPTION="The Caesium compression library written in C"
HOMEPAGE="https://github.com/Lymphatus/libcaesium"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
inherit eutils cmake-utils multilib-minimal
EGIT_COMMIT="978af3b1727520260e018ccabd154a07163139fd"
SRC_URI=\
"https://github.com/Lymphatus/libcaesium/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
SLOT="0/${PV}"
RDEPEND="media-libs/mozjpeg
	 app-arch/zopfli"
DEPEND="${RDEPEND}"
RESTRICT="mirror"
S=${WORKDIR}/"${PN}-${EGIT_COMMIT}"

src_prepare() {
	sed -i -e "s|/opt/mozjpeg/include|/usr/include/libmozjpeg|" \
		CMakeLists.txt || die
	sed -i -e "s|/usr/include/zopflipng|/usr/include|" CMakeLists.txt || die
	sed -i -e "s|/opt/mozjpeg/lib64|/usr/lib64|" CMakeLists.txt || die
	sed -i -e "s|/opt/mozjpeg/lib|/usr/lib|" CMakeLists.txt || die
	sed -i -e "s|jpeg jpeg|mozjpeg mozjpeg|" caesium/CMakeLists.txt || die
	sed -i -e "s|/opt/mozjpeg/lib|/usr/lib|" caesium/CMakeLists.txt || die
	sed -i -e "s|caesium jpeg|caesium mozjpeg|" caesium/CMakeLists.txt \
		|| die
	cmake-utils_src_prepare
	multilib_copy_sources
}

multilib_src_configure() {
	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
}

multilib_src_install() {
	cmake-utils_src_install
}

