# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CUDA_TARGETS_COMPAT=(
	sm_35
	sm_50
	sm_60
	sm_61
	sm_70
	sm_80
	sm_90

	compute_61
	compute_70
	compute_80
	compute_90
)
NCCL_TESTS_COMMIT="1292b25553bd0384f2faa2965f9d82b99797a348" # committer-date:<=2024-06-19
S_TESTS="${WORKDIR}/nccl-tests-${NCCL_TESTS_COMMIT}"

inherit autotools flag-o-matic

S="${WORKDIR}/${P}-1"
KEYWORDS="~amd64"
SRC_URI="
https://github.com/NVIDIA/nccl/archive/refs/tags/v${PV}-1.tar.gz
	-> ${P}.tar.gz
https://github.com/NVIDIA/nccl-tests/archive/${NCCL_TESTS_COMMIT}.tar.gz
	-> nccl-tests-${NCCL_TESTS_COMMIT:0:7}.tar.gz
"

DESCRIPTION="Optimized primitives for collective multi-GPU communication"
HOMEPAGE="
https://developer.nvidia.com/nccl
https://github.com/NVIDIA/nccl
"
LICENSE="
	(
		BSD-2
		custom
	)
	Apache-2.0-with-LLVM-exceptions
"
# Apache-2.0-with-LLVM-exceptions - NVTX/LICENSE.txt
# Apache-2.0-with-LLVM-exceptions - src/include/nvtx3/nvtxDetail/nvtxExtPayloadHelperInternal.h
RESTRICT="mirror test"
SLOT="0"
IUSE="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
test
ebuild-revision-1
"
REQUIRED_USE="
	|| (
		${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
	)
"
RDEPEND="
	|| (
		=dev-util/nvidia-cuda-toolkit-12.5*
		=dev-util/nvidia-cuda-toolkit-12.4*
		=dev-util/nvidia-cuda-toolkit-12.3*
		=dev-util/nvidia-cuda-toolkit-11.8*
	)
	cuda_targets_compute_61? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12.5*
			=dev-util/nvidia-cuda-toolkit-12.4*
			=dev-util/nvidia-cuda-toolkit-12.3*
			=dev-util/nvidia-cuda-toolkit-11.8*
		)
	)
	cuda_targets_compute_70? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12.5*
			=dev-util/nvidia-cuda-toolkit-12.4*
			=dev-util/nvidia-cuda-toolkit-12.3*
			=dev-util/nvidia-cuda-toolkit-11.8*
		)
	)
	cuda_targets_compute_80? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12.5*
			=dev-util/nvidia-cuda-toolkit-12.4*
			=dev-util/nvidia-cuda-toolkit-12.3*
			=dev-util/nvidia-cuda-toolkit-11.8*
		)
	)
	cuda_targets_compute_90? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12.5*
			=dev-util/nvidia-cuda-toolkit-12.4*
			=dev-util/nvidia-cuda-toolkit-12.3*
			=dev-util/nvidia-cuda-toolkit-11.8*
		)
	)
	cuda_targets_sm_35? (
		=dev-util/nvidia-cuda-toolkit-11.8*
	)
	cuda_targets_sm_50? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12.5*
			=dev-util/nvidia-cuda-toolkit-12.4*
			=dev-util/nvidia-cuda-toolkit-12.3*
			=dev-util/nvidia-cuda-toolkit-11.8*
		)
	)
	cuda_targets_sm_60? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12.5*
			=dev-util/nvidia-cuda-toolkit-12.4*
			=dev-util/nvidia-cuda-toolkit-12.3*
			=dev-util/nvidia-cuda-toolkit-11.8*
		)
	)
	cuda_targets_sm_61? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12.5*
			=dev-util/nvidia-cuda-toolkit-12.4*
			=dev-util/nvidia-cuda-toolkit-12.3*
			=dev-util/nvidia-cuda-toolkit-11.8*
		)
	)
	cuda_targets_sm_70? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12.5*
			=dev-util/nvidia-cuda-toolkit-12.4*
			=dev-util/nvidia-cuda-toolkit-12.3*
			=dev-util/nvidia-cuda-toolkit-11.8*
		)
	)
	cuda_targets_sm_80? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12.5*
			=dev-util/nvidia-cuda-toolkit-12.4*
			=dev-util/nvidia-cuda-toolkit-12.3*
			=dev-util/nvidia-cuda-toolkit-11.8*
		)
	)
	cuda_targets_sm_90? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12.5*
			=dev-util/nvidia-cuda-toolkit-12.4*
			=dev-util/nvidia-cuda-toolkit-12.3*
			=dev-util/nvidia-cuda-toolkit-11.8*
		)
	)
	dev-util/nvidia-cuda-toolkit:=
	sys-libs/glibc
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-build/make
"
PATCHES=(
	"${FILESDIR}/${PN}-2.22.3-libdir.patch"
)

libstdcxx_check() {
	local required_gcc_slot="${1}"
        local gcc_current_profile=$(gcc-config -c)
        local gcc_current_profile_slot=${gcc_current_profile##*-}
        if ver_test "${gcc_current_profile_slot}" -ne "${required_gcc_slot}" ; then
eerror
eerror "You must switch to =sys-devel/gcc-${required_gcc_slot}.  Do"
eerror
eerror "  eselect gcc set ${CHOST}-${required_gcc_slot}"
eerror "  source /etc/profile"
eerror
                die
        fi
}

src_configure() {
	if has_version "=dev-util/nvidia-cuda-toolkit-12.5*" ; then
		export CC="${CHOST}-gcc-13"
		export CXX="${CHOST}-g++-13"
		libstdcxx_check 13
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.4*" ; then
		export CC="${CHOST}-gcc-13"
		export CXX="${CHOST}-g++-13"
		libstdcxx_check 13
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.3*" ; then
		export CC="${CHOST}-gcc-12"
		export CXX="${CHOST}-g++-12"
		libstdcxx_check 12
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.8*" ; then
		export CC="${CHOST}-gcc-11"
		export CXX="${CHOST}-g++-11"
		libstdcxx_check 11
	else
# Avoid version symbols problems.
eerror "Unsupported cuda version."
		die
	fi
	export CUDA_HOME="/opt/cuda"
	local list=()
	if use cuda_targets_sm_35 ; then
		list+=( -gencode=arch=compute_35,code=sm_35 )
	fi
	if use cuda_targets_sm_50 ; then
		list+=( -gencode=arch=compute_50,code=sm_50 )
	fi
	if use cuda_targets_sm_60 ; then
		list+=( -gencode=arch=compute_60,code=sm_60 )
	fi
	if use cuda_targets_sm_70 ; then
		list+=( -gencode=arch=compute_70,code=sm_70 )
	fi
	if use cuda_targets_sm_80 ; then
		list+=( -gencode=arch=compute_80,code=sm_80 )
	fi
	if use cuda_targets_sm_90 ; then
		list+=( -gencode=arch=compute_90,code=sm_90 )
	fi

	# PTX
	if use cuda_targets_compute_61 ; then
		list+=( -gencode=arch=compute_61,code=compute_61 )
	fi
	if use cuda_targets_compute_70 ; then
		list+=( -gencode=arch=compute_70,code=compute_70 )
	fi
	if use cuda_targets_compute_80 ; then
		list+=( -gencode=arch=compute_80,code=compute_80 )
	fi
	if use cuda_targets_compute_90 ; then
		list+=( -gencode=arch=compute_90,code=compute_90 )
	fi
	export NVCC_GENCODE="${list[@]}"
}

src_compile() {
	emake
	pushd "${S_TESTS}" || die
		export NCCL_HOME="${S}/build"
		INSTALL_LIBDIR="$(get_libdir)" \
		PREFIX="/usr" \
		emake
	popd
}

src_test() {
	pushd "${S_TESTS}" || die
		"./build/all_reduce_perf" -b 8 -e 256M -f 2 -g 1
	popd
}

src_install() {
	emake \
		INSTALL_LIBDIR="$(get_libdir)" \
		PREFIX="${ED}/usr" \
		install
	dodoc "LICENSE.txt"
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
