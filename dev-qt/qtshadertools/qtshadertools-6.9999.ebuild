# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=17

FALLBACK_COMMIT="af0d9c3e0dcd68176b5a5288a5192c12a2d8a188" # Mon, 15 Jun 2026 04:04:14 +0000

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

CHKL_TIMESTAMPS=(
	"dev-qt/qtbase-6.9999"
)

inherit chkl libcxx-slot libstdcxx-slot flag-o-matic qt6-build

DESCRIPTION="Qt APIs and Tools for Graphics Pipelines"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

RDEPEND="
	~dev-qt/qtbase-${PV}:6=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},gui]
"
DEPEND="${RDEPEND}"

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	chkl_check_many_timestamps
	# -Werror=odr violations between mismatching spirv.hpp (bug #972694)
	filter-lto

	qt6-build_src_configure
}
