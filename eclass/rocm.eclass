# Copyright 2022-2025 Gentoo Authors
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

inherit hip-versions
inherit flag-o-matic toolchain-funcs

BDEPEND+="
	dev-util/patchelf
"

declare -A _GLIBCXX_VER_INV=(
	# See https://gcc.gnu.org/onlinedocs/libstdc++/manual/abi.html
	# ["$GLIBCXX"]=$GCC_PV
	['GCC_14_1_0']="3.4.33"
	['GCC_13_2_0']="3.4.32"
	['GCC_13_1_0']="3.4.31"
	['GCC_12_1_0']="3.4.30"
	['GCC_11_1_0']="3.4.29"
	['GCC_10_1_0']="3.4.28"
	['GCC_9_2_0']="3.4.27"
	['GCC_9_1_0']="3.4.26"
	['GCC_8_1_0']="3.4.25"
	['GCC_7_2_0']="3.4.24"
	['GCC_7_1_0']="3.4.23"
	['GCC_6_1_0']="3.4.22"
	['GCC_5_1_0']="3.4.21"
	['GCC_4_9_0']="3.4.20"
	['GCC_4_8_3']="3.4.19"
	['GCC_4_8_0']="3.4.18"
	['GCC_4_7_0']="3.4.17"
	['GCC_4_6_1']="3.4.16"
	['GCC_4_6_0']="3.4.15"
	['GCC_4_5_0']="3.4.14"
	['GCC_4_4_2']="3.4.13"
	['GCC_4_4_1']="3.4.12"
	['GCC_4_4_0']="3.4.11"
	['GCC_4_3_0']="3.4.10"
	['GCC_4_2_0']="3.4.9"
	['GCC_4_1_1']="3.4.8"
	['GCC_4_0_3']="3.4.7"
	['GCC_4_0_2']="3.4.6"
	['GCC_4_0_1']="3.4.5"
	['GCC_4_0_0']="3.4.4"
	['GCC_3_4_3']="3.4.3"
	['GCC_3_4_2']="3.4.2"
	['GCC_3_4_1']="3.4.1"
	['GCC_3_4']="3.4.0"
	['GCC_3_3_3']="3.2.3"
	['GCC_3_3_0']="3.2.2"
	['GCC_3_2_1']="3.2.1"
	['GCC_3_2_0']="3.2"
	['GCC_3_1_1']="3.1"
)

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

# @ECLASS_VARIABLE: ROCM_USE_LLVM_ROC
# @DESCRIPTION:
# ROCM_USE_LLVM_ROC=1 fixes rpaths for llvm-roc and sets some @...@ symbols to
# point to paths in use the llvm-roc.  If ROCM_USE_LLVM_ROC=0, it will fix
# rpaths and @...@ symbols to point to the system's llvm.

# @FUNCTION: _report_hipify_requirements
# @DESCRIPTION:
_report_hipify_requirements() {
	if [[ -n "${ROCM_SLOT}" ]] ; then
		local _HIP_CUDA_VERSION="HIPIFY_${ROCM_SLOT/./_}_CUDA_SLOT"
		local HIP_CUDA_VERSION="${!_HIP_CUDA_VERSION}"

		local _HIPIFY_CUDA_SDK_EBUILD_URI="HIPIFY_${ROCM_SLOT/./_}_CUDA_URI"
		local HIPIFY_CUDA_SDK_EBUILD_URI="${!_HIPIFY_CUDA_SDK_EBUILD_URI}"

		if has cuda ${IUSE_EFFECTIVE} ; then
ewarn
ewarn "You are responsible for maintaining a local copy of"
ewarn "=dev-util/nvidia-cuda-toolkit-${HIP_CUDA_VERSION}* for"
ewarn "${CATEGORY}/${PN}-${PVR}:${SLOT} for CUDA support if ebuild not"
ewarn "available."
ewarn
ewarn "=dev-util/nvidia-cuda-toolkit-${HIP_CUDA_VERSION}* ebuild URI:"
ewarn "${HIPIFY_CUDA_SDK_EBUILD_URI}"
ewarn
		fi
	fi
}

# @FUNCTION: _rocm_set_globals_default
# @DESCRIPTION:
# Allow ebuilds to define IUSE, ROCM_REQUIRED_USE
_rocm_set_globals_default() {
	if [[ -z "${ROCM_VERSION}" ]] ; then
		export ROCM_VERSION="${PV}"
	fi

	if [[ -n "${ROCM_SLOT}" ]] ; then
		local _ROCM_CLANG_USEDEP=""
		if [[ -n "${ROCM_CLANG_USEDEP}" ]] ; then
			_ROCM_CLANG_USEDEP="[${ROCM_CLANG_USEDEP}]"
		fi
		ROCM_CLANG_DEPEND="
			~sys-devel/llvm-roc-${ROCM_VERSION}:${ROCM_SLOT}${_ROCM_CLANG_USEDEP}
			sys-devel/llvm-roc:=
		"
		HIP_CLANG_DEPEND="
			${ROCM_CLANG_DEPEND}
		"
	fi

	HIP_SUPPORT_CUDA="${HIP_SUPPORT_CUDA:-0}"
	HIP_SUPPORT_ROCM="${HIP_SUPPORT_ROCM:-1}"
	# Based on sys-devel/llvm-roc.
	# See
	# https://github.com/ROCm/HIPIFY/blob/rocm-6.1.2/docs/hipify-clang.rst
	# https://github.com/ROCm/HIPIFY/blob/rocm-6.0.2/docs/hipify-clang.md
	# https://github.com/ROCm/HIPIFY/blob/rocm-5.7.1/docs/hipify-clang.md
	# https://github.com/ROCm/HIPIFY/blob/rocm-5.6.1/docs/hipify-clang.md
	# https://github.com/ROCm/HIPIFY/blob/rocm-5.5.1/README.md
	# https://github.com/ROCm/HIPIFY/blob/rocm-5.4.3/README.md
	# https://github.com/ROCm/HIPIFY/blob/rocm-5.3.3/README.md
	# https://github.com/ROCm/HIPIFY/blob/rocm-5.2.3/README.md
	# https://github.com/ROCm/HIPIFY/blob/rocm-5.1.3/README.md
	# https://github.com/ROCm/HIPIFY/blob/rocm-5.0.2/README.md
	# https://github.com/ROCm/HIPIFY/blob/rocm-4.5.2/README.md

	local gen_hip_cuda_impl=""
	if [[ -n "${ROCM_SLOT}" ]] ; then
		local _HIP_CUDA_VERSION="HIPIFY_${ROCM_SLOT/./_}_CUDA_SLOT"
		HIP_CUDA_VERSION="${!_HIP_CUDA_VERSION}"

		local _HIPIFY_CUDA_SDK_EBUILD_URI="HIPIFY_${ROCM_SLOT/./_}_CUDA_URI"
		HIPIFY_CUDA_SDK_EBUILD_URI="${!_HIPIFY_CUDA_SDK_EBUILD_URI}"

		gen_hip_cuda_impl+="
			=dev-util/nvidia-cuda-toolkit-${HIP_CUDA_VERSION}*
		"
	else
		HIP_SUPPORT_CUDA=0
	fi
	if [[ "${HIP_SUPPORT_CUDA}" == "1" ]] ; then
		HIP_CUDA_DEPEND="
			|| (
				${gen_hip_cuda_impl}
			)
			dev-util/nvidia-cuda-toolkit:=
		"
	fi
	if has rocm ${IUSE_EFFECTIVE} && has cuda ${IUSE_EFFECTIVE} ; then
		if [[ "${HIP_SUPPORT_CUDA}" == "1" ]] ; then
			HIPCC_DEPEND+="
				cuda? (
					|| (
						${gen_hip_cuda_impl[@]}
					)
					dev-util/nvidia-cuda-toolkit:=
				)
			"
		fi
		if [[ "${HIP_SUPPORT_ROCM}" == "1" && -n "${ROCM_SLOT}" ]] ; then
			HIPCC_DEPEND+="
				rocm? (
					~sys-devel/llvm-roc-${ROCM_VERSION}:${ROCM_SLOT}
					sys-devel/llvm-roc:=
				)
			"
		elif [[ "${HIP_SUPPORT_ROCM}" == "1" && -z "${ROCM_SLOT}" ]] ; then
			HIPCC_DEPEND+="
				rocm? (
					sys-devel/llvm-roc:=
				)
			"
		fi
	elif has rocm ${IUSE_EFFECTIVE} && ! has cuda ${IUSE_EFFECTIVE} ; then
		if [[ "${HIP_SUPPORT_CUDA}" == "1" ]] ; then
			HIPCC_DEPEND+="
				!rocm? (
					|| (
						${gen_hip_cuda_impl[@]}
					)
					dev-util/nvidia-cuda-toolkit:=
				)
			"
		fi
		if [[ "${HIP_SUPPORT_ROCM}" == "1" && -n "${ROCM_SLOT}" ]] ; then
			HIPCC_DEPEND+="
				rocm? (
					~sys-devel/llvm-roc-${ROCM_VERSION}:${ROCM_SLOT}
					sys-devel/llvm-roc:=
				)
			"
		elif [[ "${HIP_SUPPORT_ROCM}" == "1" && -z "${ROCM_SLOT}" ]] ; then
			HIPCC_DEPEND+="
				rocm? (
					sys-devel/llvm-roc:=
				)
			"
		fi
	elif has cuda ${IUSE_EFFECTIVE} && ! has rocm ${IUSE_EFFECTIVE} ; then
		if [[ "${HIP_SUPPORT_CUDA}" == "1" ]] ; then
			HIPCC_DEPEND+="
				cuda? (
					|| (
						${gen_hip_cuda_impl[@]}
					)
					dev-util/nvidia-cuda-toolkit:=
				)
			"
		fi
		if [[ "${HIP_SUPPORT_ROCM}" == "1" && -n "${ROCM_SLOT}" ]] ; then
			HIPCC_DEPEND+="
				!cuda? (
					~sys-devel/llvm-roc-${ROCM_VERSION}:${ROCM_SLOT}
					sys-devel/llvm-roc:=
				)
			"
		elif [[ "${HIP_SUPPORT_ROCM}" == "1" && -z "${ROCM_SLOT}" ]] ; then
			HIPCC_DEPEND+="
				!cuda? (
					sys-devel/llvm-roc:=
				)
			"
		fi
	else
		if [[ "${HIP_SUPPORT_CUDA}" == "1" ]] ; then
			HIPCC_DEPEND="
				|| (
					${gen_hip_cuda_impl[@]}
				)
				dev-util/nvidia-cuda-toolkit:=
			"
		fi
		if [[ "${HIP_SUPPORT_ROCM}" == "1" && -n "${ROCM_SLOT}" ]] ; then
			HIPCC_DEPEND="
				~sys-devel/llvm-roc-${ROCM_VERSION}:${ROCM_SLOT}
				sys-devel/llvm-roc:=
			"
		elif [[ "${HIP_SUPPORT_ROCM}" == "1" && -z "${ROCM_SLOT}" ]] ; then
			HIPCC_DEPEND="
				sys-devel/llvm-roc:=
			"
		fi
	fi

	(( ${#AMDGPU_TARGETS_COMPAT[@]} == 0 )) && return
	local allflags=(
		"${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}"
	)
	local iuse_flags=(
		"${AMDGPU_TARGETS_COMPAT[@]/#/+amdgpu_targets_}"
	)

	if [[ "${AMDGPU_TARGETS_COMPAT[@]}" =~ "gfx900_xnack" && "${AMDGPU_TARGETS_COMPAT[@]}" =~ "amdgpu_targets_gfx900_xnack_minus" ]] ; then
		ROCM_REQUIRED_USE+="
			amdgpu_targets_gfx900? (
				amdgpu_targets_gfx900_xnack_minus
			)
		"
	fi

	if [[ "${AMDGPU_TARGETS_COMPAT[@]}" =~ "gfx906_xnack" && "${AMDGPU_TARGETS_COMPAT[@]}" =~ "amdgpu_targets_gfx906_xnack_minus" ]] ; then
		ROCM_REQUIRED_USE+="
			amdgpu_targets_gfx906? (
				amdgpu_targets_gfx906_xnack_minus
			)
		"
	fi

	if [[ "${AMDGPU_TARGETS_COMPAT[@]}" =~ "gfx908_xnack" && "${AMDGPU_TARGETS_COMPAT[@]}" =~ "amdgpu_targets_gfx908_xnack_minus" ]] ; then
		ROCM_REQUIRED_USE+="
			amdgpu_targets_gfx908? (
				amdgpu_targets_gfx908_xnack_minus
			)
		"
	fi

	if [[ "${AMDGPU_TARGETS_COMPAT[@]}" =~ "gfx90a_xnack" && "${AMDGPU_TARGETS_COMPAT[@]}" =~ "amdgpu_targets_gfx90a_xnack_minus" && "${AMDGPU_TARGETS_COMPAT[@]}" =~ "amdgpu_targets_gfx90a_xnack_plus" ]] ; then
		ROCM_REQUIRED_USE+="
			amdgpu_targets_gfx90a? (
				|| (
					amdgpu_targets_gfx90a_xnack_minus
					amdgpu_targets_gfx90a_xnack_plus
				)
			)
		"
	elif [[ "${AMDGPU_TARGETS_COMPAT[@]}" =~ "gfx90a_xnack" && "${AMDGPU_TARGETS_COMPAT[@]}" =~ "amdgpu_targets_gfx90a_xnack_minus" ]] ; then
		ROCM_REQUIRED_USE+="
			amdgpu_targets_gfx90a? (
				amdgpu_targets_gfx90a_xnack_minus
			)
		"
	fi

	if [[ "${AMDGPU_TARGETS_COMPAT[@]}" =~ "xnack" ]] ; then
		local x
		for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
			if [[ "${x}" =~ "xnack" ]] ; then
				IUSE+="
					amdgpu_targets_${x%%_*}
				"
				ROCM_REQUIRED_USE+="
					amdgpu_targets_${x}? (
						amdgpu_targets_${x%%_*}
					)
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

inherit rocm-targets-compat

# @FUNCTION:  rocm_pkg_setup
# @DESCRIPTION:
# Init paths
rocm_pkg_setup() {
	if has cuda ${IUSE_EFFECTIVE} && use cuda ; then
		if [[ "${HIP_PLATFORM}" != "nvidia" ]] ; then
eerror
eerror "Change HIP_PLATFORM=\"nvidia\" in /etc/portage/make.conf to continue."
eerror
eerror "The HIP stack should be completely uninstalled also to rebuild with the"
eerror "same GCC version."
eerror
			die
		fi
	elif has cuda ${IUSE_EFFECTIVE} && ! use cuda ; then
		if [[ -z "${HIP_PLATFORM}" ]] ; then
			:
		elif [[ "${HIP_PLATFORM}" != "amd" ]] ; then
eerror
eerror "Change HIP_PLATFORM=\"amd\" in /etc/portage/make.conf to continue."
eerror
eerror "The HIP stack should be completely uninstalled also to rebuild with the"
eerror "same GCC version."
eerror
			die
		fi
	fi

	if [[ -z "${LLVM_SLOT}" ]] ; then
eerror
eerror "LLVM_SLOT must be defined."
eerror
		die
	fi

	if [[ "${ROCM_SLOT+x}" != "x" ]] ; then
ewarn "QA:  ROCM_SLOT should be defined."
	fi

	if [[ "${ROCM_SLOT+x}" == "x" ]] ; then
		export PATH="${ESYSROOT}/opt/rocm-${ROCM_VERSION}/bin:${PATH}"
	fi

	export EROCM_PATH="/opt/rocm-${ROCM_VERSION}"
	export ROCM_PATH="${ESYSROOT}${EROCM_PATH}"

	# LLVM_SLOT must be after llvm_pkg_setup or llvm-r1_pkg_setup
	# The CLANG_SLOT is the folder name.
	if [[ "${ROCM_USE_LLVM_ROC:-1}" == "1" ]] ; then
		# ls /opt/rocm-*/llvm/lib64/clang -> 16.0.0 17.0.0
		if ver_test ${ROCM_SLOT} -ge 6.1 ; then
			CLANG_SLOT="${LLVM_SLOT}"
		else
			CLANG_SLOT="${LLVM_SLOT}.0.0"
		fi
	else
		# ls /usr/lib/clang -> 13.0.1  14.0.6  15.0.1  15.0.5  15.0.6  15.0.7  16  17
		if ver_test ${LLVM_SLOT} -ge 16 ; then
			CLANG_SLOT="${LLVM_SLOT}"
		else
			CLANG_SLOT=$(best_version "llvm-core/clang:${LLVM_SLOT}" \
				| sed -e "s|llvm-core/clang-||")
			CLANG_SLOT=$(ver_cut 1-3 "${CLANG_SLOT}")
		fi
	fi

	local clang_selected_desc
	if [[ "${ROCM_USE_LLVM_ROC:-1}" == "1" ]] ; then
		EROCM_CLANG_PATH="/opt/rocm-${ROCM_VERSION}/llvm/$(rocm_get_libdir)/clang/${CLANG_SLOT}"
		clang_selected_desc="sys-devel/llvm-roc:${ROCM_SLOT}"
	else
		EROCM_CLANG_PATH="/usr/lib/clang/${CLANG_SLOT}"
		clang_selected_desc="llvm-core/clang:${LLVM_SLOT}"
	fi

	if [[ "${ROCM_USE_LLVM_ROC:-1}" == "1" ]] ; then
		EROCM_LLVM_PATH="/opt/rocm-${ROCM_VERSION}/llvm"
	else
		EROCM_LLVM_PATH="/usr/lib/llvm/${LLVM_SLOT}"
	fi

	if [[ "${FEATURES}" =~ "ccache" && "${HIP_CLANG_DISABLE_CCACHE}" != "1" ]] ; then
		export CCACHE_PATH="${EROCM_LLVM_PATH}/bin"
	fi

	export HIP_CLANG_PATH="${ESYSROOT}/${EROCM_LLVM_PATH}/bin"

	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:${ESYSROOT}${EROCM_LLVM_PATH}/bin|g")

	if [[ "${HIP_CLANG_DISABLE_CCACHE}" == "1" ]] ; then
einfo "Removing ccache from PATH to prevent override by system's clang..."
		export PATH=$(echo "${PATH}" \
			| tr ":" "\n" \
			| sed -E -e "/ccache/d" \
			| tr "\n" ":")
	fi

# Avoid these kinds of errors with pgo by disabling ccache:
#error: number of counters in profile data for function '...' does not match its profile data (counter 'indirect_call', expected 2 and have 3) [-Werror=coverage-mismatch]
#error: the control flow of function '...' does not match its profile data (counter 'time_profiler') [-Werror=coverage-mismatch]
	if [[ "${LLVM_ROC_PGO_TRAINING}" == "1" ]] ; then
einfo "Removing ccache from PATH to prevent override by system's clang..."
		export PATH=$(echo "${PATH}" \
			| tr ":" "\n" \
			| sed -E -e "/ccache/d" \
			| tr "\n" ":")
	fi

# Unbreak dev-libs/rocm-device-libs
	if [[ "${LLVM_ROC_PGO_TRAINING}" == "1" ]] || true ; then
	# Allow to create and write a PGO profile.
		MULTILIB_ABI_FLAG=""
		local path="/var/lib/pgo-profiles/sys-devel/llvm-roc/${ROCM_SLOT}/${MULTILIB_ABI_FLAG}.${ABI}"
		addwrite "${path}"
		mkdir -p "${path}"
		chown -R portage:portage "${path}" || die
	fi

	export PKG_CONFIG_PATH="${ESYSROOT}${EROCM_PATH}/share/pkgconfig:${PKG_CONFIG_PATH}"

einfo
einfo "Eclass variables:"
einfo
einfo "  CLANG_SLOT:  ${CLANG_SLOT}"
einfo "  LLVM_SLOT:  ${LLVM_SLOT}"
einfo "  EROCM_CLANG_PATH:  ${EROCM_CLANG_PATH}"
einfo "  EROCM_LLVM_PATH:  ${EROCM_LLVM_PATH}"
einfo "  EROCM_PATH:  ${EROCM_PATH}"
einfo
einfo "Build files variables:"
einfo
einfo "  HIP_CLANG_PATH:  ${HIP_CLANG_PATH}"
einfo "  ROCM_PATH:  ${ROCM_PATH}"
einfo
einfo "Environment variables:"
einfo
einfo "  PATH:  ${PATH}"
einfo "  PKG_CONFIG_PATH:  ${PKG_CONFIG_PATH}"
einfo

	_report_hipify_requirements
}

# @FUNCTION:  _rocm_change_common_paths
# @DESCRIPTION:
# Patch common paths or symbols.
#
# Supported symbol replacements with expanded possibilities:
#
# @CHOST@        - x86_64-pc-linux-gnu, or whatever is produced by `gcc -dumpmachine`
# @CLANG_SLOT@   -
#     if ROCM_USE_LLVM_ROC==1 (default) then 13.0.0, 14.0.0, 15.0.0, 16.0.0, 17.0.0 if ROCM_SLOT <= 6.0; 17 if ROCM_SLOT >= 6.1.
#     if ROCM_USE_LLVM_ROC==0 then 13.0.1, 14.0.6, 15.0.1, 15.0.5, 15.0.6, 15.0.7, 16, 17.
# @EPREFIX@      - /home/<USER>/blah, "", or any path
# @EPREFIX_CLANG_PATH@  -
#     if ROCM_USE_LLVM_ROC==1 (default) then ${EPREFIX}/opt/rocm-${ROCM_VERSION}/llvm/lib/clang/${LLVM_SLOT}.0.0
#     if ROCM_USE_LLVM_ROC==0 then ${EPREFIX}/usr/lib/clang/${CLANG_SLOT}
# @EPREFIX_LLVM_PATH@   -
#     if ROCM_USE_LLVM_ROC==1 (default) then ${EPREFIX}/opt/rocm-${ROCM_VERSION}/llvm
#     if ROCM_USE_LLVM_ROC==0 then ${EPREFIX}/usr/lib/llvm/${LLVM_SLOT}
# @ESYSROOT@     - /usr/x86_64-pc-linux-gnu, "", or any path.
# @ESYSROOT_CLANG_PATH@ -
#     if ROCM_USE_LLVM_ROC==1 (default) then ${ESYSROOT}/opt/rocm-${ROCM_VERSION}/llvm/lib/clang/${LLVM_SLOT}.0.0
#     if ROCM_USE_LLVM_ROC==0 then ${ESYSROOT}/usr/lib/clang/${CLANG_SLOT}
# @ESYSROOT_LLVM_PATH@  -
#     if ROCM_USE_LLVM_ROC==1 (default) then ${ESYSROOT}/opt/rocm-${ROCM_VERSION}/llvm
#     if ROCM_USE_LLVM_ROC==0 then ${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}
# @GCC_SLOT@     - 10, 11, 12 [based on folders contained in /usr/lib/gcc/]
# @ABI_LIBDIR@   - lib or lib64 (same as get_libdir)
# @COND_LIBDIR@  - When evaluating @ESYSROOT_LLVM_PATH@/@COND_LIBDIR@,
#                  If cuda, then same as get_libdir.
#                  If rocm, then same as rocm_get_libdir.
#                  The ebuild defines cond_get_libdir which should echo lib or lib64.
# @ROCM_LIBDIR@  - lib (same as rocm_get_libdir)
# @LLVM_SLOT@    - 13, 14, 15, 16, 17
# @PV@           - x.y.z
# @ROCM_VERSION@ - 5.1.3, 5.2.3, 5.3.3, 5.4.3, 5.5.1, 5.6.1, 5.7.0
#

_rocm_change_common_paths() {
	IFS=$'\n'

	local _patch_paths=(
		"${WORKDIR}"
	)
	if [[ "${PATCH_PATHS[@]}" ]] ; then
		_patch_paths=(
			"${PATCH_PATHS[@]}"
		)
	fi

	sed \
		-i \
		-e "s|@EPREFIX@|${EPREFIX}|g" \
		$(grep -r -l -e "@EPREFIX@" "${_patch_paths[@]}" 2>/dev/null) \
		2>/dev/null || true
	sed \
		-i \
		-e "s|@ESYSROOT@|${ESYSROOT}|g" \
		$(grep -r -l -e "@ESYSROOT@" "${_patch_paths[@]}" 2>/dev/null) \
		2>/dev/null || true

	sed \
		-i \
		-e "s|@ABI_LIBDIR@|$(get_libdir)|g" \
		$(grep -r -l -e "@ABI_LIBDIR@" "${_patch_paths[@]}" 2>/dev/null) \
		2>/dev/null || true

	sed \
		-i \
		-e "s|@ROCM_LIBDIR@|$(rocm_get_libdir)|g" \
		$(grep -r -l -e "@ROCM_LIBDIR@" "${_patch_paths[@]}" 2>/dev/null) \
		2>/dev/null || true

	if declare -f cond_get_libdir >/dev/null ; then
		sed \
			-i \
			-e "s|@COND_LIBDIR@|$(cond_get_libdir)|g" \
			$(grep -r -l -e "@COND_LIBDIR@" "${_patch_paths[@]}" 2>/dev/null) \
			2>/dev/null || true
	fi

	# @LLVM_SLOT@ is deprecated.  Use @EPREFIX_LLVM_PATH@, @ESYSROOT_LLVM_PATH@.
	sed \
		-i \
		-e "s|@LLVM_SLOT@|${LLVM_SLOT}|g" \
		$(grep -r -l -e "@LLVM_SLOT@" "${_patch_paths[@]}" 2>/dev/null) \
		2>/dev/null || true

	# @CLANG_SLOT@ is deprecated.  Use @EPREFIX_CLANG_PATH@, @ESYSROOT_CLANG_PATH@.
	sed \
		-i \
		-e "s|@CLANG_SLOT@|${CLANG_SLOT}|g" \
		$(grep -r -l -e "@CLANG_SLOT@" "${_patch_paths[@]}" 2>/dev/null) \
		2>/dev/null || true

	sed \
		-i \
		-e "s|@ROCM_VERSION@|${ROCM_VERSION}|g" \
		$(grep -r -l -e "@ROCM_VERSION@" "${_patch_paths[@]}" 2>/dev/null) \
		2>/dev/null || true

	sed \
		-i \
		-e "s|@ROCM_SLOT@|${ROCM_SLOT}|g" \
		$(grep -r -l -e "@ROCM_SLOT@" "${_patch_paths[@]}" 2>/dev/null) \
		2>/dev/null || true

	sed \
		-i \
		-e "s|@ROCM_PATH@|${EROCM_PATH}|g" \
		$(grep -r -l -e "@ROCM_PATH@" "${_patch_paths[@]}" 2>/dev/null) \
		2>/dev/null || true

	sed \
		-i \
		-e "s|@EPREFIX_ROCM_PATH@|${EPREFIX}${EROCM_PATH}|g" \
		$(grep -r -l -e "@EPREFIX_ROCM_PATH@" "${_patch_paths[@]}" 2>/dev/null) \
		2>/dev/null || true

	sed \
		-i \
		-e "s|@ESYSROOT_ROCM_PATH@|${ESYSROOT}${EROCM_PATH}|g" \
		$(grep -r -l -e "@ESYSROOT_ROCM_PATH@" "${_patch_paths[@]}" 2>/dev/null) \
		2>/dev/null || true

	sed \
		-i \
		-e "s|@EPREFIX_CLANG_PATH@|${EPREFIX}${EROCM_CLANG_PATH}|g" \
		$(grep -r -l -e "@EPREFIX_CLANG_PATH@" "${_patch_paths[@]}" 2>/dev/null) \
		2>/dev/null || true

	sed \
		-i \
		-e "s|@ESYSROOT_CLANG_PATH@|${ESYSROOT}${EROCM_CLANG_PATH}|g" \
		$(grep -r -l -e "@ESYSROOT_CLANG_PATH@" "${_patch_paths[@]}" 2>/dev/null) \
		2>/dev/null || true

	sed \
		-i \
		-e "s|@EPREFIX_LLVM_PATH@|${EPREFIX}${EROCM_LLVM_PATH}|g" \
		$(grep -r -l -e "@EPREFIX_LLVM_PATH@" "${_patch_paths[@]}" 2>/dev/null) \
		2>/dev/null || true

	sed \
		-i \
		-e "s|@ESYSROOT_LLVM_PATH@|${ESYSROOT}${EROCM_LLVM_PATH}|g" \
		$(grep -r -l -e "@ESYSROOT_LLVM_PATH@" "${_patch_paths[@]}" 2>/dev/null) \
		2>/dev/null || true


	local libdir_suffix="$(rocm_get_libdir)"
	libdir_suffix="${libdir_suffix/lib}"
	sed \
		-i \
		-e "s|@LIBDIR_SUFFIX@|${libdir_suffix}|g" \
		$(grep -r -l -e "@LIBDIR_SUFFIX@" "${_patch_paths[@]}" 2>/dev/null) \
		2>/dev/null || true
	sed \
		-i \
		-e "s|@P@|${P}|g" \
		$(grep -r -l -e "@P@" "${_patch_paths[@]}" 2>/dev/null) \
		2>/dev/null || true
	sed \
		-i \
		-e "s|@PN@|${PN}|g" \
		$(grep -r -l -e "@PN@" "${_patch_paths[@]}" 2>/dev/null) \
		2>/dev/null || true
	sed \
		-i \
		-e "s|@PV@|${PV}|g" \
		$(grep -r -l -e "@PV@" "${_patch_paths[@]}" 2>/dev/null) \
		2>/dev/null || true
	sed \
		-i \
		-e "s|@PVR@|${PVR}|g" \
		$(grep -r -l -e "@PVR@" "${_patch_paths[@]}" 2>/dev/null) \
		2>/dev/null || true
	sed \
		-i \
		-e "s|@S@|${S}|g" \
		$(grep -r -l -e "@S@" "${_patch_paths[@]}" 2>/dev/null) \
		2>/dev/null || true
	sed \
		-i \
		-e "s|@CHOST@|${CHOST}|g" \
		$(grep -r -l -e "@CHOST@" "${_patch_paths[@]}" 2>/dev/null) \
		2>/dev/null || true
	local gcc_slot=$(gcc-major-version)
	sed \
		-i \
		-e "s|@GCC_SLOT@|${gcc_slot}|g" \
		$(grep -r -l -e "@GCC_SLOT@" "${_patch_paths[@]}" 2>/dev/null) \
		2>/dev/null || true

	if [[ -n "${EPYTHON}" ]] ; then
		sed \
			-i \
			-e "s|@EPYTHON@|${EPYTHON}|g" \
			$(grep -r -l -e "@EPYTHON@" "${_patch_paths[@]}" 2>/dev/null) \
			2>/dev/null || true
		sed \
			-i \
			-e "s|@PYTHON@|${PYTHON}|g" \
			$(grep -r -l -e "@PYTHON@" "${_patch_paths[@]}" 2>/dev/null) \
			2>/dev/null || true
	fi

	IFS=$' \t\n'
}

# @FUNCTION:  rocm_src_prepare
# @DESCRIPTION:
# Patcher
rocm_src_prepare() {
	_rocm_change_common_paths
}

# @FUNCTION:  verify_libstdcxx
# Checks if the selected gcc via eselect gcc is >= the one used to build rocr-runtime and hip.
verify_libstdcxx() {
	has_version "dev-util/hip:${ROCM_SLOT}" || return # For libamdhip64.so checks
	has_version "dev-libs/rocr-runtime:${ROCM_SLOT}" || return # For libhsa-runtime64.so.1 checks

	declare -A _GLIBCXX_VER=(
	# See https://gcc.gnu.org/onlinedocs/libstdc++/manual/abi.html
		# ["$GLIBCXX"]=$GCC_PV
		['GLIBCXX_3_4_33']="14.1.0"
		['GLIBCXX_3_4_32']="13.2.0"
		['GLIBCXX_3_4_31']="13.1.0"
		['GLIBCXX_3_4_30']="12.1.0"
		['GLIBCXX_3_4_29']="11.1.0"
		['GLIBCXX_3_4_28']="10.1.0"
		['GLIBCXX_3_4_27']="9.2.0"
		['GLIBCXX_3_4_26']="9.1.0"
		['GLIBCXX_3_4_25']="8.1.0"
		['GLIBCXX_3_4_24']="7.2.0"
		['GLIBCXX_3_4_23']="7.1.0"
		['GLIBCXX_3_4_22']="6.1.0"
		['GLIBCXX_3_4_21']="5.1.0"
		['GLIBCXX_3_4_20']="4.9.0"
		['GLIBCXX_3_4_19']="4.8.3"
		['GLIBCXX_3_4_18']="4.8.0"
		['GLIBCXX_3_4_17']="4.7.0"
		['GLIBCXX_3_4_16']="4.6.1"
		['GLIBCXX_3_4_15']="4.6.0"
		['GLIBCXX_3_4_14']="4.5.0"
		['GLIBCXX_3_4_13']="4.4.2"
		['GLIBCXX_3_4_12']="4.4.1"
		['GLIBCXX_3_4_11']="4.4.0"
		['GLIBCXX_3_4_10']="4.3.0"
		['GLIBCXX_3_4_9']="4.2.0"
		['GLIBCXX_3_4_8']="4.1.1"
		['GLIBCXX_3_4_7']="4.0.3"
		['GLIBCXX_3_4_6']="4.0.2"
		['GLIBCXX_3_4_5']="4.0.1"
		['GLIBCXX_3_4_4']="4.0.0"
		['GLIBCXX_3_4_3']="3.4.3"
		['GLIBCXX_3_4_2']="3.4.2"
		['GLIBCXX_3_4_1']="3.4.1"
		['GLIBCXX_3_4_0']="3.4"
		['GLIBCXX_3_2_3']="3.3.3"
		['GLIBCXX_3_2_2']="3.3.0"
		['GLIBCXX_3_2_1']="3.2.1"
		['GLIBCXX_3_2']="3.2.0"
		['GLIBCXX_3_1']="3.1.1"
	)

	local hip_glibcxx_ver=$(strings "${EROCM_PATH}/$(rocm_get_libdir)/libamdhip64.so" \
		| grep -E "GLIBCXX_[0-9]\.[0-9]\.[0-9]+" \
		| sort -V \
		| grep -E "^GLIBCXX" \
		| tail -n 1 \
		| cut -f 2 -d "_")
	local hsa_runtime_glibcxx_ver=$(strings "${EROCM_PATH}/$(rocm_get_libdir)/libhsa-runtime64.so" \
		| grep -E "GLIBCXX_[0-9]\.[0-9]\.[0-9]+" \
		| sort -V \
		| grep -E "^GLIBCXX" \
		| tail -n 1 \
		| cut -f 2 -d "_")
	local gcc_current_profile=$(gcc-config -c)
	local gcc_current_profile_slot=${gcc_current_profile##*-}
	local gcc_current_glibcxx_ver=$(strings "/usr/lib/gcc/${CHOST}/${gcc_current_profile_slot}/libstdc++.so" \
		| grep -E "GLIBCXX_[0-9]\.[0-9]\.[0-9]+" \
		| sort -V \
		| grep -E "^GLIBCXX" \
		| tail -n 1 \
		| cut -f 2 -d "_")
einfo
einfo "GLIBCXX used:"
einfo
printf " \e[32m*\e[0m %-30s%s\n" "dev-libs/rocr-runtime:${ROCM_SLOT}" "GCC ${_GLIBCXX_VER[GLIBCXX_${hsa_runtime_glibcxx_ver//./_}]} (GLIBCXX version ${hsa_runtime_glibcxx_ver})"
	local gcc_current_pv="${_GLIBCXX_VER[GLIBCXX_${gcc_current_glibcxx_ver//./_}]}"
printf " \e[32m*\e[0m %-30s%s\n" "sys-deve/gcc:${gcc_current_pv%%.*}" "GCC ${gcc_current_pv} (GLIBCXX version ${gcc_current_glibcxx_ver})"
printf " \e[32m*\e[0m %-30s%s\n" "sys-devel/hip:${ROCM_SLOT}" "GCC ${_GLIBCXX_VER[GLIBCXX_${hip_glibcxx_ver//./_}]} (GLIBCXX version ${hip_glibcxx_ver})"
einfo

	local _rocm_slot_glibcxx_ver="HIP_${ROCM_SLOT/./_}_GLIBCXX"
	local rocm_slot_glibcxx_ver=${!_rocm_slot_glibcxx_ver}
	local gcc_pv="${_GLIBCXX_VER[GLIBCXX_${rocm_slot_glibcxx_ver//./_}]}"
	local gcc_slot="${gcc_pv%%.*}"

	# Check eselect gcc
	if ver_test "${gcc_current_glibcxx_ver}" -gt "${rocm_slot_glibcxx_ver}" ; then
eerror
eerror "You must switch to <= GCC ${gcc_pv}.  Do"
eerror
eerror "  eselect gcc set ${CHOST}-${gcc_slot}"
eerror "  source /etc/profile"
eerror
eerror "Error 1"
eerror
		die
	fi

	# Check hip
	if ver_test "${hip_glibcxx_ver}" -gt "${rocm_slot_glibcxx_ver}" ; then
		gcc_slot="${gcc_pv%%.*}"
eerror
eerror "You must switch to <= GCC ${gcc_pv}.  Do"
eerror
eerror "  eselect gcc set ${CHOST}-${gcc_slot}"
eerror "  source /etc/profile"
eerror
eerror "Error 2"
eerror
eerror "Uninstall all sys-devel/hip slots and rebuild with GCC ${gcc_slot}."
eerror
		die
	fi

	# Check rocr-runtime
	if ver_test "${hsa_runtime_glibcxx_ver}" -gt "${rocm_slot_glibcxx_ver}" ; then
		gcc_slot="${gcc_pv%%.*}"
eerror
eerror "You must switch to <= GCC ${gcc_slot}.  Do"
eerror
eerror "  eselect gcc set ${CHOST}-${gcc_slot}"
eerror "  source /etc/profile"
eerror
eerror "Error 3"
eerror
eerror "Uninstall all dev-libs/rocr-runtime slots and rebuild with GCC ${gcc_slot}."
eerror
		die
	fi
}

# @FUNCTION:  rocm_src_configure
# @DESCRIPTION:
# Apply multilib configuration and call the build system's configure.
rocm_src_configure() {
	verify_libstdcxx

	if [[ -n "${_CMAKE_ECLASS}" ]] ; then
		if [[ "${ROCM_DEFAULT_LIBDIR:-lib}" == "lib" ]] ; then
			mycmakeargs+=(
				-DCMAKE_INSTALL_LIBDIR=$(rocm_get_libdir)
			)
		else
			mycmakeargs+=(
				-DCMAKE_INSTALL_LIBDIR="${ROCM_DEFAULT_LIBDIR}"
			)
		fi

		if [[ "${CXX}" =~ "hipcc" || "${CXX}" =~ "clang++" ]] ; then
			# Fix cmake configure time check for -lamdhip.
			# You must call rocm_src_configure not cmake_src_configure
			# Prevent configure test issues
			append-flags \
				-Wl,-L"${ESYSROOT}${EROCM_PATH}/$(rocm_get_libdir)"

			if grep -q -e "gfortran" $(find "${WORKDIR}" -name "CMakeLists.txt" -o -name "*.cmake") ; then
				:
			else
				# Prevent configure test issues
				append-flags \
					--rocm-path="${ESYSROOT}${EROCM_PATH}" \
					--rocm-device-lib-path="${ESYSROOT}${EROCM_PATH}/amdgcn/bitcode"
			fi
			append-ldflags \
				-L"${ESYSROOT}${EROCM_PATH}/$(rocm_get_libdir)"
		else
			append-flags \
				-Wl,-L"${ESYSROOT}${EROCM_PATH}/$(rocm_get_libdir)"
			append-ldflags \
				-L"${ESYSROOT}${EROCM_PATH}/$(rocm_get_libdir)"
		fi
einfo "rocm_src_configure():  Calling cmake_src_configure()"
		cmake_src_configure
	else
		ewarn "src_configure not called for the build system."
	fi
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

# @FUNCTION: rocm_mv_docs
# @DESCRIPTION:
# Move the docs to avoid a multislot collision.
rocm_mv_docs() {
	if [[ -e "${ED}/usr/share/doc" ]] ; then
		dodir "${EROCM_PATH}/share"
		if [[ -e "${ED}${EROCM_PATH}/share/doc" ]] ; then
			cp \
				-aT \
				"${ED}/usr/share/doc" \
				"${ED}${EROCM_PATH}/share/doc" \
				|| die
			rm -rf "${ED}/usr/share/doc"
		else
			dodir "${EROCM_PATH}/share/doc"
			cp \
				-aT \
				"${ED}/usr/share/doc" \
				"${ED}${EROCM_PATH}/share/doc" \
				|| die
			rm -rf "${ED}/usr/share/doc"
		fi
	fi
}

# @FUNCTION: rocm_get_libdir
# @DESCRIPTION:
# Prints out the corresponding lib folder matchin the ABI.
rocm_get_libdir() {
	echo "lib"
}

# @FUNCTION: rocm_fix_rpath
# @DESCRIPTION:
# Fix multislot issues
rocm_fix_rpath() {
	local scan_path="${1}"
	if [[ -z "${scan_path}" ]] ; then
		scan_path="${ED}"
	fi
	IFS=$'\n'
	local rocm_libs=(
		"libamdhip64.so"
		"libhiprtc.so"
		"libhsa-runtime64.so"
		"libhsakmt.so"
		"librdc_bootstrap.so"
		"librocm-dbgapi.so"
		"librocm_smi64.so"
		"librocrand.so"
		"libroctracer64.so"
	)
	local llvm_libs=(
		"libflang.so"
		"libflangrti.so"
		"libLLVMCore.so"
		"libLLVMFrontendOpenMP.so"
		"libLLVMOption.so"
		"libLLVMSupport.so"
		"libLLVMSupport.so.13git"
		"libLLVMSupport.so.14git"
		"libLLVMSupport.so.15git"
		"libLLVMSupport.so.16git"
	)
	local clang_libs=(
		"libclangBasic.so"
		"libclang.so"
		"libclang-cpp.so"
	)
	local libomp_libs=(
		"libomp.so"
	)
	local l
	local path
	for path in $(find "${scan_path}" -type f) ; do
		local is_exe=0
		local is_so=0
		if file "${path}" | grep -q "shared object" ; then
			is_so=1
		elif file "${path}" | grep -q "ELF.*executable" ; then
			is_exe=1
		elif file "${path}" | grep -q "symbolic link" ; then
			continue
		fi

		local _ABI
		if file "${path}" | grep -q "32-bit" && file "${file}" | grep -q "x86-64" ; then
			local _ABI="x32"
		elif file "${path}" | grep -q "x86-64" ; then
			local _ABI="amd64"
		elif file "${path}" | grep -q "80386" ; then
			local _ABI="x86"
		else
			continue
		fi

		local needs_rpath_patch_clang=0
		local needs_rpath_patch_libomp=0
		local needs_rpath_patch_llvm=0
		local needs_rpath_patch_rocm=0
		if (( ${is_so} || ${is_exe} )) ; then
			for l in "${rocm_libs[@]}" ; do
				if ldd "${path}" 2>/dev/null | grep -q "${l}" ; then
					if ldd "${path}" 2>/dev/null | grep "${l}" | grep -q "/rocm-[0-9]\.[0-9]\.[0-9]/" ; then
						:
					else
						needs_rpath_patch_rocm=1
					fi
				fi
			done

			if [[ "${ROCM_USE_LLVM_ROC:-1}" == "0" ]] ; then
				:
			else
				for l in "${llvm_libs[@]}" ; do
					if ldd "${path}" 2>/dev/null | grep -q "${l}" ; then
						if ldd "${path}" 2>/dev/null | grep "${l}" | grep -q "/rocm-[0-9]\.[0-9]\.[0-9]/" ; then
							:
						else
							needs_rpath_patch_llvm=1
						fi
					fi
				done

				for l in "${clang_libs[@]}" ; do
					if ldd "${path}" 2>/dev/null | grep -q "${l}" ; then
						if ldd "${path}" 2>/dev/null | grep "${l}" | grep -q "/rocm-[0-9]\.[0-9]\.[0-9]/" ; then
							:
						else
							needs_rpath_patch_clang=1
						fi
					fi
				done

				for l in "${libomp_libs[@]}" ; do
					if ldd "${path}" 2>/dev/null | grep -q "${l}" ; then
						if ldd "${path}" 2>/dev/null | grep "${l}" | grep -q "/rocm-[0-9]\.[0-9]\.[0-9]/" ; then
							:
						else
							needs_rpath_patch_libomp=1
						fi
					fi
				done
			fi

			if [[ "${ROCM_USE_LLVM_ROC:-1}" == "0" ]] ; then
				for l in "${llvm_libs[@]}" ; do
					if ldd "${path}" 2>/dev/null | grep -q "${l}" ; then
						if ldd "${path}" 2>/dev/null | grep "${l}" | grep -q "lib/llvm" ; then
							:
						else
							needs_rpath_patch_llvm=1
						fi
					fi
				done

				for l in "${clang_libs[@]}" ; do
					if ldd "${path}" 2>/dev/null | grep -q "${l}" ; then
						if ldd "${path}" 2>/dev/null | grep "${l}" | grep -q "lib/llvm" ; then
							:
						else
							needs_rpath_patch_clang=1
						fi
					fi
				done

				for l in "${libomp_libs[@]}" ; do
					if ldd "${path}" 2>/dev/null | grep -q "${l}" ; then
						if ldd "${path}" 2>/dev/null | grep "${l}" | grep -q "lib/llvm" ; then
							:
						else
							needs_rpath_patch_libomp=1
						fi
					fi
				done
			fi
		fi

		if (( ${needs_rpath_patch_rocm} )) ; then
einfo "Fixing rpath for ${path}"
			patchelf \
				--add-rpath "${EPREFIX}${EROCM_PATH}/$(rocm_get_libdir)" \
				"${path}" \
				|| die
		fi

		if (( ${needs_rpath_patch_clang} )) ; then
einfo "Fixing rpath for ${path}"
			if [[ "${_USE_AOCC}" == "1" ]] ; then
				patchelf \
					--add-rpath "${EPREFIX}${EROCM_PATH}/$(rocm_get_libdir)/llvm/alt/lib" \
					"${path}" \
					|| die
			else
				patchelf \
					--add-rpath "${EPREFIX}${EROCM_CLANG_PATH}/$(rocm_get_libdir)" \
					"${path}" \
					|| die
			fi
		fi

		if (( ${needs_rpath_patch_llvm} )) ; then
einfo "Fixing rpath for ${path}"
			patchelf \
				--add-rpath "${EPREFIX}${EROCM_LLVM_PATH}/$(rocm_get_libdir)" \
				"${path}" \
				|| die
		fi

		if (( ${needs_rpath_patch_libomp} )) ; then
einfo "Fixing rpath for ${path}"
			patchelf \
				--add-rpath "${EPREFIX}${EROCM_LLVM_PATH}/$(rocm_get_libdir)" \
				"${path}" \
				|| die
		fi

		if (( ${is_so} || ${is_exe} )) && ldd "${path}" 2>/dev/null | grep -q "not found" ; then
			if [[ "${EROCM_RPATH_SCAN_FATAL}" == "1" ]] ; then
				# Use 1 in src_install
				die "Q/A:  Missing rpath for ${path} ; Reason:  (not found)"
			else
				# Use 0 or unset in pkg_postinst
				ewarn "Q/A:  Missing rpath for ${path} ; Reason:  (not found)"
			fi
		fi
	done
	IFS=$' \t\n'
}

# @FUNCTION: rocm_verify_rpath_correctness
# @DESCRIPTION:
# Check if we are using the multislot lib paths and not unislot system folders
# for libhsa-runtime64.so and libamdhip64.so.
rocm_verify_rpath_correctness() {
	local source
	if [[ -z "${EROCM_RPATH_SCAN_FOLDER}" ]] ; then
		source="${ED}"
	else
		source="${EROCM_RPATH_SCAN_FOLDER}"
	fi
	IFS=$'\n'
	local rocm_libs=(
		"libamdhip64.so"
		"libhiprtc.so"
		"libhsa-runtime64.so"
		"libhsakmt.so"
		"librdc_bootstrap.so"
		"librocm-dbgapi.so"
		"librocm_smi64.so"
		"librocrand.so"
		"libroctracer64.so"
	)
	local llvm_libs=(
		"libflang.so"
		"libflangrti.so"
		"libLLVMCore.so"
		"libLLVMFrontendOpenMP.so"
		"libLLVMOption.so"
		"libLLVMSupport.so"
		"libLLVMSupport.so.13git"
		"libLLVMSupport.so.14git"
		"libLLVMSupport.so.15git"
		"libLLVMSupport.so.16git"
	)
	local clang_libs=(
		"libclangBasic.so"
		"libclang.so"
		"libclang-cpp.so"
	)
	local libomp_libs=(
		"libomp.so"
	)
	local l
	local path
	for path in $(find "${source}" -type f) ; do
		local is_exe=0
		local is_so=0
		if file "${path}" | grep -q "shared object" ; then
			is_so=1
		elif file "${path}" | grep -q "ELF.*executable" ; then
			is_exe=1
		elif file "${path}" | grep -q "symbolic link" ; then
			continue
		fi

		local _ABI
		if file "${path}" | grep -q "32-bit" && file "${file}" | grep -q "x86-64" ; then
			local _ABI="x32"
		elif file "${path}" | grep -q "x86-64" ; then
			local _ABI="amd64"
		elif file "${path}" | grep -q "80386" ; then
			local _ABI="x86"
		else
			continue
		fi

		local reason_clang=""
		local reason_libomp=""
		local reason_llvm=""
		local reason_rocm=""
		local needs_rpath_patch_clang=0
		local needs_rpath_patch_libomp=0
		local needs_rpath_patch_llvm=0
		local needs_rpath_patch_rocm=0
		if (( ${is_so} || ${is_exe} )) ; then
			for l in "${rocm_libs[@]}" ; do
				if ldd "${path}" 2>/dev/null | grep -q "${l}" ; then
					if ldd "${path}" 2>/dev/null | grep "${l}" | grep -q "/rocm-[0-9]\.[0-9]\.[0-9]/" ; then
						:
					else
						reason_rocm="${l}"
						needs_rpath_patch_rocm=1
					fi
				fi
			done

			if [[ "${ROCM_USE_LLVM_ROC:-1}" == "0" ]] ; then
				:
			else
				for l in "${llvm_libs[@]}" ; do
					if ldd "${path}" 2>/dev/null | grep -q "${l}" ; then
						if ldd "${path}" 2>/dev/null | grep "${l}" | grep -q "/rocm-[0-9]\.[0-9]\.[0-9]/" ; then
							:
						else
							reason_llvm="${l}"
							needs_rpath_patch_llvm=1
						fi
					fi
				done

				for l in "${clang_libs[@]}" ; do
					if ldd "${path}" 2>/dev/null | grep -q "${l}" ; then
						if ldd "${path}" 2>/dev/null | grep "${l}" | grep -q "/rocm-[0-9]\.[0-9]\.[0-9]/" ; then
							:
						else
							reason_clang="${l}"
							needs_rpath_patch_clang=1
						fi
					fi
				done

				for l in "${libomp_libs[@]}" ; do
					if ldd "${path}" 2>/dev/null | grep -q "${l}" ; then
						if ldd "${path}" 2>/dev/null | grep "${l}" | grep -q "/rocm-[0-9]\.[0-9]\.[0-9]/" ; then
							:
						else
							reason_libomp="${l}"
							needs_rpath_patch_libomp=1
						fi
					fi
				done
			fi

			if [[ "${ROCM_USE_LLVM_ROC:-1}" == "0" ]] ; then
				for l in "${llvm_libs[@]}" ; do
					if ldd "${path}" 2>/dev/null | grep -q "${l}" ; then
						if ldd "${path}" 2>/dev/null | grep "${l}" | grep -q "lib/llvm" ; then
							:
						else
							reason_llvm="${l}"
							needs_rpath_patch_llvm=1
						fi
					fi
				done

				for l in "${clang_libs[@]}" ; do
					if ldd "${path}" 2>/dev/null | grep -q "${l}" ; then
						if ldd "${path}" 2>/dev/null | grep "${l}" | grep -q "lib/llvm" ; then
							:
						else
							reason_clang="${l}"
							needs_rpath_patch_clang=1
						fi
					fi
				done

				for l in "${libomp_libs[@]}" ; do
					if ldd "${path}" 2>/dev/null | grep -q "${l}" ; then
						if ldd "${path}" 2>/dev/null | grep "${l}" | grep -q "lib/llvm" ; then
							:
						else
							reason_libomp="${l}"
							needs_rpath_patch_libomp=1
						fi
					fi
				done
			fi

		fi

		if (( ${needs_rpath_patch_rocm} )) ; then
			if [[ "${EROCM_RPATH_SCAN_FATAL}" == "1" ]] ; then
				# Use 1 in src_install
				die "Q/A:  Missing rpath for ${path} (rocm)"
			else
				# Use 0 or unset in pkg_postinst
				ewarn "Q/A:  Missing rpath for ${path} (rocm)"
			fi
		fi

		if (( ${needs_rpath_patch_llvm} )) ; then
			if [[ "${EROCM_RPATH_SCAN_FATAL}" == "1" ]] ; then
				# Use 1 in src_install
				die "Q/A:  Missing rpath for ${path} (llvm)"
			else
				# Use 0 or unset in pkg_postinst
				ewarn "Q/A:  Missing rpath for ${path} (llvm)"
			fi
		fi

		if (( ${needs_rpath_patch_clang} )) ; then
			if [[ "${EROCM_RPATH_SCAN_FATAL}" == "1" ]] ; then
				# Use 1 in src_install
				die "Q/A:  Missing rpath for ${path} (clang)"
			else
				# Use 0 or unset in pkg_postinst
				ewarn "Q/A:  Missing rpath for ${path} (clang)"
			fi
		fi

		if (( ${needs_rpath_patch_libomp} )) ; then
			if [[ "${EROCM_RPATH_SCAN_FATAL}" == "1" ]] ; then
				# Use 1 in src_install
				die "Q/A:  Missing rpath for ${path} (libomp)"
			else
				# Use 0 or unset in pkg_postinst
				ewarn "Q/A:  Missing rpath for ${path} (libomp)"
			fi
		fi

		if (( ${is_so} || ${is_exe} )) && ldd "${path}" 2>/dev/null | grep -q "not found" ; then
			if [[ "${EROCM_RPATH_SCAN_FATAL}" == "1" ]] ; then
				# Use 1 in src_install
				die "Q/A:  Missing rpath for ${path} ; Reason:  (not found)"
			else
				# Use 0 or unset in pkg_postinst
				ewarn "Q/A:  Missing rpath for ${path} ; Reason:  (not found)"
			fi
		fi
	done
	IFS=$' \t\n'
}

# @FUNCTION: rocm_get_libomp_path
# @DESCRIPTION:
# Gets the abspath to libomp.so*.
rocm_get_libomp_path() {
	local libomp_path
	if [[ "${ROCM_USE_LLVM_ROC:-1}" == "0" ]] ; then
		# Stable API, slotted
		libomp_path="${ESYSROOT}/${EROCM_LLVM_PATH}/$(get_libdir)/libomp.so.${LLVM_SLOT}"
	else
		# The suffix allows us to resolve the ambiguousness.
		if [[ -e "${ESYSROOT}/${EROCM_LLVM_PATH}/$(rocm_get_libdir)/libomp.so.${LLVM_SLOT}roc" ]] ; then
			libomp_path="${ESYSROOT}/${EROCM_LLVM_PATH}/$(rocm_get_libdir)/libomp.so.${LLVM_SLOT}roc"
		elif [[ -e "${ESYSROOT}/${EROCM_LLVM_PATH}/$(rocm_get_libdir)/libomp.so.${LLVM_SLOT}git" ]] ; then
			# May require RPATH
			# Unstable API, slotted
			libomp_path="${ESYSROOT}/${EROCM_LLVM_PATH}/$(rocm_get_libdir)/libomp.so.${LLVM_SLOT}git"
		elif [[ -e "${ESYSROOT}/${EROCM_LLVM_PATH}/$(rocm_get_libdir)/libomp.so.${LLVM_SLOT}" ]] ; then
			# Requires RPATH
			# Stable API, slotted
			libomp_path="${ESYSROOT}/${EROCM_LLVM_PATH}/$(rocm_get_libdir)/libomp.so.${LLVM_SLOT}"
		else
			# Requires RPATH
			libomp_path="${ESYSROOT}/${EROCM_LLVM_PATH}/$(rocm_get_libdir)/libomp.so"
		fi
	fi
	echo "${libomp_path}"
}

# @FUNCTION: rocm_set_default_gcc
# @DESCRIPTION:
# Sets compiler defaults to gcc to avoid versioned C++ linking errors.
rocm_set_default_gcc() {
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CC} -E"
	strip-unsupported-flags
	filter-flags '-fuse-ld=*'
	append-ldflags -fuse-ld=bfd
}

# @FUNCTION: rocm_set_default_clang
# @DESCRIPTION:
# Sets compiler defaults to clang to avoid primarily linker errors.
rocm_set_default_clang() {
	local _llvm_slot="HIP_${ROCM_SLOT/./_}_LLVM_SLOT"
	llvm_slot="${!_llvm_slot}"
	export CC="${CHOST}-clang-${llvm_slot}"
	export CXX="${CHOST}-clang++-${llvm_slot}"
	export CPP="${CC} -E"
	strip-unsupported-flags
	filter-flags '-fuse-ld=*'
	append-ldflags -fuse-ld=lld
}

# @FUNCTION: rocm_set_default_aocc
# @DESCRIPTION:
# Sets compiler defaults to aocc to avoid primarily linker errors.
rocm_set_default_aocc() {
	export PATH="${ESYSROOT}/opt/rocm-${ROCM_VERSION}/lib/llvm/alt/bin:${PATH}"
	local _llvm_slot="AOCC_${ROCM_SLOT/./_}_SLOT"
	llvm_slot="${!_llvm_slot}"
	export CC="${CHOST}-clang-${llvm_slot}"
	export CXX="${CHOST}-clang++-${llvm_slot}"
	export CPP="${CC} -E"
	strip-unsupported-flags
	filter-flags '-fuse-ld=*'
	append-ldflags -fuse-ld=lld
	export _USE_AOCC=1
	filter-lto
}

# @FUNCTION: rocm_set_default_hipcc
# @DESCRIPTION:
# Sets compiler defaults for hipcc.
rocm_set_default_hipcc() {
	export CC="hipcc"
	export CXX="hipcc"
#	export CPP="${CC} -E"
	strip-unsupported-flags
	if has cuda ${IUSE_EFFECTIVE} && use cuda ; then
		# Limited by HIPIFY.  See _rocm_set_globals_default()
		local s
		if has_version "=dev-util/nvidia-cuda-toolkit-12.6*" && has_version "=sys-devel/gcc-13" ; then
			s="13"
		elif has_version "=dev-util/nvidia-cuda-toolkit-12.5*" && has_version "=sys-devel/gcc-13" ; then
			s="13"
		else
eerror
eerror "Your CUDA version not supported.  The CUDA pairing must be the following:"
eerror
eerror "For HIP 6.3, =dev-util/nvidia-cuda-toolkit-12.6 with sys-devel/gcc-13"
eerror "For HIP 6.2, =dev-util/nvidia-cuda-toolkit-12.5 with sys-devel/gcc-13"
eerror
			die
		fi

		unset CPP
		# It should use nvcc.
		strip-flags
		filter-flags \
			-pipe \
			-Wl,-O1 \
			-Wl,--as-needed \
			-Wno-unknown-pragmas
		filter-flags '-fuse-ld=*'
		append-ldflags -fuse-ld=bfd
		append-cxxflags -ccbin "${EPREFIX}/usr/${CHOST}/gcc-bin/${s}/${CHOST}-g++"
	else
		export CPP="${CC} -E"
		strip-unsupported-flags
		filter-flags '-fuse-ld=*'
		append-ldflags -fuse-ld=lld
	fi
	filter-lto
}

# @FUNCTION: hip_nvcc_get_gcc_slot
# @DESCRIPTION:
# Gets the gcc slot for cuda builds needed for fopenmp or DEPENDs with gcc.
hip_nvcc_get_gcc_slot() {
	if has_version "=dev-util/nvidia-cuda-toolkit-11.8*" ; then
		echo "11"
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.5*" ; then
		echo "11"
	fi
}

# @FUNCTION: rocm_verify_glibcxx
# @DESCRIPTION:
# Verify the list of libraries are built with a lower glibcxx version.
rocm_verify_glibcxx() {
	# It breaks if _GLIBCXX_VER is global.
	declare -A _GLIBCXX_VER=(
	# See https://gcc.gnu.org/onlinedocs/libstdc++/manual/abi.html
		# ["$GLIBCXX"]=$GCC_PV
		['GLIBCXX_3_4_33']="14.1.0"
		['GLIBCXX_3_4_32']="13.2.0"
		['GLIBCXX_3_4_31']="13.1.0"
		['GLIBCXX_3_4_30']="12.1.0"
		['GLIBCXX_3_4_29']="11.1.0"
		['GLIBCXX_3_4_28']="10.1.0"
		['GLIBCXX_3_4_27']="9.2.0"
		['GLIBCXX_3_4_26']="9.1.0"
		['GLIBCXX_3_4_25']="8.1.0"
		['GLIBCXX_3_4_24']="7.2.0"
		['GLIBCXX_3_4_23']="7.1.0"
		['GLIBCXX_3_4_22']="6.1.0"
		['GLIBCXX_3_4_21']="5.1.0"
		['GLIBCXX_3_4_20']="4.9.0"
		['GLIBCXX_3_4_19']="4.8.3"
		['GLIBCXX_3_4_18']="4.8.0"
		['GLIBCXX_3_4_17']="4.7.0"
		['GLIBCXX_3_4_16']="4.6.1"
		['GLIBCXX_3_4_15']="4.6.0"
		['GLIBCXX_3_4_14']="4.5.0"
		['GLIBCXX_3_4_13']="4.4.2"
		['GLIBCXX_3_4_12']="4.4.1"
		['GLIBCXX_3_4_11']="4.4.0"
		['GLIBCXX_3_4_10']="4.3.0"
		['GLIBCXX_3_4_9']="4.2.0"
		['GLIBCXX_3_4_8']="4.1.1"
		['GLIBCXX_3_4_7']="4.0.3"
		['GLIBCXX_3_4_6']="4.0.2"
		['GLIBCXX_3_4_5']="4.0.1"
		['GLIBCXX_3_4_4']="4.0.0"
		['GLIBCXX_3_4_3']="3.4.3"
		['GLIBCXX_3_4_2']="3.4.2"
		['GLIBCXX_3_4_1']="3.4.1"
		['GLIBCXX_3_4_0']="3.4"
		['GLIBCXX_3_2_3']="3.3.3"
		['GLIBCXX_3_2_2']="3.3.0"
		['GLIBCXX_3_2_1']="3.2.1"
		['GLIBCXX_3_2']="3.2.0"
		['GLIBCXX_3_1']="3.1.1"
	)

	if [[ -z "${ROCM_PATH}" ]] ; then
eerror "QA:  Call rocm_pkg_setup() before calling rocm_verify_glibcxx()"
		die
	fi

einfo "Verifying libstdc++ version symbol compatibility for ROCm ${ROCM_VERSION}"
	local glibcxx_ver="${1}" # maximum
	shift
	local libs=( $@ )

	# Problem:  Avoid version symbols error:
	# ld: /opt/rocm-6.1.2/lib/librocblas.so: undefined reference to `std::ios_base_library_init()@GLIBCXX_3.4.32'
	# It happens when the questioned library is built with a newer version.
	local _lib
	for _lib in ${libs[@]} ; do
		local lib="${_lib%:*}"
		local pkg="${_lib#*:}"
		if ! [[ -e "${ROCM_PATH}/lib/lib${lib}.so" ]] ; then
ewarn "Missing ${ROCM_PATH}/lib/lib${lib}.so"
			die
		fi
		if ! strings "${ROCM_PATH}/lib/lib${lib}.so" | grep -q -e "^GLIBCXX" ; then
ewarn "QA:  Remove ${lib} arg from rocm_verify_glibcxx"
			continue
		fi
		local lib_glibcxx_ver=$(strings "${ROCM_PATH}/lib/lib${lib}.so" \
			| grep -e "^GLIBCXX" \
			| sort -V \
			| tail -n 1 \
			| cut -f 2 -d "_")
		if ver_test ${lib_glibcxx_ver} -gt ${glibcxx_ver} ; then
			local gcc_pv="${_GLIBCXX_VER[GLIBCXX_${glibcxx_ver//./_}]}"
			local gcc_slot="${gcc_pv%%.*}"
eerror
eerror "Detected missing versioned symbol."
eerror "Rebuild ${ROCM_PATH}/lib/lib${lib}.so with GCC ${gcc_pv} or less"
eerror
eerror "Actual GLIBCXX version:  ${lib_glibcxx_ver}, GCC ${_GLIBCXX_VER[GLIBCXX_${lib_glibcxx_ver//./_}]}"
eerror "Expected GLIBCXX version:  ${glibcxx_ver}, GCC ${gcc_pv}"
eerror
eerror "Do the following to switch and rebuild:"
eerror
eerror "  eselect gcc set ${CHOST}-${gcc_slot}"
eerror "  source /etc/profile"
eerror "  emerge -1vO ${pkg}:${ROCM_SLOT}"
eerror
			die
		else
einfo "${lib} PASSED"
		fi
	done
}

#Do it manually
#EXPORT_FUNCTIONS pkg_setup src_prepare

fi
