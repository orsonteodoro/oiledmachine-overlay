# Copyright 2019-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KEYWORDS="~amd64 ~arm64"
SRC_URI=""

DESCRIPTION="Manages the emscripten environment"
HOMEPAGE="https://github.com/orsonteodoro/oiledmachine-overlay/tree/master/app-eselect/eselect-emscripten"
LICENSE="GPL-2"
RESTRICT="fetch"
SLOT="0"
IUSE="ebuild_revision_3"

src_unpack() {
	default
	mkdir -p "${S}" || die
	cp \
		"${FILESDIR}/emscripten-${PVR}.eselect" \
		"${S}/emscripten.eselect" \
		|| die
}

src_install() {
	insinto "/usr/share/eselect/modules"
	doins "emscripten.eselect"
	insinto "/usr/share/${PN}"
	doins "${FILESDIR}/hello_world.cpp"
}

pkg_postinst() {
ewarn
ewarn "The following must be entered in every shell in order for fixes to take"
ewarn "effect:"
ewarn
ewarn "  eselect emscripten set <#>"
ewarn "  env-update"
ewarn "  source /etc/profile"
ewarn
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
