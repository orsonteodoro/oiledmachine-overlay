# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
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
FLAG_O_MATIC_STRIP_UNSUPPORTED_FLAGS=1
NCCL_TESTS_COMMIT="1292b25553bd0384f2faa2965f9d82b99797a348" # committer-date:<=2024-06-19
S_TESTS="${WORKDIR}/nccl-tests-${NCCL_TESTS_COMMIT}"
PYTHON_COMPAT=( python3_{10..12} )

inherit autotools flag-o-matic linux-info python-any-r1

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
-gdrcopy peermem rdma roce test -verbs
ebuild_revision_4
"
REQUIRED_USE="
	|| (
		${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
	)
	rdma? (
		|| (
			roce
			verbs
		)
	)
"
CUDA_TOOLKIT_11_8="
	=dev-util/nvidia-cuda-toolkit-11.8*[rdma]
"
CUDA_TOOLKIT_12_3="
	=dev-util/nvidia-cuda-toolkit-12.3*[rdma]
"
CUDA_TOOLKIT_12_4="
	=dev-util/nvidia-cuda-toolkit-12.4*[rdma]
"
CUDA_TOOLKIT_12_5="
	=dev-util/nvidia-cuda-toolkit-12.5*[rdma]
"
CUDA_TOOLKIT_12_6="
	=dev-util/nvidia-cuda-toolkit-12.6*[rdma]
"
RDEPEND="
	>=x11-drivers/nvidia-drivers-470[kernel-open,modules]
	|| (
		${CUDA_TOOLKIT_12_6}
		${CUDA_TOOLKIT_12_5}
		${CUDA_TOOLKIT_12_4}
		${CUDA_TOOLKIT_12_3}
		${CUDA_TOOLKIT_11_8}
	)
	cuda_targets_compute_61? (
		|| (
			${CUDA_TOOLKIT_12_6}
			${CUDA_TOOLKIT_12_5}
			${CUDA_TOOLKIT_12_4}
			${CUDA_TOOLKIT_12_3}
			${CUDA_TOOLKIT_11_8}
		)
	)
	cuda_targets_compute_70? (
		|| (
			${CUDA_TOOLKIT_12_6}
			${CUDA_TOOLKIT_12_5}
			${CUDA_TOOLKIT_12_4}
			${CUDA_TOOLKIT_12_3}
			${CUDA_TOOLKIT_11_8}
		)
	)
	cuda_targets_compute_80? (
		|| (
			${CUDA_TOOLKIT_12_6}
			${CUDA_TOOLKIT_12_5}
			${CUDA_TOOLKIT_12_4}
			${CUDA_TOOLKIT_12_3}
			${CUDA_TOOLKIT_11_8}
		)
	)
	cuda_targets_compute_90? (
		|| (
			${CUDA_TOOLKIT_12_6}
			${CUDA_TOOLKIT_12_5}
			${CUDA_TOOLKIT_12_4}
			${CUDA_TOOLKIT_12_3}
			${CUDA_TOOLKIT_11_8}
		)
	)
	cuda_targets_sm_35? (
		${CUDA_TOOLKIT_11_8}
	)
	cuda_targets_sm_50? (
		|| (
			${CUDA_TOOLKIT_12_6}
			${CUDA_TOOLKIT_12_5}
			${CUDA_TOOLKIT_12_4}
			${CUDA_TOOLKIT_12_3}
			${CUDA_TOOLKIT_11_8}
		)
	)
	cuda_targets_sm_60? (
		|| (
			${CUDA_TOOLKIT_12_6}
			${CUDA_TOOLKIT_12_5}
			${CUDA_TOOLKIT_12_4}
			${CUDA_TOOLKIT_12_3}
			${CUDA_TOOLKIT_11_8}
		)
	)
	cuda_targets_sm_61? (
		|| (
			${CUDA_TOOLKIT_12_6}
			${CUDA_TOOLKIT_12_5}
			${CUDA_TOOLKIT_12_4}
			${CUDA_TOOLKIT_12_3}
			${CUDA_TOOLKIT_11_8}
		)
	)
	cuda_targets_sm_70? (
		|| (
			${CUDA_TOOLKIT_12_6}
			${CUDA_TOOLKIT_12_5}
			${CUDA_TOOLKIT_12_4}
			${CUDA_TOOLKIT_12_3}
			${CUDA_TOOLKIT_11_8}
		)
	)
	cuda_targets_sm_80? (
		|| (
			${CUDA_TOOLKIT_12_6}
			${CUDA_TOOLKIT_12_5}
			${CUDA_TOOLKIT_12_4}
			${CUDA_TOOLKIT_12_3}
			${CUDA_TOOLKIT_11_8}
		)
	)
	cuda_targets_sm_90? (
		|| (
			${CUDA_TOOLKIT_12_6}
			${CUDA_TOOLKIT_12_5}
			${CUDA_TOOLKIT_12_4}
			${CUDA_TOOLKIT_12_3}
			${CUDA_TOOLKIT_11_8}
		)
	)
	gdrcopy? (
		dev-libs/gdrcopy
	)
	peermem? (
		dev-util/DOCA-Host[mlnx-ofed-kernel]
		x11-drivers/nvidia-drivers
	)
	verbs? (
		sys-cluster/rdma-core
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
	"${FILESDIR}/${PN}-2.22.3-link-verbserbs-nccl.patch"
)

check_kernel_setup() {
	linux-info_pkg_setup
#		~DRM # Referenced but not used
	CONFIG_CHECK="
		~PROC_FS
		~PROC_SYSCTL

		~SYSFS
		~NUMA

		~PCI
		~PCIEPORTBUS
	"
	WARNING_DRM="CONFIG_DRM=y is needed for driver support."
	WARNING_PROC_FS="CONFIG_PROC_FS=y is needed for acquiring system details."
	WARNING_PROC_SYSCTL="CONFIG_PROC_SYSCTL=y is needed for Host ID generation."
	WARNING_PCI="CONFIG_PCI=y is required for PCIe support"
	WARNING_PCIEPORTBUS="CONFIG_PCIEPORTBUS=y is required for PCIe support."
	WARNING_NUMA="CONFIG_NUMA is required for tools or NUMA CPU identification."
	WARNING_SYSFS="CONFIG_SYSFS is required for GPUDirect RDMA (GDR) detection."
	check_extra_config

	CONFIG_CHECK="
		~DMA_SHARED_BUFFER
		~DMABUF_MOVE_NOTIFY

		~ZONE_DEVICE
		~64BIT
		~PCI_P2PDMA
	"
	WARNING_DMA_SHARED_BUFFER="CONFIG_DMA_SHARED_BUFFER=y is required for DMA-BUF and GPUDirect RDMA support."
	WARNING_DMABUF_MOVE_NOTIFY="CONFIG_DMABUF_MOVE_NOTIFY=y is required for DMA-BUF and GPUDirect RDMA support."
	WARNING_ZONE_DEVICE="CONFIG_ZONE_DEVICE=y is required for DMA-BUF and GPUDirect RDMA support."
	WARNING_64BIT="CONFIG_64BIT=y is required for DMA-BUF and GPUDirect RDMA support."
	WARNING_PCI_P2PDMA="CONFIG_PCI_P2PDMA=y is required for DMA-BUF and GPUDirect RDMA support."
	check_extra_config

	CONFIG_CHECK="
		~SHMEM
	"
	WARNING_SHMEM="CONFIG_SHMEM=y is required for shared memory transport support."
	check_extra_config

	CONFIG_CHECK="
		~NET
		~INET
		~IPV6
	"
	WARNING_NET="CONFIG_NET=y is required for TCP/IP socket support."
	WARNING_INET="CONFIG_INET=y is required for TCP/IP socket support."
	WARNING_IPV6="CONFIG_IPV6=y is optional for TCP/IP IPv6 socket support."
	check_extra_config

	if use roce ; then
		CONFIG_CHECK="
			~NET
			~INET
			~IPV6
			~INFINIBAND
			~INFINIBAND_ADDR_TRANS
		"
		WARNING_NET="CONFIG_NET=y is required for RoCE support."
		WARNING_INET="CONFIG_INET=y is required for RoCE support."
		WARNING_IPV6="CONFIG_IPV6=y is required for RoCE support."
		WARNING_INFINIBAND="CONFIG_INFINIBAND=y is required for RoCE support."
		WARNING_INFINIBAND_ADDR_TRANS="CONFIG_INFINIBAND_ADDR_TRANS=y is required for RoCE support."
		check_extra_config
	fi

	if use verbs ; then
		CONFIG_CHECK="
			~NET
			~INET
			~IPV6
			~INFINIBAND
			~INFINIBAND_USER_ACCESS
		"
		WARNING_NET="CONFIG_NET=y is required for InfiniBand support."
		WARNING_INET="CONFIG_INET=y is required for InfiniBand support."
		WARNING_IPV6="CONFIG_IPV6=y is required for InfiniBand support."
		WARNING_INFINIBAND="CONFIG_INFINIBAND=y is required for InfiniBand support."
		WARNING_INFINIBAND_USER_ACCESS="CONFIG_INFINIBAND_USER_ACCESS=y is required for InfiniBand Verbs support."
		check_extra_config
	fi

	if use rdma ; then
		CONFIG_CHECK="
			~NETDEVICES
			~ETHERNET
			~NET_VENDOR_MELLANOX
			~MLX5_CORE
			~MLX5_INFINIBAND
		"
		WARNING_NETDEVICES="CONFIG_NETDEVICES=y is required for ConnectX-4 or later support."
		WARNING_ETHERNET="CONFIG_ETHERNET=y is required for ConnectX-4 or later support."
		WARNING_MLX5_CORE="CONFIG_MLX5_CORE=y is required for ConnectX-4 or later support."
		WARNING_MLX5_INFINIBAND="CONFIG_MLX5_INFINIBAND=y is required for ConnectX-4 or later support."
	fi
}

pkg_setup() {
	check_kernel_setup
	python-any-r1_pkg_setup
}

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

src_prepare() {
	default
	pushd "${S_TESTS}" >/dev/null 2>&1 || die
		eapply "${FILESDIR}/${PN}-2.22.3-link-verbserbs-tests.patch"
	popd >/dev/null 2>&1 || die

}

src_configure() {
	if has_version "=dev-util/nvidia-cuda-toolkit-12.5*" ; then
		export CC="${CHOST}-gcc-13"
		export CXX="${CHOST}-g++-13"
		export CPP="${CC} -E"
		strip-unsupported-flags
		libstdcxx_check 13
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.4*" ; then
		export CC="${CHOST}-gcc-13"
		export CXX="${CHOST}-g++-13"
		export CPP="${CC} -E"
		strip-unsupported-flags
		libstdcxx_check 13
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.3*" ; then
		export CC="${CHOST}-gcc-12"
		export CXX="${CHOST}-g++-12"
		export CPP="${CC} -E"
		strip-unsupported-flags
		libstdcxx_check 12
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.8*" ; then
		export CC="${CHOST}-gcc-11"
		export CXX="${CHOST}-g++-11"
		export CPP="${CC} -E"
		strip-unsupported-flags
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
	export RDMA_CORE=$(usex verbs "1" "0")
}

src_compile() {
	INSTALL_LIBDIR="$(get_libdir)" \
	PREFIX="/usr" \
	emake
	pushd "${S_TESTS}" || die
		export NCCL_HOME="${S}/build"
		emake
	popd
}

src_test() {
	pushd "${S_TESTS}" || die
		"./build/all_reduce_perf" -b 8 -e 256M -f 2 -g 1
	popd
}

gen_enable_gdrcopy_flush_enable() {
# Discussed in closed issue #683
# It avoids a NIC round trip penalty.
cat <<EOF > "${T}/99-nccl-gdrcopy-flush-enable"
NCCL_GDRCOPY_ENABLE=1
NCCL_GDRCOPY_FLUSH_ENABLE=1
EOF
	doenvd "${T}/99-nccl-gdrcopy-flush-enable"
}

src_install() {
	emake \
		INSTALL_LIBDIR="$(get_libdir)" \
		PREFIX="${ED}/usr" \
		install
	dodoc "LICENSE.txt"
	if use gdrcopy && [[ "${NCCL_GDRCOPY_FLUSH_ENABLE:-1}" == "1" ]] ; then
einfo "Setting NCCL_GDRCOPY_FLUSH_ENABLE=1.  Set build time per-package environment variable to change it."
		gen_enable_gdrcopy_flush_enable
	fi
}

pkg_postinst() {
	if ! use peermem ; then
ewarn "GPUDirect RDMA support via DMA-BUF requires a >= 5.12 Linux Kernel."
	fi
einfo
einfo "There are more environment variable tweakables.  Search NCCL_PARAM in"
einfo
einfo "  https://github.com/search?q=repo%3ANVIDIA%2Fnccl%20NCCL_PARAM&type=code"
einfo
einfo "They should be prefixed with NCCL_."
einfo
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
