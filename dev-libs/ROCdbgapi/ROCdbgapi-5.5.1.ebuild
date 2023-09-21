# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=16
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake rocm

SRC_URI="
	https://github.com/ROCm-Developer-Tools/ROCdbgapi/archive/rocm-${PV}.tar.gz
		-> ${P}.tar.gz
"

DESCRIPTION="AMD Debugger API"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/ROCdbgapi"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="${ROCM_SLOT}/${PV}"
IUSE=" r3"
RDEPEND="
	!dev-libs/ROCdbgapi:0
	~dev-libs/rocm-comgr-${PV}:${ROCM_SLOT}
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.8
"
S="${WORKDIR}/ROCdbgapi-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/${PN}-5.5.1-path-changes.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	local mycmakeargs=(
	)
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
	)
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
