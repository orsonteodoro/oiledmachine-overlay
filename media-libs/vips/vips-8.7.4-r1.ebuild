# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit autotools eutils multilib-minimal python-single-r1

DESCRIPTION="VIPS Image Processing Library"
HOMEPAGE="https://jcupitt.github.io/libvips/"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
IUSE="cxx doc debug exif fits fftw graphicsmagick imagemagick jpeg lcms matio openexr openslide +orc png python static-libs svg tiff webp zlib"
SRC_URI="https://github.com/libvips/libvips/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RDEPEND="debug? ( dev-libs/dmalloc )
	 >=dev-libs/glib-2.6:2[${MULTILIB_USEDEP}]
	 dev-libs/libxml2[${MULTILIB_USEDEP}]
	 dev-util/gtk-doc
	 exif? ( >=media-libs/libexif-0.6[${MULTILIB_USEDEP}] )
	 fftw? ( sci-libs/fftw:3.0=[${MULTILIB_USEDEP}] )
	 fits? ( sci-libs/cfitsio[${MULTILIB_USEDEP}] )
	 imagemagick? (
		graphicsmagick? ( media-gfx/graphicsmagick )
		!graphicsmagick? ( media-gfx/imagemagick )
	 )
	 jpeg? ( virtual/jpeg:0=[${MULTILIB_USEDEP}] )
	 lcms? ( media-libs/lcms[${MULTILIB_USEDEP}] )
	 matio? ( >=sci-libs/matio-1.3.4[${MULTILIB_USEDEP}] )
	 openexr? ( >=media-libs/openexr-1.2.2[${MULTILIB_USEDEP}] )
	 openslide? ( media-libs/openslide[${MULTILIB_USEDEP}] )
	 orc? ( >=dev-lang/orc-0.4.11[${MULTILIB_USEDEP}] )
	 png? ( >=media-libs/libpng-1.2.9:0=[${MULTILIB_USEDEP}] )
	 svg? ( gnome-base/librsvg[${MULTILIB_USEDEP}] )
	 python? ( ${PYTHON_DEPS} )
	 sys-libs/zlib[${MULTILIB_USEDEP}]
	 tiff? ( media-libs/tiff:0=[${MULTILIB_USEDEP}] )
	 webp? ( media-libs/libwebp[${MULTILIB_USEDEP}] )
	 >=x11-libs/pango-1.8[${MULTILIB_USEDEP}]"
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
