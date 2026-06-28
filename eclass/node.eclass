# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS:  node.eclass
# @MAINTAINER:  Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS:  8
# @BLURB:  set multislot node config
# @DESCRIPTION:
# Helpers to support multislot node for parallel emerge.

# This eclass use AI inference for clarification.

case ${EAPI:-0} in
	[8]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_NODE_ECLASS} ]] ; then
_NODE_ECLASS=1

# See https://github.com/nodejs/node/blob/main/src/node_version.h
_NODE_LIVE_VERSION="27"

# See LTS tags in under status in https://nodejs.org/en/about/previous-releases
_NODE_LTS_SLOTS=(
	"24"
	"22"
)

inherit flag-o-matic

# @FUNCTION:  _node_package_json_check_lts_required
# @DESCRIPTION:
# A helper function for FAFO users and node_check_if_nodejs_live_compatible().
#
# Most popular JS packages will use one of these so live nodejs ebuilds is out
# of the question.
_node_package_json_check_lts_required() {
	local pkg="${x}"
	local path="${x}"
	local L=(
	#
	# Typically if an engines -> node sections exist in the package.json, it
	# is version sensitive.
	#
	# TODO:  Add version verification
	#
	# Manual inspection for slot compatibility is more efficient.
	#
	# We want to use Node.js live but it is not possible because the most
	# popular ones listed below are using LTS (even major versions of
	# Node.js).
	#
		"@babel/cli"
		"@babel/core"
		"@types/node"						# Missing engines.node
		"@swc/core"
		"bcrypt"
		"canvas"
		"chalk"
		"drizzle-orm"						# Missing engines.node, but contains typescript
		"esbuild-wasm"
		"esbuild"
		"execa"
		"got"
		"jest"
		"mocha"
		"ts-jest"
		"ts-node"						# Missing engines.node, but contains @swc/core and @types/node
		"gulp"
		"next"
		"nock"
		"node-addon-api"
		"node-fetch"
		"node-gyp"
		"node-sass"
		"pm2"
		"nodemon"
		"openai"						# Missing engines.node, but contains @swc/core and @types/node
		"oracledb"
		"pg"							# Missing engines.node, but contains @types/node
		"postgres"
		"rollup"
		"sass-embedded"
		"sharp"
		"sqlite3"
		"tiktoken"						# Missing engines.node, but contains @types/node
		"typescript"
		"vite"
		"webpack"
	)
	local row
	for row in "${L[@]}" ; do
		local pn="${row%%;*}"
		if grep -r -e "\"${pn}\"" "${x}" ; then
			return 0
		fi
	done
	return 1
}

# @FUNCTION:  node_check_if_nodejs_live_compatible
# @DESCRIPTION:
# Scan for likely breakage with live nodejs.  Use this if you have no clue if
# you should be using Node.js LTS or Node.js live.  It is not necessary to
# have this in most cases if you take the time to read the package.json and
# lockfiles.  It is recommended to limit the Node.js slot available than use
# this function which can be expensive for large projects.
# Use it after unpacking or after restoring lockfiles.
# If not compatible it will be a fatal error.
node_check_if_nodejs_live_compatible() {
	local node_pv=$(node --version)
	node_pv=${node_pv:1}

	local is_live=0 # Is Node.js live?
	if ver_test "${node_pv}" "-ge" "${_NODE_LIVE_VERSION}" ; then
		is_live=1
	fi

	local x
	local is_lts=0 # Is Node.js LTS?
	for x in "${_NODE_LTS_SLOTS[@]}" ; do
		if ver_test "${node_pv%%.*}" "-eq" "${x}" ; then
			is_lts=1
		fi
	done

	local x
	for x in $(find "${WORKDIR}" -name "package.json") ; do
		if _node_package_json_check_lts_required "${x}" && (( ${is_live} == 1 || ${is_lts} == 0 )) ; then
			if (( ${is_live} == 1 )) ; then
eerror "QA:  Node.js live is not supported for ${x}."
			elif (( ${is_lts} == 0 )) ; then
eerror "QA:  Node.js non-LTS is not supported for ${x}."
			fi
eerror "QA:  Limit the allowed Node.js slots to build against."
			die
		fi
	done
}

# @FUNCTION:  node_setup
# @DESCRIPTION:
# Setup multislot node for early src_unpack (live ebuilds) or during src_configure phase.
node_setup() {
# We generally only allow one because sometime it takes too long to build or download.
# The build or release quality will degrade if untested.
	if [[ -z "${NODE_SLOT}" ]] ; then
eerror "QA:  NODE_SLOT must be defined"
		die
	fi

	# Sanitize paths for logs
	filter-flags "-I*/usr/lib/node/*"
	export PATH=$(echo "${PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/node/|d" | tr $'\n' ":")

	local prefix="${ESYSROOT}/usr/lib/node/${NODE_SLOT}"
	append-flags "-I${prefix}/include"
	export PATH="${prefix}/bin:${PATH}"
einfo "PATH:  ${PATH}"
}

fi
