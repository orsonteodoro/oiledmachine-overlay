# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Firmware blobs used by amdgpu driver in DKMS format"
HOMEPAGE="
https://www.amd.com/en/support/linux-drivers
"
LICENSE="AMDGPU-FIRMWARE-2020"
KEYWORDS="~amd64"
RDEPEND="
	!sys-firmware/rock-firmware
"
SLOT="0/${PV}"
inherit unpacker
IUSE=""
REQUIRED_USE="
"
DRIVER_PV="5.6"
ROCM_PV="5.6.0"
MY_PV="6.1.5.50600-1609671"  # The 4th component is the rock version 5.06.00 == 5.6.0.
DEB_OS_REL="22.04"
FN="amdgpu-dkms-firmware_${MY_PV}.${DEB_OS_REL}_all.deb"
SRC_URI="
https://repo.radeon.com/amdgpu/${DRIVER_PV}/ubuntu/pool/main/a/amdgpu-dkms/${FN}
"
# Update also https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/rocm-5.6.0/drivers/gpu/drm/amd/amdgpu/amdgpu_cgs.c
# The above file is used to obtain CONFIG_EXTRA_FIRMWARE.
S="${WORKDIR}"

pkg_setup() {
	local last_cfg=$(ls \
		/etc/portage/savedconfig/sys-kernel/linux-firmware* \
		| sort \
		| tail -n 1)

	if [[ ! -f /etc/portage/savedconfig/sys-kernel/${last_cfg} ]]
	then
		last_cfg="linux-firmware-20230625"
	fi

ewarn
ewarn "/lib/firmware/amdgpu folders must not be present in order to prevent a"
ewarn "merge conflict.  Make sure that the savedconfig USE flag is set in the"
ewarn "linux-firmware package."
ewarn
ewarn "Do something like:"
ewarn
ewarn "  sed -i -e \"s|^amdgpu|#amdgpu|g\" /etc/portage/savedconfig/sys-kernel/${last_cfg}"
ewarn
ewarn "Then, remerge linux-firmware again.  If you emerged rock-firmware or"
ewarn "amdgpu-firmware, unemerge them completely."
ewarn
ewarn "For futher details, see"
ewarn
ewarn "  https://wiki.gentoo.org/wiki/Linux_firmware#Savedconfig"
ewarn
}

unpack_deb() {
	echo ">>> Unpacking ${1##*/} to ${PWD}"
	unpack $1
	unpacker ./data.tar*
	rm -f debian-binary {control,data}.tar*
}

src_unpack() {
	default
	unpack_deb "${DISTDIR}/${FN}"
	export S="${WORKDIR}/lib/firmware/updates/amdgpu"
}

src_configure() {
	:;
}

src_compile() {
	:;
}

PKG_POSTINST_LIST=""
PKG_RADEON_LIST=""

gen_radeon_list() {
	local F=$(grep -r \
		-e "radeon/" \
		"${FILESDIR}/${ROCM_PV}/amdgpu_cgs.c" \
		| sed \
			-e "s|.*\"radeon|radeon|" \
			-e "s|.bin.*|.bin|")
	#typeset -p F # pickler if needed
	declare -A L
	for f in ${F} ; do
		cn=$(echo "${f}" \
			| cut -f 2 -d "/" \
			| cut -f 1 -d "_")
		if [[ -v "L[${cn}]" ]] ; then
			L[${cn}]+=" ${f}"
		else
			L[${cn}]="${f}"
		fi
	done

	local cn
	for cn in ${!L[@]} ; do
		PKG_RADEON_LIST+=" \e[1m\e[92m*\e[0m ${cn}:\t${L[${cn}]}\n"
	done
}

gen_all_list() {
	local _ma
	local ma
	for _ma in ${MA} ; do
		# Corrections
		if [[ "${_ma}" == "beige" ]] ; then
			ma="beige_goby"
		elif [[ "${_ma}" == "cyan" ]] ; then
			ma="cyan_skillfish2"
		elif [[ "${_ma}" == "dimgrey" ]] ; then
			ma="dimgrey_cavefish"
		elif [[ "${_ma}" == "green" ]] ; then
			ma="green_sardine"
		elif [[ "${_ma}" == "navy" ]] ; then
			ma="navy_flounder"
		elif [[ "${_ma}" == "sienna" ]] ; then
			ma="sienna_cichlid"
		elif [[ "${_ma}" == "yellow" ]] ; then
			ma="yellow_carp"
		else
			ma="${_ma}"
		fi

		F=(
			$(ls ${ma}_*)
		)

		PKG_POSTINST_LIST+=" \e[1m\e[92m*\e[0m ${ma}:\t${F[@]/#/amdgpu/}\n"
	done
}

pkg_preinst() {
	cd "${S}" || die
	# MA = microarches
	local MA=$(ls * \
		| cut -f1 -d"_" \
		| uniq \
		| tr "\n" " ")

	gen_all_list
	gen_radeon_list
}

src_install() {
	insinto /lib/firmware/amdgpu
	doins -r *
	docinto licenses
	cd "${WORKDIR}/usr/share/doc/amdgpu-dkms-firmware" || die
	dodoc "copyright"
	dodoc "LICENSE"
}

pkg_postinst() {
einfo
einfo "Please update your CONFIG_EXTRA_FIRMWARE of your kernel .config file"
einfo "with one the following:"
einfo
	echo -e "${PKG_POSTINST_LIST}"
einfo
einfo "Additional firmware in the sys-kernel/linux-firmware package is"
einfo "required by amdgpu-dkms for these codenames and should be added to"
einfo "CONFIG_EXTRA_FIRMWARE:"
einfo
	echo -e "${PKG_RADEON_LIST}"
	einfo
einfo
einfo "The firmware requirements may change if the amdgpu DKMS driver is"
einfo "updated."
einfo
}
