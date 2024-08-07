# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
GOOGLETEST_PV="1.12.1"
INTEL_XPU_BACKEND_COMMIT="0bcc485f82b34d49494bd0264bacc24a20aafb7a"
PYBIND11_PV="2.10.0"
PYTHON_COMPAT=( "python3_"{10..12} )
SPIRV_HEADERS_COMMIT="cfbe4feef20c3c0628712c2792624f0221e378ac"
SPIRV_TOOLS_COMMIT="25ad5e19f193429b737433d5f6151062ddbc1680"

inherit dep-prepare distutils-r1 flag-o-matic

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/triton-lang/triton.git"
	FALLBACK_COMMIT="da40a1e984bf57c4708daf603eb427442025f99b" # Aug 31, 2023
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	#KEYWORDS="~amd64" # Ebuild still in development.
	S="${WORKDIR}/${P}"
	S_TRITION="${WORKDIR}/${P}"
	SRC_URI="
https://github.com/triton-lang/triton/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/intel/intel-xpu-backend-for-triton/archive/${INTEL_XPU_BACKEND_COMMIT}.tar.gz
	-> intel-xpu-backend-for-triton-${INTEL_XPU_BACKEND_COMMIT:0:7}.tar.gz
https://github.com/google/googletest/archive/refs/tags/release-${GOOGLETEST_PV}.tar.gz
	-> googletest-release-${GOOGLETEST_PV}.tar.gz
https://github.com/KhronosGroup/SPIRV-Headers/archive/${SPIRV_HEADERS_COMMIT}.tar.gz
	-> SPIRV-Headers-${SPIRV_HEADERS_COMMIT:0:7}.tar.gz
https://github.com/KhronosGroup/SPIRV-Tools/archive/${SPIRV_TOOLS_COMMIT}.tar.gz
	-> SPIRV-Tools-${SPIRV_TOOLS_COMMIT:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/refs/tags/v${PYBIND11_PV}.tar.gz
	-> pybind11-${PYBIND11_PV}.tar.gz
	"
fi

DESCRIPTION="Development repository for the Triton language and compiler"
HOMEPAGE="
	https://triton-lang.org/
	https://github.com/triton-lang/triton
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
# Missing target errors:
# MLIRArithDialect - LLVM 16
# MLIRArithToLLVM - LLVM 16
# MLIRBuiltinToLLVMIRTranslation - LLVM 17
# MLIRExecutionEngineUtils - LLVM 15
# MLIRGPUOps - LLVM 13 (MIN), LLVM 16 (MAX), Renamed to MLIRGPUDialect in LLVM 17
# MLIRGPUTransforms - LLVM 13
# MLIRIndexToLLVM - LLVM 16
# MLIRLLVMDialect - LLVM 15
# MLIRLLVMToLLVMIRTranslation - LLVM 13
# MLIRMathDialect - LLVM 15
# MLIRNVVMToLLVMIRTranslation - LLVM 13
# MLIRROCDLToLLVMIRTranslation - LLVM 13
# MLIRSCFDialect - LLVM 15
# MLIRSCFToControlFlow - LLVM 15
# MLIRTargetLLVMIRExport - LLVM 13
LLVM_COMPAT=( 17 )
ROCM_SLOTS=(
	rocm_6_1
	rocm_6_0
	rocm_5_7
)
LLVM_TARGETS=(
	AMDGPU
	NVPTX
)
IUSE+="
${LLVM_COMPAT[@]/#/llvm_slot_}
${ROCM_SLOTS[@]}
${LLVM_TARGETS[@]/#/llvm_targets_}
rocm
"
gen_rocm_required_use() {
	local u
	for u in ${ROCM_SLOTS[@]} ; do
		echo "
			${u}? (
				rocm
			)
		"
	done
}
REQUIRED_USE="
	!rocm? (
		^^ (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
	)
	rocm? (
		^^ (
			$(gen_rocm_required_use)
		)
	)
"
gen_llvm_rdepend() {
	local u
	for u in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${u}? (
				amd64? (
					sys-devel/llvm:${u}[llvm_targets_X86,llvm_targets_NVPTX?]
					sys-devel/mlir:${u}[llvm_targets_X86,llvm_targets_NVPTX?]
				)
				arm? (
					sys-devel/llvm:${u}[llvm_targets_ARM]
					sys-devel/mlir:${u}[llvm_targets_ARM]
				)
				arm64? (
					sys-devel/llvm:${u}[llvm_targets_AArch64]
					sys-devel/mlir:${u}[llvm_targets_AArch64]
				)
				loong? (
					sys-devel/llvm:${u}[llvm_targets_LoongArch]
					sys-devel/mlir:${u}[llvm_targets_LoongArch]
				)
				mips? (
					sys-devel/llvm:${u}[llvm_targets_Mips]
					sys-devel/mlir:${u}[llvm_targets_Mips]
				)
				ppc? (
					sys-devel/llvm:${u}[llvm_targets_PowerPC]
					sys-devel/mlir:${u}[llvm_targets_PowerPC]
				)
				ppc64? (
					sys-devel/llvm:${u}[llvm_targets_PowerPC]
					sys-devel/mlir:${u}[llvm_targets_PowerPC]
				)
				sparc? (
					sys-devel/llvm:${u}[llvm_targets_Sparc]
					sys-devel/mlir:${u}[llvm_targets_Sparc]
				)
				x86? (
					sys-devel/llvm:${u}[llvm_targets_X86,llvm_targets_NVPTX?]
					sys-devel/mlir:${u}[llvm_targets_X86,llvm_targets_NVPTX?]
				)
			)
		"
	done
}
# This project uses nvcc from 12.1 but it doesn't exist on the distro.  The nvcc
# used is based on
# https://github.com/llvm/llvm-project/blob/llvmorg-17.0.6/clang/include/clang/Basic/Cuda.h#L42C26-L42C29
RDEPEND+="
	!rocm? (
		$(gen_llvm_rdepend)
	)
	rocm? (
		rocm_6_1? (
			sys-devel/llvm-roc:6.1[llvm_targets_X86,llvm_targets_AMDGPU,mlir]
		)
		rocm_6_0? (
			sys-devel/llvm-roc:6.0[llvm_targets_X86,llvm_targets_AMDGPU,mlir]
		)
		rocm_5_7? (
			sys-devel/llvm-roc:5.7[llvm_targets_X86,llvm_targets_AMDGPU,mlir]
		)
	)
	llvm_targets_NVPTX? (
		=dev-util/nvidia-cuda-toolkit-11.8*
		dev-util/nvidia-cuda-toolkit:=
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.18
	>=dev-build/ninja-1.11.1
"
DOCS=( "README.md" )
_PATCHES=(
	"${FILESDIR}/${PN}-2.1.0-dynlib.patch"
	"${FILESDIR}/${PN}-2.1.0-llvm-static-linking.patch"
	"${FILESDIR}/${PN}-2.1.0-optionalize-targets.patch"
	"${FILESDIR}/${PN}-2.1.0-rename-to-llvm-17-target.patch"
	"${FILESDIR}/${PN}-2.1.0-optionalize-gpu-init.patch"
	"${FILESDIR}/${PN}-2.1.0-customize-setup_py.patch"
	"${FILESDIR}/${PN}-2.1.0-offline-install.patch"
)

pkg_setup() {
	ewarn "This ebuild is still in development"
	:
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		dep_prepare_mv "${WORKDIR}/intel-xpu-backend-for-triton-${INTEL_XPU_BACKEND_COMMIT}" "${S}/third_party/intel_xpu_backend"
		dep_prepare_mv "${WORKDIR}/googletest-release-${GOOGLETEST_PV}" "${S}/third_party/googletest"
		dep_prepare_mv "${WORKDIR}/SPIRV-Headers-${SPIRV_HEADERS_COMMIT}" "${S}/third_party/intel_xpu_backend/third_party/SPIRV-Headers"
		dep_prepare_mv "${WORKDIR}/SPIRV-Tools-${SPIRV_TOOLS_COMMIT}" "${S}/third_party/intel_xpu_backend/third_party/SPIRV-Tools"
		dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_PV}" "${S}/third_party/pybind11"
	fi
}

src_prepare() {
	default
	eapply ${_PATCHES[@]}
	S="${WORKDIR}/${P}/python"
	distutils-r1_src_prepare
}

python_configure() {
einfo "Called python_configure"
	local dynlib=0
	local llvm_root_dir
	if use rocm_6_1 && has_version "~sys-devel/llvm-roc-6.1.2" ; then
		llvm_root_dir="/opt/rocm-6.1.2/llvm" # LLVM 17.0.0git
	elif use rocm_6_0 && has_version "~sys-devel/llvm-roc-6.0.2" ; then
		llvm_root_dir="/opt/rocm-6.0.2/llvm" # LLVM 17.0.0git
	elif use rocm_5_7 && has_version "~sys-devel/llvm-roc-5.7.1" ; then
		llvm_root_dir="/opt/rocm-5.7.1/llvm" # LLVM 17.0.0git
	elif use llvm_slot_17 && has_version "sys-devel/llvm:17" && has_version "sys-devel/mlir:17" ; then
		llvm_root_dir="/usr/lib/llvm/17"
		dynlib=1
	else
eerror "Cannot find a LLVM installation."
		die
	fi

	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:${llvm_root_dir}/bin|g")
einfo "PATH:  ${PATH}"

	export USE_SYSTEM_LLVM=1
	if use rocm ; then
		export LLVM_INCLUDE_DIR="${llvm_root_dir}/include"
		export LLVM_LIBRARY_DIR="${llvm_root_dir}/lib"
	else
		export LLVM_INCLUDE_DIR="${llvm_root_dir}/include"
		export LLVM_LIBRARY_DIR="${llvm_root_dir}/$(get_libdir)"
	fi

	export LLVM_ROOT_DIR="${llvm_root_dir}"
	if use rocm ; then
		export USE_ROCM=1
	else
		export USE_ROCM=0
	fi
	if (( ${dynlib} == 1 )) ; then
		export USE_DYNLIB=1
	else
		export USE_DYNLIB=0
	fi

	if [[ "${PV}" == *"9999" ]] ; then
		export OFFLINE_INSTALL=0
	else
		export OFFLINE_INSTALL=1
		export FETCHCONTENT_GOOGLETEST_DIR="${S_TRITION}/third_party/googletest"
		export FETCHCONTENT_SPIRV_HEADERS_DIR="${S_TRITION}/third_party/intel_xpu_backend/third_party/SPIRV-Headers"
		export FETCHCONTENT_SPIRV_TOOLS_DIR="${S_TRITION}/third_party/intel_xpu_backend/third_party/SPIRV-Tools"
		export PYBIND11_INCLUDE_DIR="${S_TRITION}/third_party/pybind11/include"
		export PYBIND11_SYSPATH="${S_TRITION}/third_party/pybind11/lib"
		export LLVM_INCLUDE_DIRS="${LLVM_INCLUDE_DIR}"
		export LLVM_LIBRARY_DIR="${LLVM_LIBRARY_DIR}"
		export LLVM_SYSPATH="${llvm_root_dir}"
	fi

	if use llvm_targets_AMDGPU ; then
		append-cxxflags -DUSE_AMDGPU
		export USE_AMDGPU=1
	else
		export USE_AMDGPU=0
	fi
	if use llvm_targets_NVPTX ; then
		append-cxxflags -DUSE_NVPTX
		export USE_NVPTX=1
	else
		export USE_NVPTX=0
	fi

}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
	cd "${WORKDIR}/${P}" || die
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
