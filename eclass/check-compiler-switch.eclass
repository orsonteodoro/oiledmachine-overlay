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
	if [[ "${_DETECT_COMPILER_SWITCH_T0_VENDOR}" == "gcc" ]] ; then
		DETECT_COMPILER_SWITCH_T0_FLAVOR="gcc"
		DETECT_COMPILER_SWITCH_T0_VER=$(gcc-fullversion)
		DETECT_COMPILER_SWITCH_T0_SLOT=$(gcc-major-version)
	elif [[ "${_DETECT_COMPILER_SWITCH_T0_VENDOR}" == "clang" ]] ; then
		if ${CC} --version 2>&1 | grep -q -e "AOCC" ; then
			DETECT_COMPILER_SWITCH_T0_FLAVOR="aocc"
			DETECT_COMPILER_SWITCH_T0_VER=$(${CC} --version | head -n 1 | cut -f 4 -d " ")
			DETECT_COMPILER_SWITCH_T0_SLOT="${_DETECT_COMPILER_SWITCH_T0_VER%%.*}"
		elif ${CC} --version 2>&1 | grep "/opt/rocm" ; then
			DETECT_COMPILER_SWITCH_T0_FLAVOR="rocm"
			DETECT_COMPILER_SWITCH_T0_VER=$(${CC} --version | head -n 1 | cut -f 3 -d " ")
			DETECT_COMPILER_SWITCH_T0_SLOT="${_DETECT_COMPILER_SWITCH_T0_VER%%.*}"
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
	${CC} --version | grep -q -e "gcc" && _DETECT_COMPILER_SWITCH_T1_ARCH="gcc"
	${CC} --version | grep -q -e "clang" && _DETECT_COMPILER_SWITCH_T1_ARCH="clang"

	${CC} --version | grep -q -e "gcc" && _DETECT_COMPILER_SWITCH_T1_VENDOR="GNU"
	${CC} --version | grep -q -E -e "^clang" && _DETECT_COMPILER_SWITCH_T1_VENDOR="LLVM"
	${CC} --version | grep -q -E -e "AMD" && _DETECT_COMPILER_SWITCH_T1_VENDOR="AMD"
	if [[ "${_DETECT_COMPILER_SWITCH_T0_VENDOR}" == "gcc" ]] ; then
		DETECT_COMPILER_SWITCH_T1_SLOT=$(gcc-major-version)
		DETECT_COMPILER_SWITCH_T1_FLAVOR="gcc"
	elif [[ "${_DETECT_COMPILER_SWITCH_T0_VENDOR}" == "clang" ]] ; then
		if ${CC} --version 2>&1 | grep -q -e "AOCC" ; then
			DETECT_COMPILER_SWITCH_T1_FLAVOR="aocc"
			DETECT_COMPILER_SWITCH_T1_VER=$(${CC} --version | head -n 1 | cut -f 4 -d " ")
			DETECT_COMPILER_SWITCH_T1_SLOT="${_DETECT_COMPILER_SWITCH_T1_VER%%.*}"
		elif ${CC} --version 2>&1 | grep "/opt/rocm" ; then
			DETECT_COMPILER_SWITCH_T1_FLAVOR="rocm"
			DETECT_COMPILER_SWITCH_T1_VER=$(${CC} --version | head -n 1 | cut -f 3 -d " ")
			DETECT_COMPILER_SWITCH_T1_SLOT="${_DETECT_COMPILER_SWITCH_T1_VER%%.*}"
		else
			DETECT_COMPILER_SWITCH_T1_FLAVOR="llvm"
			DETECT_COMPILER_SWITCH_T1_SLOT=$(clang-major-version)
			DETECT_COMPILER_SWITCH_T1_SLOT=$(clang-major-version)
		fi
	fi
}

# @FUNCTION:  check-compiler-switch_is_fingerprint_changed
# @DESCRIPTION:
# Did the compiler change fingerprints?
# Don't use this if the CHOST changes.
# Use instead either
# check-compiler-switch_is_same_flavor_slot()
# check-compiler-switch_is_same_arch_slot()
# check-compiler-switch_is_same_arch()
# @RETURN: 0 - yes, 1 - no
check-compiler-switch_is_fingerprint_changed() {
	if [[ "${DETECT_COMPILER_SWITCH_T0_FINGERPRINT}" == "${DETECT_COMPILER_SWITCH_T1_FINGERPRINT}" ]] ; then
		return 0
	else
		return 1
	fi
}

# @FUNCTION:  check-compiler-switch_is_flavor_slot_changed
# @DESCRIPTION:
# Did the change the compiler fork flavor and the compiler slot?
# @RETURN: 0 - yes, 1 - no
check-compiler-switch_is_flavor_slot_changed() {
	if [[ "${DETECT_COMPILER_SWITCH_T0_FLAVOR}" == "${DETECT_COMPILER_SWITCH_T1_FLAVOR}" && "${DETECT_COMPILER_SWITCH_T0_SLOT}" == "${DETECT_COMPILER_SWITCH_T1_SLOT}" ]] ; then
		return 0
	else
		return 1
	fi
}

# @FUNCTION:  check-compiler-switch_is_arch_slot_changed
# @DESCRIPTION:
# Did the compiler the compiler arch and the compiler slot stay the same?
# @RETURN: 0 - yes, 1 - no
check-compiler-switch_is_arch_slot_changed() {
	if [[ "${DETECT_COMPILER_SWITCH_T0_ARCH}" == "${DETECT_COMPILER_SWITCH_T1_ARCH}" && "${DETECT_COMPILER_SWITCH_T0_SLOT}" == "${DETECT_COMPILER_SWITCH_T1_SLOT}" ]] ; then
		return 0
	else
		return 1
	fi
}

# @FUNCTION:  check-compiler-switch_is_arch_changed
# @DESCRIPTION:
# Did the compiler architecture stay the same?
# @RETURN: 0 - yes, 1 - no
check-compiler-switch_is_arch_changed() {
	if [[ "${DETECT_COMPILER_SWITCH_T0_ARCH}" == "${DETECT_COMPILER_SWITCH_T1_ARCH}" ]] ; then
		return 0
	else
		return 1
	fi
}

fi
