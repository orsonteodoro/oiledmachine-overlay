# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# We use the *live* unstable.  The stable is for binary packages.
# Plus the unstable is ahead 1 month of security fixes.
#   Stable 4.22.4: Apr 29, 2026 - Security lag time is 2 1/2 months
# Unstable 4.23.1: May 29, 2026 - Security lag time is 1 1/2 months
#   Live unstable: Jun 16, 2026 - Security lag time is less than 1 day

# ASan does not work with f16c and introspection
CFLAGS_HARDENED_ASSEMBLERS="inline"
CFLAGS_HARDENED_CI_SANITIZERS="asan"
CFLAGS_HARDENED_CI_SANITIZERS_CLANG_COMPAT="17" # F39
CFLAGS_HARDENED_LANGS="asm c-lang"
CFLAGS_HARDENED_SANITIZERS_DISABLE=1 # Disabled because introspection needs review.  It will break apps with GTK Python bindings.
CFLAGS_HARDENED_USE_CASES="copy-paste-password security-critical sensitive-data untrusted-data" # Harden password widget with retpoline
CFLAGS_HARDENED_VULNERABILITY_HISTORY="DOS HO IO PE"

PYTHON_COMPAT=( python3_{10..14} )

FALLBACK_COMMIT="9cf50da891ed748135513a908b080ff06068bd19"

CHKL_TIMESTAMPS=(
	"dev-libs/fribidi-9999"
	"dev-libs/glib-2.89.9999"
	"dev-libs/wayland-9999"
	"net-print/cups-9999"
	"gnome-base/librsvg-9999"
	"media-libs/harfbuzz-9999"
	"media-libs/libjpeg-turbo-9999"
	"media-libs/libpng-9999"
	"media-libs/mesa-9999"
	"media-libs/tiff-9999"
	"media-libs/vulkan-loader-9999"
	"x11-libs/cairo-9999"
	"x11-libs/libdrm-9999"
	"x11-libs/libX11-9999"
	"x11-libs/libXcursor-9999"
	"x11-libs/libxkbcommon-9999"
	"x11-libs/pango-9999"
)

inherit cflags-hardened chkl flag-o-matic gnome.org gnome2-utils meson optfeature python-any-r1 secure-version toolchain-funcs virtualx xdg

DESCRIPTION="GTK is a multi-platform toolkit for creating graphical user interfaces"
HOMEPAGE="https://www.gtk.org/ https://gitlab.gnome.org/GNOME/gtk/"

LICENSE="LGPL-2+"
SLOT="4"
REQUIRED_USE="
	|| ( aqua wayland X )
	gtk-doc? ( introspection )
	test? ( introspection )
"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE+="
aqua broadway cloudproviders colord cups examples gstreamer gtk-doc +introspection sysprof test vulkan wayland +X cpu_flags_x86_f16c
ebuild_revision_1
"

# librsvg for svg icons and "!8541 Use librsvg for symbolics that we
#     can't parse ourselves" (formerly a PDEPEND to avoid circular dep
#     on wd40 profiles with librsvg[tools]), bug #547710
# NOTE: Support was added to build against both cups2 and cups3
COMMON_DEPEND="
	~dev-libs/glib-${GLIB_PV}:=
	>=x11-libs/cairo-${CAIRO_PV}:=[aqua?,glib,svg(+),X?]
	>=x11-libs/pango-${PANGO_PV}:=[introspection?]
	>=dev-libs/fribidi-${FRIBIDI_PV}:=
	>=media-libs/harfbuzz-${HARFBUZZ_PV}:=
	>=x11-libs/gdk-pixbuf-${GDK_PIXBUF_PV}:=[introspection?]
	>=media-libs/libpng-${LIBPNG_PV}:=
	>=media-libs/tiff-${TIFF_PV}:=
	>=media-libs/libjpeg-turbo-${LIBJPEG_TURBO_PV}:=
	>=gnome-base/librsvg-${LIBRSVG_PV}:=
	>=media-libs/libepoxy-1.4:=[egl(+),X(+)?]
	>=media-libs/graphene-1.10.0:=[introspection?]
	app-text/iso-codes:=
	x11-misc/shared-mime-info:=

	cloudproviders? ( >=net-libs/libcloudproviders-${LIBCLOUDPROVIDERS_PV}:= )
	colord? ( >=x11-misc/colord-${COLORD_PV}:= )
	cups? ( >=net-print/cups-${CUPS_PV}:= )
	examples? ( >=gnome-base/librsvg-${LIBRSVG_PV}:= )
	elibc_glibc? (
		>=sys-libs/glibc-${GLIBC_PV}:=
	)
	elibc_musl? (
		>=sys-libs/musl-${MUSL_PV}:=
	)
	gstreamer? (
		>=media-libs/gstreamer-${GSTREAMER_PV}:=
		>=media-libs/gst-plugins-bad-${GSTREAMER_PV}:=
		|| (
			>=media-libs/gst-plugins-base-${GSTREAMER_PV}[gles2]
			>=media-libs/gst-plugins-base-${GSTREAMER_PV}[opengl]
		)
	)
	introspection? ( >=dev-libs/gobject-introspection-${GOBJECT_INTROSPECTION_PV}:= )
	vulkan? (
		>=media-libs/vulkan-loader-${VULKAN_LOADER_PV}:=[wayland?,X?]
		>=media-libs/mesa-${MESA_PV}:=[vulkan]
		)
	wayland? (
		>=dev-libs/wayland-${WAYLAND_PV}:=
		>=dev-libs/wayland-protocols-1.44:=
		>=media-libs/mesa-${MESA_PV}:=[wayland]
		>=x11-libs/libxkbcommon-${LIBXKBCOMMON_PV}:=
	)
	X? (
		>=media-libs/fontconfig-${FONTCONFIG_PV}:=
		>=media-libs/mesa-${MESA_PV}:=[X(+)]
		>=x11-libs/libX11-${LIBX11_PV}:=
		>=x11-libs/libXi-${LIBXI_PV}:=
		>=x11-libs/libXext-${LIBXEXT_PV}:=
		>=x11-libs/libXrandr-${LIBXRANDR_PV}:=
		>=x11-libs/libXcursor-${LIBXCURSOR_PV}:=
		>=x11-libs/libXfixes-${LIBXFIXES_PV}:=
		x11-libs/libXdamage:=
		>=x11-libs/libXinerama-${LIBXINERAMA_PV}:=
	)
"
DEPEND="${COMMON_DEPEND}
	kernel_linux? (
		>=x11-libs/libdrm-${LIBDRM_PV}:=
		sys-kernel/linux-headers:=
	)
	sysprof? ( >=dev-util/sysprof-capture-3.40.1:= )
	X? ( x11-base/xorg-proto:= )
"
RDEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-update-icon-cache-3:=
"
PDEPEND="
	>=x11-themes/adwaita-icon-theme-3.14
"
BDEPEND="
	>=dev-build/meson-1.5.0
	introspection? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-python/pygobject:3[${PYTHON_USEDEP}]
		')
	)
	dev-python/docutils
	~dev-libs/glib-${GLIB_PV}
	>=dev-util/gdbus-codegen-2.80.5-r1
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
	gtk-doc? ( dev-util/gi-docgen )
	vulkan? ( media-libs/shaderc )
	wayland? (
		>=dev-util/wayland-scanner-1.24.0
	)
	test? (
		~dev-libs/glib-${GLIB_PV}
		media-fonts/cantarell
		wayland? ( dev-libs/weston[headless] )
	)
"

PATCHES=(
	# Gentoo-specific patch to add a "poison" macro support, allowing other ebuilds
	# with USE="-wayland -X" to trick gtk into claiming that it wasn't built with
	# such support.
	# https://bugs.gentoo.org/624960
	"${FILESDIR}"/0001-gdk-add-a-poison-macro-to-hide-GDK_WINDOWING_ge_4.18.5.patch
)

python_check_deps() {
	python_has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]" || return
}

pkg_setup() {
	use introspection && python-any-r1_pkg_setup
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
		local expected_pv=$(ver_cut "1-2" "${PV}")
		if ! ( grep "version:" "${S}/meson.build" | head -n 1 | grep -q "${expected_pv}" ) ; then
			local actual_pv=$(grep "version:" "${S}/meson.build" \
				| head -n 1 \
				| cut -f 2 -d "'" \
				| cut -f 1-2 -d ".")
eerror "QA:  Bump slot or change PV to ${actual_pv}.9999"
eerror "QA:  Expected PV:  ${expected_pv}"
eerror "QA:  Actual PV:  ${actual_pv}"
			die
		fi
	else
		unpack ${A}
	fi
}

src_prepare() {
	default
	xdg_environment_reset

	# Nothing should use gtk4-update-icon-cache and an unversioned one is shipped by dev-util/gtk-update-icon-cache
	sed -i \
		-e '/gtk4-update-icon-cache/d' \
		docs/reference/gtk/meson.build \
		tools/meson.build \
		|| die

	# The border-image-excess-size.ui test is known to fail on big-endian platforms
	# See https://gitlab.gnome.org/GNOME/gtk/-/issues/5904
	if [[ $(tc-endian) == big ]]; then
		sed -i \
			-e "/border-image-excess-size.ui/d" \
			-e "/^xfails =/a 'border-image-excess-size.ui'," \
			testsuite/reftests/meson.build || die
	fi
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append

	use x86 && append-flags -DDISABLE_X64=1 #943705 https://gitlab.gnome.org/GNOME/gtk/-/issues/4173

	local emesonargs=(
		# GDK backends
		$(meson_use X x11-backend)
		$(meson_use wayland wayland-backend)
		$(meson_use broadway broadway-backend)
		-Dwin32-backend=false
		-Dandroid-backend=false
		$(meson_use aqua macos-backend)

		# Media backends
		$(meson_feature gstreamer media-gstreamer)

		# Print backends
		-Dprint-cpdb=disabled
		$(meson_feature cups print-cups)

		# Optional dependencies
		$(meson_feature vulkan)
		$(meson_feature cloudproviders)
		$(meson_feature sysprof)
		-Dtracker=disabled  # tracker3 is not packaged in Gentoo yet
		$(meson_feature colord)
		# Expected to fail with GCC < 11
		# See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=71993
		$(meson_feature cpu_flags_x86_f16c f16c)
		-Dandroid-runtime=disabled
		# Introspection
		$(meson_feature introspection)

		# Documentation
		$(meson_use gtk-doc documentation)
		-Dscreenshots=false
		-Dman-pages=true

		# Demos, examples, and tests
		-Dprofile=default
		$(meson_use examples build-demos)
		$(meson_use test build-testsuite)
		$(meson_use examples build-examples)
		-Dbuild-tests=false
	)
	meson_src_configure
}

src_test() {
	"${BROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/gtk" || die

	addwrite /dev/dri

	# Note that skipping gsk-compare entirely means we do run *far*
	# fewer tests, but a reliable testsuite for us is more important
	# than absolute-maximum coverage if we can't trust the results and
	# dismiss any failures as "probably font related" and so on.
	if use X; then
		einfo "Running tests under X"
		GSETTINGS_SCHEMA_DIR="${S}/gtk" virtx meson_src_test --timeout-multiplier=130 \
			--setup=x11 \
			--no-suite=failing \
			--no-suite=x11_failing \
			--no-suite=flaky \
			--no-suite=headless \
			--no-suite=gsk-compare \
			--no-suite=gsk-compare-broadway \
			--no-suite=needs-udmabuf \
			--no-suite=pango
	fi

	if use wayland; then
		einfo "Running tests under Weston"

		export XDG_RUNTIME_DIR="$(mktemp -p $(pwd) -d xdg-runtime-XXXXXX)"

		weston --backend=headless-backend.so --socket=wayland-5 --idle-time=0 &
		compositor=$!
		export WAYLAND_DISPLAY=wayland-5

		GSETTINGS_SCHEMA_DIR="${S}/gtk" meson_src_test --timeout-multiplier=130 \
			--setup=wayland \
			--no-suite=failing \
			--no-suite=wayland_failing \
			--no-suite=flaky \
			--no-suite=headless \
			--no-suite=gsk-compare \
			--no-suite=gsk-compare-broadway \
			--no-suite=needs-udmabuf

		exit_code=$?
		kill ${compositor}
	fi
}

src_install() {
	local i src

	meson_src_install

	if use gtk-doc; then
		mkdir -p "${ED}/usr/share/gtk-doc/html" || die

		for dir in gdk4 gtk4 gsk4; do
			src="${ED}/usr/share/doc/${dir}"
			test -d "${src}" || die "Expected documentation directory ${src} not found"
			mv -v "${src}" "${ED}/usr/share/gtk-doc/html" || die
		done

		if use X; then
			src="${ED}/usr/share/doc/gdk4-x11"
			test -d "${src}" || die "Expected X11 documentation ${src} not found"
			mv -v "${src}" "${ED}/usr/share/gtk-doc/html" || die
		fi

		if use wayland; then
			src="${ED}/usr/share/doc/gdk4-wayland"
			test -d "${src}" || die "Expected Wayland documentation ${src} not found"
			mv -v "${src}" "${ED}/usr/share/gtk-doc/html" || die
		fi
	fi
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_schemas_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	if ! has_version "app-text/evince"; then
		elog "Please install app-text/evince for print preview functionality."
		elog "Alternatively, check \"gtk-print-preview-command\" documentation and"
		elog "add it to your settings.ini file."
	fi

	if use examples ; then
		optfeature "syntax highlighting in gtk4-demo" app-text/highlight
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
