# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib multilib-minimal

KEYWORDS="~amd64"
SRC_URI="http://prdownloads.sourceforge.net/log4c/log4c-1.2.4.tar.gz"

DESCRIPTION="Logging FrameWork for C, as Log4j or Log4Cpp"
HOMEPAGE="
	https://log4c.sourceforge.net/
	https://sourceforge.net/projects/log4c/
"
LICENSE="LGPL-2.1"
SLOT="0/$(ver_cut 1-2 ${PV})"
PATCHES=(
	"${FILESDIR}/log4c-1.2.4-log4c-config-multilib.patch"
)

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_install() {
	default
	dodir "/usr/$(get_libdir)/${PN}"
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multilib
