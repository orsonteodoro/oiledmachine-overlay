# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D12, U22

# NPM_AUDIT_FIX=0
NPM_INSTALL_ARGS=(
	"--prefer-offline"
)

# To update npm side use:
# PATH="/usr/local/oiledmachine-overlay/scripts:${PATH}"
# NPM_UPDATER_PROJECT_ROOT="coolercontrol-2.2.1/coolercontrol-ui" NPM_UPDATER_VERSIONS="2.2.1" npm_updater_update_locks.sh

# To update cargo size use:
# ./convert-cargo-lock.sh 2.2.1 2.2.1

declare -A GIT_CRATES=(
[nvml-wrapper-sys]="https://github.com/codifryed/nvml-wrapper;572095f631da93be8d243c73820e581676969897;nvml-wrapper-%commit%/nvml-wrapper-sys" # 0.8.0
[nvml-wrapper]="https://github.com/codifryed/nvml-wrapper;572095f631da93be8d243c73820e581676969897;nvml-wrapper-%commit%/nvml-wrapper" # 0.10.0
[tower_governor]="https://github.com/codifryed/tower-governor;fd799d86418e58179468953c80ad7094a81a9e37;tower-governor-%commit%" # 0.4.3
)

CRATES="
addr2line-0.24.2
adler2-2.0.1
aead-0.5.2
aes-0.8.4
aes-gcm-0.10.3
ahash-0.7.8
ahash-0.8.12
aho-corasick-1.1.3
aide-0.13.5
aligned-vec-0.6.4
alloc-no-stdlib-2.0.4
alloc-stdlib-0.2.2
allocator-api2-0.2.21
android-tzdata-0.1.1
android_system_properties-0.1.5
anstream-0.6.19
anstyle-1.0.11
anstyle-parse-0.2.7
anstyle-query-1.1.3
anstyle-wincon-3.0.9
anyhow-1.0.98
arbitrary-1.4.1
arg_enum_proc_macro-0.3.4
arrayref-0.3.9
arrayvec-0.7.6
async-broadcast-0.7.2
async-compression-0.4.25
async-recursion-1.1.1
async-trait-0.1.88
autocfg-1.5.0
av1-grain-0.2.4
avif-serialize-0.8.4
axum-0.7.9
axum-core-0.4.5
axum-extra-0.9.6
axum-macros-0.4.2
axum_typed_multipart-0.14.0
axum_typed_multipart_macros-0.14.0
backtrace-0.3.75
base64-0.22.1
bitflags-1.3.2
bitflags-2.9.1
bitstream-io-2.6.0
bitvec-1.0.1
block-buffer-0.10.4
borsh-1.5.7
borsh-derive-1.5.7
brotli-8.0.1
brotli-decompressor-5.0.0
built-0.7.7
bumpalo-3.19.0
bytecheck-0.6.12
bytecheck_derive-0.6.12
bytemuck-1.23.1
byteorder-lite-0.1.0
bytes-1.10.1
cached-0.55.1
cached_proc_macro-0.24.0
cached_proc_macro_types-0.1.1
cc-1.2.27
cfg-expr-0.15.8
cfg-if-1.0.1
cfg_aliases-0.2.1
chrono-0.4.41
cipher-0.4.4
clap-4.5.40
clap_builder-4.5.40
clap_derive-4.5.40
clap_lex-0.7.5
color_quant-1.1.0
colorchoice-1.0.4
concurrent-queue-2.5.0
const_format-0.2.34
const_format_proc_macros-0.2.34
cookie-0.18.1
core-foundation-sys-0.8.7
cpufeatures-0.2.17
crc32fast-1.4.2
crossbeam-channel-0.5.15
crossbeam-deque-0.8.6
crossbeam-epoch-0.9.18
crossbeam-utils-0.8.21
crypto-common-0.1.6
ctr-0.9.2
darling-0.20.11
darling_core-0.20.11
darling_macro-0.20.11
deranged-0.4.0
derive_more-2.0.1
derive_more-impl-2.0.1
digest-0.10.7
dyn-clone-1.0.19
either-1.15.0
encoding_rs-0.8.35
endi-1.1.0
enumflags2-0.7.12
enumflags2_derive-0.7.12
env_filter-0.1.3
env_logger-0.11.8
equator-0.4.2
equator-macro-0.4.2
equivalent-1.0.2
errno-0.3.13
event-listener-5.4.0
event-listener-strategy-0.5.4
fastrand-2.3.0
fdeflate-0.3.7
flate2-1.1.2
fnv-1.0.7
foldhash-0.1.5
fontdue-0.7.3
form_urlencoded-1.2.1
forwarded-header-value-0.1.1
funty-2.0.0
futures-0.3.31
futures-channel-0.3.31
futures-core-0.3.31
futures-executor-0.3.31
futures-io-0.3.31
futures-lite-2.6.0
futures-macro-0.3.31
futures-sink-0.3.31
futures-task-0.3.31
futures-timer-3.0.3
futures-util-0.3.31
generic-array-0.14.7
getrandom-0.2.16
getrandom-0.3.3
ghash-0.5.1
gif-0.13.3
gif-dispose-5.0.1
gifski-1.33.0
gimli-0.31.1
glob-0.3.2
governor-0.7.0
hashbrown-0.12.3
hashbrown-0.13.2
hashbrown-0.14.5
hashbrown-0.15.4
hashlink-0.10.0
headers-0.4.1
headers-core-0.3.0
heck-0.5.0
hermit-abi-0.5.2
hex-0.4.3
hkdf-0.12.4
hmac-0.12.1
http-1.3.1
http-body-1.0.1
http-body-util-0.1.3
httparse-1.10.1
httpdate-1.0.3
hyper-1.6.0
hyper-util-0.1.14
iana-time-zone-0.1.63
iana-time-zone-haiku-0.1.2
ident_case-1.0.1
image-0.25.6
image-webp-0.2.3
imagequant-4.3.4
imgref-1.11.0
include_dir-0.7.4
include_dir_macros-0.7.4
indexmap-2.10.0
inout-0.1.4
interpolate_name-0.2.4
io-uring-0.6.4
is_terminal_polyfill-1.70.1
itertools-0.12.1
itoa-1.0.15
jiff-0.2.15
jiff-static-0.2.15
jobserver-0.1.33
jpeg-decoder-0.3.2
js-sys-0.3.77
lazy_format-2.0.3
libc-0.2.174
libdrm_amdgpu_sys-0.8.3
libfuzzer-sys-0.4.9
libloading-0.8.8
linux-raw-sys-0.9.4
lock_api-0.4.13
log-0.4.27
loop9-0.1.5
mach2-0.4.3
matchit-0.7.3
maybe-rayon-0.1.1
memchr-2.7.5
memoffset-0.9.1
mime-0.3.17
mime_guess-2.0.5
minimal-lexical-0.2.1
miniz_oxide-0.8.9
mio-1.0.4
moro-local-0.4.0
multer-3.1.0
new_debug_unreachable-1.0.6
nix-0.29.0
nix-0.30.1
no-std-compat-0.4.1
nom-7.1.3
nonempty-0.7.0
nonzero_ext-0.3.0
noop_proc_macro-0.3.0
ntapi-0.4.1
nu-glob-0.104.1
num-bigint-0.4.6
num-conv-0.1.0
num-derive-0.4.2
num-integer-0.1.46
num-rational-0.4.2
num-traits-0.2.19
num_cpus-1.17.0
objc2-core-foundation-0.3.1
objc2-io-kit-0.3.1
object-0.36.7
once_cell-1.21.3
once_cell_polyfill-1.70.1
opaque-debug-0.3.1
ordered-channel-1.2.0
ordered-stream-0.2.0
parking-2.2.1
parking_lot-0.12.4
parking_lot_core-0.9.11
paste-1.0.15
pciid-parser-0.8.0
percent-encoding-2.3.1
pin-project-1.1.10
pin-project-internal-1.1.10
pin-project-lite-0.2.16
pin-utils-0.1.0
pkg-config-0.3.32
png-0.17.16
polyval-0.6.2
portable-atomic-1.11.1
portable-atomic-util-0.2.4
powerfmt-0.2.0
ppv-lite86-0.2.21
proc-macro-crate-3.3.0
proc-macro-error-attr2-2.0.0
proc-macro-error2-2.0.1
proc-macro2-1.0.95
profiling-1.0.17
profiling-procmacros-1.0.17
psutil-5.2.0
ptr_meta-0.1.4
ptr_meta_derive-0.1.4
quick-error-2.0.1
quote-1.0.40
r-efi-5.3.0
radium-0.7.0
rand-0.8.5
rand_chacha-0.3.1
rand_core-0.6.4
rav1e-0.7.1
ravif-0.11.20
rayon-1.10.0
rayon-core-1.12.1
redox_syscall-0.5.13
regex-1.11.1
regex-automata-0.4.9
regex-syntax-0.8.5
rend-0.4.2
resize-0.8.8
rgb-0.8.50
ril-0.10.3
rkyv-0.7.45
rkyv_derive-0.7.45
rust_decimal-1.37.2
rustc-demangle-0.1.25
rustix-1.0.7
rustversion-1.0.21
ryu-1.0.20
scc-2.3.4
schemars-0.8.22
schemars_derive-0.8.22
scopeguard-1.2.0
sdd-3.0.8
seahash-4.1.0
serde-1.0.219
serde_derive-1.0.219
serde_derive_internals-0.29.1
serde_json-1.0.140
serde_path_to_error-0.1.17
serde_qs-0.13.0
serde_repr-0.1.20
serde_spanned-0.6.9
serde_urlencoded-0.7.1
serial_test-3.2.0
serial_test_derive-3.2.0
sha1-0.10.6
sha2-0.10.9
shlex-1.3.0
signal-hook-registry-1.4.5
simd-adler32-0.3.7
simd_helpers-0.1.0
simdutf8-0.1.5
slab-0.4.10
smallvec-1.15.1
socket2-0.4.10
socket2-0.5.10
spin-0.9.8
spinning_top-0.3.0
static_assertions-1.1.0
strict-num-0.1.1
strsim-0.11.1
strum-0.27.1
strum_macros-0.27.1
subtle-2.6.1
syn-1.0.109
syn-2.0.104
sync_wrapper-1.0.2
sysinfo-0.35.2
system-deps-6.2.2
systemd-journal-logger-2.2.2
tap-1.0.1
target-lexicon-0.12.16
tempfile-3.20.0
thiserror-1.0.69
thiserror-2.0.12
thiserror-impl-1.0.69
thiserror-impl-2.0.12
thread_local-1.1.9
tiff-0.9.1
time-0.3.41
time-core-0.1.4
time-macros-0.2.22
tiny-skia-0.11.4
tiny-skia-path-0.11.4
tinyvec-1.9.0
tinyvec_macros-0.1.1
tokio-1.45.1
tokio-macros-2.5.0
tokio-stream-0.1.17
tokio-uring-0.5.0
tokio-util-0.7.15
toml-0.8.23
toml_datetime-0.6.11
toml_edit-0.22.27
toml_write-0.1.2
tower-0.5.2
tower-cookies-0.10.0
tower-http-0.6.6
tower-layer-0.3.3
tower-serve-static-0.1.1
tower-service-0.3.3
tower-sessions-0.13.0
tower-sessions-core-0.13.0
tower-sessions-memory-store-0.13.0
tracing-0.1.41
tracing-attributes-0.1.30
tracing-core-0.1.34
try-lock-0.2.5
ttf-parser-0.15.2
typenum-1.18.0
ubyte-0.10.4
uds_windows-1.1.0
unicase-2.8.1
unicode-ident-1.0.18
unicode-xid-0.2.6
universal-hash-0.5.1
utf8parse-0.2.2
uuid-1.17.0
v_frame-0.3.9
version-compare-0.2.0
version_check-0.9.5
want-0.3.1
wasi-0.11.1+wasi-snapshot-preview1
wasi-0.14.2+wasi-0.2.4
wasm-bindgen-0.2.100
wasm-bindgen-backend-0.2.100
wasm-bindgen-macro-0.2.100
wasm-bindgen-macro-support-0.2.100
wasm-bindgen-shared-0.2.100
web-time-1.1.0
weezl-0.1.10
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.61.3
windows-collections-0.2.0
windows-core-0.61.2
windows-future-0.2.1
windows-implement-0.60.0
windows-interface-0.59.1
windows-link-0.1.3
windows-numerics-0.2.0
windows-result-0.3.4
windows-strings-0.4.2
windows-sys-0.52.0
windows-sys-0.59.0
windows-sys-0.60.2
windows-targets-0.52.6
windows-targets-0.53.2
windows-threading-0.1.0
windows_aarch64_gnullvm-0.52.6
windows_aarch64_gnullvm-0.53.0
windows_aarch64_msvc-0.52.6
windows_aarch64_msvc-0.53.0
windows_i686_gnu-0.52.6
windows_i686_gnu-0.53.0
windows_i686_gnullvm-0.52.6
windows_i686_gnullvm-0.53.0
windows_i686_msvc-0.52.6
windows_i686_msvc-0.53.0
windows_x86_64_gnu-0.52.6
windows_x86_64_gnu-0.53.0
windows_x86_64_gnullvm-0.52.6
windows_x86_64_gnullvm-0.53.0
windows_x86_64_msvc-0.52.6
windows_x86_64_msvc-0.53.0
winnow-0.7.11
wit-bindgen-rt-0.39.0
wrapcenum-derive-0.4.1
wyz-0.5.1
yata-0.7.0
zbus-5.7.1
zbus_macros-5.7.1
zbus_names-4.2.0
zerocopy-0.8.26
zerocopy-derive-0.8.26
zstd-0.13.3
zstd-safe-7.2.4
zstd-sys-2.0.15+zstd.1.5.7
zune-core-0.4.12
zune-jpeg-0.4.18
zvariant-5.5.3
zvariant_derive-5.5.3
zvariant_utils-3.2.0
"

NPM_TARBALL="coolercontrol-${PV}.tar.bz2"
PYTHON_COMPAT=( "python3_"{10,11} )
RUST_MAX_VER="1.82.0" # Inclusive
RUST_MIN_VER="1.82.0" # llvm-19.1, required for:  feature `edition2024` is required

inherit cargo lcnr npm

KEYWORDS="~amd64"
S="${WORKDIR}/coolercontrol-${PV}/coolercontrold"
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
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" hwmon video_cards_nvidia openrc systemd ebuild_revision_6"
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
		=dev-lang/rust-1.82*
		=dev-lang/rust-bin-1.82*
	)
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

	mkdir -p "${ECARGO_VENDOR}" "${S}" || die

	local archive shasum pkg
	local crates=()
	einfo "${A}"
	for archive in ${A}; do
		case "${archive}" in
			*.crate)
				crates+=( "${archive}" )
				;;
			*)
				einfo "pwd:  "$(pwd)
				if [[ "${archive}" == "coolercontrol-${PV}.tar.bz2" ]] ; then
					einfo "Skipping coolercontrol-${PV}.tar.bz2"
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

# FIXME:  Change port
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
ewarn "Do not emerge ${CATEGORY}/${PN} package directly.  Emerge the sys-apps/coolercontrol metapackage instead."
	npm_pkg_setup
	rust_pkg_setup
}

npm_update_lock_install_post() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		pushd "${WORKDIR}/coolercontrol-${PV}/coolercontrol-ui" >/dev/null 2>&1 || die
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
	#unpack "coolercontrol-${PV}.tar.bz2"
	#die

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
# OILEDMACHINE-OVERLAY-TEST:  passed (2.2.1, 20250701)
