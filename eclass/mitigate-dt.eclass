# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# @ECLASS: mitigate-dt.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Mitigate side channel data tampering attacks
# @DESCRIPTION:
# This ebuild is to perform kernel checks on CPU hardware flaws that may
# cause a Denial of Service.
#
# See also https://en.wikipedia.org/wiki/Transient_execution_CPU_vulnerability
#

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_MITIGATE_DT_ECLASS} ]] ; then
_MITIGATE_DT_ECLASS=1

_mitigate_dt_set_globals() {
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

_mitigate_dt_set_globals
unset -f _mitigate_dt_set_globals

# We like to delete all of the cpu_target_* but can't because the eclass doesn't
# do auto detect min required kernel via USE=auto.  The cpu_target_x86_* does
# more accurate pruning allowing for better LTS support.  The auto will just
# simplify and prune everything except the latest stable.

# Sometimes the mitigation is not backported to the older kernel series.  This
# is why the min is raised higher for certain microarches.

CPU_TARGET_X86=(
	cpu_target_x86_arrandale
	cpu_target_x86_clarkdale
	cpu_target_x86_gladden
	cpu_target_x86_lynnfield
	cpu_target_x86_bakerville
	cpu_target_x86_nehalem
	cpu_target_x86_nehalem
	cpu_target_x86_westmere
	cpu_target_x86_sandy_bridge
	cpu_target_x86_ivy_bridge
	cpu_target_x86_haswell
	cpu_target_x86_broadwell
	cpu_target_x86_hewitt_lake
	cpu_target_x86_skylake
	cpu_target_x86_kaby_lake_gen7
	cpu_target_x86_amber_lake_gen8
	cpu_target_x86_coffee_lake_gen8
	cpu_target_x86_kaby_lake_gen8
	cpu_target_x86_ice_lake
	cpu_target_x86_sapphire_rapids
	cpu_target_x86_sapphire_rapids_edge_enhanced
	cpu_target_x86_tiger_lake
	cpu_target_x86_alder_lake
	cpu_target_x86_catlow_golden_cove
	cpu_target_x86_rocket_lake
	cpu_target_x86_raptor_lake_gen13
	cpu_target_x86_raptor_lake_gen14
	cpu_target_x86_purley_refresh
	cpu_target_x86_cedar_island
	cpu_target_x86_greenlow
	cpu_target_x86_whitley
	cpu_target_x86_tatlow
	cpu_target_x86_eagle_stream
	cpu_target_x86_catlow_raptor_cove
	cpu_target_x86_idaville
	cpu_target_x86_whiskey_lake
	cpu_target_x86_coffee_lake_gen9
	cpu_target_x86_comet_lake
	cpu_target_x86_meteor_lake

	cpu_target_x86_cooper_lake
	cpu_target_x86_emerald_rapids

	cpu_target_x86_milan
	cpu_target_x86_milan-x
	cpu_target_x86_genoa
	cpu_target_x86_genoa-x
	cpu_target_x86_bergamo
	cpu_target_x86_zen_4
	cpu_target_x86_zen_3
	cpu_target_x86_zen_2
	cpu_target_x86_zen
	cpu_target_x86_naples
	cpu_target_x86_rome
	cpu_target_x86_siena
)

inherit linux-info toolchain-funcs

IUSE+="
	${ACTIVE_VERSIONS[@]/./_}
	${CPU_TARGET_X86[@]}
	auto
	custom-kernel
	+enforce
	firmware
	kvm
	+zero-tolerance
	ebuild_revision_0
"
REQUIRED_USE="
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
	cpu_target_x86_nehalem? (
		firmware
	)
	cpu_target_x86_nehalem? (
		firmware
	)
	cpu_target_x86_westmere? (
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
	cpu_target_x86_ice_lake? (
		firmware
	)
	cpu_target_x86_sapphire_rapids? (
		firmware
	)
	cpu_target_x86_sapphire_rapids_edge_enhanced? (
		firmware
	)
	cpu_target_x86_tiger_lake? (
		firmware
	)
	cpu_target_x86_sapphire_rapids? (
		firmware
	)
	cpu_target_x86_alder_lake? (
		firmware
	)
	cpu_target_x86_catlow_golden_cove? (
		firmware
	)
	cpu_target_x86_rocket_lake? (
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
	cpu_target_x86_whiskey_lake? (
		firmware
	)
	cpu_target_x86_coffee_lake_gen9? (
		firmware
	)
	cpu_target_x86_comet_lake? (
		firmware
	)
	cpu_target_x86_cooper_lake? (
		firmware
	)
	cpu_target_x86_emerald_rapids? (
		firmware
	)
	cpu_target_x86_meteor_lake? (
		firmware
	)
	cpu_target_x86_idaville? (
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
	cpu_target_x86_naples? (
		firmware
	)
	cpu_target_x86_rome? (
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

# broxton needs verification
_mitigate_dt_foreshadow_rdepend_x86_64() {
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
_mitigate_dt_foreshadow_rdepend_x86_32() {
	_mitigate_dt_foreshadow_rdepend_x86_64
}

_mitigate_dt_tecra_rdepend_x86_64() {
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
_mitigate_dt_tecra_rdepend_x86_32() {
	_mitigate_dt_tecra_rdepend_x86_64
}

_mitigate_dt_CACHEWARP_rdepend_x86_64() {
	if _use cpu_target_x86_milan ; then
		if _use firmware ; then
			gen_linux_firmware_ge 20230724
		fi
	fi
	if _use cpu_target_x86_milan-x ; then
		if _use firmware ; then
			gen_linux_firmware_ge 20230724
		fi
	fi
}
_mitigate_dt_CACHEWARP_rdepend_x86_32() {
	_mitigate_dt_CACHEWARP_rdepend_x86_64
}

_mitigate_dt_reptar_rdepend_x86_64() {
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
_mitigate_dt_reptar_rdepend_x86_32() {
	_mitigate_dt_reptar_rdepend_x86_64
}

_mitigate_dt_sinkclose_rdepend_x86_64() {
	if _use cpu_target_x86_naples ; then
		if _use firmware ; then
			gen_linux_firmware_ge 20240710
		fi
	fi
	if _use cpu_target_x86_rome ; then
		if _use firmware ; then
			gen_linux_firmware_ge 20240710
		fi
	fi
	if _use cpu_target_x86_milan ; then
		if _use firmware ; then
			gen_linux_firmware_ge 20240710
		fi
	fi
	if _use cpu_target_x86_milan-x ; then
		if _use firmware ; then
			gen_linux_firmware_ge 20240710
		fi
	fi
	if _use cpu_target_x86_genoa ; then
		if _use firmware ; then
			gen_linux_firmware_ge 20240710
		fi
	fi
	if _use cpu_target_x86_genoa-x ; then
		if _use firmware ; then
			gen_linux_firmware_ge 20240710
		fi
	fi
	if _use cpu_target_x86_bergamo ; then
		if _use firmware ; then
			gen_linux_firmware_ge 20240710
		fi
	fi
	if _use cpu_target_x86_siena ; then
		if _use firmware ; then
			gen_linux_firmware_ge 20240710
		fi
	fi
}
_mitigate_dt_sinkclose_rdepend_x86_32() {
	_mitigate_dt_sinkclose_rdepend_x86_64
}

_mitigate_dt_cve_2024_24853_rdepend_x86_64() {
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
_mitigate_dt_cve_2024_24853_rdepend_x86_32() {
	_mitigate_dt_cve_2024_24853_rdepend_x86_64
}

_mitigate_dt_cve_2024_24980_rdepend_x86_64() {
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
_mitigate_dt_cve_2024_24980_rdepend_x86_32() {
	_mitigate_dt_cve_2024_24980_rdepend_x86_64
}

_mitigate_dt_cve_2024_42667_rdepend_x86_64() {
	if _use cpu_target_x86_meteor_lake ; then
		gen_intel_microcode_ge 20240813
	fi
}
_mitigate_dt_cve_2024_42667_rdepend_x86_32() {
	_mitigate_dt_cve_2024_42667_rdepend_x86_64
}

_mitigate_dt_cve_2023_49141_rdepend_x86_64() {
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

_mitigate_dt_cve_2023_49141_rdepend_x86_32() {
	_mitigate_dt_cve_2023_49141_rdepend_x86_64
}

_mitigate_dt_auto() {
	if [[ "${FIRMWARE_VENDOR}" == "amd" ]] ; then
		gen_linux_firmware_ge 20240811
	fi
	if [[ "${FIRMWARE_VENDOR}" == "intel" ]] ; then
		gen_intel_microcode_ge 20250812
	fi
}

# @ECLASS_VARIABLE: MITIGATE_DT_RDEPEND
# @INTERNAL
# @DESCRIPTION:
# High level RDEPEND
mitigate_dt_rdepend() {
	if _use kernel_linux ; then
		if ! _use custom-kernel ; then
			if _use auto ; then
				_mitigate_dt_auto
			fi
			if _use amd64 ; then
				_mitigate_dt_foreshadow_rdepend_x86_64
				_mitigate_dt_tecra_rdepend_x86_64
				_mitigate_dt_reptar_rdepend_x86_64
				_mitigate_dt_sinkclose_rdepend_x86_64
				_mitigate_dt_cve_2023_49141_rdepend_x86_64
				_mitigate_dt_cve_2024_24853_rdepend_x86_64
				_mitigate_dt_cve_2024_24980_rdepend_x86_64
				_mitigate_dt_cve_2024_42667_rdepend_x86_64
			fi
			if _use x86 ; then
				_mitigate_dt_foreshadow_rdepend_x86_32
				_mitigate_dt_tecra_rdepend_x86_32
				_mitigate_dt_reptar_rdepend_x86_32
				_mitigate_dt_sinkclose_rdepend_x86_32
				_mitigate_dt_cve_2023_49141_rdepend_x86_32
				_mitigate_dt_cve_2024_24853_rdepend_x86_32
				_mitigate_dt_cve_2024_24980_rdepend_x86_32
				_mitigate_dt_cve_2024_42667_rdepend_x86_32
			fi
		fi
	fi
}

# @FUNCTION: _mitigate_dt_mitigate_with_ssp
# @INTERNAL
# @DESCRIPTION:
# Check for SSP to prevent pre attack for privilege escalation which can lead to data theft.
_mitigate_dt_mitigate_with_ssp() {
	CONFIG_CHECK="
		STACKPROTECTOR
	"
	ERROR_STACKPROTECTOR="CONFIG_STACKPROTECTOR is required for SSP to mitigate against privilege escalation which could lead to data theft."
	check_extra_config
}

# @FUNCTION: _mitigate_dt_mitigate_with_aslr
# @INTERNAL
# @DESCRIPTION:
# Check for ASLR to prevent pre attack for privilege escalation which can lead to data theft.
_mitigate_dt_mitigate_with_aslr() {
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

# @FUNCTION: _mitigate_dt_verify_mitigation_foreshadow
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against Foreshadow.
_mitigate_dt_verify_mitigation_foreshadow() {
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

# @FUNCTION: _mitigate_dt_verify_mitigation_tecra
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2023-22655, also known as the Trusted Execution Register Access (TECRA) vulnerability.
_mitigate_dt_verify_mitigation_tecra() {
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

# @FUNCTION: _mitigate_dt_verify_mitigation_reptar
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against Reptar.
_mitigate_dt_verify_mitigation_reptar() {
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

# @FUNCTION: _mitigate_dt_verify_mitigation_sinkclose
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2023-31315, also known as Sinkclose or the SMM Lock Bypass (SLB) vulnerability.
_mitigate_dt_verify_mitigation_sinkclose() {
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

# @FUNCTION: _mitigate_dt_verify_mitigation_cachewarp
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CacheWarp, also known as the CacheWarp attack or the "AMD INVD Instruction Security Vulnerability".
_mitigate_dt_verify_mitigation_cachewarp() {
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
		ERROR_CPU_SUP_AMD="CONFIG_CPU_SUP_AMD is required for CacheWarp mitigation."
		check_extra_config
		if ! has_version ">=sys-kernel/linux-firmware-20230724" ; then
# Needed for custom-kernel USE flag due to RDEPEND being bypassed.
eerror ">=sys-kernel/linux-firmware-20230724 is required for CacheWarp mitigation."
			die
		fi
	fi
	if use cpu_target_x86_rome ; then
eerror "No mitigation for CacheWarp for Rome"
	fi
	if use cpu_target_x86_naples ; then
eerror "No mitigation for CacheWarp for Naples"
	fi
	if use auto && ( use auto && [[ "${FIRMWARE_VENDOR}" == "amd" && "${ARCH}" =~ ("amd64"|"x86") ]] ) ; then
eerror "No mitigation for CacheWarp for Rome."
eerror "No mitigation for CacheWarp for Naples."
	fi
}

# @FUNCTION: _mitigate_dt_verify_mitigation_cve_2024_24853
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2024-24853
_mitigate_dt_verify_mitigation_cve_2024_24853() {
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

# @FUNCTION: _mitigate_dt_verify_mitigation_cve_2024_24980
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2024-24980
_mitigate_dt_verify_mitigation_cve_2024_24980() {
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

# @FUNCTION: _mitigate_dt_verify_mitigation_cve_2023_49141
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2023-49141
_mitigate_dt_verify_mitigation_cve_2023_49141() {
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

# @FUNCTION: _mitigate_dt_verify_mitigation_cve_2024_42667
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2024-42667
_mitigate_dt_verify_mitigation_cve_2024_42667() {
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


# @FUNCTION: _mitigate-dt_check_kernel_flags
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags
_mitigate-dt_check_kernel_flags() {
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
	local auto_version=$(_mitigate-dt_get_fallback_version)
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
		local required_version=$(_mitigate-dt_get_required_version)
		[[ -z "${required_version}" ]] && required_version=$(_mitigate-dt_get_fallback_version)
		is_microarch_selected || required_version=$(_mitigate-dt_get_fallback_version)
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

	_mitigate_dt_mitigate_with_ssp			# PE, CE
	_mitigate_dt_mitigate_with_aslr			# PE

	# Notify the user if grub or the kernel config is incorrectly
	# configured/tampered or using a copypasta-ed workaround.

	# The list below reflects hardware vulnerabilities.  For software
	# vulnerabilities, see ebuild.

	# Verification
	# CVE            | Vulnerability name           | Vulnerability classes
	# CVE-2018-3615  | Foreshadow L1TF SGX          | ID, DT (I:L)
	# CVE-2023-20592 | CacheWarp                    | DT
	# CVE-2023-22655 | TECRA                        | DT (I:H), ID (C:L)
	# CVE-2023-23583 | Reptar                       | DoS, DT, ID
	# CVE-2023-31315 | Sinkclose                    | ID (C:L), DT (I:H), DoS (A:L)
	# CVE-2023-49141 |                              | DoS, DT, ID
	# CVE-2024-24853 |                              | DoS, DT, ID
	# CVE-2024-24980 |                              | ID (C:L), DT (I:H)
	# CVE-2024-42667 |                              | DoS, DT, ID

	_mitigate_dt_verify_mitigation_foreshadow		# Mitigations against L1TF (2018)
	_mitigate_dt_verify_mitigation_cachewarp		# Mitigations against CacheWarp # DT
	_mitigate_dt_verify_mitigation_tecra			# Mitigations against TECRA (2023) # PE
	_mitigate_dt_verify_mitigation_reptar			# Mitigations against Reptar (2023) # PE
	_mitigate_dt_verify_mitigation_sinkclose		# Mitigations against SLB (2023) # CE
	_mitigate_dt_verify_mitigation_cve_2023_49141		# Mitigations against CVE-2023-49141 (2023) # PE
	_mitigate_dt_verify_mitigation_cve_2024_24853		# Mitigations against CVE-2024-24853 (2024) # PE
	_mitigate_dt_verify_mitigation_cve_2024_24980		# Mitigations against CVE-2024-24980 (2024) # PE
	_mitigate_dt_verify_mitigation_cve_2024_42667		# Mitigations against CVE-2024-42667 (2024) # PE
}

# @FUNCTION: _mitigate-dt_get_fallback_version
# @DESCRIPTION:
# Get the fallback version when no microarches selected
_mitigate-dt_get_fallback_version() {
	if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" ]] ; then
		echo "5.4"
	fi
}

# @FUNCTION: _mitigate-dt_get_required_version
# @DESCRIPTION:
# Get the required kernel version for custom-kernel.
_mitigate-dt_get_required_version() {
	if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" ]] ; then
		if \
			   use cpu_target_x86_apollo_lake \
			|| use cpu_target_x86_denverton \
		; then
			echo "5.4"
		fi
	fi
}

# @FUNCTION: mitigate-dt_pkg_setup
# @DESCRIPTION:
# Check the kernel config
mitigate-dt_pkg_setup() {
	if tc-is-cross-compiler && use auto ; then
eerror "The auto USE flag can only be used in native builds."
		die
	fi
	use auto && einfo "FIRMWARE_VENDOR=${FIRMWARE_VENDOR}"
	if use kernel_linux ; then
		linux-info_pkg_setup
		_mitigate-dt_check_kernel_flags
	fi
}

fi
