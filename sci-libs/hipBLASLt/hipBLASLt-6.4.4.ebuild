# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx908_xnack_minus
	gfx908_xnack_plus # with or without asan
	gfx90a_xnack_minus
	gfx90a_xnack_plus # with or without asan
	gfx942
	gfx942_xnack_plus # with asan
	gfx1100
	gfx1101
	gfx1103
	gfx1150
	gfx1151
	gfx1200
	gfx1201
)
CMAKE_MAKEFILE_GENERATOR="emake"
HIP_SUPPORT_CUDA=1
LLVM_SLOT=19
PYTHON_COMPAT=( "python3_12" )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake flag-o-matic python-r1 rocm

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
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	MIT
"
# all-rights-reserved MIT - utilities/find_exact.py
# MIT - LICENSE.md
SLOT="0/${ROCM_SLOT}"
IUSE+="
${ROCM_IUSE}
asan benchmark cuda +rocm +tensile ebuild_revision_14
"
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
	$(gen_rocm_required_use)
	rocm? (
		${ROCM_REQUIRED_USE}
	)
	^^ (
		rocm
		cuda
	)
"
RDEPEND="
	${HIPCC_DEPEND}
	dev-libs/boost
	dev-libs/msgpack
	virtual/blas
	>=dev-util/hip-${PV}:${SLOT}[cuda?,rocm?]
	dev-util/hip:=
	>=sys-libs/llvm-roc-libomp-${PV}:${SLOT}[amdgpu_targets_gfx942?,amdgpu_targets_gfx1100?,amdgpu_targets_gfx1101?,amdgpu_targets_gfx1103?,amdgpu_targets_gfx1150?,amdgpu_targets_gfx1151?,amdgpu_targets_gfx1200?,amdgpu_targets_gfx1201?]
	sys-libs/llvm-roc-libomp:=
	amdgpu_targets_gfx908_xnack_minus? (
		>=sys-libs/llvm-roc-libomp-${PV}:${SLOT}[amdgpu_targets_gfx908]
		sys-libs/llvm-roc-libomp:=
	)
	amdgpu_targets_gfx908_xnack_plus? (
		>=sys-libs/llvm-roc-libomp-${PV}:${SLOT}[amdgpu_targets_gfx908]
		sys-libs/llvm-roc-libomp:=
	)
	amdgpu_targets_gfx90a_xnack_minus? (
		>=sys-libs/llvm-roc-libomp-${PV}:${SLOT}[amdgpu_targets_gfx90a]
		sys-libs/llvm-roc-libomp:=
	)
	amdgpu_targets_gfx90a_xnack_plus? (
		>=sys-libs/llvm-roc-libomp-${PV}:${SLOT}[amdgpu_targets_gfx90a]
		sys-libs/llvm-roc-libomp:=
	)
	amdgpu_targets_gfx942_xnack_plus? (
		>=sys-libs/llvm-roc-libomp-${PV}:${SLOT}[amdgpu_targets_gfx942]
		sys-libs/llvm-roc-libomp:=
	)
	cuda? (
		${HIP_CUDA_DEPEND}
		>=sci-libs/hipBLAS-${PV}:${SLOT}[cuda]
		sci-libs/hipBLAS:=
	)
	rocm? (
		>=dev-util/rocm-smi-${PV}:${SLOT}
		dev-util/rocm-smi:=
		>=sci-libs/hipBLAS-${PV}:${SLOT}[rocm]
		sci-libs/hipBLAS:=
	)
"
DEPEND="
	${RDEPEND}
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
BDEPEND="
	${HIPCC_DEPEND}
	>=dev-build/cmake-3.16.8
	dev-python/pip[${PYTHON_USEDEP}]
	dev-python/virtualenv[${PYTHON_USEDEP}]
	>=dev-build/rocm-cmake-${PV}:${SLOT}
	dev-build/rocm-cmake:=
"
RESTRICT="test"
PATCHES=(
	"${FILESDIR}/${PN}-5.6.0-set-CMP0074-NEW.patch"
)

pkg_setup() {
	python_setup
	rocm_pkg_setup
}

src_prepare() {
	if use tensile && has_version "dev-util/Tensile" ; then
# Avoid referencing dev-util/Tensile with V4/V5 code object version.  Building
# requires v2 or v3.
eerror
eerror "You must temporarly uninstall dev-util/Tensile."
eerror "Reinstall dev-util/Tensile after this package completes."
eerror
		die
	fi
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
	rocm_src_prepare
}

get_makeopts_nprocs() {
	# ~ 7.33 GiB per process.
	local ncpus=$(echo "${MAKEOPTS}" \
		| grep -E -e "-j.*[0-9]+" \
		| grep -o -E "[0-9]+")
	[[ -z "${ncpus}" ]] && ncpus=1
	echo "${ncpus}"
}

check_asan() {
	local ASAN_GPUS=(
		"gfx908_xnack_plus"
		"gfx90a_xnack_plus"
		"gfx942_xnack_plus"
	)
	local found=0
	local x
	for x in ${ASAN_GPUS[@]} ; do
		if use "amdgpu_targets_${x}" ; then
			found=1
		fi
	done
	if (( ${found} == 0 )) && use asan ; then
ewarn "ASan security mitigations for GPU are disabled."
ewarn "ASan is enabled for CPU HOST side but not GPU side for both older and newer GPUs."
ewarn "Pick one of the following for GPU side ASan:  ${ASAN_GPUS[@]/#/amdgpu_targets_}"
	fi
}

src_configure() {
	addpredict "/dev/random"
	addpredict "/dev/kfd"
	addpredict "/dev/dri/"

	replace-flags '-O0' '-O1'
	local nprocs=$(get_makeopts_nprocs)
	if (( "${nprocs}" > 1 )) ; then
ewarn
ewarn "MAKEOPTS > 1.  Expect 7.33 GiB per process."
ewarn "Changing to MAKEOPTS=-j1 is recommended."
ewarn
	fi

	check_asan

	local mycmakeargs=(
		-DBUILD_ADDRESS_SANITIZER=$(usex asan)
		-DBUILD_CLIENTS_BENCHMARKS=$(usex benchmark ON OFF)
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DUSE_CUDA=$(usex cuda ON OFF)
#		-DVIRTUALENV_BIN_DIR="${BUILD_DIR}/venv/bin"
#		-DVIRTUALENV_PYTHON_EXENAME="${EPYTHON}"
	)

	if use cuda ; then
		export CUDA_PATH="${ESYSROOT}/opt/cuda"
		export HIP_PLATFORM="nvidia"
		mycmakeargs+=(
			-DBUILD_WITH_TENSILE=OFF
			-DHIP_COMPILER="nvcc"
			-DHIP_PLATFORM="nvidia"
			-DHIP_RUNTIME="cuda"
		)
		if use tensile ; then
			mycmakeargs+=(
				-DOPENCL_ROOT="/opt/cuda"
			)
		fi
	elif use rocm ; then
		export HIP_PATH="${ROCM_PATH}"
		export HIP_PLATFORM="amd"
		export ROCM_PATH="${ROCM_PATH}"
		einfo "get_amdgpu_flags:  $(get_amdgpu_flags)"
		mycmakeargs+=(
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
			-DBUILD_WITH_TENSILE=$(usex tensile ON OFF)
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)
		if use tensile ; then
			export TENSILE_ROCM_ASSEMBLER_PATH="${ESYSROOT}${EROCM_LLVM_PATH}/bin/clang++"
			export TENSILE_ROCM_OFFLOAD_BUNDLER_PATH="${ESYSROOT}${EROCM_LLVM_PATH}/bin/clang-offload-bundler"
			mycmakeargs+=(
				-DOPENCL_ROOT="${EROCM_PATH}/opencl"
				-DTensile_CODE_OBJECT_VERSION="V3" # Avoid V2 build error with xnack-
				-DTensile_CPU_THREADS="${nprocs}"
#				-DTensile_ROOT="${ESYSROOT}${EROCM_PATH}"
				-DTensile_ROOT="${S}/tensilelite"
			)
		fi
	fi

#	virtualenv "${BUILD_DIR}/venv" || die
#	source "${BUILD_DIR}/venv/bin/activate" || die

# Avoid:
# virtualenv/bin/python3: No module named pip
	export PYTHONPATH="${ESYSROOT}/usr/lib/${EPYTHON}/site-packages/:${PYTHONPATH}"

	export VERBOSE=1
	rocm_set_default_hipcc
	rocm_src_configure
#	deactivate || die
}

src_compile() {
	cmake_src_compile || die
	mkdir -p "${BUILD_DIR}/Tensile/library" || die
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}/clients/staging" || die
	export ROCBLAS_TENSILE_LIBPATH="${BUILD_DIR}/Tensile/library"
	export ROCBLAS_TEST_TIMEOUT=3600
	export LD_LIBRARY_PATH="${BUILD_DIR}/clients:${BUILD_DIR}/library/src"
	edob "./${PN,,}-test"
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
