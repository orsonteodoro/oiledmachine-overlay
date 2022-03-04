# Copyright 2019-2022 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

K_GENPATCHES_VER="110"
BMQ_FN="bmq_v${PATCH_BMQ_VER}.patch"
PATCH_PROJC_VER="5.10-r2"
PATCH_RT_VER="5.10.100-rt62"

inherit ot-kernel-v5.10

# See also,
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel-v5.10.eclass
