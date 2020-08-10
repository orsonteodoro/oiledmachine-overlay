# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="CMake modules to help use sanitizers"
HOMEPAGE="https://github.com/arsenm/sanitizers-cmake"
LICENSE="MIT" # project default license
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND=""
DEPEND="${RDEPEND}"
REQUIRED_USE=""
SLOT="0/${PV}"
EGIT_COMMIT="99e159ec9bc8dd362b08d18436bd40ff0648417b"
SRC_URI=\
"https://github.com/arsenm/sanitizers-cmake/archive/${EGIT_COMMIT}.tar.gz
	 -> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake-utils

src_install() {
	insinto /usr/$(get_libdir)/cmake/${PN}
	doins cmake/*
	dodoc LICENSE
	dodoc README.md
}
