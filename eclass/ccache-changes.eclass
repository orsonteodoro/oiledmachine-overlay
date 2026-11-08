# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ccache-changes.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: request ccache changes
# @DESCRIPTION:
# Display common ccache changes required

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z "${_CCACHE_CHANGES_ECLASS}" ]] ; then
_CCACHE_CHANGES_ECLASS=1

# @FUNCTION: ccache-changes_no_feature
# @DESCRIPTION:
# Template
ccache-changes_no_feature() {
	local feature_name="${1}"
	local reason="${2}"

	if [[ "${FEATURES}" =~ (^|" ")"${feature_name}"($|" ") ]] ; then
eerror
eerror "Ccache changes requested via per-package env for =${CATEGORY}/${PN}-${PVR}."
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

# @FUNCTION: ccache-changes_yes_feature
# @DESCRIPTION:
# Template
ccache-changes_yes_feature() {
	local feature_name="${1}"
	local reason="${2}"

	if ! [[ "${FEATURES}" =~ (^|" ")"${feature_name}"($|" ") ]] ; then
eerror
eerror "Ccache changes requested via per-package env for =${CATEGORY}/${PN}-${PVR}."
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

# @FUNCTION: ccache-changes_no_ccache
# @DESCRIPTION:
# Ask user to disable ccache
ccache-changes_no_ccache() {
	local reason="${1}"
	ccache-changes_no_feature "ccache" "${reason}"
}

# @FUNCTION: ccache-changes_no_ccache
# @DESCRIPTION:
# Ask user to enable ccache
ccache-changes_yes_ccache() {
	local reason="${1}"
	ccache-changes_yes_feature "ccache" "${reason}"
}

fi
