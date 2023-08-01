# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

SRC_URI="
	https://github.com/ROCm-Developer-Tools/ROCdbgapi/archive/rocm-${PV}.tar.gz
		-> ${P}.tar.gz
"

DESCRIPTION="AMD Debugger API"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/ROCdbgapi"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
RDEPEND="
	~dev-libs/rocm-comgr-${PV}:${SLOT}
	~dev-libs/rocr-runtime-${PV}:${SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.8
"
S="${WORKDIR}/ROCdbgapi-rocm-${PV}"
PATCHES=(
)

src_prepare() {
	sed \
		-e "s:DESTINATION lib:DESTINATION lib64:" \
		-i \
		"CMakeLists.txt" \
		|| die
	sed \
		-e "s:DESTINATION share/doc/amd-dbgapi:DESTINATION share/doc/amd-dbgapi-${PV}:" \
		-i \
		"CMakeLists.txt" \
		|| die
	local mycmakeargs=(
	)
	cmake_src_prepare
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
