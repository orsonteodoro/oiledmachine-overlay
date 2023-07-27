# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rocm.eclass
# @MAINTAINER:
# Gentoo Science Project <sci@gentoo.org>
# @AUTHOR:
# Yiyang Wu <xgreenlandforwyy@gmail.com>
# @SUPPORTED_EAPIS: 8
# @BLURB: Common functions and variables for ROCm packages written in HIP
# @DESCRIPTION:
# ROCm packages such as sci-libs/<roc|hip>*, and packages built on top of ROCm
# libraries, can utilize variables and functions provided by this eclass.
# It handles the AMDGPU_TARGETS variable via USE_EXPAND, so user can
# edit USE flag to control which GPU architecture to compile. Using
# ${ROCM_USEDEP} can ensure coherence among dependencies. Ebuilds can call the
# function get_amdgpu_flag to translate activated target to GPU compile flags,
# passing it to configuration. Function check_amdgpu can help ebuild ensure
# read and write permissions to GPU device in src_test phase, throwing friendly
# error message if unavailable.
#
# oiledmachine-overlay changes:
# Reworked _rocm_set_globals for better version handling.
#
# @EXAMPLE:
# Example ebuild for ROCm library in https://github.com/ROCmSoftwarePlatform
# which uses cmake to build and test, and depends on rocBLAS:
# @CODE
# ROCM_VERSION=${PV}
# inherit cmake rocm
# # ROCm libraries SRC_URI is usually in form of:
# SRC_URI="https://github.com/ROCmSoftwarePlatform/${PN}/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"
# S=${WORKDIR}/${PN}-rocm-${PV}
# SLOT="0/$(ver_cut 1-2)"
# IUSE="test"
# REQUIRED_USE="${ROCM_REQUIRED_USE}"
# RESTRICT="!test? ( test )"
#
# RDEPEND="
#     dev-util/hip
#     sci-libs/rocBLAS:${SLOT}[${ROCM_USEDEP}]
# "
#
# src_configure() {
#     # avoid sandbox violation
#     addpredict /dev/kfd
#     addpredict /dev/dri/
#     local mycmakeargs=(
#         -DAMDGPU_TARGETS="$(get_amdgpu_flags)"
#         -DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
#     )
#     CXX=hipcc cmake_src_configure
# }
#
# src_test() {
#     check_amdgpu
#     # export LD_LIBRARY_PATH=<path to built lib dir> if necessary
#     cmake_src_test # for packages using the cmake test
#     # For packages using a standalone test binary rather than cmake test,
#     # just execute it (or using edob)
# }
# @CODE
#
# Examples for packages depend on ROCm libraries -- a package which depends on
# rocBLAS, uses comma separated ${HCC_AMDGPU_TARGET} to determine GPU
# architectures, and requires ROCm version >=5.1
# @CODE
# ROCM_VERSION=5.1
# inherit rocm
# IUSE="rocm"
# REQUIRED_USE="rocm? ( ${ROCM_REQUIRED_USE} )"
# DEPEND="rocm? ( >=dev-util/hip-${ROCM_VERSION}
#     >=sci-libs/rocBLAS-${ROCM_VERSION}[${ROCM_USEDEP}] )"
#
# src_configure() {
#     if use rocm; then
#         local amdgpu_flags=$(get_amdgpu_flags)
#         export HCC_AMDGPU_TARGET=${amdgpu_flags//;/,}
#     fi
#     default
# }
# src_test() {
#     use rocm && check_amdgpu
#     default
# }
# @CODE

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_ROCM_ECLASS} ]]; then
_ROCM_ECLASS=1

# @ECLASS_VARIABLE: ROCM_VERSION
# @REQUIRED
# @PRE_INHERIT
# @DESCRIPTION:
# The ROCm version of current package. For ROCm libraries, it should be ${PV};
# for other packages that depend on ROCm libraries, this can be set to match
# the version required for ROCm libraries.

# @ECLASS_VARIABLE: ROCM_REQUIRED_USE
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Requires at least one AMDGPU target to be compiled.
# Example use for ROCm libraries:
# @CODE
# REQUIRED_USE="${ROCM_REQUIRED_USE}"
# @CODE
# Example use for packages that depend on ROCm libraries:
# @CODE
# IUSE="rocm"
# REQUIRED_USE="rocm? ( ${ROCM_REQUIRED_USE} )"
# @CODE

# @ECLASS_VARIABLE: ROCM_USEDEP
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# This is an eclass-generated USE-dependency string which can be used to
# depend on another ROCm package being built for the same AMDGPU architecture.
#
# The generated USE-flag list is compatible with packages using rocm.eclass.
#
# Example use:
# @CODE
# DEPEND="sci-libs/rocBLAS[${ROCM_USEDEP}]"
# @CODE

# @FUNCTION: _rocm_set_globals_default
# @DESCRIPTION:
# Set global variables useful to ebuilds: IUSE, ROCM_REQUIRED_USE, and
# ROCM_USEDEP
_rocm_set_globals_default() {
	# See
	# https://github.com/RadeonOpenCompute/ROCm/blob/rocm-4.0.0/README.md#supported-gpus
	# https://github.com/ROCmSoftwarePlatform/Tensile/blob/rocm-5.6.0/Tensile/Source/lib/include/Tensile/AMDGPU.hpp
	# https://github.com/ROCmSoftwarePlatform/Tensile/blob/rocm-5.6.0/Tensile/Common.py#L274
	# https://llvm.org/docs/AMDGPUUsage.html#processors
	local amdgpu_targets=()

# Allowed via ROC_ENABLE_PRE_VEGA=true in ROCclr
#	if ver_test ${ROCM_VERSION} -lt 4.5 ; then
		# See https://github.com/ROCm-Developer-Tools/ROCclr/blob/rocm-5.6.0/utils/flags.hpp#L248
		# See https://github.com/ROCm-Developer-Tools/ROCclr/blob/rocm-5.6.0/device/device.hpp
		amdgpu_targets+=(
			gfx701 # Since 2.6
			gfx702
			gfx803 # offered in in 2.10 but dropped since 4.0
		)
#	fi

	# 2.10
	amdgpu_targets+=(
		# Vega allowed
		gfx900
		gfx906
		gfx908
	)

	if ver_test ${ROCM_VERSION} -ge 3.3.0 ; then
		amdgpu_targets+=(
			${amdgpu_targets}
			gfx1010
		)
	fi

	if ver_test ${ROCM_VERSION} -ge 4.3.0 ; then
		amdgpu_targets+=(
			gfx90a # Not listed in flags.hpp but in Common.py
			gfx910
			gfx1011
			gfx1012
			gfx1030
		)
	fi

	if ver_test ${ROCM_VERSION} -ge 5.3.0 ; then
		amdgpu_targets+=(
			gfx1100
			gfx1101
			gfx1102
		)
	fi

	if ver_test ${ROCM_VERSION} -ge 5.5.0 ; then
		amdgpu_targets+=(
			gfx1031
			gfx1032
			gfx1034
			gfx1035
		)
	fi

	local _list=()
	if [[ -n "${AMDGPU_TARGETS_BLACKLIST[@]}" ]] ; then
		local x
		local y
		for x in ${amdgpu_targets[@]} ; do
			local bl=0
			for y in ${AMDGPU_TARGETS_BLACKLIST[@]} ; do
				if [[ "${x}" == "${y}" ]] ; then
					bl=1
				fi
			done
			if (( ${bl} == 0 )) ; then
				_list+=( "${x}" )
			fi
		done
		amdgpu_targets=(
			${_list[@]}
		)
	fi

	if [[ -z "${amdgpu_targets[@]}" ]] ; then
		die "Unknown ROCm major version! Please update rocm.eclass before bumping to new ebuilds"
	fi

	local iuse_flags=(
		"${amdgpu_targets[@]/#/+amdgpu_targets_}"
	)
	IUSE="${iuse_flags[*]}"

	local all_amdgpu_targets=(
		"${amdgpu_targets[@]}"
	)
	local allflags=( "${all_amdgpu_targets[@]/#/amdgpu_targets_}" )
	ROCM_REQUIRED_USE=" || ( ${allflags[*]} )"

	local optflags=${allflags[@]/%/(-)?}
	ROCM_USEDEP=${optflags// /,}
}

# @FUNCTION: _rocm_set_globals_override
# @DESCRIPTION:
# Allow ebuilds to define IUSE, ROCM_REQUIRED_USE
_rocm_set_globals_override() {
	local iuse_flags=(
		"${AMDGPU_TARGETS_OVERRIDE[@]/#/+amdgpu_targets_}"
	)
	IUSE="${iuse_flags[*]}"

	local allflags=(
		"${AMDGPU_TARGETS_OVERRIDE[@]/#/amdgpu_targets_}"
	)
	ROCM_REQUIRED_USE=" || ( ${allflags[*]} )"

	local optflags=${allflags[@]/%/(-)?}
	ROCM_USEDEP=${optflags// /,}
}


# @FUNCTION: _rocm_set_globals
# @DESCRIPTION:
# Set global variables useful to ebuilds: IUSE, ROCM_REQUIRED_USE, and
# ROCM_USEDEP
_rocm_set_globals() {
	if [[ -n "${AMDGPU_TARGETS_OVERRIDE[@]}" ]] ; then
		_rocm_set_globals_override
	else
		_rocm_set_globals_default
	fi
}

_rocm_set_globals
unset -f _rocm_set_globals_override
unset -f _rocm_set_globals_default
unset -f _rocm_set_globals


# @FUNCTION: get_amdgpu_flags
# @USAGE: get_amdgpu_flags
# @DESCRIPTION:
# Convert specified use flag of amdgpu_targets to compilation flags.
# Append default target feature to GPU arch. See
# https://llvm.org/docs/AMDGPUUsage.html#target-features
get_amdgpu_flags() {
	local amdgpu_target_flags
	for gpu_target in ${AMDGPU_TARGETS}; do
		if [[ "${gpu_target}" =~ "xnack_minus" ]] ; then
			gpu_target="${gpu_target%%_*}:xnack-"
		elif [[ "${gpu_target}" =~ "xnack_plus" ]] ; then
			gpu_target="${gpu_target%%_*}:xnack+"
		fi
		amdgpu_target_flags+="${gpu_target}${target_feature};"
	done
	echo "${amdgpu_target_flags}"
}

# @FUNCTION: check_amdgpu
# @USAGE: check_amdgpu
# @DESCRIPTION:
# grant and check read-write permissions on AMDGPU devices, die if not available.
check_amdgpu() {
	for device in /dev/kfd /dev/dri/render*; do
		addwrite ${device}
		if [[ ! -r ${device} || ! -w ${device} ]]; then
			eerror "Cannot read or write ${device}!"
			eerror "Make sure it is present and check the permission."
			ewarn "By default render group have access to it. Check if portage user is in render group."
			die "${device} inaccessible"
		fi
	done
}

fi
