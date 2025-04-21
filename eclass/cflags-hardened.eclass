# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cflags-hardened.eclass
# @MAINTAINER:
# orsonteodoro@hotmail.com
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: Additional functions to simplify hardening
# @DESCRIPTION:
# This eclass can be used to easily deploy harden flags for network/server
# packages.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_CFLAGS_HARDEN_ECLASS} ]]; then
_CFLAGS_HARDEND_ECLASS=1

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

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_NX_VERSUS_CF
# @DESCRIPTION:
# (Draft... still undergoing reasearch)
# Choose either nx bit protection or cf protection.  They may be
# mutually exclusive.  Using cf may require trampolines (executable stack) but
# -Wl,-z,noexecstack will cause trampolines to be disabled.  Executable stack
# is required by interpreters.
#
# Acceptable values:
#
#   nx   - For LDFLAGS+=-Wl,-z,noexecstack   (cannot be used with interpreters (e.g. JavaScript), nested functions with trampolines)
#   cf   - For LDFLAGS+=-fcf-protection=full
#   none - Do not apply any
#   both - Apply both
#
# See also https://wiki.gentoo.org/wiki/Hardened/GNU_stack_quickstart#Causes_of_executable_stack_markings
#
# Chromium will use -z,noexecstack by default but not -fcf-protection=full.  Use
# cf if you need to run interpreter or trampoline but cannot disable executable
# stack.
#
# The -fhardened is missing -Wl,-z,noexecstack.
#
CFLAGS_HARDENED_NX_VERSUS_CF=${CFLAGS_HARDENED_NX_VERSUS_CF:-"nx"}

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_APPEND_GOFLAGS
# @DESCRIPTION:
# Append flags to CGO_CFLAGS, GO_CXXFLAGS, CGO_LDFLAGS when
# cflags-hardened_append is called.
# Acceptable values: 1, 0, unset

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_DISABLED
# @DESCRIPTION:
# A user variable to disable hardening flags.
#
# Example contents of /etc/make.conf:
# CFLAGS_HARDENED_DISABLED=1
#

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_SUID
# Add additional flags to secure packages with IUSE=suid
# Acceptable values: 1, 0, unset

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_DAEMON
# Add additional flags to secure daemons package
# Acceptable values: 1, 0, unset

# @ECLASS_VARIABLE:  CFLAGS_HARDENED_SERVER
# Add additional flags to secure server packages
# Acceptable values: 1, 0, unset

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
	CFLAGS_HARDENED_CFLAGS=""
	CFLAGS_HARDENED_CXXFLAGS=""
	CFLAGS_HARDENED_LDFLAGS=""
	if [[ "${CFLAGS_HARDENED_LEVEL}" == "2" && "${CFLAGS_HARDENED_NX_VERSUS_CF}" =~ ("both"|"cf") ]] && tc-check-min_ver gcc "14.2" ; then
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
		if [[ "${CFLAGS_HARDENED_NX_VERSUS_CF}" =~ "both" ]] ; then
			filter-flags "-Wa,--noexecstack"
			filter-flags "-Wl,-z,noexecstack"
			append-flags "-Wa,--noexecstack"
			append-ldflags "-Wl,-z,noexecstack"
			CFLAGS_HARDENED_LDFLAGS+=" -Wl,-z,noexecstack"
		fi
	else
		replace-flags "-O0" "-O1"
		if [[ "${CFLAGS}" =~ "-O0" ]] ; then
			CFLAGS_HARDENED_CFLAGS+=" -O1"
		fi
		if [[ "${CXXFLAGS}" =~ "-O0" ]] ; then
			CFLAGS_HARDENED_CFLAGS+=" -O1"
		fi
		if \
			(( \
				   ${CFLAGS_HARDENED_DAEMON:-0} == 1 \
				|| ${CFLAGS_HARDENED_SERVER:-0} == 1 \
				|| ${CFLAGS_HARDENED_SUID:-0}   == 1 \
			)) \
					&& \
			test-flags-CC "-fstack-clash-protection" \
		; then
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
		if [[ "${CFLAGS_HARDENED_NX_VERSUS_CF}" =~ ("both"|"cf") ]] && test-flags-CC "-fcf-protection=full" ; then
			filter-flags "-fcf-protection=*"
			append-flags "-fcf-protection=full"
			CFLAGS_HARDENED_CFLAGS+=" -fcf-protection=full"
			CFLAGS_HARDENED_CXXFLAGS+=" -fcf-protection=full"
		fi
		if [[ "${CFLAGS_HARDENED_NX_VERSUS_CF}" =~ ("both"|"nx") ]] ; then
			filter-flags "-Wa,--noexecstack"
			filter-flags "-Wl,-z,noexecstack"
			append-flags "-Wa,--noexecstack"
			append-ldflags "-Wl,-z,noexecstack"
			CFLAGS_HARDENED_LDFLAGS+=" -Wl,-z,noexecstack"
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
