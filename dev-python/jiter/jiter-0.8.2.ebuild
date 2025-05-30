# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="maturin"
PYTHON_COMPAT=( "python3_"{10..12} )

# Generated by "./convert-cargo-lock.sh 0.8.2 0.8.2"
CRATES="
ahash-0.8.11
arbitrary-1.4.1
autocfg-1.4.0
bencher-0.1.5
bitflags-2.9.0
bitvec-1.0.1
cc-1.2.16
cfg-if-1.0.0
codspeed-2.8.1
codspeed-bencher-compat-2.8.1
colored-2.2.0
equivalent-1.0.2
funty-2.0.0
getrandom-0.2.15
getrandom-0.3.1
hashbrown-0.15.2
heck-0.5.0
indexmap-2.7.1
indoc-2.0.6
itoa-1.0.15
jiter-0.8.2
jobserver-0.1.32
lazy_static-1.5.0
lexical-parse-float-0.8.5
lexical-parse-integer-0.8.6
lexical-util-0.8.5
libc-0.2.170
libfuzzer-sys-0.4.9
memchr-2.7.4
memoffset-0.9.1
num-bigint-0.4.6
num-integer-0.1.46
num-traits-0.2.19
once_cell-1.20.3
paste-1.0.15
portable-atomic-1.11.0
proc-macro2-1.0.94
pyo3-0.23.5
pyo3-build-config-0.23.5
pyo3-ffi-0.23.5
pyo3-macros-0.23.5
pyo3-macros-backend-0.23.5
python3-dll-a-0.2.13
quote-1.0.39
radium-0.7.0
ryu-1.0.20
serde-1.0.219
serde_derive-1.0.219
serde_json-1.0.140
shlex-1.3.0
smallvec-1.14.0
static_assertions-1.1.0
syn-2.0.100
tap-1.0.1
target-lexicon-0.12.16
unicode-ident-1.0.18
unindent-0.2.4
uuid-1.15.1
version_check-0.9.5
wasi-0.11.0+wasi-snapshot-preview1
wasi-0.13.3+wasi-0.2.2
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
wit-bindgen-rt-0.33.0
wyz-0.5.1
zerocopy-0.7.35
zerocopy-derive-0.7.35
"

inherit distutils-r1 cargo edo

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
S_PROJECT="${WORKDIR}/${PN}-${PV}"
S_PYTHON="${WORKDIR}/${PN}-${PV}/crates/jiter-python"
SRC_URI="
$(cargo_crate_uris ${CRATES})
https://github.com/pydantic/jiter/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Fast iterable JSON parser"
HOMEPAGE="
	https://github.com/pydantic/jiter
	https://pypi.org/project/jiter
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
RDEPEND+="
	dev-python/orjson[${PYTHON_USEDEP}]
	dev-python/ujson[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-util/maturin[${PYTHON_USEDEP}]
"
DOCS=( "README.md" )

pkg_setup() {
	python_setup
	rust_pkg_setup
}

src_unpack() {
	unpack ${A}
	cp -a \
		"${FILESDIR}/${PV}/Cargo."* \
		"${S}" \
		|| die
	cargo_src_unpack
}

src_prepare() {
	distutils-r1_src_prepare
}

python_configure() {
	:
}

src_configure() {
	cargo_src_configure
	distutils-r1_src_configure
}

python_compile() {
	cargo_src_compile
	pushd "${S_PYTHON}" >/dev/null 2>&1 || die
		edo maturin \
			pep517 \
			build-wheel \
			-i "${PYTHON}" \
			--compatibility off \
			--auditwheel=skip \
			--jobs=1 \
			--offline \
			--manifest-path "${S_PROJECT}/Cargo.toml"

		local d="${WORKDIR}/${PN}-${PV}-${EPYTHON/./_}/install"
		mkdir -p "${d}/usr/bin" || die
		local pyv="${EPYTHON/python/}"
		pyv="${pyv/./}"
		local wheel_path=$(realpath "${S_PROJECT}/target/wheels/${PN}-${PV}-cp${pyv}-cp${pyv}-linux_"*".whl")
		distutils_wheel_install "${d}" \
			"${wheel_path}"
	popd >/dev/null 2>&1 || die
}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
