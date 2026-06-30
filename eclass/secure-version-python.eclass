# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: secure-versions-python.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 8 9
# @BLURB: secure versions for python
# @DESCRIPTION:
# Install *only* secure versions for python.

case ${EAPI:-0} in
	[89]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z "${_SECURE_VERSION_NODE_ECLASS}" ]] ; then
_SECURE_VERSION_NODE_ECLASS=1

# You must prefix your entry with PYTHON_

PYTHON_SELENIUM_PV=${PYTHON_SELENIUM_PV:-"4.44.0"}

fi
