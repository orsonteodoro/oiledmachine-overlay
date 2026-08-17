# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# dev-util/rocprofiler-sdk
# rocJPEG
# rocSHMEM

CXX_STANDARD="ignore"
LIBSTDCXX_SLOT_VERIFY=0
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

# See
# https://github.com/ROCm/rocm-install-on-linux/blob/rocm-7.2.0/docs/reference/system-requirements.rst
# https://github.com/ROCm/rocm-install-on-linux/blob/rocm-7.2.0/docs/reference/user-kernel-space-compat-matrix.rst
AMDGPU_TARGETS_COMPAT=(
	"gfx908"
	"gfx90a"
	"gfx942"
	"gfx950"
	"gfx1030"
	"gfx1100"
	"gfx1101"
	"gfx1200"
	"gfx1201"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_ROCM_7_2[@]}"
)

inherit libstdcxx-slot secure-version rocm

#KEYWORDS="~amd64"

DESCRIPTION="ROCm metapackage"
HOMEPAGE=""
LICENSE="metapackage"
SLOT="0/${ROCM_SLOT}"
IUSE="
	ai
	+compilers
	communication
	cv
	flang-legacy
	flang-new
	fortran
	+hip
	+kernel-driver
	+math
	+ml
	non-free
	+opencl
	+primitives
	+runtimes
	+support-libs
	tools-deploy
	tools-dev
	tools-perf
	tools-system
"
REQUIRED_USE="
	ai? (
		cv
		ml
	)
	fortran? (
		compilers
		|| (
			hip
			non-free
		)
		|| (
			flang-legacy
			flang-new
		)
	)
	hip? (
		compilers
		runtimes
		support-libs
	)
	math? (
		support-libs
	)
	ml? (
		support-libs
	)
	opencl? (
		compilers
		runtimes
		support-libs
	)
	primitives? (
		support-libs
	)
	support-libs? (
		kernel-driver
	)
	tools-deploy? (
		kernel-driver
	)
	tools-dev? (
		kernel-driver
		support-libs
	)
	tools-system? (
		kernel-driver
	)
	|| (
		fortran
		hip
		opencl
		tools-deploy
	)
"
has_gpu() {
	local gpu="${x}"
	local x
	for x in "${AMDGPU_TARGETS_COMPAT[@]}" ; do
		if [[ "${gpu}" == "${x}" ]] ; then
			return 0
		fi
	done
	return 1
}
gen_hipblaslt_rdepend() {
	local x
	for x in "${HIPBLASLT_7_2_AMDGPU_TARGETS_COMPAT[@]}" ; do
		[[ "${x}" =~ "xnack" ]] && continue
		has_gpu "${x}" || continue
		echo "
			amdgpu_targets_${x}? (
				~sci-libs/hipBLASLt-${PV}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep HIPBLASLT)]
			)
		"
	done
}
gen_hipsparselt_rdepend() {
	local x
	for x in "${HIPSPARSELT_7_2_AMDGPU_TARGETS_COMPAT[@]}" ; do
		[[ "${x}" =~ "xnack" ]] && continue
		has_gpu "${x}" || continue
		echo "
			amdgpu_targets_${x}? (
				~sci-libs/hipSPARSELt-${PV}:=[${LIBSTDCXX_USEDEP},rocm]
			)
		"
	done
}
RDEPEND="
	!dev-util/amd-rocm-meta
	compilers? (
		fortran? (
			flang-legacy? (
				~dev-lang/rocm-flang-${PV}:=[${LIBSTDCXX_USEDEP}]
			)
			flang-new? (
				~sys-libs/llvm-roc-${PV}:=[${LIBSTDCXX_USEDEP},flang]
			)
		)
		hip? (
			~dev-libs/rocm-comgr-${PV}:=[${LIBSTDCXX_USEDEP}]
			~sys-libs/llvm-roc-${PV}:=[${LIBSTDCXX_USEDEP}]
		)
		opencl? (
			~llvm-core/clang-ocl-${PV}:=
			~sys-libs/llvm-roc-${PV}:=[${LIBSTDCXX_USEDEP}]
			~sys-libs/llvm-roc-libomp-${PV}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep LLVM_ROC_LIBOMP)]
		)
	)
	communication? (
		~dev-libs/rccl-${PV}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep RCCL)]
		~dev-libs/rccl-rdma-sharp-plugins-${PV}:=
	)
	cv? (
		~dev-python/rocPyDecode-${PV}:=
		~sci-libs/MIVisionX-${PV}:=[${LIBSTDCXX_USEDEP},rocm]
		~sci-libs/rocAL-${PV}:=[${LIBSTDCXX_USEDEP}]
		~sci-libs/rocDecode-${PV}:=[${LIBSTDCXX_USEDEP}]
		~sci-libs/rpp-${PV}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep RPP)]
	)
	kernel-driver? (
		virtual/kfd:=
		|| (
			~virtual/kfd-7.2:0/7.2
			~virtual/kfd-7.1:0/7.1
			~virtual/kfd-7.0:0/7.0
		)
	)
	math? (
		~dev-util/Tensile-7.0.0:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep TENSILE)]
		~sci-libs/hipBLAS-${PV}:=[${LIBSTDCXX_USEDEP},rocm]
		~sci-libs/hipFFT-${PV}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep HIPFFT)]
		~sci-libs/hipRAND-${PV}:=[${LIBSTDCXX_USEDEP},rocm]
		~sci-libs/hipSOLVER-${PV}:=[${LIBSTDCXX_USEDEP},rocm]
		~sci-libs/hipSPARSE-${PV}:=[${LIBSTDCXX_USEDEP},rocm]
		~sci-libs/rocALUTION-${PV}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep ROCALUTION)]
		~sci-libs/rocBLAS-${PV}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep ROCBLAS)]
		~sci-libs/rocFFT-${PV}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep ROCFFT)]
		~sci-libs/rocRAND-${PV}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep ROCRAND)]
		~sci-libs/rocSOLVER-${PV}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep ROCSOLVER)]
		~sci-libs/rocSPARSE-${PV}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep ROCSPARSE)]
		~sci-libs/rocWMMA-${PV}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep ROCWMMA)]
		$(gen_hipblaslt_rdepend)
		$(gen_hipsparselt_rdepend)
		fortran? (
			~dev-util/hipfort-${PV}:=
		)
	)
	ml? (
		~sci-libs/composable-kernel-${PV}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep COMPOSABLE_KERNEL)]
		~sci-libs/MIGraphX-${PV}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep MIGRAPHX)]
		~sci-libs/miopen-${PV}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep MIOPEN)]
	)
	primitives? (
		~sci-libs/hipCUB-${PV}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep HIPCUB)]
		~sci-libs/hipTensor-${PV}:=[${LIBSTDCXX_USEDEP},rocm]
		~sci-libs/rocPRIM-${PV}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep ROCPRIM)]
		~sci-libs/rocThrust-${PV}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep ROCTHRUST)]
	)
	runtimes? (
		~dev-libs/rocm-device-libs-${PV}:=
		~dev-libs/rocr-runtime-${PV}:=[${LIBSTDCXX_USEDEP}]
		hip? (
			$(secure-version_gen_perl_depends)
			>=sys-libs/glibc-${GLIBC_PV}:=
			sys-apps/file:=
			dev-perl/URI-Encode
			dev-perl/File-BaseDir
			dev-perl/File-Copy-Recursive
			dev-perl/File-Listing
			dev-perl/File-Which
			~dev-util/hip-${PV}:=[${LIBSTDCXX_USEDEP},rocm]
		)
		opencl? (
			~dev-libs/rocm-opencl-runtime-${PV}:=[${LIBSTDCXX_USEDEP}]
		)
	)
	support-libs? (
		~dev-build/rocm-cmake-${PV}:=
		~dev-libs/rocm-core-${PV}:=[${LIBSTDCXX_USEDEP}]
	)
	tools-deploy? (
		~dev-util/amd-smi-${PV}:=[${LIBSTDCXX_USEDEP}]
		~dev-util/rocm-smi-${PV}:=[${LIBSTDCXX_USEDEP}]
		~dev-util/rocm-validation-suite-${PV}:=[${LIBSTDCXX_USEDEP}]
		~sys-cluster/rdc-${PV}:=
	)
	tools-dev? (
		~dev-libs/ROCdbgapi-${PV}:=
		~dev-libs/rocm-debug-agent-${PV}:=
		~dev-util/HIPIFY-${PV}:=
		~dev-util/ROCgdb-${PV}:=
	)
	tools-perf? (
		~dev-util/rocprofiler-compute-${PV}:=
		~dev-util/rocprofiler-systems-${PV}:=[${LIBSTDCXX_USEDEP}]
		~dev-util/rocprofiler-sdk-${PV}:=[${LIBSTDCXX_USEDEP}]
		~dev-util/rocm_bandwidth_test-${PV}:=
		non-free? (
			~dev-libs/rocprofiler-register-${PV}:=[${LIBSTDCXX_USEDEP}]
			~dev-util/rocprofiler-${PV}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep ROCPROFILER)]
			~dev-util/roctracer-${PV}:=[${LIBSTDCXX_USEDEP}]
		)
	)
	tools-system? (
		~dev-util/rocminfo-${PV}:=[${LIBSTDCXX_USEDEP}]
		opencl? (
			dev-util/clinfo:=
		)
	)
"
