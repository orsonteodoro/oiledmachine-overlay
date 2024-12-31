# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# shellcheck disable=SC2086

EAPI=8

#GENERATE_LOCKFILE=1

CRATES="
adler-1.0.2
ahash-0.8.7
aom-decode-0.2.7
autocfg-1.1.0
avif-parse-1.0.0
bitreader-0.3.8
bytemuck-1.14.0
byteorder-1.5.0
cc-1.0.83
cfg-if-1.0.0
cmake-0.1.50
crc32fast-1.3.2
crossbeam-channel-0.5.11
crossbeam-deque-0.8.5
crossbeam-epoch-0.9.18
crossbeam-utils-0.8.19
dssim-3.3.1
dssim-core-3.2.8
dunce-1.0.4
either-1.9.0
fallible_collections-0.4.9
flate2-1.0.28
foreign-types-0.5.0
foreign-types-macros-0.2.3
foreign-types-shared-0.3.1
getopts-0.2.21
hashbrown-0.13.2
hermit-abi-0.3.4
imgref-1.10.0
itertools-0.12.0
jobserver-0.1.27
jpeg-decoder-0.3.1
lcms2-6.0.4
lcms2-sys-4.0.4
libaom-sys-0.15.0
libc-0.2.152
libwebp-0.1.2
libwebp-sys2-0.1.9
load_image-3.1.4
lodepng-3.10.0
log-0.4.20
miniz_oxide-0.7.1
num-0.4.1
num-bigint-0.4.4
num-complex-0.4.4
num-integer-0.1.45
num-iter-0.1.43
num-rational-0.4.1
num-traits-0.2.17
num_cpus-1.16.0
once_cell-1.19.0
pkg-config-0.3.29
proc-macro2-1.0.76
quick-error-2.0.1
quote-1.0.35
rayon-1.8.1
rayon-core-1.12.1
rexif-0.7.3
rgb-0.8.37
static_assertions-1.1.0
syn-2.0.48
unicode-ident-1.0.12
unicode-width-0.1.11
vcpkg-0.2.15
version_check-0.9.4
yuv-0.1.5
zerocopy-0.7.32
zerocopy-derive-0.7.32
"

inherit cargo edo
QA_FLAGS_IGNORED="usr/bin/dssim"

KEYWORDS="~amd64"
SRC_URI+="
$(cargo_crate_uris ${CRATES})
https://github.com/kornelski/dssim/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Image similarity comparison simulating human perception"
HOMEPAGE="https://github.com/kornelski/dssim"
LICENSE="
	0BSD
	AGPL-3
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	BSD
	BSD-2
	CC0-1.0
	GPL-3+
	IJG
	MIT
	MPL-2.0
	Unlicense
	ZLIB
"
RESTRICT="mirror"
SLOT="0"
IUSE=" ebuild_revision_1"
BDEPEND="
	dev-util/cargo-c
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
				#unpack ${archive} # Don't override lockfile with double unpack of ${P}.tar.gz containing possible vulnerable crate reference
				;;
		esac
	done

	cargo_gen_config
}

src_unpack() {
	unpack "${P}.tar.gz"
	if [[ "${GENERATE_LOCKFILE}" == "1" ]] ; then
		cd "${S}" || die
# Regenerate and replace vulnerable cargo crates
		rm -f "Cargo.lock"
		cargo generate-lockfile || die
einfo "Manually copy ${S}/Cargo.* to ${FILESDIR}/${PV}"
		die
	else
		cp -a "${FILESDIR}/${PV}/Cargo."* "${S}" || die
	fi
	_cargo_src_unpack
}

src_compile() {
	cargo_src_compile
	cd "${S}/dssim-core" || die
	edo cargo cbuild --release
}

src_install() {
	einstalldocs
	cargo_src_install
	cd "${S}/dssim-core/target/x86_64-unknown-linux-gnu/release" || die
	insinto "/usr/include"
	doins "include/dssim.h"
	dolib.so "libdssim.so"
	dolib.a "libdssim.a"
	insinto "/usr/$(get_libdir)/pkgconfig"
	sed -i -e "s|/usr/local|/usr|" "dssim.pc" || die
	doins "dssim.pc"
	dosym \
		"/usr/$(get_libdir)/libdssim.so" \
		"/usr/$(get_libdir)/libdssim.so.3"
}
