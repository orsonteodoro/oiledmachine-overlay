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
# LTS D11/U22 - grpc:3/1.30 - protobuf-cpp:3/3.12 - protobuf-python:3/3.12 - abseil-cpp:20200225 - re2:20220623 # PyTorch 2.9
# LTS D12/U24 - grpc:3/1.51 - protobuf-cpp:3/3.21 - protobuf-python:4/4.21 - abseil-cpp:20220623 - re2:20220623 # Tensorflow 2.17, JAX
# Rolling G23 - grpc:4/1.62 - protobuf-cpp:4/4.25 - protobuf-python:4/4.25 - abseil-cpp:20240116 - re2:20220623 # Apache Arrow
# Rolling G23 - grpc:5/1.71 - protobuf-cpp:5/5.29 - protobuf-python:5/5.29 - abseil-cpp:20240722 - re2:20240116 # TensorFlow 2.20, LocalAI
# Rolling G23 - grpc:6/1.75 - protobuf-cpp:6/6.33 - protobuf-python:6/6.33 - abseil-cpp:20250512 - re2:20240116
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

# @FUNCTION:  abseil-cpp_append_flags_direct
# @DESCRIPTION:
# Append flags for C/C++ while passing LDFLAGS directly to linker
#
# Example:
#
# ABSEIL_CPP_SLOT="20250814"
# inherit abseil-cpp
#
# src_configure() {
#   abseil-cpp_append_flags_direct
#   einfo "ABSEIL_CPP_CFLAGS:  ${ABSEIL_CPP_CFLAGS}"
#   einfo "ABSEIL_CPP_LDFLAGS:  ${ABSEIL_CPP_LDFLAGS}"
# }
#
abseil-cpp_append_flags_direct() {
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

	# Sanitize/isolate
	filter-flags \
		"-I/usr/lib/abseil-cpp/*/include" \
		"-L/usr/lib/abseil-cpp/*" \
		"--rpath,/usr/lib/abseil-cpp/*"

	# For manual configuration or sed patch
	export ABSEIL_CPP_CFLAGS="-I/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/include"
	export ABSEIL_CPP_CXXFLAGS="${ABSEIL_CPP_CXXFLAGS}"
	export ABSEIL_CPP_LDFLAGS="-L/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir} --rpath=/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir}"

	append-flags "-I/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/include"
	append-ldflags \
		"-L/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir}" \
		"--rpath=/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir}"
}

# @FUNCTION:  abseil-cpp_append_flags_indirect
# @DESCRIPTION:
# Append flags for C/C++ while passing LDFLAGS indirectly to linker
#
# Example:
#
# ABSEIL_CPP_SLOT="20250814"
# inherit abseil-cpp
#
# src_configure() {
#   abseil-cpp_append_flags_indirect
#   einfo "ABSEIL_CPP_CFLAGS:  ${ABSEIL_CPP_CFLAGS}"
#   einfo "ABSEIL_CPP_LDFLAGS:  ${ABSEIL_CPP_LDFLAGS}"
# }
#
abseil-cpp_append_flags_indirect() {
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

	# Sanitize/isolate
	filter-flags \
		"-I/usr/lib/abseil-cpp/*/include" \
		"-Wl,-L/usr/lib/abseil-cpp/*" \
		"-Wl,-rpath,/usr/lib/abseil-cpp/*"

	# For manual configuration or sed patch
	export ABSEIL_CPP_CFLAGS="-I/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/include"
	export ABSEIL_CPP_CXXFLAGS="${ABSEIL_CPP_CXXFLAGS}"
	export ABSEIL_CPP_LDFLAGS="-Wl,-L/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir} -Wl,-rpath,/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir}"

	append-flags "-I/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/include"
	append-ldflags \
		"-Wl,-L/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir}" \
		"-Wl,-rpath,/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir}"
}

# @FUNCTION:  abseil-cpp_append_mycmakeargs
# @DESCRIPTION:
# Dump absl location into mycmakeargs
#
# Example:
#
# ABSEIL_CPP_SLOT="20250814"
# inherit abseil-cpp
#
# src_configure() {
#   local mycmakeargs=(
#     $(abseil-cpp_append_mycmakeargs)
#   )
# }
#
abseil-cpp_append_mycmakeargs() {
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

# @FUNCTION:  abseil-cpp_append_pkgconfig
# @DESCRIPTION:
# Dump absl location into PKG_CONFIG_PATH
#
# Example:
#
# ABSEIL_CPP_SLOT="20250814"
# inherit abseil-cpp
#
# src_configure() {
#   abseil-cpp_append_pkgconfig
# }
#
abseil-cpp_append_pkgconfig() {
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

	# Sanitize/isolate
	PKG_CONFIG_PATH=$(echo "${PKG_CONFIG_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/abseil-cpp/|d" | tr $'\n' ":")

	export PKG_CONFIG_PATH="${ESYSROOT}/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir}/pkgconfig:${PKG_CONFIG_PATH}"
}

# @FUNCTION:  abseil-cpp_append_ld_library_path
# @DESCRIPTION:
# Dump absl location into LD_LIBRARY_PATH
#
# Example:
#
# ABSEIL_CPP_SLOT="20250814"
# inherit abseil-cpp
#
# src_configure() {
#   abseil-cpp_append_ld_library_path
# }
#
abseil-cpp_append_ld_library_path() {
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

	# Sanitize/isolate
	LD_LIBRARY_PATH=$(echo "${LD_LIBRARY_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/abseil-cpp/|d" | tr $'\n' ":")

	export LD_LIBRARY_PATH="${ESYSROOT}/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir}/pkgconfig:${LD_LIBRARY_PATH}"
}

fi
