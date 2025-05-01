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
# Flag					Performance as a normalized decimal multiple
# No mitigation				   1
# -C link-arg=-D_FORTIFY_SOURCE=2	1.01
# -C link-arg=-D_FORTIFY_SOURCE=3	1.02
# -C overflow-checks=on			1.01 -  1.20
# -C soft-float				2.00 -  10.00
# -C stack-protector=all		1.05 -  1.10
# -C stack-protector=strong		1.02 -  1.05
# -C stack-protector=basic		1.01 -  1.03
# -C target-feature=+retpoline		1.01 -  1.20
# -Zsanitizer=address			1.50 -  4.0 (asan); 1.01 - 1.1 (gwp-asan)
# -Zsanitizer=cfi			1.10 -  2.0
# -Zsanitizer=hwaddress			1.15 -  1.50 (arm64)
# -Zsanitizer=leak			1.05 -  1.5
# -Zsanitizer=memory			3.00 - 11.00
# -Zsanitizer=safestack			1.01 -  1.20
# -Zsanitizer=shadow-call-stack		1.01 -  1.15
# -Zsanitizer=thread			4.00 - 16.00

# Setting to 4.0 will enable ASAN and other faster sanitizers.
# Setting to 15.0 will enable TSAN and other faster sanitizers.

# For example, TSAN is about 4-16x slower compared to the unmitigated build.

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_TOLERANCE_USER
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
# 1 - compile time checks only
# 2 - general compile + runtime protection
# 3 - maximum compile + runtime protection

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_SANITIZERS
# @DESCRIPTION:
# A space delimited list of allowed sanitizer options.

# @ECLASS_VARIABLE:  RUSTFLAGS_HARDENED_SANITIZERS_COMPAT
# @DESCRIPTION:
# You cannot mix sanitizers with static-libs.  The preferred value depends on
# the default CC/CXX.  The CC vendor should not be changed per package but
# distro does not put guardrails from doing this.  List of compatible sanitizers
# This affects if the sanitizer be applied to the package.  This affects if
# LLVM CFI gets applied also.
# Acceptable values:
# llvm
# gcc
# Example:
# RUSTFLAGS_HARDENED_SANITIZERS_COMPAT=( "gcc" "llvm" )


# @ECLASS_VARIABLE:  RUSTFLAGS_UNSTABLE_RUSTC_PV
# @DESCRIPTION:
RUSTFLAGS_UNSTABLE_RUSTC_PV="1.86.0"

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

# @FUNCTION: _rustflags-hardened_has_unstable_rust
# @DESCRIPTION:
# For -Z <option> checks
_rustflags-hardened_has_unstable_rust() {
	if [[ -z "${RUSTC}" ]] ; then
eerror "QA:  Place _rustflags-hardened_has_unstable_rust() after RUSTC init."
		die
	fi
	local rust_pv=$(${RUSTC} --version | cut -f 2 -d " ")
	local is_unstable=0
	if ver_test "${rust_pv}" -lt "${RUSTFLAGS_UNSTABLE_RUSTC_PV}" ; then
		return 1
	fi
	if has_version "=dev-lang/rust-9999" ; then
		return 0
	elif has_version "=dev-lang/rust-bin-9999" ; then
		return 0
	fi
	return 1
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

	if [[ -z "${CC}" ]] ; then
		export CC=$(tc-getCC)
		export CXX=$(tc-getCXX)
		export CPP="${CC} -E"
einfo "CC:  ${CC}"
		${CC} --version || die
	fi

	if tc-is-gcc ; then
		RUSTFLAGS+=" -C linker=gcc"
	elif tc-is-clang ; then
		RUSTFLAGS+=" -C linker=clang"
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
		LLVM_SLOT=$(clang-major-version)

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
			export CXX="clang++-"
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
			_rustflags-hardened_print_cfi_requires_clang
			_rustflags-hardened_print_cfi_rules
		fi
eerror "Did not detect compiler."
		die
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
		RUSTFLAGS+=" -C target-feature=+cet"
	elif \
		_rustflags-hardened_has_pauth \
			&& \
		[[ "${RUSTFLAGS_HARDENED_PAUTH:-1}" == "1" ]] \
	; then
		RUSTFLAGS+=" -C control-flow-protection"
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
	# PE, ID
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
|"security-critical"\
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
|"security-critical"\
|"safety-critical"\
|"untrusted-data")\
		]] \
			&& \
		_rustflags-hardened_fcmp "${RUSTFLAGS_HARDENED_TOLERANCE}" ">=" "1.20" \
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
	# CE, PE, DoS
		RUSTFLAGS+=" -C link-arg=-z -C link-arg=noexecstack"
	fi

	# For executable packages only.
	# Do not apply to hybrid (executible with libs) packages
	if [[ "${RUSTFLAGS_HARDENED_PIE:-0}" == "1" ]] ; then
		RUSTFLAGS+=" -C relocation-model=pie"
		RUSTFLAGS+=" -C link-arg=-pie"
	fi

	# For library packages only
	if [[ "${RUSTFLAGS_HARDENED_PIC:-0}" == "1" ]] ; then
		RUSTFLAGS+=" -C relocation-model=pic"
	fi

	if ver_test "${rust_pv}" -ge "1.79" ; then
	# DoS, DT
		RUSTFLAGS+=" -C relro-level=full"
		RUSTFLAGS+=" -Clink-arg=-Wl,-z,relro"
		RUSTFLAGS+=" -Clink-arg=-Wl,-z,now"
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
		if _rustflags-hardened_has_target_feature "strict-fp" ; then
			RUSTFLAGS+=" -C target-feature=+strict-fp"
		fi
		RUSTFLAGS+=" -C target-feature=-fast-math"
		RUSTFLAGS+=" -C float-precision=exact"
		RUSTFLAGS+=" -C soft-float"
		RUSTFLAGS+=" -C codegen-units=1"
	fi

	# We don't enable these because clang/llvm not installed by default.
	# We will need to test them before allowing users to use them.
	# Enablement is complicated by LLVM_COMPAT and compile time to build LLVM with sanitizers enabled.

	if [[ -n "${RUSTFLAGS_HARDENED_SANITIZERS}" ]] ; then
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
			["asan"]="0"			# CE, PE, DoS, DT, ID
			["cfi"]="0"			# CE, PE, DoS, DT, ID
			["dfsan"]="0"
			["gwp-asan"]="0"
			["hwasan"]="0"			# CE, PE, DoS, DT, ID
			["lsan"]="0"			# ID
			["msan"]="0"			# CE, PE, DoS, DT, ID
			["rtsan"]="0"
			["safestack"]="0"
			["shadowcallstack"]="0"
			["tsan"]="0"			# CE, PE, DoS, DT, ID
			["ubsan"]="0"			# CE, PE, DoS, DT, ID
			["tysan"]="0"
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
			if \
				tc-is-gcc \
					&& \
				_rustflags-hardened_sanitizers_compat "gcc" \
			; then
				:
			elif \
				tc-is-clang \
					&& \
				_rustflags-hardened_sanitizers_compat "clang" \
			; then
				:
			else
				continue
			fi

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
				elif [[ "${x}" == "cfi" ]] && ! _rustflags-hardened_has_cet && [[ "${ARCH}" == "amd64" ]] ; then
					RUSTFLAGS+=" -Zsanitizer=${x}"
				elif [[ "${x}" == "cfi" ]] ; then
					skip=1
				else
					RUSTFLAGS+=" -Zsanitizer=${x}"
				fi

				if (( ${skip} == 0 )) ; then
					added[${module}]="1"
einfo "Added ${x} from ${module} sanitizer"
				fi
			fi
		done
	fi

	export RUSTFLAGS
einfo "RUSTFLAGS:  ${RUSTFLAGS}"
	_rustflags-hardened_proximate_opt_level
}

fi
