# Copyright 2019-2022 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

K_GENPATCHES_VER="16"
PATCH_PROJC_VER="5.15-r1" # For updates see https://gitlab.com/alfredchen/projectc/-/tree/master
PATCH_RT_VER="5.16.2-rt19"

inherit ot-kernel-v5.16

# See also,
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel-v5.16.eclass
