# Copyright 2019-2020 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

FETCH_VANILLA_SOURCES_BY_BRANCH=1
K_LIVE_PATCHABLE=1
K_GENPATCHES_VER="13"
PATCH_BMQ_VER="5.7-r3"
BMQ_FN="bmq_v${PATCH_BMQ_VER}.patch"
PATCH_PROJC_VER="5.8-r3"
SLOT=${PV}

inherit ot-kernel-v5.8

pkg_setup() {
	ewarn "ebuild for testing purposes only.  do not use at this time."
	ot-kernel_pkg_setup
}
