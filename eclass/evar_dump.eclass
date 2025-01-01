# Copyright 2019-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: evar_dump.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Print variables
# @DESCRIPTION:
# Print variables with pretty formatting.

# @ECLASS_VARIABLE: EVAR_DUMP_VAR_LENGTH
# @DESCRIPTION:
# Variable width with padding

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_EVAR_DUMP_ECLASS} ]]; then
_EVAR_DUMP_ECLASS=1

_evar_dump_set_globals() {
	EVAR_DUMP_VAR_LENGTH="${EVAR_DUMP_VAR_LENGTH:-30}"
}
_evar_dump_set_globals
unset -f _evar_dump_set_globals

# @FUNCTION: evar_dump
# @DESCRIPTION:
# Print the name and the variable contents in the same column.
#
# Example:
#
#   evar_dump "S" "${S}"
#
evar_dump() {
	local k="${1}"
	local v="${2}"
	printf " \e[32m*\e[0m %${EVAR_DUMP_VAR_LENGTH}s : %s\n" "${k}" "${v}"
}

# @FUNCTION: evar_dump_raw
# @DESCRIPTION:
# Print the name and the assocative array contents.
#
# Example:
#
#   evar_dump_raw "S"
#
evar_dump_raw() {
	local k="${1}"
	local v=$(declare -p "${k}")
	printf " \e[32m*\e[0m %${EVAR_DUMP_VAR_LENGTH}s : %s\n" "${k}" "${v}"
}

fi
