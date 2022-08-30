# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: tbolt.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# Help wanted!  Requires co-maintainer or testers.
# @SUPPORTED_EAPIS: 7 8
# @BLURB: three step bolt support
# @DESCRIPTION:
# Deploy bolt support for select ebuilds

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

_TBOLT_ECLASS=1

LLVM_SLOTS=(16 15 14)
inherit flag-o-matic toolchain-funcs train

IUSE+=" bolt"
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

# @ECLASS_VARIABLE: _UOPTS_BOLT_PATH
# @INTERNAL
# @DESCRIPTION:
# Allow disjointed PATH to llvm-bolt while respecting LLVM_MAX_SLOT
_UOPTS_BOLT_PATH="" # Set in tbolt_setup

# @ECLASS_VARIABLE: UOPTS_BOLT_SLOT
# @DESCRIPTION:
# Force a particular LLVM slot for llvm-slot.  This is for compatiblity for BOLT profiles.
# The preference is auto selection to the highest enabled.

# @ECLASS_VARIABLE: UOPTS_BOLT_OPTIMIZATIONS
# @DESCRIPTION:
# Allow to override the default BOLT optimization setting

# @FUNCTION: tbolt_meets_requirements
# @RETURN:
# 0 - as the exit code if it has installed assets and training dependencies
# 1 - as the exit code if it did not install assets or did not install dependencies
# @DESCRIPTION:
# Reports if the prerequisites to train are met.  The implication is that if it
# doesn't have the assets, or doesn't have the training tool, or doesn't have
# the dependency to that training tool, it will fall back to as if USE=-tbolt.
# Example scenario:  dynamic linking to be train with a separate package with
# app that uses the dynamic library.  If the app is not installed, then
# we skip both INST and OPT and fallback to normal merging sequence.
#
# This function is actually a user defined event handler and optional.
#

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

_tbolt_check_bolt() {
	if use bolt ; then
ewarn
ewarn "BOLT support is still a Work In Progress (WIP)."
ewarn
		if ! use kernel_linux ; then
ewarn
ewarn "The ebuilds only support BOLT for Linux at the moment."
ewarn
		fi
	fi
}

_setup_malloc() {
	[[ -z "${UOPTS_BOLT_MALLOC}" ]] && UOPTS_BOLT_MALLOC="auto"

	if [[ -e "${ESYSROOT}/usr/$(get_libdir ${DEFAULT_ABI})/libjemalloc.so" \
		&& "${UOPTS_BOLT_MALLOC}" =~ ("auto"|"jemalloc") ]] ; then
		export _UOPTS_BOLT_MALLOC_LIB="${ESYSROOT}/usr/$(get_libdir ${DEFAULT_ABI})/libjemalloc.so"
	elif [[ -e "${ESYSROOT}/usr/$(get_libdir ${DEFAULT_ABI})/libtcmalloc_minimal.so" \
		&& "${UOPTS_BOLT_MALLOC}" =~ ("auto"|"jemalloc-minimal") ]] ; then
		export _UOPTS_BOLT_MALLOC_LIB="${ESYSROOT}/usr/$(get_libdir ${DEFAULT_ABI})/libtcmalloc_minimal.so"
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
	if [[ -n "${UOPTS_BOLT_SLOT}" ]] ; then
		_UOPTS_BOLT_PATH="${ESYSROOT}/usr/lib/llvm/${UOPTS_BOLT_SLOT}/bin"
	elif [[ -z "${LLVM_MAX_SLOT}" ]] ; then
		for s in ${LLVM_SLOTS[@]} ; do
			if has_version "sys-devel/llvm:${s}[bolt]" ; then
				_UOPTS_BOLT_PATH="${ESYSROOT}/usr/lib/llvm/${s}/bin"
				break
			fi
		done
	fi
}

# @FUNCTION: tbolt_setup
# @DESCRIPTION:
# You must call this in pkg_setup
tbolt_setup() {
	_tbolt_check_bolt
	_setup_malloc
	train_setup
	_setup_llvm
	export UOPTS_BOLT_OPTIMIZATIONS=${UOPTS_BOLT_OPTIMIZATIONS:-"-reorder-blocks=cache+ -reorder-functions=hfsort -split-functions=2 -split-all-cold -split-eh -dyno-stats"}

	if [[ -z "${_UOPTS_ECLASS}" ]] ; then
eerror "tbolt.eclass must be used with uopts.eclass.  Do not inherit tbolt"
eerror "directly."
		die
	fi
}

# @FUNCTION: _tbolt_prepare_bolt
# @INTERNAL
# @DESCRIPTION:
# Copies an existing profile snapshot into build space.
_tbolt_prepare_bolt() {
	local bolt_data_suffix_dir="${EPREFIX}${_UOPTS_BOLT_DATA_DIR}/${_UOPTS_BOLT_SUFFIX}"
	local bolt_data_staging_dir="${T}/bolt-${_UOPTS_BOLT_SUFFIX}"

	mkdir -p "${bolt_data_staging_dir}" || die
	if [[ -e "${bolt_data_suffix_dir}" ]] ; then
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

tbolt_src_configure() {
	local bolt_data_suffix_dir="${EPREFIX}${_UOPTS_BOLT_DATA_DIR}/${_UOPTS_BOLT_SUFFIX}"
	local bolt_data_staging_dir="${T}/bolt-${_UOPTS_BOLT_SUFFIX}"
	if use bolt ; then
		filter-flags \
			'-f*reorder-blocks-and-partition' \
			'-Wl,--emit-relocs' \
			'-Wl,-q'
		append-flags $(test-flag -fno-reorder-blocks-and-partition)
		append-ldflags $(test-flag-CCLD -fno-reorder-blocks-and-partition) \
			-Wl,--emit-relocs
	fi
}

# @FUNCTION: _tbolt_is_profile_reusable
# @INTERNAL
# @DESCRIPTION:
# Checks if requirements are met
_tbolt_is_profile_reusable() {
	if use bolt ; then
		local bolt_data_staging_dir="${T}/bolt-${_UOPTS_BOLT_SUFFIX}"

		has_version "sys-devel/llvm[bolt]" || return 2

		# Actually, you can use GCC.

		touch "${pgo_data_staging_dir}/llvm_bolt_fingerprint" \
			|| die "You must call ebolt_src_prepare before calling ebolt_get_phase"
		local actual=$("${_UOPTS_BOLT_PATH}/llvm-bolt" --version | sha512sum | cut -f 1 -d " ")
		local expected=$(cat "${pgo_data_staging_dir}/llvm_bolt_fingerprint")
		if [[ "${actual}" != "${expected}" ]] ; then
# This check is done because of BOLT profile compatibility.
ewarn
ewarn "llvm-bolt incompatable:"
ewarn
ewarn "actual: ${actual}"
ewarn "expected: ${expected}"
ewarn
			return 1
		else
			return 2
ewarn
ewarn "llvm-bolt fingerprint mismatch"
ewarn
		fi

		# Has profile?
		if find "${bolt_data_staging_dir}" -name "*.fdata" \
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

# @FUNCTION: _tbolt_inst_tree
# @INTERNAL
# @DESCRIPTION:
# Instruments a tree
_tbolt_inst_tree() {
	[[ "${BOLT_PHASE}" == "INST" ]] || return
	local tree="${1}"
	local bolt_data_staging_dir="${T}/bolt-${_UOPTS_BOLT_SUFFIX}"
	for p in $(find "${tree}" -type f) ; do
		[[ -L "${p}" ]] && continue
		local bn=$(basename "${p}")
		is_bolt_banned "${bn}" && continue
		local is_boltable=0
		if file "${p}" | grep -q "ELF.*executable" ; then
			is_boltable=1
		elif file "${p}" | grep -q "ELF.*shared object" ; then
			is_boltable=1
		fi
		if is_stripped "${p}" ; then
eerror
eerror "The package has prestripped binaries.  Patch is required.  Detected in ${p}"
eerror
			die
		fi
		is_abi_same "${p}" || continue
		if (( ${is_boltable} == 1 )) ; then
			# See also https://github.com/llvm/llvm-project/blob/main/bolt/lib/Passes/Instrumentation.cpp#L28
			einfo "vanilla -> BOLT instrumented:  ${p}"
			"${_UOPTS_BOLT_MALLOC_LIB}" "${_UOPTS_BOLT_PATH}/llvm-bolt" \
				"${p}" \
				-instrument \
				-o "${p}.bolt" \
				-instrumentation-file "${bolt_data_staging_dir}/${bn}.fdata" \
				|| die
			mv "${p}" "${p}.orig" || die
			mv "${p}.bolt" "${p}" || die
		fi
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
	for p in $(find "${tree}" -type f) ; do
		[[ -L "${p}" ]] && continue
		local bn=$(basename "${p}")
		is_bolt_banned "${bn}" && continue
		local is_boltable=0
		if file "${p}" | grep -q "ELF.*executable" ; then
			is_boltable=1
		elif file "${p}" | grep -q "ELF.*shared object" ; then
			is_boltable=1
		fi
		if is_stripped "${p}" ; then
eerror
eerror "The package has stripped binaries for ${p}"
eerror
			die
		fi
		is_abi_same "${p}" || continue
		if (( ${is_boltable} == 1 )) ; then
			local args=( ${UOPTS_BOLT_OPTIMIZATIONS} )
			local bn=$(basename "${p}")
			einfo "vanilla -> BOLT optimized:  ${p}"
			"${_UOPTS_BOLT_MALLOC_LIB}" "${_UOPTS_BOLT_PATH}/llvm-bolt" \
				"${p}" \
				-o "${p}.bolt" \
				-data="${bolt_data_staging_dir}/${bn}.fdata" \
				${args[@]} \
				|| die
			rm "${p}" || die
			mv "${p}.bolt" "${p}" || die
		fi
	done
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
	local p="${1}"
	# Only x86-64 and aarch supported supported
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

# @FUNCTION: tbolt_src_install
# @DESCRIPTION:
# You must call it in *src_install
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
		_UOPTS_BOLT_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${UOPTS_IMPLS}"
		local bolt_data_suffix_dir="${_UOPTS_BOLT_DATA_DIR}/${_UOPTS_BOLT_SUFFIX}"
		local bolt_data_staging_dir="${T}/bolt-${_UOPTS_BOLT_SUFFIX}"
		keepdir "${bolt_data_suffix_dir}"

		cp -aT \
			"${bolt_data_staging_dir}" \
			"${ED}/${bolt_data_suffix_dir}" \
			|| die

		"${_UOPTS_BOLT_PATH}/llvm-bolt" --version \
			> "${ED}/${bolt_data_suffix_dir}/llvm_bolt_version" || die
		"${_UOPTS_BOLT_PATH}/llvm-bolt" --version | sha512sum | cut -f 1 -d " " \
			> "${ED}/${bolt_data_suffix_dir}/llvm_bolt_fingerprint" || die
	fi
}

# @FUNCTION: _tbolt_wipe_bolt_profile
# @INTERNAL
# @DESCRIPTION:
# Reinitalizes the BOLT profile immediately after INST built
_tbolt_wipe_bolt_profile() {
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
