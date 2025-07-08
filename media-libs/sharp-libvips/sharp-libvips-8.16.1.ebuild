# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# A:3.15, AL:2, D11, U22

CFLAGS_HARDENED_USE_CASES="sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_CAIRO="CE DOS HO IO NPD OOBR OOBW UAF"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_EXPAT="IO"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_FREETYPE="CE HO IO SO UAF UM"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_GLIB="CE HO IO"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_HARFBUZZ="CE DOS HO IO NPD"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_HEIF="BO"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBAOM="BO HO IO UAF"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBPNG="BO CE DOS HO IO NPD MC OOBR SO UAF UM"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBXML2="BO DF DOS FS HO IO MC NPD OOBA OOBR OOBW SO UAF"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_PANGO="BO CE DOS HO IO"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_WEBP="DF HO IO UAF UM"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_CAIRO}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_EXPAT}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_FREETYPE}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_GLIB}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_HARFBUZZ}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_HEIF}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBAOM}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBPNG}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBXML2}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_PANGO}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_WEBP}
"


PYTHON_COMPAT=( "python3_12" )

# This ebuild allows to build a portable version with custom -march.

# Dependency versions

VERSION_VIPS=${PV}
VERSION_ZLIB_NG=2.2.4
VERSION_FFI=3.4.7
VERSION_GLIB=2.84.1
VERSION_XML2=2.14.1
VERSION_EXIF=0.6.25
VERSION_LCMS2=2.17
VERSION_MOZJPEG=4.1.5
VERSION_PNG16=1.6.47
VERSION_SPNG=0.7.4
VERSION_IMAGEQUANT=2.4.1
VERSION_WEBP=1.5.0
VERSION_TIFF=4.7.0
VERSION_HWY=1.2.0
VERSION_PROXY_LIBINTL=0.4
VERSION_FREETYPE=2.13.3
VERSION_EXPAT=2.7.1
VERSION_ARCHIVE=3.7.9
VERSION_FONTCONFIG=2.16.1
VERSION_HARFBUZZ=11.0.0
VERSION_PIXMAN=0.44.2
VERSION_CAIRO=1.18.4
VERSION_FRIBIDI=1.0.16
VERSION_PANGO=1.56.3
VERSION_RSVG=2.60.0
VERSION_AOM=3.12.0
VERSION_HEIF=1.19.7
VERSION_CGIF=0.5.0

inherit cflags-hardened check-compiler-switch flag-o-matic python-single-r1 meson rust

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
	https://github.com/lovell/sharp-libvips/archive/refs/tags/v8.16.1.tar.gz -> ${P}.tar.gz
	https://github.com/frida/proxy-libintl/archive/${VERSION_PROXY_LIBINTL}.tar.gz -> proxy-libintl-${VERSION_PROXY_LIBINTL}.tar.gz
	https://github.com/zlib-ng/zlib-ng/archive/${VERSION_ZLIB_NG}.tar.gz -> zlib-ng-${VERSION_ZLIB_NG}.tar.gz
	https://github.com/libffi/libffi/releases/download/v${VERSION_FFI}/libffi-${VERSION_FFI}.tar.gz
	https://download.gnome.org/sources/glib/${VERSION_GLIB%.*}/glib-${VERSION_GLIB}.tar.xz
	https://download.gnome.org/sources/libxml2/${VERSION_XML2%.*}/libxml2-${VERSION_XML2}.tar.xz
	https://github.com/libexif/libexif/releases/download/v${VERSION_EXIF}/libexif-${VERSION_EXIF}.tar.xz
	https://github.com/mm2/Little-CMS/releases/download/lcms${VERSION_LCMS2}/lcms2-${VERSION_LCMS2}.tar.gz
	https://storage.googleapis.com/aom-releases/libaom-${VERSION_AOM}.tar.gz
	https://github.com/strukturag/libheif/releases/download/v${VERSION_HEIF}/libheif-${VERSION_HEIF}.tar.gz
	https://github.com/mozilla/mozjpeg/archive/v${VERSION_MOZJPEG}.tar.gz -> mozjpeg-${VERSION_MOZJPEG}.tar.gz
	https://downloads.sourceforge.net/project/libpng/libpng16/${VERSION_PNG16}/libpng-${VERSION_PNG16}.tar.xz
	https://github.com/randy408/libspng/archive/v${VERSION_SPNG}.tar.gz -> libspng-${VERSION_SPNG}.tar.gz
	https://github.com/lovell/libimagequant/archive/v${VERSION_IMAGEQUANT}.tar.gz -> libimagequant-${VERSION_IMAGEQUANT}.tar.gz
	https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-${VERSION_WEBP}.tar.gz
	https://download.osgeo.org/libtiff/tiff-${VERSION_TIFF}.tar.gz
	https://github.com/google/highway/archive/${VERSION_HWY}.tar.gz -> highway-${VERSION_HWY}.tar.gz
	https://github.com/freetype/freetype/archive/VER-${VERSION_FREETYPE//./-}.tar.gz -> freetype-${VERSION_FREETYPE}.tar.gz
	https://github.com/libexpat/libexpat/releases/download/R_${VERSION_EXPAT//./_}/expat-${VERSION_EXPAT}.tar.xz
	https://github.com/libarchive/libarchive/releases/download/v${VERSION_ARCHIVE}/libarchive-${VERSION_ARCHIVE}.tar.xz
	https://gitlab.freedesktop.org/fontconfig/fontconfig/-/archive/${VERSION_FONTCONFIG}/fontconfig-${VERSION_FONTCONFIG}.tar.gz
	https://github.com/harfbuzz/harfbuzz/archive/${VERSION_HARFBUZZ}.tar.gz -> harfbuzz-${VERSION_HARFBUZZ}.tar.gz
	https://cairographics.org/releases/pixman-${VERSION_PIXMAN}.tar.gz
	https://cairographics.org/releases/cairo-${VERSION_CAIRO}.tar.xz
	https://github.com/fribidi/fribidi/releases/download/v${VERSION_FRIBIDI}/fribidi-${VERSION_FRIBIDI}.tar.xz
	https://download.gnome.org/sources/pango/${VERSION_PANGO%.*}/pango-${VERSION_PANGO}.tar.xz
	https://download.gnome.org/sources/librsvg/${VERSION_RSVG%.*}/librsvg-${VERSION_RSVG}.tar.xz
	https://github.com/dloebl/cgif/archive/v${VERSION_CGIF}.tar.gz -> cgif-${VERSION_CGIF}.tar.gz
	https://github.com/libvips/libvips/releases/download/v${VERSION_VIPS}/vips-${VERSION_VIPS}.tar.xz

	https://gist.github.com/kleisauke/284d685efa00908da99ea6afbaaf39ae/raw/936a6b8013d07d358c6944cc5b5f0e27db707ace/glib-without-gregex.patch -> ${P}-glib-without-gregex.patch
	https://gitlab.gnome.org/GNOME/libxml2/-/commit/88732cae7d6031b2fa216faa3dd542681b385117.patch -> ${P}-88732cae7d6031b2fa216faa3dd542681b385117.patch
	https://gist.githubusercontent.com/lovell/313a6901e9db1bf285f2a1f1180499e4/raw/3988223c7dfa4d22745d9392034b0117abef1446/libvips-cpp-soversion.patch -> ${P}-libvips-cpp-soversion.patch
	https://github.com/libvips/build-win64-mxe/raw/v${VERSION_VIPS}/build/patches/vips-8-heifsave-disable-hbr-support.patch -> ${P}-vips-8-heifsave-disable-hbr-support.patch
	https://raw.githubusercontent.com/lovell/sharp-libvips/main/THIRD-PARTY-NOTICES.md -> ${P}-THIRD-PARTY-NOTICES.md
"

DESCRIPTION="libvips static build for sharp, matching sharp-libvips"
HOMEPAGE="https://github.com/lovell/sharp-libvips"
LICENSE="
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	BSD
	BSD-2
	BSD-4
	icu
	IJG
	ISC
	public-domain
	LGPL-2+
	LGPL-2.1+
	LGPL-3+
	MIT
	MPL-2.0
	Old-MIT
	Unicode-DFS-2016
	ZLIB
	|| (
		FTL
		GPL-2+
	)
	|| (
		LGPL-2.1
		MPL-1.1
	)
"
# cairo - || ( LGPL-2.1 MPL-1.1 )
# cgif - MIT
# glib - LGPL-2.1+
# fontconfig - MIT
# freetype - || ( FTL GPL-2+ )
# fribidi - LGPL-2.1+
# harfbuzz - Old-MIT ISC icu
# highway - Apache-2.0, BSD
# libarchive - BSD BSD-2 BSD-4 public-domain
# libaom - BSD-2, Alliance for Open Media Patent License 1.0
# libheif - LGPL-3+
# libexif - LGPL-2.1+
# libexpat - MIT
# libffi - MIT
# libimagequant - BSD-2
# libpng - libpng
# librsvg - LGPL-2.1+ Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD ISC MIT MPL-2.0 Unicode-DFS-2016
# libspng - BSD-2
# libtiff - MIT
# Little-CMS - MIT
# libvips - LGPL-2.1+
# libwebp - BSD
# libxml2 - MIT
# mozjpeg - IJG, BSD
# pango - LGPL-2+
# pixman - MIT
# proxy-libintl - LGPL-2.1+
# sharp-libvips - Apache-2.0
# zlib-ng - ZLIB

RESTRICT="mirror" # Speed up downloads
SLOT="0"
DEPEND="
	>=app-arch/bzip2-1.0.8
	>=app-arch/tar-1.35
	>=app-arch/xz-utils-5.8.1
	>=dev-libs/openssl-3.5.1
"
BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/packaging-25.0[${PYTHON_USEDEP}]
		>=dev-python/pip-20.3.4[${PYTHON_USEDEP}]
	')
	>=app-misc/jq-1.8.0
	>=dev-build/autoconf-2.72
	>=dev-build/automake-1.18.1
	>=dev-build/cmake-4.0.3
	>=dev-build/libtool-2.5.4
	>=dev-build/make-4.4.1
	>=dev-build/meson-1.8.2
	>=dev-build/ninja-1.13.0
	>=dev-lang/nasm-2.16.03
	>=dev-util/gperf-3.3
	>=dev-vcs/git-2.50.0
	>=net-misc/curl-8.14.1
	>=sys-apps/coreutils-9.7
	>=sys-apps/findutils-4.10.0
	>=sys-devel/binutils-2.44
	>=sys-devel/gettext-0.24.1
	>=sys-devel/patch-2.8
	>=sys-kernel/linux-headers-6.15.5
	sys-devel/gcc
	virtual/pkgconfig
	|| (
		dev-lang/rust:1.88.0
		dev-lang/rust-bin:1.88.0
	)
	|| (
		dev-lang/rust:=
		dev-lang/rust-bin:=
	)
"
PATCHES=(
	"${FILESDIR}/sharp-libvips-8.16.1-lin-sh.patch"
)

pkg_setup() {
	check-compiler-switch_start
	rust_pkg_setup
	python-single-r1_pkg_setup
}

src_unpack() {
	unpack ${A}
}

src_prepare() {
	default
}

src_configure() {
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CC} -E"
	export AS="as"
	export AR="ar"
	export NM="nm"
	export STRIP="strip"
	export RANDLIB="randlib"
	export READELF="readelf"
	unset LD
	check-compiler-switch_end

	strip-unsupported-flags
	replace-flags '-O*' '-O2'

	cflags-hardened_append
	if check-compiler-switch_is_flavor_slot_changed ; then
ewarn "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi
}

get_platform() {
	if [[ "${ABI}" == "amd64" && "${ELIBC}" == "glibc" ]] ; then
		echo "linux-x64"
	elif [[ "${ABI}" == "amd64" && "${ELIBC}" == "musl" ]] ; then
		echo "linuxmusl-x64"

	elif [[ "${ABI}" == "arm64" && "${ELIBC}" == "glibc" ]] ; then
		echo "linux-arm64v8"
	elif [[ "${ABI}" == "arm64" && "${ELIBC}" == "musl" ]] ; then
		echo "linuxmusl-arm64v8"

	elif [[ "${CHOST}" == "armv6" && "${ELIBC}" == "glibc" ]] ; then
		echo "linux-armv6"

	elif [[ "${CHOST}" =~ "powerpc64le-" && "${ELIBC}" == "glibc" ]] ; then
		echo "linux-ppc64le"

	elif [[ "${CHOST}" == "s390x" && "${ELIBC}" == "glibc" ]] ; then
		echo "linux-s390x"

	else
		die "ARCH=${ARCH} ABI=${ABI} is not supported.  Modify ebuild for support."
	fi
}

setup_arch() {
	local platform=$(get_platform)
	pushd "platforms/${platform}" 2>&1 >/dev/null || die
		export RUSTUP_HOME="${HOME}/rustup"
		export CARGO_HOME="${HOME}/cargo"
		export PKG_CONFIG="${CHOST}-pkg-config --static"
		#export MESON="--cross-file='${HOME}/meson.ini'" # Breaks during building glib
		export FLAGS=""
		#cp -a "meson.ini" "${HOME}" || die
		cp -a "Toolchain.cmake" "${HOME}" || die
		if [[ "${ABI}" == "amd64" && "${ELIBC}" == "glibc" ]] ; then
			#export FLAGS="-march=nehalem"
			:
		elif [[ "${ABI}" == "amd64" && "${ELIBC}" == "musl" ]] ; then
			#export FLAGS="-march=nehalem"
			:
		elif [[ "${ABI}" == "arm64" && "${ELIBC}" == "glibc" ]] ; then
			#export FLAGS="-march=armv8-a"
			:
		elif [[ "${ABI}" == "arm64" && "${ELIBC}" == "musl" ]] ; then
			#export FLAGS="-march=armv8-a"
			export RUST_TARGET="aarch64-unknown-linux-musl"
		elif [[ "${CHOST}" == "armv6" && "${ELIBC}" == "glibc" ]] ; then
			#export FLAGS="-marm -mcpu=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard"
			export RUST_TARGET="arm-unknown-linux-gnueabihf"
			export WITHOUT_HIGHWAY="true"
			export WITHOUT_NEON="true"
		elif [[ "${CHOST}" =~ "powerpc64le-" && "${ELIBC}" == "glibc" ]] ; then
			#export FLAGS=""
			export RUST_TARGET="powerpc64le-unknown-linux-gnu"
		elif [[ "${CHOST}" == "s390x" && "${ELIBC}" == "glibc" ]] ; then
			#export FLAGS=""
			#export FLAGS="-march=z14 -mzvector"
			export RUST_TARGET="s390x-unknown-linux-gnu"
			export WITHOUT_HIGHWAY="true"
		else
			die "ARCH=${ARCH} ABI=${ABI} is not supported.  Modify ebuild for support."
		fi
	popd 2>&1 >/dev/null || die

}

src_compile() {
	unset MESON_CROSS_FILE
	export PLATFORM=$(get_platform)
#	export SHARP_LIBVIPS_PREFIX="${WORKDIR}/build/deps"
#	export PKG_CONFIG_PATH="${SHARP_LIBVIPS_PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH}"
	setup_arch
	bash "${S}/build/lin.sh" || die
}

src_install() {
	meson install -C "${WORKDIR}/vips-${LIBVIPS_PV}/build" || die "Meson install failed"
}
