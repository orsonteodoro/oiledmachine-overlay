# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This package is a misnomer.  This is the non-python portions of pytorch.

AMDGPU_TARGETS_COMPAT=(
	gfx900
	gfx906
	gfx908
)
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
)
LLVM_MAX_SLOT=16
MYPN="pytorch"
MYP="${MYPN}-${PV}"
PYTHON_COMPAT=( python3_10 ) # Upstream only allows <=3.10
ROCM_SLOT="5.2" # To be changed in pkg_setup()

inherit cmake cuda flag-o-matic rocm python-single-r1

SRC_URI="
https://github.com/pytorch/${MYPN}/archive/refs/tags/v${PV}.tar.gz
	-> ${MYP}.tar.gz
"

DESCRIPTION="A deep learning framework"
HOMEPAGE="https://pytorch.org/"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
# cuda and rocm are enabled by default upstream.
IUSE="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${ROCM_IUSE}
cuda +distributed +fbgemm -ffmpeg +gloo +magma +mpi +nnpack +numpy -opencl -opencv +openmp
rocm +qnnpack +tensorpipe +xnnpack
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
	cuda? (
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	ffmpeg? (
		opencv
	)
	mpi? (
		distributed
	)
	tensorpipe? (
		distributed
	)
	gloo? (
		distributed
	)
	rocm? (
		${ROCM_REQUIRED_USE}
	)
"
ROCM_SLOTS=(
# https://github.com/pytorch/pytorch/blob/v1.13.1/.github/workflows/periodic.yml#L37
	"5.2.3" # TODO:  Confirm version completeness.
)
gen_rocm_depends() {
	local pv
	for pv in ${ROCM_SLOTS[@]} ; do
		local s="0/"$(ver_cut 1-2 ${pv})
		echo "
			(
				~dev-libs/rccl-${pv}:${s}
				~dev-libs/rocm-comgr-${pv}:${s}
				~dev-libs/rocm-core-${pv}:${s}
				~dev-libs/rocr-runtime-${pv}:${s}
				~dev-util/hip-${pv}:${s}[rocm]
				~dev-util/rocprofiler-${pv}:${s}
				~dev-util/roctracer-${pv}:${s}
				~sci-libs/hipCUB-${pv}:${s}[rocm]
				~sci-libs/hipSPARSE-${pv}:${s}[rocm]
				~sci-libs/hipFFT-${pv}:${s}[rocm]
				~sci-libs/miopen-${pv}:${s}[rocm]
				~sci-libs/rocBLAS-${pv}:${s}[rocm]
				~sci-libs/rocFFT-${pv}:${s}[rocm]
				~sci-libs/rocRAND-${pv}:${s}[rocm]
				~sci-libs/rocPRIM-${pv}:${s}[rocm]
				~sci-libs/rocThrust-${pv}:${s}
				magma? (
					sci-libs/magma:${s}
				)
			)
		"
	done
}
# CUDA 12 not supported yet: https://github.com/pytorch/pytorch/issues/91122
CUDA_PV="11.8" # 11.6 minimum required
RDEPEND="
	${PYTHON_DEPS}
	>=dev-cpp/glog-0.5.0
	>=sci-libs/onnx-1.12.0
	dev-cpp/gflags:=
	dev-libs/cpuinfo
	dev-libs/libfmt
	dev-libs/protobuf:=
	dev-libs/pthreadpool
	dev-libs/sleef
	sci-libs/lapack
	sci-libs/foxi
	cuda? (
		=dev-libs/cudnn-8*
		dev-libs/cudnn-frontend:0/8
		cuda_targets_auto? (
			=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*:=
		)
		cuda_targets_sm_50_plus_ptx? (
			=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*:=
		)
		cuda_targets_sm_52? (
			=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*:=
		)
		cuda_targets_sm_60? (
			=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*:=
		)
		cuda_targets_sm_61? (
			=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*:=
		)
		cuda_targets_sm_70? (
			=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*:=
		)
		cuda_targets_sm_70_plus_ptx? (
			=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*:=
		)
		cuda_targets_sm_75? (
			=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*:=
		)
		cuda_targets_sm_80? (
			=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*:=
		)
		cuda_targets_sm_86? (
			=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*:=
		)
		=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*[profiler]
	)
	fbgemm? (
		dev-libs/FBGEMM
	)
	ffmpeg? (
		media-video/ffmpeg:=
	)
	gloo? (
		sci-libs/gloo[cuda?]
	)
	magma? (
		sci-libs/magma[cuda?,rocm?]
		sci-libs/magma:=
		cuda? (
			sci-libs/magma:0
		)
	)
	mpi? (
		sys-cluster/openmpi
	)
	nnpack? (
		sci-libs/NNPACK
	)
	numpy? (
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
		')
	)
	opencl? (
		virtual/opencl
	)
	opencv? (
		media-libs/opencv:=
	)
	qnnpack? (
		sci-libs/QNNPACK
	)
	rocm? (
		|| (
			$(gen_rocm_depends)
		)
	)
	tensorpipe? (
		sci-libs/tensorpipe
	)
	xnnpack? (
		sci-libs/XNNPACK
	)
"
DEPEND="
	$(python_gen_cond_dep '
		dev-python/pybind11[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
	${RDEPEND}
	dev-cpp/eigen
	dev-libs/psimd
	dev-libs/FP16
	dev-libs/FXdiv
	dev-libs/pocketfft
	dev-libs/flatbuffers
	sci-libs/kineto
	cuda? (
		dev-libs/cutlass
	)
"
BDEPEND="
	>=dev-util/cmake-3.13
"
RESTRICT="test"
S="${WORKDIR}/${MYP}"
PATCHES=(
	"${FILESDIR}/${PN}-1.13.0-gentoo.patch"
	"${FILESDIR}/${PN}-1.13.0-install-dirs.patch"
	"${FILESDIR}/${PN}-1.12.0-glog-0.6.0.patch"
	"${FILESDIR}/${PN}-1.12.0-clang.patch"
	"${FILESDIR}/${P}-tensorpipe.patch"
	"${FILESDIR}/${PN}-2.0.1-hip-cmake.patch"
)

pkg_setup() {
	if has_version "dev-util/hip:5.2" ; then
		LLVM_MAX_SLOT="14"
		ROCM_SLOT="5.2"
	fi
	rocm_pkg_setup
}

src_prepare() {
	filter-lto #bug 862672
	sed -i \
		-e "/third_party\/gloo/d" \
		cmake/Dependencies.cmake \
		|| die
	cmake_src_prepare
	pushd torch/csrc/jit/serialization || die
		flatc \
			--cpp \
			--gen-mutable \
			--scoped-enums \
			mobile_bytecode.fbs \
			|| die
	popd
	sed \
		-i \
		-e "s|lib/cmake|$(get_libdir)/cmake|g" \
		"cmake/public/LoadHIP.cmake" \
		|| die
	rocm_src_prepare
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
		-DBLAS="Eigen"
		-DBUILD_CUSTOM_PROTOBUF=OFF
		-DBUILD_SHARED_LIBS=ON
		-DLIBSHM_INSTALL_LIB_SUBDIR="${EPREFIX}/usr/$(get_libdir)"
		-DPYBIND11_PYTHON_VERSION="${EPYTHON#python}"
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DTORCH_INSTALL_LIB_DIR="${EPREFIX}/usr/$(get_libdir)"
		-DUSE_CCACHE=OFF
		-DUSE_CUDA=$(usex cuda)
		-DUSE_CUDNN=$(usex cuda)
		-DUSE_DISTRIBUTED=$(usex distributed)
		-DUSE_FAKELOWP=OFF
		-DUSE_FAST_NVCC=$(usex cuda)
		-DUSE_FBGEMM=$(usex fbgemm)
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_GFLAGS=ON
		-DUSE_GLOG=ON
		-DUSE_GLOO=$(usex gloo)
		-DUSE_ITT=OFF
		-DUSE_KINETO=OFF # TODO
		-DUSE_LEVELDB=OFF
		-DUSE_MAGMA=$(usex magma)
		-DUSE_MKLDNN=OFF
		-DUSE_MPI=$(usex mpi)
		-DUSE_NCCL=OFF # TODO: NVIDIA Collective Communication Library
		-DUSE_NNPACK=$(usex nnpack)
		-DUSE_QNNPACK=$(usex qnnpack)
		-DUSE_SYSTEM_EIGEN_INSTALL=ON
		-DUSE_SYSTEM_FP16=ON
		-DUSE_SYSTEM_FXDIV=ON
		-DUSE_SYSTEM_GLOO=ON
		-DUSE_SYSTEM_ONNX=ON
		-DUSE_SYSTEM_PTHREADPOOL=ON
		-DUSE_SYSTEM_SLEEF=ON
		-DUSE_SYSTEM_XNNPACK=$(usex xnnpack)
		-DUSE_TENSORPIPE=$(usex tensorpipe)
		-DUSE_PYTORCH_QNNPACK=OFF
		-DUSE_NUMPY=$(usex numpy)
		-DUSE_OPENCL=$(usex opencl)
		-DUSE_OPENCV=$(usex opencv)
		-DUSE_OPENMP=$(usex openmp)
		-DUSE_ROCM=$(usex rocm)
		-DUSE_SYSTEM_CPUINFO=ON
		-DUSE_SYSTEM_PYBIND11=ON
		-DUSE_UCC=OFF
		-DUSE_VALGRIND=OFF
		-DUSE_XNNPACK=$(usex xnnpack)
		-Wno-dev
	)

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
		)
	fi
	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto "/var/lib/${PN}"
	doins "${BUILD_DIR}/CMakeCache.txt"

	rm -rf python
	mkdir -p python/torch/include || die
	mv \
		"${ED}/usr/lib/python"*"/site-packages/caffe2" \
		python/ \
		|| die
	mv \
		"${ED}/usr/include/torch"
		python/torch/include \
		|| die
	cp \
		torch/version.py \
		python/torch/ \
		|| die
	rm -rf "${ED}/var/tmp" || die
	python_domodule python/caffe2
	python_domodule python/torch
}
