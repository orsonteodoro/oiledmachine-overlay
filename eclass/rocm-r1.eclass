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

if [[ ! ${_ROCM_R1_ECLASS} ]]; then
_ROCM_R1_ECLASS=1

# It is assumed monoslot for rocm-system, rocm-libraries

: ${ROCM_DISABLE_CCACHE:=0}
: ${ROCM_LLVM_PATH:="/opt/rocm/lib/llvm"}
: ${ROCM_LLVM_SLOT:="24"}
: ${ROCM_PATH:="/opt/rocm"}
: ${ROCM_SLOT:="9999"}
: ${ROCM_VERSION:="${PV}"}

# The distro's release cycle is faster.
HIP_CUDA_DEPEND_DISTRO="
	virtual/cuda:=
	|| (
		virtual/cuda:13
		virtual/cuda:12
	)
"

# https://github.com/ROCm/HIPIFY/blob/therock-10.1/docs/how-to/hipify-clang.rst
# Upstream supported, user is responsible for packaging it locally.
HIP_CUDA_DEPEND_UPSTREAM="
	dev-util/nvidia-cuda-toolkit:=
	x11-drivers/nvidia-drivers:=
	|| (
		(
			>=x11-drivers/nvidia-drivers-595
			=dev-util/nvidia-cuda-toolkit-13.2*
		)
		(
			>=x11-drivers/nvidia-drivers-575.57
			=dev-util/nvidia-cuda-toolkit-12.9*
		)
		(
			>=x11-drivers/nvidia-drivers-570.124
			=dev-util/nvidia-cuda-toolkit-12.8*
		)
		(
			>=x11-drivers/nvidia-drivers-560.35
			=dev-util/nvidia-cuda-toolkit-12.6*
		)
	)
"

# The user can choose either distro or upstream.
if [[ ${HIP_CUDA_DEPEND_FLAVOR:-"upstream"} =~ "distro" ]] ; then
	HIP_CUDA_DEPEND="${HIP_CUDA_DEPEND_DISTRO}"
else
	HIP_CUDA_DEPEND="${HIP_CUDA_DEPEND_UPSTREAM}"
fi

inherit flag-o-matic toolchain-funcs

# @FUNCTION:  rocm-r1_pkg_setup
# @DESCRIPTION:
# Preconditional warnings and checks
rocm-r1_pkg_setup() {
	if [[ -z "${ROCM_TARGETS}" ]] ; then
ewarn
ewarn "Your ROCM_TARGETS environment variable is empty.  Please set it to reduce the number of GPU kernels built."
ewarn "See https://github.com/ROCm/TheRock/blob/main/SUPPORTED_GPUS.md#rocm-on-linux for details"
ewarn
ewarn "Examples"
ewarn
ewarn "ROCM_TARGETS=\"gfx900;gfx950\""
ewarn "ROCM_TARGETS=\"gfx900\""
ewarn
	fi
einfo "ROCM_TARGETS:  ${ROCM_TARGETS}"
}

# @FUNCTION:  rocm-r1_set_default_gcc
# @DESCRIPTION:
# Sets compiler defaults to system GCC.
rocm-r1_set_default_gcc() {
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CC} -E"
	strip-unsupported-flags
	filter-flags "-fuse-ld=*"
	append-ldflags "-fuse-ld=bfd"

einfo "CC:  ${CC}"
einfo "CXX:  ${CXX}"
einfo "CPP:  ${CPP}"
einfo "CFLAGS:  ${CFLAGS}"
einfo "CXXFLAGS:  ${CXXFLAGS}"
einfo "CPPFLAGS:  ${CPPFLAGS}"
einfo "LDFLAGS:  ${LDFLAGS}"
}

# @FUNCTION:  rocm-r1_set_default_clang
# @DESCRIPTION:
# Sets compiler defaults to system Clang.
rocm-r1_set_default_clang() {
	local llvm_slot="${ROCM_LLVM_SLOT}"
	export CC="${CHOST}-clang-${llvm_slot}"
	export CXX="${CHOST}-clang++-${llvm_slot}"
	export CPP="${CC} -E"
	strip-unsupported-flags
	filter-flags "-fuse-ld=*"
	append-ldflags "-fuse-ld=lld"

	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:${ESYSROOT}/usr/lib/llvm/${llvm_slot}/bin|g")

einfo "CC:  ${CC}"
einfo "CXX:  ${CXX}"
einfo "CPP:  ${CPP}"
einfo "CFLAGS:  ${CFLAGS}"
einfo "CXXFLAGS:  ${CXXFLAGS}"
einfo "CPPFLAGS:  ${CPPFLAGS}"
einfo "LDFLAGS:  ${LDFLAGS}"
einfo "PATH:  ${PATH}"
}

# @FUNCTION:  rocm-r1_set_default_hip_clang
# @DESCRIPTION:
# Sets compiler defaults to HIP-Clang.
rocm-r1_set_default_hip_clang() {
	if [[ "${FEATURES}" =~ "ccache" && "${ROCM_DISABLE_CCACHE}" != "1" ]] ; then
	# Placed here to unbreak ccache with gcc.
		export CCACHE_PATH="${ROCM_LLVM_PATH}/bin"
	fi

	local llvm_slot="${ROCM_LLVM_SLOT}"
	export CC="amdclang"
	export CXX="amdclang++"
	export CPP="${CC} -E"

	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:${ESYSROOT}${ROCM_LLVM_PATH}/bin|g")

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

# @FUNCTION:  rocm-r1_set_default_hipcc
# @DESCRIPTION:
# Sets compiler defaults for hipcc frontend.
rocm-r1_set_default_hipcc() {
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
