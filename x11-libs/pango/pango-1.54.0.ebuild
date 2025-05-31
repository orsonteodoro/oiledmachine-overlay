# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Add retpoline for the show password feature
CFLAGS_HARDENED_CI_SANITIZERS="asan"
CFLAGS_HARDENED_CI_SANITIZERS_CLANG_COMPAT="15" # F37
CFLAGS_HARDENED_FORTIFY_FIX_LEVEL=3
CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO CE DOS HO IO"

inherit cflags-hardened flag-o-matic gnome2-utils meson-multilib xdg

KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390
~sparc ~x86
"
SRC_URI="
https://download.gnome.org/sources/pango/$(ver_cut 1-2)/${P}.tar.xz
"

DESCRIPTION="Internationalized text layout and rendering library"
HOMEPAGE="https://pango.gnome.org/ https://gitlab.gnome.org/GNOME/pango"
LICENSE="LGPL-2+"
SLOT="0"
IUSE="
debug examples +introspection sysprof test X
ebuild_revision_13
"
RESTRICT="
	!test? (
		test
	)
"
RDEPEND="
	>=dev-libs/glib-2.62.2:2[${MULTILIB_USEDEP}]
	>=dev-libs/fribidi-1.0.6[${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-2.6.0:=[glib(+),introspection?,truetype(+),${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.13.0:1.0[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.12.10[X?,${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.5.0.1:2[${MULTILIB_USEDEP}]
	introspection? (
		>=dev-libs/gobject-introspection-0.9.5:=
	)
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXft-2.3.1-r1[${MULTILIB_USEDEP}]
		>=x11-libs/libXrender-0.9.8[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	sysprof? (
		>=dev-util/sysprof-capture-3.40.1:4[${MULTILIB_USEDEP}]
	)
	X? (
		x11-base/xorg-proto
	)
"
BDEPEND="
	dev-util/glib-utils
	sys-apps/help2man
	virtual/pkgconfig
	test? (
		media-fonts/cantarell
	)
"

src_prepare() {
	default
	xdg_environment_reset
	gnome2_environment_reset

	# Get rid of a win32 example.
	rm "examples/pangowin32tobmp.c" || die
}

multilib_src_configure() {
	if use debug; then
		append-cflags -DPANGO_ENABLE_DEBUG
	else
		append-cflags -DG_DISABLE_CAST_CHECKS
	fi

	cflags-hardened_append

	local emesonargs=(
		$(meson_feature sysprof)
		$(meson_feature X xft)
		$(meson_native_use_feature introspection)
		$(meson_use test build-testsuite)
		# Never use gi-docgen subproject \
		--wrap-mode nofallback
		-Dbuild-examples=false
		-Dcairo=enabled
		-Ddocumentation=false # we ship pregenerated docs
		-Dfontconfig=enabled
		-Dfreetype=enabled
		-Dlibthai=disabled
	)
	meson_src_configure
}

multilib_src_install_all() {
	if use examples; then
		dodoc -r "examples"
	fi

	insinto "/usr/share/gtk-doc/html"
	# This will install PangoXft API docs regardless of USE=-X, but this is intentional
	doins -r "${S}/docs/Pango"*
}

pkg_postinst() {
	xdg_pkg_postinst
	if has_version 'media-libs/freetype[-harfbuzz]' ; then
ewarn
ewarn "media-libs/freetype is installed without harfbuzz support. This may"
ewarn "lead to minor font rendering problems, see bug 712374."
ewarn
	fi
}
