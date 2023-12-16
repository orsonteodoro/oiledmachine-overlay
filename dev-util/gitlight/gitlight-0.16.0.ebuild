# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

declare -A GIT_CRATES=(
[tauri-plugin-autostart]="https://github.com/tauri-apps/plugins-workspace;cdb77c4b650a81a9c44c4b5db5a46c31954dd7f9;plugins-workspace-%commit%/plugins/autostart" # 0.0.0
#[tauri-plugin-deep-link]="https://github.com/tauri-apps/plugins-workspace;cdb77c4b650a81a9c44c4b5db5a46c31954dd7f9;plugins-workspace-%commit%/plugins/deep-link" # 0.0.0
[tauri-plugin-positioner]="https://github.com/tauri-apps/plugins-workspace;cdb77c4b650a81a9c44c4b5db5a46c31954dd7f9;plugins-workspace-%commit%/plugins/positioner" # 0.1.0
[tauri-plugin-window-state]="https://github.com/tauri-apps/plugins-workspace;cdb77c4b650a81a9c44c4b5db5a46c31954dd7f9;plugins-workspace-%commit%/plugins/window-state" # 0.1.0
)

#app-0.16.0
CRATES="
addr2line-0.20.0
adler-1.0.2
aho-corasick-1.0.2
alloc-no-stdlib-2.0.4
alloc-stdlib-0.2.2
android_system_properties-0.1.5
android-tzdata-0.1.1
anyhow-1.0.72
async-broadcast-0.5.1
async-channel-1.9.0
async-executor-1.5.1
async-fs-1.6.0
async-io-1.13.0
async-lock-2.7.0
async-process-1.7.0
async-recursion-1.0.4
async-task-4.4.0
async-trait-0.1.72
atk-0.15.1
atk-sys-0.15.1
atomic-waker-1.1.1
autocfg-1.1.0
auto-launch-0.4.0
backtrace-0.3.68
base64-0.13.1
base64-0.21.2
bincode-1.3.3
bitflags-1.3.2
bitflags-2.3.3
block-0.1.6
block-buffer-0.10.4
blocking-1.3.1
brotli-3.3.4
brotli-decompressor-2.3.4
bstr-1.6.0
bumpalo-3.13.0
bytemuck-1.13.1
byteorder-1.4.3
bytes-1.4.0
cairo-rs-0.15.12
cairo-sys-rs-0.15.1
cargo_toml-0.15.3
cc-1.0.81
cesu8-1.1.0
cfb-0.7.3
cfg-expr-0.15.4
cfg-expr-0.9.1
cfg-if-1.0.0
chrono-0.4.26
cocoa-0.24.1
cocoa-0.25.0
cocoa-foundation-0.1.1
color_quant-1.1.0
combine-4.6.6
concurrent-queue-2.2.0
convert_case-0.4.0
core-foundation-0.9.3
core-foundation-sys-0.8.4
core-graphics-0.22.3
core-graphics-0.23.1
core-graphics-types-0.1.2
cpufeatures-0.2.9
crc32fast-1.3.2
crossbeam-channel-0.5.8
crossbeam-utils-0.8.16
crypto-common-0.1.6
cssparser-0.27.2
cssparser-macros-0.6.1
ctor-0.1.26
darling-0.20.3
darling_core-0.20.3
darling_macro-0.20.3
deranged-0.3.7
derivative-2.2.0
derive_more-0.99.17
digest-0.10.7
dirs-4.0.0
dirs-5.0.1
dirs-next-2.0.0
dirs-sys-0.3.7
dirs-sys-0.4.1
dirs-sys-next-0.1.2
dispatch-0.2.0
dtoa-1.0.9
dtoa-short-0.3.4
dunce-1.0.4
embed_plist-1.2.2
embed-resource-2.2.0
encoding_rs-0.8.32
enumflags2-0.7.7
enumflags2_derive-0.7.7
equivalent-1.0.1
errno-0.3.2
errno-dragonfly-0.1.2
event-listener-2.5.3
fastrand-1.9.0
fastrand-2.0.0
fdeflate-0.3.0
field-offset-0.3.6
filetime-0.2.21
flate2-1.0.26
fnv-1.0.7
foreign-types-0.3.2
foreign-types-0.5.0
foreign-types-macros-0.2.3
foreign-types-shared-0.1.1
foreign-types-shared-0.3.1
form_urlencoded-1.2.0
futf-0.1.5
futures-channel-0.3.28
futures-core-0.3.28
futures-executor-0.3.28
futures-io-0.3.28
futures-lite-1.13.0
futures-macro-0.3.28
futures-sink-0.3.28
futures-task-0.3.28
futures-util-0.3.28
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
getrandom-0.2.10
gimli-0.27.3
gio-0.15.12
gio-sys-0.15.10
glib-0.15.12
glib-macros-0.15.13
glib-sys-0.15.10
glob-0.3.1
globset-0.4.12
gobject-sys-0.15.10
gtk-0.15.5
gtk3-macros-0.15.6
gtk-sys-0.15.3
h2-0.3.20
hashbrown-0.12.3
hashbrown-0.14.0
heck-0.3.3
heck-0.4.1
hermit-abi-0.3.2
hex-0.4.3
html5ever-0.25.2
html5ever-0.26.0
http-0.2.9
httparse-1.8.0
http-body-0.4.5
httpdate-1.0.2
http-range-0.1.5
hyper-0.14.27
hyper-tls-0.5.0
iana-time-zone-0.1.57
iana-time-zone-haiku-0.1.2
ico-0.3.0
ident_case-1.0.1
idna-0.4.0
ignore-0.4.20
image-0.24.6
indexmap-1.9.3
indexmap-2.0.0
infer-0.12.0
infer-0.9.0
instant-0.1.12
interprocess-1.2.1
io-lifetimes-1.0.11
ipnet-2.8.0
itoa-0.4.8
itoa-1.0.9
javascriptcore-rs-0.16.0
javascriptcore-rs-sys-0.4.0
jni-0.20.0
jni-sys-0.3.0
json-patch-1.0.0
js-sys-0.3.64
kuchiki-0.8.1
kuchikiki-0.8.2
lazy_static-1.4.0
libappindicator-0.7.1
libappindicator-sys-0.7.3
libc-0.2.147
libloading-0.7.4
line-wrap-0.1.1
linux-raw-sys-0.3.8
linux-raw-sys-0.4.5
lock_api-0.4.10
log-0.4.20
loom-0.5.6
mac-0.1.1
mac-notification-sys-0.5.8
malloc_buf-0.0.6
markup5ever-0.10.1
markup5ever-0.11.0
matchers-0.1.0
matches-0.1.10
memchr-2.5.0
memoffset-0.7.1
memoffset-0.9.0
mime-0.3.17
minisign-verify-0.2.1
miniz_oxide-0.7.1
mio-0.8.8
native-tls-0.2.11
ndk-0.6.0
ndk-context-0.1.1
ndk-sys-0.3.0
new_debug_unreachable-1.0.4
nix-0.26.2
nodrop-0.1.14
notify-rust-4.8.0
nu-ansi-term-0.46.0
num_cpus-1.16.0
num_enum-0.5.11
num_enum_derive-0.5.11
num-integer-0.1.45
num-rational-0.4.1
num-traits-0.2.16
objc-0.2.7
objc2-0.4.1
objc2-encode-3.0.0
objc_exception-0.1.2
objc-foundation-0.1.1
objc_id-0.1.1
objc-sys-0.3.1
object-0.31.1
once_cell-1.18.0
open-3.2.0
openssl-0.10.55
openssl-macros-0.1.1
openssl-probe-0.1.5
openssl-sys-0.9.90
option-ext-0.2.0
ordered-stream-0.2.0
os_info-3.7.0
os_pipe-1.1.4
overload-0.1.1
pango-0.15.10
pango-sys-0.15.10
parking-2.1.0
parking_lot-0.12.1
parking_lot_core-0.9.8
pathdiff-0.2.1
percent-encoding-2.3.0
phf-0.10.1
phf-0.8.0
phf_codegen-0.10.0
phf_codegen-0.8.0
phf_generator-0.10.0
phf_generator-0.8.0
phf_macros-0.10.0
phf_macros-0.8.0
phf_shared-0.10.0
phf_shared-0.8.0
pin-project-lite-0.2.10
pin-utils-0.1.0
pkg-config-0.3.27
plist-1.5.0
png-0.17.9
polling-2.8.0
ppv-lite86-0.2.17
precomputed-hash-0.1.1
proc-macro2-1.0.66
proc-macro-crate-1.3.1
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro-hack-0.5.20+deprecated
quick-xml-0.23.1
quick-xml-0.29.0
quote-1.0.32
rand-0.7.3
rand-0.8.5
rand_chacha-0.2.2
rand_chacha-0.3.1
rand_core-0.5.1
rand_core-0.6.4
rand_hc-0.2.0
rand_pcg-0.2.1
raw-window-handle-0.5.2
redox_syscall-0.2.16
redox_syscall-0.3.5
redox_users-0.4.3
regex-1.9.1
regex-automata-0.1.10
regex-automata-0.3.4
regex-syntax-0.6.29
regex-syntax-0.7.4
reqwest-0.11.18
rfd-0.10.0
rustc-demangle-0.1.23
rustc_version-0.4.0
rustix-0.37.23
rustix-0.38.6
rustversion-1.0.14
ryu-1.0.15
safemem-0.3.3
same-file-1.0.6
schannel-0.1.22
scoped-tls-1.0.1
scopeguard-1.2.0
security-framework-2.9.2
security-framework-sys-2.9.1
selectors-0.22.0
semver-1.0.18
serde-1.0.180
serde_derive-1.0.180
serde_json-1.0.104
serde_repr-0.1.16
serde_spanned-0.6.3
serde_urlencoded-0.7.1
serde_with-3.1.0
serde_with_macros-3.1.0
serialize-to-javascript-0.1.1
serialize-to-javascript-impl-0.1.1
servo_arc-0.1.1
sha1-0.10.5
sha2-0.10.7
sharded-slab-0.1.4
shared_child-1.0.0
signal-hook-0.3.17
signal-hook-registry-1.4.1
simd-adler32-0.3.7
siphasher-0.3.10
slab-0.4.8
smallvec-1.11.0
socket2-0.4.9
soup2-0.2.1
soup2-sys-0.2.0
stable_deref_trait-1.2.0
state-0.5.3
static_assertions-1.1.0
string_cache-0.8.7
string_cache_codegen-0.5.2
strsim-0.10.0
syn-1.0.109
syn-2.0.28
sys-locale-0.2.4
system-deps-5.0.0
system-deps-6.1.1
tao-0.16.2
tao-macros-0.1.1
tar-0.4.39
target-lexicon-0.12.11
tauri-1.5.2
tauri-build-1.5.0
tauri-codegen-1.4.1
tauri-macros-1.4.1
tauri-plugin-deep-link-0.1.2
tauri-plugin-positioner-1.0.4
tauri-runtime-0.14.1
tauri-runtime-wry-0.14.1
tauri-utils-1.5.0
tauri-winres-0.1.1
tauri-winrt-notification-0.1.2
tempfile-3.7.0
tendril-0.4.3
thin-slice-0.1.1
thiserror-1.0.44
thiserror-impl-1.0.44
thread_local-1.1.7
time-0.3.25
time-core-0.1.1
time-macros-0.2.11
tinyvec-1.6.0
tinyvec_macros-0.1.1
tokio-1.29.1
tokio-native-tls-0.3.1
tokio-util-0.7.8
to_method-1.1.0
toml-0.5.11
toml-0.7.6
toml_datetime-0.6.3
toml_edit-0.19.14
tower-service-0.3.2
tracing-0.1.37
tracing-attributes-0.1.26
tracing-core-0.1.31
tracing-log-0.1.3
tracing-subscriber-0.3.17
treediff-4.0.2
try-lock-0.2.4
typenum-1.16.0
uds_windows-1.0.2
unicode-bidi-0.3.13
unicode-ident-1.0.11
unicode-normalization-0.1.22
unicode-segmentation-1.10.1
url-2.4.0
utf-8-0.7.6
uuid-1.4.1
valuable-0.1.0
vcpkg-0.2.15
version_check-0.9.4
version-compare-0.0.11
version-compare-0.1.1
vswhom-0.1.0
vswhom-sys-0.1.2
waker-fn-1.1.0
walkdir-2.3.3
want-0.3.1
wasi-0.11.0+wasi-snapshot-preview1
wasi-0.9.0+wasi-snapshot-preview1
wasm-bindgen-0.2.87
wasm-bindgen-backend-0.2.87
wasm-bindgen-futures-0.4.37
wasm-bindgen-macro-0.2.87
wasm-bindgen-macro-support-0.2.87
wasm-bindgen-shared-0.2.87
wasm-streams-0.2.3
webkit2gtk-0.18.2
webkit2gtk-sys-0.18.0
web-sys-0.3.64
webview2-com-0.19.1
webview2-com-macros-0.6.0
webview2-com-sys-0.19.0
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.37.0
windows-0.39.0
windows-0.48.0
windows_aarch64_gnullvm-0.42.2
windows_aarch64_gnullvm-0.48.0
windows_aarch64_msvc-0.37.0
windows_aarch64_msvc-0.39.0
windows_aarch64_msvc-0.42.2
windows_aarch64_msvc-0.48.0
windows-bindgen-0.39.0
windows_i686_gnu-0.37.0
windows_i686_gnu-0.39.0
windows_i686_gnu-0.42.2
windows_i686_gnu-0.48.0
windows_i686_msvc-0.37.0
windows_i686_msvc-0.39.0
windows_i686_msvc-0.42.2
windows_i686_msvc-0.48.0
windows-implement-0.39.0
windows-metadata-0.39.0
windows-sys-0.42.0
windows-sys-0.45.0
windows-sys-0.48.0
windows-targets-0.42.2
windows-targets-0.48.1
windows-tokens-0.39.0
windows_x86_64_gnu-0.37.0
windows_x86_64_gnu-0.39.0
windows_x86_64_gnu-0.42.2
windows_x86_64_gnu-0.48.0
windows_x86_64_gnullvm-0.42.2
windows_x86_64_gnullvm-0.48.0
windows_x86_64_msvc-0.37.0
windows_x86_64_msvc-0.39.0
windows_x86_64_msvc-0.42.2
windows_x86_64_msvc-0.48.0
winnow-0.5.3
winreg-0.10.1
winreg-0.11.0
winreg-0.50.0
wry-0.24.4
x11-2.21.0
x11-dl-2.21.0
xattr-0.2.3
xdg-home-1.0.0
zbus-3.14.1
zbus_macros-3.14.1
zbus_names-2.6.0
zip-0.6.6
zvariant-3.15.0
zvariant_derive-3.15.0
zvariant_utils-1.0.1
"

MY_PN="gitlight-gitlight"
NODE_SLOTS="18"
NPM_AUDIT_FIX=0
NPM_OFFLINE=1
NPM_INSTALL_UNPACK_ARGS="--legacy-peer-deps"
inherit cargo desktop lcnr npm xdg

# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@tauri-apps/cli-darwin-arm64/-/cli-darwin-arm64-1.5.8.tgz -> npmpkg-@tauri-apps-cli-darwin-arm64-1.5.8.tgz
https://registry.npmjs.org/@tauri-apps/cli-darwin-x64/-/cli-darwin-x64-1.5.8.tgz -> npmpkg-@tauri-apps-cli-darwin-x64-1.5.8.tgz
https://registry.npmjs.org/@tauri-apps/cli-linux-arm-gnueabihf/-/cli-linux-arm-gnueabihf-1.5.8.tgz -> npmpkg-@tauri-apps-cli-linux-arm-gnueabihf-1.5.8.tgz
https://registry.npmjs.org/@tauri-apps/cli-linux-arm64-gnu/-/cli-linux-arm64-gnu-1.5.8.tgz -> npmpkg-@tauri-apps-cli-linux-arm64-gnu-1.5.8.tgz
https://registry.npmjs.org/@tauri-apps/cli-linux-arm64-musl/-/cli-linux-arm64-musl-1.5.8.tgz -> npmpkg-@tauri-apps-cli-linux-arm64-musl-1.5.8.tgz
https://registry.npmjs.org/@tauri-apps/cli-win32-arm64-msvc/-/cli-win32-arm64-msvc-1.5.8.tgz -> npmpkg-@tauri-apps-cli-win32-arm64-msvc-1.5.8.tgz
https://registry.npmjs.org/@tauri-apps/cli-win32-ia32-msvc/-/cli-win32-ia32-msvc-1.5.8.tgz -> npmpkg-@tauri-apps-cli-win32-ia32-msvc-1.5.8.tgz
https://registry.npmjs.org/@tauri-apps/cli-win32-x64-msvc/-/cli-win32-x64-msvc-1.5.8.tgz -> npmpkg-@tauri-apps-cli-win32-x64-msvc-1.5.8.tgz
https://registry.npmjs.org/@typescript-eslint/eslint-plugin/-/eslint-plugin-6.14.0.tgz -> npmpkg-@typescript-eslint-eslint-plugin-6.14.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/@esbuild/android-arm/-/android-arm-0.18.20.tgz -> npmpkg-@esbuild-android-arm-0.18.20.tgz
https://registry.npmjs.org/@esbuild/android-arm64/-/android-arm64-0.18.20.tgz -> npmpkg-@esbuild-android-arm64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/android-x64/-/android-x64-0.18.20.tgz -> npmpkg-@esbuild-android-x64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/darwin-arm64/-/darwin-arm64-0.18.20.tgz -> npmpkg-@esbuild-darwin-arm64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/darwin-x64/-/darwin-x64-0.18.20.tgz -> npmpkg-@esbuild-darwin-x64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/freebsd-arm64/-/freebsd-arm64-0.18.20.tgz -> npmpkg-@esbuild-freebsd-arm64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/freebsd-x64/-/freebsd-x64-0.18.20.tgz -> npmpkg-@esbuild-freebsd-x64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-arm/-/linux-arm-0.18.20.tgz -> npmpkg-@esbuild-linux-arm-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-arm64/-/linux-arm64-0.18.20.tgz -> npmpkg-@esbuild-linux-arm64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-ia32/-/linux-ia32-0.18.20.tgz -> npmpkg-@esbuild-linux-ia32-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-loong64/-/linux-loong64-0.18.20.tgz -> npmpkg-@esbuild-linux-loong64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-mips64el/-/linux-mips64el-0.18.20.tgz -> npmpkg-@esbuild-linux-mips64el-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-ppc64/-/linux-ppc64-0.18.20.tgz -> npmpkg-@esbuild-linux-ppc64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-riscv64/-/linux-riscv64-0.18.20.tgz -> npmpkg-@esbuild-linux-riscv64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-s390x/-/linux-s390x-0.18.20.tgz -> npmpkg-@esbuild-linux-s390x-0.18.20.tgz
https://registry.npmjs.org/@esbuild/netbsd-x64/-/netbsd-x64-0.18.20.tgz -> npmpkg-@esbuild-netbsd-x64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/openbsd-x64/-/openbsd-x64-0.18.20.tgz -> npmpkg-@esbuild-openbsd-x64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/sunos-x64/-/sunos-x64-0.18.20.tgz -> npmpkg-@esbuild-sunos-x64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/win32-arm64/-/win32-arm64-0.18.20.tgz -> npmpkg-@esbuild-win32-arm64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/win32-ia32/-/win32-ia32-0.18.20.tgz -> npmpkg-@esbuild-win32-ia32-0.18.20.tgz
https://registry.npmjs.org/@esbuild/win32-x64/-/win32-x64-0.18.20.tgz -> npmpkg-@esbuild-win32-x64-0.18.20.tgz
https://registry.npmjs.org/eslint/-/eslint-8.56.0.tgz -> npmpkg-eslint-8.56.0.tgz
https://registry.npmjs.org/eslint-plugin-import/-/eslint-plugin-import-2.29.1.tgz -> npmpkg-eslint-plugin-import-2.29.1.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/doctrine/-/doctrine-2.1.0.tgz -> npmpkg-doctrine-2.1.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/prettier/-/prettier-3.1.1.tgz -> npmpkg-prettier-3.1.1.tgz
https://registry.npmjs.org/@rollup/rollup-android-arm-eabi/-/rollup-android-arm-eabi-4.9.0.tgz -> npmpkg-@rollup-rollup-android-arm-eabi-4.9.0.tgz
https://registry.npmjs.org/@rollup/rollup-android-arm64/-/rollup-android-arm64-4.9.0.tgz -> npmpkg-@rollup-rollup-android-arm64-4.9.0.tgz
https://registry.npmjs.org/@rollup/rollup-darwin-arm64/-/rollup-darwin-arm64-4.9.0.tgz -> npmpkg-@rollup-rollup-darwin-arm64-4.9.0.tgz
https://registry.npmjs.org/@rollup/rollup-darwin-x64/-/rollup-darwin-x64-4.9.0.tgz -> npmpkg-@rollup-rollup-darwin-x64-4.9.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-arm-gnueabihf/-/rollup-linux-arm-gnueabihf-4.9.0.tgz -> npmpkg-@rollup-rollup-linux-arm-gnueabihf-4.9.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-arm64-gnu/-/rollup-linux-arm64-gnu-4.9.0.tgz -> npmpkg-@rollup-rollup-linux-arm64-gnu-4.9.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-arm64-musl/-/rollup-linux-arm64-musl-4.9.0.tgz -> npmpkg-@rollup-rollup-linux-arm64-musl-4.9.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-riscv64-gnu/-/rollup-linux-riscv64-gnu-4.9.0.tgz -> npmpkg-@rollup-rollup-linux-riscv64-gnu-4.9.0.tgz
https://registry.npmjs.org/@rollup/rollup-win32-arm64-msvc/-/rollup-win32-arm64-msvc-4.9.0.tgz -> npmpkg-@rollup-rollup-win32-arm64-msvc-4.9.0.tgz
https://registry.npmjs.org/@rollup/rollup-win32-ia32-msvc/-/rollup-win32-ia32-msvc-4.9.0.tgz -> npmpkg-@rollup-rollup-win32-ia32-msvc-4.9.0.tgz
https://registry.npmjs.org/@rollup/rollup-win32-x64-msvc/-/rollup-win32-x64-msvc-4.9.0.tgz -> npmpkg-@rollup-rollup-win32-x64-msvc-4.9.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/stylelint/-/stylelint-15.11.0.tgz -> npmpkg-stylelint-15.11.0.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-2.0.0.tgz -> npmpkg-balanced-match-2.0.0.tgz
https://registry.npmjs.org/file-entry-cache/-/file-entry-cache-7.0.2.tgz -> npmpkg-file-entry-cache-7.0.2.tgz
https://registry.npmjs.org/svelte-check/-/svelte-check-3.6.2.tgz -> npmpkg-svelte-check-3.6.2.tgz
https://registry.npmjs.org/estree-walker/-/estree-walker-3.0.3.tgz -> npmpkg-estree-walker-3.0.3.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-1.0.4.tgz -> npmpkg-mkdirp-1.0.4.tgz
https://registry.npmjs.org/@tauri-apps/api/-/api-1.5.1.tgz -> npmpkg-@tauri-apps-api-1.5.1.tgz
https://registry.npmjs.org/typescript/-/typescript-5.3.3.tgz -> npmpkg-typescript-5.3.3.tgz
https://registry.npmjs.org/@esbuild/android-arm/-/android-arm-0.19.9.tgz -> npmpkg-@esbuild-android-arm-0.19.9.tgz
https://registry.npmjs.org/@esbuild/android-arm64/-/android-arm64-0.19.9.tgz -> npmpkg-@esbuild-android-arm64-0.19.9.tgz
https://registry.npmjs.org/@esbuild/android-x64/-/android-x64-0.19.9.tgz -> npmpkg-@esbuild-android-x64-0.19.9.tgz
https://registry.npmjs.org/@esbuild/darwin-arm64/-/darwin-arm64-0.19.9.tgz -> npmpkg-@esbuild-darwin-arm64-0.19.9.tgz
https://registry.npmjs.org/@esbuild/darwin-x64/-/darwin-x64-0.19.9.tgz -> npmpkg-@esbuild-darwin-x64-0.19.9.tgz
https://registry.npmjs.org/@esbuild/freebsd-arm64/-/freebsd-arm64-0.19.9.tgz -> npmpkg-@esbuild-freebsd-arm64-0.19.9.tgz
https://registry.npmjs.org/@esbuild/freebsd-x64/-/freebsd-x64-0.19.9.tgz -> npmpkg-@esbuild-freebsd-x64-0.19.9.tgz
https://registry.npmjs.org/@esbuild/linux-arm/-/linux-arm-0.19.9.tgz -> npmpkg-@esbuild-linux-arm-0.19.9.tgz
https://registry.npmjs.org/@esbuild/linux-arm64/-/linux-arm64-0.19.9.tgz -> npmpkg-@esbuild-linux-arm64-0.19.9.tgz
https://registry.npmjs.org/@esbuild/linux-ia32/-/linux-ia32-0.19.9.tgz -> npmpkg-@esbuild-linux-ia32-0.19.9.tgz
https://registry.npmjs.org/@esbuild/linux-loong64/-/linux-loong64-0.19.9.tgz -> npmpkg-@esbuild-linux-loong64-0.19.9.tgz
https://registry.npmjs.org/@esbuild/linux-mips64el/-/linux-mips64el-0.19.9.tgz -> npmpkg-@esbuild-linux-mips64el-0.19.9.tgz
https://registry.npmjs.org/@esbuild/linux-ppc64/-/linux-ppc64-0.19.9.tgz -> npmpkg-@esbuild-linux-ppc64-0.19.9.tgz
https://registry.npmjs.org/@esbuild/linux-riscv64/-/linux-riscv64-0.19.9.tgz -> npmpkg-@esbuild-linux-riscv64-0.19.9.tgz
https://registry.npmjs.org/@esbuild/linux-s390x/-/linux-s390x-0.19.9.tgz -> npmpkg-@esbuild-linux-s390x-0.19.9.tgz
https://registry.npmjs.org/@esbuild/linux-x64/-/linux-x64-0.19.9.tgz -> npmpkg-@esbuild-linux-x64-0.19.9.tgz
https://registry.npmjs.org/@esbuild/netbsd-x64/-/netbsd-x64-0.19.9.tgz -> npmpkg-@esbuild-netbsd-x64-0.19.9.tgz
https://registry.npmjs.org/@esbuild/openbsd-x64/-/openbsd-x64-0.19.9.tgz -> npmpkg-@esbuild-openbsd-x64-0.19.9.tgz
https://registry.npmjs.org/@esbuild/sunos-x64/-/sunos-x64-0.19.9.tgz -> npmpkg-@esbuild-sunos-x64-0.19.9.tgz
https://registry.npmjs.org/@esbuild/win32-arm64/-/win32-arm64-0.19.9.tgz -> npmpkg-@esbuild-win32-arm64-0.19.9.tgz
https://registry.npmjs.org/@esbuild/win32-ia32/-/win32-ia32-0.19.9.tgz -> npmpkg-@esbuild-win32-ia32-0.19.9.tgz
https://registry.npmjs.org/@esbuild/win32-x64/-/win32-x64-0.19.9.tgz -> npmpkg-@esbuild-win32-x64-0.19.9.tgz
https://registry.npmjs.org/esbuild/-/esbuild-0.19.9.tgz -> npmpkg-esbuild-0.19.9.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS

SRC_URI="
$(cargo_crate_uris ${CRATES})
${NPM_EXTERNAL_URIS}
https://github.com/colinlienard/gitlight/archive/refs/tags/gitlight-v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${PN}-v${PV}"

DESCRIPTION="GitHub & GitLab notifications on your desktop"
HOMEPAGE="
https://github.com/colinlienard/gitlight
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
#KEYWORDS="~amd64" # Ebuild still in development
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" tray wayland +X"
REQUIRED_USE="
	|| (
		wayland
		X
	)
"
# U 20.04
WEBKIT_GTK_STABLE=(
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
	# There is a bug with webkit-gtk's jit that causes it to crash.
		echo "=net-libs/webkit-gtk-${s}*:4[-dfg-jit,-ftl-jit,-jit,-yarr-jit,introspection,wayland?,X?]"
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
einfo "Unpacking npm side"
	S="${WORKDIR}/${MY_PN}-v${PV}" \
	npm_src_unpack

einfo "Unpacking tauri side"
	pushd "${WORKDIR}/${MY_PN}-v${PV}/src-tauri" || die
		S="${WORKDIR}/${MY_PN}-v${PV}/src-tauri" \
		_cargo_src_unpack
	popd

	cd "${WORKDIR}" || die
	local commit="cdb77c4b650a81a9c44c4b5db5a46c31954dd7f9"
	mkdir -p "${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/autostart" || die
#	mkdir -p "${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/deep-link" || die
	mkdir -p "${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/positioner" || die
	mkdir -p "${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/window-state" || die
	unpack "${DISTDIR}/plugins-workspace-${commit}.gh.tar.gz"
	cp -aT \
		"${WORKDIR}/plugins-workspace-${commit}/plugins/autostart" \
		"${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/autostart" \
		|| die
#	cp -aT \
#		"${WORKDIR}/plugins-workspace-${commit}/plugins/deep-link" \
#		"${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/deep-link" \
#		|| die
	cp -aT \
		"${WORKDIR}/plugins-workspace-${commit}/plugins/positioner" \
		"${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/positioner" \
		|| die
	cp -aT \
		"${WORKDIR}/plugins-workspace-${commit}/plugins/window-state" \
		"${WORKDIR}/cargo_home/gentoo/plugins-workspace-${commit}/plugins/window-state" \
		|| die
}

src_configure() {
	if [[ ! -e "${GITLIGHT_CREDENTIALS_PATH}" ]] ; then
eerror
eerror "You need to create your own API keys/tokens to use this software"
eerror
eerror "You must set GITLIGHT_CREDENTIALS_PATH as an environment variable"
eerror "pointing to a single file with the following variables:"
eerror
eerror "AUTH_GITHUB_ID=\"<GITHUB_ID>\""
eerror "AUTH_GITHUB_SECRET=\"<GITHUB_SECRET>\""
eerror "AUTH_GITLAB_ID=\"<GITLAB_ID>\""
eerror "AUTH_GITLAB_SECRET=\"<GITLAB_SECRET>\""
eerror "..."
eerror
eerror "For the full list, see"
eerror
eerror "  https://github.com/colinlienard/gitlight/blob/gitlight-v0.16.0/.env.example"
eerror "  https://github.com/colinlienard/gitlight/blob/main/CONTRIBUTING.md#github-oauth-app"
eerror
eerror
eerror "Security Notices:"
eerror
eerror "The credentials should be stored in a secure location."
eerror
eerror
eerror "Setting up the GITLIGHT_CREDENTIALS_PATH via per-package env..."
eerror
eerror "Contents of /etc/portage/env/gitlight.conf:"
eerror
eerror "  GITLIGHT_CREDENTIALS_PATH=\"secure storage path\""
eerror
eerror "Contents of /etc/portage/package.env:"
eerror
eerror "  ${CATEGORY}/${PN} gitlight.conf"
eerror
		die
	else
# Can we symlink or does it copy it in the binary?
einfo "Copying API tokens/credentials to ${S}/.env"
		cat "${GITLIGHT_CREDENTIALS_PATH}" > "${S}/.env" || die
	fi
	pushd "${WORKDIR}/${MY_PN}-v${PV}/src-tauri" || die
		S="${WORKDIR}/${MY_PN}-v${PV}/src-tauri" \
		cargo_src_configure
	popd
}

src_compile() {
einfo "Building npm side"
	S="${WORKDIR}/${MY_PN}-v${PV}" \
	npm_src_compile
	grep -e "- error TS" "${T}/build.log" && die "Detected error.  Emerge again."
einfo "Building tauri side"
	enpm run build:tauri
#
# Running cargo_src_compile doesn't work because tauri.conf.json with tauri does
# more extra build steps.
#
#	pushd "${WORKDIR}/${MY_PN}-v${PV}/src-tauri" || die
#einfo "Building tauri side"
#		S="${WORKDIR}/${MY_PN}-v${PV}/src-tauri" \
#		cargo_src_compile
#	popd
einfo "Secure deleting copied tokens/credentials at ${S}/.env"
	shred -f "${S}/.env" || die
}

src_install() {
	exeinto /usr/bin
	doexe src-tauri/target/release/git-light

	make_desktop_entry \
		"git-light" \
		"${PN}" \
		"GitLight" \
		"Development;RevisionControl"

	newicon -s 32 assets/logo.png git-light.png
	newicon -s 128 assets/logo.png git-light.png
	newicon -s 256 assets/logo.png git-light.png

	LCNR_SOURCE="${WORKDIR}/cargo_home/gentoo"
	LCNR_TAG="third_party_cargo"
	lcnr_install_files

	LCNR_SOURCE="${WORKDIR}/${MY_PN}-v${PV}/node_modules"
	LCNR_TAG="third_party_npm"
	lcnr_install_files
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  TBA
