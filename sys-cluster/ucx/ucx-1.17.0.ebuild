# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See also https://openucx.readthedocs.io/en/master/faq.html?highlight=cuda#what-stuff-should-i-have-on-my-machine-to-use-ucx

MY_PV="${PV/_/-}"

CUDA_TARGETS_COMPAT=(
	sm_35
	sm_60
	sm_70
	sm_72
	sm_75
)
CLANG_COMPAT=( {18..15} )
FLAG_O_MATIC_STRIP_UNSUPPORTED_FLAGS=1
inherit hip-versions
RDMA_CORE_PV="28.0"
ROCM_VERSIONS=(
	"${HIP_6_2_VERSION}"
	"${HIP_6_1_VERSION}"
	"${HIP_6_0_VERSION}"
	"${HIP_5_7_VERSION}"
	"${HIP_5_6_VERSION}"
	"${HIP_5_5_VERSION}"
	"${HIP_5_4_VERSION}"
	"${HIP_5_3_VERSION}"
	"${HIP_5_2_VERSION}"
	"${HIP_5_1_VERSION}"
	"${HIP_4_5_VERSION}"
	"${HIP_4_1_VERSION}"
)
gen_rocm_iuse() {
	for ver in ${ROCM_VERSIONS[@]} ; do
		local s="${ver//./_}"
		s="${s%_*}"
		echo "
			rocm_${s}
		"
	done
}
ROCM_IUSE=(
	$(gen_rocm_iuse)
)
UCG_COMMIT="aaa65c30af52115aa601c9b17529cb295797864f"

inherit autotools check-compiler-switch dep-prepare flag-o-matic rocm linux-info toolchain-funcs

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${PN}-${MY_PV}"
SRC_URI="
https://github.com/openucx/ucx/releases/download/v${PV}/${P}.tar.gz
https://github.com/openucx/xucg/archive/${UCG_COMMIT}.tar.gz
	-> xucg-${UCG_COMMIT:0:7}.tar.gz
"

DESCRIPTION="Unified Communication X is a network High Performance Computing (HPC) framework"
HOMEPAGE="https://openucx.org"
LICENSE="BSD"
SLOT="0"
IUSE="
${CLANG_COMPAT[@]/#/llvm_slot_}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${ROCM_IUSE[@]}
clang +cma cuda custom-kernel dc debug devx dm dmabuf fuse3 gcc examples gdrcopy
hip-clang knem mlx5-dv +numa +openmp rc rdma rocm roce threads tm ud verbs xpmem
video_cards_intel
ebuild_revision_5
"
get_cuda_targets_required_use() {
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		echo "
			cuda_targets_${x}? (
				cuda
			)
		"
	done
}
gen_rocm_iuse_required_use() {
	local u
	for u in ${ROCM_IUSE[@]} ; do
		echo "
			${u}? (
				rocm
			)
		"
	done
}
REQUIRED_USE="
	$(gen_rocm_iuse_required_use)
	$(get_cuda_targets_required_use)
	?? (
		cuda
		rocm
	)
	^^ (
		gcc
		clang
		hip-clang
	)
	clang? (
		^^ (
			${CLANG_COMPAT[@]/#/llvm_slot_}
		)
	)
	cuda? (
		gcc
	)
	gdrcopy? (
		cuda
		rdma
	)
	rdma? (
		dmabuf
		|| (
			roce
			verbs
		)
		|| (
			cuda
			rocm
		)
	)
	rocm? (
		|| (
			${ROCM_IUSE[@]}
		)
	)
"
gen_rocm_rdepend() {
	local u
	for u in ${ROCM_IUSE[@]} ; do
		local s
		s="${u/rocm_}"
		s="${s//./_}"
		echo "
			${u}? (
				dev-util/hip:${s}
			)
		"
	done
}
CUDA_TOOLKIT_11_8_DEPENDS="
	(
		=dev-util/nvidia-cuda-toolkit-11.8*
		=sys-devel/gcc-12*
	)
"
CUDA_TOOLKIT_12_3_DEPENDS="
	(
		=dev-util/nvidia-cuda-toolkit-12.3*
		=sys-devel/gcc-12*
	)
"
CUDA_TOOLKIT_12_4_DEPENDS="
	(
		=dev-util/nvidia-cuda-toolkit-12.4*
		=sys-devel/gcc-13*
	)
"
CUDA_TOOLKIT_12_5_DEPENDS="
	(
		=dev-util/nvidia-cuda-toolkit-12.5*
		=sys-devel/gcc-13*
	)
"
ROCM_KFD_DEPEND="
	rocm_6_2? (
		rdma? (
			|| (
				virtual/kfd:6.2
				virtual/kfd:6.1
				virtual/kfd:6.0
			)
		)
	)
	rocm_6_1? (
		rdma? (
			|| (
				virtual/kfd:6.2
				virtual/kfd:6.1
				virtual/kfd:6.0
				virtual/kfd:5.7
			)
		)
	)
	rocm_6_0? (
		rdma? (
			|| (
				virtual/kfd:6.2
				virtual/kfd:6.1
				virtual/kfd:6.0
				virtual/kfd:5.7
				virtual/kfd:5.6
			)
		)
	)
	rocm_5_7? (
		rdma? (
			|| (
				virtual/kfd:6.1
				virtual/kfd:6.0
				virtual/kfd:5.7
				virtual/kfd:5.6
				virtual/kfd:5.5
			)
		)
	)
	rocm_5_6? (
		rdma? (
			|| (
				virtual/kfd:6.0
				virtual/kfd:5.7
				virtual/kfd:5.6
				virtual/kfd:5.5
				virtual/kfd:5.4
			)
		)
	)
	rocm_5_5? (
		rdma? (
			|| (
				virtual/kfd:5.7
				virtual/kfd:5.6
				virtual/kfd:5.5
				virtual/kfd:5.4
				virtual/kfd:5.3
			)
		)
	)
	rocm_5_4? (
		rdma? (
			|| (
				virtual/kfd:5.6
				virtual/kfd:5.5
				virtual/kfd:5.4
				virtual/kfd:5.3
				virtual/kfd:5.2
			)
		)
	)
	rocm_5_3? (
		rdma? (
			|| (
				virtual/kfd:5.5
				virtual/kfd:5.4
				virtual/kfd:5.3
				virtual/kfd:5.2
				virtual/kfd:5.1
			)
		)
	)
	rocm_5_2? (
		rdma? (
			virtual/kfd:5.2
		)
	)
	rocm_5_1? (
		rdma? (
			virtual/kfd:5.1
		)
	)
	rocm_4_5? (
		rdma? (
			virtual/kfd:4.5
		)
	)
	rocm_4_1? (
		rdma? (
			virtual/kfd:4.1
		)
	)
"
RDEPEND="
	${ROCM_KFD_DEPEND}
	$(gen_rocm_rdepend)
	cma? (
		>=sys-libs/glibc-2.15
	)
	cuda_targets_sm_35? (
		${CUDA_TOOLKIT_11_8_DEPENDS}
	)
	cuda_targets_sm_60? (
		|| (
			${CUDA_TOOLKIT_11_8_DEPENDS}
			${CUDA_TOOLKIT_12_3_DEPENDS}
			${CUDA_TOOLKIT_12_4_DEPENDS}
			${CUDA_TOOLKIT_12_5_DEPENDS}
		)
	)
	cuda_targets_sm_70? (
		|| (
			${CUDA_TOOLKIT_11_8_DEPENDS}
			${CUDA_TOOLKIT_12_3_DEPENDS}
			${CUDA_TOOLKIT_12_4_DEPENDS}
			${CUDA_TOOLKIT_12_5_DEPENDS}
		)
	)
	cuda_targets_sm_72? (
		|| (
			${CUDA_TOOLKIT_11_8_DEPENDS}
			${CUDA_TOOLKIT_12_3_DEPENDS}
			${CUDA_TOOLKIT_12_4_DEPENDS}
			${CUDA_TOOLKIT_12_5_DEPENDS}
		)
	)
	cuda_targets_sm_75? (
		|| (
			${CUDA_TOOLKIT_11_8_DEPENDS}
			${CUDA_TOOLKIT_12_3_DEPENDS}
			${CUDA_TOOLKIT_12_4_DEPENDS}
			${CUDA_TOOLKIT_12_5_DEPENDS}
		)
	)
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-8.0
		dmabuf? (
			>=dev-util/nvidia-cuda-toolkit-11.7[rdma]
			x11-drivers/nvidia-drivers[kernel-open]
		)
		dev-util/nvidia-cuda-toolkit:=
	)
	dc? (
		>=sys-cluster/rdma-core-${RDMA_CORE_PV}
	)
	debug? (
		sys-libs/binutils-libs:=
	)
	devx? (
		>=sys-cluster/rdma-core-${RDMA_CORE_PV}
	)
	dm? (
		>=sys-cluster/rdma-core-${RDMA_CORE_PV}
	)
	dmabuf? (
		!custom-kernel? (
			|| (
				>=sys-kernel/gentoo-sources-5.12
				>=sys-kernel/vanilla-sources-5.12
				>=sys-kernel/git-sources-5.12
				>=sys-kernel/mips-sources-5.12
				>=sys-kernel/pf-sources-5.12
				>=sys-kernel/rt-sources-5.12
				>=sys-kernel/zen-sources-5.12
				>=sys-kernel/raspberrypi-sources-5.12
				>=sys-kernel/gentoo-kernel-5.12
				>=sys-kernel/gentoo-kernel-bin-5.12
				>=sys-kernel/vanilla-kernel-5.12
				>=sys-kernel/linux-next-5.12
				>=sys-kernel/asahi-sources-5.12
				>=sys-kernel/ot-sources-5.12
			)
		)
	)
	gdrcopy? (
		>=dev-libs/gdrcopy-2.3.1
	)
	fuse3? (
		sys-fs/fuse:3
	)
	knem? (
		sys-cluster/knem[modules]
	)
	mlx5-dv? (
		>=sys-cluster/rdma-core-${RDMA_CORE_PV}
	)
	numa? (
		sys-process/numactl
	)
	rc? (
		>=sys-cluster/rdma-core-${RDMA_CORE_PV}
	)
	rocm? (
		>=dev-util/hip-4.0
		dev-util/hip:=
	)
	ud? (
		>=sys-cluster/rdma-core-${RDMA_CORE_PV}
	)
	tm? (
		>=sys-cluster/rdma-core-${RDMA_CORE_PV}
	)
	video_cards_intel? (
		dev-libs/intel-compute-runtime[l0]
		dev-libs/level-zero:=
	)
	verbs? (
		>=sys-cluster/rdma-core-${RDMA_CORE_PV}
	)
"
DEPEND="
	${RDEPEND}
"
gen_clang_bdepend() {
	local s
	for s in ${CLANG_COMPAT[@]} ; do
		echo "
			llvm-core/clang:${s}
			llvm-core/llvm:${s}
			llvm-core/lld:${s}
			openmp? (
				llvm-runtimes/openmp:${s}
			)
		"
	done
}
gen_hip_clang_bdepend() {
	local pv
	for pv in ${ROCM_VERSIONS[@]} ; do
		echo "
			=sys-devel/gcc-12*
			~sys-devel/llvm-roc-${pv}:${pv%.*}
			openmp? (
				~sys-libs/llvm-roc-libomp-${pv}:${pv%.*}
			)
		"
	done
}
BDEPEND="
	dev-build/autoconf
	dev-build/automake
	dev-build/libtool
	virtual/pkgconfig
	gcc? (
		sys-devel/gcc[openmp?]
		sys-devel/binutils
	)
	clang? (
		$(gen_clang_bdepend)
	)
	hip-clang? (
		$(gen_hip_clang_bdepend)
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-1.13.0-drop-werror.patch"
	"${FILESDIR}/${PN}-1.17.0-no-rpm-sandbox.patch"
)

pkg_pretend() {
	[[ "${MERGE_TYPE}" != "binary" ]] && use openmp && tc-check-openmp
}

_init_rocm_variables() {
	if use rocm ; then
		local ver
		for ver in ${ROCM_VERSIONS[@]} ; do
			local s="${ver//./_}"
			s="${s%_*}"
			if use "rocm_${s}" ; then
				export ROCM_SLOT="${ver%.*}"
				local n="HIP_${s}_VERSION"
				export ROCM_VERSION="${!n}"
				local m="HIP_${s}_LLVM_SLOT"
				export LLVM_SLOT="${!m}"
				break
			fi
		done
einfo "ROCM_SLOT:  ${ROCM_SLOT}"
einfo "ROCM_VERSION:  ${ROCM_VERSION}"
einfo "LLVM_SLOT:  ${LLVM_SLOT}"
	fi
}

check_libstdcxx() {
	local slot="${1}"
	local gcc_current_profile=$(gcc-config -c)
	local gcc_current_profile_slot=${gcc_current_profile##*-}

	if ver_test "${gcc_current_profile_slot}" -ne "${slot}" ; then
eerror
eerror "You must switch to GCC ${slot}.  Do"
eerror
eerror "  eselect gcc set ${CHOST}-${slot}"
eerror "  source /etc/profile"
eerror
eerror "This is a temporary for ${PN}:${SLOT}.  You must restore it back"
eerror "to the default immediately after this package has been merged."
eerror
		die
	fi
}

pkg_setup() {
	check-compiler-switch_start
	[[ "${MERGE_TYPE}" != "binary" ]] && use openmp && tc-check-openmp
	_init_rocm_variables
	if use clang ; then
		local s
		for s in ${CLANG_COMPAT[@]} ; do
			if use "llvm_slot_${s}" ; then
				LLVM_SLOT="${s}"
				break
			fi
		done
		export PATH=$(echo "${PATH}" \
			| tr ":" "\n" \
			| sed -E -e "\|/usr/lib/llvm|d" \
			| tr "\n" ":")
		export PATH=$(echo "${PATH}" \
			| tr ":" "\n" \
			| sed -E -e "/llvm\/[0-9]+/d" \
			| tr "\n" ":" \
			| sed -e "s|/opt/bin|/opt/bin:${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}/bin|g")
	fi
	if use hip-clang ; then
		rocm_pkg_setup
	fi
	linux-info_pkg_setup

	if use dmabuf ; then
		CONFIG_CHECK="
			~DMA_SHARED_BUFFER
			~DMABUF_MOVE_NOTIFY

			~ZONE_DEVICE
			~64BIT
			~PCI_P2PDMA
		"
		WARNING_DMA_SHARED_BUFFER="CONFIG_DMA_SHARED_BUFFER=y is required for zero-copy RDMA via DMA-BUF."
		WARNING_DMABUF_MOVE_NOTIFY="CONFIG_DMABUF_MOVE_NOTIFY=y is required for zero-copy RDMA via DMA-BUF."
		WARNING_ZONE_DEVICE="CONFIG_ZONE_DEVICE=y is required for zero-copy RDMA via DMA-BUF."
		WARNING_64BIT="CONFIG_64BIT=y is required for zero-copy RDMA via DMA-BUF."
		WARNING_PCI_P2PDMA="CONFIG_PCI_P2PDMA=y is required for zero-copy RDMA via DMA-BUF."
		check_extra_config
	fi

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

src_unpack() {
	unpack ${A}
	dep_prepare_mv "${WORKDIR}/xucg-${UCG_COMMIT}" "${S}/src/ucg"
}

src_prepare() {
	default
	eautoreconf
	if use rocm ; then
		local pv
		for pv in ${ROCM_VERSIONS[@]} ; do
			local s="${pv}"
			s="${s%.*}"
			s="${s/./_}"
			if use "rocm_${s}" ; then
einfo "Copying sources for ROCm ${pv}"
				local ROCM_SLOT="${pv%.*}"
				cp -a "${S}" "${S}_rocm_${s}" || die
			fi
		done
	fi
}

_configure() {
	if use gcc ; then
		local gcc_slot=12
		if use cuda && has_version "=dev-util/nvidia-cuda-toolkit-11.8*" ; then
			gcc_slot="12"
		elif use cuda && has_version "=dev-util/nvidia-cuda-toolkit-12.3*" ; then
			gcc_slot="12"
		elif use cuda && has_version "=dev-util/nvidia-cuda-toolkit-12.4*" ; then
			gcc_slot="13"
		elif use cuda && has_version "=dev-util/nvidia-cuda-toolkit-12.5*" ; then
			gcc_slot="13"
		elif use rocm ; then
			gcc_slot="12"
		fi
		export CC="${CHOST}-gcc-${gcc_slot}"
		export CXX="${CHOST}-g++-${gcc_slot}"
		export CPP="${CC} -E"
		filter-flags '-fuse-ld=bfd'
	elif use clang ; then
		export CC="${CHOST}-clang-${LLVM_SLOT}"
		export CXX="${CHOST}-clang++-${LLVM_SLOT}"
		export CPP="${CC} -E"
		filter-flags '-fuse-ld=lld'
	elif use hip-clang ; then
		export CC="amdclang"
		export CXX="amdclang++"
		export CPP="${CC} -E"
		filter-flags '-fuse-ld=lld'
	fi
	${CC} --version || die
	strip-unsupported-flags

	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if use debug ; then
		filter-flags '-fuse-ld=*'
		append-ldflags '-fuse-ld=bfd'
	fi

	BASE_CFLAGS="" \
	local myconf=(
		$(use_enable cma)
		$(use_enable examples)
		$(use_enable numa)
		$(use_enable openmp)
		$(use_enable threads mt)
		$(use_with dc)
		$(use_with debug bfd)
		$(use_with devx)
		$(use_with dm)
		$(use_with fuse3)
		$(use_with mlx5-dv)
		$(use_with rc)
		$(use_with ud)
		--disable-compiler-opt
		--disable-doxygen-doc
		--without-go
		--without-java
	)

	if [[ "${USE_ROCM}" != "1" ]] && use cuda ; then
		myconf+=(
			$(use_with examples iodemo-cuda)
			--with-cuda="${ESYSROOT}/opt/cuda"
		)
	else
		myconf+=(
			--without-cuda
		)
	fi
	if [[ "${USE_ROCM}" != "1" ]] && use gdrcopy ; then
		myconf+=(
			--with-gdrcopy="${ESYSROOT}/usr"
		)
	else
		myconf+=(
			--without-gdrcopy
		)
	fi

	if use knem ; then
		myconf+=(
			--with-knem="${ESYSROOT}/usr"
		)
	else
		myconf+=(
			--without-knem
		)
	fi

	if use clang && use openmp ; then
		append-flags -I"${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}/include" -fopenmp=libomp
	fi

	if use hip-clang && use openmp ; then
		append-flags -I"${ESYSROOT}/opt/rocm-${ROCM_VERSION}/llvm/include" -fopenmp=libomp
	fi

	if use tm ; then
		myconf+=(
			--with-ib-hw-tm=upstream
		)
	else
		myconf+=(
			--without-ib-hw-tm
		)
	fi

	if use verbs ; then
		myconf+=(
			--with-verbs="${ESYSROOT}/usr"
		)
	else
		myconf+=(
			--without-verbs
		)
	fi

	if use xpmem ; then
		myconf+=(
			--with-xpmem="${ESYSROOT}/usr"
		)
	else
		myconf+=(
			--without-xpmem
		)
	fi

	if [[ "${USE_ROCM}" != "1" ]] && use video_cards_intel ; then
		myconf+=(
			--with-ze="${ESYSROOT}/usr"
		)
	else
		myconf+=(
			--without-ze
		)
	fi

	if [[ "${USE_ROCM}" != "1" ]] && use cuda && has_version "=dev-util/nvidia-cuda-toolkit-11.8*" ; then
		check_libstdcxx 12
	elif [[ "${USE_ROCM}" != "1" ]] && use cuda && has_version "=dev-util/nvidia-cuda-toolkit-12.3*" ; then
		check_libstdcxx 12
	elif [[ "${USE_ROCM}" != "1" ]] && use cuda && has_version "=dev-util/nvidia-cuda-toolkit-12.4*" ; then
		check_libstdcxx 13
	elif [[ "${USE_ROCM}" != "1" ]] && use cuda && has_version "=dev-util/nvidia-cuda-toolkit-12.5*" ; then
		check_libstdcxx 13
	elif [[ "${USE_ROCM}" == "1" ]] && use rocm ; then
		check_libstdcxx 12
	fi

	NVCC_APPEND_FLAGS=""
	if use cuda_targets_sm_35 ; then
		export NVCC_APPEND_FLAGS+=" -arch=sm_35"
	fi
	if use cuda_targets_sm_60 ; then
		export NVCC_APPEND_FLAGS+=" -arch=sm_60"
	fi
	if use cuda_targets_sm_70 ; then
		export NVCC_APPEND_FLAGS+=" -arch=sm_70"
	fi
	if use cuda_targets_sm_72 ; then
		export NVCC_APPEND_FLAGS+=" -arch=sm_72"
	fi
	if use cuda_targets_sm_75 ; then
		export NVCC_APPEND_FLAGS+=" -arch=sm_75"
	fi

	if [[ "${USE_ROCM}" == "1" ]] ; then
		myconf+=(
			--libdir="/opt/rocm-${ROCM_VERSION}/lib"
			--prefix="/opt/rocm-${ROCM_VERSION}"
			--with-rocm="${ESYSROOT}/opt/rocm-${ROCM_VERSION}"
		)

# Fix for:
# checking for hsa_amd_portable_export_dmabuf... no
# checking for hip_runtime.h... no
# configure: WARNING: HIP Runtime not found
		replace-flags '-O*' '-O2'
		filter-flags \
			'-fuse-ld=*' \
			'-Wl,-fuse-ld=*' \
			'-Wl,--as-needed'
		if [[ "${s/_/.}" == "6.2" ]] ; then
			append-flags \
				'-Wl,-fuse-ld=lld' \
				-Wl,-L"${ESYSROOT}${EROCM_PATH}/lib" \
				-Wl,-lhsakmt-staticdrm \
				-Wl,-ldrm
		else
# Fix:  libhsa-runtime64.so: undefined reference to `hsaKmtWaitOnMultipleEvents_Ext'
			append-flags \
				'-Wl,-fuse-ld=lld'
		fi
	else
		myconf+=(
			--libdir="/usr/$(get_libdir)"
			--prefix="/usr"
			--without-rocm
		)
	fi

	econf ${myconf[@]}
}

_compile() {
	BASE_CFLAGS="" \
	emake
}

src_configure() {
	:
}

src_compile() {
einfo "Building system ucx"
	_configure
	_compile
	if use rocm ; then
		local USE_ROCM=1
		local pv
		for pv in ${ROCM_VERSIONS[@]} ; do
			local s="${pv}"
			s="${s%.*}"
			s="${s/./_}"
			if use "rocm_${s}" ; then
				local ROCM_SLOT="${pv%.*}"
				local rocm_version="HIP_${s}_VERSION"
				local ROCM_VERSION="${!rocm_version}"
				local llvm_slot="HIP_${s}_LLVM_SLOT"
				LLVM_SLOT="${!llvm_slot}"
				pushd "${S}_rocm_${s}" >/dev/null 2>&1 || die
einfo "Building for ROCm ${pv}"
					rocm_pkg_setup
					_configure
					_compile
				popd >/dev/null 2>&1 || die
			fi
		done
		USE_ROCM=0
	fi
}

src_install() {
	default
	if use rocm ; then
		local USE_ROCM=1
		local pv
		for pv in ${ROCM_VERSIONS[@]} ; do
			local s="${pv}"
			s="${s%.*}"
			s="${s/./_}"
			if use "rocm_${s}" ; then
einfo "Installing for ROCm ${pv}"
				local ROCM_SLOT="${pv%.*}"
				local rocm_version="HIP_${s}_VERSION"
				local ROCM_VERSION="${!rocm_version}"
				pushd "${S}_rocm_${s}" >/dev/null 2>&1 || die
					default
				popd >/dev/null 2>&1 || die
				EROCM_PATH="/opt/rocm-${ROCM_VERSION}"
				EROCM_CLANG_PATH="/opt/rocm-${ROCM_VERSION}/llvm/$(rocm_get_libdir)/clang/${CLANG_SLOT}"
				EROCM_LLVM_PATH="/opt/rocm-${ROCM_VERSION}/llvm"
				rocm_fix_rpath "${ED}/opt/rocm-${ROCM_VERSION}"
			fi
		done
		USE_ROCM=0
	fi
	find "${ED}" -type f -name '*.la' -delete || die
}
