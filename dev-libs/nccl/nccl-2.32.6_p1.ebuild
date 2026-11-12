# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=11

MY_PV="2.32.6-1"
NCCL_TESTS_PV="2.21.1"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}" # 14, 15
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_CXX14_CUDA_12[@]/llvm_slot_}" # 19
	"${LIBCXX_COMPAT_CXX17_CUDA_13[@]/llvm_slot_}" # 19, 21, 22
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}" # 19, 21, 22
)

S_TESTS="${WORKDIR}/nccl-tests-${NCCL_TESTS_PV}"
PYTHON_COMPAT=( "python3_"{11..14} )

# TODO:  Retest with clang
# inherit libcxx-slot
inherit check-compiler-switch cmake cuda flag-o-matic libcxx-slot libstdcxx-slot
inherit linux-info secure-version python-any-r1

S="${WORKDIR}/${PN}-${MY_PV}"
KEYWORDS="~amd64"
SRC_URI="
https://github.com/NVIDIA/nccl/archive/refs/tags/v${MY_PV}.tar.gz
	-> ${PN}-${MY_PV}.tar.gz
https://github.com/NVIDIA/nccl-tests/archive/refs/tags/v${NCCL_TESTS_PV}.tar.gz
	-> nccl-tests-${NCCL_TESTS_PV}.tar.gz
"

DESCRIPTION="Optimized primitives for collective multi-GPU communication"
HOMEPAGE="
https://developer.nvidia.com/nccl
https://github.com/NVIDIA/nccl
"
LICENSE="
	(
		Apache-2.0
		BitstreamVera
		BSD
		matplotlib
		NVIDIA-CUDA
	)
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	BSD
"
# Apache-2.0 BitstreamVera BSD matplotlib NVIDIA-CUDA -  contrib/tide/ThirdPartyNotices.txt
# Apache-2.0-with-LLVM-exceptions - NVTX/LICENSE.txt
# Apache-2.0-with-LLVM-exceptions - src/include/nvtx3/nvtxDetail/nvtxExtPayloadHelperInternal.h
RESTRICT="mirror test"
SOVER=$(ver_cut "1" "${PV}")
SLOT="0/${SOVER}"
IUSE="
-gdrcopy openssl peermem rdma roce test -verbs
ebuild_revision_10
"
REQUIRED_USE="
	^^ (
		${LIBCXX_COMPAT_CXX17_CUDA_13[@]}
	)
	rdma? (
		|| (
			roce
			verbs
		)
	)
"
RDEPEND="
	virtual/cuda:=[rdma]
	|| (
		=virtual/cuda-12*[rdma]
		=virtual/cuda-13*[rdma]
	)
	gdrcopy? (
		dev-libs/gdrcopy:=
	)
	openssl? (
		$(secure-version_gen_openssl_depends '3.5-3.6')
	)
	peermem? (
		dev-util/DOCA-Host:=[${LIBSTDCXX_USEDEP},mlnx-ofed-kernel]
		x11-drivers/nvidia-drivers:=
	)
	verbs? (
		sys-cluster/rdma-core:=
	)
	dev-util/nvidia-cuda-toolkit:=
	>=sys-libs/glibc-${GLIBC_PV}:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.25
"
PATCHES=(
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
	check-compiler-switch_start
	check_kernel_setup
	python-any-r1_pkg_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_prepare() {
	cmake_src_prepare
	cuda_src_prepare
}

_get_cuda_targets() {
	local x
	local out=""
	for x in $(echo "${CUDA_TARGETS}" | tr ";" " ") ; do
		out+=";${x#sm_}"
	done
	echo "${out:1}"
}

src_configure() {
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CC} -E"
	strip-unsupported-flags

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	export CUDA_HOME="/opt/cuda"

	if use openssl ; then
		export TLS_BACKEND="OPENSSL3"
	else
		unset TLS_BACKEND
	fi

einfo "Setting mycmakeargs"
	local mycmakeargs=(
		-DCMAKE_CUDA_ARCHITECTURES=$(_get_cuda_targets)
		-DRDMA_CORE=$(usex verbs "ON" "OFF")
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
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
	cmake_src_install
	dodoc "LICENSE.txt"
	dodoc "ThirdPartyNotices.txt"
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
