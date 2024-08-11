# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

S="${WORKDIR}/${P}-1"
KEYWORDS="~amd64"
SRC_URI="
https://github.com/NVIDIA/nccl/archive/refs/tags/v${PV}-1.tar.gz
	-> ${P}.tar.gz
https://github.com/RadeonOpenCompute/rocm-core/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
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
SLOT="0"
IUSE="ebuild-revision-0"
RDEPEND="
	|| (
		=dev-util/nvidia-cuda-toolkit-12.5*
		=dev-util/nvidia-cuda-toolkit-12.4*
		=dev-util/nvidia-cuda-toolkit-12.3*
		=dev-util/nvidia-cuda-toolkit-11.8*
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
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc "LICENSE.txt"
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
