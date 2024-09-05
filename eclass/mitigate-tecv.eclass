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

FIRMWARE_VENDOR=""
_mitigate_tecv_set_globals() {
	if [[ -e "/proc/cpuinfo" ]] ; then
		while read -r line ; do
			if [[ "${line}" =~ "AuthenticAMD" ]] ; then
				FIRMWARE_VENDOR="amd"
				break
			fi
			if [[ "${line}" =~ "GenuineIntel" ]] ; then
				FIRMWARE_VENDOR="intel"
				break
			fi
		done < "/proc/cpuinfo"
	fi
}

_mitigate_tecv_set_globals
unset -f _mitigate_tecv_set_globals

CPU_TARGET_X86=(
# For completeness, see also
# https://www.intel.com/content/www/us/en/developer/topic-technology/software-security-guidance/processors-affected-consolidated-product-cpu-model.html
	cpu_target_x86_apollo_lake
	cpu_target_x86_denverton
	cpu_target_x86_snow_ridge_bts
	cpu_target_x86_snow_ridge
	cpu_target_x86_parker_ridge
	cpu_target_x86_elkhart_lake
	cpu_target_x86_arizona_beach
	cpu_target_x86_jasper_lake
	cpu_target_x86_alder_lake_n
	cpu_target_x86_gemini_lake
	cpu_target_x86_core			# Missing documentation so only Meltdown and Spectre mitigated.  Ebuild still can be fixed by user.
	cpu_target_x86_nehalem			# Missing documentation so only Meltdown and Spectre mitigated.  Ebuild still can be fixed by user.
	cpu_target_x86_westmere			# Missing documentation so only Meltdown and Spectre mitigated.  Ebuild still can be fixed by user.
	cpu_target_x86_sandy_bridge		# Missing documentation so only Meltdown and Spectre mitigated.  Ebuild still can be fixed by user.
	cpu_target_x86_ivy_bridge		# Missing documentation so only Meltdown and Spectre mitigated.  Ebuild still can be fixed by user.
	cpu_target_x86_haswell
	cpu_target_x86_broadwell
	cpu_target_x86_skylake
	cpu_target_x86_kaby_lake_gen7
	cpu_target_x86_amber_lake_gen8
	cpu_target_x86_coffee_lake_gen8
	cpu_target_x86_kaby_lake_gen8
	cpu_target_x86_whiskey_lake
	cpu_target_x86_coffee_lake_gen9
	cpu_target_x86_comet_lake
	cpu_target_x86_amber_lake_gen10
	cpu_target_x86_ice_lake
	cpu_target_x86_tiger_lake
	cpu_target_x86_alder_lake
	cpu_target_x86_raptor_lake_gen13
	cpu_target_x86_raptor_lake_gen14
	cpu_target_x86_meteor_lake

	cpu_target_x86_cascade_lake
	cpu_target_x86_cooper_lake
	cpu_target_x86_sapphire_rapids
	cpu_target_x86_sapphire_rapids_edge_enhanced
	cpu_target_x86_granite_rapids
	cpu_target_x86_emerald_rapids

	cpu_target_x86_zen
	cpu_target_x86_zen_plus
	cpu_target_x86_zen_2
	cpu_target_x86_zen_3
	cpu_target_x86_zen_4
)

CPU_TARGET_ARM=(
# See also
# https://developer.arm.com/Arm%20Security%20Center/Speculative%20Processor%20Vulnerability
# https://github.com/torvalds/linux/blob/v6.10/arch/arm64/kernel/cpufeature.c#L1739
	cpu_target_arm_cortex_r7	# BHB
	cpu_target_arm_cortex_r8	# BHB
	cpu_target_arm_cortex_a15	# BHB, Variant 3a
	cpu_target_arm_cortex_a57	# BHB, Variant 3a, Variant 4
	cpu_target_arm_cortex_a65	# BHB
	cpu_target_arm_cortex_a65ae	# BHB
	cpu_target_arm_cortex_a72	# BHB, Variant 3a, Variant 4
	cpu_target_arm_cortex_a73	# BHB, Variant 4
	cpu_target_arm_cortex_a75	# BHB, Variant 3, Variant 4
	cpu_target_arm_cortex_a76	# BHB, Variant 4
	cpu_target_arm_cortex_a77	# BHB, Variant 4
	cpu_target_arm_cortex_a78	# BHB
	cpu_target_arm_cortex_a78c	# BHB
	cpu_target_arm_cortex_a710	# BHB
	cpu_target_arm_cortex_a715	# BHB
	cpu_target_arm_neoverse_e1	# BHB
	cpu_target_arm_neoverse_n1	# BHB, Variant 4
	cpu_target_arm_neoverse_v1	# BHB
	cpu_target_arm_neoverse_n2	# BHB
	cpu_target_arm_neoverse_v2	# BHB
	cpu_target_arm_cortex_x1	# BHB
	cpu_target_arm_cortex_x2	# BHB
	cpu_target_arm_cortex_x3	# BHB
)

CPU_TARGET_PPC=(
	cpu_target_ppc_power7
	cpu_target_ppc_power8
	cpu_target_ppc_power9

	cpu_target_ppc_85xx
	cpu_target_ppc_e500mc

	cpu_target_ppc_e5500
	cpu_target_ppc_e6500
)

inherit linux-info

IUSE+="
	${CPU_TARGET_ARM[@]}
	${CPU_TARGET_PPC[@]}
	${CPU_TARGET_X86[@]}
	auto
	bpf
	custom-kernel
	firmware
	ebuild-revision-4
"
# The !custom-kernel is required for RDEPEND to work properly to download the
# proper kernel version kernel and the proper firmware.
REQUIRED_USE="
	?? (
		auto
		${CPU_TARGET_ARM[@]}
		${CPU_TARGET_PPC[@]}
		${CPU_TARGET_X86[@]}
	)
	auto? (
		!custom-kernel
		firmware
	)
	cpu_target_x86_apollo_lake? (
		firmware
	)
	cpu_target_x86_denverton? (
		firmware
	)
	cpu_target_x86_snow_ridge_bts? (
		firmware
	)
	cpu_target_x86_snow_ridge? (
		firmware
	)
	cpu_target_x86_parker_ridge? (
		firmware
	)
	cpu_target_x86_elkhart_lake? (
		firmware
	)
	cpu_target_x86_arizona_beach? (
		firmware
	)
	cpu_target_x86_jasper_lake? (
		firmware
	)
	cpu_target_x86_alder_lake_n? (
		firmware
	)

	cpu_target_x86_sandy_bridge? (
		firmware
	)
	cpu_target_x86_ivy_bridge? (
		firmware
	)
	cpu_target_x86_haswell? (
		firmware
	)
	cpu_target_x86_broadwell? (
		firmware
	)
	cpu_target_x86_skylake? (
		firmware
	)
	cpu_target_x86_kaby_lake_gen7? (
		firmware
	)
	cpu_target_x86_amber_lake_gen8? (
		firmware
	)
	cpu_target_x86_coffee_lake_gen8? (
		firmware
	)
	cpu_target_x86_kaby_lake_gen8? (
		firmware
	)
	cpu_target_x86_whiskey_lake? (
		firmware
	)
	cpu_target_x86_coffee_lake_gen9? (
		firmware
	)
	cpu_target_x86_comet_lake? (
		firmware
	)
	cpu_target_x86_amber_lake_gen10? (
		firmware
	)
	cpu_target_x86_ice_lake? (
		firmware
	)
	cpu_target_x86_alder_lake? (
		firmware
	)

	cpu_target_x86_cascade_lake? (
		firmware
	)
	cpu_target_x86_cooper_lake? (
		firmware
	)
	cpu_target_x86_sapphire_rapids? (
		firmware
	)
	cpu_target_x86_sapphire_rapids_edge_enhanced? (
		firmware
	)
	cpu_target_x86_granite_rapids? (
		firmware
	)
	cpu_target_x86_emerald_rapids? (
		firmware
	)

	cpu_target_x86_zen_2? (
		firmware
	)
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
			>=sys-kernel/gentoo-kernel-${kv}
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
		!<sys-kernel/gentoo-kernel-${kv}
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


# Mitigated with RFI flush not KPTI
_MITIGATE_TECV_MELTDOWN_RDEPEND_PPC64="
	cpu_target_ppc_power7? (
		$(gen_patched_kernel_list 4.15)
	)
	cpu_target_ppc_power8? (
		$(gen_patched_kernel_list 4.15)
	)
	cpu_target_ppc_power9? (
		$(gen_patched_kernel_list 4.15)
	)
"

# Based on D
_MITIGATE_TECV_SPECTRE_RDEPEND_X86_64="
	$(gen_patched_kernel_list 4.15)
	cpu_target_x86_apollo_lake? (
		>=sys-firmware/intel-microcode-20180312
	)
	cpu_target_x86_denverton? (
		>=sys-firmware/intel-microcode-20180312
	)

	cpu_target_x86_gemini_lake? (
		>=sys-firmware/intel-microcode-20180312
	)

	cpu_target_x86_sandy_bridge? (
		>=sys-firmware/intel-microcode-20180312
	)
	cpu_target_x86_ivy_bridge? (
		>=sys-firmware/intel-microcode-20180312
	)
	cpu_target_x86_haswell? (
		>=sys-firmware/intel-microcode-20180312
	)
	cpu_target_x86_broadwell? (
		>=sys-firmware/intel-microcode-20180312
	)
	cpu_target_x86_skylake? (
		>=sys-firmware/intel-microcode-20180312
	)
	cpu_target_x86_kaby_lake_gen7? (
		>=sys-firmware/intel-microcode-20180312
	)
	cpu_target_x86_amber_lake_gen8? (
		>=sys-firmware/intel-microcode-20180312
	)
	cpu_target_x86_coffee_lake_gen8? (
		>=sys-firmware/intel-microcode-20180312
	)
	cpu_target_x86_kaby_lake_gen8? (
		>=sys-firmware/intel-microcode-20180312
	)
	cpu_target_x86_whiskey_lake? (
		>=sys-firmware/intel-microcode-20180312
	)
	cpu_target_x86_coffee_lake_gen9? (
		>=sys-firmware/intel-microcode-20180610
	)

	cpu_target_x86_cascade_lake? (
		>=sys-firmware/intel-microcode-20180610
	)
	cpu_target_x86_cooper_lake? (
		>=sys-firmware/intel-microcode-20180610
	)
	cpu_target_x86_sapphire_rapids? (
		>=sys-firmware/intel-microcode-20180610
	)
	cpu_target_x86_sapphire_rapids_edge_enhanced? (
		>=sys-firmware/intel-microcode-20180610
	)
	cpu_target_x86_granite_rapids? (
		>=sys-firmware/intel-microcode-20180610
	)
	cpu_target_x86_emerald_rapids? (
		>=sys-firmware/intel-microcode-20180610
	)

	bpf? (
		$(gen_patched_kernel_list 5.13)
	)
"
_MITIGATE_TECV_SPECTRE_RDEPEND_X86_32="
	${_MITIGATE_TECV_SPECTRE_RDEPEND_X86_64}
"
_MITIGATE_TECV_MELTDOWN_RDEPEND_X86_64="
	$(gen_patched_kernel_list 4.15)
	cpu_target_x86_sandy_bridge? (
		$(gen_patched_kernel_list 4.15)
	)
	cpu_target_x86_ivy_bridge? (
		$(gen_patched_kernel_list 4.15)
	)
	cpu_target_x86_haswell? (
		$(gen_patched_kernel_list 4.15)
	)
	cpu_target_x86_broadwell? (
		$(gen_patched_kernel_list 4.15)
	)
	cpu_target_x86_skylake? (
		$(gen_patched_kernel_list 4.15)
	)
	cpu_target_x86_kaby_lake_gen7? (
		$(gen_patched_kernel_list 4.15)
	)
	cpu_target_x86_amber_lake_gen8? (
		$(gen_patched_kernel_list 4.15)
	)
	cpu_target_x86_coffee_lake_gen8? (
		$(gen_patched_kernel_list 4.15)
	)
	cpu_target_x86_kaby_lake_gen8? (
		$(gen_patched_kernel_list 4.15)
	)
	cpu_target_x86_whiskey_lake? (
		$(gen_patched_kernel_list 4.15)
	)
	cpu_target_x86_gemini_lake? (
		$(gen_patched_kernel_list 4.15)
	)
"
_MITIGATE_TECV_MELTDOWN_RDEPEND_ARM64="
	cpu_target_arm_cortex_a75? (
		$(gen_patched_kernel_list 4.16)
	)
"
# Variant 3a (4.16), Variant 4 (4.18) \
_MITIGATE_TECV_SPECTRE_NG_RDEPEND_ARM64="
	cpu_target_arm_cortex_a15? (
		$(gen_patched_kernel_list 4.16)
	)

	cpu_target_arm_cortex_a57? (
		$(gen_patched_kernel_list 4.18)
	)
	cpu_target_arm_cortex_a72? (
		$(gen_patched_kernel_list 4.18)
	)
	cpu_target_arm_cortex_a75? (
		$(gen_patched_kernel_list 4.18)
	)
	cpu_target_arm_cortex_a76? (
		$(gen_patched_kernel_list 4.18)
	)
	cpu_target_arm_cortex_a77? (
		$(gen_patched_kernel_list 4.18)
	)
	cpu_target_arm_neoverse_n1? (
		$(gen_patched_kernel_list 4.18)
	)
	bpf? (
		$(gen_patched_kernel_list 5.13)
	)
"

# Firmware date based on D distro even though it may be removed from microcode repo.
# List for mitigations against Variant 4 and Variant 3a
_MITIGATE_TECV_SPECTRE_NG_RDEPEND_X86_64="
	cpu_target_x86_gemini_lake? (
		$(gen_patched_kernel_list 4.17)
		firmware? (
			>=sys-firmware/intel-microcode-20180703
		)
	)
	cpu_target_x86_haswell? (
		$(gen_patched_kernel_list 4.17)
		firmware? (
			>=sys-firmware/intel-microcode-20180703
		)
	)
	cpu_target_x86_broadwell? (
		$(gen_patched_kernel_list 4.17)
		firmware? (
			>=sys-firmware/intel-microcode-20180703
		)
	)
	cpu_target_x86_skylake? (
		$(gen_patched_kernel_list 4.17)
		firmware? (
			>=sys-firmware/intel-microcode-20180703
		)
	)
	cpu_target_x86_kaby_lake_gen7? (
		$(gen_patched_kernel_list 4.17)
		firmware? (
			>=sys-firmware/intel-microcode-20180703
		)
	)
	cpu_target_x86_amber_lake_gen8? (
		$(gen_patched_kernel_list 4.17)
		firmware? (
			>=sys-firmware/intel-microcode-20180703
		)
	)
	cpu_target_x86_coffee_lake_gen8? (
		$(gen_patched_kernel_list 4.17)
		firmware? (
			>=sys-firmware/intel-microcode-20180703
		)
	)
	cpu_target_x86_kaby_lake_gen8? (
		$(gen_patched_kernel_list 4.17)
		firmware? (
			>=sys-firmware/intel-microcode-20180703
		)
	)
	cpu_target_x86_whiskey_lake? (
		$(gen_patched_kernel_list 4.17)
		firmware? (
			>=sys-firmware/intel-microcode-20180703
		)
	)
	cpu_target_x86_coffee_lake_gen9? (
		$(gen_patched_kernel_list 4.17)
		firmware? (
			>=sys-firmware/intel-microcode-20180703
		)
	)
	cpu_target_x86_comet_lake? (
		$(gen_patched_kernel_list 4.17)
		firmware? (
			>=sys-firmware/intel-microcode-20180703
		)
	)
	cpu_target_x86_amber_lake_gen10? (
		$(gen_patched_kernel_list 4.17)
		firmware? (
			>=sys-firmware/intel-microcode-20180703
		)
	)
	cpu_target_x86_ice_lake? (
		$(gen_patched_kernel_list 4.17)
		firmware? (
			>=sys-firmware/intel-microcode-20180703
		)
	)
	cpu_target_x86_tiger_lake? (
		$(gen_patched_kernel_list 4.17)
	)
	cpu_target_x86_alder_lake? (
		$(gen_patched_kernel_list 4.17)
	)
	cpu_target_x86_raptor_lake_gen13? (
		$(gen_patched_kernel_list 4.17)
	)
	cpu_target_x86_raptor_lake_gen14? (
		$(gen_patched_kernel_list 4.17)
	)
	cpu_target_x86_meteor_lake? (
		$(gen_patched_kernel_list 4.17)
	)

	cpu_target_x86_cascade_lake? (
		$(gen_patched_kernel_list 4.17)
	)
	cpu_target_x86_cooper_lake? (
		$(gen_patched_kernel_list 4.17)
	)
	cpu_target_x86_sapphire_rapids? (
		$(gen_patched_kernel_list 4.17)
	)
	cpu_target_x86_sapphire_rapids_edge_enhanced? (
		$(gen_patched_kernel_list 4.17)
	)
	cpu_target_x86_granite_rapids? (
		$(gen_patched_kernel_list 4.17)
	)
	cpu_target_x86_emerald_rapids? (
		$(gen_patched_kernel_list 4.17)
	)

	bpf? (
		$(gen_patched_kernel_list 5.13)
	)
"
_MITIGATE_TECV_SPECTRE_NG_RDEPEND_X86_32="
	${_MITIGATE_TECV_SPECTRE_NG_RDEPEND_X86_64}
"

_MITIGATE_TECV_SPECTRE_RDEPEND_S390X="
	$(gen_patched_kernel_list 4.16)
	bpf? (
		$(gen_patched_kernel_list 5.13)
	)
"

_MITIGATE_TECV_SPECTRE_RSB_RDEPEND_X86_64="
	cpu_target_x86_skylake? (
		$(gen_patched_kernel_list 4.19)
	)
	cpu_target_x86_kaby_lake_gen7? (
		$(gen_patched_kernel_list 4.19)
	)
	cpu_target_x86_amber_lake_gen8? (
		$(gen_patched_kernel_list 4.19)
	)
	cpu_target_x86_coffee_lake_gen8? (
		$(gen_patched_kernel_list 4.19)
	)
	cpu_target_x86_kaby_lake_gen8? (
		$(gen_patched_kernel_list 4.19)
	)
	cpu_target_x86_whiskey_lake? (
		$(gen_patched_kernel_list 4.19)
	)
	cpu_target_x86_coffee_lake_gen9? (
		$(gen_patched_kernel_list 4.19)
	)
	cpu_target_x86_comet_lake? (
		$(gen_patched_kernel_list 4.19)
	)
	cpu_target_x86_amber_lake_gen10? (
		$(gen_patched_kernel_list 4.19)
	)
	cpu_target_x86_ice_lake? (
		$(gen_patched_kernel_list 4.19)
	)
	cpu_target_x86_alder_lake? (
		$(gen_patched_kernel_list 4.19)
	)
	cpu_target_x86_raptor_lake_gen13? (
		$(gen_patched_kernel_list 4.19)
	)
	cpu_target_x86_raptor_lake_gen14? (
		$(gen_patched_kernel_list 4.19)
	)
	cpu_target_x86_meteor_lake? (
		$(gen_patched_kernel_list 4.19)
	)

	cpu_target_x86_cascade_lake? (
		$(gen_patched_kernel_list 4.19)
	)
	cpu_target_x86_cooper_lake? (
		$(gen_patched_kernel_list 4.19)
	)
	cpu_target_x86_sapphire_rapids? (
		$(gen_patched_kernel_list 4.19)
	)
	cpu_target_x86_sapphire_rapids_edge_enhanced? (
		$(gen_patched_kernel_list 4.19)
	)
	cpu_target_x86_granite_rapids? (
		$(gen_patched_kernel_list 4.19)
	)
	cpu_target_x86_emerald_rapids? (
		$(gen_patched_kernel_list 4.19)
	)

"
_MITIGATE_TECV_SPECTRE_RSB_RDEPEND_X86_32="
	${_MITIGATE_TECV_SPECTRE_RSB_RDEPEND_X86_64}
"


_MITIGATE_TECV_FORESHADOW_RDEPEND_X86_64="
	cpu_target_x86_core? (
		$(gen_patched_kernel_list 4.19)
		firmware? (
			>=sys-firmware/intel-microcode-20180807
		)
	)
	cpu_target_x86_nehalem? (
		$(gen_patched_kernel_list 4.19)
		firmware? (
			>=sys-firmware/intel-microcode-20180807
		)
	)
	cpu_target_x86_westmere? (
		$(gen_patched_kernel_list 4.19)
		firmware? (
			>=sys-firmware/intel-microcode-20180807
		)
	)
	cpu_target_x86_sandy_bridge? (
		$(gen_patched_kernel_list 4.19)
		firmware? (
			>=sys-firmware/intel-microcode-20180807
		)
	)
	cpu_target_x86_ivy_bridge? (
		$(gen_patched_kernel_list 4.19)
		firmware? (
			>=sys-firmware/intel-microcode-20180807
		)
	)
	cpu_target_x86_haswell? (
		$(gen_patched_kernel_list 4.19)
		firmware? (
			>=sys-firmware/intel-microcode-20180807
		)
	)
	cpu_target_x86_broadwell? (
		$(gen_patched_kernel_list 4.19)
		firmware? (
			>=sys-firmware/intel-microcode-20180807
		)
	)
	cpu_target_x86_skylake? (
		$(gen_patched_kernel_list 4.19)
		firmware? (
			>=sys-firmware/intel-microcode-20180807
		)
	)
	cpu_target_x86_kaby_lake_gen7? (
		$(gen_patched_kernel_list 4.19)
		firmware? (
			>=sys-firmware/intel-microcode-20180807
		)
	)
	cpu_target_x86_amber_lake_gen8? (
		$(gen_patched_kernel_list 4.19)
		firmware? (
			>=sys-firmware/intel-microcode-20180807
		)
	)
	cpu_target_x86_coffee_lake_gen8? (
		$(gen_patched_kernel_list 4.19)
		firmware? (
			>=sys-firmware/intel-microcode-20180807
		)
	)
	cpu_target_x86_kaby_lake_gen8? (
		$(gen_patched_kernel_list 4.19)
		firmware? (
			>=sys-firmware/intel-microcode-20180807
		)
	)
"
_MITIGATE_TECV_FORESHADOW_RDEPEND_X86_32="
	${_MITIGATE_TECV_FORESHADOW_RDEPEND_X86_64}
"


_MITIGATE_TECV_SPECTRE_RDEPEND_PPC32="
	cpu_target_ppc_85xx? (
		$(gen_patched_kernel_list 5.0)
	)
	cpu_target_ppc_e500mc? (
		$(gen_patched_kernel_list 5.0)
	)
"

_MITIGATE_TECV_SPECTRE_RDEPEND_PPC64="
	cpu_target_ppc_e5500? (
		$(gen_patched_kernel_list 5.0)
	)
	cpu_target_ppc_e6500? (
		$(gen_patched_kernel_list 5.0)
	)
"

# MFBDS, MLPDS, MSBDS
_MITIGATE_TECV_MDS_RDEPEND_X86_64="
	cpu_target_x86_haswell? (
		$(gen_patched_kernel_list 5.2)
		firmware? (
			>=sys-firmware/intel-microcode-20190618
		)
	)
	cpu_target_x86_broadwell? (
		$(gen_patched_kernel_list 5.2)
		firmware? (
			>=sys-firmware/intel-microcode-20190618
		)
	)
	cpu_target_x86_skylake? (
		$(gen_patched_kernel_list 5.2)
		firmware? (
			>=sys-firmware/intel-microcode-20190618
		)
	)
	cpu_target_x86_kaby_lake_gen7? (
		$(gen_patched_kernel_list 5.2)
		firmware? (
			>=sys-firmware/intel-microcode-20190618
		)
	)
	cpu_target_x86_amber_lake_gen8? (
		$(gen_patched_kernel_list 5.2)
		firmware? (
			>=sys-firmware/intel-microcode-20190618
		)
	)
	cpu_target_x86_coffee_lake_gen8? (
		$(gen_patched_kernel_list 5.2)
		firmware? (
			>=sys-firmware/intel-microcode-20190618
		)
	)
	cpu_target_x86_kaby_lake_gen8? (
		$(gen_patched_kernel_list 5.2)
		firmware? (
			>=sys-firmware/intel-microcode-20190618
		)
	)
	cpu_target_x86_whiskey_lake? (
		$(gen_patched_kernel_list 5.2)
		firmware? (
			>=sys-firmware/intel-microcode-20190618
		)
	)
	cpu_target_x86_coffee_lake_gen9? (
		$(gen_patched_kernel_list 5.2)
		firmware? (
			>=sys-firmware/intel-microcode-20190618
		)

	cpu_target_x86_comet_lake? (
		$(gen_patched_kernel_list 5.2)
		firmware? (
			>=sys-firmware/intel-microcode-20190618
		)
	)
	cpu_target_x86_ice_lake? (
		$(gen_patched_kernel_list 5.2)
		firmware? (
			>=sys-firmware/intel-microcode-20190618
		)
	)
"
_MITIGATE_TECV_MDS_RDEPEND_X86_32="
	${_MITIGATE_TECV_MDS_RDEPEND_X86_64}
"

_MITIGATE_TECV_SWAPGS_RDEPEND_X86_64="
	cpu_target_x86_apollo_lake? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_denverton? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_snow_ridge_bts? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_snow_ridge? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_parker_ridge? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_elkhart_lake? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_arizona_beach? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_jasper_lake? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_alder_lake_n? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_gemini_lake? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_haswell? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_broadwell? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_skylake? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_kaby_lake_gen7? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_amber_lake_gen8? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_coffee_lake_gen8? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_kaby_lake_gen8? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_whiskey_lake? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_coffee_lake_gen9? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_comet_lake? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_amber_lake_gen10? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_ice_lake? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_tiger_lake? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_alder_lake? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_raptor_lake_gen13? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_raptor_lake_gen14? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_meteor_lake? (
		$(gen_patched_kernel_list 5.3)
	)

	cpu_target_x86_cascade_lake? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_cooper_lake? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_sapphire_rapids? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_sapphire_rapids_edge_enhanced? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_granite_rapids? (
		$(gen_patched_kernel_list 5.3)
	)
	cpu_target_x86_emerald_rapids? (
		$(gen_patched_kernel_list 5.3)
	)

"
_MITIGATE_TECV_SWAPGS_RDEPEND_X86_32="
	${_MITIGATE_TECV_SWAPGS_RDEPEND_X86_64}
"

# Only >= Gen6 firmware
_MITIGATE_TECV_ZOMBIELOAD_V2_RDEPEND_X86_64="
	cpu_target_x86_haswell? (
		$(gen_patched_kernel_list 5.4)
	)
	cpu_target_x86_broadwell? (
		$(gen_patched_kernel_list 5.4)
	)
	cpu_target_x86_skylake? (
		$(gen_patched_kernel_list 5.4)
		firmware? (
			>=sys-firmware/intel-microcode-20191112
		)
	)
	cpu_target_x86_kaby_lake_gen7? (
		$(gen_patched_kernel_list 5.4)
		firmware? (
			>=sys-firmware/intel-microcode-20191112
		)
	)
	cpu_target_x86_amber_lake_gen8? (
		$(gen_patched_kernel_list 5.4)
		firmware? (
			>=sys-firmware/intel-microcode-20191112
		)
	)
	cpu_target_x86_coffee_lake_gen8? (
		$(gen_patched_kernel_list 5.4)
		firmware? (
			>=sys-firmware/intel-microcode-20191112
		)
	)
	cpu_target_x86_kaby_lake_gen8? (
		$(gen_patched_kernel_list 5.4)
		firmware? (
			>=sys-firmware/intel-microcode-20191112
		)
	)
	cpu_target_x86_whiskey_lake? (
		$(gen_patched_kernel_list 5.4)
		firmware? (
			>=sys-firmware/intel-microcode-20191112
		)
	)
	cpu_target_x86_coffee_lake_gen9? (
		$(gen_patched_kernel_list 5.4)
		firmware? (
			>=sys-firmware/intel-microcode-20191112
		)
	)
	cpu_target_x86_amber_lake_gen10? (
		$(gen_patched_kernel_list 5.4)
		firmware? (
			>=sys-firmware/intel-microcode-20191112
		)
	)

	cpu_target_x86_cascade_lake? (
		$(gen_patched_kernel_list 5.4)
		firmware? (
			>=sys-firmware/intel-microcode-20191112
		)
	)
"
_MITIGATE_TECV_ZOMBIELOAD_V2_RDEPEND_X86_32="
	${_MITIGATE_TECV_ZOMBIELOAD_V2_RDEPEND_X86_64}
"

_MITIGATE_TECV_CACHEOUT_RDEPEND_X86_64="
	cpu_target_x86_skylake? (
		firmware? (
			>=sys-firmware/intel-microcode-20200609
		)
	)
	cpu_target_x86_kaby_lake_gen7? (
		firmware? (
			>=sys-firmware/intel-microcode-20200609
		)
	)
	cpu_target_x86_coffee_lake_gen8? (
		firmware? (
			>=sys-firmware/intel-microcode-20200609
		)
	)
	cpu_target_x86_kaby_lake_gen8? (
		firmware? (
			>=sys-firmware/intel-microcode-20200609
		)
	)
	cpu_target_x86_whiskey_lake? (
		firmware? (
			>=sys-firmware/intel-microcode-20200609
		)
	)
	cpu_target_x86_coffee_lake_gen9? (
		firmware? (
			>=sys-firmware/intel-microcode-20200609
		)
	)
	cpu_target_x86_comet_lake? (
		firmware? (
			>=sys-firmware/intel-microcode-20200609
		)
	)
	cpu_target_x86_ice_lake? (
		firmware? (
			>=sys-firmware/intel-microcode-20200609
		)
	)

	cpu_target_x86_cascade_lake? (
		firmware? (
			>=sys-firmware/intel-microcode-20200609
		)
	)

"
_MITIGATE_TECV_CACHEOUT_RDEPEND_X86_32="
	${_MITIGATE_TECV_CACHEOUT_RDEPEND_X86_64}
"

# See commit 80eb5fe
_MITIGATE_TECV_SPECTRE_RSB_RDEPEND_PPC64="
	$(gen_patched_kernel_list 5.5)
"
_MITIGATE_TECV_SPECTRE_RSB_RDEPEND_PPC32="
	${_MITIGATE_TECV_SPECTRE_RSB_RDEPEND_PPC64}
"

_MITIGATE_TECV_CROSSTALK_RDEPEND_X86_64="
	cpu_target_x86_skylake? (
		$(gen_patched_kernel_list 5.8)
		firmware? (
			>=sys-firmware/intel-microcode-20200609
		)
	)
	cpu_target_x86_kaby_lake_gen7? (
		$(gen_patched_kernel_list 5.8)
		firmware? (
			>=sys-firmware/intel-microcode-20200609
		)
	)
	cpu_target_x86_amber_lake_gen8? (
		$(gen_patched_kernel_list 5.8)
		firmware? (
			>=sys-firmware/intel-microcode-20200609
		)
	)
	cpu_target_x86_coffee_lake_gen8? (
		$(gen_patched_kernel_list 5.8)
		firmware? (
			>=sys-firmware/intel-microcode-20200609
		)
	)
	cpu_target_x86_kaby_lake_gen8? (
		$(gen_patched_kernel_list 5.8)
		firmware? (
			>=sys-firmware/intel-microcode-20200609
		)
	)
	cpu_target_x86_whiskey_lake? (
		$(gen_patched_kernel_list 5.8)
		firmware? (
			>=sys-firmware/intel-microcode-20200609
		)
	)
	cpu_target_x86_coffee_lake_gen9? (
		$(gen_patched_kernel_list 5.8)
		firmware? (
			>=sys-firmware/intel-microcode-20200609
		)
	)
	cpu_target_x86_amber_lake_gen10? (
		$(gen_patched_kernel_list 5.8)
		firmware? (
			>=sys-firmware/intel-microcode-20200609
		)
	)
"
_MITIGATE_TECV_CROSSTALK_RDEPEND_X86_32="
	${_MITIGATE_TECV_CROSSTALK_RDEPEND_X86_64}
"

_MITIGATE_TECV_SPECTRE_RDEPEND_ARM64="
	bpf? (
		$(gen_patched_kernel_list 5.13)
	)
"

_MITIGATE_TECV_MMIO_RDEPEND_X86_64="
	cpu_target_x86_snow_ridge_bts? (
		$(gen_patched_kernel_list 5.19)
		firmware? (
			>=sys-firmware/intel-microcode-20220510
		)
	)
	cpu_target_x86_snow_ridge? (
		$(gen_patched_kernel_list 5.19)
		firmware? (
			>=sys-firmware/intel-microcode-20220510
		)
	)
	cpu_target_x86_parker_ridge? (
		$(gen_patched_kernel_list 5.19)
		firmware? (
			>=sys-firmware/intel-microcode-20220510
		)
	)
	cpu_target_x86_elkhart_lake? (
		$(gen_patched_kernel_list 5.19)
		firmware? (
			>=sys-firmware/intel-microcode-20220510
		)
	)
	cpu_target_x86_jasper_lake? (
		$(gen_patched_kernel_list 5.19)
		firmware? (
			>=sys-firmware/intel-microcode-20220510
		)
	)

	cpu_target_x86_haswell? (
		$(gen_patched_kernel_list 5.19)
		firmware? (
			>=sys-firmware/intel-microcode-20220510
		)
	)
	cpu_target_x86_broadwell? (
		$(gen_patched_kernel_list 5.19)
		firmware? (
			>=sys-firmware/intel-microcode-20220510
		)
	)
	cpu_target_x86_skylake? (
		$(gen_patched_kernel_list 5.19)
		firmware? (
			>=sys-firmware/intel-microcode-20220510
		)
	)
	cpu_target_x86_kaby_lake_gen7? (
		$(gen_patched_kernel_list 5.19)
		firmware? (
			>=sys-firmware/intel-microcode-20220510
		)
	)
	cpu_target_x86_amber_lake_gen8? (
		$(gen_patched_kernel_list 5.19)
		firmware? (
			>=sys-firmware/intel-microcode-20220510
		)
	)
	cpu_target_x86_coffee_lake_gen8? (
		$(gen_patched_kernel_list 5.19)
		firmware? (
			>=sys-firmware/intel-microcode-20220510
		)
	)
	cpu_target_x86_kaby_lake_gen8? (
		$(gen_patched_kernel_list 5.19)
		firmware? (
			>=sys-firmware/intel-microcode-20220510
		)
	)
	cpu_target_x86_whiskey_lake? (
		$(gen_patched_kernel_list 5.19)
		firmware? (
			>=sys-firmware/intel-microcode-20220510
		)
	)
	cpu_target_x86_coffee_lake_gen9? (
		$(gen_patched_kernel_list 5.19)
		firmware? (
			>=sys-firmware/intel-microcode-20220510
		)
	)
	cpu_target_x86_comet_lake? (
		$(gen_patched_kernel_list 5.19)
		firmware? (
			>=sys-firmware/intel-microcode-20220510
		)
	)
	cpu_target_x86_amber_lake_gen10? (
		$(gen_patched_kernel_list 5.19)
		firmware? (
			>=sys-firmware/intel-microcode-20220510
		)
	)
	cpu_target_x86_ice_lake? (
		$(gen_patched_kernel_list 5.19)
		firmware? (
			>=sys-firmware/intel-microcode-20220510
		)
	)
	cpu_target_x86_tiger_lake? (
		$(gen_patched_kernel_list 5.19)
		firmware? (
			>=sys-firmware/intel-microcode-20220510
		)
	)

	cpu_target_x86_cascade_lake? (
		$(gen_patched_kernel_list 5.19)
		firmware? (
			>=sys-firmware/intel-microcode-20220510
		)
	)
	cpu_target_x86_cooper_lake? (
		$(gen_patched_kernel_list 5.19)
		firmware? (
			>=sys-firmware/intel-microcode-20220510
		)
	)
"
_MITIGATE_TECV_MMIO_RDEPEND_X86_32="
	${_MITIGATE_TECV_MMIO_RDEPEND_X86_64}
"

_MITIGATE_TECV_RETBLEED_RDEPEND_X86_64="
	cpu_target_x86_skylake? (
		$(gen_patched_kernel_list 5.19)
	)
	cpu_target_x86_kaby_lake_gen7? (
		$(gen_patched_kernel_list 5.19)
	)
	cpu_target_x86_amber_lake_gen8? (
		$(gen_patched_kernel_list 5.19)
	)
	cpu_target_x86_coffee_lake_gen8? (
		$(gen_patched_kernel_list 5.19)
	)
	cpu_target_x86_kaby_lake_gen8? (
		$(gen_patched_kernel_list 5.19)
	)
	cpu_target_x86_whiskey_lake? (
		$(gen_patched_kernel_list 5.19)
	)
	cpu_target_x86_amber_lake_gen10? (
		$(gen_patched_kernel_list 5.19)
	)
	cpu_target_x86_zen? (
		$(gen_patched_kernel_list 5.19)
	)
	cpu_target_x86_zen_plus? (
		$(gen_patched_kernel_list 5.19)
	)
	cpu_target_x86_zen_2? (
		$(gen_patched_kernel_list 5.19)
	)
"

_MITIGATE_TECV_BHB_RDEPEND_ARM64="
	cpu_target_arm_cortex_r7? (
		$(gen_patched_kernel_list 6.1)
	)
	cpu_target_arm_cortex_r8? (
		$(gen_patched_kernel_list 6.1)
	)
	cpu_target_arm_cortex_a15? (
		$(gen_patched_kernel_list 6.1)
	)
	cpu_target_arm_cortex_a57? (
		$(gen_patched_kernel_list 6.1)
	)
	cpu_target_arm_cortex_a65? (
		$(gen_patched_kernel_list 6.1)
	)
	cpu_target_arm_cortex_a65ae? (
		$(gen_patched_kernel_list 6.1)
	)
	cpu_target_arm_cortex_a72? (
		$(gen_patched_kernel_list 6.1)
	)
	cpu_target_arm_cortex_a73? (
		$(gen_patched_kernel_list 6.1)
	)
	cpu_target_arm_cortex_a75? (
		$(gen_patched_kernel_list 6.1)
	)
	cpu_target_arm_cortex_a76? (
		$(gen_patched_kernel_list 6.1)
	)
	cpu_target_arm_cortex_a77? (
		$(gen_patched_kernel_list 6.1)
	)
	cpu_target_arm_cortex_a78? (
		$(gen_patched_kernel_list 6.1)
	)
	cpu_target_arm_cortex_a78c? (
		$(gen_patched_kernel_list 6.1)
	)
	cpu_target_arm_cortex_a710? (
		$(gen_patched_kernel_list 6.1)
	)
	cpu_target_arm_cortex_a715? (
		$(gen_patched_kernel_list 6.1)
	)
	cpu_target_arm_neoverse_e1? (
		$(gen_patched_kernel_list 6.1)
	)
	cpu_target_arm_neoverse_n1? (
		$(gen_patched_kernel_list 6.1)
	)
	cpu_target_arm_neoverse_v1? (
		$(gen_patched_kernel_list 6.1)
	)
	cpu_target_arm_neoverse_n2? (
		$(gen_patched_kernel_list 6.1)
	)
	cpu_target_arm_neoverse_v2? (
		$(gen_patched_kernel_list 6.1)
	)
	cpu_target_arm_cortex_x1? (
		$(gen_patched_kernel_list 6.1)
	)
	cpu_target_arm_cortex_x2? (
		$(gen_patched_kernel_list 6.1)
	)
	cpu_target_arm_cortex_x3? (
		$(gen_patched_kernel_list 6.1)
	)
"

_MITIGATE_TECV_DOWNFALL_RDEPEND_X86_64="
	cpu_target_x86_skylake? (
		$(gen_patched_kernel_list 6.5)
		firmware? (
			>=sys-firmware/intel-microcode-20230808
		)
	)
	cpu_target_x86_kaby_lake_gen7? (
		$(gen_patched_kernel_list 6.5)
		firmware? (
			>=sys-firmware/intel-microcode-20230808
		)
	)
	cpu_target_x86_amber_lake_gen8? (
		$(gen_patched_kernel_list 6.5)
		firmware? (
			>=sys-firmware/intel-microcode-20230808
		)
	)
	cpu_target_x86_coffee_lake_gen8? (
		$(gen_patched_kernel_list 6.5)
		firmware? (
			>=sys-firmware/intel-microcode-20230808
		)
	)
	cpu_target_x86_kaby_lake_gen8? (
		$(gen_patched_kernel_list 6.5)
		firmware? (
			>=sys-firmware/intel-microcode-20230808
		)
	)
	cpu_target_x86_whiskey_lake? (
		$(gen_patched_kernel_list 6.5)
		firmware? (
			>=sys-firmware/intel-microcode-20230808
		)
	)
	cpu_target_x86_coffee_lake_gen9? (
		$(gen_patched_kernel_list 6.5)
		firmware? (
			>=sys-firmware/intel-microcode-20230808
		)
	)
	cpu_target_x86_comet_lake? (
		$(gen_patched_kernel_list 6.5)
		firmware? (
			>=sys-firmware/intel-microcode-20230808
		)
	)
	cpu_target_x86_amber_lake_gen10? (
		$(gen_patched_kernel_list 6.5)
		firmware? (
			>=sys-firmware/intel-microcode-20230808
		)
	)
	cpu_target_x86_ice_lake? (
		$(gen_patched_kernel_list 6.5)
		firmware? (
			>=sys-firmware/intel-microcode-20230808
		)
	)
	cpu_target_x86_tiger_lake? (
		$(gen_patched_kernel_list 6.5)
		firmware? (
			>=sys-firmware/intel-microcode-20230808
		)
	)

	cpu_target_x86_cascade_lake? (
		$(gen_patched_kernel_list 6.5)
		firmware? (
			>=sys-firmware/intel-microcode-20230808
		)
	)
	cpu_target_x86_cooper_lake? (
		$(gen_patched_kernel_list 6.5)
		firmware? (
			>=sys-firmware/intel-microcode-20230808
		)
	)

"
_MITIGATE_TECV_DOWNFALL_RDEPEND_X86_32="
	${_MITIGATE_TECV_DOWNFALL_RDEPEND_X86_64}
"

_MITIGATE_TECV_INCEPTION_RDEPEND_X86_64="
	cpu_target_x86_zen_4? (
		$(gen_patched_kernel_list 6.9)
	)
	cpu_target_x86_zen_3? (
		$(gen_patched_kernel_list 6.9)
	)
	cpu_target_x86_zen_2? (
		$(gen_patched_kernel_list 6.5)
	)
	cpu_target_x86_zen? (
		$(gen_patched_kernel_list 6.5)
	)
"
_MITIGATE_TECV_INCEPTION_RDEPEND_X86_32="
	${_MITIGATE_TECV_ZENBLEED_RDEPEND_X86_64}
"

_MITIGATE_TECV_RDFS_RDEPEND_X86_64="
	cpu_target_x86_apollo_lake? (
		$(gen_patched_kernel_list 6.9)
		firmware? (
			>=sys-firmware/intel-microcode-20240312
		)
	)
	cpu_target_x86_denverton? (
		$(gen_patched_kernel_list 6.9)
		firmware? (
			>=sys-firmware/intel-microcode-20240312
		)
	)
	cpu_target_x86_snow_ridge? (
		$(gen_patched_kernel_list 6.9)
		firmware? (
			>=sys-firmware/intel-microcode-20240312
		)
	)
	cpu_target_x86_parker_ridge? (
		$(gen_patched_kernel_list 6.9)
		firmware? (
			>=sys-firmware/intel-microcode-20240312
		)
	)
	cpu_target_x86_elkhart_lake? (
		$(gen_patched_kernel_list 6.9)
		firmware? (
			>=sys-firmware/intel-microcode-20240312
		)
	)
	cpu_target_x86_arizona_beach? (
		$(gen_patched_kernel_list 6.9)
		firmware? (
			>=sys-firmware/intel-microcode-20240312
		)
	)
	cpu_target_x86_jasper_lake? (
		$(gen_patched_kernel_list 6.9)
		firmware? (
			>=sys-firmware/intel-microcode-20240312
		)
	)
	cpu_target_x86_alder_lake_n? (
		$(gen_patched_kernel_list 6.9)
		firmware? (
			>=sys-firmware/intel-microcode-20240312
		)
	)
"
_MITIGATE_TECV_RDFS_RDEPEND_X86_32="
	${_MITIGATE_TECV_RDFS_RDEPEND_X86_64}
"


_MITIGATE_TECV_ZENBLEED_RDEPEND_X86_64="
	cpu_target_x86_zen_2? (
		$(gen_patched_kernel_list 6.9)
		firmware? (
			>=sys-kernel/linux-firmware-20231205
		)
	)

"
_MITIGATE_TECV_ZENBLEED_RDEPEND_X86_32="
	${_MITIGATE_TECV_ZENBLEED_RDEPEND_X86_64}
"

# The 12th Gen needs microcode but it is not documented for the version
# requirement.  The date of the advisory is used as a placeholder.
_MITIGATE_TECV_BHI_RDEPEND_X86_64="
	cpu_target_x86_gemini_lake? (
		$(gen_patched_kernel_list 6.9)
	)
	cpu_target_x86_amber_lake_gen8? (
		$(gen_patched_kernel_list 6.9)
	)
	cpu_target_x86_whiskey_lake? (
		$(gen_patched_kernel_list 6.9)
	)
	cpu_target_x86_coffee_lake_gen9? (
		$(gen_patched_kernel_list 6.9)
	)
	cpu_target_x86_comet_lake? (
		$(gen_patched_kernel_list 6.9)
	)
	cpu_target_x86_amber_lake_gen10? (
		$(gen_patched_kernel_list 6.9)
	)
	cpu_target_x86_ice_lake? (
		$(gen_patched_kernel_list 6.9)
	)
	cpu_target_x86_tiger_lake? (
		$(gen_patched_kernel_list 6.9)
	)
	cpu_target_x86_alder_lake? (
		$(gen_patched_kernel_list 6.9)
		firmware? (
			>=sys-firmware/intel-microcode-20220308
		)
	)
	cpu_target_x86_raptor_lake_gen13? (
		$(gen_patched_kernel_list 6.9)
	)
	cpu_target_x86_raptor_lake_gen14? (
		$(gen_patched_kernel_list 6.9)
	)
	cpu_target_x86_meteor_lake? (
		$(gen_patched_kernel_list 6.9)
	)

	cpu_target_x86_cascade_lake? (
		$(gen_patched_kernel_list 6.9)
	)
	cpu_target_x86_cooper_lake? (
		$(gen_patched_kernel_list 6.9)
	)
	cpu_target_x86_sapphire_rapids? (
		$(gen_patched_kernel_list 6.9)
	)
	cpu_target_x86_sapphire_rapids_edge_enhanced? (
		$(gen_patched_kernel_list 6.9)
	)
	cpu_target_x86_granite_rapids? (
		$(gen_patched_kernel_list 6.9)
	)
	cpu_target_x86_emerald_rapids? (
		$(gen_patched_kernel_list 6.9)
	)

"
_MITIGATE_TECV_BHI_RDEPEND_X86_32="
	${_MITIGATE_TECV_BHI_RDEPEND_X86_64}
"

_MITIGATE_TECV_AUTO="
	$(gen_patched_kernel_list 6.9)

"
if [[ "${FIRMWARE_VENDOR}" == "amd" ]] ; then
	_MITIGATE_TECV_AUTO+="
		>=sys-kernel/linux-firmware-20240811
	"
fi
if [[ "${FIRMWARE_VENDOR}" == "intel" ]] ; then
	_MITIGATE_TECV_AUTO+="
		>=sys-firmware/intel-microcode-20240813
	"
fi

# @ECLASS_VARIABLE: MITIGATE_TECV_RDEPEND
# @INTERNAL
# @DESCRIPTION:
# High level RDEPEND
MITIGATE_TECV_RDEPEND="
	kernel_linux? (
		!custom-kernel? (
			auto? (
				${_MITIGATE_TECV_AUTO}
			)
			arm64? (
				${_MITIGATE_TECV_SPECTRE_RDEPEND_ARM64}
				${_MITIGATE_TECV_MELTDOWN_RDEPEND_ARM64}
				${_MITIGATE_TECV_SPECTRE_NG_RDEPEND_ARM64}
				${_MITIGATE_TECV_BHB_RDEPEND_ARM64}
			)
			amd64? (
				${_MITIGATE_TECV_SPECTRE_RDEPEND_X86_64}
				${_MITIGATE_TECV_MELTDOWN_RDEPEND_X86_64}
				${_MITIGATE_TECV_SWAPGS_RDEPEND_X86_64}
				${_MITIGATE_TECV_ZOMBIELOAD_V2_RDEPEND_X86_64}
				${_MITIGATE_TECV_CACHEOUT_RDEPEND_X86_64}
				${_MITIGATE_TECV_CROSSTALK_RDEPEND_X86_64}
				${_MITIGATE_TECV_SPECTRE_NG_RDEPEND_X86_64}
				${_MITIGATE_TECV_SPECTRE_RSB_RDEPEND_X86_64}
				${_MITIGATE_TECV_FORESHADOW_RDEPEND_X86_64}
				${_MITIGATE_TECV_BHI_RDEPEND_X86_64}
				${_MITIGATE_TECV_MMIO_RDEPEND_X86_64}
				${_MITIGATE_TECV_RETBLEED_RDEPEND_X86_64}
				${_MITIGATE_TECV_DOWNFALL_RDEPEND_X86_64}
				${_MITIGATE_TECV_INCEPTION_RDEPEND_X86_64}
				${_MITIGATE_TECV_RDFS_RDEPEND_X86_64}
				${_MITIGATE_TECV_ZENBLEED_RDEPEND_X86_64}
			)
			ppc? (
				${_MITIGATE_TECV_SPECTRE_RDEPEND_PPC32}
				${_MITIGATE_TECV_SPECTRE_RSB_RDEPEND_PPC32}
			)
			ppc64? (
				${_MITIGATE_TECV_MELTDOWN_RDEPEND_PPC64}
				${_MITIGATE_TECV_SPECTRE_RDEPEND_PPC64}
				${_MITIGATE_TECV_SPECTRE_RSB_RDEPEND_PPC64}
			)
			s390? (
				${_MITIGATE_TECV_SPECTRE_RDEPEND_S390X}
			)
			x86? (
				${_MITIGATE_TECV_SPECTRE_RDEPEND_X86_32}
				${_MITIGATE_TECV_SWAPGS_RDEPEND_X86_32}
				${_MITIGATE_TECV_ZOMBIELOAD_V2_RDEPEND_X86_32}
				${_MITIGATE_TECV_CACHEOUT_RDEPEND_X86_32}
				${_MITIGATE_TECV_CROSSTALK_RDEPEND_X86_32}
				${_MITIGATE_TECV_SPECTRE_RSB_RDEPEND_X86_32}
				${_MITIGATE_TECV_FORESHADOW_RDEPEND_X86_32}
				${_MITIGATE_TECV_SPECTRE_NG_RDEPEND_X86_32}
				${_MITIGATE_TECV_BHI_RDEPEND_X86_32}
				${_MITIGATE_TECV_MMIO_RDEPEND_X86_32}
				${_MITIGATE_TECV_DOWNFALL_RDEPEND_X86_32}
				${_MITIGATE_TECV_INCEPTION_RDEPEND_X86_32}
				${_MITIGATE_TECV_RDFS_RDEPEND_X86_32}
				${_MITIGATE_TECV_ZENBLEED_RDEPEND_X86_32}
			)
		)
	)
"

# @FUNCTION: _check_kernel_cmdline
# @INTERNAL
# @DESCRIPTION:
# Checks the kernel command line for the option.
_check_kernel_cmdline() {
	local option="${1}"
	local cl=$(linux_chkconfig_string "CMDLINE")
	if [[ "${cl}" =~ "${option}" ]] ; then
		return 0
	fi
	if grep -q "${option}" "/etc/default/grub" ; then
		return 0
	fi
	if grep -q "${option}" "/etc/grub.d/40_custom" ; then
		return 0
	fi
	return 1
}

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
			ERROR_MITIGATION_PAGE_TABLE_ISOLATION="CONFIG_MITIGATION_PAGE_TABLE_ISOLATION is required for Meltdown mitigation."
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
			ERROR_PAGE_TABLE_ISOLATION="CONFIG_PAGE_TABLE_ISOLATION is required for Meltdown mitigation."
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
		if _check_kernel_cmdline "mitigations=off" ; then
eerror
eerror "Detected mitigations=off in the kernel command line."
eerror
eerror "Acceptable values:"
eerror
eerror "  mitigations=auto              # The kernel default"
eerror "  mitigations=auto,nosmt"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
		if (( ${needs_kpti} == 1 )) && _check_kernel_cmdline "kpti=off" ; then
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
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
		elif (( ${needs_kpti} == 1 )) && ! _check_kernel_cmdline "kpti=" ; then
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
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
		fi
	fi

	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "4.15" ; then
		if _check_kernel_cmdline "mitigations=off" ; then
eerror
eerror "Detected mitigations=off in the kernel command line."
eerror
eerror "Acceptable values:"
eerror
eerror "  mitigations=auto              # The kernel default"
eerror "  mitigations=auto,nosmt"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
		# x86, ppc \
		if _check_kernel_cmdline "nopti" ; then
eerror
eerror "Detected nopti in the kernel command line."
eerror
eerror "Remove it from:"
eerror
eerror "  /etc/default/grub"
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
	if use firmware ; then
		if \
			   use cpu_target_x86_apollo_lake \
			|| use cpu_target_x86_denverton \
			|| use cpu_target_x86_haswell \
			|| use cpu_target_x86_broadwell \
			|| use cpu_target_x86_skylake \
			|| use cpu_target_x86_kaby_lake_gen7 \
			|| use cpu_target_x86_amber_lake_gen8 \
			|| use cpu_target_x86_coffee_lake_gen8 \
			|| use cpu_target_x86_kaby_lake_gen8 \
			|| use cpu_target_x86_whiskey_lake \
			|| use cpu_target_x86_coffee_lake_gen9 \
			|| use cpu_target_x86_gemini_lake \
			|| use cpu_target_x86_sandy_bridge \
			|| use cpu_target_x86_ivy_bridge \
			|| use cpu_target_x86_haswell \
			|| use cpu_target_x86_broadwell \
			|| use cpu_target_x86_skylake \
			|| use cpu_target_x86_kaby_lake_gen7 \
			|| use cpu_target_x86_amber_lake_gen8 \
			|| use cpu_target_x86_coffee_lake_gen8 \
			|| use cpu_target_x86_kaby_lake_gen8 \
			|| use cpu_target_x86_whiskey_lake \
			|| use cpu_target_x86_coffee_lake_gen9 \
			|| use cpu_target_x86_cascade_lake \
			|| use cpu_target_x86_cooper_lake \
			|| use cpu_target_x86_sapphire_rapids \
			|| use cpu_target_x86_sapphire_rapids_edge_enhanced \
			|| use cpu_target_x86_granite_rapids \
			|| use cpu_target_x86_emerald_rapids \
			|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
		; then
			CONFIG_CHECK="
				CPU_SUP_INTEL
			"
			ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for Spectre mitigation."
			check_extra_config
			if ! has_version ">=sys-firmware/intel-microcode-20180610" ; then
# Needed for custom-kernel USE flag due to RDEPEND being bypassed.
eerror ">=sys-firmware/intel-microcode-20180610 is required for Spectre mitigation."
				die
			fi
		fi
	fi
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "6.9" ; then
		if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" ]] ; then
			CONFIG_CHECK="
				MITIGATION_RETPOLINE
			"
			ERROR_MITIGATION_RETPOLINE="CONFIG_MITIGATION_RETPOLINE is required for Spectre mitigation."
			check_extra_config
		fi

		if [[ "${ARCH}" == "s390" ]] ; then
			CONFIG_CHECK="
				EXPOLINE
			"
			ERROR_RETPOLINE="CONFIG_EXPOLINE is required for Spectre mitigation."
			check_extra_config
		fi


	elif ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "4.15" ; then
		if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" ]] ; then
			CONFIG_CHECK="
				RETPOLINE
			"
			ERROR_RETPOLINE="CONFIG_RETPOLINE is required for Spectre mitigation."
			check_extra_config
		fi

		if [[ "${ARCH}" == "s390" ]] ; then
			CONFIG_CHECK="
				EXPOLINE
			"
			ERROR_RETPOLINE="CONFIG_EXPOLINE is required for Spectre mitigation."
			check_extra_config
		fi
	fi

	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "4.15" ; then
		if _check_kernel_cmdline "mitigations=off" ; then
eerror
eerror "Detected mitigations=off in the kernel command line."
eerror
eerror "Acceptable values:"
eerror
eerror "  mitigations=auto              # The kernel default"
eerror "  mitigations=auto,nosmt"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
		if _check_kernel_cmdline "nospectre_v1" ; then
eerror
eerror "Detected nospectre_v1 in the kernel command line."
eerror
eerror "Remove it from:"
eerror
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
		if _check_kernel_cmdline "nospectre_v2" ; then
eerror
eerror "Detected nospectre_v2 in the kernel command line."
eerror
eerror "Remove it from:"
eerror
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
	fi
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "5.13" ; then
	# See https://lwn.net/Articles/946389/
		if linux_chkconfig_present "BPF" && [[ "${BPF_SPECTRE_V2_FAUSTIAN_BARGAIN:-interpreter}" == "jit" ]] ; then
			CONFIG_CHECK="
				BPF_JIT
				BPF_JIT_ALWAYS_ON
			"
			ERROR_BPF_JIT="CONFIG_BPF_JIT=y is required for Spectre (Variant 2) mitigation."
			ERROR_BPF_JIT_ALWAYS_ON="CONFIG_BPF_JIT_ALWAYS_ON=y is required for Spectre (Variant 2) mitigation."
			check_extra_config
		fi
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_spectre_ng
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against Spectre-NG.
_mitigate_tecv_verify_mitigation_spectre_ng() {
	if use firmware ; then
		if \
			   use cpu_target_x86_gemini_lake \
			|| use cpu_target_x86_haswell \
			|| use cpu_target_x86_broadwell \
			|| use cpu_target_x86_skylake \
			|| use cpu_target_x86_kaby_lake_gen7 \
			|| use cpu_target_x86_amber_lake_gen8 \
			|| use cpu_target_x86_coffee_lake_gen8 \
			|| use cpu_target_x86_kaby_lake_gen8 \
			|| use cpu_target_x86_whiskey_lake \
			|| use cpu_target_x86_coffee_lake_gen9 \
			|| use cpu_target_x86_comet_lake \
			|| use cpu_target_x86_amber_lake_gen10 \
			|| use cpu_target_x86_ice_lake \
			|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
		; then
			CONFIG_CHECK="
				CPU_SUP_INTEL
			"
			ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for Spectre-NG mitigation."
			check_extra_config
			if ! has_version ">=sys-firmware/intel-microcode-20180703" ; then
# Needed for custom-kernel USE flag due to RDEPEND being bypassed.
eerror ">=sys-firmware/intel-microcode-20180703 is required for Spectre-NG mitigation."
				die
			fi
		fi
	fi
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "4.17" ; then
		if _check_kernel_cmdline "mitigations=off" ; then
eerror
eerror "Detected mitigations=off in the kernel command line."
eerror
eerror "Acceptable values:"
eerror
eerror "  mitigations=auto              # The kernel default"
eerror "  mitigations=auto,nosmt"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
		if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" || "${ARCH}" == "powerpc" ]] ; then
			if _check_kernel_cmdline "nospec_store_bypass_disable" ; then
eerror
eerror "Detected nospec_store_bypass_disable in the kernel command line."
eerror
eerror "Remove it from:"
eerror
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
				die
			fi
			if _check_kernel_cmdline "spec_store_bypass_disable=off" ; then
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
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
				die
			fi
		fi
	fi
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "5.13" ; then
	# See https://lwn.net/Articles/946389/
		if linux_chkconfig_present "BPF" ; then
			CONFIG_CHECK="
				BPF_UNPRIV_DEFAULT_OFF
			"
			ERROR_BPF_UNPRIV_DEFAULT_OFF="CONFIG_BPF_UNPRIV_DEFAULT_OFF=y is required for Spectre-NG v4 mitigation."
			check_extra_config
		fi
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_spectre_bhb
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against Spectre-BHB.
_mitigate_tecv_verify_mitigation_spectre_bhb() {
	if [[ "${ARCH}" == "arm64" ]] && ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "6.1" ; then
		if _check_kernel_cmdline "mitigations=off" ; then
eerror
eerror "Detected mitigations=off in the kernel command line."
eerror
eerror "Acceptable values:"
eerror
eerror "  mitigations=auto              # The kernel default"
eerror "  mitigations=auto,nosmt"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
		if _check_kernel_cmdline "nospectre_bhb" ; then
eerror
eerror "Detected nospectre_bhb in the kernel command line."
eerror
eerror "Remove it from:"
eerror
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_bhi
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against Spectre-BHI.
_mitigate_tecv_verify_mitigation_bhi() {
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "6.9" ; then
		if use firmware ; then
			if \
				   use cpu_target_x86_alder_lake \
				|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
			; then
	# Possibly userspace only mitigations
				CONFIG_CHECK="
					CPU_SUP_INTEL
					MITIGATION_SPECTRE_BHI
				"
				ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for Spectre-BHI mitigation."
				ERROR_MITIGATION_SPECTRE_BHI="CONFIG_MITIGATION_SPECTRE_BHI is required for Spectre-BHI mitigation."
				check_extra_config
				if ! has_version ">=sys-firmware/intel-microcode-20220308" ; then
# Needed for custom-kernel USE flag due to RDEPEND being bypassed.
eerror ">=sys-firmware/intel-microcode-20220308 is required for Spectre-BHI mitigation."
					die
				fi
			fi
		fi
	fi
	if [[ "${ARCH}" == "x86" || "${ARCH}" == "amd64" ]] && ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "6.9" ; then
		if _check_kernel_cmdline "mitigations=off" ; then
eerror
eerror "Detected mitigations=off in the kernel command line."
eerror
eerror "Acceptable values:"
eerror
eerror "  mitigations=auto              # The kernel default"
eerror "  mitigations=auto,nosmt"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
		if _check_kernel_cmdline "spectre_bhi=off" ; then
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
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_foreshadow
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against Foreshadow.
_mitigate_tecv_verify_mitigation_foreshadow() {
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "4.19" ; then
		if use firmware ; then
			if \
				   use cpu_target_x86_nehalem \
				|| use cpu_target_x86_westmere \
				|| use cpu_target_x86_sandy_bridge \
				|| use cpu_target_x86_ivy_bridge \
				|| use cpu_target_x86_haswell \
				|| use cpu_target_x86_broadwell \
				|| use cpu_target_x86_skylake \
				|| use cpu_target_x86_kaby_lake_gen7 \
				|| use cpu_target_x86_amber_lake_gen8 \
				|| use cpu_target_x86_coffee_lake_gen8 \
				|| use cpu_target_x86_kaby_lake_gen8 \
				|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
			; then
				CONFIG_CHECK="
					CPU_SUP_INTEL
				"
				ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for Foreshadow mitigation."
				check_extra_config
				if ! has_version ">=sys-firmware/intel-microcode-20180807" ; then
# Needed for custom-kernel USE flag due to RDEPEND being bypassed.
eerror ">=sys-firmware/intel-microcode-20180807 is required for Foreshadow mitigation."
					die
				fi
			fi
		fi
		if _check_kernel_cmdline "mitigations=off" ; then
eerror
eerror "Detected mitigations=off in the kernel command line."
eerror
eerror "Acceptable values:"
eerror
eerror "  mitigations=auto              # The kernel default"
eerror "  mitigations=auto,nosmt"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
		if _check_kernel_cmdline "l1tf=off" ; then
eerror
eerror "Detected l1tf=off in the kernel command line."
eerror
eerror "Acceptable values:"
eerror
eerror "  l1tf=full"
eerror "  l1tf=full,force"
eerror "  l1tf=flush                    # The kernel default"
eerror "  l1tf=flush,nosmt"
eerror "  l1tf=flush,nowarn"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/default/grub"
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
	use cpu_target_x86_snow_ridge_bts && eerror "No planned mitigation for RDFS."
	use cpu_target_x86_gemini_lake && ewarn "cpu_target_x86_gemini_lake requires a BIOS firmware update."
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "6.9" ; then
		if \
			use firmware \
				&& \
			   use cpu_target_x86_apollo_lake \
			|| use cpu_target_x86_denverton \
			|| use cpu_target_x86_snow_ridge \
			|| use cpu_target_x86_parker_ridge \
			|| use cpu_target_x86_elkhart_lake \
			|| use cpu_target_x86_arizona_beach \
			|| use cpu_target_x86_jasper_lake \
			|| use cpu_target_x86_alder_lake_n \
			|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
		; then
			CONFIG_CHECK="
				CPU_SUP_INTEL
			"
			ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for RDFS mitigation on Intel® Atom®."
			check_extra_config
			if ! has_version ">=sys-firmware/intel-microcode-20240312" ; then
# Needed for custom-kernel USE flag due to RDEPEND being bypassed.
eerror ">=sys-firmware/intel-microcode-20240312 is required for RDFS mitigation."
				die
			fi
		elif \
			   use cpu_target_x86_apollo_lake \
			|| use cpu_target_x86_denverton \
			|| use cpu_target_x86_snow_ridge \
			|| use cpu_target_x86_parker_ridge \
			|| use cpu_target_x86_elkhart_lake \
			|| use cpu_target_x86_arizona_beach \
			|| use cpu_target_x86_jasper_lake \
			|| use cpu_target_x86_alder_lake_n \
		; then
			CONFIG_CHECK="
				MITIGATION_RFDS
			"
			ERROR_MITIGATION_RFDS="CONFIG_MITIGATION_RFDS or >=sys-firmware/intel-microcode-20240312 is required for RDFS mitigation on Intel® Atom®."
			check_extra_config
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
			cpu_target_x86_skylake
			cpu_target_x86_kaby_lake_gen7
			cpu_target_x86_amber_lake_gen8
			cpu_target_x86_coffee_lake_gen8
			cpu_target_x86_kaby_lake_gen8
			cpu_target_x86_whiskey_lake
			cpu_target_x86_coffee_lake_gen9
			cpu_target_x86_comet_lake
			cpu_target_x86_amber_lake_gen10
			cpu_target_x86_ice_lake
			cpu_target_x86_tiger_lake
			cpu_target_x86_cascade_lake
			cpu_target_x86_cooper_lake
		)
		for x in ${L[@]} ; do
			if \
				use firmware \
					&& \
				( \
					use "${x}" \
					|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
				) \
			; then
				CONFIG_CHECK="
					CPU_SUP_INTEL
				"
				ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for GDS mitigation on ${x}."
				check_extra_config
				if ! has_version ">=sys-firmware/intel-microcode-20230808" ; then
# Needed for custom-kernel USE flag due to RDEPEND being bypassed.
eerror ">=sys-firmware/intel-microcode-20230808 is required for GDS mitigation."
					die
				fi
			elif use "${x}" ; then
				# Default off upstream
				CONFIG_CHECK="
					GDS_FORCE_MITIGATION
				"
				ERROR_GDS_FORCE_MITIGATION="CONFIG_GDS_FORCE_MITIGATION or >=sys-firmware/intel-microcode-20230808 is required for GDS mitigation on ${x}."
				check_extra_config
				if _check_kernel_cmdline "gather_data_sampling=off" ; then
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
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
					die
				fi
			fi
		done
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_retbleed
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against Retbleed.
_mitigate_tecv_verify_mitigation_retbleed() {
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "5.19" ; then
		if _check_kernel_cmdline "retbleed=off" ; then
eerror
eerror "Detected retbleed=off in the kernel command line."
eerror "Note:  This mitigation will turn off AVX acceleration."
eerror
eerror "Acceptable values:"
eerror
eerror "  retbleed=auto                 # The kernel default"
eerror "  retbleed=auto,nosmt"
eerror "  retbleed=ibpb"
eerror "  retbleed=unret"
eerror "  retbleed=unret,nosmt"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
		if [[ "${ARCH}" == "x86" ]] ; then
eerror "No mitigation against Retbleed for 32-bit x86.  Use only 64-bit instead."
			die
		fi
		if has abi_x86_32 ${IUSE_EFFECTIVE} && use abi_x86_32 ; then
eerror "No mitigation against Retbleed for 32-bit x86.  Use only 64-bit instead."
			die
		fi
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_zenbleed
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against Zenbleed.
_mitigate_tecv_verify_mitigation_zenbleed() {
	if \
		use firmware \
			&& \
		( \
			   use cpu_target_x86_zen_2 \
			|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "amd" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
		) \
	; then
		if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "6.9" ; then
			CONFIG_CHECK="
				CPU_SUP_AMD
			"
			ERROR_CPU_SUP_AMD="CONFIG_CPU_SUP_AMD is required for Zenbleed mitigation."
			check_extra_config
			if ! has_version ">=sys-kernel/linux-firmware-20231205" ; then
# Needed for custom-kernel USE flag due to RDEPEND being bypassed.
eerror ">=sys-kernel/linux-firmware-20231205 is required for Zenbleed mitigation."
				die
			fi
		fi
	fi
	if \
		   use cpu_target_x86_zen_2 \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "amd" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
ewarn "A BIOS firmware update may be needed for Zenbleed mitigation for different models and may only be provided that way."
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_crosstalk
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CROSSTalk.
_mitigate_tecv_verify_mitigation_crosstalk() {
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "5.8" ; then
		if use firmware ; then
			if \
				   use cpu_target_x86_skylake \
				|| use cpu_target_x86_kaby_lake_gen7 \
				|| use cpu_target_x86_amber_lake_gen8 \
				|| use cpu_target_x86_coffee_lake_gen8 \
				|| use cpu_target_x86_kaby_lake_gen8 \
				|| use cpu_target_x86_whiskey_lake \
				|| use cpu_target_x86_coffee_lake_gen9 \
				|| use cpu_target_x86_amber_lake_gen10 \
				|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
			; then
				CONFIG_CHECK="
					CPU_SUP_INTEL
				"
				ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for CROSSTalk mitigation."
				check_extra_config
				if ! has_version ">=sys-firmware/intel-microcode-20200609" ; then
# Needed for custom-kernel USE flag due to RDEPEND being bypassed.
eerror ">=sys-firmware/intel-microcode-20200609 is required for CROSSTalk mitigation."
					die
				fi
			fi
		fi
		if _check_kernel_cmdline "mitigations=off" ; then
eerror
eerror "Detected mitigations=off in the kernel command line."
eerror
eerror "Acceptable values:"
eerror
eerror "  mitigations=auto              # The kernel default"
eerror "  mitigations=auto,nosmt"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
		if _check_kernel_cmdline "srbds=off" ; then
eerror
eerror "Detected srbds=off in the kernel command line."
eerror
eerror "Remove it from:"
eerror
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_inception
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against Inception.
_mitigate_tecv_verify_mitigation_inception() {
	local ver
	if use cpu_target_x86_zen_3 || use cpu_target_x86_zen_4 ; then
		ver="6.9"
	elif use cpu_target_x86_zen || use cpu_target_x86_zen2 ; then
		ver="6.5"
	else
		return
	fi
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "${ver}" ; then
		CONFIG_CHECK="
			CPU_SRSO
		"
		ERROR_CPU_SRSO="CONFIG_CPU_SRSO is required for Inception mitigation."
		check_extra_config
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_zombieload_v2
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against ZombieLoad v2.
_mitigate_tecv_verify_mitigation_zombieload_v2() {
	if use firmware ; then
		if \
			   use cpu_target_x86_skylake \
			|| use cpu_target_x86_kaby_lake_gen7 \
			|| use cpu_target_x86_amber_lake_gen8 \
			|| use cpu_target_x86_coffee_lake_gen8 \
			|| use cpu_target_x86_kaby_lake_gen8 \
			|| use cpu_target_x86_whiskey_lake \
			|| use cpu_target_x86_coffee_lake_gen9 \
			|| use cpu_target_x86_amber_lake_gen10 \
			|| use cpu_target_x86_cascade_lake \
			|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
		; then
			CONFIG_CHECK="
				CPU_SUP_INTEL
			"
			ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for ZombieLoad v2 mitigation."
			check_extra_config
			if ! has_version ">=sys-firmware/intel-microcode-20191112" ; then
# Needed for custom-kernel USE flag due to RDEPEND being bypassed.
eerror ">=sys-firmware/intel-microcode-20191112 is required for ZombieLoad v2 mitigation."
				die
			fi
		fi
	fi

	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "5.4" ; then
		if _check_kernel_cmdline "mitigations=off" ; then
eerror
eerror "Detected mitigations=off in the kernel command line."
eerror
eerror "Acceptable values:"
eerror
eerror "  mitigations=auto              # The kernel default"
eerror "  mitigations=auto,nosmt"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
		if _check_kernel_cmdline "tsx_async_abort=off" ; then
eerror
eerror "Detected tsx_async_abort=off in the kernel command line."
eerror
eerror "Acceptable values:"
eerror
eerror "  tsx_async_abort=full          # The kernel default"
eerror "  tsx_async_abort=full,nosmt"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
		fi
	fi
	if use cpu_target_x86_haswell ; then
ewarn "Missing firmware for Gen4 TAA mitigations"
	fi
	if use cpu_target_x86_broadwell ; then
ewarn "Missing firmware for Gen5 TAA mitigations"
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_cacheout
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CacheOut (L1DES) and VRS.
_mitigate_tecv_verify_mitigation_cacheout() {
	if \
		   use cpu_target_x86_skylake \
		|| use cpu_target_x86_kaby_lake_gen7 \
		|| use cpu_target_x86_coffee_lake_gen8 \
		|| use cpu_target_x86_kaby_lake_gen8 \
		|| use cpu_target_x86_whiskey_lake \
		|| use cpu_target_x86_coffee_lake_gen9 \
		|| use cpu_target_x86_comet_lake \
		|| use cpu_target_x86_ice_lake \
		|| use cpu_target_x86_cascade_lake \
	; then
	# Microcode mitigation only
		CONFIG_CHECK="
			CPU_SUP_INTEL
		"
		ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for CacheOut and VRS mitigation."
		check_extra_config
		if ! has_version ">=sys-firmware/intel-microcode-20200609" ; then
# Needed for custom-kernel USE flag due to RDEPEND being bypassed.
eerror ">=sys-firmware/intel-microcode-20200609 is required for CacheOut and VRS mitigation."
			die
		fi
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_spectre_rsb
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against SpectreRSB, RSBU, RSBA, RRSBA.
_mitigate_tecv_verify_mitigation_spectre_rsb() {
	if use cpu_target_x86_alder_lake ; then
	# Needs microcode mitigation
		CONFIG_CHECK="
			CPU_SUP_INTEL
		"
		ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for RSBU/RRSBA mitigation."
		check_extra_config
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_mds
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against MDS.
# The MDSUM column was not processed and missing.
_mitigate_tecv_verify_mitigation_mds() {
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "5.2" ; then
		if use firmware ; then
			if \
				   use cpu_target_x86_haswell \
				|| use cpu_target_x86_broadwell \
				|| use cpu_target_x86_skylake \
				|| use cpu_target_x86_kaby_lake_gen7 \
				|| use cpu_target_x86_amber_lake_gen8 \
				|| use cpu_target_x86_coffee_lake_gen8 \
				|| use cpu_target_x86_kaby_lake_gen8 \
				|| use cpu_target_x86_whiskey_lake \
				|| use cpu_target_x86_coffee_lake_gen9 \
				|| use cpu_target_x86_comet_lake \
				|| use cpu_target_x86_ice_lake \
				|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
			; then
				CONFIG_CHECK="
					CPU_SUP_INTEL
				"
				ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for MDS mitigation."
				check_extra_config
				if ! has_version ">=sys-firmware/intel-microcode-20190618" ; then
# Needed for custom-kernel USE flag due to RDEPEND being bypassed.
eerror ">=sys-firmware/intel-microcode-20190618 is required for MDS mitigation."
					die
				fi
			fi
		fi
		if _check_kernel_cmdline "mitigations=off" ; then
eerror
eerror "Detected mitigations=off in the kernel command line."
eerror
eerror "Acceptable values:"
eerror
eerror "  mitigations=auto              # The kernel default"
eerror "  mitigations=auto,nosmt"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
		if _check_kernel_cmdline "mds=off" ; then
eerror
eerror "Detected mds=off in the kernel command line."
eerror
eerror "Acceptable values:"
eerror
eerror "  mds=full                      # The kernel default"
eerror "  mds=full,nosmt"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
		fi
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_mmio_stale_data
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against MMIO Stale Data.
_mitigate_tecv_verify_mitigation_mmio_stale_data() {
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "5.19" ; then
		if use firmware ; then
			if \
				   use cpu_target_x86_snow_ridge_bts \
				|| use cpu_target_x86_snow_ridge \
				|| use cpu_target_x86_parker_ridge \
				|| use cpu_target_x86_elkhart_lake \
				|| use cpu_target_x86_jasper_lake \
				|| use cpu_target_x86_haswell \
				|| use cpu_target_x86_broadwell \
				|| use cpu_target_x86_skylake \
				|| use cpu_target_x86_kaby_lake_gen7 \
				|| use cpu_target_x86_amber_lake_gen8 \
				|| use cpu_target_x86_coffee_lake_gen8 \
				|| use cpu_target_x86_kaby_lake_gen8 \
				|| use cpu_target_x86_whiskey_lake \
				|| use cpu_target_x86_coffee_lake_gen9 \
				|| use cpu_target_x86_comet_lake \
				|| use cpu_target_x86_amber_lake_gen10 \
				|| use cpu_target_x86_ice_lake \
				|| use cpu_target_x86_tiger_lake \
				|| use cpu_target_x86_cascade_lake \
				|| use cpu_target_x86_cooper_lake \
				|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
			; then
				CONFIG_CHECK="
					CPU_SUP_INTEL
				"
				ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for MMIO Stale Data mitigation."
				check_extra_config
				if ! has_version ">=sys-firmware/intel-microcode-20220510" ; then
# Needed for custom-kernel USE flag due to RDEPEND being bypassed.
eerror ">=sys-firmware/intel-microcode-20220510 is required for MMIO Stale Data mitigation."
					die
				fi
			fi
		fi
		if _check_kernel_cmdline "mitigations=off" ; then
eerror
eerror "Detected mitigations=off in the kernel command line."
eerror
eerror "Acceptable values:"
eerror
eerror "  mitigations=auto              # The kernel default"
eerror "  mitigations=auto,nosmt"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
		if _check_kernel_cmdline "mmio_stale_data=off" ; then
eerror
eerror "Detected mmio_stale_data=off in the kernel command line."
eerror
eerror "Acceptable values:"
eerror
eerror "  mmio_stale_data=full          # The kernel default"
eerror "  mmio_stale_data=full,nosmt"
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
		fi
	fi
}

# @FUNCTION: _mitigate-tecv_check_kernel_flags
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags
_mitigate-tecv_check_kernel_flags() {
	einfo "Kernel version:  ${KV_MAJOR}.${KV_MINOR}"

	if ! linux_config_src_exists ; then
eerror "Missing .config in /usr/src/linux"
		die
	fi

	if linux_chkconfig_present "BPF" && ! use bpf ; then
eerror "Detected BPF in the kernel config.  Enable the bpf USE flag."
		die
	fi

	# Notify if grub or the kernel config is incorrectly configured/tampered
	# or a copypasta-ed workaround.
	_mitigate_tecv_verify_mitigation_meltdown		# Mitigations against Variant 3 (2017)
	_mitigate_tecv_verify_mitigation_spectre		# Mitigations against Variant 1 (2017), Variant 2 (2017), SWAPGS (2019)
	_mitigate_tecv_verify_mitigation_spectre_ng		# Mitigations against Variant 4 (2018)
	_mitigate_tecv_verify_mitigation_spectre_bhb		# Mitigations against BHB (2022), ARM
	_mitigate_tecv_verify_mitigation_bhi			# Mitigations against BHI (2022), X86
	_mitigate_tecv_verify_mitigation_crosstalk		# Mitigations against SRBDS (2020)
	_mitigate_tecv_verify_mitigation_spectre_rsb		# Mitigations against SpectreRSB (2018), RSBU (2022), RSBA (2022), RRSBA (2022)
	_mitigate_tecv_verify_mitigation_foreshadow		# Mitigations against L1TF (2018)
	_mitigate_tecv_verify_mitigation_zombieload_v2		# Mitigations against TAA (2019)
	_mitigate_tecv_verify_mitigation_mds			# Mitigations against ZombieLoad/MFBDS (2028), MLPDS (2028), MSBDS (2018), MDSUM (2019)
	_mitigate_tecv_verify_mitigation_cacheout		# Mitigations against L1DES (2020), VRS (2020)
	_mitigate_tecv_verify_mitigation_downfall		# Mitigations against GDS (2022)
	_mitigate_tecv_verify_mitigation_retbleed		# Mitigations against Retbleed (2022)
	_mitigate_tecv_verify_mitigation_mmio_stale_data	# Mitigations against SBDR (2022), SBDS (2022), DRPW (2022)
	_mitigate_tecv_verify_mitigation_zenbleed		# Mitigations against Zenbleed (2023)
	_mitigate_tecv_verify_mitigation_inception		# Mitigations against SRSO (2023)
	_mitigate_tecv_verify_mitigation_rfds			# Mitigations against RFDS (2024)

	# For SLAM, see https://en.wikipedia.org/wiki/Transient_execution_CPU_vulnerability#2023
}

# @FUNCTION: _mitigate-tecv_print_required_versions
# @DESCRIPTION:
# Print the required kernel versions for custom-kernel.
_mitigate-tecv_print_required_versions() {
	if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" ]] ; then
		if \
			   use cpu_target_x86_apollo_lake \
			|| use cpu_target_x86_denverton \
			|| use cpu_target_x86_snow_ridge_bts \
			|| use cpu_target_x86_snow_ridge \
			|| use cpu_target_x86_parker_ridge \
			|| use cpu_target_x86_elkhart_lake \
			|| use cpu_target_x86_arizona_beach \
			|| use cpu_target_x86_jasper_lake \
			|| use cpu_target_x86_alder_lake_n \
			|| use cpu_target_x86_zen_2 \
			|| use cpu_target_x86_zen_3 \
			|| use cpu_target_x86_zen_4 \
			|| use cpu_target_x86_amber_lake_gen8 \
			|| use cpu_target_x86_coffee_lake_gen8 \
			|| use cpu_target_x86_kaby_lake_gen8 \
			|| use cpu_target_x86_whiskey_lake \
			|| use cpu_target_x86_coffee_lake_gen9 \
			|| use cpu_target_x86_comet_lake \
			|| use cpu_target_x86_amber_lake_gen10 \
			|| use cpu_target_x86_ice_lake \
			|| use cpu_target_x86_tiger_lake \
			|| use cpu_target_x86_alder_lake \
			|| use cpu_target_x86_raptor_lake_gen13 \
			|| use cpu_target_x86_raptor_lake_gen14 \
			|| use cpu_target_x86_meteor_lake \
			|| use cpu_target_x86_cascade_lake \
			|| use cpu_target_x86_cooper_lake \
			|| use cpu_target_x86_sapphire_rapids \
			|| use cpu_target_x86_sapphire_rapids_edge_enhanced \
			|| use cpu_target_x86_granite_rapids \
			|| use cpu_target_x86_emerald_rapids \
		; then
ewarn "You are responsible for using only Linux Kernel >= 6.9."
		elif \
			   use cpu_target_x86_skylake \
			|| use cpu_target_x86_kaby_lake_gen7 \
			|| use cpu_target_x86_zen \
			|| use cpu_target_x86_zen_2 \
		; then
ewarn "You are responsible for using only Linux Kernel >= 6.5."
		elif \
			   use cpu_target_x86_zen \
			|| use cpu_target_x86_zen_plus \
		; then
ewarn "You are responsible for using only Linux Kernel >= 5.19."
		elif use bpf ; then
ewarn "You are responsible for using only Linux Kernel >= 5.13."
		elif \
			   use cpu_target_x86_haswell \
			|| use cpu_target_x86_broadwell \
		; then
ewarn "You are responsible for using only Linux Kernel >= 5.4."
		elif \
			   use cpu_target_x86_nehalem \
			|| use cpu_target_x86_westmere \
			|| use cpu_target_x86_sandy_bridge \
			|| use cpu_target_x86_ivy_bridge \
		; then
ewarn "You are responsible for using only Linux Kernel >= 4.19."
		else
ewarn "You are responsible for using only Linux Kernel >= 4.15."
		fi
	fi
	if [[ "${ARCH}" == "ppc" || "${ARCH}" == "ppc64" ]] ; then
		if \
			   use cpu_target_ppc_85xx \
			|| use cpu_target_ppc_e500mc \
			|| use cpu_target_ppc_e5500 \
			|| use cpu_target_ppc_e6500 \
		; then
ewarn "You are responsible for using only Linux Kernel >= 5.0."
		else
ewarn "You are responsible for using only Linux Kernel >= 4.15."
		fi
	fi
	if [[ "${ARCH}" == "s390" ]] ; then
ewarn "You are responsible for using only Linux Kernel >= 4.15."
	fi
	if [[ "${ARCH}" == "arm64" ]] ; then
		if \
			   use cpu_target_arm_cortex_r7 \
			|| use cpu_target_arm_cortex_r8 \
			|| use cpu_target_arm_cortex_a15 \
			|| use cpu_target_arm_cortex_a57 \
			|| use cpu_target_arm_cortex_a65 \
			|| use cpu_target_arm_cortex_a65ae \
			|| use cpu_target_arm_cortex_a72 \
			|| use cpu_target_arm_cortex_a73 \
			|| use cpu_target_arm_cortex_a75 \
			|| use cpu_target_arm_cortex_a76 \
			|| use cpu_target_arm_cortex_a77 \
			|| use cpu_target_arm_cortex_a78 \
			|| use cpu_target_arm_cortex_a78c \
			|| use cpu_target_arm_cortex_a710 \
			|| use cpu_target_arm_cortex_a715 \
			|| use cpu_target_arm_neoverse_e1 \
			|| use cpu_target_arm_neoverse_n1 \
			|| use cpu_target_arm_neoverse_v1 \
			|| use cpu_target_arm_neoverse_n2 \
			|| use cpu_target_arm_neoverse_v2 \
			|| use cpu_target_arm_cortex_x1 \
			|| use cpu_target_arm_cortex_x2 \
			|| use cpu_target_arm_cortex_x3 \
		; then
ewarn "You are responsible for using only Linux Kernel >= 6.1."
		elif use bpf ; then
ewarn "You are responsible for using only Linux Kernel >= 5.13."
		elif \
			   use cpu_target_arm_cortex_a15 \
			|| use cpu_target_arm_cortex_a75 \
		; then
ewarn "You are responsible for using only Linux Kernel >= 4.16."
		else
# Placeholder
# TODO:  Verify earliest version for Variant 1 and Variant 2 mitigations
ewarn "You are responsible for using only Linux Kernel >= 4.16."
		fi
	fi
}

# @FUNCTION: mitigate-tecv_pkg_setup
# @DESCRIPTION:
# Check the kernel config
mitigate-tecv_pkg_setup() {
	if [[ "${ARCH}" == "arm" ]] ; then
ewarn "CPU vulnerability mitigation has not been added yet for ARCH=${ARCH}."
	fi
	use auto && einfo "FIRMWARE_VENDOR=${FIRMWARE_VENDOR}"
	if use kernel_linux ; then
		linux-info_pkg_setup
		_mitigate-tecv_check_kernel_flags
		if use custom-kernel ; then
			_mitigate-tecv_print_required_versions
		fi
# It is a common practice by hardware manufacturers to delete support or
# historical information after a period of time.
		if use cpu_target_x86_core ; then
ewarn "Mitigation coverage for cpu_target_x86_core may be incompletable."
		fi
		if use cpu_target_x86_nehalem ; then
ewarn "Mitigation coverage for cpu_target_x86_nehalem may be incompletable."
		fi
		if use cpu_target_x86_westmere ; then
ewarn "Mitigation coverage for cpu_target_x86_westmere may be incompletable."
		fi
		if use cpu_target_x86_sandy_bridge ; then
ewarn "Mitigation coverage for cpu_target_x86_sandy_bridge may be incompletable."
		fi
		if use cpu_target_x86_ivy_bridge ; then
ewarn "Mitigation coverage for cpu_target_x86_ivy_bridge may be incompletable."
		fi
# We didn't verify yet.  Maybe it could be run in src_test().
ewarn "Use a CPU vulnerability checker to verify complete mitigation or to help complete mitigation."
	fi
}

# @FUNCTION: mitigate-tecv_pkg_postinst
# @DESCRIPTION:
# Remind user to use only patched kernels especially for large packages.
mitigate-tecv_pkg_postinst() {
	if use kernel_linux ; then
		if use custom-kernel ; then
			_mitigate-tecv_print_required_versions
		fi
	fi
}

fi
