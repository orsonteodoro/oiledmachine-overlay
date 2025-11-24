# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=17
RE2_SLOT="20220623"

ABSEIL_CPP_PV="20240722.0"

# arrow.git: testing
ARROW_DATA_GIT_HASH="9a02925d1ba80bd493b6d4da6e8a777588d57ac4"
# arrow.git: cpp/submodules/parquet-testing
PARQUET_DATA_GIT_HASH="a3d96a65e11e2bbca7d22a894e8313ede90a33a3"

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
inherit cmake libcxx-slot libstdcxx-slot

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~riscv ~s390 ~x86"
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
+brotli bzip2 +compute +dataset +json lz4 +parquet +re2 +snappy ssl test zlib
zstd
"
REQUIRED_USE="
	ssl? (
		json
	)
	test? (
		json
		parquet? (
			zstd
		)
	)
"
RESTRICT="
	!test? (
		test
	)
"

RDEPEND="
	>=dev-cpp/abseil-cpp-${ABSEIL_CPP_PV}:${ABSEIL_CPP_PV%%.*}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-cpp/abseil-cpp:=
	>=dev-libs/boost-1.87.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-libs/boost:=
	brotli? (
		>=app-arch/brotli-1.1.0
		app-arch/brotli:=
	)
	bzip2? (
		>=app-arch/bzip2-1.0.8
		app-arch/bzip2:=
	)
	compute? (
		dev-libs/libutf8proc:=
	)
	dataset? (
		dev-libs/libutf8proc:=
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
		>=dev-libs/re2-0.2023-03-01:${RE2_SLOT}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-libs/re2:=
	)
	snappy? (
		>=app-arch/snappy-1.1.9[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		app-arch/snappy:=
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
DEPEND="
	${RDEPEND}
	dev-cpp/xsimd:=
	json? (
		>=dev-libs/rapidjson-9999
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

src_configure() {
	local mycmakeargs=(
		-DARROW_BUILD_STATIC=OFF
		-DARROW_BUILD_TESTS=$(usex test ON OFF)
		-DARROW_COMPUTE=$(usex compute ON OFF)
		-DARROW_CSV=ON
		-DARROW_DATASET=$(usex dataset ON OFF)
		-DARROW_DEPENDENCY_SOURCE="SYSTEM"
		-DARROW_DEPENDENCY_USE_SHARED=ON
		-DARROW_DOC_DIR="share/doc/${PF}"
		-DARROW_FILESYSTEM=ON
		-DARROW_HDFS=ON
		-DARROW_JEMALLOC=OFF
		-DARROW_JSON=$(usex json ON OFF)
		-DARROW_MIMALLOC=OFF
		-DARROW_PARQUET=$(usex parquet ON OFF)
		-DARROW_USE_CCACHE=OFF
		-DARROW_USE_SCCACHE=OFF
		-DARROW_WITH_BROTLI=$(usex brotli ON OFF)
		-DARROW_WITH_BZ2=$(usex bzip2 ON OFF)
		-DARROW_WITH_LZ4=$(usex lz4 ON OFF)
		-DARROW_WITH_RE2=$(usex re2 ON OFF)
		-DARROW_WITH_SNAPPY=$(usex snappy ON OFF)
		-DARROW_WITH_ZLIB=$(usex zlib ON OFF)
		-DARROW_WITH_ZSTD=$(usex zstd ON OFF)
		-DCMAKE_CXX_STANDARD=17
		-DPARQUET_REQUIRE_ENCRYPTION=$(usex ssl ON OFF)
		-Dabsl_DIR="${ESYSROOT}/usr/lib/abseil-cpp/${ABSEIL_CPP_PV}/$(get_libdir)/cmake/absl"
		-Dre2_DIR="${ESYSROOT}/usr/lib/re2/${RE2_SLOT}/$(get_libdir)/cmake/re2"
	)
	cmake_src_configure
}

src_test() {
	local -x PARQUET_TEST_DATA="${WORKDIR}/parquet-testing-${PARQUET_DATA_GIT_HASH}/data"
	local -x ARROW_TEST_DATA="${WORKDIR}/arrow-testing-${ARROW_DATA_GIT_HASH}/data"
	cmake_src_test
}

src_install() {
	cmake_src_install
	if use test; then
		cd "${D}/usr/$(get_libdir)" || die
		rm -r "cmake/ArrowTesting" || die
		rm "libarrow_testing"* || die
		rm "pkgconfig/arrow-testing.pc" || die
	fi
}
