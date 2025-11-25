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

fi
