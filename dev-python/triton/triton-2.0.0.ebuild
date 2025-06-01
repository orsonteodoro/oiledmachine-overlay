# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Check pypi also for version update.

DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
GOOGLETEST_PV="1.12.1"
PYBIND11_PV="2.10.0"
PYTHON_COMPAT=( "python3_"{10..11} ) # Upstream only tests up to 3.6 for this release.

inherit dep-prepare distutils-r1 flag-o-matic

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/triton-lang/triton.git"
	FALLBACK_COMMIT="bd5c2117f62c73a9e922d5e93353a39ab3ac269b" # Mar 2, 2023
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${P}"
	SRC_URI="
https://github.com/triton-lang/triton/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/google/googletest/archive/refs/tags/release-${GOOGLETEST_PV}.tar.gz
	-> googletest-release-${GOOGLETEST_PV}.tar.gz
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
	(
		all-rights-reserved
		custom
	)
	(
		all-rights-reserved
		LGPL-2.1+
	)
	BSD
	MIT
"
# all-rights-reserved custom - python/triton/third_party/cuda/include/cuda.h
# all-rights-reserved LGPL-2.1+ - include/triton/Tools/Sys/GetEnv.hpp
# BSD - third_party/googletest/googlemock/test/gmock-matchers-arithmetic_test.cc
# MIT - LICENSE
# The distro's LGPL-2.1+ license template does not contain all rights reserved.
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
LLVM_COMPAT=( 14 )
ROCM_SLOTS=(
	rocm_5_2
	rocm_5_1
)
LLVM_TARGETS=(
	AMDGPU
	NVPTX
)
IUSE+="
${LLVM_COMPAT[@]/#/llvm_slot_}
${LLVM_TARGETS[@]/#/llvm_targets_}
${ROCM_SLOTS[@]}
rocm test tutorials
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
# You need a local copy of dev-util/nvidia-cuda-toolkit if you want to use
# llvm_targets_NVPTX on llvm:14.
# Upstream missing GPU init section for AMDGPU.
#	!rocm
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
# This project uses nvcc from 12.0 but it doesn't exist on the distro.
#
# For CUDA compatibility, see
#
#   https://github.com/llvm/llvm-project/blob/llvmorg-14.0.6/clang/include/clang/Basic/Cuda.h#L37
#
# CUDA SDK ebuilds:
#
#   11.5:  https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-util/nvidia-cuda-toolkit/nvidia-cuda-toolkit-11.5.1-r1.ebuild?id=e51ca099bec28c5a27a7eb070e7c77a06790a30d
#
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/filelock[${PYTHON_USEDEP}]
	')
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	!rocm? (
		$(gen_llvm_rdepend)
	)
	llvm_targets_NVPTX? (
		llvm_slot_14? (
			|| (
				=dev-util/nvidia-cuda-toolkit-11.5*
			)
		)
		dev-util/nvidia-cuda-toolkit:=
	)
	rocm? (
		rocm_5_2? (
			sys-devel/llvm-roc:5.2[llvm_targets_X86,llvm_targets_AMDGPU,mlir]
		)
		rocm_5_1? (
			sys-devel/llvm-roc:5.1[llvm_targets_X86,llvm_targets_AMDGPU,mlir]
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
			dev-python/pycodestyle[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
		)
	')
	test? (
		sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	)
"
DOCS=( "README.md" )
_PATCHES=(
	"${FILESDIR}/${PN}-2.0.0-optionalize-gpu-targets-and-dynlib.patch"
	"${FILESDIR}/${PN}-2.0.0-llvm-static-linking.patch"
	"${FILESDIR}/${PN}-2.0.0-optionalize-gpu-init.patch"
	"${FILESDIR}/${PN}-2.0.0-customize-setup_py.patch"
	"${FILESDIR}/${PN}-2.0.0-cuda-hardcoded-paths.patch"
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
	if use rocm_5_2 && has_version "~sys-devel/llvm-roc-5.2.3" ; then
		llvm_root_dir="/opt/rocm-5.2.3/llvm" # LLVM 14.0.0git
		export ROCM_VERSION="5.2.3"
	elif use rocm_5_1 && has_version "~sys-devel/llvm-roc-5.1.3" ; then
		llvm_root_dir="/opt/rocm-5.1.3/llvm" # LLVM 14.0.0git
		export ROCM_VERSION="5.1.3"
	elif use llvm_slot_14 && has_version "llvm-core/llvm:14" && has_version "llvm-core/mlir:14"; then
		llvm_root_dir="/usr/lib/llvm/14"
		dynlib=1
	else
eerror "Cannot find a LLVM installation."
		die
	fi

	# No ROCm hardcoded paths.

	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:${llvm_root_dir}/bin|g")
einfo "PATH:  ${PATH}"

	if [[ "${PV}" == *"9999" ]] ; then
		export OFFLINE_INSTALL=0
	else
		export OFFLINE_INSTALL=1
	fi
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
