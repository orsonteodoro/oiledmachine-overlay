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

# TODO add PAC support

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
# Acceptable values:  balanced, default, secure, secure-embedded, secure-lightweight, secure-realtime, secure-speed, testing
# secure is compiler dependent so the performance guarantees vary.
# secure is a bidirectional alias for default, balanced.
# secure-embedded is a bidirectional alias for secure-lightweight.
# secure-realtime is a bidirectional alias for secure-speed or IBRS.
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

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_SANITIZERS
# @DESCRIPTION:
# A space delimited list of allowed sanitizer options.

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_TOLERANCE
# @DESCRIPTION:
# The default performance impact to trigger enablement of expensive mitigations.
# Acceptable values: 1.0 to 21.00 (based on table below), unset
# Default: 1.35 (Similar to -O1 best case without mitigations)
CFLAGS_HARDENED_TOLERANCE=${CFLAGS_HARDENED_TOLERANCE:-"1.35"}
# For speed set values closer to 1.
# For accuracy/integrity set values closer to 20.

# Estimates:
# Flag					Performance as a normalized decimal multiple
# No mitigation				1.00
# -D_FORTIFY_SOURCE=2			1.01
# -D_FORTIFY_SOURCE=3			1.02
# -fcf-protection=full			1.03 -  1.10
# -fstack-clash-protection		1.02 -  1.10
# -fstack-protect			1.01 -  1.05
# -fstack-protect-strong		1.03 -  1.10
# -fstack-protect-all			1.05 -  1.10
# -ftrapv				1.20 -  2.00
# -fsanitize=address			1.50 -  4.00 (ASan); 1.01 - 1.1 (GWP-ASan)
# -fsanitize=cfi			1.10 -  2.00
# -fsanitize=hwaddress			1.15 -  1.50 (ARM64)
# -fsanitize=leak			1.05 -  1.50
# -fsanitize=memory			3.00 - 11.00
# -fsanitize=safe-stack			1.01 -  1.20
# -fsanitize=shadowcallstack		1.01 -  1.15
# -fsanitize=thread			4.00 - 16.00
# -fsanitize=undefined			1.10 -  2.00
# -mbranch-protection=bti		1.00 -  1.05
# -mbranch-protection=pac-ret		1.01 -  1.05
# -mbranch-protection=pac-ret+bti	1.02 -  1.07
# -mbranch-protection=standard		1.02 -  1.07
# -mfloat-abi=soft -mfpu=none           5.00 - 20.00
# -mfunction-return=thunk-extern	1.01 -  1.05
# -mfunction-return=thunk-inline	1.01 -  1.03
# -mfunction-return=thunk		1.01 -  1.05
# -mindirect-branch=ibrs		1.01 -  1.10
# -mindirect-branch=thunk		1.05 -  1.30
# -mindirect-branch=thunk-inline	1.03 -  1.25
# -mindirect-branch=thunk-extern	1.05 -  1.15
# -mindirect-branch-register		1.05 -  1.30
# -mretpoline				1.10 -  1.30
# -mretpoline-external-thunk		1.15 -  1.35
# -fvtable-verify=preinit		1.06 -  1.16
# -fvtable-verify=std			1.05 -  1.15

# Setting to 4.0 will enable ASAN and other faster sanitizers.
# Setting to 15.0 will enable TSan and other faster sanitizers.
# Setting to 20.0 will enable soft-floats and other faster sanitizers.

# For example, TSan is about 4-16x slower compared to the unmitigated build.

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_TOLERANCE_USER
# @USER_VARIABLE
# @DESCRIPTION:
# A user override for CFLAGS_HARDENED_TOLERANCE.  This is to allow the user to
# set the security-performance tradeoff especially for performance-critical
# apps/libs.
# Acceptable values: 1.0-20.00, unset (same as CFLAGS_HARDENED_TOLERANCE)
# Default: unset
# It is assumed that these don't stack and are mutually exclusive.
#
# What value means is that one can tune the package for either low latency or
# more accurate calcuation by controlling the worst case limits on a per
# package basis.
# (ex. stock trading versus accurate finance model calculated predictions)
#

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
# game-engine
# high-precision-research
# hypervisor
# jit
# kernel
# language-runtime (e.g. compiler, interpeter, language virtual machine)
# messenger
# modular-app (an app that uses plugins)
# real-time-integrity
# safety-critical
# multithreaded-confidential
# multiuser-system
# network
# p2p
# plugin
# sandbox
# security-critical (e.g. sandbox, antivirus, crypto libs, memory allocator libs)
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

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_INDIRECT_BRANCH_REGISTER
# @DESCRIPTION:
# Acceptable values:
# 1 - enable (default)
# 0 - disable, if buggy

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_SANITIZERS_COMPAT
# @DESCRIPTION:
# A list of sanitizer implementations that have been verified to work with
# the test suite in src_test().
#
# You cannot mix sanitizers with static-libs.  The preferred value depends on
# the default CC/CXX.  The CC vendor should not be changed per package but
# distro does not put guardrails from doing this.  List of compatible sanitizers
# This affects if the sanitizer be applied to the package.  This affects if
# LLVM CFI gets applied also.
#
# Acceptable values:
#
#   llvm - via llvm-runtimes/compiler-rt-sanitizers
#   gcc  - via sys-devel/gcc[sanitizers]
#
# Example:
#
#   CFLAGS_HARDENED_SANITIZERS_COMPAT=( "gcc" "llvm" )
#

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_BTI_USER
# @USER_VARIABLE
# @DESCRIPTION:
# User override to force enable BTI (Branch Target Identification).
# armv9*-r or armv8*-r users should set this if they have the feature.
# Valid values: 1, 0, unset

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_MTE_USER
# @USER_VARIABLE
# @DESCRIPTION:
# User override to force enable MTE (Memory Tag Extention).
# armv9*-r or armv8*-r users should set this if they have the feature.
# Valid values: 1, 0, unset

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_PAC_USER
# @USER_VARIABLE
# @DESCRIPTION:
# User override to force enable PAC (Pointer Authentication Code).
# armv9*-r or armv8*-r users should set this if they have the feature.
# Valid values: 1, 0, unset

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_ARM_CFI_USER
# @USER_VARIABLE
# @DESCRIPTION:
# Allow build to be built with JOP, ROP mitigations
# Valid values: 1, 0, unset

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

# @FUNCTION: _cflags-hardened_proximate_opt_level
# @DESCRIPTION:
# Convert the tolerance level to -Oflag level
_cflags-hardened_proximate_opt_level() {
	if _cflags-hardened_fcmp "${CFLAGS_HARDENED_TOLERANCE}" ">" "1.80" ; then
einfo "CFLAGS_HARDENED_TOLERANCE:  ${CFLAGS_HARDENED_TOLERANCE} (similar to -O0 with heavy thrashing)"
	elif _cflags-hardened_fcmp "${CFLAGS_HARDENED_TOLERANCE}" ">=" "1.4" ; then
einfo "CFLAGS_HARDENED_TOLERANCE:  ${CFLAGS_HARDENED_TOLERANCE} (similar to -O0 with light thrashing)"
	elif _cflags-hardened_fcmp "${CFLAGS_HARDENED_TOLERANCE}" ">=" "1.35" ; then
einfo "CFLAGS_HARDENED_TOLERANCE:  ${CFLAGS_HARDENED_TOLERANCE} (similar to -O1)"
	elif _cflags-hardened_fcmp "${CFLAGS_HARDENED_TOLERANCE}" ">=" "1.25" ; then
einfo "CFLAGS_HARDENED_TOLERANCE:  ${CFLAGS_HARDENED_TOLERANCE} (similar to -Os)"
	elif _cflags-hardened_fcmp "${CFLAGS_HARDENED_TOLERANCE}" ">=" "1.10" ; then
einfo "CFLAGS_HARDENED_TOLERANCE:  ${CFLAGS_HARDENED_TOLERANCE} (similar to -O2)"
	elif _cflags-hardened_fcmp "${CFLAGS_HARDENED_TOLERANCE}" ">=" "1.05" ; then
einfo "CFLAGS_HARDENED_TOLERANCE:  ${CFLAGS_HARDENED_TOLERANCE} (similar to -O3)"
	else
einfo "CFLAGS_HARDENED_TOLERANCE:  ${CFLAGS_HARDENED_TOLERANCE} (similar to -Ofast)"
	fi
einfo
einfo "The CFLAGS_HARDENED_TOLERANCE_USER can override this.  See"
einfo "cflags-hardened.eclass for details."
einfo
}

# @FUNCTION: _cflags-hardened_sanitizers_compat
# @DESCRIPTION:
# Check the sanitizer compatibility
_cflags-hardened_sanitizers_compat() {
	local needed_compiler="${1}"
	local impl
	for impl in ${CFLAGS_HARDENED_SANITIZERS_COMPAT[@]} ; do
		if [[ "${impl}" == "${needed_compiler}" ]] ; then
			return 0
		fi
	done
	return 1
}

# @FUNCTION: _cflags-hardened_has_mte
# @DESCRIPTION:
# Check if CPU supports MTE (Memory Tagging Extension)
_cflags-hardened_has_mte() {
	local mte=0
	if grep "Features" "/proc/cpuinfo" | grep -q -e "mte" ; then
		mte=1
	fi
	return ${mte}
}

# @FUNCTION: _cflags-hardened_has_pauth
# @DESCRIPTION:
# Check if CPU supports PAC (Pointer Authentication Code)
_cflags-hardened_has_pauth() {
	local pauth=0
	if grep "Features" "/proc/cpuinfo" | grep -q -e "pauth" ; then
		pauth=1
	fi
	return ${pauth}
}

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
# PE, ID
_cflags-hardened_append_clang_retpoline() {
	tc-is-clang || return
	[[ "${ARCH}" == "amd64" ]] || return

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
	# ZC, ID
		append-flags "-mretpoline"
		CFLAGS_HARDENED_CFLAGS+=" -mretpoline"
		CFLAGS_HARDENED_CXXFLAGS+=" -mretpoline"
		CFLAGS_HARDENED_LDFLAGS+=" -Wl,-z,retpolineplt"

	# ZC, ID
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

	#-mindirect-branch is not compatible with fcf-protection=return
	# There is a tradeoff between -fcf-protection versus -mindirect-branch.
	# We keep the flag that removes the more dangerous vulnerabilities.
	if _cflags-hardened_has_cet ; then
		filter-flags "-m*retpoline"
		filter-flags "-m*retpoline-external-thunk"
		filter-flags "-Wl,-z,retpolineplt"
		CFLAGS_HARDENED_CFLAGS=$(echo "${CFLAGS_HARDENED_CFLAGS}" \
			| sed \
				-e "s|-mretpoline||g" \
				-e "s|-mretpoline-external-thunk||g")
		CFLAGS_HARDENED_CXXFLAGS=$(echo "${CFLAGS_HARDENED_CXXFLAGS}" \
			| sed \
				-e "s|-mretpoline||g" \
				-e "s|-mretpoline-external-thunk||g")
		CFLAGS_HARDENED_LDFLAGS=$(echo "${CFLAGS_HARDENED_LDFLAGS}" \
			| sed \
				-e "s|-Wl,-z,retpolineplt||g")
	else
		filter-flags "-f*cf-protection=*"
		append-flags "-fcf-protection=none" # none works, branch works, return doesn't work
	fi
}

# @FUNCTION: _cflags-hardened_append_gcc_retpoline
# @DESCRIPTION:
# Apply retpoline flags for gcc
_cflags-hardened_append_gcc_retpoline() {
	tc-is-gcc || return
	[[ "${ARCH}" == "amd64" ]] || return

	# cf-protection (CE, ID) is a more stronger than Retpoline against Spectre v2 (ID).
	# cf-protection=full is mutually exclusive to -mfunction-return=thunk.
	# For old machines without CET, we fallback to Retpoline.
	# For newer machines, we prioritize CET over Retpoline.

	filter-flags "-m*function-return=*"
	filter-flags "-m*indirect-branch-register"

	if \
		[[ "${CFLAGS_HARDENED_RETPOLINE_FLAVOR}" == "testing" ]] \
			&& \
		test-flags-CC "-mfunction-return=keep" \
	; then
	# No mitigation
		append-flags $(test-flags-CC "-mfunction-return=keep")
		CFLAGS_HARDENED_CFLAGS+=" -mfunction-return=keep"
		CFLAGS_HARDENED_CXXFLAGS+=" -mfunction-return=keep"
	elif \
		[[ \
			"${CFLAGS_HARDENED_RETPOLINE_FLAVOR}" =~ ("balanced"|"default"|"portable") \
				|| \
			"${CFLAGS_HARDENED_RETPOLINE_FLAVOR}" == "secure" \
		]] \
			&& \
		test-flags-CC "-mfunction-return=thunk" \
	; then
	# Full mitigation gainst Spectre v2 (but random performance between compiler vendors)
	# ZC, ID
		append-flags $(test-flags-CC "-mfunction-return=thunk")
		CFLAGS_HARDENED_CFLAGS+=" -mfunction-return=thunk"
		CFLAGS_HARDENED_CXXFLAGS+=" -mfunction-return=thunk"
	elif \
		[[ "${CFLAGS_HARDENED_RETPOLINE_FLAVOR}" =~ ("secure-embedded"|"secure-lightweight") ]] \
			&& \
		test-flags-CC "-mfunction-return=thunk-extern" \
	; then
	# Full mitigation against Spectre v2 (deterministic)
		append-flags $(test-flags-CC "-mfunction-return=thunk-extern")
		CFLAGS_HARDENED_CFLAGS+=" -mfunction-return=thunk-extern"
		CFLAGS_HARDENED_CXXFLAGS+=" -mfunction-return=thunk-extern"
	elif \
		[[ "${CFLAGS_HARDENED_RETPOLINE_FLAVOR}" =~ ("secure-realtime"|"secure-speed") ]] \
			&& \
		test-flags-CC "-mfunction-return=thunk-inline" \
	; then
	# Full mitigation against Spectre v2 (deterministic)
		append-flags $(test-flags-CC "-mfunction-return=thunk-inline")
		CFLAGS_HARDENED_CFLAGS+=" -mfunction-return=thunk-inline"
		CFLAGS_HARDENED_CXXFLAGS+=" -mfunction-return=thunk-inline"
	fi

	if \
		[[ "${CFLAGS_HARDENED_RETPOLINE_FLAVOR}" =~ ("secure-realtime"|"secure-speed") ]] \
			&& \
		which lscpu \
			&& \
		grep -q -e "Spectre v2.*Mitigation.*IBRS_FW" \
	; then
	# Full mitigation against Spectre v2 (hardware implementation)
		append-flags $(test-flags-CC "-mindirect-branch=ibrs")
		CFLAGS_HARDENED_CFLAGS+=" -mindirect-branch=ibrs"
		CFLAGS_HARDENED_CXXFLAGS+=" -mindirect-branch=ibrs"
	elif \
		[[ "${CFLAGS_HARDENED_RETPOLINE_FLAVOR}" == "testing" ]] \
			&& \
		test-flags-CC "-mindirect-branch=none" \
	; then
	# No mitigation
		append-flags $(test-flags-CC "-mindirect-branch=none")
		CFLAGS_HARDENED_CFLAGS+=" -mindirect-branch=none"
		CFLAGS_HARDENED_CXXFLAGS+=" -mindirect-branch=none"
	elif \
		[[ \
			"${CFLAGS_HARDENED_RETPOLINE_FLAVOR}" =~ ("balanced"|"default"|"portable") \
				|| \
			"${CFLAGS_HARDENED_RETPOLINE_FLAVOR}" == "secure" \
		]] \
			&& \
		test-flags-CC "-mindirect-branch=thunk" \
	; then
	# Full mitigation against Spectre v2 (but random performance between compiler vendors)
	# ZC, ID
		append-flags $(test-flags-CC "-mindirect-branch=thunk")
		CFLAGS_HARDENED_CFLAGS+=" -mindirect-branch=thunk"
		CFLAGS_HARDENED_CXXFLAGS+=" -mindirect-branch=thunk"
	elif \
		[[ "${CFLAGS_HARDENED_RETPOLINE_FLAVOR}" =~ ("secure-embedded"|"secure-lightweight") ]] \
			&& \
		test-flags-CC "-mindirect-branch=thunk-extern" \
	; then
	# Full mitigation against Spectre v2 (deterministic)
		append-flags $(test-flags-CC "-mindirect-branch=thunk-extern")
		CFLAGS_HARDENED_CFLAGS+=" -mindirect-branch=thunk-extern"
		CFLAGS_HARDENED_CXXFLAGS+=" -mindirect-branch=thunk-extern"
	elif \
		[[ "${CFLAGS_HARDENED_RETPOLINE_FLAVOR}" =~ ("secure-realtime"|"secure-speed") ]] \
			&& \
		test-flags-CC "-mindirect-branch=thunk-inline" \
	; then
	# Full mitigation against Spectre v2 (deterministic)
		append-flags $(test-flags-CC "-mindirect-branch=thunk-inline")
		CFLAGS_HARDENED_CFLAGS+=" -mindirect-branch=thunk-inline"
		CFLAGS_HARDENED_CXXFLAGS+=" -mindirect-branch=thunk-inline"
	fi

	if \
		[[ "${CFLAGS_HARDENED_INDIRECT_BRANCH_REGISTER:-1}" == "1" ]] \
			&& \
		[[ \
			"${CFLAGS_HARDENED_RETPOLINE_FLAVOR}" == "register" \
				|| \
			"${CFLAGS}" =~ ("mindirect-branch"|"function-return") \
		]] \
			&& \
		test-flags-CC "-mindirect-branch-register" \
	; then
	# Mitigation against CFI but does not mitigate Spectre v2.
		append-flags $(test-flags-CC "-mindirect-branch-register")
		CFLAGS_HARDENED_CFLAGS+=" -mindirect-branch-register"
		CFLAGS_HARDENED_CXXFLAGS+=" -mindirect-branch-register"
	fi

	#-mindirect-branch is not compatible with fcf-protection=return
	# There is a tradeoff between -fcf-protection versus -mindirect-branch.
	# We keep the flag that removes the more dangerous vulnerabilities.
	if _cflags-hardened_has_cet ; then
		filter-flags "-m*function-return=*"
		filter-flags "-m*indirect-branch=*"
		filter-flags "-m*indirect-branch-register"
		CFLAGS_HARDENED_CFLAGS=$(echo "${CFLAGS_HARDENED_CFLAGS}" \
			| sed \
				-e "s|-mindirect-branch-register||g")
		CFLAGS_HARDENED_CXXFLAGS=$(echo "${CXXFLAGS_HARDENED_CFLAGS}" \
			| sed \
				-e "s|-mindirect-branch-register||g")
		CFLAGS_HARDENED_CFLAGS=$(echo "${CFLAGS_HARDENED_CFLAGS}" \
			| sed \
				-e "s|-mfunction-return=keep||g" \
				-e "s|-mfunction-return=thunk||g" \
				-e "s|-mfunction-return=thunk-inline||g" \
				-e "s|-mfunction-return=thunk-extern||g")
		CFLAGS_HARDENED_CXXFLAGS=$(echo "${CXXFLAGS_HARDENED_CFLAGS}" \
			| sed \
				-e "s|-mfunction-return=keep||g" \
				-e "s|-mfunction-return=thunk||g" \
				-e "s|-mfunction-return=thunk-inline||g" \
				-e "s|-mfunction-return=thunk-extern||g")
		CFLAGS_HARDENED_CFLAGS=$(echo "${CFLAGS_HARDENED_CFLAGS}" \
			| sed \
				-e "s|-mindirect-branch=thunk-extern||g" \
				-e "s|-mindirect-branch=thunk-inline||g" \
				-e "s|-mindirect-branch=thunk||g" \
				-e "s|-mindirect-branch=none||g" \
				-e "s|-mindirect-branch=ibrs||g")
		CFLAGS_HARDENED_CXXFLAGS=$(echo "${CXXFLAGS_HARDENED_CXXFLAGS}" \
			| sed \
				-e "s|-mindirect-branch=thunk-extern||g" \
				-e "s|-mindirect-branch=thunk-inline||g" \
				-e "s|-mindirect-branch=thunk||g" \
				-e "s|-mindirect-branch=none||g" \
				-e "s|-mindirect-branch=ibrs||g")
	else
		filter-flags "-f*cf-protection=*"
		append-flags "-fcf-protection=none" # none works, branch works, return doesn't work
	fi
}

# @FUNCTION:  _cflags-hardened_print_cfi_rules
# @DESCRIPTION:
# Print rules for successful LLVM CFI
_cflags-hardened_print_cfi_rules() {
ewarn
ewarn "The rules for CFI hardening:"
ewarn
ewarn "(1) Do not CFI the Clang toolchain."
ewarn "(2) Do not CFI @system set."
ewarn "(3) You must always use Clang for LTO."
ewarn
}

# @FUNCTION:  _cflags-hardened_print_cfi_requires_clang
# @DESCRIPTION:
# Print LLVM CFI requirements
_cflags-hardened_print_cfi_requires_clang() {
eerror "CFI requires Clang.  Do the following:"
eerror "emerge -1vuDN llvm-core/llvm:${LLVM_SLOT}"
eerror "emerge -vuDN llvm-core/clang:${LLVM_SLOT}"
eerror "emerge -vuDN llvm-core/lld"
eerror "emerge -1vuDN llvm-runtimes/compiler-rt:${LLVM_SLOT}"
eerror "emerge -vuDN llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[cfi]"
eerror "emerge -1vuDN llvm-core/clang-runtime:${LLVM_SLOT}[sanitize]"
}

# @FUNCTION:  _cflags-hardened_arm_cfi
# @DESCRIPTION:
# Adjust flags for CFI
_cflags-hardened_arm_cfi() {
	[[ "${ARCH}" == "amd64" ]] || return
	[[ "${CFLAGS_HARDENED_ARM_CFI_USER}" == "0" ]] && return

	# The default setting, not ready for production
	[[ "${CFLAGS_HARDENED_ARM_CFI:-0}" == "0" ]] && return

	declare -A BTI=(
		["armv8.3-a"]="0"
		["armv8.4-a"]="0"
		["armv8.5-a"]="1"
		["armv8.6-a"]="1"
		["armv8.7-a"]="1"
		["armv8.8-a"]="1"
		["armv8.9-a"]="1"
		["armv9-a"]="1"
	)

	declare -A MTE=(
		["armv8.3-a"]="0"
		["armv8.4-a"]="0"
		["armv8.5-a"]="1"
		["armv8.6-a"]="1"
		["armv8.7-a"]="1"
		["armv8.8-a"]="1"
		["armv8.9-a"]="1"
		["armv9-a"]="1"
	)

	declare -A PAC=(
		["armv8.3-a"]="1"
		["armv8.4-a"]="1"
		["armv8.5-a"]="1"
		["armv8.6-a"]="1"
		["armv8.7-a"]="1"
		["armv8.8-a"]="1"
		["armv8.9-a"]="1"
		["armv9-a"]="1"
	)

	local march=$(echo "${CFLAGS}" \
		| grep -E "-march=armv[8-9]\.[0-9]-a" \
		| tr " " "\n" \
		| tail -n 1 \
		| sed -e "s|-march=||g")

	if [[ -z "${march}" ]] ; then
ewarn
ewarn "Add -march= to CFLAGS to enable CFI for ARCH=arm64"
ewarn
ewarn "  or"
ewarn
ewarn "change CFLAGS_HARDENED_BTI_USER, CFLAGS_HARDENED_MTE_USER,"
ewarn "CFLAGS_HARDENED_PAC_USER."
ewarn
ewarn "See cflags-hardened.eclass for details."
ewarn
	fi

	local bti="${BTI[${march}]}"
	local mte="${MTE[${march}]}"
	local pac="${PAC[${march}]}"
	[[ -z "${bti}" ]] && bti="0"
	[[ -z "${mte}" ]] && mte="0"
	[[ -z "${pac}" ]] && pac="0"

	if [[ -n "${CFLAGS_HARDENED_BTI_USER}" ]] ; then
		bti="${CFLAGS_HARDENED_BTI_USER}"
	fi

	if [[ -n "${CFLAGS_HARDENED_MTE_USER}" ]] ; then
		mte="${CFLAGS_HARDENED_MTE_USER}"
	fi

	if [[ -n "${CFLAGS_HARDENED_PAC_USER}" ]] ; then
		pac="${CFLAGS_HARDENED_PAC_USER}"
	fi

	filter-flags "-m*branch-protection=*"
	if [[ "${bti}" == "1" ]] && _cflags-hardened_fcmp "${RUSTFLAGS_HARDENED_TOLERANCE}" ">=" "1.07" ; then
	# Partial heap overflow mitigation, jop, rop
		append-flags "-mbranch-protection=pac-ret+bti"	# security-critical
	elif [[ "${pac}" == "1" ]] && _cflags-hardened_fcmp "${RUSTFLAGS_HARDENED_TOLERANCE}" ">=" "1.05" ; then
	# Partial heap overflow mitigation, jop, rop
		append-flags "-mbranch-protection=standard"	# balance
	elif [[ "${pac}" == "1" ]] && _cflags-hardened_fcmp "${RUSTFLAGS_HARDENED_TOLERANCE}" ">=" "1.05" ; then
	# Partial heap overflow mitigation, rop
		append-flags "-mbranch-protection=pac-ret"	# balance
	elif [[ "${bti}" == "1" ]] && _cflags-hardened_fcmp "${RUSTFLAGS_HARDENED_TOLERANCE}" ">=" "1.05" ; then
	# jop
		append-flags "-mbranch-protection=bti"		# performance-critical
	else
		append-flags "-mbranch-protection=none"		# performance-critical
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

	local need_cfi=0
	local need_clang=0
	if \
		_cflags-hardened_fcmp "${CFLAGS_HARDENED_TOLERANCE}" ">=" "1.15" \
			&& \
		[[ "${CFLAGS_HARDENED_CFI:-0}" == "1" ]] \
			&& \
		! _cflags-hardened_has_cet \
			&& \
		[[ "${ARCH}" == "amd64" ]] \
			&& \
		_cflags-hardened_sanitizers_compat "llvm" \
	; then
		need_cfi=1
		need_clang=1
	fi

	if tc-is-clang ; then
		need_clang=1
	fi
	if [[ "${CHROMIUM_TOOLCHAIN}" == "1" ]] ; then
		need_clang=1
	fi

	if (( ${need_clang} == 1 )) ; then
	# Get the slot
		if [[ -n "${LLVM_SLOT}" ]] ; then
			export CC="${CHOST}-clang-${LLVM_SLOT}"
			export CXX="${CHOST}-clang++-${LLVM_SLOT}"
			export CPP="${CC} -E"
		else
			export CC="${CHOST}-clang"
			export CXX="${CHOST}-clang++"
			export CPP="${CC} -E"
		fi
		export LLVM_SLOT=$(clang-major-version)

	# Avoid wrong clang used bug
		local path
		if [[ "${CHROMIUM_TOOLCHAIN}" == "1" ]] ; then
			path="/usr/share/chromium/toolchain/clang/bin"
		else
			path="/usr/lib/llvm/${LLVM_SLOT}/bin"
		fi
		PATH=$(echo "${PATH}" \
			| tr ":" "\n" \
			| sed -e "\|/usr/lib/llvm|d" \
			| sed -e "s|/opt/bin|/opt/bin\n${path}|g" \
			| tr "\n" ":")
		export LLVM_SLOT=$(clang-major-version)

	# Set CC/CXX again to avoid ccache and reproducibility problems.
		if [[ "${CHROMIUM_TOOLCHAIN}" == "1" ]] ; then
			export CC="clang"
			export CXX="clang++"
			export CPP="${CC} -E"
		else
			export CC="${CHOST}-clang-${LLVM_SLOT}"
			export CXX="${CHOST}-clang++-${LLVM_SLOT}"
			export CPP="${CC} -E"
		fi
	fi
	strip-unsupported-flags
	if ${CC} --version ; then
		:
	else
		if (( ${need_cfi} == 1 )) ; then
			_cflags-hardened_print_cfi_requires_clang
			_cflags-hardened_print_cfi_rules
		fi
eerror "Did not detect a compiler."
		die
	fi

	local s

	if tc-is-clang && [[ "${ARCH}" == "amd64" ]] ; then
		s=$(clang-major-version)
		if ! has_version "llvm-runtimes/compiler-rt-sanitizers:${s}[cfi]" ; then
ewarn
ewarn "LLVM CFI will be soon be required for the oiledmachine-overlay for"
ewarn "ARCH=amd64 without CET.  Rebuild llvm-runtimes/compiler-rt-sanitizers"
ewarn "${s} with cfi USE flag enabled."
ewarn
		fi
	fi

	if tc-is-clang && [[ "${ARCH}" == "amd64" ]] ; then
		s=$(clang-major-version)
		if ! has_version "llvm-runtimes/compiler-rt-sanitizers:${s}[lsan]" ; then
ewarn
ewarn "LSan will be soon be required for the oiledmachine-overlay for"
ewarn "ARCH=amd64 without CET.  Rebuild llvm-runtimes/compiler-rt-sanitizers"
ewarn "${s} with lsan USE flag enabled."
ewarn
		fi
	fi

	if tc-is-clang && [[ "${ARCH}" == "amd64" ]] ; then
		s=$(clang-major-version)
		if ! has_version "llvm-runtimes/compiler-rt-sanitizers:${s}[ubsan]" ; then
ewarn
ewarn "UBSan with Clang will be soon be required for the oiledmachine-overlay"
ewarn "for ARCH=amd64.  Rebuild llvm-runtimes/compiler-rt-sanitizers ${s} with"
ewarn "ubsan USE flag enabled."
ewarn
		fi
	fi

	if tc-is-clang && [[ "${ARCH}" == "arm64" ]] ; then
		s=$(clang-major-version)
		if ! has_version "llvm-runtimes/compiler-rt-sanitizers:${s}[hwasan]" ; then
ewarn
ewarn "HWASan with Clang will be soon be required for the oiledmachine-overlay"
ewarn "for ARCH=arm64.  Rebuild llvm-runtimes/compiler-rt-sanitizers ${s} with"
ewarn "hwasan USE flag enabled."
ewarn
		fi
	fi

	if tc-is-clang && [[ "${ARCH}" == "amd64" ]] ; then
		s=$(clang-major-version)
		if ! has_version "llvm-runtimes/compiler-rt-sanitizers:${s}[asan]" ; then
ewarn
ewarn "ASan with Clang will be soon be required for the oiledmachine-overlay"
ewarn "for ARCH=arm64.  Rebuild llvm-runtimes/compiler-rt-sanitizers ${s} with"
ewarn "hwasan USE flag enabled."
ewarn
		fi
	fi

	if tc-is-clang ; then
		s=$(clang-major-version)
		if ! has_version "llvm-runtimes/compiler-rt-sanitizers:${s}[gwp-asan]" ; then
ewarn
ewarn "ASan and GWP-ASan with Clang will be soon be required for the"
ewarn "oiledmachine-overlay for ARCH=arm64 and ARCH=amd64.  Rebuild"
ewarn "llvm-runtimes/compiler-rt-sanitizers ${s} with both asan and gwp-asan"
ewarn "USE flag enabled."
ewarn
		fi
	fi

	local s
	if tc-is-clang && [[ "${ARCH}" == "amd64" ]] ; then
		s=$(clang-major-version)
		if ! has_version "sys-devel/gcc:${s}[sanitize]" ; then
ewarn
ewarn "UBSan with gcc will be soon be required for the oiledmachine-overlay for"
ewarn "ARCH=amd64.  Rebuild sys-devel/gcc ${s} with sanitize USE flag enabled."
ewarn
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
|"security-critical"\
|"sensitive-data"\
|"server"\
|"untrusted-data"\
|"web-browser")\
		]] \
			&& \
		tc-is-gcc \
			&&
		ver_test "${gcc_pv}" -ge "14.2" \
			&& \
		[[ "${CFLAGS_HARDENED_FHARDENED:-1}" == "1" ]] \
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
|"language-runtime"\
|"messenger"\
|"multithreaded-confidential"\
|"multiuser-system"\
|"network"\
|"p2p"\
|"pe"\
|"security-critical"\
|"server"\
|"suid"\
|"untrusted-data"\
|"web-browser")\
			]] \
					&&
			test-flags-CC "-fstack-clash-protection" \
		; then
	# ZC, CE, EP, DoS, DT
			filter-flags "-f*stack-clash-protection"
			append-flags "-fstack-clash-protection"
			CFLAGS_HARDENED_CFLAGS+=" -fstack-clash-protection"
			CFLAGS_HARDENED_CXXFLAGS+=" -fstack-clash-protection"
		fi
		if [[ "${CFLAGS_HARDENED_LEVEL}" == "1" ]] && ! tc-enables-ssp ; then
	# ZC, CE, EP
einfo "Standard SSP hardening (>= 8 byte buffers, *alloc functions)"
			filter-flags "-f*stack-protector"
			append-flags "-fstack-protector"
			CFLAGS_HARDENED_CFLAGS+=" -fstack-protector"
			CFLAGS_HARDENED_CXXFLAGS+=" -fstack-protector"
		elif [[ "${CFLAGS_HARDENED_LEVEL}" == "2" ]] && ! tc-enables-ssp-strong ; then
	# ZC, CE, EP
einfo "Strong SSP hardening (>= 8 byte buffers, *alloc functions, functions with local arrays or local pointers)"
			filter-flags "-f*stack-protector-strong"
			append-flags "-fstack-protector-strong"
			CFLAGS_HARDENED_CFLAGS+=" -fstack-protector-strong"
			CFLAGS_HARDENED_CXXFLAGS+=" -fstack-protector-strong"
		elif [[ "${CFLAGS_HARDENED_LEVEL}" == "3" ]] && ! tc-enables-ssp-all ; then
	# ZC, CE, EP
einfo "All SSP hardening (All functions hardened)"
			filter-flags "-f*stack-protector-all"
			append-flags "-fstack-protector-all"
			CFLAGS_HARDENED_CFLAGS+=" -fstack-protector-all"
			CFLAGS_HARDENED_CXXFLAGS+=" -fstack-protector-all"
		fi

	# ZC, CE, PE, DT
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
|"language-runtime"\
|"multiuser-system"\
|"network"\
|"pe"\
|"plugin"\
|"real-time-integrity"\
|"safety-critical"\
|"scripting"\
|"security-critical"\
|"sensitive-data"\
|"untrusted-data")\
			]] \
				&&
			test-flags-CC "-fcf-protection=full" \
				&&
			_cflags-hardened_has_cet \
				&& \
			[[ "${CFLAGS_HARDENED_CF_PROTECTION:-1}" == "1" ]] \
		; then
	# ZC, CE, PE
			filter-flags "-f*cf-protection=*"
			append-flags "-fcf-protection=full"
			CFLAGS_HARDENED_CFLAGS+=" -fcf-protection=full"
			CFLAGS_HARDENED_CXXFLAGS+=" -fcf-protection=full"
		elif [[ "${ARCH}" == "arm64" ]] ; then
			_cflags-hardened_arm_cfi
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
|"security-critical") \
			]] \
		; then
	# CE, PE, DoS, DT, ID
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
	# ZC, CE, PE
		filter-flags "-Wa,--noexecstack"
		filter-flags "-Wl,-z,noexecstack"
		append-flags "-Wa,--noexecstack"
		append-ldflags "-Wl,-z,noexecstack"
		CFLAGS_HARDENED_CFLAGS+=" -Wa,--noexecstack"
		CFLAGS_HARDENED_CXXFLAGS+=" -Wa,--noexecstack"
		CFLAGS_HARDENED_LDFLAGS+=" -Wl,-z,noexecstack"
	fi
	if \
		[[ \
			"${CFLAGS_HARDENED_RETPOLINE:-1}" == "1" \
				&& \
			"${CFLAGS_HARDENED_USE_CASES}" =~ ("id"|"kernel") \
		]] \
	; then
	# Spectre V2 mitigation Linux kernel case
	# For GCC it uses
	#   General case: -mindirect-branch=thunk-extern -mindirect-branch-register
	#   vDSO case:    -mindirect-branch=thunk-inline -mindirect-branch-register
	# For Clang it uses:
	#   General case: -mretpoline-external-thunk -mindirect-branch-cs-prefix
	#   vDSO case:    -mretpoline
	# ZC, ID
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
	# Spectre V2 mitigation general case
		# -mfunction-return and -fcf-protection are mutually exclusive.

		if \
			which lscpu >/dev/null \
				&& \
			lscpu | grep -q -E -e "Spectre v2.*(Mitigation|Vulnerable)" \
		; then
			filter-flags \
				"-m*retpoline" \
				"-m*retpoline-external-thunk" \
				"-m*function-return=*" \
				"-m*indirect-branch-register" \

			if [[ -n "${CFLAGS_HARDENED_RETPOLINE_FLAVOR_USER}" ]] ; then
				CFLAGS_HARDENED_RETPOLINE_FLAVOR="${CFLAGS_HARDENED_RETPOLINE_FLAVOR_USER}"
			fi
			_cflags-hardened_append_gcc_retpoline		# ZC, ID
			_cflags-hardened_append_clang_retpoline		# ZC, ID
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
|"security-critical"\
|"safety-critical"\
|"untrusted-data")\
		]] \
				&& \
		_cflags-hardened_fcmp "${CFLAGS_HARDENED_TOLERANCE}" ">=" "2.00" \
	; then
	# Remove flag if 50% drop in performance.
	# For runtime *signed* integer overflow detection
	# ZC, CE, PE, DoS, DT, ID
		filter-flags "-f*trapv"
		append-flags "-ftrapv"
		CFLAGS_HARDENED_CFLAGS+=" -ftrapv"
		CFLAGS_HARDENED_CXXFLAGS+=" -ftrapv"
	fi

	# Do not use tc-enables-fortify-source because it doesn't do quality control.
	filter-flags \
		"-D_FORTIFY_SOURCE=*" \
		"-U_FORTIFY_SOURCE"
	append-flags "-U_FORTIFY_SOURCE"
	CFLAGS_HARDENED_CFLAGS+=" -U_FORTIFY_SOURCE"
	CFLAGS_HARDENED_CXXFLAGS+=" -U_FORTIFY_SOURCE"

	# ZC, CE, PE, DoS, DT, ID
	if [[ -n "${CFLAGS_HARDENED_FORTIFY_SOURCE}" ]] ; then
		local level="${CFLAGS_HARDENED_FORTIFY_SOURCE}"
		append-flags -D_FORTIFY_SOURCE=${level}
		CFLAGS_HARDENED_CFLAGS+=" -D_FORTIFY_SOURCE=${level}"
		CFLAGS_HARDENED_CXXFLAGS+=" -D_FORTIFY_SOURCE=${level}"
	elif \
		[[ "${CFLAGS_HARDENED_USE_CASES}" =~ ("container-runtime"|"dss"|"untrusted-data"|"security-critical"|"multiuser-system") ]] \
			&& \
		has_version ">=sys-libs/glibc-2.34" \
	; then
		if tc-is-clang && ver_test $(clang-major-version) -ge "15" ; then
			append-flags -D_FORTIFY_SOURCE=3
			CFLAGS_HARDENED_CFLAGS+=" -D_FORTIFY_SOURCE=3"
			CFLAGS_HARDENED_CXXFLAGS+=" -D_FORTIFY_SOURCE=3"
		elif tc-is-gcc && ver_test $(gcc-major-version) -ge "12" ; then
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

	# For executable packages only.
	# Do not apply to hybrid (executible with libs) packages
	if [[ "${CFLAGS_HARDENED_PIE:-0}" == "1" ]] && ! tc-enables-pie ; then
	# ZC, CE, PE, ID
		filter-flags "-fPIE" "-pie"
		append-flags "-fPIE" "-pie"
		CFLAGS_HARDENED_CFLAGS+=" -fPIE -pie"
		CFLAGS_HARDENED_CXXFLAGS+=" -fPIE -pie"
	fi

	# For library packages only
	if [[ "${CFLAGS_HARDENED_PIC:-0}" == "1" ]] ; then
	# ZC, CE, PE, ID
		filter-flags "-fPIC"
		append-flags "-fPIC"
		CFLAGS_HARDENED_CFLAGS+=" -fPIC"
		CFLAGS_HARDENED_CXXFLAGS+=" -fPIC"
	fi

	if \
		tc-is-gcc && is-flagq '-Ofast' \
			&& \
		[[ \
			"${CFLAGS_HARDENED_USE_CASES}" \
				=~ \
("dss"\
|"safety-critical") \
		]] \
	; then
	# DoS, DT
		filter-flags "-f*allow-store-data-races"
		append-flags "-fno-allow-store-data-races"
		CFLAGS_HARDENED_CFLAGS+=" -fno-allow-store-data-races"
		CFLAGS_HARDENED_CXXFLAGS+=" -fno-allow-store-data-races"
	fi

	if \
		[[ \
			"${CFLAGS_HARDENED_USE_CASES}" \
				=~ \
("dss"\
|"fp-determinism"\
|"high-precision-research") \
		]] \
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

	local sanitizers_compat=0
	if \
		tc-is-gcc \
			&& \
		_cflags-hardened_sanitizers_compat "gcc" \
	; then
		sanitizers_compat=1
	elif \
		tc-is-clang \
			&& \
		_cflags-hardened_sanitizers_compat "llvm" \
	; then
		sanitizers_compat=1
	fi

	if [[ "${CFLAGS_HARDENED_SANITIZERS_DEACTIVATE}" == 0 ]] ; then
		sanitizers_compat=0
	fi

	filter-flags "-f*sanitize=*"
	if [[ -n "${CFLAGS_HARDENED_SANITIZERS}" ]] && (( ${sanitizers_compat} == 1 )) ; then
		local l="${CFLAGS_HARDENED_SANITIZERS}"
		declare -A GCC_M=(
			["shift"]="ubsan"
			["shift-exponent"]="ubsan"
			["shift-base"]="ubsan"
			["integer-divide-by-zero"]="ubsan"
			["unreachable"]="ubsan"
			["vla-bound"]="ubsan"
			["null"]="ubsan"
			["return"]="ubsan"
			["signed-integer-overflow"]="ubsan"
			["bounds"]="ubsan"
			["bounds-strict"]="ubsan"
			["alignment"]="ubsan"
			["object-size"]="ubsan"
			["float-divide-by-zero"]="ubsan"
			["float-cast-overflow"]="ubsan"
			["nonnull-attribute"]="ubsan"
			["returns-nonnull-attribute"]="ubsan"
			["bool"]="ubsan"
			["enum"]="ubsan"
			["vptr"]="ubsan"
			["pointer-overflow"]="ubsan"
			["builtin"]="ubsan"

			["address"]="asan"
			["hwaddress"]="hwasan"
			["kernel-address"]="asan"
			["kernel-hwaddress"]="hwasan"
			["leak"]="lsan"
			["pointer-compare"]="asan"
			["pointer-subtract"]="asan"
			["shadow-call-stack"]="shadowcallstack"
			["thread"]="tsan"
			["undefined"]="ubsan"
		)
		declare -A CLANG_M=(
			["alignment"]="ubsan"
			["bool"]="ubsan"
			["builtin"]="ubsan"
			["bounds"]="ubsan"
			["array-bounds"]="ubsan"
			["local-bounds"]="ubsan"
			["undefined"]="ubsan"
			["enum"]="ubsan"
			["float-cast-overflow"]="ubsan"
			["float-divide-by-zero"]="ubsan"
			["function"]="ubsan"
			["implicit-unsigned-integer-truncation"]="ubsan"
			["implicit-signed-integer-truncation"]="ubsan"
			["implicit-integer-sign-change"]="ubsan"
			["integer-divide-by-zero"]="ubsan"
			["implicit-bitfield-conversion"]="ubsan"
			["nonnull-attribute"]="ubsan"
			["null"]="ubsan"
			["nullability-arg"]="ubsan"
			["nullability-assign"]="ubsan"
			["nullability-return"]="ubsan"
			["objc-cast"]="ubsan"
			["object-size"]="ubsan"
			["pointer-overflow"]="ubsan"
			["return"]="ubsan"
			["returns-nonnull-attribute"]="ubsan"
			["shift"]="ubsan"
			["shift-base"]="ubsan"
			["shift-exponent"]="ubsan"
			["unsigned-shift-base"]="ubsan"
			["signed-integer-overflow"]="ubsan"
			["unreachable"]="ubsan"
			["unsigned-integer-overflow"]="ubsan"
			["vla-bound"]="ubsan"
			["vptr"]="ubsan"

			["undefined"]="ubsan"
			["undefined-trap"]="ubsan"
			["implicit-integer-truncation"]="ubsan"
			["implicit-integer-arithmetic-value-change"]="ubsan"
			["implicit-integer-conversion"]="ubsan"
			["implicit-conversion"]="ubsan"
			["integer"]="ubsan"
			["nullability"]="ubsan"

			["address"]="asan"
			["cfi"]="cfi"
			["dataflow"]="dfsan"
			["hwaddress"]="hwasan"
			["leak"]="lsan"
			["memory"]="msan"
			["safe-stack"]="safestack"
			["shadowcallstack"]="shadowcallstack"
			["realtime"]="rtsan"
			["thread"]="tsan"
			["type"]="tysan"
		)

		declare -A SLOWDOWN=(
			["asan"]="4.0"
			["cfi"]="2.0"
			["dfsan"]="30.0"
			["gwp-asan"]="1.15"
			["hwasan"]="2.0"
			["lsan"]="1.5"
			["msan"]="11.0"
			["rtsan"]="1.05" # placeholder
			["safestack"]="1.20"
			["shadowcallstack"]="1.15"
			["tsan"]="16.0"
			["ubsan"]="2.0"
			["tysan"]="1.05" # placeholder
		)

		unset added
		declare -A added=(
	# CE = Code Execution
	# DoS = Denial of Service
	# DT = Data Tampering
	# ID = Information Disclosure
	# PE = Privilege Escalation
	# ZC = Zero Click Attack
	#		Sanitizer			Type of attacks it protects against
			["asan"]="0"			# ZC, CE, PE, DoS, DT, ID
			["cfi"]="0"			# ZC, CE, PE
			["dfsan"]="0"			# DT, ID
			["gwp-asan"]="0"		# ZC, CE, PE, DoS, DT, ID
			["hwasan"]="0"			# ZC, CE, PE, DoS, DT, ID
			["lsan"]="0"			# DoS
			["msan"]="0"			# DoS, ID
			["rtsan"]="0"
			["safestack"]="0"		# ZC, CE, PE
			["shadowcallstack"]="0"		# ZC, CE, PE
			["tsan"]="0"			# ZC, CE, PE, DoS, DT
			["ubsan"]="0"			# ZC, CE, PE, DoS, DT, ID
			["tysan"]="0"			# ZC, CE, PE, DoS, DT, ID
		)
		local asan=0

		if tc-is-gcc ; then
			if [[ -n "${CC}" ]] ; then
				GCC_SLOT=$(gcc-major-version)
			else
				CC=$(tc-getCC)
				CXX=$(tc-getCXX)
				GCC_SLOT=$(gcc-major-version)
			fi
		fi
		local L=$(echo "${l}")
		local x
		for x in ${L[@]} ; do
			local module
			if tc-is-clang ; then
				module=${CLANG_M[${x}]}
			else
				module=${GCC_M[${x}]}
			fi
			if [[ -z "${module}" ]] ; then
ewarn "Skipping custom sanitizer -fsanitize=${x} for CC=${CC}"
				continue
			fi
			local slowdown=${SLOWDOWN[${module}]}

			if \
				tc-is-gcc \
					&&
				! has_version "sys-devel/gcc:${GCC_SLOT}[sanitize]" \
					&& \
				[[ ${added[${module}]} == "0" ]] \
			; then
eerror "Missing ${module} sanitizer.  Do the following:"
eerror "emerge -1vuDN sys-devel/gcc:${GCC_SLOT}[sanitize]"
			elif \
				tc-is-clang \
					&& \
				! has_version "llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[${module}]" \
					&& \
				[[ ${added[${module}]} == "0" ]] \
			; then
eerror "Missing ${module} sanitizer.  Do the following:"
eerror "emerge -1vuDN llvm-runtimes/compiler-rt:${LLVM_SLOT}"
eerror "emerge -vuDN llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[${module}]"
eerror "emerge -1vuDN llvm-core/clang-runtime:${LLVM_SLOT}[sanitize]"
				die
			fi
			local skip=0
			if \
				_cflags-hardened_fcmp "${CFLAGS_HARDENED_TOLERANCE}" ">=" "${slowdown}" \
					&& \
				[[ ${added[${module}]} == "0" ]] \
			; then
				if [[ "${x}" =~ "address" ]] && (( ${asan} == 1 )) ; then
					skip=1
				elif [[ "${x}" == "hwaddress" ]] && _cflags-hardened_has_mte && [[ "${ARCH}" == "arm64" ]] ; then
					append-flags "-fsanitize=${x}"
					append-ldflags "-fsanitize=${x}"
					CFLAGS_HARDENED_CFLAGS+=" -fsanitize=${x}"
					CFLAGS_HARDENED_CXXFLAGS+=" -fsanitize=${x}"
					CFLAGS_HARDENED_LDFLAGS+=" -fsanitize=${x}"
					asan=1
				elif [[ "${x}" == "hwaddress" ]] ; then
					skip=1
				elif [[ "${x}" == "address" ]] ; then
					append-flags "-fsanitize=${x}"
					append-ldflags "-fsanitize=${x}"
					CFLAGS_HARDENED_CFLAGS+=" -fsanitize=${x}"
					CFLAGS_HARDENED_CXXFLAGS+=" -fsanitize=${x}"
					CFLAGS_HARDENED_LDFLAGS+=" -fsanitize=${x}"
					asan=1
				elif [[ "${x}" == "cfi" ]] && ! _cflags-hardened_has_cet && [[ "${ARCH}" == "amd64" ]] && tc-is-clang ; then
					append-flags "-fsanitize=${x}"
					append-ldflags "-fsanitize=${x}"
					CFLAGS_HARDENED_CFLAGS+=" -fsanitize=${x}"
					CFLAGS_HARDENED_CXXFLAGS+=" -fsanitize=${x}"
					CFLAGS_HARDENED_LDFLAGS+=" -fsanitize=${x}"

					filter-flags "-flto*"
					append-flags "-flto=thin"
					append-ldflags "-flto=thin"
					CFLAGS_HARDENED_CFLAGS+=" -flto=thin"
					CFLAGS_HARDENED_CXXFLAGS+=" -flto=thin"
					CFLAGS_HARDENED_LDFLAGS+=" -flto=thin"
					filter-flags "-fuse-ld=*"
					append-ldflags "-fuse-ld=lld"
					CFLAGS_HARDENED_LDFLAGS+=" -fuse-ld=lld"
				elif [[ "${x}" == "cfi" ]] ; then
					skip=1
				else
					append-flags "-fsanitize=${x}"
					append-ldflags "-fsanitize=${x}"
					CFLAGS_HARDENED_CFLAGS+=" -fsanitize=${x}"
					CFLAGS_HARDENED_CXXFLAGS+=" -fsanitize=${x}"
					CFLAGS_HARDENED_LDFLAGS+=" -fsanitize=${x}"
					if [[ "${x}" == "undefined" || "${x}" == "signed-integer-overflow" ]] ; then
einfo "Deduping signed integer overflow check"
						filter-flags "-f*trapv"
						CFLAGS_HARDENED_CFLAGS=$(echo "${CFLAGS_HARDENED_CFLAGS}" \
							| sed -r -e "s#-f(-no|)trapv##g")
						CFLAGS_HARDENED_CXXFLAGS=$(echo "${CXXFLAGS_HARDENED_CFLAGS}" \
							| sed -r -e "s#-f(-no|)trapv##g")
					fi
				fi

				if (( ${skip} == 0 )) ; then
	# We need to statically link sanitizers to avoid breaking the @system
	# set.
					if tc-is-clang ; then
						append-flags "-static-libsan"
						append-ldflags "-static-libsan"
						CFLAGS_HARDENED_CFLAGS+=" -static-libsan"
						CFLAGS_HARDENED_CXXFLAGS+=" -static-libsan"
						CFLAGS_HARDENED_LDFLAGS+=" -static-libsan"
					elif tc-is-gcc && [[ "${module}" == "asan" ]] ; then
						append-flags "-Wl,-static-libasan"
						CFLAGS_HARDENED_CFLAGS+=" -Wl,-static-libasan"
					elif tc-is-gcc && [[ "${module}" == "hwasan" ]] ; then
						append-flags "-Wl,-static-libhwasan"
						CFLAGS_HARDENED_CFLAGS+=" -Wl,-static-libhwasan"
					elif tc-is-gcc && [[ "${module}" == "lsan" ]] ; then
						append-flags "-Wl,-static-liblsan"
						CFLAGS_HARDENED_CFLAGS+=" -Wl,-static-liblsan"
					elif tc-is-gcc && [[ "${module}" == "tsan" ]] ; then
						append-flags "-Wl,-static-libtsan"
						CFLAGS_HARDENED_CFLAGS+=" -Wl,-static-libtsan"
					elif tc-is-gcc && [[ "${module}" == "ubsan" ]] ; then
						append-flags "-Wl,-static-libubsan"
						CFLAGS_HARDENED_CFLAGS+=" -Wl,-static-libubsan"
					fi

					added[${module}]="1"
einfo "Added ${x} from ${module} sanitizer"
				fi
			fi
		done

		if (( ${asan} == 1 )) ; then
einfo "Deduping stack overflow check"
			filter-flags "-f*stack-protector*"
			CFLAGS_HARDENED_CFLAGS=$(echo "${CFLAGS_HARDENED_CFLAGS}" \
				| sed \
					-r \
					-e "s#-f(no-|)stack-protector-all##g" \
					-e "s#-f(no-|)stack-protector-strong##g" \
					-e "s#-f(no-|)stack-protector##g")
			CFLAGS_HARDENED_CXXFLAGS=$(echo "${CXXFLAGS_HARDENED_CFLAGS}" \
				| sed \
					-r \
					-e "s#-f(no-|)stack-protector-all##g" \
					-e "s#-f(no-|)stack-protector-strong##g" \
					-e "s#-f(no-|)stack-protector##g")
	# Disable the compiler default.
			append-flags "-fno-stack-protector"
			CFLAGS_HARDENED_CFLAGS+=" -fno-stack-protector"
			CFLAGS_HARDENED_CXXFLAGS+=" -fno-stack-protector"
		fi
	fi

	filter-flags "-f*sanitize-recover"
	if [[ "${CFLAGS}" =~ "-fsanitize=" ]] ; then
	# Force exit before data/execution integrity is compromised.
		append-flags "-fno-sanitize-recover"
		CFLAGS_HARDENED_CFLAGS+=" -fno-sanitize-recover"
		CFLAGS_HARDENED_CXXFLAGS+=" -fno-sanitize-recover"
	fi

	local s
	if tc-is-gcc ; then
		s=$(gcc-major-version)
		if ! has_version "sys-devel/gcc:${s}[vtv]" ; then
ewarn "vtable hardening is required for the oiledmachine overlay for C++.  Rebuild gcc ${s} with vtv USE flag enabled."
		fi
	fi

	if [[ "${CFLAGS_HARDENED_VTABLE_VERIFY:-0}" == "1" ]] && tc-is-gcc && ver_test $(gcc-version) -ge "4.9" ; then
	# The package manager is not designed to track updates which makes it a
	# maintenance nightmare.  vtv can only be applied to c++ to the
	# following cases to simplify maintenance.
	# (1) app only packages.
	# (2) hybrid packages (app+lib) without headers.
		if ! has_version "sys-devel/gcc:${s}[vtv]" ; then
ewarn "Skipping vtable hardening.  Update gcc and rebuild ${CATEGORY}/${PN}-${PV} again."
		elif \
			has_version "sys-devel/gcc:${s}[vtv]" \
				&& \
			[[ "${CFLAGS_HARDENED_USE_CASES}" =~ ("dss"|"game-engine"|"hypervisor"|"kernel"|"modular-app"|"network"|"safety-critical"|"security-critical"|"web-browsers") ]] \
		; then
	# ZC, CE, PE
			filter-flags "-f*vtable-verify=*"
			append-cxxflags "-fvtable-verify=std"
			CFLAGS_HARDENED_CXXFLAGS+=" -fvtable-verify=std"
		fi
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
	_cflags-hardened_proximate_opt_level
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
