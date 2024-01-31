# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit meson

# EOL ; Kept around because of the cursor theme

DESCRIPTION="Paper Icon Theme"
HOMEPAGE="http://snwh.org/paper"
EGIT_COMMIT="aa3e8af7a1f0831a51fd7e638a4acb077a1e5188"
LICENSE="
	CC-BY-SA-4.0
	GPL-3
"
BDEPEND+="
	>=dev-build/meson-0.40
"
SLOT="0"
SRC_URI="
https://github.com/snwh/paper-icon-theme/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}-${EGIT_COMMIT:0:7}.tar.gz
"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
