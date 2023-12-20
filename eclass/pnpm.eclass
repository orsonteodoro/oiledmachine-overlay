# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: pnpm.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for pnpm
# @DESCRIPTION:
# Add support for pnpm

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_PNPM_ECLASS} ]]; then
_PNPM_ECLASS=1

EXPORT_FUNCTIONS pkg_setup src_unpack src_compile

_pnpm_set_globals() {
	PNPM_TRIES="${PNPM_TRIES:-10}"
	PNPM_NETWORK_FETCH_RETRIES=${PNPM_NETWORK_FETCH_RETRIES:-"7"}
	PNPM_NETWORK_RETRY_MINTIMEOUT=${PNPM_NETWORK_RETRY_MINTIMEOUT:-"100000"}
	PNPM_NETWORK_RETRY_MAXTIMEOUT=${PNPM_NETWORK_RETRY_MAXTIMEOUT:-"300000"}
	PNPM_NETWORK_MAX_SOCKETS=${PNPM_NETWORK_MAX_SOCKETS:-"1"}
}
_pnpm_set_globals
unset -f _pnpm_set_globals

if [[ -n "${PNPM_SLOT}" ]] ; then
	BDEPEND+="
		sys-apps/pnpm:${PNPM_SLOT}
	"
else
	BDEPEND+="
		sys-apps/pnpm:8
	"
fi

# @FUNCTION: pnpm_check_network_sandbox
# @DESCRIPTION:
# Check the network sandbox.
pnpm_check_network_sandbox() {
# Corepack problems.  Cannot do complete offline install.
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download micropackages."
eerror
		die
	fi
}

# @FUNCTION: epnpm
# @DESCRIPTION:
# Wrapper for the pnpm command.
epnpm() {
	pnpm "$@" || die
}


# @FUNCTION: pnpm_hydrate
# @DESCRIPTION:
# Load pnpm in the sandbox.
pnpm_hydrate() {
# Cannot use pnpm for offline install with distfiles yet, so always online.
# This is why pnpm is avoided.
	npm_check_network_sandbox
	if [[ "${NPM_OFFLINE:-1}" == "0" ]] ; then
		COREPACK_ENABLE_NETWORK="1" # It still requires online.
	else
		COREPACK_ENABLE_NETWORK="${COREPACK_ENABLE_NETWORK:-0}"
	fi
	local pnpm_slot="${PNPM_SLOT:-8}"
	if [[ ! -f "${EROOT}/usr/share/pnpm/pnpm-${pnpm_slot}.tgz" ]] ; then
eerror
eerror "Missing ${EROOT}/usr/share/pnpm/pnpm-${pnpm_slot}.tgz"
eerror
eerror "You must install sys-apps/pnpm:${pnpm_slot}::oiledmachine-overlay to"
eerror "continue."
eerror
		die
	fi
einfo "Hydrating pnpm..."
	corepack hydrate "${ESYSROOT}/usr/share/pnpm/pnpm-${pnpm_slot}.tgz" || die
	local pnpm_pv=$(basename $(realpath "${HOME}/.cache/node/corepack/pnpm/"*))
	export PATH=".:${HOME}/.cache/node/corepack/pnpm/${pnpm_pv}/bin:${PATH}"
}

# @FUNCTION: pnpm_pkg_setup
# @DESCRIPTION:
# Checks node slot required for building
pnpm_pkg_setup() {
	local found=0
	local slot
	local node_pv=$(node --version \
		| sed -e "s|v||g")
	if [[ -n "${NODE_SLOTS}" ]] ; then
		for slot in ${NODE_SLOTS} ; do
			if has_version "=net-libs/nodejs-${slot}*" \
				&& (( ${node_pv%%.*} == ${slot} )) ; then
				export NODE_VERSION=${slot}
				found=1
				break
			fi
		done
		if (( ${found} == 0 )) ; then
eerror
eerror "Did not find the preferred nodejs slot."
eerror "Expected node versions:  ${NODE_SLOTS}"
eerror
eerror "Try one of the following:"
eerror
			local s
			for s in ${NODE_SLOTS} ; do
eerror "  eselect nodejs set node${s}"
			done

eerror
eerror "See eselect nodejs for more details."
eerror
			die
		fi
	elif [[ -n "${NODE_VERSION}" ]] ; then
		if has_version "=net-libs/nodejs-${NODE_VERSION}*" \
			&& (( ${node_pv%%.*} == ${NODE_VERSION} )) ; then
			found=1
		fi
		if (( ${found} == 0 )) ; then
eerror
eerror "Did not find the preferred nodejs slot."
eerror "Expected node version:  ${NODE_VERSION}"
eerror
eerror "Try the following:"
eerror
eerror "  eselect nodejs set node$(ver_cut 1 ${NODE_VERSION})"
eerror
eerror "See eselect nodejs for more details."
eerror
			die
		fi
	fi
	:;#npm_check_network_sandbox
}

# @FUNCTION: pnpm_src_unpack
# @DESCRIPTION:
# Unpacks a pnpm application.
pnpm_src_unpack() {
	pnpm_hydrate
	export PATH="${S}/node_modules/.bin:${PATH}"
	epnpm install
}

# @FUNCTION: pnpm_src_compile
# @DESCRIPTION:
# Builds a pnpm application.
pnpm_src_compile() {
	epnpm run build
}

fi
