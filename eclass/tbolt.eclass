# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: tbolt.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: three step bolt support
# @DESCRIPTION:
# Deploy bolt support for select ebuilds

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_TBOLT_ECLASS} ]] ; then
_TBOLT_ECLASS=1

inherit flag-o-matic linux-info toolchain-funcs

IUSE+=" bolt"
RESTRICT+=" strip" # Don't strip at all

# @ECLASS_VARIABLE: UOPTS_BOLT_DISABLE_BDEPEND
# @DESCRIPTION:
# Disable BDEPEND to avoid possible circular dependency

if [[ "${UOPTS_BOLT_DISABLE_BDEPEND}" != "1" ]] ; then
BDEPEND+="
	bolt? (
		|| (
			>=llvm-core/llvm-19:19[bolt]
			>=llvm-core/llvm-18:18[bolt]
			>=llvm-core/llvm-17:17[bolt]
			>=llvm-core/llvm-16:16[bolt]
			>=llvm-core/llvm-15:15[bolt]
			>=llvm-core/llvm-14:14[bolt]
		)
	)
"
fi

# @ECLASS_VARIABLE: UOPTS_BOLT_EXCLUDE_BINS
# @DESCRIPTION:
# A space separated list of basenames executables or shared libraries not to
# instrument.

# @ECLASS_VARIABLE: UOPTS_BOLT_PROFILES_DIR
# @DESCRIPTION:
# Sets the location to dump BOLT profiles.
UOPTS_BOLT_PROFILES_DIR=${UOPTS_BOLT_PROFILES_DIR:-"/var/lib/bolt-profiles"}

# @ECLASS_VARIABLE: _UOPTS_SLOT
# @INTERNAL
# @DESCRIPTION:
# Default PV with breaking changes when bumped.
_UOPTS_SLOT=$(ver_cut 1-2 ${PV}) # default

# @ECLASS_VARIABLE: UOPTS_SLOT
# @DESCRIPTION:
# Set to the PV range which can cause breakage when bumped.  Excludes non
# breaking patch versions.
UOPTS_SLOT=${UOPTS_SLOT:-${_UOPTS_SLOT}}

# @ECLASS_VARIABLE: _UOPTS_BOLT_CATPN_DATA_DIR
# @INTERNAL
# @DESCRIPTION:
# The path to the program BOLT profile with general package id specificity.
_UOPTS_BOLT_CATPN_DATA_DIR=${_UOPTS_BOLT_CATPN_DATA_DIR:-"${UOPTS_BOLT_PROFILES_DIR}/${CATEGORY}/${PN}"}

# @ECLASS_VARIABLE: _UOPTS_BOLT_DATA_DIR
# @INTERNAL
# @DESCRIPTION:
# The path to the program BOLT profile with version specificity.
_UOPTS_BOLT_DATA_DIR=${_UOPTS_BOLT_DATA_DIR:-"${UOPTS_BOLT_PROFILES_DIR}/${CATEGORY}/${PN}/${UOPTS_SLOT}"}

# @ECLASS_VARIABLE: UOPTS_BOLT_EXCLUDE_FLAGS
# @DESCRIPTION:
# An array of llvm-bolt flags to filter out.

# @ECLASS_VARIABLE: UOPTS_BOLT_FORK_MULTIPLIER
# @USER_VARIABLE
# @DESCRIPTION:
# A multiplier m in forks=m*ncpus for parallel loop processing.  Increasing may
# increase utilization or wasted resources.  This can be a decimal (ex. 0.5).
# Each llvm-bolt is 2G per process.

# @ECLASS_VARIABLE: UOPTS_BOLT_HUGIFY
# @USER_VARIABLE
# @DESCRIPTION:
# The user can decide to enable hugify support.
# Optimize large (>=2MB) linked programs/libraries to reduce iTLB misses.
# Note PREEMPT_RT is incompatible with hugify support.

# @ECLASS_VARIABLE: UOPTS_BOLT_HUGIFY_SIZE
# @DESCRIPTION:
# Set the threshold for .so/exe size to apply -hugify to avoid wasting page space.
# Default setting - If the library or executable is orders of magnitude larger,
# suggest hugepage (2 MiB) support.  It is not clear when the benefits start to
# actually happen.
#UOPTS_BOLT_HUGIFY_SIZE=${UOPTS_BOLT_HUGIFY_SIZE:-1073741824} # 1 GiB for production
UOPTS_BOLT_HUGIFY_SIZE=${UOPTS_BOLT_HUGIFY_SIZE:-20971520} # 20 MiB for testing

# @ECLASS_VARIABLE: UOPTS_BOLT_PATH
# @DESCRIPTION:
# The absolute path to the folder containing llvm-bolt.

# @ECLASS_VARIABLE: _UOPTS_BOLT_PATH
# @INTERNAL
# @DESCRIPTION:
# Allow disjointed PATH to llvm-bolt while respecting LLVM_MAX_SLOT
_UOPTS_BOLT_PATH="" # Set in tbolt_setup

# @ECLASS_VARIABLE: UOPTS_BOLT_SCAN_EXTRA_EXPRESSIONS
# @DESCRIPTION:
# Add extra find expressions for instrumentation.
# Example:
# UOPTS_BOLT_SCAN_EXTRA_EXPRESSIONS=(
#	-o -name "libfoo.so.1"
#	-o -name "libbar.so.2"
#	-o -name "hello_world"
# )

# @ECLASS_VARIABLE: UOPTS_BOLT_SLOT
# @DESCRIPTION:
# Force a particular LLVM slot for llvm-slot.  This is for compatiblity for BOLT profiles.
# The preference is auto selection to the highest enabled.

# @ECLASS_VARIABLE: UOPTS_BOLT_OPTIMIZATIONS
# @USER_VARIABLE
# @DESCRIPTION:
# Allow to override the default BOLT optimization setting.

# @ECLASS_VARIABLE: BOLTFLAGS
# @USER_VARIABLE
# @DESCRIPTION:
# Analog to CFLAGS with the same requirements as UOPTS_BOLT_OPTIMIZATIONS.

# @ECLASS_VARIABLE: UOPTS_BOLT_MALLOC
# @DESCRIPTION:
# Chooses the preferred malloc

#
# Acceptable values:
#
#   auto - auto detect
#   jemalloc - want jemalloc
#   none - don't use one of these
#   tcmalloc - want tcmalloc
#   tcmalloc-minimal - want tcmalloc
#   unset - auto detection fallback
#

# @ECLASS_VARIABLE: UOPTS_BOLT_FORCE_INST
# @DESCRIPTION:
# Temporarily set to 1 to build with instrument flags.
# Only the user can decide.  Do not set it in the ebuild.
# Example:
# UOPTS_BOLT_FORCE_INST=1 emerge foo

# @ECLASS_VARIABLE: UOPTS_BOLT_INST_ARGS
# @DESCRIPTION:
# Extra instrumentation args to pass to basename.  Extra args are separated by
# semicolon.
# Example:
# UOPTS_BOLT_INST_ARGS=(
#	"libjpeg.so.62.3.0:--skip-funcs=.text/1"
#	"libturbojpeg.so.0.2.0:--skip-funcs=.text/1"
# )

_tbolt_check_bolt() {
	if use bolt ; then
		if ! use kernel_linux ; then
ewarn "The ebuilds only support BOLT for Linux at the moment."
		fi
	fi
}

_setup_malloc() {
	[[ -z "${UOPTS_BOLT_MALLOC}" ]] && UOPTS_BOLT_MALLOC="auto"

	if [[ \
		-e "${ESYSROOT}/usr/$(get_libdir ${DEFAULT_ABI})/libtcmalloc_minimal.so" \
		&& "${UOPTS_BOLT_MALLOC}" =~ ("auto"|"jemalloc-minimal") \
	]] ; then
		export _UOPTS_BOLT_MALLOC_LIB="${ESYSROOT}/usr/$(get_libdir ${DEFAULT_ABI})/libtcmalloc_minimal.so"
	elif [[ \
		-e "${ESYSROOT}/usr/$(get_libdir ${DEFAULT_ABI})/libjemalloc.so" \
		&& "${UOPTS_BOLT_MALLOC}" =~ ("auto"|"jemalloc") \
	]] ; then
		export _UOPTS_BOLT_MALLOC_LIB="${ESYSROOT}/usr/$(get_libdir ${DEFAULT_ABI})/libjemalloc.so"
	elif [[ \
		-e "${ESYSROOT}/usr/$(get_libdir ${DEFAULT_ABI})/libtcmalloc.so" \
		&& "${UOPTS_BOLT_MALLOC}" =~ ("auto"|"tcmalloc") \
	]] ; then
		export _UOPTS_BOLT_MALLOC_LIB="${ESYSROOT}/usr/$(get_libdir ${DEFAULT_ABI})/libtcmalloc.so"
	else
		export _UOPTS_BOLT_MALLOC_LIB=""
	fi
}

# @FUNCTION: _setup_llvm
# @DESCRIPTION:
# Setup PATH for llvm-bolt
_setup_llvm() {
	local s
	if [[ -n "${UOPTS_BOLT_PATH}" ]] ; then
		_UOPTS_BOLT_PATH="${UOPTS_BOLT_PATH}"
	elif [[ -n "${UOPTS_BOLT_SLOT}" ]] ; then
		_UOPTS_BOLT_PATH="${ESYSROOT}/usr/lib/llvm/${UOPTS_BOLT_SLOT}/bin"
	elif [[ -n "${LLVM_SLOT}" ]] ; then
		# uopts_pkg_setup called after llvm_pkg_setup
		s="${LLVM_SLOT}"
		if has_version "llvm-core/llvm:${s}[bolt]" ; then
			_UOPTS_BOLT_PATH="${ESYSROOT}/usr/lib/llvm/${s}/bin"
		fi
	elif [[ -n "${LLVM_COMPAT[0]}" && ${LLVM_COMPAT[0]} -gt ${LLVM_COMPAT[-1]} ]] ; then
		# 17 16 15 14 order
		# This is why we have LLVM_MAX_SLOT.  People can just randomly sort by ascend or descend order.
		for s in $(seq 14 ${LLVM_COMPAT[0]} | tac) ; do
			if has_version "llvm-core/llvm:${s}[bolt]" ; then
				_UOPTS_BOLT_PATH="${ESYSROOT}/usr/lib/llvm/${s}/bin"
				break
			fi
		done
	elif [[ -n "${LLVM_COMPAT[0]}" && ${LLVM_COMPAT[0]} -le ${LLVM_COMPAT[-1]} ]] ; then
		# 14 15 16 17 order
		# This is why we have LLVM_MAX_SLOT.  People can just randomly sort by ascend or descend order.
		for s in $(seq 14 ${LLVM_COMPAT[-1]} | tac) ; do
			if has_version "llvm-core/llvm:${s}[bolt]" ; then
				_UOPTS_BOLT_PATH="${ESYSROOT}/usr/lib/llvm/${s}/bin"
				break
			fi
		done
	elif [[ -n "${LLVM_MAX_SLOT}" ]] ; then
		for s in $(seq 14 ${LLVM_MAX_SLOT} | tac) ; do
			if has_version "llvm-core/llvm:${s}[bolt]" ; then
				_UOPTS_BOLT_PATH="${ESYSROOT}/usr/lib/llvm/${s}/bin"
				break
			fi
		done
	elif [[ -z "${LLVM_MAX_SLOT}" && -z "${LLVM_SLOT}" ]] ; then
		for s in ${_UOPTS_LLVM_SLOTS[@]} ; do
			if has_version "llvm-core/llvm:${s}[bolt]" ; then
				_UOPTS_BOLT_PATH="${ESYSROOT}/usr/lib/llvm/${s}/bin"
				break
			fi
		done
	fi
}

# @FUNCTION: _tbolt_convert_hugify_to_env
# @DESCRIPTION:
# Convert UOPTS_BOLT_OPTIMIZATIONS="-hugify" to flag _UOPTS_USER_WANTS_HUGIFY=1
_tbolt_convert_hugify_to_env() {
	export _UOPTS_USER_WANTS_HUGIFY=0
	local list=()
	local flag
	for flag in ${UOPTS_BOLT_OPTIMIZATIONS} ; do
	# Only apply to targets that qualify to avoid wasted page space.
		if [[ "${flag}" == "-hugify" ]] ; then
			export _UOPTS_USER_WANTS_HUGIFY=1
		else
			list+=( "${flag}" )
		fi
	done
	export UOPTS_BOLT_OPTIMIZATIONS="${list[@]}"
}

# @FUNCTION: filter_boltflags
# @DESCRIPTION:
# Remove banned UOPTS_BOLT_OPTIMIZATIONS
filter_boltflags() {
	local list=()
	local flag
	for flag in ${UOPTS_BOLT_OPTIMIZATIONS} ; do
		if [[ -n "${UOPTS_BOLT_EXCLUDE_FLAGS[@]}" ]] ; then
			local is_banned=0
			local excluded_flag
			for excluded_flag in ${UOPTS_BOLT_EXCLUDE_FLAGS[@]} ; do
				if [[ "${flag}" == "${excluded_flag}" ]] ; then
					is_banned=1
				fi
			done
			if (( ${is_banned} == 0 )) ; then
				list+=( "${flag}" )
			fi
		else
			list+=( "${flag}" )
		fi
	done
	echo "${list[@]}"
}

# @FUNCTION: tbolt_is_boltflag_banned
# @DESCRIPTION:
# Check if a flag is banned
tbolt_is_boltflag_banned() {
	local flag="${1}"
	if [[ -n "${UOPTS_BOLT_EXCLUDE_FLAGS[@]}" ]] ; then
		local excluded_flag
		for excluded_flag in ${UOPTS_BOLT_EXCLUDE_FLAGS[@]} ; do
			if [[ "${flag}" == "${excluded_flag}" ]] ; then
				return 0
			fi
		done
	fi
	return 1
}

# @FUNCTION: tbolt_setup
# @DESCRIPTION:
# You must call this in pkg_setup
tbolt_setup() {
	_tbolt_check_bolt
	_setup_malloc
	train_setup
	subscribe_verify_profile_warn "tbolt_train_verify_profile_warn"
	subscribe_verify_profile_fatal "tbolt_train_verify_profile_fatal"
	_setup_llvm

	# Keep in sync with
	# https://github.com/llvm/llvm-project/blob/main/bolt/README.md?plain=1#L183
	export UOPTS_BOLT_OPTIMIZATIONS=${UOPTS_BOLT_OPTIMIZATIONS:-"-reorder-blocks=ext-tsp -reorder-functions=hfsort -split-functions -split-all-cold -split-eh -dyno-stats"}
	if [[ -n "${BOLTFLAGS}" ]] ; then
		UOPTS_BOLT_OPTIMIZATIONS="${BOLTFLAGS}"
	fi
	if tbolt_is_boltflag_banned "-hugify" ; then
		UOPTS_BOLT_HUGIFY=0
	fi
	UOPTS_BOLT_OPTIMIZATIONS=$(filter_boltflags)
	if [[ "${UOPTS_BOLT_OPTIMIZATIONS}" =~ "-hugify" || "${UOPTS_BOLT_HUGIFY}" == "1" ]] ; then
		linux-info_pkg_setup
		if ! linux_config_exists ; then
ewarn "You must enable CONFIG_TRANSPARENT_HUGEPAGE for BOLT -hugify support."
		else
			if ! linux_chkconfig_builtin "TRANSPARENT_HUGEPAGE" ; then
ewarn "You must enable CONFIG_TRANSPARENT_HUGEPAGE for BOLT -hugify support."
			fi
		fi
	fi

	_tbolt_convert_hugify_to_env

	if [[ -z "${_UOPTS_ECLASS}" ]] ; then
eerror
eerror "The tbolt.eclass must be used with uopts.eclass.  Do not inherit tbolt"
eerror "directly."
eerror
		die
	fi

	UOPTS_BOLT_FORK_MULTIPLIER=${UOPTS_BOLT_FORK_MULTIPLIER:-"0.5"}
}

# @FUNCTION: _tbolt_prepare_bolt
# @INTERNAL
# @DESCRIPTION:
# Copies an existing profile snapshot into build space.
_tbolt_prepare_bolt() {
	local bolt_data_suffix_dir="${EPREFIX}${_UOPTS_BOLT_DATA_DIR}/${_UOPTS_BOLT_SUFFIX}"
	local bolt_data_staging_dir="${T}/bolt-${_UOPTS_BOLT_SUFFIX}"

	mkdir -p "${bolt_data_staging_dir}" || die
	if [[ "${UOPTS_BOLT_FORCE_INST}" == "1" ]] ; then
		:
	elif [[ -e "${bolt_data_suffix_dir}" ]] ; then
		cp -aT "${bolt_data_suffix_dir}" "${bolt_data_staging_dir}" || die
	fi
	touch "${bolt_data_staging_dir}/llvm_bolt_fingerprint" || die
}

# @FUNCTION: tbolt_src_prepare
# @DESCRIPTION:
# You must call this inside the multibuild loop in src_prepare or in a
# *src_prepare multibuild variant.  It has to be inside the loop so that the
# UOPTS_IMPLS can divide the bolt profile per ABI or module.  You must define
# UOPTS_IMPLS to divide BOLT profiles if impl exists for example headless and
# non-headless builds.
tbolt_src_prepare() {
	_UOPTS_BOLT_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${UOPTS_IMPLS}"
	_tbolt_prepare_bolt
}

# @FUNCTION: tbolt_src_prepare
# @DESCRIPTION:
# Applies compiler flags required for proper BOLT support.
tbolt_src_configure() {
	local bolt_data_suffix_dir="${EPREFIX}${_UOPTS_BOLT_DATA_DIR}/${_UOPTS_BOLT_SUFFIX}"
	local bolt_data_staging_dir="${T}/bolt-${_UOPTS_BOLT_SUFFIX}"
	if use bolt ; then
		filter-flags \
			'-f*reorder-blocks-and-partition' \
			'-Wl,--emit-relocs' \
			'-Wl,-q'

		if tc-is-gcc ; then
			append-flags -fno-reorder-blocks-and-partition
			append-ldflags -fno-reorder-blocks-and-partition
		fi
		append-ldflags -Wl,--emit-relocs
	fi
}

# @FUNCTION: _tbolt_get_build_time
# @DESCRIPTION:
# Gets the build time
_tbolt_get_build_time() {
# Same as portageq metadata "/${BROOT}" "installed" "llvm-core/llvm-${raw_pv}" "BUILD_TIME"
	local f="/${BROOT}/var/db/pkg/llvm-core/llvm-${raw_pv}/BUILD_TIME"
	if [[ -e "${f}" ]] ; then
		cat "${f}"
	else
		echo "0"
	fi
}

# @FUNCTION: _tbolt_is_profile_reusable
# @INTERNAL
# @DESCRIPTION:
# Checks if requirements are met
_tbolt_is_profile_reusable() {
	if use bolt ; then
		local bolt_data_staging_dir="${T}/bolt-${_UOPTS_BOLT_SUFFIX}"

		has_version "llvm-core/llvm[bolt]" || return 2

		# Actually, you can use GCC.

		touch "${bolt_data_staging_dir}/llvm_bolt_fingerprint" \
			|| die "You must call uopts_src_prepare before calling tbolt_get_phase"

		if ! tc-is-gcc && ! tc-is-clang ; then
ewarn "Compiler is not supported for TBOLT."
			return 2
		fi

		if [[ -z "${CC}" ]] ; then
			export CC="${CHOST}-gcc"
			export CXX="${CHOST}-g++"
			export CPP="${CC} -E"
		fi

		local bolt_pv=$("${_UOPTS_BOLT_PATH}/llvm-bolt" --version \
			| grep -E -o "[0-9]+\.[0-9]+\.[0-9]+")
		local bolt_major_pv="${bolt_pv%%.*}"
		local raw_pv=$(best_version "=llvm-core/llvm-${bolt_major_pv}*" \
			| sed -e "s|llvm-core/llvm-||g")
		local bolt_slot=$(ver_cut 1-2 "${bolt_pv}") # For stable ABI.
		if [[ "${raw_pv}" =~ "9999" ]] ; then
			# Live with unstable ABI.
			local build_timestamp=$(_tbolt_get_build_time)
			bolt_slot="${raw_pv}-${build_timestamp}"
		elif [[ "${raw_pv}" =~ "_pre" ]] ; then
			# Live snapshot with unstable ABI.
			bolt_slot="${raw_pv}"
		fi
		local triple=$(${CC} -dumpmachine) # For ABI and LIBC consistency.
		if [[ "${triple}" =~ "i386" && "${CC}" =~ "clang" && "${CC}" =~ "x86_64" ]] ; then
	#
	# Fix inconsistency between
	#
	# `x86_64-pc-linux-gnu-clang -m32 -dumpmachine` outputs i386-pc-linux-gnu
	#
	#   and
	#
	# `i686-pc-linux-gnu-clang -m32 -dumpmachine` outputs i686-pc-linux-gnu
	#
			triple="${triple/i386/i686}"
		fi
		local cc_type
		if tc-is-clang ; then
			cc_type="clang"
		elif tc-is-gcc ; then
			cc_type="gcc"
		else
			cc_type="${CC}"
		fi
		local actual="llvm-bolt;${bolt_slot};${cc_type};${MULTILIB_ABI_FLAG}.${ABI};${triple}"
		local expected=$(cat "${bolt_data_staging_dir}/llvm_bolt_fingerprint")
		if [[ "${actual}" != "${expected}" ]] ; then
# This check is done because of BOLT profile compatibility.
ewarn
ewarn "llvm-bolt fingerprint changed:"
ewarn
ewarn "Actual:\t${actual}"
ewarn "Expected:\t${expected}"
ewarn
			return 1
		fi

		# Has profile?
		local list=(
			$(find "${bolt_data_staging_dir}" -name "*.fdata")
		)
		local n_lines=${#list[@]}
		if (( ${n_lines} > 0 )) ; then
			: # pass
		else
ewarn "NO BOLT PROFILE FOR ABI == ${ABI}"
			return 1
		fi

		return 0
	fi
	return 1
}

# @FUNCTION: __get_nprocs
# @INTERNAL
# @DESCRIPTION:
# Gets the number N from -jN defined by MAKEOPTS.
__get_nprocs() {
	local nprocs=$(echo "${MAKEOPTS}" \
		| grep -E -e "-j[ ]*[0-9]+" \
		| grep -E -o -e "[0-9]+")
	[[ -z "${nprocs}" ]] && nprocs=1
	echo "${nprocs}"
}

# @FUNCTION: _tbolt_inst_tree
# @INTERNAL
# @DESCRIPTION:
# Instruments a tree
_tbolt_inst_tree() {
	[[ "${BOLT_PHASE}" == "INST" ]] || return
	local tree="${1}"
	local bolt_data_staging_dir="${T}/bolt-${_UOPTS_BOLT_SUFFIX}"
	local file_list=(
		$(find "${tree}" \
			-type f \
			-executable \
			-not -type l \
			${UOPTS_BOLT_SCAN_EXTRA_EXPRESSIONS[@]} \
		)
	)
	local n_files=${#file_list[@]}
	local x_files=0
ewarn "Finding binaries to BOLT.  Please wait..."
ewarn "Number of files to scan:  ${n_files}"
ewarn "Scanning ${tree}"
	local n_cores=$(__get_nprocs)
	local n_procs
	n_procs=$(python -c "print(int(${n_cores} * ${UOPTS_BOLT_FORK_MULTIPLIER}))")
	(( "${n_procs}" <= 0 )) && n_procs=1
	local job_list
	local n_jobs
	local p
	for p in ${file_list[@]} ; do
		x_files=$((${x_files} + 1))
		if (( $(($(date +%s) % 15)) == 0 )) ; then
einfo "Progress: ${x_files}/${n_files} ("$(python -c "print(${x_files}/${n_files}*100)")"%)"
		fi
		(
			local bn=$(basename "${p}")
			local is_boltable=0
			local file_output=$(file "${p}")
			if [[ "${file_output}" =~ "ELF".*"executable" ]] && is_file_boltable "${p}" ; then
				is_boltable=1
			elif [[ "${file_output}" =~ "ELF".*"shared object" ]] && is_file_boltable "${p}" ; then
				is_boltable=1
			else
				is_boltable=0
			fi
	# Try to avoid disk access which is a big penalty.
			if (( ${is_boltable} == 1 )) && is_bolt_banned "${bn}" ; then
				is_boltable=0
			fi
			if (( ${is_boltable} == 1 )) && is_abi_same "${p}" ; then
				:
			else
				is_boltable=0
			fi
			if (( ${is_boltable} == 1 )) && is_stripped "${p}" ; then
ewarn "The package has prestripped binaries.  Re-emerge with FEATURES=\"\${FEATURES} nostrip\" or patch.  Skipping ${p}"
				is_boltable=0
			fi
			if (( ${is_boltable} == 1 )) && ! has_relocs "${p}" ; then
ewarn "Skipping ${p} because of missing .rela.text section"
				is_boltable=0
			fi
			if (( ${is_boltable} == 1 )) ; then
				local size=$(stat -c "%s" "${p}")
				# See also https://github.com/llvm/llvm-project/blob/main/bolt/lib/Passes/Instrumentation.cpp#L28
				if [[ ! -e "${p}.orig" ]] ; then
					mv "${p}"{,.orig} || die
				else
ewarn "${p}.orig existed and BUILD_DIR was not completely wiped."
				fi
einfo "Instrumenting ${p} with BOLT"
				local extra_args=()
				local arg
				for arg in ${UOPTS_BOLT_INST_ARGS[@]} ; do
					local bn=$(basename "${p}")
					local fn="${arg%%:*}"
					local raw_args="${arg##*:}"
					if [[ "${fn}" =~ "${bn}" ]] ; then
						local t_args=(
							$(echo "${raw_args}" | tr ";" "\n")
						)
						local x_arg
						for x_arg in ${t_args[@]} ; do
							extra_args+=(
								${x_arg}
							)
						done
					fi
				done

#einfo "DEBUG:  LD_PRELOAD=\"${_UOPTS_BOLT_MALLOC_LIB}\" ${_UOPTS_BOLT_PATH}/llvm-bolt \"${p}.orig\" -instrument -o \"${p}\" -instrumentation-file \"${bolt_data_staging_dir}/${bn}.fdata\" ${extra_args[@]}"
				LD_PRELOAD="${_UOPTS_BOLT_MALLOC_LIB}" "${_UOPTS_BOLT_PATH}/llvm-bolt" \
					"${p}.orig" \
					-instrument \
					-o "${p}" \
					-instrumentation-file "${bolt_data_staging_dir}/${bn}.fdata" \
					${extra_args[@]} \
					|| die
			fi
		) &
	# `wait -n` can only be used with unicore or MAKEOPTS="-j1".
	# busy-wait should be used with multicore or MAKEOPTS="-j2" or higher.
		job_list=( $(jobs -r -p) )
		while (( ${#job_list[@]} >= ${n_procs} )) ; do
			sleep 0.1
			job_list=( $(jobs -r -p) )
		done
	done
	job_list=( $(jobs -r -p) )
	while (( ${#job_list[@]} >= 1 )) ; do
		sleep 0.1
		job_list=( $(jobs -r -p) )
	done
}

# @FUNCTION: _tbolt_opt_tree
# @INTERNAL
# @DESCRIPTION:
# Optimizes a tree
_tbolt_opt_tree() {
	[[ "${BOLT_PHASE}" == "OPT" ]] || return
	local tree="${1}"
	local bolt_data_staging_dir="${T}/bolt-${_UOPTS_BOLT_SUFFIX}"
	local file_list=(
		$(find "${tree}" \
			-type f \
			-executable \
			-not -type l \
			${UOPTS_BOLT_SCAN_EXTRA_EXPRESSIONS[@]} \
		)
	)
	local n_files=${#file_list[@]}
	local x_files=0
ewarn "Finding binaries to BOLT.  Please wait..."
ewarn "Number of files to scan:  ${n_files}"
ewarn "Scanning ${tree}"
	local n_cores=$(__get_nprocs)
	local n_procs
	n_procs=$(python -c "print(int(${n_cores} * ${UOPTS_BOLT_FORK_MULTIPLIER}))")
	(( "${n_procs}" <= 0 )) && n_procs=1
	local job_list
	local n_jobs
	local p
	for p in ${file_list[@]} ; do
		x_files=$((${x_files} + 1))
		if (( $(($(date +%s) % 15)) == 0 )) ; then
einfo "Progress: ${x_files}/${n_files} ("$(python -c "print(${x_files}/${n_files}*100)")"%)"
		fi
		(
			local bn=$(basename "${p}")
			local is_boltable=0
			local file_output=$(file "${p}")
			if [[ "${file_output}" =~ "ELF".*"executable" ]] && is_file_boltable "${p}" ; then
				is_boltable=1
			elif [[ "${file_output}" =~ "ELF".*"shared object" ]] && is_file_boltable "${p}" ; then
				is_boltable=1
			else
				is_boltable=0
			fi
	# Try to avoid disk access which is a big penalty.
			if (( ${is_boltable} == 1 )) && is_bolt_banned "${bn}" ; then
				is_boltable=0
			fi
			if (( ${is_boltable} == 1 )) && is_abi_same "${p}" ; then
				:
			else
				is_boltable=0
			fi
			if (( ${is_boltable} == 1 )) && is_stripped "${p}" ; then
ewarn "The package has prestripped binaries.  Re-emerge with FEATURES=\"\${FEATURES} nostrip\" or patch.  Skipping ${p}"
				is_boltable=0
			fi
			if (( ${is_boltable} == 1 )) && [[ ! -e "${bolt_data_staging_dir}/${bn}.fdata" ]] ; then
				if [[ -e "${p}.orig" ]] ; then
					mv "${p}"{.orig,} || die
				fi
				is_boltable=0
			fi
			if (( ${is_boltable} == 1 )) ; then
				local args=( ${UOPTS_BOLT_OPTIMIZATIONS} )
				if [[ "${UOPTS_BOLT_HUGIFY}" == "1" || "${_UOPTS_USER_WANTS_HUGIFY}" == "1" ]] ; then
					local size=$(stat -c "%s" "${p}")
					if [[ "${UOPTS_BOLT_HUGIFIABLE}" == "0" ]] ; then
ewarn "Hugify is disallowed for ${PN}."
					elif (( ${size} >= ${UOPTS_BOLT_HUGIFY_SIZE} )) ; then
einfo "Hugifing "$(basename "${p}")" with a file size of "$(python -c "print(${size}/1048576)")" MiB"
						args+=( -hugify )
					fi
				fi
einfo "Optimizing ${p} with BOLT"
				if [[ "${skip_inst}" == "yes" ]] ; then
					mv "${p}"{,.orig} || die
				fi
				rm -rf "${p}" || die
				LD_PRELOAD="${_UOPTS_BOLT_MALLOC_LIB}" "${_UOPTS_BOLT_PATH}/llvm-bolt" \
					"${p}.orig" \
					-o "${p}" \
					-data="${bolt_data_staging_dir}/${bn}.fdata" \
					${args[@]} \
					|| die
				rm -rf "${p}.orig" || die
			fi
		) &
	# `wait -n` can only be used with unicore or MAKEOPTS="-j1".
	# busy-wait should be used with multicore or MAKEOPTS="-j2" or higher.
		job_list=( $(jobs -r -p) )
		while (( ${#job_list[@]} >= ${n_procs} )) ; do
			sleep 0.1
			job_list=( $(jobs -r -p) )
		done
	done
	job_list=( $(jobs -r -p) )
	while (( ${#job_list[@]} >= 1 )) ; do
		sleep 0.1
		job_list=( $(jobs -r -p) )
	done
}

# @FUNCTION: _tbolt_src_pre_train
# @INTERNAL
# @DESCRIPTION:
# Initalize training specifically for TBOLT
_tbolt_src_pre_train() {
	local _TBOLT_TRAIN_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${TRAIN_IMPLS}"
	export tbolt_data_staging_dir="${T}/bolt-${_TBOLT_TRAIN_SUFFIX}"
}

# @FUNCTION: tbolt_train_verify_profile_warn
# @INTERNAL
# @DESCRIPTION:
# Verify that a OPT profile was created and warn if some training didn't
# generate a profile in the middle of the training run.
tbolt_train_verify_profile_warn() {
	[[ "${skip_inst}" == "yes" ]] && return
	if use bolt ; then
		local list=(
			$(find "${tbolt_data_staging_dir}" -name "*.fdata")
		)
		local n_lines=${#list[@]}
		if (( ${n_lines} == 0 )) ; then
ewarn "Failed to generate a BOLT profile."
		fi
	fi
}

# @FUNCTION: tbolt_train_verify_profile_fatal
# @INTERNAL
# @DESCRIPTION:
# Verify that a OPT profile was created at the end of training
# if not then die.
tbolt_train_verify_profile_fatal() {
	[[ "${skip_inst}" == "yes" ]] && return
	if use bolt; then
		local list=(
			$(find "${tbolt_data_staging_dir}" -name "*.fdata")
		)
		local n_lines=${#list[@]}
		if (( ${n_lines} == 0 )) ; then
eerror
eerror "Failed to generate a BOLT profile."
eerror
			if [[ "${ABI}" =~ ("amd64"|"arm64") ]] ; then
				die
			fi
		fi
	fi
}

# @FUNCTION: is_bolt_banned
# @DESCRIPTION:
# Check if the executable or library is not allowed to be BOLT
is_bolt_banned() {
	local needle="${1}"
	for haystack in ${UOPTS_BOLT_EXCLUDE_BINS} ; do
		if [[ "${haystack}" == "${needle}" ]] ; then
			return 0
		fi
	done
	return 1
}

# @FUNCTION: is_abi_same
# @DESCRIPTION:
# Check if ABIs are the same and supported
# Precondition:  file_output=$(file "${p}")
is_abi_same() {
	local p="${1}"
	# Only x86-64 and aarch64 supported supported
	if [[ "${file_output}" =~ "ELF".*"x86-64" && "${ABI}" == "amd64" ]] ; then
		return 0
	elif [[ "${file_output}" =~ "ELF".*"aarch64" && "${ABI}" == "arm64" ]] ; then
		return 0
	fi
#ewarn "Unsupported ABI: ${p}"
	return 1
}

# @FUNCTION: is_abi_boltable
# @DESCRIPTION:
# Check if ABIs can be bolted
is_abi_boltable() {
	# Only x86-64 and aarch64 supported supported
	if [[ "${ABI}" == "amd64" ]] ; then
		return 0
	elif [[ "${ABI}" == "arm64" ]] ; then
		return 0
	fi
#ewarn "Unsupported ABI: ${p}"
	return 1
}

# @FUNCTION: is_file_boltable
# @DESCRIPTION:
# Check if files ABI supported
# Precondition:  file_output=$(file "${p}")
is_file_boltable() {
	local p="${1}"
	# Only x86-64 and aarch64 supported supported
	if [[ "${file_output}" =~ "ELF".*"x86-64" ]] ; then
		return 0
	elif [[ "${file_output}" =~ "ELF".*"aarch64" ]] ; then
		return 0
	fi
ewarn "Unsupported ABI: ${p}"
	return 1
}

# @FUNCTION: is_stripped
# @DESCRIPTION:
# Check if the file has been STRIPed
is_stripped() {
	local p="${1}"
	! readelf -s "${p}" | grep -q ".symtab"
}

# @FUNCTION: has_relocs
# @DESCRIPTION:
# Check if the file has relocations
has_relocs() {
	local p="${1}"
	readelf -r "${p}" | grep -q ".rela.text"
}

# @FUNCTION: _disallow_instrumented
# @DESCRIPTION:
# Allowing instrumented to pass is dangerous for any @system or toolchain
# referenced package.  The reason why is because the bolt will break the system library
# or compiler program due to the missing profile folder and exhibit strange behavior.
# A similar problem happens in GCC PGO but handled gracefully.
_disallow_instrumented() {
	local p
	for p in $(find "${D}" -type f) ; do
		if file "${p}" | grep -q "ELF.*executable" ; then
			:
		elif file "${p}" | grep -q "ELF.*shared object" ; then
			:
		else
			continue
		fi
		if readelf -p ".note.bolt_info" "${p}" \
			| grep -E -i -e "-instrument( |$)" ; then
eerror
eerror "The instrumented binary:  ${p}"
eerror
eerror "Detected instrumented binary in D the image which can lead to @system"
eerror "failure.  This indicates a bug in the tbolt.eclass not properly"
eerror "reverting back to the original binary.  Disable the bolt USE flag"
eerror "or wait for a fix."
eerror
			die
		fi
	done
}

# @FUNCTION: tbolt_src_install
# @DESCRIPTION:
# You must call it in *src_install after *_src_install, emake install
#
# User defined event handlers:
#
#   tbolt-custom-bin-wrapper (OPTIONAL, TESTING)
#
#     Re-define this function if names would seem to clobber each other.
#     Ebuild developer note:  This may be deprecated with a list of space
#       separated pairs of rel_path_of_binary_in_builddir:profile_name
#
tbolt_src_install() {
	if use bolt ; then
		_disallow_instrumented
		_UOPTS_BOLT_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${UOPTS_IMPLS}"
		local bolt_data_suffix_dir="${_UOPTS_BOLT_DATA_DIR}/${_UOPTS_BOLT_SUFFIX}"
		local bolt_data_staging_dir="${T}/bolt-${_UOPTS_BOLT_SUFFIX}"
		keepdir "${bolt_data_suffix_dir}"

		cp -aT \
			"${bolt_data_staging_dir}" \
			"${ED}/${bolt_data_suffix_dir}" \
			|| die

		if [[ -z "${CC}" ]] ; then
			export CC="${CHOST}-gcc"
			export CXX="${CHOST}-g++"
			export CPP="${CC} -E"
		fi

		local bolt_pv=$("${_UOPTS_BOLT_PATH}/llvm-bolt" --version \
			| grep -E -o "[0-9]+\.[0-9]+\.[0-9]+")
		local bolt_major_pv="${bolt_pv%%.*}"
		local raw_pv=$(best_version "=llvm-core/llvm-${bolt_major_pv}*" \
			| sed -e "s|llvm-core/llvm-||g")
		local bolt_slot=$(ver_cut 1-2 "${bolt_pv}") # For stable ABI.
		if [[ "${raw_pv}" =~ "9999" ]] ; then
			# Live with unstable ABI.
			local build_timestamp=$(_tbolt_get_build_time)
			bolt_slot="${raw_pv}-${build_timestamp}"
		elif [[ "${raw_pv}" =~ "_pre" ]] ; then
			# Live snapshot with unstable ABI.
			bolt_slot="${raw_pv}"
		fi
		local triple=$(${CC} -dumpmachine) # For ABI and LIBC consistency.
		if [[ "${triple}" =~ "i386" && "${CC}" =~ "clang" && "${CC}" =~ "x86_64" ]] ; then
	#
	# Fix inconsistency between
	#
	# `x86_64-pc-linux-gnu-clang -m32 -dumpmachine` outputs i386-pc-linux-gnu
	#
	#   and
	#
	# `i686-pc-linux-gnu-clang -m32 -dumpmachine` outputs i686-pc-linux-gnu
	#
			triple="${triple/i386/i686}"
		fi
		local cc_type
		if tc-is-clang ; then
			cc_type="clang"
		elif tc-is-gcc ; then
			cc_type="gcc"
		else
			cc_type="${CC}"
		fi
		local fingerprint="llvm-bolt;${bolt_slot};${cc_type};${MULTILIB_ABI_FLAG}.${ABI};${triple}"
		echo "llvm-bolt ${raw_pv}" \
			> "${ED}/${bolt_data_suffix_dir}/llvm_bolt_version" || die
		echo "${fingerprint}" \
			> "${ED}/${bolt_data_suffix_dir}/llvm_bolt_fingerprint" || die

		# Never strip.  If you do it will segfault.
		export STRIP="true"
	fi
}

# @FUNCTION: _tbolt_wipe_bolt_profile
# @INTERNAL
# @DESCRIPTION:
# Reinitalizes the BOLT profile immediately after INST built
_tbolt_wipe_bolt_profile() {
	if [[ "${BOLT_PHASE}" =~ "INST" ]] ; then
einfo "Wiping previous BOLT profile"
		local bolt_data_dir="${EROOT}${_UOPTS_BOLT_DATA_DIR}"
		find "${bolt_data_dir}" -type f \
			-not -name "llvm_bolt_fingerprint" \
			-not -name "llvm_bolt_version" \
			-delete
	fi
}

# @FUNCTION: _tbolt_delete_old_bolt_profiles
# @INTERNAL
# @DESCRIPTION:
# Deletes all old bolt profiles
_tbolt_delete_old_bolt_profiles() {
	if [[ -n "${REPLACING_VERSIONS}" ]] ; then
		local pvr
		for pvr in ${REPLACING_VERSIONS} ; do
			local pv=$(ver_cut 1-2 "${pvr}")
			if ver_test ${pv} -eq $(ver_cut 1-2 "${PV}") ; then
				# Don't delete permissions
				continue
			fi
			local bolt_data_dir="${EROOT}${_UOPTS_BOLT_CATPN_DATA_DIR}/${pv}"
			if [[ -e "${bolt_data_dir}" ]] ; then
einfo "Removing old BOLT profile for =${CATEGORY}/${PN}-${pvr}"
				rm -rf "${bolt_data_dir}" || true
			fi
		done
	fi
}

# @FUNCTION: tbolt_pkg_postinst
# @DESCRIPTION:
# You must call this in pkg_postinst
tbolt_pkg_postinst() {
	use bolt && _tbolt_wipe_bolt_profile
	_tbolt_delete_old_bolt_profiles
}
fi
