# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# The lockfile should be updated once a week for security reasons.

EAPI=8

MY_PV="${PV}"

if [[ "${MY_PV}" =~ 9999 ]] ; then
	EGIT_BRANCH="main"
	EGIT_COMMIT="HEAD"
	EGIT_COMMIT_FALLBACK="55b74c9a9af3539ea9cf8acdcd98deaf839898c3" # Feb 26, 2024
	EGIT_REPO_URI="https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs.git"
	MY_PV="9999"
	inherit git-r3
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${PN}-${MY_PV}"
else
	SRC_URI+="
https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/gstreamer-${MY_PV}/gst-plugins-rs-gstreamer-${MY_PV}.tar.bz2
	"
	S="${WORKDIR}/gst-plugins-rs-gstreamer-${MY_PV}"
	KEYWORDS="~amd64"
	if [[ "${GENERATE_LOCKFILE}" == "1" ]] ; then
		:;
	else
declare -A GIT_CRATES=(
[cairo-rs]="https://github.com/gtk-rs/gtk-rs-core;23c5599424cc75ec66618891c915d9f490f6e4c2;gtk-rs-core-%commit%/cairo" # 0.19.2
[cairo-sys-rs]="https://github.com/gtk-rs/gtk-rs-core;23c5599424cc75ec66618891c915d9f490f6e4c2;gtk-rs-core-%commit%/cairo/sys" # 0.19.2
[ffv1]="https://github.com/rust-av/ffv1;2afb025a327173ce891954c052e804d0f880368a;ffv1-%commit%" # 0.0.0
[flavors]="https://github.com/rust-av/flavors;833508af656d298c269f2397c8541a084264d992;flavors-%commit%" # 0.2.0
[gdk4]="https://github.com/gtk-rs/gtk4-rs;0e2a0297defc02b8b16e12299aafa8de2a9ec2bd;gtk4-rs-%commit%/gdk4" # 0.8.0
[gdk4-sys]="https://github.com/gtk-rs/gtk4-rs;0e2a0297defc02b8b16e12299aafa8de2a9ec2bd;gtk4-rs-%commit%/gdk4/sys" # 0.8.0
[gdk4-wayland]="https://github.com/gtk-rs/gtk4-rs;0e2a0297defc02b8b16e12299aafa8de2a9ec2bd;gtk4-rs-%commit%/gdk4-wayland" # 0.8.0
[gdk4-wayland-sys]="https://github.com/gtk-rs/gtk4-rs;0e2a0297defc02b8b16e12299aafa8de2a9ec2bd;gtk4-rs-%commit%/gdk4-wayland/sys" # 0.8.0
[gdk4-win32]="https://github.com/gtk-rs/gtk4-rs;0e2a0297defc02b8b16e12299aafa8de2a9ec2bd;gtk4-rs-%commit%/gdk4-win32" # 0.8.0
[gdk4-win32-sys]="https://github.com/gtk-rs/gtk4-rs;0e2a0297defc02b8b16e12299aafa8de2a9ec2bd;gtk4-rs-%commit%/gdk4-win32/sys" # 0.8.0
[gdk4-x11]="https://github.com/gtk-rs/gtk4-rs;0e2a0297defc02b8b16e12299aafa8de2a9ec2bd;gtk4-rs-%commit%/gdk4-x11" # 0.8.0
[gdk4-x11-sys]="https://github.com/gtk-rs/gtk4-rs;0e2a0297defc02b8b16e12299aafa8de2a9ec2bd;gtk4-rs-%commit%/gdk4-x11/sys" # 0.8.0
[gdk-pixbuf]="https://github.com/gtk-rs/gtk-rs-core;23c5599424cc75ec66618891c915d9f490f6e4c2;gtk-rs-core-%commit%/gdk-pixbuf" # 0.19.2
[gdk-pixbuf-sys]="https://github.com/gtk-rs/gtk-rs-core;23c5599424cc75ec66618891c915d9f490f6e4c2;gtk-rs-core-%commit%/gdk-pixbuf/sys" # 0.19.2
[gio]="https://github.com/gtk-rs/gtk-rs-core;23c5599424cc75ec66618891c915d9f490f6e4c2;gtk-rs-core-%commit%/gio" # 0.19.2
[gio-sys]="https://github.com/gtk-rs/gtk-rs-core;23c5599424cc75ec66618891c915d9f490f6e4c2;gtk-rs-core-%commit%/gio/sys" # 0.19.2
[glib]="https://github.com/gtk-rs/gtk-rs-core;23c5599424cc75ec66618891c915d9f490f6e4c2;gtk-rs-core-%commit%/glib" # 0.19.2
[glib-macros]="https://github.com/gtk-rs/gtk-rs-core;23c5599424cc75ec66618891c915d9f490f6e4c2;gtk-rs-core-%commit%/glib-macros" # 0.19.2
[glib-sys]="https://github.com/gtk-rs/gtk-rs-core;23c5599424cc75ec66618891c915d9f490f6e4c2;gtk-rs-core-%commit%/glib/sys" # 0.19.2
[gobject-sys]="https://github.com/gtk-rs/gtk-rs-core;23c5599424cc75ec66618891c915d9f490f6e4c2;gtk-rs-core-%commit%/glib/gobject-sys" # 0.19.2
[graphene-rs]="https://github.com/gtk-rs/gtk-rs-core;23c5599424cc75ec66618891c915d9f490f6e4c2;gtk-rs-core-%commit%/graphene" # 0.19.2
[graphene-sys]="https://github.com/gtk-rs/gtk-rs-core;23c5599424cc75ec66618891c915d9f490f6e4c2;gtk-rs-core-%commit%/graphene/sys" # 0.19.2
[gsk4]="https://github.com/gtk-rs/gtk4-rs;0e2a0297defc02b8b16e12299aafa8de2a9ec2bd;gtk4-rs-%commit%/gsk4" # 0.8.0
[gsk4-sys]="https://github.com/gtk-rs/gtk4-rs;0e2a0297defc02b8b16e12299aafa8de2a9ec2bd;gtk4-rs-%commit%/gsk4/sys" # 0.8.0
[gstreamer-app]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-app" # 0.22.2
[gstreamer-app-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-app/sys" # 0.22.2
[gstreamer-audio]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-audio" # 0.22.2
[gstreamer-audio-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-audio/sys" # 0.22.2
[gstreamer-base]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-base" # 0.22.2
[gstreamer-base-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-base/sys" # 0.22.2
[gstreamer-check]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-check" # 0.22.2
[gstreamer-check-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-check/sys" # 0.22.2
[gstreamer-gl-egl]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-gl/egl" # 0.22.2
[gstreamer-gl-egl-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-gl/egl/sys" # 0.22.2
[gstreamer-gl]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-gl" # 0.22.2
[gstreamer-gl-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-gl/sys" # 0.22.2
[gstreamer-gl-wayland]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-gl/wayland" # 0.22.2
[gstreamer-gl-wayland-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-gl/wayland/sys" # 0.22.2
[gstreamer-gl-x11]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-gl/x11" # 0.22.2
[gstreamer-gl-x11-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-gl/x11/sys" # 0.22.2
[gstreamer]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer" # 0.22.2
[gstreamer-net]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-net" # 0.22.2
[gstreamer-net-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-net/sys" # 0.22.2
[gstreamer-pbutils]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-pbutils" # 0.22.2
[gstreamer-pbutils-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-pbutils/sys" # 0.22.2
[gstreamer-rtp]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-rtp" # 0.22.2
[gstreamer-rtp-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-rtp/sys" # 0.22.2
[gstreamer-sdp]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-sdp" # 0.22.2
[gstreamer-sdp-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-sdp/sys" # 0.22.2
[gstreamer-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer/sys" # 0.22.2
[gstreamer-utils]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-utils" # 0.22.2
[gstreamer-video]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-video" # 0.22.2
[gstreamer-video-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-video/sys" # 0.22.2
[gstreamer-webrtc]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-webrtc" # 0.22.2
[gstreamer-webrtc-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;782c698846ad9712d430a8449bdf1fd2087f94f1;gstreamer-rs-%commit%/gstreamer-webrtc/sys" # 0.22.2
[gtk4]="https://github.com/gtk-rs/gtk4-rs;0e2a0297defc02b8b16e12299aafa8de2a9ec2bd;gtk4-rs-%commit%/gtk4" # 0.8.0
[gtk4-macros]="https://github.com/gtk-rs/gtk4-rs;0e2a0297defc02b8b16e12299aafa8de2a9ec2bd;gtk4-rs-%commit%/gtk4-macros" # 0.8.0
[gtk4-sys]="https://github.com/gtk-rs/gtk4-rs;0e2a0297defc02b8b16e12299aafa8de2a9ec2bd;gtk4-rs-%commit%/gtk4/sys" # 0.8.0
[pangocairo]="https://github.com/gtk-rs/gtk-rs-core;23c5599424cc75ec66618891c915d9f490f6e4c2;gtk-rs-core-%commit%/pangocairo" # 0.19.2
[pangocairo-sys]="https://github.com/gtk-rs/gtk-rs-core;23c5599424cc75ec66618891c915d9f490f6e4c2;gtk-rs-core-%commit%/pangocairo/sys" # 0.19.2
[pango]="https://github.com/gtk-rs/gtk-rs-core;23c5599424cc75ec66618891c915d9f490f6e4c2;gtk-rs-core-%commit%/pango" # 0.19.2
[pango-sys]="https://github.com/gtk-rs/gtk-rs-core;23c5599424cc75ec66618891c915d9f490f6e4c2;gtk-rs-core-%commit%/pango/sys" # 0.19.2
)

CRATES="
addr2line-0.21.0
adler-1.0.2
aes-0.6.0
aes-ctr-0.6.0
aesni-0.10.0
aes-soft-0.6.4
ahash-0.8.9
aho-corasick-1.1.2
allocator-api2-0.2.16
android_system_properties-0.1.5
android-tzdata-0.1.1
anstream-0.6.12
anstyle-1.0.6
anstyle-parse-0.2.3
anstyle-query-1.0.2
anstyle-wincon-3.0.2
anyhow-1.0.80
arbitrary-1.3.2
arg_enum_proc_macro-0.3.4
arrayvec-0.7.4
async-channel-2.2.0
async-compression-0.4.6
async-recursion-1.0.5
async-stream-0.3.5
async-stream-impl-0.3.5
async-task-4.7.0
async-trait-0.1.77
async-tungstenite-0.25.0
atomic_refcell-0.1.13
atty-0.2.14
autocfg-1.1.0
av1-grain-0.2.3
aws-config-1.1.6
aws-credential-types-1.1.6
aws-runtime-1.1.6
aws-sdk-kinesisvideo-1.15.0
aws-sdk-kinesisvideosignaling-1.14.0
aws-sdk-s3-1.16.0
aws-sdk-sso-1.14.0
aws-sdk-ssooidc-1.14.0
aws-sdk-sts-1.14.0
aws-sdk-transcribestreaming-1.14.0
aws-sdk-translate-1.14.0
aws-sigv4-1.1.6
aws-smithy-async-1.1.7
aws-smithy-checksums-0.60.6
aws-smithy-eventstream-0.60.4
aws-smithy-http-0.60.6
aws-smithy-json-0.60.6
aws-smithy-query-0.60.6
aws-smithy-runtime-1.1.7
aws-smithy-runtime-api-1.1.7
aws-smithy-types-1.1.7
aws-smithy-xml-0.60.6
aws-types-1.1.6
backtrace-0.3.69
base16ct-0.1.1
base32-0.4.0
base64-0.13.1
base64-0.21.7
base64ct-1.6.0
base64-serde-0.7.0
base64-simd-0.8.0
bincode-1.3.3
bitflags-1.3.2
bitflags-2.4.2
bitstream-io-2.2.0
block-buffer-0.10.4
block-buffer-0.9.0
bstr-1.9.1
build_const-0.2.2
built-0.7.1
bumpalo-3.15.3
bytemuck-1.14.3
byteorder-1.5.0
bytes-1.5.0
byte-slice-cast-1.2.2
bytes-utils-0.1.4
cc-1.0.88
cdg-0.1.0
cdg_renderer-0.7.1
cea708-types-0.3.0
cfg-expr-0.15.7
cfg-if-1.0.0
chrono-0.4.34
cipher-0.2.5
clap-4.4.18
clap_builder-4.4.18
clap_derive-4.4.7
clap_lex-0.6.0
claxon-0.4.3
colorchoice-1.0.0
color-name-1.1.0
color_quant-1.1.0
color-thief-0.2.2
concurrent-queue-2.4.0
const-oid-0.9.6
cookie-0.17.0
cookie-factory-0.3.2
cookie_store-0.20.0
core-foundation-0.9.4
core-foundation-sys-0.8.6
cpufeatures-0.2.12
crc-1.8.1
crc32c-0.6.5
crc32fast-1.4.0
crossbeam-channel-0.5.11
crossbeam-deque-0.8.5
crossbeam-epoch-0.9.18
crossbeam-utils-0.8.19
crypto-bigint-0.4.9
crypto-bigint-0.5.5
crypto-common-0.1.6
crypto-mac-0.11.0
csound-0.1.8
csound-sys-0.1.2
ctr-0.6.0
darling-0.20.8
darling_core-0.20.8
darling_macro-0.20.8
dashmap-5.5.3
dash-mpd-0.15.0
dasp_frame-0.11.0
dasp_sample-0.11.0
data-encoding-2.5.0
dav1d-0.9.6
dav1d-sys-0.7.3
der-0.6.1
deranged-0.3.11
diff-0.1.13
digest-0.10.7
digest-0.9.0
dssim-core-3.2.8
ebur128-0.1.8
ecdsa-0.14.8
ed25519-1.5.3
either-1.10.0
elliptic-curve-0.12.3
encoding_rs-0.8.33
env_logger-0.10.2
env_logger-0.9.3
equivalent-1.0.1
errno-0.3.8
event-listener-5.1.0
event-listener-strategy-0.5.0
fallible-iterator-0.3.0
fastrand-2.0.1
fdeflate-0.3.4
ff-0.12.1
field-offset-0.3.6
fixedbitset-0.4.2
flate2-1.0.28
flume-0.11.0
fnv-1.0.7
foreign-types-0.3.2
foreign-types-shared-0.1.1
form_urlencoded-1.2.1
fs-err-2.11.0
fst-0.4.7
futures-0.3.30
futures-channel-0.3.30
futures-core-0.3.30
futures-executor-0.3.30
futures-io-0.3.30
futures-macro-0.3.30
futures-sink-0.3.30
futures-task-0.3.30
futures-util-0.3.30
generic-array-0.14.7
getopts-0.2.21
getrandom-0.2.12
gif-0.13.1
gimli-0.28.1
glob-0.3.1
group-0.12.1
h2-0.3.24
hashbrown-0.12.3
hashbrown-0.14.3
headers-0.3.9
headers-core-0.2.0
heck-0.4.1
hermit-abi-0.1.19
hermit-abi-0.3.8
hex-0.4.3
hmac-0.11.0
hmac-0.12.1
home-0.5.9
hostname-0.3.1
hrtf-0.8.1
http-0.2.11
http-1.0.0
httparse-1.8.0
http-body-0.4.6
httpdate-1.0.3
human_bytes-0.4.3
humantime-2.1.0
hyper-0.14.28
hyper-proxy-0.9.1
hyper-rustls-0.24.2
hyper-tls-0.5.0
hyphenation-0.8.4
hyphenation_commons-0.8.4
iana-time-zone-0.1.60
iana-time-zone-haiku-0.1.2
ident_case-1.0.1
idna-0.3.0
idna-0.5.0
if-addrs-0.7.0
image-0.24.9
image_hasher-1.2.0
imgref-1.10.1
indexmap-1.9.3
indexmap-2.2.3
interpolate_name-0.2.4
ipnet-2.9.0
iso8601-0.6.1
is-terminal-0.4.12
itertools-0.11.0
itertools-0.12.1
itoa-1.0.10
jsonwebtoken-9.2.0
js-sys-0.3.68
khronos-egl-6.0.0
lazy_static-1.4.0
lewton-0.10.2
libc-0.2.153
libfuzzer-sys-0.4.7
libloading-0.8.1
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
linux-raw-sys-0.4.13
livekit-api-0.3.0
livekit-protocol-0.3.0
lock_api-0.4.11
log-0.4.20
lru-0.12.3
m3u8-rs-5.0.5
match_cfg-0.1.0
matchers-0.1.0
maybe-rayon-0.1.1
md-5-0.10.6
memchr-2.7.1
memoffset-0.6.5
memoffset-0.9.0
mime-0.3.17
mime_guess-2.0.4
minimal-lexical-0.2.1
miniz_oxide-0.7.2
mio-0.8.10
more-asserts-0.3.1
muldiv-1.0.1
multer-2.1.0
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
num-complex-0.4.5
num-conv-0.1.0
num_cpus-1.16.0
num-derive-0.4.2
num-integer-0.1.46
num-rational-0.4.1
num-traits-0.2.18
object-0.32.2
ogg-0.8.0
once_cell-1.19.0
opaque-debug-0.3.0
openssl-0.10.64
openssl-macros-0.1.1
openssl-probe-0.1.5
openssl-sys-0.9.101
option-operations-0.5.0
outref-0.5.1
overload-0.1.1
p256-0.11.1
parking-2.2.0
parking_lot-0.12.1
parking_lot_core-0.9.9
parse_link_header-0.3.3
paste-1.0.14
pbjson-0.6.0
pbjson-build-0.6.2
pbjson-types-0.6.0
pbkdf2-0.8.0
percent-encoding-2.3.1
petgraph-0.6.4
pin-project-1.1.4
pin-project-internal-1.1.4
pin-project-lite-0.2.13
pin-utils-0.1.0
pkcs8-0.9.0
pkg-config-0.3.30
png-0.17.13
pocket-resources-0.3.2
polling-3.5.0
powerfmt-0.2.0
ppv-lite86-0.2.17
pretty_assertions-1.4.0
prettyplease-0.2.16
primal-check-0.3.3
priority-queue-1.4.0
proc-macro2-1.0.78
proc-macro-crate-3.1.0
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
profiling-1.0.15
profiling-procmacros-1.0.15
prost-0.12.3
prost-build-0.12.3
prost-derive-0.12.3
prost-types-0.12.3
protobuf-2.28.0
protobuf-codegen-2.28.0
protobuf-codegen-pure-2.28.0
psl-types-2.0.11
publicsuffix-2.2.3
quick-xml-0.31.0
quote-1.0.35
rand-0.8.5
rand_chacha-0.3.1
rand_core-0.6.4
rand_distr-0.4.3
raptorq-1.8.0
rav1e-0.7.1
rayon-1.8.1
rayon-core-1.12.1
realfft-3.3.0
redox_syscall-0.4.1
regex-1.10.3
regex-automata-0.1.10
regex-automata-0.4.5
regex-lite-0.1.5
regex-syntax-0.6.29
regex-syntax-0.8.2
reqwest-0.11.24
rfc6979-0.3.1
rgb-0.8.37
ring-0.17.8
rpassword-6.0.1
rtsp-types-0.1.1
rubato-0.14.1
rustc-demangle-0.1.23
rustc_version-0.4.0
rustdct-0.7.1
rustfft-6.2.0
rustix-0.38.31
rustls-0.21.10
rustls-native-certs-0.6.3
rustls-pemfile-1.0.4
rustls-webpki-0.101.7
ryu-1.0.17
same-file-1.0.6
schannel-0.1.23
scoped-tls-1.0.1
scopeguard-1.2.0
sct-0.7.1
sdp-types-0.1.6
sec1-0.3.0
security-framework-2.9.2
security-framework-sys-2.9.1
semver-1.0.22
serde-1.0.197
serde_bytes-0.11.14
serde_derive-1.0.197
serde_json-1.0.114
serde_path_to_error-0.1.15
serde_spanned-0.6.5
serde_urlencoded-0.7.1
serde_with-3.6.1
serde_with_macros-3.6.1
serial_test-3.0.0
serial_test_derive-3.0.0
sha1-0.10.6
sha-1-0.9.8
sha2-0.10.8
shannon-0.2.0
sharded-slab-0.1.7
shell-words-1.1.0
signal-hook-0.3.17
signal-hook-registry-1.4.1
signature-1.6.4
simd-adler32-0.3.7
simd_helpers-0.1.0
slab-0.4.9
smallvec-1.13.1
smawk-0.3.2
socket2-0.4.10
socket2-0.5.6
sodiumoxide-0.2.7
spin-0.9.8
spki-0.6.0
sprintf-0.1.4
strength_reduce-0.2.4
strsim-0.10.0
subtle-2.5.0
syn-1.0.109
syn-2.0.51
sync_wrapper-0.1.2
system-configuration-0.5.1
system-configuration-sys-0.5.0
system-deps-6.2.0
target-lexicon-0.12.14
tempfile-3.10.0
termcolor-1.4.1
test-log-0.2.14
test-log-macros-0.2.14
test-with-0.12.5
textwrap-0.16.1
thiserror-1.0.57
thiserror-impl-1.0.57
thread-id-4.2.1
thread_local-1.1.8
time-0.3.34
time-core-0.1.2
time-macros-0.2.17
tinyvec-1.6.0
tinyvec_macros-0.1.1
tokio-1.36.0
tokio-macros-2.2.0
tokio-native-tls-0.3.1
tokio-rustls-0.24.1
tokio-stream-0.1.14
tokio-tungstenite-0.20.1
tokio-util-0.7.10
toml-0.8.10
toml_datetime-0.6.5
toml_edit-0.21.1
toml_edit-0.22.6
tower-service-0.3.2
tracing-0.1.40
tracing-attributes-0.1.27
tracing-core-0.1.32
tracing-log-0.2.0
tracing-subscriber-0.3.18
transpose-0.2.3
try-lock-0.2.5
tungstenite-0.20.1
tungstenite-0.21.0
typenum-1.17.0
unicase-2.7.0
unicode-bidi-0.3.15
unicode-ident-1.0.12
unicode-linebreak-0.1.5
unicode-normalization-0.1.23
unicode-width-0.1.11
untrusted-0.9.0
url-2.5.0
urlencoding-2.1.3
url-escape-0.1.1
utf-8-0.7.6
utf8parse-0.2.1
uuid-1.7.0
va_list-0.1.4
valuable-0.1.0
vcpkg-0.2.15
vergen-3.2.0
version_check-0.9.4
version-compare-0.1.1
v_frame-0.3.7
vsimd-0.8.0
waker-fn-1.1.1
walkdir-2.4.0
want-0.3.1
warp-0.3.6
wasi-0.11.0+wasi-snapshot-preview1
wasm-bindgen-0.2.91
wasm-bindgen-backend-0.2.91
wasm-bindgen-futures-0.4.41
wasm-bindgen-macro-0.2.91
wasm-bindgen-macro-support-0.2.91
wasm-bindgen-shared-0.2.91
web-sys-0.3.68
weezl-0.1.8
which-4.4.2
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.6
winapi-x86_64-pc-windows-gnu-0.4.0
windows_aarch64_gnullvm-0.48.5
windows_aarch64_gnullvm-0.52.3
windows_aarch64_msvc-0.48.5
windows_aarch64_msvc-0.52.3
windows-core-0.52.0
windows_i686_gnu-0.48.5
windows_i686_gnu-0.52.3
windows_i686_msvc-0.48.5
windows_i686_msvc-0.52.3
windows-sys-0.48.0
windows-sys-0.52.0
windows-targets-0.48.5
windows-targets-0.52.3
windows_x86_64_gnu-0.48.5
windows_x86_64_gnu-0.52.3
windows_x86_64_gnullvm-0.48.5
windows_x86_64_gnullvm-0.52.3
windows_x86_64_msvc-0.48.5
windows_x86_64_msvc-0.52.3
winnow-0.5.40
winnow-0.6.2
winreg-0.50.0
xattr-1.3.1
xmlparser-0.13.6
xml-rs-0.8.19
xmltree-0.10.3
yansi-0.5.1
zerocopy-0.6.6
zerocopy-0.7.32
zerocopy-derive-0.6.6
zerocopy-derive-0.7.32
zeroize-1.7.0
"

		inherit cargo
		SRC_URI+="$(cargo_crate_uris)"
	fi
fi

LLVM_COMPAT=( 17 ) # For clang-sys ; slot based on virtual/rust subslot
LLVM_MAX_SLOT="${LLVM_COMPAT[0]}"
PYTHON_COMPAT=( python3_{8..11} )

inherit flag-o-matic lcnr llvm meson multilib-minimal

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

SLOT="1.0/${MY_PV}" # 1.0 is same as media-libs/gstreamer
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
IUSE+="
${MODULES[@]}
${LLVM_COMPAT[@]/#/llvm_slot_}
doc system-libsodium r1
"
REQUIRED_USE+="
	|| (
		${MODULES[@]}
	)
	webrtchttp? (
		reqwest
	)
"
# Assumes D 12
# Depends same as stage: test and name: meson shared CI job
GOBJECT_INTROSPECTION_PV="1.74.0"
GST_PV="1.22.3" # Based on gstreamer1.0-plugins-good ; downgraded for distro.  Upstream uses ~1.23.90
RUST_PV="1.76.0" # Required by bindings
CARGO_PV="1.76.0"
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
	>=media-libs/graphene-1.10[introspection]
	>=gui-libs/gtk-4.8.3:4[introspection,gstreamer]
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
		>=media-libs/dav1d-1.1.0:=[${MULTILIB_USEDEP}]
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
DEPEND+=" ${RDEPEND}"
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
BDEPEND+="
	$(gen_llvm_bdepend)
	>=dev-util/cargo-c-0.9.22
	>=dev-build/meson-1.1.1
	>=dev-util/pkgconf-1.8.1[${MULTILIB_USEDEP},pkg-config(+)]
	>=sys-devel/binutils-2.40
	>=sys-devel/gcc-12.2.0
	>=virtual/rust-${RUST_PV}[${MULTILIB_USEDEP}]
	doc? (
		dev-python/hotdoc
	)
"
RESTRICT="mirror"
PATCHES=(
)
# FIXME:
EXPECTED_BUILD_FILES_FINGERPRINT="\
de3226d4e1a5184c51040e9eb13848756b4daed0978cf8786bc351c7a04e5f83\
ecbbc78d55f3ef65324330035ceb38eec9143accd158d63007a5760c3afc6c99\
"

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

	# The file name version does not match the --version.
	local x_cargo_pv=$(cargo --version | cut -f 2 -d " ")
	if ver_test ${x_cargo_pv} -lt ${CARGO_PV} ; then
eerror
eerror "Cargo version requirements are not met."
eerror
eerror "Current cargo version:\t${x_cargo_pv}"
eerror "Expected cargo version:\t${CARGO_PV}"
eerror
		die
	else
einfo "cargo version: ${x_cargo_pv}"
	fi
}

multilib_src_configure() {
	local found=0
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		if \
			   has_version "sys-devel/clang:${s}" \
			&& has_version "sys-devel/llvm:${s}" \
		; then
			found=1
			break
		fi
	done
	if (( ${found} == 1 )) ; then
		LLVM_MAX_SLOT=${s}
		llvm_pkg_setup
	else
eerror
eerror "The LLVM/clang version is not supported.  Send a issue request to"
eerror "update the ebuild maintainer."
eerror
		die
	fi
einfo "LLVM=${LLVM_MAX_SLOT}"

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
		if [[ "${EXPECTED_BUILD_FILES_FINGERPRINT}" != "${actual_build_files_fingerprint}" ]] ; then
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
		cp -a "${FILESDIR}/${PV}/Cargo.lock" "${S}" || die
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
