# Copyright 2019-2020 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

FETCH_VANILLA_SOURCES_BY_BRANCH=1
K_LIVE_PATCHABLE=1
K_GENPATCHES_VER="205"
SLOT=${PV}

inherit ot-kernel-v4.14

pkg_setup() {
	ot-kernel-common_pkg_setup
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
