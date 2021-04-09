# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A library that simplifies native UI engineering on the Linux \
desktop"
HOMEPAGE="https://github.com/TheAssassin/libdesktopenvironments"
LICENSE="MIT" # project's default license

# Live ebuilds don't get keyworded

SLOT="0/${PV}"
IUSE="demo"
EGIT_COMMIT="c5128a97a6fc34175ed0be604511efce32adc45d"
SRC_URI=\
"https://github.com/TheAssassin/libdesktopenvironments/archive/${EGIT_COMMIT}.tar.gz
	 -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake-utils

src_install() {
	insinto /usr/include
	doins -r include/desktopenvironments.h
	dolib.so "${BUILD_DIR}/src/libdesktopenvironments.so"
	docinto licenses
	dodoc LICENSE
	docinto readmes
	dodoc README.md
	if use demo ; then
		exeinto /usr/bin
		doexe "${BUILD_DIR}/libde_demo"
	fi
}
