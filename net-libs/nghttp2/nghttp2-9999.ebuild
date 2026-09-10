# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

# AI inference is used to fix security tags.
# AI generation is used for init scripts and suggestions.

CFLAGS_ASSEMBLERS="gas"
CFLAGS_HARDENED_CI_SANITIZERS="asan ubsan"
CFLAGS_HARDENED_CI_SANITIZERS_CLANG_COMPAT="18"
CFLAGS_HARDENED_CI_SANITIZERS_GCC_COMPAT="14"
CFLAGS_HARDENED_USE_CASES="security-critical network sensitive-data system-set untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="DF DOS UAF"
CXX_STANDARD=23
PYTHON_COMPAT=( "python3_"{10..14} ) # Relaxed
USE_RUBY="ruby32 ruby33"

HTTP_PARSER_COMMIT="ec8b5ee63f0e51191ea43bb0c6eac7bfbff3141d" # dep of urlparse
MRUBY_COMMIT="831da26b9021de0369d17b71b5667e2941a1a32d"
MUNIT_COMMIT_1="cb04288a5225645be005a521c537b83c51934ef6"
MUNIT_COMMIT_2="3cf9c79f3a76f313d560dedd5b47c0416a0fbb6e" # dep of urlparse
NEVERBLEED_COMMIT="68f65c7b05f68e6fd93631668d4f469875946656"
URLPARSE_COMMIT="59b068a7618a256c6823b0b9801b61d1d04677a3"

CHKL_TIMESTAMPS=(
	"app-arch/brotli-9999"
	"dev-libs/libbpf-9999"
	"dev-libs/libxml2-9999"
	"dev-libs/jansson-9999"
	"dev-libs/jemalloc-9999"
	"dev-libs/openssl-4.0.9999"
	"dev-libs/openssl-3.6.9999"
	"dev-libs/openssl-3.5.9999"
	"dev-libs/openssl-3.4.9999"
	"dev-libs/openssl-3.0.9999"
	"net-dns/c-ares-9999"
	"net-libs/nghttp3-9999"
	"net-libs/ngtcp2-9999"
	"sys-apps/systemd-9999"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	#"${LIBSTDCXX_COMPAT_STDCXX23[@]}"
	"gcc_slot_11_5" # Support -std=c++17.
	"gcc_slot_12_5" # Support -std=c++17.
	"gcc_slot_13_4" # Support -std=c++17.
	"gcc_slot_14_3" # Support -std=c++17
	"gcc_slot_15_3" # Support -std=c++17, -std=c++23.
	"gcc_slot_16_1" # Support -std=c++23.
)

inherit libcxx-compat
LLVM_COMPAT=(
	#"${LIBCXX_COMPAT_STDCXX23[@]/llvm_slot_}"
	18 19 # c++17
	21 22 # c++17, c++23
)



inherit cflags-hardened check-compiler-switch chkl cmake dep-prepare flag-o-matic libcxx-slot libstdcxx-slot multilib-minimal python-r1 ruby-single secure-version systemd toolchain-funcs

if [[ "${PV}" == "9999" ]] ; then
	FALLBACK_COMMIT="e4a2c989b39a9285791a8c0bbb9eb90fcb328659"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/nghttp2/nghttp2.git"
	inherit git-r3
else
	KEYWORDS="
~amd64 ~arm64 ~x86
	"
	S="${WORKDIR}/${P}"
	SRC_URI="
https://github.com/nghttp2/nghttp2/releases/download/v${PV}/${P}.tar.xz
https://github.com/ngtcp2/urlparse/archive/${URLPARSE_COMMIT}.tar.gz
	-> urlparse-${URLPARSE_COMMIT:0:7}.tar.gz
https://github.com/nodejs/http-parser/archive/${HTTP_PARSER_COMMIT}.tar.gz
	-> http-parser-${HTTP_PARSER_COMMIT:0:7}.tar.gz
https://github.com/ngtcp2/munit/archive/${MUNIT_COMMIT_2}.tar.gz
	-> munit-${MUNIT_COMMIT_2:0:7}.tar.gz
	mruby? (
https://github.com/mruby/mruby/archive/${MRUBY_COMMIT}.tar.gz
	-> mruby-${MRUBY_COMMIT:0:7}.tar.gz
	)
	neverbleed? (
https://github.com/tatsuhiro-t/neverbleed/archive/${NEVERBLEED_COMMIT}.tar.gz
	-> neverbleed-${NEVERBLEED_COMMIT:0:7}.tar.gz
	)
	test? (
https://github.com/ngtcp2/munit/archive/${MUNIT_COMMIT_1}.tar.gz
	-> munit-${MUNIT_COMMIT_1:0:7}.tar.gz
	)
	"
fi


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
SO_CURRENT="43"
SO_AGE="29"
SLOT="0/1.$((${SO_CURRENT} - ${SO_AGE}))"
# bpf is disabled on CI for release
# hpack-tools is disabled on CI for release
# http3 is disabled on CI for release
# jemalloc is disabled on CI for release
# threads is enabled on CI for release
# utils is disabled on CI for release
# xml is enabled on CI for release
IUSE+="
apparmor -bpf clang debug doc gcc -hpack-tools -http3 -mruby -neverbleed -jemalloc openrc quic
-static-libs systemd test +threads -utils +xml
ebuild_revision_26
"
REQUIRED_USE="
	|| (
		gcc
		clang
	)
	!utils? (
		!hpack-tools? (
			gcc? (
				|| (
					gcc_slot_11_5
					gcc_slot_12_5
					gcc_slot_13_4
					gcc_slot_14_3
					gcc_slot_15_3
				)
			)
			clang? (
				|| (
					llvm_slot_18
					llvm_slot_19
					llvm_slot_21
					llvm_slot_22
				)
			)
		)
	)
	utils? (
		gcc? (
			|| (
				gcc_slot_15_3
				gcc_slot_16_1
			)
		)
		clang? (
			|| (
				llvm_slot_21
				llvm_slot_22
			)
		)
	)
	doc? (
		${PYTHON_REQUIRED_USE}
	)
"
SSL_DEPEND="
	$(secure-version_gen_openssl_depends '' '[-bindist(-),${MULTILIB_USEDEP}]')
	>=dev-libs/libevent-2.0.8:=[${MULTILIB_USEDEP},ssl]
	>=net-libs/ngtcp2-${NGTCP2_PV}:=[${MULTILIB_USEDEP},openssl]
"
RDEPEND="
	acct-group/nghttpx
	acct-user/nghttpx
	bpf? (
		>=dev-libs/libbpf-${LIBBPF_PV}:=
	)
	hpack-tools? (
		>=dev-libs/jansson-${JANSSON_PV}:=
	)
	http3? (
		>=net-libs/nghttp3-${NGHTTP3_PV}:=[${MULTILIB_USEDEP}]
	)
	jemalloc? (
		>=dev-libs/jemalloc-${JEMALLOC_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
	)
	quic? (
		>=net-libs/ngtcp2-${NGTCP2_PV}:=[${MULTILIB_USEDEP}]
	)
	utils? (
		${SSL_DEPEND}
		>=app-arch/brotli-${BROTLI_PV}:=[${MULTILIB_USEDEP}]
		>=dev-libs/libev-${LIBEV_PV}:=[${MULTILIB_USEDEP}]
		>=net-dns/c-ares-${C_ARES_PV}:=[${MULTILIB_USEDEP}]
		>=virtual/zlib-${ZLIB_PV}:=[${MULTILIB_USEDEP}]
	)
	systemd? (
		>=sys-apps/systemd-${SYSTEMD_PV}:=
	)
	xml? (
		>=dev-libs/libxml2-${LIBXML2_PV}:=[${MULTILIB_USEDEP}]
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
"

pkg_setup() {
	check-compiler-switch_start
	python_setup
	if tc-is-clang && use http3 && ! use bpf ; then
ewarn "bpf is default ON upstream if clang ON, http3 ON"
	fi
	libcxx-slot_verify
	libstdcxx-slot_verify
	if tc-is-clang ; then
		use clang || die "Enable the clang USE flag"
	fi
	if tc-is-gcc ; then
		use gcc || die "Enable the gcc USE flag"
	fi
}

src_unpack() {
	if [[ "${PV}" == "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		dep_prepare_mv "${WORKDIR}/urlparse-${URLPARSE_COMMIT}" "${S}/third-party/urlparse"
		dep_prepare_mv "${WORKDIR}/http-parser-${HTTP_PARSER_COMMIT}" "${S}/third-party/urlparse/http-parser"
		dep_prepare_mv "${WORKDIR}/munit-${MUNIT_COMMIT_2}" "${S}/third-party/urlparse/munit"
		if use mruby ; then
			dep_prepare_mv "${WORKDIR}/mruby-${MRUBY_COMMIT}" "${S}/third-party/mruby"
		fi
		if use neverbleed ; then
			dep_prepare_mv "${WORKDIR}/neverbleed-${NEVERBLEED_COMMIT}" "${S}/third-party/neverbleed"
		fi
		if use test ; then
			dep_prepare_mv "${WORKDIR}/munit-${MUNIT_COMMIT_1}" "${S}/tests/munit"
		fi
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
	chkl_check_many_timestamps

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

	if ! use utils && ! use hpack-tools ; then
		mycmakeargs=(
			-DENABLE_LIB_ONLY=ON # For C++20
		)
	else
ewarn "Using -std=c++23"
	fi

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

	if use apparmor ; then
		insinto "/etc/apparmor.d"
		sed -i -e "s|/usr/sbin/nghttpx|/usr/bin/nghttpx|" \
			"${S}/contrib/usr.sbin.nghttpx" \
			|| die
		doins "${S}/contrib/usr.sbin.nghttpx"
	fi

	if use openrc  ; then
	# OpenRC deployment
		newinitd "${FILESDIR}/nghttpx.initd" "nghttpx"
		newconfd "${FILESDIR}/nghttpx.confd" "nghttpx"
	fi

	if use systemd ; then
	# systemd deployment
		systemd_dounit "${FILESDIR}/nghttpx.service"
	fi

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
