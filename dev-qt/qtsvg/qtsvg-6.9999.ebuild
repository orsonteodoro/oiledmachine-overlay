# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_LANGS="cxx"
CFLAGS_HARDENED_USE_CASES="security-critical untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="DOS IO"
CXX_STANDARD=17

FALLBACK_COMMIT="f8888c3e8640d48c4be5828962dba0f6cbd8d17e" # Wed, 27 May 2026 16:17:25 +0200

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

CHKL_TIMESTAMPS=(
	"dev-qt/qtbase-qtsvg-6.9999"
)

inherit cflags-hardened chkl libcxx-slot libstdcxx-slot qt6-build secure-version toolchain-funcs

DESCRIPTION="SVG rendering library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

RDEPEND="
	~dev-qt/qtbase-${PV}:6=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},gui,widgets]
	>=virtual/zlib-${ZLIB_PV}:=
"
DEPEND="${RDEPEND}"

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	qt6-build_src_configure
}

src_test() {
	# tst_QSvgRenderer::testFeColorMatrix (new in 6.7, likely low impact)
	# is known failing on BE, could use more looking into (bug #935356)
	[[ $(tc-endian) == big ]] && local CMAKE_SKIP_TESTS=( tst_qsvgrenderer )

	qt6-build_src_test
}
