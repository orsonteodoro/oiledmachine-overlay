# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This is a meta package

PYTHON_COMPAT=( python3_{10,11} ) # Can support 3.12 but limited by Nuitka

inherit python-r1 xdg

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
IUSE+=" gtk3 html hwmon openrc qt6 systemd wayland X r1"
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
		html
		qt6
	)
"
RDEPEND+="
	~sys-apps/coolercontrol-liqctld-${PV}[${PYTHON_USEDEP},openrc?,systemd?]
	~sys-apps/coolercontrold-${PV}[hwmon?,openrc?,systemd?]
	gtk3? (
		~sys-apps/coolercontrol-ui-${PV}[wayland?,X?]
	)
	qt6? (
		~sys-apps/coolercontrol-gui-${PV}[${PYTHON_USEDEP},hwmon?,wayland?,X?]
	)
"
DEPEND+="
	${RDEPEND}
"

src_configure() {
	default
}

src_configure() { :; }

src_compile() { :; }

gen_html_wrapper() {
	local www_browser="xdg-open"
	if [[ -n "${COOLERCONTROL_BROWSER}" ]] ; then
		www_browser="${COOLERCONTROL_BROWSER}"
	fi
	dodir /usr/bin
cat <<EOF > "${ED}/usr/bin/coolercontrol-html"
#!/bin/bash
${www_browser} "http://localhost:11987"
EOF
	fperms 0755 /usr/bin/coolercontrol-html
}

src_install() {
	insinto "/usr/share/icons/hicolor/scalable/apps"
	doins "packaging/metadata/org.coolercontrol.CoolerControl.svg"

	insinto "/usr/share/icons/hicolor/256x256/apps"
	doins "packaging/metadata/org.coolercontrol.CoolerControl.png"

	insinto "/usr/share/metainfo"
	doins "packaging/metadata/org.coolercontrol.CoolerControl.metainfo.xml"

	if use html ; then
		gen_html_wrapper
		make_desktop_entry \
			"/usr/bin/coolercontrol-html" \
			"CoolerControl (html)" \
			"org.coolercontrol.CoolerControl" \
			"Utility;"
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	if use html ; then
		ln -sf \
			"${EROOT}/usr/bin/coolercontrol-html5" \
			"${EROOT}/usr/bin/coolercontrol" \
			|| die
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
