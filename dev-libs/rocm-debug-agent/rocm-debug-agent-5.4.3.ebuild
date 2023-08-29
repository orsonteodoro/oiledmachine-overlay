# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CONFIG_CHECK="~HSA_AMD"
LLVM_MAX_SLOT=15

inherit cmake linux-info rocm

SRC_URI="
https://github.com/ROCm-Developer-Tools/rocr_debug_agent/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Radeon Open Compute Debug Agent"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/rocr_debug_agent/"
KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="test"
RDEPEND="
	~dev-libs/ROCdbgapi-${PV}:${SLOT}
	~dev-libs/rocr-runtime-${PV}:${SLOT}
	dev-libs/elfutils
	dev-util/systemtap
	virtual/libelf
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.8.0
	test? (
		~dev-util/hip-${PV}:${SLOT}
	)
"
RESTRICT="
	test
"
S="${WORKDIR}/rocr_debug_agent-rocm-${PV}"

pkg_setup() {
	linux-info_pkg_setup
	rocm_pkg_setup
}

src_prepare() {
	sed \
		-e "s:/opt/rocm/hip/cmake:/usr/$(get_libdir)/cmake/hip/:" \
		-i \
		"${S}/test/CMakeLists.txt" \
		|| die

	sed \
		-e "s:enable_testing:#enable_testing:" \
		-i \
		"${S}/CMakeLists.txt" \
		|| die
	sed \
		-e "s:add_subdirectory(test):#add_subdirectory(test):" \
		-i \
		"${S}/CMakeLists.txt" \
		|| die

	sed \
		-e \
		"s:DESTINATION lib:DESTINATION $(get_libdir):" \
		-i \
		"${S}/CMakeLists.txt" \
		|| die
	sed \
		-e "s:DESTINATION share/doc/rocm-debug-agent:DESTINATION share/doc/rocm-debug-agent-${PV}:" \
		-i \
		"${S}/CMakeLists.txt" \
		|| die

	sed \
		-i \
		-e "s|lib/cmake/amd-dbgapi|$(get_libdir)/cmake/amd-dbgapi|g" \
		"${S}/CMakeLists.txt" \
		|| die
	sed \
		-i \
		-e "s|/lib/|/$(get_libdir)/|g" \
		"${S}/README.md" \
		|| die

	cmake_src_prepare
	rocm_src_prepare
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
