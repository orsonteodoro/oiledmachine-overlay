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
# Add additional flags to secure packages based on typical USE cases.
# Valid values:
# Acceptable values: 1, 0, unset
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
	if [[ -z "${RUSTC}" ]] ; then
eerror "QA:  RUSTC is not initialized.  Did you rust_pkg_setup?"
		die
	fi
	local rust_pv=$("${RUSTC}" --version | cut -f 2 -d " ")

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

	if [[ -n "${RUSTFLAGS_HARDENED_USER_LEVEL}" ]] ; then
		RUSTFLAGS_HARDENED_LEVEL="${RUSTFLAGS_HARDENED_USER_LEVEL}"
	fi

	# Not production ready only available on nightly
	# For status see https://github.com/rust-lang/rust/blob/master/src/doc/rustc/src/exploit-mitigations.md?plain=1#L41
	if true ; then
		: # Broken
	elif ver_test "${rust_pv}" -ge "1.58.0" ; then
		if [[ "${RUSTFLAGS_HARDENED_LEVEL}" == "3" ]] ; then
	#		RUSTFLAGS+=" -C stack-protector=all"
		elif [[ "${RUSTFLAGS_HARDENED_LEVEL}" == "2" ]] ; then
	#		RUSTFLAGS+=" -C stack-protector=strong"
		elif [[ "${RUSTFLAGS_HARDENED_LEVEL}" == "1" ]] ; then
	#		RUSTFLAGS+=" -C stack-protector=basic"
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
				RUSTFLAGS+=" -C target-feature=+retpoline"
			fi
		fi
	fi

	if is-flagq "-O0" ; then
		replace-flags "-O0" "-O1"
		RUSTFLAGS+=" -C opt-level=1"
		RUSTFLAGS+=" -C link-arg=-D_FORTIFY_SOURCE=2"
	fi
	RUSTFLAGS+=" -C link-arg=-D_FORTIFY_SOURCE=2"

	if [[ \
		"${RUSTFLAGS_HARDENED_TRAPV:-1}" == "1" \
			&& \
		"${RUSTFLAGS_HARDENED_USE_CASES}" =~ \
("dss"\
|"network"\
|"secure-critical"\
|"safety-critical"\
|"untrusted-data")\
	]] ; then
	# Remove flag if 50% drop in performance.
	# For runtime *signed* integer overflow detection
		RUSTFLAGS+=" -C overflow-checks=on"
	fi

	RUSTFLAGS+=" -C link-arg=-fstack-clash-protection"

	if \
		[[ \
			"${RUSTFLAGS_HARDENED_NOEXECSTACK:-1}" == "1" \
				&& \
			"${RUSTFLAGS_HARDENED_USE_CASES}" \
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
	# CE, DT/ID
		RUSTFLAGS+=" -C link-arg=-znoexecstack"
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

	RUSTFLAGS+=" -C link-arg=-z -C link-arg=relro"
	RUSTFLAGS+=" -C link-arg=-z -C link-arg=now"

	if [[ "${RUSTFLAGS_HARDENED_USE_CASES}" =~ ("dss"|"fp-determinism"|"high-precision-research") ]] ; then
		if is-flagq "-Ofast" ; then
			replace-flags "-Ofast" "-O3"
			RUSTFLAGS+=" -C opt-level=3"
		fi
		RUSTFLAGS+=" -C float-opts=none"
		RUSTFLAGS+=" -C target-feature=+strict-fp"
		RUSTFLAGS+=" -C target-feature=-fast-math"
		RUSTFLAGS+=" -C codegen-units=1"
	fi
	export RUSTFLAGS
}

fi
