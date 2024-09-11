# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dhms

# https://github.com/chromium/chromium/blob/128.0.6613.119/tools/clang/scripts/update.py#L38C41-L38C49 \
# grep 'CLANG_REVISION = ' ${S}/tools/clang/scripts/update.py -A1 | cut -c 18- # \
GN_PV="0.2175"
GN_COMMIT="b2afae122eeb6ce09c52d63f67dc53fc517dbdc8"
LLVM_COMMIT="ecea8371"
LLVM_N_COMMITS="14561"
LLVM_OFFICIAL_SLOT="19" # Cr official slot
LLVM_SUB_REV="3000"
# https://github.com/chromium/chromium/blob/128.0.6613.119/tools/rust/update_rust.py#L37 \
# grep 'RUST_REVISION = ' ${S}/tools/rust/update_rust.py -A1 | cut -c 17- # \
RUST_COMMIT="3cf924b934322fd7b514600a7dc84fc517515346"
RUST_SUB_REV="3"
RUST_PV="1.79.0" # Based on changelog
VENDORED_CLANG_VER="llvmorg-${LLVM_OFFICIAL_SLOT}-init-${LLVM_N_COMMITS}-g${LLVM_COMMIT:0:8}-${LLVM_SUB_REV}"
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

	(
		all-rights-reserved
		OFL-1.1
	)
	(
		Apache-2.0
		BSD
		CC-BY-3.0
		MIT
	)
	(
		Apache-2.0
		MIT
		public-domain
	)
	(
		Apache-2.0
		MIT
	)
	(
		BSD
		custom
		curl
		LGPL-2.1
		GPL-2
		openssl
		Unlicense
		ZLIB
	)
	(
		GPL-2+
		LGPL-2.1+
		public-domain
		|| (
			GPL-2+
			GPL-3+
		)
	)
	(
		icu
		Unicode-DFS-2016
	)
	(
		BSD
		public-domain
	)
	0BSD
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	Boost-1.0
	BSD
	BSD-2
	CC-BY-3.0
	custom
	GPL-2.0
	GPL-2.0
	GPL-3.0
	MIT
	MPL-2.0
	Unicode-3.0
	Unicode-DFS-2016
	Unlicense
	ZLIB
	|| (
		AFL-2.1
		GPL-2+
	)
	|| (
		MIT
		Unlicense
	)
	|| (
		MIT
		UoI-NCSA
	)
"

#( all-rights-reserved OFL-1.1 ) - rust/lib/rustlib/src/rust/vendor/mdbook-0.4.40/src/theme/fonts/SOURCE-CODE-PRO-LICENSE.txt
#0BSD - rust/lib/rustlib/src/rust/vendor/adler-1.0.2/LICENSE-0BSD
#Apache-2.0 - rust/lib/rustlib/src/rust/vendor/windows_x86_64_msvc-0.52.5/license-apache-2.0
#Apache-2.0 BSD CC-BY-3.0 MIT  - rust/lib/rustlib/src/rust/vendor/crossbeam-channel-0.5.13/LICENSE-THIRD-PARTY
#Apache-2.0 MIT public-domain - rust/lib/rustlib/src/rust/vendor/parse-zoneinfo-0.3.1/LICENSE
#Apache-2.0 MIT - rust/lib/rustlib/src/rust/vendor/chrono-0.4.38/LICENSE.txt
#Boost-1.0 - rust/lib/rustlib/src/rust/vendor/ryu-1.0.18/LICENSE-BOOST
#BSD - rust/lib/rustlib/src/rust/vendor/instant-0.1.13/LICENSE
#BSD custom curl LGPL-2.1 GPL-2 openssl Unlicense ZLIB - rust/share/doc/cargo/LICENSE-THIRD-PARTY
#BSD-2 - rust/lib/rustlib/src/rust/vendor/jemalloc-sys-0.5.4+5.3.0-patched/jemalloc/COPYING
#CC-BY-3.0 - rust/lib/rustlib/src/rust/vendor/crossbeam-channel-0.5.13/LICENSE-THIRD-PARTY
#GPL-2+ LGPL-2.1+ public-domain || ( GPL-2+ GPL-3+ ) - rust/lib/rustlib/src/rust/vendor/lzma-sys-0.1.20/xz-5.2/COPYING
#GPL-2.0 - rust/lib/rustlib/src/rust/vendor/libffi-sys-2.3.0/libffi/LICENSE-BUILDTOOLS
#GPL-2.0 - rust/lib/rustlib/src/rust/vendor/lzma-sys-0.1.20/xz-5.2/COPYING.GPLv2
#GPL-3.0 - rust/lib/rustlib/src/rust/vendor/lzma-sys-0.1.20/xz-5.2/COPYING.GPLv3
#MIT - rust/lib/rustlib/src/rust/vendor/windows_x86_64_msvc-0.52.5/license-mit
#MPL-2.0 - rust/lib/rustlib/src/rust/vendor/colored-2.1.0/LICENSE
#public-domain BSD - rust/lib/rustlib/src/rust/vendor/chrono-tz-0.9.0/tz/LICENSE
#Unicode-3.0 - rust/lib/rustlib/src/rust/vendor/yoke-0.7.4/LICENSE
#Unicode-DFS-2016 - rust/lib/rustlib/src/rust/vendor/regex-syntax-0.8.3/src/unicode_tables/LICENSE-UNICODE
#Unlicense - rust/lib/rustlib/src/rust/vendor/aho-corasick-1.1.3/UNLICENSE
#ZLIB - rust/lib/rustlib/src/rust/vendor/miniz_oxide-0.7.3/LICENSE-ZLIB.md
#|| ( AFL-2.1 GPL-2+ ) rust/lib/rustlib/src/rust/vendor/libdbus-sys-0.2.5/vendor/dbus/COPYING
#|| ( Unlicense MIT ) - rust/lib/rustlib/src/rust/vendor/byteorder-1.5.0/COPYING
#|| ( UoI-NCSA MIT ) - rust/lib/rustlib/src/rust/vendor/compiler_builtins-0.1.109/LICENSE.txt
#The distro's OFL-1.1 license template does not contain all rights reserved.
#custom - rust/lib/rustlib/src/rust/vendor/regex-automata-0.1.10/data/tests/fowler/LICENSE

#BSD - gn/LICENSE
#icu-2017 or icu-58 Unicode-DFS-2016 - gn/src/base/third_party/icu/LICENSE

#Apache-2.0-with-LLVM-exceptions - clang/lib/clang/19/include/__stdarg_va_copy.h

RESTRICT="binchecks mirror strip test"
SLOT="0/llvm${LLVM_OFFICIAL_SLOT}-rust$(ver_cut 1-2 ${RUST_PV})-gn${GN_PV}"
IUSE+=" +clang +gn +rust ebuild-revision-3"
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

pkg_setup() {
	dhms_start
}

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
	if use clang ; then
		cd "${WORKDIR}/clang" || die
		echo \
			"${VENDORED_CLANG_VER}" \
			> \
			"cr_build_revision" \
			|| die "Failed to set clang version"
	fi
	if use rust ; then
		cd "${WORKDIR}/rust" || die
		cp \
			"VERSION" \
			"INSTALLED_VERSION" \
			|| die "Failed to set rust version"
	fi
}

src_install() {
	addwrite "/usr/share/chromium/toolchain"
	rm -rf "/usr/share/chromium/toolchain"
	mkdir -p "/usr/share/chromium/toolchain" || die
	# Bypass scanelf and writing to /var/pkg/db
	# Use filesystem tricks (pointer change) to speed up merge time.
	mv "${WORKDIR}/"* "/usr/share/chromium/toolchain" || die
# With speed up changes:
# Completion time:  0 days, 0 hrs, 5 mins, 17 secs
}

pkg_preinst() {
	dhms_end
}

pkg_postrm() {
	if [[ -z "${REPLACED_BY_VERSION}" ]] ; then
		rm -rf "/usr/share/chromium/toolchain"
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
