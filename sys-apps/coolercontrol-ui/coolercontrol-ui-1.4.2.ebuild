# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 22.04

# NPM_AUDIT_FIX=0

# To update npm side use:
# PATH="/usr/local/oiledmachine-overlay/scripts:${PATH}"
# NPM_UPDATER_PROJECT_ROOT="coolercontrol-1.4.2/coolercontrol-ui" NPM_UPDATER_VERSIONS="1.4.2" npm_updater_update_locks.sh

# To update cargo side use:
# ./convert-cargo-lock.sh 1.4.2 1.4.2

PLUGINS_WORKSPACE_COMMIT="5e3900e682e13f3759b439116ae2f77a6d389ca2" # Same as below

declare -A GIT_CRATES=(
[tauri-plugin-cli]="https://github.com/tauri-apps/plugins-workspace;fb85e5dd76688f3ae836890160f9bde843b70167;plugins-workspace-%commit%/plugins/cli" # 2.0.0-rc.1
[tauri-plugin-shell]="https://github.com/tauri-apps/plugins-workspace;fb85e5dd76688f3ae836890160f9bde843b70167;plugins-workspace-%commit%/plugins/shell" # 2.0.0-rc.3
[tauri-plugin-store]="https://github.com/tauri-apps/plugins-workspace;fb85e5dd76688f3ae836890160f9bde843b70167;plugins-workspace-%commit%/plugins/store" # 2.0.0-rc.3
)

CRATES="
addr2line-0.24.1
adler-1.0.2
adler2-2.0.0
aho-corasick-1.1.3
alloc-no-stdlib-2.0.4
alloc-stdlib-0.2.2
android-tzdata-0.1.1
android_system_properties-0.1.5
anstream-0.6.15
anstyle-1.0.8
anstyle-parse-0.2.5
anstyle-query-1.1.1
anstyle-wincon-3.0.4
anyhow-1.0.89
arboard-3.4.1
ascii-1.1.0
async-broadcast-0.7.1
async-channel-2.3.1
async-executor-1.13.1
async-fs-2.1.2
async-io-2.3.4
async-lock-3.4.0
async-process-2.3.0
async-recursion-1.1.1
async-signal-0.2.10
async-task-4.7.1
async-trait-0.1.82
atk-0.18.0
atk-sys-0.18.0
atomic-waker-1.1.2
autocfg-1.3.0
backtrace-0.3.74
base64-0.21.7
base64-0.22.1
bit_field-0.10.2
bitflags-1.3.2
bitflags-2.6.0
block-0.1.6
block-buffer-0.10.4
block2-0.5.1
blocking-1.6.1
brotli-6.0.0
brotli-decompressor-4.0.1
bumpalo-3.16.0
bytemuck-1.18.0
byteorder-1.5.0
byteorder-lite-0.1.0
bytes-1.7.1
cairo-rs-0.18.5
cairo-sys-rs-0.18.2
camino-1.1.9
cargo-platform-0.1.8
cargo_metadata-0.18.1
cargo_toml-0.17.2
cc-1.1.20
cesu8-1.1.0
cfb-0.7.3
cfg-expr-0.15.8
cfg-if-1.0.0
cfg_aliases-0.2.1
chrono-0.4.38
chunked_transfer-1.5.0
clap-4.5.17
clap_builder-4.5.17
clap_lex-0.7.2
clipboard-win-5.4.0
cocoa-0.26.0
cocoa-foundation-0.2.0
color_quant-1.1.0
colorchoice-1.0.2
combine-4.6.7
concurrent-queue-2.5.0
convert_case-0.4.0
core-foundation-0.10.0
core-foundation-0.9.4
core-foundation-sys-0.8.7
core-graphics-0.23.2
core-graphics-0.24.0
core-graphics-types-0.1.3
core-graphics-types-0.2.0
cpufeatures-0.2.14
crc32fast-1.4.2
crossbeam-channel-0.5.13
crossbeam-deque-0.8.5
crossbeam-epoch-0.9.18
crossbeam-utils-0.8.20
crunchy-0.2.2
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
dirs-5.0.1
dirs-sys-0.4.1
dispatch-0.2.0
dlopen2-0.7.0
dlopen2_derive-0.4.0
dpi-0.1.1
dtoa-1.0.9
dtoa-short-0.3.5
dunce-1.0.5
dyn-clone-1.0.17
either-1.13.0
embed-resource-2.4.3
embed_plist-1.2.2
encoding_rs-0.8.34
endi-1.1.0
enumflags2-0.7.10
enumflags2_derive-0.7.10
equivalent-1.0.1
erased-serde-0.4.5
errno-0.3.9
error-code-3.3.1
event-listener-5.3.1
event-listener-strategy-0.5.2
exr-1.72.0
fastrand-2.1.1
fdeflate-0.3.4
field-offset-0.3.6
flate2-1.0.33
fluent-uri-0.1.4
flume-0.11.0
fnv-1.0.7
foreign-types-0.5.0
foreign-types-macros-0.2.3
foreign-types-shared-0.3.1
form_urlencoded-1.2.1
futf-0.1.5
futures-channel-0.3.30
futures-core-0.3.30
futures-executor-0.3.30
futures-io-0.3.30
futures-lite-2.3.0
futures-macro-0.3.30
futures-sink-0.3.30
futures-task-0.3.30
futures-util-0.3.30
fxhash-0.2.1
gdk-0.18.0
gdk-pixbuf-0.18.5
gdk-pixbuf-sys-0.18.0
gdk-sys-0.18.0
gdkwayland-sys-0.18.0
gdkx11-0.18.0
gdkx11-sys-0.18.0
generator-0.7.5
generic-array-0.14.7
gethostname-0.4.3
getrandom-0.1.16
getrandom-0.2.15
gif-0.13.1
gimli-0.31.0
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
half-2.4.1
hashbrown-0.12.3
hashbrown-0.14.5
heck-0.4.1
heck-0.5.0
hermit-abi-0.3.9
hermit-abi-0.4.0
hex-0.4.3
html5ever-0.26.0
http-1.1.0
http-body-1.0.1
http-body-util-0.1.2
httparse-1.9.4
httpdate-1.0.3
hyper-1.4.1
hyper-util-0.1.8
iana-time-zone-0.1.61
iana-time-zone-haiku-0.1.2
ico-0.3.0
ident_case-1.0.1
idna-0.5.0
image-0.24.9
image-0.25.2
indexmap-1.9.3
indexmap-2.5.0
infer-0.16.0
instant-0.1.13
ipnet-2.10.0
is-docker-0.2.0
is-wsl-0.4.0
is_terminal_polyfill-1.70.1
itoa-0.4.8
itoa-1.0.11
javascriptcore-rs-1.1.2
javascriptcore-rs-sys-1.1.1
jni-0.21.1
jni-sys-0.3.0
jpeg-decoder-0.3.1
js-sys-0.3.70
json-patch-2.0.0
jsonptr-0.4.7
keyboard-types-0.7.0
kuchikiki-0.8.2
lazy_static-1.5.0
lebe-0.5.2
libappindicator-0.9.0
libappindicator-sys-0.9.0
libc-0.2.158
libloading-0.7.4
libredox-0.1.3
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
memoffset-0.9.1
mime-0.3.17
miniz_oxide-0.7.4
miniz_oxide-0.8.0
mio-1.0.2
muda-0.14.1
ndk-0.9.0
ndk-context-0.1.1
ndk-sys-0.6.0+11769913
new_debug_unreachable-1.0.6
nix-0.27.1
nodrop-0.1.14
nu-ansi-term-0.46.0
num-conv-0.1.0
num-traits-0.2.19
num_enum-0.7.3
num_enum_derive-0.7.3
objc-0.2.7
objc-sys-0.3.5
objc2-0.5.2
objc2-app-kit-0.2.2
objc2-core-data-0.2.2
objc2-core-image-0.2.2
objc2-encode-4.0.3
objc2-foundation-0.2.2
objc2-metal-0.2.2
objc2-quartz-core-0.2.2
objc_exception-0.1.2
objc_id-0.1.1
object-0.36.4
once_cell-1.19.0
open-5.3.0
option-ext-0.2.0
ordered-stream-0.2.0
os_pipe-1.2.1
overload-0.1.1
pango-0.18.3
pango-sys-0.18.0
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
pin-project-1.1.5
pin-project-internal-1.1.5
pin-project-lite-0.2.14
pin-utils-0.1.0
piper-0.2.4
pkg-config-0.3.30
plist-1.7.0
png-0.17.13
polling-3.7.3
powerfmt-0.2.0
ppv-lite86-0.2.20
precomputed-hash-0.1.1
proc-macro-crate-1.3.1
proc-macro-crate-2.0.2
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro-hack-0.5.20+deprecated
proc-macro2-1.0.86
qoi-0.4.1
quick-xml-0.32.0
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
rayon-1.10.0
rayon-core-1.12.1
redox_syscall-0.5.4
redox_users-0.4.6
regex-1.10.6
regex-automata-0.1.10
regex-automata-0.4.7
regex-syntax-0.6.29
regex-syntax-0.8.4
reqwest-0.12.7
rustc-demangle-0.1.24
rustc_version-0.4.1
rustix-0.38.37
rustversion-1.0.17
ryu-1.0.18
same-file-1.0.6
schemars-0.8.21
schemars_derive-0.8.21
scoped-tls-1.0.1
scopeguard-1.2.0
selectors-0.22.0
semver-1.0.23
serde-1.0.210
serde-untagged-0.1.6
serde_derive-1.0.210
serde_derive_internals-0.29.1
serde_json-1.0.128
serde_repr-0.1.19
serde_spanned-0.6.7
serde_urlencoded-0.7.1
serde_with-3.9.0
serde_with_macros-3.9.0
serialize-to-javascript-0.1.1
serialize-to-javascript-impl-0.1.1
servo_arc-0.1.1
sha1-0.10.6
sha2-0.10.8
sharded-slab-0.1.7
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
state-0.6.0
static_assertions-1.1.0
string_cache-0.8.7
string_cache_codegen-0.5.2
strsim-0.11.1
swift-rs-1.0.7
syn-1.0.109
syn-2.0.77
sync_wrapper-1.0.1
system-deps-6.2.2
tao-0.30.0
tao-macros-0.1.3
target-lexicon-0.12.16
tauri-2.0.0-rc.15
tauri-build-2.0.0-rc.12
tauri-codegen-2.0.0-rc.12
tauri-macros-2.0.0-rc.11
tauri-plugin-2.0.0-rc.12
tauri-plugin-clipboard-manager-2.0.0-rc.4
tauri-plugin-localhost-2.0.0-rc.1
tauri-plugin-window-state-2.0.0-rc.5
tauri-runtime-2.0.0-rc.12
tauri-runtime-wry-2.0.0-rc.13
tauri-utils-2.0.0-rc.12
tauri-winres-0.1.1
tempfile-3.12.0
tendril-0.4.3
thin-slice-0.1.1
thiserror-1.0.63
thiserror-impl-1.0.63
thread_local-1.1.8
tiff-0.9.1
time-0.3.36
time-core-0.1.2
time-macros-0.2.18
tiny_http-0.12.0
tinyvec-1.8.0
tinyvec_macros-0.1.1
tokio-1.40.0
tokio-util-0.7.12
toml-0.7.8
toml-0.8.2
toml_datetime-0.6.3
toml_edit-0.19.15
toml_edit-0.20.2
tower-0.4.13
tower-layer-0.3.3
tower-service-0.3.3
tracing-0.1.40
tracing-attributes-0.1.27
tracing-core-0.1.32
tracing-log-0.2.0
tracing-subscriber-0.3.18
tray-icon-0.17.0
try-lock-0.2.5
typeid-1.0.2
typenum-1.17.0
uds_windows-1.1.0
unic-char-property-0.9.0
unic-char-range-0.9.0
unic-common-0.9.0
unic-ucd-ident-0.9.0
unic-ucd-version-0.9.0
unicode-bidi-0.3.15
unicode-ident-1.0.13
unicode-normalization-0.1.23
unicode-segmentation-1.12.0
url-2.5.2
urlpattern-0.3.0
utf-8-0.7.6
utf8parse-0.2.2
uuid-1.10.0
valuable-0.1.0
version-compare-0.2.0
version_check-0.9.5
vswhom-0.1.0
vswhom-sys-0.1.2
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
wasm-streams-0.4.0
web-sys-0.3.70
webkit2gtk-2.0.1
webkit2gtk-sys-2.0.1
webview2-com-0.33.0
webview2-com-macros-0.8.0
webview2-com-sys-0.33.0
weezl-0.1.8
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.9
winapi-x86_64-pc-windows-gnu-0.4.0
window-vibrancy-0.5.2
windows-0.48.0
windows-0.58.0
windows-core-0.52.0
windows-core-0.58.0
windows-implement-0.58.0
windows-interface-0.58.0
windows-registry-0.2.0
windows-result-0.2.0
windows-strings-0.1.0
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
winreg-0.52.0
wry-0.43.1
x11-2.21.0
x11-dl-2.21.0
x11rb-0.13.1
x11rb-protocol-0.13.1
xdg-home-1.3.0
zbus-4.0.1
zbus_macros-4.0.1
zbus_names-3.0.0
zerocopy-0.7.35
zerocopy-derive-0.7.35
zune-inflate-0.2.54
zvariant-4.0.0
zvariant_derive-4.0.0
zvariant_utils-1.1.0
"

# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@babel/helper-string-parser/-/helper-string-parser-7.25.7.tgz -> npmpkg-@babel-helper-string-parser-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.25.7.tgz -> npmpkg-@babel-helper-validator-identifier-7.25.7.tgz
https://registry.npmjs.org/@babel/parser/-/parser-7.25.7.tgz -> npmpkg-@babel-parser-7.25.7.tgz
https://registry.npmjs.org/@babel/types/-/types-7.25.7.tgz -> npmpkg-@babel-types-7.25.7.tgz
https://registry.npmjs.org/@ctrl/tinycolor/-/tinycolor-3.6.1.tgz -> npmpkg-@ctrl-tinycolor-3.6.1.tgz
https://registry.npmjs.org/@element-plus/icons-vue/-/icons-vue-2.3.1.tgz -> npmpkg-@element-plus-icons-vue-2.3.1.tgz
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
https://registry.npmjs.org/@floating-ui/utils/-/utils-0.2.8.tgz -> npmpkg-@floating-ui-utils-0.2.8.tgz
https://registry.npmjs.org/@isaacs/cliui/-/cliui-8.0.2.tgz -> npmpkg-@isaacs-cliui-8.0.2.tgz
https://registry.npmjs.org/@jamescoyle/vue-icon/-/vue-icon-0.1.2.tgz -> npmpkg-@jamescoyle-vue-icon-0.1.2.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.5.0.tgz -> npmpkg-@jridgewell-sourcemap-codec-1.5.0.tgz
https://registry.npmjs.org/@mdi/js/-/js-7.4.47.tgz -> npmpkg-@mdi-js-7.4.47.tgz
https://registry.npmjs.org/@one-ini/wasm/-/wasm-0.1.1.tgz -> npmpkg-@one-ini-wasm-0.1.1.tgz
https://registry.npmjs.org/@pkgjs/parseargs/-/parseargs-0.11.0.tgz -> npmpkg-@pkgjs-parseargs-0.11.0.tgz
https://registry.npmjs.org/@sxzz/popperjs-es/-/popperjs-es-2.11.7.tgz -> npmpkg-@sxzz-popperjs-es-2.11.7.tgz
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
https://registry.npmjs.org/@tauri-apps/api/-/api-2.0.0-rc.5.tgz -> npmpkg-@tauri-apps-api-2.0.0-rc.5.tgz
https://registry.npmjs.org/@trysound/sax/-/sax-0.2.0.tgz -> npmpkg-@trysound-sax-0.2.0.tgz
https://registry.npmjs.org/@tsconfig/node18/-/node18-18.2.4.tgz -> npmpkg-@tsconfig-node18-18.2.4.tgz
https://registry.npmjs.org/@types/d3/-/d3-7.4.3.tgz -> npmpkg-@types-d3-7.4.3.tgz
https://registry.npmjs.org/@types/d3-array/-/d3-array-3.2.1.tgz -> npmpkg-@types-d3-array-3.2.1.tgz
https://registry.npmjs.org/@types/d3-axis/-/d3-axis-3.0.6.tgz -> npmpkg-@types-d3-axis-3.0.6.tgz
https://registry.npmjs.org/@types/d3-brush/-/d3-brush-3.0.6.tgz -> npmpkg-@types-d3-brush-3.0.6.tgz
https://registry.npmjs.org/@types/d3-chord/-/d3-chord-3.0.6.tgz -> npmpkg-@types-d3-chord-3.0.6.tgz
https://registry.npmjs.org/@types/d3-color/-/d3-color-3.1.3.tgz -> npmpkg-@types-d3-color-3.1.3.tgz
https://registry.npmjs.org/@types/d3-contour/-/d3-contour-3.0.6.tgz -> npmpkg-@types-d3-contour-3.0.6.tgz
https://registry.npmjs.org/@types/d3-delaunay/-/d3-delaunay-6.0.4.tgz -> npmpkg-@types-d3-delaunay-6.0.4.tgz
https://registry.npmjs.org/@types/d3-dispatch/-/d3-dispatch-3.0.6.tgz -> npmpkg-@types-d3-dispatch-3.0.6.tgz
https://registry.npmjs.org/@types/d3-drag/-/d3-drag-3.0.7.tgz -> npmpkg-@types-d3-drag-3.0.7.tgz
https://registry.npmjs.org/@types/d3-dsv/-/d3-dsv-3.0.7.tgz -> npmpkg-@types-d3-dsv-3.0.7.tgz
https://registry.npmjs.org/@types/d3-ease/-/d3-ease-3.0.2.tgz -> npmpkg-@types-d3-ease-3.0.2.tgz
https://registry.npmjs.org/@types/d3-fetch/-/d3-fetch-3.0.7.tgz -> npmpkg-@types-d3-fetch-3.0.7.tgz
https://registry.npmjs.org/@types/d3-force/-/d3-force-3.0.10.tgz -> npmpkg-@types-d3-force-3.0.10.tgz
https://registry.npmjs.org/@types/d3-format/-/d3-format-3.0.4.tgz -> npmpkg-@types-d3-format-3.0.4.tgz
https://registry.npmjs.org/@types/d3-geo/-/d3-geo-3.1.0.tgz -> npmpkg-@types-d3-geo-3.1.0.tgz
https://registry.npmjs.org/@types/d3-hierarchy/-/d3-hierarchy-3.1.7.tgz -> npmpkg-@types-d3-hierarchy-3.1.7.tgz
https://registry.npmjs.org/@types/d3-interpolate/-/d3-interpolate-3.0.4.tgz -> npmpkg-@types-d3-interpolate-3.0.4.tgz
https://registry.npmjs.org/@types/d3-path/-/d3-path-3.1.0.tgz -> npmpkg-@types-d3-path-3.1.0.tgz
https://registry.npmjs.org/@types/d3-polygon/-/d3-polygon-3.0.2.tgz -> npmpkg-@types-d3-polygon-3.0.2.tgz
https://registry.npmjs.org/@types/d3-quadtree/-/d3-quadtree-3.0.6.tgz -> npmpkg-@types-d3-quadtree-3.0.6.tgz
https://registry.npmjs.org/@types/d3-random/-/d3-random-3.0.3.tgz -> npmpkg-@types-d3-random-3.0.3.tgz
https://registry.npmjs.org/@types/d3-scale/-/d3-scale-4.0.8.tgz -> npmpkg-@types-d3-scale-4.0.8.tgz
https://registry.npmjs.org/@types/d3-scale-chromatic/-/d3-scale-chromatic-3.0.3.tgz -> npmpkg-@types-d3-scale-chromatic-3.0.3.tgz
https://registry.npmjs.org/@types/d3-selection/-/d3-selection-3.0.10.tgz -> npmpkg-@types-d3-selection-3.0.10.tgz
https://registry.npmjs.org/@types/d3-shape/-/d3-shape-3.1.6.tgz -> npmpkg-@types-d3-shape-3.1.6.tgz
https://registry.npmjs.org/@types/d3-time/-/d3-time-3.0.3.tgz -> npmpkg-@types-d3-time-3.0.3.tgz
https://registry.npmjs.org/@types/d3-time-format/-/d3-time-format-4.0.3.tgz -> npmpkg-@types-d3-time-format-4.0.3.tgz
https://registry.npmjs.org/@types/d3-timer/-/d3-timer-3.0.2.tgz -> npmpkg-@types-d3-timer-3.0.2.tgz
https://registry.npmjs.org/@types/d3-transition/-/d3-transition-3.0.8.tgz -> npmpkg-@types-d3-transition-3.0.8.tgz
https://registry.npmjs.org/@types/d3-zoom/-/d3-zoom-3.0.8.tgz -> npmpkg-@types-d3-zoom-3.0.8.tgz
https://registry.npmjs.org/@types/estree/-/estree-1.0.6.tgz -> npmpkg-@types-estree-1.0.6.tgz
https://registry.npmjs.org/@types/geojson/-/geojson-7946.0.14.tgz -> npmpkg-@types-geojson-7946.0.14.tgz
https://registry.npmjs.org/@types/jsdom/-/jsdom-21.1.7.tgz -> npmpkg-@types-jsdom-21.1.7.tgz
https://registry.npmjs.org/@types/lodash/-/lodash-4.17.10.tgz -> npmpkg-@types-lodash-4.17.10.tgz
https://registry.npmjs.org/@types/lodash-es/-/lodash-es-4.17.12.tgz -> npmpkg-@types-lodash-es-4.17.12.tgz
https://registry.npmjs.org/@types/node/-/node-20.16.10.tgz -> npmpkg-@types-node-20.16.10.tgz
https://registry.npmjs.org/@types/tough-cookie/-/tough-cookie-4.0.5.tgz -> npmpkg-@types-tough-cookie-4.0.5.tgz
https://registry.npmjs.org/@types/uuid/-/uuid-10.0.0.tgz -> npmpkg-@types-uuid-10.0.0.tgz
https://registry.npmjs.org/@types/web-bluetooth/-/web-bluetooth-0.0.16.tgz -> npmpkg-@types-web-bluetooth-0.0.16.tgz
https://registry.npmjs.org/@vitejs/plugin-vue/-/plugin-vue-5.1.4.tgz -> npmpkg-@vitejs-plugin-vue-5.1.4.tgz
https://registry.npmjs.org/@vitest/expect/-/expect-2.1.2.tgz -> npmpkg-@vitest-expect-2.1.2.tgz
https://registry.npmjs.org/@vitest/mocker/-/mocker-2.1.2.tgz -> npmpkg-@vitest-mocker-2.1.2.tgz
https://registry.npmjs.org/@vitest/pretty-format/-/pretty-format-2.1.2.tgz -> npmpkg-@vitest-pretty-format-2.1.2.tgz
https://registry.npmjs.org/@vitest/runner/-/runner-2.1.2.tgz -> npmpkg-@vitest-runner-2.1.2.tgz
https://registry.npmjs.org/@vitest/snapshot/-/snapshot-2.1.2.tgz -> npmpkg-@vitest-snapshot-2.1.2.tgz
https://registry.npmjs.org/@vitest/spy/-/spy-2.1.2.tgz -> npmpkg-@vitest-spy-2.1.2.tgz
https://registry.npmjs.org/@vitest/utils/-/utils-2.1.2.tgz -> npmpkg-@vitest-utils-2.1.2.tgz
https://registry.npmjs.org/@volar/language-core/-/language-core-2.4.5.tgz -> npmpkg-@volar-language-core-2.4.5.tgz
https://registry.npmjs.org/@volar/source-map/-/source-map-2.4.5.tgz -> npmpkg-@volar-source-map-2.4.5.tgz
https://registry.npmjs.org/@volar/typescript/-/typescript-2.4.5.tgz -> npmpkg-@volar-typescript-2.4.5.tgz
https://registry.npmjs.org/@vue/compiler-core/-/compiler-core-3.5.11.tgz -> npmpkg-@vue-compiler-core-3.5.11.tgz
https://registry.npmjs.org/estree-walker/-/estree-walker-2.0.2.tgz -> npmpkg-estree-walker-2.0.2.tgz
https://registry.npmjs.org/@vue/compiler-dom/-/compiler-dom-3.5.11.tgz -> npmpkg-@vue-compiler-dom-3.5.11.tgz
https://registry.npmjs.org/@vue/compiler-sfc/-/compiler-sfc-3.5.11.tgz -> npmpkg-@vue-compiler-sfc-3.5.11.tgz
https://registry.npmjs.org/estree-walker/-/estree-walker-2.0.2.tgz -> npmpkg-estree-walker-2.0.2.tgz
https://registry.npmjs.org/@vue/compiler-ssr/-/compiler-ssr-3.5.11.tgz -> npmpkg-@vue-compiler-ssr-3.5.11.tgz
https://registry.npmjs.org/@vue/compiler-vue2/-/compiler-vue2-2.7.16.tgz -> npmpkg-@vue-compiler-vue2-2.7.16.tgz
https://registry.npmjs.org/@vue/devtools-api/-/devtools-api-6.6.4.tgz -> npmpkg-@vue-devtools-api-6.6.4.tgz
https://registry.npmjs.org/@vue/language-core/-/language-core-2.1.6.tgz -> npmpkg-@vue-language-core-2.1.6.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.5.tgz -> npmpkg-minimatch-9.0.5.tgz
https://registry.npmjs.org/@vue/reactivity/-/reactivity-3.5.11.tgz -> npmpkg-@vue-reactivity-3.5.11.tgz
https://registry.npmjs.org/@vue/runtime-core/-/runtime-core-3.5.11.tgz -> npmpkg-@vue-runtime-core-3.5.11.tgz
https://registry.npmjs.org/@vue/runtime-dom/-/runtime-dom-3.5.11.tgz -> npmpkg-@vue-runtime-dom-3.5.11.tgz
https://registry.npmjs.org/@vue/server-renderer/-/server-renderer-3.5.11.tgz -> npmpkg-@vue-server-renderer-3.5.11.tgz
https://registry.npmjs.org/@vue/shared/-/shared-3.5.11.tgz -> npmpkg-@vue-shared-3.5.11.tgz
https://registry.npmjs.org/@vue/test-utils/-/test-utils-2.4.6.tgz -> npmpkg-@vue-test-utils-2.4.6.tgz
https://registry.npmjs.org/@vue/tsconfig/-/tsconfig-0.5.1.tgz -> npmpkg-@vue-tsconfig-0.5.1.tgz
https://registry.npmjs.org/@vueuse/core/-/core-9.13.0.tgz -> npmpkg-@vueuse-core-9.13.0.tgz
https://registry.npmjs.org/vue-demi/-/vue-demi-0.14.10.tgz -> npmpkg-vue-demi-0.14.10.tgz
https://registry.npmjs.org/@vueuse/metadata/-/metadata-9.13.0.tgz -> npmpkg-@vueuse-metadata-9.13.0.tgz
https://registry.npmjs.org/@vueuse/shared/-/shared-9.13.0.tgz -> npmpkg-@vueuse-shared-9.13.0.tgz
https://registry.npmjs.org/vue-demi/-/vue-demi-0.14.10.tgz -> npmpkg-vue-demi-0.14.10.tgz
https://registry.npmjs.org/abbrev/-/abbrev-2.0.0.tgz -> npmpkg-abbrev-2.0.0.tgz
https://registry.npmjs.org/agent-base/-/agent-base-7.1.1.tgz -> npmpkg-agent-base-7.1.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-6.1.0.tgz -> npmpkg-ansi-regex-6.1.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/array-buffer-byte-length/-/array-buffer-byte-length-1.0.1.tgz -> npmpkg-array-buffer-byte-length-1.0.1.tgz
https://registry.npmjs.org/arraybuffer.prototype.slice/-/arraybuffer.prototype.slice-1.0.3.tgz -> npmpkg-arraybuffer.prototype.slice-1.0.3.tgz
https://registry.npmjs.org/assertion-error/-/assertion-error-2.0.1.tgz -> npmpkg-assertion-error-2.0.1.tgz
https://registry.npmjs.org/async-validator/-/async-validator-4.2.5.tgz -> npmpkg-async-validator-4.2.5.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz -> npmpkg-asynckit-0.4.0.tgz
https://registry.npmjs.org/available-typed-arrays/-/available-typed-arrays-1.0.7.tgz -> npmpkg-available-typed-arrays-1.0.7.tgz
https://registry.npmjs.org/axios/-/axios-1.7.7.tgz -> npmpkg-axios-1.7.7.tgz
https://registry.npmjs.org/axios-retry/-/axios-retry-4.5.0.tgz -> npmpkg-axios-retry-4.5.0.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz -> npmpkg-balanced-match-1.0.2.tgz
https://registry.npmjs.org/boolbase/-/boolbase-1.0.0.tgz -> npmpkg-boolbase-1.0.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/cac/-/cac-6.7.14.tgz -> npmpkg-cac-6.7.14.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.7.tgz -> npmpkg-call-bind-1.0.7.tgz
https://registry.npmjs.org/chai/-/chai-5.1.1.tgz -> npmpkg-chai-5.1.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/check-error/-/check-error-2.1.1.tgz -> npmpkg-check-error-2.1.1.tgz
https://registry.npmjs.org/chokidar/-/chokidar-4.0.1.tgz -> npmpkg-chokidar-4.0.1.tgz
https://registry.npmjs.org/class-transformer/-/class-transformer-0.5.1.tgz -> npmpkg-class-transformer-0.5.1.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz -> npmpkg-combined-stream-1.0.8.tgz
https://registry.npmjs.org/commander/-/commander-10.0.1.tgz -> npmpkg-commander-10.0.1.tgz
https://registry.npmjs.org/computeds/-/computeds-0.0.1.tgz -> npmpkg-computeds-0.0.1.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/config-chain/-/config-chain-1.1.13.tgz -> npmpkg-config-chain-1.1.13.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/css-select/-/css-select-5.1.0.tgz -> npmpkg-css-select-5.1.0.tgz
https://registry.npmjs.org/css-tree/-/css-tree-2.3.1.tgz -> npmpkg-css-tree-2.3.1.tgz
https://registry.npmjs.org/css-what/-/css-what-6.1.0.tgz -> npmpkg-css-what-6.1.0.tgz
https://registry.npmjs.org/csso/-/csso-5.0.5.tgz -> npmpkg-csso-5.0.5.tgz
https://registry.npmjs.org/css-tree/-/css-tree-2.2.1.tgz -> npmpkg-css-tree-2.2.1.tgz
https://registry.npmjs.org/mdn-data/-/mdn-data-2.0.28.tgz -> npmpkg-mdn-data-2.0.28.tgz
https://registry.npmjs.org/cssstyle/-/cssstyle-4.1.0.tgz -> npmpkg-cssstyle-4.1.0.tgz
https://registry.npmjs.org/csstype/-/csstype-3.1.3.tgz -> npmpkg-csstype-3.1.3.tgz
https://registry.npmjs.org/d3-array/-/d3-array-3.2.4.tgz -> npmpkg-d3-array-3.2.4.tgz
https://registry.npmjs.org/d3-color/-/d3-color-3.1.0.tgz -> npmpkg-d3-color-3.1.0.tgz
https://registry.npmjs.org/d3-format/-/d3-format-3.1.0.tgz -> npmpkg-d3-format-3.1.0.tgz
https://registry.npmjs.org/d3-interpolate/-/d3-interpolate-3.0.1.tgz -> npmpkg-d3-interpolate-3.0.1.tgz
https://registry.npmjs.org/d3-scale/-/d3-scale-4.0.2.tgz -> npmpkg-d3-scale-4.0.2.tgz
https://registry.npmjs.org/d3-scale-chromatic/-/d3-scale-chromatic-3.1.0.tgz -> npmpkg-d3-scale-chromatic-3.1.0.tgz
https://registry.npmjs.org/d3-time/-/d3-time-3.1.0.tgz -> npmpkg-d3-time-3.1.0.tgz
https://registry.npmjs.org/d3-time-format/-/d3-time-format-4.1.0.tgz -> npmpkg-d3-time-format-4.1.0.tgz
https://registry.npmjs.org/data-urls/-/data-urls-5.0.0.tgz -> npmpkg-data-urls-5.0.0.tgz
https://registry.npmjs.org/data-view-buffer/-/data-view-buffer-1.0.1.tgz -> npmpkg-data-view-buffer-1.0.1.tgz
https://registry.npmjs.org/data-view-byte-length/-/data-view-byte-length-1.0.1.tgz -> npmpkg-data-view-byte-length-1.0.1.tgz
https://registry.npmjs.org/data-view-byte-offset/-/data-view-byte-offset-1.0.0.tgz -> npmpkg-data-view-byte-offset-1.0.0.tgz
https://registry.npmjs.org/dayjs/-/dayjs-1.11.13.tgz -> npmpkg-dayjs-1.11.13.tgz
https://registry.npmjs.org/de-indent/-/de-indent-1.0.2.tgz -> npmpkg-de-indent-1.0.2.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/decimal.js/-/decimal.js-10.4.3.tgz -> npmpkg-decimal.js-10.4.3.tgz
https://registry.npmjs.org/deep-eql/-/deep-eql-5.0.2.tgz -> npmpkg-deep-eql-5.0.2.tgz
https://registry.npmjs.org/define-data-property/-/define-data-property-1.1.4.tgz -> npmpkg-define-data-property-1.1.4.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.2.1.tgz -> npmpkg-define-properties-1.2.1.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz -> npmpkg-delayed-stream-1.0.0.tgz
https://registry.npmjs.org/dom-serializer/-/dom-serializer-2.0.0.tgz -> npmpkg-dom-serializer-2.0.0.tgz
https://registry.npmjs.org/domelementtype/-/domelementtype-2.3.0.tgz -> npmpkg-domelementtype-2.3.0.tgz
https://registry.npmjs.org/domhandler/-/domhandler-5.0.3.tgz -> npmpkg-domhandler-5.0.3.tgz
https://registry.npmjs.org/domutils/-/domutils-3.1.0.tgz -> npmpkg-domutils-3.1.0.tgz
https://registry.npmjs.org/eastasianwidth/-/eastasianwidth-0.2.0.tgz -> npmpkg-eastasianwidth-0.2.0.tgz
https://registry.npmjs.org/echarts/-/echarts-5.5.1.tgz -> npmpkg-echarts-5.5.1.tgz
https://registry.npmjs.org/editorconfig/-/editorconfig-1.0.4.tgz -> npmpkg-editorconfig-1.0.4.tgz
https://registry.npmjs.org/element-plus/-/element-plus-2.8.4.tgz -> npmpkg-element-plus-2.8.4.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-9.2.2.tgz -> npmpkg-emoji-regex-9.2.2.tgz
https://registry.npmjs.org/entities/-/entities-4.5.0.tgz -> npmpkg-entities-4.5.0.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.2.tgz -> npmpkg-error-ex-1.3.2.tgz
https://registry.npmjs.org/es-abstract/-/es-abstract-1.23.3.tgz -> npmpkg-es-abstract-1.23.3.tgz
https://registry.npmjs.org/es-define-property/-/es-define-property-1.0.0.tgz -> npmpkg-es-define-property-1.0.0.tgz
https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz -> npmpkg-es-errors-1.3.0.tgz
https://registry.npmjs.org/es-object-atoms/-/es-object-atoms-1.0.0.tgz -> npmpkg-es-object-atoms-1.0.0.tgz
https://registry.npmjs.org/es-set-tostringtag/-/es-set-tostringtag-2.0.3.tgz -> npmpkg-es-set-tostringtag-2.0.3.tgz
https://registry.npmjs.org/es-to-primitive/-/es-to-primitive-1.2.1.tgz -> npmpkg-es-to-primitive-1.2.1.tgz
https://registry.npmjs.org/esbuild/-/esbuild-0.21.5.tgz -> npmpkg-esbuild-0.21.5.tgz
https://registry.npmjs.org/escape-html/-/escape-html-1.0.3.tgz -> npmpkg-escape-html-1.0.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/estree-walker/-/estree-walker-3.0.3.tgz -> npmpkg-estree-walker-3.0.3.tgz
https://registry.npmjs.org/follow-redirects/-/follow-redirects-1.15.9.tgz -> npmpkg-follow-redirects-1.15.9.tgz
https://registry.npmjs.org/for-each/-/for-each-0.3.3.tgz -> npmpkg-for-each-0.3.3.tgz
https://registry.npmjs.org/foreground-child/-/foreground-child-3.3.0.tgz -> npmpkg-foreground-child-3.3.0.tgz
https://registry.npmjs.org/form-data/-/form-data-4.0.0.tgz -> npmpkg-form-data-4.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz -> npmpkg-function-bind-1.1.2.tgz
https://registry.npmjs.org/function.prototype.name/-/function.prototype.name-1.1.6.tgz -> npmpkg-function.prototype.name-1.1.6.tgz
https://registry.npmjs.org/functions-have-names/-/functions-have-names-1.2.3.tgz -> npmpkg-functions-have-names-1.2.3.tgz
https://registry.npmjs.org/get-func-name/-/get-func-name-2.0.2.tgz -> npmpkg-get-func-name-2.0.2.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.4.tgz -> npmpkg-get-intrinsic-1.2.4.tgz
https://registry.npmjs.org/get-symbol-description/-/get-symbol-description-1.0.2.tgz -> npmpkg-get-symbol-description-1.0.2.tgz
https://registry.npmjs.org/glob/-/glob-10.4.5.tgz -> npmpkg-glob-10.4.5.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.5.tgz -> npmpkg-minimatch-9.0.5.tgz
https://registry.npmjs.org/globalthis/-/globalthis-1.0.4.tgz -> npmpkg-globalthis-1.0.4.tgz
https://registry.npmjs.org/gopd/-/gopd-1.0.1.tgz -> npmpkg-gopd-1.0.1.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz -> npmpkg-graceful-fs-4.2.11.tgz
https://registry.npmjs.org/has-bigints/-/has-bigints-1.0.2.tgz -> npmpkg-has-bigints-1.0.2.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.2.tgz -> npmpkg-has-property-descriptors-1.0.2.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.3.tgz -> npmpkg-has-proto-1.0.3.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/has-tostringtag/-/has-tostringtag-1.0.2.tgz -> npmpkg-has-tostringtag-1.0.2.tgz
https://registry.npmjs.org/hasown/-/hasown-2.0.2.tgz -> npmpkg-hasown-2.0.2.tgz
https://registry.npmjs.org/he/-/he-1.2.0.tgz -> npmpkg-he-1.2.0.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> npmpkg-hosted-git-info-2.8.9.tgz
https://registry.npmjs.org/html-encoding-sniffer/-/html-encoding-sniffer-4.0.0.tgz -> npmpkg-html-encoding-sniffer-4.0.0.tgz
https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-7.0.2.tgz -> npmpkg-http-proxy-agent-7.0.2.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-7.0.5.tgz -> npmpkg-https-proxy-agent-7.0.5.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz -> npmpkg-iconv-lite-0.6.3.tgz
https://registry.npmjs.org/immutable/-/immutable-4.3.7.tgz -> npmpkg-immutable-4.3.7.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/internal-slot/-/internal-slot-1.0.7.tgz -> npmpkg-internal-slot-1.0.7.tgz
https://registry.npmjs.org/internmap/-/internmap-2.0.3.tgz -> npmpkg-internmap-2.0.3.tgz
https://registry.npmjs.org/is-array-buffer/-/is-array-buffer-3.0.4.tgz -> npmpkg-is-array-buffer-3.0.4.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz -> npmpkg-is-arrayish-0.2.1.tgz
https://registry.npmjs.org/is-bigint/-/is-bigint-1.0.4.tgz -> npmpkg-is-bigint-1.0.4.tgz
https://registry.npmjs.org/is-boolean-object/-/is-boolean-object-1.1.2.tgz -> npmpkg-is-boolean-object-1.1.2.tgz
https://registry.npmjs.org/is-callable/-/is-callable-1.2.7.tgz -> npmpkg-is-callable-1.2.7.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.15.1.tgz -> npmpkg-is-core-module-2.15.1.tgz
https://registry.npmjs.org/is-data-view/-/is-data-view-1.0.1.tgz -> npmpkg-is-data-view-1.0.1.tgz
https://registry.npmjs.org/is-date-object/-/is-date-object-1.0.5.tgz -> npmpkg-is-date-object-1.0.5.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-negative-zero/-/is-negative-zero-2.0.3.tgz -> npmpkg-is-negative-zero-2.0.3.tgz
https://registry.npmjs.org/is-number-object/-/is-number-object-1.0.7.tgz -> npmpkg-is-number-object-1.0.7.tgz
https://registry.npmjs.org/is-potential-custom-element-name/-/is-potential-custom-element-name-1.0.1.tgz -> npmpkg-is-potential-custom-element-name-1.0.1.tgz
https://registry.npmjs.org/is-regex/-/is-regex-1.1.4.tgz -> npmpkg-is-regex-1.1.4.tgz
https://registry.npmjs.org/is-retry-allowed/-/is-retry-allowed-2.2.0.tgz -> npmpkg-is-retry-allowed-2.2.0.tgz
https://registry.npmjs.org/is-shared-array-buffer/-/is-shared-array-buffer-1.0.3.tgz -> npmpkg-is-shared-array-buffer-1.0.3.tgz
https://registry.npmjs.org/is-string/-/is-string-1.0.7.tgz -> npmpkg-is-string-1.0.7.tgz
https://registry.npmjs.org/is-symbol/-/is-symbol-1.0.4.tgz -> npmpkg-is-symbol-1.0.4.tgz
https://registry.npmjs.org/is-typed-array/-/is-typed-array-1.1.13.tgz -> npmpkg-is-typed-array-1.1.13.tgz
https://registry.npmjs.org/is-weakref/-/is-weakref-1.0.2.tgz -> npmpkg-is-weakref-1.0.2.tgz
https://registry.npmjs.org/isarray/-/isarray-2.0.5.tgz -> npmpkg-isarray-2.0.5.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/jackspeak/-/jackspeak-3.4.3.tgz -> npmpkg-jackspeak-3.4.3.tgz
https://registry.npmjs.org/js-beautify/-/js-beautify-1.15.1.tgz -> npmpkg-js-beautify-1.15.1.tgz
https://registry.npmjs.org/js-cookie/-/js-cookie-3.0.5.tgz -> npmpkg-js-cookie-3.0.5.tgz
https://registry.npmjs.org/jsdom/-/jsdom-25.0.1.tgz -> npmpkg-jsdom-25.0.1.tgz
https://registry.npmjs.org/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz -> npmpkg-json-parse-better-errors-1.0.2.tgz
https://registry.npmjs.org/load-json-file/-/load-json-file-4.0.0.tgz -> npmpkg-load-json-file-4.0.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lodash-es/-/lodash-es-4.17.21.tgz -> npmpkg-lodash-es-4.17.21.tgz
https://registry.npmjs.org/lodash-unified/-/lodash-unified-1.0.3.tgz -> npmpkg-lodash-unified-1.0.3.tgz
https://registry.npmjs.org/loupe/-/loupe-3.1.1.tgz -> npmpkg-loupe-3.1.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-10.4.3.tgz -> npmpkg-lru-cache-10.4.3.tgz
https://registry.npmjs.org/magic-string/-/magic-string-0.30.11.tgz -> npmpkg-magic-string-0.30.11.tgz
https://registry.npmjs.org/mdn-data/-/mdn-data-2.0.30.tgz -> npmpkg-mdn-data-2.0.30.tgz
https://registry.npmjs.org/memoize-one/-/memoize-one-6.0.0.tgz -> npmpkg-memoize-one-6.0.0.tgz
https://registry.npmjs.org/memorystream/-/memorystream-0.3.1.tgz -> npmpkg-memorystream-0.3.1.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.52.0.tgz -> npmpkg-mime-db-1.52.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.35.tgz -> npmpkg-mime-types-2.1.35.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.1.tgz -> npmpkg-minimatch-9.0.1.tgz
https://registry.npmjs.org/minipass/-/minipass-7.1.2.tgz -> npmpkg-minipass-7.1.2.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/muggle-string/-/muggle-string-0.4.1.tgz -> npmpkg-muggle-string-0.4.1.tgz
https://registry.npmjs.org/nanoid/-/nanoid-3.3.7.tgz -> npmpkg-nanoid-3.3.7.tgz
https://registry.npmjs.org/nice-try/-/nice-try-1.0.5.tgz -> npmpkg-nice-try-1.0.5.tgz
https://registry.npmjs.org/nopt/-/nopt-7.2.1.tgz -> npmpkg-nopt-7.2.1.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-2.5.0.tgz -> npmpkg-normalize-package-data-2.5.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/normalize-wheel-es/-/normalize-wheel-es-1.2.0.tgz -> npmpkg-normalize-wheel-es-1.2.0.tgz
https://registry.npmjs.org/npm-run-all/-/npm-run-all-4.1.5.tgz -> npmpkg-npm-run-all-4.1.5.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-6.0.5.tgz -> npmpkg-cross-spawn-6.0.5.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/path-key/-/path-key-2.0.1.tgz -> npmpkg-path-key-2.0.1.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-1.2.0.tgz -> npmpkg-shebang-command-1.2.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-1.0.0.tgz -> npmpkg-shebang-regex-1.0.0.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/nth-check/-/nth-check-2.1.1.tgz -> npmpkg-nth-check-2.1.1.tgz
https://registry.npmjs.org/nwsapi/-/nwsapi-2.2.13.tgz -> npmpkg-nwsapi-2.2.13.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.13.2.tgz -> npmpkg-object-inspect-1.13.2.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/object.assign/-/object.assign-4.1.5.tgz -> npmpkg-object.assign-4.1.5.tgz
https://registry.npmjs.org/package-json-from-dist/-/package-json-from-dist-1.0.1.tgz -> npmpkg-package-json-from-dist-1.0.1.tgz
https://registry.npmjs.org/parse-json/-/parse-json-4.0.0.tgz -> npmpkg-parse-json-4.0.0.tgz
https://registry.npmjs.org/parse5/-/parse5-7.1.2.tgz -> npmpkg-parse5-7.1.2.tgz
https://registry.npmjs.org/path-browserify/-/path-browserify-1.0.1.tgz -> npmpkg-path-browserify-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-scurry/-/path-scurry-1.11.1.tgz -> npmpkg-path-scurry-1.11.1.tgz
https://registry.npmjs.org/path-type/-/path-type-3.0.0.tgz -> npmpkg-path-type-3.0.0.tgz
https://registry.npmjs.org/pathe/-/pathe-1.1.2.tgz -> npmpkg-pathe-1.1.2.tgz
https://registry.npmjs.org/pathval/-/pathval-2.0.0.tgz -> npmpkg-pathval-2.0.0.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.1.0.tgz -> npmpkg-picocolors-1.1.0.tgz
https://registry.npmjs.org/pidtree/-/pidtree-0.3.1.tgz -> npmpkg-pidtree-0.3.1.tgz
https://registry.npmjs.org/pify/-/pify-3.0.0.tgz -> npmpkg-pify-3.0.0.tgz
https://registry.npmjs.org/pinia/-/pinia-2.2.4.tgz -> npmpkg-pinia-2.2.4.tgz
https://registry.npmjs.org/vue-demi/-/vue-demi-0.14.10.tgz -> npmpkg-vue-demi-0.14.10.tgz
https://registry.npmjs.org/possible-typed-array-names/-/possible-typed-array-names-1.0.0.tgz -> npmpkg-possible-typed-array-names-1.0.0.tgz
https://registry.npmjs.org/postcss/-/postcss-8.4.47.tgz -> npmpkg-postcss-8.4.47.tgz
https://registry.npmjs.org/primeflex/-/primeflex-3.3.1.tgz -> npmpkg-primeflex-3.3.1.tgz
https://registry.npmjs.org/primeicons/-/primeicons-7.0.0.tgz -> npmpkg-primeicons-7.0.0.tgz
https://registry.npmjs.org/primevue/-/primevue-3.44.0.tgz -> npmpkg-primevue-3.44.0.tgz
https://registry.npmjs.org/proto-list/-/proto-list-1.2.4.tgz -> npmpkg-proto-list-1.2.4.tgz
https://registry.npmjs.org/proxy-from-env/-/proxy-from-env-1.1.0.tgz -> npmpkg-proxy-from-env-1.1.0.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz -> npmpkg-punycode-2.3.1.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-3.0.0.tgz -> npmpkg-read-pkg-3.0.0.tgz
https://registry.npmjs.org/readdirp/-/readdirp-4.0.2.tgz -> npmpkg-readdirp-4.0.2.tgz
https://registry.npmjs.org/reflect-metadata/-/reflect-metadata-0.2.2.tgz -> npmpkg-reflect-metadata-0.2.2.tgz
https://registry.npmjs.org/regexp.prototype.flags/-/regexp.prototype.flags-1.5.3.tgz -> npmpkg-regexp.prototype.flags-1.5.3.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.8.tgz -> npmpkg-resolve-1.22.8.tgz
https://registry.npmjs.org/rollup/-/rollup-4.24.0.tgz -> npmpkg-rollup-4.24.0.tgz
https://registry.npmjs.org/rrweb-cssom/-/rrweb-cssom-0.7.1.tgz -> npmpkg-rrweb-cssom-0.7.1.tgz
https://registry.npmjs.org/safe-array-concat/-/safe-array-concat-1.1.2.tgz -> npmpkg-safe-array-concat-1.1.2.tgz
https://registry.npmjs.org/safe-regex-test/-/safe-regex-test-1.0.3.tgz -> npmpkg-safe-regex-test-1.0.3.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz -> npmpkg-safer-buffer-2.1.2.tgz
https://registry.npmjs.org/sass/-/sass-1.79.4.tgz -> npmpkg-sass-1.79.4.tgz
https://registry.npmjs.org/saxes/-/saxes-6.0.0.tgz -> npmpkg-saxes-6.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/set-function-length/-/set-function-length-1.2.2.tgz -> npmpkg-set-function-length-1.2.2.tgz
https://registry.npmjs.org/set-function-name/-/set-function-name-2.0.2.tgz -> npmpkg-set-function-name-2.0.2.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/shell-quote/-/shell-quote-1.8.1.tgz -> npmpkg-shell-quote-1.8.1.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.6.tgz -> npmpkg-side-channel-1.0.6.tgz
https://registry.npmjs.org/siginfo/-/siginfo-2.0.0.tgz -> npmpkg-siginfo-2.0.0.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-4.1.0.tgz -> npmpkg-signal-exit-4.1.0.tgz
https://registry.npmjs.org/source-map-js/-/source-map-js-1.2.1.tgz -> npmpkg-source-map-js-1.2.1.tgz
https://registry.npmjs.org/spdx-correct/-/spdx-correct-3.2.0.tgz -> npmpkg-spdx-correct-3.2.0.tgz
https://registry.npmjs.org/spdx-exceptions/-/spdx-exceptions-2.5.0.tgz -> npmpkg-spdx-exceptions-2.5.0.tgz
https://registry.npmjs.org/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> npmpkg-spdx-expression-parse-3.0.1.tgz
https://registry.npmjs.org/spdx-license-ids/-/spdx-license-ids-3.0.20.tgz -> npmpkg-spdx-license-ids-3.0.20.tgz
https://registry.npmjs.org/stackback/-/stackback-0.0.2.tgz -> npmpkg-stackback-0.0.2.tgz
https://registry.npmjs.org/std-env/-/std-env-3.7.0.tgz -> npmpkg-std-env-3.7.0.tgz
https://registry.npmjs.org/string-width/-/string-width-5.1.2.tgz -> npmpkg-string-width-5.1.2.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/string.prototype.padend/-/string.prototype.padend-3.1.6.tgz -> npmpkg-string.prototype.padend-3.1.6.tgz
https://registry.npmjs.org/string.prototype.trim/-/string.prototype.trim-1.2.9.tgz -> npmpkg-string.prototype.trim-1.2.9.tgz
https://registry.npmjs.org/string.prototype.trimend/-/string.prototype.trimend-1.0.8.tgz -> npmpkg-string.prototype.trimend-1.0.8.tgz
https://registry.npmjs.org/string.prototype.trimstart/-/string.prototype.trimstart-1.0.8.tgz -> npmpkg-string.prototype.trimstart-1.0.8.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-7.1.0.tgz -> npmpkg-strip-ansi-7.1.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz -> npmpkg-strip-bom-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> npmpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.npmjs.org/svgo/-/svgo-3.3.2.tgz -> npmpkg-svgo-3.3.2.tgz
https://registry.npmjs.org/commander/-/commander-7.2.0.tgz -> npmpkg-commander-7.2.0.tgz
https://registry.npmjs.org/symbol-tree/-/symbol-tree-3.2.4.tgz -> npmpkg-symbol-tree-3.2.4.tgz
https://registry.npmjs.org/tinybench/-/tinybench-2.9.0.tgz -> npmpkg-tinybench-2.9.0.tgz
https://registry.npmjs.org/tinyexec/-/tinyexec-0.3.0.tgz -> npmpkg-tinyexec-0.3.0.tgz
https://registry.npmjs.org/tinypool/-/tinypool-1.0.1.tgz -> npmpkg-tinypool-1.0.1.tgz
https://registry.npmjs.org/tinyrainbow/-/tinyrainbow-1.2.0.tgz -> npmpkg-tinyrainbow-1.2.0.tgz
https://registry.npmjs.org/tinyspy/-/tinyspy-3.0.2.tgz -> npmpkg-tinyspy-3.0.2.tgz
https://registry.npmjs.org/tldts/-/tldts-6.1.50.tgz -> npmpkg-tldts-6.1.50.tgz
https://registry.npmjs.org/tldts-core/-/tldts-core-6.1.50.tgz -> npmpkg-tldts-core-6.1.50.tgz
https://registry.npmjs.org/to-fast-properties/-/to-fast-properties-2.0.0.tgz -> npmpkg-to-fast-properties-2.0.0.tgz
https://registry.npmjs.org/tough-cookie/-/tough-cookie-5.0.0.tgz -> npmpkg-tough-cookie-5.0.0.tgz
https://registry.npmjs.org/tr46/-/tr46-5.0.0.tgz -> npmpkg-tr46-5.0.0.tgz
https://registry.npmjs.org/ts-enum-util/-/ts-enum-util-4.1.0.tgz -> npmpkg-ts-enum-util-4.1.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.3.0.tgz -> npmpkg-tslib-2.3.0.tgz
https://registry.npmjs.org/typed-array-buffer/-/typed-array-buffer-1.0.2.tgz -> npmpkg-typed-array-buffer-1.0.2.tgz
https://registry.npmjs.org/typed-array-byte-length/-/typed-array-byte-length-1.0.1.tgz -> npmpkg-typed-array-byte-length-1.0.1.tgz
https://registry.npmjs.org/typed-array-byte-offset/-/typed-array-byte-offset-1.0.2.tgz -> npmpkg-typed-array-byte-offset-1.0.2.tgz
https://registry.npmjs.org/typed-array-length/-/typed-array-length-1.0.6.tgz -> npmpkg-typed-array-length-1.0.6.tgz
https://registry.npmjs.org/typescript/-/typescript-5.6.2.tgz -> npmpkg-typescript-5.6.2.tgz
https://registry.npmjs.org/unbox-primitive/-/unbox-primitive-1.0.2.tgz -> npmpkg-unbox-primitive-1.0.2.tgz
https://registry.npmjs.org/undici-types/-/undici-types-6.19.8.tgz -> npmpkg-undici-types-6.19.8.tgz
https://registry.npmjs.org/uplot/-/uplot-1.6.31.tgz -> npmpkg-uplot-1.6.31.tgz
https://registry.npmjs.org/uuid/-/uuid-10.0.0.tgz -> npmpkg-uuid-10.0.0.tgz
https://registry.npmjs.org/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> npmpkg-validate-npm-package-license-3.0.4.tgz
https://registry.npmjs.org/vite/-/vite-5.4.8.tgz -> npmpkg-vite-5.4.8.tgz
https://registry.npmjs.org/vite-node/-/vite-node-2.1.2.tgz -> npmpkg-vite-node-2.1.2.tgz
https://registry.npmjs.org/vite-plugin-package-version/-/vite-plugin-package-version-1.1.0.tgz -> npmpkg-vite-plugin-package-version-1.1.0.tgz
https://registry.npmjs.org/vite-svg-loader/-/vite-svg-loader-5.1.0.tgz -> npmpkg-vite-svg-loader-5.1.0.tgz
https://registry.npmjs.org/vitest/-/vitest-2.1.2.tgz -> npmpkg-vitest-2.1.2.tgz
https://registry.npmjs.org/vscode-uri/-/vscode-uri-3.0.8.tgz -> npmpkg-vscode-uri-3.0.8.tgz
https://registry.npmjs.org/vue/-/vue-3.5.11.tgz -> npmpkg-vue-3.5.11.tgz
https://registry.npmjs.org/vue-component-type-helpers/-/vue-component-type-helpers-2.1.6.tgz -> npmpkg-vue-component-type-helpers-2.1.6.tgz
https://registry.npmjs.org/vue-demi/-/vue-demi-0.13.11.tgz -> npmpkg-vue-demi-0.13.11.tgz
https://registry.npmjs.org/vue-echarts/-/vue-echarts-7.0.3.tgz -> npmpkg-vue-echarts-7.0.3.tgz
https://registry.npmjs.org/vue-router/-/vue-router-4.4.5.tgz -> npmpkg-vue-router-4.4.5.tgz
https://registry.npmjs.org/vue-tsc/-/vue-tsc-2.1.6.tgz -> npmpkg-vue-tsc-2.1.6.tgz
https://registry.npmjs.org/w3c-xmlserializer/-/w3c-xmlserializer-5.0.0.tgz -> npmpkg-w3c-xmlserializer-5.0.0.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-7.0.0.tgz -> npmpkg-webidl-conversions-7.0.0.tgz
https://registry.npmjs.org/whatwg-encoding/-/whatwg-encoding-3.1.1.tgz -> npmpkg-whatwg-encoding-3.1.1.tgz
https://registry.npmjs.org/whatwg-mimetype/-/whatwg-mimetype-4.0.0.tgz -> npmpkg-whatwg-mimetype-4.0.0.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-14.0.0.tgz -> npmpkg-whatwg-url-14.0.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> npmpkg-which-boxed-primitive-1.0.2.tgz
https://registry.npmjs.org/which-typed-array/-/which-typed-array-1.1.15.tgz -> npmpkg-which-typed-array-1.1.15.tgz
https://registry.npmjs.org/why-is-node-running/-/why-is-node-running-2.3.0.tgz -> npmpkg-why-is-node-running-2.3.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-8.1.0.tgz -> npmpkg-wrap-ansi-8.1.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-6.2.1.tgz -> npmpkg-ansi-styles-6.2.1.tgz
https://registry.npmjs.org/ws/-/ws-8.18.0.tgz -> npmpkg-ws-8.18.0.tgz
https://registry.npmjs.org/xml-name-validator/-/xml-name-validator-5.0.0.tgz -> npmpkg-xml-name-validator-5.0.0.tgz
https://registry.npmjs.org/xmlchars/-/xmlchars-2.2.0.tgz -> npmpkg-xmlchars-2.2.0.tgz
https://registry.npmjs.org/zrender/-/zrender-5.6.0.tgz -> npmpkg-zrender-5.6.0.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS

NODE_SLOTS="18"
NPM_TARBALL="coolercontrol-${PV}.tar.bz2"
PYTHON_COMPAT=( python3_{10,11} ) # Can support 3.12 but limited by Nuitka
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

inherit cargo desktop lcnr npm xdg

#KEYWORDS="~amd64" # The standalone version freezes.
S="${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui/src-tauri"
SRC_URI="
$(cargo_crate_uris ${CRATES})
${NPM_EXTERNAL_URIS}
https://gitlab.com/coolercontrol/coolercontrol/-/archive/${PV}/coolercontrol-${PV}.tar.bz2
"

DESCRIPTION="A new user interface for CoolerControl using Tauri, GTK 3, Rust, Vue 3, WebKitGTK"
HOMEPAGE="
https://gitlab.com/coolercontrol/coolercontrol
https://gitlab.com/coolercontrol/coolercontrol/-/tree/main/coolercontrol-ui
"
CARGO_PACKAGES_LICENSES="
	(
		ISC
		MIT
		openssl
		SSLeay
	)
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	Boost-1.0
	BSD
	BSD-2
	CC-BY-3.0
	CC0-1.0
	ISC
	GPL-3+
	HPND-Pbmplus
	MIT
	MPL-2.0
	Unicode-DFS-2016
	Unlicense
	ZLIB
	|| (
		Apache-2.0
		ISC
		MIT
	)
	|| (
		Apache-2.0
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
	Apache-2.0
	BSD
	BSD-2
	CC0-1.0
	custom
	MIT
	ISC
"
# ( all-rights-reserved, Apache-2.0 ) - coolercontrol-ui/node_modules/reflect-metadata/CopyrightNotice.txt ; The distro's Apache-2.0 license template does not have all rights reserved
# ( all-rights-reserved, MIT ) - coolercontrol-ui/node_modules/sass/LICENSE
# ( ISC MIT openssl SSLeay ) - cargo_home/gentoo/ring-0.17.5/LICENSE
# 0BSD - coolercontrol-ui/node_modules/tslib/CopyrightNotice.txt
# Apache-2.0, MIT - coolercontrol-ui/node_modules/@mdi/js/LICENSE
# Boost-1.0 - cargo_home/gentoo/ryu-1.0.15/LICENSE-BOOST
# CC-BY-4.0, MIT, Unicode-DFS-2016, W3C-Community-Final-Specification-Agreement - coolercontrol-ui/node_modules/typescript/ThirdPartyNoticeText.txt
# CC0-1.0 - coolercontrol-ui/node_modules/csso/node_modules/mdn-data/LICENSE
# custom - coolercontrol-ui/node_modules/jackspeak/LICENSE.md
#   keywords:  "This license gives everyone as much permission to work with"
# GPL-3+, HPND-Pbmplus - cargo_home/gentoo/imagequant-4.2.2/COPYRIGHT
LICENSE="
	${CARGO_PACKAGES_LICENSES}
	${NPM_PACKAGES_LICENSES}
	GPL-3+
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" tray wayland X ebuild_revision_3"
gen_webkit_depend() {
	local s
	for s in ${WEBKIT_GTK_STABLE[@]} ; do
	# There is a bug with webkit-gtk's jit that causes it to crash.
		echo "=net-libs/webkit-gtk-${s}*:4[javascript,-jit,introspection,wayland?,X?]"
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
"
RUST_BINDINGS_BDEPEND="
	virtual/pkgconfig
"
RDEPEND+="
	${RUST_BINDINGS_DEPEND}
	~sys-apps/coolercontrold-${PV}
"
DEPEND+="
	${RDEPEND}
"
COOLERCONTROL_UI_BDEPEND="
	>=net-libs/nodejs-18.12.0[npm]
	|| (
		(
			>=dev-lang/rust-1.75
			dev-lang/rust:=
		)
		(
			>=dev-lang/rust-bin-1.75
			dev-lang/rust-bin:=
		)
	)
"
VUE_DEPEND="
	>=net-libs/nodejs-18.12.0[npm]
"
BDEPEND+="
	${COOLERCONTROL_UI_BDEPEND}
	${RUST_BINDINGS_BDEPEND}
	${VUE_DEPEND}
	>=dev-build/make-4.3
"

set_gui_port() {
	local L=(
		"coolercontrol-liqctld/coolercontrol_liqctld/server.py"
	)
	local port=${COOLERCONTROL_GUI_PORT:-11987}
	local p
	for p in "${L[@]}" ; do
		sed -i -e "s|11987|${port}|g" "${p}" || die
	done
}

set_liqctld_port() {
	local L=(
		"coolercontrol-liqctld/coolercontrol_liqctld/server.py"
	)
	local port=${COOLERCONTROL_LIQCTLD_PORT:-11986}
	local p
	for p in "${L[@]}" ; do
		sed -i -e "s|11986|${port}|g" "${p}" || die
	done
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

pkg_setup() {
ewarn "Do not emerge ${CATEGORY}/${PN} package directly.  Emerge sys-apps/coolercontrol instead."
	npm_pkg_setup
}

src_unpack() {
	local commit="${PLUGINS_WORKSPACE_COMMIT}"
	S="${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui" \
	npm_src_unpack
	S="${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui/src-tauri" \
	_cargo_src_unpack

	cd "${WORKDIR}" || die
	unpack "${DISTDIR}/plugins-workspace-${commit}.gh.tar.gz"

	# Bugged
	mkdir -p "${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/autostart" || die
	mkdir -p "${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/single-instance" || die
	mkdir -p "${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/store" || die
	mkdir -p "${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/window-state" || die
	cp -aT \
		"${WORKDIR}/plugins-workspace-${commit}/plugins/autostart" \
		"${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/autostart" \
		|| die
	cp -aT \
		"${WORKDIR}/plugins-workspace-${commit}/plugins/store" \
		"${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/store" \
		|| die
	cp -aT \
		"${WORKDIR}/plugins-workspace-${commit}/plugins/single-instance" \
		"${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/single-instance" \
		|| die
	cp -aT \
		"${WORKDIR}/plugins-workspace-${commit}/plugins/window-state" \
		"${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/window-state" \
		|| die

#	mkdir -p "${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}" || die
##	cd "${WORKDIR}" || die
#	cp -aT \
#		"${WORKDIR}/plugins-workspace-${commit}" \
#		"${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}" \
#		|| die
#	ln -s \
#		"${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/store" \
#		"${WORKDIR}/tauri-plugin-store-${commit}" \
#		|| die
}

src_configure() {
	pushd "${WORKDIR}/coolercontrol-${PV}" || die
		set_gui_port
		set_liqctld_port
	popd
	S="${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui/src-tauri" \
	cargo_src_configure
	local port=${COOLERCONTROL_GUI_PORT:-11987}
#	sed -i \
#		-e "s|localhost:5173|localhost:${port}|g" \
#		-e "s|../dist|localhost:${port}|g" \
#		"${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui/src-tauri/tauri.conf.json" \
#		|| die
}

src_compile() {
	npm_hydrate
	pushd "${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui" || die
einfo "PWD: $(pwd)"
		S="${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui" \
		enpm install \
			${NPM_INSTALL_ARGS[@]}
	# Audit fix already done with NPM_UPDATE_LOCK=1
		S="${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui" \
		enpm run build
	popd
	[[ -e "${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui/dist/index.html" ]] || die
	S="${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui/src-tauri" \
	cargo_src_compile -F custom-protocol
}

src_install() {
	S="${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui/src-tauri" \
	cargo_src_install
	mv "${ED}/usr/bin/coolercontrol"{,-gtk3}
	make_desktop_entry \
		"/usr/bin/coolercontrol-gtk3" \
		"CoolerControl (GTK3)" \
		"org.coolercontrol.CoolerControl" \
		"Utility;"

	LCNR_SOURCE="${WORKDIR}/cargo_home/gentoo"
	LCNR_TAG="third_party_cargo"
	lcnr_install_files

	LCNR_SOURCE="${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui/node_modules"
	LCNR_TAG="third_party_npm"
	lcnr_install_files
}

pkg_postinst() {
	ln -sf \
		"${EROOT}/usr/bin/coolercontrol-gtk3" \
		"${EROOT}/usr/bin/coolercontrol" \
		|| die
	xdg_pkg_postinst
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  passed (webkit-gtk 2.42.2, 20231204)
