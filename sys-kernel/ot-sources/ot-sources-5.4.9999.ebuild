# Copyright 2019-2021 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

FETCH_VANILLA_SOURCES_BY_BRANCH=1
K_LIVE_PATCHABLE=1
# Keep in sync with https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/refs/tags
TEST_REWIND_SOURCES_BACK_TO="7b26f72026cc66544b8a5fffb6fb8e8dc30ea3dc" # 5.4.142
K_GENPATCHES_VER="145"
PATCH_BMQ_VER="5.4-r2"
BMQ_FN="bmq_v${PATCH_BMQ_VER}.patch"
PATCH_RT_VER="5.4.138-rt62"

inherit ot-kernel-v5.4

pkg_setup() {
	ewarn "ebuild for testing purposes only.  do not use at this time."
	ot-kernel_pkg_setup
}
