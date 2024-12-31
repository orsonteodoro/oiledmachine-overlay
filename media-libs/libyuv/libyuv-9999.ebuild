# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See README.chromium or include/libyuv/version.h for lib version

EAPI=8

STABLE_EXPECTED_FINGERPRINT="\
d598ee724bf56ae04ed475987d4e8780e302be56a5e98dd284225069bb54caf9\
c4abf7602876c86bf9b75f6b8e2f663dc71c1438e4fa3d0ced829781d395e294\
"
STABLE_FALLBACK_COMMIT="eb6e7bb63738e29efd82ea3cf2a115238a89fa51" # Wed Apr 28 15:34:12 2021

MAIN_EXPECTED_FINGERPRINT="\
1fc5a055711f8a10f8cee3dff1c574bad289fbcdd7aee15681c95ce1a55d2620\
c86dc4c94f7dc3d64b7ee5667a31823dffae04937ce8902c2f3eb0bfcb1db4fe\
"
MAIN_FALLBACK_COMMIT="8e18fc93c8c07d2ba6f9671281d6f35c8c47b2f4" # Tue May 21 15:55:24 2024

inherit cmake multilib-minimal

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_REPO_URI="https://chromium.googlesource.com/libyuv/libyuv"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
	SRC_URI="FIXME"
fi

DESCRIPTION="libyuv is an open source project that includes YUV scaling and \
conversion functionality."
HOMEPAGE="https://chromium.googlesource.com/libyuv/libyuv/"
LICENSE="
	BSD
	libyuv-PATENTS
"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${GIT_BRANCHES}
+main stable static system-gflags test
"
REQUIRED_USE+="
	^^ (
		main
		stable
	)
"
RDEPEND+="
	virtual/libc
"
DEPEND+="
	${RDEPEND}
	test? (
		dev-cpp/gflags[${MULTILIB_USEDEP}]
		dev-cpp/gtest[${MULTILIB_USEDEP}]
		virtual/jpeg[${MULTILIB_USEDEP}]
	)
"
BDEPEND+="
	sys-apps/grep[pcre]
	!stable? (
		>=dev-build/cmake-2.8.12
	)
	stable? (
		>=dev-build/cmake-2.8
	)
"
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

unpack_live() {
	# clone uses main
	local expected_fingerprint
	if use stable ; then
		EGIT_BRANCH="stable"
		expected_fingerprint="${STABLE_EXPECTED_FINGERPRINT}"
		use fallback-commit && export EGIT_COMMIT="${STABLE_FALLBACK_COMMIT}"
	elif use main ; then
		EGIT_BRANCH="main"
		expected_fingerprint="${MAIN_EXPECTED_FINGERPRINT}"
		use fallback-commit && export EGIT_COMMIT="${MAIN_FALLBACK_COMMIT}"
	fi
einfo "Using ${EGIT_BRANCH} branch"
	git-r3_fetch
	git-r3_checkout
	actual_fingerprint=$(get_hash)
	if [[ "${expected_fingerprint}" == "disable" ]] ; then
		:
	elif [[ "${expected_fingerprint}" != "${actual_fingerprint}" ]] ; then
eerror
eerror "The build files has changed.  This means that either a change in"
eerror "dependencies, supported arches, ABI, config options, etc."
eerror
eerror "This means that the ebuild packager needs to update the *DEPENDS,"
eerror "IUSE, KEYWORDS.  Send an issue request about this."
eerror
eerror "Expected build files fingerprint:\t${expected_fingerprint}"
eerror "Actual build files fingerprint:\t${actual_fingerprint}"
eerror
		die
	fi
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		unpack_live
	else
		unpack ${A}
	fi
}

multilib_src_configure() {
	local mycmakeargs=(
		-DTEST=$(usex test "ON" "OFF")
	)
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
		-e "s|@version@|${PV}|" \
		> "${T}/${PN}.pc" \
		|| die
	doins "${T}/${PN}.pc"
	cd "${S}" || die
	einstalldocs
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multilib
# OILEDMACHINE-OVERLAY-META-REVDEP:  xpra
