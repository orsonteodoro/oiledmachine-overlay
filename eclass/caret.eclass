# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS:  caret.eclass
# @MAINTAINER:  Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS:  8
# @BLURB:  ^ version operator
# @DESCRIPTION:
# Add ^ caret operator for js/cargo packages.

# This eclass used AI inference for help and contains AI output.

# In supply chain attacks, the versioning may feel out of place or is unusual.
# The operator can be used to harden against suspicious version bumps.

# Semantics
# ^0.45.1.5    >= 0.45.1.5  && < 0.46.0
# ^0.45.1      >= 0.45.1    && < 0.46.0
# ^0.45        >= 0.45.0    && < 0.46.0
# ^0           >= 0.0.0     && < 1.0.0
# ^1           >= 1.0.0     && < 2.0.0
# ^1.4         >= 1.4.0     && < 2.0.0
# ^1.4.1       >= 1.4.1     && < 2.0.0
# ^1.4.3.4     >= 1.4.3.4   && < 2.0.0.0

# @FUNCTION:  caret
# @DESCRIPTION:
# Generate an ebuild compatible expression for the ^ operator.
# RDEPEND="
#	$(caret dev-util/foo 1.4 '[${PYTHON_USEDEP}]')
# "
# Generates:
# RDEPEND="
#	>=dev-util/foo-1.4[python_targets_python3_10(-)?,python_targets_python3_11(-)?,python_targets_python3_12(-)?,python_targets_python3_13(-)?,python_targets_python3_14(-)?]
#	<dev-util/foo-2.0[python_targets_python3_10(-)?,python_targets_python3_11(-)?,python_targets_python3_12(-)?,python_targets_python3_13(-)?,python_targets_python3_14(-)?]
# "
caret() {
	local category_pn="${1}"	# e.g. dev-util
	local pv="${2}"			# e.g. 1.4.2
	local use_dep="${3}"		# e.g. [${PYTHON_USEDEP}]
	local pv_0=$(ver_cut "1" "${pv}") # 1
	local pv_1=$(ver_cut "2" "${pv}") # 4
	local pv_2=$(ver_cut "3" "${pv}") # 2

	local stripped_len=${pv//./}
	local n_periods=$(( ${#pv} - ${#stripped_len} ))

	local t
	if (( ${pv_0} == 0 )) ; then
		if (( ${n_periods} == 0 )) ; then
			t="
				>=${category_pn}-${pv}${use_dep}
				<${category_pn}-1.0.0${use_dep}
			"
		elif (( ${n_periods} == 1 )) ; then
			t="
				>=${category_pn}-${pv}${use_dep}
				<${category_pn}-0.$(( ${pv_1} + 1 )).0${use_dep}
			"
		elif (( ${n_periods} == 2 )) ; then
			t="
				>=${category_pn}-${pv}${use_dep}
				<${category_pn}-0.$(( ${pv_1} + 1 )).0${use_dep}
			"
		elif (( ${n_periods} == 3 )) ; then
			t="
				>=${category_pn}-${pv}${use_dep}
				<${category_pn}-0.$(( ${pv_1} + 1 )).0${use_dep}
			"
		else
die ">= 4 periods is not supported for the ^ (caret) implementation."
		fi
	else
		if (( ${n_periods} == 0 )) ; then
			t="
				>=${category_pn}-${pv}${use_dep}
				<${category_pn}-$(( ${pv_0} + 1 )).0${use_dep}
			"
		elif (( ${n_periods} == 1 )) ; then
			t="
				>=${category_pn}-${pv}${use_dep}
				<${category_pn}-$(( ${pv_0} + 1 )).0${use_dep}
			"
		elif (( ${n_periods} == 2 )) ; then
			t="
				>=${category_pn}-${pv}${use_dep}
				<${category_pn}-$(( ${pv_0} + 1 )).0.0${use_dep}
			"
		elif (( ${n_periods} == 3 )) ; then
			t="
				>=${category_pn}-${pv}${use_dep}
				<${category_pn}-$(( ${pv_0} + 1 )).0.0.0${use_dep}
			"
		elif (( ${n_periods} == 4 )) ; then
			t="
				>=${category_pn}-${pv}${use_dep}
				<${category_pn}-$(( ${pv_0} + 1 )).0.0.0.0${use_dep}
			"
		else
die ">= 5 periods is not supported for the ^ (caret) implementation."
		fi
	fi

	local output
	if declare -f caret_replace_dep ; then
		output=$(caret_replace_dep)
	else
		local t2
		t2="${t//\$\{PYTHON_USEDEP\}/${PYTHON_USEDEP}}"
		output="${t2//\$\{PYTHON_SINGLE_USEDEP\}/${PYTHON_SINGLE_USEDEP}}"
	fi
	echo "${output}"
}
