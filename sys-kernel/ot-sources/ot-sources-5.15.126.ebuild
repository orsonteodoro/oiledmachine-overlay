# Copyright 2019-2023 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GENPATCHES_VER="132"
PATCH_PROJC_VER="5.15-r1"
PATCH_RT_VER="5.15.125-rt66"

inherit ot-kernel-v5.15

# See also,
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel-v5.15.eclass

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  modularize-ebuild-as-milestone-eclasses
# OILEDMACHINE-OVERLAY-META-TAGS:  see-eclass-for-full-details
# OILEDMACHINE-OVERLAY-META-WIP:  tresor, signed-kexec-kernel, signed-kernels
