# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See CMakeLists.txt for versioning
EAPI=7

inherit cmake-utils eutils git-r3

DESCRIPTION="Caesium Command Line Tools - Lossy/lossless image compression tool \
using mozjpeg and zopflipng"
HOMEPAGE="http://saerasoft.com/caesium/clt"
LICENSE="Apache-2.0 Unlicense BSD-2"
# The licenses are for internal dependencies
# optparse - Unlicense
# tinydir - BSD-2
# README.md, package - all-rights-reserved (The vanilla Apache-2.0 doesn't have all rights reserved)
EGIT_REPO_URI="https://github.com/Lymphatus/caesium-clt.git"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="r1"
RDEPEND=">=media-libs/libcaesium-0.6.0"
DEPEND="${RDEPEND}"
RESTRICT="fetch mirror"
S="${WORKDIR}/${P}"

src_prepare() {
	default
	local v_major=$(grep "VERSION_MAJOR" "${S}/CMakeLists.txt" \
		| cut -f 2 -d " " \
		| grep -E -o -e "[0-9]+")
	local v_minor=$(grep "VERSION_MINOR" "${S}/CMakeLists.txt" \
		| cut -f 2 -d " " \
		| grep -E -o -e "[0-9]+")
	local v_patch=$(grep "VERSION_PATCH" "${S}/CMakeLists.txt" \
		| cut -f 2 -d " " \
		| grep -E -o -e "[0-9]+")
	local v="${v_major}.${v_minor}.${v_patch}"
	local v_expected=$(ver_cut 1-3 "${PV}")
	if [[ "${v}" != "${v_expected}" ]] ; then
eerror
eerror "Version bump required"
eerror
eerror "Expected PV:  ${v_expected}"
eerror "Found PV:  ${v}"
eerror
		die
	fi
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLIBCAESIUM_PATH=/usr/$(get_libdir)
	)
	cmake-utils_src_configure
}
