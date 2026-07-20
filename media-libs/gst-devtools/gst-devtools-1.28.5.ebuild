# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHKL_TIMESTAMPS=(
	"dev-libs/glib-2.89.9999"
	"x11-libs/gtk+-3.24.9999"
)

inherit check-compiler-switch chkl flag-o-matic secure-version gstreamer-meson

KEYWORDS="~amd64 ~arm64 ~x86"

DESCRIPTION="A GStreamer based RTSP server library"
HOMEPAGE="https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
LICENSE="
	LGPL-2+
	debug_viewer? (
		GPL-3+
	)
	validate? (
		LGPL-2+
		LGPL-2.1+
		GPL-2
	)
"
IUSE="
cairo -debug_viewer doc dots_viewer gtk3 +introspection +nls static-libs test +tools validate
ebuild_revision_0
"
RDEPEND="
	>=media-libs/gstreamer-${PV}:${SLOT}=[${MULTILIB_USEDEP},introspection?]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}=[${MULTILIB_USEDEP},introspection?]
	>=dev-libs/glib-${GLIB_PV}:=[${MULTILIB_USEDEP}]
	>=dev-libs/json-glib-${JSON_GLIB_PV}:=[${MULTILIB_USEDEP}]
	gtk3? (
		>=x11-libs/gtk+-${GTK3_PV}:=[${MULTILIB_USEDEP}]
	)
	introspection? (
		>=dev-libs/gobject-introspection-${GOBJECT_INTROSPECTION_PV}:=
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"
DOCS=( "ChangeLog" "README.md" "RELEASE" "release-notes-1.28.md" )

pkg_setup() {
	check-compiler-switch_start
	gstreamer-meson_pkg_setup
}

multilib_src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	chkl_check_many_timestamps
	local emesonargs=(
		$(meson_feature cairo)
		$(meson_feature debug_viewer)
		$(meson_feature doc)
		$(meson_feature dots_viewer)
		$(meson_feature test tests)
		$(meson_feature nls)
		$(meson_feature tools)
		$(meson_feature validate)
		-Dintrospection=$(multilib_native_usex introspection "enabled" "disabled")
	)
	gstreamer_multilib_src_configure
}

multilib_src_install_all() {
	einstalldocs
}
