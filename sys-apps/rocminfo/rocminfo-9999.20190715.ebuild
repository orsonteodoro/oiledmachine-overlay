# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils cmake-utils multilib-minimal multilib-build

COMMIT="0f9f4bc3d0c6880f673e04cb089aac878331f5ae"

DESCRIPTION="ROCm Application for Reporting System Info "
HOMEPAGE="https://github.com/RadeonOpenCompute/rocminfo"
SRC_URI="https://github.com/RadeonOpenCompute/rocminfo/archive/${COMMIT}.zip -> ${PN}-${PV}.zip"

LICENSE="NCSA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="rock-latest rock-milestone rock-snapshot"
REQUIRED_USE="|| ( rock-latest rock-milestone rock-snapshot )"

RDEPEND="sys-kernel/ot-sources[rock-latest?,rock-milestone?,rock-snapshot?]
	 || ( x11-drivers/amdgpu-pro[hsa] dev-libs/roct-thunk-interface )
	 dev-libs/rocm-cmake
	 dev-libs/rocr-runtime"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	cmake-utils_src_prepare
	multilib_copy_sources
}

multilib_src_configure() {
	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
}

multilib_src_install() {
	cmake-utils_src_install
}
