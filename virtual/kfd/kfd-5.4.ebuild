# Copyright 1999-2020,2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# The PV is the same as DC_VER in
# https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/rocm-5.4.3/drivers/gpu/drm/amd/display/dc/dc.h#L48

AMDGPU_FIRMWARE_PV="5.18.13.50403"
DC_VER="3.2.212" # From rock-dkms
KERNEL_FIRMWARE_PV="20230125" # Based on linux-firmware commit logs for git message 5.4 (2023-01-10) and add VCN (2023-01-25)
# Expected firmware properites:
# Git message:  5.4
# Driver folder = 5.4.3
# DCN = 3.2.0
# GC = 11.0.1
# PSP = 13.0.8
# SDMA = 6.0.1
# VCN = 4.0.2
KERNEL_PV="6.3" # DC_VER = 3.2.223 ; DCN = 3.2.1 ; KERNEL_PV is from linux-kernel not rock-dkms
# Expected kernel properties:
# Some of the last amdkfd commits are applied to the amdkfd folder (79ff64f, fc65b97, 0caeefd, 954866d)
# DCN is >= 3.2
# DC_VER is >= 3.2.212
# KMS is >= 3.48.0
#
# See also
# https://github.com/ROCm/ROCK-Kernel-Driver/commits/rocm-5.4.3/drivers/gpu/drm/amd/amdkfd
# drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c for KMS version
# drivers/gpu/drm/amd/display/dc/dc.h for DC_VER
# drivers/gpu/drm/amd/display/include/dal_types.h for DCN version
# drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c for VCN version
ROCM_VERSION="5.4.3" # DC_VER = ${PV}
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
IUSE="custom-kernel kernel rock-dkms strict-pairing ebuild-revision-4"
SLOT="${ROCM_SLOT}/${ROCM_VERSION}"
FIRMWARE_RDEPEND="
	!strict-pairing? (
		|| (
			>=sys-firmware/amdgpu-dkms-firmware-${AMDGPU_FIRMWARE_PV}
			>=sys-kernel/linux-firmware-${KERNEL_FIRMWARE_PV}
		)
	)
	strict-pairing? (
		~sys-firmware/amdgpu-dkms-firmware-${AMDGPU_FIRMWARE_PV}:${ROCM_SLOT}
	)
"
KFD_RDEPEND="
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
"
RDEPEND="
	!virtual/amdgpu-drm
	${FIRMWARE_RDEPEND}
	${KFD_RDEPEND}
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
