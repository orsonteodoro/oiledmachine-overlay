# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ebolt.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# Help wanted!  Requires co-maintainer or testers.
# @SUPPORTED_EAPIS: 7 8
# @BLURB: event based bolt support
# @DESCRIPTION:
# Deploy bolt support for select ebuilds

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

_EBOLT_ECLASS=1

inherit flag-o-matic toolchain-funcs

IUSE+=" ebolt"
RESTRICT+=" strip" # Don't strip at all

# @ECLASS_VARIABLE: UOPTS_BOLT_DISABLE_BDEPEND
# @DESCRIPTION:
# Disable BDEPEND to avoid possible circular dependency

if [[ "${UOPTS_BOLT_DISABLE_BDEPEND}" != "1" ]] ; then
BDEPEND+="
	>=sys-devel/llvm-14[bolt]
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

# @ECLASS_VARIABLE: _UOPTS_BOLT_PV
# @INTERNAL
# @DESCRIPTION:
# Default PV with breaking changes when bumped.
_UOPTS_BOLT_PV=$(ver_cut 1-2 ${PV}) # default

# @ECLASS_VARIABLE: UOPTS_BOLT_PV
# @DESCRIPTION:
# Set to the PV range which can cause breakage when bumped.  Excludes non
# breaking patch versions.
UOPTS_BOLT_PV=${UOPTS_BOLT_PV:-${_UOPTS_BOLT_PV}}

# @ECLASS_VARIABLE: _UOPTS_BOLT_CATPN_DATA_DIR
# @INTERNAL
# @DESCRIPTION:
# The path to the program BOLT profile with general package id specificity.
_UOPTS_BOLT_CATPN_DATA_DIR=${_UOPTS_BOLT_CATPN_DATA_DIR:-"${UOPTS_BOLT_PROFILES_DIR}/${CATEGORY}/${PN}"}

# @ECLASS_VARIABLE: _UOPTS_BOLT_DATA_DIR
# @INTERNAL
# @DESCRIPTION:
# The path to the program BOLT profile with version specificity.
_UOPTS_BOLT_DATA_DIR=${_UOPTS_BOLT_DATA_DIR:-"${UOPTS_BOLT_PROFILES_DIR}/${CATEGORY}/${PN}/${UOPTS_BOLT_PV}"}

# @ECLASS_VARIABLE: UOPTS_BOLT_PATH
# @DESCRIPTION:
# The absolute path to the folder containing llvm-bolt.

# @ECLASS_VARIABLE: _UOPTS_BOLT_PATH
# @DESCRIPTION:
# Allow disjointed PATH to llvm-bolt while respecting LLVM_MAX_SLOT
_UOPTS_BOLT_PATH="" # Set in ebolt_setup

# @ECLASS_VARIABLE: UOPTS_BOLT_OPTIMIZATIONS
# @DESCRIPTION:
# Allow to override the default BOLT optimization setting

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

_ebolt_check_bolt() {
	if use ebolt ; then
		if [[ -z "${UOPTS_BOLT_GROUP}" ]] ; then
eerror
eerror "The UOPTS_BOLT_GROUP must be defined either in ${EPREFIX}/etc/portage/make.conf or"
eerror "in a per-package env file.  Users who are not a member of this group"
eerror "cannot generate a BOLT profile data with this program."
eerror
eerror "Example:"
eerror
eerror "  UOPTS_BOLT_GROUP=\"ebolt\""
eerror
			die
		fi

		if ! use kernel_linux ; then
ewarn
ewarn "The ebuilds only support BOLT for Linux at the moment."
ewarn
		fi
	fi
}

_setup_malloc() {
	[[ -z "${UOPTS_BOLT_MALLOC}" ]] && UOPTS_BOLT_MALLOC="auto"

	if [[ -e "${ESYSROOT}/usr/$(get_libdir ${DEFAULT_ABI})/libtcmalloc_minimal.so" \
		&& "${UOPTS_BOLT_MALLOC}" =~ ("auto"|"jemalloc-minimal") ]] ; then
		export _UOPTS_BOLT_MALLOC_LIB="${ESYSROOT}/usr/$(get_libdir ${DEFAULT_ABI})/libtcmalloc_minimal.so"
	elif [[ -e "${ESYSROOT}/usr/$(get_libdir ${DEFAULT_ABI})/libjemalloc.so" \
		&& "${UOPTS_BOLT_MALLOC}" =~ ("auto"|"jemalloc") ]] ; then
		export _UOPTS_BOLT_MALLOC_LIB="${ESYSROOT}/usr/$(get_libdir ${DEFAULT_ABI})/libjemalloc.so"
	elif [[ -e "${ESYSROOT}/usr/$(get_libdir ${DEFAULT_ABI})/libtcmalloc.so" \
		&& "${UOPTS_BOLT_MALLOC}" =~ ("auto"|"tcmalloc") ]] ; then
		export _UOPTS_BOLT_MALLOC_LIB="${ESYSROOT}/usr/$(get_libdir ${DEFAULT_ABI})/libtcmalloc.so"
	else
		export _UOPTS_BOLT_MALLOC_LIB=""
	fi
}

# @FUNCTION: _setup_llvm
# @DESCRIPTION:
# Setup PATH for llvm-bolt
_setup_llvm() {
	if [[ -n "${UOPTS_BOLT_PATH}" ]] ; then
		_UOPTS_BOLT_PATH="${UOPTS_BOLT_PATH}"
	elif [[ -n "${UOPTS_BOLT_SLOT}" ]] ; then
		_UOPTS_BOLT_PATH="${ESYSROOT}/usr/lib/llvm/${UOPTS_BOLT_SLOT}/bin"
	elif [[ -z "${LLVM_MAX_SLOT}" ]] ; then
		for s in ${_UOPTS_LLVM_SLOTS[@]} ; do
			if has_version "sys-devel/llvm:${s}[bolt]" ; then
				_UOPTS_BOLT_PATH="${ESYSROOT}/usr/lib/llvm/${s}/bin"
				break
			fi
		done
	fi
}

# @FUNCTION: ebolt_setup
# @DESCRIPTION:
# You must call this in pkg_setup
ebolt_setup() {
ewarn
ewarn "The ebolt USE flag is still Work In Progress (WIP)."
ewarn
	_ebolt_check_bolt
	_setup_malloc
	_setup_llvm

	# Keep in sync with
	# https://github.com/llvm/llvm-project/blob/main/bolt/README.md?plain=1#L183
	export UOPTS_BOLT_OPTIMIZATIONS=${UOPTS_BOLT_OPTIMIZATIONS:-"-reorder-blocks=ext-tsp -reorder-functions=hfsort -split-functions -split-all-cold -split-eh -dyno-stats"}

	if [[ -z "${_UOPTS_ECLASS}" ]] ; then
eerror "The ebolt.eclass must be used with uopts.eclass.  Do not inherit ebolt"
eerror "directly."
		die
	fi
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
		:;
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

# @FUNCTION: _ebolt_meets_bolt_requirements
# @INTERNAL
# @DESCRIPTION:
# Checks if requirements are met
_ebolt_meets_bolt_requirements() {
	if use ebolt ; then
		local bolt_data_staging_dir="${T}/bolt-${_UOPTS_BOLT_SUFFIX}"

		has_version "sys-devel/llvm[bolt]" || return 2

		# Actually, you can use GCC.

		touch "${bolt_data_staging_dir}/llvm_bolt_fingerprint" \
			|| die "You must call uopts_src_prepare before calling ebolt_get_phase"

		if ! tc-is-gcc && ! tc-is-clang ; then
ewarn
ewarn "Compiler is not supported."
ewarn
			return 2
		fi

		"${_UOPTS_BOLT_PATH}/llvm-bolt" --version || die
		local actual=$("${_UOPTS_BOLT_PATH}/llvm-bolt" --version | sha512sum | cut -f 1 -d " ")
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
		local nlines=$(find "${bolt_data_staging_dir}" -name "*.fdata" | wc -l)
		if (( ${nlines} > 0 )) ; then
			:; # pass
		else
ewarn
ewarn "NO BOLT PROFILE"
ewarn
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
	elif is_abi_boltable ; then
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
is_abi_same() {
	local p="${1}"
	# Only x86-64 and aarch64 supported supported
	if file "${p}" | grep -q "ELF.*x86-64" && [[ "${ABI}" == "amd64" ]] ; then
		return 0
	elif file "${p}" | grep -q "ELF.*aarch64" && [[ "${ABI}" == "arm64" ]] ; then
		return 0
	fi
	ewarn "Unsupported ABI: ${p}"
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
	ewarn "Unsupported ABI: ${p}"
	return 1
}

# @FUNCTION: is_file_boltable
# @DESCRIPTION:
# Check if files ABI supported
is_file_boltable() {
	local p="${1}"
	# Only x86-64 and aarch64 supported supported
	if file "${p}" | grep -q "ELF.*x86-64" ; then
		return 0
	elif file "${p}" | grep -q "ELF.*aarch64" ; then
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

# @FUNCTION: _src_compile_bolt_inst
# @DESCRIPTION:
# Instrument the build tree
_src_compile_bolt_inst() {
	# There is a time to quality ratio here.  If we keep it in
	# install, it is deterministic but takes too long.
	if [[ "${BOLT_PHASE}" == "INST" ]] ; then
		[[ -z "${BUILD_DIR}" ]] && die "BUILD_DIR cannot be empty"
		for p in $(find "${BUILD_DIR}" -type f) ; do
			[[ -L "${p}" ]] && continue
			local bn=$(basename "${p}")
			is_bolt_banned "${bn}" && continue
			local is_boltable=0
			if file "${p}" | grep -q "ELF.*executable" ; then
				is_boltable=1
			elif file "${p}" | grep -q "ELF.*shared object" ; then
				is_boltable=1
			else
				continue
			fi
			is_abi_same "${p}" || continue
			if is_stripped "${p}" ; then
ewarn "The package has prestripped binaries.  Re-emerge with FEATURES=\"\${FEATURES} nostrip\" or patch.  Skipping ${p}"
				continue
			fi
			if ! has_relocs "${p}" ; then
ewarn "Missing .rela.text.  Skipping ${p}"
				continue
			fi
			if (( ${is_boltable} == 1 )) ; then
				# See also https://github.com/llvm/llvm-project/blob/main/bolt/lib/Passes/Instrumentation.cpp#L28
				einfo "vanilla -> BOLT instrumented:  ${p}"
				LD_PRELOAD="${_UOPTS_BOLT_MALLOC_LIB}" "${_UOPTS_BOLT_PATH}/llvm-bolt" \
					"${p}" \
					-instrument \
					-o "${p}.bolt" \
					-instrumentation-file "${EPREFIX}${bolt_data_suffix_dir}/${bn}.fdata" || die
				mv "${p}" "${p}.orig" || die
				mv "${p}.bolt" "${p}" || die
			fi
		done
	fi
}

# @FUNCTION: _src_compile_bolt_opt
# @DESCRIPTION:
# Optimize the build tree
_src_compile_bolt_opt() {
	if [[ "${BOLT_PHASE}" == "OPT" ]] ; then
		[[ -z "${BUILD_DIR}" ]] && die "BUILD_DIR cannot be empty"
		for p in $(find "${BUILD_DIR}" -type f) ; do
			[[ -L "${p}" ]] && continue
			local bn=$(basename "${p}")
			is_bolt_banned "${bn}" && continue
			local is_boltable=0
			if file "${p}" | grep -q "ELF.*executable" ; then
				is_boltable=1
			elif file "${p}" | grep -q "ELF.*shared object" ; then
				is_boltable=1
			else
				continue
			fi
			is_abi_same "${p}" || continue
			if is_stripped "${p}" ; then
ewarn "The package has prestripped binaries.  Re-emerge with FEATURES=\"\${FEATURES} nostrip\" or patch.  Skipping ${p}"
				continue
			fi
			local bn=$(basename "${p}")
			if [[ ! -e "${bolt_data_staging_dir}/${bn}.fdata" ]] ; then
				if [[ -e "${p}.orig" ]] ; then
					mv "${p}"{.orig,} || die
				fi
				continue
			fi
			if (( ${is_boltable} == 1 )) ; then
				local args=( ${UOPTS_BOLT_OPTIMIZATIONS} )
				local bn=$(basename "${p}")
				einfo "vanilla -> BOLT optimized:  ${p}"
				LD_PRELOAD="${_UOPTS_BOLT_MALLOC_LIB}" "${_UOPTS_BOLT_PATH}/llvm-bolt" \
					"${p}" \
					-o "${p}.bolt" \
					-data="${bolt_data_staging_dir}/${bn}.fdata" \
					${args[@]} || die
				rm "${p}" || die
				mv "${p}.bolt" "${p}" || die
			fi
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
		fowners root:${UOPTS_BOLT_GROUP} "${bolt_data_suffix_dir}"
		fperms 0775 "${bolt_data_suffix_dir}"

		if [[ -z "${CC}" ]] ; then
			# It should be done earlier.
			export CC=$(tc-getCC)
			export CXX=$(tc-getCXX)
		fi

		CC="${CC% *}"

		"${_UOPTS_BOLT_PATH}/llvm-bolt" --version || die
		"${_UOPTS_BOLT_PATH}/llvm-bolt" --version \
			> "${ED}/${bolt_data_suffix_dir}/llvm_bolt_version" || die
		"${_UOPTS_BOLT_PATH}/llvm-bolt" --version | sha512sum | cut -f 1 -d " " \
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
einfo
einfo "Wiping previous BOLT profile"
einfo
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
	local p
	for p in $(grep "obj" "${EROOT}/var/db/pkg/${CATEGORY}/${P}/CONTENTS" \
		| cut -f 2 -d " ") ; do
		# Always assume optimized or not
		BOLT_PHASE=$(ebolt_get_phase)
		if [[ "${BOLT_PHASE}" == "OPT" ]] ; then
			[[ -L "${p}" ]] && continue
			local bn=$(basename "${p}")
			is_bolt_banned "${bn}" && continue
			local is_boltable=0
			if file "${p}" | grep -q "ELF.*executable" && is_file_boltable "${p}" ; then
				is_boltable=1
			elif file "${p}" | grep -q "ELF.*shared object" && is_file_boltable "${p}" ; then
				is_boltable=1
			else
				continue
			fi
			is_abi_same "${p}" || continue
			if is_stripped "${p}" ; then
ewarn "The package has prestripped binaries.  Re-emerge with FEATURES=\"\${FEATURES} nostrip\" or patch.  Skipping ${p}"
				continue
			fi
			local bn=$(basename "${p}")
			if [[ ! -e "${bolt_data_staging_dir}/${bn}.fdata" ]] ; then
				if [[ -e "${p}.orig" ]] ; then
					mv "${p}"{.orig,} || die
				fi
				continue
			fi
			if (( ${is_boltable} == 1 )) ; then
				local args=( ${UOPTS_BOLT_OPTIMIZATIONS} )
				if [[ ! -e "${p}.orig" ]] ; then
					cp -a "${p}" "${p}.orig" || true
				fi
				einfo "BOLT instrumented -> optimized:  ${p}"
				if ! LD_PRELOAD="${_UOPTS_BOLT_MALLOC_LIB}" "${_UOPTS_BOLT_PATH}/llvm-bolt" \
					"${p}" \
					-o "${p}.bolt" \
					-data="${EPREFIX}${bolt_data_suffix_dir}/${bn}.fdata" \
					${args[@]} ; then
					touch "${p}.bolt_failed"
				fi
			fi
		fi
	done

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
