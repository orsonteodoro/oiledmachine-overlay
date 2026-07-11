# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# @ECLASS: dss.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Helper for the dss ebuild
# @DESCRIPTION:
# This ebuild is to help forcefully remove old kernels.
#

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_DSS_ECLASS} ]] ; then
_DSS_ECLASS=1

FLAVORS=(
	"sys-kernel/gentoo-kernel" # 7.1.3, 7.1.2_p1
	"sys-kernel/gentoo-kernel-bin" # 7.1.3, 7.1.2_p1, 6.18.38
	"sys-kernel/gentoo-sources" # 7.1.3, 7.1.2-r1
	"sys-kernel/git-sources" # 7.2_rc2
	"sys-kernel/linux-next" # 9999
	"sys-kernel/ot-sources" # 7.1.3
	"sys-kernel/vanilla-kernel" # 7.1.3, 6.18.9999
	"sys-kernel/vanilla-sources" # 7.1.3
)

FLAVORS_MAJOR_MINOR=(
)

FLAVORS_POINT_RELEASE=(
	"sys-kernel/gentoo-kernel"
	"sys-kernel/gentoo-kernel-bin"
	"sys-kernel/gentoo-sources"
	"sys-kernel/ot-sources"
	"sys-kernel/vanilla-sources"
)

FLAVORS_POST_3C_RELEASE=(
	"sys-kernel/gentoo-kernel"
	"sys-kernel/gentoo-kernel-bin"
)

FLAVORS_POST_2C_RELEASE=(
)

FLAVORS_RC=(
	"sys-kernel/git-sources"
)

FLAVORS_LIVE_9999=(
	"sys-kernel/linux-next"
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

gen_render_kernels_list_v2() {
	local acceptable_list=""
	local eol_list=""
	local o
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
			"${CUSTOM_KERNEL_ATOM}"
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "post-3c" ]] ; then
		FLAVORS_POST_3C_RELEASE+=(
			"${CUSTOM_KERNEL_ATOM}"
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "post-2c" ]] ; then
		FLAVORS_POST_2C_RELEASE+=(
			"${CUSTOM_KERNEL_ATOM}"
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "rc" ]] ; then
		FLAVORS_RC+=(
			"${CUSTOM_KERNEL_ATOM}"
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "live-9999" ]] ; then
		FLAVORS_LIVE_9999+=(
			"${CUSTOM_KERNEL_ATOM}"
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "live-slot-9999" ]] ; then
		FLAVORS_LIVE_SLOT_9999+=(
			"${CUSTOM_KERNEL_ATOM}"
		)
	fi

	for slot in "${EOL_VERSIONS[@]}" ; do
		for x in "${FLAVORS[@]}" ; do
			eol_list+="
				!=${x}-${slot}*
			"
		done
	done

	for pv in "${MULTISLOT_LATEST_KERNEL_RELEASE[@]}" ; do
		[[ "${pv}" =~ "rc" ]] && continue
		for x in "${FLAVORS_POINT_RELEASE[@]}" ; do
			for y in $(_seq 1 ${pv##*.}) ; do
				eol_list+="
					!~${x}-${pv%.*}.${y}
				"
			done
		done
		for x in "${FLAVORS_POST_3C_RELEASE[@]}" ; do
			for y in $(_seq 1 ${pv##*.}) ; do
				eol_list+="
					!=${x}-${pv%.*}.${y}_p*
				"
			done
		done
	done

	for pv in "${MULTISLOT_LATEST_KERNEL_RELEASE[@]}" ; do
		[[ "${pv}" =~ "rc" ]] && continue
		for x in "${FLAVORS_POINT_RELEASE[@]}" ; do
			acceptable_list+="
				~${x}-${pv}
			"
		done
	done

	for pv in "${MULTISLOT_LATEST_KERNEL_RELEASE[@]}" ; do
		[[ "${pv}" =~ "rc" ]] && continue
		for x in "${FLAVORS_POST_3C_RELEASE[@]}" ; do
			acceptable_list+="
				=${x}-${pv}_p*
			"
		done
	done

	for slot in "${ACTIVE_VERSIONS[@]}" ; do
		for x in "${FLAVORS_POST_2C_RELEASE[@]}" ; do
			acceptable_list+="
				=${x}-${slot}_p*
			"
		done
	done

	for pv in "${MULTISLOT_LATEST_KERNEL_RELEASE[@]}" ; do
		[[ "${pv}" =~ "rc" ]] || continue
		for x in "${FLAVORS_RC[@]}" ; do
			acceptable_list+="
				~${x}-${pv}
			"
		done
	done

	for slot in "${ACTIVE_VERSIONS[@]}" ; do
		for x in "${FLAVORS_LIVE_9999[@]}" ; do
			acceptable_list+="
				=${x}-${slot}.9999
			"
		done
	done

	for x in "${FLAVORS_LIVE_SLOT_9999[@]}" ; do
		acceptable_list+="
			=${x}-9999
		"
	done

	# EOL list
	o="
		${eol_list}
	"
	echo "${o}"
#einfo "EOL list:"
#einfo "${o}"

	# Acceptable list
	o="
		|| (
			${acceptable_list}
		)
	"
	echo "${o}"
#einfo "Acceptable list:"
#einfo "${o}"
}

fi
