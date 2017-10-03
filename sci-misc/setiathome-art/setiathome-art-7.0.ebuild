# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Astropulse Art"
HOMEPAGE="http://setiathome.ssl.berkeley.edu/"
SRC_URI=""

RESTRICT="fetch"

LICENSE="GPL-2"
SLOT="7"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"
S="${WORKDIR}"

src_install() {
	mkdir -p "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu
	cp ${FILESDIR}/better_banner.jpg "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu
	chown boinc:boinc "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu/better_banner.jpg
}
