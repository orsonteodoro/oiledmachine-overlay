# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# @ECLASS: verify-binutils.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Verify binutils version
# @DESCRIPTION:
# Verify Binutils (implying the BFD) version against possibly vulnerable versions.
# The distro uses the trust but no verify model for the toolchain.
#

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_VERIFY_BINUTILS_ECLASS} ]] ; then
_VERIFY_BINUTILS_ECLASS=1

# Security-critical packages may set it to allow the latest subslot only.
VERIFY_BINUTILS_SLOT=${_VERIFY_BINUTILS_SLOT:-"2.45"} # Minimum allowed.  Usually 2 minor versions is acceptable.

# CE, MC, ID, DoS
# Mitigate poorly generated code by BFD
verify-binutils_check() {
	local _default_chost="CHOST_${DEFAULT_ABI}"
	local default_chost="${!_default_chost}"
	local binutils_pv=$(cat "${ESYSROOT}/etc/env.d/binutils/config-${default_chost}" | cut -f 2 -d "=")
	local binutils_pv_major=$(ver_cut 1 "${binutils_pv}")
	local binutils_pv_minor=$(ver_cut 2 "${binutils_pv}")

	if ver_test "${binutils_pv_major}" "-ge" "3" ; then
		:
	elif ver_test "${binutils_pv_major}" "-eq" "2" && ver_test "${binutils_pv_minor}" "-lt" "${VERIFY_BINUTILS_SLOT#*.}" ; then
		if has "enforce" ${IUSE_EFFECTIVE} && use enforce ; then
eerror "Switch to >= ${_BINUTILS_PV}"
			die
		else
ewarn "Your Binutils which distributes the BFD linker is old.  Use \`eselect binutils\` to change the Binutils version to a more secure version."
ewarn "Binutils actual version:  ${binutils_pv}"
ewarn "Binutils expected version:  >= ${VERIFY_BINUTILS_SLOT}"
		fi
	elif ver_test "${binutils_pv_major}" "-lt" "2" ; then
		if has "enforce" ${IUSE_EFFECTIVE} && use enforce ; then
eerror "Switch to >= ${_BINUTILS_PV}"
			die
		else
ewarn "Your Binutils which distributes the BFD linker is old."
ewarn "Binutils actual version:  ${binutils_pv}"
ewarn "Binutils expected version:  >= ${VERIFY_BINUTILS_SLOT}"
		fi
	fi
}

fi
