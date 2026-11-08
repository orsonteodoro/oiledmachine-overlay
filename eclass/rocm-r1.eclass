# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rocm-r1.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 8
# @BLURB: Common functions and variables for ROCm packages written in HIP
# @DESCRIPTION:
# Rewrite and simplified for therock-10+

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_ROCM_ECLASS} ]]; then
_ROCM_ECLASS=1

: ${ROCM_DISABLE_CCACHE:=0}
: ${ROCM_LLVM_PATH:-"/opt/rocm"}
: ${ROCM_VERSION:-"${PV}"}

inherit hip-versions
inherit flag-o-matic toolchain-funcs

# @FUNCTION:  rocm_pkg_setup
# @DESCRIPTION:
# Init paths
rocm-r1_pkg_setup() {
	if [[ -z "${GPU_TARGETS}" ]] ; then
ewarn "Your GPU_TARGETS environment variable is empty.  Please set it to reduce the number of kernels built."
	fi
einfo "GPU_TARGETS:  ${GPU_TARGETS}"
}

# @FUNCTION: rocm_set_default_gcc
# @DESCRIPTION:
# Sets compiler defaults to gcc to avoid versioned C++ linking errors.
rocm-r1_set_default_gcc() {
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CC} -E"
	strip-unsupported-flags
	filter-flags "-fuse-ld=*"
	append-ldflags "-fuse-ld=bfd"

einfo "Switched to GCC"
einfo "CC:  ${CC}"
einfo "CXX:  ${CXX}"
einfo "CPP:  ${CPP}"
einfo "CFLAGS:  ${CFLAGS}"
einfo "CXXFLAGS:  ${CXXFLAGS}"
einfo "CPPFLAGS:  ${CPPFLAGS}"
einfo "LDFLAGS:  ${LDFLAGS}"
}

# @FUNCTION: rocm_set_default_clang
# @DESCRIPTION:
# Sets compiler defaults to clang to avoid primarily linker errors.
rocm-r1_set_default_clang() {
	if [[ -z "${ROCM_SLOT}" ]] ; then
eerror "QA:  ROCM_SLOT needs to be defined."
		die
	fi

	if [[ "${FEATURES}" =~ "ccache" && "${ROCM_DISABLE_CCACHE}" != "1" ]] ; then
	# Placed here to unbreak ccache with gcc.
		export CCACHE_PATH="${ROCM_LLVM_PATH}/bin"
	fi

	local _llvm_slot="HIP_${ROCM_SLOT/./_}_LLVM_SLOT"
	llvm_slot="${!_llvm_slot}"
	export CC="${CHOST}-clang-${llvm_slot}"
	export CXX="${CHOST}-clang++-${llvm_slot}"
	export CPP="${CC} -E"
	strip-unsupported-flags
	filter-flags "-fuse-ld=*"
	append-ldflags "-fuse-ld=lld"
einfo "CC:  ${CC}"
einfo "CXX:  ${CXX}"
einfo "CPP:  ${CPP}"
einfo "CFLAGS:  ${CFLAGS}"
einfo "CXXFLAGS:  ${CXXFLAGS}"
einfo "CPPFLAGS:  ${CPPFLAGS}"
einfo "LDFLAGS:  ${LDFLAGS}"
einfo "PATH:  ${PATH}"
}

# @FUNCTION: rocm_set_default_hip_clang
# @DESCRIPTION:
# Sets compiler defaults to clang to avoid primarily linker errors.
rocm-r1_set_default_hip_clang() {
	if [[ -z "${ROCM_SLOT}" ]] ; then
eerror "QA:  ROCM_SLOT needs to be defined."
		die
	fi

	local _llvm_slot="HIP_${ROCM_SLOT/./_}_LLVM_SLOT"
	llvm_slot="${!_llvm_slot}"
	export CC="amdclang"
	export CXX="amdclang++"
	export CPP="${CC} -E"
	strip-unsupported-flags
	filter-flags "-fuse-ld=*"
	append-ldflags "-fuse-ld=lld"
einfo "CC:  ${CC}"
einfo "CXX:  ${CXX}"
einfo "CPP:  ${CPP}"
einfo "CFLAGS:  ${CFLAGS}"
einfo "CXXFLAGS:  ${CXXFLAGS}"
einfo "CPPFLAGS:  ${CPPFLAGS}"
einfo "LDFLAGS:  ${LDFLAGS}"
einfo "PATH:  ${PATH}"
}

# @FUNCTION: rocm_set_default_hipcc
# @DESCRIPTION:
# Sets compiler defaults for hipcc.
rocm-r1_set_default_hipcc() {
	if [[ -z "${ROCM_SLOT}" ]] ; then
eerror "QA:  ROCM_SLOT needs to be defined."
		die
	fi

	if [[ "${FEATURES}" =~ "ccache" && "${ROCM_DISABLE_CCACHE}" != "1" ]] ; then
	# Placed here to unbreak ccache with gcc.
		export CCACHE_PATH="${ROCM_LLVM_PATH}/bin"
	fi

	export CC="hipcc"
	export CXX="hipcc"
#	export CPP="${CC} -E"
	strip-unsupported-flags
	if has "cuda" ${IUSE_EFFECTIVE} && use cuda ; then
		unset CPP
		# It should use nvcc.
		strip-flags
		filter-flags \
			"-pipe" \
			"-Wl,-O1" \
			"-Wl,--as-needed" \
			"-Wno-unknown-pragmas"
		filter-flags "-fuse-ld=*"
		append-ldflags "-fuse-ld=bfd"
		append-cxxflags "-ccbin" "${EPREFIX}/usr/${CHOST}/gcc-bin/${s}/${CHOST}-g++"
	else
		export CPP="${CC} -E"
		strip-unsupported-flags
		filter-flags "-fuse-ld=*"
		append-ldflags "-fuse-ld=lld"
	fi
	filter-lto
einfo "CC:  ${CC}"
einfo "CXX:  ${CXX}"
einfo "CPP:  ${CPP}"
einfo "CFLAGS:  ${CFLAGS}"
einfo "CXXFLAGS:  ${CXXFLAGS}"
einfo "CPPFLAGS:  ${CPPFLAGS}"
einfo "LDFLAGS:  ${LDFLAGS}"
einfo "PATH:  ${PATH}"
}

fi
