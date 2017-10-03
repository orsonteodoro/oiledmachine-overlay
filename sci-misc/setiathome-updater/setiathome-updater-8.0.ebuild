# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Setiathome configuration files"
SLOT="8"
KEYWORDS="amd64"
IUSE="ap-cpu ap-gpu sah-cpu sah-gpu"
RDEPEND="sah-cpu? ( sci-misc/setiathome-cpu:8= )
         sah-gpu? ( sci-misc/setiathome-gpu:8= )
         ap-cpu? ( sci-misc/astropulse-cpu:7= )
         ap-gpu? ( sci-misc/astropulse-gpu:7= )
        "
S="${WORKDIR}"

src_unpack() {
	cp -a "${FILESDIR}"/setiathome-updater "${WORKDIR}"/
	cp -a "${FILESDIR}"/app_info.xml_end "${WORKDIR}"/
	cp -a "${FILESDIR}"/app_info.xml_start "${WORKDIR}"/
}

src_prepare() {
	eapply_user
}

src_install() {
	mkdir -p "${D}"/usr/share/setiathome-updater/
	cp "${WORKDIR}"/setiathome-updater "${D}"/usr/share/setiathome-updater/
	cp "${WORKDIR}"/app_info.xml_end "${D}"/usr/share/setiathome-updater/
	cp "${WORKDIR}"/app_info.xml_start "${D}"/usr/share/setiathome-updater/
	chmod +x "${D}"/usr/share/setiathome-updater/setiathome-updater
	dosym /usr/share/setiathome-updater/setiathome-updater /usr/bin/setiathome-updater
}

pkg_postinst() {
	einfo "Running updater"
	setiathome-updater
}
