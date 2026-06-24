# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=17

FALLBACK_COMMIT="c7e4e72dfec4aa200f1ec05d7667a2c5382e8c09" # Fri, 12 Jun 2026 21:06:43 +0000

CHKL_TIMESTAMPS=(
	"dev-qt/qtbase-6.9999"
	"dev-qt/qtdeclarative-6.9999"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

inherit chkl libcxx-slot libstdcxx-slot qt6-build

DESCRIPTION="Qt module for keyframe-based timeline construction"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

RDEPEND="
	~dev-qt/qtbase-${PV}:6=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	~dev-qt/qtdeclarative-${PV}:6=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
"
DEPEND="${RDEPEND}"

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	chkl_check_many_timestamps
	qt6-build_src_configure
}
