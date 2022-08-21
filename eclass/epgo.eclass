# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: epgo-single.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: EPGO
# @DESCRIPTION:
# This ebuild is to perform a PGO step on every point release.
# It exist to reduce the time cost.

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

IUSE+=" epgo"

EPGO_PROFILES_DIR=${EPGO_PROFILES_DIR:-"/var/lib/pgo-profiles"}
_EPGO_PV=$(ver_cut 1-2 ${PV}) # default
EPGO_PV=${EPGO_PV:-${_EPGO_PV}}
EPGO_CATPN_DATA_DIR=${EPGO_DATA_DIR:-"${EPGO_PROFILES_DIR}/${CATEGORY}/${PN}"}
EPGO_DATA_DIR=${EPGO_DATA_DIR:-"${EPGO_PROFILES_DIR}/${CATEGORY}/${PN}/${EPGO_PV}"}

inherit flag-o-matic toolchain-funcs

# @FUNCTION: _epgo_check_pgo
# @DESCRIPTION:
# Checks the preferred trainer group.
# You can use an existing or completely isolated group.
# Existing groups can be users, wheel
# New groups can be epgo, pgo, etc.
_epgo_check_pgo() {
	if use epgo ; then
ewarn
ewarn "PGO support is still (WIP)."
ewarn
		if [[ -z "${EPGO_GROUP}" ]] ; then
eerror
eerror "The EPGO_GROUP must be defined either in ${EPREFIX}/etc/portage/make.conf or"
eerror "in a per-package env file.  Users who are not a member of this group"
eerror "cannot generate PGO profile data with this program."
eerror
eerror "Example:"
eerror
eerror "  EPGO_GROUP=\"epgo\""
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
}

# @FUNCTION: _epgo_prepare_pgo
# @DESCRIPTION:
# Copies an existing profile snapshot into build space.
_epgo_prepare_pgo() {
	local pgo_data_suffix_dir="${EPREFIX}${EPGO_DATA_DIR}/${EPGO_SUFFIX}"
	local pgo_data_staging_dir="${T}/pgo-${EPGO_SUFFIX}"

	mkdir -p "${pgo_data_staging_dir}" || die
	if [[ -e "${pgo_data_suffix_dir}" ]] ; then
		cp -aT "${pgo_data_suffix_dir}" "${pgo_data_staging_dir}" || die
	fi
	touch "${pgo_data_staging_dir}/compiler_fingerprint" || die
}

# @FUNCTION: epgo_src_prepare
# @DESCRIPTION:
# You must call this inside the multibuild loop in src_prepare or in a
# *src_prepare multibuild variant.  It has to be inside the loop so that the
# EPGO_IMPL can divide the pgo profile per ABI or module.  You must define
# EPGO_IMPL to divide PGO profiles if impl exists for example headless and
# non-headless builds.
epgo_src_prepare() {
	EPGO_SUFFIX=${EPGO_SUFFIX:-"${MULTILIB_ABI_FLAG}.${ABI}"}
	_epgo_prepare_pgo
}

# @FUNCTION: _epgo_configure
# @DESCRIPTION:
# Setup compiler flags
_epgo_configure() {
	filter-flags '-fprofile*'
	local pgo_data_suffix_dir="${EPREFIX}${EPGO_DATA_DIR}/${EPGO_SUFFIX}"
	local pgo_data_staging_dir="${T}/pgo-${EPGO_SUFFIX}"
	mkdir -p "${ED}/${pgo_data_dir}" || die
	use epgo && addpredict "${EPREFIX}${EPGO_PROFILES_DIR}"
	if [[ "${PGO_PHASE}" == "PGI" ]] ; then
		if tc-is-clang ; then
			append-flags -fprofile-generate="${pgo_data_suffix_dir}"
		elif tc-is-gcc ; then
			append-flags -fprofile-generate -fprofile-dir="${pgo_data_suffix_dir}"
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
			if ! ls "${BUILD_DIR}/"*".profraw" 2>/dev/null 1>/dev/null ; then
eerror
eerror "Missing *.profraw files"
eerror
				die
			fi
			llvm-profdata merge -output="${pgo_data_staging_dir}/custom-pgo.profdata" \
				"${pgo_data_staging_dir}" || die
			append-flags -fprofile-use="${pgo_data_staging_dir}/custom-pgo.profdata"
		elif tc-is-gcc ; then
			append-flags -fprofile-use -fprofile-dir="${pgo_data_staging_dir}"
		fi
	fi
}

# @FUNCTION: epgo_src_configure
# @DESCRIPTION:
# You must call this in *src_configure
epgo_src_configure() {
	EPGO_SUFFIX=${EPGO_SUFFIX:-"${MULTILIB_ABI_FLAG}.${ABI}"}
	_epgo_configure
}

# @FUNCTION: _epgo_meets_pgo_requirements
# @DESCRIPTION:
# Checks if requirements are met
_epgo_meets_pgo_requirements() {
	if use epgo ; then
		local pgo_data_staging_dir="${T}/pgo-${EPGO_SUFFIX}"

		if [[ -z "${CC}" ]] ; then
# This shouldn't set the CC but we have to for -dumpmachine.
			export CC=$(tc-getCC)
			export CXX=$(tc-getCXX)
		fi
einfo
einfo "CC=${CC}"
einfo "CXX=${CXX}"
einfo

		# Has same compiler?
		if tc-is-gcc ; then
			local actual=$("${CC}" -dumpmachine | sha512sum | cut -f 1 -d " ")
			local expected=$(cat "${pgo_data_staging_dir}/compiler_fingerprint")
			if [[ "${actual}" != "${expected}" ]] ; then
ewarn
ewarn "GCC incompatable:"
ewarn
ewarn "actual: ${actual}"
ewarn "expected: ${expected}"
ewarn
				return 1
			fi
		elif tc-is-clang ; then
			local actual=$("${CC}" -dumpmachine | sha512sum | cut -f 1 -d " ")
			local expected=$(cat "${pgo_data_staging_dir}/compiler_fingerprint")
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
		if tc-is-gcc && find "${pgo_data_staging_dir}" -name "*.gcda" \
			2>/dev/null 1>/dev/null ; then
			:; # pass
		elif tc-is-clang && find "${pgo_data_staging_dir}" -name "*.profraw" \
			2>/dev/null 1>/dev/null ; then
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
	EPGO_SUFFIX=${EPGO_SUFFIX:-"${MULTILIB_ABI_FLAG}.${ABI}"}
	_epgo_meets_pgo_requirements
	local ret=$?
	if ! use epgo ; then
		result="NO_PGO"
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
		EPGO_SUFFIX=${EPGO_SUFFIX:-"${MULTILIB_ABI_FLAG}.${ABI}"}
		local pgo_data_suffix_dir="${EPGO_DATA_DIR}/${EPGO_SUFFIX}"
		keepdir "${pgo_data_suffix_dir}"
		fowners root:${EPGO_GROUP} "${pgo_data_suffix_dir}"
		fperms 0775 "${pgo_data_suffix_dir}"
		keepdir "${PGO}"

		if [[ -z "${CC}" ]] ; then
			# It should be done earlier.
			export CC=$(tc-getCC)
			export CXX=$(tc-getCXX)
		fi

		if tc-is-gcc ; then
			"${CC}" -dumpmachine \
				> "${ED}/${pgo_data_suffix_dir}/compiler" || die
			"${CC}" -dumpmachine | sha512sum | cut -f 1 -d " " \
				> "${ED}/${pgo_data_suffix_dir}/compiler_fingerprint" || die
		elif tc-is-clang ; then
			"${CC}" -dumpmachine \
				> "${ED}/${pgo_data_suffix_dir}/compiler" || die
			"${CC}" -dumpmachine | sha512sum | cut -f 1 -d " " \
				> "${ED}/${pgo_data_suffix_dir}/compiler_fingerprint" || die
		fi
	fi
}

# @FUNCTION: _epgo_wipe_pgo_profile
# @DESCRIPTION:
# Reinitalizes the PGO profile immediately after PGI built
_epgo_wipe_pgo_profile() {
	if [[ "${PGO_PHASE}" =~ "PGI" ]] ; then
einfo
einfo "Wiping previous PGO profile"
einfo
		local pgo_data_dir="${EROOT}${EPGO_DATA_DIR}"
		find "${pgo_data_dir}" -type f \
			-not -name "compiler_fingerprint" \
			-not -name "compiler" \
			-delete
	fi
}

# @FUNCTION: _epgo_delete_old_pgo_profiles
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
			local pgo_data_dir="${EROOT}${EPGO_CATPN_DATA_DIR}/${pv}"
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
