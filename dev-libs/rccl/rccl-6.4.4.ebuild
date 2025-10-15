# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx906
	gfx908
	gfx90a
	gfx942
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1200
	gfx1201
)
CHECKREQS_MEMORY=25G # Tested with 34.3G total memory
LLVM_SLOT=19
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit check-reqs cmake edo flag-o-matic linux-info rocm

KEYWORDS="~amd64"
S="${WORKDIR}/rccl-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/rccl/archive/rocm-${PV}.tar.gz
	-> rccl-${PV}.tar.gz
"

DESCRIPTION="ROCm Communication Collectives Library (RCCL)"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rccl"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	BSD
	MIT
"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0/${ROCM_SLOT}"
IUSE="
test peermem rdma roce verbs
ebuild_revision_8
"
REQUIRED_USE="
	rdma? (
		|| (
			roce
			verbs
		)
	)
"
RDEPEND="
	>=dev-libs/rocr-runtime-${PV}:${SLOT}
	dev-libs/rocr-runtime:=
	>=dev-util/hip-${PV}:${SLOT}[rocm]
	dev-util/hip:=
	>=dev-util/rocm-smi-${PV}:${SLOT}
	dev-util/rocm-smi:=
	peermem? (
		dev-util/DOCA-Host[mlnx-ofed-kernel]
		|| (
			>=virtual/kfd-6.4:0/6.4[rock-dkms]
			>=virtual/kfd-6.3:0/6.3[rock-dkms]
			>=virtual/kfd-6.2:0/6.2[rock-dkms]
		)
		virtual/kfd:=
	)
	verbs? (
		sys-cluster/rdma-core
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIPCC_DEPEND}
	>=dev-build/cmake-3.5
	>=dev-util/HIPIFY-${PV}:${SLOT}
	dev-util/HIPIFY:=
	>=dev-build/rocm-cmake-${PV}:${SLOT}
	dev-build/rocm-cmake:=
	test? (
		>=dev-cpp/gtest-1.11
	)
"
PATCHES=(
#	"${FILESDIR}/${PN}-6.1.2-customize-targets.patch"
)

pkg_pretend() {
	# It randomly crashes at 20G total memory
ewarn "Set CHECKREQS_DONOTHING=1 to bypass build requirements not met check at your own risk"
	check-reqs_pkg_pretend
}

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
	if \
		use amdgpu_targets_gfx942 \
	; then
		+="
			~DMI
			~DMIID
		"
		WARNING_DMI="CONFIG_DMI=y is needed for gfx94x special cases or for disabing GPUDirect RDMA (GDR) in virtual machine."
		WARNING_DMIID="CONFIG_DMIID=y is needed for gfx94x special cases or for for disabing GPUDirect RDMA (GDR) in virtual machine."
	fi
	WARNING_DRM="CONFIG_DRM=y is needed for driver support."
	WARNING_PROC_FS="CONFIG_PROC_FS=y is needed for acquiring system details."
	WARNING_PROC_SYSCTL="CONFIG_PROC_SYSCTL=y is needed for Host ID generation."
	WARNING_PCI="CONFIG_PCI=y is required for PCIe support."
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
	WARNING_DMA_SHARED_BUFFER="CONFIG_DMA_SHARED_BUFFER=y is required for DMA-BUF support."
	WARNING_DMABUF_MOVE_NOTIFY="CONFIG_DMABUF_MOVE_NOTIFY=y is required for DMA-BUF support."
	WARNING_ZONE_DEVICE="CONFIG_ZONE_DEVICE=y is required for DMA-BUF support."
	WARNING_64BIT="CONFIG_64BIT=y is required for DMA-BUF support."
	WARNING_PCI_P2PDMA="CONFIG_PCI_P2PDMA=y is required for DMA-BUF support."
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
	check-reqs_pkg_setup

	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare

	# Prevent swapping
	sed -i -r -e "s|-parallel-jobs=[0-9]+||g" "CMakeLists.txt" || die
}

src_configure() {
	addpredict "/dev/kfd"
	addpredict "/dev/dri/"

	which hipify-perl || die

# Fix error:
#1.	<eof> parser at end of file
#2.	Code generation
#3.	Running pass 'Function Pass Manager' on module '/var/tmp/portage/dev-libs/rccl-5.6.0/work/rccl-rocm-5.6.0_build/src/graph/search.cpp'.
#4.	Running pass 'XXXXXXXXX DAG->DAG Instruction Selection' on function '@_Z15ncclTopoComputeP14ncclTopoSystemP13ncclTopoGraph'
# #0 0x00007f535e6ac7b5 llvm::sys::PrintStackTrace(llvm::raw_ostream&, int) (/usr/lib/llvm/16/bin/../lib64/libLLVM-16.so+0xaac7b5)
# #1 0x00007f535e6accd6 PrintStackTraceSignalHandler(void*) Signals.cpp:0:0
# #2 0x00007f535e6aa605 llvm::sys::RunSignalHandlers() (/usr/lib/llvm/16/bin/../lib64/libLLVM-16.so+0xaaa605)

# XXXXXXXXXXX is omitted
	replace-flags '-O0' '-O1'

	rocm_set_default_hipcc

	export HIP_PLATFORM="amd"
	local amdgpu_targets=$(get_amdgpu_flags)
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test ON OFF)
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DGPU_TARGETS="${amdgpu_targets}"
		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_RUNTIME="rocclr"
		-DROCM_PATH="${ESYSROOT}${EROCM_PATH}"
		-DSKIP_RPATH=ON
		-Wno-dev
	)

ewarn "It may hang when generating git_version.cpp.  Restart emerge if it happens."
	rocm_src_configure
}

src_test() {
	check_amdgpu
	LD_LIBRARY_PATH="${BUILD_DIR}" edob "./test/UnitTests"
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
