# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# The lockfile should be updated once a week for security reasons.

# Last check dates:
# meson.build - May 1, 2024
# meson_options.txt - May 1, 2024

EAPI=8

# D11-slim
# The versioning is based on the tag with the gstreamer- prefix.
# The project version is 0.9.13.

_gst_plugins_rs_globals() {
	GENERATE_LOCKFILE=${GENERATE_LOCKFILE:-0}
	if [[ "${GENERATE_LOCKFILE}" == "1" ]] ; then
einfo "Generating lockfile"
	fi
}
_gst_plugins_rs_globals
unset -f _gst_plugins_rs_globals

MY_PV="${PV}"
EXPECTED_BUILD_FILES_FINGERPRINT="disable"
GOBJECT_INTROSPECTION_PV="1.74.0"
GST_PV="1.20.0" # Based on meson.build
LLVM_COMPAT=( 17 16 15 ) # For clang-sys ; slot based on virtual/rust subslot
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
PYTHON_COMPAT=( python3_{8..11} )
declare -A VIRTUAL_RUST_PV_TO_LLVM_SLOT=(
# See https://github.com/rust-lang/rust/blob/1.78.0/src/doc/rustc/src/linker-plugin-lto.md?plain=1#L203
	["1.77"]=17 # Build to be tested, max supported by distro
	["1.76"]=17
	["1.75"]=17
	["1.74"]=17
	["1.73"]=17
	["1.72"]=16
	["1.71"]=16
	["1.70"]=16
	["1.69"]=15
	["1.68"]=15
	["1.67"]=15
	["1.66"]=15 # Rust inclusion based "meson static" on CI for issue
)

if [[ "${MY_PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_COMMIT="HEAD"
	EGIT_COMMIT_FALLBACK="a84bbc66f30573b62871db163c48afef75adf6ec" # Feb 2, 2024
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
addr2line-0.20.0
adler-1.0.2
aes-0.6.0
aes-ctr-0.6.0
aesni-0.10.0
aes-soft-0.6.4
aho-corasick-1.1.2
android_system_properties-0.1.5
android-tzdata-0.1.1
anyhow-1.0.75
arbitrary-0.4.7
arg_enum_proc_macro-0.3.4
arrayvec-0.7.4
async-attributes-1.1.2
async-channel-1.9.0
async-channel-2.1.1
async-compression-0.4.5
async-executor-1.8.0
async-global-executor-2.4.1
async-io-1.13.0
async-io-2.2.2
async-lock-2.8.0
async-lock-3.2.0
async-native-tls-0.4.0
async-process-1.8.1
async-recursion-1.0.5
async-signal-0.2.5
async-std-1.12.0
async-task-4.6.0
async-trait-0.1.74
async-tungstenite-0.19.0
atomic_refcell-0.1.13
atomic-waker-1.1.2
atty-0.2.14
autocfg-1.1.0
av1-grain-0.2.2
aws-config-0.53.0
aws-credential-types-0.53.0
aws-endpoint-0.53.0
aws-http-0.53.0
aws-sdk-s3-0.23.0
aws-sdk-sso-0.23.0
aws-sdk-sts-0.23.0
aws-sdk-transcribe-0.23.0
aws-sig-auth-0.53.0
aws-sigv4-0.53.2
aws-smithy-async-0.53.1
aws-smithy-checksums-0.53.1
aws-smithy-client-0.53.1
aws-smithy-eventstream-0.53.1
aws-smithy-http-0.53.1
aws-smithy-http-tower-0.53.1
aws-smithy-json-0.53.1
aws-smithy-query-0.53.1
aws-smithy-types-0.53.1
aws-smithy-xml-0.53.1
aws-types-0.53.0
backoff-0.4.0
backtrace-0.3.68
base32-0.4.0
base64-0.13.1
base64-0.21.5
base64-simd-0.7.0
bincode-1.3.3
bitflags-1.3.2
bitflags-2.4.1
bitstream-io-1.10.0
block-buffer-0.10.4
block-buffer-0.9.0
blocking-1.5.1
build_const-0.2.2
built-0.5.2
bumpalo-3.14.0
bytemuck-1.14.0
byteorder-1.5.0
bytes-1.5.0
byte-slice-cast-1.2.2
bytes-utils-0.1.4
cargo-lock-8.0.3
cc-1.0.83
cdg-0.1.0
cdg_renderer-0.7.1
cfg-expr-0.15.3
cfg-if-1.0.0
chrono-0.4.31
cipher-0.2.5
clap-4.0.32
clap_derive-4.0.21
clap_lex-0.3.0
claxon-0.4.3
color-name-1.1.0
color_quant-1.1.0
color-thief-0.2.2
concurrent-queue-2.4.0
cookie-0.16.2
cookie_store-0.16.2
core-foundation-0.9.4
core-foundation-sys-0.8.6
cpufeatures-0.2.11
crc-1.8.1
crc-3.0.1
crc32c-0.6.4
crc32fast-1.3.2
crc-catalog-2.4.0
crossbeam-deque-0.8.4
crossbeam-epoch-0.9.16
crossbeam-utils-0.8.17
crypto-common-0.1.6
crypto-mac-0.11.1
csound-0.1.8
csound-sys-0.1.2
ctr-0.6.0
dasp_frame-0.11.0
dasp_sample-0.11.0
dav1d-0.9.5
dav1d-sys-0.7.2
diff-0.1.13
digest-0.10.7
digest-0.9.0
dssim-core-3.2.7
ebur128-0.1.8
ed25519-1.5.3
either-1.9.0
encoding_rs-0.8.33
env_logger-0.10.1
env_logger-0.9.3
equivalent-1.0.1
errno-0.3.8
event-listener-2.5.3
event-listener-3.0.1
event-listener-4.0.0
event-listener-strategy-0.4.0
fastrand-1.9.0
fastrand-2.0.1
fdeflate-0.3.1
field-offset-0.3.6
fixedbitset-0.4.2
flate2-1.0.28
flume-0.10.14
fnv-1.0.7
foreign-types-0.3.2
foreign-types-shared-0.1.1
form_urlencoded-1.2.1
fst-0.4.7
futures-0.3.29
futures-channel-0.3.29
futures-core-0.3.29
futures-executor-0.3.29
futures-io-0.3.29
futures-lite-1.13.0
futures-lite-2.1.0
futures-macro-0.3.29
futures-sink-0.3.29
futures-task-0.3.29
futures-util-0.3.29
generic-array-0.14.7
getopts-0.2.21
getrandom-0.2.11
gif-0.12.0
gimli-0.27.3
glob-0.3.1
gloo-timers-0.2.6
h2-0.3.22
hashbrown-0.12.3
hashbrown-0.14.3
headers-0.3.9
headers-core-0.2.0
heck-0.4.1
hermit-abi-0.1.19
hermit-abi-0.3.3
hex-0.4.3
hmac-0.11.0
hmac-0.12.1
hostname-0.3.1
hrtf-0.8.1
http-0.2.11
httparse-1.8.0
http-body-0.4.6
httpdate-1.0.3
human_bytes-0.4.3
humantime-2.1.0
hyper-0.14.27
hyper-proxy-0.9.1
hyper-rustls-0.23.2
hyper-tls-0.5.0
hyphenation-0.8.4
hyphenation_commons-0.8.4
iana-time-zone-0.1.58
iana-time-zone-haiku-0.1.2
idna-0.2.3
idna-0.3.0
idna-0.5.0
if-addrs-0.7.0
image-0.24.7
image_hasher-1.2.0
imgref-1.10.0
indexmap-1.9.3
indexmap-2.1.0
instant-0.1.12
interpolate_name-0.2.4
io-lifetimes-1.0.11
ipnet-2.9.0
is-terminal-0.4.9
itertools-0.10.5
itertools-0.11.0
itoa-1.0.10
jobserver-0.1.26
js-sys-0.3.66
kv-log-macro-1.0.7
lazy_static-1.4.0
lewton-0.10.2
libc-0.2.151
libfuzzer-sys-0.3.5
libloading-0.7.4
libm-0.2.8
libmdns-0.7.5
librespot-0.4.2
librespot-audio-0.4.2
librespot-connect-0.4.2
librespot-core-0.4.2
librespot-discovery-0.4.2
librespot-metadata-0.4.2
librespot-playback-0.4.2
librespot-protocol-0.4.2
libsodium-sys-0.2.7
libwebp-sys2-0.1.9
linux-raw-sys-0.3.8
linux-raw-sys-0.4.12
lock_api-0.4.11
log-0.4.20
m3u8-rs-5.0.5
match_cfg-0.1.0
matchers-0.1.0
matches-0.1.10
maybe-rayon-0.1.1
md-5-0.10.6
memchr-2.6.4
memoffset-0.6.5
memoffset-0.9.0
mime-0.3.17
minimal-lexical-0.2.1
miniz_oxide-0.7.1
mio-0.8.10
more-asserts-0.3.1
muldiv-1.0.1
multimap-0.8.3
nanorand-0.7.0
nasm-rs-0.2.5
native-tls-0.2.11
new_debug_unreachable-1.0.4
nix-0.23.2
nnnoiseless-0.5.1
nom-7.1.3
noop_proc_macro-0.3.0
nu-ansi-term-0.46.0
num-bigint-0.4.4
num-complex-0.4.4
num_cpus-1.16.0
num-derive-0.3.3
num-derive-0.4.1
num-integer-0.1.45
num-rational-0.4.1
num-traits-0.2.17
object-0.31.1
ogg-0.8.0
once_cell-1.19.0
opaque-debug-0.3.0
openssl-0.10.61
openssl-macros-0.1.1
openssl-probe-0.1.5
openssl-sys-0.9.97
option-operations-0.5.0
os_str_bytes-6.5.1
outref-0.1.0
overload-0.1.1
parking-2.2.0
parking_lot-0.12.1
parking_lot_core-0.9.9
parse_link_header-0.3.3
paste-1.0.14
pbkdf2-0.8.0
percent-encoding-2.3.1
petgraph-0.6.3
pin-project-1.1.3
pin-project-internal-1.1.3
pin-project-lite-0.2.13
pin-utils-0.1.0
piper-0.2.1
pkg-config-0.3.27
png-0.17.10
pocket-resources-0.3.2
polling-2.8.0
polling-3.3.1
ppv-lite86-0.2.17
pretty_assertions-1.4.0
pretty-hex-0.3.0
primal-check-0.3.3
priority-queue-1.3.2
proc-macro2-1.0.70
proc-macro-crate-1.3.1
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
protobuf-2.28.0
protobuf-codegen-2.28.0
protobuf-codegen-pure-2.28.0
psl-types-2.0.11
publicsuffix-2.2.3
quote-1.0.33
rand-0.8.5
rand_chacha-0.3.1
rand_core-0.6.4
rand_distr-0.4.3
raptorq-1.8.0
rav1e-0.6.6
rayon-1.8.0
rayon-core-1.12.0
realfft-3.3.0
redox_syscall-0.4.1
regex-1.9.5
regex-automata-0.1.10
regex-automata-0.3.8
regex-syntax-0.6.29
regex-syntax-0.7.5
reqwest-0.11.22
rgb-0.8.37
ring-0.16.20
ring-0.17.7
rpassword-6.0.1
rubato-0.14.1
rustc-demangle-0.1.23
rustc_version-0.4.0
rustdct-0.7.1
rustfft-6.1.0
rust_hawktracer-0.7.0
rust_hawktracer_normal_macro-0.4.1
rust_hawktracer_proc_macro-0.4.1
rustix-0.37.27
rustix-0.38.21
rustls-0.20.9
rustls-native-certs-0.6.3
rustls-pemfile-1.0.4
ryu-1.0.16
same-file-1.0.6
schannel-0.1.22
scopeguard-1.2.0
sct-0.7.1
security-framework-2.9.2
security-framework-sys-2.9.1
semver-1.0.20
serde-1.0.188
serde_bytes-0.11.12
serde_derive-1.0.188
serde_json-1.0.107
serde_spanned-0.6.1
serde_urlencoded-0.7.1
sha1-0.10.6
sha-1-0.9.8
sha2-0.10.8
shannon-0.2.0
sharded-slab-0.1.7
shell-words-1.1.0
signal-hook-0.3.17
signal-hook-registry-1.4.1
signature-1.6.4
simd-abstraction-0.7.1
simd-adler32-0.3.7
simd_helpers-0.1.0
slab-0.4.9
smallvec-1.11.2
smawk-0.3.2
socket2-0.4.10
socket2-0.5.5
sodiumoxide-0.2.7
spin-0.5.2
spin-0.9.8
sprintf-0.1.4
strength_reduce-0.2.4
strsim-0.10.0
subtle-2.4.1
syn-1.0.109
syn-2.0.41
system-configuration-0.5.1
system-configuration-sys-0.5.0
system-deps-6.1.1
target-lexicon-0.12.12
tempfile-3.8.1
termcolor-1.4.0
test-log-0.2.14
test-log-macros-0.2.14
test-with-0.9.7
textwrap-0.16.0
thiserror-1.0.51
thiserror-impl-1.0.51
thread-id-4.2.1
thread_local-1.1.7
time-0.3.20
time-core-0.1.0
time-macros-0.2.8
tinyvec-1.6.0
tinyvec_macros-0.1.1
tokio-1.35.0
tokio-macros-2.2.0
tokio-native-tls-0.3.1
tokio-rustls-0.23.4
tokio-stream-0.1.14
tokio-util-0.7.10
toml-0.5.11
toml-0.7.3
toml_datetime-0.6.1
toml_edit-0.19.8
tower-0.4.13
tower-layer-0.3.2
tower-service-0.3.2
tracing-0.1.40
tracing-attributes-0.1.27
tracing-core-0.1.32
tracing-log-0.1.4
tracing-log-0.2.0
tracing-subscriber-0.3.18
transpose-0.2.2
try-lock-0.2.5
tungstenite-0.18.0
typenum-1.17.0
unicode-bidi-0.3.14
unicode-ident-1.0.12
unicode-linebreak-0.1.5
unicode-normalization-0.1.22
unicode-width-0.1.11
untrusted-0.7.1
untrusted-0.9.0
url-2.5.0
urlencoding-2.1.3
utf-8-0.7.6
uuid-1.6.1
va_list-0.1.4
valuable-0.1.0
value-bag-1.4.2
vcpkg-0.2.15
vergen-3.2.0
version_check-0.9.4
version-compare-0.1.1
v_frame-0.3.6
waker-fn-1.1.1
walkdir-2.4.0
want-0.3.1
wasi-0.11.0+wasi-snapshot-preview1
wasm-bindgen-0.2.89
wasm-bindgen-backend-0.2.89
wasm-bindgen-futures-0.4.39
wasm-bindgen-macro-0.2.89
wasm-bindgen-macro-support-0.2.89
wasm-bindgen-shared-0.2.89
webpki-0.22.4
web-sys-0.3.66
weezl-0.1.7
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.6
winapi-x86_64-pc-windows-gnu-0.4.0
windows_aarch64_gnullvm-0.48.5
windows_aarch64_gnullvm-0.52.0
windows_aarch64_msvc-0.48.5
windows_aarch64_msvc-0.52.0
windows-core-0.51.1
windows_i686_gnu-0.48.5
windows_i686_gnu-0.52.0
windows_i686_msvc-0.48.5
windows_i686_msvc-0.52.0
windows-sys-0.48.0
windows-sys-0.52.0
windows-targets-0.48.5
windows-targets-0.52.0
windows_x86_64_gnu-0.48.5
windows_x86_64_gnu-0.52.0
windows_x86_64_gnullvm-0.48.5
windows_x86_64_gnullvm-0.52.0
windows_x86_64_msvc-0.48.5
windows_x86_64_msvc-0.52.0
winnow-0.4.1
winreg-0.50.0
xmlparser-0.13.6
xml-rs-0.8.19
xmltree-0.10.3
yansi-0.5.1
zerocopy-0.6.6
zerocopy-derive-0.6.6
zeroize-1.7.0
"
declare -A GIT_CRATES=(
[cairo-rs]="https://github.com/gtk-rs/gtk-rs-core;63753d183f76f6603aaf239ffffbb98a089c4c1b;gtk-rs-core-%commit%/cairo" # 0.16.9
[cairo-sys-rs]="https://github.com/gtk-rs/gtk-rs-core;63753d183f76f6603aaf239ffffbb98a089c4c1b;gtk-rs-core-%commit%/cairo/sys" # 0.16.9
[ffv1]="https://github.com/rust-av/ffv1;2afb025a327173ce891954c052e804d0f880368a;ffv1-%commit%" # 0.0.0
[flavors]="https://github.com/rust-av/flavors;833508af656d298c269f2397c8541a084264d992;flavors-%commit%" # 0.2.0
[gdk4]="https://github.com/gtk-rs/gtk4-rs;79a1b60ab4c585dcb9a2529d76a0c874e52175da;gtk4-rs-%commit%/gdk4" # 0.5.6
[gdk4-sys]="https://github.com/gtk-rs/gtk4-rs;79a1b60ab4c585dcb9a2529d76a0c874e52175da;gtk4-rs-%commit%/gdk4/sys" # 0.5.6
[gdk4-wayland]="https://github.com/gtk-rs/gtk4-rs;79a1b60ab4c585dcb9a2529d76a0c874e52175da;gtk4-rs-%commit%/gdk4-wayland" # 0.5.6
[gdk4-wayland-sys]="https://github.com/gtk-rs/gtk4-rs;79a1b60ab4c585dcb9a2529d76a0c874e52175da;gtk4-rs-%commit%/gdk4-wayland/sys" # 0.5.6
[gdk4-x11]="https://github.com/gtk-rs/gtk4-rs;79a1b60ab4c585dcb9a2529d76a0c874e52175da;gtk4-rs-%commit%/gdk4-x11" # 0.5.6
[gdk4-x11-sys]="https://github.com/gtk-rs/gtk4-rs;79a1b60ab4c585dcb9a2529d76a0c874e52175da;gtk4-rs-%commit%/gdk4-x11/sys" # 0.5.6
[gdk-pixbuf]="https://github.com/gtk-rs/gtk-rs-core;63753d183f76f6603aaf239ffffbb98a089c4c1b;gtk-rs-core-%commit%/gdk-pixbuf" # 0.16.9
[gdk-pixbuf-sys]="https://github.com/gtk-rs/gtk-rs-core;63753d183f76f6603aaf239ffffbb98a089c4c1b;gtk-rs-core-%commit%/gdk-pixbuf/sys" # 0.16.9
[gio]="https://github.com/gtk-rs/gtk-rs-core;63753d183f76f6603aaf239ffffbb98a089c4c1b;gtk-rs-core-%commit%/gio" # 0.16.9
[gio-sys]="https://github.com/gtk-rs/gtk-rs-core;63753d183f76f6603aaf239ffffbb98a089c4c1b;gtk-rs-core-%commit%/gio/sys" # 0.16.9
[glib]="https://github.com/gtk-rs/gtk-rs-core;63753d183f76f6603aaf239ffffbb98a089c4c1b;gtk-rs-core-%commit%/glib" # 0.16.9
[glib-macros]="https://github.com/gtk-rs/gtk-rs-core;63753d183f76f6603aaf239ffffbb98a089c4c1b;gtk-rs-core-%commit%/glib-macros" # 0.16.9
[glib-sys]="https://github.com/gtk-rs/gtk-rs-core;63753d183f76f6603aaf239ffffbb98a089c4c1b;gtk-rs-core-%commit%/glib/sys" # 0.16.9
[gobject-sys]="https://github.com/gtk-rs/gtk-rs-core;63753d183f76f6603aaf239ffffbb98a089c4c1b;gtk-rs-core-%commit%/glib/gobject-sys" # 0.16.9
[graphene-rs]="https://github.com/gtk-rs/gtk-rs-core;63753d183f76f6603aaf239ffffbb98a089c4c1b;gtk-rs-core-%commit%/graphene" # 0.16.9
[graphene-sys]="https://github.com/gtk-rs/gtk-rs-core;63753d183f76f6603aaf239ffffbb98a089c4c1b;gtk-rs-core-%commit%/graphene/sys" # 0.16.9
[gsk4]="https://github.com/gtk-rs/gtk4-rs;79a1b60ab4c585dcb9a2529d76a0c874e52175da;gtk4-rs-%commit%/gsk4" # 0.5.6
[gsk4-sys]="https://github.com/gtk-rs/gtk4-rs;79a1b60ab4c585dcb9a2529d76a0c874e52175da;gtk4-rs-%commit%/gsk4/sys" # 0.5.6
[gstreamer-app]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-app" # 0.19.8
[gstreamer-app-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-app/sys" # 0.19.8
[gstreamer-audio]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-audio" # 0.19.8
[gstreamer-audio-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-audio/sys" # 0.19.8
[gstreamer-base]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-base" # 0.19.8
[gstreamer-base-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-base/sys" # 0.19.8
[gstreamer-check]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-check" # 0.19.8
[gstreamer-check-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-check/sys" # 0.19.8
[gstreamer-gl-egl]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-gl/egl" # 0.19.8
[gstreamer-gl-egl-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-gl/egl/sys" # 0.19.8
[gstreamer-gl]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-gl" # 0.19.8
[gstreamer-gl-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-gl/sys" # 0.19.8
[gstreamer-gl-wayland]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-gl/wayland" # 0.19.8
[gstreamer-gl-wayland-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-gl/wayland/sys" # 0.19.8
[gstreamer-gl-x11]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-gl/x11" # 0.19.8
[gstreamer-gl-x11-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-gl/x11/sys" # 0.19.8
[gstreamer]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer" # 0.19.8
[gstreamer-net]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-net" # 0.19.8
[gstreamer-net-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-net/sys" # 0.19.8
[gstreamer-pbutils]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-pbutils" # 0.19.8
[gstreamer-pbutils-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-pbutils/sys" # 0.19.8
[gstreamer-rtp]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-rtp" # 0.19.8
[gstreamer-rtp-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-rtp/sys" # 0.19.8
[gstreamer-sdp]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-sdp" # 0.19.8
[gstreamer-sdp-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-sdp/sys" # 0.19.8
[gstreamer-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer/sys" # 0.19.8
[gstreamer-utils]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-utils" # 0.19.8
[gstreamer-video]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-video" # 0.19.8
[gstreamer-video-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-video/sys" # 0.19.8
[gstreamer-webrtc]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-webrtc" # 0.19.8
[gstreamer-webrtc-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;b9307ca2582706519abf487175c3c0ddbf2e4654;gstreamer-rs-%commit%/gstreamer-webrtc/sys" # 0.19.8
[gtk4]="https://github.com/gtk-rs/gtk4-rs;79a1b60ab4c585dcb9a2529d76a0c874e52175da;gtk4-rs-%commit%/gtk4" # 0.5.6
[gtk4-macros]="https://github.com/gtk-rs/gtk4-rs;79a1b60ab4c585dcb9a2529d76a0c874e52175da;gtk4-rs-%commit%/gtk4-macros" # 0.5.6
[gtk4-sys]="https://github.com/gtk-rs/gtk4-rs;79a1b60ab4c585dcb9a2529d76a0c874e52175da;gtk4-rs-%commit%/gtk4/sys" # 0.5.6
[pangocairo]="https://github.com/gtk-rs/gtk-rs-core;63753d183f76f6603aaf239ffffbb98a089c4c1b;gtk-rs-core-%commit%/pangocairo" # 0.16.9
[pangocairo-sys]="https://github.com/gtk-rs/gtk-rs-core;63753d183f76f6603aaf239ffffbb98a089c4c1b;gtk-rs-core-%commit%/pangocairo/sys" # 0.16.9
[pango]="https://github.com/gtk-rs/gtk-rs-core;63753d183f76f6603aaf239ffffbb98a089c4c1b;gtk-rs-core-%commit%/pango" # 0.16.9
[pango-sys]="https://github.com/gtk-rs/gtk-rs-core;63753d183f76f6603aaf239ffffbb98a089c4c1b;gtk-rs-core-%commit%/pango/sys" # 0.16.9
)
		inherit cargo
		SRC_URI+="$(cargo_crate_uris)"
	fi
fi

inherit flag-o-matic lcnr llvm meson multilib-minimal python-any-r1

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
doc system-libsodium ebuild-revision-1
"
REQUIRED_USE+="
	^^ (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
	webrtchttp? (
		reqwest
	)
	|| (
		${MODULES[@]}
	)
"
# Depends is the same as stage: test and name: meson shared CI job
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

RDEPEND+="
	${CARGO_BINDINGS_DEPENDS_GLIB}
	${GST_PLUGINS_META}
	>=media-plugins/gst-plugins-meta-${GST_PV}:1.0[${MULTILIB_USEDEP}]
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
		<media-libs/dav1d-1.2.2[${MULTILIB_USEDEP}]
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
	webrtchttp? (
		>=media-plugins/gst-plugins-webrtc-${GST_PV}[${MULTILIB_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
# Update while keeping track of versions of virtual/rust.
# Expanded here because the virtual system is broken for multilib.
gen_llvm_bdepend() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				sys-devel/clang:${s}[${MULTILIB_USEDEP}]
				sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
			)
		"
	done
}
gen_virtual_rust_bdepend() {
	local virtual_rust_pv
	for virtual_rust_pv in ${!VIRTUAL_RUST_PV_TO_LLVM_SLOT[@]} ; do
		local llvm_slot="${VIRTUAL_RUST_PV_TO_LLVM_SLOT[${virtual_rust_pv}]}"
		echo "
			llvm_slot_${llvm_slot}? (
				=virtual/rust-${virtual_rust_pv}*[${MULTILIB_USEDEP}]
			)
		"
	done
}
BDEPEND+="
	$(gen_llvm_bdepend)
	>=dev-build/meson-0.60
	>=dev-util/cargo-c-0.9.3
	>=dev-util/pkgconf-1.8.1[${MULTILIB_USEDEP},pkg-config(+)]
	>=sys-devel/binutils-2.35.2
	>=sys-devel/gcc-10.2.1
	doc? (
		$(python_gen_any_dep '
			dev-python/hotdoc[${PYTHON_USEDEP}]
		')
	)
	|| (
		$(gen_virtual_rust_bdepend)
	)
	virtual/rust:=
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
}

multilib_src_configure() {
	local found=0
	local llvm_slot
	local virtual_rust_slot
	for virtual_rust_slot in ${!VIRTUAL_RUST_PV_TO_LLVM_SLOT[@]} ; do
		llvm_slot=${VIRTUAL_RUST_PV_TO_LLVM_SLOT[${virtual_rust_slot}]}
		[[ -z "${llvm_slot}" ]] && continue
		if \
			   has_version "=virtual/rust-${virtual_rust_slot}*" \
			&& has_version "sys-devel/clang:${llvm_slot}" \
			&& has_version "sys-devel/llvm:${llvm_slot}" \
		; then
			found=1
			break
		fi
	done
	if (( ${found} == 1 )) ; then
		LLVM_MAX_SLOT=${llvm_slot}
		llvm_pkg_setup
	else
		local virtual_rust_pv=$(best_version "virtual/rust" \
			| sed -e "s|virtual/rust-||g")
		local virtual_rust_pv_slot=${virtual_rust_pv%.*}
		local has_clang_slot="no"
		local has_llvm_slot="no"
		if has_version "sys-devel/clang:${VIRTUAL_RUST_PV_TO_LLVM_SLOT[${virtual_rust_pv_slot}]}" ; then
			has_clang_slot="yes"
		else
			has_clang_slot="no"
		fi
		if has_version "sys-devel/llvm:${VIRTUAL_RUST_PV_TO_LLVM_SLOT[${virtual_rust_pv_slot}]}" ; then
			has_llvm_slot="yes"
		else
			has_llvm_slot="no"
		fi
eerror
eerror "The LLVM/clang version is not supported or the dependencies are not"
eerror "completely installed.  Emerge clang and llvm to match subslot slot of"
eerror "virtual/rust."
eerror
eerror "Current virtual/rust version:  ${virtual_rust_pv}"
eerror "Has installed sys-devel/clang:${VIRTUAL_RUST_PV_TO_LLVM_SLOT[${virtual_rust_pv_slot}]} slot:  ${has_clang_slot}"
eerror "Has installed sys-devel/llvm:${VIRTUAL_RUST_PV_TO_LLVM_SLOT[${virtual_rust_pv_slot}]} slot:  ${has_llvm_slot}"
eerror
		die
	fi
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
