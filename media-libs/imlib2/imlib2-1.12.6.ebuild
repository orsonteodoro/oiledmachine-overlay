# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Must be bumped with media-plugins/imlib2_loaders!
CFLAGS_HARDENED_USE_CASES="security-critical untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE HO IO SO"

CHKL_TIMESTAMPS=(
	"app-arch/bzip2-9999"
	"gnome-base/librsvg-9999"
	"media-libs/freetype-9999"
	"media-libs/giflib-9999"
	"media-libs/libavif-9999"
	"media-libs/libheif-9999"
	"media-libs/libid3tag-9999"
	"media-libs/libjpeg-turbo-9999"
	"media-libs/libjxl-9999"
	"media-libs/libpng-9999"
	"media-libs/libraw-9999"
	"media-libs/libyuv-9999"
	"media-libs/libwebp-9999"
	"media-libs/tiff-9999"
	"x11-libs/libX11-9999"
	"x11-libs/libxcb-9999"
)

inherit cflags-hardened check-compiler-switch flag-o-matic libtool secure-version toolchain-funcs multilib-minimal

DESCRIPTION="Version 2 of an advanced replacement library for libraries like libXpm"
HOMEPAGE="https://www.enlightenment.org/
	https://sourceforge.net/projects/enlightenment/files/imlib2-src/"
SRC_URI="https://downloads.sourceforge.net/enlightenment/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"
IUSE+="
+X apidoc avif bzip2 cpu_flags_x86_mmx cpu_flags_x86_sse2 debug
eps +filters +gif +jpeg jpeg2k jpegxl heif lzma mp3 packing +png
raw +shm static-libs svg +text +tools +tiff +webp y4m +zlib
ebuild_revision_20
"

REQUIRED_USE="shm? ( X )"

RDEPEND="
	X? (
		>=x11-libs/libX11-${LIBX11_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-${LIBXEXT_PV}:=[${MULTILIB_USEDEP}]
	)
	shm? ( >=x11-libs/libxcb-${LIBXCB_PV}:=[${MULTILIB_USEDEP}] )
	avif? ( >=media-libs/libavif-${LIBAVIF_PV}:=[${MULTILIB_USEDEP}] )
	bzip2? ( >=app-arch/bzip2-${BZIP2_PV}:=[${MULTILIB_USEDEP}] )
	eps? ( >=app-text/libspectre-${LIBSPECTRE_PV}:= )
	gif? ( >=media-libs/giflib-${GIFLIB_PV}:=[${MULTILIB_USEDEP}] )
	heif? ( >=media-libs/libheif-${LIBHEIF_PV}:=[${MULTILIB_USEDEP}] )
	jpeg2k? ( >=media-libs/openjpeg-${OPENJPEG_PV}:=[${MULTILIB_USEDEP}] )
	jpeg? ( >=media-libs/libjpeg-turbo-${LIBJPEG_TURBO_PV}:=[${MULTILIB_USEDEP}] )
	jpegxl? ( >=media-libs/libjxl-${LIBJXL_PV}:=[${MULTILIB_USEDEP}] )
	lzma? ( >=app-arch/xz-utils-${XZ_UTILS_PV}:=[${MULTILIB_USEDEP}] )
	text? ( >=media-libs/freetype-${FREETYPE_PV}:=[${MULTILIB_USEDEP}] )
	mp3? ( >=media-libs/libid3tag-${LIBID3TAG_PV}:=[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-${LIBPNG_PV}:=[${MULTILIB_USEDEP}] )
	raw? ( >=media-libs/libraw-${LIBRAW_PV}:=[${MULTILIB_USEDEP}] )
	svg? ( >=gnome-base/librsvg-${LIBRSVG_PV}:=[${MULTILIB_USEDEP}] )
	tools? ( >=virtual/zlib-${ZLIB_PV}:=[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-${TIFF_PV}:=[${MULTILIB_USEDEP}] )
	webp? ( >=media-libs/libwebp-${LIBWEBP_PV}:=[${MULTILIB_USEDEP}] )
	y4m? ( >=media-libs/libyuv-${LIBYUV_PV}:= )
	zlib? ( >=virtual/zlib-${ZLIB_PV}:=[${MULTILIB_USEDEP}] )
	!<media-plugins/imlib2_loaders-${PV}
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto:= )"
BDEPEND="
	virtual/pkgconfig
	apidoc? ( app-text/doxygen )
"

# default DOCS will haul README.in we do not need
DOCS=( AUTHORS ChangeLog README TODO )

pkg_setup() {
	check-compiler-switch_start
}

src_prepare() {
	default
	elibtoolize
}

multilib_src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cflags-hardened_append
	local myeconfargs=(
		$(use_with X x)
		$(multilib_native_use_enable apidoc doc-build)
		$(use_with avif)
		$(use_with bzip2 bz2)
		$(use_enable debug)
		$(multilib_native_use_with eps ps)
		$(use_enable filters)
		$(use_with gif)
		$(use_with heif)
		$(use_with jpeg)
		$(use_with jpeg2k j2k)
		$(use_with jpegxl jxl)
		$(use_with lzma)
		$(use_with mp3 id3)
		$(use_enable packing)
		$(use_with png)
		$(use_with raw)
		$(use_with shm x-shm-fd)
		$(use_enable static-libs static)
		$(use_with svg)
		$(use_enable text)
		$(use_enable tools progs)
		$(use_with tiff)
		$(use_with webp)
		$(multilib_native_use_with y4m)
		$(use_with zlib)

		# needed if a package is dlopen-ing imlib2 with RTLD_LOCAL,
		# which dev-perl/Image-Imlib2 *might* be doing (haven't
		# verified). if not, then should be fine to disable.
		# See also: https://git.enlightenment.org/old/legacy-imlib2/issues/30
		--enable-rtld-local-support
	)

	# imlib2 has different configure options for x86/amd64 assembly
	if [[ $(tc-arch) == amd64 ]]; then
		myeconfargs+=( $(use_enable cpu_flags_x86_sse2 amd64) --disable-mmx )
	else
		myeconfargs+=( --disable-amd64 $(use_enable cpu_flags_x86_mmx mmx) )
	fi

	ECONF_SOURCE="${S}" \
	econf "${myeconfargs[@]}"
}

multilib_src_install() {
	V=1 emake install DESTDIR="${D}"
	find "${D}" -name '*.la' -delete || die
	multilib_is_native_abi && use apidoc &&
		export HTML_DOCS=( "${BUILD_DIR}/doc/html/"* )
}
