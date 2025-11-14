# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# llnl-hatchet

# You need to manually hard unmask the llvm_slot_19 USE flag if you want to use this ebuild.
# echo "dev-python/triton -llvm_slot_19" >> /etc/portage/profile/package.use.mask

# Check pypi also for version update.

#
# For CUDA compatibility, see
#
#   https://github.com/triton-lang/triton/blob/v3.5.1/cmake/nvidia-toolchain-version.json
#
# For ROCm compatibility, see
#
#   https://github.com/triton-lang/triton/blob/v3.5.1/.github/workflows/integration-tests-amd.yml#L18
#

inherit hip-versions

CXX_STANDARD=17
DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
GOOGLETEST_PV="1.17.0" # https://github.com/triton-lang/triton/blob/v3.5.1/unittest/googletest.cmake
PYTHON_COMPAT=( "python3_"{10..12} )

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	# Support object code version 5 for ROCm
	# https://github.com/ROCm/llvm-project/blob/d366fa84f3fdcbd4b10847ebd5db572ae12a34fb/clang/lib/Driver/ToolChains/AMDGPU.h#L93
	# The ^^ operator is bugged.
	{18..19}
	#${LIBCXX_COMPAT_CXX17_ROCM_6_4[@]/llvm_slot_} # 19
	#${LIBCXX_COMPAT_CXX17_ROCM_7_0[@]/llvm_slot_} # 19
	#${LIBCXX_COMPAT_CXX17_CUDA_12_8[@]/llvm_slot_} # 18, 19
)

ROCM_SLOTS=(
# No LLVM 19 release for ROCm yet.  Use 3.0.0 without _p1.
	"rocm_6_4" # Upstream uses ROCm 6.2 but relaxed to avoid issues
)

LLVM_TARGETS=(
	"AMDGPU"
	"NVPTX"
)

inherit dep-prepare distutils-r1 flag-o-matic hip-versions libcxx-slot libstdcxx-slot

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="release/3.0.x"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/triton-lang/triton.git"
	FALLBACK_COMMIT="0add68262ab0a2e33b84524346cb27cbb2787356" # Nov 11, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	EGIT_COMMIT="0add68262ab0a2e33b84524346cb27cbb2787356" # Nov 11, 2025
	#KEYWORDS="~amd64" # Ebuild still in development.
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
	S_TRITION="${WORKDIR}/${P}"
	SRC_URI="
https://github.com/triton-lang/triton/archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${EGIT_COMMIT:0:7}.tar.gz
https://github.com/google/googletest/archive/refs/tags/v${GOOGLETEST_PV}.tar.gz
	-> googletest-release-${GOOGLETEST_PV}.tar.gz
	"
fi

DESCRIPTION="Development repository for the Triton language and compiler"
HOMEPAGE="
	https://triton-lang.org/
	https://github.com/triton-lang/triton
"
LICENSE="
	BSD
	MIT
"
# BSD - third_party/googletest/LICENSE
# MIT - LICENSE
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${LLVM_COMPAT[@]/#/llvm_slot_}
${LLVM_TARGETS[@]/#/llvm_targets_}
${ROCM_SLOTS[@]}
cuda rocm test tutorials video_cards_intel
ebuild_revision_7
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
TRASH="
"
# The oiledmachine-overlay has strict version requirements for GPU support.  No testing means it is disabled.
# If tested, then the disabled ROCm support can be removed.
# ^^ is bugged.  If duplicate entry, it bugs.
REQUIRED_USE="
	!rocm
	!rocm? (
		^^ (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
	)
	cuda? (
		^^ (
			${LIBCXX_COMPAT_CXX17_CUDA_12_8[@]}
		)
	)
	rocm? (
		^^ (
			${LIBSTDCXX_COMPAT_ROCM_6_4[@]}
		)
		^^ (
			${LIBCXX_COMPAT_CXX17_ROCM_6_4[@]}
		)
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
					llvm-core/llvm:${u}[${LIBSTDCXX_USEDEP},llvm_targets_X86,llvm_targets_NVPTX?]
					llvm-core/mlir:${u}[${LIBSTDCXX_USEDEP},llvm_targets_X86,llvm_targets_NVPTX?]
				)
				arm? (
					llvm-core/llvm:${u}[${LIBSTDCXX_USEDEP},llvm_targets_ARM]
					llvm-core/mlir:${u}[${LIBSTDCXX_USEDEP},llvm_targets_ARM]
				)
				arm64? (
					llvm-core/llvm:${u}[${LIBSTDCXX_USEDEP},llvm_targets_AArch64]
					llvm-core/mlir:${u}[${LIBSTDCXX_USEDEP},llvm_targets_AArch64]
				)
				loong? (
					llvm-core/llvm:${u}[${LIBSTDCXX_USEDEP},llvm_targets_LoongArch]
					llvm-core/mlir:${u}[${LIBSTDCXX_USEDEP},llvm_targets_LoongArch]
				)
				mips? (
					llvm-core/llvm:${u}[${LIBSTDCXX_USEDEP},llvm_targets_Mips]
					llvm-core/mlir:${u}[${LIBSTDCXX_USEDEP},llvm_targets_Mips]
				)
				ppc? (
					llvm-core/llvm:${u}[${LIBSTDCXX_USEDEP},llvm_targets_PowerPC]
					llvm-core/mlir:${u}[${LIBSTDCXX_USEDEP},llvm_targets_PowerPC]
				)
				ppc64? (
					llvm-core/llvm:${u}[${LIBSTDCXX_USEDEP},llvm_targets_PowerPC]
					llvm-core/mlir:${u}[${LIBSTDCXX_USEDEP},llvm_targets_PowerPC]
				)
				sparc? (
					llvm-core/llvm:${u}[${LIBSTDCXX_USEDEP},llvm_targets_Sparc]
					llvm-core/mlir:${u}[${LIBSTDCXX_USEDEP},llvm_targets_Sparc]
				)
				x86? (
					llvm-core/llvm:${u}[${LIBSTDCXX_USEDEP},llvm_targets_X86,llvm_targets_NVPTX?]
					llvm-core/mlir:${u}[${LIBSTDCXX_USEDEP},llvm_targets_X86,llvm_targets_NVPTX?]
				)
				llvm-core/llvm:=
				llvm-core/mlir:=
			)
		"
	done
}

CUDA_12_8_DEPEND="
	(
		=dev-util/nvidia-cuda-toolkit-12.8*
		dev-util/nvidia-cuda-toolkit:=
		>=x11-drivers/nvidia-drivers-570.124
		virtual/cuda-compiler:0/12.8[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		virtual/cuda-compiler:=
	)
"

RDEPEND+="
	!rocm? (
		$(gen_llvm_rdepend)
	)
	llvm_targets_NVPTX? (
		${CUDA_12_8_DEPEND}
	)
	rocm? (
		rocm_6_4? (
			sys-devel/llvm-roc:6.4[${LIBSTDCXX_USEDEP},llvm_targets_X86,llvm_targets_AMDGPU,mlir]
			sys-devel/llvm-roc:=
		)
	)
	tutorials? (
		$(python_gen_cond_dep '
			dev-python/matplotlib[${PYTHON_USEDEP}]
			dev-python/tabulate[${PYTHON_USEDEP}]
		')
		sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
		sci-ml/caffe2[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		sci-ml/caffe2:=
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-build/cmake-3.20
		>=dev-build/ninja-1.11.1
		>=dev-python/pybind11-2.13.1[${PYTHON_USEDEP}]
		>=dev-python/setuptools-40.8.0[${PYTHON_USEDEP}]
		dev-python/lit[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		test? (
			>=dev-python/scipy-1.7.1[${PYTHON_USEDEP}]
			dev-python/autopep8[${PYTHON_USEDEP}]
			dev-python/flake8[${PYTHON_USEDEP}]
			dev-python/isort[${PYTHON_USEDEP}]
			dev-python/llnl-hatchet[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-forked[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
		)
		tutorials? (
			dev-python/pandas[${PYTHON_USEDEP}]
			dev-python/matplotlib[${PYTHON_USEDEP}]
			dev-python/tabulate[${PYTHON_USEDEP}]
		)
	')
	test? (
		sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
		sci-ml/caffe2[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		sci-ml/caffe2:=
	)
"
DOCS=( "README.md" )
_PATCHES=(
	"${FILESDIR}/${PN}-3.5.1-dynlib.patch"
	"${FILESDIR}/${PN}-2.1.0-llvm-static-linking.patch"
	"${FILESDIR}/${PN}-3.5.1-customize-setup_py.patch"
	"${FILESDIR}/${PN}-3.5.1-offline-install.patch"
	"${FILESDIR}/${PN}-3.5.1-llvm-arch.patch"
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
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_PV}" "${S}/third_party/googletest"
	fi
}

src_prepare() {
	default
	eapply ${_PATCHES[@]}
	S="${WORKDIR}/${P}/python"
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
	if use rocm_6_4 ; then
		llvm_root_dir="/opt/rocm/lib/llvm" # LLVM 19.0.0git
		export ROCM_VERSION="${HIP_6_4_VERSION}"
	elif use llvm_slot_19 && has_version "llvm-core/llvm:19" && has_version "llvm-core/mlir:19" ; then
		llvm_root_dir="/usr/lib/llvm/19"
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
