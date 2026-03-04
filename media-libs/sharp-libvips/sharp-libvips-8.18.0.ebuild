# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Version based on libvips

# Dependency graph:
# librsvg:  -L/var/tmp/portage/media-libs/sharp-libvips-8.16.1/work/build/deps/lib64 -lrsvg-2 -lgio-2.0 -lgobject-2.0 -lffi -lcairo -ldl -lfontconfig -lpng16 -lz -lharfbuzz -lm -lfreetype -lpixman-1 -lgmodule-2.0 -lglib-2.0 -latomic -lm -pthread
# libexif:  -L/var/tmp/portage/media-libs/sharp-libvips-8.16.1/work/build/deps/lib64 -lexif
# libpng: -L/var/tmp/portage/media-libs/sharp-libvips-8.16.1/work/build/deps/lib64 -lpng16
# libspng:  -L/var/tmp/portage/media-libs/sharp-libvips-8.16.1/work/build/deps/lib64 -lspng -lm -lz
# libjpeg:  -L/var/tmp/portage/media-libs/sharp-libvips-8.16.1/work/build/deps/lib64 -ljpeg
# libheif:  -L/var/tmp/portage/media-libs/sharp-libvips-8.16.1/work/build/deps/lib64 -lheif
# libarchive:  -L/var/tmp/portage/media-libs/sharp-libvips-8.16.1/work/build/deps/lib64 -larchive
# cgif:  -L/var/tmp/portage/media-libs/sharp-libvips-8.16.1/work/build/deps/lib64 -lcgif
# lcms2:  -L/var/tmp/portage/media-libs/sharp-libvips-8.16.1/work/build/deps/lib64 -llcms2 -lm -pthread
# libwebp:  -L/var/tmp/portage/media-libs/sharp-libvips-8.16.1/work/build/deps/lib64 -lwebp
# libwebpmux:  -L/var/tmp/portage/media-libs/sharp-libvips-8.16.1/work/build/deps/lib64 -lwebpmux
# libwebpdemux:  -L/var/tmp/portage/media-libs/sharp-libvips-8.16.1/work/build/deps/lib64 -lwebpdemux
# hwy:  -L/var/tmp/portage/media-libs/sharp-libvips-8.16.1/work/build/deps/lib64 -lhwy
# imagequant:  -L/var/tmp/portage/media-libs/sharp-libvips-8.16.1/work/build/deps/lib64 -limagequant -lm
# aom:  -L/var/tmp/portage/media-libs/sharp-libvips-8.16.1/work/build/deps/lib64 -laom
# sharpyuv -L/var/tmp/portage/media-libs/sharp-libvips-8.16.1/work/build/deps/lib64 -lsharpyuv
# libtiff:  -L/var/tmp/portage/media-libs/sharp-libvips-8.16.1/work/build/deps/lib64 -ltiff
# uhdr: -L/var/tmp/portage/media-libs/sharp-libvips-8.18.0/work/build/deps/lib64 -luhdr -ljpeg
# vips-cpp:  -L/usr/lib/sharp-vips/lib64 -lvips-cpp -lvips -ltiff -larchive -lz -ljpeg -lwebp -lwebpmux -lwebpdemux -lheif -limagequant -lcgif -lexif -lrsvg-2 -lcairo-gobject -lxml2 -lpangocairo-1.0 -lpangoft2-1.0 -lpango-1.0 -lgio-2.0 -lgobject-2.0 -lcairo -lpng16 -lfontconfig -lexpat -lharfbuzz -lfreetype -lpixman-1 -lgmodule-2.0 -lglib-2.0 -llcms2 -lhwy -laom -lsharpyuv -lm -lffi -lfribidi -ldl -lmd -latomic -lstdc++ -pthread
# vips:  -L/usr/lib/sharp-vips/lib64 -lvips -ltiff -larchive -lz -ljpeg -lwebp -lwebpmux -lwebpdemux -lheif -limagequant -lcgif -lexif -lrsvg-2 -lcairo-gobject -lxml2 -lpangocairo-1.0 -lpangoft2-1.0 -lpango-1.0 -lgio-2.0 -lgobject-2.0 -lcairo -lpng16 -lfontconfig -lexpat -lharfbuzz -lfreetype -lpixman-1 -lgmodule-2.0 -lglib-2.0 -llcms2 -lhwy -laom -lsharpyuv -lm -lffi -lfribidi -ldl -lmd -latomic -lstdc++ -pthread

# A:3.15, AL:2, D11, U22

# Why this ebuild exists:
# 1.  The prebuilt sharp-libvips is non-portable for older processors.
# 2.  Sharp's format() is broken for globally installed vips.  The static build and pinned versions may resolve it.
#     While is it is unnecessary to use format(), some downstream projects may require it.

PYTHON_COMPAT=( "python3_12" )

# This ebuild allows to build a portable version with custom -march.

# Dependency versions

# Rust requirements relaxed.  Use the one that supports --check-cfg.
# Lowest minimal required by dependencies used
# Upstream uses 1.94.0-nightly (fcd630976; Jan 1, 2026, LLVM 21.1)
RUST_MAX_VER="1.88.0" # Inclusive
RUST_MIN_VER="1.88.0" # llvm-20.1

RUST_PV="${RUST_MAX_VER}"
SHARP_VIPS_PV="1.3.0-rc.2" # BUMP IMPORTANT!  Use GH tag name
VERSION_SHARP_LIBVIPS=${SHARP_VIPS_PV}
VERSION_VIPS=${PV}
VERSION_ZLIB_NG=2.3.2
VERSION_FFI=3.5.2
VERSION_GLIB=2.87.1
VERSION_XML2=2.15.1
VERSION_EXIF=0.6.25
VERSION_LCMS=2.17
VERSION_MOZJPEG="0826579"
VERSION_MOZJPEG_COMMIT="08265790774cd0714832c9e675522acbe5581437"
VERSION_PNG=1.6.53
VERSION_IMAGEQUANT=2.4.1
VERSION_WEBP=1.6.0
VERSION_TIFF=4.7.1
VERSION_HWY=1.3.0
VERSION_PROXY_LIBINTL=0.5
VERSION_FREETYPE=2.14.1
VERSION_EXPAT=2.7.3
VERSION_ARCHIVE=3.8.4
VERSION_FONTCONFIG=2.17.1
VERSION_HARFBUZZ=12.3.0
VERSION_PIXMAN=0.46.4
VERSION_CAIRO=1.18.4
VERSION_FRIBIDI=1.0.16
VERSION_PANGO=1.57.0
VERSION_RSVG=2.61.3
VERSION_AOM=3.13.1
VERSION_HEIF=1.21.1
VERSION_CGIF=0.5.0
VERSION_UHDR=1.4.0

RUSTFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_USE_CASES="sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_CAIRO="CE DOS HO IO NPD OOBR OOBW UAF"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_EXPAT="IO"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_FREETYPE="CE HO IO SO UAF UM"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_FRIBIDI="BO CE DOS"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_FONTCONFIG="CE DF"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_GLIB="CE HO IO"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_HARFBUZZ="CE DOS HO IO NPD"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_HEIF="BO"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_LCMS2="DOS HO ID OOBR OOBW"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBAOM="BO HO IO UAF"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBARCHIVE="CE DOS HO IO MC NPD OOBA OOBR PT RC UAF UB"
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
	${CFLAGS_HARDENED_VULNERABILITY_HISTORY_FONTCONFIG}
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

CPU_FLAGS_X86=(
	"cpu_flags_x86_sse4"
)

RUSTFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBRSVG="DOS NPD OOBR PT"
RUSTFLAGS_HARDENED_VULNERABILITY_HISTORY="
	${RUSTFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBRSVG}
"


declare -A GIT_CRATES=()
# To get the generated CRATES list do:
# ./convert-cargo-lock.sh 8.16.1 > t
# Remove the non crate lines from t
# cat t | sort | uniq

CRATES_DISABLED="
fc-fontations-0.1.0
fcint-bindings-0.1.0
librsvg-c-2.61.3
pixbufloader-svg-0.0.1
rsvg-bench-2.61.3
rsvg_convert-2.61.3
fontconfig-bindings-0.1.0
"

CRATES="
adler2-2.0.1
aes-0.8.4
ahash-0.8.12
aho-corasick-1.1.4
android_system_properties-0.1.5
anes-0.1.6
anstream-0.6.21
anstyle-1.0.13
anstyle-parse-0.2.7
anstyle-query-1.1.5
anstyle-wincon-3.0.11
anyhow-1.0.102
approx-0.5.1
assert_cmd-2.1.2
autocfg-1.5.0
av-data-0.4.4
bitflags-2.11.0
bitreader-0.3.11
bit-set-0.8.0
bit-vec-0.8.0
block-0.1.6
block-buffer-0.10.4
block-padding-0.3.3
bstr-1.12.1
bumpalo-3.20.2
bytecount-0.6.9
bytemuck-1.23.0
bytemuck-1.25.0
bytemuck_derive-1.9.3
byteorder-1.5.0
byteorder-lite-0.1.0
bytes-1.11.1
byte-slice-cast-1.2.3
cairo-rs-0.21.5
cairo-sys-rs-0.21.5
cast-0.3.0
cbc-0.1.2
cc-1.2.56
cfg-expr-0.20.6
cfg-if-1.0.4
chrono-0.4.44
ci-0.0.0
ciborium-0.2.2
ciborium-io-0.2.2
ciborium-ll-0.2.2
cipher-0.4.4
clap-4.5.60
clap_builder-4.5.60
clap_complete-4.5.66
clap_derive-4.5.55
clap_lex-1.0.0
colorchoice-1.0.4
color_quant-1.1.0
core-foundation-sys-0.8.7
cpufeatures-0.2.17
crc32fast-1.5.0
criterion-0.7.0
criterion-plot-0.6.0
crossbeam-deque-0.8.6
crossbeam-epoch-0.9.18
crossbeam-utils-0.8.21
crunchy-0.2.4
crypto-common-0.1.7
cssparser-0.35.0
cssparser-color-0.3.0
cssparser-macros-0.6.1
data-url-0.3.2
dav1d-0.10.4
dav1d-sys-0.8.3
deranged-0.5.8
derive_more-2.1.1
derive_more-impl-2.1.1
difflib-0.4.0
digest-0.10.7
displaydoc-0.2.5
dlib-0.5.3
dtoa-1.0.11
dtoa-short-0.3.5
ecb-0.1.2
either-1.15.0
encoding_rs-0.8.35
equivalent-1.0.2
errno-0.3.14
fallible_collections-0.4.9
fastrand-2.3.0
fdeflate-0.3.7
find-msvc-tools-0.1.9
flate2-1.1.9
float-cmp-0.10.0
fnv-1.0.7
foldhash-0.1.5
font-types-0.9.0
form_urlencoded-1.2.2
futf-0.1.5
futures-channel-0.3.32
futures-core-0.3.32
futures-executor-0.3.32
futures-io-0.3.32
futures-macro-0.3.32
futures-task-0.3.32
futures-util-0.3.32
fxhash-0.2.1
gdk-pixbuf-0.21.5
gdk-pixbuf-sys-0.21.5
generic-array-0.14.7
getrandom-0.3.4
getrandom-0.4.2
gif-0.14.1
gio-0.21.5
gio-sys-0.21.5
glib-0.21.5
glib-macros-0.21.5
glib-sys-0.21.5
gobject-sys-0.21.5
half-2.7.1
hashbrown-0.13.2
hashbrown-0.15.5
hashbrown-0.16.1
heck-0.5.0
iana-time-zone-0.1.65
iana-time-zone-haiku-0.1.2
icu_collections-2.1.1
icu_locale_core-2.1.1
icu_normalizer-2.1.1
icu_normalizer_data-2.1.1
icu_properties-2.1.2
icu_properties_data-2.1.2
icu_provider-2.1.1
id-arena-2.3.0
idna-1.1.0
idna_adapter-1.2.1
image-0.25.9
image-webp-0.2.4
indexmap-2.13.0
inout-0.1.4
is_terminal_polyfill-1.70.2
itertools-0.13.0
itertools-0.14.0
itoa-1.0.17
jiff-0.2.22
jiff-static-0.2.22
jiff-tzdb-0.1.5
jiff-tzdb-platform-0.1.3
js-sys-0.3.91
language-tags-0.3.2
lazy_static-1.5.0
leb128fmt-0.1.0
libc-0.2.172
libc-0.2.182
libloading-0.8.9
librsvg-2.61.3
librsvg-rebind-0.2.1
librsvg-rebind-sys-0.2.1
linux-raw-sys-0.12.1
litemap-0.8.1
locale_config-0.3.0
lock_api-0.4.14
log-0.4.29
lopdf-0.38.0
mac-0.1.1
malloc_buf-0.0.6
markup5ever-0.35.0
matches-0.1.10
matrixmultiply-0.3.10
md-5-0.10.6
memchr-2.8.0
miniz_oxide-0.8.9
moxcms-0.7.11
mp4parse-0.17.0
nalgebra-0.33.2
nalgebra-macros-0.2.2
new_debug_unreachable-1.0.6
nom-8.0.0
nom_locate-5.0.0
normalize-line-endings-0.3.0
num-bigint-0.4.6
num-complex-0.4.6
num-conv-0.2.0
num-derive-0.4.2
num-integer-0.1.46
num-rational-0.4.2
num-traits-0.2.19
objc-0.2.7
objc-foundation-0.1.1
objc_id-0.1.1
once_cell-1.21.3
once_cell_polyfill-1.70.2
oorandom-11.1.5
pango-0.21.5
pangocairo-0.21.5
pangocairo-sys-0.21.5
pango-sys-0.21.5
parking_lot-0.12.5
parking_lot_core-0.9.12
paste-1.0.15
percent-encoding-2.3.2
phf-0.11.3
phf_codegen-0.11.3
phf_generator-0.11.3
phf_macros-0.11.3
phf_shared-0.11.3
phf_shared-0.13.1
pin-project-lite-0.2.17
pkg-config-0.3.32
plotters-0.3.7
plotters-backend-0.3.7
plotters-svg-0.3.7
png-0.18.1
portable-atomic-1.13.1
portable-atomic-util-0.2.5
potential_utf-0.1.4
powerfmt-0.2.0
ppv-lite86-0.2.21
precomputed-hash-0.1.1
predicates-3.1.4
predicates-core-1.0.10
predicates-tree-1.0.13
prettyplease-0.2.37
proc-macro2-1.0.106
proc-macro2-1.0.95
proc-macro-crate-3.4.0
proptest-1.10.0
pxfm-0.1.28
quick-error-1.2.3
quick-error-2.0.1
quote-1.0.40
quote-1.0.44
rand-0.8.5
rand-0.9.2
rand_chacha-0.9.0
rand_core-0.6.4
rand_core-0.9.5
rand_xorshift-0.4.0
rangemap-1.7.1
rawpointer-0.2.1
rayon-1.11.0
rayon-core-1.13.0
rctree-0.6.0
read-fonts-0.29.2
redox_syscall-0.5.18
r-efi-5.3.0
r-efi-6.0.0
regex-1.12.3
regex-automata-0.4.14
regex-syntax-0.8.10
rgb-0.8.53
rustc_version-0.4.1
rustix-1.1.4
rustversion-1.0.22
rusty-fork-0.3.1
safe_arch-0.7.4
same-file-1.0.6
scopeguard-1.2.0
selectors-0.31.0
semver-1.0.27
serde-1.0.228
serde_core-1.0.228
serde_derive-1.0.228
serde_json-1.0.149
serde_spanned-1.0.4
servo_arc-0.4.3
sha2-0.10.9
shell-words-1.1.1
shlex-1.3.0
simba-0.9.1
simd-adler32-0.3.8
siphasher-1.0.2
skrifa-0.31.3
slab-0.4.12
smallvec-1.15.1
stable_deref_trait-1.2.1
static_assertions-1.1.0
string_cache-0.8.9
string_cache-0.9.0
string_cache_codegen-0.5.4
stringprep-0.1.5
strsim-0.11.1
syn-2.0.101
syn-2.0.117
synstructure-0.13.2
system-deps-7.0.7
target-lexicon-0.13.3
tempfile-3.26.0
tendril-0.4.3
termtree-0.5.1
thiserror-2.0.18
thiserror-impl-2.0.18
time-0.3.47
time-core-0.1.8
time-macros-0.2.27
tinystr-0.8.2
tinytemplate-1.2.1
tinyvec-1.10.0
tinyvec_macros-0.1.1
toml-0.9.12+spec-1.1.0
toml_datetime-0.7.5+spec-1.1.0
toml_edit-0.23.10+spec-1.0.0
toml_parser-1.0.9+spec-1.1.0
toml_writer-1.0.6+spec-1.1.0
ttf-parser-0.25.1
typenum-1.19.0
unarray-0.1.4
unicode-bidi-0.3.18
unicode-ident-1.0.18
unicode-ident-1.0.24
unicode-normalization-0.1.25
unicode-properties-0.1.4
unicode-xid-0.2.6
url-2.5.8
utf-8-0.7.6
utf8_iter-1.0.4
utf8parse-0.2.2
version_check-0.9.5
version-compare-0.2.1
wait-timeout-0.2.1
walkdir-2.5.0
wasip2-1.0.2+wasi-0.2.9
wasip3-0.4.0+wasi-0.3.0-rc-2026-01-06
wasm-bindgen-0.2.114
wasm-bindgen-macro-0.2.114
wasm-bindgen-macro-support-0.2.114
wasm-bindgen-shared-0.2.114
wasm-encoder-0.244.0
wasm-metadata-0.244.0
wasmparser-0.244.0
web_atoms-0.1.3
web-sys-0.3.91
weezl-0.1.12
wide-0.7.33
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.11
winapi-x86_64-pc-windows-gnu-0.4.0
windows-core-0.62.2
windows-implement-0.60.2
windows-interface-0.59.3
windows-link-0.2.1
windows-result-0.4.1
windows-strings-0.5.1
windows-sys-0.61.2
winnow-0.7.14
wit-bindgen-0.51.0
wit-bindgen-core-0.51.0
wit-bindgen-rust-0.51.0
wit-bindgen-rust-macro-0.51.0
wit-component-0.244.0
wit-parser-0.244.0
writeable-0.6.2
xml5ever-0.35.0
yeslogic-fontconfig-sys-6.0.0
yoke-0.8.1
yoke-derive-0.8.1
zerocopy-0.8.40
zerocopy-derive-0.8.40
zerofrom-0.1.6
zerofrom-derive-0.1.6
zerotrie-0.2.3
zerovec-0.11.5
zerovec-derive-0.11.2
zmij-1.0.21
zune-core-0.5.1
zune-jpeg-0.5.12
"

inherit cargo cflags-hardened rustflags-hardened check-compiler-switch flag-o-matic multiprocessing python-single-r1 meson rust

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${SHARP_VIPS_PV}"
SRC_URI="
$(cargo_crate_uris ${CRATES})
https://github.com/lovell/sharp-libvips/archive/refs/tags/v${SHARP_VIPS_PV}.tar.gz -> ${PN}-${SHARP_VIPS_PV}.tar.gz
https://github.com/frida/proxy-libintl/archive/${VERSION_PROXY_LIBINTL}.tar.gz -> proxy-libintl-${VERSION_PROXY_LIBINTL}.tar.gz
https://github.com/zlib-ng/zlib-ng/archive/${VERSION_ZLIB_NG}.tar.gz -> zlib-ng-${VERSION_ZLIB_NG}.tar.gz
https://github.com/libffi/libffi/releases/download/v${VERSION_FFI}/libffi-${VERSION_FFI}.tar.gz
https://download.gnome.org/sources/glib/${VERSION_GLIB%.*}/glib-${VERSION_GLIB}.tar.xz
https://download.gnome.org/sources/libxml2/${VERSION_XML2%.*}/libxml2-${VERSION_XML2}.tar.xz
https://github.com/libexif/libexif/releases/download/v${VERSION_EXIF}/libexif-${VERSION_EXIF}.tar.xz
https://github.com/mm2/Little-CMS/releases/download/lcms${VERSION_LCMS}/lcms2-${VERSION_LCMS}.tar.gz
https://storage.googleapis.com/aom-releases/libaom-${VERSION_AOM}.tar.gz
https://github.com/strukturag/libheif/releases/download/v${VERSION_HEIF}/libheif-${VERSION_HEIF}.tar.gz
https://github.com/mozilla/mozjpeg/archive/${VERSION_MOZJPEG}.tar.gz -> mozjpeg-${VERSION_MOZJPEG}.tar.gz
https://downloads.sourceforge.net/project/libpng/libpng16/${VERSION_PNG}/libpng-${VERSION_PNG}.tar.xz
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
https://github.com/google/libultrahdr/archive/v${VERSION_UHDR}.tar.gz -> libultrahdr-${VERSION_UHDR}.tar.gz

https://gist.github.com/kleisauke/284d685efa00908da99ea6afbaaf39ae/raw/bdad5489a61c217850631571caf57f5db6ea8b2c/glib-without-gregex.patch -> ${P}-glib-without-gregex-bdad548.patch
https://gist.githubusercontent.com/lovell/313a6901e9db1bf285f2a1f1180499e4/raw/3988223c7dfa4d22745d9392034b0117abef1446/libvips-cpp-soversion.patch -> ${P}-libvips-cpp-soversion-313a690-3988223.patch
https://github.com/libvips/build-win64-mxe/raw/v${VERSION_VIPS}/build/patches/vips-8-heifsave-disable-hbr-support.patch -> ${P}-vips-8-heifsave-disable-hbr-support.patch
https://raw.githubusercontent.com/lovell/sharp-libvips/refs/tags/v${SHARP_VIPS_PV}/THIRD-PARTY-NOTICES.md -> ${P}-THIRD-PARTY-NOTICES.md
https://github.com/google/highway/commit/ad48f2bf298bac247288c8399a5c0e9a40ed8246.patch -> ${P}-highway-ad48f2b.patch
https://github.com/m-ab-s/aom/commit/6d2b7f71b98bfa28e372b1f2d85f137280bdb3de.patch -> ${P}-libaom-6d2b7f7.patch
https://github.com/google/libultrahdr/commit/5ed39d67cd31d254e84ebf76b03d4b7bcc12e2f7.patch -> ${P}-libultrahdr-5ed39d6.patch
https://github.com/google/libultrahdr/pull/376.patch -> ${P}-libultrahdr-pull-376.patch
https://github.com/libvips/build-win64-mxe/raw/v${VERSION_VIPS}/build/patches/vips-8-heifsave-disable-hbr-support.patch -> ${P}-vips-8-heifsave-disable-hbr-support-for-${VERSION_VIPS}.patch
"

DESCRIPTION="libvips static build for sharp, matching sharp-libvips"
HOMEPAGE="https://github.com/lovell/sharp-libvips"
IUSE+="
${CPU_FLAGS_X86[@]}
debug
-vanilla
ebuild_revision_35
"
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
		dev-lang/rust:1.78.0
		dev-lang/rust:1.77.2
		dev-lang/rust-bin:1.78.0
		dev-lang/rust-bin:1.77.2
	)
	|| (
		dev-lang/rust:=
		dev-lang/rust-bin:=
	)
"
PATCHES=(
	"${FILESDIR}/sharp-libvips-8.18.0-posix-sh.patch"
)

pkg_setup() {
ewarn "This ebuild is under development."
	check-compiler-switch_start
	rust_pkg_setup
	python-single-r1_pkg_setup

	local rust_pv_raw=$("${RUSTC}" --version \
		| cut -f 2 -d " ")
	local rust_pv=$("${RUSTC}" --version \
		| cut -f 2 -d " " \
		| cut -f 1 -d "-")
	if [[ "${rust_pv_raw}" =~ "nightly" ]] ; then
		local _date=$("${RUSTC}" --version \
			| cut -f 4 -d " " \
			| sed -e "s|)||g")
		if ver_test "${rust_pv_raw}" -lt "1.94.0" ; then
eerror "Only Rust >= 1.94.0 supported for nightly"
			die
		fi
		if ver_test "${_date//-/}" -lt "20260101" ; then
eerror "Only Rust nightly >= 2026-01-01 supported for nightly"
			die
		fi
	fi
}

# @FUNCTION: cargo_src_unpack
# @DESCRIPTION:
# Unpacks the package and the cargo registry.
# From cargo.eclass
_cargo_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

einfo "ECARGO_VENDOR:  ${ECARGO_VENDOR}"
einfo "S:  ${S}"

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

	if [[ "${PKGBUMPING}" != "${PVR}" && "${#crates[@]}" -gt "0" ]]; then
		pushd "${DISTDIR}" >/dev/null || die

		ebegin "Unpacking crates"
		printf '%s\0' "${crates[@]}" |
			xargs -0 -P "$(makeopts_jobs)" -n 1 -t -- \
				tar -x -C "${ECARGO_VENDOR}" -f
		assert
		eend $?

		while read -d '' -r shasum archive ; do
			pkg="${archive%.crate}"
			cat <<- EOF > "${ECARGO_VENDOR}/${pkg}/.cargo-checksum.json" || die
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
einfo "Applying Cargo.toml patches to librsvg ${VERSION_RSVG}"
	sed -i "/image = /s/, \"gif\", \"webp\"//" "${WORKDIR}/librsvg-${VERSION_RSVG}/rsvg/Cargo.toml" || die
	sed -i "/cairo-rs = /s/, \"pdf\", \"ps\"//" "${WORKDIR}/librsvg-${VERSION_RSVG}/"{"librsvg-c","rsvg"}"/Cargo.toml" || die
	pushd "${WORKDIR}/librsvg-${VERSION_RSVG}" 2>&1 >/dev/null || die
		eapply "${FILESDIR}/librsvg-2.60.0-offline.patch"
	popd 2>&1 >/dev/null || die
	pushd "${WORKDIR}/vips-${VERSION_VIPS}" 2>&1 >/dev/null || die
		eapply "${FILESDIR}/vips-8.16.1-quantise-c-cast-pointers.patch"
		eapply "${FILESDIR}/vips-8.16.1-suffix.patch"
	popd 2>&1 >/dev/null || die
	echo "VERSION_MOZJPEG_COMMIT=${VERSION_MOZJPEG_COMMIT}" >> "${S}/versions.properties" || die
	pushd "${WORKDIR}/libwebp-${VERSION_WEBP}" 2>&1 >/dev/null || die
		eapply "${FILESDIR}/libwebp-1.6.0-configure-fix.patch"
	popd 2>&1 >/dev/null || die
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
eerror "ARCH=${ARCH} ABI=${ABI} is not supported.  Modify ebuild for support."
		die
	fi
}

get_cpu_family() {
# See https://mesonbuild.com/Reference-tables.html#cpu-families
	if [[ "${CHOST}" =~ "alpha" ]] ; then
		echo "alpha"
	elif [[ "${CHOST}" =~ "aarch64" ]] ; then
		echo "aarch64"
	elif [[ "${CHOST}" =~ "arm" ]] ; then
		echo "arm"
	elif [[ "${CHOST}" =~ "i686" ]] ; then
		echo "x86"
	elif [[ "${CHOST}" =~ "loongarch64" ]] ; then
		echo "loongarch64"
	elif [[ "${CHOST}" =~ "mips64-" ]] ; then
		echo "mips64"
	elif [[ "${CHOST}" =~ "mips-" ]] ; then
		echo "mips"
	elif [[ "${CHOST}" =~ "powerpc64" ]] ; then
		echo "ppc64"
	elif [[ "${CHOST}" =~ "powerpc-" ]] ; then
		echo "ppc"
	elif [[ "${CHOST}" =~ "s390x" ]] ; then
		echo "s390x"
	elif [[ "${CHOST}" =~ "s390" ]] ; then
		echo "s390"
	elif [[ "${CHOST}" =~ "sparc64" ]] ; then
		echo "sparc64"
	elif [[ "${CHOST}" =~ "sparc" ]] ; then
		echo "sparc"
	elif [[ "${CHOST}" =~ "x86_64" ]] ; then
		echo "x86_64"
	fi
}
get_cpu() {
	echo "${CHOST%%-*}"
}
get_endian() {
	local endian=$(tc-endian)
	if [[ "${endian}" == "big" ]] ; then
		echo "big"
	elif [[ "${endian}" == "little" ]] ; then
		echo "little"
	else
eerror "Unknown endianness"
		die
	fi
}

gen_meson_ini() {
	local cpu_family=$(get_cpu_family)
	local cpu=$(get_cpu)
	local endian=$(get_endian)
	local libdir=$(get_libdir)
cat <<EOF > "${HOME}/meson.ini"
[host_machine]
system = 'linux'
cpu_family = '${cpu_family}'
cpu = '${cpu}'
endian = '${endian}'

[binaries]
c = '${CHOST}-gcc'
cpp = '${CHOST}-g++'
ar = 'ar'
nm = 'nm'
ld = 'ld'
strip = 'strip'
ranlib = 'ranlib'

[properties]
have_c99_vsnprintf = true
have_c99_snprintf = true
have_unix98_printf = true

[built-in options]
libdir = '${libdir}'
prefix = '${WORKDIR}/build/deps'
datadir = '${WORKDIR}/build/deps/share'
localedir = '${WORKDIR}/build/deps/share/locale'
sysconfdir = '/etc'
localstatedir = '/var'
wrap_mode = 'nofallback'
EOF
}

setup_arch() {
	local platform=$(get_platform)
	pushd "platforms/${platform}" 2>&1 >/dev/null || die
		export RUSTUP_HOME="${WORKDIR}/rustup_home"
		export CARGO_HOME="${WORKDIR}/cargo_home"
		export PKG_CONFIG="${CHOST}-pkg-config --static"
		export MESON="--cross-file=${HOME}/meson.ini" # Breaks during building glib
		export FLAGS=""
		gen_meson_ini
		#cp -a "meson.ini" "${HOME}" || die
		cp -a "Toolchain.cmake" "${HOME}" || die
		if [[ "${ABI}" == "amd64" && "${ELIBC}" == "glibc" ]] ; then
			if use vanilla ; then
				export FLAGS="-march=nehalem"
			fi
		elif [[ "${ABI}" == "amd64" && "${ELIBC}" == "musl" ]] ; then
			if use vanilla ; then
				export FLAGS="-march=nehalem"
			fi
		elif [[ "${ABI}" == "arm64" && "${ELIBC}" == "glibc" ]] ; then
			if use vanilla ; then
				export FLAGS="-march=armv8-a"
			fi
		elif [[ "${ABI}" == "arm64" && "${ELIBC}" == "musl" ]] ; then
			if use vanilla ; then
				export FLAGS="-march=armv8-a"
			fi
			export RUST_TARGET="aarch64-unknown-linux-musl"
		elif [[ "${CHOST}" == "armv6" && "${ELIBC}" == "glibc" ]] ; then
			if use vanilla ; then
				export FLAGS="-marm -mcpu=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard"
			fi
			export RUST_TARGET="arm-unknown-linux-gnueabihf"
			export WITHOUT_HIGHWAY="true"
			export WITHOUT_NEON="true"
		elif [[ "${CHOST}" =~ "powerpc64le-" && "${ELIBC}" == "glibc" ]] ; then
			if use vanilla ; then
				export FLAGS=""
			fi
			export RUST_TARGET="powerpc64le-unknown-linux-gnu"
		elif [[ "${CHOST}" == "s390x" && "${ELIBC}" == "glibc" ]] ; then
			if use vanilla ; then
				export FLAGS=""
				export FLAGS="-march=z14 -mzvector"
			fi
			export RUST_TARGET="s390x-unknown-linux-gnu"
			export WITHOUT_HIGHWAY="true"
		else
			die "ARCH=${ARCH} ABI=${ABI} is not supported.  Modify ebuild for support."
		fi
	popd 2>&1 >/dev/null || die

}

src_configure() {
	# Debug flags handled by build scripts and to avoid runtime issue.
	filter-flags \
		'-g' \
		'-ggdb*'
	replace-flags '-O*' '-O2'

	if use debug ; then
		replace-flags '-O*' '-O0'
		if ! is-flagq '-O0' ; then
			append-flags '-O0'
		fi
		export MESON_BUILDTYPE="debug"
	else
		export MESON_BUILDTYPE="release"
	fi

	# Reduce issue with pointer corruption or encoutering invalid pointer
	# address ranges
	export MESON_DEFAULT_LIBRARY="static"

	filter-flags -Wl,--as-needed
	local rust_pv=$(rustc --version | cut -f 2 -d " " | cut -f 1 -d "-")
	if [[ -n "${ERUST_SLOT_OVERRIDE}" ]] ; then
		RUST_SLOT="${ERUST_SLOT_OVERRIDE}"
	elif \
		ver_test "${RUST_MIN_VER}" -le "${rust_pv}" \
			&& \
		ver_test "${rust_pv}" -le "${RUST_MAX_VER}" \
	; then
		:
	else
eerror
eerror "Use \`eselect rust\` to switch to"
eerror "Rust ${RUST_MIN_VER} <= x <= ${RUST_MAX_VER}"
eerror
		die
	fi
	if ! has_version "dev-util/sccache" ; then
einfo "Didn't detect sccache.  Removing sccache environment variables."
		unset RUSTC_WRAPPER
		unset SCCACHE_DIR
		unset SCCACHE_MAX_FRAME_LENGTH
	fi

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

einfo "RUST_SLOT:  ${RUST_SLOT}"
	local rust_type=""
	if [[ -n "${ERUST_TYPE_OVERRIDE}" ]] ; then
		rust_type="${ERUST_TYPE_OVERRIDE}"
	elif has_version "dev-lang/rust-bin:${RUST_SLOT}" ; then
		rust_type="binary"
	elif has_version "dev-lang/rust:${RUST_SLOT}" ; then
		rust_type="source"
	else
		die "You must select a Rust ${RUST_MIN_VER} <= x <= ${RUST_MAX_VER}"
	fi

	local rust_path=$(get_rust_path "${EPREFIX}" "${RUST_SLOT}" "${rust_type}")
	export PATH="${rust_path}/bin:${PATH}"
einfo "PATH:  ${PATH}"

	strip-unsupported-flags

	if use cpu_flags_x86_sse4 ; then
		export USE_SSE4="1"
	fi

	if use vanilla ; then
		export VANILLA=1
		strip-flags
	else
		export VANILLA=0
		cflags-hardened_append
		rustflags-hardened_append
	fi
	if check-compiler-switch_is_flavor_slot_changed ; then
ewarn "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	unset MESON_CROSS_FILE
	export LIBDIR=$(get_libdir)
	export PLATFORM=$(get_platform)
	export PKG_CONFIG_LIBDIR=""
	export PKG_CONFIG_PATH=""
	export VERSION_VIPS="${VERSION_VIPS}"
	export VERSION_SHARP_LIBVIPS="${SHARP_VIPS_PV}"
	if use debug ; then
		export DEBUG=1

	# Prevent linker memory spike
		export MAKEFLAGS="-j1"
		export MAKEOPTS="-j1"
		export MAKE_LINK_JOBS="-j1"
		export MESON_LINK_JOBS="-j1"
	else
		export MAKEFLAGS="-j$(makeopts_jobs)"
		export MAKEOPTS="-j$(makeopts_jobs)"
		export MAKE_LINK_JOBS="-j$(makeopts_jobs)"
		export MESON_LINK_JOBS="-j$(makeopts_jobs)"
	fi
einfo "MAKEOPTS:  ${MAKEOPTS}"
einfo "MAKE_LINK_JOBS:  ${MAKE_LINK_JOBS}"
einfo "MESON_LINK_JOBS:  ${MESON_LINK_JOBS}"
	setup_arch

	export USE_AOM=${USE_AOM:-1}
	export USE_ARCHIVE=${USE_ARCHIVE:-1}
	export USE_CAIRO=${USE_CAIRO:-1}
	export USE_CGIF=${USE_CGIF:-1}
	export USE_EXIF=${USE_EXIF:-1}
	export USE_EXPAT=1
	export USE_FFI=${USE_FFI:-1}
	export USE_FONTCONFIG=${USE_FONTCONFIG:-1}
	export USE_FREETYPE=${USE_FREETYPE:-1}
	export USE_FRIBIDI=${USE_FRIBIDI:-1}
	export USE_GLIB=1
	export USE_HARFBUZZ=${USE_HARFBUZZ:-1}
	export USE_HEIF=${USE_HEIF:-1}
	export USE_HWY=${USE_HWY:-1}
	export USE_IMAGEQUANT=${USE_IMAGEQUANT:-1}
	export USE_LCMS2=${USE_LCMS2:-1}
	export USE_MOZJPEG=${USE_MOZJPEG:-1}
	export USE_PANGO=${USE_PANGO:-1}
	export USE_PIXMAN=${USE_PIXMAN:-1}
	export USE_PNG16=${USE_PNG16:-1}
	export USE_RSVG=${USE_RSVG:-1}
	export USE_TIFF=${USE_TIFF:-1}
	export USE_WEBP=${USE_WEBP:-1}
	export USE_XML2=${USE_XML2:-1}
	export USE_ZLIB_NG=${USE_ZLIB_NG:-1}
	export USE_UHDR=${USE_UHDR:-1}

	if use elibc_musl ; then
		export USE_PROXY_LIBINTL=1
	else
		export USE_PROXY_LIBINTL=0
	fi

	if [[ "${USE_RSVG}" == "1" ]] ; then
		export USE_CAIRO=1
		export USE_GLIB=1
		export USE_FFI=1
		export USE_FONTCONFIG=1
		export USE_FREETYPE=1
		export USE_HARFBUZZ=1
		export USE_PANGO=1
		export USE_PIXMAN=1
		export USE_PNG16=1
		export USE_XML2=1
		export USE_ZLIB_NG=1
	fi

	if [[ "${USE_PANGO}" == "1" ]] ; then
		export USE_CAIRO=1
		export USE_FRIBIDI=1
		export USE_FONTCONFIG=1
		export USE_FREETYPE=1
		export USE_GLIB=1
		export USE_HARFBUZZ=1
	fi

	if [[ "${USE_CAIRO}" == "1" ]] ; then
		export USE_GLIB=1
		export USE_PIXMAN=1
		export USE_PNG16=1
		export USE_FONTCONFIG=1
		export USE_FREETYPE=1
	fi

	if [[ "${USE_GLIB}" == "1" ]] ; then
		export USE_FFI=1
		export USE_ZLIB_NG=1
	fi

	if [[ "${USE_FONTCONFIG}" == "1" ]] ; then
		export USE_EXPAT=1
	fi

	if [[ "${USE_FREETYPE}" == "1" ]] ; then
		export USE_HARFBUZZ=1
		export USE_PNG16=1
		export USE_ZLIB_NG=1
	fi

	if [[ "${USE_HEIF}" == "1" ]] ; then
		export USE_AOM=1
		export USE_WEBP=1
	fi

	if [[ "${USE_PNG16}" == "1" ]] ; then
		USE_ZLIB_NG=1
	fi

	if [[ "${USE_TIFF}" == "1" ]] ; then
		USE_ZLIB_NG=1
	fi

	if [[ "${USE_UHDR}" == "1" ]] ; then
		USE_MOZJPEG=1
	fi
}

src_compile() {
	mkdir -p "${WORKDIR}/build" || die
	mkdir -p "${WORKDIR}/packaging" || die
	bash "${S}/build/posix.sh" || die
}

is_debug_whitelisted() {
	local WHITELIST=(
		"vips"
	)
	local name="${1}"
	local x
	for x in ${WHITELIST[@]} ; do
		if [[ "${name}" == "${x}" ]] ; then
			return 0
		fi
	done
	return 1
}

src_install() {
	if use debug && [[ "${FEATURES}" =~ "splitdebug" ]] ; then
		export STRIP="/bin/true"
	fi
	local libdir=$(get_libdir)
	insinto "/usr/lib/sharp-vips/${libdir}"
	# Install shared and static libraries
	if [[ -d "${WORKDIR}/build/deps/${libdir}-original" ]] ; then
		if ls "${WORKDIR}/build/deps/${libdir}-original/"*".so"* >/dev/null 2>&1 ; then
			doins -r "${WORKDIR}/build/deps/${libdir}-original/"*".so"*
		fi
		if ls "${WORKDIR}/build/deps/${libdir}-original/"*".a" >/dev/null 2>&1 ; then
			doins -r "${WORKDIR}/build/deps/${libdir}-original/"*".a"
		fi
	elif [[ -d "${WORKDIR}/build/deps/${libdir}" ]] ; then
		if ls "${WORKDIR}/build/deps/${libdir}/"*".so"* >/dev/null 2>&1 ; then
			doins -r "${WORKDIR}/build/deps/${libdir}/"*".so"*
		fi
		if ls "${WORKDIR}/build/deps/${libdir}/"*".a" >/dev/null 2>&1 ; then
			doins -r "${WORKDIR}/build/deps/${libdir}/"*".a"
		fi
	else
eerror
eerror "No libraries found in ${WORKDIR}/build/deps/${libdir}"
eerror "or ${libdir}-original"
eerror
		die
	fi

	# Install binaries for debugging
	insinto "/usr/lib/sharp-vips/bin"
	if [[ -d "${WORKDIR}/build/deps/bin" ]] ; then
		doins -r "${WORKDIR}/build/deps/bin/"*
	fi

	# Install share
	insinto "/usr/lib/sharp-vips/share"
	if [[ -d "${WORKDIR}/build/deps/share" ]] ; then
		doins -r "${WORKDIR}/build/deps/share/"*
	fi

	insinto "/usr/lib/sharp-vips/${libdir}/pkgconfig"
	# Install .pc files
	if [[ -d "${WORKDIR}/build/deps/${libdir}/pkgconfig" ]] ; then
		doins "${WORKDIR}/build/deps/${libdir}/pkgconfig/"*".pc"
	fi
	if [[ -d "${WORKDIR}/vips-${VERSION_VIPS}/_build/meson-private" ]] ; then
		doins "${WORKDIR}/vips-${VERSION_VIPS}/_build/meson-private/"*".pc"
	fi


# Libs: -L\${libdir} -lvips -ltiff -larchive -lspng -lz -ljpeg -lwebp -lwebpmux \
# -lwebpdemux -lheif -limagequant -lcgif -lexif -lrsvg-2 -lcairo-gobject \
# -lxml2 -lpangocairo-1.0 -lpangoft2-1.0 -lpango-1.0 -lgio-2.0 -lgobject-2.0 \
# -lcairo -lpng16 -lfontconfig -lexpat -lharfbuzz -lfreetype -lpixman-1 \
# -lgmodule-2.0 -lglib-2.0 -llcms2 -lhwy -laom -lsharpyuv -lm -lffi -lfribidi \
# -ldl -lmd -latomic -lstdc++ -pthread
	# DO NOT SORT CONDITIONALS
	local vips_cflags=()
	local vips_libs=(
		"-lvips"
	)

	# DO NOT SORT CONDITIONALS
	if [[ "${USE_TIFF}" == "1" ]] ; then
		vips_libs+=(
			"-ltiff"
		)
	fi
	if [[ "${USE_ARCHIVE}" == "1" ]] ; then
		vips_libs+=(
			"-larchive"
		)
	fi
	if [[ "${USE_ZLIB_NG}" == "1" ]] ; then
		vips_libs+=(
			"-lz"
		)
	fi
	if [[ "${USE_MOZJPEG}" == "1" ]] ; then
		vips_libs+=(
			"-ljpeg"
		)
	fi
	if [[ "${USE_WEBP}" == "1" ]] ; then
		vips_libs+=(
			"-lwebp"
			"-lwebpmux"
			"-lwebpdemux"
		)
	fi
	if [[ "${USE_HEIF}" == "1" ]] ; then
		vips_libs+=(
			"-lheif"
		)
	fi
	if [[ "${USE_IMAGEQUANT}" == "1" ]] ; then
		vips_libs+=(
			"-limagequant"
		)
	fi
	if [[ "${USE_CGIF}" == "1" ]] ; then
		vips_libs+=(
			"-lcgif"
		)
	fi
	if [[ "${USE_EXIF}" == "1" ]] ; then
		vips_libs+=(
			"-lexif"
		)
	fi
	if [[ "${USE_RSVG}" == "1" ]] ; then
		vips_libs+=(
			"-lrsvg-2"
		)
	fi
	if [[ "${USE_CAIRO}" == "1" ]] ; then
		vips_libs+=(
			"-lcairo-gobject"
		)
	fi
	if [[ "${USE_XML2}" == "1" ]] ; then
		vips_libs+=(
			"-lxml2"
		)
	fi
	if [[ "${USE_PANGO}" == "1" ]] ; then
		vips_libs+=(
			"-lpangocairo-1.0"
			"-lpangoft2-1.0"
			"-lpango-1.0"
		)
	fi
	if [[ "${USE_GLIB}" == "1" ]] ; then
		vips_libs+=(
			"-lgio-2.0"
			"-lgobject-2.0"
		)
	fi
	if [[ "${USE_CAIRO}" == "1" ]] ; then
		vips_libs+=(
			"-lcairo"
		)
	fi
	if [[ "${USE_PNG16}" == "1" ]] ; then
		vips_libs+=(
			"-lpng16"
		)
		vips_cflags+=(
			"-DPNG16_STATIC"
		)
	fi
	if [[ "${USE_FONTCONFIG}" == "1" ]] ; then
		vips_libs+=(
			"-lfontconfig"
		)
	fi
	if [[ "${USE_EXPAT}" == "1" ]] ; then
		vips_libs+=(
			"-lexpat"
		)
	fi
	if [[ "${USE_HARFBUZZ}" == "1" ]] ; then
		vips_libs+=(
			"-lharfbuzz"
		)
	fi
	if [[ "${USE_FREETYPE}" == "1" ]] ; then
		vips_libs+=(
			"-lfreetype"
		)
	fi
	if [[ "${USE_PIXMAN}" == "1" ]] ; then
		vips_libs+=(
			"-lpixman-1"
		)
	fi
	if [[ "${USE_GLIB}" == "1" ]] ; then
		vips_libs+=(
			"-lgmodule-2.0"
			"-lglib-2.0"
		)
	fi
	if [[ "${USE_LCMS2}" == "1" ]] ; then
		vips_libs+=(
			"-llcms2"
		)
	fi
	if [[ "${USE_HWY}" == "1" ]] ; then
		vips_libs+=(
			"-lhwy"
		)
	fi
	if [[ "${USE_AOM}" == "1" ]] ; then
		vips_libs+=(
			"-laom"
		)
	fi
	if [[ "${USE_WEBP}" == "1" ]] ; then
		vips_libs+=(
			"-lsharpyuv"
		)
	fi
	vips_libs+=(
		"-lm"
	)
	if [[ "${USE_FFI}" == "1" ]] ; then
		vips_libs+=(
			"-lffi"
		)
	fi
	if [[ "${USE_FRIBIDI}" == "1" ]] ; then
		vips_libs+=(
			"-lfribidi"
		)
	fi
	vips_libs+=(
		"-ldl"
		"-lmd"
		"-latomic"
		"-lstdc++"
		"-pthread"
	)

	# Manually generate to dedupe and to control linking order
	if [[ -d "${ED}/usr/lib/sharp-vips/${libdir}/pkgconfig" ]] ; then
cat <<EOF > "${ED}/usr/lib/sharp-vips/${libdir}/pkgconfig/vips.pc" || die
prefix=/usr/lib/sharp-vips
exec_prefix=\${prefix}
libdir=\${prefix}/${libdir}
includedir=\${prefix}/include

Name: vips
Description: VIPS image processing library
Version: ${PV}
Libs: -L\${libdir} ${vips_libs[@]}
Cflags: -I\${includedir} -I\${includedir}/glib-2.0 -I\${libdir}/glib-2.0/include ${vips_cflags[@]}
EOF

cat <<EOF > "${ED}/usr/lib/sharp-vips/${libdir}/pkgconfig/vips-cpp.pc" || die
prefix=/usr/lib/sharp-vips
exec_prefix=\${prefix}
libdir=\${prefix}/${libdir}
includedir=\${prefix}/include

Name: vips-cpp
Description: VIPS C++ binding
Version: ${PV}
Requires: vips
Libs: -L\${libdir} -lvips-cpp
Cflags: -I\${includedir}
EOF
	fi

	# Install include
	insinto "/usr/lib/sharp-vips/include"
	if [[ -d "${WORKDIR}/build/deps/include" ]] ; then
		doins -r "${WORKDIR}/build/deps/include/"*
	fi

	# Install glib-2.0/include (for glibconfig.h)
	insinto "/usr/lib/sharp-vips/${libdir}/glib-2.0/include"
	if [[ -d "${WORKDIR}/build/deps/${libdir}/glib-2.0/include" ]] ; then
		doins -r "${WORKDIR}/build/deps/${libdir}/glib-2.0/include/"*
	else
eerror
eerror "No glib-2.0/include directory found in"
eerror "${WORKDIR}/build/deps/${libdir}/glib-2.0/include"
eerror
		die
	fi

	# Create symlinks for shared libraries
	if [[ -f "${ED}/usr/lib/sharp-vips/${libdir}/libvips-cpp.so.${PV}" ]] ; then
		ln -sf \
			"libvips-cpp.so.${PV}" \
			"${ED}/usr/lib/sharp-vips/${libdir}/libvips-cpp.so" \
			|| die "Failed to create libvips-cpp.so symlink"
	fi
	if [[ -f "${ED}/usr/lib/sharp-vips/${libdir}/libvips.so.${PV}" ]] ; then
		ln -sf \
			"libvips.so.${PV}" \
			"${ED}/usr/lib/sharp-vips/${libdir}/libvips.so" \
			|| die "Failed to create libvips.so symlink"
	fi

	# Install tarball for debugging
	insinto "/usr/lib/sharp-vips"
	doins "${WORKDIR}/packaging/sharp-libvips-${PLATFORM}.tar.gz"

	local L=(
		"cjpeg"
		"djpeg"
		"gdbus-codegen"
		"glib-compile-resources"
		"glib-genmarshal"
		"glib-gettextize"
		"glib-mkenums"
		"gobject-query"
		"gtester"
		"gtester-report"
		"jpegtran"
		"rdjpgcom"
		"vips"
		"vipsedit"
		"vipsheader"
		"vipsprofile"
		"vipsthumbnail"
		"wrjpgcom"
	)
	local x
	for x in ${L[@]} ; do
		[[ -e "${ED}/usr/lib/sharp-vips/bin/${x}" ]] || continue
		fperms 0755 "/usr/lib/sharp-vips/bin/${x}"
	done

	if use debug && [[ "${FEATURES}" =~ "splitdebug" ]] ; then
		for x in ${L[@]} ; do
			[[ -e "${ED}/usr/lib/sharp-vips/bin/${x}" ]] || continue
			if \
				file "${ED}/usr/lib/sharp-vips/bin/${x}" \
					| grep -q "ELF.*executable.*with debug_info" \
			; then
				:
			else
				continue
			fi
			if is_debug_whitelisted "${x}" ; then
				objcopy \
					--only-keep-debug \
					"${ED}/usr/lib/sharp-vips/bin/${x}" \
					"${T}/${x}.debug" \
					|| die
				exeinto "/usr/lib/debug/usr/lib/sharp-vips/bin/${x}"
				doexe "${T}/${x}.debug"
			fi
			strip \
				--strip-unneeded \
				"${ED}/usr/lib/sharp-vips/bin/${x}" \
				|| die
		done
	fi
}
