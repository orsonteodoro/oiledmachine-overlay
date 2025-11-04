# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD="ignore"
LIBCXX_SLOT_VERIFY=0
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

# See https://github.com/ROCm/rocm-install-on-linux/blob/release/rocm-rel-6.4.3/docs/reference/system-requirements.rst
AMDGPU_TARGETS_COMPAT=(
	"gfx908"
	"gfx90a"
	"gfx942"
	"gfx1030"
	"gfx1100"
	"gfx1101"
	"gfx1200"
	"gfx1201"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_ROCM_6_4[@]}
)

inherit libstdcxx-slot rocm

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
	ebuild_revision_1
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
	for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		if [[ "${gpu}" == "${x}" ]] ; then
			return 0
		fi
	done
	return 1
}
gen_hipblaslt_rdepend() {
	local x
	for x in ${HIPBLASLT_6_4_AMDGPU_TARGETS_COMPAT[@]} ; do
		[[ "${x}" =~ "xnack" ]] && continue
		has_gpu "${x}" || continue
		echo "
			amdgpu_targets_${x}? (
				>=sci-libs/hipBLASLt-${PV}:${SLOT}[${LIBSTDCXX_USEDEP},$(get_rocm_usedep HIPBLASLT)]
				sci-libs/hipBLASLt:=
			)
		"
	done
}
gen_hipsparselt_rdepend() {
	local x
	for x in ${HIPSPARSELT_6_4_AMDGPU_TARGETS_COMPAT[@]} ; do
		[[ "${x}" =~ "xnack" ]] && continue
		has_gpu "${x}" || continue
		echo "
			amdgpu_targets_${x}? (
				>=sci-libs/hipSPARSELt-${PV}:${SLOT}[${LIBSTDCXX_USEDEP},rocm]
				sci-libs/hipSPARSELt:=
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
			>=dev-libs/rocm-comgr-${PV}:${SLOT}[${LIBSTDCXX_USEDEP}]
			dev-libs/rocm-comgr:=
			>=sys-devel/llvm-roc-${PV}:${SLOT}[${LIBSTDCXX_USEDEP}]
			sys-devel/llvm-roc:=
		)
	)
	math? (
		>=sci-libs/hipBLAS-${PV}:${SLOT}[${LIBSTDCXX_USEDEP},cuda?,rocm?]
		sci-libs/hipBLAS:=
		>=sci-libs/hipRAND-${PV}:${SLOT}[${LIBSTDCXX_USEDEP},cuda?,rocm?]
		sci-libs/hipRAND:=
		>=sci-libs/hipSOLVER-${PV}:${SLOT}[${LIBSTDCXX_USEDEP},cuda?,rocm?]
		sci-libs/hipSOLVER:=
		>=sci-libs/hipSPARSE-${PV}:${SLOT}[${LIBSTDCXX_USEDEP},cuda?,rocm?]
		sci-libs/hipSPARSE:=
		cuda? (
			>=sci-libs/hipFFT-${PV}:${SLOT}[${LIBSTDCXX_USEDEP},cuda]
			sci-libs/hipFFT:=
		)
		fortran? (
			>=dev-util/hipfort-${PV}:${SLOT}
			dev-util/hipfort:=
		)
		rocm? (
			>=sci-libs/hipFFT-${PV}:${SLOT}[${LIBSTDCXX_USEDEP},$(get_rocm_usedep HIPFFT)]
			sci-libs/hipFFT:=
			$(gen_hipblaslt_rdepend)
			$(gen_hipsparselt_rdepend)
		)
	)
	primitives? (
		>=sci-libs/hipTensor-${PV}:${SLOT}[${LIBSTDCXX_USEDEP},cuda?,rocm?]
		sci-libs/hipTensor:=
		cuda? (
			>=sci-libs/hipCUB-${PV}:${SLOT}[${LIBSTDCXX_USEDEP},cuda]
			sci-libs/hipCUB:=
		)
		rocm? (
			>=sci-libs/hipCUB-${PV}:${SLOT}[${LIBSTDCXX_USEDEP},$(get_rocm_usedep HIPCUB)]
			sci-libs/hipCUB:=
		)
	)
	runtimes? (
		hip? (
			>=dev-lang/perl-5.0
			sys-apps/file
			gcc_slot_12_5? (
				>=sys-libs/glibc-2.35
			)
			gcc_slot_13_4? (
				>=sys-libs/glibc-2.39
			)
			dev-perl/URI-Encode
			dev-perl/File-BaseDir
			dev-perl/File-Copy-Recursive
			dev-perl/File-Listing
			dev-perl/File-Which
			>=dev-util/hip-${PV}:${SLOT}[${LIBSTDCXX_USEDEP},cuda?,rocm?]
			dev-util/hip:=
		)
		rocm? (
			>=dev-libs/rocm-device-libs-${PV}:${SLOT}
			dev-libs/rocm-device-libs:=
			>=dev-libs/rocr-runtime-${PV}:${SLOT}[${LIBSTDCXX_USEDEP}]
			dev-libs/rocr-runtime:=
		)
	)
	support-libs? (
		cuda? (
			>=dev-build/rocm-cmake-${PV}:${SLOT}
			dev-build/rocm-cmake:=
			>=dev-libs/hipother-${PV}:${SLOT}
			dev-libs/hipother:=
		)
		rocm? (
			>=dev-build/rocm-cmake-${PV}:${SLOT}
			dev-build/rocm-cmake:=
			>=dev-libs/rocm-core-${PV}:${SLOT}[${LIBSTDCXX_USEDEP}]
			dev-libs/rocm-core:=
		)
	)
"
