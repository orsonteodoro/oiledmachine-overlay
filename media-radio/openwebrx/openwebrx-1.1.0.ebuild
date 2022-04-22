# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 user

DESCRIPTION="Open source, multi-user SDR receiver software with a web interface"
HOMEPAGE="https://www.openwebrx.de/"
LICENSE="AGPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
DOCS=( CHANGELOG.md LICENSE.txt README.md )
RESTRICT="mirror"
SLOT="0"
IUSE+=" openrc systemd"
DEVICES=(
	rtl_sdr
	rtl_sdr_soapy
	rtl_tcp
	sdrplay
	hackrf
	perseussdr
	airspy
	airspyhf
	lime_sdr
	fifi_sdr
	pluto_sdr
	soapy_remote
	uhd
	radioberry
	fcdpp
	sddc
	hpsdr
	runds
)
OPTIONAL_FEATURES=(
	dream
	digital_voice_digiham
	digital_voice_freedv
	digital_voice_m17
	wsjtx
	packet
	pocsag
	js8
	drm
)
IUSE+=" ${DEVICES[@]/#/openwebrx_sdr_}"
IUSE+=" ${OPTIONAL_FEATURES[@]}"
REQUIRED_USE="|| ( openrc systemd )"
SRC_URI="
https://github.com/jketterl/openwebrx/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}
"
OWRX_CONNECTOR_DEPEND="
	>=media-radio/owrx_connector-0.5
"
SOX_DEPEND="
	media-sound/sox
"
SOAPY_DEVICES=(
	rtl_sdr_soapy
	sdrplay
	hackrf
	airspy
	airspyhf
	lime_sdr
	pluto_sdr
	soapy_remote
	uhd
	radioberry
	fcdpp
)
gen_soapy_depends() {
	local d
	for d in ${SOAPY_DEVICES[@]} ; do
		echo "
		openwebrx_sdr_${d}? (
			${OWRX_CONNECTOR_DEPEND}
		)
		"
		if [[ "${d}" == "hackrf" ]] ; then
			echo "
				openwebrx_sdr_${d}? (
					net-wireless/soapysdr[${PYTHON_USEDEP},hackrf,python]
				)
			"
		elif [[ "${d}" =~ "rtl_sdr" ]] ; then
			echo "
				openwebrx_sdr_${d}? (
					net-wireless/soapysdr[${PYTHON_USEDEP},rtlsdr,python]
				)
			"
		elif [[ "${d}" == "pluto_sdr" ]] ; then
			echo "
				openwebrx_sdr_${d}? (
					net-wireless/soapysdr[${PYTHON_USEDEP},plutosdr,python]
				)
			"
		elif [[ "${d}" == "uhd" ]] ; then
			echo "
				openwebrx_sdr_${d}? (
					net-wireless/soapysdr[${PYTHON_USEDEP},uhd,python]
				)
			"
		else
			echo "
				openwebrx_sdr_${d}? (
					net-wireless/soapysdr[${PYTHON_USEDEP},python]
				)
			"
		fi
	done
}
RDEPEND+=" "$(gen_soapy_depends)
RDEPEND_UNPACKAGED+="
	openwebrx_sdr_airspy? (
		net-wireless/soapyairspy
	)
	openwebrx_sdr_airspyhf? (
		net-wireless/soapyairspyhf
	)
	openwebrx_sdr_fcdpp? (
		net-wireless/soapyfcdpp
	)
	openwebrx_sdr_radioberry? (
		net-wireless/radioberry2
	)
	openwebrx_sdr_fifi_sdr? (
		net-wireless/rockprog
	)
"
RDEPEND+=" ${RDEPEND_UNPACKAGED}" # Package it yourself
RDEPEND+=" ${PYTHON_DEPS}
	>=media-radio/csdr-0.17
	|| (
		net-analyzer/netcat
		net-analyzer/openbsd-netcat
	)
	digital_voice_digiham? (
		${SOX_DEPEND}
		>=media-radio/codecserver-0.1
		>=media-radio/digiham-0.5
	)
	digital_voice_freedv? (
		${SOX_DEPEND}
		media-libs/codec2
	)
	digital_voice_m17? (
		${SOX_DEPEND}
		>=media-radio/digiham-0.5
		  media-radio/m17-cxx-demod
	)
	dream? (
		${SOX_DEPEND}
		media-radio/dream
	)
	js8? (
		${SOX_DEPEND}
		dev-python/js8py[${PYTHON_USEDEP}]
		media-radio/js8call
	)
	openwebrx_sdr_perseussdr? (
		net-libs/libperseus-sdr
	)
	openwebrx_sdr_rtl_sdr? (
		${OWRX_CONNECTOR_DEPEND}
	)
	openwebrx_sdr_rtl_tcp? (
		${OWRX_CONNECTOR_DEPEND}
	)
	openwebrx_sdr_fifi_sdr? (
		media-libs/alsa-lib
		media-sound/alsa-utils
	)
	openwebrx_sdr_hpsdr? (
		media-radio/hpsdrconnector
	)
	openwebrx_sdr_lime_sdr? (
		net-wireless/limesuite
	)
	openwebrx_sdr_perseussdr? (
		virtual/libusb
	)
	openwebrx_sdr_runds? (
		media-radio/runds_connector
	)
	openwebrx_sdr_sddc? (
		media-radio/sddc_connector
	)
	openwebrx_sdr_sdrplay? (
		net-wireless/soapysdrplay
	)
	openwebrx_sdr_soapy_remote? (
		net-wireless/soapyremote
	)
	packet? (
		${SOX_DEPEND}
		  media-radio/aprs-symbols
		>=media-radio/direwolf-1.4
	)
	pocsag? (
		${SOX_DEPEND}
		>=media-radio/digiham-0.5
	)
	systemd? (
		sys-apps/systemd
	)
	wsjtx? (
		${SOX_DEPEND}
		media-radio/wsjtx
	)
"
DEPEND+=" ${RDEPEND}"
BDEPEND+=" ${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
S="${WORKDIR}/${P}"

pkg_setup() {
	ewarn "This ebuild is in development"
	enewuser ${PN}
	enewgroup ${PN}
	esetgroups ${PN} ${PN}
}

src_install() {
	distutils-r1_src_install
	cd "${S}" || die
	insinto /etc/${PN}
	doins bands.json ${PN}.conf
	if use systemd ; then
		insinto /lib/systemd/system
		doins systemd/${PN}.service
	fi

	if use openrc ; then
		exeinto /etc/init.d
		doexe "${FILESDIR}/init.d/${PN}"
	fi

	insinto /var/lib/${PN}

	echo "[]" > "${T}/users.json"
	doins "${T}/users.json"
	fowners ${PN} /var/lib/${PN}/users.json
	fperms 0600 /var/lib/${PN}/users.json

	echo "{}" > "${T}/settings.json"
	doins "${T}/settings.json"
	fowners ${PN} /var/lib/${PN}/settings.json

	touch "${T}/bookmarks.json"
	doins "${T}/bookmarks.json"
	fowners ${PN} /var/lib/${PN}/bookmarks.json

	fowners ${PN}:${PN} /var/lib/${PN}

	einstalldocs
}

pkg_postinst() {
	if ! ${PN} admin --silent hasuser admin; then
		einfo "Admin user created but the default password should be changed"
		${PN} admin --noninteractive adduser admin
	fi
	einfo
	einfo "The init script must be started before accessing the web based interface."
	einfo "To access the web based interface put http://localhost:8073"
	einfo "To access the web admin panel put http://localhost:8073/settings"
	einfo "To change the password do:  openwebrx admin resetpassword admin"
	einfo
}
