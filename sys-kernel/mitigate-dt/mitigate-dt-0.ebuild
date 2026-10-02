# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Security:  update every kernel version bump
# This ebuild uses AI inference to better inform the FAFO user of the risks of bypassing mitigation.

inherit secure-version

inherit chkl mitigate-dt toolchain-funcs

# Add RDEPEND+=" sys-kernel/mitigate-dt" to downstream package if the downstream ebuild uses:
# Server (financial, banking, legal, voting)
# Web Browser (For voting, financial, banking, legal, voting)
# Network Software
# Realtime manufacturing

S="${WORKDIR}"

DESCRIPTION="Enforce data tampering kernel config mitigations"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE+="
ebuild_revision_63
"
# CE - Code Execution
# DoS - Denial of Service (CVSS A:H)
# DT - Data Tampering (CVSS I:H)
# ID - Information Disclosure (CVSS C:H)
# PE - Privilege Escalation

#
# In the kernel changelog, you can do a common keywords search of the following
# to look up the formulaic results:
#
# Arbitrary code execution, CVSS 9.8 # DoS, DT, ID
# Buffer overflow, CVSS 6.7 # DoS, DT, ID
# Crash, CVSS 5.5 # DoS
# Data corruption, CVSS 7.1 # DT, DoS
# Data race, CVSS 7.0 # DoS, DT, ID
# Deadlock, CVSS 5.5 # DoS
# Double free, CVSS 7.8 # DoS, DT, ID
# Local privilege escalation, CVSS 7.8 # DoS, DT, ID
# Memory leak, CVSS 5.5 # DoS
# NULL pointer dereference, CVSS 5.5 # DoS
# Out of bounds read, CVSS 7.1, # DoS, ID
# Out of bounds write, CVSS 7.8, # DoS, ID, DT
# Race condition, CVSS 4.7 # DoS
# ToCToU race, CVSS 7.0 # PE, DoS, DT, ID
# Use after free, use-after-free, UAF, CVSS 7.8 # DoS, DT, ID
# VM guest makes host slow and responsive, CVSS 6.0 # DoS
#

# Ebuild policy for automatic classification for rows marked *unofficial*:
#
# Sensitive data read || incomplete sanitization of sensitive data : ID
# Possible privilege escalation || data corruption || altered permissions : DT
# Possible crash || kernel panic || (!ID && !DT) : DoS

#
# Usually stable versions get security checked.
# The betas and dev versions usually do not get security reports.
#

BDEPEND="
"

_check_y() {
	local kconfig_setting="${1}"
	CONFIG_CHECK+="
		${kconfig_setting}
	"
}

_check_n() {
	local kconfig_setting="${1}"
	CONFIG_CHECK+="
		!${kconfig_setting}
	"
}

verify_disable_ksm_for_one_kernel() {
	CONFIG_CHECK="
		!KSM
		!UKSM
	"
	ERROR_KSM="CONFIG_KSM=n is required to mitigate from ASLR circumvention, information disclosure, Rowhammer (elevated privileges, data tampering)"
	ERROR_UKSM="CONFIG_UKSM=n is required to mitigate against denial of service" # Thrashy
	check_extra_config
}

verify_disable_ksm() {
	local prev_kernel_dir="${KERNEL_DIR}"
	local L=(
		$(grep -l "EXTRAVERSION" $(ls "/usr/src/"*"/Makefile"))
	)
	local x
	for x in ${L[@]} ; do
		unset KV_FULL
		local pv_major=$(grep "VERSION =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
		local pv_minor=$(grep "PATCHLEVEL =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
		local pv_patch=$(grep "SUBLEVEL =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
		local pv_extraversion=$(grep "EXTRAVERSION =" "${x}" | head -n 1 | cut -f 2 -d "=" | sed -E -e "s|[ ]+||g")
einfo
einfo "Verifying CONFIG_KSM=n settings for ${pv_major}.${pv_minor}.${pv_patch}${pv_extraversion}"
		KERNEL_DIR=$(dirname "${x}")
		verify_disable_ksm_for_one_kernel
	done
	KERNEL_DIR="${prev_kernel_dir}"
}

pkg_setup() {
	use enforce || return
	mitigate-dt_pkg_setup
ewarn "This ebuild is a Work In Progress (WIP)."
	verify_disable_ksm
}

src_configure() {
	use enforce || ewarn "The USE enforce flag is disabled."
	chkl_check_many_timestamps
}

src_compile() {
	use enforce || ewarn "The USE enforce flag is disabled."
	use enforce || return
	tc-is-cross-compiler && return
# TODO:  Find similar app
#einfo "Checking for mitigations against DoS."
#	if lscpu | grep -q "Vulnerable" ; then
#eerror "FAIL:  Detected an unmitigated CPU vulnerability."
#eerror "Fix issues to continue."
#		lscpu
#		die
#	else
#einfo "PASS"
#	fi
}
