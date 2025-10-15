# Copyright 1999-2025 Gentoo Authors
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
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a
	gfx942
	gfx1010
	gfx1012
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1150
	gfx1151
	gfx1200
	gfx1201
)
CPU_FLAGS_X86=(
	cpu_flags_x86_f16c
)
CMAKE_MAKEFILE_GENERATOR="emake"
DOCS_BUILDER="doxygen"
DOCS_DIR="docs"
DOCS_DEPEND="
	media-gfx/graphviz
"
HIP_SUPPORT_CUDA=1
LLVM_SLOT=19 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-6.2.4/llvm/CMakeLists.txt
PYTHON_COMPAT=( "python3_12" )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake docs edo flag-o-matic multiprocessing python-single-r1 rocm

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/rocBLAS/archive/rocm-${PV}.tar.gz
	-> rocm-${P}.tar.gz
"

DESCRIPTION="AMD's library for BLAS on ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocBLAS"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	BSD
"
# The distro's MIT license template does not have All rights reserved.
RESTRICT="
	!test? (
		test
	)
"
SLOT="0/${ROCM_SLOT}"
IUSE="
${CPU_FLAGS_X86[@]}
benchmark cuda +rocm test ebuild_revision_26
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
	$(python_gen_cond_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
	>=dev-libs/msgpack-3.0.1
	>=dev-util/hip-${PV}:${SLOT}[cuda?,rocm?]
	dev-util/hip:=
	benchmark? (
		sys-libs/llvm-roc-libomp:${SLOT}[${LLVM_ROC_LIBOMP_6_4_AMDGPU_USEDEP}]
		sys-libs/llvm-roc-libomp:=
		virtual/blas
	)
	cuda? (
		${HIP_CUDA_DEPEND}
	)
	rocm? (
		>=dev-util/Tensile-${PV}:${SLOT}[${TENSILE_6_4_AMDGPU_USEDEP},rocm]
		dev-util/Tensile:=
		$(python_gen_cond_dep '
			>=dev-util/Tensile-'"${PV}:${SLOT}"'['"${TENSILE_6_4_AMDGPU_USEDEP}"',rocm]
			dev-util/Tensile:=
		')
	)
"
DEPEND="
	${RDEPEND}
	test? (
		dev-cpp/gtest
		sys-libs/llvm-roc-libomp:${SLOT}[${LLVM_ROC_LIBOMP_6_4_AMDGPU_USEDEP}]
		sys-libs/llvm-roc-libomp:=
		virtual/blas
	)
"
BDEPEND="
	${PYTHON_DEPS}
	${HIPCC_DEPEND}
	$(python_gen_cond_dep '
		dev-python/joblib[${PYTHON_USEDEP}]
		dev-python/msgpack[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	')
	>=dev-build/rocm-cmake-${PV}:${SLOT}
	dev-build/rocm-cmake:=
	rocm? (
		$(python_gen_cond_dep '
			>=dev-util/Tensile-'"${PV}:${SLOT}"'['"${TENSILE_6_4_AMDGPU_USEDEP}"',${PYTHON_USEDEP},client,rocm]
			dev-util/Tensile:=
		')
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-6.4.4-cpp_lib_filesystem.patch"
	"${FILESDIR}/${PN}-6.4.4-unbundle-Tensile.patch"
	"${FILESDIR}/${PN}-5.4.2-add-missing-header.patch"
	"${FILESDIR}/${PN}-5.4.2-link-cblas.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
	rocm_pkg_setup

	QA_FLAGS_IGNORED="${EROCM_PATH}/$(rocm_get_libdir)/rocblas/library/.*"
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
	if ! use cpu_flags_x86_f16c ; then
	# Issue 1422
	# Breaks Ollama for CPUs without AVX
		sed -i \
			-e "s|-mf16c|-mno-f16c|g" \
			$(find "${S}" -name "CMakeLists.txt") \
			|| die
	fi
}

src_configure() {
	addpredict "/dev/random"
	addpredict "/dev/kfd"
	addpredict "/dev/dri/"

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
		-DBUILD_TESTING=OFF
		-DCMAKE_INSTALL_INCLUDEDIR="include"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DCMAKE_SKIP_RPATH=ON
		-Dpython="${PYTHON}"
		-DROCM_SYMLINK_LIBS=OFF
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
			-DTensile_ROOT="${ESYSROOT}${EROCM_PATH}/lib/${EPYTHON}/site-packages/Tensile"
			-DTensile_TENSILE_ROOT="${ESYSROOT}${EROCM_PATH}"
			-DTensile_TEST_LOCAL_PATH="${ESYSROOT}${EROCM_PATH}/lib/${EPYTHON}/site-packages/Tensile"
		)
	fi
	rocm_set_default_hipcc
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
	edob "./${PN,,}-test"
}

src_install() {
	cmake_src_install

	if use benchmark; then
		cd "${BUILD_DIR}" || die
		dolib.a "clients/librocblas_fortran_client.a"
		dobin "clients/staging/rocblas-bench"
	fi
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-error
