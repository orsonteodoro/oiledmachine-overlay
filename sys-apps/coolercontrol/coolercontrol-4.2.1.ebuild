# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This is a meta package
# D12, U22

PYTHON_COMPAT=( "python3_"{10,11} )

inherit desktop xdg python-single-r1

S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://gitlab.com/coolercontrol/coolercontrol/-/archive/${PV}/coolercontrol-${PV}.tar.bz2
"

DESCRIPTION="Cooling device control for Linux"
HOMEPAGE="
https://gitlab.com/coolercontrol/coolercontrol
"
LICENSE="
	GPL-3+
"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
hwmon man openrc pwa qt6 systemd wayland X
ebuild_revision_1
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	qt6? (
		|| (
			wayland
			X
		)
	)
	|| (
		pwa
		qt6
	)
"
RDEPEND+="
	~sys-apps/coolercontrold-${PV}[${PYTHON_SINGLE_USEDEP},hwmon?,openrc?,systemd?]
	qt6? (
		~sys-apps/coolercontrol-qt6-${PV}[wayland?,X?]
	)
"
DEPEND+="
	${RDEPEND}
"

src_configure() {
	default
}

src_configure() {
	:
}

src_compile() {
	:
}

gen_pwa_wrapper() {
	local www_browser="xdg-open"
	if [[ -n "${COOLERCONTROL_BROWSER}" ]] ; then
		www_browser="${COOLERCONTROL_BROWSER}"
	fi
	dodir /usr/bin
cat <<EOF > "${ED}/usr/bin/coolercontrol-pwa"
#!/bin/bash
${www_browser} "http://localhost:11987"
EOF
	fperms 0755 "/usr/bin/coolercontrol-pwa"
}

src_install() {
	insinto "/usr/share/icons/hicolor/scalable/apps"
	doins "packaging/metadata/org.coolercontrol.CoolerControl.svg"

	insinto "/usr/share/icons/hicolor/256x256/apps"
	doins "packaging/metadata/org.coolercontrol.CoolerControl.png"

	insinto "/usr/share/metainfo"
	doins "packaging/metadata/org.coolercontrol.CoolerControl.metainfo.xml"

	if use pwa ; then
		gen_pwa_wrapper
		make_desktop_entry \
			"/usr/bin/coolercontrol-pwa" \
			"CoolerControl (pwa)" \
			"org.coolercontrol.CoolerControl" \
			"Utility;"
	fi

	if use man ; then
		doman "packaging/man/coolercontrol.1"
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	if use pwa ; then
		ln -sf \
			"${EROOT}/usr/bin/coolercontrol-pwa" \
			"${EROOT}/usr/bin/coolercontrol" \
			|| die
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
