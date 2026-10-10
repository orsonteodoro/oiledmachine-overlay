# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D12, D13, RH9, RH10, U22, U24

# The patches were based on AI generated code samples.

POSTGRES_COMPAT=( {15..19} )
POSTGRES_USEDEP="server"
RUST_MAX_VER="1.98.1"
RUST_MIN_VER="1.98.1" # LLVM 22.1
RUST_PV="${RUST_MIN_VER}"

DATAFUSION_COMMIT="41b058cc278eb497a2ffc6b41a323f056d3ef568"
FST_COMMIT="1d2e473c6de63d17749030eb8538ba4d647f3430"
TANTIVY_COMMIT="63e0c241cfd330381aebd5893f188fa858acbf45"

CPU_FLAGS_X86=(
	"cpu_flags_x86_sse"
	"cpu_flags_x86_sse2"
	"cpu_flags_x86_sse3"
	"cpu_flags_x86_ssse3"
	"cpu_flags_x86_sse4_1"
	"cpu_flags_x86_sse4_2"
	"cpu_flags_x86_popcnt"
	"cpu_flags_x86_cx16"
	"cpu_flags_x86_avx"
	"cpu_flags_x86_avx2"
	"cpu_flags_x86_fma"
	"cpu_flags_x86_bmi"
	"cpu_flags_x86_bmi2"
	"cpu_flags_x86_f16c"
	"cpu_flags_x86_lzcnt"
	"cpu_flags_x86_movbe"
	"cpu_flags_x86_xsave"
	"cpu_flags_x86_avx512f"
	"cpu_flags_x86_avx512bw"
	"cpu_flags_x86_avx512cd"
	"cpu_flags_x86_avx512dq"
	"cpu_flags_x86_avx512vl"
)

CPU_FLAGS_X86_ISA1=(
	"cpu_flags_x86_sse"
	"cpu_flags_x86_sse2"
)

CPU_FLAGS_X86_ISA2=(
	"${CPU_FLAGS_X86_ISA1[@]}"
	"cpu_flags_x86_sse3"
	"cpu_flags_x86_ssse3"
	"cpu_flags_x86_sse4_1"
	"cpu_flags_x86_sse4_2"
	"cpu_flags_x86_popcnt"
	"cpu_flags_x86_cx16"
)

CPU_FLAGS_X86_ISA3=(
	"${CPU_FLAGS_X86_ISA2[@]}"
	"cpu_flags_x86_avx"
	"cpu_flags_x86_avx2"
	"cpu_flags_x86_fma"
	"cpu_flags_x86_bmi"
	"cpu_flags_x86_bmi2"
	"cpu_flags_x86_f16c"
	"cpu_flags_x86_lzcnt"
	"cpu_flags_x86_movbe"
	"cpu_flags_x86_xsave"
)

CPU_FLAGS_X86_ISA4=(
	"${CPU_FLAGS_X86_ISA3[@]}"
	"cpu_flags_x86_avx512f"
	"cpu_flags_x86_avx512bw"
	"cpu_flags_x86_avx512cd"
	"cpu_flags_x86_avx512dq"
	"cpu_flags_x86_avx512vl"
)

DISABLED_CRATES="
benchmarks-0.26.1
macros-0.26.1
pg_search-0.26.1
stressgres-0.26.1
tokenizers-0.26.1
dst-0.26.1
"

CRATES="
adler2-2.0.1
adler32-1.2.0
ahash-0.8.12
aho-corasick-1.1.5
aligned-0.4.3
aligned-vec-0.6.4
allocator-api2-0.2.21
android_system_properties-0.1.6
anstream-1.0.0
anstyle-1.0.14
anstyle-parse-1.0.0
anstyle-query-1.1.5
anstyle-wincon-3.0.11
antithesis-instrumentation-0.1.0
antithesis_sdk-0.2.9
antithesis_sdk-0.3.0
anyhow-1.0.104
approx-0.5.1
arbitrary-1.5.0
arc-swap-1.9.2
arg_enum_proc_macro-0.3.4
arrayvec-0.7.8
arrow-58.4.0
arrow-59.3.0
arrow-arith-58.4.0
arrow-arith-59.3.0
arrow-array-58.4.0
arrow-array-59.3.0
arrow-buffer-58.4.0
arrow-buffer-59.3.0
arrow-cast-58.4.0
arrow-cast-59.3.0
arrow-csv-59.3.0
arrow-data-58.4.0
arrow-data-59.3.0
arrow-ipc-59.3.0
arrow-json-59.3.0
arrow-ord-58.4.0
arrow-ord-59.3.0
arrow-row-58.4.0
arrow-row-59.3.0
arrow-schema-58.4.0
arrow-schema-59.3.0
arrow-select-58.4.0
arrow-select-59.3.0
arrow-string-58.4.0
arrow-string-59.3.0
as-slice-0.2.1
async-attributes-1.1.2
async-channel-1.9.0
async-channel-2.5.0
async-executor-1.14.0
async-fs-2.2.0
async-global-executor-2.4.1
async-io-2.6.0
async-lock-3.4.2
async-std-1.13.2
async-stream-0.3.6
async-stream-impl-0.3.6
async-task-4.7.1
async-trait-0.1.92
atoi-2.0.0
atomic-waker-1.1.2
autocfg-1.5.1
av1-grain-0.2.5
avif-serialize-0.8.9
av-scenechange-0.14.1
base64-0.22.1
base64-0.23.1
bigdecimal-0.4.11
bincode-1.3.3
bincode-2.0.1
bindgen-0.72.1
bit_field-0.10.3
bitflags-1.3.2
bitflags-2.13.2
bitpacking-0.9.3
bit-set-0.8.0
bitstream-io-4.10.0
bit-vec-0.8.0
bitvec-1.1.1
block-buffer-0.10.4
block-buffer-0.12.1
blocking-1.7.0
bon-3.10.2
bon-macros-3.10.2
borsh-1.8.1
borsh-derive-1.8.1
built-0.8.1
bumpalo-3.20.3
bytecheck-0.8.3
bytecheck_derive-0.8.3
bytecount-0.6.9
bytemuck-1.25.2
bytemuck_derive-1.12.1
byteorder-1.5.0
byteorder-lite-0.1.0
bytes-1.12.1
camino-1.2.6
cargo_metadata-0.23.1
cargo-platform-0.3.3
cargo_toml-0.22.3
cast-0.3.0
castaway-0.2.4
cc-1.7.0
cedarwood-0.5.0
cee-scape-0.2.0
census-0.4.2
cexpr-0.6.0
cfg_aliases-0.2.2
cfg-if-1.0.5
chacha20-0.10.2
chrono-0.4.45
chrono-tz-0.10.4
clang-sys-1.9.1
clap-4.6.7
clap_builder-4.6.7
clap-cargo-0.18.3
clap_derive-4.6.7
clap_lex-1.1.1
cmd_lib-2.0.1
cmd_lib_macros-2.0.1
cmov-0.5.4
cobs-0.3.0
codepage-0.1.3
colorchoice-1.0.5
color_quant-1.1.0
comfy-table-7.1.4
compact_str-0.9.1
concurrent-queue-2.5.0
const-oid-0.10.2
const-random-0.1.18
const-random-macro-0.1.16
convert_case-0.11.0
core_detect-1.0.0
core-foundation-0.9.4
core-foundation-sys-0.8.7
core-graphics-0.23.2
core-graphics-types-0.1.3
core_maths-0.1.1
core-text-20.1.0
cpufeatures-0.2.17
cpufeatures-0.3.1
crawdad-0.4.1
crc32fast-1.5.2
crc-3.4.0
crc-catalog-2.5.0
crossbeam-channel-0.5.17
crossbeam-deque-0.8.8
crossbeam-epoch-0.9.21
crossbeam-queue-0.3.14
crossbeam-utils-0.8.23
crossterm-0.28.1
crossterm_winapi-0.9.1
crunchy-0.2.4
crypto-common-0.1.6
crypto-common-0.2.2
csv-1.4.0
csv-core-0.1.13
ctutils-0.4.3
cursive-0.21.1
cursive_core-0.4.7
cursive-macros-0.1.0
cursive-multiplex-0.7.0
cursive_table_view-0.15.0
daachorse-5.0.0
darling-0.21.3
darling-0.24.1
darling_core-0.21.3
darling_core-0.24.1
darling_macro-0.21.3
darling_macro-0.24.1
dary_heap-0.3.9
dashmap-6.2.1
datasketches-0.3.0
decimal-bytes-0.6.0
defmt-1.1.1
defmt-macros-1.1.1
defmt-parser-1.0.0
delegate-0.13.5
deranged-0.4.0
deranged-0.5.8
derive_arbitrary-1.5.0
diff-0.1.13
digest-0.10.7
digest-0.11.3
dirs-6.0.0
dirs-sys-0.5.0
dispatch2-0.3.1
displaydoc-0.2.7
distrs-0.2.3
dlib-0.5.3
dotenvy-0.15.7
downcast-rs-2.0.2
duckdb-1.10506.0
dwrote-0.11.5
either-1.19.0
embedded-io-0.4.0
embedded-io-0.6.1
emojis-0.9.0
encoding_rs-0.8.42
encoding_rs_io-0.1.8
enum-map-2.7.3
enum-map-derive-0.17.0
enumset-1.1.14
enumset_derive-0.15.0
env_filter-2.0.0
env_logger-0.11.11
equator-0.4.2
equator-macro-0.4.2
equivalent-1.0.2
erased-serde-0.4.10
errno-0.3.14
etcetera-0.11.0
event-listener-2.5.3
event-listener-5.4.2
event-listener-strategy-0.5.4
exr-1.74.2
eyre-0.6.14
faccess-0.2.4
fallible-iterator-0.2.0
fallible-iterator-0.3.0
fallible-streaming-iterator-0.1.9
fastdivide-0.4.2
fastrand-2.5.0
fax-0.2.7
fdeflate-0.3.7
filetime-0.2.29
find-msvc-tools-0.1.14
fixedbitset-0.5.7
flatbuffers-25.12.19
flate2-1.1.10
float-ord-0.3.2
flume-0.12.0
fnv-1.0.7
foldhash-0.1.5
foldhash-0.2.0
font-kit-0.14.3
foreign-types-0.3.2
foreign-types-0.5.0
foreign-types-macros-0.2.4
foreign-types-shared-0.1.1
foreign-types-shared-0.3.1
form_urlencoded-1.2.2
freetype-sys-0.20.1
frostem-1.20260821.7
funty-2.0.0
futures-0.3.34
futures-channel-0.3.34
futures-core-0.3.34
futures-executor-0.3.34
futures-intrusive-0.5.0
futures-io-0.3.34
futures-lite-2.6.1
futures-macro-0.3.34
futures-sink-0.3.34
futures-task-0.3.34
futures-timer-3.0.4
futures-util-0.3.34
generic-array-0.14.9
getrandom-0.2.17
getrandom-0.3.4
getrandom-0.4.3
gif-0.12.0
gif-0.14.2
glob-0.3.4
gloo-timers-0.3.0
half-1.8.3
half-2.7.1
hashbrown-0.14.5
hashbrown-0.15.5
hashbrown-0.16.1
hashbrown-0.17.1
hashlink-0.10.0
hashlink-0.11.1
heck-0.5.0
hermit-abi-0.5.3
hex-0.4.3
hkdf-0.13.0
hmac-0.13.0
htmlescape-0.3.1
http-1.5.0
httparse-1.10.1
human_bytes-0.4.3
humantime-2.4.0
hybrid-array-0.4.15
iana-time-zone-0.1.65
iana-time-zone-haiku-0.1.2
icu_collections-2.3.0
icu_locale_core-2.3.0
icu_locale_fallback-2.3.0
icu_locale_fallback_data-2.3.0
icu_normalizer-2.3.0
icu_normalizer_data-2.3.0
icu_properties-2.3.0
icu_properties_data-2.3.0
icu_provider-2.3.1
icu_segmenter-2.3.0
icu_segmenter_data-2.3.0
ident_case-1.0.1
idna-1.1.0
idna_adapter-1.2.2
image-0.24.9
image-0.25.10
image-webp-0.2.4
imgref-1.12.3
include-flate-0.3.4
include-flate-codegen-0.3.4
include-flate-compress-0.3.4
indenter-0.3.4
indexmap-2.14.2
indextree-4.9.2
indextree-macros-0.1.4
interpolate_name-0.2.4
inventory-0.3.25
is_ci-1.2.0
is_terminal_polyfill-1.70.2
itertools-0.13.0
itertools-0.14.0
itertools-0.15.0
itoa-1.0.18
jieba-macros-0.10.4
jieba-rs-0.10.4
jiff-0.2.38
jiff-core-0.1.1
jiff-static-0.2.38
jiff-tzdb-0.1.9
jiff-tzdb-platform-0.1.3
jobserver-0.1.35
jpeg-decoder-0.3.2
js-sys-0.3.106
kanaria-0.2.0
kv-log-macro-1.0.7
lazy_static-1.5.1
lebe-0.5.3
levenshtein_automata-0.2.1
lexical-core-1.0.6
lexical-parse-float-1.0.6
lexical-parse-integer-1.0.6
lexical-util-1.0.7
lexical-write-float-1.0.6
lexical-write-integer-1.0.6
libc-0.2.190
libduckdb-sys-1.10506.0
libflate-2.3.2
libflate_lz77-2.3.0
libfuzzer-sys-0.4.13
libloading-0.8.9
libm-0.2.16
libredox-0.1.25
libsqlite3-sys-0.37.0
lindera-6.2.0
lindera-analysis-6.2.0
lindera-cc-cedict-6.2.0
lindera-dictionary-6.2.0
lindera-ipadic-6.2.0
lindera-ko-dic-6.2.0
linkme-0.3.37
linkme-impl-0.3.37
linux-raw-sys-0.12.1
linux-raw-sys-0.4.15
litemap-0.8.3
lock_api-0.4.14
lockfree-object-pool-0.1.6
log-0.4.34
loop9-0.1.5
lru-0.18.5
lz4_flex-0.14.0
matrixmultiply-0.3.11
maybe-rayon-0.1.1
md-5-0.11.0
md5-0.8.1
measure_time-0.9.0
memchr-2.8.3
memmap2-0.9.11
minimal-lexical-0.2.1
miniz_oxide-0.8.9
miniz_oxide-0.9.1
mio-1.2.4
moka-0.12.16
moxcms-0.8.1
multiversion_no_op-1.0.0
munge-0.4.7
munge_macro-0.4.7
murmurhash32-0.4.0
new_debug_unreachable-1.0.6
nom-7.1.3
nom-8.0.0
noop_proc_macro-0.3.0
no_std_io2-0.9.4
ntapi-0.4.3
num-0.4.3
num-bigint-0.4.8
num-bigint-0.5.1
num-complex-0.4.6
num-conv-0.2.2
num_cpus-1.17.0
num-derive-0.4.2
num-integer-0.1.47
num-iter-0.1.46
num-rational-0.4.2
num-traits-0.2.19
objc2-0.6.5
objc2-core-foundation-0.3.2
objc2-encode-4.1.0
objc2-foundation-0.3.2
objc2-io-kit-0.3.2
objc2-open-directory-0.3.2
objc2-system-configuration-0.3.2
object_store-0.13.2
once_cell-1.21.4
once_cell_polyfill-1.70.2
oneshot-0.1.13
openssl-0.10.81
openssl-macros-0.1.1
openssl-sys-0.9.117
option-ext-0.2.0
ordered-float-5.5.0
os_pipe-1.2.3
owo-colors-4.4.0
parking-2.2.1
parking_lot-0.12.5
parking_lot_core-0.9.12
paste-1.0.15
pastey-0.1.1
pathfinder_geometry-0.5.1
pathfinder_simd-0.5.6
pathsearch-0.2.0
percent-encoding-2.3.2
petgraph-0.8.3
pgrx-0.19.3
pgrx-bindgen-0.19.3
pgrx-macros-0.19.3
pgrx-pg-config-0.19.3
pgrx-pg-sys-0.19.3
pgrx-sql-entity-graph-0.19.3
pgrx-tests-0.19.3
pgvector-0.4.2
phf-0.12.1
phf-0.13.1
phf_codegen-0.13.1
phf_generator-0.13.1
phf_shared-0.12.1
phf_shared-0.13.1
pin-project-1.1.13
pin-project-internal-1.1.13
pin-project-lite-0.2.17
pin-utils-0.1.1
piper-0.2.5
pkg-config-0.3.34
plotters-0.3.7
plotters-backend-0.3.7
plotters-bitmap-0.3.7
plotters-svg-0.3.7
png-0.17.16
png-0.18.1
polling-3.11.0
portable-atomic-1.15.0
portable-atomic-util-0.2.8
postcard-1.1.3
postgres-0.19.14
postgres-openssl-0.5.3
postgres-protocol-0.6.12
postgres-types-0.2.14
potential_utf-0.1.6
powerfmt-0.2.1
ppv-lite86-0.2.21
precis-core-0.1.11
precis-profiles-0.1.13
precis-tools-0.1.10
pretty_assertions-1.4.1
prettyplease-0.3.0
proc-macro2-1.0.107
proc-macro-crate-3.5.0
proc-macro-error3-3.1.1
proc-macro-error-attr3-3.1.1
profiling-1.0.18
profiling-procmacros-1.0.18
proptest-derive-0.8.0
prost-0.14.4
prost-derive-0.14.4
ptr_meta-0.3.2
ptr_meta_derive-0.3.2
pulp-0.22.3
pulp-wasm-simd-flag-0.1.1
pxfm-0.1.30
qoi-0.4.1
quick-error-1.2.3
quick-error-2.0.1
quote-1.0.47
radium-0.7.0
rancor-0.1.3
rand-0.10.3
rand-0.8.8
rand-0.9.5
rand_chacha-0.10.0
rand_chacha-0.3.1
rand_chacha-0.9.0
rand_core-0.10.1
rand_core-0.6.4
rand_core-0.9.5
rand_distr-0.4.3
rand_xorshift-0.4.0
rand_xorshift-0.5.0
rav1e-0.8.1
ravif-0.13.0
raw-cpuid-11.6.0
rawpointer-0.2.1
rayon-1.12.0
rayon-core-1.13.0
reborrow-0.5.5
redox_syscall-0.5.18
redox_users-0.5.3
r-efi-5.3.0
r-efi-6.0.0
regex-1.13.1
regex-automata-0.4.18
regex-lite-0.1.9
regex-syntax-0.8.11
relative-path-1.9.3
rend-0.5.4
rgb-0.8.53
ring-0.17.14
rkyv-0.8.18
rkyv_derive-0.8.18
rle-decode-fast-1.0.3
rstest-0.27.0
rstest_macros-0.27.0
rustc-hash-2.1.3
rustc_version-0.4.1
rustc_version_runtime-0.3.0
rust_decimal-1.43.0
rustix-0.38.44
rustix-1.1.5
rustls-0.23.45
rustls-pki-types-1.15.1
rustls-webpki-0.103.15
rustversion-1.0.23
rusty-fork-0.3.1
ryu-1.0.23
same-file-1.0.6
scopeguard-1.2.0
seahash-4.1.0
semver-1.0.28
serde-1.0.229
serde_cbor-0.11.2
serde_core-1.0.229
serde_derive-1.0.229
serde_json-1.0.151
serde_path_to_error-0.1.20
serde_spanned-1.1.2
serde_yaml_ng-0.10.0
sha1-0.11.0
sha2-0.10.9
sha2-0.11.0
shlex-1.3.0
shlex-2.0.1
shutdown_hooks-0.1.0
signal-hook-0.3.18
signal-hook-mio-0.2.5
signal-hook-registry-1.4.8
simd-adler32-0.3.10
simd_helpers-0.1.0
simdutf8-0.1.5
siphasher-1.0.4
sketches-ddsketch-0.3.1
sketches-ddsketch-0.4.1
slab-0.4.12
smallvec-1.16.3
socket2-0.6.5
spin-0.9.9
sqlparser-0.62.0
sqlparser_derive-0.5.0
sqlx-0.9.0
sqlx-core-0.9.0
sqlx-macros-0.9.0
sqlx-macros-core-0.9.0
sqlx-mysql-0.9.0
sqlx-postgres-0.9.0
sqlx-sqlite-0.9.0
stable_deref_trait-1.2.1
static_assertions-1.1.0
stringprep-0.1.5
strsim-0.11.1
strum-0.27.2
strum-0.28.0
strum_macros-0.27.2
strum_macros-0.28.0
subtle-2.6.1
supports-color-3.0.2
syn-1.0.109
syn-2.0.119
syn-3.0.7
synstructure-0.14.0
sysinfo-0.39.6
tagptr-0.2.0
tantivy-jieba-0.20.0
tantivy-stemmers-0.4.0
tap-1.0.1
tar-0.4.46
tempfile-3.27.0
thiserror-1.0.69
thiserror-2.0.21
thiserror-impl-1.0.69
thiserror-impl-2.0.21
thread-tree-0.3.3
tiff-0.11.3
time-0.3.55
time-core-0.1.9
time-macros-0.2.32
tiny-keccak-2.0.2
tinystr-0.8.4
tinyvec-1.13.3
tokio-1.53.2
tokio-macros-2.7.2
tokio-openssl-0.6.5
tokio-postgres-0.7.18
tokio-stream-0.1.19
tokio-util-0.7.20
toml-0.9.12+spec-1.1.0
toml-1.1.8+spec-1.1.0
toml_datetime-0.7.5+spec-1.1.0
toml_datetime-1.1.2+spec-1.1.0
toml_edit-0.25.17+spec-1.1.0
toml_parser-1.1.5+spec-1.1.0
toml_writer-1.1.3+spec-1.1.0
tracing-0.1.44
tracing-attributes-0.1.31
tracing-core-0.1.36
ttf-parser-0.20.0
twox-hash-2.1.5
typeid-1.0.3
typenum-1.20.1
typetag-0.2.23
typetag-impl-0.2.23
ucd-parse-0.1.13
unarray-0.1.4
unescape-0.1.0
unicode-bidi-0.3.18
unicode-blocks-0.1.10
unicode-ident-1.0.26
unicode-normalization-0.1.25
unicode-properties-0.1.4
unicode-segmentation-1.13.3
unicode-width-0.1.14
unicode-width-0.2.2
unsafe-libyaml-0.2.11
untrusted-0.9.0
unty-0.0.4
unwrap-infallible-1.0.0
ureq-3.4.2
ureq-proto-0.6.4
url-2.5.8
utf8_iter-1.0.4
utf8parse-0.2.2
utf8-ranges-1.0.5
utf8-zero-0.8.1
uuid-1.28.0
value-bag-1.14.1
vcpkg-0.2.15
version_check-0.9.5
v_frame-0.3.9
wait-timeout-0.2.1
walkdir-2.5.0
wasi-0.11.1+wasi-snapshot-preview1
wasi-0.14.7+wasi-0.2.4
wasip2-1.0.4+wasi-0.2.12
wasite-1.0.2
wasm-bindgen-0.2.129
wasm-bindgen-futures-0.4.79
wasm-bindgen-macro-0.2.129
wasm-bindgen-macro-support-0.2.129
wasm-bindgen-shared-0.2.129
webpki-roots-1.0.9
web-sys-0.3.106
web-time-1.1.0
weezl-0.1.12
whoami-2.1.3
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.11
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.62.2
windows_aarch64_gnullvm-0.52.6
windows_aarch64_msvc-0.52.6
windows-collections-0.3.2
windows-core-0.62.2
windows-future-0.3.2
windows_i686_gnu-0.52.6
windows_i686_gnullvm-0.52.6
windows_i686_msvc-0.52.6
windows-implement-0.60.2
windows-interface-0.59.3
windows-link-0.2.1
windows-numerics-0.3.1
windows-result-0.4.1
windows-strings-0.5.1
windows-sys-0.52.0
windows-sys-0.59.0
windows-sys-0.61.2
windows-targets-0.52.6
windows-threading-0.2.1
windows_x86_64_gnu-0.52.6
windows_x86_64_gnullvm-0.52.6
windows_x86_64_msvc-0.52.6
winnow-0.7.15
winnow-1.0.4
wio-0.2.2
wit-bindgen-0.57.1
writeable-0.6.4
wyz-0.5.1
xattr-1.6.1
xi-unicode-0.3.0
y4m-0.8.0
yansi-1.0.1
yeslogic-fontconfig-sys-6.0.1
yoke-0.8.3
yoke-derive-0.8.4
zerocopy-0.8.62
zerocopy-derive-0.8.62
zerofrom-0.1.8
zerofrom-derive-0.1.8
zeroize-1.9.1
zerotrie-0.2.5
zerovec-0.11.8
zerovec-derive-0.11.6
zip-6.0.0
zlib-rs-0.6.8
zmij-1.0.23
zopfli-0.8.3
zstd-0.13.3
zstd-safe-7.3.0
zstd-sys-2.1.1+zstd.1.5.7
zune-core-0.5.3
zune-inflate-0.2.54
zune-jpeg-0.5.15
"

declare -A GIT_CRATES=(
# Replace datafusion-<INT> with datafusion
# Remove [tests] row
# Remove ?tag=snapshot-main-2026-10-06-224907
[cascade]="https://github.com/paradedb/tantivy;63e0c241cfd330381aebd5893f188fa858acbf45;" # 0.1.0
[datafusion-catalog]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/catalog" # 55.1.0
[datafusion-catalog-listing]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/catalog-listing" # 55.1.0
[datafusion-common]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/common" # 55.1.0
[datafusion-common-runtime]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/common-runtime" # 55.1.0
[datafusion-datasource-arrow]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/datasource-arrow" # 55.1.0
[datafusion-datasource-csv]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/datasource-csv" # 55.1.0
[datafusion-datasource]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/datasource" # 55.1.0
[datafusion-datasource-json]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/datasource-json" # 55.1.0
[datafusion-distributed]="https://github.com/paradedb/datafusion-distributed;2b82e8d2af32a6b15fb301be858ef47d7b629a3c;" # 4.0.0
[datafusion-doc]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/doc" # 55.1.0
[datafusion-execution]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/execution" # 55.1.0
[datafusion-expr-common]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/expr-common" # 55.1.0
[datafusion-expr]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/expr" # 55.1.0
[datafusion-functions-aggregate-common]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/functions-aggregate-common" # 55.1.0
[datafusion-functions-aggregate]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/functions-aggregate" # 55.1.0
[datafusion-functions]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/functions" # 55.1.0
[datafusion-functions-nested]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;" # 55.1.0
[datafusion-functions-table]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/functions-table" # 55.1.0
[datafusion-functions-window-common]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/functions-window-common" # 55.1.0
[datafusion-functions-window]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/functions-window" # 55.1.0
[datafusion]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/core" # 55.1.0
[datafusion-macros]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/macros" # 55.1.0
[datafusion-optimizer]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/optimizer" # 55.1.0
[datafusion-physical-expr-adapter]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/physical-expr-adapter" # 55.1.0
[datafusion-physical-expr-common]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/physical-expr-common" # 55.1.0
[datafusion-physical-expr]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/physical-expr" # 55.1.0
[datafusion-physical-optimizer]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/physical-optimizer" # 55.1.0
[datafusion-physical-plan]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/physical-plan" # 55.1.0
[datafusion-proto-common]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/proto-common" # 55.1.0
[datafusion-proto]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/proto" # 55.1.0
[datafusion-proto-models]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;" # 55.1.0
[datafusion-pruning]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/pruning" # 55.1.0
[datafusion-session]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;datafusion-%commit%/datafusion/session" # 55.1.0
[datafusion-sql]="https://github.com/paradedb/datafusion;41b058cc278eb497a2ffc6b41a323f056d3ef568;" # 55.1.0
[fht]="https://github.com/paradedb/tantivy;63e0c241cfd330381aebd5893f188fa858acbf45;" # 0.1.0
[grid-plane]="https://github.com/paradedb/tantivy;63e0c241cfd330381aebd5893f188fa858acbf45;" # 0.1.0
[opencc-jieba-rs]="https://github.com/paradedb/opencc-jieba-rs;75453c464ff30201aeef3c1211482406b66b2e38;" # 0.8.1
[ownedbytes]="https://github.com/paradedb/tantivy;63e0c241cfd330381aebd5893f188fa858acbf45;tantivy-%commit%/ownedbytes" # 0.9.0
[proptest]="https://github.com/antithesishq/proptest;6061eb48d67ff76f882e709677308816d5791ce7;" # 1.11.0
[quant-model]="https://github.com/paradedb/tantivy;63e0c241cfd330381aebd5893f188fa858acbf45;" # 0.1.0
[sign-plane]="https://github.com/paradedb/tantivy;63e0c241cfd330381aebd5893f188fa858acbf45;" # 0.1.0
[superkmeans-rs]="https://github.com/paradedb/superkmeans-rs;c06dc2b6e9bd15fb5c4a0627178bebbe1fb37a64;" # 0.2.0
[tantivy-bitpacker]="https://github.com/paradedb/tantivy;63e0c241cfd330381aebd5893f188fa858acbf45;tantivy-%commit%/bitpacker" # 0.10.0
[tantivy-columnar]="https://github.com/paradedb/tantivy;63e0c241cfd330381aebd5893f188fa858acbf45;tantivy-%commit%/columnar" # 0.7.0
[tantivy-common]="https://github.com/paradedb/tantivy;63e0c241cfd330381aebd5893f188fa858acbf45;tantivy-%commit%/common" # 0.11.0
[tantivy-fst]="https://github.com/paradedb/fst;1d2e473c6de63d17749030eb8538ba4d647f3430;fst-%commit%" # 0.5.0
[tantivy]="https://github.com/paradedb/tantivy;63e0c241cfd330381aebd5893f188fa858acbf45;tantivy-%commit%" # 0.27.0
[tantivy-query-grammar]="https://github.com/paradedb/tantivy;63e0c241cfd330381aebd5893f188fa858acbf45;tantivy-%commit%/query-grammar" # 0.26.0
[tantivy-sstable]="https://github.com/paradedb/tantivy;63e0c241cfd330381aebd5893f188fa858acbf45;tantivy-%commit%/sstable" # 0.7.0
[tantivy-stacker]="https://github.com/paradedb/tantivy;63e0c241cfd330381aebd5893f188fa858acbf45;tantivy-%commit%/stacker" # 0.7.0
[tantivy-tokenizer-api]="https://github.com/paradedb/tantivy;63e0c241cfd330381aebd5893f188fa858acbf45;tantivy-%commit%/tokenizer-api" # 0.7.0
#[tests]=";" # 0.26.1
)

inherit cargo lcnr postgres-multi rust sandbox-changes

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/paradedb-${PV}"
S_PARADEDB="${WORKDIR}/paradedb-${PV}"
S_PG_SEARCH="${WORKDIR}/paradedb-${PV}/pg_search"
SRC_URI="
$(cargo_crate_uris ${CRATES})
https://github.com/paradedb/paradedb/archive/refs/tags/v${PV}.tar.gz -> paradedb-${PV}.tar.gz
"

DESCRIPTION="Full text search for PostgreSQL using BM25"
HOMEPAGE="https://github.com/paradedb/paradedb/blob/main/pg_search"
LICENSE="
	(
		Old-MIT
		ZLIB
		|| (
			FTL
			GPL-2
		)
	)
	AGPL-3+
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	Boost-1.0
	BSD
	BSD-2
	CC-BY-3.0
	CC-BY-SA-4.0
	CC0-1.0
	CDLA-Permissive-2.0
	custom
	GPL-3
	ISC
	MIT
	MPL-2.0
	public-domain
	Unicode-3.0
	Unicode-DFS-2016
	ZLIB
	|| (
		Apache-2.0
		MIT
	)
"
# Third party licenses:
# AGPL-3+ - ./paradedb-0.22.2/LICENSE
# Apache-2.0 - ./cargo_home/gentoo/windows-sys-0.61.0/license-apache-2.0
# Apache-2.0-with-LLVM-exceptions - ./cargo_home/gentoo/linux-raw-sys-0.3.8/LICENSE-Apache-2.0_WITH_LLVM-exception
# Boost-1.0 - ./cargo_home/gentoo/lockfree-object-pool-0.1.6/LICENSE_1_0.txt
# BSD - ./cargo_home/gentoo/moxcms-0.7.11/LICENSE.md
# BSD-2 ./cargo_home/gentoo/human_bytes-0.4.3/LICENSE
# CC-BY-3.0 BSD MIT Apache-2.0 - ./cargo_home/gentoo/crossbeam-channel-0.5.15/LICENSE-THIRD-PARTY
# CC-BY-SA-4.0 - ./cargo_home/gentoo/petgraph-0.8.3/assets/images/LICENSE.md
# CC0-1.0 - ./cargo_home/gentoo/tiny-keccak-2.0.2/LICENSE
# CDLA-Permissive-2.0 - ./cargo_home/gentoo/webpki-roots-1.0.2/LICENSE
# custom - ./cargo_home/gentoo/image-0.24.9/tests/images/tga/testsuite/LICENSE
# GPL-3 - ./cargo_home/gentoo/rust-stemmers-1.2.0/test_data/LICENSE
# ISC - ./cargo_home/gentoo/rustls-0.23.31/LICENSE-ISC
# MIT - ./fst-11e89334c578f26f9fbafbd1122ffb220ebbdbbf/LICENSE-MIT
# MIT - ./cargo_home/gentoo/windows-sys-0.61.0/license-mit
# MPL-2.0 - ./cargo_home/gentoo/option-ext-0.2.0/LICENSE.txt
# BSD public-domain - ./cargo_home/gentoo/chrono-tz-0.10.4/tz/LICENSE
# Unicode-3.0 - ./cargo_home/gentoo/icu_normalizer_data-2.1.1/LICENSE
# Unicode-DFS-2016 - ./cargo_home/gentoo/regex-syntax-0.8.10/src/unicode_tables/LICENSE-UNICODE
# ZLIB - ./cargo_home/gentoo/bytemuck_derive-1.10.2/LICENSE-ZLIB
# || ( FTL GPL-2 ) Old-MIT ZLIB - ./cargo_home/gentoo/freetype-sys-0.20.1/freetype2/LICENSE.TXT
# || ( Apache-2.0 MIT ) - ./cargo_home/gentoo/lexical-parse-float-1.0.6/LICENSE.md
SLOT="0"
IUSE="
${CPU_FLAGS_X86[@]}
debug
ebuild_revision_1
"
RESTRICT="mirror" # Speed up downloads, bypass server banner
REQUIRED_USE="
	${POSTGRES_REQ_USE}
"
RDEPEND="
	${POSTGRES_DEP}
"
DEPEND="
	${RDEPEND}
"
# Requirement in https://github.com/paradedb/paradedb/blob/v0.26.1/Cargo.toml#L67
BDEPEND="
	=dev-util/cargo-pgrx-0.19*:=
"

pkg_setup() {
	# Both are required
	sandbox-changes_no_network_sandbox "To download cargo metadata" # Still required if set to offline in cargo_home/cargo.toml
	sandbox-changes_no_feature "sandbox" "To download cargo metadata" # Still required if network sandbox disabled

	postgres-multi_pkg_setup
	rust_pkg_setup
}

src_unpack() {
	unpack "paradedb-${PV}.tar.gz"
#	die
einfo "Calling cargo_src_unpack"
	cargo_src_unpack
	if [[ -e "${FILESDIR}/${PV}/Cargo.lock" ]] ; then
einfo "Restoring lockfiles"
		cp -vaT \
			"${FILESDIR}/${PV}" \
			"${WORKDIR}/paradedb-${PV}" \
			|| die
	fi
}

is_x86_isa_level1() {
	has_all_flags=1
	local x
	for x in "${CPU_FLAGS_X86_ISA1[@]}" ; do
		if ! use "${x}" ; then
			has_all_flags=0
			break
		fi
	done

	if (( ${has_all_flags} == 1 )) ; then
		return 0
	else
		return 1
	fi
}

is_x86_isa_level2() {
	has_all_flags=1
	local x
	for x in "${CPU_FLAGS_X86_ISA2[@]}" ; do
		if ! use "${x}" ; then
			has_all_flags=0
			break
		fi
	done

	if (( ${has_all_flags} == 1 )) ; then
		return 0
	else
		return 1
	fi
}

is_x86_isa_level3() {
	has_all_flags=1
	local x
	for x in "${CPU_FLAGS_X86_ISA3[@]}" ; do
		if ! use "${x}" ; then
			has_all_flags=0
			break
		fi
	done

	if (( ${has_all_flags} == 1 )) ; then
		return 0
	else
		return 1
	fi
}

is_x86_isa_level4() {
	has_all_flags=1
	local x
	for x in "${CPU_FLAGS_X86_ISA4[@]}" ; do
		if ! use "${x}" ; then
			has_all_flags=0
			break
		fi
	done

	if (( ${has_all_flags} == 1 )) ; then
		return 0
	else
		return 1
	fi
}

src_prepare() {
	default
	cd "${WORKDIR}" || die
	eapply "${FILESDIR}/${PN}-0.23.2-unify-tantivy-tokenizer-api-to-paradedb-fork.patch"
	eapply "${FILESDIR}/${PN}-0.23.2-tantivy-jieba-use-paradedb-fork.patch"
}

src_configure() {
	if [[ "${ABI}" == "amd64" ]] ; then
		if is_x86_isa_level4 ; then
einfo "Detected X86-64 ISA Level 4"
			export RUSTFLAGS=" -C target-cpu=x86-64-v4"
		elif is_x86_isa_level3 ; then
einfo "Detected X86-64 ISA Level 3"
			export RUSTFLAGS=" -C target-cpu=x86-64-v3"
		elif is_x86_isa_level2 ; then
einfo "Detected X86-64 ISA Level 2"
			export RUSTFLAGS=" -C target-cpu=x86-64-v2"
		elif is_x86_isa_level1 ; then
einfo "Detected X86-64 ISA Level 1"
			export RUSTFLAGS=" -C target-cpu=x86-64"
		else
eerror "CPU is not supported.  Make sure that the cpu_flags_x86_* flags are updated for ${CATEGORY}/${PN}."
			die
		fi
	fi
	cargo_src_configure

	# Required to download cargo metadata
	sed -i -e "s|offline = true|offline = false|g" "${WORKDIR}/cargo_home/config.toml" || die

	postgres-multi_foreach_src_configure() {
		:
	}
	postgres-multi_foreach postgres-multi_foreach_src_configure
}

src_compile() {
	local configuration=$(usex debug "--debug" "")
	postgres-multi_foreach_src_compile() {
einfo "CARGO:  ${CARGO}"
einfo "PG_CONFIG:  ${PG_CONFIG}"
einfo "PG_SLOT:  ${PG_SLOT}"

		pushd "${S_PG_SEARCH}" 2>/dev/null 2>&1 || die
	# Generate build directory
			cargo pgrx init --pg${PG_SLOT}="${PG_CONFIG}"

einfo "Building for PostgreSQL ${PG_SLOT}"
			"${CARGO}" pgrx package \
				--pg-config="${PG_CONFIG}" \
				${configuration} \
				|| die "cargo pgrx install failed for PostgreSQL ${PG_SLOT}"
		popd 2>/dev/null 2>&1 || die
	}

	postgres-multi_foreach postgres-multi_foreach_src_compile
}

src_install() {
	local configuration=$(usex debug "debug" "release")
	postgres-multi_foreach_src_install() {
einfo "Installing for PostgreSQL ${PG_SLOT}"
		pushd "${S_PARADEDB}/target/${configuration}/pg_search-pg${PG_SLOT}" || die
			doins -r *
			local libdir=$(get_libdir)
			fperms 0644 "/usr/${libdir}/postgresql-${PG_SLOT}/${libdir}/pg_search.so"
		popd || die
	}

	postgres-multi_foreach postgres-multi_foreach_src_install

	# Copy all the Licenses, Copyright Notices, Readmes
        LCNR_SOURCE="${WORKDIR}/cargo_home/gentoo"
        LCNR_TAG="third_party"
	lcnr_install_files

        LCNR_SOURCE="${WORKDIR}/datafusion-${DATAFUSION_COMMIT}"
        LCNR_TAG="datafusion"
	lcnr_install_files

        LCNR_SOURCE="${WORKDIR}/fst-${FST_COMMIT}"
        LCNR_TAG="fst"
	lcnr_install_files

        LCNR_SOURCE="${WORKDIR}/tantivy-${TANTIVY_COMMIT}"
        LCNR_TAG="tantivy"
	lcnr_install_files

        LCNR_SOURCE="${WORKDIR}/paradedb-${PV}"
        LCNR_TAG="paradedb"
	lcnr_install_files
}
