# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LTS_VERSIONS=("4.19" "5.4" "5.10" "5.15" "6.1" "6.6")
ACTIVE_VERSIONS=("4.19" "5.4" "5.10" "5.15" "6.1" "6.6" "6.10" "6.11")
STABLE_OR_MAINLINE_VERSIONS=("6.10" "6.11")
EOL_VERSIONS=(
	"0"
	"1"
	"2"
	"3"
	"4.0" "4.1" "4.2" "4.3" "4.4" "4.5" "4.6" "4.7" "4.8" "4.9" "4.10" "4.11" "4.12" "4.13" "4.14" "4.15" "4.16" "4.17" "4.18" "4.20"
	"5.0" "5.1" "5.2" "5.3" "5.5" "5.6" "5.7" "5.8" "5.9" "5.11" "5.12" "5.13" "5.14" "5.16" "5.17" "5.18" "5.19"
	"6.0" "6.2" "6.3" "6.4" "6.5" "6.7" "6.8" "6.9"
)

# For zero-tolerance mode
MULTISLOT_LATEST_KERNEL_RELEASE=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.111" "6.6.52" "6.10.11" "6.11")

MULTISLOT_KERNEL_DRIVER_IWLWIFI=("4.14.268" "4.19.231" "5.4.181" "5.10.102" "5.15.25" "5.16.11")
MULTISLOT_KERNEL_DRIVER_MLX5=("5.4.185" "5.10.106" "5.15.29" "5.16.15")
MULTISLOT_KERNEL_DRIVER_DRM_AMDGPU=("5.10.226" "5.15.167" "6.1.109" "6.6.50" "6.10.9")
MULTISLOT_KERNEL_DRIVER_DRM_I915=("5.10.211" "5.15.162" "6.1.97" "6.6.37" "6.9.8")
MULTISLOT_KERNEL_DRIVER_DRM_NOUVEAU=("5.0.21" "5.4.284")
MULTISLOT_KERNEL_DRIVER_DRM_VMWGFX=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.111" "6.6.52")
MULTISLOT_KERNEL_DRIVER_DRM_XE=("6.10.8")
MULTISLOT_KERNEL_NETFILTER=("5.15" "6.1.107" "6.6.48" "6.10.7")
MULTISLOT_KERNEL_NF_TABLES=("4.19.313" "5.4.275" "5.10.216" "5.15.157" "6.1.88" "6.6.29" "6.8.8")
MULTISLOT_KERNEL_SELINUX=("5.10.99" "5.15.22" "5.16.8")

CVE_DRM_AMDGPU="CVE-2024-46725"
CVE_DRM_I915="CVE-2024-41092"
CVE_DRM_NOUVEAU="CVE-2023-0030"
CVE_DRM_VMWGFX="CVE-2022-22942"
CVE_DRM_XE="CVE-2024-46683"
CVE_IWLWIFI="CVE-2022-48787"
CVE_MLX5="CVE-2022-48858"
CVE_NETFILTER="CVE-2024-44983"
CVE_NF_TABLES="CVE-2024-27020"
CVE_SELINUX="CVE-2022-48740"

inherit mitigate-id toolchain-funcs

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
iwlwifi
mlx5
netfilter
nftables
selinux
"
# CE - Code Execution
# DoS - Denial of Service (CVSS A:H)
# DT - Data Tampering (CVSS I:H)
# ID - Information Disclosure (CVSS C:H)
# PE - Privilege Escalation

#
# In the kernel changelog, you can do a common keywords search of the following
# to look up the formulaic results:
#
# Arbitrary code execution, CVSS 9.8 # DoS, DT, ID
# Buffer overflow, CVSS 6.7 # DoS, DT, ID
# Crash, CVSS 5.5 # DoS
# Data race, CVSS 7.0 # DoS, DT, ID
# Deadlock, CVSS 5.5 # DoS
# Double free # CVSS 7.8 # DoS, DT, ID
# Local privilege escalation, CVSS 7.8 # DoS, DT, ID
# Memory leak, CVSS 5.5 # DoS
# NULL pointer dereference, NPD, CVSS 5.5 # DoS
# Out of bounds read, CVSS 7.1, # DoS, ID
# Out of bounds write, CVSS 7.8, # DoS, ID, DT
# Race condition, CVSS 4.7 # DoS
# ToCToU race, CVSS 7.0 # PE, DoS, DT, ID
# Use after free, use-after-free, UAF, CVSS 7.8 # DoS, DT, ID
#

#
# The latest to near past vulnerabilities are reported below.
#
# iwlwifi? https://nvd.nist.gov/vuln/detail/CVE-2022-48787 # DoS, DT, ID
# mlx5? https://nvd.nist.gov/vuln/detail/CVE-2022-48858 # DoS, DT, ID
# netfilter? https://nvd.nist.gov/vuln/detail/CVE-2024-44983 # DoS, ID
# selinux? https://nvd.nist.gov/vuln/detail/CVE-2022-48740 # DoS, DT, ID
# video_cards_amdgpu? https://nvd.nist.gov/vuln/detail/CVE-2024-46725 # DoS, DT, ID
# video_cards_intel? https://nvd.nist.gov/vuln/detail/CVE-2024-41092 # DoS, ID
# video_cards_nouveau? https://nvd.nist.gov/vuln/detail/CVE-2023-0030 # PE, ID, DoS, DT.  Fixed in >= 5.0.
# video_cards_nouveau? https://nvd.nist.gov/vuln/detail/CVE-2021-20292 # PE, CE, ID, DoS, DT.  Fixed in >= 5.9.
# video_cards_nvidia? https://nvidia.custhelp.com/app/answers/detail/a_id/5551 # DoS, ID, DT, CE, PE
# video_cards_vmware? https://nvd.nist.gov/vuln/detail/CVE-2022-22942 # PE, DoS, DT, ID
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
	!custom-kernel? (
		zero-tolerance? (
			$(gen_zero_tolerance_kernel_list ${MULTISLOT_LATEST_KERNEL_RELEASE[@]})
		)
		$(gen_eol_kernels_list ${MULTISLOT_LATEST_KERNEL_RELEASE[@]})
	)
	mlx5? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_DRIVER_MLX5[@]})
		)
	)
	netfilter? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NETFILTER[@]})
		)
	)
	nftables? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NF_TABLES[@]})
		)
	)
	selinux? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_SELINUX[@]})
		)
	)
	video_cards_amdgpu? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_DRIVER_DRM_AMDGPU[@]})
		)
	)
	video_cards_intel? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_DRIVER_DRM_I915[@]})
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_DRIVER_DRM_XE[@]})
		)
	)
	video_cards_nouveau? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_DRIVER_DRM_NOUVEAU[@]})
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
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_DRIVER_DRM_VMWGFX[@]})
		)
	)
"
BDEPEND="
	sys-apps/util-linux
"

check_kernel_version() {
	local driver_name="${1}"
	shift
	local cve="${1}"
	shift
	local PATCHED_VERSIONS=( ${@} )
	if ! tc-is-cross-compiler && use custom-kernel ; then
		local required_version="${kv}"
		local prev_kernel_dir="${KERNEL_DIR}"
		local FOUND_VERSIONS_MAKEFILES=(
			$(grep -l "EXTRAVERSION" $(ls "/usr/src/"*"/Makefile"))
		)
		local makefile_path
		for makefile_path in ${FOUND_VERSIONS_MAKEFILES[@]} ; do
			unset KV_FULL
			local pv_major=$(grep "VERSION =" "${makefile_path}" | head -n 1 | grep -E -oe "[0-9]+")
			local pv_minor=$(grep "PATCHLEVEL =" "${makefile_path}" | head -n 1 | grep -E -oe "[0-9]+")
			local pv_patch=$(grep "SUBLEVEL =" "${makefile_path}" | head -n 1 | grep -E -oe "[0-9]+")
			local pv_extraversion=$(grep "EXTRAVERSION =" "${makefile_path}" | head -n 1 | cut -f 2 -d "=" | sed -E -e "s|[ ]+||g")
			local found_version="${pv_major}.${pv_minor}.${pv_patch}"
	# linux-info's get_version() is spammy.

			local vulnerable=1

	# Last version of patched versions
			local patched_version=${PATCHED_VERSIONS[-1]}
			if ! is_eol "${found_version}" && ver_test ${found_version} -ge ${patched_version} ; then
				vulnerable=0
			fi

	# Check LTS versions
			local patched_version
			for patched_version in ${PATCHED_VERSIONS[@]} ; do
				if is_lts ${patched_version} ; then
					local s1=$(ver_cut 1-2 ${found_version})
					local s2=$(ver_cut 1-2 ${patched_version})
					if ver_test ${s1} -eq ${s2} && ver_test ${found_version} -ge ${patched_version} ; then
						vulnerable=0
						break
					fi
				fi
			done

			if (( ${vulnerable} == 1 )) ; then
ewarn "${cve}:  not mitigated, component name - ${driver_name}, found version - ${found_version}"
			else
einfo "${cve}:  mitigated, component name - ${driver_name}, found version - ${found_version}"
			fi
		done
		KERNEL_DIR="${prev_kernel_dir}"
	fi
}

check_drivers() {
	# Check for USE=custom-kernels only which bypass RDEPEND
	use custom-kernel || return
	if use iwlwifi ; then
		check_kernel_version "iwlwifi" "${CVE_IWLWIFI}" ${MULTISLOT_KERNEL_DRIVER_IWLWIFI[@]}
	fi
	if use mlx5 ; then
		check_kernel_version "mlx5" "${CVE_MLX5}" ${MULTISLOT_KERNEL_DRIVER_MLX5[@]}
	fi
	if use netfilter ; then
		check_kernel_version "netfilter" "${CVE_NETFILTER}" ${MULTISLOT_KERNEL_NETFILTER[@]}
	fi
	if use nftables ; then
		check_kernel_version "nftables" "${CVE_NF_TABLES}" ${MULTISLOT_KERNEL_NF_TABLES[@]}
	fi
	if use selinux ; then
		check_kernel_version "selinux" "${CVE_SELINUX}" ${MULTISLOT_KERNEL_SELINUX[@]}
	fi
	if use video_cards_amdgpu ; then
		check_kernel_version "amdgpu" "${CVE_DRM_AMDGPU}" ${MULTISLOT_KERNEL_DRIVER_DRM_AMDGPU[@]}
	fi
	if use video_cards_intel ; then
		check_kernel_version "i915" "${CVE_DRM_I915}" ${MULTISLOT_KERNEL_DRIVER_DRM_I915[@]}
		check_kernel_version "xe" "${CVE_DRM_XE}" ${MULTISLOT_KERNEL_DRIVER_DRM_XE[@]}
	fi
	if use video_cards_vmware ; then
		check_kernel_version "vmwgfx" "${CVE_DRM_VMWGFX}" ${MULTISLOT_KERNEL_DRIVER_DRM_VMWGFX[@]}
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

pkg_postinst() {
einfo "The optional sys-kernel/mitigate-dos is also provided and can be emerged directly."
}
