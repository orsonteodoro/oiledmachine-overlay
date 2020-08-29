# Copyright 2019-2020 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

K_GENPATCHES_VER="19"
PATCH_BMQ_VER="5.7-r1"
BMQ_FN="bmq_v${PATCH_BMQ_VER}.patch"
PATCH_PROJC_VER="5.7-r3"

# Not supported by the Gentoo crew
K_SECURITY_UNSUPPORTED="1"

inherit ot-kernel-v5.7

KEYWORDS="~amd64 ~x86"

pkg_setup() {
	ewarn "The 5.7 series will be removed in the next update cycle."
        kernel-2_pkg_setup
	ot-kernel-common_pkg_setup
}

pkg_pretend() {
	ot-kernel-common_pkg_pretend
}

src_unpack() {
	ot-kernel-common_src_unpack
}

src_compile() {
	ot-kernel-common_src_compile
}

src_install() {
	ot-kernel-common_src_install
	kernel-2_src_install
}

pkg_postinst() {
	kernel-2_pkg_postinst
	ot-kernel-common_pkg_postinst
}
