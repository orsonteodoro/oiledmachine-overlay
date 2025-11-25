# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS:  protobuf-cpp.eclass
# @MAINTAINER:  Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS:  8
# @BLURB:  set multislot protobuf-cpp config for build systems
# @DESCRIPTION:
# Helpers to support multislot protobuf-cpp.
# It assumes that abseil-cpp eclass is also being used.

#
# Keep version/slot aligned
#
# LTS D11/U22 - grpc:3/1.30 - protobuf-cpp:3/3.12 - protobuf-python:3/3.12 - abseil-cpp:20200225 - re2:20220623
# LTS D12/U24 - grpc:3/1.51 - protobuf-cpp:3/3.21 - protobuf-python:4/4.21 - abseil-cpp:20220623 - re2:20220623 # Tensorflow 2.17, JAX
# Rolling G23 - grpc:4/1.62 - protobuf-cpp:4/4.25 - protobuf-python:4/4.25 - abseil-cpp:20240116 - re2:20220623
# Rolling G23 - grpc:5/1.71 - protobuf-cpp:5/5.29 - protobuf-python:5/5.29 - abseil-cpp:20240722 - re2:20240116 # TensorFlow 2.20, LocalAI
# Rolling G23 - grpc:6/1.75 - protobuf-cpp:6/6.33 - protobuf-python:6/6.33 - abseil-cpp:20250512 - re2:20240116
#

#
# Full examples:
#
# ABSEIL_CPP_SLOT="20220623"
# PROTOBUF_CPP_SLOT="3"
# inherit abseil-cpp multilib-minimal protobuf-cpp
#
# multilib_src_configure() {
#   abseil-cpp_append_flags_direct # For includes, linking, rpath
#   protobuf-cpp_append_flags_direct # For includes, linking, rpath
#   protobuf-cpp_append_path # For protoc
# }
#
#
# ABSEIL_CPP_SLOT="20220623"
# PROTOBUF_CPP_SLOT="3"
# inherit abseil-cpp multilib-minimal protobuf-cpp
#
# multilib_src_configure() {
#   abseil-cpp_append_flags_direct # For rpath change
#   protobuf-cpp_append_flags_direct # For rpath change
#   protobuf-cpp_append_path # For protoc
#   local mycmakeargs() {
#     $(abseil-cpp_append_mycmakeargs)
#     $(protobuf-cpp_append_mycmakeargs)
#   }
# }
#

case ${EAPI:-0} in
	[8]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_PROTOBUF_CPP_ECLASS} ]] ; then
_PROTOBUF_CPP_ECLASS=1

inherit flag-o-matic

# @FUNCTION:  protobuf-cpp_append_flags_direct
# @DESCRIPTION:
# Append flags for C/C++ while passing LDFLAGS directly to linker
#
# Example:
#
# PROTOBUF_CPP_SLOT="3"
# inherit protobuf-cpp
#
# src_configure() {
#   protobuf-cpp_append_flags_direct
#   einfo "PROTOBUF_CPP_CFLAGS:  ${PROTOBUF_CPP_CFLAGS}"
#   einfo "PROTOBUF_CPP_LDFLAGS:  ${PROTOBUF_CPP_LDFLAGS}"
# }
#
protobuf-cpp_append_flags_direct() {
	local _PROTOBUF_CPP_SLOT=""
	if [[ "${PROTOBUF_CPP_PV}" ]] ; then
		_PROTOBUF_CPP_SLOT="${PROTOBUF_CPP_PV%.*}"
	elif [[ "${PROTOBUF_CPP_SLOT}" ]] ; then
		_PROTOBUF_CPP_SLOT="${PROTOBUF_CPP_SLOT%.*}"
	else
eerror "QA:  Set either PROTOBUF_CPP_PV or PROTOBUF_CPP_SLOT"
		die
	fi
	local libdir=$(get_libdir)

	# Sanitize/isolate
	filter-flags \
		"-I/usr/lib/protobuf/*/include" \
		"-L/usr/lib/protobuf/*" \
		"--rpath,/usr/lib/protobuf/*"

	# For manual configuration or sed patch
	export PROTOBUF_CPP_CFLAGS="-I/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/include"
	export PROTOBUF_CPP_CXXFLAGS="${PROTOBUF_CPP_CFLAGS}"
	export PROTOBUF_CPP_LDFLAGS="-L/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/${libdir} --rpath=/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/${libdir}"

	append-flags "-I/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/include"
	append-ldflags \
		"-L/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/${libdir}" \
		"--rpath=/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/${libdir}"
}

# @FUNCTION:  protobuf-cpp_append_flags_indirect
# @DESCRIPTION:
# Append flags for C/C++ while passing LDFLAGS indirectly to linker
#
# Example:
#
# PROTOBUF_CPP_SLOT="3"
# inherit protobuf-cpp
#
# src_configure() {
#   protobuf-cpp_append_flags_indirect
#   einfo "PROTOBUF_CPP_CFLAGS:  ${PROTOBUF_CPP_CFLAGS}"
#   einfo "PROTOBUF_CPP_LDFLAGS:  ${PROTOBUF_CPP_LDFLAGS}"
# }
#
protobuf-cpp_append_flags_indirect() {
	local _PROTOBUF_CPP_SLOT=""
	if [[ "${PROTOBUF_CPP_PV}" ]] ; then
		_PROTOBUF_CPP_SLOT="${PROTOBUF_CPP_PV%.*}"
	elif [[ "${PROTOBUF_CPP_SLOT}" ]] ; then
		_PROTOBUF_CPP_SLOT="${PROTOBUF_CPP_SLOT%.*}"
	else
eerror "QA:  Set either PROTOBUF_CPP_PV or PROTOBUF_CPP_SLOT"
		die
	fi
	local libdir=$(get_libdir)

	# Sanitize/isolate
	filter-flags \
		"-I/usr/lib/protobuf/*/include" \
		"-Wl,-L/usr/lib/protobuf/*" \
		"-Wl,-rpath,/usr/lib/protobuf/*"

	# For manual configuration or sed patch
	export PROTOBUF_CPP_CFLAGS="-I/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/include"
	export PROTOBUF_CPP_CXXFLAGS="${PROTOBUF_CPP_CFLAGS}"
	export PROTOBUF_CPP_LDFLAGS="-Wl,-L/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/${libdir} -Wl,-rpath,/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/${libdir}"

	append-flags "-I/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/include"
	append-ldflags \
		"-Wl,-L/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/${libdir}" \
		"-Wl,-rpath,/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/${libdir}"
}

# @FUNCTION:  protobuf-cpp_append_mycmakeargs
# @DESCRIPTION:
# Dump protobuf-cpp location into mycmakeargs
#
# Example:
#
# PROTOBUF_CPP_SLOT="3"
# inherit protobuf-cpp
#
# src_configure() {
#   local mycmakeargs=(
#     $(protobuf-cpp_append_mycmakeargs)
#   )
# }
#
protobuf-cpp_append_mycmakeargs() {
	local _PROTOBUF_CPP_SLOT=""
	if [[ "${PROTOBUF_CPP_PV}" ]] ; then
		_PROTOBUF_CPP_SLOT="${PROTOBUF_CPP_PV%.*}"
	elif [[ "${PROTOBUF_CPP_SLOT}" ]] ; then
		_PROTOBUF_CPP_SLOT="${PROTOBUF_CPP_SLOT%.*}"
	else
eerror "QA:  Set either PROTOBUF_CPP_PV or PROTOBUF_CPP_SLOT"
		die
	fi

	local name
	if [[ -n "${1}" ]] ; then
		name="${1}"
	else
		name="Protobuf"
	fi
	local libdir=$(get_libdir)
	echo "-D${name}_DIR=/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/${libdir}/cmake/protobuf"
}

# @FUNCTION:  protobuf-cpp_append_pkgconfig
# @DESCRIPTION:
# Dump protobuf-cpp location into PKG_CONFIG_PATH
#
# Example:
#
# PROTOBUF_CPP_SLOT="3"
# inherit protobuf-cpp
#
# src_configure() {
#   protobuf-cpp_append_pkgconfig
# }
#
protobuf-cpp_append_pkgconfig() {
	local _PROTOBUF_CPP_SLOT=""
	if [[ "${PROTOBUF_CPP_PV}" ]] ; then
		_PROTOBUF_CPP_SLOT="${PROTOBUF_CPP_PV%.*}"
	elif [[ "${PROTOBUF_CPP_SLOT}" ]] ; then
		_PROTOBUF_CPP_SLOT="${PROTOBUF_CPP_SLOT%.*}"
	else
eerror "QA:  Set either PROTOBUF_CPP_PV or PROTOBUF_CPP_SLOT"
		die
	fi
	local libdir=$(get_libdir)

	# Sanitize/isolate
	PKG_CONFIG_PATH=$(echo "${PKG_CONFIG_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/protobuf/|d" | tr $'\n' ":")

	export PKG_CONFIG_PATH="${ESYSROOT}/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/${libdir}/pkgconfig:${PKG_CONFIG_PATH}"
}

# @FUNCTION:  protobuf-cpp_append_ld_library_path
# @DESCRIPTION:
# Dump protobuf-cpp location into LD_LIBRARY_PATH
#
# Example:
#
# PROTOBUF_CPP_SLOT="3"
# inherit protobuf-cpp
#
# src_configure() {
#   protobuf-cpp_append_ld_library_path
# }
#
protobuf-cpp_append_ld_library_path() {
	local _PROTOBUF_CPP_SLOT=""
	if [[ "${PROTOBUF_CPP_PV}" ]] ; then
		_PROTOBUF_CPP_SLOT="${PROTOBUF_CPP_PV%.*}"
	elif [[ "${PROTOBUF_CPP_SLOT}" ]] ; then
		_PROTOBUF_CPP_SLOT="${PROTOBUF_CPP_SLOT%.*}"
	else
eerror "QA:  Set either PROTOBUF_CPP_PV or PROTOBUF_CPP_SLOT"
		die
	fi
	local libdir=$(get_libdir)

	# Sanitize/isolate
	LD_LIBRARY_PATH=$(echo "${LD_LIBRARY_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/protobuf/|d" | tr $'\n' ":")

	export LD_LIBRARY_PATH="${ESYSROOT}/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/${libdir}/pkgconfig:${LD_LIBRARY_PATH}"
}

# @FUNCTION:  protobuf-cpp_append_path
# @DESCRIPTION:
# Dump protobuf-cpp location into PATH to run executibles
#
# Example:
#
# PROTOBUF_CPP_SLOT="3"
# inherit protobuf-cpp
#
# src_configure() {
#   protobuf-cpp_append_path
# }
#
protobuf-cpp_append_path() {
	local _PROTOBUF_CPP_SLOT=""
	if [[ "${PROTOBUF_CPP_PV}" ]] ; then
		_PROTOBUF_CPP_SLOT="${PROTOBUF_CPP_PV%.*}"
	elif [[ "${PROTOBUF_CPP_SLOT}" ]] ; then
		_PROTOBUF_CPP_SLOT="${PROTOBUF_CPP_SLOT%.*}"
	else
eerror "QA:  Set either PROTOBUF_CPP_PV or PROTOBUF_CPP_SLOT"
		die
	fi
	local libdir=$(get_libdir)

	# Sanitize/isolate
	PATH=$(echo "${PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/protobuf/|d" | tr $'\n' ":")

	export PATH="${ESYSROOT}/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/bin:${PATH}"
}

fi
