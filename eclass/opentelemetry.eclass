# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS:  opentelemetry.eclass
# @MAINTAINER:  Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS:  8
# @BLURB:  set multislot opentelemetry config for build systems
# @DESCRIPTION:
# Helpers to support multislot opentelemetry.

#
# Currently OPENTELEMETRY_SLOT only supports the following:
#
# OPENTELEMETRY_SLOT=3 # For LTS
# OPENTELEMETRY_SLOT=5 # For Rolling
#

case ${EAPI:-0} in
	[8]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_OPENTELEMETRY_ECLASS} ]] ; then
_OPENTELEMETRY_ECLASS=1

# @FUNCTION:  opentelemetry_append_flags_direct
# @DESCRIPTION:
# Append flags for C/C++ while passing LDFLAGS directly to linker
#
# Example:
#
# OPENTELEMETRY_SLOT="3"
# inherit opentelemetry
#
# src_configure() {
#   opentelemetry_append_flags_direct
#   einfo "OPENTELEMETRY_CFLAGS:  ${OPENTELEMETRY_CFLAGS}"
#   einfo "OPENTELEMETRY_LDFLAGS:  ${OPENTELEMETRY_LDFLAGS}"
# }
#
opentelemetry_append_flags_direct() {
	local _OPENTELEMETRY_SLOT=""
	if [[ "${OPENTELEMETRY_PV}" ]] ; then
		_OPENTELEMETRY_SLOT="${OPENTELEMETRY_PV%.*}"
	elif [[ "${OPENTELEMETRY_SLOT}" ]] ; then
		_OPENTELEMETRY_SLOT="${OPENTELEMETRY_SLOT%.*}"
	else
eerror "QA:  Set either OPENTELEMETRY_PV or OPENTELEMETRY_SLOT"
		die
	fi
	local libdir=$(get_libdir)

	# Sanitize/isolate
	filter-flags \
		"-I/usr/lib/opentelemetry/*/include" \
		"-L/usr/lib/opentelemetry/*" \
		"--rpath,/usr/lib/opentelemetry/*"

	# For manual configuration or sed patch
	export OPENTELEMETRY_CFLAGS="-I/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/include"
	export OPENTELEMETRY_CXXFLAGS="${OPENTELEMETRY_CXXFLAGS}"
	export OPENTELEMETRY_LDFLAGS="-L/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/${libdir} --rpath=/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/${libdir}"

	append-flags "-I/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/include"
	append-ldflags \
		"-L/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/${libdir}" \
		"--rpath=/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/${libdir}"
}

# @FUNCTION:  opentelemetry_append_flags_indirect
# @DESCRIPTION:
# Append flags for C/C++ while passing LDFLAGS indirectly to linker
#
# Example:
#
# OPENTELEMETRY_SLOT="20250814"
# inherit opentelemetry
#
# src_configure() {
#   opentelemetry_append_flags_indirect
#   einfo "OPENTELEMETRY_CFLAGS:  ${OPENTELEMETRY_CFLAGS}"
#   einfo "OPENTELEMETRY_LDFLAGS:  ${OPENTELEMETRY_LDFLAGS}"
# }
#
opentelemetry_append_flags_indirect() {
	local _OPENTELEMETRY_SLOT=""
	if [[ "${OPENTELEMETRY_PV}" ]] ; then
		_OPENTELEMETRY_SLOT="${OPENTELEMETRY_PV%.*}"
	elif [[ "${OPENTELEMETRY_SLOT}" ]] ; then
		_OPENTELEMETRY_SLOT="${OPENTELEMETRY_SLOT%.*}"
	else
eerror "QA:  Set either OPENTELEMETRY_PV or OPENTELEMETRY_SLOT"
		die
	fi
	local libdir=$(get_libdir)

	# Sanitize/isolate
	filter-flags \
		"-I/usr/lib/opentelemetry/*/include" \
		"-Wl,-L/usr/lib/opentelemetry/*" \
		"-Wl,-rpath,/usr/lib/opentelemetry/*"

	# For manual configuration or sed patch
	export OPENTELEMETRY_CFLAGS="-I/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/include"
	export OPENTELEMETRY_CXXFLAGS="${OPENTELEMETRY_CXXFLAGS}"
	export OPENTELEMETRY_LDFLAGS="-Wl,-L/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/${libdir} -Wl,-rpath,/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/${libdir}"

	append-flags "-I/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/include"
	append-ldflags \
		"-Wl,-L/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/${libdir}" \
		"-Wl,-rpath,/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/${libdir}"
}

# @FUNCTION:  opentelemetry_append_pythonpath
# @DESCRIPTION:
# Dump OpenTelemetry location into PYTHONPATH
#
# Example:
#
# OPENTELEMETRY_SLOT="3"
# inherit opentelemetry
#
# src_configure() {
#   opentelemetry_append_pythonpath
# }
#
opentelemetry_append_pythonpath() {
	local _OPENTELEMETRY_SLOT=""
	if [[ "${OPENTELEMETRY_PV}" ]] ; then
		_OPENTELEMETRY_SLOT="${OPENTELEMETRY_PV%%.*}"
	elif [[ "${OPENTELEMETRY_SLOT}" ]] ; then
		_OPENTELEMETRY_SLOT="${OPENTELEMETRY_SLOT%%.*}"
	elif [[ "${PROTOBUF_CPP_SLOT}" ]] ; then
		_OPENTELEMETRY_SLOT="${PROTOBUF_CPP_SLOT%%.*}"
	else
eerror "QA:  Set either OPENTELEMETRY_PV, OPENTELEMETRY_SLOT, PROTOBUF_CPP_SLOT"
		die
	fi
	local libdir=$(get_libdir)

	# Sanitize/isolate
	PYTHONPATH=$(echo "${PYTHONPATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/opentelemetry/|d" | tr $'\n' ":")

	export PYTHONPATH="${ESYSROOT}/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/lib/${EPYTHON}/site-packages:${PYTHONPATH}"
}


# @FUNCTION:  opentelemetry_append_pkgconfig
# @DESCRIPTION:
# Dump OpenTelemetry location into PKG_CONFIG_PATH
#
# Example:
#
# OPENTELEMETRY_SLOT="3"
# inherit opentelemetry
#
# src_configure() {
#   opentelemetry_append_pkgconfig
# }
#
opentelemetry_append_pkgconfig() {
	local _OPENTELEMETRY_SLOT=""
	if [[ "${OPENTELEMETRY_PV}" ]] ; then
		_OPENTELEMETRY_SLOT="${OPENTELEMETRY_PV%%.*}"
	elif [[ "${OPENTELEMETRY_SLOT}" ]] ; then
		_OPENTELEMETRY_SLOT="${OPENTELEMETRY_SLOT%%.*}"
	elif [[ "${PROTOBUF_CPP_SLOT}" ]] ; then
		_OPENTELEMETRY_SLOT="${PROTOBUF_CPP_SLOT%%.*}"
	else
eerror "QA:  Set either OPENTELEMETRY_PV, OPENTELEMETRY_SLOT, PROTOBUF_CPP_SLOT"
		die
	fi
	local libdir=$(get_libdir)

	# Sanitize/isolate
	PKG_CONFIG_PATH=$(echo "${PKG_CONFIG_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/opentelemetry/|d" | tr $'\n' ":")

	export PKG_CONFIG_PATH="${ESYSROOT}/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/${libdir}/pkgconfig:${PKG_CONFIG_PATH}"
}

# @FUNCTION:  opentelemetry_append_ld_library_path
# @DESCRIPTION:
# Dump OpenTelemetry location into LD_LIBRARY_PATH
#
# Example:
#
# OPENTELEMETRY_SLOT="3"
# inherit opentelemetry
#
# src_configure() {
#   opentelemetry_append_ld_library_path
# }
#
opentelemetry_append_ld_library_path() {
	local _OPENTELEMETRY_SLOT=""
	if [[ "${OPENTELEMETRY_PV}" ]] ; then
		_OPENTELEMETRY_SLOT="${OPENTELEMETRY_PV%%.*}"
	elif [[ "${OPENTELEMETRY_SLOT}" ]] ; then
		_OPENTELEMETRY_SLOT="${OPENTELEMETRY_SLOT%%.*}"
	elif [[ "${PROTOBUF_CPP_SLOT}" ]] ; then
		_OPENTELEMETRY_SLOT="${PROTOBUF_CPP_SLOT%%.*}"
	else
eerror "QA:  Set either OPENTELEMETRY_PV, OPENTELEMETRY_SLOT, PROTOBUF_CPP_SLOT"
		die
	fi
	local libdir=$(get_libdir)

	# Sanitize/isolate
	LD_LIBRARY_PATH=$(echo "${LD_LIBRARY_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/opentelemetry/|d" | tr $'\n' ":")

	export LD_LIBRARY_PATH="${ESYSROOT}/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/${libdir}/pkgconfig:${LD_LIBRARY_PATH}"
}


fi
