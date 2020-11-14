# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Shared CMake functions and macros"
HOMEPAGE="https://github.com/lirios/cmake-shared"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
RDEPEND=">=kde-frameworks/extra-cmake-modules-5.48.0"
DEPEND="${RDEPEND}
	>=dev-util/cmake-3.10.0"
inherit cmake-utils eutils
EGIT_COMMIT="071ec5dbbedafa48fe8d80e9bd627ed318a5014f"
SRC_URI=\
"https://github.com/lirios/cmake-shared/archive/${EGIT_COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
PATCHES=( "${FILESDIR}/${PN}-1.1.0_p20200511-pkgconfig-lib-basename.patch" )
