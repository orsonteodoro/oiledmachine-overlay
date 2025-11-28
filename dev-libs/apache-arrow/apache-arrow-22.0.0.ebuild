# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Requirements:
# https://github.com/apache/arrow/blob/apache-arrow-22.0.0/.env

ABSEIL_CPP_SLOT="20240722"
CXX_STANDARD=17
GRPC_SLOT="4"
PROTOBUF_CPP_SLOT="4"
RE2_SLOT="20220623"

# arrow.git: testing
ARROW_DATA_GIT_HASH="9a02925d1ba80bd493b6d4da6e8a777588d57ac4"
# arrow.git: cpp/submodules/parquet-testing
PARQUET_DATA_GIT_HASH="a3d96a65e11e2bbca7d22a894e8313ede90a33a3"

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
	"cpu_flags_x86_sse4_2"
	"cpu_flags_x86_avx2"
	"cpu_flags_x86_avx512"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

# Note: upstream meson port is incomplete.
# https://github.com/apache/arrow/issues/45778
inherit cmake flag-o-matic libcxx-slot libstdcxx-slot

KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~x86"
S="${WORKDIR}/${P}/cpp"
SRC_URI="
mirror://apache/arrow/arrow-${PV}/${P}.tar.gz
	test? (
https://github.com/apache/parquet-testing/archive/${PARQUET_DATA_GIT_HASH}.tar.gz
	-> parquet-testing-${PARQUET_DATA_GIT_HASH}.tar.gz
https://github.com/apache/arrow-testing/archive/${ARROW_DATA_GIT_HASH}.tar.gz
	-> arrow-testing-${ARROW_DATA_GIT_HASH}.tar.gz
	)
"

DESCRIPTION="A cross-language development platform for in-memory data"
HOMEPAGE="
	https://arrow.apache.org/
	https://github.com/apache/arrow/
"
LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1)"
IUSE="
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_PPC[@]}
${CPU_FLAGS_X86[@]}
-arrow-flight -arrow-flight-sql -arrow-flight-sql-odbc -brotli -bzip2 -compute
-csv -cuda -filesystem -gandiva -dataset -gcs -hdfs +ipc -jemalloc -json -lz4
+mimalloc +parquet +re2 -s3 -snappy -tensorflow ssl test +threads +utf8proc
-zlib -zstd
ebuild_revision_1
"
# oiledmachine-overlay has strict GPU version requirements, CUDA 11.7 not supported on distro.
REQUIRED_USE="
	!cuda
	cpu_flags_arm_sve? (
		cpu_flags_arm_neon
	)
	cpu_flags_arm_sve128? (
		cpu_flags_arm_sve
	)
	cpu_flags_arm_sve256? (
		cpu_flags_arm_sve128
	)
	cpu_flags_arm_sve512? (
		cpu_flags_arm_sve256
	)

	cpu_flags_x86_avx2? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_avx512? (
		cpu_flags_x86_avx2
	)

	arrow-flight? (
		ipc
	)
	arrow-flight-sql? (
		arrow-flight
	)
	arrow-flight-sql-odbc? (
		arrow-flight-sql
		compute
	)
	cuda? (
		ipc
	)
	dataset? (
		filesystem
	)
	gandiva? (
		filesystem
		re2
	)
	gcs? (
		filesystem
	)
	hdfs? (
		filesystem
	)
	parquet? (
		ipc
	)
	re2? (
		compute
	)
	s3? (
		filesystem
	)
	ssl? (
		json
	)
	test? (
		json
		parquet? (
			zstd
		)
	)
	utf8proc? (
		compute
	)
"
RESTRICT="
	!test? (
		test
	)
"

RDEPEND="
	>=dev-cpp/abseil-cpp-${ABSEIL_CPP_SLOT}:${ABSEIL_CPP_SLOT%%.*}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-cpp/abseil-cpp:=
	>=dev-libs/boost-1.87.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-libs/boost:=
	arrow-flight? (
		net-libs/grpc:${GRPC_SLOT}
		net-libs/grpc:=
	)
	brotli? (
		>=app-arch/brotli-1.1.0
		app-arch/brotli:=
	)
	bzip2? (
		>=app-arch/bzip2-1.0.8
		app-arch/bzip2:=
	)
	elibc_musl? (
		sys-libs/timezone-data
	)
	lz4? (
		>=app-arch/lz4-1.10.0
		app-arch/lz4:=
	)
	parquet? (
		dev-libs/libutf8proc:=
		>=dev-libs/thrift-0.20.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-libs/thrift:=
		ssl? (
			>=dev-libs/openssl-3.0.8
			dev-libs/openssl:=
		)
	)
	re2? (
		>=dev-libs/re2-0.2023.03.01:${RE2_SLOT}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-libs/re2:=
	)
	snappy? (
		>=app-arch/snappy-1.1.9[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		app-arch/snappy:=
	)
	utf8proc? (
		dev-libs/libutf8proc:=
	)
	zlib? (
		>=virtual/zlib-1.3.1
		virtual/zlib:=
	)
	zstd? (
		>=app-arch/zstd-1.5.7
		app-arch/zstd:=
	)
"
# rapidjson version relaxed from live (9999)
DEPEND="
	${RDEPEND}
	dev-cpp/xsimd:=
	json? (
		dev-libs/rapidjson
		dev-libs/rapidjson:=
	)
"
BDEPEND="
	test? (
		>=dev-cpp/gflags-2.2.2[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-cpp/gtest[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-cpp/gflags:=
		dev-cpp/gtest:=
	)
"

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_prepare() {
	# Use Gentoo CXXFLAGS.  Specify docdir at src_configure.
	sed -i \
		-e '/SetupCxxFlags/d' \
		-e '/set(ARROW_DOC_DIR.*)/d' \
		"CMakeLists.txt" \
		|| die
	cmake_src_prepare
}

get_buildtime_simd_level() {
	if use cpu_flags_arm_sve512 ; then
		echo "SVE512"
	elif use cpu_flags_arm_sve256 ; then
		echo "SVE256"
	elif use cpu_flags_arm_sve ; then
		echo "SVE"
	elif use cpu_flags_arm_neon ; then
		echo "NEON"
	elif use cpu_flags_x86_avx512 ; then
		echo "AVX512"
	elif use cpu_flags_x86_avx2 ; then
		echo "AVX2"
	elif use cpu_flags_x86_sse4_2 ; then
		echo "SSE4_2"
	else
		echo "NONE"
	fi
}

get_runtime_simd_level() {
	if use cpu_flags_x86_avx512 ; then
		echo "AVX512"
	elif use cpu_flags_x86_avx2 ; then
		echo "AVX2"
	elif use cpu_flags_x86_sse4_2 ; then
		echo "SSE4_2"
	else
		echo "NONE"
	fi
}

src_configure() {
	local libdir=$(get_libdir)
	append-ldflags \
		"-Wl,,-L/usr/lib/abseil-cpp/${ABSEIL_CPP_SLOT%.*}/${libdir}" \
		"-Wl,,-L/usr/lib/re2/${RE2_SLOT}/${libdir}" \
		"-Wl,--rpath,/usr/lib/abseil-cpp/${ABSEIL_CPP_SLOT%.*}/${libdir}" \
		"-Wl,--rpath,/usr/lib/re2/${RE2_SLOT}/${libdir}"

	local use_gold="OFF"
	local use_lld="OFF"
	local use_mold="OFF"
	if is-flagq '-fuse-ld=gold' ; then
		use_gold="ON"
	elif is-flagq '-fuse-ld=lld' ; then
		use_lld="ON"
	elif is-flagq '-fuse-ld=mold' ; then
		use_mold="ON"
	fi
	filter-flags "-fuse-ld=*"

	local use_ccache="OFF"
	if [[ "${FEATURES}" =~ "ccache" ]] && has_version "dev-util/ccache" ; then
		use_ccache="ON"
	fi

	local use_sccache="OFF"
	if [[ -n "${SCCACHE_DIR}" ]] && has_version "dev-util/sccache" ; then
		use_sccache="ON"
	fi

	if use arrow-flight ; then
		abseil-cpp_src_configure
		protobuf_src_configure
		re2_src_configure
		grpc_src_configure
	fi

	# See https://github.com/apache/arrow/blob/apache-arrow-22.0.0/cpp/cmake_modules/DefineOptions.cmake
	local mycmakeargs=(
		-DARROW_ALTIVEC=$(usex cpu_flags_ppc_altivec ON OFF)
		-DARROW_BUILD_STATIC=OFF
		-DARROW_BUILD_TESTS=$(usex test ON OFF)
		-DARROW_COMPUTE=$(usex compute ON OFF)
		-DARROW_CUDA=$(usex cuda ON OFF)
		-DARROW_CSV=$(usex csv ON OFF)
		-DARROW_DATASET=$(usex dataset ON OFF)
		-DARROW_DEPENDENCY_SOURCE="SYSTEM"
		-DARROW_DEPENDENCY_USE_SHARED=ON
		-DARROW_DOC_DIR="share/doc/${PF}"
		-DARROW_ENABLE_THREADING=$(usex threads ON OFF)
		-DARROW_FILESYSTEM=$(usex filesystem ON OFF)
		-DARROW_FLIGHT=$(usex arrow-flight ON OFF)
		-DARROW_FLIGHT_SQL=$(usex arrow-flight-sql ON OFF)
		-DARROW_FLIGHT_SQL_ODBC=$(usex arrow-flight-sql-odbc ON OFF)
		-DARROW_GANDIVA=$(usex gandiva ON OFF)
		-DARROW_GCS=$(usex gcs ON OFF)
		-DARROW_HDFS=$(usex hdfs ON OFF)
		-DARROW_IPC=$(usex ipc ON OFF)
		-DARROW_JEMALLOC=$(usex jemalloc ON OFF)
		-DARROW_JSON=$(usex json ON OFF)
		-DARROW_MIMALLOC=$(usex mimalloc ON OFF)
		-DARROW_PARQUET=$(usex parquet ON OFF)
		-DARROW_RUNTIME_SIMD_LEVEL=$(get_runtime_simd_level)
		-DARROW_S3=$(usex s3 ON OFF)
		-DARROW_SIMD_LEVEL=$(get_buildtime_simd_level)
		-DARROW_TENSORFLOW=$(usex tensorflow ON OFF)
		-DARROW_USE_CCACHE="${use_ccache}"
		-DARROW_USE_GOLD="${use_mold}"
		-DARROW_USE_LLD="${use_lld}"
		-DARROW_USE_MOLD="${use_mold}"
		-DARROW_USE_SCCACHE="${use_sccache}"
		-DARROW_WITH_BROTLI=$(usex brotli ON OFF)
		-DARROW_WITH_BZ2=$(usex bzip2 ON OFF)
		-DARROW_WITH_LZ4=$(usex lz4 ON OFF)
		-DARROW_WITH_MUSL=$(usex elibc_musl ON OFF)
		-DARROW_WITH_RE2=$(usex re2 ON OFF)
		-DARROW_WITH_SNAPPY=$(usex snappy ON OFF)
		-DARROW_WITH_ZLIB=$(usex zlib ON OFF)
		-DARROW_WITH_ZSTD=$(usex zstd ON OFF)
		-DCMAKE_CXX_STANDARD=17
		-DPARQUET_REQUIRE_ENCRYPTION=$(usex ssl ON OFF)
	)

	if use arrow-flight ; then
		mycmakeargs+=(
			$(abseil-cpp_append_cmake)
			$(protobuf_append_cmake)
			$(re2_append_cmake)
			$(grpc_append_cmake)
C		)
	fi

	cmake_src_configure
}

src_test() {
	local -x PARQUET_TEST_DATA="${WORKDIR}/parquet-testing-${PARQUET_DATA_GIT_HASH}/data"
	local -x ARROW_TEST_DATA="${WORKDIR}/arrow-testing-${ARROW_DATA_GIT_HASH}/data"
	cmake_src_test
}

src_install() {
	cmake_src_install
	if use test ; then
		cd "${D}/usr/$(get_libdir)" || die
		rm -r "cmake/ArrowTesting" || die
		rm "libarrow_testing"* || die
		rm "pkgconfig/arrow-testing.pc" || die
	fi
}
