# Copyright 2022-2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D12, U22

# This contains info obtained by AI inference.
# This ebuild contains AI generated assets/artifacts.

#
# I verified that it is possible to run as a limited user.
#
# Security score
#
# | Property               | Before       | After               |
# | ---                    | ---          | ---                 |
# | Privilege level        | Root (10/10) | Limited user + caps |
# | Attack surface         | Very high    | Medium low          |
# | Compromised impact     | Catastropic  | Moderate            |
# | Filesystem access      | Full         | Restricted          |
# | Raw hardware access    | Unlimited    | Only needed caps    |
# | Overall security score | 3.5 / 10     | 7.8 / 10            |
#

inherit secure-version

CFLAGS_HARDENED_USE_CASES="secure-version sensitive-data untrusted-data"
NODE_SLOT="24"
NPM_TARBALL="coolercontrol-${PV}.tar.bz2"
PYTHON_COMPAT=( "python3_11" )
RUST_MAX_VER="${RUST_LLVM_ROLLING_PV}"
RUST_MIN_VER="${RUST_LLVM_ROLLING_PV}"
RUST_PV="${RUST_MAX_VER}"
RUSTFLAGS_HARDENED_USE_CASES="secure-version sensitive-data untrusted-data"

# Tonic doesn't need native C/C++ gRPC dep.
ABSEIL_CPP_SLOT="20220623"
PROTOBUF_CPP_SLOT="3"

# Only provide the necessary capabilities
# cap_dac_override - For applying CPU/GPU fan control settings for /sys/class/hwmon/
# cap_sys_rawio - For SuperIO detection through /dev/port
FILECAPS=(
	"cap_sys_rawio,cap_dac_override=ep" "usr/bin/coolercontrold"
)

# NPM_AUDIT_FIX=0
NPM_INSTALL_ARGS=(
	"--prefer-offline"
)

VIDEO_CARDS=(
	"video_cards_amdgpu"
	"video_cards_nvidia"
)

# To update npm side use:
# PATH=$(realpath "../../scripts")":${PATH}"
# NPM_UPDATER_PROJECT_ROOT="coolercontrol-5.1.2/coolercontrol-ui" NPM_UPDATER_VERSIONS="5.1.2" npm_updater_update_locks.sh

# To update cargo size use:
# ./convert-cargo-lock.sh 5.1.2 5.1.2

# Remove the -2-0 suffix
declare -A GIT_CRATES=(
)

DISABLED_CRATES="
cc-detect-1.0.1
cc-image-1.0.0
cc-stress-0.2.1
"

CRATES="
adler2-2.0.1
aead-0.5.2
aes-0.8.4
aes-gcm-0.10.3
ahash-0.8.12
aho-corasick-1.1.5
aide-0.15.1
aligned-0.4.3
aligned-vec-0.6.4
android_system_properties-0.1.6
anstream-1.0.0
anstyle-1.0.14
anstyle-parse-1.0.0
anstyle-query-1.1.5
anstyle-wincon-3.0.11
anyhow-1.0.104
arbitrary-1.5.0
arc-swap-1.9.5
arg_enum_proc_macro-0.3.4
argon2-0.6.0
arrayref-0.3.9
arrayvec-0.7.8
ash-0.38.0+1.3.281
asn1-rs-0.7.2
asn1-rs-derive-0.6.0
asn1-rs-impl-0.2.0
as-slice-0.2.1
async-compression-0.4.52
async-trait-0.1.92
atomic-waker-1.1.2
autocfg-1.5.1
av1-grain-0.2.5
avif-serialize-0.8.9
av-scenechange-0.14.1
axum-0.8.9
axum-core-0.5.6
axum-macros-0.5.1
axum-server-0.9.2
base64-0.22.1
base64-0.23.1
base64ct-1.8.3
beef-0.5.2
bit_field-0.10.4
bitflags-1.3.2
bitflags-2.13.2
bit-set-0.8.0
bitstream-io-4.10.0
bit-vec-0.8.0
bit-vec-0.9.1
blake2-0.11.0
block-0.1.6
block-buffer-0.10.4
block-buffer-0.12.1
built-0.8.1
bumpalo-3.20.4
bytemuck-1.25.2
bytemuck_derive-1.12.1
byteorder-lite-0.1.0
bytes-1.12.2
cc-1.11.3
cfg_aliases-0.2.2
cfg-if-1.0.5
chrono-0.4.45
cipher-0.4.4
clap-4.6.9
clap_builder-4.6.7
clap_derive-4.6.9
clap_lex-1.1.2
cmov-0.5.4
codespan-reporting-0.11.1
colorchoice-1.0.5
color_quant-1.1.0
compression-codecs-0.4.47
compression-core-0.4.34
cookie-0.18.2
core_detect-1.0.0
core-foundation-0.9.4
core-foundation-sys-0.8.7
core-graphics-types-0.1.3
cpufeatures-0.2.17
cpufeatures-0.3.1
crc32fast-1.5.5
crossbeam-channel-0.5.17
crossbeam-deque-0.8.8
crossbeam-epoch-0.9.21
crossbeam-utils-0.8.23
crunchy-0.2.4
crypto-common-0.1.7
crypto-common-0.2.2
ctr-0.9.2
ctutils-0.4.8
darling-0.20.11
darling_core-0.20.11
darling_macro-0.20.11
data-encoding-2.11.1
deranged-0.5.9
der-parser-10.0.0
digest-0.10.7
digest-0.11.3
displaydoc-0.2.7
document-features-0.2.12
dyn-clone-1.0.20
either-1.19.0
encoding_rs-0.8.44
endi-1.1.1
env_filter-2.1.0
env_logger-0.11.12
equator-0.4.2
equator-macro-0.4.2
equivalent-1.0.3
errno-0.3.15
exr-1.74.3
fastrand-2.5.0
fax-0.2.7
fdeflate-0.3.7
filetime-0.2.30
find-msvc-tools-0.1.15
fixedbitset-0.5.9
flate2-1.1.11
fnv-1.0.7
foldhash-0.1.5
fontdue-0.7.3
foreign-types-0.5.0
foreign-types-macros-0.2.4
foreign-types-shared-0.3.1
form_urlencoded-1.2.3
fs-err-3.3.2
futures-0.3.34
futures-channel-0.3.34
futures-core-0.3.34
futures-executor-0.3.34
futures-io-0.3.34
futures-macro-0.3.34
futures-sink-0.3.34
futures-task-0.3.34
futures-util-0.3.34
generic-array-0.14.7
getrandom-0.2.17
getrandom-0.3.4
getrandom-0.4.3
ghash-0.5.1
gif-0.13.3
gif-0.14.2
gif-dispose-5.0.1
gifski-1.34.0
gl_generator-0.14.0
glob-0.3.4
glow-0.16.0
glutin_wgl_sys-0.6.1
gpu-alloc-0.6.2
gpu-alloc-types-0.3.1
gpu-descriptor-0.3.2
gpu-descriptor-types-0.2.0
h2-0.4.20
half-2.7.1
hashbrown-0.13.2
hashbrown-0.15.5
hashbrown-0.17.1
heck-0.5.0
hex-0.4.3
hexf-parse-0.2.1
hkdf-0.12.4
hmac-0.12.1
http-1.5.0
httparse-1.10.1
http-body-1.1.0
http-body-util-0.1.5
httpdate-1.0.3
http-range-header-0.4.2
hybrid-array-0.4.15
hyper-1.12.0
hyper-timeout-0.5.2
hyper-util-0.1.21
iana-time-zone-0.1.65
iana-time-zone-haiku-0.1.2
ident_case-1.0.1
image-0.25.10
imagequant-4.4.1
image-webp-0.2.4
imgref-1.12.3
include_dir-0.7.4
include_dir_macros-0.7.4
indexmap-2.14.2
inout-0.1.4
interpolate_name-0.2.4
is_terminal_polyfill-1.70.2
itertools-0.14.0
itertools-0.15.0
itoa-1.0.19
jiff-1.0.1
jiff-core-1.0.1
jiff-static-1.0.1
jni-sys-0.3.1
jni-sys-0.4.1
jni-sys-macros-0.4.1
jobserver-0.1.35
js-sys-0.3.107
khronos_api-3.1.0
khronos-egl-6.0.0
lazy_static-1.5.1
lebe-0.5.3
libc-0.2.191
libdrm_amdgpu_sys-0.9.0
libfuzzer-sys-0.4.13
libloading-0.8.9
linux-raw-sys-0.12.1
litrs-1.0.1
lock_api-0.4.14
log-0.4.35
logos-0.15.1
logos-0.16.1
logos-codegen-0.15.1
logos-codegen-0.16.1
logos-derive-0.15.1
logos-derive-0.16.1
loop9-0.1.5
malloc_buf-0.0.6
matchit-0.8.4
maybe-rayon-0.1.1
memchr-2.8.3
memoffset-0.9.1
metal-0.31.0
miette-7.6.0
miette-derive-7.6.0
mime-0.3.18
mime_guess-2.0.5
minimal-lexical-0.2.1
miniz_oxide-0.8.9
miniz_oxide-0.9.1
mio-1.2.5
moro-local-0.4.0
moxcms-0.8.1
multer-3.1.0
multimap-0.10.1
multiversion-0.8.1
multiversion-macros-0.8.1
multiversion_no_op-1.0.0
naga-24.0.0
ndk-sys-0.5.0+25.2.9519653
new_debug_unreachable-1.0.6
nix-0.31.4
nom-7.1.3
nom-8.0.0
noop_proc_macro-0.3.0
no_std_io2-0.9.4
ntapi-0.4.3
num-bigint-0.4.8
num-conv-0.2.2
num-derive-0.4.2
num-integer-0.1.47
num-rational-0.4.2
num-traits-0.2.19
nvml-wrapper-0.13.0
nvml-wrapper-sys-0.10.0
objc-0.2.7
objc2-core-foundation-0.3.2
objc2-io-kit-0.3.2
oid-registry-0.8.1
once_cell-1.21.4
once_cell_polyfill-1.70.2
opaque-debug-0.3.1
ordered-channel-1.2.0
ordered-float-4.6.0
ordered-stream-0.2.0
parking_lot-0.12.5
parking_lot_core-0.9.12
password-hash-0.6.1
paste-1.0.15
pastey-0.1.1
pem-4.0.0
percent-encoding-2.3.2
petgraph-0.8.3
phc-0.6.1
pin-project-1.2.0
pin-project-internal-1.2.0
pin-project-lite-0.2.18
pkg-config-0.3.34
png-0.17.16
png-0.18.1
polyval-0.6.2
portable-atomic-1.15.0
portable-atomic-util-0.2.8
powerfmt-0.2.1
ppv-lite86-0.2.21
prettyplease-0.2.37
prettyplease-0.3.0
proc-macro2-1.0.107
profiling-1.0.18
profiling-procmacros-1.0.18
prost-0.14.6
prost-build-0.14.6
prost-derive-0.14.6
prost-reflect-0.16.5
prost-types-0.14.6
protox-0.9.1
protox-parse-0.9.0
pulldown-cmark-0.13.6
pulldown-cmark-to-cmark-22.0.3
pxfm-0.1.30
quick-error-2.0.1
quote-1.0.47
rand-0.8.8
rand-0.9.5
rand_chacha-0.3.1
rand_chacha-0.9.0
rand_core-0.6.4
rand_core-0.9.5
rav1e-0.8.1
ravif-0.13.0
raw-window-handle-0.6.2
rayon-1.12.0
rayon-core-1.13.0
rcgen-0.14.10
redox_syscall-0.5.18
ref-cast-1.0.27
ref-cast-impl-1.0.27
r-efi-5.3.0
r-efi-6.0.0
regex-1.13.2
regex-automata-0.4.19
regex-syntax-0.8.12
renderdoc-sys-1.1.0
resize-0.8.9
rgb-0.8.53
ril-0.10.3
ring-0.17.14
rustc-hash-1.1.0
rustc_version-0.4.1
rusticata-macros-4.1.0
rustix-1.1.6
rustls-0.23.46
rustls-pki-types-1.16.0
rustls-webpki-0.103.17
rustversion-1.0.23
ryu-1.0.23
schemars-0.9.0
schemars_derive-0.9.0
scopeguard-1.2.0
sd-notify-0.5.0
semver-1.0.28
serde-1.0.229
serde_core-1.0.229
serde_derive-1.0.229
serde_derive_internals-0.29.1
serde_json-1.0.154
serde_path_to_error-0.1.20
serde_qs-0.14.0
serde_repr-0.1.21
serde_spanned-1.1.3
serde_urlencoded-0.7.1
serial_test-4.0.1
serial_test_derive-4.0.1
sha2-0.10.9
shlex-2.0.1
signal-hook-registry-1.4.8
simd-adler32-0.3.10
simd_helpers-0.1.0
simdutf8-0.1.5
slab-0.4.12
slotmap-1.1.1
smallvec-1.16.6
socket2-0.6.5
spin-0.9.9
spirv-0.3.0+sdk-1.3.268.0
stable_deref_trait-1.2.1
static_assertions-1.1.0
strict-num-0.1.1
strsim-0.11.1
strum-0.26.3
strum-0.28.0
strum_macros-0.26.4
strum_macros-0.28.0
subtle-2.6.1
syn-2.0.119
syn-3.0.10
sync_wrapper-1.0.2
synstructure-0.13.2
sysinfo-0.40.4
systemd-journal-logger-2.2.2
tar-0.4.46
target-features-0.1.6
tempfile-3.27.0
termcolor-1.4.1
thiserror-1.0.69
thiserror-2.0.21
thiserror-impl-1.0.69
thiserror-impl-2.0.21
thread_local-1.1.10
tiff-0.11.3
time-0.3.55
time-core-0.1.9
time-macros-0.2.32
tiny-skia-0.12.0
tiny-skia-path-0.12.0
tokio-1.54.1
tokio-macros-2.7.2
tokio-rustls-0.26.6
tokio-stream-0.1.19
tokio-util-0.7.20
toml-1.2.1+spec-1.1.0
toml_datetime-1.1.3+spec-1.1.0
toml_edit-0.25.19+spec-1.1.0
toml_parser-1.1.5+spec-1.1.0
toml_writer-1.2.0+spec-1.1.0
tonic-0.14.9
tonic-build-0.14.9
tonic-health-0.14.9
tonic-prost-0.14.9
tonic-prost-build-0.14.9
tower-0.5.3
tower-cookies-0.11.0
tower-http-0.7.1
tower-layer-0.3.3
tower-serve-static-0.1.2
tower-service-0.3.3
tower-sessions-0.15.0
tower-sessions-core-0.15.0
tower-sessions-memory-store-0.15.0
tracing-0.1.44
tracing-attributes-0.1.31
tracing-core-0.1.36
try-lock-0.2.5
ttf-parser-0.15.2
typenum-1.20.1
uds_windows-1.2.1
unicase-2.10.0
unicode-ident-1.0.27
unicode-width-0.1.14
unicode-xid-0.2.6
universal-hash-0.5.1
untrusted-0.9.0
utf8parse-0.2.2
uuid-1.29.3
version_check-0.9.5
v_frame-0.3.9
want-0.3.2
wasi-0.11.1+wasi-snapshot-preview1
wasip2-1.0.4+wasi-0.2.12
wasm-bindgen-0.2.130
wasm-bindgen-futures-0.4.80
wasm-bindgen-macro-0.2.130
wasm-bindgen-macro-support-0.2.130
wasm-bindgen-shared-0.2.130
web-sys-0.3.107
weezl-0.1.12
wgpu-24.0.5
wgpu-core-24.0.5
wgpu-hal-24.0.4
wgpu-types-24.0.0
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.11
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.58.0
windows-0.62.2
windows_aarch64_gnullvm-0.52.6
windows_aarch64_msvc-0.52.6
windows-collections-0.3.2
windows-core-0.58.0
windows-core-0.62.2
windows-future-0.3.2
windows_i686_gnu-0.52.6
windows_i686_gnullvm-0.52.6
windows_i686_msvc-0.52.6
windows-implement-0.58.0
windows-implement-0.60.2
windows-interface-0.58.0
windows-interface-0.59.3
windows-link-0.2.1
windows-numerics-0.3.1
windows-result-0.2.0
windows-result-0.4.1
windows-strings-0.1.0
windows-strings-0.5.1
windows-sys-0.52.0
windows-sys-0.61.2
windows-targets-0.52.6
windows-threading-0.2.1
windows_x86_64_gnu-0.52.6
windows_x86_64_gnullvm-0.52.6
windows_x86_64_msvc-0.52.6
winnow-1.0.5
wit-bindgen-0.57.1
wrapcenum-derive-0.4.1
x509-parser-0.18.1
xml-rs-0.8.29
y4m-0.8.0
yasna-0.6.0
zbus-6.5.0
zbus_macros-6.5.0
zbus_utils-6.1.0
zcheapstr-1.4.0
zerocopy-0.8.63
zerocopy-derive-0.8.63
zeroize-1.9.2
zlib-rs-0.6.8
zmij-1.0.23
zruntime-0.2.4
zune-core-0.5.3
zune-inflate-0.2.54
zune-jpeg-0.5.15
"

CHKL_TIMESTAMPS=(
	"app-arch/zstd-9999"
	"x11-libs/libdrm-9999"
)

inherit abseil-cpp cargo cflags-hardened fcaps lcnr npm protobuf python-single-r1 rust rustflags-hardened

KEYWORDS="~amd64"
S_ROOT="${WORKDIR}/coolercontrol-${PV}"
S="${S_ROOT}/coolercontrold"
SRC_URI="
$(cargo_crate_uris ${CRATES})
https://gitlab.com/coolercontrol/coolercontrol/-/archive/${PV}/coolercontrol-${PV}.tar.bz2
"

DESCRIPTION="The CoolerControl system service that handles controlling hardware"
HOMEPAGE="
https://gitlab.com/coolercontrol/coolercontrol
https://gitlab.com/coolercontrol/coolercontrol/-/tree/main/coolercontrold
"
CARGO_PACKAGES_LICENSES="
	(
		Apache-2.0
		BSD
		CC-BY-3.0
		MIT
	)
	(
		ISC
		MIT
		openssl
		SSLeay
	)
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	Boost-1.0
	BSD-2
	GPL-3+
	HPND-Pbmplus
	ISC
	MIT
	MPL-2.0
	Unicode-DFS-2016
	Unlicense
	ZLIB
	|| (
		Apache-2.0
		MIT
	)
	|| (
		Apache-2.0
		Apache-2.0-with-LLVM-exceptions
		MIT
	)
"
NPM_PACKAGES_LICENSES="
	(
		CC-BY-4.0
		MIT
		Unicode-DFS-2016
		W3C-Community-Final-Specification-Agreement
		W3C-Software-and-Document-Notice-and-License
	)
	(
		Apache-2.0
		MIT
	)
	(
		Apache-2.0
		all-rights-reserved
	)
	0BSD
	CC0-1.0
	custom
"
# ( Apache-2.0, all-rights-reserved ) coolercontrol-ui/node_modules/reflect-metadata/CopyrightNotice.txt ; The distro's Apache-2.0 license template does not have all rights reserved
# ( MIT all-rights-reserved ) coolercontrol-ui/node_modules/sass/LICENSE
# 0BSD - coolercontrol-ui/node_modules/tslib/CopyrightNotice.txt
# CC0-1.0 - coolercontrol-ui/node_modules/csso/node_modules/mdn-data/LICENSE
# custom - coolercontrol-ui/node_modules/jackspeak/LICENSE.md
#   keywords:  "This license gives everyone as much permission to work with"
# Apache-2.0, MIT - coolercontrol-ui/node_modules/@mdi/js/LICENSE
# CC-BY-4.0, MIT, Unicode-DFS-2016, W3C-Community-Final-Specification-Agreement - coolercontrol-ui/node_modules/typescript/ThirdPartyNoticeText.txt
# CC-BY-3.0 - cargo_home/gentoo/crossbeam-channel-0.5.8/LICENSE-THIRD-PARTY
# HPND-Pbmplus - cargo_home/gentoo/imagequant-4.2.2/COPYRIGHT
# MPL-2.0 - cargo_home/gentoo/webpki-roots-0.25.3/LICENSE
# openssl, SSLeay - cargo_home/gentoo/ring-0.17.5/LICENSE
# Unicode-DFS-2016 - gentoo/regex-syntax-0.8.2/src/unicode_tables/LICENSE-UNICODE
# Unlicense - cargo_home/gentoo/memchr-2.6.4/UNLICENSE
LICENSE="
	${CARGO_PACKAGES_LICENSES}
	${NPM_PACKAGES_LICENSES}
	GPL-3+
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
${VIDEO_CARDS[@]}
hwmon liquidctl man openrc systemd
ebuild_revision_18
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	filecaps
"
# The sys-libs/libcap is an ebuild or init security requirement not upstream requirement.
# virtual/udev is an ebuild requirement but not upstream.
RDEPEND+="
	acct-group/coolercontrold:*
	acct-user/coolercontrold:*
	>=app-arch/zstd-${ZSTD_PV}:=
	dev-cpp/abseil-cpp:20220623=
	dev-libs/protobuf:=
	|| (
		dev-libs/protobuf:3/3.21
	)
	sys-kernel/secure-kernel:*
	>=sys-libs/libcap-${LIBCAP_PV}:=
	virtual/udev:*
	liquidctl? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			app-misc/liquidctl:=[${PYTHON_USEDEP}]
		')
	)
	hwmon? (
		>=sys-apps/lm-sensors-3.6.0:=
	)
	video_cards_amdgpu? (
		>=x11-libs/libdrm-${LIBDRM_PV}:=
	)
	video_cards_nvidia? (
		$(secure-version_gen_nvidia_drivers_depends '' '[tools]')
	)
"
DEPEND+="
	${RDEPEND}
	>=x11-libs/libdrm-${LIBDRM_PV}:=
"
# app-admin/sudo is an ebuild requirement but not upstream.
BDEPEND+="
	${VUE_BDEPEND}
	>=dev-build/make-4.3
	app-admin/sudo
	net-libs/nodejs:${NODE_SLOT}=[npm]
	virtual/pkgconfig
	|| (
		dev-lang/rust:${RUST_PV}[wasm]
		dev-lang/rust-bin:${RUST_PV}
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-4.2.1-symbolize-python.patch"
	"${FILESDIR}/${PN}-4.2.1-remove-root-check.patch"
)

# @FUNCTION: cargo_src_unpack
# @DESCRIPTION:
# Unpacks the package and the cargo registry.
# From cargo.eclass
_cargo_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	mkdir -p "${ECARGO_VENDOR}" || die
	mkdir -p "${S}" || die

	cp -aT \
		"${FILESDIR}/${PV}/" \
		"${S}" \
		|| die

	mkdir -p "${ECARGO_VENDOR}" "${S}" || die

	local archive shasum pkg
	local crates=()
	for archive in ${A}; do
		case "${archive}" in
			*.crate)
				crates+=( "${archive}" )
				;;
			*)
				einfo "pwd:  "$(pwd)
				if [[ "${archive}" == "coolercontrol-${PV}.tar.bz2" ]] ; then
					einfo "Skipping unpack for coolercontrol-${PV}.tar.bz2"
				else
					pushd "${WORKDIR}" || die
						unpack "${archive}"
					popd || die
				fi
				;;
		esac
	done

	if [[ ${PKGBUMPING} != ${PVR} && ${crates[@]} ]]; then
		pushd "${DISTDIR}" >/dev/null || die

		ebegin "Unpacking crates"
		printf '%s\0' "${crates[@]}" |
			xargs -0 -P "$(makeopts_jobs)" -n 1 -t -- \
				tar -x -C "${ECARGO_VENDOR}" -f
		assert
		eend $?

		while read -d '' -r shasum archive; do
			pkg=${archive%.crate}
			cat <<- EOF > ${ECARGO_VENDOR}/${pkg}/.cargo-checksum.json || die
			{
				"package": "${shasum}",
				"files": {}
			}
			EOF

			# if this is our target package we need it in ${WORKDIR} too
			# to make ${S} (and handle any revisions too)
			if [[ ${P} == ${pkg}* ]]; then
				tar -xf "${archive}" -C "${WORKDIR}" || die
			fi
		done < <(sha256sum -z "${crates[@]}" || die)

		popd >/dev/null || die
	fi

	cargo_gen_config
}

set_gui_port() {
	local L=(
		"coolercontrold/daemon/src/api/mod.rs"
	)
	local port=${COOLERCONTROL_GUI_PORT:-11987}
	local p
	for p in "${L[@]}" ; do
		sed -i -e "s|11987|${port}|g" "${p}" || die
	done
}

set_grpc_port() {
	local L=(
		"coolercontrold/daemon/src/api/mod.rs"
	)
	local port=${COOLERCONTROL_GRPC_PORT:-11988}
	local p
	for p in "${L[@]}" ; do
		sed -i -e "s|11988|${port}|g" "${p}" || die
	done
}

pkg_setup() {
ewarn "Do not emerge ${CATEGORY}/${PN} package directly.  Emerge the sys-apps/coolercontrol metapackage instead."
	python-single-r1_pkg_setup
	npm_pkg_setup
	rust_pkg_setup
	"${RUSTC}" --version || die
}

npm_update_lock_install_post() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		pushd "${S_ROOT}/coolercontrol-ui" >/dev/null 2>&1 || die
			sed -i -e "s|\"vitest\": \"^2.1.8\"|\"vitest\": \"^2.1.9\"|" "package.json" || die
			enpm install "vitest@2.1.9" -D ${NPM_INSTALL_ARGS[@]}						# CVE-2025-24964; DoS, DT, ID; Critical

			sed -i -e "s|\"esbuild\": \"^0.21.3\"|\"esbuild\": \"^0.25.0\"|g" "package-lock.json" || die	# Must follow vitest
			sed -i -e "s|\"esbuild\": \"^0.24.2\"|\"esbuild\": \"^0.25.0\"|g" "package-lock.json" || die	# Must follow vitest
			enpm install "esbuild@^0.25.0" -D

			enpm install "axios@^1.8.2" -P									# CVE-2025-27152; ID; High
		popd >/dev/null 2>&1 || die
	fi
}

src_unpack() {
	# For updating lockfile
	unpack "coolercontrol-${PV}.tar.bz2"
#	die

	S="${S_ROOT}/coolercontrol-ui" \
	npm_src_unpack
	S="${S_ROOT}/coolercontrold" \
	_cargo_src_unpack
}

src_configure() {
	cflags-hardened_append		# For *-sys crates
	rustflags-hardened_append
	abseil-cpp_src_configure
	protobuf_src_configure
	export PROTOC="/usr/lib/protobuf/${PROTOBUF_CPP_SLOT}/bin/protoc"
	"${PROTOC}" --version || die

	sed -i \
		-e "s|@EPYTHON@|${EPYTHON}|g" \
		"${S}/cc-detect/src/shell_command.rs" \
		"${S}/daemon/resources/liqctld/main.py" \
		"${S}/daemon/resources/liqctld/verify.py" \
		"${S}/daemon/src/repositories/liquidctl/liqctld_service.rs" \
		"${S}/resources/liqctld/main.py" \
		"${S}/resources/liqctld/verify.py" \
		|| die

	export ZSTD_SYS_USE_PKG_CONFIG=1

	S="${S_ROOT}/coolercontrold" \
	cargo_src_configure
	pushd "${S_ROOT}" || die
		set_gui_port
		set_grpc_port
	popd
}

src_compile() {
	npm_hydrate
	pushd "${S_ROOT}/coolercontrol-ui" || die
einfo "PWD: $(pwd)"
		S="${S_ROOT}/coolercontrol-ui" \
		enpm install ${NPM_INSTALL_ARGS[@]}
	# Audit fix already done with NPM_UPDATE_LOCK=1
		S="${S_ROOT}/coolercontrol-ui" \
		enpm run build
	popd
	cp -r \
		"${S_ROOT}/coolercontrol-ui/dist/"* \
		"resources/app/" \
		|| die
	S="${S_ROOT}/coolercontrold" \
	cargo_src_compile
}

src_install() {
	cargo_src_install --path daemon

	# Create directories with correct ownership
	keepdir "/etc/coolercontrol"
	keepdir "/var/lib/coolercontrol"

	if use openrc ; then
		exeinto "/etc/init.d"
		doexe "${FILESDIR}/coolercontrold"
	fi
	if use systemd ; then
		insinto "/lib/systemd/system"
		doins "${FILESDIR}/coolercontrold.service"
	fi
	if ! use openrc && ! use systemd ; then
ewarn
ewarn "You are responsible to creating the init service for ${PN} for your"
ewarn "init system."
ewarn
	fi

	insinto "/etc/udev/rules.d"
	doins "${FILESDIR}/99-coolercontrol.rules"

	LCNR_SOURCE="${WORKDIR}/cargo_home/gentoo"
	LCNR_TAG="third_party_cargo"
	lcnr_install_files

	LCNR_SOURCE="${S_ROOT}/coolercontrol-ui/node_modules"
	LCNR_TAG="third_party_npm"
	lcnr_install_files

	einstalldocs
	doman "${S_ROOT}/packaging/man/coolercontrold.8"
}

pkg_postinst() {
	local gui_port=${COOLERCONTROL_GUI_PORT:-11987}
	local grpc_port=${COOLERCONTROL_GRPC_PORT:-11988}
einfo
ewarn "The /etc/coolercontrol can be removed to reset the daemon settings."
einfo
einfo "GUI port:  ${gui_port}"
einfo "gRPC port:  ${grpc_port}"
einfo
einfo "Bookmark and access the GUI from the web browser:  http://localhost:${gui_port}"
einfo
einfo "Returning from a long vacation?"
einfo "To reset the password:  /usr/bin/coolercontrold --reset-password"
einfo

	fcaps_pkg_postinst

	# Set correct permissions
	chown -R "coolercontrold:coolercontrold" "${EROOT}/etc/coolercontrol" || true
	chown -R "coolercontrold:coolercontrold" "${EROOT}/var/lib/coolercontrol" || true

einfo "Reloading udev rules"
	sudo udevadm control --reload-rules
	sudo udevadm trigger

elog ""
elog "CoolerControlD is now running as the restricted 'coolercontrold' user (improved security)."
elog "If it is running now as root, kill/stop it now and restart it as a limited user."
elog ""
elog "Start commands:"
elog "  OpenRC   →  rc-service coolercontrold start"
elog "  systemd  →  systemctl enable --now coolercontrold"
elog ""

# Not necessary at this time
#elog "Add your user to the coolercontrold group for GUI access:"
#elog "    usermod -aG coolercontrold \$USER"
#elog ""
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  passed (0.17.2, 20231201)
# OILEDMACHINE-OVERLAY-TEST:  passed (2.2.1, 20250701)
# OILEDMACHINE-OVERLAY-TEST:  passed (2.2.2, 20250814)
# OILEDMACHINE-OVERLAY-TEST:  passed (3.0.1, 20251004)
# OILEDMACHINE-OVERLAY-TEST:  passed (4.2.1, 20260507) with limited user
# OpenRC - passed
# PWA (web browser GUI) - passed
# Systemd - untested
