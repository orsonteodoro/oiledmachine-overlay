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

inherit llvm

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
# Allow ebuilds to define IUSE, ROCM_REQUIRED_USE
_rocm_set_globals_default() {
	(( ${#AMDGPU_TARGETS_COMPAT[@]} == 0 )) && return
	local allflags=(
		"${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}"
	)
	local iuse_flags=(
		"${AMDGPU_TARGETS_COMPAT[@]/#/+amdgpu_targets_}"
	)

	if [[ "${AMDGPU_TARGETS_COMPAT[@]}" =~ "gfx900_xnack" ]] ; then
		ROCM_REQUIRED_USE+="
			amdgpu_targets_gfx900? (
				amdgpu_targets_gfx900_xnack_minus
			)
		"
	fi

	if [[ "${AMDGPU_TARGETS_COMPAT[@]}" =~ "gfx906_xnack" ]] ; then
		ROCM_REQUIRED_USE+="
			amdgpu_targets_gfx906? (
				amdgpu_targets_gfx906_xnack_minus
			)
		"
	fi

	if [[ "${AMDGPU_TARGETS_COMPAT[@]}" =~ "gfx908_xnack" ]] ; then
		ROCM_REQUIRED_USE+="
			amdgpu_targets_gfx908? (
				amdgpu_targets_gfx908_xnack_minus
			)
		"
	fi

	if [[ "${AMDGPU_TARGETS_COMPAT[@]}" =~ "gfx90a_xnack" ]] ; then
		ROCM_REQUIRED_USE+="
			amdgpu_targets_gfx90a? (
				|| (
					amdgpu_targets_gfx90a_xnack_minus
					amdgpu_targets_gfx90a_xnack_plus
				)
			)
		"
	fi

	if [[ "${AMDGPU_TARGETS_COMPAT[@]}" =~ "xnack" ]] ; then
		local x
		for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
			if [[ "${x}" =~ "xnack" ]] ; then
				ROCM_REQUIRED_USE+="
					amdgpu_targets_${x}? (
						amdgpu_targets_${x%%_*}
					)
				"
				IUSE+="
					amdgpu_targets_${x%%_*}
				"
			fi
		done
	fi

	IUSE+=" ${iuse_flags[*]}"
	ROCM_REQUIRED_USE+="
		|| (
			${allflags[*]}
		)
	"

	local list=""
	local x
	for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		list+=",amdgpu_targets_${x%%_*}(-)?"
	done
	list="${list:1}"
	ROCM_USEDEP="${list}"
}


# @FUNCTION: _rocm_set_globals
# @DESCRIPTION:
# Set global variables useful to ebuilds: IUSE, ROCM_REQUIRED_USE, and
# ROCM_USEDEP
_rocm_set_globals() {
	_rocm_set_globals_default
}

_rocm_set_globals
unset -f _rocm_set_globals_override
unset -f _rocm_set_globals_default
unset -f _rocm_set_globals

# @FUNCTION:  rocm_pkg_setup
# @DESCRIPTION:
# Init paths
rocm_pkg_setup() {
	llvm_pkg_setup # Init LLVM_SLOT
}

# @FUNCTION:  rocm_src_prepare
# @DESCRIPTION:
# Patch common paths
rocm_src_prepare() {
	IFS=$'\n'
	sed \
		-i \
		-e "s|}/llvm/bin|}/lib/llvm/@LLVM_SLOT@/bin|g" \
		$(grep -r -F -l -e "}/llvm/bin" "${WORKDIR}") \
		2>/dev/null || true
	sed \
		-i \
		-e "s|/usr/bin/clang++|@EPREFIX@/usr/lib/llvm/@LLVM_SLOT@/bin/clang++|g" \
		$(grep -r -F -l -e "/usr/bin/clang++" "${WORKDIR}") \
		2>/dev/null || true
	sed \
		-i \
		-e "s|}/llvm/bin/clang++|}/lib/llvm/@LLVM_SLOT@/bin/clang++|g" \
		$(grep -r -F -l -e "}/llvm/bin/clang++" "${WORKDIR}") \
		2>/dev/null || true
	sed \
		-i \
		-e "s|/opt/rocm/llvm/bin/clang++|/opt/rocm/lib/llvm/@LLVM_SLOT@/bin/clang++|g" \
		$(grep -r -F -l -e "/opt/rocm/llvm/bin/clang++" "${WORKDIR}") \
		2>/dev/null || true
	sed \
		-i \
		-e "s|/opt/rocm-ver|@EPREFIX@/usr|g" \
		$(grep -r -l -e "/opt/rocm" "${WORKDIR}") \
		2>/dev/null || true
	sed \
		-i \
		-e "s|/opt/rocm|@EPREFIX@/usr|g" \
		$(grep -r -l -e "/opt/rocm" "${WORKDIR}") \
		2>/dev/null || true
	sed \
		-i \
		-e "s|@EPREFIX@|${EPREFIX}|g" \
		$(grep -r -l -e "@EPREFIX@" "${WORKDIR}") \
		2>/dev/null || true
	sed \
		-i \
		-e "s|@LLVM_SLOT@|${LLVM_SLOT}|g" \
		$(grep -r -l -e "@LLVM_SLOT@" "${WORKDIR}") \
		2>/dev/null || true
	IFS=$' \t\n'
}

# @FUNCTION: get_amdgpu_flags
# @USAGE: get_amdgpu_flags
# @DESCRIPTION:
# Convert specified use flag of amdgpu_targets to compilation flags.
# Append default target feature to GPU arch. See
# https://llvm.org/docs/AMDGPUUsage.html#target-features
get_amdgpu_flags() {
	local amdgpu_target_flags
	for gpu_target in ${AMDGPU_TARGETS}; do
		local gpu_target_base="${gpu_target%%_*}"
		if [[ "${gpu_target}" =~ "xnack_minus" ]] ; then
			gpu_target="${gpu_target_base}:xnack-"
		elif [[ "${gpu_target}" =~ "xnack_plus" ]] ; then
			gpu_target="${gpu_target_base}:xnack+"
		fi
		if [[ "${AMDGPU_TARGETS_COMPAT[@]}" =~ "${gpu_target_base}_xnack" ]] \
			&& [[ "${gpu_target}" == "${gpu_target_base}" ]] ; then
			# Placeholder
			continue
		fi
		amdgpu_target_flags+=";${gpu_target}"
	done
	amdgpu_target_flags="${amdgpu_target_flags:1}"
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

EXPORT_FUNCTIONS pkg_setup src_prepare

fi
