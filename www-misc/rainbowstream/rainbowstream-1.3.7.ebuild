# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 eutils

DESCRIPTION="Command line twitter"
HOMEPAGE="http://www.rainbowstream.org/"
SRC_URI="https://github.com/DTVD/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"

IUSE="jpeg"

DEPEND="dev-python/requests
        dev-python/python-dateutil
        =dev-python/twitter-9999
        dev-python/PySocks
        dev-python/pillow[jpeg?]
        dev-python/arrow
        dev-python/pocket
        dev-python/pyfiglet"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${P}"

python_prepare_all() {
	eapply "${FILESDIR}"/${PN}-1.3.7-no-user-env.patch
	eapply "${FILESDIR}"/${PN}-1.3.5-requests-relax-version.patch
	eapply_user
        distutils-r1_python_prepare_all
}

python_compile() {
	mkdir -p "${D}/usr/share/${P}/homedir"
	HOME="${D}/usr/share/${P}/homedir" \
	SUDO_USER="root" \
	USER="root" \
        distutils-r1_python_compile
	cp "${D}/usr/share/${P}/homedir/.rainbow_config.json" "${T}/.rainbow_config.json"
}

python_install_all() {
	mkdir -p "${D}/usr/share/${P}/homedir"
	HOME="${D}/usr/share/${P}/homedir" \
	SUDO_USER="root" \
	USER="root" \
        distutils-r1_python_install_all
	cp "${T}/.rainbow_config.json" "${D}/usr/share/${P}/homedir/.rainbow_config.json"
	echo ${PYTHON_TARGETS}
	for i in ${PYTHON_TARGETS}; do
		dosym "/etc/rainbowstream/consumer.py" "/usr/lib/${i}/site-packages/${PN}/consumer.py"
	done
	mkdir -p "${D}/etc/rainbowstream"
	cp "${FILESDIR}"/consumer.py "${D}/usr/share/${P}"
}

pkg_postinst() {
	einfo "You need to create a consumer.py in /etc/rainbowstream"
	einfo "Details about this is in ${D}/usr/share/${P}/consumer.py and https://github.com/DTVD/rainbowstream"
	einfo "You need to copy ${D}/usr/share/${P}/homedir/.rainbow_config.json to your homedir."
}
