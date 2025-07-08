# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# A:3.15, AL:2, D11, U22

RUSTFLAGS_HARDENED_USE_CASES="sensitive-data untrusted-data"
CFLAGS_HARDENED_USE_CASES="sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_CAIRO="CE DOS HO IO NPD OOBR OOBW UAF"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_EXPAT="IO"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_FREETYPE="CE HO IO SO UAF UM"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_FRIBIDI="BO CE DOS"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_GLIB="CE HO IO"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_HARFBUZZ="CE DOS HO IO NPD"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_HEIF="BO"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBAOM="BO HO IO UAF"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBARCHIVE="CE DOS HO IO MC NPD OOBA OOBR PT RC UAF UB"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_LCMS2="DOS HO ID OOBR OOBW"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBEXIF="CE DOS HO ID IO OOBR UAF"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBFFI="CE"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBHEIF="BO CE DOS NPD UAF"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBPNG="BO CE DOS HO IO NPD MC OOBR SO UAF UM"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBTIFF="BO DF DOS NPD HO IO OOBR OOBW"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBXML2="BO DF DOS FS HO IO MC NPD OOBA OOBR OOBW SO UAF"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_MOZJPEG="DOS"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_PANGO="BO CE DOS HO IO"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_PIXMAN="CE IO OOBW SO"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_VIPS="NPD UAF"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_WEBP="DF HO IO UAF UM"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_ZLIB_NG="BO CE"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_CAIRO}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_EXPAT}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_FREETYPE}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_FRIBIDI}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_GLIB}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_HARFBUZZ}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_HEIF}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_LCMS2}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBAOM}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBARCHIVE}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBEXIF}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBFFI}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBHEIF}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBPNG}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBTIFF}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBXML2}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_MOZJPEG}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_PANGO}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_PIXMAN}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_VIPS}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_WEBP}
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_ZLIB_NG}
"
RUSTFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBRSVG="DOS NPD OOBR PT"
RUSTFLAGS_HARDENED_VULNERABILITY_HISTORY="
	${RUSTFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBRSVG}
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

declare -A GIT_CRATES=()
# To get the generated CRATES list do:
# ./convert-cargo-lock.sh 8.16.1 > t
# Remove the non crate lines from t
# cat t | sort | uniq

CRATES_DISABLED="
fc-fontations-0.1.0
fc-fontations-bindgen-0.1.0
harfbuzz_fontations-0.0.0
librsvg-c-2.60.0
pixbufloader-svg-0.0.1
rsvg-bench-2.60.0
rsvg_convert-2.60.0
"

CRATES="
adler2-2.0.0
ahash-0.8.11
aho-corasick-1.1.3
android-tzdata-0.1.1
android_system_properties-0.1.5
anes-0.1.6
anstream-0.6.18
anstyle-1.0.10
anstyle-parse-0.2.6
anstyle-query-1.1.2
anstyle-wincon-3.0.6
anyhow-1.0.94
approx-0.5.1
assert_cmd-2.0.16
autocfg-1.4.0
av-data-0.4.4
bit-set-0.5.3
bit-vec-0.6.3
bitflags-1.3.2
bitflags-2.6.0
bitreader-0.3.11
block-0.1.6
block-buffer-0.10.4
bstr-1.11.0
bumpalo-3.16.0
byte-slice-cast-1.2.2
bytemuck-1.20.0
bytemuck-1.22.0
bytemuck_derive-1.8.1
byteorder-1.5.0
byteorder-lite-0.1.0
bytes-1.9.0
cairo-rs-0.20.5
cairo-sys-rs-0.20.0
cast-0.3.0
cc-1.2.3
cfg-expr-0.15.8
cfg-expr-0.17.2
cfg-if-1.0.0
chrono-0.4.39
ciborium-0.2.2
ciborium-io-0.2.2
ciborium-ll-0.2.2
clap-4.5.23
clap_builder-4.5.23
clap_complete-4.5.38
clap_derive-4.5.18
clap_lex-0.7.4
color_quant-1.1.0
colorchoice-1.0.3
core-foundation-sys-0.8.7
crc32fast-1.4.2
criterion-0.5.1
criterion-plot-0.5.0
crossbeam-deque-0.8.5
crossbeam-epoch-0.9.18
crossbeam-utils-0.8.20
crunchy-0.2.2
crypto-common-0.1.6
cssparser-0.31.2
cssparser-macros-0.6.1
data-url-0.3.1
dav1d-0.10.3
dav1d-sys-0.8.2
deranged-0.3.11
derive_more-0.99.18
difflib-0.4.0
digest-0.10.7
displaydoc-0.2.5
dlib-0.5.2
doc-comment-0.3.3
dtoa-1.0.9
dtoa-short-0.3.5
either-1.13.0
encoding_rs-0.8.35
equivalent-1.0.1
errno-0.3.10
fallible_collections-0.4.9
fastrand-2.3.0
fdeflate-0.3.7
flate2-1.0.35
float-cmp-0.9.0
fnv-1.0.7
font-types-0.8.3
form_urlencoded-1.2.1
futf-0.1.5
futures-channel-0.3.31
futures-core-0.3.31
futures-executor-0.3.31
futures-io-0.3.31
futures-macro-0.3.31
futures-task-0.3.31
futures-util-0.3.31
fxhash-0.2.1
gdk-pixbuf-0.20.4
gdk-pixbuf-sys-0.20.4
generic-array-0.14.7
getrandom-0.2.15
gif-0.13.1
gio-0.20.6
gio-sys-0.20.8
glib-0.20.6
glib-macros-0.20.5
glib-sys-0.20.6
gobject-sys-0.20.4
half-2.4.1
hashbrown-0.13.2
hashbrown-0.15.2
heck-0.5.0
hermit-abi-0.4.0
iana-time-zone-0.1.61
iana-time-zone-haiku-0.1.2
icu_collections-1.5.0
icu_locid-1.5.0
icu_locid_transform-1.5.0
icu_locid_transform_data-1.5.0
icu_normalizer-1.5.0
icu_normalizer_data-1.5.0
icu_properties-1.5.1
icu_properties_data-1.5.0
icu_provider-1.5.0
icu_provider_macros-1.5.0
idna-1.0.3
idna_adapter-1.2.0
image-0.25.5
image-webp-0.2.0
indexmap-2.7.0
is-terminal-0.4.13
is_terminal_polyfill-1.70.1
itertools-0.10.5
itertools-0.13.0
itoa-1.0.14
js-sys-0.3.76
language-tags-0.3.2
lazy_static-1.5.0
libc-0.2.165
libc-0.2.168
libloading-0.8.6
libm-0.2.11
librsvg-2.60.0
librsvg-rebind-0.1.0
librsvg-rebind-sys-0.1.0
linked-hash-map-0.5.6
linux-raw-sys-0.4.14
litemap-0.7.4
locale_config-0.3.0
lock_api-0.4.12
log-0.4.22
lopdf-0.33.0
mac-0.1.1
malloc_buf-0.0.6
markup5ever-0.12.1
matches-0.1.10
matrixmultiply-0.3.9
md-5-0.10.6
memchr-2.7.4
minimal-lexical-0.2.1
miniz_oxide-0.8.0
mp4parse-0.17.0
nalgebra-0.33.2
nalgebra-macros-0.2.2
new_debug_unreachable-1.0.6
nom-7.1.3
normalize-line-endings-0.3.0
num-bigint-0.4.6
num-complex-0.4.6
num-conv-0.1.0
num-derive-0.4.2
num-integer-0.1.46
num-rational-0.4.2
num-traits-0.2.19
objc-0.2.7
objc-foundation-0.1.1
objc_id-0.1.1
once_cell-1.20.2
oorandom-11.1.4
pango-0.20.6
pango-sys-0.20.4
pangocairo-0.20.4
pangocairo-sys-0.20.4
parking_lot-0.12.3
parking_lot_core-0.9.10
paste-1.0.15
percent-encoding-2.3.1
phf-0.10.1
phf-0.11.2
phf_codegen-0.10.0
phf_codegen-0.11.2
phf_generator-0.10.0
phf_generator-0.11.2
phf_macros-0.11.2
phf_shared-0.10.0
phf_shared-0.11.2
pin-project-lite-0.2.15
pin-utils-0.1.0
pkg-config-0.3.31
plotters-0.3.7
plotters-backend-0.3.7
plotters-svg-0.3.7
png-0.17.15
powerfmt-0.2.0
ppv-lite86-0.2.20
precomputed-hash-0.1.1
predicates-3.1.2
predicates-core-1.0.8
predicates-tree-1.0.11
proc-macro-crate-3.2.0
proc-macro2-1.0.92
proc-macro2-1.0.94
proptest-1.5.0
quick-error-1.2.3
quick-error-2.0.1
quote-1.0.37
quote-1.0.39
rand-0.8.5
rand_chacha-0.3.1
rand_core-0.6.4
rand_xorshift-0.3.0
rawpointer-0.2.1
rayon-1.10.0
rayon-core-1.12.1
rctree-0.6.0
read-fonts-0.27.5
redox_syscall-0.5.7
regex-1.11.1
regex-automata-0.4.9
regex-syntax-0.8.5
rgb-0.8.50
rustix-0.38.42
rusty-fork-0.3.0
ryu-1.0.18
safe_arch-0.7.2
same-file-1.0.6
scopeguard-1.2.0
selectors-0.25.0
serde-1.0.215
serde_derive-1.0.215
serde_json-1.0.133
serde_spanned-0.6.8
servo_arc-0.3.0
shell-words-1.1.0
shlex-1.3.0
simba-0.9.0
simd-adler32-0.3.7
siphasher-0.3.11
skrifa-0.29.2
slab-0.4.9
smallvec-1.13.2
stable_deref_trait-1.2.0
static_assertions-1.1.0
string_cache-0.8.7
string_cache_codegen-0.5.2
strsim-0.11.1
syn-2.0.90
syn-2.0.99
synstructure-0.13.1
system-deps-6.2.2
system-deps-7.0.3
target-lexicon-0.12.16
tempfile-3.14.0
tendril-0.4.3
termtree-0.4.1
thiserror-1.0.69
thiserror-impl-1.0.69
time-0.3.37
time-core-0.1.2
time-macros-0.2.19
tinystr-0.7.6
tinytemplate-1.2.1
tinyvec-1.8.0
tinyvec_macros-0.1.1
toml-0.8.19
toml_datetime-0.6.8
toml_edit-0.22.22
typenum-1.17.0
unarray-0.1.4
unicode-ident-1.0.14
unicode-ident-1.0.18
url-2.5.4
utf-8-0.7.6
utf16_iter-1.0.5
utf8_iter-1.0.4
utf8parse-0.2.2
version-compare-0.2.0
version_check-0.9.5
wait-timeout-0.2.0
walkdir-2.5.0
wasi-0.11.0+wasi-snapshot-preview1
wasm-bindgen-0.2.99
wasm-bindgen-backend-0.2.99
wasm-bindgen-macro-0.2.99
wasm-bindgen-macro-support-0.2.99
wasm-bindgen-shared-0.2.99
web-sys-0.3.76
weezl-0.1.8
wide-0.7.30
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.9
winapi-x86_64-pc-windows-gnu-0.4.0
windows-core-0.52.0
windows-sys-0.52.0
windows-sys-0.59.0
windows-targets-0.52.6
windows_aarch64_gnullvm-0.52.6
windows_aarch64_msvc-0.52.6
windows_i686_gnu-0.52.6
windows_i686_gnullvm-0.52.6
windows_i686_msvc-0.52.6
windows_x86_64_gnu-0.52.6
windows_x86_64_gnullvm-0.52.6
windows_x86_64_msvc-0.52.6
winnow-0.6.20
write16-1.0.0
writeable-0.5.5
xml5ever-0.18.1
yeslogic-fontconfig-sys-6.0.0
yoke-0.7.5
yoke-derive-0.7.5
zerocopy-0.7.35
zerocopy-derive-0.7.35
zerofrom-0.1.5
zerofrom-derive-0.1.5
zerovec-0.10.4
zerovec-derive-0.10.3
zune-core-0.4.12
zune-jpeg-0.4.14
"


inherit cargo cflags-hardened rustflags-hardened check-compiler-switch flag-o-matic python-single-r1 meson rust

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
$(cargo_crate_uris ${CRATES})
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

# @FUNCTION: cargo_src_unpack
# @DESCRIPTION:
# Unpacks the package and the cargo registry.
# From cargo.eclass
_cargo_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	mkdir -p "${ECARGO_VENDOR}" || die
	mkdir -p "${S}" || die

	cp -aT \
		"${FILESDIR}/${PV}" \
		"${WORKDIR}" \
		|| die

	mkdir -p "${ECARGO_VENDOR}" "${S}" || die

	local archive shasum pkg
	local crates=()
	for archive in ${A}; do
		case "${archive}" in
			*.crate)
				crates+=( "${archive}" )
				;;
			*)
				einfo "Skipping unpack for ${archive}.  Not a crate."
				;;
		esac
	done

	if [[ ${PKGBUMPING} != ${PVR} && ${crates[@]} ]]; then
		pushd "${DISTDIR}" >/dev/null || die

		ebegin "Unpacking crates"
		printf '%s\0' "${crates[@]}" |
			xargs -0 -P "$(makeopts_jobs)" -n 1 -t -- \
				tar -x -C "${ECARGO_VENDOR}" -f
		assert
		eend $?

		while read -d '' -r shasum archive; do
			pkg=${archive%.crate}
			cat <<- EOF > ${ECARGO_VENDOR}/${pkg}/.cargo-checksum.json || die
			{
				"package": "${shasum}",
				"files": {}
			}
			EOF

			# if this is our target package we need it in ${WORKDIR} too
			# to make ${S} (and handle any revisions too)
			if [[ ${P} == ${pkg}* ]]; then
				tar -xf "${archive}" -C "${WORKDIR}" || die
			fi
		done < <(sha256sum -z "${crates[@]}" || die)

		popd >/dev/null || die
	fi

	cargo_gen_config
}

src_unpack() {
	unpack ${A}
	S="${WORKDIR}/librsvg-${VERSION_RSVG}" \
	_cargo_src_unpack
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
	rustflags-hardened_append
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
