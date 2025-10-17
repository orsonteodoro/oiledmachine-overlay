# Copyright 2011-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=98

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX98[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX98[@]/llvm_slot_}
)

inherit cmake-multilib libcxx-slot libstdcxx-slot

DESCRIPTION="Google Logging library"
HOMEPAGE="https://github.com/google/glog"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/google/glog"
	inherit git-r3
else
	SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

	KEYWORDS="amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
fi

LICENSE="BSD"
SLOT="0/1"
IUSE="gflags +libunwind llvm-libunwind test"
RESTRICT="!test? ( test )"

RDEPEND="
	gflags? (
		dev-cpp/gflags[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
		dev-cpp/gflags:=
	)
	libunwind? (
		llvm-libunwind? ( llvm-runtimes/libunwind:=[${MULTILIB_USEDEP}] )
		!llvm-libunwind? ( sys-libs/libunwind:=[${MULTILIB_USEDEP}] )
	)
"
DEPEND="
	${RDEPEND}
	test? (
		>=dev-cpp/gtest-1.8.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
		dev-cpp/gtest:=
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.0-cmake-4.patch
)

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test ON OFF)
		-DWITH_GFLAGS=$(usex gflags ON OFF)
		-DWITH_GTEST=$(usex test ON OFF)
		-DWITH_UNWIND=$(usex libunwind ON OFF)
	)

	cmake-multilib_src_configure
}

src_test() {
	# Tests have a history of being brittle: bug #863599
	CMAKE_SKIP_TESTS=(
		logging
		stacktrace
		symbolize
		log_severity_conversion
		includes_vlog_is_on
		includes_raw_logging
	)

	cmake-multilib_src_test -j1
}
