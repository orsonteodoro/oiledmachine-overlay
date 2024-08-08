# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This is the python portion of the package.

# For requirements, see
# https://github.com/pytorch/pytorch/blob/v2.3.1/RELEASE.md?plain=1#L49

AMDGPU_TARGETS_COMPAT=(
	gfx700
	gfx701
	gfx801
	gfx802
	gfx803
	gfx900
	gfx902
	gfx904
	gfx906
	gfx908
	gfx90a
	gfx90c
	gfx1010
	gfx1011
	gfx1012
	gfx1013
	gfx1030
	gfx1031
	gfx1032
	gfx1033
	gfx1034
	gfx1035
)
AMDGPU_TARGETS_UNTESTED=(
	gfx700
	gfx701
	gfx801
	gfx802
	gfx803
	gfx900
	gfx902
	gfx904
#	gfx906
	gfx908
	gfx90a
	gfx90c
	gfx1010
	gfx1011
	gfx1012
	gfx1013
	gfx1030
	gfx1031
	gfx1032
	gfx1033
	gfx1034
	gfx1035
)
CUDA_TARGETS_COMPAT=(
# Builds for all cards
	auto

# Observed:
	#sm_35 # Dropped based on RELEASE.md:  Release Compatibility Matrix
	sm_50_plus_ptx
	sm_52
	sm_60
	sm_61
	sm_70
	sm_70_plus_ptx
	sm_75
	sm_80
	sm_86
)
AMDGPU_TARGETS_USEDEP=("${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}")
AMDGPU_TARGETS_USEDEP=("${AMDGPU_TARGETS_USEDEP[@]/%/?}")
AMDGPU_TARGETS_USEDEP="${AMDGPU_TARGETS_USEDEP[@]}"
AMDGPU_TARGETS_USEDEP="${AMDGPU_TARGETS_USEDEP// /,}"
CUDA_PV="11.8" # 11.7 minimum required
CUDA_TARGETS_USEDEP=("${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}")
CUDA_TARGETS_USEDEP=("${CUDA_TARGETS_USEDEP[@]/%/?}")
CUDA_TARGETS_USEDEP="${CUDA_TARGETS_USEDEP[@]}"
CUDA_TARGETS_USEDEP="${CUDA_TARGETS_USEDEP// /,}"
DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..11} ) # Upstream only allows <= 3.11
inherit hip-versions
ROCM_SLOTS=(
# See https://github.com/pytorch/pytorch/blob/v2.3.1/.github/workflows/trunk.yml#L180
	"${HIP_6_0_VERSION}"
	"${HIP_5_7_VERSION}"
)
gen_rocm_slots() {
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		local s="${s%.*}"
		s="${s/./_}"
		echo "rocm_${s}"
	done
}
ROCM_SLOTS2=( $(gen_rocm_slots) )

inherit distutils-r1 prefix rocm

SRC_URI="
https://github.com/pytorch/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Tensors and Dynamic neural networks in Python"
HOMEPAGE="https://pytorch.org/"
LICENSE="BSD"
RESTRICT="test"
SLOT="0"
KEYWORDS="~amd64"
IUSE="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${ROCM_IUSE}
${ROCM_SLOTS2[@]}
cuda rocm
"
gen_cuda_required_use() {
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		echo "
			cuda_targets_${x}? (
				cuda
			)
		"
	done
}
gen_rocm_required_use() {
	local x
	for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		echo "
			amdgpu_targets_${x}? (
				rocm
			)
		"
	done
}
REQUIRED_USE="
	$(gen_cuda_required_use)
	$(gen_rocm_required_use)
	?? (
		cuda
		rocm
	)
	cuda? (
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	rocm? (
		${ROCM_REQUIRED_USE}
		^^ (
			${ROCM_SLOTS2[@]}
		)
	)
	${PYTHON_REQUIRED_USE}
"
gen_rocm_depends() {
	local pv
	for pv in ${ROCM_SLOTS[@]} ; do
		local s=$(ver_cut 1-2 ${pv})
		local u="${s}"
		u="${u/./_}"
		echo "
			rocm_${u}? (
				~dev-libs/rccl-${pv}:${s}
				~dev-libs/rocm-comgr-${pv}:${s}
				~dev-libs/rocm-core-${pv}:${s}
				~dev-libs/rocr-runtime-${pv}:${s}
				~dev-util/hip-${pv}:${s}[rocm]
				~dev-util/rocprofiler-${pv}:${s}
				~dev-util/roctracer-${pv}:${s}
				~sci-libs/hipCUB-${pv}:${s}[rocm]
				~sci-libs/hipSPARSE-${pv}:${s}[rocm]
				~sci-libs/hipFFT-${pv}:${s}[rocm]
				~sci-libs/miopen-${pv}:${s}[rocm]
				~sci-libs/rocBLAS-${pv}:${s}[rocm]
				~sci-libs/rocFFT-${pv}:${s}[rocm]
				~sci-libs/rocRAND-${pv}:${s}[rocm]
				~sci-libs/rocPRIM-${pv}:${s}[rocm]
				~sci-libs/rocThrust-${pv}:${s}
			)
		"
	done
}
RDEPEND="
	$(python_gen_cond_dep '
		dev-python/sympy[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	')
	${PYTHON_DEPS}
	~sci-libs/caffe2-${PV}[${AMDGPU_TARGETS_USEDEP},${CUDA_TARGETS_USEDEP},${PYTHON_SINGLE_USEDEP},cuda=,rocm=]
	cuda? (
		cuda_targets_auto? (
			=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*:=
		)
		cuda_targets_sm_50_plus_ptx? (
			=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*:=
		)
		cuda_targets_sm_52? (
			=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*:=
		)
		cuda_targets_sm_60? (
			=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*:=
		)
		cuda_targets_sm_61? (
			=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*:=
		)
		cuda_targets_sm_70? (
			=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*:=
		)
		cuda_targets_sm_70_plus_ptx? (
			=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*:=
		)
		cuda_targets_sm_75? (
			=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*:=
		)
		cuda_targets_sm_80? (
			=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*:=
		)
		cuda_targets_sm_86? (
			=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*:=
		)
		=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*[profiler]
	)
	rocm? (
		|| (
			$(gen_rocm_depends)
		)
	)
"
DEPEND="
	$(python_gen_cond_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
	${RDEPEND}
"
BDEPEND="
"
_PATCHES=(
	"${FILESDIR}/${PN}-2.1.1-dontbuildagain.patch"
	"${FILESDIR}/pytorch-1.9.0-Change-library-directory-according-to-CMake-build.patch"
	"${FILESDIR}/${PN}-2.0.0-global-dlopen.patch"
	"${FILESDIR}/pytorch-1.7.1-torch_shm_manager.patch"
	"${FILESDIR}/${PN}-1.13.0-setup.patch"
	"${FILESDIR}/${PN}-2.2.1-emptyso.patch"
)

warn_untested_gpu() {
	local gpu
	for gpu in ${AMDGPU_TARGETS_UNTESTED[@]} ; do
		if use "amdgpu_targets_${gpu}" ; then
ewarn "${gpu} is not CI tested upstream."
		fi
	done
}

pkg_setup() {
	warn_untested_gpu
	python-single-r1_pkg_setup
}

src_prepare() {
	eapply ${_PATCHES[@]}

	# Set build dir for pytorch's setup
	sed -i \
		-e "/BUILD_DIR/s|build|/var/lib/caffe2/|" \
		"tools/setup_helpers/env.py" \
		|| die
	distutils-r1_src_prepare

	hprefixify "tools/setup_helpers/env.py"
}

python_compile() {
	# Python files only
	# For binaries/libs see caffe2
	mkdir -p "${BUILD_DIR}" || die
	cd "${S}" || die
	CMAKE_BUILD_DIR="${BUILD_DIR}" \
	PYTORCH_BUILD_VERSION="${PV}" \
	PYTORCH_BUILD_NUMBER=0 \
	USE_SYSTEM_LIBS=ON \
	distutils-r1_python_compile develop sdist
}

python_install() {
	USE_SYSTEM_LIBS=ON \
	distutils-r1_python_install
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
