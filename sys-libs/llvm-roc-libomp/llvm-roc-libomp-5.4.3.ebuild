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
# https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.4.3/clang/include/clang/Basic/Cuda.h
# CUDA targets:  https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.4.3/openmp/libomptarget/DeviceRTL/CMakeLists.txt#L59
# ROCm targets:  https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.4.3/openmp/libomptarget/DeviceRTL/CMakeLists.txt#L83

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
https://github.com/RadeonOpenCompute/llvm-project/commit/056b229c2c479171ff7bd634321a2c1064f400a0.patch
	-> llvm-roc-commit-056b229.patch
"
# 056b229 - [openmp] - Fix DP issue in amdgpu plugin.

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
+archer -cuda -offload -ompt +ompd -rpc
r13
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
		<dev-util/nvidia-cuda-toolkit-11.6:=
	)
	offload? (
		dev-libs/libffi:=
		virtual/libelf:=
	)
	rpc? (
		>=net-libs/grpc-1.49.3:=
		dev-libs/protobuf:0/32
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
	|| (
		sys-devel/lld:${LLVM_MAX_SLOT}
		~sys-devel/llvm-roc-${PV}:${ROCM_SLOT}[${LLVM_TARGETS_USEDEP}]
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
	eapply "${FILESDIR}/llvm-roc-libomp-5.6.0-omp-tools-includes.patch"
	eapply "${FILESDIR}/llvm-roc-5.4.3-path-changes.patch"
	eapply "${FILESDIR}/llvm-roc-libomp-5.6.0-omp.h-includes.patch"
	eapply "${FILESDIR}/llvm-roc-libomp-5.1.3-libomptarget-includes-path.patch"
	eapply "${FILESDIR}/llvm-roc-libomp-5.2.3-libomptarget-prep-libomptarget-bc-link-directory.patch"
	eapply "${DISTDIR}/llvm-roc-commit-056b229.patch"
	cd "${S}" || die
	cmake_src_prepare

	# Speed up symbol replacmenet for @...@ by reducing the search space
	# Generated from below one liner ran in the same folder as this file:
	# grep -F -r -e "+++" | cut -f 2 -d " " | cut -f 1 -d $'\t' | sort | uniq | cut -f 2- -d $'/' | sort | uniq
	PATCH_PATHS=(
		"${S_ROOT}/clang/lib/Driver/ToolChains/AMDGPU.cpp"
		"${S_ROOT}/clang/lib/Driver/ToolChains/AMDGPUOpenMP.cpp"
		"${S_ROOT}/clang/tools/amdgpu-arch/CMakeLists.txt"
		"${S_ROOT}/compiler-rt/CMakeLists.txt"
		"${S_ROOT}/compiler-rt/test/asan/lit.cfg.py"
		"${S_ROOT}/libc/cmake/modules/prepare_libc_gpu_build.cmake"
		"${S_ROOT}/libc/utils/gpu/loader/CMakeLists.txt"
		"${S_ROOT}/mlir/lib/Dialect/GPU/CMakeLists.txt"
		"${S_ROOT}/mlir/lib/Dialect/GPU/Transforms/SerializeToHsaco.cpp"
		"${S_ROOT}/mlir/lib/ExecutionEngine/CMakeLists.txt"
		"${S_ROOT}/openmp/libomptarget/CMakeLists.txt"
		"${S_ROOT}/openmp/libomptarget/DeviceRTL/CMakeLists.txt"
		"${S_ROOT}/openmp/libomptarget/deviceRTLs/amdgcn/CMakeLists.txt"
		"${S_ROOT}/openmp/libomptarget/deviceRTLs/libm/CMakeLists.txt"
		"${S_ROOT}/openmp/libomptarget/hostexec/CMakeLists.txt"
		"${S_ROOT}/openmp/libomptarget/hostexec/CMakeLists.txt.with400files"
		"${S_ROOT}/openmp/libomptarget/hostrpc/services/CMakeLists.txt"
		"${S_ROOT}/openmp/libomptarget/libm/CMakeLists.txt"
		"${S_ROOT}/openmp/libomptarget/plugins/amdgpu/CMakeLists.txt"
		"${S_ROOT}/openmp/libomptarget/plugins/amdgpu/rtl_test/buildrun.sh"
		"${S_ROOT}/openmp/libomptarget/plugins-nextgen/amdgpu/CMakeLists.txt"
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
}

src_configure() {
	addpredict /dev/kfd
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	filter-flags "-fuse-ld=*"
	strip-unsupported-flags
	replace-flags '-O0' '-O1'
	append-ldflags -fuse-ld=lld # Fix ld: duplicate version tag `VERS1.0'
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
		-DLLVM_EXTERNAL_LIT="/usr/bin/lit"
		-DLLVM_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}/llvm/$(get_libdir)/cmake/llvm"
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
			-DLIBOMPTARGET_ENABLE_EXPERIMENTAL_REMOTE_PLUGIN=$(usex rpc)
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
			-DLIBOMPTARGET_ENABLE_EXPERIMENTAL_REMOTE_PLUGIN=OFF
			-DOPENMP_ENABLE_LIBOMPTARGET=OFF
		)
	fi
	cmake_src_configure
}

# The reason why to do this is to reduce the build cost from 4000 compilation
# units to 1000 units skipping over the already built ones in both src_compile()
# and src_install().
src_compile() {
	local targets
	targets=(
		"omp"
	)
	if use archer ; then
		targets+=(
			"libarcher.so"
			"libarcher_static.a"
		)
	fi
	if use offload ; then
		if use llvm_targets_X86 ; then
			targets+=(
				"libomptarget.rtl.x86_64.so"
				"omptarget.rtl.x86_64"
			)
		fi
		if use llvm_targets_AMDGPU ; then
			local target
			for target in "${AMDGPU_TARGETS_COMPAT[@]}" ; do
				if use "amdgpu_targets_${target}" ; then
					targets+=(
						"libm-amdgcn-${target}.bc"
						"libomptarget-amdgcn-${target}"
						"omptarget-amdgpu-${target}-bc"
					)
				fi
			done
			targets+=(
				"libomptarget.rtl.amdgpu.so"
				"omptarget.devicertl.amdgpu"
				"omptarget.rtl.amdgpu"
				"omptarget-amdgcn"
			)
		fi
		if use llvm_targets_NVPTX ; then
			local target
			for target in "${CUDA_TARGETS_COMPAT[@]}" ; do
				if use "cuda_targets_${target}" ; then
					targets+=(
						"libm-target-${target}"
						"omptarget-nvptx-${target}-bc"
					)
				fi
			done
			targets+=(
				"omptarget.devicertl.nvptx"
			)
		fi
		if use rpc ; then
			targets+=(
				"libomptarget.rtl.rpc.so"
				"omptarget.rtl.rpc"
			)
		fi
		targets+=(
			"libomptarget.so"
			"omptarget"
		)
	fi
	if use ompd ; then
		targets+=(
			"ompd"
		)
	fi
	cmake_src_compile \
		"${targets[@]}"
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

_install_libomptarget() {
	# Missing install-* targets.
	local L1=(
		$(find "${WORKDIR}/llvm-project-rocm-${PV}/llvm_build" -name "libomptarget.so*")
		$(find "${WORKDIR}/llvm-project-rocm-${PV}/llvm_build" -name "libomptarget.rtl.*.so*")
	)
	local L2=(
		$(find "${WORKDIR}/llvm-project-rocm-${PV}/llvm_build" -name "libomptarget*.bc")
	)

	exeinto "${EROCM_PATH}/llvm/$(get_libdir)"
	insinto "${EROCM_PATH}/llvm/$(get_libdir)"
	IFS=$'\n'
	for x in "${L1[@]}" ; do
		doexe "${x}"
	done
	for x in "${L2[@]}" ; do
		doins "${x}"
	done
	IFS=$' \t\n'
}

_install_libomp_libs() {
	exeinto "${EROCM_PATH}/llvm/$(get_libdir)"
	local L1=(
		$(find "${WORKDIR}/llvm-project-rocm-${PV}/llvm_build/lib" -name "libgomp.so*")
		$(find "${WORKDIR}/llvm-project-rocm-${PV}/llvm_build/lib" -name "libiomp*.so*")
		$(find "${WORKDIR}/llvm-project-rocm-${PV}/llvm_build/lib" -name "libomp.so*")
		$(find "${WORKDIR}/llvm-project-rocm-${PV}/llvm_build/lib" -name "libompd.so*")
	)
	IFS=$'\n'
	for x in "${L1[@]}" ; do
		doexe "${x}"
	done
	IFS=$' \t\n'

	insinto "${EROCM_PATH}/llvm/$(get_libdir)/cmake/openmp"
	local L2=(
		$(find "${WORKDIR}/llvm-project-rocm-${PV}/openmp" -name "FindOpenMPTarget.cmake")
	)
	IFS=$'\n'
	for x in "${L2[@]}" ; do
		doins "${x}"
	done
	IFS=$' \t\n'
}

_install_archer() {
	exeinto "${EROCM_PATH}/llvm/$(get_libdir)"
	local L1=(
		$(find "${WORKDIR}/llvm-project-rocm-${PV}/llvm_build" -name "libarcher.so*")
	)
	IFS=$'\n'
	for x in "${L1[@]}" ; do
		doexe "${x}"
	done
	IFS=$' \t\n'
	insinto "${EROCM_PATH}/llvm/$(get_libdir)"
	local L2=(
		$(find "${WORKDIR}/llvm-project-rocm-${PV}/llvm_build" -name "libarcher_static.a*")
	)
	IFS=$'\n'
	for x in "${L2[@]}" ; do
		doins "${x}"
	done
	IFS=$' \t\n'
}

src_install() {
	cd "${BUILD_DIR}" || die
	_install_libomp_libs
	exeinto "${EROCM_PATH}/llvm/$(get_libdir)"
	insinto "${EROCM_PATH}/llvm/include"
	doins "${S_ROOT}/openmp/runtime/exports/common.dia.ompt.optional/include/omp.h"
	if use ompt ; then
		doins "${S_ROOT}/openmp/runtime/exports/common.dia.ompt.optional/include/omp-tools.h"
		doins "${S_ROOT}/openmp/tools/multiplex/ompt-multiplex.h"
		dosym \
			"/usr/$(get_libdir)/rocm/${ROCM_SLOT}/llvm/include/omp-tools.h" \
			"/usr/$(get_libdir)/rocm/${ROCM_SLOT}/llvm/include/ompt.h"
	fi
	_install_libomptarget
	use archer && _install_archer
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
