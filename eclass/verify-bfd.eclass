# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# @ECLASS: vf.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Verify BFD version
# @DESCRIPTION:
# Verify BFD version against possibly vulnerable versions.
# The distro uses the trust but no verify model for the toolchain.
#

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_VERIFY_BFD_ECLASS} ]] ; then
_VERIFY_BFD_ECLASS=1

# Security-critical packages may set it to allow the latest subslot only.
VERIFY_BFD_SLOT=${_VERIFY_BFD_SLOT:-"2.45"} # Minimum allowed.  Usually 2 minor versions is acceptable.

# CE, MC, ID, DoS
# Mitigate poorly generated code
verify-bfd_check() {
	local bfd_pv=$(echo "${A}" | grep -E -o "[0-9]+\.[0-9]+\.[0-9]+" | tail -n 1)
	local bfd_pv_major=$(ver_cut "1" "${bfd_pv}")
	local bfd_pv_minor=$(ver_cut "2" "${bfd_pv}")

	if ver_test "${bfd_pv_major}" "-ge" "3" ; then
		:
	elif ver_test "${bfd_pv_major}" "-eq" "2" && ver_test "${bfd_pv_minor}" "-lt" "${VERIFY_BFD_SLOT#*.}" ; then
		if has "enforce" ${IUSE_EFFECTIVE} && use enforce ; then
eerror "Switch to >= ${_BFD_PV}"
			die
		else
ewarn "Your BFD is old."
ewarn "Expected version:  >= ${VERIFY_BFD_SLOT}"
ewarn "Actual version:  ${bfd_pv}"
		fi
	elif ver_test "${bfd_pv_major}" "-lt" "2" ; then
		if has "enforce" ${IUSE_EFFECTIVE} && use enforce ; then
eerror "Switch to >= ${_BFD_PV}"
			die
		else
ewarn "Your BFD is old."
ewarn "Expected version:  >= ${VERIFY_BFD_SLOT}"
ewarn "Actual version:  ${bfd_pv}"
		fi
	fi
}

fi
