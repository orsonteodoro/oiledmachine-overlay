# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dhms

CXX_STANDARD=20 # Same as gn.  gn = c++20, llvm = c++17, clang = c++17, lld = c++17, libcxx = c++23, compiler-rt = c++17, compiler-rt-sanitizers = c++17
# https://github.com/chromium/chromium/blob/146.0.7680.71/DEPS#L533
GN_COMMIT="304bbef6c7e9a86630c12986b99c8654eb7fe648"
GN_PV="0.2324" # See get_gn_ver.sh
INSTALL_PREFIX="/usr/share/chromium/${PV%.*}.x"
# https://github.com/chromium/chromium/blob/146.0.7680.71/tools/clang/scripts/update.py#L38 \
LLVM_COMMIT="5bd8dadb" # without the g prefix
LLVM_LIVE_TIMESTAMP="Fri, 30 Jan 2026 13:04:23 +0000" # Timestamp from https://github.com/llvm/llvm-project/commit/${LLVM_COMMIT}.patch
LLVM_N_COMMITS="2224"
LLVM_OFFICIAL_SLOT="23" # Cr official slot
LLVM_SUB_REV="3"
LLVM_SLOT_UNSTABLE="23" # Comment out if using stable slot
# https://github.com/chromium/chromium/blob/146.0.7680.71/tools/rust/update_rust.py#L37 \
# grep 'RUST_REVISION = ' ${S}/tools/rust/update_rust.py -A1 | cut -c 17- # \
RUST_LIVE_TIMESTAMP="Feb 27, 2026 09:38:23 -0800" # Same as Rust 1.96.0 timestamp
RUST_COMMIT="7d8ebe3128fc87f3da1ad64240e63ccf07b8f0bd"
RUST_SUB_REV="3"
# Upstream uses 1.95.0 corresponding to LLVM 22.1
# This ebuild assumes 1.96.0 (live 9999) corresponding to llvm 22 to reduce build time.
# For the LLVM version used for Rust snapshot, see https://github.com/rust-lang/rust/blob/7d8ebe3128fc87f3da1ad64240e63ccf07b8f0bd/.gitmodules#L28
# For the Rust version, see https://github.com/rust-lang/rust/blob/7d8ebe3128fc87f3da1ad64240e63ccf07b8f0bd/src/version
RUST_MAX_VER="9999" # Inclusive
RUST_MIN_VER="9999" # Corresponds to llvm-22.1
RUST_PV="${RUST_MIN_VER}"
VENDORED_CLANG_VER="llvmorg-${LLVM_OFFICIAL_SLOT}-init-${LLVM_N_COMMITS}-g${LLVM_COMMIT:0:8}-${LLVM_SUB_REV}"
VENDORED_RUST_VER="${RUST_COMMIT}-${RUST_SUB_REV}"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX20[@]}" # For gn
)
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)"

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX20[@]/llvm_slot_}" # 20-22; For gn
)
LIBCXX_USEDEP_LTS="llvm_slot_skip(+)"

inherit check-compiler-switch edo flag-o-matic flag-o-matic-om libcxx-slot libstdcxx-slot multilib-minimal ninja-utils rust toolchain-funcs

KEYWORDS="~amd64"
S="${WORKDIR}"
SRC_URI="
https://gn.googlesource.com/gn/+archive/${GN_COMMIT}.tar.gz
	-> gn-${GN_COMMIT:0:7}.tar.gz
	!system-clang? (
		amd64? (
https://commondatastorage.googleapis.com/chromium-browser-clang/Linux_x64/clang-${VENDORED_CLANG_VER}.tar.xz
	-> chromium-${PV%%\.*}-${LLVM_COMMIT:0:7}-${LLVM_SUB_REV}-clang-linux-x64.tar.xz
		)
	)
	!system-rust? (
		amd64? (
https://commondatastorage.googleapis.com/chromium-browser-clang/Linux_x64/rust-toolchain-${VENDORED_RUST_VER}-${VENDORED_CLANG_VER%-*}.tar.xz
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
SLOT="${PV%.*}.x"
IUSE+="
${LLVM_COMPAT[@]/#/llvm_slot_}
+cfi +pgo -system-clang -system-rust
ebuild_revision_16
"
REQUIRED_USE="
	^^ (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
"

RDEPEND+="
	!www-client/chromium-toolchain:0
	system-clang? (
		=llvm-runtimes/compiler-rt-${LLVM_OFFICIAL_SLOT}*[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
		llvm-runtimes/compiler-rt:=
		=llvm-runtimes/clang-runtime-${LLVM_OFFICIAL_SLOT}*[${MULTILIB_USEDEP},compiler-rt,sanitize]
		llvm-runtimes/clang-runtime:=
		llvm-core/clang:${LLVM_OFFICIAL_SLOT}[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS},${MULTILIB_USEDEP}]
		llvm-core/clang:=
		llvm-core/lld:${LLVM_OFFICIAL_SLOT}[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
		llvm-core/lld:=
		llvm-core/llvm:${LLVM_OFFICIAL_SLOT}[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS},${MULTILIB_USEDEP}]
		llvm-core/llvm:=

		>=llvm-runtimes/libcxx-${LLVM_OFFICIAL_SLOT}[${LIBCXX_USEDEP},${LIBCXX_USEDEP},libcxxabi]
		llvm-runtimes/libcxx:=

		>=llvm-runtimes/libcxxabi-${LLVM_OFFICIAL_SLOT}[${LIBCXX_USEDEP},${LIBCXX_USEDEP}]
		llvm-runtimes/libcxxabi:=

		cfi? (
			=llvm-runtimes/compiler-rt-sanitizers-${LLVM_OFFICIAL_SLOT}*[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS},${MULTILIB_USEDEP},cfi]
			llvm-runtimes/compiler-rt-sanitizers:=
		)
		pgo? (
			=llvm-runtimes/compiler-rt-sanitizers-${LLVM_OFFICIAL_SLOT}*[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS},${MULTILIB_USEDEP},profile]
			llvm-runtimes/compiler-rt-sanitizers:=
		)
	)
	system-rust? (
		|| (
			=dev-lang/rust-9999
			=dev-lang/rust-bin-9999
		)
		|| (
			dev-lang/rust:=
			dev-lang/rust-bin:=
		)
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( )

verify_rust() {
	local is_nightly=$("${RUSTC}" --version | grep -q "nightly")
	is_nightly=$(( "${?}" == 0 ? 1 : 0 ))

	if (( ${is_nightly} == 0 )) ; then
eerror "Only nightly Rust is currently supported."
eerror "Switch to live with \`eselect rust\`"
		die
	fi

	if "${RUSTC}" --version | grep -q -e "nightly" ; then
		local compatible_time=$(date --date="${RUST_LIVE_TIMESTAMP}" "+%s")

		local merge_time
		local pkg_name
		if [[ "${RUSTC}" =~ "rust-bin" ]] ; then
			pkg_name="rust-bin"
			merge_time=$(cat "/var/db/pkg/dev-lang/rust-bin-9999/BUILD_TIME")
		else
			pkg_name="rust"
			merge_time=$(cat "/var/db/pkg/dev-lang/rust-9999/BUILD_TIME")
		fi
		if (( ${merge_time} < ${compatible_time} )) ; then
eerror
eerror "Detected old live timestamp."
eerror "Re-emerge ${pkg_name} or switch to Rust 1.96.0 or later."
eerror
eerror "Current timestamp:  "$(date --date="@${merge_time}")
eerror "Expected timestamp:  >= "$(date --date="@${compatible_time}")
eerror
			die
		fi
	else
		local actual_pv=$("${RUSTC}" --version | cut -f 2 -d " ")
		if ver_test "${actual_pv}" "-lt" "${RUST_MIN_VER}" ; then
eerror "Switch Rust to >= ${RUST_MIN_VER}"
			die
		fi
	fi
}

verify_clang() {
	if [[ -n "${LLVM_SLOT_UNSTABLE}" ]] ; then
		local upstream_timestamp=$(date --date="${LLVM_LIVE_TIMESTAMP}" "+%s")
		local L=(
			"llvm-core/clang"
			"llvm-core/llvm"
			"llvm-core/lld"
			"llvm-runtimes/libcxx"
			"llvm-runtimes/libcxxabi"
			"llvm-runtimes/compiler-rt"
			"llvm-runtimes/compiler-rt-sanitizers"
		)
		local pkg
		for pkg in "${L[@]}" ; do
			local pkg_timestamp=$(cat "/var/db/pkg/${pkg}-${LLVM_SLOT_UNSTABLE}"*"/BUILD_TIME")
			if (( ${pkg_timestamp} < ${upstream_timestamp} )) ; then
eerror
eerror "Detected old live timestamp."
eerror "Re-emerge ${pkg}."
eerror
eerror "Current timestamp:  "$(date --date="@${pkg_timestamp}")
eerror "Expected timestamp:  >= "$(date --date="@${upstream_timestamp}")
eerror
				die
			fi
		done
	fi
}

pkg_setup() {
	dhms_start
	check-compiler-switch_start
	libcxx-slot_verify
	libstdcxx-slot_verify
	rust_pkg_setup
	if use system-rust ; then
		verify_rust
	fi

	if use system-clang ; then
		verify_clang
	fi
}

src_unpack() {
	mkdir -p "${WORKDIR}/gn" || die
	pushd "${WORKDIR}/gn" >/dev/null 2>&1 || die
		unpack "gn-${GN_COMMIT:0:7}.tar.gz"
		echo "${GN_PV}-${GN_COMMIT}" > gn-ver.txt || die
	popd >/dev/null 2>&1 || die

	if ! use system-clang ; then
		mkdir -p "${WORKDIR}/clang" || die
		pushd "${WORKDIR}/clang" >/dev/null 2>&1 || die
			if [[ "${ARCH}" == "amd64" ]] ; then
				unpack "chromium-${PV%%\.*}-${LLVM_COMMIT:0:7}-${LLVM_SUB_REV}-clang-linux-x64.tar.xz"
			fi
			echo "${VENDORED_CLANG_VER}" > clang-ver.txt || die
		popd >/dev/null 2>&1 || die
	fi

	if ! use system-rust ; then
		mkdir -p "${WORKDIR}/rust" || die
		pushd "${WORKDIR}/rust" >/dev/null 2>&1 || die
			if [[ "${ARCH}" == "amd64" ]] ; then
				unpack "chromium-${PV%%\.*}-${RUST_COMMIT:0:7}-${RUST_SUB_REV}-rust-linux-x64.tar.xz"
			fi
			echo "${VENDORED_RUST_VER}" > rust-ver.txt || die
		popd >/dev/null 2>&1 || die
	fi
}

src_configure() {
	if use system-clang ; then
		local s
		for s in "${LLVM_COMPAT[@]}" ; do
			if use "llvm_slot_${s}" ; then
				LLVM_SLOT="${s}"
				break
			fi
		done

		local llvm_path="${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}"
		export PATH=$(echo "${PATH}" \
			| tr ":" $'\n' \
			| sed -E -e "/llvm\/[0-9]+/d" \
			| tr $'\n' ":" \
			| sed -e "s|/opt/bin|/opt/bin:${llvm_path}/bin|g")
		export CC="${CHOST}-clang-${s}"
		export CXX="${CHOST}-clang++-${s}"
		"${CC}" --version || die
	else
		local llvm_path="${WORKDIR}/clang"
		export PATH=$(echo "${PATH}" \
			| tr ":" $'\n' \
			| sed -E -e "/llvm\/[0-9]+/d" \
			| tr $'\n' ":" \
			| sed -e "s|/opt/bin|/opt/bin:${llvm_path}/bin|g")
		export CC="clang"
		export CXX="clang++"
	fi
	fix_mb_len_max
	append-flags -D_POSIX_C_SOURCE=200809L
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

	if ! use system-clang ; then
		cd "${WORKDIR}/clang" || die
		echo \
			"${VENDORED_CLANG_VER}" \
			> \
			"cr_build_revision" \
			|| die "Failed to set clang version"
	fi

	if ! use system-rust ; then
		cd "${WORKDIR}/rust" || die
		cp \
			"VERSION" \
			"INSTALLED_VERSION" \
			|| die "Failed to set rust version"
	fi
}

_method1() {
	rm -rf "${INSTALL_PREFIX}/toolchain"
	mkdir -p "${INSTALL_PREFIX}/toolchain" || die
	# Bypass scanelf and writing to /var/pkg/db
	# Use filesystem tricks (pointer change) to speed up merge time.
	mv "${WORKDIR}/"* "${INSTALL_PREFIX}/toolchain" || die
# Completion time:  0 days, 0 hrs, 5 mins, 17 secs
}

_method2() {
	mkdir -p "${INSTALL_PREFIX}/toolchain" || die
	rsync -cavu "${WORKDIR}/" "${INSTALL_PREFIX}/toolchain" || die
# Completion time:  0 days, 0 hrs, 12 mins, 11 secs
}

_method3() {
	mkdir -p "${INSTALL_PREFIX}/toolchain" || die
	rsync -avu --delete "${WORKDIR}/" "${INSTALL_PREFIX}/toolchain" || die
# Completion time:  0 days, 0 hrs, 5 mins, 41 secs
}

src_install() {
	keepdir "${INSTALL_PREFIX}/toolchain"
	addwrite "/usr/share/chromium"
	addwrite "${INSTALL_PREFIX}"
	addwrite "${INSTALL_PREFIX}/toolchain"
	_method1
}

pkg_preinst() {
	dhms_end
	local count=$(find "${INSTALL_PREFIX}/toolchain/" -type f | wc -l)
	echo "${count}" >> "${INSTALL_PREFIX}/toolchain/file-count"
einfo "Files merged:"
	find "${INSTALL_PREFIX}/toolchain/"
einfo "QA:  Update chromium ebuild with tc_count_expected=${count}"

	# Remove old unislot
	if [[ -e "/usr/share/chromium/toolchain" ]] ; then
		rm -rf "/usr/share/chromium/toolchain"
	fi
}

pkg_postrm() {
	if [[ -z "${REPLACED_BY_VERSION}" ]] ; then
		if ls "/usr/share/chromium/"*"/toolchain" ; then
	# Remove all multislots
			rm -rf "${INSTALL_PREFIX}/toolchain"
		fi
		if [[ "/usr/share/chromium/toolchain" ]] ; then
	# Remove unislot
			rm -rf "/usr/share/chromium/toolchain"
		fi
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
