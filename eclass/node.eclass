# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS:  node.eclass
# @MAINTAINER:  Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS:  8
# @BLURB:  set multislot node config
# @DESCRIPTION:
# Helpers to support multislot node for parallel emerge.

case ${EAPI:-0} in
	[8]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_NODE_ECLASS} ]] ; then
_NODE_ECLASS=1

inherit flag-o-matic

# @FUNCTION:  node_setup
# @DESCRIPTION:
# Setup multislot node for early src_unpack (live ebuilds) or during src_configure phase.
node_setup() {
	if [[ -n "${NODE_SLOT}" ]] ; then
eerror "QA:  NODE_SLOT must be defined"
		die
	fi

	# Sanitize paths for logs
	filter-flags "-I*/usr/bin/node/*"
	PATH=$(echo "${PATH}" | tr ":" $'\n' | sed -e "\|/usr/bin/node/|d" | tr $'\n' ":")

	append-flags "-I${ESYSROOT}/usr/bin/node/${NODE_SLOT}/include"
	export PATH="${ESYSROOT}/usr/bin/node/${NODE_SLOT}/bin"
}

fi
