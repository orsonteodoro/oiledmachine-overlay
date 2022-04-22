# Copyright 2019-2022 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

K_GENPATCHES_VER="194"
PATCH_BMQ_VER="5.4-r2"
BMQ_FN="bmq_v${PATCH_BMQ_VER}.patch"
PATCH_RT_VER="5.4.188-rt73"

inherit ot-kernel-v5.4

# See also,
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel-v5.4.eclass
