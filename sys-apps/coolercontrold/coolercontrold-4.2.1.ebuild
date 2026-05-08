# Copyright 2022-2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D12, U22

# This contains info obtained by AI inference.
# This ebuild contains AI generated assets/artifacts.

#
# I verified that it is possible to run as a limited user.
#
# Security score
#
# | Property               | Before       | After               |
# | ---                    | ---          | ---                 |
# | Privilege level        | Root (10/10) | Limited user + caps |
# | Attack surface         | Very high    | Medium low          |
# | Compromised impact     | Catastropic  | Moderate            |
# | Filesystem access      | Full         | Restricted          |
# | Raw hardware access    | Unlimited    | Only needed caps    |
# | Overall security score | 3.5 / 10     | 7.8 / 10            |
#

NODE_SLOT="22"
NPM_TARBALL="coolercontrol-${PV}.tar.bz2"
PYTHON_COMPAT=( "python3_"{10,11} )
RUST_MAX_VER="1.91.1"
RUST_MIN_VER="1.91.1" # LLVM 21.1
RUST_PV="${RUST_MAX_VER}"

# Tonic doesn't need native C/C++ gRPC dep.
ABSEIL_CPP_SLOT="20220623"
PROTOBUF_CPP_SLOT="3"

# Only provide the necessary capabilities
# cap_dac_override - For changing /sys/class/hwmon/ file permissions for fan control
# cap_sys_rawio - For SuperIO detection through /dev/port
FILECAPS=(
#	"cap_sys_rawio,cap_dac_override=ep" "usr/bin/coolercontrold"
	"cap_sys_rawio=ep" "usr/bin/coolercontrold"
)

# NPM_AUDIT_FIX=0
NPM_INSTALL_ARGS=(
	"--prefer-offline"
)

VIDEO_CARDS=(
	"video_cards_amdgpu"
	"video_cards_nvidia"
)

# To update npm side use:
# PATH=$(realpath "../../scripts")":${PATH}"
# NPM_UPDATER_PROJECT_ROOT="coolercontrol-4.2.1/coolercontrol-ui" NPM_UPDATER_VERSIONS="4.2.1" npm_updater_update_locks.sh

# To update cargo size use:
# ./convert-cargo-lock.sh 4.2.1 4.2.1

# Remove the -2-0 suffix
declare -A GIT_CRATES=(
)

DISABLED_CRATES="
cc-detect-0.2.0
cc-image-0.1.0
cc-stress-0.1.1
"

CRATES="
adler2-2.0.1
aead-0.5.2
aes-0.8.4
aes-gcm-0.10.3
ahash-0.7.8
ahash-0.8.12
aho-corasick-1.1.4
aide-0.15.1
aligned-vec-0.6.4
alloc-no-stdlib-2.0.4
alloc-stdlib-0.2.2
android_system_properties-0.1.5
anstream-1.0.0
anstyle-1.0.14
anstyle-parse-1.0.0
anstyle-query-1.1.5
anstyle-wincon-3.0.11
anyhow-1.0.102
arbitrary-1.4.2
arc-swap-1.9.1
arg_enum_proc_macro-0.3.4
argon2-0.5.3
arrayref-0.3.9
arrayvec-0.7.6
ash-0.38.0+1.3.281
asn1-rs-0.7.1
asn1-rs-derive-0.6.0
asn1-rs-impl-0.2.0
async-broadcast-0.7.2
async-compression-0.4.42
async-recursion-1.1.1
async-trait-0.1.89
atomic-waker-1.1.2
autocfg-1.5.0
av1-grain-0.2.5
avif-serialize-0.8.8
axum-0.8.9
axum-core-0.5.6
axum-macros-0.5.1
axum-server-0.8.0
axum_typed_multipart-0.16.4
axum_typed_multipart_macros-0.16.4
base64-0.22.1
base64ct-1.8.3
bitflags-1.3.2
bitflags-2.11.1
bit-set-0.8.0
bitstream-io-2.6.0
bit-vec-0.8.0
bitvec-1.0.1
blake2-0.10.6
block-0.1.6
block-buffer-0.10.4
block-buffer-0.12.0
borsh-1.6.1
borsh-derive-1.6.1
brotli-8.0.2
brotli-decompressor-5.0.0
built-0.7.7
bumpalo-3.20.2
bytecheck-0.6.12
bytecheck_derive-0.6.12
bytemuck-1.25.0
bytemuck_derive-1.10.2
byteorder-lite-0.1.0
bytes-1.11.1
cc-1.2.61
cfg_aliases-0.2.1
cfg-expr-0.15.8
cfg-if-1.0.4
chrono-0.4.44
cipher-0.4.4
clap-4.6.1
clap_builder-4.6.0
clap_derive-4.6.1
clap_lex-1.1.0
codespan-reporting-0.11.1
colorchoice-1.0.5
color_quant-1.1.0
compression-codecs-0.4.38
compression-core-0.4.32
concurrent-queue-2.5.0
const-oid-0.10.2
convert_case-0.10.0
cookie-0.18.1
core-foundation-0.9.4
core-foundation-sys-0.8.7
core-graphics-types-0.1.3
cpufeatures-0.2.17
cpufeatures-0.3.0
crc32fast-1.5.0
crossbeam-channel-0.5.15
crossbeam-deque-0.8.6
crossbeam-epoch-0.9.18
crossbeam-utils-0.8.21
crunchy-0.2.4
crypto-common-0.1.7
crypto-common-0.2.1
ctr-0.9.2
darling-0.20.11
darling_core-0.20.11
darling_macro-0.20.11
data-encoding-2.11.0
deranged-0.5.8
derive_more-2.1.1
derive_more-impl-2.1.1
der-parser-10.0.0
digest-0.10.7
digest-0.11.3
displaydoc-0.2.5
document-features-0.2.12
dyn-clone-1.0.20
either-1.15.0
encoding_rs-0.8.35
endi-1.1.1
enumflags2-0.7.12
enumflags2_derive-0.7.12
env_filter-1.0.1
env_logger-0.11.10
equator-0.4.2
equator-macro-0.4.2
equivalent-1.0.2
errno-0.3.14
event-listener-5.4.1
event-listener-strategy-0.5.4
fastrand-2.4.1
fax-0.2.7
fdeflate-0.3.7
find-msvc-tools-0.1.9
fixedbitset-0.5.7
flate2-1.1.9
fnv-1.0.7
foldhash-0.1.5
fontdue-0.7.3
foreign-types-0.5.0
foreign-types-macros-0.2.3
foreign-types-shared-0.3.1
form_urlencoded-1.2.2
fs-err-3.3.0
funty-2.0.0
futures-0.3.32
futures-channel-0.3.32
futures-core-0.3.32
futures-executor-0.3.32
futures-io-0.3.32
futures-lite-2.6.1
futures-macro-0.3.32
futures-sink-0.3.32
futures-task-0.3.32
futures-util-0.3.32
generic-array-0.14.7
getrandom-0.2.17
getrandom-0.3.4
getrandom-0.4.2
ghash-0.5.1
gif-0.13.3
gif-dispose-5.0.1
gifski-1.34.0
gl_generator-0.14.0
glow-0.16.0
glutin_wgl_sys-0.6.1
gpu-alloc-0.6.0
gpu-alloc-types-0.3.0
gpu-descriptor-0.3.2
gpu-descriptor-types-0.2.0
h2-0.4.14
half-2.7.1
hashbrown-0.12.3
hashbrown-0.13.2
hashbrown-0.15.5
hashbrown-0.17.0
heck-0.5.0
hex-0.4.3
hexf-parse-0.2.1
hkdf-0.12.4
hmac-0.12.1
http-1.4.0
httparse-1.10.1
http-body-1.0.1
http-body-util-0.1.3
httpdate-1.0.3
http-range-header-0.4.2
hybrid-array-0.4.11
hyper-1.9.0
hyper-timeout-0.5.2
hyper-util-0.1.20
iana-time-zone-0.1.65
iana-time-zone-haiku-0.1.2
id-arena-2.3.0
ident_case-1.0.1
image-0.25.8
imagequant-4.4.1
image-webp-0.2.4
imgref-1.12.1
include_dir-0.7.4
include_dir_macros-0.7.4
indexmap-2.14.0
inout-0.1.4
interpolate_name-0.2.4
io-uring-0.6.4
is_terminal_polyfill-1.70.2
itertools-0.12.1
itertools-0.14.0
itoa-1.0.18
jiff-0.2.24
jiff-static-0.2.24
jni-sys-0.3.1
jni-sys-0.4.1
jni-sys-macros-0.4.1
jobserver-0.1.34
js-sys-0.3.98
khronos_api-3.1.0
khronos-egl-6.0.0
lazy_static-1.5.0
leb128fmt-0.1.0
libc-0.2.186
libdrm_amdgpu_sys-0.8.13
libfuzzer-sys-0.4.12
libloading-0.8.9
linux-raw-sys-0.12.1
litrs-1.0.0
lock_api-0.4.14
log-0.4.29
loop9-0.1.5
malloc_buf-0.0.6
matchit-0.8.4
maybe-rayon-0.1.1
memchr-2.8.0
memoffset-0.9.1
metal-0.31.0
mime-0.3.17
mime_guess-2.0.5
minimal-lexical-0.2.1
miniz_oxide-0.8.9
mio-1.2.0
moro-local-0.4.0
moxcms-0.7.11
multer-3.1.0
multimap-0.10.1
naga-24.0.0
ndk-sys-0.5.0+25.2.9519653
new_debug_unreachable-1.0.6
nix-0.31.2
nom-7.1.3
nom-8.0.0
noop_proc_macro-0.3.0
ntapi-0.4.3
nu-glob-0.107.0
num-bigint-0.4.6
num-conv-0.1.0
num-derive-0.4.2
num-integer-0.1.46
num-rational-0.4.2
num-traits-0.2.19
nvml-wrapper-0.12.1
nvml-wrapper-sys-0.9.1
objc-0.2.7
objc2-core-foundation-0.3.2
objc2-io-kit-0.3.2
oid-registry-0.8.1
once_cell-1.21.4
once_cell_polyfill-1.70.2
opaque-debug-0.3.1
ordered-channel-1.2.0
ordered-float-4.6.0
ordered-stream-0.2.0
parking-2.2.1
parking_lot-0.12.5
parking_lot_core-0.9.12
password-hash-0.5.0
paste-1.0.15
pem-3.0.6
percent-encoding-2.3.2
petgraph-0.8.3
pin-project-1.1.12
pin-project-internal-1.1.12
pin-project-lite-0.2.17
pkg-config-0.3.33
png-0.17.16
png-0.18.1
polyval-0.6.2
portable-atomic-1.13.1
portable-atomic-util-0.2.7
powerfmt-0.2.0
ppv-lite86-0.2.21
prettyplease-0.2.37
proc-macro2-1.0.106
proc-macro-crate-3.5.0
proc-macro-error2-2.0.1
proc-macro-error-attr2-2.0.0
profiling-1.0.18
profiling-procmacros-1.0.18
prost-0.14.3
prost-build-0.14.3
prost-derive-0.14.3
prost-types-0.14.3
ptr_meta-0.1.4
ptr_meta_derive-0.1.4
pulldown-cmark-0.13.3
pulldown-cmark-to-cmark-22.0.0
pxfm-0.1.29
quick-error-2.0.1
quote-1.0.45
radium-0.7.0
rand-0.8.6
rand-0.9.4
rand_chacha-0.3.1
rand_chacha-0.9.0
rand_core-0.6.4
rand_core-0.9.5
rav1e-0.7.1
ravif-0.11.20
raw-window-handle-0.6.2
rayon-1.12.0
rayon-core-1.13.0
rcgen-0.14.7
redox_syscall-0.5.18
ref-cast-1.0.25
ref-cast-impl-1.0.25
r-efi-5.3.0
r-efi-6.0.0
regex-1.12.3
regex-automata-0.4.14
regex-syntax-0.8.10
rend-0.4.2
renderdoc-sys-1.1.0
resize-0.8.9
rgb-0.8.53
ril-0.10.3
ring-0.17.14
rkyv-0.7.46
rkyv_derive-0.7.46
rustc-hash-1.1.0
rustc_version-0.4.1
rust_decimal-1.42.0
rusticata-macros-4.1.0
rustix-1.1.4
rustls-0.23.40
rustls-pki-types-1.14.1
rustls-webpki-0.103.13
rustversion-1.0.22
ryu-1.0.23
scc-2.4.0
schemars-0.9.0
schemars_derive-0.9.0
scopeguard-1.2.0
sdd-3.0.10
seahash-4.1.0
semver-1.0.28
serde-1.0.228
serde_core-1.0.228
serde_derive-1.0.228
serde_derive_internals-0.29.1
serde_json-1.0.149
serde_path_to_error-0.1.20
serde_qs-0.14.0
serde_repr-0.1.20
serde_spanned-0.6.9
serde_urlencoded-0.7.1
serial_test-3.4.0
serial_test_derive-3.4.0
sha2-0.10.9
sha2-0.11.0
shlex-1.3.0
signal-hook-registry-1.4.8
simd-adler32-0.3.9
simd_helpers-0.1.0
simdutf8-0.1.5
slab-0.4.12
slotmap-1.1.1
smallvec-1.15.1
socket2-0.4.10
socket2-0.6.3
spin-0.9.8
spirv-0.3.0+sdk-1.3.268.0
static_assertions-1.1.0
strict-num-0.1.1
strsim-0.11.1
strum-0.26.3
strum-0.28.0
strum_macros-0.26.4
strum_macros-0.28.0
subtle-2.6.1
syn-1.0.109
syn-2.0.117
sync_wrapper-1.0.2
synstructure-0.13.2
sysinfo-0.36.1
system-deps-6.2.2
systemd-journal-logger-2.2.2
tap-1.0.1
target-lexicon-0.12.16
tempfile-3.27.0
termcolor-1.4.1
thiserror-1.0.69
thiserror-2.0.18
thiserror-impl-1.0.69
thiserror-impl-2.0.18
thread_local-1.1.9
tiff-0.10.3
time-0.3.45
time-core-0.1.7
time-macros-0.2.25
tiny-skia-0.12.0
tiny-skia-path-0.12.0
tinyvec-1.11.0
tinyvec_macros-0.1.1
tokio-1.52.2
tokio-macros-2.7.0
tokio-rustls-0.26.4
tokio-stream-0.1.18
tokio-uring-0.5.0
tokio-util-0.7.18
toml-0.8.23
toml_datetime-0.6.11
toml_datetime-0.7.5+spec-1.1.0
toml_datetime-1.1.1+spec-1.1.0
toml_edit-0.22.27
toml_edit-0.23.10+spec-1.0.0
toml_edit-0.25.11+spec-1.1.0
toml_parser-1.1.2+spec-1.1.0
toml_write-0.1.2
toml_writer-1.1.1+spec-1.1.0
tonic-0.14.5
tonic-build-0.14.5
tonic-health-0.14.5
tonic-prost-0.14.5
tonic-prost-build-0.14.5
tonic-reflection-0.14.5
tower-0.5.3
tower-cookies-0.11.0
tower-http-0.6.10
tower-layer-0.3.3
tower-serve-static-0.1.1
tower-service-0.3.3
tower-sessions-0.15.0
tower-sessions-core-0.15.0
tower-sessions-memory-store-0.15.0
tracing-0.1.44
tracing-attributes-0.1.31
tracing-core-0.1.36
try-lock-0.2.5
ttf-parser-0.15.2
typenum-1.20.0
ubyte-0.10.4
uds_windows-1.2.1
unicase-2.9.0
unicode-ident-1.0.24
unicode-segmentation-1.13.2
unicode-width-0.1.14
unicode-xid-0.2.6
universal-hash-0.5.1
untrusted-0.9.0
utf8parse-0.2.2
uuid-1.23.1
version_check-0.9.5
version-compare-0.2.1
v_frame-0.3.9
want-0.3.1
wasi-0.11.1+wasi-snapshot-preview1
wasip2-1.0.1+wasi-0.2.4
wasip3-0.4.0+wasi-0.3.0-rc-2026-01-06
wasm-bindgen-0.2.121
wasm-bindgen-futures-0.4.71
wasm-bindgen-macro-0.2.121
wasm-bindgen-macro-support-0.2.121
wasm-bindgen-shared-0.2.121
wasm-encoder-0.244.0
wasm-metadata-0.244.0
wasmparser-0.244.0
web-sys-0.3.98
weezl-0.1.12
wgpu-24.0.5
wgpu-core-24.0.5
wgpu-hal-24.0.4
wgpu-types-24.0.0
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.11
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.58.0
windows-0.61.3
windows_aarch64_gnullvm-0.52.6
windows_aarch64_msvc-0.52.6
windows-collections-0.2.0
windows-core-0.58.0
windows-core-0.61.2
windows-core-0.62.2
windows-future-0.2.1
windows_i686_gnu-0.52.6
windows_i686_gnullvm-0.52.6
windows_i686_msvc-0.52.6
windows-implement-0.58.0
windows-implement-0.60.2
windows-interface-0.58.0
windows-interface-0.59.3
windows-link-0.1.3
windows-link-0.2.1
windows-numerics-0.2.0
windows-result-0.2.0
windows-result-0.3.4
windows-result-0.4.1
windows-strings-0.1.0
windows-strings-0.4.2
windows-strings-0.5.1
windows-sys-0.52.0
windows-sys-0.61.2
windows-targets-0.52.6
windows-threading-0.1.0
windows_x86_64_gnu-0.52.6
windows_x86_64_gnullvm-0.52.6
windows_x86_64_msvc-0.52.6
winnow-0.7.15
winnow-1.0.2
wit-bindgen-0.46.0
wit-bindgen-0.51.0
wit-bindgen-core-0.51.0
wit-bindgen-rust-0.51.0
wit-bindgen-rust-macro-0.51.0
wit-component-0.244.0
wit-parser-0.244.0
wrapcenum-derive-0.4.1
wyz-0.5.1
x509-parser-0.18.1
xml-rs-0.8.28
yasna-0.5.2
zbus-5.13.0
zbus_macros-5.13.2
zbus_names-4.3.1
zerocopy-0.8.48
zerocopy-derive-0.8.48
zeroize-1.8.2
zmij-1.0.21
zstd-0.13.3
zstd-safe-7.2.4
zstd-sys-2.0.16+zstd.1.5.7
zune-core-0.4.12
zune-jpeg-0.4.21
zvariant-5.9.2
zvariant_derive-5.9.2
zvariant_utils-3.3.0
"

inherit abseil-cpp cargo fcaps lcnr npm protobuf python-single-r1 rust

KEYWORDS="~amd64"
S_ROOT="${WORKDIR}/coolercontrol-${PV}"
S="${S_ROOT}/coolercontrold"
SRC_URI="
$(cargo_crate_uris ${CRATES})
https://gitlab.com/coolercontrol/coolercontrol/-/archive/${PV}/coolercontrol-${PV}.tar.bz2
"

DESCRIPTION="The CoolerControl system service that handles controlling hardware"
HOMEPAGE="
https://gitlab.com/coolercontrol/coolercontrol
https://gitlab.com/coolercontrol/coolercontrol/-/tree/main/coolercontrold
"
CARGO_PACKAGES_LICENSES="
	(
		Apache-2.0
		BSD
		CC-BY-3.0
		MIT
	)
	(
		ISC
		MIT
		openssl
		SSLeay
	)
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	Boost-1.0
	BSD-2
	GPL-3+
	HPND-Pbmplus
	ISC
	MIT
	MPL-2.0
	Unicode-DFS-2016
	Unlicense
	ZLIB
	|| (
		Apache-2.0
		MIT
	)
	|| (
		Apache-2.0
		Apache-2.0-with-LLVM-exceptions
		MIT
	)
"
NPM_PACKAGES_LICENSES="
	(
		CC-BY-4.0
		MIT
		Unicode-DFS-2016
		W3C-Community-Final-Specification-Agreement
		W3C-Software-and-Document-Notice-and-License
	)
	(
		Apache-2.0
		MIT
	)
	(
		Apache-2.0
		all-rights-reserved
	)
	0BSD
	CC0-1.0
	custom
"
# ( Apache-2.0, all-rights-reserved ) coolercontrol-ui/node_modules/reflect-metadata/CopyrightNotice.txt ; The distro's Apache-2.0 license template does not have all rights reserved
# ( MIT all-rights-reserved ) coolercontrol-ui/node_modules/sass/LICENSE
# 0BSD - coolercontrol-ui/node_modules/tslib/CopyrightNotice.txt
# CC0-1.0 - coolercontrol-ui/node_modules/csso/node_modules/mdn-data/LICENSE
# custom - coolercontrol-ui/node_modules/jackspeak/LICENSE.md
#   keywords:  "This license gives everyone as much permission to work with"
# Apache-2.0, MIT - coolercontrol-ui/node_modules/@mdi/js/LICENSE
# CC-BY-4.0, MIT, Unicode-DFS-2016, W3C-Community-Final-Specification-Agreement - coolercontrol-ui/node_modules/typescript/ThirdPartyNoticeText.txt
# CC-BY-3.0 - cargo_home/gentoo/crossbeam-channel-0.5.8/LICENSE-THIRD-PARTY
# HPND-Pbmplus - cargo_home/gentoo/imagequant-4.2.2/COPYRIGHT
# MPL-2.0 - cargo_home/gentoo/webpki-roots-0.25.3/LICENSE
# openssl, SSLeay - cargo_home/gentoo/ring-0.17.5/LICENSE
# Unicode-DFS-2016 - gentoo/regex-syntax-0.8.2/src/unicode_tables/LICENSE-UNICODE
# Unlicense - cargo_home/gentoo/memchr-2.6.4/UNLICENSE
LICENSE="
	${CARGO_PACKAGES_LICENSES}
	${NPM_PACKAGES_LICENSES}
	GPL-3+
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
${VIDEO_CARDS[@]}
hwmon liquidctl man openrc systemd
ebuild_revision_15
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	filecaps
"
# The sys-libs/libcap is an ebuild or init security requirement not upstream requirement.
# virtual/udev is an ebuild requirement but not upstream.
RDEPEND+="
	acct-group/coolercontrold
	acct-user/coolercontrold
	dev-cpp/abseil-cpp:20220623
	dev-libs/protobuf:3/3.21
	sys-libs/libcap
	virtual/udev
	liquidctl? (
		app-misc/liquidctl
	)
	hwmon? (
		>=sys-apps/lm-sensors-3.6.0
	)
	video_cards_amdgpu? (
		x11-libs/libdrm
	)
	video_cards_nvidia? (
		x11-drivers/nvidia-drivers[tools]
	)
"
DEPEND+="
	${RDEPEND}
	x11-libs/libdrm
"
# app-admin/sudo is an ebuild requirement but not upstream.
BDEPEND+="
	${VUE_BDEPEND}
	>=dev-build/make-4.3
	app-admin/sudo
	net-libs/nodejs:${NODE_SLOT}[npm]
	net-libs/nodejs:=
	virtual/pkgconfig
	|| (
		dev-lang/rust:${RUST_PV}[wasm]
		dev-lang/rust-bin:${RUST_PV}
	)
	|| (
		dev-lang/rust:=
		dev-lang/rust-bin:=
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-4.2.1-symbolize-python.patch"
	"${FILESDIR}/${PN}-4.2.1-remove-root-check.patch"
)

# @FUNCTION: cargo_src_unpack
# @DESCRIPTION:
# Unpacks the package and the cargo registry.
# From cargo.eclass
_cargo_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	mkdir -p "${ECARGO_VENDOR}" || die
	mkdir -p "${S}" || die

	cp -aT \
		"${FILESDIR}/${PV}/" \
		"${S}" \
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
				einfo "pwd:  "$(pwd)
				if [[ "${archive}" == "coolercontrol-${PV}.tar.bz2" ]] ; then
					einfo "Skipping unpack for coolercontrol-${PV}.tar.bz2"
				else
					pushd "${WORKDIR}" || die
						unpack "${archive}"
					popd || die
				fi
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

set_gui_port() {
	local L=(
		"coolercontrold/daemon/src/api/mod.rs"
	)
	local port=${COOLERCONTROL_GUI_PORT:-11987}
	local p
	for p in "${L[@]}" ; do
		sed -i -e "s|11987|${port}|g" "${p}" || die
	done
}

set_grpc_port() {
	local L=(
		"coolercontrold/daemon/src/api/mod.rs"
	)
	local port=${COOLERCONTROL_GRPC_PORT:-11988}
	local p
	for p in "${L[@]}" ; do
		sed -i -e "s|11988|${port}|g" "${p}" || die
	done
}

pkg_setup() {
ewarn "Do not emerge ${CATEGORY}/${PN} package directly.  Emerge the sys-apps/coolercontrol metapackage instead."
	python-single-r1_pkg_setup
	npm_pkg_setup
	rust_pkg_setup
	"${RUSTC}" --version || die
}

npm_update_lock_install_post() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		pushd "${S_ROOT}/coolercontrol-ui" >/dev/null 2>&1 || die
			sed -i -e "s|\"vitest\": \"^2.1.8\"|\"vitest\": \"^2.1.9\"|" "package.json" || die
			enpm install "vitest@2.1.9" -D ${NPM_INSTALL_ARGS[@]}						# CVE-2025-24964; DoS, DT, ID; Critical

			sed -i -e "s|\"esbuild\": \"^0.21.3\"|\"esbuild\": \"^0.25.0\"|g" "package-lock.json" || die	# Must follow vitest
			sed -i -e "s|\"esbuild\": \"^0.24.2\"|\"esbuild\": \"^0.25.0\"|g" "package-lock.json" || die	# Must follow vitest
			enpm install "esbuild@^0.25.0" -D

			enpm install "axios@^1.8.2" -P									# CVE-2025-27152; ID; High
		popd >/dev/null 2>&1 || die
	fi
}

src_unpack() {
	# For updating lockfile
	unpack "coolercontrol-${PV}.tar.bz2"
#	die

	S="${S_ROOT}/coolercontrol-ui" \
	npm_src_unpack
	S="${S_ROOT}/coolercontrold" \
	_cargo_src_unpack
}

src_configure() {
	abseil-cpp_src_configure
	protobuf_src_configure
	export PROTOC="/usr/lib/protobuf/${PROTOBUF_CPP_SLOT}/bin/protoc"
	"${PROTOC}" --version || die

	sed -i \
		-e "s|@EPYTHON@|${EPYTHON}|g" \
		"${S}/cc-detect/src/shell_command.rs" \
		"${S}/daemon/resources/liqctld/main.py" \
		"${S}/daemon/resources/liqctld/verify.py" \
		"${S}/daemon/src/repositories/liquidctl/liqctld_service.rs" \
		"${S}/resources/liqctld/main.py" \
		"${S}/resources/liqctld/verify.py" \
		|| die

	S="${S_ROOT}/coolercontrold" \
	cargo_src_configure
	pushd "${S_ROOT}" || die
		set_gui_port
		set_grpc_port
	popd
}

src_compile() {
	npm_hydrate
	pushd "${S_ROOT}/coolercontrol-ui" || die
einfo "PWD: $(pwd)"
		S="${S_ROOT}/coolercontrol-ui" \
		enpm install ${NPM_INSTALL_ARGS[@]}
	# Audit fix already done with NPM_UPDATE_LOCK=1
		S="${S_ROOT}/coolercontrol-ui" \
		enpm run build
	popd
	cp -r \
		"${S_ROOT}/coolercontrol-ui/dist/"* \
		"resources/app/" \
		|| die
	S="${S_ROOT}/coolercontrold" \
	cargo_src_compile
}

src_install() {
	# cargo install is broken
	exeinto "/usr/bin"
	doexe "${S}/target/"*"/release/coolercontrold"

	# Create directories with correct ownership
	keepdir "/etc/coolercontrol"
	keepdir "/var/lib/coolercontrol"

	if use openrc ; then
ewarn
ewarn "The OpenRC script is experimental for ${CATEGORY}/${PN}."
ewarn "If it works, send an issue request to remove this message."
ewarn
		exeinto "/etc/init.d"
		doexe "${FILESDIR}/coolercontrold"
	fi
	if use systemd ; then
		insinto "/lib/systemd/system"
		doins "${FILESDIR}/coolercontrold.service"
	fi
	if ! use openrc && ! use systemd ; then
ewarn
ewarn "You are responsible to creating the init service for ${PN} for your"
ewarn "init system."
ewarn
	fi

	insinto "/etc/udev/rules.d"
	doins "${FILESDIR}/99-coolercontrol.rules"

	LCNR_SOURCE="${WORKDIR}/cargo_home/gentoo"
	LCNR_TAG="third_party_cargo"
	lcnr_install_files

	LCNR_SOURCE="${S_ROOT}/coolercontrol-ui/node_modules"
	LCNR_TAG="third_party_npm"
	lcnr_install_files

	einstalldocs
	doman "${ROOT}/packaging/man/coolercontrold.8"
}

pkg_postinst() {
	local gui_port=${COOLERCONTROL_GUI_PORT:-11987}
	local grpc_port=${COOLERCONTROL_GRPC_PORT:-11988}
einfo
ewarn "The /etc/coolercontrol can be removed to reset the daemon settings."
einfo
einfo "GUI port:  ${gui_port}"
einfo "gRPC port:  ${grpc_port}"
einfo
einfo "Bookmark and access the GUI from the web browser:  http://localhost:${gui_port}"
einfo
einfo "Returning from a long vacation?"
einfo "To reset the password:  /usr/bin/coolercontrol --reset-password"
einfo

	fcaps_pkg_postinst

	# Set correct permissions
	chown -R "coolercontrold:coolercontrold" "${EROOT}/etc/coolercontrol" || true
	chown -R "coolercontrold:coolercontrold" "${EROOT}/var/lib/coolercontrol" || true

einfo "TODO:  any issues"

einfo "Reloading udev rules"
	sudo udevadm control --reload-rules
	sudo udevadm trigger

elog ""
elog "CoolerControlD has been installed and configured to run as the dedicated 'coolercontrold' user."
elog ""
elog "Security Note:"
elog ""
elog "  • Always run the daemon as a non-root user with minimal capabilities instead of full root privileges."
elog "  • This significantly reduces the attack surface."
elog ""
elog "To start the service:"

    if has_version sys-apps/openrc; then
elog
elog "  OpenRC:"
elog
elog "    rc-update add coolercontrold default"
elog "    rc-service coolercontrold start"
elog "    rc-service coolercontrold status"
    fi

    if has_version sys-apps/systemd; then
elog
elog "  systemd:"
elog
elog "    systemctl enable --now coolercontrold"
elog "    systemctl status coolercontrold"
    fi

# Not necessary at the moment.
#elog ""
#elog "For the CoolerControl GUI to access sensors and devices, add your user to the group:"
#elog
#elog "    usermod -aG coolercontrold \$USER"
#elog ""
#elog "Log file: /var/log/coolercontrold.log"
#elog "Config:   /etc/coolercontrol/config.toml"
elog ""
elog "You may want to reboot or log out/in after adding your user to the group."
elog ""
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  passed (0.17.2, 20231201)
# OILEDMACHINE-OVERLAY-TEST:  passed (2.2.1, 20250701)
# OILEDMACHINE-OVERLAY-TEST:  passed (2.2.2, 20250814)
# OILEDMACHINE-OVERLAY-TEST:  passed (3.0.1, 20251004)
# OILEDMACHINE-OVERLAY-TEST:  passed (4.2.1, 20260507) with limited user
# OpenRC - passed
# PWA - passed
# Systemd - untested
