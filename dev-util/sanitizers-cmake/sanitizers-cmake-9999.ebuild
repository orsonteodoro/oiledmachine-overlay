# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake git-r3

DESCRIPTION="CMake modules to help use sanitizers"
HOMEPAGE="https://github.com/arsenm/sanitizers-cmake"
LICENSE="MIT" # project default license

# Live ebuilds don't get KEYWORDed

SLOT="0/$(ver_cut 1-2 ${PV})"
if [[ ${PV} =~ 9999 ]] ; then
	IUSE+=" fallback-commit"
else
	SRC_URI="
https://github.com/arsenm/sanitizers-cmake/archive/${EGIT_COMMIT}.tar.gz
	 -> ${P}.tar.gz
	"
fi
RESTRICT="mirror"

src_unpack() {
	if [[ ${PV} =~ 9999 ]] ; then
		use fallback-commit && EGIT_COMMIT="a6748f4f51273d86312e3d27ebe5277c9b1ff870" # Dec 29, 2022
		EGIT_REPO_URI="https://github.com/arsenm/sanitizers-cmake.git"
		EGIT_BRANCH="master"
		git-r3_fetch
		git-r3_checkout
		S="${WORKDIR}/${PN}-9999"
	else
		unpack ${A}
		S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
	fi
}

src_install() {
	insinto /usr/$(get_libdir)/cmake/${PN}
	doins cmake/*
	dodoc LICENSE
	dodoc README.md
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-REVDEP:  AppImageKit
