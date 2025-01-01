# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: dhms.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: measures ebuild completion time
# @DESCRIPTION:
# Measures the ebuild completion time for large packages.  This is to discourage
# ricer flags such as pgo, lto, which can cause unintended consequences like a
# vulnerability backlog.
#
# It also can be used just for the dhms_get function to for an instance measure
# time since last security update and encourage/recommend users update to
# the next security release.
#

if [[ -z "${_DHMS_ECLASS}" ]] ; then
_DHMS_ECLASS=1

# @ECLASS_VARIABLE: DHMS_OUTPUT
# @DESCRIPTION:
# Selects the output method.
# Valid values:
#   einfo - report it to standard output (default)
#   elog - report it to system logs
#   quiet - disable reporting

# @ECLASS_VARIABLE: _DHMS_TIME_START
# @INTERNAL
# @DESCRIPTION:
# Start time of build
_DHMS_TIME_START=0

# @ECLASS_VARIABLE: _DHMS_TIME_END
# @INTERNAL
# @DESCRIPTION:
# End time of build
_DHMS_TIME_END=0

# @FUNCTION: dhms_get
# @DESCRIPTION:
# Gets the days, hours, minutes, seconds as a string
dhms_get() {
	local time_start=${1}
	local time_end=${2}
	local _day=$((60*60*24))
	local _hour=$((60*60))
	local _minute=60
	local t
	t=$((${time_end} - ${time_start})) # Seconds elapsed
	local days_passed=$(( ${t} / ${_day} ))
	local hours_passed=$(( ${t} % ${_day} ))
	t=${hours_passed}
	hours_passed=$(( ${t} / ${_hour} ))
	local minutes_passed=$(( ${t} % ${_hour} ))
	t=${minutes_passed}
	minutes_passed=$(( ${t} / ${_minute} ))
	local seconds_passed=$(( ${t} % ${_minute} ))
	local dhms_passed="${days_passed} days, ${hours_passed} hrs, ${minutes_passed} mins, ${seconds_passed} secs"
	echo "${dhms_passed}"
}

# @FUNCTION: dhms_start
# @DESCRIPTION:
# Start watch
dhms_start() {
	export _DHMS_TIME_START=${EPOCHSECONDS}
}

# @FUNCTION: dhms_start
# @DESCRIPTION:
# End watch and report completion time
dhms_end() {
	export _DHMS_TIME_END=${EPOCHSECONDS}
	local dhms_passed=$(dhms_get ${_DHMS_TIME_START} ${_DHMS_TIME_END})
	local dhms_output="${DHMS_OUTPUT:-einfo}"
	if [[ "${dhms_output}" == "einfo" ]] ; then
einfo "Completion time:  ${dhms_passed}"
	elif [[ "${dhms_output}" == "elog" ]] ; then
elog "Completion time:  ${dhms_passed}"
	fi
	local _day=$((60*60*24))
	if (( ${_DHMS_TIME_END} > ${_DHMS_TIME_START} + ${_day} )) ; then
ewarn "Critical vulnerabilities are assumed to be fixed within a day."
	fi
}

fi
