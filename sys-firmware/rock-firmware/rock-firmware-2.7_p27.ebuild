# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Radeon Open Compute (ROCk) firmware"
HOMEPAGE="https://rocm.github.io/"
LICENSE="LICENSE.ucode"
KEYWORDS="~amd64"
MY_RPR="${PV//_p/-}" # Remote PR
FN="rock-dkms_${MY_RPR}_all.deb"
BASE_URL="http://repo.radeon.com/rocm/apt/debian"
FOLDER="pool/main/r/rock-dkms"
RDEPEND="!sys-kernel/linux-firmware
	 !sys-firmware/amdgpu-firmware"
RESTRICT="fetch"
SLOT="0/${PV}"
inherit unpacker
SRC_URI="http://repo.radeon.com/rocm/apt/debian/pool/main/r/rock-dkms/${FN}"
S="${WORKDIR}"

pkg_nofetch() {
        local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
        einfo "Please download"
        einfo "  - ${FN}"
        einfo "from ${BASE_URL} in the ${FOLDER} folder and place them in"
	einfo "${distdir}"
}

src_unpack() {
	unpack_deb ${A}
}

src_compile() {
	:;
}

src_install() {
	insinto /lib/firmware
	doins -r usr/src/amdgpu-${MY_RPR}/firmware/{radeon,amdgpu}
}
