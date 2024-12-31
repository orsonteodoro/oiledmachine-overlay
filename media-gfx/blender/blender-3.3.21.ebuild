# Copyright 2022-2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EOL_DATE="Sep 2024"
RELEASE_TYPE="lts"
VARIANT="stable"

KEYWORDS=" " # Removed KEYWORDS, EOL

inherit blender-v3.3

# For current version, see
# https://download.blender.org/source/
# https://builder.blender.org/download/daily/

# See eclass below for implementation:
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/blender.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/blender-multibuild.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/blender-v3.3.eclass

# For version bumps see,
# https://download.blender.org/release/Blender3.3/

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  turned-into-split-eclasses
