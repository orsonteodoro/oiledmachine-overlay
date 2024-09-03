# @ECLASS: mitigate-tecv.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Spectre and Meltdown kernel mitigation
# @DESCRIPTION:
# This ebuild is to perform kernel checks on Spectre and Meltdown on the kernel
# level.  This also covers other mitigations for hardware vulnerabilities.
#
# TECV = Transient Execution CPU Vulnerability
# https://en.wikipedia.org/wiki/Transient_execution_CPU_vulnerability
#

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_MITIGATE_TECV_ECLASS} ]] ; then
_MITIGATE_TECV_ECLASS=1

CPU_TARGET_X86=(
	cpu_target_x86_atom
	cpu_target_x86_core_gen6
	cpu_target_x86_core_gen7
	cpu_target_x86_core_gen8
	cpu_target_x86_core_gen9
	cpu_target_x86_core_gen10
	cpu_target_x86_core_gen11
	cpu_target_x86_zen2
)

CPU_TARGET_ARM=(
# See also
# https://developer.arm.com/Arm%20Security%20Center/Speculative%20Processor%20Vulnerability
# https://github.com/torvalds/linux/blob/v6.10/arch/arm64/kernel/cpufeature.c#L1739
	cpu_target_arm_cortex_a15 # Variant 3a
	# cpu_target_arm_cortex_a57 # Variant 3a
	# cpu_target_arm_cortex_a72 # Variant 3a
	cpu_target_arm_cortex_a75 # Variant 3
)

inherit linux-info

IUSE+="
	${CPU_TARGET_ARM[@]}
	${CPU_TARGET_X86[@]}
	custom-kernel
"

# @FUNCTION: gen_patched_kernel_list
# @INTERNAL
# @DESCRIPTION:
# Generate the patched kernel list
gen_patched_kernel_list() {
	local kv="${1}"
	echo "
		|| (
			>=sys-kernel/gentoo-kernel-bin-${kv}
			>=sys-kernel/gentoo-sources-${kv}
			>=sys-kernel/vanilla-sources-${kv}
			>=sys-kernel/git-sources-${kv}
			>=sys-kernel/mips-sources-${kv}
			>=sys-kernel/pf-sources-${kv}
			>=sys-kernel/rt-sources-${kv}
			>=sys-kernel/zen-sources-${kv}
			>=sys-kernel/raspberrypi-sources-${kv}
			>=sys-kernel/gentoo-kernel-${kv}
			>=sys-kernel/gentoo-kernel-bin-${kv}
			>=sys-kernel/vanilla-kernel-${kv}
			>=sys-kernel/linux-next-${kv}
			>=sys-kernel/asahi-sources-${kv}
			>=sys-kernel/ot-sources-${kv}
		)
		!<sys-kernel/gentoo-kernel-bin-${kv}
		!<sys-kernel/gentoo-sources-${kv}
		!<sys-kernel/vanilla-sources-${kv}
		!<sys-kernel/git-sources-${kv}
		!<sys-kernel/mips-sources-${kv}
		!<sys-kernel/pf-sources-${kv}
		!<sys-kernel/rt-sources-${kv}
		!<sys-kernel/zen-sources-${kv}
		!<sys-kernel/raspberrypi-sources-${kv}
		!<sys-kernel/gentoo-kernel-${kv}
		!<sys-kernel/gentoo-kernel-bin-${kv}
		!<sys-kernel/vanilla-kernel-${kv}
		!<sys-kernel/linux-next-${kv}
		!<sys-kernel/asahi-sources-${kv}
		!<sys-kernel/ot-sources-${kv}
	"
}

# @ECLASS_VARIABLE: MITIGATE_TECV_RDEPEND
# @INTERNAL
# @DESCRIPTION:
# High level RDEPEND
# Footnotes:   KPTI added for arm64 in 5.1 but for a few microarches.
MITIGATE_TECV_RDEPEND="
	kernel_linux? (
		!custom-kernel? (
			arm64? (
				cpu_target_arm_cortex_a15? (
					$(gen_patched_kernel_list 4.16)
				)
				cpu_target_arm_cortex_a75? (
					$(gen_patched_kernel_list 4.16)
				)
			)
			amd64? (
				$(gen_patched_kernel_list 4.15)
				cpu_target_x86_atom? (
					$(gen_patched_kernel_list 6.9)
				)
				cpu_target_x86_core_gen6? (
					$(gen_patched_kernel_list 6.5)
				)
				cpu_target_x86_core_gen7? (
					$(gen_patched_kernel_list 6.5)
				)
				cpu_target_x86_core_gen8? (
					$(gen_patched_kernel_list 6.5)
				)
				cpu_target_x86_core_gen9? (
					$(gen_patched_kernel_list 6.5)
				)
				cpu_target_x86_core_gen10? (
					$(gen_patched_kernel_list 6.5)
				)
				cpu_target_x86_core_gen11? (
					$(gen_patched_kernel_list 6.5)
				)
				cpu_target_x86_zen2? (
					$(gen_patched_kernel_list 6.9)
				)
			)
			s390? (
				$(gen_patched_kernel_list 4.16)
			)
			x86? (
				$(gen_patched_kernel_list 4.15)
				cpu_target_x86_atom? (
					$(gen_patched_kernel_list 6.9)
				)
				cpu_target_x86_core_gen6? (
					$(gen_patched_kernel_list 6.5)
				)
				cpu_target_x86_core_gen7? (
					$(gen_patched_kernel_list 6.5)
				)
				cpu_target_x86_core_gen8? (
					$(gen_patched_kernel_list 6.5)
				)
				cpu_target_x86_core_gen9? (
					$(gen_patched_kernel_list 6.5)
				)
				cpu_target_x86_core_gen10? (
					$(gen_patched_kernel_list 6.5)
				)
				cpu_target_x86_core_gen11? (
					$(gen_patched_kernel_list 6.5)
				)
				cpu_target_x86_zen2? (
					$(gen_patched_kernel_list 6.9)
				)
			)
		)
	)
"

# @FUNCTION: _mitigate_tecv_verify_mitigation_meltdown
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags to mitigate against Meltdown.
_mitigate_tecv_verify_mitigation_meltdown() {
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "6.9" ; then
		if [[ "${ARCH}" == "amd64" ]] ; then
			CONFIG_CHECK="
				MITIGATION_PAGE_TABLE_ISOLATION
			"
			WARNING_MITIGATION_PAGE_TABLE_ISOLATION="CONFIG_MITIGATION_PAGE_TABLE_ISOLATION is required for Meltdown mitigation."
			check_extra_config
		fi

		if [[ "${ARCH}" == "x86" ]] ; then
eerror "No mitigation against Meltdown for 32-bit x86.  Use only 64-bit instead."
			die
		fi
		if has abi_x86_32 ${IUSE_EFFECTIVE} && use abi_x86_32 ; then
eerror "No mitigation against Meltdown for 32-bit x86.  Use only 64-bit instead."
			die
		fi
	elif ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "4.15" ; then
		if [[ "${ARCH}" == "amd64" ]] ; then
			CONFIG_CHECK="
				PAGE_TABLE_ISOLATION
			"
			WARNING_PAGE_TABLE_ISOLATION="CONFIG_PAGE_TABLE_ISOLATION is required for Meltdown mitigation."
			check_extra_config
		fi

		if [[ "${ARCH}" == "x86" ]] ; then
eerror "No mitigation against Meltdown for 32-bit x86.  Use only 64-bit instead."
			die
		fi

		if has abi_x86_32 ${IUSE_EFFECTIVE} && use abi_x86_32 ; then
eerror "No mitigation against Meltdown for 32-bit x86.  Use only 64-bit instead."
			die
		fi
	fi


	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "4.16" ; then
		local needs_kpti=0
		use cpu_target_arm_cortex_a75 && needs_kpti=1
		use cpu_target_arm_cortex_a15 && needs_kpti=1
		if grep -q "mitigations=off" "/proc/cmdline" ; then
eerror
eerror "Detected mitigations=off in the kernel command line."
eerror
eerror "Acceptable values:"
eerror
eerror "  mitigations=auto"
eerror "  mitigations=auto,nosmt"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/defaults/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
		if (( ${needs_kpti} == 1 )) && grep -q "kpti=off" "/proc/cmdline" ; then
# Variant 3/3a
eerror
eerror "Detected kpti=off in the kernel command line."
eerror
eerror "Acceptable values:"
eerror
eerror "  kpti=on"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/defaults/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
		elif (( ${needs_kpti} == 1 )) && grep -q "kpti=off" "/proc/cmdline" ; then
# Variant 3/3a
eerror
eerror "Detected no kpti= in the kernel command line which implies kpti=off."
eerror
eerror "Acceptable values:"
eerror
eerror "  kpti=on"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/defaults/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
		fi
	fi

	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "4.15" ; then
		if grep -q "mitigations=off" "/proc/cmdline" ; then
eerror
eerror "Detected mitigations=off in the kernel command line."
eerror
eerror "Acceptable values:"
eerror
eerror "  mitigations=auto"
eerror "  mitigations=auto,nosmt"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/defaults/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
		# x86, ppc \
		if grep -q "nopti" "/proc/cmdline" ; then
eerror
eerror "Detected nopti in the kernel command line."
eerror
eerror "Remove it from:"
eerror
eerror "  /etc/defaults/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_spectre
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against Spectre.
_mitigate_tecv_verify_mitigation_spectre() {
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "6.9" ; then
		if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" ]] ; then
			CONFIG_CHECK="
				MITIGATION_RETPOLINE
				~MITIGATION_SPECTRE_BHI
			"
			WARNING_MITIGATION_RETPOLINE="CONFIG_MITIGATION_RETPOLINE is required for Spectre mitigation."
			WARNING_MITIGATION_SPECTRE_BHI="CONFIG_MITIGATION_SPECTRE_BHI is required for Spectre-BHI mitigation." # Possibly userspace only mitigations
			check_extra_config
		fi

		if [[ "${ARCH}" == "s390" ]] ; then
			CONFIG_CHECK="
				EXPOLINE
			"
			WARNING_RETPOLINE="CONFIG_EXPOLINE is required for Spectre mitigation."
			check_extra_config
		fi


	elif ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "4.15" ; then
		if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" ]] ; then
			CONFIG_CHECK="
				RETPOLINE
			"
			WARNING_RETPOLINE="CONFIG_RETPOLINE is required for Spectre mitigation."
			check_extra_config
		fi

		if [[ "${ARCH}" == "s390" ]] ; then
			CONFIG_CHECK="
				EXPOLINE
			"
			WARNING_RETPOLINE="CONFIG_EXPOLINE is required for Spectre mitigation."
			check_extra_config
		fi
	fi

	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "4.15" ; then
		if grep -q "mitigations=off" "/proc/cmdline" ; then
eerror
eerror "Detected mitigations=off in the kernel command line."
eerror
eerror "Acceptable values:"
eerror
eerror "  mitigations=auto"
eerror "  mitigations=auto,nosmt"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/defaults/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
		if grep -q "nospectre_v1" "/proc/cmdline" ; then
eerror
eerror "Detected nospectre_v1 in the kernel command line."
eerror
eerror "Remove it from:"
eerror
eerror "  /etc/defaults/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
		if grep -q "nospectre_v2" "/proc/cmdline" ; then
eerror
eerror "Detected nospectre_v2 in the kernel command line."
eerror
eerror "Remove it from:"
eerror
eerror "  /etc/defaults/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
		if [[ "${ARCH}" == "arm64" ]] && grep -q "nospectre_bhb" "/proc/cmdline" ; then
eerror
eerror "Detected nospectre_bhb in the kernel command line."
eerror
eerror "Remove it from:"
eerror
eerror "  /etc/defaults/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi

		if [[ "${ARCH}" == "x86" || "${ARCH}" == "amd64" ]] && grep -q "spectre_bhi=off" "/proc/cmdline" ; then
eerror
eerror "Detected spectre_bhi=off in the kernel command line."
eerror
eerror "Acceptable values for kernel command line:"
eerror
eerror "  spectre_bhi=on                     # The default if not specified"
eerror "  spectre_bhi=vmexit                 # Partial mitigation"
eerror "  spec_store_bypass_disable=prctl    # x86 default"
eerror
eerror "Remove it from:"
eerror
eerror "  /etc/defaults/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi

		if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" || "${ARCH}" == "powerpc" ]] ; then
			if grep -q "nospec_store_bypass_disable" "/proc/cmdline" ; then
eerror
eerror "Detected nospec_store_bypass_disable in the kernel command line."
eerror
eerror "Remove it from:"
eerror
eerror "  /etc/defaults/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
				die
			fi
			if grep -q "spec_store_bypass_disable=off" "/proc/cmdline" ; then
	# SSB / Spectre-NG Variant 4
eerror
eerror "Detected spec_store_bypass_disable=off."
eerror
eerror "Acceptable values for kernel command line:"
eerror
eerror "  spec_store_bypass_disable=auto     # The default if not specified"
eerror "  spec_store_bypass_disable=on"
eerror "  spec_store_bypass_disable=prctl    # x86 default"
eerror
eerror "Please check:"
eerror
eerror "  /etc/defaults/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
				die
			fi
		fi
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_spectre
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against Foreshadow.
_mitigate_tecv_verify_mitigation_foreshadow() {
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "4.19" ; then
		if grep -q "mitigations=off" "/proc/cmdline" ; then
eerror
eerror "Detected mitigations=off in the kernel command line."
eerror
eerror "Acceptable values:"
eerror
eerror "  mitigations=auto         # The Kernel default"
eerror "  mitigations=auto,nosmt"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/defaults/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
		if grep -q "l1tf=off" "/proc/cmdline" ; then
eerror
eerror "Detected l1tf=off in the kernel command line."
eerror
eerror "Acceptable values:"
eerror
eerror "  l1tf=full"
eerror "  l1tf=full,force"
eerror "  l1tf=flush               # The Kernel default"
eerror "  l1tf=flush,nosmt"
eerror "  l1tf=flush,nowarn"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/defaults/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_rfds
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against RDFS.
_mitigate_tecv_verify_mitigation_rfds() {
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "6.9" ; then
		if has_version ">=sys-firmware/intel-microcode-20240312" ; then
			CONFIG_CHECK="
				CPU_SUP_INTEL
			"
			if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" ]] ; then
				WARNING_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for RDFS mitigation on Intel® Atom®."
				check_extra_config
			fi
		elif use cpu_target_x86_atom ; then
			CONFIG_CHECK="
				MITIGATION_RFDS
			"
			if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" ]] ; then
				WARNING_MITIGATION_RFDS="CONFIG_MITIGATION_RFDS or >=sys-firmware/intel-microcode-20240312 is required for RDFS mitigation on Intel® Atom®."
				check_extra_config
			fi
		fi
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_downfall
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against GDS.
_mitigate_tecv_verify_mitigation_downfall() {
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "6.5" ; then
	local L=(
		cpu_target_x86_core_gen6
		cpu_target_x86_core_gen7
		cpu_target_x86_core_gen8
		cpu_target_x86_core_gen9
		cpu_target_x86_core_gen10
		cpu_target_x86_core_gen11
	)
	for x in ${L[@]} ; do
		if has_version ">=sys-firmware/intel-microcode-20230808" ; then
			CONFIG_CHECK="
				CPU_SUP_INTEL
			"
			if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" ]] ; then
				WARNING_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for GDS mitigation on ${x}."
				check_extra_config
			fi
		elif use "${x}" ; then
			# Default off upstream
			CONFIG_CHECK="
				GDS_FORCE_MITIGATION
			"
			if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" ]] ; then
				WARNING_GDS_FORCE_MITIGATION="CONFIG_GDS_FORCE_MITIGATION or >=sys-firmware/intel-microcode-20230808 is required for GDS mitigation on ${x}."
				check_extra_config
			fi
			if grep -q "gather_data_sampling=off" "/proc/cmdline" ; then
eerror
eerror "Detected gather_data_sampling=off in the kernel command line."
eerror "Note:  This will turn off AVX acceleration."
eerror
eerror "Acceptable values:"
eerror
eerror "  gather_data_sampling=force"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/defaults/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
				die
			fi
		fi
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_zenbleed
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against Zenbleed.
_mitigate_tecv_verify_mitigation_zenbleed() {
	if use cpu_target_x86_zen2 && ! has_version ">=sys-kernel/linux-firmware-20231205" ; then
eerror "You need to download >=sys-kernel/linux-firmware-20231205 for Zenbleed mitigation."
		die
	fi
	if use cpu_target_x86_zen2 && has_version ">=sys-kernel/linux-firmware-20231205" ; then
		if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "6.9" ; then
			CONFIG_CHECK="
				CPU_SUP_AMD
			"
			if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" ]] ; then
				WARNING_CPU_SUP_AMD="CONFIG_CPU_SUP_AMD is required for Zenbleed mitigation."
				check_extra_config
			fi
		fi
	fi
}

# @FUNCTION: _mitigate-tecv_check_kernel_flags
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags
_mitigate-tecv_check_kernel_flags() {
	einfo "Kernel version:  ${KV_MAJOR}.${KV_MINOR}"

	# Notify if grub or the kernel config is incorrectly configured/tampered
	# or a copypasta-ed workaround.
	_mitigate_tecv_verify_mitigation_meltdown		# Mitigations against Variant 3 (2017)
	_mitigate_tecv_verify_mitigation_spectre		# Mitigations against Variant 1 (2017), Variant 2 (2017), Variant 4 (2018), BHB (2022), BHI (2022)
	_mitigate_tecv_verify_mitigation_foreshadow		# Mitigations against Variant 5 (2018)
	_mitigate_tecv_verify_mitigation_downfall		# Mitigations against GDS (2022)
	_mitigate_tecv_verify_mitigation_zenbleed		# Mitigations against Zenbleed (2023)
	_mitigate_tecv_verify_mitigation_rfds			# Mitigations against RFDS (2024)
}

# @FUNCTION: _mitigate-tecv_print_required_versions
# @DESCRIPTION:
# Print the required kernel versions for custom-kernel.
_mitigate-tecv_print_required_versions() {
	# For Spectre/Meltdown
	if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" ]] ; then
		if \
			   use cpu_target_x86_atom \
			|| use cpu_target_x86_zen2 \
		; then
ewarn "You are responsible for using only Linux Kernel >= 6.9."
		elif \
			   use cpu_target_x86_core_gen6 \
			|| use cpu_target_x86_core_gen7 \
			|| use cpu_target_x86_core_gen8 \
			|| use cpu_target_x86_core_gen9 \
			|| use cpu_target_x86_core_gen10 \
			|| use cpu_target_x86_core_gen11 \
		; then
ewarn "You are responsible for using only Linux Kernel >= 6.5."
		else
ewarn "You are responsible for using only Linux Kernel >= 4.19."
		fi
	fi
	if [[ "${ARCH}" == "s390" ]] ; then
ewarn "You are responsible for using only Linux Kernel >= 4.15."
	fi
	if [[ "${ARCH}" == "arm64" ]] ; then
		if \
			   use cpu_target_arm_cortex_a15 \
			|| use cpu_target_arm_cortex_a75 \
		; then
ewarn "You are responsible for using only Linux Kernel >= 4.16."
		fi
	fi
}

# @FUNCTION: mitigate-tecv_pkg_setup
# @DESCRIPTION:
# Check the kernel config
mitigate-tecv_pkg_setup() {
	if use kernel_linux ; then
		linux-info_pkg_setup
		_mitigate-tecv_check_kernel_flags
		if use custom-kernel ; then
			_mitigate-tecv_print_required_versions
		fi
	fi
}

# @FUNCTION: mitigate-tecv_pkg_postinst
# @DESCRIPTION:
# Remind user to use only patched kernels especially for large packages.
mitigate-tecv_pkg_postinst() {
	# For Spectre/Meltdown
	if use kernel_linux ; then
		if use custom-kernel ; then
			_mitigate-tecv_print_required_versions
		fi
	fi
}

fi
