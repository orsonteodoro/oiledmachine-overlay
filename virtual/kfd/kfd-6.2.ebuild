# Copyright 1999-2020,2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# The PV is the same as DC_VER in
# https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/rocm-6.2.0/drivers/gpu/drm/amd/display/dc/dc.h#L48

AMDGPU_FIRMWARE_PV="6.7.0.60102" # Not available yet.
DC_VER="3.2.286" # From rock-dkms
KERNEL_FIRMWARE_PV="99999999" # DCN 4.0.1 and VCN 5.0.0 was not found.  Currently DCN is 3.1.4, VCN is 4.0.0 on linux-firmware.git
# Expected firmware properites:
# Git message:  6.2
# Driver folder = 6.2.0
# DCN = 4.0.1
# GC = ?
# PSP = ?
# SDMA = ?
# VCN = 5.0.0
KERNEL_PV="6.11" # DC_VER = 3.2.291 ; DCN = 4.0.1 ; KERNEL_PV is from linux-kernel not rock-dkms
# Expected kernel properties:
# Some of the last amdkfd commits are applied to the amdkfd folder (d2e5bf7, b7c09a6, 97f3ca8, 37209d5) ; missing 835309f, a3431f7
# DCN is >= 4.0.1
# DC_VER is >= 3.2.286
# KMS is >= 3.58.0
#
# See also
# https://github.com/ROCm/ROCK-Kernel-Driver/commits/rocm-6.2.0/drivers/gpu/drm/amd/amdkfd
# drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c for KMS version
# drivers/gpu/drm/amd/display/dc/dc.h for DC_VER
# drivers/gpu/drm/amd/display/include/dal_types.h for DCN version
# drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c for VCN version
ROCM_VERSION="6.2.0" # DC_VER = ${PV}
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
KEYWORDS="~amd64 ~x86" # Work In Progress (WIP)
IUSE="custom-kernel kernel rock-dkms strict-pairing r3"
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
