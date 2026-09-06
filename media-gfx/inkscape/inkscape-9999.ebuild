# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U26

# Remember to check the release notes for a 'Important Changes for Packagers'
# section, e.g. https://inkscape.org/doc/release_notes/1.4/Inkscape_1.4.html#Important_Changes_for_Packagers.
# For requirements, see https://gitlab.com/inkscape/inkscape/-/blob/master/CMakeScripts/DefineDependsandFlags.cmake
# See also https://gitlab.com/inkscape/extensions

CXX_STANDARD=20
CFLAGS_HARDENED_USE_CASES="ip-assets untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO CE FS OOBR OOBW"
PYTHON_COMPAT=( python3_{10..14} )
PYTHON_REQ_USE="xml(+)"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX20[@]}" # 13..16
)
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)"

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX20[@]/llvm_slot_}" # 21, 22
)
LIBCXX_USEDEP_LTS="llvm_slot_skip(+)"

CHKL_TIMESTAMPS=(
	"app-text/ghostscript-gpl-9999"
	"app-text/poppler-9999"
	"dev-libs/double-conversion-9999"
	"dev-libs/glib-2.89.9999"
	"dev-libs/icu-79.0.9999"
	"dev-libs/jemalloc-9999"
	"dev-libs/libxml2-9999"
	"gui-libs/gtk-4.23.9999"
	"media-gfx/imagemagick-9999"
	"media-libs/fontconfig-9999"
	"media-libs/freetype-9999"
	"media-libs/harfbuzz-9999"
	"media-libs/lcms-9999"
	"media-libs/libjpeg-turbo-9999"
	"sys-libs/readline-9999"
	"x11-libs/libX11-9999"
)

inherit cflags-hardened chkl cmake flag-o-matic libcxx-slot libstdcxx-slot optfeature secure-version toolchain-funcs xdg python-single-r1

MY_P="${P/_/}"
DESCRIPTION="SVG based generic vector-drawing program"
HOMEPAGE="https://inkscape.org/ https://gitlab.com/inkscape/inkscape/"

if [[ ${PV} = 9999* ]]; then
	FALLBACK_COMMIT="4ecab4da64eeccfb884e7eb45e717b13847f66de"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://gitlab.com/inkscape/inkscape.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://media.inkscape.org/dl/resources/file/${MY_P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
# -exif based on CI/CD
# -graphicsmagick based on CI/CD
# -imagemagick based on CI/CD
IUSE+="
+cdr -exif -graphicsmagick -imagemagick -jemalloc jpeg openmp postscript +readline +sourceview +spell +svg2 test +visio wayland +wpg X
ebuild_revision_10
"
# The oiledmachine-overlay uses imagemagick 7 (live) but the project needs 6 or earlier, so it is disabled.
REQUIRED_USE="
${PYTHON_REQUIRED_USE}
!imagemagick
"
# Lots of test failures which need investigating, bug #871621
RESTRICT="!test? ( test ) test"

BDEPEND="
	>=dev-build/cmake-3.24.0
	>=sys-devel/gettext-0.17
	dev-util/glib-utils
	virtual/pkgconfig
	test? (
		virtual/imagemagick-tools
	)
"
COMMON_DEPEND="${PYTHON_DEPS}
	>=app-text/poppler-${POPPLER_PV}:=[cairo,lcms]
	>=dev-cpp/cairomm-1.18.0:1.16=[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
	>=dev-cpp/glibmm-${GLIBMM_PV}:2.68=[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
	>=dev-cpp/gtkmm-4.20.0:4.0=[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
	>=dev-cpp/pangomm-2.56.1:2.48=[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
	>=dev-libs/boehm-gc-${BOEHM_GC_PV}:=
	>=dev-libs/boost-1.19.0:=[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS},stacktrace(-)]
	>=dev-libs/double-conversion-${DOUBLE_CONVERSION_PV}:=
	>=dev-libs/glib-${GLIB_PV}:=
	>=dev-libs/icu-${ICU_PV}:=
	>=dev-libs/libsigc++-3.6:3=[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
	>=dev-libs/libxml2-${LIBXML2_PV}:=
	>=dev-libs/libxslt-${LIBXSLT_PV}:=
	>=dev-libs/popt-${POPT_PV}:=
	>=gui-libs/gtk-${GTK4_PV}:4=[X?,wayland?]
	>=media-libs/fontconfig-${FONTCONFIG_PV}:=
	>=media-libs/freetype-${FREETYPE_PV}:=
	>=media-libs/graphene-1.0:=
	>=media-libs/harfbuzz-${HARFBUZZ_PV}:=
	>=media-libs/lcms-${LCMS_PV}:=
	>=media-libs/libepoxy-1.5.10:=
	>=media-libs/libpng-${LIBPNG_PV}:=
	>=sci-libs/gsl-${GSL_PV}:=
	>=virtual/zlib-${ZLIB_PV}:=
	>=x11-libs/pango-${PANGO_PV}:=
	>=x11-libs/gdk-pixbuf-${GDK_PIXBUF_PV}:=
	dev-cpp/mm-common:=
	media-gfx/potrace:=
	media-libs/gst-plugins-bad:=
	media-libs/shaderc:=
	virtual/libiconv:*
	virtual/libintl:*
	$(python_gen_cond_dep '
		dev-python/appdirs[${PYTHON_USEDEP}]
		dev-python/cachecontrol[${PYTHON_USEDEP}]
		dev-python/cssselect[${PYTHON_USEDEP}]
		dev-python/filelock[${PYTHON_USEDEP}]
		dev-python/lockfile[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/tinycss2[${PYTHON_USEDEP}]
		virtual/pillow:=[${PYTHON_USEDEP},jpeg?,tiff,webp]
		media-gfx/scour:=[${PYTHON_USEDEP}]
	')
	jemalloc? (
		>=dev-libs/jemalloc-${JEMALLOC_PV}:=
	)
	cdr? (
		>=dev-libs/librevenge-0.0.5:=
		>=media-libs/libcdr-0.1:=
	)
	exif? (
		>=media-libs/libexif-${LIBEXIF_PV}:=
	)
	imagemagick? (
		!graphicsmagick? (
			>=media-gfx/imagemagick-${IMAGEMAGICK_PV}:=[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS},cxx]
			|| (
				=media-gfx/imagemagick-6*[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS},cxx]
			)
		)
		graphicsmagick? (
			>=media-gfx/graphicsmagick-${GRAPHICSMAGICK_PV}:=[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS},cxx]
		)
	)
	jpeg? (
		>=media-libs/libjpeg-turbo-${LIBJPEG_TURBO_PV}:=
	)
	readline? (
		>=sys-libs/readline-${READLINE_PV}:=
	)
	sourceview? (
		>=x11-libs/gtksourceview-5.18.0:5=
	)
	spell? (
		>=app-text/libspelling-0.4.9:=
	)
	visio? (
		>=dev-libs/librevenge-0.0.5:=
		>=media-libs/libvisio-0.1:=
	)
	wpg? (
		>=app-text/libwpg-0.3:=
		>=dev-libs/librevenge-0.0.5:=
	)
	X? (
		>=x11-libs/libX11-${LIBX11_PV}:=
	)
"
# These only use executables provided by these packages
# See share/extensions for more details. inkscape can tell you to
# install these so we could of course just not depend on those and rely
# on that.
RDEPEND="${COMMON_DEPEND}
	$(python_gen_cond_dep '
		virtual/numpy:=[${PYTHON_USEDEP}]
	')
"
DEPEND="${COMMON_DEPEND}
	test? (
		dev-cpp/gtest:=
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.4-respect-EPYTHON.patch # bug 924747
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	python-single-r1_pkg_setup
}

src_unpack() {
	if [[ ${PV} = 9999* ]]; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_src_unpack
	else
		default
	fi
	[[ -d "${S}" ]] || mv -v "${WORKDIR}/${P/_/-}_202"?-??-* "${S}" || die
}

src_prepare() {
	rm -vr src/3rdparty/2geom/tests/dependent-project || die # unused, causing bug #964016
	cmake_src_prepare
	sed -i "/install.*COPYING/d" CMakeScripts/ConfigCPack.cmake || die
	# bug #924747
	sed -i -e "s:@GENTOO_PYTHON_INTERP@:${EPYTHON}:" src/extension/implementation/script.cpp || die
}

src_configure() {
	chkl_check_many_timestamps

	# ODR violation (https://gitlab.com/inkscape/lib2geom/-/issues/71, bug #859628)
	filter-lto
	# Aliasing unsafe (bug #310393)
	append-flags -fno-strict-aliasing

	use wayland || append-flags -DGENTOO_GTK_HIDE_WAYLAND

	cflags-hardened_append

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DENABLE_LCMS=ON
		-DENABLE_POPPLER=ON
		-DENABLE_POPPLER_CAIRO=ON
		-DBUILD_TESTING=$(usex test)
		-DWITH_GNU_READLINE=$(usex readline)
		-DWITH_GRAPHICS_MAGICK=$(usex graphicsmagick $(usex imagemagick)) # both must be enabled to use GraphicsMagick
		-DWITH_GSOURCEVIEW=$(usex sourceview)
		-DWITH_IMAGE_MAGICK=$(usex imagemagick $(usex !graphicsmagick)) # requires ImageMagick 6, only IM must be enabled
		-DWITH_INTERNAL_2GEOM=ON
		-DWITH_JEMALLOC=$(usex jemalloc)
		-DWITH_LIBCDR=$(usex cdr)
		-DWITH_LIBSPELLING=$(usex spell)
		-DWITH_LIBVISIO=$(usex visio)
		-DWITH_LIBWPG=$(usex wpg)
		#-DWITH_LPETOOL   # Compile with LPE Tool and experimental LPEs enabled
		-DWITH_NLS=ON
		-DWITH_OPENMP=$(usex openmp)
		-DWITH_PROFILING=OFF
		-DWITH_SVG2=$(usex svg2)
		-DWITH_X11=$(usex X)
	)

	cmake_src_configure
}

src_test() {
	CMAKE_SKIP_TESTS=(
		# render_text*: needs patched Cairo / maybe upstream changes
		# not yet in a release.
		# test_lpe/test_lpe64: precision differences b/c of new GCC?
		# cli_export-png-color-mode-gray-8_png_check_output: ditto?
		render_test-use
		render_test-glyph-y-pos
		render_text-glyphs-combining
		render_text-glyphs-vertical
		render_test-rtl-vertical
		test_lpe
		test_lpe64
		cli_export-png-color-mode-gray-8_png_check_output
	)

	# bug #871621
	cmake_src_compile tests
	cmake_src_test -j1
}

src_install() {
	cmake_src_install

	find "${ED}" -type f -name "*.la" -delete || die
	find "${ED}"/usr/share/man -type f -maxdepth 3 -name '*.bz2' -exec bzip2 -d {} \; || die
	find "${ED}"/usr/share/man -type f -maxdepth 3 -name '*.gz' -exec gzip -d {} \; || die

	local extdir="${ED}"/usr/share/${PN}/extensions
	if [[ -e "${extdir}" ]] && [[ -n $(find "${extdir}" -mindepth 1) ]]; then
		python_fix_shebang "${ED}"/usr/share/${PN}/extensions
		python_optimize "${ED}"/usr/share/${PN}/extensions
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	# In https://gitlab.com/inkscape/extensions there are .inx metadata files for extension summaries.
	# The one with external dependences will have a dependency type="executable" in .inx.
	optfeature_header "Install optional extension dependency packages:"
	optfeature "export Gimp's XCF file format" "media-gfx/gimp"
	optfeature "export PDF documents" "app-office/scribus"
	optfeature "import XFIG graphics files" "media-gfx/fig2dev"
	optfeature "load Postscript/EPS Files" "app-text/ghostscript-gpl"
	optfeature "LaTeX formula support" "app-text/texlive"
	optfeature "PNG optimized output" "media-gfx/optipng"
	optfeature "PS/EPS importer for determining page orientation from text direction" "app-office/scribus"
	optfeature "Typst math formula support" "app-text/typst"
}
