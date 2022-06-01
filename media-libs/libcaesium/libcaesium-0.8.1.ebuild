# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See CI
# Get the "Download log archive" from the gear icon and grep for "Downloaded" for the below crates
# with careful manual crate additions to preserve build determinism

# Use below:
# grep "Downloaded" 'build (ubuntu-latest)'/* | sed -e "s|.*Downloaded||g" | cut -c 6- | sed -e "s| v|-|g" | sort

MISSING_CRATES="
glob-0.3.0
hermit-abi-0.1.19
redox_syscall-0.2.10
wasi-0.10.2+wasi-snapshot-preview1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
"

CRATES="
${MISSING_CRATES}
adler-1.0.2
adler32-1.2.0
ahash-0.7.6
ansi_term-0.12.1
arrayvec-0.7.2
atty-0.2.14
autocfg-1.1.0
bitflags-1.3.2
bit-vec-0.6.3
build_const-0.2.2
bytemuck-1.9.1
byteorder-1.4.3
bytes-0.5.6
bytes-1.1.0
cc-1.0.73
cfb-0.6.1
cfg-if-1.0.0
chrono-0.4.19
clap-2.34.0
cloudflare-zlib-0.2.9
cloudflare-zlib-sys-0.3.0
color_quant-1.1.0
crc-1.8.1
crc-2.1.0
crc32fast-1.3.2
crc-catalog-1.1.1
crossbeam-channel-0.5.4
crossbeam-deque-0.8.1
crossbeam-epoch-0.9.8
crossbeam-utils-0.8.8
deflate-0.8.6
deflate-1.0.0
dssim-3.2.0
dssim-core-3.2.1
dunce-1.0.2
either-1.6.1
fallible_collections-0.4.4
filetime-0.2.15
flate2-1.0.23
foreign-types-0.5.0
foreign-types-macros-0.2.2
foreign-types-shared-0.3.1
getopts-0.2.21
getrandom-0.2.6
gif-0.11.3
gifsicle-1.92.5
hashbrown-0.11.2
image-0.23.14
image-0.24.1
img-parts-0.2.3
imgref-1.9.1
indexmap-1.8.1
infer-0.7.0
itertools-0.10.3
jobserver-0.1.24
jpeg-decoder-0.2.4
kamadak-exif-0.5.4
lazy_static-1.4.0
lcms2-5.4.1
lcms2-sys-3.1.9
libc-0.2.123
libdeflater-0.7.5
libdeflate-sys-0.7.5
libwebp-sys-0.4.2
load_image-2.16.2
lodepng-3.6.1
log-0.4.16
memoffset-0.6.5
miniz_oxide-0.3.7
miniz_oxide-0.4.4
miniz_oxide-0.5.1
mozjpeg-0.9.2
mozjpeg-sys-1.0.1
mutate_once-0.1.1
nasm-rs-0.2.4
num-0.4.0
num-bigint-0.4.3
num-complex-0.4.0
num_cpus-1.13.1
num-integer-0.1.44
num-iter-0.1.42
num-rational-0.3.2
num-rational-0.4.0
num-traits-0.2.14
once_cell-1.10.0
oxipng-5.0.1
pkg-config-0.3.25
png-0.16.8
png-0.17.5
proc-macro2-1.0.37
quote-1.0.18
rayon-1.5.1
rayon-core-1.9.1
rexif-0.7.3
rgb-0.8.32
rustc_version-0.4.0
scopeguard-1.1.0
semver-1.0.7
stderrlog-0.5.1
strsim-0.8.0
syn-1.0.91
termcolor-1.1.3
textwrap-0.11.0
thread_local-1.0.1
time-0.1.43
typed-arena-1.7.0
unicode-width-0.1.9
unicode-xid-0.2.2
uuid-0.8.2
vec_map-0.8.2
version_check-0.9.4
webp-0.2.2
weezl-0.1.5
wild-2.0.4
zopfli-0.4.0
"

inherit cargo

DESCRIPTION="The Caesium compression library written in Rust"
HOMEPAGE="https://github.com/Lymphatus/libcaesium"
LICENSE="
	Apache-2.0
	0BSD
	AGPL-3
	BSD
	CC-BY-3.0
	CC0-1.0
	load_image-2.16.x
	MIT
	ZLIB
"
# Apache-2.0 is this project the rest are dependencies

KEYWORDS="~amd64 ~x86"
SLOT="0/$(ver_cut 1-3 ${PV})"
SRC_URI="https://github.com/Lymphatus/libcaesium/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" $(cargo_crate_uris)"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${PV}"
DOCS=( README.md )

_install_licenses() {
	OIFS="${IFS}"
	export IFS=$'\n'
	for f in $(find "${S}" \
	  -iname "*licen*" -type f \
	  -o -iname "*copyright*" \
	  -o -iname "*copying*" \
	  -o -iname "*patent*" \
	  -o -iname "ofl.txt" \
	  -o -iname "*notice*" \
	  -o -iname "*authors*" \
	  -o -iname "*CONTRIBUTORS*" \
	  ) $(grep -i -G -l \
		-e "copyright" \
		-e "licen" \
		-e "warrant" \
		$(find "${S}" -iname "*readme*")) ; \
	do
		if [[ -f "${f}" ]] ; then
			d=$(dirname "${f}" | sed -e "s|^${S}||")
		else
			d=$(echo "${f}" | sed -e "s|^${S}||")
		fi
		docinto "licenses/${d}"
		dodoc -r "${f}"
	done
	export IFS="${OIFS}"
}

src_install() {
	dolib.so target/release/${PN}.so
	einstalldocs
	_install_licenses
}
