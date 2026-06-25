# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild fork used AI inference for help.
# This ebuild fork uses a patches that uses AI generated code.
# This ebuild fork contains AI generated code.

CXX_STANDARD=17
CFLAGS_HARDENED_LANGS="c-lang cxx"
CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE DOS HO IO NPD"
EXPECTED_CARGO_HASH="3cab8b6daf33cceed328b4efd7bea3fd4a4e26bb940532b13ce33a522a1dadc80bb2d85c0e61c4cd178ccb777ac26dd492b2cc9b01cec2f700d04de9e5a118e5"
PYTHON_COMPAT=( python3_{10..14} )
RUSTFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
RUSTFLAGS_HARDENED_VULNERABILITY_HISTORY="CE DOS HO IO NPD"
RUST_LIVE_TIMESTAMP="Fri, 22 May 2026 00:33:25 -0700" # Same as 1.98.0 version bump
RUST_MAX_VER="9999" # LLVM 22.1
RUST_MIN_VER="1.90.0" # LLVM 20.1 for harfbuzz_rust@0.0.0
RUST_NEEDS_LLVM=1 # Prune rustc for unused LLVM slots
RUST_NIGHTLY_PV="1.98.0"



KB_COMMIT="ca6c9624dd7c6b774e6cec9901f3d8d998d6f62a"
RAGEL_PV="6.10"

CHKL_TIMESTAMPS=(
	"dev-libs/glib-2.89.9999"
	"dev-libs/icu-79.0.9999"
	"x11-libs/cairo-9999"
)

declare -A GIT_CRATES=(
)


CRATES_DISABLED="
harfbuzz_rust-0.0.0
"

# From "./convert-cargo-lock.sh 9999"
CRATES="
bitflags-2.13.0
bytemuck-1.25.0
bytemuck_derive-1.10.2
font-types-0.11.3
font-types-0.12.0
harfrust-0.10.0
once_cell-1.21.4
proc-macro2-1.0.106
quote-1.0.46
read-fonts-0.39.2
read-fonts-0.40.2
skrifa-0.43.2
smallvec-1.15.2
syn-2.0.118
unicode-ident-1.0.24
"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	#"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}" # 18, 19
	{20..22} # For Rust
)

inherit cargo cflags-hardened chkl flag-o-matic libcxx-slot libstdcxx-slot meson-multilib python-any-r1  rustflags-hardened xdg-utils

DESCRIPTION="An OpenType text shaping engine"
HOMEPAGE="https://harfbuzz.github.io/"

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="f2210d5787230f542a1b2035322134b0b686c0ae"
	EGIT_REPO_URI="https://github.com/harfbuzz/harfbuzz.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
	SRC_URI="
https://github.com/harfbuzz/harfbuzz/releases/download/${PV}/${P}.tar.xz
	"
fi
SRC_URI+="
	$(cargo_crate_uris ${CRATES})
	kbts? (
https://github.com/JimmyLefevre/kb/archive/${KB_COMMIT}.tar.gz
	-> kb-${KB_COMMIT:0:7}.tar.gz
	)
	ragel? (
		!system-ragel? (
https://www.colm.net/files/ragel/ragel-${RAGEL_PV}.tar.gz
		)
	)
"

LICENSE="
	icu
	ISC
	Old-MIT
"
# 0.9.18 introduced the harfbuzz-icu split; bug #472416
# 3.0.0 dropped some unstable APIs; bug #813705
# 6.0.0 changed libharfbuzz-subset.so ABI
ABI_VERSION="6"
SLOT="0/${ABI_VERSION}.0.0"

IUSE+="
-benchmark +cairo +chafa debug doc -experimental -fatlto -fontations +glib +gpu
+graphite -harfrust +icu +kbts +png +raster +ragel +subset -system-icu -system-ragel
+introspection test -thinlto +truetype +utilities +vector +zlib
ebuild_revision_2
"
RESTRICT="
	!test? (
		test
	)
"
REQUIRED_USE="
	?? (
		thinlto
		fatlto
	)
	fatlto? (
		llvm_slot_20
	)
	fontations? (
		^^ (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
		|| (
			amd64
			arm64
		)
	)
	harfrust? (
		^^ (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
		|| (
			amd64
			arm64
		)
	)
	introspection? (
		glib
	)
	test? (
		utilities
	)
	thinlto? (
		llvm_slot_20
	)
"

RDEPEND="
	cairo? (
		>=x11-libs/cairo-9999:=[${MULTILIB_USEDEP}]
	)
	chafa? (
		>=media-gfx/chafa-1.14.0:=
	)
	glib? (
		>=dev-libs/glib-2.80.0:2=[${MULTILIB_USEDEP}]
	)
	graphite? (
		>=media-gfx/graphite2-1.3.15:=[${MULTILIB_USEDEP}]
	)
	icu? (
		system-icu? (
			>=dev-libs/icu-79.0.9999:=[${MULTILIB_USEDEP}]
		)
	)
	introspection? (
		>=dev-libs/gobject-introspection-1.82.0-r2:=
	)
	png? (
		>=media-libs/libpng-1.6.57:=[${MULTILIB_USEDEP}]
	)
	ragel? (
		system-ragel? (
			>=dev-util/ragel-${RAGEL_PV}:=
		)
	)
	truetype? (
		>=media-libs/freetype-9999:2=[${MULTILIB_USEDEP}]
	)
	zlib? (
		virtual/zlib:=[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
RUST_BDEPEND="
	llvm_slot_20? (
		|| (
			dev-lang/rust-bin:1.90.0
			dev-lang/rust:1.90.0
		)
	)
	llvm_slot_21? (
		|| (
			dev-lang/rust-bin:1.94.1
			dev-lang/rust:1.94.1
		)
	)
	llvm_slot_22? (
		|| (
			dev-lang/rust-bin:9999
			dev-lang/rust:9999
		)
	)
	|| (
		dev-lang/rust:=
		dev-lang/rust-bin:=
	)
"
BDEPEND="
	${PYTHON_DEPS}
	sys-apps/help2man
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )
	fontations? (
		${RUST_BDEPEND}
	)
	harfrust? (
		${RUST_BDEPEND}
	)
	introspection? ( dev-util/glib-utils )
"
PATCHES=(
	"${FILESDIR}/${PN}-14.2.1-offline.patch"
	"${FILESDIR}/${PN}-14.2.1-stable-rust.patch"
)

is_rust() {
	if use fontations ; then
		return 0
	elif use harfrust ; then
		return 0
	fi
	return 1
}

verify_rust_nightly() {
	is_rust || return
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
eerror "Re-emerge ${pkg_name} or switch to Rust ${RUST_NIGHTLY_PV} or later."
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

pkg_setup() {
	rust_pkg_setup
	verify_rust_nightly
	libcxx-slot_verify
	libstdcxx-slot_verify
	use experimental && ewarn "USE=experimental is experimental"
	use fontations && ewarn "USE=fontations is experimental"
	use harfrust && ewarn "USE=harfrust is experimental"
	has wasm ${IUSE_EFFECTIVE} && use wasm && ewarn "USE=wasm is experimental"
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout

#die
		local actual_cargo_hash=$(sha512sum "${S}/src/rust/Cargo.toml" | cut -f 1 -d " ")
		local expected_cargo_hash="${EXPECTED_CARGO_HASH}"
		if [[ "${actual_cargo_hash}" != "${expected_cargo_hash}" ]] ; then
eerror "QA:  Update cargo crates"
eerror "QA:  Expected cargo hash:  ${expected_cargo_hash}"
eerror "QA:  Actual cargo hash:  ${actual_cargo_hash}"
			die
		fi
	else
		unpack ${A}
	fi

	local actual_abi_version=$(grep -r -e "hb_version_int" "${S}/meson.build" | head -n 1 | cut -f 3 -d " " | cut -c 1)
	local expected_abi_version="${ABI_VERSION}"
	if ver_test "${actual_abi_version}" "-ne" "${expected_abi_version}" ; then
eerror "QA:  Update the ABI_VERSION"
eerror "QA:  Actual ABI_VERSION:  ${actual_abi_version}"
eerror "QA:  Expected ABI_VERSION:  ${expected_abi_version}"
		die
	fi

	cargo_src_unpack
	cp -aT \
		"${FILESDIR}/${PV}"* \
		"${S}" \
		|| die
	local d="${S}/subprojects/packagefiles"
	mkdir -p "${d}" || die
	if use kbts ; then
		cat "${DISTDIR}/kb-${KB_COMMIT:0:7}.tar.gz" > "${d}/kb-${KB_COMMIT:0:7}.tar.gz" || die
	fi
	if use ragel && ! use system-ragel ; then
		cat "${DISTDIR}/ragel-${RAGEL_PV}.tar.gz" > "${d}/ragel-${RAGEL_PV}.tar.gz" || die
	fi
}

get_olast() {
	local olast=$(echo "${CFLAGS}" \
		| grep -o -E -e "-O(0|1|z|s|2|3|4|fast)" \
		| tr " " "\n" \
		| tail -n 1)
	echo "${olast}"
}

src_prepare() {
	default

	xdg_environment_reset

	# bug #790359
	filter-flags -fexceptions -fthreadsafe-statics

	if ! use debug ; then
		append-cppflags -DHB_NDEBUG
	fi
}

multilib_src_configure() {
	local ptr_size=$(tc-get-ptr-size)
	if is_rust && (( ${ptr_size} == 4 )) ; then
		ewarn "USE=harfrust or USE=fontations only works for 64-bit"
	fi

	export CARGO_TERM_VERBOSE="true"

	cflags-hardened_append
	rustflags-hardened_append
	chkl_check_many_timestamps

	local lto="none"
	use thinlto && lto="thin"
	use fatlto && lto="fat"

	# Simplified only allow a few for security-critical.
	local olast=$(get_olast)
	if [[ "${olast}" == "z" ]] ; then
		optimization="z"
	elif [[ "${olast}" == "s" ]] ; then
		optimization="s"
	elif [[ "${olast}" == "1" ]] ; then
		optimization="1"
	else
		optimization="2"
	fi

	if use kbts ; then
		append-cppflags -I"${S}/subprojects/kb-${KB_COMMIT}"
	fi

	# harfbuzz-gobject only used for introspection, bug #535852
	local emesonargs=(
		$(meson_feature benchmark)
		$(meson_feature cairo)
		$(meson_feature chafa)
		$(meson_native_use_feature fontations) # Breaks during buildtime for abi_x86_32
		$(meson_feature glib)
		$(meson_feature gpu)
		$(meson_feature graphite graphite2)
		$(meson_feature icu)
		$(meson_feature kbts)
		$(meson_feature png)
		$(meson_feature raster)
		$(meson_native_use_feature harfrust) # Breaks during buildtime for abi_x86_32
		$(meson_feature subset)
		$(meson_feature test tests)
		$(meson_feature truetype freetype)
		$(meson_feature vector)
		$(meson_feature zlib)

		$(meson_use experimental experimental_api)

		$(meson_native_use_feature doc docs)
		$(meson_native_use_feature introspection gobject)
		$(meson_native_use_feature introspection)

		# Breaks building tests..
		$(meson_native_use_feature utilities)

		$(meson_use !system-icu icu_builtin)
		$(meson_use experimental experimental_api)

		-Dbuildtype=release
		-Doptimization=${optimization}
		-Dcoretext=disabled
		-Dwasm=disabled
	)

	if is_rust && ( use fatlto || use thinlto ) && use llvm_slot_20 ; then
# People will still insist to mix different IR versions.
ewarn "Using Rust may break LTS userland with LTO for ${CATEGORY}/${PN}."
ewarn "To reduce the risk of runtime failure disable thinlto and fatlto USE flags."
ewarn "LTO should only be used if the main systemwide Clang compiler is 20."
		emesonargs+=(
			-Dharfrust_lto="${lto}"
		)
	else
		emesonargs+=(
			-Dharfrust_lto="none"
		)
	fi


	if use ragel ; then
		emesonargs+=(
			$(meson_use !system-ragel ragel_subproject)
		)
	else
		emesonargs+=(
			-Dragel_subproject=false
		)
	fi


	meson_src_configure
}

src_configure() {
	cargo_src_configure
	meson-multilib_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

src_compile() {
	meson-multilib_src_compile
}

multilib_src_test() {
	# harfbuzz:src / check-static-inits times out on hppa
	meson_src_test --timeout-multiplier 5
}

# @FUNCTION: multilib_check_headers
# @DESCRIPTION:
# Check whether the header files are consistent between ABIs.
#
# This function needs to be called after each ABI's installation phase.
# It obtains the header file checksums and compares them with previous
# runs (if any). Dies if header files differ.
multilib_check_headers() {
	local ptr_size=$(tc-get-ptr-size)
	if is_rust && (( ${ptr_size} == 4 )) ; then
einfo "Bypassed check for Rust + 32-bit"
		return
	fi
	_multilib_header_cksum() {
		set -o pipefail

		if [[ -d ${ED}/usr/include ]]; then
			find "${ED}"/usr/include -type f \
				-exec cksum {} + | sort -k2
		fi
	}

	local cksum cksum_prev
	local cksum_file=${T}/.multilib_header_cksum
	cksum=$(_multilib_header_cksum) || die
	unset -f _multilib_header_cksum

	if [[ -f ${cksum_file} ]]; then
		cksum_prev=$(< "${cksum_file}") || die

		if [[ ${cksum} != ${cksum_prev} ]]; then
			echo "${cksum}" > "${cksum_file}.new" || die

			eerror "Header files have changed between ABIs."

			if type -p diff &>/dev/null; then
				eerror "$(diff -du "${cksum_file}" "${cksum_file}.new")"
			else
				eerror "Old checksums in: ${cksum_file}"
				eerror "New checksums in: ${cksum_file}.new"
			fi

			die "Header checksum mismatch, aborting."
		fi
	else
		echo "${cksum}" > "${cksum_file}" || die
	fi
}

src_install() {
	meson-multilib_src_install

	local L=(
		"/usr/lib64/pkgconfig/harfbuzz-cairo.pc"
		"/usr/lib64/pkgconfig/harfbuzz-gobject.pc"
		"/usr/lib64/pkgconfig/harfbuzz-gpu.pc"
		"/usr/lib64/pkgconfig/harfbuzz.pc"
		"/usr/lib64/pkgconfig/harfbuzz-raster.pc"
		"/usr/lib64/pkgconfig/harfbuzz-subset.pc"
		"/usr/lib64/pkgconfig/harfbuzz-vector.pc"
	)

	local x
	for x in "${L[@]}" ; do
		if [[ -e "${x}" ]] ; then
			sed -i -e "s|{prefix}/lib |{libdir} |g" "${ED}${x}" || die
		fi
	done

	if [[ -e "${ED}/usr/lib/libharfbuzz_rust.a" && -e "${ED}/usr/lib64" ]] ; then
		mv "${ED}/usr/lib/libharfbuzz_rust.a" "${ED}/usr/lib64" || die
	fi
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive/integration-testing) 14.2.1 (20260611)
# mousepad:  passed
# xfce4-terminal:  passed
# hb-shape <ttf-path> "السلام عليكم"  --font-funcs=fontations:  failed for fontations test
# HB_SHAPER_LIST=harfrust hb-shape <ttf-path> "السلام عليكم":  failed for harfrust test

# USE="cairo fontations glib gpu graphite harfrust icu introspection kbts png
# raster subset truetype vector zlib -benchmark -chafa (-debug) -doc
# -experimental -fatlto -ragel -system-icu -system-ragel -test -thinlto
# -utilities"
# GCC_SLOT="13_4"
# LLVM_SLOT="20"
