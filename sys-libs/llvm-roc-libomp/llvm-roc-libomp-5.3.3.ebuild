# Copyright 1999-2021 Gentoo Authors
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
# https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.3.3/clang/include/clang/Basic/Cuda.h
# CUDA targets:  https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.3.3/openmp/libomptarget/DeviceRTL/CMakeLists.txt#L59
# ROCm targets:  https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.3.3/openmp/libomptarget/DeviceRTL/CMakeLists.txt#L83

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
	gfx1010
	gfx1030
	gfx1031
	gfx1032
	gfx1033
	gfx1034
	gfx1035
	gfx1036
)
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
LLVM_MAX_SLOT=15
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake flag-o-matic rocm

SRC_URI="
https://github.com/RadeonOpenCompute/llvm-project/archive/rocm-${PV}.tar.gz
	-> llvm-project-rocm-${PV}.tar.gz
https://github.com/RadeonOpenCompute/ROCm-Device-Libs/archive/refs/tags/rocm-${PV}.tar.gz
	-> rocm-device-libs-${PV}.tar.gz
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
# Apache-2.0-with-LLVM-exceptions, UoI-NCSA, MIT, custom - llvm-project-rocm-5.6.0/openmp/LICENSE.TXT
#   Keyword search:  "all right, title, and interest"
KEYWORDS="~amd64"
SLOT="${ROCM_SLOT}/${PV}"
LLVM_TARGETS=(
	AMDGPU
	X86
)
IUSE+="
${LLVM_TARGETS[@]/#/llvm_targets_}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${ROCM_IUSE}
-cuda -offload -ompt +ompd
r5
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
	llvm_targets_NVPTX? (
		<dev-util/nvidia-cuda-toolkit-11.6:=
	)
	offload? (
		dev-libs/libffi:=
		virtual/libelf:=
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/gcc
	offload? (
		virtual/pkgconfig
	)
"
PATCHES=(
)
S="${WORKDIR}/llvm-project-rocm-${PV}/llvm"
S_DEVICELIBS="${WORKDIR}/ROCm-Device-Libs-rocm-${PV}"
S_ROOT="${WORKDIR}/llvm-project-rocm-${PV}"
CMAKE_BUILD_TYPE="RelWithDebInfo"

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

src_prepare() {
	cd "${S_ROOT}" || die
	eapply "${FILESDIR}/llvm-roc-libomp-5.6.0-ompt-includes.patch"
	eapply "${FILESDIR}/llvm-roc-libomp-5.3.3-omp-tools-includes.patch"
	eapply "${FILESDIR}/llvm-roc-5.5.1-path-changes.patch"
	eapply "${FILESDIR}/llvm-roc-libomp-5.6.0-omp.h-includes.patch"
	cd "${S}" || die
	cmake_src_prepare

	PATCH_PATHS=(
		"${S_ROOT}/clang/lib/Driver/ToolChains/AMDGPU.cpp"
		"${S_ROOT}/clang/lib/Driver/ToolChains/AMDGPUOpenMP.cpp"
		"${S_ROOT}/compiler-rt/test/asan/lit.cfg.py"
		"${S_ROOT}/mlir/lib/Dialect/GPU/Transforms/SerializeToHsaco.cpp"
		"${S_ROOT}/openmp/libomptarget/CMakeLists.txt"
		"${S_ROOT}/openmp/libomptarget/deviceRTLs/libm/CMakeLists.txt"
		"${S_ROOT}/openmp/libomptarget/src/CMakeLists.txt"
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
}

src_configure() {
	addpredict /dev/kfd
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	filter-flags "-fuse-ld=*"
	strip-unsupported-flags
	replace-flags '-O0' '-O1'
# Avoid
# The dependency target "clang" of target "check-all" does not exist.
	PROJECTS="clang;openmp"
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
	local libdir="$(get_libdir)"
	local mycmakeargs=(
#		-DBUILD_SHARED_LIBS=OFF
		-DCMAKE_C_COMPILER="${CHOST}-gcc"
		-DCMAKE_CXX_COMPILER="${CHOST}-g++"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}/llvm"
		-DLIBOMP_OMPD_SUPPORT=$(usex ompd ON OFF)
		-DLIBOMP_OMPT_SUPPORT=$(usex ompt ON OFF)
		-DLLVM_BUILD_DOCS=NO
#		-DLLVM_BUILD_LLVM_DYLIB=ON
		-DLLVM_ENABLE_ASSERTIONS=ON # For mlir
		-DLLVM_ENABLE_DOXYGEN=OFF
		-DLLVM_ENABLE_OCAMLDOC=OFF
		-DLLVM_ENABLE_PROJECTS="${PROJECTS}"
		-DLLVM_ENABLE_SPHINX=NO
		-DLLVM_ENABLE_ZSTD=OFF # For mlir
		-DLLVM_ENABLE_ZLIB=OFF # For mlir
		-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="${experimental_targets}"
		-DLLVM_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}/llvm/lib/cmake/llvm"
		-DLLVM_INSTALL_UTILS=ON
#		-DLLVM_LINK_LLVM_DYLIB=ON
		-DLLVM_TARGETS_TO_BUILD=""
#		-DLLVM_VERSION_SUFFIX=roc
		-DOCAMLFIND=NO
		-DOPENMP_ENABLE_LIBOMPTARGET=$(usex offload ON OFF)
		-DOPENMP_LIBDIR_SUFFIX="${libdir#lib}"
	)
	if use offload && has "${CHOST%%-*}" aarch64 powerpc64le x86_64 ; then
		mycmakeargs+=(
			-DLIBOMPTARGET_BUILD_AMDGPU_PLUGIN=$(usex llvm_targets_AMDGPU)
			-DLIBOMPTARGET_BUILD_CUDA_PLUGIN=$(usex llvm_targets_NVPTX)
			-DLIBOMPTARGET_OMPT_SUPPORT=$(usex ompt ON OFF)
			-DOPENMP_ENABLE_LIBOMPTARGET=ON
		)
		if use llvm_targets_AMDGPU ; then
			mycmakeargs+=(
				-DAMDDeviceLibs_DIR="${ESYSROOT}${EROCM_PATH}/$(get_libdir)/cmake/AMDDeviceLibs"
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
			-DOPENMP_ENABLE_LIBOMPTARGET=OFF
		)
	fi
	cmake_src_configure
}

src_compile() {
	local targets=(
		omp
	)
	if use offload ; then
		targets+=(
			LLVMOffloadArch
			bin/offload-arch
			lib/libomptarget.so.${LLVM_MAX_SLOT}roc
			lib/libomptarget.so
		)
		if use llvm_targets_X86 ; then
			targets+=(
				lib/libomptarget.rtl.x86_64.so.${LLVM_MAX_SLOT}roc
				lib/libomptarget.rtl.x86_64.so
			)
		fi
		if use llvm_targets_AMDGPU ; then
			targets+=(
				lib/OffloadArch/offload-arch/amdgpu-offload-arch
				lib/libomptarget.rtl.amdgpu.so.${LLVM_MAX_SLOT}roc
				lib/libomptarget.rtl.amdgpu.so
			)
		fi
		if use llvm_targets_NVPTX ; then
			targets+=(
				lib/OffloadArch/offload-arch/nvidia-arch
				lib/libomptarget.rtl.cuda.so.${LLVM_MAX_SLOT}roc
				lib/libomptarget.rtl.cuda.so
			)
		fi
	fi
	if use ompd ; then
		targets+=(
			ompd
		)
	fi
	cmake_src_compile \
		${targets[@]}
}

# From cmake.eclass.  Removed cmake_build install.
# @FUNCTION: cmake_src_install
# @DESCRIPTION:
# Function for installing the package. Automatically detects the build type.
_cmake_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	DESTDIR="${D}" cmake_build "$@"

	if [[ ${EAPI} == 7 ]]; then
		pushd "${S}" > /dev/null || die
		einstalldocs
		popd > /dev/null || die
	else
		pushd "${CMAKE_USE_DIR}" > /dev/null || die
		einstalldocs
		popd > /dev/null || die
	fi
}

src_install() {
	local targets=()
	if use offload ; then
		targets+=(
			install-omptarget
		)
		if use llvm_targets_X86 ; then
			targets+=(
				install-omptarget.rtl.x86_64
			)
		fi
		if use llvm_targets_AMDGPU ; then
			targets+=(
				install-omptarget.rtl.amdgpu
			)
		fi
		if use llvm_targets_NVPTX ; then
			targets+=(
				install-omptarget.rtl.cuda
			)
		fi
		_cmake_src_install \
			${targets[@]}
	fi
	cd "${BUILD_DIR}" || die
	exeinto "${EROCM_PATH}/llvm/lib"
	doexe "lib/"{libgomp.so,libomp.so,libiomp5.so}
	use ompd && doexe "lib/libompd.so"
	insinto "${EROCM_PATH}/llvm/include"
	doins "${S_ROOT}/openmp/runtime/exports/common.dia.ompt.optional/include/omp.h"
	if use ompt ; then
		doins "${S_ROOT}/openmp/runtime/exports/common.dia.ompt.optional/include/omp-tools.h"
	fi
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
