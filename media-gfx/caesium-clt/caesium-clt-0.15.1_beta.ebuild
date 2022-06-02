# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See CMakeLists.txt for versioning
EAPI=7
DESCRIPTION="Caesium Command Line Tools - Lossy/lossless image compression tool \
using mozjpeg and zopflipng"
HOMEPAGE="http://saerasoft.com/caesium/clt"
LICENSE="all-rights-reserved Apache-2.0 Unlicense BSD-2"
# The licenses are for internal dependencies
# optparse - Unlicense
# tinydir - BSD-2
# README.md, package - all-rights-reserved (The vanilla Apache-2.0 doesn't have all rights reserved)
GH_HOMEPAGE="https://github.com/Lymphatus/caesium-clt"
FN_SRC="v.$(ver_cut 1-3 ${PV}).tar.gz"
FN_DEST="${P}.tar.gz"
SRC_URI="
https://github.com/Lymphatus/caesium-clt/archive/refs/tags/${FN_SRC}
	-> ${FN_DEST}"
inherit eutils cmake-utils
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="
	>=media-libs/libcaesium-0.5.0
	<media-libs/libcaesium-0.16.0
"
DEPEND="${RDEPEND}"
RESTRICT="fetch mirror"
S="${WORKDIR}/caesium-clt-${EGIT_COMMIT}"

pkg_nofetch() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	local dl_url="${GH_HOMEPAGE}/archive/refs/tags/${FN_SRC}"
	einfo "Please download"
	einfo "  - ${FN_SRC}"
	einfo "from ${GH_HOMEPAGE}/tags and rename it to ${FN_DEST} place it in ${distdir}"
	einfo "or do \`wget -O ${distdir}/${FN_DEST} ${dl_url}\`"
}
