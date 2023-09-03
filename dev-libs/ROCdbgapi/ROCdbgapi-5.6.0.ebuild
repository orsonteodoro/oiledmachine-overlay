# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=16

inherit cmake rocm

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
	"${FILESDIR}/${PN}-5.6.0-path-changes.patch"
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

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
