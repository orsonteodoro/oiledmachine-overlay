# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

# For requirements, see https://github.com/sched-ext/scx/tree/v1.0.20?tab=readme-ov-file#build--install

# AL2026-01-01:  Rust 1.93.0, LLVM 21.1.8, Protobuf 6.33.1-3
# C2026-02 (Native):  Rust 1.93.0, LLVM 21.1.8, Protobuf 6.33.1
# C2026-02 (Frawhide):  Rust 1.93.1, LLVM 21.1.8, Protobuf 3.19.6
# C2026-02 (F44):  Rust 1.93.1, LLVM 21.1.8, Protobuf 3.19.6
# C2026-02 (F43):  Rust 1.93.0, LLVM 21.1.8, Protobuf 3.19.6
# C2026-02 (F42):  Rust 1.93.0, LLVM 21.1.8, Protobuf 3.19.6
# G23:  Rust 1.92.0, LLVM 21.1.8, Protobuf 6.31.1
# U24:  Rust 1.74.1, 1.75.0 (default), 1.76.0, 1.77.2, 1.78.0, 1.79.0, 1.80.1, 1.81.0, 1.82.0, 1.83.0, 1.84.1, 1.85.1, 1.89.0; LLVM 14-19 (18 default), Protobuf 3.21.12
# U24 (CI):  Rust 1.95.0, LLVM 19, Protobuf 3.21.12
# N25.11:  Rust 1.91.1, LLVM 21.1.7, Protobuf 6.32.1

GENERATE_LOCKFILE=0
LLVM_COMPAT=( {19..22} ) # Only U24 LTS supported for this ebuild fork
RUST_MIN_VER="1.82.0"
DISABLED_CRATES="
scx_arena_selftests-1.0.7
scx_bpf_unittests-0.1.6
scx_mitosis-0.0.17
scx_wd40-1.0.20
vmlinux_docify-0.1.9
xtask-0.1.4
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
anstream-0.6.21
anstyle-1.0.13
anstyle-parse-0.2.7
anstyle-query-1.1.5
anstyle-wincon-3.0.11
anyhow-1.0.102
arrayvec-0.7.6
async-broadcast-0.7.2
async-channel-2.5.0
async-executor-1.14.0
async-io-2.6.0
async-lock-3.4.2
async-process-2.5.0
async-recursion-1.1.1
async-signal-0.2.13
async-task-4.7.1
async-trait-0.1.89
atomic-waker-1.1.2
autocfg-1.5.0
backtrace-0.3.76
below-common-0.9.0
bindgen-0.63.0
bindgen-0.72.1
bitflags-1.3.2
bitflags-2.11.0
bitvec-1.0.1
blazesym-0.2.3
block2-0.6.2
blocking-1.6.2
buddy_system_allocator-0.11.0
bumpalo-3.20.2
byteorder-1.5.0
bytes-1.11.1
camino-1.2.2
cargo_metadata-0.18.1
cargo_metadata-0.19.2
cargo_metadata-0.23.1
cargo-platform-0.1.9
cargo-platform-0.3.2
cassowary-0.3.0
cast-0.3.0
castaway-0.2.4
cc-1.2.56
cexpr-0.6.0
cfg_aliases-0.2.1
cfg-if-1.0.4
cgroupfs-0.9.0
chrono-0.4.43
ciborium-0.2.2
ciborium-io-0.2.2
ciborium-ll-0.2.2
clang-sys-1.8.1
clap-4.5.60
clap_builder-4.5.60
clap_complete-4.5.66
clap_derive-4.5.55
clap_lex-1.0.0
clap_main-0.2.9
clap-num-1.2.0
colorchoice-1.0.4
colored-3.1.1
combinations-0.1.0
compact_str-0.8.1
concurrent-queue-2.5.0
const_format-0.2.35
const_format_proc_macros-0.2.34
convert_case-0.6.0
core-foundation-sys-0.8.7
cpp_demangle-0.5.1
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
crossterm_winapi-0.9.1
crunchy-0.2.4
csv-1.4.0
csv-core-0.1.13
ctrlc-3.5.1
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
deranged-0.5.8
dispatch2-0.3.0
either-1.15.0
encoding_rs-0.8.35
endi-1.1.1
enumflags2-0.7.12
enumflags2_derive-0.7.12
enum-map-2.7.3
enum-map-derive-0.17.0
enumset-1.1.10
enumset_derive-0.14.0
equivalent-1.0.2
erased-serde-0.3.31
errno-0.3.14
event-listener-5.4.1
event-listener-strategy-0.5.4
fallible-iterator-0.3.0
fastrand-2.3.0
fb_procfs-0.7.1
filetime-0.2.27
find-msvc-tools-0.1.9
flate2-1.1.9
fnv-1.0.7
foldhash-0.1.5
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
getrandom-0.2.17
getrandom-0.3.4
getrandom-0.4.1
gimli-0.32.3
glob-0.3.3
gpoint-0.2.1
half-2.7.1
hashbrown-0.15.5
hashbrown-0.16.1
heck-0.5.0
hermit-abi-0.3.9
hermit-abi-0.5.2
hex-0.4.3
home-0.5.12
humantime-2.3.0
iana-time-zone-0.1.65
iana-time-zone-haiku-0.1.2
id-arena-2.3.0
ident_case-1.0.1
include_dir-0.7.4
include_dir_macros-0.7.4
indexmap-2.13.0
indoc-2.0.7
inotify-0.11.0
inotify-sys-0.1.5
instability-0.3.11
io-lifetimes-1.0.11
is-terminal-0.4.17
is_terminal_polyfill-1.70.2
itertools-0.10.5
itertools-0.13.0
itoa-1.0.17
js-sys-0.3.88
lazycell-1.3.0
lazy_static-1.5.0
leb128fmt-0.1.0
libbpf-cargo-0.26.0-beta.1
libbpf-rs-0.26.0-beta.1
libbpf-sys-1.6.1+v1.6.1
libc-0.2.182
libloading-0.8.9
libredox-0.1.12
linux-raw-sys-0.11.0
linux-raw-sys-0.1.4
linux-raw-sys-0.4.15
lock_api-0.4.14
log-0.4.29
log-panics-2.1.0
lru-0.12.5
maplit-1.0.2
matchers-0.2.0
memchr-2.8.0
memmap2-0.9.10
memoffset-0.6.5
memoffset-0.9.1
minimal-lexical-0.2.1
miniz_oxide-0.8.9
miniz_oxide-0.9.0
mio-0.8.11
mio-1.1.1
nix-0.25.1
nix-0.29.0
nix-0.30.1
nom-7.1.3
ntapi-0.4.3
nu-ansi-term-0.50.3
num-0.4.3
num-bigint-0.4.6
num-complex-0.4.6
num-conv-0.2.0
num_cpus-1.17.0
num-format-0.4.4
num-format-windows-0.4.4
num-integer-0.1.46
num-iter-0.1.45
num-rational-0.4.2
num_threads-0.1.7
num-traits-0.2.19
nvml-wrapper-0.11.0
nvml-wrapper-sys-0.9.0
objc2-0.6.3
objc2-core-foundation-0.3.2
objc2-encode-4.1.0
objc2-io-kit-0.3.2
object-0.36.7
object-0.37.3
once_cell-1.21.3
once_cell_polyfill-1.70.2
oorandom-11.1.5
openat-0.1.21
ordered-float-3.9.2
ordered-stream-0.2.0
owning_ref-0.4.1
parking-2.2.1
parking_lot-0.12.5
parking_lot_core-0.9.12
paste-1.0.15
peeking_take_while-0.1.2
perfetto_protos-0.51.1
perf-event-open-sys-5.0.0
pin-project-lite-0.2.16
pin-utils-0.1.0
piper-0.2.4
pkg-config-0.3.32
plain-0.2.3
plotters-0.3.7
plotters-backend-0.3.7
plotters-svg-0.3.7
polling-3.11.0
powerfmt-0.2.0
ppv-lite86-0.2.21
prettyplease-0.2.37
procfs-0.15.1
procfs-0.18.0
procfs-core-0.18.0
proc-macro2-1.0.106
proc-macro-crate-3.4.0
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
quote-1.0.44
radium-0.7.0
rand-0.8.5
rand_chacha-0.3.1
rand_core-0.6.4
ratatui-0.29.0
rayon-1.11.0
rayon-core-1.13.0
redox_syscall-0.5.18
redox_syscall-0.7.1
r-efi-5.3.0
regex-1.12.3
regex-automata-0.4.14
regex-syntax-0.6.29
regex-syntax-0.8.9
rlimit-0.10.2
rustc-demangle-0.1.27
rustc-hash-1.1.0
rustc-hash-2.1.1
rustix-0.36.17
rustix-0.38.44
rustix-1.1.3
rustversion-1.0.22
ruzstd-0.7.3
ruzstd-0.8.2
ryu-1.0.23
same-file-1.0.6
scopeguard-1.2.0
scx_arena-0.1.4
scx_beerland-1.0.5
scx_bpf_compat-1.0.20
scx_bpfland-1.0.20
scx_cargo-1.0.27
scxcash-0.1.5
scx_chaos-1.0.23
scx_cosmos-1.0.7
scx_flash-1.0.18
scx_lavd-1.0.21
scx_layered-1.0.23
scx_p2dq-1.0.25
scx_raw_pmu-0.1.4
scx_rlfifo-1.0.20
scx_rustland-1.0.20
scx_rustland_core-2.4.10
scx_rusty-1.0.20
scx_stats-1.0.22
scx_stats_derive-1.0.21
scx_tickless-1.0.11
scxtop-1.0.22
scx_userspace_arena-1.0.20
scx_utils-1.0.26
seccomp-0.1.2
seccomp-sys-0.1.3
semver-1.0.27
serde-1.0.228
serde_core-1.0.228
serde_derive-1.0.228
serde_json-1.0.149
serde_repr-0.1.20
serde_spanned-0.6.9
sharded-slab-0.1.7
shlex-1.3.0
signal-hook-0.3.18
signal-hook-mio-0.2.5
signal-hook-registry-1.4.8
simd-adler32-0.3.8
simplelog-0.12.2
simple_logger-5.2.0
slab-0.4.12
slog-2.8.2
slog-term-2.9.2
smallvec-1.15.1
smartstring-1.0.1
socket2-0.6.2
sorted-vec-0.8.10
sscanf-0.4.4
sscanf_macro-0.4.4
stable_deref_trait-1.2.1
static_assertions-1.1.0
strsim-0.11.1
strum-0.26.3
strum_macros-0.26.4
syn-1.0.109
syn-2.0.117
sysinfo-0.35.2
tap-1.0.1
tar-0.4.44
tempfile-3.25.0
term-1.2.1
termcolor-1.4.1
terminal_size-0.4.3
thiserror-1.0.69
thiserror-2.0.18
thiserror-impl-1.0.69
thiserror-impl-2.0.18
thread_local-1.1.9
threadpool-1.8.1
time-0.3.47
time-core-0.1.8
time-macros-0.2.27
tinytemplate-1.2.1
tokio-1.49.0
tokio-macros-2.6.0
tokio-util-0.7.18
toml-0.8.23
toml_datetime-0.6.11
toml_datetime-0.7.5+spec-1.1.0
toml_edit-0.22.27
toml_edit-0.23.10+spec-1.0.0
toml_parser-1.0.9+spec-1.1.0
toml_write-0.1.2
tracing-0.1.44
tracing-attributes-0.1.31
tracing-core-0.1.36
tracing-log-0.2.0
tracing-subscriber-0.3.22
twox-hash-1.6.3
twox-hash-2.1.2
uds_windows-1.1.0
unicase-2.9.0
unicode-ident-1.0.24
unicode-segmentation-1.12.0
unicode-truncate-1.1.0
unicode-width-0.1.14
unicode-width-0.2.0
unicode-xid-0.2.6
utf8parse-0.2.2
uuid-1.21.0
valuable-0.1.1
vergen-8.3.2
version_check-0.9.5
version-compare-0.1.1
vsprintf-2.0.0
walkdir-2.5.0
wasi-0.11.1+wasi-snapshot-preview1
wasip2-1.0.2+wasi-0.2.9
wasip3-0.4.0+wasi-0.3.0-rc-2026-01-06
wasm-bindgen-0.2.111
wasm-bindgen-macro-0.2.111
wasm-bindgen-macro-support-0.2.111
wasm-bindgen-shared-0.2.111
wasm-encoder-0.244.0
wasm-metadata-0.244.0
wasmparser-0.244.0
web-sys-0.3.88
which-4.4.2
widestring-1.2.1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.11
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.61.3
windows_aarch64_gnullvm-0.42.2
windows_aarch64_gnullvm-0.48.5
windows_aarch64_gnullvm-0.52.6
windows_aarch64_gnullvm-0.53.1
windows_aarch64_msvc-0.42.2
windows_aarch64_msvc-0.48.5
windows_aarch64_msvc-0.52.6
windows_aarch64_msvc-0.53.1
windows-collections-0.2.0
windows-core-0.61.2
windows-core-0.62.2
windows-future-0.2.1
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
windows-sys-0.48.0
windows-sys-0.59.0
windows-sys-0.60.2
windows-sys-0.61.2
windows-targets-0.42.2
windows-targets-0.48.5
windows-targets-0.52.6
windows-targets-0.53.5
windows-threading-0.1.0
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
wit-bindgen-core-0.51.0
wit-bindgen-rust-0.51.0
wit-bindgen-rust-macro-0.51.0
wit-component-0.244.0
wit-parser-0.244.0
wrapcenum-derive-0.4.1
wyz-0.5.1
xattr-1.6.1
xdg-2.5.2
xi-unicode-0.3.0
zbus-5.13.2
zbus_macros-5.13.2
zbus_names-4.3.1
zerocopy-0.8.39
zerocopy-derive-0.8.39
zmij-1.0.21
zvariant-5.9.2
zvariant_derive-5.9.2
zvariant_utils-3.3.0
"

inherit abseil-cpp cargo llvm-r2 linux-info protobuf

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
IUSE+=" +lto"
REQUIRED_USE+="
	llvm_slot_19
	^^ (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
"
DEPEND="
	>=dev-libs/libbpf-1.2.2
	dev-libs/libbpf:=
	sys-libs/libseccomp
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
	dev-cpp/abseil-cpp:=
	dev-libs/protobuf:=
	virtual/pkgconfig
	llvm_slot_19? (
		llvm-core/clang:19[llvm_targets_BPF(-)]
		llvm-core/clang:=
		|| (
			=dav-lang/rust-1.86*
			=dav-lang/rust-1.85*
			=dav-lang/rust-1.84*
			=dav-lang/rust-1.83*
			=dav-lang/rust-1.82*
			=dav-lang/rust-bin-1.86*
			=dav-lang/rust-bin-1.85*
			=dav-lang/rust-bin-1.84*
			=dav-lang/rust-bin-1.83*
			=dav-lang/rust-bin-1.82*
		)
	)
	llvm_slot_20? (
		llvm-core/clang:20[llvm_targets_BPF(-)]
		llvm-core/clang:=
		|| (
			=dav-lang/rust-1.90*
			=dav-lang/rust-1.89*
			=dav-lang/rust-1.88*
			=dav-lang/rust-1.87*
			=dav-lang/rust-bin-1.90*
			=dav-lang/rust-bin-1.89*
			=dav-lang/rust-bin-1.88*
			=dav-lang/rust-bin-1.87*
		)
	)
	llvm_slot_21? (
		llvm-core/clang:21[llvm_targets_BPF(-)]
		llvm-core/clang:=
		|| (
			=dav-lang/rust-1.93*
			=dav-lang/rust-1.92*
			=dav-lang/rust-1.91*
			=dav-lang/rust-bin-1.93*
			=dav-lang/rust-bin-1.92*
			=dav-lang/rust-bin-1.91*
		)
	)
	llvm_slot_22? (
		llvm-core/clang:22[llvm_targets_BPF(-)]
		llvm-core/clang:=
		|| (
			=dav-lang/rust-9999*
			=dav-lang/rust-bin-9999*
		)
	)
	|| (
		dav-lang/rust:=
		dav-lang/rust-bin:=
	)
"
PDEPEND="
	~sys-kernel/scx-loader-${PV}
	sys-kernel/scx-loader:=
"
CONFIG_CHECK="
	~BPF
	~BPF_EVENTS
	~BPF_JIT
	~BPF_SYSCALL
	~DEBUG_INFO_BTF
	~FTRACE
	~SCHED_CLASS_EXT
"

QA_PREBUILT="/usr/bin/vmlinux_docify"
PATCHES=(
	"${FILESDIR}/${PN}-1.0.20-llvm-19.patch"
)

pkg_setup() {
	linux-info_pkg_setup
	llvm-r2_pkg_setup
	rust_pkg_setup

	"${RUSTC}" --version \
		| cut -f 2 -d " " \
		| grep -q -e "nightly" \
		|| die
	local is_nightly=$?
	is_nightly=$(( ${is_nightly} ? 0 : 1 ))

	if use llvm_slot_22 ; then
		local rust_nightly_date=$("${RUSTC}" --version \
			| cut -f 4 -d " " \
			| sed -e "s|[)]||g" | sed -e "s|-||g")
		if ver_test "${rust_nightly_date}" "-lt" "20260127" ; then
	# From commit history of .gitmodules
eerror "Update Rust nightly to at least 2026-01-27"
			die
		fi
		if (( ${is_nightly} == 0 )) ; then
eerror "llvm_slot_22 requires Rust nightly"
			die
		fi
	fi
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
	#die
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
	debug-print-function ${FUNCNAME} "$@"

	#_cargo_check_initialized

	set -- "${CARGO}" build ${ECARGO_ARGS[@]} "$@"
	einfo "${@}"
	cargo_env "${@}" || die "cargo build failed"
}

src_compile() {
einfo "Building Rust schedulers"
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

	_cargo_src_compile ${myrustconf[@]}

einfo "Building C schedulers"
	emake BPF_CLANG="$(get_llvm_prefix)/bin/clang"
}

src_install() {
	local configuration=$(usex debug "debug" "release")
einfo "Installing rust schedulers"
	local sched
	for sched in "scheds/rust/scx_"* ; do
einfo "Installing ${sched#scheds/rust/}"
		dobin "target/"*"/${configuration}/${sched#scheds/rust}"
	done

einfo "Installing C schedulers"
	emake INSTALL_DIR="${ED}/usr/bin" install

einfo "Installing tools"
	dobin "target/"*"/${configuration}/"{"scx"{"cash","top"},"vmlinux_docify"}

	dodoc "README.md"

	local readme readme_name
	for readme in "scheds/"{"rust","c"}"/"*"/README.md" "./rust/"*"/README.md" ; do
		[[ -e "${readme}" ]] || continue
		readme_name="${readme#*/rust/}"
		readme_name="${readme_name#*/c/}"
		readme_name="${readme_name%/README.md}"
		newdoc "${readme}" "${readme_name}.md"
	done
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.0.20 (INTERACTIVE, 20260222)
# scx_lavd load: passed
# scx_lavd used: passed
# verification:
# ps -aux | grep scx_lavd
# cat /sys/kernel/sched_ext/state
# cat /sys/kernel/sched_ext/root/ops
