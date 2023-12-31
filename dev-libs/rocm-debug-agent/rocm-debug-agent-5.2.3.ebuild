# Copyright 1999-2020,2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CONFIG_CHECK="~HSA_AMD"
LLVM_MAX_SLOT=14
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake linux-info rocm

SRC_URI="
https://github.com/ROCm-Developer-Tools/rocr_debug_agent/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Radeon Open Compute Debug Agent"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/rocr_debug_agent/"
KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="test r2"
RDEPEND="
	!dev-libs/rocm-debug-agent:0
	dev-libs/elfutils
	dev-util/systemtap
	virtual/libelf
	~dev-libs/ROCdbgapi-${PV}:${ROCM_SLOT}
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.8.0
	test? (
		~dev-util/hip-${PV}:${ROCM_SLOT}
	)
"
RESTRICT="
	test
"
S="${WORKDIR}/rocr_debug_agent-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/${PN}-5.2.3-path-changes.patch"
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
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
