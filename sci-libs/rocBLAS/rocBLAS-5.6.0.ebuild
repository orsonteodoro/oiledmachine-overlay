# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1010
	gfx1012
	gfx1030
	gfx1031
	gfx1100
	gfx1101
	gfx1102
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
DOCS_BUILDER="doxygen"
DOCS_DIR="docs"
DOCS_DEPEND="
	media-gfx/graphviz
"
LLVM_MAX_SLOT=16 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.6.0/llvm/CMakeLists.txt
ROCM_VERSION="${PV}"
PYTHON_COMPAT=( python3_{10..11} )
inherit cmake docs edo flag-o-matic multiprocessing llvm python-any-r1 rocm

SRC_URI="
https://github.com/ROCmSoftwarePlatform/rocBLAS/archive/rocm-${PV}.tar.gz
	-> rocm-${P}.tar.gz
	amdgpu_targets_gfx1031? (
https://media.githubusercontent.com/media/littlewu2508/littlewu2508.github.io/main/gentoo-distfiles/${PN}-5.4.2-Tensile-asm_full-navi22.tar.gz
	)
"

DESCRIPTION="AMD's library for BLAS on ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocBLAS"
LICENSE="BSD"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
benchmark cuda +rocm test r3
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
	$(python_gen_any_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
	>=dev-libs/msgpack-3.0.1
	~dev-util/hip-${PV}:${SLOT}[cuda?,rocm?]
	benchmark? (
		>=sys-libs/libomp-${LLVM_MAX_SLOT}
		virtual/blas
	)
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
	)
"
DEPEND="
	${RDEPEND}
	test? (
		>=sys-libs/libomp-${LLVM_MAX_SLOT}
		dev-cpp/gtest
		virtual/blas
	)
"
BDEPEND="
	$(python_gen_any_dep '
		dev-python/joblib[${PYTHON_USEDEP}]
		dev-python/msgpack[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	')
	${PYTHON_DEPS}
	sys-devel/clang:${LLVM_MAX_SLOT}
	~dev-util/rocm-cmake-${PV}:${SLOT}
	rocm? (
		~dev-util/Tensile-${PV}:${SLOT}
	)
"
RESTRICT="
	!test? (
		test
	)
"
S="${WORKDIR}/${PN}-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/${PN}-5.4.2-cpp_lib_filesystem.patch"
	"${FILESDIR}/${PN}-5.4.2-unbundle-Tensile.patch"
	"${FILESDIR}/${PN}-5.4.2-add-missing-header.patch"
	"${FILESDIR}/${PN}-5.4.2-link-cblas.patch"
	"${FILESDIR}/${PN}-5.6.0-path-changes.patch"
)
QA_FLAGS_IGNORED="/usr/lib64/rocblas/library/.*"

pkg_setup() {
	llvm_pkg_setup # For LLVM_SLOT init.  Must be explicitly called or it is blank.
	python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	if use amdgpu_targets_gfx1031 ; then
		cp -a \
			"${WORKDIR}/asm_full/" \
			"library/src/blas3/Tensile/Logic/" \
			|| die
	fi
	rocm_src_prepare
}

src_configure() {
	addpredict /dev/random
	addpredict /dev/kfd
	addpredict /dev/dri/

	# Prevent error below for miopen
	# undefined reference to `rocblas_status_ rocblas_internal_check_numerics_matrix_template
	replace-flags '-O0' '-O1'

	# Disallow newer clangs versions when producing .o files.
	einfo "LLVM_SLOT=${LLVM_SLOT}"
	einfo "PATH=${PATH} (before)"
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:/usr/lib/llvm/${LLVM_SLOT}/bin|g")
	einfo "PATH=${PATH} (after)"

	local mycmakeargs=(
		-DBUILD_CLIENTS_BENCHMARKS=$(usex benchmark ON OFF)
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocblas"
		-DCMAKE_SKIP_RPATH=ON
		-Dpython="${PYTHON}"
		-DROCM_SYMLINK_LIBS=OFF
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
		export HIP_CLANG_PATH=$(get_llvm_prefix ${LLVM_SLOT})"/bin"
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
			-DBUILD_WITH_TENSILE=ON
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
			-DTensile_CODE_OBJECT_VERSION="default"
			-DTensile_COMPILER="hipcc"
			-DTensile_CPU_THREADS=$(makeopts_jobs)
			-DTensile_LIBRARY_FORMAT="msgpack"
			-DTensile_LOGIC="asm_full"
			-DTensile_ROOT="${EPREFIX}/usr/share/Tensile"
			-DTensile_TEST_LOCAL_PATH="${EPREFIX}/usr/share/Tensile"
		)
	fi
	CXX="${HIP_CXX:-hipcc}" \
	cmake_src_configure
}

src_compile() {
	docs_compile
	cmake_src_compile
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}/clients/staging" || die
	export ROCBLAS_TENSILE_LIBPATH="${BUILD_DIR}/Tensile/library"
	export ROCBLAS_TEST_TIMEOUT=3600
	export LD_LIBRARY_PATH="${BUILD_DIR}/clients:${BUILD_DIR}/library/src"
	edob "${PN,,}-test"
}

src_install() {
	cmake_src_install

	if use benchmark; then
		cd "${BUILD_DIR}" || die
		dolib.a clients/librocblas_fortran_client.a
		dobin clients/staging/rocblas-bench
	fi
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
