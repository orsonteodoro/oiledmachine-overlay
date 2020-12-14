# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit autotools eutils multilib-minimal python-single-r1 toolchain-funcs

DESCRIPTION="VIPS Image Processing Library"
HOMEPAGE="https://jcupitt.github.io/libvips/"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
IUSE="+analyze cairo cxx debug +doc exif fftw fits giflib graphicsmagick gsf \
+hdr heif imagemagick imagequant jpeg lcms matio -minimal openexr openslide orc \
pangoft2 png poppler +ppm python static-libs svg tiff webp zlib"
SRC_URI="https://github.com/libvips/libvips/archive/v${PV}.tar.gz -> ${P}.tar.gz"
# See also https://github.com/libvips/libvips/blob/v8.10.2/.travis.yml
# libnifti missing
RDEPEND="cairo? ( >=x11-libs/cairo-1.2[${MULTILIB_USEDEP}] )
	 debug? ( >=dev-libs/dmalloc-5.5.2 )
	 >=dev-libs/glib-2.6.2:2[${MULTILIB_USEDEP}]
	 >=dev-libs/expat-2.2.5[${MULTILIB_USEDEP}]
	 >=dev-libs/gobject-introspection-1.56.1[${PYTHON_SINGLE_USEDEP}]
	 >=dev-libs/libffi-3.2.1[${MULTILIB_USEDEP}]
	 >=sys-libs/libomp-10.0.0[${MULTILIB_USEDEP}]
	 exif? ( >=media-libs/libexif-0.6.21[${MULTILIB_USEDEP}] )
	 fftw? ( >=sci-libs/fftw-3.3.7:3.0=[${MULTILIB_USEDEP}] )
	 fits? ( >=sci-libs/cfitsio-3.430[${MULTILIB_USEDEP}] )
	 giflib? ( >=media-libs/giflib-5.1.4[${MULTILIB_USEDEP}] )
	 gsf? ( >=gnome-extra/libgsf-1.14.41 )
	 heif? ( >=media-libs/libde265-1.0.2[${MULTILIB_USEDEP}]
		 >=media-libs/libheif-1.1.0[${MULTILIB_USEDEP}] )
	 imagemagick? (
		graphicsmagick? ( >=media-gfx/graphicsmagick-1.3.28 )
		!graphicsmagick? ( >=media-gfx/imagemagick-6.9.7.4 )
	 )
	 imagequant? ( media-gfx/libimagequant )
	 jpeg? (
		|| ( virtual/jpeg:0=[${MULTILIB_USEDEP}]
			>=media-libs/libjpeg-turbo-1.5.2[${MULTILIB_USEDEP}]
		)
	 )
	 lcms? ( >=media-libs/lcms-2.9[${MULTILIB_USEDEP}] )
	 matio? ( >=sci-libs/matio-1.5.11[${MULTILIB_USEDEP}] )
	 openexr? ( >=media-libs/openexr-2.2.0[${MULTILIB_USEDEP}] )
	 openslide? ( >=media-libs/openslide-3.4.1[${MULTILIB_USEDEP}] )
	 orc? ( >=dev-lang/orc-0.4[${MULTILIB_USEDEP}] )
	 png? ( >=media-libs/libpng-1.6.34:0=[${MULTILIB_USEDEP}] )
	 poppler? ( >=app-text/poppler-0.62.0[cairo,introspection] )
	 python? ( ${PYTHON_DEPS} )
	 >=sci-libs/gsl-2.4
	 svg? ( >=gnome-base/librsvg-2.40.20[${MULTILIB_USEDEP}] )
	 tiff? ( >=media-libs/tiff-4.0.9:0=[${MULTILIB_USEDEP}] )
	 webp? ( >=media-libs/libwebp-0.6.1[${MULTILIB_USEDEP}] )
	 pangoft2? ( >=x11-libs/pango-1.40.14[${MULTILIB_USEDEP}] )
	 zlib? ( >=sys-libs/zlib-0.4[${MULTILIB_USEDEP}] )"
DEPEND="dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1.27 )
	|| (
		>=sys-devel/gcc-10
		>=sys-devel/clang-10
	)
	${RDEPEND}"
REQUIRED_USE="doc
	      imagequant? ( png )
	      poppler? ( cairo )
	      python? ( ${PYTHON_REQUIRED_USE} )
	      svg? ( cairo )"
RESTRICT="mirror"
SLOT="1/${PV}"
S="${WORKDIR}/libvips-${PV}"
DOCS=( AUTHORS ChangeLog NEWS README.md THANKS )

pkg_setup() {
	use python && python-single-r1_pkg_setup

	CC=$(tc-getCC)
	CXX=$(tc-getCC)

	if [[ "${CXX}" =~ 'g++' ]] ; then
		if ver_test $(gcc-version) -lt 9 ; then
			ewarn "Upstream tests with GCC >= 9 only.  Switch to version >=9 if it breaks."
		fi
	elif [[ "${CXX}" =~ 'clang++' ]] ; then
		if ver_test $(clang-version) -lt 10 ; then
			ewarn "Upstream tests with clang++ >= 10 only.  Switch to version >=10 if it breaks."
		fi
	fi
}

src_prepare() {
	default
	sed -r -e '/define VIPS_VERSION_STRING/s#@VIPS_VERSION_STRING@#@VIPS_VERSION@#' \
		-i "${S}"/libvips/include/vips/version.h.in || die

	gtkdocize --copy --docdir doc --flavour no-tmpl
	# ^ the way portage calling it doesn't work, so let's call manually
	# Needs dev-util/gtk-doc in the dependencies

	eautoreconf

	multilib_copy_sources
}

multilib_src_configure() {
	local magick="--without-magick";
	use graphicsmagick && magick="--with-magickpackage=GraphicsMagick"
	use imagemagick && magick="--with-magickpackage=MagickCore"

	econf ${magick} \
		--without-nifti \
		--without-libspng \
		--without-pdfium \
		$(multilib_native_use_enable doc gtk-doc) \
		$(use cxx || echo "--disable-cxx") \
		$(use_enable debug) \
		$(use_enable static-libs static) \
		$(use_with analyze) \
		$(use_with debug dmalloc) \
		$(use_with exif libexif) \
		$(use_with jpeg) \
		$(use_with fits cfitsio) \
		$(use_with fftw) \
		$(use_with giflib) \
		$(use_with gsf) \
		$(use_with hdr radiance) \
		$(use_with heif) \
		$(use_with imagequant) \
		$(use_with lcms) \
		$(use_with matio ) \
		$(use_with openexr OpenEXR) \
		$(use_with openslide) \
		$(use_with orc) \
		$(use_with pangoft2) \
		$(use_with png) \
		$(use_with poppler) \
		$(use_with ppm) \
		$(use_with python) \
		$(use_with svg rsvg) \
		$(use_with tiff) \
		$(use_with webp libwebp) \
		$(use_with zlib) \
		$(usex minimal "--without-deprecated" "--with-deprecated")
		--with-html-dir="/usr/share/gtk-doc/html"
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	einstalldocs
	use python && python_optimize
	prune_libtool_files
	docinto licenses
	dodoc COPYING
}
