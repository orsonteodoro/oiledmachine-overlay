# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 22.04

# network-sandbox must be disabled for npm update.

# NPM_AUDIT_FIX=0

# To update npm side use:
# PATH="/usr/local/oiledmachine-overlay/scripts:${PATH}"
# NPM_UPDATER_PROJECT_ROOT="coolercontrol-1.3.0/coolercontrol-ui" NPM_UPDATER_VERSIONS="1.3.0" npm_updater_update_locks.sh

# To update cargo size use:
# ./convert-cargo-lock.sh 1.3.0 1.3.0

CRATES="
actix-codec-0.5.2
actix-cors-0.7.0
actix-http-3.8.0
actix-macros-0.2.4
actix-multipart-0.6.2
actix-multipart-derive-0.6.1
actix-router-0.5.3
actix-rt-2.10.0
actix-server-2.4.0
actix-service-2.0.2
actix-session-0.9.0
actix-utils-3.0.1
actix-web-4.8.0
actix-web-codegen-4.3.0
actix-web-static-files-4.0.1
addr2line-0.22.0
adler-1.0.2
aead-0.5.2
aes-0.8.4
aes-gcm-0.10.3
ahash-0.8.11
aho-corasick-1.1.3
alloc-no-stdlib-2.0.4
alloc-stdlib-0.2.2
android-tzdata-0.1.1
android_system_properties-0.1.5
anstream-0.6.14
anstyle-1.0.7
anstyle-parse-0.2.4
anstyle-query-1.1.0
anstyle-wincon-3.0.3
anyhow-1.0.86
arrayref-0.3.7
arrayvec-0.7.4
async-broadcast-0.7.1
async-channel-2.3.1
async-io-2.3.3
async-lock-3.4.0
async-process-2.2.3
async-recursion-1.1.1
async-signal-0.2.8
async-task-4.7.1
async-trait-0.1.80
atomic-0.6.0
atomic-waker-1.1.2
autocfg-1.3.0
backtrace-0.3.73
base64-0.13.1
base64-0.20.0
base64-0.22.1
bitflags-1.3.2
bitflags-2.5.0
block-buffer-0.10.4
blocking-1.6.1
brotli-6.0.0
brotli-decompressor-4.0.1
bumpalo-3.16.0
bytemuck-1.16.1
bytemuck_derive-1.7.0
byteorder-1.5.0
byteorder-lite-0.1.0
bytes-1.6.0
bytestring-1.3.1
cc-1.0.99
cfg-if-1.0.0
cfg_aliases-0.1.1
cfg_aliases-0.2.1
chrono-0.4.38
cipher-0.4.4
clap-4.5.7
clap_builder-4.5.7
clap_derive-4.5.5
clap_lex-0.7.1
clokwerk-0.4.0
color_quant-1.1.0
colorchoice-1.0.1
concurrent-queue-2.5.0
const_format-0.2.32
const_format_proc_macros-0.2.32
convert_case-0.4.0
cookie-0.16.2
core-foundation-sys-0.8.6
cpufeatures-0.2.12
crc32fast-1.4.2
crossbeam-channel-0.5.13
crossbeam-deque-0.8.5
crossbeam-epoch-0.9.18
crossbeam-utils-0.8.20
crypto-common-0.1.6
ctr-0.9.2
darling-0.20.9
darling_core-0.20.9
darling_macro-0.20.9
deranged-0.3.11
derive_more-0.99.18
digest-0.10.7
either-1.12.0
encoding_rs-0.8.34
endi-1.1.0
enumflags2-0.7.10
enumflags2_derive-0.7.10
env_filter-0.1.0
env_logger-0.11.3
equivalent-1.0.1
errno-0.3.9
event-listener-5.3.1
event-listener-strategy-0.5.2
fastrand-2.1.0
fdeflate-0.3.4
flate2-1.0.30
fnv-1.0.7
fontdue-0.7.3
form_urlencoded-1.2.1
futures-0.3.30
futures-channel-0.3.30
futures-core-0.3.30
futures-executor-0.3.30
futures-io-0.3.30
futures-lite-2.3.0
futures-macro-0.3.30
futures-sink-0.3.30
futures-task-0.3.30
futures-util-0.3.30
generic-array-0.14.7
getrandom-0.2.15
ghash-0.5.1
gif-0.13.1
gif-dispose-5.0.0
gifski-1.32.0
gimli-0.29.0
glob-0.3.1
h2-0.3.26
hashbrown-0.13.2
hashbrown-0.14.5
heck-0.5.0
hermit-abi-0.3.9
hermit-abi-0.4.0
hex-0.4.3
hkdf-0.12.4
hmac-0.12.1
http-0.2.12
http-1.1.0
http-auth-basic-0.3.3
http-body-1.0.0
http-body-util-0.1.2
httparse-1.9.4
httpdate-1.0.3
humantime-2.1.0
hyper-1.3.1
hyper-util-0.1.5
iana-time-zone-0.1.60
iana-time-zone-haiku-0.1.2
ident_case-1.0.1
idna-0.5.0
image-0.25.1
image-webp-0.1.2
imagequant-4.3.1
imgref-1.10.1
indexmap-2.2.6
inout-0.1.3
is_terminal_polyfill-1.70.0
itoa-1.0.11
jobserver-0.1.31
jpeg-decoder-0.3.1
js-sys-0.3.69
language-tags-0.3.2
lazy_static-1.5.0
libc-0.2.155
linux-raw-sys-0.4.14
local-channel-0.1.5
local-waker-0.1.4
lock_api-0.4.12
log-0.4.21
loop9-0.1.5
mach2-0.4.2
memchr-2.7.4
memoffset-0.9.1
miette-7.2.0
miette-derive-7.2.0
mime-0.3.17
mime_guess-2.0.4
miniz_oxide-0.7.4
mio-0.8.11
nix-0.24.3
nix-0.28.0
nix-0.29.0
ntapi-0.4.1
nu-glob-0.93.0
num-conv-0.1.0
num-traits-0.2.19
num_cpus-1.16.0
object-0.36.0
once_cell-1.19.0
opaque-debug-0.3.1
ordered-channel-1.1.0
ordered-stream-0.2.0
parking-2.2.0
parking_lot-0.12.3
parking_lot_core-0.9.10
parse-size-1.0.0
paste-1.0.15
path-slash-0.1.5
percent-encoding-2.3.1
pin-project-1.1.5
pin-project-internal-1.1.5
pin-project-lite-0.2.14
pin-utils-0.1.0
piper-0.2.3
pkg-config-0.3.30
png-0.17.13
polling-3.7.2
polyval-0.6.2
powerfmt-0.2.0
ppv-lite86-0.2.17
proc-macro-crate-3.1.0
proc-macro2-1.0.86
psutil-3.3.0
quick-error-2.0.1
quote-1.0.36
rand-0.8.5
rand_chacha-0.3.1
rand_core-0.6.4
rayon-1.10.0
rayon-core-1.12.1
redox_syscall-0.5.2
regex-1.10.5
regex-automata-0.4.7
regex-lite-0.1.6
regex-syntax-0.8.4
resize-0.8.4
rgb-0.8.37
ril-0.10.1
rustc-demangle-0.1.24
rustc_version-0.4.0
rustix-0.38.34
rustversion-1.0.17
ryu-1.0.18
scopeguard-1.2.0
semver-1.0.23
serde-1.0.203
serde_derive-1.0.203
serde_json-1.0.117
serde_plain-1.0.2
serde_repr-0.1.19
serde_urlencoded-0.7.1
sha1-0.10.6
sha2-0.10.8
signal-hook-0.3.17
signal-hook-registry-1.4.2
simd-adler32-0.3.7
slab-0.4.9
smallvec-1.13.2
socket2-0.5.7
static-files-0.2.3
static_assertions-1.1.0
strict-num-0.1.1
strsim-0.11.1
strum-0.26.2
strum_macros-0.26.4
subtle-2.6.0
syn-2.0.67
sysinfo-0.30.12
systemd-journal-logger-2.1.1
tempfile-3.10.1
test-context-0.3.0
test-context-macros-0.3.0
thiserror-1.0.61
thiserror-impl-1.0.61
thread_local-1.1.8
tiff-0.9.1
time-0.3.36
time-core-0.1.2
time-macros-0.2.18
tiny-skia-0.11.4
tiny-skia-path-0.11.4
tinyvec-1.6.0
tinyvec_macros-0.1.1
tokio-1.38.0
tokio-graceful-shutdown-0.15.0
tokio-macros-2.3.0
tokio-util-0.7.11
toml_datetime-0.6.6
toml_edit-0.21.1
toml_edit-0.22.14
tower-0.4.13
tower-layer-0.3.2
tower-service-0.3.2
tracing-0.1.40
tracing-attributes-0.1.27
tracing-core-0.1.32
try-lock-0.2.5
ttf-parser-0.15.2
typenum-1.17.0
uds_windows-1.1.0
unicase-2.7.0
unicode-bidi-0.3.15
unicode-ident-1.0.12
unicode-normalization-0.1.23
unicode-width-0.1.13
unicode-xid-0.2.4
universal-hash-0.5.1
url-2.5.2
utf8parse-0.2.2
uuid-1.8.0
value-bag-1.9.0
version_check-0.9.4
want-0.3.1
wasi-0.11.0+wasi-snapshot-preview1
wasm-bindgen-0.2.92
wasm-bindgen-backend-0.2.92
wasm-bindgen-macro-0.2.92
wasm-bindgen-macro-support-0.2.92
wasm-bindgen-shared-0.2.92
weezl-0.1.8
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.52.0
windows-core-0.52.0
windows-sys-0.48.0
windows-sys-0.52.0
windows-targets-0.48.5
windows-targets-0.52.5
windows_aarch64_gnullvm-0.48.5
windows_aarch64_gnullvm-0.52.5
windows_aarch64_msvc-0.48.5
windows_aarch64_msvc-0.52.5
windows_i686_gnu-0.48.5
windows_i686_gnu-0.52.5
windows_i686_gnullvm-0.52.5
windows_i686_msvc-0.48.5
windows_i686_msvc-0.52.5
windows_x86_64_gnu-0.48.5
windows_x86_64_gnu-0.52.5
windows_x86_64_gnullvm-0.48.5
windows_x86_64_gnullvm-0.52.5
windows_x86_64_msvc-0.48.5
windows_x86_64_msvc-0.52.5
winnow-0.5.40
winnow-0.6.13
xdg-home-1.2.0
yata-0.7.0
zbus-4.3.0
zbus_macros-4.3.0
zbus_names-3.0.0
zerocopy-0.7.34
zerocopy-derive-0.7.34
zstd-0.13.1
zstd-safe-7.1.0
zstd-sys-2.0.11+zstd.1.5.6
zune-core-0.4.12
zune-jpeg-0.4.11
zvariant-4.1.1
zvariant_derive-4.1.1
zvariant_utils-2.0.0
"

# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@babel/parser/-/parser-7.24.7.tgz -> npmpkg-@babel-parser-7.24.7.tgz
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
https://registry.npmjs.org/@floating-ui/core/-/core-1.6.2.tgz -> npmpkg-@floating-ui-core-1.6.2.tgz
https://registry.npmjs.org/@floating-ui/dom/-/dom-1.6.5.tgz -> npmpkg-@floating-ui-dom-1.6.5.tgz
https://registry.npmjs.org/@floating-ui/utils/-/utils-0.2.2.tgz -> npmpkg-@floating-ui-utils-0.2.2.tgz
https://registry.npmjs.org/@isaacs/cliui/-/cliui-8.0.2.tgz -> npmpkg-@isaacs-cliui-8.0.2.tgz
https://registry.npmjs.org/@jamescoyle/vue-icon/-/vue-icon-0.1.2.tgz -> npmpkg-@jamescoyle-vue-icon-0.1.2.tgz
https://registry.npmjs.org/@jest/schemas/-/schemas-29.6.3.tgz -> npmpkg-@jest-schemas-29.6.3.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.15.tgz -> npmpkg-@jridgewell-sourcemap-codec-1.4.15.tgz
https://registry.npmjs.org/@mdi/js/-/js-7.4.47.tgz -> npmpkg-@mdi-js-7.4.47.tgz
https://registry.npmjs.org/@one-ini/wasm/-/wasm-0.1.1.tgz -> npmpkg-@one-ini-wasm-0.1.1.tgz
https://registry.npmjs.org/@pkgjs/parseargs/-/parseargs-0.11.0.tgz -> npmpkg-@pkgjs-parseargs-0.11.0.tgz
https://registry.npmjs.org/@rollup/rollup-android-arm-eabi/-/rollup-android-arm-eabi-4.18.0.tgz -> npmpkg-@rollup-rollup-android-arm-eabi-4.18.0.tgz
https://registry.npmjs.org/@rollup/rollup-android-arm64/-/rollup-android-arm64-4.18.0.tgz -> npmpkg-@rollup-rollup-android-arm64-4.18.0.tgz
https://registry.npmjs.org/@rollup/rollup-darwin-arm64/-/rollup-darwin-arm64-4.18.0.tgz -> npmpkg-@rollup-rollup-darwin-arm64-4.18.0.tgz
https://registry.npmjs.org/@rollup/rollup-darwin-x64/-/rollup-darwin-x64-4.18.0.tgz -> npmpkg-@rollup-rollup-darwin-x64-4.18.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-arm-gnueabihf/-/rollup-linux-arm-gnueabihf-4.18.0.tgz -> npmpkg-@rollup-rollup-linux-arm-gnueabihf-4.18.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-arm-musleabihf/-/rollup-linux-arm-musleabihf-4.18.0.tgz -> npmpkg-@rollup-rollup-linux-arm-musleabihf-4.18.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-arm64-gnu/-/rollup-linux-arm64-gnu-4.18.0.tgz -> npmpkg-@rollup-rollup-linux-arm64-gnu-4.18.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-arm64-musl/-/rollup-linux-arm64-musl-4.18.0.tgz -> npmpkg-@rollup-rollup-linux-arm64-musl-4.18.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-powerpc64le-gnu/-/rollup-linux-powerpc64le-gnu-4.18.0.tgz -> npmpkg-@rollup-rollup-linux-powerpc64le-gnu-4.18.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-riscv64-gnu/-/rollup-linux-riscv64-gnu-4.18.0.tgz -> npmpkg-@rollup-rollup-linux-riscv64-gnu-4.18.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-s390x-gnu/-/rollup-linux-s390x-gnu-4.18.0.tgz -> npmpkg-@rollup-rollup-linux-s390x-gnu-4.18.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-x64-gnu/-/rollup-linux-x64-gnu-4.18.0.tgz -> npmpkg-@rollup-rollup-linux-x64-gnu-4.18.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-x64-musl/-/rollup-linux-x64-musl-4.18.0.tgz -> npmpkg-@rollup-rollup-linux-x64-musl-4.18.0.tgz
https://registry.npmjs.org/@rollup/rollup-win32-arm64-msvc/-/rollup-win32-arm64-msvc-4.18.0.tgz -> npmpkg-@rollup-rollup-win32-arm64-msvc-4.18.0.tgz
https://registry.npmjs.org/@rollup/rollup-win32-ia32-msvc/-/rollup-win32-ia32-msvc-4.18.0.tgz -> npmpkg-@rollup-rollup-win32-ia32-msvc-4.18.0.tgz
https://registry.npmjs.org/@rollup/rollup-win32-x64-msvc/-/rollup-win32-x64-msvc-4.18.0.tgz -> npmpkg-@rollup-rollup-win32-x64-msvc-4.18.0.tgz
https://registry.npmjs.org/@sinclair/typebox/-/typebox-0.27.8.tgz -> npmpkg-@sinclair-typebox-0.27.8.tgz
https://registry.npmjs.org/@sxzz/popperjs-es/-/popperjs-es-2.11.7.tgz -> npmpkg-@sxzz-popperjs-es-2.11.7.tgz
https://registry.npmjs.org/@tauri-apps/api/-/api-1.5.6.tgz -> npmpkg-@tauri-apps-api-1.5.6.tgz
https://registry.npmjs.org/@trysound/sax/-/sax-0.2.0.tgz -> npmpkg-@trysound-sax-0.2.0.tgz
https://registry.npmjs.org/@tsconfig/node18/-/node18-18.2.4.tgz -> npmpkg-@tsconfig-node18-18.2.4.tgz
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
https://registry.npmjs.org/@types/d3-scale-chromatic/-/d3-scale-chromatic-3.0.3.tgz -> npmpkg-@types-d3-scale-chromatic-3.0.3.tgz
https://registry.npmjs.org/@types/d3-scale/-/d3-scale-4.0.8.tgz -> npmpkg-@types-d3-scale-4.0.8.tgz
https://registry.npmjs.org/@types/d3-selection/-/d3-selection-3.0.10.tgz -> npmpkg-@types-d3-selection-3.0.10.tgz
https://registry.npmjs.org/@types/d3-shape/-/d3-shape-3.1.6.tgz -> npmpkg-@types-d3-shape-3.1.6.tgz
https://registry.npmjs.org/@types/d3-time-format/-/d3-time-format-4.0.3.tgz -> npmpkg-@types-d3-time-format-4.0.3.tgz
https://registry.npmjs.org/@types/d3-time/-/d3-time-3.0.3.tgz -> npmpkg-@types-d3-time-3.0.3.tgz
https://registry.npmjs.org/@types/d3-timer/-/d3-timer-3.0.2.tgz -> npmpkg-@types-d3-timer-3.0.2.tgz
https://registry.npmjs.org/@types/d3-transition/-/d3-transition-3.0.8.tgz -> npmpkg-@types-d3-transition-3.0.8.tgz
https://registry.npmjs.org/@types/d3-zoom/-/d3-zoom-3.0.8.tgz -> npmpkg-@types-d3-zoom-3.0.8.tgz
https://registry.npmjs.org/@types/d3/-/d3-7.4.3.tgz -> npmpkg-@types-d3-7.4.3.tgz
https://registry.npmjs.org/@types/estree/-/estree-1.0.5.tgz -> npmpkg-@types-estree-1.0.5.tgz
https://registry.npmjs.org/@types/geojson/-/geojson-7946.0.14.tgz -> npmpkg-@types-geojson-7946.0.14.tgz
https://registry.npmjs.org/@types/jsdom/-/jsdom-21.1.7.tgz -> npmpkg-@types-jsdom-21.1.7.tgz
https://registry.npmjs.org/@types/lodash-es/-/lodash-es-4.17.12.tgz -> npmpkg-@types-lodash-es-4.17.12.tgz
https://registry.npmjs.org/@types/lodash/-/lodash-4.17.5.tgz -> npmpkg-@types-lodash-4.17.5.tgz
https://registry.npmjs.org/@types/node/-/node-20.14.7.tgz -> npmpkg-@types-node-20.14.7.tgz
https://registry.npmjs.org/@types/tough-cookie/-/tough-cookie-4.0.5.tgz -> npmpkg-@types-tough-cookie-4.0.5.tgz
https://registry.npmjs.org/@types/uuid/-/uuid-9.0.8.tgz -> npmpkg-@types-uuid-9.0.8.tgz
https://registry.npmjs.org/@types/web-bluetooth/-/web-bluetooth-0.0.16.tgz -> npmpkg-@types-web-bluetooth-0.0.16.tgz
https://registry.npmjs.org/@vitejs/plugin-vue/-/plugin-vue-5.0.5.tgz -> npmpkg-@vitejs-plugin-vue-5.0.5.tgz
https://registry.npmjs.org/@vitest/expect/-/expect-1.6.0.tgz -> npmpkg-@vitest-expect-1.6.0.tgz
https://registry.npmjs.org/@vitest/runner/-/runner-1.6.0.tgz -> npmpkg-@vitest-runner-1.6.0.tgz
https://registry.npmjs.org/@vitest/snapshot/-/snapshot-1.6.0.tgz -> npmpkg-@vitest-snapshot-1.6.0.tgz
https://registry.npmjs.org/@vitest/spy/-/spy-1.6.0.tgz -> npmpkg-@vitest-spy-1.6.0.tgz
https://registry.npmjs.org/@vitest/utils/-/utils-1.6.0.tgz -> npmpkg-@vitest-utils-1.6.0.tgz
https://registry.npmjs.org/@volar/language-core/-/language-core-2.3.1.tgz -> npmpkg-@volar-language-core-2.3.1.tgz
https://registry.npmjs.org/@volar/source-map/-/source-map-2.3.1.tgz -> npmpkg-@volar-source-map-2.3.1.tgz
https://registry.npmjs.org/@volar/typescript/-/typescript-2.3.1.tgz -> npmpkg-@volar-typescript-2.3.1.tgz
https://registry.npmjs.org/@vue/compiler-core/-/compiler-core-3.4.29.tgz -> npmpkg-@vue-compiler-core-3.4.29.tgz
https://registry.npmjs.org/@vue/compiler-dom/-/compiler-dom-3.4.29.tgz -> npmpkg-@vue-compiler-dom-3.4.29.tgz
https://registry.npmjs.org/@vue/compiler-sfc/-/compiler-sfc-3.4.29.tgz -> npmpkg-@vue-compiler-sfc-3.4.29.tgz
https://registry.npmjs.org/@vue/compiler-ssr/-/compiler-ssr-3.4.29.tgz -> npmpkg-@vue-compiler-ssr-3.4.29.tgz
https://registry.npmjs.org/@vue/devtools-api/-/devtools-api-6.6.3.tgz -> npmpkg-@vue-devtools-api-6.6.3.tgz
https://registry.npmjs.org/@vue/language-core/-/language-core-2.0.21.tgz -> npmpkg-@vue-language-core-2.0.21.tgz
https://registry.npmjs.org/@vue/reactivity/-/reactivity-3.4.29.tgz -> npmpkg-@vue-reactivity-3.4.29.tgz
https://registry.npmjs.org/@vue/runtime-core/-/runtime-core-3.4.29.tgz -> npmpkg-@vue-runtime-core-3.4.29.tgz
https://registry.npmjs.org/@vue/runtime-dom/-/runtime-dom-3.4.29.tgz -> npmpkg-@vue-runtime-dom-3.4.29.tgz
https://registry.npmjs.org/@vue/server-renderer/-/server-renderer-3.4.29.tgz -> npmpkg-@vue-server-renderer-3.4.29.tgz
https://registry.npmjs.org/@vue/shared/-/shared-3.4.29.tgz -> npmpkg-@vue-shared-3.4.29.tgz
https://registry.npmjs.org/@vue/test-utils/-/test-utils-2.4.6.tgz -> npmpkg-@vue-test-utils-2.4.6.tgz
https://registry.npmjs.org/@vue/tsconfig/-/tsconfig-0.5.1.tgz -> npmpkg-@vue-tsconfig-0.5.1.tgz
https://registry.npmjs.org/@vueuse/core/-/core-9.13.0.tgz -> npmpkg-@vueuse-core-9.13.0.tgz
https://registry.npmjs.org/@vueuse/metadata/-/metadata-9.13.0.tgz -> npmpkg-@vueuse-metadata-9.13.0.tgz
https://registry.npmjs.org/@vueuse/shared/-/shared-9.13.0.tgz -> npmpkg-@vueuse-shared-9.13.0.tgz
https://registry.npmjs.org/abbrev/-/abbrev-2.0.0.tgz -> npmpkg-abbrev-2.0.0.tgz
https://registry.npmjs.org/acorn-walk/-/acorn-walk-8.3.3.tgz -> npmpkg-acorn-walk-8.3.3.tgz
https://registry.npmjs.org/acorn/-/acorn-8.12.0.tgz -> npmpkg-acorn-8.12.0.tgz
https://registry.npmjs.org/agent-base/-/agent-base-7.1.1.tgz -> npmpkg-agent-base-7.1.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-6.0.1.tgz -> npmpkg-ansi-regex-6.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-6.2.1.tgz -> npmpkg-ansi-styles-6.2.1.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz -> npmpkg-anymatch-3.1.3.tgz
https://registry.npmjs.org/array-buffer-byte-length/-/array-buffer-byte-length-1.0.1.tgz -> npmpkg-array-buffer-byte-length-1.0.1.tgz
https://registry.npmjs.org/arraybuffer.prototype.slice/-/arraybuffer.prototype.slice-1.0.3.tgz -> npmpkg-arraybuffer.prototype.slice-1.0.3.tgz
https://registry.npmjs.org/assertion-error/-/assertion-error-1.1.0.tgz -> npmpkg-assertion-error-1.1.0.tgz
https://registry.npmjs.org/async-validator/-/async-validator-4.2.5.tgz -> npmpkg-async-validator-4.2.5.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz -> npmpkg-asynckit-0.4.0.tgz
https://registry.npmjs.org/available-typed-arrays/-/available-typed-arrays-1.0.7.tgz -> npmpkg-available-typed-arrays-1.0.7.tgz
https://registry.npmjs.org/axios-retry/-/axios-retry-4.4.1.tgz -> npmpkg-axios-retry-4.4.1.tgz
https://registry.npmjs.org/axios/-/axios-1.7.2.tgz -> npmpkg-axios-1.7.2.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz -> npmpkg-balanced-match-1.0.2.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.3.0.tgz -> npmpkg-binary-extensions-2.3.0.tgz
https://registry.npmjs.org/boolbase/-/boolbase-1.0.0.tgz -> npmpkg-boolbase-1.0.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/braces/-/braces-3.0.3.tgz -> npmpkg-braces-3.0.3.tgz
https://registry.npmjs.org/cac/-/cac-6.7.14.tgz -> npmpkg-cac-6.7.14.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.7.tgz -> npmpkg-call-bind-1.0.7.tgz
https://registry.npmjs.org/chai/-/chai-4.4.1.tgz -> npmpkg-chai-4.4.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/check-error/-/check-error-1.0.3.tgz -> npmpkg-check-error-1.0.3.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.6.0.tgz -> npmpkg-chokidar-3.6.0.tgz
https://registry.npmjs.org/class-transformer/-/class-transformer-0.5.1.tgz -> npmpkg-class-transformer-0.5.1.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz -> npmpkg-combined-stream-1.0.8.tgz
https://registry.npmjs.org/commander/-/commander-10.0.1.tgz -> npmpkg-commander-10.0.1.tgz
https://registry.npmjs.org/commander/-/commander-7.2.0.tgz -> npmpkg-commander-7.2.0.tgz
https://registry.npmjs.org/computeds/-/computeds-0.0.1.tgz -> npmpkg-computeds-0.0.1.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/confbox/-/confbox-0.1.7.tgz -> npmpkg-confbox-0.1.7.tgz
https://registry.npmjs.org/config-chain/-/config-chain-1.1.13.tgz -> npmpkg-config-chain-1.1.13.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-6.0.5.tgz -> npmpkg-cross-spawn-6.0.5.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/css-select/-/css-select-5.1.0.tgz -> npmpkg-css-select-5.1.0.tgz
https://registry.npmjs.org/css-tree/-/css-tree-2.2.1.tgz -> npmpkg-css-tree-2.2.1.tgz
https://registry.npmjs.org/css-tree/-/css-tree-2.3.1.tgz -> npmpkg-css-tree-2.3.1.tgz
https://registry.npmjs.org/css-what/-/css-what-6.1.0.tgz -> npmpkg-css-what-6.1.0.tgz
https://registry.npmjs.org/csso/-/csso-5.0.5.tgz -> npmpkg-csso-5.0.5.tgz
https://registry.npmjs.org/cssstyle/-/cssstyle-4.0.1.tgz -> npmpkg-cssstyle-4.0.1.tgz
https://registry.npmjs.org/csstype/-/csstype-3.1.3.tgz -> npmpkg-csstype-3.1.3.tgz
https://registry.npmjs.org/d3-array/-/d3-array-3.2.4.tgz -> npmpkg-d3-array-3.2.4.tgz
https://registry.npmjs.org/d3-color/-/d3-color-3.1.0.tgz -> npmpkg-d3-color-3.1.0.tgz
https://registry.npmjs.org/d3-format/-/d3-format-3.1.0.tgz -> npmpkg-d3-format-3.1.0.tgz
https://registry.npmjs.org/d3-interpolate/-/d3-interpolate-3.0.1.tgz -> npmpkg-d3-interpolate-3.0.1.tgz
https://registry.npmjs.org/d3-scale-chromatic/-/d3-scale-chromatic-3.1.0.tgz -> npmpkg-d3-scale-chromatic-3.1.0.tgz
https://registry.npmjs.org/d3-scale/-/d3-scale-4.0.2.tgz -> npmpkg-d3-scale-4.0.2.tgz
https://registry.npmjs.org/d3-time-format/-/d3-time-format-4.1.0.tgz -> npmpkg-d3-time-format-4.1.0.tgz
https://registry.npmjs.org/d3-time/-/d3-time-3.1.0.tgz -> npmpkg-d3-time-3.1.0.tgz
https://registry.npmjs.org/data-urls/-/data-urls-5.0.0.tgz -> npmpkg-data-urls-5.0.0.tgz
https://registry.npmjs.org/data-view-buffer/-/data-view-buffer-1.0.1.tgz -> npmpkg-data-view-buffer-1.0.1.tgz
https://registry.npmjs.org/data-view-byte-length/-/data-view-byte-length-1.0.1.tgz -> npmpkg-data-view-byte-length-1.0.1.tgz
https://registry.npmjs.org/data-view-byte-offset/-/data-view-byte-offset-1.0.0.tgz -> npmpkg-data-view-byte-offset-1.0.0.tgz
https://registry.npmjs.org/dayjs/-/dayjs-1.11.11.tgz -> npmpkg-dayjs-1.11.11.tgz
https://registry.npmjs.org/de-indent/-/de-indent-1.0.2.tgz -> npmpkg-de-indent-1.0.2.tgz
https://registry.npmjs.org/debug/-/debug-4.3.5.tgz -> npmpkg-debug-4.3.5.tgz
https://registry.npmjs.org/decimal.js/-/decimal.js-10.4.3.tgz -> npmpkg-decimal.js-10.4.3.tgz
https://registry.npmjs.org/deep-eql/-/deep-eql-4.1.4.tgz -> npmpkg-deep-eql-4.1.4.tgz
https://registry.npmjs.org/define-data-property/-/define-data-property-1.1.4.tgz -> npmpkg-define-data-property-1.1.4.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.2.1.tgz -> npmpkg-define-properties-1.2.1.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz -> npmpkg-delayed-stream-1.0.0.tgz
https://registry.npmjs.org/diff-sequences/-/diff-sequences-29.6.3.tgz -> npmpkg-diff-sequences-29.6.3.tgz
https://registry.npmjs.org/dom-serializer/-/dom-serializer-2.0.0.tgz -> npmpkg-dom-serializer-2.0.0.tgz
https://registry.npmjs.org/domelementtype/-/domelementtype-2.3.0.tgz -> npmpkg-domelementtype-2.3.0.tgz
https://registry.npmjs.org/domhandler/-/domhandler-5.0.3.tgz -> npmpkg-domhandler-5.0.3.tgz
https://registry.npmjs.org/domutils/-/domutils-3.1.0.tgz -> npmpkg-domutils-3.1.0.tgz
https://registry.npmjs.org/eastasianwidth/-/eastasianwidth-0.2.0.tgz -> npmpkg-eastasianwidth-0.2.0.tgz
https://registry.npmjs.org/echarts/-/echarts-5.5.0.tgz -> npmpkg-echarts-5.5.0.tgz
https://registry.npmjs.org/editorconfig/-/editorconfig-1.0.4.tgz -> npmpkg-editorconfig-1.0.4.tgz
https://registry.npmjs.org/element-plus/-/element-plus-2.7.6.tgz -> npmpkg-element-plus-2.7.6.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
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
https://registry.npmjs.org/estree-walker/-/estree-walker-2.0.2.tgz -> npmpkg-estree-walker-2.0.2.tgz
https://registry.npmjs.org/estree-walker/-/estree-walker-3.0.3.tgz -> npmpkg-estree-walker-3.0.3.tgz
https://registry.npmjs.org/execa/-/execa-8.0.1.tgz -> npmpkg-execa-8.0.1.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz -> npmpkg-fill-range-7.1.1.tgz
https://registry.npmjs.org/follow-redirects/-/follow-redirects-1.15.6.tgz -> npmpkg-follow-redirects-1.15.6.tgz
https://registry.npmjs.org/for-each/-/for-each-0.3.3.tgz -> npmpkg-for-each-0.3.3.tgz
https://registry.npmjs.org/foreground-child/-/foreground-child-3.2.1.tgz -> npmpkg-foreground-child-3.2.1.tgz
https://registry.npmjs.org/form-data/-/form-data-4.0.0.tgz -> npmpkg-form-data-4.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz -> npmpkg-function-bind-1.1.2.tgz
https://registry.npmjs.org/function.prototype.name/-/function.prototype.name-1.1.6.tgz -> npmpkg-function.prototype.name-1.1.6.tgz
https://registry.npmjs.org/functions-have-names/-/functions-have-names-1.2.3.tgz -> npmpkg-functions-have-names-1.2.3.tgz
https://registry.npmjs.org/get-func-name/-/get-func-name-2.0.2.tgz -> npmpkg-get-func-name-2.0.2.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.4.tgz -> npmpkg-get-intrinsic-1.2.4.tgz
https://registry.npmjs.org/get-stream/-/get-stream-8.0.1.tgz -> npmpkg-get-stream-8.0.1.tgz
https://registry.npmjs.org/get-symbol-description/-/get-symbol-description-1.0.2.tgz -> npmpkg-get-symbol-description-1.0.2.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/glob/-/glob-10.4.2.tgz -> npmpkg-glob-10.4.2.tgz
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
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-7.0.4.tgz -> npmpkg-https-proxy-agent-7.0.4.tgz
https://registry.npmjs.org/human-signals/-/human-signals-5.0.0.tgz -> npmpkg-human-signals-5.0.0.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz -> npmpkg-iconv-lite-0.6.3.tgz
https://registry.npmjs.org/immutable/-/immutable-4.3.6.tgz -> npmpkg-immutable-4.3.6.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/internal-slot/-/internal-slot-1.0.7.tgz -> npmpkg-internal-slot-1.0.7.tgz
https://registry.npmjs.org/internmap/-/internmap-2.0.3.tgz -> npmpkg-internmap-2.0.3.tgz
https://registry.npmjs.org/is-array-buffer/-/is-array-buffer-3.0.4.tgz -> npmpkg-is-array-buffer-3.0.4.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz -> npmpkg-is-arrayish-0.2.1.tgz
https://registry.npmjs.org/is-bigint/-/is-bigint-1.0.4.tgz -> npmpkg-is-bigint-1.0.4.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz -> npmpkg-is-binary-path-2.1.0.tgz
https://registry.npmjs.org/is-boolean-object/-/is-boolean-object-1.1.2.tgz -> npmpkg-is-boolean-object-1.1.2.tgz
https://registry.npmjs.org/is-callable/-/is-callable-1.2.7.tgz -> npmpkg-is-callable-1.2.7.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.14.0.tgz -> npmpkg-is-core-module-2.14.0.tgz
https://registry.npmjs.org/is-data-view/-/is-data-view-1.0.1.tgz -> npmpkg-is-data-view-1.0.1.tgz
https://registry.npmjs.org/is-date-object/-/is-date-object-1.0.5.tgz -> npmpkg-is-date-object-1.0.5.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/is-negative-zero/-/is-negative-zero-2.0.3.tgz -> npmpkg-is-negative-zero-2.0.3.tgz
https://registry.npmjs.org/is-number-object/-/is-number-object-1.0.7.tgz -> npmpkg-is-number-object-1.0.7.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/is-potential-custom-element-name/-/is-potential-custom-element-name-1.0.1.tgz -> npmpkg-is-potential-custom-element-name-1.0.1.tgz
https://registry.npmjs.org/is-regex/-/is-regex-1.1.4.tgz -> npmpkg-is-regex-1.1.4.tgz
https://registry.npmjs.org/is-retry-allowed/-/is-retry-allowed-2.2.0.tgz -> npmpkg-is-retry-allowed-2.2.0.tgz
https://registry.npmjs.org/is-shared-array-buffer/-/is-shared-array-buffer-1.0.3.tgz -> npmpkg-is-shared-array-buffer-1.0.3.tgz
https://registry.npmjs.org/is-stream/-/is-stream-3.0.0.tgz -> npmpkg-is-stream-3.0.0.tgz
https://registry.npmjs.org/is-string/-/is-string-1.0.7.tgz -> npmpkg-is-string-1.0.7.tgz
https://registry.npmjs.org/is-symbol/-/is-symbol-1.0.4.tgz -> npmpkg-is-symbol-1.0.4.tgz
https://registry.npmjs.org/is-typed-array/-/is-typed-array-1.1.13.tgz -> npmpkg-is-typed-array-1.1.13.tgz
https://registry.npmjs.org/is-weakref/-/is-weakref-1.0.2.tgz -> npmpkg-is-weakref-1.0.2.tgz
https://registry.npmjs.org/isarray/-/isarray-2.0.5.tgz -> npmpkg-isarray-2.0.5.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/jackspeak/-/jackspeak-3.4.0.tgz -> npmpkg-jackspeak-3.4.0.tgz
https://registry.npmjs.org/js-beautify/-/js-beautify-1.15.1.tgz -> npmpkg-js-beautify-1.15.1.tgz
https://registry.npmjs.org/js-cookie/-/js-cookie-3.0.5.tgz -> npmpkg-js-cookie-3.0.5.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-9.0.0.tgz -> npmpkg-js-tokens-9.0.0.tgz
https://registry.npmjs.org/jsdom/-/jsdom-24.1.0.tgz -> npmpkg-jsdom-24.1.0.tgz
https://registry.npmjs.org/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz -> npmpkg-json-parse-better-errors-1.0.2.tgz
https://registry.npmjs.org/load-json-file/-/load-json-file-4.0.0.tgz -> npmpkg-load-json-file-4.0.0.tgz
https://registry.npmjs.org/local-pkg/-/local-pkg-0.5.0.tgz -> npmpkg-local-pkg-0.5.0.tgz
https://registry.npmjs.org/lodash-es/-/lodash-es-4.17.21.tgz -> npmpkg-lodash-es-4.17.21.tgz
https://registry.npmjs.org/lodash-unified/-/lodash-unified-1.0.3.tgz -> npmpkg-lodash-unified-1.0.3.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/loupe/-/loupe-2.3.7.tgz -> npmpkg-loupe-2.3.7.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-10.2.2.tgz -> npmpkg-lru-cache-10.2.2.tgz
https://registry.npmjs.org/magic-string/-/magic-string-0.30.10.tgz -> npmpkg-magic-string-0.30.10.tgz
https://registry.npmjs.org/mdn-data/-/mdn-data-2.0.28.tgz -> npmpkg-mdn-data-2.0.28.tgz
https://registry.npmjs.org/mdn-data/-/mdn-data-2.0.30.tgz -> npmpkg-mdn-data-2.0.30.tgz
https://registry.npmjs.org/memoize-one/-/memoize-one-6.0.0.tgz -> npmpkg-memoize-one-6.0.0.tgz
https://registry.npmjs.org/memorystream/-/memorystream-0.3.1.tgz -> npmpkg-memorystream-0.3.1.tgz
https://registry.npmjs.org/merge-stream/-/merge-stream-2.0.0.tgz -> npmpkg-merge-stream-2.0.0.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.52.0.tgz -> npmpkg-mime-db-1.52.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.35.tgz -> npmpkg-mime-types-2.1.35.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-4.0.0.tgz -> npmpkg-mimic-fn-4.0.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.1.tgz -> npmpkg-minimatch-9.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.4.tgz -> npmpkg-minimatch-9.0.4.tgz
https://registry.npmjs.org/minipass/-/minipass-7.1.2.tgz -> npmpkg-minipass-7.1.2.tgz
https://registry.npmjs.org/mlly/-/mlly-1.7.1.tgz -> npmpkg-mlly-1.7.1.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/nanoid/-/nanoid-3.3.7.tgz -> npmpkg-nanoid-3.3.7.tgz
https://registry.npmjs.org/nice-try/-/nice-try-1.0.5.tgz -> npmpkg-nice-try-1.0.5.tgz
https://registry.npmjs.org/nopt/-/nopt-7.2.1.tgz -> npmpkg-nopt-7.2.1.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-2.5.0.tgz -> npmpkg-normalize-package-data-2.5.0.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/normalize-wheel-es/-/normalize-wheel-es-1.2.0.tgz -> npmpkg-normalize-wheel-es-1.2.0.tgz
https://registry.npmjs.org/npm-run-all/-/npm-run-all-4.1.5.tgz -> npmpkg-npm-run-all-4.1.5.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-5.3.0.tgz -> npmpkg-npm-run-path-5.3.0.tgz
https://registry.npmjs.org/nth-check/-/nth-check-2.1.1.tgz -> npmpkg-nth-check-2.1.1.tgz
https://registry.npmjs.org/nwsapi/-/nwsapi-2.2.10.tgz -> npmpkg-nwsapi-2.2.10.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.13.1.tgz -> npmpkg-object-inspect-1.13.1.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/object.assign/-/object.assign-4.1.5.tgz -> npmpkg-object.assign-4.1.5.tgz
https://registry.npmjs.org/onetime/-/onetime-6.0.0.tgz -> npmpkg-onetime-6.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-5.0.0.tgz -> npmpkg-p-limit-5.0.0.tgz
https://registry.npmjs.org/package-json-from-dist/-/package-json-from-dist-1.0.0.tgz -> npmpkg-package-json-from-dist-1.0.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-4.0.0.tgz -> npmpkg-parse-json-4.0.0.tgz
https://registry.npmjs.org/parse5/-/parse5-7.1.2.tgz -> npmpkg-parse5-7.1.2.tgz
https://registry.npmjs.org/path-browserify/-/path-browserify-1.0.1.tgz -> npmpkg-path-browserify-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-2.0.1.tgz -> npmpkg-path-key-2.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/path-key/-/path-key-4.0.0.tgz -> npmpkg-path-key-4.0.0.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-scurry/-/path-scurry-1.11.1.tgz -> npmpkg-path-scurry-1.11.1.tgz
https://registry.npmjs.org/path-type/-/path-type-3.0.0.tgz -> npmpkg-path-type-3.0.0.tgz
https://registry.npmjs.org/pathe/-/pathe-1.1.2.tgz -> npmpkg-pathe-1.1.2.tgz
https://registry.npmjs.org/pathval/-/pathval-1.1.1.tgz -> npmpkg-pathval-1.1.1.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.0.1.tgz -> npmpkg-picocolors-1.0.1.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/pidtree/-/pidtree-0.3.1.tgz -> npmpkg-pidtree-0.3.1.tgz
https://registry.npmjs.org/pify/-/pify-3.0.0.tgz -> npmpkg-pify-3.0.0.tgz
https://registry.npmjs.org/pinia/-/pinia-2.1.7.tgz -> npmpkg-pinia-2.1.7.tgz
https://registry.npmjs.org/pkg-types/-/pkg-types-1.1.1.tgz -> npmpkg-pkg-types-1.1.1.tgz
https://registry.npmjs.org/possible-typed-array-names/-/possible-typed-array-names-1.0.0.tgz -> npmpkg-possible-typed-array-names-1.0.0.tgz
https://registry.npmjs.org/postcss/-/postcss-8.4.38.tgz -> npmpkg-postcss-8.4.38.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/primeflex/-/primeflex-3.3.1.tgz -> npmpkg-primeflex-3.3.1.tgz
https://registry.npmjs.org/primeicons/-/primeicons-7.0.0.tgz -> npmpkg-primeicons-7.0.0.tgz
https://registry.npmjs.org/primevue/-/primevue-3.44.0.tgz -> npmpkg-primevue-3.44.0.tgz
https://registry.npmjs.org/proto-list/-/proto-list-1.2.4.tgz -> npmpkg-proto-list-1.2.4.tgz
https://registry.npmjs.org/proxy-from-env/-/proxy-from-env-1.1.0.tgz -> npmpkg-proxy-from-env-1.1.0.tgz
https://registry.npmjs.org/psl/-/psl-1.9.0.tgz -> npmpkg-psl-1.9.0.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz -> npmpkg-punycode-2.3.1.tgz
https://registry.npmjs.org/querystringify/-/querystringify-2.2.0.tgz -> npmpkg-querystringify-2.2.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.3.1.tgz -> npmpkg-react-is-18.3.1.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-3.0.0.tgz -> npmpkg-read-pkg-3.0.0.tgz
https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz -> npmpkg-readdirp-3.6.0.tgz
https://registry.npmjs.org/reflect-metadata/-/reflect-metadata-0.2.2.tgz -> npmpkg-reflect-metadata-0.2.2.tgz
https://registry.npmjs.org/regexp.prototype.flags/-/regexp.prototype.flags-1.5.2.tgz -> npmpkg-regexp.prototype.flags-1.5.2.tgz
https://registry.npmjs.org/requires-port/-/requires-port-1.0.0.tgz -> npmpkg-requires-port-1.0.0.tgz
https://registry.npmjs.org/resize-detector/-/resize-detector-0.3.0.tgz -> npmpkg-resize-detector-0.3.0.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.8.tgz -> npmpkg-resolve-1.22.8.tgz
https://registry.npmjs.org/rollup/-/rollup-4.18.0.tgz -> npmpkg-rollup-4.18.0.tgz
https://registry.npmjs.org/rrweb-cssom/-/rrweb-cssom-0.6.0.tgz -> npmpkg-rrweb-cssom-0.6.0.tgz
https://registry.npmjs.org/rrweb-cssom/-/rrweb-cssom-0.7.1.tgz -> npmpkg-rrweb-cssom-0.7.1.tgz
https://registry.npmjs.org/safe-array-concat/-/safe-array-concat-1.1.2.tgz -> npmpkg-safe-array-concat-1.1.2.tgz
https://registry.npmjs.org/safe-regex-test/-/safe-regex-test-1.0.3.tgz -> npmpkg-safe-regex-test-1.0.3.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz -> npmpkg-safer-buffer-2.1.2.tgz
https://registry.npmjs.org/sass/-/sass-1.77.6.tgz -> npmpkg-sass-1.77.6.tgz
https://registry.npmjs.org/saxes/-/saxes-6.0.0.tgz -> npmpkg-saxes-6.0.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/semver/-/semver-7.6.2.tgz -> npmpkg-semver-7.6.2.tgz
https://registry.npmjs.org/set-function-length/-/set-function-length-1.2.2.tgz -> npmpkg-set-function-length-1.2.2.tgz
https://registry.npmjs.org/set-function-name/-/set-function-name-2.0.2.tgz -> npmpkg-set-function-name-2.0.2.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-1.2.0.tgz -> npmpkg-shebang-command-1.2.0.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-1.0.0.tgz -> npmpkg-shebang-regex-1.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/shell-quote/-/shell-quote-1.8.1.tgz -> npmpkg-shell-quote-1.8.1.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.6.tgz -> npmpkg-side-channel-1.0.6.tgz
https://registry.npmjs.org/siginfo/-/siginfo-2.0.0.tgz -> npmpkg-siginfo-2.0.0.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-4.1.0.tgz -> npmpkg-signal-exit-4.1.0.tgz
https://registry.npmjs.org/source-map-js/-/source-map-js-1.2.0.tgz -> npmpkg-source-map-js-1.2.0.tgz
https://registry.npmjs.org/spdx-correct/-/spdx-correct-3.2.0.tgz -> npmpkg-spdx-correct-3.2.0.tgz
https://registry.npmjs.org/spdx-exceptions/-/spdx-exceptions-2.5.0.tgz -> npmpkg-spdx-exceptions-2.5.0.tgz
https://registry.npmjs.org/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> npmpkg-spdx-expression-parse-3.0.1.tgz
https://registry.npmjs.org/spdx-license-ids/-/spdx-license-ids-3.0.18.tgz -> npmpkg-spdx-license-ids-3.0.18.tgz
https://registry.npmjs.org/stackback/-/stackback-0.0.2.tgz -> npmpkg-stackback-0.0.2.tgz
https://registry.npmjs.org/std-env/-/std-env-3.7.0.tgz -> npmpkg-std-env-3.7.0.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/string-width/-/string-width-5.1.2.tgz -> npmpkg-string-width-5.1.2.tgz
https://registry.npmjs.org/string.prototype.padend/-/string.prototype.padend-3.1.6.tgz -> npmpkg-string.prototype.padend-3.1.6.tgz
https://registry.npmjs.org/string.prototype.trim/-/string.prototype.trim-1.2.9.tgz -> npmpkg-string.prototype.trim-1.2.9.tgz
https://registry.npmjs.org/string.prototype.trimend/-/string.prototype.trimend-1.0.8.tgz -> npmpkg-string.prototype.trimend-1.0.8.tgz
https://registry.npmjs.org/string.prototype.trimstart/-/string.prototype.trimstart-1.0.8.tgz -> npmpkg-string.prototype.trimstart-1.0.8.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-7.1.0.tgz -> npmpkg-strip-ansi-7.1.0.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz -> npmpkg-strip-bom-3.0.0.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-3.0.0.tgz -> npmpkg-strip-final-newline-3.0.0.tgz
https://registry.npmjs.org/strip-literal/-/strip-literal-2.1.0.tgz -> npmpkg-strip-literal-2.1.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> npmpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.npmjs.org/svgo/-/svgo-3.3.2.tgz -> npmpkg-svgo-3.3.2.tgz
https://registry.npmjs.org/symbol-tree/-/symbol-tree-3.2.4.tgz -> npmpkg-symbol-tree-3.2.4.tgz
https://registry.npmjs.org/tinybench/-/tinybench-2.8.0.tgz -> npmpkg-tinybench-2.8.0.tgz
https://registry.npmjs.org/tinypool/-/tinypool-0.8.4.tgz -> npmpkg-tinypool-0.8.4.tgz
https://registry.npmjs.org/tinyspy/-/tinyspy-2.2.1.tgz -> npmpkg-tinyspy-2.2.1.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/tough-cookie/-/tough-cookie-4.1.4.tgz -> npmpkg-tough-cookie-4.1.4.tgz
https://registry.npmjs.org/tr46/-/tr46-5.0.0.tgz -> npmpkg-tr46-5.0.0.tgz
https://registry.npmjs.org/ts-enum-util/-/ts-enum-util-4.1.0.tgz -> npmpkg-ts-enum-util-4.1.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.3.0.tgz -> npmpkg-tslib-2.3.0.tgz
https://registry.npmjs.org/type-detect/-/type-detect-4.0.8.tgz -> npmpkg-type-detect-4.0.8.tgz
https://registry.npmjs.org/typed-array-buffer/-/typed-array-buffer-1.0.2.tgz -> npmpkg-typed-array-buffer-1.0.2.tgz
https://registry.npmjs.org/typed-array-byte-length/-/typed-array-byte-length-1.0.1.tgz -> npmpkg-typed-array-byte-length-1.0.1.tgz
https://registry.npmjs.org/typed-array-byte-offset/-/typed-array-byte-offset-1.0.2.tgz -> npmpkg-typed-array-byte-offset-1.0.2.tgz
https://registry.npmjs.org/typed-array-length/-/typed-array-length-1.0.6.tgz -> npmpkg-typed-array-length-1.0.6.tgz
https://registry.npmjs.org/typescript/-/typescript-5.5.2.tgz -> npmpkg-typescript-5.5.2.tgz
https://registry.npmjs.org/ufo/-/ufo-1.5.3.tgz -> npmpkg-ufo-1.5.3.tgz
https://registry.npmjs.org/unbox-primitive/-/unbox-primitive-1.0.2.tgz -> npmpkg-unbox-primitive-1.0.2.tgz
https://registry.npmjs.org/undici-types/-/undici-types-5.26.5.tgz -> npmpkg-undici-types-5.26.5.tgz
https://registry.npmjs.org/universalify/-/universalify-0.2.0.tgz -> npmpkg-universalify-0.2.0.tgz
https://registry.npmjs.org/uplot/-/uplot-1.6.30.tgz -> npmpkg-uplot-1.6.30.tgz
https://registry.npmjs.org/url-parse/-/url-parse-1.5.10.tgz -> npmpkg-url-parse-1.5.10.tgz
https://registry.npmjs.org/uuid/-/uuid-9.0.1.tgz -> npmpkg-uuid-9.0.1.tgz
https://registry.npmjs.org/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> npmpkg-validate-npm-package-license-3.0.4.tgz
https://registry.npmjs.org/vite-node/-/vite-node-1.6.0.tgz -> npmpkg-vite-node-1.6.0.tgz
https://registry.npmjs.org/vite-plugin-package-version/-/vite-plugin-package-version-1.1.0.tgz -> npmpkg-vite-plugin-package-version-1.1.0.tgz
https://registry.npmjs.org/vite-svg-loader/-/vite-svg-loader-5.1.0.tgz -> npmpkg-vite-svg-loader-5.1.0.tgz
https://registry.npmjs.org/vite/-/vite-5.3.1.tgz -> npmpkg-vite-5.3.1.tgz
https://registry.npmjs.org/vitest/-/vitest-1.6.0.tgz -> npmpkg-vitest-1.6.0.tgz
https://registry.npmjs.org/vscode-uri/-/vscode-uri-3.0.8.tgz -> npmpkg-vscode-uri-3.0.8.tgz
https://registry.npmjs.org/vue-component-type-helpers/-/vue-component-type-helpers-2.0.21.tgz -> npmpkg-vue-component-type-helpers-2.0.21.tgz
https://registry.npmjs.org/vue-demi/-/vue-demi-0.13.11.tgz -> npmpkg-vue-demi-0.13.11.tgz
https://registry.npmjs.org/vue-demi/-/vue-demi-0.14.8.tgz -> npmpkg-vue-demi-0.14.8.tgz
https://registry.npmjs.org/vue-echarts/-/vue-echarts-6.7.3.tgz -> npmpkg-vue-echarts-6.7.3.tgz
https://registry.npmjs.org/vue-router/-/vue-router-4.4.0.tgz -> npmpkg-vue-router-4.4.0.tgz
https://registry.npmjs.org/vue-template-compiler/-/vue-template-compiler-2.7.16.tgz -> npmpkg-vue-template-compiler-2.7.16.tgz
https://registry.npmjs.org/vue-tsc/-/vue-tsc-2.0.21.tgz -> npmpkg-vue-tsc-2.0.21.tgz
https://registry.npmjs.org/vue/-/vue-3.4.29.tgz -> npmpkg-vue-3.4.29.tgz
https://registry.npmjs.org/w3c-xmlserializer/-/w3c-xmlserializer-5.0.0.tgz -> npmpkg-w3c-xmlserializer-5.0.0.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-7.0.0.tgz -> npmpkg-webidl-conversions-7.0.0.tgz
https://registry.npmjs.org/whatwg-encoding/-/whatwg-encoding-3.1.1.tgz -> npmpkg-whatwg-encoding-3.1.1.tgz
https://registry.npmjs.org/whatwg-mimetype/-/whatwg-mimetype-4.0.0.tgz -> npmpkg-whatwg-mimetype-4.0.0.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-14.0.0.tgz -> npmpkg-whatwg-url-14.0.0.tgz
https://registry.npmjs.org/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> npmpkg-which-boxed-primitive-1.0.2.tgz
https://registry.npmjs.org/which-typed-array/-/which-typed-array-1.1.15.tgz -> npmpkg-which-typed-array-1.1.15.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/why-is-node-running/-/why-is-node-running-2.2.2.tgz -> npmpkg-why-is-node-running-2.2.2.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-8.1.0.tgz -> npmpkg-wrap-ansi-8.1.0.tgz
https://registry.npmjs.org/ws/-/ws-8.17.1.tgz -> npmpkg-ws-8.17.1.tgz
https://registry.npmjs.org/xml-name-validator/-/xml-name-validator-5.0.0.tgz -> npmpkg-xml-name-validator-5.0.0.tgz
https://registry.npmjs.org/xmlchars/-/xmlchars-2.2.0.tgz -> npmpkg-xmlchars-2.2.0.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-1.0.0.tgz -> npmpkg-yocto-queue-1.0.0.tgz
https://registry.npmjs.org/zrender/-/zrender-5.5.0.tgz -> npmpkg-zrender-5.5.0.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS

NPM_TARBALL="coolercontrol-${PV}.tar.bz2"
PYTHON_COMPAT=( python3_{10,11} ) # Can support 3.12 but limited by Nuitka

inherit cargo lcnr npm

KEYWORDS="~amd64"
S="${WORKDIR}/coolercontrol-${PV}/coolercontrold"
SRC_URI="
$(cargo_crate_uris ${CRATES})
${NPM_EXTERNAL_URIS}
https://gitlab.com/coolercontrol/coolercontrol/-/archive/${PV}/coolercontrol-${PV}.tar.bz2
"

DESCRIPTION="coolercontrold is the main daemon containing the core logic for interfacing with devices"
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
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" hwmon video_cards_nvidia openrc systemd ebuild-revision-1"
RDEPEND+="
	~sys-apps/coolercontrol-liqctld-${PV}
	hwmon? (
		>=sys-apps/lm-sensors-3.6.0
	)
	video_cards_nvidia? (
		x11-drivers/nvidia-drivers[tools]
	)
"
DEPEND+="
	${RDEPEND}
"
VUE_DEPEND="
	>=net-libs/nodejs-18.12.0[npm]
"
BDEPEND+="
	${VUE_DEPEND}
	>=dev-build/make-4.3
	virtual/pkgconfig
	virtual/rust
"

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

set_gui_port() {
	local L=(
		"coolercontrold/src/api/mod.rs"
	)
	local port=${COOLERCONTROL_GUI_PORT:-11987}
	local p
	for p in "${L[@]}" ; do
		sed -i -e "s|11987|${port}|g" "${p}" || die
	done
}

set_liqctld_port() {
	local L=(
		"coolercontrold/src/repositories/liquidctl/liquidctl_repo.rs"
	)
	local port=${COOLERCONTROL_LIQCTLD_PORT:-11986}
	local p
	for p in "${L[@]}" ; do
		sed -i -e "s|11986|${port}|g" "${p}" || die
	done
}

pkg_setup() {
ewarn "Do not emerge ${CATEGORY}/${PN} package directly.  Emerge sys-apps/coolercontrol instead."
	npm_pkg_setup
}

src_unpack() {
	S="${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui" \
	npm_src_unpack
	S="${WORKDIR}/coolercontrol-${PV}/coolercontrold" \
	_cargo_src_unpack
}

src_configure() {
	S="${WORKDIR}/coolercontrol-${PV}/coolercontrold" \
	cargo_src_configure
	pushd "${WORKDIR}/coolercontrol-${PV}" || die
		set_gui_port
		set_liqctld_port
	popd
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
	cp -r \
		"${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui/dist/"* \
		"resources/app/" \
		|| die
	S="${WORKDIR}/coolercontrol-${PV}/coolercontrold" \
	cargo_src_compile
}

src_install() {
	S="${WORKDIR}/coolercontrol-${PV}/coolercontrold" \
	cargo_src_install
	if use openrc ; then
ewarn
ewarn "The OpenRC script is experimental for ${CATEGORY}/${PN}."
ewarn "If it works, send an issue request to remove this message."
ewarn
		exeinto /etc/init.d
		doexe "${FILESDIR}/coolercontrold"
	fi
	if use systemd ; then
		insinto /lib/systemd/system
		doins "${WORKDIR}/coolercontrol-${PV}/packaging/systemd/coolercontrold.service"
	fi
	if ! use openrc && ! use systemd ; then
ewarn
ewarn "You are responsible to creating the init service for ${PN} for your"
ewarn "init system."
ewarn
	fi

	LCNR_SOURCE="${WORKDIR}/cargo_home/gentoo"
	LCNR_TAG="third_party_cargo"
	lcnr_install_files

	LCNR_SOURCE="${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui/node_modules"
	LCNR_TAG="third_party_npm"
	lcnr_install_files
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  passed (0.17.2, 20231201)
