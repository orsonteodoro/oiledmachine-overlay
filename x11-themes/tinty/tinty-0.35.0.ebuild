# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

inherit secure-version

CFLAGS_HARDENED_USE_CASES="untrusted-data"
RUST_MAX_VER="${RUST_LLVM_ROLLING_PV}"
RUST_MIN_VER="${RUST_LLVM_ROLLING_PV}"
RUST_PV="${RUST_MIN_VER}"
RUSTFLAGS_HARDENED_USE_CASES="untrusted-data"

CRATES="
adler2-2.0.1
aho-corasick-1.1.4
aligned-0.4.3
aligned-vec-0.6.4
anstream-0.6.21
anstyle-1.0.13
anstyle-parse-0.2.7
anstyle-query-1.1.5
anstyle-wincon-3.0.11
anyhow-1.0.103
approx-0.5.1
arbitrary-1.4.2
arg_enum_proc_macro-0.3.4
arrayvec-0.7.6
as-slice-0.2.1
autocfg-1.5.0
av1-grain-0.2.5
avif-serialize-0.8.8
av-scenechange-0.14.1
bit_field-0.10.3
bitflags-1.3.2
bitflags-2.10.0
bitstream-io-4.10.0
built-0.8.0
bumpalo-3.20.2
by_address-1.2.1
bytemuck-1.25.0
byteorder-lite-0.1.0
cc-1.2.60
cfg-if-1.0.4
clap-4.5.55
clap_builder-4.5.55
clap_complete-4.5.65
clap_derive-4.5.55
clap_lex-0.7.7
colorchoice-1.0.4
color_quant-1.1.0
color-thief-0.2.2
const_format-0.2.36
const_format_proc_macros-0.2.34
crc32fast-1.5.0
crossbeam-deque-0.8.6
crossbeam-epoch-0.9.20
crossbeam-utils-0.8.21
crunchy-0.2.4
dirs-6.0.0
dirs-sys-0.5.0
displaydoc-0.2.5
either-1.15.0
equator-0.4.2
equator-macro-0.4.2
equivalent-1.0.2
errno-0.3.14
exr-1.74.0
fastrand-1.9.0
fast-srgb8-1.0.0
fax-0.2.6
fax_derive-0.2.0
fdeflate-0.3.7
find-msvc-tools-0.1.9
flate2-1.1.9
form_urlencoded-1.2.2
fs2-0.4.3
getrandom-0.2.17
getrandom-0.3.4
gif-0.14.2
half-2.7.1
hashbrown-0.16.1
heck-0.5.0
hermit-abi-0.3.9
hex_color-3.0.0
home-0.5.12
html-escape-0.2.13
icu_collections-2.1.1
icu_locale_core-2.1.1
icu_normalizer-2.1.1
icu_normalizer_data-2.1.1
icu_properties-2.1.2
icu_properties_data-2.1.2
icu_provider-2.1.1
idna-1.1.0
idna_adapter-1.2.1
image-0.25.10
image-webp-0.2.4
imgref-1.12.0
indexmap-2.13.0
instant-0.1.13
interpolate_name-0.2.4
io-lifetimes-1.0.11
is_terminal_polyfill-1.70.2
itertools-0.14.0
itoa-1.0.17
jobserver-0.1.34
konst-0.2.20
konst_macro_rules-0.2.19
lebe-0.5.3
libc-0.2.184
libfuzzer-sys-0.4.12
libredox-0.1.12
linux-raw-sys-0.3.8
litemap-0.8.1
log-0.4.29
loop9-0.1.5
maybe-rayon-0.1.1
memchr-2.7.6
minimal-lexical-0.2.1
miniz_oxide-0.8.9
moxcms-0.8.1
new_debug_unreachable-1.0.6
nom-7.1.3
nom-8.0.0
noop_proc_macro-0.3.0
no_std_io2-0.9.3
num-bigint-0.4.6
num-derive-0.4.2
num-integer-0.1.46
num-rational-0.4.2
num-traits-0.2.19
once_cell-1.21.4
once_cell_polyfill-1.70.2
option-ext-0.2.0
palette-0.7.6
palette_derive-0.7.6
paste-1.0.15
pastey-0.1.1
percent-encoding-2.3.2
phf-0.11.3
phf_generator-0.11.3
phf_macros-0.11.3
phf_shared-0.11.3
png-0.18.1
pori-0.0.0
potential_utf-0.1.4
ppv-lite86-0.2.21
proc-macro2-1.0.106
profiling-1.0.17
profiling-procmacros-1.0.17
pxfm-0.1.29
qoi-0.4.1
quick-error-2.0.1
quick-xml-0.38.4
quote-1.0.45
rand-0.8.6
rand-0.9.4
rand_chacha-0.3.1
rand_chacha-0.9.0
rand_core-0.6.4
rand_core-0.9.5
rav1e-0.8.1
ravif-0.13.0
rayon-1.11.0
rayon-core-1.13.0
redox_syscall-0.3.5
redox_users-0.5.2
r-efi-5.3.0
regex-1.12.2
regex-automata-0.4.13
regex-syntax-0.8.8
rgb-0.8.53
ribboncurls-0.5.0
rustix-0.37.28
rustversion-1.0.22
ryu-1.0.22
same-file-1.0.6
semver-1.0.28
serde-1.0.228
serde_core-1.0.228
serde_derive-1.0.228
serde_json-1.0.149
serde_spanned-0.6.9
serde_yaml-0.9.34+deprecated
shell-words-1.1.1
shlex-1.3.0
simd-adler32-0.3.9
simd_helpers-0.1.0
siphasher-1.0.2
smallvec-1.15.1
stable_deref_trait-1.2.1
strip-ansi-escapes-0.2.1
strsim-0.11.1
syn-2.0.117
synstructure-0.13.2
tempfile-3.6.0
thiserror-1.0.69
thiserror-2.0.18
thiserror-impl-1.0.69
thiserror-impl-2.0.18
tiff-0.11.3
tinted-builder-0.16.0
tinted-builder-rust-0.21.0
tinted-scheme-extractor-0.13.0
tinty-0.35.0
tinystr-0.8.2
tinyvec-1.11.0
tinyvec_macros-0.1.1
toml-0.8.23
toml_datetime-0.6.11
toml_edit-0.22.27
toml_write-0.1.2
unicode-ident-1.0.24
unicode-normalization-0.1.25
unicode-xid-0.2.6
unsafe-libyaml-0.2.11
url-2.5.8
utf8_iter-1.0.4
utf8parse-0.2.2
utf8-width-0.1.8
v_frame-0.3.9
vte-0.14.1
walkdir-2.5.0
wasi-0.11.1+wasi-snapshot-preview1
wasip2-1.0.3+wasi-0.2.9
wasm-bindgen-0.2.118
wasm-bindgen-macro-0.2.118
wasm-bindgen-macro-support-0.2.118
wasm-bindgen-shared-0.2.118
wax-0.7.0
weezl-0.1.12
which-8.0.2
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.11
winapi-x86_64-pc-windows-gnu-0.4.0
windows_aarch64_gnullvm-0.48.5
windows_aarch64_msvc-0.48.5
windows_i686_gnu-0.48.5
windows_i686_msvc-0.48.5
windows-link-0.2.1
windows-sys-0.48.0
windows-sys-0.61.2
windows-targets-0.48.5
windows_x86_64_gnu-0.48.5
windows_x86_64_gnullvm-0.48.5
windows_x86_64_msvc-0.48.5
winnow-0.7.14
wit-bindgen-0.57.1
writeable-0.6.2
xdg-2.5.2
y4m-0.8.0
yoke-0.8.1
yoke-derive-0.8.1
zerocopy-0.8.47
zerocopy-derive-0.8.47
zerofrom-0.1.6
zerofrom-derive-0.1.6
zerotrie-0.2.3
zerovec-0.11.5
zerovec-derive-0.11.2
zmij-1.0.17
zune-core-0.5.1
zune-inflate-0.2.54
zune-jpeg-0.5.15
"

declare -A GIT_CRATES=(
)

CHKL_TIMESTAMPS=(
	"dev-vcs/git-9999-r2"
	"dev-vcs/git-9999-r3"
	"dev-vcs/git-9999-r1"
	"dev-vcs/git-9999"
)

inherit cargo cflags-hardened chkl rustflags-hardened

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
$(cargo_crate_uris)
https://github.com/tinted-theming/tinty/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A base16 and base24 color scheme manager"
HOMEPAGE="
	https://github.com/tinted-theming/tinty
"
LICENSE="
	GPL-3
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
ebuild_revision_1
"
RDEPEND+="
	>=dev-vcs/git-${GIT_PV}:=
	>=x11-misc/xdg-utils-${XDG_UTILS_PV}:=
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "CHANGELOG.md" "README.md" "USAGE.md" )

pkg_setup() {
	rust_pkg_setup
}

src_unpack() {
	unpack ${A}
#	die
	cargo_src_unpack
	cp -aT \
		"${FILESDIR}/${PV}"* \
		"${S}" \
		|| die
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append		# For *-sys crates
	rustflags-hardened_append
	cargo_src_configure
}

src_compile() {
	cargo_src_compile
}

src_install() {
	cargo_src_install
	einstalldocs
	docinto "licenses"
	dodoc "LICENSE"
}

pkg_postinst() {
einfo "For a list of color themes, bookmark https://tinted-theming.github.io/tinted-gallery/"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  INTERACTIVE 0.32.2 (20260519)
# Apply color theme to alacritty:  passed
# Apply color theme to xfce4-terminal:  passed
