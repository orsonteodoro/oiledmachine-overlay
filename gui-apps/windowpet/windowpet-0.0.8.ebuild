# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="WindowPet"
NODE_VERSION="21" # Upstream uses 21.6.1
NPM_AUDIT_FIX=1
NPM_OFFLINE=0 # Build failures if offline
NPM_SKIP_TARBALL_UNPACK="1"
PLUGINS_WORKSPACE_COMMIT="6d8188ebfa096fce9fea714b7dad948a98b2c36c"

declare -A GIT_CRATES=(
[tauri-plugin-autostart]="https://github.com/tauri-apps/plugins-workspace;0b59bc7096dfc7ff1b141c31457a2a0a4a5f9ad1;plugins-workspace-%commit%/plugins/autostart" # 0.0.0
[tauri-plugin-log]="https://github.com/tauri-apps/plugins-workspace;0b59bc7096dfc7ff1b141c31457a2a0a4a5f9ad1;plugins-workspace-%commit%/plugins/log" # 0.0.0
[tauri-plugin-single-instance]="https://github.com/tauri-apps/plugins-workspace;0b59bc7096dfc7ff1b141c31457a2a0a4a5f9ad1;plugins-workspace-%commit%/plugins/single-instance" # 0.0.0
[tauri-plugin-store]="https://github.com/tauri-apps/plugins-workspace;0b59bc7096dfc7ff1b141c31457a2a0a4a5f9ad1;plugins-workspace-%commit%/plugins/store" # 0.0.0
)

CRATES="
addr2line-0.24.2
adler2-2.0.0
ahash-0.7.8
aho-corasick-1.1.3
alloc-no-stdlib-2.0.4
alloc-stdlib-0.2.2
android-tzdata-0.1.1
android_system_properties-0.1.5
anyhow-1.0.89
arrayvec-0.7.6
async-broadcast-0.5.1
async-channel-2.3.1
async-executor-1.13.1
async-fs-1.6.0
async-io-1.13.0
async-io-2.3.4
async-lock-2.8.0
async-lock-3.4.0
async-process-1.8.1
async-recursion-1.1.1
async-signal-0.2.10
async-task-4.7.1
async-trait-0.1.83
atk-0.15.1
atk-sys-0.15.1
atomic-waker-1.1.2
auto-launch-0.5.0
autocfg-1.4.0
backtrace-0.3.74
base64-0.13.1
base64-0.21.7
base64-0.22.1
bitflags-1.3.2
bitflags-2.6.0
bitvec-1.0.1
block-0.1.6
block-buffer-0.10.4
blocking-1.6.1
borsh-1.5.1
borsh-derive-1.5.1
brotli-6.0.0
brotli-decompressor-4.0.1
bstr-1.10.0
bumpalo-3.16.0
byte-unit-5.1.4
bytecheck-0.6.12
bytecheck_derive-0.6.12
bytemuck-1.18.0
byteorder-1.5.0
bytes-1.7.2
cairo-rs-0.15.12
cairo-sys-rs-0.15.1
cargo_toml-0.15.3
cc-1.1.25
cesu8-1.1.0
cfb-0.7.3
cfg-expr-0.15.8
cfg-expr-0.9.1
cfg-if-1.0.0
cfg_aliases-0.2.1
chrono-0.4.38
cocoa-0.24.1
cocoa-foundation-0.1.2
color_quant-1.1.0
combine-4.6.7
concurrent-queue-2.5.0
convert_case-0.4.0
core-foundation-0.9.4
core-foundation-sys-0.8.7
core-graphics-0.22.3
core-graphics-types-0.1.3
cpufeatures-0.2.14
crc32fast-1.4.2
crossbeam-channel-0.5.13
crossbeam-deque-0.8.5
crossbeam-epoch-0.9.18
crossbeam-utils-0.8.20
crypto-common-0.1.6
cssparser-0.27.2
cssparser-macros-0.6.1
ctor-0.2.8
darling-0.20.10
darling_core-0.20.10
darling_macro-0.20.10
deranged-0.3.11
derivative-2.2.0
derive_more-0.99.18
digest-0.10.7
dirs-4.0.0
dirs-next-2.0.0
dirs-sys-0.3.7
dirs-sys-next-0.1.2
dispatch-0.2.0
dtoa-1.0.9
dtoa-short-0.3.5
dunce-1.0.5
embed-resource-2.5.0
embed_plist-1.2.2
encoding_rs-0.8.34
enumflags2-0.7.10
enumflags2_derive-0.7.10
equivalent-1.0.1
errno-0.3.9
event-listener-2.5.3
event-listener-3.1.0
event-listener-5.3.1
event-listener-strategy-0.5.2
fastrand-1.9.0
fastrand-2.1.1
fdeflate-0.3.5
fern-0.6.2
field-offset-0.3.6
filetime-0.2.25
flate2-1.0.34
fluent-uri-0.1.4
fnv-1.0.7
foreign-types-0.3.2
foreign-types-shared-0.1.1
form_urlencoded-1.2.1
funty-2.0.0
futf-0.1.5
futures-channel-0.3.31
futures-core-0.3.31
futures-executor-0.3.31
futures-io-0.3.31
futures-lite-1.13.0
futures-lite-2.3.0
futures-macro-0.3.31
futures-sink-0.3.31
futures-task-0.3.31
futures-util-0.3.31
fxhash-0.2.1
gdk-0.15.4
gdk-pixbuf-0.15.11
gdk-pixbuf-sys-0.15.10
gdk-sys-0.15.1
gdkwayland-sys-0.15.3
gdkx11-sys-0.15.1
generator-0.7.5
generic-array-0.14.7
getrandom-0.1.16
getrandom-0.2.15
gimli-0.31.1
gio-0.15.12
gio-sys-0.15.10
glib-0.15.12
glib-macros-0.15.13
glib-sys-0.15.10
glob-0.3.1
globset-0.4.15
gobject-sys-0.15.10
gtk-0.15.5
gtk-sys-0.15.3
gtk3-macros-0.15.6
h2-0.3.26
hashbrown-0.12.3
hashbrown-0.15.0
heck-0.3.3
heck-0.4.1
heck-0.5.0
hermit-abi-0.3.9
hermit-abi-0.4.0
hex-0.4.3
html5ever-0.26.0
http-0.2.12
http-body-0.4.6
http-range-0.1.5
httparse-1.9.5
httpdate-1.0.3
hyper-0.14.30
hyper-tls-0.5.0
iana-time-zone-0.1.61
iana-time-zone-haiku-0.1.2
ico-0.3.0
ident_case-1.0.1
idna-0.5.0
ignore-0.4.23
image-0.24.9
indexmap-1.9.3
indexmap-2.6.0
infer-0.13.0
instant-0.1.13
io-lifetimes-1.0.11
ipnet-2.10.1
is-docker-0.2.0
is-wsl-0.4.0
itoa-0.4.8
itoa-1.0.11
javascriptcore-rs-0.16.0
javascriptcore-rs-sys-0.4.0
jni-0.20.0
jni-sys-0.3.0
js-sys-0.3.70
json-patch-2.0.0
jsonptr-0.4.7
kuchikiki-0.8.2
lazy_static-1.5.0
libappindicator-0.7.1
libappindicator-sys-0.7.3
libc-0.2.159
libloading-0.7.4
libredox-0.1.3
linux-raw-sys-0.3.8
linux-raw-sys-0.4.14
lock_api-0.4.12
log-0.4.22
loom-0.5.6
mac-0.1.1
malloc_buf-0.0.6
markup5ever-0.11.0
matchers-0.1.0
matches-0.1.10
memchr-2.7.4
memoffset-0.7.1
memoffset-0.9.1
mime-0.3.17
minisign-verify-0.2.2
miniz_oxide-0.8.0
mio-1.0.2
mouse_position-0.1.4
native-tls-0.2.12
ndk-0.6.0
ndk-context-0.1.1
ndk-sys-0.3.0
new_debug_unreachable-1.0.6
nix-0.26.4
nodrop-0.1.14
nu-ansi-term-0.46.0
num-conv-0.1.0
num-traits-0.2.19
num_enum-0.5.11
num_enum_derive-0.5.11
num_threads-0.1.7
objc-0.2.7
objc-foundation-0.1.1
objc_exception-0.1.2
objc_id-0.1.1
object-0.36.5
once_cell-1.20.2
open-3.2.0
open-5.3.0
openssl-0.10.66
openssl-macros-0.1.1
openssl-probe-0.1.5
openssl-sys-0.9.103
ordered-stream-0.2.0
overload-0.1.1
pango-0.15.10
pango-sys-0.15.10
parking-2.2.1
parking_lot-0.12.3
parking_lot_core-0.9.10
pathdiff-0.2.1
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
pin-project-lite-0.2.14
pin-utils-0.1.0
piper-0.2.4
pkg-config-0.3.31
plist-1.7.0
png-0.17.14
polling-2.8.0
polling-3.7.3
powerfmt-0.2.0
ppv-lite86-0.2.20
precomputed-hash-0.1.1
proc-macro-crate-1.3.1
proc-macro-crate-3.2.0
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro-hack-0.5.20+deprecated
proc-macro2-1.0.86
ptr_meta-0.1.4
ptr_meta_derive-0.1.4
quick-xml-0.32.0
quote-1.0.37
radium-0.7.0
rand-0.7.3
rand-0.8.5
rand_chacha-0.2.2
rand_chacha-0.3.1
rand_core-0.5.1
rand_core-0.6.4
rand_hc-0.2.0
rand_pcg-0.2.1
raw-window-handle-0.5.2
redox_syscall-0.5.7
redox_users-0.4.6
regex-1.11.0
regex-automata-0.1.10
regex-automata-0.4.8
regex-syntax-0.6.29
regex-syntax-0.8.5
rend-0.4.2
reqwest-0.11.27
rfd-0.10.0
rkyv-0.7.45
rkyv_derive-0.7.45
rust_decimal-1.36.0
rustc-demangle-0.1.24
rustc_version-0.4.1
rustix-0.37.27
rustix-0.38.37
rustls-pemfile-1.0.4
rustversion-1.0.17
ryu-1.0.18
same-file-1.0.6
schannel-0.1.24
scoped-tls-1.0.1
scopeguard-1.2.0
seahash-4.1.0
security-framework-2.11.1
security-framework-sys-2.12.0
selectors-0.22.0
semver-1.0.23
serde-1.0.210
serde_derive-1.0.210
serde_json-1.0.128
serde_repr-0.1.19
serde_spanned-0.6.8
serde_urlencoded-0.7.1
serde_with-3.11.0
serde_with_macros-3.11.0
serialize-to-javascript-0.1.2
serialize-to-javascript-impl-0.1.2
servo_arc-0.1.1
sha1-0.10.6
sha2-0.10.8
sharded-slab-0.1.7
shlex-1.3.0
signal-hook-registry-1.4.2
simd-adler32-0.3.7
simdutf8-0.1.5
siphasher-0.3.11
slab-0.4.9
smallvec-1.13.2
socket2-0.4.10
socket2-0.5.7
soup2-0.2.1
soup2-sys-0.2.0
stable_deref_trait-1.2.0
state-0.5.3
static_assertions-1.1.0
string_cache-0.8.7
string_cache_codegen-0.5.2
strsim-0.11.1
syn-1.0.109
syn-2.0.79
syn_derive-0.1.8
sync_wrapper-0.1.2
system-configuration-0.5.1
system-configuration-sys-0.5.0
system-deps-5.0.0
system-deps-6.2.2
tao-0.16.10
tao-macros-0.1.3
tap-1.0.1
tar-0.4.42
target-lexicon-0.12.16
tauri-1.8.0
tauri-build-1.5.5
tauri-codegen-1.4.5
tauri-macros-1.4.6
tauri-runtime-0.14.5
tauri-runtime-wry-0.14.10
tauri-utils-1.6.1
tauri-winres-0.1.1
tempfile-3.13.0
tendril-0.4.3
thin-slice-0.1.1
thiserror-1.0.64
thiserror-impl-1.0.64
thread_local-1.1.8
time-0.3.36
time-core-0.1.2
time-macros-0.2.18
tinyvec-1.8.0
tinyvec_macros-0.1.1
tokio-1.40.0
tokio-native-tls-0.3.1
tokio-util-0.7.12
toml-0.5.11
toml-0.7.8
toml-0.8.19
toml_datetime-0.6.8
toml_edit-0.19.15
toml_edit-0.22.22
tower-service-0.3.3
tracing-0.1.40
tracing-attributes-0.1.27
tracing-core-0.1.32
tracing-log-0.2.0
tracing-subscriber-0.3.18
try-lock-0.2.5
typenum-1.17.0
uds_windows-1.1.0
unicode-bidi-0.3.17
unicode-ident-1.0.13
unicode-normalization-0.1.24
unicode-segmentation-1.12.0
url-2.5.2
utf-8-0.7.6
utf8-width-0.1.7
uuid-1.10.0
valuable-0.1.0
value-bag-1.9.0
vcpkg-0.2.15
version-compare-0.0.11
version-compare-0.2.0
version_check-0.9.5
vswhom-0.1.0
vswhom-sys-0.1.2
waker-fn-1.2.0
walkdir-2.5.0
want-0.3.1
wasi-0.11.0+wasi-snapshot-preview1
wasi-0.9.0+wasi-snapshot-preview1
wasm-bindgen-0.2.93
wasm-bindgen-backend-0.2.93
wasm-bindgen-futures-0.4.43
wasm-bindgen-macro-0.2.93
wasm-bindgen-macro-support-0.2.93
wasm-bindgen-shared-0.2.93
wasm-streams-0.4.1
web-sys-0.3.70
webkit2gtk-0.18.2
webkit2gtk-sys-0.18.0
webview2-com-0.19.1
webview2-com-macros-0.6.0
webview2-com-sys-0.19.0
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.9
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.37.0
windows-0.39.0
windows-0.48.0
windows-bindgen-0.39.0
windows-core-0.52.0
windows-implement-0.39.0
windows-metadata-0.39.0
windows-sys-0.42.0
windows-sys-0.48.0
windows-sys-0.52.0
windows-sys-0.59.0
windows-targets-0.48.5
windows-targets-0.52.6
windows-tokens-0.39.0
windows-version-0.1.1
windows_aarch64_gnullvm-0.42.2
windows_aarch64_gnullvm-0.48.5
windows_aarch64_gnullvm-0.52.6
windows_aarch64_msvc-0.37.0
windows_aarch64_msvc-0.39.0
windows_aarch64_msvc-0.42.2
windows_aarch64_msvc-0.48.5
windows_aarch64_msvc-0.52.6
windows_i686_gnu-0.37.0
windows_i686_gnu-0.39.0
windows_i686_gnu-0.42.2
windows_i686_gnu-0.48.5
windows_i686_gnu-0.52.6
windows_i686_gnullvm-0.52.6
windows_i686_msvc-0.37.0
windows_i686_msvc-0.39.0
windows_i686_msvc-0.42.2
windows_i686_msvc-0.48.5
windows_i686_msvc-0.52.6
windows_x86_64_gnu-0.37.0
windows_x86_64_gnu-0.39.0
windows_x86_64_gnu-0.42.2
windows_x86_64_gnu-0.48.5
windows_x86_64_gnu-0.52.6
windows_x86_64_gnullvm-0.42.2
windows_x86_64_gnullvm-0.48.5
windows_x86_64_gnullvm-0.52.6
windows_x86_64_msvc-0.37.0
windows_x86_64_msvc-0.39.0
windows_x86_64_msvc-0.42.2
windows_x86_64_msvc-0.48.5
windows_x86_64_msvc-0.52.6
winnow-0.5.40
winnow-0.6.20
winreg-0.10.1
winreg-0.50.0
winreg-0.52.0
wry-0.24.11
wyz-0.5.1
x11-2.21.0
x11-dl-2.21.0
xattr-1.3.1
xdg-home-1.3.0
zbus-3.15.2
zbus_macros-3.15.2
zbus_names-2.6.1
zerocopy-0.7.35
zerocopy-derive-0.7.35
zip-0.6.6
zvariant-3.15.2
zvariant_derive-3.15.2
zvariant_utils-1.0.1
"

inherit cargo desktop lcnr npm xdg

# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@ampproject/remapping/-/remapping-2.3.0.tgz -> npmpkg-@ampproject-remapping-2.3.0.tgz
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.25.7.tgz -> npmpkg-@babel-code-frame-7.25.7.tgz
https://registry.npmjs.org/@babel/compat-data/-/compat-data-7.25.7.tgz -> npmpkg-@babel-compat-data-7.25.7.tgz
https://registry.npmjs.org/@babel/core/-/core-7.25.7.tgz -> npmpkg-@babel-core-7.25.7.tgz
https://registry.npmjs.org/@babel/generator/-/generator-7.25.7.tgz -> npmpkg-@babel-generator-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-compilation-targets/-/helper-compilation-targets-7.25.7.tgz -> npmpkg-@babel-helper-compilation-targets-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-module-imports/-/helper-module-imports-7.25.7.tgz -> npmpkg-@babel-helper-module-imports-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-module-transforms/-/helper-module-transforms-7.25.7.tgz -> npmpkg-@babel-helper-module-transforms-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-plugin-utils/-/helper-plugin-utils-7.25.7.tgz -> npmpkg-@babel-helper-plugin-utils-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-simple-access/-/helper-simple-access-7.25.7.tgz -> npmpkg-@babel-helper-simple-access-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-string-parser/-/helper-string-parser-7.25.7.tgz -> npmpkg-@babel-helper-string-parser-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.25.7.tgz -> npmpkg-@babel-helper-validator-identifier-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-validator-option/-/helper-validator-option-7.25.7.tgz -> npmpkg-@babel-helper-validator-option-7.25.7.tgz
https://registry.npmjs.org/@babel/helpers/-/helpers-7.25.7.tgz -> npmpkg-@babel-helpers-7.25.7.tgz
https://registry.npmjs.org/@babel/highlight/-/highlight-7.25.7.tgz -> npmpkg-@babel-highlight-7.25.7.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/@babel/parser/-/parser-7.25.7.tgz -> npmpkg-@babel-parser-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-react-jsx-self/-/plugin-transform-react-jsx-self-7.25.7.tgz -> npmpkg-@babel-plugin-transform-react-jsx-self-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-react-jsx-source/-/plugin-transform-react-jsx-source-7.25.7.tgz -> npmpkg-@babel-plugin-transform-react-jsx-source-7.25.7.tgz
https://registry.npmjs.org/@babel/runtime/-/runtime-7.25.7.tgz -> npmpkg-@babel-runtime-7.25.7.tgz
https://registry.npmjs.org/@babel/template/-/template-7.25.7.tgz -> npmpkg-@babel-template-7.25.7.tgz
https://registry.npmjs.org/@babel/traverse/-/traverse-7.25.7.tgz -> npmpkg-@babel-traverse-7.25.7.tgz
https://registry.npmjs.org/@babel/types/-/types-7.25.7.tgz -> npmpkg-@babel-types-7.25.7.tgz
https://registry.npmjs.org/@cspotcode/source-map-support/-/source-map-support-0.8.1.tgz -> npmpkg-@cspotcode-source-map-support-0.8.1.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.9.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.9.tgz
https://registry.npmjs.org/@esbuild/aix-ppc64/-/aix-ppc64-0.21.5.tgz -> npmpkg-@esbuild-aix-ppc64-0.21.5.tgz
https://registry.npmjs.org/@esbuild/android-arm/-/android-arm-0.21.5.tgz -> npmpkg-@esbuild-android-arm-0.21.5.tgz
https://registry.npmjs.org/@esbuild/android-arm64/-/android-arm64-0.21.5.tgz -> npmpkg-@esbuild-android-arm64-0.21.5.tgz
https://registry.npmjs.org/@esbuild/android-x64/-/android-x64-0.21.5.tgz -> npmpkg-@esbuild-android-x64-0.21.5.tgz
https://registry.npmjs.org/@esbuild/darwin-arm64/-/darwin-arm64-0.21.5.tgz -> npmpkg-@esbuild-darwin-arm64-0.21.5.tgz
https://registry.npmjs.org/@esbuild/darwin-x64/-/darwin-x64-0.21.5.tgz -> npmpkg-@esbuild-darwin-x64-0.21.5.tgz
https://registry.npmjs.org/@esbuild/freebsd-arm64/-/freebsd-arm64-0.21.5.tgz -> npmpkg-@esbuild-freebsd-arm64-0.21.5.tgz
https://registry.npmjs.org/@esbuild/freebsd-x64/-/freebsd-x64-0.21.5.tgz -> npmpkg-@esbuild-freebsd-x64-0.21.5.tgz
https://registry.npmjs.org/@esbuild/linux-arm/-/linux-arm-0.21.5.tgz -> npmpkg-@esbuild-linux-arm-0.21.5.tgz
https://registry.npmjs.org/@esbuild/linux-arm64/-/linux-arm64-0.21.5.tgz -> npmpkg-@esbuild-linux-arm64-0.21.5.tgz
https://registry.npmjs.org/@esbuild/linux-ia32/-/linux-ia32-0.21.5.tgz -> npmpkg-@esbuild-linux-ia32-0.21.5.tgz
https://registry.npmjs.org/@esbuild/linux-loong64/-/linux-loong64-0.21.5.tgz -> npmpkg-@esbuild-linux-loong64-0.21.5.tgz
https://registry.npmjs.org/@esbuild/linux-mips64el/-/linux-mips64el-0.21.5.tgz -> npmpkg-@esbuild-linux-mips64el-0.21.5.tgz
https://registry.npmjs.org/@esbuild/linux-ppc64/-/linux-ppc64-0.21.5.tgz -> npmpkg-@esbuild-linux-ppc64-0.21.5.tgz
https://registry.npmjs.org/@esbuild/linux-riscv64/-/linux-riscv64-0.21.5.tgz -> npmpkg-@esbuild-linux-riscv64-0.21.5.tgz
https://registry.npmjs.org/@esbuild/linux-s390x/-/linux-s390x-0.21.5.tgz -> npmpkg-@esbuild-linux-s390x-0.21.5.tgz
https://registry.npmjs.org/@esbuild/linux-x64/-/linux-x64-0.21.5.tgz -> npmpkg-@esbuild-linux-x64-0.21.5.tgz
https://registry.npmjs.org/@esbuild/netbsd-x64/-/netbsd-x64-0.21.5.tgz -> npmpkg-@esbuild-netbsd-x64-0.21.5.tgz
https://registry.npmjs.org/@esbuild/openbsd-x64/-/openbsd-x64-0.21.5.tgz -> npmpkg-@esbuild-openbsd-x64-0.21.5.tgz
https://registry.npmjs.org/@esbuild/sunos-x64/-/sunos-x64-0.21.5.tgz -> npmpkg-@esbuild-sunos-x64-0.21.5.tgz
https://registry.npmjs.org/@esbuild/win32-arm64/-/win32-arm64-0.21.5.tgz -> npmpkg-@esbuild-win32-arm64-0.21.5.tgz
https://registry.npmjs.org/@esbuild/win32-ia32/-/win32-ia32-0.21.5.tgz -> npmpkg-@esbuild-win32-ia32-0.21.5.tgz
https://registry.npmjs.org/@esbuild/win32-x64/-/win32-x64-0.21.5.tgz -> npmpkg-@esbuild-win32-x64-0.21.5.tgz
https://registry.npmjs.org/@floating-ui/core/-/core-1.6.8.tgz -> npmpkg-@floating-ui-core-1.6.8.tgz
https://registry.npmjs.org/@floating-ui/dom/-/dom-1.6.11.tgz -> npmpkg-@floating-ui-dom-1.6.11.tgz
https://registry.npmjs.org/@floating-ui/react/-/react-0.26.24.tgz -> npmpkg-@floating-ui-react-0.26.24.tgz
https://registry.npmjs.org/@floating-ui/react-dom/-/react-dom-2.1.2.tgz -> npmpkg-@floating-ui-react-dom-2.1.2.tgz
https://registry.npmjs.org/@floating-ui/utils/-/utils-0.2.8.tgz -> npmpkg-@floating-ui-utils-0.2.8.tgz
https://registry.npmjs.org/@jest/schemas/-/schemas-29.6.3.tgz -> npmpkg-@jest-schemas-29.6.3.tgz
https://registry.npmjs.org/@jridgewell/gen-mapping/-/gen-mapping-0.3.5.tgz -> npmpkg-@jridgewell-gen-mapping-0.3.5.tgz
https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.2.tgz -> npmpkg-@jridgewell-resolve-uri-3.1.2.tgz
https://registry.npmjs.org/@jridgewell/set-array/-/set-array-1.2.1.tgz -> npmpkg-@jridgewell-set-array-1.2.1.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.5.0.tgz -> npmpkg-@jridgewell-sourcemap-codec-1.5.0.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.25.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.25.tgz
https://registry.npmjs.org/@mantine/core/-/core-7.13.2.tgz -> npmpkg-@mantine-core-7.13.2.tgz
https://registry.npmjs.org/@mantine/hooks/-/hooks-7.13.2.tgz -> npmpkg-@mantine-hooks-7.13.2.tgz
https://registry.npmjs.org/@mantine/modals/-/modals-7.13.2.tgz -> npmpkg-@mantine-modals-7.13.2.tgz
https://registry.npmjs.org/@mantine/notifications/-/notifications-7.13.2.tgz -> npmpkg-@mantine-notifications-7.13.2.tgz
https://registry.npmjs.org/@mantine/store/-/store-7.13.2.tgz -> npmpkg-@mantine-store-7.13.2.tgz
https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> npmpkg-@nodelib-fs.scandir-2.1.5.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> npmpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> npmpkg-@nodelib-fs.walk-1.2.8.tgz
https://registry.npmjs.org/@remix-run/router/-/router-1.19.2.tgz -> npmpkg-@remix-run-router-1.19.2.tgz
https://registry.npmjs.org/@rollup/rollup-android-arm-eabi/-/rollup-android-arm-eabi-4.24.0.tgz -> npmpkg-@rollup-rollup-android-arm-eabi-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-android-arm64/-/rollup-android-arm64-4.24.0.tgz -> npmpkg-@rollup-rollup-android-arm64-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-darwin-arm64/-/rollup-darwin-arm64-4.24.0.tgz -> npmpkg-@rollup-rollup-darwin-arm64-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-darwin-x64/-/rollup-darwin-x64-4.24.0.tgz -> npmpkg-@rollup-rollup-darwin-x64-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-arm-gnueabihf/-/rollup-linux-arm-gnueabihf-4.24.0.tgz -> npmpkg-@rollup-rollup-linux-arm-gnueabihf-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-arm-musleabihf/-/rollup-linux-arm-musleabihf-4.24.0.tgz -> npmpkg-@rollup-rollup-linux-arm-musleabihf-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-arm64-gnu/-/rollup-linux-arm64-gnu-4.24.0.tgz -> npmpkg-@rollup-rollup-linux-arm64-gnu-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-arm64-musl/-/rollup-linux-arm64-musl-4.24.0.tgz -> npmpkg-@rollup-rollup-linux-arm64-musl-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-powerpc64le-gnu/-/rollup-linux-powerpc64le-gnu-4.24.0.tgz -> npmpkg-@rollup-rollup-linux-powerpc64le-gnu-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-riscv64-gnu/-/rollup-linux-riscv64-gnu-4.24.0.tgz -> npmpkg-@rollup-rollup-linux-riscv64-gnu-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-s390x-gnu/-/rollup-linux-s390x-gnu-4.24.0.tgz -> npmpkg-@rollup-rollup-linux-s390x-gnu-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-x64-gnu/-/rollup-linux-x64-gnu-4.24.0.tgz -> npmpkg-@rollup-rollup-linux-x64-gnu-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-x64-musl/-/rollup-linux-x64-musl-4.24.0.tgz -> npmpkg-@rollup-rollup-linux-x64-musl-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-win32-arm64-msvc/-/rollup-win32-arm64-msvc-4.24.0.tgz -> npmpkg-@rollup-rollup-win32-arm64-msvc-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-win32-ia32-msvc/-/rollup-win32-ia32-msvc-4.24.0.tgz -> npmpkg-@rollup-rollup-win32-ia32-msvc-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-win32-x64-msvc/-/rollup-win32-x64-msvc-4.24.0.tgz -> npmpkg-@rollup-rollup-win32-x64-msvc-4.24.0.tgz
https://registry.npmjs.org/@sinclair/typebox/-/typebox-0.27.8.tgz -> npmpkg-@sinclair-typebox-0.27.8.tgz
https://registry.npmjs.org/@tabler/icons/-/icons-2.47.0.tgz -> npmpkg-@tabler-icons-2.47.0.tgz
https://registry.npmjs.org/@tabler/icons-react/-/icons-react-2.47.0.tgz -> npmpkg-@tabler-icons-react-2.47.0.tgz
https://registry.npmjs.org/@tauri-apps/api/-/api-1.6.0.tgz -> npmpkg-@tauri-apps-api-1.6.0.tgz
https://registry.npmjs.org/@tauri-apps/cli/-/cli-1.5.14.tgz -> npmpkg-@tauri-apps-cli-1.5.14.tgz
https://registry.npmjs.org/@tauri-apps/cli-darwin-arm64/-/cli-darwin-arm64-1.5.14.tgz -> npmpkg-@tauri-apps-cli-darwin-arm64-1.5.14.tgz
https://registry.npmjs.org/@tauri-apps/cli-darwin-x64/-/cli-darwin-x64-1.5.14.tgz -> npmpkg-@tauri-apps-cli-darwin-x64-1.5.14.tgz
https://registry.npmjs.org/@tauri-apps/cli-linux-arm-gnueabihf/-/cli-linux-arm-gnueabihf-1.5.14.tgz -> npmpkg-@tauri-apps-cli-linux-arm-gnueabihf-1.5.14.tgz
https://registry.npmjs.org/@tauri-apps/cli-linux-arm64-gnu/-/cli-linux-arm64-gnu-1.5.14.tgz -> npmpkg-@tauri-apps-cli-linux-arm64-gnu-1.5.14.tgz
https://registry.npmjs.org/@tauri-apps/cli-linux-arm64-musl/-/cli-linux-arm64-musl-1.5.14.tgz -> npmpkg-@tauri-apps-cli-linux-arm64-musl-1.5.14.tgz
https://registry.npmjs.org/@tauri-apps/cli-linux-x64-gnu/-/cli-linux-x64-gnu-1.5.14.tgz -> npmpkg-@tauri-apps-cli-linux-x64-gnu-1.5.14.tgz
https://registry.npmjs.org/@tauri-apps/cli-linux-x64-musl/-/cli-linux-x64-musl-1.5.14.tgz -> npmpkg-@tauri-apps-cli-linux-x64-musl-1.5.14.tgz
https://registry.npmjs.org/@tauri-apps/cli-win32-arm64-msvc/-/cli-win32-arm64-msvc-1.5.14.tgz -> npmpkg-@tauri-apps-cli-win32-arm64-msvc-1.5.14.tgz
https://registry.npmjs.org/@tauri-apps/cli-win32-ia32-msvc/-/cli-win32-ia32-msvc-1.5.14.tgz -> npmpkg-@tauri-apps-cli-win32-ia32-msvc-1.5.14.tgz
https://registry.npmjs.org/@tauri-apps/cli-win32-x64-msvc/-/cli-win32-x64-msvc-1.5.14.tgz -> npmpkg-@tauri-apps-cli-win32-x64-msvc-1.5.14.tgz
https://registry.npmjs.org/@testing-library/dom/-/dom-9.3.4.tgz -> npmpkg-@testing-library-dom-9.3.4.tgz
https://registry.npmjs.org/@testing-library/react/-/react-14.3.1.tgz -> npmpkg-@testing-library-react-14.3.1.tgz
https://registry.npmjs.org/@tsconfig/node10/-/node10-1.0.11.tgz -> npmpkg-@tsconfig-node10-1.0.11.tgz
https://registry.npmjs.org/@tsconfig/node12/-/node12-1.0.11.tgz -> npmpkg-@tsconfig-node12-1.0.11.tgz
https://registry.npmjs.org/@tsconfig/node14/-/node14-1.0.3.tgz -> npmpkg-@tsconfig-node14-1.0.3.tgz
https://registry.npmjs.org/@tsconfig/node16/-/node16-1.0.4.tgz -> npmpkg-@tsconfig-node16-1.0.4.tgz
https://registry.npmjs.org/@types/aria-query/-/aria-query-5.0.4.tgz -> npmpkg-@types-aria-query-5.0.4.tgz
https://registry.npmjs.org/@types/babel__core/-/babel__core-7.20.5.tgz -> npmpkg-@types-babel__core-7.20.5.tgz
https://registry.npmjs.org/@types/babel__generator/-/babel__generator-7.6.8.tgz -> npmpkg-@types-babel__generator-7.6.8.tgz
https://registry.npmjs.org/@types/babel__template/-/babel__template-7.4.4.tgz -> npmpkg-@types-babel__template-7.4.4.tgz
https://registry.npmjs.org/@types/babel__traverse/-/babel__traverse-7.20.6.tgz -> npmpkg-@types-babel__traverse-7.20.6.tgz
https://registry.npmjs.org/@types/debug/-/debug-4.1.12.tgz -> npmpkg-@types-debug-4.1.12.tgz
https://registry.npmjs.org/@types/estree/-/estree-1.0.6.tgz -> npmpkg-@types-estree-1.0.6.tgz
https://registry.npmjs.org/@types/estree-jsx/-/estree-jsx-1.0.5.tgz -> npmpkg-@types-estree-jsx-1.0.5.tgz
https://registry.npmjs.org/@types/hast/-/hast-3.0.4.tgz -> npmpkg-@types-hast-3.0.4.tgz
https://registry.npmjs.org/@types/mdast/-/mdast-4.0.4.tgz -> npmpkg-@types-mdast-4.0.4.tgz
https://registry.npmjs.org/@types/ms/-/ms-0.7.34.tgz -> npmpkg-@types-ms-0.7.34.tgz
https://registry.npmjs.org/@types/node/-/node-20.16.10.tgz -> npmpkg-@types-node-20.16.10.tgz
https://registry.npmjs.org/@types/prop-types/-/prop-types-15.7.13.tgz -> npmpkg-@types-prop-types-15.7.13.tgz
https://registry.npmjs.org/@types/react/-/react-18.3.11.tgz -> npmpkg-@types-react-18.3.11.tgz
https://registry.npmjs.org/@types/react-dom/-/react-dom-18.3.0.tgz -> npmpkg-@types-react-dom-18.3.0.tgz
https://registry.npmjs.org/@types/unist/-/unist-3.0.3.tgz -> npmpkg-@types-unist-3.0.3.tgz
https://registry.npmjs.org/@ungap/structured-clone/-/structured-clone-1.2.0.tgz -> npmpkg-@ungap-structured-clone-1.2.0.tgz
https://registry.npmjs.org/@vitejs/plugin-react/-/plugin-react-4.3.2.tgz -> npmpkg-@vitejs-plugin-react-4.3.2.tgz
https://registry.npmjs.org/@vitest/expect/-/expect-1.6.0.tgz -> npmpkg-@vitest-expect-1.6.0.tgz
https://registry.npmjs.org/@vitest/runner/-/runner-1.6.0.tgz -> npmpkg-@vitest-runner-1.6.0.tgz
https://registry.npmjs.org/@vitest/snapshot/-/snapshot-1.6.0.tgz -> npmpkg-@vitest-snapshot-1.6.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.3.1.tgz -> npmpkg-react-is-18.3.1.tgz
https://registry.npmjs.org/@vitest/spy/-/spy-1.6.0.tgz -> npmpkg-@vitest-spy-1.6.0.tgz
https://registry.npmjs.org/@vitest/utils/-/utils-1.6.0.tgz -> npmpkg-@vitest-utils-1.6.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.3.1.tgz -> npmpkg-react-is-18.3.1.tgz
https://registry.npmjs.org/acorn/-/acorn-8.12.1.tgz -> npmpkg-acorn-8.12.1.tgz
https://registry.npmjs.org/acorn-walk/-/acorn-walk-8.3.4.tgz -> npmpkg-acorn-walk-8.3.4.tgz
https://registry.npmjs.org/agent-base/-/agent-base-7.1.1.tgz -> npmpkg-agent-base-7.1.1.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-4.3.2.tgz -> npmpkg-ansi-escapes-4.3.2.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.21.3.tgz -> npmpkg-type-fest-0.21.3.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz -> npmpkg-anymatch-3.1.3.tgz
https://registry.npmjs.org/arg/-/arg-4.1.3.tgz -> npmpkg-arg-4.1.3.tgz
https://registry.npmjs.org/aria-query/-/aria-query-5.1.3.tgz -> npmpkg-aria-query-5.1.3.tgz
https://registry.npmjs.org/array-buffer-byte-length/-/array-buffer-byte-length-1.0.1.tgz -> npmpkg-array-buffer-byte-length-1.0.1.tgz
https://registry.npmjs.org/assertion-error/-/assertion-error-1.1.0.tgz -> npmpkg-assertion-error-1.1.0.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz -> npmpkg-asynckit-0.4.0.tgz
https://registry.npmjs.org/available-typed-arrays/-/available-typed-arrays-1.0.7.tgz -> npmpkg-available-typed-arrays-1.0.7.tgz
https://registry.npmjs.org/bail/-/bail-2.0.2.tgz -> npmpkg-bail-2.0.2.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz -> npmpkg-balanced-match-1.0.2.tgz
https://registry.npmjs.org/big-integer/-/big-integer-1.6.52.tgz -> npmpkg-big-integer-1.6.52.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.3.0.tgz -> npmpkg-binary-extensions-2.3.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/braces/-/braces-3.0.3.tgz -> npmpkg-braces-3.0.3.tgz
https://registry.npmjs.org/broadcast-channel/-/broadcast-channel-3.7.0.tgz -> npmpkg-broadcast-channel-3.7.0.tgz
https://registry.npmjs.org/browserslist/-/browserslist-4.24.0.tgz -> npmpkg-browserslist-4.24.0.tgz
https://registry.npmjs.org/cac/-/cac-6.7.14.tgz -> npmpkg-cac-6.7.14.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.7.tgz -> npmpkg-call-bind-1.0.7.tgz
https://registry.npmjs.org/camelcase-css/-/camelcase-css-2.0.1.tgz -> npmpkg-camelcase-css-2.0.1.tgz
https://registry.npmjs.org/caniuse-lite/-/caniuse-lite-1.0.30001667.tgz -> npmpkg-caniuse-lite-1.0.30001667.tgz
https://registry.npmjs.org/ccount/-/ccount-2.0.1.tgz -> npmpkg-ccount-2.0.1.tgz
https://registry.npmjs.org/chai/-/chai-4.5.0.tgz -> npmpkg-chai-4.5.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/character-entities/-/character-entities-2.0.2.tgz -> npmpkg-character-entities-2.0.2.tgz
https://registry.npmjs.org/character-entities-html4/-/character-entities-html4-2.1.0.tgz -> npmpkg-character-entities-html4-2.1.0.tgz
https://registry.npmjs.org/character-entities-legacy/-/character-entities-legacy-3.0.0.tgz -> npmpkg-character-entities-legacy-3.0.0.tgz
https://registry.npmjs.org/character-reference-invalid/-/character-reference-invalid-2.0.1.tgz -> npmpkg-character-reference-invalid-2.0.1.tgz
https://registry.npmjs.org/check-error/-/check-error-1.0.3.tgz -> npmpkg-check-error-1.0.3.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.6.0.tgz -> npmpkg-chokidar-3.6.0.tgz
https://registry.npmjs.org/clsx/-/clsx-2.1.1.tgz -> npmpkg-clsx-2.1.1.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz -> npmpkg-combined-stream-1.0.8.tgz
https://registry.npmjs.org/comma-separated-tokens/-/comma-separated-tokens-2.0.3.tgz -> npmpkg-comma-separated-tokens-2.0.3.tgz
https://registry.npmjs.org/commander/-/commander-8.3.0.tgz -> npmpkg-commander-8.3.0.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/confbox/-/confbox-0.1.7.tgz -> npmpkg-confbox-0.1.7.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-2.0.0.tgz -> npmpkg-convert-source-map-2.0.0.tgz
https://registry.npmjs.org/create-require/-/create-require-1.1.1.tgz -> npmpkg-create-require-1.1.1.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/cssesc/-/cssesc-3.0.0.tgz -> npmpkg-cssesc-3.0.0.tgz
https://registry.npmjs.org/cssfontparser/-/cssfontparser-1.2.1.tgz -> npmpkg-cssfontparser-1.2.1.tgz
https://registry.npmjs.org/cssstyle/-/cssstyle-4.1.0.tgz -> npmpkg-cssstyle-4.1.0.tgz
https://registry.npmjs.org/csstype/-/csstype-3.1.3.tgz -> npmpkg-csstype-3.1.3.tgz
https://registry.npmjs.org/data-urls/-/data-urls-5.0.0.tgz -> npmpkg-data-urls-5.0.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/decimal.js/-/decimal.js-10.4.3.tgz -> npmpkg-decimal.js-10.4.3.tgz
https://registry.npmjs.org/decode-named-character-reference/-/decode-named-character-reference-1.0.2.tgz -> npmpkg-decode-named-character-reference-1.0.2.tgz
https://registry.npmjs.org/deep-eql/-/deep-eql-4.1.4.tgz -> npmpkg-deep-eql-4.1.4.tgz
https://registry.npmjs.org/deep-equal/-/deep-equal-2.2.3.tgz -> npmpkg-deep-equal-2.2.3.tgz
https://registry.npmjs.org/define-data-property/-/define-data-property-1.1.4.tgz -> npmpkg-define-data-property-1.1.4.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.2.1.tgz -> npmpkg-define-properties-1.2.1.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz -> npmpkg-delayed-stream-1.0.0.tgz
https://registry.npmjs.org/dequal/-/dequal-2.0.3.tgz -> npmpkg-dequal-2.0.3.tgz
https://registry.npmjs.org/detect-node/-/detect-node-2.1.0.tgz -> npmpkg-detect-node-2.1.0.tgz
https://registry.npmjs.org/detect-node-es/-/detect-node-es-1.1.0.tgz -> npmpkg-detect-node-es-1.1.0.tgz
https://registry.npmjs.org/devlop/-/devlop-1.1.0.tgz -> npmpkg-devlop-1.1.0.tgz
https://registry.npmjs.org/diff/-/diff-4.0.2.tgz -> npmpkg-diff-4.0.2.tgz
https://registry.npmjs.org/diff-sequences/-/diff-sequences-29.6.3.tgz -> npmpkg-diff-sequences-29.6.3.tgz
https://registry.npmjs.org/dom-accessibility-api/-/dom-accessibility-api-0.5.16.tgz -> npmpkg-dom-accessibility-api-0.5.16.tgz
https://registry.npmjs.org/dom-helpers/-/dom-helpers-5.2.1.tgz -> npmpkg-dom-helpers-5.2.1.tgz
https://registry.npmjs.org/electron-to-chromium/-/electron-to-chromium-1.5.32.tgz -> npmpkg-electron-to-chromium-1.5.32.tgz
https://registry.npmjs.org/entities/-/entities-4.5.0.tgz -> npmpkg-entities-4.5.0.tgz
https://registry.npmjs.org/es-define-property/-/es-define-property-1.0.0.tgz -> npmpkg-es-define-property-1.0.0.tgz
https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz -> npmpkg-es-errors-1.3.0.tgz
https://registry.npmjs.org/es-get-iterator/-/es-get-iterator-1.1.3.tgz -> npmpkg-es-get-iterator-1.1.3.tgz
https://registry.npmjs.org/esbuild/-/esbuild-0.21.5.tgz -> npmpkg-esbuild-0.21.5.tgz
https://registry.npmjs.org/escalade/-/escalade-3.2.0.tgz -> npmpkg-escalade-3.2.0.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-5.0.0.tgz -> npmpkg-escape-string-regexp-5.0.0.tgz
https://registry.npmjs.org/estree-util-is-identifier-name/-/estree-util-is-identifier-name-3.0.0.tgz -> npmpkg-estree-util-is-identifier-name-3.0.0.tgz
https://registry.npmjs.org/estree-walker/-/estree-walker-3.0.3.tgz -> npmpkg-estree-walker-3.0.3.tgz
https://registry.npmjs.org/eventemitter3/-/eventemitter3-5.0.1.tgz -> npmpkg-eventemitter3-5.0.1.tgz
https://registry.npmjs.org/execa/-/execa-8.0.1.tgz -> npmpkg-execa-8.0.1.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-5.3.0.tgz -> npmpkg-npm-run-path-5.3.0.tgz
https://registry.npmjs.org/path-key/-/path-key-4.0.0.tgz -> npmpkg-path-key-4.0.0.tgz
https://registry.npmjs.org/extend/-/extend-3.0.2.tgz -> npmpkg-extend-3.0.2.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.2.tgz -> npmpkg-fast-glob-3.3.2.tgz
https://registry.npmjs.org/fastq/-/fastq-1.17.1.tgz -> npmpkg-fastq-1.17.1.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz -> npmpkg-fill-range-7.1.1.tgz
https://registry.npmjs.org/for-each/-/for-each-0.3.3.tgz -> npmpkg-for-each-0.3.3.tgz
https://registry.npmjs.org/form-data/-/form-data-4.0.0.tgz -> npmpkg-form-data-4.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-11.2.0.tgz -> npmpkg-fs-extra-11.2.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz -> npmpkg-function-bind-1.1.2.tgz
https://registry.npmjs.org/functions-have-names/-/functions-have-names-1.2.3.tgz -> npmpkg-functions-have-names-1.2.3.tgz
https://registry.npmjs.org/gensync/-/gensync-1.0.0-beta.2.tgz -> npmpkg-gensync-1.0.0-beta.2.tgz
https://registry.npmjs.org/get-func-name/-/get-func-name-2.0.2.tgz -> npmpkg-get-func-name-2.0.2.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.4.tgz -> npmpkg-get-intrinsic-1.2.4.tgz
https://registry.npmjs.org/get-nonce/-/get-nonce-1.0.1.tgz -> npmpkg-get-nonce-1.0.1.tgz
https://registry.npmjs.org/get-stream/-/get-stream-8.0.1.tgz -> npmpkg-get-stream-8.0.1.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/globals/-/globals-11.12.0.tgz -> npmpkg-globals-11.12.0.tgz
https://registry.npmjs.org/globrex/-/globrex-0.1.2.tgz -> npmpkg-globrex-0.1.2.tgz
https://registry.npmjs.org/gopd/-/gopd-1.0.1.tgz -> npmpkg-gopd-1.0.1.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz -> npmpkg-graceful-fs-4.2.11.tgz
https://registry.npmjs.org/has-bigints/-/has-bigints-1.0.2.tgz -> npmpkg-has-bigints-1.0.2.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.2.tgz -> npmpkg-has-property-descriptors-1.0.2.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.3.tgz -> npmpkg-has-proto-1.0.3.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/has-tostringtag/-/has-tostringtag-1.0.2.tgz -> npmpkg-has-tostringtag-1.0.2.tgz
https://registry.npmjs.org/hasown/-/hasown-2.0.2.tgz -> npmpkg-hasown-2.0.2.tgz
https://registry.npmjs.org/hast-util-to-jsx-runtime/-/hast-util-to-jsx-runtime-2.3.0.tgz -> npmpkg-hast-util-to-jsx-runtime-2.3.0.tgz
https://registry.npmjs.org/hast-util-whitespace/-/hast-util-whitespace-3.0.0.tgz -> npmpkg-hast-util-whitespace-3.0.0.tgz
https://registry.npmjs.org/html-encoding-sniffer/-/html-encoding-sniffer-4.0.0.tgz -> npmpkg-html-encoding-sniffer-4.0.0.tgz
https://registry.npmjs.org/html-parse-stringify/-/html-parse-stringify-3.0.1.tgz -> npmpkg-html-parse-stringify-3.0.1.tgz
https://registry.npmjs.org/html-url-attributes/-/html-url-attributes-3.0.1.tgz -> npmpkg-html-url-attributes-3.0.1.tgz
https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-7.0.2.tgz -> npmpkg-http-proxy-agent-7.0.2.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-7.0.5.tgz -> npmpkg-https-proxy-agent-7.0.5.tgz
https://registry.npmjs.org/human-signals/-/human-signals-5.0.0.tgz -> npmpkg-human-signals-5.0.0.tgz
https://registry.npmjs.org/i18next/-/i18next-23.15.2.tgz -> npmpkg-i18next-23.15.2.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz -> npmpkg-iconv-lite-0.6.3.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/inline-style-parser/-/inline-style-parser-0.2.4.tgz -> npmpkg-inline-style-parser-0.2.4.tgz
https://registry.npmjs.org/internal-slot/-/internal-slot-1.0.7.tgz -> npmpkg-internal-slot-1.0.7.tgz
https://registry.npmjs.org/invariant/-/invariant-2.2.4.tgz -> npmpkg-invariant-2.2.4.tgz
https://registry.npmjs.org/is-alphabetical/-/is-alphabetical-2.0.1.tgz -> npmpkg-is-alphabetical-2.0.1.tgz
https://registry.npmjs.org/is-alphanumerical/-/is-alphanumerical-2.0.1.tgz -> npmpkg-is-alphanumerical-2.0.1.tgz
https://registry.npmjs.org/is-arguments/-/is-arguments-1.1.1.tgz -> npmpkg-is-arguments-1.1.1.tgz
https://registry.npmjs.org/is-array-buffer/-/is-array-buffer-3.0.4.tgz -> npmpkg-is-array-buffer-3.0.4.tgz
https://registry.npmjs.org/is-bigint/-/is-bigint-1.0.4.tgz -> npmpkg-is-bigint-1.0.4.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz -> npmpkg-is-binary-path-2.1.0.tgz
https://registry.npmjs.org/is-boolean-object/-/is-boolean-object-1.1.2.tgz -> npmpkg-is-boolean-object-1.1.2.tgz
https://registry.npmjs.org/is-callable/-/is-callable-1.2.7.tgz -> npmpkg-is-callable-1.2.7.tgz
https://registry.npmjs.org/is-date-object/-/is-date-object-1.0.5.tgz -> npmpkg-is-date-object-1.0.5.tgz
https://registry.npmjs.org/is-decimal/-/is-decimal-2.0.1.tgz -> npmpkg-is-decimal-2.0.1.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/is-hexadecimal/-/is-hexadecimal-2.0.1.tgz -> npmpkg-is-hexadecimal-2.0.1.tgz
https://registry.npmjs.org/is-map/-/is-map-2.0.3.tgz -> npmpkg-is-map-2.0.3.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/is-number-object/-/is-number-object-1.0.7.tgz -> npmpkg-is-number-object-1.0.7.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-4.1.0.tgz -> npmpkg-is-plain-obj-4.1.0.tgz
https://registry.npmjs.org/is-potential-custom-element-name/-/is-potential-custom-element-name-1.0.1.tgz -> npmpkg-is-potential-custom-element-name-1.0.1.tgz
https://registry.npmjs.org/is-regex/-/is-regex-1.1.4.tgz -> npmpkg-is-regex-1.1.4.tgz
https://registry.npmjs.org/is-set/-/is-set-2.0.3.tgz -> npmpkg-is-set-2.0.3.tgz
https://registry.npmjs.org/is-shared-array-buffer/-/is-shared-array-buffer-1.0.3.tgz -> npmpkg-is-shared-array-buffer-1.0.3.tgz
https://registry.npmjs.org/is-stream/-/is-stream-3.0.0.tgz -> npmpkg-is-stream-3.0.0.tgz
https://registry.npmjs.org/is-string/-/is-string-1.0.7.tgz -> npmpkg-is-string-1.0.7.tgz
https://registry.npmjs.org/is-symbol/-/is-symbol-1.0.4.tgz -> npmpkg-is-symbol-1.0.4.tgz
https://registry.npmjs.org/is-weakmap/-/is-weakmap-2.0.2.tgz -> npmpkg-is-weakmap-2.0.2.tgz
https://registry.npmjs.org/is-weakset/-/is-weakset-2.0.3.tgz -> npmpkg-is-weakset-2.0.3.tgz
https://registry.npmjs.org/isarray/-/isarray-2.0.5.tgz -> npmpkg-isarray-2.0.5.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/jest-canvas-mock/-/jest-canvas-mock-2.5.2.tgz -> npmpkg-jest-canvas-mock-2.5.2.tgz
https://registry.npmjs.org/js-sha3/-/js-sha3-0.8.0.tgz -> npmpkg-js-sha3-0.8.0.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz -> npmpkg-js-tokens-4.0.0.tgz
https://registry.npmjs.org/jsdom/-/jsdom-24.1.3.tgz -> npmpkg-jsdom-24.1.3.tgz
https://registry.npmjs.org/jsesc/-/jsesc-3.0.2.tgz -> npmpkg-jsesc-3.0.2.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/local-pkg/-/local-pkg-0.5.0.tgz -> npmpkg-local-pkg-0.5.0.tgz
https://registry.npmjs.org/longest-streak/-/longest-streak-3.1.0.tgz -> npmpkg-longest-streak-3.1.0.tgz
https://registry.npmjs.org/loose-envify/-/loose-envify-1.4.0.tgz -> npmpkg-loose-envify-1.4.0.tgz
https://registry.npmjs.org/loupe/-/loupe-2.3.7.tgz -> npmpkg-loupe-2.3.7.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-5.1.1.tgz -> npmpkg-lru-cache-5.1.1.tgz
https://registry.npmjs.org/lz-string/-/lz-string-1.5.0.tgz -> npmpkg-lz-string-1.5.0.tgz
https://registry.npmjs.org/magic-string/-/magic-string-0.30.11.tgz -> npmpkg-magic-string-0.30.11.tgz
https://registry.npmjs.org/make-error/-/make-error-1.3.6.tgz -> npmpkg-make-error-1.3.6.tgz
https://registry.npmjs.org/markdown-table/-/markdown-table-3.0.3.tgz -> npmpkg-markdown-table-3.0.3.tgz
https://registry.npmjs.org/match-sorter/-/match-sorter-6.3.4.tgz -> npmpkg-match-sorter-6.3.4.tgz
https://registry.npmjs.org/mdast-util-find-and-replace/-/mdast-util-find-and-replace-3.0.1.tgz -> npmpkg-mdast-util-find-and-replace-3.0.1.tgz
https://registry.npmjs.org/mdast-util-from-markdown/-/mdast-util-from-markdown-2.0.1.tgz -> npmpkg-mdast-util-from-markdown-2.0.1.tgz
https://registry.npmjs.org/mdast-util-gfm/-/mdast-util-gfm-3.0.0.tgz -> npmpkg-mdast-util-gfm-3.0.0.tgz
https://registry.npmjs.org/mdast-util-gfm-autolink-literal/-/mdast-util-gfm-autolink-literal-2.0.1.tgz -> npmpkg-mdast-util-gfm-autolink-literal-2.0.1.tgz
https://registry.npmjs.org/mdast-util-gfm-footnote/-/mdast-util-gfm-footnote-2.0.0.tgz -> npmpkg-mdast-util-gfm-footnote-2.0.0.tgz
https://registry.npmjs.org/mdast-util-gfm-strikethrough/-/mdast-util-gfm-strikethrough-2.0.0.tgz -> npmpkg-mdast-util-gfm-strikethrough-2.0.0.tgz
https://registry.npmjs.org/mdast-util-gfm-table/-/mdast-util-gfm-table-2.0.0.tgz -> npmpkg-mdast-util-gfm-table-2.0.0.tgz
https://registry.npmjs.org/mdast-util-gfm-task-list-item/-/mdast-util-gfm-task-list-item-2.0.0.tgz -> npmpkg-mdast-util-gfm-task-list-item-2.0.0.tgz
https://registry.npmjs.org/mdast-util-mdx-expression/-/mdast-util-mdx-expression-2.0.1.tgz -> npmpkg-mdast-util-mdx-expression-2.0.1.tgz
https://registry.npmjs.org/mdast-util-mdx-jsx/-/mdast-util-mdx-jsx-3.1.3.tgz -> npmpkg-mdast-util-mdx-jsx-3.1.3.tgz
https://registry.npmjs.org/mdast-util-mdxjs-esm/-/mdast-util-mdxjs-esm-2.0.1.tgz -> npmpkg-mdast-util-mdxjs-esm-2.0.1.tgz
https://registry.npmjs.org/mdast-util-phrasing/-/mdast-util-phrasing-4.1.0.tgz -> npmpkg-mdast-util-phrasing-4.1.0.tgz
https://registry.npmjs.org/mdast-util-to-hast/-/mdast-util-to-hast-13.2.0.tgz -> npmpkg-mdast-util-to-hast-13.2.0.tgz
https://registry.npmjs.org/mdast-util-to-markdown/-/mdast-util-to-markdown-2.1.0.tgz -> npmpkg-mdast-util-to-markdown-2.1.0.tgz
https://registry.npmjs.org/mdast-util-to-string/-/mdast-util-to-string-4.0.0.tgz -> npmpkg-mdast-util-to-string-4.0.0.tgz
https://registry.npmjs.org/merge-stream/-/merge-stream-2.0.0.tgz -> npmpkg-merge-stream-2.0.0.tgz
https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz -> npmpkg-merge2-1.4.1.tgz
https://registry.npmjs.org/micromark/-/micromark-4.0.0.tgz -> npmpkg-micromark-4.0.0.tgz
https://registry.npmjs.org/micromark-core-commonmark/-/micromark-core-commonmark-2.0.1.tgz -> npmpkg-micromark-core-commonmark-2.0.1.tgz
https://registry.npmjs.org/micromark-extension-gfm/-/micromark-extension-gfm-3.0.0.tgz -> npmpkg-micromark-extension-gfm-3.0.0.tgz
https://registry.npmjs.org/micromark-extension-gfm-autolink-literal/-/micromark-extension-gfm-autolink-literal-2.1.0.tgz -> npmpkg-micromark-extension-gfm-autolink-literal-2.1.0.tgz
https://registry.npmjs.org/micromark-extension-gfm-footnote/-/micromark-extension-gfm-footnote-2.1.0.tgz -> npmpkg-micromark-extension-gfm-footnote-2.1.0.tgz
https://registry.npmjs.org/micromark-extension-gfm-strikethrough/-/micromark-extension-gfm-strikethrough-2.1.0.tgz -> npmpkg-micromark-extension-gfm-strikethrough-2.1.0.tgz
https://registry.npmjs.org/micromark-extension-gfm-table/-/micromark-extension-gfm-table-2.1.0.tgz -> npmpkg-micromark-extension-gfm-table-2.1.0.tgz
https://registry.npmjs.org/micromark-extension-gfm-tagfilter/-/micromark-extension-gfm-tagfilter-2.0.0.tgz -> npmpkg-micromark-extension-gfm-tagfilter-2.0.0.tgz
https://registry.npmjs.org/micromark-extension-gfm-task-list-item/-/micromark-extension-gfm-task-list-item-2.1.0.tgz -> npmpkg-micromark-extension-gfm-task-list-item-2.1.0.tgz
https://registry.npmjs.org/micromark-factory-destination/-/micromark-factory-destination-2.0.0.tgz -> npmpkg-micromark-factory-destination-2.0.0.tgz
https://registry.npmjs.org/micromark-factory-label/-/micromark-factory-label-2.0.0.tgz -> npmpkg-micromark-factory-label-2.0.0.tgz
https://registry.npmjs.org/micromark-factory-space/-/micromark-factory-space-2.0.0.tgz -> npmpkg-micromark-factory-space-2.0.0.tgz
https://registry.npmjs.org/micromark-factory-title/-/micromark-factory-title-2.0.0.tgz -> npmpkg-micromark-factory-title-2.0.0.tgz
https://registry.npmjs.org/micromark-factory-whitespace/-/micromark-factory-whitespace-2.0.0.tgz -> npmpkg-micromark-factory-whitespace-2.0.0.tgz
https://registry.npmjs.org/micromark-util-character/-/micromark-util-character-2.1.0.tgz -> npmpkg-micromark-util-character-2.1.0.tgz
https://registry.npmjs.org/micromark-util-chunked/-/micromark-util-chunked-2.0.0.tgz -> npmpkg-micromark-util-chunked-2.0.0.tgz
https://registry.npmjs.org/micromark-util-classify-character/-/micromark-util-classify-character-2.0.0.tgz -> npmpkg-micromark-util-classify-character-2.0.0.tgz
https://registry.npmjs.org/micromark-util-combine-extensions/-/micromark-util-combine-extensions-2.0.0.tgz -> npmpkg-micromark-util-combine-extensions-2.0.0.tgz
https://registry.npmjs.org/micromark-util-decode-numeric-character-reference/-/micromark-util-decode-numeric-character-reference-2.0.1.tgz -> npmpkg-micromark-util-decode-numeric-character-reference-2.0.1.tgz
https://registry.npmjs.org/micromark-util-decode-string/-/micromark-util-decode-string-2.0.0.tgz -> npmpkg-micromark-util-decode-string-2.0.0.tgz
https://registry.npmjs.org/micromark-util-encode/-/micromark-util-encode-2.0.0.tgz -> npmpkg-micromark-util-encode-2.0.0.tgz
https://registry.npmjs.org/micromark-util-html-tag-name/-/micromark-util-html-tag-name-2.0.0.tgz -> npmpkg-micromark-util-html-tag-name-2.0.0.tgz
https://registry.npmjs.org/micromark-util-normalize-identifier/-/micromark-util-normalize-identifier-2.0.0.tgz -> npmpkg-micromark-util-normalize-identifier-2.0.0.tgz
https://registry.npmjs.org/micromark-util-resolve-all/-/micromark-util-resolve-all-2.0.0.tgz -> npmpkg-micromark-util-resolve-all-2.0.0.tgz
https://registry.npmjs.org/micromark-util-sanitize-uri/-/micromark-util-sanitize-uri-2.0.0.tgz -> npmpkg-micromark-util-sanitize-uri-2.0.0.tgz
https://registry.npmjs.org/micromark-util-subtokenize/-/micromark-util-subtokenize-2.0.1.tgz -> npmpkg-micromark-util-subtokenize-2.0.1.tgz
https://registry.npmjs.org/micromark-util-symbol/-/micromark-util-symbol-2.0.0.tgz -> npmpkg-micromark-util-symbol-2.0.0.tgz
https://registry.npmjs.org/micromark-util-types/-/micromark-util-types-2.0.0.tgz -> npmpkg-micromark-util-types-2.0.0.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.8.tgz -> npmpkg-micromatch-4.0.8.tgz
https://registry.npmjs.org/microseconds/-/microseconds-0.2.0.tgz -> npmpkg-microseconds-0.2.0.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.52.0.tgz -> npmpkg-mime-db-1.52.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.35.tgz -> npmpkg-mime-types-2.1.35.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-4.0.0.tgz -> npmpkg-mimic-fn-4.0.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/mlly/-/mlly-1.7.1.tgz -> npmpkg-mlly-1.7.1.tgz
https://registry.npmjs.org/moo-color/-/moo-color-1.0.3.tgz -> npmpkg-moo-color-1.0.3.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/nano-time/-/nano-time-1.0.0.tgz -> npmpkg-nano-time-1.0.0.tgz
https://registry.npmjs.org/nanoid/-/nanoid-3.3.7.tgz -> npmpkg-nanoid-3.3.7.tgz
https://registry.npmjs.org/node-releases/-/node-releases-2.0.18.tgz -> npmpkg-node-releases-2.0.18.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-4.0.1.tgz -> npmpkg-npm-run-path-4.0.1.tgz
https://registry.npmjs.org/nwsapi/-/nwsapi-2.2.13.tgz -> npmpkg-nwsapi-2.2.13.tgz
https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz -> npmpkg-object-assign-4.1.1.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.13.2.tgz -> npmpkg-object-inspect-1.13.2.tgz
https://registry.npmjs.org/object-is/-/object-is-1.1.6.tgz -> npmpkg-object-is-1.1.6.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/object.assign/-/object.assign-4.1.5.tgz -> npmpkg-object.assign-4.1.5.tgz
https://registry.npmjs.org/oblivious-set/-/oblivious-set-1.0.0.tgz -> npmpkg-oblivious-set-1.0.0.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/onetime/-/onetime-6.0.0.tgz -> npmpkg-onetime-6.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-5.0.0.tgz -> npmpkg-p-limit-5.0.0.tgz
https://registry.npmjs.org/parse-entities/-/parse-entities-4.0.1.tgz -> npmpkg-parse-entities-4.0.1.tgz
https://registry.npmjs.org/@types/unist/-/unist-2.0.11.tgz -> npmpkg-@types-unist-2.0.11.tgz
https://registry.npmjs.org/parse5/-/parse5-7.1.2.tgz -> npmpkg-parse5-7.1.2.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/pathe/-/pathe-1.1.2.tgz -> npmpkg-pathe-1.1.2.tgz
https://registry.npmjs.org/pathval/-/pathval-1.1.1.tgz -> npmpkg-pathval-1.1.1.tgz
https://registry.npmjs.org/phaser/-/phaser-3.85.2.tgz -> npmpkg-phaser-3.85.2.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.1.0.tgz -> npmpkg-picocolors-1.1.0.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/pkg-types/-/pkg-types-1.2.0.tgz -> npmpkg-pkg-types-1.2.0.tgz
https://registry.npmjs.org/possible-typed-array-names/-/possible-typed-array-names-1.0.0.tgz -> npmpkg-possible-typed-array-names-1.0.0.tgz
https://registry.npmjs.org/postcss/-/postcss-8.4.47.tgz -> npmpkg-postcss-8.4.47.tgz
https://registry.npmjs.org/postcss-js/-/postcss-js-4.0.1.tgz -> npmpkg-postcss-js-4.0.1.tgz
https://registry.npmjs.org/postcss-mixins/-/postcss-mixins-9.0.4.tgz -> npmpkg-postcss-mixins-9.0.4.tgz
https://registry.npmjs.org/postcss-nested/-/postcss-nested-6.2.0.tgz -> npmpkg-postcss-nested-6.2.0.tgz
https://registry.npmjs.org/postcss-preset-mantine/-/postcss-preset-mantine-1.17.0.tgz -> npmpkg-postcss-preset-mantine-1.17.0.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-6.1.2.tgz -> npmpkg-postcss-selector-parser-6.1.2.tgz
https://registry.npmjs.org/postcss-simple-vars/-/postcss-simple-vars-7.0.1.tgz -> npmpkg-postcss-simple-vars-7.0.1.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-27.5.1.tgz -> npmpkg-pretty-format-27.5.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/prop-types/-/prop-types-15.8.1.tgz -> npmpkg-prop-types-15.8.1.tgz
https://registry.npmjs.org/react-is/-/react-is-16.13.1.tgz -> npmpkg-react-is-16.13.1.tgz
https://registry.npmjs.org/property-information/-/property-information-6.5.0.tgz -> npmpkg-property-information-6.5.0.tgz
https://registry.npmjs.org/psl/-/psl-1.9.0.tgz -> npmpkg-psl-1.9.0.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz -> npmpkg-punycode-2.3.1.tgz
https://registry.npmjs.org/querystringify/-/querystringify-2.2.0.tgz -> npmpkg-querystringify-2.2.0.tgz
https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz -> npmpkg-queue-microtask-1.2.3.tgz
https://registry.npmjs.org/react/-/react-18.3.1.tgz -> npmpkg-react-18.3.1.tgz
https://registry.npmjs.org/react-dom/-/react-dom-18.3.1.tgz -> npmpkg-react-dom-18.3.1.tgz
https://registry.npmjs.org/react-i18next/-/react-i18next-14.1.3.tgz -> npmpkg-react-i18next-14.1.3.tgz
https://registry.npmjs.org/react-intersection-observer/-/react-intersection-observer-9.13.1.tgz -> npmpkg-react-intersection-observer-9.13.1.tgz
https://registry.npmjs.org/react-is/-/react-is-17.0.2.tgz -> npmpkg-react-is-17.0.2.tgz
https://registry.npmjs.org/react-markdown/-/react-markdown-9.0.1.tgz -> npmpkg-react-markdown-9.0.1.tgz
https://registry.npmjs.org/react-number-format/-/react-number-format-5.4.2.tgz -> npmpkg-react-number-format-5.4.2.tgz
https://registry.npmjs.org/react-query/-/react-query-3.39.3.tgz -> npmpkg-react-query-3.39.3.tgz
https://registry.npmjs.org/react-refresh/-/react-refresh-0.14.2.tgz -> npmpkg-react-refresh-0.14.2.tgz
https://registry.npmjs.org/react-remove-scroll/-/react-remove-scroll-2.6.0.tgz -> npmpkg-react-remove-scroll-2.6.0.tgz
https://registry.npmjs.org/react-remove-scroll-bar/-/react-remove-scroll-bar-2.3.6.tgz -> npmpkg-react-remove-scroll-bar-2.3.6.tgz
https://registry.npmjs.org/react-router/-/react-router-6.26.2.tgz -> npmpkg-react-router-6.26.2.tgz
https://registry.npmjs.org/react-router-dom/-/react-router-dom-6.26.2.tgz -> npmpkg-react-router-dom-6.26.2.tgz
https://registry.npmjs.org/react-style-singleton/-/react-style-singleton-2.2.1.tgz -> npmpkg-react-style-singleton-2.2.1.tgz
https://registry.npmjs.org/react-textarea-autosize/-/react-textarea-autosize-8.5.3.tgz -> npmpkg-react-textarea-autosize-8.5.3.tgz
https://registry.npmjs.org/react-transition-group/-/react-transition-group-4.4.5.tgz -> npmpkg-react-transition-group-4.4.5.tgz
https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz -> npmpkg-readdirp-3.6.0.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.14.1.tgz -> npmpkg-regenerator-runtime-0.14.1.tgz
https://registry.npmjs.org/regexp.prototype.flags/-/regexp.prototype.flags-1.5.3.tgz -> npmpkg-regexp.prototype.flags-1.5.3.tgz
https://registry.npmjs.org/remark-gfm/-/remark-gfm-4.0.0.tgz -> npmpkg-remark-gfm-4.0.0.tgz
https://registry.npmjs.org/remark-parse/-/remark-parse-11.0.0.tgz -> npmpkg-remark-parse-11.0.0.tgz
https://registry.npmjs.org/remark-rehype/-/remark-rehype-11.1.1.tgz -> npmpkg-remark-rehype-11.1.1.tgz
https://registry.npmjs.org/remark-stringify/-/remark-stringify-11.0.0.tgz -> npmpkg-remark-stringify-11.0.0.tgz
https://registry.npmjs.org/remove-accents/-/remove-accents-0.5.0.tgz -> npmpkg-remove-accents-0.5.0.tgz
https://registry.npmjs.org/requires-port/-/requires-port-1.0.0.tgz -> npmpkg-requires-port-1.0.0.tgz
https://registry.npmjs.org/reusify/-/reusify-1.0.4.tgz -> npmpkg-reusify-1.0.4.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/rollup/-/rollup-4.24.0.tgz -> npmpkg-rollup-4.24.0.tgz
https://registry.npmjs.org/rrweb-cssom/-/rrweb-cssom-0.7.1.tgz -> npmpkg-rrweb-cssom-0.7.1.tgz
https://registry.npmjs.org/run-parallel/-/run-parallel-1.2.0.tgz -> npmpkg-run-parallel-1.2.0.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz -> npmpkg-safer-buffer-2.1.2.tgz
https://registry.npmjs.org/saxes/-/saxes-6.0.0.tgz -> npmpkg-saxes-6.0.0.tgz
https://registry.npmjs.org/scheduler/-/scheduler-0.23.2.tgz -> npmpkg-scheduler-0.23.2.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/set-function-length/-/set-function-length-1.2.2.tgz -> npmpkg-set-function-length-1.2.2.tgz
https://registry.npmjs.org/set-function-name/-/set-function-name-2.0.2.tgz -> npmpkg-set-function-name-2.0.2.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.6.tgz -> npmpkg-side-channel-1.0.6.tgz
https://registry.npmjs.org/siginfo/-/siginfo-2.0.0.tgz -> npmpkg-siginfo-2.0.0.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-4.1.0.tgz -> npmpkg-signal-exit-4.1.0.tgz
https://registry.npmjs.org/source-map-js/-/source-map-js-1.2.1.tgz -> npmpkg-source-map-js-1.2.1.tgz
https://registry.npmjs.org/space-separated-tokens/-/space-separated-tokens-2.0.2.tgz -> npmpkg-space-separated-tokens-2.0.2.tgz
https://registry.npmjs.org/stackback/-/stackback-0.0.2.tgz -> npmpkg-stackback-0.0.2.tgz
https://registry.npmjs.org/std-env/-/std-env-3.7.0.tgz -> npmpkg-std-env-3.7.0.tgz
https://registry.npmjs.org/stop-iteration-iterator/-/stop-iteration-iterator-1.0.0.tgz -> npmpkg-stop-iteration-iterator-1.0.0.tgz
https://registry.npmjs.org/stringify-entities/-/stringify-entities-4.0.4.tgz -> npmpkg-stringify-entities-4.0.4.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-3.0.0.tgz -> npmpkg-strip-final-newline-3.0.0.tgz
https://registry.npmjs.org/strip-literal/-/strip-literal-2.1.0.tgz -> npmpkg-strip-literal-2.1.0.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-9.0.0.tgz -> npmpkg-js-tokens-9.0.0.tgz
https://registry.npmjs.org/style-to-object/-/style-to-object-1.0.8.tgz -> npmpkg-style-to-object-1.0.8.tgz
https://registry.npmjs.org/sugarss/-/sugarss-4.0.1.tgz -> npmpkg-sugarss-4.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/symbol-tree/-/symbol-tree-3.2.4.tgz -> npmpkg-symbol-tree-3.2.4.tgz
https://registry.npmjs.org/tabbable/-/tabbable-6.2.0.tgz -> npmpkg-tabbable-6.2.0.tgz
https://github.com/tauri-apps/tauri-plugin-autostart/archive/6e4666fe3462f0534e90ed6bc075394dff1a1bde.tar.gz -> npmpkg-tauri-plugin-autostart.git-6e4666fe3462f0534e90ed6bc075394dff1a1bde.tgz
https://github.com/tauri-apps/tauri-plugin-log/archive/cc86b2d9878d6ec02c9f25bd48292621a4bc2a6f.tar.gz -> npmpkg-tauri-plugin-log.git-cc86b2d9878d6ec02c9f25bd48292621a4bc2a6f.tgz
https://github.com/tauri-apps/tauri-plugin-store/archive/0b7079b8c55bf25f6d9d9e8c57812d03b48a9788.tar.gz -> npmpkg-tauri-plugin-store.git-0b7079b8c55bf25f6d9d9e8c57812d03b48a9788.tgz
https://registry.npmjs.org/tiny-invariant/-/tiny-invariant-1.3.3.tgz -> npmpkg-tiny-invariant-1.3.3.tgz
https://registry.npmjs.org/tinybench/-/tinybench-2.9.0.tgz -> npmpkg-tinybench-2.9.0.tgz
https://registry.npmjs.org/tinypool/-/tinypool-0.8.4.tgz -> npmpkg-tinypool-0.8.4.tgz
https://registry.npmjs.org/tinyspy/-/tinyspy-2.2.1.tgz -> npmpkg-tinyspy-2.2.1.tgz
https://registry.npmjs.org/to-fast-properties/-/to-fast-properties-2.0.0.tgz -> npmpkg-to-fast-properties-2.0.0.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/tough-cookie/-/tough-cookie-4.1.4.tgz -> npmpkg-tough-cookie-4.1.4.tgz
https://registry.npmjs.org/tr46/-/tr46-5.0.0.tgz -> npmpkg-tr46-5.0.0.tgz
https://registry.npmjs.org/trim-lines/-/trim-lines-3.0.1.tgz -> npmpkg-trim-lines-3.0.1.tgz
https://registry.npmjs.org/trough/-/trough-2.2.0.tgz -> npmpkg-trough-2.2.0.tgz
https://registry.npmjs.org/ts-node/-/ts-node-10.9.2.tgz -> npmpkg-ts-node-10.9.2.tgz
https://registry.npmjs.org/tsconfck/-/tsconfck-3.1.3.tgz -> npmpkg-tsconfck-3.1.3.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/type-detect/-/type-detect-4.1.0.tgz -> npmpkg-type-detect-4.1.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-4.26.1.tgz -> npmpkg-type-fest-4.26.1.tgz
https://registry.npmjs.org/typescript/-/typescript-5.6.2.tgz -> npmpkg-typescript-5.6.2.tgz
https://registry.npmjs.org/ufo/-/ufo-1.5.4.tgz -> npmpkg-ufo-1.5.4.tgz
https://registry.npmjs.org/undici-types/-/undici-types-6.19.8.tgz -> npmpkg-undici-types-6.19.8.tgz
https://registry.npmjs.org/unified/-/unified-11.0.5.tgz -> npmpkg-unified-11.0.5.tgz
https://registry.npmjs.org/unist-util-is/-/unist-util-is-6.0.0.tgz -> npmpkg-unist-util-is-6.0.0.tgz
https://registry.npmjs.org/unist-util-position/-/unist-util-position-5.0.0.tgz -> npmpkg-unist-util-position-5.0.0.tgz
https://registry.npmjs.org/unist-util-stringify-position/-/unist-util-stringify-position-4.0.0.tgz -> npmpkg-unist-util-stringify-position-4.0.0.tgz
https://registry.npmjs.org/unist-util-visit/-/unist-util-visit-5.0.0.tgz -> npmpkg-unist-util-visit-5.0.0.tgz
https://registry.npmjs.org/unist-util-visit-parents/-/unist-util-visit-parents-6.0.1.tgz -> npmpkg-unist-util-visit-parents-6.0.1.tgz
https://registry.npmjs.org/universalify/-/universalify-0.2.0.tgz -> npmpkg-universalify-0.2.0.tgz
https://registry.npmjs.org/unload/-/unload-2.2.0.tgz -> npmpkg-unload-2.2.0.tgz
https://registry.npmjs.org/update-browserslist-db/-/update-browserslist-db-1.1.1.tgz -> npmpkg-update-browserslist-db-1.1.1.tgz
https://registry.npmjs.org/url-parse/-/url-parse-1.5.10.tgz -> npmpkg-url-parse-1.5.10.tgz
https://registry.npmjs.org/use-callback-ref/-/use-callback-ref-1.3.2.tgz -> npmpkg-use-callback-ref-1.3.2.tgz
https://registry.npmjs.org/use-composed-ref/-/use-composed-ref-1.3.0.tgz -> npmpkg-use-composed-ref-1.3.0.tgz
https://registry.npmjs.org/use-isomorphic-layout-effect/-/use-isomorphic-layout-effect-1.1.2.tgz -> npmpkg-use-isomorphic-layout-effect-1.1.2.tgz
https://registry.npmjs.org/use-latest/-/use-latest-1.2.1.tgz -> npmpkg-use-latest-1.2.1.tgz
https://registry.npmjs.org/use-sidecar/-/use-sidecar-1.1.2.tgz -> npmpkg-use-sidecar-1.1.2.tgz
https://registry.npmjs.org/use-sync-external-store/-/use-sync-external-store-1.2.2.tgz -> npmpkg-use-sync-external-store-1.2.2.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/v8-compile-cache-lib/-/v8-compile-cache-lib-3.0.1.tgz -> npmpkg-v8-compile-cache-lib-3.0.1.tgz
https://registry.npmjs.org/vfile/-/vfile-6.0.3.tgz -> npmpkg-vfile-6.0.3.tgz
https://registry.npmjs.org/vfile-message/-/vfile-message-4.0.2.tgz -> npmpkg-vfile-message-4.0.2.tgz
https://registry.npmjs.org/vite/-/vite-5.4.8.tgz -> npmpkg-vite-5.4.8.tgz
https://registry.npmjs.org/vite-node/-/vite-node-1.6.0.tgz -> npmpkg-vite-node-1.6.0.tgz
https://registry.npmjs.org/vite-plugin-checker/-/vite-plugin-checker-0.6.4.tgz -> npmpkg-vite-plugin-checker-0.6.4.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/vite-tsconfig-paths/-/vite-tsconfig-paths-4.3.2.tgz -> npmpkg-vite-tsconfig-paths-4.3.2.tgz
https://registry.npmjs.org/vitest/-/vitest-1.6.0.tgz -> npmpkg-vitest-1.6.0.tgz
https://registry.npmjs.org/vitest-canvas-mock/-/vitest-canvas-mock-0.3.3.tgz -> npmpkg-vitest-canvas-mock-0.3.3.tgz
https://registry.npmjs.org/void-elements/-/void-elements-3.1.0.tgz -> npmpkg-void-elements-3.1.0.tgz
https://registry.npmjs.org/vscode-jsonrpc/-/vscode-jsonrpc-6.0.0.tgz -> npmpkg-vscode-jsonrpc-6.0.0.tgz
https://registry.npmjs.org/vscode-languageclient/-/vscode-languageclient-7.0.0.tgz -> npmpkg-vscode-languageclient-7.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/vscode-languageserver/-/vscode-languageserver-7.0.0.tgz -> npmpkg-vscode-languageserver-7.0.0.tgz
https://registry.npmjs.org/vscode-languageserver-protocol/-/vscode-languageserver-protocol-3.16.0.tgz -> npmpkg-vscode-languageserver-protocol-3.16.0.tgz
https://registry.npmjs.org/vscode-languageserver-textdocument/-/vscode-languageserver-textdocument-1.0.12.tgz -> npmpkg-vscode-languageserver-textdocument-1.0.12.tgz
https://registry.npmjs.org/vscode-languageserver-types/-/vscode-languageserver-types-3.16.0.tgz -> npmpkg-vscode-languageserver-types-3.16.0.tgz
https://registry.npmjs.org/vscode-uri/-/vscode-uri-3.0.8.tgz -> npmpkg-vscode-uri-3.0.8.tgz
https://registry.npmjs.org/w3c-xmlserializer/-/w3c-xmlserializer-5.0.0.tgz -> npmpkg-w3c-xmlserializer-5.0.0.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-7.0.0.tgz -> npmpkg-webidl-conversions-7.0.0.tgz
https://registry.npmjs.org/whatwg-encoding/-/whatwg-encoding-3.1.1.tgz -> npmpkg-whatwg-encoding-3.1.1.tgz
https://registry.npmjs.org/whatwg-mimetype/-/whatwg-mimetype-4.0.0.tgz -> npmpkg-whatwg-mimetype-4.0.0.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-14.0.0.tgz -> npmpkg-whatwg-url-14.0.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> npmpkg-which-boxed-primitive-1.0.2.tgz
https://registry.npmjs.org/which-collection/-/which-collection-1.0.2.tgz -> npmpkg-which-collection-1.0.2.tgz
https://registry.npmjs.org/which-typed-array/-/which-typed-array-1.1.15.tgz -> npmpkg-which-typed-array-1.1.15.tgz
https://registry.npmjs.org/why-is-node-running/-/why-is-node-running-2.3.0.tgz -> npmpkg-why-is-node-running-2.3.0.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/ws/-/ws-8.18.0.tgz -> npmpkg-ws-8.18.0.tgz
https://registry.npmjs.org/xml-name-validator/-/xml-name-validator-5.0.0.tgz -> npmpkg-xml-name-validator-5.0.0.tgz
https://registry.npmjs.org/xmlchars/-/xmlchars-2.2.0.tgz -> npmpkg-xmlchars-2.2.0.tgz
https://registry.npmjs.org/yallist/-/yallist-3.1.1.tgz -> npmpkg-yallist-3.1.1.tgz
https://registry.npmjs.org/yn/-/yn-3.1.1.tgz -> npmpkg-yn-3.1.1.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-1.1.1.tgz -> npmpkg-yocto-queue-1.1.1.tgz
https://registry.npmjs.org/zustand/-/zustand-4.5.5.tgz -> npmpkg-zustand-4.5.5.tgz
https://registry.npmjs.org/zwitch/-/zwitch-2.0.4.tgz -> npmpkg-zwitch-2.0.4.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS

SRC_URI="
$(cargo_crate_uris ${CRATES})
${NPM_EXTERNAL_URIS}
https://github.com/SeakMengs/WindowPet/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="Adorable anime pet companions on your screen"
HOMEPAGE="
https://github.com/SeakMengs/WindowPet
"
# From cargo or npm packages
THIRD_PARTY_LICENSES="
	0BSD
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	BSD
	BSD-2
	BZIP2
	MIT
	Boost-1.0
	CC0-1.0
	CC-BY-3.0
	CC-BY-4.0
	ISC
	Unicode-DFS-2016
	Unlicense
	UoI-NCSA
	W3C-Community-Final-Specification-Agreement
	W3C-Software-and-Document-Notice-and-License
	ZLIB
	|| (
		Apache-2.0
		MIT
	)
"
LICENSE="
	${THIRD_PARTY_LICENSES}
	MIT
"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
tray wayland +X
ebuild_revision_1
"
REQUIRED_USE="
	|| (
		wayland
		X
	)
"
# U 20.04
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
gen_webkit_depend() {
	local s
	for s in ${WEBKIT_GTK_STABLE[@]} ; do
		echo "=net-libs/webkit-gtk-${s}*:4[javascript,introspection,wayland?,X?]"
	done
}
# React depends has been relaxed
# See https://github.com/facebook/react/blob/v18.2.0/package.json#L103
TYPESCRIPT_DEPEND="
	(
                >=net-libs/nodejs-20.1
	)
"
REACT_DEPEND="
	(
                >=net-libs/nodejs-12.17
                <net-libs/nodejs-21
	)
"
# U 22.04.3
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
"
RUST_BINDINGS_BDEPEND="
	virtual/pkgconfig
"
RDEPEND+="
	${RUST_BINDINGS_DEPEND}
	${REACT_DEPEND}
	${TYPESCRIPT_DEPEND}
	>=gnome-base/librsvg-2.52.5:2
	>=net-libs/nodejs-20.10:20[npm]
	>=net-libs/webkit-gtk-2.42.3:4.0[wayland?,X?]
	>=x11-libs/gtk+-3.24.33:3[wayland?,X?]
	sys-process/procps
	X? (
		x11-misc/xcompmgr
	)
	|| (
		dev-libs/libappindicator
		dev-libs/libayatana-appindicator
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND="
	${RUST_BINDINGS_BDEPEND}
	>=dev-util/patchelf-0.14.3
"

pkg_setup() {
	npm_pkg_setup
	npm_check_network_sandbox
}

# @FUNCTION: cargo_src_unpack
# @DESCRIPTION:
# Unpacks the package and the cargo registry.
# From cargo.eclass
_cargo_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	mkdir -p "${ECARGO_VENDOR}" || die
	mkdir -p "${S}" || die

	local archive shasum pkg
	for archive in ${A}; do
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

src_unpack() {
	unpack ${P}.tar.gz

	if [[ -e "${FILESDIR}/${PV}/Cargo.lock" ]] ; then
		cp -a \
			"${FILESDIR}/${PV}/Cargo.lock" \
			"${FILESDIR}/${PV}/Cargo.toml" \
			"${WORKDIR}/${MY_PN}-${PV}/src-tauri" \
			|| die
	else
ewarn "Missing security updated Cargo.lock"
	fi

einfo "Unpacking npm side"
	S="${WORKDIR}/${MY_PN}-${PV}" \
	npm_src_unpack
	S="${WORKDIR}/${MY_PN}-${PV}" \
	enpm i --save-dev "@types/testing-library__react"

einfo "Unpacking tauri side"
	pushd "${WORKDIR}/${MY_PN}-${PV}/src-tauri" || die
		S="${WORKDIR}/${MY_PN}-${PV}/src-tauri" \
		_cargo_src_unpack
	popd

	cd "${WORKDIR}" || die
	local commit="${PLUGINS_WORKSPACE_COMMIT}"
	mkdir -p "${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/autostart" || die
	mkdir -p "${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/log" || die
	mkdir -p "${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/single-instance" || die
	mkdir -p "${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/store" || die
	unpack "${DISTDIR}/plugins-workspace-${commit}.gh.tar.gz"
	cp -aT \
		"${WORKDIR}/plugins-workspace-${commit}/plugins/autostart" \
		"${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/autostart" \
		|| die
	cp -aT \
		"${WORKDIR}/plugins-workspace-${commit}/plugins/log" \
		"${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/log" \
		|| die
	cp -aT \
		"${WORKDIR}/plugins-workspace-${commit}/plugins/single-instance" \
		"${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/single-instance" \
		|| die
	cp -aT \
		"${WORKDIR}/plugins-workspace-${commit}/plugins/store" \
		"${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/store" \
		|| die
}

src_configure() {
	pushd "${WORKDIR}/${MY_PN}-${PV}/src-tauri" || die
		S="${WORKDIR}/${MY_PN}-${PV}/src-tauri" \
		cargo_src_configure
	popd
}

src_compile() {
einfo "Building npm side"
	S="${WORKDIR}/${MY_PN}-${PV}" \
	npm_src_compile
	grep -e "- error TS" "${T}/build.log" && die "Detected error.  Emerge again."
einfo "Building tauri side"
	enpm run tauri build
#
# Running cargo_src_compile doesn't work because tauri.conf.json with tauri does
# more extra build steps.
#
#	pushd "${WORKDIR}/${MY_PN}-${PV}/src-tauri" || die
#einfo "Building tauri side"
#		S="${WORKDIR}/${MY_PN}-${PV}/src-tauri" \
#		cargo_src_compile
#	popd
}

gen_wrapper() {
	dodir /usr/bin
cat <<EOF > "${ED}/usr/bin/window-pet"
#!/bin/bash
if ! pgrep "xcompmgr" && [[ -n "\${DISPLAY}" ]] ; then
	xcompmgr 2>/dev/null &
	window-pet-bin
	killall xcompmgr "\$@"
else
	window-pet-bin "\$@"
fi
EOF
	fperms 0755 /usr/bin/window-pet
}

src_install() {
	exeinto /usr/bin
	newexe src-tauri/target/release/window-pet window-pet-bin
	gen_wrapper

	make_desktop_entry \
		"window-pet" \
		"${PN}" \
		"window-pet" \
		"Office;"

	newicon -s 32 public/media/icon.png window-pet.png
	newicon -s 128 public/media/icon.png window-pet.png
	newicon -s 256 public/media/icon.png window-pet.png

	LCNR_SOURCE="${WORKDIR}/cargo_home/gentoo"
	LCNR_TAG="third_party_cargo"
	lcnr_install_files

	LCNR_SOURCE="${WORKDIR}/${MY_PN}-${PV}/node_modules"
	LCNR_TAG="third_party_npm"
	lcnr_install_files
}

pkg_postinst() {
	xdg_pkg_postinst
	if use X ; then
einfo
einfo "You will need to start xcompmgr in X to have transparent window support."
einfo
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  passed (0.0.6, 20231215) on X
# OILEDMACHINE-OVERLAY-TEST:  passed (0.0.7, 20240413) on X
# OILEDMACHINE-OVERLAY-TEST:  passed (0.0.8, 20240621) on X
