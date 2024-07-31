# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=17
ROCM_SLOT="${PV%.*}"

inherit rocm

KEYWORDS="~amd64"
S="${WORKDIR}/hipother-rocm-${PV}"
SRC_URI="
https://github.com/ROCm/hipother/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Other HIP backend compatibility"
HOMEPAGE="https://github.com/ROCm/hipother"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
"
# The distro's MIT license template does not contain all rights reserved.
SLOT="${ROCM_SLOT}/${PV}"

pkg_setup() {
	rocm_pkg_setup
}

src_install() {
	insinto "${EROCM_PATH}/include"
	doins -r "hipnv/include/hip"
}
