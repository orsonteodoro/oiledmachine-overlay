# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Logging FrameWork for C, as Log4j or Log4Cpp"
HOMEPAGE="http://log4c.sourceforge.net/"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
SRC_URI="http://prdownloads.sourceforge.net/log4c/log4c-1.2.4.tar.gz"
inherit multilib-minimal

src_prepare() {
	default
	multilib_copy_sources
}
