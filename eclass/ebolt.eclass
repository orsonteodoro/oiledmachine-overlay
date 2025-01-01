# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ebolt.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: event based bolt support
# @DESCRIPTION:
# Deploy bolt support for select ebuilds

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_EBOLT_ECLASS} ]] ; then
_EBOLT_ECLASS=1

inherit flag-o-matic linux-info toolchain-funcs

IUSE+=" ebolt"
RESTRICT+=" strip" # Don't strip at all

# @ECLASS_VARIABLE: UOPTS_BOLT_DISABLE_BDEPEND
# @DESCRIPTION:
# Disable BDEPEND to avoid possible circular dependency

if [[ "${UOPTS_BOLT_DISABLE_BDEPEND}" != "1" ]] ; then
BDEPEND+="
	ebolt? (
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
# @DESCRIPTION:
# Allow disjointed PATH to llvm-bolt while respecting LLVM_MAX_SLOT
_UOPTS_BOLT_PATH="" # Set in ebolt_setup

# @ECLASS_VARIABLE: UOPTS_BOLT_OPTIMIZATIONS
# @USER_VARIABLE
# @DESCRIPTION:
# Allow to override the default BOLT optimization setting

# @ECLASS_VARIABLE: BOLTFLAGS
# @USER_VARIABLE
# @DESCRIPTION:
# Analog to CFLAGS with the same requirements as UOPTS_BOLT_OPTIMIZATIONS.

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

# @FUNCTION: _ebolt_check_bolt
# @DESCRIPTION:
# Check additional bolt requirements
_ebolt_check_bolt() {
	if use ebolt ; then
		if ! use kernel_linux ; then
ewarn "The ebuilds only support BOLT for Linux at the moment."
		fi
	fi
}

# @FUNCTION: _setup_malloc
# @DESCRIPTION:
# Picks the malloc library
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

# @FUNCTION: _ebolt_convert_hugify_to_env
# @DESCRIPTION:
# Convert UOPTS_BOLT_OPTIMIZATIONS="-hugify" to flag _UOPTS_USER_WANTS_HUGIFY=1
_ebolt_convert_hugify_to_env() {
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

# @FUNCTION: ebolt_is_boltflag_banned
# @DESCRIPTION:
# Check if a flag is banned
ebolt_is_boltflag_banned() {
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

# @FUNCTION: ebolt_setup
# @DESCRIPTION:
# You must call this in pkg_setup
ebolt_setup() {
	_ebolt_check_bolt
	_setup_malloc
	_setup_llvm

	# Keep in sync with
	# https://github.com/llvm/llvm-project/blob/main/bolt/README.md?plain=1#L183
	export UOPTS_BOLT_OPTIMIZATIONS=${UOPTS_BOLT_OPTIMIZATIONS:-"-reorder-blocks=ext-tsp -reorder-functions=hfsort -split-functions -split-all-cold -split-eh -dyno-stats"}
	if [[ -n "${BOLTFLAGS}" ]] ; then
		UOPTS_BOLT_OPTIMIZATIONS="${BOLTFLAGS}"
	fi
	if ebolt_is_boltflag_banned "-hugify" ; then
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

	_ebolt_convert_hugify_to_env

	if [[ -z "${_UOPTS_ECLASS}" ]] ; then
eerror
eerror "The ebolt.eclass must be used with uopts.eclass.  Do not inherit ebolt"
eerror "directly."
eerror
		die
	fi

	UOPTS_BOLT_FORK_MULTIPLIER=${UOPTS_BOLT_FORK_MULTIPLIER:-"0.5"}
}

# @FUNCTION: _ebolt_prepare_bolt
# @INTERNAL
# @DESCRIPTION:
# Copies an existing profile snapshot into build space.
_ebolt_prepare_bolt() {
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

# @FUNCTION: ebolt_src_prepare
# @DESCRIPTION:
# You must call this inside the multibuild loop in src_prepare or in a
# *src_prepare multibuild variant.  It has to be inside the loop so that the
# UOPTS_IMPLS can divide the bolt profile per ABI or module.  You must define
# UOPTS_IMPLS to divide BOLT profiles if impl exists for example headless and
# non-headless builds.
ebolt_src_prepare() {
	_UOPTS_BOLT_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${UOPTS_IMPLS}"
	_ebolt_prepare_bolt
}

# @FUNCTION: ebolt_src_configure
# @DESCRIPTION:
# Applies compiler flags required for proper BOLT support.
ebolt_src_configure() {
	local bolt_data_suffix_dir="${EPREFIX}${_UOPTS_BOLT_DATA_DIR}/${_UOPTS_BOLT_SUFFIX}"
	local bolt_data_staging_dir="${T}/bolt-${_UOPTS_BOLT_SUFFIX}"
	if use ebolt ; then
		# Apply unconditionally especially if build scripts force gcc.
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


# @FUNCTION: _ebolt_get_build_time
# @DESCRIPTION:
# Gets the build time
_ebolt_get_build_time() {
# Same as portageq metadata "/${BROOT}" "installed" "llvm-core/llvm-${raw_pv}" "BUILD_TIME"
	local f="/${BROOT}/var/db/pkg/llvm-core/llvm-${raw_pv}/BUILD_TIME"
	if [[ -e "${f}" ]] ; then
		cat "${f}"
	else
		echo "0"
	fi
}

# @FUNCTION: _ebolt_meets_bolt_requirements
# @INTERNAL
# @DESCRIPTION:
# Checks if requirements are met
_ebolt_meets_bolt_requirements() {
	if use ebolt ; then
		local bolt_data_staging_dir="${T}/bolt-${_UOPTS_BOLT_SUFFIX}"

		has_version "llvm-core/llvm[bolt]" || return 2

		# Actually, you can use GCC.

		touch "${bolt_data_staging_dir}/llvm_bolt_fingerprint" \
			|| die "You must call uopts_src_prepare before calling ebolt_get_phase"

		if ! tc-is-gcc && ! tc-is-clang ; then
ewarn "Compiler is not supported for EBOLT."
			return 2
		fi

		if [[ -z "${CC}" ]] ; then
			export CC="${CHOST}-gcc"
			export CXX="${CHOST}-g++"
			export CPP="${CC} -E"
			strip-unsupported-flags
		fi

		local bolt_pv=$("${_UOPTS_BOLT_PATH}/llvm-bolt" --version \
			| grep -E -o "[0-9]+\.[0-9]+\.[0-9]+")
		local bolt_major_pv="${bolt_pv%%.*}"
		local raw_pv=$(best_version "=llvm-core/llvm-${bolt_major_pv}*" \
			| sed -e "s|llvm-core/llvm-||g")
		local bolt_slot=$(ver_cut 1-2 "${bolt_pv}") # For stable ABI.
		if [[ "${raw_pv}" =~ "9999" ]] ; then
			# Live with unstable ABI.
			local build_timestamp=$(_ebolt_get_build_time)
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
		local actual="llvm-bolt;${bolt_slot};${MULTILIB_ABI_FLAG}.${ABI};${triple}"
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

# @FUNCTION: ebolt_get_phase
# @DESCRIPTION:
# Reports the current BOLT phase
ebolt_get_phase() {
	# INSTRUMENT
	# GATHER / TRAIN
	# OPTIMIZE
	local result="NO_BOLT"
	_UOPTS_BOLT_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${UOPTS_IMPLS}"
	_ebolt_meets_bolt_requirements
	local ret=$?

	if ! use ebolt ; then
		result="NO_BOLT"
	elif ! is_abi_boltable ; then
		result="NO_BOLT"
	elif use ebolt && [[ "${UOPTS_BOLT_FORCE_INST}" == "1" ]] ; then
		result="INST"
	elif use ebolt && (( ${ret} == 0 )) ; then
		result="OPT"
	elif use ebolt && (( ${ret} == 1 )) ; then
		result="INST"
	elif use ebolt && (( ${ret} == 2 )) ; then
		result="NO_BOLT"
	fi
	echo "${result}"
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

# @FUNCTION: _src_compile_bolt_inst
# @DESCRIPTION:
# Instrument the build tree
_src_compile_bolt_inst() {
	# There is a time to quality ratio here.  If we keep it in
	# install, it is deterministic but takes too long.
	if [[ "${BOLT_PHASE}" == "INST" ]] ; then
		[[ -z "${BUILD_DIR}" ]] && die "BUILD_DIR cannot be empty"
		_UOPTS_BOLT_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${UOPTS_IMPLS}"
		local bolt_data_suffix_dir="${_UOPTS_BOLT_DATA_DIR}/${_UOPTS_BOLT_SUFFIX}"
		local file_list=(
			$(find "${BUILD_DIR}" \
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
ewarn "Scanning ${BUILD_DIR}"
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

#einfo "DEBUG:  LD_PRELOAD=\"${_UOPTS_BOLT_MALLOC_LIB}\" ${_UOPTS_BOLT_PATH}/llvm-bolt \"${p}\" -instrument -o \"${p}.bolt\" -instrumentation-file \"${EPREFIX}${bolt_data_suffix_dir}/${bn}.fdata\" ${extra_args[@]}"
					# See also https://github.com/llvm/llvm-project/blob/main/bolt/lib/Passes/Instrumentation.cpp#L28
					LD_PRELOAD="${_UOPTS_BOLT_MALLOC_LIB}" "${_UOPTS_BOLT_PATH}/llvm-bolt" \
						"${p}" \
						-instrument \
						-o "${p}.bolt" \
						-instrumentation-file "${EPREFIX}${bolt_data_suffix_dir}/${bn}.fdata" \
						${extra_args[@]} \
						|| die
					mv "${p}" "${p}.orig" || die
					mv "${p}.bolt" "${p}" || die
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
	fi
}

# @FUNCTION: _src_compile_bolt_opt
# @DESCRIPTION:
# Optimize the build tree
_src_compile_bolt_opt() {
	if [[ "${BOLT_PHASE}" == "OPT" ]] ; then
		[[ -z "${BUILD_DIR}" ]] && die "BUILD_DIR cannot be empty"
		local bolt_data_staging_dir="${T}/bolt-${_UOPTS_BOLT_SUFFIX}"
		local file_list=(
			$(find "${BUILD_DIR}" \
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
ewarn "Scanning ${BUILD_DIR}"
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
					LD_PRELOAD="${_UOPTS_BOLT_MALLOC_LIB}" "${_UOPTS_BOLT_PATH}/llvm-bolt" \
						"${p}" \
						-o "${p}.bolt" \
						-data="${bolt_data_staging_dir}/${bn}.fdata" \
						${args[@]} || die
					rm "${p}" || die
					mv "${p}.bolt" "${p}" || die
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
	fi
}

# @FUNCTION: ebolt_src_install
# @DESCRIPTION:
# You must call it in *src_install
#
# User defined event handlers:
#
#   ebolt-custom-bin-wrapper (OPTIONAL, TESTING)
#
#     Re-define this function if names would seem to clobber each other.
#     Ebuild developer note:  This may be deprecated with a list of space
#       separated pairs of rel_path_of_binary_in_builddir:profile_name
#
ebolt_src_install() {
	if use ebolt ; then
		_UOPTS_BOLT_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${UOPTS_IMPLS}"
		local bolt_data_suffix_dir="${_UOPTS_BOLT_DATA_DIR}/${_UOPTS_BOLT_SUFFIX}"
		local bolt_data_staging_dir="${T}/bolt-${_UOPTS_BOLT_SUFFIX}"
		keepdir "${bolt_data_suffix_dir}"
	# Root does not have the limited user group (ex. johndoe).
		fowners ${UOPTS_USER}:${UOPTS_GROUP} "${bolt_data_suffix_dir}"
		fperms 0775 "${bolt_data_suffix_dir}"

		if [[ -z "${CC}" ]] ; then
			export CC="${CHOST}-gcc"
			export CXX="${CHOST}-g++"
			export CPP="${CC} -E"
			strip-unsupported-flags
		fi

		local bolt_pv=$("${_UOPTS_BOLT_PATH}/llvm-bolt" --version \
			| grep -E -o "[0-9]+\.[0-9]+\.[0-9]+")
		local bolt_major_pv="${bolt_pv%%.*}"
		local raw_pv=$(best_version "=llvm-core/llvm-${bolt_major_pv}*" \
			| sed -e "s|llvm-core/llvm-||g")
		local bolt_slot=$(ver_cut 1-2 "${bolt_pv}") # For stable ABI.
		if [[ "${raw_pv}" =~ "9999" ]] ; then
			# Live with unstable ABI.
			local build_timestamp=$(_ebolt_get_build_time)
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
		local fingerprint="llvm-bolt;${bolt_slot};${MULTILIB_ABI_FLAG}.${ABI};${triple}"
		echo "llvm-bolt ${raw_pv}" \
			> "${ED}/${bolt_data_suffix_dir}/llvm_bolt_version" || die
		echo "${fingerprint}" \
			> "${ED}/${bolt_data_suffix_dir}/llvm_bolt_fingerprint" || die

		# Never strip.  If you do it will segfault.
		export STRIP="true"
	fi
}

# @FUNCTION: _ebolt_wipe_bolt_profile
# @INTERNAL
# @DESCRIPTION:
# Reinitalizes the BOLT profile immediately after INST built
_ebolt_wipe_bolt_profile() {
	if [[ "${BOLT_PHASE}" =~ "INST" ]] ; then
einfo "Wiping previous BOLT profile"
		local bolt_data_dir="${EROOT}${_UOPTS_BOLT_DATA_DIR}"
		find "${bolt_data_dir}" -type f \
			-not -name "llvm_bolt_fingerprint" \
			-not -name "llvm_bolt_version" \
			-delete
	fi
}

# @FUNCTION: _ebolt_delete_old_bolt_profiles
# @INTERNAL
# @DESCRIPTION:
# Deletes all old bolt profiles
_ebolt_delete_old_bolt_profiles() {
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

# @FUNCTION: ebolt_pkg_postinst
# @DESCRIPTION:
# You must call this in pkg_postinst
ebolt_pkg_postinst() {
	use ebolt && _ebolt_wipe_bolt_profile
	_ebolt_delete_old_bolt_profiles
}

_pkg_config_bolt_optimization() {
	use ebolt || return
	# At this point we assume instrumented already.
	# The grep is not friendly with Win systems
	# FIXME:  Specifically, if the path contains a space, it may not work correctly.
	local file_list=(
		$(grep "obj" "${EROOT}/var/db/pkg/${CATEGORY}/${P}/CONTENTS" \
	                | cut -f 2 -d " ")
	)
	local n_files=${#file_list[@]}
	local x_files=0
ewarn "Finding binaries to BOLT.  Please wait..."
ewarn "Number of files to scan:  ${n_files}"
ewarn "Scanning files in file list from ${EROOT}/var/db/pkg/${CATEGORY}/${P}/CONTENTS"
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
			# Always assume optimized or not
			BOLT_PHASE=$(ebolt_get_phase)
			if [[ "${BOLT_PHASE}" == "OPT" ]] ; then
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
				if (( ${is_boltable} == 1 )) && [[ -L "${p}" ]] ; then
					is_boltable=0
				fi
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
					if [[ ! -e "${p}.orig" ]] ; then
						cp -a "${p}" "${p}.orig" || true
					fi
einfo "Optimizing ${p} with BOLT"
					if ! LD_PRELOAD="${_UOPTS_BOLT_MALLOC_LIB}" "${_UOPTS_BOLT_PATH}/llvm-bolt" \
						"${p}" \
						-o "${p}.bolt" \
						-data="${EPREFIX}${bolt_data_suffix_dir}/${bn}.fdata" \
						${args[@]} ; then
						touch "${p}.bolt_failed"
					fi
				fi
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
einfo "Done"

	# Using best effort to BOLT while undoing failed optimization.
	for p in $(grep "obj" "${EROOT}/var/db/pkg/${CATEGORY}/${P}/CONTENTS" \
		| cut -f 2 -d " ") ; do
		if [[ -e "${p}.bolt_failed" ]] ; then
einfo "Undoing BOLT failure for ${p}"
			mv "${p}.orig" "${p}"
			rm -rf "${p}.bolt" \
				"${p}.bolt_failed"
		fi
		if [[ -e "${p}.bolt" ]] ; then
einfo "Replacing with BOLT optimized for ${p}"
			mv "${p}.bolt" "${p}"
			rm -rf "${p}.orig"
		fi
	done
}

# @FUNCTION: ebolt_pkg_config
# @DESCRIPTION:
# Optimizes binaries for BOLT
ebolt_pkg_config() {
	if [[ -n "${_MULTILIB_BUILD_ECLASS}" ]] ; then
		pkg_config_abi() {
			_UOPTS_BOLT_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${UOPTS_IMPLS}"
			local bolt_data_suffix_dir="${_UOPTS_BOLT_DATA_DIR}/${_UOPTS_BOLT_SUFFIX}"
			_pkg_config_bolt_optimization
		}
		multilib_foreach_abi pkg_config_abi
	else
		_UOPTS_BOLT_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${UOPTS_IMPLS}"
		local bolt_data_suffix_dir="${_UOPTS_BOLT_DATA_DIR}/${_UOPTS_BOLT_SUFFIX}"
		_pkg_config_bolt_optimization
	fi
}
fi
