# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# @ECLASS: secure-kernel.eclass
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

inherit secure-version

_mitigate_dt_set_globals() {
	FIRMWARE_VENDOR=${FIRMWARE_VENDOR:-""}
	if [[ -z "${FIRMWARE_VENDOR}" ]] ; then
ewarn "FIRMWARE_VENDOR is unset."
ewarn "Set FIRMWARE_VENDOR in /etc/portage/make.conf or as a per-package environment variable for ${CATEGORY}/${PN}."
ewarn "Valid values:  amd, intel, misc"
	fi
	if [[ "${FIRMWARE_VENDOR}" == "amd" ]] ; then
		FIRMWARE_VENDOR="amd"
	fi
	if [[ "${FIRMWARE_VENDOR}" == "intel" ]] ; then
		FIRMWARE_VENDOR="intel"
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
	${CPU_TARGET_X86[@]}
	auto
	custom-kernel
	dss
	+enforce
	intel-microcode
	landlock
	linux-firmware
	kvm
	mseal
"
REQUIRED_USE="
	cpu_target_x86_arrandale? (
		intel-microcode
	)
	cpu_target_x86_clarkdale? (
		intel-microcode
	)
	cpu_target_x86_gladden? (
		intel-microcode
	)
	cpu_target_x86_lynnfield? (
		intel-microcode
	)
	cpu_target_x86_bakerville? (
		intel-microcode
	)
	cpu_target_x86_nehalem? (
		intel-microcode
	)
	cpu_target_x86_nehalem? (
		intel-microcode
	)
	cpu_target_x86_westmere? (
		intel-microcode
	)
	cpu_target_x86_sandy_bridge? (
		intel-microcode
	)
	cpu_target_x86_ivy_bridge? (
		intel-microcode
	)
	cpu_target_x86_haswell? (
		intel-microcode
	)
	cpu_target_x86_broadwell? (
		intel-microcode
	)
	cpu_target_x86_hewitt_lake? (
		intel-microcode
	)
	cpu_target_x86_skylake? (
		intel-microcode
	)
	cpu_target_x86_kaby_lake_gen7? (
		intel-microcode
	)
	cpu_target_x86_amber_lake_gen8? (
		intel-microcode
	)
	cpu_target_x86_coffee_lake_gen8? (
		intel-microcode
	)
	cpu_target_x86_kaby_lake_gen8? (
		intel-microcode
	)
	cpu_target_x86_ice_lake? (
		intel-microcode
	)
	cpu_target_x86_sapphire_rapids? (
		intel-microcode
	)
	cpu_target_x86_sapphire_rapids_edge_enhanced? (
		intel-microcode
	)
	cpu_target_x86_tiger_lake? (
		intel-microcode
	)
	cpu_target_x86_sapphire_rapids? (
		intel-microcode
	)
	cpu_target_x86_alder_lake? (
		intel-microcode
	)
	cpu_target_x86_catlow_golden_cove? (
		intel-microcode
	)
	cpu_target_x86_rocket_lake? (
		intel-microcode
	)
	cpu_target_x86_raptor_lake_gen13? (
		intel-microcode
	)
	cpu_target_x86_raptor_lake_gen14? (
		intel-microcode
	)

	cpu_target_x86_purley_refresh? (
		intel-microcode
	)
	cpu_target_x86_cedar_island? (
		intel-microcode
	)
	cpu_target_x86_greenlow? (
		intel-microcode
	)
	cpu_target_x86_tatlow? (
		intel-microcode
	)
	cpu_target_x86_whiskey_lake? (
		intel-microcode
	)
	cpu_target_x86_coffee_lake_gen9? (
		intel-microcode
	)
	cpu_target_x86_comet_lake? (
		intel-microcode
	)
	cpu_target_x86_cooper_lake? (
		intel-microcode
	)
	cpu_target_x86_emerald_rapids? (
		intel-microcode
	)
	cpu_target_x86_meteor_lake? (
		intel-microcode
	)
	cpu_target_x86_idaville? (
		intel-microcode
	)

	cpu_target_x86_milan? (
		linux-firmware
	)
	cpu_target_x86_milan-x? (
		linux-firmware
	)
	cpu_target_x86_genoa? (
		linux-firmware
	)
	cpu_target_x86_genoa-x? (
		linux-firmware
	)
	cpu_target_x86_bergamo? (
		linux-firmware
	)
	cpu_target_x86_naples? (
		linux-firmware
	)
	cpu_target_x86_rome? (
		linux-firmware
	)
	cpu_target_x86_siena? (
		linux-firmware
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

DSS_FLAVORS=(
	"sys-kernel/gentoo-kernel" # 7.1.3, 7.1.2_p1
	"sys-kernel/gentoo-kernel-bin" # 7.1.3, 7.1.2_p1, 6.18.38
	"sys-kernel/gentoo-sources" # 7.1.3, 7.1.2-r1
	"sys-kernel/git-sources" # 7.2_rc2
	"sys-kernel/linux-next" # 9999
	"sys-kernel/ot-sources" # 7.1.3
	"sys-kernel/vanilla-kernel" # 7.1.3, 6.18.9999
	"sys-kernel/vanilla-sources" # 7.1.3
)

DSS_FLAVORS_REJ=(
	"sys-kernel/asahi-kernel" # 7.0.12_p1
	"sys-kernel/asahi-sources" # 7.0.9_p2
	"sys-kernel/cachyos-kernel" # 7.0.12-r1, 7.0.12, 7.0.12_p1, 7.2_rc1_p1, 7.2_rc2
	"sys-kernel/cachyos-kernel-bin" # 7.1.2-r2, 7.0.12
	"sys-kernel/cachyos-sources" # 7.1.3, 7.1.2-r2
	"sys-kernel/hardened-sources" # 7.1.2, 4.3.3-r5
	"sys-kernel/liquorix-sources" # 7.0.14_p2, 6.6.8
	"sys-kernel/mips-sources" # 5.4.294
	"sys-kernel/pf-sources" # 7.0_p4
	"sys-kernel/raspberrypi-image" # 9999, 6.18.32_p20260521
	"sys-kernel/raspberrypi-sources" # 6.18.32_p20260521
	"sys-kernel/rt-sources" # 7.0.1_p2
	"sys-kernel/surface-sources" # 7.0.5
	"sys-kernel/xanmod-kernel" # 7.1.3, 7.1.2_p1
	"sys-kernel/xanmod-rt" # 6.12.31
	"sys-kernel/xanmod-sources" # 7.1.3, 7.1.2-r1
	"sys-kernel/xanmod-sources-rt" # 6.1.13
	"sys-kernel/zen-sources" # 7.1.2, 7.1.3_p1
)

FLAVORS=(
	"sys-kernel/asahi-kernel" # 7.0.12_p1
	"sys-kernel/asahi-sources" # 7.0.9_p2
	"sys-kernel/cachyos-kernel" # 7.0.12-r1, 7.0.12, 7.0.12_p1, 7.2_rc1_p1, 7.2_rc2
	"sys-kernel/cachyos-kernel-bin" # 7.1.2-r2, 7.0.12
	"sys-kernel/cachyos-sources" # 7.1.3, 7.1.2-r2
	"sys-kernel/gentoo-kernel" # 7.1.3, 7.1.2_p1
	"sys-kernel/gentoo-kernel-bin" # 7.1.3, 7.1.2_p1, 6.18.38
	"sys-kernel/gentoo-sources" # 7.1.3, 7.1.2-r1
	"sys-kernel/git-sources" # 7.2_rc2
	"sys-kernel/hardened-sources" # 7.1.2, 4.3.3-r5
	"sys-kernel/linux-next" # 9999
	"sys-kernel/liquorix-sources" # 7.0.14_p2, 6.6.8
	"sys-kernel/mips-sources" # 5.4.294
	"sys-kernel/ot-sources" # 7.1.3
	"sys-kernel/pf-sources" # 7.0_p4
	"sys-kernel/raspberrypi-image" # 9999, 6.18.32_p20260521
	"sys-kernel/raspberrypi-sources" # 6.18.32_p20260521
	"sys-kernel/rt-sources" # 7.0.1_p2
	"sys-kernel/surface-sources" # 7.0.5
	"sys-kernel/vanilla-kernel" # 7.1.3, 6.18.9999
	"sys-kernel/vanilla-sources" # 7.1.3
	"sys-kernel/xanmod-kernel" # 7.1.3, 7.1.2_p1
	"sys-kernel/xanmod-rt" # 6.12.31
	"sys-kernel/xanmod-sources" # 7.1.3, 7.1.2-r1
	"sys-kernel/xanmod-sources-rt" # 6.1.13
	"sys-kernel/zen-sources" # 7.1.2, 7.1.3_p1
)

FLAVORS_MAJOR_MINOR=(
)

FLAVORS_POINT_RELEASE=(
	"sys-kernel/cachyos-kernel"
	"sys-kernel/cachyos-kernel-bin"
	"sys-kernel/cachyos-sources"
	"sys-kernel/gentoo-kernel"
	"sys-kernel/gentoo-kernel-bin"
	"sys-kernel/gentoo-sources"
	"sys-kernel/hardened-sources"
	"sys-kernel/liquorix-sources"
	"sys-kernel/mips-sources"
	"sys-kernel/ot-sources"
	"sys-kernel/surface-sources"
	"sys-kernel/vanilla-sources"
	"sys-kernel/xanmod-kernel"
	"sys-kernel/xanmod-rt"
	"sys-kernel/xanmod-sources"
	"sys-kernel/xanmod-sources-rt"
	"sys-kernel/zen-sources"
)

FLAVORS_POST_3C_RELEASE=(
	"sys-kernel/asahi-kernel"
	"sys-kernel/asahi-sources"
	"sys-kernel/cachyos-kernel"
	"sys-kernel/gentoo-kernel"
	"sys-kernel/gentoo-kernel-bin"
	"sys-kernel/liquorix-sources"
	"sys-kernel/raspberrypi-image"
	"sys-kernel/raspberrypi-sources"
	"sys-kernel/rt-sources"
	"sys-kernel/xanmod-kernel"
	"sys-kernel/zen-sources"
)

FLAVORS_POST_2C_RELEASE=(
	"sys-kernel/pf-sources"
)

FLAVORS_RC=(
	"sys-kernel/cachyos-kernel"
	"sys-kernel/git-sources"
)

FLAVORS_LIVE_9999=(
	"sys-kernel/linux-next"
	"sys-kernel/raspberrypi-image"
)

FLAVORS_LIVE_SLOT_9999=(
	"sys-kernel/ot-sources"
	"sys-kernel/vanilla-kernel"
)



# @FUNCTION: _seq
# @DESCRIPTION:
# Generates a sequence
# Example:
# _seq 1 5 -> 1 2 3 4
_seq()
{
	local a=${1}
	local b=${2}
	local i
	for ((i=${a}; i<${b}; i+=1)); do
	    echo "${i}"
	done
}

is_dss_flavor() {
	local flavor="${1}"
	local x
	for x in "${DSS_FLAVORS[@]}" ; do
		[[ "${x}" == "${flavor}" ]] && return 0
	done
	return 1
}

DSS_MIN_SLOT="6.12"
LANDLOCK_MIN_SLOT="5.13"
MSEAL_MIN_SLOT="6.10"
gen_render_x_list_v2_iuse() {
	local x_min_ver="${1}"
	local x_cond_operator="${2}"
	local x_not_operator="${3}"
	local x_filter_rule="${4}"
	local iuse_list=""
	local eol_list=""
	local o
	local av
	local pv
	local slot
	local x
	local y

	if [[ -n "${CUSTOM_KERNEL_ATOM}" && -z "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" ]] ; then
eerror
eerror "CUSTOM_KERNEL_ATOM_VERSIONING_STYLES must be defined when using CUSTOM_KERNEL_ATOM."
eerror
eerror "Valid values:"
eerror
eerror "point-release - ex. 7.1.1"
eerror "post-3c - ex. 7.1.1_p2"
eerror "post-2c - ex. 7.1_p2"
eerror "rc - ex. 7.1_rc1"
eerror "live-9999 - ex. 9999"
eerror "live-slot-9999 - ex. 7.1.9999"
eerror
eerror "Example:"
eerror
eerror "CUSTOM_KERNEL_ATOM=\"sys-kernel/xanmod-kernel\""
eerror "CUSTOM_KERNEL_ATOM_VERSIONING_STYLES=\"point-release|post-3c\""
eerror
		die
	fi

	# CUSTOM_KERNEL_ATOM_VERSIONING_STYLES valid values
	# Example:  CUSTOM_KERNEL_ATOM_VERSIONING_STYLES="point-release|post-3c|post-2c|rc|live-9999|live-slot-9999"
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "point-release" ]] ; then
		FLAVORS_POINT_RELEASE+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "post-3c" ]] ; then
		FLAVORS_POST_3C_RELEASE+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "post-2c" ]] ; then
		FLAVORS_POST_2C_RELEASE+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "rc" ]] ; then
		FLAVORS_RC+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "live-9999" ]] ; then
		FLAVORS_LIVE_9999+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "live-slot-9999" ]] ; then
		FLAVORS_LIVE_SLOT_9999+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi

	# 7.2.3
	for pv in "${MULTISLOT_LATEST_KERNEL_RELEASE[@]}" ; do
		[[ "${pv}" =~ "rc" ]] && continue
		local slot=$(ver_cut "1-2" "${pv}")
		ver_test "${slot}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		ver_test "${slot}" "${x_cond_operator}" "${x_min_ver}" && continue
		slot="${slot/./_}"
		for x in "${FLAVORS_POINT_RELEASE[@]}" ; do
			local pn="${x#*/}"
			if [[ "${x_filter_rule}" == "dss-accept" ]] ; then
				if is_dss_flavor "${x}" ; then
					iuse_list+="
						kernel_targets_${pn}_${slot}
					"
				else
					:
				fi
			elif [[ "${x_filter_rule}" == "dss-reject" ]] ; then
				if is_dss_flavor "${x}" ; then
					:
				else
					iuse_list+="
						!kernel_targets_${pn}_${slot}
					"
				fi
			else
				iuse_list+="
					${x_not_operator}kernel_targets_${pn}_${slot}
				"
			fi
		done
	done

	# 7.2.3_p1
	for pv in "${MULTISLOT_LATEST_KERNEL_RELEASE[@]}" ; do
		[[ "${pv}" =~ "rc" ]] && continue
		local slot=$(ver_cut "1-2" "${pv}")
		ver_test "${slot}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		ver_test "${slot}" "${x_cond_operator}" "${x_min_ver}" && continue
		slot="${slot/./_}"
		for x in "${FLAVORS_POST_3C_RELEASE[@]}" ; do
			local pn="${x#*/}"
			if [[ "${x_filter_rule}" == "dss-accept" ]] ; then
				if is_dss_flavor "${x}" ; then
					iuse_list+="
						kernel_targets_${pn}_${slot}
					"
				else
					:
				fi
			elif [[ "${x_filter_rule}" == "dss-reject" ]] ; then
				if is_dss_flavor "${x}" ; then
					:
				else
					iuse_list+="
						!kernel_targets_${pn}_${slot}
					"
				fi
			else
				iuse_list+="
					${x_not_operator}kernel_targets_${pn}_${slot}
				"
			fi
		done
	done

	# 7.2_p1
	for av in "${ACTIVE_VERSIONS[@]}" ; do
		[[ "${pv}" =~ "rc" ]] && continue
		local slot=$(ver_cut "1-2" "${av}")
		ver_test "${slot}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		ver_test "${slot}" "${x_cond_operator}" "${x_min_ver}" && continue
		slot="${slot/./_}"
		for x in "${FLAVORS_POST_2C_RELEASE[@]}" ; do
			local pn="${x#*/}"
			if [[ "${x_filter_rule}" == "dss-accept" ]] ; then
				if is_dss_flavor "${x}" ; then
					iuse_list+="
						kernel_targets_${pn}_${slot}
					"
				else
					:
				fi
			elif [[ "${x_filter_rule}" == "dss-reject" ]] ; then
				if is_dss_flavor "${x}" ; then
					:
				else
					iuse_list+="
						!kernel_targets_${pn}_${slot}
					"
				fi
			else
				iuse_list+="
					${x_not_operator}kernel_targets_${pn}_${slot}
				"
			fi
		done
	done

	# 7.3_rc1
	for pv in "${MULTISLOT_LATEST_KERNEL_RELEASE[@]}" ; do
		[[ "${pv}" =~ "rc" ]] || continue
		local slot=$(ver_cut "1-2" "${pv}")
		ver_test "${slot}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		ver_test "${slot}" "${x_cond_operator}" "${x_min_ver}" && continue
		slot="${slot/./_}"
		for x in "${FLAVORS_RC[@]}" ; do
			local pn="${x#*/}"
			if [[ "${x_filter_rule}" == "dss-accept" ]] ; then
				if is_dss_flavor "${x}" ; then
					iuse_list+="
						kernel_targets_${pn}_rc
					"
				else
					:
				fi
			elif [[ "${x_filter_rule}" == "dss-reject" ]] ; then
				if is_dss_flavor "${x}" ; then
					:
				else
					iuse_list+="
						!kernel_targets_${pn}_rc
					"
				fi
			else
				iuse_list+="
					${x_not_operator}kernel_targets_${pn}_rc
				"
			fi
		done
	done

	# 6.18.9999
	for av in "${ACTIVE_VERSIONS[@]}" ; do
		local slot=$(ver_cut "1-2" "${av}")
		ver_test "${slot}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		ver_test "${slot}" "-lt" "${KERNEL_MIN_LTS_SLOT}" && continue
		ver_test "${slot}" "-gt" "${KERNEL_MAX_LTS_SLOT}" && continue
		ver_test "${slot}" "${x_cond_operator}" "${x_min_ver}" && continue
		slot="${slot/./_}"
		for x in "${FLAVORS_LIVE_9999[@]}" ; do
			local pn="${x#*/}"
			if [[ "${x_filter_rule}" == "dss-accept" ]] ; then
				if is_dss_flavor "${x}" ; then
					iuse_list+="
						kernel_targets_${pn}_${slot}_live
					"
				else
					:
				fi
			elif [[ "${x_filter_rule}" == "dss-reject" ]] ; then
				if is_dss_flavor "${x}" ; then
					:
				else
					iuse_list+="
						!kernel_targets_${pn}_${slot}_live
					"
				fi
			else
				iuse_list+="
					${x_not_operator}kernel_targets_${pn}_${slot}_live
				"
			fi
		done
	done

	# 7.3.9999
	for x in "${FLAVORS_LIVE_SLOT_9999[@]}" ; do
		local slot=$(ver_cut "1-2" "${pv}")
		ver_test "${slot}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		ver_test "${slot}" "${x_cond_operator}" "${x_min_ver}" && continue
		slot="${slot/./_}"
		local pn="${x#*/}"
		if [[ "${x_filter_rule}" == "dss-accept" ]] ; then
			if is_dss_flavor "${x}" ; then
				iuse_list+="
					kernel_targets_${pn}_live
				"
			else
				:
			fi
		elif [[ "${x_filter_rule}" == "dss-reject" ]] ; then
			if is_dss_flavor "${x}" ; then
				:
			else
				iuse_list+="
					!kernel_targets_${pn}_live
				"
			fi
		else
			iuse_list+="
				${x_not_operator}kernel_targets_${pn}_live
			"
		fi
	done

	# IUSE list
	o="
		${iuse_list}
	"
	echo "${o}"
#einfo "IUSE list:"
#einfo "${o}"
}
IUSE_KERNELS=( $(gen_render_x_list_v2_iuse "${KERNEL_MIN_SLOT}" '-lt' '') )
IUSE_DSS=( $(gen_render_x_list_v2_iuse "${DSS_MIN_SLOT}" '-lt' '' 'dss-accept') )
IUSE_DSS_REJ=( $(gen_render_x_list_v2_iuse "${DSS_MIN_SLOT}" '-ge' '!' 'dss-reject') )
IUSE_LANDLOCK=( $(gen_render_x_list_v2_iuse "${LANDLOCK_MIN_SLOT}" '-lt' '') )
IUSE_LANDLOCK_REJ=( $(gen_render_x_list_v2_iuse "${LANDLOCK_MIN_SLOT}" '-ge' '!') )
IUSE_MSEAL=( $(gen_render_x_list_v2_iuse "${MSEAL_MIN_SLOT}" '-lt' '') )
IUSE_MSEAL_REJ=( $(gen_render_x_list_v2_iuse "${MSEAL_MIN_SLOT}" '-ge' '!') )

IUSE+="
	${IUSE_KERNELS[@]}
"
REQUIRED_USE+="
	enforce? (
		!dss? (
			|| (
				${IUSE_KERNELS[@]}
			)
		)
		dss? (
			|| (
				${IUSE_DSS[@]}
			)
			${IUSE_DSS_REJ[@]}
		)
		landlock? (
			|| (
				${IUSE_LANDLOCK[@]}
			)
			${IUSE_LANDLOCK_REJ[@]}
		)
		mseal? (
			|| (
				${IUSE_MSEAL[@]}
			)
			${IUSE_MSEAL_REJ[@]}
		)
	)
"

gen_render_kernels_list_v2() {
	local acceptable_list=""
	local eol_list=""
	local landlock_list=""
	local mseal_list=""
	local o
	local av
	local pv
	local slot
	local x
	local y

	if [[ -n "${CUSTOM_KERNEL_ATOM}" && -z "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" ]] ; then
eerror
eerror "CUSTOM_KERNEL_ATOM_VERSIONING_STYLES must be defined when using CUSTOM_KERNEL_ATOM."
eerror
eerror "Valid values:"
eerror
eerror "point-release - ex. 7.1.1"
eerror "post-3c - ex. 7.1.1_p2"
eerror "post-2c - ex. 7.1_p2"
eerror "rc - ex. 7.1_rc1"
eerror "live-9999 - ex. 9999"
eerror "live-slot-9999 - ex. 7.1.9999"
eerror
eerror "Example:"
eerror
eerror "CUSTOM_KERNEL_ATOM=\"sys-kernel/xanmod-kernel\""
eerror "CUSTOM_KERNEL_ATOM_VERSIONING_STYLES=\"point-release|post-3c\""
eerror
		die
	fi

	# CUSTOM_KERNEL_ATOM_VERSIONING_STYLES valid values
	# Example:  CUSTOM_KERNEL_ATOM_VERSIONING_STYLES="point-release|post-3c|post-2c|rc|live-9999|live-slot-9999"
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "point-release" ]] ; then
		FLAVORS_POINT_RELEASE+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "post-3c" ]] ; then
		FLAVORS_POST_3C_RELEASE+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "post-2c" ]] ; then
		FLAVORS_POST_2C_RELEASE+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "rc" ]] ; then
		FLAVORS_RC+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "live-9999" ]] ; then
		FLAVORS_LIVE_9999+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "live-slot-9999" ]] ; then
		FLAVORS_LIVE_SLOT_9999+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi

	for slot in "${EOL_VERSIONS[@]}" ; do
		for x in "${FLAVORS[@]}" ${CUSTOM_KERNEL_ATOM} ; do
			[[ -z "${x}" ]] && continue
			eol_list+="
				!=${x}-${slot}*
			"
		done
	done

	for pv in "${MULTISLOT_LATEST_KERNEL_RELEASE[@]}" ; do
		local dots="${pv//[^.]}"
		n_dots=${#dots}
		[[ "${pv}" =~ "rc" ]] && continue
		for x in "${FLAVORS_POINT_RELEASE[@]}" ; do
			if (( ${n_dots} == 2 )) && (( ${pv##*.} >= 1 )) ; then
				# if 7.1.1 or newer:
				#   delete 7.1_rc*, 7.1, 7.1_p*, 7.1.0, 7.1.0_p*
				eol_list+="
					!=${x}-${pv%.*}_rc*
					!~${x}-${pv%.*}
					!=${x}-${pv%.*}_p*
					!~${x}-${pv%.*}.0
					!=${x}-${pv%.*}.0_p*
				"
			fi
			for y in $(_seq 1 ${pv##*.}) ; do
				eol_list+="
					!~${x}-${pv%.*}.${y}
				"
			done
		done
		for x in "${FLAVORS_POST_3C_RELEASE[@]}" ; do
			local _pv=$(ver_cut 1-3 "${pv}")
			if (( ${n_dots} == 2 )) && (( ${_pv##*.} >= 1 )) ; then
				# if 7.1.1_p0 or newer:
				#   delete 7.1_rc*, 7.1, 7.1_p*, 7.1.0, 7.1.0_p*
				eol_list+="
					!=${x}-${pv%.*}_rc*
					!~${x}-${pv%.*}
					!=${x}-${pv%.*}_p*
					!~${x}-${pv%.*}.0
					!=${x}-${pv%.*}.0_p*
				"
			fi
			for y in $(_seq 1 ${pv##*.}) ; do
				eol_list+="
					!=${x}-${pv%.*}.${y}_p*
				"
			done
		done
	done

	# 7.2.3
	for pv in "${MULTISLOT_LATEST_KERNEL_RELEASE[@]}" ; do
		[[ "${pv}" =~ "rc" ]] && continue
		local slot=$(ver_cut "1-2" "${pv}")
		ver_test "${slot}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		slot="${slot/./_}"
		for x in "${FLAVORS_POINT_RELEASE[@]}" ; do
			local pn="${x#*/}"
			acceptable_list+="
				kernel_targets_${pn}_${slot}? (
					~${x}-${pv}
				)
			"
		done
	done

	# 7.2.3_p1
	for pv in "${MULTISLOT_LATEST_KERNEL_RELEASE[@]}" ; do
		[[ "${pv}" =~ "rc" ]] && continue
		local slot=$(ver_cut "1-2" "${pv}")
		ver_test "${slot}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		slot="${slot/./_}"
		for x in "${FLAVORS_POST_3C_RELEASE[@]}" ; do
			local pn="${x#*/}"
			acceptable_list+="
				kernel_targets_${pn}_${slot}? (
					=${x}-${pv}_p*
				)
			"
		done
	done

	# 7.2_p1
	for av in "${ACTIVE_VERSIONS[@]}" ; do
		[[ "${pv}" =~ "rc" ]] && continue
		local slot=$(ver_cut "1-2" "${av}")
		ver_test "${slot}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		slot="${slot/./_}"
		for x in "${FLAVORS_POST_2C_RELEASE[@]}" ; do
			local pn="${x#*/}"
			acceptable_list+="
				kernel_targets_${pn}_${slot}? (
					=${x}-${av}_p*
				)
			"
		done
	done

	# 7.3_rc1
	for pv in "${MULTISLOT_LATEST_KERNEL_RELEASE[@]}" ; do
		[[ "${pv}" =~ "rc" ]] || continue
		local slot=$(ver_cut "1-2" "${pv}")
		ver_test "${slot}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		slot="${slot/./_}"
		for x in "${FLAVORS_RC[@]}" ; do
			local pn="${x#*/}"
			acceptable_list+="
				kernel_targets_${pn}_rc? (
					~${x}-${pv}
				)
			"
		done
	done

	# 6.18.9999
	for av in "${ACTIVE_VERSIONS[@]}" ; do
		local slot=$(ver_cut "1-2" "${av}")
		ver_test "${slot}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		ver_test "${slot}" "-lt" "${KERNEL_MIN_LTS_SLOT}" && continue
		ver_test "${slot}" "-gt" "${KERNEL_MAX_LTS_SLOT}" && continue
		slot="${slot/./_}"
		for x in "${FLAVORS_LIVE_9999[@]}" ; do
			local pn="${x#*/}"
			acceptable_list+="
				kernel_targets_${pn}_${slot}_live? (
					=${x}-${av}.9999
				)
			"
		done
	done

	# 7.3.9999
	for x in "${FLAVORS_LIVE_SLOT_9999[@]}" ; do
		local slot=$(ver_cut "1-2" "${pv}")
		ver_test "${slot}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		slot="${slot/./_}"
		local pn="${x#*/}"
		acceptable_list+="
			kernel_targets_${pn}_live? (
				=${x}-9999
			)
		"
	done

	# landlock is for PT mitigation
	for x in "${FLAVORS[@]}" ${CUSTOM_KERNEL_ATOM} ; do
		[[ -z "${x}" ]] && continue
		landlock_list+="
			!<${x}-${LANDLOCK_MIN_SLOT}
		"
	done

	# mseal is for RCE mitigation
	for x in "${FLAVORS[@]}" ${CUSTOM_KERNEL_ATOM} ; do
		[[ -z "${x}" ]] && continue
		mseal_list+="
			!<${x}-${MSEAL_MIN_SLOT}
		"
	done

	# landlock list
	o="
		landlock? (
			${landlock_list}
		)
	"
	echo "${o}"

	# mseal list
	o="
		mseal? (
			${mseal_list}
		)
	"
	echo "${o}"

	# EOL list
	o="
		${eol_list}
	"
	echo "${o}"
#einfo "EOL list:"
#einfo "${o}"

	# Acceptable list
	o="
		${acceptable_list}
	"
	echo "${o}"
#einfo "Acceptable list:"
#einfo "${o}"
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

# @FUNCTION: _secure-kernel_get_fallback_version
# @DESCRIPTION:
# Get the fallback version when no microarches selected
_secure-kernel_get_fallback_version() {
	if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" ]] ; then
		echo "5.4"
	fi
}

# @FUNCTION: _secure-kernel_get_required_version
# @DESCRIPTION:
# Get the required kernel version for custom-kernel.
_secure-kernel_get_required_version() {
	if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" ]] ; then
		if \
			   use cpu_target_x86_apollo_lake \
			|| use cpu_target_x86_denverton \
		; then
			echo "5.4"
		fi
	fi
}

# @FUNCTION: secure-kernel_pkg_setup
# @DESCRIPTION:
# Check the kernel config
secure-kernel_pkg_setup() {
	if tc-is-cross-compiler && use auto ; then
eerror "The auto USE flag can only be used in native builds."
		die
	fi
	use auto && einfo "FIRMWARE_VENDOR=${FIRMWARE_VENDOR}"
	if use kernel_linux ; then
		linux-info_pkg_setup
	fi
}

fi
