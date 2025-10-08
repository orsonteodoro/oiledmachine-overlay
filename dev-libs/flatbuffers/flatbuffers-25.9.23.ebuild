# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GCC_COMPAT=(
	"gcc_slot_11_5" # Support -std=c++17
	"gcc_slot_12_5" # Support -std=c++17
	"gcc_slot_13_4" # Support -std=c++17
	"gcc_slot_14_3" # Support -std=c++17
)

inherit cmake libstdcxx-slot

DESCRIPTION="Memory efficient serialization library"
HOMEPAGE="
	https://flatbuffers.dev/
	https://github.com/google/flatbuffers/
"
SRC_URI="
	https://github.com/google/flatbuffers/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

pkg_setup() {
	libstdcxx-slot_verify
}

src_configure() {
	local mycmakeargs=(
		-DFLATBUFFERS_BUILD_FLATLIB=$(usex static-libs)
		-DFLATBUFFERS_BUILD_SHAREDLIB=ON
		-DFLATBUFFERS_BUILD_TESTS=$(usex test)
		-DFLATBUFFERS_BUILD_BENCHMARKS=OFF
	)

	cmake_src_configure
}
