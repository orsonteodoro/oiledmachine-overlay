# Copyright 1999-2020,2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# The PV is the same as DC_VER in
# https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/rocm-5.5.1/drivers/gpu/drm/amd/display/dc/dc.h#L48

AMDGPU_FIRMWARE_PV="6.0.5.50501"
DC_VER="3.2.223" # From rock-dkms
KERNEL_FIRMWARE_PV="20230523" # Based on linux-firmware commit logs for git message 5.5 (2023-05-23) and add PSP (2023-03-30)
# Expected firmware properites:
# Git message:  5.5
# Driver folder = 5.5.1
# DCN = 3.2.1
# GC = 11.0.4
# PSP = 13.0.11
# SDMA = 6.0.2
# VCN = 4.0.4
KERNEL_PV="6.3" # DC_VER = 3.2.223 ; DCN = 3.2.1 ; KERNEL_PV is from linux-kernel not rock-dkms
# Expected kernel properties:
# Some of the last amdkfd commits are applied to the amdkfd folder (62e2a0f, 7f75823 [cancelled by 62e2a0f but applied for 6.0 with 0ab2d75], 7efe5d3, e81ed7b, f5c1d84)
# DCN is >= 3.2
# DC_VER is >= 3.2.223
# KMS is >= 3.51.0
#
# See also
# https://github.com/ROCm/ROCK-Kernel-Driver/commits/rocm-5.5.1/drivers/gpu/drm/amd/amdkfd
# drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c for KMS version
# drivers/gpu/drm/amd/display/dc/dc.h for DC_VER
# drivers/gpu/drm/amd/display/include/dal_types.h for DCN version
# drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c for VCN version
KERNEL_RANGE=(
# Avoid pinning solely to EOL version.
# See footnote 2 in metadata.xml.
	"6.5"  # +2
	"6.4"  # +1
	"6.3"  #  0 : KERNEL_PV, not LTS or EOL
)
ROCM_VERSION="5.5.1" # DC_VER = ${PV}
ROCM_SLOT="${ROCM_VERSION%.*}"
#
# linux firmware notes:
# no exact tag # matches last commit/tag AMDGPU_DKMS_PV in linux-firmware git
#
# You can find the timestamps at
# https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/log/amdgpu
# https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/refs/
#

DESCRIPTION="KFD (Kernel Fusion Driver) with version limited lower boundary"
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