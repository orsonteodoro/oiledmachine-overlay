# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="https://github.com/pvaret/rtl8192cu-fixes.git"

inherit git-r3 linux-mod

DESCRIPTION="Realtek 8192 chipset driver, ported to kernel 3.11"
HOMEPAGE="https://github.com/pvaret/rtl8192cu-fixes"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

MODULE_NAMES="8192cu(kernel/drivers/net/wireless)"
BUILD_TARGETS="clean modules"

src_install() {
	linux-mod_src_install

	dodoc README.md *.conf
	einfo "Sample configuration files were installed to ${EPREFIX}/usr/share/doc/${PF}."
	einfo "Copy them to /etc/modprobe.d to enable"
	einfo "See README.md installed there for more info"
}

