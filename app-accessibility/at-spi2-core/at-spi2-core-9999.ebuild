# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"

PYTHON_COMPAT=( python3_{10..14} )

CHKL_TIMESTAMPS=(
	"sys-apps/dbus-9999"
	"dev-libs/glib-2.89.9999"
	"dev-libs/libxml2-9999"
	"sys-apps/systemd-9999"
	"x11-libs/libX11-9999"
)

inherit cflags-hardened chkl gnome.org meson-multilib python-r1 secure-version systemd virtualx xdg

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="5062a4d9598c91e0d28835f17a5fa6ffe15f8bc7"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/at-spi2-core.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
fi

DESCRIPTION="D-Bus accessibility specifications and registration daemon"
HOMEPAGE="https://gitlab.gnome.org/GNOME/at-spi2-core"

LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
IUSE+=" X dbus-broker gtk-doc +introspection systemd"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	dbus-broker? ( systemd )
	gtk-doc? ( X )
"

DEPEND="
	>=sys-apps/dbus-${DBUS_PV}:=[${MULTILIB_USEDEP}]
	>=dev-libs/glib-${GLIB_PV}:=[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-${LIBXML2_PV}:=[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-${GOBJECT_INTROSPECTION_PV}:= )
	systemd? ( >=sys-apps/systemd-${SYSTEMD_PV}:=[${MULTILIB_USEDEP}] )
	X? (
		>=x11-libs/libX11-${LIBX11_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXtst-${LIBXTST_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXi-${LIBXI_PV}:=[${MULTILIB_USEDEP}]
	)

	!<dev-libs/atk-2.46.0
"
RDEPEND="${DEPEND}
	${PYTHON_DEPS}
	dbus-broker? ( sys-apps/dbus-broker:= )
"
BDEPEND="
	dev-util/glib-utils
	gtk-doc? (
		dev-python/sphinx
		dev-util/gdbus-codegen
		>=dev-util/gi-docgen-2021.1
	)
	${PYTHON_DEPS}
	test? ( dev-python/pygobject[${PYTHON_USEDEP}] )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

multilib_src_configure() {
	python_setup

	chkl_check_many_timestamps
	cflags-hardened_append

	local emesonargs=(
		-Ddefault_bus=$(usex dbus-broker dbus-broker dbus-daemon)
		$(meson_use systemd use_systemd)
		-Dgtk2_atk_adaptor=true
		-Dsystemd_user_dir="$(systemd_get_userunitdir)"
		$(meson_native_use_bool gtk-doc docs)
		$(meson_native_use_feature introspection)
		$(meson_feature X x11)
		-Datk_only=false
		-Dpython="${EPYTHON}"
	)
	meson_src_configure
}

multilib_src_test() {
	# Avoid locales using commas as decimal separators and breaking some
	# tests
	LC_ALL=C.UTF-8 virtx dbus-run-session meson test -C "${BUILD_DIR}" --print-errorlogs || die
}

multilib_src_install_all() {
	einstalldocs
	python_optimize

	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/{libatspi,atk} || die
		mv "${ED}"/usr/share/doc/libatspi "${ED}"/usr/share/gtk-doc/libatspi/html || die
		mv "${ED}"/usr/share/doc/atk "${ED}"/usr/share/gtk-doc/atk/html || die
	fi
}
