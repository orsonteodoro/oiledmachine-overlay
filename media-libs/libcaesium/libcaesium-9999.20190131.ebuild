# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils cmake-utils multilib-minimal multilib-build

DESCRIPTION="The Caesium compression library written in C"
HOMEPAGE="https://github.com/Lymphatus/libcaesium"
COMMIT="978af3b1727520260e018ccabd154a07163139fd"
SRC_URI="https://github.com/Lymphatus/libcaesium/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/mozjpeg
	 app-arch/zopfli"
DEPEND="${RDEPEND}"

S=${WORKDIR}/"${PN}-${COMMIT}"

src_prepare() {
	sed -i -e "s|/opt/mozjpeg/include|/usr/include/libmozjpeg|" CMakeLists.txt
	sed -i -e "s|/usr/include/zopflipng|/usr/include|" CMakeLists.txt
	sed -i -e "s|/opt/mozjpeg/lib64|/usr/lib64|" CMakeLists.txt
	sed -i -e "s|/opt/mozjpeg/lib|/usr/lib|" CMakeLists.txt
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

