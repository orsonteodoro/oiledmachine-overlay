# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
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
# The CVE-xxxx-xxxxx can be replaced with a custom identifier such
# as a 7 digit git hash, GLSA, etc.
#

# @FUNCTION: vf_show
# @DESCRIPTION:
# Shows the vulnerabilities fixed for this release cycle.
vf_show() {
	if [[ -n "${MITIGATION_URI}" ]] ; then
einfo "Patched vulnerabilities:"
		SEVERITY_LABEL=${SEVERITY_LABEL:-"CVSS 3.1"} # Can be CVSS 4.0 or a custom severity label
		IFS=$'\n'
		local x
		for x in ${VULNERABILITIES_FIXED[@]} ; do
			local id=$(echo "${x}" | cut -f 1 -d ";")
			local vulnerability_classes=$(echo "${x}" | cut -f 2 -d ";")
			local severity=$(echo "${x}" | cut -f 3 -d ";")
			local _severity=""
			if [[ -n "${severity}" ]] ; then
				_severity=" (${SEVERITY_LABEL} ${severity})"
			fi
			if [[ -n "${_severity}" || -n "${vulnerability_classes}" ]] ; then
				_delimiter=":"
			fi
			if [[ "${_severity}" =~ [Rr]"ejected" ]] ; then
echo -e " \033[0;32m*\033[0m \e[9m${id}\e[0m"
			else
einfo "${id}${_delimiter}  ${vulnerability_classes}${_severity}"
			fi
		done
		IFS=$' \t\n'
	#
	# Glossary
	#
	# Most rows just need DoS, DT, ID.
	#
	# The remaining are to be used as a fallback or temporary
	# placeholder when it is not clear that it is a DoS, DT, ID as
	# the CVSS is still being evaluated.
	#
	# The complex cases that are undecided, or that fit more than one
	# vulnerability class, or unable to be classified should deserve
	# a conditional, but trivial vulnerabilities should only use one
	# or more DoS, DT, ID impact vectors.
	#
einfo
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "BO" ]] ; then
einfo "BO = Buffer Overflow"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ ("ACE"|"CE") ]] ; then
# Arbitrary Code Execution
einfo "CE = Code Execution"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "CI" ]] ; then
einfo "CI = Shell Command Injection"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "CSRF" ]] ; then
einfo "CSRF = Cross Site Request Forgery"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "DoS" ]] ; then
einfo "DoS = Denial of Service"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "DF" ]] ; then
einfo "DF = Double Free"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "DR" ]] ; then
# DT
einfo "DR = Data Race"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "DT" ]] ; then
einfo "DT = Data Tampering"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ ("EM"|"EMA") ]] ; then
# CVSS 3.1 - AV:P/PR:N/UI:N/C:H
einfo "EMA = Evil Maid Attack"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "HO" ]] ; then
einfo "HO = Heap Based Buffer Overflow"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "ID" ]] ; then
einfo "ID = Information Disclosure"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ ("IF"|"IR") ]] ; then
# Improper Release
einfo "IF = Improper Free"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "IP" ]] ; then
einfo "IP = Improper Permissions"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "IO" ]] ; then
einfo "IO = Integer Overflow"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "IS" ]] ; then
einfo "IS = Insufficient Sanitiation of Input"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "IV" ]] ; then
einfo "IV = Insufficient Validation of Input or Data"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "KEV" ]] ; then
einfo "KEV = Known Exploited Vulnerabilities (actively exploited in the wild)"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "MC" ]] ; then
einfo "MC = Memory Corruption"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ ("MT"|"US") ]] ; then
# Unterminated String
einfo "MT = Missing Terminator Character"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "NPD" ]] ; then
einfo "NPD = Null Pointer Dereference"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^| )"OOB"( |$) ]] ; then
einfo "OOB = Out Of Bounds"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "OOBA" ]] ; then
einfo "OOBA = Out Of Bounds Access"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "OOBR" ]] ; then
einfo "OOBR = Out Of Bounds Read"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "OOBW" ]] ; then
einfo "OOBW = Out Of Bounds Write"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "OOR" ]] ; then
einfo "OOR = Out Of Range Access"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ ("PE"|"EP"|"EoP") ]] ; then
# Escalated Privileges
# Escalation of Privileges
einfo "PE = Privilege Escalation"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "PI" ]] ; then
einfo "PI = Prompt Injection"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "PP" ]] ; then
einfo "PP = Prototype Pollution"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "RC" ]] ; then
# DoS, DT, ID, PE
einfo "RC = Race Condition"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "SA" ]] ; then
einfo "SA = Spoofing Attack Vulnerability"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "SO" ]] ; then
einfo "SO = Stack Based Buffer Overflow"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "SBX" ]] ; then
einfo "SBX = Sandbox Escape"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "SE" ]] ; then
einfo "SE = Social Engineering Attack"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "TC" ]] ; then
einfo "TC = Type Confusion"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "ToCToU" ]] ; then
einfo "ToCToU = Time of Check Time of Use"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "TSE" ]] ; then
einfo "TSE = Transient Speculative Execution"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "TSG" ]] ; then
einfo "TSG = Transient Speculative Execution Gadget"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "UB" ]] ; then
einfo "UB = Undefined Behavior"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "UI" ]] ; then
einfo "UI = UI Spoofing"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "UM" ]] ; then
einfo "UM = Uninitialized Memory"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "UP" ]] ; then
einfo "UP = Uninitialized Pointer"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "UV" ]] ; then
einfo "UV = Uninitialized Value"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "UAF" ]] ; then
einfo "UAF = Use After Free"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "UAR" ]] ; then
einfo "UAR = Use After Return"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "XSS" ]] ; then
einfo "XSS = Cross Site Scripting Attack"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "XSRF" ]] ; then
einfo "XSRF = Cross Site Request Forgery"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "ZC" ]] ; then
# CVSS 3.1 - AV:N/PR:N/UI:N
einfo "ZC = Zero Click Attack"
		fi
einfo
einfo "Tip:  Ask the AI/LLM this question to fill in the blanks for the table"
einfo "for possible impact vectors:"
einfo
einfo "Give me the y, n, n/a in a table if <cve-id> causes code execution,"
einfo "elevated privileges, data tampering, denial of service, information"
einfo "disclosure. This one is a <universally recognized bug name (e.g. use"
einfo "after free)>.  Also give me a CVSS 3.1 estimate and severity as a"
einfo "column.  The package in question is <package-name>."
einfo
einfo "Tip:  Ask the AI/LLM this question to fill in the blanks for"
einfo "percentages:"
einfo
einfo "What are the chances or the proportion of a <vulnerability name> to"
einfo "become a denial of service, data tampering, information disclosure,"
einfo "code execution, privilege escalation, or zero click attack?"
einfo
	fi
}
fi
