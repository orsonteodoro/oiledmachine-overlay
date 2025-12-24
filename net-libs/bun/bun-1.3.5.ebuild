# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO:
#
# Build gentoo/stage3 docker image with oiledmachine-overlay with bun ebuild to lower SIMD requirements
#
# Proposed prebuilts or changes
#
# bun-linux-armv8a-glibc with -march=armv8-a
# bun-linux-armv8a-musl with -march=armv8-a
# bun-linux-x86_64-sse2-glibc with -march=x86-64
# bun-linux-x86_64-sse2-musl with -march=x86-64
#

CXX_STANDARD=23
BROTLI_PV="1.1.0"
NODEJS_PV="24.3.0"

BORINGSSL_COMMIT="f1ffd9e83d4f5c28a9c70d73f9a4e6fcf310062f"
C_ARES_COMMIT="3ac47ee46edd8ea40370222f91613fc16c434853"
HDRHISTOGRAM_C_COMMIT="be60a9987ee48d0abf0d7b6a175bad8d6c1585d1"
HIGHWAY_COMMIT="ac0d5d297b13ab1b89f48484fc7911082d76a93f"
LIBARCHIVE_COMMIT="9525f90ca4bd14c7b335e2f8c84a4607b0af6bdf"
LIBDEFLATE_COMMIT="c8c56a20f8f621e6a966b716b31f1dedab6a41e3"
LIBUV_COMMIT="f3ce527ea940d926c40878ba5de219640c362811"
LOL_HTML_COMMIT="d64457d9ff0143deef025d5df7e8586092b9afb7"
LS_HPACK_COMMIT="8905c024b6d052f083a3d11d0a169b3c2735c8a1"
MIMALLOC_COMMIT="1beadf9651a7bfdec6b5367c380ecc3fe1c40d1a"
PICOHTTPPARSER_COMMIT="066d2b1e9ab820703db0837a7255d92d30f0c9f5"
TINYCC_COMMIT="29985a3b59898861442fa3b43f663fc1af2591d7"
ZIG_COMMIT="c1423ff3fc7064635773a4a4616c5bf986eb00fe"
ZLIB_COMMIT="886098f3f339617b4243b286f5ed364b9989e245"
ZSTD_COMMIT="f8745da6ff1ad1e7bab384bd1f9d742439278e99"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX23[@]}"
)
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)"

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX23[@]/llvm_slot_}"
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
	"cpu_flags_x86_3dnowa"
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
	"cpu_flags_x86_sse4a"
	"cpu_flags_x86_sse4_2"
)

inherit cmake dep-prepare git-r3 libcxx-slot libstdcxx-slot

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
https://github.com/google/highway/archive/${HIGHWAY_COMMIT}.tar.gz
	-> highway-${HIGHWAY_COMMIT:0:7}.tar.gz
https://github.com/h2o/picohttpparser/archive/${PICOHTTPPARSER_COMMIT}.tar.gz
	-> picohttpparser-${PICOHTTPPARSER_COMMIT:0:7}.tar.gz
https://github.com/HdrHistogram/HdrHistogram_c/archive/${HDRHISTOGRAM_C_COMMIT}.tar.gz
	-> HdrHistogram_c-${HDRHISTOGRAM_C_COMMIT:0:7}.tar.gz
https://github.com/libuv/libuv/archive/${LIBUV_COMMIT}.tar.gz
	-> libuv-${LIBUV_COMMIT:0:7}.tar.gz
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

https://nodejs.org/dist/v${NODEJS_PV}/node-v${NODEJS_PV}-headers.tar.gz

	amd64? (
		!release-safe? (
https://github.com/oven-sh/zig/releases/download/autobuild-${ZIG_COMMIT}/bootstrap-x86_64-linux-musl.zip
	-> oven-sh-zig-${ZIG_COMMIT:0:7}-bootstrap-x86_64-linux-musl.zip
		)
		release-safe? (
https://github.com/oven-sh/zig/releases/download/autobuild-${ZIG_COMMIT}/bootstrap-x86_64-linux-musl-ReleaseSafe.zip
	-> oven-sh-zig-${ZIG_COMMIT:0:7}-bootstrap-x86_64-linux-musl-ReleaseSafe.zip
		)
	)
	"
fi

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
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_X86[@]}
lto release-safe
"
REQUIRED_USE="
	cpu_flags_x86_cx16? (
		cpu_flags_x86_mmx
	)
	cpu_flags_x86_fxsr? (
		cpu_flags_x86_mmx
	)
	cpu_flags_x86_sse4_2? (
		cpu_flags_x86_mmx
	)

	cpu_flags_x86_sse4a? (
		cpu_flags_x86_mmx
		cpu_flags_x86_lzcnt
		cpu_flags_x86_popcnt
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
RDEPEND+="
	net-libs/bun-jsc[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-1.3.5-march-changes.patch"
	"${FILESDIR}/${PN}-1.3.5-offline.patch"
)

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
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
	dep_prepare_mv "${WORKDIR}/bootstrap-${zig_arch}-linux-musl" "${S}/cmake/vendor/zig"
	dep_prepare_mv "${WORKDIR}/boringssl-${BORINGSSL_COMMIT}" "${S}/cmake/vendor/boringssl"
	dep_prepare_mv "${WORKDIR}/brotli-v${BROTLI_PV}" "${S}/cmake/vendor/brotli"
	dep_prepare_mv "${WORKDIR}/c-ares-${C_ARES_COMMIT}" "${S}/cmake/vendor/c-ares"
	dep_prepare_mv "${WORKDIR}/HdrHistogram_c-${HDRHISTOGRAM_C_COMMIT}" "${S}/cmake/vendor/HdrHistogram_c"
	dep_prepare_mv "${WORKDIR}/highway-${HIGHWAY_COMMIT}" "${S}/cmake/vendor/highway"
	dep_prepare_mv "${WORKDIR}/libarchive-${LIBARCHIVE_COMMIT}" "${S}/cmake/vendor/libarchive"
	dep_prepare_mv "${WORKDIR}/libdeflate-${LIBDEFLATE_COMMIT}" "${S}/cmake/vendor/libdeflate"
	dep_prepare_mv "${WORKDIR}/libuv-${LIBUV_COMMIT}" "${S}/cmake/vendor/libuv"
	dep_prepare_mv "${WORKDIR}/lol-html-${LOL_HTML_COMMIT}" "${S}/cmake/vendor/lol-html"
	dep_prepare_mv "${WORKDIR}/ls-hpack-${LS_HPACK_COMMIT}" "${S}/cmake/vendor/ls-hpack"
	dep_prepare_mv "${WORKDIR}/mimalloc-${MIMALLOC_COMMIT}" "${S}/cmake/vendor/mimalloc"
	dep_prepare_mv "${WORKDIR}/node-v${NODE_PV}" "${S}/cmake/vendor/"
	dep_prepare_mv "${WORKDIR}/picohttpparser-${PICOHTTPPARSER_COMMIT}" "${S}/cmake/vendor/picohttpparser"
	dep_prepare_mv "${WORKDIR}/tinycc-${TINYCC_COMMIT}" "${S}/cmake/vendor/tinycc"
	dep_prepare_mv "${WORKDIR}/zlib-${ZLIB_COMMIT}" "${S}/cmake/vendor/zlib"
	dep_prepare_mv "${WORKDIR}/zstd-${ZSTD_COMMIT}" "${S}/cmake/vendor/zstd"
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

src_configure() {
	local mycmakeargs=(
		-DENABLE_LTO=$(usex lto "ON" "OFF")
		-DENABLE_SIMD=$(usex simd "ON" "OFF")
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

		-DUSE_3DNOWA=$(usex cpu_flags_x86_3dnowa)
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
		-DUSE_SSE4A=$(usex cpu_flags_x86_sse4a)
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

src_compile() {
	cmake_src_compile
}

src_install() {
	docinto "licenses"
	dodoc "LICENSE.md"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
