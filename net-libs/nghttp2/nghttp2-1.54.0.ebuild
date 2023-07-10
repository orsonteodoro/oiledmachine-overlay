# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="HTTP/2 C Library"
HOMEPAGE="https://nghttp2.org/"
LICENSE="MIT"
SLOT="0/1.14" # 1.<SONAME>
KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv
~s390 ~sparc ~x86 ~amd64-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris
"
IUSE="bpf debug hpack-tools http3 jemalloc static-libs systemd test utils xml"
SSL_DEPEND="
	>=dev-libs/libevent-2.0.8[${MULTILIB_USEDEP},ssl]
	>=dev-libs/openssl-1.0.1:0=[${MULTILIB_USEDEP},-bindist(-)]
	net-libs/ngtcp2[${MULTILIB_USEDEP},openssl]
"
RDEPEND="
	bpf? (
		>=dev-libs/libbpf-0.4.0
	)
	hpack-tools? (
		>=dev-libs/jansson-2.5:=
	)
	http3? (
		net-libs/nghttp3[${MULTILIB_USEDEP}]
	)
	jemalloc? (
		dev-libs/jemalloc:=[${MULTILIB_USEDEP}]
	)
	utils? (
		${SSL_DEPEND}
		>=dev-libs/libev-4.11[${MULTILIB_USEDEP}]
		>=net-dns/c-ares-1.7.5:=[${MULTILIB_USEDEP}]
		>=sys-libs/zlib-1.2.3[${MULTILIB_USEDEP}]
	)
	systemd? (
		>=sys-apps/systemd-209
	)
	xml? (
		>=dev-libs/libxml2-2.6.26:2[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
	test? (
		>=dev-util/cunit-2.1[${MULTILIB_USEDEP}]
	)
"
BDEPEND="
	>dev-util/cmake-3.0
	virtual/pkgconfig
"
RESTRICT="
	!test? (
		test
	)
"
SRC_URI="
https://github.com/nghttp2/nghttp2/releases/download/v${PV}/${P}.tar.xz
"

multilib_src_configure() {
	local so_c=$(grep -F "set(LT_CURRENT" "${S}/CMakeLists.txt" \
		| grep -E -o "[0-9]+")
	local so_r=$(grep -F "set(LT_REVISION" "${S}/CMakeLists.txt" \
		| grep -E -o "[0-9]+")
	local so_a=$(grep -F "set(LT_AGE" "${S}/CMakeLists.txt" \
		| grep -E -o "[0-9]+")
	local actual_slot="0/1."$((${so_c} - ${so_a}))
	local expected_slot="${SLOT}"
	if [[ "${actual_slot}" != "${expected_slot}" ]] ; then
eerror
eerror "QA: Slot mismatch"
eerror
eerror "Expected slot:  ${expected_slot}"
eerror "Actual slot:    ${actual_slot}"
eerror
eerror "Update SLOT to ${actual_slot}."
eerror
		die
	fi
	local mycmakeargs=(
		$(cmake_use_find_package hpack-tools Jansson)
		$(cmake_use_find_package systemd Systemd)
		$(cmake_use_find_package test CUnit)
		-DENABLE_APP=$(multilib_native_usex utils)
		-DENABLE_DEBUG=$(usex debug)
		-DENABLE_EXAMPLES=OFF
		-DENABLE_FAILMALLOC=OFF
		-DENABLE_HPACK_TOOLS=$(multilib_native_usex hpack-tools)
		-DENABLE_STATIC_LIB=$(usex static-libs)
		-DENABLE_THREADS=ON
		-DENABLE_WERROR=OFF
		-DWITH_JEMALLOC=$(multilib_native_usex jemalloc)
		-DWITH_LIBBPF=$(multilib_native_usex bpf)
		-DWITH_LIBXML2=$(multilib_native_usex xml)
	)
	cmake_src_configure
}

multilib_src_test() {
	eninja check
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.54.0 (20230709)
# USE="test -bpf (-debug) -hpack-tools -http3 -jemalloc -static-libs -systemd -utils -xml"
# Both 32-bit and 64-bit tested
#    Start 1: main
#1/1 Test #1: main .............................   Passed    0.02 sec
#
#100% tests passed, 0 tests failed out of 1
#
#Total Test time (real) =   0.03 sec
