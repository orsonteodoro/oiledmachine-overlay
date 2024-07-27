# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit hip-versions

LLVM_SLOT=17
ROCM_SLOT="5.7"
ROCM_VERSION="${HIP_5_7_VERSION}"

inherit rocm

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/GPUOpen-LibrariesAndSDKs/Orochi/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Orochi is a library loading HIP and CUDA APIs dynamically, allowing the user to switch APIs at runtime"
HOMEPAGE="https://github.com/GPUOpen-LibrariesAndSDKs/Orochi"
LICENSE="
	(
		all-rights-reserved
		Apache-2.0
	)
	(
		all-rights-reserved
		MIT
	)
	BSD
	MIT
"
# all-rights-reserved Apache-2.0 - contrib/cuew/include/cuew.h
# all-rights-reserved MIT - Orochi/nvidia_hip_runtime_api_oro.h
# BSD - UnitTest/contrib/gtest-1.6.0/gtest-all.cc
# BSD MIT - Test/SimpleD3D12/DXSampleHelper.h
# MIT - LICENSE
# The distro's Apache-2.0 license template does not contain all rights reserved.
# The distro's MIT license template does not contain all rights reserved.
SLOT="${ROCM_SLOT}/${ROCM_VERSION}"
RDEPEND="
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/premake:5
"
PATCHES=(
	"${FILESDIR}/${PN}-2.00-hardcoded-paths.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_unpack() {
	unpack ${A}
}

src_prepare() {
	default
	rocm_src_prepare
	premake5 gmake
}

src_configure() {
	:
}

src_compile() {
	emake config=release
}

src_install() {
	insinto "/opt/rocm-${ROCM_VERSION}/include/${PN}"
	doins -r *
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
