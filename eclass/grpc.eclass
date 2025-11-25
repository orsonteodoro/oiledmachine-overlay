# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS:  grpc.eclass
# @MAINTAINER:  Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS:  8
# @BLURB:  set multislot grpc config for build systems
# @DESCRIPTION:
# Helpers to support multislot grpc.
# It assumes that abseil-cpp and protobuf eclasses are also being used.

#
# Full examples:
#
# ABSEIL_CPP_SLOT="20220623"
# PROTOBUF_CPP_SLOT="3"
# inherit abseil-cpp grpc multilib-minimal protobuf-cpp
#
# multilib_src_configure() {
#   abseil-cpp_append_flags_direct # For includes, linking, rpath
#   protobuf-cpp_append_flags_direct # For includes, linking, rpath
#   grpc_append_flags_direct # For includes, linking, rpath
#   protobuf-cpp_append_path # For protoc
#   grpc_append_path # For grpc_cpp_plugin
# }
#
#
# ABSEIL_CPP_SLOT="20220623"
# PROTOBUF_CPP_SLOT="3"
# inherit abseil-cpp grpc multilib-minimal protobuf-cpp
#
# multilib_src_configure() {
#   abseil-cpp_append_flags_direct
#   protobuf_append_flags_direct # For rpath change
#   grpc_append_flags_direct # For rpath change
#   protobuf-cpp_append_path # For protoc
#   grpc_append_path # For grpc_cpp_plugin
#   local mycmakeargs() {
#     $(abseil-cpp_append_mycmakeargs)
#     $(protobuf-cpp_append_mycmakeargs)
#     $(grpc_append_mycmakeargs)
#   }
# }
#


case ${EAPI:-0} in
	[8]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_GRPC_ECLASS} ]] ; then
_GRPC_ECLASS=1

inherit flag-o-matic

# @FUNCTION:  grpc_append_flags_direct
# @DESCRIPTION:
# Append flags for C/C++ while passing LDFLAGS directly to linker
#
# Example:
#
# GRPC_SLOT="3"
# inherit grpc
#
# src_configure() {
#   grpc_append_flags_direct
#   einfo "GRPC_CFLAGS:  ${GRPC_CFLAGS}"
#   einfo "GRPC_CXXFLAGS:  ${GRPC_CXXFLAGS}"
# }
#
grpc_append_flags_direct() {
	local _GRPC_SLOT=""
	if [[ "${GRPC_PV}" ]] ; then
		_GRPC_SLOT="${GRPC_PV%%.*}"
	elif [[ "${GRPC_SLOT}" ]] ; then
		_GRPC_SLOT="${GRPC_SLOT%%.*}"
	elif [[ "${PROTOBUF_CPP_SLOT}" ]] ; then
		_GRPC_SLOT="${PROTOBUF_CPP_SLOT%%.*}"
	else
eerror "QA:  Set either GRPC_PV, GRPC_SLOT, or PROTOBUF_CPP_SLOT"
		die
	fi
	local libdir=$(get_libdir)

	# Sanitize/isolate
	filter-flags \
		"-I/usr/lib/grpc/*/include" \
		"-L/usr/lib/grpc/*" \
		"--rpath,/usr/lib/grpc/*"

	# For manual configuration or sed patch
	export GRPC_CFLAGS="-I/usr/lib/grpc/${_GRPC_SLOT}/include"
	export GRPC_CXXFLAGS="${GRPC_CFLAGS}"
	export GRPC_LDFLAGS="-L/usr/lib/grpc/${_GRPC_SLOT}/${libdir} --rpath=/usr/lib/grpc/${_GRPC_SLOT}/${libdir}"

	append-flags "-I/usr/lib/grpc/${_GRPC_SLOT}/include"
	append-ldflags \
		"-L/usr/lib/grpc/${_GRPC_SLOT}/${libdir}" \
		"--rpath=/usr/lib/grpc/${_GRPC_SLOT}/${libdir}"
}

# @FUNCTION:  grpc_append_flags_indirect
# @DESCRIPTION:
# Append flags for C/C++ while passing LDFLAGS indirectly to linker
#
# Example:
#
# GRPC_SLOT="3"
# inherit grpc
#
# src_configure() {
#   grpc_append_flags_indirect
#   einfo "GRPC_CFLAGS:  ${GRPC_CFLAGS}"
#   einfo "GRPC_CXXFLAGS:  ${GRPC_CXXFLAGS}"
# }
#
grpc_append_flags_indirect() {
	local _GRPC_SLOT=""
	if [[ "${GRPC_PV}" ]] ; then
		_GRPC_SLOT="${GRPC_PV%%.*}"
	elif [[ "${GRPC_SLOT}" ]] ; then
		_GRPC_SLOT="${GRPC_SLOT%%.*}"
	elif [[ "${PROTOBUF_CPP_SLOT}" ]] ; then
		_GRPC_SLOT="${PROTOBUF_CPP_SLOT%%.*}"
	else
eerror "QA:  Set either GRPC_PV, GRPC_SLOT, or PROTOBUF_CPP_SLOT"
		die
	fi
	local libdir=$(get_libdir)

	# Sanitize/isolate
	filter-flags \
		"-I/usr/lib/grpc/*/include" \
		"-Wl,-L/usr/lib/grpc/*" \
		"-Wl,-rpath,/usr/lib/grpc/*"

	# For manual configuration or sed patch
	export GRPC_CFLAGS="-I/usr/lib/grpc/${_GRPC_SLOT}/include"
	export GRPC_CXXFLAGS="${GRPC_CFLAGS}"
	export GRPC_LDFLAGS="-Wl,-L/usr/lib/grpc/${_GRPC_SLOT}/${libdir} -Wl,-rpath,/usr/lib/grpc/${_GRPC_SLOT}/${libdir}"

	append-flags "-I/usr/lib/grpc/${_GRPC_SLOT}/include"
	append-ldflags \
		"-Wl,-L/usr/lib/grpc/${_GRPC_SLOT}/${libdir}" \
		"-Wl,-rpath,/usr/lib/grpc/${_GRPC_SLOT}/${libdir}"
}

# @FUNCTION:  grpc_append_mycmakeargs
# @DESCRIPTION:
# Dump grpc location into mycmakeargs
#
# Example:
#
# GRPC_SLOT="3"
# inherit grpc
#
# src_configure() {
#   local mycmakeargs=(
#     $(grpc_append_mycmakeargs)
#   )
# }
#
grpc_append_mycmakeargs() {
	local _GRPC_SLOT=""
	if [[ "${GRPC_PV}" ]] ; then
		_GRPC_SLOT="${GRPC_PV%%.*}"
	elif [[ "${GRPC_SLOT}" ]] ; then
		_GRPC_SLOT="${GRPC_SLOT%%.*}"
	elif [[ "${PROTOBUF_CPP_SLOT}" ]] ; then
		_GRPC_SLOT="${PROTOBUF_CPP_SLOT%%.*}"
	else
eerror "QA:  Set either GRPC_PV, GRPC_SLOT, or PROTOBUF_CPP_SLOT"
		die
	fi

	local name
	if [[ -n "${1}" ]] ; then
		name="${1}"
	else
		name="gRPC"
	fi
	local libdir=$(get_libdir)
	echo "-D${name}_DIR=/usr/lib/grpc/${_GRPC_SLOT}/${libdir}/cmake/grpc"
}

# @FUNCTION:  grpc_append_pkgconfig
# @DESCRIPTION:
# Dump grpc location into PKG_CONFIG_PATH
#
# Example:
#
# GRPC_SLOT="3"
# inherit grpc
#
# src_configure() {
#   grpc_append_pkgconfig
# }
#
grpc_append_pkgconfig() {
	local _GRPC_SLOT=""
	if [[ "${GRPC_PV}" ]] ; then
		_GRPC_SLOT="${GRPC_PV%%.*}"
	elif [[ "${GRPC_SLOT}" ]] ; then
		_GRPC_SLOT="${GRPC_SLOT%%.*}"
	elif [[ "${PROTOBUF_CPP_SLOT}" ]] ; then
		_GRPC_SLOT="${PROTOBUF_CPP_SLOT%%.*}"
	else
eerror "QA:  Set either GRPC_PV, GRPC_SLOT, or PROTOBUF_CPP_SLOT"
		die
	fi
	local libdir=$(get_libdir)

	# Sanitize/isolate
	PKG_CONFIG_PATH=$(echo "${PKG_CONFIG_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/grpc/|d" | tr $'\n' ":")

	export PKG_CONFIG_PATH="${ESYSROOT}/usr/lib/grpc/${_GRPC_SLOT}/${libdir}/pkgconfig:${PKG_CONFIG_PATH}"
}

# @FUNCTION:  grpc_append_ld_library_path
# @DESCRIPTION:
# Dump grpc location into LD_LIBRARY_PATH
#
# Example:
#
# GRPC_SLOT="3"
# inherit grpc
#
# src_configure() {
#   grpc_append_ld_library_path
# }
#
grpc_append_ld_library_path() {
	local _GRPC_SLOT=""
	if [[ "${GRPC_PV}" ]] ; then
		_GRPC_SLOT="${GRPC_PV%%.*}"
	elif [[ "${GRPC_SLOT}" ]] ; then
		_GRPC_SLOT="${GRPC_SLOT%%.*}"
	elif [[ "${PROTOBUF_CPP_SLOT}" ]] ; then
		_GRPC_SLOT="${PROTOBUF_CPP_SLOT%%.*}"
	else
eerror "QA:  Set either GRPC_PV, GRPC_SLOT, or PROTOBUF_CPP_SLOT"
		die
	fi
	local libdir=$(get_libdir)

	# Sanitize/isolate
	LD_LIBRARY_PATH=$(echo "${LD_LIBRARY_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/grpc/|d" | tr $'\n' ":")

	export LD_LIBRARY_PATH="${ESYSROOT}/usr/lib/grpc/${_GRPC_SLOT}/${libdir}/pkgconfig:${LD_LIBRARY_PATH}"
}

# @FUNCTION:  grpc_append_path
# @DESCRIPTION:
# Dump grpc location into PATH to run executibles
#
# Example:
#
# GRPC_SLOT="3"
# inherit grpc
#
# src_configure() {
#   grpc_append_path
# }
#
grpc_append_ld_library_path() {
	local _GRPC_SLOT=""
	if [[ "${GRPC_PV}" ]] ; then
		_GRPC_SLOT="${GRPC_PV%%.*}"
	elif [[ "${GRPC_SLOT}" ]] ; then
		_GRPC_SLOT="${GRPC_SLOT%%.*}"
	elif [[ "${PROTOBUF_CPP_SLOT}" ]] ; then
		_GRPC_SLOT="${PROTOBUF_CPP_SLOT%%.*}"
	else
eerror "QA:  Set either GRPC_PV, GRPC_SLOT, or PROTOBUF_CPP_SLOT"
		die
	fi
	local libdir=$(get_libdir)

	# Sanitize/isolate
	PATH=$(echo "${PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/grpc/|d" | tr $'\n' ":")

	export PATH="${ESYSROOT}/usr/lib/grpc/${_GRPC_SLOT}/bin:${PATH}"
}

fi
