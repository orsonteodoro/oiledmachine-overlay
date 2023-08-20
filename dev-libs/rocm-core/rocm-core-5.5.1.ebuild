# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=16
ROCM_VERSION="${PV}"

inherit cmake rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/rocm-core/"
	inherit git-r3
else
	SRC_URI="
https://github.com/RadeonOpenCompute/rocm-core/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/rocm-core-rocm-${PV}"
fi

DESCRIPTION="rocm-core is a utility which can be used to get ROCm release version. "
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm-core"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
RDEPEND="
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.16
"
PATCHES=(
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DROCM_VERSION="${PV}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodoc copyright
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
