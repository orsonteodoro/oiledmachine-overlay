# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Bootstrap plan (Tentative):

# Build Bun 1.0.7 with Bun's Zig for generic Bun.
# Build 1 or more generic Buns with lowest possible ISA SIMD (-march=x86-64, -march=armv8-a) towards the latest stable bun.
# Build Bun latest stable with generic Bun as feature complete Bun.
# Boostrapping Bun is similar to bootstrapping Rust where the previous version bootstraps to next version.

# 1.0.7 is being used before bun is required for generate-jssink ts to js transpilation.  We keep the pregenerated js transpilation.

# 1.0.7     Bun's Zig to generic Bun 1.0.7 to build portable Bun for -march=x86-64 or -march=armv8-a
# M         generic Bun 1.0.7 -> M generic Bun
# ...
# N         generic Bun M -> Bun N generic Bun
# 1.1.26    generic Bun N -> Bun 1.1.26
# 1.3.35    generic Bun 1.1.26 to feature complete Bun 1.3.5.  Steps will merge if possible to save time.

# Deps versions:
# https://github.com/oven-sh/bun/tree/bun-v1.0.7/src/deps
# https://github.com/oven-sh/bun/tree/bun-v1.0.7/src/bun.js		# Older WebKit commit
# https://github.com/oven-sh/bun/blob/bun-v1.0.7/CMakeLists.txt#L7	# Newer WebKit commit

# TODO:
# FIXME:  Missing data collection policy/legal text

CFLAGS_HARDENED_USE_CASES="security-critical jit network untrusted-data"
CXX_STANDARD=20

BROTLI_PV="1.1.0"
BUN_JSC_SLOT="20231014"
BUN_SLOT=$(ver_cut "1-2" "${PV}")
BUN_ZIG_SLOT="20231013"
NODE_PV="22.6.0"
NODE_SLOT="${NODE_PV%%.*}"

BUN_SEED_SLOT="TBD"

BASE64_COMMIT="e77bd70bdd860c52c561568cffb251d88bba064c"
BORINGSSL_COMMIT="b275c5ce1c88bc06f5a967026d3c0ce1df2be815"				# S1 in threat model
C_ARES_COMMIT="0e7a5dee0fbb04080750cf6eabbe89d8bae87faa"
LIBARCHIVE_COMMIT="dc321febde83dd0f31158e1be61a7aedda65e7a2"				# S0 security-critical in threat model
LOL_HTML_COMMIT="8d4c273ded322193d017042d1f48df2766b0f88b"
MIMALLOC_COMMIT="7968d4285043401bb36573374710d47a4081a063"				# S0 security-critical in threat model
PICOHTTPPARSER_COMMIT="066d2b1e9ab820703db0837a7255d92d30f0c9f5"
TINYCC_COMMIT="2d3ad9e0d32194ad7fd867b66ebe218dcc8cb5cd"
WEBKIT_COMMIT="1a49a1f94bf42ab4f8c6b11d7bbbb21e491d2d62"
ZIG_COMMIT="027aabf4977d0362e908d9ef732aaa929605d563"
ZLIB_COMMIT="885674026394870b7e7a05b7bf1ec5eb7bd8a9c0"					# S0 security-critical in threat model
ZSTD_COMMIT="63779c798237346c2b245c546c40b72a5a5913fe"					# S0 security-critical in threat model

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX20[@]}"
)
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)"

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX20[@]/llvm_slot_}"
)
LIBCXX_USEDEP_LTS="llvm_slot_skip(+)"

CPU_FLAGS_ARM=(
	"cpu_flags_arm_aes"
	"cpu_flags_arm_crc"
	"cpu_flags_arm_fp16"
	"cpu_flags_arm_fp16fml"
	"cpu_flags_arm_neon"
	"cpu_flags_arm_rnd"
	"cpu_flags_arm_sha3"
	"cpu_flags_arm_sb"
	"cpu_flags_arm_ssbs"
	"cpu_flags_arm_v8_4a"
	"cpu_flags_arm_v8_6a"
)

CPU_FLAGS_X86=(
	"cpu_flags_x86_avx2"
	"cpu_flags_x86_bmi"
	"cpu_flags_x86_bmi2"
	"cpu_flags_x86_cx16"
	"cpu_flags_x86_f16c"
	"cpu_flags_x86_fma"
	"cpu_flags_x86_fxsr"
	"cpu_flags_x86_lzcnt"
	"cpu_flags_x86_mmx"
	"cpu_flags_x86_pclmul"
	"cpu_flags_x86_popcnt"
	"cpu_flags_x86_rdrnd"
	"cpu_flags_x86_sse"
	"cpu_flags_x86_sse2"
	"cpu_flags_x86_sse4_2"
)

inherit check-compiler-switch cflags-hardened cmake dep-prepare dhms edo git-r3 libcxx-slot libstdcxx-slot node

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/oven-sh/bun.git"
	FALLBACK_COMMIT="fa5a5bbe556a4bda5bde77b4013aa6c3bb4ec9ab" # Dec 17, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	#KEYWORDS="~amd64" # We are still trying to figure how to bootstrap this as generic CPU.
	S="${WORKDIR}/${PN}-${PN}-v${PV}"
	SRC_URI="
https://github.com/aklomp/base64/archive/${BASE64_COMMIT}.tar.gz
	-> base64-${BASE64_COMMIT:0:7}.tar.gz
https://github.com/c-ares/c-ares/archive/${C_ARES_COMMIT}.tar.gz
	-> c-ares-${C_ARES_COMMIT:0:7}.tar.gz
https://github.com/cloudflare/lol-html/archive/${LOL_HTML_COMMIT}.tar.gz
	-> lol-html-${LOL_HTML_COMMIT:0:7}.tar.gz
https://github.com/cloudflare/zlib/archive/${ZLIB_COMMIT}.tar.gz
	-> cloudflare-zlib-${ZLIB_COMMIT:0:7}.tar.gz
https://github.com/facebook/zstd/archive/${ZSTD_COMMIT}.tar.gz
	-> zstd-${ZSTD_COMMIT:0:7}.tar.gz
https://github.com/google/brotli/archive/refs/tags/v${BROTLI_PV}.tar.gz
	-> brotli-${BROTLI_PV}.tar.gz
https://github.com/h2o/picohttpparser/archive/${PICOHTTPPARSER_COMMIT}.tar.gz
	-> picohttpparser-${PICOHTTPPARSER_COMMIT:0:7}.tar.gz
https://github.com/oven-sh/boringssl/archive/${BORINGSSL_COMMIT}.tar.gz
	-> oven-sh-boringssl-${BORINGSSL_COMMIT:0:7}.tar.gz
https://github.com/oven-sh/bun/archive/refs/tags/bun-v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/oven-sh/mimalloc/archive/${MIMALLOC_COMMIT}.tar.gz
	-> oven-sh-mimalloc-${MIMALLOC_COMMIT:0:7}.tar.gz
https://github.com/oven-sh/tinycc/archive/${TINYCC_COMMIT}.tar.gz
	-> tinycc-${TINYCC_COMMIT:0:7}.tar.gz
https://github.com/libarchive/libarchive/archive/${LIBARCHIVE_COMMIT}.tar.gz
	-> libarchive-${LIBARCHIVE_COMMIT:0:7}.tar.gz

https://nodejs.org/dist/v${NODE_PV}/node-v${NODE_PV}-headers.tar.gz

	"
fi
#https://github.com/oven-sh/WebKit/archive/${WEBKIT_COMMIT}.tar.gz
#	-> bun-webkit-${WEBKIT_COMMIT:0:7}.tar.gz

DESCRIPTION="Incredibly fast JavaScript runtime, bundler, test runner, and package manager – all in one"
HOMEPAGE="
	https://bun.com/
	https://github.com/oven-sh/bun
"
LICENSE="
	(
		BSD
		BSD-2
		public-domain
		|| (
			Apache-2.0
			CC0-1.0
			openssl
		)
	)
	Apache-2.0
	BSD
	BSD-2
	icu
	LGPL-2.1
	MIT
	ZLIB
	|| (
		Artistic
		GPL-1+
	)
	|| (
		BSD
		GPL-2+
	)
"
RESTRICT="mirror"
BUN_SLOT_MAJOR="${BUN_SLOT}-${BUN_JSC_SLOT}"
SLOT="${BUN_SLOT_MAJOR}/${PV}"
IUSE+="
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_X86[@]}
clang lto -telemetry
"
REQUIRED_USE="
	clang
	clang? (
		^^ (
			${LIBCXX_COMPAT_STDCXX23[@]}
		)
	)

	cpu_flags_x86_cx16? (
		cpu_flags_x86_mmx
	)
	cpu_flags_x86_fxsr? (
		cpu_flags_x86_mmx
	)
	cpu_flags_x86_sse2? (
		cpu_flags_x86_mmx
	)

	cpu_flags_x86_sse4_2? (
		cpu_flags_x86_sse2
	)

	cpu_flags_x86_avx2? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_f16c? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_fma? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_pclmul? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_rdrnd? (
		cpu_flags_x86_sse4_2
	)

	cpu_flags_arm_fp16fml? (
		cpu_flags_arm_fp16
	)

	cpu_flags_arm_v8_6a? (
		cpu_flags_arm_v8_4a
	)
"
gen_depend_llvm() {
	local s
	for s in "${LLVM_COMPAT[@]}" ; do
		echo "
			llvm_slot_${s}? (
				llvm-core/clang:${s}[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
				llvm-core/clang:=
				llvm-core/llvm:${s}[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
				llvm-core/llvm:=
				llvm-core/lld:${s}[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
				llvm-core/lld:=
			)
		"
	done
}

RDEPEND+="
	net-libs/bun-jsc:${BUN_JSC_SLOT}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	app-arch/xz-utils
	dev-libs/libxml2
	dev-libs/openssl
	dev-vcs/git
	sys-libs/zlib
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=net-libs/nodejs-${NODE_PV}:${NODE_SLOT}
	>=dev-build/cmake-3.30
	app-arch/unzip
	dev-lang/go
	dev-lang/python
	net-misc/curl
	net-misc/wget
	virtual/pkgconfig
	clang? (
		$(gen_depend_llvm)
	)
	|| (
		>=dev-lang/rust-1.92
		>=dev-lang/rust-bin-1.92
	)
	|| (
		net-libs/bun-zig:${BUN_ZIG_SLOT}[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
	)
	net-libs/bun-zig:=
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-1.1.26-march-and-opt-level-changes.patch"
	"${FILESDIR}/${PN}-1.1.26-mimalloc-secure-on.patch"
	"${FILESDIR}/${PN}-1.1.26-disable-cmake-build-type-check.patch"
)

_set_clang() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		if use "llvm_slot_${s}" ; then
			export CC="${CHOST}-clang-${s}"
			export CXX="${CHOST}-clang++-${s}"
			export LLVM_SLOT="${s}"
			break
		fi
	done
	if [[ -z "${CC}" ]] ; then
eerror "Choose a LLVM slot for C++ standard ${CXX_STANDARD}.  Valid values:  ${LLVM_COMPAT[@]/#/llvm_slot_}"
eerror "Enable a llvm_slot_<x> flag."
		die
	fi

einfo "PATH=${PATH} (before)"
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}/bin|g")
einfo "PATH=${PATH} (after)"

	if ! which "${CC}" ; then
eerror "${CC} is not found.  Emerge the compiler slot."
		die
	fi
	export CPP="${CC} -E"
	export AR="llvm-ar"
	export NM="llvm-nm"
	export OBJCOPY="llvm-objcopy"
	export OBJDUMP="llvm-objdump"
	export READELF="llvm-readelf"
	export STRIP="llvm-strip"
	export GCC_FLAGS=""
	strip-unsupported-flags
	${CC} --version || die
}

_set_gcc() {
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CC} -E"
	export AR="ar"
	export NM="nm"
	export OBJCOPY="objcopy"
	export OBJDUMP="objdump"
	export READELF="readelf"
	export STRIP="strip"
	export GCC_FLAGS="-fno-allow-store-data-races"
	strip-unsupported-flags
}

_set_cxx() {
	if tc-is-clang && ! use clang ; then
eerror "Enable the clang USE flag or remove clang from CC/CXX"
		die
	fi
	if [[ ${MERGE_TYPE} != "binary" ]] ; then
	# See https://docs.webkit.org/Ports/WebKitGTK%20and%20WPE%20WebKit/DependenciesPolicy.html
	# Based on D 12, U 22, U 24
	# D12 - gcc 12.2, clang 14.0
	# U22 - gcc 11.2, clang 14.0
	# U24 - gcc 13.2, clang 18.0
		if use clang ; then
			_set_clang
		else
			_set_gcc
		fi
	fi
}

pkg_setup() {
	dhms_start
	check-compiler-switch_start
	_set_cxx
	libcxx-slot_verify
	libstdcxx-slot_verify
	node_setup

	export DO_NOT_TRACK=1
	export BUN_ENABLE_CRASH_REPORTING=0
	export BUN_CRASH_REPORT_URL="https://localhost"
	export NEXT_TELEMETRY_DISABLED=1
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}

	fi
}

get_zig_arch() {
	if [[ "${ARCH}" == "amd64" ]] ; then
		echo "x86_64"
	elif [[ "${ARCH}" == "arm64" ]] ; then
		echo "aarch64"
	else
eerror "ARCH=${ARCH} is not supported"
		die
	fi
}

src_prepare() {
	local zig_arch=$(get_zig_arch)
#	dep_prepare_mv "${WORKDIR}/bootstrap-${zig_arch}-linux-musl" "${S}/src/deps/zig"
	dep_prepare_mv "${WORKDIR}/boringssl-${BORINGSSL_COMMIT}" "${S}/src/deps/boringssl"
	dep_prepare_mv "${WORKDIR}/brotli-${BROTLI_PV}" "${S}/src/deps/brotli"
	dep_prepare_mv "${WORKDIR}/c-ares-${C_ARES_COMMIT}" "${S}/src/deps/c-ares"
	dep_prepare_mv "${WORKDIR}/libarchive-${LIBARCHIVE_COMMIT}" "${S}/src/deps/libarchive"
	dep_prepare_mv "${WORKDIR}/lol-html-${LOL_HTML_COMMIT}" "${S}/src/deps/lol-html"
	dep_prepare_mv "${WORKDIR}/mimalloc-${MIMALLOC_COMMIT}" "${S}/src/deps/mimalloc"
#	dep_prepare_mv "${WORKDIR}/node-v${NODE_PV}" "${S}/src/deps/" # TODO finish
	dep_prepare_mv "${WORKDIR}/picohttpparser-${PICOHTTPPARSER_COMMIT}" "${S}/src/deps/picohttpparser"
	dep_prepare_mv "${WORKDIR}/tinycc-${TINYCC_COMMIT}" "${S}/src/deps/tinycc"
	dep_prepare_mv "${WORKDIR}/zlib-${ZLIB_COMMIT}" "${S}/src/deps/zlib"
	dep_prepare_mv "${WORKDIR}/zstd-${ZSTD_COMMIT}" "${S}/src/deps/zstd"
	cmake_src_prepare
}

get_march() {
	echo "${CFLAGS}" | grep -E -e "-march=[a-z0-9_+-]+" | tr " " $'\n' | tail -n 1
}

get_mtune() {
	echo "${CFLAGS}" | grep -E -e "-mtune=[a-z0-9_+-]+" | tr " " $'\n' | tail -n 1
}

get_mcpu() {
	echo "${CFLAGS}" | grep -E -e "-mcpu=[a-z0-9_+-]+" | tr " " $'\n' | tail -n 1
}

_configure_cmake() {
	local _ABI="${ABI}"
	unset ABI

	local libc=""
	if use elibc_glibc ; then
		libc="gnu"
	elif use elibc_musl ; then
		libc="musl"
	else
eerror "ELIBC=${ELIBC} is not supported."
		die
	fi

	local mycmakeargs=(
		-DABI="${libc}"
		-DCMAKE_BUILD_TYPE="RelWithDebInfo" # Force -O2 to prevent optimizing out _FORTIFY_SOURCE memory corruption checks
		-DENABLE_LTO=$(usex lto "ON" "OFF")
		-DWEBKIT_LOCAL=ON

	# Hints for fallback defaults
		-DUSE_AES=$(usex cpu_flags_arm_aes)
		-DUSE_CRC=$(usex cpu_flags_arm_crc)
		-DUSE_FP16=$(usex cpu_flags_arm_fp16)
		-DUSE_FP16FML=$(usex cpu_flags_arm_fp16fml)
		-DUSE_NEON=$(usex cpu_flags_arm_neon)
		-DUSE_RND=$(usex cpu_flags_arm_rnd)
		-DUSE_SHA3=$(usex cpu_flags_arm_sha3)
		-DUSE_SB=$(usex cpu_flags_arm_sb)
		-DUSE_SSBS=$(usex cpu_flags_arm_ssbs)
		-DUSE_V8_4A=$(usex cpu_flags_arm_v8_4a)
		-DUSE_V8_6A=$(usex cpu_flags_arm_v8_6a)

		-DUSE_AVX2=$(usex cpu_flags_x86_avx2)
		-DUSE_BMI=$(usex cpu_flags_x86_bmi)
		-DUSE_BMI2=$(usex cpu_flags_x86_bmi2)
		-DUSE_CX16=$(usex cpu_flags_x86_cx16)
		-DUSE_F16C=$(usex cpu_flags_x86_f16c)
		-DUSE_FMA=$(usex cpu_flags_x86_fma)
		-DUSE_FXSR=$(usex cpu_flags_x86_fxsr)
		-DUSE_LZCNT=$(usex cpu_flags_x86_lzcnt)
		-DUSE_MMX=$(usex cpu_flags_x86_mmx)
		-DUSE_PCLMUL=$(usex cpu_flags_x86_pclmul)
		-DUSE_POPCNT=$(usex cpu_flags_x86_popcnt)
		-DUSE_RDRND=$(usex cpu_flags_x86_rdrnd)
		-DUSE_SSE=$(usex cpu_flags_x86_sse)
		-DUSE_SSE2=$(usex cpu_flags_x86_sse2)
		-DUSE_SSE4_2=$(usex cpu_flags_x86_sse4_2)
	)

	local march=$(get_march)
	local mtune=$(get_mtune)
	local mcpu=$(get_mcpu)

	if [[ -n "${march}" ]] ; then
		mycmakeargs+=(
			-DZIG_CPU="${march/-/_}"
		)
	elif [[ -n "${mcpu}" ]] ; then
		mycmakeargs+=(
			-DZIG_CPU="${mcpu/-/_}"
		)
	elif [[ -n "${mtune}" ]] ; then
		mycmakeargs+=(
			-DZIG_CPU="${mtune/-/_}"
		)
	else
		if [[ "${ARCH}" == "amd64" ]] ; then
			local generic_arch=""
			if \
				   use cpu_flags_x86_fxsr \
				&& use cpu_flags_x86_mmx \
				&& use cpu_flags_x86_sse \
				&& use cpu_flags_x86_sse2 \
			; then
				generic_arch="x86_64"
			elif \
				   use cpu_flags_x86_cx16 \
				&& use cpu_flags_x86_fxsr \
				&& use cpu_flags_x86_mmx \
				&& use cpu_flags_x86_sse4_2 \
				&& use cpu_flags_x86_popcnt \
			; then
				generic_arch="x86_64_v2"
			elif \
				   use cpu_flags_x86_avx2 \
				&& use cpu_flags_x86_bmi \
				&& use cpu_flags_x86_bmi2 \
				&& use cpu_flags_x86_cx16 \
				&& use cpu_flags_x86_f16c \
				&& use cpu_flags_x86_fma \
				&& use cpu_flags_x86_fxsr \
				&& use cpu_flags_x86_lzcnt \
				&& use cpu_flags_x86_mmx \
				&& use cpu_flags_x86_popcnt \
			; then
				generic_arch="x86_64_v3"
			else
eerror
eerror "CPU is not supported"
eerror
eerror "At least one row must be completely enabled to continue."
eerror
eerror "<zig_cpu> - -march=<codename> added to CFLAGS"
eerror "nehalem - -march=nehalem added to CFLAGS"
eerror "haswell - -march=haswell added to CFLAGS"
eerror "x86_64 - cpu_flags_x86_fxsr, cpu_flags_x86_mmx, cpu_flags_x86_sse, cpu_flags_x86_sse2 added to USE flags"
eerror "x86_64_v2 - cpu_flags_x86_cx16, cpu_flags_x86_fxsr, cpu_flags_x86_mmx, cpu_flags_x86_sse4_2, cpu_flags_x86_popcnt added to USE flags"
eerror "x86_64_v3 - cpu_flags_x86_avx2, cpu_flags_x86_bmi, cpu_flags_x86_bmi2, cpu_flags_x86_cx16, cpu_flags_x86_f16c, cpu_flags_x86_fma, cpu_flags_x86_fxsr, cpu_flags_x86_lzcnt, cpu_flags_x86_mmx, cpu_flags_x86_popcnt added to USE flags"
eerror
				die
			fi
			mycmakeargs+=(
				-DZIG_CPU="${generic_arch}"
			)
		elif [[ "${ARCH}" == "arm64" ]] ; then
			local generic_arch=""
			if \
				   use cpu_flags_arm_aes \
				&& use cpu_flags_arm_fp16fml \
				&& use cpu_flags_arm_sb \
				&& use cpu_flags_arm_sha3 \
				&& use cpu_flags_arm_ssbs \
				&& use cpu_flags_arm_v8_4a \
			; then
				generic_arch="apple_m1"
			elif \
				   use cpu_flags_arm_aes \
				&& use cpu_flags_arm_fp16 \
				&& use cpu_flags_arm_rnd \
				&& use cpu_flags_arm_sha3 \
				&& use cpu_flags_arm_v8_6a \
			; then
				generic_arch="ampere1"
			else
eerror
eerror "CPU is not supported"
eerror
eerror "At least one row must be completely enabled to continue."
eerror
eerror "<zig_cpu> - -march=<codename> added to CFLAGS"
eerror "apple_m1 - -mcpu=apple-m1 added to CFLAGS"
eerror "ampere1 - -mtune=ampere1 added to CFLAGS"
eerror "apple_m1 - cpu_flags_arm_aes, cpu_flags_arm_fp16fml, cpu_flags_arm_sb, cpu_flags_arm_sha3, cpu_flags_arm_ssbs, cpu_flags_arm_v8_4a added to USE flags"
eerror "ampere1 - cpu_flags_arm_aes, cpu_flags_arm_fp16, cpu_flags_arm_rnd, cpu_flags_arm_sha3, cpu_flags_arm_v8_6a added to USE flags"
eerror
				die
			fi
			mycmakeargs+=(
				-DZIG_CPU="${generic_arch}"
			)
		else
eerror "ARCH=${ARCH} is not supported"
			die
		fi
	fi
	cmake_src_configure
}

_configure_zig() {
	export ZIG_COMPILER="system"
	export PATH="/usr/lib/bun-zig/${BUN_ZIG_SLOT}/bin:${PATH}"
	ZIG="/usr/lib/bun-zig/${BUN_ZIG_SLOT}/bin/zig"
	"${ZIG}" version || die
}

src_configure() {
	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
		allow_lto=0
	fi

	cflags-hardened_append

	_configure_zig
	_configure_cmake
}

src_compile() {
	cmake_src_compile
}

src_test() {
	"./zig-out/bin/bun" -e "console.log('hello from bun')" || die
}

src_install() {
	dhms_end
	docinto "licenses"
	dodoc "LICENSE.md"

	if ! use telemetry ; then
ewarn "Reboot for telemetry disablement for ${P}"
	        dodir /etc/env.d
newenvd - 50${PN}-${BUN_SLOT}-${BUN_JSC_SLOT} <<-EOF
DO_NOT_TRACK=1
BUN_ENABLE_CRASH_REPORTING=0
BUN_CRASH_REPORT_URL="https://localhost"
EOF
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-REVDEP:  LocalAGI, lobe-chat
