# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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

AT_TYPES_NODE_PV="20.12.12"
MY_PN="WindowPet"
NODE_VERSION="${AT_TYPES_NODE_PV%%.*}"
NPM_AUDIT_FIX=1
NPM_SKIP_TARBALL_UNPACK="1"
PLUGINS_WORKSPACE_COMMIT="5e3900e682e13f3759b439116ae2f77a6d389ca2"

declare -A GIT_CRATES=(
[tauri-plugin-log]="https://github.com/tauri-apps/plugins-workspace;5e3900e682e13f3759b439116ae2f77a6d389ca2;plugins-workspace-%commit%/plugins/log" # 0.0.0
[tauri-plugin-single-instance]="https://github.com/tauri-apps/plugins-workspace;5e3900e682e13f3759b439116ae2f77a6d389ca2;plugins-workspace-%commit%/plugins/single-instance" # 0.0.0
[tauri-plugin-store]="https://github.com/tauri-apps/plugins-workspace;5e3900e682e13f3759b439116ae2f77a6d389ca2;plugins-workspace-%commit%/plugins/store" # 0.0.0
)

CRATES="
addr2line-0.21.0
adler-1.0.2
ahash-0.7.8
aho-corasick-1.1.3
alloc-no-stdlib-2.0.4
alloc-stdlib-0.2.2
android-tzdata-0.1.1
android_system_properties-0.1.5
anyhow-1.0.86
arrayvec-0.7.4
async-broadcast-0.5.1
async-channel-2.3.1
async-executor-1.11.0
async-fs-1.6.0
async-io-1.13.0
async-io-2.3.2
async-lock-2.8.0
async-lock-3.3.0
async-process-1.8.1
async-recursion-1.1.1
async-signal-0.2.6
async-task-4.7.1
async-trait-0.1.80
atk-0.15.1
atk-sys-0.15.1
atomic-waker-1.1.2
auto-launch-0.5.0
autocfg-1.3.0
backtrace-0.3.71
base64-0.13.1
base64-0.21.7
base64-0.22.1
bitflags-1.3.2
bitflags-2.5.0
bitvec-1.0.1
block-0.1.6
block-buffer-0.10.4
blocking-1.6.0
borsh-1.5.0
borsh-derive-1.5.0
brotli-3.5.0
brotli-decompressor-2.5.1
bstr-1.9.1
bumpalo-3.16.0
byte-unit-5.1.4
bytecheck-0.6.12
bytecheck_derive-0.6.12
bytemuck-1.16.0
byteorder-1.5.0
bytes-1.6.0
cairo-rs-0.15.12
cairo-sys-rs-0.15.1
cargo_toml-0.15.3
cc-1.0.98
cesu8-1.1.0
cfb-0.7.3
cfg-expr-0.15.8
cfg-expr-0.9.1
cfg-if-1.0.0
cfg_aliases-0.1.1
chrono-0.4.38
cocoa-0.24.1
cocoa-foundation-0.1.2
color_quant-1.1.0
combine-4.6.7
concurrent-queue-2.5.0
convert_case-0.4.0
core-foundation-0.9.4
core-foundation-sys-0.8.6
core-graphics-0.22.3
core-graphics-types-0.1.3
cpufeatures-0.2.12
crc32fast-1.4.2
crossbeam-channel-0.5.13
crossbeam-deque-0.8.5
crossbeam-epoch-0.9.18
crossbeam-utils-0.8.20
crypto-common-0.1.6
cssparser-0.27.2
cssparser-macros-0.6.1
ctor-0.2.8
darling-0.20.9
darling_core-0.20.9
darling_macro-0.20.9
deranged-0.3.11
derivative-2.2.0
derive_more-0.99.17
digest-0.10.7
dirs-4.0.0
dirs-next-2.0.0
dirs-sys-0.3.7
dirs-sys-next-0.1.2
dispatch-0.2.0
dtoa-1.0.9
dtoa-short-0.3.4
dunce-1.0.4
embed-resource-2.4.2
embed_plist-1.2.2
encoding_rs-0.8.34
enumflags2-0.7.9
enumflags2_derive-0.7.9
equivalent-1.0.1
errno-0.3.9
event-listener-2.5.3
event-listener-3.1.0
event-listener-4.0.3
event-listener-5.3.0
event-listener-strategy-0.4.0
event-listener-strategy-0.5.2
fastrand-1.9.0
fastrand-2.1.0
fdeflate-0.3.4
fern-0.6.2
field-offset-0.3.6
filetime-0.2.23
flate2-1.0.30
fnv-1.0.7
foreign-types-0.3.2
foreign-types-shared-0.1.1
form_urlencoded-1.2.1
funty-2.0.0
futf-0.1.5
futures-channel-0.3.30
futures-core-0.3.30
futures-executor-0.3.30
futures-io-0.3.30
futures-lite-1.13.0
futures-lite-2.3.0
futures-macro-0.3.30
futures-sink-0.3.30
futures-task-0.3.30
futures-util-0.3.30
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
h2-0.3.26
hashbrown-0.12.3
hashbrown-0.14.5
heck-0.3.3
heck-0.4.1
heck-0.5.0
hermit-abi-0.3.9
hex-0.4.3
html5ever-0.26.0
http-0.2.12
http-body-0.4.6
http-range-0.1.5
httparse-1.8.0
httpdate-1.0.3
hyper-0.14.28
hyper-tls-0.5.0
iana-time-zone-0.1.60
iana-time-zone-haiku-0.1.2
ico-0.3.0
ident_case-1.0.1
idna-0.5.0
ignore-0.4.22
image-0.24.9
indexmap-1.9.3
indexmap-2.2.6
infer-0.13.0
instant-0.1.13
io-lifetimes-1.0.11
ipnet-2.9.0
is-docker-0.2.0
is-wsl-0.4.0
itoa-0.4.8
itoa-1.0.11
javascriptcore-rs-0.16.0
javascriptcore-rs-sys-0.4.0
jni-0.20.0
jni-sys-0.3.0
js-sys-0.3.69
json-patch-1.4.0
kuchikiki-0.8.2
lazy_static-1.4.0
libappindicator-0.7.1
libappindicator-sys-0.7.3
libc-0.2.155
libloading-0.7.4
libredox-0.1.3
line-wrap-0.2.0
linux-raw-sys-0.3.8
linux-raw-sys-0.4.14
lock_api-0.4.12
log-0.4.21
loom-0.5.6
mac-0.1.1
malloc_buf-0.0.6
markup5ever-0.11.0
matchers-0.1.0
matches-0.1.10
memchr-2.7.2
memoffset-0.7.1
memoffset-0.9.1
mime-0.3.17
minisign-verify-0.2.1
miniz_oxide-0.7.3
mio-0.8.11
mouse_position-0.1.3
native-tls-0.2.11
ndk-0.6.0
ndk-context-0.1.1
ndk-sys-0.3.0
new_debug_unreachable-1.0.6
nix-0.26.4
nodrop-0.1.14
nu-ansi-term-0.46.0
num-conv-0.1.0
num-traits-0.2.19
num_cpus-1.16.0
num_enum-0.5.11
num_enum_derive-0.5.11
num_threads-0.1.7
objc-0.2.7
objc-foundation-0.1.1
objc_exception-0.1.2
objc_id-0.1.1
object-0.32.2
once_cell-1.19.0
open-3.2.0
open-5.1.3
openssl-0.10.64
openssl-macros-0.1.1
openssl-probe-0.1.5
openssl-sys-0.9.102
ordered-stream-0.2.0
overload-0.1.1
pango-0.15.10
pango-sys-0.15.10
parking-2.2.0
parking_lot-0.12.2
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
piper-0.2.2
pkg-config-0.3.30
plist-1.6.1
png-0.17.13
polling-2.8.0
polling-3.7.0
powerfmt-0.2.0
ppv-lite86-0.2.17
precomputed-hash-0.1.1
proc-macro-crate-1.3.1
proc-macro-crate-3.1.0
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro-hack-0.5.20+deprecated
proc-macro2-1.0.83
ptr_meta-0.1.4
ptr_meta_derive-0.1.4
quick-xml-0.31.0
quote-1.0.36
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
redox_syscall-0.4.1
redox_syscall-0.5.1
redox_users-0.4.5
regex-1.10.4
regex-automata-0.1.10
regex-automata-0.4.6
regex-syntax-0.6.29
regex-syntax-0.8.3
rend-0.4.2
reqwest-0.11.27
rfd-0.10.0
rkyv-0.7.44
rkyv_derive-0.7.44
rust_decimal-1.35.0
rustc-demangle-0.1.24
rustc_version-0.4.0
rustix-0.37.27
rustix-0.38.34
rustls-pemfile-1.0.4
rustversion-1.0.17
ryu-1.0.18
same-file-1.0.6
schannel-0.1.23
scoped-tls-1.0.1
scopeguard-1.2.0
seahash-4.1.0
security-framework-2.11.0
security-framework-sys-2.11.0
selectors-0.22.0
semver-1.0.23
serde-1.0.202
serde_derive-1.0.202
serde_json-1.0.117
serde_repr-0.1.19
serde_spanned-0.6.6
serde_urlencoded-0.7.1
serde_with-3.8.1
serde_with_macros-3.8.1
serialize-to-javascript-0.1.1
serialize-to-javascript-impl-0.1.1
servo_arc-0.1.1
sha1-0.10.6
sha2-0.10.8
sharded-slab-0.1.7
signal-hook-registry-1.4.2
simd-adler32-0.3.7
simdutf8-0.1.4
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
syn-2.0.65
syn_derive-0.1.8
sync_wrapper-0.1.2
system-configuration-0.5.1
system-configuration-sys-0.5.0
system-deps-5.0.0
system-deps-6.2.2
tao-0.16.9
tao-macros-0.1.2
tap-1.0.1
tar-0.4.40
target-lexicon-0.12.14
tauri-1.6.7
tauri-build-1.5.2
tauri-codegen-1.4.3
tauri-macros-1.4.4
tauri-runtime-0.14.3
tauri-runtime-wry-0.14.8
tauri-utils-1.5.4
tauri-winres-0.1.1
tempfile-3.10.1
tendril-0.4.3
thin-slice-0.1.1
thiserror-1.0.61
thiserror-impl-1.0.61
thread_local-1.1.8
time-0.3.36
time-core-0.1.2
time-macros-0.2.18
tinyvec-1.6.0
tinyvec_macros-0.1.1
tokio-1.37.0
tokio-native-tls-0.3.1
tokio-util-0.7.11
toml-0.5.11
toml-0.7.8
toml-0.8.13
toml_datetime-0.6.6
toml_edit-0.19.15
toml_edit-0.21.1
toml_edit-0.22.13
tower-service-0.3.2
tracing-0.1.40
tracing-attributes-0.1.27
tracing-core-0.1.32
tracing-log-0.2.0
tracing-subscriber-0.3.18
try-lock-0.2.5
typenum-1.17.0
uds_windows-1.1.0
unicode-bidi-0.3.15
unicode-ident-1.0.12
unicode-normalization-0.1.23
unicode-segmentation-1.11.0
url-2.5.0
utf-8-0.7.6
utf8-width-0.1.7
uuid-1.8.0
valuable-0.1.0
value-bag-1.9.0
vcpkg-0.2.15
version-compare-0.0.11
version-compare-0.2.0
version_check-0.9.4
vswhom-0.1.0
vswhom-sys-0.1.2
waker-fn-1.2.0
walkdir-2.5.0
want-0.3.1
wasi-0.11.0+wasi-snapshot-preview1
wasi-0.9.0+wasi-snapshot-preview1
wasm-bindgen-0.2.92
wasm-bindgen-backend-0.2.92
wasm-bindgen-futures-0.4.42
wasm-bindgen-macro-0.2.92
wasm-bindgen-macro-support-0.2.92
wasm-bindgen-shared-0.2.92
wasm-streams-0.4.0
web-sys-0.3.69
webkit2gtk-0.18.2
webkit2gtk-sys-0.18.0
webview2-com-0.19.1
webview2-com-macros-0.6.0
webview2-com-sys-0.19.0
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.8
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
windows-targets-0.48.5
windows-targets-0.52.5
windows-tokens-0.39.0
windows-version-0.1.1
windows_aarch64_gnullvm-0.42.2
windows_aarch64_gnullvm-0.48.5
windows_aarch64_gnullvm-0.52.5
windows_aarch64_msvc-0.37.0
windows_aarch64_msvc-0.39.0
windows_aarch64_msvc-0.42.2
windows_aarch64_msvc-0.48.5
windows_aarch64_msvc-0.52.5
windows_i686_gnu-0.37.0
windows_i686_gnu-0.39.0
windows_i686_gnu-0.42.2
windows_i686_gnu-0.48.5
windows_i686_gnu-0.52.5
windows_i686_gnullvm-0.52.5
windows_i686_msvc-0.37.0
windows_i686_msvc-0.39.0
windows_i686_msvc-0.42.2
windows_i686_msvc-0.48.5
windows_i686_msvc-0.52.5
windows_x86_64_gnu-0.37.0
windows_x86_64_gnu-0.39.0
windows_x86_64_gnu-0.42.2
windows_x86_64_gnu-0.48.5
windows_x86_64_gnu-0.52.5
windows_x86_64_gnullvm-0.42.2
windows_x86_64_gnullvm-0.48.5
windows_x86_64_gnullvm-0.52.5
windows_x86_64_msvc-0.37.0
windows_x86_64_msvc-0.39.0
windows_x86_64_msvc-0.42.2
windows_x86_64_msvc-0.48.5
windows_x86_64_msvc-0.52.5
winnow-0.5.40
winnow-0.6.8
winreg-0.10.1
winreg-0.50.0
winreg-0.52.0
wry-0.24.10
wyz-0.5.1
x11-2.21.0
x11-dl-2.21.0
xattr-1.3.1
xdg-home-1.1.0
zbus-3.15.2
zbus_macros-3.15.2
zbus_names-2.6.1
zip-0.6.6
zvariant-3.15.2
zvariant_derive-3.15.2
zvariant_utils-1.0.1
"

inherit cargo desktop lcnr npm xdg

SRC_URI="
$(cargo_crate_uris ${CRATES})
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
#KEYWORDS="~amd64" # Needs code audit or code review
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
tray wayland +X
ebuild_revision_3
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
	>=net-libs/webkit-gtk-2.42.3:4[wayland?,X?]
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
	rust_pkg_setup
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

npm_unpack_post() {
	pushd "${S}" >/dev/null 2>&1 || die
		if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
			eapply "${FILESDIR}/windowpet-0.0.8-remove-tauri-plugin-autostart-api-from-lockfiles.patch"
			eapply "${FILESDIR}/windowpet-0.0.8-remove-tauri-plugin-autostart-api-from-code.patch"
		else
			eapply "${FILESDIR}/windowpet-0.0.8-remove-tauri-plugin-autostart-api-from-code.patch"
		fi
	popd >/dev/null 2>&1 || die
	if [[ -e "${FILESDIR}/${PV}/Cargo.lock" ]] ; then
		cp -a \
			"${FILESDIR}/${PV}/Cargo.lock" \
			"${FILESDIR}/${PV}/Cargo.toml" \
			"${WORKDIR}/${MY_PN}-${PV}/src-tauri" \
			|| die
	else
ewarn "Missing security updated Cargo.lock"
	fi
}

src_unpack() {
	if [[ "${NPM_UPDATE_LOCK}" != "1" ]] ; then
		unpack ${P}.tar.gz
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
	rm -f "${WORKDIR}/${MY_PN}-${PV}/Cargo."{"lock","toml"}
	grep -q -r -e "tauri-plugin-autostart-api" "${S}" && die "Detected unpatched project (1)"
	grep -q -r -e "tauri-plugin-autostart" "${S}" && die "Detected unpatched project (2)"
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
