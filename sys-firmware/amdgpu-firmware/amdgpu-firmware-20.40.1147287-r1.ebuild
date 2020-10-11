# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="AMDGPU firmware"
HOMEPAGE=\
"https://www.amd.com/en/support/kb/release-notes/rn-amdgpu-unified-linux-20-40"
LICENSE="AMDGPU-FIRMWARE"
# See the rock-firmware package for details.
KEYWORDS="~amd64"
PKG_VER=$(ver_cut 1-2 ${PV})
PKG_VER_MAJ=$(ver_cut 1 ${PV})
PKG_REV=$(ver_cut 3)
PKG_ARCH="ubuntu"
PKG_ARCH_VER="18.04"
PKG_VER_STRING=${PKG_VER}-${PKG_REV}
PKG_VER_STRING_DIR=${PKG_VER}-${PKG_REV}-${PKG_ARCH}-${PKG_ARCH_VER}
FN="amdgpu-pro-${PKG_VER_STRING}-${PKG_ARCH}-${PKG_ARCH_VER}.tar.xz"
FIRMWARE_VER="5.6.14.224-1147287"
RESTRICT="fetch"
RDEPEND="!sys-firmware/rock-firmware"
SLOT="0/${PV}"
inherit unpacker
SRC_URI="https://www2.ati.com/drivers/linux/${PKG_ARCH}/${FN}"
S="${WORKDIR}"

pkg_nofetch() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	einfo "Please download"
	einfo "  - ${FN}"
	einfo "from ${HOMEPAGE} and place them in ${distdir}"
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
"/lib/firmware/amdgpu folders must not be present.  Make sure that\n\
the savedconfig USE flag is set in the linux-firmware package.\n\
  Do something like\n\
  \`sed -i -e \"s|^amdgpu|#amdgpu|g\" \
/etc/portage/savedconfig/sys-kernel/${last_cfg}\`\n\
Then, remerge linux-firmware again.  If you emerged rock-firmware or\n\
amdgpu-firmware, unemerge them completely.
For futher details, see\n\
  https://wiki.gentoo.org/wiki/Linux_firmware#Savedconfig"
}

unpack_deb() {
	echo ">>> Unpacking ${1##*/} to ${PWD}"
	unpack $1
	unpacker ./data.tar*
	rm -f debian-binary {control,data}.tar*
}

src_unpack() {
	default
	unpack_deb \
"amdgpu-pro-${PKG_VER_STRING_DIR}/amdgpu-dkms_${FIRMWARE_VER}_all.deb"
	unpack_deb \
"amdgpu-pro-${PKG_VER_STRING_DIR}/amdgpu-dkms-firmware_${FIRMWARE_VER}_all.deb"
	export S="${WORKDIR}/usr/src/amdgpu-${FIRMWARE_VER}"
}

src_configure() {
	:;
}

src_compile() {
	:;
}

PKG_POSTINST_LIST=""
PKG_RADEON_LIST=""

pkg_preinst() {
	cd "${S}/firmware/amdgpu" || die
	MA=$(ls * | cut -f1 -d"_" | uniq | tr "\n" " ")

	for ma in ${MA} ; do
		F=($(ls ${ma}*))
		PKG_POSTINST_LIST+=" \e[1m\e[92m*\e[0m ${ma}:\t${F[@]/#/amdgpu/}\n"
	done

	F=$(grep -r -e "radeon/" "${S}/amd/amdgpu/amdgpu_cgs.c" | sed -e "s|.*\"radeon|radeon|" -e "s|.bin.*|.bin|")
	#typeset -p F # pickler if needed
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
		PKG_RADEON_LIST+=" \e[1m\e[92m*\e[0m ${cn}:\t${L[${cn}]}\n"
	done
}

src_install() {
	insinto /lib/firmware
	doins -r firmware/amdgpu
	pushd "${WORKDIR}"/usr/share/doc || die
		L=$(find . -name "copyright" -print0 |  xargs -0 dirname {} | sed -r -e "s|.[\/]?||" | tail -n +2)
		for d in $L ; do
			docinto licenses/${d}
			dodoc ${d}/copyright
		done
	popd
	docinto licenses
	local d_insdoc="${WORKDIR}/amdgpu-pro-${PKG_VER}-${PKG_REV}-${PKG_ARCH}-${PKG_ARCH_VER}/doc"
	dodoc "${d_insdoc}"/copyright
	dodoc "${FILESDIR}"/LICENSE.amdgpu
}

pkg_postinst() {
	einfo "Please update your CONFIG_EXTRA_FIRMWARE of your kernel .config file with one the following:"
	einfo
	echo -e "${PKG_POSTINST_LIST}"
	einfo
	einfo "Additional firmware in the sys-kernel/linux-firmware package is required by amdgpu-dkms for these codenames and should be added to CONFIG_EXTRA_FIRMWARE:"
	einfo
	echo -e "${PKG_RADEON_LIST}"
	einfo
	einfo "The firmware requirements may change if the amdgpu DKMS driver is updated."
}
