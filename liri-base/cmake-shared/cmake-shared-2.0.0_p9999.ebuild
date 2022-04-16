# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3 eutils

DESCRIPTION="Shared CMake functions and macros"
HOMEPAGE="https://github.com/lirios/cmake-shared"
LICENSE="BSD"

# Live/snapshots do not get KEYWORDS.

SLOT="0/$(ver_cut 1-3 ${PV})"
DEPEND+=" >=kde-frameworks/extra-cmake-modules-5.48.0"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" >=dev-util/cmake-3.10.0"
SRC_URI=""
RESTRICT="fetch mirror"
PATCHES=( "${FILESDIR}/${PN}-1.1.0_p20200511-pkgconfig-lib-basename.patch" )
EGIT_BRANCH="develop"
EGIT_REPO_URI="https://github.com/lirios/cmake-shared.git"
S="${WORKDIR}/${P}"
PROPERTIES="live"

src_unpack() {
	git-r3_fetch
	git-r3_checkout
	local v_live=$(grep -r -e "VERSION \"" "${S}/CMakeLists.txt" | cut -f 2 -d "\"")
	local v_expected=$(ver_cut 1-3 ${PV})
	if ver_test ${v_expected} -ne ${v_live} ; then
		eerror
		eerror "Version bump required."
		eerror
		eerror "v_expected=${v_expected}"
		eerror "v_live=${v_live}"
		eerror
		die
	else
		einfo
		einfo "v_expected=${v_expected}"
		einfo "v_live=${v_live}"
		einfo
	fi
}
