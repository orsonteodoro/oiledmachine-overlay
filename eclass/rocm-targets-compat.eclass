# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild is part of the rocm.eclass.

# @ECLASS: rocm-targets-compat.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 8
# @BLURB: USEDEP generators
# @DESCRIPTION:
# *USEDEP genenerators for HIP/ROCm ebuilds.

# The rocm-targets-compat* eclasses addresses the following:
# 1. Missing USEDEP flags.
# 2. Deduped lists.
# 3. Reusability

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_ROCM_TARGETS_COMPAT_ECLASS} ]]; then
_ROCM_TARGETS_COMPAT_ECLASS=1

# @FUNCTION: gen_x_usedep
# @DESCRIPTION:
# Generate a USEDEP compat
#
# Example:
# ROCBLAS_USEDEP=$(gen_x_usedep ROCBLAS_5_1_TARGETS_COMPAT)
# COMPOSABLE_KERNEL_USEDEP=$(gen_x_usedep COMPOSABLE_KERNEL_5_1_TARGETS_COMPAT)
# RDEPEND="
#	sci-libs/rocBLAS[ROCBLAS_USEDEP]
#	sci-libs/composable-kernel[ROCBLAS_USEDEP]
# "
#
gen_x_usedep() {
	local x_targets_compat="${1}"

	if [[ -z "${AMDGPU_TARGETS_COMPAT[@]}" ]] ; then
#eerror "QA:  AMDGPU_TARGETS_COMPAT is a typo or missing.  Check if it is placed before \`inherit rocm\`"
#eerror "QA:  ${P}, x_targets_compat=${x_targets_compat}, called_from=gen_x_usedep"
		return
	fi

	local t="${x_targets_compat}[@]"
	if [[ -z "${!t}" ]] ; then
ewarn "${x_targets_compat} is a typo or missing."
#		die
	fi

	local list=""
	local g1
	for g1 in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		local found=0
		local g2
		local g2_suffix=""
		for g2 in ${!t} ; do
			# For the following cases:
			# foo/bar[amdgpu_targets_gfx90a_xnack_minus] == foo/bar[amdgpu_targets_gfx90a_xnack_minus]
			# foo/bar[amdgpu_targets_gfx90a_xnack_plus] == foo/bar[amdgpu_targets_gfx90a_xnack_plus]
			# foo/bar[amdgpu_targets_gfx90a] == foo/bar[amdgpu_targets_gfx90a]
			if [[ "${g1}" == "${g2}" ]] ; then
				found=1
				if [[ "${g1}" =~ "xnack_minus" && "${g2}" =~ "xnack_minus" ]] ; then
					g2_suffix="_xnack_minus"
				elif [[ "${g1}" =~ "xnack_plus" && "${g2}" =~ "xnack_plus" ]] ; then
					g2_suffix="_xnack_plus"
				else
					g2_suffix=""
				fi
				break 1

			# For the following case:
			# foo/bar[amdgpu_targets_gfx90a_xnack_minus] == foo/bar[amdgpu_targets_gfx90a]
			elif [[ \
				"${g1%%_*}" == "${g2%%_*}" \
				&& "${g1}" =~ "xnack_minus" && ! ( "${g2}" =~ "xnack" ) \
				&& "${IUSE}" =~ (^|" ")"amdgpu_targets_${g2%%_*}"($|" ") \
			]] ; then
				found=1
				g2_suffix=""

				break 1

			# For the following case:
			# foo/bar[amdgpu_targets_gfx90a] == foo/bar[amdgpu_targets_gfx90a_xnack_minus]
			elif [[ \
				"${g1%%_*}" == "${g2%%_*}" \
				&& ! ( "${g1}" =~ "xnack" ) && ( "${g2}" =~ "xnack_minus" ) \
				&& "${IUSE}" =~ (^|" ")"amdgpu_targets_${g2%%_*}_xnack_minus"($|" ") \
			]] ; then
				found=1
				g2_suffix="_xnack_minus"

				break 1

			fi
		done
		if (( ${found} == 1 )) ; then
			list+=",amdgpu_targets_${g1%%_*}${g2_suffix}?"
		fi
	done

	if [[ -z "${list}" ]] ; then
		list+=",amdgpu_targets_skip(+)"
	fi

	list="${list:1}"
	echo "${list}"
}

# @FUNCTION: get_rocm_usedep
# @DESCRIPTION:
# Generate a USEDEP compat with enabled rocm USE flag
get_rocm_usedep() {
	[[ -z "${ROCM_SLOT}" ]] && die "QA:  ROCM_SLOT must be defined before \`inherit rocm\`"
	local rocm_version="${ROCM_SLOT/./_}"
        local name="${1}"
        local extra_useflags="${2}"
        local t1="${name}_${rocm_version}_AMDGPU_USEDEP"
        t2="${t1}[@]"
        if [[ "${name}" == "MAGMA_2_6" ]] ; then
# Not packaged yet.
                return
        fi
        if [[ -z "${!t2}" ]] ; then
#eerror "QA:  AMDGPU_TARGETS_COMPAT is a typo or missing.  Check if it is placed before \`inherit rocm\`"
#eerror "QA:  ${P}, name=${name}, called_from=get_rocm_usedep"
# Dep does not contain GPU target.
                return
        fi
        if [[ "${name}" =~ ("HIPBLASLT"|"HIPCUB"|"HIPFFT"|"MIGRAPHX"|"MIOPEN"|"ROCALUTION"|"ROCBLAS"|"ROCFFT"|"ROCRAND"|"ROCPRIM"|"TENSILE") ]] ; then
		if [[ -n "${extra_useflags}" ]] ; then
	                echo "${!t2},rocm,${extra_useflags}"
		else
	                echo "${!t2},rocm"
		fi
        else
		if [[ -n "${extra_useflags}" ]] ; then
	                echo "${!t2},${extra_useflags}"
		else
	                echo "${!t2}"
		fi
        fi
}

inherit rocm-targets-compat-6.4
inherit rocm-targets-compat-7.0

fi
