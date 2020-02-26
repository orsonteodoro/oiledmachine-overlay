# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See CMakeLists.txt for versioning
EAPI=7
DESCRIPTION="Caesium Command Line Tools - Lossy/lossless image compression tool\
 using mozjpeg and zopflipng"
HOMEPAGE="http://saerasoft.com/caesium/clt"
LICENSE="all-rights-reserved Apache-2.0 Unlicense BSD-2"
# The licenses are for internal dependencies
# optparse - Unlicense
# tinydir - BSD-2
# README.md, package - all-rights-reserved
EGIT_COMMIT="50952c1860f3dddfedca26ed311f483fdce6766d"
GITHUB_HOMEPAGE="https://github.com/Lymphatus/caesium-clt"
FN_DEST="${PN}-${EGIT_COMMIT}.zip"
FN_SRC="${EGIT_COMMIT}.zip"
SRC_URI=\
"${GITHUB_HOMEPAGE}/archive/${FN_SRC} \
	-> ${FN_DEST}"
inherit eutils cmake-utils
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="media-libs/libcaesium:0/$(ver_cut 1-3 ${PV})"
DEPEND="${RDEPEND}"
RESTRICT="fetch mirror"
S="${WORKDIR}/caesium-clt-${EGIT_COMMIT}"

pkg_nofetch() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	local homepage="${GITHUB_HOMEPAGE}/tree/${EGIT_COMMIT}"
	einfo "Please download"
	einfo "  - ${FN_SRC}"
	einfo "from ${homepage} and rename it to ${FN_DEST} place it in ${distdir}"
	einfo "or do \`wget -O ${distdir}/${FN_DEST} ${GITHUB_HOMEPAGE}/archive/${FN_SRC}\`"
}
