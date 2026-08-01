# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

# Ebuild TODO:
# Phase 1:  Update to tauri v2 (done)
# Phase 2:  Fix friction issues (current)
# Phase 3:  Fix vulnerabilities in lockfiles deps

# This ebuild an associated patch(es) contains an AI generated content.
# The node sharp patches are directly from AI generated code.
# Some of the patches for amica were suggested/influenced with the help of AI inference.

# To generate crates:
# ./convert-cargo-lock.sh 0.2.1_p20250723 ca2415c77d20ec41dd4fcf917dbb0e97961ddf08

# To generate npm lockfiles
# PATH=$(realpath "../../scripts")":${PATH}"
# NPM_UPDATER_VERSIONS="0.2.1_p20250723" npm_updater_update_locks.sh

#GENERATE_LOCKFILE=${GENERATE_LOCKFILE:-1}

EGIT_COMMIT="ca2415c77d20ec41dd4fcf917dbb0e97961ddf08" # Jul 23, 2025
NODE_ENV="development"
NODE_SHARP_USE="exif jpeg"
NODE_SLOT="24" # Upstream uses 18 and 20
NPM_AUDIT_FATAL=0
PYTHON_COMPAT=( "python3_"{10..12} )
RUST_MAX_VER="1.93.1"
RUST_MIN_VER="1.93.1" # LLVM 21.1
RUST_PV="${RUST_MIN_VER}"

AT_TYPES_NODE_PV="22.7.4"
NODE_SHARP_PV="0.35.3"

CPU_FLAGS_X86=(
	"cpu_flags_x86_sse4_2"
)

DISABLED_CRATES="
app-0.1.0
"

CRATES="
adler2-2.0.1
aho-corasick-1.1.4
alloc-no-stdlib-2.0.4
alloc-stdlib-0.2.4
android_system_properties-0.1.5
anyhow-1.0.104
atk-0.18.2
atk-sys-0.18.2
atomic-waker-1.1.2
autocfg-1.5.1
base64-0.21.7
base64-0.22.1
bitflags-1.3.2
bitflags-2.13.1
bit-set-0.8.0
bit-vec-0.8.0
block2-0.6.2
block-buffer-0.10.4
brotli-8.0.4
brotli-decompressor-5.0.3
bs58-0.5.1
bumpalo-3.20.3
bytemuck-1.25.2
byteorder-1.5.0
bytes-1.12.1
cairo-rs-0.18.5
cairo-sys-rs-0.18.2
camino-1.2.5
cargo_metadata-0.19.2
cargo-platform-0.1.9
cargo_toml-0.22.3
cc-1.4.0
cesu8-1.1.0
cfb-0.7.3
cfg-expr-0.15.8
cfg-if-1.0.4
chrono-0.4.45
combine-4.6.7
cookie-0.18.1
core-foundation-0.10.1
core-foundation-sys-0.8.7
core-graphics-0.25.0
core-graphics-types-0.2.0
cpufeatures-0.2.17
crc32fast-1.5.0
crossbeam-channel-0.5.16
crossbeam-utils-0.8.22
crypto-common-0.1.7
cssparser-0.36.0
cssparser-macros-0.6.1
ctor-0.8.0
ctor-proc-macro-0.0.7
darling-0.23.0
darling_core-0.23.0
darling_macro-0.23.0
dbus-0.9.12
deranged-0.5.8
derive_more-2.1.1
derive_more-impl-2.1.1
digest-0.10.7
dirs-6.0.0
dirs-sys-0.5.0
dispatch2-0.3.1
displaydoc-0.2.7
dlopen2-0.8.2
dlopen2_derive-0.4.3
dom_query-0.27.0
dpi-0.1.2
dtoa-1.0.11
dtoa-short-0.3.5
dtor-0.3.0
dtor-proc-macro-0.0.6
dunce-1.0.5
dyn-clone-1.0.20
embed_plist-1.2.2
embed-resource-3.0.11
encoding_rs-0.8.35
equivalent-1.0.2
erased-serde-0.4.10
errno-0.3.14
fastrand-2.5.0
fdeflate-0.3.7
field-offset-0.3.6
find-msvc-tools-0.1.9
flate2-1.1.9
fnv-1.0.7
foldhash-0.2.0
foreign-types-0.5.0
foreign-types-macros-0.2.4
foreign-types-shared-0.3.1
form_urlencoded-1.2.2
futures-channel-0.3.33
futures-core-0.3.33
futures-executor-0.3.33
futures-io-0.3.33
futures-macro-0.3.33
futures-sink-0.3.33
futures-task-0.3.33
futures-util-0.3.33
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
hex-0.4.3
html5ever-0.38.0
http-1.5.0
httparse-1.10.1
http-body-1.1.0
http-body-util-0.1.4
hyper-1.11.0
hyper-util-0.1.20
iana-time-zone-0.1.65
iana-time-zone-haiku-0.1.2
ico-0.5.0
icu_collections-2.2.0
icu_locale_core-2.2.0
icu_normalizer-2.2.0
icu_normalizer_data-2.2.0
icu_properties-2.2.0
icu_properties_data-2.2.0
icu_provider-2.2.0
ident_case-1.0.1
idna-1.1.0
idna_adapter-1.2.2
indexmap-1.9.3
indexmap-2.14.0
infer-0.19.0
ipnet-2.12.0
is-docker-0.2.0
is-wsl-0.4.0
itoa-1.0.18
javascriptcore-rs-1.1.2
javascriptcore-rs-sys-1.1.1
jni-0.21.1
jni-sys-0.3.1
jni-sys-0.4.1
jni-sys-macros-0.4.1
json-patch-3.0.1
jsonptr-0.6.3
js-sys-0.3.103
keyboard-types-0.7.0
libappindicator-0.9.0
libappindicator-sys-0.9.0
libc-0.2.189
libdbus-sys-0.2.7
libloading-0.7.4
libredox-0.1.18
litemap-0.8.2
lock_api-0.4.14
log-0.4.33
markup5ever-0.38.0
memchr-2.8.3
memoffset-0.9.1
mime-0.3.17
miniz_oxide-0.8.9
mio-1.2.2
muda-0.19.3
ndk-0.9.0
ndk-sys-0.6.0+11769913
new_debug_unreachable-1.0.6
num-conv-0.2.2
num_enum-0.7.6
num_enum_derive-0.7.6
num-traits-0.2.19
objc2-0.6.4
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
objc2-quartz-core-0.3.2
objc2-ui-kit-0.3.2
objc2-user-notifications-0.3.2
objc2-web-kit-0.3.2
once_cell-1.21.4
open-5.4.0
option-ext-0.2.0
os_pipe-1.2.3
pango-0.18.3
pango-sys-0.18.0
parking_lot-0.12.5
parking_lot_core-0.9.12
percent-encoding-2.3.2
phf-0.13.1
phf_codegen-0.13.1
phf_generator-0.13.1
phf_macros-0.13.1
phf_shared-0.13.1
pin-project-lite-0.2.17
pkg-config-0.3.33
plist-1.10.0
png-0.17.16
png-0.18.1
potential_utf-0.1.5
powerfmt-0.2.0
precomputed-hash-0.1.1
proc-macro2-1.0.107
proc-macro-crate-1.3.1
proc-macro-crate-2.0.2
proc-macro-crate-3.5.0
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
quick-xml-0.41.0
quote-1.0.47
raw-window-handle-0.6.2
redox_syscall-0.5.18
redox_users-0.5.2
ref-cast-1.0.26
ref-cast-impl-1.0.26
r-efi-5.3.0
r-efi-6.0.0
regex-1.13.1
regex-automata-0.4.16
regex-syntax-0.8.11
reqwest-0.13.4
rustc-hash-2.1.3
rustc_version-0.4.1
rustversion-1.0.23
same-file-1.0.6
schemars-0.8.22
schemars-0.9.0
schemars-1.2.2
schemars_derive-0.8.22
scopeguard-1.2.0
selectors-0.36.1
semver-1.0.28
serde-1.0.229
serde_core-1.0.229
serde_derive-1.0.229
serde_derive_internals-0.29.1
serde_json-1.0.151
serde_repr-0.1.21
serde_spanned-0.6.9
serde_spanned-1.1.1
serde-untagged-0.1.9
serde_with-3.21.0
serde_with_macros-3.21.0
serialize-to-javascript-0.1.2
serialize-to-javascript-impl-0.1.2
servo_arc-0.4.3
sha2-0.10.9
shared_child-1.1.1
shlex-2.0.1
sigchld-0.2.4
signal-hook-0.3.18
signal-hook-registry-1.4.8
simd-adler32-0.3.10
siphasher-1.0.3
slab-0.4.12
smallvec-1.15.2
socket2-0.6.5
softbuffer-0.4.8
soup3-0.5.0
soup3-sys-0.5.0
stable_deref_trait-1.2.1
string_cache-0.9.0
string_cache_codegen-0.6.1
strsim-0.11.1
swift-rs-1.0.7
syn-1.0.109
syn-2.0.119
syn-3.0.3
sync_wrapper-1.0.2
synstructure-0.13.2
system-deps-6.2.2
tao-0.35.3
tao-macros-0.1.4
target-lexicon-0.12.16
tauri-2.11.5
tauri-build-2.6.3
tauri-codegen-2.6.3
tauri-macros-2.6.3
tauri-plugin-2.6.3
tauri-plugin-shell-2.3.5
tauri-runtime-2.11.3
tauri-runtime-wry-2.11.4
tauri-utils-2.9.3
tauri-winres-0.3.6
tendril-0.5.1
thiserror-1.0.69
thiserror-2.0.19
thiserror-impl-1.0.69
thiserror-impl-2.0.19
time-0.3.54
time-core-0.1.9
time-macros-0.2.32
tinystr-0.8.3
tinyvec-1.12.0
tinyvec_macros-0.1.1
tokio-1.53.1
tokio-util-0.7.19
toml-0.8.2
toml-0.9.12+spec-1.1.0
toml-1.1.4+spec-1.1.0
toml_datetime-0.6.3
toml_datetime-0.7.5+spec-1.1.0
toml_datetime-1.1.1+spec-1.1.0
toml_edit-0.19.15
toml_edit-0.20.2
toml_edit-0.25.13+spec-1.1.0
toml_parser-1.1.3+spec-1.1.0
toml_writer-1.1.2+spec-1.1.0
tower-0.5.3
tower-http-0.6.11
tower-layer-0.3.3
tower-service-0.3.3
tracing-0.1.44
tracing-core-0.1.36
tray-icon-0.24.2
try-lock-0.2.5
typeid-1.0.3
typenum-1.20.1
unic-char-property-0.9.0
unic-char-range-0.9.0
unic-common-0.9.0
unicode-ident-1.0.24
unicode-segmentation-1.13.3
unic-ucd-ident-0.9.0
unic-ucd-version-0.9.0
url-2.5.8
urlpattern-0.3.0
utf8_iter-1.0.4
uuid-1.24.0
version_check-0.9.5
version-compare-0.2.1
vswhom-0.1.0
vswhom-sys-0.1.3
walkdir-2.5.0
want-0.3.1
wasi-0.11.1+wasi-snapshot-preview1
wasip2-1.0.4+wasi-0.2.12
wasm-bindgen-0.2.126
wasm-bindgen-futures-0.4.76
wasm-bindgen-macro-0.2.126
wasm-bindgen-macro-support-0.2.126
wasm-bindgen-shared-0.2.126
wasm-streams-0.5.0
web_atoms-0.2.5
webkit2gtk-2.0.2
webkit2gtk-sys-2.0.2
web-sys-0.3.103
webview2-com-0.38.2
webview2-com-macros-0.8.1
webview2-com-sys-0.38.2
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.11
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.61.3
windows_aarch64_gnullvm-0.42.2
windows_aarch64_gnullvm-0.52.6
windows_aarch64_gnullvm-0.53.1
windows_aarch64_msvc-0.42.2
windows_aarch64_msvc-0.52.6
windows_aarch64_msvc-0.53.1
windows-collections-0.2.0
windows-core-0.61.2
windows-core-0.62.2
windows-future-0.2.1
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
windows-link-0.1.3
windows-link-0.2.1
windows-numerics-0.2.0
windows-result-0.3.4
windows-result-0.4.1
windows-strings-0.4.2
windows-strings-0.5.1
windows-sys-0.45.0
windows-sys-0.59.0
windows-sys-0.60.2
windows-sys-0.61.2
windows-targets-0.42.2
windows-targets-0.52.6
windows-targets-0.53.5
windows-threading-0.1.0
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
window-vibrancy-0.6.0
winnow-0.5.40
winnow-0.7.15
winnow-1.0.4
winreg-0.55.0
wit-bindgen-0.57.1
writeable-0.6.3
wry-0.55.1
x11-2.21.0
x11-dl-2.21.0
yoke-0.8.3
yoke-derive-0.8.2
zerofrom-0.1.8
zerofrom-derive-0.1.7
zerotrie-0.2.4
zerovec-0.11.6
zerovec-derive-0.11.3
zmij-1.0.23

"

NODE_SHARP_PATCHES=(
	"${FILESDIR}/sharp-0.35.3-remove-sover-suffix.patch"
)

NPM_AUDIT_FIX_ARGS=(
	"--legacy-peer-deps"
	"--prefer-offline"
)

NPM_DEDUPE_ARGS=(
	"--legacy-peer-deps"
)

NPM_INSTALL_ARGS=(
	"--legacy-peer-deps"
	"--prefer-offline"
)

NPM_UNINSTALL_ARGS=(
	"--legacy-peer-deps"
	"--prefer-offline"
)

CHKL_TIMESTAMPS=(
	"app-accessibility/at-spi2-core-9999"
	"dev-libs/glib-2.89.9999"
	"x11-libs/cairo-9999"
	"x11-libs/gtk+-3.24.9999"
)

inherit cargo chkl desktop edo lcnr npm python-single-r1 rust node-sharp secure-version secure-version-node xdg

KEYWORDS="~amd64 ~arm64"
SRC_URI="
$(cargo_crate_uris ${CRATES})
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
${CPU_FLAGS_X86[@]}
coqui debug ollama tray voice-recognition wayland whisper-cpp X
ebuild_revision_33
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
RUST_BINDINGS_DEPEND_DISABLED="
	>=net-libs/libsoup-${LIBSOUP2_PV}:2.4[introspection]
"
RUST_BINDINGS_DEPEND="
	>=app-accessibility/at-spi2-core-${AT_SPI2_CORE_PV}:=[introspection]
	>=dev-libs/glib-${GLIB_PV}:=
	>=dev-libs/gobject-introspection-${GOBJECT_INTROSPECTION_PV}:=
	>=x11-libs/cairo-${CAIRO_PV}:=
	>=x11-libs/gdk-pixbuf-${GDK_PIXBUF_PV}:=[introspection]
	>=x11-libs/gtk+-${GTK3_PV}:3=[introspection,wayland?,X?]
	>=x11-libs/pango-${PANGO_PV}:=[introspection]
	elibc_glibc? (
		>=sys-libs/glibc-${GLIBC_PV}:=
	)
	elibc_musl? (
		>=sys-libs/musl-${MUSL_PV}:=
	)
	tray? (
		|| (
			>=dev-libs/libappindicator-12.10.1_p20200408:3
			>=dev-libs/libayatana-appindicator-0.5.4
		)
	)

	>=net-libs/webkit-gtk-${WEBKIT_GTK_STABLE_PV}:4.1=[javascript,jit,introspection,wayland?,webassembly,X?,webgl]
	voice-recognition? (
		~net-libs/webkit-gtk-${WEBKIT_GTK_STABLE_PV}:4.1=[microphone]
	)
"
RUST_BINDINGS_BDEPEND="
	virtual/pkgconfig
"
RDEPEND+="
	${RUST_BINDINGS_DEPEND}
	coqui? (
		dev-python/coqui-tts:=[${PYTHON_SINGLE_USEDEP}]
		>=sys-process/procps-${PROCPS_PV}:=
	)
	ollama? (
		>=sci-ml/ollama-${OLLAMA_PV}:=
	)
	whisper-cpp? (
		app-accessibility/whisper-cpp:=
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${RUST_BINDINGS_BDEPEND}
	>=net-libs/nodejs-${NODEJS_24_PV}:${NODE_SLOT}=[npm,webassembly(+)]
	virtual/pkgconfig
	|| (
		dev-lang/rust:${RUST_PV}[wasm]
		dev-lang/rust-bin:${RUST_PV}
	)
"
DOCS=( "README.md" )

pkg_setup() {
	npm_pkg_setup
	export NEXT_TELEMETRY_DISABLED=1
	python-single-r1_pkg_setup
	node-sharp_pkg_setup
	rust_pkg_setup
	if has_version "dev-lang/rust-bin:${RUST_PV}" ; then
		rust_prepend_path "${RUST_PV}" "binary"
	elif has_version "dev-lang/rust:${RUST_PV}" ; then
		rust_prepend_path "${RUST_PV}" "source"
	fi
	[[ -z "${RUSTC}" ]] && die "RUSTC is not defined"
	local actual_rust_pv=$("${RUSTC}" --version | cut -f 2 -d " ")
	if ver_test "${actual_rust_pv}" -ne "${RUST_PV}" ; then
eerror
eerror "Use \`eselect rust\` to switch to Rust ${RUST_PV}"
eerror
eerror "Actual Rust version:  ${actual_rust_pv}"
eerror "Expected Rust version:  ${RUST_PV}"
eerror
		die
	else
einfo
einfo "Actual Rust version:  ${actual_rust_pv}"
einfo "Expected Rust version:  ${RUST_PV}"
einfo
	fi
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
	debug-print-function "${FUNCNAME}" "$@"

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
			"${FILESDIR}/${PV}/Cargo."{"toml","lock"} \
			"${S}" \
			|| die
	fi
	_cargo_src_unpack
}

npm_update_lock_install_post() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
#ewarn "QA:  Manually \`cargo add serde@1.0.219\` in src-tauri"
#ewarn "QA:  Manually remove node_modules/eslint-config-next/node_modules/eslint-plugin-react-hooks in package-lock.json"
#ewarn "QA:  Manually remove node_modules/copy-webpack-plugin/node_modules/serialize-javascript in package-lock.json"
#ewarn "QA:  Manually remove node_modules/@charcoal-ui/icons/node_modules/dompurify in package-lock.json"

		local pkgs
		pkgs=(
			"onnxruntime-web@1.14.0"								# Fix build breakage
			"serialize-javascript@^7.0.5"
			"@sentry/nextjs@^10.50.0"								# Fix build breakage
		)
		enpm install "${pkgs[@]}" -P "${NPM_INSTALL_ARGS[@]}"
		pkgs=(
		)
		#enpm install "${pkgs[@]}" -P --legacy-peer-deps

		pkgs=(
			"@types/node@^${AT_TYPES_NODE_PV}"

			# Fix runtime
			"typescript@5.6.3"
			"@eslint/compat"									# Fix build breakage

	#
	# Required Cargo.toml changes for tauri v2:
	#
	# Update [build-dependencies] with the following:
	# tauri-build needs version = 2.6.3.
	#
	# Update [dependencies] with the following:
	# tauri = { version = "2.11.5", features = [ "macos-private-api", "tray-icon" ] }
	# tauri-plugin-shell = "2"
	#

	# Must be the same major.minor (2.11) versions
	# The Tauri in package.json and Cargo.toml must be the same major.minor (2.11) version.
			"@tauri-apps/api@2.11.1"
			"@tauri-apps/cli@2.11.4"								# Fix build issue with tauri.conf.json when updating to tauri v2
		)
		enpm install "${pkgs[@]}" -D "${NPM_INSTALL_ARGS[@]}"
	fi
}

src_unpack() {
	# For updating cargo lockfile.
	unpack "${TARBALL}"
#	die

	node-sharp_append_includes

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
		enpm install "node-gyp@^12.4.0" -D "${NPM_INSTALL_ARGS[@]}"

		local configuration="Debug"
		local nconfiguration="Release"
		if [[ "${NODE_SHARP_DEBUG}" != "1" ]] ; then
			configuration="Release"
			nconfiguration="Debug"
		fi
		local sharp_platform=$(node-sharp_get_platform)

		local fn="sharp-${sharp_platform}-${NODE_SHARP_PV}.node"
	# Replace upstream prebuilt with newly source locally built node sharp
	# The upstream sharp-node is minimally x86-64-v2 and not portable.
		pushd "${S}" >/dev/null 2>&1 || die
			node-sharp_npm_rebuild_sharp

			mkdir -p "node_modules/sharp/build/${configuration}" \
				|| die "Failed to create dir"
			cp \
				"node_modules/sharp/src/build/${configuration}/${fn}" \
				"node_modules/sharp/build/${configuration}/${fn}" \
				|| die "Failed to copy ${fn} (1)"

			cp \
				"node_modules/sharp/src/build/${configuration}/${fn}" \
				"node_modules/@xenova/transformers/node_modules/sharp/build/Release/obj.target/sharp-${sharp_platform}.node" \
				|| die "Failed to copy ${fn} (2)"

			cp \
				"node_modules/sharp/src/build/${configuration}/${fn}" \
				"node_modules/@xenova/transformers/node_modules/sharp/build/Release/sharp-${sharp_platform}.node" \
				|| die "Failed to copy ${fn} (3)"

	        popd >/dev/null 2>&1 || die

	# Allow only the locally built node sharp
		node-sharp_verify_dedupe
	fi
}

src_prepare() {
	default
#	eapply "${FILESDIR}/${PN}-0.2.1_p20241022-debug.patch"
	eapply "${FILESDIR}/${PN}-0.2.1_p20241022-ollama.patch"
#	eapply -R "${DISTDIR}/${PN}-commit-da5a390.patch"
#	eapply "${FILESDIR}/${PN}-0.2.1_p20241022-coqui-local.patch"
	eapply "${FILESDIR}/${PN}-0.2.1_p20250204-array-type-check.patch"
	eapply "${FILESDIR}/${PN}-0.2.1_p20250723-import-fix.patch"
	eapply "${FILESDIR}/${PN}-0.2.1_p20250723-next-public-root.patch"
	eapply "${FILESDIR}/${PN}-0.2.1_p20250723-tauri-v2.patch"

# Prevent ⨯ ESLint: a.getScope is not a function Occurred while linting ${S}/src/components/addToHomescreen.tsx:9 Rule: "react-hooks/rules-of-hooks"
cat <<EOF > "${S}/eslint.config.mjs"
import { fixupPluginRules } from "@eslint/compat";
import reactHooks from "eslint-plugin-react-hooks";

export default [
  {
    plugins: {
      "react-hooks": fixupPluginRules(reactHooks),
    },
    rules: reactHooks.configs.recommended.rules,
  },
];
EOF
}

src_configure() {
	chkl_check_many_timestamps
	export WEBKIT2GTK_USE_API="4.1"
	if ! has_version "dev-util/sccache" ; then
einfo "Disabling sccache support"
		unset RUSTC_WRAPPER
		unset SCCACHE_DIR
	fi
	sed \
		-i \
		-e "s|\"targets\": \"all\"|\"targets\": \"deb\"|g" \
		"${S}/src-tauri/tauri.conf.json" \
		|| die
	cargo_src_configure
}

src_compile() {
	rm -f "${S}/Cargo."* || true
	npm_hydrate

	mkdir -p "out" || die
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
	local configuration=$(usex debug "debug" "release")
	newexe \
		"src-tauri/target/${configuration}/app" \
		"${PN}"

	newicon -s 48 "app-icon.png" "${PN}.png"
	make_desktop_entry \
		"/usr/bin/${PN}" \
		"${PN^}" \
		"${PN}.png" \
		"Utility;"
	docinto "licenses"
	dodoc "LICENSE"

	LCNR_SOURCE="${WORKDIR}/cargo_home/gentoo"
	LCNR_TAG="third_party_cargo"
	lcnr_install_files

	LCNR_SOURCE="${S_PROJECT}/node_modules"
	LCNR_TAG="third_party_npm"
	lcnr_install_files

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
# OILEDMACHINE-OVERLAY-TEST:  Working but buggy, wait several iterations for the tauri v2 patch to mature (0.2.1_p20250723, 20260731)
# OILEDMACHINE-OVERLAY-TEST:  Passed (0.2.1_p20250723, 20260426 with webkit-gtk-2.52.3:4.1/0, ollama 0.21.2, TTS off)
# OILEDMACHINE-OVERLAY-TEST:  Passed (0.2.1_p20250723, 20250810)
# OILEDMACHINE-OVERLAY-TEST:  Passed (0.2.1_p20250610, 20250701)
# OILEDMACHINE-OVERLAY-TEST:  Passed (0.2.1_p20250311, 20250318)
# OILEDMACHINE-OVERLAY-TEST:  Passed (0.2.1_p20250204 [c5829dd], 20250211)
# OILEDMACHINE-OVERLAY-TEST:  Passed (0.2.1_p20250204 [c5829dd], 20250208)
# OILEDMACHINE-OVERLAY-TEST:  Passed (0.2.1_p20241022, 20241117)
# ollama support - passed (with smollm:135m)
