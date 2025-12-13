# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See README.chromium or include/libyuv/version.h for lib version

EAPI=8

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

# See https://chromium.googlesource.com/libyuv/libyuv/+log/refs/heads/main/README.chromium for activity
CFLAGS_HARDENED_USE_CASES="untrusted-data"
CXX_STANDARD=17 # Compiler default
EGIT_COMMIT="500f45652c459cfccd20f83f297eb66cb7b015cb"

inherit cflags-hardened cmake libcxx-slot libstdcxx-slot multilib-minimal

KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
S="${WORKDIR}/${P}"
SRC_URI="
https://chromium.googlesource.com/libyuv/libyuv/+archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${EGIT_COMMIT:0:7}.tar.gz
"

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
system-gflags test
ebuild_revision_6
"
REQUIRED_USE+="
"
RDEPEND+="
	virtual/libc
"
DEPEND+="
	${RDEPEND}
	test? (
		dev-cpp/gflags[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
		dev-cpp/gflags:=
		dev-cpp/gtest[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
		dev-cpp/gtest:=
		virtual/jpeg[${MULTILIB_USEDEP}]
	)
"
BDEPEND+="
	>=dev-build/cmake-3.16
	sys-apps/grep[pcre]
"
PATCHES=(
	"${FILESDIR}/${PN}-1922-cmake-libdir.patch"
)
DOCS=( "AUTHORS" "LICENSE" "PATENTS" "README.chromium" "README.md" )

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	mkdir -p "${P}" || die
	cd "${P}" || die
	unpack ${A}
}

multilib_src_configure() {
	cflags-hardened_append
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
	local libdir=$(get_libdir)
	insinto "/usr/${libdir}/pkgconfig"
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
