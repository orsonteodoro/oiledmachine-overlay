# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS:  tilde.eclass
# @MAINTAINER:  Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS:  8
# @BLURB:  ~ version operator
# @DESCRIPTION:
# Add ~ tilde operator for package versioning

# This eclass used AI inference for help and contains AI output.

# In supply chain attacks, the versioning may feel out of place or is unusual.
# The operator can be used to harden against suspicious version bumps.

# Semantics
# ~0.45.2.7    >= 0.45.2.7  && < 0.45.3.0
# ~0.45.2      >= 0.45.2    && < 0.46.0
# ~0.45        >= 0.45.0    && < 0.46.0
# ~1           >= 1.0.0     && < 2.0.0
# ~1.4         >= 1.4.0     && < 1.5.0
# ~1.4.1       >= 1.4.1     && < 1.5.0
# ~1.4.3.4     >= 1.4.3.4   && < 1.4.4.0

# @FUNCTION:  tilde
# @DESCRIPTION:
# Generate an ebuild compatible expression for the ~ operator.
# RDEPEND="
#	$(tilde dev-util/foo 1.4 '[${PYTHON_USEDEP}]')
# "
# Generates:
# RDEPEND="
#	>=dev-util/foo-1.4[python_targets_python3_10(-)?,python_targets_python3_11(-)?,python_targets_python3_12(-)?,python_targets_python3_13(-)?,python_targets_python3_14(-)?]
#	<dev-util/foo-1.5[python_targets_python3_10(-)?,python_targets_python3_11(-)?,python_targets_python3_12(-)?,python_targets_python3_13(-)?,python_targets_python3_14(-)?]
# "
tilde() {
	local category_pn="${1}"	# e.g. dev-util
	local pv="${2}"			# e.g. 1.4.2.3
	local use_dep="${3}"		# e.g. [${PYTHON_USEDEP}]
	local pv_0=$(ver_cut "1" "${pv}") # 1
	local pv_1=$(ver_cut "2" "${pv}") # 4
	local pv_2=$(ver_cut "3" "${pv}") # 2
	local pv_3=$(ver_cut "4" "${pv}") # 3

	local stripped_len=${pv//./}
	local n_periods=$(( ${#pv} - ${#stripped_len} ))

	local t
	if (( ${n_periods} == 0 )) ; then
		t="
			>=${category_pn}-${pv}${use_dep}					# 1
			<${category_pn}-$(( ${pv_0} + 1 ))${use_dep}				# 2
		"
	elif (( ${n_periods} == 1 )) ; then
		t="
			>=${category_pn}-${pv}${use_dep}					# 1.4
			<${category_pn}-${pv_0}.$(( ${pv_1} + 1 ))${use_dep}			# 1.5
		"
	elif (( ${n_periods} == 2 )) ; then
		t="
			>=${category_pn}-${pv}${use_dep}					# 1.4.1
			<${category_pn}-${pv_0}.$(( ${pv_1} + 1 )).0${use_dep}			# 1.5.0
		"
	elif (( ${n_periods} == 3 )) ; then
		t="
			>=${category_pn}-${pv}${use_dep}					# 1.4.3.4
			<${category_pn}-${pv_0}.${pv_1}.$(( ${pv_2} + 1 )).0${use_dep}		# 1.4.4.0
		"
	else
die "> 4 periods are not supported for the ~ (tilde) implementation."
	fi

	local output
	if declare -f tilde_replace_dep ; then
		output=$(tilde_replace_dep)
	else
		local t2
		t2="${t//\$\{PYTHON_USEDEP\}/${PYTHON_USEDEP}}"
		output="${t2//\$\{PYTHON_SINGLE_USEDEP\}/${PYTHON_SINGLE_USEDEP}}"
	fi
	echo "${output}"
}
