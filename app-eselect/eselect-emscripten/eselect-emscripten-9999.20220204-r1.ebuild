# Copyright 2019-2022 Orson Teodoro
# Copyright 1999-2016 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="Manages the /usr/include/node symlink"
HOMEPAGE="https://github.com/orsonteodoro/oiledmachine-overlay"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x64-macos"
IUSE=""
RESTRICT="fetch"

src_unpack() {
	default
	mkdir -p "${S}" || die
	cp "${FILESDIR}/emscripten-${PVR}.eselect" "${S}/emscripten.eselect" || die
}

src_install() {
	insinto /usr/share/eselect/modules
	doins emscripten.eselect
	insinto /usr/share/${PN}
	doins "${FILESDIR}/hello_world.cpp"
}

pkg_postinst() {
	ewarn "A \`eselect emscripten set <#>\` followed by \`env-update ; source /etc/profile\` in every shell are required in order for fixes to take effect."
}
