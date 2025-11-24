# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22, U24

CXX_STANDARD=11

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

inherit cmake libcxx-slot libstdcxx-slot

KEYWORDS="~amd64"
# Misses testing files
# SRC_URI="mirror://apache/thrift/${PV}/${P}.tar.gz"
SRC_URI="
https://github.com/apache/thrift/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz
"

DESCRIPTION="C++ bindings for Apache Thrift"
HOMEPAGE="https://thrift.apache.org/lib/cpp.html"
LICENSE="Apache-2.0"
SLOT="0/${PV}"
IUSE="libevent lua +ssl test"
REQUIRED_USE="
	test? (
		libevent
		ssl
	)
"
RESTRICT="
	!test? (
		test
	)
"
DEPEND="
	>=dev-libs/boost-1.56[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},nls(+)]
	dev-libs/boost:=
	dev-libs/openssl:=
	>=virtual/zlib-1.2.3
	virtual/zlib:=
	libevent? (
		>=dev-libs/libevent-2.0
		dev-libs/libevent:=
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.16
	app-alternatives/lex
	app-alternatives/yacc
"

PATCHES=(
)

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	local mycmakeargs=(
	# WITH_OPTION is preferred over BUILD_OPTION for bug #943012
		-DBUILD_COMPILER=ON
		-DBUILD_LIBRARIES=ON
		-DBUILD_TESTING=$(usex test)
		-DBUILD_TUTORIALS=OFF
		-DWITH_AS3=ON
		-DWITH_C_GLIB=OFF
		-DWITH_CPP=ON
		-DWITH_LIBEVENT=$(usex libevent)
		-DWITH_JAVA=OFF
		-DWITH_JAVASCRIPT=OFF
		-DWITH_NODEJS=OFF
		-DWITH_OPENSSL=$(usex ssl)
		-DWITH_PYTHON=OFF
		-DWITH_QT5=OFF
		-DWITH_ZLIB=ON
		-Wno-dev
	)
	cmake_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=(
	# Network sandbox
		"StressTestConcurrent"
		"StressTestNonBlocking"
		"UnitTests"
	)
	cmake_src_test
}
