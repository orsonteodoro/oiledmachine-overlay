# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# The lockfile should be updated once a week for security reasons.

EAPI=8

# D12-slim
# The versioning is based on the tag with the gstreamer- prefix.
# The project version is 0.12.5.

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
EXPECTED_BUILD_FILES_FINGERPRINT="disable"
GOBJECT_INTROSPECTION_PV="1.74.0"
GST_PV="${MY_PV}"
LLVM_COMPAT=( {17..16} ) # For clang-sys ; slot based on rust subslot
LLVM_MAX_SLOT="${LLVM_COMPAT[0]}"
MODULES=(
	audiofx
	aws
	cdg
	claxon
	closedcaption
	csound
	dav1d
	doc
	examples
	fallbackswitch
	ffv1
	file
	flavors
	fmp4
	gif
	gtk4
	hlssink3
	hsv
	inter
	json
	lewton
	livesync
	mp4
	ndi
	onvif
	png
	raptorq
	rav1e
	regex
	reqwest
	rtp
	rtsp
	spotify
	sodium
#	test
	textahead
	textwrap
	threadshare
	togglerecord
	tracers
	uriplaylistbin
	videofx
	webp
	webrtc
	webrtchttp
)
PATENT_STATUS_IUSE=(
	patent_status_nonfree
)
PYTHON_COMPAT=( python3_{8..11} )

if [[ "${MY_PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_COMMIT="HEAD"
	EGIT_COMMIT_FALLBACK="177dd1af8ddcd9f6755ea7007b63169c6f2a3ee7" # Oct 29, 2024
#	EGIT_COMMIT_FALLBACK="d51226dce5c133837c1c70df3f87bb6a437a0775" # Apr 29, 2024
	EGIT_REPO_URI="https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs.git"
	MY_PV="9999"
	inherit git-r3
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${PN}-${MY_PV}"
else
	#KEYWORDS="~amd64" # Missing gstreamer 1.24 on distro repo
	S="${WORKDIR}/gst-plugins-rs-gstreamer-${MY_PV}"
	SRC_URI+="
https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/gstreamer-${MY_PV}/gst-plugins-rs-gstreamer-${MY_PV}.tar.bz2
	"
	if [[ "${GENERATE_LOCKFILE}" == "1" ]] ; then
		:
	else
CRATES="
addr2line-0.24.2
adler2-2.0.0
aes-0.6.0
aes-ctr-0.6.0
aes-soft-0.6.4
aesni-0.10.0
aho-corasick-1.1.3
aligned-vec-0.5.0
allocator-api2-0.2.21
android-tzdata-0.1.1
android_system_properties-0.1.5
anstream-0.6.18
anstyle-1.0.10
anstyle-parse-0.2.6
anstyle-query-1.1.2
anstyle-wincon-3.0.7
anyhow-1.0.95
arbitrary-1.4.1
arg_enum_proc_macro-0.3.4
arrayvec-0.7.6
async-channel-2.3.1
async-compression-0.4.18
async-recursion-1.1.1
async-stream-0.3.6
async-stream-impl-0.3.6
async-task-4.7.1
async-trait-0.1.86
async-tungstenite-0.26.2
atomic-waker-1.1.2
atomic_refcell-0.1.13
autocfg-1.4.0
av1-grain-0.2.3
aws-config-1.5.16
aws-credential-types-1.2.1
aws-runtime-1.5.5
aws-sdk-kinesisvideo-1.59.0
aws-sdk-kinesisvideosignaling-1.58.0
aws-sdk-s3-1.74.0
aws-sdk-sso-1.58.0
aws-sdk-ssooidc-1.59.0
aws-sdk-sts-1.59.0
aws-sdk-transcribestreaming-1.60.0
aws-sdk-translate-1.58.0
aws-sigv4-1.2.8
aws-smithy-async-1.2.4
aws-smithy-checksums-0.62.0
aws-smithy-eventstream-0.60.6
aws-smithy-http-0.60.12
aws-smithy-json-0.61.2
aws-smithy-query-0.60.7
aws-smithy-runtime-1.7.8
aws-smithy-runtime-api-1.7.3
aws-smithy-types-1.2.13
aws-smithy-xml-0.60.9
aws-types-1.3.5
backtrace-0.3.74
base16ct-0.1.1
base32-0.5.1
base64-0.13.1
base64-0.21.7
base64-0.22.1
base64-serde-0.7.0
base64-simd-0.8.0
base64ct-1.6.0
bincode-1.3.3
bitflags-1.3.2
bitflags-2.8.0
bitstream-io-2.6.0
block-buffer-0.10.4
block-buffer-0.9.0
bstr-1.11.3
build_const-0.2.2
built-0.7.6
bumpalo-3.17.0
byte-slice-cast-1.2.2
bytemuck-1.21.0
byteorder-1.5.0
bytes-1.10.0
bytes-utils-0.1.4
cbindgen-0.27.0
cc-1.2.13
cdg-0.1.0
cdg_renderer-0.7.1
cea708-types-0.3.5
cfg-expr-0.15.8
cfg-if-1.0.0
chrono-0.4.39
cipher-0.2.5
clap-4.5.28
clap_builder-4.5.27
clap_derive-4.5.28
clap_lex-0.7.4
claxon-0.4.3
color-name-1.1.0
color-thief-0.2.2
color_quant-1.1.0
colorchoice-1.0.3
concurrent-queue-2.5.0
const-oid-0.9.6
cookie-0.18.1
cookie-factory-0.3.3
cookie_store-0.21.1
core-foundation-0.9.4
core-foundation-sys-0.8.7
cpufeatures-0.2.17
crc-1.8.1
crc-3.2.1
crc-catalog-2.4.0
crc32c-0.6.8
crc32fast-1.4.2
crc64fast-nvme-1.1.1
crossbeam-channel-0.5.14
crossbeam-deque-0.8.6
crossbeam-epoch-0.9.18
crossbeam-utils-0.8.21
crypto-bigint-0.4.9
crypto-bigint-0.5.5
crypto-common-0.1.6
crypto-mac-0.11.0
csound-0.1.8
csound-sys-0.1.2
ctr-0.6.0
darling-0.20.10
darling_core-0.20.10
darling_macro-0.20.10
dash-mpd-0.16.6
dasp_frame-0.11.0
dasp_sample-0.11.0
data-encoding-2.8.0
dav1d-0.9.6
dav1d-sys-0.7.3
der-0.6.1
deranged-0.3.11
diff-0.1.13
digest-0.10.7
digest-0.9.0
displaydoc-0.2.5
document-features-0.2.10
dssim-core-3.2.11
ebur128-0.1.10
ecdsa-0.14.8
ed25519-1.5.3
either-1.13.0
elliptic-curve-0.12.3
encoding_rs-0.8.35
env_logger-0.10.2
equivalent-1.0.1
errno-0.3.10
event-listener-5.4.0
event-listener-strategy-0.5.3
fallible-iterator-0.3.0
fastrand-2.3.0
fdeflate-0.3.7
ff-0.12.1
field-offset-0.3.6
fixedbitset-0.4.2
flate2-1.0.35
flume-0.11.1
fnv-1.0.7
foldhash-0.1.4
foreign-types-0.3.2
foreign-types-shared-0.1.1
form_urlencoded-1.2.1
fs-err-2.11.0
fst-0.4.7
futures-0.3.31
futures-channel-0.3.31
futures-core-0.3.31
futures-executor-0.3.31
futures-io-0.3.31
futures-macro-0.3.31
futures-sink-0.3.31
futures-task-0.3.31
futures-util-0.3.31
generic-array-0.14.7
getrandom-0.2.15
getrandom-0.3.1
gif-0.13.1
gimli-0.31.1
glob-0.3.2
group-0.12.1
h2-0.3.26
h2-0.4.7
hashbrown-0.12.3
hashbrown-0.15.2
headers-0.3.9
headers-0.4.0
headers-core-0.2.0
headers-core-0.3.0
heck-0.4.1
heck-0.5.0
hermit-abi-0.3.9
hermit-abi-0.4.0
hex-0.4.3
hmac-0.11.0
hmac-0.12.1
hrtf-0.8.1
http-0.2.12
http-1.2.0
http-body-0.4.6
http-body-1.0.1
http-body-util-0.1.2
httparse-1.10.0
httpdate-1.0.3
human_bytes-0.4.3
humantime-2.1.0
hyper-0.14.32
hyper-1.6.0
hyper-proxy-0.9.1
hyper-rustls-0.24.2
hyper-rustls-0.27.5
hyper-tls-0.5.0
hyper-tls-0.6.0
hyper-util-0.1.10
hyphenation-0.8.4
hyphenation_commons-0.8.4
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
ident_case-1.0.1
idna-1.0.3
idna_adapter-1.2.0
image-0.24.9
image_hasher-1.2.0
imgref-1.11.0
indexmap-1.9.3
indexmap-2.7.1
interpolate_name-0.2.4
ipnet-2.11.0
is-terminal-0.4.15
is_terminal_polyfill-1.70.1
iso8601-0.6.2
itertools-0.11.0
itertools-0.12.1
itertools-0.13.0
itertools-0.14.0
itoa-1.0.14
jobserver-0.1.32
js-sys-0.3.77
jsonwebtoken-9.3.1
khronos-egl-6.0.0
lazy_static-1.5.0
lewton-0.10.2
libc-0.2.169
libfuzzer-sys-0.4.9
libloading-0.8.6
libm-0.2.11
librespot-audio-0.4.2
librespot-core-0.4.2
librespot-metadata-0.4.2
librespot-playback-0.4.2
librespot-protocol-0.4.2
libsodium-sys-0.2.7
libwebp-sys2-0.1.10
linux-raw-sys-0.4.15
litemap-0.7.4
litrs-0.4.1
livekit-api-0.3.2
livekit-protocol-0.3.8
livekit-runtime-0.4.0
lock_api-0.4.12
log-0.4.25
lru-0.12.5
m3u8-rs-5.0.5
matchers-0.1.0
maybe-rayon-0.1.1
md-5-0.10.6
memchr-2.7.4
memoffset-0.9.1
mime-0.3.17
mime_guess-2.0.5
minimal-lexical-0.2.1
miniz_oxide-0.8.3
mio-1.0.3
more-asserts-0.3.1
muldiv-1.0.1
multer-2.1.0
multimap-0.10.0
nanorand-0.7.0
nasm-rs-0.2.5
native-tls-0.2.13
new_debug_unreachable-1.0.6
nnnoiseless-0.5.1
nom-7.1.3
nom-8.0.0
noop_proc_macro-0.3.0
nu-ansi-term-0.46.0
num-bigint-0.4.6
num-complex-0.4.6
num-conv-0.1.0
num-derive-0.4.2
num-integer-0.1.46
num-rational-0.4.2
num-traits-0.2.19
num_cpus-1.16.0
object-0.36.7
ogg-0.8.0
once_cell-1.20.3
opaque-debug-0.3.1
openssl-0.10.70
openssl-macros-0.1.1
openssl-probe-0.1.6
openssl-sys-0.9.105
option-operations-0.5.0
outref-0.5.2
overload-0.1.1
p256-0.11.1
parking-2.2.1
parking_lot-0.12.3
parking_lot_core-0.9.10
parse_link_header-0.3.3
paste-1.0.15
pbjson-0.6.0
pbjson-build-0.6.2
pbjson-types-0.6.0
pbkdf2-0.8.0
percent-encoding-2.3.1
petgraph-0.6.5
pin-project-1.1.9
pin-project-internal-1.1.9
pin-project-lite-0.2.16
pin-utils-0.1.0
pkcs8-0.9.0
pkg-config-0.3.31
png-0.17.16
pocket-resources-0.3.2
polling-3.7.4
powerfmt-0.2.0
ppv-lite86-0.2.20
pretty_assertions-1.4.1
prettyplease-0.2.29
primal-check-0.3.4
priority-queue-1.4.0
proc-macro-crate-3.2.0
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro2-1.0.93
profiling-1.0.16
profiling-procmacros-1.0.16
prost-0.12.6
prost-build-0.12.6
prost-derive-0.12.6
prost-types-0.12.6
protobuf-2.28.0
protobuf-codegen-2.28.0
protobuf-codegen-pure-2.28.0
psl-types-2.0.11
publicsuffix-2.3.0
quick-xml-0.31.0
quick-xml-0.36.2
quote-1.0.38
rand-0.8.5
rand_chacha-0.3.1
rand_core-0.6.4
rand_distr-0.4.3
raptorq-1.8.1
rav1e-0.7.1
rayon-1.10.0
rayon-core-1.12.1
realfft-3.4.0
redox_syscall-0.5.8
regex-1.11.1
regex-automata-0.1.10
regex-automata-0.4.9
regex-lite-0.1.6
regex-syntax-0.6.29
regex-syntax-0.8.5
reqwest-0.11.27
reqwest-0.12.12
rfc6979-0.3.1
rgb-0.8.50
ring-0.17.8
rtsp-types-0.1.3
rubato-0.14.1
rustc-demangle-0.1.24
rustc_version-0.4.1
rustdct-0.7.1
rustfft-6.2.0
rustix-0.38.44
rustls-0.21.12
rustls-0.23.22
rustls-native-certs-0.6.3
rustls-pemfile-1.0.4
rustls-pemfile-2.2.0
rustls-pki-types-1.11.0
rustls-webpki-0.101.7
rustls-webpki-0.102.8
rustversion-1.0.19
ryu-1.0.19
same-file-1.0.6
scc-2.3.3
schannel-0.1.27
scoped-tls-1.0.1
scopeguard-1.2.0
sct-0.7.1
sdd-3.0.7
sdp-types-0.1.7
sec1-0.3.0
security-framework-2.11.1
security-framework-sys-2.14.0
semver-1.0.25
serde-1.0.217
serde_bytes-0.11.15
serde_derive-1.0.217
serde_json-1.0.138
serde_path_to_error-0.1.16
serde_spanned-0.6.8
serde_urlencoded-0.7.1
serde_with-3.12.0
serde_with_macros-3.12.0
serial_test-3.2.0
serial_test_derive-3.2.0
sha-1-0.9.8
sha1-0.10.6
sha2-0.10.8
shannon-0.2.0
sharded-slab-0.1.7
shell-words-1.1.0
shlex-1.3.0
signal-hook-0.3.17
signal-hook-registry-1.4.2
signature-1.6.4
simd-adler32-0.3.7
simd_helpers-0.1.0
slab-0.4.9
smallvec-1.13.2
smawk-0.3.2
socket2-0.5.8
sodiumoxide-0.2.7
spin-0.9.8
spki-0.6.0
sprintf-0.1.4
stable_deref_trait-1.2.0
strength_reduce-0.2.4
strsim-0.11.1
subtle-2.6.1
syn-1.0.109
syn-2.0.98
sync_wrapper-0.1.2
sync_wrapper-1.0.2
synstructure-0.13.1
system-configuration-0.5.1
system-configuration-0.6.1
system-configuration-sys-0.5.0
system-configuration-sys-0.6.0
system-deps-6.2.2
target-lexicon-0.12.16
tempfile-3.16.0
termcolor-1.4.1
test-log-0.2.17
test-log-macros-0.2.17
test-with-0.12.6
textwrap-0.16.1
thiserror-1.0.69
thiserror-2.0.11
thiserror-impl-1.0.69
thiserror-impl-2.0.11
thread-id-4.2.2
thread_local-1.1.8
time-0.3.37
time-core-0.1.2
time-macros-0.2.19
tinystr-0.7.6
tinyvec-1.8.1
tinyvec_macros-0.1.1
tokio-1.43.0
tokio-macros-2.5.0
tokio-native-tls-0.3.1
tokio-rustls-0.24.1
tokio-rustls-0.26.1
tokio-stream-0.1.17
tokio-tungstenite-0.20.1
tokio-tungstenite-0.21.0
tokio-util-0.7.13
toml-0.8.20
toml_datetime-0.6.8
toml_edit-0.22.23
tower-0.5.2
tower-layer-0.3.3
tower-service-0.3.3
tracing-0.1.41
tracing-attributes-0.1.28
tracing-core-0.1.33
tracing-log-0.2.0
tracing-subscriber-0.3.19
transpose-0.2.3
try-lock-0.2.5
tungstenite-0.20.1
tungstenite-0.21.0
tungstenite-0.23.0
typenum-1.17.0
unicase-2.8.1
unicode-ident-1.0.16
unicode-linebreak-0.1.5
unicode-width-0.1.14
untrusted-0.9.0
url-2.5.4
url-escape-0.1.1
urlencoding-2.1.3
utf-8-0.7.6
utf16_iter-1.0.5
utf8_iter-1.0.4
utf8parse-0.2.2
uuid-1.13.1
v_frame-0.3.8
va_list-0.1.4
valuable-0.1.1
vcpkg-0.2.15
vergen-3.2.0
version-compare-0.2.0
version_check-0.9.5
vsimd-0.8.0
waker-fn-1.2.0
walkdir-2.5.0
want-0.3.1
warp-0.3.7
wasi-0.11.0+wasi-snapshot-preview1
wasi-0.13.3+wasi-0.2.2
wasm-bindgen-0.2.100
wasm-bindgen-backend-0.2.100
wasm-bindgen-futures-0.4.50
wasm-bindgen-macro-0.2.100
wasm-bindgen-macro-support-0.2.100
wasm-bindgen-shared-0.2.100
web-sys-0.3.77
weezl-0.1.8
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.9
winapi-x86_64-pc-windows-gnu-0.4.0
windows-core-0.52.0
windows-registry-0.2.0
windows-result-0.2.0
windows-strings-0.1.0
windows-sys-0.48.0
windows-sys-0.52.0
windows-sys-0.59.0
windows-targets-0.48.5
windows-targets-0.52.6
windows_aarch64_gnullvm-0.48.5
windows_aarch64_gnullvm-0.52.6
windows_aarch64_msvc-0.48.5
windows_aarch64_msvc-0.52.6
windows_i686_gnu-0.48.5
windows_i686_gnu-0.52.6
windows_i686_gnullvm-0.52.6
windows_i686_msvc-0.48.5
windows_i686_msvc-0.52.6
windows_x86_64_gnu-0.48.5
windows_x86_64_gnu-0.52.6
windows_x86_64_gnullvm-0.48.5
windows_x86_64_gnullvm-0.52.6
windows_x86_64_msvc-0.48.5
windows_x86_64_msvc-0.52.6
winnow-0.7.1
winreg-0.50.0
wit-bindgen-rt-0.33.0
write16-1.0.0
writeable-0.5.5
xattr-1.4.0
xml-rs-0.8.25
xmlparser-0.13.6
xmltree-0.10.3
yansi-1.0.1
yoke-0.7.5
yoke-derive-0.7.5
zerocopy-0.6.6
zerocopy-0.7.35
zerocopy-derive-0.6.6
zerocopy-derive-0.7.35
zerofrom-0.1.5
zerofrom-derive-0.1.5
zeroize-1.8.1
zerovec-0.10.4
zerovec-derive-0.10.3
"

declare -A GIT_CRATES=(
[cairo-rs]="https://github.com/gtk-rs/gtk-rs-core;ed9a0d549a7bebba77a1d055cefb27c4b59097f3;gtk-rs-core-%commit%/cairo" # 0.19.9
[cairo-sys-rs]="https://github.com/gtk-rs/gtk-rs-core;ed9a0d549a7bebba77a1d055cefb27c4b59097f3;gtk-rs-core-%commit%/cairo/sys" # 0.19.9
[ffv1]="https://github.com/rust-av/ffv1;2afb025a327173ce891954c052e804d0f880368a;ffv1-%commit%" # 0.0.0
[flavors]="https://github.com/rust-av/flavors;833508af656d298c269f2397c8541a084264d992;flavors-%commit%" # 0.2.0
[gdk-pixbuf-sys]="https://github.com/gtk-rs/gtk-rs-core;ed9a0d549a7bebba77a1d055cefb27c4b59097f3;gtk-rs-core-%commit%/gdk-pixbuf/sys" # 0.19.9
[gdk-pixbuf]="https://github.com/gtk-rs/gtk-rs-core;ed9a0d549a7bebba77a1d055cefb27c4b59097f3;gtk-rs-core-%commit%/gdk-pixbuf" # 0.19.9
[gdk4-sys]="https://github.com/gtk-rs/gtk4-rs;cf84b5cd36fc1aa31175bc24ff45e8ceb0710dec;gtk4-rs-%commit%/gdk4/sys" # 0.8.2
[gdk4-wayland-sys]="https://github.com/gtk-rs/gtk4-rs;cf84b5cd36fc1aa31175bc24ff45e8ceb0710dec;gtk4-rs-%commit%/gdk4-wayland/sys" # 0.8.2
[gdk4-wayland]="https://github.com/gtk-rs/gtk4-rs;cf84b5cd36fc1aa31175bc24ff45e8ceb0710dec;gtk4-rs-%commit%/gdk4-wayland" # 0.8.2
[gdk4-win32-sys]="https://github.com/gtk-rs/gtk4-rs;cf84b5cd36fc1aa31175bc24ff45e8ceb0710dec;gtk4-rs-%commit%/gdk4-win32/sys" # 0.8.2
[gdk4-win32]="https://github.com/gtk-rs/gtk4-rs;cf84b5cd36fc1aa31175bc24ff45e8ceb0710dec;gtk4-rs-%commit%/gdk4-win32" # 0.8.2
[gdk4-x11-sys]="https://github.com/gtk-rs/gtk4-rs;cf84b5cd36fc1aa31175bc24ff45e8ceb0710dec;gtk4-rs-%commit%/gdk4-x11/sys" # 0.8.2
[gdk4-x11]="https://github.com/gtk-rs/gtk4-rs;cf84b5cd36fc1aa31175bc24ff45e8ceb0710dec;gtk4-rs-%commit%/gdk4-x11" # 0.8.2
[gdk4]="https://github.com/gtk-rs/gtk4-rs;cf84b5cd36fc1aa31175bc24ff45e8ceb0710dec;gtk4-rs-%commit%/gdk4" # 0.8.2
[gio-sys]="https://github.com/gtk-rs/gtk-rs-core;ed9a0d549a7bebba77a1d055cefb27c4b59097f3;gtk-rs-core-%commit%/gio/sys" # 0.19.9
[gio]="https://github.com/gtk-rs/gtk-rs-core;ed9a0d549a7bebba77a1d055cefb27c4b59097f3;gtk-rs-core-%commit%/gio" # 0.19.9
[glib-macros]="https://github.com/gtk-rs/gtk-rs-core;ed9a0d549a7bebba77a1d055cefb27c4b59097f3;gtk-rs-core-%commit%/glib-macros" # 0.19.9
[glib-sys]="https://github.com/gtk-rs/gtk-rs-core;ed9a0d549a7bebba77a1d055cefb27c4b59097f3;gtk-rs-core-%commit%/glib/sys" # 0.19.9
[glib]="https://github.com/gtk-rs/gtk-rs-core;ed9a0d549a7bebba77a1d055cefb27c4b59097f3;gtk-rs-core-%commit%/glib" # 0.19.9
[gobject-sys]="https://github.com/gtk-rs/gtk-rs-core;ed9a0d549a7bebba77a1d055cefb27c4b59097f3;gtk-rs-core-%commit%/glib/gobject-sys" # 0.19.9
[graphene-rs]="https://github.com/gtk-rs/gtk-rs-core;ed9a0d549a7bebba77a1d055cefb27c4b59097f3;gtk-rs-core-%commit%/graphene" # 0.19.9
[graphene-sys]="https://github.com/gtk-rs/gtk-rs-core;ed9a0d549a7bebba77a1d055cefb27c4b59097f3;gtk-rs-core-%commit%/graphene/sys" # 0.19.9
[gsk4-sys]="https://github.com/gtk-rs/gtk4-rs;cf84b5cd36fc1aa31175bc24ff45e8ceb0710dec;gtk4-rs-%commit%/gsk4/sys" # 0.8.2
[gsk4]="https://github.com/gtk-rs/gtk4-rs;cf84b5cd36fc1aa31175bc24ff45e8ceb0710dec;gtk4-rs-%commit%/gsk4" # 0.8.2
[gstreamer-allocators-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;" # 0.22.8
[gstreamer-allocators]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;" # 0.22.8
[gstreamer-app-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-app/sys" # 0.22.8
[gstreamer-app]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-app" # 0.22.8
[gstreamer-audio-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-audio/sys" # 0.22.8
[gstreamer-audio]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-audio" # 0.22.8
[gstreamer-base-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-base/sys" # 0.22.8
[gstreamer-base]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-base" # 0.22.8
[gstreamer-check-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-check/sys" # 0.22.8
[gstreamer-check]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-check" # 0.22.8
[gstreamer-gl-egl-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-gl/egl/sys" # 0.22.8
[gstreamer-gl-egl]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-gl/egl" # 0.22.8
[gstreamer-gl-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-gl/sys" # 0.22.8
[gstreamer-gl-wayland-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-gl/wayland/sys" # 0.22.8
[gstreamer-gl-wayland]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-gl/wayland" # 0.22.8
[gstreamer-gl-x11-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-gl/x11/sys" # 0.22.8
[gstreamer-gl-x11]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-gl/x11" # 0.22.8
[gstreamer-gl]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-gl" # 0.22.8
[gstreamer-net-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-net/sys" # 0.22.8
[gstreamer-net]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-net" # 0.22.8
[gstreamer-pbutils-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-pbutils/sys" # 0.22.8
[gstreamer-pbutils]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-pbutils" # 0.22.8
[gstreamer-rtp-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-rtp/sys" # 0.22.8
[gstreamer-rtp]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-rtp" # 0.22.8
[gstreamer-sdp-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-sdp/sys" # 0.22.8
[gstreamer-sdp]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-sdp" # 0.22.8
[gstreamer-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer/sys" # 0.22.8
[gstreamer-utils]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-utils" # 0.22.8
[gstreamer-video-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-video/sys" # 0.22.8
[gstreamer-video]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-video" # 0.22.8
[gstreamer-webrtc-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-webrtc/sys" # 0.22.8
[gstreamer-webrtc]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer-webrtc" # 0.22.8
[gstreamer]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;256e4319e9ef6efa4623eb39217caf5cf939f092;gstreamer-rs-%commit%/gstreamer" # 0.22.8
[gtk4-macros]="https://github.com/gtk-rs/gtk4-rs;cf84b5cd36fc1aa31175bc24ff45e8ceb0710dec;gtk4-rs-%commit%/gtk4-macros" # 0.8.2
[gtk4-sys]="https://github.com/gtk-rs/gtk4-rs;cf84b5cd36fc1aa31175bc24ff45e8ceb0710dec;gtk4-rs-%commit%/gtk4/sys" # 0.8.2
[gtk4]="https://github.com/gtk-rs/gtk4-rs;cf84b5cd36fc1aa31175bc24ff45e8ceb0710dec;gtk4-rs-%commit%/gtk4" # 0.8.2
[pango-sys]="https://github.com/gtk-rs/gtk-rs-core;ed9a0d549a7bebba77a1d055cefb27c4b59097f3;gtk-rs-core-%commit%/pango/sys" # 0.19.9
[pango]="https://github.com/gtk-rs/gtk-rs-core;ed9a0d549a7bebba77a1d055cefb27c4b59097f3;gtk-rs-core-%commit%/pango" # 0.19.9
[pangocairo-sys]="https://github.com/gtk-rs/gtk-rs-core;ed9a0d549a7bebba77a1d055cefb27c4b59097f3;gtk-rs-core-%commit%/pangocairo/sys" # 0.19.9
[pangocairo]="https://github.com/gtk-rs/gtk-rs-core;ed9a0d549a7bebba77a1d055cefb27c4b59097f3;gtk-rs-core-%commit%/pangocairo" # 0.19.9
)

		inherit cargo
		SRC_URI+="$(cargo_crate_uris)"
	fi
fi

inherit flag-o-matic lcnr llvm meson multilib-minimal python-any-r1 rust

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
ebuild_revision_2
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
	>=dev-libs/glib-2.56[${MULTILIB_USEDEP}]
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
	${GST_PLUGINS_META}
	${PATENT_STATUS_RDEPEND}
	~media-plugins/gst-plugins-meta-${GST_PV}:1.0[${MULTILIB_USEDEP}]
	aws? (
		>=dev-libs/openssl-3.0.11[${MULTILIB_USEDEP}]
	)
	closedcaption? (
		${CARGO_BINDINGS_DEPENDS_CAIRO}
		${CARGO_BINDINGS_DEPENDS_PANGO}
	)
	csound? (
		>=media-sound/csound-6.18.1[${MULTILIB_USEDEP}]
	)
	dav1d? (
		>=media-libs/dav1d-1.0.0[${MULTILIB_USEDEP}]
		<media-libs/dav1d-1.3[${MULTILIB_USEDEP}]
		media-libs/dav1d:=[${MULTILIB_USEDEP}]
	)
	gtk4? (
		${CARGO_BINDINGS_DEPENDS_GTK4}
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
RUST_BDEPEND="
	llvm_slot_16? (
		|| (
			=dev-lang/rust-1.72*
			=dev-lang/rust-1.71*
			=dev-lang/rust-1.70*
			=dev-lang/rust-bin-1.72*
			=dev-lang/rust-bin-1.71*
			=dev-lang/rust-bin-1.70*
		)
	)
	llvm_slot_17? (
		|| (
			=dev-lang/rust-1.77*[${MULTILIB_USEDEP}]
			=dev-lang/rust-1.75*[${MULTILIB_USEDEP}]
			=dev-lang/rust-1.75*[${MULTILIB_USEDEP}]
			=dev-lang/rust-1.74*[${MULTILIB_USEDEP}]
			=dev-lang/rust-1.73*[${MULTILIB_USEDEP}]
			=dev-lang/rust-bin-1.77*[${MULTILIB_USEDEP}]
			=dev-lang/rust-bin-1.75*[${MULTILIB_USEDEP}]
			=dev-lang/rust-bin-1.75*[${MULTILIB_USEDEP}]
			=dev-lang/rust-bin-1.74*[${MULTILIB_USEDEP}]
			=dev-lang/rust-bin-1.73*[${MULTILIB_USEDEP}]
		)
	)
	|| (
		dev-lang/rust:=
		dev-lang/rust-bin:=
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
)

check_network_sandbox() {
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"-network-sandbox\" must be added per-package env to be able"
eerror "to download the internal dependencies."
eerror
		die
	fi
}

pkg_setup() {
	if [[ "${GENERATE_LOCKFILE}" =~ "1" ]] ; then
		check_network_sandbox
	fi
	if has fallback-commit ${IUSE} && ! use fallback-commit ; then
ewarn
ewarn "It is strongly recommended to use the fallback-commit USE flag for"
ewarn "deterministic rebuilds.  Disabling fallback-commit will likely"
ewarn "fail if the ebuild is not actively maintained *daily*."
ewarn
	fi

	if [[ "${MY_PV}" =~ "9999" ]] ; then
		check_network_sandbox
	fi
	python-any-r1_pkg_setup
	rust_pkg_setup
}

multilib_src_configure() {
	local llvm_slot
	if use llvm_slot_19 ; then
		llvm_slot=19
	elif use llvm_slot_18 ; then
		llvm_slot=18
	elif use llvm_slot_17 ; then
		llvm_slot=17
	elif use llvm_slot_16 ; then
		llvm_slot=16
	fi
	LLVM_MAX_SLOT=${llvm_slot}
	llvm_pkg_setup
einfo "LLVM SLOT:  ${LLVM_MAX_SLOT}"

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
		unpack "gst-plugins-rs-gstreamer-${MY_PV}.tar.bz2"
		if [[ -e "${FILESDIR}/${PV}/Cargo.lock" ]] ; then
			cp -a "${FILESDIR}/${PV}/Cargo.lock" "${S}" || die
		fi
		cargo_src_unpack
	fi
}

_lockfile_gen_unpack() {
	unpack "gst-plugins-rs-gstreamer-${MY_PV}.tar.bz2"
	cd "${S}" || die
einfo "Generating lockfile"
	rm Cargo.lock
	cargo generate-lockfile || die "Failed to update Cargo.lock"
	die
}

_lockfile_gen_unpack_upstream() {
	unpack "gst-plugins-rs-gstreamer-${MY_PV}.tar.bz2"
einfo "Copy Cargo.lock Cargo.toml to the files/${PV}"
	die
}

src_unpack() {
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
