# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

# This ebuild uses a patch that was based on an AI generated code fix.

# For requirements, see https://github.com/sched-ext/scx/tree/v1.1.4?tab=readme-ov-file#build--install

# AL2026-01-01:  Rust 1.93.0, LLVM 21.1.8, Protobuf 6.33.1-3
# C2026-02 (Native):  Rust 1.93.0, LLVM 21.1.8, Protobuf 6.33.1
# C2026-02 (Frawhide):  Rust 1.93.1, LLVM 21.1.8, Protobuf 3.19.6
# C2026-02 (F44):  Rust 1.93.1, LLVM 21.1.8, Protobuf 3.19.6
# C2026-02 (F43):  Rust 1.93.0, LLVM 21.1.8, Protobuf 3.19.6
# C2026-02 (F42):  Rust 1.93.0, LLVM 21.1.8, Protobuf 3.19.6
# G:  Rust 1.98.1, LLVM 22.1.8, Protobuf 6.31.1
# G~:  Rust 1.99.0, LLVM 23.1.6, Protobuf 7.34.1
# U24:  Rust 1.74.1, 1.75.0 (default), 1.76.0, 1.77.2, 1.78.0, 1.79.0, 1.80.1, 1.81.0, 1.82.0, 1.83.0, 1.84.1, 1.85.1, 1.89.0; LLVM 14-19 (18 default), Protobuf 3.21.12
# U24 (CI):  Rust 1.100.0, LLVM 22, Protobuf 3.21.12
# N25.11:  Rust 1.99.1, LLVM 21.1.8, Protobuf 7.36.2

# Upstream uses LLVM 22, Rust 1.100.0, protobuf-c 3.21.12.
# Both LLVM 22 for protobuf-cpp, and LLVM 22 for project are required.
# Ideally both should be aligned but not possible, but the package will still build.
# LLVM 22 - Required for protobuf-cpp 3.21.12 (LTS on D12/U24).
#           Required for Linux kernel built with Clang 19 (LTS on D13)
# LLVM 23 - Required for Rust 1.100.1 (Previously the same as CI testing for lavd)

inherit secure-version

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data" # For aws-lc-sys, AI said that it uses IPC, untrusted-data=no, sensitive-data=yes.
GENERATE_LOCKFILE=0
LLVM_SLOT_PROTOBUF=22 # Same slot as dev-libs/protobuf3/3.21
LLVM_SLOT_SCX=23 # Same slot used in Rust 1.100.0
LLVM_COMPAT=( ${LLVM_SLOT_PROTOBUF} ${LLVM_SLOT_SCX} )
# RUST_*_VER will be pinned to meet cargo lockfile requirements.
RUST_MAX_VER="${RUST_LLVM_23_PV}" # LLVM 23.1
RUST_MIN_VER="${RUST_LLVM_23_PV}" # LLVM 23.1
RUSTFLAGS_HARDENED_USE_CASES="security-critical sensitive-data"

DISABLED_CRATES="
scx_arena_libarena_selftests-1.1.4
scx_arena_selftests-1.1.4
scx_eevdf-1.1.4
scx_mavd-1.1.4
scx_mitosis-1.1.4
scx_nitosis-1.1.4
vmlinux_docify-1.1.4
xtask-1.1.4
"

CRATES="
addr2line-0.27.1
adler2-2.0.1
affinity-0.1.2
ahash-0.8.12
aho-corasick-1.1.5
alloca-0.4.0
allocator-api2-0.2.21
android_system_properties-0.1.6
anes-0.1.6
anstream-1.0.0
anstyle-1.0.14
anstyle-parse-1.0.0
anstyle-query-1.1.5
anstyle-wincon-3.0.11
anyhow-1.0.104
approx-0.5.1
ar_archive_writer-0.5.5
arc-swap-1.9.5
arrayvec-0.7.8
ascii-1.1.0
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
atomic-polyfill-1.0.3
atomic-waker-1.1.2
autocfg-1.5.1
aws-lc-rs-1.19.0
aws-lc-sys-0.47.0
backtrace-0.3.77
base64-0.22.1
base64-0.23.1
below-common-0.9.0
bindgen-0.63.0
bindgen-0.72.1
bindgen-0.73.2
bitflags-1.3.2
bitflags-2.13.2
bit-set-0.5.3
bit-vec-0.6.3
bitvec-1.1.1
blazesym-0.2.7
block2-0.6.2
block-buffer-0.10.4
block-buffer-0.12.1
blocking-1.7.0
bstr-1.14.0
btf-rs-2.0.1
btf-rs-derive-2.0.1
buddy_system_allocator-0.13.0
bumpalo-3.20.4
by_address-1.2.1
byteorder-1.5.0
bytes-1.12.2
camino-1.2.6
cargo_metadata-0.19.2
cargo_metadata-0.23.1
cargo-platform-0.1.9
cargo-platform-0.3.3
cast-0.3.0
castaway-0.2.4
cc-1.11.2
cexpr-0.6.0
cfg_aliases-0.2.2
cfg-if-1.0.5
cgroupfs-0.9.0
chacha20-0.10.2
chrono-0.4.45
chunked_transfer-1.5.0
ciborium-0.2.2
ciborium-io-0.2.2
ciborium-ll-0.2.2
clang-sys-1.9.1
clap-4.6.8
clap_builder-4.6.7
clap_complete-4.6.12
clap_derive-4.6.8
clap_lex-1.1.2
clap_main-0.2.9
clap-num-1.2.0
clru-0.6.3
cmake-0.1.58
cobs-0.3.0
colorchoice-1.0.5
colored-3.1.1
combine-4.6.9
comfy-table-7.2.2
compact_str-0.9.1
concurrent-queue-2.5.0
console-0.16.6
const-oid-0.10.3
convert_case-0.10.0
convert_case-0.11.0
core_detect-1.0.0
core-foundation-0.10.1
core-foundation-0.9.4
core-foundation-sys-0.8.7
cpio-0.4.2
cpp_demangle-0.5.1
cpufeatures-0.2.17
cpufeatures-0.3.1
crc32fast-1.5.5
criterion-0.8.2
criterion-plot-0.8.2
critical-section-1.2.0
crossbeam-0.8.5
crossbeam-channel-0.5.17
crossbeam-deque-0.8.8
crossbeam-epoch-0.9.21
crossbeam-queue-0.3.14
crossbeam-utils-0.8.23
crossterm-0.25.0
crossterm-0.28.1
crossterm-0.29.0
crossterm_winapi-0.9.1
crunchy-0.2.4
crypto-common-0.1.7
crypto-common-0.2.2
csscolorparser-0.6.2
csv-1.4.0
csv-core-0.1.13
ctor-1.0.14
ctrlc-3.5.3
cursive-0.20.0
cursive_core-0.3.7
darling-0.20.11
darling-0.21.3
darling-0.24.1
darling_core-0.20.11
darling_core-0.21.3
darling_core-0.24.1
darling_macro-0.20.11
darling_macro-0.21.3
darling_macro-0.24.1
dashmap-6.2.1
defmt-0.3.101
defmt-1.2.0
defmt-macros-1.2.0
defmt-parser-1.1.0
deltae-0.3.2
deranged-0.5.9
derive_more-2.1.1
derive_more-impl-2.1.1
digest-0.10.7
digest-0.11.3
dispatch2-0.3.1
displaydoc-0.2.7
document-features-0.2.12
dunce-1.0.5
either-1.19.0
embedded-io-0.4.0
embedded-io-0.6.1
encode_unicode-1.0.0
encoding_rs-0.8.44
endi-1.1.1
enumflags2-0.7.12
enumflags2_derive-0.7.12
enum-map-2.7.3
enum-map-derive-0.17.0
enumset-1.1.15
enumset_derive-0.15.1
equivalent-1.0.3
erased-serde-0.3.31
errno-0.3.15
euclid-0.22.14
event-listener-5.4.2
event-listener-strategy-0.5.4
fallible-iterator-0.3.0
fancy-regex-0.11.0
faster-hex-0.10.1
fastrand-2.5.0
fb_procfs-0.9.0
filedescriptor-0.8.3
filetime-0.2.30
find_cuda_helper-0.2.0
find-msvc-tools-0.1.15
finl_unicode-1.5.1
fixedbitset-0.4.2
flate2-1.1.11
fnv-1.0.7
foldhash-0.2.0
foreign-types-0.3.2
foreign-types-shared-0.1.1
form_urlencoded-1.2.2
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
generic-array-0.14.7
getrandom-0.2.17
getrandom-0.3.4
getrandom-0.4.3
gimli-0.33.0
gimli-0.34.0
gix-0.83.0
gix-actor-0.41.2
gix-archive-0.32.0
gix-attributes-0.33.2
gix-bitmap-0.3.3
gix-blame-0.13.0
gix-chunk-0.7.3
gix-command-0.9.2
gix-commitgraph-0.37.1
gix-config-0.56.0
gix-config-value-0.18.1
gix-credentials-0.38.2
gix-date-0.15.6
gix-diff-0.63.0
gix-dir-0.25.0
gix-discover-0.51.0
gix-error-0.2.5
gix-features-0.48.1
gix-filter-0.30.0
gix-fs-0.21.2
gix-glob-0.26.1
gix-hash-0.25.1
gix-hashtable-0.15.2
gix-ignore-0.21.1
gix-imara-diff-0.2.5
gix-index-0.51.0
gix-lock-23.0.1
gix-merge-0.16.0
gix-negotiate-0.31.0
gix-object-0.60.0
gix-odb-0.80.0
gix-pack-0.70.0
gix-packetline-0.21.5
gix-path-0.12.6
gix-pathspec-0.18.1
gix-prompt-0.15.1
gix-protocol-0.61.0
gix-quote-0.7.2
gix-ref-0.63.0
gix-refspec-0.41.0
gix-revision-0.45.0
gix-revwalk-0.31.0
gix-sec-0.14.2
gix-shallow-0.12.1
gix-status-0.30.0
gix-submodule-0.30.0
gix-tempfile-23.0.2
gix-trace-0.1.21
gix-transport-0.57.2
gix-traverse-0.57.0
gix-url-0.36.2
gix-utils-0.3.6
gix-validate-0.11.4
gix-worktree-0.52.0
gix-worktree-state-0.30.0
gix-worktree-stream-0.32.0
glob-0.3.4
goblin-0.10.7
gpoint-0.3.0
h2-0.4.20
half-2.7.1
hash32-0.2.1
hash32-0.3.1
hashbrown-0.14.5
hashbrown-0.16.1
hashbrown-0.17.1
heapless-0.7.17
heapless-0.8.0
heck-0.5.0
hermit-abi-0.5.3
hex-0.4.3
home-0.5.12
http-1.5.0
httparse-1.10.1
http-body-1.1.0
http-body-util-0.1.5
httpdate-1.0.3
humantime-2.4.0
hybrid-array-0.4.15
hyper-1.12.0
hyper-rustls-0.27.10
hyper-tls-0.6.0
hyper-util-0.1.21
iana-time-zone-0.1.65
iana-time-zone-haiku-0.1.2
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
include_dir-0.7.4
include_dir_macros-0.7.4
indexmap-2.14.2
indicatif-0.18.6
indoc-2.0.8
inotify-0.11.5
inotify-sys-0.1.8
instability-0.3.14
io-close-0.3.7
ipnet-2.12.2
is-terminal-0.4.17
is_terminal_polyfill-1.70.2
itertools-0.13.0
itertools-0.14.0
itoa-1.0.19
jiff-0.2.46
jiff-core-0.1.8
jiff-static-0.2.46
jiff-tzdb-0.1.10
jiff-tzdb-platform-0.1.3
jni-0.22.4
jni-macros-0.22.4
jni-sys-0.4.1
jni-sys-macros-0.4.1
jobserver-0.1.35
js-sys-0.3.107
kasuari-0.4.13
kstring-2.0.2
ktstr-0.18.0
ktstr-macros-0.18.0
kvm-bindings-0.14.2
kvm-ioctls-0.24.0
lab-0.11.0
lazycell-1.3.0
lazy_static-1.5.1
libarena-rs-0.3.4
libbpf-cargo-0.26.2
libbpf-cargo-0.27.2
libbpf-rs-0.26.2
libbpf-rs-0.27.2
libbpf-sys-1.7.0+v1.7.0
libc-0.2.191
libloading-0.8.9
libm-0.2.16
line-clipping-0.3.8
linkme-0.3.38
linkme-impl-0.3.38
link-section-0.19.4
linktime-proc-macro-0.2.3
linux-loader-0.13.2
linux-raw-sys-0.12.1
linux-raw-sys-0.4.15
litemap-0.8.3
litrs-1.0.1
llama-cpp-2-0.1.161
llama-cpp-sys-2-0.1.161
lock_api-0.4.14
log-0.4.35
log-panics-2.1.0
lru-0.18.5
lru-slab-0.1.3
lz4_flex-0.13.2
lzma-sys-0.1.20
mac_address-1.2.1
maplit-1.0.2
matchers-0.2.0
maybe-async-0.2.11
memchr-2.8.3
memmap2-0.9.12
memmem-0.1.1
memoffset-0.9.1
mime-0.3.18
minimal-lexical-0.2.1
miniz_oxide-0.9.1
mio-0.8.11
mio-1.2.5
multiversion_no_op-1.0.0
native-tls-0.2.18
netlink-packet-core-0.8.2
netlink-packet-generic-0.4.0
netlink-sys-0.8.8
nix-0.29.0
nix-0.31.4
nix-0.32.0
nom-7.1.3
nonblock-0.2.0
nonempty-0.12.0
ntapi-0.4.3
nu-ansi-term-0.50.3
num-0.4.3
num-bigint-0.4.8
num-complex-0.4.6
num-conv-0.2.2
num_cpus-1.17.0
num-derive-0.4.2
num-derive-0.5.1
num-format-0.4.4
num-format-windows-0.4.4
num-integer-0.1.47
num-iter-0.1.46
num-rational-0.4.2
num_threads-0.1.8
numtoa-0.2.4
num-traits-0.2.19
nvml-wrapper-0.12.1
nvml-wrapper-sys-0.9.1
objc2-0.6.5
objc2-core-foundation-0.3.2
objc2-encode-4.1.0
objc2-io-kit-0.3.2
object-0.39.1
object-0.40.0
once_cell-1.21.4
once_cell_polyfill-1.70.2
oorandom-11.1.5
openat-0.1.21
openssl-0.10.82
openssl-macros-0.1.1
openssl-probe-0.2.2
openssl-sys-0.9.118
ordered-float-4.6.0
ordered-float-5.5.1
ordered-stream-0.2.0
owning_ref-0.4.1
page_size-0.6.0
palette-0.7.7
palette_derive-0.7.7
palette_math-0.7.7
parking-2.2.1
parking_lot-0.12.5
parking_lot_core-0.9.12
paste-1.0.15
peeking_take_while-0.1.2
percent-encoding-2.3.2
perfetto_protos-0.51.1
perf-event-open-sys-6.0.0
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
pkg-config-0.3.34
plain-0.2.3
plotters-0.3.7
plotters-backend-0.3.7
plotters-svg-0.3.7
polling-3.11.0
portable-atomic-1.15.0
portable-atomic-util-0.2.8
postcard-1.1.3
potential_utf-0.1.6
powerfmt-0.2.1
prettyplease-0.2.37
prettyplease-0.3.0
procfs-0.18.0
procfs-core-0.18.0
proc-macro2-1.0.107
proc-macro-crate-3.5.0
prodash-31.0.1
protobuf-3.7.2
protobuf-codegen-3.7.2
protobuf-parse-3.7.2
protobuf-support-3.7.2
protoc-bin-vendored-3.3.0
protoc-bin-vendored-linux-aarch_64-3.3.0
protoc-bin-vendored-linux-ppcle_64-3.3.0
protoc-bin-vendored-linux-s390_64-3.3.0
protoc-bin-vendored-linux-x86_32-3.3.0
protoc-bin-vendored-linux-x86_64-3.3.0
protoc-bin-vendored-macos-aarch_64-3.3.0
protoc-bin-vendored-macos-x86_64-3.3.0
protoc-bin-vendored-win32-3.3.0
psm-0.1.32
quinn-0.11.12
quinn-proto-0.11.19
quinn-udp-0.5.16
quote-1.0.47
radium-0.7.0
rand-0.10.4
rand-0.8.8
rand_core-0.10.1
rand_core-0.6.4
rand_pcg-0.10.3
ratatui-0.30.2
ratatui-core-0.1.2
ratatui-crossterm-0.1.2
ratatui-macros-0.7.2
ratatui-termina-0.1.0
ratatui-termion-0.1.2
ratatui-termwiz-0.1.2
ratatui-widgets-0.3.2
rayon-1.12.0
rayon-core-1.13.0
redox_syscall-0.5.18
r-efi-5.3.0
r-efi-6.0.0
regex-1.13.2
regex-automata-0.4.19
regex-syntax-0.8.12
reqwest-0.12.28
reqwest-0.13.5
ring-0.17.14
rlimit-0.11.0
rmesg-1.0.26
rustc-demangle-0.1.28
rustc-hash-1.1.0
rustc-hash-2.1.3
rustc_version-0.4.1
rustix-0.38.44
rustix-1.1.6
rustls-0.23.46
rustls-native-certs-0.8.5
rustls-pki-types-1.16.0
rustls-platform-verifier-0.7.1
rustls-platform-verifier-android-0.2.0
rustls-webpki-0.103.17
rustversion-1.0.23
ruzstd-0.8.3
ryu-1.0.23
same-file-1.0.6
schannel-0.1.30
scopeguard-1.2.0
scroll-0.13.0
scroll_derive-0.13.2
scx_arena-1.1.4
scx_beerland-1.1.4
scx_bpf_compat-1.1.4
scx_bpfland-1.1.4
scx_cake-1.2.2
scx_cargo-1.1.4
scx_chaos-1.1.4
scx_characterize-1.1.4
scx_cosmos-1.1.7
scx_flash-1.1.4
scx_flow-4.8.15
scx_forge-1.1.3
scx_forge_agent-1.1.3
scx_lavd-1.1.4
scx_layered-1.1.4
scx_mlfq-1.3.12
scx_p2dq-1.1.4
scx_pandemonium-5.23.1
scx_raw_pmu-1.1.4
scx_rlfifo-1.1.4
scx_rustland-1.1.4
scx_rustland_core-2.4.15
scx_rusty-1.1.4
scx_stats-1.1.4
scx_stats_derive-1.1.4
scx_tickless-1.1.4
scxtop-1.1.4
scx_userspace_arena-1.1.4
scx_utils-1.1.4
seccomp-0.1.2
seccomp-sys-0.1.3
security-framework-3.7.0
security-framework-sys-2.17.0
semver-1.0.28
serde-1.0.229
serde_core-1.0.229
serde_derive-1.0.229
serde_json-1.0.154
serde_path_to_error-0.1.20
serde_repr-0.1.21
serde_spanned-1.1.3
serde_urlencoded-0.7.1
sha1-0.10.7
sha1-checked-0.10.0
sha2-0.10.9
sha2-0.11.1
sharded-slab-0.1.7
shell-words-1.1.1
shlex-1.3.0
shlex-2.0.1
signal-hook-0.3.18
signal-hook-0.4.6
signal-hook-mio-0.2.5
signal-hook-registry-1.4.8
simd-adler32-0.3.10
simd_cesu8-1.2.0
simdutf8-0.1.5
simplelog-0.12.2
simple_logger-5.2.0
siphasher-1.0.4
slab-0.4.12
slog-2.8.2
slog-term-2.9.2
smallvec-1.16.6
smartstring-1.0.1
socket2-0.6.5
sorted-vec-0.8.11
spin-0.9.9
sscanf-0.5.0
sscanf_macro-0.5.0
stable_deref_trait-1.2.1
stacker-0.1.25
static_assertions-1.1.0
streaming-iterator-0.1.9
strsim-0.11.1
strum-0.27.2
strum-0.28.0
strum_macros-0.27.2
strum_macros-0.28.0
subtle-2.6.1
syn-1.0.109
syn-2.0.119
syn-3.0.10
sync_wrapper-1.0.2
synstructure-0.14.0
sysinfo-0.38.4
system-configuration-0.7.0
system-configuration-sys-0.6.0
tap-1.0.1
tar-0.4.46
tempfile-3.27.0
term-1.2.1
termcolor-1.4.1
termina-0.3.3
terminal_size-0.4.4
terminfo-0.9.0
termion-4.0.6
termios-0.3.3
termwiz-0.23.3
thiserror-1.0.69
thiserror-2.0.21
thiserror-impl-1.0.69
thiserror-impl-2.0.21
thread_local-1.1.10
threadpool-1.8.1
tikv-jemallocator-0.6.1
tikv-jemalloc-ctl-0.6.1
tikv-jemalloc-sys-0.6.1+5.3.0-1-ge13ca993e8ccb9ba9847cc330696e02839f328f7
time-0.3.55
time-core-0.1.9
time-macros-0.2.32
tiny_http-0.12.0
tinystr-0.8.5
tinytemplate-1.2.1
tinyvec-1.13.3
tokio-1.54.1
tokio-macros-2.7.2
tokio-native-tls-0.3.1
tokio-rustls-0.26.6
tokio-util-0.7.20
toml-1.2.1+spec-1.1.0
toml_datetime-1.1.3+spec-1.1.0
toml_edit-0.25.19+spec-1.1.0
toml_parser-1.1.5+spec-1.1.0
toml_writer-1.2.0+spec-1.1.0
tower-0.5.3
tower-http-0.6.11
tower-layer-0.3.3
tower-service-0.3.3
tracing-0.1.44
tracing-attributes-0.1.31
tracing-core-0.1.36
tracing-log-0.2.0
tracing-subscriber-0.3.23
tree-sitter-0.26.13
tree-sitter-c-0.24.2
tree-sitter-language-0.1.9
try-lock-0.2.5
twox-hash-2.1.5
typenum-1.20.1
ucd-trie-0.1.8
uds_windows-1.2.1
unicase-2.10.0
unicode-bom-2.0.3
unicode-ident-1.0.27
unicode-normalization-0.1.26
unicode-segmentation-1.13.3
unicode-truncate-2.0.1
unicode-width-0.1.14
unicode-width-0.2.3
unit-prefix-0.5.2
untrusted-0.9.0
url-2.5.8
utf8_iter-1.1.0
utf8parse-0.2.2
utf_types-1.0.0
uuid-1.29.3
valuable-0.1.1
vcpkg-0.2.15
version_check-0.9.5
version-compare-0.2.1
virtio-bindings-0.2.7
virtio-queue-0.17.0
vm-fdt-0.3.0
vm-memory-0.17.1
vmm-sys-util-0.15.0
vm-superio-0.8.2
vsprintf-2.0.0
vtparse-0.6.2
walkdir-2.5.0
want-0.3.2
wasi-0.11.1+wasi-snapshot-preview1
wasip2-1.0.4+wasi-0.2.12
wasm-bindgen-0.2.130
wasm-bindgen-futures-0.4.80
wasm-bindgen-macro-0.2.130
wasm-bindgen-macro-support-0.2.130
wasm-bindgen-shared-0.2.130
webpki-root-certs-1.0.12
web-sys-0.3.107
web-time-1.1.0
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
windows-0.62.2
windows_aarch64_gnullvm-0.48.5
windows_aarch64_gnullvm-0.52.6
windows_aarch64_msvc-0.48.5
windows_aarch64_msvc-0.52.6
windows-collections-0.3.2
windows-core-0.62.2
windows-future-0.3.2
windows_i686_gnu-0.48.5
windows_i686_gnu-0.52.6
windows_i686_gnullvm-0.52.6
windows_i686_msvc-0.48.5
windows_i686_msvc-0.52.6
windows-implement-0.60.2
windows-interface-0.59.3
windows-link-0.2.1
windows-numerics-0.3.1
windows-registry-0.6.1
windows-result-0.4.1
windows-strings-0.5.1
windows-sys-0.48.0
windows-sys-0.52.0
windows-sys-0.59.0
windows-sys-0.61.2
windows-targets-0.48.5
windows-targets-0.52.6
windows-threading-0.2.1
windows_x86_64_gnu-0.48.5
windows_x86_64_gnu-0.52.6
windows_x86_64_gnullvm-0.48.5
windows_x86_64_gnullvm-0.52.6
windows_x86_64_msvc-0.48.5
windows_x86_64_msvc-0.52.6
winnow-1.0.5
wit-bindgen-0.57.1
wrapcenum-derive-0.4.1
writeable-0.6.4
wyz-0.5.1
xattr-1.7.0
xdg-3.0.0
xi-unicode-0.3.0
xz2-0.1.7
yoke-0.8.4
yoke-derive-0.8.4
zbus-5.19.0
zbus_macros-5.19.0
zbus_names-4.3.5
zcheapstr-1.3.0
zerocopy-0.8.63
zerocopy-derive-0.8.63
zerofrom-0.1.8
zerofrom-derive-0.1.8
zeroize-1.9.2
zerotrie-0.2.5
zerovec-0.11.9
zerovec-derive-0.11.7
zlib-rs-0.6.8
zmij-1.0.23
zstd-0.13.5
zstd-safe-7.4.1
zstd-sys-2.1.3+zstd.1.5.7
zvariant-5.15.1
zvariant_derive-5.15.1
zvariant_utils-4.2.0
"

# Generally speaking the llvm eclasses make things worst when two llvm slots are required.
inherit abseil-cpp cargo cflags-hardened flag-o-matic-om linux-info protobuf rustflags-hardened

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
ebuild_revision_16
"
# Both LLVM slots are required as discussed above.
REQUIRED_USE+="
	llvm_slot_${LLVM_SLOT_PROTOBUF}
	llvm_slot_${LLVM_SLOT_SCX}
	|| (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
"
DEPEND="
	>=dev-libs/libbpf-1.2.2:=
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
			dev-cpp/abseil-cpp:20220623[llvm_slot_${LLVM_SLOT_PROTOBUF}?]
			dev-libs/protobuf:3/3.21[llvm_slot_${LLVM_SLOT_PROTOBUF}?,protoc(+)]
		)
		(
			dev-cpp/abseil-cpp:20260526[llvm_slot_${LLVM_SLOT_PROTOBUF}?]
			dev-libs/protobuf:7/7.36[llvm_slot_${LLVM_SLOT_PROTOBUF}?,protoc(+)]
		)
	)
	virtual/pkgconfig:*
	llvm_slot_${LLVM_SLOT_PROTOBUF}? (
		llvm-core/clang:${LLVM_SLOT_PROTOBUF}=[llvm_targets_BPF(-)]
		llvm-core/llvm:${LLVM_SLOT_PROTOBUF}=[llvm_targets_BPF(-)]
	)
	llvm_slot_${LLVM_SLOT_SCX}? (
		llvm-core/clang:${LLVM_SLOT_SCX}=[llvm_targets_BPF(-)]
		llvm-core/llvm:${LLVM_SLOT_SCX}=[llvm_targets_BPF(-)]
		|| (
			dev-lang/rust:${RUST_LLVM_22_PV}
			dev-lang/rust-bin:${RUST_LLVM_22_PV}
		)
	)
"
PDEPEND="
	~sys-kernel/scx-loader-${PV}
"

setup_kernel_config_production() {
	# CONFIG_BPF_JIT=y for scx enablement
	CONFIG_CHECK="
		~NET
		~BPF
		~BPF_SYSCALL
		~BPF_JIT
		~DEBUG_INFO
		~DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
		~DEBUG_INFO_DWARF4
		~DEBUG_INFO_DWARF5
		~DEBUG_INFO_BTF
		~BPF_JIT_ALWAYS_ON
		~BPF_JIT_DEFAULT_ON
	"
	WARNING_BPF="CONFIG_NET=y is required for scx enablement."
	WARNING_BPF="CONFIG_BPF=y is required for scx enablement."
	WARNING_BPF_SYSCALL="CONFIG_BPF_SYSCALL=y is required for scx enablement."
	WARNING_BPF_JIT="CONFIG_BPF_JIT=y is required for scx enablement."
	WARNING_DEBUG_INFO="CONFIG_DEBUG_INFO=y is required for scx enablement."
	WARNING_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT="Either CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y, CONFIG_DEBUG_INFO_DWARF4=y, or CONFIG_DEBUG_INFO_DWARF5=y is required for scx enablement."
	WARNING_DEBUG_INFO_DWARF4="Either CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y, CONFIG_DEBUG_INFO_DWARF4=y, or CONFIG_DEBUG_INFO_DWARF5=y is required for scx enablement."
	WARNING_DEBUG_INFO_DWARF5="Either CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y, CONFIG_DEBUG_INFO_DWARF4=y, or CONFIG_DEBUG_INFO_DWARF5=y is required for scx enablement."
	WARNING_DEBUG_INFO_BTF="CONFIG_DEBUG_INFO_BTF=y is required for scx enablement."
	WARNING_BPF_JIT_ALWAYS_ON="CONFIG_BPF_JIT_ALWAYS_ON=y is required for scx enablement."
	WARNING_BPF_JIT_DEFAULT_ON="CONFIG_BPF_JIT_DEFAULT_ON=y is required for scx enablement."

	# SCHED_CLASS_EXT=y for scx enablement
	CONFIG_CHECK="
		~SCHED_CLASS_EXT
	"
	WARNING_SCHED_CLASS_EXT="CONFIG_SCHED_CLASS_EXT=y is required for scx enablement."
	check_extra_config

	# CONFIG_DEBUG_INFO=y and dependency config for scx enablement
	CONFIG_CHECK="
		~DEBUG_INFO
		~!DEBUG_INFO_SPLIT
		~!DEBUG_INFO_REDUCED
		~!COMPILE_TEST
		~DEBUG_INFO_BTF
	"
	WARNING_DEBUG_INFO="CONFIG_DEBUG_INFO=y is required for scx enablement."
	WARNING_DEBUG_INFO_SPLIT="An unset CONFIG_DEBUG_INFO_SPLIT is required for scx enablement."
	WARNING_DEBUG_INFO_REDUCED="An unset CONFIG_DEBUG_INFO_REDUCED is required for scx enablement."
	WARNING_COMPILE_TEST="An unset CONFIG_COMPILE_TEST is required for scx enablement."
	WARNING_DEBUG_INFO_BTF="CONFIG_DEBUG_INFO_BTF=y is required for scx enablement."
	check_extra_config

	CONFIG_CHECK="
		~DEBUG_KERNEL
		~KALLSYMS_ALL
	"
	WARNING_DEBUG_KERNEL="CONFIG_DEBUG_KERNEL=y is required for scx_p2dq, scx_layered, scxtop."
	WARNING_KALLSYMS_ALL="CONFIG_KALLSYMS_ALL=y is required for scx_p2dq, scx_layered, scxtop."
	check_extra_config

	CONFIG_CHECK="
		~DEBUG_INFO_REDUCED
	"
	WARNING_DEBUG_INFO_REDUCED="CONFIG_DEBUG_INFO_REDUCED=y is required for scx enablement on arm64."
	check_extra_config

	CONFIG_CHECK="
		~FUNCTION_TRACER
		~FUTEX
	"
	WARNING_FUNCTION_TRACER="CONFIG_FUNCTION_TRACER=y is required for scx_lavd enablement and timeslice gain for scx_lavd and better systemwide throughput."
	WARNING_FUTEX="CONFIG_FUTEX=y is required for scx_lavd enablement."
	check_extra_config

	# CONFIG_TRACING=y and dependency config for scx enablement
	# CONFIG_FTRACE=y and dependency config for scx enablement
	CONFIG_CHECK="
		~TRACE_IRQFLAGS_SUPPORT
		~STACKTRACE_SUPPORT
		~TRACING_SUPPORT
		~FTRACE
	"
	WARNING_TRACE_IRQFLAGS_SUPPORT="CONFIG_TRACE_IRQFLAGS_SUPPORT=y is required for scx enablement."
	WARNING_STACKTRACE_SUPPORT="CONFIG_STACKTRACE_SUPPORT=y is required for scx enablement."
	WARNING_TRACING_SUPPORT="CONFIG_TRACING_SUPPORT=y is required for scx enablement."
	WARNING_FTRACE="CONFIG_FTRACE=y is required for scx enablement."
	check_extra_config

	# KPROBES=y and dependency config for scx enablement
	CONFIG_CHECK="
		~KPROBES
		~KPROBE_EVENTS
		~PERF_EVENTS
		~MMU
		~UPROBE_EVENTS
		~BPF_EVENTS
		~TRACING
		~TRACEPOINTS
	"
	WARNING_KPROBES="CONFIG_KPROBES=y is required for scx enablement."
	WARNING_KPROBE_EVENTS="CONFIG_KPROBE_EVENTS=y is required for scx enablement."
	WARNING_PERF_EVENTS="CONFIG_PERF_EVENTS=y is required for scx enablement."
	WARNING_MMU="CONFIG_MMU=y is required for scx enablement."
	WARNING_UPROBE_EVENTS="CONFIG_UPROBE_EVENTS=y is required for scx enablement."
	WARNING_BPF_EVENTS="CONFIG_BPF_EVENTS=y is required for scx enablement."
	WARNING_TRACING="CONFIG_TRACING=y is required for scx enablement."
	WARNING_TRACEPOINTS="CONFIG_TRACEPOINTS=y is required for scx enablement."
	check_extra_config

	CONFIG_CHECK="
		~EXPERT
		~PROC_FS
		~PROC_SYSCTL
		~SYSFS
	"
	WARNING_EXPERT="CONFIG_EXPERT=y is required for utils."
	WARNING_PROC_FS="CONFIG_PROC_FS=y is required for utils."
	WARNING_PROC_SYSCTL="CONFIG_PROC_SYSCTL=y is required for utils."
	WARNING_SYSFS="CONFIG_SYSFS=y is required for utils."
	check_extra_config

	CONFIG_CHECK="
		~IKHEADERS
		~IKCONFIG_PROC
		~IKCONFIG
	"
	WARNING_IKHEADERS="CONFIG_IKHEADERS=y is required for avoiding warnings for \`scx_lavd --performance\`."
	WARNING_IKCONFIG_PROC="CONFIG_IKCONFIG_PROC=y is required for avoiding warnings for \`scx_lavd --performance\`."
	WARNING_IKCONFIG="CONFIG_IKCONFIG=y is required for avoiding warnings for \`scx_lavd --performance\`."
	check_extra_config

	CONFIG_CHECK="
		~!LTO
		~PAHOLE_HAS_LANG_EXCLUDE
	"
	WARNING_LTO="An unset CONFIG_LTO is required for scx support."
	WARNING_PAHOLE_HAS_LANG_EXCLUDE="CONFIG_PAHOLE_HAS_LANG_EXCLUDE=y is required for scx support."
	check_extra_config

}

setup_kernel_config_debug() {
	CONFIG_CHECK="
		~SCHED_DEBUG
	"
	WARNING_SCHED_DEBUG="CONFIG_SCHED_DEBUG=y is required for 6.15 and earlier kernels for scheduling debugging."
	check_extra_config

	CONFIG_CHECK="
		~NUMA
		~NUMA_BALANCING
		~SCHED_AUTOGROUP
		~SCHED_CORE
		~SCHED_MC
	"
	WARNING_NUMA="CONFIG_NUMA=y is required for increased code coverage feature testing."
	WARNING_NUMA_BALANCING="CONFIG_NUMA_BALANCING=y is required for increased code coverage feature testing."
	WARNING_SCHED_AUTOGROUP="CONFIG_SCHED_AUTOGROUP=y is required for increased code coverage feature testing."
	WARNING_SCHED_CORE="CONFIG_SCHED_CORE=y is required for increased code coverage feature testing."
	WARNING_SCHED_MC="CONFIG_SCHED_MC=y is required for increased code coverage feature testing."
	check_extra_config

	CONFIG_CHECK="
		~PREEMPT
		~PREEMPT_DYNAMIC
	"
	WARNING_PREEMPT="CONFIG_PREEMPT=y is required for testing coverage."
	WARNING_PREEMPT_DYNAMIC="CONFIG_PREEMPT_DYNAMIC=y is required for testing coverage."
	check_extra_config

	CONFIG_CHECK="
		~DEBUG_LOCKDEP
		~DEBUG_ATOMIC_SLEEP
		~PROVE_LOCKING
	"
	WARNING_DEBUG_LOCKDEP="CONFIG_DEBUG_LOCKDEP=y is required for additional debugging info for deadlock analysis."
	WARNING_DEBUG_ATOMIC_SLEEP="CONFIG_DEBUG_ATOMIC_SLEEP=y is required for additional debugging info for deadlock analysis."
	WARNING_PROVE_LOCKING="CONFIG_PROVE_LOCKING=y is required for additional debugging info for deadlock analysis."
	check_extra_config

	CONFIG_CHECK="
		~BPF_EVENTS
		~FTRACE_SYSCALLS
		~DYNAMIC_FTRACE
		~KPROBES
		~KPROBE_EVENTS
		~UPROBES
		~UPROBE_EVENTS
		~DEBUG_FS
	"
	WARNING_BPF_EVENTS="CONFIG_BPF_EVENTS=y is required for additional debug info."
	WARNING_FTRACE_SYSCALLS="CONFIG_FTRACE_SYSCALLS=y is required for additional debug info."
	WARNING_DYNAMIC_FTRACE="CONFIG_DYNAMIC_FTRACE=y is required for additional debug info."
	WARNING_KPROBES="CONFIG_KPROBES=y is required for additional debug info."
	WARNING_KPROBE_EVENTS="CONFIG_KPROBE_EVENTS=y is required for additional debug info."
	WARNING_UPROBES="CONFIG_UPROBES=y is required for additional debug info."
	WARNING_UPROBE_EVENTS="CONFIG_UPROBE_EVENTS=y is required for additional debug info."
	WARNING_DEBUG_FS="CONFIG_DEBUG_FS=y is required for additional debug info."
	check_extra_config

	CONFIG_CHECK="
		~IKHEADERS
		~IKCONFIG_PROC
		~IKCONFIG
	"
	WARNING_IKHEADERS="CONFIG_IKHEADERS=y is required for scx to access kernel config headers at runtime."
	WARNING_IKCONFIG_PROC="CONFIG_IKCONFIG_PROC=y is required for scx to access kernel config headers at runtime."
	WARNING_IKCONFIG="CONFIG_IKCONFIG=y is required for scx to access kernel config headers at runtime."
	check_extra_config
}

QA_PREBUILT="/usr/bin/vmlinux_docify"
PATCHES=(
	"${FILESDIR}/${PN}-1.0.20-llvm-19.patch"
)

pkg_setup() {
	setup_kernel_config
	linux-info_pkg_setup

	setup_kernel_config_production
	if use debug ; then
		setup_kernel_config_debug
	fi

	# Sanitize and manually add to avoid llvm*.eclass side-effects.
	PATH=$(echo "${PATH}" | tr ":" "\n" | sed -e "\|/usr/lib/llvm/|d" | tr "\n" ":")
	PATH=$(echo "${PATH}" | sed -e "s|/opt/bin:|/opt/bin:/usr/lib/llvm/${LLVM_SLOT_PROTOBUF}/bin:|g")
	export PATH=$(echo "${PATH}" | sed -e "s|/opt/bin:|/opt/bin:/usr/lib/llvm/${LLVM_SLOT_SCX}/bin:|g")
	export LLVM_SLOT="${LLVM_SLOT_SCX}"
	export CLANG_PATH=$(which clang-${LLVM_SLOT_SCX})
einfo "CLANG_PATH:  ${CLANG_PATH}"
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

	fix_mb_len_max			# For Clang built aws-lc-sys
	cflags-hardened_append		# For aws-lc-sys
	rustflags-hardened_append

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
		dobin "target/${configuration}/${sched#scheds/rust}"
	done

einfo "Installing tools"
	dobin "target/${configuration}/vmlinux_docify"
	dobin "target/${configuration}/scxtop"
	dobin "target/${configuration}/scx-forge-agent"

	if use debug ; then
		exeinto "/usr/$(get_libdir)"
		doexe "target/${configuration}/libscx_stats_derive.so"
	fi

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
