# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: fix-rpath.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: GCC_COMPAT templates
# @DESCRIPTION:
# Fix a list of missing RPATHS

if [[ -z ${_FIX_RPATH_ECLASS} ]] ; then
_FIX_RPATH_ECLASS=1

inherit edo

BDEPEND="
	dev-util/patchelf
"

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
# Fix missing RPATHs
# Example:
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
fix-rpath_repair() {
	if [[ -z "${RPATH_FIXES}" ]] ; then
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
