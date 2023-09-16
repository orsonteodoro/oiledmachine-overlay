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

inherit flag-o-matic toolchain-funcs

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

_tbolt_check_bolt() {
	if use bolt ; then
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
	if [[ -n "${UOPTS_BOLT_SLOT}" ]] ; then
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
	if [[ "${UOPTS_BOLT_FORCE_INST}" == "1" ]] ; then
		:;
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

# @FUNCTION: _tbolt_is_profile_reusable
# @INTERNAL
# @DESCRIPTION:
# Checks if requirements are met
_tbolt_is_profile_reusable() {
	if use bolt ; then
		local bolt_data_staging_dir="${T}/bolt-${_UOPTS_BOLT_SUFFIX}"

		has_version "sys-devel/llvm[bolt]" || return 2

		# Actually, you can use GCC.

		touch "${bolt_data_staging_dir}/llvm_bolt_fingerprint" \
			|| die "You must call uopts_src_prepare before calling tbolt_get_phase"

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

# @FUNCTION: _tbolt_inst_tree
# @INTERNAL
# @DESCRIPTION:
# Instruments a tree
_tbolt_inst_tree() {
	[[ "${BOLT_PHASE}" == "INST" ]] || return
	local tree="${1}"
	local bolt_data_staging_dir="${T}/bolt-${_UOPTS_BOLT_SUFFIX}"
	for p in $(find "${tree}" -type f -not -name "*.orig") ; do
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
		if is_stripped "${p}" ; then
ewarn "The package has prestripped binaries.  Re-emerge with FEATURES=\"\${FEATURES} nostrip\" or patch.  Skipping ${p}"
			continue
		fi
		if ! has_relocs "${p}" ; then
ewarn "Missing .rela.text skipping ${p}"
			continue
		fi
		is_abi_same "${p}" || continue
		if (( ${is_boltable} == 1 )) ; then
			# See also https://github.com/llvm/llvm-project/blob/main/bolt/lib/Passes/Instrumentation.cpp#L28
			einfo "vanilla -> BOLT instrumented:  ${p}"
			if [[ ! -e "${p}.orig" ]] ; then
				mv "${p}"{,.orig} || die
			else
				ewarn "${p}.orig existed and BUILD_DIR was not completely wiped."
			fi
			LD_PRELOAD="${_UOPTS_BOLT_MALLOC_LIB}" "${_UOPTS_BOLT_PATH}/llvm-bolt" \
				"${p}.orig" \
				-instrument \
				-o "${p}" \
				-instrumentation-file "${bolt_data_staging_dir}/${bn}.fdata" || die
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
	for p in $(find "${tree}" -type f -not -name "*.orig") ; do
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
			einfo "vanilla -> BOLT optimized:  ${p}"
			if [[ "${skip_inst}" == "yes" ]] ; then
				mv "${p}"{,.orig} || die
			fi
			rm -rf "${p}" || die
			LD_PRELOAD="${_UOPTS_BOLT_MALLOC_LIB}" "${_UOPTS_BOLT_PATH}/llvm-bolt" \
				"${p}.orig" \
				-o "${p}" \
				-data="${bolt_data_staging_dir}/${bn}.fdata" \
				${args[@]} || die
			rm -rf "${p}.orig" || die
		fi
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
		local nlines=$(find "${tbolt_data_staging_dir}" -name "*.fdata" | wc -l)
		if (( ${nlines} == 0 )) ; then
ewarn
ewarn "Failed to generate a BOLT profile."
ewarn
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
		local nlines=$(find "${tbolt_data_staging_dir}" -name "*.fdata" | wc -l)
		if (( ${nlines} == 0 )) ; then
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
			:;
		elif file "${p}" | grep -q "ELF.*shared object" ; then
			:;
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

		"${_UOPTS_BOLT_PATH}/llvm-bolt" --version || die
		"${_UOPTS_BOLT_PATH}/llvm-bolt" --version \
			> "${ED}/${bolt_data_suffix_dir}/llvm_bolt_version" || die
		"${_UOPTS_BOLT_PATH}/llvm-bolt" --version | sha512sum | cut -f 1 -d " " \
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
