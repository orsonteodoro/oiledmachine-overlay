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

	# Alternative for beginners or exact personalities but may be used in video or audio only podcasting reports
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"C"($|" "|";"|",") ]] ; then
# Same as ID
einfo "C = Confidentiality Impacted"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"I"($|" "|";"|",") ]] ; then
# Same as DT
einfo "I = Integrity Impacted"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"A"($|" "|";"|",") ]] ; then
# Same as DoS
einfo "A = Availability Impacted"
		fi

# Same as CIA but preferred in professional written reports
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"ID"($|" "|";"|",") ]] ; then
# Same as C
einfo "ID = Information Disclosure"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"DT"($|" "|";"|",") ]] ; then
# Same as I
einfo "DT = Data Tampering"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")("DoS"|"DOS")($|" "|";"|",") ]] ; then
# Same as A
einfo "DoS = Denial of Service"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"ABO"($|" "|";"|",") ]] ; then
# Adjacent buffer integrity compromised
# BO is taken so ABO is used
einfo "ABO = Adjacent Buffer Overrun"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"AE"($|" "|";"|",") ]] ; then
# Alias for ITW.
# Not necessarily KEV.
einfo "AE = Actively Exploited" # More formal
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"AEITW"($|" "|";"|",") ]] ; then
# Alias for ITW.
# Not necessarily KEV.
einfo "AEITW = Actively Exploited In The Wild" # More formal
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"ITW"($|" "|";"|",") ]] ; then
# Alias for AEITW.
# Not necessarily KEV.
einfo "ITW = In The Wild" # More informal but more commonly used
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"KEV"($|" "|";"|",") ]] ; then
# Government recognition of AEITW
einfo "KEV = Known Exploited Vulnerabilities (U.S. Government Advisory)"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"AR"($|" "|";"|",") ]] ; then
einfo "AR = Arbitrary Read"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"AW"($|" "|";"|",") ]] ; then
einfo "AW = Arbitrary Write"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"BO"($|" "|";"|",") ]] ; then
# Stack size insufficient
einfo "BO = Buffer Overflow"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"ACE"($|" "|";"|",") ]] ; then
einfo "ACE = Arbitrary Code Execution"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"CE"($|" "|";"|",") ]] ; then
# Alias for ACE, RCE
einfo "CE = Code Execution"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"RCE"($|" "|";"|",") ]] ; then
# Alias for ACE
einfo "RCE = Remote Code Execution"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"CJ"($|" "|";"|",") ]] ; then
einfo "CJ = Clickjack"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"CRSH"($|" "|";"|",") ]] ; then
einfo "CRSH = Crash"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"CSRF"($|" "|";"|",") ]] ; then
einfo "CSRF = Cross Site Request Forgery"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")("DbZ"|"DBZ")($|" "|";"|",") ]] ; then
einfo "DbZ = Divide by Zero"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"DF"($|" "|";"|",") ]] ; then
einfo "DF = Double Free"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"DL"($|" "|";"|",") ]] ; then
einfo "DL = Deadlock"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"H"($|" "|";"|",") ]] ; then
einfo "H = Hang"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"HL"($|" "|";"|",") ]] ; then
einfo "HL = Hard Lockup"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"SL"($|" "|";"|",") ]] ; then
einfo "SL = Soft Lockup"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"DR"($|" "|";"|",") ]] ; then
# DT
einfo "DR = Data Race"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")("EM"|"EMA")($|" "|";"|",") ]] ; then
# CVSS 3.1 - AV:P/PR:N/UI:N/C:H
einfo "EMA = Evil Maid Attack"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"HF"($|" "|";"|",") ]] ; then
einfo "HF = Hardware Fault"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"HWF"($|" "|";"|",") ]] ; then
einfo "HWF = Hardware Fault"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"GPF"($|" "|";"|",") ]] ; then
einfo "GPF = General Protection Fault"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")("DI")($|" "|";"|",") ]] ; then
einfo "DI = Designed Insecurely"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")("IbD"|"IBD")($|" "|";"|",") ]] ; then
einfo "IbD = Insecure by Design"
		fi


		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"IF"($|" "|";"|",") ]] ; then
einfo "IF = Improper Free"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"IFM"($|" "|";"|",") ]] ; then
einfo "IFM = Improper Freed Memory"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"IFR"($|" "|";"|",") ]] ; then
einfo "IFR = Improper Freed Resources"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")("IMPRREL")($|" "|";"|",") ]] ; then
einfo "IMPRREL = Improper Release"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")("IRMEM")($|" "|";"|",") ]] ; then
einfo "IRMEM = Improper Release of Memory"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")("IRoM"|"IROM")($|" "|";"|",") ]] ; then
einfo "IRoM = Improper Release of Memory"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")("IRMEM")($|" "|";"|",") ]] ; then
einfo "IRRES = Improper Release of Resources"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")("IRoR"|"IROR")($|" "|";"|",") ]] ; then
einfo "IRoR = Improper Release of Resources"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"ICP"($|" "|";"|",") ]] ; then
einfo "ICP = Insecure Coding Practices"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"II"($|" "|";"|",") ]] ; then
einfo "II = Improper Implementation"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"III"($|" "|";"|",") ]] ; then
einfo "III = Improper and Insecure Implementation"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"NSS"($|" "|";"|",") ]] ; then
einfo "NSS = Not Sufficiently Secure"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"WS"($|" "|";"|",") ]] ; then
einfo "WS = Weak Security Design or Implementation"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"MBV"($|" "|";"|",") ]] ; then
# Same as CWE-119
einfo "MBV = Memory Bounds Violation (Off-by-One/Off-by-Any Read/Write, Heap/Stack Overread/Overwrite/Underread/Overwrite)"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"IL"($|" "|";"|",") ]] ; then
einfo "IL = Infinite Loop"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"IP"($|" "|";"|",") ]] ; then
einfo "IP = Improper Permissions"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"IO"($|" "|";"|",") ]] ; then
einfo "IO = Integer Overflow"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"IOOB"($|" "|";"|",") ]] ; then
einfo "IOOB = Index Out Of Bounds"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"IIS"($|" "|";"|",") ]] ; then
einfo "IIS = Insufficient Input Sanitiation"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"IS"($|" "|";"|",") ]] ; then
einfo "IS = Insufficient Sanitiation"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")("ISoI"|"ISOI")($|" "|";"|",") ]] ; then
einfo "ISoI = Insufficient Sanitiation of Input"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")("IE")($|" "|";"|",") ]] ; then
einfo "IE = Insufficient Entropy"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"IU"($|" "|";"|",") ]] ; then
einfo "IU = Integer Underflow"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"IV"($|" "|";"|",") ]] ; then
einfo "IV = Insufficient Validation of Input or Data"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"HC"($|" "|";"|",") ]] ; then
einfo "HC = Heap Corruption"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"MC"($|" "|";"|",") ]] ; then
einfo "MC = Memory Corruption"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"CP"($|" "|";"|",") ]] ; then
einfo "CP = Corrupt Pointer"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"PC"($|" "|";"|",") ]] ; then
einfo "PC = Pointer Corruption"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"SC"($|" "|";"|",") ]] ; then
einfo "SC = Stack Corruption"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"HO"($|" "|";"|",") ]] ; then
einfo "HO = Heap Based Buffer Overflow"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"IR"($|" "|";"|",") ]] ; then
einfo "IR = Infinite Recursion"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"IRCSN"($|" "|";"|",") ]] ; then
einfo "IRCSN = Infinite Recursion"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"ML"($|" "|";"|",") ]] ; then
einfo "ML = Memory Leak"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"SO"($|" "|";"|",") ]] ; then
einfo "SO = Stack Based Buffer Overflow"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"MT"($|" "|";"|",") ]] ; then
einfo "MT = Missing Terminator Character or Condition"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"NPD"($|" "|";"|",") ]] ; then
einfo "NPD = Null Pointer Dereference"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"OOB"($|" "|";"|",") ]] ; then
einfo "OOB = Out Of Bounds"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"OOBA"($|" "|";"|",") ]] ; then
einfo "OOBA = Out Of Bounds Access"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"OOBR"($|" "|";"|",") ]] ; then
einfo "OOBR = Out Of Bounds Read"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"OOBW"($|" "|";"|",") ]] ; then
einfo "OOBW = Out Of Bounds Write"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"OOR"($|" "|";"|",") ]] ; then
einfo "OOR = Out Of Range Access"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"KP"($|" "|";"|",") ]] ; then
# Equivalent to BSOD
einfo "KP = Kernel Panic"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")("PoO"|"POO")($|" "|";"|",") ]] ; then
einfo "PoO = Panic On Oops"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")("PoW"|"POW")($|" "|";"|",") ]] ; then
einfo "POW = Panic On Warn"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")("PE")($|" "|";"|",") ]] ; then
einfo "PE = Privilege Escalation"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")("EP")($|" "|";"|",") ]] ; then
einfo "EP = Escalated Privileges"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")("EoP")($|" "|";"|",") ]] ; then
einfo "EoP = Escalation of Privileges"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"PI"($|" "|";"|",") ]] ; then
einfo "PI = Prompt Injection"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"PP"($|" "|";"|",") ]] ; then
einfo "PP = Prototype Pollution"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"PT"($|" "|";"|",") ]] ; then
einfo "PT = Path Traversal"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"R"($|" "|";"|",") ]] ; then
# DoS, DT, ID, PE
# Alias for Race Condition
# Less formal that Race Condition
einfo "R = Race"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"RC"($|" "|";"|",") ]] ; then
# DoS, DT, ID, PE
einfo "RC = Race Condition"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")("ReDoS"|"REDOS")($|" "|";"|",") ]] ; then
einfo "ReDoS = Regular Expression Denial of Service"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"SA"($|" "|";"|",") ]] ; then
einfo "SA = Spoofing Attack"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"CI"($|" "|";"|",") ]] ; then
einfo "CI = Command Injection"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"DBCI"($|" "|";"|",") ]] ; then
einfo "DBCI = Database Command Injection"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"SCRPTCI"($|" "|";"|",") ]] ; then
einfo "SCRPTCI = Script Command Injection"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"SHCI"($|" "|";"|",") ]] ; then
einfo "SHCI = Shell Command Injection"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"SQLCMDI"($|" "|";"|",") ]] ; then
einfo "SQLCMDI = SQL Command Injection"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"SQLCDI"($|" "|";"|",") ]] ; then
einfo "SQLCDI = SQL Code Injection"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"SQLI"($|" "|";"|",") ]] ; then
einfo "SQLI = SQL Injection"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"SEA"($|" "|";"|",") ]] ; then
einfo "SEA = Social Engineering Attack"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"SBE"($|" "|";"|",") ]] ; then
einfo "SBE = SandBox Escape"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"SE"($|" "|";"|",") ]] ; then
einfo "SE = Sandbox Escape"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"SBX"($|" "|";"|",") ]] ; then
einfo "SBX = SandBoX Escape"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"IB"($|" "|";"|",") ]] ; then
einfo "IB = Integrity Bypass"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"SB"($|" "|";"|",") ]] ; then
einfo "SB = Security Bypass"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")("SC"|"SCV")($|" "|";"|",") ]] ; then
einfo "SC = Side Channel Vulnerability"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"SHFTOF"($|" "|";"|",") ]] ; then
einfo "SHFTOF = Shift Overflow"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"SHFTU"($|" "|";"|",") ]] ; then
einfo "SHFTU = Shift Underflow"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"SOF"($|" "|";"|",") ]] ; then
einfo "SOF = Shift Overflow"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"SUF"($|" "|";"|",") ]] ; then
einfo "SUF = Shift Underflow"
		fi

		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"SOOB"($|" "|";"|",") ]] ; then
einfo "SOOB = Shift Out Of Bounds"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"SOPB"($|" "|";"|",") ]] ; then
einfo "SOPB = Same-Origin Policy Bypass"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"TC"($|" "|";"|",") ]] ; then
einfo "TC = Type Confusion"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")("ToCToU"|"TOCTOU")($|" "|";"|",") ]] ; then
einfo "ToCToU = Time of Check Time of Use"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"TSE"($|" "|";"|",") ]] ; then
einfo "TSE = Transient Speculative Execution"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"TSG"($|" "|";"|",") ]] ; then
einfo "TSG = Transient Speculative Execution Gadget"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"UB"($|" "|";"|",") ]] ; then
einfo "UB = Undefined Behavior"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"UI"($|" "|";"|",") ]] ; then
einfo "UI = UI Spoofing"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"UM"($|" "|";"|",") ]] ; then
einfo "UM = Uninitialized Memory"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"UP"($|" "|";"|",") ]] ; then
einfo "UP = Uninitialized Pointer"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"US"($|" "|";"|",") ]] ; then
einfo "US = Unterminated String"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"UV"($|" "|";"|",") ]] ; then
einfo "UV = Uninitialized Value"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"UAF"($|" "|";"|",") ]] ; then
einfo "UAF = Use After Free"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"UAR"($|" "|";"|",") ]] ; then
einfo "UAR = Use After Return"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"WC"($|" "|";"|",") ]] ; then
einfo "WC = Weak Cipher"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"WWWC"($|" "|";"|",") ]] ; then
einfo "WWWC = Write What Where Condition"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"XSS"($|" "|";"|",") ]] ; then
einfo "XSS = Cross Site Scripting Attack"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")"XSRF"($|" "|";"|",") ]] ; then
einfo "XSRF = Cross Site Request Forgery"
		fi

# CVSS 3.1 - AV:N/PR:N/UI:N
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")("ZC")($|" "|";"|",") ]] ; then
einfo "ZC = Zero Click"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")("ZCA")($|" "|";"|",") ]] ; then
einfo "ZCA = Zero Click Attack"
		fi
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ (^|" "|";"|",")("ZCV")($|" "|";"|",") ]] ; then
einfo "ZCV = Zero Click Vulnerability"
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
