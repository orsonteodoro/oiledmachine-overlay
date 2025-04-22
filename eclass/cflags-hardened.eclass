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
# 1 = standard (recommended for heavy packages, default)
#     Use cases:
#     Used by Chromium production builds
#     Linux kernel default for %3 of functions
#     For DSS builds that fail on strong, strongest but pass with standard
# 2 = strong (recommened for light packages)
#     Use cases:
#     Used by Chromium debug builds
#     Used by linux kernel default for 20% of functions
#     For DSS builds if test suite fails for strongest but passes for strong
# 3 = strongest
#     Use cases:
#     For DSS builds if test suite passed for this level
CFLAGS_HARDENED_LEVEL=${CFLAGS_HARDENED_LEVEL:-1}
CFLAGS_HARDENED_RETPOLINE_FLAVOR=${CFLAGS_HARDENED_RETPOLINE_FLAVOR:-"default"}

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_USER_LEVEL
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

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_PIE
# @DESCRIPTION:
# Adds -fPIC if compiler is not enable it by default.
# Acceptable values: 1, 0, unset

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_USE_CASES
# Add additional flags to secure packages based on typical USE cases.
# Valid values:
#
# ce (Code Execution)
# dos (Denial of Service)
# dt (Data Tampering)
# pe (Privilege Esclation)
# id (Information Disclosure)
#
# admin-access (e.g. sudo)
# daemon
# dss (e.g. cryptocurrency, finance)
# extensions
# execution-integrity
# kernel
# messengers
# real-time-integrity
# safety-critical
# multithreaded-confidential
# multiuser-system
# p2p
# plugins
# sandbox
# secure-critical (e.g. sandbox, antivirus, crypto libs, memory libs)
# sensitive-data
# scripting
# server
# virtual-machine
# web-browser
# web-server

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
		filter-flags "-fcf-protection=*"
	elif is-flagq "-fcf-protection=*"  ; then
ewarn "Avoiding possible flag conflict between -fcf-protection=return and -mretpoline-external-thunk implied by -fcf-protection=full."
		filter-flags "-mretpoline-external-thunk"
		return
	fi

	if [[ "${CFLAGS_HARDENED_RETPOLINE_FLAVOR}" =~ ("secure-realtime"|"secure-speed") ]] && test-flags-CC "-mretpoline" ; then
	# For portablity and speed
		append-flags "-mretpoline"
		CFLAGS_HARDENED_CFLAGS+=" -mretpoline"
		CFLAGS_HARDENED_CXXFLAGS+=" -mretpoline"
		CFLAGS_HARDENED_LDFLAGS+=" -Wl,-z,retpolineplt"
	elif [[ "${CFLAGS_HARDENED_RETPOLINE_FLAVOR}" =~ ("secure-embedded"|"secure-lightweight") ]] && test-flags-CC "-mretpoline" && test-flags-CC "-mretpoline-external-thunk" ; then
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
		filter-flags "-fcf-protection=*"
	elif is-flagq "-fcf-protection=*"  ; then
ewarn "Forcing -mindirect-branch-register to avoid flag conflict between -fcf-protection=return implied by -fcf-protection=full."
		CFLAGS_HARDENED_RETPOLINE_FLAVOR="register"
	fi

	# cf-protection (CE -> DoS, DT, ID) is a more stronger than Retpoline against Spectre v2 (ID).
	# cf-protection=full is mutually exclusive to -mfunction-return=thunk.
	# For old machines without CET, we fallback to Retpoline.
	# For newer machines, we prioritize CET over Retpoline.

	filter-flags "-mfunction-return=*"
	filter-flags "-mindirect-branch-register"

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

	if [[ -n "${CFLAGS_HARDENED_USER_LEVEL}" ]] ; then
		CFLAGS_HARDENED_LEVEL="${CFLAGS_HARDENED_USER_LEVEL}"
	fi

	CFLAGS_HARDENED_CFLAGS=""
	CFLAGS_HARDENED_CXXFLAGS=""
	CFLAGS_HARDENED_LDFLAGS=""
	if \
		[[ "${CFLAGS_HARDENED_LEVEL}" == "2" ]] \
			&& \
		[[ "${CFLAGS_HARDENED_USE_CASES}" =~ ("admin-access"|"ce"|"daemon"|"dos"|"dss"|"dt"|"execution-integrity"|"extensions"|"id"|"kernel"|"messengers"|"multithreaded-confidential"|"multiuser-system"|"p2p"|"pe"|"plugins"|"real-time-integrity"|"safety-critical"|"secure-critical"|"sensitive-data"|"server"|"web-browser") ]] \
			&& \
		tc-check-min_ver gcc "14.2" \
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
			"-fstack-clash-protection" \
			"-fstack-protector" \
			"-fstack-protector-strong" \
			"-fstack-protector-all" \
			"-D_FORTIFY_SOURCE=1" \
			"-D_FORTIFY_SOURCE=2" \
			"-D_FORTIFY_SOURCE=3" \
			"-Wl,-z,relro" \
			"-Wl,-z,now" \
			"-fcf-protection=*"
		filter-flags "-fhardened"
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
			[[ "${CFLAGS_HARDENED_USE_CASES}" =~ ("admin-access"|"ce"|"daemon"|"databases"|"dos"|"dss"|"dt"|"execution-integrity"|"messengers"|"multithreaded-confidential"|"multiuser-system"|"p2p"|"pe"|"secure-critical"|"server"|"suid"|"web-browser") ]] \
				&&
			test-flags-CC "-fstack-clash-protection" \
		; then
	# MC, DT, CE, DoS, PE
	# CE = Code Execution
	# DoS = Denial of Service
	# DT = Data Tampering
	# ID = Information Disclosure
	# MC = Memory Corruption
	# PE = Privilege Execution
			filter-flags "-fstack-clash-protection"
			append-flags "-fstack-clash-protection"
			CFLAGS_HARDENED_CFLAGS+=" -fstack-clash-protection"
			CFLAGS_HARDENED_CXXFLAGS+=" -fstack-clash-protection"
		fi
		if [[ "${CFLAGS_HARDENED_LEVEL}" == "1" ]] && ! tc-enables-ssp ; then
einfo "Standard SSP hardening (>= 8 byte buffers, *alloc functions)"
			filter-flags "-fstack-protector"
			append-flags "-fstack-protector"
			CFLAGS_HARDENED_CFLAGS+=" -fstack-protector"
			CFLAGS_HARDENED_CXXFLAGS+=" -fstack-protector"
		elif [[ "${CFLAGS_HARDENED_LEVEL}" == "2" ]] && ! tc-enables-ssp-strong ; then
einfo "Strong SSP hardening (>= 8 byte buffers, *alloc functions, functions with local arrays or local pointers)"
			filter-flags "-fstack-protector-strong"
			append-flags "-fstack-protector-strong"
			CFLAGS_HARDENED_CFLAGS+=" -fstack-protector-strong"
			CFLAGS_HARDENED_CXXFLAGS+=" -fstack-protector-strong"
		elif [[ "${CFLAGS_HARDENED_LEVEL}" == "3" ]] && ! tc-enables-ssp-all ; then
einfo "All SSP hardening (All functions hardened)"
			filter-flags "-fstack-protector-all"
			append-flags "-fstack-protector-all"
			CFLAGS_HARDENED_CFLAGS+=" -fstack-protector-all"
			CFLAGS_HARDENED_CXXFLAGS+=" -fstack-protector-all"
		fi
		if ! tc-enables-fortify-source ; then
			filter-flags \
				-D_FORTIFY_SOURCE=1 \
				-D_FORTIFY_SOURCE=2 \
				-D_FORTIFY_SOURCE=3
			append-flags -D_FORTIFY_SOURCE=2
			CFLAGS_HARDENED_CFLAGS+=" -D_FORTIFY_SOURCE=2"
			CFLAGS_HARDENED_CXXFLAGS+=" -D_FORTIFY_SOURCE=2"
		fi
		append-ldflags "-Wl,-z,relro"
		append-ldflags "-Wl,-z,now"
		CFLAGS_HARDENED_LDFLAGS+=" -Wl,-z,relro"
		CFLAGS_HARDENED_LDFLAGS+=" -Wl,-z,now"
		if \
			[[ "${CFLAGS_HARDENED_USE_CASES}" =~ ("ce"|"dss"|"execution-integrity"|"extensions"|"id"|"kernel"|"pe"|"plugins"|"real-time-integrity"|"safety-critical"|"secure-critical"|"sensitive-data") ]] \
					&&
			test-flags-CC "-fcf-protection=full" \
					&&
			_cflags-hardened_has_cet \
		; then
	# MC, ID, PE, CE
			filter-flags "-fcf-protection=*"
			append-flags "-fcf-protection=full"
			CFLAGS_HARDENED_CFLAGS+=" -fcf-protection=full"
			CFLAGS_HARDENED_CXXFLAGS+=" -fcf-protection=full"
		fi
	fi

	if [[ "${CFLAGS_HARDENED_USE_CASES}" =~ ("ce"|"execution-integrity"|"scripting"|"sensitive-data"|"server"|"web-server") ]] ; then
	# CE, DT/ID
		filter-flags "-Wa,--noexecstack"
		filter-flags "-Wl,-z,noexecstack"
		append-flags "-Wa,--noexecstack"
		append-ldflags "-Wl,-z,noexecstack"
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
	elif [[ "${CFLAGS_HARDENED_RETPOLINE:-1}" == "1" && "${CFLAGS_HARDENED_USE_CASES}" =~ ("dss"|"id"|"scripting"|"sensitive-data"|"server"|"virtual-machine"|"web-browser") ]] ; then
		:
	# ID
	# Spectre V2 mitigation general case
		# -mfunction-return and -fcf-protection are mutually exclusive.

		if which lscpu >/dev/null && lscpu | grep -q "Spectre v2.*Mitigation" ; then
			filter-flags \
				"-mretpoline" \
				"-mretpoline-external-thunk" \
				"-mfunction-return=keep" \
				"-mindirect-branch-register" \
				"-mfunction-return=thunk" \
				"-mfunction-return=thunk-inline" \
				"-mfunction-return=thunk-extern"

			if [[ -n "${CFLAGS_HARDENED_RETPOLINE_FLAVOR_USER}" ]] ; then
				CFLAGS_HARDENED_RETPOLINE_FLAVOR="${CFLAGS_HARDENED_RETPOLINE_FLAVOR_USER}"
			fi

			_cflags-hardened_append_gcc_retpoline
			_cflags-hardened_append_clang_retpoline
		fi
	fi

	if [[ "${CFLAGS_HARDENED_PIE:-1}" == "1" ]] && ! tc-enables-pie ; then
		filter-flags "-fPIC"
		append-flags "-fPIC"
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
