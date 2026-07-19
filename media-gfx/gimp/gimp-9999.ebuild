# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Live is used because there is about 2 month lag time for security update.

CFLAGS_HARDENED_USE_CASES="ip-assets sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE DOS HO IO SO UAF"

LUA_COMPAT=( luajit )
PYTHON_COMPAT=( python3_{10..14} )
VALA_USE_DEPEND=vapigen

CHKL_TIMESTAMPS=(
	"app-accessibility/at-spi2-core-9999"
	"app-arch/bzip2-9999"
	"app-arch/libarchive-9999"
	"app-text/ghostscript-gpl-9999"
	"app-text/poppler-9999"
	"app-arch/xz-utils-9999"
	"dev-libs/glib-2.89.9999"
	"gnome-base/librsvg-9999"
	"media-libs/freetype-9999"
	"media-libs/harfbuzz-9999"
	"media-libs/lcms-9999"
	"media-libs/libheif-9999"
	"media-libs/libjpeg-turbo-9999"
	"media-libs/libjxl-9999"
	"media-libs/libpng-9999"
	"media-libs/libwebp-9999"
	"media-libs/libwmf-9999"
	"media-libs/openexr-9999"
	"media-libs/tiff-9999"
	"sys-libs/libunwind-9999"
	"x11-libs/cairo-9999"
	"x11-libs/libX11-9999"
	"x11-libs/libXcursor-9999"
)

inherit bash-completion-r1 branding chkl flag-o-matic lua-single meson python-single-r1 secure-version toolchain-funcs vala xdg

DESCRIPTION="GNU Image Manipulation Program"
HOMEPAGE="https://www.gimp.org/"

if [[ ${PV} == 9999 ]]; then
	FALLBACK_COMMIT="b4b2bd4be172ae002ca66301c0d5672391d3ad92"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/gimp.git"
	inherit git-r3

	MAJOR_VERSION="3"
else
	MY_PV="${PV/_rc/-RC}"
	MY_P="${PN}-${MY_PV}"
	SRC_URI="mirror://gimp/v$(ver_cut 1-2)/${MY_P}.tar.xz"
	S="${WORKDIR}/${MY_P}"

	MAJOR_VERSION="$(ver_cut 1)"

	# Dont keyword prereleases or unstable releases
	# https://gitlab.gnome.org/Infrastructure/gimp-web-devel/-/blob/testing/content/core/maintainer/versioning.md#software-version
	if ! [[ ${PV} =~ _rc ]] &&
		[[ $(( $(ver_cut 2) % 2 )) -eq 0 ]] &&
		[[ $(( $(ver_cut 3) % 2 )) -eq 0 ]]
	then
		KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
	fi
fi

LICENSE="GPL-3+ LGPL-3+"
SLOT="0/${MAJOR_VERSION}"

IUSE="
X aalib alsa bash-completion doc fits gnome heif javascript jpeg2k jpegxl lua mng openexr openmp postscript test udev unwind vala vector-icons wayland webp wmf xpm
ebuild_revision_1
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	lua? ( ${LUA_REQUIRED_USE} )
	xpm? ( X )
"

RESTRICT="!test? ( test )"

# See libgimp_deps_table in libgimp/meson.build for introspection dependencies, bug #969449
COMMON_DEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pycairo[${PYTHON_USEDEP}]
		>=dev-python/pygobject-3.0:=[${PYTHON_USEDEP}]
	')
	>=app-accessibility/at-spi2-core-${AT_SPI2_CORE_PV}:=
	>=app-arch/bzip2-${BZIP2_PV}:=
	>=app-arch/libarchive-${LIBARCHIVE_PV}:=
	>=app-arch/xz-utils-${XZ_UTILS_PV}:=
	app-text/iso-codes:=
	>=app-text/poppler-${POPPLER_PV}:=[cairo]
	>=app-text/poppler-data-0.4.9:=
	>=dev-libs/appstream-0.16.1:=
	>=dev-libs/glib-${GLIB_PV}:=[introspection]
	>=dev-libs/gobject-introspection-${GOBJECT_INTROSPECTION_PV}:=
	>=dev-libs/json-glib-${JSON_GLIB_PV}:=
	>=gnome-base/librsvg-${LIBRSVG_PV}:=
	>=media-gfx/exiv2-0.27.4:=
	media-gfx/mypaint-brushes:2.0=
	>=media-libs/fontconfig-${FONTCONFIG_PV}:=
	>=media-libs/freetype-${FREETYPE_PV}:=
	<media-libs/gexiv2-0.15.0:=[introspection]
	>=media-libs/gexiv2-0.14.0:=[introspection]
	>=media-libs/harfbuzz-${HARFBUZZ_PV}:=
	>=media-libs/lcms-${LCMS_PV}:=
	>=media-libs/libjpeg-turbo-${LIBJPEG_TURBO_PV}:=
	>=media-libs/libmypaint-1.5.0:=
	>=media-libs/libpng-${LIBPNG_PV}:=
	>=media-libs/tiff-${TIFF_PV}:=
	net-libs/glib-networking:=[ssl]
	>=virtual/zlib-${ZLIB_PV}:=
	>=x11-libs/cairo-${CAIRO_PV}:=[introspection(+),X?]
	>=x11-libs/gdk-pixbuf-${GDK_PIXBUF_PV}:=[introspection]
	>=x11-libs/gtk+-${GTK3_PV}:3=[introspection,wayland?,X?]
	>=x11-libs/pango-${PANGO_PV}:=[introspection,X?]
	aalib? ( media-libs/aalib:= )
	alsa? ( >=media-libs/alsa-lib-${ALSA_LIB_PV}:= )
	fits? ( sci-libs/cfitsio:= )
	heif? ( >=media-libs/libheif-${LIBHEIF_PV}:= )
	javascript? ( dev-libs/gjs:= )
	jpeg2k? ( >=media-libs/openjpeg-${OPENJPEG_PV}:= )
	jpegxl? ( >=media-libs/libjxl-${LIBJXL_PV}:= )
	lua? (
		${LUA_DEPS}
		$(lua_gen_cond_dep '
			dev-lua/lgi[${LUA_USEDEP}]
		')
	)
	mng? ( media-libs/libmng:= )
	openexr? ( >=media-libs/openexr-${OPENEXR_PV}:= )
	postscript? ( >=app-text/ghostscript-gpl-${GHOSTSCRIPT_GPL_PV}:= )
	udev? ( >=dev-libs/libgudev-167:= )
	unwind? ( >=sys-libs/libunwind-${LIBUNWIND_PV}:= )
	webp? ( >=media-libs/libwebp-${LIBWEBP_PV}:= )
	wmf? ( >=media-libs/libwmf-${LIBWMF_PV}:=[X?] )
	X? (
		>=x11-libs/libX11-${LIBX11_PV}:=
		>=x11-libs/libXcursor-${LIBXCURSOR_PV}:=
		>=x11-libs/libXext-${LIBXEXT_PV}:=
		>=x11-libs/libXfixes-${LIBXFIXES_PV}:=
		>=x11-libs/libXmu-1.1.4:=
	)
	xpm? ( x11-libs/libXpm:= )
"
if [[ ${PV} == 9999 ]]; then
	COMMON_DEPEND+="
		>=media-libs/babl-9999:=[introspection,lcms,vala?]
		>=media-libs/gegl-9999:=[cairo,introspection,lcms,vala?]
	"
else
	COMMON_DEPEND+="
		>=media-libs/babl-0.1.118:=[introspection,lcms,vala?]
		>=media-libs/gegl-0.4.66:=[cairo,introspection,lcms,vala?]
	"
fi

RDEPEND="
	${COMMON_DEPEND}
	x11-themes/hicolor-icon-theme:=
	gnome? ( gnome-base/gvfs:= )
"

DEPEND="${COMMON_DEPEND}"

BDEPEND="
	>=dev-lang/perl-${PERL_PV}
	>=dev-libs/libxslt-${LIBXSLT_PV}
	>=dev-util/gdbus-codegen-2.80.5-r1
	>=sys-devel/gettext-0.21
	virtual/pkgconfig
	bash-completion? (
		app-shells/bash-completion
		>=app-shells/bash-${BASH_PV}
	)
	doc? (
		>=dev-libs/gobject-introspection-${GOBJECT_INTROSPECTION_PV}[doctool]
		dev-util/gi-docgen
	)
	vala? ( $(vala_depend) )
	vector-icons? ( x11-misc/shared-mime-info )
"
#	X? ( test? (
#		sys-apps/dbus
#		x11-misc/xvfb-run
#	) )

DOCS=( "AUTHORS" "NEWS" "README" "README.i18n" )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		use openmp && tc-check-openmp

		# bug #969468
		local locales="$(locale -a)"
		if ! has "en_US.utf8" ${locales} && ! has "en_US.UTF-8" ${locales}; then
			# portage splits and unset LC_ALL. Cannot rely on that
			if [[ "${LANG}" != "C" ]] && [[ "${LANG}" != "POSIX" ]] && [[ "${LANG}" == "${LANG#C\.}" ]]; then
				# Set LC_ALL to avoid locales breaking due to the profile setting LC_MESSAGES=C
				# and portage itself setting LC_COLLATE=C
				einfo "Setting LC_ALL=${LANG} based on LANG because en_US.UTF-8 isn't available, bug #968468"
				export LC_ALL="${LANG}"
			else
				eerror "Cannot use LANG=${LANG} as it cannot be C or POSIX"
				die "en_US.UTF-8 isn't available and cannot fallback to user locale, bug #969468"
			fi
		fi
	fi

	python-single-r1_pkg_setup
	use lua && lua-single_pkg_setup

	if [[ ${PV} == 9999 ]]; then
		if has_version ">=media-libs/babl-9999" || has_version ">=media-libs/gegl-9999"; then
			ewarn "Please make sure to rebuild media-libs/babl-9999 and media-libs/gegl-9999 packages"
			ewarn "before building media-gfx/gimp-9999 to have their latest master branch versions."
		fi
	fi
}

src_prepare() {
	default

	# Fix Gimp  and GimpUI devel doc installation paths
	sed -e "s/'doc'/'gtk-doc'/" -i devel-docs/reference/gimp{,-ui}/meson.build || die

	# Fix pygimp.interp python implementation path.
	# Meson @PYTHON_PATH@ use sandbox path e.g.:
	# '/var/tmp/portage/media-gfx/gimp-2.99.12/temp/python3.10/bin/python3'
	sed -e 's/@PYTHON_EXE@/'${EPYTHON}'/' -i plug-ins/python/pygimp.interp.in || die

	# Set proper intallation path of documentation logo
	sed -e "s/'gimp-' + gimp_api_version/'gimp-${PVR}'/" -i gimp-data/images/logo/meson.build || die

	# Force disable x11_target if USE="-X" is setup. See bug #943164 for additional info
	if use !X; then
		sed -e 's/x11_target = /x11_target = false #/' -i meson.build || die
	fi

	# Disable automagic pandoc use that isn't relevant for a package build
	sed -e '/pandoc/ s/ = .*/ = disabler()/' -i docs/meson.build || die
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append

	# Defang automagic dependencies, bug #943164
	use wayland || append-cppflags -DGENTOO_GTK_HIDE_WAYLAND
	use X || append-cppflags -DGENTOO_GTK_HIDE_X11

	tc-export NM READELF

	use vala && vala_setup

	local emesonargs=(
		-Denable-default-bin=enabled

		-Dcheck-update=no
		-Ddebug-self-in-build=false
		-Denable-multiproc=true
		-Dappdata-test=disabled
		-Dbug-report-url="${BRANDING_OS_BUG_REPORT_URL}"
		-Dilbm=disabled
		-Dlibbacktrace=false
		$(meson_feature aalib aa)
		$(meson_feature alsa)
		$(meson_feature bash-completion)
		$(meson_feature doc gi-docgen)
		$(meson_feature fits)
		$(meson_feature heif)
		$(meson_feature javascript)
		$(meson_feature jpeg2k jpeg2000)
		$(meson_feature jpegxl jpeg-xl)
		$(meson_feature mng)
		$(meson_feature openexr)
		$(meson_feature openmp)
		$(meson_feature postscript ghostscript)
		# https://gitlab.gnome.org/GNOME/gimp/-/issues/15763
		-Dheadless-tests=disabled
		#$(usex X $(meson_feature test headless-tests) -Dheadless-tests=disabled )
		$(meson_feature udev gudev)
		$(meson_feature vala)
		$(meson_feature webp)
		$(meson_feature wmf)
		$(meson_feature X xcursor)
		$(meson_feature xpm)
		$(meson_use lua)
		$(meson_use unwind libunwind)
		$(meson_use vector-icons)
	)

	meson_src_configure
}

src_compile() {
	export XDG_DATA_DIRS="${EPREFIX}"/usr/share  # bug 587004
	meson_src_compile
}

# bug #664938
_rename_plugins() {
	einfo 'Renaming plug-ins to not collide with pre-2.10.6 file layout (bug #664938)...'
	local prename=gimp-org-
	(
		cd "${ED}"/usr/$(get_libdir)/gimp/3.0/plug-ins || exit 1
		for plugin_slash in $(ls -d1 */); do
			plugin=${plugin_slash%/}
			if [[ -f ${plugin}/${plugin} ]]; then
				# NOTE: Folder and file name need to match for Gimp to load that plug-in
				#       so "file-svg/file-svg" becomes "${prename}file-svg/${prename}file-svg"
				mv ${plugin}/{,${prename}}${plugin} || exit 1
				mv {,${prename}}${plugin} || exit 1
			fi
		done
	)
}

src_test() {
	local -x LD_LIBRARY_PATH="${BUILD_DIR}/libgimp:${LD_LIBRARY_PATH}"

	# Try hard to avoid system installed gimp causing issues
	local -x GIMP3_DIRECTORY="${BUILD_DIR}/"
	local -x GIMP3_PLUGINDIR="${BUILD_DIR}/plug-ins/"
	local -x GIMP3_SYSCONFDIR="${BUILD_DIR}/etc/"

	# Flakyness is possible
	meson_src_test -j1
}

src_install() {
	meson_src_install

	python_optimize "${ED}/usr/$(get_libdir)/gimp"
	python_fix_shebang "${ED}/usr/$(get_libdir)/gimp"

	# Create symlinks for Gimp exec in /usr/bin
	# gimp-$(ver_cut 1-2) -> gimp-$(ver_cut 1) -> gimp
	dosym "${ESYSROOT}"/usr/bin/gimp-${MAJOR_VERSION} /usr/bin/gimp
	dosym "${ESYSROOT}"/usr/bin/gimp-console-${MAJOR_VERSION} /usr/bin/gimp-console
	dosym "${ESYSROOT}"/usr/bin/gimp-test-clipboard-${MAJOR_VERSION} /usr/bin/gimp-test-clipboard
	dosym "${ESYSROOT}"/usr/bin/gimptool-${MAJOR_VERSION} /usr/bin/gimptool

	if use bash-completion; then
		bashcomp_alias gimp-3.2 gimp{,-3} gimp-console{,-3,-3.2}
	fi

	_rename_plugins || die
}
