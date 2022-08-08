# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DESCRIPTION="CMake modules to help use sanitizers"
HOMEPAGE="https://github.com/arsenm/sanitizers-cmake"
LICENSE="MIT" # project default license

# Live ebuilds don't get KEYWORDed

SLOT="0/${PV}"
EGIT_COMMIT="99e159ec9bc8dd362b08d18436bd40ff0648417b"
SRC_URI=\
"https://github.com/arsenm/sanitizers-cmake/archive/${EGIT_COMMIT}.tar.gz
	 -> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake

src_install() {
	insinto /usr/$(get_libdir)/cmake/${PN}
	doins cmake/*
	dodoc LICENSE
	dodoc README.md
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-REVDEP:  AppImageKit
