# Copyright 2019-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: web-kernel-config.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for checking the web safe kernel config
# @DESCRIPTION:
# Check the kernel config for web safe settings.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

inherit linux-info toolchain-funcs

WEB_KERNEL_CONFIG_CHECK_YAMA="${WEB_KERNEL_CONFIG_CHECK_YAMA:-0}"

# @FUNCTION: web-kernel-config_setup
# @DESCRIPTION:
# Checks if the kernel config for standard security settings for web browsers.
#
# Verify kernel mitigations:
#
# ALSR - Code Reuse, Privilege Escalation, Memory Corruption
# Hardened user copy - Heap Overflow, Code Execution, Information Disclosure, Denial of Service
# Init on free / init on alloc - Use After Free
# Kernel stack offset randomization - Sandbox Escape, Privilege Escalation
# MMAP minimum address - Privilege Escalation, Sandbox Escape
# NX bit - Code Execution
# PTI - Information Disclosure
# Retpoline - Information Disclosure
# seccomp - Code Execution, Privilege Escalation
# SSP - Code Execution, Privilege Escalation
# YAMA - Sandbox Escape, Privilege Escalation, Information Disclosure
#
web-kernel-config_setup() {
	if use kernel_linux ; then
		linux-info_pkg_setup

einfo "Kernel version:  ${KV_MAJOR}.${KV_MINOR}"
einfo "CONFIG_PATH being reviewed:  $(linux_config_path)"

	        if ! linux_config_src_exists ; then
eerror "Missing .config in /usr/src/linux"
	        fi

		if ! linux_config_exists ; then
ewarn "Missing kernel .config file."
		fi

	#
	# The kstack offset mitigation has been weaponized for Data Tampering in CVE-2025-38236
	# It has a better Faustian deal by enabling it.
	#
	# YAMA is a Chromium requirement.
	#
	# We don't make config options a hard requirement because not all arches support them.
	#
		CONFIG_CHECK="
			~HARDENED_USERCOPY
			~INIT_ON_ALLOC_DEFAULT_ON
			~INIT_ON_FREE_DEFAULT_ON
			~RANDOMIZE_BASE
			~RANDOMIZE_KSTACK_OFFSET
			~RELOCATABLE
			~SECCOMP
			~STACKPROTECTOR
			~STACKPROTECTOR_STRONG
			~STRICT_KERNEL_RWX
		"

		if [[ "${WEB_KERNEL_CONFIG_CHECK_YAMA}" == "1" ]] ; then
			CONFIG_CHECK+="
				~MULTIUSER
				~SECURITY
				~SECURITY_YAMA
				~SYSFS

			"
			WARNING_SECURITY="CONFIG_SECURITY is required for YAMA for mitigation against credential theft or sandbox escape."
			WARNING_SECURITY_YAMA="CONFIG_SECURITY_YAMA could be added for ptrace sandbox protection to mitigate against credential theft or sandbox escape."
			WARNING_MULTIUSER="CONFIG_MULTIUSER is required for YAMA for mitigation against credential theft or sandbox escape."
			WARNING_SYSFS="CONFIG_SYSFS could be added for ptrace sandbox protection."
		fi

		if use amd64 ; then
			CONFIG_CHECK+="
				~RANDOMIZE_MEMORY
			"
		fi
		if ver_test "${KV_MAJOR}.${KV_MINOR}" "-lt" "6.9" ; then
	# Kernel 2.10
			CONFIG_CHECK+="
				~PAGE_TABLE_ISOLATION
				~RETPOLINE
			"
		else
	# Kernel 6.9
			CONFIG_CHECK+="
				~MITIGATION_PAGE_TABLE_ISOLATION
				~MITIGATION_RETPOLINE
			"
		fi

		WARNING_INIT_ON_ALLOC_DEFAULT_ON="CONFIG_INIT_ON_ALLOC_DEFAULT_ON is required to mitigate against full system compromise."
		WARNING_INIT_ON_FREE_DEFAULT_ON="CONFIG_INIT_ON_FREE_DEFAULT_ON is required to mitigate against full system compromise."
		WARNING_HARDENED_USERCOPY="CONFIG_HARDENED_USERCOPY is required to mitigate against full system compromise."
		WARNING_MITIGATION_PAGE_TABLE_ISOLATION="CONFIG_MITIGATION_PAGE_TABLE_ISOLATION is required for Meltdown mitigation or exfiltration mitigation."
		WARNING_MITIGATION_RETPOLINE="CONFIG_MITIGATION_RETPOLINE is required for Spectre mitigation or exfiltration mitigation."
		WARNING_PAGE_TABLE_ISOLATION="CONFIG_PAGE_TABLE_ISOLATION is required for Meltdown mitigation or exfiltration mitigation."
		WARNING_RANDOMIZE_BASE="CONFIG_RANDOMIZE_BASE is required to mitigate against full system compromise."
		WARNING_RANDOMIZE_KSTACK_OFFSET="CONFIG_RANDOMIZE_KSTACK_OFFSET is required to mitigate against sandbox escape."
		WARNING_RANDOMIZE_MEMORY="CONFIG_RANDOMIZE_MEMORY is required to mitigate against full system compromise."
		WARNING_RANDOMIZE_RELOCATABLE="CONFIG_RANDOMIZE_BASE is required to mitigate against full system compromise."
		WARNING_RETPOLINE="CONFIG_RETPOLINE is required for Spectre mitigation or exfiltration mitigation."
		WARNING_SECCOMP="CONFIG_SECCOMP is required to sandbox correctly."
		WARNING_STACKPROTECTOR="CONFIG_STACKPROTECTOR is required to mitigate against full system compromise."
		WARNING_STACKPROTECTOR_STRONG="CONFIG_STACKPROTECTOR is required to mitigate against full system compromise."
		WARNING_STRICT_KERNEL_RWX="CONFIG_STRICT_KERNEL_RWX is required to mitigate against full system compromise."

		if \
			[[ "${WEB_KERNEL_CONFIG_CHECK_YAMA}" == "1" ]] \
				&& \
			linux_chkconfig_present "SECURITY_YAMA" \
		; then
			local lsm=$(linux_chkconfig_string "LSM")
			if ! [[ "${lsm}" =~ "yama" ]] ; then
ewarn "CONFIG_LSM should add yama for ptrace sandbox protection and sandbox escape mitigation."
			fi
		fi

		check_extra_config

		local config_path=$(linux_config_path)
		local is_64bit=$(tc-get-ptr-size)
		is_64bit=$(( ${is_64bit} == 8 ? 1 : 0 ))
		if [[ -e "${config_path}" ]] ; then
			local v=$(grep -e "CONFIG_DEFAULT_MMAP_MIN_ADDR" "${config_path}" | cut -f 2 -d "=")
			[[ -z "${v}" ]] && v=0
			if (( ${is_64bit} == 1 && ${v} != 65536 )) ; then
ewarn "CONFIG_DEFAULT_MMAP_MIN_ADDR should be 65536 for 64-bit to mitigate sandbox escape."
			fi
			if (( ${is_64bit} == 0 && ${v} != 32768 )) ; then
ewarn "CONFIG_DEFAULT_MMAP_MIN_ADDR should be 32768 for 32-bit to mitigate sandbox escape."
			fi
		else
ewarn "CONFIG_DEFAULT_MMAP_MIN_ADDR should be 65536 for 64-bit, 32768 for 32-bit to mitigate sandbox escape."
		fi
	fi
}
