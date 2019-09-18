# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit autotools eutils multilib-minimal python-single-r1

DESCRIPTION="VIPS Image Processing Library"
HOMEPAGE="https://jcupitt.github.io/libvips/"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE="cxx doc debug exif fits fftw graphicsmagick imagemagick jpeg lcms matio openexr openslide +orc png python static-libs svg tiff webp zlib"
SRC_URI="https://github.com/libvips/libvips/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RDEPEND="debug? ( dev-libs/dmalloc )
	 >=dev-libs/glib-2.6:2
	 dev-libs/libxml2
	 dev-util/gtk-doc
	 exif? ( >=media-libs/libexif-0.6 )
	 fftw? ( sci-libs/fftw:3.0= )
	 fits? ( sci-libs/cfitsio )
	 imagemagick? (
		graphicsmagick? ( media-gfx/graphicsmagick )
		!graphicsmagick? ( media-gfx/imagemagick )
	 )
	 jpeg? ( virtual/jpeg:0= )
	 lcms? ( media-libs/lcms )
	 matio? ( >=sci-libs/matio-1.3.4 )
	 openexr? ( >=media-libs/openexr-1.2.2 )
	 openslide? ( media-libs/openslide )
	 orc? ( >=dev-lang/orc-0.4.11 )
	 png? ( >=media-libs/libpng-1.2.9:0= )
	 svg? ( gnome-base/librsvg )
	 python? ( ${PYTHON_DEPS} )
	 sys-libs/zlib
	 tiff? ( media-libs/tiff:0= )
	 webp? ( media-libs/libwebp )
	 >=x11-libs/pango-1.8"
DEPEND="dev-util/gtk-doc-am
	doc? ( dev-util/gtk-doc )
	${RDEPEND}"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="mirror"
SLOT="1"
S="${WORKDIR}/libvips-${PV}"
DOCS=( ChangeLog NEWS README.md THANKS TODO )

pkg_setup() {
	use python && python-single-r1_pkg_setup
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
		$(multilib_native_use_enable doc gtk-doc) \
		$(use cxx || echo "--disable-cxx") \
		$(use_enable debug) \
		$(use_enable static-libs static) \
		$(use_with debug dmalloc) \
		$(use_with fftw) \
		$(use_with exif libexif) \
		$(use_with fits cfitsio) \
		$(use_with jpeg) \
		$(use_with lcms) \
		$(use_with matio ) \
		$(use_with openexr OpenEXR) \
		$(use_with openslide) \
		$(use_with orc) \
		$(use_with png) \
		$(use_with python) \
		$(use_with svg rsvg) \
		$(use_with tiff) \
		$(use_with webp libwebp) \
		--with-html-dir="/usr/share/gtk-doc/html"
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	einstalldocs
	use python && python_optimize
	prune_libtool_files
}
