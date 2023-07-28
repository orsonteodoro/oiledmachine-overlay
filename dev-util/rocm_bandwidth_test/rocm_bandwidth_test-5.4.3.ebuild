# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

SRC_URI="
https://github.com/RadeonOpenCompute/${PN}/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Bandwidth test for ROCm"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm_bandwidth_test"
LICENSE="NCSA-AMD"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
RDEPEND="
	~dev-libs/rocr-runtime-${PV}:${SLOT}
"
DEPEND="
	${DEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.6.3
"
S="${WORKDIR}/${PN}-rocm-${PV}"

src_install() {
	cmake_src_install
	rm -rfv "${ED}/usr/share/doc/rocm-bandwidth-test"
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
