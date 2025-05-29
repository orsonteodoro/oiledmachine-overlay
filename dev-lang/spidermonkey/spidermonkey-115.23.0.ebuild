# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

# 115.21.0 -> 115.22.0
# 115.22.0 -> 115.23.0

# For polkit

# DEPENDS:
# /var/tmp/portage/dev-lang/spidermonkey-115.23.0/work/firefox-115.23.0/taskcluster/ci/toolchain/rust.yml
# /var/tmp/portage/dev-lang/spidermonkey-115.23.0/work/firefox-115.23.0/taskcluster/ci/fetch/toolchains.yml

CFLAGS_HARDENED_USE_CASES="jit language-runtime scripting sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="IO TC"
RUSTFLAGS_HARDENED_USE_CASES="jit language-runtime scripting sensitive-data untrusted-data"
RUSTFLAGS_HARDENED_VULNERABILITY_HISTORY="IO TC"
CPU_FLAGS_ARM=(
	"cpu_flags_arm_neon"
)

# Patch version
FIREFOX_PATCHSET="firefox-115esr-patches-13.tar.xz"
SPIDERMONKEY_PATCHSET="spidermonkey-115-patches-02.tar.xz"

LLVM_MAX_SLOT=16
LLVM_COMPAT=( 16 ) # Limited by rust

PYTHON_COMPAT=( "python3_"{10..11} )
PYTHON_REQ_USE="ncurses,ssl,xml(+)"

MY_PN="mozjs"
MY_PV="${PV/_pre*}" # Handle Gentoo pre-releases

MY_MAJOR=$(ver_cut 1)

# MITIGATION_LAST_UPDATE is the same as firefox esr ebuild
MITIGATION_DATE="Apr 29, 2025" # Advisory date
MITIGATION_LAST_UPDATE=1745866140 # From `date +%s -d "2025-04-28 11:49"` from ftp date matching version in report
MITIGATION_URI="https://www.mozilla.org/en-US/security/advisories/mfsa2025-30/"
MOZ_ESR="yes"

MOZ_PV=${PV}
MOZ_PV_SUFFIX=
if [[ ${PV} =~ (_(alpha|beta|rc).*)$ ]] ; then
	MOZ_PV_SUFFIX=${BASH_REMATCH[1]}

	# Convert the ebuild version to the upstream Mozilla version
	MOZ_PV="${MOZ_PV/_alpha/a}" # Handle alpha for SRC_URI
	MOZ_PV="${MOZ_PV/_beta/b}"  # Handle beta for SRC_URI
	MOZ_PV="${MOZ_PV%%_rc*}"    # Handle rc for SRC_URI
fi

if [[ -n ${MOZ_ESR} ]] ; then
	# ESR releases have slightly different version numbers
	MOZ_PV="${MOZ_PV}esr"
fi

MOZ_PN="firefox"
MOZ_P="${MOZ_PN}-${MOZ_PV}"
MOZ_PV_DISTFILES="${MOZ_PV}${MOZ_PV_SUFFIX}"
MOZ_P_DISTFILES="${MOZ_PN}-${MOZ_PV_DISTFILES}"

MOZ_SRC_BASE_URI="https://archive.mozilla.org/pub/${MOZ_PN}/releases/${MOZ_PV}"

if [[ ${PV} == *_rc* ]] ; then
	MOZ_SRC_BASE_URI="https://archive.mozilla.org/pub/${MOZ_PN}/candidates/${MOZ_PV}-candidates/build${PV##*_rc}"
fi

PATCH_URIS=(
	https://dev.gentoo.org/~juippis/mozilla/patchsets/${FIREFOX_PATCHSET}
	https://dev.gentoo.org/~juippis/mozilla/patchsets/${SPIDERMONKEY_PATCHSET}
)

RUST_NEEDS_LLVM=1
RUST_MAX_VER="1.81.0" # Inclusive.  Corresponds to llvm 16
RUST_MIN_VER="1.65.0" # Corresponds to llvm 15

WANT_AUTOCONF="2.1"

inherit autotools cflags-hardened check-reqs dhms flag-o-matic llvm
inherit multiprocessing prefix python-any-r1 rust rustflags-hardened
inherit toolchain-funcs

KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
S="${WORKDIR}/firefox-${MY_PV}/js/src"
SRC_URI="
	${MOZ_SRC_BASE_URI}/source/${MOZ_P}.source.tar.xz -> ${MOZ_P_DISTFILES}.source.tar.xz
	${PATCH_URIS[@]}
"

DESCRIPTION="A JavaScript engine written in C and C++"
HOMEPAGE="https://spidermonkey.dev https://firefox-source-docs.mozilla.org/js/index.html "
RESTRICT="
	!test? (
		test
	)
"
SLOT="$(ver_cut 1)"
LICENSE="MPL-2.0"
IUSE="
${CPU_FLAGS_ARM[@]}
${LLVM_COMPAT[@]/#/llvm_slot_}
clang debug +jit lto rust-simd test
ebuild_revision_12
"
REQUIRED_USE="
	rust-simd? (
		|| (
			llvm_slot_16
		)
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
	llvm_slot_16? (
		|| (
			=dev-lang/rust-1.72*
			=dev-lang/rust-1.71*
			=dev-lang/rust-1.70*
			=dev-lang/rust-bin-1.72*
			=dev-lang/rust-bin-1.71*
			=dev-lang/rust-bin-1.70*
		)
	)
	|| (
		dev-lang/rust:=
		dev-lang/rust-bin:=
	)
"
RDEPEND="
	${RUST_CDEPEND}
	>=dev-libs/icu-73.1:=
	dev-libs/nspr
	sys-libs/readline:0=
	sys-libs/zlib
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	${RUST_CDEPEND}
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
	if ! has_version -b "llvm-core/llvm:${LLVM_SLOT}" ; then
einfo "llvm-core/llvm:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
		return 1
	fi

	if use clang ; then
		if ! has_version -b "llvm-core/clang:${LLVM_SLOT}" ; then
einfo "llvm-core/clang:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
			return 1
		fi

		check_rust_16() {
			if has_version "=dev-lang/rust-1.72*" || has_version "=dev-lang/rust-bin-1.72*" ; then
				return 0
			elif has_version "=dev-lang/rust-1.71*" || has_version "=dev-lang/rust-bin-1.71*" ; then
				return 0
			elif has_version "=dev-lang/rust-1.70*" || has_version "=dev-lang/rust-bin-1.70*" ; then
				return 0
			fi
			return 1
		}

		check_rust_15() {
			if has_version "=dev-lang/rust-1.69*" || has_version "=dev-lang/rust-bin-1.69*" ; then
				return 0
			elif has_version "=dev-lang/rust-1.68*" || has_version "=dev-lang/rust-bin-1.68*" ; then
				return 0
			elif has_version "=dev-lang/rust-1.67*" || has_version "=dev-lang/rust-bin-1.67*" ; then
				return 0
			elif has_version "=dev-lang/rust-1.66*" || has_version "=dev-lang/rust-bin-1.66*" ; then
				return 0
			elif has_version "=dev-lang/rust-1.65*" || has_version "=dev-lang/rust-bin-1.65*" ; then
				return 0
			fi
			return 1
		}

		if use llvm_slot_16 && check_rust_16 ; then
			:
		elif use llvm_slot_15 && check_rust_15 ; then
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
	local out

	# Ensure ld output is in English.
	local -x LC_ALL=C

	# First check the linker directly.
	out=$($(tc-getLD "$@") --version 2>&1)
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
		CHECKREQS_DISK_BUILD="4000M"
	else
		CHECKREQS_DISK_BUILD="3600M"
	fi

	check-reqs_pkg_pretend
}

pkg_setup() {
	dhms_start
	if [[ "${MERGE_TYPE}" != "binary" ]] ; then
		if use test ; then
			CHECKREQS_DISK_BUILD="4000M"
		else
			CHECKREQS_DISK_BUILD="3600M"
		fi

		check-reqs_pkg_setup

		llvm_pkg_setup
		rust_pkg_setup

		if false && use clang && use lto && tc-ld-is-lld ; then
			local version_lld=$(ld.lld --version 2>/dev/null | awk '{ print $2 }')
			[[ -n ${version_lld} ]] && version_lld=$(ver_cut 1 "${version_lld}")
			[[ -z ${version_lld} ]] && die "Failed to read ld.lld version!"

			local version_llvm_rust=$(rustc -Vv 2>/dev/null | grep -F -- 'LLVM version:' | awk '{ print $3 }')
			[[ -n ${version_llvm_rust} ]] && version_llvm_rust=$(ver_cut 1 "${version_llvm_rust}")
			[[ -z ${version_llvm_rust} ]] && die "Failed to read used LLVM version from rustc!"

			if false && ver_test "${version_lld}" -ne "${version_llvm_rust}" ; then
eerror "Rust is using LLVM version ${version_llvm_rust} but ld.lld version belongs to LLVM version ${version_lld}."
eerror "You will be unable to link ${CATEGORY}/${PN}. To proceed you have the following options:"
eerror "  - Manually switch rust version using 'eselect rust' to match used LLVM version"
eerror "  - Switch to dev-lang/rust[system-llvm] which will guarantee matching version"
eerror "  - Build ${CATEGORY}/${PN} without USE=lto"
eerror "  - Rebuild lld with llvm that was used to build rust (may need to rebuild the whole "
eerror "    llvm/clang/lld/rust chain depending on your @world updates)"
eerror "LLVM version used by Rust (${version_llvm_rust}) does not match with ld.lld version (${version_lld})!"
				die
			fi
		fi

		python-any-r1_pkg_setup

	# Build system is using /proc/self/oom_score_adj, bug #604394
		addpredict "/proc/self/oom_score_adj"

		if ! mountpoint -q "/dev/shm" ; then
	# If /dev/shm is not available, configure is known to fail with
	# a traceback report referencing /usr/lib/pythonN.N/multiprocessing/synchronize.py
ewarn "/dev/shm is not mounted -- expect build failures!"
		fi

	# Ensure we use C locale when building, bug #746215
		export LC_ALL="C"
	fi
}

src_prepare() {
	pushd "../.." &>/dev/null || die

	use lto && rm -v "${WORKDIR}/firefox-patches/"*"-LTO-Only-enable-LTO-"*".patch"

	if ! use ppc64; then
		rm -v "${WORKDIR}/firefox-patches/"*"ppc64"*".patch" || die
	fi

	# Workaround for bgo #915651,915651,929013 on musl
	if use elibc_glibc ; then
		rm -v "${WORKDIR}/firefox-patches/"*"bgo-748849-RUST_TARGET_override.patch" || die
	fi

	eapply "${WORKDIR}/firefox-patches"
	eapply "${WORKDIR}/spidermonkey-patches"

	default

	# Make cargo respect MAKEOPTS
	export CARGO_BUILD_JOBS="$(makeopts_jobs)"

	# Workaround for bgo #915651,915651,929013 on musl
	if ! use elibc_glibc ; then
		if use amd64 ; then
			export RUST_TARGET="x86_64-unknown-linux-musl"
		elif use x86 ; then
			export RUST_TARGET="i686-unknown-linux-musl"
		else
eerror "Unknown musl chost, please post your rustc -vV along with emerge --info"
eerror "on Gentoo's bug #915651"
			die
		fi
	fi

	# sed-in toolchain prefix
	sed -i \
		-e "s/objdump/${CHOST}-objdump/" \
		"python/mozbuild/mozbuild/configure/check_debug_ranges.py" \
		|| die "sed failed to set toolchain prefix"

	# use prefix shell in wrapper linker scripts, bug #789660
	hprefixify "${S}/../../build/cargo-"{"","host-"}"linker"

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

	MOZJS_BUILDDIR="${WORKDIR}/build"
	mkdir "${MOZJS_BUILDDIR}" || die

	popd &>/dev/null || die
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
#einfo "Current CFLAGS:    ${CFLAGS}"
#einfo "Current CXXFLAGS:  ${CXXFLAGS}"
#einfo "Current LDFLAGS:   ${LDFLAGS}"
#einfo "Current RUSTFLAGS: ${RUSTFLAGS}"

	if tc-is-clang && ! use clang ; then
eerror "Detected clang.  You must set USE=clang."
		die
	fi

	local have_switched_compiler=
	if use clang ; then
	# Force clang
einfo "Enforcing the use of clang due to USE=clang ..."
		local version_clang=$(clang --version 2>/dev/null | grep -F -- 'clang version' | awk '{ print $3 }')
		if [[ -n ${version_clang} ]] ; then
			version_clang=$(ver_cut 1 "${version_clang}")
		fi
		if [[ -z ${version_clang} ]] ; then
eerror "Failed to read clang version!"
			die
		fi
		if tc-is-gcc ; then
			have_switched_compiler="yes"
		fi
		AR="llvm-ar"
		CC="${CHOST}-clang-${version_clang}"
		CXX="${CHOST}-clang++-${version_clang}"
		CPP="${CC} -E"
		NM="llvm-nm"
		RANLIB="llvm-ranlib"
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
	fi

	if [[ -n "${have_switched_compiler}" ]] ; then
	# Because we switched active compiler we have to ensure
	# that no unsupported flags are set
		strip-unsupported-flags
	fi
	cflags-hardened_append
	rustflags-hardened_append

	# Ensure we use correct toolchain,
	# AS is used in a non-standard way by upstream, #bmo1654031
	export HOST_CC="$(tc-getBUILD_CC)"
	export HOST_CXX="$(tc-getBUILD_CXX)"
	export AS="$(tc-getCC) -c"
	tc-export CC CXX LD AR AS NM OBJDUMP RANLIB PKG_CONFIG

	cd "${MOZJS_BUILDDIR}" || die

	# ../python/mach/mach/mixin/process.py fails to detect SHELL
	export SHELL="${EPREFIX}/bin/bash"

	local -a myeconfargs=(
		--host="${CBUILD:-${CHOST}}"
		--target="${CHOST}"

		--disable-ctype
		--disable-jemalloc
		--disable-smoosh
		--disable-strip

		--enable-project=js
		--enable-readline
		--enable-release
		--enable-shared-js

		--with-intl-api
		--with-system-icu
		--with-system-nspr
		--with-system-zlib
		--with-toolchain-prefix="${CHOST}-"

		$(use_enable debug)
		$(use_enable jit)
		$(use_enable test tests)
	)

	if use debug; then
		myeconfargs+=(
			--disable-optimize
			--enable-debug-symbols
			--enable-real-time-tracing
		)
	else
		myeconfargs+=(
			--enable-optimize
			--disable-debug-symbols
			--disable-real-time-tracing
		)
	fi

	if use rust-simd ; then
		local rust_pv=$(rustc --version | cut -f 2 -d " ")
		if ver_test "${rust_pv}" -gt "1.78" ; then
eerror "Use eselect to switch rust to < 1.78 or disable the rust-simd USE flag."
			die
		fi
		myeconfargs+=(
			--enable-rust-simd
		)
	else
	# We always end up disabling this at some point due to newer rust versions. bgo#933372
		myeconfargs+=(
			--disable-rust-simd
		)
	fi

	# Modifications to better support ARM, bug 717344
	if use cpu_flags_arm_neon ; then
		myeconfargs+=(
			--with-fpu=neon
		)
		if ! tc-is-clang ; then
	# Thumb options aren't supported when using clang, bug 666966
			myeconfargs+=(
				--with-thumb=yes
				--with-thumb-interwork=no
			)
		fi
	fi

	# Tell build system that we want to use LTO
	if use lto ; then
		if use clang ; then
			if tc-ld-is-mold ; then
				myeconfargs+=(
					--enable-linker=mold
				)
			else
				myeconfargs+=(
					--enable-linker=lld
				)
			fi
			myeconfargs+=(
				--enable-lto=cross
			)

		else
			myeconfargs+=(
				--enable-linker=bfd
				--enable-lto=full
			)
		fi
	fi

	# LTO flag was handled via configure
	filter-lto

	# Use system's Python environment
	export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE="none"
	export PIP_NETWORK_INSTALL_RESTRICTED_VIRTUALENVS="mach"

	# Show flags we will use
	einfo "Build CFLAGS:    ${CFLAGS}"
	einfo "Build CXXFLAGS:  ${CXXFLAGS}"
	einfo "Build LDFLAGS:   ${LDFLAGS}"
	einfo "Build RUSTFLAGS: ${RUSTFLAGS}"

	# Forcing system-icu allows us to skip patching bundled ICU for PPC
	# and other minor arches
	ECONF_SOURCE="${S}" \
	econf \
		${myeconfargs[@]} \
		XARGS="${EPREFIX}/usr/bin/xargs"
}

src_compile() {
	cd "${MOZJS_BUILDDIR}" || die
	default
}

src_test() {
	if "${MOZJS_BUILDDIR}/js/src/js" -e 'print("Hello world!")'; then
einfo "Smoke-test successful, continuing with full test suite"
	else
eerror "Smoke-test failed: did interpreter initialization fail?"
		die
	fi

	cp \
		"${FILESDIR}/spidermonkey-${SLOT}-known-test-failures.txt" \
		"${T}/known_failures.list" \
		|| die

	if use sparc ; then
		echo \
			"non262/Array/regress-157652.js" \
			>> \
			"${T}/known_failures.list" \
			|| die
		echo \
			"non262/regress/regress-422348.js" \
			>> \
			"${T}/known_failures.list" \
			|| die
		echo \
			"test262/built-ins/TypedArray/prototype/set/typedarray-arg-set-values-same-buffer-other-type.js" \
			>> \
			"${T}/known_failures.list" \
			|| die
	fi

	if use x86 ; then
		echo \
			"non262/Date/timeclip.js" \
			>> \
			"${T}/known_failures.list" \
			|| die
		echo \
			"test262/built-ins/Date/UTC/fp-evaluation-order.js" \
			>> \
			"${T}/known_failures.list" \
			|| die
		echo \
			"test262/language/types/number/S8.5_A2.1.js" \
			>> \
			"${T}/known_failures.list" \
			|| die
		echo \
			"test262/language/types/number/S8.5_A2.2.js" \
			>> \
			"${T}/known_failures.list" \
			|| die
	fi

	${EPYTHON} "${S}/tests/jstests.py" \
		-d \
		-s \
		-t 1800 \
		--wpt=disabled \
		--no-progress \
		--exclude-file="${T}/known_failures.list" \
		"${MOZJS_BUILDDIR}/js/src/js" \
		|| die

	if use jit ; then
		${EPYTHON} "${S}/tests/jstests.py" \
			-d \
			-s \
			-t 1800 \
			--wpt=disabled \
			--no-progress \
			--exclude-file="${T}/known_failures.list" \
			"${MOZJS_BUILDDIR}/js/src/js" \
			"basic" \
			|| die
	fi
}

src_install() {
	cd "${MOZJS_BUILDDIR}" || die
	default

	# Fix soname links
	pushd "${ED}"/usr/$(get_libdir) &>/dev/null || die
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
