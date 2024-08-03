# Copyright 1999-2020,2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# The PV is the same as DC_VER in
# https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/rocm-5.1.3/drivers/gpu/drm/amd/display/dc/dc.h#L48

AMDGPU_FIRMWARE_PV="5.11.32.40502"
DC_VER="3.2.150" # From rock-dkms
KERNEL_FIRMWARE_PV="20211112" # Based on linux-firmware commit logs for git message 21.40 (2021-11-12)
# Expected firmware properites:
# Git message:  21.40
# Driver folder = 21.40.2
# DCN = missing [3.1]
# GC = missing
# PSP = missing
# SDMA = missing
# VCN = missing
# beige_goby = yes (2021-09-28)
# vangogh = yes (2021-08-12)
# yellow_carp = yes (2021-09-15)
KERNEL_PV="5.17" # DC_VER = 3.2.167 ; DCN = 3.1 ; KERNEL_PV is from linux-kernel not rock-dkms
# Expected kernel properties:
# Some of the last amdkfd commits are applied to the amdkfd folder (55a383f, 4bf8e09, 5c3c497)
# DCN is >= 3.1
# DC_VER is >= 3.2.150
# KMS is >= 3.43.0
#
# See also
# https://github.com/ROCm/ROCK-Kernel-Driver/commits/rocm-4.5.2/drivers/gpu/drm/amd/amdkfd
# drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c for KMS version
# drivers/gpu/drm/amd/display/dc/dc.h for DC_VER
# drivers/gpu/drm/amd/display/include/dal_types.h for DCN version
ROCM_VERSION="4.5.2" # DC_VER = ${PV}
ROCM_SLOT="${ROCM_VERSION%.*}"
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
SLOT="${ROCM_SLOT}/${ROCM_VERSION}"
RDEPEND="
	!virtual/amdgpu-drm:0
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
			>=sys-kernel/rock-dkms-${ROCM_VERSION}
		)
	)
	strict-pairing? (
		~sys-firmware/amdgpu-dkms-firmware-${AMDGPU_FIRMWARE_PV}:${ROCM_SLOT}
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
			~sys-kernel/rock-dkms-${ROCM_VERSION}:${ROCM_SLOT}
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
