# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="Taigo"
inherit meson desktop xdg

SRC_URI="
https://github.com/pontaoski/taigo/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"

DESCRIPTION="A virtual pet for your desktop built with GTK+, Vala, and love."
HOMEPAGE="
https://github.com/pontaoski/taigo
"
LICENSE="
	GPL-3
"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" +X wayland"
REQUIRED_USE="
	|| (
		wayland
		X
	)
"
RDEPEND+="
	>=dev-libs/glib-2.50
	>=dev-libs/json-glib-1.0
	>=dev-libs/libgee-0.8
	>=media-libs/clutter-1.0[gtk,X?,wayland?]
	>=x11-libs/gtk+-3.22:3[wayland?,X?]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/meson-0.50.0
	dev-lang/vala:0.56
"

src_prepare() {
	default
	mkdir -p "${WORKDIR}/bin" || die
	export PATH="${WORKDIR}/bin:${PATH}"
	ln -s \
		"/usr/bin/valac-0.56" \
		"${WORKDIR}/bin/valac" \
		|| die
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  passed (0.3, 20231227)
# Notes:  It takes a long time to start up.
