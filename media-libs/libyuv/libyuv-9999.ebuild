# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See README.chromium or include/libyuv/version.h for lib version

EAPI=8

inherit cmake multilib-minimal git-r3

DESCRIPTION="libyuv is an open source project that includes YUV scaling and \
conversion functionality."
HOMEPAGE="https://chromium.googlesource.com/libyuv/libyuv/"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
SLOT="0/${PV}"
GIT_BRANCHES="+main master stable"
IUSE+="
	${GIT_BRANCHES}
	static system-gflags test
"
REQUIRED_USE+="
	^^ (
		main
		master
		stable
	)
"
RDEPEND+="
	virtual/jpeg[${MULTILIB_USEDEP}]
	virtual/libc
"
DEPEND+="
	${RDEPEND}
	test? (
		dev-cpp/gflags[${MULTILIB_USEDEP}]
		dev-cpp/gtest[${MULTILIB_USEDEP}]
	)
"
BDEPEND+="
	stable? (
		>=dev-util/cmake-2.8
	)
	!stable? (
		>=dev-util/cmake-2.8.12
	)
	sys-apps/grep[pcre]
"
SRC_URI=""
S="${WORKDIR}/${P}"
EGIT_REPO_URI="https://chromium.googlesource.com/libyuv/libyuv"
PATCHES=(
	"${FILESDIR}/${PN}-1741-cmake-libdir.patch"
)
DOCS=( AUTHORS LICENSE PATENTS README.chromium README.md )

get_hash() {
	cat $(find "${WORKDIR}/libyuv-9999" \
		-name "*.cmake" \
		-o -name "CMakeLists.txt" \
		-o -name "*.cmake" \
			| sort) \
		| sha512sum \
		| cut -f 1 -d " "
}

src_unpack() {
	# clone uses main
	if use stable ; then
		EGIT_BRANCH="stable"
		expected="\
d598ee724bf56ae04ed475987d4e8780e302be56a5e98dd284225069bb54caf9\
c4abf7602876c86bf9b75f6b8e2f663dc71c1438e4fa3d0ced829781d395e294"
	elif use master ; then
		EGIT_BRANCH="master"
		expected="\
d598ee724bf56ae04ed475987d4e8780e302be56a5e98dd284225069bb54caf9\
c4abf7602876c86bf9b75f6b8e2f663dc71c1438e4fa3d0ced829781d395e294"
	elif use main ; then
		EGIT_BRANCH="main"
		expected="\
087f42d76101c61ea91db87a052c8f53394a18875e8535d5e349fe586bcaca78\
dea5d9746a82a88d9ccf9eb9120d7f65c55150fb7bac480da3f3ea92d83e0208"
	fi
	git-r3_fetch
	git-r3_checkout
	actual=$(get_hash)
	if [[ "${expected}" != "${actual}" ]] ; then
eerror
eerror "The build files has changed.  This means that either a change in"
eerror "dependencies, supported arches, ABI, etc."
eerror
eerror "This means that the ebuild packager needs to update the *DEPENDS or"
eerror "KEYWORDS.  Send an issue request about this."
eerror
eerror "Expected build files fingerprint:  ${expected}"
eerror "Actual build files fingerprint:  ${actual}"
eerror
		die
	fi
}

src_prepare() {
	cmake_src_prepare
	multilib_copy_sources
}

multilib_src_configure() {
	local mycmakeargs=( )
	use test && mycmakeargs+=( -DTEST=ON )
	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile
}

multilib_src_install() {
	cmake_src_install
	insinto /usr/$(get_libdir)/pkgconfig
	cat "${FILESDIR}/${PN}.pc.in" | \
	sed \
		-e "s|@prefix@|/usr|" \
		-e "s|@exec_prefix@|\${prefix}|" \
		-e "s|@libdir@|/usr/$(get_libdir)|" \
		-e "s|@includedir@|\${prefix}/include|" \
		-e "s|@version@|${PV}|" > "${T}/${PN}.pc" \
		|| die
	doins "${T}/${PN}.pc"
	cd "${S}" || die
	einstalldocs
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multilib
# OILEDMACHINE-OVERLAY-META-REVDEP:  xpra
