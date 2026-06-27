# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Add retpoline for the show password feature
CFLAGS_HARDENED_CI_SANITIZERS="asan"
CFLAGS_HARDENED_CI_SANITIZERS_CLANG_COMPAT="18" # F40
CFLAGS_HARDENED_FORTIFY_FIX_LEVEL=3
CFLAGS_HARDENED_LANGS="c-lang"
CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO CE DOS HO IO"

CHKL_TIMESTAMPS=(
	"dev-libs/fribidi-9999"
	"dev-libs/glib-2.89.9999"
	"media-libs/freetype-9999"
	"media-libs/harfbuzz-9999"
	"x11-libs/cairo-9999"
	"x11-libs/libX11-9999"
)

inherit cflags-hardened flag-o-matic chkl gnome2-utils meson-multilib secure-version xdg

DESCRIPTION="Internationalized text layout and rendering library"
HOMEPAGE="https://www.gtk.org/docs/architecture/pango https://gitlab.gnome.org/GNOME/pango"
SRC_URI="https://download.gnome.org/sources/pango/$(ver_cut 1-2)/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

IUSE+="
debug examples gtk-doc +introspection sysprof test X
ebuild_revision_7
"
REQUIRED_USE="gtk-doc? ( introspection )"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-${GLIB_PV}:=[${MULTILIB_USEDEP}]
	>=dev-libs/fribidi-${FRIBIDI_PV}:=[${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-${HARFBUZZ_PV}:=[glib(+),introspection?,truetype(+),${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-${FONTCONFIG_PV}:=[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-${CAIRO_PV}:=[X?,${MULTILIB_USEDEP}]
	>=media-libs/freetype-${FREETYPE_PV}:=[harfbuzz,png,${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-${GOBJECT_INTROSPECTION_PV}:= )
	X? (
		>=x11-libs/libX11-${LIBX11_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXft-${LIBXFT_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXrender-${LIBXRENDER_PV}:=[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	sysprof? ( >=dev-util/sysprof-capture-3.40.1:4[${MULTILIB_USEDEP}] )
	X? ( x11-base/xorg-proto )
"
BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
	dev-python/docutils
	gtk-doc? ( dev-util/gi-docgen )
	test? ( media-fonts/cantarell )
"

src_prepare() {
	default
	xdg_environment_reset
	gnome2_environment_reset

	# get rid of a win32 example
	rm examples/pangowin32tobmp.c || die

	# Skip broken test:
	# https://gitlab.gnome.org/GNOME/pango/-/issues/677
	rm tests/layouts/valid-20.layout || die
}

multilib_src_configure() {
	if use debug; then
		append-cflags -DPANGO_ENABLE_DEBUG
	else
		append-cflags -DG_DISABLE_CAST_CHECKS
	fi

	chkl_check_many_timestamps
	cflags-hardened_append

	local emesonargs=(
		# Never use gi-docgen subproject
		--wrap-mode nofallback

		$(meson_native_use_bool gtk-doc documentation)
		$(meson_native_use_feature introspection)
		-Dman-pages=true
		$(meson_use test build-testsuite)
		-Dbuild-examples=false
		-Dfontconfig=enabled
		$(meson_feature sysprof)
		-Dlibthai=disabled
		-Dcairo=enabled
		$(meson_feature X xft)
		-Dfreetype=enabled
	)
	meson_src_configure
}

multilib_src_install_all() {
	if use examples; then
		dodoc -r examples
	fi

	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/Pango* "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}
