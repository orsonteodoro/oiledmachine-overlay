# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

# U24, rust 1.75.0, llvm 17.0
# @swc/core, rust 1.77.1, llvm 18.0

CPU_FLAGS_X86=(
	"cpu_flags_x86_sse4_2"
)
CRATES="
addr2line-0.24.2
adler2-2.0.0
aes-0.8.4
aho-corasick-1.1.3
alloc-no-stdlib-2.0.4
alloc-stdlib-0.2.2
android-tzdata-0.1.1
android_system_properties-0.1.5
anyhow-1.0.97
arbitrary-1.4.1
ashpd-0.11.0
async-broadcast-0.7.2
async-channel-2.3.1
async-executor-1.13.1
async-fs-2.1.2
async-io-2.4.0
async-lock-3.4.0
async-process-2.3.0
async-recursion-1.1.1
async-signal-0.2.10
async-task-4.7.1
async-trait-0.1.88
atk-0.18.2
atk-sys-0.18.2
atomic-waker-1.1.2
autocfg-1.4.0
backtrace-0.3.74
base64-0.21.7
base64-0.22.1
base64ct-1.7.3
bit-set-0.5.3
bit-vec-0.6.3
bitflags-1.3.2
bitflags-2.9.0
block-buffer-0.10.4
block2-0.5.1
block2-0.6.0
blocking-1.6.1
brotli-7.0.0
brotli-decompressor-4.0.2
bstr-1.11.3
bumpalo-3.17.0
bytemuck-1.22.0
byteorder-1.5.0
bytes-1.10.1
bzip2-0.4.4
bzip2-sys-0.1.13+1.0.8
cairo-rs-0.18.5
cairo-sys-rs-0.18.2
camino-1.1.9
cargo-platform-0.1.9
cargo_metadata-0.19.2
cargo_toml-0.21.0
cc-1.2.16
cesu8-1.1.0
cfb-0.7.3
cfg-expr-0.15.8
cfg-if-1.0.0
cfg_aliases-0.2.1
chrono-0.4.40
cipher-0.4.4
combine-4.6.7
concurrent-queue-2.5.0
const-random-0.1.18
const-random-macro-0.1.16
constant_time_eq-0.1.5
convert_case-0.4.0
cookie-0.18.1
cookie_store-0.21.1
core-foundation-0.10.0
core-foundation-0.9.4
core-foundation-sys-0.8.7
core-graphics-0.24.0
core-graphics-types-0.2.0
cpufeatures-0.2.17
crc32fast-1.4.2
crossbeam-channel-0.5.14
crossbeam-utils-0.8.21
crunchy-0.2.3
crypto-common-0.1.6
cssparser-0.27.2
cssparser-macros-0.6.1
ctor-0.2.9
darling-0.20.10
darling_core-0.20.10
darling_macro-0.20.10
data-url-0.3.1
deranged-0.4.0
derive_arbitrary-1.4.1
derive_more-0.99.19
digest-0.10.7
dirs-6.0.0
dirs-sys-0.5.0
dispatch-0.2.0
dispatch2-0.2.0
displaydoc-0.2.5
dlopen2-0.7.0
dlopen2_derive-0.4.0
dlv-list-0.5.2
document-features-0.2.11
dpi-0.1.1
dtoa-1.0.10
dtoa-short-0.3.5
dunce-1.0.5
dyn-clone-1.0.19
embed-resource-3.0.2
embed_plist-1.2.2
encoding_rs-0.8.35
endi-1.1.0
enumflags2-0.7.11
enumflags2_derive-0.7.11
equivalent-1.0.2
erased-serde-0.4.6
errno-0.3.10
event-listener-5.4.0
event-listener-strategy-0.5.3
eventsource-client-0.12.2
fancy-regex-0.11.0
fastrand-2.3.0
fdeflate-0.3.7
field-offset-0.3.6
filetime-0.2.25
flate2-1.1.0
fnv-1.0.7
foreign-types-0.3.2
foreign-types-0.5.0
foreign-types-macros-0.2.3
foreign-types-shared-0.1.1
foreign-types-shared-0.3.1
form_urlencoded-1.2.1
futf-0.1.5
futures-0.3.31
futures-channel-0.3.31
futures-core-0.3.31
futures-executor-0.3.31
futures-io-0.3.31
futures-lite-2.6.0
futures-macro-0.3.31
futures-sink-0.3.31
futures-task-0.3.31
futures-util-0.3.31
fxhash-0.2.1
gdk-0.18.2
gdk-pixbuf-0.18.5
gdk-pixbuf-sys-0.18.0
gdk-sys-0.18.2
gdkwayland-sys-0.18.2
gdkx11-0.18.2
gdkx11-sys-0.18.2
generic-array-0.14.7
gethostname-1.0.0
getrandom-0.1.16
getrandom-0.2.15
getrandom-0.3.2
gimli-0.31.1
gio-0.18.4
gio-sys-0.18.1
glib-0.18.5
glib-macros-0.18.5
glib-sys-0.18.1
glob-0.3.2
gobject-sys-0.18.0
gtk-0.18.2
gtk-sys-0.18.2
gtk3-macros-0.18.2
h2-0.3.26
h2-0.4.8
hashbrown-0.12.3
hashbrown-0.14.5
hashbrown-0.15.2
heck-0.4.1
heck-0.5.0
hermit-abi-0.4.0
hex-0.4.3
hmac-0.12.1
html5ever-0.26.0
http-0.2.12
http-1.3.1
http-body-0.4.6
http-body-1.0.1
http-body-util-0.1.3
http-range-0.1.5
httparse-1.10.1
httpdate-1.0.3
hyper-0.14.32
hyper-1.6.0
hyper-rustls-0.24.2
hyper-rustls-0.27.5
hyper-timeout-0.4.1
hyper-tls-0.5.0
hyper-tls-0.6.0
hyper-util-0.1.10
iana-time-zone-0.1.61
iana-time-zone-haiku-0.1.2
ico-0.4.0
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
indexmap-1.9.3
indexmap-2.8.0
infer-0.19.0
inout-0.1.4
ipnet-2.11.0
is-docker-0.2.0
is-wsl-0.4.0
itoa-0.4.8
itoa-1.0.15
javascriptcore-rs-1.1.2
javascriptcore-rs-sys-1.1.1
jni-0.21.1
jni-sys-0.3.0
jobserver-0.1.32
js-sys-0.3.77
json-patch-3.0.1
jsonptr-0.6.3
keyboard-types-0.7.0
kuchikiki-0.8.2
lazy_static-1.5.0
libappindicator-0.9.0
libappindicator-sys-0.9.0
libc-0.2.171
libloading-0.7.4
libredox-0.1.3
linux-raw-sys-0.4.15
linux-raw-sys-0.9.3
litemap-0.7.5
litrs-0.4.1
lock_api-0.4.12
log-0.4.26
mac-0.1.1
markup5ever-0.11.0
matches-0.1.10
memchr-2.7.4
memoffset-0.9.1
mime-0.3.17
minisign-verify-0.2.3
miniz_oxide-0.8.5
mio-1.0.3
muda-0.16.1
native-tls-0.2.14
ndk-0.9.0
ndk-context-0.1.1
ndk-sys-0.6.0+11769913
new_debug_unreachable-1.0.6
nix-0.29.0
nodrop-0.1.14
num-conv-0.1.0
num-traits-0.2.19
num_enum-0.7.3
num_enum_derive-0.7.3
objc-sys-0.3.5
objc2-0.5.2
objc2-0.6.0
objc2-app-kit-0.3.0
objc2-cloud-kit-0.3.0
objc2-core-data-0.3.0
objc2-core-foundation-0.3.0
objc2-core-graphics-0.3.0
objc2-core-image-0.3.0
objc2-encode-4.1.0
objc2-exception-helper-0.1.1
objc2-foundation-0.2.2
objc2-foundation-0.3.0
objc2-io-surface-0.3.0
objc2-metal-0.2.2
objc2-osa-kit-0.3.0
objc2-quartz-core-0.2.2
objc2-quartz-core-0.3.0
objc2-ui-kit-0.3.0
objc2-web-kit-0.3.0
object-0.36.7
once_cell-1.21.1
open-5.3.2
openssl-0.10.71
openssl-macros-0.1.1
openssl-probe-0.1.6
openssl-sys-0.9.106
option-ext-0.2.0
ordered-multimap-0.7.3
ordered-stream-0.2.0
os_info-3.10.0
os_pipe-1.2.1
osakit-0.3.1
pango-0.18.3
pango-sys-0.18.0
parking-2.2.1
parking_lot-0.12.3
parking_lot_core-0.9.10
password-hash-0.4.2
pathdiff-0.2.3
pbkdf2-0.11.0
percent-encoding-2.3.1
phf-0.10.1
phf-0.11.3
phf-0.8.0
phf_codegen-0.10.0
phf_codegen-0.8.0
phf_generator-0.10.0
phf_generator-0.11.3
phf_generator-0.8.0
phf_macros-0.11.3
phf_macros-0.8.0
phf_shared-0.10.0
phf_shared-0.11.3
phf_shared-0.8.0
pin-project-1.1.10
pin-project-internal-1.1.10
pin-project-lite-0.2.16
pin-utils-0.1.0
piper-0.2.4
pkg-config-0.3.32
plist-1.7.0
png-0.17.16
polling-3.7.4
powerfmt-0.2.0
ppv-lite86-0.2.21
precomputed-hash-0.1.1
proc-macro-crate-1.3.1
proc-macro-crate-2.0.0
proc-macro-crate-3.3.0
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro-hack-0.5.20+deprecated
proc-macro2-1.0.94
psl-types-2.0.11
publicsuffix-2.3.0
quick-xml-0.32.0
quinn-0.11.7
quinn-proto-0.11.10
quinn-udp-0.5.10
quote-1.0.40
r-efi-5.2.0
rand-0.7.3
rand-0.8.5
rand-0.9.0
rand_chacha-0.2.2
rand_chacha-0.3.1
rand_chacha-0.9.0
rand_core-0.5.1
rand_core-0.6.4
rand_core-0.9.3
rand_hc-0.2.0
rand_pcg-0.2.1
raw-window-handle-0.6.2
redox_syscall-0.5.10
redox_users-0.5.0
regex-1.11.1
regex-automata-0.4.9
regex-syntax-0.8.5
reqwest-0.11.27
reqwest-0.12.15
rfd-0.15.3
ring-0.17.14
rust-ini-0.21.1
rustc-demangle-0.1.24
rustc-hash-1.1.0
rustc-hash-2.1.1
rustc_version-0.4.1
rustix-0.38.44
rustix-1.0.3
rustls-0.21.12
rustls-0.23.25
rustls-native-certs-0.6.3
rustls-pemfile-1.0.4
rustls-pemfile-2.2.0
rustls-pki-types-1.11.0
rustls-webpki-0.101.7
rustls-webpki-0.103.0
rustversion-1.0.20
ryu-1.0.20
same-file-1.0.6
schannel-0.1.27
schemars-0.8.22
schemars_derive-0.8.22
scopeguard-1.2.0
sct-0.7.1
security-framework-2.11.1
security-framework-sys-2.14.0
selectors-0.22.0
semver-1.0.26
serde-1.0.219
serde-untagged-0.1.7
serde_derive-1.0.219
serde_derive_internals-0.29.1
serde_json-1.0.140
serde_repr-0.1.20
serde_spanned-0.6.8
serde_urlencoded-0.7.1
serde_with-3.12.0
serde_with_macros-3.12.0
serialize-to-javascript-0.1.1
serialize-to-javascript-impl-0.1.1
servo_arc-0.1.1
sha1-0.10.6
sha2-0.10.8
shared_child-1.0.1
shlex-1.3.0
signal-hook-registry-1.4.2
simd-adler32-0.3.7
siphasher-0.3.11
siphasher-1.0.1
slab-0.4.9
smallvec-1.14.0
socket2-0.5.8
softbuffer-0.4.6
soup3-0.5.0
soup3-sys-0.5.0
stable_deref_trait-1.2.0
static_assertions-1.1.0
string_cache-0.8.8
string_cache_codegen-0.5.4
strsim-0.11.1
subtle-2.6.1
swift-rs-1.0.7
syn-1.0.109
syn-2.0.100
sync_wrapper-0.1.2
sync_wrapper-1.0.2
synstructure-0.13.1
sys-locale-0.3.2
system-configuration-0.5.1
system-configuration-0.6.1
system-configuration-sys-0.5.0
system-configuration-sys-0.6.0
system-deps-6.2.2
tao-0.32.8
tao-macros-0.1.3
tar-0.4.44
target-lexicon-0.12.16
tauri-2.3.1
tauri-build-2.0.6
tauri-codegen-2.0.5
tauri-macros-2.0.5
tauri-plugin-2.0.5
tauri-plugin-deep-link-2.2.0
tauri-plugin-dialog-2.2.0
tauri-plugin-fs-2.2.0
tauri-plugin-http-2.4.2
tauri-plugin-os-2.2.1
tauri-plugin-process-2.2.0
tauri-plugin-shell-2.2.0
tauri-plugin-single-instance-2.2.2
tauri-plugin-updater-2.6.1
tauri-runtime-2.4.0
tauri-runtime-wry-2.4.1
tauri-utils-2.2.0
tauri-winres-0.3.0
tempfile-3.19.0
tendril-0.4.3
thin-slice-0.1.1
thiserror-1.0.69
thiserror-2.0.12
thiserror-impl-1.0.69
thiserror-impl-2.0.12
tiktoken-rs-0.4.5
time-0.3.40
time-core-0.1.4
time-macros-0.2.21
tiny-keccak-2.0.2
tinystr-0.7.6
tinyvec-1.9.0
tinyvec_macros-0.1.1
tokio-1.44.1
tokio-io-timeout-1.2.0
tokio-macros-2.5.0
tokio-native-tls-0.3.1
tokio-rustls-0.24.1
tokio-rustls-0.26.2
tokio-util-0.7.14
toml-0.8.20
toml_datetime-0.6.8
toml_edit-0.19.15
toml_edit-0.20.7
toml_edit-0.22.24
tower-0.5.2
tower-layer-0.3.3
tower-service-0.3.3
tracing-0.1.41
tracing-attributes-0.1.28
tracing-core-0.1.33
tray-icon-0.20.0
trim-in-place-0.1.7
try-lock-0.2.5
typeid-1.0.3
typenum-1.18.0
uds_windows-1.1.0
unic-char-property-0.9.0
unic-char-range-0.9.0
unic-common-0.9.0
unic-ucd-ident-0.9.0
unic-ucd-version-0.9.0
unicode-ident-1.0.18
unicode-segmentation-1.12.0
untrusted-0.9.0
url-2.5.4
urlpattern-0.3.0
utf-8-0.7.6
utf16_iter-1.0.5
utf8_iter-1.0.4
uuid-1.16.0
vcpkg-0.2.15
version-compare-0.2.0
version_check-0.9.5
vswhom-0.1.0
vswhom-sys-0.1.3
walkdir-2.5.0
want-0.3.1
wasi-0.11.0+wasi-snapshot-preview1
wasi-0.14.2+wasi-0.2.4
wasi-0.9.0+wasi-snapshot-preview1
wasm-bindgen-0.2.100
wasm-bindgen-backend-0.2.100
wasm-bindgen-futures-0.4.50
wasm-bindgen-macro-0.2.100
wasm-bindgen-macro-support-0.2.100
wasm-bindgen-shared-0.2.100
wasm-streams-0.4.2
web-sys-0.3.77
web-time-1.1.0
webkit2gtk-2.0.1
webkit2gtk-sys-2.0.1
webpki-roots-0.26.8
webview2-com-0.36.0
webview2-com-macros-0.8.0
webview2-com-sys-0.36.0
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.9
winapi-x86_64-pc-windows-gnu-0.4.0
window-vibrancy-0.6.0
windows-0.60.0
windows-collections-0.1.1
windows-core-0.52.0
windows-core-0.60.1
windows-future-0.1.1
windows-implement-0.59.0
windows-interface-0.59.1
windows-link-0.1.1
windows-numerics-0.1.1
windows-registry-0.3.0
windows-registry-0.4.0
windows-result-0.2.0
windows-result-0.3.2
windows-strings-0.2.0
windows-strings-0.3.1
windows-sys-0.45.0
windows-sys-0.48.0
windows-sys-0.52.0
windows-sys-0.59.0
windows-targets-0.42.2
windows-targets-0.48.5
windows-targets-0.52.6
windows-targets-0.53.0
windows-version-0.1.4
windows_aarch64_gnullvm-0.42.2
windows_aarch64_gnullvm-0.48.5
windows_aarch64_gnullvm-0.52.6
windows_aarch64_gnullvm-0.53.0
windows_aarch64_msvc-0.42.2
windows_aarch64_msvc-0.48.5
windows_aarch64_msvc-0.52.6
windows_aarch64_msvc-0.53.0
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
winnow-0.5.40
winnow-0.7.4
winreg-0.50.0
winreg-0.52.0
wit-bindgen-rt-0.39.0
write16-1.0.0
writeable-0.5.5
wry-0.50.5
x11-2.21.0
x11-dl-2.21.0
xattr-1.5.0
xdg-home-1.3.0
yoke-0.7.5
yoke-derive-0.7.5
zbus-5.5.0
zbus_macros-5.5.0
zbus_names-4.2.0
zerocopy-0.8.23
zerocopy-derive-0.8.23
zerofrom-0.1.6
zerofrom-derive-0.1.6
zeroize-1.8.1
zerovec-0.10.4
zerovec-derive-0.10.3
zip-0.6.6
zip-2.4.2
zstd-0.11.2+zstd.1.5.2
zstd-safe-5.0.2+zstd.1.5.2
zstd-sys-2.0.14+zstd.1.5.7
zvariant-5.4.0
zvariant_derive-5.4.0
zvariant_utils-3.2.0

"
NODE_VERSION=20
NPM_AUDIT_FIX_ARGS=(
	"--legacy-peer-deps"
)
NPM_INSTALL_ARGS=(
	"--legacy-peer-deps"
)
NPM_SLOT="3"
RUST_MAX_VER="1.81.0" # Inclusive
RUST_MIN_VER="1.81.0" # llvm-18.0, required by @swc/core
RUST_PV="${RUST_MIN_VER}"
SHARP_PV="0.33.5"
TARBALL="${P}.tar.gz"
NPM_TARBALL="${TARBALL}"
VIPS_PV="8.15.3"
VITE_PV="5.4.9"
WEBKIT_GTK_STABLE=(
	"2.46"
	"2.44"
	"2.42"
	"2.40"
	"2.38"
	"2.36"
	"2.34"
	"2.32"
	"2.30"
	"2.28"
)

inherit cargo edo lcnr node-sharp npm xdg

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
S_PROJECT="${WORKDIR}/${P}"
SRC_URI="
$(cargo_crate_uris ${CRATES})
https://github.com/kwaroran/RisuAI/archive/refs/tags/v${PV}.tar.gz
	-> ${TARBALL}
"

DESCRIPTION="Make your own story. User-friendly software for LLM roleplaying"
LICENSE="
	GPL-3
	RisuAI-Terms-of-Service
"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE="
${CPU_FLAGS_X86[@]}
ollama +system-vips tray wayland X
ebuild_revision_6
"
REQUIRED_USE="
	!cpu_flags_x86_sse4_2? (
		system-vips
	)
	|| (
		X
		wayland
	)
"
gen_webkit_depend() {
	local s
	for s in ${WEBKIT_GTK_STABLE[@]} ; do
	# TODO:  add audio minimum requirement for webkit-gtk for tts/stt
	# onnxruntime-web needs webassembly
		echo "
			=net-libs/webkit-gtk-${s}*:4.1[javascript,jit,introspection,wayland?,webassembly,X?,webgl]
		"
	done
}
RUST_BINDINGS_DEPEND="
	>=app-accessibility/at-spi2-core-2.35.1[introspection]
	>=dev-libs/glib-2.48:2
	>=dev-libs/gobject-introspection-1.64.0
	>=net-libs/libsoup-2.70.0:2.4[introspection]
	>=x11-libs/cairo-1.14
	>=x11-libs/gdk-pixbuf-2.32[introspection]
	>=x11-libs/gtk+-3.18:3[introspection,wayland?,X?]
	>=x11-libs/pango-1.38[introspection]
	elibc_glibc? (
		>=sys-libs/glibc-2.31
	)
	elibc_musl? (
		>=sys-libs/musl-1.1.24
	)
	tray? (
		|| (
			>=dev-libs/libappindicator-12.10.1_p20200408:3
			>=dev-libs/libayatana-appindicator-0.5.4
		)
	)
	|| (
		$(gen_webkit_depend)
	)
	net-libs/webkit-gtk:=
"
RUST_BINDINGS_BDEPEND="
	virtual/pkgconfig
"
TAURI_RDEPEND="
	${RUST_BINDINGS_DEPEND}
	|| (
		dev-lang/rust-bin:${RUST_PV}
		dev-lang/rust:${RUST_PV}
	)
"
RDEPEND+="
	${TAURI_RDEPEND}
	ollama? (
		app-misc/ollama
	)
	system-vips? (
		>=media-libs/vips-${VIPS_PV}[cxx,exif,lcms,jpeg,png,svg]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${RUST_BINDINGS_BDEPEND}
	net-libs/nodejs:${NODE_VERSION}
	sys-apps/npm
"

pkg_setup() {
ewarn "This ebuild is still in development"
	npm_pkg_setup
	node-sharp_pkg_setup
	rust_pkg_setup
	if has_version "dev-lang/rust-bin:${RUST_PV}" ; then
		rust_prepend_path "${RUST_PV}" "binary"
	elif has_version "dev-lang/rust:${RUST_PV}" ; then
		rust_prepend_path "${RUST_PV}" "source"
	fi
}

npm_update_lock_install_post() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		enpm add -D "vite@${VITE_PV}" ${NPM_INSTALL_ARGS[@]}
	fi
}

npm_update_lock_audit_post() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		fix_lockfile() {
			sed -i -e "s|\"esbuild\": \"^0.21.3\"|\"esbuild\": \"^0.25.0\"|g" "package-lock.json" || die
		}
		fix_lockfile
		enpm add -D "esbuild@^0.25.0" --legacy-peer-deps
		node-sharp_npm_lockfile_add_sharp
		fix_lockfile
	fi
}

# @FUNCTION: cargo_src_unpack
# @DESCRIPTION:
# Unpacks the package and the cargo registry.
# From cargo.eclass
_cargo_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	mkdir -p "${ECARGO_VENDOR}" || die
	mkdir -p "${S}" || die

	cp -a \
		"${FILESDIR}/${PV}/Cargo."{"lock","toml"} \
		"${WORKDIR}/${P}/src-tauri" \
		|| die

	local archive shasum pkg
	for archive in ${A} ; do
		case "${archive}" in
			*.crate)
				ebegin "Loading ${archive} into Cargo registry"
				tar -xf "${DISTDIR}"/${archive} -C "${ECARGO_VENDOR}/" || die
				# generate sha256sum of the crate itself as cargo needs this
				shasum=$(sha256sum "${DISTDIR}"/${archive} | cut -d ' ' -f 1)
				pkg=$(basename ${archive} .crate)
				cat <<- EOF > ${ECARGO_VENDOR}/${pkg}/.cargo-checksum.json
				{
					"package": "${shasum}",
					"files": {}
				}
				EOF
				# if this is our target package we need it in ${WORKDIR} too
				# to make ${S} (and handle any revisions too)
				if [[ ${P} == ${pkg}* ]]; then
					tar -xf "${DISTDIR}"/${archive} -C "${WORKDIR}" || die
				fi
				eend $?
				;;
			*)
				#unpack ${archive} # don't unpack npm tarballs yet
				;;
		esac
	done

	cargo_gen_config
}

_production_unpack() {
	if [[ -e "${FILESDIR}/${PV}/Cargo.lock" ]] ; then
einfo "Adding Cargo.lock"
		cp -a \
			"${FILESDIR}/${PV}/Cargo."{"lock","toml"} \
			"${WORKDIR}/${P}/src-tauri" \
			|| die
	fi
	_cargo_src_unpack
}

src_unpack() {
einfo "Unpacking npm packages"
einfo "PATH: ${PATH}"
	rustc --version
	local rust_pv=$(rustc --version \
		| cut -f 2 -d " ")

	if ver_test "${rust_pv}" -ne "${RUST_PV}" ; then
eerror
eerror "Switch rust to ${RUST_PV} via \`eselect rust\`"
eerror
eerror "Current Rust version: ${rust_pv}"
eerror "Expected Rust version: ${RUST_PV}"
eerror
		die
	fi

	# For manual lockfile creation
ewarn "Ebuild dev QA:  Manually \`cargo add \"hyper-tls@^0.6\"\` for the cargo lockfile."
#	unpack ${A}
#	die

	npm_src_unpack
	node-sharp_npm_rebuild_sharp

einfo "Unpacking cargo packages"
	if [[ "${GENERATE_LOCKFILE}" == "1" ]] ; then
		S="${S_PROJECT}/src-tauri" \
		_lockfile_gen_unpack
	else
		S="${S_PROJECT}/src-tauri" \
		_production_unpack
	fi
}

src_prepare() {
	default
	eapply "${FILESDIR}/${PN}-146.1.0-ollama-fix.patch"
}

src_configure() {
	export PKG_CONFIG_PATH="/usr/$(get_libdir)/pkgconfig:${PKG_CONFIG_PATH}"
	cargo_src_configure
	sed -i -e "s|pnpm|npm run|g" "src-tauri/tauri.conf.json" || die
}

get_rustc_target() {
	if [[ "${ABI}" == "amd64" ]] && use elibc_musl ; then
		echo "x86_64-unknown-linux-musl"
	elif [[ "${ABI}" == "amd64" ]] ; then
		echo "x86_64-unknown-linux-gnu"
	elif [[ "${ABI}" == "arm64" ]] && use elibc_musl ; then
		echo "aarch64-unknown-linux-musl"
	elif [[ "${ABI}" == "arm64" ]] ; then
		echo "aarch64-unknown-linux-gnu"
	elif [[ "${CHOST}" =~ "armv7a".*"hf" ]] && use elibc_musl ; then
		echo "armv7-unknown-linux-musleabihf"
	elif [[ "${CHOST}" =~ "armv7a".*"hf" ]] ; then
		echo "armv7-unknown-linux-gnueabihf"
	elif [[ "${CHOST}" =~ "armv7a" ]] && use elibc_musl ; then
		echo "armv7-unknown-linux-musleabi"
	elif [[ "${CHOST}" =~ "armv7a" ]] ; then
		echo "armv7-unknown-linux-gnueabi"
	elif [[ "${ARCH}" == "arm" && "${CHOST}" =~ "arm-" ]] && use elibc_musl ; then
		echo "arm-unknown-linux-musleabi"
	elif [[ "${ARCH}" == "arm" && "${CHOST}" =~ "arm-" ]] ; then
		echo "arm-unknown-linux-gnueabi"
	# Missing mips64el n32
	elif [[ "${ARCH}" == "mips" && "${CHOST}" =~ "mips64el" && "${ABI}" == "n64" ]] && use elibc_musl ; then
		echo "mips64el-unknown-linux-muslabi64"
	elif [[ "${ARCH}" == "mips" && "${CHOST}" =~ "mips64el" && "${ABI}" == "n64" ]] ; then
		echo "mips64el-unknown-linux-gnuabi64"
	elif [[ "${ARCH}" == "mips" && "${CHOST}" =~ "mips64el" && "${ABI}" == "o32" ]] && use elibc_musl ; then
		echo "mipsel-unknown-linux-musl"
	elif [[ "${ARCH}" == "mips" && "${CHOST}" =~ "mips64el" && "${ABI}" == "o32" ]] ; then
		echo "mipsel-unknown-linux-gnu"
	elif [[ "${ARCH}" == "loong" && "${ABI}" == "lp64d" ]] ; then
		echo "loongarch64-unknown-linux-gnu"
	elif [[ "${ABI}" == "ppc64" ]] && use elibc_musl ; then
		echo "powerpc64-unknown-linux-musl"
	elif [[ "${ABI}" == "ppc64" ]] ; then
		echo "powerpc64-unknown-linux-gnu"
	elif [[ "${ABI}" == "ppc64" && "${CHOST}" =~ "powerpc64le" ]] && use elibc_musl ; then
		echo "powerpc64le-unknown-linux-musl"
	elif [[ "${ABI}" == "ppc64" && "${CHOST}" =~ "powerpc64le" ]] ; then
		echo "powerpc64le-unknown-linux-gnu"
	elif [[ "${ABI}" == "ppc" ]] && use elibc_musl ; then
		echo "powerpc-unknown-linux-musl"
	elif [[ "${ABI}" == "ppc" ]] ; then
		echo "powerpc-unknown-linux-gnu"
	# Missing riscv lp64d, ilp32d, ilp32
	elif [[ "${ARCH}" == "riscv" && "${ABI}" == "lp64" ]] && use elibc_musl ; then
		echo "riscv64gc-unknown-linux-musl"
	elif [[ "${ARCH}" == "riscv" && "${ABI}" == "lp64" ]] ; then
		echo "riscv64gc-unknown-linux-gnu"
	elif [[ "${ABI}" == "s390x" ]] && use elibc_musl ; then
		echo "s390x-unknown-linux-musl"
	elif [[ "${ABI}" == "s390x" ]] ; then
		echo "s390x-unknown-linux-gnu"
	elif [[ "${ABI}" == "sparc32" ]] ; then
		echo "sparc-unknown-linux-gnu"
	elif [[ "${ABI}" == "sparc64" ]] ; then
		echo "sparc64-unknown-linux-gnu"
	elif [[ "${ABI}" == "x86" ]] && use elibc_musl ; then
		echo "i686-unknown-linux-musl"
	elif [[ "${ABI}" == "x86" ]] ; then
		echo "i686-unknown-linux-gnu"
	else
eerror "Unsupported ARCH=${ARCH} ABI=${ABI}"
		die
	fi
}

src_compile() {
	rm -f "${S}/Cargo."{"toml","lock"}
	npm_hydrate
	enpm --version

#	enpm install -D "vite@${VITE_PV}" ${NPM_INSTALL_ARGS[@]}
	enpm run build
	local chost=$(get_rustc_target)
	enpm run tauri build -- --target "${chost}"
	grep -e "failed to build app" "${T}/build.log" && die "Detected error"
}

src_install() {
	local chost=$(get_rustc_target)
	exeinto "/usr/bin"
	doexe "src-tauri/target/${chost}/release/${PN}"

	newicon -s 48 "resources/icon-only.png" "${PN}.png"
	make_desktop_entry \
		"/usr/bin/${PN}" \
		"${PN^}" \
		"${PN}.png" \
		"Game;RolePlaying"
	docinto "licenses"
	dodoc "LICENSE"

	LCNR_SOURCE="${WORKDIR}/cargo_home/gentoo"
	LCNR_TAG="third_party_cargo"
	lcnr_install_files

	LCNR_SOURCE="${S_PROJECT}/node_modules"
	LCNR_TAG="third_party_npm"
	lcnr_install_files

	insinto "/usr/lib/${PN}"
	doins -r "src-tauri/target/${chost}/release/src-python"

	fperms 0755 "/usr/bin/${PN}"
	fowners "root:root" "/usr/bin/${PN}"
}

pkg_postinst() {
	xdg_pkg_postinst
	if use ollama ; then
einfo
einfo "The Ollama settings must be manually changed."
einfo "The default URI is http://localhost:11434"
einfo
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (139.2.0, 20241125)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (146.1.0, 20250120)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (149.1.0, 20250209)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (154.1.0, 20250209) with rust 1.81.0
# OILEDMACHINE-OVERLAY-TEST:  PASSED (155.0.0, 20250318) with rust 1.81.0
# ollama support - passed
