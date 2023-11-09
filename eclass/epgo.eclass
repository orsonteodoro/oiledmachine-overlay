# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: epgo.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: EPGO
# @DESCRIPTION:
# This ebuild is to perform a PGO step on every point release.
# It exist to reduce the time cost.  Wayland only apps should use this
# instead of the tpgo eclass.

# It is preferred to have this as a bashrc.  Due to a lack of ABI bashrc hooks
# in multilib_src_configure or any derivative of multibuild*, it must be done in
# eclass level.

# Requirements:
# No active trainer.  Trainer is done passively
# Use in large packages that have hours of compile time or high estimated MLOC.
# For smaller packages, use tpgo.eclass (for 3 step pgo - in planning)

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

_EPGO_ECLASS=1

# @ECLASS_VARIABLE: UOPTS_PGO_FORCE_PGI
# @DESCRIPTION:
# Temporarily set to 1 to build with PGI (instrumentation) flags.
# Only the user can decide.  Do not set it in the ebuild.
# Example:
# UOPTS_PGO_FORCE_PGI=1 emerge foo

# @ECLASS_VARIABLE: UOPTS_IMPLS (OPTIONAL)
# @DESCRIPTION:
# This variable should be expliclity before calling any epgo function.
# Sets the suffix to isolate PGO profiles (e.g. 32-bit, 64-bit).  Different
# implementations should attach and define impl like one of the examples
# below.
# UOPTS_IMPLS="_${impl}"
# UOPTS_IMPLS="_${impl1}_${impl2}"
# UOPTS_IMPLS="_${impl1}_${impl2}_${impl3}"
#
# Example:
# impl="headless"
# UOPTS_IMPLS="_${impl}"
# epgo_src_prepare
#

# TIPS:

# If using GCC PGO, you may need to add -lgcov to LIBS or modify the build
# files but only in PGI phase.

inherit flag-o-matic toolchain-funcs

IUSE+=" epgo"

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

# @FUNCTION: _epgo_check_pgo
# @INTERNAL
# @DESCRIPTION:
# Checks the preferred trainer group.
# You can use an existing or completely isolated group.
# Existing groups can be users, wheel
# New groups can be epgo, pgo, etc.
_epgo_check_pgo() {
	if use epgo ; then
		if [[ -z "${UOPTS_PGO_GROUP}" ]] ; then
eerror
eerror "The UOPTS_PGO_GROUP must be defined either in ${EPREFIX}/etc/portage/make.conf or"
eerror "in a per-package env file.  Users who are not a member of this group"
eerror "cannot generate PGO profile data with this program."
eerror
eerror "Example:"
eerror
eerror "  UOPTS_PGO_GROUP=\"epgo\""
eerror
			die
		fi
	fi
}

# @FUNCTION: epgo_setup
# @DESCRIPTION:
# You must call this in pkg_setup
epgo_setup() {
	_epgo_check_pgo

	if [[ -z "${_UOPTS_ECLASS}" ]] ; then
eerror "The epgo.eclass must be used with uopts.eclass.  Do not inherit epgo"
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

# @FUNCTION: _epgo_prepare_pgo
# @INTERNAL
# @DESCRIPTION:
# Copies an existing profile snapshot into build space.
_epgo_prepare_pgo() {
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

# @FUNCTION: epgo_src_prepare
# @DESCRIPTION:
# You must call this inside the multibuild loop in src_prepare or in a
# *src_prepare multibuild variant.  It has to be inside the loop so that the
# UOPTS_IMPLS can divide the pgo profile per ABI or module.  You must define
# UOPTS_IMPLS to divide PGO profiles if impl exists for example headless and
# non-headless builds.
epgo_src_prepare() {
	_UOPTS_PGO_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${UOPTS_IMPLS}"
	_epgo_prepare_pgo
}

# @FUNCTION: _epgo_append_all
# @INTERNAL
# @DESCRIPTION:
# Append all flags to {C,CXX,LD}FLAGS
_epgo_append_flags() {
	append-flags ${@}
	append-ldflags ${@}
}

# @FUNCTION: _epgo_configure
# @INTERNAL
# @DESCRIPTION:
# Setup compiler flags
_epgo_configure() {
	filter-flags '-fprofile*'
	local pgo_data_suffix_dir="${EPREFIX}${_UOPTS_PGO_DATA_DIR}/${_UOPTS_PGO_SUFFIX}"
	local pgo_data_staging_dir="${T}/pgo-${_UOPTS_PGO_SUFFIX}"
	mkdir -p "${ED}/${pgo_data_dir}" || die
	use epgo && addpredict "${EPREFIX}${UOPTS_PGO_PROFILES_DIR}"
	if [[ "${PGO_PHASE}" == "PGI" ]] ; then
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
			_epgo_append_flags \
				-fprofile-generate="${pgo_data_suffix_dir}"
		elif tc-is-gcc ; then
			_epgo_append_flags \
				-fprofile-generate \
				-fprofile-dir="${pgo_data_suffix_dir}"
			[[ "${UOPTS_PGO_PORTABLE}" == "1" || "${UOPTS_PGO_EVENT_BASED}" == "1" ]] \
				&& _epgo_append_flags -fprofile-partial-training
		else
eerror
eerror "Only GCC and Clang are supported for PGO."
eerror
			die
		fi
	elif [[ "${PGO_PHASE}" == "PGO" ]] ; then
		if tc-is-clang ; then
einfo
einfo "Merging PGO data to generate a PGO profile"
einfo
			if ! ls "${pgo_data_staging_dir}/"*".profraw" 2>/dev/null 1>/dev/null ; then
eerror
eerror "Missing *.profraw files"
eerror
				die
			fi
			llvm-profdata \
				merge \
				-output="${pgo_data_staging_dir}/pgo-custom.profdata" \
				$(find "${pgo_data_staging_dir}" -name "*.profraw") || die
			_epgo_append_flags \
				-fprofile-use="${pgo_data_staging_dir}/pgo-custom.profdata"
		elif tc-is-gcc ; then
			_epgo_append_flags \
				-fprofile-correction \
				-fprofile-use \
				-fprofile-dir="${pgo_data_staging_dir}"
			[[ "${UOPTS_PGO_PORTABLE}" == "1" || "${UOPTS_PGO_EVENT_BASED}" == "1" ]] \
				&& _epgo_append_flags -fprofile-partial-training
		fi
	fi
}

# @FUNCTION: epgo_src_configure
# @DESCRIPTION:
# You must call this in *src_configure
epgo_src_configure() {
	_UOPTS_PGO_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${UOPTS_IMPLS}"
	_epgo_configure
}

# @FUNCTION: _epgo_meets_pgo_requirements
# @INTERNAL
# @DESCRIPTION:
# Checks if requirements are met
_epgo_meets_pgo_requirements() {
	if use epgo ; then
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
			|| die "You must call uopts_src_prepare before calling epgo_get_phase"
		# Has same compiler?
		if tc-is-gcc ; then
			local compile_major_pv="$(gcc-major-version)"
			local compiler_pv="$(gcc-version)" # major.minor
			local raw_pv=$(best_version "=sys-devel/gcc-${compile_major_pv}*" \
				| sed -e "s|sys-devel/gcc-||g")
			local pgo_slot=$(ver_cut 1-2 "${compiler_pv}")
			if [[ "${raw_pv}" =~ "9999" ]] ; then
				# Live unstable ABI.
				local build_timestamp=$(portageq metadata "/${BROOT}" "installed" "sys-devel/gcc-${raw_pv}" "BUILD_TIME")
				pgo_slot="${raw_pv}-${build_timestamp}"
			elif [[ "${raw_pv}" =~ "_p" ]] ; then
				# Live snapshot with unstable ABI.
				pgo_slot="${raw_pv}"
			fi
			local triple=$(${_CC} -dumpmachine) # For ABI and LIBC consistency.
			local actual="${pgo_slot};${triple}"
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
			local pgo_slot="${sys_index_ver}"
			local triple=$(${_CC} -dumpmachine) # For ABI and LIBC consistency.
			local actual="${pgo_slot};${triple}"
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
		elif tc-is-clang && (( ${nlines2} > 0 ))  ; then
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

# @FUNCTION: epgo_get_phase
# @DESCRIPTION:
# Reports the current PGO phase
epgo_get_phase() {
	local result="NO_PGO"
	_UOPTS_PGO_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${UOPTS_IMPLS}"
	_epgo_meets_pgo_requirements
	local ret=$?
	if ! use epgo ; then
		result="NO_PGO"
	elif use epgo && [[ "${UOPTS_PGO_FORCE_PGI}" == "1" ]] ; then
		result="PGI"
	elif use epgo && (( ${ret} == 0 )) ; then
		result="PGO"
	elif use epgo && (( ${ret} == 1 )) ; then
		result="PGI"
	elif use epgo && (( ${ret} == 2 )) ; then
		result="NO_PGO"
	fi
	echo "${result}"
}

# @FUNCTION: epgo_src_install
# @DESCRIPTION:
# You must call it in *src_install
epgo_src_install() {
	if use epgo ; then
		_UOPTS_PGO_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${UOPTS_IMPLS}"
		local pgo_data_suffix_dir="${_UOPTS_PGO_DATA_DIR}/${_UOPTS_PGO_SUFFIX}"
		keepdir "${pgo_data_suffix_dir}"
		fowners root:${UOPTS_PGO_GROUP} "${pgo_data_suffix_dir}"
		fperms 0775 "${pgo_data_suffix_dir}"

		if [[ -z "${CC}" ]] ; then
			# It should be done earlier.
			export CC=$(tc-getCC)
			export CXX=$(tc-getCXX)
		fi

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
			local pgo_slot=$(ver_cut 1-2 "${compiler_pv}")
			if [[ "${raw_pv}" =~ "9999" ]] ; then
				# Live unstable ABI.
				local build_timestamp=$(portageq metadata "/${BROOT}" "installed" "sys-devel/gcc-${raw_pv}" "BUILD_TIME")
				pgo_slot="${raw_pv}-${build_timestamp}"
			elif [[ "${raw_pv}" =~ "_p" ]] ; then
				# Live snapshot with unstable ABI.
				pgo_slot="${raw_pv}"
			fi
			local triple=$(${_CC} -dumpmachine) # For ABI and LIBC consistency.
			local fingerprint="${pgo_slot};${triple}"
			echo "gcc ${raw_pv}" \
				> "${ED}/${pgo_data_suffix_dir}/compiler_version" || die
			echo "${fingerprint}" \
				> "${ED}/${pgo_data_suffix_dir}/compiler_fingerprint" || die
		elif tc-is-clang ; then
	# Compatibility based on either specific unmerged .profraw version or
	# flexible merged .profdata version.  The latter is preferred.
			local clang_major_pv="$(clang-major-version)"
			local sys_index_ver=$(grep -E \
				-e " INSTR_PROF_INDEX_VERSION [0-9]+" \
				"${ESYSROOT}/usr/lib/llvm/${clang_major_pv}/include/llvm/ProfileData/InstrProfData.inc" \
	                        | cut -f 3 -d " ")
			local pgo_slot="${sys_index_ver}"
			local triple=$(${_CC} -dumpmachine) # For ABI and LIBC consistency.
			local fingerprint="${pgo_slot};${triple}"
			echo "clang ${compiler_pv}" \
				> "${ED}/${pgo_data_suffix_dir}/compiler_version" || die
			echo "${fingerprint}" \
				> "${ED}/${pgo_data_suffix_dir}/compiler_fingerprint" || die
		fi
	fi
}

# @FUNCTION: _epgo_wipe_pgo_profile
# @INTERNAL
# @DESCRIPTION:
# Reinitalizes the PGO profile immediately after PGI built
_epgo_wipe_pgo_profile() {
	if [[ "${PGO_PHASE}" =~ "PGI" ]] ; then
einfo
einfo "Wiping previous PGO profile"
einfo
		local pgo_data_dir="${EROOT}${_UOPTS_PGO_DATA_DIR}"
		find "${pgo_data_dir}" -type f \
			-not -name "compiler_fingerprint" \
			-not -name "compiler" \
			-delete
	fi
}

# @FUNCTION: _epgo_delete_old_pgo_profiles
# @INTERNAL
# @DESCRIPTION:
# Deletes all old pgo profiles
_epgo_delete_old_pgo_profiles() {
	if [[ -n "${REPLACING_VERSIONS}" ]] ; then
		local pvr
		for pvr in ${REPLACING_VERSIONS} ; do
			local pv=$(ver_cut 1-2 "${pvr}")
			if ver_test ${pv} -eq $(ver_cut 1-2 "${PV}") ; then
				# Don't delete permissions
				continue
			fi
			local pgo_data_dir="${EROOT}${_UOPTS_PGO_CATPN_DATA_DIR}/${pv}"
			if [[ -e "${pgo_data_dir}" ]] ; then
einfo "Removing old PGO profile for =${CATEGORY}/${PN}-${pvr}"
				rm -rf "${pgo_data_dir}" || true
			fi
		done
	fi
}

# @FUNCTION: epgo_pkg_postinst
# @DESCRIPTION:
# You must call this in pkg_postinst
epgo_pkg_postinst() {
	use epgo && _epgo_wipe_pgo_profile
	_epgo_delete_old_pgo_profiles
}
