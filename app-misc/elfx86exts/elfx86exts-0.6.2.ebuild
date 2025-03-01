# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Use `./convert-cargo-lock.sh 0.6.2 0.6.2` to generate

CRATES="
adler2-2.0.0
anstream-0.6.18
anstyle-1.0.10
anstyle-parse-0.2.6
anstyle-query-1.1.2
anstyle-wincon-3.0.7
assert_cmd-2.0.16
bstr-1.11.3
byteorder-1.5.0
capstone-0.11.0
capstone-sys-0.15.0
cc-1.2.16
cfg-if-1.0.0
clap-4.5.31
clap_builder-4.5.31
clap_derive-4.5.28
clap_lex-0.7.4
colorchoice-1.0.3
crc32fast-1.4.2
derive_more-0.99.19
difflib-0.4.0
doc-comment-0.3.3
elfx86exts-0.6.2
escargot-0.5.13
flate2-1.1.0
heck-0.5.0
is_terminal_polyfill-1.70.1
itoa-1.0.14
libc-0.2.170
log-0.4.26
memchr-2.7.4
memmap-0.7.0
miniz_oxide-0.8.5
object-0.32.2
once_cell-1.20.3
predicates-3.1.3
predicates-core-1.0.9
predicates-tree-1.0.12
proc-macro2-1.0.93
quote-1.0.38
regex-automata-0.4.9
ruzstd-0.5.0
ryu-1.0.19
serde-1.0.218
serde_derive-1.0.218
serde_json-1.0.139
shlex-1.3.0
static_assertions-1.1.0
strsim-0.11.1
syn-2.0.98
termtree-0.5.1
twox-hash-1.6.3
unicode-ident-1.0.17
utf8parse-0.2.2
wait-timeout-0.2.1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
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
"

inherit cargo lcnr

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PN}-${PV}"
SRC_URI="
	https://github.com/pkgw/${PN}/archive/${PN}@${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)
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

src_install() {
	cargo_src_install
	docinto "licenses"
	dodoc "LICENSE"

	LCNR_SOURCE="${WORKDIR}/cargo_home/gentoo"
	LCNR_TAG="third_party_cargo"
	lcnr_install_files
}
