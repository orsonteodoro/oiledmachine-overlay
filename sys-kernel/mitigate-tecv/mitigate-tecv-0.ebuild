# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit mitigate-tecv

# Add this if the ebuild uses:
# JavaScript
# WebAssembly
# Keychains
# Passwords
# Bitcoin Wallets
# Sensitive data

# It is used to mitigate against cross process exfiltration.

DESCRIPTION="Enforce Transient Execution CPU Vulnerability mitigations"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~s390 ~x86"
RDEPEND="
	${MITIGATE_TECV_RDEPEND}
"

pkg_setup() {
	mitigate-tecv_pkg_setup
}
