# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GCC_COMPAT=(
	"gcc_slot_12_5" # Equivalent to GLIBCXX 3.4.30 in prebuilt binary for U22
	"gcc_slot_13_4" # Equivalent to GLIBCXX 3.4.32 in prebuilt binary for U24
)
LLVM_TARGETS_CPU_COMPAT=(
	llvm_targets_X86
)
LLVM_TARGETS_GPU_COMPAT=(
	llvm_targets_AMDGPU
	llvm_targets_NVPTX
)

IUSE+="
${LLVM_TARGETS_CPU_COMPAT[@]}
${LLVM_TARGETS_GPU_COMPAT[@]}
"

LLVM_TARGETS_USEDEP=""
_llvm_roc_libomp_globals() {
	local u
	for u in ${LLVM_TARGETS_CPU_COMPAT[@]} ${LLVM_TARGETS_GPU_COMPAT[@]} ; do
		LLVM_TARGETS_USEDEP+=",${u}?"
	done
	LLVM_TARGETS_USEDEP="${LLVM_TARGETS_USEDEP:1}"
	readonly LLVM_TARGETS_USEDEP
}
_llvm_roc_libomp_globals
unset -f _llvm_roc_libomp_globals

# Cuda compatibility:
# https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-7.0.2/clang/include/clang/Basic/Cuda.h
# CUDA targets:  https://github.com/ROCm/llvm-project/blob/rocm-7.0.2/offload/hostexec/CMakeLists.txt#L134
# ROCm targets:  https://github.com/ROCm/llvm-project/blob/rocm-7.0.2/offload/hostexec/CMakeLists.txt#L129

AMDGPU_TARGETS_COMPAT=(
	gfx700
	gfx701
	gfx801
	gfx803
	gfx900
	gfx902
	gfx906
	gfx908
	gfx90a
	gfx90c
	gfx940
	gfx941
	gfx942
	gfx950
	gfx1010
	gfx1030
	gfx1031
	gfx1032
	gfx1033
	gfx1034
	gfx1035
	gfx1036
	gfx1100
	gfx1101
	gfx1102
	gfx1103
	gfx1150
	gfx1151
	gfx1152
	gfx1153
	gfx1200
	gfx1201
)
CMAKE_BUILD_TYPE="RelWithDebInfo"
CUDA_TARGETS_COMPAT=(
	sm_35
	sm_37
	sm_50
	sm_52
	sm_53
	sm_60
	sm_61
	sm_62
	sm_70
	sm_72
	sm_75
	sm_80
	sm_86
	sm_89
	sm_90
)
LLVM_SLOT=19
PYTHON_COMPAT=( "python3_12" )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_USE_LLVM_ROC=1

inherit check-compiler-switch cmake flag-o-matic libstdcxx-slot python-single-r1 rocm

#KEYWORDS="~amd64" # Update is WIP
S="${WORKDIR}/llvm-project-rocm-${PV}/openmp"
S_DEVICELIBS="${WORKDIR}/llvm-project-rocm-${PV}/amd/device-libs"
S_ROOT="${WORKDIR}/llvm-project-rocm-${PV}"
SRC_URI="
https://github.com/RadeonOpenCompute/llvm-project/archive/rocm-${PV}.tar.gz
	-> llvm-project-rocm-${PV}.tar.gz
"

DESCRIPTION="The ROCm™ fork of LLVM's libomp"
HOMEPAGE="
	https://github.com/RadeonOpenCompute/llvm-project
"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	BSD
	custom
	MIT
	rc
	public-domain
	UoI-NCSA
"
# Apache-2.0-with-LLVM-exceptions, UoI-NCSA, MIT, custom - llvm-project-rocm-7.0.2/openmp/LICENSE.TXT
#   Keyword search:  "all right, title, and interest"
RESTRICT="
	strip
"
SLOT="0/${ROCM_SLOT}"
LLVM_TARGETS=(
	AMDGPU
	X86
)
IUSE+="
${LLVM_TARGETS[@]/#/llvm_targets_}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${ROCM_IUSE}
+archer -cuda +gdb-plugin -offload -ompt +ompd -rpc
ebuild_revision_29
"

gen_cuda_required_use() {
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		echo "
			cuda_targets_${x}? (
				llvm_targets_NVPTX
			)
		"
	done
}
gen_rocm_required_use() {
	local x
	for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		echo "
			amdgpu_targets_${x}? (
				llvm_targets_AMDGPU
			)
		"
	done
}
REQUIRED_USE="
	$(gen_cuda_required_use)
	$(gen_rocm_required_use)
	offload
	cuda? (
		llvm_targets_NVPTX
	)
	gdb-plugin? (
		${PYTHON_REQUIRED_USE}
		ompd
	)
	llvm_targets_AMDGPU? (
		${ROCM_REQUIRED_USE}
	)
	llvm_targets_NVPTX? (
		cuda
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	ompd? (
		ompt
	)
	rpc? (
		offload
	)
	^^ (
		${LLVM_TARGETS_CPU_COMPAT[@]}
	)
"
CUDA_11_8_RDEPEND="
	(
		=dev-util/nvidia-cuda-toolkit-11.8*
		dev-util/nvidia-cuda-toolkit:=
	)
"
CUDA_12_3_RDEPEND="
	(
		=dev-util/nvidia-cuda-toolkit-12.3*
		dev-util/nvidia-cuda-toolkit:=
	)
"
CUDA_12_4_RDEPEND="
	(
		=dev-util/nvidia-cuda-toolkit-12.4*
		dev-util/nvidia-cuda-toolkit:=
	)
"
CUDA_12_5_RDEPEND="
	(
		=dev-util/nvidia-cuda-toolkit-12.5*
		dev-util/nvidia-cuda-toolkit:=
	)
"
RDEPEND="
	>=dev-libs/rocm-device-libs-${PV}:${SLOT}
	dev-libs/rocm-device-libs:=
	>=sys-devel/llvm-roc-${PV}:${SLOT}[${LLVM_TARGETS_USEDEP}]
	sys-devel/llvm-roc:=
	cuda_targets_sm_35? (
		${CUDA_11_8_RDEPEND}
	)
	cuda_targets_sm_37? (
		${CUDA_11_8_RDEPEND}
	)
	cuda_targets_sm_50? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
			${CUDA_12_4_RDEPEND}
			${CUDA_12_5_RDEPEND}
		)
	)
	cuda_targets_sm_52? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
			${CUDA_12_4_RDEPEND}
			${CUDA_12_5_RDEPEND}
		)
	)
	cuda_targets_sm_53? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
			${CUDA_12_4_RDEPEND}
			${CUDA_12_5_RDEPEND}
		)
	)
	cuda_targets_sm_60? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
			${CUDA_12_4_RDEPEND}
			${CUDA_12_5_RDEPEND}
		)
	)
	cuda_targets_sm_61? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
			${CUDA_12_4_RDEPEND}
			${CUDA_12_5_RDEPEND}
		)
	)
	cuda_targets_sm_62? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
			${CUDA_12_4_RDEPEND}
			${CUDA_12_5_RDEPEND}
		)
	)
	cuda_targets_sm_70? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
			${CUDA_12_4_RDEPEND}
			${CUDA_12_5_RDEPEND}
		)
	)
	cuda_targets_sm_72? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
			${CUDA_12_4_RDEPEND}
			${CUDA_12_5_RDEPEND}
		)
	)
	cuda_targets_sm_75? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
			${CUDA_12_4_RDEPEND}
			${CUDA_12_5_RDEPEND}
		)
	)
	cuda_targets_sm_80? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
			${CUDA_12_4_RDEPEND}
			${CUDA_12_5_RDEPEND}
		)
	)
	cuda_targets_sm_86? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
			${CUDA_12_4_RDEPEND}
			${CUDA_12_5_RDEPEND}
		)
	)
	cuda_targets_sm_89? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
			${CUDA_12_4_RDEPEND}
			${CUDA_12_5_RDEPEND}
		)
	)
	cuda_targets_sm_90? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
			${CUDA_12_4_RDEPEND}
			${CUDA_12_5_RDEPEND}
		)
	)
	llvm_targets_AMDGPU? (
		>=dev-libs/rocr-runtime-${ROCM_SLOT}:${SLOT}
		dev-libs/rocr-runtime:=
		sys-process/numactl
		x11-libs/libdrm[video_cards_amdgpu]
	)
	llvm_targets_NVPTX? (
		<dev-util/nvidia-cuda-toolkit-11.9:=
	)
	offload? (
		dev-libs/libffi:=
		virtual/libelf:=
	)
	rpc? (
		net-libs/grpc[${LIBSTDCXX_USEDEP},cxx]
		virtual/grpc:=
	)
"
# The versions for protobuf and grpc was not disclosed in build files.
# Originally >=net-libs/grpc-1.49.3:=[cxx]
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${ROCM_GCC_DEPEND}
	offload? (
		virtual/pkgconfig
	)
	|| (
		llvm-core/lld:${LLVM_SLOT}
		(
			>=sys-devel/llvm-roc-${PV}:${SLOT}[${LLVM_TARGETS_USEDEP}]
			sys-devel/llvm-roc:=
		)
	)
"
PATCHES=(
)

gen_nvptx_list() {
	if use cuda_targets_auto ; then
		echo "auto"
	else
		local list
		local x
		for x in ${CUDA_TARGETS_COMPAT[@]} ; do
			if use "cuda_targets_${x}" ; then
				list+=";${x/sm_}"
			fi
		done
		list="${list:1}"
		echo "${list}"
	fi
}

pkg_setup() {
	check-compiler-switch_start
	rocm_pkg_setup
	python-single-r1_pkg_setup
	libstdcxx-slot_verify
}

src_prepare() {
	cd "${S_ROOT}" || die
#	eapply "${FILESDIR}/llvm-roc-libomp-5.6.0-ompt-includes.patch"
#	eapply "${FILESDIR}/llvm-roc-libomp-6.2.0-omp-tools-includes.patch"
#	eapply "${FILESDIR}/llvm-roc-libomp-5.6.0-omp.h-includes.patch"
#	eapply "${FILESDIR}/llvm-roc-libomp-5.1.3-libomptarget-includes-path.patch"
	cd "${S}" || die
	cmake_src_prepare

	rocm_src_prepare
#	if ! use llvm_targets_NVPTX ; then
#		sed -i \
#			-e "\|/nvidia-arch|d" \
#			"${S_ROOT}/llvm/lib/OffloadArch/offload-arch/CMakeLists.txt" \
#			|| die
#	fi
#	if ! use llvm_targets_AMDGPU ; then
#		sed -i \
#			-e "\|/amdgpu-offload-arch|d" \
#			"${S_ROOT}/llvm/lib/OffloadArch/offload-arch/CMakeLists.txt" \
#			|| die
#	fi

	cd "${WORKDIR}/llvm-project-rocm-${PV}" || die
	local prune_dirs=(
		"bolt"
		"clang"
		"clang-tools-extra"
		#"cmake"
		"compiler-rt"
		"cross-project-tests"
		"flang"
		"libc"
		"libclc"
		"libcxx"
		"libcxxabi"
		"libunwind"
		"lld"
		"lldb"
		#"llvm"
		"llvm-libgcc"
		"mlir"
		#"openmp"
		"polly"
		"pstl"
		#"rocm-device-libs"
		"runtimes"
		"third-party"
		"utils"
	)
	rm -rf ${prune_dirs[@]} || die
	mkdir -p "t"
	mv "llvm/include/" "t" || die
	mkdir -p "llvm" || die
	mv "t/include" "llvm" || die
	rm -rf t
}

src_configure() {
	addpredict "/dev/kfd"
	addpredict "/proc/self/task/"
	rocm_set_default_gcc

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if ! check-compiler-switch_is_system_flavor ; then
einfo "Detected GPU compiler switch.  Disabling LTO."
		filter-lto
	fi

	replace-flags '-O0' '-O1'

# Fixes:
# ld.bfd: duplicate version tag `VERS1.0'
	filter-flags '-fuse-ld=*'
	append-ldflags -fuse-ld=lld
	strip-unsupported-flags # Filter LDFLAGS

	append-flags -I"/usr/$(get_libdir)/libffi/include"

# Fix
# /usr/bin/python3.12: No module named pip
	export PYTHONPATH="${ESYSROOT}/usr/lib/${EPYTHON}/site-packages/:${PYTHONPATH}"
	export PYTHONPATH="${ESYSROOT}/${EROCM_PATH}/lib/${EPYTHON}/site-packages:${PYTHONPATH}"

	PROJECTS="openmp"
	local experimental_targets=""
	if use llvm_targets_X86 ; then
		experimental_targets+=";X86"
	fi
	if use llvm_targets_AMDGPU ; then
		experimental_targets+=";AMDGPU"
	fi
	if use llvm_targets_NVPTX ; then
		experimental_targets+=";NVPTX"
	fi
	experimental_targets="${experimental_targets:1}"
	local libdir="$(rocm_get_libdir)"
	local mycmakeargs=(
#		-DBUILD_SHARED_LIBS=OFF
		-DCMAKE_C_COMPILER="${CHOST}-gcc"
		-DCMAKE_CXX_COMPILER="${CHOST}-g++"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}/llvm"
		-DLIBOMP_OMPD_GDB_SUPPORT=$(usex gdb-plugin ON OFF)
		-DLIBOMP_OMPD_SUPPORT=$(usex ompd ON OFF)
		-DLIBOMP_OMPT_SUPPORT=$(usex ompt ON OFF)
		-DLLVM_BUILD_DOCS=OFF
#		-DLLVM_BUILD_LLVM_DYLIB=ON
		-DLLVM_ENABLE_ASSERTIONS=ON # For mlir
		-DLLVM_ENABLE_DOXYGEN=OFF
		-DLLVM_ENABLE_OCAMLDOC=OFF
		-DLLVM_ENABLE_PROJECTS="${PROJECTS}"
		-DLLVM_ENABLE_SPHINX=OFF
		-DLLVM_ENABLE_ZSTD=OFF # For mlir
		-DLLVM_ENABLE_ZLIB=OFF # For mlir
		-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="${experimental_targets}"
		-DLLVM_EXTERNAL_LIT="/usr/bin/lit"
#		-DLLVM_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}/llvm/$(rocm_get_libdir)/cmake/llvm"
		-DLLVM_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}/llvm"
		-DLLVM_INSTALL_UTILS=OFF
#		-DLLVM_LINK_LLVM_DYLIB=ON
		-DLLVM_TARGETS_TO_BUILD=""
#		-DLLVM_VERSION_SUFFIX=roc
		-DOCAMLFIND=OFF
		-DOPENMP_ENABLE_LIBOMPTARGET=$(usex offload ON OFF)
		-DOPENMP_LIBDIR_SUFFIX="${libdir#lib}"
		-DPython3_EXECUTABLE="${PYTHON}"
	)
	if use offload && has "${CHOST%%-*}" aarch64 powerpc64le x86_64 ; then
		mycmakeargs+=(
			-DLIBOMPTARGET_BUILD_AMDGPU_PLUGIN=$(usex llvm_targets_AMDGPU)
			-DLIBOMPTARGET_BUILD_CUDA_PLUGIN=$(usex llvm_targets_NVPTX)
			-DLIBOMPTARGET_ENABLE_EXPERIMENTAL_REMOTE_PLUGIN=$(usex rpc)
			-DLIBOMPTARGET_OMPT_SUPPORT=$(usex ompt ON OFF)
			-DOPENMP_ENABLE_LIBOMPTARGET=ON
		)
		if use llvm_targets_AMDGPU ; then
			mycmakeargs+=(
				-DAMDDeviceLibs_DIR="${ESYSROOT}${EROCM_PATH}/$(rocm_get_libdir)/cmake/AMDDeviceLibs"
				-DDEVICELIBS_ROOT="${S_DEVICELIBS}"
				-DLIBOMPTARGET_AMDGCN_GFXLIST=$(get_amdgpu_flags)
			)
			if ! use llvm_targets_NVPTX ; then
	# Workaround
	# For error:
	#/opt/rocm-5.7.1/llvm/lib/clang/17.0.0/include/__clang_cuda_device_functions.h:697:10: error: '__nvvm_atom_sys_add_gen_ll' needs target feature sm_60|sm_61|sm_62|sm_70|sm_72|sm_75|sm_80|sm_86|sm_87|sm_89|sm_90
				mycmakeargs+=(
					-DLIBOMPTARGET_NVPTX_COMPUTE_CAPABILITIES="60"
				)
			fi
		fi
		if use llvm_targets_NVPTX ; then
			mycmakeargs+=(
				-DLIBOMPTARGET_NVPTX_COMPUTE_CAPABILITIES=$(gen_nvptx_list)
			)
		fi
	else
		mycmakeargs+=(
			-DCMAKE_DISABLE_FIND_PACKAGE_CUDA=ON
			-DLIBOMPTARGET_BUILD_AMDGPU_PLUGIN=OFF
			-DLIBOMPTARGET_BUILD_CUDA_PLUGIN=OFF
			-DLIBOMPTARGET_ENABLE_EXPERIMENTAL_REMOTE_PLUGIN=OFF
			-DOPENMP_ENABLE_LIBOMPTARGET=OFF
		)
	fi
	einfo "CONFIGURE START ${mycmakeargs[@]}"
	cmake_src_configure
	einfo "CONFIGURE DONE"
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
