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
# 2 = strong (recommened for light packages, security-critical packages, default)
#     Use cases:
#     Used by Chromium debug builds
#     Used by linux kernel default for 20% of functions
#     For DSS builds if test suite fails for strongest but passes for strong
# 3 = strongest (for legacy or EOL packages, or safety-critical packages or critical infrastructure)
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
# crypto
# daemon
# dss (e.g. cryptocurrency, finance)
# extension
# execution-integrity
# fp-determinism
# high-precision-research
# hypervisor
# jit
# kernel
# login (sudo)
# messenger
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

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_TOLERANCE
# @DESCRIPTION:
# The default performance impact to trigger enablement of expensive mitigations.
# Acceptable values: 1.0 to 16.0 (based on table below), unset
# Default: 1.20 (Similar to -O1 best case without mitigations)
# For speed set values closer to 1.
# For accuracy/integrity set values closer to 16.
RUSTFLAGS_HARDENED_TOLERANCE=${RUSTFLAGS_HARDENED_TOLERANCE:-"1.20"}

# Estimates:
# Flag						Performance as a normalized decimal multiple
# No mitigation						   1
# -C link-arg=-D_FORTIFY_SOURCE=2			1.01
# -C link-arg=-D_FORTIFY_SOURCE=3			1.02
# -C overflow-checks=on					1.01 -  1.20
# -C soft-float						2.00 -  10.00
# -Z stack-protector=all				1.05 -  1.10
# -Z stack-protector=strong				1.02 -  1.05
# -Z stack-protector=basic				1.01 -  1.03
# -C target-feature=+bti				1.00 -  1.05
# -C target-feature=+pac-ret				1.01 -  1.05
# -C target-feature=+pac-ret,+bti			1.02 -  1.07
# -C target-feature=+retpoline				1.01 -  1.20
# -Zsanitizer=address					1.50 -  4.0 (ASan); 1.01 - 1.1 (GWP-ASan)
# -Zsanitizer=cfi					1.10 -  2.0
# -Zsanitizer=hwaddress					1.15 -  1.50 (ARM64)
# -Zsanitizer=leak					1.05 -  1.5
# -Zsanitizer=memory					3.00 - 11.00
# -Zsanitizer=safestack					1.01 -  1.20
# -Zsanitizer=shadow-call-stack				1.01 -  1.15
# -Zsanitizer=thread					4.00 - 16.00

# Setting to 4.0 will enable ASan and other faster sanitizers.
# Setting to 15.0 will enable TSan and other faster sanitizers.

# For example, TSan is about 4-16x slower compared to the unmitigated build.

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_TOLERANCE_USER
# @DESCRIPTION:
# A user override for RUSTFLAGS_HARDENED_TOLERANCE.
# Acceptable values: 1.0-16, unset
# Default: unset
# It is assumed that these don't stack and are mutually exclusive.
#
# What value means is that one can tune the package for either low latency or
# more accurate calcuation by controlling the worst case limits on a per
# package basis.
# (ex. stock trading versus accurate finance model calculated predictions)
#

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_FORTIFY_SOURCE
# @DESCRIPTION:
# Allow to override the _FORTIFY_SOURCE level.
# Acceptable values:
# 0 - package doesn't use mem*, str* functions from glibc
# 1 - compile time checks only
# 2 - general compile + runtime protection
# 3 - maximum compile + runtime protection

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_SANITIZERS
# @DESCRIPTION:
# A space delimited list of allowed sanitizer options.

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_SANITIZERS_COMPAT
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
#   RUSTFLAGS_HARDENED_SANITIZERS_COMPAT=( "gcc" "llvm" )
#


# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_BTI_USER
# @USER_VARIABLE
# @DESCRIPTION:
# User override to force enable BTI (Branch Target Identification).
# armv9*-r or armv8*-r users should set this if they have the feature.
# Valid values: 1, 0, unset

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_MTE_USER
# @USER_VARIABLE
# @DESCRIPTION:
# User override to force enable MTE (Memory Tag Extention).
# armv9*-r or armv8*-r users should set this if they have the feature.
# Valid values: 1, 0, unset

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_PAC_USER
# @USER_VARIABLE
# @DESCRIPTION:
# User override to force enable PAC (Pointer Authentication Code).
# armv9*-r or armv8*-r users should set this if they have the feature.
# Valid values: 1, 0, unset

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_ARM_CFI_USER
# @USER_VARIABLE
# @DESCRIPTION:
# Allow build to be built with JOP, ROP mitigations
# Valid values: 1, 0, unset

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_SANITIZERS_DEACTIVATE
# @USER_VARIABLE
# @DESCRIPTION:
# Enable or disable sanitizers for a package.  To be used on a per-package basis.
# Acceptable values: 1, 0, unset


# @FUNCTION: _rustflags-hardened_sanitizers_compat
# @DESCRIPTION:
# Check the sanitizer compatibility
_rustflags-hardened_sanitizers_compat() {
	local needed_compiler="${1}"
	local impl
	for impl in ${RUSTFLAGS_HARDENED_SANITIZERS_COMPAT[@]} ; do
		if [[ "${impl}" == "${needed_compiler}" ]] ; then
			return 0
		fi
	done
	return 1
}

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

_rustflags-hardened_print_cfi_rules() {
ewarn
ewarn "The rules for CFI hardening:"
ewarn
ewarn "(1) Do not CFI the Clang toolchain."
ewarn "(2) Do not CFI @system set."
ewarn "(3) You must always use Clang for LTO."
ewarn
}

_rustflags-hardened_print_cfi_requires_clang() {
eerror "CFI requires Clang.  Do the following:"
eerror "emerge -1vuDN llvm-core/llvm:${LLVM_SLOT}"
eerror "emerge -vuDN llvm-core/clang:${LLVM_SLOT}"
eerror "emerge -vuDN llvm-core/lld"
eerror "emerge -1vuDN llvm-runtimes/compiler-rt:${LLVM_SLOT}"
eerror "emerge -vuDN llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[cfi]"
eerror "emerge -1vuDN llvm-core/clang-runtime:${LLVM_SLOT}[sanitize]"
}

# @FUNCTION: _rustflags-hardened_proximate_opt_level
# @DESCRIPTION:
# Convert the tolerance level to -Oflag level
_rustflags-hardened_proximate_opt_level() {
	if _rustflags-hardened_fcmp "${RUSTFLAGS_HARDENED_TOLERANCE}" ">" "1.80" ; then
einfo "RUSTFLAGS_HARDENED_TOLERANCE:  ${RUSTFLAGS_HARDENED_TOLERANCE} (similar to -O0 with heavy thrashing)"
	elif _rustflags-hardened_fcmp "${RUSTFLAGS_HARDENED_TOLERANCE}" ">=" "1.4" ; then
einfo "RUSTFLAGS_HARDENED_TOLERANCE:  ${RUSTFLAGS_HARDENED_TOLERANCE} (similar to -O0 with light thrashing)"
	elif _rustflags-hardened_fcmp "${RUSTFLAGS_HARDENED_TOLERANCE}" ">=" "1.35" ; then
einfo "RUSTFLAGS_HARDENED_TOLERANCE:  ${RUSTFLAGS_HARDENED_TOLERANCE} (similar to -O1)"
	elif _rustflags-hardened_fcmp "${RUSTFLAGS_HARDENED_TOLERANCE}" ">=" "1.250" ; then
einfo "RUSTFLAGS_HARDENED_TOLERANCE:  ${RUSTFLAGS_HARDENED_TOLERANCE} (similar to -Os)"
	elif _rustflags-hardened_fcmp "${RUSTFLAGS_HARDENED_TOLERANCE}" ">=" "1.10" ; then
einfo "RUSTFLAGS_HARDENED_TOLERANCE:  ${RUSTFLAGS_HARDENED_TOLERANCE} (similar to -O2)"
	elif _rustflags-hardened_fcmp "${RUSTFLAGS_HARDENED_TOLERANCE}" ">=" "1.05" ; then
einfo "RUSTFLAGS_HARDENED_TOLERANCE:  ${RUSTFLAGS_HARDENED_TOLERANCE} (similar to -O3)"
	else
einfo "RUSTFLAGS_HARDENED_TOLERANCE:  ${RUSTFLAGS_HARDENED_TOLERANCE} (similar to -Ofast)"
	fi
einfo
einfo "The RUSTFLAGS_HARDENED_TOLERANCE_USER can override this.  See"
einfo "rustflags-hardened.eclass for details."
einfo
}

# @FUNCTION: _rustflags-hardened_has_mte
# @DESCRIPTION:
# Check if CPU supports MTE (Memory Tagging Extension)
_rustflags-hardened_has_mte() {
	local mte=0
	if grep "Features" "/proc/cpuinfo" | grep -q -e "mte" ; then
		mte=1
	fi
	return ${mte}
}


# @FUNCTION: _rustflags-hardened_has_pauth
# @DESCRIPTION:
# Check if CPU supports PAC (Pointer Authentication Code)
_rustflags-hardened_has_pauth() {
	local pauth=0
	if grep "Features" "/proc/cpuinfo" | grep -q -e "pauth" ; then
		pauth=1
	fi
	return ${pauth}
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

# @FUNCTION: _rustflags-hardened_has_target_feature
# @DESCRIPTION:
# For -C target-feature=<option> checks
_rustflags-hardened_has_target_feature() {
	local feature="${1}"
	[[ -n "${RUSTC}" ]] || die "QA:  Initialize RUSTC first"
	if ${RUSTC} --print target-features | grep -q -e "${feature}" ; then
		return 0
	fi
	return 1
}

# @FUNCTION:  _rustflags-hardened_arm_cfi
# @DESCRIPTION:
# Adjust flags for CFI
_rustflags-hardened_arm_cfi() {
	[[ "${ARCH}" == "amd64" ]] || return
	[[ "${RUSTFLAGS_HARDENED_ARM_CFI_USER}" == "0" ]] && return

	# The default setting, not ready for production
	[[ "${RUSTFLAGS_HARDENED_ARM_CFI:-0}" == "0" ]] && return

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
		| grep -E "-march=armv8\.[0-9]-a" \
		| tr " " "\n" \
		| tail -n 1 \
		| sed -e "s|-march=||g")

	if [[ -z "${march}" ]] ; then
ewarn
ewarn "Add -march= to CFLAGS to enable CFI for ARCH=arm64"
ewarn
ewarn "  or"
ewarn
ewarn "change RUSTFLAGS_HARDENED_BTI_USER, RUSTFLAGS_HARDENED_MTE_USER,"
ewarn "RUSTFLAGS_HARDENED_PAC_USER."
ewarn
ewarn "See rustflags-hardened.eclass for details."
ewarn
		return
	fi

	local bti="${BTI[${march}]}"
	local mte="${MTE[${march}]}"
	local pac="${PAC[${march}]}"
	[[ -z "${bti}" ]] && bti="0"
	[[ -z "${mte}" ]] && mte="0"
	[[ -z "${pac}" ]] && pac="0"

	if [[ -n "${RUSTFLAGS_HARDENED_BTI_USER}" ]] ; then
		bti="${RUSTFLAGS_HARDENED_BTI_USER}"
	fi

	if [[ -n "${RUSTFLAGS_HARDENED_MTE_USER}" ]] ; then
		mte="${RUSTFLAGS_HARDENED_MTE_USER}"
	fi

	if [[ -n "${RUSTFLAGS_HARDENED_PAC_USER}" ]] ; then
		pac="${RUSTFLAGS_HARDENED_PAC_USER}"
	fi

	RUSTFLAGS=$(echo "${RUSTFLAGS}" \
		| sed \
			-e "s|-C target-feature=[+]pac-ret,[+]bti||g" \
			-e "s|-C target-feature=[+]pac-ret||g" \
			-e "s|-C target-feature=[+]bti||g" \
			-e "s|-C target-feature=-pac-ret,-bti||g")
	if [[ "${bti}" == "1" ]] && _rustflags-hardened_fcmp "${RUSTFLAGS_HARDENED_TOLERANCE}" ">=" "1.07" ; then
	# Partial heap overflow mitigation, jop, rop
		RUSTFLAGS+=" -C target-feature=+pac-ret,+bti"	# security-critical
	elif [[ "${pac}" == "1" ]] && _rustflags-hardened_fcmp "${RUSTFLAGS_HARDENED_TOLERANCE}" ">=" "1.05" ; then
	# Partial heap overflow mitigation, jop, rop
		RUSTFLAGS+=" -C target-feature=+pac-ret,+bti"	# balance
	elif [[ "${pac}" == "1" ]] && _rustflags-hardened_fcmp "${RUSTFLAGS_HARDENED_TOLERANCE}" ">=" "1.05" ; then
	# Partial heap overflow mitigation, rop
		RUSTFLAGS+=" -C target-feature=+pac-ret"	# balance
	elif [[ "${bti}" == "1" ]] && _rustflags-hardened_fcmp "${RUSTFLAGS_HARDENED_TOLERANCE}" ">=" "1.05" ; then
	# jop
		RUSTFLAGS+=" -C target-feature=+bti"		# performance-critical
	else
		RUSTFLAGS+=" -C target-feature=-pac-ret,-bti"	# performance-critical
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

ewarn "=dev-lang/rust-bin-9999 or =dev-lang/rust-9999 will be required for security-critical rust packages."

	if [[ -z "${CC}" ]] && [[ "${RUSTFLAGS_HARDENED_NO_COMPILER_SWITCH:-0}" != "1" ]] ; then
		export CC=$(tc-getCC)
		export CXX=$(tc-getCXX)
		export CPP="${CC} -E"
einfo "CC:  ${CC}"
		${CC} --version || die
	fi

	RUSTFLAGS=$(echo "${RUSTFLAGS}" \
		| sed -r -e "s#-C[ ]*linker=(clang|gcc)##g")
	if tc-is-clang ; then
		RUSTFLAGS+=" -C linker=clang"
	elif tc-is-gcc ; then
		RUSTFLAGS+=" -C linker=gcc"
	fi

	local need_cfi=0
	local need_clang=0
	if \
		_rustflags-hardened_fcmp "${RUSTFLAGS_HARDENED_TOLERANCE}" ">=" "1.15" \
			&& \
		[[ "${RUSTFLAGS_HARDENED_CFI:-0}" == "1" ]] \
			&& \
		! _rustflags-hardened_has_cet \
			&& \
		[[ "${ARCH}" == "amd64" ]] \
			&& \
		_rustflags-hardened_sanitizers_compat "llvm" \
	; then
		need_cfi=1
		need_clang=1
	elif [[ "${ARCH}" == "arm64" ]] ; then
		_rustflags-hardened_arm_cfi
	fi

	if tc-is-clang ; then
		need_clang=1
	fi

	if (( ${need_clang} == 1 )) && [[ "${RUSTFLAGS_HARDENED_NO_COMPILER_SWITCH:-0}" != "1" ]] ; then
	# Get the slot
		export CC="${CHOST}-clang"
		export CXX="${CHOST}-clang++"
		export CPP="${CC} -E"
		LLVM_SLOT=$(clang-major-version)

	# Avoid wrong clang used bug
		local path
		path="/usr/lib/llvm/${LLVM_SLOT}/bin"
		PATH=$(echo "${PATH}" \
			| tr ":" "\n" \
			| sed -e "\|/usr/lib/llvm|d" \
			| sed -e "s|/opt/bin|/opt/bin\n${path}|g" \
			| tr "\n" ":")
		export LLVM_SLOT=$(clang-major-version)

	# Set CC/CXX again to avoid ccache and reproducibility problems.
		export CC="${CHOST}-clang-${LLVM_SLOT}"
		export CXX="${CHOST}-clang++-${LLVM_SLOT}"
		export CPP="${CC} -E"
	fi
	strip-unsupported-flags
	if ${CC} --version ; then
		:
	else
		if (( ${need_cfi} == 1 )) ; then
			_rustflags-hardened_print_cfi_requires_clang
			_rustflags-hardened_print_cfi_rules
		fi
eerror "Did not detect a compiler."
		die
	fi

	if [[ -z "${RUSTC}" ]] ; then
eerror "QA:  RUSTC is not initialized.  Did you rust_pkg_setup?"
		die
	fi

	${RUSTC} -Z help 2>/dev/null 1>/dev/null
	local is_rust_nightly=$?

	local rust_pv=$("${RUSTC}" --version \
		| cut -f 2 -d " " \
		| sed -e "s|-nightly||g")

	local arch=$(echo "${CFLAGS}" \
		| grep -E -o -e "-march=[-.a-z0-9]+" \
		| sed -e "s|-march=||")
	if [[ -n "${arch}" ]] && ! [[ "${RUSTFLAGS}" =~ "target-cpu=" ]] ; then
		RUSTFLAGS=$(echo "${RUSTFLAGS}" \
			| sed -r -e "s|-C[ ]*target-cpu=[-.a-z0-9]+||g")
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
		RUSTFLAGS=$(echo "${RUSTFLAGS}" \
			| sed -r -e "s#-C[ ]*opt-level=(0|1|2|3|4|fast|s|z)##g")
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
|"security-critical"\
|"sensitive-data"\
|"untrusted-data")\
		]] \
			&&
		ver_test "${rust_pv}" -ge "1.60.0" \
			&& \
		[[ "${RUSTFLAGS_HARDENED_CET:-1}" == "1" ]] \
			&& \
		_rustflags-hardened_has_target_feature "cet" \
	; then
	# ZC, CE, PE
		RUSTFLAGS=$(echo "${RUSTFLAGS}" \
			| sed -r -e "s#-C[ ]*target-feature=[-+]cet##g")
		RUSTFLAGS+=" -C target-feature=+cet"
	elif \
		_rustflags-hardened_has_pauth \
			&& \
		[[ "${RUSTFLAGS_HARDENED_PAUTH:-1}" == "1" ]] \
	; then
	# ZC, CE, PE
		RUSTFLAGS=$(echo "${RUSTFLAGS}" \
			| sed -r -e "s#-C[ ]*control-flow-protection##g")
		RUSTFLAGS+=" -C control-flow-protection"
	fi

	${RUSTC} -Z help | grep -q -e "stack-protector"
	has_stack_protector=$?

	# Not production ready only available on nightly
	# For status see https://github.com/rust-lang/rust/blob/master/src/doc/rustc/src/exploit-mitigations.md?plain=1#L41
	if (( ${is_rust_nightly} != 0 )) ; then
		:
	elif (( ${has_stack_protector} != 0 )) ; then
		:
	else
		RUSTFLAGS=$(echo "${RUSTFLAGS}" \
			| sed -r \
				-e "s#-Z[ ]*stack-protector=(all|basic|none|strong)##g")
		if [[ "${RUSTFLAGS_HARDENED_LEVEL}" == "3" ]] ; then
	# ZC, CE, EP
			RUSTFLAGS+=" -Z stack-protector=all"
		elif [[ "${RUSTFLAGS_HARDENED_LEVEL}" == "1" ]] ; then
	# ZC, CE, EP
			RUSTFLAGS+=" -Z stack-protector=basic"
		elif [[ "${RUSTFLAGS_HARDENED_LEVEL}" == "2" ]] ; then
	# ZC, CE, EP
			RUSTFLAGS+=" -Z stack-protector=strong"
		fi
	fi

	if [[ "${RUSTFLAGS_HARDENED_RETPOLINE:-1}" == "1" && "${RUSTFLAGS_HARDENED_USE_CASES}" =~ ("id"|"kernel") ]] ; then
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
	# Spectre V2 mitigation general case
		# -mfunction-return and -fcf-protection are mutually exclusive.

		if which lscpu >/dev/null && lscpu | grep -q -E -e "Spectre v2.*(Mitigation|Vulnerable)" ; then
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
			elif _rustflags-hardened_has_target_feature "retpoline" ; then
	# ZC, ID
				RUSTFLAGS=$(echo "${RUSTFLAGS}" \
					| sed -r -e "s#-C[ ]*target-feature=[-+]retpoline##g")
				RUSTFLAGS+=" -C target-feature=+retpoline"
			fi
		fi
	fi

	if is-flagq "-O0" ; then
		replace-flags "-O0" "-O1"
		RUSTFLAGS=$(echo "${RUSTFLAGS}" \
			| sed -r -e "s#-C[ ]*opt-level=(0|1|2|3|4|fast|s|z)##g")
		RUSTFLAGS+=" -C opt-level=1"
	fi

	# ZC, CE, PE, DoS, DT, ID
	filter-flags "-D_FORTIFY_SOURCE=*"
	filter-flags "-U_FORTIFY_SOURCE"
	append-flags "-U_FORTIFY_SOURCE"
	RUSTFLAGS=$(echo "${RUSTFLAGS}" | sed -r -e "s#-C[ ]*link-arg=-D_FORTIFY_SOURCE=[0-3]##g")
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
|"security-critical"\
|"multiuser-system") \
		]] \
				&& \
		has_version ">=sys-libs/glibc-2.34" \
	; then
		RUSTFLAGS=$(echo "${RUSTFLAGS}" \
			| sed -r -e "s#-C[ ]*link-arg=-D_FORTIFY_SOURCE=[0-3]+##g")
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
		RUSTFLAGS=$(echo "${RUSTFLAGS}" | sed -r -e "s#-C[ ]*link-arg=-D_FORTIFY_SOURCE=[0-3]##g")
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
|"security-critical"\
|"safety-critical"\
|"untrusted-data")\
		]] \
			&& \
		_rustflags-hardened_fcmp "${RUSTFLAGS_HARDENED_TOLERANCE}" ">=" "1.20" \
	; then
	# Remove flag if 50% drop in performance.
	# For runtime *signed* integer overflow detection
	# ZC, CE, PE, DoS, DT, ID
		RUSTFLAGS=$(echo "${RUSTFLAGS}" \
			| sed -r -e "s#-C[ ]*overflow-checks=(on|off|true|false|yes|no|y|n)##g")
		RUSTFLAGS+=" -C overflow-checks=on"
	fi

	local host=$(${RUSTC} -vV | grep "host:" | cut -f 2 -d " ")
einfo "rustc host:  ${host}"

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
|"security-critical"\
|"sensitive-data"\
|"server"\
|"untrusted-data"\
|"web-browser")\
		]] \
	; then
	# For CFLAGS equivalent list, see also `rustc --print target-features`
	# For -mllvm option, see `rustc -C llvm-args="--help"`
		if _rustflags-hardened_has_target_feature "stack-probe" ; then
	# Mitigation for stack clash, stack overflow
	# Not available for ARCH=amd64 prebuilt build.
			RUSTFLAGS=$(echo "${RUSTFLAGS}" \
				| sed -r -e "s#-C[ ]*target-feature=[-+]stack-probe##g")
			RUSTFLAGS+=" -C target-feature=+stack-probe"
		fi

	# ZC, CE, EP, DoS, DT
		RUSTFLAGS=$(echo "${RUSTFLAGS}" \
			| sed -r -e "s#-C[ ]*link-arg=[-+]fstack-clash-protection##g")
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
	# ZC, CE, PE
		RUSTFLAGS=$(echo "${RUSTFLAGS}" \
			| sed -r \
				-e "s#-C[ ]*link-arg=-z[ ]*-C[ ]*link-arg=noexecstack##g" \
				-e "s#-C[ ]*link-arg=-Wl,-z,noexecstack##g")
		RUSTFLAGS+=" -C link-arg=-Wl,-z,noexecstack"
	fi

	# For executable packages only.
	# Do not apply to hybrid (executible with libs) packages
	if [[ "${RUSTFLAGS_HARDENED_PIE:-0}" == "1" ]] ; then
	# ZC, CE, PE, ID
		RUSTFLAGS=$(echo "${RUSTFLAGS}" \
			| sed -r -e "s#-C[ ]*relocation-model=pie##g")
		RUSTFLAGS+=" -C relocation-model=pie"

		RUSTFLAGS=$(echo "${RUSTFLAGS}" \
			| sed -r -e "s#-C[ ]*link-arg=-pie##g")
		RUSTFLAGS+=" -C link-arg=-pie"
	fi

	# For library packages only
	if [[ "${RUSTFLAGS_HARDENED_PIC:-0}" == "1" ]] ; then
	# ZC, CE, PE, ID
		RUSTFLAGS=$(echo "${RUSTFLAGS}" \
			| sed -r -e "s#-C[ ]*relocation-model=pic##g")
		RUSTFLAGS+=" -C relocation-model=pic"
	fi

	if ver_test "${rust_pv}" -ge "1.79" ; then
	# DoS, DT
		RUSTFLAGS=$(echo "${RUSTFLAGS}" \
			| sed -r -e "s#-C[ ]*relro-level=(off|partial|full)##g")
		RUSTFLAGS+=" -C relro-level=full"

		RUSTFLAGS=$(echo "${RUSTFLAGS}" \
			| sed -r \
				-e "s#-C[ ]*link-arg=-z[ ]*-C[ ]*link-arg=relro##g" \
				-e "s#-C[ ]*link-arg=-Wl,-z,relro##g")
		RUSTFLAGS+=" -C link-arg=-Wl,-z,relro"

		RUSTFLAGS=$(echo "${RUSTFLAGS}" \
			| sed -r \
				-e "s#-C[ ]*link-arg=-z[ ]*-C[ ]*link-arg=now##g" \
				-e "s#-C[ ]*link-arg=-Wl,-z,now##g")
		RUSTFLAGS+=" -C link-arg=-Wl,-z,now"
	fi

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
			RUSTFLAGS=$(echo "${RUSTFLAGS}" \
				| sed -r -e "s|-C[ ]*target-cpu=[-.a-z0-9]+||g")
			RUSTFLAGS+=" -C target-cpu=generic"
			RUSTFLAGS+=" -C target-feature=-3dnow,-avx,-avx2,-avx512cd,-avx512dq,-avx512f,-avx512ifma,-avx512vl,-fma,-mmx,-msse4,-msse4.1,-sse,-sse2"
		fi
		if [[ "${ARCH}" == "arm64" ]] ; then
			replace-flags "-march=*" "-march=armv8-a"
			filter-flags "-mtune=*"
			RUSTFLAGS=$(echo "${RUSTFLAGS}" \
				| sed -r -e "s|-C[ ]*target-cpu=[-.a-z0-9]+||g")
			RUSTFLAGS+=" -C target-cpu=generic"
			RUSTFLAGS+=" -C target-feature=-fp-armv8,-neon"
		fi
		if is-flagq "-Ofast" ; then
			replace-flags "-Ofast" "-O3"
			RUSTFLAGS=$(echo "${RUSTFLAGS}" \
				| sed -r -e "s#-C[ ]*opt-level=(0|1|2|3|4|fast|s|z)##g")
			RUSTFLAGS+=" -C opt-level=3"
		fi

		RUSTFLAGS=$(echo "${RUSTFLAGS}" \
			| sed -r -e "s|-C[ ]*target-cpu=[-.a-z0-9]+||g")
		RUSTFLAGS+=" -C target-cpu=generic"
		if _rustflags-hardened_has_target_feature "strict-fp" ; then
			RUSTFLAGS=$(echo "${RUSTFLAGS}" | sed -r -e "s#-C[ ]*target-feature=[-+]strict-fp##g")
			RUSTFLAGS+=" -C target-feature=+strict-fp"
		fi
		RUSTFLAGS=$(echo "${RUSTFLAGS}" | sed -r -e "s#-C[ ]*target-feature=[-+]fast-math##g")
		RUSTFLAGS+=" -C target-feature=-fast-math"

		RUSTFLAGS=$(echo "${RUSTFLAGS}" | sed -r -e "s#-C[ ]*float-precision=(exact|16|32|64)##g")
		RUSTFLAGS+=" -C float-precision=exact"

		RUSTFLAGS=$(echo "${RUSTFLAGS}" | sed -r -e "s#-C[ ]*soft-float##g")
		RUSTFLAGS+=" -C soft-float"

		RUSTFLAGS=$(echo "${RUSTFLAGS}" | sed -r -e "s#-C[ ]*codegen-units=[0-9]+##g")
		RUSTFLAGS+=" -C codegen-units=1"
	fi

	# We don't enable these because clang/llvm not installed by default.
	# We will need to test them before allowing users to use them.
	# Enablement is complicated by LLVM_COMPAT and compile time to build LLVM with sanitizers enabled.

	local sanitizers_compat=0
	if \
		tc-is-gcc \
			&& \
		_rustflags-hardened_sanitizers_compat "gcc" \
	; then
		sanitizers_compat=1
	elif \
		tc-is-clang \
			&& \
		_rustflags-hardened_sanitizers_compat "llvm" \
	; then
		sanitizers_compat=1
	fi

	if [[ "${RUSTFLAGS_HARDENED_SANITIZERS_DEACTIVATE}" == "0" ]] ; then
		sanitizers_compat=0
	fi

	if (( ${is_rust_nightly} != 0 )) ; then
		sanitizers_compat=0
	fi

	if [[ -n "${RUSTFLAGS_HARDENED_SANITIZERS}" ]] && (( ${sanitizers_compat} == 1 )) ; then
		local l="${RUSTFLAGS_HARDENED_SANITIZERS}"
		declare -A GCC_M=(
			["address"]="asan"
			["hwaddress"]="hwasan"
			["leak"]="lsan"
			["shadow-call-stack"]="shadowcallstack"
			["thread"]="tsan"
			["undefined"]="ubsan"
		)
		declare -A CLANG_M=(
			["address"]="asan"
			["cfi"]="cfi"
			["dataflow"]="dfsan"
			["hwaddress"]="hwasan"
			["leak"]="lsan"
			["memory"]="msan"
			["safe-stack"]="safestack"
			["shadow-call-stack"]="shadowcallstack"
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

			if [[ "${RUSTFLAGS_HARDENED_IGNORE_SANITIZER_CHECK:-0}" == "1" ]] ; then
				:
			elif \
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
				_rustflags-hardened_fcmp "${RUSTFLAGS_HARDENED_TOLERANCE}" ">=" "${slowdown}" \
					&& \
				[[ ${added[${module}]} == "0" ]] \
			; then
				if [[ "${x}" =~ "address" ]] && (( ${asan} == 1 )) ; then
					skip=1
				elif [[ "${x}" == "ubsan" ]] ; then
	# Not supported
	# Many of the above sanitizer options are not supported
					skip=1
				elif [[ "${x}" == "hwaddress" ]] && _rustflags-hardened_has_mte && [[ "${ARCH}" == "arm64" ]] ; then
					RUSTFLAGS+=" -Zsanitizer=${x}"
					asan=1
				elif [[ "${x}" == "hwaddress" ]] ; then
					skip=1
				elif [[ "${x}" == "address" ]] ; then
					RUSTFLAGS+=" -Zsanitizer=${x}"
					asan=1
				elif [[ "${x}" == "cfi" ]] && ! _rustflags-hardened_has_cet && [[ "${ARCH}" == "amd64" ]] && tc-is-clang ; then
					RUSTFLAGS+=" -Zsanitizer=${x}"
				elif [[ "${x}" == "cfi" ]] ; then
					skip=1
				else
					RUSTFLAGS+=" -Zsanitizer=${x}"
				fi

				if (( ${skip} == 0 )) ; then
	#
	# We need to statically link sanitizers to avoid breaking some of the
	# @world set.
	#
	# Prevent linking to shared lib.  When you unemerge the compiler slot
	# containing the sanitizer lib, it could lead to a DoS.
	#
					if tc-is-clang ; then
						if [[ "${RUSTFLAGS}" =~ "--as-needed" ]] ; then
							RUSTFLAGS+=" -C link-arg=-Wl,--no-as-needed -C link-arg=-static-libsan -C link-arg=-Wl,--as-needed"
						else
							RUSTFLAGS+=" -C link-arg=-Wl,--no-as-needed -C link-arg=-static-libsan"
						fi
einfo "Linking -static-libsan for Clang $(clang-major-version)"
					elif tc-is-gcc ; then
						local lib_name="lib${module}.a"
						local cflags_abi="CFLAGS_${ABI}"
						local lib_path=$(${CC} ${!cflags_abi} -print-file-name="${lib_name}")
						local pat="/usr/lib/gcc/${CHOST}/[0-9]+(.*)?/lib${module}.a"
						RUSTFLAGS=$(echo "${RUSTFLAGS}" | sed -r -e "s|${pat}||g")
						if [[ "${RUSTFLAGS}" =~ "--as-needed" ]] ; then
							RUSTFLAGS+=" -C link-arg=-Wl,--no-as-needed -C link-arg=-static-lib${module} -C link-arg=${lib_path} -C link-arg=-Wl,--as-needed"
						else
							RUSTFLAGS+=" -C link-arg=-static-lib${module}"
						fi
einfo "Linking -static-lib${module} for GCC $(gcc-major-version)"
					fi

					added[${module}]="1"
einfo "Added ${x} from ${module} sanitizer"
				fi
			fi
		done

		if (( ${is_rust_nightly} != 0 )) ; then
			:
		elif (( ${has_stack_protector} != 0 )) ; then
			:
		else
einfo "Deduping stack overflow check"
			RUSTFLAGS=$(echo "${RUSTFLAGS}" \
				| sed -r \
					-e "s#-Z[ ]*stack-protector=(all|basic|none|strong)##g")
	# Disable if it was the compiler default
			RUSTFLAGS+=" -Z stack-protector=none"
		fi
	fi

	export RUSTFLAGS
einfo "RUSTFLAGS:  ${RUSTFLAGS}"
	_rustflags-hardened_proximate_opt_level
}

fi
