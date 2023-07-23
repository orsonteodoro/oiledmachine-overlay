# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROCK_DKMS_PV="5.6.0" # DC_VER = ${PV}
VANILLA_KERNEL_PV="6.4"  # DC_VER = 3.2.230
VANILLA_FIRMWARE_PV="20230625" # Rounded to the closest day within the month based on Makefile 6.4 timestamp.
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
IUSE="dkms +firmware kernel rock-dkms strict-pairing"
SLOT="0/${PV}" # based on DC_VER, rock-dkms will not be an exact fit
RDEPEND="
	strict-pairing? (
		rock-dkms? (
			=sys-kernel/rock-dkms-${ROCK_DKMS_PV}*
		)
		firmware? (
			=sys-kernel/linux-firmware-${VANILLA_FIRMWARE_PV}
		)
	)
	!strict-pairing? (
		rock-dkms? (
			>=sys-kernel/rock-dkms-${ROCK_DKMS_PV}
		)
		firmware? (
			>=sys-kernel/linux-firmware-${VANILLA_FIRMWARE_PV}
		)
	)
"
# A mask for sys-kernel/linux-firmware should be in REQUIRED_USE
REQUIRED_USE="
	!rock-dkms
	^^ (
		kernel
		rock-dkms
	)
	dkms? (
		^^ (
			rock-dkms
		)
	)
	rock-dkms? (
		dkms
	)
"

pkg_setup() {
	if use rock-dkms ; then
		:;
	else
		if [[ ! -f "${EROOT}/usr/src/linux/drivers/gpu/drm/amd/display/dc/dc.h" ]] ; then
eerror
eerror "Cannot find ${EROOT}/usr/src/linux/drivers/gpu/drm/amd/display/dc/dc.h"
eerror
eerror "Install the source code for your kernel and make sure the"
eerror "${EROOT}/usr/src/linux symlink is updated."
eerror
			die
		fi
		DC_VER=$(grep "DC_VER" "${EROOT}/usr/src/linux/drivers/gpu/drm/amd/display/dc/dc.h" \
			| cut -f 3 -d " " \
			| sed -e "s|\"||g")
		if ver_test ${DC_VER} -lt ${PV} ; then
eerror
eerror "Your DC_VER is old.  Your kernel needs to be at least"
eerror "${VANILLA_KERNEL_PV} or DC_VER needs to be ${PV}."
eerror
			die
		fi
	fi
}
