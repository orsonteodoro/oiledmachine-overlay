# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Security:  update every kernel version bump

declare -A _ALL_VERSIONS=(
["_0"]="EOL"
["_1"]="EOL"
["_2"]="EOL"
["_3"]="EOL"
["_4_0"]="EOL"
["_4_1"]="EOL"
["_4_2"]="EOL"
["_4_3"]="EOL"
["_4_4"]="EOL"
["_4_5"]="EOL"
["_4_6"]="EOL"
["_4_7"]="EOL"
["_4_8"]="EOL"
["_4_8"]="EOL"
["_4_9"]="EOL"
["_4_10"]="EOL"
["_4_11"]="EOL"
["_4_12"]="EOL"
["_4_13"]="EOL"
["_4_14"]="EOL"
["_4_15"]="EOL"
["_4_16"]="EOL"
["_4_17"]="EOL"
["_4_18"]="EOL"
["_4_19"]="EOL"
["_4_20"]="EOL"
["_5_0"]="EOL"
["_5_1"]="EOL"
["_5_2"]="EOL"
["_5_3"]="EOL"
["_5_4"]="5.4"
["_5_5"]="EOL"
["_5_6"]="EOL"
["_5_7"]="EOL"
["_5_8"]="EOL"
["_5_9"]="EOL"
["_5_10"]="5.10"
["_5_11"]="EOL"
["_5_12"]="EOL"
["_5_13"]="EOL"
["_5_14"]="EOL"
["_5_15"]="5.15"
["_5_16"]="EOL"
["_5_17"]="EOL"
["_5_18"]="EOL"
["_5_19"]="EOL"
["_6_0"]="EOL"
["_6_1"]="6.1"
["_6_2"]="EOL"
["_6_3"]="EOL"
["_6_4"]="EOL"
["_6_5"]="EOL"
["_6_6"]="6.6"
["_6_7"]="EOL"
["_6_8"]="EOL"
["_6_9"]="EOL"
["_6_10"]="EOL"
["_6_11"]="EOL"
["_6_12"]="6.12"
["_6_13"]="EOL"
["_6_14"]="6.14"
["_6_15"]="6.15"
)
_INTEL_MICROCODE_PV=0
_LINUX_FIRMWARE_PV=0

LTS_VERSIONS=("5.4" "5.10" "5.15" "6.1" "6.6" "6.12")
ACTIVE_VERSIONS=("5.4" "5.10" "5.15" "6.1" "6.6" "6.12" "6.14" "6.15")
STABLE_OR_MAINLINE_VERSIONS=("6.12" "6.13" "6.14" "6.15")
ALL_VERSIONS=(
	"0"
	"1"
	"2"
	"3"
	"4.0" "4.1" "4.2" "4.3" "4.4" "4.5" "4.6" "4.7" "4.8" "4.9" "4.10" "4.11" "4.12" "4.13" "4.14" "4.15" "4.16" "4.17" "4.18" "4.19" "4.20"
	"5.0" "5.1" "5.2" "5.3" "5.4" "5.5" "5.6" "5.7" "5.8" "5.9" "5.10" "5.11" "5.12" "5.13" "5.14" "5.15" "5.16" "5.17" "5.18" "5.19"
	"6.0" "6.1" "6.2" "6.3" "6.4" "6.5" "6.6" "6.7" "6.8" "6.9" "6.11" "6.12" "6.13" "6.14" "6.15"
)
EOL_VERSIONS=(
	"0"
	"1"
	"2"
	"3"
	"4.0" "4.1" "4.2" "4.3" "4.4" "4.5" "4.6" "4.7" "4.8" "4.9" "4.10" "4.11" "4.12" "4.13" "4.14" "4.15" "4.16" "4.17" "4.18" "4.19" "4.20"
	"5.0" "5.1" "5.2" "5.3" "5.5" "5.6" "5.7" "5.8" "5.9" "5.11" "5.12" "5.13" "5.14" "5.16" "5.17" "5.18" "5.19"
	"6.0" "6.2" "6.3" "6.4" "6.5" "6.7" "6.8" "6.9" "6.10" "6.11" "6.13"
)

# For zero-tolerance mode
MULTISLOT_LATEST_KERNEL_RELEASE=("5.4.293" "5.10.237" "5.15.184" "6.1.140" "6.6.92" "6.12.31" "6.14.9" "6.15")

inherit mitigate-dt toolchain-funcs

# Add RDEPEND+=" sys-kernel/mitigate-dt" to downstream package if the downstream ebuild uses:
# Server (financial, banking, legal, voting)
# Web Browser (For voting, financial, banking, legal, voting)
# Network Software
# Realtime manufacturing

S="${WORKDIR}"

DESCRIPTION="Enforce Data Tampering mitigations"
SLOT="0"
KEYWORDS="~amd64 ~x86"
VIDEO_CARDS=(
	video_cards_nvidia
)
IUSE+="
${VIDEO_CARDS[@]}
"
REQUIRED_USE="
zero-tolerance
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
# Data corruption, CVSS 7.1 # DT, DoS
# Data race, CVSS 7.0 # DoS, DT, ID
# Deadlock, CVSS 5.5 # DoS
# Double free, CVSS 7.8 # DoS, DT, ID
# Local privilege escalation, CVSS 7.8 # DoS, DT, ID
# Memory leak, CVSS 5.5 # DoS
# NULL pointer dereference, CVSS 5.5 # DoS
# Out of bounds read, CVSS 7.1, # DoS, ID
# Out of bounds write, CVSS 7.8, # DoS, ID, DT
# Race condition, CVSS 4.7 # DoS
# ToCToU race, CVSS 7.0 # PE, DoS, DT, ID
# Use after free, use-after-free, UAF, CVSS 7.8 # DoS, DT, ID
# VM guest makes host slow and responsive, CVSS 6.0 # DoS
#

# Ebuild policy for automatic classification for rows marked *unofficial*:
#
# Sensitive data read || incomplete sanitization of sensitive data : ID
# Possible privilege escalation || data corruption || altered permissions : DT
# Possible crash || kernel panic || (!ID && !DT) : DoS

#
# Usually stable versions get security checked.
# The betas and dev versions usually do not get security reports.
#

all_rdepend() {
	mitigate_dt_rdepend
	if ! _use custom-kernel ; then
		if _use zero-tolerance ; then
			gen_zero_tolerance_kernel_list ${MULTISLOT_LATEST_KERNEL_RELEASE[@]}
		fi
	fi
}
all_rdepend
RDEPEND="
	enforce? (
		!sys-kernel/rock-dkms
		!sys-kernel/rocm-sources
		!custom-kernel? (
			$(gen_render_kernels_list ${MULTISLOT_LATEST_KERNEL_RELEASE[@]})
		)
		video_cards_nvidia? (
			|| (
				>=x11-drivers/nvidia-drivers-565.57.01:0/565
				>=x11-drivers/nvidia-drivers-550.127.05:0/550
				>=x11-drivers/nvidia-drivers-535.216.01:0/535
				>=x11-drivers/nvidia-drivers-470.256.02:0/470
			)
			x11-drivers/nvidia-drivers:=
		)
	)
"
if [[ "${FIRMWARE_VENDOR}" == "intel" ]] ; then
	RDEPEND+="
		enforce? (
			firmware? (
				>=sys-firmware/intel-microcode-${_INTEL_MICROCODE_PV}
			)
		)
	"
fi
if [[ "${FIRMWARE_VENDOR}" == "amd" ]] ; then
	RDEPEND+="
		enforce? (
			firmware? (
				>=sys-kernel/linux-firmware-${_LINUX_FIRMWARE_PV}
			)
		)
	"
fi
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
					if ver_test ${s1} -eq ${s2} && [[ "${patched_version}" =~ "V" ]] ; then
						vulnerable=1
						break
					elif ver_test ${s1} -eq ${s2} && ver_test ${found_version} -ge ${patched_version} ; then
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

_check_y() {
	local kconfig_setting="${1}"
	CONFIG_CHECK+="
		${kconfig_setting}
	"
}

_check_n() {
	local kconfig_setting="${1}"
	CONFIG_CHECK+="
		!${kconfig_setting}
	"
}

verify_disable_ksm_for_one_kernel() {
	CONFIG_CHECK="
		!KSM
		!UKSM
	"
	ERROR_KSM="CONFIG_KSM=n is required to mitigate from ASLR circumvention, information disclosure, Rowhammer (elevated privileges, data tampering)"
	ERROR_UKSM="CONFIG_UKSM=n is required to mitigate against denial of service" # Thrashy
	check_extra_config
}

verify_disable_ksm() {
	if use zero-tolerance ; then
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
einfo
einfo "Verifying CONFIG_KSM=n settings for ${pv_major}.${pv_minor}.${pv_patch}${pv_extraversion}"
			KERNEL_DIR=$(dirname "${x}")
			verify_disable_ksm_for_one_kernel
		done
		KERNEL_DIR="${prev_kernel_dir}"
	fi
}

check_zero_tolerance() {
	use custom-kernel || return
	if use zero-tolerance ; then
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

			local latest_version
			for latest_version in ${MULTISLOT_LATEST_KERNEL_RELEASE[@]} ; do
				local s1=$(ver_cut 1-2 "${latest_version}")
				local s2="${pv_major}.${pv_minor}"
				if is_eol "${pv_major}.${pv_minor}" ; then
eerror "${pv_major}.${pv_minor}.${pv_patch}${extra_version} is EOL should be unemerged."
				elif ver_test "${s1}" -eq "${s2}" && ver_test "${pv_major}.${pv_minor}.${pv_patch}" -lt "${latest_version}" ; then
eerror "${pv_major}.${pv_minor}.${pv_patch}${extra_version} failed zero-tolerance and should be unemerged."
				fi
			done

		done
		KERNEL_DIR="${prev_kernel_dir}"
	fi
}

pkg_setup() {
	use enforce || return
	mitigate-dt_pkg_setup
ewarn "This ebuild is a Work In Progress (WIP)."
	check_zero_tolerance
	verify_disable_ksm
}

src_compile() {
	use enforce || ewarn "The USE enforce flag is disabled."
	use enforce || return
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
