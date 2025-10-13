# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# ROCm driver versions:
# Last GC:    https://github.com/ROCm/amdgpu/blob/rocm-6.4.3/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
# DCN:        https://github.com/ROCm/amdgpu/blob/rocm-6.4.3/drivers/gpu/drm/amd/display/include/dal_types.h#L67
# DC_VER:     https://github.com/ROCm/amdgpu/blob/rocm-6.4.3/drivers/gpu/drm/amd/display/dc/dc.h
# KFD IOCTL:  https://github.com/ROCm/amdgpu/blob/rocm-6.4.3/include/uapi/linux/kfd_ioctl.h
# PSP:        https://github.com/ROCm/amdgpu/blob/rocm-6.4.3/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c
# VCN:        https://github.com/ROCm/amdgpu/blob/rocm-6.4.3/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c#L65

# VCN: Hardware accelerated encode and decode
# DC:  Software driver layer
# DCN: Hardware display controller
# GC:  Graphics and compute
# PSP:  Platform security processor, HDCP

AMDGPU_FIRMWARE_PV="6.12.12.60403"
DC_VER="3.2.320" # From rock-dkms
KERNEL_FIRMWARE_PV="20250707"
# Expected firmware properites:
# Git message:  
# Driver folder = 6.4.3
# DCN = 4.0.1 (20241206)
# DC_VER = 3.2.320
# GC = 12.0.1 (20241203, without kicker)
# KFD IOCTL = 1.17
# PSP = 14.0.5 (20250707, without kicker)
# SDMA = 
# SMU = 
# VCN = 5.0.1 (20250620)
# VPE = 

# Vanilla kernel versions:
# Last GC:    https://github.com/torvalds/linux/blob/v6.15/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
# DCN:        https://github.com/torvalds/linux/blob/v6.15/drivers/gpu/drm/amd/display/include/dal_types.h#L67
# DC_VER:     https://github.com/torvalds/linux/blob/v6.15/drivers/gpu/drm/amd/display/dc/dc.h
# KFD IOCTL:  https://github.com/torvalds/linux/blob/v6.15/include/uapi/linux/kfd_ioctl.h
# PSP:        https://github.com/torvalds/linux/blob/v6.15/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c
# VCN:        https://github.com/torvalds/linux/blob/v6.15/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c#L65
KERNEL_PV="6.15" # This row is from the vanilla Linux kernel not rock-dkms that reflects the vanilla kernel versions >= ROCm versions.
# Expected kernel properties:
# Some of the last amdkfd commits are applied to the amdkfd folder (d2e5bf7, b7c09a6, 97f3ca8, 37209d5) ; missing 835309f, a3431f7
# GC = 12.0.1 (without kicker)
# DC_VER = 3.2.325
# DCN = 4.0.1
# KFD IOCTL = 1.18
# PSP = 14.0.5
# VCN = 5.0.1

#
# See also
# https://github.com/ROCm/ROCK-Kernel-Driver/commits/rocm-6.2.4/drivers/gpu/drm/amd/amdkfd
# drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c for KMS version
# drivers/gpu/drm/amd/display/dc/dc.h for DC_VER
# drivers/gpu/drm/amd/display/include/dal_types.h for DCN version
# drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c for VCN version
KERNEL_RANGE=(
# Avoid pinning solely to EOL version.
# See footnote 2 in metadata.xml.
	"6.15" #  0 : KERNEL_PV
	"6.14" # -1
	"5.13"  # -2
)
ROCM_VERSION="6.4.3" # DC_VER = ${PV}
ROCM_SLOT="${ROCM_VERSION%.*}"
#
# linux firmware notes:
# no exact tag # matches last commit/tag AMDGPU_DKMS_PV in linux-firmware git
#
# You can find the timestamps at
# https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/log/amdgpu
# https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/refs/
#

DESCRIPTION="KFD (Kernel Fusion Driver) with version limited upper boundary"
#KEYWORDS="~amd64 ~x86" # Work In Progress (WIP)
IUSE="custom-kernel kernel rock-dkms strict-pairing ebuild_revision_5"
REQUIRED_USE="
	^^ (
		kernel
		rock-dkms
	)
"
SLOT="0/${ROCM_SLOT}"
FIRMWARE_RDEPEND="
	!strict-pairing? (
		|| (
			(
				>=sys-firmware/amdgpu-dkms-firmware-${AMDGPU_FIRMWARE_PV}:${SLOT}
				sys-firmware/amdgpu-dkms-firmware:=
			)
			>=sys-kernel/linux-firmware-${KERNEL_FIRMWARE_PV}
		)
		rock-dkms? (
			>=sys-kernel/rock-dkms-${ROCM_VERSION}:${SLOT}
			sys-kernel/rock-dkms:=
		)
	)
	strict-pairing? (
		>=sys-firmware/amdgpu-dkms-firmware-${AMDGPU_FIRMWARE_PV}:${SLOT}
		sys-firmware/amdgpu-dkms-firmware:=
	)
"
gen_kfd_entry() {
	local atom="${1}" # ex: sys-kernel/ot-sources
	local x
	for x in ${KERNEL_RANGE[@]} ; do
		echo "
			=${atom}-${x}*
		"
	done
}
KFD_RDEPEND="
	kernel? (
		!custom-kernel? (
			|| (
				$(gen_kfd_entry sys-kernel/gentoo-kernel)
				$(gen_kfd_entry sys-kernel/gentoo-kernel-bin)
				$(gen_kfd_entry sys-kernel/gentoo-sources)
				$(gen_kfd_entry sys-kernel/git-sources)
				$(gen_kfd_entry sys-kernel/ot-sources)
				$(gen_kfd_entry sys-kernel/pf-sources)
				$(gen_kfd_entry sys-kernel/rt-sources)
				$(gen_kfd_entry sys-kernel/vanilla-kernel)
				$(gen_kfd_entry sys-kernel/vanilla-sources)
				$(gen_kfd_entry sys-kernel/zen-sources)
			)
		)
	)
	rock-dkms? (
		~sys-kernel/rock-dkms-${ROCM_VERSION}:${SLOT}
	)
"
RDEPEND="
	!virtual/amdgpu-drm
	${FIRMWARE_RDEPEND}
	${KFD_RDEPEND}
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
