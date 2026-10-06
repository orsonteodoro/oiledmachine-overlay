# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# AI inference was used for obtaining info for the patch.
# This ebuild contains AI generated code.

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CXX_STANDARD=20
RUSTFLAGS_HARDENED_USE_CASES="untrusted-data"
RUST_MAX_VER="1.98.1"
RUST_MIN_VER="1.98.1" # LLVM 22.1
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
wayle-0.7.0
wayle-config-0.7.0
wayle-derive-0.7.0
wayle-i18n-0.7.0
wayle-icons-0.7.0
wayle-idle-inhibit-0.7.0
wayle-ipc-0.7.0
wayle-settings-0.7.0
wayle-shell-0.7.0
wayle-styling-0.7.0
wayle-widgets-0.7.0
"

CRATES="
adler2-2.0.1
ahash-0.8.12
aho-corasick-1.1.5
allocator-api2-0.2.21
android_system_properties-0.1.6
anstream-1.0.0
anstyle-1.0.14
anstyle-parse-1.0.0
anstyle-query-1.1.5
anstyle-wincon-3.0.11
approx-0.5.1
arc-swap-1.9.2
arrayref-0.3.9
arrayvec-0.7.8
async-broadcast-0.7.2
async-recursion-1.2.0
async-stream-0.3.6
async-stream-impl-0.3.6
async-trait-0.1.92
atomic-waker-1.1.2
autocfg-1.5.1
aws-lc-rs-1.18.1
aws-lc-sys-0.45.0
base64-0.22.1
base64-0.23.1
basic-toml-0.1.10
bindgen-0.72.1
bitflags-2.13.2
bitvec-1.1.1
block-buffer-0.12.1
bumpalo-3.20.3
by_address-1.2.1
bytemuck-1.25.2
bytemuck_derive-1.12.1
bytes-1.12.1
bytesize-2.7.0
cairo-rs-0.22.9
cairo-sys-rs-0.22.9
calloop-0.14.5
calloop-wayland-source-0.4.1
cc-1.6.0
cexpr-0.6.0
cfg_aliases-0.2.2
cfg-expr-0.20.10
cfg-if-1.0.5
chacha20-0.10.2
chrono-0.4.45
clang-sys-1.9.1
clap-4.6.7
clap_builder-4.6.7
clap_complete-4.6.11
clap_derive-4.6.7
clap_lex-1.1.1
cmake-0.1.58
codemap-0.1.3
colorchoice-1.0.5
combine-4.6.8
concurrent-queue-2.5.0
console-0.16.6
const-oid-0.10.2
core_detect-1.0.0
core-foundation-0.10.1
core-foundation-sys-0.8.7
core_maths-0.1.1
cpufeatures-0.3.1
crc32fast-1.5.2
crossbeam-channel-0.5.17
crossbeam-utils-0.8.23
crypto-common-0.2.2
cursor-icon-1.2.0
data-url-0.3.2
deranged-0.5.8
derive_more-2.1.1
derive_more-impl-2.1.1
digest-0.11.3
displaydoc-0.2.7
dotenvy-0.15.7
downcast-rs-1.2.1
dunce-1.0.5
dyn-clone-1.0.20
either-1.18.0
encode_unicode-1.0.0
encoding_rs-0.8.42
endi-1.1.1
enumflags2-0.7.12
enumflags2_derive-0.7.12
equivalent-1.0.2
errno-0.3.14
euclid-0.22.14
evdev-0.13.2
event-listener-5.4.2
event-listener-strategy-0.5.4
fallible-iterator-0.3.0
fallible-streaming-iterator-0.1.9
fastrand-2.5.0
fdeflate-0.3.7
field-offset-0.3.6
find-crate-0.6.3
find-msvc-tools-0.1.14
flate2-1.1.10
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
fragile-2.1.0
fsevent-sys-4.1.0
fs_extra-1.3.0
funty-2.0.0
futures-0.3.34
futures-channel-0.3.34
futures-core-0.3.34
futures-executor-0.3.34
futures-io-0.3.34
futures-lite-2.6.1
futures-macro-0.3.34
futures-sink-0.3.34
futures-task-0.3.34
futures-util-0.3.34
gdk4-0.11.5
gdk4-sys-0.11.5
gdk-pixbuf-0.22.0
gdk-pixbuf-sys-0.22.9
getrandom-0.2.17
getrandom-0.3.4
getrandom-0.4.3
gio-0.22.10
gio-sys-0.22.9
gio-unix-0.22.8
gio-unix-sys-0.22.9
gl-0.14.0
gl_generator-0.14.0
glib-0.22.10
glib-macros-0.22.9
glib-sys-0.22.9
glob-0.3.4
gobject-sys-0.22.9
graphene-rs-0.22.8
graphene-sys-0.22.9
grass-0.13.4
grass_compiler-0.13.4
gsk4-0.11.5
gsk4-sys-0.11.5
gtk4-0.11.5
gtk4-layer-shell-0.8.1
gtk4-layer-shell-sys-0.6.1
gtk4-macros-0.11.5
gtk4-sys-0.11.5
hashbrown-0.14.5
hashbrown-0.16.1
hashbrown-0.17.1
hashlink-0.11.1
heck-0.5.0
hermit-abi-0.3.9
hermit-abi-0.5.3
hex-0.4.3
http-1.5.0
httparse-1.10.1
http-body-1.1.0
http-body-util-0.1.5
hybrid-array-0.4.15
hyper-1.11.1
hyper-rustls-0.27.10
hyper-util-0.1.21
i18n-config-0.4.8
i18n-embed-0.16.0
i18n-embed-fl-0.10.1
i18n-embed-impl-0.8.4
iana-time-zone-0.1.65
iana-time-zone-haiku-0.1.2
icu_collections-2.3.0
icu_locale_core-2.3.0
icu_normalizer-2.3.0
icu_normalizer_data-2.3.0
icu_properties-2.3.0
icu_properties_data-2.3.0
icu_provider-2.3.1
idna-1.1.0
idna_adapter-1.2.2
imagesize-0.14.0
indexmap-2.14.2
indicatif-0.18.6
inotify-0.11.5
inotify-sys-0.1.8
intl-memoizer-0.5.3
intl_pluralrules-7.0.2
inventory-0.3.24
io-lifetimes-1.0.11
ipnet-2.12.2
is_terminal_polyfill-1.70.2
itertools-0.13.0
itoa-1.0.18
jni-0.22.4
jni-macros-0.22.4
jni-sys-0.4.1
jni-sys-macros-0.4.1
jobserver-0.1.35
js-sys-0.3.106
khronos_api-3.1.0
kqueue-1.2.1
kqueue-sys-1.1.2
kurbo-0.13.1
lasso-0.7.3
lazy_static-1.5.1
libc-0.2.190
libloading-0.8.9
libm-0.2.16
libpulse-binding-2.30.1
libpulse-sys-1.23.0
libsqlite3-sys-0.36.0
libudev-sys-0.1.4
linux-raw-sys-0.12.1
litemap-0.8.3
lock_api-0.4.14
log-0.4.34
lru-slab-0.1.3
matchers-0.2.0
memchr-2.8.3
memmap2-0.9.11
memoffset-0.9.1
memo-map-0.3.4
mime-0.3.17
mime_guess-2.0.5
minijinja-2.24.0
minimal-lexical-0.2.1
miniz_oxide-0.8.9
miniz_oxide-0.9.1
mio-1.2.4
multiversion_no_op-1.0.0
niri-ipc-25.11.0
nix-0.29.0
nix-0.30.1
nom-7.1.3
notify-8.2.0
notify-types-2.1.0
ntapi-0.4.3
nu-ansi-term-0.50.3
num-conv-0.2.2
num-derive-0.4.2
num-traits-0.2.19
once_cell-1.21.4
once_cell_polyfill-1.70.2
openssl-probe-0.2.1
ordered-stream-0.2.0
owo-colors-4.4.0
palette-0.7.7
palette_derive-0.7.7
palette_math-0.7.7
pango-0.22.9
pango-sys-0.22.9
parking-2.2.1
parking_lot-0.12.5
parking_lot_core-0.9.12
percent-encoding-2.3.2
phf-0.11.3
phf-0.13.1
phf_generator-0.11.3
phf_macros-0.11.3
phf_shared-0.11.3
phf_shared-0.13.1
pico-args-0.5.0
pin-project-lite-0.2.17
pkg-config-0.3.34
png-0.18.1
polling-3.11.0
polycool-0.4.0
portable-atomic-1.15.0
potential_utf-0.1.6
powerfmt-0.2.1
ppv-lite86-0.2.21
prettyplease-0.2.37
proc-macro2-1.0.107
proc-macro-crate-3.5.0
proc-macro-error3-3.1.1
proc-macro-error-attr3-3.1.1
quick-xml-0.41.0
quinn-0.11.12
quinn-proto-0.11.19
quinn-udp-0.5.16
quote-1.0.47
radium-0.7.0
rand-0.10.3
rand-0.8.8
rand-0.9.5
rand_chacha-0.3.1
rand_chacha-0.9.0
rand_core-0.10.1
rand_core-0.6.4
rand_core-0.9.5
rand_pcg-0.10.2
redox_syscall-0.5.18
ref-cast-1.0.27
ref-cast-impl-1.0.27
r-efi-5.3.0
r-efi-6.0.0
regex-1.13.1
regex-automata-0.4.18
regex-syntax-0.8.11
relm4-0.11.0
relm4-css-0.11.0
relm4-macros-0.11.0
reqwest-0.13.5
ring-0.17.14
roxmltree-0.20.0
roxmltree-0.21.1
rsqlite-vfs-0.1.1
rusqlite-0.38.0
rustc-hash-2.1.3
rustc_version-0.4.1
rust-embed-8.12.0
rust-embed-impl-8.12.0
rust-embed-utils-8.12.0
rustix-1.1.5
rustls-0.23.45
rustls-native-certs-0.8.4
rustls-pki-types-1.15.1
rustls-platform-verifier-0.7.1
rustls-platform-verifier-android-0.2.0
rustls-webpki-0.103.15
rustversion-1.0.23
rustybuzz-0.20.1
ryu-1.0.23
same-file-1.0.6
schannel-0.1.29
schemars-1.2.2
schemars_derive-1.2.2
scopeguard-1.2.0
security-framework-3.7.0
security-framework-sys-2.17.0
self_cell-1.3.0
semver-1.0.28
serde-1.0.229
serde_core-1.0.229
serde_derive-1.0.229
serde_derive_internals-0.30.0
serde_json-1.0.151
serde_json_path-0.7.2
serde_json_path_core-0.2.2
serde_json_path_macros-0.1.6
serde_json_path_macros_internal-0.1.2
serde_repr-0.1.21
serde_spanned-1.1.1
serde_urlencoded-0.7.1
sha2-0.11.0
sharded-slab-0.1.7
shlex-1.3.0
shlex-2.0.1
signal-hook-registry-1.4.8
simd-adler32-0.3.10
simd_cesu8-1.2.0
simdutf8-0.1.5
simplecss-0.2.2
siphasher-1.0.4
slab-0.4.12
slotmap-1.1.1
smallvec-1.16.2
smithay-client-toolkit-0.20.0
socket2-0.6.5
sourceview5-0.11.2
sourceview5-sys-0.11.2
spin-0.9.9
sqlite-wasm-rs-0.5.5
stable_deref_trait-1.2.1
strict-num-0.1.1
strsim-0.11.1
subtle-2.6.1
svgtypes-0.16.1
symlink-0.1.0
syn-2.0.119
syn-3.0.6
sync_wrapper-1.0.2
synstructure-0.14.0
sysinfo-0.33.1
sys-locale-0.3.2
system-deps-7.0.8
system-deps-8.0.0
system-deps-9.0.0
tap-1.0.1
target-lexicon-0.13.5
tempfile-3.27.0
thiserror-1.0.69
thiserror-2.0.21
thiserror-impl-1.0.69
thiserror-impl-2.0.21
thread_local-1.1.10
time-0.3.55
time-core-0.1.9
time-macros-0.2.32
tiny-skia-path-0.11.4
tinystr-0.8.4
tinyvec-1.13.3
tokio-1.53.2
tokio-macros-2.7.2
tokio-rustls-0.26.6
tokio-stream-0.1.19
tokio-util-0.7.19
toml-0.5.11
toml-1.1.6+spec-1.1.0
toml_datetime-1.1.1+spec-1.1.0
toml_edit-0.25.15+spec-1.1.0
toml_parser-1.1.3+spec-1.1.0
toml_writer-1.1.2+spec-1.1.0
tower-0.5.3
tower-http-0.6.11
tower-layer-0.3.3
tower-service-0.3.3
tracing-0.1.44
tracing-appender-0.2.5
tracing-attributes-0.1.31
tracing-core-0.1.36
tracing-log-0.2.0
tracing-serde-0.2.0
tracing-subscriber-0.3.23
try-lock-0.2.5
ttf-parser-0.25.1
type-map-0.5.1
typenum-1.20.1
udev-0.9.3
uds_windows-1.2.1
unicase-2.10.0
unic-langid-0.9.6
unic-langid-impl-0.9.6
unicode-bidi-0.3.18
unicode-bidi-mirroring-0.4.0
unicode-ccc-0.4.0
unicode-ident-1.0.26
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
uuid-1.27.0
valuable-0.1.1
vcpkg-0.2.15
version_check-0.9.5
version-compare-0.2.1
walkdir-2.5.0
want-0.3.2
wasi-0.11.1+wasi-snapshot-preview1
wasip2-1.0.4+wasi-0.2.12
wasm-bindgen-0.2.129
wasm-bindgen-futures-0.4.79
wasm-bindgen-macro-0.2.129
wasm-bindgen-macro-support-0.2.129
wasm-bindgen-shared-0.2.129
wayland-backend-0.3.17
wayland-client-0.31.15
wayland-csd-frame-0.3.0
wayland-cursor-0.31.14
wayland-protocols-0.32.13
wayland-protocols-experimental-20250721.0.1
wayland-protocols-misc-0.3.12
wayland-protocols-wlr-0.3.12
wayland-scanner-0.31.11
wayland-sys-0.31.11
wayle-audio-0.1.4
wayle-battery-0.1.2
wayle-bluetooth-0.1.2
wayle-brightness-0.1.2
wayle-cava-0.1.2
wayle-core-0.1.2
wayle-hyprland-0.2.3
wayle-mango-0.1.1
wayle-media-0.1.3
wayle-network-0.1.2
wayle-niri-0.1.0
wayle-notification-0.1.4
wayle-power-profiles-0.1.4
wayle-sysinfo-0.1.2
wayle-systray-0.1.4
wayle-traits-0.1.2
wayle-wallpaper-0.1.4
wayle-weather-0.1.2
webpki-root-certs-1.0.9
web-sys-0.3.106
web-time-1.1.0
wildcard-0.3.0
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.11
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.57.0
windows_aarch64_gnullvm-0.48.5
windows_aarch64_gnullvm-0.52.6
windows_aarch64_gnullvm-0.53.1
windows_aarch64_msvc-0.48.5
windows_aarch64_msvc-0.52.6
windows_aarch64_msvc-0.53.1
windows-core-0.57.0
windows-core-0.62.2
windows_i686_gnu-0.48.5
windows_i686_gnu-0.52.6
windows_i686_gnu-0.53.1
windows_i686_gnullvm-0.52.6
windows_i686_gnullvm-0.53.1
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
windows-sys-0.48.0
windows-sys-0.52.0
windows-sys-0.60.2
windows-sys-0.61.2
windows-targets-0.48.5
windows-targets-0.52.6
windows-targets-0.53.5
windows_x86_64_gnu-0.48.5
windows_x86_64_gnu-0.52.6
windows_x86_64_gnu-0.53.1
windows_x86_64_gnullvm-0.48.5
windows_x86_64_gnullvm-0.52.6
windows_x86_64_gnullvm-0.53.1
windows_x86_64_msvc-0.48.5
windows_x86_64_msvc-0.52.6
windows_x86_64_msvc-0.53.1
winnow-1.0.4
wit-bindgen-0.57.1
writeable-0.6.4
wyz-0.5.1
xcursor-0.3.11
xkbcommon-0.8.0
xkeysym-0.2.1
xml-rs-0.8.29
xmlwriter-0.1.0
yoke-0.8.3
yoke-derive-0.8.4
zbus-5.19.0
zbus_macros-5.19.0
zbus_names-4.3.4
zcheapstr-1.1.0
zerocopy-0.8.60
zerocopy-derive-0.8.60
zerofrom-0.1.8
zerofrom-derive-0.1.8
zeroize-1.9.0
zerotrie-0.2.5
zerovec-0.11.8
zerovec-derive-0.11.6
zlib-rs-0.6.8
zmij-1.0.23
zvariant-5.15.0
zvariant_derive-5.15.0
zvariant_utils-4.2.0
"

CHKL_TIMESTAMPS=(
	"dev-vcs/git-9999-r3"
	"dev-vcs/git-9999-r2"
	"dev-vcs/git-9999-r1"
	"dev-vcs/git-9999"
	"gui-libs/gtk-4.24.9999"
	"media-libs/libpulse-9999"
	"media-video/pipewire-9999"
	"net-wireless/bluez-9999"
	"net-misc/networkmanager-9999"
)

inherit cargo cflags-hardened flag-o-matic-om libcxx-slot libstdcxx-slot lcnr rust rustflags-hardened secure-version systemd xdg

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
bluez doc networkmanager pipewire pipewire-pulse power-profiles-daemon upower wireplumber
ebuild_revision_3
"
REQUIRED_USE="
	pipewire-pulse? (
		pipewire
	)
"
RDEPEND+="
	>=gui-libs/gtk-${GTK4_PV}:4=
	>=gui-libs/gtk4-layer-shell-1.0:=
	>=gui-libs/gtksourceview-5:=
	>=media-libs/libpulse-${LIBPULSE_PV}:=
	>=sci-libs/fftw-3:=
	x11-themes/hicolor-icon-theme:=
	virtual/libudev:=
	bluez? (
		>=net-wireless/bluez-${BLUEZ_PV}:=
	)
	networkmanager? (
		>=net-misc/networkmanager-${NETWORKMANAGER_PV}:=
	)
	pipewire? (
		>=media-video/pipewire-${PIPEWIRE_PV}:=
		pipewire-pulse? (
			>=media-video/pipewire-${PIPEWIRE_PV}:=[sound-server]
		)
	)
	power-profiles-daemon? (
		sys-power/power-profiles-daemon:=
	)
	upower? (
		sys-power/upower:=
	)
	wireplumber? (
		media-video/wireplumber:=
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-vcs/git-${GIT_PV}
	dev-build/cmake
	dev-util/desktop-file-utils
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
		#die
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
		eapply "${FILESDIR}/aws-lc-sys-0.45.0-append-O0.patch"
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
# OILEDMACHINE-OVERLAY-TEST:  PASSED INTERACTIVE 0.3.0 (20260522)
