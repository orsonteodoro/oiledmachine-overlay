# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="5.5.0"
LLVM_SLOT=14
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit cmake rocm

if [[ ${PV} == *"9999" ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/rocm-core/"
	inherit git-r3
else
# No tagged release, but we will try a workaround for 5.1.3 to 5.4.3
	SRC_URI="
https://github.com/ROCm/rocm-core/archive/refs/tags/rocm-${MY_PV}.tar.gz
	-> ${PN}-${MY_PV}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/rocm-core-rocm-${MY_PV}"
fi

DESCRIPTION="rocm-core is a utility which can be used to get ROCm release version. "
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm-core"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
"
# The distro's MIT license template does not contain all rights reserved.
SLOT="${ROCM_SLOT}/${PV}"
IUSE="ebuild-revision-6"
RDEPEND="
	!dev-libs/rocm-core:0
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${ROCM_GCC_DEPEND}
	>=dev-build/cmake-3.16
"
PATCHES=(
	"${FILESDIR}/${PN}-5.5.1-fix-linker-flags.patch"
	"${FILESDIR}/${PN}-5.5.1-hardcoded-paths.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	rocm_set_default_gcc
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DROCM_VERSION="${PV}"
	)
	rocm_src_configure
}

src_install() {
	cmake_src_install
	dodoc copyright
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
