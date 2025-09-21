# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
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
# # gcc-config -l reports the currently selected libstdcxx but setting CC= cannot do it properly.
# local gcc_current_profile_slot=$(gcc-config -l | grep "*" | cut -f 3 -d " ")
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
		# See https://gcc.gnu.org/onlinedocs/libstdc++/manual/abi.html
		# ["$GLIBCXX"]=$GCC_PV
		['GCC_14']="3.4.33"
		['GCC_14_1_0']="3.4.33"
		['GCC_13']="3.4.32"
		['GCC_13_2_0']="3.4.32"
		['GCC_13_1_0']="3.4.31"
		['GCC_12']="3.4.30"
		['GCC_12_1_0']="3.4.30"
		['GCC_11']="3.4.29"
		['GCC_11_1_0']="3.4.29"
		['GCC_10']="3.4.28"
		['GCC_10_1_0']="3.4.28"
		['GCC_9']="3.4.27"
		['GCC_9_2_0']="3.4.27"
		['GCC_9_1_0']="3.4.26"
		['GCC_8']="3.4.25"
		['GCC_8_1_0']="3.4.25"
		['GCC_7']="3.4.24"
		['GCC_7_2_0']="3.4.24"
		['GCC_7_1_0']="3.4.23"
		['GCC_6']="3.4.22"
		['GCC_6_1_0']="3.4.22"
		['GCC_5']="3.4.21"
		['GCC_5_1_0']="3.4.21"
		['GCC_4']="3.4.20"
		['GCC_4_9_0']="3.4.20"
		['GCC_4_8_3']="3.4.19"
		['GCC_4_8_0']="3.4.18"
		['GCC_4_7_0']="3.4.17"
		['GCC_4_6_1']="3.4.16"
		['GCC_4_6_0']="3.4.15"
		['GCC_4_5_0']="3.4.14"
		['GCC_4_4_2']="3.4.13"
		['GCC_4_4_1']="3.4.12"
		['GCC_4_4_0']="3.4.11"
		['GCC_4_3_0']="3.4.10"
		['GCC_4_2_0']="3.4.9"
		['GCC_4_1_1']="3.4.8"
		['GCC_4_0_3']="3.4.7"
		['GCC_4_0_2']="3.4.6"
		['GCC_4_0_1']="3.4.5"
		['GCC_4_0_0']="3.4.4"
		['GCC_3']="3.4.3"
		['GCC_3_4_3']="3.4.3"
		['GCC_3_4_2']="3.4.2"
		['GCC_3_4_1']="3.4.1"
		['GCC_3_4']="3.4.0"
		['GCC_3_3_3']="3.2.3"
		['GCC_3_3_0']="3.2.2"
		['GCC_3_2_1']="3.2.1"
		['GCC_3_2_0']="3.2"
		['GCC_3_1_1']="3.1"
	)
	declare -A glibcxx_to_gcc=(
	# See https://gcc.gnu.org/onlinedocs/libstdc++/manual/abi.html
		# ["$GLIBCXX"]=$GCC_PV
		['GLIBCXX_3_4_33']="14.1.0"
		['GLIBCXX_3_4_32']="13.2.0"
		['GLIBCXX_3_4_31']="13.1.0"
		['GLIBCXX_3_4_30']="12.1.0"
		['GLIBCXX_3_4_29']="11.1.0"
		['GLIBCXX_3_4_28']="10.1.0"
		['GLIBCXX_3_4_27']="9.2.0"
		['GLIBCXX_3_4_26']="9.1.0"
		['GLIBCXX_3_4_25']="8.1.0"
		['GLIBCXX_3_4_24']="7.2.0"
		['GLIBCXX_3_4_23']="7.1.0"
		['GLIBCXX_3_4_22']="6.1.0"
		['GLIBCXX_3_4_21']="5.1.0"
		['GLIBCXX_3_4_20']="4.9.0"
		['GLIBCXX_3_4_19']="4.8.3"
		['GLIBCXX_3_4_18']="4.8.0"
		['GLIBCXX_3_4_17']="4.7.0"
		['GLIBCXX_3_4_16']="4.6.1"
		['GLIBCXX_3_4_15']="4.6.0"
		['GLIBCXX_3_4_14']="4.5.0"
		['GLIBCXX_3_4_13']="4.4.2"
		['GLIBCXX_3_4_12']="4.4.1"
		['GLIBCXX_3_4_11']="4.4.0"
		['GLIBCXX_3_4_10']="4.3.0"
		['GLIBCXX_3_4_9']="4.2.0"
		['GLIBCXX_3_4_8']="4.1.1"
		['GLIBCXX_3_4_7']="4.0.3"
		['GLIBCXX_3_4_6']="4.0.2"
		['GLIBCXX_3_4_5']="4.0.1"
		['GLIBCXX_3_4_4']="4.0.0"
		['GLIBCXX_3_4_3']="3.4.3"
		['GLIBCXX_3_4_2']="3.4.2"
		['GLIBCXX_3_4_1']="3.4.1"
		['GLIBCXX_3_4_0']="3.4"
		['GLIBCXX_3_2_3']="3.3.3"
		['GLIBCXX_3_2_2']="3.3.0"
		['GLIBCXX_3_2_1']="3.2.1"
		['GLIBCXX_3_2']="3.2.0"
		['GLIBCXX_3_1']="3.1.1"
	)
	local glibcxx_ver=$(strings "${library_path}" \
		| grep "^GLIBCXX" \
		| sort \
		| tail -n 1 \
		| cut -f 2 -d "_")
	if true ; then
		local library_glibcxx_version="${glibcxx_ver}"
		local library_gcc_version="${glibcxx_to_gcc[GLIBCXX_${library_glibcxx_version//./_}]}"
ewarn
ewarn "${package} needs to be rebuilt with gcc ${gcc_version} or earlier."
ewarn "Use per-package cflags to avoid linking issues with versioned symbols."
ewarn
ewarn "Library:\t\t${library_path}"
ewarn "Actual version:\tGCC ${library_gcc_version} (GLIBCXX ${glibcxx_ver})"
ewarn "Expected version:\tGCC ${gcc_version} (GLIBCXX ${gcc_to_glibcxx[GCC_${gcc_version//./_}]})"
	if ver_test "${library_gcc_version}" -le "${gcc_version}" ; then
ewarn "Compatible:\t\tYes"
	else
eerror "Compatible:\t\tNo"
	fi
echo -e
echo -e "# Contents of /etc/portage/env/gcc-${gcc_version}.conf:"
echo -e
echo -e "CC=\"gcc-${gcc_version}\""
echo -e "CXX=\"g++-${gcc_version}\""
echo -e "CPP=\"\${CC} -E\""
echo -e "AR=\"ar\""
echo -e "NM=\"nm\""
echo -e "OBJCOPY=\"objcopy\""
echo -e "OBJDUMP=\"objdump\""
echo -e "READELF=\"readelf\""
echo -e "STRIP=\"strip\""
echo -e
echo -e "# Contents of /etc/portage/package.env:"
echo -e
echo -e "${package} gcc-${gcc_version}.conf"
echo -e
		if ver_test "${glibcxx_ver}" -gt "${gcc_version}" ; then
eerror "Detected incompatible version symbol."
			die
		fi
	fi
}
