# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS:  re2.eclass
# @MAINTAINER:  Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS:  8
# @BLURB:  set multislot re2 config for build systems
# @DESCRIPTION:
# Helpers to support multislot re2.

case ${EAPI:-0} in
	[8]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_RE2_ECLASS} ]] ; then
_RE2_ECLASS=1

inherit flag-o-matic

# @FUNCTION:  re2_append_flags_direct
# @DESCRIPTION:
# Append flags for C/C++ while passing LDFLAGS directly to linker
#
# Example:
#
# RE2_SLOT="20240116"
# inherit re2
#
# src_configure() {
#   re2_append_flags_direct
#   einfo "RE2_CFLAGS:  ${RE2_CFLAGS}"
#   einfo "RE2_LDFLAGS:  ${RE2_LDFLAGS}"
# }
#
re2_append_flags_direct() {
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
		"-L/usr/lib/re2/*" \
		"--rpath,/usr/lib/re2/*"

	# For manual configuration or sed patch
	export RE2_CFLAGS="-I/usr/lib/re2/${_RE2_SLOT}/include"
	export RE2_CXXFLAGS="${RE2_CXXFLAGS}"
	export RE2_LDFLAGS="-L/usr/lib/re2/${_RE2_SLOT}/${libdir} --rpath=/usr/lib/re2/${_RE2_SLOT}/${libdir}"

	append-flags "-I/usr/lib/re2/${_RE2_SLOT}/include"
	append-ldflags \
		"-L/usr/lib/re2/${_RE2_SLOT}/${libdir}" \
		"--rpath=/usr/lib/re2/${_RE2_SLOT}/${libdir}"
}

# @FUNCTION:  re2_append_flags_indirect
# @DESCRIPTION:
# Append flags for C/C++ while passing LDFLAGS indirectly to linker
#
# Example:
#
# RE2_SLOT="20240116"
# inherit re2
#
# src_configure() {
#   re2_append_flags_indirect
#   einfo "RE2_CFLAGS:  ${RE2_CFLAGS}"
#   einfo "RE2_LDFLAGS:  ${RE2_LDFLAGS}"
# }
#
re2_append_flags_indirect() {
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

	# For manual configuration or sed patch
	export RE2_CFLAGS="-I/usr/lib/re2/${_RE2_SLOT}/include"
	export RE2_CXXFLAGS="${RE2_CXXFLAGS}"
	export RE2_LDFLAGS="-Wl,-L/usr/lib/re2/${_RE2_SLOT}/${libdir} -Wl,-rpath,/usr/lib/re2/${_RE2_SLOT}/${libdir}"

	append-flags "-I/usr/lib/re2/${_RE2_SLOT}/include"
	append-ldflags \
		"-Wl,-L/usr/lib/re2/${_RE2_SLOT}/${libdir}" \
		"-Wl,-rpath,/usr/lib/re2/${_RE2_SLOT}/${libdir}"
}

# @FUNCTION:  re2_append_mycmakeargs
# @DESCRIPTION:
# Dump absl location into mycmakeargs
#
# Example:
#
# RE2_SLOT="20240116"
# inherit re2
#
# src_configure() {
#   local mycmakeargs=(
#     $(re2_append_mycmakeargs)
#   )
# }
#
re2_append_mycmakeargs() {
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

# @FUNCTION:  re2_append_pkgconfig
# @DESCRIPTION:
# Dump absl location into PKG_CONFIG_PATH
#
# Example:
#
# RE2_SLOT="20240116"
# inherit re2
#
# src_configure() {
#   re2_append_pkgconfig
# }
#
re2_append_pkgconfig() {
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
	PKG_CONFIG_PATH=$(echo "${PKG_CONFIG_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/re2/|d" | tr $'\n' ":")

	export PKG_CONFIG_PATH="${ESYSROOT}/usr/lib/re2/${_RE2_SLOT}/${libdir}/pkgconfig:${PKG_CONFIG_PATH}"
}

# @FUNCTION:  re2_append_ld_library_path
# @DESCRIPTION:
# Dump absl location into LD_LIBRARY_PATH
#
# Example:
#
# RE2_SLOT="20240116"
# inherit re2
#
# src_configure() {
#   re2_append_ld_library_path
# }
#
re2_append_ld_library_path() {
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
	LD_LIBRARY_PATH=$(echo "${LD_LIBRARY_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/re2/|d" | tr $'\n' ":")

	export LD_LIBRARY_PATH="${ESYSROOT}/usr/lib/re2/${_RE2_SLOT}/${libdir}/pkgconfig:${LD_LIBRARY_PATH}"
}

fi
