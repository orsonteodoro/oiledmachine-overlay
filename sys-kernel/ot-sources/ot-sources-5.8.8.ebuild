# Copyright 2019-2020 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

K_GENPATCHES_VER="9"
PATCH_BMQ_VER="5.7-r3"
BMQ_FN="bmq_v${PATCH_BMQ_VER}.patch"
PATCH_PROJC_VER="5.8-r2"

inherit ot-kernel-v5.8

pkg_setup() {
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
}

pkg_postinst() {
	ot-kernel-common_pkg_postinst
}
