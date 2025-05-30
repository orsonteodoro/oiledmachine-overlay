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

DETECT_COMPILER_SWITCH_T0_FINGERPRINT=""
DETECT_COMPILER_SWITCH_T0_FLAVOR=""
DETECT_COMPILER_SWITCH_T0_SLOT=""
DETECT_COMPILER_SWITCH_T0_VENDOR=""
DETECT_COMPILER_SWITCH_T0_VER=""

DETECT_COMPILER_SWITCH_T1_FINGERPRINT=""
DETECT_COMPILER_SWITCH_T1_FLAVOR=""
DETECT_COMPILER_SWITCH_T1_SLOT=""
DETECT_COMPILER_SWITCH_T1_VENDOR=""
DETECT_COMPILER_SWITCH_T1_VER=""

# @FUNCTION: check-compiler-switch_start
# @DESCRIPTION:
# Get the starting fingerprint
check-compiler-switch_start() {
	CC=$(tc-getCC)
	CXX=$(tc-getCXX)
	CPP=$(tc-getCPP)
	DETECT_COMPILER_SWITCH_T0_FINGERPRINT=$(${CC} --version 2>&1 | sha1sum | cut -f 1 -d " ")
	${CC} --version | grep -q -e "gcc" && DETECT_COMPILER_SWITCH_T0_VENDOR="gcc"
	${CC} --version | grep -q -e "clang" && DETECT_COMPILER_SWITCH_T0_VENDOR="clang"
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

# @FUNCTION: check-compiler-switch_end
# @DESCRIPTION:
# Get the ending fingerprint
check-compiler-switch_end() {
	CC=$(tc-getCC)
	CXX=$(tc-getCXX)
	CPP=$(tc-getCPP)
	DETECT_COMPILER_SWITCH_T1_FINGERPRINT=$(${CC} --version 2>&1 | sha1sum | cut -f 1 -d " ")
	${CC} --version | grep -q -e "gcc" && _DETECT_COMPILER_SWITCH_T1_VENDOR="gcc"
	${CC} --version | grep -q -e "clang" && _DETECT_COMPILER_SWITCH_T1_VENDOR="clang"
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

# @FUNCTION: check-compiler-switch_is_same
# @DESCRIPTION:
# Did the compiler change
check-compiler-switch_is_same() {
	if [[ "${DETECT_COMPILER_SWITCH_T0_FINGERPRINT}" == "${DETECT_COMPILER_SWITCH_T1_FINGERPRINT}" ]] ; then
		return 0
	else
		return 1
	fi
}

fi
