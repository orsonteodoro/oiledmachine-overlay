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

# For additional slot availability send issue request.

# @ECLASS_VARIABLE: PNPM_OFFLINE
# @DESCRIPTION:
# 1 - offline preferred, 0 - online

# @ECLASS_VARIABLE: PNPM_SLOT
# @DESCRIPTION:
# The version of the pnpm lockfile. (Default:  9)
# lockfile version | pnpm version
# 9                | 9.15.x, 10.0.x
# 8                | 8.0.x, 8.15.x
# 6                | 7.33.x
# 5.4              | 6.32.x, 6.33.x, 6.34.x, 6.35.x, 7.0.x
# 5.3              | 5.18.x, 6.0.x, 6.31.x
# 5.2              | 5.16.x, 5.17.x
# 5.1              | 3.5.0, 3.8.x, 4.0.x, 4.14.x, 5.0.2
# 5                | 3.0.x, 3.4.0                               # lockfileVersion (pnpm-lock.yaml)
# 4                | 2.25.x (shri)                              # shrinkwrapVersion (shrinkwrap.yaml)


case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z "${_PNPM_ECLASS}" ]]; then
_PNPM_ECLASS=1

EXPORT_FUNCTIONS pkg_setup src_unpack src_compile

_pnpm_set_globals() {
	export PNPM_OFFLINE=${PNPM_OFFLINE:-1}
	export PNPM_NETWORK_FETCH_RETRIES=${PNPM_NETWORK_FETCH_RETRIES:-7}
	export PNPM_NETWORK_FETCH_RETRY_MAXTIMEOUT=${PNPM_NETWORK_FETCH_RETRY_MAXTIMEOUT:-300000}
	export PNPM_NETWORK_FETCH_RETRY_MINTIMEOUT=${PNPM_NETWORK_FETCH_RETRY_MINTIMEOUT:-60000}
	export PNPM_NETWORK_FETCH_TIMEOUT=${PNPM_NETWORK_FETCH_TIMEOUT:-300000}
	export PNPM_NETWORK_MAXSOCKETS=${PNPM_NETWORK_MAXSOCKETS:-1}
	export PNPM_NETWORK_NETWORK_CONCURRENCY=${PNPM_NETWORK_NETWORK_CONCURRENCY:-1}
}
_pnpm_set_globals
unset -f _pnpm_set_globals

if [[ -n "${PNPM_SLOT}" ]] ; then
	BDEPEND+="
		sys-apps/pnpm:${PNPM_SLOT}
	"
else
	BDEPEND+="
		sys-apps/pnpm:9
	"
fi

# @ECLASS_VARIABLE: PNPM_INSTALL_ARGS
# @DESCRIPTION:
# This variable is an array.
# Global arguments to append to `pnpm install`

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
einfo "Current directory:\t${PWD}"
einfo "Running:\t\tpnpm $@"
	pnpm "$@" || die
}

# @FUNCTION: pnpm_network_settings
# @DESCRIPTION:
# Smooth out network settings.
pnpm_network_settings() {
	pnpm config set fetch-retries ${PNPM_NETWORK_FETCH_RETRIES} || die # 2 -> lucky number 7
	pnpm config set fetch-retry-maxtimeout ${PNPM_NETWORK_FETCH_RETRY_MAXTIMEOUT} || die # 1 min -> 5 min
	pnpm config set fetch-retry-mintimeout ${PNPM_NETWORK_FETCH_RETRY_MINTIMEOUT} || die # 10 s -> 1 min
	pnpm config set fetch-timeout ${PNPM_NETWORK_FETCH_TIMEOUT} || die # 1 min -> 5 min
	pnpm config set network-concurrency ${PNPM_NETWORK_NETWORK_CONCURRENCY} || die # 16 -> 1
	pnpm config set maxsockets ${PNPM_NETWORK_MAXSOCKETS} || die # 3 * network-concurrency -> 1
}

# @FUNCTION: pnpm_hydrate
# @DESCRIPTION:
# Load pnpm in the sandbox.
pnpm_hydrate() {
# Cannot use pnpm for offline install with distfiles yet, so always online.
# This is why pnpm is avoided.
	pnpm_check_network_sandbox
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
	local pnpm_pv=$(basename $(realpath "${HOME}/.cache/node/corepack/v1/pnpm/"*))
	export PATH=".:${HOME}/.cache/node/corepack/v1/pnpm/${pnpm_pv}/bin:${PATH}"
	pnpm_network_settings
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
	: #pnpm_check_network_sandbox
}

# @FUNCTION: pnpm_src_unpack
# @DESCRIPTION:
# Unpacks a pnpm application.
pnpm_src_unpack() {
	pnpm_hydrate
	if [[ "${PNPM_OFFLINE}" == "1" ]] ; then
		pnpm config set preferOffline "true" || die
	fi

	mkdir -p "${HOME}/.local/share/pnpm"
	export PNPM_CACHE_FOLDER="${EDISTDIR}/pnpm-download-cache-${PNPM_SLOT}/${CATEGORY}/${P}"
	einfo "DEBUG:  Default cache folder:  ${HOME}/.local/share/pnpm/store"
	einfo "PNPM_OFFLINE:  ${PNPM_OFFLINE}"
	einfo "PNPM_CACHE_FOLDER:  ${PNPM_CACHE_FOLDER}"
	mkdir -p "${HOME}/.local/share/pnpm" || die
	ln -s "${PNPM_CACHE_FOLDER}" "${HOME}/.local/share/pnpm/store"
	addwrite "${EDISTDIR}"
	addwrite "${PNPM_CACHE_FOLDER}"
	mkdir -p "${PNPM_CACHE_FOLDER}"
	pnpm config set store-dir "${PNPM_CACHE_FOLDER}" || die

	export PATH="${S}/node_modules/.bin:${PATH}"
	epnpm install \
		${PNPM_INSTALL_ARGS[@]}
}

# @FUNCTION: pnpm_src_compile
# @DESCRIPTION:
# Builds a pnpm application.
pnpm_src_compile() {
	epnpm run build
}

fi
