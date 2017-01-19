# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Setiathome configuration files"
SLOT="7"
KEYWORDS="amd64"
IUSE="ap-cpu ap-gpu sah-cpu sah-gpu"
RDEPEND="sah-cpu? ( sci-misc/setiathome-cpu:7= )
         sah-gpu? ( sci-misc/setiathome-gpu:7= )
         ap-cpu? ( sci-misc/astropulse-cpu:7= )
         ap-gpu? ( sci-misc/astropulse-gpu:7= )
        "
S="${WORKDIR}"

src_unpack() {
	use sah-cpu && cp /var/lib/boinc/projects/setiathome.berkeley.edu/app_info.xml_sah_cpu "${T}"
	use sah-gpu && cp /var/lib/boinc/projects/setiathome.berkeley.edu/app_info.xml_sah_gpu.ocl "${T}"
	use ap-cpu && cp /var/lib/boinc/projects/setiathome.berkeley.edu/app_info.xml_ap_cpu "${T}"
	use ap-gpu && cp /var/lib/boinc/projects/setiathome.berkeley.edu/app_info.xml_ap_gpu.ocl "${T}"
}

src_prepare() {
	eapply_User
}

src_install() {
	mkdir -p "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu
	cat ${FILESDIR}/app_info.xml_start >> "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu/app_info.xml
	use sah-cpu && cat ${T}/app_info.xml_sah_cpu >> "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu/app_info.xml
	use sah-gpu && cat ${T}/app_info.xml_sah_gpu.ocl >> "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu/app_info.xml
	use ap-cpu && cat ${T}/app_info.xml_ap_cpu >> "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu/app_info.xml
	use ap-gpu && cat ${T}/app_info.xml_ap_gpu.ocl >> "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu/app_info.xml
	cat ${FILESDIR}/app_info.xml_end >> "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu/app_info.xml
}
