# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils eutils

DESCRIPTION="Shared CMake functions and macros"
HOMEPAGE="https://github.com/lirios/cmake-shared"
LICENSE="BSD"

# Live/snapshots do not get KEYWORDS.

SLOT="0/$(ver_cut 1-3 ${PV})"
DEPEND+=" >=kde-frameworks/extra-cmake-modules-5.48.0"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" >=dev-util/cmake-3.10.0"
EGIT_COMMIT="89d685cc6d448fe5c516ff80f1410be5feccc109"
SRC_URI="
https://github.com/lirios/cmake-shared/archive/${EGIT_COMMIT}.tar.gz
	-> ${CATEGORY}-${PN}-${PV}-${EGIT_COMMIT:0:7}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
PATCHES=( "${FILESDIR}/${PN}-1.1.0_p20200511-pkgconfig-lib-basename.patch" )
