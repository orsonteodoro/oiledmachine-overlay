# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# The lockfile should be updated once a week for security reasons.

EAPI=8

MY_PV="0.11.0+fixup"

if [[ "${MY_PV}" =~ 9999 ]] ; then
	EGIT_BRANCH="main"
	EGIT_COMMIT="HEAD"
	EGIT_COMMIT_FALLBACK="16d58caf2e0d99ea499ff5e9164e3a118835b400" # Aug 10, 2023
	EGIT_REPO_URI="https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs.git"
	MY_PV="9999"
	inherit git-r3
	IUSE+=" fallback-commit"
	# Live ebuilds do not get KEYWORDS [soft blocked]
else
	SRC_URI+="
https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/${MY_PV}/gst-plugins-rs-${MY_PV}.tar.bz2
	"
	KEYWORDS="~amd64"
	if [[ "${GENERATE_LOCKFILE}" == "1" ]] ; then
		:;
	else
declare -A GIT_CRATES=(
[cairo-rs]="https://github.com/gtk-rs/gtk-rs-core;854c9b0592fb3a3865caa3e8538a5dda98399c0c;gtk-rs-core-%commit%/cairo" # 0.18.1
[cairo-sys-rs]="https://github.com/gtk-rs/gtk-rs-core;854c9b0592fb3a3865caa3e8538a5dda98399c0c;gtk-rs-core-%commit%/cairo/sys" # 0.18.1
[ffv1]="https://github.com/rust-av/ffv1;2afb025a327173ce891954c052e804d0f880368a;ffv1-%commit%" # 0.0.0
[flavors]="https://github.com/rust-av/flavors;833508af656d298c269f2397c8541a084264d992;flavors-%commit%" # 0.2.0
[gdk4]="https://github.com/gtk-rs/gtk4-rs;9cf490a3afcad0a61233d4f65cfc2f5d2d369e9f;gtk4-rs-%commit%/gdk4" # 0.7.1
[gdk4-sys]="https://github.com/gtk-rs/gtk4-rs;9cf490a3afcad0a61233d4f65cfc2f5d2d369e9f;gtk4-rs-%commit%/gdk4/sys" # 0.7.1
[gdk4-wayland]="https://github.com/gtk-rs/gtk4-rs;9cf490a3afcad0a61233d4f65cfc2f5d2d369e9f;gtk4-rs-%commit%/gdk4-wayland" # 0.7.1
[gdk4-wayland-sys]="https://github.com/gtk-rs/gtk4-rs;9cf490a3afcad0a61233d4f65cfc2f5d2d369e9f;gtk4-rs-%commit%/gdk4-wayland/sys" # 0.7.1
[gdk4-win32]="https://github.com/gtk-rs/gtk4-rs;9cf490a3afcad0a61233d4f65cfc2f5d2d369e9f;" # 0.7.1
[gdk4-win32-sys]="https://github.com/gtk-rs/gtk4-rs;9cf490a3afcad0a61233d4f65cfc2f5d2d369e9f;" # 0.7.1
[gdk4-x11]="https://github.com/gtk-rs/gtk4-rs;9cf490a3afcad0a61233d4f65cfc2f5d2d369e9f;gtk4-rs-%commit%/gdk4-x11" # 0.7.1
[gdk4-x11-sys]="https://github.com/gtk-rs/gtk4-rs;9cf490a3afcad0a61233d4f65cfc2f5d2d369e9f;gtk4-rs-%commit%/gdk4-x11/sys" # 0.7.1
[gdk-pixbuf]="https://github.com/gtk-rs/gtk-rs-core;854c9b0592fb3a3865caa3e8538a5dda98399c0c;gtk-rs-core-%commit%/gdk-pixbuf" # 0.18.1
[gdk-pixbuf-sys]="https://github.com/gtk-rs/gtk-rs-core;854c9b0592fb3a3865caa3e8538a5dda98399c0c;gtk-rs-core-%commit%/gdk-pixbuf/sys" # 0.18.1
[gio]="https://github.com/gtk-rs/gtk-rs-core;854c9b0592fb3a3865caa3e8538a5dda98399c0c;gtk-rs-core-%commit%/gio" # 0.18.1
[gio-sys]="https://github.com/gtk-rs/gtk-rs-core;854c9b0592fb3a3865caa3e8538a5dda98399c0c;gtk-rs-core-%commit%/gio/sys" # 0.18.1
[glib]="https://github.com/gtk-rs/gtk-rs-core;854c9b0592fb3a3865caa3e8538a5dda98399c0c;gtk-rs-core-%commit%/glib" # 0.18.1
[glib-macros]="https://github.com/gtk-rs/gtk-rs-core;854c9b0592fb3a3865caa3e8538a5dda98399c0c;gtk-rs-core-%commit%/glib-macros" # 0.18.1
[glib-sys]="https://github.com/gtk-rs/gtk-rs-core;854c9b0592fb3a3865caa3e8538a5dda98399c0c;gtk-rs-core-%commit%/glib/sys" # 0.18.1
[gobject-sys]="https://github.com/gtk-rs/gtk-rs-core;854c9b0592fb3a3865caa3e8538a5dda98399c0c;gtk-rs-core-%commit%/glib/gobject-sys" # 0.18.1
[graphene-rs]="https://github.com/gtk-rs/gtk-rs-core;854c9b0592fb3a3865caa3e8538a5dda98399c0c;gtk-rs-core-%commit%/graphene" # 0.18.1
[graphene-sys]="https://github.com/gtk-rs/gtk-rs-core;854c9b0592fb3a3865caa3e8538a5dda98399c0c;gtk-rs-core-%commit%/graphene/sys" # 0.18.1
[gsk4]="https://github.com/gtk-rs/gtk4-rs;9cf490a3afcad0a61233d4f65cfc2f5d2d369e9f;gtk4-rs-%commit%/gsk4" # 0.7.1
[gsk4-sys]="https://github.com/gtk-rs/gtk4-rs;9cf490a3afcad0a61233d4f65cfc2f5d2d369e9f;gtk4-rs-%commit%/gsk4/sys" # 0.7.1
[gstreamer-app]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-app" # 0.21.0
[gstreamer-app-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-app/sys" # 0.21.0
[gstreamer-audio]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-audio" # 0.21.0
[gstreamer-audio-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-audio/sys" # 0.21.0
[gstreamer-base]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-base" # 0.21.0
[gstreamer-base-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-base/sys" # 0.21.0
[gstreamer-check]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-check" # 0.21.0
[gstreamer-check-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-check/sys" # 0.21.0
[gstreamer-gl-egl]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-gl/egl" # 0.21.0
[gstreamer-gl-egl-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-gl/egl/sys" # 0.21.0
[gstreamer-gl]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-gl" # 0.21.0
[gstreamer-gl-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-gl/sys" # 0.21.0
[gstreamer-gl-wayland]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-gl/wayland" # 0.21.0
[gstreamer-gl-wayland-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-gl/wayland/sys" # 0.21.0
[gstreamer-gl-x11]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-gl/x11" # 0.21.0
[gstreamer-gl-x11-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-gl/x11/sys" # 0.21.0
[gstreamer]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer" # 0.21.0
[gstreamer-net]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-net" # 0.21.0
[gstreamer-net-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-net/sys" # 0.21.0
[gstreamer-pbutils]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-pbutils" # 0.21.0
[gstreamer-pbutils-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-pbutils/sys" # 0.21.0
[gstreamer-rtp]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-rtp" # 0.21.0
[gstreamer-rtp-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-rtp/sys" # 0.21.0
[gstreamer-sdp]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-sdp" # 0.21.0
[gstreamer-sdp-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-sdp/sys" # 0.21.0
[gstreamer-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer/sys" # 0.21.0
[gstreamer-utils]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-utils" # 0.21.0
[gstreamer-video]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-video" # 0.21.0
[gstreamer-video-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-video/sys" # 0.21.0
[gstreamer-webrtc]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-webrtc" # 0.21.0
[gstreamer-webrtc-sys]="https://gitlab.freedesktop.org/gstreamer/gstreamer-rs;5022d85b8385814669aa797249dce94193eeccc0;gstreamer-rs-%commit%/gstreamer-webrtc/sys" # 0.21.0
[gtk4]="https://github.com/gtk-rs/gtk4-rs;9cf490a3afcad0a61233d4f65cfc2f5d2d369e9f;gtk4-rs-%commit%/gtk4" # 0.7.1
[gtk4-macros]="https://github.com/gtk-rs/gtk4-rs;9cf490a3afcad0a61233d4f65cfc2f5d2d369e9f;gtk4-rs-%commit%/gtk4-macros" # 0.7.1
[gtk4-sys]="https://github.com/gtk-rs/gtk4-rs;9cf490a3afcad0a61233d4f65cfc2f5d2d369e9f;gtk4-rs-%commit%/gtk4/sys" # 0.7.1
[pangocairo]="https://github.com/gtk-rs/gtk-rs-core;854c9b0592fb3a3865caa3e8538a5dda98399c0c;gtk-rs-core-%commit%/pangocairo" # 0.18.1
[pangocairo-sys]="https://github.com/gtk-rs/gtk-rs-core;854c9b0592fb3a3865caa3e8538a5dda98399c0c;gtk-rs-core-%commit%/pangocairo/sys" # 0.18.1
[pango]="https://github.com/gtk-rs/gtk-rs-core;854c9b0592fb3a3865caa3e8538a5dda98399c0c;gtk-rs-core-%commit%/pango" # 0.18.1
[pango-sys]="https://github.com/gtk-rs/gtk-rs-core;854c9b0592fb3a3865caa3e8538a5dda98399c0c;gtk-rs-core-%commit%/pango/sys" # 0.18.1
)

CRATES="
addr2line-0.20.0
adler-1.0.2
aes-0.6.0
aes-ctr-0.6.0
aesni-0.10.0
aes-soft-0.6.4
aho-corasick-1.0.3
android_system_properties-0.1.5
android-tzdata-0.1.1
anstream-0.3.2
anstyle-1.0.1
anstyle-parse-0.2.1
anstyle-query-1.0.0
anstyle-wincon-1.0.2
anyhow-1.0.72
arbitrary-0.4.7
arg_enum_proc_macro-0.3.2
arrayvec-0.7.4
async-compression-0.4.1
async-recursion-1.0.4
async-stream-0.3.5
async-stream-impl-0.3.5
async-task-4.4.0
async-trait-0.1.72
async-tungstenite-0.23.0
atomic_refcell-0.1.10
atty-0.2.14
autocfg-1.1.0
av1-grain-0.2.2
aws-config-0.56.0
aws-credential-types-0.56.0
aws-http-0.56.0
aws-runtime-0.56.0
aws-sdk-kinesisvideo-0.29.0
aws-sdk-kinesisvideosignaling-0.29.0
aws-sdk-s3-0.29.0
aws-sdk-sso-0.29.0
aws-sdk-sts-0.29.0
aws-sdk-transcribestreaming-0.29.0
aws-sdk-translate-0.29.0
aws-sig-auth-0.56.0
aws-sigv4-0.56.0
aws-smithy-async-0.56.0
aws-smithy-checksums-0.56.0
aws-smithy-client-0.56.0
aws-smithy-eventstream-0.56.0
aws-smithy-http-0.56.0
aws-smithy-http-tower-0.56.0
aws-smithy-json-0.56.0
aws-smithy-query-0.56.0
aws-smithy-runtime-0.56.0
aws-smithy-runtime-api-0.56.0
aws-smithy-types-0.56.0
aws-smithy-xml-0.56.0
aws-types-0.56.0
backtrace-0.3.68
base32-0.4.0
base64-0.13.1
base64-0.21.2
base64-serde-0.7.0
base64-simd-0.8.0
bincode-1.3.3
bitflags-1.3.2
bitflags-2.3.3
bitstream-io-1.7.0
block-buffer-0.10.4
block-buffer-0.9.0
build_const-0.2.2
built-0.5.2
bumpalo-3.13.0
bytemuck-1.13.1
byteorder-1.4.3
bytes-1.4.0
byte-slice-cast-1.2.2
bytes-utils-0.1.3
cargo-lock-8.0.3
cc-1.0.82
cdg-0.1.0
cdg_renderer-0.7.1
cea708-types-0.1.0
cfg-expr-0.15.4
cfg-if-1.0.0
chrono-0.4.26
cipher-0.2.5
clap-4.3.21
clap_builder-4.3.21
clap_derive-4.3.12
clap_lex-0.5.0
claxon-0.4.3
colorchoice-1.0.0
color-name-1.1.0
color_quant-1.1.0
color-thief-0.2.2
concurrent-queue-2.2.0
cookie-0.16.2
cookie_store-0.16.2
core-foundation-0.9.3
core-foundation-sys-0.8.4
cpufeatures-0.2.9
crc-1.8.1
crc32c-0.6.4
crc32fast-1.3.2
crossbeam-channel-0.5.8
crossbeam-deque-0.8.3
crossbeam-epoch-0.9.15
crossbeam-utils-0.8.16
crypto-common-0.1.6
crypto-mac-0.11.1
csound-0.1.8
csound-sys-0.1.2
ctr-0.6.0
darling-0.20.3
darling_core-0.20.3
darling_macro-0.20.3
dash-mpd-0.13.0
dasp_frame-0.11.0
dasp_sample-0.11.0
data-encoding-2.4.0
dav1d-0.9.4
dav1d-sys-0.7.1
deranged-0.3.7
diff-0.1.13
digest-0.10.7
digest-0.9.0
dssim-core-3.2.7
ebur128-0.1.8
ed25519-1.5.3
either-1.9.0
encoding_rs-0.8.32
env_logger-0.10.0
env_logger-0.9.3
equivalent-1.0.1
errno-0.3.2
errno-dragonfly-0.1.2
fastrand-2.0.0
fdeflate-0.3.0
field-offset-0.3.6
fixedbitset-0.4.2
flate2-1.0.26
flume-0.10.14
fnv-1.0.7
foreign-types-0.3.2
foreign-types-shared-0.1.1
form_urlencoded-1.2.0
fs-err-2.9.0
fst-0.4.7
futures-0.3.28
futures-channel-0.3.28
futures-core-0.3.28
futures-executor-0.3.28
futures-io-0.3.28
futures-macro-0.3.28
futures-sink-0.3.28
futures-task-0.3.28
futures-util-0.3.28
generic-array-0.14.7
getopts-0.2.21
getrandom-0.2.10
gif-0.12.0
gimli-0.27.3
glob-0.3.1
h2-0.3.20
hashbrown-0.12.3
hashbrown-0.14.0
headers-0.3.8
headers-core-0.2.0
heck-0.4.1
hermit-abi-0.1.19
hermit-abi-0.3.2
hex-0.4.3
hmac-0.11.0
hmac-0.12.1
hostname-0.3.1
hrtf-0.8.0
http-0.2.9
httparse-1.8.0
http-body-0.4.5
httpdate-1.0.2
human_bytes-0.4.2
humantime-2.1.0
hyper-0.14.27
hyper-proxy-0.9.1
hyper-rustls-0.24.1
hyper-tls-0.5.0
hyphenation-0.8.4
hyphenation_commons-0.8.4
iana-time-zone-0.1.57
iana-time-zone-haiku-0.1.2
ident_case-1.0.1
idna-0.2.3
idna-0.3.0
idna-0.4.0
if-addrs-0.7.0
image-0.24.7
image_hasher-1.2.0
imgref-1.9.4
indexmap-1.9.3
indexmap-2.0.0
interpolate_name-0.2.3
ipnet-2.8.0
iso8601-0.6.1
is-terminal-0.4.9
itertools-0.10.5
itertools-0.11.0
itoa-1.0.9
jobserver-0.1.26
jsonwebtoken-8.3.0
js-sys-0.3.64
khronos-egl-5.0.0
lazy_static-1.4.0
lewton-0.10.2
libc-0.2.147
libfuzzer-sys-0.3.5
libloading-0.8.0
libm-0.2.7
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
libwebp-sys2-0.1.7
linux-raw-sys-0.4.5
livekit-api-0.1.3
livekit-protocol-0.1.3
lock_api-0.4.10
log-0.4.19
m3u8-rs-5.0.4
match_cfg-0.1.0
matchers-0.1.0
matches-0.1.10
maybe-rayon-0.1.1
md-5-0.10.5
memchr-2.5.0
memoffset-0.6.5
memoffset-0.9.0
mime-0.3.17
minimal-lexical-0.2.1
miniz_oxide-0.7.1
mio-0.8.8
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
num-bigint-0.4.3
num-complex-0.4.3
num_cpus-1.16.0
num-derive-0.3.3
num-derive-0.4.0
num-integer-0.1.45
num-rational-0.4.1
num-traits-0.2.16
object-0.31.1
ogg-0.8.0
once_cell-1.18.0
opaque-debug-0.3.0
openssl-0.10.56
openssl-macros-0.1.1
openssl-probe-0.1.5
openssl-sys-0.9.91
option-operations-0.5.0
outref-0.5.1
overload-0.1.1
parking_lot-0.12.1
parking_lot_core-0.9.8
parse_link_header-0.3.3
paste-1.0.14
pbkdf2-0.8.0
percent-encoding-2.3.0
petgraph-0.6.3
pin-project-1.1.3
pin-project-internal-1.1.3
pin-project-lite-0.2.12
pin-utils-0.1.0
pkg-config-0.3.27
png-0.17.9
pocket-resources-0.3.2
polling-2.8.0
ppv-lite86-0.2.17
pretty_assertions-1.4.0
pretty-hex-0.3.0
primal-check-0.3.3
priority-queue-1.3.2
proc-macro2-1.0.66
proc-macro-crate-1.3.1
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
prost-0.11.9
prost-derive-0.11.9
prost-types-0.11.9
protobuf-2.28.0
protobuf-codegen-2.28.0
protobuf-codegen-pure-2.28.0
psl-types-2.0.11
publicsuffix-2.2.3
quick-xml-0.30.0
quote-1.0.32
rand-0.8.5
rand_chacha-0.3.1
rand_core-0.6.4
rand_distr-0.4.3
raptorq-1.7.0
rav1e-0.6.6
rayon-1.7.0
rayon-core-1.11.0
realfft-2.0.1
redox_syscall-0.2.16
redox_syscall-0.3.5
regex-1.9.3
regex-automata-0.1.10
regex-automata-0.3.6
regex-syntax-0.6.29
regex-syntax-0.7.4
reqwest-0.11.18
rgb-0.8.36
ring-0.16.20
rpassword-6.0.1
rubato-0.10.1
rustc-demangle-0.1.23
rustc_version-0.4.0
rustdct-0.7.1
rustfft-6.1.0
rust_hawktracer-0.7.0
rust_hawktracer_normal_macro-0.4.1
rust_hawktracer_proc_macro-0.4.1
rustix-0.38.7
rustls-0.21.6
rustls-native-certs-0.6.3
rustls-pemfile-1.0.3
rustls-webpki-0.101.3
ryu-1.0.15
same-file-1.0.6
schannel-0.1.22
scopeguard-1.2.0
sct-0.7.0
security-framework-2.9.2
security-framework-sys-2.9.1
semver-1.0.18
serde-1.0.183
serde_bytes-0.11.12
serde_derive-1.0.183
serde_json-1.0.104
serde_spanned-0.6.3
serde_urlencoded-0.7.1
serde_with-3.2.0
serde_with_macros-3.2.0
sha1-0.10.5
sha-1-0.9.8
sha2-0.10.7
shannon-0.2.0
sharded-slab-0.1.4
shell-words-1.1.0
signal-hook-0.3.17
signal-hook-registry-1.4.1
signature-1.6.4
simd-adler32-0.3.7
simd_helpers-0.1.0
slab-0.4.8
smallvec-1.11.0
smawk-0.3.1
socket2-0.4.9
socket2-0.5.3
sodiumoxide-0.2.7
spin-0.5.2
spin-0.9.8
strength_reduce-0.2.4
strsim-0.10.0
subtle-2.4.1
syn-1.0.109
syn-2.0.28
system-deps-6.1.1
target-lexicon-0.12.11
tempfile-3.7.1
termcolor-1.2.0
test-log-0.2.12
test-with-0.10.0
textwrap-0.16.0
thiserror-1.0.44
thiserror-impl-1.0.44
thread-id-4.1.0
thread_local-1.1.7
time-0.1.45
time-0.3.25
time-core-0.1.1
time-macros-0.2.11
tinyvec-1.6.0
tinyvec_macros-0.1.1
tokio-1.30.0
tokio-macros-2.1.0
tokio-native-tls-0.3.1
tokio-rustls-0.24.1
tokio-stream-0.1.14
tokio-tungstenite-0.19.0
tokio-util-0.7.8
toml-0.5.11
toml-0.7.6
toml_datetime-0.6.3
toml_edit-0.19.14
tower-0.4.13
tower-layer-0.3.2
tower-service-0.3.2
tracing-0.1.37
tracing-attributes-0.1.26
tracing-core-0.1.31
tracing-log-0.1.3
tracing-subscriber-0.3.17
transpose-0.2.2
try-lock-0.2.4
tungstenite-0.19.0
tungstenite-0.20.0
typenum-1.16.0
unicode-bidi-0.3.13
unicode-ident-1.0.11
unicode-linebreak-0.1.5
unicode-normalization-0.1.22
unicode-width-0.1.10
untrusted-0.7.1
url-2.4.0
urlencoding-2.1.3
url-escape-0.1.1
utf-8-0.7.6
utf8parse-0.2.1
uuid-1.4.1
va_list-0.1.4
valuable-0.1.0
vcpkg-0.2.15
vergen-3.2.0
version_check-0.9.4
version-compare-0.1.1
v_frame-0.3.6
vsimd-0.8.0
waker-fn-1.1.0
walkdir-2.3.3
want-0.3.1
wasi-0.10.0+wasi-snapshot-preview1
wasi-0.11.0+wasi-snapshot-preview1
wasm-bindgen-0.2.87
wasm-bindgen-backend-0.2.87
wasm-bindgen-futures-0.4.37
wasm-bindgen-macro-0.2.87
wasm-bindgen-macro-support-0.2.87
wasm-bindgen-shared-0.2.87
web-sys-0.3.64
weezl-0.1.7
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.48.0
windows_aarch64_gnullvm-0.48.0
windows_aarch64_msvc-0.48.0
windows_i686_gnu-0.48.0
windows_i686_msvc-0.48.0
windows-sys-0.48.0
windows-targets-0.48.1
windows_x86_64_gnu-0.48.0
windows_x86_64_gnullvm-0.48.0
windows_x86_64_msvc-0.48.0
winnow-0.5.4
winreg-0.10.1
xattr-1.0.1
xmlparser-0.13.5
xml-rs-0.8.16
xmltree-0.10.3
yansi-0.5.1
zerocopy-0.6.3
zerocopy-derive-0.6.3
zeroize-1.6.0
"

		inherit cargo
		SRC_URI+="$(cargo_crate_uris)"
	fi
fi

LLVM_SLOTS=( 14 ) # For clang-sys
LLVM_MAX_SLOT=14

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
${MODULES[@]} doc system-libsodium r1
"
REQUIRED_USE+="
	|| (
		${MODULES[@]}
	)
	webrtchttp? (
		reqwest
	)
"
# Depends same as stage: test and name: meson shared CI job
RUST_PV="1.70.0" # Relaxed.  Upstream uses 1.70.0.  1.70.0 is hard masked [blocked] on distro.
CARGO_PV="1.70.0"
# grep -e "requires_private" "${WORKDIR}" for external dependencies
# See "Run-time dependency" in CI
# Assumes D12
CAIRO_PV="1.16.0" # Same as cairo-gobject in CI
GST_PV="1.20.0" # Relaxed.  Upstream CI uses 1.23.0.1
PANGO_PV="1.50.12"
# openssl requirement relaxed CI uses 3.0.8
#	>=dev-libs/libgit2-1.5
RDEPEND+="
	>=dev-libs/glib-2.74.6:2[${MULTILIB_USEDEP}]
	>=media-plugins/gst-plugins-meta-${GST_PV}:1.0[${MULTILIB_USEDEP}]
	aws? (
		>=dev-libs/openssl-1.1[${MULTILIB_USEDEP}]
	)
	closedcaption? (
		>=x11-libs/cairo-${CAIRO_PV}[${MULTILIB_USEDEP}]
		>=x11-libs/pango-${PANGO_PV}[${MULTILIB_USEDEP}]
	)
	csound? (
		>=media-sound/csound-6.18.1[${MULTILIB_USEDEP}]
	)
	dav1d? (
		>=media-libs/dav1d-1.1.0:=[${MULTILIB_USEDEP}]
	)
	gtk4? (
		>=gui-libs/gtk-4.10.3:4[gstreamer]
	)
	onvif? (
		>=x11-libs/pango-${PANGO_PV}[${MULTILIB_USEDEP}]
	)
	system-libsodium? (
		>=dev-libs/libsodium-1.0.18[${MULTILIB_USEDEP}]
	)
	videofx? (
		>=x11-libs/cairo-${CAIRO_PV}[${MULTILIB_USEDEP}]
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
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
			(
				sys-devel/clang:${s}[${MULTILIB_USEDEP}]
				sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
			)
		"
	done
}
BDEPEND+="
	|| (
		$(gen_llvm_bdepend)
	)
	>=dev-util/cargo-c-0.9.15
	>=dev-util/meson-1.1.1
	>=dev-util/pkgconf-1.8.1[${MULTILIB_USEDEP},pkg-config(+)]
	>=sys-devel/gcc-12.2.0
	>=virtual/rust-${RUST_PV}[${MULTILIB_USEDEP}]
	doc? (
		dev-python/hotdoc
	)
"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${MY_PV}"
PATCHES=(
)
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

	if [[ "${MY_PV}" =~ 9999 ]] ; then
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
	for s in ${LLVM_SLOTS[@]} ; do
		if has_version "sys-devel/clang:${s}" \
			&& has_version "sys-devel/llvm:${s}" ; then
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
	if [[ ${MY_PV} =~ 9999 ]] ; then
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
		unpack "gst-plugins-rs-${MY_PV}.tar.bz2"
		cp -a "${FILESDIR}/${PV}/Cargo.lock" "${S}" || die
		cargo_src_unpack
	fi
}

_lockfile_gen_unpack() {
	unpack "gst-plugins-rs-${MY_PV}.tar.bz2"
	cd "${S}" || die
einfo "Generating lockfile"
	rm Cargo.lock
	cargo generate-lockfile || die "Failed to update Cargo.lock"
	die
}

src_unpack() {
	if [[ "${GENERATE_LOCKFILE}" =~ "1" ]] ; then
		_lockfile_gen_unpack
	else
		_production_unpack
	fi
}

src_prepare() {
	default
	sed -i -e "s|csound64|csound|g" \
		"meson.build" \
		|| die
}

multilib_src_compile() {
# DO NOT REMOVE
	meson_src_compile
}

multilib_src_install() {
	meson_src_install

	if [[ "${MY_PV}" =~ 9999 ]] ; then
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
