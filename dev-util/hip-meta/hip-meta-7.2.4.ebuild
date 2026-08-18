# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD="ignore"
LIBCXX_SLOT_VERIFY=0
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

# See https://github.com/ROCm/rocm-install-on-linux/blob/rocm-7.0.0/docs/reference/system-requirements.rst
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

DESCRIPTION="HIP metapackage"
HOMEPAGE=""
LICENSE="metapackage"
SLOT="0/${ROCM_SLOT}"
IUSE="
	compilers
	cuda
	fortran
	hip
	math
	primitives
	rocm
	runtimes
	support-libs
	ebuild_revision_3
"
REQUIRED_USE="
	hip? (
		compilers
		runtimes
		support-libs
	)
	math? (
		support-libs
	)
	primitives? (
		support-libs
	)
	^^ (
		cuda
		rocm
	)
	|| (
		hip
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
	compilers? (
		cuda? (
			dev-util/nvidia-cuda-toolkit:=
			virtual/cuda-compiler:=
		)
		rocm? (
			~dev-libs/rocm-comgr-${PV}:=[${LIBSTDCXX_USEDEP}]
			~sys-devel/llvm-roc-${PV}:=[${LIBSTDCXX_USEDEP}]
		)
	)
	math? (
		~sci-libs/hipBLAS-${PV}:=[${LIBSTDCXX_USEDEP},cuda?,rocm?]
		~sci-libs/hipRAND-${PV}:=[${LIBSTDCXX_USEDEP},cuda?,rocm?]
		~sci-libs/hipSOLVER-${PV}:=[${LIBSTDCXX_USEDEP},cuda?,rocm?]
		~sci-libs/hipSPARSE-${PV}:=[${LIBSTDCXX_USEDEP},cuda?,rocm?]
		cuda? (
			~sci-libs/hipFFT-${PV}:=[${LIBSTDCXX_USEDEP},cuda]
		)
		fortran? (
			~dev-util/hipfort-${PV}:=
		)
		rocm? (
			~sci-libs/hipFFT-${PV}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep HIPFFT)]
			$(gen_hipblaslt_rdepend)
			$(gen_hipsparselt_rdepend)
		)
	)
	primitives? (
		~sci-libs/hipTensor-${PV}:=[${LIBSTDCXX_USEDEP},cuda?,rocm?]
		cuda? (
			~sci-libs/hipCUB-${PV}:=[${LIBSTDCXX_USEDEP},cuda]
		)
		rocm? (
			~sci-libs/hipCUB-${PV}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep HIPCUB)]
		)
	)
	runtimes? (
		hip? (
			$(secure-version_gen_perl_depends)
			>=sys-libs/glibc-${GLIBC_PV}:=
			sys-apps/file:=
			dev-perl/URI-Encode
			dev-perl/File-BaseDir
			dev-perl/File-Copy-Recursive
			dev-perl/File-Listing
			dev-perl/File-Which
			~dev-util/hip-${PV}:=[${LIBSTDCXX_USEDEP},cuda?,rocm?]
		)
		rocm? (
			~dev-libs/rocm-device-libs-${PV}:=
			~dev-libs/rocr-runtime-${PV}:=[${LIBSTDCXX_USEDEP}]
		)
	)
	support-libs? (
		cuda? (
			~dev-build/rocm-cmake-${PV}:=
			~dev-libs/hipother-${PV}:=
		)
		rocm? (
			~dev-build/rocm-cmake-${PV}:=
			~dev-libs/rocm-core-${PV}:=[${LIBSTDCXX_USEDEP}]
		)
	)
"
