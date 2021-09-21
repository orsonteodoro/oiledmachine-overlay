# Copyright 2021 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

# See https://www.electronjs.org/releases/stable?version=12

EAPI=7
DESCRIPTION="Electron updates for ebuild-packages with electron-builder \
or electron-packager"
KEYWORDS="~amd64 ~arm ~amd64 ~x86"
SLOT="$(ver_cut 1 ${PV})/${PV}"
