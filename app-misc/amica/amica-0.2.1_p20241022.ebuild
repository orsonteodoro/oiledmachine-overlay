# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# FIXME: Fix ollama /api/chat support

NPM_AUDIT_FIX=0 # Lockfiles are the same as upstream because I'm still fixing the missing microphone dialog permissions prompt window

CRATES="
addr2line-0.21.0
adler-1.0.2
aho-corasick-1.1.2
alloc-no-stdlib-2.0.4
alloc-stdlib-0.2.2
android-tzdata-0.1.1
android_system_properties-0.1.5
anyhow-1.0.75
atk-0.15.1
atk-sys-0.15.1
autocfg-1.1.0
backtrace-0.3.69
base64-0.13.1
base64-0.21.5
bitflags-1.3.2
bitflags-2.4.1
block-0.1.6
block-buffer-0.10.4
brotli-3.4.0
brotli-decompressor-2.5.1
bstr-1.8.0
bumpalo-3.14.0
bytemuck-1.14.0
byteorder-1.5.0
bytes-1.5.0
cairo-rs-0.15.12
cairo-sys-rs-0.15.1
cargo_toml-0.15.3
cc-1.0.83
cesu8-1.1.0
cfb-0.7.3
cfg-expr-0.15.5
cfg-expr-0.9.1
cfg-if-1.0.0
chrono-0.4.31
cocoa-0.24.1
cocoa-foundation-0.1.2
color_quant-1.1.0
combine-4.6.6
convert_case-0.4.0
core-foundation-0.9.4
core-foundation-sys-0.8.6
core-graphics-0.22.3
core-graphics-types-0.1.3
cpufeatures-0.2.11
crc32fast-1.3.2
crossbeam-channel-0.5.9
crossbeam-deque-0.8.4
crossbeam-epoch-0.9.16
crossbeam-utils-0.8.17
crypto-common-0.1.6
cssparser-0.27.2
cssparser-macros-0.6.1
ctor-0.2.6
darling-0.20.3
darling_core-0.20.3
darling_macro-0.20.3
deranged-0.3.10
derive_more-0.99.17
digest-0.10.7
dirs-next-2.0.0
dirs-sys-next-0.1.2
dispatch-0.2.0
dtoa-1.0.9
dtoa-short-0.3.4
dunce-1.0.4
embed-resource-2.4.0
embed_plist-1.2.2
encoding_rs-0.8.33
equivalent-1.0.1
errno-0.3.8
fastrand-2.0.1
fdeflate-0.3.1
field-offset-0.3.6
filetime-0.2.23
flate2-1.0.28
fnv-1.0.7
foreign-types-0.3.2
foreign-types-shared-0.1.1
form_urlencoded-1.2.1
futf-0.1.5
futures-channel-0.3.29
futures-core-0.3.29
futures-executor-0.3.29
futures-io-0.3.29
futures-macro-0.3.29
futures-task-0.3.29
futures-util-0.3.29
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
getrandom-0.2.11
gimli-0.28.1
gio-0.15.12
gio-sys-0.15.10
glib-0.15.12
glib-macros-0.15.13
glib-sys-0.15.10
glob-0.3.1
globset-0.4.14
gobject-sys-0.15.10
gtk-0.15.5
gtk-sys-0.15.3
gtk3-macros-0.15.6
hashbrown-0.12.3
hashbrown-0.14.3
heck-0.3.3
heck-0.4.1
hermit-abi-0.3.3
hex-0.4.3
html5ever-0.25.2
html5ever-0.26.0
http-0.2.11
http-range-0.1.5
iana-time-zone-0.1.58
iana-time-zone-haiku-0.1.2
ico-0.3.0
ident_case-1.0.1
idna-0.5.0
ignore-0.4.21
image-0.24.7
indexmap-1.9.3
indexmap-2.1.0
infer-0.13.0
instant-0.1.12
itoa-0.4.8
itoa-1.0.10
javascriptcore-rs-0.16.0
javascriptcore-rs-sys-0.4.0
jni-0.20.0
jni-sys-0.3.0
js-sys-0.3.66
json-patch-1.2.0
kuchiki-0.8.1
kuchikiki-0.8.2
lazy_static-1.4.0
libappindicator-0.7.1
libappindicator-sys-0.7.3
libc-0.2.151
libloading-0.7.4
libredox-0.0.1
line-wrap-0.1.1
linux-raw-sys-0.4.12
lock_api-0.4.11
log-0.4.20
loom-0.5.6
mac-0.1.1
malloc_buf-0.0.6
markup5ever-0.10.1
markup5ever-0.11.0
matchers-0.1.0
matches-0.1.10
memchr-2.6.4
memoffset-0.9.0
miniz_oxide-0.7.1
ndk-0.6.0
ndk-context-0.1.1
ndk-sys-0.3.0
new_debug_unreachable-1.0.4
nodrop-0.1.14
nu-ansi-term-0.46.0
num-integer-0.1.45
num-rational-0.4.1
num-traits-0.2.17
num_cpus-1.16.0
num_enum-0.5.11
num_enum_derive-0.5.11
objc-0.2.7
objc_exception-0.1.2
objc_id-0.1.1
object-0.32.1
once_cell-1.19.0
open-3.2.0
overload-0.1.1
pango-0.15.10
pango-sys-0.15.10
parking_lot-0.12.1
parking_lot_core-0.9.9
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
pin-project-lite-0.2.13
pin-utils-0.1.0
pkg-config-0.3.27
plist-1.6.0
png-0.17.10
powerfmt-0.2.0
ppv-lite86-0.2.17
precomputed-hash-0.1.1
proc-macro-crate-1.3.1
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro-hack-0.5.20+deprecated
proc-macro2-1.0.70
quick-xml-0.31.0
quote-1.0.33
rand-0.7.3
rand-0.8.5
rand_chacha-0.2.2
rand_chacha-0.3.1
rand_core-0.5.1
rand_core-0.6.4
rand_hc-0.2.0
rand_pcg-0.2.1
raw-window-handle-0.5.2
redox_syscall-0.4.1
redox_users-0.4.4
regex-1.10.2
regex-automata-0.1.10
regex-automata-0.4.3
regex-syntax-0.6.29
regex-syntax-0.8.2
rustc-demangle-0.1.23
rustc_version-0.4.0
rustix-0.38.28
rustversion-1.0.14
ryu-1.0.16
safemem-0.3.3
same-file-1.0.6
scoped-tls-1.0.1
scopeguard-1.2.0
selectors-0.22.0
semver-1.0.20
serde-1.0.193
serde_derive-1.0.193
serde_json-1.0.108
serde_repr-0.1.17
serde_spanned-0.6.4
serde_with-3.4.0
serde_with_macros-3.4.0
serialize-to-javascript-0.1.1
serialize-to-javascript-impl-0.1.1
servo_arc-0.1.1
sha2-0.10.8
sharded-slab-0.1.7
simd-adler32-0.3.7
siphasher-0.3.11
slab-0.4.9
smallvec-1.11.2
soup2-0.2.1
soup2-sys-0.2.0
stable_deref_trait-1.2.0
state-0.5.3
string_cache-0.8.7
string_cache_codegen-0.5.2
strsim-0.10.0
syn-1.0.109
syn-2.0.41
system-deps-5.0.0
system-deps-6.2.0
tao-0.16.5
tao-macros-0.1.2
tar-0.4.40
target-lexicon-0.12.12
tauri-1.5.3
tauri-build-1.5.0
tauri-codegen-1.4.1
tauri-macros-1.4.2
tauri-runtime-0.14.1
tauri-runtime-wry-0.14.2
tauri-utils-1.5.1
tauri-winres-0.1.1
tempfile-3.8.1
tendril-0.4.3
thin-slice-0.1.1
thiserror-1.0.50
thiserror-impl-1.0.50
thread_local-1.1.7
time-0.3.30
time-core-0.1.2
time-macros-0.2.15
tinyvec-1.6.0
tinyvec_macros-0.1.1
tokio-1.35.0
toml-0.5.11
toml-0.7.8
toml-0.8.8
toml_datetime-0.6.5
toml_edit-0.19.15
toml_edit-0.21.0
tracing-0.1.40
tracing-attributes-0.1.27
tracing-core-0.1.32
tracing-log-0.2.0
tracing-subscriber-0.3.18
treediff-4.0.2
typenum-1.17.0
unicode-bidi-0.3.14
unicode-ident-1.0.12
unicode-normalization-0.1.22
unicode-segmentation-1.10.1
url-2.5.0
utf-8-0.7.6
uuid-1.6.1
valuable-0.1.0
version-compare-0.0.11
version-compare-0.1.1
version_check-0.9.4
vswhom-0.1.0
vswhom-sys-0.1.2
walkdir-2.4.0
wasi-0.11.0+wasi-snapshot-preview1
wasi-0.9.0+wasi-snapshot-preview1
wasm-bindgen-0.2.89
wasm-bindgen-backend-0.2.89
wasm-bindgen-macro-0.2.89
wasm-bindgen-macro-support-0.2.89
wasm-bindgen-shared-0.2.89
webkit2gtk-0.18.2
webkit2gtk-sys-0.18.0
webview2-com-0.19.1
webview2-com-macros-0.6.0
webview2-com-sys-0.19.0
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.6
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.39.0
windows-0.48.0
windows-bindgen-0.39.0
windows-core-0.51.1
windows-implement-0.39.0
windows-metadata-0.39.0
windows-sys-0.42.0
windows-sys-0.48.0
windows-sys-0.52.0
windows-targets-0.48.5
windows-targets-0.52.0
windows-tokens-0.39.0
windows-version-0.1.0
windows_aarch64_gnullvm-0.42.2
windows_aarch64_gnullvm-0.48.5
windows_aarch64_gnullvm-0.52.0
windows_aarch64_msvc-0.39.0
windows_aarch64_msvc-0.42.2
windows_aarch64_msvc-0.48.5
windows_aarch64_msvc-0.52.0
windows_i686_gnu-0.39.0
windows_i686_gnu-0.42.2
windows_i686_gnu-0.48.5
windows_i686_gnu-0.52.0
windows_i686_msvc-0.39.0
windows_i686_msvc-0.42.2
windows_i686_msvc-0.48.5
windows_i686_msvc-0.52.0
windows_x86_64_gnu-0.39.0
windows_x86_64_gnu-0.42.2
windows_x86_64_gnu-0.48.5
windows_x86_64_gnu-0.52.0
windows_x86_64_gnullvm-0.42.2
windows_x86_64_gnullvm-0.48.5
windows_x86_64_gnullvm-0.52.0
windows_x86_64_msvc-0.39.0
windows_x86_64_msvc-0.42.2
windows_x86_64_msvc-0.48.5
windows_x86_64_msvc-0.52.0
winnow-0.5.28
winreg-0.51.0
wry-0.24.6
x11-2.21.0
x11-dl-2.21.0
xattr-1.1.3
"
EGIT_COMMIT="cf39b01ce92c6fa02dba4ab245e8e97311edd969"
NODE_VERSION=20
NODE_ENV="development"
PYTHON_COMPAT=( "python3_"{10..12} )
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

inherit cargo desktop lcnr npm python-single-r1 xdg

# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@adobe/css-tools/-/css-tools-4.3.2.tgz -> npmpkg-@adobe-css-tools-4.3.2.tgz
https://registry.npmjs.org/@ampproject/remapping/-/remapping-2.2.1.tgz -> npmpkg-@ampproject-remapping-2.2.1.tgz
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.22.13.tgz -> npmpkg-@babel-code-frame-7.22.13.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/@babel/compat-data/-/compat-data-7.23.2.tgz -> npmpkg-@babel-compat-data-7.23.2.tgz
https://registry.npmjs.org/@babel/core/-/core-7.23.2.tgz -> npmpkg-@babel-core-7.23.2.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@babel/generator/-/generator-7.23.0.tgz -> npmpkg-@babel-generator-7.23.0.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.20.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.20.tgz
https://registry.npmjs.org/@babel/helper-annotate-as-pure/-/helper-annotate-as-pure-7.22.5.tgz -> npmpkg-@babel-helper-annotate-as-pure-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-builder-binary-assignment-operator-visitor/-/helper-builder-binary-assignment-operator-visitor-7.22.15.tgz -> npmpkg-@babel-helper-builder-binary-assignment-operator-visitor-7.22.15.tgz
https://registry.npmjs.org/@babel/helper-compilation-targets/-/helper-compilation-targets-7.22.15.tgz -> npmpkg-@babel-helper-compilation-targets-7.22.15.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-5.1.1.tgz -> npmpkg-lru-cache-5.1.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/yallist/-/yallist-3.1.1.tgz -> npmpkg-yallist-3.1.1.tgz
https://registry.npmjs.org/@babel/helper-create-class-features-plugin/-/helper-create-class-features-plugin-7.22.15.tgz -> npmpkg-@babel-helper-create-class-features-plugin-7.22.15.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@babel/helper-create-regexp-features-plugin/-/helper-create-regexp-features-plugin-7.22.15.tgz -> npmpkg-@babel-helper-create-regexp-features-plugin-7.22.15.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@babel/helper-define-polyfill-provider/-/helper-define-polyfill-provider-0.4.3.tgz -> npmpkg-@babel-helper-define-polyfill-provider-0.4.3.tgz
https://registry.npmjs.org/@babel/helper-environment-visitor/-/helper-environment-visitor-7.22.20.tgz -> npmpkg-@babel-helper-environment-visitor-7.22.20.tgz
https://registry.npmjs.org/@babel/helper-function-name/-/helper-function-name-7.23.0.tgz -> npmpkg-@babel-helper-function-name-7.23.0.tgz
https://registry.npmjs.org/@babel/helper-hoist-variables/-/helper-hoist-variables-7.22.5.tgz -> npmpkg-@babel-helper-hoist-variables-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-member-expression-to-functions/-/helper-member-expression-to-functions-7.23.0.tgz -> npmpkg-@babel-helper-member-expression-to-functions-7.23.0.tgz
https://registry.npmjs.org/@babel/helper-module-imports/-/helper-module-imports-7.22.15.tgz -> npmpkg-@babel-helper-module-imports-7.22.15.tgz
https://registry.npmjs.org/@babel/helper-module-transforms/-/helper-module-transforms-7.23.0.tgz -> npmpkg-@babel-helper-module-transforms-7.23.0.tgz
https://registry.npmjs.org/@babel/helper-optimise-call-expression/-/helper-optimise-call-expression-7.22.5.tgz -> npmpkg-@babel-helper-optimise-call-expression-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-plugin-utils/-/helper-plugin-utils-7.22.5.tgz -> npmpkg-@babel-helper-plugin-utils-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-remap-async-to-generator/-/helper-remap-async-to-generator-7.22.20.tgz -> npmpkg-@babel-helper-remap-async-to-generator-7.22.20.tgz
https://registry.npmjs.org/@babel/helper-replace-supers/-/helper-replace-supers-7.22.20.tgz -> npmpkg-@babel-helper-replace-supers-7.22.20.tgz
https://registry.npmjs.org/@babel/helper-simple-access/-/helper-simple-access-7.22.5.tgz -> npmpkg-@babel-helper-simple-access-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-skip-transparent-expression-wrappers/-/helper-skip-transparent-expression-wrappers-7.22.5.tgz -> npmpkg-@babel-helper-skip-transparent-expression-wrappers-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.22.6.tgz -> npmpkg-@babel-helper-split-export-declaration-7.22.6.tgz
https://registry.npmjs.org/@babel/helper-string-parser/-/helper-string-parser-7.22.5.tgz -> npmpkg-@babel-helper-string-parser-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.22.20.tgz -> npmpkg-@babel-helper-validator-identifier-7.22.20.tgz
https://registry.npmjs.org/@babel/helper-validator-option/-/helper-validator-option-7.22.15.tgz -> npmpkg-@babel-helper-validator-option-7.22.15.tgz
https://registry.npmjs.org/@babel/helper-wrap-function/-/helper-wrap-function-7.22.20.tgz -> npmpkg-@babel-helper-wrap-function-7.22.20.tgz
https://registry.npmjs.org/@babel/helpers/-/helpers-7.23.2.tgz -> npmpkg-@babel-helpers-7.23.2.tgz
https://registry.npmjs.org/@babel/highlight/-/highlight-7.22.20.tgz -> npmpkg-@babel-highlight-7.22.20.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/@babel/parser/-/parser-7.23.0.tgz -> npmpkg-@babel-parser-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-bugfix-safari-id-destructuring-collision-in-function-expression/-/plugin-bugfix-safari-id-destructuring-collision-in-function-expression-7.22.15.tgz -> npmpkg-@babel-plugin-bugfix-safari-id-destructuring-collision-in-function-expression-7.22.15.tgz
https://registry.npmjs.org/@babel/plugin-bugfix-v8-spread-parameters-in-optional-chaining/-/plugin-bugfix-v8-spread-parameters-in-optional-chaining-7.22.15.tgz -> npmpkg-@babel-plugin-bugfix-v8-spread-parameters-in-optional-chaining-7.22.15.tgz
https://registry.npmjs.org/@babel/plugin-proposal-private-property-in-object/-/plugin-proposal-private-property-in-object-7.21.0-placeholder-for-preset-env.2.tgz -> npmpkg-@babel-plugin-proposal-private-property-in-object-7.21.0-placeholder-for-preset-env.2.tgz
https://registry.npmjs.org/@babel/plugin-syntax-async-generators/-/plugin-syntax-async-generators-7.8.4.tgz -> npmpkg-@babel-plugin-syntax-async-generators-7.8.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-bigint/-/plugin-syntax-bigint-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-bigint-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-class-properties/-/plugin-syntax-class-properties-7.12.13.tgz -> npmpkg-@babel-plugin-syntax-class-properties-7.12.13.tgz
https://registry.npmjs.org/@babel/plugin-syntax-class-static-block/-/plugin-syntax-class-static-block-7.14.5.tgz -> npmpkg-@babel-plugin-syntax-class-static-block-7.14.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-dynamic-import/-/plugin-syntax-dynamic-import-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-dynamic-import-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-export-namespace-from/-/plugin-syntax-export-namespace-from-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-export-namespace-from-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-import-assertions/-/plugin-syntax-import-assertions-7.22.5.tgz -> npmpkg-@babel-plugin-syntax-import-assertions-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-import-attributes/-/plugin-syntax-import-attributes-7.22.5.tgz -> npmpkg-@babel-plugin-syntax-import-attributes-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-import-meta/-/plugin-syntax-import-meta-7.10.4.tgz -> npmpkg-@babel-plugin-syntax-import-meta-7.10.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-json-strings/-/plugin-syntax-json-strings-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-json-strings-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-jsx/-/plugin-syntax-jsx-7.23.3.tgz -> npmpkg-@babel-plugin-syntax-jsx-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-logical-assignment-operators/-/plugin-syntax-logical-assignment-operators-7.10.4.tgz -> npmpkg-@babel-plugin-syntax-logical-assignment-operators-7.10.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-nullish-coalescing-operator/-/plugin-syntax-nullish-coalescing-operator-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-nullish-coalescing-operator-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-numeric-separator/-/plugin-syntax-numeric-separator-7.10.4.tgz -> npmpkg-@babel-plugin-syntax-numeric-separator-7.10.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-object-rest-spread/-/plugin-syntax-object-rest-spread-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-object-rest-spread-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-optional-catch-binding/-/plugin-syntax-optional-catch-binding-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-optional-catch-binding-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-optional-chaining/-/plugin-syntax-optional-chaining-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-optional-chaining-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-private-property-in-object/-/plugin-syntax-private-property-in-object-7.14.5.tgz -> npmpkg-@babel-plugin-syntax-private-property-in-object-7.14.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-top-level-await/-/plugin-syntax-top-level-await-7.14.5.tgz -> npmpkg-@babel-plugin-syntax-top-level-await-7.14.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-typescript/-/plugin-syntax-typescript-7.23.3.tgz -> npmpkg-@babel-plugin-syntax-typescript-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-unicode-sets-regex/-/plugin-syntax-unicode-sets-regex-7.18.6.tgz -> npmpkg-@babel-plugin-syntax-unicode-sets-regex-7.18.6.tgz
https://registry.npmjs.org/@babel/plugin-transform-arrow-functions/-/plugin-transform-arrow-functions-7.22.5.tgz -> npmpkg-@babel-plugin-transform-arrow-functions-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-async-generator-functions/-/plugin-transform-async-generator-functions-7.23.2.tgz -> npmpkg-@babel-plugin-transform-async-generator-functions-7.23.2.tgz
https://registry.npmjs.org/@babel/plugin-transform-async-to-generator/-/plugin-transform-async-to-generator-7.22.5.tgz -> npmpkg-@babel-plugin-transform-async-to-generator-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-block-scoped-functions/-/plugin-transform-block-scoped-functions-7.22.5.tgz -> npmpkg-@babel-plugin-transform-block-scoped-functions-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-block-scoping/-/plugin-transform-block-scoping-7.23.0.tgz -> npmpkg-@babel-plugin-transform-block-scoping-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-class-properties/-/plugin-transform-class-properties-7.22.5.tgz -> npmpkg-@babel-plugin-transform-class-properties-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-class-static-block/-/plugin-transform-class-static-block-7.22.11.tgz -> npmpkg-@babel-plugin-transform-class-static-block-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-classes/-/plugin-transform-classes-7.22.15.tgz -> npmpkg-@babel-plugin-transform-classes-7.22.15.tgz
https://registry.npmjs.org/globals/-/globals-11.12.0.tgz -> npmpkg-globals-11.12.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-computed-properties/-/plugin-transform-computed-properties-7.22.5.tgz -> npmpkg-@babel-plugin-transform-computed-properties-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-destructuring/-/plugin-transform-destructuring-7.23.0.tgz -> npmpkg-@babel-plugin-transform-destructuring-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-dotall-regex/-/plugin-transform-dotall-regex-7.22.5.tgz -> npmpkg-@babel-plugin-transform-dotall-regex-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-duplicate-keys/-/plugin-transform-duplicate-keys-7.22.5.tgz -> npmpkg-@babel-plugin-transform-duplicate-keys-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-dynamic-import/-/plugin-transform-dynamic-import-7.22.11.tgz -> npmpkg-@babel-plugin-transform-dynamic-import-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-exponentiation-operator/-/plugin-transform-exponentiation-operator-7.22.5.tgz -> npmpkg-@babel-plugin-transform-exponentiation-operator-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-export-namespace-from/-/plugin-transform-export-namespace-from-7.22.11.tgz -> npmpkg-@babel-plugin-transform-export-namespace-from-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-for-of/-/plugin-transform-for-of-7.22.15.tgz -> npmpkg-@babel-plugin-transform-for-of-7.22.15.tgz
https://registry.npmjs.org/@babel/plugin-transform-function-name/-/plugin-transform-function-name-7.22.5.tgz -> npmpkg-@babel-plugin-transform-function-name-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-json-strings/-/plugin-transform-json-strings-7.22.11.tgz -> npmpkg-@babel-plugin-transform-json-strings-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-literals/-/plugin-transform-literals-7.22.5.tgz -> npmpkg-@babel-plugin-transform-literals-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-logical-assignment-operators/-/plugin-transform-logical-assignment-operators-7.22.11.tgz -> npmpkg-@babel-plugin-transform-logical-assignment-operators-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-member-expression-literals/-/plugin-transform-member-expression-literals-7.22.5.tgz -> npmpkg-@babel-plugin-transform-member-expression-literals-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-amd/-/plugin-transform-modules-amd-7.23.0.tgz -> npmpkg-@babel-plugin-transform-modules-amd-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-commonjs/-/plugin-transform-modules-commonjs-7.23.0.tgz -> npmpkg-@babel-plugin-transform-modules-commonjs-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-systemjs/-/plugin-transform-modules-systemjs-7.23.0.tgz -> npmpkg-@babel-plugin-transform-modules-systemjs-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-umd/-/plugin-transform-modules-umd-7.22.5.tgz -> npmpkg-@babel-plugin-transform-modules-umd-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-named-capturing-groups-regex/-/plugin-transform-named-capturing-groups-regex-7.22.5.tgz -> npmpkg-@babel-plugin-transform-named-capturing-groups-regex-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-new-target/-/plugin-transform-new-target-7.22.5.tgz -> npmpkg-@babel-plugin-transform-new-target-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-nullish-coalescing-operator/-/plugin-transform-nullish-coalescing-operator-7.22.11.tgz -> npmpkg-@babel-plugin-transform-nullish-coalescing-operator-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-numeric-separator/-/plugin-transform-numeric-separator-7.22.11.tgz -> npmpkg-@babel-plugin-transform-numeric-separator-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-object-rest-spread/-/plugin-transform-object-rest-spread-7.22.15.tgz -> npmpkg-@babel-plugin-transform-object-rest-spread-7.22.15.tgz
https://registry.npmjs.org/@babel/plugin-transform-object-super/-/plugin-transform-object-super-7.22.5.tgz -> npmpkg-@babel-plugin-transform-object-super-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-optional-catch-binding/-/plugin-transform-optional-catch-binding-7.22.11.tgz -> npmpkg-@babel-plugin-transform-optional-catch-binding-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-optional-chaining/-/plugin-transform-optional-chaining-7.23.0.tgz -> npmpkg-@babel-plugin-transform-optional-chaining-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-parameters/-/plugin-transform-parameters-7.22.15.tgz -> npmpkg-@babel-plugin-transform-parameters-7.22.15.tgz
https://registry.npmjs.org/@babel/plugin-transform-private-methods/-/plugin-transform-private-methods-7.22.5.tgz -> npmpkg-@babel-plugin-transform-private-methods-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-private-property-in-object/-/plugin-transform-private-property-in-object-7.22.11.tgz -> npmpkg-@babel-plugin-transform-private-property-in-object-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-property-literals/-/plugin-transform-property-literals-7.22.5.tgz -> npmpkg-@babel-plugin-transform-property-literals-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-regenerator/-/plugin-transform-regenerator-7.22.10.tgz -> npmpkg-@babel-plugin-transform-regenerator-7.22.10.tgz
https://registry.npmjs.org/@babel/plugin-transform-reserved-words/-/plugin-transform-reserved-words-7.22.5.tgz -> npmpkg-@babel-plugin-transform-reserved-words-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-shorthand-properties/-/plugin-transform-shorthand-properties-7.22.5.tgz -> npmpkg-@babel-plugin-transform-shorthand-properties-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-spread/-/plugin-transform-spread-7.22.5.tgz -> npmpkg-@babel-plugin-transform-spread-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-sticky-regex/-/plugin-transform-sticky-regex-7.22.5.tgz -> npmpkg-@babel-plugin-transform-sticky-regex-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-template-literals/-/plugin-transform-template-literals-7.22.5.tgz -> npmpkg-@babel-plugin-transform-template-literals-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-typeof-symbol/-/plugin-transform-typeof-symbol-7.22.5.tgz -> npmpkg-@babel-plugin-transform-typeof-symbol-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-escapes/-/plugin-transform-unicode-escapes-7.22.10.tgz -> npmpkg-@babel-plugin-transform-unicode-escapes-7.22.10.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-property-regex/-/plugin-transform-unicode-property-regex-7.22.5.tgz -> npmpkg-@babel-plugin-transform-unicode-property-regex-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-regex/-/plugin-transform-unicode-regex-7.22.5.tgz -> npmpkg-@babel-plugin-transform-unicode-regex-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-sets-regex/-/plugin-transform-unicode-sets-regex-7.22.5.tgz -> npmpkg-@babel-plugin-transform-unicode-sets-regex-7.22.5.tgz
https://registry.npmjs.org/@babel/preset-env/-/preset-env-7.23.2.tgz -> npmpkg-@babel-preset-env-7.23.2.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@babel/preset-modules/-/preset-modules-0.1.6-no-external-plugins.tgz -> npmpkg-@babel-preset-modules-0.1.6-no-external-plugins.tgz
https://registry.npmjs.org/@babel/regjsgen/-/regjsgen-0.8.0.tgz -> npmpkg-@babel-regjsgen-0.8.0.tgz
https://registry.npmjs.org/@babel/runtime/-/runtime-7.23.5.tgz -> npmpkg-@babel-runtime-7.23.5.tgz
https://registry.npmjs.org/@babel/template/-/template-7.22.15.tgz -> npmpkg-@babel-template-7.22.15.tgz
https://registry.npmjs.org/@babel/traverse/-/traverse-7.23.2.tgz -> npmpkg-@babel-traverse-7.23.2.tgz
https://registry.npmjs.org/globals/-/globals-11.12.0.tgz -> npmpkg-globals-11.12.0.tgz
https://registry.npmjs.org/@babel/types/-/types-7.23.0.tgz -> npmpkg-@babel-types-7.23.0.tgz
https://registry.npmjs.org/@bcoe/v8-coverage/-/v8-coverage-0.2.3.tgz -> npmpkg-@bcoe-v8-coverage-0.2.3.tgz
https://registry.npmjs.org/@charcoal-ui/foundation/-/foundation-2.10.0.tgz -> npmpkg-@charcoal-ui-foundation-2.10.0.tgz
https://registry.npmjs.org/@charcoal-ui/icon-files/-/icon-files-2.10.0.tgz -> npmpkg-@charcoal-ui-icon-files-2.10.0.tgz
https://registry.npmjs.org/@charcoal-ui/icons/-/icons-2.10.0.tgz -> npmpkg-@charcoal-ui-icons-2.10.0.tgz
https://registry.npmjs.org/@charcoal-ui/theme/-/theme-2.10.0.tgz -> npmpkg-@charcoal-ui-theme-2.10.0.tgz
https://registry.npmjs.org/@charcoal-ui/utils/-/utils-2.10.0.tgz -> npmpkg-@charcoal-ui-utils-2.10.0.tgz
https://registry.npmjs.org/@cspotcode/source-map-support/-/source-map-support-0.8.1.tgz -> npmpkg-@cspotcode-source-map-support-0.8.1.tgz
https://registry.npmjs.org/@ducanh2912/next-pwa/-/next-pwa-9.7.2.tgz -> npmpkg-@ducanh2912-next-pwa-9.7.2.tgz
https://registry.npmjs.org/@esbuild/android-arm/-/android-arm-0.19.8.tgz -> npmpkg-@esbuild-android-arm-0.19.8.tgz
https://registry.npmjs.org/@esbuild/android-arm64/-/android-arm64-0.19.8.tgz -> npmpkg-@esbuild-android-arm64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/android-x64/-/android-x64-0.19.8.tgz -> npmpkg-@esbuild-android-x64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/darwin-arm64/-/darwin-arm64-0.19.8.tgz -> npmpkg-@esbuild-darwin-arm64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/darwin-x64/-/darwin-x64-0.19.8.tgz -> npmpkg-@esbuild-darwin-x64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/freebsd-arm64/-/freebsd-arm64-0.19.8.tgz -> npmpkg-@esbuild-freebsd-arm64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/freebsd-x64/-/freebsd-x64-0.19.8.tgz -> npmpkg-@esbuild-freebsd-x64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/linux-arm/-/linux-arm-0.19.8.tgz -> npmpkg-@esbuild-linux-arm-0.19.8.tgz
https://registry.npmjs.org/@esbuild/linux-arm64/-/linux-arm64-0.19.8.tgz -> npmpkg-@esbuild-linux-arm64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/linux-ia32/-/linux-ia32-0.19.8.tgz -> npmpkg-@esbuild-linux-ia32-0.19.8.tgz
https://registry.npmjs.org/@esbuild/linux-loong64/-/linux-loong64-0.19.8.tgz -> npmpkg-@esbuild-linux-loong64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/linux-mips64el/-/linux-mips64el-0.19.8.tgz -> npmpkg-@esbuild-linux-mips64el-0.19.8.tgz
https://registry.npmjs.org/@esbuild/linux-ppc64/-/linux-ppc64-0.19.8.tgz -> npmpkg-@esbuild-linux-ppc64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/linux-riscv64/-/linux-riscv64-0.19.8.tgz -> npmpkg-@esbuild-linux-riscv64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/linux-s390x/-/linux-s390x-0.19.8.tgz -> npmpkg-@esbuild-linux-s390x-0.19.8.tgz
https://registry.npmjs.org/@esbuild/linux-x64/-/linux-x64-0.19.8.tgz -> npmpkg-@esbuild-linux-x64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/netbsd-x64/-/netbsd-x64-0.19.8.tgz -> npmpkg-@esbuild-netbsd-x64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/openbsd-x64/-/openbsd-x64-0.19.8.tgz -> npmpkg-@esbuild-openbsd-x64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/sunos-x64/-/sunos-x64-0.19.8.tgz -> npmpkg-@esbuild-sunos-x64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/win32-arm64/-/win32-arm64-0.19.8.tgz -> npmpkg-@esbuild-win32-arm64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/win32-ia32/-/win32-ia32-0.19.8.tgz -> npmpkg-@esbuild-win32-ia32-0.19.8.tgz
https://registry.npmjs.org/@esbuild/win32-x64/-/win32-x64-0.19.8.tgz -> npmpkg-@esbuild-win32-x64-0.19.8.tgz
https://registry.npmjs.org/@eslint-community/eslint-utils/-/eslint-utils-4.4.0.tgz -> npmpkg-@eslint-community-eslint-utils-4.4.0.tgz
https://registry.npmjs.org/@eslint-community/regexpp/-/regexpp-4.4.1.tgz -> npmpkg-@eslint-community-regexpp-4.4.1.tgz
https://registry.npmjs.org/@eslint/eslintrc/-/eslintrc-2.0.1.tgz -> npmpkg-@eslint-eslintrc-2.0.1.tgz
https://registry.npmjs.org/@eslint/js/-/js-8.36.0.tgz -> npmpkg-@eslint-js-8.36.0.tgz
https://registry.npmjs.org/@gltf-transform/core/-/core-2.5.1.tgz -> npmpkg-@gltf-transform-core-2.5.1.tgz
https://registry.npmjs.org/@gulpjs/to-absolute-glob/-/to-absolute-glob-4.0.0.tgz -> npmpkg-@gulpjs-to-absolute-glob-4.0.0.tgz
https://registry.npmjs.org/@headlessui/react/-/react-1.7.17.tgz -> npmpkg-@headlessui-react-1.7.17.tgz
https://registry.npmjs.org/@heroicons/react/-/react-2.0.18.tgz -> npmpkg-@heroicons-react-2.0.18.tgz
https://registry.npmjs.org/@humanwhocodes/config-array/-/config-array-0.11.8.tgz -> npmpkg-@humanwhocodes-config-array-0.11.8.tgz
https://registry.npmjs.org/@humanwhocodes/module-importer/-/module-importer-1.0.1.tgz -> npmpkg-@humanwhocodes-module-importer-1.0.1.tgz
https://registry.npmjs.org/@humanwhocodes/object-schema/-/object-schema-1.2.1.tgz -> npmpkg-@humanwhocodes-object-schema-1.2.1.tgz
https://registry.npmjs.org/@istanbuljs/load-nyc-config/-/load-nyc-config-1.1.0.tgz -> npmpkg-@istanbuljs-load-nyc-config-1.1.0.tgz
https://registry.npmjs.org/argparse/-/argparse-1.0.10.tgz -> npmpkg-argparse-1.0.10.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-3.14.1.tgz -> npmpkg-js-yaml-3.14.1.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-5.0.0.tgz -> npmpkg-resolve-from-5.0.0.tgz
https://registry.npmjs.org/@istanbuljs/schema/-/schema-0.1.3.tgz -> npmpkg-@istanbuljs-schema-0.1.3.tgz
https://registry.npmjs.org/@jest/console/-/console-29.7.0.tgz -> npmpkg-@jest-console-29.7.0.tgz
https://registry.npmjs.org/@jest/core/-/core-29.7.0.tgz -> npmpkg-@jest-core-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.2.0.tgz -> npmpkg-react-is-18.2.0.tgz
https://registry.npmjs.org/@jest/environment/-/environment-29.7.0.tgz -> npmpkg-@jest-environment-29.7.0.tgz
https://registry.npmjs.org/@jest/expect/-/expect-29.7.0.tgz -> npmpkg-@jest-expect-29.7.0.tgz
https://registry.npmjs.org/@jest/expect-utils/-/expect-utils-29.7.0.tgz -> npmpkg-@jest-expect-utils-29.7.0.tgz
https://registry.npmjs.org/@jest/fake-timers/-/fake-timers-29.7.0.tgz -> npmpkg-@jest-fake-timers-29.7.0.tgz
https://registry.npmjs.org/@jest/globals/-/globals-29.7.0.tgz -> npmpkg-@jest-globals-29.7.0.tgz
https://registry.npmjs.org/@jest/reporters/-/reporters-29.7.0.tgz -> npmpkg-@jest-reporters-29.7.0.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.20.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.20.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-29.7.0.tgz -> npmpkg-jest-worker-29.7.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-8.1.1.tgz -> npmpkg-supports-color-8.1.1.tgz
https://registry.npmjs.org/@jest/schemas/-/schemas-29.6.3.tgz -> npmpkg-@jest-schemas-29.6.3.tgz
https://registry.npmjs.org/@jest/source-map/-/source-map-29.6.3.tgz -> npmpkg-@jest-source-map-29.6.3.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.20.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.20.tgz
https://registry.npmjs.org/@jest/test-result/-/test-result-29.7.0.tgz -> npmpkg-@jest-test-result-29.7.0.tgz
https://registry.npmjs.org/@jest/test-sequencer/-/test-sequencer-29.7.0.tgz -> npmpkg-@jest-test-sequencer-29.7.0.tgz
https://registry.npmjs.org/@jest/transform/-/transform-29.7.0.tgz -> npmpkg-@jest-transform-29.7.0.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.20.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.20.tgz
https://registry.npmjs.org/@jest/types/-/types-29.6.3.tgz -> npmpkg-@jest-types-29.6.3.tgz
https://registry.npmjs.org/@jridgewell/gen-mapping/-/gen-mapping-0.3.3.tgz -> npmpkg-@jridgewell-gen-mapping-0.3.3.tgz
https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.1.tgz -> npmpkg-@jridgewell-resolve-uri-3.1.1.tgz
https://registry.npmjs.org/@jridgewell/set-array/-/set-array-1.1.2.tgz -> npmpkg-@jridgewell-set-array-1.1.2.tgz
https://registry.npmjs.org/@jridgewell/source-map/-/source-map-0.3.5.tgz -> npmpkg-@jridgewell-source-map-0.3.5.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.15.tgz -> npmpkg-@jridgewell-sourcemap-codec-1.4.15.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.9.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.9.tgz
https://registry.npmjs.org/@next/env/-/env-13.5.6.tgz -> npmpkg-@next-env-13.5.6.tgz
https://registry.npmjs.org/@next/eslint-plugin-next/-/eslint-plugin-next-13.2.4.tgz -> npmpkg-@next-eslint-plugin-next-13.2.4.tgz
https://registry.npmjs.org/@next/swc-darwin-arm64/-/swc-darwin-arm64-13.5.6.tgz -> npmpkg-@next-swc-darwin-arm64-13.5.6.tgz
https://registry.npmjs.org/@next/swc-darwin-x64/-/swc-darwin-x64-13.5.6.tgz -> npmpkg-@next-swc-darwin-x64-13.5.6.tgz
https://registry.npmjs.org/@next/swc-linux-arm64-gnu/-/swc-linux-arm64-gnu-13.5.6.tgz -> npmpkg-@next-swc-linux-arm64-gnu-13.5.6.tgz
https://registry.npmjs.org/@next/swc-linux-arm64-musl/-/swc-linux-arm64-musl-13.5.6.tgz -> npmpkg-@next-swc-linux-arm64-musl-13.5.6.tgz
https://registry.npmjs.org/@next/swc-linux-x64-gnu/-/swc-linux-x64-gnu-13.5.6.tgz -> npmpkg-@next-swc-linux-x64-gnu-13.5.6.tgz
https://registry.npmjs.org/@next/swc-linux-x64-musl/-/swc-linux-x64-musl-13.5.6.tgz -> npmpkg-@next-swc-linux-x64-musl-13.5.6.tgz
https://registry.npmjs.org/@next/swc-win32-arm64-msvc/-/swc-win32-arm64-msvc-13.5.6.tgz -> npmpkg-@next-swc-win32-arm64-msvc-13.5.6.tgz
https://registry.npmjs.org/@next/swc-win32-ia32-msvc/-/swc-win32-ia32-msvc-13.5.6.tgz -> npmpkg-@next-swc-win32-ia32-msvc-13.5.6.tgz
https://registry.npmjs.org/@next/swc-win32-x64-msvc/-/swc-win32-x64-msvc-13.5.6.tgz -> npmpkg-@next-swc-win32-x64-msvc-13.5.6.tgz
https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> npmpkg-@nodelib-fs.scandir-2.1.5.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> npmpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> npmpkg-@nodelib-fs.walk-1.2.8.tgz
https://registry.npmjs.org/@pixiv/three-vrm/-/three-vrm-2.0.7.tgz -> npmpkg-@pixiv-three-vrm-2.0.7.tgz
https://registry.npmjs.org/@pixiv/three-vrm-springbone/-/three-vrm-springbone-2.0.7.tgz -> npmpkg-@pixiv-three-vrm-springbone-2.0.7.tgz
https://registry.npmjs.org/@pixiv/three-vrm-core/-/three-vrm-core-2.0.7.tgz -> npmpkg-@pixiv-three-vrm-core-2.0.7.tgz
https://registry.npmjs.org/@pixiv/three-vrm-materials-hdr-emissive-multiplier/-/three-vrm-materials-hdr-emissive-multiplier-2.0.7.tgz -> npmpkg-@pixiv-three-vrm-materials-hdr-emissive-multiplier-2.0.7.tgz
https://registry.npmjs.org/@pixiv/three-vrm-materials-mtoon/-/three-vrm-materials-mtoon-2.0.7.tgz -> npmpkg-@pixiv-three-vrm-materials-mtoon-2.0.7.tgz
https://registry.npmjs.org/@pixiv/three-vrm-materials-v0compat/-/three-vrm-materials-v0compat-2.0.7.tgz -> npmpkg-@pixiv-three-vrm-materials-v0compat-2.0.7.tgz
https://registry.npmjs.org/@pixiv/three-vrm-node-constraint/-/three-vrm-node-constraint-2.0.7.tgz -> npmpkg-@pixiv-three-vrm-node-constraint-2.0.7.tgz
https://registry.npmjs.org/@pixiv/types-vrm-0.0/-/types-vrm-0.0-2.0.7.tgz -> npmpkg-@pixiv-types-vrm-0.0-2.0.7.tgz
https://registry.npmjs.org/@pixiv/types-vrmc-materials-hdr-emissive-multiplier-1.0/-/types-vrmc-materials-hdr-emissive-multiplier-1.0-2.0.7.tgz -> npmpkg-@pixiv-types-vrmc-materials-hdr-emissive-multiplier-1.0-2.0.7.tgz
https://registry.npmjs.org/@pixiv/types-vrmc-materials-mtoon-1.0/-/types-vrmc-materials-mtoon-1.0-2.0.7.tgz -> npmpkg-@pixiv-types-vrmc-materials-mtoon-1.0-2.0.7.tgz
https://registry.npmjs.org/@pixiv/types-vrmc-node-constraint-1.0/-/types-vrmc-node-constraint-1.0-2.0.7.tgz -> npmpkg-@pixiv-types-vrmc-node-constraint-1.0-2.0.7.tgz
https://registry.npmjs.org/@pixiv/types-vrmc-springbone-1.0/-/types-vrmc-springbone-1.0-2.0.7.tgz -> npmpkg-@pixiv-types-vrmc-springbone-1.0-2.0.7.tgz
https://registry.npmjs.org/@pixiv/types-vrmc-vrm-1.0/-/types-vrmc-vrm-1.0-2.0.7.tgz -> npmpkg-@pixiv-types-vrmc-vrm-1.0-2.0.7.tgz
https://registry.npmjs.org/@pkgr/utils/-/utils-2.3.1.tgz -> npmpkg-@pkgr-utils-2.3.1.tgz
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
https://registry.npmjs.org/@ricky0123/vad-react/-/vad-react-0.0.17.tgz -> npmpkg-@ricky0123-vad-react-0.0.17.tgz
https://registry.npmjs.org/@ricky0123/vad-web/-/vad-web-0.0.12.tgz -> npmpkg-@ricky0123-vad-web-0.0.12.tgz
https://registry.npmjs.org/@rollup/plugin-babel/-/plugin-babel-5.3.1.tgz -> npmpkg-@rollup-plugin-babel-5.3.1.tgz
https://registry.npmjs.org/@rollup/plugin-node-resolve/-/plugin-node-resolve-11.2.1.tgz -> npmpkg-@rollup-plugin-node-resolve-11.2.1.tgz
https://registry.npmjs.org/@rollup/plugin-replace/-/plugin-replace-2.4.2.tgz -> npmpkg-@rollup-plugin-replace-2.4.2.tgz
https://registry.npmjs.org/@rollup/pluginutils/-/pluginutils-3.1.0.tgz -> npmpkg-@rollup-pluginutils-3.1.0.tgz
https://registry.npmjs.org/@types/estree/-/estree-0.0.39.tgz -> npmpkg-@types-estree-0.0.39.tgz
https://registry.npmjs.org/@rushstack/eslint-patch/-/eslint-patch-1.2.0.tgz -> npmpkg-@rushstack-eslint-patch-1.2.0.tgz
https://registry.npmjs.org/@sinclair/typebox/-/typebox-0.27.8.tgz -> npmpkg-@sinclair-typebox-0.27.8.tgz
https://registry.npmjs.org/@sinonjs/commons/-/commons-3.0.0.tgz -> npmpkg-@sinonjs-commons-3.0.0.tgz
https://registry.npmjs.org/@sinonjs/fake-timers/-/fake-timers-10.3.0.tgz -> npmpkg-@sinonjs-fake-timers-10.3.0.tgz
https://registry.npmjs.org/@supabase/functions-js/-/functions-js-2.1.5.tgz -> npmpkg-@supabase-functions-js-2.1.5.tgz
https://registry.npmjs.org/@supabase/gotrue-js/-/gotrue-js-2.57.1.tgz -> npmpkg-@supabase-gotrue-js-2.57.1.tgz
https://registry.npmjs.org/@supabase/node-fetch/-/node-fetch-2.6.15.tgz -> npmpkg-@supabase-node-fetch-2.6.15.tgz
https://registry.npmjs.org/tr46/-/tr46-0.0.3.tgz -> npmpkg-tr46-0.0.3.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-3.0.1.tgz -> npmpkg-webidl-conversions-3.0.1.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-5.0.0.tgz -> npmpkg-whatwg-url-5.0.0.tgz
https://registry.npmjs.org/@supabase/postgrest-js/-/postgrest-js-1.9.0.tgz -> npmpkg-@supabase-postgrest-js-1.9.0.tgz
https://registry.npmjs.org/@supabase/realtime-js/-/realtime-js-2.8.4.tgz -> npmpkg-@supabase-realtime-js-2.8.4.tgz
https://registry.npmjs.org/@supabase/storage-js/-/storage-js-2.5.5.tgz -> npmpkg-@supabase-storage-js-2.5.5.tgz
https://registry.npmjs.org/@supabase/supabase-js/-/supabase-js-2.39.0.tgz -> npmpkg-@supabase-supabase-js-2.39.0.tgz
https://registry.npmjs.org/@surma/rollup-plugin-off-main-thread/-/rollup-plugin-off-main-thread-2.2.3.tgz -> npmpkg-@surma-rollup-plugin-off-main-thread-2.2.3.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/@swc/helpers/-/helpers-0.5.2.tgz -> npmpkg-@swc-helpers-0.5.2.tgz
https://registry.npmjs.org/@tabler/icons/-/icons-3.11.0.tgz -> npmpkg-@tabler-icons-3.11.0.tgz
https://registry.npmjs.org/@tabler/icons-react/-/icons-react-3.11.0.tgz -> npmpkg-@tabler-icons-react-3.11.0.tgz
https://registry.npmjs.org/@tailwindcss/forms/-/forms-0.5.6.tgz -> npmpkg-@tailwindcss-forms-0.5.6.tgz
https://registry.npmjs.org/@tailwindcss/line-clamp/-/line-clamp-0.4.4.tgz -> npmpkg-@tailwindcss-line-clamp-0.4.4.tgz
https://registry.npmjs.org/@tauri-apps/api/-/api-1.5.3.tgz -> npmpkg-@tauri-apps-api-1.5.3.tgz
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
https://registry.npmjs.org/@testing-library/dom/-/dom-9.3.3.tgz -> npmpkg-@testing-library-dom-9.3.3.tgz
https://registry.npmjs.org/@testing-library/jest-dom/-/jest-dom-6.1.4.tgz -> npmpkg-@testing-library-jest-dom-6.1.4.tgz
https://registry.npmjs.org/chalk/-/chalk-3.0.0.tgz -> npmpkg-chalk-3.0.0.tgz
https://registry.npmjs.org/@testing-library/react/-/react-14.1.2.tgz -> npmpkg-@testing-library-react-14.1.2.tgz
https://registry.npmjs.org/@tootallnate/once/-/once-2.0.0.tgz -> npmpkg-@tootallnate-once-2.0.0.tgz
https://registry.npmjs.org/@tsconfig/node10/-/node10-1.0.9.tgz -> npmpkg-@tsconfig-node10-1.0.9.tgz
https://registry.npmjs.org/@tsconfig/node12/-/node12-1.0.11.tgz -> npmpkg-@tsconfig-node12-1.0.11.tgz
https://registry.npmjs.org/@tsconfig/node14/-/node14-1.0.3.tgz -> npmpkg-@tsconfig-node14-1.0.3.tgz
https://registry.npmjs.org/@tsconfig/node16/-/node16-1.0.4.tgz -> npmpkg-@tsconfig-node16-1.0.4.tgz
https://registry.npmjs.org/@tweenjs/tween.js/-/tween.js-18.6.4.tgz -> npmpkg-@tweenjs-tween.js-18.6.4.tgz
https://registry.npmjs.org/@types/aria-query/-/aria-query-5.0.4.tgz -> npmpkg-@types-aria-query-5.0.4.tgz
https://registry.npmjs.org/@types/babel__core/-/babel__core-7.20.5.tgz -> npmpkg-@types-babel__core-7.20.5.tgz
https://registry.npmjs.org/@types/babel__generator/-/babel__generator-7.6.7.tgz -> npmpkg-@types-babel__generator-7.6.7.tgz
https://registry.npmjs.org/@types/babel__template/-/babel__template-7.4.4.tgz -> npmpkg-@types-babel__template-7.4.4.tgz
https://registry.npmjs.org/@types/babel__traverse/-/babel__traverse-7.20.4.tgz -> npmpkg-@types-babel__traverse-7.20.4.tgz
https://registry.npmjs.org/@types/dom-speech-recognition/-/dom-speech-recognition-0.0.1.tgz -> npmpkg-@types-dom-speech-recognition-0.0.1.tgz
https://registry.npmjs.org/@types/eslint/-/eslint-8.44.6.tgz -> npmpkg-@types-eslint-8.44.6.tgz
https://registry.npmjs.org/@types/eslint-scope/-/eslint-scope-3.7.6.tgz -> npmpkg-@types-eslint-scope-3.7.6.tgz
https://registry.npmjs.org/@types/estree/-/estree-1.0.4.tgz -> npmpkg-@types-estree-1.0.4.tgz
https://registry.npmjs.org/@types/file-saver/-/file-saver-2.0.7.tgz -> npmpkg-@types-file-saver-2.0.7.tgz
https://registry.npmjs.org/@types/glob/-/glob-7.2.0.tgz -> npmpkg-@types-glob-7.2.0.tgz
https://registry.npmjs.org/@types/graceful-fs/-/graceful-fs-4.1.9.tgz -> npmpkg-@types-graceful-fs-4.1.9.tgz
https://registry.npmjs.org/@types/istanbul-lib-coverage/-/istanbul-lib-coverage-2.0.6.tgz -> npmpkg-@types-istanbul-lib-coverage-2.0.6.tgz
https://registry.npmjs.org/@types/istanbul-lib-report/-/istanbul-lib-report-3.0.3.tgz -> npmpkg-@types-istanbul-lib-report-3.0.3.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/jsdom/-/jsdom-20.0.1.tgz -> npmpkg-@types-jsdom-20.0.1.tgz
https://registry.npmjs.org/@types/json-schema/-/json-schema-7.0.14.tgz -> npmpkg-@types-json-schema-7.0.14.tgz
https://registry.npmjs.org/@types/json5/-/json5-0.0.29.tgz -> npmpkg-@types-json5-0.0.29.tgz
https://registry.npmjs.org/@types/long/-/long-4.0.2.tgz -> npmpkg-@types-long-4.0.2.tgz
https://registry.npmjs.org/@types/minimatch/-/minimatch-5.1.2.tgz -> npmpkg-@types-minimatch-5.1.2.tgz
https://registry.npmjs.org/@types/node/-/node-18.15.10.tgz -> npmpkg-@types-node-18.15.10.tgz
https://registry.npmjs.org/@types/phoenix/-/phoenix-1.6.4.tgz -> npmpkg-@types-phoenix-1.6.4.tgz
https://registry.npmjs.org/@types/prop-types/-/prop-types-15.7.5.tgz -> npmpkg-@types-prop-types-15.7.5.tgz
https://registry.npmjs.org/@types/react/-/react-18.0.29.tgz -> npmpkg-@types-react-18.0.29.tgz
https://registry.npmjs.org/@types/react-dom/-/react-dom-18.0.11.tgz -> npmpkg-@types-react-dom-18.0.11.tgz
https://registry.npmjs.org/@types/resolve/-/resolve-1.17.1.tgz -> npmpkg-@types-resolve-1.17.1.tgz
https://registry.npmjs.org/@types/scheduler/-/scheduler-0.16.3.tgz -> npmpkg-@types-scheduler-0.16.3.tgz
https://registry.npmjs.org/@types/stack-utils/-/stack-utils-2.0.3.tgz -> npmpkg-@types-stack-utils-2.0.3.tgz
https://registry.npmjs.org/@types/stats.js/-/stats.js-0.17.3.tgz -> npmpkg-@types-stats.js-0.17.3.tgz
https://registry.npmjs.org/@types/symlink-or-copy/-/symlink-or-copy-1.2.2.tgz -> npmpkg-@types-symlink-or-copy-1.2.2.tgz
https://registry.npmjs.org/@types/three/-/three-0.154.0.tgz -> npmpkg-@types-three-0.154.0.tgz
https://registry.npmjs.org/@types/tough-cookie/-/tough-cookie-4.0.5.tgz -> npmpkg-@types-tough-cookie-4.0.5.tgz
https://registry.npmjs.org/@types/trusted-types/-/trusted-types-2.0.5.tgz -> npmpkg-@types-trusted-types-2.0.5.tgz
https://registry.npmjs.org/@types/websocket/-/websocket-1.0.10.tgz -> npmpkg-@types-websocket-1.0.10.tgz
https://registry.npmjs.org/@types/webxr/-/webxr-0.5.10.tgz -> npmpkg-@types-webxr-0.5.10.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-17.0.32.tgz -> npmpkg-@types-yargs-17.0.32.tgz
https://registry.npmjs.org/@types/yargs-parser/-/yargs-parser-21.0.3.tgz -> npmpkg-@types-yargs-parser-21.0.3.tgz
https://registry.npmjs.org/@typescript-eslint/parser/-/parser-5.56.0.tgz -> npmpkg-@typescript-eslint-parser-5.56.0.tgz
https://registry.npmjs.org/@typescript-eslint/scope-manager/-/scope-manager-5.56.0.tgz -> npmpkg-@typescript-eslint-scope-manager-5.56.0.tgz
https://registry.npmjs.org/@typescript-eslint/types/-/types-5.56.0.tgz -> npmpkg-@typescript-eslint-types-5.56.0.tgz
https://registry.npmjs.org/@typescript-eslint/typescript-estree/-/typescript-estree-5.56.0.tgz -> npmpkg-@typescript-eslint-typescript-estree-5.56.0.tgz
https://registry.npmjs.org/@typescript-eslint/visitor-keys/-/visitor-keys-5.56.0.tgz -> npmpkg-@typescript-eslint-visitor-keys-5.56.0.tgz
https://registry.npmjs.org/@webassemblyjs/ast/-/ast-1.11.6.tgz -> npmpkg-@webassemblyjs-ast-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/floating-point-hex-parser/-/floating-point-hex-parser-1.11.6.tgz -> npmpkg-@webassemblyjs-floating-point-hex-parser-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/helper-api-error/-/helper-api-error-1.11.6.tgz -> npmpkg-@webassemblyjs-helper-api-error-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/helper-buffer/-/helper-buffer-1.11.6.tgz -> npmpkg-@webassemblyjs-helper-buffer-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/helper-numbers/-/helper-numbers-1.11.6.tgz -> npmpkg-@webassemblyjs-helper-numbers-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/helper-wasm-bytecode/-/helper-wasm-bytecode-1.11.6.tgz -> npmpkg-@webassemblyjs-helper-wasm-bytecode-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/helper-wasm-section/-/helper-wasm-section-1.11.6.tgz -> npmpkg-@webassemblyjs-helper-wasm-section-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/ieee754/-/ieee754-1.11.6.tgz -> npmpkg-@webassemblyjs-ieee754-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/leb128/-/leb128-1.11.6.tgz -> npmpkg-@webassemblyjs-leb128-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/utf8/-/utf8-1.11.6.tgz -> npmpkg-@webassemblyjs-utf8-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-edit/-/wasm-edit-1.11.6.tgz -> npmpkg-@webassemblyjs-wasm-edit-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-gen/-/wasm-gen-1.11.6.tgz -> npmpkg-@webassemblyjs-wasm-gen-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-opt/-/wasm-opt-1.11.6.tgz -> npmpkg-@webassemblyjs-wasm-opt-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-parser/-/wasm-parser-1.11.6.tgz -> npmpkg-@webassemblyjs-wasm-parser-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/wast-printer/-/wast-printer-1.11.6.tgz -> npmpkg-@webassemblyjs-wast-printer-1.11.6.tgz
https://registry.npmjs.org/@xenova/transformers/-/transformers-2.7.0.tgz -> npmpkg-@xenova-transformers-2.7.0.tgz
https://registry.npmjs.org/@xtuc/ieee754/-/ieee754-1.2.0.tgz -> npmpkg-@xtuc-ieee754-1.2.0.tgz
https://registry.npmjs.org/@xtuc/long/-/long-4.2.2.tgz -> npmpkg-@xtuc-long-4.2.2.tgz
https://registry.npmjs.org/abab/-/abab-2.0.6.tgz -> npmpkg-abab-2.0.6.tgz
https://registry.npmjs.org/acorn/-/acorn-8.8.2.tgz -> npmpkg-acorn-8.8.2.tgz
https://registry.npmjs.org/acorn-globals/-/acorn-globals-7.0.1.tgz -> npmpkg-acorn-globals-7.0.1.tgz
https://registry.npmjs.org/acorn-import-assertions/-/acorn-import-assertions-1.9.0.tgz -> npmpkg-acorn-import-assertions-1.9.0.tgz
https://registry.npmjs.org/acorn-jsx/-/acorn-jsx-5.3.2.tgz -> npmpkg-acorn-jsx-5.3.2.tgz
https://registry.npmjs.org/acorn-walk/-/acorn-walk-8.3.0.tgz -> npmpkg-acorn-walk-8.3.0.tgz
https://registry.npmjs.org/agent-base/-/agent-base-6.0.2.tgz -> npmpkg-agent-base-6.0.2.tgz
https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz -> npmpkg-ajv-6.12.6.tgz
https://registry.npmjs.org/ajv-formats/-/ajv-formats-2.1.1.tgz -> npmpkg-ajv-formats-2.1.1.tgz
https://registry.npmjs.org/ajv/-/ajv-8.12.0.tgz -> npmpkg-ajv-8.12.0.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> npmpkg-json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-3.5.2.tgz -> npmpkg-ajv-keywords-3.5.2.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-4.3.2.tgz -> npmpkg-ansi-escapes-4.3.2.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.21.3.tgz -> npmpkg-type-fest-0.21.3.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/any-promise/-/any-promise-1.3.0.tgz -> npmpkg-any-promise-1.3.0.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz -> npmpkg-anymatch-3.1.3.tgz
https://registry.npmjs.org/arg/-/arg-5.0.2.tgz -> npmpkg-arg-5.0.2.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz -> npmpkg-argparse-2.0.1.tgz
https://registry.npmjs.org/aria-query/-/aria-query-5.1.3.tgz -> npmpkg-aria-query-5.1.3.tgz
https://registry.npmjs.org/array-buffer-byte-length/-/array-buffer-byte-length-1.0.0.tgz -> npmpkg-array-buffer-byte-length-1.0.0.tgz
https://registry.npmjs.org/array-includes/-/array-includes-3.1.6.tgz -> npmpkg-array-includes-3.1.6.tgz
https://registry.npmjs.org/array-union/-/array-union-2.1.0.tgz -> npmpkg-array-union-2.1.0.tgz
https://registry.npmjs.org/array-uniq/-/array-uniq-1.0.3.tgz -> npmpkg-array-uniq-1.0.3.tgz
https://registry.npmjs.org/array.prototype.flat/-/array.prototype.flat-1.3.1.tgz -> npmpkg-array.prototype.flat-1.3.1.tgz
https://registry.npmjs.org/array.prototype.flatmap/-/array.prototype.flatmap-1.3.1.tgz -> npmpkg-array.prototype.flatmap-1.3.1.tgz
https://registry.npmjs.org/array.prototype.tosorted/-/array.prototype.tosorted-1.1.1.tgz -> npmpkg-array.prototype.tosorted-1.1.1.tgz
https://registry.npmjs.org/ast-types-flow/-/ast-types-flow-0.0.7.tgz -> npmpkg-ast-types-flow-0.0.7.tgz
https://registry.npmjs.org/async/-/async-3.2.5.tgz -> npmpkg-async-3.2.5.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz -> npmpkg-asynckit-0.4.0.tgz
https://registry.npmjs.org/at-least-node/-/at-least-node-1.0.0.tgz -> npmpkg-at-least-node-1.0.0.tgz
https://registry.npmjs.org/autoprefixer/-/autoprefixer-10.4.14.tgz -> npmpkg-autoprefixer-10.4.14.tgz
https://registry.npmjs.org/available-typed-arrays/-/available-typed-arrays-1.0.5.tgz -> npmpkg-available-typed-arrays-1.0.5.tgz
https://registry.npmjs.org/axe-core/-/axe-core-4.6.3.tgz -> npmpkg-axe-core-4.6.3.tgz
https://registry.npmjs.org/axobject-query/-/axobject-query-3.1.1.tgz -> npmpkg-axobject-query-3.1.1.tgz
https://registry.npmjs.org/b4a/-/b4a-1.6.4.tgz -> npmpkg-b4a-1.6.4.tgz
https://registry.npmjs.org/babel-jest/-/babel-jest-29.7.0.tgz -> npmpkg-babel-jest-29.7.0.tgz
https://registry.npmjs.org/babel-plugin-istanbul/-/babel-plugin-istanbul-6.1.1.tgz -> npmpkg-babel-plugin-istanbul-6.1.1.tgz
https://registry.npmjs.org/istanbul-lib-instrument/-/istanbul-lib-instrument-5.2.1.tgz -> npmpkg-istanbul-lib-instrument-5.2.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/babel-plugin-jest-hoist/-/babel-plugin-jest-hoist-29.6.3.tgz -> npmpkg-babel-plugin-jest-hoist-29.6.3.tgz
https://registry.npmjs.org/babel-plugin-polyfill-corejs2/-/babel-plugin-polyfill-corejs2-0.4.6.tgz -> npmpkg-babel-plugin-polyfill-corejs2-0.4.6.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/babel-plugin-polyfill-corejs3/-/babel-plugin-polyfill-corejs3-0.8.6.tgz -> npmpkg-babel-plugin-polyfill-corejs3-0.8.6.tgz
https://registry.npmjs.org/babel-plugin-polyfill-regenerator/-/babel-plugin-polyfill-regenerator-0.5.3.tgz -> npmpkg-babel-plugin-polyfill-regenerator-0.5.3.tgz
https://registry.npmjs.org/babel-preset-current-node-syntax/-/babel-preset-current-node-syntax-1.0.1.tgz -> npmpkg-babel-preset-current-node-syntax-1.0.1.tgz
https://registry.npmjs.org/babel-preset-jest/-/babel-preset-jest-29.6.3.tgz -> npmpkg-babel-preset-jest-29.6.3.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz -> npmpkg-balanced-match-1.0.2.tgz
https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz -> npmpkg-base64-js-1.5.1.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.2.0.tgz -> npmpkg-binary-extensions-2.2.0.tgz
https://registry.npmjs.org/bl/-/bl-4.1.0.tgz -> npmpkg-bl-4.1.0.tgz
https://registry.npmjs.org/boolbase/-/boolbase-1.0.0.tgz -> npmpkg-boolbase-1.0.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/braces/-/braces-3.0.2.tgz -> npmpkg-braces-3.0.2.tgz
https://registry.npmjs.org/broccoli-node-api/-/broccoli-node-api-1.7.0.tgz -> npmpkg-broccoli-node-api-1.7.0.tgz
https://registry.npmjs.org/broccoli-node-info/-/broccoli-node-info-2.2.0.tgz -> npmpkg-broccoli-node-info-2.2.0.tgz
https://registry.npmjs.org/broccoli-output-wrapper/-/broccoli-output-wrapper-3.2.5.tgz -> npmpkg-broccoli-output-wrapper-3.2.5.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz -> npmpkg-universalify-0.1.2.tgz
https://registry.npmjs.org/broccoli-plugin/-/broccoli-plugin-4.0.7.tgz -> npmpkg-broccoli-plugin-4.0.7.tgz
https://registry.npmjs.org/browserslist/-/browserslist-4.22.1.tgz -> npmpkg-browserslist-4.22.1.tgz
https://registry.npmjs.org/bser/-/bser-2.1.1.tgz -> npmpkg-bser-2.1.1.tgz
https://registry.npmjs.org/buffer/-/buffer-5.7.1.tgz -> npmpkg-buffer-5.7.1.tgz
https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.2.tgz -> npmpkg-buffer-from-1.1.2.tgz
https://registry.npmjs.org/bufferutil/-/bufferutil-4.0.8.tgz -> npmpkg-bufferutil-4.0.8.tgz
https://registry.npmjs.org/builtin-modules/-/builtin-modules-3.3.0.tgz -> npmpkg-builtin-modules-3.3.0.tgz
https://registry.npmjs.org/busboy/-/busboy-1.6.0.tgz -> npmpkg-busboy-1.6.0.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.2.tgz -> npmpkg-call-bind-1.0.2.tgz
https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz -> npmpkg-callsites-3.1.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/camelcase-css/-/camelcase-css-2.0.1.tgz -> npmpkg-camelcase-css-2.0.1.tgz
https://registry.npmjs.org/caniuse-lite/-/caniuse-lite-1.0.30001561.tgz -> npmpkg-caniuse-lite-1.0.30001561.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/char-regex/-/char-regex-1.0.2.tgz -> npmpkg-char-regex-1.0.2.tgz
https://registry.npmjs.org/cheerio/-/cheerio-1.0.0-rc.12.tgz -> npmpkg-cheerio-1.0.0-rc.12.tgz
https://registry.npmjs.org/cheerio-select/-/cheerio-select-2.1.0.tgz -> npmpkg-cheerio-select-2.1.0.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.5.3.tgz -> npmpkg-chokidar-3.5.3.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/chownr/-/chownr-1.1.4.tgz -> npmpkg-chownr-1.1.4.tgz
https://registry.npmjs.org/chrome-trace-event/-/chrome-trace-event-1.0.3.tgz -> npmpkg-chrome-trace-event-1.0.3.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/cjs-module-lexer/-/cjs-module-lexer-1.2.3.tgz -> npmpkg-cjs-module-lexer-1.2.3.tgz
https://registry.npmjs.org/clean-webpack-plugin/-/clean-webpack-plugin-4.0.0.tgz -> npmpkg-clean-webpack-plugin-4.0.0.tgz
https://registry.npmjs.org/client-only/-/client-only-0.0.1.tgz -> npmpkg-client-only-0.0.1.tgz
https://registry.npmjs.org/cliui/-/cliui-8.0.1.tgz -> npmpkg-cliui-8.0.1.tgz
https://registry.npmjs.org/clone/-/clone-2.1.2.tgz -> npmpkg-clone-2.1.2.tgz
https://registry.npmjs.org/clone-stats/-/clone-stats-1.0.0.tgz -> npmpkg-clone-stats-1.0.0.tgz
https://registry.npmjs.org/clsx/-/clsx-2.0.0.tgz -> npmpkg-clsx-2.0.0.tgz
https://registry.npmjs.org/co/-/co-4.6.0.tgz -> npmpkg-co-4.6.0.tgz
https://registry.npmjs.org/collect-v8-coverage/-/collect-v8-coverage-1.0.2.tgz -> npmpkg-collect-v8-coverage-1.0.2.tgz
https://registry.npmjs.org/color/-/color-4.2.3.tgz -> npmpkg-color-4.2.3.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/color-string/-/color-string-1.9.1.tgz -> npmpkg-color-string-1.9.1.tgz
https://registry.npmjs.org/colors/-/colors-1.4.0.tgz -> npmpkg-colors-1.4.0.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz -> npmpkg-combined-stream-1.0.8.tgz
https://registry.npmjs.org/commander/-/commander-4.1.1.tgz -> npmpkg-commander-4.1.1.tgz
https://registry.npmjs.org/common-tags/-/common-tags-1.8.2.tgz -> npmpkg-common-tags-1.8.2.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-2.0.0.tgz -> npmpkg-convert-source-map-2.0.0.tgz
https://registry.npmjs.org/copy-webpack-plugin/-/copy-webpack-plugin-11.0.0.tgz -> npmpkg-copy-webpack-plugin-11.0.0.tgz
https://registry.npmjs.org/ajv/-/ajv-8.12.0.tgz -> npmpkg-ajv-8.12.0.tgz
https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-5.1.0.tgz -> npmpkg-ajv-keywords-5.1.0.tgz
https://registry.npmjs.org/globby/-/globby-13.2.2.tgz -> npmpkg-globby-13.2.2.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> npmpkg-json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-4.2.0.tgz -> npmpkg-schema-utils-4.2.0.tgz
https://registry.npmjs.org/slash/-/slash-4.0.0.tgz -> npmpkg-slash-4.0.0.tgz
https://registry.npmjs.org/core-js-compat/-/core-js-compat-3.33.2.tgz -> npmpkg-core-js-compat-3.33.2.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.3.tgz -> npmpkg-core-util-is-1.0.3.tgz
https://registry.npmjs.org/create-jest/-/create-jest-29.7.0.tgz -> npmpkg-create-jest-29.7.0.tgz
https://registry.npmjs.org/create-require/-/create-require-1.1.1.tgz -> npmpkg-create-require-1.1.1.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/crypto-random-string/-/crypto-random-string-2.0.0.tgz -> npmpkg-crypto-random-string-2.0.0.tgz
https://registry.npmjs.org/css-select/-/css-select-5.1.0.tgz -> npmpkg-css-select-5.1.0.tgz
https://registry.npmjs.org/css-what/-/css-what-6.1.0.tgz -> npmpkg-css-what-6.1.0.tgz
https://registry.npmjs.org/css.escape/-/css.escape-1.5.1.tgz -> npmpkg-css.escape-1.5.1.tgz
https://registry.npmjs.org/cssesc/-/cssesc-3.0.0.tgz -> npmpkg-cssesc-3.0.0.tgz
https://registry.npmjs.org/cssom/-/cssom-0.5.0.tgz -> npmpkg-cssom-0.5.0.tgz
https://registry.npmjs.org/cssstyle/-/cssstyle-2.3.0.tgz -> npmpkg-cssstyle-2.3.0.tgz
https://registry.npmjs.org/cssom/-/cssom-0.3.8.tgz -> npmpkg-cssom-0.3.8.tgz
https://registry.npmjs.org/csstype/-/csstype-3.1.2.tgz -> npmpkg-csstype-3.1.2.tgz
https://registry.npmjs.org/d/-/d-1.0.1.tgz -> npmpkg-d-1.0.1.tgz
https://registry.npmjs.org/damerau-levenshtein/-/damerau-levenshtein-1.0.8.tgz -> npmpkg-damerau-levenshtein-1.0.8.tgz
https://registry.npmjs.org/data-urls/-/data-urls-3.0.2.tgz -> npmpkg-data-urls-3.0.2.tgz
https://registry.npmjs.org/tr46/-/tr46-3.0.0.tgz -> npmpkg-tr46-3.0.0.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-7.0.0.tgz -> npmpkg-webidl-conversions-7.0.0.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-11.0.0.tgz -> npmpkg-whatwg-url-11.0.0.tgz
https://registry.npmjs.org/de-indent/-/de-indent-1.0.2.tgz -> npmpkg-de-indent-1.0.2.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/decimal.js/-/decimal.js-10.4.3.tgz -> npmpkg-decimal.js-10.4.3.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-6.0.0.tgz -> npmpkg-decompress-response-6.0.0.tgz
https://registry.npmjs.org/dedent/-/dedent-1.5.1.tgz -> npmpkg-dedent-1.5.1.tgz
https://registry.npmjs.org/deep-equal/-/deep-equal-2.2.0.tgz -> npmpkg-deep-equal-2.2.0.tgz
https://registry.npmjs.org/deep-extend/-/deep-extend-0.6.0.tgz -> npmpkg-deep-extend-0.6.0.tgz
https://registry.npmjs.org/deep-is/-/deep-is-0.1.4.tgz -> npmpkg-deep-is-0.1.4.tgz
https://registry.npmjs.org/deepmerge/-/deepmerge-4.3.1.tgz -> npmpkg-deepmerge-4.3.1.tgz
https://registry.npmjs.org/define-lazy-prop/-/define-lazy-prop-2.0.0.tgz -> npmpkg-define-lazy-prop-2.0.0.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.2.0.tgz -> npmpkg-define-properties-1.2.0.tgz
https://registry.npmjs.org/del/-/del-4.1.1.tgz -> npmpkg-del-4.1.1.tgz
https://registry.npmjs.org/array-union/-/array-union-1.0.2.tgz -> npmpkg-array-union-1.0.2.tgz
https://registry.npmjs.org/globby/-/globby-6.1.0.tgz -> npmpkg-globby-6.1.0.tgz
https://registry.npmjs.org/pify/-/pify-2.3.0.tgz -> npmpkg-pify-2.3.0.tgz
https://registry.npmjs.org/pify/-/pify-4.0.1.tgz -> npmpkg-pify-4.0.1.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.7.1.tgz -> npmpkg-rimraf-2.7.1.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz -> npmpkg-delayed-stream-1.0.0.tgz
https://registry.npmjs.org/detect-libc/-/detect-libc-2.0.2.tgz -> npmpkg-detect-libc-2.0.2.tgz
https://registry.npmjs.org/detect-newline/-/detect-newline-3.1.0.tgz -> npmpkg-detect-newline-3.1.0.tgz
https://registry.npmjs.org/dexie/-/dexie-4.0.4.tgz -> npmpkg-dexie-4.0.4.tgz
https://registry.npmjs.org/dexie-react-hooks/-/dexie-react-hooks-1.1.7.tgz -> npmpkg-dexie-react-hooks-1.1.7.tgz
https://registry.npmjs.org/didyoumean/-/didyoumean-1.2.2.tgz -> npmpkg-didyoumean-1.2.2.tgz
https://registry.npmjs.org/diff/-/diff-4.0.2.tgz -> npmpkg-diff-4.0.2.tgz
https://registry.npmjs.org/diff-sequences/-/diff-sequences-29.6.3.tgz -> npmpkg-diff-sequences-29.6.3.tgz
https://registry.npmjs.org/dir-glob/-/dir-glob-3.0.1.tgz -> npmpkg-dir-glob-3.0.1.tgz
https://registry.npmjs.org/dlv/-/dlv-1.1.3.tgz -> npmpkg-dlv-1.1.3.tgz
https://registry.npmjs.org/doctrine/-/doctrine-3.0.0.tgz -> npmpkg-doctrine-3.0.0.tgz
https://registry.npmjs.org/dom-accessibility-api/-/dom-accessibility-api-0.5.16.tgz -> npmpkg-dom-accessibility-api-0.5.16.tgz
https://registry.npmjs.org/dom-serializer/-/dom-serializer-2.0.0.tgz -> npmpkg-dom-serializer-2.0.0.tgz
https://registry.npmjs.org/domelementtype/-/domelementtype-2.3.0.tgz -> npmpkg-domelementtype-2.3.0.tgz
https://registry.npmjs.org/domexception/-/domexception-4.0.0.tgz -> npmpkg-domexception-4.0.0.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-7.0.0.tgz -> npmpkg-webidl-conversions-7.0.0.tgz
https://registry.npmjs.org/domhandler/-/domhandler-5.0.3.tgz -> npmpkg-domhandler-5.0.3.tgz
https://registry.npmjs.org/dompurify/-/dompurify-2.4.5.tgz -> npmpkg-dompurify-2.4.5.tgz
https://registry.npmjs.org/domutils/-/domutils-3.1.0.tgz -> npmpkg-domutils-3.1.0.tgz
https://registry.npmjs.org/ejs/-/ejs-3.1.9.tgz -> npmpkg-ejs-3.1.9.tgz
https://registry.npmjs.org/electron-to-chromium/-/electron-to-chromium-1.4.576.tgz -> npmpkg-electron-to-chromium-1.4.576.tgz
https://registry.npmjs.org/emittery/-/emittery-0.13.1.tgz -> npmpkg-emittery-0.13.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-9.2.2.tgz -> npmpkg-emoji-regex-9.2.2.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz -> npmpkg-end-of-stream-1.4.4.tgz
https://registry.npmjs.org/enhanced-resolve/-/enhanced-resolve-5.15.0.tgz -> npmpkg-enhanced-resolve-5.15.0.tgz
https://registry.npmjs.org/ensure-posix-path/-/ensure-posix-path-1.1.1.tgz -> npmpkg-ensure-posix-path-1.1.1.tgz
https://registry.npmjs.org/entities/-/entities-4.5.0.tgz -> npmpkg-entities-4.5.0.tgz
https://registry.npmjs.org/eol/-/eol-0.9.1.tgz -> npmpkg-eol-0.9.1.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.2.tgz -> npmpkg-error-ex-1.3.2.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz -> npmpkg-is-arrayish-0.2.1.tgz
https://registry.npmjs.org/es-abstract/-/es-abstract-1.21.2.tgz -> npmpkg-es-abstract-1.21.2.tgz
https://registry.npmjs.org/es-get-iterator/-/es-get-iterator-1.1.3.tgz -> npmpkg-es-get-iterator-1.1.3.tgz
https://registry.npmjs.org/es-module-lexer/-/es-module-lexer-1.3.1.tgz -> npmpkg-es-module-lexer-1.3.1.tgz
https://registry.npmjs.org/es-set-tostringtag/-/es-set-tostringtag-2.0.1.tgz -> npmpkg-es-set-tostringtag-2.0.1.tgz
https://registry.npmjs.org/es-shim-unscopables/-/es-shim-unscopables-1.0.0.tgz -> npmpkg-es-shim-unscopables-1.0.0.tgz
https://registry.npmjs.org/es-to-primitive/-/es-to-primitive-1.2.1.tgz -> npmpkg-es-to-primitive-1.2.1.tgz
https://registry.npmjs.org/es5-ext/-/es5-ext-0.10.62.tgz -> npmpkg-es5-ext-0.10.62.tgz
https://registry.npmjs.org/es6-iterator/-/es6-iterator-2.0.3.tgz -> npmpkg-es6-iterator-2.0.3.tgz
https://registry.npmjs.org/es6-symbol/-/es6-symbol-3.1.3.tgz -> npmpkg-es6-symbol-3.1.3.tgz
https://registry.npmjs.org/esbuild/-/esbuild-0.19.8.tgz -> npmpkg-esbuild-0.19.8.tgz
https://registry.npmjs.org/escalade/-/escalade-3.1.1.tgz -> npmpkg-escalade-3.1.1.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> npmpkg-escape-string-regexp-4.0.0.tgz
https://registry.npmjs.org/escodegen/-/escodegen-2.1.0.tgz -> npmpkg-escodegen-2.1.0.tgz
https://registry.npmjs.org/eslint/-/eslint-8.36.0.tgz -> npmpkg-eslint-8.36.0.tgz
https://registry.npmjs.org/eslint-config-next/-/eslint-config-next-13.2.4.tgz -> npmpkg-eslint-config-next-13.2.4.tgz
https://registry.npmjs.org/eslint-import-resolver-node/-/eslint-import-resolver-node-0.3.7.tgz -> npmpkg-eslint-import-resolver-node-0.3.7.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/eslint-import-resolver-typescript/-/eslint-import-resolver-typescript-3.5.3.tgz -> npmpkg-eslint-import-resolver-typescript-3.5.3.tgz
https://registry.npmjs.org/globby/-/globby-13.1.3.tgz -> npmpkg-globby-13.1.3.tgz
https://registry.npmjs.org/slash/-/slash-4.0.0.tgz -> npmpkg-slash-4.0.0.tgz
https://registry.npmjs.org/eslint-module-utils/-/eslint-module-utils-2.7.4.tgz -> npmpkg-eslint-module-utils-2.7.4.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/eslint-plugin-import/-/eslint-plugin-import-2.27.5.tgz -> npmpkg-eslint-plugin-import-2.27.5.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/doctrine/-/doctrine-2.1.0.tgz -> npmpkg-doctrine-2.1.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/eslint-plugin-jsx-a11y/-/eslint-plugin-jsx-a11y-6.7.1.tgz -> npmpkg-eslint-plugin-jsx-a11y-6.7.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/eslint-plugin-react/-/eslint-plugin-react-7.32.2.tgz -> npmpkg-eslint-plugin-react-7.32.2.tgz
https://registry.npmjs.org/eslint-plugin-react-hooks/-/eslint-plugin-react-hooks-4.6.0.tgz -> npmpkg-eslint-plugin-react-hooks-4.6.0.tgz
https://registry.npmjs.org/doctrine/-/doctrine-2.1.0.tgz -> npmpkg-doctrine-2.1.0.tgz
https://registry.npmjs.org/resolve/-/resolve-2.0.0-next.4.tgz -> npmpkg-resolve-2.0.0-next.4.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-7.1.1.tgz -> npmpkg-eslint-scope-7.1.1.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-3.3.0.tgz -> npmpkg-eslint-visitor-keys-3.3.0.tgz
https://registry.npmjs.org/espree/-/espree-9.5.0.tgz -> npmpkg-espree-9.5.0.tgz
https://registry.npmjs.org/esprima/-/esprima-4.0.1.tgz -> npmpkg-esprima-4.0.1.tgz
https://registry.npmjs.org/esquery/-/esquery-1.5.0.tgz -> npmpkg-esquery-1.5.0.tgz
https://registry.npmjs.org/esrecurse/-/esrecurse-4.3.0.tgz -> npmpkg-esrecurse-4.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/estree-walker/-/estree-walker-1.0.1.tgz -> npmpkg-estree-walker-1.0.1.tgz
https://registry.npmjs.org/esutils/-/esutils-2.0.3.tgz -> npmpkg-esutils-2.0.3.tgz
https://registry.npmjs.org/events/-/events-3.3.0.tgz -> npmpkg-events-3.3.0.tgz
https://registry.npmjs.org/execa/-/execa-5.1.1.tgz -> npmpkg-execa-5.1.1.tgz
https://registry.npmjs.org/exit/-/exit-0.1.2.tgz -> npmpkg-exit-0.1.2.tgz
https://registry.npmjs.org/expand-template/-/expand-template-2.0.3.tgz -> npmpkg-expand-template-2.0.3.tgz
https://registry.npmjs.org/expect/-/expect-29.7.0.tgz -> npmpkg-expect-29.7.0.tgz
https://registry.npmjs.org/ext/-/ext-1.7.0.tgz -> npmpkg-ext-1.7.0.tgz
https://registry.npmjs.org/type/-/type-2.7.2.tgz -> npmpkg-type-2.7.2.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> npmpkg-fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-fifo/-/fast-fifo-1.3.2.tgz -> npmpkg-fast-fifo-1.3.2.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.1.tgz -> npmpkg-fast-glob-3.3.1.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> npmpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.npmjs.org/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz -> npmpkg-fast-levenshtein-2.0.6.tgz
https://registry.npmjs.org/fastq/-/fastq-1.15.0.tgz -> npmpkg-fastq-1.15.0.tgz
https://registry.npmjs.org/fb-watchman/-/fb-watchman-2.0.2.tgz -> npmpkg-fb-watchman-2.0.2.tgz
https://registry.npmjs.org/fflate/-/fflate-0.6.10.tgz -> npmpkg-fflate-0.6.10.tgz
https://registry.npmjs.org/file-entry-cache/-/file-entry-cache-6.0.1.tgz -> npmpkg-file-entry-cache-6.0.1.tgz
https://registry.npmjs.org/file-saver/-/file-saver-2.0.5.tgz -> npmpkg-file-saver-2.0.5.tgz
https://registry.npmjs.org/filelist/-/filelist-1.0.4.tgz -> npmpkg-filelist-1.0.4.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/filepond/-/filepond-4.30.4.tgz -> npmpkg-filepond-4.30.4.tgz
https://registry.npmjs.org/filepond-plugin-file-validate-type/-/filepond-plugin-file-validate-type-1.2.8.tgz -> npmpkg-filepond-plugin-file-validate-type-1.2.8.tgz
https://registry.npmjs.org/filepond-plugin-image-preview/-/filepond-plugin-image-preview-4.6.11.tgz -> npmpkg-filepond-plugin-image-preview-4.6.11.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.0.1.tgz -> npmpkg-fill-range-7.0.1.tgz
https://registry.npmjs.org/find-up/-/find-up-5.0.0.tgz -> npmpkg-find-up-5.0.0.tgz
https://registry.npmjs.org/flat-cache/-/flat-cache-3.0.4.tgz -> npmpkg-flat-cache-3.0.4.tgz
https://registry.npmjs.org/flatbuffers/-/flatbuffers-1.12.0.tgz -> npmpkg-flatbuffers-1.12.0.tgz
https://registry.npmjs.org/flatted/-/flatted-3.2.7.tgz -> npmpkg-flatted-3.2.7.tgz
https://registry.npmjs.org/for-each/-/for-each-0.3.3.tgz -> npmpkg-for-each-0.3.3.tgz
https://registry.npmjs.org/form-data/-/form-data-4.0.0.tgz -> npmpkg-form-data-4.0.0.tgz
https://registry.npmjs.org/fraction.js/-/fraction.js-4.2.0.tgz -> npmpkg-fraction.js-4.2.0.tgz
https://registry.npmjs.org/fs-constants/-/fs-constants-1.0.0.tgz -> npmpkg-fs-constants-1.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/fs-merger/-/fs-merger-3.2.1.tgz -> npmpkg-fs-merger-3.2.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz -> npmpkg-universalify-0.1.2.tgz
https://registry.npmjs.org/fs-mkdirp-stream/-/fs-mkdirp-stream-2.0.1.tgz -> npmpkg-fs-mkdirp-stream-2.0.1.tgz
https://registry.npmjs.org/fs-tree-diff/-/fs-tree-diff-2.0.1.tgz -> npmpkg-fs-tree-diff-2.0.1.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.2.tgz -> npmpkg-fsevents-2.3.2.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.1.tgz -> npmpkg-function-bind-1.1.1.tgz
https://registry.npmjs.org/function.prototype.name/-/function.prototype.name-1.1.5.tgz -> npmpkg-function.prototype.name-1.1.5.tgz
https://registry.npmjs.org/functions-have-names/-/functions-have-names-1.2.3.tgz -> npmpkg-functions-have-names-1.2.3.tgz
https://registry.npmjs.org/gensync/-/gensync-1.0.0-beta.2.tgz -> npmpkg-gensync-1.0.0-beta.2.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz -> npmpkg-get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.0.tgz -> npmpkg-get-intrinsic-1.2.0.tgz
https://registry.npmjs.org/get-own-enumerable-property-symbols/-/get-own-enumerable-property-symbols-3.0.2.tgz -> npmpkg-get-own-enumerable-property-symbols-3.0.2.tgz
https://registry.npmjs.org/get-package-type/-/get-package-type-0.1.0.tgz -> npmpkg-get-package-type-0.1.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-6.0.1.tgz -> npmpkg-get-stream-6.0.1.tgz
https://registry.npmjs.org/get-symbol-description/-/get-symbol-description-1.0.0.tgz -> npmpkg-get-symbol-description-1.0.0.tgz
https://registry.npmjs.org/get-tsconfig/-/get-tsconfig-4.5.0.tgz -> npmpkg-get-tsconfig-4.5.0.tgz
https://registry.npmjs.org/github-from-package/-/github-from-package-0.0.0.tgz -> npmpkg-github-from-package-0.0.0.tgz
https://registry.npmjs.org/gl-matrix/-/gl-matrix-3.4.3.tgz -> npmpkg-gl-matrix-3.4.3.tgz
https://registry.npmjs.org/glob/-/glob-7.1.7.tgz -> npmpkg-glob-7.1.7.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-6.0.2.tgz -> npmpkg-glob-parent-6.0.2.tgz
https://registry.npmjs.org/glob-stream/-/glob-stream-8.0.0.tgz -> npmpkg-glob-stream-8.0.0.tgz
https://registry.npmjs.org/glob-to-regexp/-/glob-to-regexp-0.4.1.tgz -> npmpkg-glob-to-regexp-0.4.1.tgz
https://registry.npmjs.org/globals/-/globals-13.20.0.tgz -> npmpkg-globals-13.20.0.tgz
https://registry.npmjs.org/globalthis/-/globalthis-1.0.3.tgz -> npmpkg-globalthis-1.0.3.tgz
https://registry.npmjs.org/globalyzer/-/globalyzer-0.1.0.tgz -> npmpkg-globalyzer-0.1.0.tgz
https://registry.npmjs.org/globby/-/globby-11.1.0.tgz -> npmpkg-globby-11.1.0.tgz
https://registry.npmjs.org/globrex/-/globrex-0.1.2.tgz -> npmpkg-globrex-0.1.2.tgz
https://registry.npmjs.org/gopd/-/gopd-1.0.1.tgz -> npmpkg-gopd-1.0.1.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz -> npmpkg-graceful-fs-4.2.11.tgz
https://registry.npmjs.org/grapheme-splitter/-/grapheme-splitter-1.0.4.tgz -> npmpkg-grapheme-splitter-1.0.4.tgz
https://registry.npmjs.org/guid-typescript/-/guid-typescript-1.0.9.tgz -> npmpkg-guid-typescript-1.0.9.tgz
https://registry.npmjs.org/gulp-sort/-/gulp-sort-2.0.0.tgz -> npmpkg-gulp-sort-2.0.0.tgz
https://registry.npmjs.org/has/-/has-1.0.3.tgz -> npmpkg-has-1.0.3.tgz
https://registry.npmjs.org/has-bigints/-/has-bigints-1.0.2.tgz -> npmpkg-has-bigints-1.0.2.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.0.tgz -> npmpkg-has-property-descriptors-1.0.0.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.1.tgz -> npmpkg-has-proto-1.0.1.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/has-tostringtag/-/has-tostringtag-1.0.0.tgz -> npmpkg-has-tostringtag-1.0.0.tgz
https://registry.npmjs.org/he/-/he-1.2.0.tgz -> npmpkg-he-1.2.0.tgz
https://registry.npmjs.org/heimdalljs/-/heimdalljs-0.2.6.tgz -> npmpkg-heimdalljs-0.2.6.tgz
https://registry.npmjs.org/heimdalljs-logger/-/heimdalljs-logger-0.1.10.tgz -> npmpkg-heimdalljs-logger-0.1.10.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/rsvp/-/rsvp-3.2.1.tgz -> npmpkg-rsvp-3.2.1.tgz
https://registry.npmjs.org/html-encoding-sniffer/-/html-encoding-sniffer-3.0.0.tgz -> npmpkg-html-encoding-sniffer-3.0.0.tgz
https://registry.npmjs.org/html-escaper/-/html-escaper-2.0.2.tgz -> npmpkg-html-escaper-2.0.2.tgz
https://registry.npmjs.org/html-parse-stringify/-/html-parse-stringify-3.0.1.tgz -> npmpkg-html-parse-stringify-3.0.1.tgz
https://registry.npmjs.org/htmlparser2/-/htmlparser2-8.0.2.tgz -> npmpkg-htmlparser2-8.0.2.tgz
https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-5.0.0.tgz -> npmpkg-http-proxy-agent-5.0.0.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz -> npmpkg-https-proxy-agent-5.0.1.tgz
https://registry.npmjs.org/human-signals/-/human-signals-2.1.0.tgz -> npmpkg-human-signals-2.1.0.tgz
https://registry.npmjs.org/i18next/-/i18next-23.7.7.tgz -> npmpkg-i18next-23.7.7.tgz
https://registry.npmjs.org/i18next-browser-languagedetector/-/i18next-browser-languagedetector-7.2.0.tgz -> npmpkg-i18next-browser-languagedetector-7.2.0.tgz
https://registry.npmjs.org/i18next-parser/-/i18next-parser-8.9.0.tgz -> npmpkg-i18next-parser-8.9.0.tgz
https://registry.npmjs.org/commander/-/commander-11.0.0.tgz -> npmpkg-commander-11.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-11.2.0.tgz -> npmpkg-fs-extra-11.2.0.tgz
https://registry.npmjs.org/typescript/-/typescript-5.3.2.tgz -> npmpkg-typescript-5.3.2.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz -> npmpkg-iconv-lite-0.6.3.tgz
https://registry.npmjs.org/idb/-/idb-7.1.1.tgz -> npmpkg-idb-7.1.1.tgz
https://registry.npmjs.org/ieee754/-/ieee754-1.2.1.tgz -> npmpkg-ieee754-1.2.1.tgz
https://registry.npmjs.org/ignore/-/ignore-5.2.4.tgz -> npmpkg-ignore-5.2.4.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/import-local/-/import-local-3.1.0.tgz -> npmpkg-import-local-3.1.0.tgz
https://registry.npmjs.org/imurmurhash/-/imurmurhash-0.1.4.tgz -> npmpkg-imurmurhash-0.1.4.tgz
https://registry.npmjs.org/indent-string/-/indent-string-4.0.0.tgz -> npmpkg-indent-string-4.0.0.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/internal-slot/-/internal-slot-1.0.5.tgz -> npmpkg-internal-slot-1.0.5.tgz
https://registry.npmjs.org/is-arguments/-/is-arguments-1.1.1.tgz -> npmpkg-is-arguments-1.1.1.tgz
https://registry.npmjs.org/is-array-buffer/-/is-array-buffer-3.0.2.tgz -> npmpkg-is-array-buffer-3.0.2.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.3.2.tgz -> npmpkg-is-arrayish-0.3.2.tgz
https://registry.npmjs.org/is-bigint/-/is-bigint-1.0.4.tgz -> npmpkg-is-bigint-1.0.4.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz -> npmpkg-is-binary-path-2.1.0.tgz
https://registry.npmjs.org/is-boolean-object/-/is-boolean-object-1.1.2.tgz -> npmpkg-is-boolean-object-1.1.2.tgz
https://registry.npmjs.org/is-callable/-/is-callable-1.2.7.tgz -> npmpkg-is-callable-1.2.7.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.11.0.tgz -> npmpkg-is-core-module-2.11.0.tgz
https://registry.npmjs.org/is-date-object/-/is-date-object-1.0.5.tgz -> npmpkg-is-date-object-1.0.5.tgz
https://registry.npmjs.org/is-docker/-/is-docker-2.2.1.tgz -> npmpkg-is-docker-2.2.1.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-generator-fn/-/is-generator-fn-2.1.0.tgz -> npmpkg-is-generator-fn-2.1.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/is-map/-/is-map-2.0.2.tgz -> npmpkg-is-map-2.0.2.tgz
https://registry.npmjs.org/is-module/-/is-module-1.0.0.tgz -> npmpkg-is-module-1.0.0.tgz
https://registry.npmjs.org/is-negated-glob/-/is-negated-glob-1.0.0.tgz -> npmpkg-is-negated-glob-1.0.0.tgz
https://registry.npmjs.org/is-negative-zero/-/is-negative-zero-2.0.2.tgz -> npmpkg-is-negative-zero-2.0.2.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/is-number-object/-/is-number-object-1.0.7.tgz -> npmpkg-is-number-object-1.0.7.tgz
https://registry.npmjs.org/is-obj/-/is-obj-1.0.1.tgz -> npmpkg-is-obj-1.0.1.tgz
https://registry.npmjs.org/is-path-cwd/-/is-path-cwd-2.2.0.tgz -> npmpkg-is-path-cwd-2.2.0.tgz
https://registry.npmjs.org/is-path-in-cwd/-/is-path-in-cwd-2.1.0.tgz -> npmpkg-is-path-in-cwd-2.1.0.tgz
https://registry.npmjs.org/is-path-inside/-/is-path-inside-2.1.0.tgz -> npmpkg-is-path-inside-2.1.0.tgz
https://registry.npmjs.org/is-path-inside/-/is-path-inside-3.0.3.tgz -> npmpkg-is-path-inside-3.0.3.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-4.1.0.tgz -> npmpkg-is-plain-obj-4.1.0.tgz
https://registry.npmjs.org/is-potential-custom-element-name/-/is-potential-custom-element-name-1.0.1.tgz -> npmpkg-is-potential-custom-element-name-1.0.1.tgz
https://registry.npmjs.org/is-regex/-/is-regex-1.1.4.tgz -> npmpkg-is-regex-1.1.4.tgz
https://registry.npmjs.org/is-regexp/-/is-regexp-1.0.0.tgz -> npmpkg-is-regexp-1.0.0.tgz
https://registry.npmjs.org/is-set/-/is-set-2.0.2.tgz -> npmpkg-is-set-2.0.2.tgz
https://registry.npmjs.org/is-shared-array-buffer/-/is-shared-array-buffer-1.0.2.tgz -> npmpkg-is-shared-array-buffer-1.0.2.tgz
https://registry.npmjs.org/is-stream/-/is-stream-2.0.1.tgz -> npmpkg-is-stream-2.0.1.tgz
https://registry.npmjs.org/is-string/-/is-string-1.0.7.tgz -> npmpkg-is-string-1.0.7.tgz
https://registry.npmjs.org/is-symbol/-/is-symbol-1.0.4.tgz -> npmpkg-is-symbol-1.0.4.tgz
https://registry.npmjs.org/is-typed-array/-/is-typed-array-1.1.10.tgz -> npmpkg-is-typed-array-1.1.10.tgz
https://registry.npmjs.org/is-typedarray/-/is-typedarray-1.0.0.tgz -> npmpkg-is-typedarray-1.0.0.tgz
https://registry.npmjs.org/is-valid-glob/-/is-valid-glob-1.0.0.tgz -> npmpkg-is-valid-glob-1.0.0.tgz
https://registry.npmjs.org/is-weakmap/-/is-weakmap-2.0.1.tgz -> npmpkg-is-weakmap-2.0.1.tgz
https://registry.npmjs.org/is-weakref/-/is-weakref-1.0.2.tgz -> npmpkg-is-weakref-1.0.2.tgz
https://registry.npmjs.org/is-weakset/-/is-weakset-2.0.2.tgz -> npmpkg-is-weakset-2.0.2.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-2.2.0.tgz -> npmpkg-is-wsl-2.2.0.tgz
https://registry.npmjs.org/isarray/-/isarray-2.0.5.tgz -> npmpkg-isarray-2.0.5.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/istanbul-lib-coverage/-/istanbul-lib-coverage-3.2.2.tgz -> npmpkg-istanbul-lib-coverage-3.2.2.tgz
https://registry.npmjs.org/istanbul-lib-instrument/-/istanbul-lib-instrument-6.0.1.tgz -> npmpkg-istanbul-lib-instrument-6.0.1.tgz
https://registry.npmjs.org/istanbul-lib-report/-/istanbul-lib-report-3.0.1.tgz -> npmpkg-istanbul-lib-report-3.0.1.tgz
https://registry.npmjs.org/istanbul-lib-source-maps/-/istanbul-lib-source-maps-4.0.1.tgz -> npmpkg-istanbul-lib-source-maps-4.0.1.tgz
https://registry.npmjs.org/istanbul-reports/-/istanbul-reports-3.1.6.tgz -> npmpkg-istanbul-reports-3.1.6.tgz
https://registry.npmjs.org/jake/-/jake-10.8.7.tgz -> npmpkg-jake-10.8.7.tgz
https://registry.npmjs.org/jest/-/jest-29.7.0.tgz -> npmpkg-jest-29.7.0.tgz
https://registry.npmjs.org/jest-changed-files/-/jest-changed-files-29.7.0.tgz -> npmpkg-jest-changed-files-29.7.0.tgz
https://registry.npmjs.org/jest-circus/-/jest-circus-29.7.0.tgz -> npmpkg-jest-circus-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.2.0.tgz -> npmpkg-react-is-18.2.0.tgz
https://registry.npmjs.org/jest-cli/-/jest-cli-29.7.0.tgz -> npmpkg-jest-cli-29.7.0.tgz
https://registry.npmjs.org/jest-config/-/jest-config-29.7.0.tgz -> npmpkg-jest-config-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.2.0.tgz -> npmpkg-react-is-18.2.0.tgz
https://registry.npmjs.org/jest-diff/-/jest-diff-29.7.0.tgz -> npmpkg-jest-diff-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.2.0.tgz -> npmpkg-react-is-18.2.0.tgz
https://registry.npmjs.org/jest-docblock/-/jest-docblock-29.7.0.tgz -> npmpkg-jest-docblock-29.7.0.tgz
https://registry.npmjs.org/jest-each/-/jest-each-29.7.0.tgz -> npmpkg-jest-each-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.2.0.tgz -> npmpkg-react-is-18.2.0.tgz
https://registry.npmjs.org/jest-environment-jsdom/-/jest-environment-jsdom-29.7.0.tgz -> npmpkg-jest-environment-jsdom-29.7.0.tgz
https://registry.npmjs.org/jest-environment-node/-/jest-environment-node-29.7.0.tgz -> npmpkg-jest-environment-node-29.7.0.tgz
https://registry.npmjs.org/jest-get-type/-/jest-get-type-29.6.3.tgz -> npmpkg-jest-get-type-29.6.3.tgz
https://registry.npmjs.org/jest-haste-map/-/jest-haste-map-29.7.0.tgz -> npmpkg-jest-haste-map-29.7.0.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-29.7.0.tgz -> npmpkg-jest-worker-29.7.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-8.1.1.tgz -> npmpkg-supports-color-8.1.1.tgz
https://registry.npmjs.org/jest-leak-detector/-/jest-leak-detector-29.7.0.tgz -> npmpkg-jest-leak-detector-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.2.0.tgz -> npmpkg-react-is-18.2.0.tgz
https://registry.npmjs.org/jest-matcher-utils/-/jest-matcher-utils-29.7.0.tgz -> npmpkg-jest-matcher-utils-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.2.0.tgz -> npmpkg-react-is-18.2.0.tgz
https://registry.npmjs.org/jest-message-util/-/jest-message-util-29.7.0.tgz -> npmpkg-jest-message-util-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.2.0.tgz -> npmpkg-react-is-18.2.0.tgz
https://registry.npmjs.org/jest-mock/-/jest-mock-29.7.0.tgz -> npmpkg-jest-mock-29.7.0.tgz
https://registry.npmjs.org/jest-pnp-resolver/-/jest-pnp-resolver-1.2.3.tgz -> npmpkg-jest-pnp-resolver-1.2.3.tgz
https://registry.npmjs.org/jest-regex-util/-/jest-regex-util-29.6.3.tgz -> npmpkg-jest-regex-util-29.6.3.tgz
https://registry.npmjs.org/jest-resolve/-/jest-resolve-29.7.0.tgz -> npmpkg-jest-resolve-29.7.0.tgz
https://registry.npmjs.org/jest-resolve-dependencies/-/jest-resolve-dependencies-29.7.0.tgz -> npmpkg-jest-resolve-dependencies-29.7.0.tgz
https://registry.npmjs.org/jest-runner/-/jest-runner-29.7.0.tgz -> npmpkg-jest-runner-29.7.0.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-29.7.0.tgz -> npmpkg-jest-worker-29.7.0.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.13.tgz -> npmpkg-source-map-support-0.5.13.tgz
https://registry.npmjs.org/supports-color/-/supports-color-8.1.1.tgz -> npmpkg-supports-color-8.1.1.tgz
https://registry.npmjs.org/jest-runtime/-/jest-runtime-29.7.0.tgz -> npmpkg-jest-runtime-29.7.0.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-4.0.0.tgz -> npmpkg-strip-bom-4.0.0.tgz
https://registry.npmjs.org/jest-snapshot/-/jest-snapshot-29.7.0.tgz -> npmpkg-jest-snapshot-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.2.0.tgz -> npmpkg-react-is-18.2.0.tgz
https://registry.npmjs.org/jest-util/-/jest-util-29.7.0.tgz -> npmpkg-jest-util-29.7.0.tgz
https://registry.npmjs.org/jest-validate/-/jest-validate-29.7.0.tgz -> npmpkg-jest-validate-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-6.3.0.tgz -> npmpkg-camelcase-6.3.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.2.0.tgz -> npmpkg-react-is-18.2.0.tgz
https://registry.npmjs.org/jest-watcher/-/jest-watcher-29.7.0.tgz -> npmpkg-jest-watcher-29.7.0.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-27.5.1.tgz -> npmpkg-jest-worker-27.5.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-8.1.1.tgz -> npmpkg-supports-color-8.1.1.tgz
https://registry.npmjs.org/jiti/-/jiti-1.18.2.tgz -> npmpkg-jiti-1.18.2.tgz
https://registry.npmjs.org/js-sdsl/-/js-sdsl-4.4.0.tgz -> npmpkg-js-sdsl-4.4.0.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz -> npmpkg-js-tokens-4.0.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz -> npmpkg-js-yaml-4.1.0.tgz
https://registry.npmjs.org/jsdom/-/jsdom-20.0.3.tgz -> npmpkg-jsdom-20.0.3.tgz
https://registry.npmjs.org/tr46/-/tr46-3.0.0.tgz -> npmpkg-tr46-3.0.0.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-7.0.0.tgz -> npmpkg-webidl-conversions-7.0.0.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-11.0.0.tgz -> npmpkg-whatwg-url-11.0.0.tgz
https://registry.npmjs.org/jsesc/-/jsesc-2.5.2.tgz -> npmpkg-jsesc-2.5.2.tgz
https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz -> npmpkg-json-parse-even-better-errors-2.3.1.tgz
https://registry.npmjs.org/json-schema/-/json-schema-0.4.0.tgz -> npmpkg-json-schema-0.4.0.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> npmpkg-json-schema-traverse-0.4.1.tgz
https://registry.npmjs.org/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> npmpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/jsonpointer/-/jsonpointer-5.0.1.tgz -> npmpkg-jsonpointer-5.0.1.tgz
https://registry.npmjs.org/jsx-ast-utils/-/jsx-ast-utils-3.3.3.tgz -> npmpkg-jsx-ast-utils-3.3.3.tgz
https://registry.npmjs.org/kleur/-/kleur-3.0.3.tgz -> npmpkg-kleur-3.0.3.tgz
https://registry.npmjs.org/language-subtag-registry/-/language-subtag-registry-0.3.22.tgz -> npmpkg-language-subtag-registry-0.3.22.tgz
https://registry.npmjs.org/language-tags/-/language-tags-1.0.5.tgz -> npmpkg-language-tags-1.0.5.tgz
https://registry.npmjs.org/lead/-/lead-4.0.0.tgz -> npmpkg-lead-4.0.0.tgz
https://registry.npmjs.org/leven/-/leven-3.1.0.tgz -> npmpkg-leven-3.1.0.tgz
https://registry.npmjs.org/levn/-/levn-0.4.1.tgz -> npmpkg-levn-0.4.1.tgz
https://registry.npmjs.org/lil-gui/-/lil-gui-0.17.0.tgz -> npmpkg-lil-gui-0.17.0.tgz
https://registry.npmjs.org/lilconfig/-/lilconfig-2.1.0.tgz -> npmpkg-lilconfig-2.1.0.tgz
https://registry.npmjs.org/lines-and-columns/-/lines-and-columns-1.2.4.tgz -> npmpkg-lines-and-columns-1.2.4.tgz
https://registry.npmjs.org/loader-runner/-/loader-runner-4.3.0.tgz -> npmpkg-loader-runner-4.3.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-6.0.0.tgz -> npmpkg-locate-path-6.0.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lodash.debounce/-/lodash.debounce-4.0.8.tgz -> npmpkg-lodash.debounce-4.0.8.tgz
https://registry.npmjs.org/lodash.merge/-/lodash.merge-4.6.2.tgz -> npmpkg-lodash.merge-4.6.2.tgz
https://registry.npmjs.org/lodash.sortby/-/lodash.sortby-4.7.0.tgz -> npmpkg-lodash.sortby-4.7.0.tgz
https://registry.npmjs.org/long/-/long-4.0.0.tgz -> npmpkg-long-4.0.0.tgz
https://registry.npmjs.org/loose-envify/-/loose-envify-1.4.0.tgz -> npmpkg-loose-envify-1.4.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/lz-string/-/lz-string-1.5.0.tgz -> npmpkg-lz-string-1.5.0.tgz
https://registry.npmjs.org/magic-string/-/magic-string-0.25.9.tgz -> npmpkg-magic-string-0.25.9.tgz
https://registry.npmjs.org/make-dir/-/make-dir-4.0.0.tgz -> npmpkg-make-dir-4.0.0.tgz
https://registry.npmjs.org/make-error/-/make-error-1.3.6.tgz -> npmpkg-make-error-1.3.6.tgz
https://registry.npmjs.org/makeerror/-/makeerror-1.0.12.tgz -> npmpkg-makeerror-1.0.12.tgz
https://registry.npmjs.org/matcher-collection/-/matcher-collection-2.0.1.tgz -> npmpkg-matcher-collection-2.0.1.tgz
https://registry.npmjs.org/@types/minimatch/-/minimatch-3.0.5.tgz -> npmpkg-@types-minimatch-3.0.5.tgz
https://registry.npmjs.org/merge-stream/-/merge-stream-2.0.0.tgz -> npmpkg-merge-stream-2.0.0.tgz
https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz -> npmpkg-merge2-1.4.1.tgz
https://registry.npmjs.org/meshoptimizer/-/meshoptimizer-0.18.1.tgz -> npmpkg-meshoptimizer-0.18.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.5.tgz -> npmpkg-micromatch-4.0.5.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.52.0.tgz -> npmpkg-mime-db-1.52.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.35.tgz -> npmpkg-mime-types-2.1.35.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-2.1.0.tgz -> npmpkg-mimic-fn-2.1.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-3.1.0.tgz -> npmpkg-mimic-response-3.1.0.tgz
https://registry.npmjs.org/min-indent/-/min-indent-1.0.1.tgz -> npmpkg-min-indent-1.0.1.tgz
https://registry.npmjs.org/mini-svg-data-uri/-/mini-svg-data-uri-1.4.4.tgz -> npmpkg-mini-svg-data-uri-1.4.4.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/mkdirp-classic/-/mkdirp-classic-0.5.3.tgz -> npmpkg-mkdirp-classic-0.5.3.tgz
https://registry.npmjs.org/mktemp/-/mktemp-0.4.0.tgz -> npmpkg-mktemp-0.4.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/mz/-/mz-2.7.0.tgz -> npmpkg-mz-2.7.0.tgz
https://registry.npmjs.org/nanoid/-/nanoid-3.3.6.tgz -> npmpkg-nanoid-3.3.6.tgz
https://registry.npmjs.org/napi-build-utils/-/napi-build-utils-1.0.2.tgz -> npmpkg-napi-build-utils-1.0.2.tgz
https://registry.npmjs.org/natural-compare/-/natural-compare-1.4.0.tgz -> npmpkg-natural-compare-1.4.0.tgz
https://registry.npmjs.org/neo-async/-/neo-async-2.6.2.tgz -> npmpkg-neo-async-2.6.2.tgz
https://registry.npmjs.org/next/-/next-13.5.6.tgz -> npmpkg-next-13.5.6.tgz
https://registry.npmjs.org/next-tick/-/next-tick-1.1.0.tgz -> npmpkg-next-tick-1.1.0.tgz
https://registry.npmjs.org/node-abi/-/node-abi-3.51.0.tgz -> npmpkg-node-abi-3.51.0.tgz
https://registry.npmjs.org/node-addon-api/-/node-addon-api-6.1.0.tgz -> npmpkg-node-addon-api-6.1.0.tgz
https://registry.npmjs.org/node-gyp-build/-/node-gyp-build-4.7.1.tgz -> npmpkg-node-gyp-build-4.7.1.tgz
https://registry.npmjs.org/node-int64/-/node-int64-0.4.0.tgz -> npmpkg-node-int64-0.4.0.tgz
https://registry.npmjs.org/node-releases/-/node-releases-2.0.13.tgz -> npmpkg-node-releases-2.0.13.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/normalize-range/-/normalize-range-0.1.2.tgz -> npmpkg-normalize-range-0.1.2.tgz
https://registry.npmjs.org/now-and-later/-/now-and-later-3.0.0.tgz -> npmpkg-now-and-later-3.0.0.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-4.0.1.tgz -> npmpkg-npm-run-path-4.0.1.tgz
https://registry.npmjs.org/nth-check/-/nth-check-2.1.1.tgz -> npmpkg-nth-check-2.1.1.tgz
https://registry.npmjs.org/nwsapi/-/nwsapi-2.2.7.tgz -> npmpkg-nwsapi-2.2.7.tgz
https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz -> npmpkg-object-assign-4.1.1.tgz
https://registry.npmjs.org/object-hash/-/object-hash-3.0.0.tgz -> npmpkg-object-hash-3.0.0.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.12.3.tgz -> npmpkg-object-inspect-1.12.3.tgz
https://registry.npmjs.org/object-is/-/object-is-1.1.5.tgz -> npmpkg-object-is-1.1.5.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/object.assign/-/object.assign-4.1.4.tgz -> npmpkg-object.assign-4.1.4.tgz
https://registry.npmjs.org/object.entries/-/object.entries-1.1.6.tgz -> npmpkg-object.entries-1.1.6.tgz
https://registry.npmjs.org/object.fromentries/-/object.fromentries-2.0.6.tgz -> npmpkg-object.fromentries-2.0.6.tgz
https://registry.npmjs.org/object.hasown/-/object.hasown-1.1.2.tgz -> npmpkg-object.hasown-1.1.2.tgz
https://registry.npmjs.org/object.values/-/object.values-1.1.6.tgz -> npmpkg-object.values-1.1.6.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/onetime/-/onetime-5.1.2.tgz -> npmpkg-onetime-5.1.2.tgz
https://registry.npmjs.org/onnx-proto/-/onnx-proto-4.0.4.tgz -> npmpkg-onnx-proto-4.0.4.tgz
https://registry.npmjs.org/onnxruntime-common/-/onnxruntime-common-1.14.0.tgz -> npmpkg-onnxruntime-common-1.14.0.tgz
https://registry.npmjs.org/onnxruntime-node/-/onnxruntime-node-1.14.0.tgz -> npmpkg-onnxruntime-node-1.14.0.tgz
https://registry.npmjs.org/onnxruntime-web/-/onnxruntime-web-1.14.0.tgz -> npmpkg-onnxruntime-web-1.14.0.tgz
https://registry.npmjs.org/open/-/open-8.4.2.tgz -> npmpkg-open-8.4.2.tgz
https://registry.npmjs.org/optionator/-/optionator-0.9.1.tgz -> npmpkg-optionator-0.9.1.tgz
https://registry.npmjs.org/p-limit/-/p-limit-3.1.0.tgz -> npmpkg-p-limit-3.1.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-5.0.0.tgz -> npmpkg-p-locate-5.0.0.tgz
https://registry.npmjs.org/p-map/-/p-map-2.1.0.tgz -> npmpkg-p-map-2.1.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/parent-module/-/parent-module-1.0.1.tgz -> npmpkg-parent-module-1.0.1.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/parse5/-/parse5-7.1.2.tgz -> npmpkg-parse5-7.1.2.tgz
https://registry.npmjs.org/parse5-htmlparser2-tree-adapter/-/parse5-htmlparser2-tree-adapter-7.0.0.tgz -> npmpkg-parse5-htmlparser2-tree-adapter-7.0.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-is-inside/-/path-is-inside-1.0.2.tgz -> npmpkg-path-is-inside-1.0.2.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-posix/-/path-posix-1.0.0.tgz -> npmpkg-path-posix-1.0.0.tgz
https://registry.npmjs.org/path-type/-/path-type-4.0.0.tgz -> npmpkg-path-type-4.0.0.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.0.0.tgz -> npmpkg-picocolors-1.0.0.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/pify/-/pify-2.3.0.tgz -> npmpkg-pify-2.3.0.tgz
https://registry.npmjs.org/pinkie/-/pinkie-2.0.4.tgz -> npmpkg-pinkie-2.0.4.tgz
https://registry.npmjs.org/pinkie-promise/-/pinkie-promise-2.0.1.tgz -> npmpkg-pinkie-promise-2.0.1.tgz
https://registry.npmjs.org/pirates/-/pirates-4.0.5.tgz -> npmpkg-pirates-4.0.5.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-4.2.0.tgz -> npmpkg-pkg-dir-4.2.0.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/platform/-/platform-1.3.6.tgz -> npmpkg-platform-1.3.6.tgz
https://registry.npmjs.org/polished/-/polished-4.2.2.tgz -> npmpkg-polished-4.2.2.tgz
https://registry.npmjs.org/postcss/-/postcss-8.4.31.tgz -> npmpkg-postcss-8.4.31.tgz
https://registry.npmjs.org/postcss-import/-/postcss-import-14.1.0.tgz -> npmpkg-postcss-import-14.1.0.tgz
https://registry.npmjs.org/postcss-nested/-/postcss-nested-6.0.0.tgz -> npmpkg-postcss-nested-6.0.0.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-6.0.11.tgz -> npmpkg-postcss-selector-parser-6.0.11.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-4.2.0.tgz -> npmpkg-postcss-value-parser-4.2.0.tgz
https://registry.npmjs.org/prebuild-install/-/prebuild-install-7.1.1.tgz -> npmpkg-prebuild-install-7.1.1.tgz
https://registry.npmjs.org/tar-fs/-/tar-fs-2.1.1.tgz -> npmpkg-tar-fs-2.1.1.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-2.2.0.tgz -> npmpkg-tar-stream-2.2.0.tgz
https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.2.1.tgz -> npmpkg-prelude-ls-1.2.1.tgz
https://registry.npmjs.org/prettier/-/prettier-2.8.8.tgz -> npmpkg-prettier-2.8.8.tgz
https://registry.npmjs.org/prettier-plugin-tailwindcss/-/prettier-plugin-tailwindcss-0.2.8.tgz -> npmpkg-prettier-plugin-tailwindcss-0.2.8.tgz
https://registry.npmjs.org/pretty-bytes/-/pretty-bytes-5.6.0.tgz -> npmpkg-pretty-bytes-5.6.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-27.5.1.tgz -> npmpkg-pretty-format-27.5.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/react-is/-/react-is-17.0.2.tgz -> npmpkg-react-is-17.0.2.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> npmpkg-process-nextick-args-2.0.1.tgz
https://registry.npmjs.org/promise-map-series/-/promise-map-series-0.3.0.tgz -> npmpkg-promise-map-series-0.3.0.tgz
https://registry.npmjs.org/prompts/-/prompts-2.4.2.tgz -> npmpkg-prompts-2.4.2.tgz
https://registry.npmjs.org/prop-types/-/prop-types-15.8.1.tgz -> npmpkg-prop-types-15.8.1.tgz
https://registry.npmjs.org/property-graph/-/property-graph-0.2.6.tgz -> npmpkg-property-graph-0.2.6.tgz
https://registry.npmjs.org/protobufjs/-/protobufjs-6.11.4.tgz -> npmpkg-protobufjs-6.11.4.tgz
https://registry.npmjs.org/psl/-/psl-1.9.0.tgz -> npmpkg-psl-1.9.0.tgz
https://registry.npmjs.org/pump/-/pump-3.0.0.tgz -> npmpkg-pump-3.0.0.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.0.tgz -> npmpkg-punycode-2.3.0.tgz
https://registry.npmjs.org/pure-rand/-/pure-rand-6.0.4.tgz -> npmpkg-pure-rand-6.0.4.tgz
https://registry.npmjs.org/querystringify/-/querystringify-2.2.0.tgz -> npmpkg-querystringify-2.2.0.tgz
https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz -> npmpkg-queue-microtask-1.2.3.tgz
https://registry.npmjs.org/queue-tick/-/queue-tick-1.0.1.tgz -> npmpkg-queue-tick-1.0.1.tgz
https://registry.npmjs.org/quick-lru/-/quick-lru-5.1.1.tgz -> npmpkg-quick-lru-5.1.1.tgz
https://registry.npmjs.org/quick-temp/-/quick-temp-0.1.8.tgz -> npmpkg-quick-temp-0.1.8.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.7.1.tgz -> npmpkg-rimraf-2.7.1.tgz
https://registry.npmjs.org/randombytes/-/randombytes-2.1.0.tgz -> npmpkg-randombytes-2.1.0.tgz
https://registry.npmjs.org/rc/-/rc-1.2.8.tgz -> npmpkg-rc-1.2.8.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-2.0.1.tgz -> npmpkg-strip-json-comments-2.0.1.tgz
https://registry.npmjs.org/react/-/react-18.2.0.tgz -> npmpkg-react-18.2.0.tgz
https://registry.npmjs.org/react-dom/-/react-dom-18.2.0.tgz -> npmpkg-react-dom-18.2.0.tgz
https://registry.npmjs.org/react-filepond/-/react-filepond-7.1.2.tgz -> npmpkg-react-filepond-7.1.2.tgz
https://registry.npmjs.org/react-i18next/-/react-i18next-13.5.0.tgz -> npmpkg-react-i18next-13.5.0.tgz
https://registry.npmjs.org/react-is/-/react-is-16.13.1.tgz -> npmpkg-react-is-16.13.1.tgz
https://registry.npmjs.org/react-webcam/-/react-webcam-7.2.0.tgz -> npmpkg-react-webcam-7.2.0.tgz
https://registry.npmjs.org/read-cache/-/read-cache-1.0.0.tgz -> npmpkg-read-cache-1.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz -> npmpkg-readdirp-3.6.0.tgz
https://registry.npmjs.org/redent/-/redent-3.0.0.tgz -> npmpkg-redent-3.0.0.tgz
https://registry.npmjs.org/regenerate/-/regenerate-1.4.2.tgz -> npmpkg-regenerate-1.4.2.tgz
https://registry.npmjs.org/regenerate-unicode-properties/-/regenerate-unicode-properties-10.1.1.tgz -> npmpkg-regenerate-unicode-properties-10.1.1.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.14.0.tgz -> npmpkg-regenerator-runtime-0.14.0.tgz
https://registry.npmjs.org/regenerator-transform/-/regenerator-transform-0.15.2.tgz -> npmpkg-regenerator-transform-0.15.2.tgz
https://registry.npmjs.org/regexp.prototype.flags/-/regexp.prototype.flags-1.4.3.tgz -> npmpkg-regexp.prototype.flags-1.4.3.tgz
https://registry.npmjs.org/regexpu-core/-/regexpu-core-5.3.2.tgz -> npmpkg-regexpu-core-5.3.2.tgz
https://registry.npmjs.org/regjsparser/-/regjsparser-0.9.1.tgz -> npmpkg-regjsparser-0.9.1.tgz
https://registry.npmjs.org/jsesc/-/jsesc-0.5.0.tgz -> npmpkg-jsesc-0.5.0.tgz
https://registry.npmjs.org/remove-trailing-separator/-/remove-trailing-separator-1.1.0.tgz -> npmpkg-remove-trailing-separator-1.1.0.tgz
https://registry.npmjs.org/replace-ext/-/replace-ext-2.0.0.tgz -> npmpkg-replace-ext-2.0.0.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/require-from-string/-/require-from-string-2.0.2.tgz -> npmpkg-require-from-string-2.0.2.tgz
https://registry.npmjs.org/requires-port/-/requires-port-1.0.0.tgz -> npmpkg-requires-port-1.0.0.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.1.tgz -> npmpkg-resolve-1.22.1.tgz
https://registry.npmjs.org/resolve-cwd/-/resolve-cwd-3.0.0.tgz -> npmpkg-resolve-cwd-3.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-5.0.0.tgz -> npmpkg-resolve-from-5.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/resolve-options/-/resolve-options-2.0.0.tgz -> npmpkg-resolve-options-2.0.0.tgz
https://registry.npmjs.org/resolve.exports/-/resolve.exports-2.0.2.tgz -> npmpkg-resolve.exports-2.0.2.tgz
https://registry.npmjs.org/reusify/-/reusify-1.0.4.tgz -> npmpkg-reusify-1.0.4.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/rollup/-/rollup-2.79.1.tgz -> npmpkg-rollup-2.79.1.tgz
https://registry.npmjs.org/rollup-plugin-terser/-/rollup-plugin-terser-7.0.2.tgz -> npmpkg-rollup-plugin-terser-7.0.2.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-26.6.2.tgz -> npmpkg-jest-worker-26.6.2.tgz
https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-4.0.0.tgz -> npmpkg-serialize-javascript-4.0.0.tgz
https://registry.npmjs.org/rsvp/-/rsvp-4.8.5.tgz -> npmpkg-rsvp-4.8.5.tgz
https://registry.npmjs.org/run-parallel/-/run-parallel-1.2.0.tgz -> npmpkg-run-parallel-1.2.0.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/safe-regex-test/-/safe-regex-test-1.0.0.tgz -> npmpkg-safe-regex-test-1.0.0.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz -> npmpkg-safer-buffer-2.1.2.tgz
https://registry.npmjs.org/saxes/-/saxes-6.0.0.tgz -> npmpkg-saxes-6.0.0.tgz
https://registry.npmjs.org/scheduler/-/scheduler-0.23.0.tgz -> npmpkg-scheduler-0.23.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-6.0.1.tgz -> npmpkg-serialize-javascript-6.0.1.tgz
https://registry.npmjs.org/sharp/-/sharp-0.32.6.tgz -> npmpkg-sharp-0.32.6.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.4.tgz -> npmpkg-side-channel-1.0.4.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.7.tgz -> npmpkg-signal-exit-3.0.7.tgz
https://registry.npmjs.org/simple-concat/-/simple-concat-1.0.1.tgz -> npmpkg-simple-concat-1.0.1.tgz
https://registry.npmjs.org/simple-get/-/simple-get-4.0.1.tgz -> npmpkg-simple-get-4.0.1.tgz
https://registry.npmjs.org/simple-swizzle/-/simple-swizzle-0.2.2.tgz -> npmpkg-simple-swizzle-0.2.2.tgz
https://registry.npmjs.org/sisteransi/-/sisteransi-1.0.5.tgz -> npmpkg-sisteransi-1.0.5.tgz
https://registry.npmjs.org/slash/-/slash-3.0.0.tgz -> npmpkg-slash-3.0.0.tgz
https://registry.npmjs.org/sort-keys/-/sort-keys-5.0.0.tgz -> npmpkg-sort-keys-5.0.0.tgz
https://registry.npmjs.org/source-list-map/-/source-list-map-2.0.1.tgz -> npmpkg-source-list-map-2.0.1.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/source-map-js/-/source-map-js-1.0.2.tgz -> npmpkg-source-map-js-1.0.2.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.21.tgz -> npmpkg-source-map-support-0.5.21.tgz
https://registry.npmjs.org/sourcemap-codec/-/sourcemap-codec-1.4.8.tgz -> npmpkg-sourcemap-codec-1.4.8.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.0.3.tgz -> npmpkg-sprintf-js-1.0.3.tgz
https://registry.npmjs.org/stack-utils/-/stack-utils-2.0.6.tgz -> npmpkg-stack-utils-2.0.6.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-2.0.0.tgz -> npmpkg-escape-string-regexp-2.0.0.tgz
https://registry.npmjs.org/stop-iteration-iterator/-/stop-iteration-iterator-1.0.0.tgz -> npmpkg-stop-iteration-iterator-1.0.0.tgz
https://registry.npmjs.org/stream-composer/-/stream-composer-1.0.2.tgz -> npmpkg-stream-composer-1.0.2.tgz
https://registry.npmjs.org/streamsearch/-/streamsearch-1.1.0.tgz -> npmpkg-streamsearch-1.1.0.tgz
https://registry.npmjs.org/streamx/-/streamx-2.15.1.tgz -> npmpkg-streamx-2.15.1.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.3.0.tgz -> npmpkg-string_decoder-1.3.0.tgz
https://registry.npmjs.org/string-length/-/string-length-4.0.2.tgz -> npmpkg-string-length-4.0.2.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/string.prototype.matchall/-/string.prototype.matchall-4.0.8.tgz -> npmpkg-string.prototype.matchall-4.0.8.tgz
https://registry.npmjs.org/string.prototype.trim/-/string.prototype.trim-1.2.7.tgz -> npmpkg-string.prototype.trim-1.2.7.tgz
https://registry.npmjs.org/string.prototype.trimend/-/string.prototype.trimend-1.0.6.tgz -> npmpkg-string.prototype.trimend-1.0.6.tgz
https://registry.npmjs.org/string.prototype.trimstart/-/string.prototype.trimstart-1.0.6.tgz -> npmpkg-string.prototype.trimstart-1.0.6.tgz
https://registry.npmjs.org/stringify-object/-/stringify-object-3.3.0.tgz -> npmpkg-stringify-object-3.3.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz -> npmpkg-strip-bom-3.0.0.tgz
https://registry.npmjs.org/strip-comments/-/strip-comments-2.0.1.tgz -> npmpkg-strip-comments-2.0.1.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-2.0.0.tgz -> npmpkg-strip-final-newline-2.0.0.tgz
https://registry.npmjs.org/strip-indent/-/strip-indent-3.0.0.tgz -> npmpkg-strip-indent-3.0.0.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> npmpkg-strip-json-comments-3.1.1.tgz
https://registry.npmjs.org/styled-jsx/-/styled-jsx-5.1.1.tgz -> npmpkg-styled-jsx-5.1.1.tgz
https://registry.npmjs.org/sucrase/-/sucrase-3.31.0.tgz -> npmpkg-sucrase-3.31.0.tgz
https://registry.npmjs.org/glob/-/glob-7.1.6.tgz -> npmpkg-glob-7.1.6.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> npmpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.npmjs.org/symbol-tree/-/symbol-tree-3.2.4.tgz -> npmpkg-symbol-tree-3.2.4.tgz
https://registry.npmjs.org/symlink-or-copy/-/symlink-or-copy-1.3.1.tgz -> npmpkg-symlink-or-copy-1.3.1.tgz
https://registry.npmjs.org/synckit/-/synckit-0.8.5.tgz -> npmpkg-synckit-0.8.5.tgz
https://registry.npmjs.org/tailwindcss/-/tailwindcss-3.3.1.tgz -> npmpkg-tailwindcss-3.3.1.tgz
https://registry.npmjs.org/postcss-js/-/postcss-js-4.0.1.tgz -> npmpkg-postcss-js-4.0.1.tgz
https://registry.npmjs.org/postcss-load-config/-/postcss-load-config-3.1.4.tgz -> npmpkg-postcss-load-config-3.1.4.tgz
https://registry.npmjs.org/tapable/-/tapable-2.2.1.tgz -> npmpkg-tapable-2.2.1.tgz
https://registry.npmjs.org/tar-fs/-/tar-fs-3.0.4.tgz -> npmpkg-tar-fs-3.0.4.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-3.1.6.tgz -> npmpkg-tar-stream-3.1.6.tgz
https://registry.npmjs.org/teex/-/teex-1.0.1.tgz -> npmpkg-teex-1.0.1.tgz
https://registry.npmjs.org/temp-dir/-/temp-dir-2.0.0.tgz -> npmpkg-temp-dir-2.0.0.tgz
https://registry.npmjs.org/tempy/-/tempy-0.6.0.tgz -> npmpkg-tempy-0.6.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.16.0.tgz -> npmpkg-type-fest-0.16.0.tgz
https://registry.npmjs.org/terser/-/terser-5.24.0.tgz -> npmpkg-terser-5.24.0.tgz
https://registry.npmjs.org/terser-webpack-plugin/-/terser-webpack-plugin-5.3.9.tgz -> npmpkg-terser-webpack-plugin-5.3.9.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.20.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.20.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-3.3.0.tgz -> npmpkg-schema-utils-3.3.0.tgz
https://registry.npmjs.org/commander/-/commander-2.20.3.tgz -> npmpkg-commander-2.20.3.tgz
https://registry.npmjs.org/test-exclude/-/test-exclude-6.0.0.tgz -> npmpkg-test-exclude-6.0.0.tgz
https://registry.npmjs.org/text-table/-/text-table-0.2.0.tgz -> npmpkg-text-table-0.2.0.tgz
https://registry.npmjs.org/thenify/-/thenify-3.3.1.tgz -> npmpkg-thenify-3.3.1.tgz
https://registry.npmjs.org/thenify-all/-/thenify-all-1.6.0.tgz -> npmpkg-thenify-all-1.6.0.tgz
https://registry.npmjs.org/three/-/three-0.154.0.tgz -> npmpkg-three-0.154.0.tgz
https://registry.npmjs.org/through2/-/through2-2.0.5.tgz -> npmpkg-through2-2.0.5.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/tiny-glob/-/tiny-glob-0.2.9.tgz -> npmpkg-tiny-glob-0.2.9.tgz
https://registry.npmjs.org/tmpl/-/tmpl-1.0.5.tgz -> npmpkg-tmpl-1.0.5.tgz
https://registry.npmjs.org/to-fast-properties/-/to-fast-properties-2.0.0.tgz -> npmpkg-to-fast-properties-2.0.0.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/to-through/-/to-through-3.0.0.tgz -> npmpkg-to-through-3.0.0.tgz
https://registry.npmjs.org/tough-cookie/-/tough-cookie-4.1.3.tgz -> npmpkg-tough-cookie-4.1.3.tgz
https://registry.npmjs.org/universalify/-/universalify-0.2.0.tgz -> npmpkg-universalify-0.2.0.tgz
https://registry.npmjs.org/tr46/-/tr46-1.0.1.tgz -> npmpkg-tr46-1.0.1.tgz
https://registry.npmjs.org/ts-interface-checker/-/ts-interface-checker-0.1.13.tgz -> npmpkg-ts-interface-checker-0.1.13.tgz
https://registry.npmjs.org/ts-node/-/ts-node-10.9.1.tgz -> npmpkg-ts-node-10.9.1.tgz
https://registry.npmjs.org/arg/-/arg-4.1.3.tgz -> npmpkg-arg-4.1.3.tgz
https://registry.npmjs.org/tsconfig-paths/-/tsconfig-paths-3.14.2.tgz -> npmpkg-tsconfig-paths-3.14.2.tgz
https://registry.npmjs.org/tslib/-/tslib-2.5.0.tgz -> npmpkg-tslib-2.5.0.tgz
https://registry.npmjs.org/tsutils/-/tsutils-3.21.0.tgz -> npmpkg-tsutils-3.21.0.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.6.0.tgz -> npmpkg-tunnel-agent-0.6.0.tgz
https://registry.npmjs.org/type/-/type-1.2.0.tgz -> npmpkg-type-1.2.0.tgz
https://registry.npmjs.org/type-check/-/type-check-0.4.0.tgz -> npmpkg-type-check-0.4.0.tgz
https://registry.npmjs.org/type-detect/-/type-detect-4.0.8.tgz -> npmpkg-type-detect-4.0.8.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.20.2.tgz -> npmpkg-type-fest-0.20.2.tgz
https://registry.npmjs.org/typed-array-length/-/typed-array-length-1.0.4.tgz -> npmpkg-typed-array-length-1.0.4.tgz
https://registry.npmjs.org/typedarray-to-buffer/-/typedarray-to-buffer-3.1.5.tgz -> npmpkg-typedarray-to-buffer-3.1.5.tgz
https://registry.npmjs.org/typescript/-/typescript-5.0.2.tgz -> npmpkg-typescript-5.0.2.tgz
https://registry.npmjs.org/typescript-collections/-/typescript-collections-1.3.3.tgz -> npmpkg-typescript-collections-1.3.3.tgz
https://registry.npmjs.org/unbox-primitive/-/unbox-primitive-1.0.2.tgz -> npmpkg-unbox-primitive-1.0.2.tgz
https://registry.npmjs.org/underscore.string/-/underscore.string-3.3.6.tgz -> npmpkg-underscore.string-3.3.6.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.1.3.tgz -> npmpkg-sprintf-js-1.1.3.tgz
https://registry.npmjs.org/unicode-canonical-property-names-ecmascript/-/unicode-canonical-property-names-ecmascript-2.0.0.tgz -> npmpkg-unicode-canonical-property-names-ecmascript-2.0.0.tgz
https://registry.npmjs.org/unicode-match-property-ecmascript/-/unicode-match-property-ecmascript-2.0.0.tgz -> npmpkg-unicode-match-property-ecmascript-2.0.0.tgz
https://registry.npmjs.org/unicode-match-property-value-ecmascript/-/unicode-match-property-value-ecmascript-2.1.0.tgz -> npmpkg-unicode-match-property-value-ecmascript-2.1.0.tgz
https://registry.npmjs.org/unicode-property-aliases-ecmascript/-/unicode-property-aliases-ecmascript-2.1.0.tgz -> npmpkg-unicode-property-aliases-ecmascript-2.1.0.tgz
https://registry.npmjs.org/unique-string/-/unique-string-2.0.0.tgz -> npmpkg-unique-string-2.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/upath/-/upath-1.2.0.tgz -> npmpkg-upath-1.2.0.tgz
https://registry.npmjs.org/update-browserslist-db/-/update-browserslist-db-1.0.13.tgz -> npmpkg-update-browserslist-db-1.0.13.tgz
https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz -> npmpkg-uri-js-4.4.1.tgz
https://registry.npmjs.org/url-parse/-/url-parse-1.5.10.tgz -> npmpkg-url-parse-1.5.10.tgz
https://registry.npmjs.org/utf-8-validate/-/utf-8-validate-5.0.10.tgz -> npmpkg-utf-8-validate-5.0.10.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/v8-compile-cache-lib/-/v8-compile-cache-lib-3.0.1.tgz -> npmpkg-v8-compile-cache-lib-3.0.1.tgz
https://registry.npmjs.org/v8-to-istanbul/-/v8-to-istanbul-9.2.0.tgz -> npmpkg-v8-to-istanbul-9.2.0.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.20.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.20.tgz
https://registry.npmjs.org/value-or-function/-/value-or-function-4.0.0.tgz -> npmpkg-value-or-function-4.0.0.tgz
https://registry.npmjs.org/vinyl/-/vinyl-3.0.0.tgz -> npmpkg-vinyl-3.0.0.tgz
https://registry.npmjs.org/vinyl-contents/-/vinyl-contents-2.0.0.tgz -> npmpkg-vinyl-contents-2.0.0.tgz
https://registry.npmjs.org/bl/-/bl-5.1.0.tgz -> npmpkg-bl-5.1.0.tgz
https://registry.npmjs.org/buffer/-/buffer-6.0.3.tgz -> npmpkg-buffer-6.0.3.tgz
https://registry.npmjs.org/vinyl-fs/-/vinyl-fs-4.0.0.tgz -> npmpkg-vinyl-fs-4.0.0.tgz
https://registry.npmjs.org/vinyl-sourcemap/-/vinyl-sourcemap-2.0.0.tgz -> npmpkg-vinyl-sourcemap-2.0.0.tgz
https://registry.npmjs.org/void-elements/-/void-elements-3.1.0.tgz -> npmpkg-void-elements-3.1.0.tgz
https://registry.npmjs.org/vue-template-compiler/-/vue-template-compiler-2.7.15.tgz -> npmpkg-vue-template-compiler-2.7.15.tgz
https://registry.npmjs.org/w3c-xmlserializer/-/w3c-xmlserializer-4.0.0.tgz -> npmpkg-w3c-xmlserializer-4.0.0.tgz
https://registry.npmjs.org/walk-sync/-/walk-sync-2.2.0.tgz -> npmpkg-walk-sync-2.2.0.tgz
https://registry.npmjs.org/@types/minimatch/-/minimatch-3.0.5.tgz -> npmpkg-@types-minimatch-3.0.5.tgz
https://registry.npmjs.org/walker/-/walker-1.0.8.tgz -> npmpkg-walker-1.0.8.tgz
https://registry.npmjs.org/warning/-/warning-4.0.3.tgz -> npmpkg-warning-4.0.3.tgz
https://registry.npmjs.org/watchpack/-/watchpack-2.4.0.tgz -> npmpkg-watchpack-2.4.0.tgz
https://registry.npmjs.org/wavefile/-/wavefile-11.0.0.tgz -> npmpkg-wavefile-11.0.0.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-4.0.2.tgz -> npmpkg-webidl-conversions-4.0.2.tgz
https://registry.npmjs.org/webpack/-/webpack-5.89.0.tgz -> npmpkg-webpack-5.89.0.tgz
https://registry.npmjs.org/webpack-sources/-/webpack-sources-3.2.3.tgz -> npmpkg-webpack-sources-3.2.3.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-5.1.1.tgz -> npmpkg-eslint-scope-5.1.1.tgz
https://registry.npmjs.org/estraverse/-/estraverse-4.3.0.tgz -> npmpkg-estraverse-4.3.0.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-3.3.0.tgz -> npmpkg-schema-utils-3.3.0.tgz
https://registry.npmjs.org/websocket/-/websocket-1.0.34.tgz -> npmpkg-websocket-1.0.34.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/whatwg-encoding/-/whatwg-encoding-2.0.0.tgz -> npmpkg-whatwg-encoding-2.0.0.tgz
https://registry.npmjs.org/whatwg-mimetype/-/whatwg-mimetype-3.0.0.tgz -> npmpkg-whatwg-mimetype-3.0.0.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-7.1.0.tgz -> npmpkg-whatwg-url-7.1.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> npmpkg-which-boxed-primitive-1.0.2.tgz
https://registry.npmjs.org/which-collection/-/which-collection-1.0.1.tgz -> npmpkg-which-collection-1.0.1.tgz
https://registry.npmjs.org/which-typed-array/-/which-typed-array-1.1.9.tgz -> npmpkg-which-typed-array-1.1.9.tgz
https://registry.npmjs.org/window.ai/-/window.ai-0.2.4.tgz -> npmpkg-window.ai-0.2.4.tgz
https://registry.npmjs.org/word-wrap/-/word-wrap-1.2.5.tgz -> npmpkg-word-wrap-1.2.5.tgz
https://registry.npmjs.org/workbox-background-sync/-/workbox-background-sync-7.0.0.tgz -> npmpkg-workbox-background-sync-7.0.0.tgz
https://registry.npmjs.org/workbox-broadcast-update/-/workbox-broadcast-update-7.0.0.tgz -> npmpkg-workbox-broadcast-update-7.0.0.tgz
https://registry.npmjs.org/workbox-build/-/workbox-build-7.0.0.tgz -> npmpkg-workbox-build-7.0.0.tgz
https://registry.npmjs.org/@apideck/better-ajv-errors/-/better-ajv-errors-0.3.6.tgz -> npmpkg-@apideck-better-ajv-errors-0.3.6.tgz
https://registry.npmjs.org/ajv/-/ajv-8.12.0.tgz -> npmpkg-ajv-8.12.0.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> npmpkg-json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.8.0-beta.0.tgz -> npmpkg-source-map-0.8.0-beta.0.tgz
https://registry.npmjs.org/workbox-cacheable-response/-/workbox-cacheable-response-7.0.0.tgz -> npmpkg-workbox-cacheable-response-7.0.0.tgz
https://registry.npmjs.org/workbox-core/-/workbox-core-7.0.0.tgz -> npmpkg-workbox-core-7.0.0.tgz
https://registry.npmjs.org/workbox-expiration/-/workbox-expiration-7.0.0.tgz -> npmpkg-workbox-expiration-7.0.0.tgz
https://registry.npmjs.org/workbox-google-analytics/-/workbox-google-analytics-7.0.0.tgz -> npmpkg-workbox-google-analytics-7.0.0.tgz
https://registry.npmjs.org/workbox-navigation-preload/-/workbox-navigation-preload-7.0.0.tgz -> npmpkg-workbox-navigation-preload-7.0.0.tgz
https://registry.npmjs.org/workbox-precaching/-/workbox-precaching-7.0.0.tgz -> npmpkg-workbox-precaching-7.0.0.tgz
https://registry.npmjs.org/workbox-range-requests/-/workbox-range-requests-7.0.0.tgz -> npmpkg-workbox-range-requests-7.0.0.tgz
https://registry.npmjs.org/workbox-recipes/-/workbox-recipes-7.0.0.tgz -> npmpkg-workbox-recipes-7.0.0.tgz
https://registry.npmjs.org/workbox-routing/-/workbox-routing-7.0.0.tgz -> npmpkg-workbox-routing-7.0.0.tgz
https://registry.npmjs.org/workbox-strategies/-/workbox-strategies-7.0.0.tgz -> npmpkg-workbox-strategies-7.0.0.tgz
https://registry.npmjs.org/workbox-streams/-/workbox-streams-7.0.0.tgz -> npmpkg-workbox-streams-7.0.0.tgz
https://registry.npmjs.org/workbox-sw/-/workbox-sw-7.0.0.tgz -> npmpkg-workbox-sw-7.0.0.tgz
https://registry.npmjs.org/workbox-webpack-plugin/-/workbox-webpack-plugin-7.0.0.tgz -> npmpkg-workbox-webpack-plugin-7.0.0.tgz
https://registry.npmjs.org/webpack-sources/-/webpack-sources-1.4.3.tgz -> npmpkg-webpack-sources-1.4.3.tgz
https://registry.npmjs.org/workbox-window/-/workbox-window-7.0.0.tgz -> npmpkg-workbox-window-7.0.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/write-file-atomic/-/write-file-atomic-4.0.2.tgz -> npmpkg-write-file-atomic-4.0.2.tgz
https://registry.npmjs.org/ws/-/ws-8.14.2.tgz -> npmpkg-ws-8.14.2.tgz
https://registry.npmjs.org/xml-name-validator/-/xml-name-validator-4.0.0.tgz -> npmpkg-xml-name-validator-4.0.0.tgz
https://registry.npmjs.org/xmlchars/-/xmlchars-2.2.0.tgz -> npmpkg-xmlchars-2.2.0.tgz
https://registry.npmjs.org/xtend/-/xtend-4.0.2.tgz -> npmpkg-xtend-4.0.2.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yaeti/-/yaeti-0.0.6.tgz -> npmpkg-yaeti-0.0.6.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/yaml/-/yaml-1.10.2.tgz -> npmpkg-yaml-1.10.2.tgz
https://registry.npmjs.org/yargs/-/yargs-17.7.2.tgz -> npmpkg-yargs-17.7.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-21.1.1.tgz -> npmpkg-yargs-parser-21.1.1.tgz
https://registry.npmjs.org/yn/-/yn-3.1.1.tgz -> npmpkg-yn-3.1.1.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-0.1.0.tgz -> npmpkg-yocto-queue-0.1.0.tgz
https://registry.npmjs.org/@adobe/css-tools/-/css-tools-4.3.2.tgz -> npmpkg-@adobe-css-tools-4.3.2.tgz
https://registry.npmjs.org/@ampproject/remapping/-/remapping-2.2.1.tgz -> npmpkg-@ampproject-remapping-2.2.1.tgz
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.22.13.tgz -> npmpkg-@babel-code-frame-7.22.13.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/@babel/compat-data/-/compat-data-7.23.2.tgz -> npmpkg-@babel-compat-data-7.23.2.tgz
https://registry.npmjs.org/@babel/core/-/core-7.23.2.tgz -> npmpkg-@babel-core-7.23.2.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@babel/generator/-/generator-7.23.0.tgz -> npmpkg-@babel-generator-7.23.0.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.20.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.20.tgz
https://registry.npmjs.org/@babel/helper-annotate-as-pure/-/helper-annotate-as-pure-7.22.5.tgz -> npmpkg-@babel-helper-annotate-as-pure-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-builder-binary-assignment-operator-visitor/-/helper-builder-binary-assignment-operator-visitor-7.22.15.tgz -> npmpkg-@babel-helper-builder-binary-assignment-operator-visitor-7.22.15.tgz
https://registry.npmjs.org/@babel/helper-compilation-targets/-/helper-compilation-targets-7.22.15.tgz -> npmpkg-@babel-helper-compilation-targets-7.22.15.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-5.1.1.tgz -> npmpkg-lru-cache-5.1.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/yallist/-/yallist-3.1.1.tgz -> npmpkg-yallist-3.1.1.tgz
https://registry.npmjs.org/@babel/helper-create-class-features-plugin/-/helper-create-class-features-plugin-7.22.15.tgz -> npmpkg-@babel-helper-create-class-features-plugin-7.22.15.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@babel/helper-create-regexp-features-plugin/-/helper-create-regexp-features-plugin-7.22.15.tgz -> npmpkg-@babel-helper-create-regexp-features-plugin-7.22.15.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@babel/helper-define-polyfill-provider/-/helper-define-polyfill-provider-0.4.3.tgz -> npmpkg-@babel-helper-define-polyfill-provider-0.4.3.tgz
https://registry.npmjs.org/@babel/helper-environment-visitor/-/helper-environment-visitor-7.22.20.tgz -> npmpkg-@babel-helper-environment-visitor-7.22.20.tgz
https://registry.npmjs.org/@babel/helper-function-name/-/helper-function-name-7.23.0.tgz -> npmpkg-@babel-helper-function-name-7.23.0.tgz
https://registry.npmjs.org/@babel/helper-hoist-variables/-/helper-hoist-variables-7.22.5.tgz -> npmpkg-@babel-helper-hoist-variables-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-member-expression-to-functions/-/helper-member-expression-to-functions-7.23.0.tgz -> npmpkg-@babel-helper-member-expression-to-functions-7.23.0.tgz
https://registry.npmjs.org/@babel/helper-module-imports/-/helper-module-imports-7.22.15.tgz -> npmpkg-@babel-helper-module-imports-7.22.15.tgz
https://registry.npmjs.org/@babel/helper-module-transforms/-/helper-module-transforms-7.23.0.tgz -> npmpkg-@babel-helper-module-transforms-7.23.0.tgz
https://registry.npmjs.org/@babel/helper-optimise-call-expression/-/helper-optimise-call-expression-7.22.5.tgz -> npmpkg-@babel-helper-optimise-call-expression-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-plugin-utils/-/helper-plugin-utils-7.22.5.tgz -> npmpkg-@babel-helper-plugin-utils-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-remap-async-to-generator/-/helper-remap-async-to-generator-7.22.20.tgz -> npmpkg-@babel-helper-remap-async-to-generator-7.22.20.tgz
https://registry.npmjs.org/@babel/helper-replace-supers/-/helper-replace-supers-7.22.20.tgz -> npmpkg-@babel-helper-replace-supers-7.22.20.tgz
https://registry.npmjs.org/@babel/helper-simple-access/-/helper-simple-access-7.22.5.tgz -> npmpkg-@babel-helper-simple-access-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-skip-transparent-expression-wrappers/-/helper-skip-transparent-expression-wrappers-7.22.5.tgz -> npmpkg-@babel-helper-skip-transparent-expression-wrappers-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.22.6.tgz -> npmpkg-@babel-helper-split-export-declaration-7.22.6.tgz
https://registry.npmjs.org/@babel/helper-string-parser/-/helper-string-parser-7.22.5.tgz -> npmpkg-@babel-helper-string-parser-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.22.20.tgz -> npmpkg-@babel-helper-validator-identifier-7.22.20.tgz
https://registry.npmjs.org/@babel/helper-validator-option/-/helper-validator-option-7.22.15.tgz -> npmpkg-@babel-helper-validator-option-7.22.15.tgz
https://registry.npmjs.org/@babel/helper-wrap-function/-/helper-wrap-function-7.22.20.tgz -> npmpkg-@babel-helper-wrap-function-7.22.20.tgz
https://registry.npmjs.org/@babel/helpers/-/helpers-7.23.2.tgz -> npmpkg-@babel-helpers-7.23.2.tgz
https://registry.npmjs.org/@babel/highlight/-/highlight-7.22.20.tgz -> npmpkg-@babel-highlight-7.22.20.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/@babel/parser/-/parser-7.23.0.tgz -> npmpkg-@babel-parser-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-bugfix-safari-id-destructuring-collision-in-function-expression/-/plugin-bugfix-safari-id-destructuring-collision-in-function-expression-7.22.15.tgz -> npmpkg-@babel-plugin-bugfix-safari-id-destructuring-collision-in-function-expression-7.22.15.tgz
https://registry.npmjs.org/@babel/plugin-bugfix-v8-spread-parameters-in-optional-chaining/-/plugin-bugfix-v8-spread-parameters-in-optional-chaining-7.22.15.tgz -> npmpkg-@babel-plugin-bugfix-v8-spread-parameters-in-optional-chaining-7.22.15.tgz
https://registry.npmjs.org/@babel/plugin-proposal-private-property-in-object/-/plugin-proposal-private-property-in-object-7.21.0-placeholder-for-preset-env.2.tgz -> npmpkg-@babel-plugin-proposal-private-property-in-object-7.21.0-placeholder-for-preset-env.2.tgz
https://registry.npmjs.org/@babel/plugin-syntax-async-generators/-/plugin-syntax-async-generators-7.8.4.tgz -> npmpkg-@babel-plugin-syntax-async-generators-7.8.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-bigint/-/plugin-syntax-bigint-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-bigint-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-class-properties/-/plugin-syntax-class-properties-7.12.13.tgz -> npmpkg-@babel-plugin-syntax-class-properties-7.12.13.tgz
https://registry.npmjs.org/@babel/plugin-syntax-class-static-block/-/plugin-syntax-class-static-block-7.14.5.tgz -> npmpkg-@babel-plugin-syntax-class-static-block-7.14.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-dynamic-import/-/plugin-syntax-dynamic-import-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-dynamic-import-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-export-namespace-from/-/plugin-syntax-export-namespace-from-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-export-namespace-from-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-import-assertions/-/plugin-syntax-import-assertions-7.22.5.tgz -> npmpkg-@babel-plugin-syntax-import-assertions-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-import-attributes/-/plugin-syntax-import-attributes-7.22.5.tgz -> npmpkg-@babel-plugin-syntax-import-attributes-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-import-meta/-/plugin-syntax-import-meta-7.10.4.tgz -> npmpkg-@babel-plugin-syntax-import-meta-7.10.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-json-strings/-/plugin-syntax-json-strings-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-json-strings-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-jsx/-/plugin-syntax-jsx-7.23.3.tgz -> npmpkg-@babel-plugin-syntax-jsx-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-logical-assignment-operators/-/plugin-syntax-logical-assignment-operators-7.10.4.tgz -> npmpkg-@babel-plugin-syntax-logical-assignment-operators-7.10.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-nullish-coalescing-operator/-/plugin-syntax-nullish-coalescing-operator-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-nullish-coalescing-operator-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-numeric-separator/-/plugin-syntax-numeric-separator-7.10.4.tgz -> npmpkg-@babel-plugin-syntax-numeric-separator-7.10.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-object-rest-spread/-/plugin-syntax-object-rest-spread-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-object-rest-spread-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-optional-catch-binding/-/plugin-syntax-optional-catch-binding-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-optional-catch-binding-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-optional-chaining/-/plugin-syntax-optional-chaining-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-optional-chaining-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-private-property-in-object/-/plugin-syntax-private-property-in-object-7.14.5.tgz -> npmpkg-@babel-plugin-syntax-private-property-in-object-7.14.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-top-level-await/-/plugin-syntax-top-level-await-7.14.5.tgz -> npmpkg-@babel-plugin-syntax-top-level-await-7.14.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-typescript/-/plugin-syntax-typescript-7.23.3.tgz -> npmpkg-@babel-plugin-syntax-typescript-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-unicode-sets-regex/-/plugin-syntax-unicode-sets-regex-7.18.6.tgz -> npmpkg-@babel-plugin-syntax-unicode-sets-regex-7.18.6.tgz
https://registry.npmjs.org/@babel/plugin-transform-arrow-functions/-/plugin-transform-arrow-functions-7.22.5.tgz -> npmpkg-@babel-plugin-transform-arrow-functions-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-async-generator-functions/-/plugin-transform-async-generator-functions-7.23.2.tgz -> npmpkg-@babel-plugin-transform-async-generator-functions-7.23.2.tgz
https://registry.npmjs.org/@babel/plugin-transform-async-to-generator/-/plugin-transform-async-to-generator-7.22.5.tgz -> npmpkg-@babel-plugin-transform-async-to-generator-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-block-scoped-functions/-/plugin-transform-block-scoped-functions-7.22.5.tgz -> npmpkg-@babel-plugin-transform-block-scoped-functions-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-block-scoping/-/plugin-transform-block-scoping-7.23.0.tgz -> npmpkg-@babel-plugin-transform-block-scoping-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-class-properties/-/plugin-transform-class-properties-7.22.5.tgz -> npmpkg-@babel-plugin-transform-class-properties-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-class-static-block/-/plugin-transform-class-static-block-7.22.11.tgz -> npmpkg-@babel-plugin-transform-class-static-block-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-classes/-/plugin-transform-classes-7.22.15.tgz -> npmpkg-@babel-plugin-transform-classes-7.22.15.tgz
https://registry.npmjs.org/globals/-/globals-11.12.0.tgz -> npmpkg-globals-11.12.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-computed-properties/-/plugin-transform-computed-properties-7.22.5.tgz -> npmpkg-@babel-plugin-transform-computed-properties-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-destructuring/-/plugin-transform-destructuring-7.23.0.tgz -> npmpkg-@babel-plugin-transform-destructuring-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-dotall-regex/-/plugin-transform-dotall-regex-7.22.5.tgz -> npmpkg-@babel-plugin-transform-dotall-regex-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-duplicate-keys/-/plugin-transform-duplicate-keys-7.22.5.tgz -> npmpkg-@babel-plugin-transform-duplicate-keys-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-dynamic-import/-/plugin-transform-dynamic-import-7.22.11.tgz -> npmpkg-@babel-plugin-transform-dynamic-import-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-exponentiation-operator/-/plugin-transform-exponentiation-operator-7.22.5.tgz -> npmpkg-@babel-plugin-transform-exponentiation-operator-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-export-namespace-from/-/plugin-transform-export-namespace-from-7.22.11.tgz -> npmpkg-@babel-plugin-transform-export-namespace-from-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-for-of/-/plugin-transform-for-of-7.22.15.tgz -> npmpkg-@babel-plugin-transform-for-of-7.22.15.tgz
https://registry.npmjs.org/@babel/plugin-transform-function-name/-/plugin-transform-function-name-7.22.5.tgz -> npmpkg-@babel-plugin-transform-function-name-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-json-strings/-/plugin-transform-json-strings-7.22.11.tgz -> npmpkg-@babel-plugin-transform-json-strings-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-literals/-/plugin-transform-literals-7.22.5.tgz -> npmpkg-@babel-plugin-transform-literals-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-logical-assignment-operators/-/plugin-transform-logical-assignment-operators-7.22.11.tgz -> npmpkg-@babel-plugin-transform-logical-assignment-operators-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-member-expression-literals/-/plugin-transform-member-expression-literals-7.22.5.tgz -> npmpkg-@babel-plugin-transform-member-expression-literals-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-amd/-/plugin-transform-modules-amd-7.23.0.tgz -> npmpkg-@babel-plugin-transform-modules-amd-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-commonjs/-/plugin-transform-modules-commonjs-7.23.0.tgz -> npmpkg-@babel-plugin-transform-modules-commonjs-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-systemjs/-/plugin-transform-modules-systemjs-7.23.0.tgz -> npmpkg-@babel-plugin-transform-modules-systemjs-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-umd/-/plugin-transform-modules-umd-7.22.5.tgz -> npmpkg-@babel-plugin-transform-modules-umd-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-named-capturing-groups-regex/-/plugin-transform-named-capturing-groups-regex-7.22.5.tgz -> npmpkg-@babel-plugin-transform-named-capturing-groups-regex-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-new-target/-/plugin-transform-new-target-7.22.5.tgz -> npmpkg-@babel-plugin-transform-new-target-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-nullish-coalescing-operator/-/plugin-transform-nullish-coalescing-operator-7.22.11.tgz -> npmpkg-@babel-plugin-transform-nullish-coalescing-operator-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-numeric-separator/-/plugin-transform-numeric-separator-7.22.11.tgz -> npmpkg-@babel-plugin-transform-numeric-separator-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-object-rest-spread/-/plugin-transform-object-rest-spread-7.22.15.tgz -> npmpkg-@babel-plugin-transform-object-rest-spread-7.22.15.tgz
https://registry.npmjs.org/@babel/plugin-transform-object-super/-/plugin-transform-object-super-7.22.5.tgz -> npmpkg-@babel-plugin-transform-object-super-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-optional-catch-binding/-/plugin-transform-optional-catch-binding-7.22.11.tgz -> npmpkg-@babel-plugin-transform-optional-catch-binding-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-optional-chaining/-/plugin-transform-optional-chaining-7.23.0.tgz -> npmpkg-@babel-plugin-transform-optional-chaining-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-parameters/-/plugin-transform-parameters-7.22.15.tgz -> npmpkg-@babel-plugin-transform-parameters-7.22.15.tgz
https://registry.npmjs.org/@babel/plugin-transform-private-methods/-/plugin-transform-private-methods-7.22.5.tgz -> npmpkg-@babel-plugin-transform-private-methods-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-private-property-in-object/-/plugin-transform-private-property-in-object-7.22.11.tgz -> npmpkg-@babel-plugin-transform-private-property-in-object-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-property-literals/-/plugin-transform-property-literals-7.22.5.tgz -> npmpkg-@babel-plugin-transform-property-literals-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-regenerator/-/plugin-transform-regenerator-7.22.10.tgz -> npmpkg-@babel-plugin-transform-regenerator-7.22.10.tgz
https://registry.npmjs.org/@babel/plugin-transform-reserved-words/-/plugin-transform-reserved-words-7.22.5.tgz -> npmpkg-@babel-plugin-transform-reserved-words-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-shorthand-properties/-/plugin-transform-shorthand-properties-7.22.5.tgz -> npmpkg-@babel-plugin-transform-shorthand-properties-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-spread/-/plugin-transform-spread-7.22.5.tgz -> npmpkg-@babel-plugin-transform-spread-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-sticky-regex/-/plugin-transform-sticky-regex-7.22.5.tgz -> npmpkg-@babel-plugin-transform-sticky-regex-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-template-literals/-/plugin-transform-template-literals-7.22.5.tgz -> npmpkg-@babel-plugin-transform-template-literals-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-typeof-symbol/-/plugin-transform-typeof-symbol-7.22.5.tgz -> npmpkg-@babel-plugin-transform-typeof-symbol-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-escapes/-/plugin-transform-unicode-escapes-7.22.10.tgz -> npmpkg-@babel-plugin-transform-unicode-escapes-7.22.10.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-property-regex/-/plugin-transform-unicode-property-regex-7.22.5.tgz -> npmpkg-@babel-plugin-transform-unicode-property-regex-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-regex/-/plugin-transform-unicode-regex-7.22.5.tgz -> npmpkg-@babel-plugin-transform-unicode-regex-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-sets-regex/-/plugin-transform-unicode-sets-regex-7.22.5.tgz -> npmpkg-@babel-plugin-transform-unicode-sets-regex-7.22.5.tgz
https://registry.npmjs.org/@babel/preset-env/-/preset-env-7.23.2.tgz -> npmpkg-@babel-preset-env-7.23.2.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@babel/preset-modules/-/preset-modules-0.1.6-no-external-plugins.tgz -> npmpkg-@babel-preset-modules-0.1.6-no-external-plugins.tgz
https://registry.npmjs.org/@babel/regjsgen/-/regjsgen-0.8.0.tgz -> npmpkg-@babel-regjsgen-0.8.0.tgz
https://registry.npmjs.org/@babel/runtime/-/runtime-7.23.5.tgz -> npmpkg-@babel-runtime-7.23.5.tgz
https://registry.npmjs.org/@babel/template/-/template-7.22.15.tgz -> npmpkg-@babel-template-7.22.15.tgz
https://registry.npmjs.org/@babel/traverse/-/traverse-7.23.2.tgz -> npmpkg-@babel-traverse-7.23.2.tgz
https://registry.npmjs.org/globals/-/globals-11.12.0.tgz -> npmpkg-globals-11.12.0.tgz
https://registry.npmjs.org/@babel/types/-/types-7.23.0.tgz -> npmpkg-@babel-types-7.23.0.tgz
https://registry.npmjs.org/@bcoe/v8-coverage/-/v8-coverage-0.2.3.tgz -> npmpkg-@bcoe-v8-coverage-0.2.3.tgz
https://registry.npmjs.org/@charcoal-ui/foundation/-/foundation-2.10.0.tgz -> npmpkg-@charcoal-ui-foundation-2.10.0.tgz
https://registry.npmjs.org/@charcoal-ui/icon-files/-/icon-files-2.10.0.tgz -> npmpkg-@charcoal-ui-icon-files-2.10.0.tgz
https://registry.npmjs.org/@charcoal-ui/icons/-/icons-2.10.0.tgz -> npmpkg-@charcoal-ui-icons-2.10.0.tgz
https://registry.npmjs.org/@charcoal-ui/theme/-/theme-2.10.0.tgz -> npmpkg-@charcoal-ui-theme-2.10.0.tgz
https://registry.npmjs.org/@charcoal-ui/utils/-/utils-2.10.0.tgz -> npmpkg-@charcoal-ui-utils-2.10.0.tgz
https://registry.npmjs.org/@cspotcode/source-map-support/-/source-map-support-0.8.1.tgz -> npmpkg-@cspotcode-source-map-support-0.8.1.tgz
https://registry.npmjs.org/@ducanh2912/next-pwa/-/next-pwa-9.7.2.tgz -> npmpkg-@ducanh2912-next-pwa-9.7.2.tgz
https://registry.npmjs.org/@esbuild/android-arm/-/android-arm-0.19.8.tgz -> npmpkg-@esbuild-android-arm-0.19.8.tgz
https://registry.npmjs.org/@esbuild/android-arm64/-/android-arm64-0.19.8.tgz -> npmpkg-@esbuild-android-arm64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/android-x64/-/android-x64-0.19.8.tgz -> npmpkg-@esbuild-android-x64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/darwin-arm64/-/darwin-arm64-0.19.8.tgz -> npmpkg-@esbuild-darwin-arm64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/darwin-x64/-/darwin-x64-0.19.8.tgz -> npmpkg-@esbuild-darwin-x64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/freebsd-arm64/-/freebsd-arm64-0.19.8.tgz -> npmpkg-@esbuild-freebsd-arm64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/freebsd-x64/-/freebsd-x64-0.19.8.tgz -> npmpkg-@esbuild-freebsd-x64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/linux-arm/-/linux-arm-0.19.8.tgz -> npmpkg-@esbuild-linux-arm-0.19.8.tgz
https://registry.npmjs.org/@esbuild/linux-arm64/-/linux-arm64-0.19.8.tgz -> npmpkg-@esbuild-linux-arm64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/linux-ia32/-/linux-ia32-0.19.8.tgz -> npmpkg-@esbuild-linux-ia32-0.19.8.tgz
https://registry.npmjs.org/@esbuild/linux-loong64/-/linux-loong64-0.19.8.tgz -> npmpkg-@esbuild-linux-loong64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/linux-mips64el/-/linux-mips64el-0.19.8.tgz -> npmpkg-@esbuild-linux-mips64el-0.19.8.tgz
https://registry.npmjs.org/@esbuild/linux-ppc64/-/linux-ppc64-0.19.8.tgz -> npmpkg-@esbuild-linux-ppc64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/linux-riscv64/-/linux-riscv64-0.19.8.tgz -> npmpkg-@esbuild-linux-riscv64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/linux-s390x/-/linux-s390x-0.19.8.tgz -> npmpkg-@esbuild-linux-s390x-0.19.8.tgz
https://registry.npmjs.org/@esbuild/linux-x64/-/linux-x64-0.19.8.tgz -> npmpkg-@esbuild-linux-x64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/netbsd-x64/-/netbsd-x64-0.19.8.tgz -> npmpkg-@esbuild-netbsd-x64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/openbsd-x64/-/openbsd-x64-0.19.8.tgz -> npmpkg-@esbuild-openbsd-x64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/sunos-x64/-/sunos-x64-0.19.8.tgz -> npmpkg-@esbuild-sunos-x64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/win32-arm64/-/win32-arm64-0.19.8.tgz -> npmpkg-@esbuild-win32-arm64-0.19.8.tgz
https://registry.npmjs.org/@esbuild/win32-ia32/-/win32-ia32-0.19.8.tgz -> npmpkg-@esbuild-win32-ia32-0.19.8.tgz
https://registry.npmjs.org/@esbuild/win32-x64/-/win32-x64-0.19.8.tgz -> npmpkg-@esbuild-win32-x64-0.19.8.tgz
https://registry.npmjs.org/@eslint-community/eslint-utils/-/eslint-utils-4.4.0.tgz -> npmpkg-@eslint-community-eslint-utils-4.4.0.tgz
https://registry.npmjs.org/@eslint-community/regexpp/-/regexpp-4.4.1.tgz -> npmpkg-@eslint-community-regexpp-4.4.1.tgz
https://registry.npmjs.org/@eslint/eslintrc/-/eslintrc-2.0.1.tgz -> npmpkg-@eslint-eslintrc-2.0.1.tgz
https://registry.npmjs.org/@eslint/js/-/js-8.36.0.tgz -> npmpkg-@eslint-js-8.36.0.tgz
https://registry.npmjs.org/@gltf-transform/core/-/core-2.5.1.tgz -> npmpkg-@gltf-transform-core-2.5.1.tgz
https://registry.npmjs.org/@gulpjs/to-absolute-glob/-/to-absolute-glob-4.0.0.tgz -> npmpkg-@gulpjs-to-absolute-glob-4.0.0.tgz
https://registry.npmjs.org/@headlessui/react/-/react-1.7.17.tgz -> npmpkg-@headlessui-react-1.7.17.tgz
https://registry.npmjs.org/@heroicons/react/-/react-2.0.18.tgz -> npmpkg-@heroicons-react-2.0.18.tgz
https://registry.npmjs.org/@humanwhocodes/config-array/-/config-array-0.11.8.tgz -> npmpkg-@humanwhocodes-config-array-0.11.8.tgz
https://registry.npmjs.org/@humanwhocodes/module-importer/-/module-importer-1.0.1.tgz -> npmpkg-@humanwhocodes-module-importer-1.0.1.tgz
https://registry.npmjs.org/@humanwhocodes/object-schema/-/object-schema-1.2.1.tgz -> npmpkg-@humanwhocodes-object-schema-1.2.1.tgz
https://registry.npmjs.org/@istanbuljs/load-nyc-config/-/load-nyc-config-1.1.0.tgz -> npmpkg-@istanbuljs-load-nyc-config-1.1.0.tgz
https://registry.npmjs.org/argparse/-/argparse-1.0.10.tgz -> npmpkg-argparse-1.0.10.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-3.14.1.tgz -> npmpkg-js-yaml-3.14.1.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-5.0.0.tgz -> npmpkg-resolve-from-5.0.0.tgz
https://registry.npmjs.org/@istanbuljs/schema/-/schema-0.1.3.tgz -> npmpkg-@istanbuljs-schema-0.1.3.tgz
https://registry.npmjs.org/@jest/console/-/console-29.7.0.tgz -> npmpkg-@jest-console-29.7.0.tgz
https://registry.npmjs.org/@jest/core/-/core-29.7.0.tgz -> npmpkg-@jest-core-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.2.0.tgz -> npmpkg-react-is-18.2.0.tgz
https://registry.npmjs.org/@jest/environment/-/environment-29.7.0.tgz -> npmpkg-@jest-environment-29.7.0.tgz
https://registry.npmjs.org/@jest/expect/-/expect-29.7.0.tgz -> npmpkg-@jest-expect-29.7.0.tgz
https://registry.npmjs.org/@jest/expect-utils/-/expect-utils-29.7.0.tgz -> npmpkg-@jest-expect-utils-29.7.0.tgz
https://registry.npmjs.org/@jest/fake-timers/-/fake-timers-29.7.0.tgz -> npmpkg-@jest-fake-timers-29.7.0.tgz
https://registry.npmjs.org/@jest/globals/-/globals-29.7.0.tgz -> npmpkg-@jest-globals-29.7.0.tgz
https://registry.npmjs.org/@jest/reporters/-/reporters-29.7.0.tgz -> npmpkg-@jest-reporters-29.7.0.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.20.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.20.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-29.7.0.tgz -> npmpkg-jest-worker-29.7.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-8.1.1.tgz -> npmpkg-supports-color-8.1.1.tgz
https://registry.npmjs.org/@jest/schemas/-/schemas-29.6.3.tgz -> npmpkg-@jest-schemas-29.6.3.tgz
https://registry.npmjs.org/@jest/source-map/-/source-map-29.6.3.tgz -> npmpkg-@jest-source-map-29.6.3.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.20.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.20.tgz
https://registry.npmjs.org/@jest/test-result/-/test-result-29.7.0.tgz -> npmpkg-@jest-test-result-29.7.0.tgz
https://registry.npmjs.org/@jest/test-sequencer/-/test-sequencer-29.7.0.tgz -> npmpkg-@jest-test-sequencer-29.7.0.tgz
https://registry.npmjs.org/@jest/transform/-/transform-29.7.0.tgz -> npmpkg-@jest-transform-29.7.0.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.20.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.20.tgz
https://registry.npmjs.org/@jest/types/-/types-29.6.3.tgz -> npmpkg-@jest-types-29.6.3.tgz
https://registry.npmjs.org/@jridgewell/gen-mapping/-/gen-mapping-0.3.3.tgz -> npmpkg-@jridgewell-gen-mapping-0.3.3.tgz
https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.1.tgz -> npmpkg-@jridgewell-resolve-uri-3.1.1.tgz
https://registry.npmjs.org/@jridgewell/set-array/-/set-array-1.1.2.tgz -> npmpkg-@jridgewell-set-array-1.1.2.tgz
https://registry.npmjs.org/@jridgewell/source-map/-/source-map-0.3.5.tgz -> npmpkg-@jridgewell-source-map-0.3.5.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.15.tgz -> npmpkg-@jridgewell-sourcemap-codec-1.4.15.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.9.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.9.tgz
https://registry.npmjs.org/@next/env/-/env-13.5.6.tgz -> npmpkg-@next-env-13.5.6.tgz
https://registry.npmjs.org/@next/eslint-plugin-next/-/eslint-plugin-next-13.2.4.tgz -> npmpkg-@next-eslint-plugin-next-13.2.4.tgz
https://registry.npmjs.org/@next/swc-darwin-arm64/-/swc-darwin-arm64-13.5.6.tgz -> npmpkg-@next-swc-darwin-arm64-13.5.6.tgz
https://registry.npmjs.org/@next/swc-darwin-x64/-/swc-darwin-x64-13.5.6.tgz -> npmpkg-@next-swc-darwin-x64-13.5.6.tgz
https://registry.npmjs.org/@next/swc-linux-arm64-gnu/-/swc-linux-arm64-gnu-13.5.6.tgz -> npmpkg-@next-swc-linux-arm64-gnu-13.5.6.tgz
https://registry.npmjs.org/@next/swc-linux-arm64-musl/-/swc-linux-arm64-musl-13.5.6.tgz -> npmpkg-@next-swc-linux-arm64-musl-13.5.6.tgz
https://registry.npmjs.org/@next/swc-linux-x64-gnu/-/swc-linux-x64-gnu-13.5.6.tgz -> npmpkg-@next-swc-linux-x64-gnu-13.5.6.tgz
https://registry.npmjs.org/@next/swc-linux-x64-musl/-/swc-linux-x64-musl-13.5.6.tgz -> npmpkg-@next-swc-linux-x64-musl-13.5.6.tgz
https://registry.npmjs.org/@next/swc-win32-arm64-msvc/-/swc-win32-arm64-msvc-13.5.6.tgz -> npmpkg-@next-swc-win32-arm64-msvc-13.5.6.tgz
https://registry.npmjs.org/@next/swc-win32-ia32-msvc/-/swc-win32-ia32-msvc-13.5.6.tgz -> npmpkg-@next-swc-win32-ia32-msvc-13.5.6.tgz
https://registry.npmjs.org/@next/swc-win32-x64-msvc/-/swc-win32-x64-msvc-13.5.6.tgz -> npmpkg-@next-swc-win32-x64-msvc-13.5.6.tgz
https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> npmpkg-@nodelib-fs.scandir-2.1.5.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> npmpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> npmpkg-@nodelib-fs.walk-1.2.8.tgz
https://registry.npmjs.org/@pixiv/three-vrm/-/three-vrm-2.0.7.tgz -> npmpkg-@pixiv-three-vrm-2.0.7.tgz
https://registry.npmjs.org/@pixiv/three-vrm-core/-/three-vrm-core-2.0.7.tgz -> npmpkg-@pixiv-three-vrm-core-2.0.7.tgz
https://registry.npmjs.org/@pixiv/three-vrm-materials-hdr-emissive-multiplier/-/three-vrm-materials-hdr-emissive-multiplier-2.0.7.tgz -> npmpkg-@pixiv-three-vrm-materials-hdr-emissive-multiplier-2.0.7.tgz
https://registry.npmjs.org/@pixiv/three-vrm-materials-mtoon/-/three-vrm-materials-mtoon-2.0.7.tgz -> npmpkg-@pixiv-three-vrm-materials-mtoon-2.0.7.tgz
https://registry.npmjs.org/@pixiv/three-vrm-materials-v0compat/-/three-vrm-materials-v0compat-2.0.7.tgz -> npmpkg-@pixiv-three-vrm-materials-v0compat-2.0.7.tgz
https://registry.npmjs.org/@pixiv/three-vrm-node-constraint/-/three-vrm-node-constraint-2.0.7.tgz -> npmpkg-@pixiv-three-vrm-node-constraint-2.0.7.tgz
https://registry.npmjs.org/@pixiv/three-vrm-springbone/-/three-vrm-springbone-2.0.7.tgz -> npmpkg-@pixiv-three-vrm-springbone-2.0.7.tgz
https://registry.npmjs.org/@pixiv/types-vrm-0.0/-/types-vrm-0.0-2.0.7.tgz -> npmpkg-@pixiv-types-vrm-0.0-2.0.7.tgz
https://registry.npmjs.org/@pixiv/types-vrmc-materials-hdr-emissive-multiplier-1.0/-/types-vrmc-materials-hdr-emissive-multiplier-1.0-2.0.7.tgz -> npmpkg-@pixiv-types-vrmc-materials-hdr-emissive-multiplier-1.0-2.0.7.tgz
https://registry.npmjs.org/@pixiv/types-vrmc-materials-mtoon-1.0/-/types-vrmc-materials-mtoon-1.0-2.0.7.tgz -> npmpkg-@pixiv-types-vrmc-materials-mtoon-1.0-2.0.7.tgz
https://registry.npmjs.org/@pixiv/types-vrmc-node-constraint-1.0/-/types-vrmc-node-constraint-1.0-2.0.7.tgz -> npmpkg-@pixiv-types-vrmc-node-constraint-1.0-2.0.7.tgz
https://registry.npmjs.org/@pixiv/types-vrmc-springbone-1.0/-/types-vrmc-springbone-1.0-2.0.7.tgz -> npmpkg-@pixiv-types-vrmc-springbone-1.0-2.0.7.tgz
https://registry.npmjs.org/@pixiv/types-vrmc-vrm-1.0/-/types-vrmc-vrm-1.0-2.0.7.tgz -> npmpkg-@pixiv-types-vrmc-vrm-1.0-2.0.7.tgz
https://registry.npmjs.org/@pkgr/utils/-/utils-2.3.1.tgz -> npmpkg-@pkgr-utils-2.3.1.tgz
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
https://registry.npmjs.org/@ricky0123/vad-react/-/vad-react-0.0.17.tgz -> npmpkg-@ricky0123-vad-react-0.0.17.tgz
https://registry.npmjs.org/@ricky0123/vad-web/-/vad-web-0.0.12.tgz -> npmpkg-@ricky0123-vad-web-0.0.12.tgz
https://registry.npmjs.org/@rollup/plugin-babel/-/plugin-babel-5.3.1.tgz -> npmpkg-@rollup-plugin-babel-5.3.1.tgz
https://registry.npmjs.org/@rollup/plugin-node-resolve/-/plugin-node-resolve-11.2.1.tgz -> npmpkg-@rollup-plugin-node-resolve-11.2.1.tgz
https://registry.npmjs.org/@rollup/plugin-replace/-/plugin-replace-2.4.2.tgz -> npmpkg-@rollup-plugin-replace-2.4.2.tgz
https://registry.npmjs.org/@rollup/pluginutils/-/pluginutils-3.1.0.tgz -> npmpkg-@rollup-pluginutils-3.1.0.tgz
https://registry.npmjs.org/@types/estree/-/estree-0.0.39.tgz -> npmpkg-@types-estree-0.0.39.tgz
https://registry.npmjs.org/@rushstack/eslint-patch/-/eslint-patch-1.2.0.tgz -> npmpkg-@rushstack-eslint-patch-1.2.0.tgz
https://registry.npmjs.org/@sinclair/typebox/-/typebox-0.27.8.tgz -> npmpkg-@sinclair-typebox-0.27.8.tgz
https://registry.npmjs.org/@sinonjs/commons/-/commons-3.0.0.tgz -> npmpkg-@sinonjs-commons-3.0.0.tgz
https://registry.npmjs.org/@sinonjs/fake-timers/-/fake-timers-10.3.0.tgz -> npmpkg-@sinonjs-fake-timers-10.3.0.tgz
https://registry.npmjs.org/@supabase/functions-js/-/functions-js-2.1.5.tgz -> npmpkg-@supabase-functions-js-2.1.5.tgz
https://registry.npmjs.org/@supabase/gotrue-js/-/gotrue-js-2.57.1.tgz -> npmpkg-@supabase-gotrue-js-2.57.1.tgz
https://registry.npmjs.org/@supabase/node-fetch/-/node-fetch-2.6.15.tgz -> npmpkg-@supabase-node-fetch-2.6.15.tgz
https://registry.npmjs.org/tr46/-/tr46-0.0.3.tgz -> npmpkg-tr46-0.0.3.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-3.0.1.tgz -> npmpkg-webidl-conversions-3.0.1.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-5.0.0.tgz -> npmpkg-whatwg-url-5.0.0.tgz
https://registry.npmjs.org/@supabase/postgrest-js/-/postgrest-js-1.9.0.tgz -> npmpkg-@supabase-postgrest-js-1.9.0.tgz
https://registry.npmjs.org/@supabase/realtime-js/-/realtime-js-2.8.4.tgz -> npmpkg-@supabase-realtime-js-2.8.4.tgz
https://registry.npmjs.org/@supabase/storage-js/-/storage-js-2.5.5.tgz -> npmpkg-@supabase-storage-js-2.5.5.tgz
https://registry.npmjs.org/@supabase/supabase-js/-/supabase-js-2.39.0.tgz -> npmpkg-@supabase-supabase-js-2.39.0.tgz
https://registry.npmjs.org/@surma/rollup-plugin-off-main-thread/-/rollup-plugin-off-main-thread-2.2.3.tgz -> npmpkg-@surma-rollup-plugin-off-main-thread-2.2.3.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/@swc/helpers/-/helpers-0.5.2.tgz -> npmpkg-@swc-helpers-0.5.2.tgz
https://registry.npmjs.org/@tabler/icons/-/icons-3.11.0.tgz -> npmpkg-@tabler-icons-3.11.0.tgz
https://registry.npmjs.org/@tabler/icons-react/-/icons-react-3.11.0.tgz -> npmpkg-@tabler-icons-react-3.11.0.tgz
https://registry.npmjs.org/@tailwindcss/forms/-/forms-0.5.6.tgz -> npmpkg-@tailwindcss-forms-0.5.6.tgz
https://registry.npmjs.org/@tailwindcss/line-clamp/-/line-clamp-0.4.4.tgz -> npmpkg-@tailwindcss-line-clamp-0.4.4.tgz
https://registry.npmjs.org/@tauri-apps/api/-/api-1.5.3.tgz -> npmpkg-@tauri-apps-api-1.5.3.tgz
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
https://registry.npmjs.org/@testing-library/dom/-/dom-9.3.3.tgz -> npmpkg-@testing-library-dom-9.3.3.tgz
https://registry.npmjs.org/@testing-library/jest-dom/-/jest-dom-6.1.4.tgz -> npmpkg-@testing-library-jest-dom-6.1.4.tgz
https://registry.npmjs.org/chalk/-/chalk-3.0.0.tgz -> npmpkg-chalk-3.0.0.tgz
https://registry.npmjs.org/@testing-library/react/-/react-14.1.2.tgz -> npmpkg-@testing-library-react-14.1.2.tgz
https://registry.npmjs.org/@tootallnate/once/-/once-2.0.0.tgz -> npmpkg-@tootallnate-once-2.0.0.tgz
https://registry.npmjs.org/@tsconfig/node10/-/node10-1.0.9.tgz -> npmpkg-@tsconfig-node10-1.0.9.tgz
https://registry.npmjs.org/@tsconfig/node12/-/node12-1.0.11.tgz -> npmpkg-@tsconfig-node12-1.0.11.tgz
https://registry.npmjs.org/@tsconfig/node14/-/node14-1.0.3.tgz -> npmpkg-@tsconfig-node14-1.0.3.tgz
https://registry.npmjs.org/@tsconfig/node16/-/node16-1.0.4.tgz -> npmpkg-@tsconfig-node16-1.0.4.tgz
https://registry.npmjs.org/@tweenjs/tween.js/-/tween.js-18.6.4.tgz -> npmpkg-@tweenjs-tween.js-18.6.4.tgz
https://registry.npmjs.org/@types/aria-query/-/aria-query-5.0.4.tgz -> npmpkg-@types-aria-query-5.0.4.tgz
https://registry.npmjs.org/@types/babel__core/-/babel__core-7.20.5.tgz -> npmpkg-@types-babel__core-7.20.5.tgz
https://registry.npmjs.org/@types/babel__generator/-/babel__generator-7.6.7.tgz -> npmpkg-@types-babel__generator-7.6.7.tgz
https://registry.npmjs.org/@types/babel__template/-/babel__template-7.4.4.tgz -> npmpkg-@types-babel__template-7.4.4.tgz
https://registry.npmjs.org/@types/babel__traverse/-/babel__traverse-7.20.4.tgz -> npmpkg-@types-babel__traverse-7.20.4.tgz
https://registry.npmjs.org/@types/dom-speech-recognition/-/dom-speech-recognition-0.0.1.tgz -> npmpkg-@types-dom-speech-recognition-0.0.1.tgz
https://registry.npmjs.org/@types/eslint/-/eslint-8.44.6.tgz -> npmpkg-@types-eslint-8.44.6.tgz
https://registry.npmjs.org/@types/eslint-scope/-/eslint-scope-3.7.6.tgz -> npmpkg-@types-eslint-scope-3.7.6.tgz
https://registry.npmjs.org/@types/estree/-/estree-1.0.4.tgz -> npmpkg-@types-estree-1.0.4.tgz
https://registry.npmjs.org/@types/file-saver/-/file-saver-2.0.7.tgz -> npmpkg-@types-file-saver-2.0.7.tgz
https://registry.npmjs.org/@types/glob/-/glob-7.2.0.tgz -> npmpkg-@types-glob-7.2.0.tgz
https://registry.npmjs.org/@types/graceful-fs/-/graceful-fs-4.1.9.tgz -> npmpkg-@types-graceful-fs-4.1.9.tgz
https://registry.npmjs.org/@types/istanbul-lib-coverage/-/istanbul-lib-coverage-2.0.6.tgz -> npmpkg-@types-istanbul-lib-coverage-2.0.6.tgz
https://registry.npmjs.org/@types/istanbul-lib-report/-/istanbul-lib-report-3.0.3.tgz -> npmpkg-@types-istanbul-lib-report-3.0.3.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/jsdom/-/jsdom-20.0.1.tgz -> npmpkg-@types-jsdom-20.0.1.tgz
https://registry.npmjs.org/@types/json-schema/-/json-schema-7.0.14.tgz -> npmpkg-@types-json-schema-7.0.14.tgz
https://registry.npmjs.org/@types/json5/-/json5-0.0.29.tgz -> npmpkg-@types-json5-0.0.29.tgz
https://registry.npmjs.org/@types/long/-/long-4.0.2.tgz -> npmpkg-@types-long-4.0.2.tgz
https://registry.npmjs.org/@types/minimatch/-/minimatch-5.1.2.tgz -> npmpkg-@types-minimatch-5.1.2.tgz
https://registry.npmjs.org/@types/node/-/node-18.15.10.tgz -> npmpkg-@types-node-18.15.10.tgz
https://registry.npmjs.org/@types/phoenix/-/phoenix-1.6.4.tgz -> npmpkg-@types-phoenix-1.6.4.tgz
https://registry.npmjs.org/@types/prop-types/-/prop-types-15.7.5.tgz -> npmpkg-@types-prop-types-15.7.5.tgz
https://registry.npmjs.org/@types/react/-/react-18.0.29.tgz -> npmpkg-@types-react-18.0.29.tgz
https://registry.npmjs.org/@types/react-dom/-/react-dom-18.0.11.tgz -> npmpkg-@types-react-dom-18.0.11.tgz
https://registry.npmjs.org/@types/resolve/-/resolve-1.17.1.tgz -> npmpkg-@types-resolve-1.17.1.tgz
https://registry.npmjs.org/@types/scheduler/-/scheduler-0.16.3.tgz -> npmpkg-@types-scheduler-0.16.3.tgz
https://registry.npmjs.org/@types/stack-utils/-/stack-utils-2.0.3.tgz -> npmpkg-@types-stack-utils-2.0.3.tgz
https://registry.npmjs.org/@types/stats.js/-/stats.js-0.17.3.tgz -> npmpkg-@types-stats.js-0.17.3.tgz
https://registry.npmjs.org/@types/symlink-or-copy/-/symlink-or-copy-1.2.2.tgz -> npmpkg-@types-symlink-or-copy-1.2.2.tgz
https://registry.npmjs.org/@types/three/-/three-0.154.0.tgz -> npmpkg-@types-three-0.154.0.tgz
https://registry.npmjs.org/@types/tough-cookie/-/tough-cookie-4.0.5.tgz -> npmpkg-@types-tough-cookie-4.0.5.tgz
https://registry.npmjs.org/@types/trusted-types/-/trusted-types-2.0.5.tgz -> npmpkg-@types-trusted-types-2.0.5.tgz
https://registry.npmjs.org/@types/websocket/-/websocket-1.0.10.tgz -> npmpkg-@types-websocket-1.0.10.tgz
https://registry.npmjs.org/@types/webxr/-/webxr-0.5.10.tgz -> npmpkg-@types-webxr-0.5.10.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-17.0.32.tgz -> npmpkg-@types-yargs-17.0.32.tgz
https://registry.npmjs.org/@types/yargs-parser/-/yargs-parser-21.0.3.tgz -> npmpkg-@types-yargs-parser-21.0.3.tgz
https://registry.npmjs.org/@typescript-eslint/parser/-/parser-5.56.0.tgz -> npmpkg-@typescript-eslint-parser-5.56.0.tgz
https://registry.npmjs.org/@typescript-eslint/scope-manager/-/scope-manager-5.56.0.tgz -> npmpkg-@typescript-eslint-scope-manager-5.56.0.tgz
https://registry.npmjs.org/@typescript-eslint/types/-/types-5.56.0.tgz -> npmpkg-@typescript-eslint-types-5.56.0.tgz
https://registry.npmjs.org/@typescript-eslint/typescript-estree/-/typescript-estree-5.56.0.tgz -> npmpkg-@typescript-eslint-typescript-estree-5.56.0.tgz
https://registry.npmjs.org/@typescript-eslint/visitor-keys/-/visitor-keys-5.56.0.tgz -> npmpkg-@typescript-eslint-visitor-keys-5.56.0.tgz
https://registry.npmjs.org/@webassemblyjs/ast/-/ast-1.11.6.tgz -> npmpkg-@webassemblyjs-ast-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/floating-point-hex-parser/-/floating-point-hex-parser-1.11.6.tgz -> npmpkg-@webassemblyjs-floating-point-hex-parser-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/helper-api-error/-/helper-api-error-1.11.6.tgz -> npmpkg-@webassemblyjs-helper-api-error-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/helper-buffer/-/helper-buffer-1.11.6.tgz -> npmpkg-@webassemblyjs-helper-buffer-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/helper-numbers/-/helper-numbers-1.11.6.tgz -> npmpkg-@webassemblyjs-helper-numbers-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/helper-wasm-bytecode/-/helper-wasm-bytecode-1.11.6.tgz -> npmpkg-@webassemblyjs-helper-wasm-bytecode-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/helper-wasm-section/-/helper-wasm-section-1.11.6.tgz -> npmpkg-@webassemblyjs-helper-wasm-section-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/ieee754/-/ieee754-1.11.6.tgz -> npmpkg-@webassemblyjs-ieee754-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/leb128/-/leb128-1.11.6.tgz -> npmpkg-@webassemblyjs-leb128-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/utf8/-/utf8-1.11.6.tgz -> npmpkg-@webassemblyjs-utf8-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-edit/-/wasm-edit-1.11.6.tgz -> npmpkg-@webassemblyjs-wasm-edit-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-gen/-/wasm-gen-1.11.6.tgz -> npmpkg-@webassemblyjs-wasm-gen-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-opt/-/wasm-opt-1.11.6.tgz -> npmpkg-@webassemblyjs-wasm-opt-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-parser/-/wasm-parser-1.11.6.tgz -> npmpkg-@webassemblyjs-wasm-parser-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/wast-printer/-/wast-printer-1.11.6.tgz -> npmpkg-@webassemblyjs-wast-printer-1.11.6.tgz
https://registry.npmjs.org/@xenova/transformers/-/transformers-2.7.0.tgz -> npmpkg-@xenova-transformers-2.7.0.tgz
https://registry.npmjs.org/@xtuc/ieee754/-/ieee754-1.2.0.tgz -> npmpkg-@xtuc-ieee754-1.2.0.tgz
https://registry.npmjs.org/@xtuc/long/-/long-4.2.2.tgz -> npmpkg-@xtuc-long-4.2.2.tgz
https://registry.npmjs.org/abab/-/abab-2.0.6.tgz -> npmpkg-abab-2.0.6.tgz
https://registry.npmjs.org/acorn/-/acorn-8.8.2.tgz -> npmpkg-acorn-8.8.2.tgz
https://registry.npmjs.org/acorn-globals/-/acorn-globals-7.0.1.tgz -> npmpkg-acorn-globals-7.0.1.tgz
https://registry.npmjs.org/acorn-import-assertions/-/acorn-import-assertions-1.9.0.tgz -> npmpkg-acorn-import-assertions-1.9.0.tgz
https://registry.npmjs.org/acorn-jsx/-/acorn-jsx-5.3.2.tgz -> npmpkg-acorn-jsx-5.3.2.tgz
https://registry.npmjs.org/acorn-walk/-/acorn-walk-8.3.0.tgz -> npmpkg-acorn-walk-8.3.0.tgz
https://registry.npmjs.org/agent-base/-/agent-base-6.0.2.tgz -> npmpkg-agent-base-6.0.2.tgz
https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz -> npmpkg-ajv-6.12.6.tgz
https://registry.npmjs.org/ajv-formats/-/ajv-formats-2.1.1.tgz -> npmpkg-ajv-formats-2.1.1.tgz
https://registry.npmjs.org/ajv/-/ajv-8.12.0.tgz -> npmpkg-ajv-8.12.0.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> npmpkg-json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-3.5.2.tgz -> npmpkg-ajv-keywords-3.5.2.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-4.3.2.tgz -> npmpkg-ansi-escapes-4.3.2.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.21.3.tgz -> npmpkg-type-fest-0.21.3.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/any-promise/-/any-promise-1.3.0.tgz -> npmpkg-any-promise-1.3.0.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz -> npmpkg-anymatch-3.1.3.tgz
https://registry.npmjs.org/arg/-/arg-5.0.2.tgz -> npmpkg-arg-5.0.2.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz -> npmpkg-argparse-2.0.1.tgz
https://registry.npmjs.org/aria-query/-/aria-query-5.1.3.tgz -> npmpkg-aria-query-5.1.3.tgz
https://registry.npmjs.org/array-buffer-byte-length/-/array-buffer-byte-length-1.0.0.tgz -> npmpkg-array-buffer-byte-length-1.0.0.tgz
https://registry.npmjs.org/array-includes/-/array-includes-3.1.6.tgz -> npmpkg-array-includes-3.1.6.tgz
https://registry.npmjs.org/array-union/-/array-union-2.1.0.tgz -> npmpkg-array-union-2.1.0.tgz
https://registry.npmjs.org/array-uniq/-/array-uniq-1.0.3.tgz -> npmpkg-array-uniq-1.0.3.tgz
https://registry.npmjs.org/array.prototype.flat/-/array.prototype.flat-1.3.1.tgz -> npmpkg-array.prototype.flat-1.3.1.tgz
https://registry.npmjs.org/array.prototype.flatmap/-/array.prototype.flatmap-1.3.1.tgz -> npmpkg-array.prototype.flatmap-1.3.1.tgz
https://registry.npmjs.org/array.prototype.tosorted/-/array.prototype.tosorted-1.1.1.tgz -> npmpkg-array.prototype.tosorted-1.1.1.tgz
https://registry.npmjs.org/ast-types-flow/-/ast-types-flow-0.0.7.tgz -> npmpkg-ast-types-flow-0.0.7.tgz
https://registry.npmjs.org/async/-/async-3.2.5.tgz -> npmpkg-async-3.2.5.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz -> npmpkg-asynckit-0.4.0.tgz
https://registry.npmjs.org/at-least-node/-/at-least-node-1.0.0.tgz -> npmpkg-at-least-node-1.0.0.tgz
https://registry.npmjs.org/autoprefixer/-/autoprefixer-10.4.14.tgz -> npmpkg-autoprefixer-10.4.14.tgz
https://registry.npmjs.org/available-typed-arrays/-/available-typed-arrays-1.0.5.tgz -> npmpkg-available-typed-arrays-1.0.5.tgz
https://registry.npmjs.org/axe-core/-/axe-core-4.6.3.tgz -> npmpkg-axe-core-4.6.3.tgz
https://registry.npmjs.org/axobject-query/-/axobject-query-3.1.1.tgz -> npmpkg-axobject-query-3.1.1.tgz
https://registry.npmjs.org/b4a/-/b4a-1.6.4.tgz -> npmpkg-b4a-1.6.4.tgz
https://registry.npmjs.org/babel-jest/-/babel-jest-29.7.0.tgz -> npmpkg-babel-jest-29.7.0.tgz
https://registry.npmjs.org/babel-plugin-istanbul/-/babel-plugin-istanbul-6.1.1.tgz -> npmpkg-babel-plugin-istanbul-6.1.1.tgz
https://registry.npmjs.org/istanbul-lib-instrument/-/istanbul-lib-instrument-5.2.1.tgz -> npmpkg-istanbul-lib-instrument-5.2.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/babel-plugin-jest-hoist/-/babel-plugin-jest-hoist-29.6.3.tgz -> npmpkg-babel-plugin-jest-hoist-29.6.3.tgz
https://registry.npmjs.org/babel-plugin-polyfill-corejs2/-/babel-plugin-polyfill-corejs2-0.4.6.tgz -> npmpkg-babel-plugin-polyfill-corejs2-0.4.6.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/babel-plugin-polyfill-corejs3/-/babel-plugin-polyfill-corejs3-0.8.6.tgz -> npmpkg-babel-plugin-polyfill-corejs3-0.8.6.tgz
https://registry.npmjs.org/babel-plugin-polyfill-regenerator/-/babel-plugin-polyfill-regenerator-0.5.3.tgz -> npmpkg-babel-plugin-polyfill-regenerator-0.5.3.tgz
https://registry.npmjs.org/babel-preset-current-node-syntax/-/babel-preset-current-node-syntax-1.0.1.tgz -> npmpkg-babel-preset-current-node-syntax-1.0.1.tgz
https://registry.npmjs.org/babel-preset-jest/-/babel-preset-jest-29.6.3.tgz -> npmpkg-babel-preset-jest-29.6.3.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz -> npmpkg-balanced-match-1.0.2.tgz
https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz -> npmpkg-base64-js-1.5.1.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.2.0.tgz -> npmpkg-binary-extensions-2.2.0.tgz
https://registry.npmjs.org/bl/-/bl-4.1.0.tgz -> npmpkg-bl-4.1.0.tgz
https://registry.npmjs.org/boolbase/-/boolbase-1.0.0.tgz -> npmpkg-boolbase-1.0.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/braces/-/braces-3.0.2.tgz -> npmpkg-braces-3.0.2.tgz
https://registry.npmjs.org/broccoli-node-api/-/broccoli-node-api-1.7.0.tgz -> npmpkg-broccoli-node-api-1.7.0.tgz
https://registry.npmjs.org/broccoli-node-info/-/broccoli-node-info-2.2.0.tgz -> npmpkg-broccoli-node-info-2.2.0.tgz
https://registry.npmjs.org/broccoli-output-wrapper/-/broccoli-output-wrapper-3.2.5.tgz -> npmpkg-broccoli-output-wrapper-3.2.5.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz -> npmpkg-universalify-0.1.2.tgz
https://registry.npmjs.org/broccoli-plugin/-/broccoli-plugin-4.0.7.tgz -> npmpkg-broccoli-plugin-4.0.7.tgz
https://registry.npmjs.org/browserslist/-/browserslist-4.22.1.tgz -> npmpkg-browserslist-4.22.1.tgz
https://registry.npmjs.org/bser/-/bser-2.1.1.tgz -> npmpkg-bser-2.1.1.tgz
https://registry.npmjs.org/buffer/-/buffer-5.7.1.tgz -> npmpkg-buffer-5.7.1.tgz
https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.2.tgz -> npmpkg-buffer-from-1.1.2.tgz
https://registry.npmjs.org/bufferutil/-/bufferutil-4.0.8.tgz -> npmpkg-bufferutil-4.0.8.tgz
https://registry.npmjs.org/builtin-modules/-/builtin-modules-3.3.0.tgz -> npmpkg-builtin-modules-3.3.0.tgz
https://registry.npmjs.org/busboy/-/busboy-1.6.0.tgz -> npmpkg-busboy-1.6.0.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.2.tgz -> npmpkg-call-bind-1.0.2.tgz
https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz -> npmpkg-callsites-3.1.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/camelcase-css/-/camelcase-css-2.0.1.tgz -> npmpkg-camelcase-css-2.0.1.tgz
https://registry.npmjs.org/caniuse-lite/-/caniuse-lite-1.0.30001561.tgz -> npmpkg-caniuse-lite-1.0.30001561.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/char-regex/-/char-regex-1.0.2.tgz -> npmpkg-char-regex-1.0.2.tgz
https://registry.npmjs.org/cheerio/-/cheerio-1.0.0-rc.12.tgz -> npmpkg-cheerio-1.0.0-rc.12.tgz
https://registry.npmjs.org/cheerio-select/-/cheerio-select-2.1.0.tgz -> npmpkg-cheerio-select-2.1.0.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.5.3.tgz -> npmpkg-chokidar-3.5.3.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/chownr/-/chownr-1.1.4.tgz -> npmpkg-chownr-1.1.4.tgz
https://registry.npmjs.org/chrome-trace-event/-/chrome-trace-event-1.0.3.tgz -> npmpkg-chrome-trace-event-1.0.3.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/cjs-module-lexer/-/cjs-module-lexer-1.2.3.tgz -> npmpkg-cjs-module-lexer-1.2.3.tgz
https://registry.npmjs.org/clean-webpack-plugin/-/clean-webpack-plugin-4.0.0.tgz -> npmpkg-clean-webpack-plugin-4.0.0.tgz
https://registry.npmjs.org/client-only/-/client-only-0.0.1.tgz -> npmpkg-client-only-0.0.1.tgz
https://registry.npmjs.org/cliui/-/cliui-8.0.1.tgz -> npmpkg-cliui-8.0.1.tgz
https://registry.npmjs.org/clone/-/clone-2.1.2.tgz -> npmpkg-clone-2.1.2.tgz
https://registry.npmjs.org/clone-stats/-/clone-stats-1.0.0.tgz -> npmpkg-clone-stats-1.0.0.tgz
https://registry.npmjs.org/clsx/-/clsx-2.0.0.tgz -> npmpkg-clsx-2.0.0.tgz
https://registry.npmjs.org/co/-/co-4.6.0.tgz -> npmpkg-co-4.6.0.tgz
https://registry.npmjs.org/collect-v8-coverage/-/collect-v8-coverage-1.0.2.tgz -> npmpkg-collect-v8-coverage-1.0.2.tgz
https://registry.npmjs.org/color/-/color-4.2.3.tgz -> npmpkg-color-4.2.3.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/color-string/-/color-string-1.9.1.tgz -> npmpkg-color-string-1.9.1.tgz
https://registry.npmjs.org/colors/-/colors-1.4.0.tgz -> npmpkg-colors-1.4.0.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz -> npmpkg-combined-stream-1.0.8.tgz
https://registry.npmjs.org/commander/-/commander-4.1.1.tgz -> npmpkg-commander-4.1.1.tgz
https://registry.npmjs.org/common-tags/-/common-tags-1.8.2.tgz -> npmpkg-common-tags-1.8.2.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-2.0.0.tgz -> npmpkg-convert-source-map-2.0.0.tgz
https://registry.npmjs.org/copy-webpack-plugin/-/copy-webpack-plugin-11.0.0.tgz -> npmpkg-copy-webpack-plugin-11.0.0.tgz
https://registry.npmjs.org/ajv/-/ajv-8.12.0.tgz -> npmpkg-ajv-8.12.0.tgz
https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-5.1.0.tgz -> npmpkg-ajv-keywords-5.1.0.tgz
https://registry.npmjs.org/globby/-/globby-13.2.2.tgz -> npmpkg-globby-13.2.2.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> npmpkg-json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-4.2.0.tgz -> npmpkg-schema-utils-4.2.0.tgz
https://registry.npmjs.org/slash/-/slash-4.0.0.tgz -> npmpkg-slash-4.0.0.tgz
https://registry.npmjs.org/core-js-compat/-/core-js-compat-3.33.2.tgz -> npmpkg-core-js-compat-3.33.2.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.3.tgz -> npmpkg-core-util-is-1.0.3.tgz
https://registry.npmjs.org/create-jest/-/create-jest-29.7.0.tgz -> npmpkg-create-jest-29.7.0.tgz
https://registry.npmjs.org/create-require/-/create-require-1.1.1.tgz -> npmpkg-create-require-1.1.1.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/crypto-random-string/-/crypto-random-string-2.0.0.tgz -> npmpkg-crypto-random-string-2.0.0.tgz
https://registry.npmjs.org/css-select/-/css-select-5.1.0.tgz -> npmpkg-css-select-5.1.0.tgz
https://registry.npmjs.org/css-what/-/css-what-6.1.0.tgz -> npmpkg-css-what-6.1.0.tgz
https://registry.npmjs.org/css.escape/-/css.escape-1.5.1.tgz -> npmpkg-css.escape-1.5.1.tgz
https://registry.npmjs.org/cssesc/-/cssesc-3.0.0.tgz -> npmpkg-cssesc-3.0.0.tgz
https://registry.npmjs.org/cssom/-/cssom-0.5.0.tgz -> npmpkg-cssom-0.5.0.tgz
https://registry.npmjs.org/cssstyle/-/cssstyle-2.3.0.tgz -> npmpkg-cssstyle-2.3.0.tgz
https://registry.npmjs.org/cssom/-/cssom-0.3.8.tgz -> npmpkg-cssom-0.3.8.tgz
https://registry.npmjs.org/csstype/-/csstype-3.1.2.tgz -> npmpkg-csstype-3.1.2.tgz
https://registry.npmjs.org/d/-/d-1.0.1.tgz -> npmpkg-d-1.0.1.tgz
https://registry.npmjs.org/damerau-levenshtein/-/damerau-levenshtein-1.0.8.tgz -> npmpkg-damerau-levenshtein-1.0.8.tgz
https://registry.npmjs.org/data-urls/-/data-urls-3.0.2.tgz -> npmpkg-data-urls-3.0.2.tgz
https://registry.npmjs.org/tr46/-/tr46-3.0.0.tgz -> npmpkg-tr46-3.0.0.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-7.0.0.tgz -> npmpkg-webidl-conversions-7.0.0.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-11.0.0.tgz -> npmpkg-whatwg-url-11.0.0.tgz
https://registry.npmjs.org/de-indent/-/de-indent-1.0.2.tgz -> npmpkg-de-indent-1.0.2.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/decimal.js/-/decimal.js-10.4.3.tgz -> npmpkg-decimal.js-10.4.3.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-6.0.0.tgz -> npmpkg-decompress-response-6.0.0.tgz
https://registry.npmjs.org/dedent/-/dedent-1.5.1.tgz -> npmpkg-dedent-1.5.1.tgz
https://registry.npmjs.org/deep-equal/-/deep-equal-2.2.0.tgz -> npmpkg-deep-equal-2.2.0.tgz
https://registry.npmjs.org/deep-extend/-/deep-extend-0.6.0.tgz -> npmpkg-deep-extend-0.6.0.tgz
https://registry.npmjs.org/deep-is/-/deep-is-0.1.4.tgz -> npmpkg-deep-is-0.1.4.tgz
https://registry.npmjs.org/deepmerge/-/deepmerge-4.3.1.tgz -> npmpkg-deepmerge-4.3.1.tgz
https://registry.npmjs.org/define-lazy-prop/-/define-lazy-prop-2.0.0.tgz -> npmpkg-define-lazy-prop-2.0.0.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.2.0.tgz -> npmpkg-define-properties-1.2.0.tgz
https://registry.npmjs.org/del/-/del-4.1.1.tgz -> npmpkg-del-4.1.1.tgz
https://registry.npmjs.org/array-union/-/array-union-1.0.2.tgz -> npmpkg-array-union-1.0.2.tgz
https://registry.npmjs.org/globby/-/globby-6.1.0.tgz -> npmpkg-globby-6.1.0.tgz
https://registry.npmjs.org/pify/-/pify-2.3.0.tgz -> npmpkg-pify-2.3.0.tgz
https://registry.npmjs.org/pify/-/pify-4.0.1.tgz -> npmpkg-pify-4.0.1.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.7.1.tgz -> npmpkg-rimraf-2.7.1.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz -> npmpkg-delayed-stream-1.0.0.tgz
https://registry.npmjs.org/detect-libc/-/detect-libc-2.0.2.tgz -> npmpkg-detect-libc-2.0.2.tgz
https://registry.npmjs.org/detect-newline/-/detect-newline-3.1.0.tgz -> npmpkg-detect-newline-3.1.0.tgz
https://registry.npmjs.org/dexie/-/dexie-4.0.4.tgz -> npmpkg-dexie-4.0.4.tgz
https://registry.npmjs.org/dexie-react-hooks/-/dexie-react-hooks-1.1.7.tgz -> npmpkg-dexie-react-hooks-1.1.7.tgz
https://registry.npmjs.org/didyoumean/-/didyoumean-1.2.2.tgz -> npmpkg-didyoumean-1.2.2.tgz
https://registry.npmjs.org/diff/-/diff-4.0.2.tgz -> npmpkg-diff-4.0.2.tgz
https://registry.npmjs.org/diff-sequences/-/diff-sequences-29.6.3.tgz -> npmpkg-diff-sequences-29.6.3.tgz
https://registry.npmjs.org/dir-glob/-/dir-glob-3.0.1.tgz -> npmpkg-dir-glob-3.0.1.tgz
https://registry.npmjs.org/dlv/-/dlv-1.1.3.tgz -> npmpkg-dlv-1.1.3.tgz
https://registry.npmjs.org/doctrine/-/doctrine-3.0.0.tgz -> npmpkg-doctrine-3.0.0.tgz
https://registry.npmjs.org/dom-accessibility-api/-/dom-accessibility-api-0.5.16.tgz -> npmpkg-dom-accessibility-api-0.5.16.tgz
https://registry.npmjs.org/dom-serializer/-/dom-serializer-2.0.0.tgz -> npmpkg-dom-serializer-2.0.0.tgz
https://registry.npmjs.org/domelementtype/-/domelementtype-2.3.0.tgz -> npmpkg-domelementtype-2.3.0.tgz
https://registry.npmjs.org/domexception/-/domexception-4.0.0.tgz -> npmpkg-domexception-4.0.0.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-7.0.0.tgz -> npmpkg-webidl-conversions-7.0.0.tgz
https://registry.npmjs.org/domhandler/-/domhandler-5.0.3.tgz -> npmpkg-domhandler-5.0.3.tgz
https://registry.npmjs.org/dompurify/-/dompurify-2.4.5.tgz -> npmpkg-dompurify-2.4.5.tgz
https://registry.npmjs.org/domutils/-/domutils-3.1.0.tgz -> npmpkg-domutils-3.1.0.tgz
https://registry.npmjs.org/ejs/-/ejs-3.1.9.tgz -> npmpkg-ejs-3.1.9.tgz
https://registry.npmjs.org/electron-to-chromium/-/electron-to-chromium-1.4.576.tgz -> npmpkg-electron-to-chromium-1.4.576.tgz
https://registry.npmjs.org/emittery/-/emittery-0.13.1.tgz -> npmpkg-emittery-0.13.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-9.2.2.tgz -> npmpkg-emoji-regex-9.2.2.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz -> npmpkg-end-of-stream-1.4.4.tgz
https://registry.npmjs.org/enhanced-resolve/-/enhanced-resolve-5.15.0.tgz -> npmpkg-enhanced-resolve-5.15.0.tgz
https://registry.npmjs.org/ensure-posix-path/-/ensure-posix-path-1.1.1.tgz -> npmpkg-ensure-posix-path-1.1.1.tgz
https://registry.npmjs.org/entities/-/entities-4.5.0.tgz -> npmpkg-entities-4.5.0.tgz
https://registry.npmjs.org/eol/-/eol-0.9.1.tgz -> npmpkg-eol-0.9.1.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.2.tgz -> npmpkg-error-ex-1.3.2.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz -> npmpkg-is-arrayish-0.2.1.tgz
https://registry.npmjs.org/es-abstract/-/es-abstract-1.21.2.tgz -> npmpkg-es-abstract-1.21.2.tgz
https://registry.npmjs.org/es-get-iterator/-/es-get-iterator-1.1.3.tgz -> npmpkg-es-get-iterator-1.1.3.tgz
https://registry.npmjs.org/es-module-lexer/-/es-module-lexer-1.3.1.tgz -> npmpkg-es-module-lexer-1.3.1.tgz
https://registry.npmjs.org/es-set-tostringtag/-/es-set-tostringtag-2.0.1.tgz -> npmpkg-es-set-tostringtag-2.0.1.tgz
https://registry.npmjs.org/es-shim-unscopables/-/es-shim-unscopables-1.0.0.tgz -> npmpkg-es-shim-unscopables-1.0.0.tgz
https://registry.npmjs.org/es-to-primitive/-/es-to-primitive-1.2.1.tgz -> npmpkg-es-to-primitive-1.2.1.tgz
https://registry.npmjs.org/es5-ext/-/es5-ext-0.10.62.tgz -> npmpkg-es5-ext-0.10.62.tgz
https://registry.npmjs.org/es6-iterator/-/es6-iterator-2.0.3.tgz -> npmpkg-es6-iterator-2.0.3.tgz
https://registry.npmjs.org/es6-symbol/-/es6-symbol-3.1.3.tgz -> npmpkg-es6-symbol-3.1.3.tgz
https://registry.npmjs.org/esbuild/-/esbuild-0.19.8.tgz -> npmpkg-esbuild-0.19.8.tgz
https://registry.npmjs.org/escalade/-/escalade-3.1.1.tgz -> npmpkg-escalade-3.1.1.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> npmpkg-escape-string-regexp-4.0.0.tgz
https://registry.npmjs.org/escodegen/-/escodegen-2.1.0.tgz -> npmpkg-escodegen-2.1.0.tgz
https://registry.npmjs.org/eslint/-/eslint-8.36.0.tgz -> npmpkg-eslint-8.36.0.tgz
https://registry.npmjs.org/eslint-config-next/-/eslint-config-next-13.2.4.tgz -> npmpkg-eslint-config-next-13.2.4.tgz
https://registry.npmjs.org/eslint-import-resolver-node/-/eslint-import-resolver-node-0.3.7.tgz -> npmpkg-eslint-import-resolver-node-0.3.7.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/eslint-import-resolver-typescript/-/eslint-import-resolver-typescript-3.5.3.tgz -> npmpkg-eslint-import-resolver-typescript-3.5.3.tgz
https://registry.npmjs.org/globby/-/globby-13.1.3.tgz -> npmpkg-globby-13.1.3.tgz
https://registry.npmjs.org/slash/-/slash-4.0.0.tgz -> npmpkg-slash-4.0.0.tgz
https://registry.npmjs.org/eslint-module-utils/-/eslint-module-utils-2.7.4.tgz -> npmpkg-eslint-module-utils-2.7.4.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/eslint-plugin-import/-/eslint-plugin-import-2.27.5.tgz -> npmpkg-eslint-plugin-import-2.27.5.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/doctrine/-/doctrine-2.1.0.tgz -> npmpkg-doctrine-2.1.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/eslint-plugin-jsx-a11y/-/eslint-plugin-jsx-a11y-6.7.1.tgz -> npmpkg-eslint-plugin-jsx-a11y-6.7.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/eslint-plugin-react/-/eslint-plugin-react-7.32.2.tgz -> npmpkg-eslint-plugin-react-7.32.2.tgz
https://registry.npmjs.org/doctrine/-/doctrine-2.1.0.tgz -> npmpkg-doctrine-2.1.0.tgz
https://registry.npmjs.org/resolve/-/resolve-2.0.0-next.4.tgz -> npmpkg-resolve-2.0.0-next.4.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/eslint-plugin-react-hooks/-/eslint-plugin-react-hooks-4.6.0.tgz -> npmpkg-eslint-plugin-react-hooks-4.6.0.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-7.1.1.tgz -> npmpkg-eslint-scope-7.1.1.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-3.3.0.tgz -> npmpkg-eslint-visitor-keys-3.3.0.tgz
https://registry.npmjs.org/espree/-/espree-9.5.0.tgz -> npmpkg-espree-9.5.0.tgz
https://registry.npmjs.org/esprima/-/esprima-4.0.1.tgz -> npmpkg-esprima-4.0.1.tgz
https://registry.npmjs.org/esquery/-/esquery-1.5.0.tgz -> npmpkg-esquery-1.5.0.tgz
https://registry.npmjs.org/esrecurse/-/esrecurse-4.3.0.tgz -> npmpkg-esrecurse-4.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/estree-walker/-/estree-walker-1.0.1.tgz -> npmpkg-estree-walker-1.0.1.tgz
https://registry.npmjs.org/esutils/-/esutils-2.0.3.tgz -> npmpkg-esutils-2.0.3.tgz
https://registry.npmjs.org/events/-/events-3.3.0.tgz -> npmpkg-events-3.3.0.tgz
https://registry.npmjs.org/execa/-/execa-5.1.1.tgz -> npmpkg-execa-5.1.1.tgz
https://registry.npmjs.org/exit/-/exit-0.1.2.tgz -> npmpkg-exit-0.1.2.tgz
https://registry.npmjs.org/expand-template/-/expand-template-2.0.3.tgz -> npmpkg-expand-template-2.0.3.tgz
https://registry.npmjs.org/expect/-/expect-29.7.0.tgz -> npmpkg-expect-29.7.0.tgz
https://registry.npmjs.org/ext/-/ext-1.7.0.tgz -> npmpkg-ext-1.7.0.tgz
https://registry.npmjs.org/type/-/type-2.7.2.tgz -> npmpkg-type-2.7.2.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> npmpkg-fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-fifo/-/fast-fifo-1.3.2.tgz -> npmpkg-fast-fifo-1.3.2.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.1.tgz -> npmpkg-fast-glob-3.3.1.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> npmpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.npmjs.org/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz -> npmpkg-fast-levenshtein-2.0.6.tgz
https://registry.npmjs.org/fastq/-/fastq-1.15.0.tgz -> npmpkg-fastq-1.15.0.tgz
https://registry.npmjs.org/fb-watchman/-/fb-watchman-2.0.2.tgz -> npmpkg-fb-watchman-2.0.2.tgz
https://registry.npmjs.org/fflate/-/fflate-0.6.10.tgz -> npmpkg-fflate-0.6.10.tgz
https://registry.npmjs.org/file-entry-cache/-/file-entry-cache-6.0.1.tgz -> npmpkg-file-entry-cache-6.0.1.tgz
https://registry.npmjs.org/file-saver/-/file-saver-2.0.5.tgz -> npmpkg-file-saver-2.0.5.tgz
https://registry.npmjs.org/filelist/-/filelist-1.0.4.tgz -> npmpkg-filelist-1.0.4.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/filepond/-/filepond-4.30.4.tgz -> npmpkg-filepond-4.30.4.tgz
https://registry.npmjs.org/filepond-plugin-file-validate-type/-/filepond-plugin-file-validate-type-1.2.8.tgz -> npmpkg-filepond-plugin-file-validate-type-1.2.8.tgz
https://registry.npmjs.org/filepond-plugin-image-preview/-/filepond-plugin-image-preview-4.6.11.tgz -> npmpkg-filepond-plugin-image-preview-4.6.11.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.0.1.tgz -> npmpkg-fill-range-7.0.1.tgz
https://registry.npmjs.org/find-up/-/find-up-5.0.0.tgz -> npmpkg-find-up-5.0.0.tgz
https://registry.npmjs.org/flat-cache/-/flat-cache-3.0.4.tgz -> npmpkg-flat-cache-3.0.4.tgz
https://registry.npmjs.org/flatbuffers/-/flatbuffers-1.12.0.tgz -> npmpkg-flatbuffers-1.12.0.tgz
https://registry.npmjs.org/flatted/-/flatted-3.2.7.tgz -> npmpkg-flatted-3.2.7.tgz
https://registry.npmjs.org/for-each/-/for-each-0.3.3.tgz -> npmpkg-for-each-0.3.3.tgz
https://registry.npmjs.org/form-data/-/form-data-4.0.0.tgz -> npmpkg-form-data-4.0.0.tgz
https://registry.npmjs.org/fraction.js/-/fraction.js-4.2.0.tgz -> npmpkg-fraction.js-4.2.0.tgz
https://registry.npmjs.org/fs-constants/-/fs-constants-1.0.0.tgz -> npmpkg-fs-constants-1.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/fs-merger/-/fs-merger-3.2.1.tgz -> npmpkg-fs-merger-3.2.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz -> npmpkg-universalify-0.1.2.tgz
https://registry.npmjs.org/fs-mkdirp-stream/-/fs-mkdirp-stream-2.0.1.tgz -> npmpkg-fs-mkdirp-stream-2.0.1.tgz
https://registry.npmjs.org/fs-tree-diff/-/fs-tree-diff-2.0.1.tgz -> npmpkg-fs-tree-diff-2.0.1.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.2.tgz -> npmpkg-fsevents-2.3.2.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.1.tgz -> npmpkg-function-bind-1.1.1.tgz
https://registry.npmjs.org/function.prototype.name/-/function.prototype.name-1.1.5.tgz -> npmpkg-function.prototype.name-1.1.5.tgz
https://registry.npmjs.org/functions-have-names/-/functions-have-names-1.2.3.tgz -> npmpkg-functions-have-names-1.2.3.tgz
https://registry.npmjs.org/gensync/-/gensync-1.0.0-beta.2.tgz -> npmpkg-gensync-1.0.0-beta.2.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz -> npmpkg-get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.0.tgz -> npmpkg-get-intrinsic-1.2.0.tgz
https://registry.npmjs.org/get-own-enumerable-property-symbols/-/get-own-enumerable-property-symbols-3.0.2.tgz -> npmpkg-get-own-enumerable-property-symbols-3.0.2.tgz
https://registry.npmjs.org/get-package-type/-/get-package-type-0.1.0.tgz -> npmpkg-get-package-type-0.1.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-6.0.1.tgz -> npmpkg-get-stream-6.0.1.tgz
https://registry.npmjs.org/get-symbol-description/-/get-symbol-description-1.0.0.tgz -> npmpkg-get-symbol-description-1.0.0.tgz
https://registry.npmjs.org/get-tsconfig/-/get-tsconfig-4.5.0.tgz -> npmpkg-get-tsconfig-4.5.0.tgz
https://registry.npmjs.org/github-from-package/-/github-from-package-0.0.0.tgz -> npmpkg-github-from-package-0.0.0.tgz
https://registry.npmjs.org/gl-matrix/-/gl-matrix-3.4.3.tgz -> npmpkg-gl-matrix-3.4.3.tgz
https://registry.npmjs.org/glob/-/glob-7.1.7.tgz -> npmpkg-glob-7.1.7.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-6.0.2.tgz -> npmpkg-glob-parent-6.0.2.tgz
https://registry.npmjs.org/glob-stream/-/glob-stream-8.0.0.tgz -> npmpkg-glob-stream-8.0.0.tgz
https://registry.npmjs.org/glob-to-regexp/-/glob-to-regexp-0.4.1.tgz -> npmpkg-glob-to-regexp-0.4.1.tgz
https://registry.npmjs.org/globals/-/globals-13.20.0.tgz -> npmpkg-globals-13.20.0.tgz
https://registry.npmjs.org/globalthis/-/globalthis-1.0.3.tgz -> npmpkg-globalthis-1.0.3.tgz
https://registry.npmjs.org/globalyzer/-/globalyzer-0.1.0.tgz -> npmpkg-globalyzer-0.1.0.tgz
https://registry.npmjs.org/globby/-/globby-11.1.0.tgz -> npmpkg-globby-11.1.0.tgz
https://registry.npmjs.org/globrex/-/globrex-0.1.2.tgz -> npmpkg-globrex-0.1.2.tgz
https://registry.npmjs.org/gopd/-/gopd-1.0.1.tgz -> npmpkg-gopd-1.0.1.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz -> npmpkg-graceful-fs-4.2.11.tgz
https://registry.npmjs.org/grapheme-splitter/-/grapheme-splitter-1.0.4.tgz -> npmpkg-grapheme-splitter-1.0.4.tgz
https://registry.npmjs.org/guid-typescript/-/guid-typescript-1.0.9.tgz -> npmpkg-guid-typescript-1.0.9.tgz
https://registry.npmjs.org/gulp-sort/-/gulp-sort-2.0.0.tgz -> npmpkg-gulp-sort-2.0.0.tgz
https://registry.npmjs.org/has/-/has-1.0.3.tgz -> npmpkg-has-1.0.3.tgz
https://registry.npmjs.org/has-bigints/-/has-bigints-1.0.2.tgz -> npmpkg-has-bigints-1.0.2.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.0.tgz -> npmpkg-has-property-descriptors-1.0.0.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.1.tgz -> npmpkg-has-proto-1.0.1.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/has-tostringtag/-/has-tostringtag-1.0.0.tgz -> npmpkg-has-tostringtag-1.0.0.tgz
https://registry.npmjs.org/he/-/he-1.2.0.tgz -> npmpkg-he-1.2.0.tgz
https://registry.npmjs.org/heimdalljs/-/heimdalljs-0.2.6.tgz -> npmpkg-heimdalljs-0.2.6.tgz
https://registry.npmjs.org/rsvp/-/rsvp-3.2.1.tgz -> npmpkg-rsvp-3.2.1.tgz
https://registry.npmjs.org/heimdalljs-logger/-/heimdalljs-logger-0.1.10.tgz -> npmpkg-heimdalljs-logger-0.1.10.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/html-encoding-sniffer/-/html-encoding-sniffer-3.0.0.tgz -> npmpkg-html-encoding-sniffer-3.0.0.tgz
https://registry.npmjs.org/html-escaper/-/html-escaper-2.0.2.tgz -> npmpkg-html-escaper-2.0.2.tgz
https://registry.npmjs.org/html-parse-stringify/-/html-parse-stringify-3.0.1.tgz -> npmpkg-html-parse-stringify-3.0.1.tgz
https://registry.npmjs.org/htmlparser2/-/htmlparser2-8.0.2.tgz -> npmpkg-htmlparser2-8.0.2.tgz
https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-5.0.0.tgz -> npmpkg-http-proxy-agent-5.0.0.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz -> npmpkg-https-proxy-agent-5.0.1.tgz
https://registry.npmjs.org/human-signals/-/human-signals-2.1.0.tgz -> npmpkg-human-signals-2.1.0.tgz
https://registry.npmjs.org/i18next/-/i18next-23.7.7.tgz -> npmpkg-i18next-23.7.7.tgz
https://registry.npmjs.org/i18next-browser-languagedetector/-/i18next-browser-languagedetector-7.2.0.tgz -> npmpkg-i18next-browser-languagedetector-7.2.0.tgz
https://registry.npmjs.org/i18next-parser/-/i18next-parser-8.9.0.tgz -> npmpkg-i18next-parser-8.9.0.tgz
https://registry.npmjs.org/commander/-/commander-11.0.0.tgz -> npmpkg-commander-11.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-11.2.0.tgz -> npmpkg-fs-extra-11.2.0.tgz
https://registry.npmjs.org/typescript/-/typescript-5.3.2.tgz -> npmpkg-typescript-5.3.2.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz -> npmpkg-iconv-lite-0.6.3.tgz
https://registry.npmjs.org/idb/-/idb-7.1.1.tgz -> npmpkg-idb-7.1.1.tgz
https://registry.npmjs.org/ieee754/-/ieee754-1.2.1.tgz -> npmpkg-ieee754-1.2.1.tgz
https://registry.npmjs.org/ignore/-/ignore-5.2.4.tgz -> npmpkg-ignore-5.2.4.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/import-local/-/import-local-3.1.0.tgz -> npmpkg-import-local-3.1.0.tgz
https://registry.npmjs.org/imurmurhash/-/imurmurhash-0.1.4.tgz -> npmpkg-imurmurhash-0.1.4.tgz
https://registry.npmjs.org/indent-string/-/indent-string-4.0.0.tgz -> npmpkg-indent-string-4.0.0.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/internal-slot/-/internal-slot-1.0.5.tgz -> npmpkg-internal-slot-1.0.5.tgz
https://registry.npmjs.org/is-arguments/-/is-arguments-1.1.1.tgz -> npmpkg-is-arguments-1.1.1.tgz
https://registry.npmjs.org/is-array-buffer/-/is-array-buffer-3.0.2.tgz -> npmpkg-is-array-buffer-3.0.2.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.3.2.tgz -> npmpkg-is-arrayish-0.3.2.tgz
https://registry.npmjs.org/is-bigint/-/is-bigint-1.0.4.tgz -> npmpkg-is-bigint-1.0.4.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz -> npmpkg-is-binary-path-2.1.0.tgz
https://registry.npmjs.org/is-boolean-object/-/is-boolean-object-1.1.2.tgz -> npmpkg-is-boolean-object-1.1.2.tgz
https://registry.npmjs.org/is-callable/-/is-callable-1.2.7.tgz -> npmpkg-is-callable-1.2.7.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.11.0.tgz -> npmpkg-is-core-module-2.11.0.tgz
https://registry.npmjs.org/is-date-object/-/is-date-object-1.0.5.tgz -> npmpkg-is-date-object-1.0.5.tgz
https://registry.npmjs.org/is-docker/-/is-docker-2.2.1.tgz -> npmpkg-is-docker-2.2.1.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-generator-fn/-/is-generator-fn-2.1.0.tgz -> npmpkg-is-generator-fn-2.1.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/is-map/-/is-map-2.0.2.tgz -> npmpkg-is-map-2.0.2.tgz
https://registry.npmjs.org/is-module/-/is-module-1.0.0.tgz -> npmpkg-is-module-1.0.0.tgz
https://registry.npmjs.org/is-negated-glob/-/is-negated-glob-1.0.0.tgz -> npmpkg-is-negated-glob-1.0.0.tgz
https://registry.npmjs.org/is-negative-zero/-/is-negative-zero-2.0.2.tgz -> npmpkg-is-negative-zero-2.0.2.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/is-number-object/-/is-number-object-1.0.7.tgz -> npmpkg-is-number-object-1.0.7.tgz
https://registry.npmjs.org/is-obj/-/is-obj-1.0.1.tgz -> npmpkg-is-obj-1.0.1.tgz
https://registry.npmjs.org/is-path-cwd/-/is-path-cwd-2.2.0.tgz -> npmpkg-is-path-cwd-2.2.0.tgz
https://registry.npmjs.org/is-path-in-cwd/-/is-path-in-cwd-2.1.0.tgz -> npmpkg-is-path-in-cwd-2.1.0.tgz
https://registry.npmjs.org/is-path-inside/-/is-path-inside-2.1.0.tgz -> npmpkg-is-path-inside-2.1.0.tgz
https://registry.npmjs.org/is-path-inside/-/is-path-inside-3.0.3.tgz -> npmpkg-is-path-inside-3.0.3.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-4.1.0.tgz -> npmpkg-is-plain-obj-4.1.0.tgz
https://registry.npmjs.org/is-potential-custom-element-name/-/is-potential-custom-element-name-1.0.1.tgz -> npmpkg-is-potential-custom-element-name-1.0.1.tgz
https://registry.npmjs.org/is-regex/-/is-regex-1.1.4.tgz -> npmpkg-is-regex-1.1.4.tgz
https://registry.npmjs.org/is-regexp/-/is-regexp-1.0.0.tgz -> npmpkg-is-regexp-1.0.0.tgz
https://registry.npmjs.org/is-set/-/is-set-2.0.2.tgz -> npmpkg-is-set-2.0.2.tgz
https://registry.npmjs.org/is-shared-array-buffer/-/is-shared-array-buffer-1.0.2.tgz -> npmpkg-is-shared-array-buffer-1.0.2.tgz
https://registry.npmjs.org/is-stream/-/is-stream-2.0.1.tgz -> npmpkg-is-stream-2.0.1.tgz
https://registry.npmjs.org/is-string/-/is-string-1.0.7.tgz -> npmpkg-is-string-1.0.7.tgz
https://registry.npmjs.org/is-symbol/-/is-symbol-1.0.4.tgz -> npmpkg-is-symbol-1.0.4.tgz
https://registry.npmjs.org/is-typed-array/-/is-typed-array-1.1.10.tgz -> npmpkg-is-typed-array-1.1.10.tgz
https://registry.npmjs.org/is-typedarray/-/is-typedarray-1.0.0.tgz -> npmpkg-is-typedarray-1.0.0.tgz
https://registry.npmjs.org/is-valid-glob/-/is-valid-glob-1.0.0.tgz -> npmpkg-is-valid-glob-1.0.0.tgz
https://registry.npmjs.org/is-weakmap/-/is-weakmap-2.0.1.tgz -> npmpkg-is-weakmap-2.0.1.tgz
https://registry.npmjs.org/is-weakref/-/is-weakref-1.0.2.tgz -> npmpkg-is-weakref-1.0.2.tgz
https://registry.npmjs.org/is-weakset/-/is-weakset-2.0.2.tgz -> npmpkg-is-weakset-2.0.2.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-2.2.0.tgz -> npmpkg-is-wsl-2.2.0.tgz
https://registry.npmjs.org/isarray/-/isarray-2.0.5.tgz -> npmpkg-isarray-2.0.5.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/istanbul-lib-coverage/-/istanbul-lib-coverage-3.2.2.tgz -> npmpkg-istanbul-lib-coverage-3.2.2.tgz
https://registry.npmjs.org/istanbul-lib-instrument/-/istanbul-lib-instrument-6.0.1.tgz -> npmpkg-istanbul-lib-instrument-6.0.1.tgz
https://registry.npmjs.org/istanbul-lib-report/-/istanbul-lib-report-3.0.1.tgz -> npmpkg-istanbul-lib-report-3.0.1.tgz
https://registry.npmjs.org/istanbul-lib-source-maps/-/istanbul-lib-source-maps-4.0.1.tgz -> npmpkg-istanbul-lib-source-maps-4.0.1.tgz
https://registry.npmjs.org/istanbul-reports/-/istanbul-reports-3.1.6.tgz -> npmpkg-istanbul-reports-3.1.6.tgz
https://registry.npmjs.org/jake/-/jake-10.8.7.tgz -> npmpkg-jake-10.8.7.tgz
https://registry.npmjs.org/jest/-/jest-29.7.0.tgz -> npmpkg-jest-29.7.0.tgz
https://registry.npmjs.org/jest-changed-files/-/jest-changed-files-29.7.0.tgz -> npmpkg-jest-changed-files-29.7.0.tgz
https://registry.npmjs.org/jest-circus/-/jest-circus-29.7.0.tgz -> npmpkg-jest-circus-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.2.0.tgz -> npmpkg-react-is-18.2.0.tgz
https://registry.npmjs.org/jest-cli/-/jest-cli-29.7.0.tgz -> npmpkg-jest-cli-29.7.0.tgz
https://registry.npmjs.org/jest-config/-/jest-config-29.7.0.tgz -> npmpkg-jest-config-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.2.0.tgz -> npmpkg-react-is-18.2.0.tgz
https://registry.npmjs.org/jest-diff/-/jest-diff-29.7.0.tgz -> npmpkg-jest-diff-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.2.0.tgz -> npmpkg-react-is-18.2.0.tgz
https://registry.npmjs.org/jest-docblock/-/jest-docblock-29.7.0.tgz -> npmpkg-jest-docblock-29.7.0.tgz
https://registry.npmjs.org/jest-each/-/jest-each-29.7.0.tgz -> npmpkg-jest-each-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.2.0.tgz -> npmpkg-react-is-18.2.0.tgz
https://registry.npmjs.org/jest-environment-jsdom/-/jest-environment-jsdom-29.7.0.tgz -> npmpkg-jest-environment-jsdom-29.7.0.tgz
https://registry.npmjs.org/jest-environment-node/-/jest-environment-node-29.7.0.tgz -> npmpkg-jest-environment-node-29.7.0.tgz
https://registry.npmjs.org/jest-get-type/-/jest-get-type-29.6.3.tgz -> npmpkg-jest-get-type-29.6.3.tgz
https://registry.npmjs.org/jest-haste-map/-/jest-haste-map-29.7.0.tgz -> npmpkg-jest-haste-map-29.7.0.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-29.7.0.tgz -> npmpkg-jest-worker-29.7.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-8.1.1.tgz -> npmpkg-supports-color-8.1.1.tgz
https://registry.npmjs.org/jest-leak-detector/-/jest-leak-detector-29.7.0.tgz -> npmpkg-jest-leak-detector-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.2.0.tgz -> npmpkg-react-is-18.2.0.tgz
https://registry.npmjs.org/jest-matcher-utils/-/jest-matcher-utils-29.7.0.tgz -> npmpkg-jest-matcher-utils-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.2.0.tgz -> npmpkg-react-is-18.2.0.tgz
https://registry.npmjs.org/jest-message-util/-/jest-message-util-29.7.0.tgz -> npmpkg-jest-message-util-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.2.0.tgz -> npmpkg-react-is-18.2.0.tgz
https://registry.npmjs.org/jest-mock/-/jest-mock-29.7.0.tgz -> npmpkg-jest-mock-29.7.0.tgz
https://registry.npmjs.org/jest-pnp-resolver/-/jest-pnp-resolver-1.2.3.tgz -> npmpkg-jest-pnp-resolver-1.2.3.tgz
https://registry.npmjs.org/jest-regex-util/-/jest-regex-util-29.6.3.tgz -> npmpkg-jest-regex-util-29.6.3.tgz
https://registry.npmjs.org/jest-resolve/-/jest-resolve-29.7.0.tgz -> npmpkg-jest-resolve-29.7.0.tgz
https://registry.npmjs.org/jest-resolve-dependencies/-/jest-resolve-dependencies-29.7.0.tgz -> npmpkg-jest-resolve-dependencies-29.7.0.tgz
https://registry.npmjs.org/jest-runner/-/jest-runner-29.7.0.tgz -> npmpkg-jest-runner-29.7.0.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-29.7.0.tgz -> npmpkg-jest-worker-29.7.0.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.13.tgz -> npmpkg-source-map-support-0.5.13.tgz
https://registry.npmjs.org/supports-color/-/supports-color-8.1.1.tgz -> npmpkg-supports-color-8.1.1.tgz
https://registry.npmjs.org/jest-runtime/-/jest-runtime-29.7.0.tgz -> npmpkg-jest-runtime-29.7.0.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-4.0.0.tgz -> npmpkg-strip-bom-4.0.0.tgz
https://registry.npmjs.org/jest-snapshot/-/jest-snapshot-29.7.0.tgz -> npmpkg-jest-snapshot-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.2.0.tgz -> npmpkg-react-is-18.2.0.tgz
https://registry.npmjs.org/jest-util/-/jest-util-29.7.0.tgz -> npmpkg-jest-util-29.7.0.tgz
https://registry.npmjs.org/jest-validate/-/jest-validate-29.7.0.tgz -> npmpkg-jest-validate-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-6.3.0.tgz -> npmpkg-camelcase-6.3.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.2.0.tgz -> npmpkg-react-is-18.2.0.tgz
https://registry.npmjs.org/jest-watcher/-/jest-watcher-29.7.0.tgz -> npmpkg-jest-watcher-29.7.0.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-27.5.1.tgz -> npmpkg-jest-worker-27.5.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-8.1.1.tgz -> npmpkg-supports-color-8.1.1.tgz
https://registry.npmjs.org/jiti/-/jiti-1.18.2.tgz -> npmpkg-jiti-1.18.2.tgz
https://registry.npmjs.org/js-sdsl/-/js-sdsl-4.4.0.tgz -> npmpkg-js-sdsl-4.4.0.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz -> npmpkg-js-tokens-4.0.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz -> npmpkg-js-yaml-4.1.0.tgz
https://registry.npmjs.org/jsdom/-/jsdom-20.0.3.tgz -> npmpkg-jsdom-20.0.3.tgz
https://registry.npmjs.org/tr46/-/tr46-3.0.0.tgz -> npmpkg-tr46-3.0.0.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-7.0.0.tgz -> npmpkg-webidl-conversions-7.0.0.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-11.0.0.tgz -> npmpkg-whatwg-url-11.0.0.tgz
https://registry.npmjs.org/jsesc/-/jsesc-2.5.2.tgz -> npmpkg-jsesc-2.5.2.tgz
https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz -> npmpkg-json-parse-even-better-errors-2.3.1.tgz
https://registry.npmjs.org/json-schema/-/json-schema-0.4.0.tgz -> npmpkg-json-schema-0.4.0.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> npmpkg-json-schema-traverse-0.4.1.tgz
https://registry.npmjs.org/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> npmpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/jsonpointer/-/jsonpointer-5.0.1.tgz -> npmpkg-jsonpointer-5.0.1.tgz
https://registry.npmjs.org/jsx-ast-utils/-/jsx-ast-utils-3.3.3.tgz -> npmpkg-jsx-ast-utils-3.3.3.tgz
https://registry.npmjs.org/kleur/-/kleur-3.0.3.tgz -> npmpkg-kleur-3.0.3.tgz
https://registry.npmjs.org/language-subtag-registry/-/language-subtag-registry-0.3.22.tgz -> npmpkg-language-subtag-registry-0.3.22.tgz
https://registry.npmjs.org/language-tags/-/language-tags-1.0.5.tgz -> npmpkg-language-tags-1.0.5.tgz
https://registry.npmjs.org/lead/-/lead-4.0.0.tgz -> npmpkg-lead-4.0.0.tgz
https://registry.npmjs.org/leven/-/leven-3.1.0.tgz -> npmpkg-leven-3.1.0.tgz
https://registry.npmjs.org/levn/-/levn-0.4.1.tgz -> npmpkg-levn-0.4.1.tgz
https://registry.npmjs.org/lil-gui/-/lil-gui-0.17.0.tgz -> npmpkg-lil-gui-0.17.0.tgz
https://registry.npmjs.org/lilconfig/-/lilconfig-2.1.0.tgz -> npmpkg-lilconfig-2.1.0.tgz
https://registry.npmjs.org/lines-and-columns/-/lines-and-columns-1.2.4.tgz -> npmpkg-lines-and-columns-1.2.4.tgz
https://registry.npmjs.org/loader-runner/-/loader-runner-4.3.0.tgz -> npmpkg-loader-runner-4.3.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-6.0.0.tgz -> npmpkg-locate-path-6.0.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lodash.debounce/-/lodash.debounce-4.0.8.tgz -> npmpkg-lodash.debounce-4.0.8.tgz
https://registry.npmjs.org/lodash.merge/-/lodash.merge-4.6.2.tgz -> npmpkg-lodash.merge-4.6.2.tgz
https://registry.npmjs.org/lodash.sortby/-/lodash.sortby-4.7.0.tgz -> npmpkg-lodash.sortby-4.7.0.tgz
https://registry.npmjs.org/long/-/long-4.0.0.tgz -> npmpkg-long-4.0.0.tgz
https://registry.npmjs.org/loose-envify/-/loose-envify-1.4.0.tgz -> npmpkg-loose-envify-1.4.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/lz-string/-/lz-string-1.5.0.tgz -> npmpkg-lz-string-1.5.0.tgz
https://registry.npmjs.org/magic-string/-/magic-string-0.25.9.tgz -> npmpkg-magic-string-0.25.9.tgz
https://registry.npmjs.org/make-dir/-/make-dir-4.0.0.tgz -> npmpkg-make-dir-4.0.0.tgz
https://registry.npmjs.org/make-error/-/make-error-1.3.6.tgz -> npmpkg-make-error-1.3.6.tgz
https://registry.npmjs.org/makeerror/-/makeerror-1.0.12.tgz -> npmpkg-makeerror-1.0.12.tgz
https://registry.npmjs.org/matcher-collection/-/matcher-collection-2.0.1.tgz -> npmpkg-matcher-collection-2.0.1.tgz
https://registry.npmjs.org/@types/minimatch/-/minimatch-3.0.5.tgz -> npmpkg-@types-minimatch-3.0.5.tgz
https://registry.npmjs.org/merge-stream/-/merge-stream-2.0.0.tgz -> npmpkg-merge-stream-2.0.0.tgz
https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz -> npmpkg-merge2-1.4.1.tgz
https://registry.npmjs.org/meshoptimizer/-/meshoptimizer-0.18.1.tgz -> npmpkg-meshoptimizer-0.18.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.5.tgz -> npmpkg-micromatch-4.0.5.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.52.0.tgz -> npmpkg-mime-db-1.52.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.35.tgz -> npmpkg-mime-types-2.1.35.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-2.1.0.tgz -> npmpkg-mimic-fn-2.1.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-3.1.0.tgz -> npmpkg-mimic-response-3.1.0.tgz
https://registry.npmjs.org/min-indent/-/min-indent-1.0.1.tgz -> npmpkg-min-indent-1.0.1.tgz
https://registry.npmjs.org/mini-svg-data-uri/-/mini-svg-data-uri-1.4.4.tgz -> npmpkg-mini-svg-data-uri-1.4.4.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/mkdirp-classic/-/mkdirp-classic-0.5.3.tgz -> npmpkg-mkdirp-classic-0.5.3.tgz
https://registry.npmjs.org/mktemp/-/mktemp-0.4.0.tgz -> npmpkg-mktemp-0.4.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/mz/-/mz-2.7.0.tgz -> npmpkg-mz-2.7.0.tgz
https://registry.npmjs.org/nanoid/-/nanoid-3.3.6.tgz -> npmpkg-nanoid-3.3.6.tgz
https://registry.npmjs.org/napi-build-utils/-/napi-build-utils-1.0.2.tgz -> npmpkg-napi-build-utils-1.0.2.tgz
https://registry.npmjs.org/natural-compare/-/natural-compare-1.4.0.tgz -> npmpkg-natural-compare-1.4.0.tgz
https://registry.npmjs.org/neo-async/-/neo-async-2.6.2.tgz -> npmpkg-neo-async-2.6.2.tgz
https://registry.npmjs.org/next/-/next-13.5.6.tgz -> npmpkg-next-13.5.6.tgz
https://registry.npmjs.org/next-tick/-/next-tick-1.1.0.tgz -> npmpkg-next-tick-1.1.0.tgz
https://registry.npmjs.org/node-abi/-/node-abi-3.51.0.tgz -> npmpkg-node-abi-3.51.0.tgz
https://registry.npmjs.org/node-addon-api/-/node-addon-api-6.1.0.tgz -> npmpkg-node-addon-api-6.1.0.tgz
https://registry.npmjs.org/node-gyp-build/-/node-gyp-build-4.7.1.tgz -> npmpkg-node-gyp-build-4.7.1.tgz
https://registry.npmjs.org/node-int64/-/node-int64-0.4.0.tgz -> npmpkg-node-int64-0.4.0.tgz
https://registry.npmjs.org/node-releases/-/node-releases-2.0.13.tgz -> npmpkg-node-releases-2.0.13.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/normalize-range/-/normalize-range-0.1.2.tgz -> npmpkg-normalize-range-0.1.2.tgz
https://registry.npmjs.org/now-and-later/-/now-and-later-3.0.0.tgz -> npmpkg-now-and-later-3.0.0.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-4.0.1.tgz -> npmpkg-npm-run-path-4.0.1.tgz
https://registry.npmjs.org/nth-check/-/nth-check-2.1.1.tgz -> npmpkg-nth-check-2.1.1.tgz
https://registry.npmjs.org/nwsapi/-/nwsapi-2.2.7.tgz -> npmpkg-nwsapi-2.2.7.tgz
https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz -> npmpkg-object-assign-4.1.1.tgz
https://registry.npmjs.org/object-hash/-/object-hash-3.0.0.tgz -> npmpkg-object-hash-3.0.0.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.12.3.tgz -> npmpkg-object-inspect-1.12.3.tgz
https://registry.npmjs.org/object-is/-/object-is-1.1.5.tgz -> npmpkg-object-is-1.1.5.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/object.assign/-/object.assign-4.1.4.tgz -> npmpkg-object.assign-4.1.4.tgz
https://registry.npmjs.org/object.entries/-/object.entries-1.1.6.tgz -> npmpkg-object.entries-1.1.6.tgz
https://registry.npmjs.org/object.fromentries/-/object.fromentries-2.0.6.tgz -> npmpkg-object.fromentries-2.0.6.tgz
https://registry.npmjs.org/object.hasown/-/object.hasown-1.1.2.tgz -> npmpkg-object.hasown-1.1.2.tgz
https://registry.npmjs.org/object.values/-/object.values-1.1.6.tgz -> npmpkg-object.values-1.1.6.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/onetime/-/onetime-5.1.2.tgz -> npmpkg-onetime-5.1.2.tgz
https://registry.npmjs.org/onnx-proto/-/onnx-proto-4.0.4.tgz -> npmpkg-onnx-proto-4.0.4.tgz
https://registry.npmjs.org/onnxruntime-common/-/onnxruntime-common-1.14.0.tgz -> npmpkg-onnxruntime-common-1.14.0.tgz
https://registry.npmjs.org/onnxruntime-node/-/onnxruntime-node-1.14.0.tgz -> npmpkg-onnxruntime-node-1.14.0.tgz
https://registry.npmjs.org/onnxruntime-web/-/onnxruntime-web-1.14.0.tgz -> npmpkg-onnxruntime-web-1.14.0.tgz
https://registry.npmjs.org/open/-/open-8.4.2.tgz -> npmpkg-open-8.4.2.tgz
https://registry.npmjs.org/optionator/-/optionator-0.9.1.tgz -> npmpkg-optionator-0.9.1.tgz
https://registry.npmjs.org/p-limit/-/p-limit-3.1.0.tgz -> npmpkg-p-limit-3.1.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-5.0.0.tgz -> npmpkg-p-locate-5.0.0.tgz
https://registry.npmjs.org/p-map/-/p-map-2.1.0.tgz -> npmpkg-p-map-2.1.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/parent-module/-/parent-module-1.0.1.tgz -> npmpkg-parent-module-1.0.1.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/parse5/-/parse5-7.1.2.tgz -> npmpkg-parse5-7.1.2.tgz
https://registry.npmjs.org/parse5-htmlparser2-tree-adapter/-/parse5-htmlparser2-tree-adapter-7.0.0.tgz -> npmpkg-parse5-htmlparser2-tree-adapter-7.0.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-is-inside/-/path-is-inside-1.0.2.tgz -> npmpkg-path-is-inside-1.0.2.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-posix/-/path-posix-1.0.0.tgz -> npmpkg-path-posix-1.0.0.tgz
https://registry.npmjs.org/path-type/-/path-type-4.0.0.tgz -> npmpkg-path-type-4.0.0.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.0.0.tgz -> npmpkg-picocolors-1.0.0.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/pify/-/pify-2.3.0.tgz -> npmpkg-pify-2.3.0.tgz
https://registry.npmjs.org/pinkie/-/pinkie-2.0.4.tgz -> npmpkg-pinkie-2.0.4.tgz
https://registry.npmjs.org/pinkie-promise/-/pinkie-promise-2.0.1.tgz -> npmpkg-pinkie-promise-2.0.1.tgz
https://registry.npmjs.org/pirates/-/pirates-4.0.5.tgz -> npmpkg-pirates-4.0.5.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-4.2.0.tgz -> npmpkg-pkg-dir-4.2.0.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/platform/-/platform-1.3.6.tgz -> npmpkg-platform-1.3.6.tgz
https://registry.npmjs.org/polished/-/polished-4.2.2.tgz -> npmpkg-polished-4.2.2.tgz
https://registry.npmjs.org/postcss/-/postcss-8.4.31.tgz -> npmpkg-postcss-8.4.31.tgz
https://registry.npmjs.org/postcss-import/-/postcss-import-14.1.0.tgz -> npmpkg-postcss-import-14.1.0.tgz
https://registry.npmjs.org/postcss-nested/-/postcss-nested-6.0.0.tgz -> npmpkg-postcss-nested-6.0.0.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-6.0.11.tgz -> npmpkg-postcss-selector-parser-6.0.11.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-4.2.0.tgz -> npmpkg-postcss-value-parser-4.2.0.tgz
https://registry.npmjs.org/prebuild-install/-/prebuild-install-7.1.1.tgz -> npmpkg-prebuild-install-7.1.1.tgz
https://registry.npmjs.org/tar-fs/-/tar-fs-2.1.1.tgz -> npmpkg-tar-fs-2.1.1.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-2.2.0.tgz -> npmpkg-tar-stream-2.2.0.tgz
https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.2.1.tgz -> npmpkg-prelude-ls-1.2.1.tgz
https://registry.npmjs.org/prettier/-/prettier-2.8.8.tgz -> npmpkg-prettier-2.8.8.tgz
https://registry.npmjs.org/prettier-plugin-tailwindcss/-/prettier-plugin-tailwindcss-0.2.8.tgz -> npmpkg-prettier-plugin-tailwindcss-0.2.8.tgz
https://registry.npmjs.org/pretty-bytes/-/pretty-bytes-5.6.0.tgz -> npmpkg-pretty-bytes-5.6.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-27.5.1.tgz -> npmpkg-pretty-format-27.5.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/react-is/-/react-is-17.0.2.tgz -> npmpkg-react-is-17.0.2.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> npmpkg-process-nextick-args-2.0.1.tgz
https://registry.npmjs.org/promise-map-series/-/promise-map-series-0.3.0.tgz -> npmpkg-promise-map-series-0.3.0.tgz
https://registry.npmjs.org/prompts/-/prompts-2.4.2.tgz -> npmpkg-prompts-2.4.2.tgz
https://registry.npmjs.org/prop-types/-/prop-types-15.8.1.tgz -> npmpkg-prop-types-15.8.1.tgz
https://registry.npmjs.org/property-graph/-/property-graph-0.2.6.tgz -> npmpkg-property-graph-0.2.6.tgz
https://registry.npmjs.org/protobufjs/-/protobufjs-6.11.4.tgz -> npmpkg-protobufjs-6.11.4.tgz
https://registry.npmjs.org/psl/-/psl-1.9.0.tgz -> npmpkg-psl-1.9.0.tgz
https://registry.npmjs.org/pump/-/pump-3.0.0.tgz -> npmpkg-pump-3.0.0.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.0.tgz -> npmpkg-punycode-2.3.0.tgz
https://registry.npmjs.org/pure-rand/-/pure-rand-6.0.4.tgz -> npmpkg-pure-rand-6.0.4.tgz
https://registry.npmjs.org/querystringify/-/querystringify-2.2.0.tgz -> npmpkg-querystringify-2.2.0.tgz
https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz -> npmpkg-queue-microtask-1.2.3.tgz
https://registry.npmjs.org/queue-tick/-/queue-tick-1.0.1.tgz -> npmpkg-queue-tick-1.0.1.tgz
https://registry.npmjs.org/quick-lru/-/quick-lru-5.1.1.tgz -> npmpkg-quick-lru-5.1.1.tgz
https://registry.npmjs.org/quick-temp/-/quick-temp-0.1.8.tgz -> npmpkg-quick-temp-0.1.8.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.7.1.tgz -> npmpkg-rimraf-2.7.1.tgz
https://registry.npmjs.org/randombytes/-/randombytes-2.1.0.tgz -> npmpkg-randombytes-2.1.0.tgz
https://registry.npmjs.org/rc/-/rc-1.2.8.tgz -> npmpkg-rc-1.2.8.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-2.0.1.tgz -> npmpkg-strip-json-comments-2.0.1.tgz
https://registry.npmjs.org/react/-/react-18.2.0.tgz -> npmpkg-react-18.2.0.tgz
https://registry.npmjs.org/react-dom/-/react-dom-18.2.0.tgz -> npmpkg-react-dom-18.2.0.tgz
https://registry.npmjs.org/react-filepond/-/react-filepond-7.1.2.tgz -> npmpkg-react-filepond-7.1.2.tgz
https://registry.npmjs.org/react-i18next/-/react-i18next-13.5.0.tgz -> npmpkg-react-i18next-13.5.0.tgz
https://registry.npmjs.org/react-is/-/react-is-16.13.1.tgz -> npmpkg-react-is-16.13.1.tgz
https://registry.npmjs.org/react-webcam/-/react-webcam-7.2.0.tgz -> npmpkg-react-webcam-7.2.0.tgz
https://registry.npmjs.org/read-cache/-/read-cache-1.0.0.tgz -> npmpkg-read-cache-1.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz -> npmpkg-readdirp-3.6.0.tgz
https://registry.npmjs.org/redent/-/redent-3.0.0.tgz -> npmpkg-redent-3.0.0.tgz
https://registry.npmjs.org/regenerate/-/regenerate-1.4.2.tgz -> npmpkg-regenerate-1.4.2.tgz
https://registry.npmjs.org/regenerate-unicode-properties/-/regenerate-unicode-properties-10.1.1.tgz -> npmpkg-regenerate-unicode-properties-10.1.1.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.14.0.tgz -> npmpkg-regenerator-runtime-0.14.0.tgz
https://registry.npmjs.org/regenerator-transform/-/regenerator-transform-0.15.2.tgz -> npmpkg-regenerator-transform-0.15.2.tgz
https://registry.npmjs.org/regexp.prototype.flags/-/regexp.prototype.flags-1.4.3.tgz -> npmpkg-regexp.prototype.flags-1.4.3.tgz
https://registry.npmjs.org/regexpu-core/-/regexpu-core-5.3.2.tgz -> npmpkg-regexpu-core-5.3.2.tgz
https://registry.npmjs.org/regjsparser/-/regjsparser-0.9.1.tgz -> npmpkg-regjsparser-0.9.1.tgz
https://registry.npmjs.org/jsesc/-/jsesc-0.5.0.tgz -> npmpkg-jsesc-0.5.0.tgz
https://registry.npmjs.org/remove-trailing-separator/-/remove-trailing-separator-1.1.0.tgz -> npmpkg-remove-trailing-separator-1.1.0.tgz
https://registry.npmjs.org/replace-ext/-/replace-ext-2.0.0.tgz -> npmpkg-replace-ext-2.0.0.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/require-from-string/-/require-from-string-2.0.2.tgz -> npmpkg-require-from-string-2.0.2.tgz
https://registry.npmjs.org/requires-port/-/requires-port-1.0.0.tgz -> npmpkg-requires-port-1.0.0.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.1.tgz -> npmpkg-resolve-1.22.1.tgz
https://registry.npmjs.org/resolve-cwd/-/resolve-cwd-3.0.0.tgz -> npmpkg-resolve-cwd-3.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-5.0.0.tgz -> npmpkg-resolve-from-5.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/resolve-options/-/resolve-options-2.0.0.tgz -> npmpkg-resolve-options-2.0.0.tgz
https://registry.npmjs.org/resolve.exports/-/resolve.exports-2.0.2.tgz -> npmpkg-resolve.exports-2.0.2.tgz
https://registry.npmjs.org/reusify/-/reusify-1.0.4.tgz -> npmpkg-reusify-1.0.4.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/rollup/-/rollup-2.79.1.tgz -> npmpkg-rollup-2.79.1.tgz
https://registry.npmjs.org/rollup-plugin-terser/-/rollup-plugin-terser-7.0.2.tgz -> npmpkg-rollup-plugin-terser-7.0.2.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-26.6.2.tgz -> npmpkg-jest-worker-26.6.2.tgz
https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-4.0.0.tgz -> npmpkg-serialize-javascript-4.0.0.tgz
https://registry.npmjs.org/rsvp/-/rsvp-4.8.5.tgz -> npmpkg-rsvp-4.8.5.tgz
https://registry.npmjs.org/run-parallel/-/run-parallel-1.2.0.tgz -> npmpkg-run-parallel-1.2.0.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/safe-regex-test/-/safe-regex-test-1.0.0.tgz -> npmpkg-safe-regex-test-1.0.0.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz -> npmpkg-safer-buffer-2.1.2.tgz
https://registry.npmjs.org/saxes/-/saxes-6.0.0.tgz -> npmpkg-saxes-6.0.0.tgz
https://registry.npmjs.org/scheduler/-/scheduler-0.23.0.tgz -> npmpkg-scheduler-0.23.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-6.0.1.tgz -> npmpkg-serialize-javascript-6.0.1.tgz
https://registry.npmjs.org/sharp/-/sharp-0.32.6.tgz -> npmpkg-sharp-0.32.6.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.4.tgz -> npmpkg-side-channel-1.0.4.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.7.tgz -> npmpkg-signal-exit-3.0.7.tgz
https://registry.npmjs.org/simple-concat/-/simple-concat-1.0.1.tgz -> npmpkg-simple-concat-1.0.1.tgz
https://registry.npmjs.org/simple-get/-/simple-get-4.0.1.tgz -> npmpkg-simple-get-4.0.1.tgz
https://registry.npmjs.org/simple-swizzle/-/simple-swizzle-0.2.2.tgz -> npmpkg-simple-swizzle-0.2.2.tgz
https://registry.npmjs.org/sisteransi/-/sisteransi-1.0.5.tgz -> npmpkg-sisteransi-1.0.5.tgz
https://registry.npmjs.org/slash/-/slash-3.0.0.tgz -> npmpkg-slash-3.0.0.tgz
https://registry.npmjs.org/sort-keys/-/sort-keys-5.0.0.tgz -> npmpkg-sort-keys-5.0.0.tgz
https://registry.npmjs.org/source-list-map/-/source-list-map-2.0.1.tgz -> npmpkg-source-list-map-2.0.1.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/source-map-js/-/source-map-js-1.0.2.tgz -> npmpkg-source-map-js-1.0.2.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.21.tgz -> npmpkg-source-map-support-0.5.21.tgz
https://registry.npmjs.org/sourcemap-codec/-/sourcemap-codec-1.4.8.tgz -> npmpkg-sourcemap-codec-1.4.8.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.0.3.tgz -> npmpkg-sprintf-js-1.0.3.tgz
https://registry.npmjs.org/stack-utils/-/stack-utils-2.0.6.tgz -> npmpkg-stack-utils-2.0.6.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-2.0.0.tgz -> npmpkg-escape-string-regexp-2.0.0.tgz
https://registry.npmjs.org/stop-iteration-iterator/-/stop-iteration-iterator-1.0.0.tgz -> npmpkg-stop-iteration-iterator-1.0.0.tgz
https://registry.npmjs.org/stream-composer/-/stream-composer-1.0.2.tgz -> npmpkg-stream-composer-1.0.2.tgz
https://registry.npmjs.org/streamsearch/-/streamsearch-1.1.0.tgz -> npmpkg-streamsearch-1.1.0.tgz
https://registry.npmjs.org/streamx/-/streamx-2.15.1.tgz -> npmpkg-streamx-2.15.1.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.3.0.tgz -> npmpkg-string_decoder-1.3.0.tgz
https://registry.npmjs.org/string-length/-/string-length-4.0.2.tgz -> npmpkg-string-length-4.0.2.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/string.prototype.matchall/-/string.prototype.matchall-4.0.8.tgz -> npmpkg-string.prototype.matchall-4.0.8.tgz
https://registry.npmjs.org/string.prototype.trim/-/string.prototype.trim-1.2.7.tgz -> npmpkg-string.prototype.trim-1.2.7.tgz
https://registry.npmjs.org/string.prototype.trimend/-/string.prototype.trimend-1.0.6.tgz -> npmpkg-string.prototype.trimend-1.0.6.tgz
https://registry.npmjs.org/string.prototype.trimstart/-/string.prototype.trimstart-1.0.6.tgz -> npmpkg-string.prototype.trimstart-1.0.6.tgz
https://registry.npmjs.org/stringify-object/-/stringify-object-3.3.0.tgz -> npmpkg-stringify-object-3.3.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz -> npmpkg-strip-bom-3.0.0.tgz
https://registry.npmjs.org/strip-comments/-/strip-comments-2.0.1.tgz -> npmpkg-strip-comments-2.0.1.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-2.0.0.tgz -> npmpkg-strip-final-newline-2.0.0.tgz
https://registry.npmjs.org/strip-indent/-/strip-indent-3.0.0.tgz -> npmpkg-strip-indent-3.0.0.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> npmpkg-strip-json-comments-3.1.1.tgz
https://registry.npmjs.org/styled-jsx/-/styled-jsx-5.1.1.tgz -> npmpkg-styled-jsx-5.1.1.tgz
https://registry.npmjs.org/sucrase/-/sucrase-3.31.0.tgz -> npmpkg-sucrase-3.31.0.tgz
https://registry.npmjs.org/glob/-/glob-7.1.6.tgz -> npmpkg-glob-7.1.6.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> npmpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.npmjs.org/symbol-tree/-/symbol-tree-3.2.4.tgz -> npmpkg-symbol-tree-3.2.4.tgz
https://registry.npmjs.org/symlink-or-copy/-/symlink-or-copy-1.3.1.tgz -> npmpkg-symlink-or-copy-1.3.1.tgz
https://registry.npmjs.org/synckit/-/synckit-0.8.5.tgz -> npmpkg-synckit-0.8.5.tgz
https://registry.npmjs.org/tailwindcss/-/tailwindcss-3.3.1.tgz -> npmpkg-tailwindcss-3.3.1.tgz
https://registry.npmjs.org/postcss-js/-/postcss-js-4.0.1.tgz -> npmpkg-postcss-js-4.0.1.tgz
https://registry.npmjs.org/postcss-load-config/-/postcss-load-config-3.1.4.tgz -> npmpkg-postcss-load-config-3.1.4.tgz
https://registry.npmjs.org/tapable/-/tapable-2.2.1.tgz -> npmpkg-tapable-2.2.1.tgz
https://registry.npmjs.org/tar-fs/-/tar-fs-3.0.4.tgz -> npmpkg-tar-fs-3.0.4.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-3.1.6.tgz -> npmpkg-tar-stream-3.1.6.tgz
https://registry.npmjs.org/teex/-/teex-1.0.1.tgz -> npmpkg-teex-1.0.1.tgz
https://registry.npmjs.org/temp-dir/-/temp-dir-2.0.0.tgz -> npmpkg-temp-dir-2.0.0.tgz
https://registry.npmjs.org/tempy/-/tempy-0.6.0.tgz -> npmpkg-tempy-0.6.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.16.0.tgz -> npmpkg-type-fest-0.16.0.tgz
https://registry.npmjs.org/terser/-/terser-5.24.0.tgz -> npmpkg-terser-5.24.0.tgz
https://registry.npmjs.org/commander/-/commander-2.20.3.tgz -> npmpkg-commander-2.20.3.tgz
https://registry.npmjs.org/terser-webpack-plugin/-/terser-webpack-plugin-5.3.9.tgz -> npmpkg-terser-webpack-plugin-5.3.9.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.20.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.20.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-3.3.0.tgz -> npmpkg-schema-utils-3.3.0.tgz
https://registry.npmjs.org/test-exclude/-/test-exclude-6.0.0.tgz -> npmpkg-test-exclude-6.0.0.tgz
https://registry.npmjs.org/text-table/-/text-table-0.2.0.tgz -> npmpkg-text-table-0.2.0.tgz
https://registry.npmjs.org/thenify/-/thenify-3.3.1.tgz -> npmpkg-thenify-3.3.1.tgz
https://registry.npmjs.org/thenify-all/-/thenify-all-1.6.0.tgz -> npmpkg-thenify-all-1.6.0.tgz
https://registry.npmjs.org/three/-/three-0.154.0.tgz -> npmpkg-three-0.154.0.tgz
https://registry.npmjs.org/through2/-/through2-2.0.5.tgz -> npmpkg-through2-2.0.5.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/tiny-glob/-/tiny-glob-0.2.9.tgz -> npmpkg-tiny-glob-0.2.9.tgz
https://registry.npmjs.org/tmpl/-/tmpl-1.0.5.tgz -> npmpkg-tmpl-1.0.5.tgz
https://registry.npmjs.org/to-fast-properties/-/to-fast-properties-2.0.0.tgz -> npmpkg-to-fast-properties-2.0.0.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/to-through/-/to-through-3.0.0.tgz -> npmpkg-to-through-3.0.0.tgz
https://registry.npmjs.org/tough-cookie/-/tough-cookie-4.1.3.tgz -> npmpkg-tough-cookie-4.1.3.tgz
https://registry.npmjs.org/universalify/-/universalify-0.2.0.tgz -> npmpkg-universalify-0.2.0.tgz
https://registry.npmjs.org/tr46/-/tr46-1.0.1.tgz -> npmpkg-tr46-1.0.1.tgz
https://registry.npmjs.org/ts-interface-checker/-/ts-interface-checker-0.1.13.tgz -> npmpkg-ts-interface-checker-0.1.13.tgz
https://registry.npmjs.org/ts-node/-/ts-node-10.9.1.tgz -> npmpkg-ts-node-10.9.1.tgz
https://registry.npmjs.org/arg/-/arg-4.1.3.tgz -> npmpkg-arg-4.1.3.tgz
https://registry.npmjs.org/tsconfig-paths/-/tsconfig-paths-3.14.2.tgz -> npmpkg-tsconfig-paths-3.14.2.tgz
https://registry.npmjs.org/tslib/-/tslib-2.5.0.tgz -> npmpkg-tslib-2.5.0.tgz
https://registry.npmjs.org/tsutils/-/tsutils-3.21.0.tgz -> npmpkg-tsutils-3.21.0.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.6.0.tgz -> npmpkg-tunnel-agent-0.6.0.tgz
https://registry.npmjs.org/type/-/type-1.2.0.tgz -> npmpkg-type-1.2.0.tgz
https://registry.npmjs.org/type-check/-/type-check-0.4.0.tgz -> npmpkg-type-check-0.4.0.tgz
https://registry.npmjs.org/type-detect/-/type-detect-4.0.8.tgz -> npmpkg-type-detect-4.0.8.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.20.2.tgz -> npmpkg-type-fest-0.20.2.tgz
https://registry.npmjs.org/typed-array-length/-/typed-array-length-1.0.4.tgz -> npmpkg-typed-array-length-1.0.4.tgz
https://registry.npmjs.org/typedarray-to-buffer/-/typedarray-to-buffer-3.1.5.tgz -> npmpkg-typedarray-to-buffer-3.1.5.tgz
https://registry.npmjs.org/typescript/-/typescript-5.0.2.tgz -> npmpkg-typescript-5.0.2.tgz
https://registry.npmjs.org/typescript-collections/-/typescript-collections-1.3.3.tgz -> npmpkg-typescript-collections-1.3.3.tgz
https://registry.npmjs.org/unbox-primitive/-/unbox-primitive-1.0.2.tgz -> npmpkg-unbox-primitive-1.0.2.tgz
https://registry.npmjs.org/underscore.string/-/underscore.string-3.3.6.tgz -> npmpkg-underscore.string-3.3.6.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.1.3.tgz -> npmpkg-sprintf-js-1.1.3.tgz
https://registry.npmjs.org/unicode-canonical-property-names-ecmascript/-/unicode-canonical-property-names-ecmascript-2.0.0.tgz -> npmpkg-unicode-canonical-property-names-ecmascript-2.0.0.tgz
https://registry.npmjs.org/unicode-match-property-ecmascript/-/unicode-match-property-ecmascript-2.0.0.tgz -> npmpkg-unicode-match-property-ecmascript-2.0.0.tgz
https://registry.npmjs.org/unicode-match-property-value-ecmascript/-/unicode-match-property-value-ecmascript-2.1.0.tgz -> npmpkg-unicode-match-property-value-ecmascript-2.1.0.tgz
https://registry.npmjs.org/unicode-property-aliases-ecmascript/-/unicode-property-aliases-ecmascript-2.1.0.tgz -> npmpkg-unicode-property-aliases-ecmascript-2.1.0.tgz
https://registry.npmjs.org/unique-string/-/unique-string-2.0.0.tgz -> npmpkg-unique-string-2.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/upath/-/upath-1.2.0.tgz -> npmpkg-upath-1.2.0.tgz
https://registry.npmjs.org/update-browserslist-db/-/update-browserslist-db-1.0.13.tgz -> npmpkg-update-browserslist-db-1.0.13.tgz
https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz -> npmpkg-uri-js-4.4.1.tgz
https://registry.npmjs.org/url-parse/-/url-parse-1.5.10.tgz -> npmpkg-url-parse-1.5.10.tgz
https://registry.npmjs.org/utf-8-validate/-/utf-8-validate-5.0.10.tgz -> npmpkg-utf-8-validate-5.0.10.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/v8-compile-cache-lib/-/v8-compile-cache-lib-3.0.1.tgz -> npmpkg-v8-compile-cache-lib-3.0.1.tgz
https://registry.npmjs.org/v8-to-istanbul/-/v8-to-istanbul-9.2.0.tgz -> npmpkg-v8-to-istanbul-9.2.0.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.20.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.20.tgz
https://registry.npmjs.org/value-or-function/-/value-or-function-4.0.0.tgz -> npmpkg-value-or-function-4.0.0.tgz
https://registry.npmjs.org/vinyl/-/vinyl-3.0.0.tgz -> npmpkg-vinyl-3.0.0.tgz
https://registry.npmjs.org/vinyl-contents/-/vinyl-contents-2.0.0.tgz -> npmpkg-vinyl-contents-2.0.0.tgz
https://registry.npmjs.org/bl/-/bl-5.1.0.tgz -> npmpkg-bl-5.1.0.tgz
https://registry.npmjs.org/buffer/-/buffer-6.0.3.tgz -> npmpkg-buffer-6.0.3.tgz
https://registry.npmjs.org/vinyl-fs/-/vinyl-fs-4.0.0.tgz -> npmpkg-vinyl-fs-4.0.0.tgz
https://registry.npmjs.org/vinyl-sourcemap/-/vinyl-sourcemap-2.0.0.tgz -> npmpkg-vinyl-sourcemap-2.0.0.tgz
https://registry.npmjs.org/void-elements/-/void-elements-3.1.0.tgz -> npmpkg-void-elements-3.1.0.tgz
https://registry.npmjs.org/vue-template-compiler/-/vue-template-compiler-2.7.15.tgz -> npmpkg-vue-template-compiler-2.7.15.tgz
https://registry.npmjs.org/w3c-xmlserializer/-/w3c-xmlserializer-4.0.0.tgz -> npmpkg-w3c-xmlserializer-4.0.0.tgz
https://registry.npmjs.org/walk-sync/-/walk-sync-2.2.0.tgz -> npmpkg-walk-sync-2.2.0.tgz
https://registry.npmjs.org/@types/minimatch/-/minimatch-3.0.5.tgz -> npmpkg-@types-minimatch-3.0.5.tgz
https://registry.npmjs.org/walker/-/walker-1.0.8.tgz -> npmpkg-walker-1.0.8.tgz
https://registry.npmjs.org/warning/-/warning-4.0.3.tgz -> npmpkg-warning-4.0.3.tgz
https://registry.npmjs.org/watchpack/-/watchpack-2.4.0.tgz -> npmpkg-watchpack-2.4.0.tgz
https://registry.npmjs.org/wavefile/-/wavefile-11.0.0.tgz -> npmpkg-wavefile-11.0.0.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-4.0.2.tgz -> npmpkg-webidl-conversions-4.0.2.tgz
https://registry.npmjs.org/webpack/-/webpack-5.89.0.tgz -> npmpkg-webpack-5.89.0.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-5.1.1.tgz -> npmpkg-eslint-scope-5.1.1.tgz
https://registry.npmjs.org/estraverse/-/estraverse-4.3.0.tgz -> npmpkg-estraverse-4.3.0.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-3.3.0.tgz -> npmpkg-schema-utils-3.3.0.tgz
https://registry.npmjs.org/webpack-sources/-/webpack-sources-3.2.3.tgz -> npmpkg-webpack-sources-3.2.3.tgz
https://registry.npmjs.org/websocket/-/websocket-1.0.34.tgz -> npmpkg-websocket-1.0.34.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/whatwg-encoding/-/whatwg-encoding-2.0.0.tgz -> npmpkg-whatwg-encoding-2.0.0.tgz
https://registry.npmjs.org/whatwg-mimetype/-/whatwg-mimetype-3.0.0.tgz -> npmpkg-whatwg-mimetype-3.0.0.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-7.1.0.tgz -> npmpkg-whatwg-url-7.1.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> npmpkg-which-boxed-primitive-1.0.2.tgz
https://registry.npmjs.org/which-collection/-/which-collection-1.0.1.tgz -> npmpkg-which-collection-1.0.1.tgz
https://registry.npmjs.org/which-typed-array/-/which-typed-array-1.1.9.tgz -> npmpkg-which-typed-array-1.1.9.tgz
https://registry.npmjs.org/window.ai/-/window.ai-0.2.4.tgz -> npmpkg-window.ai-0.2.4.tgz
https://registry.npmjs.org/word-wrap/-/word-wrap-1.2.5.tgz -> npmpkg-word-wrap-1.2.5.tgz
https://registry.npmjs.org/workbox-background-sync/-/workbox-background-sync-7.0.0.tgz -> npmpkg-workbox-background-sync-7.0.0.tgz
https://registry.npmjs.org/workbox-broadcast-update/-/workbox-broadcast-update-7.0.0.tgz -> npmpkg-workbox-broadcast-update-7.0.0.tgz
https://registry.npmjs.org/workbox-build/-/workbox-build-7.0.0.tgz -> npmpkg-workbox-build-7.0.0.tgz
https://registry.npmjs.org/@apideck/better-ajv-errors/-/better-ajv-errors-0.3.6.tgz -> npmpkg-@apideck-better-ajv-errors-0.3.6.tgz
https://registry.npmjs.org/ajv/-/ajv-8.12.0.tgz -> npmpkg-ajv-8.12.0.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> npmpkg-json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.8.0-beta.0.tgz -> npmpkg-source-map-0.8.0-beta.0.tgz
https://registry.npmjs.org/workbox-cacheable-response/-/workbox-cacheable-response-7.0.0.tgz -> npmpkg-workbox-cacheable-response-7.0.0.tgz
https://registry.npmjs.org/workbox-core/-/workbox-core-7.0.0.tgz -> npmpkg-workbox-core-7.0.0.tgz
https://registry.npmjs.org/workbox-expiration/-/workbox-expiration-7.0.0.tgz -> npmpkg-workbox-expiration-7.0.0.tgz
https://registry.npmjs.org/workbox-google-analytics/-/workbox-google-analytics-7.0.0.tgz -> npmpkg-workbox-google-analytics-7.0.0.tgz
https://registry.npmjs.org/workbox-navigation-preload/-/workbox-navigation-preload-7.0.0.tgz -> npmpkg-workbox-navigation-preload-7.0.0.tgz
https://registry.npmjs.org/workbox-precaching/-/workbox-precaching-7.0.0.tgz -> npmpkg-workbox-precaching-7.0.0.tgz
https://registry.npmjs.org/workbox-range-requests/-/workbox-range-requests-7.0.0.tgz -> npmpkg-workbox-range-requests-7.0.0.tgz
https://registry.npmjs.org/workbox-recipes/-/workbox-recipes-7.0.0.tgz -> npmpkg-workbox-recipes-7.0.0.tgz
https://registry.npmjs.org/workbox-routing/-/workbox-routing-7.0.0.tgz -> npmpkg-workbox-routing-7.0.0.tgz
https://registry.npmjs.org/workbox-strategies/-/workbox-strategies-7.0.0.tgz -> npmpkg-workbox-strategies-7.0.0.tgz
https://registry.npmjs.org/workbox-streams/-/workbox-streams-7.0.0.tgz -> npmpkg-workbox-streams-7.0.0.tgz
https://registry.npmjs.org/workbox-sw/-/workbox-sw-7.0.0.tgz -> npmpkg-workbox-sw-7.0.0.tgz
https://registry.npmjs.org/workbox-webpack-plugin/-/workbox-webpack-plugin-7.0.0.tgz -> npmpkg-workbox-webpack-plugin-7.0.0.tgz
https://registry.npmjs.org/webpack-sources/-/webpack-sources-1.4.3.tgz -> npmpkg-webpack-sources-1.4.3.tgz
https://registry.npmjs.org/workbox-window/-/workbox-window-7.0.0.tgz -> npmpkg-workbox-window-7.0.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/write-file-atomic/-/write-file-atomic-4.0.2.tgz -> npmpkg-write-file-atomic-4.0.2.tgz
https://registry.npmjs.org/ws/-/ws-8.14.2.tgz -> npmpkg-ws-8.14.2.tgz
https://registry.npmjs.org/xml-name-validator/-/xml-name-validator-4.0.0.tgz -> npmpkg-xml-name-validator-4.0.0.tgz
https://registry.npmjs.org/xmlchars/-/xmlchars-2.2.0.tgz -> npmpkg-xmlchars-2.2.0.tgz
https://registry.npmjs.org/xtend/-/xtend-4.0.2.tgz -> npmpkg-xtend-4.0.2.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yaeti/-/yaeti-0.0.6.tgz -> npmpkg-yaeti-0.0.6.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/yaml/-/yaml-1.10.2.tgz -> npmpkg-yaml-1.10.2.tgz
https://registry.npmjs.org/yargs/-/yargs-17.7.2.tgz -> npmpkg-yargs-17.7.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-21.1.1.tgz -> npmpkg-yargs-parser-21.1.1.tgz
https://registry.npmjs.org/yn/-/yn-3.1.1.tgz -> npmpkg-yn-3.1.1.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-0.1.0.tgz -> npmpkg-yocto-queue-0.1.0.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS
KEYWORDS="~amd64 ~arm64"
SRC_URI="
$(cargo_crate_uris ${CRATES})
${NPM_EXTERNAL_URIS}
https://github.com/semperai/amica/commit/da5a3908fa5055cbb4651c21562038ebf308ac48.patch
	-> ${PN}-commit-da5a390.patch
"
# Fix ollamaChat by implementing new Ollama chat API.
#   Reverting, broken

if [[ "${PV}" =~ "_p" ]] ; then
	TARBALL="${PN}-${EGIT_COMMIT:0:7}.tar.gz"
	SRC_URI+="
https://github.com/semperai/amica/archive/${EGIT_COMMIT}.tar.gz
	-> ${TARBALL}
	"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
	S_PROJECT="${WORKDIR}/${PN}-${EGIT_COMMIT}"
else
	TARBALL="${P}.tar.gz"
	SRC_URI+="
https://github.com/semperai/amica/archive/refs/tags/app-v${PV}.tar.gz
	-> ${TARBALL}
	"
	S="${WORKDIR}/${PN}-app-v${PV}"
	S_PROJECT="${WORKDIR}/${PN}-app-v${PV}"
fi
NPM_TARBALL="${TARBALL}"

DESCRIPTION="Amica is a customizable friendly interactive AI with 3D characters, voice synthesis, speech recognition, emotion engine"
HOMEPAGE="
	https://heyamica.com/
	https://github.com/semperai/amica
"
CARGO_PACKAGES_LICENSES="
	(
		Apache-2.0
		BSD
		CC-BY-3.0
		MIT
	)
	0BSD
	Apache-2.0
	BSD
	CC0-1.0
	MPL-2.0
	Unicode-DFS-2016
	ZLIB
"
# 0BSD - ./cargo_home/gentoo/adler-1.0.2/LICENSE-0BSD
# Apache-2.0 - ./cargo_home/gentoo/toml-0.5.11/LICENSE-APACHE
# Apache-2.0 BSD CC-BY-3.0 MIT - ./cargo_home/gentoo/crossbeam-channel-0.5.9/LICENSE-THIRD-PARTY
# BSD - ./cargo_home/gentoo/instant-0.1.12/LICENSE
# CC0-1.0 - ./cargo_home/gentoo/tao-0.16.5/LICENSE.spdx
# MPL-2.0 - ./cargo_home/gentoo/cssparser-macros-0.6.1/LICENSE
# Unicode-DFS-2016 - ./cargo_home/gentoo/bstr-1.8.0/src/unicode/data/LICENSE-UNICODE
# ZLIB - ./cargo_home/gentoo/miniz_oxide-0.7.1/LICENSE-ZLIB.md
NPM_PACKAGES_LICENSES="
	(
		(
			all-rights-reserved
			MIT
		)
		0BSD
		Apache-2.0
		BSD
		BSD-2
		ISC
		MIT
	)
	(
		all-rights-reserved
		MIT
	)
	(
		Alliance-for-Open-Media-Patent-License-1.0
		BSD
		BSD-2
		FTL
		IJG
		LGPL-3
		libpng
		libtiff
		MIT
		MPL-2.0
		ZLIB
	)
	(
		MIT
		CC0-1.0
	)
	(
		MIT
		WTFPL-2
	)
	Apache-2.0
	BSD
	BSD-2
	CC-BY-4.0
	ISC
	MagentaMgOpen
	MIT
	MPL-2.0
	OFL-1.1
	PSF-2.2
	|| (
		Apache-2.0
		MPL-2.0
	)
	|| (
		AFL-2.1
		BSD
	)
"
# 0BSD Apache-2.0 BSD BSD-2 ISC MIT ( MIT all-rights-reserved ) - ./amica-app-v0.2.1/node_modules/prettier/LICENSE
# Alliance-for-Open-Media-Patent-License-1.0 BSD BSD-2 FTL IJG LGPL-3 libpng libtiff MIT MPL-2.0 ZLIB - ./amica-app-v0.2.1/node_modules/sharp/vendor/8.14.5/linux-x64/THIRD-PARTY-NOTICES.md
# Apache-2.0 - ./amica-app-v0.2.1/node_modules/sharp/LICENSE
# BSD - ./amica-app-v0.2.1/node_modules/istanbul-lib-source-maps/LICENSE
# BSD-2 - ./amica-app-v0.2.1/node_modules/eslint-scope/LICENSE
# CC-BY-4.0 - ./amica-app-v0.2.1/node_modules/caniuse-lite/LICENSE
# ISC - ./amica-app-v0.2.1/node_modules/filelist/node_modules/minimatch/LICENSE
# MagentaMgOpen - ./amica-app-v0.2.1/node_modules/three/examples/fonts/LICENSE
# MIT - amica-app-v0.2.1/node_modules/dir-glob/license
# MIT all-rights-reserved - ./amica-app-v0.2.1/node_modules/string_decoder/LICENSE
# MIT all-rights-reserved - ./amica-app-v0.2.1/node_modules/convert-source-map/LICENSE
# MIT CC0-1.0 - ./amica-app-v0.2.1/node_modules/lodash.sortby/LICENSE
# MIT WTFPL-2 - ./amica-app-v0.2.1/node_modules/path-is-inside/LICENSE.txt
# MPL-2.0 - ./amica-app-v0.2.1/node_modules/axe-core/LICENSE
# OFL-1.1 - ./amica-app-v0.2.1/node_modules/polished/docs/assets/fonts/LICENSE.txt
# PSF-2.2 - ./amica-app-v0.2.1/node_modules/protobufjs/cli/node_modules/argparse/LICENSE
# ^^ ( Apache-2.0 MPL-2.0 ) - ./amica-app-v0.2.1/node_modules/dompurify/LICENSE
# || ( AFL-2.1 BSD ) - ./amica-app-v0.2.1/node_modules/json-schema/LICENSE
LICENSE="
	${CARGO_PACKAGES_LICENSES}
	${NPM_PACKAGES_LICENSES}
	MIT
"
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="mirror"
SLOT="0"
IUSE+="
coqui debug ollama tray voice-recognition wayland whisper-cpp X
ebuild_revision_1
"
REQUIRED_USE="
	voice-recognition
	whisper-cpp? (
		voice-recognition
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
			(
				=net-libs/webkit-gtk-${s}*:4[javascript,jit,introspection,wayland?,webassembly,X?,webgl]
		"

	# tts - voice synthesis
		echo "
		"

	# stt - voice recognition
		echo "
				voice-recognition? (
					=net-libs/webkit-gtk-${s}*:4[microphone]
				)
			)
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
"
RUST_BINDINGS_BDEPEND="
	virtual/pkgconfig
"
RDEPEND+="
	${RUST_BINDINGS_DEPEND}
	coqui? (
		$(python_gen_cond_dep '
			dev-python/coqui-tts[${PYTHON_USEDEP}]
		')
		sys-process/procps
	)
	ollama? (
		app-misc/ollama
	)
	whisper-cpp? (
		app-accessibility/whisper-cpp
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${RUST_BINDINGS_BDEPEND}
	=net-libs/nodejs-18*[npm]
	virtual/pkgconfig
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
DOCS=( "README.md" )

check_sandbox() {
	if has network-sandbox ${FEATURES} ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download fonts and to compile."
eerror
		die
	fi
}

pkg_setup() {
	ewarn "${PN} is still broken for ollama support."
	npm_pkg_setup
	export NEXT_TELEMETRY_DISABLED=1
	check_sandbox
	python_setup
}

_lockfile_gen_unpack() {
	cd "${S}" || die
einfo "Generating lockfile"
	rm Cargo.lock
	cargo generate-lockfile || die "Failed to update Cargo.lock"
	die
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
	unpack "${TARBALL}"
#die # debug / fixme
einfo "Unpacking npm packages"
	if [[ "${PV}" =~ "_p" ]] ; then
		S="${S_PROJECT}/" \
		npm_src_unpack
	else
		S="${S_PROJECT}/" \
		npm_src_unpack
	fi
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
	eapply "${FILESDIR}/${PN}-0.2.1_p20241022-debug.patch"
	eapply "${FILESDIR}/${PN}-0.2.1_p20241022-ollama.patch"
#	eapply -R "${DISTDIR}/${PN}-commit-da5a390.patch"
#	eapply "${FILESDIR}/${PN}-0.2.1_p20241022-coqui-local.patch"
}

src_configure() {
	sed \
		-i \
		-e "s|\"targets\": \"all\"|\"targets\": \"deb\"|g" \
		"${S}/src-tauri/tauri.conf.json" \
		|| die
	cargo_src_configure
}

src_compile() {
	npm_hydrate
	if use debug ; then
		enpm run tauri dev
	else
		enpm run tauri build
	fi
	grep -e "FetchError:" "${T}/build.log" && die
}

src_install() {
#	pushd "${S_PROJECT}/src-tauri" >/dev/null 2>&1 || die
#		S="${S_PROJECT}/src-tauri" \
#		cargo_src_install
#	popd >/dev/null 2>&1 || die
#	rm -rf "${ED}/usr/bin/app" || die

	exeinto "/usr/lib/${PN}"
	if use debug ; then
		doexe "src-tauri/target/debug/${PN}"
	else
		doexe "src-tauri/target/release/${PN}"
	fi

	newicon -s 48 "app-icon.png" "${PN}.png"
	make_desktop_entry \
		"/usr/bin/${PN}" \
		"${PN^}" \
		"${PN}.png" \
		"Utility;"
	docinto "licenses"
	dodoc "LICENSE"

if false ; then
	LCNR_SOURCE="${WORKDIR}/cargo_home/gentoo"
	LCNR_TAG="third_party_cargo"
	lcnr_install_files

	LCNR_SOURCE="${S_PROJECT}/node_modules"
	LCNR_TAG="third_party_npm"
	lcnr_install_files
fi

	USE_COQUI=$(usex coqui "1" "0")

	dodir "/usr/bin"
cat <<EOF > "${ED}/usr/bin/amica"
#!/bin/bash
USE_COQUI=\${USE_COQUI:-${USE_COQUI}}
if [[ "\${USE_COQUI}" == "1" ]] ; then
	if ! ps aux | grep -q "TTS/server/server.py" ; then
"${EPYTHON}" "/usr/lib/${EPYTHON}/site-packages/TTS/server/server.py" --model_name "tts_models/en/vctk/vits" &
	fi
fi
"/usr/lib/${PN}/${PN}" \$@
EOF
	fperms 0755 "/usr/bin/amica"
	fowners "root:root" "/usr/bin/amica"
}

pkg_postinst() {
	xdg_pkg_postinst
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  Passed (0.2.1_p20241022, 20241117)
# ollama support - passed (with smollm:135m)
