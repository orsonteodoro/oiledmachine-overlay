# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cuda.eclass
# @MAINTAINER:
# Gentoo Science Project <sci@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Common functions for cuda packages
# @DESCRIPTION:
# This eclass contains functions to be used with cuda package. Currently it is
# setting and/or sanitizing NVCCFLAGS, the compiler flags for nvcc. This is
# automatically done and exported in src_prepare() or manually by calling
# cuda_sanitize.
# @EXAMPLE:
# inherit cuda

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_CUDA_ECLASS} ]]; then
_CUDA_ECLASS=1

inherit flag-o-matic toolchain-funcs

# @ECLASS_VARIABLE: NVCCFLAGS
# @DESCRIPTION:
# nvcc compiler flags (see nvcc --help), which should be used like
# CFLAGS for c compiler
: "${NVCCFLAGS:=-O2}"

# @ECLASS_VARIABLE: CUDA_VERBOSE
# @DESCRIPTION:
# Being verbose during compilation to see underlying commands
: "${CUDA_VERBOSE:=true}"

# @FUNCTION: cuda_gccdir
# @USAGE: [-f]
# @RETURN: gcc bindir compatible with current cuda, optionally (-f) prefixed with "--compiler-bindir "
# @DESCRIPTION:
# Helper for determination of the latest gcc bindir supported by
# then current nvidia cuda toolkit.
#
# Example:
# @CODE
# cuda_gccdir -f
# -> --compiler-bindir "/usr/x86_64-pc-linux-gnu/gcc-bin/4.6.3"
# @CODE
cuda_gccdir() {
	debug-print-function ${FUNCNAME} "$@"

	local dirs gcc_bindir ver vers="" flag

	# Currently we only support the gnu compiler suite
	if ! tc-is-gcc ; then
		ewarn "Currently we only support the gnu compiler suite"
		return 2
	fi

	while [[ "$1" ]]; do
		case $1 in
			-f)
				flag="--compiler-bindir "
				;;
			*)
				;;
		esac
		shift
	done

	if ! vers="$(cuda-config -s)"; then
		eerror "Could not execute cuda-config"
		eerror "Make sure >=dev-util/nvidia-cuda-toolkit-4.2.9-r1 is installed"
		die "cuda-config not found"
	fi
	if [[ -z ${vers} ]]; then
		die "Could not determine supported gcc versions from cuda-config"
	fi

	# Try the current gcc version first
	ver=$(gcc-version)
	if [[ -n "${ver}" ]] && [[ ${vers} =~ ${ver} ]]; then
		dirs=( "${EPREFIX}"/usr/*pc-linux-gnu/gcc-bin/${ver%.*}*/ )
		gcc_bindir="${dirs[${#dirs[@]}-1]}"
	fi

	if [[ -z ${gcc_bindir} ]]; then
		ver=$(best_version "sys-devel/gcc")
		ver=$(ver_cut 1-2 "${ver##*sys-devel/gcc-}")

		if [[ -n "${ver}" ]] && [[ ${vers} =~ ${ver} ]]; then
			dirs=( "${EPREFIX}"/usr/*pc-linux-gnu/gcc-bin/${ver%.*}*/ )
			gcc_bindir="${dirs[${#dirs[@]}-1]}"
		fi
	fi

	for ver in ${vers}; do
		if has_version "=sys-devel/gcc-${ver}*"; then
			dirs=( "${EPREFIX}"/usr/*pc-linux-gnu/gcc-bin/${ver%.*}*/ )
			gcc_bindir="${dirs[${#dirs[@]}-1]}"
		fi
	done

	if [[ -n ${gcc_bindir} ]]; then
		if [[ -n ${flag} ]]; then
			echo "${flag}\"${gcc_bindir%/}\""
		else
			echo "${gcc_bindir%/}"
		fi
		return 0
	else
		eerror "Only gcc version(s) ${vers} are supported,"
		eerror "of which none is installed"
		die "Only gcc version(s) ${vers} are supported"
		return 1
	fi
}

# @FUNCTION: cuda_sanitize
# @DESCRIPTION:
# Correct NVCCFLAGS by adding the necessary reference to gcc bindir and
# passing CXXFLAGS to underlying compiler without disturbing nvcc.
cuda_sanitize() {
	debug-print-function ${FUNCNAME} "$@"

	local rawldflags=$(raw-ldflags)
	# Be verbose if wanted
	[[ "${CUDA_VERBOSE}" == true ]] && NVCCFLAGS+=" -v"

	# Tell nvcc where to find a compatible compiler
	NVCCFLAGS+=" $(cuda_gccdir -f)"

	# Tell nvcc which flags should be used for underlying C compiler
	NVCCFLAGS+=" --compiler-options \"${CXXFLAGS}\" --linker-options \"${rawldflags// /,}\""

	debug-print "Using ${NVCCFLAGS} for cuda"
	export NVCCFLAGS
}

# @FUNCTION: cuda_add_sandbox
# @USAGE: [-w]
# @DESCRIPTION:
# Add nvidia dev nodes to the sandbox predict list.
# with -w, add to the sandbox write list.
cuda_add_sandbox() {
	debug-print-function ${FUNCNAME} "$@"

	local i
	for i in /dev/nvidia*; do
		if [[ $1 == '-w' ]]; then
			addwrite $i
		else
			addpredict $i
		fi
	done
	if [[ $1 == '-w' ]]; then
		addwrite /proc/self/task
	else
		addpredict /proc/self/task
	fi
}

# @FUNCTION: cuda_toolkit_version
# @DESCRIPTION:
# echo the installed version of dev-util/nvidia-cuda-toolkit
cuda_toolkit_version() {
	debug-print-function ${FUNCNAME} "$@"

	local v
	v="$(best_version dev-util/nvidia-cuda-toolkit)"
	v="${v##*cuda-toolkit-}"
	ver_cut 1-2 "${v}"
}

# @FUNCTION: cuda_cudnn_version
# @DESCRIPTION:
# echo the installed version of dev-libs/cudnn
cuda_cudnn_version() {
	debug-print-function ${FUNCNAME} "$@"

	local v
	v="$(best_version dev-libs/cudnn)"
	v="${v##*cudnn-}"
	ver_cut 1-2 "${v}"
}

# @FUNCTION: cuda_src_prepare
# @DESCRIPTION:
# Sanitise and export NVCCFLAGS by default
cuda_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	cuda_sanitize
}

get_cuda_targets() {
	if [[ -z "${CUDA_TARGETS}" ]] ; then
eerror
eerror "To reduce the number of GPU kernels built and to complete the build in"
eerror "practical time, CUDA_TARGETS must be set."
eerror
eerror "You must specify semicolon separated list in CUDA_TARGETS in"
eerror "/etc/portage/make.conf or as per-package environment variables."
eerror
eerror
eerror "Sample contents of /etc/portage/env/cuda.conf:"
eerror
eerror "# Pick a row to add:"
eerror "CUDA_TARGETS=\"auto\""
eerror "CUDA_TARGETS=\"sm_75;sm_90\""
eerror "CUDA_TARGETS=\"sm_90\""
eerror
eerror
eerror "Contents of /etc/portage/package.env:"
eerror
eerror "${CATEGORY}/${PN} cuda.conf"
eerror
		die
	fi

	local L=()
	local _L=()
	if [[ "${CUDA_TARGETS}" =~ "auto" ]] ; then
		if has_version "=dev-util/nvidia-cuda-toolkit-13" ; then
			_L=(
				50 52 53		# Maxwell
				60 61 62		# Pascal
				70 72			# Volta
				75			# Turing
				80 86 87 88		# Ampere
				89			# Ada Lovelace
				90			# Hopper
				100 101 103 120 121	# Blackwell & Thor
			)
			L=(
				${_L[@]/#/sm_}
			)
		elif has_version "=dev-util/nvidia-cuda-toolkit-12" ; then
			_L=(
				75			# Turing
				80 86 87 88		# Ampere
				89			# Ada Lovelace
				90			# Hopper
				100 110 103 120 121	# Blackwell & Thor
				107			# Rubin
			)
			L=(
				${_L[@]/#/sm_}
			)
		else
eerror "dev-util/nvidia-cuda-toolkit not installed"
			die
		fi
	else
		IFS=';' read -ra L <<< "${CUDA_TARGETS}"
	fi

	# Loop through the array to verify
	for item in "${L[@]}"; do
		echo "${item}"
	done
}

fi

EXPORT_FUNCTIONS src_prepare
