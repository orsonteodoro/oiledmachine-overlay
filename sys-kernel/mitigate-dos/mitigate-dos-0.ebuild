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

MULTISLOT_KERNEL_DRIVER_MLX5=("6.1.107" "6.6.48" "6.10.7")
MULTISLOT_KERNEL_DRIVER_DRM_AMDGPU=("5.10.226" "5.15.167" "6.1.109" "6.6.50" "6.10.9")
MULTISLOT_KERNEL_DRIVER_DRM_I915=("5.10.221" "5.15.162" "6.1.97" "6.6.37")
MULTISLOT_KERNEL_DRIVER_DRM_NOUVEAU=("6.6.48" "6.10.7")
MULTISLOT_KERNEL_DRIVER_DRM_RADEON=("5.15.164" "6.1.101" "6.6.42" "6.9.11")
MULTISLOT_KERNEL_DRIVER_DRM_VMWGFX=("6.6.49" "6.9" "6.10.8")

CVE_MLX5="CVE-2024-45019"
CVE_DRM_AMDGPU="CVE-2024-46725"
CVE_DRM_I915="CVE-2024-41092"
CVE_DRM_NOUVEAU="CVE-2024-45012"
CVE_DRM_RADEON="CVE-2024-41060"
CVE_DRM_VMWGFX="CVE-2024-46709"

inherit mitigate-dos toolchain-funcs

# Add RDEPEND+=" sys-kernel/mitigate-dos" to downstream package if the downstream ebuild uses:
# Server
# Web Browser (For test taking, emergency service, voting)
# Network Software

S="${WORKDIR}"

DESCRIPTION="Enforce Denial of Service mitigations"
SLOT="0"
KEYWORDS="~amd64 ~x86"
VIDEO_CARDS=(
	video_cards_amdgpu
	video_cards_intel
	video_cards_nouveau
	video_cards_nvidia
	video_cards_radeon
	video_cards_vmware
)
IUSE="
${VIDEO_CARDS[@]}
mlx5
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
# Crash CVSS, 5.5 # DoS
# Deadlock, CVSS 5.5 # DoS
# Double free # CVSS 7.8 # DoS, DT, ID
# NULL pointer dereference, CVSS 5.5 # DoS
# Out of bounds read, CVSS 7.1, # DoS, ID
# Out of bounds write, CVSS 7.8, # DoS, ID, DT
# Use after free, use-after-free, UAF, CVSS 7.8 # DoS, DT, ID
# Race condition, CVSS 4.7 # DoS
#

#
# The latest to near past vulnerabilities are reported below.
#
# mlx5? https://nvd.nist.gov/vuln/detail/CVE-2024-45019 # DoS
# video_cards_amdgpu? https://nvd.nist.gov/vuln/detail/CVE-2024-46725 # DoS, DT, ID
# video_cards_intel? https://nvd.nist.gov/vuln/detail/CVE-2023-52913 # DoS
# video_cards_intel? https://nvd.nist.gov/vuln/detail/CVE-2024-41092 # DoS, ID
# video_cards_nouveau? https://nvd.nist.gov/vuln/detail/CVE-2024-45012 # DoS; requires >= 6.11 for fix
# video_cards_nouveau? https://nvd.nist.gov/vuln/detail/CVE-2024-42101 # DoS; requires >= 6.10 for fix
# video_cards_nvidia? https://nvidia.custhelp.com/app/answers/detail/a_id/5551 # DoS, ID, DT, CE, PE
# video_cards_radeon? https://nvd.nist.gov/vuln/detail/CVE-2024-41060 # DoS
# video_cards_vmware? https://nvd.nist.gov/vuln/detail/CVE-2024-46709 # DoS
#
# Usually stable versions get security checked.
# The betas and dev versions usually do not get security reports.
#
RDEPEND="
	${MITIGATE_DOS_RDEPEND}
	mlx5? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_DRIVER_MLX5[@]})
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
	video_cards_radeon? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_DRIVER_DRM_RADEON[@]})
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
ewarn "${cve}:  not mitigated, driver name - ${driver_name}, found version - ${found_version}"
			else
einfo "${cve}:  mitigated, driver name - ${driver_name}, found version - ${found_version}"
			fi
		done
	fi
}

check_drivers() {
	# Check for USE=custom-kernels only which bypass RDEPEND
	use custom-kernel || return
	if use mlx5 ; then
		check_kernel_version "mlx5 network" "${CVE_MLX5}" ${MULTISLOT_KERNEL_DRIVER_MLX5[@]}
	fi
	if use video_cards_amdgpu ; then
		check_kernel_version "amdgpu video" "${CVE_DRM_AMDGPU}" ${MULTISLOT_KERNEL_DRIVER_DRM_AMDGPU[@]}
	fi
	if use video_cards_intel ; then
		check_kernel_version "i915 video" "${CVE_DRM_I915}" ${MULTISLOT_KERNEL_DRIVER_DRM_I915[@]}
	fi
	if use video_cards_radeon ; then
		check_kernel_version "radeon video" "${CVE_DRM_RADEON}" ${MULTISLOT_KERNEL_DRIVER_DRM_RADEON[@]}
	fi
	if use video_cards_vmware ; then
		check_kernel_version "vmwgfx video" "${CVE_DRM_VMWGFX}" ${MULTISLOT_KERNEL_DRIVER_DRM_RADEON[@]}
	fi
}

pkg_setup() {
	mitigate-dos_pkg_setup
ewarn "This ebuild is a Work In Progress (WIP)."
	check_drivers
}

# Unconditionally check
src_compile() {
	tc-is-cross-compiler && return
# TODO:  Find similar app
#einfo "Checking for mitigations against DoS."
#	if lscpu | grep -q "Vulnerable" ; then
#eerror "FAIL:  Detected an unmitigated CPU vulnerability."
#eerror "Fix issues to continue."
#		lscpu
#		die
#	else
#einfo "PASS"
#	fi
}
