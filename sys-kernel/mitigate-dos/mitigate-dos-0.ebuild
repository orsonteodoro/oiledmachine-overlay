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
["_6_14"]="EOL"
["_6_15"]="EOL"
["_6_16"]="6.16"
)
_INTEL_MICROCODE_PV=0
_LINUX_FIRMWARE_PV=0
_XEN_PV=0

LTS_VERSIONS=("5.4" "5.10" "5.15" "6.1" "6.6" "6.12")
ACTIVE_VERSIONS=("5.4" "5.10" "5.15" "6.1" "6.6" "6.12" "6.15" "6.16")
STABLE_OR_MAINLINE_VERSIONS=("6.12" "6.15")
ALL_VERSIONS=(
	"0"
	"1"
	"2"
	"3"
	"4.0" "4.1" "4.2" "4.3" "4.4" "4.5" "4.6" "4.7" "4.8" "4.9" "4.10" "4.11" "4.12" "4.13" "4.14" "4.15" "4.16" "4.17" "4.18" "4.19" "4.20"
	"5.0" "5.1" "5.2" "5.3" "5.4" "5.5" "5.6" "5.7" "5.8" "5.9" "5.10" "5.11" "5.12" "5.13" "5.14" "5.15" "5.16" "5.17" "5.18" "5.19"
	"6.0" "6.1" "6.2" "6.3" "6.4" "6.5" "6.6" "6.7" "6.8" "6.9" "6.11" "6.12" "6.13" "6.14" "6.15" "6.16"
)
EOL_VERSIONS=(
	"0"
	"1"
	"2"
	"3"
	"4.0" "4.1" "4.2" "4.3" "4.4" "4.5" "4.6" "4.7" "4.8" "4.9" "4.10" "4.11" "4.12" "4.13" "4.14" "4.15" "4.16" "4.17" "4.18" "4.19" "4.20"
	"5.0" "5.1" "5.2" "5.3" "5.5" "5.6" "5.7" "5.8" "5.9" "5.11" "5.12" "5.13" "5.14" "5.16" "5.17" "5.18" "5.19"
	"6.0" "6.2" "6.3" "6.4" "6.5" "6.7" "6.8" "6.9" "6.10" "6.11" "6.13" "6.14" "6.15"
)

# For zero-tolerance mode
MULTISLOT_LATEST_KERNEL_RELEASE=("5.4.299" "5.10.244" "5.15.193" "6.1.154" "6.6.108" "6.12.49" "6.16.9")

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
	video_cards_nvidia
)
IUSE+="
${VIDEO_CARDS[@]}
+max-uptime
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
# NULL pointer dereference, NPD, CVSS 5.5 # DoS
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
	mitigate_dos_rdepend
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
		xen? (
			>=app-emulation/xen-${_XEN_PV}
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

_disable_gentoo_self_protection() {
	# Disabled for fine grained customization.
	_check_n "GENTOO_KERNEL_SELF_PROTECTION"
	_check_n "GENTOO_KERNEL_SELF_PROTECTION_COMMON"
	_check_n "GENTOO_KERNEL_SELF_PROTECTION_X86_64"
	_check_n "GENTOO_KERNEL_SELF_PROTECTION_X86_32"
	_check_n "GENTOO_KERNEL_SELF_PROTECTION_ARM64"
	_check_n "GENTOO_KERNEL_SELF_PROTECTION_ARM"
}

_check_kernel_cmdline() {
	local arg="${1}"
ewarn "${arg} should be added to the kernel command line for max-uptime."
}

_unset_pat_kconfig_kernel_cmdline() {
	local arg="${1}"
ewarn "${arg} should be unset to the kernel command line for max-uptime."
}

_y_retpoline() {
	if ver_test "${KV_MAJOR_MINOR}" -ge "6.9" ; then
		_check_y "MITIGATION_RETPOLINE"
	elif ver_test "${KV_MAJOR_MINOR}" -ge "4.15" ; then
		_check_y "RETPOLINE"
	else
ewarn "Retpoline not supported for < 4.15"
		return
	fi
	local ready=0
	if [[ "${compiler}" =~ "gcc" ]] && ver_test "${compiler_version}" -ge "7.3.0" ; then
		ready=1
	elif [[ "${compiler}" =~ "clang" ]] && ver_test "${compiler_version}" -ge "5.0.2" ; then
		ready=1
	fi
	if (( ${ready} == 0 )) ; then

		local gcc_version=$(gcc-version)
		local clang_version=$(clang-version)
		local compiler_name
		if [[ "${compiler}" =~ "gcc" ]] ; then
			compiler_name="gcc"
		elif [[ "${compiler}" =~ "clang" ]] ; then
			compiler_name="clang"
		fi
eerror
eerror "Switch to >=gcc-7.3 or >=clang-5.0.2 for retpoline support"
eerror
eerror "Actual ${compiler_name} version:  ${compiler_version}"
eerror
eerror "Tip:  Add/remove clang in OT_KERNEL_USE and in USE."
eerror
#		die
	fi
}

_y_cet_ibt() {
	_check_y "X86_KERNEL_IBT"
	local ready=0
	if [[ "${compiler}" =~ "gcc" ]] && ver_test "${compiler_version%%.*}" -ge "9" && ot-kernel_has_version ">=sys-devel/binutils-2.29" ; then
		ready=1
	elif [[ "${compiler}" =~ "clang" ]] && ver_test "${compiler_version%%.*}" -ge "14" && ot-kernel_has_version ">=llvm-core/lld-${compiler_version}" ; then
		ready=1
	fi
	if (( ${ready} == 0 )) ; then
		local compiler_name
		if [[ "${compiler}" =~ "gcc" ]] ; then
			compiler_name="gcc"
		elif [[ "${compiler}" =~ "clang" ]] ; then
			compiler_name="clang"
		fi
eerror
eerror "For CET-IBT (Indirect Branch Tracking) support for hardware forward edge CFI, switch to"
eerror
eerror "  >=gcc-9 with >=binutils-2.29"
eerror
eerror "    or"
eerror
eerror "  >=clang-14 with >=lld-14"
eerror
eerror "Actual ${compiler_name} version:  ${compiler_version}"
eerror
eerror "Tip:  Add/remove clang in OT_KERNEL_USE and in USE."
eerror
		if has cet ${IUSE_EFFECTIVE} && use cet ; then
			die
		else
			:
		fi
	fi
}
_y_cet_ss() {
	_check_y "X86_USER_SHADOW_STACK"
	local ready=0
	if [[ "${compiler}" =~ "gcc" ]] && ver_test "${compiler_version%%.*}" -ge "8" && ot-kernel_has_version ">=sys-devel/binutils-2.31" ; then
		ready=1
	elif [[ "${compiler}" =~ "clang" ]] && ver_test "${compiler_version%%.*}" -ge "6" && ot-kernel_has_version ">=llvm-core/lld-6" ; then
		ready=1
	fi
	if (( ${ready} == 0 )) ; then
		local compiler_name
		if [[ "${compiler}" =~ "gcc" ]] ; then
			compiler_name="gcc"
		elif [[ "${compiler}" =~ "clang" ]] ; then
			compiler_name="clang"
		fi
eerror
eerror "For CET-SS User Shadow Stack support for hardware backward edge CFI, switch to"
eerror
eerror "  >=gcc-8 with >=binutils-2.31"
eerror
eerror "    or"
eerror
eerror "  >=clang-6 with >=lld-6"
eerror
eerror "Actual ${compiler_name} version:  ${compiler_version}"
eerror
eerror "Tip:  Add/remove clang in OT_KERNEL_USE and in USE."
eerror
		if has cet ${IUSE_EFFECTIVE} && use cet ; then
			die
		else
			:
		fi
	fi
}

_set_kconfig_l1tf_mitigations() {
	local mode="${1}" # 1=enable, 0=disable
	[[ "${firmware_vendor}" != "intel" ]] && return
	if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
		local family
		if tc-is-cross-compiler ; then
			family=6
		else
			family=$(cat /proc/cpuinfo \
				| grep "cpu family" \
				| grep -Eo "[0-9]+" \
				| head -n 1)
		fi
		if (( ${family} != 6 )) ; then
			_unset_pat_kconfig_kernel_cmdline "l1tf=off"
			return
		fi

		if [[ "${mode}" == "1" ]] ; then
	# SMT off, full hypervisor mitigation
			_unset_pat_kconfig_kernel_cmdline "l1tf=full,force"
		elif [[ "${mode}" == "0.5" ]] ; then
	# SMT on, default hypervisor mitigation
			_unset_pat_kconfig_kernel_cmdline "l1tf=flush"
		else
	# SMT on, no mitigation
			_unset_pat_kconfig_kernel_cmdline "l1tf=off"
		fi
	# Upstream uses SMT on, partial hypervisor mitigation.
	fi
}

# Keep in sync from with ot-kernel's ot-kernel_set_kconfig_hardening_level() default section.
# My explanation why the default setting is the most reliable for max uptime.
# 1.  Less overheating
# 2.  More CI testing for these defaults
# 3.  Mitigations do contribute to reducing fatal crash
# Tested with 62 days uptime with heavy compilation.
_verify_max_uptime_kernel_config_for_one_kernel() {
	local KV_MAJOR_MINOR="${1}"

	# This function resets the .config back to upstream defaults.

	local path_config="${KERNEL_DIR}/.config"
	if ! [[ -f "${path_config}" ]] ; then
ewarn "Missing ${path_config}.  Skipping max-uptime verification"
		return
	fi

	local compiler=$(linux_chkconfig_string "CC_VERSION_TEXT")
	if ! [[ "${compiler}" =~ "gcc" ]] ; then
		ewarn "${compiler} has not been verified for max uptime.  Rebuild with gcc to replicate the results."
	fi

	local compiler_version
	local gcc_slot
	if [[ "${compiler}" =~ "gcc" ]] ; then
		compiler_version=$(grep -e "CONFIG_CC_VERSION_TEXT" "${path_config}" | cut -f 2 -d "=" | cut -f 5 -d " ")
		gcc_slot="${compiler_version%%.*}"
	elif [[ "${compiler}" =~ "clang" ]] ; then
		compiler_version=$(grep -e "CONFIG_CC_VERSION_TEXT" "${path_config}" | cut -f 2 -d "=" | cut -f 3 -d " ")
	else
eerror "gcc or clang only supported for max-uptime in kernel .config.  Skipping check."
		return
	fi

	CONFIG_CHECK="
	"

	local arch=""
	if grep -q -e "Linux/x86" "${path_config}" && grep -q -e "^CONFIG_X86_64=y" "${path_config}" ; then
		arch="x86_64"
	elif grep -q -e "Linux/x86" "${path_config}" && grep -q -e "^CONFIG_X86=y" "${path_config}" ; then
		arch="x86"
	elif grep -q -e "Linux/arm64" "${path_config}" ; then
		arch="arm64"
	elif grep -q -e "Linux/arm" "${path_config}" ; then
		arch="arm"
	elif grep -q -e "Linux/s390" "${path_config}" ; then
		arch="s390"
	elif grep -q -e "Linux/powerpc" "${path_config}" ; then
		arch="powerpc"
	elif grep -q -e "Linux/sparc" "${path_config}" ; then
		arch="sparc"
	elif grep -q -e "Linux/mips" "${path_config}" ; then
		arch="mips"
	elif grep -q -e "Linux/riscv" "${path_config}" ; then
		arch="riscv"
	elif grep -q -e "Linux/mips" "${path_config}" ; then
		arch="mips"
	elif grep -q -e "Linux/loongarch" "${path_config}" ; then
		arch="loongarch"
	elif grep -q -e "Linux/alpha" "${path_config}" ; then
		arch="alpha"
	elif grep -q -e "Linux/parisc" "${path_config}" ; then
		arch="parisc" # HPPA
	else
eerror "USE=max-uptime not supported for ARCH=${ARCH}"
		die
	fi

	_check_n "CFI_CLANG"

	local firmware_vendor="${FIRMWARE_VENDOR,,}"
	if [[ -z "${firmware_vendor}" ]] ; then
eerror "FIRMWARE_VENDOR is empty."
eerror "Set FIRMWARE_VENDOR as the fallback corresponding to the CPU manufacturer.  Valid values:  intel, amd, arm, etc."
		die
	fi

	# In essence, make everything the default vanilla kernel settings.

	_check_n "KASAN"
	_check_n "KCSAN"

	# The vanilla kernel makes this disabled but sometimes it is enabled for distro kernels.
	_check_n "KFENCE"

	_check_n "KMSAN"
	_check_n "UBSAN"

	# Force -O2 to reduce encountering bad generated code.
	_check_n "CC_OPTIMIZE_FOR_PERFORMANCE_O3"
	_check_y "CC_OPTIMIZE_FOR_PERFORMANCE"
	_check_n "CC_OPTIMIZE_FOR_SIZE"

	_check_y "COMPAT_BRK"
	_check_n "FORTIFY_SOURCE"
	_disable_gentoo_self_protection
	_check_n "HARDENED_USERCOPY"
	_check_n "INIT_ON_ALLOC_DEFAULT_ON"
	_check_n "INIT_ON_FREE_DEFAULT_ON"

	if \
		[[ "${compiler}" =~ "gcc" ]] \
			&& \
		test -e $("${CHOST}-gcc-${gcc_slot}" -print-file-name=plugin)"/include/plugin-version.h" \
			&& \
		grep -q -E -e "^CONFIG_HAVE_GCC_PLUGINS=y" "${path_config}" \
			&& \
		! linux_chkconfig_present "RUST" \
	; then
		_check_y "GCC_PLUGINS"
	else
		_check_n "GCC_PLUGINS"
	fi

	if ver_test "${KV_MAJOR_MINOR}" -ge "5.15" ; then
		if grep -q -E -e "^CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO=y" "${path_config}" ; then
			_check_n "INIT_STACK_ALL_PATTERN"
			_check_y "INIT_STACK_ALL_ZERO" # Needs >= GCC 12
			_check_n "GCC_PLUGIN_STACKLEAK"
			_check_n "GCC_PLUGIN_STRUCTLEAK_BYREF"
			_check_n "GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
			_check_n "GCC_PLUGIN_STRUCTLEAK_USER"
			_check_n "INIT_STACK_NONE"
		else
			_check_n "INIT_STACK_ALL_PATTERN"
			_check_n "INIT_STACK_ALL_ZERO"
			_check_n "GCC_PLUGIN_STACKLEAK"
			_check_n "GCC_PLUGIN_STRUCTLEAK_BYREF"
			_check_n "GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
			_check_n "GCC_PLUGIN_STRUCTLEAK_USER"
			_check_y "INIT_STACK_NONE"
		fi
	elif ver_test "${KV_MAJOR_MINOR}" -ge "5.9" ; then
		_check_n "INIT_STACK_ALL_PATTERN"
		_check_n "INIT_STACK_ALL_ZERO"
		_check_n "GCC_PLUGIN_STACKLEAK"
		_check_n "GCC_PLUGIN_STRUCTLEAK_BYREF"
		_check_n "GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
		_check_n "GCC_PLUGIN_STRUCTLEAK_USER"
		_check_y "INIT_STACK_NONE"
	elif ver_test "${KV_MAJOR_MINOR}" -ge "5.4" ; then
		_check_n "INIT_STACK_ALL"
		_check_y "INIT_STACK_NONE"
		_check_n "GCC_PLUGIN_STRUCTLEAK"
		_check_n "GCC_PLUGIN_STRUCTLEAK_BYREF"
		_check_n "GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
		_check_n "GCC_PLUGIN_STRUCTLEAK_USER"
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "5.19" ; then
		# COMPILE_TEST is not default ON.
		_check_y "RANDSTRUCT_NONE"
		_check_n "RANDSTRUCT_FULL"
		_check_n "RANDSTRUCT_PERFORMANCE"
	fi
	_check_y "EXPERT"
	_check_y "MODIFY_LDT_SYSCALL"
	_check_y "RELOCATABLE"
	_check_y "RANDOMIZE_BASE"
	_check_n "RANDOMIZE_KSTACK_OFFSET_DEFAULT"
	if [[ "${arch}" == "s390" ]] ; then
		_check_y "EXPOLINE"
		_check_n "EXPOLINE_OFF"
		_check_y "EXPOLINE_AUTO"
		_check_n "EXPOLINE_ON"
	elif [[ "${arch}" == "x86"  || "${arch}" == "x86_64" ]] ; then
		_check_y "RANDOMIZE_MEMORY"
	fi
	_y_retpoline
	_check_n "SHUFFLE_PAGE_ALLOCATOR"
	_check_n "SLAB_FREELIST_HARDENED"
	_check_n "SLAB_FREELIST_RANDOM"
	_check_y "SLAB_MERGE_DEFAULT"
	_check_y "STACKPROTECTOR"
	_check_y "STACKPROTECTOR_STRONG"
	if tc-is-gcc ; then
		_check_n "ZERO_CALL_USED_REGS"
	fi
	_check_n "SCHED_CORE"
	if ver_test "${KV_MAJOR_MINOR}" -ge "4.14" ; then
		if [[ "${firmware_vendor}" == "intel" ]] ; then
	# GDS:  Rely on automagic
			_check_n "GDS_FORCE_MITIGATION"
		fi
		if [[ "${arch}" == "arm64" ]] ; then
	# KPTI:  This assumes unforced default
	# SSBD:  Rely on automagic
			:
		fi

		if [[ "${arch}" == "powerpc" ]] ; then
			_check_kernel_cmdline "spec_store_bypass_disable=auto"
		fi

		if [[ "${arch}" == "s390" ]] ; then
			_check_n "KERNEL_NOBP"
			#_check_kernel_cmdline "nobp=0"
		fi

		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			_check_kernel_cmdline "spec_store_bypass_disable=auto"
			_check_kernel_cmdline "spectre_v2=auto"
			_check_kernel_cmdline "spectre_v2_user=auto"
			if grep -q -E -e "^CONFIG_KVM=y" "${path_config}" ; then
				_check_kernel_cmdline "kvm.nx_huge_pages=auto"
			fi
			if [[ "${firmware_vendor}" == "intel" ]] ; then
				_check_y "X86_INTEL_TSX_MODE_OFF"
				_check_n "X86_INTEL_TSX_MODE_ON"
				_check_n "X86_INTEL_TSX_MODE_AUTO"
				_check_kernel_cmdline "mds=full"
				_check_kernel_cmdline "mmio_stale_data=full"
				_check_kernel_cmdline "tsx=off"
				_check_kernel_cmdline "tsx_async_abort=full"
				if grep -q -E -e "^CONFIG_KVM=y" "${path_config}" ; then
					_check_kernel_cmdline "kvm-intel.vmentry_l1d_flush=cond"
				fi
			fi
		fi
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "4.15" ; then
		if [[ "${arch}" == "x86" ]] && grep -q -E -e "^CONFIG_X86_PAE=y" "${path_config}" ; then
			_check_y "PAGE_TABLE_ISOLATION"
		fi
		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			_check_y "PAGE_TABLE_ISOLATION"
		fi
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "5.8" ; then
		if [[ "${arch}" == "arm64" ]] && linux_chkconfig_present "ARM64_BTI_KERNEL" ; then
			_check_y "ARM64_VHE"
			_check_y "ARM64_PTR_AUTH"
			_check_y "ARM64_BTI_KERNEL"
			_check_n "GCOV_KERNEL"
			_check_n "FUNCTION_GRAPH_TRACER"
			_check_y "ARM64_BTI"
		elif [[ "${arch}" == "arm64" ]] && linux_chkconfig_present "ARM64_PTR_AUTH" ; then
# TODO:  Make it a fatal errror based on /proc/cpuinfo or lscpu.
ewarn "cpu_flags_arm_bti is default ON for ARMv8.5."
		fi
		if [[ "${arch}" == "arm64" ]] && linux_chkconfig_present "ARM64_PTR_AUTH" ; then
			_check_n "FUNCTION_GRAPH_TRACER"
			_check_y "ARM64_VHE"
			_check_y "ARM64_PTR_AUTH"
		elif [[ "${arch}" == "arm64" ]] && linux_chkconfig_present "ARM64_PTR_AUTH" ; then
# TODO:  Make it a fatal errror based on /proc/cpuinfo or lscpu.
ewarn "cpu_flags_arm_pac is default ON for ARMv8.5."
		fi
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "5.10" ; then
		_check_y "CPU_MITIGATIONS"
		if [[ "${firmware_vendor}" == "intel" ]] ; then
			_check_y "MITIGATION_RFDS"
		fi
		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			if [[ "${firmware_vendor}" == "amd" ]] ; then
				_check_y "CPU_SRSO"
				_check_y "CPU_UNRET_ENTRY"
				_check_kernel_cmdline "spec_rstack_overflow=safe-ret"
			fi
			_check_y "SPECULATION_MITIGATIONS"
		fi
		_check_y "RETHUNK"
		_check_y "CPU_IBPB_ENTRY"
		_check_y "CPU_IBRS_ENTRY"
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "5.14" ; then
		_set_kconfig_l1tf_mitigations "0.5"
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "5.15" ; then
		if [[ "${firmware_vendor}" == "intel" ]] ; then
			_check_y "MITIGATION_SPECTRE_BHI"
		fi
		if [[ "${arch}" == "powerpc" ]] ; then
			_check_kernel_cmdline "spec_store_bypass_disable=auto"
		fi
		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			_check_kernel_cmdline "retbleed=auto"
		fi
		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			_check_kernel_cmdline "spectre_bhi=on"
			_check_kernel_cmdline "spec_store_bypass_disable=auto"
		fi
	elif ver_test "${KV_MAJOR_MINOR}" -ge "4.14" ; then
		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			_check_kernel_cmdline "retbleed=auto"
		fi
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "5.17" ; then
		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			_check_y "SLS"
		fi
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "5.18" ; then
		_check_y "SPECULATION_MITIGATIONS"
		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			_y_cet_ibt
		fi
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "6.1" ; then
		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			if [[ "${firmware_vendor}" == "intel" ]] ; then
				_check_kernel_cmdline "reg_file_data_sampling=on"
				_check_y "MITIGATION_RFDS"
			fi
		fi
		if [[ "${arch}" == "x86_64" ]] ; then
			if [[ "${firmware_vendor}" == "amd" ]] ; then
				_check_y "SRSO"
			fi
		fi
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "6.2" ; then
		_check_y "CALL_DEPTH_TRACKING"
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "6.4" ; then
		if [[ "${arch}" == "x86_64" ]] ; then
			_check_n "ADDRESS_MASKING" # SLAM
		fi
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "6.5" ; then
		_check_y "CPU_SRSO"
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "6.6" ; then
		if [[ "${arch}" == "x86_64" ]] ; then
			_check_n "X86_CET"
			_y_cet_ibt  # Forward-edge CFI
			_y_cet_ss   # Backward-edge CFI
		fi
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "6.8" ; then
		if [[ "${firmware_vendor}" == "intel" ]] ; then
			_check_y "MITIGATION_SPECTRE_BHI"
		fi
		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			_check_kernel_cmdline "spectre_bhi=on"
		fi
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "6.9" ; then
		if [[ "${arch}" == "x86_64" ]] ; then
			_check_y "MITIGATION_PAGE_TABLE_ISOLATION"
			_check_y "MITIGATION_SLS"
			_check_y "MITIGATION_RETHUNK"
			if [[ "${firmware_vendor}" == "amd" ]] ; then
				_check_y "MITIGATION_SRSO"
				_check_y "MITIGATION_UNRET_ENTRY"
				_check_y "MITIGATION_IBPB_ENTRY"
			fi
			if [[ "${firmware_vendor}" == "intel" ]] ; then
				_check_y "MITIGATION_CALL_DEPTH_TRACKING"
				_check_y "MITIGATION_IBRS_ENTRY"
				if has_version "sys-firmware/intel-microcode" ; then
					_check_n "MITIGATION_GDS_FORCE"
				#elif use cpu_flags_x86_avx ; then
				#	_check_y "MITIGATION_GDS_FORCE"
				fi
			fi
		fi
	fi

	# See https://en.wikipedia.org/wiki/Kernel_same-page_merging#Security_risks
	# Rowhammer - PE, DT, PE -> ID, PE -> DoS
	_check_n "KSM"
	_check_n "UKSM"

	if ! linux_chkconfig_present "SWAP" ; then
# See https://github.com/facebookincubator/oomd/blob/v0.5.0/docs/production_setup.md#swap
ewarn
ewarn "CONFIG_SWAP is recommended with 4x the RAM or at least 32 GiB total memory.  Tested with 28 GiB Swap and 8 GiB ram for 62 days of uptime."
ewarn "The CONFIG_SWAP=y recommendation does NOT apply to realtime, music production, or hardcore gameplay."
ewarn
	fi

	check_extra_config
}

verify_max_uptime_kernel_config() {
	if ! tc-is-cross-compiler && use max-uptime ; then
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
			KERNEL_DIR=$(dirname "${x}")
einfo
einfo "Verifying max-uptime settings for ${pv_major}.${pv_minor}.${pv_patch}${pv_extraversion}"
			_verify_max_uptime_kernel_config_for_one_kernel "${pv_major}.${pv_minor}"
		done
		KERNEL_DIR="${prev_kernel_dir}"
	fi
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
	mitigate-dos_pkg_setup
ewarn "This ebuild is a Work In Progress (WIP)."
	check_zero_tolerance
	use max-uptime && verify_max_uptime_kernel_config
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
