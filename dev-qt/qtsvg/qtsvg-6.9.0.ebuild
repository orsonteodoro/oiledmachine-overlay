# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_LANGS="cxx"
CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="DOS IO"

inherit cflags-hardened qt6-build toolchain-funcs

DESCRIPTION="SVG rendering library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~x86"
fi
IUSE="
ebuild_revision_7
"
RDEPEND="
	~dev-qt/qtbase-${PV}:6[gui,widgets]
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}"

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
