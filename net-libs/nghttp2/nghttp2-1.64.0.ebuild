# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

CFLAGS_ASSEMBLERS="gas"
CFLAGS_HARDENED_CI_SANITIZERS="asan ubsan"
CFLAGS_HARDENED_CI_SANITIZERS_CLANG_COMPAT="18"
CFLAGS_HARDENED_CI_SANITIZERS_GCC_COMPAT="14"
CFLAGS_HARDENED_USE_CASES="network"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="DF DOS UAF"
MRUBY_COMMIT="32279e4128527bab4c961854b9cce727a060abea"
MUNIT_COMMIT="7f53fea8901089d46233302b3af35bf8be93cfc5"
NEVERBLEED_COMMIT="929e470260d460dacc20a10601c2d3c7a9f386b2"
PYTHON_COMPAT=( "python3_"{10..12} )
USE_RUBY="ruby32 ruby33"

inherit cflags-hardened check-compiler-switch cmake flag-o-matic multilib-minimal python-r1 ruby-single toolchain-funcs

KEYWORDS="
~amd64 ~arm64 ~x86
"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/nghttp2/nghttp2/releases/download/v${PV}/${P}.tar.xz
	mruby? (
https://github.com/mruby/mruby/archive/${MRUBY_COMMIT}.tar.gz
	-> mruby-${MRUBY_COMMIT:0:7}.tar.gz
	)
	neverbleed? (
https://github.com/tatsuhiro-t/neverbleed/archive/${NEVERBLEED_COMMIT}.tar.gz
	-> neverbleed-${NEVERBLEED_COMMIT:0:7}.tar.gz
	)
	test? (
https://github.com/ngtcp2/munit/archive/${MUNIT_COMMIT}.tar.gz
	-> munit-${MUNIT_COMMIT:0:7}.tar.gz
	)
"

DESCRIPTION="HTTP/2 C Library"
HOMEPAGE="https://nghttp2.org/"
LICENSE="
	MIT
	mruby? (
		(
			custom
			all-rights-reserved
		)
		BSD-2
		MIT
		public-domain
	)
	neverbleed? (
		MIT
	)
	test? (
		MIT
	)
"
# custom all-rights-reserved - https://github.com/mruby/mruby/blob/master/LEGAL
RESTRICT="
	!test? (
		test
	)
"
SO_CURRENT="42"
SO_AGE="28"
SLOT="0/1.$((${SO_CURRENT} - ${SO_AGE}))"
# bpf is default ON if clang and http3
# doc is default on upstream
# hpack-tools is enabled on CI
# jemalloc is enabled on CI
# utils is enabled on CI
# xml is enabled on CI
IUSE="
-bpf debug doc +hpack-tools -http3 -mruby -neverbleed +jemalloc -static-libs
systemd test +threads +utils +xml
ebuild_revision_15
"
REQUIRED_USE="
	doc? (
		${PYTHON_REQUIRED_USE}
	)
"
SSL_DEPEND="
	>=dev-libs/libevent-2.0.8[${MULTILIB_USEDEP},ssl]
	>=net-libs/ngtcp2-1.8.1[${MULTILIB_USEDEP},openssl]
	|| (
		(
			>=dev-libs/openssl-1.1.1w:0[${MULTILIB_USEDEP},-bindist(-)]
			=dev-libs/openssl-1*:=[${MULTILIB_USEDEP},-bindist(-)]
		)
		(
			>=dev-libs/openssl-3.1.7:0[${MULTILIB_USEDEP},-bindist(-)]
			=dev-libs/openssl-3*:=[${MULTILIB_USEDEP},-bindist(-)]
		)
	)
"
RDEPEND="
	bpf? (
		>=dev-libs/libbpf-1.4.6
	)
	hpack-tools? (
		>=dev-libs/jansson-2.5:=
	)
	http3? (
		>=net-libs/nghttp3-1.6.0[${MULTILIB_USEDEP}]
	)
	jemalloc? (
		dev-libs/jemalloc:=[${MULTILIB_USEDEP}]
	)
	utils? (
		${SSL_DEPEND}
		>=app-arch/brotli-1.0.9[${MULTILIB_USEDEP}]
		>=dev-libs/libev-4.11[${MULTILIB_USEDEP}]
		>=net-dns/c-ares-1.16.0:=[${MULTILIB_USEDEP}]
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
"
BDEPEND="
	>dev-build/cmake-3.14
	virtual/pkgconfig
	doc? (
		${PYTHON_DEPS}
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
	)
	mruby? (
		${RUBY_DEPS}
		sys-devel/bison
	)
	|| (
		>=sys-devel/gcc-14
		>=llvm-core/clang-18
	)
"

pkg_setup() {
	check-compiler-switch_start
	ruby-single_setup
	python_setup
	if tc-is-clang && use http3 && ! use bpf ; then
ewarn "bpf is default ON upstream if clang ON, http3 ON"
	fi
}

src_unpack() {
	unpack ${A}
	if use mruby ; then
		rm -rf "${S}/third-party/mruby"
		mv \
			"${WORKDIR}/mruby-${MRUBY_COMMIT}" \
			"${S}/third-party/mruby" \
			|| die
	fi
	if use neverbleed ; then
		rm -rf "${S}/third-party/neverbleed"
		mv \
			"${WORKDIR}/neverbleed-${NEVERBLEED_COMMIT}" \
			"${S}/third-party/neverbleed" \
			|| die
	fi
	if use test ; then
		rm -rf "${S}/tests/munit"
		mv \
			"${WORKDIR}/munit-${MUNIT_COMMIT}" \
			"${S}/tests/munit" \
			|| die
	fi
}

src_prepare() {
	cmake_src_prepare
}

multilib_src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

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
	cflags-hardened_append
	local mycmakeargs=(
		$(cmake_use_find_package hpack-tools Jansson)
		$(cmake_use_find_package systemd Systemd)
		$(cmake_use_find_package test CUnit)
		-DENABLE_APP=$(multilib_native_usex utils)
		-DENABLE_DEBUG=$(usex debug)
		-DENABLE_DOC=$(usex doc)
		-DENABLE_EXAMPLES=OFF
		-DENABLE_FAILMALLOC=OFF
		-DENABLE_HPACK_TOOLS=$(multilib_native_usex hpack-tools)
		-DENABLE_STATIC_LIB=$(usex static-libs)
		-DENABLE_THREADS=$(usex threads)
		-DENABLE_WERROR=OFF
		-DWITH_JEMALLOC=$(multilib_native_usex jemalloc)
		-DWITH_LIBBPF=$(multilib_native_usex bpf)
		-DWITH_LIBXML2=$(multilib_native_usex xml)
		-DWITH_MRUBY=$(usex mruby)
		-DWITH_NEVERBLEED=$(usex neverbleed)
	)
	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile
}

multilib_src_test() {
	eninja check
}

multilib_src_install() {
	cmake_src_install
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
