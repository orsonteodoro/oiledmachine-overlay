# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# The lockfile should be updated once a week for security reasons.

EAPI=8

# D12-slim
# The versioning is based on the tag with the gstreamer- prefix.

_gst_plugins_rs_globals() {
	LOCKFILE_SOURCE="ebuild" # ebuild or upstream
	GENERATE_LOCKFILE=${GENERATE_LOCKFILE:-0} # Set to 1 if generating lockfile
	if [[ "${GENERATE_LOCKFILE}" == "1" ]] ; then
einfo "Generating lockfile"
	fi
}
_gst_plugins_rs_globals
unset -f _gst_plugins_rs_globals

MY_PV="${PV}"

RUSTFLAGS_HARDENED_USE_CASES="network plugin untrusted-data secure-critical server"
EXPECTED_BUILD_FILES_FINGERPRINT="disable"
GOBJECT_INTROSPECTION_PV="1.74.0"
GST_PV="${MY_PV}"
LLVM_COMPAT=( 19 ) # For clang-sys ; slot based on rust subslot
LLVM_MAX_SLOT="${LLVM_COMPAT[0]}"
MODULES=(
	"analytics"
	"audiofx"
	"aws"
	"cdg"
	"claxon"
	"closedcaption"
	"csound"
	"dav1d"
	"doc"
	"elevenlabs"
	"examples"
	"fallbackswitch"
	"ffv1"
	"file"
	"flavors"
	"fmp4"
	"gif"
	"gopbuffer"
	"gtk4"
	"hlsmultivariantsink"
	"hlssink3"
	"hsv"
	"inter"
	"json"
	"lewton"
	"livesync"
	"mp4"
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
#	"test"
	"textahead"
	"textwrap"
	"threadshare"
	"togglerecord"
	"tracers"
	"uriplaylistbin"
	"videofx"
	"vvdec"
	"webp"
	"webrtc"
	"webrtchttp"
)
PATENT_STATUS_IUSE=(
	"patent_status_nonfree"
)
PYTHON_COMPAT=( "python3_"{8..11} )
# Upstream uses Rust 1.88.0, but relaxed
RUST_MAX_VER="1.85.1" # Inclusive.  Corresponds to llvm 19.1
RUST_MIN_VER="1.85.1" # Corresponds to llvm 19.1

if [[ "${MY_PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_COMMIT="HEAD"
	EGIT_COMMIT_FALLBACK="ff2b71cbbd02b4b6fc47d6f1fce471b015e1ed88" # Jun 26, 2025
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
	"
	if [[ "${GENERATE_LOCKFILE}" == "1" ]] ; then
		:
	else
CRATES="
addr2line-0.24.2
adler2-2.0.1
aes-0.8.4
aho-corasick-1.1.3
aligned-0.4.2
aligned-vec-0.6.4
allocator-api2-0.2.21
android_system_properties-0.1.5
android-tzdata-0.1.1
anstream-0.6.20
anstyle-1.0.11
anstyle-parse-0.2.7
anstyle-query-1.1.4
anstyle-wincon-3.0.10
anyhow-1.0.98
arbitrary-1.4.1
arg_enum_proc_macro-0.3.4
arrayvec-0.7.6
as-slice-0.2.1
async-channel-2.5.0
async-compression-0.4.27
async-lock-3.4.1
async-recursion-1.1.1
async-stream-0.3.6
async-stream-impl-0.3.6
async-task-4.7.1
async-trait-0.1.88
async-tungstenite-0.30.0
atomic_refcell-0.1.13
atomic-waker-1.1.2
autocfg-1.5.0
av1-grain-0.2.4
av-data-0.4.4
av-scenechange-0.14.1
aws-config-1.5.18
aws-credential-types-1.2.2
aws-lc-rs-1.13.3
aws-lc-sys-0.30.0
aws-runtime-1.5.5
aws-sdk-kinesisvideo-1.62.0
aws-sdk-kinesisvideosignaling-1.61.0
aws-sdk-polly-1.64.0
aws-sdk-s3-1.76.0
aws-sdk-sso-1.61.0
aws-sdk-ssooidc-1.62.0
aws-sdk-sts-1.62.0
aws-sdk-transcribestreaming-1.63.0
aws-sdk-translate-1.61.0
aws-sigv4-1.2.9
aws-smithy-async-1.2.5
aws-smithy-checksums-0.62.0
aws-smithy-eventstream-0.60.10
aws-smithy-http-0.60.12
aws-smithy-http-0.61.1
aws-smithy-json-0.61.4
aws-smithy-query-0.60.7
aws-smithy-runtime-1.7.8
aws-smithy-runtime-api-1.7.4
aws-smithy-types-1.3.2
aws-smithy-xml-0.60.10
aws-types-1.3.6
backtrace-0.3.75
base16ct-0.1.1
base32-0.5.1
base64-0.13.1
base64-0.21.7
base64-0.22.1
base64ct-1.8.0
base64-serde-0.8.0
base64-simd-0.8.0
bincode-1.3.3
bindgen-0.69.5
bindgen-0.71.1
bindgen-0.72.0
bitflags-1.3.2
bitflags-2.9.1
bitreader-0.3.11
bitstream-io-4.5.0
block-buffer-0.10.4
bstr-1.12.0
built-0.8.0
bumpalo-3.19.0
bytemuck-1.23.2
byteorder-1.5.0
byteorder-lite-0.1.0
byteorder_slice-3.0.0
bytes-1.10.1
byte-slice-cast-1.2.3
bytes-utils-0.1.4
cc-1.2.32
cdg-0.1.0
cdg_renderer-0.8.0
cdp-types-0.3.0
cea608-types-0.1.4
cea708-types-0.4.1
cesu8-1.1.0
cexpr-0.6.0
cfg_aliases-0.2.1
cfg-expr-0.20.2
cfg-if-1.0.1
chrono-0.4.41
cipher-0.4.4
clang-sys-1.8.1
clap-4.5.43
clap_builder-4.5.43
clap_derive-4.5.41
clap_lex-0.7.5
claxon-0.4.3
cmake-0.1.54
colorchoice-1.0.4
color-name-1.1.0
color_quant-1.1.0
color-thief-0.2.2
combine-4.6.7
concurrent-queue-2.5.0
const-oid-0.9.6
cookie-0.18.1
cookie-factory-0.3.3
cookie_store-0.21.1
core2-0.4.0
core-foundation-0.10.1
core-foundation-0.9.4
core-foundation-sys-0.8.7
cpufeatures-0.2.17
crc32c-0.6.8
crc32fast-1.5.0
crc-3.3.0
crc64fast-nvme-1.2.0
crc-catalog-2.4.0
crossbeam-deque-0.8.6
crossbeam-epoch-0.9.18
crossbeam-utils-0.8.21
crypto-bigint-0.4.9
crypto-bigint-0.5.5
crypto-common-0.1.6
csound-0.1.8
csound-sys-0.1.2
ctr-0.9.2
ctrlc-3.4.7
darling-0.20.11
darling_core-0.20.11
darling_macro-0.20.11
dash-mpd-0.18.4
dasp_frame-0.11.0
dasp_sample-0.11.0
data-encoding-2.9.0
dav1d-0.11.0
dav1d-sys-0.8.3
der-0.6.1
der-0.7.10
deranged-0.4.0
derive_builder-0.20.2
derive_builder_core-0.20.2
derive_builder_macro-0.20.2
derive-into-owned-0.2.0
derive_more-2.0.1
derive_more-impl-2.0.1
diff-0.1.13
digest-0.10.7
displaydoc-0.2.5
document-features-0.2.11
dssim-core-3.2.11
dunce-1.0.5
dyn-clone-1.0.20
ebml-iterable-0.6.3
ebml-iterable-specification-0.4.0
ebml-iterable-specification-derive-0.4.0
ebur128-0.1.10
ecdsa-0.14.8
ed25519-1.5.3
either-1.15.0
elliptic-curve-0.12.3
encoding_rs-0.8.35
enumn-0.1.14
env_filter-0.1.3
env_logger-0.11.8
equator-0.4.2
equator-macro-0.4.2
equivalent-1.0.2
errno-0.3.13
etherparse-0.19.0
event-listener-5.4.1
event-listener-strategy-0.5.4
fallible-iterator-0.3.0
fastbloom-0.9.0
fastrand-2.3.0
fdeflate-0.3.7
ff-0.12.1
field-offset-0.3.6
filetime-0.2.25
fixedbitset-0.4.2
flate2-1.1.2
flume-0.11.1
fnv-1.0.7
foldhash-0.1.5
foreign-types-0.3.2
foreign-types-shared-0.1.1
form_urlencoded-1.2.1
fs-err-3.1.1
fs_extra-1.3.0
fst-0.4.7
futures-0.3.31
futures-channel-0.3.31
futures-core-0.3.31
futures-executor-0.3.31
futures-io-0.3.31
futures-macro-0.3.31
futures-sink-0.3.31
futures-task-0.3.31
futures-timer-3.0.3
futures-util-0.3.31
generic-array-0.14.7
getifaddrs-0.2.0
getrandom-0.2.16
getrandom-0.3.3
gif-0.13.3
gimli-0.31.1
glob-0.3.2
governor-0.6.3
group-0.12.1
h2-0.3.27
h2-0.4.12
hashbrown-0.12.3
hashbrown-0.15.5
headers-0.3.9
headers-0.4.1
headers-core-0.2.0
headers-core-0.3.0
heck-0.4.1
heck-0.5.0
hermit-abi-0.5.2
hex-0.4.3
hmac-0.12.1
home-0.5.11
hrtf-0.8.1
http-0.2.12
http-1.3.1
httparse-1.10.1
http-body-0.4.6
http-body-1.0.1
http-body-util-0.1.3
httpdate-1.0.3
human_bytes-0.4.3
hxdmp-0.2.1
hyper-0.14.32
hyper-1.6.0
hyper-proxy2-0.1.0
hyper-rustls-0.24.2
hyper-rustls-0.26.0
hyper-rustls-0.27.7
hyper-tls-0.5.0
hyper-tls-0.6.0
hyper-util-0.1.16
hyphenation-0.8.4
hyphenation_commons-0.8.4
iana-time-zone-0.1.63
iana-time-zone-haiku-0.1.2
icu_collections-2.0.0
icu_locale_core-2.0.0
icu_normalizer-2.0.0
icu_normalizer_data-2.0.0
icu_properties-2.0.1
icu_properties_data-2.0.1
icu_provider-2.0.0
ident_case-1.0.1
idna-1.0.3
idna_adapter-1.2.1
image-0.25.6
image_hasher-3.0.0
imgref-1.11.0
indexmap-1.9.3
indexmap-2.10.0
inout-0.1.4
interpolate_name-0.2.4
io-uring-0.7.9
ipnet-2.11.0
iri-string-0.7.8
iso8601-0.6.3
is_terminal_polyfill-1.70.1
itertools-0.11.0
itertools-0.12.1
itertools-0.13.0
itertools-0.14.0
itoa-1.0.15
jiff-0.2.15
jiff-static-0.2.15
jni-0.21.1
jni-sys-0.3.0
jobserver-0.1.33
jsonwebtoken-9.3.1
js-sys-0.3.77
khronos-egl-6.0.0
kstring-2.0.2
lazycell-1.3.0
lazy_static-1.5.0
lewton-0.10.2
libc-0.2.174
libfuzzer-sys-0.4.10
libloading-0.8.8
libm-0.2.15
libredox-0.1.9
librespot-audio-0.6.0
librespot-core-0.6.0
librespot-metadata-0.6.0
librespot-oauth-0.6.0
librespot-playback-0.6.0
librespot-protocol-0.6.0
libsodium-sys-0.2.7
libwebp-sys2-0.1.11
linux-raw-sys-0.4.15
linux-raw-sys-0.9.4
litemap-0.8.0
litrs-0.4.2
livekit-api-0.3.2
livekit-protocol-0.3.2
lock_api-0.4.13
log-0.4.27
lru-0.12.5
lru-0.16.0
lru-slab-0.1.2
m3u8-rs-6.0.0
matchers-0.1.0
maybe-rayon-0.1.1
md-5-0.10.6
memchr-2.7.5
memoffset-0.9.1
mime-0.3.17
mime_guess-2.0.5
minimal-lexical-0.2.1
miniz_oxide-0.8.9
mio-1.0.4
more-asserts-0.3.1
mp4-atom-0.8.1
muldiv-1.0.1
multer-2.1.0
multimap-0.10.1
nanorand-0.7.0
nasm-rs-0.3.0
native-tls-0.2.14
new_debug_unreachable-1.0.6
nix-0.30.1
nnnoiseless-0.5.1
nom-7.1.3
nom-8.0.0
nonzero_ext-0.3.0
noop_proc_macro-0.3.0
no-std-compat-0.4.1
ntapi-0.4.1
nu-ansi-term-0.46.0
num-0.4.3
num-bigint-0.4.6
num-bigint-dig-0.8.4
num-complex-0.4.6
num-conv-0.1.0
num_cpus-1.17.0
num-derive-0.4.2
num-integer-0.1.46
num-iter-0.1.45
num-rational-0.4.2
num_threads-0.1.7
num-traits-0.2.19
oauth2-4.4.2
object-0.36.7
ogg-0.9.2
once_cell-1.21.3
once_cell_polyfill-1.70.1
openssl-0.10.73
openssl-macros-0.1.1
openssl-probe-0.1.6
openssl-sys-0.9.109
option-operations-0.5.0
outref-0.5.2
overload-0.1.1
p256-0.11.1
parking-2.2.1
parking_lot-0.12.4
parking_lot_core-0.9.11
parse_link_header-0.4.0
paste-1.0.15
pastey-0.1.0
pbjson-0.6.0
pbjson-build-0.6.2
pbjson-types-0.6.0
pbkdf2-0.12.2
pcap-file-2.0.0
pem-3.0.5
pem-rfc7468-0.7.0
percent-encoding-2.3.1
petgraph-0.6.5
pin-project-1.1.10
pin-project-internal-1.1.10
pin-project-lite-0.2.16
pin-utils-0.1.0
pkcs1-0.7.5
pkcs8-0.10.2
pkcs8-0.9.0
pkg-config-0.3.32
png-0.17.16
pocket-resources-0.3.2
polling-3.10.0
portable-atomic-1.11.1
portable-atomic-util-0.2.4
potential_utf-0.1.2
powerfmt-0.2.0
ppv-lite86-0.2.21
pretty_assertions-1.4.1
prettyplease-0.2.36
primal-check-0.3.4
priority-queue-2.5.0
proc-macro2-1.0.95
proc-macro-crate-3.3.0
proc-macro-error2-2.0.1
proc-macro-error-attr2-2.0.0
profiling-1.0.17
profiling-procmacros-1.0.17
prost-0.12.6
prost-build-0.12.6
prost-derive-0.12.6
prost-types-0.12.6
protobuf-3.7.2
protobuf-codegen-3.7.2
protobuf-parse-3.7.2
protobuf-support-3.7.2
psl-types-2.0.11
publicsuffix-2.3.0
quick-xml-0.36.2
quick-xml-0.37.5
quick-xml-0.38.1
quinn-0.11.8
quinn-proto-0.11.12
quinn-udp-0.5.13
quote-1.0.40
rand-0.8.5
rand-0.9.2
rand_chacha-0.3.1
rand_chacha-0.9.0
rand_core-0.6.4
rand_core-0.9.3
rand_distr-0.4.3
raptorq-2.0.0
rav1e-0.8.1
rayon-1.10.0
rayon-core-1.12.1
rcgen-0.14.3
realfft-3.5.0
redox_syscall-0.5.17
ref-cast-1.0.24
ref-cast-impl-1.0.24
r-efi-5.3.0
regex-1.11.1
regex-automata-0.1.10
regex-automata-0.4.9
regex-lite-0.1.6
regex-syntax-0.6.29
regex-syntax-0.8.5
reqwest-0.11.27
reqwest-0.12.22
rfc6979-0.3.1
rgb-0.8.52
ring-0.17.14
rsa-0.9.8
rtcp-types-0.2.0
rtp-types-0.1.2
rtsp-types-0.1.3
rubato-0.14.1
rustc-demangle-0.1.26
rustc-hash-1.1.0
rustc-hash-2.1.1
rustc_version-0.4.1
rustdct-0.7.1
rustfft-6.4.0
rustix-0.38.44
rustix-1.0.8
rustls-0.21.12
rustls-0.22.4
rustls-0.23.31
rustls-native-certs-0.6.3
rustls-native-certs-0.7.3
rustls-native-certs-0.8.1
rustls-pemfile-1.0.4
rustls-pemfile-2.2.0
rustls-pki-types-1.12.0
rustls-platform-verifier-0.5.3
rustls-platform-verifier-android-0.1.1
rustls-webpki-0.101.7
rustls-webpki-0.102.8
rustls-webpki-0.103.4
rustversion-1.0.22
ryu-1.0.20
safe_arch-0.7.4
same-file-1.0.6
scc-2.3.4
schannel-0.1.27
schemars-0.9.0
schemars-1.0.4
scoped-tls-1.0.1
scopeguard-1.2.0
sct-0.7.1
sdd-3.0.10
sdp-types-0.1.8
sec1-0.3.0
security-framework-2.11.1
security-framework-3.3.0
security-framework-sys-2.14.0
semver-1.0.26
serde-1.0.219
serde_bytes-0.11.17
serde_derive-1.0.219
serde_json-1.0.142
serde_path_to_error-0.1.17
serde_spanned-0.6.9
serde_urlencoded-0.7.1
serde_with-3.14.0
serde_with_macros-3.14.0
serial_test-3.2.0
serial_test_derive-3.2.0
sha1-0.10.6
sha2-0.10.9
shannon-0.2.0
sharded-slab-0.1.7
shell-words-1.1.0
shlex-1.3.0
signal-hook-0.3.18
signal-hook-registry-1.4.6
signature-1.6.4
signature-2.2.0
simd-adler32-0.3.7
simd_helpers-0.1.0
siphasher-1.0.1
skia-bindings-0.87.0
skia-safe-0.87.0
slab-0.4.11
smallvec-1.15.1
smawk-0.3.2
socket2-0.5.10
socket2-0.6.0
sodiumoxide-0.2.7
spin-0.9.8
spinning_top-0.3.0
spki-0.6.0
spki-0.7.3
sprintf-0.4.2
stable_deref_trait-1.2.0
static_assertions-1.1.0
strength_reduce-0.2.4
strsim-0.11.1
subtle-2.6.1
symphonia-0.5.4
symphonia-bundle-mp3-0.5.4
symphonia-codec-vorbis-0.5.4
symphonia-core-0.5.4
symphonia-format-ogg-0.5.4
symphonia-metadata-0.5.4
symphonia-utils-xiph-0.5.4
syn-1.0.109
syn-2.0.104
sync_wrapper-0.1.2
sync_wrapper-1.0.2
synstructure-0.13.2
sysinfo-0.31.4
system-configuration-0.5.1
system-configuration-0.6.1
system-configuration-sys-0.5.0
system-configuration-sys-0.6.0
system-deps-7.0.5
tar-0.4.44
target-lexicon-0.13.2
tempfile-3.20.0
test-log-0.2.18
test-log-macros-0.2.18
test-with-0.15.3
textwrap-0.16.2
thiserror-1.0.69
thiserror-2.0.12
thiserror-impl-1.0.69
thiserror-impl-2.0.12
thread-id-4.2.2
thread_local-1.1.9
time-0.3.41
time-core-0.1.4
time-macros-0.2.22
tinystr-0.8.1
tinyvec-1.9.0
tinyvec_macros-0.1.1
tokio-1.47.1
tokio-macros-2.5.0
tokio-native-tls-0.3.1
tokio-rustls-0.24.1
tokio-rustls-0.25.0
tokio-rustls-0.26.2
tokio-stream-0.1.17
tokio-tungstenite-0.20.1
tokio-tungstenite-0.21.0
tokio-tungstenite-0.24.0
tokio-util-0.7.16
toml-0.8.23
toml_datetime-0.6.11
toml_datetime-0.7.0
toml_edit-0.22.27
toml_edit-0.23.3
toml_parser-1.0.2
toml_write-0.1.2
tower-0.5.2
tower-http-0.6.6
tower-layer-0.3.3
tower-service-0.3.3
tracing-0.1.41
tracing-attributes-0.1.30
tracing-core-0.1.34
tracing-log-0.2.0
tracing-subscriber-0.3.19
transpose-0.2.3
try-lock-0.2.5
tungstenite-0.20.1
tungstenite-0.21.0
tungstenite-0.24.0
tungstenite-0.27.0
typenum-1.18.0
unicase-2.8.1
unicode-ident-1.0.18
unicode-linebreak-0.1.5
unicode-width-0.2.1
untrusted-0.9.0
url-2.5.4
urlencoding-2.1.3
url-escape-0.1.1
utf-8-0.7.6
utf8_iter-1.0.4
utf8parse-0.2.2
uuid-1.17.0
va_list-0.1.4
valuable-0.1.1
vcpkg-0.2.15
vergen-9.0.6
vergen-gitcl-1.0.8
vergen-lib-0.1.6
version_check-0.9.5
version-compare-0.2.0
v_frame-0.3.9
vsimd-0.8.0
vvdec-0.6.11
vvdec-sys-0.7.0
waker-fn-1.2.0
walkdir-2.5.0
want-0.3.1
warp-0.3.7
wasi-0.11.1+wasi-snapshot-preview1
wasi-0.14.2+wasi-0.2.4
wasm-bindgen-0.2.100
wasm-bindgen-backend-0.2.100
wasm-bindgen-futures-0.4.50
wasm-bindgen-macro-0.2.100
wasm-bindgen-macro-support-0.2.100
wasm-bindgen-shared-0.2.100
webm-iterable-0.6.4
webpki-0.22.4
webpki-root-certs-0.26.11
webpki-root-certs-1.0.2
webpki-roots-0.25.4
web-sys-0.3.77
web-time-1.1.0
web-transport-proto-0.2.6
web-transport-quinn-0.7.3
weezl-0.1.10
which-4.4.2
wide-0.7.33
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.9
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.57.0
windows_aarch64_gnullvm-0.42.2
windows_aarch64_gnullvm-0.48.5
windows_aarch64_gnullvm-0.52.6
windows_aarch64_gnullvm-0.53.0
windows_aarch64_msvc-0.42.2
windows_aarch64_msvc-0.48.5
windows_aarch64_msvc-0.52.6
windows_aarch64_msvc-0.53.0
windows-core-0.57.0
windows-core-0.61.2
windows_i686_gnu-0.42.2
windows_i686_gnu-0.48.5
windows_i686_gnu-0.52.6
windows_i686_gnu-0.53.0
windows_i686_gnullvm-0.52.6
windows_i686_gnullvm-0.53.0
windows_i686_msvc-0.42.2
windows_i686_msvc-0.48.5
windows_i686_msvc-0.52.6
windows_i686_msvc-0.53.0
windows-implement-0.57.0
windows-implement-0.60.0
windows-interface-0.57.0
windows-interface-0.59.1
windows-link-0.1.3
windows-registry-0.5.3
windows-result-0.1.2
windows-result-0.3.4
windows-strings-0.4.2
windows-sys-0.45.0
windows-sys-0.48.0
windows-sys-0.52.0
windows-sys-0.59.0
windows-sys-0.60.2
windows-targets-0.42.2
windows-targets-0.48.5
windows-targets-0.52.6
windows-targets-0.53.3
windows_x86_64_gnu-0.42.2
windows_x86_64_gnu-0.48.5
windows_x86_64_gnu-0.52.6
windows_x86_64_gnu-0.53.0
windows_x86_64_gnullvm-0.42.2
windows_x86_64_gnullvm-0.48.5
windows_x86_64_gnullvm-0.52.6
windows_x86_64_gnullvm-0.53.0
windows_x86_64_msvc-0.42.2
windows_x86_64_msvc-0.48.5
windows_x86_64_msvc-0.52.6
windows_x86_64_msvc-0.53.0
winnow-0.7.12
winreg-0.50.0
wit-bindgen-rt-0.39.0
writeable-0.6.1
xattr-1.5.1
xmlparser-0.13.6
xml-rs-0.8.27
xmltree-0.11.0
y4m-0.8.0
yansi-1.0.1
yasna-0.5.2
yoke-0.8.0
yoke-derive-0.8.0
zerocopy-0.7.35
zerocopy-0.8.26
zerocopy-derive-0.7.35
zerocopy-derive-0.8.26
zerofrom-0.1.6
zerofrom-derive-0.1.6
zeroize-1.8.1
zerotrie-0.2.2
zerovec-0.11.4
zerovec-derive-0.11.1
"

declare -A GIT_CRATES=(
[cairo-rs]="https://github.com/gtk-rs/gtk-rs-core;a93a100230de5eb68850af90a96961c34d2b917b;gtk-rs-core-%commit%/cairo" # 0.21.0
[cairo-sys-rs]="https://github.com/gtk-rs/gtk-rs-core;a93a100230de5eb68850af90a96961c34d2b917b;gtk-rs-core-%commit%/cairo/sys" # 0.21.0
[ffv1]="https://github.com/rust-av/ffv1;bd9eabfc14c9ad53c37b32279e276619f4390ab8;ffv1-%commit%" # 0.0.0
[flavors]="https://github.com/rust-av/flavors;833508af656d298c269f2397c8541a084264d992;flavors-%commit%" # 0.2.0
[gdk4]="https://github.com/gtk-rs/gtk4-rs;416aa3ae63fc33ff6436ab1fe26ffbdbe47e8976;gtk4-rs-%commit%/gdk4" # 0.10.0
[gdk4-sys]="https://github.com/gtk-rs/gtk4-rs;416aa3ae63fc33ff6436ab1fe26ffbdbe47e8976;gtk4-rs-%commit%/gdk4/sys" # 0.10.0
[gdk4-wayland]="https://github.com/gtk-rs/gtk4-rs;416aa3ae63fc33ff6436ab1fe26ffbdbe47e8976;gtk4-rs-%commit%/gdk4-wayland" # 0.10.0
[gdk4-wayland-sys]="https://github.com/gtk-rs/gtk4-rs;416aa3ae63fc33ff6436ab1fe26ffbdbe47e8976;gtk4-rs-%commit%/gdk4-wayland/sys" # 0.10.0
[gdk4-win32]="https://github.com/gtk-rs/gtk4-rs;416aa3ae63fc33ff6436ab1fe26ffbdbe47e8976;gtk4-rs-%commit%/gdk4-win32" # 0.10.0
[gdk4-win32-sys]="https://github.com/gtk-rs/gtk4-rs;416aa3ae63fc33ff6436ab1fe26ffbdbe47e8976;gtk4-rs-%commit%/gdk4-win32/sys" # 0.10.0
[gdk4-x11]="https://github.com/gtk-rs/gtk4-rs;416aa3ae63fc33ff6436ab1fe26ffbdbe47e8976;gtk4-rs-%commit%/gdk4-x11" # 0.10.0
[gdk4-x11-sys]="https://github.com/gtk-rs/gtk4-rs;416aa3ae63fc33ff6436ab1fe26ffbdbe47e8976;gtk4-rs-%commit%/gdk4-x11/sys" # 0.10.0
[gdk-pixbuf]="https://github.com/gtk-rs/gtk-rs-core;a93a100230de5eb68850af90a96961c34d2b917b;gtk-rs-core-%commit%/gdk-pixbuf" # 0.21.0
[gdk-pixbuf-sys]="https://github.com/gtk-rs/gtk-rs-core;a93a100230de5eb68850af90a96961c34d2b917b;gtk-rs-core-%commit%/gdk-pixbuf/sys" # 0.21.0
[gio]="https://github.com/gtk-rs/gtk-rs-core;a93a100230de5eb68850af90a96961c34d2b917b;gtk-rs-core-%commit%/gio" # 0.21.0
[gio-sys]="https://github.com/gtk-rs/gtk-rs-core;a93a100230de5eb68850af90a96961c34d2b917b;gtk-rs-core-%commit%/gio/sys" # 0.21.0
[glib]="https://github.com/gtk-rs/gtk-rs-core;a93a100230de5eb68850af90a96961c34d2b917b;gtk-rs-core-%commit%/glib" # 0.21.0
[glib-macros]="https://github.com/gtk-rs/gtk-rs-core;a93a100230de5eb68850af90a96961c34d2b917b;gtk-rs-core-%commit%/glib-macros" # 0.21.0
[glib-sys]="https://github.com/gtk-rs/gtk-rs-core;a93a100230de5eb68850af90a96961c34d2b917b;gtk-rs-core-%commit%/glib/sys" # 0.21.0
[gobject-sys]="https://github.com/gtk-rs/gtk-rs-core;a93a100230de5eb68850af90a96961c34d2b917b;gtk-rs-core-%commit%/glib/gobject-sys" # 0.21.0
[graphene-rs]="https://github.com/gtk-rs/gtk-rs-core;a93a100230de5eb68850af90a96961c34d2b917b;gtk-rs-core-%commit%/graphene" # 0.21.0
[graphene-sys]="https://github.com/gtk-rs/gtk-rs-core;a93a100230de5eb68850af90a96961c34d2b917b;gtk-rs-core-%commit%/graphene/sys" # 0.21.0
[gsk4]="https://github.com/gtk-rs/gtk4-rs;416aa3ae63fc33ff6436ab1fe26ffbdbe47e8976;gtk4-rs-%commit%/gsk4" # 0.10.0
[gsk4-sys]="https://github.com/gtk-rs/gtk4-rs;416aa3ae63fc33ff6436ab1fe26ffbdbe47e8976;gtk4-rs-%commit%/gsk4/sys" # 0.10.0
[gstreamer-allocators]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-allocators" # 0.24.0
[gstreamer-allocators-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-allocators/sys" # 0.24.0
[gstreamer-analytics]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-analytics" # 0.24.0
[gstreamer-analytics-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-analytics/sys" # 0.24.0
[gstreamer-app]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-app" # 0.24.0
[gstreamer-app-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-app/sys" # 0.24.0
[gstreamer-audio]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-audio" # 0.24.0
[gstreamer-audio-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-audio/sys" # 0.24.0
[gstreamer-base]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-base" # 0.24.0
[gstreamer-base-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-base/sys" # 0.24.0
[gstreamer-check]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-check" # 0.24.0
[gstreamer-check-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-check/sys" # 0.24.0
[gstreamer-gl-egl]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-gl/egl" # 0.24.0
[gstreamer-gl-egl-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-gl/egl/sys" # 0.24.0
[gstreamer-gl]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-gl" # 0.24.0
[gstreamer-gl-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-gl/sys" # 0.24.0
[gstreamer-gl-wayland]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-gl/wayland" # 0.24.0
[gstreamer-gl-wayland-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-gl/wayland/sys" # 0.24.0
[gstreamer-gl-x11]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-gl/x11" # 0.24.0
[gstreamer-gl-x11-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-gl/x11/sys" # 0.24.0
[gstreamer]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer" # 0.24.0
[gstreamer-net]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-net" # 0.24.0
[gstreamer-net-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-net/sys" # 0.24.0
[gstreamer-pbutils]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-pbutils" # 0.24.0
[gstreamer-pbutils-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-pbutils/sys" # 0.24.0
[gstreamer-rtp]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-rtp" # 0.24.0
[gstreamer-rtp-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-rtp/sys" # 0.24.0
[gstreamer-sdp]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-sdp" # 0.24.0
[gstreamer-sdp-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-sdp/sys" # 0.24.0
[gstreamer-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer/sys" # 0.24.0
[gstreamer-tag]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;" # 0.24.0
[gstreamer-tag-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;" # 0.24.0
[gstreamer-utils]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-utils" # 0.24.0
[gstreamer-video]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-video" # 0.24.0
[gstreamer-video-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-video/sys" # 0.24.0
[gstreamer-webrtc]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-webrtc" # 0.24.0
[gstreamer-webrtc-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;ad81cf9ccaf0779b79a0cfb3fc0de628114d04ad;gstreamer-rs-%commit%/gstreamer-webrtc/sys" # 0.24.0
[gtk4]="https://github.com/gtk-rs/gtk4-rs;416aa3ae63fc33ff6436ab1fe26ffbdbe47e8976;gtk4-rs-%commit%/gtk4" # 0.10.0
[gtk4-macros]="https://github.com/gtk-rs/gtk4-rs;416aa3ae63fc33ff6436ab1fe26ffbdbe47e8976;gtk4-rs-%commit%/gtk4-macros" # 0.10.0
[gtk4-sys]="https://github.com/gtk-rs/gtk4-rs;416aa3ae63fc33ff6436ab1fe26ffbdbe47e8976;gtk4-rs-%commit%/gtk4/sys" # 0.10.0
[pangocairo]="https://github.com/gtk-rs/gtk-rs-core;a93a100230de5eb68850af90a96961c34d2b917b;gtk-rs-core-%commit%/pangocairo" # 0.21.0
[pangocairo-sys]="https://github.com/gtk-rs/gtk-rs-core;a93a100230de5eb68850af90a96961c34d2b917b;gtk-rs-core-%commit%/pangocairo/sys" # 0.21.0
[pango]="https://github.com/gtk-rs/gtk-rs-core;a93a100230de5eb68850af90a96961c34d2b917b;gtk-rs-core-%commit%/pango" # 0.21.0
[pango-sys]="https://github.com/gtk-rs/gtk-rs-core;a93a100230de5eb68850af90a96961c34d2b917b;gtk-rs-core-%commit%/pango/sys" # 0.21.0
)
		inherit cargo
		SRC_URI+="$(cargo_crate_uris)"
	fi
fi

inherit rustflags-hardened flag-o-matic lcnr llvm meson multilib-minimal
inherit python-any-r1 rust sandbox-changes

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

RESTRICT="mirror test"
SLOT="1.0/$(ver_cut 1-2 ${MY_PV})" # 1.0 is same as media-libs/gstreamer
IUSE+="
${LLVM_COMPAT[@]/#/llvm_slot_}
${MODULES[@]}
${PATENT_STATUS_IUSE[@]}
aom doc nvcodec qsv openh264 rav1e system-libsodium va vaapi vpx vulkan x264 x265
webrtc-aws
webrtc-livekit
ebuild_revision_30
"
WEBRTC_AV1_ENCODERS_REQUIRED_USE="
	!patent_status_nonfree? (
		|| (
			aom
			rav1e
			va
		)
		!nvcodec
	)
	patent_status_nonfree? (
		|| (
			aom
			nvcodec
			rav1e
			va
		)
	)
"
WEBRTC_H264_ENCODERS_REQUIRED_USE="
	!patent_status_nonfree? (
		!nvcodec
		!qsv
		!openh264
		!va
		!vaapi
		!x264
	)
	patent_status_nonfree? (
		|| (
			nvcodec
			qsv
			openh264
			va
			vaapi
			x264
		)
	)
"
WEBRTC_H265_ENCODERS_REQUIRED_USE="
	!patent_status_nonfree? (
		!nvcodec
		!qsv
		!va
		!vaapi
		!x265
	)
	patent_status_nonfree? (
		|| (
			nvcodec
			qsv
			va
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
		!va
		!vaapi
		|| (
			aom
		)
	)
	patent_status_nonfree? (
		|| (
			aom
			nvcodec
			va
			vaapi
		)
	)
"
WEBRTC_H264_DECODERS_REQUIRED_USE="
	!patent_status_nonfree? (
		!nvcodec
		!openh264
		!qsv
		!va
		!vaapi
		!vulkan
	)
	patent_status_nonfree? (
		|| (
			nvcodec
			openh264
			qsv
			va
			vaapi
			vulkan
		)
	)
"
WEBRTC_H265_DECODERS_REQUIRED_USE="
	!patent_status_nonfree? (
		!nvcodec
		!qsv
		!va
		!vaapi
		!vulkan
	)
	patent_status_nonfree? (
		|| (
			nvcodec
			qsv
			va
			vaapi
			vulkan
		)
	)
"
WEBRTC_VP8_DECODERS_REQUIRED_USE="
	!patent_status_nonfree? (
		!nvcodec
		!va
		|| (
			vpx
		)
	)
	patent_status_nonfree? (
		|| (
			nvcodec
			va
			vpx
		)
	)
"
WEBRTC_VP9_DECODERS_REQUIRED_USE="
	!patent_status_nonfree? (
		!nvcodec
		!qsv
		!va
		!vaapi
		|| (
			vpx
		)
	)
	patent_status_nonfree? (
		|| (
			nvcodec
			qsv
			va
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
		!fmp4
		!hlssink3
		!nvcodec
		!openh264
		!qsv
		!va
		!vaapi
		!vulkan
		!vvdec
		!x264
		!x265
	)
	flavors? (
		patent_status_nonfree
	)
	fmp4? (
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
	va? (
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
	>=dev-libs/glib-2.62[${MULTILIB_USEDEP}]
	>=dev-libs/gobject-introspection-${GOBJECT_INTROSPECTION_PV}
	elibc_glibc? (
		>=sys-libs/glibc-2.36
	)
	elibc_musl? (
		>=sys-libs/musl-1.1.24
	)
"
CARGO_BINDINGS_DEPENDS_GOBJECT_SYS="
	${CARGO_BINDINGS_DEPENDS_GLIB}
"
CARGO_BINDINGS_DEPENDS_CAIRO="
	${CARGO_BINDINGS_DEPENDS_GOBJECT_SYS}
	>=dev-libs/gobject-introspection-${GOBJECT_INTROSPECTION_PV}
	>=x11-libs/cairo-1.14[${MULTILIB_USEDEP}]
"
CARGO_BINDINGS_DEPENDS_PANGO="
	${CARGO_BINDINGS_DEPENDS_GOBJECT_SYS}
	>=x11-libs/pango-1.40[${MULTILIB_USEDEP},introspection]
"
CARGO_BINDINGS_DEPENDS_GTK4="
	${CARGO_BINDINGS_DEPENDS_CAIRO}
	${CARGO_BINDINGS_DEPENDS_PANGO}
	>=gui-libs/gtk-4.6:4[introspection,gstreamer]
	>=media-libs/graphene-1.10[introspection]
	>=x11-libs/gdk-pixbuf-2.36.8[introspection]
"

PATENT_STATUS_RDEPEND="
	virtual/patent-status[patent_status_nonfree=]
"
RDEPEND+="
	${CARGO_BINDINGS_DEPENDS_GLIB}
	${PATENT_STATUS_RDEPEND}
	~media-plugins/gst-plugins-meta-${GST_PV}:1.0[${MULTILIB_USEDEP}]
	analytics? (
		>=media-plugins/gst-plugins-analyticsoverlay-${GST_PV}:1.0[${MULTILIB_USEDEP}]
	)
	aws? (
		>=dev-libs/openssl-1.1[${MULTILIB_USEDEP}]
	)
	closedcaption? (
		${CARGO_BINDINGS_DEPENDS_CAIRO}
		${CARGO_BINDINGS_DEPENDS_PANGO}
	)
	csound? (
		>=media-sound/csound-6.18.1[${MULTILIB_USEDEP}]
	)
	dav1d? (
		>=media-libs/dav1d-1.3[${MULTILIB_USEDEP}]
		media-libs/dav1d:=[${MULTILIB_USEDEP}]
	)
	gtk4? (
		${CARGO_BINDINGS_DEPENDS_GTK4}
		>=media-libs/gst-plugins-base-${GST_PV}:1.0[${MULTILIB_USEDEP},opengl]
	)
	onvif? (
		${CARGO_BINDINGS_DEPENDS_CAIRO}
		${CARGO_BINDINGS_DEPENDS_PANGO}
	)
	system-libsodium? (
		>=dev-libs/libsodium-1.0.18[${MULTILIB_USEDEP}]
	)
	videofx? (
		${CARGO_BINDINGS_DEPENDS_CAIRO}
	)
	webp? (
		>=media-libs/libwebp-1.2.4[${MULTILIB_USEDEP}]
	)
	webrtc? (
		~media-plugins/gst-plugins-opus-${GST_PV}:1.0[${MULTILIB_USEDEP}]
		~media-plugins/gst-plugins-rtp-${GST_PV}:1.0[${MULTILIB_USEDEP}]
		aom? (
			~media-plugins/gst-plugins-aom-${GST_PV}:1.0[${MULTILIB_USEDEP}]
		)
		nvcodec? (
			~media-plugins/gst-plugins-bad-${GST_PV}:1.0[${MULTILIB_USEDEP},nvcodec]
		)
		openh264? (
			~media-plugins/gst-plugins-openh264-${GST_PV}:1.0[${MULTILIB_USEDEP}]
		)
		qsv? (
			~media-plugins/gst-plugins-bad-${GST_PV}:1.0[${MULTILIB_USEDEP},qsv]
		)
		rav1e? (
			${CARGO_BINDINGS_DEPENDS_CAIRO}
			~media-plugins/gst-plugins-rav1e-${GST_PV}:1.0[${MULTILIB_USEDEP}]
		)
		va? (
			>=media-plugins/gst-plugins-bad-${GST_PV}:1.0[${MULTILIB_USEDEP},vaapi]
		)
		vaapi? (
			~media-plugins/gst-plugins-vaapi-${GST_PV}:1.0[${MULTILIB_USEDEP}]
		)
		vpx? (
			~media-plugins/gst-plugins-vpx-${GST_PV}:1.0[${MULTILIB_USEDEP}]
		)
		vulkan? (
			~media-plugins/gst-plugins-bad-${GST_PV}:1.0[${MULTILIB_USEDEP},vulkan,vulkan-video]
		)
		x264? (
			~media-plugins/gst-plugins-x264-${GST_PV}:1.0[${MULTILIB_USEDEP}]
		)
		x265? (
			~media-plugins/gst-plugins-x265-${GST_PV}:1.0[${MULTILIB_USEDEP}]
		)
	)
	webrtchttp? (
		~media-plugins/gst-plugins-webrtc-${GST_PV}:1.0[${MULTILIB_USEDEP}]
	)
	vvdec? (
		>=media-libs/vvdec-3.0[${MULTILIB_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
# Update while keeping track of versions of rust.
# Expanded here because the virtual system is broken for multilib.
gen_llvm_bdepend() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				llvm-core/clang:${s}[${MULTILIB_USEDEP}]
				llvm-core/llvm:${s}[${MULTILIB_USEDEP}]
			)
		"
	done
}
RUST1_BDEPEND="
	llvm_slot_19? (
		|| (
			=dev-lang/rust-1.85*[${MULTILIB_USEDEP}]
			=dev-lang/rust-1.86*[${MULTILIB_USEDEP}]
			=dev-lang/rust-bin-1.85*[${MULTILIB_USEDEP}]
			=dev-lang/rust-bin-1.86*[${MULTILIB_USEDEP}]
		)
	)
	|| (
		dev-lang/rust:=
		dev-lang/rust-bin:=
	)
"
RUST_BDEPEND="
	llvm_slot_19? (
		|| (
			=dev-lang/rust-bin-1.85*[${MULTILIB_USEDEP}]
			=dev-lang/rust-1.85*[${MULTILIB_USEDEP}]
		)
	)
	|| (
		dev-lang/rust-bin:=
		dev-lang/rust:=
	)
"
BDEPEND+="
	${RUST_BDEPEND}
	$(gen_llvm_bdepend)
	>=dev-build/meson-1.1
	>=dev-util/cargo-c-0.9.21
	>=dev-util/pkgconf-1.8.1[${MULTILIB_USEDEP},pkg-config(+)]
	>=sys-devel/binutils-2.40
	>=sys-devel/gcc-12.2.0
	doc? (
		$(python_gen_any_dep '
			dev-python/hotdoc[${PYTHON_USEDEP}]
		')
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-1.26.0-some-mismatched-types.patch"
)

pkg_setup() {
	if [[ "${GENERATE_LOCKFILE}" =~ "1" ]] ; then
		sandbox-changes_no_network_sandbox "To download internal dependencies"
	fi
	if has fallback-commit ${IUSE} && ! use fallback-commit ; then
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

multilib_src_configure() {
	local llvm_slot=""
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		if has "llvm_slot_${s}" ${IUSE_EFFECTIVE} && use "llvm_slot_${s}" ; then
			llvm_slot="${s}"
			break
		fi
	done
	LLVM_MAX_SLOT=${llvm_slot}
	llvm_pkg_setup
einfo "LLVM SLOT:  ${LLVM_MAX_SLOT}"
	${RUSTC} --version || die

	export CSOUND_LIB_DIR="${ESYSROOT}/usr/$(get_libdir)"

	local m
	for m in ${MODULES[@]} ; do
		emesonargs+=(
			$(meson_feature ${m})
		)
	done

	if use system-libsodium ; then
		emesonargs+=(
			-Dsodium-source=system
		)
	fi

	meson_src_configure
}

_production_unpack() {
	if has fallback-commit ${IUSE} && use fallback-commit ; then
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
		#unpack "gst-plugins-rs-gstreamer-${MY_PV}.tar.bz2"
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
	#die # For manual lockfile update

	if [[ "${GENERATE_LOCKFILE}" =~ "1" && "${LOCKFILE_SOURCE}" == "upstream" ]] ; then
		_lockfile_gen_unpack_upstream
	elif [[ "${GENERATE_LOCKFILE}" =~ "1" ]] ; then
		_lockfile_gen_unpack
	else
		_production_unpack
	fi
}

src_prepare() {
	default
	sed -i \
		-e "s|csound64|csound|g" \
		"meson.build" \
		|| die
}

multilib_src_configure() {
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
