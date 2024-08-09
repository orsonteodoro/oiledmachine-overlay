# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This package is a misnomer.  This is the non-python portions of pytorch.

# For requirements, see
# https://github.com/pytorch/pytorch/blob/v2.4.0/RELEASE.md?plain=1#L49
# https://github.com/pytorch/pytorch/tree/v2.4.0/third_party
# https://github.com/pytorch/pytorch/blob/v2.4.0/.ci/docker/common/install_rocm_magma.sh#L10 for magma

AMDGPU_TARGETS_COMPAT=(
# Based on rocm_agent_enumerator
	gfx700
	gfx701
	gfx801
	gfx802
	gfx803
	gfx900
	gfx902
	gfx904
	gfx906
	gfx908
	gfx90a
	gfx90c
	gfx1010
	gfx1011
	gfx1012
	gfx1013
	gfx1030
	gfx1031
	gfx1032
	gfx1033
	gfx1034
	gfx1035
)
AMDGPU_TARGETS_UNTESTED=(
# Based on https://github.com/pytorch/pytorch/blob/v2.4.0/.ci/pytorch/build.sh#L169
	gfx700
	gfx701
	gfx801
	gfx802
	gfx803
	gfx900
	gfx902
	gfx904
#	gfx906
	gfx908
	gfx90a
	gfx90c
	gfx1010
	gfx1011
	gfx1012
	gfx1013
	gfx1030
	gfx1031
	gfx1032
	gfx1033
	gfx1034
	gfx1035
)
# CUDA 12 not supported yet: https://github.com/pytorch/pytorch/issues/91122
CUDA_TARGETS_COMPAT=(
# Builds for all cards
	auto

# Observed:
#	sm_35 # Dropped based on RELEASE.md:  Release Compatibility Matrix
	sm_50_plus_ptx
	sm_52
	sm_60
	sm_61
	sm_70
	sm_70_plus_ptx
	sm_75
	sm_80
	sm_86
	sm_90
)
FMT_COMMIT="e69e5f977d458f2650bb346dadf2ad30c5320281"
LLVM_COMPAT=(
	17 # ROCm slot
	16 15 12 10 9 # Upstream build.sh, pull.yml
)
MYPN="pytorch"
MYP="${MYPN}-${PV}"
PYTHON_COMPAT=( python3_{10..11} ) # Upstream only allows <=3.11
inherit hip-versions
ROCM_SLOTS=(
# See https://github.com/pytorch/pytorch/blob/v2.4.0/.ci/docker/build.sh#L190
	"${HIP_6_1_VERSION}"
	"${HIP_6_0_VERSION}"
)
gen_rocm_slots() {
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		local s="${s%.*}"
		s="${s/./_}"
		echo "rocm_${s}"
	done
}
ROCM_SLOTS2=( $(gen_rocm_slots) )

inherit cmake cuda dep-prepare flag-o-matic llvm rocm python-single-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${MYP}"
SRC_URI="
https://github.com/pytorch/${MYPN}/archive/refs/tags/v${PV}.tar.gz
	-> ${MYP}.tar.gz
	!system-fmt? (
https://github.com/fmtlib/fmt/archive/${FMT_COMMIT}.tar.gz
	-> fmt-${FMT_COMMIT}.tar.gz
	)
"

DESCRIPTION="A deep learning framework"
HOMEPAGE="https://pytorch.org/"
LICENSE="BSD"
RESTRICT="test"
SLOT="0"
# cuda and rocm are enabled by default upstream.
IUSE="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${LLVM_COMPAT[@]/#/llvm_slot_}
${ROCM_IUSE}
${ROCM_SLOTS2[@]}
cuda +distributed +fbgemm flash +gloo +magma mkl +mpi +nnpack +numpy onednn
openblas -opencl +openmp +qnnpack rccl rocm system-fmt test +xnnpack
ebuild-revision-2
"
gen_cuda_required_use() {
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		echo "
			cuda_targets_${x}? (
				cuda
			)
		"
	done
}
gen_rocm_required_use() {
	local x
	for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		echo "
			amdgpu_targets_${x}? (
				rocm
			)
		"
	done
}
REQUIRED_USE="
	$(gen_cuda_required_use)
	$(gen_rocm_required_use)
	${PYTHON_REQUIRED_USE}
	?? (
		cuda
		rocm
	)
	cuda? (
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	mpi? (
		distributed
	)
	gloo? (
		distributed
	)
	rocm? (
		${ROCM_REQUIRED_USE}
		^^ (
			${ROCM_SLOTS2[@]}
		)
	)
	rocm_6_1? (
		llvm_slot_17
	)
	rocm_6_0? (
		llvm_slot_17
	)
"
gen_rocm_depends() {
	local pv
	for pv in ${ROCM_SLOTS[@]} ; do
		local s=$(ver_cut 1-2 ${pv})
		local u="${s}"
		u="${u/./_}"
		echo "
			rocm_${u}? (
				~dev-libs/rocm-comgr-${pv}:${s}
				~dev-libs/rocm-core-${pv}:${s}
				~dev-libs/rocr-runtime-${pv}:${s}
				~dev-util/hip-${pv}:${s}[rocm]
				~dev-util/rocprofiler-${pv}:${s}$(get_rocm_usedep ROCPROFILER)
				~dev-util/roctracer-${pv}:${s}
				~sci-libs/hipBLAS-${pv}:${s}[rocm]
				~sci-libs/hipBLASLt-${pv}:${s}$(get_rocm_usedep HIPBLASLT)
				~sci-libs/hipCUB-${pv}:${s}[rocm]
				~sci-libs/hipRAND-${pv}:${s}[rocm]
				~sci-libs/hipSOLVER-${pv}:${s}[rocm]
				~sci-libs/hipSPARSE-${pv}:${s}[rocm]
				~sci-libs/hipFFT-${pv}:${s}[rocm]
				~sci-libs/miopen-${pv}:${s}$(get_rocm_usedep MIOPEN)
				~sci-libs/rocBLAS-${pv}:${s}$(get_rocm_usedep ROCBLAS)
				~sci-libs/rocFFT-${pv}:${s}$(get_rocm_usedep ROCFFT)
				~sci-libs/rocRAND-${pv}:${s}$(get_rocm_usedep ROCRAND)
				~sci-libs/rocPRIM-${pv}:${s}$(get_rocm_usedep ROCPRIM)
				~sci-libs/rocThrust-${pv}:${s}$(get_rocm_usedep ROCTHRUST)
				magma? (
					=sci-libs/magma-2.8*:${s}$(get_rocm_usedep MAGMA_2_8)
				)
				rccl? (
					~dev-libs/rccl-${pv}:${s}$(get_rocm_usedep RCCL)
				)
			)
		"
	done
}

CUDA_11_8_RDEPEND="
(
	=dev-util/nvidia-cuda-toolkit-11.8*:=[profiler]
	=dev-libs/cudnn-8.6*
)
"
CUDA_12_1_RDEPEND="
(
	=dev-util/nvidia-cuda-toolkit-12.1*:=[profiler]
	=dev-libs/cudnn-8.8*
)
"
CUDA_12_4_RDEPEND="
(
	=dev-util/nvidia-cuda-toolkit-12.4*:=[profiler]
	=dev-libs/cudnn-8.8*
)
"
# glod missing
RDEPEND="
	${PYTHON_DEPS}
	(
		>=dev-cpp/gflags-2.2.2:=
		dev-cpp/gflags:=
	)
	>=dev-cpp/glog-0.4.0
	>=dev-libs/cpuinfo-2023.11.03
	>=dev-libs/protobuf-3.13.1:0/3.21
	>=dev-libs/pthreadpool-2023.08.28
	>=dev-libs/sleef-3.6.0
	>=sci-libs/foxi-2021.05.26
	>=sci-libs/onnx-1.16.0
	dev-cpp/opentelemetry-cpp
	virtual/lapack
	cuda? (
		>=dev-libs/cudnn-frontend-1.4.0:0/8
		cuda_targets_auto? (
			|| (
				${CUDA_11_8_RDEPEND}
				${CUDA_12_1_RDEPEND}
				${CUDA_12_4_RDEPEND}
			)
		)
		cuda_targets_sm_50_plus_ptx? (
			|| (
				${CUDA_11_8_RDEPEND}
				${CUDA_12_1_RDEPEND}
				${CUDA_12_4_RDEPEND}
			)
		)
		cuda_targets_sm_52? (
			|| (
				${CUDA_11_8_RDEPEND}
				${CUDA_12_1_RDEPEND}
				${CUDA_12_4_RDEPEND}
			)
		)
		cuda_targets_sm_60? (
			|| (
				${CUDA_11_8_RDEPEND}
				${CUDA_12_1_RDEPEND}
				${CUDA_12_4_RDEPEND}
			)
		)
		cuda_targets_sm_61? (
			|| (
				${CUDA_11_8_RDEPEND}
				${CUDA_12_1_RDEPEND}
				${CUDA_12_4_RDEPEND}
			)
		)
		cuda_targets_sm_70? (
			|| (
				${CUDA_11_8_RDEPEND}
				${CUDA_12_1_RDEPEND}
				${CUDA_12_4_RDEPEND}
			)
		)
		cuda_targets_sm_70_plus_ptx? (
			|| (
				${CUDA_11_8_RDEPEND}
				${CUDA_12_1_RDEPEND}
				${CUDA_12_4_RDEPEND}
			)
		)
		cuda_targets_sm_75? (
			|| (
				${CUDA_11_8_RDEPEND}
				${CUDA_12_1_RDEPEND}
				${CUDA_12_4_RDEPEND}
			)
		)
		cuda_targets_sm_80? (
			|| (
				${CUDA_11_8_RDEPEND}
				${CUDA_12_1_RDEPEND}
				${CUDA_12_4_RDEPEND}
			)
		)
		cuda_targets_sm_86? (
			|| (
				${CUDA_11_8_RDEPEND}
				${CUDA_12_1_RDEPEND}
				${CUDA_12_4_RDEPEND}
			)
		)
		cuda_targets_sm_90? (
			|| (
				${CUDA_11_8_RDEPEND}
				${CUDA_12_1_RDEPEND}
				${CUDA_12_4_RDEPEND}
			)
		)
		dev-util/nvidia-cuda-toolkit:=
		dev-libs/cudnn:=
	)
	distributed? (
		>=sci-libs/tensorpipe-2021.12.27[cuda?]
	)
	fbgemm? (
		>=sci-libs/FBGEMM-2023.12.04
	)
	gloo? (
		>=sci-libs/gloo-0.5.0[cuda?]
	)
	magma? (
		sci-libs/magma[cuda?,rocm?]
		sci-libs/magma:=
		cuda? (
			sci-libs/magma:0
		)
	)
	mkl? (
		sci-libs/mkl
	)
	mpi? (
		virtual/mpi
	)
	nnpack? (
		>=sci-libs/NNPACK-2020.12.21
	)
	numpy? (
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
		')
	)
	openblas? (
		sci-libs/openblas
	)
	onednn? (
		dev-libs/oneDNN
	)
	opencl? (
		virtual/opencl
	)
	qnnpack? (
		!sci-libs/QNNPACK
		>=dev-cpp/gemmlowp-2018.11.26
	)
	rocm? (
		|| (
			$(gen_rocm_depends)
		)
	)
	system-fmt? (
		>=dev-libs/libfmt-10.2.1
	)
	xnnpack? (
		>=sci-libs/XNNPACK-2024.02.29
	)
"
DEPEND="
	$(python_gen_cond_dep '
		dev-python/pybind11[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
	${RDEPEND}
	>=dev-libs/flatbuffers-23.3.3
	>=dev-libs/FP16-2020.05.14
	>=dev-libs/FXdiv-2020.04.17
	>=dev-libs/pocketfft-2023.12.30
	>=dev-libs/psimd-2020.05.17
	>=sci-libs/kineto-0.4.0_p20240524
	cuda? (
		>=dev-libs/cutlass-3.4.1
	)
	onednn? (
		>=sci-libs/ideep-3.4.2
	)
"
BDEPEND="
	test? (
		>=dev-cpp/benchmark-1.6.1
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-2.2.1-gentoo.patch"
	"${FILESDIR}/${PN}-1.13.0-install-dirs.patch"
	"${FILESDIR}/${PN}-1.12.0-glog-0.6.0.patch"
	"${FILESDIR}/${PN}-1.13.1-tensorpipe.patch"
	"${FILESDIR}/${PN}-2.3.0-cudnn_include_fix.patch"
	"${FILESDIR}/${PN}-2.1.2-fix-rpath.patch"
	"${FILESDIR}/${PN}-2.1.2-fix-openmp-link.patch"
	"${FILESDIR}/${PN}-2.3.0-rocm-fix-std-cpp17.patch"
	"${FILESDIR}/${PN}-2.2.2-musl.patch"
	"${FILESDIR}/${PN}-2.3.0-CMakeFix.patch"
	"${FILESDIR}/${PN}-2.3.0-exclude-aotriton.patch"
	"${FILESDIR}/${PN}-2.3.0-fix-rocm-gcc14-clamp.patch"
	"${FILESDIR}/${PN}-2.3.0-optional-hipblaslt.patch"
	"${FILESDIR}/${PN}-2.3.0-fix-libcpp.patch"
	"${FILESDIR}/${PN}-2.3.0-fix-gcc-clang-abi-compat.patch"
)

warn_untested_gpu() {
	local gpu
	for gpu in ${AMDGPU_TARGETS_UNTESTED[@]} ; do
		if use "amdgpu_targets_${gpu}" ; then
ewarn "${gpu} is not CI tested upstream."
		fi
	done
}

pkg_setup() {
	warn_untested_gpu
	if use rocm_6_1 ; then
		LLVM_SLOT="17"
		LLVM_MAX_SLOT="${LLVM_SLOT}"
		ROCM_SLOT="6.1"
		rocm_pkg_setup
	elif use rocm_6_0 ; then
		LLVM_SLOT="17"
		LLVM_MAX_SLOT="${LLVM_SLOT}"
		ROCM_SLOT="6.0"
		rocm_pkg_setup
	else
		local s
		for s in ${LLVM_COMPAT[@]} ; do
			if use "llvm_slot_${s}" ; then
				LLVM_MAX_SLOT="${s}"
				break
			fi
		done
		llvm_pkg_setup
	fi
	python-single-r1_pkg_setup
}

src_prepare() {
	if ! use system-fmt ; then
		dep_prepare_mv "${WORKDIR}/fmt-${FMT_COMMIT}" "${S}/third_party/fmt"
	fi
	filter-lto #bug 862672
	sed -i \
		-e "/third_party\/gloo/d" \
		cmake/Dependencies.cmake \
		|| die
	cmake_src_prepare
	pushd torch/csrc/jit/serialization >/dev/null 2>&1 || die
		flatc \
			--cpp \
			--gen-mutable \
			--scoped-enums \
			mobile_bytecode.fbs \
			|| die
	popd >/dev/null 2>&1 || die
	sed \
		-i \
		-e "s|lib/cmake|$(get_libdir)/cmake|g" \
		"cmake/public/LoadHIP.cmake" \
		|| die
	if use rocm ; then
		rocm_src_prepare
		ebegin "HIPifying cuda sources"
			${EPYTHON} "tools/amd_build/build_amd.py" || die
		eend $?
	fi
}

gen_cuda_arch_list() {
	if -n [[ "${TORCH_CUDA_ARCH_LIST}" ]] ; then
		echo "${TORCH_CUDA_ARCH_LIST}"
	else
		local list
		local x
		for x in ${CUDA_TARGETS_COMPAT[@]} ; do
			if use "cuda_targets_${x}" ; then
				local gen
				local ver
				local suffix=""
				if [[ "${x}" =~ "plus_ptx" ]] ; then
					suffix="+PTX"
					x="${x/_plus_ptx/}"
				fi
				local val=",${x#*_}"
				if (( "${#val}" == 2 )) ; then
					# CC 3.5, 7.5
					ver=${val:1:1}
					gen=${val:0:1}
				elif (( "${#val}" == 3 )) ; then
					# Hypothentical CC 10.0
					ver=${val:2:1}
					gen=${val:0:2}
				fi
				list+=",${getn}.${val}${suffix}"
			fi
		done
		echo "${list:1}"
	fi
}

src_configure() {
	if use cuda && [[ -z ${TORCH_CUDA_ARCH_LIST} ]]; then
einfo
einfo "You can look up your GPU's CUDA compute capability at"
einfo
einfo "  https://developer.nvidia.com/cuda-gpus"
einfo
einfo "or by running"
einfo
einfo "  /opt/cuda/extras/demo_suite/deviceQuery | grep 'CUDA Capability'"
einfo
	fi

	local mycmakeargs=(
	# Avoid the use of MKL, if found on the system
		-DBUILD_CUSTOM_PROTOBUF=OFF
		-DBUILD_SHARED_LIBS=ON
		-DLIBSHM_INSTALL_LIB_SUBDIR="${EPREFIX}/usr/$(get_libdir)"
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DTORCH_INSTALL_LIB_DIR="${EPREFIX}/usr/$(get_libdir)"
		-DUSE_CCACHE=OFF
		-DUSE_CUDA=$(usex cuda)
		-DUSE_DISTRIBUTED=$(usex distributed)
		-DUSE_FAKELOWP=OFF
		-DUSE_FBGEMM=$(usex fbgemm)
		-DUSE_FLASH_ATTENTION=$(usex flash)
		-DUSE_GFLAGS=ON
		-DUSE_GLOG=ON
		-DUSE_GLOO=$(usex gloo)
		-DUSE_ITT=OFF
		-DUSE_KINETO=OFF # TODO
		-DUSE_MAGMA=$(usex magma)
		-DUSE_MEM_EFF_ATTENTION=OFF
		-DUSE_MKLDNN=$(usex onednn)
		-DUSE_MPI=$(usex mpi)
		-DUSE_NNPACK=$(usex nnpack)
		-DUSE_PYTORCH_QNNPACK=$(usex qnnpack)
		-DUSE_SYSTEM_FP16=ON
		-DUSE_SYSTEM_FXDIV=ON
		-DUSE_SYSTEM_GLOO=ON
		-DUSE_SYSTEM_ONNX=ON
		-DUSE_SYSTEM_PSIMD=ON
		-DUSE_SYSTEM_PTHREADPOOL=ON
		-DUSE_SYSTEM_SLEEF=ON
		-DUSE_SYSTEM_XNNPACK=$(usex xnnpack)
		-DUSE_TENSORPIPE=$(usex distributed)
		-DUSE_PYTORCH_METAL=OFF
		-DUSE_NUMPY=$(usex numpy)
		-DUSE_OPENCL=$(usex opencl)
		-DUSE_OPENMP=$(usex openmp)
		-DUSE_RCCL=$(usex rccl)
		-DUSE_ROCM=$(usex rocm)
		-DUSE_SYSTEM_CPUINFO=ON
		-DUSE_SYSTEM_PYBIND11=ON
		-DUSE_UCC=OFF
		-DUSE_VALGRIND=OFF
		-DUSE_XNNPACK=$(usex xnnpack)
		-DUSE_XPU=OFF
		-Wno-dev
	)

	if use mkl ; then
		mycmakeargs+=(
			-DBLAS=MKL
		)
	elif use openblas ; then
		mycmakeargs+=(
			-DBLAS=OpenBLAS
		)
	else
		mycmakeargs+=(
			-DBLAS=Generic
			-DBLAS_LIBRARIES=
		)
	fi

	if use cuda ; then
		addpredict "/dev/nvidiactl" # bug 867706
		addpredict "/dev/char"

		if use cuda_targets_auto ; then
			# From U18.04 Dockerfile
			# CI for linux uses only Maxwell or 5.2
			mycmakeargs+=(
				-DTORCH_CUDA_ARCH_LIST=${TORCH_CUDA_ARCH_LIST:-"5.2 6.0 6.1 7.0+PTX 8.0"}
			)
		else
			mycmakeargs+=(
				-DTORCH_CUDA_ARCH_LIST=$(gen_cuda_arch_list)
			)
		fi

		mycmakeargs+=(
			-DCMAKE_CUDA_FLAGS=$(cuda_gccdir -f \
				| tr -d \")
			-DUSE_CUDNN=ON
			-DTORCH_CUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST:-3.5 7.0}"
			-DUSE_NCCL=OFF # TODO: NVIDIA Collective Communication Library
		)
	fi
	if use rocm ; then
		export HCC_PATH="${ESYSROOT}${EROCM_PATH}"
		export HIP_PATH="${ESYSROOT}${EROCM_PATH}"
		export HIPCUB_PATH="${ESYSROOT}${EROCM_PATH}"
		export HIPFFT_PATH="${ESYSROOT}${EROCM_PATH}"
		export HIPRAND_PATH="${ESYSROOT}${EROCM_PATH}"
		export HIPSPARSE_PATH="${ESYSROOT}${EROCM_PATH}"
		export HSA_PATH="${ESYSROOT}${EROCM_PATH}"
		export MAGMA_HOME="${ESYSROOT}${EROCM_PATH}"
		export MIOPEN_PATH="${ESYSROOT}${EROCM_PATH}"
		export RCCL_PATH="${ESYSROOT}${EROCM_PATH}"
		export ROCBLAS_PATH="${ESYSROOT}${EROCM_PATH}"
		export ROCFFT_PATH="${ESYSROOT}${EROCM_PATH}"
		export ROCM_HOME="${ESYSROOT}${EROCM_PATH}"
		export ROCM_INCLUDE_DIRS="${ESYSROOT}${EROCM_PATH}/include"
		export ROCM_PATH="${ESYSROOT}${EROCM_PATH}"
		export ROCPRIM_PATH="${ESYSROOT}${EROCM_PATH}"
		export ROCRAND_PATH="${ESYSROOT}${EROCM_PATH}"
		export ROCTRACER_PATH="${ESYSROOT}${EROCM_PATH}"
		export ROCTHRUST_PATH="${ESYSROOT}${EROCM_PATH}"
		export THRUST_PATH="${ESYSROOT}${EROCM_PATH}/include"
		mycmakeargs+=(
			-DPYTORCH_ROCM_ARCH=$(get_amdgpu_flags)
			-DUSE_NCCL=$(usex rccl)
			-DUSE_SYSTEM_NCCL=ON
		)
	fi

	if use onednn ; then
		mycmakeargs+=(
			-DUSE_MKLDNN=ON
			-DMKLDNN_FOUND=ON
			-DMKLDNN_LIBRARIES=dnnl
			-DMKLDNN_INCLUDE_DIR="${ESYSROOT}/usr/include/oneapi/dnnl"
		)
	fi

	cmake_src_configure

	# Do not rerun cmake and the build process in src_install
	sed '/RERUN/,+1d' -i "${BUILD_DIR}"/build.ninja || die
}

src_install() {
	cmake_src_install

	insinto "/var/lib/${PN}"
	doins "${BUILD_DIR}/CMakeCache.txt"

	rm -rf "python"
	mkdir -p "python/torch/include" || die
	mv \
		"${ED}/usr/lib/python"*"/site-packages/caffe2" \
		"python/" \
		|| die
	cp \
		"torch/version.py" \
		"python/torch/" \
		|| die
	rm -rf "${ED}/var/tmp" || die
	python_domodule python/caffe2
	python_domodule python/torch
	ln -s \
		"../../../../../include/torch" \
		"${D}$(python_get_sitedir)/torch/include/torch" \
		|| die # bug 923269
}
