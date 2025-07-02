# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# shellcheck disable=SC2086

EAPI=8

#GENERATE_LOCKFILE=1

CRATES="
adler2-2.0.1
aom-decode-0.2.13
arrayvec-0.7.6
autocfg-1.5.0
avif-parse-1.4.0
bitflags-2.9.1
bitreader-0.3.11
bytemuck-1.23.1
byteorder-1.5.0
cc-1.2.27
cfg-if-1.0.1
cmake-0.1.54
crc32fast-1.4.2
crossbeam-channel-0.5.15
crossbeam-deque-0.8.6
crossbeam-epoch-0.9.18
crossbeam-utils-0.8.21
dunce-1.0.5
either-1.15.0
fallible_collections-0.5.1
flate2-1.1.2
foreign-types-0.5.0
foreign-types-macros-0.2.3
foreign-types-shared-0.3.1
getopts-0.2.23
getrandom-0.3.3
imgref-1.11.0
itertools-0.14.0
jobserver-0.1.33
jpeg-decoder-0.3.2
lcms2-6.1.0
lcms2-sys-4.0.5
leb128-0.2.5
libaom-sys-0.17.2+libaom.3.11.0
libc-0.2.174
libwebp-0.1.2
libwebp-sys2-0.1.11
libz-rs-sys-0.5.1
load_image-3.2.1
lodepng-3.12.1
log-0.4.27
miniz_oxide-0.8.9
num-traits-0.2.19
ordered-channel-1.2.0
pkg-config-0.3.32
proc-macro2-1.0.95
quick-error-2.0.1
quote-1.0.40
r-efi-5.3.0
rayon-1.10.0
rayon-core-1.12.1
rexif-0.7.5
rgb-0.8.50
shlex-1.3.0
syn-2.0.104
unicode-ident-1.0.18
unicode-width-0.2.1
vcpkg-0.2.15
wasi-0.14.2+wasi-0.2.4
wit-bindgen-rt-0.39.0
yuv-0.1.9
zlib-rs-0.5.1
"
# Upstream uses Rust 1.72, but not in distro
#
# Using 9999 because of:
# error: the `-Z unstable-options` flag must also be passed to enable the flag `check-cfg`
# error: could not compile `bytemuck` (lib)
#
# For 9999, the compiler used was rustc 1.89.0-nightly (bf64d66bd 2025-05-21)
#
RUST_MAX_VER="9999" # Inclusive
RUST_MIN_VER="9999" # Rust 20.1
RUST_PV="${RUST_MIN_VER}"

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
IUSE=" ebuild_revision_3"
BDEPEND="
	dev-util/cargo-c
	|| (
		dev-lang/rust:${RUST_PV}
		dev-lang/rust-bin:${RUST_PV}
	)
	|| (
		dev-lang/rust:=
		dev-lang/rust-bin:=
	)
"

pkg_setup() {
	rust_pkg_setup
}

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
	#die # For lockfile updates

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

# See https://doc.rust-lang.org/rustc/platform-support.html
get_rust_chost() {
	if [[ "${ABI}" == "amd64" && "${ELIBC}" == "glibc" ]] ; then
		echo "x86_64-unknown-linux-gnu"
	elif [[ "${ABI}" == "amd64" && "${ELIBC}" == "musl" ]] ; then
		echo "x86_64-unknown-linux-musl"

	elif [[ "${ABI}" == "arm64" && "${ELIBC}" == "glibc" ]] ; then
		echo "aarch64-unknown-linux-gnu"
	elif [[ "${ABI}" == "arm64" && "${ELIBC}" == "musl" ]] ; then
		echo "aarch64-unknown-linux-musl"

	elif [[ "${CHOST}" =~ "armv7" && "${CHOST}" =~ "gnueabihf" && "${ELIBC}" == "glibc" ]] ; then
		echo "armv7-unknown-linux-gnueabihf"
	elif [[ "${CHOST}" =~ "armv7" && "${CHOST}" =~ "gnueabihf" && "${ELIBC}" == "musl" ]] ; then
		echo "armv7-unknown-linux-musleabihf"

	elif [[ "${CHOST}" =~ "armv7" && "${ELIBC}" == "glibc" ]] ; then
		echo "armv7-unknown-linux-gnueabi"
	elif [[ "${CHOST}" =~ "armv7" && "${ELIBC}" == "musl" ]] ; then
		echo "armv7-unknown-linux-musleabi"

	elif [[ "${CHOST}" =~ "loongarch64" && "${ELIBC}" == "glibc" ]] ; then
		echo "loongarch64-unknown-linux-gnu"
	elif [[ "${CHOST}" =~ "loongarch64" && "${ELIBC}" == "musl" ]] ; then
		echo "loongarch64-unknown-linux-musl"

	elif [[ "${CHOST}" =~ "mips64el-" && "${ELIBC}" == "glibc" ]] ; then
		echo "mips64el-unknown-linux-gnuabi64"
	elif [[ "${CHOST}" =~ "mips64el-" && "${ELIBC}" == "musl" ]] ; then
		echo "mips64el-unknown-linux-muslabi64"

	elif [[ "${CHOST}" =~ "mips64-" && "${ELIBC}" == "glibc" ]] ; then
		echo "mips64-unknown-linux-gnuabi64"
	elif [[ "${CHOST}" =~ "mips64-" && "${ELIBC}" == "musl" ]] ; then
		echo "mips64-unknown-linux-muslabi64"

	elif [[ "${CHOST}" =~ "mips-" && "${ELIBC}" == "glibc" ]] ; then
		echo "mips-unknown-linux-gnu"
	elif [[ "${CHOST}" =~ "mips-" && "${ELIBC}" == "musl" ]] ; then
		echo "mips-unknown-linux-musl"

	elif [[ "${CHOST}" =~ "powerpc64le-" && "${ELIBC}" == "glibc" ]] ; then
		echo "powerpc64le-unknown-linux-gnu"
	elif [[ "${CHOST}" =~ "powerpc64le-" && "${ELIBC}" == "musl" ]] ; then
		echo "powerpc64le-unknown-linux-musl"

	elif [[ "${CHOST}" =~ "powerpc64-" && "${ELIBC}" == "glibc" ]] ; then
		echo "powerpc64-unknown-linux-gnu"
	elif [[ "${CHOST}" =~ "powerpc64-" && "${ELIBC}" == "musl" ]] ; then
		echo "powerpc64-unknown-linux-musl"

	elif [[ "${CHOST}" =~ "powerpc-" && "${ELIBC}" == "glibc" ]] ; then
		echo "powerpc-unknown-linux-gnu"
	elif [[ "${CHOST}" =~ "powerpc-" && "${ELIBC}" == "musl" ]] ; then
		echo "powerpc-unknown-linux-musl"

	elif [[ "${CHOST}" =~ "riscv64" && "${CHOST}" =~ "gentoo" && "${ELIBC}" == "glibc" ]] ; then
		echo "riscv64gc-unknown-linux-gnu"
	elif [[ "${CHOST}" =~ "riscv64" && "${CHOST}" =~ "gentoo" && "${ELIBC}" == "musl" ]] ; then
		echo "riscv64gc-unknown-linux-musl"

	elif [[ "${CHOST}" =~ "sparc64-" && "${ELIBC}" == "glibc" ]] ; then
		echo "sparc64-unknown-linux-gnu"

	elif [[ "${ABI}" == "x86" && "${ELIBC}" == "glibc" ]] ; then
		echo "i686-unknown-linux-gnu"
	elif [[ "${ABI}" == "x86" && "${ELIBC}" == "musl" ]] ; then
		echo "i686-unknown-linux-musl"

	fi
}

src_install() {
	einstalldocs
	cargo_src_install
	local rust_chost=$(get_rust_chost)
	cd "${S}/target/${rust_chost}/release" || die
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
