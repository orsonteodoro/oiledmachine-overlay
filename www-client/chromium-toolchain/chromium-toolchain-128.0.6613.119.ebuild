# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# https://github.com/chromium/chromium/blob/128.0.6613.119/tools/clang/scripts/update.py#L38C41-L38C49 \
# grep 'CLANG_REVISION = ' ${S}/tools/clang/scripts/update.py -A1 | cut -c 18- # \
GN_PV="0.2175"
GN_COMMIT="b2afae122eeb6ce09c52d63f67dc53fc517dbdc8"
LLVM_COMMIT="ecea8371"
LLVM_OFFICIAL_SLOT="19" # Cr official slot
LLVM_SUB_REV="3000"
NUM_COMMITS="14561"
# https://github.com/chromium/chromium/blob/128.0.6613.119/tools/rust/update_rust.py#L37 \
# grep 'RUST_REVISION = ' ${S}/tools/rust/update_rust.py -A1 | cut -c 17- # \
RUST_COMMIT="3cf924b934322fd7b514600a7dc84fc517515346"
RUST_SUB_REV="3"
RUST_PV="1.79.0" # Based on changelog
VENDORED_CLANG_VER="llvmorg-${LLVM_OFFICIAL_SLOT}-init-${NUM_COMMITS}-g${LLVM_COMMIT:0:8}-${LLVM_SUB_REV}"
VENDORED_RUST_VER="${RUST_COMMIT}-${RUST_SUB_REV}"

inherit edo flag-o-matic ninja-utils

KEYWORDS="~amd64"
S="${WORKDIR}"
SRC_URI="
	clang? (
		amd64? (
			https://commondatastorage.googleapis.com/chromium-browser-clang/Linux_x64/clang-${VENDORED_CLANG_VER}.tar.xz
				-> chromium-${PV%%\.*}-${LLVM_COMMIT:0:7}-${LLVM_SUB_REV}-clang-linux-x64.tar.xz
		)
	)
	gn? (
		https://gn.googlesource.com/gn/+archive/${GN_COMMIT}.tar.gz
			-> gn-${GN_COMMIT:0:7}.tar.gz
	)
	rust? (
		amd64? (
			https://commondatastorage.googleapis.com/chromium-browser-clang/Linux_x64/rust-toolchain-${VENDORED_RUST_VER}-${VENDORED_CLANG_VER%?????}.tar.xz
				-> chromium-${PV%%\.*}-${RUST_COMMIT:0:7}-${RUST_SUB_REV}-rust-linux-x64.tar.xz
		)
	)
"

DESCRIPTION="The Chromium toolchain (Clang + Rust + gn)"
HOMEPAGE="https://www.chromium.org/"
LICENSE="
	chromium-$(ver_cut 1-3 ${PV}).x.html
"
RESTRICT="binchecks mirror strip"
SLOT="0/llvm${LLVM_OFFICIAL_SLOT}-rust$(ver_cut 1-2 ${RUST_PV})-gn${GN_PV}"
IUSE+=" +clang +gn +rust"
REQUIRED_USE="
	gn? (
		clang
	)
	|| (
		clang
		gn
		rust
	)
"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( )

src_unpack() {
	if use gn ; then
		mkdir -p "${WORKDIR}/gn" || die
		pushd "${WORKDIR}/gn" >/dev/null 2>&1 || die
			unpack "gn-${GN_COMMIT:0:7}.tar.gz"
			echo "${GN_PV}-${GN_COMMIT}" > gn-ver.txt || die
		popd >/dev/null 2>&1 || die
	fi
	if use clang ; then
		mkdir -p "${WORKDIR}/clang" || die
		pushd "${WORKDIR}/clang" >/dev/null 2>&1 || die
			if [[ "${ARCH}" == "amd64" ]] ; then
				unpack "chromium-${PV%%\.*}-${LLVM_COMMIT:0:7}-${LLVM_SUB_REV}-clang-linux-x64.tar.xz"
			fi
			echo "${VENDORED_CLANG_VER}" > clang-ver.txt || die
		popd >/dev/null 2>&1 || die
	fi
	if use rust ; then
		mkdir -p "${WORKDIR}/rust" || die
		pushd "${WORKDIR}/rust" >/dev/null 2>&1 || die
			if [[ "${ARCH}" == "amd64" ]] ; then
				unpack "chromium-${PV%%\.*}-${RUST_COMMIT:0:7}-${RUST_SUB_REV}-rust-linux-x64.tar.xz"
			fi
			echo "${VENDORED_RUST_VER}" > rust-ver.txt || die
		popd >/dev/null 2>&1 || die
	fi
}

build_gn() {
# Sync with gn ebuild:
	pushd "${WORKDIR}/gn" >/dev/null 2>&1 || die
		local gn_opt_level="-O2"
		if is-flagq "-Ofast" ; then
			gn_opt_level="-O3"
		elif is-flagq "-O4" ; then
			gn_opt_level="-O3"
		elif is-flagq "-O3" ; then
			gn_opt_level="-O3"
		elif is-flagq "-O2" ; then
			gn_opt_level="-O2"
		elif is-flagq "-O1" ; then
			gn_opt_level="-O1"
		elif is-flagq "-O0" ; then
			gn_opt_level="-O2"
		fi
		sed -i -e \
			"s|-O3|${gn_opt_level}|g" \
			"build/gen.py" \
			|| die
		if use elibc_musl ; then # bug 906362
			append-cflags -D_LARGEFILE64_SOURCE
			append-cxxflags -D_LARGEFILE64_SOURCE
		fi
einfo "Configuring gn"
		set -- ${EPYTHON} "build/gen.py" --no-last-commit-position --no-strip --no-static-libstdc++ --allow-warnings
		edo "$@"

# Fixes
#../src/gn/scope_per_file_provider.cc:15:10: fatal error: 'last_commit_position.h' file not found
#   15 | #include "last_commit_position.h"
#      |          ^~~~~~~~~~~~~~~~~~~~~~~~
#1 error generated.
cat >out/last_commit_position.h <<-EOF || die
#ifndef OUT_LAST_COMMIT_POSITION_H_
#define OUT_LAST_COMMIT_POSITION_H_
#define LAST_COMMIT_POSITION_NUM ${GN_PV##0.}
#define LAST_COMMIT_POSITION "${GN_PV}"
#endif  // OUT_LAST_COMMIT_POSITION_H_
EOF

einfo "Building gn"
		eninja -C out gn
		export PATH="${WORKDIR}/gn-${GN_COMMIT}/out:${PATH}"
		gn --version || die
		filter-flags -D_LARGEFILE64_SOURCE
	popd >/dev/null 2>&1 || die
}

src_compile() {
	if use gn ; then
		export PATH="${WORKDIR}/clang/bin:${PATH}"
		export CC="clang"
		export CXX="clang++"
		build_gn
	fi
}

src_install() {
	dodir "/usr/share/chromium/toolchain"
	cp -a "${WORKDIR}/"* "${ED}/usr/share/chromium/toolchain" || die
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
