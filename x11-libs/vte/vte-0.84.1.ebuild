# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data security-critical sensitive-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="DOS"
PYTHON_COMPAT=( "python3_"{11..14} )

CHKL_TIMESTAMPS=(
	"app-arch/lz4-9999"
	"dev-libs/fribidi-9999"
	"dev-libs/glib-2.90.9999"
	"dev-libs/icu-79.1.9999"
	"dev-libs/libfmt-9999"
	"dev-libs/libpcre2-9999"
	"dev-libs/libxml2-9999"
	"sys-apps/systemd-9999"
	"x11-libs/cairo-9999"
	"x11-libs/pango-9999"
	"x11-libs/gtk+-3.24.9999"
)

inherit cflags-hardened chkl flag-o-matic gnome.org meson python-any-r1 secure-version vala xdg

DESCRIPTION="Library providing a virtual terminal emulator widget"
HOMEPAGE="https://gitlab.gnome.org/GNOME/vte"

# Once SIXEL support ships (0.66 or later), might need xterm license (but code might be considered upgraded to LGPL-3+)
LICENSE="LGPL-3+ GPL-3+"
API_VERSION="2.91" # vte_api_version in meson.build
SLOT="${API_VERSION}"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="X +crypt debug gtk-doc +icu +introspection systemd +vala wayland"
REQUIRED_USE="
	gtk-doc? ( introspection )
	vala? ( introspection )
"

DEPEND="
	>=app-arch/lz4-${LZ4_PV}:=
	>=dev-libs/libfmt-${LIBFMT_PV}:=
	>=dev-libs/fribidi-${FRIBIDI_PV}:=
	>=dev-libs/glib-${GLIB_PV}:=
	>=dev-libs/libpcre2-${LIBPCRE2_PV}:=
	>=dev-cpp/simdutf-6.2.0:=
	>=x11-libs/cairo-${CAIRO_PV}:=
	>=x11-libs/gtk+-${GTK3_PV}:3=[X?,introspection?,wayland?]
	>=x11-libs/pango-${PANGO_PV}:=[introspection?]
	dev-cpp/fast_float:=
	crypt?  ( >=net-libs/gnutls-${GNUTLS_PV}:= )
	icu? ( >=dev-libs/icu-${ICU_PV}:= )
	systemd? ( >=sys-apps/systemd-${SYSTEMD_PV}:= )
	introspection? ( >=dev-libs/gobject-introspection-${GOBJECT_INTROSPECTION_PV}:= )
"
RDEPEND="${DEPEND}
	~gui-libs/vte-common-${PV}:=[systemd?]
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/libxml2-${LIBXML2_PV}:=
	>=sys-devel/gettext-0.19.8
	dev-util/glib-utils
	virtual/pkgconfig
	gtk-doc? ( dev-util/gi-docgen )
	vala? ( $(vala_depend) )
"

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_src_unpack
	else
		unpack ${A}
	fi

	local expected_api_version="${API_VERSION}"
	local api_ver_c1=$(grep -E -o -e "vte_api_major_version = [0-9]+" "${S}/meson.build" | cut -f 3 -d " ")
	local api_ver_c2=$(grep -E -o -e "vte_api_minor_version = [0-9]+" "${S}/meson.build" | cut -f 3 -d " ")
	local actual_api_version="${api_ver_c1}.${api_ver_c2}"
	if ver_test "${actual_api_version}" "-ne" "${expected_api_version}" ; then
eerror "QA:  Update API_VERSION"
eerror "Actual API_VERSION:  ${actual_api_version}"
eerror "Expected API_VERSION:  ${expected_api_version}"
		die
	fi
}

src_prepare() {
	default
	use vala && vala_setup
	xdg_environment_reset

	use elibc_musl && eapply "${FILESDIR}"/${PN}-0.84.0-musl-W_EXITCODE.patch

	# -Ddebug option enables various debug support via VTE_DEBUG, but also ggdb3; strip the latter
	sed -e '/ggdb3/d' -i meson.build || die
	sed -i 's/vte_gettext_domain = vte_api_name/vte_gettext_domain = vte_gtk3_api_name/' meson.build || die
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	# Upstream don't support LTO & error out on it in meson.build
	filter-lto

	use X || append-flags -DGENTOO_GTK_HIDE_X11
	use wayland || append-flags -DGENTOO_GTK_HIDE_WAYLAND

	local emesonargs=(
		-Da11y=true
		-Dapp-hidden=true
		$(meson_use debug)
		$(meson_use gtk-doc docs)
		$(meson_use introspection gir)
		-Dfribidi=true # pulled in by pango anyhow
		-Dglade=true
		$(meson_use crypt gnutls)
		-Dgtk3=true
		-Dgtk4=false
		$(meson_use icu)
		$(meson_use systemd _systemd)
		$(meson_use vala vapi)
	)
	meson_src_configure
}

src_install() {
	# not meson_src_install because this would include einstalldocs, which
	# would result in file collisions with gui-libs/vte
	meson_install

	# Remove files that are provided by gui-libs/vte-common
	rm "${ED}"/usr/libexec/vte-urlencode-cwd || die
	rm "${ED}"/etc/profile.d/vte.sh || die
	rm "${ED}"/etc/profile.d/vte.csh || die
	if use systemd; then
		rm "${ED}"/usr/lib/systemd/user/vte-spawn-.scope.d/defaults.conf || die
	fi
	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/ || die
		mv "${ED}"/usr/share/doc/vte-${SLOT} "${ED}"/usr/share/gtk-doc/vte-${SLOT}-gtk3 || die
	fi
}
