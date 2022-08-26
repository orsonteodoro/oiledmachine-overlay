# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: bolt.eclass
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

inherit flag-o-matic toolchain-funcs

IUSE+=" ebolt"
RESTRICT+=" strip" # Don't strip static-libs
EXPORT_FUNCTIONS pkg_config

# @ECLASS_VARIABLE: EBOLT_DISABLE_BDEPEND
# @DESCRIPTION:
# Disable BDEPEND to avoid possible circular dependency

if [[ "${EBOLT_DISABLE_BDEPEND}" != "1" ]] ; then
BDEPEND+="
	>=sys-devel/llvm-14[bolt]
"
fi

# @ECLASS_VARIABLE: EBOLT_EXCLUDE_BINS
# @DESCRIPTION:
# A space separated list of basenames executables or shared libraries not to
# instrument.

# @ECLASS_VARIABLE: EBOLT_PROFILES_DIR
# @DESCRIPTION:
# Sets the location to dump BOLT profiles.
EBOLT_PROFILES_DIR=${EBOLT_PROFILES_DIR:-"/var/lib/bolt-profiles"}

# @ECLASS_VARIABLE: _EBOLT_PV
# @INTERNAL
# @DESCRIPTION:
# Default PV with breaking changes when bumped.
_EBOLT_PV=$(ver_cut 1-2 ${PV}) # default

# @ECLASS_VARIABLE: EBOLT_PV
# @DESCRIPTION:
# Set to the PV range which can cause breakage when bumped.  Excludes non
# breaking patch versions.
EBOLT_PV=${EBOLT_PV:-${_EBOLT_PV}}

# @ECLASS_VARIABLE: _EBOLT_CATPN_DATA_DIR
# @INTERNAL
# @DESCRIPTION:
# The path to the program BOLT profile with general package id specificity.
_EBOLT_CATPN_DATA_DIR=${_EBOLT_CATPN_DATA_DIR:-"${EBOLT_PROFILES_DIR}/${CATEGORY}/${PN}"}

# @ECLASS_VARIABLE: _EBOLT_DATA_DIR
# @INTERNAL
# @DESCRIPTION:
# The path to the program BOLT profile with version specificity.
_EBOLT_DATA_DIR=${_EBOLT_DATA_DIR:-"${EBOLT_PROFILES_DIR}/${CATEGORY}/${PN}/${EBOLT_PV}"}

# @FUNCTION: ebolt_meets_requirements
# @RETURN:
# 0 - as the exit code if it has installed assets and training dependencies
# 1 - as the exit code if it did not install assets or did not install dependencies
# @DESCRIPTION:
# Reports if the prerequisites to train are met.  The implication is that if it
# doesn't have the assets, or doesn't have the training tool, or doesn't have
# the dependency to that training tool, it will fall back to as if USE=-ebolt.
# Example scenario:  dynamic linking to be train with a separate package with
# app that uses the dynamic library.  If the app is not installed, then
# we skip both INST and OPT and fallback to normal merging sequence.
#
# This function is actually a user defined event handler and optional.
#

# @ECLASS_VARIABLE: EBOLT_MALLOC
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

_ebolt_check_bolt() {
	if use ebolt ; then
ewarn
ewarn "BOLT support is still a Work In Progress (WIP)."
ewarn
		if [[ -z "${EBOLT_GROUP}" ]] ; then
eerror
eerror "The EBOLT_GROUP must be defined either in ${EPREFIX}/etc/portage/make.conf or"
eerror "in a per-package env file.  Users who are not a member of this group"
eerror "cannot generate a BOLT profile data with this program."
eerror
eerror "Example:"
eerror
eerror "  EBOLT_GROUP=\"ebolt\""
eerror
			die
		fi

		if ! use kernel_linux ; then
ewarn
ewarn "The ebuilds only support BOLT for Linux at the moment."
ewarn
		fi

		if use amd64 \
			&& perf record -e cpu-clock -j any -o /dev/null -- ls \
			| grep -q -e "PMU Hardware doesn't support sampling/overflow-interrupts" ; then
eerror
eerror "Your CPU needs LBR (Last Branch Record) support.  Please disable the"
eerror "ebolt USE flag."
eerror
		fi
	fi
}

_setup_malloc() {
	[[ -z "${EBOLT_MALLOC}" ]] && EBOLT_MALLOC="auto"

	if [[ -e "${ESYSROOT}/usr/$(get_libdir ${DEFAULT_ABI})/libjemalloc.so" \
		&& "${EBOLT_MALLOC}" =~ ("auto"|"jemalloc") ]] ; then
		export _EBOLT_MALLOC_LIB="${ESYSROOT}/usr/$(get_libdir ${DEFAULT_ABI})/libjemalloc.so"
	elif [[ -e "${ESYSROOT}/usr/$(get_libdir ${DEFAULT_ABI})/libtcmalloc_minimal.so" \
		&& "${EBOLT_MALLOC}" =~ ("auto"|"jemalloc-minimal") ]] ; then
		export _EBOLT_MALLOC_LIB="${ESYSROOT}/usr/$(get_libdir ${DEFAULT_ABI})/libtcmalloc_minimal.so"
	elif [[ -e "${ESYSROOT}/usr/$(get_libdir ${DEFAULT_ABI})/libtcmalloc.so" \
		&& "${EBOLT_MALLOC}" =~ ("auto"|"tcmalloc") ]] ; then
		export _EBOLT_MALLOC_LIB="${ESYSROOT}/usr/$(get_libdir ${DEFAULT_ABI})/libtcmalloc.so"
	else
		export _EBOLT_MALLOC_LIB=""
	fi
}

# @FUNCTION: ebolt_setup
# @DESCRIPTION:
# You must call this in pkg_setup
ebolt_setup() {
	_ebolt_check_bolt
	_setup_malloc
}

# @FUNCTION: _ebolt_prepare_bolt
# @INTERNAL
# @DESCRIPTION:
# Copies an existing profile snapshot into build space.
_ebolt_prepare_bolt() {
	local bolt_data_suffix_dir="${EPREFIX}${_EBOLT_DATA_DIR}/${_EBOLT_SUFFIX}"
	local bolt_data_staging_dir="${T}/bolt-${_EBOLT_SUFFIX}"

	mkdir -p "${bolt_data_staging_dir}" || die
	if [[ -e "${bolt_data_suffix_dir}" ]] ; then
		cp -aT "${bolt_data_suffix_dir}" "${bolt_data_staging_dir}" || die
	fi
	touch "${bolt_data_staging_dir}/compiler_fingerprint" || die
}

# @FUNCTION: ebolt_src_prepare
# @DESCRIPTION:
# You must call this inside the multibuild loop in src_prepare or in a
# *src_prepare multibuild variant.  It has to be inside the loop so that the
# EBOLT_IMPL can divide the bolt profile per ABI or module.  You must define
# EBOLT_IMPL to divide BOLT profiles if impl exists for example headless and
# non-headless builds.
ebolt_src_prepare() {
	_EBOLT_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${EBOLT_IMPLS}"
	_ebolt_prepare_bolt
}

ebolt_src_configure() {
	local bolt_data_suffix_dir="${EPREFIX}${_EBOLT_DATA_DIR}/${_EBOLT_SUFFIX}"
	local bolt_data_staging_dir="${T}/bolt-${_EBOLT_SUFFIX}"
	if use ebolt ; then
		filter-flags \
			'-f*reorder-blocks-and-partition' \
			'-Wl,--emit-relocs' \
			'-Wl,-q'
		append-flags -fno-reorder-blocks-and-partition
		append-ldflags -fno-reorder-blocks-and-partition

		if [[ "${BOLT_PHASE}" == "INST" ]] ; then
			:;
		elif [[ "${BOLT_PHASE}" == "OPT" ]] ; then
			"llvm-profdata" \
				merge \
				-output="${bolt_data_staging_dir}/merged.fdata" \
				"${bolt_data_staging_dir}/"*".perf" || die
		fi
	fi
}

# @FUNCTION: _ebolt_meets_bolt_requirements
# @INTERNAL
# @DESCRIPTION:
# Checks if requirements are met
_ebolt_meets_bolt_requirements() {
	if use ebolt ; then
		local bolt_data_staging_dir="${T}/bolt-${_EBOLT_SUFFIX}"

		has_version "sys-devel/llvm[bolt]" || return 2

		if [[ -z "${CC}" ]] ; then
# This shouldn't set the CC but we have to for -dumpmachine.
			export CC=$(tc-getCC)
			export CXX=$(tc-getCXX)
		fi
einfo
einfo "CC=${CC}"
einfo "CXX=${CXX}"
einfo
		_CC="${CC% *}"

		touch "${bolt_data_staging_dir}/compiler_fingerprint" \
			|| die "You must call ebolt_src_prepare before calling ebolt_get_phase"
		# Has same compiler?
		if tc-is-clang ; then
			local actual=$("${_CC}" -dumpmachine | sha512sum | cut -f 1 -d " ")
			local expected=$(cat "${bolt_data_staging_dir}/compiler_fingerprint")
			if [[ "${actual}" != "${expected}" ]] ; then
ewarn
ewarn "Clang incompatable:"
ewarn
ewarn "actual: ${actual}"
ewarn "expected: ${expected}"
ewarn
				return 1
			fi
		else
			return 2
ewarn
ewarn "Compiler is not supported."
ewarn
		fi

		# Has profile?
		if tc-is-clang && find "${bolt_data_staging_dir}" -name "*.perf" \
			2>/dev/null 1>/dev/null ; then
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
	_EBOLT_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${EBOLT_IMPLS}"
	_ebolt_meets_bolt_requirements
	local ret=$?

	local retu=-1
	if declare -f ebolt_meets_requirements > /dev/null ; then
		ebolt_meets_requirements
		local retu=$?
	fi

	if ! use ebolt ; then
		result="NO_BOLT"
	elif use ebolt && [[ -n "${LLVM_MAX_SLOT}" ]] && (( ${LLVM_MAX_SLOT} < 14 )) ; then
		result="NO_BOLT"
	elif is_abi_boltable ; then
		result="NO_BOLT"
	elif use ebolt && (( ${retu} == 1 )) ; then
		result="NO_BOLT"
	elif use ebolt && [[ "${EBOLT_FORCE_PGI}" == "1" ]] ; then
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
	for haystack in ${EBOLT_EXCLUDE_BINS} ; do
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
	local p="${path}"
	# Only x86-64 and aarch supported supported
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
	# Only x86-64 and aarch supported supported
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
	local p="${path}"
	# Only x86-64 and aarch supported supported
	if file "${p}" | grep -q "ELF.*x86-64" ; then
		return 0
	elif file "${p}" | grep -q "ELF.*aarch64" ; then
		return 0
	fi
	ewarn "Unsupported ABI: ${p}"
	return 1
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
		_EBOLT_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${EBOLT_IMPLS}"
		local bolt_data_suffix_dir="${_EBOLT_DATA_DIR}/${_EBOLT_SUFFIX}"
		local bolt_data_staging_dir="${T}/bolt-${_EBOLT_SUFFIX}"
		keepdir "${bolt_data_suffix_dir}"
		fowners root:${EBOLT_GROUP} "${bolt_data_suffix_dir}"
		fperms 0775 "${bolt_data_suffix_dir}"

		if [[ -z "${CC}" ]] ; then
			# It should be done earlier.
			export CC=$(tc-getCC)
			export CXX=$(tc-getCXX)
		fi

		CC="${CC% *}"

		if tc-is-clang ; then
			"${CC}" -dumpmachine \
				> "${ED}/${bolt_data_suffix_dir}/compiler" || die
			"${CC}" -dumpmachine | sha512sum | cut -f 1 -d " " \
				> "${ED}/${bolt_data_suffix_dir}/compiler_fingerprint" || die
		fi
		# There is a time to quality ratio here.  If we keep it in
		# install, it is deterministic but takes too long.
		if [[ "${BOLT_PHASE}" == "INST" ]] ; then
			for p in $(find "${ED}" -type f) ; do
				[[ -L "${p}" ]] && continue
				local bn=$(basename "${p}")
				is_bolt_banned "${bn}" && continue
				local is_boltable=0
				if file "${p}" | grep -q "ELF.*executable" ; then
					is_boltable=1
				elif file "${p}" | grep -q "ELF.*shared object" ; then
					is_boltable=1
				fi
				is_abi_same "${p}" || continue
				if (( ${is_boltable} == 1 )) ; then
					# See also https://github.com/llvm/llvm-project/blob/main/bolt/lib/Passes/Instrumentation.cpp#L28
					einfo "BOLT vanilla -> instrumented:  ${p}"
					"${_EBOLT_MALLOC_LIB}" llvm-bolt \
						"${p}" \
						-instrument \
						-o "${p}.bolt" \
						-instrumentation-file "${EPREFIX}${bolt_data_suffix_dir}/${bn}.fdata" \
						|| die
					mv "${p}" "${p}.orig" || die
					mv "${p}.bolt" "${p}" || die
				fi
			done
		fi
		if [[ "${BOLT_PHASE}" == "OPT" ]] ; then
			for p in $(find "${ED}" -type f) ; do
				[[ -L "${p}" ]] && continue
				local bn=$(basename "${p}")
				is_bolt_banned "${bn}" && continue
				local is_boltable=0
				if file "${p}" | grep -q "ELF.*executable" ; then
					is_boltable=1
				elif file "${p}" | grep -q "ELF.*shared object" ; then
					is_boltable=1
				fi
				is_abi_same "${p}" || continue
				if (( ${is_boltable} == 1 )) ; then
					local bn=$(basename "${p}")
					einfo "BOLT vanilla -> optimized:  ${p}"
					"${_EBOLT_MALLOC_LIB}" llvm-bolt \
						"${p}" \
						-o "${p}.bolt" \
						-data="${bolt_data_staging_dir}/${bn}.fdata" \
						-reorder-blocks=cache+ \
						-reorder-functions=hfsort \
						-split-functions=2 \
						-split-all-cold \
						-split-eh \
						-dyno-stats || die
					rm "${p}" || die
					mv "${p}.bolt" "${p}" || die
				fi
			done
		fi
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
		local bolt_data_dir="${EROOT}${_EBOLT_DATA_DIR}"
		find "${bolt_data_dir}" -type f \
			-not -name "compiler_fingerprint" \
			-not -name "compiler" \
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
			local bolt_data_dir="${EROOT}${_EBOLT_CATPN_DATA_DIR}/${pv}"
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

_bolt_optimization() {
	use ebolt || return
	# At this point we assume instrumented already.
	# The grep is not friendly with Win systems
	# FIXME:  Specifically, if the path contains a space, it may not work correctly.
	local p
	for p in $(grep "obj" "${EROOT}/var/db/pkg/${CATEGORY}/${P}/CONTENTS" \
		| cut -f 2 -d " ") ; do
		# Always assume optimized or not
		PGO_PHASE_CONFIG=$(get_pgo_phase_config)
		if [[ "${BOLT_PHASE}" == "OPT" ]] ; then
			[[ -L "${p}" ]] && continue
			local bn=$(basename "${p}")
			is_bolt_banned "${bn}" && continue
			local is_boltable=0
			if file "${p}" | grep -q "ELF.*executable" && is_file_boltable "${p}" ; then
				is_boltable=1
			elif file "${p}" | grep -q "ELF.*shared object" && is_file_boltable "${p}" ; then
				is_boltable=1
			fi
			if (( ${is_boltable} == 1 )) ; then
				local bn=$(basename "${p}")
				if [[ ! -e "${p}.orig" ]] ; then
					cp -a "${p}" "${p}".orig || true
				fi
				einfo "BOLT instrumented -> optimized:  ${p}"
				if ! "${_EBOLT_MALLOC_LIB}" llvm-bolt \
					"${p}" \
					-o "${p}.bolt" \
					-data="${EPREFIX}${bolt_data_staging_dir}/${bn}.fdata" \
					-reorder-blocks=cache+ \
					-reorder-functions=hfsort \
					-split-functions=2 \
					-split-all-cold \
					-split-eh \
					-dyno-stats ; then
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
			rm "${p}.bolt" || true
			rm "${p}.bolt_failed"
		fi
		if [[ -e "${p}.bolt" ]] ; then
			einfo "Replacing with BOLT optimized for ${p}"
			rm "${p}"
			mv "${p}.bolt" "${p}"
			rm "${p}.orig"
		fi
	done
}

# @FUNCTION: ebolt_pkg_postinst
# @DESCRIPTION:
# Optimizes binaries for BOLT
ebolt_pkg_config() {
	if [[ -n "${_MULTILIB_BUILD_ECLASS}" ]] ; then
		pkg_config_abi() {
			_EBOLT_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${EBOLT_IMPLS}"
			local bolt_data_suffix_dir="${_EBOLT_DATA_DIR}/${_EBOLT_SUFFIX}"
			_bolt_optimization
		}
		multilib_foreach_abi pkg_config_abi
	else
		_EBOLT_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${EBOLT_IMPLS}"
		local bolt_data_suffix_dir="${_EBOLT_DATA_DIR}/${_EBOLT_SUFFIX}"
		_bolt_optimization
	fi
}
