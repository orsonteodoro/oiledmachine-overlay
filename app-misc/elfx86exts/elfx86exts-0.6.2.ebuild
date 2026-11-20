# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit secure-version

CFLAGS_HARDENED_USE_CASES="untrusted-data"
RUST_MAX_VER="${RUST_LLVM_LTS_PV}"
RUST_MIN_VER="${RUST_LLVM_LTS_PV}"
RUSTFLAGS_HARDENED_USE_CASES="untrusted-data"

# Use `./convert-cargo-lock.sh 0.6.2 0.6.2` to generate

CRATES="
adler2-2.0.1
anstream-1.0.0
anstyle-1.0.14
anstyle-parse-1.0.0
anstyle-query-1.1.5
anstyle-wincon-3.0.11
assert_cmd-2.2.2
bstr-1.14.0
byteorder-1.5.0
capstone-0.11.0
capstone-sys-0.15.0
cc-1.11.3
cfg-if-1.0.5
clap-4.6.9
clap_builder-4.6.7
clap_derive-4.6.9
clap_lex-1.1.2
colorchoice-1.0.5
crc32fast-1.5.5
derive_more-0.99.20
difflib-0.4.0
elfx86exts-0.6.2
escargot-0.5.15
find-msvc-tools-0.1.15
flate2-1.1.11
heck-0.5.0
is_terminal_polyfill-1.70.2
itoa-1.0.19
libc-0.2.191
log-0.4.35
memchr-2.8.3
memmap-0.7.0
miniz_oxide-0.9.1
object-0.32.2
once_cell_polyfill-1.70.2
predicates-3.1.4
predicates-core-1.0.10
predicates-tree-1.0.13
proc-macro2-1.0.107
quote-1.0.47
regex-automata-0.4.19
ruzstd-0.5.0
serde-1.0.229
serde_core-1.0.229
serde_derive-1.0.229
serde_json-1.0.154
shlex-2.0.1
simd-adler32-0.3.10
static_assertions-1.1.0
strsim-0.11.1
syn-2.0.119
syn-3.0.10
termtree-0.5.1
twox-hash-1.6.3
unicode-ident-1.0.27
utf8parse-0.2.2
wait-timeout-0.2.1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
windows-link-0.2.1
windows-sys-0.61.2
zlib-rs-0.6.8
zmij-1.0.23
"

inherit cargo cflags-hardened lcnr rustflags-hardened

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PN}-${PV}"
SRC_URI="
	$(cargo_crate_uris)
	https://github.com/pkgw/${PN}/archive/${PN}@${PV}.tar.gz -> ${P}.tar.gz
"

DESCRIPTION="Disassemble a x86 binary and print out used instruction sets"
HOMEPAGE="https://github.com/pkgw/elfx86exts"
LICENSE="
	0BSD
	Apache-2.0
	Boost-1.0
	MIT
	Unicode-DFS-2016
	Unlicense
	UoI-NCSA
	ZLIB
"
SLOT="0"
IUSE+="
ebuild_revision_2
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

src_unpack() {
	unpack "${P}.tar.gz"
#die
	S="${WORKDIR}/${PN}-${PN}-${PV}" \
	_cargo_src_unpack
}

src_configure() {
	cflags-hardened_append		# For *-sys crates
	rustflags-hardened_append	# For int overflow mitigation
	cargo_src_configure
}

src_install() {
	cargo_src_install
	docinto "licenses"
	dodoc "LICENSE"

	LCNR_SOURCE="${WORKDIR}/cargo_home/gentoo"
	LCNR_TAG="third_party_cargo"
	lcnr_install_files
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED (0.6.2, 20250228)
