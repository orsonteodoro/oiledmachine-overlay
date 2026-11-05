# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U20

#
# Security note:
#
# The tauri-plugin-autostart-api references have been removed in addition
# to the cargo autostart code, but the WindowPet repo still needs a code
# review for the possibility of leftovers or malicious domains.
#
# See also:
# https://github.com/advisories/GHSA-32xm-jpw6-7frx
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2025-01-16-rotate-passwords/2025-01-16-rotate-passwords.txt
#

# To update lockfile
# PATH=$(realpath "../../scripts")":${PATH}"
# NPM_UPDATER_VERSIONS="0.0.9" npm_updater_update_locks.sh

MY_PN="WindowPet"

GEN_CARGO_LOCKFILE=0 # 0, 1, unset (0)
NODE_SLOT="24" # CI uses 23 based on CI logs, bump for security
NPM_AUDIT_FATAL=0
NPM_AUDIT_FIX=1
NPM_SKIP_TARBALL_UNPACK="1"
PLUGINS_WORKSPACE_COMMIT="685d3424a946346721d839add3bfb6521690eb6e" # Obtained from GIT_CRATES
# Upstream wanted Rust 1.88.0 (llvm 20.1), but it has been relaxed in this ebuild.
RUST_MAX_VER="1.93.1"
RUST_MIN_VER="1.93.1" # llvm-21.1
RUST_PV="${RUST_MIN_VER}"
SECURE_VERSION_NODE_EBUILD_UPDATE=1793848992
SECURE_VERSION_RUST_EBUILD_UPDATE=1793849048

AT_TYPES_NODE_PV="22.13.4" # Same as TypeScript

# Autostart is disabled to mitigate Arbitrary Code Execution (ACE).
# Remove the following in src-tauri/Cargo.toml, src-tauri/Cargo.lock and from CRATES:
# auto-launch 0.5.0
# dirs 4.0.0
# dirs-sys 0.3.7
# tauri-plugin-autostart 0.0.0
# winreg 0.10.1

BANNED_CARGO_PACKAGES=(
	"auto-launch;F"
	"dirs;W"
	"dirs-sys;W"
	"tauri-plugin-autostart;F"
	"winreg;W"
)

declare -A BANNED_CARGO_PACKAGES_PV=(
	["auto-launch"]="0.5.0"
	["dirs"]="4.0.0"
	["dirs-sys"]="0.3.7"
	["tauri-plugin-autostart"]="0.0.0"
	["winreg"]="0.10.1"
)

# Remove tauri-plugin-autostart from GIT_CRATES:
declare -A GIT_CRATES=(
[tauri-plugin-dialog]="https://github.com/tauri-apps/plugins-workspace;685d3424a946346721d839add3bfb6521690eb6e;plugins-workspace-%commit%/plugins/dialog" # 2.8.4
[tauri-plugin-fs]="https://github.com/tauri-apps/plugins-workspace;685d3424a946346721d839add3bfb6521690eb6e;plugins-workspace-%commit%/plugins/fs" # 2.7.1
[tauri-plugin-log]="https://github.com/tauri-apps/plugins-workspace;685d3424a946346721d839add3bfb6521690eb6e;plugins-workspace-%commit%/plugins/log" # 2.10.1
[tauri-plugin-process]="https://github.com/tauri-apps/plugins-workspace;685d3424a946346721d839add3bfb6521690eb6e;plugins-workspace-%commit%/plugins/process" # 2.4.0
[tauri-plugin-shell]="https://github.com/tauri-apps/plugins-workspace;685d3424a946346721d839add3bfb6521690eb6e;plugins-workspace-%commit%/plugins/shell" # 2.6.0
[tauri-plugin-single-instance]="https://github.com/tauri-apps/plugins-workspace;685d3424a946346721d839add3bfb6521690eb6e;plugins-workspace-%commit%/plugins/single-instance" # 2.5.5
[tauri-plugin-store]="https://github.com/tauri-apps/plugins-workspace;685d3424a946346721d839add3bfb6521690eb6e;plugins-workspace-%commit%/plugins/store" # 2.5.0
[tauri-plugin-updater]="https://github.com/tauri-apps/plugins-workspace;685d3424a946346721d839add3bfb6521690eb6e;plugins-workspace-%commit%/plugins/updater" # 2.14.1
)

CRATES="
adler2-2.0.1
aho-corasick-1.1.5
alloc-no-stdlib-3.0.0
alloc-stdlib-0.3.0
android_logger-0.15.1
android_log-sys-0.3.2
android_system_properties-0.1.6
anyhow-1.0.104
async-broadcast-0.7.2
async-channel-2.5.0
async-executor-1.14.1
async-io-2.6.0
async-lock-3.5.0
async-process-2.5.0
async-recursion-1.2.0
async-signal-0.2.14
async-task-4.7.1
async-trait-0.1.92
atk-0.18.2
atk-sys-0.18.2
atomic-waker-1.1.2
autocfg-1.5.1
base64-0.21.7
base64-0.23.1
bitflags-1.3.2
bitflags-2.13.2
bit-set-0.8.0
bit-vec-0.8.0
block2-0.6.2
block-buffer-0.10.4
blocking-1.7.0
brotli-9.1.1
brotli-decompressor-6.2.0
bs58-0.5.1
bumpalo-3.20.3
bytemuck-1.25.2
byteorder-1.5.0
bytes-1.12.1
cairo-rs-0.18.5
cairo-sys-rs-0.18.2
camino-1.2.6
cargo_metadata-0.19.2
cargo-platform-0.1.9
cargo_toml-1.0.1
cc-1.11.0
cesu8-1.1.0
cfb-0.14.0
cfg_aliases-0.2.2
cfg-expr-0.15.8
cfg-if-1.0.5
chrono-0.4.45
combine-4.6.9
concurrent-queue-2.5.0
cookie-0.18.2
core_detect-1.0.0
core-foundation-0.10.1
core-foundation-0.9.4
core-foundation-sys-0.8.7
core-graphics-0.22.3
core-graphics-0.25.0
core-graphics-types-0.1.3
core-graphics-types-0.2.0
cpufeatures-0.2.17
crc32fast-1.5.4
crossbeam-channel-0.5.17
crossbeam-utils-0.8.23
crypto-common-0.1.7
cssparser-0.37.0
cssparser-macros-0.7.1
ctor-1.0.13
darling-0.24.1
darling_core-0.24.1
darling_macro-0.24.1
dbus-0.9.12
defmt-1.2.0
defmt-macros-1.2.0
defmt-parser-1.1.0
deranged-0.5.9
derive_more-2.1.1
derive_more-impl-2.1.1
digest-0.10.7
dirs-7.0.0
dirs-sys-0.5.0
dispatch2-0.3.1
displaydoc-0.2.7
dlopen2-0.8.2
dlopen2_derive-0.4.3
dom_query-0.28.0
dpi-0.1.2
dtoa-1.0.11
dtoa-short-0.3.5
dunce-1.0.5
dyn-clone-1.0.20
embed_plist-1.2.2
embed-resource-3.0.12
encoding_rs-0.8.44
endi-1.1.1
enumflags2-0.7.12
enumflags2_derive-0.7.12
env_filter-0.1.4
equivalent-1.0.3
erased-serde-0.4.11
errno-0.3.14
event-listener-5.4.2
event-listener-strategy-0.5.4
fastrand-2.5.0
fdeflate-0.3.7
fern-0.7.1
field-offset-0.3.6
filetime-0.2.29
find-msvc-tools-0.1.15
flate2-1.1.10
fnv-1.0.7
foldhash-0.2.0
foreign-types-0.3.2
foreign-types-0.5.0
foreign-types-macros-0.2.4
foreign-types-shared-0.1.1
foreign-types-shared-0.3.1
form_urlencoded-1.2.2
futures-channel-0.3.34
futures-core-0.3.34
futures-executor-0.3.34
futures-io-0.3.34
futures-lite-2.6.1
futures-macro-0.3.34
futures-sink-0.3.34
futures-task-0.3.34
futures-util-0.3.34
gdk-0.18.2
gdk-pixbuf-0.18.5
gdk-pixbuf-sys-0.18.0
gdk-sys-0.18.2
gdkwayland-sys-0.18.2
gdkx11-0.18.2
gdkx11-sys-0.18.2
generic-array-0.14.7
getrandom-0.2.17
getrandom-0.3.4
getrandom-0.4.3
gio-0.18.4
gio-sys-0.18.1
glib-0.18.5
glib-macros-0.18.5
glib-sys-0.18.1
glob-0.3.4
gobject-sys-0.18.0
gtk-0.18.2
gtk3-macros-0.18.2
gtk-sys-0.18.2
hashbrown-0.12.3
hashbrown-0.17.1
heck-0.4.1
heck-0.5.0
hermit-abi-0.5.3
hex-0.4.3
html5ever-0.39.0
http-1.5.0
httparse-1.10.1
http-body-1.1.0
http-body-util-0.1.5
http-range-0.1.6
hyper-1.12.0
hyper-rustls-0.27.10
hyper-util-0.1.21
iana-time-zone-0.1.65
iana-time-zone-haiku-0.1.2
ico-0.6.0
icu_collections-2.4.0
icu_locale_core-2.4.0
icu_normalizer-2.4.0
icu_normalizer_data-2.4.0
icu_properties-2.4.0
icu_properties_data-2.4.0
icu_provider-2.4.0
ident_case-1.0.1
idna-1.1.0
idna_adapter-1.2.2
indexmap-1.9.3
indexmap-2.14.2
infer-0.22.0
ipnet-2.12.2
is-docker-0.2.0
is-wsl-0.4.0
itoa-1.0.18
javascriptcore-rs-1.1.2
javascriptcore-rs-sys-1.1.1
jiff-0.2.39
jiff-core-0.1.2
jiff-static-0.2.39
jiff-tzdb-0.1.9
jiff-tzdb-platform-0.1.3
jni-0.21.1
jni-0.22.4
jni-macros-0.22.4
jni-sys-0.3.1
jni-sys-0.4.1
jni-sys-macros-0.4.1
json-patch-4.2.0
jsonptr-0.7.1
js-sys-0.3.107
keyboard-types-0.8.3
libappindicator-0.9.0
libappindicator-sys-0.9.0
libc-0.2.191
libdbus-sys-0.2.7
libloading-0.7.4
libredox-0.1.25
linux-raw-sys-0.12.1
litemap-0.8.3
lock_api-0.4.14
log-0.4.35
markup5ever-0.39.0
memchr-2.8.3
memoffset-0.9.1
mime-0.3.17
minisign-verify-0.3.0
miniz_oxide-0.8.9
miniz_oxide-0.9.1
mio-1.2.4
mouse_position-0.1.4
muda-0.20.0
multiversion_no_op-1.0.0
ndk-0.9.0
ndk-context-0.1.1
ndk-sys-0.6.0+11769913
new_debug_unreachable-1.0.6
nix-0.31.3
num-conv-0.2.2
num_enum-0.7.6
num_enum_derive-0.7.6
num_threads-0.1.8
num-traits-0.2.19
objc2-0.6.5
objc2-app-kit-0.3.2
objc2-cloud-kit-0.3.2
objc2-core-data-0.3.2
objc2-core-foundation-0.3.2
objc2-core-graphics-0.3.2
objc2-core-image-0.3.2
objc2-core-location-0.3.2
objc2-core-text-0.3.2
objc2-encode-4.1.0
objc2-exception-helper-0.1.1
objc2-foundation-0.3.2
objc2-io-surface-0.3.2
objc2-osa-kit-0.3.2
objc2-quartz-core-0.3.2
objc2-ui-kit-0.3.2
objc2-user-notifications-0.3.2
objc2-web-kit-0.3.2
once_cell-1.21.4
open-5.4.5
openssl-probe-0.2.2
option-ext-0.2.0
ordered-stream-0.2.0
osakit-0.3.1
os_pipe-1.2.3
pango-0.18.3
pango-sys-0.18.0
parking-2.2.1
parking_lot-0.12.5
parking_lot_core-0.9.12
percent-encoding-2.3.2
phf-0.13.1
phf_codegen-0.13.1
phf_generator-0.13.1
phf_macros-0.13.1
phf_shared-0.13.1
pin-project-lite-0.2.17
piper-0.2.5
pkg-config-0.3.34
plist-1.10.3
png-0.18.1
polling-3.11.0
portable-atomic-1.15.0
portable-atomic-util-0.2.8
potential_utf-0.1.6
powerfmt-0.2.1
precomputed-hash-0.1.1
proc-macro2-1.0.107
proc-macro-crate-1.3.1
proc-macro-crate-2.0.2
proc-macro-crate-3.5.0
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
quick-xml-0.42.0
quote-1.0.47
raw-window-handle-0.6.2
redox_syscall-0.5.18
redox_users-0.5.3
ref-cast-1.0.27
ref-cast-impl-1.0.27
r-efi-5.3.0
r-efi-6.0.0
regex-1.13.1
regex-automata-0.4.18
regex-syntax-0.8.11
reqwest-0.13.5
rfd-0.17.2
ring-0.17.14
rustc-hash-2.1.3
rustc_version-0.4.1
rustix-1.1.6
rustls-0.23.46
rustls-native-certs-0.8.5
rustls-pki-types-1.15.1
rustls-platform-verifier-0.7.1
rustls-platform-verifier-android-0.2.0
rustls-webpki-0.103.16
rustversion-1.0.23
same-file-1.0.6
schannel-0.1.30
schemars-0.8.22
schemars-0.9.0
schemars-1.2.3
schemars_derive-0.8.22
scopeguard-1.2.0
security-framework-3.7.0
security-framework-sys-2.17.0
selectors-0.38.0
semver-1.0.28
serde-1.0.229
serde_core-1.0.229
serde_derive-1.0.229
serde_derive_internals-0.29.1
serde_json-1.0.154
serde_repr-0.1.21
serde_spanned-0.6.9
serde_spanned-1.1.2
serde-untagged-0.1.9
serde_with-3.24.0
serde_with_macros-3.24.0
serialize-to-javascript-0.1.2
serialize-to-javascript-impl-0.1.2
servo_arc-0.4.3
sha2-0.10.9
shared_child-1.1.2
shlex-2.0.1
signal-hook-registry-1.4.8
simd-adler32-0.3.10
simd_cesu8-1.2.0
simdutf8-0.1.5
siphasher-1.0.4
slab-0.4.12
smallvec-1.16.4
socket2-0.6.5
softbuffer-0.4.8
soup3-0.5.0
soup3-sys-0.5.0
stable_deref_trait-1.2.1
static_vcruntime-3.0.0
string_cache-0.9.0
string_cache_codegen-0.6.1
strsim-0.11.1
subtle-2.6.1
swift-rs-1.0.9
syn-1.0.109
syn-2.0.119
syn-3.0.9
sync_wrapper-1.0.2
synstructure-0.14.0
system-configuration-0.7.0
system-configuration-sys-0.6.0
system-deps-6.2.2
tao-0.37.2
tao-macros-0.1.4
tar-0.4.46
target-lexicon-0.12.16
tauri-2.12.5
tauri-build-2.7.4
tauri-codegen-2.7.4
tauri-macros-2.7.4
tauri-plugin-2.7.2
tauri-runtime-2.12.2
tauri-runtime-wry-2.12.3
tauri-utils-2.10.2
tauri-winres-0.3.7
tempfile-3.27.0
tendril-0.5.1
thiserror-1.0.69
thiserror-2.0.21
thiserror-impl-1.0.69
thiserror-impl-2.0.21
time-0.3.55
time-core-0.1.9
time-macros-0.2.32
tinystr-0.8.5
tinyvec-1.13.3
tokio-1.54.1
tokio-macros-2.7.2
tokio-rustls-0.26.6
tokio-util-0.7.20
toml-0.8.2
toml-1.2.0+spec-1.1.0
toml_datetime-0.6.3
toml_datetime-1.1.2+spec-1.1.0
toml_edit-0.19.15
toml_edit-0.20.2
toml_edit-0.25.18+spec-1.1.0
toml_parser-1.1.5+spec-1.1.0
toml_writer-1.2.0+spec-1.1.0
tower-0.5.3
tower-http-0.6.11
tower-layer-0.3.3
tower-service-0.3.3
tracing-0.1.44
tracing-attributes-0.1.31
tracing-core-0.1.36
tray-icon-0.25.1
try-lock-0.2.5
typed-path-0.13.0
typeid-1.0.3
typenum-1.20.1
uds_windows-1.2.1
unicode-ident-1.0.27
unicode-segmentation-1.13.3
untrusted-0.9.0
url-2.5.8
urlpattern-0.6.0
utf8_iter-1.1.0
utf_types-1.0.0
uuid-1.29.0
version_check-0.9.5
version-compare-0.2.1
vswhom-0.1.0
vswhom-sys-0.1.3
walkdir-2.5.0
want-0.3.2
wasi-0.11.1+wasi-snapshot-preview1
wasip2-1.0.4+wasi-0.2.12
wasm-bindgen-0.2.130
wasm-bindgen-futures-0.4.80
wasm-bindgen-macro-0.2.130
wasm-bindgen-macro-support-0.2.130
wasm-bindgen-shared-0.2.130
wasm-streams-0.5.0
web_atoms-0.2.6
webkit2gtk-2.0.2
webkit2gtk-sys-2.0.2
webpki-root-certs-1.0.11
web-sys-0.3.107
web-time-1.1.0
webview2-com-0.39.1
webview2-com-macros-0.8.1
webview2-com-sys-0.39.1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.11
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.62.2
windows_aarch64_gnullvm-0.42.2
windows_aarch64_gnullvm-0.52.6
windows_aarch64_gnullvm-0.53.1
windows_aarch64_msvc-0.42.2
windows_aarch64_msvc-0.52.6
windows_aarch64_msvc-0.53.1
windows-collections-0.3.2
windows-core-0.62.2
windows-future-0.3.2
windows_i686_gnu-0.42.2
windows_i686_gnu-0.52.6
windows_i686_gnu-0.53.1
windows_i686_gnullvm-0.52.6
windows_i686_gnullvm-0.53.1
windows_i686_msvc-0.42.2
windows_i686_msvc-0.52.6
windows_i686_msvc-0.53.1
windows-implement-0.60.2
windows-interface-0.59.3
windows-link-0.2.1
windows-numerics-0.3.1
windows-registry-0.6.1
windows-result-0.4.1
windows-strings-0.5.1
windows-sys-0.45.0
windows-sys-0.52.0
windows-sys-0.60.2
windows-sys-0.61.2
windows-targets-0.42.2
windows-targets-0.52.6
windows-targets-0.53.5
windows-threading-0.2.1
windows-version-0.1.7
windows_x86_64_gnu-0.42.2
windows_x86_64_gnu-0.52.6
windows_x86_64_gnu-0.53.1
windows_x86_64_gnullvm-0.42.2
windows_x86_64_gnullvm-0.52.6
windows_x86_64_gnullvm-0.53.1
windows_x86_64_msvc-0.42.2
windows_x86_64_msvc-0.52.6
windows_x86_64_msvc-0.53.1
window-vibrancy-0.8.1
winnow-0.5.40
winnow-1.0.5
winreg-0.56.0
wit-bindgen-0.57.1
writeable-0.6.4
wry-0.57.1
x11-2.21.0
x11-dl-2.21.0
xattr-1.7.0
yoke-0.8.4
yoke-derive-0.8.4
zbus-5.19.0
zbus_macros-5.19.0
zbus_names-4.3.5
zcheapstr-1.2.0
zerofrom-0.1.8
zerofrom-derive-0.1.8
zeroize-1.9.1
zerotrie-0.2.5
zerovec-0.11.9
zerovec-derive-0.11.7
zip-9.3.0
zlib-rs-0.6.8
zmij-1.0.23
zvariant-5.15.1
zvariant_derive-5.15.1
zvariant_utils-4.2.0
"

CHKL_TIMESTAMPS=(
	"app-accessibility/at-spi2-core-9999"
	"dev-libs/glib-2.90.9999"
	"gnome-base/librsvg-9999"
	"net-libs/libsoup-2.74.9999"
	"sys-process/procps-9999"
	"x11-libs/cairo-9999"
	"x11-libs/gdk-pixbuf-9999"
	"x11-libs/gtk+-3.24.9999"
	"x11-libs/pango-9999"
)

inherit cargo chkl desktop lcnr npm secure-version secure-version-node secure-version-rust xdg

RUST_LOG_PV="0.4.21"

#KEYWORDS="~amd64" # Needs code audit or code review, deps are EOL
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
$(cargo_crate_uris ${CRATES})
https://github.com/SeakMengs/WindowPet/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

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
RESTRICT="
	mirror
" # Speed up downloads, stop snooping
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
libappindicator libayatana-appindicator tray wayland +X
ebuild_revision_17
"
REQUIRED_USE="
	tray? (
		|| (
			libappindicator
			libayatana-appindicator
		)
	)
	|| (
		wayland
		X
	)
"
RUST_BINDINGS_DEPEND="
	>=app-accessibility/at-spi2-core-${AT_SPI2_CORE_PV}:=[introspection]
	>=dev-libs/glib-${GLIB_PV}:=
	>=dev-libs/gobject-introspection-${GOBJECT_INTROSPECTION_PV}:=
	>=net-libs/libsoup-${LIBSOUP2_PV}:2.4=[introspection]
	>=x11-libs/cairo-${CAIRO_PV}:=
	>=x11-libs/gdk-pixbuf-${GDK_PIXBUF_PV}:=[introspection]
	>=x11-libs/gtk+-${GTK3_PV}:3=[introspection,wayland?,X?]
	>=x11-libs/pango-${PANGO_PV}:=[introspection]
	~net-libs/webkit-gtk-${WEBKIT_GTK_STABLE_PV}:4=[javascript,introspection,wayland?,X?]
	elibc_glibc? (
		>=sys-libs/glibc-${GLIBC_PV}:=
	)
	elibc_musl? (
		>=sys-libs/musl-${MUSL_PV}:=
	)
	tray? (
		libappindicator? (
			>=dev-libs/libappindicator-12.10.1_p20200408:3=
		)
		libayatana-appindicator? (
			>=dev-libs/libayatana-appindicator-0.5.4:=
		)
	)
"
RUST_BINDINGS_BDEPEND="
	virtual/pkgconfig
"
RDEPEND+="
	${RUST_BINDINGS_DEPEND}
	>=gnome-base/librsvg-${LIBRSVG_PV}:=
	>=net-libs/nodejs-${NODEJS_22_PV}:22=[npm]
	~net-libs/webkit-gtk-${WEBKIT_GTK_STABLE_PV}:4=[javascript,introspection,wayland?,X?]
	>=x11-libs/gtk+-${GTK3_PV}:3=[wayland?,X?]
	>=sys-process/procps-${PROCPS_PV}
	X? (
		x11-misc/xcompmgr:=
	)
	tray? (
		libappindicator? (
			dev-libs/libappindicator:3=
		)
		libayatana-appindicator? (
			dev-libs/libayatana-appindicator:=
		)
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND="
	${RUST_BINDINGS_BDEPEND}
	>=dev-util/patchelf-0.14.3
	|| (
		dev-lang/rust:${RUST_PV}[wasm]
		dev-lang/rust-bin:${RUST_PV}
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-0.0.9-tauri-v2-rs.patch"
	"${FILESDIR}/${PN}-0.0.9-tauri-v2-js-ts.patch"
	"${FILESDIR}/${PN}-0.0.9-tauri-v2-capabilities-json.patch"
	"${FILESDIR}/${PN}-0.0.9-tauri-v2-tauri-conf-json.patch"
)

pkg_setup() {
	secure-version-node_check_update
	secure-version-rust_check_update
	npm_pkg_setup
	rust_pkg_setup
}

# @FUNCTION: cargo_src_unpack
# @DESCRIPTION:
# Unpacks the package and the cargo registry.
# From cargo.eclass
_cargo_src_unpack() {
	debug-print-function "${FUNCNAME}" "$@"

	mkdir -p "${ECARGO_VENDOR}" || die
	mkdir -p "${S}" || die

	mkdir -p "${ECARGO_VENDOR}" "${S}" || die

	local archive shasum pkg
	local crates=()
	for archive in ${A} ; do
		case "${archive}" in
			*.crate)
				crates+=( "${archive}" )
				;;
			*)
				einfo "pwd:  "$(pwd)
				if [[ "${archive}" == "${P}.tar.gz" ]] ; then
					einfo "Skipping unpack for ${P}.tar.gz"
				else
					pushd "${WORKDIR}" || die
						unpack "${archive}"
					popd || die
				fi
				;;
		esac
	done

	if [[ "${PKGBUMPING}" != "${PVR}" && ${crates[@]} ]]; then
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
			if [[ "${P}" == "${pkg}"* ]]; then
				tar -xf "${archive}" -C "${WORKDIR}" || die
			fi
		done < <(sha256sum -z "${crates[@]}" || die)

		popd >/dev/null || die
	fi

	cargo_gen_config
}

npm_unpack_post() {
	pushd "${S}" >/dev/null 2>&1 || die
		if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
			eapply "${FILESDIR}/${PN}-0.0.8-remove-tauri-plugin-autostart-api-from-lockfiles.patch"
			eapply "${FILESDIR}/${PN}-0.0.8-remove-tauri-plugin-autostart-api-from-code.patch"
		else
			eapply "${FILESDIR}/${PN}-0.0.8-remove-tauri-plugin-autostart-api-from-code.patch"
			#eapply "${FILESDIR}/${PN}-0.0.9-disable-updater.patch"
		fi
	popd >/dev/null 2>&1 || die
}

npm_dedupe_post() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
#ewarn "QA:  Manually remove node_modules/esbuild (<0.25.0) and deps in ${S}/package-lock.json"
ewarn "QA:  Manually remove node_modules/vite-node/node_modules/vite in ${S}/package-lock.json"
ewarn "QA:  Manually remove node_modules/vitest/node_modules/vite in ${S}/package-lock.json"
		patch_lockfile() {
			sed -i -e "s|\"@babel/core\": \"^7.0.0\"|\"@babel/core\": \"^${NODE_BABEL_CORE_7_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"@babel/core\": \"^7.0.0-0\"|\"@babel/core\": \"^${NODE_BABEL_CORE_7_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"@babel/core\": \"^7.27.4\"|\"@babel/core\": \"^${NODE_BABEL_CORE_7_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"@remix-run/router\": \"1.23.0\"|\"@remix-run/router\": \"^${NODE_AT_REMIX_RUN_ROUTER_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"@vitest/mocker\": \"4.1.11\"|\"@vitest/mocker\": \"^${NODE_AT_VITEST_MOCKER_4_PV}\"|g" "package-lock.json" || die # 1 -> 4 could be a breaking change
			sed -i -e "s|\"brace-expansion\": \"^1.1.7\"|\"brace-expansion\": \"^${NODE_BRACE_EXPANSION_1_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"browserslist\": \"^4.24.0\"|\"browserslist\": \"^${NODE_BROWSERSLIST_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"esbuild\": \"^0.21.3\"|\"esbuild\": \"^${NODE_ESBUILD_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"form-data\": \"^4.0.0\"|\"form-data\": \"^${NODE_FORM_DATA_4_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"nanoid\": \"^3.3.11\"|\"nanoid\": \"^${NODE_NANOID_3_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"postcss\": \"^8.2.1\"|\"postcss\": \"^${NODE_POSTCSS_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"postcss\": \"^8.3.3\"|\"postcss\": \"^${NODE_POSTCSS_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"postcss\": \"^8.2.14\"|\"postcss\": \"^${NODE_POSTCSS_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"postcss\": \"^8.4.21\"|\"postcss\": \"^${NODE_POSTCSS_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"postcss\": \"^8.4.38\"|\"postcss\": \"^${NODE_POSTCSS_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"postcss\": \"^8.4.43\"|\"postcss\": \"^${NODE_POSTCSS_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"postcss-selector-parser\": \"^7.0.0\"|\"postcss-selector-parser\": \"^${NODE_POSTCSS_SELECTOR_PARSER_7_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"react-router\": \"6.30.1\"|\"react-router\": \"^${NODE_REACT_ROUTER_7_PV}\"|g" "package-lock.json" || die # 6-> 7 could be a breaking change
			sed -i -e "s|\"react-router-dom\": \"^6.23.1\"|\"react-router-dom\": \"^${NODE_REACT_ROUTER_DOM_7_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"source-map-js\": \"^1.2.1\"|\"source-map-js\": \"^${NODE_SOURCE_MAP_JS_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"vitest\": \"^1.6.0\"|\"vitest\": \"^${NODE_VITEST_4_PV}\"|g" "package-lock.json" || die # 1 -> 4 could be a breaking change
			sed -i -e "s|\"vite\": \"^5.2.11\"|\"vite\": \"^${NODE_VITE_6_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"vite\": \"^5.0.0\"|\"vite\": \"^${NODE_VITE_6_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"ws\": \"^8.18.0\"|\"ws\": \"^${NODE_WS_8_PV}\"|g" "package-lock.json" || die
		}

		patch_lockfile

		local L

	# Tauri v1 -> v2
		L=(
	# Remove Tauri v1 references
			"@tauri-apps/cli"
			"@tauri-apps/api"
			"tauri-plugin-log-api"
			"tauri-plugin-store-api"
		)
		enpm uninstall "${L[@]}"

		L=(
			"@tauri-apps/api@^${NODE_AT_TAURI_APPS_API_2_PV}"
			"@tauri-apps/plugin-dialog@^${NODE_AT_TAURI_APPS_PLUGIN_DIALOG_2_PV}"
			"@tauri-apps/plugin-fs@^${NODE_AT_TAURI_APPS_PLUGIN_FS_2_PV}"
			"@tauri-apps/plugin-log@^${NODE_AT_TAURI_APPS_PLUGIN_LOG_2_PV}"
			"@tauri-apps/plugin-process@^${NODE_AT_TAURI_APPS_PLUGIN_PROCESS_2_PV}"
			"@tauri-apps/plugin-shell@^${NODE_AT_TAURI_APPS_PLUGIN_SHELL_2_PV}"
			"@tauri-apps/plugin-store@^${NODE_AT_TAURI_APPS_PLUGIN_STORE_2_PV}"
			"@tauri-apps/plugin-updater@^${NODE_AT_TAURI_APPS_PLUGIN_UPDATER_2_PV}"
		)
		enpm install "${L[@]}" -P

		L=(
			"@tauri-apps/cli@^${NODE_AT_TAURI_APPS_CLI_2_PV}"
		)
		enpm install "${L[@]}" -D

	# Vulnerability fixes

		L=(
			"@remix-run/router@^${NODE_AT_REMIX_RUN_ROUTER_PV}"
			"brace-expansion@^${NODE_BRACE_EXPANSION_1_PV}"
			"form-data@^${NODE_FORM_DATA_4_PV}"
			"nanoid@^${NODE_NANOID_3_PV}"
			"postcss@^${NODE_POSTCSS_PV}"
			"react-router@^${NODE_REACT_ROUTER_7_PV}"
			"react-router-dom@^${NODE_REACT_ROUTER_DOM_7_PV}"
			"source-map-js@^${NODE_SOURCE_MAP_JS_PV}"
			"ws@^${NODE_WS_8_PV}"
		)
		enpm install "${L[@]}" -P

		patch_lockfile

		L=(
			"@babel/core@^${NODE_BABEL_CORE_7_PV}"
			"@vitest/mocker@^${NODE_AT_VITEST_MOCKER_4_PV}"
			"browserslist@^${NODE_BROWSERSLIST_PV}"
			"esbuild@^${NODE_ESBUILD_PV}"
			"postcss-selector-parser@^${NODE_POSTCSS_SELECTOR_PARSER_7_PV}"
			"vite@^${NODE_VITE_6_PV}"
			"vitest@${NODE_VITEST_4_PV}"
		)
		enpm install "${L[@]}" -D

		patch_lockfile
	fi
}

gen_cargo_lockfile() {
	[[ "${GEN_CARGO_LOCKFILE}" == "1" ]] || return
	cd "${S}/src-tauri" || die
	rm "${S}/src-tauri/Cargo.lock" || true
	eapply "${FILESDIR}/${PN}-0.0.9-symbolize-cargo-lock.patch"

	sed -i \
		-e "s|@RUST_LOG_PV@|${RUST_LOG_PV}|g" \
		-e "s|@RUST_SERDE_JSON_PV@|${RUST_SERDE_JSON_PV}|g" \
		-e "s|@RUST_TAURI_2_BUILD_PV@|${RUST_TAURI_2_BUILD_PV}|g" \
		-e "s|@RUST_TAURI_2_PLUGIN_DIALOG_PV@|${RUST_TAURI_2_PLUGIN_DIALOG_PV}|g" \
		-e "s|@RUST_TAURI_2_PLUGIN_FS_PV@|${RUST_TAURI_2_PLUGIN_FS_PV}|g" \
		-e "s|@RUST_TAURI_2_PLUGIN_LOG_PV@|${RUST_TAURI_2_PLUGIN_LOG_PV}|g" \
		-e "s|@RUST_TAURI_2_PLUGIN_PROCESS_PV@|${RUST_TAURI_2_PLUGIN_PROCESS_PV}|g" \
		-e "s|@RUST_TAURI_2_PLUGIN_SHELL_PV@|${RUST_TAURI_2_PLUGIN_SHELL_PV}|g" \
		-e "s|@RUST_TAURI_2_PLUGIN_SINGLE_INSTANCE_PV@|${RUST_TAURI_2_PLUGIN_SINGLE_INSTANCE_PV}|g" \
		-e "s|@RUST_TAURI_2_PLUGIN_SLOT@|${RUST_TAURI_2_PLUGIN_SLOT}|g" \
		-e "s|@RUST_TAURI_2_PLUGIN_STORE_PV@|${RUST_TAURI_2_PLUGIN_STORE_PV}|g" \
		-e "s|@RUST_TAURI_2_PLUGIN_UPDATER_PV@|${RUST_TAURI_2_PLUGIN_UPDATER_PV}|g" \
		-e "s|@RUST_TAURI_2_PV@|${RUST_TAURI_2_PV}|g" \
		"${S}/src-tauri/Cargo.toml" \
		|| die

	cargo generate-lockfile

einfo
einfo "Now do the following"
einfo "cp ${S}/src-tauri/Cargo.* files/${PV}"
einfo "./convert-cargo-lock.sh ${PV} ${PV}"
einfo "Update CRATES, GIT_CRATES"
einfo
	die
}

src_unpack() {
	unpack "${P}.tar.gz"
	gen_cargo_lockfile
	#die # For lockfile update

einfo "Unpacking npm side"
	S="${WORKDIR}/${MY_PN}-${PV}" \
	npm_src_unpack
	S="${WORKDIR}/${MY_PN}-${PV}" \
	enpm i --save-dev "@types/testing-library__react"

einfo "Unpacking Tauri side"
	pushd "${WORKDIR}/${MY_PN}-${PV}/src-tauri" || die
		S="${WORKDIR}/${MY_PN}-${PV}/src-tauri" \
		_cargo_src_unpack
	popd

einfo "Copying npm build files"
	cp -av "${FILESDIR}/${PV}/"{"package.json","package-lock.json"} "${S}" || die
einfo "Copying cargo build files"
	cp -av "${FILESDIR}/${PV}/Cargo."{"lock","toml"} "${S}/src-tauri" || die

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

	local row
	for row in "${BANNED_CARGO_PACKAGES[@]}" ; do
		local pkg="${row%;*}"
		local type="${row#*;}"
		local pkg_pv=${BANNED_CARGO_PACKAGES_PV["${pkg}"]}
		if [[ "${type}" == "W" ]] ; then
	# Ambiguous versioning warnings
			grep -q -e "${pkg}" "${S}/src-tauri/Cargo.toml" && ewarn "QA:  ${pkg} ${pkg_pv} should be removed from src-tauri/Cargo.toml"
			grep -q -e "${pkg}" "${S}/src-tauri/Cargo.lock" && ewarn "QA:  ${pkg} ${pkg_pv} should be removed from src-tauri/Cargo.lock"
		else
	# Fatal error
			grep -q -e "${pkg}" "${S}/src-tauri/Cargo.toml" && die "QA:  ${pkg} ${pkg_pv} needs to be removed from src-tauri/Cargo.toml"
			grep -q -e "${pkg}" "${S}/src-tauri/Cargo.lock" && die "QA:  ${pkg} ${pkg_pv} needs to be removed from src-tauri/Cargo.lock"
		fi
	done

	# Remove mistake by _npm_src_unpack_default_ebuild()
	rm "${S}/"{"Cargo.toml","Cargo.lock"} || true

einfo "Copying npm build files"
	cp -av "${FILESDIR}/${PV}/"{"package.json","package-lock.json"} "${S}" || die
einfo "Copying cargo build files"
	cp -av "${FILESDIR}/${PV}/Cargo."{"lock","toml"} "${S}/src-tauri" || die
}

src_configure() {
	chkl_check_many_timestamps
	pushd "${WORKDIR}/${MY_PN}-${PV}/src-tauri" || die
		S="${WORKDIR}/${MY_PN}-${PV}/src-tauri" \
		cargo_src_configure
	popd
}

src_compile() {
einfo "Inspecting code for new tauri-plugin-autostart{,-api} references.  Please wait..."
	grep -q -r -e "tauri-plugin-autostart-api" "${S}/"{"src","src-tauri"} && die "Detected unpatched project (1)"
	grep -q -r -e "tauri-plugin-autostart" "${S}/"{"src","src-tauri"} && die "Detected unpatched project (2)"
einfo "Building npm side"
	S="${WORKDIR}/${MY_PN}-${PV}" \
	npm_src_compile
	grep -e "- error TS" "${T}/build.log" && die "Detected error.  Emerge again."
einfo "Building Tauri side"
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
	exeinto "/usr/bin"
	newexe "src-tauri/target/release/window-pet" "window-pet-bin"
	gen_wrapper

	make_desktop_entry \
		"window-pet" \
		"${PN}" \
		"window-pet" \
		"Office;"

	newicon -s 32 "public/media/icon.png" "window-pet.png"
	newicon -s 128 "public/media/icon.png" "window-pet.png"
	newicon -s 256 "public/media/icon.png" "window-pet.png"

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
# OILEDMACHINE-OVERLAY-TEST:  passed (0.0.8, 20250208) on X
# OILEDMACHINE-OVERLAY-TEST:  passed (0.0.9, 20250702) on X
# OILEDMACHINE-OVERLAY-TEST:  passed (0.0.9, 20250814) on X
# OILEDMACHINE-OVERLAY-TEST:  passed (0.0.9, 20260503) on X
