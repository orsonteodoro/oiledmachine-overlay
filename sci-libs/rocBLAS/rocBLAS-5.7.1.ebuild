# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Error:

# Traceback (most recent call last):
#   File "/usr/lib/python3.10/site-packages/loky/process_executor.py", line 463, in _process_worker
#     r = call_item()
#   File "/usr/lib/python3.10/site-packages/loky/process_executor.py", line 291, in __call__
#     return self.fn(*self.args, **self.kwargs)
#   File "/usr/lib/python3.10/site-packages/joblib/parallel.py", line 589, in __call__
#     return [func(*args, **kwargs)
#   File "/usr/lib/python3.10/site-packages/joblib/parallel.py", line 589, in <listcomp>
#     return [func(*args, **kwargs)
#   File "//usr/lib64/rocm/5.7/lib/python3.10/site-packages/Tensile/Parallel.py", line 53, in pcallWithGlobalParamsMultiArg
#     return f(*args)
#   File "//usr/lib64/rocm/5.7/lib/python3.10/site-packages/Tensile/TensileCreateLibrary.py", line 234, in buildSourceCodeObjectFile
#     out = subprocess.check_output(compileArgs, stderr=subprocess.STDOUT)
#   File "/usr/lib/python3.10/subprocess.py", line 421, in check_output
#     return run(*popenargs, stdout=PIPE, timeout=timeout, check=True,
#   File "/usr/lib/python3.10/subprocess.py", line 503, in run
#     with Popen(*popenargs, **kwargs) as process:
#   File "/usr/lib/python3.10/subprocess.py", line 971, in __init__
#     self._execute_child(args, executable, preexec_fn, close_fds,
#   File "/usr/lib/python3.10/subprocess.py", line 1863, in _execute_child
#     raise child_exception_type(errno_num, err_msg, err_filename)
# OSError: [Errno 8] Exec format error: '//usr/lib64/rocm/5.7/bin/hipcc.bat'

AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx940_xnack_minus
	gfx940_xnack_plus
	gfx941_xnack_minus
	gfx941_xnack_plus
	gfx942_xnack_minus
	gfx942_xnack_plus
	gfx1010
	gfx1012
	gfx1030
	 gfx1031 # Unofficial
	gfx1100
	gfx1101
	gfx1102
)
CMAKE_MAKEFILE_GENERATOR="emake"
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
LLVM_MAX_SLOT=17 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.7.0/llvm/CMakeLists.txt
PYTHON_COMPAT=( python3_{10..11} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"
inherit cmake docs edo flag-o-matic multiprocessing llvm python-single-r1 rocm

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
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
benchmark cuda +rocm system-llvm test r7
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
	$(python_gen_cond_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
	>=dev-libs/msgpack-3.0.1
	dev-util/rocm-compiler:${ROCM_SLOT}[system-llvm=]
	~dev-util/hip-${PV}:${ROCM_SLOT}[cuda?,rocm?]
	benchmark? (
		sys-libs/libomp:${LLVM_MAX_SLOT}
		virtual/blas
	)
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
	)
"
DEPEND="
	${RDEPEND}
	test? (
		dev-cpp/gtest
		sys-libs/libomp:${LLVM_MAX_SLOT}
		virtual/blas
	)
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/joblib[${PYTHON_USEDEP}]
		dev-python/msgpack[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	')
	${PYTHON_DEPS}
	sys-devel/clang:${LLVM_MAX_SLOT}
	~dev-util/rocm-cmake-${PV}:${ROCM_SLOT}
	rocm? (
		$(python_gen_cond_dep '
			~dev-util/Tensile-'"${PV}:${ROCM_SLOT}"'[${PYTHON_USEDEP},client]
		')
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
	"${FILESDIR}/${PN}-5.7.0-unbundle-Tensile.patch"
	"${FILESDIR}/${PN}-5.4.2-add-missing-header.patch"
	"${FILESDIR}/${PN}-5.4.2-link-cblas.patch"
	"${FILESDIR}/${PN}-5.7.0-path-changes.patch"
)
QA_FLAGS_IGNORED="/usr/lib64/rocblas/library/.*"

pkg_setup() {
	llvm_pkg_setup # For LLVM_SLOT init.  Must be explicitly called or it is blank.
	python-single-r1_pkg_setup
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	if use amdgpu_targets_gfx1031 ; then
		cp -a \
			"${WORKDIR}/asm_full/" \
			"library/src/blas3/Tensile/Logic/" \
			|| die
	fi
	# Speed up symbol replacmenet for @...@ by reducing the search space
	# Generated from below one liner ran in the same folder as this file:
	# grep -F -r -e "+++" | cut -f 2 -d " " | cut -f 1 -d $'\t' | sort | uniq | cut -f 2- -d $'/' | sort | uniq
	PATCH_PATHS=(
		"${S}/CHANGELOG.md"
		"${S}/clients/CMakeLists.txt"
		"${S}/clients/common/utility.cpp"
		"${S}/clients/gtest/rocblas_test.cpp"
		"${S}/clients/include/host_alloc.hpp"
		"${S}/clients/include/rocblas_data.hpp"
		"${S}/clients/include/singletons.hpp"
		"${S}/clients/include/testing_logging.hpp"
		"${S}/clients/include/testing_ostream_threadsafety.hpp"
		"${S}/clients/include/utility.hpp"
		"${S}/CMakeLists.txt"
		"${S}/CONTRIBUTING.rst"
		"${S}/deps/external-gtest.cmake"
		"${S}/docs/Linux_Install_Guide.rst"
		"${S}/docs/source/Contributors_Guide.rst"
		"${S}/docs/source/Linux_Install_Guide.rst"
		"${S}/header_compilation_tests.sh"
		"${S}/install.sh"
		"${S}/library/CMakeLists.txt"
		"${S}/library/src/CMakeLists.txt"
		"${S}/library/src/tensile_host.cpp"
		"${S}/rmake.py"
		"${S}/scripts/performance/blas/commandrunner.py"
		"${S}/scripts/performance/blas/getspecs.py"
		"${S}/scripts/utilities/check_for_pretuned_sizes_c/Makefile"
		"${S}/toolchain-linux.cmake"
	)
	rocm_src_prepare
}

src_configure() {
	addpredict /dev/random
	addpredict /dev/kfd
	addpredict /dev/dri/

	# Prevent error below for miopen
	# undefined reference to `rocblas_status_ rocblas_internal_check_numerics_matrix_template
	replace-flags '-O0' '-O1'

	export PATH="${ESYSROOT}/${EROCM_PATH}/lib/python-exec/${EPYTHON}:${ESYSROOT}/${EROCM_PATH}/bin:${PATH}"
	export PYTHONPATH="${ESYSROOT}/${EROCM_PATH}/lib/${EPYTHON}/site-packages:${PYTHONPATH}"

	local mycmakeargs=(
		-DBUILD_CLIENTS_BENCHMARKS=$(usex benchmark ON OFF)
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocblas"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
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
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
			-DBUILD_WITH_TENSILE=ON
			-DCMAKE_CXX_COMPILER="hipcc" # Required to not call //usr/lib64/rocm/5.7/bin/hipcc.bat
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
			-DTensile_CODE_OBJECT_VERSION="default"
			-DTensile_COMPILER="hipcc"
			-DTensile_CPU_THREADS=$(makeopts_jobs)
			-DTensile_LIBRARY_FORMAT="msgpack"
			-DTensile_LOGIC="asm_full"
			-DTensile_ROOT="${ESYSROOT}${EROCM_PATH}/share/Tensile"
			-DTensile_TEST_LOCAL_PATH="${ESYSROOT}${EROCM_PATH}/share/Tensile"
		)
	fi
	export CC="${HIP_CC:-hipcc}"
	export CXX="${HIP_CXX:-hipcc}"
	rocm_src_configure
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
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
