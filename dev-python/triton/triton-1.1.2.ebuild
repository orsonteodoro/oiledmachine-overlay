# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Check pypi also for version update.

DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..11} ) # Upstream only tests up to 3.6 for this release.

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
	KEYWORDS="~amd64"
	S="${WORKDIR}/${P}"
	SRC_URI="
https://github.com/triton-lang/triton/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
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
# all-rights-reserved custom - include/triton/external/CUDA/nvml.h
# all-rights-reserved custom - include/triton/external/CUDA/cuda.h
# all-rights-reserved LGPL-2.1+ - include/triton/tools/sys/mkdir.hpp
# BSD - python/src/pybind11/chrono.h
# MIT - LICENSE
# The distro's LGPL-2.1+ license template does not contain all rights reserved.
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
LLVM_COMPAT=( {14..12} )
ROCM_SLOTS=(
	rocm_5_1
	rocm_4_5
	rocm_4_1
)
LLVM_TARGETS=(
	AMDGPU
	NVPTX
)
IUSE+="
${LLVM_COMPAT[@]/#/llvm_slot_}
${LLVM_TARGETS[@]/#/llvm_targets_}
${ROCM_SLOTS[@]}
bench rocm test tutorials
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
# llvm_targets_NVPTX on llvm:12, llvm:13, llvm: 14.
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
# For CUDA compatibility, see
#
#   https://github.com/llvm/llvm-project/blob/llvmorg-14.0.6/clang/include/clang/Basic/Cuda.h#L37
#
# CUDA SDK ebuilds:
#
#   10.0:  https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-util/nvidia-cuda-toolkit/nvidia-cuda-toolkit-10.0.130.ebuild?id=8abf2c93e0c63e966018d3192de7f5d958fc6b97
#   11.0:  https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-util/nvidia-cuda-toolkit/nvidia-cuda-toolkit-11.0.3.ebuild?id=8abf2c93e0c63e966018d3192de7f5d958fc6b97
#   11.2:  https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-util/nvidia-cuda-toolkit/nvidia-cuda-toolkit-11.2.2.ebuild?id=38b155fa1bf907617067c98eb4ba3a5d0790eb1a
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
		llvm_slot_12? (
			|| (
				=dev-util/nvidia-cuda-toolkit-11.0*
				=dev-util/nvidia-cuda-toolkit-10.1*
			)
		)
		llvm_slot_13? (
			|| (
				=dev-util/nvidia-cuda-toolkit-11.2*
				=dev-util/nvidia-cuda-toolkit-10.1*
			)
		)
		llvm_slot_14? (
			|| (
				=dev-util/nvidia-cuda-toolkit-11.5*
			)
		)
		dev-util/nvidia-cuda-toolkit:=
	)
	rocm? (
		rocm_5_1? (
			sys-devel/llvm-roc:5.1[llvm_targets_X86,llvm_targets_AMDGPU,mlir]
		)
		rocm_4_5? (
			sys-devel/llvm-roc:4.5[llvm_targets_X86,llvm_targets_AMDGPU,mlir]
		)
		rocm_4_1? (
			sys-devel/llvm-roc:4.1[llvm_targets_X86,llvm_targets_AMDGPU,mlir]
		)
	)
	tutorials? (
		$(python_gen_cond_dep '
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
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		bench? (
			dev-python/matplotlib[${PYTHON_USEDEP}]
			dev-python/pandas[${PYTHON_USEDEP}]
		)
		test? (
			dev-python/pandas[${PYTHON_USEDEP}]
			dev-python/scipy[${PYTHON_USEDEP}]
		)
	')
	test? (
		sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	)
"
DOCS=( "README.md" )
_PATCHES=(
	"${FILESDIR}/${PN}-1.1.2-optionalize-gpu-targets-and-dynlib.patch"
	"${FILESDIR}/${PN}-1.1.2-llvm-static-linking.patch"
	"${FILESDIR}/${PN}-1.1.2-optionalize-gpu-init-llvm_cc.patch"
	"${FILESDIR}/${PN}-1.1.2-customize-setup_py.patch"
	"${FILESDIR}/${PN}-1.1.2-cuda-path.patch"
	"${FILESDIR}/${PN}-1.1.2-llvm-path.patch"
	"${FILESDIR}/${PN}-1.1.2-rocm-hardcoded-paths.patch"
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
	if use rocm_5_1 && has_version "~sys-devel/llvm-roc-5.1.3" ; then
		llvm_root_dir="/opt/rocm-5.1.3/llvm" # LLVM 14.0.0git
		export ROCM_VERSION="5.1.3"
	elif use rocm_4_5 && has_version "~sys-devel/llvm-roc-4.5.2" ; then
		llvm_root_dir="/opt/rocm-4.5.2/llvm" # LLVM 13.0.0git
		export ROCM_VERSION="4.5.2"
	elif use rocm_4_1 && has_version "~sys-devel/llvm-roc-4.1.0" ; then
		llvm_root_dir="/opt/rocm-4.1.0/llvm" # LLVM 12.0.0git
		export ROCM_VERSION="4.1.0"
	elif use llvm_slot_14 && has_version "llvm-core/llvm:14" && has_version "llvm-core/mlir:14"; then
		llvm_root_dir="/usr/lib/llvm/14"
		dynlib=1
	elif use llvm_slot_13 && has_version "llvm-core/llvm:13" && has_version "llvm-core/mlir:13"; then
		llvm_root_dir="/usr/lib/llvm/13"
		dynlib=1
	elif use llvm_slot_12 && has_version "llvm-core/llvm:12" && has_version "llvm-core/mlir:12"; then
		llvm_root_dir="/usr/lib/llvm/12"
		dynlib=1
	else
eerror "Cannot find a LLVM installation."
		die
	fi

	if [[ -n "${ROCM_VERSION}" ]] ; then
		sed -i -e "s|@ROCM_VERSION@|${ROCM_VERSION}|g" $(grep -l -e "@ROCM_VERSION@" "${WORKDIR}") || die
	else
	# Placeholder
		sed -i -e "s|@ROCM_VERSION@|5.1.3|g" $(grep -l -e "@ROCM_VERSION@" "${WORKDIR}") || die
	fi

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

# TODO:
# add bench to python_test

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
