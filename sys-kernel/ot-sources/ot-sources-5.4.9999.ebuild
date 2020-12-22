# Copyright 2019-2020 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

FETCH_VANILLA_SOURCES_BY_BRANCH=1
K_LIVE_PATCHABLE=1
TEST_REWIND_SOURCES_BACK_TO="77fcb48939fc863d9ba9d808fac9000959e937d3" # 5.4.60
K_GENPATCHES_VER="87"
PATCH_BMQ_VER="5.4-r2"
BMQ_FN="bmq_v${PATCH_BMQ_VER}.patch"

inherit ot-kernel-v5.4

pkg_setup() {
	ewarn "ebuild for testing purposes only.  do not use at this time."
	ot-kernel_pkg_setup
}
