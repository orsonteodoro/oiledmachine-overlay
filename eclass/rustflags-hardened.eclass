# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rustflags-hardened.eclass
# @MAINTAINER:
# orsonteodoro@hotmail.com
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Additional functions to simplify hardening
# @DESCRIPTION:
# This eclass can be used to easily deploy harden flags for network/server
# packages.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_RUSTFLAGS_HARDENED_ECLASS} ]]; then
_RUSTFLAGS_HARDENED_ECLASS=1

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_LEVEL
# @DESCRIPTION:
# Sets the SSP (Stack Smashing Protection) level.  Set it before inheriting rustflags-hardened.
# 1 = basic (recommended for heavy packages or performance-critical packages)
#     Use cases:
#     Used by Chromium production builds
#     Linux kernel default for %3 of functions
#     For DSS builds that fail on strong, strongest but pass with standard
# 2 = strong (recommened for light packages, default)
#     Use cases:
#     Used by Chromium debug builds
#     Used by linux kernel default for 20% of functions
#     For DSS builds if test suite fails for strongest but passes for strong
# 3 = strongest
#     Use cases:
#     For DSS builds if test suite passed for this level
RUSTFLAGS_HARDENED_LEVEL=${RUSTFLAGS_HARDENED_LEVEL:-2}

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_USER_LEVEL
# @DESCRIPTION:
# Same as above but the user can override the SSP level.

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_NOEXECSTACK
# @DESCRIPTION:
# Explicitly add -C link-arg=-znoexecstack to flags.

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_PIE
# @DESCRIPTION:
# Adds PIE to executable only packages.
# Acceptable values: 1, 0, unset
# It is recommended that build scripts handle hybrid (exe + libs) cases.

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_PIC
# @DESCRIPTION:
# Adds PIC to library only packages.
# Acceptable values: 1, 0, unset

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_USE_CASES
# @DESCRIPTION:
# Add additional flags to secure packages based on typical USE cases.
# Acceptable values:
#
# ce (Code Execution)
# dos (Denial of Service)
# dt (Data Tampering)
# pe (Privilege Esclation)
# id (Information Disclosure)
#
# admin-access (e.g. sudo)
# container-runtime
# daemon
# dss (e.g. cryptocurrency, finance)
# extension
# execution-integrity
# fp-determinism
# high-precision-research
# hypervisor
# jit
# kernel
# messenger
# real-time-integrity
# safety-critical
# multithreaded-confidential
# multiuser-system
# network
# p2p
# plugin
# sandbox
# secure-critical (e.g. sandbox, antivirus, crypto libs, memory allocator libs)
# sensitive-data
# scripting
# server
# untrusted-data (e.g. user generated content, unreviewed-data, unsanitized-data, unreviewed-scripts, unreviewed-anything)
# web-browser
# web-server

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_TOLERANCE
# @DESCRIPTION:
# The default performance impact to trigger enablement of expensive mitigations.
# Acceptable values: 1.0 to 16.0 (based on table below), unset
# Default: 1.20 (Similar to -Os without mitigations)
# For speed set values closer to 1.
# For accuracy/integrity set values closer to 16.

# Estimates:
# Flag					Performance as a normalized decimal multiple
# No mitigation				   1
# -C stack-protector=all		1.05 - 1.10
# -C stack-protector=strong		1.02 - 1.05
# -C stack-protector=basic		1.01 - 1.03
# -C target-feature=+retpoline		1.01 - 1.20
# -C overflow-checks=on			1.01 - 1.20  *
# -C soft-float				 2.0 - 10.00 *
# -C link-arg=-D_FORTIFY_SOURCE=2	1.01
# -C link-arg=-D_FORTIFY_SOURCE=3	1.02
# -Zsanitizer=address			1.20 - 2.00  *
# -Zsanitizer=memory			 3.0 - 5.0   *
# -Zsanitizer=thread			 5.0 - 15.00 *
# -Zsanitizer=undefined			1.10 - 1.50  *

# * Only these are conditionally set based on worst case
#  RUSTFLAGS_HARDENED_TOLERANCE

# Setting to 2.0 will enable ASAN, UBSAN.
# Setting to 15.0 will enable TSAN.

# For example, TSAN is about 5-15x slower compared to the unmitigated build.

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_TOLERANCE_USER
# A user override for RUSTFLAGS_HARDENED_TOLERANCE.
# Acceptable values: 1.0-16, unset
# Default: unset
# It is assumed that these don't stack and are mutually exclusive.
# It can be applied per package.

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_ASAN
# @DESCRIPTION:
# Allow asan runtime detect to exit before DoS, DT, ID happens.

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_MSAN
# @DESCRIPTION:
# Allow msan runtime detect to exit before DoS, ID happens.

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_TSAN
# @DESCRIPTION:
# Allow tsan runtime detect to exit before DoS, DT happens.

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_UBSAN
# @DESCRIPTION:
# Allow ubsan runtime detect to exit before DoS, DT happens.

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_FORTIFY_SOURCE
# @DESCRIPTION:
# Allow to override the _FORTIFY_SOURCE level.
# Acceptable values:
# 1 - compile time checks only
# 2 - general compile + runtime protection
# 3 - maximum compile + runtime protection

# @FUNCTION: _rustflags-hardened_fcmp
# @DESCRIPTION:
# Floating point compare.  Bash does not support floating point comparison
_rustflags-hardened_fcmp() {
	local a="${1}"
	local opt="${2}"
	local b="${3}"
	python -c "exit(0) if ${a} ${opt} ${b} else exit(1)"
	return $?
}

# @FUNCTION: _rustflags-hardened_has_cet
# @DESCRIPTION:
# Check if CET is supported for -fcf-protection=full.
_rustflags-hardened_has_cet() {
	local ibt=0
	local user_shstk=0
	if grep -q -e "flags.*ibt" "/proc/cpuinfo" ; then
		ibt=1
	fi
	if grep -q -e "flags.*user_shstk" "/proc/cpuinfo" ; then
		user_shstk=1
	fi
	if (( ${ibt} == 1 && ${user_shstk} )) ; then
		return 0
	else
		return 1
	fi
}

# @FUNCTION: rustflags-hardened_append
# @DESCRIPTION:
# Apply RUSTFLAG hardening to Rust packages.
rustflags-hardened_append() {
	if [[ -n "${RUSTFLAGS_HARDENED_USER_LEVEL}" ]] ; then
		RUSTFLAGS_HARDENED_LEVEL="${RUSTFLAGS_HARDENED_USER_LEVEL}"
	fi

	if [[ -n "${RUSTFLAGS_HARDENED_TOLERANCE_USER}" ]] ; then
		RUSTFLAGS_HARDENED_TOLERANCE="${RUSTFLAGS_HARDENED_TOLERANCE_USER}"
	fi

	if [[ -z "${RUSTC}" ]] ; then
eerror "QA:  RUSTC is not initialized.  Did you rust_pkg_setup?"
		die
	fi

	local rust_pv=$("${RUSTC}" --version \
		| cut -f 2 -d " ")

	local arch=$(echo "${CFLAGS}" \
		| grep -E -o -e "-march=[-a-z0-9_]+" \
		| sed -e "s|-march=||")
	if [[ -n "${arch}" ]] && ! [[ "${RUSTFLAGS}" =~ "target-cpu=" ]] ; then
		RUSTFLAGS+=" -C target-cpu=${arch}"
	fi

	local opt_level=$(echo "${CFLAGS}" \
		| grep -E -o -e "-O(0|1|2|3|4|fast|s|z)" \
		| tail -n 1 \
		| sed -e "s|-O||")
	if ! [[ "${RUSTFLAGS}" =~ "opt-level" ]] ; then
		if [[ "${opt_level}" == "fast" ]] ; then
			opt_level="3"
		fi
		if [[ "${opt_level}" == "4" ]] ; then
			opt_level="3"
		fi
		RUSTFLAGS+=" -C opt-level=${opt_level}"
	fi

	if ! _rustflags-hardened_has_cet ; then
	# Allow -mretpoline-external-thunk
		filter-flags "-f*cf-protection=*"
	elif \
		[[ "${RUSTFLAGS_HARDENED_USE_CASES}" \
			=~ \
("ce"\
|"dss"\
|"execution-integrity"\
|"extension"\
|"id"\
|"jit"\
|"language-runtime"\
|"kernel"\
|"multiuser-system"\
|"network"\
|"pe"\
|"plugin"\
|"real-time-integrity"\
|"safety-critical"\
|"scripting"\
|"secure-critical"\
|"sensitive-data"\
|"untrusted-data")\
		]] \
			&&
		ver_test "${rust_pv}" -ge "1.60.0" \
	; then
		RUSTFLAGS+=" -C target-feature=+cet"
	fi

	# Not production ready only available on nightly
	# For status see https://github.com/rust-lang/rust/blob/master/src/doc/rustc/src/exploit-mitigations.md?plain=1#L41
	if true ; then
		: # Broken
	elif ver_test "${rust_pv}" -ge "1.58.0" ; then
		if [[ "${RUSTFLAGS_HARDENED_LEVEL}" == "3" ]] ; then
	# DoS, DT
			RUSTFLAGS+=" -C stack-protector=all"
		elif [[ "${RUSTFLAGS_HARDENED_LEVEL}" == "2" ]] ; then
	# DoS, DT
			RUSTFLAGS+=" -C stack-protector=strong"
		elif [[ "${RUSTFLAGS_HARDENED_LEVEL}" == "1" ]] ; then
	# DoS, DT
			RUSTFLAGS+=" -C stack-protector=basic"
		fi
	fi

	if [[ "${RUSTFLAGS_HARDENED_RETPOLINE:-1}" == "1" && "${RUSTFLAGS_HARDENED_USE_CASES}" =~ ("id"|"kernel") ]] ; then
	# ID
	# Spectre V2 mitigation Linux kernel case
		# For GCC it uses
		#   General case: -mindirect-branch=thunk-extern -mindirect-branch-register
		#   vDSO case:    -mindirect-branch=thunk-inline -mindirect-branch-register
		# For Clang it uses:
		#   General case: -mretpoline-external-thunk -mindirect-branch-cs-prefix
		#   vDSO case:    -mretpoline
		:
	elif \
		[[ \
			"${RUSTFLAGS_HARDENED_RETPOLINE:-1}" == "1" \
				&& \
			"${RUSTFLAGS_HARDENED_USE_CASES}" \
				=~ \
("container-runtime"\
|"dss"\
|"id"\
|"hypervisor"\
|"kernel"\
|"network"\
|"scripting"\
|"sensitive-data"\
|"server"\
|"untrusted-data"\
|"web-browser")\
		]] \
	; then
		:
	# ID
	# Spectre V2 mitigation general case
		# -mfunction-return and -fcf-protection are mutually exclusive.

		if which lscpu >/dev/null && lscpu | grep -E -q "Spectre v2.*(Mitigation|Vulnerable)" ; then
			filter-flags \
				"-m*retpoline" \
				"-m*retpoline-external-thunk" \
				"-m*function-return=*" \
				"-m*indirect-branch-register" \

			if [[ -n "${RUSTFLAGS_HARDENED_RETPOLINE_FLAVOR_USER}" ]] ; then
				RUSTFLAGS_HARDENED_RETPOLINE_FLAVOR="${RUSTFLAGS_HARDENED_RETPOLINE_FLAVOR_USER}"
			fi

			if _rustflags-hardened_has_cet ; then
				:
			else
	# DoS, ID
				RUSTFLAGS+=" -C target-feature=+retpoline"
			fi
		fi
	fi

	if is-flagq "-O0" ; then
		replace-flags "-O0" "-O1"
		RUSTFLAGS+=" -C opt-level=1"

	fi

	# DoS, DT, ID
	filter-flags "-D_FORTIFY_SOURCE=*"
	filter-flags "-U_FORTIFY_SOURCE"
	append-flags "-U_FORTIFY_SOURCE"
	RUSTFLAGS+=" -C link-arg=-U_FORTIFY_SOURCE"
	if [[ -n "${RUSTFLAGS_HARDENED_FORTIFY_SOURCE}" ]] ; then
		local level="${RUSTFLAGS_HARDENED_FORTIFY_SOURCE}"
		append-flags -D_FORTIFY_SOURCE=${level}
		RUSTFLAGS+=" -C link-arg=-D_FORTIFY_SOURCE=${level}"
	elif \
		[[ \
			"${RUSTFLAGS_HARDENED_USE_CASES}" \
				=~ \
("container-runtime"\
|"dss"\
|"untrusted-data"\
|"secure-critical"\
|"multiuser-system") \
		]] \
				&& \
		has_version ">=sys-libs/glibc-2.34" \
	; then
		if tc-is-clang && ver_test $(clang-major-version) -ge "15" ; then
			append-flags "-D_FORTIFY_SOURCE=3"
			RUSTFLAGS+=" -C link-arg=-D_FORTIFY_SOURCE=3"
		elif tc-is-gcc && ver_test $(gcc-major-version) -ge "12" ; then
			append-flags "-D_FORTIFY_SOURCE=3"
			RUSTFLAGS+=" -C link-arg=-D_FORTIFY_SOURCE=3"
		else
			append-flags "-D_FORTIFY_SOURCE=2"
			RUSTFLAGS+=" -C link-arg=-D_FORTIFY_SOURCE=2"
		fi
	else
		append-flags "-D_FORTIFY_SOURCE=2"
		RUSTFLAGS+=" -C link-arg=-D_FORTIFY_SOURCE=2"
	fi

	# Similar to -ftrapv
	if \
		[[ \
			"${RUSTFLAGS_HARDENED_INT_OVERFLOW:-1}" == "1" \
				&& \
			"${RUSTFLAGS_HARDENED_USE_CASES}" \
				=~ \
("dss"\
|"execution-integrity"\
|"network"\
|"secure-critical"\
|"safety-critical"\
|"untrusted-data")\
		]] \
			&& \
		_cflags-hardened_fcmp "${RUSTFLAGS_HARDENED_TOLERANCE}" ">=" "1.20" \
	; then
	# Remove flag if 50% drop in performance.
	# For runtime *signed* integer overflow detection
	# DoS, DT
		RUSTFLAGS+=" -C overflow-checks=on"
	fi

	local host=$(${RUSTC} -vV | grep "host:" | cut -f 2 -d " ")
einfo "rustc host:  ${host}"

	# MC, CE, PE, DoS, DT, ID
	if \
		[[ \
			"${RUSTFLAGS_HARDENED_USE_CASES}" \
				=~ \
("admin-access"\
|"ce"\
|"daemon"\
|"dos"\
|"dss"\
|"dt"\
|"execution-integrity"\
|"extension"\
|"id"\
|"jit"\
|"kernel"\
|"language-runtime"\
|"messenger"\
|"multithreaded-confidential"\
|"multiuser-system"\
|"network"\
|"p2p"\
|"pe"\
|"plugin"\
|"real-time-integrity"\
|"safety-critical"\
|"scripting"\
|"secure-critical"\
|"sensitive-data"\
|"server"\
|"untrusted-data"\
|"web-browser")\
		]] \
	; then
	# For CFLAGS equivalent list, see also `rustc --print target-features`
	# For -mllvm option, see `rustc -C llvm-args="--help"`
		if ${RUSTC} --print target-features | grep -q -e "stack-probe" ; then
	# Mitigation for stack clash, stack overflow
	# Not available for ARCH=amd64 prebuilt build.
			RUSTFLAGS+=" -C target-feature=+stack-probe"
		fi

		RUSTFLAGS+=" -C link-arg=-fstack-clash-protection"
	fi

	if \
		[[ \
			"${RUSTFLAGS_HARDENED_NOEXECSTACK:-1}" == "1" \
				&& \
			"${RUSTFLAGS_HARDENED_USE_CASES}" \
				=~ \
("ce"\
|"execution-integrity"\
|"language-runtime"\
|"multiuser-system"\
|"network"\
|"scripting"\
|"sensitive-data"\
|"server"\
|"untrusted-data"\
|"web-server")\
		]] \
	; then
	# CE, DoS
		RUSTFLAGS+=" -C link-arg=-z -C link-arg=noexecstack"
	fi

	# For executable packages only.
	# Do not apply to hybrid (executible with libs) packages
	if [[ "${RUSTFLAGS_HARDENED_PIE:-0}" == "1" ]] ; then
		RUSTFLAGS+=" -C relocation-model=pic"
		RUSTFLAGS+=" -C link-arg=-pie"
	fi

	# For library packages only
	if [[ "${RUSTFLAGS_HARDENED_PIC:-0}" == "1" ]] ; then
		RUSTFLAGS+=" -C relocation-model=pic"
	fi

	# DoS, DT
	RUSTFLAGS+=" -C relro-level=full"

	if [[ "${RUSTFLAGS_HARDENED_USE_CASES}" =~ ("dss"|"fp-determinism"|"high-precision-research") ]] \
		&& \
	_rustflags-hardened_fcmp "${CFLAGS_HARDENED_TOLERANCE}" ">=" "10.00" \
	; then
		if [[ "${ARCH}" == "amd64" ]] ; then
			replace-flags "-march=*" "-march=generic"
			filter-flags "-mtune=*"
			filter-flags \
				"-m*3dnow*"
				"-m*avx*" \
				"-m*fma*" \
				"-m*mmx" \
				"-m*sse*"
			append-flags \
				"-mno-3dnow" \
				"-mno-avx" \
				"-mno-avx2" \
				"-mno-avx512cd" \
				"-mno-avx512dq" \
				"-mno-avx512f" \
				"-mno-avx512vl" \
				"-mno-avx512ifma" \
				"-mno-fma" \
				"-mno-mmx" \
				"-mno-msse4" \
				"-mno-msse4.1" \
				"-mno-sse" \
				"-mno-sse2"
			RUSTFLAGS+=" -C target-cpu=generic"
			RUSTFLAGS+=" -C target-feature=-3dnow,-avx,-avx2,-avx512cd,-avx512dq,-avx512f,-avx512ifma,-avx512vl,-fma,-mmx,-msse4,-msse4.1,-sse,-sse2"
		fi
		if [[ "${ARCH}" == "arm64" ]] ; then
			replace-flags "-march=*" "-march=armv8-a"
			filter-flags "-mtune=*"
			RUSTFLAGS+=" -C target-cpu=generic"
			RUSTFLAGS+=" -C target-feature=-fp-armv8,-neon"
		fi
		if is-flagq "-Ofast" ; then
			replace-flags "-Ofast" "-O3"
			RUSTFLAGS+=" -C opt-level=3"
		fi
		RUSTFLAGS+=" -C target-cpu=generic"
		RUSTFLAGS+=" -C float-opts=none"
		RUSTFLAGS+=" -C target-feature=+strict-fp"
		RUSTFLAGS+=" -C target-feature=-fast-math"
		RUSTFLAGS+=" -C float-precision=exact"
		RUSTFLAGS+=" -C soft-float"
		RUSTFLAGS+=" -C codegen-units=1"
	fi

	# No CFI support in Rust

	# We don't enable these because clang/llvm not installed by default.
	# We will need to test them before allowing users to use them.
	# Enablement is complicated by LLVM_COMPAT and compile time to build LLVM with sanitizers enabled.
	if _rustflags-hardened_fcmp "${RUSTFLAGS_HARDENED_TOLERANCE}" ">=" "1.50" && [[ "${RUSTFLAGS_HARDENED_UBSAN:-0}" == "1" ]] ; then
# Missing -fno-sanitize-recover for Rust
ewarn "UBSAN_OPTIONS=halt_on_error=1 must be placed in wrapper or env file for UBSAN mitigation to be effective."
		RUSTFLAGS+=" -Zsanitizer=undefined"
		if tc-is-clang && ! has_version "llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[ubsan]" ; then
eerror "Missing UBSAN sanitizer.  Do the following:"
eerror "emerge -1vuDN llvm-runtimes/compiler-rt:${LLVM_SLOT}"
eerror "emerge -vuDN llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[ubsan]"
eerror "emerge -1vuDN llvm-core/clang-runtime:${LLVM_SLOT}[sanitize]"

			die
		fi
	fi

	if _rustflags-hardened_fcmp "${RUSTFLAGS_HARDENED_TOLERANCE}" ">=" "2.00" && [[ "${RUSTFLAGS_HARDENED_ASAN:-0}" == "1" ]] ; then
# Missing -fno-sanitize-recover for Rust
ewarn "ASAN_OPTIONS=halt_on_error=1 must be placed in wrapper or env file for ASAN mitigation to be effective."
		RUSTFLAGS+=" -Zsanitizer=address"
		if tc-is-clang && ! has_version "llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[asan]" ; then
eerror "Missing ASAN sanitizer.  Do the following:"
eerror "emerge -1vuDN llvm-runtimes/compiler-rt:${LLVM_SLOT}"
eerror "emerge -vuDN llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[asan]"
eerror "emerge -1vuDN llvm-core/clang-runtime:${LLVM_SLOT}[sanitize]"

			die
		fi
	fi

	if _rustflags-hardened_fcmp "${RUSTFLAGS_HARDENED_TOLERANCE}" ">=" "5.00" && [[ "${RUSTFLAGS_HARDENED_MSAN:-0}" == "1" ]] ; then
# Missing -fno-sanitize-recover for Rust
ewarn "MSAN_OPTIONS=halt_on_error=1 must be placed in wrapper or env file for MSAN mitigation to be effective."
		RUSTFLAGS+=" -Zsanitizer=memory"
		if tc-is-clang && ! has_version "llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[msan]" ; then
eerror "Missing MSAN sanitizer.  Do the following:"
eerror "emerge -1vuDN llvm-runtimes/compiler-rt:${LLVM_SLOT}"
eerror "emerge -vuDN llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[msan]"
eerror "emerge -1vuDN llvm-core/clang-runtime:${LLVM_SLOT}[sanitize]"

			die
		fi
	fi

	if _rustflags-hardened_fcmp "${RUSTFLAGS_HARDENED_TOLERANCE}" ">=" "15.00" && [[ "${RUSTFLAGS_HARDENED_TSAN:-0}" == "1" ]] ; then
# Missing -fno-sanitize-recover for Rust
ewarn "TSAN_OPTIONS=halt_on_error=1 must be placed in wrapper or env file for TSAN mitigation to be effective."
		RUSTFLAGS+=" -Zsanitizer=thread"
		if tc-is-clang && ! has_version "llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[tsan]" ; then
eerror "Missing TSAN sanitizer.  Do the following:"
eerror "emerge -1vuDN llvm-runtimes/compiler-rt:${LLVM_SLOT}"
eerror "emerge -vuDN llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[tsan]"
eerror "emerge -1vuDN llvm-core/clang-runtime:${LLVM_SLOT}[sanitize]"

			die
		fi
	fi

	export RUSTFLAGS
}

fi
