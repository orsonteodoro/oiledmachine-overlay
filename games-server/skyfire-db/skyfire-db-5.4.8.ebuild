# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils git-r3

DESCRIPTION="SkyFire database for the Mists of Pandaria (MOP) 5.4.8 Client"
HOMEPAGE="http://www.projectskyfire.org/"
LICENSE="GPL-3"
SLOT="5"
KEYWORDS="~amd64 ~x86"
RESTRICT="fetch"
RDEPEND="
	>=virtual/mysql-5.1.0
"
IUSE=""

S="${WORKDIR}"
SFDB_URI="http://www.projectskyfire.org/index.php?/files/file/1-skyfiredb-release11zip/"
SRC_URI=""

check_tarballs_available() {
	local uri=$1; shift
	local dl= unavailable=
	for dl in "${@}"; do
		[[ ! -f "${DISTDIR}/${dl}" ]] && unavailable+=" ${dl}"
	done

	if [[ -n "${unavailable}" ]]; then
		if [[ -z ${_check_tarballs_available_once} ]]; then
			einfo
			einfo "SkyFire requires you to download the needed files manually."
			einfo
			_check_tarballs_available_once=1
		fi
		einfo "Download the following files:"
		for dl in ${unavailable}; do
			einfo "  ${dl}"
		done
		einfo "at '${uri}'"
		einfo
		einfo "After you downloaded the DB you need to extract the"
		einfo "${dl} file from the downloaded file and move it into ${DISTDIR}"
		einfo
	fi
}

pkg_nofetch() {
	local distfiles=( $(eval "echo \${$(echo AT_${ARCH/-/_})}") )
	check_tarballs_available "${SFDB_URI}" "${distfiles[@]}"
}

src_unpack() {
	unpack "${A}"
}

src_prepare() {
	epatch_user
}

src_install() {
	mkdir -p "${D}/usr/share/skyfire/5"
	cp -R "${WORKDIR}"/* "${D}/usr/share/skyfire/5"
}
