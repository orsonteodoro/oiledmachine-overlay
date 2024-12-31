# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#DISTUTILS_ARGS=(
#	"kornia-py/Cargo.toml"
#)
DISTUTILS_USE_PEP517="maturin"
PYTHON_COMPAT=( "python3_"{10..12} "pypy3" )

if ! [[ "${PV}" =~ "9999" ]] ; then
# Example crates:
CRATES_EXCLUDE="
binarize-0.1.7
color_detector-0.1.7
hello_world-0.1.7
histogram-0.1.7
imgproc-0.1.7
metrics-0.1.7
normalize-0.1.7
normalize_ii-0.1.7
onnx-0.1.7
rerun_viz-0.1.7
rotate-0.1.7
std_mean-0.1.7
undistort-0.1.7
rtspcam-0.1.0
video_write-0.1.0
video_write_tasks-0.1.0
webcam-0.1.0
kornia-image-0.1.6+dev
kornia-imgproc-0.1.6+dev
kornia-io-0.1.6+dev
kornia-py-0.1.7
kornia-rs-0.1.6+dev
kornia-serve-0.1.6+dev
"

# From "./convert-cargo-lock.sh 1.4.7 1.4.7"
CRATES="
ab_glyph-0.2.29
ab_glyph_rasterizer-0.1.8
accesskit-0.12.3
accesskit_consumer-0.16.1
accesskit_macos-0.10.1
accesskit_unix-0.6.2
accesskit_windows-0.15.1
accesskit_winit-0.16.1
addr2line-0.21.0
addr2line-0.24.2
adler-1.0.2
adler2-2.0.0
ahash-0.8.11
aho-corasick-1.1.3
aligned-vec-0.5.0
android-activity-0.5.2
android-properties-0.2.2
android_system_properties-0.1.5
anes-0.1.6
anstream-0.6.13
anstream-0.6.18
anstyle-1.0.10
anstyle-1.0.6
anstyle-parse-0.2.3
anstyle-parse-0.2.6
anstyle-query-1.0.2
anstyle-query-1.1.2
anstyle-wincon-3.0.2
anstyle-wincon-3.0.6
anyhow-1.0.82
anyhow-1.0.95
arbitrary-1.3.2
arbitrary-1.4.1
arboard-3.4.1
arg_enum_proc_macro-0.3.4
array-init-2.1.0
array-init-cursor-0.2.0
arrayvec-0.7.4
arrayvec-0.7.6
arrow-buffer-52.1.0
arrow-format-0.8.1
as-raw-xcb-connection-1.0.1
ascii-1.1.0
ash-0.37.3+1.3.251
ashpd-0.6.8
async-broadcast-0.5.1
async-channel-2.3.1
async-executor-1.13.1
async-fs-1.6.0
async-fs-2.1.2
async-io-1.13.0
async-io-2.4.0
async-lock-2.8.0
async-lock-3.4.0
async-net-2.0.0
async-once-cell-0.5.4
async-process-1.8.1
async-recursion-1.1.1
async-signal-0.2.10
async-task-4.7.1
async-trait-0.1.80
async-trait-0.1.83
atomic-waker-1.1.2
atomic_refcell-0.1.13
atspi-0.19.0
atspi-common-0.3.0
atspi-connection-0.3.0
atspi-proxies-0.3.0
autocfg-1.2.0
autocfg-1.4.0
av1-grain-0.2.3
avif-serialize-0.8.1
avif-serialize-0.8.2
axum-0.7.5
axum-core-0.4.3
az-1.2.1
backtrace-0.3.71
backtrace-0.3.74
base64-0.13.1
base64-0.21.7
base64-0.22.1
binarize-0.1.7
bincode-1.3.3
bit-set-0.5.3
bit-vec-0.6.3
bit_field-0.10.2
bitflags-1.3.2
bitflags-2.6.0
bitstream-io-2.2.0
bitstream-io-2.6.0
block-0.1.6
block-buffer-0.10.4
block-sys-0.1.0-beta.1
block-sys-0.2.1
block2-0.2.0-alpha.6
block2-0.3.0
block2-0.5.1
blocking-1.6.1
bstr-1.11.1
built-0.7.2
built-0.7.5
bumpalo-3.16.0
bytecount-0.6.8
bytemuck-1.15.0
bytemuck-1.21.0
bytemuck_derive-1.8.1
byteorder-1.5.0
byteorder-lite-0.1.0
bytes-1.6.0
bytes-1.9.0
calloop-0.12.4
calloop-0.13.0
calloop-wayland-source-0.2.0
calloop-wayland-source-0.3.0
camino-1.1.9
cargo-platform-0.1.9
cargo_metadata-0.14.2
cargo_metadata-0.18.1
cast-0.3.0
cc-1.0.95
cc-1.2.6
cesu8-1.1.0
cfb-0.7.3
cfg-expr-0.15.8
cfg-expr-0.17.2
cfg-if-1.0.0
cfg_aliases-0.1.1
cfg_aliases-0.2.1
chrono-0.4.39
chunked_transfer-1.5.0
ciborium-0.2.2
ciborium-io-0.2.2
ciborium-ll-0.2.2
clang-format-0.3.0
clap-4.5.23
clap_builder-4.5.23
clap_derive-4.5.18
clap_lex-0.7.4
clean-path-0.2.1
clipboard-win-5.4.0
cmake-0.1.50
cmake-0.1.52
codespan-reporting-0.11.1
color_detector-0.1.7
color_quant-1.1.0
colorchoice-1.0.0
colorchoice-1.0.3
com-0.6.0
com_macros-0.6.0
com_macros_support-0.6.0
combine-4.6.7
comfy-table-7.1.3
concurrent-queue-2.5.0
console-0.15.10
console-0.15.8
const_soft_float-0.1.4
constgebra-0.1.4
convert_case-0.6.0
core-foundation-0.10.0
core-foundation-0.9.4
core-foundation-sys-0.8.7
core-graphics-0.23.2
core-graphics-types-0.1.3
cpufeatures-0.2.16
crc32fast-1.4.0
crc32fast-1.4.2
criterion-0.5.1
criterion-plot-0.5.0
crossbeam-0.8.4
crossbeam-channel-0.5.14
crossbeam-deque-0.8.5
crossbeam-deque-0.8.6
crossbeam-epoch-0.9.18
crossbeam-queue-0.3.12
crossbeam-utils-0.8.19
crossbeam-utils-0.8.21
crossterm-0.28.1
crossterm_winapi-0.9.1
crunchy-0.2.2
crypto-common-0.1.6
ctrlc-3.4.5
cursor-icon-1.1.0
darling-0.20.10
darling_core-0.20.10
darling_macro-0.20.10
data-encoding-2.6.0
deranged-0.3.11
derivative-2.2.0
digest-0.10.7
directories-5.0.1
dirs-sys-0.4.1
dispatch-0.2.0
displaydoc-0.2.5
dlib-0.5.2
document-features-0.2.10
downcast-rs-1.2.1
dyn-clone-1.0.17
ecolor-0.28.1
eframe-0.28.1
egui-0.28.1
egui-wgpu-0.28.1
egui-winit-0.28.1
egui_commonmark-0.17.0
egui_commonmark_backend-0.17.0
egui_extras-0.28.1
egui_glow-0.28.1
egui_plot-0.28.1
egui_tiles-0.9.1
ehttp-0.5.0
either-1.11.0
either-1.13.0
emath-0.28.1
encode_unicode-0.3.6
encode_unicode-1.0.0
enum-map-2.7.3
enum-map-derive-0.17.0
enumflags2-0.7.10
enumflags2_derive-0.7.10
enumn-0.1.14
enumset-1.1.5
enumset_derive-0.10.0
env_filter-0.1.0
env_logger-0.10.2
env_logger-0.11.3
epaint-0.28.1
equivalent-1.0.1
errno-0.3.10
error-chain-0.12.4
error-code-3.3.1
ethnum-1.5.0
event-listener-2.5.3
event-listener-3.1.0
event-listener-5.3.1
event-listener-strategy-0.5.3
ewebsock-0.6.0
exr-1.72.0
exr-1.73.0
fast_image_resize-3.0.4
fastrand-1.9.0
fastrand-2.3.0
fdeflate-0.3.4
fdeflate-0.3.7
filetime-0.2.25
fixed-1.27.0
flatbuffers-23.5.26
flate2-1.0.28
flate2-1.0.35
flume-0.11.0
fnv-1.0.7
foldhash-0.1.4
foreign-types-0.5.0
foreign-types-macros-0.2.3
foreign-types-shared-0.3.1
foreign_vec-0.1.0
form_urlencoded-1.2.1
fsevent-sys-4.1.0
futures-channel-0.3.30
futures-channel-0.3.31
futures-core-0.3.30
futures-core-0.3.31
futures-executor-0.3.30
futures-executor-0.3.31
futures-io-0.3.31
futures-lite-1.13.0
futures-lite-2.5.0
futures-macro-0.3.30
futures-macro-0.3.31
futures-sink-0.3.30
futures-sink-0.3.31
futures-task-0.3.30
futures-task-0.3.31
futures-util-0.3.30
futures-util-0.3.31
generic-array-0.14.7
gethostname-0.4.3
getrandom-0.2.14
getrandom-0.2.15
gif-0.13.1
gimli-0.28.1
gimli-0.31.1
gio-sys-0.19.8
gio-sys-0.20.8
gl_generator-0.14.0
glam-0.28.0
glib-0.19.9
glib-0.20.7
glib-macros-0.19.9
glib-macros-0.20.7
glib-sys-0.19.8
glib-sys-0.20.7
glob-0.3.2
glow-0.13.1
gltf-1.4.1
gltf-derive-1.4.1
gltf-json-1.4.1
glutin_wgl_sys-0.5.0
gobject-sys-0.19.8
gobject-sys-0.20.7
gpu-alloc-0.6.0
gpu-alloc-types-0.3.0
gpu-allocator-0.25.0
gpu-descriptor-0.3.1
gpu-descriptor-types-0.2.0
gstreamer-0.22.6
gstreamer-0.23.4
gstreamer-app-0.22.6
gstreamer-app-0.23.4
gstreamer-app-sys-0.22.6
gstreamer-app-sys-0.23.4
gstreamer-base-0.22.6
gstreamer-base-0.23.4
gstreamer-base-sys-0.22.6
gstreamer-base-sys-0.23.4
gstreamer-sys-0.22.6
gstreamer-sys-0.23.4
half-2.4.1
hash_hasher-2.0.3
hashbrown-0.14.3
hashbrown-0.14.5
hashbrown-0.15.2
hassle-rs-0.11.0
heck-0.4.1
heck-0.5.0
hello_world-0.1.7
hermit-abi-0.3.9
hermit-abi-0.4.0
hex-0.4.3
hexasphere-14.1.0
hexf-parse-0.2.1
histogram-0.1.7
home-0.5.11
http-1.1.0
http-1.2.0
http-body-1.0.0
http-body-util-0.1.1
httparse-1.8.0
httparse-1.9.5
httpdate-1.0.3
humantime-2.1.0
hyper-1.3.1
hyper-util-0.1.3
icrate-0.0.4
icu_collections-1.5.0
icu_locid-1.5.0
icu_locid_transform-1.5.0
icu_locid_transform_data-1.5.0
icu_normalizer-1.5.0
icu_normalizer_data-1.5.0
icu_properties-1.5.1
icu_properties_data-1.5.0
icu_provider-1.5.0
icu_provider_macros-1.5.0
ident_case-1.0.1
idna-1.0.3
idna_adapter-1.2.0
image-0.25.1
image-0.25.5
image-webp-0.1.2
image-webp-0.2.0
imgproc-0.1.7
imgref-1.10.1
imgref-1.11.0
indent-0.1.1
indexmap-2.2.6
indexmap-2.7.0
indicatif-0.17.8
indicatif-0.17.9
indoc-2.0.5
infer-0.15.0
inflections-1.1.1
inotify-0.9.6
inotify-sys-0.1.5
instant-0.1.12
instant-0.1.13
interpolate_name-0.2.4
io-lifetimes-1.0.11
is-terminal-0.4.13
is_terminal_polyfill-1.70.1
itertools-0.10.5
itertools-0.12.1
itertools-0.13.0
itoa-1.0.11
itoa-1.0.14
jni-0.21.1
jni-sys-0.3.0
jobserver-0.1.30
jobserver-0.1.32
jpeg-decoder-0.3.1
js-sys-0.3.69
khronos-egl-6.0.0
khronos_api-3.1.0
kornia-0.1.7
kornia-core-0.1.6+dev
kornia-core-0.1.7
kornia-core-ops-0.1.7
kornia-image-0.1.6+dev
kornia-image-0.1.7
kornia-imgproc-0.1.6+dev
kornia-imgproc-0.1.7
kornia-io-0.1.6+dev
kornia-io-0.1.7
kornia-py-0.1.7
kornia-rs-0.1.6+dev
kornia-serve-0.1.6+dev
kqueue-1.0.8
kqueue-sys-1.0.4
lazy_static-1.4.0
lazy_static-1.5.0
lebe-0.5.2
libc-0.2.153
libc-0.2.169
libfuzzer-sys-0.4.7
libfuzzer-sys-0.4.8
libloading-0.7.4
libloading-0.8.6
libredox-0.1.3
linked-hash-map-0.5.6
linux-raw-sys-0.3.8
linux-raw-sys-0.4.14
litemap-0.7.4
litrs-0.4.1
lock_api-0.4.11
lock_api-0.4.12
log-0.4.21
log-0.4.22
log-once-0.4.1
loop9-0.1.5
lz4_flex-0.11.3
malloc_buf-0.0.6
matchit-0.7.3
matrixmultiply-0.3.8
matrixmultiply-0.3.9
maybe-rayon-0.1.1
memchr-2.7.2
memchr-2.7.4
memmap2-0.9.4
memmap2-0.9.5
memoffset-0.7.1
memoffset-0.9.1
memory-stats-1.2.0
metal-0.28.0
metrics-0.1.7
mime-0.3.17
mime_guess2-2.0.5
minimal-lexical-0.2.1
miniz_oxide-0.7.2
miniz_oxide-0.8.2
mio-0.8.11
mio-1.0.3
muldiv-1.0.1
naga-0.20.0
natord-1.0.9
ndarray-0.15.6
ndk-0.8.0
ndk-context-0.1.1
ndk-sys-0.5.0+25.2.9519653
never-0.1.0
new_debug_unreachable-1.0.6
nix-0.26.4
nix-0.29.0
nohash-hasher-0.2.0
nom-7.1.3
noop_proc_macro-0.3.0
normalize-0.1.7
normalize_ii-0.1.7
notify-6.1.1
ntapi-0.4.1
num-0.4.2
num-bigint-0.4.4
num-bigint-0.4.6
num-complex-0.4.5
num-complex-0.4.6
num-conv-0.1.0
num-derive-0.4.2
num-integer-0.1.46
num-iter-0.1.45
num-rational-0.4.1
num-rational-0.4.2
num-traits-0.2.18
num-traits-0.2.19
num_cpus-1.16.0
num_enum-0.7.3
num_enum_derive-0.7.3
num_threads-0.1.7
number_prefix-0.4.0
numpy-0.21.0
objc-0.2.7
objc-foundation-0.1.1
objc-sys-0.2.0-beta.2
objc-sys-0.3.5
objc2-0.3.0-beta.3.patch-leaks.3
objc2-0.4.1
objc2-0.5.2
objc2-app-kit-0.2.2
objc2-core-data-0.2.2
objc2-core-image-0.2.2
objc2-encode-2.0.0-pre.2
objc2-encode-3.0.0
objc2-encode-4.0.3
objc2-foundation-0.2.2
objc2-metal-0.2.2
objc2-quartz-core-0.2.2
objc_id-0.1.1
object-0.32.2
object-0.36.7
once_cell-1.19.0
once_cell-1.20.2
onnx-0.1.7
oorandom-11.1.4
option-ext-0.2.0
option-operations-0.5.0
orbclient-0.3.48
ordered-float-4.6.0
ordered-stream-0.2.0
ort-2.0.0-rc.9
ort-sys-2.0.0-rc.9
owned_ttf_parser-0.25.0
parking-2.2.1
parking_lot-0.12.1
parking_lot-0.12.3
parking_lot_core-0.9.10
parking_lot_core-0.9.9
paste-1.0.14
paste-1.0.15
pathdiff-0.2.3
peg-0.6.3
peg-macros-0.6.3
peg-runtime-0.6.3
percent-encoding-2.3.1
pin-project-1.1.5
pin-project-internal-1.1.5
pin-project-lite-0.2.14
pin-project-lite-0.2.15
pin-utils-0.1.0
piper-0.2.4
pkg-config-0.3.30
pkg-config-0.3.31
planus-0.3.1
plotters-0.3.7
plotters-backend-0.3.7
plotters-svg-0.3.7
ply-rs-0.1.3
png-0.17.13
png-0.17.16
poll-promise-0.3.0
polling-2.8.0
polling-3.7.4
pollster-0.3.0
portable-atomic-1.10.0
portable-atomic-1.6.0
powerfmt-0.2.0
ppv-lite86-0.2.17
ppv-lite86-0.2.20
presser-0.3.1
prettyplease-0.2.25
proc-macro-crate-1.3.1
proc-macro-crate-3.1.0
proc-macro-crate-3.2.0
proc-macro2-1.0.81
proc-macro2-1.0.92
profiling-1.0.15
profiling-1.0.16
profiling-procmacros-1.0.15
profiling-procmacros-1.0.16
puffin-0.19.1
puffin_http-0.16.1
pulldown-cmark-0.11.3
pulldown-cmark-0.9.6
pyo3-0.21.2
pyo3-build-config-0.21.2
pyo3-ffi-0.21.2
pyo3-macros-0.21.2
pyo3-macros-backend-0.21.2
qoi-0.4.1
quick-error-2.0.1
quick-xml-0.36.2
quote-1.0.36
quote-1.0.38
rand-0.8.5
rand_chacha-0.3.1
rand_core-0.6.4
rav1e-0.7.1
ravif-0.11.11
ravif-0.11.5
raw-window-handle-0.5.2
raw-window-handle-0.6.2
rawpointer-0.2.1
rayon-1.10.0
rayon-core-1.12.1
re_analytics-0.18.2
re_arrow2-0.17.6
re_blueprint_tree-0.18.2
re_build_info-0.18.2
re_build_tools-0.18.2
re_case-0.18.2
re_chunk-0.18.2
re_chunk_store-0.18.2
re_component_ui-0.18.2
re_context_menu-0.18.2
re_crash_handler-0.18.2
re_data_loader-0.18.2
re_data_source-0.18.2
re_data_ui-0.18.2
re_entity_db-0.18.2
re_error-0.18.2
re_format-0.18.2
re_format_arrow-0.18.2
re_int_histogram-0.18.2
re_log-0.18.2
re_log_encoding-0.18.2
re_log_types-0.18.2
re_math-0.20.0
re_memory-0.18.2
re_query-0.18.2
re_renderer-0.18.2
re_sdk-0.18.2
re_sdk_comms-0.18.2
re_selection_panel-0.18.2
re_smart_channel-0.18.2
re_space_view-0.18.2
re_space_view_bar_chart-0.18.2
re_space_view_dataframe-0.18.2
re_space_view_spatial-0.18.2
re_space_view_tensor-0.18.2
re_space_view_text_document-0.18.2
re_space_view_text_log-0.18.2
re_space_view_time_series-0.18.2
re_string_interner-0.18.2
re_time_panel-0.18.2
re_tracing-0.18.2
re_tuid-0.18.2
re_types-0.18.2
re_types_blueprint-0.18.2
re_types_builder-0.18.2
re_types_core-0.18.2
re_ui-0.18.2
re_viewer-0.18.2
re_viewer_context-0.18.2
re_viewport-0.18.2
re_viewport_blueprint-0.18.2
re_web_viewer_server-0.18.2
re_ws_comms-0.18.2
redox_syscall-0.3.5
redox_syscall-0.4.1
redox_syscall-0.5.8
redox_users-0.4.6
regex-1.10.4
regex-1.11.1
regex-automata-0.4.6
regex-automata-0.4.9
regex-syntax-0.8.3
regex-syntax-0.8.5
renderdoc-sys-1.1.0
rerun-0.18.2
rerun_viz-0.1.7
rfd-0.12.1
rgb-0.8.37
rgb-0.8.50
ring-0.17.8
rmp-0.8.14
rmp-serde-1.3.0
ron-0.8.1
rotate-0.1.7
rtspcam-0.1.0
rust-format-0.3.4
rustc-demangle-0.1.23
rustc-demangle-0.1.24
rustc-hash-1.1.0
rustc_version-0.4.1
rustix-0.37.27
rustix-0.38.42
rustls-0.23.20
rustls-pki-types-1.10.1
rustls-webpki-0.102.8
rustversion-1.0.15
rustversion-1.0.19
ryu-1.0.17
ryu-1.0.18
same-file-1.0.6
scoped-tls-1.0.1
scopeguard-1.2.0
semver-1.0.24
seq-macro-0.3.5
serde-1.0.198
serde-1.0.217
serde-wasm-bindgen-0.6.5
serde_bytes-0.11.15
serde_derive-1.0.198
serde_derive-1.0.217
serde_json-1.0.116
serde_json-1.0.134
serde_path_to_error-0.1.16
serde_repr-0.1.19
serde_spanned-0.6.5
serde_spanned-0.6.8
serde_urlencoded-0.7.1
sha1-0.10.6
sha2-0.10.8
shlex-1.3.0
signal-hook-registry-1.4.1
signal-hook-registry-1.4.2
simd-adler32-0.3.7
simd_helpers-0.1.0
simdutf8-0.1.5
similar-2.6.0
similar-asserts-1.6.0
skeptic-0.13.7
slab-0.4.9
slotmap-1.0.7
smallvec-1.13.2
smithay-client-toolkit-0.18.1
smithay-client-toolkit-0.19.2
smithay-clipboard-0.7.2
smol_str-0.2.2
socket2-0.4.10
socket2-0.5.6
socket2-0.5.8
spin-0.9.8
spirv-0.3.0+sdk-1.3.268.0
stable_deref_trait-1.2.0
static_assertions-1.1.0
std_mean-0.1.7
strsim-0.11.1
strum-0.26.3
strum_macros-0.26.4
sublime_fuzzy-0.7.0
subtle-2.6.1
syn-1.0.109
syn-2.0.60
syn-2.0.93
sync_wrapper-0.1.2
sync_wrapper-1.0.1
synstructure-0.13.1
sysinfo-0.30.13
system-deps-6.2.2
system-deps-7.0.3
target-lexicon-0.12.14
target-lexicon-0.12.16
tempfile-3.14.0
termcolor-1.4.1
thiserror-1.0.59
thiserror-1.0.69
thiserror-2.0.9
thiserror-impl-1.0.59
thiserror-impl-1.0.69
thiserror-impl-2.0.9
tiff-0.9.1
time-0.3.37
time-core-0.1.2
time-macros-0.2.19
tiny_http-0.12.0
tinystl-0.0.3
tinystr-0.7.6
tinytemplate-1.2.1
tobj-4.0.2
tokio-1.37.0
tokio-1.42.0
tokio-macros-2.2.0
tokio-macros-2.4.0
toml-0.8.12
toml-0.8.19
toml_datetime-0.6.5
toml_datetime-0.6.8
toml_edit-0.19.15
toml_edit-0.21.1
toml_edit-0.22.12
toml_edit-0.22.22
tower-0.4.13
tower-layer-0.3.2
tower-service-0.3.2
tracing-0.1.40
tracing-0.1.41
tracing-attributes-0.1.28
tracing-core-0.1.32
tracing-core-0.1.33
ttf-parser-0.25.1
tungstenite-0.21.0
turbojpeg-1.1.0
turbojpeg-1.1.1
turbojpeg-sys-1.0.0
turbojpeg-sys-1.0.1
twox-hash-1.6.3
type-map-0.5.0
typenum-1.17.0
uds_windows-1.1.0
undistort-0.1.7
unicase-2.8.1
unicode-ident-1.0.12
unicode-ident-1.0.14
unicode-segmentation-1.12.0
unicode-width-0.1.11
unicode-width-0.1.14
unicode-width-0.2.0
unicode-xid-0.2.6
unindent-0.2.3
untrusted-0.9.0
ureq-2.12.1
url-2.5.4
urlencoding-2.1.3
utf-8-0.7.6
utf16_iter-1.0.5
utf8_iter-1.0.4
utf8parse-0.2.1
utf8parse-0.2.2
uuid-1.11.0
v_frame-0.3.8
vec1-1.12.1
version-compare-0.2.0
version_check-0.9.5
video_write-0.1.0
video_write_tasks-0.1.0
waker-fn-1.2.0
walkdir-2.5.0
wasi-0.11.0+wasi-snapshot-preview1
wasm-bindgen-0.2.92
wasm-bindgen-0.2.99
wasm-bindgen-backend-0.2.92
wasm-bindgen-backend-0.2.99
wasm-bindgen-futures-0.4.42
wasm-bindgen-macro-0.2.92
wasm-bindgen-macro-0.2.99
wasm-bindgen-macro-support-0.2.92
wasm-bindgen-macro-support-0.2.99
wasm-bindgen-shared-0.2.92
wasm-bindgen-shared-0.2.99
wasm-streams-0.4.1
wayland-backend-0.3.7
wayland-client-0.31.7
wayland-csd-frame-0.3.0
wayland-cursor-0.31.7
wayland-protocols-0.31.2
wayland-protocols-0.32.5
wayland-protocols-plasma-0.2.0
wayland-protocols-wlr-0.2.0
wayland-protocols-wlr-0.3.5
wayland-scanner-0.31.5
wayland-sys-0.31.5
web-sys-0.3.69
web-time-0.2.4
web-time-1.1.0
webbrowser-1.0.3
webcam-0.1.0
webpki-roots-0.26.7
weezl-0.1.8
wgpu-0.20.1
wgpu-core-0.21.1
wgpu-hal-0.21.1
wgpu-types-0.20.0
widestring-1.1.0
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.6
winapi-util-0.1.9
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.48.0
windows-0.52.0
windows-core-0.52.0
windows-implement-0.48.0
windows-interface-0.48.0
windows-sys-0.45.0
windows-sys-0.48.0
windows-sys-0.52.0
windows-sys-0.59.0
windows-targets-0.42.2
windows-targets-0.48.5
windows-targets-0.52.5
windows-targets-0.52.6
windows_aarch64_gnullvm-0.42.2
windows_aarch64_gnullvm-0.48.5
windows_aarch64_gnullvm-0.52.5
windows_aarch64_gnullvm-0.52.6
windows_aarch64_msvc-0.42.2
windows_aarch64_msvc-0.48.5
windows_aarch64_msvc-0.52.5
windows_aarch64_msvc-0.52.6
windows_i686_gnu-0.42.2
windows_i686_gnu-0.48.5
windows_i686_gnu-0.52.5
windows_i686_gnu-0.52.6
windows_i686_gnullvm-0.52.5
windows_i686_gnullvm-0.52.6
windows_i686_msvc-0.42.2
windows_i686_msvc-0.48.5
windows_i686_msvc-0.52.5
windows_i686_msvc-0.52.6
windows_x86_64_gnu-0.42.2
windows_x86_64_gnu-0.48.5
windows_x86_64_gnu-0.52.5
windows_x86_64_gnu-0.52.6
windows_x86_64_gnullvm-0.42.2
windows_x86_64_gnullvm-0.48.5
windows_x86_64_gnullvm-0.52.5
windows_x86_64_gnullvm-0.52.6
windows_x86_64_msvc-0.42.2
windows_x86_64_msvc-0.48.5
windows_x86_64_msvc-0.52.5
windows_x86_64_msvc-0.52.6
winit-0.29.15
winnow-0.5.40
winnow-0.6.20
winnow-0.6.6
write16-1.0.0
writeable-0.5.5
x11-dl-2.21.0
x11rb-0.13.1
x11rb-protocol-0.13.1
xcursor-0.3.8
xdg-home-1.3.0
xkbcommon-dl-0.4.2
xkeysym-0.2.1
xml-rs-0.8.24
xshell-0.2.7
xshell-macros-0.2.7
yoke-0.7.5
yoke-derive-0.7.5
zbus-3.15.2
zbus_macros-3.15.2
zbus_names-2.6.1
zerocopy-0.7.35
zerocopy-derive-0.7.35
zerofrom-0.1.5
zerofrom-derive-0.1.5
zeroize-1.8.1
zerovec-0.10.4
zerovec-derive-0.10.3
zune-core-0.4.12
zune-inflate-0.2.54
zune-jpeg-0.4.11
zune-jpeg-0.4.14
zvariant-3.15.2
zvariant_derive-3.15.2
zvariant_utils-1.0.1
"
	is_crate_excluded() {
		local pkg="${1}"
		local x
		for x in ${CRATES_EXCLUDE[@]} ; do
			if [[ "${x}" == "${pkg}" ]] ; then
				return 0
			fi
		done
		return 1
	}

	exclude_crates() {
		local x
		for x in ${CRATES[@]} ; do
			if is_crate_excluded "${x}" ; then
				:
			else
				echo " ${x}"
			fi
		done
	}
	CRATES=$(exclude_crates)

	inherit cargo distutils-r1
else
	inherit distutils-r1
fi

inherit pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/kornia/kornia-rs.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else

	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
$(cargo_crate_uris ${CRATES})
https://github.com/kornia/kornia-rs/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A low-level 3D computer vision library in Rust"
HOMEPAGE="
	https://docs.rs/kornia
	https://github.com/kornia/kornia-rs
	https://pypi.org/project/kornia-rs
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev test"
REQUIRED_USE="
	dev? (
		test
	)
"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	|| (
		>=dev-lang/rust-1.76
		>=dev-lang/rust-bin-1.76
	)
	>=dev-util/maturin-1[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev? (
		$(python_gen_any_dep '
			>=dev-python/kornia-0.7.2[${PYTHON_SINGLE_USEDEP}]
		')
		>=dev-python/numpy-1.23.0[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/jax[${PYTHON_USEDEP},cpu]
	)
"
DOCS=( "README.md" )
PATCHES=(
)

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
#	die
	cp -aT \
		"${FILESDIR}/${PV}"* \
		"${S}" \
		|| die
}

# From cargo.eclass.  Complains missing
# @FUNCTION: cargo_env
# @USAGE: Command with its arguments
# @DESCRIPTION:
# Run the given command under an environment needed for performing tasks with
# Cargo such as building. RUSTFLAGS are appended to additional flags set here.
# Ensure these are set consistently between Cargo invocations, otherwise
# rebuilds will occur. Project-specific rustflags set against [build] will not
# take affect due to Cargo limitations, so add these to your ebuild's RUSTFLAGS
# if they seem important.
cargo_env() {
	debug-print-function ${FUNCNAME} "$@"

	[[ ${_CARGO_GEN_CONFIG_HAS_RUN} ]] || \
		die "FATAL: please call cargo_gen_config before using ${FUNCNAME}"

	# Shadow flag variables so that filtering below remains local.
	local flag
	for flag in $(all-flag-vars); do
		local -x "${flag}=${!flag}"
	done

	# Rust extensions are incompatible with C/C++ LTO compiler see e.g.
	# https://bugs.gentoo.org/910220
	filter-lto

	tc-export AR CC CXX PKG_CONFIG

	# Set vars for cc-rs crate.
	local -x \
		HOST_AR=$(tc-getBUILD_AR)
		HOST_CC=$(tc-getBUILD_CC)
		HOST_CXX=$(tc-getBUILD_CXX)
		HOST_CFLAGS=${BUILD_CFLAGS}
		HOST_CXXFLAGS=${BUILD_CXXFLAGS}

	# Unfortunately, Cargo is *really* bad at handling flags. In short, it uses
	# the first of the RUSTFLAGS env var, any target-specific config, and then
	# any generic [build] config. It can merge within the latter two types from
	# different sources, but it will not merge across these different types, so
	# if a project sets flags under [target.'cfg(all())'], it will override any
	# flags we set under [build] and vice-versa.
	#
	# It has been common for users and ebuilds to set RUSTFLAGS, which would
	# have overridden whatever a project sets anyway, so the least-worst option
	# is to include those RUSTFLAGS in target-specific config here, which will
	# merge with any the project sets. Only flags in generic [build] config set
	# by the project will be lost, and ebuilds will need to add those to
	# RUSTFLAGS themselves if they are important.
	#
	# We could potentially inspect a project's generic [build] config and
	# reapply those flags ourselves, but that would require a proper toml parser
	# like tomlq, it might lead to confusion where projects also have
	# target-specific config, and converting arrays to strings may not work
	# well. Nightly features to inspect the config might help here in future.
	#
	# As of Rust 1.80, it is not possible to set separate flags for the build
	# host and the target host when cross-compiling. The flags given are applied
	# to the target host only with no flags being applied to the build host. The
	# nightly host-config feature will improve this situation later.
	#
	# The default linker is "cc" so override by setting linker to CC in the
	# RUSTFLAGS. The given linker cannot include any arguments, so split these
	# into link-args along with LDFLAGS.
	local -x CARGO_BUILD_TARGET=$(rust_abi)
	local TRIPLE=${CARGO_BUILD_TARGET//-/_}
	local TRIPLE=${TRIPLE^^} LD_A=( $(tc-getCC) ${LDFLAGS} )
	local -Ix CARGO_TARGET_"${TRIPLE}"_RUSTFLAGS+=" -C strip=none -C linker=${LD_A[0]}"
	[[ ${#LD_A[@]} -gt 1 ]] && local CARGO_TARGET_"${TRIPLE}"_RUSTFLAGS+="$(printf -- ' -C link-arg=%s' "${LD_A[@]:1}")"
	local CARGO_TARGET_"${TRIPLE}"_RUSTFLAGS+=" ${RUSTFLAGS}"

	(
		# These variables will override the above, even if empty, so unset them
		# locally. Do this in a subshell so that they remain set afterwards.
		unset CARGO_BUILD_RUSTFLAGS CARGO_ENCODED_RUSTFLAGS RUSTFLAGS

		"${@}"
	)
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		if [[ "${GENERATE_LOCKFILE}" == "1" ]] ; then
			_lockfile_gen_unpack
		else
			_production_unpack
		fi
#		export S="${WORKDIR}/${PN}-${PV}"
		cargo_src_unpack
	fi
}

src_configure() {
	distutils-r1_src_configure
}


python_compile() {
#	edo python3 -m venv .venv
#	edo maturin develop -m kornia-py/Cargo.toml
#	emake build-python-release
#	export S="${WORKDIR}/${PN}-${PV}"
	cargo_src_compile
	pushd "kornia-py" >/dev/null 2>&1 || die
		S="${WORKDIR}/${PN}-${PV}" \
		distutils-r1_python_compile
	popd >/dev/null 2>&1 || die
}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
