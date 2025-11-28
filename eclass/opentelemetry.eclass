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
# OPENTELEMETRY_SLOT=3 # For LTS packages
# OPENTELEMETRY_SLOT=5 # For rolling packages
#

# For privacy critics, some of us agree it should not exist, but the
# OpenTelemery is sometimes unconditional and difficult to remove.
# The caffe2 package may use multislot OpenTelemetry, but it is not used anywhere else.
# The OpenTelemetry for Node is separate and is pulled in Node based package systems.

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
# OPENTELEMETRY_LINK_MODE="direct"
# OPENTELEMETRY_SLOT="3"
#
# inherit opentelemetry
#
# src_configure() {
#   # For auto configure or adding of
#   # C/C++ include headers
#   # LD linker flags
#   # RPATH correction for multislot dynamic libraries
#   # LD_LIBRARY_PATH for library detection
#   # Executible PATHs for profiler/instrumenter
#   # PYTHONPATH for Python modules detection
#   opentelemetry_src_configure
#
#   einfo "OPENTELEMETRY_CFLAGS:  ${OPENTELEMETRY_CFLAGS}"
#   einfo "OPENTELEMETRY_LDFLAGS:  ${OPENTELEMETRY_LDFLAGS}"
#
#   econf
# }
#
opentelemetry_src_configure() {
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

	# Sanitize/isolate multiabi pollution from logs
	filter-flags \
		"-I/usr/lib/opentelemetry/*/include" \
		"-Wl,-L/usr/lib/opentelemetry/*" \
		"-Wl,-rpath,/usr/lib/opentelemetry/*" \
		"-L/usr/lib/opentelemetry/*" \
		"--rpath=/usr/lib/opentelemetry/*"

	append-flags "-I/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/include"

	if [[ ${OPENTELEMETRY_LINK_MODE:-"indirect"} == "indirect" ]] ; then
		# For manual configuration or sed patch
		export OPENTELEMETRY_CFLAGS="-I/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/include"
		export OPENTELEMETRY_CXXFLAGS="${OPENTELEMETRY_CXXFLAGS}"
		export OPENTELEMETRY_LDFLAGS="-Wl,-L/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/${libdir} -Wl,-rpath,/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/${libdir}"

		append-ldflags \
			"-Wl,-L/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/${libdir}" \
			"-Wl,-rpath,/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/${libdir}"
	else
		# For manual configuration or sed patch
		export OPENTELEMETRY_CFLAGS="-I/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/include"
		export OPENTELEMETRY_CXXFLAGS="${OPENTELEMETRY_CXXFLAGS}"
		export OPENTELEMETRY_LDFLAGS="-L/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/${libdir} --rpath=/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/${libdir}"

		append-ldflags \
			"-L/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/${libdir}" \
			"--rpath=/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/${libdir}"
	fi

	# Sanitize/isolate
	LD_LIBRARY_PATH=$(echo "${LD_LIBRARY_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/opentelemetry/|d" | tr $'\n' ":")
	PKG_CONFIG_PATH=$(echo "${PKG_CONFIG_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/opentelemetry/|d" | tr $'\n' ":")
	PATH=$(echo "${PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/opentelemetry/|d" | tr $'\n' ":")
	PYTHONPATH=$(echo "${PYTHONPATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/opentelemetry/|d" | tr $'\n' ":")

	export LD_LIBRARY_PATH="${ESYSROOT}/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/${libdir}/pkgconfig:${LD_LIBRARY_PATH}"
	export PATH="${ESYSROOT}/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/bin:${PATH}"
	export PKG_CONFIG_PATH="${ESYSROOT}/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/${libdir}/pkgconfig:${PKG_CONFIG_PATH}"
	export PYTHONPATH="${ESYSROOT}/usr/lib/opentelemetry/${_OPENTELEMETRY_SLOT}/lib/${EPYTHON}/site-packages:${PYTHONPATH}"
}

# @FUNCTION:  opentelemetry_python_configure
# @DESCRIPTION:
# Alias for ebuild style consistency
#
# Full example for setuptools projects:
#
# OPENTELEMETRY_SLOT="3"
#
# inherit distutils-r1 opentelemetry
#
# python_configure() {
#   # For adding paths for
#   # RPATH correction to find multislotted dynamic library
#   # PKG_CONFIG_PATHs for package detection
#   # LD_LIBRARY_PATHs for loading multislot dynamic libraries for build time executibles
#   # Executible PATHs for multislotted gRPC plugins or protoc code generator
#   opentelemetry_python_configure
# }
#
opentelemetry_python_configure() {
	opentelemetry_src_configure
}

# @FUNCTION:  opentelemetry_append_cmake
# @DESCRIPTION:
# Dump OpenTelemetry location into mycmakeargs for CMake's find_package().
#
# Example:
#
# GRPC_SLOT="3"
# inherit cmake opentelemetry
#
# src_configure() {
#   # For auto configure or adding of
#   # RPATH correction for multislot dynamic libraries
#   # Executible PATHs for profiler/instrumenter
#   opentelemetry_src_configure
#
#   local mycmakeargs=(
#     $(opentelemetry_append_mycmakeargs)
#   )
#
#   cmake_src_configure
# }
#
grpc_append_cmake() {
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
		name="OpenTelemetryApi"
	fi
	local libdir=$(get_libdir)
# TODO fix or correct this
	echo "-D${name}_DIR=/usr/lib/opentelemetry/${_GRPC_SLOT}/${libdir}/cmake/<FIXME>"
}

fi
