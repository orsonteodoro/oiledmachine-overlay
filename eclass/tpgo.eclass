# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: tpgo.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: traditional 3 step PGO in one emerge
# @DESCRIPTION:
# This ebuild is to perform a traditional 3 step PGO per emerge.
# It exists to increase the deployment of PGO and to educate about
# mysterious PGO support.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

_TPGO_ECLASS=1

# When to use this eclass?
#
# Only use if the build times are short like in 1 hr and the package has
# benchmarks, demos, examples.
#
# If the package doesn't contain benchmarks, demos, examples or has
# hours build times use the epgo eclass instead.
#
# If the app uses a GUI but doesn't require X but wayland, use the epgo eclass
# instead.

# The current EAPI is not designed for traditional 3 step PGO.
# Certain things should be disabled or be changed in order for it to work
# properly.

# Required
#
# These are required to prevent calling the default handler.
#
# Any event based *configure() needs to be disabled/converted.
#
# src_configure() {
#	...
# }
#	to
#
# _src_configure() { ... }  # Rename
# src_configure() { :; }    # Added
#
#
# multilib_src_configure {
#	...
# }
#
#	to
#
# _src_configure() {
#	configure_abi {
#		tpgo_src_configure
#		...
#	}
#	foreach_multilib_abi
#	configure_abi
# }                      # Renamed
# src_configure) { :; }  # Added
#
#
# Any *prepare() with sed edits needs to be converted
#
# src_prepare() {
#	...
# }
#	to
#
# _src_prepare() { ... }  # Renamed
# src_prepare() { :; }    # Added
#
#
# Any *compile() needs needs to be converted
#
# src_compile() {
#	...
# }
#	to
#
# _src_compile() { :; }              # Renamed
# src_compile() { src_compile ... }  # Changed
#
#
# multilib_src_compile {
#	...
# }
#
#	to
#
# src_compile() {
#	compile_abi {
#               tpgo_src_compile
#		...
#	}
#	foreach_multilib_abi compile_abi
# }                                       # Renamed and changed
#
# If an ebuild uses multiple multibuild derivatives, it should be converted into
# nested loops.
# Reason why is because multibuild and derivatives are broken by design.
# It is trying to cover up the n^k design (aka antipattern).

# @ECLASS_VARIABLE: TPGO_CONFIGURE_DONT_SET_FLAGS
# @DESCRIPTION:
# Lets the project decide how to add PGO flags and merge profile.
TPGO_CONFIGURE_DONT_SET_FLAGS=${TPGO_CONFIGURE_DONT_SET_FLAGS:-0}

# TIPS:

# If a library package is disjoint from the app package and the library package
# doesn't contain a trainer app, then use LD_LIBRARY_PATH to load the PGIed
# library in _src_pre_train to priorize the PGI library before the system
# library, but the app should be prebuilt with the matching depending library
# so the symbols are consistent.  Also, use the train_meets_requirements and
# PDEPEND to prevent disruption of user work.  If this is too difficult to sort
# out, use the epgo eclass instead.

# If using GCC PGO, you may need to add -lgcov to LIBS or modify the build
# files but only in PGI phase.

# @ECLASS_VARIABLE: UOPTS_PGO_PROFILES_DIR
# @DESCRIPTION:
# Sets the location to dump PGO profiles.
UOPTS_PGO_PROFILES_DIR=${UOPTS_PGO_PROFILES_DIR:-"/var/lib/pgo-profiles"}

# @ECLASS_VARIABLE: _UOPTS_PGO_PV
# @INTERNAL
# @DESCRIPTION:
# Default PV with breaking changes when bumped.
_UOPTS_PGO_PV=$(ver_cut 1-2 ${PV}) # default

# @ECLASS_VARIABLE: UOPTS_PGO_PV
# @DESCRIPTION:
# Set to the PV range which can cause breakage when bumped.  Excludes non
# breaking patch versions.
UOPTS_PGO_PV=${UOPTS_PGO_PV:-${_UOPTS_PGO_PV}}

# @ECLASS_VARIABLE: _UOPTS_PGO_CATPN_DATA_DIR
# @INTERNAL
# @DESCRIPTION:
# The path to the program PGO profile with general package id specificity.
_UOPTS_PGO_CATPN_DATA_DIR=${_UOPTS_PGO_CATPN_DATA_DIR:-"${UOPTS_PGO_PROFILES_DIR}/${CATEGORY}/${PN}"}

# @ECLASS_VARIABLE: _UOPTS_PGO_DATA_DIR
# @INTERNAL
# @DESCRIPTION:
# The path to the program PGO profile with version specificity.
_UOPTS_PGO_DATA_DIR=${_UOPTS_PGO_DATA_DIR:-"${UOPTS_PGO_PROFILES_DIR}/${CATEGORY}/${PN}/${UOPTS_PGO_PV}"}

# @ECLASS_VARIABLE: UOPTS_PGO_PORTABLE
# @DESCRIPTION:
# Optimize for speed for untouched functions.

# @ECLASS_VARIABLE: UOPTS_PGO_EVENT_BASED
# @DESCRIPTION:
# Optimize for speed for untouched event handlers.  Do not use unless you
# encounter a performance regression.

# @ECLASS_VARIABLE: UOPTS_PGO_FORCE_PGI
# @DESCRIPTION:
# Temporarily set to 1 to build with PGI (instrumentation) flags.
# Only the user can decide.  Do not set it in the ebuild.
# Example:
# UOPTS_PGO_FORCE_PGI=1 emerge foo

# @ECLASS_VARIABLE: UOPTS_IMPLS (OPTIONAL)
# @DESCRIPTION:
# This sets the suffix for multilib or different implementations.  It should be
# explicitly be set before adding calling any tpgo.eclass function.
# Examples:
#
# impl="headless"
# UOPTS_IMPLS="_${impl}"
# tpgo_src_prepare
#
# impl="simd"
# UOPTS_IMPLS="_${impl}"
# tpgo_src_prepare
#

inherit flag-o-matic toolchain-funcs

IUSE+=" pgo"

tpgo-check-x() {
	local pkg
	for pkg in ${__VIRTX_BDEPENDS[@]} ; do
		if ! has_version "${pkg}" ; then
ewarn
ewarn "${pkg} is required for PGO"
ewarn
		fi
	done
}

# @FUNCTION: tpgo_setup
# @DESCRIPTION:
# Performs checks and recommend workarounds to broken EAPI to unbreak PGO
tpgo_setup() {
	train_setup
	subscribe_verify_profile_warn "tpgo_train_verify_profile_warn"
	subscribe_verify_profile_fatal "tpgo_train_verify_profile_fatal"

	if (( $(declare -f src_configure | wc -c) > 29 )) ; then
eerror
eerror "src_configure must be nop and renamed."
eerror
eerror "Rename src_configure -> _src_configure()."
eerror "Add src_configure() { :; }"
eerror
		die
	fi

	if (( $(declare -f multilib_src_configure | wc -c) > 38 )) ; then
ewarn
ewarn "multilib_src_configure must be renamed."
ewarn
ewarn "Rename multilib_src_configure -> _src_configure()."
ewarn "Add src_configure() { :; }"
ewarn
ewarn "This message may be a false positive."
ewarn
#		die
	fi
	if (( $(declare -f _src_configure | wc -c) == 0 )) ; then
ewarn
ewarn "_src_configure should be defined"
ewarn
	fi
	if (( $(declare -f _src_compile | wc -c) == 0 )) ; then
ewarn
ewarn "_src_configure should be defined"
ewarn
	fi

	if [[ -z "${_UOPTS_ECLASS}" ]] ; then
eerror "The tpgo.eclass must be used with uopts.eclass.  Do not inherit tpgo"
eerror "directly."
		die
	fi

	if tc-is-clang ; then
		local s=$(clang-major-version)
		if [[ -n "${LLVM_MAX_SLOT}" ]] ; then
			if (( ${LLVM_MAX_SLOT} < ${s} )) ; then
				s="${LLVM_MAX_SLOT}"
			fi
		fi
		if ! has_version "=sys-libs/compiler-rt-sanitizers-${s}*[profile]" ; then
eerror
eerror "You need to emerge =sys-libs/compiler-rt-sanitizers-${s}*[profile] for"
eerror "Clang PGO in addition ABIs."
eerror
		fi
	fi
}

# @FUNCTION: _tpgo_prepare_pgo
# @INTERNAL
# @DESCRIPTION:
# Copies an existing profile snapshot into build space.
_tpgo_prepare_pgo() {
	local pgo_data_suffix_dir="${EPREFIX}${_UOPTS_PGO_DATA_DIR}/${_UOPTS_PGO_SUFFIX}"
	local pgo_data_staging_dir="${T}/pgo-${_UOPTS_PGO_SUFFIX}"

	mkdir -p "${pgo_data_staging_dir}" || die
	if [[ "${UOPTS_PGO_FORCE_PGI}" == "1" ]] ; then
		:;
	elif [[ -e "${pgo_data_suffix_dir}" ]] ; then
		cp -aT "${pgo_data_suffix_dir}" "${pgo_data_staging_dir}" || die
	fi
	touch "${pgo_data_staging_dir}/compiler_fingerprint" || die
}

# @FUNCTION: tpgo_src_prepare
# @DESCRIPTION:
# You must call this inside the multibuild loop in src_prepare or in a
# *src_prepare multibuild variant.  It has to be inside the loop so that the
# UOPTS_BOLT_IMPLS can divide the pgo profile per ABI or module.  You must define
# UOPTS_BOLT_IMPLS to divide PGO profiles if impl exists for example headless and
# non-headless builds.
tpgo_src_prepare() {
	_UOPTS_PGO_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${UOPTS_IMPLS}"
	_tpgo_prepare_pgo
}

# @FUNCTION: _tpgo_append_all
# @INTERNAL
# @DESCRIPTION:
# Append all flags to {C,CXX,LD}FLAGS
_tpgo_append_flags() {
	append-flags ${@}
	append-ldflags ${@}
}

# @FUNCTION: _tpgo_configure
# @INTERNAL
# @DESCRIPTION:
# Sets up PGO flags
_tpgo_configure() {
	if use pgo && [[ "${PGO_PHASE}" == "PGI" ]] ; then
		einfo "Setting up PGI"
		if tc-is-clang ; then
			local clang_pv=$(clang-fullversion)
			local use_arg=""
			if [[ "${_MULTILIB_BUILD_ECLASS}" == "1" ]] ; then
				use_arg="${MULTILIB_ABI_FLAG},"
			fi
			if ! has_version "~sys-libs/compiler-rt-sanitizers-${clang_pv}[${use_arg}profile]" \
				&& ! has_version "=sys-libs/compiler-rt-sanitizers-${clang_pv}*[${use_arg}profile]" ; then
eerror
eerror "You need to emerge"
eerror
eerror "~sys-libs/compiler-rt-sanitizers-${clang_pv}[$use_arg}profile]"
eerror
eerror "  or"
eerror
eerror "=sys-libs/compiler-rt-sanitizers-${clang_pv}*[${use_arg}profile]"
eerror
				die
			fi
			_tpgo_append_flags \
				-fprofile-generate="${pgo_data_staging_dir}"
		else
			_tpgo_append_flags \
				-fprofile-generate \
				-fprofile-dir="${pgo_data_staging_dir}"
			[[ "${UOPTS_PGO_PORTABLE}" == "1" || "${UOPTS_PGO_EVENT_BASED}" == "1" ]] \
				&& _tpgo_append_flags -fprofile-partial-training
		fi
	elif use pgo && [[ "${PGO_PHASE}" == "PGO" ]] ; then
		einfo "Setting up PGO"
		if tc-is-clang ; then
			llvm-profdata \
				merge \
				-output="${pgo_data_staging_dir}/pgo-custom.profdata" \
				$(find "${pgo_data_staging_dir}" -name "*.profraw") || die
			_tpgo_append_flags \
				-fprofile-use="${pgo_data_staging_dir}/pgo-custom.profdata"
		elif tc-is-gcc ; then
			_tpgo_append_flags \
				-fprofile-correction \
				-fprofile-use \
				-fprofile-dir="${pgo_data_staging_dir}"
			[[ "${UOPTS_PGO_PORTABLE}" == "1" || "${UOPTS_PGO_EVENT_BASED}" == "1" ]] \
				&& _tpgo_append_flags -fprofile-partial-training
		fi
	fi
}

# @FUNCTION: _tpgo_cmake_clean
# @INTERNAL
# @DESCRIPTION:
# Clears the build directory for a cmake based project.
# You must add this before cmake_src_configure
# The _pre_tpgo_set_clean hook can be used to override BUILD_DIR
_tpgo_cmake_clean() {
	[[ -n ${_CMAKE_ECLASS} || -n ${_CMAKE_UTILS_ECLASS} ]] || return
	declare -f _pre_tpgo_set_clean > /dev/null \
		|| ewarn "_pre_tpgo_set_clean should be defined if BUILD_DIR is changed"
	declare -f _pre_tpgo_set_clean > /dev/null && _pre_tpgo_set_clean
	[[ -e "${BUILD_DIR}" ]] || return

	if [[ -n "${CMAKE_IN_SOURCE_BUILD}" \
		|| "${CMAKE_USE_DIR}" == "${BUILD_DIR}" ]] ; then
		# TODO:  test
		if [[ -e "build.ninja" ]] && grep -q -e "^build clean:" "build.ninja" ; then
			eninja -t clean
		fi
		find "${BUILD_DIR}" -name "CMakeCache.txt" -delete || true
	else
		cd "${CMAKE_USE_DIR}" || die
		rm -rf "${BUILD_DIR}" || die
	fi
}

# @FUNCTION: _tpgo_autotools_clean
# @INTERNAL
# @DESCRIPTION:
# Clears the build directory for autotools based project.
# It assumes the current directory is the build directory
# The _pre_tpgo_set_clean can be used to change into the build directory.
_tpgo_autotools_clean() {
	declare -f _pre_tpgo_set_clean > /dev/null && _pre_tpgo_set_clean
	if [[ -e "Makefile" ]] && grep -q -e "^clean:" "Makefile" ; then
		emake clean
	fi
}

# @FUNCTION: tpgo_meson_src_configure
# @DESCRIPTION:
# Add this in emesonargs
# Example:
# emesonargs=(
#	....
#	$(tpgo_meson_src_configure)
# )
# emesonargs+=( $(tpgo_meson_src_configure) )
#
# You still need to call tpgo_src_configure before meson_src_configure.
#
tpgo_meson_src_configure() {
	if [[ "${PGO_PHASE}" == "PGO" ]] && [[ -e "${BUILD_DIR}/build.ninja" ]] ; then
		echo "--wipe"
	fi
}

# @FUNCTION: tpgo_src_configure
# @DESCRIPTION:
# You must call in _src_configure before cmake_src_configure
# It will wipe the build directory if out of source build for PGO and setup
# flags. The idea is to remove all .o files or .a files before building the
# final.  This is to prevent the possibility of already built skips when
# building PGO image.
#
tpgo_src_configure() {
	_UOPTS_PGO_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${UOPTS_IMPLS}"
	if [[ "${PGO_PHASE}" == "PGO" ]] ; then
		if declare -f _tpgo_custom_clean > /dev/null ; then
			_tpgo_custom_clean
		elif [[ -n ${_CMAKE_ECLASS} || -n ${_CMAKE_UTILS_ECLASS} ]] ; then
			_tpgo_cmake_clean
		elif [[ -n ${_AUTOTOOLS_ECLASS} ]] ; then
			_tpgo_autotools_clean
		fi
	fi

	filter-flags -fprofile*
	local pgo_data_staging_dir="${T}/pgo-${_UOPTS_PGO_SUFFIX}"
	mkdir -p "${pgo_data_staging_dir}" || die # Make first demo produce a PGO profile?

	if [[ "${TPGO_CONFIGURE_DONT_SET_FLAGS}" != "1" ]] ; then
		_tpgo_configure
	fi
}

# @FUNCTION: _tpgo_get_build_time
# @DESCRIPTION:
# Gets the build time
_tpgo_get_build_time() {
# Same as portageq metadata "/${BROOT}" "installed" "sys-devel/gcc-${raw_pv}" "BUILD_TIME"
	local f="/${BROOT}/var/db/pkg/sys-devel/gcc-${raw_pv}/BUILD_TIME"
	if [[ -e "${f}" ]] ; then
		cat "${f}"
	else
		echo "0"
	fi
}

# @FUNCTION: _tpgo_is_profile_reusable
# @INTERNAL
# @DESCRIPTION:
# Checks if requirements are met for profile reuse, skipping PGI and PGT
_tpgo_is_profile_reusable() {
	if use pgo ; then
		local pgo_data_staging_dir="${T}/pgo-${_UOPTS_PGO_SUFFIX}"

		if [[ -z "${CC}" ]] ; then
# This shouldn't set the CC but we have to for -dumpmachine.
			export CC=$(tc-getCC)
			export CXX=$(tc-getCXX)
		fi
einfo "CC:\t\t${CC}"
einfo "CXX:\t\t${CXX}"
		_CC="${CC% *}"

		if ! tc-is-gcc && ! tc-is-clang ; then
ewarn
ewarn "Compiler is not supported."
ewarn
			return 2
		fi

		touch "${pgo_data_staging_dir}/compiler_fingerprint" \
			|| die "You must call uopts_src_prepare before calling tpgo_src_compile"
		# Has same compiler?
		if tc-is-gcc ; then
			local compile_major_pv="$(gcc-major-version)"
			local compiler_pv="$(gcc-version)" # major.minor
			local raw_pv=$(best_version "=sys-devel/gcc-${compile_major_pv}*" \
				| sed -e "s|sys-devel/gcc-||g")
			local pgo_slot=$(ver_cut 1-2 "${compiler_pv}") # For stable ABI.
			if [[ "${raw_pv}" =~ "9999" ]] ; then
				# Live unstable ABI.
				local build_timestamp=$(_tpgo_get_build_time)
				pgo_slot="${raw_pv}-${build_timestamp}"
			elif [[ "${raw_pv}" =~ "_pre" ]] ; then
				# Live snapshot with unstable ABI.
				pgo_slot="${raw_pv}"
			#elif [[ "${raw_pv}" =~ "_p"[0-9]+ ]] ; then
				# Weekly snapshot of a stable branch.  ABI change unlikely.
			fi
			local triple=$(${_CC} -dumpmachine) # For ABI and LIBC consistency.
			local actual="${pgo_slot};${MULTILIB_ABI_FLAG}.${ABI};${triple}"
			local expected=$(cat "${pgo_data_staging_dir}/compiler_fingerprint")
			if [[ "${actual}" != "${expected}" ]] ; then
ewarn
ewarn "GCC fingerprint changed:"
ewarn
ewarn "Actual:\t${actual}"
ewarn "Expected:\t${expected}"
ewarn
				return 1
			fi
		elif tc-is-clang ; then
			local clang_major_pv="$(clang-major-version)"
			local sys_index_ver=$(grep -E \
				-e " INSTR_PROF_INDEX_VERSION [0-9]+" \
				"${ESYSROOT}/usr/lib/llvm/${clang_major_pv}/include/llvm/ProfileData/InstrProfData.inc" \
	                        | cut -f 3 -d " ")
			local pgo_slot="${sys_index_ver}" # For stable ABI.
			local triple=$(${_CC} -dumpmachine) # For ABI and LIBC consistency.
			local actual="${pgo_slot};${MULTILIB_ABI_FLAG}.${ABI};${triple}"
			local expected=$(cat "${pgo_data_staging_dir}/compiler_fingerprint")
			if [[ "${actual}" != "${expected}" ]] ; then
ewarn
ewarn "Clang fingerprint changed:"
ewarn
ewarn "Actual:\t${actual}"
ewarn "Expected:\t${expected}"
ewarn
				return 1
			fi
		fi

		# Has profile?
		local nlines1=$(find "${pgo_data_staging_dir}" -name "*.gcda" | wc -l)
		local nlines2=$(find "${pgo_data_staging_dir}" -name "*.profraw" | wc -l)
		if tc-is-gcc && (( ${nlines1} > 0 )) ; then
			:; # pass
		elif tc-is-clang && (( ${nlines2} > 0 )) ; then
			:; # pass
		else
ewarn
ewarn "NO PGO PROFILE"
ewarn
			return 1
		fi

		return 0
	fi
	return 1
}


# It is recommended to use (nested) loops instead of event handlers.
# The event handlers/eclass hide the information away from you.

# @FUNCTION: _tpgo_src_pre_train
# @INTERNAL
# @DESCRIPTION:
# Initalize training specifically for TPGO
_tpgo_src_pre_train() {
	local _TPGO_TRAIN_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${TRAIN_IMPLS}"
	export pgo_data_staging_dir="${T}/pgo-${_TPGO_TRAIN_SUFFIX}"
}

# @FUNCTION: tpgo_train_verify_profile_warn
# @INTERNAL
# @DESCRIPTION:
# Verify that a PGO profile was created and warn if some training didn't
# generate a profile in the middle of the training run.
tpgo_train_verify_profile_warn() {
	[[ "${skip_pgi}" == "yes" ]] && return
	if use pgo && [[ -z "${CC}" || "${CC}" =~ "gcc" ]] ; then
		local nlines=$(find "${pgo_data_staging_dir}" -name "*.gcda" | wc -l)
		if (( ${nlines} == 0 )) ; then
ewarn
ewarn "Failed to generate a PGO profile."
ewarn "pgo_data_staging_dir=${pgo_data_staging_dir}"
ewarn
		fi
	elif use pgo && [[ "${CC}" =~ "clang" ]] ; then
		local nlines=$(find "${pgo_data_staging_dir}" -name "*.profraw" | wc -l)
		if (( ${nlines} == 0 )) ; then
ewarn
ewarn "Failed to generate a PGO profile."
ewarn "pgo_data_staging_dir=${pgo_data_staging_dir}"
ewarn
		fi
	fi
}

# @FUNCTION: tpgo_train_verify_profile_fatal
# @INTERNAL
# @DESCRIPTION:
# Verify that a PGO profile was created at the end of training
# if not then die.
tpgo_train_verify_profile_fatal() {
	[[ "${skip_pgi}" == "yes" ]] && return
	if use pgo && [[ -z "${CC}" || "${CC}" =~ "gcc" ]] ; then
		local nlines=$(find "${pgo_data_staging_dir}" -name "*.gcda" | wc -l)
		if (( ${nlines} == 0 )) ; then
eerror
eerror "Didn't generate a PGO profile"
eerror
			die
		fi
	elif use pgo && [[ "${CC}" =~ "clang" ]] ; then
		local nlines=$(find "${pgo_data_staging_dir}" -name "*.profraw" | wc -l)
		if (( ${nlines} == 0 )) ; then
eerror
eerror "Didn't generate a PGO profile"
eerror
			die
		fi
	fi
}

# @FUNCTION: tpgo_src_install
# @DESCRIPTION:
# Saves the profile to skip instrumentation on patch releases
tpgo_src_install() {
	if use pgo ; then
		_UOPTS_PGO_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${UOPTS_IMPLS}"
		local pgo_data_suffix_dir="${_UOPTS_PGO_DATA_DIR}/${_UOPTS_PGO_SUFFIX}"
		local pgo_data_staging_dir="${T}/pgo-${_UOPTS_PGO_SUFFIX}"
		keepdir "${pgo_data_suffix_dir}"

		if [[ -z "${CC}" ]] ; then
			# It should be done earlier.
			export CC=$(tc-getCC)
			export CXX=$(tc-getCXX)
		fi

		dodir "${pgo_data_suffix_dir}"
		cp -aT \
			"${pgo_data_staging_dir}" \
			"${ED}/${pgo_data_suffix_dir}" \
			|| die

		_CC="${CC% *}"

		if tc-is-gcc ; then
	# Profile compatibility is based on a byte string.
	# 1 byte major version in hex
	# 2 bytes minor version
	# 1 byte development phase e - experimental, R for release found in gcc/DEV-PHASE
	# 400e - 4.00.x experimental
	# A00R - 10.00.x release
			local compile_major_pv="$(gcc-major-version)"
			local compiler_pv="$(gcc-version)" # major.minor
			local raw_pv=$(best_version "=sys-devel/gcc-${compile_major_pv}*" \
				| sed -e "s|sys-devel/gcc-||g")
			local pgo_slot=$(ver_cut 1-2 "${compiler_pv}") # For stable ABI.
			if [[ "${raw_pv}" =~ "9999" ]] ; then
				# Live unstable ABI.
				local build_timestamp=$(_tpgo_get_build_time)
				pgo_slot="${raw_pv}-${build_timestamp}"
			elif [[ "${raw_pv}" =~ "_pre" ]] ; then
				# Live snapshot with unstable ABI.
				pgo_slot="${raw_pv}"
			#elif [[ "${raw_pv}" =~ "_p"[0-9]+ ]] ; then
				# Weekly snapshot of a stable branch.  ABI change unlikely.
			fi
			local triple=$(${_CC} -dumpmachine) # For ABI and LIBC consistency.
			local fingerprint="${pgo_slot};${MULTILIB_ABI_FLAG}.${ABI};${triple}"
			echo "gcc ${raw_pv}" \
				> "${ED}/${pgo_data_suffix_dir}/compiler_version" || die
			echo "${fingerprint}" \
				> "${ED}/${pgo_data_suffix_dir}/compiler_fingerprint" || die
		elif tc-is-clang ; then
	# Compatibility based on either specific unmerged .profraw version or
	# flexible merged .profdata version.  The latter is preferred.
			local clang_major_pv="$(clang-major-version)"
			local compiler_pv="$(clang-version)" # major.minor
			local sys_index_ver=$(grep -E \
				-e " INSTR_PROF_INDEX_VERSION [0-9]+" \
				"${ESYSROOT}/usr/lib/llvm/${clang_major_pv}/include/llvm/ProfileData/InstrProfData.inc" \
	                        | cut -f 3 -d " ")
			local pgo_slot="${sys_index_ver}" # For stable ABI.
			local triple=$(${_CC} -dumpmachine) # For ABI and LIBC consistency.
			local fingerprint="${pgo_slot};${MULTILIB_ABI_FLAG}.${ABI};${triple}"
			echo "clang ${compiler_pv}" \
				> "${ED}/${pgo_data_suffix_dir}/compiler_version" || die
			echo "${fingerprint}" \
				> "${ED}/${pgo_data_suffix_dir}/compiler_fingerprint" || die
		fi
	fi
}

# @FUNCTION: tpgo_pkg_postinst
# @DESCRIPTION:
# NOP for now, but it could be used for QA, linting, fixes, cleanup.
tpgo_pkg_postinst() {
	# placeholder
	:;
}
