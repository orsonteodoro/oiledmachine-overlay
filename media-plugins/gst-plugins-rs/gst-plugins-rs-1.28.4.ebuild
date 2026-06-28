# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# The lockfile should be updated once a week for security reasons.

# 1.26.6 -> 1.26.7
# 1.26.7 -> 1.26.9
# 1.26.9 -> 1.28.0
# 1.28.0 -> 1.28.1
# 1.28.1 -> 1.28.2
# 1.28.2 -> 1.28.4

EAPI=8

# D12-slim
# The versioning is based on the tag with the gstreamer- prefix.

# For plugin renames see RENAMES variable in
# https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/blob/main/dependencies.py?ref_type=heads

_gst_plugins_rs_globals() {
	LOCKFILE_SOURCE="ebuild" # ebuild or upstream
	GENERATE_LOCKFILE=${GENERATE_LOCKFILE:-0} # DO NOT USE.  Manually update instead.  Set to 1 if generating lockfile
	if [[ "${GENERATE_LOCKFILE}" == "1" ]] ; then
einfo "Generating lockfile"
	fi
}
_gst_plugins_rs_globals
unset -f _gst_plugins_rs_globals

MY_PV="${PV}"

RUSTFLAGS_HARDENED_USE_CASES="multithreaded-confidential network p2p plugin secure-critical sensitive-data server untrusted-data"
EXPECTED_BUILD_FILES_FINGERPRINT="disable"
GST_PV="${MY_PV}"
LLVM_COMPAT=( 22 ) # For clang-sys ; slot must be updated when rust slot is changed
LLVM_MAX_SLOT="22"
PYTHON_COMPAT=( "python3_"{8..11} )
RUST_MAX_VER="1.93.1"
RUST_MIN_VER="1.93.1" # LLVM 21.1

GSTREAMER_RS_COMMIT="7b35c8f7671bc0fb3c6498474d105b4d3f26aea5" # ID from GIT_CRATES in [gstreamer] row

MODULES=(
	"analytics"
	"audiofx"
	"audioparsers"
	"burn"
	"aws"
	"cdg"
	"claxon"
	"closedcaption"
	"csound"
	"dav1d"
	"debugseimetainserter"
	"demucs"
	"deepgram"
	"doc"
	"elevenlabs"
	"examples"
	"fallbackswitch"
	"ffv1"
	"file"
	"flavors"
	"gif"
	"gopbuffer"
	"gtk4"
	"hlsmultivariantsink"
	"hlssink3"
	"hsv"
	"inter"
	"icecast"
	"isobmff"
	"json"
	"lewton"
	"livesync"
	"mpegtslive"
	"ndi"
	"onvif"
	"originalbuffer"
	"png"
	"quinn"
	"raptorq"
	"rav1e"
	"regex"
	"reqwest"
	"rtp"
	"rtsp"
	"skia"
	"speechmatics"
	"spotify"
	"sodium"
	"streamgrouper"
#	"tests"
	"textahead"
	"textwrap"
	"textaccumulate"
	"threadshare"
	"togglerecord"
	"tracers"
	"uriplaylistbin"
	"validate"
	"videofx"
	"vvdec"
	"webp"
	"webrtc"
	"webrtc-aws"
	"webrtc-livekit"
	"webrtchttp"
	"whisper"
)

PATENT_STATUS_IUSE=(
	"patent_status_nonfree"
)

CHKL_TIMESTAMPS=(
	"dev-libs/glib-2.89.9999"
	"dev-libs/libsodium-9999"
	"dev-libs/openssl-4.0.9999"
	"dev-libs/openssl-3.6.9999"
	"dev-libs/openssl-3.5.9999"
	"dev-libs/openssl-3.4.9999"
	"dev-libs/openssl-3.3.9999"
	"dev-libs/openssl-3.0.9999"
	"gui-libs/gtk-4.23.9999"
	"media-libs/dav1d-9999"
	"media-libs/fontconfig-9999"
	"media-libs/freetype-9999"
	"media-libs/harfbuzz-9999"
	"media-libs/libwebp-9999"
	"media-libs/vvdec-9999"
	"media-sound/csound-9999"
	"x11-libs/cairo-9999"
	"x11-libs/pango-9999"
)

inherit chkl rustflags-hardened flag-o-matic lcnr llvm meson multilib-build
inherit python-any-r1 rust sandbox-changes toolchain-funcs secure-version multilib-minimal

if [[ "${MY_PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_COMMIT="HEAD"
	EGIT_COMMIT_FALLBACK="ab849943313733feff0d302a67d4dabc75495300" # Sept 9, 2025
	EGIT_REPO_URI="https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs.git"
	MY_PV="9999"
	inherit git-r3
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${PN}-${MY_PV}"
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/gst-plugins-rs-gstreamer-${MY_PV}"
	SRC_URI+="
https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/gstreamer-${MY_PV}/gst-plugins-rs-gstreamer-${MY_PV}.tar.bz2
fetch+https://gitlab.freedesktop.org/gstreamer/gstreamer-rs/-/archive/${GSTREAMER_RS_COMMIT}/gstreamer-rs-${GSTREAMER_RS_COMMIT}.tar.gz -> gstreamer-rs-${GSTREAMER_RS_COMMIT}.gl.tar.gz
	"
	if [[ "${GENERATE_LOCKFILE}" == "1" ]] ; then
		:
	else
# To update packages manually:
# cargo update -p rustls-webpki@0.103.13
# cargo update -p rand@0.8.6
# Do not use the `cargo-audit audit fix` because it doesn't do anything.
# rustls-webpki@0.103.13	# GHSA-82j2-j2ch-gfr8; ZC, DoS; High
#				# GHSA-pwjx-qhcg-rvj4; DT; Moderate
#				# GHSA-xgp8-3hg3-c2mh; DT; Low
#				# GHSA-965h-392x-2mh5; DT; Low
# rand@0.8.6			# GHSA-cq8v-f236-94qc;;Low
#
CRATES="
addr2line-0.24.2
adler2-2.0.1
aes-0.8.4
ahash-0.8.12
aho-corasick-1.1.4
aligned-0.4.3
aligned-vec-0.5.0
aligned-vec-0.6.4
allocator-api2-0.2.21
android_system_properties-0.1.5
anstream-0.3.2
anstream-1.0.0
anstyle-1.0.14
anstyle-parse-0.2.7
anstyle-parse-1.0.0
anstyle-query-1.1.5
anstyle-wincon-1.0.2
anstyle-wincon-3.0.11
anyhow-1.0.102
anymap3-1.1.0
arbitrary-1.4.2
arg_enum_proc_macro-0.3.4
array-init-2.1.0
arrayvec-0.7.6
ash-0.38.0+1.3.281
asn1-rs-0.7.2
asn1-rs-derive-0.6.0
asn1-rs-impl-0.2.0
as-slice-0.2.1
async-channel-2.5.0
async-compression-0.4.36
async-lock-3.4.1
async-recursion-1.1.1
async-stream-0.3.6
async-stream-impl-0.3.6
async-task-4.7.1
async-trait-0.1.89
async-tungstenite-0.34.1
atomic_float-1.1.0
atomic_refcell-0.1.14
atomic-waker-1.1.2
autocfg-1.5.1
av1-grain-0.2.4
av-data-0.4.4
av-scenechange-0.14.1
aws-config-1.8.11
aws-credential-types-1.2.10
aws-runtime-1.5.16
aws-sdk-kinesisvideo-1.22.0
aws-sdk-kinesisvideosignaling-1.21.0
aws-sdk-polly-1.22.0
aws-sdk-s3-1.24.0
aws-sdk-sso-1.21.0
aws-sdk-sts-1.94.0
aws-sdk-transcribestreaming-1.21.0
aws-sdk-translate-1.21.0
aws-sigv4-1.3.6
aws-smithy-async-1.2.14
aws-smithy-checksums-0.60.13
aws-smithy-eventstream-0.60.13
aws-smithy-http-0.60.12
aws-smithy-http-0.62.5
aws-smithy-http-0.63.6
aws-smithy-http-client-1.1.4
aws-smithy-json-0.60.7
aws-smithy-json-0.61.7
aws-smithy-observability-0.1.4
aws-smithy-query-0.60.8
aws-smithy-runtime-1.9.4
aws-smithy-runtime-api-1.12.3
aws-smithy-runtime-api-macros-1.0.0
aws-smithy-types-1.5.0
aws-smithy-xml-0.60.12
aws-types-1.3.10
backtrace-0.3.74
base16ct-0.1.1
base16ct-0.2.0
base32-0.5.1
base64-0.21.7
base64-0.22.1
base64ct-1.6.0
base64-serde-0.8.0
base64-simd-0.8.0
bincode-1.3.3
bincode-2.0.1
bindgen-0.70.1
bindgen-0.71.1
bindgen-0.72.1
bitflags-1.3.2
bitflags-2.13.0
bitreader-0.3.11
bit-set-0.8.0
bitstream-io-4.10.0
bit-vec-0.8.0
block-0.1.6
block2-0.6.2
block-buffer-0.10.4
block-buffer-0.12.1
bs58-0.5.1
bstr-1.10.0
built-0.8.1
bumpalo-3.14.0
burn-0.20.1
burn-backend-0.20.1
burn-core-0.20.1
burn-cpu-0.20.1
burn-cubecl-0.20.1
burn-derive-0.20.1
burn-ir-0.20.1
burn-ndarray-0.20.1
burn-nn-0.20.1
burn-optim-0.20.1
burn-std-0.20.1
burn-store-0.20.1
burn-tensor-0.20.1
burn-wgpu-0.20.1
bytemuck-1.25.0
bytemuck_derive-1.10.2
byteorder-1.5.0
byteorder-lite-0.1.0
byteorder_slice-3.0.0
bytes-1.11.1
byte-slice-cast-1.2.3
bytes-utils-0.1.4
bzip2-0.6.1
c2rust-bitfields-0.20.0
c2rust-bitfields-derive-0.20.0
caseless-0.2.2
cc-1.2.64
cdg-0.1.0
cdg_renderer-0.8.0
cdp-types-0.3.0
cea608-types-0.1.1
cea708-types-0.4.1
cesu8-1.1.0
cexpr-0.6.0
cfg_aliases-0.2.1
cfg-expr-0.15.8
cfg-expr-0.20.8
cfg-if-1.0.4
chacha20-0.10.0
chrono-0.4.45
cipher-0.4.4
clang-sys-1.8.1
clap-4.3.24
clap_builder-4.3.24
clap_derive-4.3.12
clap_lex-0.5.0
claxon-0.4.3
cmake-0.1.58
codespan-reporting-0.12.0
colorchoice-1.0.5
colored-3.1.1
color-name-1.2.0
color_quant-1.1.0
color-thief-0.2.2
combine-4.6.7
compression-codecs-0.4.38
compression-core-0.4.32
comrak-0.39.1
concurrent-queue-2.5.0
console-0.16.0
constant_time_eq-0.3.1
constcat-0.6.1
const-oid-0.10.2
const-oid-0.9.6
const-random-0.1.18
const-random-macro-0.1.16
convert_case-0.10.0
convert_case-0.8.0
cookie-0.18.1
cookie-factory-0.3.3
cookie_store-0.22.0
core-foundation-0.10.1
core-foundation-0.9.4
core-foundation-sys-0.8.7
core-graphics-types-0.2.0
cpufeatures-0.2.17
cpufeatures-0.3.0
crc32c-0.6.8
crc32fast-1.5.0
critical-section-1.2.0
crossbeam-deque-0.8.6
crossbeam-epoch-0.9.18
crossbeam-utils-0.8.21
crunchy-0.2.4
crypto-bigint-0.4.9
crypto-bigint-0.5.5
crypto-common-0.1.7
crypto-common-0.2.2
csound-0.1.8
csound-sys-0.1.2
ctr-0.9.2
ctrlc-3.5.2
cubecl-0.9.0
cubecl-common-0.9.0
cubecl-core-0.9.0
cubecl-cpp-0.9.0
cubecl-cpu-0.9.0
cubecl-cuda-0.9.0
cubecl-ir-0.9.0
cubecl-macros-0.9.0
cubecl-macros-internal-0.9.0
cubecl-opt-0.9.0
cubecl-runtime-0.9.0
cubecl-spirv-0.9.0
cubecl-std-0.9.0
cubecl-wgpu-0.9.0
cubecl-zspace-0.9.0
cubek-0.1.1
cubek-attention-0.1.1
cubek-convolution-0.1.1
cubek-matmul-0.1.1
cubek-quant-0.1.1
cubek-random-0.1.1
cubek-reduce-0.1.1
cudarc-0.18.2
curve25519-dalek-4.1.3
curve25519-dalek-derive-0.1.1
darling-0.20.11
darling-0.21.3
darling-0.23.0
darling_core-0.20.11
darling_core-0.21.3
darling_core-0.23.0
darling_macro-0.20.11
darling_macro-0.21.3
darling_macro-0.23.0
dash-mpd-0.20.3
dasp-0.11.0
dasp_envelope-0.11.0
dasp_frame-0.11.0
dasp_interpolate-0.11.0
dasp_peak-0.11.0
dasp_ring_buffer-0.11.0
dasp_rms-0.11.0
dasp_sample-0.11.0
dasp_signal-0.11.0
dasp_slice-0.11.0
dasp_window-0.11.1
data-encoding-2.11.0
dav1d-0.11.1
dav1d-sys-0.8.2
deepgram-0.7.0
deflate64-0.1.12
der-0.6.1
der-0.7.10
deranged-0.5.8
derive_builder-0.20.2
derive_builder_core-0.20.2
derive_builder_macro-0.20.2
derive-into-owned-0.2.0
derive_more-2.1.1
derive_more-impl-2.1.1
derive-new-0.7.0
der-parser-10.0.0
deunicode-1.6.2
device-info-0.1.1
diff-0.1.13
digest-0.10.7
digest-0.11.3
dirs-6.0.0
dirs-sys-0.5.0
dispatch2-0.3.1
displaydoc-0.2.6
document-features-0.2.12
dssim-core-3.4.0
dyn-clone-1.0.20
easyfft-0.4.2
ebml-iterable-0.6.3
ebml-iterable-specification-0.4.0
ebml-iterable-specification-derive-0.4.0
ebur128-0.1.10
ecdsa-0.14.8
ecdsa-0.16.9
ed25519-1.5.3
ed25519-2.2.3
ed25519-dalek-2.1.1
edit-distance-2.2.2
either-1.16.0
elliptic-curve-0.12.3
elliptic-curve-0.13.8
embassy-futures-0.1.2
embassy-time-0.4.0
embassy-time-driver-0.2.2
embedded-hal-0.2.7
embedded-hal-1.0.0
embedded-hal-async-1.0.0
encode_unicode-1.0.0
encoding_rs-0.8.35
entities-1.0.1
enumn-0.1.14
enumset-1.1.10
enumset_derive-0.14.0
env_filter-1.0.1
env_logger-0.10.2
env_logger-0.11.10
equator-0.4.2
equator-macro-0.4.2
equivalent-1.0.2
errno-0.3.14
etherparse-0.19.0
event-listener-5.4.1
event-listener-strategy-0.5.4
fallible-iterator-0.3.0
fastbloom-0.14.1
fastrand-2.4.1
fdeflate-0.3.7
ff-0.12.1
ff-0.13.1
fiat-crypto-0.2.9
field-offset-0.3.6
filetime-0.2.27
find-msvc-tools-0.1.9
fixedbitset-0.4.2
flate2-1.1.9
float4-0.1.0
float8-0.4.0
float-ord-0.3.2
flume-0.12.0
fnv-1.0.7
foldhash-0.1.5
foldhash-0.2.0
foreign-types-0.5.0
foreign-types-macros-0.2.3
foreign-types-shared-0.3.1
form_urlencoded-1.2.2
fs_extra-1.3.0
fslock-0.2.1
fst-0.4.7
futures-0.3.31
futures-channel-0.3.32
futures-core-0.3.32
futures-executor-0.3.31
futures-io-0.3.32
futures-lite-2.6.1
futures-macro-0.3.32
futures-sink-0.3.32
futures-task-0.3.32
futures-timer-3.0.4
futures-util-0.3.32
g2gen-1.2.2
g2p-1.2.2
g2poly-1.2.2
generic-array-0.14.7
generic_singleton-0.5.1
getifaddrs-0.6.2
getrandom-0.2.17
getrandom-0.3.4
getrandom-0.4.2
gif-0.14.2
gimli-0.31.1
gl_generator-0.14.0
glob-0.3.3
glow-0.16.0
glutin_wgl_sys-0.6.1
governor-0.10.4
gpu-alloc-0.6.0
gpu-allocator-0.27.0
gpu-alloc-types-0.3.0
gpu-descriptor-0.3.2
gpu-descriptor-types-0.2.0
group-0.12.1
group-0.13.0
h2-0.3.27
h2-0.4.15
half-2.7.1
hashbrown-0.12.3
hashbrown-0.13.2
hashbrown-0.15.5
hashbrown-0.16.1
hashbrown-0.17.1
headers-0.4.1
headers-core-0.3.0
heck-0.4.1
heck-0.5.0
hermit-abi-0.5.2
hex-0.4.3
hexf-parse-0.2.1
hkdf-0.12.4
hmac-0.12.1
home-0.5.5
hound-3.5.1
hrtf-0.8.1
http-0.2.12
http-1.4.2
httparse-1.10.1
http-body-0.4.6
http-body-1.0.1
http-body-util-0.1.3
httpdate-1.0.3
human_bytes-0.4.3
humantime-2.3.0
hxdmp-0.2.1
hybrid-array-0.4.12
hyper-0.14.32
hyper-1.10.1
hyper-proxy2-0.1.0
hyper-rustls-0.24.2
hyper-rustls-0.26.0
hyper-rustls-0.27.2
hyper-util-0.1.20
hyphenation-0.8.4
hyphenation_commons-0.8.4
iana-time-zone-0.1.65
iana-time-zone-haiku-0.1.2
icu_collections-1.5.0
icu_collections-2.2.0
icu_locale-2.2.0
icu_locale_core-2.2.0
icu_locale_data-2.2.0
icu_locid-1.5.0
icu_locid_transform-1.5.0
icu_locid_transform_data-1.5.1
icu_normalizer-1.5.0
icu_normalizer_data-1.5.1
icu_properties-1.5.1
icu_properties_data-1.5.1
icu_provider-1.5.0
icu_provider-2.2.0
icu_provider_macros-1.5.0
icu_segmenter-2.2.0
icu_segmenter_data-2.2.0
id-arena-2.3.0
ident_case-1.0.1
idna-1.1.0
idna_adapter-1.2.0
image-0.25.4
image_hasher-3.1.1
imgref-1.12.2
indexmap-1.9.3
indexmap-2.14.0
indicatif-0.18.4
inout-0.1.4
interpolate_name-0.2.4
ipnet-2.12.0
is-docker-0.2.0
iso8601-0.6.3
is-terminal-0.4.17
is_terminal_polyfill-1.48.2
is-wsl-0.4.0
itertools-0.11.0
itertools-0.13.0
itertools-0.14.0
itoa-1.0.18
jiff-0.2.28
jiff-static-0.2.28
jni-0.21.1
jni-0.22.4
jni-macros-0.22.4
jni-sys-0.3.0
jni-sys-0.4.1
jni-sys-macros-0.4.1
jobserver-0.1.34
jsonwebtoken-10.4.0
js-sys-0.3.82
khronos_api-3.1.0
khronos-egl-6.0.0
kstring-2.0.0
lazy_static-1.5.0
leb128fmt-0.1.0
lewton-0.10.2
libbz2-rs-sys-0.2.5
libc-0.2.186
libfuzzer-sys-0.4.13
libloading-0.8.8
libloading-0.9.0
liblzma-0.4.6
liblzma-sys-0.4.6
libm-0.2.16
libredox-0.1.17
librespot-audio-0.8.0
librespot-core-0.8.0
librespot-metadata-0.8.0
librespot-oauth-0.8.0
librespot-playback-0.8.0
librespot-protocol-0.8.0
libsodium-sys-0.2.7
libwebp-sys2-0.1.11
libwebp-sys2-0.2.0
linux-raw-sys-0.12.1
linux-raw-sys-0.4.15
litemap-0.7.3
litemap-0.8.2
litrs-1.0.0
livekit-api-0.4.24
livekit-protocol-0.7.8
livekit-runtime-0.4.0
lock_api-0.4.14
log-0.4.29
lru-0.12.5
lru-0.16.4
lru-slab-0.1.2
lzma-rust2-0.15.8
m3u8-rs-6.0.0
malloc_buf-0.0.6
matchers-0.2.0
matrixmultiply-0.3.10
maybe-rayon-0.1.1
md-5-0.10.6
md-5-0.11.0
md5-0.8.0
memchr-2.8.2
memmap2-0.9.10
memoffset-0.9.1
metal-0.32.0
mime-0.3.17
mime_guess-2.0.5
minimal-lexical-0.2.1
miniz_oxide-0.8.9
mio-1.2.1
more-asserts-0.3.1
mp4-atom-0.10.1
muldiv-1.0.1
multimap-0.8.3
mykey-1.0.0
naga-26.0.0
nasm-rs-0.3.2
nb-0.1.3
nb-1.1.0
ndarray-0.17.2
ndk-sys-0.6.0+11769913
new_debug_unreachable-1.0.6
nix-0.31.3
nnnoiseless-0.5.2
nom-7.1.3
nom-8.0.0
nonzero_ext-0.3.0
noop_proc_macro-0.3.0
no_std_io2-0.9.4
ntapi-0.4.3
nu-ansi-term-0.50.3
num-0.4.3
num-bigint-0.4.6
num-bigint-dig-0.8.6
num-complex-0.4.6
num-conv-0.2.2
num_cpus-1.17.0
num-derive-0.4.2
num-integer-0.1.46
num-iter-0.1.45
num-rational-0.4.2
num_threads-0.1.7
num-traits-0.2.19
oauth2-5.0.0
objc-0.2.7
objc2-0.6.4
objc2-cloud-kit-0.3.2
objc2-core-data-0.3.2
objc2-core-foundation-0.3.2
objc2-core-graphics-0.3.2
objc2-core-image-0.3.2
objc2-core-location-0.3.2
objc2-core-text-0.3.2
objc2-encode-4.1.0
objc2-foundation-0.3.2
objc2-io-kit-0.3.2
objc2-io-surface-0.3.2
objc2-quartz-core-0.3.2
objc2-ui-kit-0.3.2
objc2-user-notifications-0.3.2
object-0.36.7
ogg-0.9.2
oid-registry-0.8.1
once_cell-1.21.4
once_cell_polyfill-1.56.1
open-5.3.5
openssl-probe-0.1.6
option-ext-0.2.0
option-operations-0.6.1
ordered-float-5.0.0
os_info-3.15.0
outref-0.5.2
p256-0.11.1
p256-0.13.2
p384-0.13.1
parking-2.2.1
parking_lot-0.12.5
parking_lot_core-0.9.12
parse_link_header-0.4.1
paste-1.0.15
pastey-0.1.1
pastey-0.2.3
pathdiff-0.2.3
pbjson-0.6.0
pbjson-build-0.6.2
pbjson-types-0.6.0
pbkdf2-0.12.2
pcap-file-2.0.0
pem-3.0.6
pem-rfc7468-0.7.0
percent-encoding-2.3.2
petgraph-0.6.5
pin-project-1.1.10
pin-project-internal-1.1.10
pin-project-lite-0.2.17
pin-utils-0.1.0
pkcs1-0.7.5
pkcs8-0.10.2
pkcs8-0.9.0
pkg-config-0.3.33
plain-0.2.3
png-0.18.1
pocket-resources-0.3.2
polling-3.10.0
portable-atomic-1.13.1
portable-atomic-util-0.2.7
potential_utf-0.1.5
powerfmt-0.2.0
ppmd-rust-1.4.0
ppv-lite86-0.2.21
presser-0.3.1
pretty_assertions-1.4.1
prettyplease-0.2.37
primal-check-0.3.4
primeorder-0.13.6
priority-queue-2.7.0
proc-macro2-1.0.106
proc-macro-crate-3.4.0
profiling-1.0.18
profiling-procmacros-1.0.18
prost-0.12.3
prost-build-0.12.3
prost-derive-0.12.3
prost-types-0.12.3
protobuf-3.7.2
protobuf-codegen-3.7.2
protobuf-json-mapping-3.7.2
protobuf-parse-3.7.2
protobuf-support-3.7.2
psl-types-2.0.11
publicsuffix-2.3.0
pyo3-0.28.3
pyo3-build-config-0.28.3
pyo3-ffi-0.28.3
pyo3-macros-0.28.3
pyo3-macros-backend-0.28.3
quick-xml-0.38.4
quick-xml-0.39.4
quick-xml-0.40.1
quinn-0.11.9
quinn-proto-0.11.14
quinn-udp-0.5.4
quote-1.0.44
rand-0.10.1
rand-0.8.6
rand-0.9.4
rand_chacha-0.3.1
rand_chacha-0.9.0
rand_core-0.10.1
rand_core-0.6.4
rand_core-0.9.5
rand_distr-0.5.1
range-alloc-0.1.5
raptorq-2.0.1
rav1e-0.8.1
rawpointer-0.2.1
raw-window-handle-0.6.2
rayon-1.10.0
rayon-core-1.12.1
rcgen-0.14.0
realfft-3.5.0
redox_syscall-0.5.18
redox_syscall-0.8.1
redox_users-0.5.2
ref-cast-1.0.25
ref-cast-impl-1.0.25
r-efi-5.3.0
r-efi-6.0.0
regex-1.12.4
regex-automata-0.4.14
regex-lite-0.1.9
regex-syntax-0.8.11
renderdoc-sys-1.1.0
reqwest-0.12.28
rfc6979-0.3.1
rfc6979-0.4.0
rgb-0.8.53
ring-0.17.14
rmp-0.8.14
rmp-serde-1.3.1
rqrr-0.10.1
rsa-0.9.10
rtcp-types-0.3.0
rtp-types-0.1.2
rtsp-types-0.1.3
rubato-0.14.1
rustc-demangle-0.1.27
rustc-hash-1.1.0
rustc-hash-2.1.1
rustc_version-0.4.1
rustdct-0.7.1
rustfft-6.4.1
rusticata-macros-4.1.0
rustix-0.38.44
rustix-1.1.4
rustls-0.21.12
rustls-0.22.4
rustls-0.23.40
rustls-native-certs-0.6.3
rustls-native-certs-0.7.3
rustls-native-certs-0.8.0
rustls-pemfile-1.0.4
rustls-pemfile-2.2.0
rustls-pki-types-1.14.1
rustls-platform-verifier-0.6.2
rustls-platform-verifier-0.7.0
rustls-platform-verifier-android-0.1.1
rustls-webpki-0.101.7
rustls-webpki-0.102.8
rustls-webpki-0.103.13
rustversion-1.0.22
ryu-1.0.22
safetensors-0.7.0
same-file-1.0.6
sanitize-filename-0.6.0
schannel-0.1.27
schemars-0.9.0
schemars-1.2.1
scoped-tls-1.0.1
scopeguard-1.2.0
sct-0.7.1
sdp-types-0.1.8
sec1-0.3.0
sec1-0.7.3
security-framework-2.11.1
security-framework-3.6.0
security-framework-sys-2.16.0
semver-1.0.28
serde-1.0.228
serde_bytes-0.11.19
serde_core-1.0.228
serde_derive-1.0.228
serde_json-1.0.149
serde_path_to_error-0.1.20
serde_spanned-0.6.9
serde_spanned-1.1.1
serde_urlencoded-0.7.1
serde_with-3.21.0
serde_with_macros-3.21.0
serial_test-3.5.0
serial_test_derive-3.5.0
sfv-0.14.0
sha1-0.10.6
sha2-0.10.9
sha2-0.11.0
sha256-1.6.0
shannon-0.2.0
sharded-slab-0.1.7
shell-words-1.1.1
shlex-1.3.0
shlex-2.0.1
signal-hook-0.4.4
signal-hook-registry-1.4.8
signalsmith-stretch-0.1.3
signature-1.6.4
signature-2.2.0
simd-adler32-0.3.9
simd_cesu8-1.1.1
simd_helpers-0.1.0
simdutf8-0.1.5
siphasher-1.0.3
skia-bindings-0.93.1
skia-safe-0.93.1
slab-0.4.12
slotmap-1.1.1
slug-0.1.6
smallvec-1.15.2
smawk-0.3.2
socket2-0.5.10
socket2-0.6.4
sodiumoxide-0.2.7
spin-0.10.0
spin-0.9.8
spinning_top-0.3.0
spirv-0.3.0+sdk-1.3.268.0
spki-0.6.0
spki-0.7.3
sprintf-0.4.3
stable_deref_trait-1.2.1
stable-vec-0.4.2
static_assertions-1.1.0
strength_reduce-0.2.4
strsim-0.10.0
strsim-0.11.1
subtle-2.6.1
symphonia-0.5.5
symphonia-bundle-flac-0.5.5
symphonia-bundle-mp3-0.5.5
symphonia-codec-vorbis-0.5.5
symphonia-core-0.5.5
symphonia-format-ogg-0.5.5
symphonia-metadata-0.5.5
symphonia-utils-xiph-0.5.5
syn-1.0.109
syn-2.0.114
sync_wrapper-1.0.2
synstructure-0.13.2
sysinfo-0.36.1
system-configuration-0.7.0
system-configuration-sys-0.6.0
system-deps-6.2.2
system-deps-7.0.4
tar-0.4.46
target-lexicon-0.12.16
target-lexicon-0.13.5
tempfile-3.27.0
termcolor-1.4.1
test-log-0.2.14
test-log-macros-0.2.14
test-with-0.16.3
test-with-derive-0.16.3
textdistance-1.1.1
text_placeholder-0.5.1
textwrap-0.16.1
thiserror-1.0.69
thiserror-2.0.18
thiserror-impl-1.0.69
thiserror-impl-2.0.18
thread_local-1.1.9
time-0.3.49
time-core-0.1.9
time-macros-0.2.29
tiny-keccak-2.0.2
tinystr-0.7.6
tinystr-0.8.3
tinyvec-1.11.0
tinyvec_macros-0.1.1
tokio-1.52.3
tokio-macros-2.7.0
tokio-rustls-0.24.1
tokio-rustls-0.25.0
tokio-rustls-0.26.0
tokio-stream-0.1.18
tokio-tungstenite-0.27.0
tokio-tungstenite-0.28.0
tokio-tungstenite-0.29.0
tokio-util-0.7.18
toml-0.8.23
toml-0.9.6
toml-1.1.2+spec-1.1.0
toml_datetime-0.6.11
toml_datetime-0.7.1
toml_datetime-1.1.1+spec-1.1.0
toml_edit-0.22.27
toml_edit-0.23.5
toml_parser-1.1.2+spec-1.1.0
toml_writer-1.1.1+spec-1.1.0
tower-0.5.3
tower-http-0.6.11
tower-layer-0.3.3
tower-service-0.3.3
tracel-ash-0.38.0+1.3.296
tracel-llvm-20.1.4-7
tracel-llvm-bundler-20.1.4-7
tracel-mlir-rs-20.1.4-7
tracel-mlir-rs-macros-20.1.4-7
tracel-mlir-sys-20.1.4-7
tracel-rspirv-0.12.1+sdk-1.4.341.0
tracel-tblgen-rs-20.1.4-7
tracing-0.1.44
tracing-attributes-0.1.31
tracing-core-0.1.36
tracing-log-0.2.0
tracing-subscriber-0.3.23
transpose-0.2.3
try-lock-0.2.5
tungstenite-0.27.0
tungstenite-0.28.0
tungstenite-0.29.0
typed-arena-2.0.2
typed-path-0.12.3
type-map-0.5.1
typenum-1.20.1
unicase-2.9.0
unicode_categories-0.1.1
unicode-ident-1.0.22
unicode-linebreak-0.1.5
unicode-normalization-0.1.25
unicode-segmentation-1.12.0
unicode-width-0.1.14
unicode-width-0.2.2
unicode-xid-0.2.6
unindent-0.2.4
unit-prefix-0.5.2
untrusted-0.9.0
unty-0.0.4
url-2.5.8
urlencoding-2.1.3
url-escape-0.1.1
utf16_iter-1.0.5
utf-8-0.7.6
utf8_iter-1.0.4
utf8parse-0.2.2
uuid-1.20.0
va_list-0.1.4
valuable-0.1.1
variadics_please-1.0.0
vcpkg-0.2.15
vergen-9.1.0
vergen-gitcl-1.0.8
vergen-lib-0.1.6
vergen-lib-9.1.0
version_check-0.9.5
version-compare-0.2.1
v_frame-0.3.8
void-1.0.2
vsimd-0.8.0
vvdec-0.6.11
vvdec-sys-0.7.0
waker-fn-1.2.0
walkdir-2.5.0
want-0.3.1
warp-0.4.3
wasi-0.11.1+wasi-snapshot-preview1
wasip2-1.0.4+wasi-0.2.12
wasip3-0.4.0+wasi-0.3.0-rc-2026-01-06
wasm-bindgen-0.2.105
wasm-bindgen-futures-0.4.55
wasm-bindgen-macro-0.2.105
wasm-bindgen-macro-support-0.2.105
wasm-bindgen-shared-0.2.105
wasm-encoder-0.244.0
wasm-metadata-0.244.0
wasmparser-0.244.0
wasm-streams-0.4.2
webm-iterable-0.6.4
webpki-0.22.4
webpki-root-certs-1.0.7
webpki-roots-0.26.11
webpki-roots-1.0.7
web-sys-0.3.82
web-time-1.1.0
web-transport-proto-0.6.0
web-transport-quinn-0.11.9
web-transport-trait-0.3.6
weezl-0.1.12
wgpu-26.0.1
wgpu-core-26.0.1
wgpu-core-deps-apple-26.0.0
wgpu-core-deps-emscripten-26.0.0
wgpu-core-deps-windows-linux-android-26.0.0
wgpu-hal-26.0.6
wgpu-types-26.0.0
which-4.4.2
whisper-rs-0.16.0
whisper-rs-sys-0.15.0
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.11
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.56.0
windows-0.58.0
windows-0.61.3
windows_aarch64_gnullvm-0.42.2
windows_aarch64_gnullvm-0.48.5
windows_aarch64_gnullvm-0.52.6
windows_aarch64_gnullvm-0.53.1
windows_aarch64_msvc-0.42.2
windows_aarch64_msvc-0.48.5
windows_aarch64_msvc-0.52.6
windows_aarch64_msvc-0.53.1
windows-collections-0.2.0
windows-core-0.56.0
windows-core-0.58.0
windows-core-0.61.2
windows-future-0.2.1
windows_i686_gnu-0.42.2
windows_i686_gnu-0.48.5
windows_i686_gnu-0.52.6
windows_i686_gnu-0.53.1
windows_i686_gnullvm-0.52.6
windows_i686_gnullvm-0.53.1
windows_i686_msvc-0.42.2
windows_i686_msvc-0.48.5
windows_i686_msvc-0.52.6
windows_i686_msvc-0.53.1
windows-implement-0.56.0
windows-implement-0.58.0
windows-implement-0.60.2
windows-interface-0.56.0
windows-interface-0.58.0
windows-interface-0.59.3
windows-link-0.1.3
windows-link-0.2.1
windows-numerics-0.2.0
windows-registry-0.3.0
windows-result-0.1.2
windows-result-0.2.0
windows-result-0.3.4
windows-strings-0.1.0
windows-strings-0.2.0
windows-strings-0.4.2
windows-sys-0.45.0
windows-sys-0.48.0
windows-sys-0.52.0
windows-sys-0.59.0
windows-sys-0.60.2
windows-sys-0.61.2
windows-targets-0.42.2
windows-targets-0.48.5
windows-targets-0.52.6
windows-targets-0.53.5
windows-threading-0.1.0
windows_x86_64_gnu-0.42.2
windows_x86_64_gnu-0.48.5
windows_x86_64_gnu-0.52.6
windows_x86_64_gnu-0.53.1
windows_x86_64_gnullvm-0.42.2
windows_x86_64_gnullvm-0.48.5
windows_x86_64_gnullvm-0.52.6
windows_x86_64_gnullvm-0.53.1
windows_x86_64_msvc-0.42.2
windows_x86_64_msvc-0.48.5
windows_x86_64_msvc-0.52.6
windows_x86_64_msvc-0.53.1
winnow-0.7.15
winnow-1.0.3
wit-bindgen-0.51.0
wit-bindgen-0.57.1
wit-bindgen-core-0.51.0
wit-bindgen-rust-0.51.0
wit-bindgen-rust-macro-0.51.0
wit-component-0.244.0
wit-parser-0.244.0
write16-1.0.0
writeable-0.5.5
writeable-0.6.3
x25519-dalek-2.0.1
x509-parser-0.18.1
xattr-1.6.1
xml-1.3.0
xmlparser-0.13.6
xml-rs-0.8.27
xmltree-0.12.0
y4m-0.8.0
yansi-1.0.1
yasna-0.5.2
yoke-0.7.4
yoke-0.8.3
yoke-derive-0.7.5
yoke-derive-0.8.2
zerocopy-0.8.52
zerocopy-derive-0.8.52
zerofrom-0.1.8
zerofrom-derive-0.1.6
zeroize-1.8.2
zeroize_derive-1.4.3
zerotrie-0.2.4
zerovec-0.10.4
zerovec-0.11.6
zerovec-derive-0.10.3
zerovec-derive-0.11.3
zip-7.2.0
zlib-rs-0.6.3
zmij-1.0.19
zopfli-0.8.0
zstd-0.13.3
zstd-safe-7.2.4
zstd-sys-2.0.16+zstd.1.5.7
"

# QA: Manually change https://gitlab.freedesktop.org/gstreamer/gstreamer-rs to https://github.com/GStreamer/gst-plugins-rs
declare -A GIT_CRATES=(
[cairo-rs]="https://github.com/gtk-rs/gtk-rs-core;ba575eeaf5c7cf043e55454620e5926593756c67;gtk-rs-core-%commit%/cairo" # 0.22.7
[cairo-sys-rs]="https://github.com/gtk-rs/gtk-rs-core;ba575eeaf5c7cf043e55454620e5926593756c67;gtk-rs-core-%commit%/cairo/sys" # 0.22.7
[ffv1]="https://github.com/rust-av/ffv1;bd9eabfc14c9ad53c37b32279e276619f4390ab8;ffv1-%commit%" # 0.0.0
[flavors]="https://github.com/rust-av/flavors;833508af656d298c269f2397c8541a084264d992;flavors-%commit%" # 0.2.0
[gdk4]="https://github.com/gtk-rs/gtk4-rs;867a6737f36c735865119cff649b059ce337dcb2;gtk4-rs-%commit%/gdk4" # 0.11.3
[gdk4-sys]="https://github.com/gtk-rs/gtk4-rs;867a6737f36c735865119cff649b059ce337dcb2;gtk4-rs-%commit%/gdk4/sys" # 0.11.3
[gdk4-wayland]="https://github.com/gtk-rs/gtk4-rs;867a6737f36c735865119cff649b059ce337dcb2;gtk4-rs-%commit%/gdk4-wayland" # 0.11.3
[gdk4-wayland-sys]="https://github.com/gtk-rs/gtk4-rs;867a6737f36c735865119cff649b059ce337dcb2;gtk4-rs-%commit%/gdk4-wayland/sys" # 0.11.3
[gdk4-win32]="https://github.com/gtk-rs/gtk4-rs;867a6737f36c735865119cff649b059ce337dcb2;gtk4-rs-%commit%/gdk4-win32" # 0.11.3
[gdk4-win32-sys]="https://github.com/gtk-rs/gtk4-rs;867a6737f36c735865119cff649b059ce337dcb2;gtk4-rs-%commit%/gdk4-win32/sys" # 0.11.3
[gdk4-x11]="https://github.com/gtk-rs/gtk4-rs;867a6737f36c735865119cff649b059ce337dcb2;gtk4-rs-%commit%/gdk4-x11" # 0.11.3
[gdk4-x11-sys]="https://github.com/gtk-rs/gtk4-rs;867a6737f36c735865119cff649b059ce337dcb2;gtk4-rs-%commit%/gdk4-x11/sys" # 0.11.3
[gdk-pixbuf]="https://github.com/gtk-rs/gtk-rs-core;ba575eeaf5c7cf043e55454620e5926593756c67;gtk-rs-core-%commit%/gdk-pixbuf" # 0.22.7
[gdk-pixbuf-sys]="https://github.com/gtk-rs/gtk-rs-core;ba575eeaf5c7cf043e55454620e5926593756c67;gtk-rs-core-%commit%/gdk-pixbuf/sys" # 0.22.7
[gio]="https://github.com/gtk-rs/gtk-rs-core;ba575eeaf5c7cf043e55454620e5926593756c67;gtk-rs-core-%commit%/gio" # 0.22.7
[gio-sys]="https://github.com/gtk-rs/gtk-rs-core;ba575eeaf5c7cf043e55454620e5926593756c67;gtk-rs-core-%commit%/gio/sys" # 0.22.7
[glib]="https://github.com/gtk-rs/gtk-rs-core;ba575eeaf5c7cf043e55454620e5926593756c67;gtk-rs-core-%commit%/glib" # 0.22.7
[glib-macros]="https://github.com/gtk-rs/gtk-rs-core;ba575eeaf5c7cf043e55454620e5926593756c67;gtk-rs-core-%commit%/glib-macros" # 0.22.7
[glib-sys]="https://github.com/gtk-rs/gtk-rs-core;ba575eeaf5c7cf043e55454620e5926593756c67;gtk-rs-core-%commit%/glib/sys" # 0.22.7
[gobject-sys]="https://github.com/gtk-rs/gtk-rs-core;ba575eeaf5c7cf043e55454620e5926593756c67;gtk-rs-core-%commit%/glib/gobject-sys" # 0.22.7
[graphene-rs]="https://github.com/gtk-rs/gtk-rs-core;ba575eeaf5c7cf043e55454620e5926593756c67;gtk-rs-core-%commit%/graphene" # 0.22.7
[graphene-sys]="https://github.com/gtk-rs/gtk-rs-core;ba575eeaf5c7cf043e55454620e5926593756c67;gtk-rs-core-%commit%/graphene/sys" # 0.22.7
[gsk4]="https://github.com/gtk-rs/gtk4-rs;867a6737f36c735865119cff649b059ce337dcb2;gtk4-rs-%commit%/gsk4" # 0.11.3
[gsk4-sys]="https://github.com/gtk-rs/gtk4-rs;867a6737f36c735865119cff649b059ce337dcb2;gtk4-rs-%commit%/gsk4/sys" # 0.11.3
[gstreamer-allocators]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-allocators" # 0.25.2
[gstreamer-allocators-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-allocators/sys" # 0.25.2
[gstreamer-analytics]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-analytics" # 0.25.2
[gstreamer-analytics-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-analytics/sys" # 0.25.2
[gstreamer-app]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-app" # 0.25.2
[gstreamer-app-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-app/sys" # 0.25.2
[gstreamer-audio]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-audio" # 0.25.2
[gstreamer-audio-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-audio/sys" # 0.25.2
[gstreamer-base]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-base" # 0.25.2
[gstreamer-base-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-base/sys" # 0.25.2
[gstreamer-check]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-check" # 0.25.2
[gstreamer-check-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-check/sys" # 0.25.2
[gstreamer-gl-egl]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-gl/egl" # 0.25.2
[gstreamer-gl-egl-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-gl/egl/sys" # 0.25.2
[gstreamer-gl]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-gl" # 0.25.2
[gstreamer-gl-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-gl/sys" # 0.25.2
[gstreamer-gl-wayland]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-gl/wayland" # 0.25.2
[gstreamer-gl-wayland-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-gl/wayland/sys" # 0.25.2
[gstreamer-gl-x11]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-gl/x11" # 0.25.2
[gstreamer-gl-x11-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-gl/x11/sys" # 0.25.2
[gstreamer]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer" # 0.25.2
[gstreamer-net]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-net" # 0.25.2
[gstreamer-net-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-net/sys" # 0.25.2
[gstreamer-pbutils]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-pbutils" # 0.25.2
[gstreamer-pbutils-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-pbutils/sys" # 0.25.2
[gstreamer-rtp]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-rtp" # 0.25.2
[gstreamer-rtp-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-rtp/sys" # 0.25.2
[gstreamer-sdp]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-sdp" # 0.25.2
[gstreamer-sdp-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-sdp/sys" # 0.25.2
[gstreamer-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer/sys" # 0.25.2
[gstreamer-tag]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-tag" # 0.25.2
[gstreamer-tag-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-tag/sys" # 0.25.2
[gstreamer-utils]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-utils" # 0.25.2
[gstreamer-validate]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-validate" # 0.25.2
[gstreamer-validate-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-validate/sys" # 0.25.2
[gstreamer-video]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-video" # 0.25.2
[gstreamer-video-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-video/sys" # 0.25.2
[gstreamer-webrtc]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-webrtc" # 0.25.2
[gstreamer-webrtc-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;7b35c8f7671bc0fb3c6498474d105b4d3f26aea5;gstreamer-rs-%commit%/gstreamer-webrtc/sys" # 0.25.2
[gtk4]="https://github.com/gtk-rs/gtk4-rs;867a6737f36c735865119cff649b059ce337dcb2;gtk4-rs-%commit%/gtk4" # 0.11.3
[gtk4-macros]="https://github.com/gtk-rs/gtk4-rs;867a6737f36c735865119cff649b059ce337dcb2;gtk4-rs-%commit%/gtk4-macros" # 0.11.3
[gtk4-sys]="https://github.com/gtk-rs/gtk4-rs;867a6737f36c735865119cff649b059ce337dcb2;gtk4-rs-%commit%/gtk4/sys" # 0.11.3
[pangocairo]="https://github.com/gtk-rs/gtk-rs-core;ba575eeaf5c7cf043e55454620e5926593756c67;gtk-rs-core-%commit%/pangocairo" # 0.22.7
[pangocairo-sys]="https://github.com/gtk-rs/gtk-rs-core;ba575eeaf5c7cf043e55454620e5926593756c67;gtk-rs-core-%commit%/pangocairo/sys" # 0.22.7
[pango]="https://github.com/gtk-rs/gtk-rs-core;ba575eeaf5c7cf043e55454620e5926593756c67;gtk-rs-core-%commit%/pango" # 0.22.7
[pango-sys]="https://github.com/gtk-rs/gtk-rs-core;ba575eeaf5c7cf043e55454620e5926593756c67;gtk-rs-core-%commit%/pango/sys" # 0.22.7
)
		inherit cargo
		SRC_URI+="$(cargo_crate_uris)"
	fi
fi

DESCRIPTION="Various GStreamer plugins written in Rust"
HOMEPAGE="https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs"
CARGO_THIRD_PARTY_PACKAGES="
	Apache-2.0
	MIT
	Unicode-DFS-2016
"
LICENSE="
	${CARGO_THIRD_PARTY_PACKAGES}
	Apache-2.0
	LGPL-2.1+
	MIT
	MPL-2.0
"
# Unicode-DFS-2016 ${HOME}/.cargo/registry/src/github.com-1ecc6299db9ec823/unicode-ident-1.0.5/LICENSE-UNICODE

RESTRICT="mirror test fetch" # Fetch restricted because of lame Anubis
SLOT="1.0/$(ver_cut 1-2 ${MY_PV})" # 1.0 is same as media-libs/gstreamer
IUSE+="
${LLVM_COMPAT[@]/#/llvm_slot_}
${MODULES[@]}
${PATENT_STATUS_IUSE[@]}
aom clang doc gcc nvcodec qsv openh264 rav1e system-libsodium vaapi vpx vulkan x264 x265
webrtc-aws webrtc-livekit
ebuild_revision_55
"
WEBRTC_AV1_ENCODERS_REQUIRED_USE="
	!patent_status_nonfree? (
		|| (
			aom
			rav1e
			vaapi
		)
		!nvcodec
	)
	patent_status_nonfree? (
		|| (
			aom
			nvcodec
			rav1e
			vaapi
		)
	)
"
WEBRTC_H264_ENCODERS_REQUIRED_USE="
	!patent_status_nonfree? (
		!nvcodec
		!qsv
		!openh264
		!vaapi
		!x264
	)
	patent_status_nonfree? (
		|| (
			nvcodec
			qsv
			openh264
			vaapi
			x264
		)
	)
"
WEBRTC_H265_ENCODERS_REQUIRED_USE="
	!patent_status_nonfree? (
		!nvcodec
		!qsv
		!vaapi
		!x265
	)
	patent_status_nonfree? (
		|| (
			nvcodec
			qsv
			vaapi
			x265
		)
	)
"
WEBRTC_VP8_ENCODERS_REQUIRED_USE="
	!patent_status_nonfree? (
		|| (
			vpx
		)
	)
	patent_status_nonfree? (
		|| (
			vpx
		)
	)
"
WEBRTC_VP9_ENCODERS_REQUIRED_USE="
	!patent_status_nonfree? (
		!qsv
		|| (
			vpx
		)
	)
	patent_status_nonfree? (
		|| (
			qsv
			vpx
		)
	)
"

WEBRTC_AV1_DECODERS_REQUIRED_USE="
	!patent_status_nonfree? (
		!nvcodec
		!vaapi
		|| (
			aom
		)
	)
	patent_status_nonfree? (
		|| (
			aom
			nvcodec
			vaapi
		)
	)
"
WEBRTC_H264_DECODERS_REQUIRED_USE="
	!patent_status_nonfree? (
		!nvcodec
		!openh264
		!qsv
		!vaapi
		!vulkan
	)
	patent_status_nonfree? (
		|| (
			nvcodec
			openh264
			qsv
			vaapi
			vulkan
		)
	)
"
WEBRTC_H265_DECODERS_REQUIRED_USE="
	!patent_status_nonfree? (
		!nvcodec
		!qsv
		!vaapi
		!vulkan
	)
	patent_status_nonfree? (
		|| (
			nvcodec
			qsv
			vaapi
			vulkan
		)
	)
"
WEBRTC_VP8_DECODERS_REQUIRED_USE="
	!patent_status_nonfree? (
		!nvcodec
		!vaapi
		|| (
			vpx
		)
	)
	patent_status_nonfree? (
		|| (
			nvcodec
			vaapi
			vpx
		)
	)
"
WEBRTC_VP9_DECODERS_REQUIRED_USE="
	!patent_status_nonfree? (
		!nvcodec
		!qsv
		!vaapi
		|| (
			vpx
		)
	)
	patent_status_nonfree? (
		|| (
			nvcodec
			qsv
			vaapi
			vpx
		)
	)
"
# The flavors plugin references aac, vp6, h264 and no way to hard disable those codepaths.
# The mp4 plugin references aac and h264 and no way to hard disable those codepaths.
PATENT_STATUS_REQUIRED_USE="
	!patent_status_nonfree? (
		!flavors
		!hlssink3
		!nvcodec
		!openh264
		!qsv
		!vaapi
		!vulkan
		!vvdec
		!x264
		!x265
	)
	flavors? (
		patent_status_nonfree
	)
	hlssink3? (
		patent_status_nonfree
	)
	nvcodec? (
		patent_status_nonfree
	)
	openh264? (
		patent_status_nonfree
	)
	qsv? (
		patent_status_nonfree
	)
	vaapi? (
		patent_status_nonfree
	)
	vulkan? (
		patent_status_nonfree
	)
	vvdec? (
		patent_status_nonfree
	)
	x264? (
		patent_status_nonfree
	)
	x265? (
		patent_status_nonfree
	)
"
REQUIRED_USE+="
	${PATENT_STATUS_REQUIRED_USE}
	^^ (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
	^^ (
		clang
		gcc
	)
	webrtc? (
		${WEBRTC_AV1_ENCODERS_REQUIRED_USE}
		${WEBRTC_H264_ENCODERS_REQUIRED_USE}
		${WEBRTC_VP8_ENCODERS_REQUIRED_USE}
		${WEBRTC_VP9_ENCODERS_REQUIRED_USE}

		${WEBRTC_AV1_DECODERS_REQUIRED_USE}
		${WEBRTC_H264_DECODERS_REQUIRED_USE}
		${WEBRTC_VP8_DECODERS_REQUIRED_USE}
		${WEBRTC_VP9_DECODERS_REQUIRED_USE}
	)
	webrtc-aws? (
		webrtc
	)
	webrtc-livekit? (
		webrtc
	)
	webrtchttp? (
		reqwest
	)

	|| (
		${MODULES[@]}
	)
"
# DEPENDS is the same as stage: test and name: meson shared CI job
# grep -e "requires_private" "${WORKDIR}" for external dependencies
# See "Run-time dependency" in CI
# openssl requirement relaxed CI uses 3.0.8
#	>=dev-libs/libgit2-1.5
CARGO_BINDINGS_DEPENDS_GLIB="
	>=dev-libs/glib-${GLIB_PV}:=[${MULTILIB_USEDEP}]
	>=dev-libs/gobject-introspection-${GOBJECT_INTROSPECTION_PV}:=
	elibc_glibc? (
		>=sys-libs/glibc-${GLIBC_PV}:=
	)
	elibc_musl? (
		>=sys-libs/musl-${MUSL_PV}:=
	)
"
CARGO_BINDINGS_DEPENDS_GOBJECT_SYS="
	${CARGO_BINDINGS_DEPENDS_GLIB}
"
CARGO_BINDINGS_DEPENDS_CAIRO="
	${CARGO_BINDINGS_DEPENDS_GOBJECT_SYS}
	>=dev-libs/gobject-introspection-${GOBJECT_INTROSPECTION_PV}:=
	>=x11-libs/cairo-${CAIRO_PV}:=[${MULTILIB_USEDEP}]
"
CARGO_BINDINGS_DEPENDS_PANGO="
	${CARGO_BINDINGS_DEPENDS_GOBJECT_SYS}
	>=x11-libs/pango-${PANGO_PV}:=[${MULTILIB_USEDEP},introspection]
"
CARGO_BINDINGS_DEPENDS_GTK4="
	${CARGO_BINDINGS_DEPENDS_CAIRO}
	${CARGO_BINDINGS_DEPENDS_PANGO}
	>=gui-libs/gtk-${GTK4_PV}:4=[introspection,gstreamer]
	>=media-libs/graphene-1.10:=[introspection]
	>=x11-libs/gdk-pixbuf-${GDK_PIXBUF_PV}:=[introspection]
"

PATENT_STATUS_RDEPEND="
	virtual/patent-status:*[patent_status_nonfree=]
"
RDEPEND+="
	${CARGO_BINDINGS_DEPENDS_GLIB}
	${PATENT_STATUS_RDEPEND}
	~media-plugins/gst-plugins-meta-${GST_PV}:=[${MULTILIB_USEDEP}]
	analytics? (
		~media-plugins/gst-plugins-analyticsoverlay-${GST_PV}:=[${MULTILIB_USEDEP}]
	)
	aws? (
		$(secure-version_gen_openssl_depends '' '[${MULTILIB_USEDEP}]')
	)
	closedcaption? (
		${CARGO_BINDINGS_DEPENDS_CAIRO}
		${CARGO_BINDINGS_DEPENDS_PANGO}
	)
	csound? (
		>=media-sound/csound-${CSOUND_PV}:=[${MULTILIB_USEDEP}]
	)
	dav1d? (
		>=media-libs/dav1d-${DAV1D_PV}:=[${MULTILIB_USEDEP}]
	)
	elibc_glibc? (
		>=sys-libs/glibc-${GLIBC_PV}:=
	)
	elibc_musl? (
		>=sys-libs/musl-${MUSL_PV}:=
	)
	gtk4? (
		${CARGO_BINDINGS_DEPENDS_GTK4}
		~media-libs/gst-plugins-base-${GST_PV}:=[${MULTILIB_USEDEP},opengl]
	)
	onvif? (
		${CARGO_BINDINGS_DEPENDS_CAIRO}
		${CARGO_BINDINGS_DEPENDS_PANGO}
	)
	skia? (
		>=media-libs/fontconfig-${FONTCONFIG_PV}:=[${MULTILIB_USEDEP}]
		>=media-libs/freetype-${FREETYPE_PV}:=[${MULTILIB_USEDEP}]
		>=media-libs/harfbuzz-${HARFBUZZ_PV}:=[${MULTILIB_USEDEP}]
	)
	system-libsodium? (
		>=dev-libs/libsodium-${LIBSODIUM_PV}:=[${MULTILIB_USEDEP}]
	)
	videofx? (
		${CARGO_BINDINGS_DEPENDS_CAIRO}
	)
	webp? (
		>=media-libs/libwebp-${LIBWEBP_PV}:=[${MULTILIB_USEDEP}]
	)
	webrtc? (
		~media-plugins/gst-plugins-opus-${GST_PV}:=[${MULTILIB_USEDEP}]
		~media-plugins/gst-plugins-rtp-${GST_PV}:=[${MULTILIB_USEDEP}]
		aom? (
			~media-plugins/gst-plugins-aom-${GST_PV}:=[${MULTILIB_USEDEP}]
		)
		nvcodec? (
			~media-plugins/gst-plugins-bad-${GST_PV}:=[${MULTILIB_USEDEP},nvcodec]
		)
		openh264? (
			~media-plugins/gst-plugins-openh264-${GST_PV}:=[${MULTILIB_USEDEP}]
		)
		qsv? (
			~media-plugins/gst-plugins-bad-${GST_PV}:=[${MULTILIB_USEDEP},qsv]
		)
		rav1e? (
			${CARGO_BINDINGS_DEPENDS_CAIRO}
			~media-plugins/gst-plugins-rav1e-${GST_PV}:=[${MULTILIB_USEDEP}]
		)
		vaapi? (
			~media-plugins/gst-plugins-bad-${GST_PV}:=[${MULTILIB_USEDEP},vaapi]
		)
		vpx? (
			~media-plugins/gst-plugins-vpx-${GST_PV}:=[${MULTILIB_USEDEP}]
		)
		vulkan? (
			~media-plugins/gst-plugins-bad-${GST_PV}:=[${MULTILIB_USEDEP},vulkan,vulkan-video]
		)
		x264? (
			~media-plugins/gst-plugins-x264-${GST_PV}:=[${MULTILIB_USEDEP}]
		)
		x265? (
			~media-plugins/gst-plugins-x265-${GST_PV}:=[${MULTILIB_USEDEP}]
		)
	)
	webrtchttp? (
		~media-plugins/gst-plugins-webrtc-${GST_PV}:=[${MULTILIB_USEDEP}]
	)
	vvdec? (
		>=media-libs/vvdec-${VVDEC_PV}:=[${MULTILIB_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
# Update while keeping track of versions of rust.
# Expanded here because the virtual system is broken for multilib.
gen_llvm_bdepend() {
	local s
	for s in "${LLVM_COMPAT[@]}" ; do
		echo "
			llvm_slot_${s}? (
				llvm-core/clang:${s}[${MULTILIB_USEDEP}]
				llvm-core/llvm:${s}[${MULTILIB_USEDEP}]
			)
		"
	done
}
RUST1_BDEPEND="
	llvm_slot_22? (
		|| (
			dev-lang/rust:1.95.0[${MULTILIB_USEDEP}]
			dev-lang/rust-bin:1.95.0[${MULTILIB_USEDEP}]
		)
	)
"
RUST_BDEPEND="
	llvm_slot_22? (
		|| (
			dev-lang/rust-bin:1.95.0[${MULTILIB_USEDEP}]
			dev-lang/rust:1.95.0[${MULTILIB_USEDEP}]
		)
	)
"
BDEPEND+="
	${RUST_BDEPEND}
	llvm-core/llvm:=
	$(gen_llvm_bdepend)
	>=dev-build/meson-1.1
	>=dev-util/cargo-c-0.9.21
	>=dev-util/pkgconf-1.8.1[${MULTILIB_USEDEP},pkg-config(+)]
	>=sys-devel/binutils-2.40
	doc? (
		$(python_gen_any_dep '
			dev-python/hotdoc[${PYTHON_USEDEP}]
		')
	)
	clang? (
		llvm-core/clang:=
	)
	gcc? (
		>=sys-devel/gcc-12.2.0:=
	)
"
PATCHES=(
)

pkg_nofetch() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	local f1="gstreamer-rs-${GSTREAMER_RS_COMMIT}.tar.gz"
	local f2="gstreamer-rs-${GSTREAMER_RS_COMMIT}.gl.tar.gz"
einfo
einfo "The Anubus AI is breaking legitimate use."
einfo "You must download the file manually.  You need to..."
einfo
einfo "1.  Goto http://gitlab.freedesktop.org/gstreamer/gstreamer-rs"
einfo "2.  Click the Code button on the top right"
einfo "3.  Click the tar.gz button in the \"Download source code\" section"
einfo "4.  mv \"/home/<user-name>/Downloads/${f1}\" \"${distdir}/${f2}\""
einfo "5.  chown portage:portage \"${distdir}/${f2}\""
einfo "6.  chmod 0664 \"${distdir}/${f2}\""
einfo "7.  emerge -1vO =${CATEGORY}/${P}"
einfo
}

pkg_setup() {
	if [[ "${GENERATE_LOCKFILE}" =~ "1" ]] ; then
		sandbox-changes_no_network_sandbox "To download internal dependencies"
	fi
	if in_iuse fallback-commit && ! use fallback-commit ; then
ewarn
ewarn "It is strongly recommended to use the fallback-commit USE flag for"
ewarn "deterministic rebuilds.  Disabling fallback-commit will likely"
ewarn "fail if the ebuild is not actively maintained *daily*."
ewarn
	fi

	if [[ "${MY_PV}" =~ "9999" ]] ; then
		sandbox-changes_no_network_sandbox "To download internal dependencies"
	fi
	python-any-r1_pkg_setup

	rust_pkg_setup
}

_production_unpack() {
	if in_iuse fallback-commit && use fallback-commit ; then
		export EGIT_COMMIT="${EGIT_COMMIT_FALLBACK}"
		export EGIT_OVERRIDE_COMMIT_GSTREAMER_GST_PLUGINS_RS="${EGIT_COMMIT_FALLBACK}"
	fi
	if [[ "${MY_PV}" =~ "9999" ]] ; then
		git-r3_fetch
		git-r3_checkout
		local actual_build_files_fingerprint=$(cat \
			$(find "${S}" \
				-name "*.toml" \
				-o -name "Cargo.lock" \
				-o -name "meson.build" \
				| sort) \
			| sha512sum \
			| cut -f 1 -d " ")
		if [[ "${EXPECTED_BUILD_FILES_FINGERPRINT}" == "disable" ]] ; then
			:
		elif [[ "${EXPECTED_BUILD_FILES_FINGERPRINT}" != "${actual_build_files_fingerprint}" ]] ; then
eerror
eerror "A change to the build scripts was detected."
eerror "Notify the ebuild maintainer for an update."
eerror
eerror "Expected build files fingerprint:\t${EXPECTED_BUILD_FILES_FINGERPRINT}"
eerror "Actual build files fingerprint:\t${actual_build_files_fingerprint}"
eerror
			die
		fi
	else
		unpack "gst-plugins-rs-gstreamer-${MY_PV}.tar.bz2"
		#die

		cargo_src_unpack
		if [[ -e "${FILESDIR}/${PV}/Cargo.lock" ]] ; then
			cp -vaT "${FILESDIR}/${PV}" "${S}" || die
		fi
	fi
}

_lockfile_gen_unpack() {
	unpack "gst-plugins-rs-gstreamer-${MY_PV}.tar.bz2"
	cd "${S}" || die
einfo "Generating lockfile"
	rm Cargo.lock
	cargo generate-lockfile || die "Failed to update Cargo.lock"

ewarn "QA:  Manually update Cargo.* files for build errors or security mitigations"
	die
}

_lockfile_gen_unpack_upstream() {
	unpack "gst-plugins-rs-gstreamer-${MY_PV}.tar.bz2"
einfo "Copy Cargo.lock Cargo.toml to the files/${PV}"
	die
}

src_unpack() {
	unpack "gst-plugins-rs-gstreamer-${MY_PV}.tar.bz2"
#	die # For manual lockfile update

	if [[ "${GENERATE_LOCKFILE}" =~ "1" && "${LOCKFILE_SOURCE}" == "upstream" ]] ; then
		_lockfile_gen_unpack_upstream
	elif [[ "${GENERATE_LOCKFILE}" =~ "1" ]] ; then
		_lockfile_gen_unpack
	else
		_production_unpack
	fi
	cp -aT \
		"${FILESDIR}/${PV}"* \
		"${S}" \
		|| die
}

src_prepare() {
	default
	sed -i \
		-e "s|csound64|csound|g" \
		"meson.build" \
		|| die

	if ! use validate ; then
		sed -i -e "/validate-plugins/d" "meson.build" || die
	fi
}

multilib_src_configure() {
	local llvm_slot=""
	local s
	for s in "${LLVM_COMPAT[@]}" ; do
		if in_iuse "llvm_slot_${s}" && use "llvm_slot_${s}" ; then
			llvm_slot="${s}"
			break
		fi
	done
	LLVM_MAX_SLOT="${llvm_slot}"
	llvm_pkg_setup
einfo "LLVM SLOT:  ${LLVM_MAX_SLOT}"
	"${RUSTC}" --version || die

	if tc-is-clang ; then
		use clang || die "Enable the clang USE flag."
	fi

	if tc-is-gcc ; then
		use gcc || die "Enable the gcc USE flag."
	fi

	export CSOUND_LIB_DIR="${ESYSROOT}/usr/$(get_libdir)"

	local emesonargs=()

	local m
	for m in "${MODULES[@]}" ; do
		emesonargs+=(
			$(meson_feature "${m}")
		)
	done

	if use system-libsodium ; then
		emesonargs+=(
			-Dsodium-source="system"
		)
	fi

einfo "emesonargs:  ${emesonargs[@]}"

	chkl_check_many_timestamps
	rustflags-hardened_append
	meson_src_configure
}

multilib_src_compile() {
# DO NOT REMOVE
	meson_src_compile
}

multilib_src_install() {
	meson_src_install

	if [[ "${MY_PV}" =~ "9999" ]] ; then
		LCNR_SOURCE="${HOME}/.cargo"
		LCNR_TAG="third_party_cargo"
		lcnr_install_files

		LCNR_SOURCE="${S}"
		LCNR_TAG="sources"
		lcnr_install_files
	else
		LCNR_SOURCE="${WORKDIR}/cargo_home/gentoo"
		LCNR_TAG="third_party_cargo"
		lcnr_install_files

		LCNR_SOURCE=$(realpath "${WORKDIR}/ffv1-"*)
		LCNR_TAG="third_party_cargo_ffv1"
		lcnr_install_files

		LCNR_SOURCE=$(realpath "${WORKDIR}/flavors-"*)
		LCNR_TAG="third_party_cargo_flavors"
		lcnr_install_files

		LCNR_SOURCE=$(realpath "${WORKDIR}/gstreamer-rs-"*)
		LCNR_TAG="third_party_cargo_gstreamer-rs"
		lcnr_install_files

		LCNR_SOURCE=$(realpath "${WORKDIR}/gtk-rs-core-"*)
		LCNR_TAG="third_party_cargo_gtk-rs-core"
		lcnr_install_files

		LCNR_SOURCE=$(realpath "${WORKDIR}/gtk4-rs-"*)
		LCNR_TAG="third_party_cargo_gtk4-rs"
		lcnr_install_files

		LCNR_SOURCE="${S}"
		LCNR_TAG="sources"
		lcnr_install_files
	fi
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install_all() {
	einstalldocs
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
