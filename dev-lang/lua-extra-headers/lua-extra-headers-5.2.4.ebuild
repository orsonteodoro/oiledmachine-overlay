# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Installs extra headers required by Lua applications"
HOMEPAGE="https://www.lua.org/"
SRC_URI="https://www.lua.org/ftp/lua-${PV}.tar.gz"
SLOT="5.2"
IUSE+=" +civetweb"
RDEPEND=" ~dev-lang/lua-${PV}"
REQUIRED_USE+=" civetweb"
RESTRICT="mirror"
S="${WORKDIR}/lua-${PV}"

src_install() {
	if use civetweb ; then
		insinto /usr/include/lua${SLOT}
		doins \
			src/llimits.h \
			src/lmem.h \
			src/lobject.h \
			src/lstate.h \
			src/ltm.h \
			src/lzio.h
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
