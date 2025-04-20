# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: go-offline-cache.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for offline gocache/gomod
# @DESCRIPTION:
# Eclass to setup paths

if [[ -z "${_GO_OFFLINE_CACHE}" ]]; then
_GO_OFFLINE_CACHE=1

# @FUNCTION: _check_network_sandbox
# @DESCRIPTION:
# Check if sandbox is more lax when downloading in unpack phase
_go-offline-cache_check_network_sandbox() {
	if has network-sandbox ${FEATURES} ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download go micropackages."
eerror
eerror "Contents of /etc/portage/env/disable-sandbox.conf:"
eerror "FEATURES=\"\${FEATURES} -network-sandbox\""
eerror
eerror "Contents of /etc/portage/package.env:"
eerror "${CATEGORY}/${PN} disable-sandbox.conf"
eerror
		die
	fi
}

# @FUNCTION: go-offline-cache_setup
# @DESCRIPTION:
# Changes the download caches to distdir so they do not get wiped.  Place before
# any calls in src_unpack() or src_compile().
#
# Examples:
# src_unpack() {
#	go-offline-cache_setup
#	unpack ${A}
# }
# src_compile() {
#	go-offline-cache_setup
#	emake build
# }
go-offline-cache_setup() {
	_go-offline-cache_check_network_sandbox
	local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	local cache_path_actual="${EDISTDIR}/go-cache/${CATEGORY}/${PN}"
	local modcache_path_actual="${EDISTDIR}/go-modcache/${CATEGORY}/${PN}"
	export GOCACHE="${cache_path_actual}"
	export GOMODCACHE="${modcache_path_actual}"
	addwrite "${EDISTDIR}"

	mkdir -p "${cache_path_actual}"
	addwrite "${cache_path_actual}"

	mkdir -p "${modcache_path_actual}"
	addwrite "${modcache_path_actual}"
einfo "GOCACHE:  ${GOCACHE}"
einfo "GOMODCACHE:  ${GOMODCACHE}"
	#go env
}


fi
