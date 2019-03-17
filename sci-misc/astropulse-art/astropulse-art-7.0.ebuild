# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit versionator

DESCRIPTION="Astropulse artwork"
HOMEPAGE="http://setiathome.ssl.berkeley.edu/"
SRC_URI=""

RESTRICT="fetch"

LICENSE="GPL-2"
SLOT="$(get_version_component_range 1 ${PV})"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"
S="${WORKDIR}"

src_unpack() {
	# self-signed cert
	wget --no-check-certificate "https://setisvn.ssl.berkeley.edu/trac/export/4014/astropulse/client/x.tga" || die
	wget --no-check-certificate "https://setisvn.ssl.berkeley.edu/trac/export/4014/astropulse/client/x.tif" || die
	wget --no-check-certificate "https://setisvn.ssl.berkeley.edu/trac/export/4014/astropulse/client/ap.jpg" || die
}

src_install() {
	cd "${S}"
	mkdir -p "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu || die
	cp ap.jpg "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu || die
	cp x.tga "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu || die
	cp x.tif "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu || die
	chown boinc:boinc "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu/{ap.jpg,x.tga,x.tif}
}
