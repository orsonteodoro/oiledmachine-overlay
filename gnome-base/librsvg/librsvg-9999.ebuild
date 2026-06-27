# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# avif should be already sandboxed unconditionally by glycin.
# glycin was the default for librsvg since Oct 17, 2025 for 2.61.2.

MY_PV="${PV%.*}"

CARGO_UNPACK_TYPES="crate"
CFLAGS_HARDENED_USE_CASES="untrusted-data"
RUSTFLAGS_HARDENED_USE_CASES="untrusted-data"
RUSTFLAGS_HARDENED_VULNERABILITY_HISTORY="DOS NPD OOBR PT"

DISABLED_CRATES="
librsvg-c-2.62.90
pixbufloader-svg-0.0.1
rsvg-bench-2.62.90
rsvg_convert-2.62.90
rsvg-fuzz-0.0.0
"

CRATES="
adler2-2.0.1
aes-0.8.4
ahash-0.8.12
aho-corasick-1.1.4
alloca-0.4.0
android_system_properties-0.1.5
anes-0.1.6
anstream-1.0.0
anstyle-1.0.14
anstyle-parse-1.0.0
anstyle-query-1.1.5
anstyle-wincon-3.0.11
approx-0.5.1
arbitrary-1.4.2
assert_cmd-2.2.2
autocfg-1.5.1
av-data-0.4.4
bitflags-1.3.2
bitflags-2.13.0
bitreader-0.3.11
bit-set-0.8.0
bit-vec-0.8.0
block-0.1.6
block-buffer-0.10.4
block-padding-0.3.3
bstr-1.12.3
bumpalo-3.20.3
bytemuck-1.25.0
byteorder-1.5.0
byteorder-lite-0.1.0
bytes-1.12.0
byte-slice-cast-1.2.3
cairo-rs-0.22.0
cairo-sys-rs-0.22.0
cast-0.3.0
cbc-0.1.2
cc-1.2.65
cfg-expr-0.20.8
cfg-if-1.0.4
chacha20-0.10.1
chrono-0.4.45
ci-0.0.0
ciborium-0.2.2
ciborium-io-0.2.2
ciborium-ll-0.2.2
cipher-0.4.4
clap-4.6.1
clap_builder-4.6.0
clap_complete-4.6.5
clap_derive-4.6.1
clap_lex-1.1.0
colorchoice-1.0.5
color_quant-1.1.0
core-foundation-sys-0.8.7
cpufeatures-0.2.17
cpufeatures-0.3.0
crc32fast-1.5.0
criterion-0.8.2
criterion-plot-0.8.2
crossbeam-deque-0.8.6
crossbeam-epoch-0.9.18
crossbeam-utils-0.8.21
crunchy-0.2.4
crypto-common-0.1.7
cssparser-0.37.0
cssparser-color-0.5.0
cssparser-macros-0.7.0
data-url-0.3.2
dav1d-0.11.1
dav1d-sys-0.8.3
defmt-1.1.0
defmt-macros-1.1.0
defmt-parser-1.0.0
deranged-0.5.8
derive_more-2.1.1
derive_more-impl-2.1.1
diff-0.1.13
difflib-0.4.0
digest-0.10.7
displaydoc-0.2.6
dlib-0.5.3
dtoa-1.0.11
dtoa-short-0.3.5
ecb-0.1.2
either-1.16.0
encoding_rs-0.8.35
equivalent-1.0.2
errno-0.3.14
fallible_collections-0.4.9
fastrand-2.4.1
fdeflate-0.3.7
find-msvc-tools-0.1.9
flate2-1.1.9
float-cmp-0.10.0
fnv-1.0.7
form_urlencoded-1.2.2
futures-channel-0.3.32
futures-core-0.3.32
futures-executor-0.3.32
futures-io-0.3.32
futures-macro-0.3.32
futures-task-0.3.32
futures-util-0.3.32
gdk-pixbuf-0.22.0
gdk-pixbuf-sys-0.22.0
generic-array-0.14.7
getrandom-0.3.4
getrandom-0.4.3
gif-0.14.2
gio-0.22.6
gio-sys-0.22.0
gio-unix-0.22.6
gio-unix-sys-0.22.0
gio-win32-0.22.6
gio-win32-sys-0.22.0
glam-0.30.10
glam-0.31.1
glam-0.32.1
glam-0.33.1
glib-0.22.7
glib-macros-0.22.6
glib-sys-0.22.6
gobject-sys-0.22.6
half-2.7.1
hashbrown-0.13.2
hashbrown-0.17.1
heck-0.5.0
iana-time-zone-0.1.65
iana-time-zone-haiku-0.1.2
icu_collections-2.2.0
icu_locale_core-2.2.0
icu_normalizer-2.2.0
icu_normalizer_data-2.2.0
icu_properties-2.2.0
icu_properties_data-2.2.0
icu_provider-2.2.0
idna-1.1.0
idna_adapter-1.2.2
image-0.25.10
image-webp-0.2.4
indexmap-2.14.0
inout-0.1.4
is_terminal_polyfill-1.70.2
itertools-0.13.0
itertools-0.15.0
itoa-1.0.18
jiff-0.2.29
jiff-static-0.2.29
jiff-tzdb-0.1.6
jiff-tzdb-platform-0.1.3
jobserver-0.1.34
js-sys-0.3.103
language-tags-0.3.2
lazy_static-1.5.0
libc-0.2.186
libfuzzer-sys-0.4.13
libloading-0.8.9
librsvg-2.63.0-beta.0
librsvg-rebind-0.3.0
librsvg-rebind-sys-0.3.0
linux-raw-sys-0.12.1
litemap-0.8.2
locale_config-0.3.0
lock_api-0.4.14
log-0.4.33
lopdf-0.42.0
malloc_buf-0.0.6
markup5ever-0.39.0
matches-0.1.10
matrixmultiply-0.3.10
md-5-0.10.6
memchr-2.8.2
miniz_oxide-0.8.9
moxcms-0.8.1
mp4parse-0.17.0
mutants-0.0.4
nalgebra-0.35.0
nalgebra-macros-0.3.0
new_debug_unreachable-1.0.6
nom-8.0.0
normalize-line-endings-0.3.0
num-bigint-0.4.6
num-complex-0.4.6
num-conv-0.2.2
num-derive-0.4.2
num-integer-0.1.46
num-rational-0.4.2
num-traits-0.2.19
objc-0.2.7
objc-foundation-0.1.1
objc_id-0.1.1
once_cell-1.21.4
once_cell_polyfill-1.70.2
oorandom-11.1.5
page_size-0.6.0
pango-0.22.6
pangocairo-0.22.0
pangocairo-sys-0.22.0
pango-sys-0.22.0
parking_lot-0.12.5
parking_lot_core-0.9.12
percent-encoding-2.3.2
phf-0.13.1
phf_codegen-0.13.1
phf_generator-0.13.1
phf_macros-0.13.1
phf_shared-0.13.1
pin-project-lite-0.2.17
pkg-config-0.3.33
plotters-0.3.7
plotters-backend-0.3.7
plotters-svg-0.3.7
png-0.18.1
portable-atomic-1.13.1
portable-atomic-util-0.2.7
potential_utf-0.1.5
powerfmt-0.2.0
ppv-lite86-0.2.21
precomputed-hash-0.1.1
predicates-3.1.4
predicates-core-1.0.10
predicates-tree-1.0.13
pretty_assertions-1.4.1
proc-macro2-1.0.106
proc-macro-error2-2.0.1
proc-macro-error-attr2-2.0.0
proptest-1.11.0
pxfm-0.1.29
quick-error-1.2.3
quick-error-2.0.1
quote-1.0.46
rand-0.10.1
rand-0.9.4
rand_chacha-0.9.0
rand_core-0.10.1
rand_core-0.9.5
rand_xorshift-0.4.0
rangemap-1.7.1
rawpointer-0.2.1
rayon-1.12.0
rayon-core-1.13.0
rctree-0.6.0
redox_syscall-0.5.18
r-efi-5.3.0
r-efi-6.0.0
regex-1.12.4
regex-automata-0.4.14
regex-syntax-0.8.11
rgb-0.8.53
rustc-hash-2.1.2
rustc_version-0.4.1
rustix-1.1.4
rustversion-1.0.22
rusty-fork-0.3.1
safe_arch-1.0.0
same-file-1.0.6
scopeguard-1.2.0
selectors-0.38.0
semver-1.0.28
serde-1.0.228
serde_core-1.0.228
serde_derive-1.0.228
serde_json-1.0.150
serde_spanned-1.1.1
servo_arc-0.4.3
sha2-0.10.9
shell-words-1.1.1
shlex-2.0.1
simba-0.10.0
simd-adler32-0.3.9
siphasher-1.0.3
slab-0.4.12
smallvec-1.15.2
stable_deref_trait-1.2.1
static_assertions-1.1.0
string_cache-0.9.0
string_cache_codegen-0.6.1
stringprep-0.1.5
strsim-0.11.1
syn-2.0.118
synstructure-0.13.2
system-deps-7.0.8
target-lexicon-0.13.5
tempfile-3.27.0
tendril-0.5.0
termtree-0.5.1
thiserror-2.0.18
thiserror-impl-2.0.18
time-0.3.51
time-core-0.1.9
time-macros-0.2.30
tinystr-0.8.3
tinytemplate-1.2.1
tinyvec-1.11.0
tinyvec_macros-0.1.1
toml-1.1.2+spec-1.1.0
toml_datetime-1.1.1+spec-1.1.0
toml_parser-1.1.2+spec-1.1.0
toml_writer-1.1.1+spec-1.1.0
ttf-parser-0.25.1
typenum-1.20.1
unarray-0.1.4
unicode-bidi-0.3.18
unicode-ident-1.0.24
unicode-normalization-0.1.25
unicode-properties-0.1.4
url-2.5.8
utf-8-0.7.6
utf8_iter-1.0.4
utf8parse-0.2.2
version_check-0.9.5
version-compare-0.2.1
wait-timeout-0.2.1
walkdir-2.5.0
wasip2-1.0.4+wasi-0.2.12
wasm-bindgen-0.2.126
wasm-bindgen-macro-0.2.126
wasm-bindgen-macro-support-0.2.126
wasm-bindgen-shared-0.2.126
web_atoms-0.2.5
web-sys-0.3.103
weezl-0.1.12
wide-1.5.0
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.11
winapi-x86_64-pc-windows-gnu-0.4.0
windows-core-0.62.2
windows-implement-0.60.2
windows-interface-0.59.3
windows-link-0.2.1
windows-result-0.4.1
windows-strings-0.5.1
windows-sys-0.61.2
winnow-1.0.3
wit-bindgen-0.57.1
writeable-0.6.3
xml5ever-0.39.0
yansi-1.0.1
yeslogic-fontconfig-sys-6.0.1
yoke-0.8.3
yoke-derive-0.8.2
zerocopy-0.8.52
zerocopy-derive-0.8.52
zerofrom-0.1.8
zerofrom-derive-0.1.7
zerotrie-0.2.4
zerovec-0.11.6
zerovec-derive-0.11.3
zmij-1.0.21
zune-core-0.5.1
zune-jpeg-0.5.15
"

PYTHON_COMPAT=( python3_{10..14} )

RUST_MAX_VER="1.95.0"
RUST_MIN_VER="1.95.0" # LLVM 22.1
RUST_MULTILIB=1

CHKL_TIMESTAMPS=(
	"dev-libs/glib-2.89.9999"
	"dev-libs/libxml2-9999"
	"media-libs/dav1d-9999"
	"media-libs/freetype-9999"
	"media-libs/harfbuzz-9999"
	"x11-libs/cairo-9999"
	"x11-libs/gdk-pixbuf-9999"
	"x11-libs/pango-9999"
)

inherit cargo cflags-hardened chkl gnome2 meson-multilib python-any-r1 rustflags-hardened rust-toolchain secure-version vala

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="1a830b1e34bab5c69aec7c5cf86812376b4e53e2"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/librsvg-librsvg-${MY_PV}"
	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/librsvg.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"
	SRC_URI+="
https://gitlab.gnome.org/GNOME/librsvg/-/archive/librsvg-${MY_PV}/librsvg-librsvg-${MY_PV}.tar.bz2?ref_type=heads -> librsvg-librsvg-${MY_PV}.tar.bz2
	"
fi
S="${WORKDIR}/librsvg-librsvg-${MY_PV}"
SRC_URI+="
${CARGO_CRATE_URIS}
"

DESCRIPTION="Scalable Vector Graphics (SVG) rendering library"
HOMEPAGE="https://wiki.gnome.org/Projects/LibRsvg https://gitlab.gnome.org/GNOME/librsvg"

LICENSE="LGPL-2.1+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD ISC MIT MPL-2.0
	Unicode-3.0
"

# It is not clear if major version, so version, gnome 2/3/4 compatibility, glib compatibility
SLOT="2"

IUSE+="
avif gtk-doc +introspection +pixbuf-loader test +vala
ebuild_revision_18
"
RESTRICT="
	!test? (
		test
	)
	mirror
" # Speed up downloads
REQUIRED_USE="
	gtk-doc? ( introspection )
	vala? ( introspection )
"

RDEPEND="
	>=x11-libs/cairo-${CAIRO_PV}:=[glib,svg(+),${MULTILIB_USEDEP}]
	>=media-libs/freetype-${FREETYPE_PV}:=[${MULTILIB_USEDEP}]
	pixbuf-loader? (
		>=x11-libs/gdk-pixbuf-${GDK_PIXBUF_PV}:=[introspection?,${MULTILIB_USEDEP}]
	)
	!pixbuf-loader? (
		>=media-libs/glycin-loaders-2.1.1:=[svg]
	)
	>=dev-libs/glib-${GLIB_PV}:=[${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-${HARFBUZZ_PV}:=[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-${LIBXML2_PV}:=[${MULTILIB_USEDEP}]
	>=x11-libs/pango-${PANGO_PV}:=[${MULTILIB_USEDEP}]

	avif? ( >=media-libs/dav1d-${DAV1D_PV}:=[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-${GOBJECT_INTROSPECTION_PV}:= )
"
DEPEND="${RDEPEND}"
# jq is not required but used to suggest default.
BDEPEND="
	>=dev-build/meson-1.3.0
	>=dev-util/cargo-c-0.10.10
	app-misc/jq
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/docutils[${PYTHON_USEDEP}]')
	gtk-doc? ( dev-util/gi-docgen )
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

QA_FLAGS_IGNORED="
	usr/bin/rsvg-convert
	usr/lib.*/librsvg.*
	usr/lib.*/gdk-pixbuf*/*/loaders/*
"

PATCHES=(
	#"${FILESDIR}"/${PN}-2.60.0-libxml2-2.15.0-tests.patch
)

pkg_setup() {
	rust_pkg_setup
	python-any-r1_pkg_setup

	if use pixbuf-loader ; then
ewarn "Image loader:  pixbuf-loader (unsandboxed)"
	else
einfo "Image loader:  glycin-loader (sandboxed)"
	fi

	local GLYCIN_PACKAGES=(
		"media-gfx/fotema"
		"media-gfx/loupe"
		"media-libs/glycin"
		"media-libs/glycin-loaders"
		"net-im/fractal"
		"gnome-base/gnome-49"
		"gnome-base/gnome-50"
		# Implies gtk4
	)

	local PIXBUF_PACKAGES=(
		"media-gfx/eog"
		"gnome-base/gnome-48"
		"gnome-base/gnome-45"
		"x11-libs/gtk+" # gtk+:3 or gtk+:2 based apps that require svg
	)

	# Peek to see if the user will build a glycin-loader based package.
	local resume_data=$(cat "/var/cache/edb/mtimedb" | jq '.resume')
	local needs_glycin=0
	local x
	if has_version "app-misc/jq" ; then
		for x in "${GLYCIN_PACKAGES[@]}" ; do
			if echo "${resume_data}" | grep -q -e "${x}" ; then
ewarn "${x} assumes USE=-pixbuf-loader for ${PN}"
			elif [[ "${x}" =~ "-"[0-9.]+$ ]] && has_version "=${x}*" ; then
ewarn "${x} assumes USE=-pixbuf-loader for ${PN}"
			elif [[ ! "${x}" =~ "-"[0-9.]+$ ]] && has_version "${x}" ; then
ewarn "${x} assumes USE=-pixbuf-loader for ${PN}"
			fi
		done
	fi

	# Peek to see if the user will build a pixbuf-loader based package.
	local needs_glycin=0
	if has_version "app-misc/jq" ; then
		for x in "${PIXBUF_PACKAGES[@]}" ; do
			if echo "${resume_data}" | grep -q -e "${x}" ; then
ewarn "${x} assumes USE=pixbuf-loader for ${PN}"
			elif [[ "${x}" =~ "-"[0-9.]+$ ]] && has_version "=${x}*" ; then
ewarn "${x} assumes USE=pixbuf-loader for ${PN}"
			elif [[ ! "${x}" =~ "-"[0-9.]+$ ]] && has_version "${x}" ; then
ewarn "${x} assumes USE=pixbuf-loader for ${PN}"
			fi
		done
	fi
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi

#	die

	local actual_cargo_lock_fingerprint=$(sha512sum "${S}/Cargo.lock" | cut -f 1 -d " ")
	local expected_cargo_lock_fingerprint="c1f53203f4b274f2d5be9c57775a738dcb1eaaf9bde5252ce4688a60fb0de38bfa8dabe73b7768e621b7aef5b5d890d1545840582e56e53a5e969b25f469bba2"
	if [[ "${actual_cargo_lock_fingerprint}" != "${expected_cargo_lock_fingerprint}" ]] ; then
eerror "QA:  Update the cargo lockfile fingerprint and the lockfile/cargo sections."
eerror "The cargo fingerprint doesn't match.  Use the fallback-commit to continue."
eerror "Actual cargo lockfile fingerprint:  ${actual_cargo_lock_fingerprint}"
eerror "Expected cargo lockfile fingerprint:  ${expected_cargo_lock_fingerprint}"
		die
	fi

	cargo_src_unpack
	cp -aT "${FILESDIR}/${PV}" "${S}" || die
}

src_prepare() {
	use vala && vala_setup
	gnome2_src_prepare
}

src_configure() {
einfo "PATH:  ${PATH}"
einfo "rustc version:"
	"${RUSTC}" --version || die

	meson-multilib_src_configure
}

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	rustflags-hardened_append
	local emesonargs=(
		$(meson_feature avif)
		$(meson_native_use_feature introspection)
		$(meson_feature pixbuf-loader pixbuf)
		$(meson_feature pixbuf-loader)
		-Dtriplet="$(rust_abi)"
		$(meson_native_use_feature gtk-doc docs)
		$(meson_native_use_feature vala)
		$(meson_use test tests)
	)

	cargo_env meson_src_configure
}

src_compile() {
	meson-multilib_src_compile
}

multilib_src_compile() {
	cargo_env meson_src_compile
}

multilib_src_test() {
	cargo_env meson_src_test
}

src_test() {
	meson-multilib_src_test
}

src_install() {
	meson-multilib_src_install
}

multilib_src_install() {
	cargo_env meson_src_install
}

multilib_src_install_all() {
	einstalldocs

	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/Rsvg-2.0 "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}

pkg_preinst() {
	multilib_foreach_abi gnome2_pkg_preinst
}

pkg_postinst() {
	multilib_foreach_abi gnome2_pkg_postinst
}

pkg_postrm() {
	multilib_foreach_abi gnome2_pkg_postrm
}

# OILEDMACHINE-OVERLAY-TEST:  INTERACTIVE passed 2.62.1 (20260504)
# eog load of svg:  passed
