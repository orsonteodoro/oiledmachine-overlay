# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=11

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX11[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX11[@]/llvm_slot_}
)

inherit cmake libcxx-slot libstdcxx-slot

DESCRIPTION="Prometheus Client Library for Modern C++"
HOMEPAGE="https://github.com/jupp0r/prometheus-cpp"
SRC_URI="https://github.com/jupp0r/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"
IUSE="test zlib"

RESTRICT="!test? ( test )"

RDEPEND="
	net-misc/curl
	sys-libs/zlib
	www-servers/civetweb[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},cxx]
"
DEPEND="
	${RDEPEND}
	test? (
		dev-cpp/benchmark[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-cpp/gtest[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
"
BDEPEND="virtual/pkgconfig"

pkg_setup() {
	libcxx-compat_verify
	libstdcxx-compat_verify
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_PULL=yes
		-DENABLE_PUSH=yes
		-DENABLE_COMPRESSION=$(usex zlib)
		-DENABLE_TESTING=$(usex test)
		-DUSE_THIRDPARTY_LIBRARIES=OFF
		-DGENERATE_PKGCONFIG=ON
		-DRUN_IWYU=OFF
	)

	cmake_src_configure
}
