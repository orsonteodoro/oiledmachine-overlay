# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dhms

# https://github.com/chromium/chromium/blob/138.0.7204.49/DEPS#L533
GN_COMMIT="ebc8f16ca7b0d36a3e532ee90896f9eb48e5423b"
GN_PV="0.2237" # See get_gn_ver.sh
# https://github.com/chromium/chromium/blob/138.0.7204.49/tools/clang/scripts/update.py#L38 \
LLVM_COMMIT="fd3fecfc"
LLVM_N_COMMITS="11777"
LLVM_OFFICIAL_SLOT="21" # Cr official slot
LLVM_SUB_REV="1"
# https://github.com/chromium/chromium/blob/138.0.7204.49/tools/rust/update_rust.py#L37 \
# grep 'RUST_REVISION = ' ${S}/tools/rust/update_rust.py -A1 | cut -c 17- # \
RUST_COMMIT="4a0969e06dbeaaa43914d2d00b2e843d49aa3886"
RUST_SUB_REV="1"
RUST_MAX_VER="1.86.0" # Inclusive
RUST_MIN_VER="1.86.0" # Corresponds to llvm-20.1, see https://github.com/rust-lang/rust/blob/4a0969e06dbeaaa43914d2d00b2e843d49aa3886/RELEASES.md
RUST_PV="${RUST_MIN_VER}"
VENDORED_CLANG_VER="llvmorg-${LLVM_OFFICIAL_SLOT}-init-${LLVM_N_COMMITS}-g${LLVM_COMMIT:0:8}-${LLVM_SUB_REV}"
VENDORED_RUST_VER="${RUST_COMMIT}-${RUST_SUB_REV}"

inherit check-compiler-switch edo flag-o-matic ninja-utils

KEYWORDS="~amd64"
S="${WORKDIR}"
SRC_URI="
	amd64? (
https://commondatastorage.googleapis.com/chromium-browser-clang/Linux_x64/clang-${VENDORED_CLANG_VER}.tar.xz
	-> chromium-${PV%%\.*}-${LLVM_COMMIT:0:7}-${LLVM_SUB_REV}-clang-linux-x64.tar.xz
https://commondatastorage.googleapis.com/chromium-browser-clang/Linux_x64/rust-toolchain-${VENDORED_RUST_VER}-${VENDORED_CLANG_VER%??}.tar.xz
	-> chromium-${PV%%\.*}-${RUST_COMMIT:0:7}-${RUST_SUB_REV}-rust-linux-x64.tar.xz
	)
https://gn.googlesource.com/gn/+archive/${GN_COMMIT}.tar.gz
	-> gn-${GN_COMMIT:0:7}.tar.gz
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
SLOT="0/${PV%.*}.x"
IUSE+="
ebuild_revision_10
"
REQUIRED_USE="
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
	check-compiler-switch_start
}

src_unpack() {
	mkdir -p "${WORKDIR}/gn" || die
	pushd "${WORKDIR}/gn" >/dev/null 2>&1 || die
		unpack "gn-${GN_COMMIT:0:7}.tar.gz"
		echo "${GN_PV}-${GN_COMMIT}" > gn-ver.txt || die
	popd >/dev/null 2>&1 || die

	mkdir -p "${WORKDIR}/clang" || die
	pushd "${WORKDIR}/clang" >/dev/null 2>&1 || die
		if [[ "${ARCH}" == "amd64" ]] ; then
			unpack "chromium-${PV%%\.*}-${LLVM_COMMIT:0:7}-${LLVM_SUB_REV}-clang-linux-x64.tar.xz"
		fi
		echo "${VENDORED_CLANG_VER}" > clang-ver.txt || die
	popd >/dev/null 2>&1 || die

	mkdir -p "${WORKDIR}/rust" || die
	pushd "${WORKDIR}/rust" >/dev/null 2>&1 || die
		if [[ "${ARCH}" == "amd64" ]] ; then
			unpack "chromium-${PV%%\.*}-${RUST_COMMIT:0:7}-${RUST_SUB_REV}-rust-linux-x64.tar.xz"
		fi
		echo "${VENDORED_RUST_VER}" > rust-ver.txt || die
	popd >/dev/null 2>&1 || die
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
	export PATH="${WORKDIR}/clang/bin:${PATH}"
	export CC="clang"
	export CXX="clang++"
	export CPP="${CC} -E"

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	build_gn

	cd "${WORKDIR}/clang" || die
	echo \
		"${VENDORED_CLANG_VER}" \
		> \
		"cr_build_revision" \
		|| die "Failed to set clang version"

	cd "${WORKDIR}/rust" || die
	cp \
		"VERSION" \
		"INSTALLED_VERSION" \
		|| die "Failed to set rust version"
}

_method1() {
	rm -rf "/usr/share/chromium/toolchain"
	mkdir -p "/usr/share/chromium/toolchain" || die
	# Bypass scanelf and writing to /var/pkg/db
	# Use filesystem tricks (pointer change) to speed up merge time.
	mv "${WORKDIR}/"* "/usr/share/chromium/toolchain" || die
# Completion time:  0 days, 0 hrs, 5 mins, 17 secs
}

_method2() {
	mkdir -p "/usr/share/chromium/toolchain" || die
	rsync -cavu "${WORKDIR}/" "/usr/share/chromium/toolchain" || die
# Completion time:  0 days, 0 hrs, 12 mins, 11 secs
}

_method3() {
	mkdir -p "/usr/share/chromium/toolchain" || die
	rsync -avu --delete "${WORKDIR}/" "/usr/share/chromium/toolchain" || die
# Completion time:  0 days, 0 hrs, 5 mins, 41 secs
}

src_install() {
	keepdir "/usr/share/chromium/toolchain"
	addwrite "/usr/share/chromium/toolchain"
	_method1
}

pkg_preinst() {
	dhms_end
	local count=$(find "/usr/share/chromium/toolchain/" -type f | wc -l)
	echo "${count}" >> "/usr/share/chromium/toolchain/file-count"
einfo "Files merged:"
	find "/usr/share/chromium/toolchain/"
einfo "QA:  Update chromium ebuild with tc_count_expected=${count}"
}

pkg_postrm() {
	if [[ -z "${REPLACED_BY_VERSION}" ]] ; then
		rm -rf "/usr/share/chromium/toolchain"
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
