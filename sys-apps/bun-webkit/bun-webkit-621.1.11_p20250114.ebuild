# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# For versioning, see
# https://github.com/oven-sh/bun/blob/bun-v1.2.0/cmake/tools/SetupWebKit.cmake#L5
# https://github.com/oven-sh/WebKit/blob/9e3b60e4a6438d20ee6f8aa5bec6b71d2b7d213f/Configurations/Version.xcconfig#L26

WEBKIT_PV="621.1.11"
LOCKFILE_VER="1.2"
CPU_FLAGS_X86=(
	cpu_flags_x86_avx2
)
EGIT_COMMIT="9e3b60e4a6438d20ee6f8aa5bec6b71d2b7d213f"

inherit cmake

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/WebKit-autobuild-${EGIT_COMMIT}"
SRC_URI="
https://github.com/oven-sh/WebKit/archive/refs/tags/autobuild-${EGIT_COMMIT}.tar.gz
	-> bun-webkit-${EGIT_COMMIT:0:7}.tar.gz
"

DESCRIPTION="WebKit with patches"
HOMEPAGE="
https://bun.sh/
https://github.com/oven-sh/WebKit
"
LICENSE="
	BSD
	LGPL-2
"
RESTRICT="mirror"
SLOT="${LOCKFILE_VER}"
IUSE+="
${CPU_FLAGS_X86[@]}
ebuild_revision_1
"
RDEPEND+="
	>=dev-libs/icu-66.1[static-libs]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.20
	sys-devel/gcc
"

src_unpack() {
	unpack ${A}
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="/usr/share/${PN}/${LOCKFILE_VER}"
		-DPORT="JSCOnly"
		-DENABLE_STATIC_JSC=ON
		-DENABLE_BUN_SKIP_FAILING_ASSERTIONS=ON
		-DCMAKE_BUILD_TYPE="Release"
		-DUSE_THIN_ARCHIVES=OFF
		-DUSE_BUN_JSC_ADDITIONS=ON
		-DUSE_BUN_EVENT_LOOP=ON
		-DENABLE_FTL_JIT=ON
		-DCMAKE_EXPORT_COMPILE_COMMANDS=ON
		-DALLOW_LINE_AND_COLUMN_NUMBER_IN_BUILTINS=ON
		-DENABLE_REMOTE_INSPECTOR=ON
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	insinto "/usr/share/${PN}/${PV}"
	cmake_src_install
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
