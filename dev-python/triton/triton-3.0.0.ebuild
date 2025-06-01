# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Check pypi also for version update.

DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
GOOGLETEST_PV="1.12.1"
PYBIND11_PV="2.11.1"
PYTHON_COMPAT=( "python3_"{10..11} )
ROCM_TRITON_COMMIT="5f0fa3a703a1ec7c9555d4a91788ebbe98cc7d42"

inherit dep-prepare distutils-r1 flag-o-matic hip-versions

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="release/3.0.x"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/triton-lang/triton.git"
	FALLBACK_COMMIT="764d4432cf422ea24f5e2942fa480270568be9bc" # Jan 17, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	EGIT_COMMIT="764d4432cf422ea24f5e2942fa480270568be9bc" # Jan 17, 2024
	#KEYWORDS="~amd64" # Ebuild still in development.
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
	S_TRITION="${WORKDIR}/${P}"
	SRC_URI="
https://github.com/triton-lang/triton/archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${EGIT_COMMIT:0:7}.tar.gz
https://github.com/google/googletest/archive/refs/tags/release-${GOOGLETEST_PV}.tar.gz
	-> googletest-release-${GOOGLETEST_PV}.tar.gz
https://github.com/pybind/pybind11/archive/refs/tags/v${PYBIND11_PV}.tar.gz
	-> pybind11-${PYBIND11_PV}.tar.gz
https://github.com/ROCm/triton/archive/${ROCM_TRITON_COMMIT}.tar.gz
	-> rocm-triton-${ROCM_TRITON_COMMIT:0:7}.tar.gz
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
		MIT
	)
	BSD
	MIT
"
# all-rights-reserved MIT - lib/Conversion/TritonGPUToLLVM/ClusterOpsToLLVM.cpp
# BSD - third_party/googletest/LICENSE
# MIT - LICENSE
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
LLVM_COMPAT=( 18 )
ROCM_SLOTS=(
	rocm_6_2
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
ebuild_revision_4
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
					llvm-core/mlir:${u}[llvm_targets_X86,llvm_targets_NVPTX?]
				)
				arm? (
					llvm-core/llvm:${u}[llvm_targets_ARM]
					llvm-core/mlir:${u}[llvm_targets_ARM]
				)
				arm64? (
					llvm-core/llvm:${u}[llvm_targets_AArch64]
					llvm-core/mlir:${u}[llvm_targets_AArch64]
				)
				loong? (
					llvm-core/llvm:${u}[llvm_targets_LoongArch]
					llvm-core/mlir:${u}[llvm_targets_LoongArch]
				)
				mips? (
					llvm-core/llvm:${u}[llvm_targets_Mips]
					llvm-core/mlir:${u}[llvm_targets_Mips]
				)
				ppc? (
					llvm-core/llvm:${u}[llvm_targets_PowerPC]
					llvm-core/mlir:${u}[llvm_targets_PowerPC]
				)
				ppc64? (
					llvm-core/llvm:${u}[llvm_targets_PowerPC]
					llvm-core/mlir:${u}[llvm_targets_PowerPC]
				)
				sparc? (
					llvm-core/llvm:${u}[llvm_targets_Sparc]
					llvm-core/mlir:${u}[llvm_targets_Sparc]
				)
				x86? (
					llvm-core/llvm:${u}[llvm_targets_X86,llvm_targets_NVPTX?]
					llvm-core/mlir:${u}[llvm_targets_X86,llvm_targets_NVPTX?]
				)
			)
		"
	done
}
#
# Triton upstream uses 12.3, but the LLVM project accepts 11.8.
#
# For CUDA compatibility, see
#
#   https://github.com/llvm/llvm-project/blob/llvmorg-18.1.8/clang/include/clang/Basic/Cuda.h#L44
#
# CUDA SDK ebuilds:
#
#   12.3:  https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-util/nvidia-cuda-toolkit/nvidia-cuda-toolkit-12.3.2.ebuild?id=d071cb72002d9422a4d1d94160012d222196173c
#
RDEPEND+="
	!rocm? (
		$(gen_llvm_rdepend)
	)
	llvm_targets_NVPTX? (
		=dev-util/nvidia-cuda-toolkit-12.3*
		dev-util/nvidia-cuda-toolkit:=
	)
	rocm? (
		rocm_6_2? (
			sys-devel/llvm-roc:6.2[llvm_targets_X86,llvm_targets_AMDGPU,mlir]
			~dev-libs/rocm-device-libs-${HIP_6_1_VERSION}:6.2
			~dev-util/hip-${HIP_6_1_VERSION}:6.2
		)
	)
	tutorials? (
		$(python_gen_cond_dep '
			dev-python/matplotlib[${PYTHON_USEDEP}]
			dev-python/tabulate[${PYTHON_USEDEP}]
		')
		sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-build/cmake-3.18
		>=dev-build/ninja-1.11.1
		dev-python/lit[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		test? (
			>=dev-python/scipy-1.7.1[${PYTHON_USEDEP}]
			dev-python/autopep8[${PYTHON_USEDEP}]
			dev-python/flake8[${PYTHON_USEDEP}]
			dev-python/isort[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/pandas[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
		)
	')
	test? (
		sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	)
"
DOCS=( "README.md" )
_PATCHES=(
	"${FILESDIR}/${PN}-3.0.0-dynlib.patch"
	"${FILESDIR}/${PN}-2.1.0-llvm-static-linking.patch"
	"${FILESDIR}/${PN}-3.0.0-customize-setup_py.patch"
	"${FILESDIR}/${PN}-3.0.0-offline-install.patch"
	"${FILESDIR}/${PN}-3.0.0-llvm-arch.patch"
	"${FILESDIR}/${PN}-3.0.0-rocm-hardcoded-paths.patch"
	"${FILESDIR}/${PN}-3.0.0-cuda-hardcoded-paths.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
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
		dep_prepare_mv "${WORKDIR}/triton-${ROCM_TRITON_COMMIT}" "${S}/third_party/amd"
	fi
}

src_prepare() {
	default
	eapply ${_PATCHES[@]}
	S="${WORKDIR}/${P}/python"

	# A hardcoded path in third_party/amd/backend/lib/libamdhip64.so
	rm -rf "third_party/amd/backend/lib/"* || die # It contains blobs from hip, rocm-device-libs.

	distutils-r1_src_prepare
}

get_llvm_arch() {
	if use amd64 ; then
		echo "X86"
	elif use arm ; then
		echo "ARM"
	elif use arm64 ; then
		echo "AArch64"
	elif use loong ; then
		echo "LoongArch"
	elif use mips ; then
		echo "Mips"
	elif use ppc ; then
		echo "PowerPC"
	elif use ppc64 ; then
		echo "PowerPC"
	elif use riscv ; then
		echo "RISCV"
	elif use sparc ; then
		echo "Sparc"
	elif use x86 ; then
		echo "X86"
	else
eerror "ARCH=${ARCH} is not supported for LLVM target."
		die
	fi
}

python_configure() {
einfo "Called python_configure"
	local dynlib=0
	local llvm_root_dir
	if use rocm_6_2 && has_version "~sys-devel/llvm-roc-6.2.0" ; then
		llvm_root_dir="/opt/rocm-6.2.0/llvm" # LLVM 18.0.0git
		export ROCM_VERSION="6.2.0"
	elif use llvm_slot_18 && has_version "llvm-core/llvm:18" && has_version "llvm-core/mlir:18" ; then
		llvm_root_dir="/usr/lib/llvm/18"
		dynlib=1
	else
eerror "Cannot find a LLVM installation."
		die
	fi

	if [[ -n "${ROCM_VERSION}" ]] ; then
		sed -i -e "s|@ROCM_VERSION@|${ROCM_VERSION}|g" $(grep -l -e "@ROCM_VERSION@" "${WORKDIR}") || die
	else
	# Placeholder
		sed -i -e "s|@ROCM_VERSION@|6.2.0|g" $(grep -l -e "@ROCM_VERSION@" "${WORKDIR}") || die
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

	export LLVM_ARCH=$(get_llvm_arch)
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
