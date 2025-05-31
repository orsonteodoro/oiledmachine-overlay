# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: check-compiler-switch.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: check for compiler switch
# @DESCRIPTION:
# Checks compiler for switch to prevent LTO or CFI build bugs.

if [[ -z "${_CHECK_COMPILER_SWITCH_ECLASS}" ]] ; then
_CHECK_COMPILER_SWITCH_ECLASS=1


# @ECLASS_VARIABLE:  DETECT_COMPILER_SWITCH_T0_ARCH
# @DESCRIPTION:
# The compiler architecture before emerging package.

# @ECLASS_VARIABLE:  DETECT_COMPILER_SWITCH_T0_FINGERPRINT
# @DESCRIPTION:
# The compiler version fingerprint before emerging package.

# @ECLASS_VARIABLE:  DETECT_COMPILER_SWITCH_T0_FLAVOR
# @DESCRIPTION:
# The compiler flavor before emerging package.

# @ECLASS_VARIABLE:  DETECT_COMPILER_SWITCH_T0_SLOT
# @DESCRIPTION:
# The compiler slot before emerging package.

# @ECLASS_VARIABLE:  DETECT_COMPILER_SWITCH_T0_VENDOR
# @DESCRIPTION:
# The compiler vendor/owner before emerging package.

# @ECLASS_VARIABLE:  DETECT_COMPILER_SWITCH_T0_VER
# @DESCRIPTION:
# The full compiler version before emerging package.


# @ECLASS_VARIABLE:  DETECT_COMPILER_SWITCH_T1_ARCH
# @DESCRIPTION:
# The compiler architecture after compiler switching phase.

# @ECLASS_VARIABLE:  DETECT_COMPILER_SWITCH_T1_FINGERPRINT
# @DESCRIPTION:
# The compiler version fingerprint after compiler switching phase.

# @ECLASS_VARIABLE:  DETECT_COMPILER_SWITCH_T1_FLAVOR
# @DESCRIPTION:
# The compiler flavor after compiler switching phase.

# @ECLASS_VARIABLE:  DETECT_COMPILER_SWITCH_T1_SLOT
# @DESCRIPTION:
# The compiler slot after compiler switching phase.

# @ECLASS_VARIABLE:  DETECT_COMPILER_SWITCH_T1_VENDOR
# @DESCRIPTION:
# The compiler vendor/owner after compiler switching phase.

# @ECLASS_VARIABLE:  DETECT_COMPILER_SWITCH_T1_VER
# @DESCRIPTION:
# The full compiler version after compiler switching phase.


# @ECLASS_VARIABLE:  DETECT_COMPILER_SWITCH_LTO_CC_NAME
# @USER_VARIABLE
# @DESCRIPTION:
# Set the default compiler name used by default for systemwide LTO.
# Valid values:  gcc, clang

# @ECLASS_VARIABLE:  DETECT_COMPILER_SWITCH_LTO_CC_SLOT
# @USER_VARIABLE
# @DESCRIPTION:
# Set the default compiler slot used by default for systemwide LTO.
# Valid values for GCC:    11, 12, 13, 14, 15, 16
# Valid values for Clang:  15, 16, 17, 18, 19, 20, 21

inherit toolchain-funcs

DETECT_COMPILER_SWITCH_T0_ARCH=""		# Compiler architecture
DETECT_COMPILER_SWITCH_T0_FINGERPRINT=""	# Compiler fingerprint
DETECT_COMPILER_SWITCH_T0_FLAVOR=""		# Compiler fork flavor
DETECT_COMPILER_SWITCH_T0_SLOT=""		# Compiler slot
DETECT_COMPILER_SWITCH_T0_VENDOR=""		# Compiler manufacturer
DETECT_COMPILER_SWITCH_T0_VER=""		# Compiler full version

DETECT_COMPILER_SWITCH_T1_ARCH=""		# Compiler architecture
DETECT_COMPILER_SWITCH_T1_FINGERPRINT=""	# Compiler fingerprint
DETECT_COMPILER_SWITCH_T1_FLAVOR=""		# Compiler fork flavor
DETECT_COMPILER_SWITCH_T1_SLOT=""		# Compiler slot
DETECT_COMPILER_SWITCH_T1_VENDOR=""		# Compiler manufacturer
DETECT_COMPILER_SWITCH_T1_VER=""		# Compiler full version

# @FUNCTION:  check-compiler-switch_start
# @DESCRIPTION:
# Get the starting fingerprint
check-compiler-switch_start() {
	CC=$(tc-getCC)
	CXX=$(tc-getCXX)
	CPP=$(tc-getCPP)
	DETECT_COMPILER_SWITCH_T0_FINGERPRINT=$(${CC} --version 2>&1 | sha1sum | cut -f 1 -d " ")
	${CC} --version | grep -q -e "gcc" && DETECT_COMPILER_SWITCH_T0_ARCH="gcc"
	${CC} --version | grep -q -e "clang" && DETECT_COMPILER_SWITCH_T0_ARCH="clang"

	${CC} --version | grep -q -e "gcc" && DETECT_COMPILER_SWITCH_T0_VENDOR="GNU"
	${CC} --version | grep -q -E -e "^clang" && DETECT_COMPILER_SWITCH_T0_VENDOR="LLVM"
	${CC} --version | grep -q -E -e "^AMD" && DETECT_COMPILER_SWITCH_T0_VENDOR="AMD"
	if [[ "${DETECT_COMPILER_SWITCH_T0_ARCH}" == "gcc" ]] ; then
		DETECT_COMPILER_SWITCH_T0_FLAVOR="gcc"
		DETECT_COMPILER_SWITCH_T0_VER=$(gcc-fullversion)
		DETECT_COMPILER_SWITCH_T0_SLOT=$(gcc-major-version)
	elif [[ "${DETECT_COMPILER_SWITCH_T0_ARCH}" == "clang" ]] ; then
		if ${CC} --version 2>&1 | grep -q -e "AOCC" ; then
			DETECT_COMPILER_SWITCH_T0_FLAVOR="aocc"
			DETECT_COMPILER_SWITCH_T0_VER=$(${CC} --version | head -n 1 | cut -f 4 -d " ")
			DETECT_COMPILER_SWITCH_T0_SLOT="${DETECT_COMPILER_SWITCH_T0_VER%%.*}"
		elif ${CC} --version 2>&1 | grep "/opt/rocm" ; then
			DETECT_COMPILER_SWITCH_T0_FLAVOR="rocm"
			DETECT_COMPILER_SWITCH_T0_VER=$(${CC} --version | head -n 1 | cut -f 3 -d " ")
			DETECT_COMPILER_SWITCH_T0_SLOT="${DETECT_COMPILER_SWITCH_T0_VER%%.*}"
		else
			DETECT_COMPILER_SWITCH_T0_FLAVOR="llvm"
			DETECT_COMPILER_SWITCH_T0_VER=$(clang-fullversion)
			DETECT_COMPILER_SWITCH_T0_SLOT=$(clang-major-version)
		fi
	fi
}

# @FUNCTION:  check-compiler-switch_end
# @DESCRIPTION:
# Get the ending fingerprint
check-compiler-switch_end() {
	CC=$(tc-getCC)
	CXX=$(tc-getCXX)
	CPP=$(tc-getCPP)
	DETECT_COMPILER_SWITCH_T1_FINGERPRINT=$(${CC} --version 2>&1 | sha1sum | cut -f 1 -d " ")
	${CC} --version | grep -q -e "gcc" && DETECT_COMPILER_SWITCH_T1_ARCH="gcc"
	${CC} --version | grep -q -e "clang" && DETECT_COMPILER_SWITCH_T1_ARCH="clang"

	${CC} --version | grep -q -e "gcc" && DETECT_COMPILER_SWITCH_T1_VENDOR="GNU"
	${CC} --version | grep -q -E -e "^clang" && DETECT_COMPILER_SWITCH_T1_VENDOR="LLVM"
	${CC} --version | grep -q -E -e "AMD" && DETECT_COMPILER_SWITCH_T1_VENDOR="AMD"
	if [[ "${DETECT_COMPILER_SWITCH_T1_ARCH}" == "gcc" ]] ; then
		DETECT_COMPILER_SWITCH_T1_SLOT=$(gcc-major-version)
		DETECT_COMPILER_SWITCH_T1_FLAVOR="gcc"
	elif [[ "${DETECT_COMPILER_SWITCH_T1_ARCH}" == "clang" ]] ; then
		if ${CC} --version 2>&1 | grep -q -e "AOCC" ; then
			DETECT_COMPILER_SWITCH_T1_FLAVOR="aocc"
			DETECT_COMPILER_SWITCH_T1_VER=$(${CC} --version | head -n 1 | cut -f 4 -d " ")
			DETECT_COMPILER_SWITCH_T1_SLOT="${DETECT_COMPILER_SWITCH_T1_VER%%.*}"
		elif ${CC} --version 2>&1 | grep "/opt/rocm" ; then
			DETECT_COMPILER_SWITCH_T1_FLAVOR="rocm"
			DETECT_COMPILER_SWITCH_T1_VER=$(${CC} --version | head -n 1 | cut -f 3 -d " ")
			DETECT_COMPILER_SWITCH_T1_SLOT="${DETECT_COMPILER_SWITCH_T1_VER%%.*}"
		else
			DETECT_COMPILER_SWITCH_T1_FLAVOR="llvm"
			DETECT_COMPILER_SWITCH_T1_VER=$(clang-fullversion)
			DETECT_COMPILER_SWITCH_T1_SLOT=$(clang-major-version)
		fi
	fi
}

# @FUNCTION:  check-compiler-switch_is_fingerprint_changed
# @DESCRIPTION:
# Did the compiler fingerprints change?
# Don't use this if the CHOST changes.
# Use instead either
# check-compiler-switch_is_same_flavor_slot()
# check-compiler-switch_is_same_arch_slot()
# check-compiler-switch_is_same_arch()
# @RETURN: 0 - yes, 1 - no
check-compiler-switch_is_fingerprint_changed() {
	if [[ "${DETECT_COMPILER_SWITCH_T0_FINGERPRINT}" == "${DETECT_COMPILER_SWITCH_T1_FINGERPRINT}" ]] ; then
		return 1
	else
		return 0
	fi
}

# @FUNCTION:  check-compiler-switch_is_flavor_slot_changed
# @DESCRIPTION:
# Did either the compiler fork flavor and the compiler slot change?
# @RETURN: 0 - yes, 1 - no
check-compiler-switch_is_flavor_slot_changed() {
	if [[ "${DETECT_COMPILER_SWITCH_T0_FLAVOR}" == "${DETECT_COMPILER_SWITCH_T1_FLAVOR}" && "${DETECT_COMPILER_SWITCH_T0_SLOT}" == "${DETECT_COMPILER_SWITCH_T1_SLOT}" ]] ; then
		return 1
	else
		return 0
	fi
}

# @FUNCTION:  check-compiler-switch_is_arch_slot_changed
# @DESCRIPTION:
# Did either the compiler the compiler arch or the compiler slot change?
# @RETURN: 0 - yes, 1 - no
check-compiler-switch_is_arch_slot_changed() {
	if [[ "${DETECT_COMPILER_SWITCH_T0_ARCH}" == "${DETECT_COMPILER_SWITCH_T1_ARCH}" && "${DETECT_COMPILER_SWITCH_T0_SLOT}" == "${DETECT_COMPILER_SWITCH_T1_SLOT}" ]] ; then
		return 1
	else
		return 0
	fi
}

# @FUNCTION:  check-compiler-switch_is_arch_changed
# @DESCRIPTION:
# Did the compiler architecture change?
# @RETURN: 0 - yes, 1 - no
check-compiler-switch_is_arch_changed() {
	if [[ "${DETECT_COMPILER_SWITCH_T0_ARCH}" == "${DETECT_COMPILER_SWITCH_T1_ARCH}" ]] ; then
		return 1
	else
		return 0
	fi
}

# @FUNCTION:  check-compiler-switch_is_lto_changed
# @DESCRIPTION:
# Did the IR for the LTO compiler change?
#
# Use this if the package has a version range limit for compiler
# (i.e. requires GCC 12) or installs a static-lib unconditionally.
#
check-compiler-switch_is_lto_changed() {
	if [[ -z "${DETECT_COMPILER_SWITCH_LTO_CC_NAME}" || -z "${DETECT_COMPILER_SWITCH_LTO_CC_SLOT}" ]] ; then
eerror
eerror "You must set both DETECT_COMPILER_SWITCH_LTO_CC_NAME and"
eerror "DETECT_COMPILER_SWITCH_LTO_CC_SLOT for LTO IR compatibility."
eerror
eerror "DETECT_COMPILER_SWITCH_LTO_CC_NAME - The name of the C/C++ compiler architecture"
eerror "Valid values:  gcc, clang"
eerror
eerror "DETECT_COMPILER_SWITCH_LTO_CC_SLOT - A single compiler slot for LTO builds"
eerror "Valid values for GCC:    11, 12, 13, 14, 15, 16"
eerror "Valid values for Clang:  15, 16, 17, 18, 19, 20, 21"
eerror
eerror "For sanitizer users, use the same values for"
eerror "CFLAGS_HARDENED_SANITIZER_CC_NAME and CFLAGS_HARDENED_SANITIZER_CC_SLOT"
eerror
eerror "You can set the above variables or remove the -flto flag to remove this"
eerror "fatal error."
eerror
		die
	fi
	if [[ "${DETECT_COMPILER_SWITCH_LTO_CC_NAME}" == "${DETECT_COMPILER_SWITCH_T1_ARCH}" && "${DETECT_COMPILER_SWITCH_LTO_CC_SLOT}" == "${DETECT_COMPILER_SWITCH_T1_SLOT}" ]] ; then
		return 1
	else
		return 0
	fi
}

fi
