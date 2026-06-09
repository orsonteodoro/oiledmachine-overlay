# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS:  cro.eclass
# @MAINTAINER:  Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS:  8
# @BLURB:  ~= version operator
# @DESCRIPTION:
# Add ~= compatibility release operator.

# This eclass used AI inference for help and contains AI output.

# In supply chain attacks, the versioning may feel out of place or is unusual.
# The operator can be used to harden against suspicious version bumps.

# See https://packaging.python.org/en/latest/specifications/version-specifiers/#version-specifiers-compatible-release
# Semantics
# ~= 1         invalid
# ~= 1.4       >= 1.4       && < 2.0
# ~= 1.4.2     >= 1.4.2     && < 1.5.0
# ~= 0.4       >= 0.4       && < 1.0
# ~= 0.4.1     >= 0.4.1     && < 0.5.0
# ~= 1.4.2.1   >= 1.4.2.1   && < 1.4.3.0
# ~= 1.4.2.1.5 >= 1.4.2.1.5 && < 1.4.3.2.0

# @FUNCTION:  cro
# @DESCRIPTION:
# Generate an ebuild compatible expression for the ~= operator.
# RDEPEND="
#	$(cro dev-python/uv-dynamic-versioning 1.2 '[${PYTHON_USEDEP}]')
# "
# Generates:
# RDEPEND="
#	>=dev-python/uv-dynamic-versioning-1.2[python_targets_python3_10(-)?,python_targets_python3_11(-)?,python_targets_python3_12(-)?,python_targets_python3_13(-)?,python_targets_python3_14(-)?]
#	<dev-python/uv-dynamic-versioning-2.0[python_targets_python3_10(-)?,python_targets_python3_11(-)?,python_targets_python3_12(-)?,python_targets_python3_13(-)?,python_targets_python3_14(-)?]
# "
cro() {
	local category_pn="${1}"	# e.g. sys-devel/gcc
	local pv="${2}"			# e.g. 1.4.2.1
	local use_dep="${3}"		# e.g. [${PYTHON_USEDEP}]
	local pv_0=$(ver_cut "1" "${pv}") # 1
	local pv_1=$(ver_cut "2" "${pv}") # 4
	local pv_2=$(ver_cut "3" "${pv}") # 2
	local pv_3=$(ver_cut "4" "${pv}") # 1
	local pv_4=$(ver_cut "5" "${pv}") # 1

	local stripped_len=${pv//./}
	local n_periods=$(( ${#pv} - ${#stripped_len} ))

	local t
	if (( ${n_periods} == 1 )) ; then
		t="
			>=${category_pn}-${pv}${use_dep}
			<${category_pn}-$(( ${pv_0} + 1 )).0${use_dep}
		"
	elif (( ${n_periods} == 2 )) ; then
		t="
			>=${category_pn}-${pv}${use_dep}
			<${category_pn}-${pv_0}.$(( ${pv_1} + 1 )).0${use_dep}
		"
	elif (( ${n_periods} == 3 )) ; then
		t="
			>=${category_pn}-${pv}${use_dep}
			<${category_pn}-${pv_0}.${pv_1}.$(( ${pv_3} + 1 )).0${use_dep}
		"
	elif (( ${n_periods} == 4 )) ; then
		t="
			>=${category_pn}-${pv}${use_dep}
			<${category_pn}-${pv_0}.${pv_1}.${pv_3}.$(( ${pv_4} + 1 )).0${use_dep}
		"
	else
die "> 4 periods is not supported for the cro (compatibility release operator) implementation."
	fi

	local output
	if declare -f cro_replace_dep ; then
		output=$(cro_replace_dep)
	else
		local t2
		t2="${t//\$\{PYTHON_USEDEP\}/${PYTHON_USEDEP}}"
		output="${t2//\$\{PYTHON_SINGLE_USEDEP\}/${PYTHON_SINGLE_USEDEP}}"
	fi
	echo "${output}"
}
