# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CONFIG_CHECK="~HSA_AMD"
LLVM_SLOT=12
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake linux-info rocm

KEYWORDS="~amd64"
S="${WORKDIR}/rocr_debug_agent-rocm-${PV}"
SRC_URI="
https://github.com/ROCm-Developer-Tools/rocr_debug_agent/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Radeon Open Compute Debug Agent"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/rocr_debug_agent/"
LICENSE="NCSA-AMD"
RESTRICT="
	test
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="test ebuild_revision_6"
RDEPEND="
	!dev-libs/rocm-debug-agent:0
	dev-libs/elfutils
	dev-debug/systemtap
	virtual/libelf
	~dev-libs/ROCdbgapi-${PV}:${ROCM_SLOT}
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${ROCM_GCC_DEPEND}
	>=dev-build/cmake-3.8.0
	test? (
		~dev-util/hip-${PV}:${ROCM_SLOT}
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-5.1.3-hardcoded-paths.patch"
)

pkg_setup() {
	linux-info_pkg_setup
	rocm_pkg_setup
}

src_prepare() {
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

	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	rocm_set_default_gcc
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
	)
	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
