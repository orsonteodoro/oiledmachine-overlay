# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 22.04

# NPM_AUDIT_FIX=0

NPM_INSTALL_ARGS=(
	"--prefer-offline"
)

# To update npm side use:
# PATH="/usr/local/oiledmachine-overlay/scripts:${PATH}"
# NPM_UPDATER_PROJECT_ROOT="coolercontrol-1.4.5/coolercontrol-ui" NPM_UPDATER_VERSIONS="1.4.5" npm_updater_update_locks.sh

# To update cargo side use:
# ./convert-cargo-lock.sh 1.4.5 1.4.5

PLUGINS_WORKSPACE_COMMIT="5e3900e682e13f3759b439116ae2f77a6d389ca2" # Same as below

declare -A GIT_CRATES=(
)

CRATES="
addr2line-0.24.2
adler2-2.0.0
aho-corasick-1.1.3
alloc-no-stdlib-2.0.4
alloc-stdlib-0.2.2
android-tzdata-0.1.1
android_system_properties-0.1.5
anstream-0.6.18
anstyle-1.0.10
anstyle-parse-0.2.6
anstyle-query-1.1.2
anstyle-wincon-3.0.7
anyhow-1.0.95
arboard-3.4.1
ascii-1.1.0
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
async-trait-0.1.85
atk-0.18.2
atk-sys-0.18.2
atomic-waker-1.1.2
autocfg-1.4.0
backtrace-0.3.74
base64-0.21.7
base64-0.22.1
bitflags-1.3.2
bitflags-2.8.0
block-0.1.6
block-buffer-0.10.4
block2-0.5.1
blocking-1.6.1
brotli-7.0.0
brotli-decompressor-4.0.1
bumpalo-3.16.0
bytemuck-1.21.0
byteorder-1.5.0
byteorder-lite-0.1.0
bytes-1.9.0
cairo-rs-0.18.5
cairo-sys-rs-0.18.2
camino-1.1.9
cargo-platform-0.1.9
cargo_metadata-0.19.1
cargo_toml-0.21.0
cc-1.2.10
cesu8-1.1.0
cfb-0.7.3
cfg-expr-0.15.8
cfg-if-1.0.0
cfg_aliases-0.2.1
chrono-0.4.39
chunked_transfer-1.5.0
clap-4.5.26
clap_builder-4.5.26
clap_lex-0.7.4
clipboard-win-5.4.0
cocoa-0.26.0
cocoa-foundation-0.2.0
colorchoice-1.0.3
combine-4.6.7
concurrent-queue-2.5.0
convert_case-0.4.0
cookie-0.18.1
core-foundation-0.10.0
core-foundation-0.9.4
core-foundation-sys-0.8.7
core-graphics-0.23.2
core-graphics-0.24.0
core-graphics-types-0.1.3
core-graphics-types-0.2.0
cpufeatures-0.2.16
crc32fast-1.4.2
crossbeam-channel-0.5.14
crossbeam-utils-0.8.21
crypto-common-0.1.6
cssparser-0.27.2
cssparser-macros-0.6.1
ctor-0.2.9
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
displaydoc-0.2.5
dlopen2-0.7.0
dlopen2_derive-0.4.0
dpi-0.1.1
dtoa-1.0.9
dtoa-short-0.3.5
dunce-1.0.5
dyn-clone-1.0.17
embed-resource-2.5.1
embed_plist-1.2.2
encoding_rs-0.8.35
endi-1.1.0
enumflags2-0.7.11
enumflags2_derive-0.7.11
equivalent-1.0.1
erased-serde-0.4.5
errno-0.3.10
error-code-3.3.1
event-listener-5.4.0
event-listener-strategy-0.5.3
fastrand-2.3.0
fdeflate-0.3.7
field-offset-0.3.6
flate2-1.0.35
fnv-1.0.7
foreign-types-0.5.0
foreign-types-macros-0.2.3
foreign-types-shared-0.3.1
form_urlencoded-1.2.1
futf-0.1.5
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
gdk-0.18.0
gdk-pixbuf-0.18.5
gdk-pixbuf-sys-0.18.0
gdk-sys-0.18.2
gdkwayland-sys-0.18.2
gdkx11-0.18.2
gdkx11-sys-0.18.2
generic-array-0.14.7
gethostname-0.4.3
getrandom-0.1.16
getrandom-0.2.15
gimli-0.31.1
gio-0.18.4
gio-sys-0.18.1
glib-0.18.5
glib-macros-0.18.5
glib-sys-0.18.1
glob-0.3.2
gobject-sys-0.18.0
gtk-0.18.1
gtk-sys-0.18.2
gtk3-macros-0.18.2
hashbrown-0.12.3
hashbrown-0.15.2
heck-0.4.1
heck-0.5.0
hermit-abi-0.4.0
hex-0.4.3
html5ever-0.26.0
http-1.2.0
http-body-1.0.1
http-body-util-0.1.2
httparse-1.9.5
httpdate-1.0.3
hyper-1.5.2
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
image-0.25.5
indexmap-1.9.3
indexmap-2.7.0
infer-0.16.0
ipnet-2.10.1
is-docker-0.2.0
is-wsl-0.4.0
is_terminal_polyfill-1.70.1
itoa-0.4.8
itoa-1.0.14
javascriptcore-rs-1.1.2
javascriptcore-rs-sys-1.1.1
jni-0.21.1
jni-sys-0.3.0
jpeg-decoder-0.3.1
js-sys-0.3.77
json-patch-3.0.1
jsonptr-0.6.3
keyboard-types-0.7.0
kuchikiki-0.8.2
lazy_static-1.5.0
libappindicator-0.9.0
libappindicator-sys-0.9.0
libc-0.2.169
libloading-0.7.4
libredox-0.1.3
linux-raw-sys-0.4.15
litemap-0.7.4
lock_api-0.4.12
log-0.4.25
mac-0.1.1
malloc_buf-0.0.6
markup5ever-0.11.0
matches-0.1.10
memchr-2.7.4
memoffset-0.9.1
mime-0.3.17
miniz_oxide-0.8.3
mio-1.0.3
muda-0.15.3
ndk-0.9.0
ndk-context-0.1.1
ndk-sys-0.6.0+11769913
new_debug_unreachable-1.0.6
nix-0.27.1
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
object-0.36.7
once_cell-1.20.2
open-5.3.2
option-ext-0.2.0
ordered-stream-0.2.0
os_pipe-1.2.1
pango-0.18.3
pango-sys-0.18.0
parking-2.2.1
parking_lot-0.12.3
parking_lot_core-0.9.10
pathdiff-0.2.3
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
pin-project-lite-0.2.16
pin-utils-0.1.0
piper-0.2.4
pkg-config-0.3.31
plist-1.7.0
png-0.17.16
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
proc-macro2-1.0.93
quick-xml-0.32.0
quote-1.0.38
rand-0.7.3
rand-0.8.5
rand_chacha-0.2.2
rand_chacha-0.3.1
rand_core-0.5.1
rand_core-0.6.4
rand_hc-0.2.0
rand_pcg-0.2.1
raw-window-handle-0.6.2
redox_syscall-0.5.8
redox_users-0.4.6
regex-1.11.1
regex-automata-0.4.9
regex-syntax-0.8.5
reqwest-0.12.12
rustc-demangle-0.1.24
rustc_version-0.4.1
rustix-0.38.43
rustversion-1.0.19
ryu-1.0.18
same-file-1.0.6
schemars-0.8.21
schemars_derive-0.8.21
scopeguard-1.2.0
selectors-0.22.0
semver-1.0.24
serde-1.0.217
serde-untagged-0.1.6
serde_derive-1.0.217
serde_derive_internals-0.29.1
serde_json-1.0.136
serde_repr-0.1.19
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
smallvec-1.13.2
socket2-0.5.8
softbuffer-0.4.6
soup3-0.5.0
soup3-sys-0.5.0
stable_deref_trait-1.2.0
static_assertions-1.1.0
string_cache-0.8.7
string_cache_codegen-0.5.2
strsim-0.11.1
swift-rs-1.0.7
syn-1.0.109
syn-2.0.96
sync_wrapper-1.0.2
synstructure-0.13.1
system-deps-6.2.2
tao-0.31.1
tao-macros-0.1.3
target-lexicon-0.12.16
tauri-2.2.3
tauri-build-2.0.5
tauri-codegen-2.0.4
tauri-macros-2.0.4
tauri-plugin-2.0.4
tauri-plugin-cli-2.2.0
tauri-plugin-clipboard-manager-2.2.0
tauri-plugin-localhost-2.2.0
tauri-plugin-shell-2.2.0
tauri-plugin-store-2.2.0
tauri-plugin-window-state-2.2.0
tauri-runtime-2.3.0
tauri-runtime-wry-2.3.0
tauri-utils-2.1.1
tauri-winres-0.1.1
tempfile-3.15.0
tendril-0.4.3
thin-slice-0.1.1
thiserror-1.0.69
thiserror-2.0.11
thiserror-impl-1.0.69
thiserror-impl-2.0.11
tiff-0.9.1
time-0.3.37
time-core-0.1.2
time-macros-0.2.19
tiny_http-0.12.0
tinystr-0.7.6
tokio-1.43.0
tokio-macros-2.5.0
tokio-util-0.7.13
toml-0.7.8
toml-0.8.19
toml_datetime-0.6.8
toml_edit-0.19.15
toml_edit-0.20.7
toml_edit-0.22.22
tower-0.5.2
tower-layer-0.3.3
tower-service-0.3.3
tracing-0.1.41
tracing-attributes-0.1.28
tracing-core-0.1.33
tray-icon-0.19.2
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
url-2.5.4
urlpattern-0.3.0
utf-8-0.7.6
utf16_iter-1.0.5
utf8_iter-1.0.4
utf8parse-0.2.2
uuid-1.12.0
version-compare-0.2.0
version_check-0.9.5
vswhom-0.1.0
vswhom-sys-0.1.2
walkdir-2.5.0
want-0.3.1
wasi-0.11.0+wasi-snapshot-preview1
wasi-0.9.0+wasi-snapshot-preview1
wasm-bindgen-0.2.100
wasm-bindgen-backend-0.2.100
wasm-bindgen-futures-0.4.50
wasm-bindgen-macro-0.2.100
wasm-bindgen-macro-support-0.2.100
wasm-bindgen-shared-0.2.100
wasm-streams-0.4.2
web-sys-0.3.77
webkit2gtk-2.0.1
webkit2gtk-sys-2.0.1
webview2-com-0.34.0
webview2-com-macros-0.8.0
webview2-com-sys-0.34.0
weezl-0.1.8
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
windows-result-0.2.0
windows-strings-0.1.0
windows-sys-0.45.0
windows-sys-0.48.0
windows-sys-0.52.0
windows-sys-0.59.0
windows-targets-0.42.2
windows-targets-0.48.5
windows-targets-0.52.6
windows-targets-0.53.0
windows-version-0.1.2
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
winnow-0.6.24
winreg-0.52.0
write16-1.0.0
writeable-0.5.5
wry-0.48.1
x11-2.21.0
x11-dl-2.21.0
x11rb-0.13.1
x11rb-protocol-0.13.1
xdg-home-1.3.0
yoke-0.7.5
yoke-derive-0.7.5
zbus-4.0.1
zbus_macros-4.0.1
zbus_names-3.0.0
zerocopy-0.7.35
zerocopy-derive-0.7.35
zerofrom-0.1.5
zerofrom-derive-0.1.5
zerovec-0.10.4
zerovec-derive-0.10.3
zvariant-4.2.0
zvariant_derive-4.2.0
zvariant_utils-1.1.0
zvariant_utils-2.1.0
"

NODE_SLOTS="18"
NPM_TARBALL="coolercontrol-${PV}.tar.bz2"
PYTHON_COMPAT=( "python3_"{10,11} ) # Can support 3.12 but limited by Nuitka
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
IUSE+=" tray wayland X ebuild_revision_5"
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
	rust_pkg_setup
}

npm_update_lock_install_post() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
	# CVE-2025-24964; DoS, DT, ID; Critical
		pushd "${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui" >/dev/null 2>&1 || die
			sed -i -e "s|\"vitest\": \"^2.1.8\"|\"vitest\": \"^2.1.9\"|" "package.json" || die
			enpm install "vitest@2.1.9" -D --prefer-offline

			sed -i -e "s|\"esbuild\": \"^0.24.2\"|\"esbuild\": \"^0.25.0\"|g" # Must follow vitest
			enpm install "esbuild@^0.25.0" -D
		popd >/dev/null 2>&1 || die
	fi
}

src_unpack() {
	local commit="${PLUGINS_WORKSPACE_COMMIT}"
	S="${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui" \
	npm_src_unpack
	S="${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui/src-tauri" \
	_cargo_src_unpack

	cd "${WORKDIR}" || die
if false ; then
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
fi
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
		enpm install ${NPM_INSTALL_ARGS[@]}
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
