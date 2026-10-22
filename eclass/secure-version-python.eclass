# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: secure-versions-python.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8 9
# @BLURB: secure versions for python
# @DESCRIPTION:
# Install *only* secure versions for python.

case ${EAPI:-0} in
	[789]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z "${_SECURE_VERSION_PYTHON_ECLASS}" ]] ; then
_SECURE_VERSION_PYTHON_ECLASS=1

# You must prefix your entry with PYTHON_

PYTHON_DIFFUSERS_PV=${PYTHON_DIFFUSERS_PV:-"0.39.0"}
PYTHON_PILLOW_PV=${PYTHON_PILLOW_PV:-"13.0.0"}

# 1.107.x is banned for supply chain attack, RAT, infostealer.  AI cited version.  Discussed on social media.  No CVE
# 1.91.1 is considered insecure by AI.  CVE-2026-93355, CVE-2026-84377
# All versions on the overlays page are insecure.
# One overlay still has the malware release on the portage overlays page.
PYTHON_LITELLM_PV=${PYTHON_LITELLM_PV:-"1.106.2"}
PYTHON_LITELLM_1_106_PV=${PYTHON_LITELLM_1_106_PV:-"1.106.2"}
PYTHON_LITELLM_1_105_PV=${PYTHON_LITELLM_1_105_PV:-"1.105.3"}
PYTHON_LITELLM_1_104_PV=${PYTHON_LITELLM_1_104_PV:-"1.104.5"}
PYTHON_LITELLM_1_103_PV=${PYTHON_LITELLM_1_103_PV:-"1.103.7"}

PYTHON_SELENIUM_PV=${PYTHON_SELENIUM_PV:-"4.44.0"}

secure-version-python_gen_litellm_depends() {
	local range="${1}" # 1.103; 1.103-r, 1.103-, <empty string>
	local usedep="${2}" # [debug], [${PYTHON_SINGLE_USEDEP}], <empty string>

	local t=""
	t+="
		!=dev-python/litellm-1.107*
		|| (
	"
	local l="" # Min
	local r="" # Max
	if [[ -z "${range}" ]] ; then
	# All ranges
		l="1.103"
		r="1.106"
	elif [[ "${range}" =~ "-" ]] ; then
		l="${range%-*}"
		r="${range#*-}"
		if [[ -z "${l}" ]] ; then
	# Min slot
			l="1.103"
		fi
		if [[ -z "${r}" ]] ; then
	# Max slot
			r="1.106"
		fi
	else
		l="${range}"
		r="${range}"
	fi
	local L=(
		"1.106"
		"1.105"
		"1.104"
		"1.103"
	)
	local x
	for x in "${L[@]}" ; do
		if ver_test "${l}" "-le" "${x}" && ver_test "${x}" "-le" "${r}" ; then
			local u="PYTHON_LITELLM_${x/./_}_PV"
#einfo "${u} ${x} ${!u}"
			t+="
				>=dev-python/litellm-${!u}${usedep}
			"
		fi
	done
	t+="
		)
	"

	local output=""
	local t2=""

	if [[ "${_PYTHON_SINGLE_R1_ECLASS}" == "1" ]] ; then
                t2="${t//\$\{PYTHON_SINGLE_USEDEP\}/${PYTHON_SINGLE_USEDEP}}"
	else
		t2="${t}"
	fi

	output="${t2}"
#einfo "${output}"
	echo "${output}"
}

fi
