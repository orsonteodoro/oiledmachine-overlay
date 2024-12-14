# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Check pypi also for version update.

DISTUTILS_EXT=1
GOOGLETEST_PV="1.12.1"
INTEL_XPU_BACKEND_COMMIT="0bcc485f82b34d49494bd0264bacc24a20aafb7a"
PYBIND11_PV="2.10.0"
PYTHON_COMPAT=( "python3_"{10..11} )
SPIRV_HEADERS_COMMIT="cfbe4feef20c3c0628712c2792624f0221e378ac"
SPIRV_TOOLS_COMMIT="25ad5e19f193429b737433d5f6151062ddbc1680"

inherit dep-prepare distutils-r1 flag-o-matic hip-versions

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
https://github.com/google/googletest/archive/refs/tags/release-${GOOGLETEST_PV}.tar.gz
	-> googletest-release-${GOOGLETEST_PV}.tar.gz
https://github.com/pybind/pybind11/archive/refs/tags/v${PYBIND11_PV}.tar.gz
	-> pybind11-${PYBIND11_PV}.tar.gz
	video_cards_intel? (
https://github.com/intel/intel-xpu-backend-for-triton/archive/${INTEL_XPU_BACKEND_COMMIT}.tar.gz
	-> intel-xpu-backend-for-triton-${INTEL_XPU_BACKEND_COMMIT:0:7}.tar.gz
https://github.com/KhronosGroup/SPIRV-Headers/archive/${SPIRV_HEADERS_COMMIT}.tar.gz
	-> SPIRV-Headers-${SPIRV_HEADERS_COMMIT:0:7}.tar.gz
https://github.com/KhronosGroup/SPIRV-Tools/archive/${SPIRV_TOOLS_COMMIT}.tar.gz
	-> SPIRV-Tools-${SPIRV_TOOLS_COMMIT:0:7}.tar.gz
	)
	"
fi

DESCRIPTION="The Triton language and compiler"
HOMEPAGE="
	https://triton-lang.org/
	https://github.com/triton-lang/triton
"
LICENSE="
	(
		all-rights-reserved
		custom
	)
	(
		all-rights-reserved
		LGPL-2.1+
	)
	(
		Apache-2.0-with-LLVM-exceptions
		custom
		UoI-NCSA
	)
	BSD
	Khronos-CLHPP
	MIT
"
# all-rights-reserved Apache-2.0 - third_party/intel_xpu_backend/third_party/SPIRV-Tools/test/fuzzers/BUILD.gn
# all-rights-reserved custom - python/triton/third_party/cuda/include/cuda.h
# all-rights-reserved LGPL-2.1+ - include/triton/Tools/Sys/GetEnv.hpp
# Apache-2.0 - third_party/intel_xpu_backend/third_party/SPIRV-Tools/utils/vscode/src/lsp/LICENSE
# Apache-2.0-with-LLVM-exceptions custom UoI-NCSA - third_party/intel_xpu_backend/third-party-programs.txt
# BSD - third_party/googletest/LICENSE
# Khronos-CLHPP - third_party/intel_xpu_backend/third_party/SPIRV-Headers/LICENSE
# BSD - third_party/googletest/googlemock/test/gmock-matchers-arithmetic_test.cc
# MIT - third_party/intel_xpu_backend/LICENSE
# MIT - LICENSE
# The distro's Apache-2.0 license template does not contain all rights reserved.
# The distro's LGPL-2.1+ license template does not contain all rights reserved.
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
${LLVM_TARGETS[@]/#/llvm_targets_}
${ROCM_SLOTS[@]}
rocm test tutorials video_cards_intel
ebuild-revision-4
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
# LoongArch appears in LLVM 16 (llvm/lib/Target folder)
gen_llvm_rdepend() {
	local u
	for u in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${u}? (
				amd64? (
					llvm-core/llvm:${u}[llvm_targets_X86,llvm_targets_NVPTX?]
					sys-devel/mlir:${u}[llvm_targets_X86,llvm_targets_NVPTX?]
				)
				arm? (
					llvm-core/llvm:${u}[llvm_targets_ARM]
					sys-devel/mlir:${u}[llvm_targets_ARM]
				)
				arm64? (
					llvm-core/llvm:${u}[llvm_targets_AArch64]
					sys-devel/mlir:${u}[llvm_targets_AArch64]
				)
				loong? (
					llvm-core/llvm:${u}[llvm_targets_LoongArch]
					sys-devel/mlir:${u}[llvm_targets_LoongArch]
				)
				mips? (
					llvm-core/llvm:${u}[llvm_targets_Mips]
					sys-devel/mlir:${u}[llvm_targets_Mips]
				)
				ppc? (
					llvm-core/llvm:${u}[llvm_targets_PowerPC]
					sys-devel/mlir:${u}[llvm_targets_PowerPC]
				)
				ppc64? (
					llvm-core/llvm:${u}[llvm_targets_PowerPC]
					sys-devel/mlir:${u}[llvm_targets_PowerPC]
				)
				sparc? (
					llvm-core/llvm:${u}[llvm_targets_Sparc]
					sys-devel/mlir:${u}[llvm_targets_Sparc]
				)
				x86? (
					llvm-core/llvm:${u}[llvm_targets_X86,llvm_targets_NVPTX?]
					sys-devel/mlir:${u}[llvm_targets_X86,llvm_targets_NVPTX?]
				)
			)
		"
	done
}
# This project uses nvcc from 12.1 but it doesn't exist on the distro.
#
# For CUDA compatibility, see
#
#   https://github.com/llvm/llvm-project/blob/llvmorg-17.0.6/clang/include/clang/Basic/Cuda.h#L42C26-L42C29
#
# CUDA SDK ebuilds:
#
#   11.8:  https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-util/nvidia-cuda-toolkit/nvidia-cuda-toolkit-11.8.0-r4.ebuild?id=d071cb72002d9422a4d1d94160012d222196173c
#
RDEPEND+="
	!rocm? (
		$(gen_llvm_rdepend)
	)
	llvm_targets_NVPTX? (
		=dev-util/nvidia-cuda-toolkit-11.8*
		dev-util/nvidia-cuda-toolkit:=
	)
	rocm? (
		rocm_6_1? (
			llvm-core/llvm-roc:6.1[llvm_targets_X86,llvm_targets_AMDGPU,mlir]
		)
		rocm_6_0? (
			llvm-core/llvm-roc:6.0[llvm_targets_X86,llvm_targets_AMDGPU,mlir]
		)
		rocm_5_7? (
			llvm-core/llvm-roc:5.7[llvm_targets_X86,llvm_targets_AMDGPU,mlir]
		)
	)
	tutorials? (
		$(python_gen_any_dep '
			sci-libs/pytorch[${PYTHON_SINGLE_USEDEP}]
		')
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/tabulate[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.18
	>=dev-build/ninja-1.11.1
	dev-python/lit[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		$(python_gen_any_dep '
			sci-libs/pytorch[${PYTHON_SINGLE_USEDEP}]
		')
		>=dev-python/scipy-1.7.1[${PYTHON_USEDEP}]
		dev-python/autopep8[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/isort[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )
_PATCHES=(
	"${FILESDIR}/${PN}-2.1.0-dynlib.patch"
	"${FILESDIR}/${PN}-2.1.0-llvm-static-linking.patch"
	"${FILESDIR}/${PN}-2.1.0-optionalize-targets.patch"
	"${FILESDIR}/${PN}-2.1.0-rename-to-llvm-17-target.patch" # The filename is kind of a misnomer but refers to the MLIRGPUOps -> MLIRGPUDialect rename discussed above.
	"${FILESDIR}/${PN}-2.1.0-optionalize-gpu-init.patch"
	"${FILESDIR}/${PN}-2.1.0-customize-setup_py.patch"
	"${FILESDIR}/${PN}-2.1.0-offline-install.patch"
	"${FILESDIR}/${PN}-2.1.0-rocm-hardcoded-paths.patch"
	"${FILESDIR}/${PN}-2.1.0-cuda-hardcoded-paths.patch"
)

pkg_setup() {
	python_setup
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		dep_prepare_mv "${WORKDIR}/googletest-release-${GOOGLETEST_PV}" "${S}/third_party/googletest"
		dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_PV}" "${S}/third_party/pybind11"
		if use video_cards_intel ; then
			dep_prepare_mv "${WORKDIR}/intel-xpu-backend-for-triton-${INTEL_XPU_BACKEND_COMMIT}" "${S}/third_party/intel_xpu_backend"
			dep_prepare_mv "${WORKDIR}/SPIRV-Headers-${SPIRV_HEADERS_COMMIT}" "${S}/third_party/intel_xpu_backend/third_party/SPIRV-Headers"
			dep_prepare_mv "${WORKDIR}/SPIRV-Tools-${SPIRV_TOOLS_COMMIT}" "${S}/third_party/intel_xpu_backend/third_party/SPIRV-Tools"
		fi
	fi
}

src_prepare() {
	default
	eapply ${_PATCHES[@]}
	if use video_cards_intel ; then
		eapply "${FILESDIR}/${PN}-2.1.0-rename-to-llvm-17-target-xpu.patch"
	fi
	S="${WORKDIR}/${P}/python"
	distutils-r1_src_prepare
}

python_configure() {
einfo "Called python_configure"
	local dynlib=0
	local llvm_root_dir
	if use rocm_6_1 && has_version "~llvm-core/llvm-roc-6.1.2" ; then
		llvm_root_dir="/opt/rocm-6.1.2/llvm" # LLVM 17.0.0git
		export ROCM_VERSION="6.1.2"
	elif use rocm_6_0 && has_version "~llvm-core/llvm-roc-6.0.2" ; then
		llvm_root_dir="/opt/rocm-6.0.2/llvm" # LLVM 17.0.0git
		export ROCM_VERSION="6.0.2"
	elif use rocm_5_7 && has_version "~llvm-core/llvm-roc-5.7.1" ; then
		llvm_root_dir="/opt/rocm-5.7.1/llvm" # LLVM 17.0.0git
		export ROCM_VERSION="5.7.1"
	elif use llvm_slot_17 && has_version "llvm-core/llvm:17" && has_version "sys-devel/mlir:17" ; then
		llvm_root_dir="/usr/lib/llvm/17"
		dynlib=1
	else
eerror "Cannot find a LLVM installation."
		die
	fi

	if [[ -n "${ROCM_VERSION}" ]] ; then
		sed -i -e "s|@ROCM_VERSION@|${ROCM_VERSION}|g" $(grep -l -e "@ROCM_VERSION@" "${WORKDIR}") || die
	else
	# Placeholder
		sed -i -e "s|@ROCM_VERSION@|6.1.2|g" $(grep -l -e "@ROCM_VERSION@" "${WORKDIR}") || die
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

	if use video_cards_intel ; then
		export TRITON_CODEGEN_INTEL_XPU_BACKEND=1
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
	if use tutorials ; then
		insinto "/usr/share/${PN}"
		doins -r "python/tutorials"
	fi
	if use rocm ; then
		local paths=(
			$(find "${ED}" -name "libtriton.so")
		)
		local x
		for x in ${paths[@]} ; do
einfo "Fixing RPATH for ${x}"
			patchelf --add-rpath "/opt/rocm-${ROCM_VERSION}/llvm/lib" "${x}" || die
		done
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
