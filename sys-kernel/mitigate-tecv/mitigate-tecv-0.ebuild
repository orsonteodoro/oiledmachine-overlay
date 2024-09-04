# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit mitigate-tecv

# Add RDEPEND+=" virtual/mitigate-tecv" to downstream package if the downstream ebuild uses:
# JavaScript
# WebAssembly
# Keychains
# Passwords
# Digital currency wallets
# Databases that that typically store sensitive data

# It is used to mitigate against cross process exfiltration.

DESCRIPTION="Enforce Transient Execution CPU Vulnerability mitigations"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~s390 ~x86"
RDEPEND="
	${MITIGATE_TECV_RDEPEND}
"
BDEPEND="
	sys-apps/util-linux
"

pkg_setup() {
	mitigate-tecv_pkg_setup
}

# Unconditionally check
src_compile() {
	if lscpu | grep -q "Vulnerable" ; then
eerror "Detected unmitigated CPU vulnerability"
		lscpu
		die
	fi
}
