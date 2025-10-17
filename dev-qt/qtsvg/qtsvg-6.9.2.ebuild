# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_LANGS="cxx"
CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="DOS IO"
CXX_STANDARD=17

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}
)

inherit cflags-hardened libcxx-slot libstdcxx-slot qt6-build toolchain-funcs

DESCRIPTION="SVG rendering library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv x86"
fi

RDEPEND="
	~dev-qt/qtbase-${PV}:6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},gui,widgets]
	dev-qt/qtbase:=
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}"

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	cflags-hardened_append
	qt6-build_src_configure
}

src_test() {
	# tst_QSvgRenderer::testFeColorMatrix (new in 6.7, likely low impact)
	# is known failing on BE, could use more looking into (bug #935356)
	[[ $(tc-endian) == big ]] && local CMAKE_SKIP_TESTS=( tst_qsvgrenderer )

	qt6-build_src_test
}
