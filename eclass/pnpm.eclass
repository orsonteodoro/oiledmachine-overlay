# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: pnpm.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 8
# @BLURB: Eclass for pnpm
# @DESCRIPTION:
# Add support for pnpm

# For additional slot availability send issue request.

#
# Hidden Rust dependency:
#
# If the lockfile contains reference to @swc/core specifically
#
#   @swc/core-linux-arm-gnueabihf
#   @swc/core-linux-arm64-gnu
#   @swc/core-linux-arm64-musl
#   @swc/core-linux-x64-gnu
#   @swc/core-linux-x64-musl
#   or similar,
#
# Rust BDEPEND and Rust path preappend should be added.  See the
# dev-util/jsonlint package for details.
#
# Use github search with commiter-date:YYYY-MM-DD to search for an
# approximation.
#
# Dependency graph:  Next.js -> @swc/core -> Rust
#

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
	[8]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z "${_PNPM_ECLASS}" ]]; then
_PNPM_ECLASS=1

inherit edo node

EXPORT_FUNCTIONS pkg_setup src_unpack src_compile

_pnpm_set_globals() {
	export PNPM_SLOT="${PNPM_SLOT:-9}"
	export PNPM_OFFLINE=${PNPM_OFFLINE:-1}
	export PNPM_NETWORK_FETCH_RETRIES=${PNPM_NETWORK_FETCH_RETRIES:-7}
	export PNPM_NETWORK_FETCH_RETRY_MAXTIMEOUT=${PNPM_NETWORK_FETCH_RETRY_MAXTIMEOUT:-300000}
	export PNPM_NETWORK_FETCH_RETRY_MINTIMEOUT=${PNPM_NETWORK_FETCH_RETRY_MINTIMEOUT:-60000}
	export PNPM_NETWORK_FETCH_TIMEOUT=${PNPM_NETWORK_FETCH_TIMEOUT:-300000}
	export PNPM_NETWORK_MAXSOCKETS=${PNPM_NETWORK_MAXSOCKETS:-1}
	export PNPM_NETWORK_NETWORK_CONCURRENCY=${PNPM_NETWORK_NETWORK_CONCURRENCY:-1}
	export COREPACK_ENABLE_DOWNLOAD_PROMPT=0
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

# @ECLASS_VARIABLE: _PNPM_PKG_SETUP_CALLED
# @INTERNAL
# @DESCRIPTION:
# Checks if state variables are initalized and network sandbox disabled.
_PNPM_PKG_SETUP_CALLED=0

# @ECLASS_VARIABLE: PNPM_TARBALL
# @DESCRIPTION:
# The main package tarball.

# @ECLASS_VARIABLE: PNPM_AUDIT_FIX
# @DESCRIPTION:
# Allow audit fix

# @ECLASS_VARIABLE: PNPM_AUDIT_FIX_ARGS
# @DESCRIPTION:
# This variable is an array.
# Global arguments to append to `pnpm audit --fix`

# @ECLASS_VARIABLE: PNPM_DEDUPE_ARGS
# @DESCRIPTION:
# This variable is an array.
# Global arguments to append to `pnpm dedupe`

# @ECLASS_VARIABLE: PNPM_ROOT
# @DESCRIPTION:
# The project root containing the pnpm-lock.yaml file.

# @FUNCTION: pnpm_check_network_sandbox
# @DESCRIPTION:
# Check the network sandbox.
pnpm_check_network_sandbox() {
# Corepack problems.  Cannot do complete offline install.
	if has "network-sandbox" ${FEATURES} ; then
eerror
eerror "Sandbox changes requested via per-package env for =${CATEGORY}/${PN}-${PVR}."
eerror "Reason:  To download micropackages and offline cache"
eerror
eerror "Contents of /etc/portage/env/no-network-sandbox.conf"
eerror "FEATURES=\"\${FEATURES} -network-sandbox\""
eerror
eerror "Contents of /etc/portage/package.env"
eerror "${CATEGORY}/${PN} no-network-sandbox.conf"
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
	(( ${_PNPM_PKG_SETUP_CALLED} == 0 )) && die "QA:  Call pnpm_pkg_setup() first"
# Cannot use pnpm for offline install with distfiles yet, so always online.
# This is why pnpm is avoided.
	if [[ "${NPM_OFFLINE:-1}" == "0" ]] ; then
		COREPACK_ENABLE_NETWORK="1" # It still requires online.
	else
		COREPACK_ENABLE_NETWORK="${COREPACK_ENABLE_NETWORK:-0}"
	fi
	if [[ ! -f "${EROOT}/usr/share/pnpm/pnpm-${PNPM_SLOT}.tgz" ]] ; then
eerror
eerror "Missing ${EROOT}/usr/share/pnpm/pnpm-${PNPM_SLOT}.tgz"
eerror
eerror "You must install sys-apps/pnpm:${PNPM_SLOT}::oiledmachine-overlay to"
eerror "continue."
eerror
		die
	fi
einfo "Hydrating pnpm..."
	corepack hydrate "${ESYSROOT}/usr/share/pnpm/pnpm-${PNPM_SLOT}.tgz" || die
	local pnpm_pv=$(basename $(realpath "${HOME}/.cache/node/corepack/v1/pnpm/"*))
	export PATH=".:${HOME}/.cache/node/corepack/v1/pnpm/${pnpm_pv}/bin:${PATH}"
	local pnpm_pv=$(pnpm --version)
	local node_pv=$(node --version)
einfo "pnpm version:  ${pnpm_pv}"
einfo "Node.js version:  ${node_pv}"

	pnpm_network_settings

	# Prevent node 18 issue when downloading:
	local node_slot=$(node --version \
		| sed -e "s|^v||g" \
		| cut -f 1 -d ".")
	if ver_test "${node_slot}" -eq "18" ; then
		export NODE_OPTIONS+=" --dns-result-order=ipv4first"
	fi
}

# @FUNCTION: pnpm_pkg_setup
# @DESCRIPTION:
# Checks node slot required for building
pnpm_pkg_setup() {
	if [[ -z "${NODE_SLOT}" ]] ; then
eerror "QA:  NODE_SLOT needs to be defined before calling npm_pkg_setup()."
		die
	fi

	node_setup
	pnpm_check_network_sandbox

	# Prevent node 18 issue when downloading:
	local node_slot=$(node --version \
		| sed -e "s|^v||g" \
		| cut -f 1 -d ".")
	if ver_test "${node_slot}" -eq "18" ; then
		export NODE_OPTIONS+=" --dns-result-order=ipv4first"
	fi

	# Corepack issue 612
	# Cached used to mitigate MITM
	#export COREPACK_INTEGRITY_KEYS=0 # Solution #1
	#export COREPACK_INTEGRITY_KEYS="$(curl https://registry.npmjs.org/-/npm/v1/keys | jq -c '{npm: .keys}')" # Solution 2
	export COREPACK_INTEGRITY_KEYS='{"npm":[{"expires":"2025-01-29T00:00:00.000Z","keyid":"SHA256:jl3bwswu80PjjokCgh0o2w5c2U4LhQAE57gj9cz1kzA","keytype":"ecdsa-sha2-nistp256","scheme":"ecdsa-sha2-nistp256","key":"MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE1Olb3zMAFFxXKHiIkQO5cJ3Yhl5i6UPp+IhuteBJbuHcA5UogKo0EWtlWwW6KSaKoTNEYL7JlCQiVnkhBktUgg=="},{"expires":null,"keyid":"SHA256:DhQ8wR5APBvFHLF/+Tc+AYvPOdTpcIDqOhxsBHRwC7U","keytype":"ecdsa-sha2-nistp256","scheme":"ecdsa-sha2-nistp256","key":"MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEY6Ya7W++7aUPzvMTrezH6Ycx3c+HOKYCcNGybJZSCJq/fd7Qa8uuAKtdIkUQtQiEKERhAmE5lMMJhP8OkDOa2g=="}]}'

	_PNPM_PKG_SETUP_CALLED=1
}

# @FUNCTION: _pnpm_setup_offline_cache
# @DESCRIPTION:
# Setup offline cache
_pnpm_setup_offline_cache() {
	pnpm config set preferOffline "true" || die
	mkdir -p "${HOME}/.local/share/pnpm"
	local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	if [[ -z "${PNPM_CACHE_FOLDER}" ]] ; then
		export PNPM_CACHE_FOLDER="${EDISTDIR}/pnpm-download-cache-${PNPM_SLOT}/${CATEGORY}/${P}"
	fi
einfo "DEBUG:  Default cache folder:  ${HOME}/.local/share/pnpm/store"
einfo "PNPM_CACHE_FOLDER:  ${PNPM_CACHE_FOLDER}"
	rm -rf "${HOME}/.local/share/pnpm/store"
	mkdir -p "${HOME}/.local/share/pnpm" || die
	ln -sf "${PNPM_CACHE_FOLDER}" "${HOME}/.local/share/pnpm/store"
	addwrite "${EDISTDIR}"
	addwrite "${PNPM_CACHE_FOLDER}"
	mkdir -p "${PNPM_CACHE_FOLDER}"
	pnpm config set store-dir "${PNPM_CACHE_FOLDER}" || die
}

# @FUNCTION: pnpm_src_unpack
# @DESCRIPTION:
# Unpacks a pnpm application.
pnpm_src_unpack() {
	pnpm_hydrate

	if [[ "${PV}" =~ "9999" ]] ; then
		:
	elif [[ -n "${PNPM_TARBALL}" ]] ; then
		unpack "${PNPM_TARBALL}"
	else
		unpack "${P}.tar.gz"
	fi

	cd "${S}" || die
	if [[ "${PNPM_OFFLINE}" == "1" ]] ; then
		_pnpm_setup_offline_cache
		if [[ "${PNPM_UPDATE_LOCK}" == "1" ]] ; then
			:
		elif [[ -e "${FILESDIR}/${PV}" && -n "${PNPM_ROOT}" ]] ; then
			cp -aT "${FILESDIR}/${PV}" "${PNPM_ROOT}" || die
		elif [[ -e "${FILESDIR}/${PV}" ]] ; then
			cp -aT "${FILESDIR}/${PV}" "${S}" || die
		fi
	fi
	mkdir -p "${HOME}/.local/share/pnpm"
	export PATH="${S}/node_modules/.bin:${PATH}"
	if declare -f pnpm_unpack_post >/dev/null 2>&1 ; then
		pnpm_unpack_post
	fi
	if declare -f pnpm_install_pre >/dev/null 2>&1 ; then
		pnpm_install_pre
	fi
	if [[ -e ".npmrc" ]] ; then
		sed -i \
			-e "s|lockfile=false|lockfile=true|g" \
			".npmrc" \
			|| die
	fi
	pnpm config set lockfile true || die
	epnpm install "${PNPM_INSTALL_ARGS[@]}"
	if [[ "${PNPM_UPDATE_LOCK}" == "1" ]] ; then
		epnpm install --lockfile-only
	fi
	if declare -f pnpm_install_post >/dev/null 2>&1 ; then
		pnpm_install_post
	fi
	if [[ "${PNPM_UPDATE_LOCK}" == "1" ]] ; then
		if declare -f pnpm_audit_pre >/dev/null 2>&1 ; then
			pnpm_audit_pre
		fi
		if [[ "${PNPM_AUDIT_FIX:-1}" == "1" ]] ; then
			edo pnpm audit --fix "${PNPM_AUDIT_FIX_ARGS[@]}"
		fi
		if declare -f pnpm_audit_post >/dev/null 2>&1 ; then
			pnpm_audit_post
		fi
		if [[ "${PNPM_DEDUPE:-1}" == "1" ]] ; then
			edo pnpm dedupe "${PNPM_DEDUPE_ARGS[@]}"
		fi
		if declare -f pnpm_dedupe_post >/dev/null 2>&1 ; then
			pnpm_dedupe_post
		fi
	fi
	grep -e "ERR_PNPM_FETCH_404" "${T}/build.log" && die "Detected error.  Check pnpm add"
}

# @FUNCTION: pnpm_src_compile
# @DESCRIPTION:
# Builds a pnpm application.
pnpm_src_compile() {
	epnpm run build
	grep -q -e "Failed to compile" "${T}/build.log" && die "Detected error"
}

fi
