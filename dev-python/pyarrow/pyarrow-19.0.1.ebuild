# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# arrow.git: testing
# arrow.git: cpp/submodules/parquet-testing

ARROW_DATA_GIT_HASH="4d209492d514c2d3cb2d392681b9aa00e6d8da1c"
EPYTEST_XDIST=1
PARQUET_DATA_GIT_HASH="cb7a9674142c137367bf75a01b79c6e214a73199"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( "python3_"{10..13} )
CPU_FLAGS_ARM=(
	"cpu_flags_arm_neon"
	"cpu_flags_arm_sve"
	"cpu_flags_arm_sve128"
	"cpu_flags_arm_sve256"
	"cpu_flags_arm_sve512"
)
CPU_FLAGS_PPC=(
	"cpu_flags_ppc_altivec"
)
CPU_FLAGS_X86=(
	"cpu_flags_x86_avx"
	"cpu_flags_x86_avx2"
	"cpu_flags_x86_avx512bw"
	"cpu_flags_x86_avx512dq"
	"cpu_flags_x86_avx512f"
	"cpu_flags_x86_avx512vl"
	"cpu_flags_x86_sse4_2"
)

inherit distutils-r1 multiprocessing

KEYWORDS="amd64 arm64 ~riscv x86"
S="${WORKDIR}/apache-arrow-${PV}/python"
SRC_URI="
mirror://apache/arrow/arrow-${PV}/apache-arrow-${PV}.tar.gz
	test? (
https://github.com/apache/parquet-testing/archive/${PARQUET_DATA_GIT_HASH}.tar.gz
	-> parquet-testing-${PARQUET_DATA_GIT_HASH}.tar.gz
https://github.com/apache/arrow-testing/archive/${ARROW_DATA_GIT_HASH}.tar.gz
	-> arrow-testing-${ARROW_DATA_GIT_HASH}.tar.gz
	)
"

DESCRIPTION="Python library for Apache Arrow"
HOMEPAGE="
	https://arrow.apache.org/
	https://github.com/apache/arrow/
	https://pypi.org/project/pyarrow/
"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_PPC[@]}
${CPU_FLAGS_X86[@]}
+parquet +snappy ssl
ebuild_revision_2
"
REQUIRED_USE="
	cpu_flags_x86_avx? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_avx2? (
		cpu_flags_x86_avx
	)
	cpu_flags_x86_avx512f? (
		cpu_flags_x86_avx2
	)
	cpu_flags_x86_avx512bw? (
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512dq? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512vl? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
	)
"
RDEPEND="
	>=dev-python/numpy-1.16.6[${PYTHON_USEDEP}]
	dev-python/numpy:=
	~dev-libs/apache-arrow-${PV}[compute,dataset,json,parquet?,re2,snappy?,ssl?]
"
BDEPEND="
	test? (
		dev-libs/apache-arrow[lz4,zlib]
		dev-python/cffi[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests "pytest"

src_prepare() {
	distutils-r1_src_prepare

	# cython's -Werror
	sed -i \
		-e '/--warning-errors/d' \
		"CMakeLists.txt" \
		|| die
	cd "${WORKDIR}/apache-arrow-${PV}" || die
}

python_configure() {
	local mycmakeargs=()
	local simd_level=""
	local altivec=$(usex cpu_flags_ppc_altivec "ON" "OFF")
	if use cpu_flags_arm_sve512 ; then
		simd_level="SVE512"
	elif use cpu_flags_arm_sve256 ; then
		simd_level="SVE256"
	elif use cpu_flags_arm_sve128 ; then
		simd_level="SVE128"
	elif use cpu_flags_arm_sve ; then
		simd_level="SVE"
	elif use cpu_flags_arm_neon ; then
		simd_level="NEON"
	elif \
		   use cpu_flags_x86_avx512bw \
		|| use cpu_flags_x86_avx512dq \
		|| use cpu_flags_x86_avx512f \
		|| use cpu_flags_x86_avx512vl \
	; then
	# Upstream uses -march=skylake-avx512 which is why you may see illegal instruction.
		simd_level="AVX512"
	elif use cpu_flags_x86_avx2 ; then
		simd_level="AVX2"
	elif use cpu_flags_x86_avx ; then
		simd_level="AVX"
	elif use cpu_flags_x86_sse4_2 ; then
		simd_level="SSE4_2"
	else
		simd_level="NONE"
	fi
einfo "SIMD level:  ${simd_level}"
	mycmakeargs+=(
		-DARROW_ALTIVEC="${altivec}"
		-DARROW_SIMD_LEVEL="${simd_level}"
		-DARROW_RUNTIME_SIMD_LEVEL="${simd_level}"
	)
	export PYARROW_CMAKE_OPTIONS="${mycmakeargs[@]}"
}

src_compile() {
	export PYARROW_BUILD_VERBOSE=1
	export PYARROW_BUNDLE_ARROW_CPP_HEADERS=0
	export PYARROW_CXXFLAGS="${CXXFLAGS}"
	export PYARROW_CMAKE_GENERATOR="Ninja"
	export PYARROW_PARALLEL="$(makeopts_jobs)"
	export PYARROW_WITH_HDFS=1
	if use parquet ; then
		export PYARROW_WITH_DATASET=1
		export PYARROW_WITH_PARQUET=1
		use ssl && export PYARROW_WITH_PARQUET_ENCRYPTION=1
	fi
	if use snappy ; then
		export PYARROW_WITH_SNAPPY=1
	fi

	distutils-r1_src_compile
}

python_test() {
	local EPYTEST_DESELECT=(
	# wtf?
		"tests/test_fs.py::test_localfs_errors"
	# these require apache-arrow with jemalloc that doesn't seem
	# to be supported by the Gentoo package
		"tests/test_memory.py::test_env_var"
		"tests/test_memory.py::test_specific_memory_pools"
		"tests/test_memory.py::test_supported_memory_backends"
	# require mimalloc
		"tests/test_memory.py::test_memory_pool_factories"
	# hypothesis health check failures
	# https://github.com/apache/arrow/issues/41318
		"tests/interchange/test_interchange_spec.py::test_dtypes"
		"tests/test_convert_builtin.py::test_array_to_pylist_roundtrip"
		"tests/test_feather.py::test_roundtrip"
		"tests/test_pandas.py::test_array_to_pandas_roundtrip"
		"tests/test_strategies.py::test_types"
		"tests/test_types.py::test_hashing"
	# fragile memory tests
		"tests/test_csv.py::TestSerialStreamingCSVRead::test_batch_lifetime"
		"tests/test_csv.py::TestThreadedStreamingCSVRead::test_batch_lifetime"
	# takes forever, and manages to generate timedeltas over 64 bits
		"tests/test_strategies.py"
		"tests/test_array.py::test_pickling[builtin_pickle]"
	# scipy.sparse does not support dtype float16
		"tests/test_sparse_tensor.py::test_sparse_coo_tensor_scipy_roundtrip[f2-arrow_type8]"
	)

	cd "${T}" || die
	local -x ARROW_TEST_DATA="${WORKDIR}/arrow-testing-${ARROW_DATA_GIT_HASH}/data"
	local -x PARQUET_TEST_DATA="${WORKDIR}/parquet-testing-${PARQUET_DATA_GIT_HASH}/data"
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest --pyargs "pyarrow"
}
