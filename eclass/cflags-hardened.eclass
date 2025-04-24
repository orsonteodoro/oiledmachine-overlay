# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cflags-hardened.eclass
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

if [[ -z ${_CFLAGS_HARDENED_ECLASS} ]]; then
_CFLAGS_HARDENED_ECLASS=1

inherit flag-o-matic toolchain-funcs

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_LEVEL
# @DESCRIPTION:
# Sets the SSP (Stack Smashing Protection) level.  Set it before inheriting cflags-hardened.
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
CFLAGS_HARDENED_LEVEL=${CFLAGS_HARDENED_LEVEL:-2}

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_LEVEL_USER
# @USER_VARIABLE
# @DESCRIPTION:
# Same as above but the user can override the SSP level.

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_RETPOLINE
# @DESCRIPTION:
# Acceptable values:
# 0 or unset - disable or ebuild can customize it
# 1 - General case solution
# If the CPU is not vulnerable, it will not apply the flag.

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_RETPOLINE_FLAVOR
# @DESCRIPTION:
# Controls retpoline protection versus speed tradeoff.
# Acceptable values:  balanced, default, register, secure, secure-embedded, secure-lightweight, secure-realtime, secure-speed, testing
# The default could be register or secure depending on CET.
# secure is compiler dependent so the performance guarantees vary.
# secure is a bidirectional alias for default, balanced.
# secure-embedded is a bidirectional alias for secure-lightweight.
# secure-realtime is a bidirectional alias for secure-speed.
CFLAGS_HARDENED_RETPOLINE_FLAVOR=${CFLAGS_HARDENED_RETPOLINE_FLAVOR:-"default"}

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_RETPOLINE_FLAVOR_USER
# @DESCRIPTION:
# Allows the user to override retpoline protection versus speed tradeoff.
# See CFLAGS_HARDENED_RETPOLINE_FLAVOR for details.

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_APPEND_GOFLAGS
# @DESCRIPTION:
# Append flags to CGO_CFLAGS, GO_CXXFLAGS, CGO_LDFLAGS when
# cflags-hardened_append is called.
# Acceptable values: 1, 0, unset

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_DISABLED
# @USER_VARIABLE
# @DESCRIPTION:
# A user variable to disable hardening flags.
#
# Example contents of /etc/make.conf:
# CFLAGS_HARDENED_DISABLED=1
#

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_NOEXECSTACK
# @DESCRIPTION:
# Explicitly add -Wa,--noexecstack or -Wl,-z,noexecstack to flags.

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_PIE
# @DESCRIPTION:
# Adds -fPIE -pie if compiler is not enable it by default to executable only packages.
# Acceptable values: 1, 0, unset
# It is recommended that build scripts handle hybrid (exe + libs) cases.

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_PIC
# @DESCRIPTION:
# Adds -fPIC if compiler is not enable it by default to library only packages.
# Acceptable values: 1, 0, unset

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_ASAN
# @DESCRIPTION:
# Allow asan runtime detect to exit before DoS, DT, ID happens.

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_CFI
# @DESCRIPTION:
# Allow runtime execution integrity check to prevent CE, DoS, DT
# to exit before unauthorized transaction in trusted code.

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_MSAN
# @DESCRIPTION:
# Allow msan runtime detect to exit before DoS, ID happens.

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_TSAN
# @DESCRIPTION:
# Allow tsan runtime detect to exit before DoS, DT happens.

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_UBSAN
# @DESCRIPTION:
# Allow ubsan runtime detect to exit before DoS, DT happens.


# @ECLASS_VARIABLE:  CFLAGS_HARDENED_TOLERANCE
# @DESCRIPTION:
# The default performance impact to trigger enablement of expensive mitigations.
# Acceptable values: 1.0 to 21.00 (based on table below), unset
# Default: 1.35 (Similar to -Os without mitigations)
CFLAGS_HARDENED_TOLERANCE=${CFLAGS_HARDENED_TOLERANCE:-"1.35"}
# For speed set values closer to 1.
# For accuracy/integrity set values closer to 20.

# Estimates:
# Flag					Performance as a normalized decimal multiple
# No mitigation				1.00
# -D_FORTIFY_SOURCE=2			1.01
# -D_FORTIFY_SOURCE=3			1.02
# -fstack-protect			1.01 - 1.05
# -fstack-protect-strong		1.03 - 1.10
# -fstack-protect-all			1.05 - 1.10
# -fcf-protection			1.01 - 1.05
# -fstack-clash-protection		1.02 - 1.10
# -ftrapv				1.20 - 2.00  *
# -fcf-protection=full			1.03 - 1.10
# -fsanitize=cfi			1.05 - 1.15  *
# -fsanitize=undefined			1.02 - 1.20  *
# -fsanitize=address			1.50 - 2.00  *
# -fsanitize=memory			3.00 - 5.00  *
# -fsanitize=thread			2.00 - 5.00  *
# -mfloat-abi=soft -mfpu=none           5.00 - 20.00 *
# -mfunction-return=thunk-extern	1.01 - 1.05
# -mfunction-return=thunk-inline	1.01 - 1.03
# -mfunction-return=thunk		1.01 - 1.05
# -mretpoline				1.10 - 1.30
# -mretpoline-external-thunk		1.15 - 1.35

# * Only these are conditionally set based on worst case
#  CFLAGS_HARDENED_TOLERANCE

# Setting to 5.0 will enable TSAN, ASAN, UBSAN, LLVM CFI.
# Setting to 20.0 will enable soft-floats.

# For example, TSAN is about 2-5x slower compared to the unmitigated build.

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_TOLERANCE_USER
# @USER_VARIABLE
# A user override for CFLAGS_HARDENED_TOLERANCE.  This is to allow the user to
# set the security-performance tradeoff especially for performance-critical
# apps/libs.
# Acceptable values: 1.0-20.00, unset (same as CFLAGS_HARDENED_TOLERANCE)
# Default: unset
# It is assumed that these don't stack and are mutually exclusive.
# It can be applied per package.

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_USE_CASES
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

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_FORTIFY_SOURCE
# @DESCRIPTION:
# Allow to override the _FORTIFY_SOURCE level.
# Acceptable values:
# 1 - compile time checks only
# 2 - general compile + runtime protection
# 3 - maximum compile + runtime protection


# @FUNCTION: _cflags-hardened_has_cet
# @DESCRIPTION:
# Check if CET is supported for -fcf-protection=full.
_cflags-hardened_has_cet() {
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

# @FUNCTION: _cflags-hardened_append_clang_retpoline
# @DESCRIPTION:
# Apply retpoline flags for Clang.
_cflags-hardened_append_clang_retpoline() {
	tc-is-clang || return
	[[ "${ARCH}" == "amd64" ]] || return

	if ! _cflags-hardened_has_cet ; then
	# Allow -mretpoline-external-thunk
		filter-flags "-f*cf-protection=*"
	elif is-flagq "-fcf-protection=*"  ; then
ewarn "Avoiding possible flag conflict between -fcf-protection=return and -mretpoline-external-thunk implied by -fcf-protection=full."
		filter-flags "-mretpoline-external-thunk"
		return
	fi

	if \
		[[ "${CFLAGS_HARDENED_RETPOLINE_FLAVOR}" =~ ("secure-realtime"|"secure-speed") ]] \
			&& \
		test-flags-CC "-mretpoline" \
	; then
	# For portablity and speed
		append-flags "-mretpoline"
		CFLAGS_HARDENED_CFLAGS+=" -mretpoline"
		CFLAGS_HARDENED_CXXFLAGS+=" -mretpoline"
		CFLAGS_HARDENED_LDFLAGS+=" -Wl,-z,retpolineplt"
	elif \
		[[ "${CFLAGS_HARDENED_RETPOLINE_FLAVOR}" =~ ("secure-embedded"|"secure-lightweight") ]] \
			&& \
		test-flags-CC "-mretpoline" \
			&& \
		test-flags-CC "-mretpoline-external-thunk" \
	; then
	# For cheap embedded devices that are designed to be slow.
		append-flags "-mretpoline"
		CFLAGS_HARDENED_CFLAGS+=" -mretpoline"
		CFLAGS_HARDENED_CXXFLAGS+=" -mretpoline"
		CFLAGS_HARDENED_LDFLAGS+=" -Wl,-z,retpolineplt"

		append-flags "-mretpoline-external-thunk"
		CFLAGS_HARDENED_CFLAGS+=" -mretpoline-external-thunk"
		CFLAGS_HARDENED_CXXFLAGS+=" -mretpoline-external-thunk"
	else
	# For portablity and speed
		append-flags "-mretpoline"
		CFLAGS_HARDENED_CFLAGS+=" -mretpoline"
		CFLAGS_HARDENED_CXXFLAGS+=" -mretpoline"
		CFLAGS_HARDENED_LDFLAGS+=" -Wl,-z,retpolineplt"
	fi
}

# @FUNCTION: _cflags-hardened_append_gcc_retpoline
# @DESCRIPTION:
# Apply retpoline flags for gcc
_cflags-hardened_append_gcc_retpoline() {
	tc-is-gcc || return
	[[ "${ARCH}" == "amd64" ]] || return

	if ! _cflags-hardened_has_cet ; then
	# Allow -mfunction-return=*
		filter-flags "-f*cf-protection=*"
	elif is-flagq "-fcf-protection=*"  ; then
ewarn "Forcing -mindirect-branch-register to avoid flag conflict between -fcf-protection=return implied by -fcf-protection=full."
		CFLAGS_HARDENED_RETPOLINE_FLAVOR="register"
	fi

	# cf-protection (CE -> DoS, DT, ID) is a more stronger than Retpoline against Spectre v2 (ID).
	# cf-protection=full is mutually exclusive to -mfunction-return=thunk.
	# For old machines without CET, we fallback to Retpoline.
	# For newer machines, we prioritize CET over Retpoline.

	filter-flags "-m*function-return=*"
	filter-flags "-m*indirect-branch-register"

	if [[ "${CFLAGS_HARDENED_RETPOLINE_FLAVOR}" == "testing" ]] && test-flags-CC "-mfunction-return=keep" ; then
	# No mitigation
		append-flags $(test-flags-CC "-mfunction-return=keep")
		CFLAGS_HARDENED_CFLAGS+=" -mfunction-return=keep"
		CFLAGS_HARDENED_CXXFLAGS+=" -mfunction-return=keep"
	elif \
		[[ \
			   "${CFLAGS_HARDENED_RETPOLINE_FLAVOR}" =~ ("balanced"|"default"|"portable") \
			|| "${CFLAGS_HARDENED_RETPOLINE_FLAVOR}" == "secure" \
		]] \
			&& \
		test-flags-CC "-mfunction-return=thunk" \
	; then
	# Full mitigation gainst Spectre v2 (but random performance between compiler vendors)
		append-flags $(test-flags-CC "-mfunction-return=thunk")
		CFLAGS_HARDENED_CFLAGS+=" -mfunction-return=thunk"
		CFLAGS_HARDENED_CXXFLAGS+=" -mfunction-return=thunk"
	elif [[ "${CFLAGS_HARDENED_RETPOLINE_FLAVOR}" =~ ("secure-embedded"|"secure-lightweight") ]] && test-flags-CC "-mfunction-return=thunk-extern" ; then
	# Full mitigation against Spectre v2 (deterministic)
		append-flags $(test-flags-CC "-mfunction-return=thunk-extern")
		CFLAGS_HARDENED_CFLAGS+=" -mfunction-return=thunk-extern"
		CFLAGS_HARDENED_CXXFLAGS+=" -mfunction-return=thunk-extern"
	elif [[ "${CFLAGS_HARDENED_RETPOLINE_FLAVOR}" =~ ("secure-realtime"|"secure-speed") ]] && test-flags-CC "-mfunction-return=thunk-inline" ; then
	# Full mitigation against Spectre v2 (deterministic)
		append-flags $(test-flags-CC "-mfunction-return=thunk-inline")
		CFLAGS_HARDENED_CFLAGS+=" -mfunction-return=thunk-inline"
		CFLAGS_HARDENED_CXXFLAGS+=" -mfunction-return=thunk-inline"
	fi

	if [[ "${CFLAGS_HARDENED_RETPOLINE_FLAVOR}" == "register" ]] && test-flags-CC "-mindirect-branch-register" ; then
	# Mitigation against CFI but does not mitigate Spectre v2.
		append-flags $(test-flags-CC "-mindirect-branch-register")
		CFLAGS_HARDENED_CFLAGS+=" -mindirect-branch-register"
		CFLAGS_HARDENED_CXXFLAGS+=" -mindirect-branch-register"
	fi
}

# @FUNCTION: _cflags-hardened_fcmp
# @DESCRIPTION:
# Floating point compare.  Bash does not support floating point comparison
_cflags-hardened_fcmp() {
	local a="${1}"
	local opt="${2}"
	local b="${3}"
	python -c "exit(0) if ${a} ${opt} ${b} else exit(1)"
	return $?
}

# @FUNCTION: cflags-hardened_append
# @DESCRIPTION:
# Apply and deploy hardening flags easily.
# The CFLAGS_HARDENED_CFLAGS, CFLAGS_HARDENED_CXXFLAGS, CFLAGS_HARDENED_LDFLAGS
# can be deployed in other equivalent flags like CGO_CFLAGS, GO_CXXFLAGS,
# CGO_LDFLAGS
#
# CFLAGS_HARDENED_APPEND_GOFLAGS=1 can be used append to CGO_*FLAGS.
#
cflags-hardened_append() {
	[[ "${CFLAGS_HARDENED_DISABLED:-0}" == 1 ]] && return

	if [[ -z "${CC}" ]] ; then
		export CC=$(tc-getCC)
		export CXX=$(tc-getCXX)
		export CPP="${CC} -E"
einfo "CC:  ${CC}"
		${CC} --version || die
	fi

	if \
		_cflags-hardened_fcmp "${CFLAGS_HARDENED_TOLERANCE}" ">=" "1.15" \
			&& \
		[[ "${CFLAGS_HARDENED_CFI:-0}" == "1" ]] \
			&& \
		! _cflags-hardened_has_cet \
			&& \
		[[ "${ARCH}" == "amd64" ]] \
	; then
		if tc-is-clang ; then
			:
		elif tc-is-gcc && [[ -n "${LLVM_SLOT}" ]] ; then
			export CC="${CHOST}-clang-${LLVM_SLOT}"
			export CXX="${CHOST}-clang++-${LLVM_SLOT}"
			export CPP="${CC} -E"
		elif tc-is-gcc ; then
			export CC="${CHOST}-clang"
			export CXX="${CHOST}-clang++"
			export CPP="${CC} -E"
		fi
		if [[ -z "${LLVM_SLOT}" ]] ; then
			export LLVM_SLOT=$(clang-major-version)
			export CC="${CHOST}-clang-${LLVM_SLOT}"
			export CXX="${CHOST}-clang++-${LLVM_SLOT}"
			export CPP="${CC} -E"
		fi
		strip-unsupported-flags
		if ${CC} --version ; then
eerror "CFI requires Clang.  Do the following:"
eerror "emerge -1vuDN llvm-core/llvm:${LLVM_SLOT}"
eerror "emerge -vuDN llvm-core/clang:${LLVM_SLOT}"
eerror "emerge -vuDN llvm-core/lld"
eerror "emerge -1vuDN llvm-runtimes/compiler-rt:${LLVM_SLOT}"
eerror "emerge -vuDN llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[cfi]"
eerror "emerge -1vuDN llvm-core/clang-runtime:${LLVM_SLOT}[sanitize]"
ewarn "You can only use Clang with LTO systemwide if doing LLVM CFI."

			die
		fi
	fi

	if [[ -n "${CFLAGS_HARDENED_LEVEL_USER}" ]] ; then
		CFLAGS_HARDENED_LEVEL="${CFLAGS_HARDENED_LEVEL_USER}"
	fi

	if [[ -n "${CFLAGS_HARDENED_TOLERANCE_USER}" ]] ; then
		CFLAGS_HARDENED_TOLERANCE="${CFLAGS_HARDENED_TOLERANCE_USER}"
	fi

	CFLAGS_HARDENED_CFLAGS=""
	CFLAGS_HARDENED_CXXFLAGS=""
	CFLAGS_HARDENED_LDFLAGS=""
	local gcc_pv=$(gcc-version)
	if \
		[[ \
			"${CFLAGS_HARDENED_LEVEL}" == "2" \
		]] \
				&& \
		[[ \
			"${CFLAGS_HARDENED_USE_CASES}" \
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
			&& \
		tc-is-gcc \
			&&
		ver_test "${gcc_pv}" -ge "14.2" \
	; then
einfo "Appending -fhardened"
einfo "Strong SSP hardening (>= 8 byte buffers, *alloc functions, functions with local arrays or local pointers)"
		if [[ "${CFLAGS}" =~ "-O0" ]] ; then
			replace-flags "-O0" "-O1"
			CFLAGS_HARDENED_CFLAGS+=" -O1"
		fi
		if [[ "${CXXFLAGS}" =~ "-O0" ]] ; then
			replace-flags "-O0" "-O1"
			CFLAGS_HARDENED_CFLAGS+=" -O1"
		fi
		filter-flags \
			"-f*cf-protection=*" \
			"-f*hardened" \
			"-f*stack-clash-protection" \
			"-f*stack-protector" \
			"-f*stack-protector-strong" \
			"-f*stack-protector-all" \
			"-D_FORTIFY_SOURCE=1" \
			"-D_FORTIFY_SOURCE=2" \
			"-D_FORTIFY_SOURCE=3" \
			"-Wl,-z,relro" \
			"-Wl,-z,now"

	# DoS, DT, ID
		append-flags "-fhardened"
		CFLAGS_HARDENED_CFLAGS+=" -fhardened"
		CFLAGS_HARDENED_CXXFLAGS+=" -fhardened"
		CFLAGS_HARDENED_LDFLAGS=""
	else
		replace-flags "-O0" "-O1"
		if [[ "${CFLAGS}" =~ "-O0" ]] ; then
			CFLAGS_HARDENED_CFLAGS+=" -O1"
		fi
		if [[ "${CXXFLAGS}" =~ "-O0" ]] ; then
			CFLAGS_HARDENED_CFLAGS+=" -O1"
		fi
		if \
			[[ \
				"${CFLAGS_HARDENED_USE_CASES}" \
					=~ \
("admin-access"\
|"ce"\
|"daemon"\
|"databases"\
|"dos"\
|"dss"\
|"dt"\
|"execution-integrity"\
|"messenger"\
|"multithreaded-confidential"\
|"multiuser-system"\
|"network"\
|"p2p"\
|"pe"\
|"secure-critical"\
|"server"\
|"suid"\
|"untrusted-data"\
|"web-browser")\
			]] \
					&&
			test-flags-CC "-fstack-clash-protection" \
		; then
	# CE = Code Execution
	# DoS = Denial of Service
	# DT = Data Tampering
	# ID = Information Disclosure
	# MC = Memory Corruption
	# PE = Privilege Execution

	# MC, CE, PE, DoS, DT, ID
			filter-flags "-f*stack-clash-protection"
			append-flags "-fstack-clash-protection"
			CFLAGS_HARDENED_CFLAGS+=" -fstack-clash-protection"
			CFLAGS_HARDENED_CXXFLAGS+=" -fstack-clash-protection"
		fi
		if [[ "${CFLAGS_HARDENED_LEVEL}" == "1" ]] && ! tc-enables-ssp ; then
	# DoS, DT
einfo "Standard SSP hardening (>= 8 byte buffers, *alloc functions)"
			filter-flags "-f*stack-protector"
			append-flags "-fstack-protector"
			CFLAGS_HARDENED_CFLAGS+=" -fstack-protector"
			CFLAGS_HARDENED_CXXFLAGS+=" -fstack-protector"
		elif [[ "${CFLAGS_HARDENED_LEVEL}" == "2" ]] && ! tc-enables-ssp-strong ; then
	# DoS, DT
einfo "Strong SSP hardening (>= 8 byte buffers, *alloc functions, functions with local arrays or local pointers)"
			filter-flags "-f*stack-protector-strong"
			append-flags "-fstack-protector-strong"
			CFLAGS_HARDENED_CFLAGS+=" -fstack-protector-strong"
			CFLAGS_HARDENED_CXXFLAGS+=" -fstack-protector-strong"
		elif [[ "${CFLAGS_HARDENED_LEVEL}" == "3" ]] && ! tc-enables-ssp-all ; then
	# DoS, DT
einfo "All SSP hardening (All functions hardened)"
			filter-flags "-f*stack-protector-all"
			append-flags "-fstack-protector-all"
			CFLAGS_HARDENED_CFLAGS+=" -fstack-protector-all"
			CFLAGS_HARDENED_CXXFLAGS+=" -fstack-protector-all"
		fi

	# DoS, DT
		append-ldflags "-Wl,-z,relro"
		append-ldflags "-Wl,-z,now"
		CFLAGS_HARDENED_LDFLAGS+=" -Wl,-z,relro"
		CFLAGS_HARDENED_LDFLAGS+=" -Wl,-z,now"
		if \
			[[ "${CFLAGS_HARDENED_USE_CASES}" \
					=~ \
("ce"\
|"dss"\
|"execution-integrity"\
|"extension"\
|"id"\
|"jit"\
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
			test-flags-CC "-fcf-protection=full" \
					&&
			_cflags-hardened_has_cet \
		; then
	# MC, ID, PE, CE
			filter-flags "-f*cf-protection=*"
			append-flags "-fcf-protection=full"
			CFLAGS_HARDENED_CFLAGS+=" -fcf-protection=full"
			CFLAGS_HARDENED_CXXFLAGS+=" -fcf-protection=full"
		fi

		if \
			tc-is-clang \
					&&
			[[ \
				"${CFLAGS_HARDENED_TRIVIAL_AUTO_VAR_INIT:-1}" == "1" \
					&&
				"${CFLAGS_HARDENED_USE_CASES}" \
					=~ \
("dos"\
|"dss"\
|"safety-critical"\
|"secure-critical") \
			]] \
		; then
	# DoS, ID
			filter-flags "-f*trivial-auto-var-init=*"
			append-flags "-ftrivial-auto-var-init=zero"
			CFLAGS_HARDENED_CFLAGS+=" -ftrivial-auto-var-init=zero"
			CFLAGS_HARDENED_CXXFLAGS+=" -ftrivial-auto-var-init=zero"
		fi
	fi

	if \
		[[ \
			"${CFLAGS_HARDENED_NOEXECSTACK:-1}" == "1" \
				&& \
			"${CFLAGS_HARDENED_USE_CASES}" \
				=~ \
("ce"\
|"execution-integrity"\
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
		filter-flags "-Wa,--noexecstack"
		filter-flags "-Wl,-z,noexecstack"
		append-flags "-Wa,--noexecstack"
		append-ldflags "-Wl,-z,noexecstack"
		CFLAGS_HARDENED_CFLAGS+=" -Wa,--noexecstack"
		CFLAGS_HARDENED_CXXFLAGS+=" -Wa,--noexecstack"
		CFLAGS_HARDENED_LDFLAGS+=" -Wl,-z,noexecstack"
	fi
	if [[ "${CFLAGS_HARDENED_RETPOLINE:-1}" == "1" && "${CFLAGS_HARDENED_USE_CASES}" =~ ("id"|"kernel") ]] ; then
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
			"${CFLAGS_HARDENED_RETPOLINE:-1}" == "1" \
				&& \
			"${CFLAGS_HARDENED_USE_CASES}" \
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
	# DoS, ID
	# Spectre V2 mitigation general case
		# -mfunction-return and -fcf-protection are mutually exclusive.

		if which lscpu >/dev/null && lscpu | grep -E -q "Spectre v2.*(Mitigation|Vulnerable)" ; then
			filter-flags \
				"-m*retpoline" \
				"-m*retpoline-external-thunk" \
				"-m*function-return=*" \
				"-m*indirect-branch-register" \

			if [[ -n "${CFLAGS_HARDENED_RETPOLINE_FLAVOR_USER}" ]] ; then
				CFLAGS_HARDENED_RETPOLINE_FLAVOR="${CFLAGS_HARDENED_RETPOLINE_FLAVOR_USER}"
			fi

			_cflags-hardened_append_gcc_retpoline
			_cflags-hardened_append_clang_retpoline
		fi
	fi

	if \
		[[ \
			"${CFLAGS_HARDENED_TRAPV:-1}" == "1" \
				&& \
			"${CFLAGS_HARDENED_USE_CASES}" =~ \
("dss"\
|"execution-integrity"\
|"network"\
|"secure-critical"\
|"safety-critical"\
|"untrusted-data")\
		]] \
				&& \
		_cflags-hardened_fcmp "${CFLAGS_HARDENED_TOLERANCE}" ">=" "2.00" \
	; then
	# Remove flag if 50% drop in performance.
	# For runtime *signed* integer overflow detection
	# DoS, DT
		filter-flags "-f*trapv"
		append-flags "-ftrapv"
		CFLAGS_HARDENED_CFLAGS+=" -ftrapv"
		CFLAGS_HARDENED_CXXFLAGS+=" -ftrapv"
	fi

	if ! tc-enables-fortify-source ; then
		filter-flags \
			"-D_FORTIFY_SOURCE=*"

	# DoS, DT, ID
		if [[ -n "${CFLAGS_HARDENED_FORTIFY_SOURCE}" ]] ; then
			local level="${CFLAGS_HARDENED_FORTIFY_SOURCE}"
			append-flags -D_FORTIFY_SOURCE=${level}
			CFLAGS_HARDENED_CFLAGS+=" -D_FORTIFY_SOURCE=${level}"
			CFLAGS_HARDENED_CXXFLAGS+=" -D_FORTIFY_SOURCE=${level}"
		elif \
			[[ "${CFLAGS_HARDENED_USE_CASES}" =~ ("container-runtime"|"untrusted-data"|"secure-critical"|"multiuser-system") ]] \
				&& \
			ver_test ">=sys-libs/glibc-2.34" \
		; then
			if tc-is-clang && ver_test $(gcc-major-version) -ge "15" ; then
				append-flags -D_FORTIFY_SOURCE=3
				CFLAGS_HARDENED_CFLAGS+=" -D_FORTIFY_SOURCE=3"
				CFLAGS_HARDENED_CXXFLAGS+=" -D_FORTIFY_SOURCE=3"
			elif tc-is-gcc && ver_test $(clang-major-version) -ge "12" ; then
				append-flags -D_FORTIFY_SOURCE=3
				CFLAGS_HARDENED_CFLAGS+=" -D_FORTIFY_SOURCE=3"
				CFLAGS_HARDENED_CXXFLAGS+=" -D_FORTIFY_SOURCE=3"
			else
				append-flags -D_FORTIFY_SOURCE=2
				CFLAGS_HARDENED_CFLAGS+=" -D_FORTIFY_SOURCE=2"
				CFLAGS_HARDENED_CXXFLAGS+=" -D_FORTIFY_SOURCE=2"
			fi
		else
			append-flags -D_FORTIFY_SOURCE=2
			CFLAGS_HARDENED_CFLAGS+=" -D_FORTIFY_SOURCE=2"
			CFLAGS_HARDENED_CXXFLAGS+=" -D_FORTIFY_SOURCE=2"
		fi
	fi

	# For executable packages only.
	# Do not apply to hybrid (executible with libs) packages
	if [[ "${CFLAGS_HARDENED_PIE:-0}" == "1" ]] && ! tc-enables-pie ; then
		filter-flags "-fPIE" "-pie"
		append-flags "-fPIE" "-pie"
		CFLAGS_HARDENED_CFLAGS+=" -fPIE -pie"
		CFLAGS_HARDENED_CXXFLAGS+=" -fPIE -pie"
	fi

	# For library packages only
	if [[ "${CFLAGS_HARDENED_PIC:-0}" == "1" ]] ; then
		filter-flags "-fPIC"
		append-flags "-fPIC"
		CFLAGS_HARDENED_CFLAGS+=" -fPIC"
		CFLAGS_HARDENED_CXXFLAGS+=" -fPIC"
	fi

	if tc-is-gcc && is-flagq '-Ofast' && [[ "${CFLAGS_HARDENED_USE_CASES}" =~ ("dss"|"safety-critical") ]] ; then
	# DoS, DT
		filter-flags "-f*allow-store-data-races"
		append-flags "-fno-allow-store-data-races"
		CFLAGS_HARDENED_CFLAGS+=" -fno-allow-store-data-races"
		CFLAGS_HARDENED_CXXFLAGS+=" -fno-allow-store-data-races"
	fi

	if \
		[[ "${CFLAGS_HARDENED_USE_CASES}" =~ ("dss"|"fp-determinism"|"high-precision-research") ]] \
			&& \
		_cflags-hardened_fcmp "${CFLAGS_HARDENED_TOLERANCE}" ">=" "20.00" \
	; then
	# Do not use in performance-critical applications
		replace-flags "-Ofast" "-O3"
		if [[ "${ARCH}" == "amd64" ]] ; then
			filter-flags "-march=*"
			filter-flags "-mtune=*"
			filter-flags \
				"-m*3dnow*"
				"-m*avx*" \
				"-m*fma*" \
				"-m*mmx" \
				"-m*sse*"
			append-flags "-march=generic"
			CFLAGS_HARDENED_CFLAGS+=" -march=generic"
			CFLAGS_HARDENED_CXXFLAGS+=" -march=generic"
			local l=(
				"-mno-3dnow" \
				"-mno-avx"
				"-mno-avx2"
				"-mno-avx512cd"
				"-mno-avx512dq"
				"-mno-avx512f"
				"-mno-avx512ifma"
				"-mno-avx512vl"
				"-mno-mmx"
				"-mno-msse4"
				"-mno-msse4.1"
				"-mno-sse"
				"-mno-sse2"
			)
			append-flags ${l[@]}
			CFLAGS_HARDENED_CFLAGS+=" ${l[@]}"
			CFLAGS_HARDENED_CXXFLAGS+=" ${l[@]}"
		fi
		if [[ "${ARCH}" == "arm64" ]] ; then
			filter-flags "-march=*"
			filter-flags "-mtune=*"
			append-flags "-march=armv8-a"
			append-flags "-mfloat-abi=soft" "-mfpu=none"
			CFLAGS_HARDENED_CFLAGS+=" -march=armv8-a"
			CFLAGS_HARDENED_CXXFLAGS+=" -march=armv8-a"
			CFLAGS_HARDENED_CFLAGS+=" -mfloat-abi=soft -mfpu=none"
			CFLAGS_HARDENED_CXXFLAGS+=" -mfloat-abi=soft -mfpu=none"
		fi
		filter-flags \
			"-f*fast-math" \
			"-f*float-store" \
			"-f*excess-precision=*" \
			"-f*fp-contract=*" \
			"-f*rounding-math" \
			"-m*fpmath=*"
		append-flags \
			"-ffast-math" \
			"-ffloat-store" \
			"-fexcess-precision=standard" \
			"-ffp-contract=off" \
			"-frounding-math"
		CFLAGS_HARDENED_CFLAGS+=" -ffloat-store -fexcess-precision=standard -ffp-contract=off -frounding-math"
		CFLAGS_HARDENED_CXXFLAGS+=" -ffloat-store -fexcess-precision=standard -ffp-contract=off -frounding-math"
	fi

	# We want to fallback to CFI if CET is missing to mitigate against CE.

	# For LLVM CFI, we want to be to *require* it as a fallback for non CET
	# users to support it for just browsers.

	# We don't enable these because clang/llvm not installed by default.
	# We will need to test them before allowing users to use them.
	# Enablement is complicated by LLVM_COMPAT and compile time to build LLVM with sanitizers enabled.
	# Worst case scores for tolerance
	if \
		_cflags-hardened_fcmp "${CFLAGS_HARDENED_TOLERANCE}" ">=" "1.15" \
			&& \
		[[ "${CFLAGS_HARDENED_CFI:-0}" == "1" ]] \
			&& \
		! _cflags-hardened_has_cet \
			&& \
		[[ "${ARCH}" == "amd64" ]] \
	; then
		filter-flags "-f*sanitize=cfi"
		append-flags "-fsanitize=cfi"
		CFLAGS_HARDENED_CFLAGS+=" -fsanitize=cfi"
		CFLAGS_HARDENED_CXXFLAGS+=" -fsanitize=cfi"

		filter-flags "-flto*"
		append-flags "-flto=thin"
		append-ldflags "-flto=thin"
		if tc-is-gcc && [[ "${CFLAGS_HARDENED_LTO_PARALLEL:-1}" == "1" ]] ; then
			append-ldflags "-fuse-linker-plugin"
		fi
		filter-flags "-fuse-ld=*"
		append-ldflags "-fuse-ld=lld"
		if [[ -z "${LLVM_SLOT}" ]] || ! has_version "llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[cfi]" ; then
eerror "CFI requires Clang.  Do the following:"
eerror "emerge -1vuDN llvm-core/llvm:${LLVM_SLOT}"
eerror "emerge -vuDN llvm-core/clang:${LLVM_SLOT}"
eerror "emerge -vuDN llvm-core/lld"
eerror "emerge -1vuDN llvm-runtimes/compiler-rt:${LLVM_SLOT}"
eerror "emerge -vuDN llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[cfi]"
eerror "emerge -1vuDN llvm-core/clang-runtime:${LLVM_SLOT}[sanitize]"

			die
		fi
	fi

	if \
		_cflags-hardened_fcmp "${CFLAGS_HARDENED_TOLERANCE}" ">=" "1.20" \
			&& \
		[[ "${CFLAGS_HARDENED_UBSAN:-0}" == "1" ]] \
	; then
		filter-flags "-f*sanitize=undefined"
		append-flags "-fsanitize=undefined"
		CFLAGS_HARDENED_CFLAGS+=" -fsanitize=undefined"
		CFLAGS_HARDENED_CXXFLAGS+=" -fsanitize=undefined"
		if tc-is-clang && ! has_version "llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[ubsan]" ; then
eerror "Missing UBSAN sanitizer.  Do the following:"
eerror "emerge -1vuDN llvm-runtimes/compiler-rt:${LLVM_SLOT}"
eerror "emerge -vuDN llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[ubsan]"
eerror "emerge -1vuDN llvm-core/clang-runtime:${LLVM_SLOT}[sanitize]"

			die
		fi
	fi

	if \
		_cflags-hardened_fcmp "${CFLAGS_HARDENED_TOLERANCE}" ">=" "2.00" \
			&& \
		[[ "${CFLAGS_HARDENED_ASAN:-0}" == "1" ]] \
	; then
		filter-flags "-f*sanitize=address"
		append-flags "-fsanitize=address"
		CFLAGS_HARDENED_CFLAGS+=" -fsanitize=address"
		CFLAGS_HARDENED_CXXFLAGS+=" -fsanitize=address"
		if tc-is-clang && ! has_version "llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[asan]" ; then
eerror "Missing ASAN sanitizer.  Do the following:"
eerror "emerge -1vuDN llvm-runtimes/compiler-rt:${LLVM_SLOT}"
eerror "emerge -vuDN llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[asan]"
eerror "emerge -1vuDN llvm-core/clang-runtime:${LLVM_SLOT}[sanitize]"

			die
		fi
	fi

	if \
		_cflags-hardened_fcmp "${CFLAGS_HARDENED_TOLERANCE}" ">=" "5.00" \
			&& \
		[[ "${CFLAGS_HARDENED_TSAN:-0}" == "1"  ]] \
	; then
		filter-flags "-f*sanitize=thread"
		append-flags "-fsanitize=thread"
		CFLAGS_HARDENED_CFLAGS+=" -fsanitize=thread"
		CFLAGS_HARDENED_CXXFLAGS+=" -fsanitize=thread"
		if tc-is-clang && ! has_version "llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[tsan]" ; then
eerror "Missing TSAN sanitizer.  Do the following:"
eerror "emerge -1vuDN llvm-runtimes/compiler-rt:${LLVM_SLOT}"
eerror "emerge -vuDN llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[tsan]"
eerror "emerge -1vuDN llvm-core/clang-runtime:${LLVM_SLOT}[sanitize]"

			die
		fi
	fi

	if \
		_cflags-hardened_fcmp "${CFLAGS_HARDENED_TOLERANCE}" ">=" "5.00" \
			&& \
		[[ "${CFLAGS_HARDENED_MSAN:-0}" == "1"  ]] \
	; then
		filter-flags "-f*sanitize=memory"
		append-flags "-fsanitize=memory"
		CFLAGS_HARDENED_CFLAGS+=" -fsanitize=memory"
		CFLAGS_HARDENED_CXXFLAGS+=" -fsanitize=memory"
		if tc-is-clang && ! has_version "llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[tsan]" ; then
eerror "Missing MSAN sanitizer.  Do the following:"
eerror "emerge -1vuDN llvm-runtimes/compiler-rt:${LLVM_SLOT}"
eerror "emerge -vuDN llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[msan]"
eerror "emerge -1vuDN llvm-core/clang-runtime:${LLVM_SLOT}[sanitize]"

			die
		fi
	fi

	if [[ "${CFLAGS}" =~ "-fsanitize=" ]] ; then
	# Force exit before data/execution integrity is compromised.
		filter-flags "-f*sanitize-recover"
		append-flags "-fno-sanitize-recover"
		CFLAGS_HARDENED_CFLAGS+=" -fno-sanitize-recover"
		CFLAGS_HARDENED_CXXFLAGS+=" -fno-sanitize-recover"
	fi

	export CFLAGS_HARDENED_CFLAGS
	export CFLAGS_HARDENED_CXXFLAGS
	export CFLAGS_HARDENED_LDFLAGS
einfo "CFLAGS:  ${CFLAGS}"
einfo "CXXFLAGS:  ${CXXFLAGS}"
einfo "LDFLAGS:  ${LDFLAGS}"
	if [[ "${CFLAGS_HARDENED_APPEND_GOFLAGS:-0}" == "1" ]] ; then
		export CGO_CFLAGS+=" ${CFLAGS_HARDENED_CFLAGS}"
		export CGO_CXXFLAGS+=" ${CFLAGS_HARDENED_CXXFLAGS}"
		export CGO_LDFLAGS+=" ${CFLAGS_HARDENED_LDFLAGS}"
einfo "CGO_CFLAGS:  ${CGO_CFLAGS}"
einfo "CGO_CXXFLAGS:  ${CGO_CXXFLAGS}"
einfo "CGO_LDFLAGS:  ${CGO_LDFLAGS}"
	fi
}

# @FUNCTION: cflags-hardened_append_nx
# @DESCRIPTION:
# Add nx bit protection to remove security warning.
# Example warning: https://bugs.gentoo.org/256679
# See https://wiki.gentoo.org/wiki/Hardened/GNU_stack_quickstart#Causes_of_executable_stack_markings
cflags-hardened_append_nx() {
	append-flags -Wa,--noexecstack
	append-ldflags -Wl,-z,noexecstack
	if [[ "${CFLAGS_HARDENED_APPEND_GOFLAGS:-0}" == "1" ]] ; then
		export CGO_CFLAGS+=" -Wa,--noexecstack"
		export CGO_CXXFLAGS+=" -Wa,--noexecstack"
		export CGO_LDFLAGS+=" -Wl,-z,noexecstack"
	fi
einfo "CFLAGS:  ${CFLAGS}"
einfo "CXXFLAGS:  ${CXXFLAGS}"
einfo "LDFLAGS:  ${LDFLAGS}"
einfo "CGO_CFLAGS:  ${CGO_CFLAGS}"
einfo "CGO_CXXFLAGS:  ${CGO_CXXFLAGS}"
einfo "CGO_LDFLAGS:  ${CGO_LDFLAGS}"
}

fi
