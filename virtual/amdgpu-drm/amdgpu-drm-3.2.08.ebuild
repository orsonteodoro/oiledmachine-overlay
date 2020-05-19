# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Virtual for the amdgpu DRM (Direct Rendering Manager) kernel module"
LICENSE="dkms? ( GPL-2 MIT )
	!dkms? ( GPL-2 MIT )
	firmware? ( AMDGPU-FIRMWARE )"
KEYWORDS="amd64 x86"
IUSE="dkms amdgpu-dkms aufs-sources ck-sources custom-kernel +firmware gentoo-sources \
git-sources hardened-sources ot-sources pf-sources rt-sources rock-dkms \
vanilla-sources xbox-sources zen-sources"
AMDGPU_DKMS_PV="18.50"
ROCK_DKMS_PV="2.0"
VANILLA_KERNEL_PV="5.0"
LINUX_FIRMWARE_PV="20190312" # matches last commit/tag AMDGPU_DKMS_PV in linux-firmware git
RDEPEND="|| (
		!custom-kernel? (
			dkms? ( amdgpu-dkms? ( >=sys-kernel/amdgpu-dkms-${AMDGPU_DKMS_PV} ) )
			aufs-sources? ( >=sys-kernel/aufs-sources-${VANILLA_KERNEL_PV} )
			ck-sources? ( >=sys-kernel/ck-sources-${VANILLA_KERNEL_PV} )
			gentoo-sources? ( >=sys-kernel/gentoo-sources-${VANILLA_KERNEL_PV} )
			git-sources? ( >=sys-kernel/git-sources-${VANILLA_KERNEL_PV} )
			hardened-sources? ( >=sys-kernel/hardened-sources-${VANILLA_KERNEL_PV} )
			ot-sources? ( >=sys-kernel/ot-sources-${VANILLA_KERNEL_PV} )
			pf-sources? ( >=sys-kernel/pf-sources-${VANILLA_KERNEL_PV} )
			dkms? ( rock-dkms? ( >=sys-kernel/rock-dkms-${ROCK_DKMS_PV} ) )
			rt-sources? ( >=sys-kernel/rt-sources-${VANILLA_KERNEL_PV} )
			vanilla-sources? ( >=sys-kernel/vanilla-sources-${VANILLA_KERNEL_PV} )
			zen-sources? ( >=sys-kernel/zen-sources-${VANILLA_KERNEL_PV} )
		)
	 )
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
REQUIRED_USE="^^ ( amdgpu-dkms aufs-sources ck-sources custom-kernel gentoo-sources \
	git-sources hardened-sources ot-sources pf-sources rt-sources rock-dkms \
	vanilla-sources xbox-sources zen-sources )
	dkms? ( ^^ ( amdgpu-dkms rock-dkms ) )"
SLOT="0/${PV}" # based on DC_VER, rock-dkms will not be an exact fit
inherit linux-info

cve_notice() {
        KERNEL_DIR="/usr/src/linux"
        get_version
        linux_config_exists
	if ver_test ${KV_MINOR}.${KV_MINOR}.${KV_PATCH} -le 5.2.14 ; then
		ewarn
		ewarn "CVE advisory:"
		ewarn
		ewarn "CVE-2019-16229 (CVSS 2.0 Medium) : https://nvd.nist.gov/vuln/detail/CVE-2019-16229"
		ewarn
		einfo "It's recommended to use either amdgpu-dkms (>=19.50), rock-dkms (>=3.1), or LTS kernels >= 5.4.x."
	fi
	if ver_test ${KV_MINOR}.${KV_MINOR}.${KV_PATCH} -le 5.3.8 ; then
		ewarn
		ewarn "CVE advisories:"
		ewarn
		ewarn "CVE-2019-19067 (CVSS 2.0 Medium) : https://nvd.nist.gov/vuln/detail/CVE-2019-19067"
		ewarn "CVE-2019-19083 (CVSS 2.0 Medium) : https://nvd.nist.gov/vuln/detail/CVE-2019-19083"
		ewarn
		einfo "It's recommended to use either amdgpu-dkms (>=19.50), rock-dkms (>=3.1), or LTS kernels >= 5.4.x."
	fi
}

pkg_setup() {
	if [[ ! -f "${EROOT}/usr/src/linux/drivers/gpu/drm/amd/display/dc/dc.h" ]] ; then
		die "Cannot find /usr/src/linux/drivers/gpu/drm/amd/display/dc/dc.h"
	fi
	DC_VER=$(grep "DC_VER" "${EROOT}/usr/src/linux/drivers/gpu/drm/amd/display/dc/dc.h" | cut -f 3 -d " " | sed -e "s|\"||g")
	if ver_test ${DC_VER} -lt ${PV} ; then
		die "Your DC_VER is old.  Your kernel needs to be at least ${VANILLA_KERNEL_PV} or DC_VER needs to be ${PV}."
	fi
	cve_notice
}
