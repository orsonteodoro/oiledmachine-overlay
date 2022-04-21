# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 user

DESCRIPTION="Open source, multi-user SDR receiver software with a web interface"
HOMEPAGE="https://www.openwebrx.de/"
LICENSE="AGPL-3"
#KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
DOCS=( CHANGELOG.md LICENSE.txt README.md )
RESTRICT="mirror"
SLOT="0"
IUSE+=" systemd"
SRC_URI="
https://github.com/jketterl/openwebrx/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"
IUSE+=" "
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}
"
RDEPEND+=" ${PYTHON_DEPS}
	  dev-python/js8py[${PYTHON_USEDEP}]
	>=media-radio/csdr-0.17
	>=media-radio/codecserver-0.1
	>=media-radio/digiham-0.5
	>=media-radio/direwolf-1.4
	  media-radio/hpsdrconnector
	  media-radio/js8call
	  media-radio/m17-cxx-demod
	>=media-radio/owrx_connector-0.5
	  media-radio/runds_connector
	  media-radio/wsjtx
	  media-sound/sox
	  net-analyzer/netcat
	  net-wireless/soapysdr[${PYTHON_USEDEP},python]
	  x11-themes/aprs-symbols
	systemd? (
		sys-apps/systemd
	)
"
DEPEND+=" ${RDEPEND}"
BDEPEND+=" ${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
S="${WORKDIR}/${P}"

pkg_setup() {
	ewarn "This ebuild is in development"
	enewuser openwebrx
}

src_install() {
	distutils-r1_src_install
	cd "${S}" || die
	insinto /etc/openwebrx
	doins bands.json openwebrx.conf
	if use systemd ; then
		insinto /lib/systemd/system
		doins systemd/openwebrx.service
	fi

	insinto /var/lib/openwebrx

	echo "[]" > "${T}/users.json"
	doins "${T}/users.json"
	fowners openwebrx /var/lib/openwebrx/users.json
	fperms 0600 /var/lib/openwebrx/users.json

	echo "{}" > "${T}/settings.json"
	doins "${T}/settings.json"
	fowners openwebrx /var/lib/openwebrx/settings.json

	touch bookmarks.json
	doins "${T}/bookmarks.json"
	fowners openwebrx /var/lib/openwebrx/bookmarks.json

	einstalldocs
}

pkg_postinst() {
	if ! openwebrx admin --silent hasuser admin; then
		einfo "Admin user created"
		openwebrx admin --noninteractive adduser admin
		ewarn "A ${PN} password may be assigned to this user"
	fi
}
