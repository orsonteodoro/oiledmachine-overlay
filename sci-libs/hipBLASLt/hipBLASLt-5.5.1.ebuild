# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx90a_xnack_minus
	gfx90a_xnack_plus
)
CUDA_TARGETS_COMPAT=(
# The project does not define.
# Listed is same as rocFFT's.
        sm_60
	sm_70
	sm_75
	compute_60
        compute_70
        compute_75
)
CMAKE_MAKEFILE_GENERATOR="emake"
LLVM_MAX_SLOT=16
PYTHON_COMPAT=( python3_{10..11} )

inherit cmake flag-o-matic llvm python-r1 rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/hipBLASLt/"
	inherit git-r3
else
	SRC_URI="
https://github.com/ROCmSoftwarePlatform/hipBLASLt/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-rocm-${PV}"
fi

DESCRIPTION="hipBLASLt is a library that provides general matrix-matrix \
operations with a flexible API and extends functionalities beyond a \
traditional BLAS library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipBLASLt"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${ROCM_IUSE}
benchmark cuda +rocm
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
	cuda? (
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	rocm? (
		${ROCM_REQUIRED_USE}
	)
	^^ (
		rocm
		cuda
	)
"
RDEPEND="
	>=sys-libs/libomp-${LLVM_MAX_SLOT}
	dev-libs/boost
	dev-libs/msgpack
	sys-devel/clang:${LLVM_MAX_SLOT}
	virtual/blas
	~dev-util/hip-${PV}:${SLOT}[cuda?,rocm?]
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
		~sci-libs/hipBLAS-${PV}:${SLOT}[cuda]
	)
	rocm? (
		~dev-util/rocm-smi-${PV}:${SLOT}
		~sci-libs/hipBLAS-${PV}:${SLOT}[rocm]
	)
"
DEPEND="
	${RDEPEND}
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-util/cmake-3.16.8
	dev-python/pip[${PYTHON_USEDEP}]
	dev-python/virtualenv[${PYTHON_USEDEP}]
	~dev-util/rocm-cmake-${PV}:${SLOT}
"
RESTRICT="test"
PATCHES=(
	"${FILESDIR}/hipBLASLt-5.6.0-set-CMP0074-NEW.patch"
	"${FILESDIR}/hipBLASLt-5.6.0-change-Tensile-paths.patch"
)

pkg_setup() {
	llvm_pkg_setup # For LLVM_SLOT init.  Must be explicitly called or it is blank.
	python_setup
}

src_prepare() {
	cmake_src_prepare
	sed \
		-i \
		-e "/install_requires=/d" \
		"${S}/tensilelite/setup.py" \
		|| die
	sed \
		-i \
		-e "s|msgpack REQUIRED|msgpackc REQUIRED|g" \
		"${S}/tensilelite/Tensile/Source/lib/CMakeLists.txt" \
		|| die
	sed \
		-i \
		-e "s|hipblas 0.50.0|hipblas|g" \
		"${S}/CMakeLists.txt" \
		|| die
}

src_configure() {
	addpredict /dev/random
	addpredict /dev/kfd
	addpredict /dev/dri/

	local mycmakeargs=(
		-DBUILD_CLIENTS_BENCHMARKS=$(usex benchmark ON OFF)
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DTensile_CODE_OBJECT_VERSION="default"
#		-DTensile_ROOT="${ESYSROOT}/usr"
		-DTensile_ROOT="${S}/tensilelite"
		-DUSE_CUDA=$(usex cuda ON OFF)
#		-DVIRTUALENV_BIN_DIR="${BUILD_DIR}/venv/bin"
#		-DVIRTUALENV_PYTHON_EXENAME="${EPYTHON}"
	)

	if use cuda ; then
		local s=11
		strip-flags
		filter-flags \
			-pipe \
			-Wl,-O1 \
			-Wl,--as-needed \
			-Wno-unknown-pragmas
		if [[ "${HIP_CXX}" == "nvcc" ]] ; then
			append-cxxflags -ccbin "${EPREFIX}/usr/${CHOST}/gcc-bin/${s}/${CHOST}-g++"
		fi
		export CUDA_PATH="${ESYSROOT}/opt/cuda"
		export HIP_PLATFORM="nvidia"
		mycmakeargs+=(
			-DBUILD_WITH_TENSILE=OFF
			-DHIP_COMPILER="nvcc"
			-DHIP_PLATFORM="nvidia"
			-DHIP_RUNTIME="cuda"
		)
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
			-DBUILD_WITH_TENSILE=ON
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)
	fi

#	virtualenv "${BUILD_DIR}/venv" || die
#	source "${BUILD_DIR}/venv/bin/activate" || die

	export PYTHONPATH="${ESYSROOT}/usr/lib/${EPYTHON}/site-packages/:${PYTHONPATH}"

	export VERBOSE=1
	CXX="${HIP_CXX:-hipcc}" \
	cmake_src_configure
#	deactivate || die
}

src_compile() {
	cmake_src_compile || die
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}/clients/staging" || die
	export ROCBLAS_TENSILE_LIBPATH="${BUILD_DIR}/Tensile/library"
	export ROCBLAS_TEST_TIMEOUT=3600
	export LD_LIBRARY_PATH="${BUILD_DIR}/clients:${BUILD_DIR}/library/src"
	edob "${PN,,}-test"
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
