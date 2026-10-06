# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"
MY_P="${PN/-/_}-${PV}"

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="maturin"
PYTHON_COMPAT=( "python3_"{10..14} "pypy3_11" )
RUST_MAX_VER="1.98.1"
RUST_MIN_VER="1.98.1" # LLVM 22.1
RUSTFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"

declare -A GIT_CRATES=(
)

DISABLED_CRATES="
git_xet-0.2.1
hf_xet-1.6.0
"

# From "./convert-cargo-lock.sh 1.6.0 1.6.0"
CRATES="
addr2line-0.25.1
adler2-2.0.1
aead-0.6.1
aes-0.9.3
aes-gcm-0.11.1
ahash-0.8.12
aho-corasick-1.1.5
aligned-vec-0.6.4
android_system_properties-0.1.6
anes-0.1.6
anstream-1.0.0
anstyle-1.0.14
anstyle-parse-1.0.0
anstyle-query-1.1.5
anstyle-wincon-3.0.11
anyhow-1.0.104
approx-0.5.1
argon2-0.6.0
arrayvec-0.7.8
assert-json-diff-2.0.2
async-channel-1.9.0
async-channel-2.5.0
async-executor-1.14.0
async-fs-2.2.0
async-global-executor-2.4.1
async-io-2.6.0
async-lock-3.4.2
async-net-2.0.0
async-object-pool-0.2.0
async-process-2.5.0
async-signal-0.2.14
async-std-1.13.2
async-task-4.7.1
async-trait-0.1.92
atomic-waker-1.1.2
autocfg-1.5.1
aws-lc-rs-1.18.1
aws-lc-sys-0.45.0
axum-0.8.9
axum-core-0.5.6
backtrace-0.3.76
bandwidth-0.3.0
base16ct-1.0.0
base64-0.22.1
base64-0.23.1
base64ct-1.8.3
bcrypt-pbkdf-0.11.0
bitflags-1.3.2
bitflags-2.13.2
blake2-0.11.0
blake3-1.8.7
block-buffer-0.10.4
block-buffer-0.12.1
blocking-1.7.0
block-padding-0.4.2
blowfish-0.10.0
bstr-1.13.1
bumpalo-3.20.3
bytemuck-1.25.2
byteorder-1.5.0
bytes-1.12.1
cast-0.3.0
cbc-0.2.1
cc-1.6.0
cfg_aliases-0.2.2
cfg-if-1.0.5
chacha20-0.10.2
chrono-0.4.45
ciborium-0.2.2
ciborium-io-0.2.2
ciborium-ll-0.2.2
cipher-0.5.2
clap-4.6.7
clap_builder-4.6.7
clap_derive-4.6.7
clap_lex-1.1.1
cmake-0.1.58
cmov-0.5.4
cobs-0.3.0
colorchoice-1.0.5
colored-3.1.1
combine-4.6.8
concurrent-queue-2.5.0
console-api-0.9.0
console-subscriber-0.5.0
constant_time_eq-0.4.2
const-oid-0.10.2
const_panic-0.2.17
const-str-1.1.0
core-foundation-0.10.1
core-foundation-0.9.4
core-foundation-sys-0.8.7
countio-0.3.0
cpp_demangle-0.4.5
cpubits-0.1.1
cpufeatures-0.2.17
cpufeatures-0.3.1
crc32fast-1.5.2
criterion-0.7.0
criterion-plot-0.6.0
crossbeam-channel-0.5.17
crossbeam-deque-0.8.8
crossbeam-epoch-0.9.21
crossbeam-utils-0.8.23
crunchy-0.2.4
crypto-bigint-0.7.5
crypto-common-0.1.7
crypto-common-0.2.2
crypto-primes-0.7.2
csv-1.4.0
csv-core-0.1.13
ctor-1.0.13
ctr-0.10.1
ctutils-0.4.3
curve25519-dalek-5.0.0
curve25519-dalek-derive-0.1.1
data-encoding-2.11.1
deadpool-0.12.3
deadpool-runtime-0.1.4
debugid-0.8.0
delegate-0.13.5
der-0.8.2
deranged-0.5.8
des-0.9.0
digest-0.10.7
digest-0.11.3
dirs-6.0.0
dirs-sys-0.5.0
displaydoc-0.2.7
downcast-0.11.0
dunce-1.0.5
ecdsa-0.17.0
ed25519-3.0.0
ed25519-dalek-3.0.0
either-1.18.0
elliptic-curve-0.14.1
embedded-io-0.4.0
embedded-io-0.6.1
enum_dispatch-0.3.13
equator-0.4.2
equator-macro-0.4.2
equivalent-1.0.2
errno-0.3.14
event-listener-2.5.3
event-listener-5.4.2
event-listener-strategy-0.5.4
fastrand-2.5.0
ff-0.14.0
fiat-crypto-0.3.0
find-msvc-tools-0.1.14
findshlibs-0.10.2
flate2-1.1.10
fnv-1.0.7
foreign-types-0.3.2
foreign-types-shared-0.1.1
form_urlencoded-1.2.2
fragile-2.1.0
fs_extra-1.3.0
futures-0.3.34
futures-channel-0.3.34
futures-core-0.3.34
futures-executor-0.3.34
futures-io-0.3.34
futures-lite-2.6.1
futures-macro-0.3.34
futures-sink-0.3.34
futures-task-0.3.34
futures-timer-3.0.4
futures-util-0.3.34
gearhash-0.1.4
generic-array-0.14.7
generic-array-1.4.5
getrandom-0.2.17
getrandom-0.3.4
getrandom-0.4.3
ghash-0.6.0
gimli-0.32.3
git2-0.21.0
git-url-parse-0.4.6
git-version-0.3.9
git-version-macro-0.3.9
gloo-timers-0.3.0
group-0.14.0
h2-0.4.19
half-2.7.1
hashbrown-0.17.1
hdrhistogram-7.6.0
headers-0.4.2
headers-core-0.3.0
heapify-0.2.0
heck-0.5.0
hermit-abi-0.5.3
hex-0.4.3
hex-literal-1.1.0
hf-xet-1.6.0
hkdf-0.13.0
hmac-0.13.0
home-0.5.12
http-1.5.0
httparse-1.10.1
http-body-1.1.0
http-body-util-0.1.5
httpdate-1.0.3
httpmock-0.8.3
human-bandwidth-0.1.4
humantime-2.4.0
hybrid-array-0.4.15
hyper-1.11.1
hyper-rustls-0.27.10
hyper-timeout-0.5.2
hyper-tls-0.6.0
hyper-util-0.1.21
iana-time-zone-0.1.65
iana-time-zone-haiku-0.1.2
icu_collections-2.3.0
icu_locale_core-2.3.0
icu_normalizer-2.3.0
icu_normalizer_data-2.3.0
icu_properties-2.3.0
icu_properties_data-2.3.0
icu_provider-2.3.1
idna-1.1.0
idna_adapter-1.2.2
indexmap-2.14.2
inferno-0.11.21
inout-0.2.2
inventory-0.3.24
ipnet-2.12.2
is-terminal-0.4.17
is_terminal_polyfill-1.70.2
itertools-0.12.1
itertools-0.13.0
itertools-0.14.0
itoa-1.0.18
jni-0.22.4
jni-macros-0.22.4
jni-sys-0.4.1
jni-sys-macros-0.4.1
jobserver-0.1.35
js-sys-0.3.106
keccak-0.2.2
kem-0.3.0
konst-0.4.3
konst_proc_macros-0.4.1
kv-log-macro-1.0.7
lazy_static-1.5.1
libc-0.2.190
libgit2-sys-0.18.8+1.9.7
libm-0.2.16
libredox-0.1.25
libz-sys-1.1.29
link-section-0.19.3
linktime-proc-macro-0.2.3
linux-raw-sys-0.12.1
linux-raw-sys-0.4.15
litemap-0.8.3
lock_api-0.4.14
log-0.4.34
lru-slab-0.1.3
lz4_flex-0.13.1
matchers-0.2.0
matchit-0.8.4
md5-0.8.1
memchr-2.8.3
memmap2-0.9.11
mime-0.3.17
miniz_oxide-0.8.9
miniz_oxide-0.9.1
mio-1.2.4
ml-kem-0.3.2
mockall-0.14.0
mockall_derive-0.14.0
module-lattice-0.2.3
more-asserts-0.3.1
native-tls-0.2.18
nix-0.26.4
nix-0.31.3
nom-8.0.0
ntapi-0.4.3
nu-ansi-term-0.50.3
num-bigint-0.5.1
num-conv-0.2.2
num_cpus-1.17.0
num-format-0.4.4
num-integer-0.1.47
num-traits-0.2.19
objc2-core-foundation-0.3.2
objc2-io-kit-0.3.2
objc2-system-configuration-0.3.2
object-0.37.3
once_cell-1.21.4
once_cell_polyfill-1.70.2
oneshot-0.1.13
oorandom-11.1.5
openssl-0.10.81
openssl-macros-0.1.1
openssl-probe-0.2.1
openssl-src-300.6.1+3.6.3
openssl-sys-0.9.117
option-ext-0.2.0
os_str_bytes-6.6.1
p256-0.14.0
p384-0.14.0
p521-0.14.0
pageant-0.2.4
parking-2.2.1
parking_lot-0.12.5
parking_lot_core-0.9.12
password-hash-0.6.1
path-tree-0.8.3
pbkdf2-0.13.0
pem-rfc7468-1.0.0
percent-encoding-2.3.2
phc-0.6.1
pin-project-1.1.13
pin-project-internal-1.1.13
pin-project-lite-0.2.17
pin-utils-0.1.1
piper-0.2.5
pkcs1-0.8.0-rc.4
pkcs5-0.8.1
pkcs8-0.11.0
pkg-config-0.3.34
plotters-0.3.7
plotters-backend-0.3.7
plotters-svg-0.3.7
polling-3.11.0
poly1305-0.9.1
polyval-0.7.3
portable-atomic-1.15.0
postcard-1.1.3
potential_utf-0.1.6
powerfmt-0.2.1
pprof-0.15.0
predicates-3.1.4
predicates-core-1.0.10
predicates-tree-1.0.13
primefield-0.14.0
primeorder-0.14.0
proc-macro2-1.0.107
prost-0.12.6
prost-0.14.4
prost-derive-0.12.6
prost-derive-0.14.4
prost-types-0.14.4
protobuf-3.7.2
protobuf-codegen-3.7.2
protobuf-parse-3.7.2
protobuf-support-3.7.2
pyo3-0.29.3
pyo3-build-config-0.29.3
pyo3-ffi-0.29.3
pyo3-macros-0.29.3
pyo3-macros-backend-0.29.3
quick-xml-0.26.0
quinn-0.11.12
quinn-proto-0.11.19
quinn-udp-0.5.16
quote-1.0.47
rand-0.10.3
rand_core-0.10.1
rand_distr-0.6.0
rand_pcg-0.10.2
rayon-1.12.0
rayon-core-1.13.0
redb-3.1.3
redox_syscall-0.5.18
redox_users-0.5.3
r-efi-5.3.0
r-efi-6.0.0
regex-1.13.1
regex-automata-0.4.18
regex-syntax-0.8.11
reqwest-0.13.5
reqwest-middleware-0.5.2
rfc6979-0.6.0
rgb-0.8.53
ring-0.17.14
rsa-0.10.0-rc.18
russh-0.63.3
russh-cryptovec-0.62.0
russh-util-0.52.0
rustc-demangle-0.1.28
rustc-hash-2.1.3
rustc_version-0.4.1
rustix-0.38.44
rustix-1.1.5
rustls-0.23.45
rustls-native-certs-0.8.4
rustls-pki-types-1.15.1
rustls-platform-verifier-0.7.1
rustls-platform-verifier-android-0.2.0
rustls-webpki-0.103.15
rust-netrc-0.1.2
rustversion-1.0.23
ryu-1.0.23
safe-transmute-0.11.3
salsa20-0.11.0
same-file-1.0.6
schannel-0.1.29
scopeguard-1.2.0
scrypt-0.12.0
sec1-0.8.1
security-framework-3.7.0
security-framework-sys-2.17.0
semver-1.0.28
serde-1.0.229
serde_core-1.0.229
serdect-0.4.3
serde_derive-1.0.229
serde_json-1.0.151
serde_path_to_error-0.1.20
serde_regex-1.2.0
serde_repr-0.1.21
serde_urlencoded-0.7.1
serial_test-3.5.0
serial_test_derive-3.5.0
sha1-0.10.7
sha1-0.11.0
sha2-0.11.0
sha3-0.11.0
sha3-0.12.0
sharded-slab-0.1.7
shellexpand-3.1.2
shell-words-1.1.1
shlex-2.0.1
signal-hook-0.3.18
signal-hook-registry-1.4.8
signature-3.0.0
simd-adler32-0.3.10
simd_cesu8-1.2.0
simdutf8-0.1.5
similar-2.7.0
slab-0.4.12
smallvec-1.16.2
smol-2.0.2
socket2-0.6.5
spin-0.10.1
spki-0.8.1
sponge-cursor-0.1.0
ssh-cipher-0.3.0
ssh-encoding-0.3.0
ssh-key-0.7.0-rc.11
stable_deref_trait-1.2.1
static_assertions-1.1.0
statrs-0.18.0
stringmetrics-2.2.2
strsim-0.11.1
str_stack-0.1.1
strum-0.27.2
strum_macros-0.27.2
subtle-2.6.1
symbolic-common-12.18.3
symbolic-demangle-12.18.3
symlink-0.1.0
syn-2.0.119
syn-3.0.6
sync_wrapper-1.0.2
synstructure-0.14.0
sysinfo-0.38.4
system-configuration-0.7.0
system-configuration-sys-0.6.0
tabwriter-1.4.1
target-lexicon-0.13.5
tempfile-3.27.0
termtree-0.5.1
thiserror-1.0.69
thiserror-2.0.21
thiserror-impl-1.0.69
thiserror-impl-2.0.21
thread_local-1.1.10
time-0.3.55
time-core-0.1.9
time-macros-0.2.32
tinystr-0.8.4
tinytemplate-1.2.1
tinyvec-1.13.3
tokio-1.53.2
tokio-macros-2.7.2
tokio-native-tls-0.3.1
tokio-retry-0.3.2
tokio-rustls-0.26.6
tokio-stream-0.1.19
tokio-util-0.7.19
tokio_with_wasm-0.8.8
tokio_with_wasm_proc-0.8.8
tonic-0.14.6
tonic-prost-0.14.6
tower-0.5.3
tower-http-0.6.11
tower-layer-0.3.3
tower-service-0.3.3
tracing-0.1.44
tracing-appender-0.2.5
tracing-attributes-0.1.31
tracing-core-0.1.36
tracing-log-0.2.0
tracing-serde-0.2.0
tracing-subscriber-0.3.23
tracing-test-0.2.6
tracing-test-macro-0.2.6
try-lock-0.2.5
twox-hash-2.1.5
typenum-1.20.1
typewit-1.15.2
unicode-ident-1.0.26
unicode-width-0.2.2
universal-hash-0.6.1
untrusted-0.7.1
untrusted-0.9.0
url-2.5.8
urlencoding-2.1.3
utf8_iter-1.0.4
utf8parse-0.2.2
uuid-1.27.0
valuable-0.1.1
value-bag-1.14.1
vcpkg-0.2.15
version_check-0.9.5
walkdir-2.5.0
want-0.3.2
wasi-0.11.1+wasi-snapshot-preview1
wasi-0.14.7+wasi-0.2.4
wasip2-1.0.4+wasi-0.2.12
wasite-1.0.2
wasm-bindgen-0.2.129
wasm-bindgen-futures-0.4.79
wasm-bindgen-macro-0.2.129
wasm-bindgen-macro-support-0.2.129
wasm-bindgen-shared-0.2.129
wasm-streams-0.5.0
webpki-root-certs-1.0.9
web-sys-0.3.106
web-time-1.1.0
which-4.4.2
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
windows-registry-0.6.1
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
wiremock-0.6.5
wit-bindgen-0.57.1
wnaf-0.14.1
writeable-0.6.4
xet-client-1.6.0
xet-core-structures-1.6.0
xet-data-1.6.0
xet-runtime-1.6.0
yoke-0.8.3
yoke-derive-0.8.4
zerocopy-0.8.60
zerocopy-derive-0.8.60
zerofrom-0.1.8
zerofrom-derive-0.1.8
zeroize-1.9.0
zerotrie-0.2.5
zerovec-0.11.8
zerovec-derive-0.11.6
zlib-rs-0.6.8
zmij-1.0.23
"

inherit cargo distutils-r1 lcnr rustflags-hardened

SRC_URI+="
$(cargo_crate_uris ${CRATES})
https://github.com/huggingface/xet-core/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz
"

KEYWORDS="~amd64"
S="${WORKDIR}/xet-core-${PV}" # Pick the one with the git_xet

DESCRIPTION="Fast transfer of large files with the Hugging Face Hub"
HOMEPAGE="
	https://github.com/huggingface/xet-core/tree/main/hf_xet
	https://pypi.org/project/hf-xet
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0"
# Upstream enables lto by default
IUSE+="
lto test
ebuild_revision_8
"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-util/maturin-1.7[${PYTHON_USEDEP}]
	<dev-util/maturin-2.0[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	unpack ${P}.gh.tar.gz
	#die
	cargo_src_unpack
	cp -aT \
		"${FILESDIR}/${PV}"* \
		"${S}" \
		|| die
}

src_prepare() {
	default
	cd "${WORKDIR}" || die
	eapply "${FILESDIR}/aws-lc-sys-0.45.0-append-O0.patch"
}

src_configure() {
	export CARGO_TERM_VERBOSE="true"
	rustflags-hardened_append

	S="${WORKDIR}/xet-core-${PV}" \
	cargo_src_configure
	local lto=$(usex lto "true" "false")
	sed -i \
		-e "s|lto = true|lto = ${lto}|g" \
		"hf_xet/Cargo.toml" \
		"Cargo.toml" \
		|| die
}

python_compile() {
	export PYTHON_SYS_EXECUTABLE="${PYTHON}"
	local pypv="${EPYTHON}"
	pypv="${pypv/./}"
	pypv="${pypv/python/}"
	sed -i \
		-r -e "s|abi3-py[0-9]+|abi3-py${pypv}|g" \
		"${S}/xet_data/Cargo.toml" \
		"${S}/hf_xet/Cargo.toml" \
		"${S}/Cargo.toml" \
		|| die

	cd "${WORKDIR}/xet-core-${PV}/hf_xet" || die

	export BUILD_DIR="${WORKDIR}/xet-core-${PV}/hf_xet"
	distutils-r1_python_compile

	local wheel_path=$(realpath "${WORKDIR}/xet-core-${PV}/hf_xet/target/wheels/hf_xet-${PV}-cp${pypv}-abi3-linux_"*".whl")
	einfo "wheel_path=${wheel_path}"
	local d="${WORKDIR}/xet-core-${PV}-${EPYTHON/./_}/install"
	distutils_wheel_install "${d}" \
		"${wheel_path}"

	# Unbreak die check
	mkdir -p "${d}/usr/bin"
	touch "${d}/usr/bin/"{"${EPYTHON}","python3","python","pyvenv.cfg"}
	mv "${d}/usr/bin/pyvenv.cfg" "${d}/usr/bin/../pyvenv.cfg" || die
}

python_install() {
	distutils-r1_python_install
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"

	LCNR_SOURCE="${WORKDIR}/cargo_home/gentoo"
	LCNR_TAG="third_party"
        lcnr_install_files
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
