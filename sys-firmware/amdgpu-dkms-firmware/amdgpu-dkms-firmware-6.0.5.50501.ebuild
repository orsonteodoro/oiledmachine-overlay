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
IUSE="r1"
REQUIRED_USE="
"
DRIVER_PV="5.5.1"
ROCM_PV="5.5.1"
MY_PV="6.0.5.50501-1593694" # The 4th component is the rock version 5.05.01 == 5.5.1.
DEB_OS_REL="22.04"
FN="amdgpu-dkms-firmware_${MY_PV}.${DEB_OS_REL}_all.deb"
SRC_URI="
https://repo.radeon.com/amdgpu/${DRIVER_PV}/ubuntu/pool/main/a/amdgpu-dkms/${FN}
"
# Update also https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/rocm-5.5.1/drivers/gpu/drm/amd/amdgpu/amdgpu_cgs.c
# The above file is used to obtain CONFIG_EXTRA_FIRMWARE.
S="${WORKDIR}"

pkg_setup() {
	has_version "sys-kernel/linux-firmware" || return
	local bv=$(best_version "sys-kernel/linux-firmware" \
		| sed -e "s|sys-kernel/linux-firmware-||")
	local last_cfg="linux-firmware-${bv}"

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
	local ma
	for ma in ${MA[@]} ; do
		F=(
			$(ls ${ma}_*)
		)

		PKG_POSTINST_LIST+=" \e[1m\e[92m*\e[0m ${ma}:\t${F[@]/#/amdgpu/}\n"
	done
}

gen_ma() {
	# MA = microarches
	local _MA=$(ls *)

	local ma
	for ma in ${_MA[@]} ; do
		if [[ "${ma}" =~ "_ce.bin" ]] ; then
			MA+=(
				"${ma%_*}"
			)
		elif [[ "${ma}" =~ "_me.bin" ]] ; then
			MA+=(
				"${ma%_*}"
			)
		elif [[ "${ma}" =~ "_"(32|k)"_mc.bin" ]] ; then
			MA+=(
				$(echo "${ma}" \
					| sed -r -e "s#_(32|k)_mc\.bin##g")
			)
		elif [[ "${ma}" =~ "_mc.bin" ]] ; then
			MA+=(
				"${ma%_*}"
			)
		elif [[ "${ma}" =~ "_vcn.bin" ]] ; then
			MA+=(
				"${ma%_*}"
			)
		elif [[ "${ma}" =~ "_"(acg|k|k2)"_smc.bin" ]] ; then
			MA+=(
				$(echo "${ma}" \
					| sed -r -e "s#_(acg|k|k2)_smc\.bin##g")
			)
		elif [[ "${ma}" =~ "_k_"[0-9]"_smc.bin" ]] ; then
			MA+=(
				$(echo "${ma}" \
					| sed -e "s#_k_[0-9]_smc\.bin##g")
			)
		elif [[ "${ma}" =~ "_smc.bin" ]] ; then
			MA+=(
				$(echo "${ma}" \
					| sed -e "s|_smc\.bin||g")
			)
		fi
	done
	local MA=(
		$(echo ${MA[@]} \
			| tr " " "\n" \
			| sort \
			| uniq)
	)
	echo ${MA[@]}
}

pkg_preinst() {
	cd "${S}" || die

	local MA=(
		$(gen_ma)
	)

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
