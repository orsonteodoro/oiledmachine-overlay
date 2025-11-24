# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS:  abseil-cpp.eclass
# @MAINTAINER:  Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS:  8
# @BLURB:  set multislot abseil-cpp config for build systems
# @DESCRIPTION:
# Helpers to support multislot abseil-cpp.

case ${EAPI:-0} in
	[8]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_ABSEIL_CPP_ECLASS} ]] ; then
_ABSEIL_CPP_ECLASS=1

inherit flag-o-matic

# @FUNCTION:  abseil-cpp_append_flags_direct
# @DESCRIPTION:
# Append flags for C/C++ with passing LDFLAGS directly to linker
abseil-cpp_append_flags_direct() {
	local _ABSEIL_CPP_SLOT=""
	if [[ "${ABSEIL_CPP_PV}" ]] ; then
		_ABSEIL_CPP_SLOT="${ABSEIL_CPP_PV%.*}"
	elif [[ "${ABSEIL_CPP_SLOT}" ]] ; then
		_ABSEIL_CPP_SLOT="${ABSEIL_CPP_SLOT%.*}"
	else
eerror "Set either ABSEIL_CPP_PV or ABSEIL_CPP_SLOT"
		die
	fi
	local libdir=$(get_libdir)

	# Sanitize/isolate
	filter-flags \
		"-I/usr/lib/abseil-cpp/*/include" \
		"-L/usr/lib/abseil-cpp/*" \
		"--rpath,/usr/lib/abseil-cpp/*"

	append-flags "-I/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/include"
	append-ldflags \
		"-L/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir}" \
		"--rpath=/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir}"
}

# @FUNCTION:  abseil-cpp_append_flags_indirect
# @DESCRIPTION:
# Append flags for C/C++ with passing LDFLAGS indirectly to linker
abseil-cpp_append_flags_indirect() {
	local _ABSEIL_CPP_SLOT=""
	if [[ "${ABSEIL_CPP_PV}" ]] ; then
		_ABSEIL_CPP_SLOT="${ABSEIL_CPP_PV%.*}"
	elif [[ "${ABSEIL_CPP_SLOT}" ]] ; then
		_ABSEIL_CPP_SLOT="${ABSEIL_CPP_SLOT%.*}"
	else
eerror "Set either ABSEIL_CPP_PV or ABSEIL_CPP_SLOT"
		die
	fi
	local libdir=$(get_libdir)

	# Sanitize/isolate
	filter-flags \
		"-I/usr/lib/abseil-cpp/*/include" \
		"-Wl,-L/usr/lib/abseil-cpp/*" \
		"-Wl,-rpath,/usr/lib/abseil-cpp/*"

	append-flags "-I/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/include"
	append-ldflags \
		"-Wl,-L/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir}" \
		"-Wl,-rpath,/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir}"
}

# @FUNCTION:  abseil-cpp_append_mycmakeargs
# @DESCRIPTION:
# Dump absl location into mycmakeargs
abseil-cpp_append_mycmakeargs() {
	local _ABSEIL_CPP_SLOT=""
	if [[ "${ABSEIL_CPP_PV}" ]] ; then
		_ABSEIL_CPP_SLOT="${ABSEIL_CPP_PV%.*}"
	elif [[ "${ABSEIL_CPP_SLOT}" ]] ; then
		_ABSEIL_CPP_SLOT="${ABSEIL_CPP_SLOT%.*}"
	else
eerror "Set either ABSEIL_CPP_PV or ABSEIL_CPP_SLOT"
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
# Dump absl location into mycmakeargs
abseil-cpp_append_pkgconfig() {
	local _ABSEIL_CPP_SLOT=""
	if [[ "${ABSEIL_CPP_PV}" ]] ; then
		_ABSEIL_CPP_SLOT="${ABSEIL_CPP_PV%.*}"
	elif [[ "${ABSEIL_CPP_SLOT}" ]] ; then
		_ABSEIL_CPP_SLOT="${ABSEIL_CPP_SLOT%.*}"
	else
eerror "Set either ABSEIL_CPP_PV or ABSEIL_CPP_SLOT"
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
abseil-cpp_append_ld_library_path() {
	local _ABSEIL_CPP_SLOT=""
	if [[ "${ABSEIL_CPP_PV}" ]] ; then
		_ABSEIL_CPP_SLOT="${ABSEIL_CPP_PV%.*}"
	elif [[ "${ABSEIL_CPP_SLOT}" ]] ; then
		_ABSEIL_CPP_SLOT="${ABSEIL_CPP_SLOT%.*}"
	else
eerror "Set either ABSEIL_CPP_PV or ABSEIL_CPP_SLOT"
		die
	fi
	local libdir=$(get_libdir)

	# Sanitize/isolate
	LD_LIBRARY_PATH=$(echo "${LD_LIBRARY_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/abseil-cpp/|d" | tr $'\n' ":")

	export LD_LIBRARY_PATH="${ESYSROOT}/usr/lib/abseil-cpp/${_ABSEIL_CPP_SLOT}/${libdir}/pkgconfig:${LD_LIBRARY_PATH}"
}

fi
