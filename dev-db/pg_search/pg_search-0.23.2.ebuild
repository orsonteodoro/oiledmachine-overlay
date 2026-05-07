# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D12, D13, RH9, RH10, U22, U24

# The patches were based on AI generated code samples.

POSTGRES_COMPAT=( {15..19} )
POSTGRES_USEDEP="server"
RUST_MAX_VER="1.91.1"
RUST_MIN_VER="1.91.1" # LLVM 21.1
RUST_PV="${RUST_MIN_VER}"

DATAFUSION_COMMIT="eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf"
FST_COMMIT="11e89334c578f26f9fbafbd1122ffb220ebbdbbf"
TANTIVY_COMMIT="84025b075a6ea71be2b9b2ba77ae30cd208ca3f5"

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
benchmarks-0.23.2
macros-0.23.2
pg_search-0.23.2
stressgres-0.23.2
tests-0.23.2
tokenizers-0.23.2
"

# Use only upstream lockfile.
CRATES="
adler2-2.0.1
adler32-1.2.0
ahash-0.7.8
ahash-0.8.12
aho-corasick-1.1.4
aligned-0.4.3
aligned-vec-0.6.4
allocator-api2-0.2.21
android_system_properties-0.1.5
annotate-snippets-0.11.5
anstream-1.0.0
anstyle-1.0.14
anstyle-parse-1.0.0
anstyle-query-1.1.5
anstyle-wincon-3.0.11
anyhow-1.0.102
approx-0.5.1
arbitrary-1.4.2
arc-swap-1.9.1
arg_enum_proc_macro-0.3.4
arrayvec-0.7.6
arrow-58.2.0
arrow-arith-58.2.0
arrow-array-58.2.0
arrow-buffer-58.2.0
arrow-cast-58.2.0
arrow-csv-58.2.0
arrow-data-58.2.0
arrow-ipc-58.2.0
arrow-json-58.2.0
arrow-ord-58.2.0
arrow-row-58.2.0
arrow-schema-58.2.0
arrow-select-58.2.0
arrow-string-58.2.0
as-slice-0.2.1
async-attributes-1.1.2
async-channel-1.9.0
async-channel-2.5.0
async-executor-1.14.0
async-global-executor-2.4.1
async-io-1.13.0
async-io-2.6.0
async-lock-2.8.0
async-lock-3.4.2
async-std-1.13.2
async-stream-0.3.6
async-stream-impl-0.3.6
async-task-4.7.1
async-trait-0.1.89
atoi-2.0.0
atomic-waker-1.1.2
autocfg-1.5.0
av1-grain-0.2.5
avif-serialize-0.8.8
av-scenechange-0.14.1
aws-lc-rs-1.16.3
aws-lc-sys-0.40.0
base64-0.22.1
base64ct-1.8.3
bigdecimal-0.4.10
bincode-2.0.1
bindgen-0.72.1
bit_field-0.10.3
bitflags-1.3.2
bitflags-2.11.1
bitpacking-0.9.3
bit-set-0.8.0
bitstream-io-4.10.0
bit-vec-0.8.0
bitvec-1.0.1
block-buffer-0.10.4
block-buffer-0.12.0
blocking-1.6.2
bon-3.9.1
bon-macros-3.9.1
borsh-1.6.1
borsh-derive-1.6.1
built-0.8.0
bumpalo-3.20.2
bytecheck-0.6.12
bytecheck-0.8.2
bytecheck_derive-0.6.12
bytecheck_derive-0.8.2
bytemuck-1.25.0
bytemuck_derive-1.10.2
byteorder-1.5.0
byteorder-lite-0.1.0
bytes-1.11.1
camino-1.2.2
cargo_metadata-0.18.1
cargo_metadata-0.23.1
cargo-platform-0.1.9
cargo-platform-0.3.3
cargo_toml-0.21.0
cargo_toml-0.22.3
cast-0.3.0
castaway-0.2.4
cc-1.2.61
cedarwood-0.4.6
cee-scape-0.2.0
census-0.4.2
cexpr-0.6.0
cfg_aliases-0.2.1
cfg-if-1.0.4
chacha20-0.10.0
chrono-0.4.44
chrono-tz-0.10.4
clang-sys-1.8.1
clap-4.6.1
clap_builder-4.6.0
clap-cargo-0.14.1
clap_derive-4.6.1
clap_lex-1.1.0
cmake-0.1.58
cmd_lib-1.9.6
cmd_lib_macros-1.9.6
cmov-0.5.3
cobs-0.3.0
codepage-0.1.2
colorchoice-1.0.5
color_quant-1.1.0
combine-4.6.7
comfy-table-7.1.4
compact_str-0.8.1
concurrent-queue-2.5.0
const-oid-0.10.2
const-oid-0.9.6
const-random-0.1.18
const-random-macro-0.1.16
convert_case-0.10.0
convert_case-0.8.0
core-foundation-0.10.1
core-foundation-0.9.4
core-foundation-sys-0.8.7
core-graphics-0.23.2
core-graphics-types-0.1.3
core_maths-0.1.1
core-text-20.1.0
cpufeatures-0.2.17
cpufeatures-0.3.0
crc32fast-1.5.0
crc-3.4.0
crc-catalog-2.5.0
crossbeam-channel-0.5.15
crossbeam-deque-0.8.6
crossbeam-epoch-0.9.18
crossbeam-queue-0.3.12
crossbeam-utils-0.8.21
crossterm-0.28.1
crossterm_winapi-0.9.1
crunchy-0.2.4
crypto-common-0.1.7
crypto-common-0.2.1
csv-1.4.0
csv-core-0.1.13
ctutils-0.4.2
cursive-0.21.1
cursive_core-0.4.6
cursive-macros-0.1.0
cursive-multiplex-0.7.0
cursive_table_view-0.15.0
darling-0.20.11
darling-0.21.3
darling-0.23.0
darling_core-0.20.11
darling_core-0.21.3
darling_core-0.23.0
darling_macro-0.20.11
darling_macro-0.21.3
darling_macro-0.23.0
dary_heap-0.3.9
dashmap-6.1.0
decimal-bytes-0.4.2
der-0.7.10
deranged-0.4.0
deranged-0.5.8
derive_arbitrary-1.4.2
derive_builder-0.20.2
derive_builder_core-0.20.2
derive_builder_macro-0.20.2
derive_more-2.1.1
derive_more-impl-2.1.1
diff-0.1.13
digest-0.10.7
digest-0.11.3
dirs-6.0.0
dirs-sys-0.5.0
displaydoc-0.2.5
dlib-0.5.3
dotenvy-0.15.7
downcast-rs-2.0.2
duckdb-1.10502.0
dunce-1.0.5
dwrote-0.11.5
either-1.15.0
embedded-io-0.4.0
embedded-io-0.6.1
emoji-0.2.1
encoding-0.2.33
encoding-index-japanese-1.20141219.5
encoding-index-korean-1.20141219.5
encoding-index-simpchinese-1.20141219.5
encoding-index-singlebyte-1.20141219.5
encoding_index_tests-0.1.4
encoding-index-tradchinese-1.20141219.5
encoding_rs-0.8.35
encoding_rs_io-0.1.7
enum-map-2.7.3
enum-map-derive-0.17.0
enumset-1.1.10
enumset_derive-0.14.0
env_filter-1.0.1
env_logger-0.10.2
env_logger-0.11.10
equator-0.4.2
equator-macro-0.4.2
equivalent-1.0.2
erased-serde-0.4.10
errno-0.3.14
etcetera-0.8.0
event-listener-2.5.3
event-listener-5.4.1
event-listener-strategy-0.5.4
exr-1.74.0
eyre-0.6.12
faccess-0.2.4
fallible-iterator-0.2.0
fallible-iterator-0.3.0
fallible-streaming-iterator-0.1.9
fastdivide-0.4.2
fastrand-1.9.0
fastrand-2.4.1
fax-0.2.7
fdeflate-0.3.7
filetime-0.2.27
find-msvc-tools-0.1.9
fixedbitset-0.5.7
flatbuffers-25.12.19
flate2-1.1.9
float-ord-0.3.2
flume-0.11.1
fnv-1.0.7
foldhash-0.1.5
foldhash-0.2.0
font-kit-0.14.3
foreign-types-0.3.2
foreign-types-0.5.0
foreign-types-macros-0.2.3
foreign-types-shared-0.1.1
foreign-types-shared-0.3.1
form_urlencoded-1.2.2
freetype-sys-0.20.1
fs_extra-1.3.0
funty-2.0.0
futures-0.3.32
futures-channel-0.3.32
futures-core-0.3.32
futures-executor-0.3.32
futures-intrusive-0.5.0
futures-io-0.3.32
futures-lite-1.13.0
futures-lite-2.6.1
futures-macro-0.3.32
futures-sink-0.3.32
futures-task-0.3.32
futures-timer-3.0.3
futures-util-0.3.32
fuzzy-matcher-0.3.7
fxhash-0.2.1
generic-array-0.14.7
getrandom-0.1.16
getrandom-0.2.17
getrandom-0.3.4
getrandom-0.4.2
gif-0.12.0
gif-0.14.2
git2-0.20.4
glob-0.3.3
gloo-timers-0.3.0
half-1.8.3
half-2.7.1
hashbrown-0.12.3
hashbrown-0.14.5
hashbrown-0.15.5
hashbrown-0.16.1
hashbrown-0.17.0
hashlink-0.10.0
heck-0.5.0
hermit-abi-0.3.9
hermit-abi-0.5.2
hex-0.4.3
hkdf-0.12.4
hmac-0.12.1
hmac-0.13.0
home-0.5.12
htmlescape-0.3.1
http-1.4.0
httparse-1.10.1
http-body-1.0.1
http-body-util-0.1.3
human_bytes-0.4.3
humantime-2.3.0
hybrid-array-0.4.11
hyper-1.9.0
hyperloglogplus-0.4.1
hyper-rustls-0.27.9
hyper-util-0.1.20
iana-time-zone-0.1.65
iana-time-zone-haiku-0.1.2
icu_collections-2.2.0
icu_locale-2.2.0
icu_locale_core-2.2.0
icu_locale_data-2.2.0
icu_normalizer-2.2.0
icu_normalizer_data-2.2.0
icu_properties-2.2.0
icu_properties_data-2.2.0
icu_provider-2.2.0
icu_segmenter-2.2.0
icu_segmenter_data-2.2.0
id-arena-2.3.0
ident_case-1.0.1
idna-1.1.0
idna_adapter-1.2.2
image-0.24.9
image-0.25.9
image-webp-0.2.4
imgref-1.12.1
include-flate-0.3.0
include-flate-codegen-0.2.0
indenter-0.3.4
indexmap-2.14.0
indextree-4.8.1
indextree-macros-0.1.3
instant-0.1.13
interpolate_name-0.2.4
inventory-0.3.24
io-lifetimes-1.0.11
ipnet-2.12.0
iri-string-0.7.12
is_ci-1.2.0
is-terminal-0.4.17
is_terminal_polyfill-1.70.2
itertools-0.13.0
itertools-0.14.0
itertools-0.9.0
itoa-1.0.18
jieba-macros-0.7.1
jieba-macros-0.8.1
jieba-rs-0.7.4
jieba-rs-0.8.0
jiff-0.2.24
jiff-static-0.2.24
jni-0.22.4
jni-macros-0.22.4
jni-sys-0.4.1
jni-sys-macros-0.4.1
jobserver-0.1.34
jpeg-decoder-0.3.2
json5-0.4.1
js-sys-0.3.97
kanaria-0.2.0
kv-log-macro-1.0.7
lazy_static-1.5.0
leb128fmt-0.1.0
lebe-0.5.3
levenshtein_automata-0.2.1
lexical-core-1.0.6
lexical-parse-float-1.0.6
lexical-parse-integer-1.0.6
lexical-util-1.0.7
lexical-write-float-1.0.6
lexical-write-integer-1.0.6
libc-0.2.186
libduckdb-sys-1.10502.0
libflate-2.3.0
libflate_lz77-2.3.0
libfuzzer-sys-0.4.12
libgit2-sys-0.18.3+1.9.2
libloading-0.8.9
libm-0.2.16
libredox-0.1.16
libsqlite3-sys-0.30.1
libz-sys-1.1.28
lindera-1.5.1
lindera-cc-cedict-1.5.1
lindera-dictionary-1.5.1
lindera-ipadic-1.5.1
lindera-ipadic-neologd-1.5.1
lindera-ko-dic-1.5.1
lindera-unidic-1.5.1
linux-raw-sys-0.12.1
linux-raw-sys-0.3.8
linux-raw-sys-0.4.15
litemap-0.8.2
lock_api-0.4.14
lockfree-object-pool-0.1.6
log-0.4.29
loop9-0.1.5
lru-0.16.4
lru-slab-0.1.2
lz4_flex-0.12.1
lz4_flex-0.13.0
maybe-rayon-0.1.1
md-5-0.10.6
md-5-0.11.0
md5-0.8.0
measure_time-0.9.0
memchr-2.8.0
memmap2-0.9.10
memoffset-0.9.1
minimal-lexical-0.2.1
miniz_oxide-0.8.9
mio-1.2.0
moxcms-0.7.11
munge-0.4.7
munge_macro-0.4.7
murmurhash32-0.3.1
new_debug_unreachable-1.0.6
nom-7.1.3
nom-8.0.0
noop_proc_macro-0.3.0
no_std_io2-0.9.3
ntapi-0.4.3
num-0.4.3
num-bigint-0.4.6
num-bigint-dig-0.8.6
num-complex-0.4.6
num-conv-0.2.1
num_cpus-1.17.0
num-derive-0.4.2
num-integer-0.1.46
num-iter-0.1.45
num-rational-0.4.2
num_threads-0.1.7
num-traits-0.2.19
objc2-core-foundation-0.3.2
objc2-io-kit-0.3.2
objc2-system-configuration-0.3.2
object_store-0.13.2
once_cell-1.21.4
once_cell_polyfill-1.70.2
oneshot-0.1.13
opencc-jieba-rs-0.7.5
openssl-0.10.79
openssl-macros-0.1.1
openssl-probe-0.2.1
openssl-sys-0.9.115
option-ext-0.2.0
ordered-float-4.6.0
ordered-float-5.3.0
os_pipe-1.2.3
owo-colors-4.3.0
parking-2.2.1
parking_lot-0.12.5
parking_lot_core-0.9.12
paste-1.0.15
pastey-0.1.1
pathfinder_geometry-0.5.1
pathfinder_simd-0.5.6
pathsearch-0.2.0
pem-rfc7468-0.7.0
percent-encoding-2.3.2
permutation-0.4.1
pest-2.8.6
pest_derive-2.8.6
pest_generator-2.8.6
pest_meta-2.8.6
petgraph-0.8.3
pgrx-0.18.0
pgrx-bindgen-0.18.0
pgrx-macros-0.18.0
pgrx-pg-config-0.13.1
pgrx-pg-config-0.18.0
pgrx-pg-sys-0.18.0
pgrx-sql-entity-graph-0.18.0
pgrx-tests-0.18.0
pgvector-0.4.1
phf-0.11.3
phf-0.12.1
phf-0.13.1
phf-0.8.0
phf_codegen-0.11.3
phf_codegen-0.13.1
phf_generator-0.11.3
phf_generator-0.13.1
phf_generator-0.8.0
phf_macros-0.8.0
phf_shared-0.11.3
phf_shared-0.12.1
phf_shared-0.13.1
phf_shared-0.8.0
pin-project-lite-0.2.17
pin-utils-0.1.0
piper-0.2.5
pkcs1-0.7.5
pkcs8-0.10.2
pkg-config-0.3.33
plain-0.2.3
plotters-0.3.7
plotters-backend-0.3.7
plotters-bitmap-0.3.7
plotters-svg-0.3.7
png-0.17.16
png-0.18.1
polling-2.8.0
polling-3.11.0
portable-atomic-1.13.1
portable-atomic-util-0.2.7
postcard-1.1.3
postgres-0.19.13
postgres-openssl-0.5.3
postgres-protocol-0.6.11
postgres-types-0.2.13
potential_utf-0.1.5
powerfmt-0.2.0
ppv-lite86-0.2.21
precis-core-0.1.11
precis-profiles-0.1.13
precis-tools-0.1.9
pretty_assertions-1.4.1
prettyplease-0.2.37
proc-macro2-1.0.106
proc-macro-crate-3.5.0
proc-macro-error2-2.0.1
proc-macro-error-attr2-2.0.0
proc-macro-hack-0.5.20+deprecated
profiling-1.0.18
profiling-procmacros-1.0.18
proptest-1.11.0
proptest-derive-0.6.0
prost-0.14.3
prost-derive-0.14.3
ptr_meta-0.1.4
ptr_meta-0.3.1
ptr_meta_derive-0.1.4
ptr_meta_derive-0.3.1
pxfm-0.1.29
qoi-0.4.1
quick-error-1.2.3
quick-error-2.0.1
quinn-0.11.9
quinn-proto-0.11.14
quinn-udp-0.5.14
quote-1.0.45
radium-0.7.0
rancor-0.1.1
rand-0.10.1
rand-0.7.3
rand-0.8.6
rand-0.9.4
rand_chacha-0.2.2
rand_chacha-0.3.1
rand_chacha-0.9.0
rand_core-0.10.1
rand_core-0.5.1
rand_core-0.6.4
rand_core-0.9.5
rand_distr-0.4.3
rand_hc-0.2.0
rand_pcg-0.2.1
rand_xorshift-0.4.0
rav1e-0.8.1
ravif-0.12.0
rayon-1.10.0
rayon-core-1.12.1
redox_syscall-0.5.18
redox_syscall-0.7.4
redox_users-0.5.2
r-efi-5.3.0
r-efi-6.0.0
regex-1.12.3
regex-automata-0.4.14
regex-lite-0.1.9
regex-syntax-0.8.10
relative-path-1.9.3
rend-0.4.2
rend-0.5.3
reqwest-0.12.28
reqwest-0.13.3
rgb-0.8.53
ring-0.17.14
rkyv-0.7.46
rkyv-0.8.16
rkyv_derive-0.7.46
rkyv_derive-0.8.16
rle-decode-fast-1.0.3
rsa-0.9.10
rstest-0.25.0
rstest_macros-0.25.0
rustc-hash-2.1.2
rustc_version-0.4.1
rust_decimal-1.41.0
rustix-0.37.28
rustix-0.38.44
rustix-1.1.4
rustls-0.23.40
rustls-native-certs-0.8.3
rustls-pki-types-1.14.1
rustls-platform-verifier-0.7.0
rustls-platform-verifier-android-0.1.1
rustls-webpki-0.103.13
rust-stemmers-1.2.0
rustversion-1.0.22
rusty-fork-0.3.1
ryu-1.0.23
same-file-1.0.6
schannel-0.1.29
scopeguard-1.2.0
seahash-4.1.0
security-framework-3.7.0
security-framework-sys-2.17.0
semver-1.0.28
serde-1.0.228
serde_cbor-0.11.2
serde_core-1.0.228
serde_derive-1.0.228
serde_json-1.0.149
serde_path_to_error-0.1.20
serde_spanned-0.6.9
serde_spanned-1.1.1
serde_urlencoded-0.7.1
serde_yaml_ng-0.10.0
sha1-0.10.6
sha2-0.10.9
sha2-0.11.0
shlex-1.3.0
shutdown_hooks-0.1.0
signal-hook-0.3.18
signal-hook-mio-0.2.5
signal-hook-registry-1.4.8
signature-2.2.0
simd-adler32-0.3.9
simd_cesu8-1.1.1
simd_helpers-0.1.0
simdutf8-0.1.5
siphasher-0.3.11
siphasher-1.0.3
sketches-ddsketch-0.3.1
slab-0.4.12
smallvec-1.15.1
soa_derive-0.14.0
soa_derive_internal-0.14.0
socket2-0.4.10
socket2-0.6.3
spin-0.9.8
spki-0.7.3
sqlx-0.8.6
sqlx-core-0.8.6
sqlx-macros-0.8.6
sqlx-macros-core-0.8.6
sqlx-mysql-0.8.6
sqlx-postgres-0.8.6
sqlx-sqlite-0.8.6
stable_deref_trait-1.2.1
static_assertions-1.1.0
stringprep-0.1.5
strsim-0.11.1
strum-0.27.2
strum_macros-0.27.2
subtle-2.6.1
supports-color-2.1.0
supports-color-3.0.2
syn-1.0.109
syn-2.0.117
sync_wrapper-1.0.2
synstructure-0.13.2
sysinfo-0.33.1
sysinfo-0.34.2
sysinfo-0.37.2
tantivy-jieba-0.18.0
tantivy-stemmers-0.4.0
tap-1.0.1
tar-0.4.45
tempfile-3.27.0
termcolor-1.4.1
thiserror-1.0.69
thiserror-2.0.18
thiserror-impl-1.0.69
thiserror-impl-2.0.18
thread_local-1.1.9
tiff-0.10.3
time-0.3.47
time-core-0.1.8
time-macros-0.2.27
tiny-keccak-2.0.2
tinystr-0.8.3
tinyvec-1.11.0
tinyvec_macros-0.1.1
tokio-1.52.2
tokio-macros-2.7.0
tokio-openssl-0.6.5
tokio-postgres-0.7.17
tokio-rustls-0.26.4
tokio-stream-0.1.18
tokio-util-0.7.18
toml-0.8.23
toml-0.9.12+spec-1.1.0
toml_datetime-0.6.11
toml_datetime-0.7.5+spec-1.1.0
toml_datetime-1.1.1+spec-1.1.0
toml_edit-0.22.27
toml_edit-0.25.11+spec-1.1.0
toml_parser-1.1.2+spec-1.1.0
toml_write-0.1.2
toml_writer-1.1.1+spec-1.1.0
tower-0.5.3
tower-http-0.6.8
tower-layer-0.3.3
tower-service-0.3.3
tracing-0.1.44
tracing-attributes-0.1.31
tracing-core-0.1.36
try-lock-0.2.5
ttf-parser-0.20.0
twox-hash-2.1.2
typeid-1.0.3
typenum-1.20.0
typetag-0.2.21
typetag-impl-0.2.21
ucd-parse-0.1.13
ucd-trie-0.1.7
unarray-0.1.4
unescape-0.1.0
unicode-bidi-0.3.18
unicode-blocks-0.1.9
unicode-ident-1.0.24
unicode-normalization-0.1.25
unicode-properties-0.1.4
unicode-segmentation-1.13.2
unicode-width-0.1.14
unicode-width-0.2.2
unicode-xid-0.2.6
unsafe-libyaml-0.2.11
untrusted-0.9.0
unty-0.0.4
url-2.5.8
utf8_iter-1.0.4
utf8parse-0.2.2
utf8-ranges-1.0.5
uuid-1.23.1
value-bag-1.12.0
vcpkg-0.2.15
vergen-9.1.0
vergen-git2-9.1.0
vergen-lib-9.1.0
version_check-0.9.5
v_frame-0.3.9
wait-timeout-0.2.1
waker-fn-1.2.0
walkdir-2.5.0
want-0.3.1
wasi-0.11.1+wasi-snapshot-preview1
wasi-0.14.7+wasi-0.2.4
wasi-0.9.0+wasi-snapshot-preview1
wasip2-1.0.3+wasi-0.2.9
wasip3-0.4.0+wasi-0.3.0-rc-2026-01-06
wasite-0.1.0
wasite-1.0.2
wasm-bindgen-0.2.120
wasm-bindgen-futures-0.4.70
wasm-bindgen-macro-0.2.120
wasm-bindgen-macro-support-0.2.120
wasm-bindgen-shared-0.2.120
wasm-encoder-0.244.0
wasm-metadata-0.244.0
wasmparser-0.244.0
webpki-root-certs-1.0.7
webpki-roots-1.0.7
web-sys-0.3.97
web-time-1.1.0
weezl-0.1.12
whoami-1.6.1
whoami-2.1.2
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.11
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.57.0
windows-0.61.3
windows_aarch64_gnullvm-0.48.5
windows_aarch64_gnullvm-0.52.6
windows_aarch64_gnullvm-0.53.1
windows_aarch64_msvc-0.48.5
windows_aarch64_msvc-0.52.6
windows_aarch64_msvc-0.53.1
windows-collections-0.2.0
windows-core-0.57.0
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
windows-implement-0.57.0
windows-implement-0.60.2
windows-interface-0.57.0
windows-interface-0.59.3
windows-link-0.1.3
windows-link-0.2.1
windows-numerics-0.2.0
windows-result-0.1.2
windows-result-0.3.4
windows-result-0.4.1
windows-strings-0.4.2
windows-strings-0.5.1
windows-sys-0.48.0
windows-sys-0.52.0
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
wio-0.2.2
wit-bindgen-0.51.0
wit-bindgen-0.57.1
wit-bindgen-core-0.51.0
wit-bindgen-rust-0.51.0
wit-bindgen-rust-macro-0.51.0
wit-component-0.244.0
wit-parser-0.244.0
writeable-0.6.3
wyz-0.5.1
xattr-1.6.1
xi-unicode-0.3.0
y4m-0.8.0
yada-0.5.1
yansi-1.0.1
yeslogic-fontconfig-sys-6.0.1
yoke-0.8.2
yoke-derive-0.8.2
zerocopy-0.8.48
zerocopy-derive-0.8.48
zerofrom-0.1.7
zerofrom-derive-0.1.7
zeroize-1.8.2
zerotrie-0.2.4
zerovec-0.11.6
zerovec-derive-0.11.3
zip-6.0.0
zlib-rs-0.6.3
zmij-1.0.21
zopfli-0.8.3
zstd-0.13.3
zstd-safe-7.2.4
zstd-sys-2.0.16+zstd.1.5.7
zune-core-0.4.12
zune-core-0.5.1
zune-inflate-0.2.54
zune-jpeg-0.4.21
zune-jpeg-0.5.15
"

declare -A GIT_CRATES=(
# Replace datafusion-53 with datafusion
[datafusion-catalog]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/catalog" # 53.1.0
[datafusion-catalog-listing]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/catalog-listing" # 53.1.0
[datafusion-common]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/common" # 53.1.0
[datafusion-common-runtime]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/common-runtime" # 53.1.0
[datafusion-datasource-arrow]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/datasource-arrow" # 53.1.0
[datafusion-datasource-csv]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/datasource-csv" # 53.1.0
[datafusion-datasource]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/datasource" # 53.1.0
[datafusion-datasource-json]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/datasource-json" # 53.1.0
[datafusion-doc]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/doc" # 53.1.0
[datafusion-execution]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/execution" # 53.1.0
[datafusion-expr-common]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/expr-common" # 53.1.0
[datafusion-expr]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/expr" # 53.1.0
[datafusion-functions-aggregate-common]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/functions-aggregate-common" # 53.1.0
[datafusion-functions-aggregate]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/functions-aggregate" # 53.1.0
[datafusion-functions]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/functions" # 53.1.0
[datafusion-functions-table]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/functions-table" # 53.1.0
[datafusion-functions-window-common]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/functions-window-common" # 53.1.0
[datafusion-functions-window]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/functions-window" # 53.1.0
[datafusion]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/core" # 53.1.0
[datafusion-macros]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/macros" # 53.1.0
[datafusion-optimizer]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/optimizer" # 53.1.0
[datafusion-physical-expr-adapter]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/physical-expr-adapter" # 53.1.0
[datafusion-physical-expr-common]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/physical-expr-common" # 53.1.0
[datafusion-physical-expr]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/physical-expr" # 53.1.0
[datafusion-physical-optimizer]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/physical-optimizer" # 53.1.0
[datafusion-physical-plan]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/physical-plan" # 53.1.0
[datafusion-proto-common]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/proto-common" # 53.1.0
[datafusion-proto]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/proto" # 53.1.0
[datafusion-pruning]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/pruning" # 53.1.0
[datafusion-session]="https://github.com/apache/datafusion;eae7bf4fa1c037c0a065d1f36d0669f5bb97a9cf;datafusion-%commit%/datafusion/session" # 53.1.0
[ownedbytes]="https://github.com/paradedb/tantivy;84025b075a6ea71be2b9b2ba77ae30cd208ca3f5;tantivy-%commit%/ownedbytes" # 0.9.0
[tantivy-bitpacker]="https://github.com/paradedb/tantivy;84025b075a6ea71be2b9b2ba77ae30cd208ca3f5;tantivy-%commit%/bitpacker" # 0.9.0
[tantivy-columnar]="https://github.com/paradedb/tantivy;84025b075a6ea71be2b9b2ba77ae30cd208ca3f5;tantivy-%commit%/columnar" # 0.6.0
[tantivy-common]="https://github.com/paradedb/tantivy;84025b075a6ea71be2b9b2ba77ae30cd208ca3f5;tantivy-%commit%/common" # 0.10.0
[tantivy-fst]="https://github.com/paradedb/fst;11e89334c578f26f9fbafbd1122ffb220ebbdbbf;fst-%commit%" # 0.5.0
[tantivy]="https://github.com/paradedb/tantivy;84025b075a6ea71be2b9b2ba77ae30cd208ca3f5;tantivy-%commit%" # 0.26.0
[tantivy-query-grammar]="https://github.com/paradedb/tantivy;84025b075a6ea71be2b9b2ba77ae30cd208ca3f5;tantivy-%commit%/query-grammar" # 0.25.0
[tantivy-sstable]="https://github.com/paradedb/tantivy;84025b075a6ea71be2b9b2ba77ae30cd208ca3f5;tantivy-%commit%/sstable" # 0.6.0
[tantivy-stacker]="https://github.com/paradedb/tantivy;84025b075a6ea71be2b9b2ba77ae30cd208ca3f5;tantivy-%commit%/stacker" # 0.6.0
[tantivy-tokenizer-api]="https://github.com/paradedb/tantivy;84025b075a6ea71be2b9b2ba77ae30cd208ca3f5;tantivy-%commit%/tokenizer-api" # 0.6.0
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
BDEPEND="
	=dev-util/cargo-pgrx-0.18*
	dev-util/cargo-pgrx:=
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
