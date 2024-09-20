# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit mitigate-dos toolchain-funcs

# Add RDEPEND+=" sys-kernel/mitigate-dos" to downstream package if the downstream ebuild uses:
# Server
# Web Browser (For test taking, emergency service, voting)
# Network Software

S="${WORKDIR}"

DESCRIPTION="Enforce Denial of Service mitigations"
SLOT="0"
KEYWORDS="~amd64 ~x86"
VIDEO_CARDS=(
	video_cards_amdgpu
	video_cards_intel
	video_cards_nouveau
	video_cards_nvidia
	video_cards_radeon
	video_cards_vmware
)
IUSE="
${VIDEO_CARDS[@]}
mlx5
"
# CE - Code Execution
# CI - Compromisable Integrity
# DoS - Denial of Service
# EP - Escalation of Privileges
# ID - Information Disclosure

#
# The latest to near past vulnerabilities are reported below.
#
# mlx5? https://nvd.nist.gov/vuln/detail/CVE-2024-45019 # DoS
# video_cards_amdgpu? https://nvd.nist.gov/vuln/detail/CVE-2024-43903 # DoS
# video_cards_intel? https://nvd.nist.gov/vuln/detail/CVE-2023-52913 # DoS
# video_cards_intel? https://nvd.nist.gov/vuln/detail/CVE-2024-41092 # DoS, ID
# video_cards_nouveau? https://nvd.nist.gov/vuln/detail/CVE-2024-45012 # DoS; requires >= 6.11 for fix
# video_cards_nouveau? https://nvd.nist.gov/vuln/detail/CVE-2024-42101 # DoS; requires >= 6.10 for fix
# video_cards_nvidia? https://nvidia.custhelp.com/app/answers/detail/a_id/5551 # DoS, ID, CI, CE, EP
# video_cards_radeon? https://nvd.nist.gov/vuln/detail/CVE-2024-41060 # DoS
# video_cards_vmware? https://nvd.nist.gov/vuln/detail/CVE-2024-46709 # DoS
#
# Usually stable versions get security checked.
# The betas and dev versions usually do not get security reports.
#
RDEPEND="
	${MITIGATE_DOS_RDEPEND}
	mlx5? (
		$(gen_patched_kernel_list 6.11)
	)
	video_cards_amdgpu? (
		$(gen_patched_kernel_list 6.11)
	)
	video_cards_intel? (
		$(gen_patched_kernel_list 6.2)
	)
	video_cards_nouveau? (
		$(gen_patched_kernel_list 6.11)
	)
	video_cards_nvidia? (
		|| (
			>=x11-drivers/nvidia-drivers-550.90.07:0/550
			>=x11-drivers/nvidia-drivers-535.183.01:0/535
			>=x11-drivers/nvidia-drivers-470.256.02:0/470
		)
	)
	video_cards_radeon? (
		$(gen_patched_kernel_list 6.10)
	)
	video_cards_vmware? (
		$(gen_patched_kernel_list 6.11)
	)
"
BDEPEND="
	sys-apps/util-linux
"

pkg_setup() {
	mitigate-dos_pkg_setup
ewarn "This ebuild is a Work In Progress (WIP)."
}

# Unconditionally check
src_compile() {
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
