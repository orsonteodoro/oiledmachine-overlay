# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D12, D13, RH9, RH10, U22, U24

POSTGRES_COMPAT=( {15..19} )
POSTGRES_USEDEP="server"
RUST_MAX_VER="1.90.0" # Inclusive
RUST_MIN_VER="1.90.0" # llvm-20.1
RUST_PV="${RUST_MIN_VER}"

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
benchmarks-0.22.2
macros-0.22.2
pg_search-0.22.2
stressgres-0.22.2
tests-0.22.2
"

# Use only upstream lockfile.
CRATES="
addr2line-0.25.1
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
anstream-0.6.21
anstyle-1.0.13
anstyle-parse-0.2.7
anstyle-query-1.1.5
anstyle-wincon-3.0.10
anyhow-1.0.100
approx-0.5.1
arbitrary-1.4.2
arc-swap-1.7.1
arg_enum_proc_macro-0.3.4
arrayvec-0.7.6
arrow-58.0.0
arrow-arith-58.0.0
arrow-array-58.0.0
arrow-buffer-58.0.0
arrow-cast-58.0.0
arrow-csv-58.0.0
arrow-data-58.0.0
arrow-ipc-58.0.0
arrow-json-58.0.0
arrow-ord-58.0.0
arrow-row-58.0.0
arrow-schema-58.0.0
arrow-select-58.0.0
arrow-string-58.0.0
as-slice-0.2.1
async-attributes-1.1.2
async-channel-1.9.0
async-channel-2.5.0
async-executor-1.13.3
async-global-executor-2.4.1
async-io-1.13.0
async-io-2.6.0
async-lock-2.8.0
async-lock-3.4.1
async-std-1.13.2
async-stream-0.3.6
async-stream-impl-0.3.6
async-task-4.7.1
async-trait-0.1.89
atoi-2.0.0
atomic-waker-1.1.2
autocfg-1.5.0
av1-grain-0.2.5
avif-serialize-0.8.6
av-scenechange-0.14.1
backtrace-0.3.76
base64-0.22.1
base64ct-1.8.0
bigdecimal-0.4.9
bincode-2.0.1
bincode_derive-2.0.1
bindgen-0.72.1
bit_field-0.10.3
bitflags-1.3.2
bitflags-2.10.0
bitpacking-0.9.3
bit-set-0.8.0
bitstream-io-4.9.0
bit-vec-0.8.0
bitvec-1.0.1
block-buffer-0.10.4
blocking-1.6.2
bon-3.7.2
bon-macros-3.7.2
borsh-1.6.0
borsh-derive-1.6.0
built-0.8.0
bumpalo-3.19.0
bytecheck-0.6.12
bytecheck_derive-0.6.12
bytemuck-1.24.0
bytemuck_derive-1.10.2
byteorder-1.5.0
byteorder-lite-0.1.0
bytes-1.11.0
camino-1.2.0
cargo_metadata-0.18.1
cargo_metadata-0.19.2
cargo-platform-0.1.9
cargo_toml-0.21.0
cargo_toml-0.22.3
castaway-0.2.4
cc-1.2.49
cedarwood-0.4.6
cee-scape-0.2.0
census-0.4.2
cexpr-0.6.0
cfg_aliases-0.2.1
cfg-if-1.0.4
chrono-0.4.44
chrono-tz-0.10.4
clang-sys-1.8.1
clap-4.5.53
clap_builder-4.5.53
clap-cargo-0.14.1
clap_derive-4.5.49
clap_lex-0.7.6
cmd_lib-1.9.6
cmd_lib_macros-1.9.6
cobs-0.3.0
codepage-0.1.2
colorchoice-1.0.4
color_quant-1.1.0
comfy-table-7.2.2
compact_str-0.8.1
concurrent-queue-2.5.0
const-oid-0.9.6
const-random-0.1.18
const-random-macro-0.1.16
convert_case-0.10.0
convert_case-0.8.0
core2-0.4.0
core-foundation-0.9.4
core-foundation-sys-0.8.7
core-graphics-0.23.2
core-graphics-types-0.1.3
core_maths-0.1.1
core-text-20.1.0
cpufeatures-0.2.17
crc32fast-1.5.0
crc-3.3.0
crc-catalog-2.4.0
crossbeam-channel-0.5.15
crossbeam-deque-0.8.6
crossbeam-epoch-0.9.18
crossbeam-queue-0.3.12
crossbeam-utils-0.8.21
crossterm-0.28.1
crossterm_winapi-0.9.1
crunchy-0.2.4
crypto-common-0.1.6
csv-1.4.0
csv-core-0.1.12
cursive-0.21.1
cursive_core-0.4.6
cursive-macros-0.1.0
cursive-multiplex-0.7.0
cursive_table_view-0.15.0
darling-0.20.11
darling-0.21.3
darling_core-0.20.11
darling_core-0.21.3
darling_macro-0.20.11
darling_macro-0.21.3
dary_heap-0.3.8
dashmap-6.1.0
decimal-bytes-0.4.2
der-0.7.10
deranged-0.4.0
deranged-0.5.5
derive_builder-0.20.2
derive_builder_core-0.20.2
derive_builder_macro-0.20.2
derive_more-2.1.0
derive_more-impl-2.1.0
diff-0.1.13
digest-0.10.7
dirs-6.0.0
dirs-sys-0.5.0
displaydoc-0.2.5
dlib-0.5.2
dotenvy-0.15.7
downcast-rs-2.0.2
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
env_filter-0.1.3
env_logger-0.10.2
env_logger-0.11.8
equator-0.4.2
equator-macro-0.4.2
equivalent-1.0.2
erased-serde-0.4.8
errno-0.3.14
etcetera-0.8.0
event-listener-2.5.3
event-listener-5.4.1
event-listener-strategy-0.5.4
exr-1.74.0
eyre-0.6.12
faccess-0.2.4
fallible-iterator-0.2.0
fastdivide-0.4.2
fastrand-1.9.0
fastrand-2.3.0
fax-0.2.6
fax_derive-0.2.0
fdeflate-0.3.7
filetime-0.2.26
find-msvc-tools-0.1.5
fixedbitset-0.5.7
flatbuffers-25.12.19
flate2-1.1.5
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
funty-2.0.0
futures-0.3.31
futures-channel-0.3.31
futures-core-0.3.31
futures-executor-0.3.31
futures-intrusive-0.5.0
futures-io-0.3.31
futures-lite-1.13.0
futures-lite-2.6.1
futures-macro-0.3.31
futures-sink-0.3.31
futures-task-0.3.31
futures-timer-3.0.3
futures-util-0.3.31
fuzzy-matcher-0.3.7
fxhash-0.2.1
generic-array-0.14.7
getrandom-0.1.16
getrandom-0.2.16
getrandom-0.3.4
getrandom-0.4.2
gif-0.12.0
gif-0.14.1
gimli-0.32.3
git2-0.20.2
glob-0.3.3
gloo-timers-0.3.0
half-1.8.3
half-2.7.1
hashbrown-0.12.3
hashbrown-0.14.5
hashbrown-0.15.5
hashbrown-0.16.1
hashlink-0.10.0
heck-0.5.0
hermit-abi-0.3.9
hermit-abi-0.5.2
hex-0.4.3
hkdf-0.12.4
hmac-0.12.1
home-0.5.12
htmlescape-0.3.1
http-1.3.1
httparse-1.10.1
http-body-1.0.1
http-body-util-0.1.3
human_bytes-0.4.3
humantime-2.3.0
hyper-1.7.0
hyperloglogplus-0.4.1
hyper-rustls-0.27.7
hyper-util-0.1.17
iana-time-zone-0.1.64
iana-time-zone-haiku-0.1.2
icu_collections-2.1.1
icu_locale-2.1.1
icu_locale_core-2.1.1
icu_locale_data-2.1.1
icu_normalizer-2.1.1
icu_normalizer_data-2.1.1
icu_properties-2.1.2
icu_properties_data-2.1.2
icu_provider-2.1.1
icu_segmenter-2.1.2
icu_segmenter_data-2.1.1
id-arena-2.3.0
ident_case-1.0.1
idna-1.1.0
idna_adapter-1.2.1
image-0.24.9
image-0.25.9
image-webp-0.2.4
imgref-1.12.0
include-flate-0.3.0
include-flate-codegen-0.2.0
indenter-0.3.4
indexmap-2.13.0
indextree-4.7.4
indextree-macros-0.1.3
instant-0.1.13
interpolate_name-0.2.4
inventory-0.3.21
io-lifetimes-1.0.11
ipnet-2.11.0
iri-string-0.7.8
is_ci-1.2.0
is-terminal-0.4.17
is_terminal_polyfill-1.70.2
itertools-0.13.0
itertools-0.14.0
itertools-0.9.0
itoa-1.0.15
jieba-macros-0.7.1
jieba-macros-0.8.1
jieba-rs-0.7.4
jieba-rs-0.8.0
jiff-0.2.15
jiff-static-0.2.15
jobserver-0.1.34
jpeg-decoder-0.3.2
json5-0.4.1
js-sys-0.3.80
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
libc-0.2.183
libflate-2.1.0
libflate_lz77-2.1.0
libfuzzer-sys-0.4.10
libgit2-sys-0.18.2+1.9.1
libloading-0.8.9
libm-0.2.15
libredox-0.1.10
libsqlite3-sys-0.30.1
libz-sys-1.1.22
lindera-1.4.1
lindera-cc-cedict-1.4.1
lindera-dictionary-1.4.1
lindera-ipadic-1.4.1
lindera-ipadic-neologd-1.4.1
lindera-ko-dic-1.4.1
lindera-unidic-1.4.1
linux-raw-sys-0.11.0
linux-raw-sys-0.3.8
linux-raw-sys-0.4.15
litemap-0.8.0
lock_api-0.4.14
lockfree-object-pool-0.1.6
log-0.4.29
loop9-0.1.5
lru-0.16.3
lru-slab-0.1.2
lz4_flex-0.12.0
maybe-rayon-0.1.1
md-5-0.10.6
md5-0.8.0
measure_time-0.9.0
memchr-2.8.0
memmap2-0.9.9
memoffset-0.9.1
minimal-lexical-0.2.1
miniz_oxide-0.8.9
mio-1.1.1
moxcms-0.7.11
murmurhash32-0.3.1
new_debug_unreachable-1.0.6
nom-7.1.3
nom-8.0.0
noop_proc_macro-0.3.0
ntapi-0.4.1
num-0.4.3
num-bigint-0.4.6
num-bigint-dig-0.8.4
num-complex-0.4.6
num-conv-0.1.0
num_cpus-1.17.0
num-derive-0.4.2
num-integer-0.1.46
num-iter-0.1.45
num-rational-0.4.2
num_threads-0.1.7
num-traits-0.2.19
objc2-core-foundation-0.3.1
object-0.37.3
object_store-0.13.1
once_cell-1.21.3
once_cell_polyfill-1.70.1
oneshot-0.1.13
opencc-jieba-rs-0.7.2
openssl-0.10.75
openssl-macros-0.1.1
openssl-sys-0.9.111
option-ext-0.2.0
ordered-float-4.6.0
ordered-float-5.1.0
os_pipe-1.2.2
owo-colors-4.2.2
parking-2.2.1
parking_lot-0.12.5
parking_lot_core-0.9.12
paste-1.0.15
pastey-0.1.1
pathfinder_geometry-0.5.1
pathfinder_simd-0.5.5
pathsearch-0.2.0
pem-rfc7468-0.7.0
percent-encoding-2.3.2
permutation-0.4.1
pest-2.8.2
pest_derive-2.8.2
pest_generator-2.8.2
pest_meta-2.8.2
petgraph-0.8.3
pgrx-0.17.0
pgrx-bindgen-0.17.0
pgrx-macros-0.17.0
pgrx-pg-config-0.13.1
pgrx-pg-config-0.17.0
pgrx-pg-sys-0.17.0
pgrx-sql-entity-graph-0.17.0
pgrx-tests-0.17.0
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
pin-project-lite-0.2.16
pin-utils-0.1.0
piper-0.2.4
pkcs1-0.7.5
pkcs8-0.10.2
pkg-config-0.3.32
plotters-0.3.7
plotters-backend-0.3.7
plotters-bitmap-0.3.7
plotters-svg-0.3.7
png-0.17.16
png-0.18.0
polling-2.8.0
polling-3.11.0
portable-atomic-1.11.1
portable-atomic-util-0.2.4
postcard-1.1.3
postgres-0.19.12
postgres-openssl-0.5.2
postgres-protocol-0.6.9
postgres-types-0.2.11
potential_utf-0.1.3
powerfmt-0.2.0
ppv-lite86-0.2.21
precis-core-0.1.11
precis-profiles-0.1.13
precis-tools-0.1.9
pretty_assertions-1.4.1
prettyplease-0.2.37
proc-macro2-1.0.103
proc-macro-crate-3.4.0
proc-macro-error2-2.0.1
proc-macro-error-attr2-2.0.0
proc-macro-hack-0.5.20+deprecated
profiling-1.0.17
profiling-procmacros-1.0.17
proptest-1.9.0
proptest-derive-0.6.0
prost-0.14.3
prost-derive-0.14.3
ptr_meta-0.1.4
ptr_meta_derive-0.1.4
pxfm-0.1.27
qoi-0.4.1
quick-error-1.2.3
quick-error-2.0.1
quinn-0.11.9
quinn-proto-0.11.13
quinn-udp-0.5.14
quote-1.0.45
radium-0.7.0
rand-0.7.3
rand-0.8.5
rand-0.9.2
rand_chacha-0.2.2
rand_chacha-0.3.1
rand_chacha-0.9.0
rand_core-0.5.1
rand_core-0.6.4
rand_core-0.9.3
rand_distr-0.4.3
rand_hc-0.2.0
rand_pcg-0.2.1
rand_xorshift-0.4.0
rav1e-0.8.1
ravif-0.12.0
rayon-1.10.0
rayon-core-1.12.1
redox_syscall-0.5.17
redox_users-0.5.2
r-efi-5.3.0
r-efi-6.0.0
regex-1.12.2
regex-automata-0.4.13
regex-lite-0.1.8
regex-syntax-0.8.10
relative-path-1.9.3
rend-0.4.2
reqwest-0.12.24
rgb-0.8.52
ring-0.17.14
rkyv-0.7.45
rkyv_derive-0.7.45
rle-decode-fast-1.0.3
rsa-0.9.8
rstest-0.25.0
rstest_macros-0.25.0
rustc-demangle-0.1.27
rustc-hash-2.1.1
rustc_version-0.4.1
rust_decimal-1.39.0
rustix-0.37.28
rustix-0.38.44
rustix-1.1.2
rustls-0.23.31
rustls-pki-types-1.12.0
rustls-webpki-0.103.6
rust-stemmers-1.2.0
rustversion-1.0.22
rusty-fork-0.3.1
ryu-1.0.20
same-file-1.0.6
scopeguard-1.2.0
seahash-4.1.0
semver-1.0.27
serde-1.0.228
serde_cbor-0.11.2
serde_core-1.0.228
serde_derive-1.0.228
serde_json-1.0.145
serde_path_to_error-0.1.20
serde_spanned-0.6.9
serde_spanned-1.0.1
serde_urlencoded-0.7.1
serde_yaml-0.9.34+deprecated
sha1-0.10.6
sha2-0.10.9
shlex-1.3.0
shutdown_hooks-0.1.0
signal-hook-0.3.18
signal-hook-mio-0.2.5
signal-hook-registry-1.4.7
signature-2.2.0
simd-adler32-0.3.8
simd_helpers-0.1.0
simdutf8-0.1.5
siphasher-0.3.11
siphasher-1.0.1
sketches-ddsketch-0.3.0
slab-0.4.11
smallvec-1.15.1
soa_derive-0.14.0
soa_derive_internal-0.14.0
socket2-0.4.10
socket2-0.6.1
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
tantivy-jieba-0.17.0
tantivy-stemmers-0.4.0
tap-1.0.1
tar-0.4.44
tempfile-3.23.0
termcolor-1.4.1
thiserror-1.0.69
thiserror-2.0.17
thiserror-impl-1.0.69
thiserror-impl-2.0.17
thread_local-1.1.9
tiff-0.10.3
time-0.3.44
time-core-0.1.6
time-macros-0.2.24
tiny-keccak-2.0.2
tinystr-0.8.1
tinyvec-1.10.0
tinyvec_macros-0.1.1
tokenizers-0.22.2
tokio-1.48.0
tokio-macros-2.6.0
tokio-openssl-0.6.5
tokio-postgres-0.7.15
tokio-rustls-0.26.3
tokio-stream-0.1.18
tokio-util-0.7.16
toml-0.8.23
toml-0.9.6
toml_datetime-0.6.11
toml_datetime-0.7.1
toml_edit-0.22.27
toml_edit-0.23.5
toml_parser-1.0.2
toml_write-0.1.2
toml_writer-1.0.2
tower-0.5.2
tower-http-0.6.6
tower-layer-0.3.3
tower-service-0.3.3
tracing-0.1.43
tracing-attributes-0.1.31
tracing-core-0.1.35
try-lock-0.2.5
ttf-parser-0.20.0
twox-hash-2.1.2
typeid-1.0.3
typenum-1.18.0
typetag-0.2.21
typetag-impl-0.2.21
ucd-parse-0.1.13
ucd-trie-0.1.7
unarray-0.1.4
unescape-0.1.0
unicode-bidi-0.3.18
unicode-blocks-0.1.9
unicode-ident-1.0.22
unicode-normalization-0.1.24
unicode-properties-0.1.3
unicode-segmentation-1.12.0
unicode-width-0.1.14
unicode-width-0.2.1
unicode-xid-0.2.6
unsafe-libyaml-0.2.11
untrusted-0.9.0
unty-0.0.4
url-2.5.7
utf8_iter-1.0.4
utf8parse-0.2.2
utf8-ranges-1.0.5
uuid-1.22.0
value-bag-1.12.0
vcpkg-0.2.15
vergen-9.0.6
vergen-git2-1.0.7
vergen-lib-0.1.6
version_check-0.9.5
v_frame-0.3.9
virtue-0.0.18
wait-timeout-0.2.1
waker-fn-1.2.0
walkdir-2.5.0
want-0.3.1
wasi-0.11.1+wasi-snapshot-preview1
wasi-0.9.0+wasi-snapshot-preview1
wasip2-1.0.1+wasi-0.2.4
wasip3-0.4.0+wasi-0.3.0-rc-2026-01-06
wasite-0.1.0
wasm-bindgen-0.2.103
wasm-bindgen-backend-0.2.103
wasm-bindgen-futures-0.4.53
wasm-bindgen-macro-0.2.103
wasm-bindgen-macro-support-0.2.103
wasm-bindgen-shared-0.2.103
wasm-encoder-0.244.0
wasm-metadata-0.244.0
wasmparser-0.244.0
webpki-roots-1.0.2
web-sys-0.3.80
web-time-1.1.0
weezl-0.1.12
whoami-1.6.1
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
windows_i686_gnu-0.48.5
windows_i686_gnu-0.52.6
windows_i686_gnu-0.53.1
windows_i686_gnullvm-0.52.6
windows_i686_gnullvm-0.53.1
windows_i686_msvc-0.48.5
windows_i686_msvc-0.52.6
windows_i686_msvc-0.53.1
windows-implement-0.57.0
windows-interface-0.57.0
windows-link-0.2.1
windows-result-0.1.2
windows-sys-0.48.0
windows-sys-0.52.0
windows-sys-0.59.0
windows-sys-0.60.2
windows-sys-0.61.0
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
winnow-0.7.13
wio-0.2.2
wit-bindgen-0.46.0
wit-bindgen-0.51.0
wit-bindgen-core-0.51.0
wit-bindgen-rust-0.51.0
wit-bindgen-rust-macro-0.51.0
wit-component-0.244.0
wit-parser-0.244.0
writeable-0.6.2
wyz-0.5.1
xattr-1.5.1
xi-unicode-0.3.0
y4m-0.8.0
yada-0.5.1
yansi-1.0.1
yeslogic-fontconfig-sys-6.0.0
yoke-0.8.0
yoke-derive-0.8.0
zerocopy-0.8.31
zerocopy-derive-0.8.31
zerofrom-0.1.6
zerofrom-derive-0.1.6
zeroize-1.8.1
zerotrie-0.2.2
zerovec-0.11.4
zerovec-derive-0.11.1
zstd-0.13.3
zstd-safe-7.2.4
zstd-sys-2.0.16+zstd.1.5.7
zune-core-0.4.12
zune-core-0.5.0
zune-inflate-0.2.54
zune-jpeg-0.4.21
zune-jpeg-0.5.8
tantivy-tokenizer-api-0.3.0
"

declare -A GIT_CRATES=(
# Replace datafusion-53 with datafusion
[datafusion-catalog]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/catalog" # 53.0.0
[datafusion-catalog-listing]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/catalog-listing" # 53.0.0
[datafusion-common]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/common" # 53.0.0
[datafusion-common-runtime]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/common-runtime" # 53.0.0
[datafusion-datasource-arrow]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/datasource-arrow" # 53.0.0
[datafusion-datasource-csv]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/datasource-csv" # 53.0.0
[datafusion-datasource]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/datasource" # 53.0.0
[datafusion-datasource-json]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/datasource-json" # 53.0.0
[datafusion-doc]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/doc" # 53.0.0
[datafusion-execution]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/execution" # 53.0.0
[datafusion-expr-common]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/expr-common" # 53.0.0
[datafusion-expr]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/expr" # 53.0.0
[datafusion-functions-aggregate-common]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/functions-aggregate-common" # 53.0.0
[datafusion-functions-aggregate]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/functions-aggregate" # 53.0.0
[datafusion-functions]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/functions" # 53.0.0
[datafusion-functions-table]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/functions-table" # 53.0.0
[datafusion-functions-window-common]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/functions-window-common" # 53.0.0
[datafusion-functions-window]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/functions-window" # 53.0.0
[datafusion]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/core" # 53.0.0
[datafusion-macros]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/macros" # 53.0.0
[datafusion-optimizer]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/optimizer" # 53.0.0
[datafusion-physical-expr-adapter]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/physical-expr-adapter" # 53.0.0
[datafusion-physical-expr-common]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/physical-expr-common" # 53.0.0
[datafusion-physical-expr]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/physical-expr" # 53.0.0
[datafusion-physical-optimizer]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/physical-optimizer" # 53.0.0
[datafusion-physical-plan]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/physical-plan" # 53.0.0
[datafusion-proto-common]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/proto-common" # 53.0.0
[datafusion-proto]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/proto" # 53.0.0
[datafusion-pruning]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/pruning" # 53.0.0
[datafusion-session]="https://github.com/apache/datafusion;05e00aeb17fc17adc3ffea90de8c786b7d8a9673;datafusion-%commit%/datafusion/session" # 53.0.0
[ownedbytes]="https://github.com/paradedb/tantivy;6338e83a36f947d37aaa602cc57b253ec1c5d652;tantivy-%commit%/ownedbytes" # 0.9.0
[tantivy-bitpacker]="https://github.com/paradedb/tantivy;6338e83a36f947d37aaa602cc57b253ec1c5d652;tantivy-%commit%/bitpacker" # 0.9.0
[tantivy-columnar]="https://github.com/paradedb/tantivy;6338e83a36f947d37aaa602cc57b253ec1c5d652;tantivy-%commit%/columnar" # 0.6.0
[tantivy-common]="https://github.com/paradedb/tantivy;6338e83a36f947d37aaa602cc57b253ec1c5d652;tantivy-%commit%/common" # 0.10.0
[tantivy-fst]="https://github.com/paradedb/fst;11e89334c578f26f9fbafbd1122ffb220ebbdbbf;fst-%commit%" # 0.5.0
[tantivy]="https://github.com/paradedb/tantivy;6338e83a36f947d37aaa602cc57b253ec1c5d652;tantivy-%commit%" # 0.26.0
[tantivy-query-grammar]="https://github.com/paradedb/tantivy;6338e83a36f947d37aaa602cc57b253ec1c5d652;tantivy-%commit%/query-grammar" # 0.25.0
[tantivy-sstable]="https://github.com/paradedb/tantivy;6338e83a36f947d37aaa602cc57b253ec1c5d652;tantivy-%commit%/sstable" # 0.6.0
[tantivy-stacker]="https://github.com/paradedb/tantivy;6338e83a36f947d37aaa602cc57b253ec1c5d652;tantivy-%commit%/stacker" # 0.6.0
[tantivy-tokenizer-api]="https://github.com/paradedb/tantivy;6338e83a36f947d37aaa602cc57b253ec1c5d652;tantivy-%commit%/tokenizer-api" # 0.6.0
)

inherit cargo postgres-multi rust sandbox-changes

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
LICENSE="AGPL-3+"
SLOT="0"
IUSE="
${CPU_FLAGS_X86[@]}
debug
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
	=dev-util/cargo-pgrx-0.17*
	dev-util/cargo-pgrx:=
"
DOCS=( "${S_PG_SEARCH}/README.md" )

pkg_setup() {
	# Both are required
	sandbox-changes_no_network_sandbox "To download cargo metadata" # Still required if set to offline in cargo_home/cargo.toml
	sandbox-changes_no_feature "sandbox" "To download cargo metadata" # Still required if network sandbox disabled

	postgres-multi_pkg_setup
	rust_pkg_setup
}

src_unpack() {
#	unpack "paradedb-${PV}.tar.gz"
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
	#die
	cd "${WORKDIR}" || die
	eapply "${FILESDIR}/${PN}-0.22.2-unify-tantivy-tokenizer-api-to-paradedb-fork.patch"
	eapply "${FILESDIR}/${PN}-0.22.2-tantivy-jieba-use-paradedb-fork.patch"
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
eerror "CPU is not supported.  Make sure that the cpu_flags_x86_* flags are updated for ${PN}."
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
		pushd "target/${configuration}/pg_search-pg${PG_SLOT}" || die
			doins -r *
			local libdir=$(get_libdir)
			fperms 0644 "/usr/${libdir}/postgresql-${PG_SLOT}/${libdir}/pg_search.so"
		popd || die
	}

	postgres-multi_foreach postgres-multi_foreach_src_install

}
