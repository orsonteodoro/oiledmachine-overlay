# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

# SECURITY:  If firefox ESR gets bumped, this package should be bumped with the same latest ESR version.

# 115.11.0 -> 115.12.0
# 115.12.0 -> 128.1.0
# 128.1.0 -> 128.2.0
# 128.2.0 -> 128.3.0
# 128.3.1 -> 128.4.0
# 128.4.0 -> 128.5.0
# 128.7.0 -> 128.8.0
# 128.8.0 -> 128.9.0
# 128.9.0 -> 128.10.0
# 128.10.0 -> 128.11.0
# 128.11.0 -> 128.12.0
# 128.12.0 -> 128.13.0

CFLAGS_HARDENED_USE_CASES="jit language-runtime scripting sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="IO TC"
RUSTFLAGS_HARDENED_USE_CASES="jit language-runtime scripting sensitive-data untrusted-data"
RUSTFLAGS_HARDENED_VULNERABILITY_HISTORY="IO TC"
CPU_FLAGS_ARM=(
	"cpu_flags_arm_neon"
)

LLVM_COMPAT=( 18 17 ) # Limited by rust

MY_MAJOR=$(ver_cut 1)
MY_PN="mozjs"
MY_PV="${PV/_pre*}"

# MITIGATION_LAST_UPDATE is the same as firefox esr ebuild
MITIGATION_DATE="Jul 22, 2025" # Advisory date
MITIGATION_LAST_UPDATE=1753110240 # From `date +%s -d "2025-07-21 08:04"` from ftp date matching version in report
MITIGATION_URI="https://www.mozilla.org/en-US/security/advisories/mfsa2025-58/"
MOZ_ESR="yes"
MOZ_PN="firefox"
MOZ_PV="${PV}"
MOZ_PV_SUFFIX=
if [[ "${PV}" =~ ("_"("alpha"|"beta"|"rc").*)$ ]] ; then
	MOZ_PV_SUFFIX="${BASH_REMATCH[1]}"
	# Convert the ebuild version to the upstream Mozilla version
	MOZ_PV="${MOZ_PV/_alpha/a}" # Handle alpha for SRC_URI
	MOZ_PV="${MOZ_PV/_beta/b}"  # Handle beta for SRC_URI
	MOZ_PV="${MOZ_PV%%_rc*}"    # Handle rc for SRC_URI
fi
if [[ -n "${MOZ_ESR}" ]] ; then
	# ESR releases have slightly different version numbers
	MOZ_PV="${MOZ_PV}esr"
fi
MOZ_P="${MOZ_PN}-${MOZ_PV}"
MOZ_PV_DISTFILES="${MOZ_PV}${MOZ_PV_SUFFIX}"
MOZ_P_DISTFILES="${MOZ_PN}-${MOZ_PV_DISTFILES}"
MOZ_SRC_BASE_URI="https://archive.mozilla.org/pub/${MOZ_PN}/releases/${MOZ_PV}"
if [[ "${PV}" == *"_rc"* ]] ; then
	MOZ_SRC_BASE_URI="https://archive.mozilla.org/pub/${MOZ_PN}/candidates/${MOZ_PV}-candidates/build${PV##*_rc}"
fi

# Patch version
FIREFOX_PATCHSET="firefox-${PV%%.*}esr-patches-11.tar.xz"
#SPIDERMONKEY_PATCHSET="spidermonkey-${PV%%.*}-patches-01.tar.xz"
SPIDERMONKEY_PATCHSET="spidermonkey-128-patches-03.tar.xz"
PATCH_URIS=(
	https://dev.gentoo.org/~juippis/mozilla/patchsets/${FIREFOX_PATCHSET}
	https://dev.gentoo.org/~juippis/mozilla/patchsets/${SPIDERMONKEY_PATCHSET}
)

PYTHON_COMPAT=( "python3_"{10..11} )
PYTHON_REQ_USE="ncurses,ssl,xml(+)"

RUST_NEEDS_LLVM=1
RUST_MAX_VER="1.81.0" # Inclusive
RUST_MIN_VER="1.76.0" # Corresponds to llvm 17

WANT_AUTOCONF="2.1"

inherit autotools cflags-hardened check-compiler-switch check-reqs dhms flag-o-matic llvm-r1
inherit multiprocessing prefix python-any-r1 rust rustflags-hardened
inherit toolchain-funcs

KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
S="${WORKDIR}/firefox-${PV%_*}"
SRC_URI="
	${MOZ_SRC_BASE_URI}/source/${MOZ_P}.source.tar.xz -> ${MOZ_P_DISTFILES}.source.tar.xz
	${PATCH_URIS[@]}
"

DESCRIPTION="A JavaScript engine written in C and C++"
HOMEPAGE="
	https://spidermonkey.dev
	https://firefox-source-docs.mozilla.org/js/index.html
"
LICENSE="MPL-2.0"
RESTRICT="
	test
	!test? (
		test
	)
" # Not tested
SLOT="$(ver_cut 1)"
IUSE="
${CPU_FLAGS_ARM[@]}
${LLVM_COMPAT[@]/#/llvm_slot_}
clang debug +jit lto rust-simd test
ebuild_revision_20
"
REQUIRED_USE="
	rust-simd? (
		!llvm_slot_18
		llvm_slot_17
	)
"
gen_clang_bdepend() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				llvm-core/llvm:${s}
				clang? (
					llvm-core/clang:${s}
					llvm-core/lld:${s}
				)
			)
		"
	done

}
RUST_CDEPEND="
	llvm_slot_18? (
		|| (
			=dev-lang/rust-1.81*
			=dev-lang/rust-1.80*
			=dev-lang/rust-1.79*
			=dev-lang/rust-1.78*
			=dev-lang/rust-bin-1.81*
			=dev-lang/rust-bin-1.80*
			=dev-lang/rust-bin-1.79*
			=dev-lang/rust-bin-1.78*
		)
	)
	llvm_slot_17? (
		|| (
			=dev-lang/rust-1.77*
			=dev-lang/rust-1.76*
			=dev-lang/rust-bin-1.77*
			=dev-lang/rust-bin-1.76*
		)
	)
	|| (
		dev-lang/rust:=
		dev-lang/rust-bin:=
	)

"
RDEPEND="
	${RUST_CDEPEND}
	>=dev-libs/icu-73.1
	dev-libs/icu:=
	>=dev-libs/nspr-4.35
	sys-libs/readline:0
	sys-libs/readline:=
	>=sys-libs/zlib-1.2.13
	sys-kernel/mitigate-id
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	${RUST_CDEPEND}
	>=dev-util/cbindgen-0.26.0
	virtual/pkgconfig
	!clang? (
		|| (
			dev-lang/rust:=
			dev-lang/rust-bin:=
		)
	)
	!elibc_glibc? (
		dev-lang/rust:=
	)
	test? (
		$(python_gen_any_dep '
			dev-python/six[${PYTHON_USEDEP}]
		')
	)
	|| (
		$(gen_clang_bdepend)
	)
"

llvm_check_deps() {
	if use clang ; then
		if ! has_version -b "llvm-core/clang:${LLVM_SLOT}" ; then
einfo "llvm-core/clang:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
			return 1
		fi

		if ! has_version -b "llvm-core/llvm:${LLVM_SLOT}" ; then
einfo "llvm-core/llvm:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
			return 1
		fi

		check_rust_18() {
			if has_version "=dev-lang/rust-1.81*" || has_version "=dev-lang/rust-bin-1.81*" ; then
				return 0
			elif has_version "=dev-lang/rust-1.80*" || has_version "=dev-lang/rust-bin-1.80*" ; then
				return 0
			elif has_version "=dev-lang/rust-1.79*" || has_version "=dev-lang/rust-bin-1.79*" ; then
				return 0
			elif has_version "=dev-lang/rust-1.78*" || has_version "=dev-lang/rust-bin-1.78*" ; then
				return 0
			fi
			return 1
		}

		check_rust_17() {
			if has_version "=dev-lang/rust-1.77*" || has_version "=dev-lang/rust-bin-1.77*" ; then
				return 0
			elif has_version "=dev-lang/rust-1.76*" || has_version "=dev-lang/rust-bin-1.76*" ; then
				return 0
			elif has_version "=dev-lang/rust-1.75*" || has_version "=dev-lang/rust-bin-1.75*" ; then
				return 0
			elif has_version "=dev-lang/rust-1.74*" || has_version "=dev-lang/rust-bin-1.74*" ; then
				return 0
			elif has_version "=dev-lang/rust-1.73*" || has_version "=dev-lang/rust-bin-1.73*" ; then
				return 0
			fi
			return 1
		}

		if use llvm_slot_18 && check_rust_18 ; then
			:
		elif use llvm_slot_17 && check_rust_17 ; then
			:
		else
einfo "Either dev-lang/rust or dev-lang/rust-bin is missing for ${LLVM_SLOT}! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
			return 1
		fi

		if ! tc-ld-is-mold ; then
			if ! has_version -b "llvm-core/lld:${LLVM_SLOT}" ; then
einfo "llvm-core/lld:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
				return 1
			fi
		fi
	fi

einfo "Using LLVM slot ${LLVM_SLOT} to build" >&2
}


mozconfig_add_options_ac() {
	debug-print-function ${FUNCNAME} "$@"

	if (( ${#} < 2 )) ; then
		die "${FUNCNAME} requires at least two arguments"
	fi

	local reason="${1}"
	shift

	local option
	for option in ${@} ; do
		echo "ac_add_options ${option} # ${reason}" >>${MOZCONFIG}
	done
}

mozconfig_add_options_mk() {
	debug-print-function ${FUNCNAME} "$@"

	if (( ${#} < 2 )) ; then
		die "${FUNCNAME} requires at least two arguments"
	fi

	local reason="${1}"
	shift

	local option
	for option in ${@} ; do
		echo "mk_add_options ${option} # ${reason}" >>${MOZCONFIG}
	done
}

mozconfig_use_enable() {
	debug-print-function ${FUNCNAME} "$@"

	if (( ${#} < 1 )) ; then
		die "${FUNCNAME} requires at least one arguments"
	fi

	local flag=$(use_enable "${@}")
	mozconfig_add_options_ac "$(use ${1} && echo +${1} || echo -${1})" "${flag}"
}

python_check_deps() {
	if use test ; then
		python_has_version "dev-python/six[${PYTHON_USEDEP}]"
	fi
}

# This is a straight copypaste from toolchain-funcs.eclass's 'tc-ld-is-lld', and is temporarily
# placed here until toolchain-funcs.eclass gets an official support for mold linker.
# Please see:
# https://github.com/gentoo/gentoo/pull/28366 ||
# https://github.com/gentoo/gentoo/pull/28355
tc-ld-is-mold() {
	# Ensure ld output is in English.
	local -x LC_ALL=C

	# First check the linker directly.
	local out=$($(tc-getLD "$@") --version 2>&1)
	if [[ "${out}" == *"mold"* ]] ; then
		return 0
	fi

	# Then see if they're selecting mold via compiler flags.
	# Note: We're assuming they're using LDFLAGS to hold the
	# options and not CFLAGS/CXXFLAGS.
	local base="${T}/test-tc-linker"
cat <<-EOF > "${base}.c"
int main() { return 0; }
EOF
	out=$($(tc-getCC "$@") ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} -Wl,--version "${base}.c" -o "${base}" 2>&1)
	rm -f "${base}"*
	if [[ "${out}" == *"mold"* ]] ; then
		return 0
	fi

	# No mold here!
	return 1
}

pkg_pretend() {
	if use test ; then
		CHECKREQS_DISK_BUILD="4400M"
	else
		CHECKREQS_DISK_BUILD="4300M"
	fi

	check-reqs_pkg_pretend
}

pkg_setup() {
	dhms_start
	check-compiler-switch_start

	# Get LTO from environment; export after this phase for use in src_configure (etc)
	use_lto=no

	if [[ "${MERGE_TYPE}" != "binary" ]] ; then
		if tc-is-lto; then
			use_lto=yes
			# LTO is handled via configure
			filter-lto
		fi

		if [[ ${use_lto} = yes ]]; then
			# -Werror=lto-type-mismatch -Werror=odr are going to fail with GCC,
			# bmo#1516758, bgo#942288
			filter-flags -Werror=lto-type-mismatch -Werror=odr
		fi

		if use test ; then
			CHECKREQS_DISK_BUILD="4400M"
		else
			CHECKREQS_DISK_BUILD="4300M"
		fi

		check-reqs_pkg_setup

		llvm-r1_pkg_setup
		rust_pkg_setup

		if false && use clang && use lto && tc-ld-is-lld ; then
			local version_lld=$(ld.lld --version 2>/dev/null \
				| awk '{ print $2 }')
			if [[ -n "${version_lld}" ]] ; then
				version_lld=$(ver_cut 1 "${version_lld}")
			fi
			if [[ -z "${version_lld}" ]] ; then
eerror "Failed to read ld.lld version!"
				die
			fi

			local version_llvm_rust=$(rustc -Vv 2>/dev/null \
				| grep -F -- 'LLVM version:' \
				| awk '{ print $3 }')
			if [[ -n "${version_llvm_rust}" ]] ; then
				version_llvm_rust=$(ver_cut 1 "${version_llvm_rust}")
			fi
			if [[ -z "${version_llvm_rust}" ]] ; then
eerror "Failed to read used LLVM version from rustc!"
				die
			fi

		fi

		python-any-r1_pkg_setup

		# Build system is using /proc/self/oom_score_adj, bug #604394
		addpredict "/proc/self/oom_score_adj"

		if ! mountpoint -q /dev/shm ; then
	# If /dev/shm is not available, configure is known to fail with a
	# traceback report referencing
	# /usr/lib/pythonN.N/multiprocessing/synchronize.py
ewarn "/dev/shm is not mounted -- expect build failures!"
		fi

		# Ensure we use C locale when building, bug #746215
		export LC_ALL=C
	fi

	export use_lto
}

src_prepare() {
	if [[ "${use_lto}" == "yes" ]]; then
		rm -v "${WORKDIR}/firefox-patches/"*"-LTO-Only-enable-LTO-"*".patch" || die
	fi

	# Workaround for bgo #915651, 915651, 929013 on musl.
	if use elibc_glibc ; then
		rm -v "${WORKDIR}/firefox-patches/"*"bgo-748849-RUST_TARGET_override.patch" || die
	fi

	eapply "${WORKDIR}/firefox-patches"

#	pushd "${WORKDIR}/firefox-${MY_PV}" >/dev/null 2>&1 || die
#		rm "${WORKDIR}/spidermonkey-patches/0003-tests-Increase-the-test-timeout-for-slower-builds.patch" || die
#		local x
#		for x in $(ls "${WORKDIR}/spidermonkey-patches") ; do
#			if [[ "${x}" =~ "0008" ]] ; then
#				eapply --fuzz=1 "${FILESDIR}/spidermonkey-128.1.0-0008-spidermonkey-91.5.0-dont-fail-gcc-sanity-checks.patch"
#				continue
#			fi
#			eapply "${WORKDIR}/spidermonkey-patches/${x}"
#		done
#	popd >/dev/null 2>&1 || die

	default

	# Maintain -D_FORTIFY_SOURCE integrity
	sed -i -e "s|-O3|-O2|g" \
		"config/moz.build" \
		"gfx/skia/moz.build" \
		"js/src/old-configure.in" \
		"js/src/old-configure" \
		"media/libopus/moz.build" \
		"old-configure.in" \
		"old-configure" \
		|| die

	# Make cargo respect MAKEOPTS
	export CARGO_BUILD_JOBS="$(makeopts_jobs)"

	# Workaround for bgo #915651, 915651, 929013 on musl.
	if ! use elibc_glibc ; then
		  if use amd64 ; then
			export RUST_TARGET="x86_64-unknown-linux-musl"
		elif use x86 ; then
			export RUST_TARGET="i686-unknown-linux-musl"
		elif use arm64 ; then
			export RUST_TARGET="aarch64-unknown-linux-musl"
		elif use ppc64 ; then
			export RUST_TARGET="powerpc64le-unknown-linux-musl"
		else
eerror
eerror "Unknown musl chost, please post your rustc -vV along with"
eerror "\`emerge --info\` on Gentoo's bug #915651"
eerror
			die
		fi
	fi

	# sed-in toolchain prefix
	sed -i \
		-e "s/objdump/${CHOST}-objdump/" \
		"python/mozbuild/mozbuild/configure/check_debug_ranges.py" \
		|| die "sed failed to set toolchain prefix"

	einfo "Removing pre-built binaries ..."
	find "third_party" \
		-type f \
		\( \
			   -name '*.so' \
			-o -name '*.o' \
		\) \
		-print \
		-delete \
		|| die

	# use prefix shell in wrapper linker scripts, bug #789660
	hprefixify "${S}/../../build/cargo-"{,host-}"linker"

	# Create build dir
	BUILD_DIR="${WORKDIR}/${PN}_build"
	mkdir -p "${BUILD_DIR}" || die
}

check_security_expire() {
	local safe_period
	local now=$(date +%s)
	local dhms_passed=$(dhms_get ${MITIGATION_LAST_UPDATE} ${now})

	local desc=""
# The ideal choice is actually mitigation_use_case=${MITIGATION_USE_CASE:-email}
# but the ESR releases tend to be less frequent compared to rapid.
	local mitigation_use_case="${MITIGATION_USE_CASE:-user-generated-content}"
	if [[ "${mitigation_use_case}" =~ ("email") ]] ; then
		safe_period=$((60*60*24*7))
		desc="1 week"
	elif [[ "${mitigation_use_case}" =~ ("socials"|"user-generated-content") ]] ; then
		safe_period=$((60*60*24*14))
		desc="2 weeks"
	else
		safe_period=$((60*60*24*30))
		desc="30 days"
	fi

	if (( ${now} > ${MITIGATION_LAST_UPDATE} + ${safe_period} )) ; then
eerror
eerror "This ebuild release period is past ${desc} since release."
eerror "It is considered insecure.  As a precaution, this particular point"
eerror "release will not (re-)install."
eerror
eerror "Time passed since the last security update:  ${dhms_passed}"
eerror "Mitigated use case(s):  ${mitigation_use_case}"
eerror
eerror "Solutions:"
eerror
eerror "1.  Use a newer release from the overlay."
eerror "2.  Use the latest distro release."
eerror
eerror "See metadata.xml for details to adjust MITIGATION_USE_CASE."
eerror
		die
	else
einfo "Time passed since the last security update:  ${dhms_passed}"
	fi
}

src_configure() {
	check_security_expire
	# Show flags set at the beginning
#einfo "Current BINDGEN_CFLAGS:\t${BINDGEN_CFLAGS:-no value set}"
#einfo "Current CFLAGS:    ${CFLAGS}"
#einfo "Current CXXFLAGS:  ${CXXFLAGS}"
#einfo "Current LDFLAGS:   ${LDFLAGS}"
#einfo "Current RUSTFLAGS: ${RUSTFLAGS}"

	if tc-is-clang && ! use clang ; then
eerror "Detected clang.  Set USE=clang."
		die
	fi

	local have_switched_compiler=
	if use clang ; then
	# Force clang
einfo "Enforcing the use of clang due to USE=clang ..."

		local version_clang=$(clang --version 2>/dev/null \
			| grep -F -- 'clang version' \
			| awk '{ print $3 }')
		if [[ -n "${version_clang}" ]] ; then
			version_clang=$(ver_cut 1 "${version_clang}")
		fi
		if [[ -z "${version_clang}" ]] ; then
			die "Failed to read clang version!"
		fi

		if tc-is-gcc; then
			have_switched_compiler=yes
		fi
		AR="llvm-ar"
		CC="${CHOST}-clang-${version_clang}"
		CXX="${CHOST}-clang++-${version_clang}"
		CPP="${CC} -E"
		NM="llvm-nm"
		RANLIB="llvm-ranlib"
		READELF="llvm-readelf"
		OBJDUMP="llvm-objdump"
	else
	# Force gcc
		have_switched_compiler="yes"
einfo "Enforcing the use of gcc due to USE=-clang ..."
		AR="gcc-ar"
		CC="${CHOST}-gcc"
		CXX="${CHOST}-g++"
		CPP="${CC} -E"
		NM="gcc-nm"
		RANLIB="gcc-ranlib"
		READELF="readelf"
		OBJDUMP="objdump"
	fi

	if [[ -n "${have_switched_compiler}" ]] ; then
	# Because we switched active compiler we have to ensure
	# that no unsupported flags are set
		strip-unsupported-flags
	fi

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cflags-hardened_append
	rustflags-hardened_append

	# Ensure we use correct toolchain,
	# AS is used in a non-standard way by upstream, #bmo1654031
	export HOST_CC="$(tc-getBUILD_CC)"
	export HOST_CXX="$(tc-getBUILD_CXX)"
	export AS="$(tc-getCC) -c"

	tc-export CC CXX LD AR AS NM OBJDUMP RANLIB READELF PKG_CONFIG

	# Pass the correct toolchain paths through cbindgen
	if tc-is-cross-compiler ; then
		export BINDGEN_CFLAGS="${SYSROOT:+--sysroot=${ESYSROOT}} --target=${CHOST} ${BINDGEN_CFLAGS-}"
	fi

	# ../python/mach/mach/mixin/process.py fails to detect SHELL
	export SHELL="${EPREFIX}/bin/bash"

	# Forced JIT on for slower computers
	local nprocs=$(get_nproc)
	if ! use jit && (( ${nprocs} <= 1 )) ; then
eerror "JIT must be turned on"
		die
	fi

	# Modifications to better support ARM, bug 717344
	# Tell build system that we want to use LTO
	# Thumb options aren't supported when using clang, bug 666966

	# Set state path
	export MOZBUILD_STATE_PATH="${BUILD_DIR}"

	# Set MOZCONFIG
	export MOZCONFIG="${S}/.mozconfig"

	# Initialize MOZCONFIG
	mozconfig_add_options_ac '' --enable-project=js

	mozconfig_add_options_ac 'Gentoo default' \
		--host="${CBUILD:-${CHOST}}" \
		--target="${CHOST}" \
		--disable-jemalloc \
		--disable-smoosh \
		--disable-strip \
		--enable-readline \
		--enable-release \
		--enable-shared-js \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--prefix="${EPREFIX}/usr" \
		--with-intl-api \
		--with-system-icu \
		--with-system-nspr \
		--with-system-zlib \
		--with-toolchain-prefix="${CHOST}-" \
		--x-includes="${ESYSROOT}/usr/include" \
		--x-libraries="${ESYSROOT}/usr/$(get_libdir)"

	mozconfig_use_enable debug
	mozconfig_use_enable jit
	mozconfig_use_enable test tests

	if use debug ; then
		mozconfig_add_options_ac '+debug' --disable-optimize
		mozconfig_add_options_ac '+debug' --enable-debug-symbols
	else
		mozconfig_add_options_ac '-debug' --enable-optimize
		mozconfig_add_options_ac '-debug' --disable-debug-symbols
	fi

	if use rust-simd ; then
		local rust_pv=$(rustc --version | cut -f 2 -d " ")
		if ver_test "${rust_pv}" -gt "1.78" ; then
eerror "Use eselect to switch rust to < 1.78 or disable the rust-simd USE flag."
			die
		fi
		mozconfig_add_options_ac '+rust-simd' --enable-rust-simd
	else
	# We always end up disabling this at some point due to newer rust versions. bgo#933372
		mozconfig_add_options_ac '-rust-simd' --disable-rust-simd
	fi

	# Modifications to better support ARM, bug 717344
	if use cpu_flags_arm_neon ; then
		mozconfig_add_options_ac '+cpu_flags_arm_neon' --with-fpu=neon

		if ! tc-is-clang ; then
			# thumb options aren't supported when using clang, bug 666966
			mozconfig_add_options_ac '+cpu_flags_arm_neon' --with-thumb=yes
			mozconfig_add_options_ac '+cpu_flags_arm_neon' --with-thumb-interwork=no
		fi
	fi

	# Tell build system that we want to use LTO
	if [[ "${use_lto}" == "yes" ]] ; then
		if use clang ; then
			if tc-ld-is-mold ; then
				mozconfig_add_options_ac '+lto' --enable-linker=mold
			else
				mozconfig_add_options_ac '+lto' --enable-linker=lld
			fi
			if ! check-compiler-switch_is_flavor_slot_changed ; then
				mozconfig_add_options_ac '+lto' --enable-lto=cross
			fi
		else
			mozconfig_add_options_ac '+lto' --enable-linker=bfd
			if ! check-compiler-switch_is_flavor_slot_changed ; then
				mozconfig_add_options_ac '+lto' --enable-lto=full
			fi
		fi
	fi

	# LTO flag was handled via configure
	filter-lto

	# Use system's Python environment
	export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE="none"
	export PIP_NETWORK_INSTALL_RESTRICTED_VIRTUALENVS="mach"

	# Disable notification when build system has finished
	export MOZ_NOSPAM=1

	# Portage sets XARGS environment variable to "xargs -r" by default which
	# breaks build system's check_prog() function which doesn't support arguments
	mozconfig_add_options_ac 'Gentoo default' "XARGS=${EPREFIX}/usr/bin/xargs"

	# Set build dir
	mozconfig_add_options_mk 'Gentoo default' "MOZ_OBJDIR=${BUILD_DIR}"

	# Show flags we will use
einfo "Build BINDGEN_CFLAGS:\t${BINDGEN_CFLAGS:-no value set}"
einfo "Build CFLAGS:    ${CFLAGS}"
einfo "Build CXXFLAGS:  ${CXXFLAGS}"
einfo "Build LDFLAGS:   ${LDFLAGS}"
einfo "Build RUSTFLAGS: ${RUSTFLAGS}"

	./mach configure || die
}

src_compile() {
	./mach build --verbose || die
}

src_test() {
	if "${BUILD_DIR}/js/src/js" -e 'print("Hello world!")'; then
einfo "Smoke-test successful, continuing with full test suite"
	else
eerror "Smoke-test failed: did interpreter initialization fail?"
		die
	fi

	cp \
		"${FILESDIR}/spidermonkey-${SLOT}-known-test-failures.txt" \
		"${T}/known_test_failures.list" \
		|| die

	if use x86 ; then
		echo \
			"non262/Intl/DateTimeFormat/timeZone_version.js" \
			>> \
			"${T}/known_test_failures.list" \
			|| die
		echo \
			"test262/intl402/Locale/constructor-non-iana-canon.js" \
			>> \
			"${T}/known_test_failures.list" \
			|| die
	fi

	./mach jstests --exclude-file="${T}/known_test_failures.list" || die
}

src_install() {
	cd "${BUILD_DIR}" || die
	default

	# Fix soname links
	pushd "${ED}/usr/$(get_libdir)" &>/dev/null || die
		mv \
			"lib${MY_PN}-${MY_MAJOR}.so" \
			"lib${MY_PN}-${MY_MAJOR}.so.0.0.0" \
			|| die
		ln -s \
			"lib${MY_PN}-${MY_MAJOR}.so.0.0.0" \
			"lib${MY_PN}-${MY_MAJOR}.so.0" \
			|| die
		ln -s \
			"lib${MY_PN}-${MY_MAJOR}.so.0" \
			"lib${MY_PN}-${MY_MAJOR}.so" \
			|| die
	popd &>/dev/null || die

	# Remove unneeded files
	rm \
		"${ED}/usr/bin/js${MY_MAJOR}-config" \
		"${ED}/usr/$(get_libdir)/libjs_static.ajs" \
		|| die

	# Fix permissions
	chmod -x \
		"${ED}/usr/$(get_libdir)/pkgconfig/"*".pc" \
		"${ED}/usr/include/mozjs-${MY_MAJOR}/js-config.h" \
		|| die
	dhms_end
}
