# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See README.chromium or include/libyuv/version.h for lib version

EAPI=8

inherit cmake multilib-minimal git-r3

DESCRIPTION="libyuv is an open source project that includes YUV scaling and \
conversion functionality."
HOMEPAGE="https://chromium.googlesource.com/libyuv/libyuv/"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
GIT_BRANCHES="+main stable"
IUSE+="
	${GIT_BRANCHES}
	fallback-commit static system-gflags test
"
REQUIRED_USE+="
	^^ (
		main
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
c4abf7602876c86bf9b75f6b8e2f663dc71c1438e4fa3d0ced829781d395e294\
"
		use fallback-commit && export EGIT_COMMIT="eb6e7bb63738e29efd82ea3cf2a115238a89fa51"
	elif use main ; then
		EGIT_BRANCH="main"
		expected="\
adf02ccbaa212eed8d8ab371c6331378c7936f4004ae25bfb42a5d34d9158f79\
97e45db859ba2cba4335ceb139bafe74e02064dc09a339fed333b3ced68bd6d0\
"
		use fallback-commit && export EGIT_COMMIT="3abd6f36b6e4f5a2e0ce236580a8bc1da3c7cf7e"
	fi
	git-r3_fetch
	git-r3_checkout
	actual=$(get_hash)
	if [[ "${expected}" != "${actual}" ]] ; then
eerror
eerror "The build files has changed.  This means that either a change in"
eerror "dependencies, supported arches, ABI, config options, etc."
eerror
eerror "This means that the ebuild packager needs to update the *DEPENDS,"
eerror "IUSE, KEYWORDS.  Send an issue request about this."
eerror
eerror "Expected build files fingerprint:\t${expected}"
eerror "Actual build files fingerprint:\t${actual}"
eerror
		die
	fi
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
