# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This is a meta package

PYTHON_COMPAT=( python3_{10,11} ) # Can support 3.12 but limited by Nuitka

inherit python-r1

SRC_URI="
https://gitlab.com/coolercontrol/coolercontrol/-/archive/${PV}/coolercontrol-${PV}.tar.bz2
"
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="Cooling device control for Linux"
HOMEPAGE="
https://gitlab.com/coolercontrol/coolercontrol
"
LICENSE="
	GPL-3+
"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" gtk3 qt6 wayland X"
REQUIRED_USE="
	gtk3? (
		|| (
			wayland
			X
		)
	)
	qt6? (
		|| (
			wayland
			X
		)
	)
	|| (
		gtk3
		qt6
	)
"
RDEPEND+="
	~sys-apps/coolercontrol-liqctld-${PV}[${PYTHON_USEDEP}]
	~sys-apps/coolercontrold-${PV}
	gtk3? (
		~sys-apps/coolercontrol-ui-${PV}[wayland?,X?]
	)
	qt6? (
		~sys-apps/coolercontrol-gui-${PV}[${PYTHON_USEDEP},wayland?,X?]
	)
"
DEPEND+="
	${RDEPEND}
"

src_install() {
	insinto "/usr/share/icons/hicolor/scalable/apps"
	doins "metadata/org.coolercontrol.CoolerControl.svg"

	insinto "/usr/share/icons/hicolor/256x256/apps"
	doins "metadata/org.coolercontrol.CoolerControl.png"

	insinto "/usr/share/applications"
	doins "metadata/org.coolercontrol.CoolerControl.desktop"

	insinto "/usr/share/metainfo"
	doins "metadata/org.coolercontrol.CoolerControl.metainfo.xml"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
