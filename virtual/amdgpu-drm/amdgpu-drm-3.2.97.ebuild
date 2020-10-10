# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Virtual for the amdgpu DRM (Direct Rendering Manager) kernel module"
KEYWORDS="amd64 x86"
IUSE="amdgpu-dkms dkms +firmware kernel rock-dkms"
AMDGPU_DKMS_PV="20.40.1147287"
ROCK_DKMS_PV="3.8"
VANILLA_KERNEL_PV="9999" # >=${PV} not released yet.  Currently 5.9 is 3.2.95
LINUX_FIRMWARE_PV="20201005" # matches last commit/tag AMDGPU_DKMS_PV in linux-firmware git
# Find the timestamp at https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/log/amdgpu
RDEPEND="amdgpu-dkms? ( >=sys-kernel/amdgpu-dkms-${AMDGPU_DKMS_PV} )
	 rock-dkms? ( >=sys-kernel/rock-dkms-${ROCK_DKMS_PV} )
	 firmware? (
		|| (
			amdgpu-dkms? ( >=sys-firmware/amdgpu-firmware-${AMDGPU_DKMS_PV} )
			rock-dkms? ( >=sys-firmware/rock-firmware-${ROCK_DKMS_PV} )
			!amdgpu-dkms? (
				!rock-dkms? (
					>=sys-kernel/linux-firmware-${LINUX_FIRMWARE_PV}
				)
			)
		)
	 )"
REQUIRED_USE="^^ ( amdgpu-dkms kernel rock-dkms )
	amdgpu-dkms? ( dkms )
	dkms? ( ^^ ( amdgpu-dkms rock-dkms ) )
	rock-dkms? ( dkms )"
SLOT="0/${PV}" # based on DC_VER, rock-dkms will not be an exact fit

pkg_setup() {
	ewarn "The linux-firmware git logs currently doesn't indicate 20.20 firmware yet as of 20200614"
	if use amdgpu-dkms || use rock-dkms ; then
		:;
	else
		if [[ ! -f "${EROOT}/usr/src/linux/drivers/gpu/drm/amd/display/dc/dc.h" ]] ; then
			die "Cannot find /usr/src/linux/drivers/gpu/drm/amd/display/dc/dc.h"
		fi
		DC_VER=$(grep "DC_VER" "${EROOT}/usr/src/linux/drivers/gpu/drm/amd/display/dc/dc.h" | cut -f 3 -d " " | sed -e "s|\"||g")
		if ver_test ${DC_VER} -lt ${PV} ; then
			die "Your DC_VER is old.  Your kernel needs to be at least ${VANILLA_KERNEL_PV} or DC_VER needs to be ${PV}."
		fi
	fi
}
