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
# 1 = standard (recommended for heavy packages)
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
	if [[ "${CFLAGS_HARDENED_LEVEL}" == "2" ]] && tc-check-min_ver gcc "14.2" ; then
einfo "Appending -fhardened"
einfo "Strong SSP hardending (>= 8 byte buffers, *alloc functions, functions with local arrays or local pointers)"
		filter-flags \
			-fstack-clash-protection \
			-fstack-protector \
			-fstack-protector-strong \
			-fstack-protector-all \
			-D_FORTIFY_SOURCE=1 \
			-D_FORTIFY_SOURCE=2 \
			-D_FORTIFY_SOURCE=3 \
			-Wl,-z,relro \
			-Wl,-z,now \
			-fcf-protection=full
		filter-flags -fhardened
		append-cflags $(test-flags-CC -fhardened)
		append-cxxflags $(test-flags-CXX -fhardened)
		if [[ "${CFLAGS}" =~ "-O0" ]] ; then
			CFLAGS_HARDENED_CFLAGS+=" -O1"
		fi
		if [[ "${CXXFLAGS}" =~ "-O0" ]] ; then
			CFLAGS_HARDENED_CFLAGS+=" -O1"
		fi
		CFLAGS_HARDENED_CFLAGS+=" -fhardened"
		CFLAGS_HARDENED_CXXFLAGS+=" -fhardened"
		CFLAGS_HARDENED_LDFLAGS=""
	else
		replace-flags '-O0' '-O1'
		if (( \
			   ${CFLAGS_HARDENED_DAEMON:-0} == 1 \
			|| ${CFLAGS_HARDENED_SERVER:-0} == 1 \
			|| ${CFLAGS_HARDENED_SUID:-0} == 1 \
		)) ; then
			filter-flags -fstack-clash-protection
			append-cflags $(test-flags-CC -fstack-clash-protection)
			append-cxxflags $(test-flags-CXX -fstack-clash-protection)
		fi
		if [[ "${CFLAGS}" =~ "-O0" ]] ; then
			CFLAGS_HARDENED_CFLAGS+=" -O1"
		fi
		if [[ "${CXXFLAGS}" =~ "-O0" ]] ; then
			CFLAGS_HARDENED_CFLAGS+=" -O1"
		fi
		CFLAGS_HARDENED_CFLAGS+=" -fstack-clash-protection"
		CFLAGS_HARDENED_CXXFLAGS+=" -fstack-clash-protection"
		if [[ "${CFLAGS_HARDENED_LEVEL}" == "1" ]] && ! tc-enables-ssp ; then
einfo "Standard SSP hardending (>= 8 byte buffers, *alloc functions)"
			filter-flags -fstack-protector
			append-cflags $(test-flags-CC -fstack-protector)
			append-cxxflags $(test-flags-CXX -fstack-protector)
			CFLAGS_HARDENED_CFLAGS+=" -fstack-protector"
			CFLAGS_HARDENED_CXXFLAGS+=" -fstack-protector"
		elif [[ "${CFLAGS_HARDENED_LEVEL}" == "2" ]] && ! tc-enables-ssp-strong ; then
einfo "Strong SSP hardending (>= 8 byte buffers, *alloc functions, functions with local arrays or local pointers)"
			filter-flags -fstack-protector-strong
			append-cflags $(test-flags-CC -fstack-protector-strong)
			append-cxxflags $(test-flags-CXX -fstack-protector-strong)
			CFLAGS_HARDENED_CFLAGS+=" -fstack-protector-strong"
			CFLAGS_HARDENED_CXXFLAGS+=" -fstack-protector-strong"
		elif [[ "${CFLAGS_HARDENED_LEVEL}" == "3" ]] && ! tc-enables-ssp-all ; then
einfo "All SSP hardending (All functions hardened)"
			filter-flags -fstack-protector-all
			append-cflags $(test-flags-CC -fstack-protector-all)
			append-cxxflags $(test-flags-CXX -fstack-protector-all)
			CFLAGS_HARDENED_CFLAGS+=" -fstack-protector-all"
			CFLAGS_HARDENED_CXXFLAGS+=" -fstack-protector-all"
		fi
		if ! tc-enables-fortify-source ; then
			filter-flags \
				-D_FORTIFY_SOURCE=1 \
				-D_FORTIFY_SOURCE=2 \
				-D_FORTIFY_SOURCE=3
			append-cflags $(test-flags-CC -D_FORTIFY_SOURCE=2)
			append-cxxflags $(test-flags-CXX -D_FORTIFY_SOURCE=2)
			CFLAGS_HARDENED_CFLAGS+=" -D_FORTIFY_SOURCE=2"
			CFLAGS_HARDENED_CXXFLAGS+=" -D_FORTIFY_SOURCE=2"
		fi
		append-ldflags -Wl,-z,relro
		append-ldflags -Wl,-z,now
		CFLAGS_HARDENED_LDFLAGS+=" -Wl,-z,relro"
		CFLAGS_HARDENED_LDFLAGS+=" -Wl,-z,now"
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

fi
