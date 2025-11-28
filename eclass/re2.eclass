# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS:  re2.eclass
# @MAINTAINER:  Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS:  8
# @BLURB:  set multislot re2 config for build systems
# @DESCRIPTION:
# Helpers to support multislot re2.

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

if [[ -z ${_RE2_ECLASS} ]] ; then
_RE2_ECLASS=1

inherit flag-o-matic

# @FUNCTION:  re2_src_configure
# @DESCRIPTION:
# Append flags for C/C++ while passing LDFLAGS directly to linker
#
# Example:
#
# RE2_SLOT="20240116"
#
# inherit re2
#
# src_configure() {
#   re2_src_configure
#   einfo "RE2_CFLAGS:  ${RE2_CFLAGS}"
#   einfo "RE2_LDFLAGS:  ${RE2_LDFLAGS}"
#
#   econf
# }
#
re2_src_configure() {
	local _RE2_SLOT=""
	if [[ "${RE2_PV}" ]] ; then
		_RE2_SLOT="${RE2_PV%.*}"
	elif [[ "${RE2_SLOT}" ]] ; then
		_RE2_SLOT="${RE2_SLOT%.*}"
	else
eerror "QA:  Set either RE2_PV or RE2_SLOT"
		die
	fi
	local libdir=$(get_libdir)

	# Sanitize/isolate
	filter-flags \
		"-I/usr/lib/re2/*/include" \
		"-Wl,-L/usr/lib/re2/*" \
		"-Wl,-rpath,/usr/lib/re2/*"
		"-L/usr/lib/re2/*" \
		"--rpath=/usr/lib/re2/*"

	if [[ ${RE2_LINK_MODE:-"indirect"} == "indirect" ]] ; then
		# For manual configuration or sed patch
		export RE2_CFLAGS="-I/usr/lib/re2/${_RE2_SLOT}/include"
		export RE2_CXXFLAGS="${RE2_CXXFLAGS}"
		export RE2_LDFLAGS="-Wl,-L/usr/lib/re2/${_RE2_SLOT}/${libdir} -Wl,-rpath,/usr/lib/re2/${_RE2_SLOT}/${libdir}"

		append-flags "-I/usr/lib/re2/${_RE2_SLOT}/include"
		append-ldflags \
			"-Wl,-L/usr/lib/re2/${_RE2_SLOT}/${libdir}" \
			"-Wl,-rpath,/usr/lib/re2/${_RE2_SLOT}/${libdir}"
	else
		# For manual configuration or sed patch
		export RE2_CFLAGS="-I/usr/lib/re2/${_RE2_SLOT}/include"
		export RE2_CXXFLAGS="${RE2_CXXFLAGS}"
		export RE2_LDFLAGS="-L/usr/lib/re2/${_RE2_SLOT}/${libdir} --rpath=/usr/lib/re2/${_RE2_SLOT}/${libdir}"

		append-flags "-I/usr/lib/re2/${_RE2_SLOT}/include"
		append-ldflags \
			"-L/usr/lib/re2/${_RE2_SLOT}/${libdir}" \
			"--rpath=/usr/lib/re2/${_RE2_SLOT}/${libdir}"

	fi

	# Sanitize/isolate
	LD_LIBRARY_PATH=$(echo "${LD_LIBRARY_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/re2/|d" | tr $'\n' ":")
	PKG_CONFIG_PATH=$(echo "${PKG_CONFIG_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/re2/|d" | tr $'\n' ":")

	export LD_LIBRARY_PATH="${ESYSROOT}/usr/lib/re2/${_RE2_SLOT}/${libdir}/pkgconfig:${LD_LIBRARY_PATH}"
	export PKG_CONFIG_PATH="${ESYSROOT}/usr/lib/re2/${_RE2_SLOT}/${libdir}/pkgconfig:${PKG_CONFIG_PATH}"
}

# @FUNCTION:  re2_python_configure
# @DESCRIPTION:
# Alias for ebuild style consistency
# Example:
#
# RE2_SLOT="20240116"
#
# inherit re2
#
# src_configure() {
#   re2_python_configure
# }
#
re2_python_configure() {
	re2_src_configure
}

# @FUNCTION:  re2_append_cmake
# @DESCRIPTION:
# Dump absl location into mycmakeargs
#
# Example:
#
# RE2_SLOT="20240116"
#
# inherit re2
#
# src_configure() {
#   local mycmakeargs=(
#     $(re2_append_cmake)
#   )
# }
#
re2_append_cmake() {
	local _RE2_SLOT=""
	if [[ "${RE2_PV}" ]] ; then
		_RE2_SLOT="${RE2_PV%.*}"
	elif [[ "${RE2_SLOT}" ]] ; then
		_RE2_SLOT="${RE2_SLOT%.*}"
	else
eerror "QA:  Set either RE2_PV or RE2_SLOT"
		die
	fi

	local name
	if [[ -n "${1}" ]] ; then
		name="${1}"
	else
		name="re2"
	fi
	local libdir=$(get_libdir)
	echo "-D${name}_DIR=/usr/lib/re2/${_RE2_SLOT}/${libdir}/cmake/absl"
}

fi
