# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See also
# https://github.com/oven-sh/bun/blob/bun-v1.2.0/cmake/tools/SetupWebKit.cmake#L5

BORINGSSL_COMMIT="914b005ef3ece44159dca0ffad74eb42a9f6679f"
BROTLI_PV="1.1.0"
C_ARES_COMMIT="b82840329a4081a1f1b125e6e6b760d4e1237b52"
CPU_FLAGS_X86=(
	cpu_flags_x86_avx2
)
LIBARCHIVE_COMMIT="898dc8319355b7e985f68a9819f182aaed61b53a"
LIBDEFLATE_COMMIT="78051988f96dc8d8916310d8b24021f01bd9e102"
LIBUV_COMMIT="da527d8d2a908b824def74382761566371439003"
LLVM_COMPAT=( 18 )
LOCKFILE_VER="1.2"
LOLHTML_COMMIT="4f8becea13a0021c8b71abd2dcc5899384973b66"
LS_HPACK_COMMIT="32e96f10593c7cb8553cd8c9c12721100ae9e924"
MIMALLOC_COMMIT="82b2c2277a4d570187c07b376557dc5bde81d848"
NODE_VERSION="20"
NPM_SLOT="3"
PICOHTTPPARSER_COMMIT="066d2b1e9ab820703db0837a7255d92d30f0c9f5"
RUST_COMPAT=(
	"1.81.0" # llvm 18
	"1.80.0" # llvm 18
	"1.79.0" # llvm 18
	"1.78.0" # llvm 18
)
TINYCC_COMMIT="29985a3b59898861442fa3b43f663fc1af2591d7"
ZIG_COMMIT="131a009ba2eb127a3447d05b9e12f710429aa5ee"
ZLIB_COMMIT="886098f3f339617b4243b286f5ed364b9989e245"
ZSTD_COMMIT="794ea1b0afca0f020f4e57b6732332231fb23c70"
YARN_SLOT="1"
WEBKIT_COMMIT="9e3b60e4a6438d20ee6f8aa5bec6b71d2b7d213f"
WEBKIT_PV="621.1.11"

inherit cmake dep-prepare npm yarn

#KEYWORDS="~amd64 ~arm64"
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
SLOT="${LOCKFILE_VER}"
IUSE+="
${CPU_FLAGS_X86[@]}
doc npm yarn
ebuild_revision_1
"
REQUIRED_USE="
	^^ (
		npm
		yarn
	)
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
	sys-apps/bun-webkit:${LOCKFILE_VER}-${WEBKIT_PV%%.*}
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
	npm? (
		sys-apps/npm:${NPM_SLOT}
	)
	yarn? (
		sys-apps/yarn:${YARN_SLOT}
	)
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
)

pkg_setup() {
	if use npm ; then
		npm_pkg_setup
	elif use yarn ; then
		yarn_pkg_setup
	fi
}

src_unpack() {
ewarn "Ebuild is in development"
	unpack ${A}
#	die
}

emulate_bun() {
	local pm

	if use npm ; then
		pm="npm"
	elif use yarn ; then
		pm="yarn"
	fi

	# Emulate bun because the baseline builds are all broken and produce
	# illegal instruction.
	mkdir -p "${HOME}/.bun/bin"
cat <<EOF > "${HOME}/.bun/bin/bun"
#!/bin/bash
ARGS=( "\$@" )
COMMAND="\${ARGS[0]}"
ARGS=( "\${ARGS[@]:1}" )
if [[ "${COMMAND}" == "x" ]] ; then
	npx "\${ARGS[@]}"
else
	${pm} "\${ARGS[@]}"
fi
EOF
	chmod +x "${HOME}/.bun/bin/bun" || die
	export PATH="${HOME}/.bun/bin:${PATH}"
	bun --version || die
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

	if use npm ; then
		sed -i \
			-e "s|--frozen-lockfile||g" \
			"${S}/cmake/Globals.cmake" \
			"${S}/cmake/analysis/RunPrettier.cmake" \
			"${S}/cmake/tools/SetupEsbuild.cmake" \
			|| die
	fi

	if use npm ; then
		npm_hydrate
		_npm_setup_offline_cache
		npm add npx --legacy-peer-deps
	elif use yarn ; then
		yarn_hydrate
		_yarn_setup_offline_cache
		npm add npx
	fi
	emulate_bun
	bun --version || die
	bun x --version || die
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
	if use npm ; then
		npm_hydrate
	elif use yarn ; then
		yarn_hydrate
	fi
	emulate_bun
	check_rust
	export CARGO_HOME="${ESYSROOT}/usr/bin"
	local mycmakeargs=(
		-DUSE_SYSTEM_ICU=ON
		-DWEBKIT_LOCAL=ON
		-DWEBKIT_PATH="/usr/share/bun-webkit/${LOCKFILE_VER}-${WEBKIT_PV%%.*}"
	)
	local abi=$(get_bun_abi)
	ABI="${abi}" \
	cmake_src_configure
}

src_compile() {
	if use npm ; then
		npm_hydrate
	elif use yarn ; then
		yarn_hydrate
	fi
	cmake_src_compile
}

src_install() {
	local d=$(get_dir)
	pushd "${d}" >/dev/null 2>&1 || die
		exeinto "/usr/bin"
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
