# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Radeon Open Compute (ROCk) firmware"
HOMEPAGE="https://rocm.github.io/"
LICENSE="AMDGPU-FIRMWARE RADEON-FIRMWARE"
# LICENSE.ucode mentioned at
#   https://rocm-documentation.readthedocs.io/en/latest/Installation_Guide/ROCK-Kernel-Driver_readme.html
# License found at:
#   https://github.com/HSAFoundation/HSA-Drivers-Linux-AMD/blob/master/LICENSE.ucode
# Same as:
#   https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/LICENSE.amdgpu
# The documentation may be outdated and the following license may apply:
#   https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/LICENSE.radeon
# See also mentioning the difference in firmware
#   https://github.com/RadeonOpenCompute/ROCm#rocm-support-in-upstream-linux-kernels
KEYWORDS="~amd64"
REV=$(ver_cut 5 ${PV})
PV_MAJOR_MINOR=$(ver_cut 1-2 ${PV})
ROCK_VER=$(ver_cut 1-3 ${PV})
SUFFIX="${PV_MAJOR_MINOR}-${REV}"
FN="rock-dkms_${SUFFIX}_all.deb"
BASE_URL="http://repo.radeon.com/rocm/apt/${ROCK_VER}/"
FOLDER="pool/main/r/rock-dkms/"
RDEPEND="!sys-firmware/amdgpu-firmware"
RESTRICT="fetch"
SLOT="0/${PV}"
inherit unpacker
SRC_URI="${BASE_URL}${FOLDER}/${FN}"
S="${WORKDIR}"

pkg_nofetch() {
        local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
        einfo "Please download"
        einfo "  - ${FN}"
        einfo "from ${BASE_URL} in the ${FOLDER} folder and place them in"
	einfo "${distdir}"
}

pkg_setup() {
	local last_cfg=$(ls \
		/etc/portage/savedconfig/sys-kernel/linux-firmware* \
		| sort | tail -n 1)

	if [[ ! -f /etc/portage/savedconfig/sys-kernel/${last_cfg} ]]
	then
		last_cfg="linux-firmware-20200122"
	fi

	ewarn \
"/lib/firmware/{amdgpu,radeon} folders should not be present.  Make sure that\n\
the savedconfig USE flag is set in the linux-firmware package.\n\
  Do something like\n\
  \`sed -i -e \"s|^amdgpu|#amdgpu|g\" -e \"s|^radeon|#radeon|g\" \
/etc/portage/savedconfig/sys-kernel/${last_cfg}\`\n\
Then, remerge linux-firmware again.  If you emerged rock-firmware or\n\
amdgpu-firmware, unemerge them completely.
For futher details, see\n\
  https://wiki.gentoo.org/wiki/Linux_firmware#Savedconfig"
}

src_unpack() {
	unpack_deb ${A}
}

src_configure() {
	:;
}

src_compile() {
	:;
}

PKG_POSTINST_LIST=""
PKG_RADEON_LIST=""

_gen_firmware_list() {
	local module="${1}"
	cd "${S}/usr/src/amdgpu-${SUFFIX}/firmware/${module}" || die
	MA=$(ls * | cut -f1 -d"_" | uniq | tr "\n" " ")

	for ma in ${MA} ; do
		F=($(ls ${ma}*))
		PKG_POSTINST_LIST+=" \e[1m\e[92m*\e[0m ${ma}:\t${F[@]/#/${module}/}\n"
	done

}

pkg_preinst() {
	_gen_firmware_list "amdgpu"
	_gen_firmware_list "radeon"

	F=$(grep -r -e "radeon/" "${S}/usr/src/amdgpu-${SUFFIX}/amd/amdgpu/amdgpu_cgs.c" \
		| sed -e "s|.*\"radeon|radeon|" -e "s|.bin.*|.bin|")
	# typeset -p F # pickler if needed
	declare -A L
	for f in ${F} ; do
		cn=$(echo "${f}" | cut -f 2 -d "/" | cut -f 1 -d "_")
		if [[ -v "L[${cn}]" ]] ; then
			L[${cn}]+=" ${f}"
		else
			L[${cn}]="${f}"
		fi
	done

	for cn in ${!L[@]} ; do
		if [[ "${cn}" == "hainan" || "${cn}" == "tahiti" ]] ; then
			PKG_RADEON_LIST+=" \e[1m\e[92m*\e[0m ${cn}:\t${L[${cn}]}\n"
		fi
	done
}

src_install() {
	insinto /lib/firmware
	doins -r usr/src/amdgpu-${SUFFIX}/firmware/{radeon,amdgpu}
	docinto licenses
	dodoc "${FILESDIR}"/{LICENSE.amdgpu,LICENSE.radeon}
	# The archives should contain license files but don't.
}

pkg_postinst() {
	einfo "Please update your CONFIG_EXTRA_FIRMWARE of your kernel .config file with one the following:"
	einfo
	echo -e "${PKG_POSTINST_LIST}"
	einfo
	einfo "Additional firmware in the sys-kernel/linux-firmware package is required by rock-dkms for these codenames and should be added to CONFIG_EXTRA_FIRMWARE:"
	einfo
	echo -e "${PKG_RADEON_LIST}"
	einfo
	einfo "The firmware requirements may change if the ROCk DKMS driver is updated."
}
