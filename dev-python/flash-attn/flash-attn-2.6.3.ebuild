# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U20

# TODO package:
# move dev-python/einops to sci-libs/einops
# hydra-colorlog
# hydra-core

COMPOSABLE_KERNEL_COMMIT="8182976c37433808b5e3a27a6536d1b74b0c23a1"
CUTLASS_COMMIT="756c351b4994854b2f8c6dded3821ebbb580876b"
#DISTUTILS_EXT=1 # TODO:  enable if required
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # Lists up to 3.12

AMDGPU_TARGETS_COMPAT=(
	"gfx90a"
	"gfx940"
	"gfx941"
	"gfx942"
)

inherit hip-versions
ROCM_SLOTS=(
	# For RDEPEND
#	"${HIP_6_2_VERSION}" # Not supported by pytorch ebuilds yet
	"${HIP_6_1_VERSION}" # Corresponds to pytorch 2.4.0 ebuild ; See https://github.com/Dao-AILab/flash-attention/issues/1086#issuecomment-2253854489
	"${HIP_6_0_VERSION}" # Corresponds to pytorch 2.3.0 ebuild.
)

gen_rocm_iuse() {
	local pv
	for pv in ${ROCM_SLOTS[@]} ; do
		local u=$(ver_cut 1-2 "${pv}")
		u="${u/./_}"
		echo "rocm_${u}"
	done
}

ROCM_IUSE=(
	$(gen_rocm_iuse)
)

inherit dep-prepare distutils-r1

#KEYWORDS="~amd64" # The ebuild is not install tested
S="${WORKDIR}/flash-attention-${PV}"
SRC_URI="
https://github.com/Dao-AILab/flash-attention/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	rocm? (
https://github.com/ROCm/composable_kernel/archive/${COMPOSABLE_KERNEL_COMMIT}.tar.gz
	-> composable_kernel-${COMPOSABLE_KERNEL_COMMIT:0:7}.tar.gz
	)
	cuda? (
https://github.com/NVIDIA/cutlass/archive/${CUTLASS_COMMIT}.tar.gz
	-> cutlass-${CUTLASS_COMMIT:0:7}.tar.gz
	)
"

DESCRIPTION="Fast and memory-efficient exact attention"
HOMEPAGE="
https://github.com/Dao-AILab/flash-attention
"
LICENSE="
	BSD
	cuda? (
		BSD
		MIT
	)
	rocm? (
		(
			all-rights-reserved
			MIT
		)
	)
"
# all-rights-reserved MIT - csrc/composable_kernel/LICENSE
# BSD - LICENSE
# BSD - csrc/cutlass/python/LICENSE.txt
# MIT - csrc/cutlass/python/docs/_static/scripts/furo.js.LICENSE.txt
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="mirror test" # Untested
SLOT="0"
IUSE="
${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}
${ROCM_IUSE[@]}
cuda rocm training
ebuild_revision_2
"
gen_rocm_required_use() {
	local pv
	for pv in ${ROCM_SLOTS[@]} ; do
		local u=$(ver_cut 1-2 "${pv}")
		u="${u/./_}"
		echo "
			rocm_${u}? (
				rocm
			)
		"
	done
}
gen_rocm_targets_required_use() {
	local g
	for g in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		echo "
			amdgpu_targets_${g}? (
				rocm
			)
		"
	done
}
REQUIRED_USE="
	$(gen_rocm_required_use)
	$(gen_rocm_targets_required_use)
	^^ (
		cuda
		rocm
	)
	rocm? (
		^^ (
			${ROCM_IUSE[@]}
		)
	)
"
gen_rocm_rdepend() {
	local pv
	for pv in ${ROCM_SLOTS[@]} ; do
		local s=$(ver_cut 1-2 ${pv})
		local u="${s}"
		u="${u/./_}"
	# Check both the direct top and indirect bottom dependencies
		echo "
			rocm_${u}? (
				~dev-build/rocm-cmake-${pv}:${s}
				~dev-util/hip-${pv}:${s}[rocm]
			)
		"
	done
}

RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/einops[${PYTHON_USEDEP}]
	')
	(
		|| (
			=sci-ml/pytorch-2.4*[${PYTHON_SINGLE_USEDEP}]
			=sci-ml/pytorch-2.3*[${PYTHON_SINGLE_USEDEP}]
			=sci-ml/pytorch-2.2*[${PYTHON_SINGLE_USEDEP}]
			=sci-ml/pytorch-2.1*[${PYTHON_SINGLE_USEDEP}]
			=sci-ml/pytorch-2.0*[${PYTHON_SINGLE_USEDEP}]
		)
		sci-ml/pytorch:=
	)
	cuda? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12.3*
			=dev-util/nvidia-cuda-toolkit-11.8*
		)
		dev-util/nvidia-cuda-toolkit:=
	)
	rocm? (
		$(gen_rocm_rdepend)
	)
	rocm_6_0? (
		=sci-ml/pytorch-2.3*[${PYTHON_SINGLE_USEDEP},rocm_6_0]
	)
	rocm_6_1? (
		=sci-ml/pytorch-2.4*[${PYTHON_SINGLE_USEDEP},rocm_6_1]
	)
	training? (
		$(python_gen_cond_dep '
			dev-python/einops[${PYTHON_USEDEP}]
			dev-python/hydra-colorlog[${PYTHON_USEDEP}]
			dev-python/hydra-core[${PYTHON_USEDEP}]
			dev-python/python-dotenv[${PYTHON_USEDEP}]
			dev-python/rich[${PYTHON_USEDEP}]
		')
		dev-python/timm[${PYTHON_SINGLE_USEDEP}]
		dev-python/triton[${PYTHON_SINGLE_USEDEP}]
		sci-ml/torchvision[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-build/ninja
	$(python_gen_cond_dep '
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		test? (
			dev-python/black[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
		)
	')
	test? (
		sci-ml/transformers[${PYTHON_SINGLE_USEDEP}]
	)
"
DOCS=( "AUTHORS" "usage.md" )

distutils_enable_tests "pytest"

src_prepare() {
	distutils-r1_python_prepare_all
	if use cuda ; then
		dep_prepare_mv "${WORKDIR}/cutlass-${CUTLASS_COMMIT}" "${S}/csrc/cutlass"
		eapply "${FILESDIR}/${PN}-2.6.3-cutlass-hardcoded-paths.patch"
	fi
	if use rocm ; then
		dep_prepare_mv "${WORKDIR}/composable_kernel-${COMPOSABLE_KERNEL_COMMIT}" "${S}/csrc/composable_kernel"
		eapply "${FILESDIR}/${PN}-2.6.3-composable_kernel-hardcoded-paths.patch"
		local ROCM_VERSION
		if use rocm_6_0 ; then
			ROCM_VERSION="${HIP_6_0_VERSION}"
		elif use rocm_6_1 ; then
			ROCM_VERSION="${HIP_6_1_VERSION}"
		fi
	else
		sed -i -e "s|@ROCM_VERSION@|6.1.2|g" $(grep -l "@ROCM_VERSION@") || die
	fi
}

python_configure() {
	if use cuda ; then
		export BUILD_TARGET="cuda"
	elif use rocm ; then
		export BUILD_TARGET="rocm"
		local list=""
		for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
			if use "amdgpu_targets_${x}" ; then
				list+=";${x}"
			fi
		done
		list="${list:1}"
		export GPU_ARCHS="${list}"
	fi
}

src_install() {
	distutils-r1_src_install
# TODO:  enable if not installed
#	if use training ; then
#		insinto "/usr/share/${PN}"
#		doins -r "${S}/training"
#	fi
}
