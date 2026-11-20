# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild contains AI generated code and AI generated artifact (e.g. RiceConfig.cmake) that contains AI generated code.

# U24

inherit secure-version

CFLAGS_HARDENED_USE_CASES="multithreaded-confidential security-critical network untrusted-data p2p"
RUST_MAX_VER="${RUST_LLVM_22_PV}"
RUST_MIN_VER="${RUST_LLVM_22_PV}"
RUSTFLAGS_HARDENED_USE_CASES="multithreaded-confidential security-critical network untrusted-data p2p"

CRATES_DISABLED="
rice-fuzz-0.4.3
"

CRATES="
aho-corasick-1.1.5
anes-0.1.6
anstream-1.0.0
anstyle-1.0.14
anstyle-parse-1.0.0
anstyle-query-1.1.5
anstyle-wincon-3.0.11
arbitrary-1.5.0
arrayvec-0.7.8
asn1-rs-0.7.2
asn1-rs-derive-0.6.0
asn1-rs-impl-0.2.0
async-channel-2.5.0
async-executor-1.14.1
async-fs-2.2.0
async-io-2.6.0
async-lock-3.5.0
async-net-2.0.0
async-process-2.5.0
async-signal-0.2.14
async-task-4.7.1
atomic-waker-1.1.2
autocfg-1.5.1
aws-lc-rs-1.19.0
aws-lc-sys-0.47.0
base16ct-0.2.0
base64-0.22.1
base64ct-1.8.3
bindgen-0.72.1
bitflags-2.13.2
bit-vec-0.9.1
block-buffer-0.12.1
blocking-1.7.0
bumpalo-3.20.4
byteorder-1.5.0
bytes-1.12.2
cast-0.3.0
cc-1.11.3
cexpr-0.6.0
cfg-expr-0.20.11
cfg-if-1.0.5
chacha20-0.10.2
ciborium-0.2.2
ciborium-io-0.2.2
ciborium-ll-0.2.2
clang-sys-1.9.1
clap-4.6.9
clap_builder-4.6.7
clap_derive-4.6.9
clap_lex-1.1.2
cmake-0.1.58
cmov-0.5.4
colorchoice-1.0.5
combine-4.6.9
concurrent-queue-2.5.0
const-oid-0.9.6
core-foundation-0.10.1
core-foundation-sys-0.8.7
cpufeatures-0.3.1
crc-3.4.0
crc-catalog-2.5.0
criterion-0.6.0
criterion-plot-0.5.0
crossbeam-deque-0.8.8
crossbeam-epoch-0.9.21
crossbeam-utils-0.8.23
crunchy-0.2.4
crypto-common-0.2.2
ctutils-0.4.8
data-encoding-2.11.1
der-0.7.10
deranged-0.5.9
der_derive-0.7.3
derive_arbitrary-1.5.0
der-parser-10.0.0
digest-0.11.3
dimpl-0.4.3
displaydoc-0.2.7
dunce-1.0.5
either-1.19.0
equivalent-1.0.3
errno-0.3.15
event-listener-5.4.2
event-listener-strategy-0.5.4
fastrand-2.5.0
find-msvc-tools-0.1.15
flagset-0.4.7
flume-0.12.0
foreign-types-0.3.2
foreign-types-shared-0.1.1
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
generic-array-0.14.9
getrandom-0.2.17
getrandom-0.3.4
getrandom-0.4.3
glob-0.3.4
half-2.7.1
hashbrown-0.16.1
hashbrown-0.17.1
heck-0.5.0
hermit-abi-0.5.3
hmac-0.13.0
hybrid-array-0.4.15
if-addrs-0.15.0
indexmap-2.14.2
is_terminal_polyfill-1.70.2
itertools-0.10.5
itertools-0.13.0
itoa-1.0.19
jni-0.22.4
jni-macros-0.22.4
jni-sys-0.4.1
jni-sys-macros-0.4.1
jobserver-0.1.35
js-sys-0.3.107
lazy_static-1.5.1
libc-0.2.191
libfuzzer-sys-0.4.13
libloading-0.8.9
librice-0.4.3
linux-raw-sys-0.12.1
lock_api-0.4.14
log-0.4.35
matchers-0.2.0
md-5-0.11.0
memchr-2.8.3
minimal-lexical-0.2.1
mio-1.2.5
nom-7.1.3
nom-8.0.0
no-std-net-0.6.0
nu-ansi-term-0.50.3
num-bigint-0.4.8
num-conv-0.2.2
num-integer-0.1.47
num-traits-0.2.19
oid-registry-0.8.1
once_cell-1.21.4
once_cell_polyfill-1.70.2
oorandom-11.1.5
openssl-0.10.82
openssl-macros-0.1.1
openssl-probe-0.2.2
openssl-sys-0.9.118
parking-2.2.1
pem-rfc7468-0.7.0
pin-project-1.2.0
pin-project-internal-1.2.0
pin-project-lite-0.2.18
piper-0.2.5
pkcs8-0.10.2
pkg-config-0.3.34
plotters-0.3.7
plotters-backend-0.3.7
plotters-svg-0.3.7
pnet_base-0.35.0
pnet_macros-0.35.0
pnet_macros_support-0.35.0
pnet_packet-0.35.0
polling-3.11.0
powerfmt-0.2.1
ppv-lite86-0.2.21
prettyplease-0.2.37
proc-macro2-1.0.107
quote-1.0.47
rand-0.10.4
rand-0.9.5
rand_chacha-0.9.0
rand_core-0.10.1
rand_core-0.9.5
rayon-1.12.0
rayon-core-1.13.0
rcgen-0.14.10
r-efi-5.3.0
r-efi-6.0.0
regex-1.13.2
regex-automata-0.4.19
regex-syntax-0.8.12
rice-c-0.4.3
rice-ctypes-0.4.3
rice-io-0.4.3
rice-proto-0.4.3
rice-stun-types-0.4.3
ring-0.17.14
rustc-hash-2.1.3
rustc_version-0.4.1
rusticata-macros-4.1.0
rustix-1.1.6
rustls-0.23.46
rustls-native-certs-0.8.5
rustls-pki-types-1.16.0
rustls-platform-verifier-0.7.1
rustls-platform-verifier-android-0.2.0
rustls-webpki-0.103.17
rustversion-1.0.23
same-file-1.0.6
sans-io-time-0.2.0
schannel-0.1.30
scopeguard-1.2.0
sec1-0.7.3
security-framework-3.7.0
security-framework-sys-2.17.0
semver-1.0.28
serde-1.0.229
serde_core-1.0.229
serde_derive-1.0.229
serde_json-1.0.154
serde_spanned-1.1.3
sha1-0.11.0
sha2-0.11.1
sharded-slab-0.1.7
shlex-1.3.0
shlex-2.0.1
signal-hook-registry-1.4.8
signature-2.2.0
simd_cesu8-1.2.0
simdutf8-0.1.5
siphasher-1.0.4
slab-0.4.12
smallvec-1.16.6
smol-2.0.2
socket2-0.6.5
spin-0.9.9
spki-0.7.3
strsim-0.11.1
stun-proto-2.0.5
stun-types-2.0.5
subtle-2.6.1
syn-2.0.119
syn-3.0.10
synstructure-0.13.2
system-deps-7.0.8
target-lexicon-0.13.5
thiserror-2.0.21
thiserror-impl-2.0.21
thread_local-1.1.10
time-0.3.55
time-core-0.1.9
time-macros-0.2.32
tinytemplate-1.2.1
tokio-1.54.1
toml-1.2.1+spec-1.1.0
toml_datetime-1.1.3+spec-1.1.0
toml_parser-1.1.5+spec-1.1.0
toml_writer-1.2.0+spec-1.1.0
tracing-0.1.44
tracing-attributes-0.1.31
tracing-core-0.1.36
tracing-futures-0.2.5
tracing-log-0.2.0
tracing-subscriber-0.3.23
turn-client-dimpl-0.1.0
turn-client-openssl-0.1.2
turn-client-proto-0.7.3
turn-client-rustls-0.1.2
turn-server-proto-0.7.3
turn-types-0.7.3
typenum-1.20.1
unicode-ident-1.0.27
untrusted-0.7.1
untrusted-0.9.0
utf8parse-0.2.2
valuable-0.1.1
vcpkg-0.2.15
version_check-0.9.5
version-compare-0.2.1
walkdir-2.5.0
wasi-0.11.1+wasi-snapshot-preview1
wasip2-1.0.4+wasi-0.2.12
wasm-bindgen-0.2.130
wasm-bindgen-macro-0.2.130
wasm-bindgen-macro-support-0.2.130
wasm-bindgen-shared-0.2.130
webpki-root-certs-1.0.12
web-sys-0.3.107
winapi-util-0.1.11
windows_aarch64_gnullvm-0.52.6
windows_aarch64_msvc-0.52.6
windows_i686_gnu-0.52.6
windows_i686_gnullvm-0.52.6
windows_i686_msvc-0.52.6
windows-link-0.2.1
windows-sys-0.52.0
windows-sys-0.61.2
windows-targets-0.52.6
windows_x86_64_gnu-0.52.6
windows_x86_64_gnullvm-0.52.6
windows_x86_64_msvc-0.52.6
winnow-1.0.5
wit-bindgen-0.57.1
x509-cert-0.2.5
x509-parser-0.18.1
yasna-0.6.0
zerocopy-0.8.63
zerocopy-derive-0.8.63
zeroize-1.9.2
zmij-1.0.23
"
declare -A GIT_CRATES=()

inherit cargo cflags-hardened edo flag-o-matic-om lcnr meson-multilib rustflags-hardened xdg

DESCRIPTION="sans-IO implementation of ICE (RFC8445) in Rust"
HOMEPAGE="https://github.com/ystreet/librice"
SRC_URI="
$(cargo_crate_uris)
https://github.com/ystreet/librice/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="
	(
		Apache-2.0
		BSD
		CC0-1.0
		ISC
		MIT
		|| (
			Apache-2.0
			ISC
		)
		|| (
			Apache-2.0
			ISC
			MIT
		)
		|| (
			Apache-2.0
			ISC
			MIT-0
		)
	)
	(
		ISC
		|| (
			Apache-2.0
			ISC
		)
	)
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	APSL-2
	BSD
	CC0-1.0
	CDLA-Permissive-2.0
	ISC
	MIT
	Unicode-3.0
	Unicode-DFS-2016
	Unlicense
"
# Third party licenses:
# Apache-2.0 - ./librice-0.4.1/LICENSE-APACHE
# Apache-2.0-with-LLVM-exceptions - ./cargo_home/gentoo/target-lexicon-0.13.3/LICENSE
# APSL-2 - ./cargo_home/gentoo/security-framework-3.7.0/THIRD_PARTY
# BSD - ./cargo_home/gentoo/if-addrs-0.15.0/LICENSE-BSD
# CC0-1.0 - ./cargo_home/gentoo/dunce-1.0.5/LICENSE
# CDLA-Permissive-2.0 - ./cargo_home/gentoo/webpki-root-certs-1.0.6/LICENSE
# ISC || ( Apache-2.0 ISC) - ./cargo_home/gentoo/aws-lc-rs-1.16.2/LICENSE
# ISC - ./cargo_home/gentoo/untrusted-0.9.0/LICENSE.txt
# MIT - ./librice-0.4.1/LICENSE-MIT
# Unicode-3.0 - ./cargo_home/gentoo/unicode-ident-1.0.24/LICENSE-UNICODE
# Unicode-DFS-2016 - ./cargo_home/gentoo/regex-syntax-0.8.10/src/unicode_tables/LICENSE-UNICODE
# Unlicense - ./cargo_home/gentoo/memchr-2.8.0/UNLICENSE
# || ( Apache-2.0 ISC ) || ( Apache-2.0 ISC MIT ) || ( Apache-2.0 ISC MIT-0 ) Apache-2.0 BSD CC0-1.0 ISC MIT - ./cargo_home/gentoo/aws-lc-sys-0.39.1/aws-lc/LICENSE
SLOT="0"
KEYWORDS="~amd64"
IUSE="
debug
ebuild_revision_7
"
RESTRICT="mirror"
RDEPEND="
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/cargo-c
"

PATCHES=(
)

pkg_setup() {
	rust_pkg_setup
}

src_unpack() {
	unpack ${A}
#	die

	cargo_src_unpack
	if [[ -e "${FILESDIR}/${PV}/Cargo.lock" ]] ; then
		cp -vaT "${FILESDIR}/${PV}" "${S}" || die
	fi
}

src_configure() {
	fix_mb_len_max			# For Clang built aws-lc-sys
	cflags-hardened_append		# For aws-lc-sys, *-sys crates
	rustflags-hardened_append
}

src_compile() {
	cargo_src_compile
	local configuration=$(usex debug "" "--release")
	edo "${CARGO}" cbuild \
		${configuration} \
		--manifest-path "rice-proto/Cargo.toml" \
		--features "capi" \
		|| die
	edo "${CARGO}" cbuild \
		${configuration} \
		--manifest-path "rice-io/Cargo.toml" \
		--features "capi" \
		|| die
}

src_install() {
	local configuration=$(usex debug "" "--release")
	edo "${CARGO}" cinstall \
		${configuration} \
		--features "capi" \
		--manifest-path "rice-proto/Cargo.toml" \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--destdir="${D}" \
		|| die
	edo "${CARGO}" cinstall \
		${configuration} \
		--features "capi" \
		--manifest-path "rice-io/Cargo.toml" \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--destdir="${D}" \
		|| die

	# === CMake compatibility layer for WebKitGTK 2.52.1 ===
	# Substitute version numbers
	local RICE_VERSION="${PV}"
	local RICE_VERSION_MAJOR=$(ver_cut 1 "${PV}")
	local RICE_VERSION_MINOR=$(ver_cut 2 "${PV}")
	local RICE_VERSION_PATCH=$(ver_cut 3 "${PV}")

	sed \
		-e "s/@RICE_VERSION@/${RICE_VERSION}/g" \
		-e "s/@RICE_VERSION_MAJOR@/${RICE_VERSION_MAJOR}/g" \
		-e "s/@RICE_VERSION_MINOR@/${RICE_VERSION_MINOR}/g" \
		-e "s/@RICE_VERSION_PATCH@/${RICE_VERSION_PATCH}/g" \
		"${FILESDIR}/RiceConfig.cmake" \
			> \
		"${T}/RiceConfig.cmake" \
		|| die

	insinto "/usr/$(get_libdir)/cmake/Rice"
	doins "${T}/RiceConfig.cmake"

	# Copy all the Licenses, Copyright Notices, Readmes
        LCNR_SOURCE="${WORKDIR}/cargo_home/gentoo"
        LCNR_TAG="third_party"
	lcnr_install_files

        LCNR_SOURCE="${S}"
        LCNR_TAG="${PN}"
	lcnr_install_files
}
