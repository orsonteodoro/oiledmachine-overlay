# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: bun.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for bun offline install
# @DESCRIPTION:
# Eclass similar to the cargo.eclass.

# For additional slot availability send issue request.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z "${_BUN_ECLASS}" ]]; then
_BUN_ECLASS=1

inherit edo

EXPORT_FUNCTIONS pkg_setup src_unpack src_compile

# @ECLASS_VARIABLE: BUN_SLOT
# @DESCRIPTION:
# Bun lockfile compatibility
# Slot      | Version
# 1.2       | 1.2.x (bun.lock)
# 1.1       | 1.1.x (bun.lockb)
# 1.0       | 1.0.x (bun.lockb)
# 0.8       | 0.8.x (bun.lockb)
# 0.7       | 0.7.x (bun.lockb)

# @ECLASS_VARIABLE: BUN_TARBALL
# @DESCRIPTION:
# The main package tarball.

# @ECLASS_VARIABLE: BUN_ROOT
# @DESCRIPTION:
# The project root containing the bun.lock or bun.lockb file.

if [[ -n "${BUN_SLOT}" ]] ; then
	BDEPEND+="
		sys-apps/bun:${BUN_SLOT}
	"
else
	BDEPEND+="
		sys-apps/bun:1.2
	"
fi

# @FUNCTION: _bun_set_globals
# @DESCRIPTION:
# Setup global variables
_bun_set_globals() {
	:
}

_bun_set_globals
unset -f _bun_set_globals

ebun() {
	edo bun "$@"
}

# @FUNCTION: bun_pkg_setup
# @DESCRIPTION:
# Prepare bun
bun_pkg_setup() {
	:
}

# @FUNCTION: _bun_setup_offline_cache
# @DESCRIPTION:
# Setup offline cache
_bun_setup_offline_cache() {
	local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	if [[ -z "${BUN_CACHE_FOLDER}" ]] ; then
		export BUN_CACHE_FOLDER="${EDISTDIR}/bun-download-cache-${BUN_SLOT}/${CATEGORY}/${P}"
	fi
einfo "DEBUG:  Default cache folder:  ${HOME}/.bun/install/cache"
einfo "BUN_CACHE_FOLDER:  ${BUN_CACHE_FOLDER}"
	rm -rf "${HOME}/.bun/install/cache"
	ln -s "${BUN_CACHE_FOLDER}" "${HOME}/.bun/install/cache"
	addwrite "${EDISTDIR}"
	addwrite "${BUN_CACHE_FOLDER}"
	mkdir -p "${BUN_CACHE_FOLDER}"
}

# @FUNCTION: bun_src_unpack
# @DESCRIPTION:
# Install bun micropackages
bun_src_unpack() {
	if [[ -n "${BUN_TARBALL}" ]] ; then
		unpack ${BUN_TARBALL}
	else
		unpack ${A}
	fi
	if [[ -n "${BUN_ROOT}" ]] ; then
		cd "${BUN_ROOT}" || die
	else
		cd "${S}" || die
	fi
	ebun install --prefer-offline
}

# @FUNCTION: bun_src_compile
# @DESCRIPTION:
# Build bun package
bun_src_compile() {
	ebun run build
}

fi
