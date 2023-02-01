# Copyright 2019-2022 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI=8

K_GENPATCHES_VER="11"
PATCH_PROJC_VER="6.1-r4"
PATCH_RT_VER="6.1-rc7-rt5"

inherit ot-kernel-v6.1

# See also,
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel-v6.1.eclass

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  modularize-ebuild-as-milestone-eclasses
# OILEDMACHINE-OVERLAY-META-TAGS:  see-eclass-for-full-details
# OILEDMACHINE-OVERLAY-META-WIP:  tresor, signed-kexec-kernel, signed-kernels
