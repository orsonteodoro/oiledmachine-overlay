# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS:  protobuf.eclass
# @MAINTAINER:  Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS:  8
# @BLURB:  set multislot protobuf config for build systems
# @DESCRIPTION:
# Helpers to support multislot protobuf-cpp and protobuf-python.
# It assumes that abseil-cpp eclass is also being used.

#
# Keep version/slot aligned
#
# LTS D11/U22 - grpc:3/1.30 - protobuf-cpp:3/3.12 - protobuf-python:3/3.12 - abseil-cpp:20200225 - re2:20220623 # PyTorch 2.9, OpenCV
# LTS D12/U24 - grpc:3/1.51 - protobuf-cpp:3/3.21 - protobuf-python:4/4.21 - abseil-cpp:20220623 - re2:20220623 # Tensorflow 2.17, JAX
# Rolling G23 - grpc:4/1.62 - protobuf-cpp:4/4.25 - protobuf-python:4/4.25 - abseil-cpp:20240116 - re2:20220623 # Apache Arrow
# Rolling G23 - grpc:5/1.71 - protobuf-cpp:5/5.29 - protobuf-python:5/5.29 - abseil-cpp:20240722 - re2:20240116 # TensorFlow 2.20, LocalAI
# Rolling G23 - grpc:6/1.75 - protobuf-cpp:6/6.33 - protobuf-python:6/6.33 - abseil-cpp:20250512 - re2:20240116
#

#
# Full example for autotools based projects:
#
# ABSEIL_CPP_SLOT="20220623"
# PROTOBUF_CPP_SLOT="3"
# PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_4[@]}" )
# inherit abseil-cpp multilib-minimal protobuf
#
# multilib_src_configure() {
#   abseil-cpp_src_configure # For includes, linking flags
#   protobuf_src_configure # For includes, linking flags, path
#   emake
# }
#

#
# Full example for CMake based projects:
#
# ABSEIL_CPP_SLOT="20220623"
# PROTOBUF_CPP_SLOT="3"
# PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_4[@]}" )
# inherit abseil-cpp cmake multilib-minimal protobuf
#
# multilib_src_configure() {
#   abseil-cpp_src_configure # For linking flags
#   protobuf_src_configure # For linking flags, path
#   local mycmakeargs() {
#     $(abseil-cpp_append_mycmakeargs)
#     $(protobuf_append_mycmakeargs)
#   }
#   cmake_src_configure
# }
#

case ${EAPI:-0} in
	[8]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_PROTOBUF_CPP_ECLASS} ]] ; then
_PROTOBUF_CPP_ECLASS=1

inherit flag-o-matic

# @ECLASS_VARIABLE:  PROTOBUF_PYTHON_SLOTS_3
# @DESCRIPTION:
# Adds all protobuf-python 3.x slots
PROTOBUF_PYTHON_SLOTS_3=(
	"3.12"
)

# @ECLASS_VARIABLE:  PROTOBUF_PYTHON_SLOTS_4
# @DESCRIPTION:
# Adds all protobuf-python 4.x slots for any protobuf-cpp
PROTOBUF_PYTHON_SLOTS_4=(
	"4.21" # For python-cpp:3
	"4.25" # For python-cpp:4
)

# @ECLASS_VARIABLE:  PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_3
# @DESCRIPTION:
# Adds all protobuf-python 4.x slots compatible with protobuf-cpp:3
PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_3=(
	"4.21" # For python-cpp:3
)

# @ECLASS_VARIABLE:  PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_4
# @DESCRIPTION:
# Adds all protobuf-python 4.x slots compatible with protobuf-cpp:4
PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_4=(
	"4.25" # For python-cpp:4
)

# @ECLASS_VARIABLE:  PROTOBUF_PYTHON_SLOTS_5
# @DESCRIPTION:
# Adds all protobuf-python 5.x slots
PROTOBUF_PYTHON_SLOTS_5=(
	"5.29"
)

# @ECLASS_VARIABLE:  PROTOBUF_PYTHON_SLOTS_6
# @DESCRIPTION:
# Adds all protobuf-python 6.x slots
PROTOBUF_PYTHON_SLOTS_6=(
	"6.33"
)

# @FUNCTION:  protobuf_src_configure
# @DESCRIPTION:
# Append flags for C/C++ while passing LDFLAGS directly to linker
#
# Example:
#
# PROTOBUF_CPP_LINK_MODE="direct"
# PROTOBUF_CPP_SLOT="3"
# inherit protobuf
#
# src_configure() {
#   protobuf_src_configure
#   einfo "PROTOBUF_CPP_CFLAGS:  ${PROTOBUF_CPP_CFLAGS}"
#   einfo "PROTOBUF_CPP_LDFLAGS:  ${PROTOBUF_CPP_LDFLAGS}"
#   emake
# }
protobuf_src_configure() {
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

	# Sanitize/isolate multiabi pollution from logs
	filter-flags \
		"-I/usr/lib/protobuf/*/include" \
		"-Wl,-L/usr/lib/protobuf/*" \
		"-Wl,-rpath,/usr/lib/protobuf/*" \
		"-L/usr/lib/protobuf/*" \
		"--rpath,/usr/lib/protobuf/*"

	append-flags "-I/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/include"

	if [[ ${PROTOBUF_CPP_LINK_MODE:-"indirect"} == "indirect" ]] ; then
		# For manual configuration or sed patch
		export PROTOBUF_CPP_CFLAGS="-I/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/include"
		export PROTOBUF_CPP_CXXFLAGS="${PROTOBUF_CPP_CFLAGS}"
		export PROTOBUF_CPP_LDFLAGS="-Wl,-L/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/${libdir} -Wl,-rpath,/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/${libdir}"

		append-ldflags \
			"-Wl,-L/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/${libdir}" \
			"-Wl,-rpath,/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/${libdir}"
	else
		# For manual configuration or sed patch
		export PROTOBUF_CPP_CFLAGS="-I/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/include"
		export PROTOBUF_CPP_CXXFLAGS="${PROTOBUF_CPP_CFLAGS}"
		export PROTOBUF_CPP_LDFLAGS="-L/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/${libdir} --rpath=/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/${libdir}"

		append-ldflags \
			"-L/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/${libdir}" \
			"--rpath=/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/${libdir}"
	fi

	# Sanitize/isolate multiabi and multislot pollution from logs
	LD_LIBRARY_PATH=$(echo "${LD_LIBRARY_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/protobuf/|d" | tr $'\n' ":")
	PATH=$(echo "${PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/protobuf/|d" | tr $'\n' ":")
	PKG_CONFIG_PATH=$(echo "${PKG_CONFIG_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/protobuf/|d" | tr $'\n' ":")
	PYTHONPATH=$(echo "${PYTHONPATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/protobuf-python/|d" | tr $'\n' ":")

	export LD_LIBRARY_PATH="${ESYSROOT}/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/${libdir}/pkgconfig:${LD_LIBRARY_PATH}"
	export PATH="${ESYSROOT}/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/bin:${PATH}"
	export PKG_CONFIG_PATH="${ESYSROOT}/usr/lib/protobuf/${_PROTOBUF_CPP_SLOT}/${libdir}/pkgconfig:${PKG_CONFIG_PATH}"

	local x=""
	local s=""
	for x in "${PROTOBUF_PYTHON_SLOTS[@]}" ; do
		if has_version "dev-python/protobuf:${x}" ; then
			s="${x}"
			break
		fi
	done

	if [[ -n "${PROTOBUF_PYTHON_SLOTS[@]}" ]] ; then
		export PYTHONPATH="${ESYSROOT}/usr/lib/protobuf-python/${s}/lib/${EPYTHON}/site-packages:${PYTHONPATH}"
	else
ewarn "QA:  Setting protobuf-python support for PYTHONPATH is skipped.  Set PROTOBUF_PYTHON_SLOTS to remove this message."
	fi
}

# @FUNCTION:  protobuf_python_configure
# @DESCRIPTION:
# Alias for ebuild style consistency
protobuf_python_configure() {
	grpc_src_configure
}

# @FUNCTION:  protobuf_append_cmake
# @DESCRIPTION:
# Dump protobuf location into mycmakeargs for CMake's find_package().
#
# Example:
#
# PROTOBUF_CPP_SLOT="3"
# inherit cmake protobuf
#
# src_configure() {
#   protobuf_src_configure # Append or get rpath for build script modding.
#   local mycmakeargs=(
#     $(protobuf_append_cmake)
#   )
#   cmake_src_configure
# }
#
protobuf_append_cmake() {
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

fi
