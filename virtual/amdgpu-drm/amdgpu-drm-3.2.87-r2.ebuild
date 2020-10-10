# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Virtual for the amdgpu DRM (Direct Rendering Manager) kernel module"
KEYWORDS="amd64 x86"
IUSE="amdgpu-dkms dkms +firmware kernel rock-dkms strict-pairing"
AMDGPU_DKMS_PV="20.30" # DC_VER = 3.2.87
ROCK_DKMS_PV="3.6_beta" # DC_VER = 3.2.87
VANILLA_KERNEL_PV="5.9_rc1" # DC_VER = 3.2.95
LINUX_FIRMWARE_PV_MIN="20200807" # matches last commit/tag AMDGPU_DKMS_PV in linux-firmware git
LINUX_FIRMWARE_PV_MAX="20200824"
# Find the timestamp at https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/log/amdgpu
RDEPEND="strict-pairing? (
		 amdgpu-dkms? ( =sys-kernel/amdgpu-dkms-${AMDGPU_DKMS_PV}* )
		 rock-dkms? ( =sys-kernel/rock-dkms-${ROCK_DKMS_PV}* )
		 firmware? (
				|| (
					amdgpu-dkms? ( =sys-firmware/amdgpu-firmware-${AMDGPU_DKMS_PV}* )
					rock-dkms? ( =sys-firmware/rock-firmware-${ROCK_DKMS_PV}* )
					!amdgpu-dkms? (
						!rock-dkms? (
							>=sys-kernel/linux-firmware-${LINUX_FIRMWARE_PV_MIN}
							<=sys-kernel/linux-firmware-${LINUX_FIRMWARE_PV_MAX}
						)
					)
				)
		)
	 )
	 !strict-pairing? (
		 amdgpu-dkms? ( >=sys-kernel/amdgpu-dkms-${AMDGPU_DKMS_PV} )
		 rock-dkms? ( >=sys-kernel/rock-dkms-${ROCK_DKMS_PV} )
		 firmware? (
				|| (
					amdgpu-dkms? ( >=sys-firmware/amdgpu-firmware-${AMDGPU_DKMS_PV} )
					rock-dkms? ( >=sys-firmware/rock-firmware-${ROCK_DKMS_PV} )
					!amdgpu-dkms? (
						!rock-dkms? (
							>=sys-kernel/linux-firmware-${LINUX_FIRMWARE_PV_MIN}
						)
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

pkg_postinst() {
	if use firmware ; then
		if use !amdgpu-dkms && use !rock-dkms ; then
			einfo "For the latest navi10 and navi10 updates, you need =sys-kernel/linux-firmware-${LINUX_FIRMWARE_PV_MAX}"
		fi
	fi
}
