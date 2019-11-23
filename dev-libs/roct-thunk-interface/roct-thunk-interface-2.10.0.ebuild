# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Radeon Open Compute Thunk Interface"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCT-Thunk-Interface"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
inherit cmake-utils linux-info
if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI=\
"https://github.com/RadeonOpenCompute/ROCT-Thunk-Interface/"
	inherit git-r3
else
	SRC_URI=\
"https://github.com/RadeonOpenCompute/ROCT-Thunk-Interface/archive/roc-${PV}.tar.gz \
	-> ${P}.tar.gz"
	S="${WORKDIR}/ROCT-Thunk-Interface-roc-${PV}"
	KEYWORDS="~amd64"
fi
RDEPEND="sys-apps/pciutils
	 sys-process/numactl
	 x11-drivers/amdgpu-pro[-roct]
	 || ( sys-kernel/amdgpu-dkms sys-kernel/rock-dkms )"
DEPEND="${RDEPEND}"
CONFIG_CHECK="~HSA_AMD"

src_prepare() {
	sed -i -e "s:get_version ( \"1.0.0\" ):get_version ( \"${PV}\" ):" \
		CMakeLists.txt || die
	cmake-utils_src_prepare
}
