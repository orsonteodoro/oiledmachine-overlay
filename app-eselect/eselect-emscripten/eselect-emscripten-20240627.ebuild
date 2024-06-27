# Copyright 2019-2023 Orson Teodoro
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Manages the emscripten environment"
HOMEPAGE="https://github.com/orsonteodoro/oiledmachine-overlay/tree/master/app-eselect/eselect-emscripten"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm64 ~x86"
SLOT="0"
SRC_URI=""
RESTRICT="fetch"

src_unpack() {
	default
	mkdir -p "${S}" || die
	cp \
		"${FILESDIR}/emscripten-${PVR}.eselect" \
		"${S}/emscripten.eselect" \
		|| die
}

src_install() {
	insinto /usr/share/eselect/modules
	doins emscripten.eselect
	insinto /usr/share/${PN}
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
