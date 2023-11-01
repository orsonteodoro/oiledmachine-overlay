# Copyright 2019-2023 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EBUILD_REV="r1"
GENPATCHES_VER="295"
PATCH_RT_VER="4.19.295-rt129"

inherit ot-kernel-v4.19

# See also,
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel-v4.19.eclass

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  modularize-ebuild-as-milestone-eclasses
# OILEDMACHINE-OVERLAY-META-TAGS:  see-eclass-for-full-details
# OILEDMACHINE-OVERLAY-META-WIP:  signed-kexec-kernel, signed-kernels
