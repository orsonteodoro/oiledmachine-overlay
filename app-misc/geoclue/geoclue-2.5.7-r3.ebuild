# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="xml(+)"
VALA_USE_DEPEND="vapigen"

inherit meson python-any-r1 systemd vala xdg

DESCRIPTION="A location information D-Bus service"
HOMEPAGE="https://gitlab.freedesktop.org/geoclue/geoclue/wikis/home"
SRC_URI="https://gitlab.freedesktop.org/geoclue/${PN}/-/archive/${PV}/${P}.tar.bz2
fix-regression-142? (
https://gitlab.freedesktop.org/geoclue/geoclue/-/commit/194529c7e7123b06d41eb8025cd4375aba271068
	-> geoclue-194529c.patch
https://gitlab.freedesktop.org/geoclue/geoclue/-/commit/715cfbf5bec8002fb1e9759b6c34bc070f977807
	-> geoclue-715cfbf.patch
)
"

LICENSE="LGPL-2.1+ GPL-2+"
SLOT="2.0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE="+fix-regression-142 +introspection gtk-doc modemmanager test vala zeroconf"
REQUIRED_USE="vala? ( introspection )"

DEPEND="
	>=dev-libs/glib-2.44:2
	>=dev-libs/json-glib-0.14.0
	>=net-libs/libsoup-2.42.0:2.4
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
	modemmanager? ( >=net-misc/modemmanager-1.6 )
	zeroconf? ( >=net-dns/avahi-0.6.10[dbus] )
	x11-libs/libnotify
"
RDEPEND="${DEPEND}
	acct-user/geoclue
	sys-apps/dbus
"
BDEPEND="
	${PYTHON_DEPS}
	dev-util/gdbus-codegen
	dev-util/glib-utils
	gtk-doc? (
		app-text/docbook-xml-dtd:4.1.2
		>=dev-util/gtk-doc-1 )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

PATCHES=(
	"${FILESDIR}"/2.5.3-optional-vapi.patch
)

show_geolocation_opt_out() {
ewarn
ewarn "You may opt out of geolocation by adding a _nomap to the end to your"
ewarn "WiFI router's or access point's SSID string.  See also:"
ewarn
ewarn "https://en.wikipedia.org/wiki/Wi-Fi_positioning_system#Public_Wi-Fi_location_databases"
ewarn
}

pkg_setup() {
	if use test ; then
		if [[ -z "${I_CONSENT_TO_GEOCLUE_TESTING_AND_MLS}" \
		|| ( -n "${I_CONSENT_TO_GEOCLUE_TESTING_AND_MLS}" \
			&& "${I_CONSENT_TO_GEOCLUE_TESTING_AND_MLS}" != "1" ) ]] ; then
eerror
eerror "You must consent to sending data to the Mozilla Location Service."
eerror "To remove this message by setting the"
eerror "I_CONSENT_TO_GEOCLUE_TESTING_AND_MLS=1 environment variable."
eerror
eerror "Testing may not work if the wifi's router's BSSID is not mapped to a"
eerror "physical location."
eerror
			show_geolocation_opt_out
			die
		fi

		if ! ( ps -aux | grep -q -e "dbus-daemon" ) ; then
			die "D-BUS must be enabled in order to do testing."
		fi
	fi
	python-any-r1_pkg_setup
}

src_prepare() {
	xdg_src_prepare
	use vala && vala_src_prepare
	if use fix-regression-142 ; then
		# Still an open issue, See https://gitlab.freedesktop.org/geoclue/geoclue/-/issues/142
		einfo
		einfo "Reverting 194529c and 715cfbf to resolve the following:"
		einfo "Failed to create query: No WiFi devices available"
		einfo
		eapply -R "${DISTDIR}/geoclue-194529c.patch"
		eapply -R "${DISTDIR}/geoclue-715cfbf.patch"
	fi
}

src_configure() {
	local emesonargs=(
		-Dlibgeoclue=true
		$(meson_use introspection)
		$(meson_use vala vapi)
		$(meson_use gtk-doc)
		$(meson_use modemmanager 3g-source)
		$(meson_use modemmanager cdma-source)
		$(meson_use modemmanager modem-gps-source)
		$(meson_use zeroconf nmea-source)
		-Denable-backend=true
		-Ddemo-agent=true
		-Dsystemd-system-unit-dir="$(systemd_get_systemunitdir)"
		-Ddbus-srv-user=geoclue
	)
	meson_src_configure
}

src_test() {
	einfo "Deferred testing to pkg_postinst"
}

die_failed_test() {
	einfo "Restoring backup geoclue.conf"
	cat "${backup_conf}" > /etc/geoclue/geoclue.conf
	rm "${backup_conf}"
	eerror "Test failed"
	[[ -d /var/db/pkg/app-misc/geoclue-${PVR} ]] \
		&& rm -rf /var/db/pkg/app-misc/geoclue-${PVR}
	[[ -f "${D_LOG}" ]] \
		&& rm "${D_LOG}"
	die "${1}"
}

D_LOG=
pkg_postinst()
{
	# Testing has to be done here because of the difficulty of
	# changing dbus search patch for service files.
	if use test ; then
		local vanilla_conf="${FILESDIR}/geoclue.conf_2.5.7"
		local backup_conf=$(mktemp)
		[[ ! -f "${vanilla_conf}" ]] && die_failed_test "${vanilla_conf} does not exist"
		cat /etc/geoclue/geoclue.conf > "${backup_conf}" || die
		cat "${vanilla_conf}" > /etc/geoclue/geoclue.conf || die
		sed -i -e "s|submit-data=false|submit-data=true|" \
			/etc/geoclue/geoclue.conf || die_failed_test
		sed -i -e "s|whitelist=|whitelist=where-am-i;|" \
			/etc/geoclue/geoclue.conf || die_failed_test
		einfo "Running agent"
		[[ -f /usr/libexec/geoclue-2.0/demos/agent ]] || die_failed_test "Missing file"
		[[ -f /usr/libexec/geoclue-2.0/demos/where-am-i ]] || die_failed_test "Missing file"
		timeout 62 /usr/libexec/geoclue-2.0/demos/agent &
		timeout_pid=$!
		sleep 0.25
		agent_pid=$(ps -o pid= --ppid ${timeout_pid})

		sleep 2 # Give agent some time to load.
		local pass=0
		local try=0
		for n in 2 3 5 7 11 13 17 ; do
			try=$(( ${try} + 1 ))
			if ! ps -p ${agent_pid} 2>/dev/null 1>/dev/null ; then
				ewarn "${PN} agent died"
				break
			fi
			D_LOG=$(mktemp)
			# This may fail several times.
			einfo "Running where-am-i instance for ${n} seconds, ${try} try"
			timeout ${n} /usr/libexec/geoclue-2.0/demos/where-am-i 2>&1 1>"${D_LOG}" &
			sleep ${n} # Wait for data
			local result=$(cat "${D_LOG}")
			einfo "Result:"
			einfo -e "${result}"
			[[ "${result}" =~ "Latitude:" ]] && pass=1
			(( ${pass} == 1 )) && break
		done
		[[ -f "${D_LOG}" ]] && rm "${D_LOG}"
		if (( ${pass} == 1 )) ; then
			einfo "Test passed"
		else
			cat "${backup_conf}" > /etc/geoclue/geoclue.conf
einfo
einfo "Wiping /var/db/pkg/app-misc/geoclue-${PVR} to remove the installed bit"
einfo "[R] from emerge to force re-emerge of working copy."
einfo
			die_failed_test "Test failed"
		fi
		cat "${backup_conf}" > /etc/geoclue/geoclue.conf
	fi
	if grep -q "^submit-data=true" ; then
ewarn
ewarn "submit-data=true is still set to true to submit data to a WPS service."
ewarn "This may be a privacy issue.  Add # in front of it in"
ewarn "/etc/geoclue/geoclue.conf if it is a problem."
ewarn
	fi
ewarn
ewarn "You may need to set submit-data=true in /etc/geoclue/geoclue.conf to use"
ewarn "the WPS (Wi-Fi positioning system) service that converts the 48-bit"
ewarn "BSSID from to a physical location can be changed by editing"
ewarn "/etc/geoclue/geoclue.conf file."
ewarn
	show_geolocation_opt_out
}
