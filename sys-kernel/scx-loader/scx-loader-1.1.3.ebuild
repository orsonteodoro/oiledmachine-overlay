# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit secure-version

CFLAGS_HARDENED_USE_CASES="daemon security-critical sensitive-data untrusted-data" # For *-sys crates.
LLVM_COMPAT=( 23 )
RUST_MAX_VER="${RUST_LLVM_23_PV}"
RUST_MIN_VER="${RUST_LLVM_23_PV}"
RUST_NEEDS_LLVM=1 # Prune rustc for unused LLVM slots
RUSTFLAGS_HARDENED_USE_CASES="daemon security-critical sensitive-data untrusted-data"

CRATES="
aho-corasick-1.1.5
allocator-api2-0.2.21
android_system_properties-0.1.6
anstream-1.0.0
anstyle-1.0.14
anstyle-parse-1.0.0
anstyle-query-1.1.5
anstyle-wincon-3.0.11
anyhow-1.0.104
approx-0.5.1
ar_archive_writer-0.5.5
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
atomic-waker-1.1.2
autocfg-1.5.1
base64-0.22.1
bitflags-1.3.2
bitflags-2.13.2
bit-set-0.5.3
bit-vec-0.6.3
block2-0.6.2
block-buffer-0.10.4
blocking-1.7.0
bumpalo-3.20.4
by_address-1.2.1
bytes-1.12.2
castaway-0.2.4
cc-1.11.2
cfg_aliases-0.2.2
cfg-if-1.0.5
chrono-0.4.45
clap-4.6.9
clap_builder-4.6.7
clap_derive-4.6.9
clap_lex-1.1.2
colorchoice-1.0.5
colored-3.1.1
compact_str-0.9.1
concurrent-queue-2.5.0
convert_case-0.10.0
core-foundation-sys-0.8.7
cpufeatures-0.2.17
critical-section-1.2.0
crossbeam-utils-0.8.23
crossterm-0.29.0
crossterm_winapi-0.9.1
crypto-common-0.1.7
csscolorparser-0.6.2
ctrlc-3.5.3
darling-0.24.1
darling_core-0.24.1
darling_macro-0.24.1
deltae-0.3.2
deranged-0.5.9
derive_more-2.1.1
derive_more-impl-2.1.1
digest-0.10.7
dispatch2-0.3.1
document-features-0.2.12
either-1.19.0
endi-1.1.1
enumflags2-0.7.12
enumflags2_derive-0.7.12
equivalent-1.0.3
errno-0.3.15
euclid-0.22.14
event-listener-5.4.2
event-listener-strategy-0.5.4
fancy-regex-0.11.0
fastrand-2.5.0
filedescriptor-0.8.3
find-msvc-tools-0.1.15
finl_unicode-1.5.1
fixedbitset-0.4.2
fnv-1.0.7
foldhash-0.2.0
futures-core-0.3.34
futures-io-0.3.34
futures-lite-2.6.1
futures-sink-0.3.34
futures-task-0.3.34
futures-util-0.3.34
generic-array-0.14.7
getrandom-0.3.4
getrandom-0.4.3
hashbrown-0.17.1
heck-0.5.0
hermit-abi-0.5.3
hex-0.4.3
iana-time-zone-0.1.65
iana-time-zone-haiku-0.1.2
ident_case-1.0.1
indexmap-2.14.2
indoc-2.0.8
instability-0.3.14
is_terminal_polyfill-1.70.2
itertools-0.14.0
itoa-1.0.19
js-sys-0.3.107
kasuari-0.4.13
lab-0.11.0
lazy_static-1.5.1
libc-0.2.191
libm-0.2.16
line-clipping-0.3.8
linux-raw-sys-0.12.1
litrs-1.0.1
lock_api-0.4.14
log-0.4.35
lru-0.18.5
mac_address-1.2.1
memchr-2.8.3
memmem-0.1.1
memoffset-0.9.1
minimal-lexical-0.2.1
mio-1.2.5
nix-0.29.0
nix-0.31.4
nix-0.32.0
nom-7.1.3
ntapi-0.4.3
num-conv-0.2.2
num-derive-0.4.2
num_threads-0.1.8
num-traits-0.2.19
objc2-0.6.5
objc2-core-foundation-0.3.2
objc2-encode-4.1.0
objc2-foundation-0.3.2
objc2-io-kit-0.3.2
objc2-open-directory-0.3.2
object-0.39.1
once_cell-1.21.4
once_cell_polyfill-1.70.2
ordered-float-4.6.0
ordered-stream-0.2.0
palette-0.7.7
palette_derive-0.7.7
palette_math-0.7.7
parking-2.2.1
parking_lot-0.12.5
parking_lot_core-0.9.12
pest-2.9.6
pest_derive-2.9.6
pest_generator-2.9.6
pest_meta-2.9.6
pest_stack_guard-1.0.1
phf-0.11.3
phf_codegen-0.11.3
phf_generator-0.11.3
phf_macros-0.11.3
phf_shared-0.11.3
pin-project-lite-0.2.18
piper-0.2.5
polling-3.11.0
portable-atomic-1.15.0
powerfmt-0.2.1
proc-macro2-1.0.107
proc-macro-crate-3.5.0
psm-0.1.32
quote-1.0.47
rand-0.8.8
rand_core-0.6.4
ratatui-0.30.2
ratatui-core-0.1.2
ratatui-crossterm-0.1.2
ratatui-macros-0.7.2
ratatui-termina-0.1.0
ratatui-termwiz-0.1.2
ratatui-widgets-0.3.2
redox_syscall-0.5.18
r-efi-5.3.0
r-efi-6.0.0
regex-1.13.2
regex-automata-0.4.19
regex-syntax-0.8.12
rustc_version-0.4.1
rustix-1.1.6
rustversion-1.0.23
ryu-1.0.23
scopeguard-1.2.0
scxctl-1.1.3
scx_loader-1.1.3
scxtui-1.1.3
semver-1.0.28
serde-1.0.229
serde_core-1.0.229
serde_derive-1.0.229
serde_json-1.0.154
serde_repr-0.1.21
serde_spanned-1.1.3
sha2-0.10.9
shell-words-1.1.1
shlex-2.0.1
signal-hook-0.3.18
signal-hook-mio-0.2.5
signal-hook-registry-1.4.8
siphasher-1.0.4
slab-0.4.12
smallvec-1.16.6
socket2-0.6.5
stacker-0.1.25
static_assertions-1.1.0
strsim-0.11.1
strum-0.28.0
strum_macros-0.28.0
syn-1.0.109
syn-2.0.119
syn-3.0.10
sysinfo-0.39.6
tempfile-3.27.0
termina-0.3.3
terminal_size-0.4.4
terminfo-0.9.0
termios-0.3.3
termwiz-0.23.3
thiserror-1.0.69
thiserror-2.0.21
thiserror-impl-1.0.69
thiserror-impl-2.0.21
time-0.3.55
time-core-0.1.9
tokio-1.54.1
tokio-macros-2.7.2
tokio-util-0.7.20
toml-1.2.1+spec-1.1.0
toml_datetime-1.1.3+spec-1.1.0
toml_edit-0.25.19+spec-1.1.0
toml_parser-1.1.5+spec-1.1.0
toml_writer-1.2.0+spec-1.1.0
tracing-0.1.44
tracing-attributes-0.1.31
tracing-core-0.1.36
typenum-1.20.1
ucd-trie-0.1.8
uds_windows-1.2.1
unicase-2.10.0
unicode-ident-1.0.27
unicode-segmentation-1.13.3
unicode-truncate-2.0.1
unicode-width-0.2.3
utf8parse-0.2.2
uuid-1.29.3
version_check-0.9.5
vtparse-0.6.2
wasi-0.11.1+wasi-snapshot-preview1
wasip2-1.0.4+wasi-0.2.12
wasm-bindgen-0.2.130
wasm-bindgen-macro-0.2.130
wasm-bindgen-macro-support-0.2.130
wasm-bindgen-shared-0.2.130
wezterm-bidi-0.2.3
wezterm-blob-leases-0.1.1
wezterm-color-types-0.3.0
wezterm-dynamic-0.2.1
wezterm-dynamic-derive-0.1.1
wezterm-input-types-0.1.0
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.62.2
windows-collections-0.3.2
windows-core-0.62.2
windows-future-0.3.2
windows-implement-0.60.2
windows-interface-0.59.3
windows-link-0.2.1
windows-numerics-0.3.1
windows-result-0.4.1
windows-strings-0.5.1
windows-sys-0.61.2
windows-threading-0.2.1
winnow-1.0.5
wit-bindgen-0.57.1
xtask-0.1.0
zbus-5.19.0
zbus_macros-5.19.0
zbus_names-4.3.5
zbus_polkit-5.1.0
zcheapstr-1.3.0
zmij-1.0.23
zvariant-5.15.1
zvariant_derive-5.15.1
zvariant_utils-4.2.0
"

inherit cargo systemd

DESCRIPTION="DBUS on-demand loader of sched-ext schedulers"
HOMEPAGE="https://github.com/sched-ext/scx-loader"
SRC_URI="
${CARGO_CRATE_URIS}
https://github.com/sched-ext/scx-loader/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

RESTRICT="mirror" # Speed up downloads and reduce snooping
LICENSE="GPL-2"
# Dependent crate licenses
LICENSE+="
	MIT
	MPL-2.0
	Unicode-3.0 ZLIB
"
SLOT="0"
KEYWORDS="~amd64"
IUSE+="
${LLVM_COMPAT[@]/#/llvm_slot_}
"
REQUIRED_USE="
	|| (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
"
RDEPEND="
	~sys-kernel/scx-${PV}:=
"
BDEPEND="
	llvm_slot_23? (
                llvm-core/clang:23=[llvm_targets_BPF(-)]
                llvm-core/llvm:23=[llvm_targets_BPF(-)]
		|| (
			dev-lang/rust-bin:${RUST_LLVM_23_PV}
			dev-lang/rust:${RUST_LLVM_23_PV}
		)
	)
"

QA_PREBUILT="
	usr/bin/scx_loader
	usr/bin/scxctl
"

pkg_setup() {
	rust_pkg_setup
	[[ -z "${RUSTC}" ]] && die "RUSTC is not defined"
	"${RUSTC}" --version || die
}

src_unpack() {
	unpack ${A}
	die
	cargo_src_unpack

einfo "Replacing with updated Cargo.lock"
	cp -aT "${FILESDIR}/${PV}" "${S}" || die # This line must go after cargo_src_unpack().
}

src_configure() {
	cflags-hardened_append		# For *-sys crates
	rustflags-hardened_append	# For D-Bus input
	cargo_src_configure
}

src_install() {
	einstalldocs
	newdoc crates/scx_loader/README.md scx_loader.md
	newdoc crates/scxctl/README.md scxctl.md

	cargo_src_install --path crates/scx_loader
	cargo_src_install --path crates/scxctl

	newinitd "${FILESDIR}"/scx_loader.initd scx_loader
	systemd_dounit services/scx_loader.service

	insinto /usr/share/dbus-1/system/
	doins services/org.scx.Loader.service

	insinto /usr/share/dbus-1/system.d/
	doins configs/org.scx.Loader.conf

	insinto /usr/share/dbus-1/interfaces/
	doins configs/org.scx.Loader.xml

	insinto /usr/share/polkit-1/actions/
	doins configs/org.scx.Loader.policy

	insinto /etc/scx_loader/
	newins configs/scx_loader.toml config.toml
}
