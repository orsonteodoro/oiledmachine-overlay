# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

AMDGPU_FIRMWARE_PV="5.13.20.22.10.50103"
KERNEL_FIRMWARE_PV="20220516" # Based on linux-firmware commit logs
KERNEL_PV="5.18"  # DC_VER = 3.2.177 ; KERNEL_PV is from linux-kernel not rock-dkms
ROCK_DKMS_PV="5.1.3" # DC_VER = ${PV}
#
# linux firmware notes:
# no exact tag # matches last commit/tag AMDGPU_DKMS_PV in linux-firmware git
#
# You can find the timestamps at
# https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/log/amdgpu
# https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/refs/
#

DESCRIPTION="Virtual for the amdgpu DRM (Direct Rendering Manager) kernel module"
KEYWORDS="~amd64 ~x86"
IUSE="custom-kernel kernel rock-dkms strict-pairing"
SLOT="0/${PV}"
RDEPEND="
	!strict-pairing? (
		|| (
			>=sys-firmware/amdgpu-dkms-firmware-${AMDGPU_FIRMWARE_PV}
			>=sys-kernel/linux-firmware-${KERNEL_FIRMWARE_PV}
		)
		kernel? (
			!custom-kernel? (
				|| (
					>=sys-kernel/gentoo-kernel-${KERNEL_PV}
					>=sys-kernel/gentoo-kernel-bin-${KERNEL_PV}
					>=sys-kernel/gentoo-sources-${KERNEL_PV}
					>=sys-kernel/git-sources-${KERNEL_PV}
					>=sys-kernel/ot-sources-${KERNEL_PV}
					>=sys-kernel/pf-sources-${KERNEL_PV}
					>=sys-kernel/rt-sources-${KERNEL_PV}
					>=sys-kernel/vanilla-kernel-${KERNEL_PV}
					>=sys-kernel/vanilla-sources-${KERNEL_PV}
					>=sys-kernel/zen-sources-${KERNEL_PV}
				)
			)
		)
		rock-dkms? (
			>=sys-kernel/rock-dkms-${ROCK_DKMS_PV}
		)
	)
	strict-pairing? (
		~sys-firmware/amdgpu-dkms-firmware-${AMDGPU_FIRMWARE_PV}
		kernel? (
			!custom-kernel? (
				|| (
					=sys-kernel/gentoo-kernel-${KERNEL_PV}*
					=sys-kernel/gentoo-kernel-bin-${KERNEL_PV}*
					=sys-kernel/gentoo-sources-${KERNEL_PV}*
					=sys-kernel/git-sources-${KERNEL_PV}*
					=sys-kernel/ot-sources-${KERNEL_PV}*
					=sys-kernel/pf-sources-${KERNEL_PV}*
					=sys-kernel/rt-sources-${KERNEL_PV}*
					=sys-kernel/vanilla-kernel-${KERNEL_PV}*
					=sys-kernel/vanilla-sources-${KERNEL_PV}*
					=sys-kernel/zen-sources-${KERNEL_PV}*
				)
			)
		)
		rock-dkms? (
			~sys-kernel/rock-dkms-${ROCK_DKMS_PV}
		)
	)
"
# A mask for sys-kernel/linux-firmware should be in REQUIRED_USE
REQUIRED_USE="
	^^ (
		kernel
		rock-dkms
	)
"

pkg_setup() {
ewarn
ewarn "The following are still required:"
ewarn
	if use strict-pairing ; then
ewarn "DC_VER:  ${PV} within z±10 in x.y.z, from /usr/src/linux/drivers/gpu/drm/amd/display/dc/dc.h"
ewarn "Kernel version:  =${KERNEL_PV}*"
	else
ewarn "DC_VER:  >=${PV}, from /usr/src/linux/drivers/gpu/drm/amd/display/dc/dc.h"
ewarn "Kernel version:  >=${KERNEL_PV}"
	fi
ewarn
}
