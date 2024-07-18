# Copyright 1999-2021,2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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
# https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.2.3/clang/include/clang/Basic/Cuda.h
# CUDA targets:  https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.2.3/openmp/libomptarget/DeviceRTL/CMakeLists.txt#L59
# ROCm targets:  https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.2.3/openmp/libomptarget/DeviceRTL/CMakeLists.txt#L99

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
	gfx1030
	gfx1031
	gfx1036
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
	auto
)
LLVM_SLOT=14
PYTHON_COMPAT=( "python3_"{10..12} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_USE_LLVM_ROC=1

inherit cmake flag-o-matic python-single-r1 rocm

KEYWORDS="~amd64"
S="${WORKDIR}/llvm-project-rocm-${PV}/openmp"
S_DEVICELIBS="${WORKDIR}/ROCm-Device-Libs-rocm-${PV}"
S_ROOT="${WORKDIR}/llvm-project-rocm-${PV}"
SRC_URI="
https://github.com/RadeonOpenCompute/llvm-project/archive/rocm-${PV}.tar.gz
	-> llvm-project-rocm-${PV}.tar.gz
https://github.com/RadeonOpenCompute/ROCm-Device-Libs/archive/refs/tags/rocm-${PV}.tar.gz
	-> rocm-device-libs-${PV}.tar.gz
https://github.com/llvm/llvm-project/commit/c23147106f7efc4b5e29c47a08951116b4d994ac.patch
	-> llvm-project-rocm-c231471.patch
"
# c231471 -  [clang][CUDA][Windows] Fix compilation error on Windows with `uint32_t __nvvm_get_smem_pointer`
#   Fix for HIPIFY

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
# Apache-2.0-with-LLVM-exceptions, UoI-NCSA, MIT, custom - llvm-project-rocm-5.6.0/openmp/LICENSE.TXT
#   Keyword search:  "all right, title, and interest"
RESTRICT="
	strip
"
SLOT="${ROCM_SLOT}/${PV}"
LLVM_TARGETS=(
	AMDGPU
	X86
)
IUSE+="
${LLVM_TARGETS[@]/#/llvm_targets_}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${ROCM_IUSE}
+archer -cuda -cuda_11_7 +gdb-plugin -offload -ompt +ompd -rpc
ebuild-revision-25
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
RDEPEND="
	~dev-libs/rocm-device-libs-${PV}:${ROCM_SLOT}
	~sys-devel/llvm-roc-${PV}:${ROCM_SLOT}[${LLVM_TARGETS_USEDEP}]
	cuda_targets_sm_35? (
		=dev-util/nvidia-cuda-toolkit-11*:=
	)
	cuda_targets_sm_37? (
		=dev-util/nvidia-cuda-toolkit-11*:=
	)
	cuda_targets_sm_50? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_52? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_53? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_60? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_61? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_62? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_70? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_72? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_75? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_80? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_86? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	llvm_targets_AMDGPU? (
		dev-libs/roct-thunk-interface:${ROCM_SLOT}
	)
	llvm_targets_NVPTX? (
		<dev-util/nvidia-cuda-toolkit-11.9:=
	)
	offload? (
		dev-libs/libffi:=
		virtual/libelf:=
	)
	rpc? (
		dev-libs/protobuf:0/3.21
		|| (
			=net-libs/grpc-1.49*[cxx]
			=net-libs/grpc-1.52*[cxx]
			=net-libs/grpc-1.53*[cxx]
			=net-libs/grpc-1.54*[cxx]
		)
		net-libs/grpc:=
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
	rocm_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	pushd "${WORKDIR}/llvm-project-rocm-${PV}" >/dev/null 2>&1 || die
		eapply "${FILESDIR}/${PN}-5.2.3-hardcoded-paths.patch"
	popd >/dev/null 2>&1 || die

	if use cuda_11_7 ; then
		pushd "${WORKDIR}/llvm-project-rocm-${PV}" >/dev/null 2>&1 || die
			eapply "${DISTDIR}/llvm-project-rocm-c231471.patch"
		popd >/dev/null 2>&1 || die
	fi

	cd "${S_ROOT}" || die
#	eapply "${FILESDIR}/llvm-roc-libomp-5.6.0-ompt-includes.patch"
	eapply "${FILESDIR}/llvm-roc-libomp-5.2.3-omp-tools-includes.patch"
	eapply "${FILESDIR}/llvm-roc-libomp-5.2.3-libomptarget-includes-path.patch"
	eapply "${FILESDIR}/llvm-roc-libomp-5.2.3-libomptarget-prep-libomptarget-bc-link-directory.patch"
	cd "${S}" || die
	cmake_src_prepare

	# Speed up symbol replacmenet for @...@ by reducing the search space
	# Generated from below one liner ran in the same folder as this file:
	# grep -F -r -e "+++" | cut -f 2 -d " " | cut -f 1 -d $'\t' | sort | uniq | cut -f 2- -d $'/' | sort | uniq
	PATCH_PATHS=(
		"${S_ROOT}/clang/tools/amdgpu-arch/CMakeLists.txt"
		"${S_ROOT}/compiler-rt/CMakeLists.txt"
		"${S_ROOT}/libc/cmake/modules/prepare_libc_gpu_build.cmake"
		"${S_ROOT}/libc/src/math/gpu/vendor/CMakeLists.txt"
		"${S_ROOT}/libc/utils/gpu/loader/CMakeLists.txt"
		"${S_ROOT}/mlir/lib/Dialect/GPU/CMakeLists.txt"
		"${S_ROOT}/mlir/lib/ExecutionEngine/CMakeLists.txt"
		"${S_ROOT}/openmp/libomptarget/CMakeLists.txt"
		"${S_ROOT}/openmp/libomptarget/DeviceRTL/CMakeLists.txt"
		"${S_ROOT}/openmp/libomptarget/deviceRTLs/amdgcn/CMakeLists.txt"
		"${S_ROOT}/openmp/libomptarget/hostexec/CMakeLists.txt"
		"${S_ROOT}/openmp/libomptarget/hostrpc/services/CMakeLists.txt"
		"${S_ROOT}/openmp/libomptarget/libm/CMakeLists.txt"
		"${S_ROOT}/openmp/libomptarget/plugins-nextgen/amdgpu/CMakeLists.txt"
		"${S_ROOT}/openmp/libomptarget/plugins/amdgpu/CMakeLists.txt"
		"${S_ROOT}/openmp/libomptarget/plugins/amdgpu/impl/impl.cpp"
		"${S_ROOT}/openmp/libomptarget/src/CMakeLists.txt"
		"${S_ROOT}/openmp/libomptarget/tools/prep-libomptarget-bc/CMakeLists.txt"
	)
	rocm_src_prepare
	if ! use llvm_targets_NVPTX ; then
		sed -i \
			-e "\|/nvidia-arch|d" \
			"${S_ROOT}/llvm/lib/OffloadArch/offload-arch/CMakeLists.txt" \
			|| die
	fi
	if ! use llvm_targets_AMDGPU ; then
		sed -i \
			-e "\|/amdgpu-offload-arch|d" \
			"${S_ROOT}/llvm/lib/OffloadArch/offload-arch/CMakeLists.txt" \
			|| die
	fi

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
	replace-flags '-O0' '-O1'

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
		-DLLVM_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}/llvm/$(rocm_get_libdir)/cmake/llvm"
		-DLLVM_INSTALL_UTILS=ON
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
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
