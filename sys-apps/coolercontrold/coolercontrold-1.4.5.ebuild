# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 22.04

# NPM_AUDIT_FIX=0
NPM_INSTALL_ARGS=(
	"--prefer-offline"
)

# To update npm side use:
# PATH="/usr/local/oiledmachine-overlay/scripts:${PATH}"
# NPM_UPDATER_PROJECT_ROOT="coolercontrol-1.4.5/coolercontrol-ui" NPM_UPDATER_VERSIONS="1.4.5" npm_updater_update_locks.sh

# To update cargo size use:
# ./convert-cargo-lock.sh 1.4.5 1.4.5

declare -A GIT_CRATES=(
[nvml-wrapper-sys]="https://github.com/codifryed/nvml-wrapper;c8dd9b97a872f6252a48c61dfc6e1c0b61eab39b;plugins-workspace-%commit%/nvml-wrapper-sys" # 0.8.0
[nvml-wrapper]="https://github.com/codifryed/nvml-wrapper;c8dd9b97a872f6252a48c61dfc6e1c0b61eab39b;plugins-workspace-%commit%/nvml-wrapper" # 0.10.0
)

CRATES="
actix-codec-0.5.2
actix-cors-0.7.0
actix-http-3.9.0
actix-macros-0.2.4
actix-multipart-0.7.2
actix-multipart-derive-0.7.0
actix-router-0.5.3
actix-rt-2.10.0
actix-server-2.5.0
actix-service-2.0.2
actix-session-0.10.1
actix-utils-3.0.1
actix-web-4.9.0
actix-web-codegen-4.3.0
actix-web-static-files-4.0.1
addr2line-0.24.2
adler2-2.0.0
aead-0.5.2
aes-0.8.4
aes-gcm-0.10.3
ahash-0.8.11
aho-corasick-1.1.3
aligned-vec-0.5.0
alloc-no-stdlib-2.0.4
alloc-stdlib-0.2.2
allocator-api2-0.2.21
android-tzdata-0.1.1
android_system_properties-0.1.5
anstream-0.6.18
anstyle-1.0.10
anstyle-parse-0.2.6
anstyle-query-1.1.2
anstyle-wincon-3.0.7
anyhow-1.0.95
arbitrary-1.4.1
arg_enum_proc_macro-0.3.4
arrayref-0.3.9
arrayvec-0.7.6
async-broadcast-0.7.2
async-recursion-1.1.1
async-trait-0.1.85
atomic-0.6.0
autocfg-1.4.0
av1-grain-0.2.3
avif-serialize-0.8.2
backtrace-0.3.74
base64-0.20.0
base64-0.22.1
bitflags-1.3.2
bitflags-2.8.0
bitstream-io-2.6.0
block-buffer-0.10.4
brotli-6.0.0
brotli-decompressor-4.0.1
built-0.7.5
bumpalo-3.16.0
bytemuck-1.21.0
bytemuck_derive-1.8.1
byteorder-1.5.0
byteorder-lite-0.1.0
bytes-1.9.0
bytestring-1.4.0
cached-0.54.0
cached_proc_macro-0.23.0
cached_proc_macro_types-0.1.1
cc-1.2.10
cfg-expr-0.15.8
cfg-if-1.0.0
cfg_aliases-0.2.1
chrono-0.4.39
cipher-0.4.4
clap-4.5.26
clap_builder-4.5.26
clap_derive-4.5.24
clap_lex-0.7.4
color_quant-1.1.0
colorchoice-1.0.3
concurrent-queue-2.5.0
const_format-0.2.34
const_format_proc_macros-0.2.34
convert_case-0.4.0
cookie-0.16.2
core-foundation-sys-0.8.7
cpufeatures-0.2.16
crc32fast-1.4.2
crossbeam-channel-0.5.14
crossbeam-deque-0.8.6
crossbeam-epoch-0.9.18
crossbeam-utils-0.8.21
crypto-common-0.1.6
ctr-0.9.2
darling-0.20.10
darling_core-0.20.10
darling_macro-0.20.10
deranged-0.3.11
derive_more-0.99.18
derive_more-1.0.0
derive_more-impl-1.0.0
digest-0.10.7
displaydoc-0.2.5
either-1.13.0
encoding_rs-0.8.35
endi-1.1.0
enumflags2-0.7.11
enumflags2_derive-0.7.11
env_filter-0.1.3
env_logger-0.11.6
equivalent-1.0.1
errno-0.3.10
event-listener-5.4.0
event-listener-strategy-0.5.3
fastrand-2.3.0
fdeflate-0.3.7
flate2-1.0.35
fnv-1.0.7
fontdue-0.7.3
form_urlencoded-1.2.1
futures-0.3.31
futures-channel-0.3.31
futures-core-0.3.31
futures-executor-0.3.31
futures-io-0.3.31
futures-macro-0.3.31
futures-sink-0.3.31
futures-task-0.3.31
futures-util-0.3.31
generic-array-0.14.7
getrandom-0.2.15
ghash-0.5.1
gif-0.13.1
gif-dispose-5.0.1
gifski-1.32.0
gimli-0.31.1
glob-0.3.2
h2-0.3.26
hashbrown-0.13.2
hashbrown-0.14.5
hashbrown-0.15.2
heck-0.5.0
hermit-abi-0.3.9
hex-0.4.3
hkdf-0.12.4
hmac-0.12.1
http-0.2.12
http-1.2.0
http-auth-basic-0.3.5
http-body-1.0.1
http-body-util-0.1.2
httparse-1.9.5
httpdate-1.0.3
humantime-2.1.0
hyper-1.5.2
hyper-util-0.1.10
iana-time-zone-0.1.61
iana-time-zone-haiku-0.1.2
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
image-0.25.5
image-webp-0.2.1
imagequant-4.3.3
imgref-1.11.0
impl-more-0.1.9
indexmap-2.7.0
inout-0.1.3
interpolate_name-0.2.4
is_terminal_polyfill-1.70.1
itertools-0.12.1
itoa-1.0.14
jobserver-0.1.32
jpeg-decoder-0.3.1
js-sys-0.3.77
language-tags-0.3.2
lazy_static-1.5.0
libc-0.2.169
libdrm_amdgpu_sys-0.7.7
libfuzzer-sys-0.4.8
libloading-0.8.6
linux-raw-sys-0.4.15
litemap-0.7.4
local-channel-0.1.5
local-waker-0.1.4
lock_api-0.4.12
log-0.4.25
loop9-0.1.5
mach2-0.4.2
maybe-rayon-0.1.1
memchr-2.7.4
memoffset-0.9.1
miette-7.4.0
miette-derive-7.4.0
mime-0.3.17
mime_guess-2.0.5
minimal-lexical-0.2.1
miniz_oxide-0.8.3
mio-1.0.3
new_debug_unreachable-1.0.6
nix-0.24.3
nix-0.29.0
nom-7.1.3
noop_proc_macro-0.3.0
ntapi-0.4.1
nu-glob-0.100.0
num-bigint-0.4.6
num-conv-0.1.0
num-derive-0.4.2
num-integer-0.1.46
num-rational-0.4.2
num-traits-0.2.19
num_cpus-1.16.0
object-0.36.7
once_cell-1.20.2
opaque-debug-0.3.1
ordered-channel-1.1.0
ordered-stream-0.2.0
parking-2.2.1
parking_lot-0.12.3
parking_lot_core-0.9.10
parse-size-1.1.0
paste-1.0.15
path-slash-0.1.5
pciid-parser-0.7.2
percent-encoding-2.3.1
pin-project-lite-0.2.16
pin-utils-0.1.0
pkg-config-0.3.31
png-0.17.16
polyval-0.6.2
powerfmt-0.2.0
ppv-lite86-0.2.20
proc-macro-crate-3.2.0
proc-macro2-1.0.93
profiling-1.0.16
profiling-procmacros-1.0.16
psutil-3.3.0
quick-error-2.0.1
quote-1.0.38
rand-0.8.5
rand_chacha-0.3.1
rand_core-0.6.4
rav1e-0.7.1
ravif-0.11.11
rayon-1.10.0
rayon-core-1.12.1
redox_syscall-0.5.8
regex-1.11.1
regex-automata-0.4.9
regex-lite-0.1.6
regex-syntax-0.8.5
resize-0.8.8
rgb-0.8.50
ril-0.10.3
rustc-demangle-0.1.24
rustc_version-0.4.1
rustix-0.38.43
rustversion-1.0.19
ryu-1.0.18
scopeguard-1.2.0
semver-1.0.24
serde-1.0.217
serde_derive-1.0.217
serde_json-1.0.136
serde_plain-1.0.2
serde_repr-0.1.19
serde_spanned-0.6.8
serde_urlencoded-0.7.1
sha1-0.10.6
sha2-0.10.8
shlex-1.3.0
signal-hook-0.3.17
signal-hook-registry-1.4.2
simd-adler32-0.3.7
simd_helpers-0.1.0
slab-0.4.9
smallvec-1.13.2
socket2-0.5.8
stable_deref_trait-1.2.0
static-files-0.2.4
static_assertions-1.1.0
strict-num-0.1.1
strsim-0.11.1
strum-0.26.3
strum_macros-0.26.4
subtle-2.6.1
syn-2.0.96
synstructure-0.13.1
sysinfo-0.33.1
system-deps-6.2.2
systemd-journal-logger-2.2.0
target-lexicon-0.12.16
tempfile-3.15.0
test-context-0.3.0
test-context-macros-0.3.0
thiserror-1.0.69
thiserror-2.0.11
thiserror-impl-1.0.69
thiserror-impl-2.0.11
thread_local-1.1.8
tiff-0.9.1
time-0.3.37
time-core-0.1.2
time-macros-0.2.19
tiny-skia-0.11.4
tiny-skia-path-0.11.4
tinystr-0.7.6
tokio-1.43.0
tokio-graceful-shutdown-0.15.3
tokio-macros-2.5.0
tokio-util-0.7.13
toml-0.8.19
toml_datetime-0.6.8
toml_edit-0.22.22
tower-service-0.3.3
tracing-0.1.41
tracing-attributes-0.1.28
tracing-core-0.1.33
try-lock-0.2.5
ttf-parser-0.15.2
typenum-1.17.0
uds_windows-1.1.0
unicase-2.8.1
unicode-ident-1.0.14
unicode-width-0.1.14
unicode-xid-0.2.6
universal-hash-0.5.1
url-2.5.4
utf16_iter-1.0.5
utf8_iter-1.0.4
utf8parse-0.2.2
uuid-1.12.0
v_frame-0.3.8
version-compare-0.2.0
version_check-0.9.5
want-0.3.1
wasi-0.11.0+wasi-snapshot-preview1
wasm-bindgen-0.2.100
wasm-bindgen-backend-0.2.100
wasm-bindgen-macro-0.2.100
wasm-bindgen-macro-support-0.2.100
wasm-bindgen-shared-0.2.100
web-time-1.1.0
weezl-0.1.8
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.57.0
windows-core-0.52.0
windows-core-0.57.0
windows-implement-0.57.0
windows-interface-0.57.0
windows-result-0.1.2
windows-sys-0.52.0
windows-sys-0.59.0
windows-targets-0.52.6
windows_aarch64_gnullvm-0.52.6
windows_aarch64_msvc-0.52.6
windows_i686_gnu-0.52.6
windows_i686_gnullvm-0.52.6
windows_i686_msvc-0.52.6
windows_x86_64_gnu-0.52.6
windows_x86_64_gnullvm-0.52.6
windows_x86_64_msvc-0.52.6
winnow-0.6.24
wrapcenum-derive-0.4.1
write16-1.0.0
writeable-0.5.5
xdg-home-1.3.0
yata-0.7.0
yoke-0.7.5
yoke-derive-0.7.5
zbus-5.3.0
zbus_macros-5.3.0
zbus_names-4.1.1
zerocopy-0.7.35
zerocopy-derive-0.7.35
zerofrom-0.1.5
zerofrom-derive-0.1.5
zerovec-0.10.4
zerovec-derive-0.10.3
zstd-0.13.2
zstd-safe-7.2.1
zstd-sys-2.0.13+zstd.1.5.6
zune-core-0.4.12
zune-jpeg-0.4.14
zvariant-5.2.0
zvariant_derive-5.2.0
zvariant_utils-3.1.0
"

NPM_TARBALL="coolercontrol-${PV}.tar.bz2"
PYTHON_COMPAT=( "python3_"{10,11} ) # Can support 3.12 but limited by Nuitka

inherit cargo lcnr npm

KEYWORDS="~amd64"
S="${WORKDIR}/coolercontrol-${PV}/coolercontrold"
SRC_URI="
$(cargo_crate_uris ${CRATES})
https://gitlab.com/coolercontrol/coolercontrol/-/archive/${PV}/coolercontrol-${PV}.tar.bz2
"

DESCRIPTION="The main daemon containing the core logic for interfacing with devices"
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
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" hwmon video_cards_nvidia openrc systemd ebuild_revision_2"
RDEPEND+="
	~sys-apps/coolercontrol-liqctld-${PV}
	hwmon? (
		>=sys-apps/lm-sensors-3.6.0
	)
	video_cards_nvidia? (
		x11-drivers/nvidia-drivers[tools]
	)
"
DEPEND+="
	${RDEPEND}
"
VUE_DEPEND="
	>=net-libs/nodejs-18.12.0[npm]
"
BDEPEND+="
	${VUE_DEPEND}
	>=dev-build/make-4.3
	virtual/pkgconfig
	|| (
		dev-lang/rust:=
		dev-lang/rust-bin:=
	)
"

# @FUNCTION: cargo_src_unpack
# @DESCRIPTION:
# Unpacks the package and the cargo registry.
# From cargo.eclass
_cargo_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	mkdir -p "${ECARGO_VENDOR}" || die
	mkdir -p "${S}" || die

	cp -a \
		"${FILESDIR}/${PV}/Cargo."{"lock","toml"} \
		"${S}" \
		|| die

	local archive shasum pkg
	for archive in ${A} ; do
		case "${archive}" in
			*.crate)
				ebegin "Loading ${archive} into Cargo registry"
				tar -xf "${DISTDIR}"/${archive} -C "${ECARGO_VENDOR}/" || die
				# generate sha256sum of the crate itself as cargo needs this
				shasum=$(sha256sum "${DISTDIR}"/${archive} | cut -d ' ' -f 1)
				pkg=$(basename ${archive} .crate)
				cat <<- EOF > ${ECARGO_VENDOR}/${pkg}/.cargo-checksum.json
				{
					"package": "${shasum}",
					"files": {}
				}
				EOF
				# if this is our target package we need it in ${WORKDIR} too
				# to make ${S} (and handle any revisions too)
				if [[ ${P} == ${pkg}* ]]; then
					tar -xf "${DISTDIR}"/${archive} -C "${WORKDIR}" || die
				fi
				eend $?
				;;
			*)
				#unpack ${archive} # don't unpack npm tarballs yet
				;;
		esac
	done

	cargo_gen_config
}

set_gui_port() {
	local L=(
		"coolercontrold/src/api/mod.rs"
	)
	local port=${COOLERCONTROL_GUI_PORT:-11987}
	local p
	for p in "${L[@]}" ; do
		sed -i -e "s|11987|${port}|g" "${p}" || die
	done
}

set_liqctld_port() {
	local L=(
		"coolercontrold/src/repositories/liquidctl/liquidctl_repo.rs"
	)
	local port=${COOLERCONTROL_LIQCTLD_PORT:-11986}
	local p
	for p in "${L[@]}" ; do
		sed -i -e "s|11986|${port}|g" "${p}" || die
	done
}

pkg_setup() {
ewarn "Do not emerge ${CATEGORY}/${PN} package directly.  Emerge sys-apps/coolercontrol instead."
	npm_pkg_setup
	rust_pkg_setup
}

npm_update_lock_install_post() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
	# CVE-2025-24964; DoS, DT, ID; Critical
		pushd "${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui" >/dev/null 2>&1 || die
			sed -i -e "s|\"vitest\": \"^2.1.8\"|\"vitest\": \"^2.1.9\"|" "package.json" || die
			enpm install "vitest@2.1.9" -D --prefer-offline

			sed -i -e "s|\"esbuild\": \"^0.24.2\"|\"esbuild\": \"^0.25.0\"|g" "package.json" || die # Must follow vitest
			enpm install "esbuild@^0.25.0" -D
		popd >/dev/null 2>&1 || die
	fi
}

src_unpack() {
	S="${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui" \
	npm_src_unpack
	S="${WORKDIR}/coolercontrol-${PV}/coolercontrold" \
	_cargo_src_unpack
}

src_configure() {
	S="${WORKDIR}/coolercontrol-${PV}/coolercontrold" \
	cargo_src_configure
	pushd "${WORKDIR}/coolercontrol-${PV}" || die
		set_gui_port
		set_liqctld_port
	popd
}

src_compile() {
	npm_hydrate
	pushd "${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui" || die
einfo "PWD: $(pwd)"
		S="${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui" \
		enpm install ${NPM_INSTALL_ARGS[@]}
	# Audit fix already done with NPM_UPDATE_LOCK=1
		S="${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui" \
		enpm run build
	popd
	cp -r \
		"${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui/dist/"* \
		"resources/app/" \
		|| die
	S="${WORKDIR}/coolercontrol-${PV}/coolercontrold" \
	cargo_src_compile
}

src_install() {
	S="${WORKDIR}/coolercontrol-${PV}/coolercontrold" \
	cargo_src_install
	if use openrc ; then
ewarn
ewarn "The OpenRC script is experimental for ${CATEGORY}/${PN}."
ewarn "If it works, send an issue request to remove this message."
ewarn
		exeinto /etc/init.d
		doexe "${FILESDIR}/coolercontrold"
	fi
	if use systemd ; then
		insinto /lib/systemd/system
		doins "${WORKDIR}/coolercontrol-${PV}/packaging/systemd/coolercontrold.service"
	fi
	if ! use openrc && ! use systemd ; then
ewarn
ewarn "You are responsible to creating the init service for ${PN} for your"
ewarn "init system."
ewarn
	fi

	LCNR_SOURCE="${WORKDIR}/cargo_home/gentoo"
	LCNR_TAG="third_party_cargo"
	lcnr_install_files

	LCNR_SOURCE="${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui/node_modules"
	LCNR_TAG="third_party_npm"
	lcnr_install_files
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  passed (0.17.2, 20231201)
