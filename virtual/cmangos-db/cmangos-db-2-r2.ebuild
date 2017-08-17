# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="CMaNGOS Two database for The Wrath of the Lich King (WOTLK) 3.3.5a Client"
SLOT="2"
KEYWORDS="amd64"
RDEPEND="|| ( games-server/psdb:${SLOT} games-server/ytdb-mangos:${SLOT} games-server/udb:${SLOT} games-server/cmangos-db:${SLOT} )"
