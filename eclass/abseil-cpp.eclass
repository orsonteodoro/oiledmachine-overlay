# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS:  abseil-cpp.eclass
# @MAINTAINER:  Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS:  8
# @BLURB:  set multislot abseil-cpp config for build systems
# @DESCRIPTION:
# Helpers to support multislot abseil-cpp.

#
# Keep version/slot aligned
#
# LTS D11/U22 - grpc:3/1.30 - protobuf-cpp:3/3.12 - protobuf-python:3.12 - abseil-cpp:20200225 - re2:20220623 # PyTorch 2.9, OpenCV
# LTS D12/U24 - grpc:3/1.51 - protobuf-cpp:3/3.21 - protobuf-python:4.21 - abseil-cpp:20220623 - re2:20220623 # Tensorflow 2.17, JAX
# Rolling G23 - grpc:4/1.62 - protobuf-cpp:4/4.25 - protobuf-python:4.25 - abseil-cpp:20240116 - re2:20220623 # Apache Arrow
# Rolling G23 - grpc:5/1.71 - protobuf-cpp:5/5.29 - protobuf-python:5.29 - abseil-cpp:20240722 - re2:20250512 # TensorFlow 2.20, LocalAI
# Rolling G23 - grpc:6/1.75 - protobuf-cpp:6/6.33 - protobuf-python:6.33 - abseil-cpp:20250512 - re2:20250512
#
# abseil-cpp:20230125 - misc apps/libs
# abseil-cpp:20220623 - re2 (c++14)
# abseil-cpp:20240116 - re2 (c++17)
# abseil-cpp:20250814 - orphaned
#

case ${EAPI:-0} in
	[8]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_ABSEIL_CPP_ECLASS} ]] ; then
_ABSEIL_CPP_ECLASS=1

inherit flag-o-matic

# @FUNCTION:  abseil-cpp_src_configure
# @DESCRIPTION:
# Update all flags for C/C++ for autotools or meson based projects.
#
# Example:
#
# ABSEIL_CPP_LINK_MODE="direct"
# ABSEIL_CPP_SLOT="20250814"
#
# inherit abseil-cpp
#
# src_configure() {
#   # For auto adding:
#   # C/C++ include headers
#   # LD linker flags
#   # RPATH correction to find multislotted dynamic libraries
#   abseil-cpp_src_configure
#
#   # Print or sed patch broken build files below.
#   einfo "ABSEIL_CPP_CFLAGS:  ${ABSEIL_CPP_CFLAGS}"
#   einfo "ABSEIL_CPP_LDFLAGS:  ${ABSEIL_CPP_LDFLAGS}"
#   econf
# }
#
abseil-cpp_src_configure() {
	local _ABSEIL_CPP_SLOT=""
	if [[ "${ABSEIL_CPP_PV}" ]] ; then
		_ABSEIL_CPP_SLOT="${ABSEIL_CPP_PV%.*}"
	elif [[ "${ABSEIL_CPP_SLOT}" ]] ; then
		_ABSEIL_CPP_SLOT="${ABSEIL_CPP_SLOT%.*}"
	else
eerror "QA:  Set either ABSEIL_CPP_PV or ABSEIL_CPP_SLOT"
		die
	fi
	local libdir=$(get_libdir)

	# Sanitize/isolate multiabi pollution from logs
	filter-flags \
		"-I/usr/lib/abseil-cpp/*/include" \
		"-Wl,-L/usr/lib/abseil-cpp/*" \
		"-Wl,-rpath,/usr/lib/abseil-cpp/*" \
		"-L/usr/lib/abseil-cpp/*" \
		"--rpath=/usr/lib/abseil-cpp/*"

	append-flags "-I/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/include"

	# For manual configuration or sed patch
	if [[ ${ABSEIL_CPP_LINK_MODE:-"indirect"} == "indirect" ]] ; then
		# For manual configuration or sed patch
		export ABSEIL_CPP_CFLAGS="-I/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/include"
		export ABSEIL_CPP_CXXFLAGS="${ABSEIL_CPP_CXXFLAGS}"
		export ABSEIL_CPP_LDFLAGS="-Wl,-L/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir} -Wl,-rpath,/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir}"

		append-ldflags \
			"-Wl,-L/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir}" \
			"-Wl,-rpath,/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir}"
	else
		export ABSEIL_CPP_CFLAGS="-I/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/include"
		export ABSEIL_CPP_CXXFLAGS="${ABSEIL_CPP_CXXFLAGS}"
		export ABSEIL_CPP_LDFLAGS="-L/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir} --rpath=/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir}"

		append-ldflags \
			"-L/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir}" \
			"--rpath=/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir}"
	fi

	# Sanitize/isolate
	LD_LIBRARY_PATH=$(echo "${LD_LIBRARY_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/abseil-cpp/|d" | tr $'\n' ":")
	PKG_CONFIG_PATH=$(echo "${PKG_CONFIG_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/abseil-cpp/|d" | tr $'\n' ":")

	export LD_LIBRARY_PATH="${ESYSROOT}/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir}/pkgconfig:${LD_LIBRARY_PATH}"
	export PKG_CONFIG_PATH="${ESYSROOT}/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir}/pkgconfig:${PKG_CONFIG_PATH}"
}

# @FUNCTION:  abseil-cpp_python_configure
# @DESCRIPTION:
# Alias for ebuild style consistency
#
# Example:
#
# ABSEIL_CPP_LINK_MODE="direct"
# ABSEIL_CPP_SLOT="20250814"
#
# inherit abseil-cpp
#
# python_configure() {
#   # For auto adding:
#   # C/C++ include headers
#   # LD linker flags
#   # RPATH correction to find multislotted dynamic libraries
#   abseil-cpp_src_configure
# }
#
abseil-cpp_python_configure() {
	grpc_src_configure
}

# @FUNCTION:  abseil-cpp_append_cmake
# @DESCRIPTION:
# Dump absl location into mycmakeargs for CMake's find_package().
#
# Example:
#
# ABSEIL_CPP_SLOT="20250814"
#
# inherit abseil-cpp cmake
#
# src_configure() {
#   # RPATH correction to find multislotted dynamic libraries
#   abseil-cpp_src_configure
#
#   local mycmakeargs=(
#     $(abseil-cpp_append_cmake)
#   )
#   cmake_src_configure
# }
#
abseil-cpp_append_cmake() {
	local _ABSEIL_CPP_SLOT=""
	if [[ "${ABSEIL_CPP_PV}" ]] ; then
		_ABSEIL_CPP_SLOT="${ABSEIL_CPP_PV%.*}"
	elif [[ "${ABSEIL_CPP_SLOT}" ]] ; then
		_ABSEIL_CPP_SLOT="${ABSEIL_CPP_SLOT%.*}"
	else
eerror "QA:  Set either ABSEIL_CPP_PV or ABSEIL_CPP_SLOT"
		die
	fi

	local name
	if [[ -n "${1}" ]] ; then
		name="${1}"
	else
		name="absl"
	fi
	local libdir=$(get_libdir)
	echo "-D${name}_DIR=/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir}/cmake/absl"
}

fi
