# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PNPM_SLOT=9
NODE_VERSION=20
NPM_AUDIT_FIX_ARGS="--legacy-peer-deps"
NPM_INSTALL_ARGS="--legacy-peer-deps"
TARBALL="${P}.tar.gz"
NPM_TARBALL="${TARBALL}"
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

CRATES="
addr2line-0.24.2
adler2-2.0.0
aes-0.8.4
aho-corasick-1.1.3
alloc-no-stdlib-2.0.4
alloc-stdlib-0.2.2
android-tzdata-0.1.1
android_system_properties-0.1.5
anyhow-1.0.93
arbitrary-1.4.1
ashpd-0.10.2
async-broadcast-0.7.1
async-channel-2.3.1
async-executor-1.13.1
async-fs-2.1.2
async-io-2.4.0
async-lock-3.4.0
async-process-2.3.0
async-recursion-1.1.1
async-signal-0.2.10
async-task-4.7.1
async-trait-0.1.83
atk-0.18.0
atk-sys-0.18.0
atomic-waker-1.1.2
autocfg-1.4.0
backtrace-0.3.74
base64-0.21.7
base64-0.22.1
base64ct-1.6.0
bit-set-0.5.3
bit-vec-0.6.3
bitflags-1.3.2
bitflags-2.6.0
block-0.1.6
block-buffer-0.10.4
block2-0.5.1
blocking-1.6.1
brotli-7.0.0
brotli-decompressor-4.0.1
bstr-1.11.0
bumpalo-3.16.0
bytemuck-1.20.0
byteorder-1.5.0
bytes-1.8.0
bzip2-0.4.4
bzip2-sys-0.1.11+1.0.8
cairo-rs-0.18.5
cairo-sys-rs-0.18.2
camino-1.1.9
cargo-platform-0.1.8
cargo_metadata-0.18.1
cargo_toml-0.17.2
cc-1.2.1
cesu8-1.1.0
cfb-0.7.3
cfg-expr-0.15.8
cfg-if-1.0.0
cfg_aliases-0.2.1
chrono-0.4.38
cipher-0.4.4
cocoa-0.26.0
cocoa-foundation-0.2.0
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
cpufeatures-0.2.16
crc32fast-1.4.2
crossbeam-channel-0.5.13
crossbeam-utils-0.8.20
crunchy-0.2.2
crypto-common-0.1.6
cssparser-0.27.2
cssparser-macros-0.6.1
ctor-0.2.9
darling-0.20.10
darling_core-0.20.10
darling_macro-0.20.10
data-url-0.3.1
deranged-0.3.11
derive_arbitrary-1.4.1
derive_more-0.99.18
digest-0.10.7
dirs-5.0.1
dirs-sys-0.4.1
dispatch-0.2.0
displaydoc-0.2.5
dlib-0.5.2
dlopen2-0.7.0
dlopen2_derive-0.4.0
dlv-list-0.5.2
document-features-0.2.10
downcast-rs-1.2.1
dpi-0.1.1
dtoa-1.0.9
dtoa-short-0.3.5
dunce-1.0.5
dyn-clone-1.0.17
embed-resource-2.5.1
embed_plist-1.2.2
encoding_rs-0.8.35
endi-1.1.0
enumflags2-0.7.10
enumflags2_derive-0.7.10
equivalent-1.0.1
erased-serde-0.4.5
errno-0.3.9
event-listener-5.3.1
event-listener-strategy-0.5.2
eventsource-client-0.12.2
fancy-regex-0.11.0
fastrand-2.2.0
fdeflate-0.3.6
field-offset-0.3.6
filetime-0.2.25
flate2-1.0.35
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
futures-lite-2.5.0
futures-macro-0.3.31
futures-sink-0.3.31
futures-task-0.3.31
futures-util-0.3.31
fxhash-0.2.1
gdk-0.18.0
gdk-pixbuf-0.18.5
gdk-pixbuf-sys-0.18.0
gdk-sys-0.18.0
gdkwayland-sys-0.18.0
gdkx11-0.18.0
gdkx11-sys-0.18.0
generic-array-0.14.7
gethostname-0.5.0
getrandom-0.1.16
getrandom-0.2.15
gimli-0.31.1
gio-0.18.4
gio-sys-0.18.1
glib-0.18.5
glib-macros-0.18.5
glib-sys-0.18.1
glob-0.3.1
gobject-sys-0.18.0
gtk-0.18.1
gtk-sys-0.18.0
gtk3-macros-0.18.0
h2-0.3.26
h2-0.4.7
hashbrown-0.12.3
hashbrown-0.14.5
hashbrown-0.15.2
heck-0.4.1
heck-0.5.0
hermit-abi-0.3.9
hermit-abi-0.4.0
hex-0.4.3
hmac-0.12.1
html5ever-0.26.0
http-0.2.12
http-1.1.0
http-body-0.4.6
http-body-1.0.1
http-body-util-0.1.2
http-range-0.1.5
httparse-1.9.5
httpdate-1.0.3
hyper-0.14.31
hyper-1.5.1
hyper-rustls-0.24.2
hyper-rustls-0.27.3
hyper-timeout-0.4.1
hyper-tls-0.5.0
hyper-tls-0.6.0
hyper-util-0.1.10
iana-time-zone-0.1.61
iana-time-zone-haiku-0.1.2
ico-0.3.0
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
indexmap-2.6.0
infer-0.16.0
inout-0.1.3
instant-0.1.13
ipnet-2.10.1
is-docker-0.2.0
is-wsl-0.4.0
itoa-0.4.8
itoa-1.0.13
javascriptcore-rs-1.1.2
javascriptcore-rs-sys-1.1.1
jni-0.21.1
jni-sys-0.3.0
jobserver-0.1.32
js-sys-0.3.72
json-patch-3.0.1
jsonptr-0.6.3
keyboard-types-0.7.0
kuchikiki-0.8.2
lazy_static-1.5.0
libappindicator-0.9.0
libappindicator-sys-0.9.0
libc-0.2.164
libloading-0.7.4
libloading-0.8.5
libredox-0.1.3
linux-raw-sys-0.4.14
litemap-0.7.4
litrs-0.4.1
lock_api-0.4.12
log-0.4.22
mac-0.1.1
malloc_buf-0.0.6
markup5ever-0.11.0
matches-0.1.10
memchr-2.7.4
memoffset-0.9.1
mime-0.3.17
minisign-verify-0.2.2
miniz_oxide-0.8.0
mio-1.0.2
muda-0.15.3
native-tls-0.2.12
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
objc-0.2.7
objc-sys-0.3.5
objc2-0.5.2
objc2-app-kit-0.2.2
objc2-cloud-kit-0.2.2
objc2-contacts-0.2.2
objc2-core-data-0.2.2
objc2-core-image-0.2.2
objc2-core-location-0.2.2
objc2-encode-4.0.3
objc2-foundation-0.2.2
objc2-link-presentation-0.2.2
objc2-metal-0.2.2
objc2-quartz-core-0.2.2
objc2-symbols-0.2.2
objc2-ui-kit-0.2.2
objc2-uniform-type-identifiers-0.2.2
objc2-user-notifications-0.2.2
objc2-web-kit-0.2.2
object-0.36.5
once_cell-1.20.2
open-5.3.1
openssl-0.10.68
openssl-macros-0.1.1
openssl-probe-0.1.5
openssl-sys-0.9.104
option-ext-0.2.0
ordered-multimap-0.7.3
ordered-stream-0.2.0
os_info-3.8.2
os_pipe-1.2.1
pango-0.18.3
pango-sys-0.18.0
parking-2.2.1
parking_lot-0.12.3
parking_lot_core-0.9.10
password-hash-0.4.2
pathdiff-0.2.2
pbkdf2-0.11.0
percent-encoding-2.3.1
phf-0.10.1
phf-0.11.2
phf-0.8.0
phf_codegen-0.10.0
phf_codegen-0.8.0
phf_generator-0.10.0
phf_generator-0.11.2
phf_generator-0.8.0
phf_macros-0.11.2
phf_macros-0.8.0
phf_shared-0.10.0
phf_shared-0.11.2
phf_shared-0.8.0
pin-project-1.1.7
pin-project-internal-1.1.7
pin-project-lite-0.2.15
pin-utils-0.1.0
piper-0.2.4
pkg-config-0.3.31
plist-1.7.0
png-0.17.14
polling-3.7.4
powerfmt-0.2.0
ppv-lite86-0.2.20
precomputed-hash-0.1.1
proc-macro-crate-1.3.1
proc-macro-crate-2.0.0
proc-macro-crate-3.2.0
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro-hack-0.5.20+deprecated
proc-macro2-1.0.92
psl-types-2.0.11
publicsuffix-2.3.0
quick-xml-0.32.0
quick-xml-0.36.2
quinn-0.11.6
quinn-proto-0.11.9
quinn-udp-0.5.7
quote-1.0.37
rand-0.7.3
rand-0.8.5
rand_chacha-0.2.2
rand_chacha-0.3.1
rand_core-0.5.1
rand_core-0.6.4
rand_hc-0.2.0
rand_pcg-0.2.1
raw-window-handle-0.6.2
redox_syscall-0.5.7
redox_users-0.4.6
regex-1.11.1
regex-automata-0.4.9
regex-syntax-0.8.5
reqwest-0.11.27
reqwest-0.12.9
rfd-0.15.1
ring-0.17.8
rust-ini-0.21.1
rustc-demangle-0.1.24
rustc-hash-1.1.0
rustc-hash-2.0.0
rustc_version-0.4.1
rustix-0.38.41
rustls-0.21.12
rustls-0.23.18
rustls-native-certs-0.6.3
rustls-pemfile-1.0.4
rustls-pemfile-2.2.0
rustls-pki-types-1.10.0
rustls-webpki-0.101.7
rustls-webpki-0.102.8
ryu-1.0.18
same-file-1.0.6
schannel-0.1.27
schemars-0.8.21
schemars_derive-0.8.21
scoped-tls-1.0.1
scopeguard-1.2.0
sct-0.7.1
security-framework-2.11.1
security-framework-sys-2.12.1
selectors-0.22.0
semver-1.0.23
serde-1.0.215
serde-untagged-0.1.6
serde_derive-1.0.215
serde_derive_internals-0.29.1
serde_json-1.0.133
serde_repr-0.1.19
serde_spanned-0.6.8
serde_urlencoded-0.7.1
serde_with-3.11.0
serde_with_macros-3.11.0
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
slab-0.4.9
smallvec-1.13.2
socket2-0.5.7
softbuffer-0.4.6
soup3-0.5.0
soup3-sys-0.5.0
spin-0.9.8
stable_deref_trait-1.2.0
static_assertions-1.1.0
string_cache-0.8.7
string_cache_codegen-0.5.2
strsim-0.11.1
subtle-2.6.1
swift-rs-1.0.7
syn-1.0.109
syn-2.0.89
sync_wrapper-0.1.2
sync_wrapper-1.0.2
synstructure-0.13.1
sys-locale-0.3.2
system-configuration-0.5.1
system-configuration-0.6.1
system-configuration-sys-0.5.0
system-configuration-sys-0.6.0
system-deps-6.2.2
tao-0.30.8
tao-macros-0.1.3
tar-0.4.43
target-lexicon-0.12.16
tauri-2.1.1
tauri-build-2.0.3
tauri-codegen-2.0.3
tauri-macros-2.0.3
tauri-plugin-2.0.3
tauri-plugin-deep-link-2.0.1
tauri-plugin-dialog-2.0.3
tauri-plugin-fs-2.0.3
tauri-plugin-http-2.0.3
tauri-plugin-os-2.0.1
tauri-plugin-process-2.0.1
tauri-plugin-shell-2.0.2
tauri-plugin-single-instance-2.0.1
tauri-plugin-updater-2.0.2
tauri-runtime-2.2.0
tauri-runtime-wry-2.2.0
tauri-utils-2.1.0
tauri-winres-0.1.1
tempfile-3.14.0
tendril-0.4.3
thin-slice-0.1.1
thiserror-1.0.69
thiserror-2.0.3
thiserror-impl-1.0.69
thiserror-impl-2.0.3
tiktoken-rs-0.4.5
time-0.3.36
time-core-0.1.2
time-macros-0.2.18
tiny-keccak-2.0.2
tinystr-0.7.6
tinyvec-1.8.0
tinyvec_macros-0.1.1
tokio-1.41.1
tokio-io-timeout-1.2.0
tokio-macros-2.4.0
tokio-native-tls-0.3.1
tokio-rustls-0.24.1
tokio-rustls-0.26.0
tokio-util-0.7.12
toml-0.7.8
toml-0.8.19
toml_datetime-0.6.8
toml_edit-0.19.15
toml_edit-0.20.7
toml_edit-0.22.22
tower-service-0.3.3
tracing-0.1.40
tracing-attributes-0.1.27
tracing-core-0.1.32
tray-icon-0.19.2
trim-in-place-0.1.7
try-lock-0.2.5
typeid-1.0.2
typenum-1.17.0
uds_windows-1.1.0
unic-char-property-0.9.0
unic-char-range-0.9.0
unic-common-0.9.0
unic-ucd-ident-0.9.0
unic-ucd-version-0.9.0
unicode-ident-1.0.14
unicode-segmentation-1.12.0
untrusted-0.9.0
url-2.5.4
urlpattern-0.3.0
utf-8-0.7.6
utf16_iter-1.0.5
utf8_iter-1.0.4
uuid-1.11.0
vcpkg-0.2.15
version-compare-0.2.0
version_check-0.9.5
vswhom-0.1.0
vswhom-sys-0.1.2
walkdir-2.5.0
want-0.3.1
wasi-0.11.0+wasi-snapshot-preview1
wasi-0.9.0+wasi-snapshot-preview1
wasm-bindgen-0.2.95
wasm-bindgen-backend-0.2.95
wasm-bindgen-futures-0.4.45
wasm-bindgen-macro-0.2.95
wasm-bindgen-macro-support-0.2.95
wasm-bindgen-shared-0.2.95
wasm-streams-0.4.2
wayland-backend-0.3.7
wayland-client-0.31.7
wayland-protocols-0.32.5
wayland-scanner-0.31.5
wayland-sys-0.31.5
web-sys-0.3.72
web-time-1.1.0
webkit2gtk-2.0.1
webkit2gtk-sys-2.0.1
webpki-roots-0.26.7
webview2-com-0.33.0
webview2-com-macros-0.8.0
webview2-com-sys-0.33.0
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.9
winapi-x86_64-pc-windows-gnu-0.4.0
window-vibrancy-0.5.2
windows-0.58.0
windows-core-0.52.0
windows-core-0.58.0
windows-implement-0.58.0
windows-interface-0.58.0
windows-registry-0.2.0
windows-registry-0.3.0
windows-result-0.2.0
windows-strings-0.1.0
windows-strings-0.2.0
windows-sys-0.45.0
windows-sys-0.48.0
windows-sys-0.52.0
windows-sys-0.59.0
windows-targets-0.42.2
windows-targets-0.48.5
windows-targets-0.52.6
windows-version-0.1.1
windows_aarch64_gnullvm-0.42.2
windows_aarch64_gnullvm-0.48.5
windows_aarch64_gnullvm-0.52.6
windows_aarch64_msvc-0.42.2
windows_aarch64_msvc-0.48.5
windows_aarch64_msvc-0.52.6
windows_i686_gnu-0.42.2
windows_i686_gnu-0.48.5
windows_i686_gnu-0.52.6
windows_i686_gnullvm-0.52.6
windows_i686_msvc-0.42.2
windows_i686_msvc-0.48.5
windows_i686_msvc-0.52.6
windows_x86_64_gnu-0.42.2
windows_x86_64_gnu-0.48.5
windows_x86_64_gnu-0.52.6
windows_x86_64_gnullvm-0.42.2
windows_x86_64_gnullvm-0.48.5
windows_x86_64_gnullvm-0.52.6
windows_x86_64_msvc-0.42.2
windows_x86_64_msvc-0.48.5
windows_x86_64_msvc-0.52.6
winnow-0.5.40
winnow-0.6.20
winreg-0.50.0
winreg-0.52.0
write16-1.0.0
writeable-0.5.5
wry-0.47.2
x11-2.21.0
x11-dl-2.21.0
xattr-1.3.1
xdg-home-1.3.0
yoke-0.7.5
yoke-derive-0.7.5
zbus-4.4.0
zbus-5.1.1
zbus_macros-4.4.0
zbus_macros-5.1.1
zbus_names-3.0.0
zbus_names-4.1.0
zerocopy-0.7.35
zerocopy-derive-0.7.35
zerofrom-0.1.5
zerofrom-derive-0.1.5
zeroize-1.8.1
zerovec-0.10.4
zerovec-derive-0.10.3
zip-0.6.6
zip-2.2.1
zstd-0.11.2+zstd.1.5.2
zstd-safe-5.0.2+zstd.1.5.2
zstd-sys-2.0.13+zstd.1.5.6
zvariant-4.2.0
zvariant-5.1.0
zvariant_derive-4.2.0
zvariant_derive-5.1.0
zvariant_utils-2.1.0
zvariant_utils-3.0.2
"

inherit cargo edo electron-app lcnr npm xdg

# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@adobe/css-tools/-/css-tools-4.3.2.tgz -> npmpkg-@adobe-css-tools-4.3.2.tgz
https://registry.npmjs.org/@alloc/quick-lru/-/quick-lru-5.2.0.tgz -> npmpkg-@alloc-quick-lru-5.2.0.tgz
https://registry.npmjs.org/@ampproject/remapping/-/remapping-2.3.0.tgz -> npmpkg-@ampproject-remapping-2.3.0.tgz
https://registry.npmjs.org/@asamuzakjp/dom-selector/-/dom-selector-2.0.2.tgz -> npmpkg-@asamuzakjp-dom-selector-2.0.2.tgz
https://registry.npmjs.org/@aws-crypto/sha256-js/-/sha256-js-5.2.0.tgz -> npmpkg-@aws-crypto-sha256-js-5.2.0.tgz
https://registry.npmjs.org/@aws-crypto/util/-/util-5.2.0.tgz -> npmpkg-@aws-crypto-util-5.2.0.tgz
https://registry.npmjs.org/@aws-sdk/types/-/types-3.696.0.tgz -> npmpkg-@aws-sdk-types-3.696.0.tgz
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.26.2.tgz -> npmpkg-@babel-code-frame-7.26.2.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.25.9.tgz -> npmpkg-@babel-helper-validator-identifier-7.25.9.tgz
https://registry.npmjs.org/@capacitor/android/-/android-5.7.8.tgz -> npmpkg-@capacitor-android-5.7.8.tgz
https://registry.npmjs.org/@capacitor/assets/-/assets-3.0.5.tgz -> npmpkg-@capacitor-assets-3.0.5.tgz
https://registry.npmjs.org/css-select/-/css-select-4.3.0.tgz -> npmpkg-css-select-4.3.0.tgz
https://registry.npmjs.org/dom-serializer/-/dom-serializer-1.4.1.tgz -> npmpkg-dom-serializer-1.4.1.tgz
https://registry.npmjs.org/domhandler/-/domhandler-4.3.1.tgz -> npmpkg-domhandler-4.3.1.tgz
https://registry.npmjs.org/domutils/-/domutils-2.8.0.tgz -> npmpkg-domutils-2.8.0.tgz
https://registry.npmjs.org/entities/-/entities-2.2.0.tgz -> npmpkg-entities-2.2.0.tgz
https://registry.npmjs.org/node-html-parser/-/node-html-parser-5.4.2.tgz -> npmpkg-node-html-parser-5.4.2.tgz
https://registry.npmjs.org/tslib/-/tslib-2.6.2.tgz -> npmpkg-tslib-2.6.2.tgz
https://registry.npmjs.org/@capacitor/cli/-/cli-5.7.8.tgz -> npmpkg-@capacitor-cli-5.7.8.tgz
https://registry.npmjs.org/commander/-/commander-9.5.0.tgz -> npmpkg-commander-9.5.0.tgz
https://registry.npmjs.org/@capacitor/core/-/core-5.7.8.tgz -> npmpkg-@capacitor-core-5.7.8.tgz
https://registry.npmjs.org/@capacitor/filesystem/-/filesystem-5.2.2.tgz -> npmpkg-@capacitor-filesystem-5.2.2.tgz
https://registry.npmjs.org/@cspotcode/source-map-support/-/source-map-support-0.8.1.tgz -> npmpkg-@cspotcode-source-map-support-0.8.1.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.9.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.9.tgz
https://registry.npmjs.org/@dqbd/tiktoken/-/tiktoken-1.0.17.tgz -> npmpkg-@dqbd-tiktoken-1.0.17.tgz
https://registry.npmjs.org/@esbuild/linux-x64/-/linux-x64-0.21.5.tgz -> npmpkg-@esbuild-linux-x64-0.21.5.tgz
https://registry.npmjs.org/@huggingface/jinja/-/jinja-0.2.2.tgz -> npmpkg-@huggingface-jinja-0.2.2.tgz
https://registry.npmjs.org/@hutson/parse-repository-url/-/parse-repository-url-3.0.2.tgz -> npmpkg-@hutson-parse-repository-url-3.0.2.tgz
https://registry.npmjs.org/@ionic/cli-framework-output/-/cli-framework-output-2.2.8.tgz -> npmpkg-@ionic-cli-framework-output-2.2.8.tgz
https://registry.npmjs.org/@ionic/utils-array/-/utils-array-2.1.6.tgz -> npmpkg-@ionic-utils-array-2.1.6.tgz
https://registry.npmjs.org/@ionic/utils-fs/-/utils-fs-3.1.7.tgz -> npmpkg-@ionic-utils-fs-3.1.7.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/@ionic/utils-object/-/utils-object-2.1.6.tgz -> npmpkg-@ionic-utils-object-2.1.6.tgz
https://registry.npmjs.org/@ionic/utils-process/-/utils-process-2.1.11.tgz -> npmpkg-@ionic-utils-process-2.1.11.tgz
https://registry.npmjs.org/@ionic/utils-terminal/-/utils-terminal-2.3.4.tgz -> npmpkg-@ionic-utils-terminal-2.3.4.tgz
https://registry.npmjs.org/@ionic/utils-stream/-/utils-stream-3.1.6.tgz -> npmpkg-@ionic-utils-stream-3.1.6.tgz
https://registry.npmjs.org/@ionic/utils-subprocess/-/utils-subprocess-2.1.14.tgz -> npmpkg-@ionic-utils-subprocess-2.1.14.tgz
https://registry.npmjs.org/@ionic/utils-terminal/-/utils-terminal-2.3.4.tgz -> npmpkg-@ionic-utils-terminal-2.3.4.tgz
https://registry.npmjs.org/@ionic/utils-terminal/-/utils-terminal-2.3.5.tgz -> npmpkg-@ionic-utils-terminal-2.3.5.tgz
https://registry.npmjs.org/@isaacs/cliui/-/cliui-8.0.2.tgz -> npmpkg-@isaacs-cliui-8.0.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-6.1.0.tgz -> npmpkg-ansi-regex-6.1.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-6.2.1.tgz -> npmpkg-ansi-styles-6.2.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-9.2.2.tgz -> npmpkg-emoji-regex-9.2.2.tgz
https://registry.npmjs.org/string-width/-/string-width-5.1.2.tgz -> npmpkg-string-width-5.1.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-7.1.0.tgz -> npmpkg-strip-ansi-7.1.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-8.1.0.tgz -> npmpkg-wrap-ansi-8.1.0.tgz
https://registry.npmjs.org/@jridgewell/gen-mapping/-/gen-mapping-0.3.5.tgz -> npmpkg-@jridgewell-gen-mapping-0.3.5.tgz
https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.2.tgz -> npmpkg-@jridgewell-resolve-uri-3.1.2.tgz
https://registry.npmjs.org/@jridgewell/set-array/-/set-array-1.2.1.tgz -> npmpkg-@jridgewell-set-array-1.2.1.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.5.0.tgz -> npmpkg-@jridgewell-sourcemap-codec-1.5.0.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.25.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.25.tgz
https://registry.npmjs.org/@mlc-ai/web-tokenizers/-/web-tokenizers-0.1.5.tgz -> npmpkg-@mlc-ai-web-tokenizers-0.1.5.tgz
https://registry.npmjs.org/@msgpack/msgpack/-/msgpack-2.8.0.tgz -> npmpkg-@msgpack-msgpack-2.8.0.tgz
https://registry.npmjs.org/@msgpackr-extract/msgpackr-extract-linux-x64/-/msgpackr-extract-linux-x64-3.0.3.tgz -> npmpkg-@msgpackr-extract-msgpackr-extract-linux-x64-3.0.3.tgz
https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> npmpkg-@nodelib-fs.scandir-2.1.5.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> npmpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> npmpkg-@nodelib-fs.walk-1.2.8.tgz
https://registry.npmjs.org/@pkgjs/parseargs/-/parseargs-0.11.0.tgz -> npmpkg-@pkgjs-parseargs-0.11.0.tgz
https://registry.npmjs.org/@popperjs/core/-/core-2.11.8.tgz -> npmpkg-@popperjs-core-2.11.8.tgz
https://registry.npmjs.org/@prettier/plugin-xml/-/plugin-xml-2.2.0.tgz -> npmpkg-@prettier-plugin-xml-2.2.0.tgz
https://registry.npmjs.org/@protobufjs/aspromise/-/aspromise-1.1.2.tgz -> npmpkg-@protobufjs-aspromise-1.1.2.tgz
https://registry.npmjs.org/@protobufjs/base64/-/base64-1.1.2.tgz -> npmpkg-@protobufjs-base64-1.1.2.tgz
https://registry.npmjs.org/@protobufjs/codegen/-/codegen-2.0.4.tgz -> npmpkg-@protobufjs-codegen-2.0.4.tgz
https://registry.npmjs.org/@protobufjs/eventemitter/-/eventemitter-1.1.0.tgz -> npmpkg-@protobufjs-eventemitter-1.1.0.tgz
https://registry.npmjs.org/@protobufjs/fetch/-/fetch-1.1.0.tgz -> npmpkg-@protobufjs-fetch-1.1.0.tgz
https://registry.npmjs.org/@protobufjs/float/-/float-1.0.2.tgz -> npmpkg-@protobufjs-float-1.0.2.tgz
https://registry.npmjs.org/@protobufjs/inquire/-/inquire-1.1.0.tgz -> npmpkg-@protobufjs-inquire-1.1.0.tgz
https://registry.npmjs.org/@protobufjs/path/-/path-1.1.2.tgz -> npmpkg-@protobufjs-path-1.1.2.tgz
https://registry.npmjs.org/@protobufjs/pool/-/pool-1.1.0.tgz -> npmpkg-@protobufjs-pool-1.1.0.tgz
https://registry.npmjs.org/@protobufjs/utf8/-/utf8-1.1.0.tgz -> npmpkg-@protobufjs-utf8-1.1.0.tgz
https://registry.npmjs.org/@risuai/ccardlib/-/ccardlib-0.4.2.tgz -> npmpkg-@risuai-ccardlib-0.4.2.tgz
https://registry.npmjs.org/@rollup/plugin-virtual/-/plugin-virtual-3.0.2.tgz -> npmpkg-@rollup-plugin-virtual-3.0.2.tgz
https://registry.npmjs.org/@rollup/rollup-linux-x64-gnu/-/rollup-linux-x64-gnu-4.27.4.tgz -> npmpkg-@rollup-rollup-linux-x64-gnu-4.27.4.tgz
https://registry.npmjs.org/@rollup/rollup-linux-x64-musl/-/rollup-linux-x64-musl-4.27.4.tgz -> npmpkg-@rollup-rollup-linux-x64-musl-4.27.4.tgz
https://registry.npmjs.org/@smithy/is-array-buffer/-/is-array-buffer-2.2.0.tgz -> npmpkg-@smithy-is-array-buffer-2.2.0.tgz
https://registry.npmjs.org/@smithy/protocol-http/-/protocol-http-3.3.0.tgz -> npmpkg-@smithy-protocol-http-3.3.0.tgz
https://registry.npmjs.org/@smithy/types/-/types-2.12.0.tgz -> npmpkg-@smithy-types-2.12.0.tgz
https://registry.npmjs.org/@smithy/signature-v4/-/signature-v4-2.3.0.tgz -> npmpkg-@smithy-signature-v4-2.3.0.tgz
https://registry.npmjs.org/@smithy/types/-/types-2.12.0.tgz -> npmpkg-@smithy-types-2.12.0.tgz
https://registry.npmjs.org/@smithy/types/-/types-3.7.1.tgz -> npmpkg-@smithy-types-3.7.1.tgz
https://registry.npmjs.org/@smithy/util-buffer-from/-/util-buffer-from-2.2.0.tgz -> npmpkg-@smithy-util-buffer-from-2.2.0.tgz
https://registry.npmjs.org/@smithy/util-hex-encoding/-/util-hex-encoding-2.2.0.tgz -> npmpkg-@smithy-util-hex-encoding-2.2.0.tgz
https://registry.npmjs.org/@smithy/util-middleware/-/util-middleware-2.2.0.tgz -> npmpkg-@smithy-util-middleware-2.2.0.tgz
https://registry.npmjs.org/@smithy/types/-/types-2.12.0.tgz -> npmpkg-@smithy-types-2.12.0.tgz
https://registry.npmjs.org/@smithy/util-uri-escape/-/util-uri-escape-2.2.0.tgz -> npmpkg-@smithy-util-uri-escape-2.2.0.tgz
https://registry.npmjs.org/@smithy/util-utf8/-/util-utf8-2.3.0.tgz -> npmpkg-@smithy-util-utf8-2.3.0.tgz
https://registry.npmjs.org/@sveltejs/vite-plugin-svelte/-/vite-plugin-svelte-4.0.1.tgz -> npmpkg-@sveltejs-vite-plugin-svelte-4.0.1.tgz
https://registry.npmjs.org/@sveltejs/vite-plugin-svelte-inspector/-/vite-plugin-svelte-inspector-3.0.1.tgz -> npmpkg-@sveltejs-vite-plugin-svelte-inspector-3.0.1.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/@swc/core/-/core-1.5.7.tgz -> npmpkg-@swc-core-1.5.7.tgz
https://registry.npmjs.org/@swc/core-linux-x64-gnu/-/core-linux-x64-gnu-1.5.7.tgz -> npmpkg-@swc-core-linux-x64-gnu-1.5.7.tgz
https://registry.npmjs.org/@swc/core-linux-x64-musl/-/core-linux-x64-musl-1.5.7.tgz -> npmpkg-@swc-core-linux-x64-musl-1.5.7.tgz
https://registry.npmjs.org/@swc/counter/-/counter-0.1.3.tgz -> npmpkg-@swc-counter-0.1.3.tgz
https://registry.npmjs.org/@swc/types/-/types-0.1.7.tgz -> npmpkg-@swc-types-0.1.7.tgz
https://registry.npmjs.org/@tailwindcss/typography/-/typography-0.5.15.tgz -> npmpkg-@tailwindcss-typography-0.5.15.tgz
https://registry.npmjs.org/@tauri-apps/api/-/api-2.0.0.tgz -> npmpkg-@tauri-apps-api-2.0.0.tgz
https://registry.npmjs.org/@tauri-apps/cli/-/cli-2.0.2.tgz -> npmpkg-@tauri-apps-cli-2.0.2.tgz
https://registry.npmjs.org/@tauri-apps/cli-linux-x64-gnu/-/cli-linux-x64-gnu-2.0.2.tgz -> npmpkg-@tauri-apps-cli-linux-x64-gnu-2.0.2.tgz
https://registry.npmjs.org/@tauri-apps/cli-linux-x64-musl/-/cli-linux-x64-musl-2.0.2.tgz -> npmpkg-@tauri-apps-cli-linux-x64-musl-2.0.2.tgz
https://registry.npmjs.org/@tauri-apps/plugin-deep-link/-/plugin-deep-link-2.0.0.tgz -> npmpkg-@tauri-apps-plugin-deep-link-2.0.0.tgz
https://registry.npmjs.org/@tauri-apps/plugin-dialog/-/plugin-dialog-2.0.1.tgz -> npmpkg-@tauri-apps-plugin-dialog-2.0.1.tgz
https://registry.npmjs.org/@tauri-apps/plugin-fs/-/plugin-fs-2.0.2.tgz -> npmpkg-@tauri-apps-plugin-fs-2.0.2.tgz
https://registry.npmjs.org/@tauri-apps/plugin-http/-/plugin-http-2.0.1.tgz -> npmpkg-@tauri-apps-plugin-http-2.0.1.tgz
https://registry.npmjs.org/@tauri-apps/plugin-os/-/plugin-os-2.0.0.tgz -> npmpkg-@tauri-apps-plugin-os-2.0.0.tgz
https://registry.npmjs.org/@tauri-apps/plugin-process/-/plugin-process-2.0.0.tgz -> npmpkg-@tauri-apps-plugin-process-2.0.0.tgz
https://registry.npmjs.org/@tauri-apps/plugin-shell/-/plugin-shell-2.0.1.tgz -> npmpkg-@tauri-apps-plugin-shell-2.0.1.tgz
https://registry.npmjs.org/@tauri-apps/plugin-updater/-/plugin-updater-2.0.0.tgz -> npmpkg-@tauri-apps-plugin-updater-2.0.0.tgz
https://registry.npmjs.org/@trapezedev/gradle-parse/-/gradle-parse-7.1.3.tgz -> npmpkg-@trapezedev-gradle-parse-7.1.3.tgz
https://registry.npmjs.org/@trapezedev/project/-/project-7.1.3.tgz -> npmpkg-@trapezedev-project-7.1.3.tgz
https://registry.npmjs.org/env-paths/-/env-paths-3.0.0.tgz -> npmpkg-env-paths-3.0.0.tgz
https://registry.npmjs.org/@tsconfig/node10/-/node10-1.0.11.tgz -> npmpkg-@tsconfig-node10-1.0.11.tgz
https://registry.npmjs.org/@tsconfig/node12/-/node12-1.0.11.tgz -> npmpkg-@tsconfig-node12-1.0.11.tgz
https://registry.npmjs.org/@tsconfig/node14/-/node14-1.0.3.tgz -> npmpkg-@tsconfig-node14-1.0.3.tgz
https://registry.npmjs.org/@tsconfig/node16/-/node16-1.0.4.tgz -> npmpkg-@tsconfig-node16-1.0.4.tgz
https://registry.npmjs.org/@tsconfig/svelte/-/svelte-3.0.0.tgz -> npmpkg-@tsconfig-svelte-3.0.0.tgz
https://registry.npmjs.org/@tweenjs/tween.js/-/tween.js-18.6.4.tgz -> npmpkg-@tweenjs-tween.js-18.6.4.tgz
https://registry.npmjs.org/@types/blueimp-md5/-/blueimp-md5-2.18.2.tgz -> npmpkg-@types-blueimp-md5-2.18.2.tgz
https://registry.npmjs.org/@types/codemirror/-/codemirror-5.60.15.tgz -> npmpkg-@types-codemirror-5.60.15.tgz
https://registry.npmjs.org/@types/dompurify/-/dompurify-3.2.0.tgz -> npmpkg-@types-dompurify-3.2.0.tgz
https://registry.npmjs.org/@types/emscripten/-/emscripten-1.39.10.tgz -> npmpkg-@types-emscripten-1.39.10.tgz
https://registry.npmjs.org/@types/estree/-/estree-1.0.6.tgz -> npmpkg-@types-estree-1.0.6.tgz
https://registry.npmjs.org/@types/fs-extra/-/fs-extra-8.1.5.tgz -> npmpkg-@types-fs-extra-8.1.5.tgz
https://registry.npmjs.org/@types/libsodium-wrappers/-/libsodium-wrappers-0.7.14.tgz -> npmpkg-@types-libsodium-wrappers-0.7.14.tgz
https://registry.npmjs.org/@types/libsodium-wrappers-sumo/-/libsodium-wrappers-sumo-0.7.8.tgz -> npmpkg-@types-libsodium-wrappers-sumo-0.7.8.tgz
https://registry.npmjs.org/@types/linkify-it/-/linkify-it-5.0.0.tgz -> npmpkg-@types-linkify-it-5.0.0.tgz
https://registry.npmjs.org/@types/lodash/-/lodash-4.17.13.tgz -> npmpkg-@types-lodash-4.17.13.tgz
https://registry.npmjs.org/@types/lodash.isequal/-/lodash.isequal-4.5.8.tgz -> npmpkg-@types-lodash.isequal-4.5.8.tgz
https://registry.npmjs.org/@types/long/-/long-4.0.2.tgz -> npmpkg-@types-long-4.0.2.tgz
https://registry.npmjs.org/@types/markdown-it/-/markdown-it-14.1.2.tgz -> npmpkg-@types-markdown-it-14.1.2.tgz
https://registry.npmjs.org/@types/mdurl/-/mdurl-2.0.0.tgz -> npmpkg-@types-mdurl-2.0.0.tgz
https://registry.npmjs.org/@types/minimist/-/minimist-1.2.5.tgz -> npmpkg-@types-minimist-1.2.5.tgz
https://registry.npmjs.org/@types/node/-/node-18.19.65.tgz -> npmpkg-@types-node-18.19.65.tgz
https://registry.npmjs.org/@types/normalize-package-data/-/normalize-package-data-2.4.4.tgz -> npmpkg-@types-normalize-package-data-2.4.4.tgz
https://registry.npmjs.org/@types/showdown/-/showdown-2.0.6.tgz -> npmpkg-@types-showdown-2.0.6.tgz
https://registry.npmjs.org/@types/slice-ansi/-/slice-ansi-4.0.0.tgz -> npmpkg-@types-slice-ansi-4.0.0.tgz
https://registry.npmjs.org/@types/sortablejs/-/sortablejs-1.15.8.tgz -> npmpkg-@types-sortablejs-1.15.8.tgz
https://registry.npmjs.org/@types/stats.js/-/stats.js-0.17.3.tgz -> npmpkg-@types-stats.js-0.17.3.tgz
https://registry.npmjs.org/@types/streamsaver/-/streamsaver-2.0.5.tgz -> npmpkg-@types-streamsaver-2.0.5.tgz
https://registry.npmjs.org/@types/tern/-/tern-0.23.9.tgz -> npmpkg-@types-tern-0.23.9.tgz
https://registry.npmjs.org/@types/three/-/three-0.154.0.tgz -> npmpkg-@types-three-0.154.0.tgz
https://registry.npmjs.org/fflate/-/fflate-0.6.10.tgz -> npmpkg-fflate-0.6.10.tgz
https://registry.npmjs.org/@types/trusted-types/-/trusted-types-2.0.7.tgz -> npmpkg-@types-trusted-types-2.0.7.tgz
https://registry.npmjs.org/@types/uuid/-/uuid-9.0.8.tgz -> npmpkg-@types-uuid-9.0.8.tgz
https://registry.npmjs.org/@types/webxr/-/webxr-0.5.20.tgz -> npmpkg-@types-webxr-0.5.20.tgz
https://registry.npmjs.org/@types/wicg-file-system-access/-/wicg-file-system-access-2020.9.8.tgz -> npmpkg-@types-wicg-file-system-access-2020.9.8.tgz
https://registry.npmjs.org/@xenova/transformers/-/transformers-2.17.2.tgz -> npmpkg-@xenova-transformers-2.17.2.tgz
https://registry.npmjs.org/@xml-tools/parser/-/parser-1.0.11.tgz -> npmpkg-@xml-tools-parser-1.0.11.tgz
https://registry.npmjs.org/@xmldom/xmldom/-/xmldom-0.7.13.tgz -> npmpkg-@xmldom-xmldom-0.7.13.tgz
https://registry.npmjs.org/accepts/-/accepts-1.3.8.tgz -> npmpkg-accepts-1.3.8.tgz
https://registry.npmjs.org/acorn/-/acorn-8.14.0.tgz -> npmpkg-acorn-8.14.0.tgz
https://registry.npmjs.org/acorn-typescript/-/acorn-typescript-1.4.13.tgz -> npmpkg-acorn-typescript-1.4.13.tgz
https://registry.npmjs.org/acorn-walk/-/acorn-walk-8.3.4.tgz -> npmpkg-acorn-walk-8.3.4.tgz
https://registry.npmjs.org/add-stream/-/add-stream-1.0.0.tgz -> npmpkg-add-stream-1.0.0.tgz
https://registry.npmjs.org/agent-base/-/agent-base-7.1.1.tgz -> npmpkg-agent-base-7.1.1.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-3.1.0.tgz -> npmpkg-aggregate-error-3.1.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/any-promise/-/any-promise-1.3.0.tgz -> npmpkg-any-promise-1.3.0.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz -> npmpkg-anymatch-3.1.3.tgz
https://registry.npmjs.org/arg/-/arg-5.0.2.tgz -> npmpkg-arg-5.0.2.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz -> npmpkg-argparse-2.0.1.tgz
https://registry.npmjs.org/aria-query/-/aria-query-5.3.2.tgz -> npmpkg-aria-query-5.3.2.tgz
https://registry.npmjs.org/array-flatten/-/array-flatten-1.1.1.tgz -> npmpkg-array-flatten-1.1.1.tgz
https://registry.npmjs.org/array-ify/-/array-ify-1.0.0.tgz -> npmpkg-array-ify-1.0.0.tgz
https://registry.npmjs.org/array-keyed-map/-/array-keyed-map-2.1.3.tgz -> npmpkg-array-keyed-map-2.1.3.tgz
https://registry.npmjs.org/array-union/-/array-union-2.1.0.tgz -> npmpkg-array-union-2.1.0.tgz
https://registry.npmjs.org/arrify/-/arrify-1.0.1.tgz -> npmpkg-arrify-1.0.1.tgz
https://registry.npmjs.org/asap/-/asap-2.0.6.tgz -> npmpkg-asap-2.0.6.tgz
https://registry.npmjs.org/astral-regex/-/astral-regex-2.0.0.tgz -> npmpkg-astral-regex-2.0.0.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz -> npmpkg-asynckit-0.4.0.tgz
https://registry.npmjs.org/at-least-node/-/at-least-node-1.0.0.tgz -> npmpkg-at-least-node-1.0.0.tgz
https://registry.npmjs.org/autoprefixer/-/autoprefixer-10.4.20.tgz -> npmpkg-autoprefixer-10.4.20.tgz
https://registry.npmjs.org/axobject-query/-/axobject-query-4.1.0.tgz -> npmpkg-axobject-query-4.1.0.tgz
https://registry.npmjs.org/b4a/-/b4a-1.6.7.tgz -> npmpkg-b4a-1.6.7.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz -> npmpkg-balanced-match-1.0.2.tgz
https://registry.npmjs.org/bare-events/-/bare-events-2.5.0.tgz -> npmpkg-bare-events-2.5.0.tgz
https://registry.npmjs.org/bare-fs/-/bare-fs-2.3.5.tgz -> npmpkg-bare-fs-2.3.5.tgz
https://registry.npmjs.org/bare-os/-/bare-os-2.4.4.tgz -> npmpkg-bare-os-2.4.4.tgz
https://registry.npmjs.org/bare-path/-/bare-path-2.1.3.tgz -> npmpkg-bare-path-2.1.3.tgz
https://registry.npmjs.org/bare-stream/-/bare-stream-2.4.2.tgz -> npmpkg-bare-stream-2.4.2.tgz
https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz -> npmpkg-base64-js-1.5.1.tgz
https://registry.npmjs.org/bidi-js/-/bidi-js-1.0.3.tgz -> npmpkg-bidi-js-1.0.3.tgz
https://registry.npmjs.org/big-integer/-/big-integer-1.6.52.tgz -> npmpkg-big-integer-1.6.52.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.3.0.tgz -> npmpkg-binary-extensions-2.3.0.tgz
https://registry.npmjs.org/binary-search/-/binary-search-1.3.6.tgz -> npmpkg-binary-search-1.3.6.tgz
https://registry.npmjs.org/bl/-/bl-4.1.0.tgz -> npmpkg-bl-4.1.0.tgz
https://registry.npmjs.org/buffer/-/buffer-5.7.1.tgz -> npmpkg-buffer-5.7.1.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/blueimp-md5/-/blueimp-md5-2.19.0.tgz -> npmpkg-blueimp-md5-2.19.0.tgz
https://registry.npmjs.org/body-parser/-/body-parser-1.20.3.tgz -> npmpkg-body-parser-1.20.3.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/boolbase/-/boolbase-1.0.0.tgz -> npmpkg-boolbase-1.0.0.tgz
https://registry.npmjs.org/bplist-creator/-/bplist-creator-0.1.0.tgz -> npmpkg-bplist-creator-0.1.0.tgz
https://registry.npmjs.org/bplist-parser/-/bplist-parser-0.3.2.tgz -> npmpkg-bplist-parser-0.3.2.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/braces/-/braces-3.0.3.tgz -> npmpkg-braces-3.0.3.tgz
https://registry.npmjs.org/browserslist/-/browserslist-4.24.2.tgz -> npmpkg-browserslist-4.24.2.tgz
https://registry.npmjs.org/buffer/-/buffer-6.0.3.tgz -> npmpkg-buffer-6.0.3.tgz
https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> npmpkg-buffer-crc32-0.2.13.tgz
https://registry.npmjs.org/bytes/-/bytes-3.1.2.tgz -> npmpkg-bytes-3.1.2.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.7.tgz -> npmpkg-call-bind-1.0.7.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/camelcase-css/-/camelcase-css-2.0.1.tgz -> npmpkg-camelcase-css-2.0.1.tgz
https://registry.npmjs.org/camelcase-keys/-/camelcase-keys-6.2.2.tgz -> npmpkg-camelcase-keys-6.2.2.tgz
https://registry.npmjs.org/caniuse-lite/-/caniuse-lite-1.0.30001684.tgz -> npmpkg-caniuse-lite-1.0.30001684.tgz
https://registry.npmjs.org/canvas/-/canvas-3.0.0-rc2.tgz -> npmpkg-canvas-3.0.0-rc2.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/chevrotain/-/chevrotain-7.1.1.tgz -> npmpkg-chevrotain-7.1.1.tgz
https://registry.npmjs.org/chokidar/-/chokidar-4.0.1.tgz -> npmpkg-chokidar-4.0.1.tgz
https://registry.npmjs.org/chownr/-/chownr-2.0.0.tgz -> npmpkg-chownr-2.0.0.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-2.2.0.tgz -> npmpkg-clean-stack-2.2.0.tgz
https://registry.npmjs.org/cliui/-/cliui-8.0.1.tgz -> npmpkg-cliui-8.0.1.tgz
https://registry.npmjs.org/codemirror/-/codemirror-5.65.18.tgz -> npmpkg-codemirror-5.65.18.tgz
https://registry.npmjs.org/color/-/color-4.2.3.tgz -> npmpkg-color-4.2.3.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/color-string/-/color-string-1.9.1.tgz -> npmpkg-color-string-1.9.1.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/colord/-/colord-2.9.3.tgz -> npmpkg-colord-2.9.3.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz -> npmpkg-combined-stream-1.0.8.tgz
https://registry.npmjs.org/commander/-/commander-8.3.0.tgz -> npmpkg-commander-8.3.0.tgz
https://registry.npmjs.org/compare-func/-/compare-func-2.0.0.tgz -> npmpkg-compare-func-2.0.0.tgz
https://registry.npmjs.org/compression-streams-polyfill/-/compression-streams-polyfill-0.1.7.tgz -> npmpkg-compression-streams-polyfill-0.1.7.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/content-disposition/-/content-disposition-0.5.4.tgz -> npmpkg-content-disposition-0.5.4.tgz
https://registry.npmjs.org/content-type/-/content-type-1.0.5.tgz -> npmpkg-content-type-1.0.5.tgz
https://registry.npmjs.org/conventional-changelog/-/conventional-changelog-3.1.25.tgz -> npmpkg-conventional-changelog-3.1.25.tgz
https://registry.npmjs.org/conventional-changelog-angular/-/conventional-changelog-angular-5.0.13.tgz -> npmpkg-conventional-changelog-angular-5.0.13.tgz
https://registry.npmjs.org/conventional-changelog-atom/-/conventional-changelog-atom-2.0.8.tgz -> npmpkg-conventional-changelog-atom-2.0.8.tgz
https://registry.npmjs.org/conventional-changelog-codemirror/-/conventional-changelog-codemirror-2.0.8.tgz -> npmpkg-conventional-changelog-codemirror-2.0.8.tgz
https://registry.npmjs.org/conventional-changelog-conventionalcommits/-/conventional-changelog-conventionalcommits-4.6.3.tgz -> npmpkg-conventional-changelog-conventionalcommits-4.6.3.tgz
https://registry.npmjs.org/conventional-changelog-core/-/conventional-changelog-core-4.2.4.tgz -> npmpkg-conventional-changelog-core-4.2.4.tgz
https://registry.npmjs.org/conventional-changelog-ember/-/conventional-changelog-ember-2.0.9.tgz -> npmpkg-conventional-changelog-ember-2.0.9.tgz
https://registry.npmjs.org/conventional-changelog-eslint/-/conventional-changelog-eslint-3.0.9.tgz -> npmpkg-conventional-changelog-eslint-3.0.9.tgz
https://registry.npmjs.org/conventional-changelog-express/-/conventional-changelog-express-2.0.6.tgz -> npmpkg-conventional-changelog-express-2.0.6.tgz
https://registry.npmjs.org/conventional-changelog-jquery/-/conventional-changelog-jquery-3.0.11.tgz -> npmpkg-conventional-changelog-jquery-3.0.11.tgz
https://registry.npmjs.org/conventional-changelog-jshint/-/conventional-changelog-jshint-2.0.9.tgz -> npmpkg-conventional-changelog-jshint-2.0.9.tgz
https://registry.npmjs.org/conventional-changelog-preset-loader/-/conventional-changelog-preset-loader-2.3.4.tgz -> npmpkg-conventional-changelog-preset-loader-2.3.4.tgz
https://registry.npmjs.org/conventional-changelog-writer/-/conventional-changelog-writer-5.0.1.tgz -> npmpkg-conventional-changelog-writer-5.0.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/conventional-commits-filter/-/conventional-commits-filter-2.0.7.tgz -> npmpkg-conventional-commits-filter-2.0.7.tgz
https://registry.npmjs.org/conventional-commits-parser/-/conventional-commits-parser-3.2.4.tgz -> npmpkg-conventional-commits-parser-3.2.4.tgz
https://registry.npmjs.org/cookie/-/cookie-0.7.1.tgz -> npmpkg-cookie-0.7.1.tgz
https://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.6.tgz -> npmpkg-cookie-signature-1.0.6.tgz
https://registry.npmjs.org/core-js/-/core-js-3.39.0.tgz -> npmpkg-core-js-3.39.0.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.3.tgz -> npmpkg-core-util-is-1.0.3.tgz
https://registry.npmjs.org/cors/-/cors-2.8.5.tgz -> npmpkg-cors-2.8.5.tgz
https://registry.npmjs.org/crc/-/crc-4.3.2.tgz -> npmpkg-crc-4.3.2.tgz
https://registry.npmjs.org/crc-32/-/crc-32-0.3.0.tgz -> npmpkg-crc-32-0.3.0.tgz
https://registry.npmjs.org/create-require/-/create-require-1.1.1.tgz -> npmpkg-create-require-1.1.1.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.6.tgz -> npmpkg-cross-spawn-7.0.6.tgz
https://registry.npmjs.org/crypto-random-string/-/crypto-random-string-2.0.0.tgz -> npmpkg-crypto-random-string-2.0.0.tgz
https://registry.npmjs.org/css-select/-/css-select-5.1.0.tgz -> npmpkg-css-select-5.1.0.tgz
https://registry.npmjs.org/css-tree/-/css-tree-2.3.1.tgz -> npmpkg-css-tree-2.3.1.tgz
https://registry.npmjs.org/css-what/-/css-what-6.1.0.tgz -> npmpkg-css-what-6.1.0.tgz
https://registry.npmjs.org/cssesc/-/cssesc-3.0.0.tgz -> npmpkg-cssesc-3.0.0.tgz
https://registry.npmjs.org/cssstyle/-/cssstyle-4.1.0.tgz -> npmpkg-cssstyle-4.1.0.tgz
https://registry.npmjs.org/rrweb-cssom/-/rrweb-cssom-0.7.1.tgz -> npmpkg-rrweb-cssom-0.7.1.tgz
https://registry.npmjs.org/dargs/-/dargs-7.0.0.tgz -> npmpkg-dargs-7.0.0.tgz
https://registry.npmjs.org/data-urls/-/data-urls-5.0.0.tgz -> npmpkg-data-urls-5.0.0.tgz
https://registry.npmjs.org/dateformat/-/dateformat-3.0.3.tgz -> npmpkg-dateformat-3.0.3.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/decamelize/-/decamelize-1.2.0.tgz -> npmpkg-decamelize-1.2.0.tgz
https://registry.npmjs.org/decamelize-keys/-/decamelize-keys-1.1.1.tgz -> npmpkg-decamelize-keys-1.1.1.tgz
https://registry.npmjs.org/map-obj/-/map-obj-1.0.1.tgz -> npmpkg-map-obj-1.0.1.tgz
https://registry.npmjs.org/decimal.js/-/decimal.js-10.4.3.tgz -> npmpkg-decimal.js-10.4.3.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-4.2.1.tgz -> npmpkg-decompress-response-4.2.1.tgz
https://registry.npmjs.org/deep-extend/-/deep-extend-0.6.0.tgz -> npmpkg-deep-extend-0.6.0.tgz
https://registry.npmjs.org/deepmerge/-/deepmerge-4.3.1.tgz -> npmpkg-deepmerge-4.3.1.tgz
https://registry.npmjs.org/default-gateway/-/default-gateway-6.0.3.tgz -> npmpkg-default-gateway-6.0.3.tgz
https://registry.npmjs.org/define-data-property/-/define-data-property-1.1.4.tgz -> npmpkg-define-data-property-1.1.4.tgz
https://registry.npmjs.org/define-lazy-prop/-/define-lazy-prop-2.0.0.tgz -> npmpkg-define-lazy-prop-2.0.0.tgz
https://registry.npmjs.org/del/-/del-6.1.1.tgz -> npmpkg-del-6.1.1.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz -> npmpkg-delayed-stream-1.0.0.tgz
https://registry.npmjs.org/depd/-/depd-2.0.0.tgz -> npmpkg-depd-2.0.0.tgz
https://registry.npmjs.org/destroy/-/destroy-1.2.0.tgz -> npmpkg-destroy-1.2.0.tgz
https://registry.npmjs.org/detect-libc/-/detect-libc-2.0.3.tgz -> npmpkg-detect-libc-2.0.3.tgz
https://registry.npmjs.org/dezalgo/-/dezalgo-1.0.4.tgz -> npmpkg-dezalgo-1.0.4.tgz
https://registry.npmjs.org/didyoumean/-/didyoumean-1.2.2.tgz -> npmpkg-didyoumean-1.2.2.tgz
https://registry.npmjs.org/diff/-/diff-5.2.0.tgz -> npmpkg-diff-5.2.0.tgz
https://registry.npmjs.org/dir-glob/-/dir-glob-3.0.1.tgz -> npmpkg-dir-glob-3.0.1.tgz
https://registry.npmjs.org/path-type/-/path-type-4.0.0.tgz -> npmpkg-path-type-4.0.0.tgz
https://registry.npmjs.org/dlv/-/dlv-1.1.3.tgz -> npmpkg-dlv-1.1.3.tgz
https://registry.npmjs.org/dom-serializer/-/dom-serializer-2.0.0.tgz -> npmpkg-dom-serializer-2.0.0.tgz
https://registry.npmjs.org/domelementtype/-/domelementtype-2.3.0.tgz -> npmpkg-domelementtype-2.3.0.tgz
https://registry.npmjs.org/domhandler/-/domhandler-5.0.3.tgz -> npmpkg-domhandler-5.0.3.tgz
https://registry.npmjs.org/dompurify/-/dompurify-3.2.1.tgz -> npmpkg-dompurify-3.2.1.tgz
https://registry.npmjs.org/domutils/-/domutils-3.1.0.tgz -> npmpkg-domutils-3.1.0.tgz
https://registry.npmjs.org/dot-prop/-/dot-prop-5.3.0.tgz -> npmpkg-dot-prop-5.3.0.tgz
https://registry.npmjs.org/eastasianwidth/-/eastasianwidth-0.2.0.tgz -> npmpkg-eastasianwidth-0.2.0.tgz
https://registry.npmjs.org/ee-first/-/ee-first-1.1.1.tgz -> npmpkg-ee-first-1.1.1.tgz
https://registry.npmjs.org/electron-to-chromium/-/electron-to-chromium-1.5.64.tgz -> npmpkg-electron-to-chromium-1.5.64.tgz
https://registry.npmjs.org/elementtree/-/elementtree-0.1.7.tgz -> npmpkg-elementtree-0.1.7.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/encodeurl/-/encodeurl-2.0.0.tgz -> npmpkg-encodeurl-2.0.0.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz -> npmpkg-end-of-stream-1.4.4.tgz
https://registry.npmjs.org/entities/-/entities-4.5.0.tgz -> npmpkg-entities-4.5.0.tgz
https://registry.npmjs.org/env-paths/-/env-paths-2.2.1.tgz -> npmpkg-env-paths-2.2.1.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.2.tgz -> npmpkg-error-ex-1.3.2.tgz
https://registry.npmjs.org/es-define-property/-/es-define-property-1.0.0.tgz -> npmpkg-es-define-property-1.0.0.tgz
https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz -> npmpkg-es-errors-1.3.0.tgz
https://registry.npmjs.org/esbuild/-/esbuild-0.21.5.tgz -> npmpkg-esbuild-0.21.5.tgz
https://registry.npmjs.org/escalade/-/escalade-3.2.0.tgz -> npmpkg-escalade-3.2.0.tgz
https://registry.npmjs.org/escape-html/-/escape-html-1.0.3.tgz -> npmpkg-escape-html-1.0.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/esm-env/-/esm-env-1.1.4.tgz -> npmpkg-esm-env-1.1.4.tgz
https://registry.npmjs.org/esrap/-/esrap-1.2.2.tgz -> npmpkg-esrap-1.2.2.tgz
https://registry.npmjs.org/etag/-/etag-1.8.1.tgz -> npmpkg-etag-1.8.1.tgz
https://registry.npmjs.org/eventemitter3/-/eventemitter3-4.0.7.tgz -> npmpkg-eventemitter3-4.0.7.tgz
https://registry.npmjs.org/eventsource-parser/-/eventsource-parser-1.1.2.tgz -> npmpkg-eventsource-parser-1.1.2.tgz
https://registry.npmjs.org/execa/-/execa-5.1.1.tgz -> npmpkg-execa-5.1.1.tgz
https://registry.npmjs.org/exifr/-/exifr-7.1.3.tgz -> npmpkg-exifr-7.1.3.tgz
https://registry.npmjs.org/expand-template/-/expand-template-2.0.3.tgz -> npmpkg-expand-template-2.0.3.tgz
https://registry.npmjs.org/express/-/express-4.21.1.tgz -> npmpkg-express-4.21.1.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/fast-fifo/-/fast-fifo-1.3.2.tgz -> npmpkg-fast-fifo-1.3.2.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.2.tgz -> npmpkg-fast-glob-3.3.2.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/fastq/-/fastq-1.17.1.tgz -> npmpkg-fastq-1.17.1.tgz
https://registry.npmjs.org/fd-slicer/-/fd-slicer-1.1.0.tgz -> npmpkg-fd-slicer-1.1.0.tgz
https://registry.npmjs.org/fdir/-/fdir-6.4.2.tgz -> npmpkg-fdir-6.4.2.tgz
https://registry.npmjs.org/fflate/-/fflate-0.8.2.tgz -> npmpkg-fflate-0.8.2.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz -> npmpkg-fill-range-7.1.1.tgz
https://registry.npmjs.org/finalhandler/-/finalhandler-1.3.1.tgz -> npmpkg-finalhandler-1.3.1.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/find-up/-/find-up-2.1.0.tgz -> npmpkg-find-up-2.1.0.tgz
https://registry.npmjs.org/flatbuffers/-/flatbuffers-1.12.0.tgz -> npmpkg-flatbuffers-1.12.0.tgz
https://registry.npmjs.org/foreground-child/-/foreground-child-3.3.0.tgz -> npmpkg-foreground-child-3.3.0.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-4.1.0.tgz -> npmpkg-signal-exit-4.1.0.tgz
https://registry.npmjs.org/form-data/-/form-data-4.0.1.tgz -> npmpkg-form-data-4.0.1.tgz
https://registry.npmjs.org/formidable/-/formidable-3.5.2.tgz -> npmpkg-formidable-3.5.2.tgz
https://registry.npmjs.org/forwarded/-/forwarded-0.2.0.tgz -> npmpkg-forwarded-0.2.0.tgz
https://registry.npmjs.org/fraction.js/-/fraction.js-4.3.7.tgz -> npmpkg-fraction.js-4.3.7.tgz
https://registry.npmjs.org/fresh/-/fresh-0.5.2.tgz -> npmpkg-fresh-0.5.2.tgz
https://registry.npmjs.org/fs-constants/-/fs-constants-1.0.0.tgz -> npmpkg-fs-constants-1.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/fs-minipass/-/fs-minipass-2.1.0.tgz -> npmpkg-fs-minipass-2.1.0.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz -> npmpkg-function-bind-1.1.2.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz -> npmpkg-get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.4.tgz -> npmpkg-get-intrinsic-1.2.4.tgz
https://registry.npmjs.org/get-pkg-repo/-/get-pkg-repo-4.2.1.tgz -> npmpkg-get-pkg-repo-4.2.1.tgz
https://registry.npmjs.org/cliui/-/cliui-7.0.4.tgz -> npmpkg-cliui-7.0.4.tgz
https://registry.npmjs.org/through2/-/through2-2.0.5.tgz -> npmpkg-through2-2.0.5.tgz
https://registry.npmjs.org/yargs/-/yargs-16.2.0.tgz -> npmpkg-yargs-16.2.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-6.0.1.tgz -> npmpkg-get-stream-6.0.1.tgz
https://registry.npmjs.org/git-raw-commits/-/git-raw-commits-2.0.11.tgz -> npmpkg-git-raw-commits-2.0.11.tgz
https://registry.npmjs.org/git-remote-origin-url/-/git-remote-origin-url-2.0.0.tgz -> npmpkg-git-remote-origin-url-2.0.0.tgz
https://registry.npmjs.org/git-semver-tags/-/git-semver-tags-4.1.1.tgz -> npmpkg-git-semver-tags-4.1.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/gitconfiglocal/-/gitconfiglocal-1.0.0.tgz -> npmpkg-gitconfiglocal-1.0.0.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/github-from-package/-/github-from-package-0.0.0.tgz -> npmpkg-github-from-package-0.0.0.tgz
https://registry.npmjs.org/glob/-/glob-9.3.5.tgz -> npmpkg-glob-9.3.5.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-6.0.2.tgz -> npmpkg-glob-parent-6.0.2.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-8.0.4.tgz -> npmpkg-minimatch-8.0.4.tgz
https://registry.npmjs.org/globby/-/globby-11.1.0.tgz -> npmpkg-globby-11.1.0.tgz
https://registry.npmjs.org/gopd/-/gopd-1.0.1.tgz -> npmpkg-gopd-1.0.1.tgz
https://registry.npmjs.org/gpt-3-encoder/-/gpt-3-encoder-1.1.4.tgz -> npmpkg-gpt-3-encoder-1.1.4.tgz
https://registry.npmjs.org/gpt3-tokenizer/-/gpt3-tokenizer-1.1.5.tgz -> npmpkg-gpt3-tokenizer-1.1.5.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz -> npmpkg-graceful-fs-4.2.11.tgz
https://registry.npmjs.org/gradle-to-js/-/gradle-to-js-2.0.1.tgz -> npmpkg-gradle-to-js-2.0.1.tgz
https://registry.npmjs.org/guid-typescript/-/guid-typescript-1.0.9.tgz -> npmpkg-guid-typescript-1.0.9.tgz
https://registry.npmjs.org/handlebars/-/handlebars-4.7.8.tgz -> npmpkg-handlebars-4.7.8.tgz
https://registry.npmjs.org/hard-rejection/-/hard-rejection-2.1.0.tgz -> npmpkg-hard-rejection-2.1.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.2.tgz -> npmpkg-has-property-descriptors-1.0.2.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.3.tgz -> npmpkg-has-proto-1.0.3.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/hasown/-/hasown-2.0.2.tgz -> npmpkg-hasown-2.0.2.tgz
https://registry.npmjs.org/he/-/he-1.2.0.tgz -> npmpkg-he-1.2.0.tgz
https://registry.npmjs.org/hexoid/-/hexoid-2.0.0.tgz -> npmpkg-hexoid-2.0.0.tgz
https://registry.npmjs.org/highlight.js/-/highlight.js-11.10.0.tgz -> npmpkg-highlight.js-11.10.0.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-4.1.0.tgz -> npmpkg-hosted-git-info-4.1.0.tgz
https://registry.npmjs.org/html-encoding-sniffer/-/html-encoding-sniffer-4.0.0.tgz -> npmpkg-html-encoding-sniffer-4.0.0.tgz
https://registry.npmjs.org/html-to-image/-/html-to-image-1.11.11.tgz -> npmpkg-html-to-image-1.11.11.tgz
https://registry.npmjs.org/http-errors/-/http-errors-2.0.0.tgz -> npmpkg-http-errors-2.0.0.tgz
https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-7.0.2.tgz -> npmpkg-http-proxy-agent-7.0.2.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-7.0.5.tgz -> npmpkg-https-proxy-agent-7.0.5.tgz
https://registry.npmjs.org/human-signals/-/human-signals-2.1.0.tgz -> npmpkg-human-signals-2.1.0.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.24.tgz -> npmpkg-iconv-lite-0.4.24.tgz
https://registry.npmjs.org/ieee754/-/ieee754-1.2.1.tgz -> npmpkg-ieee754-1.2.1.tgz
https://registry.npmjs.org/ignore/-/ignore-5.3.2.tgz -> npmpkg-ignore-5.3.2.tgz
https://registry.npmjs.org/immediate/-/immediate-3.0.6.tgz -> npmpkg-immediate-3.0.6.tgz
https://registry.npmjs.org/indent-string/-/indent-string-4.0.0.tgz -> npmpkg-indent-string-4.0.0.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/ini/-/ini-2.0.0.tgz -> npmpkg-ini-2.0.0.tgz
https://registry.npmjs.org/internal-ip/-/internal-ip-7.0.0.tgz -> npmpkg-internal-ip-7.0.0.tgz
https://registry.npmjs.org/ip-regex/-/ip-regex-4.3.0.tgz -> npmpkg-ip-regex-4.3.0.tgz
https://registry.npmjs.org/ipaddr.js/-/ipaddr.js-2.2.0.tgz -> npmpkg-ipaddr.js-2.2.0.tgz
https://registry.npmjs.org/is-any-array/-/is-any-array-2.0.1.tgz -> npmpkg-is-any-array-2.0.1.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz -> npmpkg-is-arrayish-0.2.1.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz -> npmpkg-is-binary-path-2.1.0.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.15.1.tgz -> npmpkg-is-core-module-2.15.1.tgz
https://registry.npmjs.org/is-docker/-/is-docker-2.2.1.tgz -> npmpkg-is-docker-2.2.1.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/is-ip/-/is-ip-3.1.0.tgz -> npmpkg-is-ip-3.1.0.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/is-obj/-/is-obj-2.0.0.tgz -> npmpkg-is-obj-2.0.0.tgz
https://registry.npmjs.org/is-path-cwd/-/is-path-cwd-2.2.0.tgz -> npmpkg-is-path-cwd-2.2.0.tgz
https://registry.npmjs.org/is-path-inside/-/is-path-inside-3.0.3.tgz -> npmpkg-is-path-inside-3.0.3.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-1.1.0.tgz -> npmpkg-is-plain-obj-1.1.0.tgz
https://registry.npmjs.org/is-potential-custom-element-name/-/is-potential-custom-element-name-1.0.1.tgz -> npmpkg-is-potential-custom-element-name-1.0.1.tgz
https://registry.npmjs.org/is-reference/-/is-reference-3.0.3.tgz -> npmpkg-is-reference-3.0.3.tgz
https://registry.npmjs.org/is-stream/-/is-stream-2.0.1.tgz -> npmpkg-is-stream-2.0.1.tgz
https://registry.npmjs.org/is-text-path/-/is-text-path-1.0.1.tgz -> npmpkg-is-text-path-1.0.1.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-2.2.0.tgz -> npmpkg-is-wsl-2.2.0.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/isomorphic-dompurify/-/isomorphic-dompurify-1.13.0.tgz -> npmpkg-isomorphic-dompurify-1.13.0.tgz
https://registry.npmjs.org/jackspeak/-/jackspeak-3.4.3.tgz -> npmpkg-jackspeak-3.4.3.tgz
https://registry.npmjs.org/jiti/-/jiti-1.21.6.tgz -> npmpkg-jiti-1.21.6.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz -> npmpkg-js-tokens-4.0.0.tgz
https://registry.npmjs.org/jsdom/-/jsdom-23.2.0.tgz -> npmpkg-jsdom-23.2.0.tgz
https://registry.npmjs.org/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz -> npmpkg-json-parse-better-errors-1.0.2.tgz
https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz -> npmpkg-json-parse-even-better-errors-2.3.1.tgz
https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> npmpkg-json-stringify-safe-5.0.1.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/jsonparse/-/jsonparse-1.3.1.tgz -> npmpkg-jsonparse-1.3.1.tgz
https://registry.npmjs.org/JSONStream/-/JSONStream-1.3.5.tgz -> npmpkg-JSONStream-1.3.5.tgz
https://registry.npmjs.org/jszip/-/jszip-3.10.1.tgz -> npmpkg-jszip-3.10.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/kleur/-/kleur-4.1.5.tgz -> npmpkg-kleur-4.1.5.tgz
https://registry.npmjs.org/libsodium-sumo/-/libsodium-sumo-0.7.15.tgz -> npmpkg-libsodium-sumo-0.7.15.tgz
https://registry.npmjs.org/libsodium-wrappers-sumo/-/libsodium-wrappers-sumo-0.7.15.tgz -> npmpkg-libsodium-wrappers-sumo-0.7.15.tgz
https://registry.npmjs.org/lie/-/lie-3.3.0.tgz -> npmpkg-lie-3.3.0.tgz
https://registry.npmjs.org/lil-gui/-/lil-gui-0.17.0.tgz -> npmpkg-lil-gui-0.17.0.tgz
https://registry.npmjs.org/lilconfig/-/lilconfig-2.1.0.tgz -> npmpkg-lilconfig-2.1.0.tgz
https://registry.npmjs.org/lines-and-columns/-/lines-and-columns-1.2.4.tgz -> npmpkg-lines-and-columns-1.2.4.tgz
https://registry.npmjs.org/linkify-it/-/linkify-it-5.0.0.tgz -> npmpkg-linkify-it-5.0.0.tgz
https://registry.npmjs.org/load-json-file/-/load-json-file-4.0.0.tgz -> npmpkg-load-json-file-4.0.0.tgz
https://registry.npmjs.org/pify/-/pify-3.0.0.tgz -> npmpkg-pify-3.0.0.tgz
https://registry.npmjs.org/localforage/-/localforage-1.10.0.tgz -> npmpkg-localforage-1.10.0.tgz
https://registry.npmjs.org/lie/-/lie-3.1.1.tgz -> npmpkg-lie-3.1.1.tgz
https://registry.npmjs.org/locate-character/-/locate-character-3.0.0.tgz -> npmpkg-locate-character-3.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-2.0.0.tgz -> npmpkg-locate-path-2.0.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lodash.castarray/-/lodash.castarray-4.4.0.tgz -> npmpkg-lodash.castarray-4.4.0.tgz
https://registry.npmjs.org/lodash.ismatch/-/lodash.ismatch-4.4.0.tgz -> npmpkg-lodash.ismatch-4.4.0.tgz
https://registry.npmjs.org/lodash.isplainobject/-/lodash.isplainobject-4.0.6.tgz -> npmpkg-lodash.isplainobject-4.0.6.tgz
https://registry.npmjs.org/lodash.merge/-/lodash.merge-4.6.2.tgz -> npmpkg-lodash.merge-4.6.2.tgz
https://registry.npmjs.org/long/-/long-4.0.0.tgz -> npmpkg-long-4.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/lucide-svelte/-/lucide-svelte-0.292.0.tgz -> npmpkg-lucide-svelte-0.292.0.tgz
https://registry.npmjs.org/magic-string/-/magic-string-0.30.13.tgz -> npmpkg-magic-string-0.30.13.tgz
https://registry.npmjs.org/make-error/-/make-error-1.3.6.tgz -> npmpkg-make-error-1.3.6.tgz
https://registry.npmjs.org/map-obj/-/map-obj-4.3.0.tgz -> npmpkg-map-obj-4.3.0.tgz
https://registry.npmjs.org/markdown-it/-/markdown-it-14.1.0.tgz -> npmpkg-markdown-it-14.1.0.tgz
https://registry.npmjs.org/mdn-data/-/mdn-data-2.0.30.tgz -> npmpkg-mdn-data-2.0.30.tgz
https://registry.npmjs.org/mdurl/-/mdurl-2.0.0.tgz -> npmpkg-mdurl-2.0.0.tgz
https://registry.npmjs.org/media-typer/-/media-typer-0.3.0.tgz -> npmpkg-media-typer-0.3.0.tgz
https://registry.npmjs.org/meow/-/meow-8.1.2.tgz -> npmpkg-meow-8.1.2.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> npmpkg-hosted-git-info-2.8.9.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-5.2.0.tgz -> npmpkg-read-pkg-5.2.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-7.0.1.tgz -> npmpkg-read-pkg-up-7.0.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.8.1.tgz -> npmpkg-type-fest-0.8.1.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-2.5.0.tgz -> npmpkg-normalize-package-data-2.5.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.6.0.tgz -> npmpkg-type-fest-0.6.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/merge-descriptors/-/merge-descriptors-1.0.3.tgz -> npmpkg-merge-descriptors-1.0.3.tgz
https://registry.npmjs.org/merge-stream/-/merge-stream-2.0.0.tgz -> npmpkg-merge-stream-2.0.0.tgz
https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz -> npmpkg-merge2-1.4.1.tgz
https://registry.npmjs.org/mergexml/-/mergexml-1.2.4.tgz -> npmpkg-mergexml-1.2.4.tgz
https://registry.npmjs.org/xpath/-/xpath-0.0.27.tgz -> npmpkg-xpath-0.0.27.tgz
https://registry.npmjs.org/meshoptimizer/-/meshoptimizer-0.18.1.tgz -> npmpkg-meshoptimizer-0.18.1.tgz
https://registry.npmjs.org/methods/-/methods-1.1.2.tgz -> npmpkg-methods-1.1.2.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.8.tgz -> npmpkg-micromatch-4.0.8.tgz
https://registry.npmjs.org/mime/-/mime-1.6.0.tgz -> npmpkg-mime-1.6.0.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.52.0.tgz -> npmpkg-mime-db-1.52.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.35.tgz -> npmpkg-mime-types-2.1.35.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-2.1.0.tgz -> npmpkg-mimic-fn-2.1.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-2.1.0.tgz -> npmpkg-mimic-response-2.1.0.tgz
https://registry.npmjs.org/min-indent/-/min-indent-1.0.1.tgz -> npmpkg-min-indent-1.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.0.5.tgz -> npmpkg-minimatch-3.0.5.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/minimist-options/-/minimist-options-4.1.0.tgz -> npmpkg-minimist-options-4.1.0.tgz
https://registry.npmjs.org/minipass/-/minipass-4.2.8.tgz -> npmpkg-minipass-4.2.8.tgz
https://registry.npmjs.org/minizlib/-/minizlib-2.1.2.tgz -> npmpkg-minizlib-2.1.2.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-1.0.4.tgz -> npmpkg-mkdirp-1.0.4.tgz
https://registry.npmjs.org/mkdirp-classic/-/mkdirp-classic-0.5.3.tgz -> npmpkg-mkdirp-classic-0.5.3.tgz
https://registry.npmjs.org/ml-array-mean/-/ml-array-mean-1.1.6.tgz -> npmpkg-ml-array-mean-1.1.6.tgz
https://registry.npmjs.org/ml-array-sum/-/ml-array-sum-1.1.6.tgz -> npmpkg-ml-array-sum-1.1.6.tgz
https://registry.npmjs.org/ml-distance/-/ml-distance-4.0.1.tgz -> npmpkg-ml-distance-4.0.1.tgz
https://registry.npmjs.org/ml-distance-euclidean/-/ml-distance-euclidean-2.0.0.tgz -> npmpkg-ml-distance-euclidean-2.0.0.tgz
https://registry.npmjs.org/ml-tree-similarity/-/ml-tree-similarity-1.0.0.tgz -> npmpkg-ml-tree-similarity-1.0.0.tgz
https://registry.npmjs.org/mobile-drag-drop/-/mobile-drag-drop-3.0.0-rc.0.tgz -> npmpkg-mobile-drag-drop-3.0.0-rc.0.tgz
https://registry.npmjs.org/modify-values/-/modify-values-1.0.1.tgz -> npmpkg-modify-values-1.0.1.tgz
https://registry.npmjs.org/mri/-/mri-1.2.0.tgz -> npmpkg-mri-1.2.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/msgpackr/-/msgpackr-1.10.1.tgz -> npmpkg-msgpackr-1.10.1.tgz
https://registry.npmjs.org/msgpackr-extract/-/msgpackr-extract-3.0.3.tgz -> npmpkg-msgpackr-extract-3.0.3.tgz
https://registry.npmjs.org/mz/-/mz-2.7.0.tgz -> npmpkg-mz-2.7.0.tgz
https://registry.npmjs.org/nanoid/-/nanoid-3.3.7.tgz -> npmpkg-nanoid-3.3.7.tgz
https://registry.npmjs.org/napi-build-utils/-/napi-build-utils-1.0.2.tgz -> npmpkg-napi-build-utils-1.0.2.tgz
https://registry.npmjs.org/native-run/-/native-run-2.0.1.tgz -> npmpkg-native-run-2.0.1.tgz
https://registry.npmjs.org/ini/-/ini-4.1.3.tgz -> npmpkg-ini-4.1.3.tgz
https://registry.npmjs.org/split2/-/split2-4.2.0.tgz -> npmpkg-split2-4.2.0.tgz
https://registry.npmjs.org/negotiator/-/negotiator-0.6.3.tgz -> npmpkg-negotiator-0.6.3.tgz
https://registry.npmjs.org/neo-async/-/neo-async-2.6.2.tgz -> npmpkg-neo-async-2.6.2.tgz
https://registry.npmjs.org/node-abi/-/node-abi-3.71.0.tgz -> npmpkg-node-abi-3.71.0.tgz
https://registry.npmjs.org/node-addon-api/-/node-addon-api-7.1.1.tgz -> npmpkg-node-addon-api-7.1.1.tgz
https://registry.npmjs.org/node-fetch/-/node-fetch-2.7.0.tgz -> npmpkg-node-fetch-2.7.0.tgz
https://registry.npmjs.org/tr46/-/tr46-0.0.3.tgz -> npmpkg-tr46-0.0.3.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-3.0.1.tgz -> npmpkg-webidl-conversions-3.0.1.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-5.0.0.tgz -> npmpkg-whatwg-url-5.0.0.tgz
https://registry.npmjs.org/node-gyp-build-optional-packages/-/node-gyp-build-optional-packages-5.2.2.tgz -> npmpkg-node-gyp-build-optional-packages-5.2.2.tgz
https://registry.npmjs.org/node-html-parser/-/node-html-parser-6.1.13.tgz -> npmpkg-node-html-parser-6.1.13.tgz
https://registry.npmjs.org/node-releases/-/node-releases-2.0.18.tgz -> npmpkg-node-releases-2.0.18.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-3.0.3.tgz -> npmpkg-normalize-package-data-3.0.3.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/normalize-range/-/normalize-range-0.1.2.tgz -> npmpkg-normalize-range-0.1.2.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-4.0.1.tgz -> npmpkg-npm-run-path-4.0.1.tgz
https://registry.npmjs.org/nth-check/-/nth-check-2.1.1.tgz -> npmpkg-nth-check-2.1.1.tgz
https://registry.npmjs.org/num-sort/-/num-sort-2.1.0.tgz -> npmpkg-num-sort-2.1.0.tgz
https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz -> npmpkg-object-assign-4.1.1.tgz
https://registry.npmjs.org/object-hash/-/object-hash-3.0.0.tgz -> npmpkg-object-hash-3.0.0.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.13.3.tgz -> npmpkg-object-inspect-1.13.3.tgz
https://registry.npmjs.org/ollama/-/ollama-0.5.10.tgz -> npmpkg-ollama-0.5.10.tgz
https://registry.npmjs.org/on-finished/-/on-finished-2.4.1.tgz -> npmpkg-on-finished-2.4.1.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/onetime/-/onetime-5.1.2.tgz -> npmpkg-onetime-5.1.2.tgz
https://registry.npmjs.org/onnx-proto/-/onnx-proto-4.0.4.tgz -> npmpkg-onnx-proto-4.0.4.tgz
https://registry.npmjs.org/onnxruntime-common/-/onnxruntime-common-1.14.0.tgz -> npmpkg-onnxruntime-common-1.14.0.tgz
https://registry.npmjs.org/onnxruntime-node/-/onnxruntime-node-1.14.0.tgz -> npmpkg-onnxruntime-node-1.14.0.tgz
https://registry.npmjs.org/onnxruntime-web/-/onnxruntime-web-1.14.0.tgz -> npmpkg-onnxruntime-web-1.14.0.tgz
https://registry.npmjs.org/open/-/open-8.4.2.tgz -> npmpkg-open-8.4.2.tgz
https://registry.npmjs.org/p-event/-/p-event-4.2.0.tgz -> npmpkg-p-event-4.2.0.tgz
https://registry.npmjs.org/p-finally/-/p-finally-1.0.0.tgz -> npmpkg-p-finally-1.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-1.3.0.tgz -> npmpkg-p-limit-1.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-2.0.0.tgz -> npmpkg-p-locate-2.0.0.tgz
https://registry.npmjs.org/p-map/-/p-map-4.0.0.tgz -> npmpkg-p-map-4.0.0.tgz
https://registry.npmjs.org/p-timeout/-/p-timeout-3.2.0.tgz -> npmpkg-p-timeout-3.2.0.tgz
https://registry.npmjs.org/p-try/-/p-try-1.0.0.tgz -> npmpkg-p-try-1.0.0.tgz
https://registry.npmjs.org/package-json-from-dist/-/package-json-from-dist-1.0.1.tgz -> npmpkg-package-json-from-dist-1.0.1.tgz
https://registry.npmjs.org/pako/-/pako-1.0.11.tgz -> npmpkg-pako-1.0.11.tgz
https://registry.npmjs.org/parse-json/-/parse-json-4.0.0.tgz -> npmpkg-parse-json-4.0.0.tgz
https://registry.npmjs.org/parse5/-/parse5-7.2.1.tgz -> npmpkg-parse5-7.2.1.tgz
https://registry.npmjs.org/parseurl/-/parseurl-1.3.3.tgz -> npmpkg-parseurl-1.3.3.tgz
https://registry.npmjs.org/path-exists/-/path-exists-3.0.0.tgz -> npmpkg-path-exists-3.0.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-scurry/-/path-scurry-1.11.1.tgz -> npmpkg-path-scurry-1.11.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-10.4.3.tgz -> npmpkg-lru-cache-10.4.3.tgz
https://registry.npmjs.org/minipass/-/minipass-7.1.2.tgz -> npmpkg-minipass-7.1.2.tgz
https://registry.npmjs.org/path-to-regexp/-/path-to-regexp-0.1.10.tgz -> npmpkg-path-to-regexp-0.1.10.tgz
https://registry.npmjs.org/path-type/-/path-type-3.0.0.tgz -> npmpkg-path-type-3.0.0.tgz
https://registry.npmjs.org/pify/-/pify-3.0.0.tgz -> npmpkg-pify-3.0.0.tgz
https://registry.npmjs.org/path2d/-/path2d-0.2.2.tgz -> npmpkg-path2d-0.2.2.tgz
https://registry.npmjs.org/pdfjs-dist/-/pdfjs-dist-4.8.69.tgz -> npmpkg-pdfjs-dist-4.8.69.tgz
https://registry.npmjs.org/peerjs/-/peerjs-1.5.4.tgz -> npmpkg-peerjs-1.5.4.tgz
https://registry.npmjs.org/peerjs-js-binarypack/-/peerjs-js-binarypack-2.1.0.tgz -> npmpkg-peerjs-js-binarypack-2.1.0.tgz
https://registry.npmjs.org/pend/-/pend-1.2.0.tgz -> npmpkg-pend-1.2.0.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.1.1.tgz -> npmpkg-picocolors-1.1.1.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/pify/-/pify-2.3.0.tgz -> npmpkg-pify-2.3.0.tgz
https://registry.npmjs.org/pirates/-/pirates-4.0.6.tgz -> npmpkg-pirates-4.0.6.tgz
https://registry.npmjs.org/platform/-/platform-1.3.6.tgz -> npmpkg-platform-1.3.6.tgz
https://registry.npmjs.org/plist/-/plist-3.1.0.tgz -> npmpkg-plist-3.1.0.tgz
https://registry.npmjs.org/@xmldom/xmldom/-/xmldom-0.8.10.tgz -> npmpkg-@xmldom-xmldom-0.8.10.tgz
https://registry.npmjs.org/png-chunk-text/-/png-chunk-text-1.0.0.tgz -> npmpkg-png-chunk-text-1.0.0.tgz
https://registry.npmjs.org/png-chunks-encode/-/png-chunks-encode-1.0.0.tgz -> npmpkg-png-chunks-encode-1.0.0.tgz
https://registry.npmjs.org/png-chunks-extract/-/png-chunks-extract-1.0.0.tgz -> npmpkg-png-chunks-extract-1.0.0.tgz
https://registry.npmjs.org/postcss/-/postcss-8.4.49.tgz -> npmpkg-postcss-8.4.49.tgz
https://registry.npmjs.org/postcss-import/-/postcss-import-15.1.0.tgz -> npmpkg-postcss-import-15.1.0.tgz
https://registry.npmjs.org/postcss-js/-/postcss-js-4.0.1.tgz -> npmpkg-postcss-js-4.0.1.tgz
https://registry.npmjs.org/postcss-load-config/-/postcss-load-config-4.0.2.tgz -> npmpkg-postcss-load-config-4.0.2.tgz
https://registry.npmjs.org/lilconfig/-/lilconfig-3.1.2.tgz -> npmpkg-lilconfig-3.1.2.tgz
https://registry.npmjs.org/postcss-nested/-/postcss-nested-6.2.0.tgz -> npmpkg-postcss-nested-6.2.0.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-6.1.2.tgz -> npmpkg-postcss-selector-parser-6.1.2.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-6.0.10.tgz -> npmpkg-postcss-selector-parser-6.0.10.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-4.2.0.tgz -> npmpkg-postcss-value-parser-4.2.0.tgz
https://registry.npmjs.org/prebuild-install/-/prebuild-install-7.1.2.tgz -> npmpkg-prebuild-install-7.1.2.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-6.0.0.tgz -> npmpkg-decompress-response-6.0.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-3.1.0.tgz -> npmpkg-mimic-response-3.1.0.tgz
https://registry.npmjs.org/simple-get/-/simple-get-4.0.1.tgz -> npmpkg-simple-get-4.0.1.tgz
https://registry.npmjs.org/prettier/-/prettier-2.8.8.tgz -> npmpkg-prettier-2.8.8.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> npmpkg-process-nextick-args-2.0.1.tgz
https://registry.npmjs.org/prompts/-/prompts-2.4.2.tgz -> npmpkg-prompts-2.4.2.tgz
https://registry.npmjs.org/kleur/-/kleur-3.0.3.tgz -> npmpkg-kleur-3.0.3.tgz
https://registry.npmjs.org/protobufjs/-/protobufjs-6.11.4.tgz -> npmpkg-protobufjs-6.11.4.tgz
https://registry.npmjs.org/proxy-addr/-/proxy-addr-2.0.7.tgz -> npmpkg-proxy-addr-2.0.7.tgz
https://registry.npmjs.org/ipaddr.js/-/ipaddr.js-1.9.1.tgz -> npmpkg-ipaddr.js-1.9.1.tgz
https://registry.npmjs.org/psl/-/psl-1.13.0.tgz -> npmpkg-psl-1.13.0.tgz
https://registry.npmjs.org/pump/-/pump-3.0.2.tgz -> npmpkg-pump-3.0.2.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz -> npmpkg-punycode-2.3.1.tgz
https://registry.npmjs.org/punycode.js/-/punycode.js-2.3.1.tgz -> npmpkg-punycode.js-2.3.1.tgz
https://registry.npmjs.org/q/-/q-1.5.1.tgz -> npmpkg-q-1.5.1.tgz
https://registry.npmjs.org/qs/-/qs-6.13.0.tgz -> npmpkg-qs-6.13.0.tgz
https://registry.npmjs.org/querystringify/-/querystringify-2.2.0.tgz -> npmpkg-querystringify-2.2.0.tgz
https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz -> npmpkg-queue-microtask-1.2.3.tgz
https://registry.npmjs.org/queue-tick/-/queue-tick-1.0.1.tgz -> npmpkg-queue-tick-1.0.1.tgz
https://registry.npmjs.org/quick-lru/-/quick-lru-4.0.1.tgz -> npmpkg-quick-lru-4.0.1.tgz
https://registry.npmjs.org/range-parser/-/range-parser-1.2.1.tgz -> npmpkg-range-parser-1.2.1.tgz
https://registry.npmjs.org/raw-body/-/raw-body-2.5.2.tgz -> npmpkg-raw-body-2.5.2.tgz
https://registry.npmjs.org/rc/-/rc-1.2.8.tgz -> npmpkg-rc-1.2.8.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/read-cache/-/read-cache-1.0.0.tgz -> npmpkg-read-cache-1.0.0.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-3.0.0.tgz -> npmpkg-read-pkg-3.0.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-3.0.0.tgz -> npmpkg-read-pkg-up-3.0.0.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> npmpkg-hosted-git-info-2.8.9.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-2.5.0.tgz -> npmpkg-normalize-package-data-2.5.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/readdirp/-/readdirp-4.0.2.tgz -> npmpkg-readdirp-4.0.2.tgz
https://registry.npmjs.org/redent/-/redent-3.0.0.tgz -> npmpkg-redent-3.0.0.tgz
https://registry.npmjs.org/regexp-to-ast/-/regexp-to-ast-0.5.0.tgz -> npmpkg-regexp-to-ast-0.5.0.tgz
https://registry.npmjs.org/replace/-/replace-1.2.2.tgz -> npmpkg-replace-1.2.2.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/cliui/-/cliui-6.0.0.tgz -> npmpkg-cliui-6.0.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-6.2.0.tgz -> npmpkg-wrap-ansi-6.2.0.tgz
https://registry.npmjs.org/y18n/-/y18n-4.0.3.tgz -> npmpkg-y18n-4.0.3.tgz
https://registry.npmjs.org/yargs/-/yargs-15.4.1.tgz -> npmpkg-yargs-15.4.1.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-18.1.3.tgz -> npmpkg-yargs-parser-18.1.3.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/require-from-string/-/require-from-string-2.0.2.tgz -> npmpkg-require-from-string-2.0.2.tgz
https://registry.npmjs.org/require-main-filename/-/require-main-filename-2.0.0.tgz -> npmpkg-require-main-filename-2.0.0.tgz
https://registry.npmjs.org/requires-port/-/requires-port-1.0.0.tgz -> npmpkg-requires-port-1.0.0.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.8.tgz -> npmpkg-resolve-1.22.8.tgz
https://registry.npmjs.org/reusify/-/reusify-1.0.4.tgz -> npmpkg-reusify-1.0.4.tgz
https://registry.npmjs.org/rfdc/-/rfdc-1.4.1.tgz -> npmpkg-rfdc-1.4.1.tgz
https://registry.npmjs.org/rimraf/-/rimraf-4.4.1.tgz -> npmpkg-rimraf-4.4.1.tgz
https://registry.npmjs.org/rollup/-/rollup-3.29.5.tgz -> npmpkg-rollup-3.29.5.tgz
https://registry.npmjs.org/rrweb-cssom/-/rrweb-cssom-0.6.0.tgz -> npmpkg-rrweb-cssom-0.6.0.tgz
https://registry.npmjs.org/run-parallel/-/run-parallel-1.2.0.tgz -> npmpkg-run-parallel-1.2.0.tgz
https://registry.npmjs.org/sade/-/sade-1.8.1.tgz -> npmpkg-sade-1.8.1.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz -> npmpkg-safer-buffer-2.1.2.tgz
https://registry.npmjs.org/sax/-/sax-1.1.4.tgz -> npmpkg-sax-1.1.4.tgz
https://registry.npmjs.org/saxes/-/saxes-6.0.0.tgz -> npmpkg-saxes-6.0.0.tgz
https://registry.npmjs.org/sdp/-/sdp-3.2.0.tgz -> npmpkg-sdp-3.2.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/send/-/send-0.19.0.tgz -> npmpkg-send-0.19.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/encodeurl/-/encodeurl-1.0.2.tgz -> npmpkg-encodeurl-1.0.2.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/serve-static/-/serve-static-1.16.2.tgz -> npmpkg-serve-static-1.16.2.tgz
https://registry.npmjs.org/set-blocking/-/set-blocking-2.0.0.tgz -> npmpkg-set-blocking-2.0.0.tgz
https://registry.npmjs.org/set-function-length/-/set-function-length-1.2.2.tgz -> npmpkg-set-function-length-1.2.2.tgz
https://registry.npmjs.org/setimmediate/-/setimmediate-1.0.5.tgz -> npmpkg-setimmediate-1.0.5.tgz
https://registry.npmjs.org/setprototypeof/-/setprototypeof-1.2.0.tgz -> npmpkg-setprototypeof-1.2.0.tgz
https://registry.npmjs.org/sharp/-/sharp-0.32.6.tgz -> npmpkg-sharp-0.32.6.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-6.0.0.tgz -> npmpkg-decompress-response-6.0.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-3.1.0.tgz -> npmpkg-mimic-response-3.1.0.tgz
https://registry.npmjs.org/node-addon-api/-/node-addon-api-6.1.0.tgz -> npmpkg-node-addon-api-6.1.0.tgz
https://registry.npmjs.org/simple-get/-/simple-get-4.0.1.tgz -> npmpkg-simple-get-4.0.1.tgz
https://registry.npmjs.org/tar-fs/-/tar-fs-3.0.6.tgz -> npmpkg-tar-fs-3.0.6.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-3.1.7.tgz -> npmpkg-tar-stream-3.1.7.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/showdown/-/showdown-2.1.0.tgz -> npmpkg-showdown-2.1.0.tgz
https://registry.npmjs.org/commander/-/commander-9.5.0.tgz -> npmpkg-commander-9.5.0.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.6.tgz -> npmpkg-side-channel-1.0.6.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.7.tgz -> npmpkg-signal-exit-3.0.7.tgz
https://registry.npmjs.org/simple-concat/-/simple-concat-1.0.1.tgz -> npmpkg-simple-concat-1.0.1.tgz
https://registry.npmjs.org/simple-get/-/simple-get-3.1.1.tgz -> npmpkg-simple-get-3.1.1.tgz
https://registry.npmjs.org/simple-plist/-/simple-plist-1.3.1.tgz -> npmpkg-simple-plist-1.3.1.tgz
https://registry.npmjs.org/bplist-parser/-/bplist-parser-0.3.1.tgz -> npmpkg-bplist-parser-0.3.1.tgz
https://registry.npmjs.org/simple-swizzle/-/simple-swizzle-0.2.2.tgz -> npmpkg-simple-swizzle-0.2.2.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.3.2.tgz -> npmpkg-is-arrayish-0.3.2.tgz
https://registry.npmjs.org/sisteransi/-/sisteransi-1.0.5.tgz -> npmpkg-sisteransi-1.0.5.tgz
https://registry.npmjs.org/slash/-/slash-3.0.0.tgz -> npmpkg-slash-3.0.0.tgz
https://registry.npmjs.org/slice-ansi/-/slice-ansi-4.0.0.tgz -> npmpkg-slice-ansi-4.0.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/sliced/-/sliced-1.0.1.tgz -> npmpkg-sliced-1.0.1.tgz
https://registry.npmjs.org/sortablejs/-/sortablejs-1.15.4.tgz -> npmpkg-sortablejs-1.15.4.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/source-map-js/-/source-map-js-1.2.1.tgz -> npmpkg-source-map-js-1.2.1.tgz
https://registry.npmjs.org/spdx-correct/-/spdx-correct-3.2.0.tgz -> npmpkg-spdx-correct-3.2.0.tgz
https://registry.npmjs.org/spdx-exceptions/-/spdx-exceptions-2.5.0.tgz -> npmpkg-spdx-exceptions-2.5.0.tgz
https://registry.npmjs.org/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> npmpkg-spdx-expression-parse-3.0.1.tgz
https://registry.npmjs.org/spdx-license-ids/-/spdx-license-ids-3.0.20.tgz -> npmpkg-spdx-license-ids-3.0.20.tgz
https://registry.npmjs.org/split/-/split-1.0.1.tgz -> npmpkg-split-1.0.1.tgz
https://registry.npmjs.org/split2/-/split2-3.2.2.tgz -> npmpkg-split2-3.2.2.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/statuses/-/statuses-2.0.1.tgz -> npmpkg-statuses-2.0.1.tgz
https://registry.npmjs.org/stream-buffers/-/stream-buffers-2.2.0.tgz -> npmpkg-stream-buffers-2.2.0.tgz
https://registry.npmjs.org/streamsaver/-/streamsaver-2.0.6.tgz -> npmpkg-streamsaver-2.0.6.tgz
https://registry.npmjs.org/streamx/-/streamx-2.20.2.tgz -> npmpkg-streamx-2.20.2.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz -> npmpkg-strip-bom-3.0.0.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-2.0.0.tgz -> npmpkg-strip-final-newline-2.0.0.tgz
https://registry.npmjs.org/strip-indent/-/strip-indent-3.0.0.tgz -> npmpkg-strip-indent-3.0.0.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-2.0.1.tgz -> npmpkg-strip-json-comments-2.0.1.tgz
https://registry.npmjs.org/sucrase/-/sucrase-3.35.0.tgz -> npmpkg-sucrase-3.35.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/commander/-/commander-4.1.1.tgz -> npmpkg-commander-4.1.1.tgz
https://registry.npmjs.org/glob/-/glob-10.4.5.tgz -> npmpkg-glob-10.4.5.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.5.tgz -> npmpkg-minimatch-9.0.5.tgz
https://registry.npmjs.org/minipass/-/minipass-7.1.2.tgz -> npmpkg-minipass-7.1.2.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> npmpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.npmjs.org/svelte/-/svelte-5.2.7.tgz -> npmpkg-svelte-5.2.7.tgz
https://registry.npmjs.org/svelte-awesome-color-picker/-/svelte-awesome-color-picker-3.1.4.tgz -> npmpkg-svelte-awesome-color-picker-3.1.4.tgz
https://registry.npmjs.org/svelte-awesome-slider/-/svelte-awesome-slider-1.1.2.tgz -> npmpkg-svelte-awesome-slider-1.1.2.tgz
https://registry.npmjs.org/svelte-check/-/svelte-check-4.1.0.tgz -> npmpkg-svelte-check-4.1.0.tgz
https://registry.npmjs.org/svelte-preprocess/-/svelte-preprocess-6.0.3.tgz -> npmpkg-svelte-preprocess-6.0.3.tgz
https://registry.npmjs.org/symbol-tree/-/symbol-tree-3.2.4.tgz -> npmpkg-symbol-tree-3.2.4.tgz
https://registry.npmjs.org/tailwindcss/-/tailwindcss-3.4.15.tgz -> npmpkg-tailwindcss-3.4.15.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.6.0.tgz -> npmpkg-chokidar-3.6.0.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-6.1.2.tgz -> npmpkg-postcss-selector-parser-6.1.2.tgz
https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz -> npmpkg-readdirp-3.6.0.tgz
https://registry.npmjs.org/tar/-/tar-6.2.1.tgz -> npmpkg-tar-6.2.1.tgz
https://registry.npmjs.org/tar-fs/-/tar-fs-2.1.1.tgz -> npmpkg-tar-fs-2.1.1.tgz
https://registry.npmjs.org/chownr/-/chownr-1.1.4.tgz -> npmpkg-chownr-1.1.4.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-2.2.0.tgz -> npmpkg-tar-stream-2.2.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/minipass/-/minipass-5.0.0.tgz -> npmpkg-minipass-5.0.0.tgz
https://registry.npmjs.org/temp-dir/-/temp-dir-2.0.0.tgz -> npmpkg-temp-dir-2.0.0.tgz
https://registry.npmjs.org/tempy/-/tempy-1.0.1.tgz -> npmpkg-tempy-1.0.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.16.0.tgz -> npmpkg-type-fest-0.16.0.tgz
https://registry.npmjs.org/text-decoder/-/text-decoder-1.2.1.tgz -> npmpkg-text-decoder-1.2.1.tgz
https://registry.npmjs.org/text-extensions/-/text-extensions-1.9.0.tgz -> npmpkg-text-extensions-1.9.0.tgz
https://registry.npmjs.org/thenify/-/thenify-3.3.1.tgz -> npmpkg-thenify-3.3.1.tgz
https://registry.npmjs.org/thenify-all/-/thenify-all-1.6.0.tgz -> npmpkg-thenify-all-1.6.0.tgz
https://registry.npmjs.org/three/-/three-0.154.0.tgz -> npmpkg-three-0.154.0.tgz
https://registry.npmjs.org/through/-/through-2.3.8.tgz -> npmpkg-through-2.3.8.tgz
https://registry.npmjs.org/through2/-/through2-4.0.2.tgz -> npmpkg-through2-4.0.2.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/tippy.js/-/tippy.js-6.3.7.tgz -> npmpkg-tippy.js-6.3.7.tgz
https://registry.npmjs.org/tmp/-/tmp-0.2.3.tgz -> npmpkg-tmp-0.2.3.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/toidentifier/-/toidentifier-1.0.1.tgz -> npmpkg-toidentifier-1.0.1.tgz
https://registry.npmjs.org/tough-cookie/-/tough-cookie-4.1.4.tgz -> npmpkg-tough-cookie-4.1.4.tgz
https://registry.npmjs.org/universalify/-/universalify-0.2.0.tgz -> npmpkg-universalify-0.2.0.tgz
https://registry.npmjs.org/tr46/-/tr46-5.0.0.tgz -> npmpkg-tr46-5.0.0.tgz
https://registry.npmjs.org/tree-kill/-/tree-kill-1.2.2.tgz -> npmpkg-tree-kill-1.2.2.tgz
https://registry.npmjs.org/trim-newlines/-/trim-newlines-3.0.1.tgz -> npmpkg-trim-newlines-3.0.1.tgz
https://registry.npmjs.org/ts-interface-checker/-/ts-interface-checker-0.1.13.tgz -> npmpkg-ts-interface-checker-0.1.13.tgz
https://registry.npmjs.org/ts-node/-/ts-node-10.9.2.tgz -> npmpkg-ts-node-10.9.2.tgz
https://registry.npmjs.org/arg/-/arg-4.1.3.tgz -> npmpkg-arg-4.1.3.tgz
https://registry.npmjs.org/diff/-/diff-4.0.2.tgz -> npmpkg-diff-4.0.2.tgz
https://registry.npmjs.org/tslib/-/tslib-2.8.1.tgz -> npmpkg-tslib-2.8.1.tgz
https://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.6.0.tgz -> npmpkg-tunnel-agent-0.6.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.18.1.tgz -> npmpkg-type-fest-0.18.1.tgz
https://registry.npmjs.org/type-is/-/type-is-1.6.18.tgz -> npmpkg-type-is-1.6.18.tgz
https://registry.npmjs.org/typescript/-/typescript-5.7.2.tgz -> npmpkg-typescript-5.7.2.tgz
https://registry.npmjs.org/uc.micro/-/uc.micro-2.1.0.tgz -> npmpkg-uc.micro-2.1.0.tgz
https://registry.npmjs.org/uglify-js/-/uglify-js-3.19.3.tgz -> npmpkg-uglify-js-3.19.3.tgz
https://registry.npmjs.org/undici-types/-/undici-types-5.26.5.tgz -> npmpkg-undici-types-5.26.5.tgz
https://registry.npmjs.org/unique-string/-/unique-string-2.0.0.tgz -> npmpkg-unique-string-2.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/unpipe/-/unpipe-1.0.0.tgz -> npmpkg-unpipe-1.0.0.tgz
https://registry.npmjs.org/untildify/-/untildify-4.0.0.tgz -> npmpkg-untildify-4.0.0.tgz
https://registry.npmjs.org/update-browserslist-db/-/update-browserslist-db-1.1.1.tgz -> npmpkg-update-browserslist-db-1.1.1.tgz
https://registry.npmjs.org/url-parse/-/url-parse-1.5.10.tgz -> npmpkg-url-parse-1.5.10.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/utils-merge/-/utils-merge-1.0.1.tgz -> npmpkg-utils-merge-1.0.1.tgz
https://registry.npmjs.org/uuid/-/uuid-9.0.1.tgz -> npmpkg-uuid-9.0.1.tgz
https://registry.npmjs.org/v8-compile-cache-lib/-/v8-compile-cache-lib-3.0.1.tgz -> npmpkg-v8-compile-cache-lib-3.0.1.tgz
https://registry.npmjs.org/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> npmpkg-validate-npm-package-license-3.0.4.tgz
https://registry.npmjs.org/vary/-/vary-1.1.2.tgz -> npmpkg-vary-1.1.2.tgz
https://registry.npmjs.org/vite/-/vite-5.4.9.tgz -> npmpkg-vite-5.4.9.tgz
https://registry.npmjs.org/vite-plugin-top-level-await/-/vite-plugin-top-level-await-1.4.1.tgz -> npmpkg-vite-plugin-top-level-await-1.4.1.tgz
https://registry.npmjs.org/vite-plugin-wasm/-/vite-plugin-wasm-3.3.0.tgz -> npmpkg-vite-plugin-wasm-3.3.0.tgz
https://registry.npmjs.org/rollup/-/rollup-4.27.4.tgz -> npmpkg-rollup-4.27.4.tgz
https://registry.npmjs.org/vitefu/-/vitefu-1.0.3.tgz -> npmpkg-vitefu-1.0.3.tgz
https://registry.npmjs.org/w3c-xmlserializer/-/w3c-xmlserializer-5.0.0.tgz -> npmpkg-w3c-xmlserializer-5.0.0.tgz
https://registry.npmjs.org/wasmoon/-/wasmoon-1.16.0.tgz -> npmpkg-wasmoon-1.16.0.tgz
https://registry.npmjs.org/wavefile/-/wavefile-11.0.0.tgz -> npmpkg-wavefile-11.0.0.tgz
https://registry.npmjs.org/web-streams-polyfill/-/web-streams-polyfill-3.3.3.tgz -> npmpkg-web-streams-polyfill-3.3.3.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-7.0.0.tgz -> npmpkg-webidl-conversions-7.0.0.tgz
https://registry.npmjs.org/webrtc-adapter/-/webrtc-adapter-9.0.1.tgz -> npmpkg-webrtc-adapter-9.0.1.tgz
https://registry.npmjs.org/whatwg-encoding/-/whatwg-encoding-3.1.1.tgz -> npmpkg-whatwg-encoding-3.1.1.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz -> npmpkg-iconv-lite-0.6.3.tgz
https://registry.npmjs.org/whatwg-fetch/-/whatwg-fetch-3.6.20.tgz -> npmpkg-whatwg-fetch-3.6.20.tgz
https://registry.npmjs.org/whatwg-mimetype/-/whatwg-mimetype-4.0.0.tgz -> npmpkg-whatwg-mimetype-4.0.0.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-14.0.0.tgz -> npmpkg-whatwg-url-14.0.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/which-module/-/which-module-2.0.1.tgz -> npmpkg-which-module-2.0.1.tgz
https://registry.npmjs.org/wordwrap/-/wordwrap-1.0.0.tgz -> npmpkg-wordwrap-1.0.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/ws/-/ws-8.18.0.tgz -> npmpkg-ws-8.18.0.tgz
https://registry.npmjs.org/xcode/-/xcode-3.0.1.tgz -> npmpkg-xcode-3.0.1.tgz
https://registry.npmjs.org/uuid/-/uuid-7.0.3.tgz -> npmpkg-uuid-7.0.3.tgz
https://registry.npmjs.org/xml-js/-/xml-js-1.6.11.tgz -> npmpkg-xml-js-1.6.11.tgz
https://registry.npmjs.org/sax/-/sax-1.4.1.tgz -> npmpkg-sax-1.4.1.tgz
https://registry.npmjs.org/xml-name-validator/-/xml-name-validator-5.0.0.tgz -> npmpkg-xml-name-validator-5.0.0.tgz
https://registry.npmjs.org/xml2js/-/xml2js-0.5.0.tgz -> npmpkg-xml2js-0.5.0.tgz
https://registry.npmjs.org/xmlbuilder/-/xmlbuilder-11.0.1.tgz -> npmpkg-xmlbuilder-11.0.1.tgz
https://registry.npmjs.org/xmlbuilder/-/xmlbuilder-15.1.1.tgz -> npmpkg-xmlbuilder-15.1.1.tgz
https://registry.npmjs.org/xmlchars/-/xmlchars-2.2.0.tgz -> npmpkg-xmlchars-2.2.0.tgz
https://registry.npmjs.org/xpath/-/xpath-0.0.32.tgz -> npmpkg-xpath-0.0.32.tgz
https://registry.npmjs.org/xtend/-/xtend-4.0.2.tgz -> npmpkg-xtend-4.0.2.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/yaml/-/yaml-2.6.1.tgz -> npmpkg-yaml-2.6.1.tgz
https://registry.npmjs.org/yargs/-/yargs-17.7.2.tgz -> npmpkg-yargs-17.7.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-20.2.9.tgz -> npmpkg-yargs-parser-20.2.9.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-21.1.1.tgz -> npmpkg-yargs-parser-21.1.1.tgz
https://registry.npmjs.org/yauzl/-/yauzl-2.10.0.tgz -> npmpkg-yauzl-2.10.0.tgz
https://registry.npmjs.org/yn/-/yn-3.1.1.tgz -> npmpkg-yn-3.1.1.tgz
https://registry.npmjs.org/zimmerframe/-/zimmerframe-1.1.2.tgz -> npmpkg-zimmerframe-1.1.2.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
S_PROJECT="${WORKDIR}/${P}"
SRC_URI="
$(cargo_crate_uris ${CRATES})
${NPM_EXTERNAL_URIS}
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
ollama tray wayland X
ebuild_revision_1
"
REQUIRED_USE="
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
		(
			=dev-lang/rust-bin-1.82*
			dev-lang/rust-bin:=
		)
		(
			=dev-lang/rust-1.82*
			dev-lang/rust:=
		)
	)
"
RDEPEND+="
	${TAURI_RDEPEND}
	ollama? (
		app-misc/ollama
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
}

npm_unpack_post() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		enpm install -D "vite@${VITE_PV}" ${NPM_INSTALL_ARGS}
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
		"${S}" \
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
			"${FILESDIR}/${PV}/Cargo.toml" \
			"${FILESDIR}/${PV}/Cargo.lock" \
			"${S}" \
			|| die
	fi
	_cargo_src_unpack
}

src_unpack() {
einfo "Unpacking npm packages"
	local rust_pv=$(rustc --version \
		| cut -f 2 -d " ")
	if ver_test "${rust_pv%.*}" -ne "1.82" ; then
eerror "Switch rust to ${rust_pv%.*} via \`eselect rust\`"
		die
	fi
	unpack ${A}
	npm_src_unpack

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
	eapply "${FILESDIR}/${PN}-139.2.0-ollama-fix.patch"
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
	npm_hydrate
	enpm --version
#	enpm install -D "vite@${VITE_PV}" ${NPM_INSTALL_ARGS}
	enpm run build
	local chost=$(get_rustc_target)
	enpm run tauri build -- --target "${chost}"
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
# ollama support - passed
