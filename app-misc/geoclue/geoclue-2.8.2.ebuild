# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="sensitive-data"

PYTHON_COMPAT=( python3_{10..14} )
PYTHON_REQ_USE="xml(+)"

CHKL_TIMESTAMPS=(
	"dev-libs/glib-2.89.9999"
	"net-dns/avahi-9999"
)

inherit cflags-hardened chkl meson python-any-r1 secure-version systemd vala xdg

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="45aa6aefb474f6e20ed02bcf1a556b93fa6db2f2"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://gitlab.freedesktop.org/geoclue/geoclue.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/geoclue/${PN}/-/archive/${PV}/${P}.tar.bz2"
fi

DESCRIPTION="Location information D-Bus service"
HOMEPAGE="https://gitlab.freedesktop.org/geoclue/geoclue/-/wikis/home"

LICENSE="LGPL-2.1+ GPL-2+"
SLOT="2.0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE+=" +introspection gtk-doc modemmanager selinux vala zeroconf"
REQUIRED_USE="vala? ( introspection )"

DEPEND="
	>=dev-libs/glib-${GLIB_PV}:=
	>=dev-libs/json-glib-${JSON_GLIB_PV}:=
	>=net-libs/libsoup-${LIBSOUP_PV}:3.0=
	introspection? ( >=dev-libs/gobject-introspection-${GOBJECT_INTROSPECTION_PV}:= )
	modemmanager? ( >=net-misc/modemmanager-1.12:= )
	zeroconf? ( >=net-dns/avahi-${AVAHI_PV}:=[dbus] )
	x11-libs/libnotify:=
"
RDEPEND="${DEPEND}
	acct-user/geoclue:*
	>=sys-apps/dbus-${DBUS_PV}:=
	selinux? ( sec-policy/selinux-geoclue:* )
"
BDEPEND="${PYTHON_DEPS}
	>=dev-util/gdbus-codegen-2.80.5-r1
	dev-util/glib-utils
	gtk-doc? (
		app-text/docbook-xml-dtd:4.1.2
		>=dev-util/gtk-doc-1 )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_prepare() {
	default
	use vala && vala_setup
	xdg_environment_reset
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	local emesonargs=(
		-Dlibgeoclue=true
		$(meson_use introspection)
		$(meson_use vala vapi)
		$(meson_use gtk-doc)
		$(meson_use modemmanager 3g-source)
		$(meson_use modemmanager cdma-source)
		$(meson_use modemmanager modem-gps-source)
		$(meson_use zeroconf nmea-source)
		-Dcompass=true
		-Denable-backend=true
		-Ddemo-agent=true
		-Dsystemd-system-unit-dir="$(systemd_get_systemunitdir)"
		-Ddbus-srv-user=geoclue
	)
	meson_src_configure
}

src_install () {
	meson_src_install
	# sysusers.d file is provided by acct-user/geoclue, #973676
	rm "${ED}"/usr/lib/sysusers.d/geoclue-sysusers.conf || die
}
