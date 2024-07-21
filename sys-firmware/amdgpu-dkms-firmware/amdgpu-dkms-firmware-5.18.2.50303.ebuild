# Copyright 1999-2019,2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

U_OS_REL="22.04"
DRIVER_PV="5.3.3" # Folder name
KERNEL_PV="6.0" # Equivalent for vanilla kernel based on DC_VER
KVS=(
# Commented out means EOL kernel.
#	"5.17" # U 22.04 Desktop OEM
	"5.15" # U 22.04 Desktop HWE, 22.04 Server generic
#	"5.14" # S 15.4; R 9.0, 9.1
#	"5.8"  # U 20.04 HWE
	"5.4"  # U 20.04 generic
#	"5.3"  # S 15.3
#	"4.18" # R 8.4, 8.5, 8.6
#	"3.10" # R 7.9
)
MY_PV="5.18.2.22.40.50303"
MY_PV2="${MY_PV}-1504718" # The 6th component is the rock version 5.03.03 == 5.3.3.
MY_PV3="${MY_PV%.*}-1504718.22.04"
PKG_POSTINST_LIST="" # Global var
PKG_RADEON_LIST="" # Global var
ROCM_PV="5.3.3"
ROCM_SLOT="${ROCM_PV%.*}"
FN="amdgpu-dkms-firmware_${MY_PV2}.${U_OS_REL}_all.deb"

inherit unpacker

KEYWORDS="~amd64"
S="${WORKDIR}"
SRC_URI="
https://repo.radeon.com/amdgpu/${DRIVER_PV}/ubuntu/pool/main/a/amdgpu-dkms/${FN}
	si? (
https://raw.githubusercontent.com/RadeonOpenCompute/ROCK-Kernel-Driver/rocm-${ROCM_PV}/drivers/gpu/drm/amd/amdgpu/amdgpu_cgs.c
	-> amdgpu_cgs.c.${ROCM_PV}
	)
"
# The amdgpu_cgs.c file is used to obtain CONFIG_EXTRA_FIRMWARE for Southern Islands (SI).

DESCRIPTION="Firmware blobs used by the amdgpu kernel driver"
HOMEPAGE="
https://www.amd.com/en/support/linux-drivers
"
LICENSE="
	AMDGPU-FIRMWARE-2020
	si? (
		MIT
	)
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="si ebuild-revision-7"
REQUIRED_USE="
"
RDEPEND="
	!sys-firmware/rock-firmware
"

unpack_deb() {
	echo ">>> Unpacking ${1##*/} to ${PWD}"
	unpack $1
	unpacker ./data.tar*
	rm -f debian-binary {control,data}.tar*
}

src_unpack() {
	default
	unpack_deb "${DISTDIR}/${FN}"
	export S="${WORKDIR}/usr/src/amdgpu-${MY_PV3}/firmware/amdgpu"
}

src_configure() {
	:
}

src_compile() {
	:
}

gen_radeon_list() {
	local amdgpu_cgs_path="${DISTDIR}/amdgpu_cgs.c.${ROCM_PV}"
	[[ -e "${amdgpu_cgs_path}" ]] || die "Missing file"
	local F=$(grep -r \
		-e "radeon/" \
		"${amdgpu_cgs_path}" \
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
	use si && gen_radeon_list
}

gen_scripts() {
	dodir /usr/bin
cat <<EOF > "${ED}/usr/bin/install-${P}.sh"
#!/bin/bash
echo "Installing ${P} into /lib/firmware/amdgpu"
rm -f /lib/firmware/amdgpu/*
mkdir -p /lib/firmware/amdgpu
cp -aT /lib/firmware/amdgpu-${MY_PV2%-*} /lib/firmware/amdgpu
EOF

	local kv_slot
	for kv_slot in ${KVS[@]} ; do
cat <<EOF > "${ED}/usr/bin/install-${P}-for-rock-kernel-module-slot-${kv_slot}.sh"
#!/bin/bash
echo "Installing ${P} into /lib/firmware/amdgpu"
rm -f /lib/firmware/amdgpu/*
mkdir -p /lib/firmware/amdgpu
cp -aT /lib/firmware/amdgpu-${MY_PV2%-*} /lib/firmware/amdgpu
EOF
	done

cat <<EOF > "${ED}/usr/bin/install-${P}-for-vanilla-kernel-module-slot-${KERNEL_PV}.sh"
#!/bin/bash
echo "Installing ${P} into /lib/firmware/amdgpu"
rm -f /lib/firmware/amdgpu/*
mkdir -p /lib/firmware/amdgpu
cp -aT /lib/firmware/amdgpu-${MY_PV2%-*} /lib/firmware/amdgpu
EOF

cat <<EOF > "${ED}/usr/bin/install-rocm-firmware-${ROCM_PV}.sh"
#!/bin/bash
echo "Installing ROCm v${ROCM_PV} compatible firmware into /lib/firmware/amdgpu"
rm -f /lib/firmware/amdgpu/*
mkdir -p /lib/firmware/amdgpu
cp -aT /lib/firmware/amdgpu-${MY_PV2%-*} /lib/firmware/amdgpu
EOF

cat <<EOF > "${ED}/usr/bin/install-rocm-firmware-slot-${ROCM_SLOT}.sh"
#!/bin/bash
echo "Installing ROCm ${ROCM_SLOT} (slot) compatible firmware into /lib/firmware/amdgpu"
rm -f /lib/firmware/amdgpu/*
mkdir -p /lib/firmware/amdgpu
cp -aT /lib/firmware/amdgpu-${MY_PV2%-*} /lib/firmware/amdgpu

EOF
	fperms 0755 /usr/bin/install-${P}.sh
	local kv_slot
	for kv_slot in ${KVS[@]} ; do
		fperms 0755 /usr/bin/install-${P}-for-rock-kernel-module-slot-${kv_slot}.sh
	done
	fperms 0755 /usr/bin/install-${P}-for-vanilla-kernel-module-slot-${KERNEL_PV}.sh
	fperms 0755 /usr/bin/install-rocm-firmware-${ROCM_PV}.sh
	fperms 0755 /usr/bin/install-rocm-firmware-slot-${ROCM_SLOT}.sh
}

src_install() {
	insinto /lib/firmware/amdgpu-${MY_PV2%-*}
	doins -r *
	docinto licenses
	cd "${WORKDIR}/usr/share/doc/amdgpu-dkms-firmware" || die
	dodoc "copyright"
	dodoc "LICENSE"
	# Touched files that act like metadata that indicate compatibility.
	touch "${ED}/lib/firmware/amdgpu-${MY_PV2%-*}/rocm-version-${ROCM_PV}"
	touch "${ED}/lib/firmware/amdgpu-${MY_PV2%-*}/rocm-slot-${ROCM_SLOT}"
	local kv_slot
	for kv_slot in ${KVS[@]} ; do
		touch "${ED}/lib/firmware/amdgpu-${MY_PV2%-*}/rock-kernel-module-slot-${kv_slot}"
	done
	touch "${ED}/lib/firmware/amdgpu-${MY_PV2%-*}/vanilla-kernel-module-series-${KERNEL_PV}"
	gen_scripts
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
	if use si ; then
		echo -e "${PKG_RADEON_LIST}"
		einfo
	fi
einfo
einfo "The firmware requirements may change if the amdgpu DKMS driver is"
einfo "updated."
einfo
einfo "Manual install still required.  Use one of these helper scripts to"
einfo "install:"
einfo
einfo "  install-${P}.sh"
	local kv_slot
	for kv_slot in ${KVS[@]} ; do
einfo "  install-${P}-for-rock-kernel-module-slot-${kv_slot}.sh"
	done
einfo "  install-${P}-for-vanilla-kernel-module-slot-${KERNEL_PV}.sh"
einfo "  install-rocm-firmware-${ROCM_PV}.sh"
einfo "  install-rocm-firmware-slot-${ROCM_SLOT}.sh"
einfo
}
