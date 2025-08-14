# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#GENERATE_LOCKFILE=${GENERATE_LOCKFILE:-1}

#DISTUTILS_ARGS=(
#	"kornia-py/Cargo.toml"
#)
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="maturin"
PYTHON_COMPAT=( "python3_"{10..12} "pypy3" )
RUST_MAX_VER="1.87.0" # Inclusive
RUST_MIN_VER="1.87.0" # llvm-20.1
RUST_PV="${RUST_MIN_VER}"

if ! [[ "${PV}" =~ "9999" ]] ; then
# Example crates:
# These are found in the examples folder or crates folder
CRATES_EXCLUDE="
binarize-0.1.9
colmap_rerun-0.1.9
color_detector-0.1.9
copper-0.1.9
dora-image-utils-0.1.0
dora-imgproc-0.1.0
dora-video-capture-0.1.0
dora-video-sink-0.1.0
fast_detector-0.1.0
features-0.1.0
hello_world-0.1.9
histogram-0.1.9
icp_registration-0.1.9
imgproc-0.1.9
metrics-0.1.9
normalize-0.1.9
normalize_ii-0.1.9
onnx-0.1.9
ply_rerun-0.1.9
rerun_viz-0.1.9
rotate-0.1.9
std_mean-0.1.9
undistort-0.1.9
rtspcam-0.1.0
video_write-0.1.0
video_write_tasks-0.1.0
webcam-0.1.0
kornia-image-0.1.6+dev
kornia-imgproc-0.1.6+dev
kornia-io-0.1.6+dev
kornia-py-0.1.9
kornia-rs-0.1.6+dev
kornia-serve-0.1.6+dev
"

declare -A GIT_CRATES=(
)

# From "./convert-cargo-lock.sh 0.1.9 0.1.9"
CRATES="
ab_glyph-0.2.31
ab_glyph_rasterizer-0.1.10
adler2-2.0.1
adler2-2.0.1
aho-corasick-1.1.3
aligned-vec-0.6.4
aligned-vec-0.6.4
anes-0.1.6
anstyle-1.0.11
anyhow-1.0.99
anyhow-1.0.99
approx-0.5.1
arbitrary-1.4.1
arbitrary-1.4.1
arg_enum_proc_macro-0.3.4
arg_enum_proc_macro-0.3.4
array-init-2.1.0
array-init-2.1.0
arrayvec-0.7.6
arrayvec-0.7.6
atomic_refcell-0.1.13
autocfg-1.5.0
autocfg-1.5.0
av1-grain-0.2.4
av1-grain-0.2.4
avif-serialize-0.8.5
avif-serialize-0.8.5
az-1.2.1
az-1.2.1
bincode-1.3.3
bincode-1.3.3
bincode-2.0.1
bincode_derive-2.0.1
bit_field-0.10.2
bit_field-0.10.2
bitflags-1.3.2
bitflags-1.3.2
bitflags-2.9.1
bitflags-2.9.1
bitstream-io-2.6.0
bitstream-io-2.6.0
block-buffer-0.10.4
block-buffer-0.10.4
built-0.7.7
built-0.7.7
bumpalo-3.19.0
bumpalo-3.19.0
bytemuck-1.23.2
bytemuck-1.23.2
bytemuck_derive-1.10.1
bytemuck_derive-1.10.1
byteorder-1.5.0
byteorder-1.5.0
byteorder-lite-0.1.0
byteorder-lite-0.1.0
cast-0.3.0
cc-1.2.32
cc-1.2.32
cfg-expr-0.15.8
cfg-expr-0.15.8
cfg-if-1.0.1
cfg-if-1.0.1
ciborium-0.2.2
ciborium-io-0.2.2
ciborium-ll-0.2.2
circular-buffer-1.1.0
circular-buffer-1.1.0
clap-4.5.45
clap_builder-4.5.44
clap_lex-0.7.5
cmake-0.1.54
cmake-0.1.54
cmov-0.3.1
cmov-0.3.1
coe-rs-0.1.2
coe-rs-0.1.2
color_quant-1.1.0
color_quant-1.1.0
cpufeatures-0.2.17
cpufeatures-0.2.17
crc32fast-1.5.0
crc32fast-1.5.0
criterion-0.5.1
criterion-plot-0.5.0
crossbeam-deque-0.8.6
crossbeam-deque-0.8.6
crossbeam-epoch-0.9.18
crossbeam-epoch-0.9.18
crossbeam-utils-0.8.21
crossbeam-utils-0.8.21
crunchy-0.2.4
crunchy-0.2.4
crypto-common-0.1.6
crypto-common-0.1.6
dbgf-0.1.2
dbgf-0.1.2
digest-0.10.7
digest-0.10.7
divrem-1.0.0
divrem-1.0.0
doc-comment-0.3.3
doc-comment-0.3.3
document-features-0.2.11
document-features-0.2.11
dyn-stack-0.11.0
dyn-stack-0.11.0
dyn-stack-0.13.0
dyn-stack-0.13.0
either-1.15.0
either-1.15.0
enum-as-inner-0.6.1
enum-as-inner-0.6.1
equator-0.2.2
equator-0.2.2
equator-0.4.2
equator-0.4.2
equator-macro-0.2.1
equator-macro-0.2.1
equator-macro-0.4.2
equator-macro-0.4.2
equivalent-1.0.2
equivalent-1.0.2
errno-0.3.13
exr-1.73.0
exr-1.73.0
faer-0.20.2
faer-0.20.2
faer-entity-0.20.1
faer-entity-0.20.1
fast_image_resize-5.2.1
fast_image_resize-5.2.1
fastrand-2.3.0
fdeflate-0.3.7
fdeflate-0.3.7
fixed-1.29.0
fixed-1.29.0
flate2-1.1.2
flate2-1.1.2
futures-channel-0.3.31
futures-core-0.3.31
futures-executor-0.3.31
futures-macro-0.3.31
futures-sink-0.3.31
futures-task-0.3.31
futures-util-0.3.31
gcd-2.3.0
gcd-2.3.0
gemm-0.18.2
gemm-0.18.2
gemm-c32-0.18.2
gemm-c32-0.18.2
gemm-c64-0.18.2
gemm-c64-0.18.2
gemm-common-0.18.2
gemm-common-0.18.2
gemm-f16-0.18.2
gemm-f16-0.18.2
gemm-f32-0.18.2
gemm-f32-0.18.2
gemm-f64-0.18.2
gemm-f64-0.18.2
generativity-1.1.0
generativity-1.1.0
generator-0.8.5
generator-0.8.5
generic-array-0.14.7
generic-array-0.14.7
getrandom-0.2.16
getrandom-0.2.16
getrandom-0.3.3
getrandom-0.3.3
gif-0.13.3
gif-0.13.3
gio-sys-0.19.8
glam-0.30.5
glib-0.19.9
glib-macros-0.19.9
glib-sys-0.19.8
gobject-sys-0.19.8
gstreamer-0.22.8
gstreamer-app-0.22.6
gstreamer-app-sys-0.22.6
gstreamer-base-0.22.6
gstreamer-base-sys-0.22.6
gstreamer-sys-0.22.6
half-2.6.0
half-2.6.0
hashbrown-0.15.5
hashbrown-0.15.5
heck-0.5.0
heck-0.5.0
hermit-abi-0.5.2
image-0.25.6
image-0.25.6
imageproc-0.25.0
image-webp-0.2.3
image-webp-0.2.3
imgref-1.11.0
imgref-1.11.0
indexmap-2.10.0
indexmap-2.10.0
indoc-2.0.6
interpolate_name-0.2.4
interpolate_name-0.2.4
is-terminal-0.4.16
itertools-0.10.5
itertools-0.12.1
itertools-0.12.1
itertools-0.13.0
itoa-1.0.15
jobserver-0.1.33
jobserver-0.1.33
jpeg-decoder-0.3.2
jpeg-decoder-0.3.2
jpeg-encoder-0.6.1
jpeg-encoder-0.6.1
js-sys-0.3.77
kiddo-5.2.2
kiddo-5.2.2
kornia-0.1.9
kornia-3d-0.1.9
kornia-3d-0.1.9
kornia-icp-0.1.9
kornia-icp-0.1.9
kornia-image-0.1.9
kornia-image-0.1.9
kornia-imgproc-0.1.9
kornia-imgproc-0.1.9
kornia-io-0.1.9
kornia-io-0.1.9
kornia-linalg-0.1.9
kornia-py-0.1.9
kornia-tensor-0.1.9
kornia-tensor-0.1.9
kornia-tensor-ops-0.1.9
lazy_static-1.5.0
lazy_static-1.5.0
lebe-0.5.2
lebe-0.5.2
libc-0.2.175
libc-0.2.175
libfuzzer-sys-0.4.10
libfuzzer-sys-0.4.10
libm-0.2.15
libm-0.2.15
linux-raw-sys-0.9.4
litrs-0.4.2
litrs-0.4.2
log-0.4.27
log-0.4.27
loop9-0.1.5
loop9-0.1.5
matrixcompare-0.3.0
matrixcompare-0.3.0
matrixcompare-core-0.1.0
matrixcompare-core-0.1.0
matrixmultiply-0.3.10
matrixmultiply-0.3.10
maybe-rayon-0.1.1
maybe-rayon-0.1.1
memchr-2.7.5
memchr-2.7.5
memoffset-0.9.1
minimal-lexical-0.2.1
minimal-lexical-0.2.1
miniz_oxide-0.8.9
miniz_oxide-0.8.9
muldiv-1.0.1
nalgebra-0.32.6
nano-gemm-0.1.3
nano-gemm-0.1.3
nano-gemm-c32-0.1.0
nano-gemm-c32-0.1.0
nano-gemm-c64-0.1.0
nano-gemm-c64-0.1.0
nano-gemm-codegen-0.1.0
nano-gemm-codegen-0.1.0
nano-gemm-core-0.1.0
nano-gemm-core-0.1.0
nano-gemm-f32-0.1.0
nano-gemm-f32-0.1.0
nano-gemm-f64-0.1.0
nano-gemm-f64-0.1.0
ndarray-0.15.6
ndarray-0.16.1
new_debug_unreachable-1.0.6
new_debug_unreachable-1.0.6
nom-7.1.3
nom-7.1.3
noop_proc_macro-0.3.0
noop_proc_macro-0.3.0
npyz-0.8.4
npyz-0.8.4
nu-ansi-term-0.46.0
nu-ansi-term-0.46.0
num-0.4.3
num-bigint-0.4.6
num-bigint-0.4.6
num-complex-0.4.6
num-complex-0.4.6
num-derive-0.4.2
num-derive-0.4.2
num-integer-0.1.46
num-integer-0.1.46
num-iter-0.1.45
numpy-0.24.0
num-rational-0.4.2
num-rational-0.4.2
num-traits-0.2.19
num-traits-0.2.19
once_cell-1.21.3
once_cell-1.21.3
oorandom-11.1.5
option-operations-0.5.0
ordered-float-5.0.0
ordered-float-5.0.0
overload-0.1.1
overload-0.1.1
owned_ttf_parser-0.25.1
paste-1.0.15
paste-1.0.15
pest-2.8.1
pest-2.8.1
pest_derive-2.8.1
pest_derive-2.8.1
pest_generator-2.8.1
pest_generator-2.8.1
pest_meta-2.8.1
pest_meta-2.8.1
pin-project-lite-0.2.16
pin-project-lite-0.2.16
pin-utils-0.1.0
pkg-config-0.3.32
pkg-config-0.3.32
plotters-0.3.7
plotters-backend-0.3.7
plotters-svg-0.3.7
png-0.17.16
png-0.17.16
portable-atomic-1.11.1
portable-atomic-util-0.2.4
ppv-lite86-0.2.21
ppv-lite86-0.2.21
proc-macro2-1.0.97
proc-macro2-1.0.97
proc-macro-crate-3.3.0
profiling-1.0.17
profiling-1.0.17
profiling-procmacros-1.0.17
profiling-procmacros-1.0.17
pulp-0.18.22
pulp-0.18.22
pulp-0.21.5
pulp-0.21.5
py_literal-0.4.0
py_literal-0.4.0
pyo3-0.24.2
pyo3-build-config-0.24.2
pyo3-ffi-0.24.2
pyo3-macros-0.24.2
pyo3-macros-backend-0.24.2
qoi-0.4.1
qoi-0.4.1
quick-error-2.0.1
quick-error-2.0.1
quote-1.0.40
quote-1.0.40
rand-0.8.5
rand-0.8.5
rand-0.9.2
rand_chacha-0.3.1
rand_chacha-0.3.1
rand_chacha-0.9.0
rand_core-0.6.4
rand_core-0.6.4
rand_core-0.9.3
rand_distr-0.4.3
rand_distr-0.4.3
rav1e-0.7.1
rav1e-0.7.1
ravif-0.11.20
ravif-0.11.20
raw-cpuid-11.5.0
raw-cpuid-11.5.0
rawpointer-0.2.1
rawpointer-0.2.1
rayon-1.11.0
rayon-1.11.0
rayon-core-1.13.0
rayon-core-1.13.0
reborrow-0.5.5
reborrow-0.5.5
r-efi-5.3.0
r-efi-5.3.0
regex-1.11.1
regex-automata-0.4.9
regex-syntax-0.8.5
rgb-0.8.52
rgb-0.8.52
rustc-hash-2.1.1
rustix-1.0.8
rustversion-1.0.22
rustversion-1.0.22
ryu-1.0.20
safe_arch-0.7.4
same-file-1.0.6
same-file-1.0.6
seq-macro-0.3.6
seq-macro-0.3.6
serde-1.0.219
serde-1.0.219
serde_derive-1.0.219
serde_derive-1.0.219
serde_json-1.0.142
serde_spanned-0.6.9
serde_spanned-0.6.9
sha2-0.10.9
sha2-0.10.9
sharded-slab-0.1.7
sharded-slab-0.1.7
shlex-1.3.0
shlex-1.3.0
simba-0.8.1
simd-adler32-0.3.7
simd-adler32-0.3.7
simd_helpers-0.1.0
simd_helpers-0.1.0
slab-0.4.11
smallvec-1.15.1
smallvec-1.15.1
sorted-vec-0.8.7
sorted-vec-0.8.7
syn-2.0.105
syn-2.0.105
sysctl-0.6.0
sysctl-0.6.0
system-deps-6.2.2
system-deps-6.2.2
target-lexicon-0.12.16
target-lexicon-0.12.16
target-lexicon-0.13.2
tempfile-3.20.0
thiserror-1.0.69
thiserror-1.0.69
thiserror-2.0.14
thiserror-2.0.14
thiserror-impl-1.0.69
thiserror-impl-1.0.69
thiserror-impl-2.0.14
thiserror-impl-2.0.14
thread_local-1.1.9
thread_local-1.1.9
tiff-0.9.1
tiff-0.9.1
tinytemplate-1.2.1
toml-0.8.23
toml-0.8.23
toml_datetime-0.6.11
toml_datetime-0.6.11
toml_edit-0.22.27
toml_edit-0.22.27
tracing-0.1.41
tracing-0.1.41
tracing-attributes-0.1.30
tracing-attributes-0.1.30
tracing-core-0.1.34
tracing-core-0.1.34
tracing-log-0.2.0
tracing-log-0.2.0
tracing-subscriber-0.3.19
tracing-subscriber-0.3.19
ttf-parser-0.25.1
turbojpeg-1.3.3
turbojpeg-1.3.3
turbojpeg-sys-1.1.1
turbojpeg-sys-1.1.1
typenum-1.18.0
typenum-1.18.0
ucd-trie-0.1.7
ucd-trie-0.1.7
unicode-ident-1.0.18
unicode-ident-1.0.18
unindent-0.2.4
unty-0.0.4
valuable-0.1.1
valuable-0.1.1
version_check-0.9.5
version_check-0.9.5
version-compare-0.2.0
version-compare-0.2.0
v_frame-0.3.9
v_frame-0.3.9
virtue-0.0.18
walkdir-2.5.0
walkdir-2.5.0
wasi-0.11.1+wasi-snapshot-preview1
wasi-0.11.1+wasi-snapshot-preview1
wasi-0.14.2+wasi-0.2.4
wasi-0.14.2+wasi-0.2.4
wasm-bindgen-0.2.100
wasm-bindgen-0.2.100
wasm-bindgen-backend-0.2.100
wasm-bindgen-backend-0.2.100
wasm-bindgen-macro-0.2.100
wasm-bindgen-macro-0.2.100
wasm-bindgen-macro-support-0.2.100
wasm-bindgen-macro-support-0.2.100
wasm-bindgen-shared-0.2.100
wasm-bindgen-shared-0.2.100
web-sys-0.3.77
weezl-0.1.10
weezl-0.1.10
wide-0.7.33
winapi-0.3.9
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.9
winapi-util-0.1.9
winapi-x86_64-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.61.3
windows-0.61.3
windows_aarch64_gnullvm-0.52.6
windows_aarch64_gnullvm-0.52.6
windows_aarch64_gnullvm-0.53.0
windows_aarch64_msvc-0.52.6
windows_aarch64_msvc-0.52.6
windows_aarch64_msvc-0.53.0
windows-collections-0.2.0
windows-collections-0.2.0
windows-core-0.61.2
windows-core-0.61.2
windows-future-0.2.1
windows-future-0.2.1
windows_i686_gnu-0.52.6
windows_i686_gnu-0.52.6
windows_i686_gnu-0.53.0
windows_i686_gnullvm-0.52.6
windows_i686_gnullvm-0.52.6
windows_i686_gnullvm-0.53.0
windows_i686_msvc-0.52.6
windows_i686_msvc-0.52.6
windows_i686_msvc-0.53.0
windows-implement-0.60.0
windows-implement-0.60.0
windows-interface-0.59.1
windows-interface-0.59.1
windows-link-0.1.3
windows-link-0.1.3
windows-numerics-0.2.0
windows-numerics-0.2.0
windows-result-0.3.4
windows-result-0.3.4
windows-strings-0.4.2
windows-strings-0.4.2
windows-sys-0.52.0
windows-sys-0.59.0
windows-sys-0.59.0
windows-sys-0.60.2
windows-targets-0.52.6
windows-targets-0.52.6
windows-targets-0.53.3
windows-threading-0.1.0
windows-threading-0.1.0
windows_x86_64_gnu-0.52.6
windows_x86_64_gnu-0.52.6
windows_x86_64_gnu-0.53.0
windows_x86_64_gnullvm-0.52.6
windows_x86_64_gnullvm-0.52.6
windows_x86_64_gnullvm-0.53.0
windows_x86_64_msvc-0.52.6
windows_x86_64_msvc-0.52.6
windows_x86_64_msvc-0.53.0
winnow-0.7.12
winnow-0.7.12
wit-bindgen-rt-0.39.0
wit-bindgen-rt-0.39.0
zerocopy-0.8.26
zerocopy-0.8.26
zerocopy-derive-0.8.26
zerocopy-derive-0.8.26
zune-core-0.4.12
zune-core-0.4.12
zune-inflate-0.2.54
zune-inflate-0.2.54
zune-jpeg-0.4.20
zune-jpeg-0.4.20
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
IUSE+="
dev test
ebuild_revision_4
"
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
	$(python_gen_cond_dep '
		>=dev-util/maturin-1[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev? (
			>=dev-python/numpy-1.23.0[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
		)
	')
	|| (
		dev-lang/rust:${RUST_PV}
		dev-lang/rust-bin:${RUST_PV}
	)
	|| (
		dev-lang/rust:=
		dev-lang/rust-bin:=
	)
	dev? (
		>=dev-python/kornia-0.7.2[${PYTHON_SINGLE_USEDEP}]
		dev-python/jax[${PYTHON_SINGLE_USEDEP},cpu]
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

einfo "Fixing vulnerabilities"
#	cargo install "glib@0.20.0"						# GHSA-wrw7-89jp-8q8g; ZC, DT; Moderate

	die
}

_production_unpack() {
	unpack "${P}.tar.gz"
	#die # For manual lockfile updates

	# Downgrades required:

	# cargo update --package fast_image_resize --precise 5.1.0
	# cargo update --package ort --precise 2.0.0-rc.9
	# cargo update --package ort-sys --precise 2.0.0-rc.9


	# Upgrade steps:

	# Delete examples folder
	# Downgrade fast_image_resize
	# Downgrade gstreamer to 0.22

}

pkg_setup() {
	python-single-r1_pkg_setup
	rust_pkg_setup
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
		if [[ "${GENERATE_LOCKFILE}" != "1" ]] ; then
			cp -aT \
				"${FILESDIR}/${PV}"* \
				"${S}" \
				|| die
		fi
	fi
}

src_prepare() {
	distutils-r1_src_prepare
	rm -rf "examples"
}

src_configure() {
	distutils-r1_src_configure
}


python_compile() {
#	edo python3 -m venv .venv
#	edo maturin develop -m kornia-py/Cargo.toml
#	emake build-python-release
#	export S="${WORKDIR}/${PN}-${PV}"

	# Fix path
	#cp -aT "${S}/examples/video_write tasks" "${S}/examples/video_write_tasks" || die
	#rm -rf "${S}/examples/video_write tasks"

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
