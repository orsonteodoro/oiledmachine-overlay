# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Bootstrap plan (Tentative):

# Build Bun 1.1.26 with Bun's Zig for generic Bun.
# Build 1 or more generic Buns with lowest possible ISA SIMD (-march=x86-64, -march=armv8-a) towards the latest stable bun.
# Build Bun latest stable with generic Bun as feature complete Bun.
# Boostrapping Bun is similar to bootstrapping Rust where the previous version bootstraps to next version.

# 1.1.26 is being tested before major cmake changes requiring Bun -> Bun bootstrap.

# 1.1.26    Bun's Zig to generic Bun 1.1.26
# M         generic Bun 1.2.26 -> M generic Bun
# ...
# N         generic Bun M -> Bun N generic Bun
# 1.3.35    generic Bun N to feature complete Bun 1.3.5.  Steps will merge if possible to save time.

# Deps versions:
# https://github.com/oven-sh/bun/tree/bun-v1.1.26/src/deps
# https://github.com/oven-sh/bun/tree/bun-v1.1.26/src/bun.js		# Older WebKit commit
# https://github.com/oven-sh/bun/blob/bun-v1.1.26/CMakeLists.txt#L7	# Newer WebKit commit

CXX_STANDARD=20

BROTLI_PV="1.1.0"
BUN_JSC_SLOT="20240816"
BUN_SLOT=$(ver_cut "1-2" "${PV}")
BUN_ZIG_SLOT="20240708"
NODE_PV="22.6.0"
NODE_SLOT="${NODE_PV%%.*}"

BUN_SEED_SLOT="TBA"

BORINGSSL_COMMIT="29a2cd359458c9384694b75456026e4b57e3e567"
C_ARES_COMMIT="d1722e6e8acaf10eb73fa995798a9cd421d9f85e"
LIBARCHIVE_COMMIT="898dc8319355b7e985f68a9819f182aaed61b53a"
LIBDEFLATE_COMMIT="dc76454a39e7e83b68c3704b6e3784654f8d5ac5"
LOL_HTML_COMMIT="8d4c273ded322193d017042d1f48df2766b0f88b"
LS_HPACK_COMMIT="3d0f1fc1d6e66a642e7a98c55deb38aa986eb4b0"
MIMALLOC_COMMIT="4c283af60cdae205df5a872530c77e2a6a307d43"
PICOHTTPPARSER_COMMIT="066d2b1e9ab820703db0837a7255d92d30f0c9f5"
TINYCC_COMMIT="ab631362d839333660a265d3084d8ff060b96753"
WEBKIT_COMMIT="21fc366db3de8f30dbb7f5997b9b9f5cf422ff1e" # Same as newer prebuilt
ZIG_COMMIT="131a009ba2eb127a3447d05b9e12f710429aa5ee"
ZLIB_COMMIT="886098f3f339617b4243b286f5ed364b9989e245"
ZSTD_COMMIT="794ea1b0afca0f020f4e57b6732332231fb23c70"

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

inherit check-compiler-switch cmake dep-prepare dhms edo git-r3 libcxx-slot libstdcxx-slot node

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
https://github.com/c-ares/c-ares/archive/${C_ARES_COMMIT}.tar.gz
	-> c-ares-${C_ARES_COMMIT:0:7}.tar.gz
https://github.com/cloudflare/lol-html/archive/${LOL_HTML_COMMIT}.tar.gz
	-> lol-html-${LOL_HTML_COMMIT:0:7}.tar.gz
https://github.com/cloudflare/zlib/archive/${ZLIB_COMMIT}.tar.gz
	-> cloudflare-zlib-${ZLIB_COMMIT:0:7}.tar.gz
https://github.com/ebiggers/libdeflate/archive/${LIBDEFLATE_COMMIT}.tar.gz
	-> libdeflate-${LIBDEFLATE_COMMIT:0:7}.tar.gz
https://github.com/facebook/zstd/archive/${ZSTD_COMMIT}.tar.gz
	-> zstd-${ZSTD_COMMIT:0:7}.tar.gz
https://github.com/google/brotli/archive/refs/tags/v${BROTLI_PV}.tar.gz
	-> brotli-${BROTLI_PV}.tar.gz
https://github.com/h2o/picohttpparser/archive/${PICOHTTPPARSER_COMMIT}.tar.gz
	-> picohttpparser-${PICOHTTPPARSER_COMMIT:0:7}.tar.gz
https://github.com/litespeedtech/ls-hpack/archive/${LS_HPACK_COMMIT}.tar.gz
	-> ls-hpack-${LS_HPACK_COMMIT:0:7}.tar.gz
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
SLOT="${BUN_SLOT}-${BUN_JSC_SLOT}/${PV}"
IUSE+="
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_X86[@]}
bootstrap clang lto
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
	"${FILESDIR}/${PN}-1.3.5-offline.patch"
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
	dep_prepare_mv "${WORKDIR}/libdeflate-${LIBDEFLATE_COMMIT}" "${S}/src/deps/libdeflate"
	dep_prepare_mv "${WORKDIR}/lol-html-${LOL_HTML_COMMIT}" "${S}/src/deps/lol-html"
	dep_prepare_mv "${WORKDIR}/ls-hpack-${LS_HPACK_COMMIT}" "${S}/src/deps/ls-hpack"
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
			-DDEFAULT_MARCH="${march}"
		)
	fi

	if [[ -n "${mtune}" ]] ; then
		mycmakeargs+=(
			-DDEFAULT_MTUNE="${mtune}"
		)
	fi

	if [[ -n "${mcpu}" ]] ; then
		mycmakeargs+=(
			-DDEFAULT_MCPU="${mcpu}"
		)
	fi

	if [[ -n "${march}" ]] ; then
		mycmakeargs+=(
			-DDEFAULT_ZCPU="${march/-/_}"
		)
	elif [[ -n "${mcpu}" ]] ; then
		mycmakeargs+=(
			-DDEFAULT_ZCPU="${mcpu/-/_}"
		)
	fi
	cmake_src_configure
}

_configure_zig() {
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

	if use bootstrap ; then
		_configure_zig
	else
		_configure_cmake
	fi
}

src_compile() {
	if use bootstrap ; then
		[[ -e "${S}/build.zig" ]] || die "Missing build.zig"
einfo "Building with zig"
		local codegen_dir="build/debug/codegen"
		mkdir -p "${codegen_dir}" || die

	# Bun is still required

	# Use TypeScript bindgen to generate C/C++ bindings
	# Bypass cmake to build the seed artifact.  Once we have the seed, we can build the latest feature complete Bun.
		#BUN_SEED_PATH="/usr/lib/bin/${BUN_SEED_SLOT}/bin/bun"	# Possibility 1 - A previous ancestor Bun must be used to build this version.
		#BUN_SEED_PATH="${BUILD_DIR}/bin/bun"			# Possibility 2 - Bun's Zig builds Bun within this version.

#		edo "${BUN_SEED_PATH}" run "./src/codegen/bindgen.ts" --debug=0 --codegen-root="${codegen_dir}"

#		edo "${BUN_SEED_PATH}" run "./src/codegen/generate-jssink.ts" "${codegen_dir}"

		edo "${ZIG}" build -Drelease-fast -Dgenerated-code="build/debug/codegen"
	else
einfo "Building with bun"
		cmake_src_compile
	fi
}

src_test() {
	if use bootstrap ; then
		"./zig-out/bin/bun" -e "console.log('hello from bun')" || die
	fi
}

src_install() {
	dhms_end
	docinto "licenses"
	dodoc "LICENSE.md"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-REVDEP:  LocalAGI, lobe-chat
