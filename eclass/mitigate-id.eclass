# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# @ECLASS: mitigate-id.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Spectre and Meltdown kernel mitigation
# @DESCRIPTION:
# This ebuild is to perform kernel checks on Spectre and Meltdown on the kernel
# level.  This also covers other mitigations for hardware vulnerabilities.
#
# See also https://en.wikipedia.org/wiki/Transient_execution_CPU_vulnerability
#

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_MITIGATE_ID_ECLASS} ]] ; then
_MITIGATE_ID_ECLASS=1

_mitigate_id_set_globals() {
	FIRMWARE_VENDOR=${FIRMWARE_VENDOR:-""}
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

_mitigate_id_set_globals
unset -f _mitigate_id_set_globals

# We like to delete all of the cpu_target_* but can't because the eclass doesn't
# do auto detect min required kernel via USE=auto.  The cpu_target_x86_* does
# more accurate pruning allowing for better LTS support.  The auto will just
# simplify and prune everything except the latest stable.

# Sometimes the mitigation is not backported to the older kernel series.  This
# is why the min is raised higher for certain microarches.

#
# lakefield is incomplete
# cannon lake is incomplete
CPU_TARGET_X86=(
# For completeness, see also
# https://www.intel.com/content/www/us/en/developer/topic-technology/software-security-guidance/processors-affected-consolidated-product-cpu-model.html
# * Missing documentation so only Meltdown and Spectre mitigated.  Ebuild still can be fixed by user.
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
	cpu_target_x86_arrandale
	cpu_target_x86_broxton
	cpu_target_x86_clarkdale
	cpu_target_x86_gladden
	cpu_target_x86_lynnfield
	cpu_target_x86_nehalem
	cpu_target_x86_westmere
	cpu_target_x86_sandy_bridge
	cpu_target_x86_ivy_bridge
	cpu_target_x86_haswell
	cpu_target_x86_broadwell
	cpu_target_x86_hewitt_lake
	cpu_target_x86_bakerville
	cpu_target_x86_skylake
	cpu_target_x86_kaby_lake_gen7
	cpu_target_x86_amber_lake_gen8
	cpu_target_x86_coffee_lake_gen8
	cpu_target_x86_kaby_lake_gen8
	cpu_target_x86_cannon_lake
	cpu_target_x86_whiskey_lake
	cpu_target_x86_coffee_lake_gen9
	cpu_target_x86_comet_lake
	cpu_target_x86_amber_lake_gen10
	cpu_target_x86_ice_lake
	cpu_target_x86_rocket_lake
	cpu_target_x86_tiger_lake
	cpu_target_x86_alder_lake
	cpu_target_x86_raptor_lake_gen13
	cpu_target_x86_raptor_lake_gen14
	cpu_target_x86_meteor_lake
	cpu_target_x86_cedar_island
	cpu_target_x86_whitley
	cpu_target_x86_idaville
	cpu_target_x86_purley_refresh
	cpu_target_x86_cedar_island
	cpu_target_x86_greenlow
	cpu_target_x86_whitley
	cpu_target_x86_tatlow
	cpu_target_x86_eagle_stream

	cpu_target_x86_cascade_lake
	cpu_target_x86_cooper_lake
	cpu_target_x86_sapphire_rapids
	cpu_target_x86_sapphire_rapids_edge_enhanced
	cpu_target_x86_granite_rapids
	cpu_target_x86_emerald_rapids
	cpu_target_x86_sierra_forest

	cpu_target_x86_catlow_golden_cove
	cpu_target_x86_catlow_raptor_cove

	cpu_target_x86_lakefield

	cpu_target_x86_bulldozer
	cpu_target_x86_piledriver
	cpu_target_x86_steamroller
	cpu_target_x86_excavator
	cpu_target_x86_jaguar
	cpu_target_x86_puma
	cpu_target_x86_zen
	cpu_target_x86_zen_plus
	cpu_target_x86_zen_2
	cpu_target_x86_zen_3
	cpu_target_x86_zen_4
	cpu_target_x86_naples
	cpu_target_x86_rome
	cpu_target_x86_milan
	cpu_target_x86_milan-x
	cpu_target_x86_genoa
	cpu_target_x86_genoa-x
	cpu_target_x86_bergamo
	cpu_target_x86_siena

	cpu_target_x86_dhyana
)

CPU_TARGET_ARM=(
# See also
# https://developer.arm.com/Arm%20Security%20Center/Speculative%20Processor%20Vulnerability
# https://github.com/torvalds/linux/blob/v6.10/arch/arm64/kernel/cpufeature.c#L1739

# 32-bit
	cpu_target_arm_cortex_a8	# Variant 2
	cpu_target_arm_cortex_a9	# Variant 2
	cpu_target_arm_cortex_a12	# Variant 2
	cpu_target_arm_cortex_a15	# BHB, Variant 2, Variant 3a
	cpu_target_arm_cortex_a17	# Variant 2
	cpu_target_arm_cortex_a32	# SLS
	cpu_target_arm_cortex_r7	# BHB
	cpu_target_arm_cortex_r8	# BHB
	cpu_target_arm_brahma_b15	# BHB, Variant 2

# 32-/64-bit
	cpu_target_arm_cortex_a35	# SLS
	cpu_target_arm_cortex_a53	# SLS
	cpu_target_arm_cortex_a57	# BHB, Variant 3a, Variant 4, SLS
	cpu_target_arm_cortex_a72	# BHB, Variant 3a, Variant 4, SLS
	cpu_target_arm_cortex_a73	# BHB, Variant 2, Variant 4, SLS
	cpu_target_arm_cortex_a75	# BHB, Variant 2, Variant 3, Variant 4
	cpu_target_arm_cortex_a76	# BHB, Variant 4
	cpu_target_arm_cortex_a77	# BHB, Variant 4
	cpu_target_arm_cortex_a78	# BHB
	cpu_target_arm_cortex_a78c	# BHB
	cpu_target_arm_cortex_x1	# BHB
	cpu_target_arm_cortex_x1c
	cpu_target_arm_neoverse_n1	# BHB, Variant 4

# 64-bit
	cpu_target_arm_cortex_a34	# SLS
	cpu_target_arm_cortex_a65	# BHB
	cpu_target_arm_cortex_a65ae	# BHB
	cpu_target_arm_cortex_a78ae	# BHB
	cpu_target_arm_cortex_a710	# BHB
	cpu_target_arm_cortex_a715	# BHB
	cpu_target_arm_cortex_a720
	 cpu_target_arm_cortex_a725
	cpu_target_arm_cortex_x2	# BHB
	cpu_target_arm_cortex_x3	# BHB
	 cpu_target_arm_cortex_x4
	 cpu_target_arm_cortex_x925
	cpu_target_arm_neoverse_e1	# BHB
	cpu_target_arm_neoverse_n2	# BHB
	cpu_target_arm_neoverse_v1	# BHB
	cpu_target_arm_neoverse_v2	# BHB
	 cpu_target_arm_neoverse_v3
	cpu_target_arm_ampereone	# BHB
	cpu_target_arm_thunderx2	# Spectre v2
	cpu_target_arm_falkor		# Spectre v2
	cpu_target_arm_vulkan		# Spectre v2
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

is_microarch_selected() {
	local selected=1
	local x
	for x in ${CPU_TARGET_X86[@]} ${CPU_TARGET_ARM[@]} ${CPU_TARGET_PPC[@]} ; do
		use "${x}" && selected=0
	done
	return ${selected}
}

inherit linux-info toolchain-funcs

IUSE+="
	${ACTIVE_VERSIONS[@]/./_}
	${CPU_TARGET_ARM[@]}
	${CPU_TARGET_PPC[@]}
	${CPU_TARGET_X86[@]}
	auto
	bpf
	custom-kernel
	+enforce
	firmware
	kvm
	+zero-tolerance
	ebuild_revision_9
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
	cpu_target_x86_gemini_lake? (
		firmware
	)

	cpu_target_x86_arrandale? (
		firmware
	)
	cpu_target_x86_clarkdale? (
		firmware
	)
	cpu_target_x86_gladden? (
		firmware
	)
	cpu_target_x86_lynnfield? (
		firmware
	)
	cpu_target_x86_bakerville? (
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
	cpu_target_x86_hewitt_lake? (
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
	cpu_target_x86_rocket_lake? (
		firmware
	)
	cpu_target_x86_tiger_lake? (
		firmware
	)
	cpu_target_x86_alder_lake? (
		firmware
	)
	cpu_target_x86_raptor_lake_gen13? (
		firmware
	)
	cpu_target_x86_raptor_lake_gen14? (
		firmware
	)

	cpu_target_x86_purley_refresh? (
		firmware
	)
	cpu_target_x86_cedar_island? (
		firmware
	)
	cpu_target_x86_greenlow? (
		firmware
	)
	cpu_target_x86_tatlow? (
		firmware
	)
	cpu_target_x86_comet_lake? (
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

	cpu_target_x86_catlow_golden_cove? (
		firmware
	)
	cpu_target_x86_catlow_raptor_cove? (
		firmware
	)

	cpu_target_x86_cedar_island? (
		firmware
	)
	cpu_target_x86_whitley? (
		firmware
	)
	cpu_target_x86_idaville? (
		firmware
	)
	cpu_target_x86_meteor_lake? (
		firmware
	)

	cpu_target_x86_zen_2? (
		firmware
	)

	cpu_target_x86_naples? (
		firmware
	)
	cpu_target_x86_rome? (
		firmware
	)
	cpu_target_x86_milan? (
		firmware
	)
	cpu_target_x86_milan-x? (
		firmware
	)
	cpu_target_x86_genoa? (
		firmware
	)
	cpu_target_x86_genoa-x? (
		firmware
	)
	cpu_target_x86_bergamo? (
		firmware
	)
	cpu_target_x86_siena? (
		firmware
	)

	|| (
		${ACTIVE_VERSIONS[@]/./_}
	)
"

is_lts() {
	local kv="${1}"
	local x
	for x in ${LTS_VERSIONS[@]} ; do
		local s1=$(ver_cut 1-2 ${kv})
		local s2=$(ver_cut 1-2 ${x})
		if ver_test ${s1} -eq ${s2} ; then
			return 0
		fi
	done
	return 1
}

is_stable_or_mainline_version() {
	local kv="${1}"
	local x
	for x in ${STABLE_OR_MAINLINE_VERSIONS[@]} ; do
		local s1=$(ver_cut 1-2 ${kv})
		local s2=$(ver_cut 1-2 ${x})
		if ver_test ${s1} -eq ${s2} ; then
			return 0
		fi
	done
	return 1
}

is_eol() {
	local kv="${1}"
	local x
	for x in ${ACTIVE_VERSIONS[@]} ; do
		local s1=$(ver_cut 1-2 ${kv})
		local s2=$(ver_cut 1-2 ${x})
		if ver_test ${s1} -eq ${s2} ; then
			return 1
		fi
	done
	return 0
}

# @FUNCTION: gen_patched_kernel_list
# @INTERNAL
# @DESCRIPTION:
# Generate the patched kernel list
gen_patched_kernel_list() {
	local kv="${1}"
	local active_version

	for active_version in ${ACTIVE_VERSIONS[@]} ; do
		local s1=$(ver_cut 1-2 ${kv})
		local s2=$(ver_cut 1-2 ${active_version})
		if ver_test ${s2} -ge ${s1} ; then
			:
		else
			_ALL_VERSIONS["_${s2/./_}"]="${s2}.V"
		fi
	done
}

# @FUNCTION: gen_zero_tolerance_kernel_list
# @INTERNAL
# @DESCRIPTION:
# Generate the latest point release kernel list
gen_zero_tolerance_kernel_list() {
	local PATCHED_VERSIONS=( ${@} )

	local latest_version

	for latest_version in ${PATCHED_VERSIONS[@]} ; do
		local s=$(ver_cut 1-2 ${latest_version})
		if [[ "${_ALL_VERSIONS[_${s/./_}]}" == "EOL" ]] ; then
			:
		elif [[ "${_ALL_VERSIONS[_${s/./_}]}" =~ "V" ]] ; then
			:
		else
			_ALL_VERSIONS["_${s/./_}"]="${latest_version}"
		fi
	done
}

# @FUNCTION: gen_patched_kernel_driver_list
# @INTERNAL
# @DESCRIPTION:
# Generate the patched kernel list
gen_patched_kernel_driver_list() {
	local PATCHED_VERSIONS=( ${@} )

	local patched_version
	patched_version=${PATCHED_VERSIONS[-1]}

	# Check LTS versions

	for patched_version in ${PATCHED_VERSIONS[@]} ; do
		if is_lts "${patched_version}" ; then
			if [[ "${patched_version}" =~ "V" ]] ; then
	# Unpatched / vulnerable
				local slot=$(ver_cut 1-2 ${patched_version})
				_ALL_VERSIONS["_${slot/./_}"]="${slot}.V"
			fi
		fi
	done
}

gen_render_kernels_list() {
	local ATOMS=(
		${CUSTOM_KERNEL_ATOM}
	)

	# Concat and echo are expensive in bash
	local eol_block=""
	local safe_block=""
	local atom
	local slot_version
	for slot_version in ${!_ALL_VERSIONS[@]} ; do
		local version="${_ALL_VERSIONS[${slot_version}]}"
		slot_version="${slot_version:1}"
		slot_version="${slot_version/_/.}"
		local slot=$(ver_cut 1-2 "${slot_version}")
		if [[ "${version}" == "EOL" || "${version}" =~ "V" ]] ; then
			eol_block+="
				!=sys-kernel/gentoo-kernel-bin-${slot}*
				!=sys-kernel/gentoo-kernel-${slot}*
				!=sys-kernel/gentoo-sources-${slot}*
				!=sys-kernel/vanilla-kernel-${slot}*
				!=sys-kernel/vanilla-sources-${slot}*
				!=sys-kernel/git-sources-${slot}*
				!=sys-kernel/mips-sources-${slot}*
				!=sys-kernel/pf-sources-${slot}*
				!=sys-kernel/rt-sources-${slot}*
				!=sys-kernel/zen-sources-${slot}*
				!=sys-kernel/raspberrypi-sources-${slot}*
				!=sys-kernel/linux-next-${slot}*
				!=sys-kernel/asahi-sources-${slot}*
				!=sys-kernel/ot-sources-${slot}*
			"
			for atom in ${ATOMS[@]} ; do
				eol_block+="
					!=${atom}-${slot}*
				"
			done
		else
			local t=""
			for atom in ${ATOMS[@]} ; do
				t+="
				(
					=${atom}-${slot}*
					>=${atom}-${version}
				)
				"
			done
			local c3=$(ver_cut 3 ${version})
			[[ -z "${c3}" ]] && c3="0"

	# It is inefficient because each package has a different slotting
	# template.
			local i
			for (( i=0 ; i < ${c3} ; i++ )) ; do
				eol_block+="
					!~sys-kernel/gentoo-kernel-bin-${slot}.${i}
					!~sys-kernel/gentoo-kernel-${slot}.${i}
					!~sys-kernel/gentoo-sources-${slot}.${i}
					!~sys-kernel/vanilla-kernel-${slot}.${i}
					!~sys-kernel/vanilla-sources-${slot}.${i}
					!~sys-kernel/git-sources-${slot}.${i}
					!~sys-kernel/mips-sources-${slot}.${i}
					!~sys-kernel/pf-sources-${slot}.${i}
					!~sys-kernel/rt-sources-${slot}.${i}
					!~sys-kernel/zen-sources-${slot}.${i}
					!~sys-kernel/raspberrypi-sources-${slot}.${i}
					!~sys-kernel/linux-next-${slot}.${i}
					!~sys-kernel/asahi-sources-${slot}.${i}
					!~sys-kernel/ot-sources-${slot}.${i}
				"
				for atom in ${ATOMS[@]} ; do
				eol_block+="
					!~${atom}-${slot}.${i}
				"
				done
			done

			safe_block+="
			${slot/./_}? (
				|| (
					(
						=sys-kernel/gentoo-kernel-bin-${slot}*
						>=sys-kernel/gentoo-kernel-bin-${version}
					)
					(
						=sys-kernel/gentoo-kernel-${slot}*
						>=sys-kernel/gentoo-kernel-${version}
					)
					(
						=sys-kernel/gentoo-sources-${slot}*
						>=sys-kernel/gentoo-sources-${version}
					)
					(
						=sys-kernel/vanilla-kernel-${slot}*
						>=sys-kernel/vanilla-kernel-${version}
					)
					(
						=sys-kernel/vanilla-sources-${slot}*
						>=sys-kernel/vanilla-sources-${version}
					)
					(
						=sys-kernel/git-sources-${slot}*
						>=sys-kernel/git-sources-${version}
					)
					(
						=sys-kernel/mips-sources-${slot}*
						>=sys-kernel/mips-sources-${version}
					)
					(
						=sys-kernel/pf-sources-${slot}*
						>=sys-kernel/pf-sources-${version}
					)
					(
						=sys-kernel/rt-sources-${slot}*
						>=sys-kernel/rt-sources-${version}
					)
					(
						=sys-kernel/zen-sources-${slot}*
						>=sys-kernel/zen-sources-${version}
					)
					(
						=sys-kernel/raspberrypi-sources-${slot}*
						>=sys-kernel/raspberrypi-sources-${version}
					)
					(
						=sys-kernel/linux-next-${slot}*
						>=sys-kernel/linux-next-${version}
					)
					(
						=sys-kernel/asahi-sources-${slot}*
						>=sys-kernel/asahi-sources-${version}
					)
					(
						=sys-kernel/ot-sources-${slot}*
						>=sys-kernel/ot-sources-${version}
					)
					${t}
				)
			)
			"
		fi
	done
	echo "
		${safe_block}
		${eol_block}
	"
}

gen_linux_firmware_ge() {
	local arg="${1}"
	if ver_test ${arg} -gt ${_LINUX_FIRMWARE_PV} ; then
		_LINUX_FIRMWARE_PV=${arg}
	fi
}

gen_intel_microcode_ge() {
	local arg="${1}"
	if ver_test ${arg} -gt ${_INTEL_MICROCODE_PV} ; then
		_INTEL_MICROCODE_PV=${arg}
	fi
}

_use() {
	local arg="${1}"
	local L=(
		${USE}
	)
	local x
	for x in ${L[@]} ; do
		if [[ "${x}" == "${arg}" ]] ; then
			return 0
		fi
	done
	return 1
}

# Mitigated with RFI flush not KPTI
_mitigate_id_meltdown_rdepend_ppc64() {
	if _use cpu_target_ppc_power7 ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_ppc_power8 ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_ppc_power9 ; then
		gen_patched_kernel_list 4.15
	fi
}

_mitigate_id_spectre_v1_rdepend_x86_64() {
	if _use cpu_target_x86_haswell ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_broadwell ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_skylake ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_cooper_lake ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_hewitt_lake ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_apollo_lake ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_denverton ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_ice_lake ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_gemini_lake ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_snow_ridge_bts ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_parker_ridge ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_tiger_lake ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_amber_lake_gen8 ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_kaby_lake_gen7 ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_coffee_lake_gen8 ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_kaby_lake_gen8 ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_whiskey_lake ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_comet_lake ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_sapphire_rapids ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_sapphire_rapids_edge_enhanced ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_elkhart_lake ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_alder_lake ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_catlow_golden_cove ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_arizona_beach ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_jasper_lake ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_kaby_lake_gen7 ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_kaby_lake_gen8 ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_coffee_lake_gen9 ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_comet_lake ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_rocket_lake ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_meteor_lake ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_granite_rapids ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_sierra_forest ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_raptor_lake_gen13 ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_raptor_lake_gen14 ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_catlow_raptor_cove ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_alder_lake_n ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_emerald_rapids ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_x86_cascade_lake ; then
		gen_patched_kernel_list 4.16
	fi
	if _use kvm ; then
		gen_patched_kernel_list 5.6
	fi

	if [[ "${FIRMWARE_VENDOR}" == "amd" ]] ; then
		gen_patched_kernel_list 4.16
	fi
	if [[ "${FIRMWARE_VENDOR}" == "intel" ]] ; then
		gen_patched_kernel_list 4.16
	fi
}
_mitigate_id_spectre_v1_rdepend_x86_32() {
	_mitigate_id_spectre_v1_rdepend_x86_64
}

_mitigate_id_spectre_v2_rdepend_x86_64() {
	if _use cpu_target_x86_haswell ; then
		gen_patched_kernel_list 4.15
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
	if _use cpu_target_x86_broadwell ; then
		gen_patched_kernel_list 4.15
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
	if _use cpu_target_x86_skylake ; then
		gen_patched_kernel_list 4.15
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
	if _use cpu_target_x86_cooper_lake ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_hewitt_lake ; then
		gen_patched_kernel_list 4.15
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
	if _use cpu_target_x86_apollo_lake ; then
		gen_patched_kernel_list 4.15
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
	if _use cpu_target_x86_denverton ; then
		gen_patched_kernel_list 4.15
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
	if _use cpu_target_x86_ice_lake ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_gemini_lake ; then
		gen_patched_kernel_list 4.15
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
	if _use cpu_target_x86_snow_ridge_bts ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_parker_ridge ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_tiger_lake ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_amber_lake_gen8 ; then
		gen_patched_kernel_list 4.15
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen7 ; then
		gen_patched_kernel_list 4.15
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
	if _use cpu_target_x86_coffee_lake_gen8 ; then
		gen_patched_kernel_list 4.15
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen8 ; then
		gen_patched_kernel_list 4.15
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
	if _use cpu_target_x86_whiskey_lake ; then
		gen_patched_kernel_list 4.15
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
	if _use cpu_target_x86_comet_lake ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_amber_lake_gen10 ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_sapphire_rapids ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_sapphire_rapids_edge_enhanced ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_elkhart_lake ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_alder_lake ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_catlow_golden_cove ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_arizona_beach ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_jasper_lake ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_kaby_lake_gen7 ; then
		gen_patched_kernel_list 4.15
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen8 ; then
		gen_patched_kernel_list 4.15
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
	if _use cpu_target_x86_coffee_lake_gen9 ; then
		gen_patched_kernel_list 4.15
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
	if _use cpu_target_x86_comet_lake ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_rocket_lake ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_meteor_lake ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_granite_rapids ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_sierra_forest ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_raptor_lake_gen13 ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_raptor_lake_gen14 ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_catlow_raptor_cove ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_alder_lake_n ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_emerald_rapids ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_cascade_lake ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_zen ; then
		if _use firmware ; then
			gen_linux_firmware_ge 20181128
		fi
	fi
	if _use cpu_target_x86_zen_plus ; then
		if _use firmware ; then
			gen_linux_firmware_ge 20181128
		fi
	fi
	if _use cpu_target_x86_zen_2 ; then
		if _use firmware ; then
			gen_linux_firmware_ge 20181128
		fi
	fi
	if _use cpu_target_x86_zen_3 ; then
		if _use firmware ; then
			gen_linux_firmware_ge 20181128
		fi
	fi
	if _use bpf ; then
		gen_patched_kernel_list 5.13
	fi

# TODO: replace with family
#	if _use cpu_target_x86_amd_fam_0fh
	if [[ "${FIRMWARE_VENDOR}" == "amd" ]] ; then
		gen_patched_kernel_list 4.15
	fi
	if [[ "${FIRMWARE_VENDOR}" == "intel" ]] ; then
		gen_patched_kernel_list 4.15
	fi
}

_mitigate_id_spectre_v1_v2_v3_rdepend_x86_64() {
	if _use cpu_target_x86_arrandale ; then
		gen_patched_kernel_list 4.16
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
	if _use cpu_target_x86_broxton ; then
		gen_patched_kernel_list 4.16
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
	if _use cpu_target_x86_clarkdale ; then
		gen_patched_kernel_list 4.16
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
	if _use cpu_target_x86_gladden ; then
		gen_patched_kernel_list 4.16
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
	if _use cpu_target_x86_lynnfield ; then
		gen_patched_kernel_list 4.16
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
	if _use cpu_target_x86_nehalem ; then
		gen_patched_kernel_list 4.16
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
	if _use cpu_target_x86_westmere ; then
		gen_patched_kernel_list 4.16
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi

	if _use cpu_target_x86_sandy_bridge ; then
		gen_patched_kernel_list 4.16
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
	if _use cpu_target_x86_ivy_bridge ; then
		gen_patched_kernel_list 4.16
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
	if _use cpu_target_x86_bakerville ; then
		gen_patched_kernel_list 4.16
		if _use firmware ; then
			gen_intel_microcode_ge 20180425
		fi
	fi
}
_mitigate_id_spectre_v1_v2_v3_rdepend_x86_32() {
	_mitigate_id_spectre_v1_v2_v3_rdepend_x86_64
}

_mitigate_id_meltdown_rdepend_x86_64() {
	gen_patched_kernel_list 4.15
	if _use cpu_target_x86_haswell ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_broadwell ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_hewitt_lake ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_skylake ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_kaby_lake_gen7 ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_amber_lake_gen8 ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_coffee_lake_gen8 ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_kaby_lake_gen8 ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_whiskey_lake ; then
		gen_patched_kernel_list 4.15
	fi
	if _use cpu_target_x86_gemini_lake ; then
		gen_patched_kernel_list 4.15
	fi
}

# Only if it supports PAE
_mitigate_id_meltdown_rdepend_x86_32() {
	_mitigate_id_meltdown_rdepend_x86_64
}

_mitigate_id_meltdown_rdepend_arm64() {
	if _use cpu_target_arm_cortex_a75 ; then
		gen_patched_kernel_list 4.16
	fi
}
# Variant 3a (4.16), Variant 4 (4.18) \
_mitigate_id_spectre_ng_rdepend_arm64() {
	if _use cpu_target_arm_cortex_a15 ; then
		gen_patched_kernel_list 4.16
	fi

	if _use cpu_target_arm_cortex_a57 ; then
		gen_patched_kernel_list 4.18
	fi
	if _use cpu_target_arm_cortex_a72 ; then
		gen_patched_kernel_list 4.18
	fi
	if _use cpu_target_arm_cortex_a73 ; then
		gen_patched_kernel_list 4.18
	fi
	if _use cpu_target_arm_cortex_a75 ; then
		gen_patched_kernel_list 4.18
	fi
	if _use cpu_target_arm_cortex_a76 ; then
		gen_patched_kernel_list 4.20
	fi
	if _use cpu_target_arm_cortex_a77 ; then
		gen_patched_kernel_list 4.18
	fi
	if _use cpu_target_arm_neoverse_n1 ; then
		gen_patched_kernel_list 4.20
	fi
	if _use bpf ; then
		gen_patched_kernel_list 5.13
	fi
}

# Firmware date based on D distro even though it may be removed from microcode repo.
# List for mitigations against Variant 4 and Variant 3a
_mitigate_id_spectre_ng_rdepend_x86_64() {
	if _use cpu_target_x86_gemini_lake ; then
		gen_patched_kernel_list 4.17
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_haswell ; then
		gen_patched_kernel_list 4.17
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_broadwell ; then
		gen_patched_kernel_list 4.17
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_hewitt_lake ; then
		gen_patched_kernel_list 4.17
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_skylake ; then
		gen_patched_kernel_list 4.17
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen7 ; then
		gen_patched_kernel_list 4.17
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_amber_lake_gen8 ; then
		gen_patched_kernel_list 4.17
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_coffee_lake_gen8 ; then
		gen_patched_kernel_list 4.17
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen8 ; then
		gen_patched_kernel_list 4.17
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_whiskey_lake ; then
		gen_patched_kernel_list 4.17
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_coffee_lake_gen9 ; then
		gen_patched_kernel_list 4.17
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_comet_lake ; then
		gen_patched_kernel_list 4.17
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_amber_lake_gen10 ; then
		gen_patched_kernel_list 4.17
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_ice_lake ; then
		gen_patched_kernel_list 4.17
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_rocket_lake ; then
		gen_patched_kernel_list 4.17
	fi
	if _use cpu_target_x86_tiger_lake ; then
		gen_patched_kernel_list 4.17
	fi
	if _use cpu_target_x86_alder_lake ; then
		gen_patched_kernel_list 4.17
	fi
	if _use cpu_target_x86_raptor_lake_gen13 ; then
		gen_patched_kernel_list 4.17
	fi
	if _use cpu_target_x86_raptor_lake_gen14 ; then
		gen_patched_kernel_list 4.17
	fi
	if _use cpu_target_x86_meteor_lake ; then
		gen_patched_kernel_list 4.17
	fi

	if _use cpu_target_x86_cascade_lake ; then
		gen_patched_kernel_list 4.17
	fi
	if _use cpu_target_x86_cooper_lake ; then
		gen_patched_kernel_list 4.17
	fi
	if _use cpu_target_x86_sapphire_rapids ; then
		gen_patched_kernel_list 4.17
	fi
	if _use cpu_target_x86_sapphire_rapids_edge_enhanced ; then
		gen_patched_kernel_list 4.17
	fi
	if _use cpu_target_x86_granite_rapids ; then
		gen_patched_kernel_list 4.17
	fi
	if _use cpu_target_x86_emerald_rapids ; then
		gen_patched_kernel_list 4.17
	fi
	if _use cpu_target_x86_sierra_forest ; then
		gen_patched_kernel_list 4.17
	fi

	if _use cpu_target_x86_catlow_golden_cove ; then
		gen_patched_kernel_list 4.17
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_catlow_raptor_cove ; then
		gen_patched_kernel_list 4.17
	fi

	if _use bpf ; then
		gen_patched_kernel_list 5.13
	fi
}
_mitigate_id_spectre_NG_rdepend_x86_32() {
	_mitigate_id_spectre_ng_rdepend_x86_64
}

_mitigate_id_spectre_v2_rdepend_s390x() {
	gen_patched_kernel_list 4.16
	if _use bpf ; then
		gen_patched_kernel_list 5.13
	fi
}

_mitigate_id_spectre_rsb_rdepend_x86_64() {
	gen_patched_kernel_list 4.19
}
_mitigate_id_spectre_rsb_rdepend_x86_32() {
	_mitigate_id_spectre_rsb_rdepend_x86_64
}

_mitigate_id_spectre_rsba_rdepend_x86_64() {
	if _use cpu_target_x86_skylake ; then
		gen_patched_kernel_list 5.19
	fi
	if _use cpu_target_x86_ice_lake ; then
		gen_patched_kernel_list 5.19
	fi

	if _use cpu_target_x86_amber_lake_gen8 ; then
		gen_patched_kernel_list 5.19
	fi
	if _use cpu_target_x86_coffee_lake_gen8 ; then
		gen_patched_kernel_list 5.19
	fi


	if _use cpu_target_x86_whiskey_lake ; then
		gen_patched_kernel_list 5.19
	fi

	if _use cpu_target_x86_kaby_lake_gen7 ; then
		gen_patched_kernel_list 5.19
	fi
	if _use cpu_target_x86_kaby_lake_gen8 ; then
		gen_patched_kernel_list 5.19
	fi

	if _use cpu_target_x86_coffee_lake_gen9 ; then
		gen_patched_kernel_list 5.19
	fi
}
_mitigate_id_spectre_rsba_rdepend_x86_32() {
	_mitigate_id_spectre_rsba_rdepend_x86_64
}

# The firmware is required for mitigation, but the date below is not verified
# to contain the fix.  It is based on the monotonic numbering of the advisory
# in the commit summary.
_mitigate_id_spectre_rrsba_rdepend_x86_64() {
	if _use cpu_target_x86_cooper_lake ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_x86_whiskey_lake ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_x86_comet_lake ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_x86_amber_lake_gen10 ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_x86_sapphire_rapids ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_x86_sapphire_rapids_edge_enhanced ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_x86_alder_lake ; then
		gen_patched_kernel_list 5.17
		if _use firmware ; then
			gen_intel_microcode_ge 20230214
		fi
	fi
	if _use cpu_target_x86_cascade_lake ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_x86_coffee_lake_gen9 ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_x86_comet_lake ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_x86_meteor_lake ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_x86_granite_rapids ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_x86_sierra_forest ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_x86_raptor_lake_gen13 ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_x86_raptor_lake_gen14 ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_x86_catlow_raptor_cove ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_x86_emerald_rapids ; then
		gen_patched_kernel_list 5.17
	fi
}

_mitigate_id_spectre_rrsba_rdepend_x86_32() {
	_mitigate_id_spectre_rrsba_rdepend_x86_64
}

# broxton needs verification
_mitigate_id_foreshadow_rdepend_x86_64() {
	if _use cpu_target_x86_arrandale ; then
		gen_patched_kernel_list 4.19
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_clarkdale ; then
		gen_patched_kernel_list 4.19
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_gladden ; then
		gen_patched_kernel_list 4.19
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_lynnfield ; then
		gen_patched_kernel_list 4.19
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_bakerville ; then
		gen_patched_kernel_list 4.19
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi

	if _use cpu_target_x86_nehalem ; then
		gen_patched_kernel_list 4.19
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_westmere ; then
		gen_patched_kernel_list 4.19
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_sandy_bridge ; then
		gen_patched_kernel_list 4.19
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_ivy_bridge ; then
		gen_patched_kernel_list 4.19
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_haswell ; then
		gen_patched_kernel_list 4.19
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_broadwell ; then
		gen_patched_kernel_list 4.19
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_hewitt_lake ; then
		gen_patched_kernel_list 4.19
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_skylake ; then
		gen_patched_kernel_list 4.19
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen7 ; then
		gen_patched_kernel_list 4.19
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_amber_lake_gen8 ; then
		gen_patched_kernel_list 4.19
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_coffee_lake_gen8 ; then
		gen_patched_kernel_list 4.19
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen8 ; then
		gen_patched_kernel_list 4.19
		if _use firmware ; then
			gen_intel_microcode_ge 20180807
		fi
	fi
	if _use kvm ; then
		gen_patched_kernel_list 5.6
	fi
}
_mitigate_id_foreshadow_rdepend_x86_32() {
	_mitigate_id_foreshadow_rdepend_x86_64
}


_mitigate_id_spectre_v2_rdepend_ppc32() {
	if _use cpu_target_ppc_85xx ; then
		gen_patched_kernel_list 5.0
	fi
	if _use cpu_target_ppc_e500mc ; then
		gen_patched_kernel_list 5.0
	fi
}

_mitigate_id_spectre_v2_rdepend_ppc64() {
	if _use cpu_target_ppc_e5500 ; then
		gen_patched_kernel_list 5.0
	fi
	if _use cpu_target_ppc_e6500 ; then
		gen_patched_kernel_list 5.0
	fi
}

# MFBDS, MLPDS, MSBDS
_mitigate_id_MDS_rdepend_x86_64() {
	if _use cpu_target_x86_haswell ; then
		gen_patched_kernel_list 5.2
		if _use firmware ; then
			gen_intel_microcode_ge 20190618
		fi
	fi
	if _use cpu_target_x86_broadwell ; then
		gen_patched_kernel_list 5.2
		if _use firmware ; then
			gen_intel_microcode_ge 20190618
		fi
	fi
	if _use cpu_target_x86_hewitt_lake ; then
		gen_patched_kernel_list 5.2
		if _use firmware ; then
			gen_intel_microcode_ge 20190618
		fi
	fi
	if _use cpu_target_x86_skylake ; then
		gen_patched_kernel_list 5.2
		if _use firmware ; then
			gen_intel_microcode_ge 20190618
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen7 ; then
		gen_patched_kernel_list 5.2
		if _use firmware ; then
			gen_intel_microcode_ge 20190618
		fi
	fi
	if _use cpu_target_x86_amber_lake_gen8 ; then
		gen_patched_kernel_list 5.2
		if _use firmware ; then
			gen_intel_microcode_ge 20190618
		fi
	fi
	if _use cpu_target_x86_coffee_lake_gen8 ; then
		gen_patched_kernel_list 5.2
		if _use firmware ; then
			gen_intel_microcode_ge 20190618
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen8 ; then
		gen_patched_kernel_list 5.2
		if _use firmware ; then
			gen_intel_microcode_ge 20190618
		fi
	fi
	if _use cpu_target_x86_whiskey_lake ; then
		gen_patched_kernel_list 5.2
		if _use firmware ; then
			gen_intel_microcode_ge 20190618
		fi
	fi
	if _use cpu_target_x86_coffee_lake_gen9 ; then
		gen_patched_kernel_list 5.2
		if _use firmware ; then
			gen_intel_microcode_ge 20190618
		fi
	fi

	if _use cpu_target_x86_comet_lake ; then
		gen_patched_kernel_list 5.2
		if _use firmware ; then
			gen_intel_microcode_ge 20190618
		fi
	fi
	if _use cpu_target_x86_ice_lake ; then
		gen_patched_kernel_list 5.2
		if _use firmware ; then
			gen_intel_microcode_ge 20190618
		fi
	fi
}
_mitigate_id_MDS_rdepend_x86_32() {
	_mitigate_id_MDS_rdepend_x86_64
}

_mitigate_id_swapgs_rdepend_x86_64() {
	if _use cpu_target_x86_apollo_lake ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_denverton ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_snow_ridge_bts ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_snow_ridge ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_parker_ridge ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_elkhart_lake ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_arizona_beach ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_jasper_lake ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_alder_lake_n ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_gemini_lake ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_haswell ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_broadwell ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_hewitt_lake ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_skylake ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_kaby_lake_gen7 ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_amber_lake_gen8 ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_coffee_lake_gen8 ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_kaby_lake_gen8 ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_whiskey_lake ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_coffee_lake_gen9 ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_comet_lake ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_amber_lake_gen10 ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_ice_lake ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_rocket_lake ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_tiger_lake ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_alder_lake ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_raptor_lake_gen13 ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_raptor_lake_gen14 ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_meteor_lake ; then
		gen_patched_kernel_list 5.3
	fi

	if _use cpu_target_x86_cascade_lake ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_cooper_lake ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_sapphire_rapids ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_sapphire_rapids_edge_enhanced ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_granite_rapids ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_emerald_rapids ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_sierra_forest ; then
		gen_patched_kernel_list 5.3
	fi

	if _use cpu_target_x86_catlow_golden_cove ; then
		gen_patched_kernel_list 5.3
	fi
	if _use cpu_target_x86_catlow_raptor_cove ; then
		gen_patched_kernel_list 5.3
	fi

}
_mitigate_id_swapgs_rdepend_x86_32() {
	_mitigate_id_swapgs_rdepend_x86_64
}

# Only >= Gen6 firmware
_mitigate_id_zombieload_v2_rdepend_x86_64() {
	if _use cpu_target_x86_haswell ; then
		gen_patched_kernel_list 5.4
	fi
	if _use cpu_target_x86_broadwell ; then
		gen_patched_kernel_list 5.4
	fi
	if _use cpu_target_x86_hewitt_lake ; then
		gen_patched_kernel_list 5.4
	fi
	if _use cpu_target_x86_skylake ; then
		gen_patched_kernel_list 5.4
		if _use firmware ; then
			gen_intel_microcode_ge 20191112
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen7 ; then
		gen_patched_kernel_list 5.4
		if _use firmware ; then
			gen_intel_microcode_ge 20191112
		fi
	fi
	if _use cpu_target_x86_amber_lake_gen8 ; then
		gen_patched_kernel_list 5.4
		if _use firmware ; then
			gen_intel_microcode_ge 20191112
		fi
	fi
	if _use cpu_target_x86_coffee_lake_gen8 ; then
		gen_patched_kernel_list 5.4
		if _use firmware ; then
			gen_intel_microcode_ge 20191112
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen8 ; then
		gen_patched_kernel_list 5.4
		if _use firmware ; then
			gen_intel_microcode_ge 20191112
		fi
	fi
	if _use cpu_target_x86_whiskey_lake ; then
		gen_patched_kernel_list 5.4
		if _use firmware ; then
			gen_intel_microcode_ge 20191112
		fi
	fi
	if _use cpu_target_x86_coffee_lake_gen9 ; then
		gen_patched_kernel_list 5.4
		if _use firmware ; then
			gen_intel_microcode_ge 20191112
		fi
	fi
	if _use cpu_target_x86_comet_lake ; then
		gen_patched_kernel_list 5.4
		if _use firmware ; then
			gen_intel_microcode_ge 20191112
		fi
	fi
	if _use cpu_target_x86_amber_lake_gen10 ; then
		gen_patched_kernel_list 5.4
		if _use firmware ; then
			gen_intel_microcode_ge 20191112
		fi
	fi

	if _use cpu_target_x86_cascade_lake ; then
		gen_patched_kernel_list 5.4
		if _use firmware ; then
			gen_intel_microcode_ge 20191112
		fi
	fi
}
_mitigate_id_zombieload_v2_rdepend_x86_32() {
	_mitigate_id_zombieload_v2_rdepend_x86_64
}

_mitigate_id_cacheout_rdepend_x86_64() {
	if _use cpu_target_x86_skylake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20200609
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen7 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20200609
		fi
	fi
	if _use cpu_target_x86_amber_lake_gen8 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20200609
		fi
	fi
	if _use cpu_target_x86_coffee_lake_gen8 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20200609
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen8 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20200609
		fi
	fi
	if _use cpu_target_x86_whiskey_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20200609
		fi
	fi
	if _use cpu_target_x86_coffee_lake_gen9 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20200609
		fi
	fi
	if _use cpu_target_x86_comet_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20200609
		fi
	fi
	if _use cpu_target_x86_amber_lake_gen10 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20200609
		fi
	fi

	if _use cpu_target_x86_cascade_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20200609
		fi
	fi

}
_mitigate_id_cacheout_rdepend_x86_32() {
	_mitigate_id_cacheout_rdepend_x86_64
}

_mitigate_id_vrsa_rdepend_x86_64() {
	if _use cpu_target_x86_skylake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20210125
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen7 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20210125
		fi
	fi
	if _use cpu_target_x86_amber_lake_gen8 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20210125
		fi
	fi
	if _use cpu_target_x86_coffee_lake_gen8 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20210125
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen8 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20210125
		fi
	fi
	if _use cpu_target_x86_whiskey_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20210125
		fi
	fi
	if _use cpu_target_x86_coffee_lake_gen9 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20210125
		fi
	fi
	if _use cpu_target_x86_comet_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20210125
		fi
	fi
	if _use cpu_target_x86_amber_lake_gen10 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20210125
		fi
	fi

	if _use cpu_target_x86_cascade_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20210125
		fi
	fi

}
_mitigate_id_vrsa_rdepend_x86_32() {
	_mitigate_id_vrsa_rdepend_x86_64
}

# See commit 80eb5fe
_mitigate_id_spectre_rsb_rdepend_ppc64() {
	gen_patched_kernel_list 5.5
}
_mitigate_id_spectre_rsb_rdepend_ppc32() {
	_mitigate_id_spectre_rsb_rdepend_ppc64
}

_mitigate_id_crosstalk_rdepend_x86_64() {
	if _use cpu_target_x86_skylake ; then
		gen_patched_kernel_list 5.8
		if _use firmware ; then
			gen_intel_microcode_ge 20200609
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen7 ; then
		gen_patched_kernel_list 5.8
		if _use firmware ; then
			gen_intel_microcode_ge 20200609
		fi
	fi
	if _use cpu_target_x86_amber_lake_gen8 ; then
		gen_patched_kernel_list 5.8
		if _use firmware ; then
			gen_intel_microcode_ge 20200609
		fi
	fi
	if _use cpu_target_x86_coffee_lake_gen8 ; then
		gen_patched_kernel_list 5.8
		if _use firmware ; then
			gen_intel_microcode_ge 20200609
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen8 ; then
		gen_patched_kernel_list 5.8
		if _use firmware ; then
			gen_intel_microcode_ge 20200609
		fi
	fi
	if _use cpu_target_x86_whiskey_lake ; then
		gen_patched_kernel_list 5.8
		if _use firmware ; then
			gen_intel_microcode_ge 20200609
		fi
	fi
	if _use cpu_target_x86_comet_lake ; then
		gen_patched_kernel_list 5.8
		if _use firmware ; then
			gen_intel_microcode_ge 20200609
		fi
	fi
	if _use cpu_target_x86_coffee_lake_gen9 ; then
		gen_patched_kernel_list 5.8
		if _use firmware ; then
			gen_intel_microcode_ge 20200609
		fi
	fi
	if _use cpu_target_x86_amber_lake_gen10 ; then
		gen_patched_kernel_list 5.8
		if _use firmware ; then
			gen_intel_microcode_ge 20200609
		fi
	fi
}
_mitigate_id_crosstalk_rdepend_x86_32() {
	_mitigate_id_crosstalk_rdepend_x86_64
}

_mitigate_id_spectre_v2_rdepend_arm64() {

	if _use cpu_target_arm_brahma_b15 ; then
		gen_patched_kernel_list 4.18
	fi
	if _use cpu_target_arm_cortex_a8 ; then
		gen_patched_kernel_list 4.18
	fi
	if _use cpu_target_arm_cortex_a9 ; then
		gen_patched_kernel_list 4.18
	fi
	if _use cpu_target_arm_cortex_a12 ; then
		gen_patched_kernel_list 4.18
	fi
	if _use cpu_target_arm_cortex_a15 ; then
		gen_patched_kernel_list 4.18
	fi
	if _use cpu_target_arm_cortex_a17 ; then
		gen_patched_kernel_list 4.18
	fi
	if _use cpu_target_arm_cortex_a73 ; then
		gen_patched_kernel_list 4.18
	fi
	if _use cpu_target_arm_cortex_a75 ; then
		gen_patched_kernel_list 4.18
	fi

	if _use cpu_target_arm_cortex_a57 ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_arm_cortex_a72 ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_arm_cortex_a73 ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_arm_cortex_a75 ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_arm_cortex_r7 ; then
		gen_patched_kernel_list 4.19
	fi
	if _use cpu_target_arm_cortex_r8 ; then
		gen_patched_kernel_list 4.19
	fi
	if _use cpu_target_arm_falkor ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_arm_thunderx2 ; then
		gen_patched_kernel_list 4.16
	fi
	if _use cpu_target_arm_vulkan ; then
		gen_patched_kernel_list 4.16
	fi
	if _use bpf ; then
		gen_patched_kernel_list 5.13
	fi
}
_mitigate_id_spectre_v2_rdepend_arm() {
	_mitigate_id_spectre_v2_rdepend_arm64
}

_mitigate_id_mmio_rdepend_x86_64() {
	if _use cpu_target_x86_snow_ridge_bts ; then
		gen_patched_kernel_list 5.19
		if _use firmware ; then
			gen_intel_microcode_ge 20220510
		fi
	fi
	if _use cpu_target_x86_snow_ridge ; then
		gen_patched_kernel_list 5.19
		if _use firmware ; then
			gen_intel_microcode_ge 20220510
		fi
	fi
	if _use cpu_target_x86_parker_ridge ; then
		gen_patched_kernel_list 5.19
		if _use firmware ; then
			gen_intel_microcode_ge 20220510
		fi
	fi
	if _use cpu_target_x86_elkhart_lake ; then
		gen_patched_kernel_list 5.19
		if _use firmware ; then
			gen_intel_microcode_ge 20220510
		fi
	fi
	if _use cpu_target_x86_jasper_lake ; then
		gen_patched_kernel_list 5.19
		if _use firmware ; then
			gen_intel_microcode_ge 20220510
		fi
	fi

	if _use cpu_target_x86_haswell ; then
		gen_patched_kernel_list 5.19
		if _use firmware ; then
			gen_intel_microcode_ge 20220510
		fi
	fi
	if _use cpu_target_x86_broadwell ; then
		gen_patched_kernel_list 5.19
		if _use firmware ; then
			gen_intel_microcode_ge 20220510
		fi
	fi
	if _use cpu_target_x86_hewitt_lake ; then
		gen_patched_kernel_list 5.19
		if _use firmware ; then
			gen_intel_microcode_ge 20220510
		fi
	fi
	if _use cpu_target_x86_skylake ; then
		gen_patched_kernel_list 5.19
		if _use firmware ; then
			gen_intel_microcode_ge 20220510
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen7 ; then
		gen_patched_kernel_list 5.19
		if _use firmware ; then
			gen_intel_microcode_ge 20220510
		fi
	fi
	if _use cpu_target_x86_amber_lake_gen8 ; then
		gen_patched_kernel_list 5.19
		if _use firmware ; then
			gen_intel_microcode_ge 20220510
		fi
	fi
	if _use cpu_target_x86_coffee_lake_gen8 ; then
		gen_patched_kernel_list 5.19
		if _use firmware ; then
			gen_intel_microcode_ge 20220510
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen8 ; then
		gen_patched_kernel_list 5.19
		if _use firmware ; then
			gen_intel_microcode_ge 20220510
		fi
	fi
	if _use cpu_target_x86_whiskey_lake ; then
		gen_patched_kernel_list 5.19
		if _use firmware ; then
			gen_intel_microcode_ge 20220510
		fi
	fi
	if _use cpu_target_x86_coffee_lake_gen9 ; then
		gen_patched_kernel_list 5.19
		if _use firmware ; then
			gen_intel_microcode_ge 20220510
		fi
	fi
	if _use cpu_target_x86_comet_lake ; then
		gen_patched_kernel_list 5.19
		if _use firmware ; then
			gen_intel_microcode_ge 20220510
		fi
	fi
	if _use cpu_target_x86_amber_lake_gen10 ; then
		gen_patched_kernel_list 5.19
		if _use firmware ; then
			gen_intel_microcode_ge 20220510
		fi
	fi
	if _use cpu_target_x86_ice_lake ; then
		gen_patched_kernel_list 5.19
		if _use firmware ; then
			gen_intel_microcode_ge 20220510
		fi
	fi
	if _use cpu_target_x86_rocket_lake ; then
		gen_patched_kernel_list 5.19
		if _use firmware ; then
			gen_intel_microcode_ge 20220510
		fi
	fi
	if _use cpu_target_x86_tiger_lake ; then
		gen_patched_kernel_list 5.19
		if _use firmware ; then
			gen_intel_microcode_ge 20220510
		fi
	fi

	if _use cpu_target_x86_cascade_lake ; then
		gen_patched_kernel_list 5.19
		if _use firmware ; then
			gen_intel_microcode_ge 20220510
		fi
	fi
	if _use cpu_target_x86_cooper_lake ; then
		gen_patched_kernel_list 5.19
		if _use firmware ; then
			gen_intel_microcode_ge 20220510
		fi
	fi
	if _use cpu_target_x86_lakefield ; then
		gen_patched_kernel_list 5.19
	fi
}
_mitigate_id_mmio_rdepend_x86_32() {
	_mitigate_id_mmio_rdepend_x86_64
}

_mitigate_id_retbleed_rdepend_x86_64() {
	if _use cpu_target_x86_skylake ; then
		gen_patched_kernel_list 5.19
	fi
	if _use cpu_target_x86_kaby_lake_gen7 ; then
		gen_patched_kernel_list 5.19
	fi
	if _use cpu_target_x86_amber_lake_gen8 ; then
		gen_patched_kernel_list 5.19
	fi
	if _use cpu_target_x86_coffee_lake_gen8 ; then
		gen_patched_kernel_list 5.19
	fi
	if _use cpu_target_x86_kaby_lake_gen8 ; then
		gen_patched_kernel_list 5.19
	fi
	if _use cpu_target_x86_cannon_lake ; then
		gen_patched_kernel_list 5.19
	fi
	if _use cpu_target_x86_whiskey_lake ; then
		gen_patched_kernel_list 5.19
	fi
	if _use cpu_target_x86_amber_lake_gen10 ; then
		gen_patched_kernel_list 5.19
	fi
	if _use cpu_target_x86_lakefield ; then
		gen_patched_kernel_list 5.19
	fi
	if _use cpu_target_x86_bulldozer ; then
		gen_patched_kernel_list 5.19
	fi
	if _use cpu_target_x86_piledriver ; then
		gen_patched_kernel_list 5.19
	fi
	if _use cpu_target_x86_steamroller ; then
		gen_patched_kernel_list 5.19
	fi
	if _use cpu_target_x86_excavator ; then
		gen_patched_kernel_list 5.19
	fi
	if _use cpu_target_x86_jaguar ; then
		gen_patched_kernel_list 5.19
	fi
	if _use cpu_target_x86_puma ; then
		gen_patched_kernel_list 5.19
	fi
	if _use cpu_target_x86_zen ; then
		gen_patched_kernel_list 5.19
	fi
	if _use cpu_target_x86_zen_plus ; then
		gen_patched_kernel_list 5.19
	fi
	if _use cpu_target_x86_zen_2 ; then
		gen_patched_kernel_list 5.19
	fi
	if _use cpu_target_x86_dhyana ; then
		gen_patched_kernel_list 5.19
	fi
}

_mitigate_id_bhb_rdepend_arm64() {
	if _use cpu_target_arm_ampereone ; then
		gen_patched_kernel_list 6.1
	fi
	if _use cpu_target_arm_brahma_b15 ; then
		gen_patched_kernel_list 5.18
	fi
	if _use cpu_target_arm_cortex_r7 ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_arm_cortex_r8 ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_arm_cortex_a15 ; then
		gen_patched_kernel_list 5.18
	fi
	if _use cpu_target_arm_cortex_a57 ; then
		gen_patched_kernel_list 5.18
	fi
	if _use cpu_target_arm_cortex_a65 ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_arm_cortex_a65ae ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_arm_cortex_a72 ; then
		gen_patched_kernel_list 5.18
	fi
	if _use cpu_target_arm_cortex_a73 ; then
		gen_patched_kernel_list 5.18
	fi
	if _use cpu_target_arm_cortex_a75 ; then
		gen_patched_kernel_list 5.18
	fi
	if _use cpu_target_arm_cortex_a76 ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_arm_cortex_a77 ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_arm_cortex_a78 ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_arm_cortex_a78ae ; then
		gen_patched_kernel_list 5.18
	fi
	if _use cpu_target_arm_cortex_a78c ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_arm_cortex_a710 ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_arm_cortex_a715 ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_arm_neoverse_e1 ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_arm_neoverse_n1 ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_arm_neoverse_v1 ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_arm_neoverse_n2 ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_arm_neoverse_v2 ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_arm_cortex_x1 ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_arm_cortex_x2 ; then
		gen_patched_kernel_list 5.17
	fi
	if _use cpu_target_arm_cortex_x3 ; then
		gen_patched_kernel_list 5.17
	fi
}

_mitigate_id_bhb_rdepend_arm() {
	_mitigate_id_bhb_rdepend_arm64
}

_mitigate_id_downfall_rdepend_x86_64() {
	if _use cpu_target_x86_skylake ; then
		gen_patched_kernel_list 6.5
		if _use firmware ; then
			gen_intel_microcode_ge 20230808
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen7 ; then
		gen_patched_kernel_list 6.5
		if _use firmware ; then
			gen_intel_microcode_ge 20230808
		fi
	fi
	if _use cpu_target_x86_amber_lake_gen8 ; then
		gen_patched_kernel_list 6.5
		if _use firmware ; then
			gen_intel_microcode_ge 20230808
		fi
	fi
	if _use cpu_target_x86_coffee_lake_gen8 ; then
		gen_patched_kernel_list 6.5
		if _use firmware ; then
			gen_intel_microcode_ge 20230808
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen8 ; then
		gen_patched_kernel_list 6.5
		if _use firmware ; then
			gen_intel_microcode_ge 20230808
		fi
	fi
	if _use cpu_target_x86_whiskey_lake ; then
		gen_patched_kernel_list 6.5
		if _use firmware ; then
			gen_intel_microcode_ge 20230808
		fi
	fi
	if _use cpu_target_x86_coffee_lake_gen9 ; then
		gen_patched_kernel_list 6.5
		if _use firmware ; then
			gen_intel_microcode_ge 20230808
		fi
	fi
	if _use cpu_target_x86_comet_lake ; then
		gen_patched_kernel_list 6.5
		if _use firmware ; then
			gen_intel_microcode_ge 20230808
		fi
	fi
	if _use cpu_target_x86_amber_lake_gen10 ; then
		gen_patched_kernel_list 6.5
		if _use firmware ; then
			gen_intel_microcode_ge 20230808
		fi
	fi
	if _use cpu_target_x86_ice_lake ; then
		gen_patched_kernel_list 6.5
		if _use firmware ; then
			gen_intel_microcode_ge 20230808
		fi
	fi
	if _use cpu_target_x86_rocket_lake ; then
		gen_patched_kernel_list 6.5
		if _use firmware ; then
			gen_intel_microcode_ge 20230808
		fi
	fi
	if _use cpu_target_x86_tiger_lake ; then
		gen_patched_kernel_list 6.5
		if _use firmware ; then
			gen_intel_microcode_ge 20230808
		fi
	fi

	if _use cpu_target_x86_cascade_lake ; then
		gen_patched_kernel_list 6.5
		if _use firmware ; then
			gen_intel_microcode_ge 20230808
		fi
	fi
	if _use cpu_target_x86_cooper_lake ; then
		gen_patched_kernel_list 6.5
		if _use firmware ; then
			gen_intel_microcode_ge 20230808
		fi
	fi

}
_mitigate_id_downfall_rdepend_x86_32() {
	_mitigate_id_downfall_rdepend_x86_64
}

# Pick the top set if you have server
_mitigate_id_inception_rdepend_x86_64() {

	if _use cpu_target_x86_milan ; then
		gen_patched_kernel_list 6.9
		if _use firmware ; then
			gen_linux_firmware_ge 20230724
		fi
	fi
	if _use cpu_target_x86_milan-x ; then
		gen_patched_kernel_list 6.9
		if _use firmware ; then
			gen_linux_firmware_ge 20230724
		fi
	fi
	if _use cpu_target_x86_genoa ; then
		gen_patched_kernel_list 6.9
		if _use firmware ; then
			gen_linux_firmware_ge 20230809
		fi
	fi
	if _use cpu_target_x86_genoa-x ; then
		gen_patched_kernel_list 6.9
		if _use firmware ; then
			gen_linux_firmware_ge 20230809
		fi
	fi
	if _use cpu_target_x86_bergamo ; then
		gen_patched_kernel_list 6.9
		if _use firmware ; then
			gen_linux_firmware_ge 20230809
		fi
	fi

	if _use cpu_target_x86_zen_4 ; then
		gen_patched_kernel_list 6.9
	fi
	if _use cpu_target_x86_zen_3 ; then
		gen_patched_kernel_list 6.9
	fi
	if _use cpu_target_x86_zen_2 ; then
		gen_patched_kernel_list 6.5
	fi
	if _use cpu_target_x86_zen ; then
		gen_patched_kernel_list 6.5
	fi
}
_mitigate_id_inception_rdepend_x86_32() {
	_mitigate_id_inception_rdepend_x86_64
}

_mitigate_id_rfds_rdepend_x86_64() {
	if _use cpu_target_x86_apollo_lake ; then
		gen_patched_kernel_list 6.9
		if _use firmware ; then
			gen_intel_microcode_ge 20240312
		fi
	fi
	if _use cpu_target_x86_denverton ; then
		gen_patched_kernel_list 6.9
		if _use firmware ; then
			gen_intel_microcode_ge 20240312
		fi
	fi
	if _use cpu_target_x86_snow_ridge ; then
		gen_patched_kernel_list 6.9
		if _use firmware ; then
			gen_intel_microcode_ge 20240312
		fi
	fi
	if _use cpu_target_x86_parker_ridge ; then
		gen_patched_kernel_list 6.9
		if _use firmware ; then
			gen_intel_microcode_ge 20240312
		fi
	fi
	if _use cpu_target_x86_elkhart_lake ; then
		gen_patched_kernel_list 6.9
		if _use firmware ; then
			gen_intel_microcode_ge 20240312
		fi
	fi
	if _use cpu_target_x86_arizona_beach ; then
		gen_patched_kernel_list 6.9
		if _use firmware ; then
			gen_intel_microcode_ge 20240312
		fi
	fi
	if _use cpu_target_x86_jasper_lake ; then
		gen_patched_kernel_list 6.9
		if _use firmware ; then
			gen_intel_microcode_ge 20240312
		fi
	fi
	if _use cpu_target_x86_alder_lake ; then
		gen_patched_kernel_list 6.9
		if _use firmware ; then
			gen_intel_microcode_ge 20240312
		fi
	fi
	if _use cpu_target_x86_catlow_golden_cove ; then
		gen_patched_kernel_list 6.9
		if _use firmware ; then
			gen_intel_microcode_ge 20240312
		fi
	fi
	if _use cpu_target_x86_alder_lake_n ; then
		gen_patched_kernel_list 6.9
		if _use firmware ; then
			gen_intel_microcode_ge 20240312
		fi
	fi
	if _use cpu_target_x86_raptor_lake_gen13 ; then
		gen_patched_kernel_list 6.9
		if _use firmware ; then
			gen_intel_microcode_ge 20240312
		fi
	fi
	if _use cpu_target_x86_raptor_lake_gen14 ; then
		gen_patched_kernel_list 6.9
		if _use firmware ; then
			gen_intel_microcode_ge 20240312
		fi
	fi
	if _use cpu_target_x86_emerald_rapids ; then
		gen_patched_kernel_list 6.9
		if _use firmware ; then
			gen_intel_microcode_ge 20240312
		fi
	fi
}
_mitigate_id_rfds_rdepend_x86_32() {
	_mitigate_id_rfds_rdepend_x86_64
}


_mitigate_id_zenbleed_rdepend_x86_64() {
	if _use cpu_target_x86_rome ; then
		gen_patched_kernel_list 6.9
		if _use firmware ; then
			gen_linux_firmware_ge 20231205
		fi
	fi
	if _use cpu_target_x86_zen_2 ; then
		gen_patched_kernel_list 6.9
	fi

}
_mitigate_id_zenbleed_rdepend_x86_32() {
	_mitigate_id_zenbleed_rdepend_x86_64
}

# The 12th Gen needs microcode but it is not documented for the version
# requirement.  The date of the advisory is _used as a placeholder.
_mitigate_id_bhi_rdepend_x86_64() {
	if _use cpu_target_x86_gemini_lake ; then
		gen_patched_kernel_list 6.9
	fi
	if _use cpu_target_x86_amber_lake_gen8 ; then
		gen_patched_kernel_list 6.9
	fi
	if _use cpu_target_x86_whiskey_lake ; then
		gen_patched_kernel_list 6.9
	fi
	if _use cpu_target_x86_coffee_lake_gen9 ; then
		gen_patched_kernel_list 6.9
	fi
	if _use cpu_target_x86_comet_lake ; then
		gen_patched_kernel_list 6.9
	fi
	if _use cpu_target_x86_amber_lake_gen10 ; then
		gen_patched_kernel_list 6.9
	fi
	if _use cpu_target_x86_ice_lake ; then
		gen_patched_kernel_list 6.9
	fi
	if _use cpu_target_x86_rocket_lake ; then
		gen_patched_kernel_list 6.9
	fi
	if _use cpu_target_x86_tiger_lake ; then
		gen_patched_kernel_list 6.9
	fi
	if _use cpu_target_x86_alder_lake ; then
		gen_patched_kernel_list 6.9
		if _use firmware ; then
			gen_intel_microcode_ge 20220308
		fi
	fi
	if _use cpu_target_x86_raptor_lake_gen13 ; then
		gen_patched_kernel_list 6.9
	fi
	if _use cpu_target_x86_raptor_lake_gen14 ; then
		gen_patched_kernel_list 6.9
	fi
	if _use cpu_target_x86_meteor_lake ; then
		gen_patched_kernel_list 6.9
	fi

	if _use cpu_target_x86_cascade_lake ; then
		gen_patched_kernel_list 6.9
	fi
	if _use cpu_target_x86_cooper_lake ; then
		gen_patched_kernel_list 6.9
	fi
	if _use cpu_target_x86_sapphire_rapids ; then
		gen_patched_kernel_list 6.9
	fi
	if _use cpu_target_x86_sapphire_rapids_edge_enhanced ; then
		gen_patched_kernel_list 6.9
	fi
	if _use cpu_target_x86_granite_rapids ; then
		gen_patched_kernel_list 6.9
	fi
	if _use cpu_target_x86_emerald_rapids ; then
		gen_patched_kernel_list 6.9
	fi
	if _use cpu_target_x86_sierra_forest ; then
		gen_patched_kernel_list 6.9
	fi

	if _use cpu_target_x86_catlow_golden_cove ; then
		gen_patched_kernel_list 6.9
		if _use firmware ; then
			gen_intel_microcode_ge 20220308
		fi
	fi
	if _use cpu_target_x86_catlow_raptor_cove ; then
		gen_patched_kernel_list 6.9
	fi

}
_mitigate_id_bhi_rdepend_x86_32() {
	_mitigate_id_bhi_rdepend_x86_64
}

_mitigate_id_reptar_rdepend_x86_64() {
	if _use cpu_target_x86_ice_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20231114
		fi
	fi
	if _use cpu_target_x86_tiger_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20231114
		fi
	fi
	if _use cpu_target_x86_sapphire_rapids ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20231114
		fi
	fi
	if _use cpu_target_x86_alder_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20231114
		fi
	fi
	if _use cpu_target_x86_catlow_golden_cove ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20231114
		fi
	fi
	if _use cpu_target_x86_rocket_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20231114
		fi
	fi
	if _use cpu_target_x86_raptor_lake_gen13 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20231114
		fi
	fi
	if _use cpu_target_x86_raptor_lake_gen14 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20231114
		fi
	fi
}
_mitigate_id_reptar_rdepend_x86_32() {
	_mitigate_id_reptar_rdepend_x86_64
}

_mitigate_id_ussb_rdepend_arm64() {
	if _use cpu_target_arm_cortex_a76 ; then
		gen_patched_kernel_list 6.11
	fi
	if _use cpu_target_arm_cortex_a77 ; then
		gen_patched_kernel_list 6.11
	fi
	if _use cpu_target_arm_cortex_a78 ; then
		gen_patched_kernel_list 6.11
	fi
	if _use cpu_target_arm_cortex_a78c ; then
		gen_patched_kernel_list 6.11
	fi
	if _use cpu_target_arm_cortex_a710 ; then
		gen_patched_kernel_list 6.11
	fi
	if _use cpu_target_arm_cortex_a720 ; then
		gen_patched_kernel_list 6.11
	fi
	if _use cpu_target_arm_cortex_a725 ; then
		gen_patched_kernel_list 6.11
	fi
	if _use cpu_target_arm_cortex_x1 ; then
		gen_patched_kernel_list 6.11
	fi
	if _use cpu_target_arm_cortex_x1c ; then
		gen_patched_kernel_list 6.11
	fi
	if _use cpu_target_arm_cortex_x2 ; then
		gen_patched_kernel_list 6.11
	fi
	if _use cpu_target_arm_cortex_x3 ; then
		gen_patched_kernel_list 6.11
	fi
	if _use cpu_target_arm_cortex_x4 ; then
		gen_patched_kernel_list 6.11
	fi
	if _use cpu_target_arm_cortex_x925 ; then
		gen_patched_kernel_list 6.11
	fi
	if _use cpu_target_arm_neoverse_n1 ; then
		gen_patched_kernel_list 6.11
	fi
	if _use cpu_target_arm_neoverse_n2 ; then
		gen_patched_kernel_list 6.11
	fi
	if _use cpu_target_arm_neoverse_v1 ; then
		gen_patched_kernel_list 6.11
	fi
	if _use cpu_target_arm_neoverse_v2 ; then
		gen_patched_kernel_list 6.11
	fi
	if _use cpu_target_arm_neoverse_v3 ; then
		gen_patched_kernel_list 6.11
	fi
}

_mitigate_id_ibpb_rdepend_x86_64() {
	if _use cpu_target_x86_sapphire_rapids ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240312
		fi
	fi
	if _use cpu_target_x86_sapphire_rapids_edge_enhanced ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240312
		fi
	fi
	if _use cpu_target_x86_alder_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240312
		fi
	fi
	if _use cpu_target_x86_catlow_golden_cove ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240312
		fi
	fi
	if _use cpu_target_x86_catlow_raptor_cove ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240312
		fi
	fi
	if _use cpu_target_x86_raptor_lake_gen13 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240312
		fi
	fi
	if _use cpu_target_x86_raptor_lake_gen14 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240312
		fi
	fi
}
_mitigate_id_ibpb_rdepend_x86_32() {
	_mitigate_id_ibpb_rdepend_x86_64
}

_mitigate_id_mpf_rdepend_x86_64() {
	if _use cpu_target_x86_snow_ridge ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20220207
		fi
	fi
	if _use cpu_target_x86_parker_ridge ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20220207
		fi
	fi
	if _use cpu_target_x86_elkhart_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20220207
		fi
	fi
	if _use cpu_target_x86_jasper_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20220207
		fi
	fi
}
_mitigate_id_mpf_rdepend_x86_32() {
	_mitigate_id_mpf_rdepend_x86_64
}

_mitigate_id_rsfpcd_rdepend_x86_64() {
	if _use cpu_target_x86_ice_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20220207
		fi
	fi
	if _use cpu_target_x86_tiger_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20220207
		fi
	fi
	if _use cpu_target_x86_rocket_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20220207
		fi
	fi
}
_mitigate_id_rsfpcd_rdepend_x86_32() {
	_mitigate_id_rsfpcd_rdepend_x86_64
}

_mitigate_id_aepic_rdepend_x86_64() {
	if _use cpu_target_x86_ice_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20230214
		fi
	fi
}
_mitigate_id_aepic_rdepend_x86_32() {
	_mitigate_id_aepic_rdepend_x86_64
}

_mitigate_id_tecra_rdepend_x86_64() {
	if _use cpu_target_x86_ice_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240312
		fi
	fi
	if _use cpu_target_x86_sapphire_rapids ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240312
		fi
	fi
	if _use cpu_target_x86_sapphire_rapids_edge_enhanced ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240312
		fi
	fi
}
_mitigate_id_tecra_rdepend_x86_32() {
	_mitigate_id_tecra_rdepend_x86_64
}

_mitigate_id_PLATYPUS_rdepend_x86_64() {
	if _use cpu_target_x86_skylake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20201118
		fi
	fi
	if _use cpu_target_x86_cascade_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20201118
		fi
	fi
	if _use cpu_target_x86_cooper_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20201118
		fi
	fi
	if _use cpu_target_x86_apollo_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20201118
		fi
	fi
	if _use cpu_target_x86_denverton ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20201118
		fi
	fi
	if _use cpu_target_x86_ice_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20201118
		fi
	fi
	if _use cpu_target_x86_gemini_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20201118
		fi
	fi
	if _use cpu_target_x86_snow_ridge_bts ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20201118
		fi
	fi
	if _use cpu_target_x86_snow_ridge ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20201118
		fi
	fi
	if _use cpu_target_x86_parker_ridge ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20201118
		fi
	fi
	if _use cpu_target_x86_tiger_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20201118
		fi
	fi
	if _use cpu_target_x86_amber_lake_gen8 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20201118
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen7 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20201118
		fi
	fi
	if _use cpu_target_x86_whiskey_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20201118
		fi
	fi
	if _use cpu_target_x86_comet_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20201118
		fi
	fi
	if _use cpu_target_x86_amber_lake_gen10 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20201118
		fi
	fi
	if _use cpu_target_x86_alder_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20201118
		fi
	fi
	if _use cpu_target_x86_catlow_golden_cove ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20201118
		fi
	fi
	if _use cpu_target_x86_jasper_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20201118
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen8 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20201118
		fi
	fi
	if _use cpu_target_x86_coffee_lake_gen8 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20201118
		fi
	fi
	if _use cpu_target_x86_coffee_lake_gen9 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20201118
		fi
	fi
}

_mitigate_id_PLATYPUS_rdepend_x86_32() {
	_mitigate_id_PLATYPUS_rdepend_x86_64
}

_mitigate_id_smt_rsb_rdepend_x86_64() {
	if _use cpu_target_x86_zen ; then
		gen_patched_kernel_list 6.2
	fi
	if _use cpu_target_x86_zen_plus ; then
		gen_patched_kernel_list 6.2
	fi
	if _use cpu_target_x86_zen_2 ; then
		gen_patched_kernel_list 6.2
	fi
	if _use cpu_target_x86_dhyana ; then
		gen_patched_kernel_list 6.2
	fi
}
_mitigate_id_smt_rsb_rdepend_x86_32() {
	_mitigate_id_smt_rsb_rdepend_x86_64
}


_mitigate_id_pbrsbp_rdepend_x86_64() {
	if _use cpu_target_x86_cascade_lake ; then
		gen_patched_kernel_list 6.0
	fi
	if _use cpu_target_x86_cooper_lake ; then
		gen_patched_kernel_list 6.0
	fi
	if _use cpu_target_x86_ice_lake ; then
		gen_patched_kernel_list 6.0
	fi
	if _use cpu_target_x86_tiger_lake ; then
		gen_patched_kernel_list 6.0
	fi
	if _use cpu_target_x86_whiskey_lake ; then
		gen_patched_kernel_list 6.0
	fi
	if _use cpu_target_x86_comet_lake ; then
		gen_patched_kernel_list 6.0
	fi
	if _use cpu_target_x86_amber_lake_gen10 ; then
		gen_patched_kernel_list 6.0
	fi
	if _use cpu_target_x86_sapphire_rapids ; then
		gen_patched_kernel_list 6.0
	fi
	if _use cpu_target_x86_sapphire_rapids_edge_enhanced ; then
		gen_patched_kernel_list 6.0
	fi
	if _use cpu_target_x86_alder_lake ; then
		gen_patched_kernel_list 6.0
	fi
	if _use cpu_target_x86_catlow_golden_cove ; then
		gen_patched_kernel_list 6.0
	fi
	if _use cpu_target_x86_coffee_lake_gen9 ; then
		gen_patched_kernel_list 6.0
	fi
	if _use cpu_target_x86_comet_lake ; then
		gen_patched_kernel_list 6.0
	fi
	if _use cpu_target_x86_rocket_lake ; then
		gen_patched_kernel_list 6.0
	fi
	if _use cpu_target_x86_catlow_raptor_cove ; then
		gen_patched_kernel_list 6.0
	fi
	if _use cpu_target_x86_raptor_lake_gen13 ; then
		gen_patched_kernel_list 6.0
	fi
	if _use cpu_target_x86_raptor_lake_gen14 ; then
		gen_patched_kernel_list 6.0
	fi
	if _use cpu_target_x86_emerald_rapids ; then
		gen_patched_kernel_list 6.0
	fi
}
_mitigate_id_pbrsbp_rdepend_x86_32() {
	_mitigate_id_pbrsbp_rdepend_x86_64
}

_mitigate_id_apdb_rdepend_x86_64() {
	if _use cpu_target_x86_apollo_lake ; then
		gen_intel_microcode_ge 20210608
	fi
	if _use cpu_target_x86_denverton ; then
		gen_intel_microcode_ge 20210608
	fi
	if _use cpu_target_x86_gemini_lake ; then
		gen_intel_microcode_ge 20210608
	fi
	if _use cpu_target_x86_snow_ridge_bts ; then
		gen_intel_microcode_ge 20210608
	fi
	if _use cpu_target_x86_elkhart_lake ; then
		gen_intel_microcode_ge 20210608
	fi
	if _use cpu_target_x86_jasper_lake ; then
		gen_intel_microcode_ge 20210608
	fi
}
_mitigate_id_apdb_rdepend_x86_32() {
	_mitigate_id_apdb_rdepend_x86_64
}

_mitigate_id_itdvcp_rdepend_x86_64() {
	if _use cpu_target_x86_skylake ; then
		gen_intel_microcode_ge 20210608
	fi
	if _use cpu_target_x86_ice_lake ; then
		gen_intel_microcode_ge 20210608
	fi
	if _use cpu_target_x86_tiger_lake ; then
		gen_intel_microcode_ge 20210608
	fi
	if _use cpu_target_x86_amber_lake_gen8 ; then
		gen_intel_microcode_ge 20210608
	fi
	if _use cpu_target_x86_kaby_lake_gen7 ; then
		gen_intel_microcode_ge 20210608
	fi
	if _use cpu_target_x86_coffee_lake_gen8 ; then
		gen_intel_microcode_ge 20210608
	fi
	if _use cpu_target_x86_kaby_lake_gen8 ; then
		gen_intel_microcode_ge 20210608
	fi
	if _use cpu_target_x86_comet_lake ; then
		gen_intel_microcode_ge 20210608
	fi
	if _use cpu_target_x86_amber_lake_gen10 ; then
		gen_intel_microcode_ge 20210608
	fi
	if _use cpu_target_x86_coffee_lake_gen9 ; then
		gen_intel_microcode_ge 20210608
	fi
}
_mitigate_id_itdvcp_rdepend_x86_32() {
	_mitigate_id_itdvcp_rdepend_x86_64
}

_mitigate_id_IBRS_GH_rdepend_x86_64() {
	if _use cpu_target_x86_cascade_lake ; then
		gen_intel_microcode_ge 20210608
	fi
	if _use cpu_target_x86_cooper_lake ; then
		gen_intel_microcode_ge 20210608
	fi
	if _use cpu_target_x86_ice_lake ; then
		gen_intel_microcode_ge 20210608
	fi
	if _use cpu_target_x86_whiskey_lake ; then
		gen_intel_microcode_ge 20210608
	fi
	if _use cpu_target_x86_comet_lake ; then
		gen_intel_microcode_ge 20210608
	fi
	if _use cpu_target_x86_amber_lake_gen10 ; then
		gen_intel_microcode_ge 20210608
	fi
	if _use cpu_target_x86_coffee_lake_gen9 ; then
		gen_intel_microcode_ge 20210608
	fi
}
_mitigate_id_IBRS_GH_rdepend_x86_32() {
	_mitigate_id_IBRS_GH_rdepend_x86_64
}

_mitigate_id_cve_2024_23984_rdepend_x86_64() {
	if _use cpu_target_x86_cedar_island ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240910
		fi
	fi
	if _use cpu_target_x86_whitley ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240910
		fi
	fi
	if _use cpu_target_x86_idaville ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240910
		fi
	fi
}
_mitigate_id_cve_2024_23984_rdepend_x86_32() {
	_mitigate_id_cve_2024_23984_rdepend_x86_64
}

_mitigate_id_sinkclose_rdepend_x86_64() {
	if _use cpu_target_x86_naples ; then
		gen_linux_firmware_ge 20240710
	fi
	if _use cpu_target_x86_rome ; then
		gen_linux_firmware_ge 20240710
	fi
	if _use cpu_target_x86_milan ; then
		gen_linux_firmware_ge 20240710
	fi
	if _use cpu_target_x86_milan-x ; then
		gen_linux_firmware_ge 20240710
	fi
	if _use cpu_target_x86_genoa ; then
		gen_linux_firmware_ge 20240710
	fi
	if _use cpu_target_x86_genoa-x ; then
		gen_linux_firmware_ge 20240710
	fi
	if _use cpu_target_x86_bergamo ; then
		gen_linux_firmware_ge 20240710
	fi
	if _use cpu_target_x86_siena ; then
		gen_linux_firmware_ge 20240710
	fi
}
_mitigate_id_sinkclose_rdepend_x86_32() {
	_mitigate_id_sinkclose_rdepend_x86_64
}

_mitigate_id_cve_2024_24853_rdepend_x86_64() {
	if _use cpu_target_x86_purley_refresh ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
	if _use cpu_target_x86_cedar_island ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
	if _use cpu_target_x86_greenlow ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
	if _use cpu_target_x86_whitley ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
	if _use cpu_target_x86_idaville ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
	if _use cpu_target_x86_tatlow ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
	if _use cpu_target_x86_ice_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
	if _use cpu_target_x86_tiger_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
	if _use cpu_target_x86_skylake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen7 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
	if _use cpu_target_x86_kaby_lake_gen8 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
	if _use cpu_target_x86_whiskey_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
	if _use cpu_target_x86_coffee_lake_gen8 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
	if _use cpu_target_x86_coffee_lake_gen9 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
	if _use cpu_target_x86_comet_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
	if _use cpu_target_x86_rocket_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
}
_mitigate_id_cve_2024_24853_rdepend_x86_32() {
	_mitigate_id_cve_2024_24853_rdepend_x86_64
}

_mitigate_id_cve_2024_24980_rdepend_x86_64() {
	if _use cpu_target_x86_cooper_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
	if _use cpu_target_x86_ice_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
	if _use cpu_target_x86_sapphire_rapids ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
	if _use cpu_target_x86_sapphire_rapids_edge_enhanced ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
	if _use cpu_target_x86_emerald_rapids ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
}
_mitigate_id_cve_2024_24980_rdepend_x86_32() {
	_mitigate_id_cve_2024_24980_rdepend_x86_64
}

_mitigate_id_cve_2024_42667_rdepend_x86_64() {
	if _use cpu_target_x86_meteor_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
}
_mitigate_id_cve_2024_42667_rdepend_x86_32() {
	_mitigate_id_cve_2024_42667_rdepend_x86_64
}


_mitigate_id_cve_2023_49141_rdepend_x86_64() {
	if _use cpu_target_x86_eagle_stream ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
	if _use cpu_target_x86_catlow_raptor_cove ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
	if _use cpu_target_x86_alder_lake ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
	if _use cpu_target_x86_raptor_lake_gen13 ; then
		if _use firmware ; then
			gen_intel_microcode_ge 20240813
		fi
	fi
}

_mitigate_id_cve_2023_49141_rdepend_x86_32() {
	_mitigate_id_cve_2023_49141_rdepend_x86_64
}

_mitigate_id_auto() {
	if _use arm ; then
		gen_patched_kernel_list 6.1
	fi
	if _use arm64 ; then
		gen_patched_kernel_list 5.18
	fi
	if _use amd64 ; then
		gen_patched_kernel_list 6.9
	fi
	if _use ppc ; then
		gen_patched_kernel_list 5.0
	fi
	if _use ppc64 ; then
		gen_patched_kernel_list 5.0
	fi
	if _use s390 ; then
		gen_patched_kernel_list 4.15
	fi
	if _use x86 ; then
		gen_patched_kernel_list 6.9
	fi
}
if [[ "${FIRMWARE_VENDOR}" == "amd" ]] ; then
	_mitigate_id_auto() {
		gen_linux_firmware_ge 20240811
	}
fi
if [[ "${FIRMWARE_VENDOR}" == "intel" ]] ; then
	_mitigate_id_auto() {
		gen_intel_microcode_ge 20250812
	}
fi

# @ECLASS_VARIABLE: MITIGATE_ID_RDEPEND
# @INTERNAL
# @DESCRIPTION:
# High level RDEPEND
mitigate_id_rdepend() {
	if _use kernel_linux ; then
		if ! _use custom-kernel ; then
			if _use auto ; then
				_mitigate_id_auto
			fi
			if _use arm ; then
				_mitigate_id_spectre_v2_rdepend_arm
				_mitigate_id_bhb_rdepend_arm
			fi
			if _use arm64 ; then
				_mitigate_id_spectre_v2_rdepend_arm64
				_mitigate_id_meltdown_rdepend_arm64
				_mitigate_id_spectre_ng_rdepend_arm64
				_mitigate_id_bhb_rdepend_arm64
				_mitigate_id_ussb_rdepend_arm64
			fi
			if _use amd64 ; then
				_mitigate_id_spectre_v1_v2_v3_rdepend_x86_64
				_mitigate_id_spectre_v2_rdepend_x86_64
				_mitigate_id_meltdown_rdepend_x86_64
				_mitigate_id_swapgs_rdepend_x86_64
				_mitigate_id_zombieload_v2_rdepend_x86_64
				_mitigate_id_cacheout_rdepend_x86_64
				_mitigate_id_vrsa_rdepend_x86_64
				_mitigate_id_crosstalk_rdepend_x86_64
				_mitigate_id_spectre_ng_rdepend_x86_64
				_mitigate_id_spectre_rsb_rdepend_x86_64
				_mitigate_id_spectre_rsba_rdepend_x86_64
				_mitigate_id_spectre_rrsba_rdepend_x86_64
				_mitigate_id_foreshadow_rdepend_x86_64
				_mitigate_id_bhi_rdepend_x86_64
				_mitigate_id_mmio_rdepend_x86_64
				_mitigate_id_retbleed_rdepend_x86_64
				_mitigate_id_apdb_rdepend_x86_64
				_mitigate_id_itdvcp_rdepend_x86_64
				_mitigate_id_mpf_rdepend_x86_64
				_mitigate_id_rsfpcd_rdepend_x86_64
				_mitigate_id_downfall_rdepend_x86_64
				_mitigate_id_inception_rdepend_x86_64
				_mitigate_id_ibpb_rdepend_x86_64
				_mitigate_id_rfds_rdepend_x86_64
				_mitigate_id_aepic_rdepend_x86_64
				_mitigate_id_smt_rsb_rdepend_x86_64
				_mitigate_id_reptar_rdepend_x86_64
				_mitigate_id_zenbleed_rdepend_x86_64
				_mitigate_id_tecra_rdepend_x86_64
				_mitigate_id_cve_2024_23984_rdepend_x86_64
				_mitigate_id_sinkclose_rdepend_x86_64
				_mitigate_id_cve_2023_49141_rdepend_x86_64
				_mitigate_id_cve_2024_24853_rdepend_x86_64
				_mitigate_id_cve_2024_24980_rdepend_x86_64
				_mitigate_id_cve_2024_42667_rdepend_x86_64
			fi
			if _use ppc ; then
				_mitigate_id_spectre_v2_rdepend_ppc32
				_mitigate_id_spectre_rsb_rdepend_ppc32
			fi
			if _use ppc64 ; then
				_mitigate_id_meltdown_rdepend_ppc64
				_mitigate_id_spectre_v2_rdepend_ppc64
				_mitigate_id_spectre_rsb_rdepend_ppc64
			fi
			if _use s390 ; then
				_mitigate_id_spectre_v2_rdepend_s390x
			fi
			if _use x86 ; then
				_mitigate_id_spectre_v1_v2_v3_rdepend_x86_32
				_mitigate_id_spectre_v2_rdepend_x86_32
				_mitigate_id_meltdown_rdepend_x86_32
				_mitigate_id_swapgs_rdepend_x86_32
				_mitigate_id_zombieload_v2_rdepend_x86_32
				_mitigate_id_cacheout_rdepend_x86_32
				_mitigate_id_vrsa_rdepend_x86_32
				_mitigate_id_crosstalk_rdepend_x86_32
				_mitigate_id_spectre_rsb_rdepend_x86_32
				_mitigate_id_spectre_rsba_rdepend_x86_32
				_mitigate_id_spectre_rrsba_rdepend_x86_32
				_mitigate_id_foreshadow_rdepend_x86_32
				_mitigate_id_spectre_NG_rdepend_x86_32
				_mitigate_id_bhi_rdepend_x86_32
				_mitigate_id_mmio_rdepend_x86_32
				_mitigate_id_apdb_rdepend_x86_32
				_mitigate_id_itdvcp_rdepend_x86_32
				_mitigate_id_mpf_rdepend_x86_32
				_mitigate_id_rsfpcd_rdepend_x86_32
				_mitigate_id_downfall_rdepend_x86_32
				_mitigate_id_inception_rdepend_x86_32
				_mitigate_id_ibpb_rdepend_x86_32
				_mitigate_id_rfds_rdepend_x86_32
				_mitigate_id_aepic_rdepend_x86_32
				_mitigate_id_smt_rsb_rdepend_x86_32
				_mitigate_id_reptar_rdepend_x86_32
				_mitigate_id_zenbleed_rdepend_x86_32
				_mitigate_id_tecra_rdepend_x86_32
				_mitigate_id_cve_2024_23984_rdepend_x86_32
				_mitigate_id_sinkclose_rdepend_x86_32
				_mitigate_id_cve_2023_49141_rdepend_x86_32
				_mitigate_id_cve_2024_24853_rdepend_x86_32
				_mitigate_id_cve_2024_24980_rdepend_x86_32
				_mitigate_id_cve_2024_42667_rdepend_x86_32
			fi
		fi
	fi
}

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

# @FUNCTION: _mitigate_id_verify_mitigation_meltdown
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags to mitigate against Meltdown.
_mitigate_id_verify_mitigation_meltdown() {
	local pae=0
	if tc-is-cross-compiler ; then
		:
	elif cat "/proc/cpuinfo" | grep -q  "flags.* pae " ; then
		pae=1
	fi

	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "6.9" ; then
		if [[ "${ARCH}" == "amd64" ]] || [[ "${ARCH}" == "x86" && "${pae}" == "1" ]] ; then
			CONFIG_CHECK="
				MITIGATION_PAGE_TABLE_ISOLATION
			"
			ERROR_MITIGATION_PAGE_TABLE_ISOLATION="CONFIG_MITIGATION_PAGE_TABLE_ISOLATION=y is required for Meltdown mitigation."
			check_extra_config
		fi

		if [[ "${ARCH}" == "x86" && "${pae}" != "1" ]] ; then
eerror "No mitigation against Meltdown for 32-bit x86 without PAE.  Upgrade to 64-bit instead."
		fi
	elif ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "4.15" ; then
		if [[ "${ARCH}" == "amd64" ]] || [[ "${ARCH}" == "x86" && "${pae}" == "1" ]] ; then
			CONFIG_CHECK="
				PAGE_TABLE_ISOLATION
			"
			ERROR_PAGE_TABLE_ISOLATION="CONFIG_PAGE_TABLE_ISOLATION=y is required for Meltdown mitigation."
			check_extra_config
		fi

		if [[ "${ARCH}" == "x86" && "${pae}" != "1" ]] ; then
eerror "No mitigation against Meltdown for 32-bit x86 without PAE.  Upgrade to 64-bit instead."
		fi
	fi


	if [[ "${ARCH}" == "arm64" ]] && ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "4.16" ; then
		local needs_kpti=0
		use cpu_target_arm_cortex_a75 && needs_kpti=1
		# use cpu_target_arm_cortex_a15 && needs_kpti=1
		use auto && needs_kpti=1

		if (( ${needs_kpti} == 1 )) ; then
			CONFIG_CHECK="
				UNMAP_KERNEL_AT_EL0
			"
			ERROR_UNMAP_KERNEL_AT_EL0="CONFIG_UNMAP_KERNEL_AT_EL0=y (KPTI) is required for Meltdown mitigation."
			check_extra_config
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

# @FUNCTION: _mitigate_id_verify_mitigation_spectre
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against Spectre.
_mitigate_id_verify_mitigation_spectre() {
	if use firmware ; then
		if \
			   use cpu_target_x86_apollo_lake \
			|| use cpu_target_x86_denverton \
			|| use cpu_target_x86_gemini_lake \
			|| use cpu_target_x86_sandy_bridge \
			|| use cpu_target_x86_ivy_bridge \
			|| use cpu_target_x86_haswell \
			|| use cpu_target_x86_broadwell \
			|| use cpu_target_x86_hewitt_lake \
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
		if _check_kernel_cmdline "spectre_v2=off" ; then
eerror
eerror "Detected spectre_v2=off in the kernel command line."
eerror
eerror "Acceptable values:"
eerror
eerror "  spectre_v2=on"
eerror "  spectre_v2=auto"
eerror "  spectre_v2=retpoline"
eerror "  spectre_v2=retpoline,generic"
			if [[ "${FIRMWARE_VENDOR}" == "amd" ]] ; then
eerror "  spectre_v2=retpoline,amd"
			fi
			if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "5.17" ; then
				if [[ "${FIRMWARE_VENDOR}" != "amd" ]] ; then
eerror "  spectre_v2=retpoline,lfence"
				fi
				if tc-is-cross-compiler ; then
					:
				elif cat "/proc/cpuinfo" | grep -q  "flags.* ibrs_enhanced " ; then
eerror "  spectre_v2=eibrs"
eerror "  spectre_v2=eibrs,retpoline"
					if [[ "${FIRMWARE_VENDOR}" != "amd" ]] ; then
eerror "  spectre_v2=eibrs,lfence"
					fi
				fi
			fi
			if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "5.19" ; then
				if tc-is-cross-compiler ; then
					:
				elif cat "/proc/cpuinfo" | grep -q  "flags.* ibrs " ; then
eerror "  spectre_v2=ibrs"
				fi
			fi
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
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "5.13" ; then
	# See https://lwn.net/Articles/946389/
	# The current decision is based on the rate of exfiltration (data per second) and attacker control.
	# Compromised ASLR would exfiltrate more data than a Spectre 2 attack.
		if false ; then # && linux_chkconfig_present "BPF"
	# Dead code but left as a historical note based on link above.
			CONFIG_CHECK="
				!BPF_JIT
				!BPF_JIT_ALWAYS_ON
			"
			ERROR_BPF_JIT="CONFIG_BPF_JIT=y is required for Spectre (Variant 2) mitigation."
			ERROR_BPF_JIT_ALWAYS_ON="CONFIG_BPF_JIT_ALWAYS_ON=y is required for Spectre (Variant 2) mitigation."
			check_extra_config
		elif linux_chkconfig_present "BPF" ; then
			CONFIG_CHECK="
				!BPF_JIT
				!BPF_JIT_ALWAYS_ON
			"
	# For example, a user forgets to disable BPF JIT after use.
			ERROR_BPF_JIT="CONFIG_BPF_JIT unset is required for JIT spray (circumvented ASLR) mitigation."
			ERROR_BPF_JIT_ALWAYS_ON="CONFIG_BPF_JIT_ALWAYS_ON unset is required for JIT spray (circumvented ASLR) mitigation."
			check_extra_config
		fi
	fi
	if [[ "${ARCH}" == "arm" ]] && ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "4.18" ; then
		if \
			   use cpu_target_arm_cortex_a8 \
			|| use cpu_target_arm_cortex_a9 \
			|| use cpu_target_arm_cortex_a12 \
			|| use cpu_target_arm_cortex_a15 \
			|| use cpu_target_arm_cortex_a17 \
			|| use cpu_target_arm_cortex_a73 \
			|| use cpu_target_arm_cortex_a75 \
			|| use cpu_target_arm_brahma_b15 \
			|| use auto \
		; then
			CONFIG_CHECK="
				HARDEN_BRANCH_PREDICTOR
			"
			ERROR_HARDEN_BRANCH_PREDICTOR="CONFIG_HARDEN_BRANCH_PREDICTOR=y is required for Spectre (Variant 2) mitigation."
			check_extra_config
		fi
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_spectre_ng
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against Spectre-NG.
_mitigate_id_verify_mitigation_spectre_ng() {
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
			if ! has_version ">=sys-firmware/intel-microcode-20180807" ; then
# Needed for custom-kernel USE flag due to RDEPEND being bypassed.
eerror ">=sys-firmware/intel-microcode-20180807 is required for Spectre-NG mitigation."
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
	# SSB (Spectre-NG Variant 4)
	# SSB (CVE-2018-3639) not the same as SCSB (CVE-2021-0089)
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
	if use cpu_target_arm_cortex_a76 ; then
ewarn "Cortex A76 requires a firmware update for Spectre-NG (Variant 4) mitigation."
	fi
	if use cpu_target_arm_neoverse_n1 ; then
ewarn "Neoverse N1 requires a firmware update for Spectre-NG (Variant 4) mitigation."
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_spectre_bhb
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against Spectre-BHB.
_mitigate_id_verify_mitigation_spectre_bhb() {
	if [[ "${ARCH}" == "arm" ]] && ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "5.17" ; then
		if \
			   use cpu_target_arm_brahma_b15 \
			|| use cpu_target_arm_cortex_a15 \
			|| use cpu_target_arm_cortex_a57 \
			|| use cpu_target_arm_cortex_a72 \
			|| use cpu_target_arm_cortex_a73 \
			|| use cpu_target_arm_cortex_a75 \
			|| use auto \
		; then
			CONFIG_CHECK="
				HARDEN_BRANCH_HISTORY
			"
			ERROR_HARDEN_BRANCH_HISTORY="CONFIG_HARDEN_BRANCH_HISTORY=y is required for Spectre BHB mitigation."
			check_extra_config
		fi
	fi
	if [[ "${ARCH}" == "arm64" ]] && ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "5.17" ; then
		CONFIG_CHECK="
			MITIGATE_SPECTRE_BRANCH_HISTORY
		"
		ERROR_MITIGATE_SPECTRE_BRANCH_HISTORY="CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY=y is required for Spectre BHB mitigation."
		check_extra_config
	fi
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

# @FUNCTION: _mitigate_id_verify_mitigation_bhi
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against Spectre-BHI.
_mitigate_id_verify_mitigation_bhi() {
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

# @FUNCTION: _mitigate_id_verify_mitigation_foreshadow
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against Foreshadow.
_mitigate_id_verify_mitigation_foreshadow() {
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "4.19" ; then
		if use firmware ; then
			if \
				   use cpu_target_x86_arrandale \
				|| use cpu_target_x86_clarkdale \
				|| use cpu_target_x86_gladden \
				|| use cpu_target_x86_lynnfield \
				|| use cpu_target_x86_bakerville \
				|| use cpu_target_x86_nehalem \
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
		if [[ "${ARCH}" == "x86" ]] ; then
			local levels=$(linux_chkconfig_string "PGTABLE_LEVELS")
			local pae=0
			if tc-is-cross-compiler ; then
				:
			elif cat "/proc/cpuinfo" | grep -q  "flags.* pae " ; then
				pae=1
			fi

			if [[ "${levels}" == "2" ]] && (( ${pae} == 1 )) ; then
eerror
eerror "Detected PGTABLE_LEVELS=2 with PAE support on CPU."
eerror "To continue, set to one of the following for Foreshadow mitigation:"
eerror
eerror "  CONFIG_PGTABLE_LEVELS=3 with CONFIG_X86_PAE=y"
eerror
				die
			else
ewarn
ewarn "Foreshadow mitigation was not applied for ARCH=${ARCH}.  This could mean"
ewarn "that your hardware was too old."
ewarn
			fi
		fi
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_rfds
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against RFDS.
_mitigate_id_verify_mitigation_rfds() {
	if \
		use cpu_target_x86_snow_ridge_bts \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
		eerror "No planned mitigation for RFDS for Snow Ridge BTS."
	fi
	if \
		use cpu_target_x86_gemini_lake \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
		ewarn "Gemini Lake requires a BIOS firmware update for RFDS mitigation."
	fi
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "6.9" ; then
		if \
			use firmware \
				&& \
			( \
				   use cpu_target_x86_apollo_lake \
				|| use cpu_target_x86_denverton \
				|| use cpu_target_x86_snow_ridge \
				|| use cpu_target_x86_parker_ridge \
				|| use cpu_target_x86_elkhart_lake \
				|| use cpu_target_x86_arizona_beach \
				|| use cpu_target_x86_jasper_lake \
				|| use cpu_target_x86_alder_lake \
				|| use cpu_target_x86_catlow_golden_cove \
				|| use cpu_target_x86_alder_lake_n \
				|| use cpu_target_x86_raptor_lake_gen13 \
				|| use cpu_target_x86_raptor_lake_gen14 \
				|| use cpu_target_x86_emerald_rapids \
				|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
			) \
		; then
			CONFIG_CHECK="
				CPU_SUP_INTEL
			"
			ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for RFDS mitigation."
			check_extra_config
			if ! has_version ">=sys-firmware/intel-microcode-20240312" ; then
# Needed for custom-kernel USE flag due to RDEPEND being bypassed.
eerror ">=sys-firmware/intel-microcode-20240312 is required for RFDS mitigation."
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
			|| use cpu_target_x86_alder_lake \
			|| use cpu_target_x86_catlow_golden_cove \
			|| use cpu_target_x86_alder_lake_n \
			|| use cpu_target_x86_raptor_lake_gen13 \
			|| use cpu_target_x86_raptor_lake_gen14 \
			|| use cpu_target_x86_emerald_rapids \
			|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
		; then
			CONFIG_CHECK="
				MITIGATION_RFDS
			"
			ERROR_MITIGATION_RFDS="CONFIG_MITIGATION_RFDS or >=sys-firmware/intel-microcode-20240312 is required for RFDS mitigation."
			check_extra_config
		fi
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_downfall
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against GDS.
_mitigate_id_verify_mitigation_downfall() {
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
			cpu_target_x86_rocket_lake
			cpu_target_x86_tiger_lake
			cpu_target_x86_cascade_lake
			cpu_target_x86_cooper_lake
		)
		local x
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

# @FUNCTION: _mitigate_id_verify_mitigation_retbleed
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against Retbleed.
_mitigate_id_verify_mitigation_retbleed() {
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
	if tc-is-cross-compiler ; then
		:
	elif cat "/proc/cpuinfo" | grep -q  "flags.* ibpb " ; then
eerror "  retbleed=ibpb"
	fi
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

# @FUNCTION: _mitigate_id_verify_mitigation_zenbleed
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against Zenbleed.
_mitigate_id_verify_mitigation_zenbleed() {
	if \
		use firmware \
			&& \
		( \
			   use cpu_target_x86_rome \
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
ewarn "A BIOS firmware update is required for non datacenter CPU models for Zenbleed mitigation."
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_crosstalk
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CROSSTalk.
_mitigate_id_verify_mitigation_crosstalk() {
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "5.8" ; then
		if use firmware ; then
			if \
				   use cpu_target_x86_skylake \
				|| use cpu_target_x86_kaby_lake_gen7 \
				|| use cpu_target_x86_amber_lake_gen8 \
				|| use cpu_target_x86_coffee_lake_gen8 \
				|| use cpu_target_x86_kaby_lake_gen8 \
				|| use cpu_target_x86_whiskey_lake \
				|| use cpu_target_x86_comet_lake \
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

# @FUNCTION: _mitigate_id_verify_mitigation_inception
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against Inception.
_mitigate_id_verify_mitigation_inception() {
	local ver
	if \
		use firmware\
			&& \
		( \
			   use cpu_target_x86_milan \
			|| use cpu_target_x86_milan-x \
			|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "amd" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
		) \
	; then
		CONFIG_CHECK="
			CPU_SUP_AMD
		"
		ERROR_CPU_SUP_AMD="CONFIG_CPU_SUP_AMD is required for INCEPTION mitigation."
		check_extra_config
		if ! has_version ">=sys-kernel/linux-firmware-20230724" ; then
# Needed for custom-kernel USE flag due to RDEPEND being bypassed.
eerror ">=sys-kernel/linux-firmware-20230724 is required for INCEPTION mitigation."
			die
		fi
	fi
	if \
		use firmware\
			&& \
		( \
			   use cpu_target_x86_genoa \
			|| use cpu_target_x86_genoa-x \
			|| use cpu_target_x86_bergamo \
			|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "amd" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
		) \
	; then
		CONFIG_CHECK="
			CPU_SUP_AMD
		"
		ERROR_CPU_SUP_AMD="CONFIG_CPU_SUP_AMD is required for INCEPTION mitigation."
		check_extra_config
		if ! has_version ">=sys-kernel/linux-firmware-20230809" ; then
# Needed for custom-kernel USE flag due to RDEPEND being bypassed.
eerror ">=sys-kernel/linux-firmware-20230809 is required for INCEPTION mitigation."
			die
		fi
	fi

	if \
		   use cpu_target_x86_milan \
		|| use cpu_target_x86_milan-x \
		|| use cpu_target_x86_genoa \
		|| use cpu_target_x86_genoa-x \
		|| use cpu_target_x86_bergamo \
		|| use cpu_target_x86_zen_3 \
		|| use cpu_target_x86_zen_4 \
	; then
		ver="6.9"
	elif \
		   use cpu_target_x86_zen \
		|| use cpu_target_x86_zen_2 \
	; then
		ver="6.5"
	elif [[ "${FIRMWARE_VENDOR}" == "amd" && "${ARCH}" =~ ("amd64"|"x86") ]] ; then
		ver="6.9"
	else
		return
	fi
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "${ver}" ; then
		CONFIG_CHECK="
			MITIGATION_SRSO
		"
		ERROR_CPU_SRSO="CONFIG_CPU_SRSO is required for INCEPTION mitigation for datacenters."
		check_extra_config
	elif ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "${ver}" ; then
		CONFIG_CHECK="
			CPU_SRSO
		"
		ERROR_CPU_SRSO="CONFIG_CPU_SRSO is required for INCEPTION mitigation for datacenters."
		check_extra_config
	fi
	if [[ "${FIRMWARE_VENDOR}" == "amd" ]] ; then
ewarn "A BIOS firmware update is required for non datacenters for INCEPTION mitigation."
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_zombieload_v2
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against ZombieLoad v2.
_mitigate_id_verify_mitigation_zombieload_v2() {
	if use firmware ; then
		if \
			   use cpu_target_x86_skylake \
			|| use cpu_target_x86_kaby_lake_gen7 \
			|| use cpu_target_x86_amber_lake_gen8 \
			|| use cpu_target_x86_coffee_lake_gen8 \
			|| use cpu_target_x86_kaby_lake_gen8 \
			|| use cpu_target_x86_whiskey_lake \
			|| use cpu_target_x86_coffee_lake_gen9 \
			|| use cpu_target_x86_comet_lake \
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
	if use cpu_target_x86_hewitt_lake ; then
ewarn "Missing firmware for Gen5 TAA mitigations"
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_cacheout
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CacheOut (L1DES) and VRS.
_mitigate_id_verify_mitigation_cacheout() {
	if \
		   use cpu_target_x86_skylake \
		|| use cpu_target_x86_kaby_lake_gen7 \
		|| use cpu_target_x86_amber_lake_gen8 \
		|| use cpu_target_x86_coffee_lake_gen8 \
		|| use cpu_target_x86_kaby_lake_gen8 \
		|| use cpu_target_x86_whiskey_lake \
		|| use cpu_target_x86_coffee_lake_gen9 \
		|| use cpu_target_x86_comet_lake \
		|| use cpu_target_x86_amber_lake_gen10 \
		|| use cpu_target_x86_cascade_lake \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
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

# @FUNCTION: _mitigate_id_verify_mitigation_vrsa
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against VRSA.
_mitigate_id_verify_mitigation_vrsa() {
	if \
		   use cpu_target_x86_skylake \
		|| use cpu_target_x86_kaby_lake_gen7 \
		|| use cpu_target_x86_amber_lake_gen8 \
		|| use cpu_target_x86_coffee_lake_gen8 \
		|| use cpu_target_x86_kaby_lake_gen8 \
		|| use cpu_target_x86_whiskey_lake \
		|| use cpu_target_x86_coffee_lake_gen9 \
		|| use cpu_target_x86_comet_lake \
		|| use cpu_target_x86_amber_lake_gen10 \
		|| use cpu_target_x86_cascade_lake \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
	# Microcode mitigation only
		CONFIG_CHECK="
			CPU_SUP_INTEL
		"
		ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for VRSA mitigation."
		check_extra_config
		if ! has_version ">=sys-firmware/intel-microcode-20210125" ; then
# Needed for custom-kernel USE flag due to RDEPEND being bypassed.
eerror ">=sys-firmware/intel-microcode-20210125 is required for CacheOut and VRS mitigation."
			die
		fi
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_spectre_rsb
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against SpectreRSB.
_mitigate_id_verify_mitigation_spectre_rsb() {
	:
}

# @FUNCTION: _mitigate_id_verify_mitigation_mds
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against MDS.
# The MDSUM column was not processed and missing.
_mitigate_id_verify_mitigation_mds() {
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

# @FUNCTION: _mitigate_id_verify_mitigation_mmio_stale_data
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against MMIO Stale Data.
_mitigate_id_verify_mitigation_mmio_stale_data() {
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
				|| use cpu_target_x86_hewitt_lake \
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
				|| use cpu_target_x86_rocket_lake \
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

# @FUNCTION: _mitigate_id_verify_mitigation_reptar
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against Reptar.
_mitigate_id_verify_mitigation_reptar() {
	if use firmware ; then
		if \
			   use cpu_target_x86_ice_lake \
			|| use cpu_target_x86_tiger_lake \
			|| use cpu_target_x86_sapphire_rapids \
			|| use cpu_target_x86_alder_lake \
			|| use cpu_target_x86_catlow_golden_cove \
			|| use cpu_target_x86_rocket_lake \
			|| use cpu_target_x86_raptor_lake_gen13 \
			|| use cpu_target_x86_raptor_lake_gen14 \
			|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
		; then
			CONFIG_CHECK="
				CPU_SUP_INTEL
			"
			ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for Reptar mitigation."
			check_extra_config
			if ! has_version ">=sys-firmware/intel-microcode-20231114" ; then
# Needed for custom-kernel USE flag due to RDEPEND being bypassed.
eerror ">=sys-firmware/intel-microcode-20231114 is required for Reptar mitigation."
				die
			fi
		fi
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_ussb
# @INTERNAL
# @DESCRIPTION:
# See commit adeec61
# Check the kernel config flags and kernel command line to mitigate against Unexpected Speculative Store Bypass (USSB).
_mitigate_id_verify_mitigation_ussb() {
	if [[ "${ARCH}" == "amd64" ]] && ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "6.11" ; then
		if \
			   use cpu_target_arm_cortex_a76 \
			|| use cpu_target_arm_cortex_a77 \
			|| use cpu_target_arm_cortex_a78 \
			|| use cpu_target_arm_cortex_a78c \
			|| use cpu_target_arm_cortex_a710 \
			|| use cpu_target_arm_cortex_a720 \
			|| use cpu_target_arm_cortex_a725 \
			|| use cpu_target_arm_cortex_x1 \
			|| use cpu_target_arm_cortex_x1c \
			|| use cpu_target_arm_cortex_x2 \
			|| use cpu_target_arm_cortex_x3 \
			|| use cpu_target_arm_cortex_x4 \
			|| use cpu_target_arm_cortex_x925 \
			|| use cpu_target_arm_neoverse_n1 \
			|| use cpu_target_arm_neoverse_n2 \
			|| use cpu_target_arm_neoverse_v1 \
			|| use cpu_target_arm_neoverse_v2 \
			|| use cpu_target_arm_neoverse_v3 \
			|| use auto \
		; then
			CONFIG_CHECK="
				ARM64_ERRATUM_3194386
			"
			ERROR_ARM64_ERRATUM_3194386="CONFIG_ARM64_ERRATUM_3194386 is required for Unexpected Speculative Store Bypass mitigation."
			check_extra_config
		fi
	fi
}

# @FUNCTION: _mitigate_id_mitigate_with_ssp
# @INTERNAL
# @DESCRIPTION:
# Check for SSP to prevent pre attack for privilege escalation which can lead to data theft.
_mitigate_id_mitigate_with_ssp() {
	CONFIG_CHECK="
		STACKPROTECTOR
	"
	ERROR_STACKPROTECTOR="CONFIG_STACKPROTECTOR is required for SSP to mitigate against privilege escalation which could lead to data theft."
	check_extra_config
}

# @FUNCTION: _mitigate_id_mitigate_with_aslr
# @INTERNAL
# @DESCRIPTION:
# Check for ASLR to prevent pre attack for privilege escalation which can lead to data theft.
_mitigate_id_mitigate_with_aslr() {
	if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" ]] ; then
		CONFIG_CHECK="
			RELOCATABLE
			RANDOMIZE_BASE
		"
		if [[ "${ARCH}" == "amd64" ]] ; then
			CONFIG_CHECK+="
				RANDOMIZE_MEMORY
			"
		fi
		ERROR_RELOCATABLE="CONFIG_RELOCATABLE is required for KASLR to mitigate against privilege escalation which could lead to data theft."
		ERROR_RANDOMIZE_BASE="CONFIG_RANDOMIZE_BASE is required for KASLR to mitigate against privilege escalation which could lead to data theft."
		ERROR_RANDOMIZE_MEMORY="CONFIG_RANDOMIZE_MEMORY is required to mitigate against privilege escalation which could lead to data theft."
		check_extra_config
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_ibpb
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2023-38575, also known as the Incomplete Branch Prediction Barrier (IBPB) vulnerability.
_mitigate_id_verify_mitigation_ibpb() {
	if \
		   use cpu_target_x86_sapphire_rapids \
		|| use cpu_target_x86_sapphire_rapids_edge_enhanced \
		|| use cpu_target_x86_alder_lake \
		|| use cpu_target_x86_catlow_golden_cove \
		|| use cpu_target_x86_catlow_raptor_cove \
		|| use cpu_target_x86_raptor_lake_gen13 \
		|| use cpu_target_x86_raptor_lake_gen14 \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
	# Needs microcode mitigation
		CONFIG_CHECK="
			CPU_SUP_INTEL
		"
		ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for mitigation against CVE-2023-38575, also known as the Incomplete Branch Prediction Barrier (IBPB) vulnerability."
		check_extra_config
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_mpf
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2021-33120, also known as the Missing Page Fault (MPF) vulnerability.
_mitigate_id_verify_mitigation_mpf() {
	if \
		   use cpu_target_x86_snow_ridge \
		|| use cpu_target_x86_parker_ridge \
		|| use cpu_target_x86_elkhart_lake \
		|| use cpu_target_x86_jasper_lake \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
	# Needs microcode mitigation
		CONFIG_CHECK="
			CPU_SUP_INTEL
		"
		ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for mitigation against CVE-2021-33120, also know as the Missing Page Fault (MPF) vulnerability."
		check_extra_config
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_fsfpcd
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2021-0145, also known as the Fast Store Forwarding Predictor: Cross Domain (FSFPCD) vulnerability.
_mitigate_id_verify_mitigation_fsfpcd() {
	if \
		   use cpu_target_x86_ice_lake \
		|| use cpu_target_x86_tiger_lake \
		|| use cpu_target_x86_rocket_lake \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
	# Needs microcode mitigation
		CONFIG_CHECK="
			CPU_SUP_INTEL
		"
		ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for mitigation against CVE-2021-0145, also known as the Fast Store Forwarding Predictor: Cross Domain (FSFPCD) vulnerability."
		check_extra_config
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_aepic
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2022-21233, also known as the AEPIC Leak vulnerability.
_mitigate_id_verify_mitigation_aepic() {
	if \
		   use cpu_target_x86_ice_lake \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
	# Needs microcode mitigation
		CONFIG_CHECK="
			CPU_SUP_INTEL
		"
		ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for mitigation against CVE-2022-21233, also known as the AEPIC Leak vulnerability."
		check_extra_config
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_tecra
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2023-22655, also known as the Trusted Execution Register Access (TECRA) vulnerability.
_mitigate_id_verify_mitigation_tecra() {
	if \
		   use cpu_target_x86_ice_lake \
		|| use cpu_target_x86_sapphire_rapids \
		|| use cpu_target_x86_sapphire_rapids_edge_enhanced \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
	# Needs microcode mitigation
		CONFIG_CHECK="
			CPU_SUP_INTEL
		"
		ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for mitigation against CVE-2023-22655, also known as the Trusted Execution Register Access (TECRA) vulnerability, may lead to privilege escalation."
		check_extra_config
	fi
	if \
		use cpu_target_x86_ice_lake \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
		ewarn "Ice Lake still needs a BIOS firmware update for Trusted Execution Register Access (TECRA) mitigation."
	fi
	if \
		use cpu_target_x86_sapphire_rapids \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
		ewarn "Sapphire Rapids still needs a BIOS firmware update for Trusted Execution Register Access (TECRA) mitigation."
	fi
	if \
		use cpu_target_x86_sapphire_rapids_edge_enhanced \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
		ewarn "Sapphire Rapids Edge Enhanced still needs a BIOS firmware update for Trusted Execution Register Access (TECRA) mitigation."
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_platypus
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2020-8694 and CVE-2020-8695, also known as the PLATYPUS side-channel attack.
_mitigate_id_verify_mitigation_platypus() {
	if \
		use cpu_target_x86_haswell \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
		eerror "No mitigation against PLATYPUS attack for Haswell."
	fi
	if \
		use cpu_target_x86_broadwell \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
		eerror "No mitigation against PLATYPUS attack for Broadwell."
	fi
	if [[ "${ARCH}" =~ ("amd64"|"x86") ]] ; then
		if \
			use firmware \
				&& \
			( \
				   use cpu_target_x86_skylake \
				|| use cpu_target_x86_cascade_lake \
				|| use cpu_target_x86_cooper_lake \
				|| use cpu_target_x86_apollo_lake \
				|| use cpu_target_x86_denverton \
				|| use cpu_target_x86_ice_lake \
				|| use cpu_target_x86_gemini_lake \
				|| use cpu_target_x86_snow_ridge_bts \
				|| use cpu_target_x86_snow_ridge \
				|| use cpu_target_x86_parker_ridge \
				|| use cpu_target_x86_tiger_lake \
				|| use cpu_target_x86_amber_lake_gen8 \
				|| use cpu_target_x86_kaby_lake_gen7 \
				|| use cpu_target_x86_whiskey_lake \
				|| use cpu_target_x86_comet_lake \
				|| use cpu_target_x86_amber_lake_gen10 \
				|| use cpu_target_x86_alder_lake \
				|| use cpu_target_x86_catlow_golden_cove \
				|| use cpu_target_x86_jasper_lake \
				|| use cpu_target_x86_kaby_lake_gen8 \
				|| use cpu_target_x86_coffee_lake_gen8 \
				|| use cpu_target_x86_coffee_lake_gen9 \
				|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
			) \
		; then
			CONFIG_CHECK="
				CPU_SUP_INTEL
			"
			ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for mitigation against CVE-2020-8694 and CVE-2020-8695, also known as the PLATYPUS attack."
			check_extra_config
		fi
	fi
	# To mitigate, either (1) CONFIG_INTEL_RAPL=n or (2) update the kernel to 5.10 and only allow root to use this feature.
	if [[ "${ARCH}" =~ ("amd64"|"x86") ]] ; then
		if \
			   use cpu_target_x86_haswell \
			|| use cpu_target_x86_broadwell \
			|| use cpu_target_x86_skylake \
			|| use cpu_target_x86_cascade_lake \
			|| use cpu_target_x86_cooper_lake \
			|| use cpu_target_x86_apollo_lake \
			|| use cpu_target_x86_denverton \
			|| use cpu_target_x86_ice_lake \
			|| use cpu_target_x86_gemini_lake \
			|| use cpu_target_x86_snow_ridge_bts \
			|| use cpu_target_x86_snow_ridge \
			|| use cpu_target_x86_parker_ridge \
			|| use cpu_target_x86_tiger_lake \
			|| use cpu_target_x86_amber_lake_gen8 \
			|| use cpu_target_x86_kaby_lake_gen7 \
			|| use cpu_target_x86_whiskey_lake \
			|| use cpu_target_x86_comet_lake \
			|| use cpu_target_x86_amber_lake_gen10 \
			|| use cpu_target_x86_alder_lake \
			|| use cpu_target_x86_catlow_golden_cove \
			|| use cpu_target_x86_jasper_lake \
			|| use cpu_target_x86_kaby_lake_gen8 \
			|| use cpu_target_x86_coffee_lake_gen8 \
			|| use cpu_target_x86_coffee_lake_gen9 \
			|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
		; then
			if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "5.10" ; then
				:
			else
# Needed for custom-kernel USE flag due to RDEPEND being bypassed.
				if [[ -L "${KERNEL_DIR}" ]] ; then
eerror "You need to switch the /usr/src/linux symlink to Linux Kernel >= ${auto_version} for USE=auto."
				else
eerror "You need to replace the kernel sources to Linux Kernel >= ${auto_version} for USE=auto."
				fi
				die
			fi
		fi
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_smt_rsb
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against Cross-Thread Return Address Predictions (CTRAP), also known as SMT RSB in the Linux Kernel.
_mitigate_id_verify_mitigation_smt_rsb() {
	if [[ "${ARCH}" =~ ("amd64"|"x86") ]] ; then
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
		if _check_kernel_cmdline "spectre_v2=off" ; then
# There are 2 parts to this mitigation.
# Required:
# https://github.com/torvalds/linux/blob/v6.11/Documentation/admin-guide/hw-vuln/cross-thread-rsb.rst#mitigation-mechanism
eerror
eerror "Detected mitigations=off in the kernel command line."
eerror
eerror "Acceptable values:"
eerror
eerror "  spectre_v2=on"
eerror "  spectre_v2=off"
eerror "  spectre_v2=auto               # The kernel default"
eerror "  spectre_v2=retpoline"
eerror "  spectre_v2=retpoline,generic"
			if [[ "${FIRMWARE_VENDOR}" != "amd" ]] ; then
eerror "  spectre_v2=retpoline,lfence"
			fi
			if [[ "${FIRMWARE_VENDOR}" == "amd" ]] ; then
eerror "  spectre_v2=retpoline,amd"
			fi
			if tc-is-cross-compiler ; then
				:
			elif cat "/proc/cpuinfo" | grep -q  "flags.* ibrs_enhanced " ; then
eerror "  spectre_v2=eibrs"
eerror "  spectre_v2=eibrs,retpoline"
				if [[ "${FIRMWARE_VENDOR}" != "amd" ]] ; then
eerror "  spectre_v2=eibrs,lfence"
				fi
			fi
			if tc-is-cross-compiler ; then
				:
			elif cat "/proc/cpuinfo" | grep -q  "flags.* ibrs " ; then
eerror "  spectre_v2=ibrs"
			fi
eerror "  "
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
			die
		fi
einfo
einfo "Part II of the SMT RSB mitigation:"
einfo "https://github.com/torvalds/linux/blob/v6.11/Documentation/admin-guide/hw-vuln/cross-thread-rsb.rst#mitigation-control-for-kvm---module-parameter"
einfo
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_pbrsbp
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against Post-Barrier Return Stack Buffer Predictions (PBRSBP) vulnerability.
_mitigate_id_verify_mitigation_pbrsbp() {
	:
}

# @FUNCTION: _mitigate_id_verify_mitigation_rsba
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against RSBA.
RSBU_MITIGATED=0
_mitigate_id_verify_mitigation_rsba() {
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "6.2" ; then
		if use cpu_target_x86_skylake ; then
			if _check_kernel_cmdline "spectre_v2=ibrs" ; then
				RSBU_MITIGATED=1
			elif _check_kernel_cmdline "spectre_v2=auto" ; then
				RSBU_MITIGATED=1
			elif _check_kernel_cmdline "spectre_v2=on" ; then
				RSBU_MITIGATED=1
			else
				CONFIG_CHECK="
					CALL_DEPTH_TRACKING
				"
				ERROR_CALL_DEPTH_TRACKING="CONFIG_CALL_DEPTH_TRACKING is required for retbleed=stuff to proper RSB underflow mitigation."
				check_extra_config

				if ! _check_kernel_cmdline "retbleed=off" ; then
	# See commit d82a034
eerror
eerror "Missing retbleed=stuffing in the kernel command line."
eerror
eerror "Edit it from:"
eerror
eerror "  /etc/default/grub"
eerror "  /etc/grub.d/40_custom"
eerror "  CONFIG_CMDLINE"
eerror
					die
				fi
				if ! _check_kernel_cmdline "spectre_v2=retpoline" ; then
eerror "Missing spectre_v2=retpoline required by retbleed=stuff."
					die
				fi
				RSBU_MITIGATED=1
			fi
		fi
	fi
	if (( ${RSBU_MITIGATED} == 1 )) ; then
		:
	elif ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "5.19" ; then
		if \
			[[ "${ARCH}" =~ ("amd64"|"x86") ]] \
				&& \
			( \
				   use cpu_target_x86_skylake \
				|| use cpu_target_x86_ice_lake \
				|| use cpu_target_x86_amber_lake_gen8 \
				|| use cpu_target_x86_coffee_lake_gen8 \
				|| use cpu_target_x86_whiskey_lake \
				|| use cpu_target_x86_kaby_lake_gen7 \
				|| use cpu_target_x86_kaby_lake_gen8 \
				|| use cpu_target_x86_coffee_lake_gen9 \
				|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
			) \
		; then
			if ! _check_kernel_cmdline "spectre_v2=" ; then
				:
			elif _check_kernel_cmdline "spectre_v2=on" ; then
				:
			elif _check_kernel_cmdline "spectre_v2=auto" ; then
				:
			elif _check_kernel_cmdline "spectre_v2=ibrs" ; then
				:
			elif _check_kernel_cmdline "spectre_v2=eibrs,retpoline" ; then
				:
			elif _check_kernel_cmdline "spectre_v2=eibrs,lfence" && [[ "${FIRMWARE_VENDOR}" != "amd" ]] ; then
				:
			else
eerror
eerror "Detected incorrect spectre_v2= in the kernel command line for RSBA mitigation."
eerror
eerror "Acceptable values:"
eerror
eerror "  spectre_v2=on"
eerror "  spectre_v2=auto"
		if tc-is-cross-compiler ; then
			:
		elif cat "/proc/cpuinfo" | grep -q  "flags.* ibrs " ; then
eerror "  spectre_v2=ibrs"
		fi
		if tc-is-cross-compiler ; then
			:
		elif cat "/proc/cpuinfo" | grep -q  "flags.* ibrs_enhanced " ; then
eerror "  spectre_v2=eibrs,retpoline"
			if [[ "${FIRMWARE_VENDOR}" != "amd" ]] ; then
eerror "  spectre_v2=eibrs,lfence"
			fi
		fi
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
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_rrsba
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against RRSBA.
_mitigate_id_verify_mitigation_rrsba() {
	if (( ${RSBU_MITIGATED} == 1 )) ; then
		:
	elif ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "5.17" ; then
		if \
			[[ "${ARCH}" =~ ("amd64"|"x86") ]] \
				&& \
			( \
				   use cpu_target_x86_cooper_lake \
				|| use cpu_target_x86_whiskey_lake \
				|| use cpu_target_x86_comet_lake \
				|| use cpu_target_x86_amber_lake_gen10 \
				|| use cpu_target_x86_sapphire_rapids \
				|| use cpu_target_x86_sapphire_rapids_edge_enhanced \
				|| use cpu_target_x86_alder_lake \
				|| use cpu_target_x86_cascade_lake \
				|| use cpu_target_x86_coffee_lake_gen9 \
				|| use cpu_target_x86_comet_lake \
				|| use cpu_target_x86_meteor_lake \
				|| use cpu_target_x86_granite_rapids \
				|| use cpu_target_x86_sierra_forest \
				|| use cpu_target_x86_raptor_lake_gen13 \
				|| use cpu_target_x86_raptor_lake_gen14 \
				|| use cpu_target_x86_catlow_raptor_cove \
				|| use cpu_target_x86_emerald_rapids \
				|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
			) \
		; then
			if ! _check_kernel_cmdline "spectre_v2=" ; then
				:
			elif _check_kernel_cmdline "spectre_v2=on" ; then
				:
			elif _check_kernel_cmdline "spectre_v2=auto" ; then
				:
			elif _check_kernel_cmdline "spectre_v2=eibrs" ; then
				:
			elif _check_kernel_cmdline "spectre_v2=eibrs,retpoline" ; then
				:
			elif _check_kernel_cmdline "spectre_v2=eibrs,lfence" && [[ "${FIRMWARE_VENDOR}" != "amd" ]] ; then
				:
			else
eerror
eerror "Detected incorrect spectre_v2= in the kernel command line for RRSBA mitigation."
eerror
eerror "Acceptable values:"
eerror
eerror "  spectre_v2=on"
eerror "  spectre_v2=auto"
			if tc-is-cross-compiler ; then
				:
			elif cat "/proc/cpuinfo" | grep -q  "flags.* ibrs_enhanced " ; then
eerror "  spectre_v2=eibrs"
eerror "  spectre_v2=eibrs,retpoline"
				if [[ "${FIRMWARE_VENDOR}" != "amd" ]] ; then
eerror "  spectre_v2=eibrs,lfence"
				fi
			fi
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
	fi
	if \
		use cpu_target_x86_alder_lake \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
	# Needs microcode mitigation
		CONFIG_CHECK="
			CPU_SUP_INTEL
		"
		ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for RRSBA mitigation."
		check_extra_config
	fi
}


# @FUNCTION: _mitigate_id_verify_mitigation_swapgs
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against SWAPGS.
_mitigate_id_verify_mitigation_swapgs() {
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "5.3" ; then
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
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_apdb
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2020-24513, also known as Atom Processor Domain Bypass (APDB) vulnerability.
_mitigate_id_verify_mitigation_apdb() {
	if \
		   use cpu_target_x86_apollo_lake \
		|| use cpu_target_x86_denverton \
		|| use cpu_target_x86_gemini_lake \
		|| use cpu_target_x86_snow_ridge_bts \
		|| use cpu_target_x86_elkhart_lake \
		|| use cpu_target_x86_jasper_lake \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
	# Needs microcode mitigation
		CONFIG_CHECK="
			CPU_SUP_INTEL
		"
		ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for mitigation against CVE-2020-24513, also known as the Atom Processor Domain Bypass (APDB) vulnerability."
		check_extra_config
	fi

}

# @FUNCTION: _mitigate_id_verify_mitigation_itdvcp
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2020-24512, also known as Influence of Trivial Data Value in Cache Policy (ITDVCP) vulnerability.
_mitigate_id_verify_mitigation_itdvcp() {
	if \
		   use cpu_target_x86_skylake \
		|| use cpu_target_x86_ice_lake \
		|| use cpu_target_x86_tiger_lake \
		|| use cpu_target_x86_amber_lake_gen8 \
		|| use cpu_target_x86_kaby_lake_gen7 \
		|| use cpu_target_x86_coffee_lake_gen8 \
		|| use cpu_target_x86_kaby_lake_gen8 \
		|| use cpu_target_x86_comet_lake \
		|| use cpu_target_x86_amber_lake_gen10 \
		|| use cpu_target_x86_coffee_lake_gen9 \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
	# Needs microcode mitigation
		CONFIG_CHECK="
			CPU_SUP_INTEL
		"
		ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for mitigation against CVE-2020-24512, also known as the Trivial Data Value in Cache Policy (ITDVCP) vulnerability."
		check_extra_config
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_ibrs_gh
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2020-24511, also known as IBRS Guest/Host vulnerability.
_mitigate_id_verify_mitigation_ibrs_gh() {
	if \
		   use cpu_target_x86_cascade_lake \
		|| use cpu_target_x86_cooper_lake \
		|| use cpu_target_x86_ice_lake \
		|| use cpu_target_x86_whiskey_lake \
		|| use cpu_target_x86_comet_lake \
		|| use cpu_target_x86_amber_lake_gen10 \
		|| use cpu_target_x86_coffee_lake_gen9 \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
	# Needs microcode mitigation
		CONFIG_CHECK="
			CPU_SUP_INTEL
		"
		ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for mitigation against CVE-2020-24511, also known as the IBRS Guest/Host vulnerability."
		check_extra_config
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_cve_2024_23984
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2024-23984.
_mitigate_id_verify_mitigation_cve_2024_23984() {
	if \
		   use cpu_target_x86_cedar_island \
		|| use cpu_target_x86_whitley \
		|| use cpu_target_x86_idaville \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
	# Needs microcode mitigation
		CONFIG_CHECK="
			CPU_SUP_INTEL
		"
		ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for mitigation against CVE-2024-23984."
		check_extra_config
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_sinkclose
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2023-31315, also known as Sinkclose or the SMM Lock Bypass (SLB) vulnerability.
_mitigate_id_verify_mitigation_sinkclose() {
	if \
		   use cpu_target_x86_naples \
		|| use cpu_target_x86_rome \
		|| use cpu_target_x86_milan \
		|| use cpu_target_x86_milan-x \
		|| use cpu_target_x86_genoa \
		|| use cpu_target_x86_genoa-x \
		|| use cpu_target_x86_bergamo \
		|| use cpu_target_x86_siena \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "amd" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
	# Needs microcode mitigation
		CONFIG_CHECK="
			CPU_SUP_AMD
		"
		ERROR_CPU_SUP_AMD="CONFIG_CPU_SUP_AMD is required for Sinkclose mitigation."
		check_extra_config
		if ! has_version ">=sys-kernel/linux-firmware-20240710" ; then
# Needed for custom-kernel USE flag due to RDEPEND being bypassed.
eerror ">=sys-kernel/linux-firmware-20240710 is required for Sinkclose mitigation."
			die
		fi
	fi
	if [[ "${FIRMWARE_VENDOR}" == "amd" ]] ; then
ewarn "A BIOS firmware update is required for non datacenter for Sinkclose mitigation for CPUs and GPUs."
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_cve_2024_24853
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2024-24853
_mitigate_id_verify_mitigation_cve_2024_24853() {
	if \
		   use cpu_target_x86_purley_refresh \
		|| use cpu_target_x86_cedar_island \
		|| use cpu_target_x86_greenlow \
		|| use cpu_target_x86_whitley \
		|| use cpu_target_x86_idaville \
		|| use cpu_target_x86_tatlow \
		|| use cpu_target_x86_ice_lake \
		|| use cpu_target_x86_tiger_lake \
		|| use cpu_target_x86_skylake \
		|| use cpu_target_x86_kaby_lake_gen7 \
		|| use cpu_target_x86_kaby_lake_gen8 \
		|| use cpu_target_x86_whiskey_lake \
		|| use cpu_target_x86_coffee_lake_gen8 \
		|| use cpu_target_x86_coffee_lake_gen9 \
		|| use cpu_target_x86_comet_lake \
		|| use cpu_target_x86_rocket_lake \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
	# Needs microcode mitigation
		CONFIG_CHECK="
			CPU_SUP_INTEL
		"
		ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for mitigation against CVE-2024-24853."
		check_extra_config
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_cve_2024_24980
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2024-24980
_mitigate_id_verify_mitigation_cve_2024_24980() {
	# Gen 3-5
	if \
		   use cpu_target_x86_cooper_lake \
		|| use cpu_target_x86_ice_lake \
		|| use cpu_target_x86_sapphire_rapids \
		|| use cpu_target_x86_sapphire_rapids_edge_enhanced \
		|| use cpu_target_x86_emerald_rapids \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
	# Needs microcode mitigation
		CONFIG_CHECK="
			CPU_SUP_INTEL
		"
		ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for mitigation against CVE-2024-24980."
		check_extra_config
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_cve_2024_42667
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2024-42667
_mitigate_id_verify_mitigation_cve_2024_42667() {
	if \
		use cpu_target_x86_meteor_lake \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
	# Needs microcode mitigation
		CONFIG_CHECK="
			CPU_SUP_INTEL
		"
		ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for mitigation against CVE-2024-42667."
		check_extra_config
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_cve_2023_49141
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2023-49141
_mitigate_id_verify_mitigation_cve_2023_49141() {
	if \
		   use cpu_target_x86_eagle_stream \
		|| use cpu_target_x86_catlow_raptor_cove \
		|| use cpu_target_x86_alder_lake \
		|| use cpu_target_x86_raptor_lake_gen13 \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
	# Needs microcode mitigation
		CONFIG_CHECK="
			CPU_SUP_INTEL
		"
		ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for mitigation against CVE-2023-49141."
		check_extra_config
	fi
}

# @FUNCTION: _mitigate_id_verify_mitigation_sls
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2020-13844
_mitigate_id_verify_mitigation_sls() {
	use zero-tolerance || return
# NVD says a53 but the UG1186 doc disagrees
# arm64 - harden-sls - gcc 12.1, clang 12
# x86 - harden-sls - gcc 11.3, clang 15
	if \
		   use cpu_target_arm_cortex_a32 \
		|| use cpu_target_arm_cortex_a35 \
		|| use cpu_target_arm_cortex_a53 \
		|| use cpu_target_arm_cortex_a57 \
		|| use cpu_target_arm_cortex_a72 \
		|| use cpu_target_arm_cortex_a73 \
		|| use cpu_target_arm_cortex_a34 \
	; then
# TODO
# There is SLS mitigation for x86 in the kernel but no mitigation for arm64.
ewarn "There is currently no mitigation for ARCH=${ARCH} for the kernel."
ewarn "See CONFIG_HARDEN_SLS_ALL proposal to manually patch for SLS mitigation."
	fi

# This is default off in the kernel.
	if [[ "${ARCH}" =~ ("amd64"|"x86") ]] && ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "5.17" ; then
		CONFIG_CHECK="
			SLS
		"
		ERROR_SLS="CONFIG_SLS is required for mitigation against CVE-2020-13844."
		check_extra_config

	fi
ewarn "Rowhammer mitigation should be deployed to mitigate against a post SPOILER attack (ID) that can lead to Privilege Escalation (ID, DoS, DT)."
}

# @FUNCTION: _mitigate-id_check_kernel_flags
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags
_mitigate-id_check_kernel_flags() {
	einfo "Kernel version:  ${KV_MAJOR}.${KV_MINOR}"

	if ! linux_config_src_exists ; then
eerror "Missing .config in /usr/src/linux"
		die
	fi

	local x="${KERNEL_DIR}/Makefile"
	local pv_major=$(grep "VERSION =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
	local pv_minor=$(grep "PATCHLEVEL =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
	local pv_patch=$(grep "SUBLEVEL =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
	local pv_extraversion=$(grep "EXTRAVERSION =" "${x}" | head -n 1 | cut -f 2 -d "=" | sed -E -e "s|[ ]+||g")
	local auto_version=$(_mitigate-id_get_fallback_version)
	if use auto && ver_test "${pv_major}.${pv_minor}" -lt "${auto_version}" ; then
		if [[ -L "${KERNEL_DIR}" ]] ; then
eerror "You need to switch the /usr/src/linux symlink to Linux Kernel >= ${auto_version} for USE=auto."
		else
eerror "You need to replace the kernel sources to Linux Kernel >= ${auto_version} for USE=auto."
		fi
eerror "Actual version:  ${pv_major}.${pv_minor}.${pv_patch}${pv_extraversion}"
		die
	fi

	if ! tc-is-cross-compiler && use custom-kernel ; then
		local required_version=$(_mitigate-id_get_required_version)
		[[ -z "${required_version}" ]] && required_version=$(_mitigate-id_get_fallback_version)
		is_microarch_selected || required_version=$(_mitigate-id_get_fallback_version)
einfo "The required Linux Kernel version is >= ${required_version}."
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

	if linux_chkconfig_present "BPF" && ! use bpf ; then
eerror "Detected BPF in the kernel config.  Enable the bpf USE flag."
		die
	fi
	if linux_chkconfig_present "KVM" && ! use kvm ; then
eerror "Detected KVM in the kernel config.  Enable the kvm USE flag."
		die
	fi

	# Vulnerability classes
	# CE  - Code Execution
	# DoS - Denial of Service (CVSS A:H)
	# DT  - Data Tampering (CVSS I:H)
	# ID  - Information Disclosure (CVSS C:H)
	# PE  - Privilege Escalation

	# Security implications
	# PE -> ID
	# PE -> DoS
	# PE -> ID + DoS

	_mitigate_id_mitigate_with_ssp			# PE, CE
	_mitigate_id_mitigate_with_aslr			# PE

	# Notify the user if grub or the kernel config is incorrectly
	# configured/tampered or using a copypasta-ed workaround.

	# The list below reflects hardware vulnerabilities.  For software
	# vulnerabilities, see ebuild.

	# Verification
	# CVE            | Vulnerability name           | Vulnerability classes
	# CVE-2017-5715  | Spectre v2 (BTI)             | ID
	# CVE-2017-5753  | Spectre v1 (BCB)             | ID
	# CVE-2017-5754  | Meltdown                     | ID
	# CVE-2018-3615  | Foreshadow L1TF SGX          | ID, DT (I:L)
	# CVE-2018-3620  | Foreshadow L1TF OS           | ID
	# CVE-2018-3639  | Spectre-NG v4 (SSB)          | ID
	# CVE-2018-3640  | Spectre-NG v3a (RSRR)        | ID
	# CVE-2018-3646  | Foreshadow L1TF VMM          | ID
	# CVE-2018-3665  | Lazy FP State Restore (LFSR) | ID
	# CVE-2018-3693  | Spectre-NG v1.1 (BCBS)       | ID
	# CVE-2018-12126 | MDS Fallout (MDSUM)          | ID
	# CVE-2018-12127 | MDS (MLPDS)                  | ID
	# CVE-2018-12130 | MDS ZombieLoad (MFBDS)       | ID
	# CVE-2018-15572 | SpectreRSB (RM)              | ID
	# CVE-2019-0162  | SPOILER                      | ID (C:L)
	# CVE-2019-1125  | SWAPGS                       | ID
	# CVE-2019-11091 | MDS MDSUM                    | ID
	# CVE-2019-11135 | RIDL ZombieLoad v2 (TAA)     | ID
	# CVE-2020-0543  | CrossTalk (SRBDS)            | ID
	# CVE-2020-0548  | RIDL VRS                     | ID
	# CVE-2020-0549	 | RIDL CacheOut (L1DES)        | ID
	# CVE-2020-0550  | SALVI                        | ID
	# CVE-2020-0551  | LVI				| ID
	# CVE-2020-8695  | PLATYPUS                     | ID
	# CVE-2020-8698  | VRSA                         | ID
	# CVE-2020-13844 | SLS                          | ID # TODO
	# CVE-2020-24511 | IBRS G/H                     | ID
	# CVE-2020-24512 | ITDVCP                       | ID (C:L)
	# CVE-2020-24513 | APDB                         | ID
	# CVE-2021-0086  | FPVI                         | ID
	# CVE-2021-0089  | SCSB                         | ID
	# CVE-2021-0145  | FSFPCD                       | ID
	# CVE-2021-26313 | SCSV                         | ID
	# CVE-2021-26314 | FPVI                         | ID
	# CVE-2021-33120 | MPF                          | ID (C:L), DoS (A:L)
	# CVE-2022-0001  | BHI                          | ID
	# CVE-2022-0002  | Intra-Mode BHI               | ID
	# CVE-2022-21123 | MMIO (SBDR)                  | ID
	# CVE-2022-21125 | MMIO (SBDS)                  | ID
	# CVE-2022-21166 | MMIO (DRPW)                  | ID
	# CVE-2022-21233 | AEPIC                        | ID
	# CVE-2022-23825 | Phantom (BTC-NOBR, BTC-DIR   | ID
	#                | BTC-IND)                     |
	# CVE-2022-23960 | BHB                          | ID
	# CVE-2022-26373 | PBRSBP                       | ID
	# CVE-2022-27672 | CTRAP (SMT RSB)              | ID
	# CVE-2022-28693 | RRSBA                        | ID
	# CVE-2022-29900 | Retbleed (BTC-RET)           | ID
	# CVE-2022-29901 | RSBA                         | ID
	# CVE-2022-29901 | Retbleed (BTC-RET)           | ID
	# CVE-2022-40982 | Downfall (GDS)               | ID
	# CVE-2023-20569 | Inception (SRSO)             | ID
	# CVE-2023-20593 | Zenbleed (CPIL)              | ID
	# CVE-2023-22655 | TECRA                        | DT (I:H), ID (C:L)
	# CVE-2023-23583 | Reptar                       | DoS, DT, ID
	# CVE-2023-28746 | RFDS (FP/I SIMD)             | ID
	# CVE-2023-31315 | Sinkclose                    | ID (C:L), DT (I:H), DoS (A:L)
	# CVE-2023-38575 | IBPB                         | ID
	# CVE-2023-49141 |                              | DoS, DT, ID
	# CVE-2024-23984 |                              | ID
	# CVE-2024-24853 |                              | DoS, DT, ID
	# CVE-2024-24980 |                              | ID (C:L), DT (I:H)
	# CVE-2024-42667 |                              | DoS, DT, ID

	_mitigate_id_verify_mitigation_spectre		# Mitigations against Variant 1 (2017), Variant 2 (2017)
	_mitigate_id_verify_mitigation_meltdown		# Mitigations against Variant 3 (2017)
	_mitigate_id_verify_mitigation_spectre_ng	# Mitigations against Variant 4 (2018)
							# Mitigations against Lazy FP State Restore (2018); eagerfpu removed and hardcoded enabled in 4.6 (2016), eagerfpu available in 3.7 (2012)
	_mitigate_id_verify_mitigation_foreshadow	# Mitigations against L1TF (2018)
	_mitigate_id_verify_mitigation_mds		# Mitigations against ZombieLoad/MFBDS (2028), MLPDS (2028), MSBDS (2018), MDSUM (2019)
	_mitigate_id_verify_mitigation_spectre_rsb	# Mitigations against SpectreRSB (2018)
	_mitigate_id_verify_mitigation_swapgs		# Mitigations against SWAPGS (2019)
	_mitigate_id_verify_mitigation_zombieload_v2	# Mitigations against TAA (2019)
	_mitigate_id_verify_mitigation_crosstalk	# Mitigations against SRBDS (2020)
	_mitigate_id_verify_mitigation_cacheout		# Mitigations against L1DES (2020), VRS (2020)
	_mitigate_id_verify_mitigation_platypus		# Mitigations against PLATYPUS (2020)
	_mitigate_id_verify_mitigation_vrsa		# Mitigations against VRSA (2020)
	_mitigate_id_verify_mitigation_sls		# Mitigations against SLS (2020)
	_mitigate_id_verify_mitigation_ibrs_gh		# Mitigations against IBRS G/H (2020)
	_mitigate_id_verify_mitigation_itdvcp		# Mitigations against ITDVCP (2020)
	_mitigate_id_verify_mitigation_apdb		# Mitigations against APDB (2020)
	_mitigate_id_verify_mitigation_fsfpcd		# Mitigations against FSFPCD (2021)
	_mitigate_id_verify_mitigation_mpf		# Mitigations against MPF (2021)
	_mitigate_id_verify_mitigation_spectre_bhb	# Mitigations against BHB (2022), ARM
	_mitigate_id_verify_mitigation_bhi		# Mitigations against BHI (2022), X86
	_mitigate_id_verify_mitigation_mmio_stale_data	# Mitigations against SBDR (2022), SBDS (2022), DRPW (2022)
	_mitigate_id_verify_mitigation_aepic		# Mitigations against AEPIC Leak (2022)
	_mitigate_id_verify_mitigation_pbrsbp		# Mitigations against PBRSBP (2022)
	_mitigate_id_verify_mitigation_smt_rsb		# Mitigations against SMT RSB (2022)
	_mitigate_id_verify_mitigation_retbleed		# Mitigations against Retbleed (2022)
	_mitigate_id_verify_mitigation_rsba		# Mitigations against RSBU (2022), RSBA (2022)
	_mitigate_id_verify_mitigation_rrsba		# Mitigations against RSBU (2022), RRSBA (2022)
	_mitigate_id_verify_mitigation_downfall		# Mitigations against GDS (2022)
	_mitigate_id_verify_mitigation_inception	# Mitigations against SRSO (2023)
	_mitigate_id_verify_mitigation_zenbleed		# Mitigations against Zenbleed (2023)
	_mitigate_id_verify_mitigation_tecra		# Mitigations against TECRA (2023) # PE
	_mitigate_id_verify_mitigation_reptar		# Mitigations against Reptar (2023) # PE
	_mitigate_id_verify_mitigation_rfds		# Mitigations against RFDS (2023)
	_mitigate_id_verify_mitigation_sinkclose	# Mitigations against SLB (2023) # CE
	_mitigate_id_verify_mitigation_ibpb		# Mitigations against IBPB (2023)
	_mitigate_id_verify_mitigation_cve_2023_49141   # Mitigations against CVE-2023-49141 (2023) # PE
	_mitigate_id_verify_mitigation_cve_2024_23984	# Mitigations against CVE-2024-23984 (2024)
	_mitigate_id_verify_mitigation_cve_2024_24980	# Mitigations against CVE-2024-24980 (2024) # PE
	_mitigate_id_verify_mitigation_ussb		# Mitigations against USSB (2024) # ID
	_mitigate_id_verify_mitigation_cve_2024_24853	# Mitigations against CVE-2024-24853 (2024) # PE
	_mitigate_id_verify_mitigation_cve_2024_42667	# Mitigations against CVE-2024-42667 (2024) # PE


	# For SLAM, see https://en.wikipedia.org/wiki/Transient_execution_CPU_vulnerability#2023

	# For SPOILER,
	#  - mitigation for arm64 is provided via Spectre-NG (Variant 4) mitigation and Rowhammer DRAM mitigation.
	#  - mitigation for x86* is provided via Meltdown mitigation (KPTI) and Rowhammer DRAM mitigation.
}

# @FUNCTION: _mitigate-id_get_fallback_version
# @DESCRIPTION:
# Get the fallback version when no microarches selected
_mitigate-id_get_fallback_version() {
	if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" ]] ; then
		echo "6.9"
	elif [[ "${ARCH}" == "ppc" || "${ARCH}" == "ppc64" ]] ; then
		echo "5.0"
	elif [[ "${ARCH}" == "s390" ]] ; then
		echo "4.16"
	elif [[ "${ARCH}" == "arm64" ]] ; then
		echo "6.11"
	elif [[ "${ARCH}" == "arm" ]] ; then
		echo "6.1"
	else
		echo "4.16"
	fi
}

# @FUNCTION: _mitigate-id_get_required_version
# @DESCRIPTION:
# Get the required kernel version for custom-kernel.
_mitigate-id_get_required_version() {
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
			|| use cpu_target_x86_gemini_lake \
			|| use cpu_target_x86_amber_lake_gen8 \
			|| use cpu_target_x86_coffee_lake_gen8 \
			|| use cpu_target_x86_kaby_lake_gen8 \
			|| use cpu_target_x86_whiskey_lake \
			|| use cpu_target_x86_coffee_lake_gen9 \
			|| use cpu_target_x86_comet_lake \
			|| use cpu_target_x86_amber_lake_gen10 \
			|| use cpu_target_x86_ice_lake \
			|| use cpu_target_x86_rocket_lake \
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
			|| use cpu_target_x86_sierra_forest \
			|| use cpu_target_x86_catlow_golden_cove \
			|| use cpu_target_x86_catlow_raptor_cove \
			|| use cpu_target_x86_zen_2 \
			|| use cpu_target_x86_zen_3 \
			|| use cpu_target_x86_zen_4 \
		; then
			echo "6.9" # Inception, RFDS, Zenbleed, BHI
		elif \
			   use cpu_target_x86_skylake \
			|| use cpu_target_x86_kaby_lake_gen7 \
			|| use cpu_target_x86_zen \
			|| use cpu_target_x86_zen_2 \
		; then
			echo "6.5" # Inception, Downfall
		elif \
			   use cpu_target_x86_haswell \
			|| use cpu_target_x86_broadwell \
			|| use cpu_target_x86_hewitt_lake \
			|| use cpu_target_x86_cannon_lake \
			|| use cpu_target_x86_lakefield \
			|| use cpu_target_x86_bulldozer \
			|| use cpu_target_x86_piledriver \
			|| use cpu_target_x86_steamroller \
			|| use cpu_target_x86_excavator \
			|| use cpu_target_x86_jaguar \
			|| use cpu_target_x86_zen \
			|| use cpu_target_x86_zen_plus \
			|| use cpu_target_x86_puma \
			|| use cpu_target_x86_dhyana \
		; then
			echo "5.19" # MMIO
		elif use bpf ; then
			echo "5.13" # Spectre v2, Spectre-NG (v4)
		elif \
			   use cpu_target_x86_arrandale \
			|| use cpu_target_x86_clarkdale \
			|| use cpu_target_x86_gladden \
			|| use cpu_target_x86_lynnfield \
			|| use cpu_target_x86_bakerville \
			|| use cpu_target_x86_nehalem \
			|| use cpu_target_x86_westmere \
			|| use cpu_target_x86_sandy_bridge \
			|| use cpu_target_x86_ivy_bridge \
		; then
			echo "4.19" # Foreshadow
		else
			echo "4.15" # Spectre v2
		fi
	fi
	if [[ "${ARCH}" == "ppc" || "${ARCH}" == "ppc64" ]] ; then
		if \
			   use cpu_target_ppc_85xx \
			|| use cpu_target_ppc_e500mc \
			|| use cpu_target_ppc_e5500 \
			|| use cpu_target_ppc_e6500 \
		; then
			echo "5.0" # Spectre v2
		else
			echo "4.15" # Spectre v2 fallback
		fi
	fi
	if [[ "${ARCH}" == "s390" ]] ; then
		echo "4.16" # Spectre v2
	fi
	if [[ "${ARCH}" == "arm64" ]] ; then
# TODO: Spectre v4/v3a
		if \
			   use cpu_target_arm_cortex_a76 \
			|| use cpu_target_arm_cortex_a77 \
			|| use cpu_target_arm_cortex_a78 \
			|| use cpu_target_arm_cortex_a78c \
			|| use cpu_target_arm_cortex_a710 \
			|| use cpu_target_arm_cortex_a720 \
			|| use cpu_target_arm_cortex_a725 \
			|| use cpu_target_arm_cortex_x1 \
			|| use cpu_target_arm_cortex_x1c \
			|| use cpu_target_arm_cortex_x2 \
			|| use cpu_target_arm_cortex_x3 \
			|| use cpu_target_arm_cortex_x4 \
			|| use cpu_target_arm_cortex_x925 \
			|| use cpu_target_arm_neoverse_n1 \
			|| use cpu_target_arm_neoverse_n2 \
			|| use cpu_target_arm_neoverse_v1 \
			|| use cpu_target_arm_neoverse_v2 \
			|| use cpu_target_arm_neoverse_v3 \
		; then
			echo "6.11" # USSB
		elif \
			   use cpu_target_arm_cortex_a78ae \
		; then
			echo "5.18" # BHB
		elif \
			   use cpu_target_arm_cortex_a57 \
			|| use cpu_target_arm_cortex_a72 \
			|| use cpu_target_arm_cortex_a73 \
			|| use cpu_target_arm_cortex_a75 \
							\
			|| use cpu_target_arm_cortex_a65 \
			|| use cpu_target_arm_cortex_a65ae \
			|| use cpu_target_arm_cortex_a715 \
			|| use cpu_target_arm_neoverse_e1 \
		; then
# Missing explicit recognition of BHB fix in kernel for subgroup above.  In the docs it says yes.
			echo "5.17" # BHB
		elif use bpf ; then
			echo "5.13" # Spectre v2, Spectre-NG (v4)
		else
			echo "4.16" # Spectre v2
		fi
	fi
	if [[ "${ARCH}" == "arm" ]] ; then

		if \
			   use cpu_target_arm_ampereone \
		; then
			echo "6.1" # BHB
		elif \
			   use cpu_target_arm_brahma_b15 \
			|| use cpu_target_arm_cortex_a15 \
			|| use cpu_target_arm_cortex_a57 \
			|| use cpu_target_arm_cortex_a72 \
			|| use cpu_target_arm_cortex_a73 \
			|| use cpu_target_arm_cortex_a75 \
		; then
			echo "5.18" # BHB # See commit 0dc14aa
		elif \
			   use cpu_target_arm_cortex_a76 \
			|| use cpu_target_arm_cortex_a77 \
			|| use cpu_target_arm_cortex_a78 \
			|| use cpu_target_arm_cortex_a78c \
			|| use cpu_target_arm_neoverse_n1 \
			|| use cpu_target_arm_cortex_x1 \
		; then
			echo "5.17" # BHB
		elif use bpf ; then
			echo "5.13" # Spectre v2, Spectre-NG (v4)
		elif \
			   use cpu_target_arm_cortex_r7 \
			|| use cpu_target_arm_cortex_r8 \
		; then
			echo "4.19" # Spectre
		fi
	fi
}

# @FUNCTION: mitigate-id_pkg_setup
# @DESCRIPTION:
# Check the kernel config
mitigate-id_pkg_setup() {
	if tc-is-cross-compiler && use auto ; then
eerror "The auto USE flag can only be used in native builds."
		die
	fi
	use auto && einfo "FIRMWARE_VENDOR=${FIRMWARE_VENDOR}"
	if use kernel_linux ; then
		linux-info_pkg_setup
		_mitigate-id_check_kernel_flags
# It is a common practice by hardware manufacturers to delete support or
# historical information after a period of time.
		local L=(
			cpu_target_x86_arrandale
			cpu_target_x86_broxton
			cpu_target_x86_clarkdale
			cpu_target_x86_gladden
			cpu_target_x86_lynnfield
			cpu_target_x86_nehalem
			cpu_target_x86_westmere
			cpu_target_x86_sandy_bridge
			cpu_target_x86_ivy_bridge
			cpu_target_x86_cannon_lake
			cpu_target_x86_lakefield
			cpu_target_x86_bakerville

			cpu_target_arm_cortex_a32
			cpu_target_arm_cortex_a35
			cpu_target_arm_cortex_a53
			cpu_target_arm_cortex_a34
		)
		local x
		for x in ${L[@]} ; do
			if use "${x}" ; then
ewarn "Mitigation coverage for ${x} may be incompletable due to a lack of information or the microarchitecture is End of Life (EOL)."
			fi
		done
# We didn't verify yet.  Maybe it could be run in src_test().
ewarn "Use a CPU vulnerability checker to verify complete mitigation or to help complete mitigation."
	fi
}

# @FUNCTION: mitigate-id_pkg_postinst
# @DESCRIPTION:
# Remind user to use only patched kernels especially for large packages.
mitigate-id_pkg_postinst() {
	:
}

fi
