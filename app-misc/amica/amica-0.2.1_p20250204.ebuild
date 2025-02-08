# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# To generate crates:
# ./convert-cargo-lock.sh 0.2.1_p20250204 c5829dd25a4ad93cc26bc01b4c8520fd3ef51916

AT_TYPES_NODE_PV="18.15.10"
CRATES="
addr2line-0.24.2
adler2-2.0.0
aho-corasick-1.1.3
alloc-no-stdlib-2.0.4
alloc-stdlib-0.2.2
android-tzdata-0.1.1
android_system_properties-0.1.5
anyhow-1.0.95
atk-0.15.1
atk-sys-0.15.1
autocfg-1.4.0
backtrace-0.3.74
base64-0.13.1
base64-0.21.7
base64-0.22.1
bitflags-1.3.2
bitflags-2.8.0
block-0.1.6
block-buffer-0.10.4
brotli-7.0.0
brotli-decompressor-4.0.2
bstr-1.11.3
bumpalo-3.17.0
bytemuck-1.21.0
byteorder-1.5.0
bytes-1.10.0
cairo-rs-0.15.12
cairo-sys-rs-0.15.1
cargo_toml-0.15.3
cc-1.2.12
cesu8-1.1.0
cfb-0.7.3
cfg-expr-0.15.8
cfg-expr-0.9.1
cfg-if-1.0.0
chrono-0.4.39
cocoa-0.24.1
cocoa-foundation-0.1.2
color_quant-1.1.0
combine-4.6.7
convert_case-0.4.0
core-foundation-0.9.4
core-foundation-sys-0.8.7
core-graphics-0.22.3
core-graphics-types-0.1.3
cpufeatures-0.2.17
crc32fast-1.4.2
crossbeam-channel-0.5.14
crossbeam-deque-0.8.6
crossbeam-epoch-0.9.18
crossbeam-utils-0.8.21
crypto-common-0.1.6
cssparser-0.27.2
cssparser-macros-0.6.1
ctor-0.2.9
darling-0.20.10
darling_core-0.20.10
darling_macro-0.20.10
deranged-0.3.11
derive_more-0.99.19
digest-0.10.7
dirs-next-2.0.0
dirs-sys-next-0.1.2
dispatch-0.2.0
displaydoc-0.2.5
dtoa-1.0.9
dtoa-short-0.3.5
dunce-1.0.5
embed-resource-2.5.1
embed_plist-1.2.2
encoding_rs-0.8.35
equivalent-1.0.1
errno-0.3.10
fastrand-2.3.0
fdeflate-0.3.7
field-offset-0.3.6
filetime-0.2.25
flate2-1.0.35
fluent-uri-0.1.4
fnv-1.0.7
foreign-types-0.3.2
foreign-types-shared-0.1.1
form_urlencoded-1.2.1
futf-0.1.5
futures-channel-0.3.31
futures-core-0.3.31
futures-executor-0.3.31
futures-io-0.3.31
futures-macro-0.3.31
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
getrandom-0.3.1
gimli-0.31.1
gio-0.15.12
gio-sys-0.15.10
glib-0.15.12
glib-macros-0.15.13
glib-sys-0.15.10
glob-0.3.2
globset-0.4.15
gobject-sys-0.15.10
gtk-0.15.5
gtk-sys-0.15.3
gtk3-macros-0.15.6
hashbrown-0.12.3
hashbrown-0.15.2
heck-0.3.3
heck-0.4.1
heck-0.5.0
hex-0.4.3
html5ever-0.26.0
http-0.2.12
http-range-0.1.5
iana-time-zone-0.1.61
iana-time-zone-haiku-0.1.2
ico-0.4.0
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
ignore-0.4.23
image-0.24.9
indexmap-1.9.3
indexmap-2.7.1
infer-0.13.0
instant-0.1.13
itoa-0.4.8
itoa-1.0.14
javascriptcore-rs-0.16.0
javascriptcore-rs-sys-0.4.0
jni-0.20.0
jni-sys-0.3.0
js-sys-0.3.77
json-patch-2.0.0
jsonptr-0.4.7
kuchikiki-0.8.2
lazy_static-1.5.0
libappindicator-0.7.1
libappindicator-sys-0.7.3
libc-0.2.169
libloading-0.7.4
libredox-0.1.3
linux-raw-sys-0.4.15
litemap-0.7.4
lock_api-0.4.12
log-0.4.25
loom-0.5.6
mac-0.1.1
malloc_buf-0.0.6
markup5ever-0.11.0
matchers-0.1.0
matches-0.1.10
memchr-2.7.4
memoffset-0.9.1
miniz_oxide-0.8.3
ndk-0.6.0
ndk-context-0.1.1
ndk-sys-0.3.0
new_debug_unreachable-1.0.6
nodrop-0.1.14
nu-ansi-term-0.46.0
num-conv-0.1.0
num-traits-0.2.19
num_enum-0.5.11
num_enum_derive-0.5.11
objc-0.2.7
objc_exception-0.1.2
objc_id-0.1.1
object-0.36.7
once_cell-1.20.3
open-3.2.0
overload-0.1.1
pango-0.15.10
pango-sys-0.15.10
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
pkg-config-0.3.31
plist-1.7.0
png-0.17.16
powerfmt-0.2.0
ppv-lite86-0.2.20
precomputed-hash-0.1.1
proc-macro-crate-1.3.1
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
raw-window-handle-0.5.2
redox_syscall-0.5.8
redox_users-0.4.6
regex-1.11.1
regex-automata-0.1.10
regex-automata-0.4.9
regex-syntax-0.6.29
regex-syntax-0.8.5
rustc-demangle-0.1.24
rustc_version-0.4.1
rustix-0.38.44
rustversion-1.0.19
ryu-1.0.19
same-file-1.0.6
scoped-tls-1.0.1
scopeguard-1.2.0
selectors-0.22.0
semver-1.0.25
serde-1.0.217
serde_derive-1.0.217
serde_json-1.0.138
serde_repr-0.1.19
serde_spanned-0.6.8
serde_with-3.12.0
serde_with_macros-3.12.0
serialize-to-javascript-0.1.2
serialize-to-javascript-impl-0.1.2
servo_arc-0.1.1
sha2-0.10.8
sharded-slab-0.1.7
shlex-1.3.0
simd-adler32-0.3.7
siphasher-0.3.11
siphasher-1.0.1
slab-0.4.9
smallvec-1.13.2
soup2-0.2.1
soup2-sys-0.2.0
stable_deref_trait-1.2.0
state-0.5.3
string_cache-0.8.8
string_cache_codegen-0.5.3
strsim-0.11.1
syn-1.0.109
syn-2.0.98
synstructure-0.13.1
system-deps-5.0.0
system-deps-6.2.2
tao-0.16.10
tao-macros-0.1.3
tar-0.4.43
target-lexicon-0.12.16
tauri-1.8.2
tauri-build-1.5.6
tauri-codegen-1.4.6
tauri-macros-1.4.7
tauri-runtime-0.14.6
tauri-runtime-wry-0.14.11
tauri-utils-1.6.2
tauri-winres-0.1.1
tempfile-3.16.0
tendril-0.4.3
thin-slice-0.1.1
thiserror-1.0.69
thiserror-impl-1.0.69
thread_local-1.1.8
time-0.3.37
time-core-0.1.2
time-macros-0.2.19
tinystr-0.7.6
tokio-1.43.0
toml-0.5.11
toml-0.7.8
toml-0.8.20
toml_datetime-0.6.8
toml_edit-0.19.15
toml_edit-0.22.23
tracing-0.1.41
tracing-attributes-0.1.28
tracing-core-0.1.33
tracing-log-0.2.0
tracing-subscriber-0.3.19
typenum-1.17.0
unicode-ident-1.0.16
unicode-segmentation-1.12.0
url-2.5.4
utf-8-0.7.6
utf16_iter-1.0.5
utf8_iter-1.0.4
uuid-1.13.1
valuable-0.1.1
version-compare-0.0.11
version-compare-0.2.0
version_check-0.9.5
vswhom-0.1.0
vswhom-sys-0.1.2
walkdir-2.5.0
wasi-0.11.0+wasi-snapshot-preview1
wasi-0.13.3+wasi-0.2.2
wasi-0.9.0+wasi-snapshot-preview1
wasm-bindgen-0.2.100
wasm-bindgen-backend-0.2.100
wasm-bindgen-macro-0.2.100
wasm-bindgen-macro-support-0.2.100
wasm-bindgen-shared-0.2.100
webkit2gtk-0.18.2
webkit2gtk-sys-0.18.0
webview2-com-0.19.1
webview2-com-macros-0.6.0
webview2-com-sys-0.19.0
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.9
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.39.0
windows-0.48.0
windows-bindgen-0.39.0
windows-core-0.52.0
windows-implement-0.39.0
windows-metadata-0.39.0
windows-sys-0.42.0
windows-sys-0.48.0
windows-sys-0.59.0
windows-targets-0.48.5
windows-targets-0.52.6
windows-targets-0.53.0
windows-tokens-0.39.0
windows-version-0.1.2
windows_aarch64_gnullvm-0.42.2
windows_aarch64_gnullvm-0.48.5
windows_aarch64_gnullvm-0.52.6
windows_aarch64_gnullvm-0.53.0
windows_aarch64_msvc-0.39.0
windows_aarch64_msvc-0.42.2
windows_aarch64_msvc-0.48.5
windows_aarch64_msvc-0.52.6
windows_aarch64_msvc-0.53.0
windows_i686_gnu-0.39.0
windows_i686_gnu-0.42.2
windows_i686_gnu-0.48.5
windows_i686_gnu-0.52.6
windows_i686_gnu-0.53.0
windows_i686_gnullvm-0.52.6
windows_i686_gnullvm-0.53.0
windows_i686_msvc-0.39.0
windows_i686_msvc-0.42.2
windows_i686_msvc-0.48.5
windows_i686_msvc-0.52.6
windows_i686_msvc-0.53.0
windows_x86_64_gnu-0.39.0
windows_x86_64_gnu-0.42.2
windows_x86_64_gnu-0.48.5
windows_x86_64_gnu-0.52.6
windows_x86_64_gnu-0.53.0
windows_x86_64_gnullvm-0.42.2
windows_x86_64_gnullvm-0.48.5
windows_x86_64_gnullvm-0.52.6
windows_x86_64_gnullvm-0.53.0
windows_x86_64_msvc-0.39.0
windows_x86_64_msvc-0.42.2
windows_x86_64_msvc-0.48.5
windows_x86_64_msvc-0.52.6
windows_x86_64_msvc-0.53.0
winnow-0.5.40
winnow-0.7.1
winreg-0.52.0
wit-bindgen-rt-0.33.0
write16-1.0.0
writeable-0.5.5
wry-0.24.11
x11-2.21.0
x11-dl-2.21.0
xattr-1.4.0
yoke-0.7.5
yoke-derive-0.7.5
zerocopy-0.7.35
zerocopy-derive-0.7.35
zerofrom-0.1.5
zerofrom-derive-0.1.5
zerovec-0.10.4
zerovec-derive-0.10.3
"
EGIT_COMMIT="c5829dd25a4ad93cc26bc01b4c8520fd3ef51916"
NODE_ENV="development"
NODE_VERSION="${AT_TYPES_NODE_PV%%.*}"
NPM_AUDIT_FIX_ARGS=( "--legacy-peer-deps" )
NPM_INSTALL_ARGS=( "--legacy-peer-deps" )
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
	=net-libs/nodejs-${NODE_VERSION}*[npm,webassembly(+)]
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

pkg_setup() {
	npm_pkg_setup
	export NEXT_TELEMETRY_DISABLED=1
	python_setup
	rust_pkg_setup
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
#	eapply "${FILESDIR}/${PN}-0.2.1_p20241022-debug.patch"
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
	rm -f "${S}/Cargo."* || true
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
