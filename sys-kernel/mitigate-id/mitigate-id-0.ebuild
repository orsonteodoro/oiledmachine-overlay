# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit mitigate-id toolchain-funcs

KERNEL_DRIVER_MLX5="5.17"
KERNEL_DRIVER_DRM_AMDGPU="6.10"
KERNEL_DRIVER_DRM_I915="6.2"
KERNEL_DRIVER_DRM_NOUVEAU="5.9"
KERNEL_DRIVER_DRM_VMWGFX="5.17"

# Add RDEPEND+=" sys-kernel/mitigate-id" to downstream package if the downstream ebuild uses:
# JavaScript
# WebAssembly
# Keychains
# Passwords
# Digital currency wallets
# Databases that that typically store sensitive data

# It is used to mitigate against cross process exfiltration.

S="${WORKDIR}"

DESCRIPTION="Enforce Information Disclosure mitigations"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~s390 ~x86"
VIDEO_CARDS=(
	video_cards_amdgpu
	video_cards_intel
	video_cards_nouveau
	video_cards_nvidia
	video_cards_vmware
)
IUSE="
${VIDEO_CARDS[@]}
mlx5
"
# CE - Code Execution
# DoS - Denial of Service (CVSS A:H)
# DT - Data Tampering (CVSS I:H)
# EP - Escalation of Privileges
# ID - Information Disclosure (CVSS C:H)

#
# The latest to near past vulnerabilities are reported below.
#
# mlx5? https://nvd.nist.gov/vuln/detail/CVE-2022-48858 # DoS, DT, ID
# video_cargs_amdgpu? https://nvd.nist.gov/vuln/detail/CVE-2024-42228 # # DoS, DT, ID
# video_cards_intel? https://nvd.nist.gov/vuln/detail/CVE-2024-41092 # DoS, ID
# video_cards_nouveau? https://nvd.nist.gov/vuln/detail/CVE-2023-0030 # PE, ID, DoS, DT.  Fixed in >= 5.0.
# video_cards_nouveau? https://nvd.nist.gov/vuln/detail/CVE-2021-20292 # PE, CE, ID, DoS, DT.  Fixed in >= 5.9.
# video_cards_nvidia? https://nvidia.custhelp.com/app/answers/detail/a_id/5551 # DoS, ID, DT, CE, EP
# video_cards_vmware? https://nvd.nist.gov/vuln/detail/CVE-2022-22942 # EP, DoS, DT, ID
#

#
# For Spectre v1, v2 mitigations, see https://nvidia.custhelp.com/app/answers/detail/a_id/4611
# It needs >=x11-drivers/nvidia-drivers-390.31 for V1, V2 mitigation.
# Now, we have these recent past drivers with vulnerabilities of the same class.
#
# Usually stable versions get security checked.
# The betas and dev versions usually do not get security reports, so we prune
# those.  The other reason why we prune them is because they may leak sensitive
# debug info (ID) in plain text.
#
RDEPEND="
	${MITIGATE_ID_RDEPEND}
	video_cards_amdgpu? (
		!custom-kernel? (
			$(gen_patched_kernel_list ${KERNEL_DRIVER_DRM_AMDGPU})
		)
	)
	video_cards_intel? (
		!custom-kernel? (
			$(gen_patched_kernel_list ${KERNEL_DRIVER_DRM_I915})
		)
	)
	video_cards_nouveau? (
		!custom-kernel? (
			$(gen_patched_kernel_list ${KERNEL_DRIVER_DRM_NOUVEAU})
		)
	)
	video_cards_nvidia? (
		|| (
			>=x11-drivers/nvidia-drivers-550.90.07:0/550
			>=x11-drivers/nvidia-drivers-535.183.01:0/535
			>=x11-drivers/nvidia-drivers-470.256.02:0/470
		)
	)
	video_cards_vmware? (
		!custom-kernel? (
			$(gen_patched_kernel_list ${KERNEL_DRIVER_DRM_VMWGFX})
		)
	)
"
BDEPEND="
	sys-apps/util-linux
"

check_kernel_version() {
	local kv="${1}"
	local driver_name="${2}"
	if ! tc-is-cross-compiler && use custom-kernel ; then
		local required_version="${kv}"
einfo "The required Linux Kernel version is >= ${required_version} for ${driver_name} driver."
		local prev_kernel_dir="${KERNEL_DIR}"
		local L=(
			$(grep -l "EXTRAVERSION" $(ls "/usr/src/"*"/Makefile"))
		)
		local x
		for x in ${L[@]} ; do
			unset KV_FULL
			local pv_major=$(grep "VERSION =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
			local pv_minor=$(grep "PATCHLEVEL =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
			local pv_patch=$(grep "SUBLEVEL =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
			local pv_extraversion=$(grep "EXTRAVERSION =" "${x}" | head -n 1 | cut -f 2 -d "=" | sed -E -e "s|[ ]+||g")
	# linux-info's get_version() is spammy.
			if ver_test "${pv_major}.${pv_minor}" -lt "${required_version}" ; then
ewarn "${pv_major}.${pv_minor}.${pv_patch}${pv_extraversion} does not have mitigations and should be deleted."
			else
einfo "${pv_major}.${pv_minor}.${pv_patch}${pv_extraversion} has mitigations."
			fi
		done
	fi
}

check_drivers() {
	use custom-drivers || return
	if use mlx5 ; then
		check_kernel_version "${KERNEL_DRIVER_MLX5}" "mlx5 network"
	fi
	if use video_cards_amdgpu ; then
		check_kernel_version "${KERNEL_DRIVER_DRM_AMDGPU}" "amdgpu video"
	fi
	if use video_cards_intel ; then
		check_kernel_version "${KERNEL_DRIVER_DRM_I915}" "i915 video"
	fi
	if use video_cards_vmware ; then
		check_kernel_version "${KERNEL_DRIVER_DRM_VMWGFX}" "vmwgfx video"
	fi
}

pkg_setup() {
	mitigate-id_pkg_setup
ewarn "This ebuild is a Work In Progress (WIP) and may be renamed."
	check_drivers
}

# Unconditionally check
src_compile() {
	tc-is-cross-compiler && return
einfo "Checking for mitigations against Information Disclosure based Transient Execution Vulnerabilities (e.g. Meltdown/Spectre)"
	if lscpu | grep -q "Vulnerable" ; then
eerror "FAIL:  Detected an unmitigated CPU vulnerability."
eerror "Fix issues to continue."
		lscpu
		die
	else
einfo "PASS"
	fi
}
