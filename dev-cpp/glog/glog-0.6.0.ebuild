# Copyright 2011-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

GCC_COMPAT=(
	"gcc_slot_11_5" # Support -std=c++17
	"gcc_slot_12_5" # Support -std=c++17
	"gcc_slot_13_4" # Support -std=c++17
	"gcc_slot_14_3" # Support -std=c++17
)

inherit cmake-multilib libstdcxx-slot

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/google/glog"
fi

DESCRIPTION="Google Logging library"
HOMEPAGE="https://github.com/google/glog"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD"
SLOT="0/1"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="gflags +libunwind llvm-libunwind test"
RESTRICT="!test? ( test )"

RDEPEND="
	gflags? (
		dev-cpp/gflags:0[${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
		dev-cpp/gflags:=
	)
	libunwind? (
		llvm-libunwind? ( llvm-runtimes/libunwind:0=[${MULTILIB_USEDEP}] )
		!llvm-libunwind? ( sys-libs/libunwind:0=[${MULTILIB_USEDEP}] )
	)
"
DEPEND="
	${RDEPEND}
	test? (
		>=dev-cpp/gtest-1.8.0[${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
		dev-cpp/gtest:=
	)
"

PATCHES=(
	"${FILESDIR}/${P}-disable-symbolize-test.patch" # bug 863599
	"${FILESDIR}/${P}-try-fix-logging-test.patch"
)

pkg_setup() {
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
	cmake-multilib_src_test -j1
}
