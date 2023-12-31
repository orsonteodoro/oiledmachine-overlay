# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 user-info

SRC_URI="
https://github.com/jketterl/openwebrx/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"

DESCRIPTION="Open source, multi-user SDR receiver software with a web interface"
HOMEPAGE="https://www.openwebrx.de/"
LICENSE="AGPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
RESTRICT="mirror"
SLOT="0"
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
IUSE+="
${DEVICES[@]/#/openwebrx_sdr_}
${OPTIONAL_FEATURES[@]}
openrc systemd
"
REQUIRED_USE+="
	|| (
		openrc
		systemd
	)
"
SOAPY_DEVICES=(
	airspy
	airspyhf
	fcdpp
	hackrf
	lime_sdr
	pluto_sdr
	radioberry
	rtl_sdr_soapy
	sdrplay
	soapy_remote
	uhd
)
DIGIHAM_DEPEND="
	(
		>=dev-python/pydigiham-0.6.2[${PYTHON_USEDEP}]
		>=media-radio/digiham-0.6.2
	)
"
OWRX_CONNECTOR_DEPEND="
	>=media-radio/owrx_connector-0.6.2
"
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
" # Package it yourself
# Upstream uses codec2 with deprecade code, but the distro uses the recent one.
RDEPEND+="
	${RDEPEND_UNPACKAGED}
	$(gen_soapy_depends)
	(
		>=dev-python/pycsdr-0.18.2[${PYTHON_USEDEP}]
		>=media-radio/csdr-0.18.2
	)
	digital_voice_digiham? (
		${DIGIHAM_DEPEND}
		>=media-radio/codecserver-0.2
	)
	digital_voice_freedv? (
		media-libs/codec2
	)
	digital_voice_m17? (
		${DIGIHAM_DEPEND}
		>=media-radio/m17-cxx-demod-2.3
	)
	dream? (
		>=media-radio/dream-2.1.1
	)
	js8? (
		>=dev-python/js8py-0.1.2[${PYTHON_USEDEP}]
		>=media-radio/js8call-2.2.0
	)
	openwebrx_sdr_fifi_sdr? (
		media-libs/alsa-lib
		media-sound/alsa-utils
	)
	openwebrx_sdr_hpsdr? (
		>=media-radio/hpsdrconnector-0.6.1
	)
	openwebrx_sdr_lime_sdr? (
		net-wireless/limesuite
	)
	openwebrx_sdr_perseussdr? (
		net-libs/libperseus-sdr
		virtual/libusb
	)
	openwebrx_sdr_rtl_sdr? (
		${OWRX_CONNECTOR_DEPEND}
	)
	openwebrx_sdr_rtl_tcp? (
		${OWRX_CONNECTOR_DEPEND}
	)
	openwebrx_sdr_runds? (
		>=media-radio/runds_connector-0.2.3
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
		>=media-radio/direwolf-1.6
		media-radio/aprs-symbols
	)
	pocsag? (
		${DIGIHAM_DEPEND}
	)
	systemd? (
		sys-apps/systemd
	)
	wsjtx? (
		>=media-radio/wsjtx-2.5.4
	)
	|| (
		net-analyzer/netcat
		net-analyzer/openbsd-netcat
	)
"
DEPEND+="
	${RDEPEND}
"
DOCS=( CHANGELOG.md LICENSE.txt README.md )

pkg_setup() {
	ewarn "This ebuild is in development"
}

src_configure() {
	if ! egetent group ${PN} ; then
eerror
eerror "You must add the ${PN} group to the system."
eerror
eerror "  groupadd ${PN}"
eerror
		die
	fi
	if ! egetent passwd ${PN} ; then
eerror
eerror "You must add the ${PN} user to the system."
eerror
eerror "  useradd ${PN} -g ${PN} -d /var/lib/${PN}"
eerror
		die
	fi
	distutils-r1_src_configure
}

python_install() {
	distutils-r1_python_install
	local d_src="$(python_get_sitedir)/htdocs"
	local d_dest="/usr/share/${PN}/htdocs"
	dodir "${d_dest}"
	cp -aT "${ED}${d_src}" "${ED}${d_dest}" || die
	rm -rf "${ED}/${d_src}" || die
	cd "${ED}${d_dest}" || die
	local f
	for f in $(find . -type f) ; do
		f="${d_dest}/${f/\.\/}"
		einfo "Changing permissions for ${f}"
		fperms 0644 "${f}"
	done
	sed -i -e "4 a sys.path.insert(1, \"/usr/share/${PN}\")"\
		"${ED}/usr/lib/python-exec/${EPYTHON}/openwebrx" || die
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

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
