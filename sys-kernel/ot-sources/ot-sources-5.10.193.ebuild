# Copyright 2019-2023 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BMQ_FN="bmq_v${PATCH_BMQ_VER}.patch" # FIXME
GENPATCHES_VER="203"
PRJC_LTS="-lts"
PATCH_PROJC_VER="5.10-lts-r3"
PATCH_RT_VER="5.10.192-rt92"

inherit ot-kernel-v5.10

# See also,
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel-v5.10.eclass

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  modularize-ebuild-as-milestone-eclasses
# OILEDMACHINE-OVERLAY-META-TAGS:  see-eclass-for-full-details
# OILEDMACHINE-OVERLAY-META-WIP:  signed-kexec, signed-kernels
