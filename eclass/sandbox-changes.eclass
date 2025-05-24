# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: sandbox-changes.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: request sandbox changes
# @DESCRIPTION:
# Display common sandbox changes required

if [[ -z "${_SANDBOX_CHANGES_ECLASS}" ]] ; then
_SANDBOX_CHANGES_ECLASS=1

# @FUNCTION: sandbox-changes_no_feature
# @DESCRIPTION:
# Template
sandbox-changes_no_feature() {
	local feature_name="${1}"
	local reason="${2}"

	if [[ "${FEATURES}" =~ "${feature_name}" ]] ; then
eerror
eerror "Sandbox changes requested via per-package env for =${CATEGORY}/${PN}-${PVR}."
		if [[ -n "${reason}" ]] ; then
eerror "Reason:  ${reason}"
		fi
eerror
eerror "Contents of /etc/portage/env/no-${feature_name}.conf:"
eerror "FEATURES=\"\${FEATURES} -${feature_name}\""
eerror
eerror "Contents of /etc/portage/package.env:"
eerror "${CATEGORY}/${PN} no-${feature_name}.conf"
eerror
		die
	fi
}

# @FUNCTION: sandbox-changes_yes_feature
# @DESCRIPTION:
# Template
sandbox-changes_yes_feature() {
	local feature_name="${1}"
	local reason="${2}"

	if ! [[ "${FEATURES}" =~ "${feature_name}" ]] ; then
eerror
eerror "Sandbox changes requested via per-package env for =${CATEGORY}/${PN}-${PVR}."
		if [[ -n "${reason}" ]] ; then
eerror "Reason:  ${reason}"
		fi
eerror
eerror "Contents of /etc/portage/env/yes-${feature_name}.conf:"
eerror "FEATURES=\"\${FEATURES} ${feature_name}\""
eerror
eerror "Contents of /etc/portage/package.env:"
eerror "${CATEGORY}/${PN} yes-${feature_name}.conf"
eerror
		die
	fi
}

# @FUNCTION: sandbox-changes_no_userpriv
# @DESCRIPTION:
# Ask user to disable userpriv
sandbox-changes_no_userpriv() {
	local reason="${1}"
	sandbox-changes_no_feature "userpriv" "${reason}"
}

# @FUNCTION: sandbox-changes_no_network_sandbox
# @DESCRIPTION:
# Ask user to disable network-sandbox
sandbox-changes_no_network_sandbox() {
	local reason="${1}"
	sandbox-changes_no_feature "network-sandbox" "${reason}"
}

# @FUNCTION: sandbox-changes_no_usersandbox
# @DESCRIPTION:
# Ask user to disable network-sandbox
sandbox-changes_no_usersandbox() {
	local reason="${1}"
	sandbox-changes_no_feature "usersandbox" "${reason}"
}

fi
