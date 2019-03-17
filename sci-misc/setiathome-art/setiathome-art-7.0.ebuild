# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit versionator

DESCRIPTION="Seti@Home artwork"
HOMEPAGE="http://setiathome.ssl.berkeley.edu/"
SRC_URI="http://setiathome.berkeley.edu/images/better_banner.jpg"

LICENSE="GPL-2"
SLOT="$(get_version_component_range 1 ${PV})"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"
S="${WORKDIR}"

src_install() {
	mkdir -p "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu || die
	cp ${DISTDIR}/better_banner.jpg "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu || die
	chown boinc:boinc "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu/better_banner.jpg || die
}
