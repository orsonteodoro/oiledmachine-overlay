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
NPM_OFFLINE=0
NPM_INSTALL_UNPACK_ARGS="--legacy-peer-deps"
inherit cargo desktop lcnr npm user-info xdg

# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@aashutoshrathi/word-wrap/-/word-wrap-1.2.6.tgz -> npmpkg-@aashutoshrathi-word-wrap-1.2.6.tgz
https://registry.npmjs.org/@ampproject/remapping/-/remapping-2.2.1.tgz -> npmpkg-@ampproject-remapping-2.2.1.tgz
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.23.5.tgz -> npmpkg-@babel-code-frame-7.23.5.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.22.20.tgz -> npmpkg-@babel-helper-validator-identifier-7.22.20.tgz
https://registry.npmjs.org/@babel/highlight/-/highlight-7.23.4.tgz -> npmpkg-@babel-highlight-7.23.4.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/@csstools/css-parser-algorithms/-/css-parser-algorithms-2.4.0.tgz -> npmpkg-@csstools-css-parser-algorithms-2.4.0.tgz
https://registry.npmjs.org/@csstools/css-tokenizer/-/css-tokenizer-2.2.2.tgz -> npmpkg-@csstools-css-tokenizer-2.2.2.tgz
https://registry.npmjs.org/@csstools/media-query-list-parser/-/media-query-list-parser-2.1.6.tgz -> npmpkg-@csstools-media-query-list-parser-2.1.6.tgz
https://registry.npmjs.org/@csstools/selector-specificity/-/selector-specificity-3.0.1.tgz -> npmpkg-@csstools-selector-specificity-3.0.1.tgz
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
https://registry.npmjs.org/@esbuild/linux-x64/-/linux-x64-0.18.20.tgz -> npmpkg-@esbuild-linux-x64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/netbsd-x64/-/netbsd-x64-0.18.20.tgz -> npmpkg-@esbuild-netbsd-x64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/openbsd-x64/-/openbsd-x64-0.18.20.tgz -> npmpkg-@esbuild-openbsd-x64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/sunos-x64/-/sunos-x64-0.18.20.tgz -> npmpkg-@esbuild-sunos-x64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/win32-arm64/-/win32-arm64-0.18.20.tgz -> npmpkg-@esbuild-win32-arm64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/win32-ia32/-/win32-ia32-0.18.20.tgz -> npmpkg-@esbuild-win32-ia32-0.18.20.tgz
https://registry.npmjs.org/@esbuild/win32-x64/-/win32-x64-0.18.20.tgz -> npmpkg-@esbuild-win32-x64-0.18.20.tgz
https://registry.npmjs.org/@eslint-community/eslint-utils/-/eslint-utils-4.4.0.tgz -> npmpkg-@eslint-community-eslint-utils-4.4.0.tgz
https://registry.npmjs.org/@eslint-community/regexpp/-/regexpp-4.10.0.tgz -> npmpkg-@eslint-community-regexpp-4.10.0.tgz
https://registry.npmjs.org/@eslint/eslintrc/-/eslintrc-2.1.4.tgz -> npmpkg-@eslint-eslintrc-2.1.4.tgz
https://registry.npmjs.org/@eslint/js/-/js-8.56.0.tgz -> npmpkg-@eslint-js-8.56.0.tgz
https://registry.npmjs.org/@fastify/busboy/-/busboy-2.1.0.tgz -> npmpkg-@fastify-busboy-2.1.0.tgz
https://registry.npmjs.org/@humanwhocodes/config-array/-/config-array-0.11.13.tgz -> npmpkg-@humanwhocodes-config-array-0.11.13.tgz
https://registry.npmjs.org/@humanwhocodes/module-importer/-/module-importer-1.0.1.tgz -> npmpkg-@humanwhocodes-module-importer-1.0.1.tgz
https://registry.npmjs.org/@humanwhocodes/object-schema/-/object-schema-2.0.1.tgz -> npmpkg-@humanwhocodes-object-schema-2.0.1.tgz
https://registry.npmjs.org/@jridgewell/gen-mapping/-/gen-mapping-0.3.3.tgz -> npmpkg-@jridgewell-gen-mapping-0.3.3.tgz
https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.1.tgz -> npmpkg-@jridgewell-resolve-uri-3.1.1.tgz
https://registry.npmjs.org/@jridgewell/set-array/-/set-array-1.1.2.tgz -> npmpkg-@jridgewell-set-array-1.1.2.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.15.tgz -> npmpkg-@jridgewell-sourcemap-codec-1.4.15.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.20.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.20.tgz
https://registry.npmjs.org/@mapbox/node-pre-gyp/-/node-pre-gyp-1.0.11.tgz -> npmpkg-@mapbox-node-pre-gyp-1.0.11.tgz
https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> npmpkg-@nodelib-fs.scandir-2.1.5.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> npmpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> npmpkg-@nodelib-fs.walk-1.2.8.tgz
https://registry.npmjs.org/@polka/url/-/url-1.0.0-next.24.tgz -> npmpkg-@polka-url-1.0.0-next.24.tgz
https://registry.npmjs.org/@rive-app/canvas/-/canvas-2.8.3.tgz -> npmpkg-@rive-app-canvas-2.8.3.tgz
https://registry.npmjs.org/@rollup/pluginutils/-/pluginutils-4.2.1.tgz -> npmpkg-@rollup-pluginutils-4.2.1.tgz
https://registry.npmjs.org/@rollup/rollup-android-arm-eabi/-/rollup-android-arm-eabi-4.9.1.tgz -> npmpkg-@rollup-rollup-android-arm-eabi-4.9.1.tgz
https://registry.npmjs.org/@rollup/rollup-android-arm64/-/rollup-android-arm64-4.9.1.tgz -> npmpkg-@rollup-rollup-android-arm64-4.9.1.tgz
https://registry.npmjs.org/@rollup/rollup-darwin-arm64/-/rollup-darwin-arm64-4.9.1.tgz -> npmpkg-@rollup-rollup-darwin-arm64-4.9.1.tgz
https://registry.npmjs.org/@rollup/rollup-darwin-x64/-/rollup-darwin-x64-4.9.1.tgz -> npmpkg-@rollup-rollup-darwin-x64-4.9.1.tgz
https://registry.npmjs.org/@rollup/rollup-linux-arm-gnueabihf/-/rollup-linux-arm-gnueabihf-4.9.1.tgz -> npmpkg-@rollup-rollup-linux-arm-gnueabihf-4.9.1.tgz
https://registry.npmjs.org/@rollup/rollup-linux-arm64-gnu/-/rollup-linux-arm64-gnu-4.9.1.tgz -> npmpkg-@rollup-rollup-linux-arm64-gnu-4.9.1.tgz
https://registry.npmjs.org/@rollup/rollup-linux-arm64-musl/-/rollup-linux-arm64-musl-4.9.1.tgz -> npmpkg-@rollup-rollup-linux-arm64-musl-4.9.1.tgz
https://registry.npmjs.org/@rollup/rollup-linux-riscv64-gnu/-/rollup-linux-riscv64-gnu-4.9.1.tgz -> npmpkg-@rollup-rollup-linux-riscv64-gnu-4.9.1.tgz
https://registry.npmjs.org/@rollup/rollup-linux-x64-gnu/-/rollup-linux-x64-gnu-4.9.1.tgz -> npmpkg-@rollup-rollup-linux-x64-gnu-4.9.1.tgz
https://registry.npmjs.org/@rollup/rollup-linux-x64-musl/-/rollup-linux-x64-musl-4.9.1.tgz -> npmpkg-@rollup-rollup-linux-x64-musl-4.9.1.tgz
https://registry.npmjs.org/@rollup/rollup-win32-arm64-msvc/-/rollup-win32-arm64-msvc-4.9.1.tgz -> npmpkg-@rollup-rollup-win32-arm64-msvc-4.9.1.tgz
https://registry.npmjs.org/@rollup/rollup-win32-ia32-msvc/-/rollup-win32-ia32-msvc-4.9.1.tgz -> npmpkg-@rollup-rollup-win32-ia32-msvc-4.9.1.tgz
https://registry.npmjs.org/@rollup/rollup-win32-x64-msvc/-/rollup-win32-x64-msvc-4.9.1.tgz -> npmpkg-@rollup-rollup-win32-x64-msvc-4.9.1.tgz
https://registry.npmjs.org/@sveltejs/adapter-static/-/adapter-static-2.0.3.tgz -> npmpkg-@sveltejs-adapter-static-2.0.3.tgz
https://registry.npmjs.org/@sveltejs/adapter-vercel/-/adapter-vercel-3.1.0.tgz -> npmpkg-@sveltejs-adapter-vercel-3.1.0.tgz
https://registry.npmjs.org/@sveltejs/kit/-/kit-1.30.3.tgz -> npmpkg-@sveltejs-kit-1.30.3.tgz
https://registry.npmjs.org/@sveltejs/vite-plugin-svelte/-/vite-plugin-svelte-2.5.3.tgz -> npmpkg-@sveltejs-vite-plugin-svelte-2.5.3.tgz
https://registry.npmjs.org/@sveltejs/vite-plugin-svelte-inspector/-/vite-plugin-svelte-inspector-1.0.4.tgz -> npmpkg-@sveltejs-vite-plugin-svelte-inspector-1.0.4.tgz
https://registry.npmjs.org/@tauri-apps/api/-/api-1.5.2.tgz -> npmpkg-@tauri-apps-api-1.5.2.tgz
https://registry.npmjs.org/@tauri-apps/cli/-/cli-1.5.8.tgz -> npmpkg-@tauri-apps-cli-1.5.8.tgz
https://registry.npmjs.org/@tauri-apps/cli-darwin-arm64/-/cli-darwin-arm64-1.5.8.tgz -> npmpkg-@tauri-apps-cli-darwin-arm64-1.5.8.tgz
https://registry.npmjs.org/@tauri-apps/cli-darwin-x64/-/cli-darwin-x64-1.5.8.tgz -> npmpkg-@tauri-apps-cli-darwin-x64-1.5.8.tgz
https://registry.npmjs.org/@tauri-apps/cli-linux-arm-gnueabihf/-/cli-linux-arm-gnueabihf-1.5.8.tgz -> npmpkg-@tauri-apps-cli-linux-arm-gnueabihf-1.5.8.tgz
https://registry.npmjs.org/@tauri-apps/cli-linux-arm64-gnu/-/cli-linux-arm64-gnu-1.5.8.tgz -> npmpkg-@tauri-apps-cli-linux-arm64-gnu-1.5.8.tgz
https://registry.npmjs.org/@tauri-apps/cli-linux-arm64-musl/-/cli-linux-arm64-musl-1.5.8.tgz -> npmpkg-@tauri-apps-cli-linux-arm64-musl-1.5.8.tgz
https://registry.npmjs.org/@tauri-apps/cli-linux-x64-gnu/-/cli-linux-x64-gnu-1.5.8.tgz -> npmpkg-@tauri-apps-cli-linux-x64-gnu-1.5.8.tgz
https://registry.npmjs.org/@tauri-apps/cli-linux-x64-musl/-/cli-linux-x64-musl-1.5.8.tgz -> npmpkg-@tauri-apps-cli-linux-x64-musl-1.5.8.tgz
https://registry.npmjs.org/@tauri-apps/cli-win32-arm64-msvc/-/cli-win32-arm64-msvc-1.5.8.tgz -> npmpkg-@tauri-apps-cli-win32-arm64-msvc-1.5.8.tgz
https://registry.npmjs.org/@tauri-apps/cli-win32-ia32-msvc/-/cli-win32-ia32-msvc-1.5.8.tgz -> npmpkg-@tauri-apps-cli-win32-ia32-msvc-1.5.8.tgz
https://registry.npmjs.org/@tauri-apps/cli-win32-x64-msvc/-/cli-win32-x64-msvc-1.5.8.tgz -> npmpkg-@tauri-apps-cli-win32-x64-msvc-1.5.8.tgz
https://registry.npmjs.org/@types/cookie/-/cookie-0.5.4.tgz -> npmpkg-@types-cookie-0.5.4.tgz
https://registry.npmjs.org/@types/estree/-/estree-1.0.5.tgz -> npmpkg-@types-estree-1.0.5.tgz
https://registry.npmjs.org/@types/json-schema/-/json-schema-7.0.15.tgz -> npmpkg-@types-json-schema-7.0.15.tgz
https://registry.npmjs.org/@types/json5/-/json5-0.0.29.tgz -> npmpkg-@types-json5-0.0.29.tgz
https://registry.npmjs.org/@types/minimist/-/minimist-1.2.5.tgz -> npmpkg-@types-minimist-1.2.5.tgz
https://registry.npmjs.org/@types/normalize-package-data/-/normalize-package-data-2.4.4.tgz -> npmpkg-@types-normalize-package-data-2.4.4.tgz
https://registry.npmjs.org/@types/pug/-/pug-2.0.10.tgz -> npmpkg-@types-pug-2.0.10.tgz
https://registry.npmjs.org/@types/semver/-/semver-7.5.6.tgz -> npmpkg-@types-semver-7.5.6.tgz
https://registry.npmjs.org/@typescript-eslint/eslint-plugin/-/eslint-plugin-6.14.0.tgz -> npmpkg-@typescript-eslint-eslint-plugin-6.14.0.tgz
https://registry.npmjs.org/@typescript-eslint/parser/-/parser-6.14.0.tgz -> npmpkg-@typescript-eslint-parser-6.14.0.tgz
https://registry.npmjs.org/@typescript-eslint/scope-manager/-/scope-manager-6.14.0.tgz -> npmpkg-@typescript-eslint-scope-manager-6.14.0.tgz
https://registry.npmjs.org/@typescript-eslint/type-utils/-/type-utils-6.14.0.tgz -> npmpkg-@typescript-eslint-type-utils-6.14.0.tgz
https://registry.npmjs.org/@typescript-eslint/types/-/types-6.14.0.tgz -> npmpkg-@typescript-eslint-types-6.14.0.tgz
https://registry.npmjs.org/@typescript-eslint/typescript-estree/-/typescript-estree-6.14.0.tgz -> npmpkg-@typescript-eslint-typescript-estree-6.14.0.tgz
https://registry.npmjs.org/@typescript-eslint/utils/-/utils-6.14.0.tgz -> npmpkg-@typescript-eslint-utils-6.14.0.tgz
https://registry.npmjs.org/@typescript-eslint/visitor-keys/-/visitor-keys-6.14.0.tgz -> npmpkg-@typescript-eslint-visitor-keys-6.14.0.tgz
https://registry.npmjs.org/@ungap/structured-clone/-/structured-clone-1.2.0.tgz -> npmpkg-@ungap-structured-clone-1.2.0.tgz
https://registry.npmjs.org/@vercel/nft/-/nft-0.24.4.tgz -> npmpkg-@vercel-nft-0.24.4.tgz
https://registry.npmjs.org/abbrev/-/abbrev-1.1.1.tgz -> npmpkg-abbrev-1.1.1.tgz
https://registry.npmjs.org/acorn/-/acorn-8.11.2.tgz -> npmpkg-acorn-8.11.2.tgz
https://registry.npmjs.org/acorn-jsx/-/acorn-jsx-5.3.2.tgz -> npmpkg-acorn-jsx-5.3.2.tgz
https://registry.npmjs.org/agent-base/-/agent-base-6.0.2.tgz -> npmpkg-agent-base-6.0.2.tgz
https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz -> npmpkg-ajv-6.12.6.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz -> npmpkg-anymatch-3.1.3.tgz
https://registry.npmjs.org/aproba/-/aproba-2.0.0.tgz -> npmpkg-aproba-2.0.0.tgz
https://registry.npmjs.org/are-we-there-yet/-/are-we-there-yet-2.0.0.tgz -> npmpkg-are-we-there-yet-2.0.0.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz -> npmpkg-argparse-2.0.1.tgz
https://registry.npmjs.org/aria-query/-/aria-query-5.3.0.tgz -> npmpkg-aria-query-5.3.0.tgz
https://registry.npmjs.org/array-buffer-byte-length/-/array-buffer-byte-length-1.0.0.tgz -> npmpkg-array-buffer-byte-length-1.0.0.tgz
https://registry.npmjs.org/array-includes/-/array-includes-3.1.7.tgz -> npmpkg-array-includes-3.1.7.tgz
https://registry.npmjs.org/array-union/-/array-union-2.1.0.tgz -> npmpkg-array-union-2.1.0.tgz
https://registry.npmjs.org/array.prototype.findlastindex/-/array.prototype.findlastindex-1.2.3.tgz -> npmpkg-array.prototype.findlastindex-1.2.3.tgz
https://registry.npmjs.org/array.prototype.flat/-/array.prototype.flat-1.3.2.tgz -> npmpkg-array.prototype.flat-1.3.2.tgz
https://registry.npmjs.org/array.prototype.flatmap/-/array.prototype.flatmap-1.3.2.tgz -> npmpkg-array.prototype.flatmap-1.3.2.tgz
https://registry.npmjs.org/arraybuffer.prototype.slice/-/arraybuffer.prototype.slice-1.0.2.tgz -> npmpkg-arraybuffer.prototype.slice-1.0.2.tgz
https://registry.npmjs.org/arrify/-/arrify-1.0.1.tgz -> npmpkg-arrify-1.0.1.tgz
https://registry.npmjs.org/astral-regex/-/astral-regex-2.0.0.tgz -> npmpkg-astral-regex-2.0.0.tgz
https://registry.npmjs.org/async-sema/-/async-sema-3.1.1.tgz -> npmpkg-async-sema-3.1.1.tgz
https://registry.npmjs.org/available-typed-arrays/-/available-typed-arrays-1.0.5.tgz -> npmpkg-available-typed-arrays-1.0.5.tgz
https://registry.npmjs.org/axobject-query/-/axobject-query-3.2.1.tgz -> npmpkg-axobject-query-3.2.1.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz -> npmpkg-balanced-match-1.0.2.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.2.0.tgz -> npmpkg-binary-extensions-2.2.0.tgz
https://registry.npmjs.org/bindings/-/bindings-1.5.0.tgz -> npmpkg-bindings-1.5.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/braces/-/braces-3.0.2.tgz -> npmpkg-braces-3.0.2.tgz
https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> npmpkg-buffer-crc32-0.2.13.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.5.tgz -> npmpkg-call-bind-1.0.5.tgz
https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz -> npmpkg-callsites-3.1.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-6.3.0.tgz -> npmpkg-camelcase-6.3.0.tgz
https://registry.npmjs.org/camelcase-keys/-/camelcase-keys-7.0.2.tgz -> npmpkg-camelcase-keys-7.0.2.tgz
https://registry.npmjs.org/type-fest/-/type-fest-1.4.0.tgz -> npmpkg-type-fest-1.4.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.5.3.tgz -> npmpkg-chokidar-3.5.3.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/chownr/-/chownr-2.0.0.tgz -> npmpkg-chownr-2.0.0.tgz
https://registry.npmjs.org/code-red/-/code-red-1.0.4.tgz -> npmpkg-code-red-1.0.4.tgz
https://registry.npmjs.org/estree-walker/-/estree-walker-3.0.3.tgz -> npmpkg-estree-walker-3.0.3.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/color-support/-/color-support-1.1.3.tgz -> npmpkg-color-support-1.1.3.tgz
https://registry.npmjs.org/colord/-/colord-2.9.3.tgz -> npmpkg-colord-2.9.3.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/console-control-strings/-/console-control-strings-1.1.0.tgz -> npmpkg-console-control-strings-1.1.0.tgz
https://registry.npmjs.org/cookie/-/cookie-0.5.0.tgz -> npmpkg-cookie-0.5.0.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-8.3.6.tgz -> npmpkg-cosmiconfig-8.3.6.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/css-functions-list/-/css-functions-list-3.2.1.tgz -> npmpkg-css-functions-list-3.2.1.tgz
https://registry.npmjs.org/css-tree/-/css-tree-2.3.1.tgz -> npmpkg-css-tree-2.3.1.tgz
https://registry.npmjs.org/cssesc/-/cssesc-3.0.0.tgz -> npmpkg-cssesc-3.0.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/decamelize/-/decamelize-5.0.1.tgz -> npmpkg-decamelize-5.0.1.tgz
https://registry.npmjs.org/decamelize-keys/-/decamelize-keys-1.1.1.tgz -> npmpkg-decamelize-keys-1.1.1.tgz
https://registry.npmjs.org/decamelize/-/decamelize-1.2.0.tgz -> npmpkg-decamelize-1.2.0.tgz
https://registry.npmjs.org/map-obj/-/map-obj-1.0.1.tgz -> npmpkg-map-obj-1.0.1.tgz
https://registry.npmjs.org/deep-is/-/deep-is-0.1.4.tgz -> npmpkg-deep-is-0.1.4.tgz
https://registry.npmjs.org/deepmerge/-/deepmerge-4.3.1.tgz -> npmpkg-deepmerge-4.3.1.tgz
https://registry.npmjs.org/define-data-property/-/define-data-property-1.1.1.tgz -> npmpkg-define-data-property-1.1.1.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.2.1.tgz -> npmpkg-define-properties-1.2.1.tgz
https://registry.npmjs.org/delegates/-/delegates-1.0.0.tgz -> npmpkg-delegates-1.0.0.tgz
https://registry.npmjs.org/dequal/-/dequal-2.0.3.tgz -> npmpkg-dequal-2.0.3.tgz
https://registry.npmjs.org/detect-indent/-/detect-indent-6.1.0.tgz -> npmpkg-detect-indent-6.1.0.tgz
https://registry.npmjs.org/detect-libc/-/detect-libc-2.0.2.tgz -> npmpkg-detect-libc-2.0.2.tgz
https://registry.npmjs.org/devalue/-/devalue-4.3.2.tgz -> npmpkg-devalue-4.3.2.tgz
https://registry.npmjs.org/dir-glob/-/dir-glob-3.0.1.tgz -> npmpkg-dir-glob-3.0.1.tgz
https://registry.npmjs.org/doctrine/-/doctrine-3.0.0.tgz -> npmpkg-doctrine-3.0.0.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.2.tgz -> npmpkg-error-ex-1.3.2.tgz
https://registry.npmjs.org/es-abstract/-/es-abstract-1.22.3.tgz -> npmpkg-es-abstract-1.22.3.tgz
https://registry.npmjs.org/es-set-tostringtag/-/es-set-tostringtag-2.0.2.tgz -> npmpkg-es-set-tostringtag-2.0.2.tgz
https://registry.npmjs.org/es-shim-unscopables/-/es-shim-unscopables-1.0.2.tgz -> npmpkg-es-shim-unscopables-1.0.2.tgz
https://registry.npmjs.org/es-to-primitive/-/es-to-primitive-1.2.1.tgz -> npmpkg-es-to-primitive-1.2.1.tgz
https://registry.npmjs.org/es6-promise/-/es6-promise-3.3.1.tgz -> npmpkg-es6-promise-3.3.1.tgz
https://registry.npmjs.org/esbuild/-/esbuild-0.18.20.tgz -> npmpkg-esbuild-0.18.20.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> npmpkg-escape-string-regexp-4.0.0.tgz
https://registry.npmjs.org/eslint/-/eslint-8.56.0.tgz -> npmpkg-eslint-8.56.0.tgz
https://registry.npmjs.org/eslint-compat-utils/-/eslint-compat-utils-0.1.2.tgz -> npmpkg-eslint-compat-utils-0.1.2.tgz
https://registry.npmjs.org/eslint-config-prettier/-/eslint-config-prettier-9.1.0.tgz -> npmpkg-eslint-config-prettier-9.1.0.tgz
https://registry.npmjs.org/eslint-import-resolver-node/-/eslint-import-resolver-node-0.3.9.tgz -> npmpkg-eslint-import-resolver-node-0.3.9.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/eslint-module-utils/-/eslint-module-utils-2.8.0.tgz -> npmpkg-eslint-module-utils-2.8.0.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/eslint-plugin-import/-/eslint-plugin-import-2.29.1.tgz -> npmpkg-eslint-plugin-import-2.29.1.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/doctrine/-/doctrine-2.1.0.tgz -> npmpkg-doctrine-2.1.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/eslint-plugin-svelte/-/eslint-plugin-svelte-2.35.1.tgz -> npmpkg-eslint-plugin-svelte-2.35.1.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-7.2.2.tgz -> npmpkg-eslint-scope-7.2.2.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-3.4.3.tgz -> npmpkg-eslint-visitor-keys-3.4.3.tgz
https://registry.npmjs.org/esm-env/-/esm-env-1.0.0.tgz -> npmpkg-esm-env-1.0.0.tgz
https://registry.npmjs.org/espree/-/espree-9.6.1.tgz -> npmpkg-espree-9.6.1.tgz
https://registry.npmjs.org/esquery/-/esquery-1.5.0.tgz -> npmpkg-esquery-1.5.0.tgz
https://registry.npmjs.org/esrecurse/-/esrecurse-4.3.0.tgz -> npmpkg-esrecurse-4.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/estree-walker/-/estree-walker-2.0.2.tgz -> npmpkg-estree-walker-2.0.2.tgz
https://registry.npmjs.org/esutils/-/esutils-2.0.3.tgz -> npmpkg-esutils-2.0.3.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> npmpkg-fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-diff/-/fast-diff-1.3.0.tgz -> npmpkg-fast-diff-1.3.0.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.2.tgz -> npmpkg-fast-glob-3.3.2.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> npmpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.npmjs.org/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz -> npmpkg-fast-levenshtein-2.0.6.tgz
https://registry.npmjs.org/fastest-levenshtein/-/fastest-levenshtein-1.0.16.tgz -> npmpkg-fastest-levenshtein-1.0.16.tgz
https://registry.npmjs.org/fastq/-/fastq-1.15.0.tgz -> npmpkg-fastq-1.15.0.tgz
https://registry.npmjs.org/file-entry-cache/-/file-entry-cache-6.0.1.tgz -> npmpkg-file-entry-cache-6.0.1.tgz
https://registry.npmjs.org/file-uri-to-path/-/file-uri-to-path-1.0.0.tgz -> npmpkg-file-uri-to-path-1.0.0.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.0.1.tgz -> npmpkg-fill-range-7.0.1.tgz
https://registry.npmjs.org/find-up/-/find-up-5.0.0.tgz -> npmpkg-find-up-5.0.0.tgz
https://registry.npmjs.org/flat-cache/-/flat-cache-3.2.0.tgz -> npmpkg-flat-cache-3.2.0.tgz
https://registry.npmjs.org/flatted/-/flatted-3.2.9.tgz -> npmpkg-flatted-3.2.9.tgz
https://registry.npmjs.org/for-each/-/for-each-0.3.3.tgz -> npmpkg-for-each-0.3.3.tgz
https://registry.npmjs.org/fs-minipass/-/fs-minipass-2.1.0.tgz -> npmpkg-fs-minipass-2.1.0.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz -> npmpkg-function-bind-1.1.2.tgz
https://registry.npmjs.org/function.prototype.name/-/function.prototype.name-1.1.6.tgz -> npmpkg-function.prototype.name-1.1.6.tgz
https://registry.npmjs.org/functions-have-names/-/functions-have-names-1.2.3.tgz -> npmpkg-functions-have-names-1.2.3.tgz
https://registry.npmjs.org/gauge/-/gauge-3.0.2.tgz -> npmpkg-gauge-3.0.2.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.2.tgz -> npmpkg-get-intrinsic-1.2.2.tgz
https://registry.npmjs.org/get-symbol-description/-/get-symbol-description-1.0.0.tgz -> npmpkg-get-symbol-description-1.0.0.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-6.0.2.tgz -> npmpkg-glob-parent-6.0.2.tgz
https://registry.npmjs.org/global-modules/-/global-modules-2.0.0.tgz -> npmpkg-global-modules-2.0.0.tgz
https://registry.npmjs.org/global-prefix/-/global-prefix-3.0.0.tgz -> npmpkg-global-prefix-3.0.0.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/globals/-/globals-13.24.0.tgz -> npmpkg-globals-13.24.0.tgz
https://registry.npmjs.org/globalthis/-/globalthis-1.0.3.tgz -> npmpkg-globalthis-1.0.3.tgz
https://registry.npmjs.org/globalyzer/-/globalyzer-0.1.0.tgz -> npmpkg-globalyzer-0.1.0.tgz
https://registry.npmjs.org/globby/-/globby-11.1.0.tgz -> npmpkg-globby-11.1.0.tgz
https://registry.npmjs.org/globjoin/-/globjoin-0.1.4.tgz -> npmpkg-globjoin-0.1.4.tgz
https://registry.npmjs.org/globrex/-/globrex-0.1.2.tgz -> npmpkg-globrex-0.1.2.tgz
https://registry.npmjs.org/gopd/-/gopd-1.0.1.tgz -> npmpkg-gopd-1.0.1.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz -> npmpkg-graceful-fs-4.2.11.tgz
https://registry.npmjs.org/graphemer/-/graphemer-1.4.0.tgz -> npmpkg-graphemer-1.4.0.tgz
https://registry.npmjs.org/hard-rejection/-/hard-rejection-2.1.0.tgz -> npmpkg-hard-rejection-2.1.0.tgz
https://registry.npmjs.org/has-bigints/-/has-bigints-1.0.2.tgz -> npmpkg-has-bigints-1.0.2.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.1.tgz -> npmpkg-has-property-descriptors-1.0.1.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.1.tgz -> npmpkg-has-proto-1.0.1.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/has-tostringtag/-/has-tostringtag-1.0.0.tgz -> npmpkg-has-tostringtag-1.0.0.tgz
https://registry.npmjs.org/has-unicode/-/has-unicode-2.0.1.tgz -> npmpkg-has-unicode-2.0.1.tgz
https://registry.npmjs.org/hasown/-/hasown-2.0.0.tgz -> npmpkg-hasown-2.0.0.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-4.1.0.tgz -> npmpkg-hosted-git-info-4.1.0.tgz
https://registry.npmjs.org/html-tags/-/html-tags-3.3.1.tgz -> npmpkg-html-tags-3.3.1.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz -> npmpkg-https-proxy-agent-5.0.1.tgz
https://registry.npmjs.org/ignore/-/ignore-5.3.0.tgz -> npmpkg-ignore-5.3.0.tgz
https://registry.npmjs.org/immutable/-/immutable-4.3.4.tgz -> npmpkg-immutable-4.3.4.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/import-lazy/-/import-lazy-4.0.0.tgz -> npmpkg-import-lazy-4.0.0.tgz
https://registry.npmjs.org/imurmurhash/-/imurmurhash-0.1.4.tgz -> npmpkg-imurmurhash-0.1.4.tgz
https://registry.npmjs.org/indent-string/-/indent-string-5.0.0.tgz -> npmpkg-indent-string-5.0.0.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/internal-slot/-/internal-slot-1.0.6.tgz -> npmpkg-internal-slot-1.0.6.tgz
https://registry.npmjs.org/is-array-buffer/-/is-array-buffer-3.0.2.tgz -> npmpkg-is-array-buffer-3.0.2.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz -> npmpkg-is-arrayish-0.2.1.tgz
https://registry.npmjs.org/is-bigint/-/is-bigint-1.0.4.tgz -> npmpkg-is-bigint-1.0.4.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz -> npmpkg-is-binary-path-2.1.0.tgz
https://registry.npmjs.org/is-boolean-object/-/is-boolean-object-1.1.2.tgz -> npmpkg-is-boolean-object-1.1.2.tgz
https://registry.npmjs.org/is-callable/-/is-callable-1.2.7.tgz -> npmpkg-is-callable-1.2.7.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.13.1.tgz -> npmpkg-is-core-module-2.13.1.tgz
https://registry.npmjs.org/is-date-object/-/is-date-object-1.0.5.tgz -> npmpkg-is-date-object-1.0.5.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/is-negative-zero/-/is-negative-zero-2.0.2.tgz -> npmpkg-is-negative-zero-2.0.2.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/is-number-object/-/is-number-object-1.0.7.tgz -> npmpkg-is-number-object-1.0.7.tgz
https://registry.npmjs.org/is-path-inside/-/is-path-inside-3.0.3.tgz -> npmpkg-is-path-inside-3.0.3.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-1.1.0.tgz -> npmpkg-is-plain-obj-1.1.0.tgz
https://registry.npmjs.org/is-plain-object/-/is-plain-object-5.0.0.tgz -> npmpkg-is-plain-object-5.0.0.tgz
https://registry.npmjs.org/is-reference/-/is-reference-3.0.2.tgz -> npmpkg-is-reference-3.0.2.tgz
https://registry.npmjs.org/is-regex/-/is-regex-1.1.4.tgz -> npmpkg-is-regex-1.1.4.tgz
https://registry.npmjs.org/is-shared-array-buffer/-/is-shared-array-buffer-1.0.2.tgz -> npmpkg-is-shared-array-buffer-1.0.2.tgz
https://registry.npmjs.org/is-string/-/is-string-1.0.7.tgz -> npmpkg-is-string-1.0.7.tgz
https://registry.npmjs.org/is-symbol/-/is-symbol-1.0.4.tgz -> npmpkg-is-symbol-1.0.4.tgz
https://registry.npmjs.org/is-typed-array/-/is-typed-array-1.1.12.tgz -> npmpkg-is-typed-array-1.1.12.tgz
https://registry.npmjs.org/is-weakref/-/is-weakref-1.0.2.tgz -> npmpkg-is-weakref-1.0.2.tgz
https://registry.npmjs.org/isarray/-/isarray-2.0.5.tgz -> npmpkg-isarray-2.0.5.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz -> npmpkg-js-tokens-4.0.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz -> npmpkg-js-yaml-4.1.0.tgz
https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.1.tgz -> npmpkg-json-buffer-3.0.1.tgz
https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz -> npmpkg-json-parse-even-better-errors-2.3.1.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> npmpkg-json-schema-traverse-0.4.1.tgz
https://registry.npmjs.org/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> npmpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/keyv/-/keyv-4.5.4.tgz -> npmpkg-keyv-4.5.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/kleur/-/kleur-4.1.5.tgz -> npmpkg-kleur-4.1.5.tgz
https://registry.npmjs.org/known-css-properties/-/known-css-properties-0.29.0.tgz -> npmpkg-known-css-properties-0.29.0.tgz
https://registry.npmjs.org/levn/-/levn-0.4.1.tgz -> npmpkg-levn-0.4.1.tgz
https://registry.npmjs.org/lilconfig/-/lilconfig-2.1.0.tgz -> npmpkg-lilconfig-2.1.0.tgz
https://registry.npmjs.org/lines-and-columns/-/lines-and-columns-1.2.4.tgz -> npmpkg-lines-and-columns-1.2.4.tgz
https://registry.npmjs.org/locate-character/-/locate-character-3.0.0.tgz -> npmpkg-locate-character-3.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-6.0.0.tgz -> npmpkg-locate-path-6.0.0.tgz
https://registry.npmjs.org/lodash.merge/-/lodash.merge-4.6.2.tgz -> npmpkg-lodash.merge-4.6.2.tgz
https://registry.npmjs.org/lodash.truncate/-/lodash.truncate-4.4.2.tgz -> npmpkg-lodash.truncate-4.4.2.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/magic-string/-/magic-string-0.30.5.tgz -> npmpkg-magic-string-0.30.5.tgz
https://registry.npmjs.org/make-dir/-/make-dir-3.1.0.tgz -> npmpkg-make-dir-3.1.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/map-obj/-/map-obj-4.3.0.tgz -> npmpkg-map-obj-4.3.0.tgz
https://registry.npmjs.org/mathml-tag-names/-/mathml-tag-names-2.1.3.tgz -> npmpkg-mathml-tag-names-2.1.3.tgz
https://registry.npmjs.org/mdn-data/-/mdn-data-2.0.30.tgz -> npmpkg-mdn-data-2.0.30.tgz
https://registry.npmjs.org/meow/-/meow-10.1.5.tgz -> npmpkg-meow-10.1.5.tgz
https://registry.npmjs.org/type-fest/-/type-fest-1.4.0.tgz -> npmpkg-type-fest-1.4.0.tgz
https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz -> npmpkg-merge2-1.4.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.5.tgz -> npmpkg-micromatch-4.0.5.tgz
https://registry.npmjs.org/min-indent/-/min-indent-1.0.1.tgz -> npmpkg-min-indent-1.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/minimist-options/-/minimist-options-4.1.0.tgz -> npmpkg-minimist-options-4.1.0.tgz
https://registry.npmjs.org/minipass/-/minipass-5.0.0.tgz -> npmpkg-minipass-5.0.0.tgz
https://registry.npmjs.org/minizlib/-/minizlib-2.1.2.tgz -> npmpkg-minizlib-2.1.2.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.6.tgz -> npmpkg-mkdirp-0.5.6.tgz
https://registry.npmjs.org/mri/-/mri-1.2.0.tgz -> npmpkg-mri-1.2.0.tgz
https://registry.npmjs.org/mrmime/-/mrmime-1.0.1.tgz -> npmpkg-mrmime-1.0.1.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/nanoid/-/nanoid-3.3.7.tgz -> npmpkg-nanoid-3.3.7.tgz
https://registry.npmjs.org/natural-compare/-/natural-compare-1.4.0.tgz -> npmpkg-natural-compare-1.4.0.tgz
https://registry.npmjs.org/node-fetch/-/node-fetch-2.7.0.tgz -> npmpkg-node-fetch-2.7.0.tgz
https://registry.npmjs.org/node-gyp-build/-/node-gyp-build-4.7.1.tgz -> npmpkg-node-gyp-build-4.7.1.tgz
https://registry.npmjs.org/nopt/-/nopt-5.0.0.tgz -> npmpkg-nopt-5.0.0.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-3.0.3.tgz -> npmpkg-normalize-package-data-3.0.3.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/npmlog/-/npmlog-5.0.1.tgz -> npmpkg-npmlog-5.0.1.tgz
https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz -> npmpkg-object-assign-4.1.1.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.13.1.tgz -> npmpkg-object-inspect-1.13.1.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/object.assign/-/object.assign-4.1.5.tgz -> npmpkg-object.assign-4.1.5.tgz
https://registry.npmjs.org/object.fromentries/-/object.fromentries-2.0.7.tgz -> npmpkg-object.fromentries-2.0.7.tgz
https://registry.npmjs.org/object.groupby/-/object.groupby-1.0.1.tgz -> npmpkg-object.groupby-1.0.1.tgz
https://registry.npmjs.org/object.values/-/object.values-1.1.7.tgz -> npmpkg-object.values-1.1.7.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/optionator/-/optionator-0.9.3.tgz -> npmpkg-optionator-0.9.3.tgz
https://registry.npmjs.org/overlayscrollbars/-/overlayscrollbars-2.4.5.tgz -> npmpkg-overlayscrollbars-2.4.5.tgz
https://registry.npmjs.org/p-limit/-/p-limit-3.1.0.tgz -> npmpkg-p-limit-3.1.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-5.0.0.tgz -> npmpkg-p-locate-5.0.0.tgz
https://registry.npmjs.org/parent-module/-/parent-module-1.0.1.tgz -> npmpkg-parent-module-1.0.1.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-type/-/path-type-4.0.0.tgz -> npmpkg-path-type-4.0.0.tgz
https://registry.npmjs.org/periscopic/-/periscopic-3.1.0.tgz -> npmpkg-periscopic-3.1.0.tgz
https://registry.npmjs.org/estree-walker/-/estree-walker-3.0.3.tgz -> npmpkg-estree-walker-3.0.3.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.0.0.tgz -> npmpkg-picocolors-1.0.0.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/postcss/-/postcss-8.4.32.tgz -> npmpkg-postcss-8.4.32.tgz
https://registry.npmjs.org/postcss-load-config/-/postcss-load-config-3.1.4.tgz -> npmpkg-postcss-load-config-3.1.4.tgz
https://registry.npmjs.org/postcss-media-query-parser/-/postcss-media-query-parser-0.2.3.tgz -> npmpkg-postcss-media-query-parser-0.2.3.tgz
https://registry.npmjs.org/postcss-resolve-nested-selector/-/postcss-resolve-nested-selector-0.1.1.tgz -> npmpkg-postcss-resolve-nested-selector-0.1.1.tgz
https://registry.npmjs.org/postcss-safe-parser/-/postcss-safe-parser-6.0.0.tgz -> npmpkg-postcss-safe-parser-6.0.0.tgz
https://registry.npmjs.org/postcss-scss/-/postcss-scss-4.0.9.tgz -> npmpkg-postcss-scss-4.0.9.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-6.0.13.tgz -> npmpkg-postcss-selector-parser-6.0.13.tgz
https://registry.npmjs.org/postcss-sorting/-/postcss-sorting-7.0.1.tgz -> npmpkg-postcss-sorting-7.0.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-4.2.0.tgz -> npmpkg-postcss-value-parser-4.2.0.tgz
https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.2.1.tgz -> npmpkg-prelude-ls-1.2.1.tgz
https://registry.npmjs.org/prettier/-/prettier-3.1.1.tgz -> npmpkg-prettier-3.1.1.tgz
https://registry.npmjs.org/prettier-linter-helpers/-/prettier-linter-helpers-1.0.0.tgz -> npmpkg-prettier-linter-helpers-1.0.0.tgz
https://registry.npmjs.org/prettier-plugin-svelte/-/prettier-plugin-svelte-3.1.2.tgz -> npmpkg-prettier-plugin-svelte-3.1.2.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz -> npmpkg-punycode-2.3.1.tgz
https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz -> npmpkg-queue-microtask-1.2.3.tgz
https://registry.npmjs.org/quick-lru/-/quick-lru-5.1.1.tgz -> npmpkg-quick-lru-5.1.1.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-6.0.0.tgz -> npmpkg-read-pkg-6.0.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-8.0.0.tgz -> npmpkg-read-pkg-up-8.0.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-1.4.0.tgz -> npmpkg-type-fest-1.4.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-1.4.0.tgz -> npmpkg-type-fest-1.4.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz -> npmpkg-readdirp-3.6.0.tgz
https://registry.npmjs.org/redent/-/redent-4.0.0.tgz -> npmpkg-redent-4.0.0.tgz
https://registry.npmjs.org/regexp.prototype.flags/-/regexp.prototype.flags-1.5.1.tgz -> npmpkg-regexp.prototype.flags-1.5.1.tgz
https://registry.npmjs.org/require-from-string/-/require-from-string-2.0.2.tgz -> npmpkg-require-from-string-2.0.2.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.8.tgz -> npmpkg-resolve-1.22.8.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-5.0.0.tgz -> npmpkg-resolve-from-5.0.0.tgz
https://registry.npmjs.org/reusify/-/reusify-1.0.4.tgz -> npmpkg-reusify-1.0.4.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/rollup/-/rollup-4.9.1.tgz -> npmpkg-rollup-4.9.1.tgz
https://registry.npmjs.org/run-parallel/-/run-parallel-1.2.0.tgz -> npmpkg-run-parallel-1.2.0.tgz
https://registry.npmjs.org/sade/-/sade-1.8.1.tgz -> npmpkg-sade-1.8.1.tgz
https://registry.npmjs.org/safe-array-concat/-/safe-array-concat-1.0.1.tgz -> npmpkg-safe-array-concat-1.0.1.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/safe-regex-test/-/safe-regex-test-1.0.0.tgz -> npmpkg-safe-regex-test-1.0.0.tgz
https://registry.npmjs.org/sander/-/sander-0.5.1.tgz -> npmpkg-sander-0.5.1.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.7.1.tgz -> npmpkg-rimraf-2.7.1.tgz
https://registry.npmjs.org/sass/-/sass-1.69.5.tgz -> npmpkg-sass-1.69.5.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/set-blocking/-/set-blocking-2.0.0.tgz -> npmpkg-set-blocking-2.0.0.tgz
https://registry.npmjs.org/set-cookie-parser/-/set-cookie-parser-2.6.0.tgz -> npmpkg-set-cookie-parser-2.6.0.tgz
https://registry.npmjs.org/set-function-length/-/set-function-length-1.1.1.tgz -> npmpkg-set-function-length-1.1.1.tgz
https://registry.npmjs.org/set-function-name/-/set-function-name-2.0.1.tgz -> npmpkg-set-function-name-2.0.1.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.4.tgz -> npmpkg-side-channel-1.0.4.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.7.tgz -> npmpkg-signal-exit-3.0.7.tgz
https://registry.npmjs.org/sirv/-/sirv-2.0.3.tgz -> npmpkg-sirv-2.0.3.tgz
https://registry.npmjs.org/slash/-/slash-3.0.0.tgz -> npmpkg-slash-3.0.0.tgz
https://registry.npmjs.org/slice-ansi/-/slice-ansi-4.0.0.tgz -> npmpkg-slice-ansi-4.0.0.tgz
https://registry.npmjs.org/sorcery/-/sorcery-0.11.0.tgz -> npmpkg-sorcery-0.11.0.tgz
https://registry.npmjs.org/source-map-js/-/source-map-js-1.0.2.tgz -> npmpkg-source-map-js-1.0.2.tgz
https://registry.npmjs.org/spdx-correct/-/spdx-correct-3.2.0.tgz -> npmpkg-spdx-correct-3.2.0.tgz
https://registry.npmjs.org/spdx-exceptions/-/spdx-exceptions-2.3.0.tgz -> npmpkg-spdx-exceptions-2.3.0.tgz
https://registry.npmjs.org/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> npmpkg-spdx-expression-parse-3.0.1.tgz
https://registry.npmjs.org/spdx-license-ids/-/spdx-license-ids-3.0.16.tgz -> npmpkg-spdx-license-ids-3.0.16.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.3.0.tgz -> npmpkg-string_decoder-1.3.0.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/string.prototype.trim/-/string.prototype.trim-1.2.8.tgz -> npmpkg-string.prototype.trim-1.2.8.tgz
https://registry.npmjs.org/string.prototype.trimend/-/string.prototype.trimend-1.0.7.tgz -> npmpkg-string.prototype.trimend-1.0.7.tgz
https://registry.npmjs.org/string.prototype.trimstart/-/string.prototype.trimstart-1.0.7.tgz -> npmpkg-string.prototype.trimstart-1.0.7.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz -> npmpkg-strip-bom-3.0.0.tgz
https://registry.npmjs.org/strip-indent/-/strip-indent-4.0.0.tgz -> npmpkg-strip-indent-4.0.0.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> npmpkg-strip-json-comments-3.1.1.tgz
https://registry.npmjs.org/style-search/-/style-search-0.1.0.tgz -> npmpkg-style-search-0.1.0.tgz
https://registry.npmjs.org/stylelint/-/stylelint-15.11.0.tgz -> npmpkg-stylelint-15.11.0.tgz
https://registry.npmjs.org/stylelint-config-html/-/stylelint-config-html-1.1.0.tgz -> npmpkg-stylelint-config-html-1.1.0.tgz
https://registry.npmjs.org/stylelint-config-idiomatic-order/-/stylelint-config-idiomatic-order-9.0.0.tgz -> npmpkg-stylelint-config-idiomatic-order-9.0.0.tgz
https://registry.npmjs.org/stylelint-config-recommended/-/stylelint-config-recommended-13.0.0.tgz -> npmpkg-stylelint-config-recommended-13.0.0.tgz
https://registry.npmjs.org/stylelint-config-recommended-scss/-/stylelint-config-recommended-scss-13.1.0.tgz -> npmpkg-stylelint-config-recommended-scss-13.1.0.tgz
https://registry.npmjs.org/stylelint-config-standard/-/stylelint-config-standard-34.0.0.tgz -> npmpkg-stylelint-config-standard-34.0.0.tgz
https://registry.npmjs.org/stylelint-config-standard-scss/-/stylelint-config-standard-scss-11.1.0.tgz -> npmpkg-stylelint-config-standard-scss-11.1.0.tgz
https://registry.npmjs.org/stylelint-order/-/stylelint-order-5.0.0.tgz -> npmpkg-stylelint-order-5.0.0.tgz
https://registry.npmjs.org/stylelint-prettier/-/stylelint-prettier-4.1.0.tgz -> npmpkg-stylelint-prettier-4.1.0.tgz
https://registry.npmjs.org/stylelint-scss/-/stylelint-scss-5.3.2.tgz -> npmpkg-stylelint-scss-5.3.2.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-2.0.0.tgz -> npmpkg-balanced-match-2.0.0.tgz
https://registry.npmjs.org/file-entry-cache/-/file-entry-cache-7.0.2.tgz -> npmpkg-file-entry-cache-7.0.2.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/supports-hyperlinks/-/supports-hyperlinks-3.0.0.tgz -> npmpkg-supports-hyperlinks-3.0.0.tgz
https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> npmpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.npmjs.org/svelte/-/svelte-4.2.8.tgz -> npmpkg-svelte-4.2.8.tgz
https://registry.npmjs.org/svelte-check/-/svelte-check-3.6.2.tgz -> npmpkg-svelte-check-3.6.2.tgz
https://registry.npmjs.org/svelte-eslint-parser/-/svelte-eslint-parser-0.33.1.tgz -> npmpkg-svelte-eslint-parser-0.33.1.tgz
https://registry.npmjs.org/svelte-hmr/-/svelte-hmr-0.15.3.tgz -> npmpkg-svelte-hmr-0.15.3.tgz
https://registry.npmjs.org/svelte-preprocess/-/svelte-preprocess-5.1.3.tgz -> npmpkg-svelte-preprocess-5.1.3.tgz
https://registry.npmjs.org/strip-indent/-/strip-indent-3.0.0.tgz -> npmpkg-strip-indent-3.0.0.tgz
https://registry.npmjs.org/estree-walker/-/estree-walker-3.0.3.tgz -> npmpkg-estree-walker-3.0.3.tgz
https://registry.npmjs.org/svg-tags/-/svg-tags-1.0.0.tgz -> npmpkg-svg-tags-1.0.0.tgz
https://registry.npmjs.org/table/-/table-6.8.1.tgz -> npmpkg-table-6.8.1.tgz
https://registry.npmjs.org/ajv/-/ajv-8.12.0.tgz -> npmpkg-ajv-8.12.0.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> npmpkg-json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/tar/-/tar-6.2.0.tgz -> npmpkg-tar-6.2.0.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-1.0.4.tgz -> npmpkg-mkdirp-1.0.4.tgz
https://registry.npmjs.org/@tauri-apps/api/-/api-1.5.1.tgz -> npmpkg-@tauri-apps-api-1.5.1.tgz
https://registry.npmjs.org/text-table/-/text-table-0.2.0.tgz -> npmpkg-text-table-0.2.0.tgz
https://registry.npmjs.org/tiny-glob/-/tiny-glob-0.2.9.tgz -> npmpkg-tiny-glob-0.2.9.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/totalist/-/totalist-3.0.1.tgz -> npmpkg-totalist-3.0.1.tgz
https://registry.npmjs.org/tr46/-/tr46-0.0.3.tgz -> npmpkg-tr46-0.0.3.tgz
https://registry.npmjs.org/trim-newlines/-/trim-newlines-4.1.1.tgz -> npmpkg-trim-newlines-4.1.1.tgz
https://registry.npmjs.org/ts-api-utils/-/ts-api-utils-1.0.3.tgz -> npmpkg-ts-api-utils-1.0.3.tgz
https://registry.npmjs.org/tsconfig-paths/-/tsconfig-paths-3.15.0.tgz -> npmpkg-tsconfig-paths-3.15.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.6.2.tgz -> npmpkg-tslib-2.6.2.tgz
https://registry.npmjs.org/type-check/-/type-check-0.4.0.tgz -> npmpkg-type-check-0.4.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.20.2.tgz -> npmpkg-type-fest-0.20.2.tgz
https://registry.npmjs.org/typed-array-buffer/-/typed-array-buffer-1.0.0.tgz -> npmpkg-typed-array-buffer-1.0.0.tgz
https://registry.npmjs.org/typed-array-byte-length/-/typed-array-byte-length-1.0.0.tgz -> npmpkg-typed-array-byte-length-1.0.0.tgz
https://registry.npmjs.org/typed-array-byte-offset/-/typed-array-byte-offset-1.0.0.tgz -> npmpkg-typed-array-byte-offset-1.0.0.tgz
https://registry.npmjs.org/typed-array-length/-/typed-array-length-1.0.4.tgz -> npmpkg-typed-array-length-1.0.4.tgz
https://registry.npmjs.org/typescript/-/typescript-5.3.3.tgz -> npmpkg-typescript-5.3.3.tgz
https://registry.npmjs.org/unbox-primitive/-/unbox-primitive-1.0.2.tgz -> npmpkg-unbox-primitive-1.0.2.tgz
https://registry.npmjs.org/undici/-/undici-5.26.5.tgz -> npmpkg-undici-5.26.5.tgz
https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz -> npmpkg-uri-js-4.4.1.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> npmpkg-validate-npm-package-license-3.0.4.tgz
https://registry.npmjs.org/vite/-/vite-5.0.10.tgz -> npmpkg-vite-5.0.10.tgz
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
https://registry.npmjs.org/vitefu/-/vitefu-0.2.5.tgz -> npmpkg-vitefu-0.2.5.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-3.0.1.tgz -> npmpkg-webidl-conversions-3.0.1.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-5.0.0.tgz -> npmpkg-whatwg-url-5.0.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> npmpkg-which-boxed-primitive-1.0.2.tgz
https://registry.npmjs.org/which-typed-array/-/which-typed-array-1.1.13.tgz -> npmpkg-which-typed-array-1.1.13.tgz
https://registry.npmjs.org/wide-align/-/wide-align-1.1.5.tgz -> npmpkg-wide-align-1.1.5.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/write-file-atomic/-/write-file-atomic-5.0.1.tgz -> npmpkg-write-file-atomic-5.0.1.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-4.1.0.tgz -> npmpkg-signal-exit-4.1.0.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/yaml/-/yaml-1.10.2.tgz -> npmpkg-yaml-1.10.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-20.2.9.tgz -> npmpkg-yargs-parser-20.2.9.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-0.1.0.tgz -> npmpkg-yocto-queue-0.1.0.tgz
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
#KEYWORDS="~amd64 ~arm64" # tauri supports also x86 and arm
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" -gtk3 +html tray wayland +X r3"
REQUIRED_USE="
	gtk3? (
		html
	)
	|| (
		html
		gtk3
	)
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
	html? (
		x11-misc/xdg-utils
	)
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
PATCHES=(
#	"${FILESDIR}/gitlight-0.16.0-login-uri.patch"
)

pkg_setup() {
	npm_pkg_setup
	npm_check_network_sandbox
	if use html && ! egetent group "${PN}" ; then
eerror
eerror "You must add the ${PN} group to the system."
eerror
eerror "  groupadd ${PN}"
eerror
		die
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

get_gitlight_port() {
	echo "${GITLIGHT_PORT:-5173}"
}

src_prepare() {
	default
#	sed -i \
#		-e "s|ssr = true|ssr = false|g" \
#		"./src/routes/+layout.ts" \
#		|| die

	sed -i \
		-e "s|pnpm build|npm run build|g" \
		-e "s|pnpm dev|npm run dev|g" \
		"src-tauri/tauri.conf.json" \
		|| die

	sed -i -e "s|http://localhost:5173|http://localhost:$(get_gitlight_port)|g" \
		"src-tauri/tauri.conf.json" \
		|| die
	sed -i -e "s|5173|$(get_gitlight_port)|g" \
		"vite.config.ts" \
		|| die

#	sed -i -e "s|https://gitlight.app|https://localhost:$(get_gitlight_port)|g" \
#		"src/lib/components/landing/DownloadButton.svelte" \
#		|| die
#	sed -i -e "s|https://gitlight.app|https://localhost:$(get_gitlight_port)|g" \
#		"src-tauri/tauri.conf.json" \
#		|| die
}

src_configure() {
	if [[ ! -e "${GITLIGHT_CREDENTIALS_PATH}" ]] ; then
eerror
eerror "You need to create your own OAuth tokens to use this software."
eerror
eerror "  GitHub:  https://github.com/settings/applications/new"
eerror "  GitLab:  https://gitlab.com/-/profile/applications"
eerror
eerror "For complete details details, see:"
eerror
eerror "  https://github.com/colinlienard/gitlight/blob/main/CONTRIBUTING.md#github-oauth-app"
eerror
eerror
eerror "You must set GITLIGHT_CREDENTIALS_PATH as an environment variable"
eerror "pointing to a single file with the following variables:"
eerror
eerror "Contents of /mnt/encrypted-usb/gitlight-tokens.conf:"
eerror
eerror "  AUTH_GITHUB_ID=\"<GITHUB_ID>\""
eerror "  AUTH_GITHUB_SECRET=\"<GITHUB_SECRET>\""
eerror "  AUTH_GITLAB_ID=\"<GITLAB_ID>\""
eerror "  AUTH_GITLAB_SECRET=\"<GITLAB_SECRET>\""
eerror
eerror "  # Generated from https://generate-secret.vercel.app/32"
eerror "  AUTH_SECRET=\"<paste here>\""
eerror
eerror "  # Required to communicate to vite dev server:"
eerror "  PUBLIC_SITE_URL=\"http://localhost:$(get_gitlight_port)\""
eerror
eerror "  # Keep these variables empty:"
eerror "  TAURI_PRIVATE_KEY=\"\""
eerror "  TAURI_KEY_PASSWORD=\"\""
eerror
eerror "You may use placeholder text like \"skip\" if you do not want to use"
eerror "that service."
eerror
eerror "For the full list of environment variables, see"
eerror
eerror "  https://github.com/colinlienard/gitlight/blob/gitlight-v0.16.0/.env.example"
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
eerror "  GITLIGHT_CREDENTIALS_PATH=\"/mnt/encrypted-usb/gitlight-tokens.conf\""
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
		:; #cargo_src_configure  # for *_npm path
	popd
}

src_compile() {
einfo "Building npm side"
	S="${WORKDIR}/${MY_PN}-v${PV}" \
	npm_src_compile
	grep -e "- error TS" "${T}/build.log" && die "Detected error.  Emerge again."
	if use gtk3 ; then
einfo "Building tauri side"
		enpm run build:tauri --release
	fi
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

gen_wrapper_html() {
	dodir /usr/bin
cat <<EOF > "${ED}/usr/bin/git-light-html"
#!/bin/bash
export PATH="/opt/gitlight/node_modules/.bin:\${PATH}"
mkdir -p "\${HOME}/.cache/git-light"
PID=""
cleanup() {
echo "Called cleanup"
	kill -9 \${PID}
}
trap cleanup SIGINT SIGKILL SIGTERM SIGQUIT SIGHUP

pushd "/opt/gitlight"
	vite preview &
	PID="\$!"
	echo "PID: \${PID}"
	sleep 5
	xdg-open "http://localhost:$(get_gitlight_port)/" &
	wait \$!
popd
cleanup
EOF
}

gen_wrapper_gtk3() {
	dodir /usr/bin
cat <<EOF > "${ED}/usr/bin/git-light-html"
#!/bin/bash
export PATH="/opt/gitlight/node_modules/.bin:\${PATH}"
mkdir -p "\${HOME}/.cache/git-light"
PID=""
cleanup() {
echo "Called cleanup"
	kill -9 \${PID}
}
trap cleanup SIGINT SIGKILL SIGTERM SIGQUIT SIGHUP

pushd "/opt/gitlight"
	vite preview &
	PID="\$!"
	echo "PID: \${PID}"
	sleep 5
# Setting XDG_RUNTIME_DIR fixes:
# Failed to create a temp folder for icon: Os { code: 13, kind: PermissionDenied, message: "Permission denied" }
	mkdir -p "\${HOME}/.cache/git-light"
	XDG_RUNTIME_DIR="\${HOME}/.cache/gitlight" git-light-bin "\$@"
	wait \$!
popd
cleanup
EOF
}

sanitize_permissions() {
	IFS=$'\n'
	local path
	for path in $(find "${ED}") ; do
		[[ -e "${path}" ]] || continue
		[[ -L "${path}" ]] && continue # Avoid realpaths to unsandboxed files.
		chown root:root "${path}" || die
		if file "${path}" | grep -q "directory" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q "ELF .* LSB shared object" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q "ELF .* LSB pie executable" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q "ELF .* LSB executable" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -F -q "Node.js script executable" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q "symbolic link" ; then
			:;
		else
			chmod 0644 "${path}" || die
		fi
	done
	IFS=$' \t\n'
}

src_install() {
	exeinto /usr/bin
	if use html ; then
		gen_wrapper_html
		dosym \
			/usr/bin/git-light-html \
			/usr/bin/git-light
	fi
	if use gtk3 ; then
		newexe \
			src-tauri/target/release/git-light \
			git-light-bin
# It will break when you create a new user in the OS.
ewarn
ewarn "The gtk3/tauri version login is broken."
ewarn
		gen_wrapper_gtk3
		dosym \
			/usr/bin/git-light-gtk3 \
			/usr/bin/git-light
	fi

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

	if use html ; then
		rm -rf "src-tauri/target/release" || true
		insinto "/opt/${PN}"
		doins -r .
		sanitize_permissions
		fowners "root:${PN}" "/opt/${PN}"
		fperms 0775 "/opt/${PN}"
# When it installs, emerge doesn't set the proper folder permissions.
ewarn
ewarn "You need to manually do \`chmod 0775 /opt/${PN}\`"
ewarn
		fperms 0755 /usr/bin/git-light-html
	fi
	if use gtk3 ; then
		fperms 0755 /usr/bin/git-light-gtk3
		fowners root:gitlight /usr/bin/git-light-gtk3
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	if use html ; then
# There is a bug that it needs to write
# /opt/gitlight/vite.config.ts.timestamp-*-*.mjs
ewarn
ewarn "You must add the user to the ${PN} group."
ewarn
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  fail (0.16.0, 20231216)
# npm run build + npm run build:tauri + run git-light (standalone):  fail (login fail)
# npm run build + npm run preview (vite + web browser):  pass
