# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# @ECLASS: vf.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Report the latest Vulnerability Fixes (VF)
# @DESCRIPTION:
# This eclass is used to report vulnerabilities fixed to encourage to update
# vulnerable software, to educate about vulnerabilities, to encourage to
# mark KEYWORDS faster as stable.
#

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_VULNERABILITIES_FIXED_ECLASS} ]] ; then
_VULNERABILITIES_FIXED_ECLASS=1

# @ECLASS_VARIABLE: VULNERABILITIES_FIXED
# @DESCRIPTION:
# A list of vulnerabilities fixed for this release cycle.
#
# Example:
# VULNERABILITIES_FIXED=(
#	"CVE-2024-50262;DoS, DT, ID;High"
#	"CVE-2024-50260;DoS;Medium"
#	"CVE-2024-50083;ZC, DoS;High"
# )
#
# The CVE-xxxx-xxxxx can be replace with a custom identifier such
# as a 7 digit hash, GLSA, etc.
#

# @FUNCTION: vf_show
# @DESCRIPTION:
# Shows the vulnerabilities fixed for this release cycle.
vf_show() {
	if [[ -n "${MITIGATION_URI}" ]] ; then
einfo "Patched vulnerabilities:"
		IFS=$'\n'
		local x
		for x in ${VULNERABILITIES_FIXED[@]} ; do
			local cve=$(echo "${x}" | cut -f 1 -d ";")
			local vulnerability_classes=$(echo "${x}" | cut -f 2 -d ";")
			local severity=$(echo "${x}" | cut -f 3 -d ";")
einfo "${cve}:  ${vulnerability_classes} (CVSS 3.1 ${severity})"
		done
		IFS=$' \t\n'
einfo
	#
	# Glossary
	#
	# Most rows just need DoS, DT, ID.
	#
	# The remaining are to be used as a fallback when it is not clear that
	# it is a DoS, DT, ID as the CVSS is still being evaluated.
	#
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "CE" ]] ; then
einfo "CE = Code Execution"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "DoS" ]] ; then
einfo "DoS = Denial of Service"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "DT" ]] ; then
einfo "DT = Data Tampering"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "ID" ]] ; then
einfo "ID = Information Disclosure"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "IOOR" ]] ; then
einfo "IOOR = Index Out Of Range"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "ML" ]] ; then
einfo "ML = Memory Leak"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "NPD" ]] ; then
einfo "NPD = Null Pointer Dereference"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "OOB" ]] ; then
einfo "OOB = Out Of Bounds Access"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "PE" ]] ; then
einfo "PE = Privilege Escalation"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "RC" ]] ; then
einfo "RC = Race Condition"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "SCI" ]] ; then
einfo "SCI = Shellcode Command Injection"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "UAF" ]] ; then
einfo "UAF = Use After Free"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "ZC" ]] ; then
einfo "ZC = Zero Click Attack"
		fi
einfo
	fi
}
fi
