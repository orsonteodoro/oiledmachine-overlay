# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="30.30.4.0.30300400-2341068"

DRIVER_PV="30.30.4" # Folder name
PKG_POSTINST_LIST="" # Global var
PKG_RADEON_LIST="" # Global var
ROCM_PV="7.2.4"
ROCM_SLOT="${ROCM_PV%.*}"
U_OS_REL="24.04" # Must place before FN

FN="amdgpu-dkms-firmware_${MY_PV}.${U_OS_REL}_all.deb"

KV_LTS_LIST=(
# See https://github.com/ROCm/rocm-install-on-linux/blob/rocm-7.2.0/docs/reference/system-requirements.rst#supported-operating-systems
	"5.15"
	"6.1"
	"6.12"
)

inherit unpacker

KEYWORDS="~amd64"
S="${WORKDIR}"
SRC_URI="
https://repo.radeon.com/amdgpu/${DRIVER_PV}/ubuntu/pool/main/a/amdgpu-dkms-firmware/${FN}
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
SLOT="0/${ROCM_SLOT}"
IUSE="
si
ebuild_revision_11
"
REQUIRED_USE="
"
RDEPEND="
	!sys-firmware/rock-firmware
"

unpack_deb() {
	echo ">>> Unpacking ${1##*/} to ${PWD}"
	unpack "${1}"
	unpacker "./data.tar"*
	rm -f "debian-binary" {"control","data"}".tar"*
}

src_unpack() {
	default
	unpack_deb "${DISTDIR}/${FN}"
	export S="${WORKDIR}/lib/firmware/updates/amdgpu"
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
	local F=$(grep \
			-r \
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
			L["${cn}"]+=" ${f}"
		else
			L["${cn}"]="${f}"
		fi
	done

	local cn
	for cn in "${!L[@]}" ; do
		PKG_RADEON_LIST+=" \e[1m\e[92m*\e[0m ${cn}:  ${L[${cn}]}\n"
	done
}

gen_all_list() {
	local ma
	for ma in "${MA[@]}" ; do
		ls -1 "${ma}"* >/dev/null 2>&1 || die "Cannot find ${ma} prefix in ${S}"
		F=(
			$(ls -1 "${ma}"*)
		)

		PKG_POSTINST_LIST+=" \e[1m\e[92m*\e[0m ${ma}:  ${F[@]/#/amdgpu/}\n"
	done
}

gen_microarch_list() {
	# MA = microarches
	local _MA=( $(ls *) )

	local suffix_list=(

		"_k_0_mc.bin"
		"_k_2_smc.bin"

		"_32_mc.bin"
		"_acg_smc.bin"
		"_agc_smc.bin"
		"_asd.bin"
		"_ce_2.bin"
		"_ce_wks.bin"
		"_gpu_info.bin"
		"_ip_discovery.bin"
		"_k_mc.bin"
		"_k_smc.bin"
		"_k2_smc.bin"
		"_kicker_rlc.bin"
		"_me_2.bin"
		"_me_wks.bin"
		"_mec_2.bin"
		"_mec_wks.bin"
		"_mec2_2.bin"
		"_mec2_wks.bin"
		"_mes_2.bin"
		"_pfp_2.bin"
		"_pfp_wks.bin"
		"_rlc_1.bin"
		"_rlc_am4.bin"
		"_smc_sk.bin"
		"_sjt_mec.bin"
		"_sjt_mec2.bin"
		"_imu_kicker.bin"
		"_rlc_kicker.bin"
		"_sdma1.bin"
		"_smc_sk.bin"
		"_sos_kicker.bin"
		"_ta_kicker.bin"
		"_uni_mes.bin"

		"_cap.bin"
		"_ce.bin"
		"_dmcu.bin"
		"_dmcub.bin"
		"_imu.bin"
		"_kicker.bin"
		"_mc.bin"
		"_me.bin"
		"_mec.bin"
		"_mec2.bin"
		"_mes.bin"
		"_mes1.bin"
		"_pfp.bin"
		"_rlc.bin"
		"_sdma.bin"
		"_smc.bin"
		"_sos.bin"
		"_ta.bin"
		"_toc.bin"
		"_uvd.bin"
		"_vce.bin"
		"_vcn.bin"

		".bin"
	)

	local MA1=()
	local ma
	for ma in "${_MA[@]}" ; do
		[[ "${ma}" =~ ".bin"$ ]] || continue
		local suffix
		for suffix in "${suffix_list[@]}" ; do
			if [[ "${ma}" =~ "${suffix}" ]] ; then
				local t=$(echo "${ma}" | sed -e "s|${suffix}||g")
#einfo "Added |${t}| from |${ma}| removing |${suffix}|"
				MA1+=(
					"${t}"
				)
				break
			fi
		done
	done

	# Sort and dedupe
	local MA2=(
		$(echo "${MA1[@]}" \
			| tr " " $'\n' \
			| sort \
			| uniq)
	)
	echo "${MA2[@]}"
}

_pre_gen_radeon_list() {
	cd "${S}" || die

	local MA=(
		$(gen_microarch_list)
	)
#einfo "MA:  ${MA[@]}"

	gen_all_list
	use si && gen_radeon_list
}

gen_scripts() {
	dodir "/usr/bin"
cat <<EOF > "${ED}/usr/bin/install-${P}.sh"
#!/bin/bash
echo "Installing ${P} into /lib/firmware/amdgpu"
rm -f "/lib/firmware/amdgpu/"*
mkdir -p "/lib/firmware/amdgpu"
cp -aT "/lib/firmware/amdgpu-${MY_PV%-*}" "/lib/firmware/amdgpu"
EOF

	local kv_slot
	for kv_slot in "${KV_LTS_LIST[@]}" ; do
cat <<EOF > "${ED}/usr/bin/install-${P}-for-rock-kernel-module-slot-${kv_slot}.sh"
#!/bin/bash
echo "Installing ${P} into /lib/firmware/amdgpu"
rm -f "/lib/firmware/amdgpu/"*
mkdir -p "/lib/firmware/amdgpu"
cp -aT "/lib/firmware/amdgpu-${MY_PV%-*}" "/lib/firmware/amdgpu"
EOF
	done

cat <<EOF > "${ED}/usr/bin/install-rocm-firmware-${ROCM_PV}.sh"
#!/bin/bash
echo "Installing ROCm v${ROCM_PV} compatible firmware into /lib/firmware/amdgpu"
rm -f "/lib/firmware/amdgpu/"*
mkdir -p "/lib/firmware/amdgpu"
cp -aT "/lib/firmware/amdgpu-${MY_PV%-*}" "/lib/firmware/amdgpu"
EOF

cat <<EOF > "${ED}/usr/bin/install-rocm-firmware-slot-${ROCM_SLOT}.sh"
#!/bin/bash
echo "Installing ROCm ${ROCM_SLOT} (slot) compatible firmware into /lib/firmware/amdgpu"
rm -f "/lib/firmware/amdgpu/"*
mkdir -p "/lib/firmware/amdgpu"
cp -aT "/lib/firmware/amdgpu-${MY_PV%-*}" "/lib/firmware/amdgpu"
EOF
	fperms "0755" "/usr/bin/install-${P}.sh"
	local kv_slot
	for kv_slot in "${KV_LTS_LIST[@]}" ; do
		fperms "0755" "/usr/bin/install-${P}-for-rock-kernel-module-slot-${kv_slot}.sh"
	done
	fperms "0755" "/usr/bin/install-rocm-firmware-${ROCM_PV}.sh"
	fperms "0755" "/usr/bin/install-rocm-firmware-slot-${ROCM_SLOT}.sh"
}

src_install() {
	insinto "/lib/firmware/amdgpu-${MY_PV%-*}"
	doins -r *
	docinto "licenses"
	cd "${WORKDIR}/usr/share/doc/amdgpu-dkms-firmware" || die
	dodoc "copyright"
	dodoc "LICENSE"
	# Touched files that act like metadata that indicate compatibility.
	touch "${ED}/lib/firmware/amdgpu-${MY_PV%-*}/rocm-version-${ROCM_PV}"
	touch "${ED}/lib/firmware/amdgpu-${MY_PV%-*}/rocm-slot-${ROCM_SLOT}"
	local kv_slot
	for kv_slot in "${KV_LTS_LIST[@]}" ; do
		touch "${ED}/lib/firmware/amdgpu-${MY_PV%-*}/rock-kernel-module-slot-${kv_slot}"
	done
	gen_scripts
	_pre_gen_radeon_list
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
	for kv_slot in "${KV_LTS_LIST[@]}" ; do
einfo "  install-${P}-for-rock-kernel-module-slot-${kv_slot}.sh"
	done
einfo "  install-rocm-firmware-${ROCM_PV}.sh"
einfo "  install-rocm-firmware-slot-${ROCM_SLOT}.sh"
einfo
}
