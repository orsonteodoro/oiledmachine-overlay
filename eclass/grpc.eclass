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
# Keep version/slot aligned
#
# LTS D11/U22 - grpc:3/1.30 - protobuf-cpp:3/3.12 - protobuf-python:3.12 - abseil-cpp:20200225 - re2:20220623 # PyTorch 2.9, OpenCV
# LTS D12/U24 - grpc:3/1.51 - protobuf-cpp:3/3.21 - protobuf-python:4.21 - abseil-cpp:20220623 - re2:20220623 # Tensorflow 2.17, JAX
# Rolling G23 - grpc:4/1.62 - protobuf-cpp:4/4.25 - protobuf-python:4.25 - abseil-cpp:20240116 - re2:20220623 # Apache Arrow
# Rolling G23 - grpc:5/1.71 - protobuf-cpp:5/5.29 - protobuf-python:5.29 - abseil-cpp:20240722 - re2:20240116 # TensorFlow 2.20, LocalAI
# Rolling G23 - grpc:6/1.75 - protobuf-cpp:6/6.33 - protobuf-python:6.33 - abseil-cpp:20250512 - re2:20240116
#

case ${EAPI:-0} in
	[8]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_GRPC_ECLASS} ]] ; then
_GRPC_ECLASS=1

inherit flag-o-matic

#
# Full example for CMake based autotools based projects:
#
# inherit protobuf # To populate PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_4 array.
#
# GRPC_SLOT="3"
# PROTOBUF_CPP_SLOT="3"
# PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_4[@]}" )
# RE2_SLOT="20220623"
#
# inherit abseil-cpp cmake grpc
#
# src_configure() {
#   # Assume grpc:3/1.51 row in the above alignment table.
#
#   # For auto detection or appending of
#   # C/C++ include headers
#   # LD linker flags
#   # RPATH correction to find multislotted dynamic library
#   # PKG_CONFIG_PATHs for package detection
#   # LD_LIBRARY_PATHs for loading multislot dynamic libraries for build time executibles
#   # Executible PATHs for multislotted gRPC plugins or protoc code generator
#   abseil-cpp_src_configure
#   protobuf_src_configure
#   grpc_src_configure
#
#   econf
# }
#

#
# Full example for CMake based projects:
#
# inherit protobuf # To populate PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_4 array.
#
# GRPC_SLOT="3"
# PROTOBUF_CPP_SLOT="3"
# PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_4[@]}" )
# RE2_SLOT="20220623"
#
# inherit abseil-cpp cmake grpc
#
# src_configure() {
#   # Assume grpc:3/1.51 row in the above alignment table.
#
#   # For adding paths for
#   # RPATH correction to find multislotted dynamic library
#   # PKG_CONFIG_PATHs for package detection
#   # LD_LIBRARY_PATHs for loading multislot dynamic libraries for build time executibles
#   # Executible PATHs for multislotted gRPC plugins or protoc code generator
#   abseil-cpp_src_configure
#   protobuf_src_configure
#   grpc_src_configure
#
#   local mycmakeargs=(
#     $(grpc_append_mycmakeargs)
#   )
#
#   cmake_src_configure
# }
#

#
# Full example for setuptools projects:
#
# inherit protobuf # To populate PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_4 array.
#
# GRPC_SLOT="3"
# PROTOBUF_CPP_SLOT="3"
# PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_4[@]}" )
# RE2_SLOT="20220623"
#
# inherit abseil-cpp distutils-r1 grpc
#
# python_configure() {
#   # Assume grpc:3/1.51 row in the above alignment table.
#
#   # For adding paths for
#   # RPATH correction to find multislotted dynamic library
#   # PKG_CONFIG_PATHs for package detection
#   # LD_LIBRARY_PATHs for loading multislot dynamic libraries for build time executibles
#   # Executible PATHs for multislotted gRPC plugins or protoc code generator
#   abseil-cpp_python_configure
#   protobuf_python_configure
#   grpc_python_configure
# }
#

# @FUNCTION:  grpc_src_configure
# @DESCRIPTION:
# Append flags for C/C++ while passing LDFLAGS directly to linker
#
# Example:
#
# GRPC_SLOT="3"
#
# inherit grpc
#
# src_configure() {
#   # For adding paths to
#   # C/C++ include headers
#   # LD linker flags
#   # RPATH correction to find multislotted dynamic library
#   # LD_LIBRARY_PATHs for loading multislot dynamic libraries for build time executibles
#   # Executible PATHs for multislotted gRPC plugins
#   grpc_src_configure
#
#   # Print or sed patch broken build files below.
#   einfo "GRPC_CFLAGS:  ${GRPC_CFLAGS}"
#   einfo "GRPC_CXXFLAGS:  ${GRPC_CXXFLAGS}"
#
#   econf
# }
#
grpc_src_configure() {
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

	# Sanitize/isolate multiabi pollution from logs
	filter-flags \
		"-I/usr/lib/grpc/*/include" \
		"-Wl,-L/usr/lib/grpc/*" \
		"-Wl,-rpath,/usr/lib/grpc/*" \
		"-L/usr/lib/grpc/*" \
		"--rpath=/usr/lib/grpc/*"

	append-flags "-I/usr/lib/grpc/${_GRPC_SLOT}/include"

	if [[ ${GRPC_LINK_MODE:-"indirect"} == "indirect" ]] ; then
		# For manual configuration or sed patch
		export GRPC_CFLAGS="-I/usr/lib/grpc/${_GRPC_SLOT}/include"
		export GRPC_CXXFLAGS="${GRPC_CFLAGS}"
		export GRPC_LDFLAGS="-Wl,-L/usr/lib/grpc/${_GRPC_SLOT}/${libdir} -Wl,-rpath,/usr/lib/grpc/${_GRPC_SLOT}/${libdir}"

		append-flags "-I/usr/lib/grpc/${_GRPC_SLOT}/include"
		append-ldflags \
			"-Wl,-L/usr/lib/grpc/${_GRPC_SLOT}/${libdir}" \
			"-Wl,-rpath,/usr/lib/grpc/${_GRPC_SLOT}/${libdir}"
	else
		# For manual configuration or sed patch
		export GRPC_CFLAGS="-I/usr/lib/grpc/${_GRPC_SLOT}/include"
		export GRPC_CXXFLAGS="${GRPC_CFLAGS}"
		export GRPC_LDFLAGS="-L/usr/lib/grpc/${_GRPC_SLOT}/${libdir} --rpath=/usr/lib/grpc/${_GRPC_SLOT}/${libdir}"

		append-ldflags \
			"-L/usr/lib/grpc/${_GRPC_SLOT}/${libdir}" \
			"--rpath=/usr/lib/grpc/${_GRPC_SLOT}/${libdir}"
	fi

	# Sanitize/isolate
	LD_LIBRARY_PATH=$(echo "${LD_LIBRARY_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/grpc/|d" | tr $'\n' ":")
	PATH=$(echo "${PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/grpc/|d" | tr $'\n' ":")
	PKG_CONFIG_PATH=$(echo "${PKG_CONFIG_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/grpc/|d" | tr $'\n' ":")
	PYTHONPATH=$(echo "${PYTHONPATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/grpc/|d" | tr $'\n' ":")

	export LD_LIBRARY_PATH="${ESYSROOT}/usr/lib/grpc/${_GRPC_SLOT}/${libdir}/pkgconfig:${LD_LIBRARY_PATH}"
	export PATH="${ESYSROOT}/usr/lib/grpc/${_GRPC_SLOT}/bin:${PATH}"
	export PKG_CONFIG_PATH="${ESYSROOT}/usr/lib/grpc/${_GRPC_SLOT}/${libdir}/pkgconfig:${PKG_CONFIG_PATH}"
	export PYTHONPATH="${ESYSROOT}/usr/lib/grpc/${_GRPC_SLOT}/lib/${EPYTHON}/site-packages:${PYTHONPATH}"
}

# @FUNCTION:  grpc_python_configure
# @DESCRIPTION:
# Alias for ebuild style consistency
#
# Example for setuptools projects:
#
# GRPC_SLOT="3"
#
# inherit distutils-r1 grpc
#
# python_configure() {
#   # For adding paths to
#   # C/C++ include headers
#   # LD linker flags
#   # RPATH correction to find multislotted dynamic library
#   # LD_LIBRARY_PATHs for loading multislot dynamic libraries for build time executibles
#   # Executible PATHs for multislotted gRPC plugins
#   grpc_python_configure
# }
#
grpc_python_configure() {
	grpc_src_configure
}

# @FUNCTION:  grpc_append_cmake
# @DESCRIPTION:
# Dump grpc location into mycmakeargs for CMake's find_package().
#
# Example:
#
# GRPC_SLOT="3"
#
# inherit cmake grpc
#
# src_configure() {
#   # RPATH correction to find multislotted dynamic library
#   # Executible PATHs for multislotted gRPC plugins
#   grpc_src_configure
#
#   local mycmakeargs=(
#     $(grpc_append_mycmakeargs)
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
		name="gRPC"
	fi
	local libdir=$(get_libdir)
	echo "-D${name}_DIR=/usr/lib/grpc/${_GRPC_SLOT}/${libdir}/cmake/grpc"
}

fi
