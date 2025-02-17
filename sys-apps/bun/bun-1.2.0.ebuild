# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#
# Ebuild design note
#
# Definitions:
#
#   Stage 1:  node + yarn + bun wrapper -> bun stage 1 (generic) for portable build
#   ( The bun wrapper is supposed to emulate bun native. )
#   Stage 1 xor 2:  node + yarn + bun wrapper -> either bun stage 1 or bun stage 3
#   Stage 2:  bun stage 1 (generic) -> bun stage 2 (native) for optimized build
#   Stage 3:  bun stage 2 (native) -> bun stage 3 (native) for build verification
#
# Upstream assumptions:
#
#   bun stage 3 [haswell] -> bun stage 3 [haswell] ;  This is broken for pre haswell.
#
# Ebuild assumptions:
#
#   node + yarn + bun wrapper -> either bun stage 1 or bun stage 3 based on user choice
#

# Status:  Broken bun wrapper

# See also
# https://github.com/oven-sh/bun/blob/bun-v1.2.0/cmake/tools/SetupWebKit.cmake#L5

BORINGSSL_COMMIT="914b005ef3ece44159dca0ffad74eb42a9f6679f"
BROTLI_PV="1.1.0"
C_ARES_COMMIT="b82840329a4081a1f1b125e6e6b760d4e1237b52"
CMAKE_MAKEFILE_GENERATOR="emake"
CPU_FLAGS_ARM=(
	cpu_flags_arm_crc
)
LIBARCHIVE_COMMIT="898dc8319355b7e985f68a9819f182aaed61b53a"
LIBDEFLATE_COMMIT="78051988f96dc8d8916310d8b24021f01bd9e102"
LIBUV_COMMIT="da527d8d2a908b824def74382761566371439003"
LLVM_COMPAT=( 18 )
LOCKFILE_VER="1.2"
LOLHTML_COMMIT="4f8becea13a0021c8b71abd2dcc5899384973b66"
LS_HPACK_COMMIT="32e96f10593c7cb8553cd8c9c12721100ae9e924"
MIMALLOC_COMMIT="82b2c2277a4d570187c07b376557dc5bde81d848"
NODE_VERSION="22"
PICOHTTPPARSER_COMMIT="066d2b1e9ab820703db0837a7255d92d30f0c9f5"
RUST_COMPAT=(
	"1.81.0" # llvm 18
	"1.80.0" # llvm 18
	"1.79.0" # llvm 18
	"1.78.0" # llvm 18
)
TINYCC_COMMIT="29985a3b59898861442fa3b43f663fc1af2591d7"
WEBKIT_COMMIT="9e3b60e4a6438d20ee6f8aa5bec6b71d2b7d213f"
WEBKIT_PV="621.1.11"
YARN_SLOT="1"
ZIG_COMMIT="131a009ba2eb127a3447d05b9e12f710429aa5ee"
ZLIB_COMMIT="886098f3f339617b4243b286f5ed364b9989e245"
ZSTD_COMMIT="794ea1b0afca0f020f4e57b6732332231fb23c70"

inherit cmake dep-prepare yarn

#KEYWORDS="~amd64 ~arm64" # Ebuild unfinished
S="${WORKDIR}/${PN}-${PN}-v${PV}"
SRC_URI="
https://github.com/c-ares/c-ares/archive/${C_ARES_COMMIT}.tar.gz
	-> c-ares-${C_ARES_COMMIT:0:7}.tar.gz
https://github.com/cloudflare/lol-html/archive/${LOLHTML_COMMIT}.tar.gz
	-> lol-html-${LOLHTML_COMMIT:0:7}.tar.gz
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
https://github.com/libarchive/libarchive/archive/${LIBARCHIVE_COMMIT}.tar.gz
	-> libarchive-${LIBARCHIVE_COMMIT:0:7}.tar.gz
https://github.com/libuv/libuv/archive/${LIBUV_COMMIT}.tar.gz
	-> libuv-${LIBUV_COMMIT:0:7}.tar.gz
https://github.com/litespeedtech/ls-hpack/archive/${LS_HPACK_COMMIT}.tar.gz
	-> ls-hpack-${LS_HPACK_COMMIT:0:7}.tar.gz
https://github.com/oven-sh/boringssl/archive/${BORINGSSL_COMMIT}.tar.gz
	-> oven-sh-boringssl-${BORINGSSL_COMMIT:0:7}.tar.gz
https://github.com/oven-sh/bun/archive/refs/tags/bun-v${PV}.tar.gz
https://github.com/oven-sh/mimalloc/archive/${MIMALLOC_COMMIT}.tar.gz
	-> oven-sh-mimalloc-${MIMALLOC_COMMIT:0:7}.tar.gz
https://github.com/oven-sh/tinycc/archive/${TINYCC_COMMIT}.tar.gz
	-> oven-sh-tinycc-${TINYCC_COMMIT:0:7}.tar.gz
https://github.com/oven-sh/zig/archive/${ZIG_COMMIT}.tar.gz
	-> oven-sh-zig-${ZIG_COMMIT:0:7}.tar.gz
"

DESCRIPTION="Incredibly fast JavaScript runtime, bundler, test runner, and package manager – all in one"
HOMEPAGE="
https://bun.sh/
https://github.com/oven-sh/bun
"
LICENSE="
	(
		BSD
		BSD-2
		CC0-1.0
		public-domain
	)
	(
		BSD
		ISC
		MIT
		openssl
		SSLeay
	)
	(
		Apache-2.0-with-LLVM-exceptions
		custom
		GPL-2+
		LGPL-2+
		LGPL-2.1
		MIT
	)
	Apache-2.0
	BSD
	BSD-2
	icu-72.1
	LGPL-2+
	MIT
	ZLIB
	|| (
		MIT
		|| (
			Artistic
			GPL-1+
		)
	)
	|| (
		BSD
		GPL-2
	)
"
# Apache-2.0-with-LLVM-exceptions - tinycc/include/stdatomic.h
# custom - tinycc/lib/lib-arm64.c
# GPL-2+ - tinycc/lib/libtcc1.c
# LGPL-2+ - tinycc/lib/bcheck.c
# MIT - tinycc
RESTRICT="mirror"
SLOT="${LOCKFILE_VER}-${NODE_VERSION}"
IUSE+="
${CPU_FLAGS_ARM[@]}
doc
ebuild_revision_1
"
gen_rust_depend() {
	local s
	for s in ${RUST_COMPAT[@]} ; do
		echo "
			dev-lang/rust-bin:${s}
			dev-lang/rust:${s}
		"
	done
}
gen_llvm_depend() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm-core/llvm:${s}
			llvm-core/clang:${s}
			llvm-core/lld:${s}
		"
	done
}
RDEPEND+="
	$(gen_llvm_depend)
	sys-apps/bun-webkit:${WEBKIT_PV%%.*}
	sys-apps/bun-webkit:=
	llvm-core/llvm:=
	llvm-core/clang:=
	llvm-core/lld:=
"
DEPEND+="
	${RDEPEND}
"
BOOTSTRAP_BDEPEND="
	net-libs/nodejs:${NODE_VERSION}[corepack]
	sys-apps/yarn:${YARN_SLOT}
"
BDEPEND+="
	${BOOTSTRAP_BDEPEND}
	$(gen_llvm_depend)
	$(gen_rust_depend)
	dev-build/cmake
	llvm-core/llvm:=
	llvm-core/clang:=
	llvm-core/lld:=
"
PATCHES=(
	"${FILESDIR}/${PN}-1.2.0-llvm-path.patch"
	"${FILESDIR}/${PN}-1.2.0-webkit-path.patch"
	"${FILESDIR}/${PN}-1.2.0-symbolize-arch-targets.patch"
	"${FILESDIR}/${PN}-1.2.0-offline-install-changes.patch"
)

pkg_setup() {
	yarn_pkg_setup
}

src_unpack() {
ewarn "Ebuild is in development"
	unpack ${A}
#die
}

emulate_bun() {
	local pm

	# Emulate bun because the baseline builds are all broken and produce
	# illegal instruction.  The reason why because of vendor lock-in.
	mkdir -p "${HOME}/.bun/bin"
	cp -a \
		"${FILESDIR}/bun-stage0" \
		"${HOME}/.bun/bin/bun" \
		|| die
	chmod +x "${HOME}/.bun/bin/bun" || die
	sed -i \
		-e "s|@NODE_VERSION@|${NODE_VERSION}|g" \
		"${HOME}/.bun/bin/bun" \
		|| die
	export PATH="${HOME}/.bun/bin:${PATH}"
	bun --version || die
}

gcc_mcpu() {
	local ARCHES=(
		"apple-m1"
		"apple-m2"
	)

	# For ARM, see https://github.com/ziglang/zig/blob/131a009ba2eb127a3447d05b9e12f710429aa5ee/lib/std/zig/system/arm.zig#L24

	local found=""
	local x
	for x in ${ARCHES[@]} ; do
		if [[ "${CFLAGS}" =~ "-mcpu=${x}"(" "|$) ]] ; then
			found="${x}"
			break
		fi
	done

	if [[ -z "${found}" ]] ; then
		local flag=$(echo "${CFLAGS}" \
			| grep -E -e "-mcpu=[a-zA-Z0-9-]+")
eerror
eerror "Unsupported -mcpu= detected"
eerror "You must set or change -mcpu to supported arch"
eerror
eerror "Actual -mcpu=?:  ${flag}"
eerror "Supported arches:  ${ARCHES[@]}"
eerror
		die
	fi
	echo "${found}"
}

gcc_march_arm64() {
	local ARCHES=(
		"armv8-a"
		"armv8.1-a"
		"armv8.2-a"
		"armv8.3-a"
		"armv8.4-a"
		"armv8.5-a"
		"armv8.6-a"
		"armv8.7-a"
		"armv8.8-a"
		"armv8.9-a"
		"armv9-a"
		"armv9.1-a"
		"armv9.2-a"
		"armv9.3-a"
		"armv9.4-a"
		"armv9.5-a"
		"armv8-r"
	)

	# For ARM, see https://gcc.gnu.org/onlinedocs/gcc/AArch64-Options.html#index-march

	local found=""
	local x
	for x in ${ARCHES[@]} ; do
		if [[ "${CFLAGS}" =~ "-march=${x}"(" "|$) ]] ; then
			found="${x}"
			break
		fi
	done

	if [[ -z "${found}" ]] ; then
		local flag=$(echo "${CFLAGS}" \
			| grep -E -e "-march=[a-zA-Z0-9-]+")
eerror
eerror "Unsupported -march= detected"
eerror "You must set or change -march to supported arch"
eerror
eerror "Actual -march=?:  ${flag}"
eerror "Supported arches:  ${ARCHES[@]}"
eerror
		die
	fi

	if use cpu_flags_arm_crc ; then
		found+="+crc"
	fi
	echo "${found}"
}

gcc_march() {
	local ARCHES=(
		"amdfam10"
		"btver1"
		"btver2"
		"znver1"
		"znver2"
		"znver3"
		"znver4"
		#"znver5"

		"core2"
		"penryn"
		"nehalem"
		"westmere"
		"sandybridge"
		"ivybridge"
		"haswell"
		"broadwell"
		"skylake"
		#"rocketlake"
		"cooperlake"
		"cascadelake"
		"skylake-avx512"
		"cannonlake"
		"icelake-client"
		"icelake-server"
		#"tigerlake"
		#"alderlake"
		#"gracemont"
		#"raptorlake"
		#"meteorlake"
		#"arrowlake"
		#"arrowlake-s"
		#"lunarlake"
		#"pantherlake"
		#"graniterapids"
		#"graniterapids-d"
		#"emeraldrapids"
		#"sapphirerapids"
		"bonnell"
		"silvermont"
		"goldmont"
		"goldmont-plus"
		"tremont"
		#"sierraforest"
		#"grandridge"
		#"clearwaterforest"
		"knl"
		"knm"
	)

	# For AMD, see https://github.com/ziglang/zig/blob/131a009ba2eb127a3447d05b9e12f710429aa5ee/lib/std/zig/system/x86.zig#L227
	# For Intel, see https://github.com/ziglang/zig/blob/131a009ba2eb127a3447d05b9e12f710429aa5ee/lib/std/zig/system/x86.zig#L77

	local found=""
	local x
	for x in ${ARCHES[@]} ; do
		if [[ "${CFLAGS}" =~ "-march=${x}"(" "|$) ]] ; then
			found="${x}"
			break
		fi
	done

	if [[ -z "${found}" ]] ; then
		local flag=$(echo "${CFLAGS}" \
			| grep -E -e "-march=[a-zA-Z0-9-]+")
eerror
eerror "Unsupported -march= detected"
eerror "You must set or change -march to supported arch"
eerror
eerror "Actual -march=?:  ${flag}"
eerror "Supported arches:  ${ARCHES[@]}"
eerror
		die
	fi
	echo "${found}"
}

gcc_mtune() {
	local ARCHES=(
		"apple-m1"
		"apple-m2"

		"cortex-a34"
		"cortex-a35"
		"cortex-a53"
		"cortex-a55"
		"cortex-a57"
		"cortex-a65"
		"cortex-a65ae"
		"cortex-a72"
		"cortex-a73"
		"cortex-a75"
		"cortex-a76"
		"cortex-a77"
		"cortex-a78"
		"cortex-a78c"
		"cortex-x1c"
		"cortex-x1"
		"neoverse-n1"

		"thunderx2t99"

		"thunderx"
		"thunderxt81"
		"thunderxt83"
		"thunderxt88"
		"thunderx2t99"

		"a64fx"

		"tsv110"

		"carmel"

		"emag"
		"xgene1"

		"kryo"
		"falkor"
		"saphira"
	)

	# For ARM, see https://github.com/ziglang/zig/blob/131a009ba2eb127a3447d05b9e12f710429aa5ee/lib/std/zig/system/arm.zig#L24

	local found=""
	local x
	for x in ${ARCHES[@]} ; do
		if [[ "${CFLAGS}" =~ "-mtune=${x}"(" "|$) ]] ; then
			found="${x}"
			break
		fi
	done

	if [[ -z "${found}" ]] ; then
		local flag=$(echo "${CFLAGS}" \
			| grep -E -e "-mtune=[a-zA-Z0-9-]+")
eerror
eerror "Unsupported -mtune= detected"
eerror "You must set or change -mtune to supported arch"
eerror
eerror "Actual -mtune=?:  ${flag}"
eerror "Supported arches:  ${ARCHES[@]}"
eerror
		die
	fi
	echo "${found}"
}

src_prepare() {
	dep_prepare_mv "${WORKDIR}/boringssl-${BORINGSSL_COMMIT}" "${S}/vendor/boringssl"
	dep_prepare_mv "${WORKDIR}/brotli-${BROTLI_PV}" "${S}/vendor/brotli"
	dep_prepare_mv "${WORKDIR}/c-ares-${C_ARES_COMMIT}" "${S}/vendor/cares"
	dep_prepare_mv "${WORKDIR}/libdeflate-${LIBDEFLATE_COMMIT}" "${S}/vendor/libdeflate"
	dep_prepare_mv "${WORKDIR}/ls-hpack-${LS_HPACK_COMMIT}" "${S}/vendor/lshpack"
	dep_prepare_mv "${WORKDIR}/mimalloc-${MIMALLOC_COMMIT}" "${S}/vendor/mimalloc"
	dep_prepare_mv "${WORKDIR}/picohttpparser-${PICOHTTPPARSER_COMMIT}" "${S}/vendor/picohttpparser"
	dep_prepare_mv "${WORKDIR}/tinycc-${TINYCC_COMMIT}" "${S}/vendor/tinycc"
	dep_prepare_mv "${WORKDIR}/zig-${ZIG_COMMIT}" "${S}/vendor/zig"
	dep_prepare_mv "${WORKDIR}/zlib-${ZLIB_COMMIT}" "${S}/vendor/zlib"
	dep_prepare_mv "${WORKDIR}/zstd-${ZSTD_COMMIT}" "${S}/vendor/zstd"

	cmake_src_prepare

	replace-flags '-march=barcelona' '-march=amdfam10'

einfo "CFLAGS:  ${CFLAGS}"
einfo "CXXFLAGS:  ${CXXFLAGS}"

	local compiler_flags="-march=nehalem"
	local zig_target_aarch64="cortex_a35"
	local zig_target_x86="nehalem"
	local zig_cpu_target="nehalem"

	if [[ "${ARCH}" == "arm64-macos" ]] ; then
		compiler_flags="-mcpu="$(gcc_mcpu)
		zig_target_aarch64=$(gcc_mcpu)
		zig_cpu_target=$(gcc_mcpu)
	elif [[ "${ARCH}" == "arm64" ]] ; then
		compiler_flags="-march="$(gcc_march_arm64)" -mtune="$(gcc_mtune)
		zig_target_aarch64=$(gcc_mtune)
		zig_cpu_target=$(gcc_mtune)
	elif [[ "${ARCH}" == "amd64" ]] ; then
		compiler_flags="-march="$(gcc_march)
		zig_target_x86=$(gcc_march)
		zig_cpu_target=$(gcc_march)
	else
eerror "ARCH=${ARCH} ABI=${ABI} is not supported."
		die
	fi

	zig_target_aarch64="${zig_target_aarch64/-/_}"
	zig_target_x86="${zig_target_x86/-/_}"
	zig_cpu_target="${zig_cpu_target/-/_}"

	sed -i \
		-e "s|@ZIG_TARGET_AARCH64@|${zig_target_aarch64}|g" \
		-e "s|@ZIG_TARGET_X86@|${zig_target_x86}|g" \
		-e "s|@COMPILER_FLAGS@|${compiler_flags}|g" \
		-e "s|@ZIG_CPU_TARGET@|${zig_cpu_target}|g" \
		"${S}/Makefile" \
		"${S}/build.zig" \
		"${S}/cmake/CompilerFlags.cmake" \
		"${S}/cmake/targets/BuildBun.cmake" \
		|| die

	yarn_hydrate
	_yarn_setup_offline_cache
	eyarn add npx --ignore-workspace-root-check
	eyarn add tsx -D --ignore-workspace-root-check
	emulate_bun
	bun --version || die
	[[ -e "node_modules/.bin/npx" ]] || die
	[[ -e "node_modules/.bin/tsx" ]] || die
}

get_bun_abi() {
	if [[ "${ELIBC}" == "glibc" ]] ; then
		echo "gnu"
	elif [[ "${ELIBC}" == "musl" ]] ; then
		echo "musl"
	else
eerror "ELIBC=${ELIBC} is not supported"
		die
	fi
}

check_rust() {
	local rust_pv=$(rustc --version \
		| cut -f 2 -d " ")
	local installed_pkgs=()
	local found=0
	local s
	for s in ${RUST_COMPAT[@]} ; do
		local v1="${rust_pv%.*}"
		local v2="${s%.*}"
		if ver_test "${v1}" -eq "${v2}" ; then
			found=1
		fi
		if has_version "dev-lang/rust:${s}" ; then
			installed_pkgs+=( "dev-lang/rust:${s}" )
		fi
		if has_version "dev-lang/rust-bin:${s}" ; then
			installed_pkgs+=( "dev-lang/rust-bin:${s}" )
		fi
	done
	if (( ${found} == 0 )) ; then
eerror
eerror "You need to see \`eselect rust\` to switch to a llvm ${LLVM_COMPAT[@]} compatible"
eerror "Rust build."
eerror
eerror "Actual rustc:  ${rust_pv}"
eerror "Expected rustc:  ${RUST_COMPAT[@]}"
eerror "Installed rust packages:  ${installed_pkgs[@]}"
eerror
	fi
}

src_configure() {
	yarn_hydrate
	emulate_bun
	check_rust
	export MAKEOPTS="-j1"

	export CC="${CHOST}-clang-18"
	export CXX="${CHOST}-clang++-18"
	export CPP="${CHOST}-clang-18 -E"
	append-flags -fuse-ld=lld
	strip-unsupported-flags

	export CARGO_HOME="${ESYSROOT}/usr/bin"
	local mycmakeargs=(
		-DENABLE_LLVM=ON
		-DOFFLINE=ON
		-DNODEJS_HEADERS_PATH="${ESYSROOT}/usr"
		-DUSE_SYSTEM_ICU=ON
		-DWEBKIT_LOCAL=ON
		-DWEBKIT_PATH="/usr/share/bun-webkit/${WEBKIT_PV%%.*}"
	)

	local abi=$(get_bun_abi)
	ABI="${abi}" \
	cmake_src_configure
}

src_compile() {
	yarn_hydrate
	cmake_src_compile
}

src_install() {
	local d=$(get_dir)
	pushd "${d}" >/dev/null 2>&1 || die
		exeinto "/opt/bun/${SLOT}"
		doexe "bun"
	popd >/dev/null 2>&1 || die
	pushd "${WORKDIR}/bun-bun-v${PV}" >/dev/null 2>&1 || die
		docinto "licenses"
		dodoc "LICENSE.md"
		if use doc ; then
			docinto "readmes"
			dodoc "README.md"
			insinto "/usr/share/${PN}"
			doins -r "docs"
		fi
	popd >/dev/null 2>&1 || die
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
