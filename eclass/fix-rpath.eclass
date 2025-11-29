# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: fix-rpath.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 8
# @BLURB: GCC_COMPAT templates
# @DESCRIPTION:
# Fix a list of missing RPATHS

case ${EAPI:-0} in
	[8]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_FIX_RPATH_ECLASS} ]] ; then
_FIX_RPATH_ECLASS=1

inherit edo

BDEPEND="
	dev-util/patchelf
"

# @ECLASS_VARIABLE:  RPATH_LINK_MODE
# @DESCRIPTION:
# Controls style of linking.
# Valid values:
# indirect - Flags are passed directly to the compiler which passes it to the linker.  (default)
# direct - Flags are passed directly to the linker.

# @ECLASS_VARIABLE:  RPATH_APPEND
# @DESCRIPTION:
# An array of multislotted paths for the dynamic library search.
#
# Example:
#
# RPATH_APPEND=(
#   "<rpath #0>"
#   "<rpath #1>"
#   "<rpath #2>"
#   ...
#   "<rpath #N>"
# )
#

# @ECLASS_VARIABLE:  RPATH_FIXES
# @DESCRIPTION:
# A list of executibles or library files with library paths to repair.
#
# Example:
#
# RPATH_FIXES=(
#   "<lib or exe path #0>:<list of comma separated path(s) containing the dynamic library>"
#   "<lib or exe path #1>:<list of comma separated path(s) containing the dynamic library>"
#   "<lib or exe path #2>:<list of comma separated path(s) containing the dynamic library>"
#   ...
#   "<lib or exe path #N>:<list of comma separated path(s) containing the dynamic library>"
# )
#

# @FUNCTION:  fix-rpath_src_configure
# @DESCRIPTION:
# Add RPATHs.  This method is the preferred way for open source based projects
# for proper testing.
#
# Example:
#
# multilib_src_configure() {
#	local RPATH_APPEND=(
#		"/usr/lib/abseil-cpp/${ABSEIL_CPP_SLOT}/$(get_libdir)"
#		"/usr/lib/grpc/${PROTOBUF_SLOT}/$(get_libdir)"
#		"/usr/$(get_libdir)/eog"
#	)
#	fix-rpath_src_configure
#
#	econf
# }
#
fix-rpath_src_configure() {
	if [[ -z "${RPATH_APPEND[@]}" ]] ; then
eerror "RPATH_APPEND must be initialized before calling fix-rpath_src_configure()."
		die
	fi

	local x
	for x in "${RPATH_APPEND[@]}" ; do
		if [[ ${RPATH_LINK_MODE:-"indirect"} == "indirect" ]] ; then
			append-ldflags "-Wl,-L${x}"
			append-ldflags "-Wl,-rpath,${x}"
		else
			append-ldflags "-L${x}"
			append-ldflags "--rpath=${x}"
		fi
	done
}

# @FUNCTION:  fix-rpath_python_configure
# @DESCRIPTION:
# Alias for fix-rpath_src_configure for consistent style.
#
# Example:
#
# python_configure() {
#	local RPATH_APPEND=(
#		"/usr/lib/abseil-cpp/${ABSEIL_CPP_SLOT}/$(get_libdir)"
#		"/usr/lib/grpc/${PROTOBUF_SLOT}/$(get_libdir)"
#		"/usr/$(get_libdir)/eog"
#	)
#	fix-rpath_python_configure
# }
#
fix-rpath_python_configure() {
	fix-rpath_src_configure
}

# @FUNCTION:  fix-rpath_verify
# @DESCRIPTION:
# Peform verification only
fix-rpath_verify() {
	[[ "${FIX_RPATH_VERIFY:-1}" == "1" ]] || return
einfo "Verifying dynamic link completeness"
	local x
	for x in $(find . "${ED}") ; do
		local is_exe=0
		local is_shared_lib=0
		file "${x}" | grep -q -e "ELF.*executable" && is_exe=1
		file "${x}" | grep -q -e "ELF.*shared object" && is_shared_lib=1
		(( ${is_exe} == 1 || ${is_shared_lib} == 1 )) || continue
		if ldd "${x}" | grep -q -e "not found" ; then
			if [[ "${FIX_RPATH_VERIFY_FATAL:-1}" == "1" ]] ; then
eerror "QA:  ${x} failed RPATH verification.  Runtime failure may happen.  Report the issue to the ebuild maintainer."
				die
			else
ewarn "QA:  ${x} failed RPATH verification.  Runtime failure may happen.  Report the issue to the ebuild maintainer."
			fi
		fi
	done
}

# @FUNCTION:  fix-rpath_repair
# @DESCRIPTION:
# Fix missing RPATHs.  It should only be used if build system is hermetic or prebuilt binaries.
#
# Example:
#
# src_install() {
#	local RPATH_FIXES=(
#		"${ED}/usr/bin/bear:/usr/lib/abseil-cpp/${ABSEIL_CPP_SLOT}/$(get_libdir),/usr/lib/grpc/${PROTOBUF_SLOT}/$(get_libdir)"
#		"${ED}/usr/$(get_libdir)/eog/plugins/libfullscreen.so:/usr/$(get_libdir)/eog"
#		"${ED}/usr/$(get_libdir)/eog/plugins/libreload.so:/usr/$(get_libdir)/eog"
#		"${ED}/usr/$(get_libdir)/eog/plugins/libstatusbar-date.so:/usr/$(get_libdir)/eog"
#	)
#	fix-rpath_repair
#	fix-rpath_verify
# }
#
fix-rpath_repair() {
	if [[ -z "${RPATH_FIXES[@]}" ]] ; then
eerror "RPATH_FIXES must be initialized before calling fix-rpath_repair()."
		die
	fi

	local x
	for x in "${RPATH_FIXES[@]}" ; do
		local f="${x%:*}"
		local source_paths="${x#*:}"
		if [[ ! -e "${f}" ]] ; then
ewarn "Missing ${f}"
			continue
		fi
		IFS="," read -ra _paths <<< "${source_paths}"
		local y
		for y in "${_paths[@]}" ; do
			edo patchelf --add-rpath "${y}" "${f}"
		done
	done
}

fi
