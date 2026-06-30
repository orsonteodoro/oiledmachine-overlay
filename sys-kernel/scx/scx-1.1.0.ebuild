# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

# This ebuild uses a patch that was based on an AI generated code fix.

# For requirements, see https://github.com/sched-ext/scx/tree/v1.0.20?tab=readme-ov-file#build--install

# AL2026-01-01:  Rust 1.93.0, LLVM 21.1.8, Protobuf 6.33.1-3
# C2026-02 (Native):  Rust 1.93.0, LLVM 21.1.8, Protobuf 6.33.1
# C2026-02 (Frawhide):  Rust 1.93.1, LLVM 21.1.8, Protobuf 3.19.6
# C2026-02 (F44):  Rust 1.93.1, LLVM 21.1.8, Protobuf 3.19.6
# C2026-02 (F43):  Rust 1.93.0, LLVM 21.1.8, Protobuf 3.19.6
# C2026-02 (F42):  Rust 1.93.0, LLVM 21.1.8, Protobuf 3.19.6
# G23:  Rust 1.92.0, LLVM 21.1.8, Protobuf 6.31.1
# U24:  Rust 1.74.1, 1.75.0 (default), 1.76.0, 1.77.2, 1.78.0, 1.79.0, 1.80.1, 1.81.0, 1.82.0, 1.83.0, 1.84.1, 1.85.1, 1.89.0; LLVM 14-19 (18 default), Protobuf 3.21.12
# U24 (CI):  Rust 1.91.1, LLVM 19, Protobuf 3.21.12
# N25.11:  Rust 1.91.1, LLVM 21.1.7, Protobuf 6.32.1

# Both LLVM 19 and LLVM 21 are required.
# Ideally both should be aligned but not possible, but the package will still build.
# LLVM 19 - Required for protobuf-cpp 3.21.12 (LTS on D12/U24).
#           Required for Linux kernel built with Clang 19 (LTS on D13)
# LLVM 21 - Required for Rust 1.91.1 (U24 has Rust 1.91.1 but not LLVM 21, but rust-bin uses LLVM 21)

GENERATE_LOCKFILE=0
# Both llvm_slot_19 and llvm_slot_21 must be specified.
LLVM_COMPAT=( 19 21 )
# RUST_*_VER will be pinned to meet cargo lockfile requirements.
RUST_MAX_VER="1.94.1" # LLVM 21.1
RUST_MIN_VER="1.94.1" # LLVM 21.1
DISABLED_CRATES="
scx_arena_selftests-1.1.0
scx_bpf_unittests-1.1.0
scx_mitosis-1.1.0
scx_wd40-1.1.0
vmlinux_docify-1.1.0
xtask-1.1.0
"
CRATES="
addr2line-0.25.1
adler2-2.0.1
affinity-0.1.2
ahash-0.8.12
aho-corasick-1.1.4
allocator-api2-0.2.21
android_system_properties-0.1.5
anes-0.1.6
anpa-0.10.0
anstream-0.6.21
anstream-1.0.0
anstyle-1.0.14
anstyle-parse-0.2.7
anstyle-parse-1.0.0
anstyle-query-1.1.5
anstyle-wincon-3.0.11
anyhow-1.0.102
arboard-3.6.1
arrayvec-0.7.6
async-broadcast-0.7.2
async-channel-2.5.0
async-executor-1.14.0
async-io-2.6.0
async-lock-3.4.2
async-process-2.5.0
async-recursion-1.1.1
async-signal-0.2.14
async-task-4.7.1
async-trait-0.1.89
atomic-0.6.1
atomic-waker-1.1.2
autocfg-1.5.0
backtrace-0.3.76
base64-0.22.1
below-common-0.9.0
bindgen-0.63.0
bindgen-0.72.1
bitflags-1.3.2
bitflags-2.11.1
bit-set-0.5.3
bit-vec-0.6.3
bitvec-1.0.1
blazesym-0.2.3
block2-0.6.2
block-buffer-0.10.4
blocking-1.6.2
bon-3.9.1
bon-macros-3.9.1
buddy_system_allocator-0.11.0
bumpalo-3.20.2
bytemuck-1.25.0
byteorder-lite-0.1.0
bytes-1.11.1
camino-1.2.2
cargo_metadata-0.18.1
cargo_metadata-0.19.2
cargo_metadata-0.23.1
cargo-platform-0.1.9
cargo-platform-0.3.3
cassowary-0.3.0
cast-0.3.0
castaway-0.2.4
cc-1.2.61
cexpr-0.6.0
cfg_aliases-0.2.1
cfg-if-1.0.4
cgroupfs-0.9.0
chrono-0.4.44
ciborium-0.2.2
ciborium-io-0.2.2
ciborium-ll-0.2.2
clang-sys-1.8.1
clap-4.5.60
clap_builder-4.5.60
clap_complete-4.6.3
clap_derive-4.5.55
clap_lex-1.1.0
clap_main-0.2.9
clap-num-1.2.0
clipboard-win-5.4.1
colorchoice-1.0.5
colored-3.1.1
combinations-0.1.0
compact_str-0.8.1
compact_str-0.9.0
concurrent-queue-2.5.0
const_format-0.2.36
const_format_proc_macros-0.2.34
convert_case-0.10.0
convert_case-0.6.0
core_affinity-0.8.3
core-foundation-sys-0.8.7
cpp_demangle-0.5.1
cpufeatures-0.2.17
crc32fast-1.5.0
criterion-0.6.0
criterion-plot-0.5.0
crossbeam-0.8.4
crossbeam-channel-0.5.15
crossbeam-deque-0.8.6
crossbeam-epoch-0.9.18
crossbeam-queue-0.3.12
crossbeam-utils-0.8.21
crossterm-0.25.0
crossterm-0.28.1
crossterm-0.29.0
crossterm_winapi-0.9.1
crunchy-0.2.4
crypto-common-0.1.7
csscolorparser-0.6.2
csv-1.4.0
csv-core-0.1.13
ctrlc-3.5.2
cursive-0.20.0
cursive_core-0.3.7
darling-0.20.11
darling-0.21.3
darling-0.23.0
darling_core-0.20.11
darling_core-0.21.3
darling_core-0.23.0
darling_macro-0.20.11
darling_macro-0.21.3
darling_macro-0.23.0
deltae-0.3.2
deranged-0.5.8
derive_more-2.1.1
derive_more-impl-2.1.1
digest-0.10.7
dispatch2-0.3.1
document-features-0.2.12
either-1.15.0
encoding_rs-0.8.35
endi-1.1.1
enumflags2-0.7.12
enumflags2_derive-0.7.12
enum-map-2.7.3
enum-map-derive-0.17.0
enumset-1.1.10
enumset_derive-0.14.0
env_filter-1.0.1
env_logger-0.11.10
equivalent-1.0.2
erased-serde-0.3.31
errno-0.3.14
error-code-3.3.2
euclid-0.22.14
event-listener-5.4.1
event-listener-strategy-0.5.4
fallible-iterator-0.3.0
fancy-regex-0.11.0
fastrand-2.4.1
fax-0.2.7
fb_procfs-0.7.1
fdeflate-0.3.7
filedescriptor-0.8.3
filetime-0.2.27
find-msvc-tools-0.1.9
finl_unicode-1.4.0
fixedbitset-0.4.2
flate2-1.1.9
fnv-1.0.7
foldhash-0.1.5
foldhash-0.2.0
funty-2.0.0
futures-0.3.32
futures-channel-0.3.32
futures-core-0.3.32
futures-executor-0.3.32
futures-io-0.3.32
futures-lite-2.6.1
futures-macro-0.3.32
futures-sink-0.3.32
futures-task-0.3.32
futures-util-0.3.32
generic-array-0.14.7
gethostname-1.1.0
getrandom-0.2.17
getrandom-0.3.4
getrandom-0.4.2
gimli-0.32.3
glob-0.3.3
gpoint-0.2.1
half-2.7.1
hashbrown-0.15.5
hashbrown-0.16.1
hashbrown-0.17.0
heck-0.5.0
hermit-abi-0.5.2
hex-0.4.3
home-0.5.12
humantime-2.3.0
iana-time-zone-0.1.65
iana-time-zone-haiku-0.1.2
id-arena-2.3.0
ident_case-1.0.1
image-0.25.10
include_dir-0.7.4
include_dir_macros-0.7.4
indexmap-2.14.0
indoc-2.0.7
inotify-0.11.1
inotify-sys-0.1.5
instability-0.3.12
is-terminal-0.4.17
is_terminal_polyfill-1.70.2
itertools-0.10.5
itertools-0.13.0
itertools-0.14.0
itoa-1.0.18
jiff-0.2.24
jiff-static-0.2.24
js-sys-0.3.97
kasuari-0.4.12
konst-0.2.20
konst_macro_rules-0.2.19
lab-0.11.0
lazycell-1.3.0
lazy_static-1.5.0
leb128fmt-0.1.0
libbpf-cargo-0.26.1
libbpf-rs-0.26.1
libbpf-sys-1.6.3+v1.6.3
libc-0.2.186
libloading-0.8.9
libredox-0.1.16
line-clipping-0.3.7
linux-raw-sys-0.12.1
linux-raw-sys-0.4.15
litrs-1.0.0
lock_api-0.4.14
log-0.4.29
log-panics-2.1.0
lru-0.12.5
lru-0.16.4
mac_address-1.1.8
maplit-1.0.2
matchers-0.2.0
memchr-2.8.0
memmap2-0.9.10
memmem-0.1.1
memoffset-0.6.5
memoffset-0.9.1
micromath-2.1.0
minimal-lexical-0.2.1
miniz_oxide-0.8.9
miniz_oxide-0.9.1
mio-0.8.11
mio-1.2.0
moxcms-0.8.1
nix-0.25.1
nix-0.29.0
nix-0.30.1
nix-0.31.2
nom-7.1.3
ntapi-0.4.3
nu-ansi-term-0.50.3
num-0.4.3
num-bigint-0.4.6
num-complex-0.4.6
num-conv-0.2.1
num_cpus-1.17.0
num-derive-0.4.2
num-format-0.4.4
num-format-windows-0.4.4
num-integer-0.1.46
num-iter-0.1.45
num-rational-0.4.2
num_threads-0.1.7
num-traits-0.2.19
nvml-wrapper-0.11.0
nvml-wrapper-sys-0.9.1
objc2-0.6.4
objc2-app-kit-0.3.2
objc2-core-foundation-0.3.2
objc2-core-graphics-0.3.2
objc2-encode-4.1.0
objc2-foundation-0.3.2
objc2-io-kit-0.3.2
objc2-io-surface-0.3.2
object-0.36.7
object-0.37.3
once_cell-1.21.4
once_cell_polyfill-1.70.2
oorandom-11.1.5
openat-0.1.21
ordered-float-3.9.2
ordered-float-4.6.0
ordered-stream-0.2.0
owning_ref-0.4.1
parking-2.2.1
parking_lot-0.12.5
parking_lot_core-0.9.12
paste-1.0.15
peeking_take_while-0.1.2
percent-encoding-2.3.2
perfetto_protos-0.51.1
perf-event-open-sys-5.0.0
pest-2.8.6
pest_derive-2.8.6
pest_generator-2.8.6
pest_meta-2.8.6
phf-0.11.3
phf_codegen-0.11.3
phf_generator-0.11.3
phf_macros-0.11.3
phf_shared-0.11.3
pin-project-lite-0.2.17
pin-utils-0.1.0
piper-0.2.5
pkg-config-0.3.33
plain-0.2.3
plotters-0.3.7
plotters-backend-0.3.7
plotters-svg-0.3.7
png-0.18.1
polling-3.11.0
portable-atomic-1.13.1
portable-atomic-util-0.2.7
powerfmt-0.2.0
ppv-lite86-0.2.21
prettyplease-0.2.37
procfs-0.18.0
procfs-core-0.18.0
proc-macro2-1.0.106
proc-macro-crate-3.5.0
protobuf-3.7.2
protobuf-codegen-3.7.2
protobuf-parse-3.7.2
protobuf-support-3.7.2
protoc-bin-vendored-3.2.0
protoc-bin-vendored-linux-aarch_64-3.2.0
protoc-bin-vendored-linux-ppcle_64-3.2.0
protoc-bin-vendored-linux-s390_64-3.2.0
protoc-bin-vendored-linux-x86_32-3.2.0
protoc-bin-vendored-linux-x86_64-3.2.0
protoc-bin-vendored-macos-aarch_64-3.2.0
protoc-bin-vendored-macos-x86_64-3.2.0
protoc-bin-vendored-win32-3.2.0
pxfm-0.1.29
quanta-0.12.6
quick-error-2.0.1
quote-1.0.45
radium-0.7.0
rand-0.8.6
rand_chacha-0.3.1
rand_core-0.6.4
ratatui-0.29.0
ratatui-0.30.0
ratatui-core-0.1.0
ratatui-crossterm-0.1.0
ratatui-macros-0.7.0
ratatui-termwiz-0.1.0
ratatui-widgets-0.3.0
raw-cpuid-11.6.0
rayon-1.12.0
rayon-core-1.13.0
redox_syscall-0.5.18
redox_syscall-0.7.5
r-efi-5.3.0
r-efi-6.0.0
regex-1.12.3
regex-automata-0.4.14
regex-syntax-0.6.29
regex-syntax-0.8.10
rlimit-0.10.2
rustc-demangle-0.1.27
rustc-hash-1.1.0
rustc-hash-2.1.2
rustc_version-0.4.1
rustix-0.38.44
rustix-1.1.4
rustversion-1.0.22
ruzstd-0.7.3
ruzstd-0.8.2
ryu-1.0.23
same-file-1.0.6
scopeguard-1.2.0
scx_arena-1.1.0
scx_beerland-1.1.0
scx_bpf_compat-1.1.0
scx_bpfland-1.1.0
scx_cake-1.1.0
scx_cargo-1.1.0
scxcash-1.1.0
scx_chaos-1.1.0
scx_cosmos-1.1.0
scx_flash-1.1.0
scx_lavd-1.1.0
scx_layered-1.1.0
scx_p2dq-1.1.0
scx_pandemonium-5.4.13
scx_raw_pmu-1.1.0
scx_rlfifo-1.1.0
scx_rustland-1.1.0
scx_rustland_core-2.4.11
scx_rusty-1.1.0
scx_stats-1.1.0
scx_stats_derive-1.1.0
scx_tickless-1.1.0
scxtop-1.1.0
scx_userspace_arena-1.1.0
scx_utils-1.1.0
seccomp-0.1.2
seccomp-sys-0.1.3
semver-1.0.28
serde-1.0.228
serde_core-1.0.228
serde_derive-1.0.228
serde_json-1.0.149
serde_repr-0.1.20
serde_spanned-0.6.9
sha2-0.10.9
sharded-slab-0.1.7
shlex-1.3.0
signal-hook-0.3.18
signal-hook-mio-0.2.5
signal-hook-registry-1.4.8
simd-adler32-0.3.9
simplelog-0.12.2
simple_logger-5.2.0
siphasher-1.0.3
slab-0.4.12
slog-2.8.2
slog-term-2.9.2
smallvec-1.15.1
smartstring-1.0.1
socket2-0.6.3
sorted-vec-0.8.10
sscanf-0.4.4
sscanf_macro-0.4.4
stable_deref_trait-1.2.1
static_assertions-1.1.0
strsim-0.11.1
strum-0.26.3
strum-0.27.2
strum_macros-0.26.4
strum_macros-0.27.2
syn-1.0.109
syn-2.0.117
sysinfo-0.35.2
tachyonfx-0.22.0
tap-1.0.1
tar-0.4.45
tempfile-3.27.0
term-1.2.1
termcolor-1.4.1
terminal_size-0.4.4
terminfo-0.9.0
termios-0.3.3
termwiz-0.23.3
thiserror-1.0.69
thiserror-2.0.18
thiserror-impl-1.0.69
thiserror-impl-2.0.18
thread_local-1.1.9
threadpool-1.8.1
tiff-0.11.3
time-0.3.47
time-core-0.1.8
time-macros-0.2.27
tinytemplate-1.2.1
tokio-1.52.2
tokio-macros-2.7.0
tokio-util-0.7.18
toml-0.8.23
toml_datetime-0.6.11
toml_datetime-1.1.1+spec-1.1.0
toml_edit-0.22.27
toml_edit-0.25.11+spec-1.1.0
toml_parser-1.1.2+spec-1.1.0
toml_write-0.1.2
tracing-0.1.44
tracing-attributes-0.1.31
tracing-core-0.1.36
tracing-log-0.2.0
tracing-subscriber-0.3.23
twox-hash-1.6.3
twox-hash-2.1.2
typenum-1.20.0
ucd-trie-0.1.7
uds_windows-1.2.1
unicase-2.9.0
unicode-ident-1.0.24
unicode-segmentation-1.13.2
unicode-truncate-1.1.0
unicode-truncate-2.0.1
unicode-width-0.1.14
unicode-width-0.2.0
unicode-xid-0.2.6
utf8parse-0.2.2
uuid-1.23.1
valuable-0.1.1
vergen-8.3.2
version_check-0.9.5
version-compare-0.1.1
vsprintf-2.0.0
vtparse-0.6.2
walkdir-2.5.0
wasi-0.11.1+wasi-snapshot-preview1
wasip2-1.0.3+wasi-0.2.9
wasip3-0.4.0+wasi-0.3.0-rc-2026-01-06
wasm-bindgen-0.2.120
wasm-bindgen-macro-0.2.120
wasm-bindgen-macro-support-0.2.120
wasm-bindgen-shared-0.2.120
wasm-encoder-0.244.0
wasm-metadata-0.244.0
wasmparser-0.244.0
web-sys-0.3.97
weezl-0.1.12
wezterm-bidi-0.2.3
wezterm-blob-leases-0.1.1
wezterm-color-types-0.3.0
wezterm-dynamic-0.2.1
wezterm-dynamic-derive-0.1.1
wezterm-input-types-0.1.0
which-4.4.2
widestring-1.2.1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.11
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.61.3
windows_aarch64_gnullvm-0.48.5
windows_aarch64_gnullvm-0.52.6
windows_aarch64_gnullvm-0.53.1
windows_aarch64_msvc-0.48.5
windows_aarch64_msvc-0.52.6
windows_aarch64_msvc-0.53.1
windows-collections-0.2.0
windows-core-0.61.2
windows-core-0.62.2
windows-future-0.2.1
windows_i686_gnu-0.48.5
windows_i686_gnu-0.52.6
windows_i686_gnu-0.53.1
windows_i686_gnullvm-0.52.6
windows_i686_gnullvm-0.53.1
windows_i686_msvc-0.48.5
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
windows-sys-0.48.0
windows-sys-0.59.0
windows-sys-0.60.2
windows-sys-0.61.2
windows-targets-0.48.5
windows-targets-0.52.6
windows-targets-0.53.5
windows-threading-0.1.0
windows_x86_64_gnu-0.48.5
windows_x86_64_gnu-0.52.6
windows_x86_64_gnu-0.53.1
windows_x86_64_gnullvm-0.48.5
windows_x86_64_gnullvm-0.52.6
windows_x86_64_gnullvm-0.53.1
windows_x86_64_msvc-0.48.5
windows_x86_64_msvc-0.52.6
windows_x86_64_msvc-0.53.1
winnow-0.7.15
winnow-1.0.2
wit-bindgen-0.51.0
wit-bindgen-0.57.1
wit-bindgen-core-0.51.0
wit-bindgen-rust-0.51.0
wit-bindgen-rust-macro-0.51.0
wit-component-0.244.0
wit-parser-0.244.0
wrapcenum-derive-0.4.1
wyz-0.5.1
x11rb-0.13.2
x11rb-protocol-0.13.2
xattr-1.6.1
xdg-2.5.2
xi-unicode-0.3.0
zbus-5.15.0
zbus_macros-5.15.0
zbus_names-4.3.2
zerocopy-0.8.48
zerocopy-derive-0.8.48
zmij-1.0.21
zune-core-0.5.1
zune-jpeg-0.5.15
zvariant-5.11.0
zvariant_derive-5.11.0
zvariant_utils-3.3.1
"

# Generally speaking the llvm eclasses make things worst when two llvm slots are required.
inherit abseil-cpp cargo linux-info protobuf

KEYWORDS="~amd64"
SRC_URI="
$(cargo_crate_uris ${CRATES})
https://github.com/sched-ext/scx/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

DESCRIPTION="sched_ext schedulers and tools"
HOMEPAGE="https://github.com/sched-ext/scx"
LICENSE="GPL-2"
# Dependent crate licenses
LICENSE+="
	Apache-2.0
	BSD
	BSD-2
	CC0-1.0
	ISC
	MIT
	MPL-2.0
	Unicode-3.0
	ZLIB
"
RESTRICT="mirror" # Speed up downloads
SLOT="0"
IUSE+="
${LLVM_COMPAT[@]/#/llvm_slot_}
+lto
ebuild_revision_10
"
# Both LLVM slots are required as discussed above.
REQUIRED_USE+="
	llvm_slot_19
	llvm_slot_21
	|| (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
"
DEPEND="
	>=dev-libs/libbpf-1.2.2:=
	dev-libs/libbpf:=
	sys-libs/libseccomp:=
	virtual/libelf:=
	virtual/zlib:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=dev-util/bpftool-7.5.0
	app-misc/jq
	|| (
		(
			dev-cpp/abseil-cpp:20220623[llvm_slot_19?]
			dev-libs/protobuf:3/3.21[llvm_slot_19?,protoc(+)]
		)
		(
			dev-cpp/abseil-cpp:20250512[llvm_slot_19?]
			dev-libs/protobuf:6/6.33[llvm_slot_19?,protoc(+)]
		)
	)
	virtual/pkgconfig:*
	llvm_slot_19? (
		llvm-core/clang:19=[llvm_targets_BPF(-)]
		llvm-core/llvm:19=[llvm_targets_BPF(-)]
	)
	llvm_slot_21? (
		llvm-core/clang:21=[llvm_targets_BPF(-)]
		llvm-core/llvm:21=[llvm_targets_BPF(-)]
		|| (
			dev-lang/rust:1.94.1
			dev-lang/rust-bin:1.94.1
		)
	)
"
PDEPEND="
	~sys-kernel/scx-loader-${PV}
"
CONFIG_CHECK="
	~BPF
	~BPF_EVENTS
	~BPF_JIT
	~BPF_JIT_ALWAYS_ON
	~BPF_JIT_DEFAULT_ON
	~BPF_SYSCALL
	~DEBUG_INFO_BTF
	~FTRACE
	~KALLSYMS_ALL
	~SCHED_CLASS_EXT
"

QA_PREBUILT="/usr/bin/vmlinux_docify"
PATCHES=(
	# Made obsolete by rebasing upstream, can be dropped in 1.1.1
	"${FILESDIR}/${P}-scx_cake-musl-fix.patch"

	"${FILESDIR}/${PN}-1.0.20-llvm-19.patch"
)

pkg_setup() {
	linux-info_pkg_setup

	# Sanitize and manually add to avoid llvm*.eclass side-effects.
	PATH=$(echo "${PATH}" | tr ":" "\n" | sed -e "\|/usr/lib/llvm/|d" | tr "\n" ":")
	PATH=$(echo "${PATH}" | sed -e "s|/opt/bin:|/opt/bin:/usr/lib/llvm/19/bin:|g")
	export PATH=$(echo "${PATH}" | sed -e "s|/opt/bin:|/opt/bin:/usr/lib/llvm/21/bin:|g")
	export LLVM_SLOT="21"
einfo "PATH:  ${PATH}"
einfo "LLVM_SLOT:  ${LLVM_SLOT}"

	rust_pkg_setup

	[[ -z "${RUSTC}" ]] && die "RUSTC is not defined"
	"${RUSTC}" --version || die
}

_lockfile_gen_unpack() {
	unpack "${P}.tar.gz"
	cd "${S}" || die
einfo "Generating lockfile"
	rm Cargo.lock
	cargo generate-lockfile || die "Failed to update Cargo.lock"
	die
}

_production_unpack() {
	unpack "${P}.tar.gz"
	cargo_src_unpack

einfo "Replacing with updated Cargo.lock"
	cp -aT "${FILESDIR}/${PV}" "${S}" || die # This line must go after cargo_src_unpack().
}

src_unpack() {
	unpack ${A}
#	die
	if [[ "${GENERATE_LOCKFILE}" == "1" ]] ; then
		_lockfile_gen_unpack
	else
		_production_unpack
	fi
}

src_configure() {
	# Reduce trashing
	export CARGO_BUILD_JOBS=1

	if has_version "dev-libs/protobuf:6/6.33" ; then
		ABSEIL_CPP_SLOT="20250512"
		PROTOBUF_CPP_SLOT="6"
	elif has_version "dev-libs/protobuf:3/3.21" ; then
		ABSEIL_CPP_SLOT="20220623"
		PROTOBUF_CPP_SLOT="3"
	fi
	abseil-cpp_src_configure
	protobuf_src_configure
	cargo_src_configure
}

get_olast() {
	local olast=$(echo "${CFLAGS}" \
		| grep -o -E -e "-O(0|1|z|s|2|3|4|fast)" \
		| tr " " "\n" \
		| tail -n 1)
	echo "${olast}"
}

# @FUNCTION: cargo_src_compile
# @DESCRIPTION:
# Build the package using cargo build.
_cargo_src_compile() {
einfo "Building Rust schedulers"
	debug-print-function ${FUNCNAME} "$@"

	#_cargo_check_initialized

	set -- "${CARGO}" build ${ECARGO_ARGS[@]} "$@"
	einfo "${@}"
	cargo_env "${@}" || die "cargo build failed"
}

src_compile() {
einfo "CC:  ${CC}"
einfo "CXX:  ${CXX}"
einfo "CPP:  ${CPP}"
einfo "CFLAGS:  ${CFLAGS}"
einfo "CXXFLAGS:  ${CXXFLAGS}"
einfo "LDFLAGS:  ${LDFLAGS}"
einfo "LD:  ${LD}"
einfo "PATH:  ${PATH}"
	local myrustconf=()
	if use lto ; then
		myrustconf+=(
			--profile release
		)
	else
		myrustconf+=(
			--profile release-fast
		)
	fi

	local olast=$(get_olast)
	if [[ "${olast}" =~ ("-O3"|"-O4"|"-Ofast") ]] ; then
		RUSTFLAGS+=" -C opt-level=3"
	elif [[ "${olast}" == "-Os" ]] ; then
		RUSTFLAGS+=" -C opt-level=s"
	elif [[ "${olast}" == "-Oz" ]] ; then
		RUSTFLAGS+=" -C opt-level=z"
	elif [[ "${olast}" == "-O2" ]] ; then
		RUSTFLAGS+=" -C opt-level=2"
	elif [[ "${olast}" == "-O1" ]] ; then
		RUSTFLAGS+=" -C opt-level=1"
	elif [[ "${olast}" == "-O0" ]] ; then
		RUSTFLAGS+=" -C opt-level=0"
	else
	# Upstream default at -O3
		:
	fi
	export RUSTFLAGS

	local -x BPF_CLANG="clang-${LLVM_SLOT}"
	_cargo_src_compile ${myrustconf[@]}
}

src_test() {
	# Skip broken tests in scx_mitosis and scx_utils
	# Upstream: https://github.com/sched-ext/scx/issues/3418
	cargo_src_test -- \
		--skip cell_manager::tests::test_borrowable_cpumasks_respects_cpuset \
		--skip cell_manager::tests::test_cpuset_parsing_from_file \
		--skip cell_manager::tests::test_deficit_all_cells_exceed_target \
		--skip cell_manager::tests::test_symmetric_pairwise_overlap_produces_equal_cells \
		--skip cpumask::tests::test_to_cpulist_roundtrip
}

src_install() {
einfo "Installing schedulers"
	local configuration=$(usex debug "debug" "release")
	local sched
	for sched in "scheds/rust/scx_"* ; do
einfo "Installing ${sched#scheds/rust/}"
		dobin "target/"*"/${configuration}/${sched#scheds/rust}"
	done

einfo "Installing tools"
	dobin "target/"*"/${configuration}/"{"scx"{"cash","top"},"vmlinux_docify"}

	dodoc "README.md"

	local readme readme_name
	for readme in "scheds/rust/"*"/README.md" "./rust/"*"/README.md" ; do
		[[ -e "${readme}" ]] || continue
		readme_name="${readme#*/rust/}"
		readme_name="${readme_name#*/c/}"
		readme_name="${readme_name%/README.md}"
		newdoc "${readme}" "${readme_name}.md"
	done
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.0.20 (INTERACTIVE, 20260222)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.1.0 (INTERACTIVE, 20260511)
# scx_lavd load: passed
# scx_lavd used: passed
#
# Verification:
# ps -aux | grep scx_lavd
# cat /sys/kernel/sched_ext/state
# cat /sys/kernel/sched_ext/root/ops
# scx_lavd --monitor 5
#
# Contents of /etc/scx_loader/config.toml
# default_sched = "scx_lavd"
# default_mode = "Auto"
# [scheds.'scx_lavd']
# auto_mode = ["--performance"]
#
