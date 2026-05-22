# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CXX_STANDARD=20
RUSTFLAGS_HARDENED_USE_CASES="untrusted-data"
RUST_MAX_VER="1.95.0"
RUST_MIN_VER="1.95.0" # LLVM 22.1
RUSTFLAGS_HARDENED_USE_CASES="untrusted-data"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX20[@]}" # 13-16
)
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)"

# See use_cxx23 in build/config/compiler/compiler.gni and build/config/compiler/BUILD.gn
inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX20[@]/llvm_slot_}" # 20-22
)
LIBCXX_USEDEP_LTS="llvm_slot_skip(+)"

declare -A GIT_CRATES=(
)

DISABLED_CRATES="
wayle-0.3.0
wayle-config-0.3.0
wayle-derive-0.3.0
wayle-i18n-0.3.0
wayle-icons-0.3.0
wayle-idle-inhibit-0.3.0
wayle-ipc-0.3.0
wayle-settings-0.3.0
wayle-shell-0.3.0
wayle-styling-0.3.0
wayle-widgets-0.3.0
"

CRATES="
adler2-2.0.1
ahash-0.8.12
aho-corasick-1.1.4
allocator-api2-0.2.21
android_system_properties-0.1.5
anstream-0.6.21
anstyle-1.0.13
anstyle-parse-0.2.7
anstyle-query-1.1.5
anstyle-wincon-3.0.11
approx-0.5.1
arc-swap-1.8.0
arrayref-0.3.9
arrayvec-0.7.6
async-broadcast-0.7.2
async-recursion-1.1.1
async-stream-0.3.6
async-stream-impl-0.3.6
async-trait-0.1.89
atomic-waker-1.1.2
autocfg-1.5.0
aws-lc-rs-1.15.3
aws-lc-sys-0.36.0
base64-0.22.1
basic-toml-0.1.10
bindgen-0.72.1
bitflags-1.3.2
bitflags-2.10.0
bitvec-1.0.1
block-buffer-0.10.4
bumpalo-3.19.1
by_address-1.2.1
bytemuck-1.24.0
bytemuck_derive-1.10.2
bytes-1.11.0
bytesize-2.3.1
cairo-rs-0.21.5
cairo-sys-rs-0.21.5
calloop-0.14.3
calloop-wayland-source-0.4.1
cc-1.2.53
cesu8-1.1.0
cexpr-0.6.0
cfg_aliases-0.2.1
cfg-expr-0.20.5
cfg-if-1.0.4
chrono-0.4.43
clang-sys-1.8.1
clap-4.5.54
clap_builder-4.5.54
clap_complete-4.6.0
clap_derive-4.5.49
clap_lex-0.7.7
cmake-0.1.57
codemap-0.1.3
colorchoice-1.0.4
combine-4.6.7
concurrent-queue-2.5.0
console-0.16.2
core-foundation-0.10.1
core-foundation-sys-0.8.7
core_maths-0.1.1
cpufeatures-0.2.17
crc32fast-1.5.0
crossbeam-channel-0.5.15
crossbeam-utils-0.8.21
crypto-common-0.1.7
cursor-icon-1.2.0
data-url-0.3.2
deranged-0.5.5
derive_more-2.1.1
derive_more-impl-2.1.1
digest-0.10.7
displaydoc-0.2.5
dotenvy-0.15.7
downcast-rs-1.2.1
dunce-1.0.5
dyn-clone-1.0.20
either-1.15.0
encode_unicode-1.0.0
encoding_rs-0.8.35
endi-1.1.1
enumflags2-0.7.12
enumflags2_derive-0.7.12
equivalent-1.0.2
errno-0.3.14
euclid-0.22.13
evdev-0.13.2
event-listener-5.4.1
event-listener-strategy-0.5.4
fallible-iterator-0.3.0
fallible-streaming-iterator-0.1.9
fastrand-2.3.0
fast-srgb8-1.0.0
fdeflate-0.3.7
field-offset-0.3.6
find-crate-0.6.3
find-msvc-tools-0.1.8
flate2-1.1.8
float-cmp-0.9.0
fluent-0.17.0
fluent-bundle-0.16.0
fluent-langneg-0.13.1
fluent-syntax-0.12.0
flume-0.12.0
fnv-1.0.7
foldhash-0.2.0
fontconfig-parser-0.5.8
fontdb-0.23.0
form_urlencoded-1.2.2
fragile-2.0.1
fsevent-sys-4.1.0
fs_extra-1.3.0
funty-2.0.0
futures-0.3.31
futures-channel-0.3.31
futures-core-0.3.31
futures-executor-0.3.31
futures-io-0.3.31
futures-lite-2.6.1
futures-macro-0.3.31
futures-sink-0.3.31
futures-task-0.3.31
futures-util-0.3.31
gdk4-0.10.3
gdk4-sys-0.10.3
gdk-pixbuf-0.21.5
gdk-pixbuf-sys-0.21.5
generic-array-0.14.7
getrandom-0.2.17
getrandom-0.3.4
gio-0.21.5
gio-sys-0.21.5
gl-0.14.0
gl_generator-0.14.0
glib-0.21.5
glib-macros-0.21.5
glib-sys-0.21.5
glob-0.3.3
gobject-sys-0.21.5
graphene-rs-0.21.5
graphene-sys-0.21.5
grass-0.13.4
grass_compiler-0.13.4
gsk4-0.10.3
gsk4-sys-0.10.3
gtk4-0.10.3
gtk4-layer-shell-0.7.1
gtk4-layer-shell-sys-0.5.2
gtk4-macros-0.10.3
gtk4-sys-0.10.3
hashbrown-0.14.5
hashbrown-0.16.1
hashlink-0.11.0
heck-0.5.0
hermit-abi-0.3.9
hermit-abi-0.5.2
hex-0.4.3
http-1.4.0
httparse-1.10.1
http-body-1.0.1
http-body-util-0.1.3
hyper-1.8.1
hyper-rustls-0.27.7
hyper-util-0.1.19
i18n-config-0.4.8
i18n-embed-0.16.0
i18n-embed-fl-0.10.0
i18n-embed-impl-0.8.4
iana-time-zone-0.1.64
iana-time-zone-haiku-0.1.2
icu_collections-2.1.1
icu_locale_core-2.1.1
icu_normalizer-2.1.1
icu_normalizer_data-2.1.1
icu_properties-2.1.2
icu_properties_data-2.1.2
icu_provider-2.1.1
idna-1.1.0
idna_adapter-1.2.1
imagesize-0.14.0
indexmap-2.13.0
indicatif-0.18.3
inotify-0.11.0
inotify-sys-0.1.5
intl-memoizer-0.5.3
intl_pluralrules-7.0.2
inventory-0.3.21
io-lifetimes-1.0.11
ipnet-2.11.0
iri-string-0.7.10
is_terminal_polyfill-1.70.2
itertools-0.13.0
itoa-1.0.17
jni-0.21.1
jni-sys-0.3.0
jobserver-0.1.34
js-sys-0.3.85
khronos_api-3.1.0
kqueue-1.1.1
kqueue-sys-1.0.4
kurbo-0.13.0
lasso-0.7.3
lazy_static-1.5.0
libc-0.2.180
libloading-0.8.9
libm-0.2.15
libpulse-binding-2.30.1
libpulse-sys-1.23.0
libsqlite3-sys-0.36.0
libudev-sys-0.1.4
linux-raw-sys-0.11.0
litemap-0.8.1
lock_api-0.4.14
log-0.4.29
lru-slab-0.1.2
matchers-0.2.0
memchr-2.7.6
memmap2-0.9.9
memoffset-0.9.1
mime-0.3.17
minijinja-2.15.1
minimal-lexical-0.2.1
miniz_oxide-0.8.9
mio-1.1.1
niri-ipc-25.11.0
nix-0.29.0
nix-0.30.1
nom-7.1.3
notify-8.2.0
notify-types-2.0.0
ntapi-0.4.2
nu-ansi-term-0.50.3
num-conv-0.1.0
num-derive-0.4.2
num-traits-0.2.19
once_cell-1.21.3
once_cell_polyfill-1.70.2
openssl-probe-0.2.1
ordered-stream-0.2.0
owo-colors-4.2.3
palette-0.7.6
palette_derive-0.7.6
pango-0.21.5
pango-sys-0.21.5
parking-2.2.1
parking_lot-0.12.5
parking_lot_core-0.9.12
percent-encoding-2.3.2
phf-0.11.3
phf_generator-0.11.3
phf_macros-0.11.3
phf_shared-0.11.3
pico-args-0.5.0
pin-project-lite-0.2.16
pin-utils-0.1.0
pkg-config-0.3.32
png-0.18.1
polling-3.11.0
portable-atomic-1.13.0
potential_utf-0.1.4
powerfmt-0.2.0
ppv-lite86-0.2.21
prettyplease-0.2.37
proc-macro2-1.0.105
proc-macro-crate-3.4.0
proc-macro-error2-2.0.1
proc-macro-error-attr2-2.0.0
quick-xml-0.38.4
quinn-0.11.9
quinn-proto-0.11.13
quinn-udp-0.5.14
quote-1.0.43
radium-0.7.0
rand-0.8.5
rand-0.9.2
rand_chacha-0.3.1
rand_chacha-0.9.0
rand_core-0.6.4
rand_core-0.9.5
redox_syscall-0.5.18
ref-cast-1.0.25
ref-cast-impl-1.0.25
r-efi-5.3.0
regex-1.12.3
regex-automata-0.4.13
regex-syntax-0.8.8
relm4-0.10.1
relm4-css-0.10.1
relm4-macros-0.10.1
reqwest-0.13.1
ring-0.17.14
roxmltree-0.20.0
roxmltree-0.21.1
rsqlite-vfs-0.1.0
rusqlite-0.38.0
rustc-hash-2.1.1
rustc_version-0.4.1
rust-embed-8.11.0
rust-embed-impl-8.11.0
rust-embed-utils-8.11.0
rustix-1.1.3
rustls-0.23.36
rustls-native-certs-0.8.3
rustls-pki-types-1.14.0
rustls-platform-verifier-0.6.2
rustls-platform-verifier-android-0.1.1
rustls-webpki-0.103.9
rustversion-1.0.22
rustybuzz-0.20.1
ryu-1.0.22
same-file-1.0.6
schannel-0.1.28
schemars-1.2.0
schemars_derive-1.2.0
scopeguard-1.2.0
security-framework-3.5.1
security-framework-sys-2.15.0
self_cell-1.2.2
semver-1.0.27
serde-1.0.228
serde_core-1.0.228
serde_derive-1.0.228
serde_derive_internals-0.29.1
serde_json-1.0.149
serde_json_path-0.7.2
serde_json_path_core-0.2.2
serde_json_path_macros-0.1.6
serde_json_path_macros_internal-0.1.2
serde_repr-0.1.20
serde_spanned-1.0.4
serde_urlencoded-0.7.1
sha2-0.10.9
sharded-slab-0.1.7
shlex-1.3.0
signal-hook-registry-1.4.8
simd-adler32-0.3.8
simplecss-0.2.2
siphasher-1.0.1
slab-0.4.11
slotmap-1.1.1
smallvec-1.15.1
smithay-client-toolkit-0.20.0
socket2-0.6.1
sourceview5-0.10.0
sourceview5-sys-0.10.1
spin-0.9.8
sqlite-wasm-rs-0.5.2
stable_deref_trait-1.2.1
strict-num-0.1.1
strsim-0.11.1
subtle-2.6.1
svgtypes-0.16.1
syn-2.0.114
sync_wrapper-1.0.2
synstructure-0.13.2
sysinfo-0.33.1
sys-locale-0.3.2
system-deps-7.0.7
tap-1.0.1
target-lexicon-0.13.3
tempfile-3.24.0
thiserror-1.0.69
thiserror-2.0.18
thiserror-impl-1.0.69
thiserror-impl-2.0.18
thread_local-1.1.9
time-0.3.45
time-core-0.1.7
time-macros-0.2.25
tiny-skia-path-0.11.4
tinystr-0.8.2
tinyvec-1.10.0
tinyvec_macros-0.1.1
tokio-1.49.0
tokio-macros-2.6.0
tokio-rustls-0.26.4
tokio-stream-0.1.18
tokio-util-0.7.18
toml-0.5.11
toml-0.9.11+spec-1.1.0
toml_datetime-0.7.5+spec-1.1.0
toml_edit-0.23.10+spec-1.0.0
toml_parser-1.0.6+spec-1.1.0
toml_writer-1.0.6+spec-1.1.0
tower-0.5.3
tower-http-0.6.8
tower-layer-0.3.3
tower-service-0.3.3
tracing-0.1.44
tracing-appender-0.2.4
tracing-attributes-0.1.31
tracing-core-0.1.36
tracing-log-0.2.0
tracing-serde-0.2.0
tracing-subscriber-0.3.22
try-lock-0.2.5
ttf-parser-0.25.1
type-map-0.5.1
typenum-1.19.0
udev-0.9.3
uds_windows-1.1.0
unic-langid-0.9.6
unic-langid-impl-0.9.6
unicode-bidi-0.3.18
unicode-bidi-mirroring-0.4.0
unicode-ccc-0.4.0
unicode-ident-1.0.22
unicode-properties-0.1.4
unicode-script-0.5.8
unicode-vo-0.1.0
unicode-width-0.2.2
unicode-xid-0.2.6
unit-prefix-0.5.2
untrusted-0.9.0
url-2.5.8
usvg-0.46.0
utf8_iter-1.0.4
utf8parse-0.2.2
uuid-1.19.0
valuable-0.1.1
vcpkg-0.2.15
version_check-0.9.5
version-compare-0.2.1
walkdir-2.5.0
want-0.3.1
wasi-0.11.1+wasi-snapshot-preview1
wasip2-1.0.2+wasi-0.2.9
wasm-bindgen-0.2.108
wasm-bindgen-futures-0.4.58
wasm-bindgen-macro-0.2.108
wasm-bindgen-macro-support-0.2.108
wasm-bindgen-shared-0.2.108
wayland-backend-0.3.12
wayland-client-0.31.12
wayland-csd-frame-0.3.0
wayland-cursor-0.31.12
wayland-protocols-0.32.10
wayland-protocols-experimental-20250721.0.1
wayland-protocols-misc-0.3.10
wayland-protocols-wlr-0.3.10
wayland-scanner-0.31.8
wayland-sys-0.31.8
wayle-audio-0.1.2
wayle-battery-0.1.2
wayle-bluetooth-0.1.2
wayle-brightness-0.1.2
wayle-cava-0.1.2
wayle-core-0.1.2
wayle-hyprland-0.1.2
wayle-media-0.1.2
wayle-network-0.1.2
wayle-niri-0.1.0
wayle-notification-0.1.3
wayle-power-profiles-0.1.2
wayle-sysinfo-0.1.2
wayle-systray-0.1.2
wayle-traits-0.1.2
wayle-wallpaper-0.1.3
wayle-weather-0.1.2
webpki-root-certs-1.0.5
web-sys-0.3.85
web-time-1.1.0
wildcard-0.3.0
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.11
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.57.0
windows_aarch64_gnullvm-0.42.2
windows_aarch64_gnullvm-0.48.5
windows_aarch64_gnullvm-0.52.6
windows_aarch64_gnullvm-0.53.1
windows_aarch64_msvc-0.42.2
windows_aarch64_msvc-0.48.5
windows_aarch64_msvc-0.52.6
windows_aarch64_msvc-0.53.1
windows-core-0.57.0
windows-core-0.62.2
windows_i686_gnu-0.42.2
windows_i686_gnu-0.48.5
windows_i686_gnu-0.52.6
windows_i686_gnu-0.53.1
windows_i686_gnullvm-0.52.6
windows_i686_gnullvm-0.53.1
windows_i686_msvc-0.42.2
windows_i686_msvc-0.48.5
windows_i686_msvc-0.52.6
windows_i686_msvc-0.53.1
windows-implement-0.57.0
windows-implement-0.60.2
windows-interface-0.57.0
windows-interface-0.59.3
windows-link-0.2.1
windows-result-0.1.2
windows-result-0.4.1
windows-strings-0.5.1
windows-sys-0.45.0
windows-sys-0.48.0
windows-sys-0.52.0
windows-sys-0.60.2
windows-sys-0.61.2
windows-targets-0.42.2
windows-targets-0.48.5
windows-targets-0.52.6
windows-targets-0.53.5
windows_x86_64_gnu-0.42.2
windows_x86_64_gnu-0.48.5
windows_x86_64_gnu-0.52.6
windows_x86_64_gnu-0.53.1
windows_x86_64_gnullvm-0.42.2
windows_x86_64_gnullvm-0.48.5
windows_x86_64_gnullvm-0.52.6
windows_x86_64_gnullvm-0.53.1
windows_x86_64_msvc-0.42.2
windows_x86_64_msvc-0.48.5
windows_x86_64_msvc-0.52.6
windows_x86_64_msvc-0.53.1
winnow-0.7.14
wit-bindgen-0.51.0
writeable-0.6.2
wyz-0.5.1
xcursor-0.3.10
xkbcommon-0.8.0
xkeysym-0.2.1
xml-rs-0.8.28
xmlwriter-0.1.0
yoke-0.8.1
yoke-derive-0.8.1
zbus-5.13.2
zbus_macros-5.13.2
zbus_names-4.3.1
zerocopy-0.8.33
zerocopy-derive-0.8.33
zerofrom-0.1.6
zerofrom-derive-0.1.6
zeroize-1.8.2
zerotrie-0.2.3
zerovec-0.11.5
zerovec-derive-0.11.2
zmij-1.0.16
zvariant-5.9.2
zvariant_derive-5.9.2
zvariant_utils-3.3.0
"

inherit cargo cflags-hardened flag-o-matic-om libcxx-slot libstdcxx-slot lcnr rust rustflags-hardened systemd xdg

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/wayle-rs/wayle.git"
	FALLBACK_COMMIT="4f82ef7a367fa310988e3a19cbbf12f4c84b6dc6" # May 17, 2026
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
$(cargo_crate_uris ${CRATES})
https://github.com/wayle-rs/wayle/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A compositor agnostic shell with extensive customization"
HOMEPAGE="
	https://github.com/wayle-rs/wayle
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
doc
ebuild_revision_3
"
RDEPEND+="
	>=gui-libs/gtk-4.12:4
	>=gui-libs/gtk4-layer-shell-1.0
	>=gui-libs/gtksourceview-5
	>=media-libs/libpulse-8
	>=media-video/pipewire-0.3
	>=sci-libs/fftw-3
	virtual/libudev
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-build/cmake
	dev-vcs/git
	llvm-core/clang
	virtual/pkgconfig
"
DOCS=( "README.md" )

pkg_setup() {
	rust_pkg_setup

	libcxx-slot_verify
	libstdcxx-slot_verify

	# Clang (system)
	local s
	for s in "${LLVM_COMPAT[@]}" ; do
		if use "llvm_slot_${s}" ; then
			slot="${s}"
			break
		fi
	done

	LLVM_SLOT="${slot}"

einfo "PATH:  ${PATH} (Before)"
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -e "/llvm/d" \
		| sed -e "/llvm-build/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}/bin:${PWD}/install/bin|g")
einfo "PATH:  ${PATH} (After)"
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	cargo_src_unpack
	cp -aT \
		"${FILESDIR}/${PV}"* \
		"${S}" \
		|| die
}

src_prepare() {
	default
	pushd "${WORKDIR}" || die
		eapply "${FILESDIR}/wayle-cava-0.1.2-path-max.patch"
	popd || die
}

src_configure() {
	export CARGO_TERM_VERBOSE="true"
	export CC="${CHOST}-gcc" # Prevent GCC atomic issue with Clang
	export CXX="${CHOST}-g++"
	export CPP="${CC} -E"
	fix_mb_len_max
	unset LD
	cflags-hardened_append
	rustflags-hardened_append
	export LLVM_CONFIG_PATH="/usr/lib/llvm/${LLVM_SLOT}/bin/llvm-config"
	export LIBCLANG_PATH="/usr/lib/llvm/${LLVM_SLOT}/$(get_libdir)"
	cargo_src_configure
einfo "CC:  ${CC}"
einfo "CXX:  ${CXX}"
einfo "CPP:  ${CPP}"
einfo "LD:  ${LD}"
einfo "CFLAGS:  ${CFLAGS}"
einfo "CXXFLAGS:  ${CXXFLAGS}"
einfo "CPPFLAGS:  ${CPPFLAGS}"
einfo "LDFLAGS:  ${LDFLAGS}"
}

src_compile() {
	rustflags-hardened_append
	cargo_src_compile
}

src_install() {
	exeinto "/usr/bin"
	doexe "target/"*"/release/wayle-settings"
	doexe "target/"*"/release/wayle"

	# Install resources (icons, config examples, etc.)
	if [[ -d resources ]]; then
		insinto "/usr/share/wayle"
		doins -r "resources/"*
	fi

	# Desktop file + icons (if they exist in resources)
	if [[ -f "resources/com.wayle.settings.desktop" ]] ; then
		domenu "resources/com.wayle.settings.desktop"
	fi

	doicon "wayle-settings.svg"

	if use doc && [[ -f "resources/wayle.service" ]] ; then
		systemd_douserunit "resources/wayle.service" || die
	fi

	docinto "licenses"
	dodoc "LICENSE"

	LCNR_SOURCE="${WORKDIR}/cargo_home/gentoo"
	LCNR_TAG="third_party"
        lcnr_install_files
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
