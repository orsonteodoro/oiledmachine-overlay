# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit mitigate-tecv toolchain-funcs

# Add RDEPEND+=" virtual/mitigate-tecv" to downstream package if the downstream ebuild uses:
# JavaScript
# WebAssembly
# Keychains
# Passwords
# Digital currency wallets
# Databases that that typically store sensitive data

# It is used to mitigate against cross process exfiltration.

S="${WORKDIR}"

DESCRIPTION="Enforce Transient Execution CPU Vulnerability mitigations"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~s390 ~x86"
VIDEO_CARDS=(
	video_cards_nvidia
)
IUSE="
${VIDEO_CARDS[@]}
"
# For Spectre v1, v2 mitigations, see https://nvidia.custhelp.com/app/answers/detail/a_id/4611
# It needs >=x11-drivers/nvidia-drivers-390.31 for V1, V2 mitigation.
# Now, we have these recent past drivers with vulnerabilities of the same class.
# Security notes:
# video_cards_nvidia? https://nvidia.custhelp.com/app/answers/detail/a_id/5551
#
# Usually stable versions get security checked.
# The betas and dev versions usually do not get security reports.
#
RDEPEND="
	${MITIGATE_TECV_RDEPEND}
	video_cards_nvidia? (
		|| (
			>=x11-drivers/nvidia-drivers-550.90.07:0/550
			>=x11-drivers/nvidia-drivers-535.183.01:0/535
			>=x11-drivers/nvidia-drivers-470.256.02:0/470
		)
	)
"
BDEPEND="
	sys-apps/util-linux
"

pkg_setup() {
	mitigate-tecv_pkg_setup
}

# Unconditionally check
src_compile() {
	tc-is-cross-compiler && return
einfo "Checking for mitigations against Transient Execution CPU Vulnerabilities (e.g. Meltdown/Spectre)"
	if lscpu | grep -q "Vulnerable" ; then
eerror "FAIL:  Detected an unmitigated CPU vulnerability."
eerror "Fix issues to continue."
		lscpu
		die
	else
einfo "PASS"
	fi
}
