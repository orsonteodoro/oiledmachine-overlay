# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${P/lib}
inherit libtool multilib-minimal

DESCRIPTION="Functions for accessing ISO-IEC:14496-1:2001 MPEG-4 standard"
HOMEPAGE="https://code.google.com/p/mp4v2/"
SRC_URI="https://mp4v2.googlecode.com/files/${MY_P}.tar.bz2
	 https://github.com/sergiomb2/libmp4v2/commit/a94a3372c6ef66a2276cc6cd92f7ec07a9c8bb6b.patch -> CVE-2018-14403-fix-libmp4v2.patch
	 https://github.com/sergiomb2/libmp4v2/commit/bb920de948c85e3db4a52292ac7250a50e3bfc86.patch -> CVE-2018-14379-fix-libmp4v2.patch
	 https://github.com/sergiomb2/libmp4v2/commit/3410bc66fb91f46325ab1d008b6a421dd8240949.patch -> CVE-2018-14054-fix-libmp4v2.patch
	 https://github.com/sergiomb2/libmp4v2/commit/9084868fd9f86bee118001c23171e832f15009f4.patch -> CVE-2018-14326--CVE-2018-14446--CVE-2018-14325-fixes-libmp4v2-v3.patch
"

LICENSE="MPL-1.1"
SLOT="0/${PV}"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="static-libs test utils"
RESTRICT="!test? ( test )"

BDEPEND="
	sys-apps/sed
	test? ( dev-util/dejagnu )
	utils? ( sys-apps/help2man )
"

DOCS=( doc/{Authors,BuildSource,Documentation,ReleaseNotes,ToolGuide}.txt README )

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}/${P}-gcc7.patch"
	"${FILESDIR}/${P}-mp4tags-corruption.patch"
	"${FILESDIR}/${P}-clang.patch"
	"${DISTDIR}/CVE-2018-14403-fix-libmp4v2.patch"
	"${DISTDIR}/CVE-2018-14379-fix-libmp4v2.patch"
	"${DISTDIR}/CVE-2018-14054-fix-libmp4v2.patch"
	"${DISTDIR}/CVE-2018-14326--CVE-2018-14446--CVE-2018-14325-fixes-libmp4v2-v3.patch"
)

src_prepare() {
	ewarn "This package upstream currently has no official maintainer."
	ewarn "This package is possibly vulnerable to:"

	# MP4v2
	ewarn "CVE-2018-17236"
	ewarn "CVE-2018-17235"
	ewarn "CVE-2018-14446"
	ewarn "CVE-2018-14403 (applied possible fix)"
	ewarn "CVE-2018-14379 (applied possible fix)"
	ewarn "CVE-2018-14326 (applied possible fix)"
	ewarn "CVE-2018-14325 (applied possible fix)"
	ewarn "CVE-2018-14054 (applied possible fix)"
	ewarn "CVE-2018-7339"

	# make it static to avoid Header checksum mismatch, aborting.
	sed -i -e "s|PROJECT_build=\"\`date\`\"|PROJECT_build=\"$(date)\"|" configure || die
	default
	elibtoolize
	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		--disable-gch \
		$(use_enable utils util) \
		$(use_enable static-libs static)
}

multilib_src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
