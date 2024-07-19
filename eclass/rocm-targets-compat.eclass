# Copyright 2024 Orson Teodoro
# Copyright 2022-2023 Gentoo Authors
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
	7|8) ;;
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
#	sci-libs/composable_kernel[ROCBLAS_USEDEP]
# "
#
gen_x_usedep() {
	local x_targets_compat="${1}"

	if [[ -z "${AMDGPU_TARGETS_COMPAT[@]}" ]] ; then
#eerror "AMDGPU_TARGETS_COMPAT is a typo or missing."
		return
	fi
	local t="${x_targets_compat}[@]"
	if [[ -z "${!t}" ]] ; then
eerror "${x_targets_compat} is a typo or missing."
		die
	fi

	local list
	local g1
	for g1 in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		local found=0
		local g2
		for g2 in ${!t} ; do
			if [[ "${g2}" == "${g1}" ]] ; then
				found=1
			fi
		done
		if (( ${found} == 1 )) ; then
			list+=",amdgpu_targets_${g1}?"
		fi
	done
	list="${list:1}"
	echo "${list}"
}

inherit rocm-targets-compat-5.1
inherit rocm-targets-compat-5.2
inherit rocm-targets-compat-5.3
inherit rocm-targets-compat-5.4
inherit rocm-targets-compat-5.5
inherit rocm-targets-compat-5.6
inherit rocm-targets-compat-5.7
inherit rocm-targets-compat-6.0
inherit rocm-targets-compat-6.1

fi
