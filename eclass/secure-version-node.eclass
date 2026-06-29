# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: secure-versions.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 8 9
# @BLURB: secure versions for node/electron
# @DESCRIPTION:
# Install *only* secure versions for node/electron micropackages.

case ${EAPI:-0} in
	[89]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z "${_SECURE_VERSION_NODE_ECLASS}" ]] ; then
_SECURE_VERSION_NODE_ECLASS=1

# Entries below must have a NODE_ prefix to prevent clobbering.


fi
