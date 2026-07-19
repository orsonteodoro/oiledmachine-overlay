# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=17

FALLBACK_COMMIT="e9a1635e0c89d1b222e71544b4e9b51ea447c57e"

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
IUSE+=" ebuild_revision_1"
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
