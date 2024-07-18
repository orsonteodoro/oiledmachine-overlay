# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: check-glibcxx-ver.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Check version symbol compatibility
# @DESCRIPTION:
# Check version symbol compatibility

# @FUNCTION: check_pkg_glibcxx
# @INTERNAL
# @DESCRIPTION:
# Check version symbol library compatibility with glibcxx
#
# Examples:
# local gcc_current_profile=$(gcc-config -c)
# local gcc_current_profile_slot=${gcc_current_profile##*-}
# check_pkg_glibcxx "dev-libs/boost" "/usr/$(get_libdir)/libboost_program_options.so" "${gcc_current_profile_slot}"
#
# check_pkg_glibcxx "dev-libs/boost" "/usr/$(get_libdir)/libboost_program_options.so" "12"
#
#
check_pkg_glibcxx() {
	local package="${1}"
	local library_path="${2}"
	local gcc_version="${3}"
	declare -A gcc_to_glibcxx=(
		["8"]="3.4.28" # guessed
		["9"]="3.4.27" # guessed
		["10"]="3.4.28"
		["11"]="3.4.29"
		["12"]="3.4.30"
		["13"]="3.4.31" # guessed
		["13"]="3.4.32"
		["14"]="3.4.34"
		["15"]="3.4.35"
		["16"]="3.4.36"
		["17"]="3.4.37"
	)
	declare -A glibcxx_to_gcc=(
		["3.4.28"]="8" # guessed
		["3.4.27"]="9" # guessed
		["3.4.28"]="10"
		["3.4.29"]="11"
		["3.4.30"]="12"
		["3.4.31"]="13" # guessed
		["3.4.32"]="13"
		["3.4.34"]="14"
		["3.4.35"]="15"
		["3.4.36"]="16"
		["3.4.37"]="17"
	)
	local glibcxx_ver=$(strings "${library_path}" \
		| grep "^GLIBCXX" \
		| sort \
		| tail -n 1 \
		| cut -f 2 -d "_")
	if true ; then
		local library_glibcxx_version="${glibcxx_ver}"
		local library_gcc_version="${glibcxx_to_gcc[${library_glibcxx_version}]}"
ewarn
ewarn "${package} needs to be rebuilt with gcc ${gcc_version} or earlier."
ewarn "Use per-package cflags to avoid linking issues with versioned symbols."
ewarn
ewarn "Library:\t\t${library_path}"
ewarn "Actual version:\tGCC ${library_gcc_version} (GLIBCXX ${glibcxx_ver})"
ewarn "Expected version:\tGCC ${gcc_version} (GLIBCXX ${gcc_to_glibcxx[${gcc_version}]})"
	if ver_test "${library_gcc_version}" -le "${gcc_version}" ; then
ewarn "Compatible:\t\tYes"
	else
eerror "Compatible:\t\tNo"
	fi
ewarn
ewarn "Contents of /etc/portage/env/gcc-${gcc_version}.conf:"
ewarn "CC=\"gcc-${gcc_version}\""
ewarn "CXX=\"g++-${gcc_version}\""
ewarn "CPP=\"\${CXX} -E\""
ewarn "AR=\"ar\""
ewarn "NM=\"nm\""
ewarn "OBJCOPY=\"objcopy\""
ewarn "OBJDUMP=\"objdump\""
ewarn "READELF=\"readelf\""
ewarn "STRIP=\"strip\""
ewarn
ewarn "Contents of /etc/portage/package.env:"
ewarn "${package} gcc-${gcc_version}.conf"
ewarn
		if ver_test "${glibcxx_ver}" -gt "${gcc_version}" ; then
eerror "Detected incompatible version symbol."
			die
		fi
	fi
}
