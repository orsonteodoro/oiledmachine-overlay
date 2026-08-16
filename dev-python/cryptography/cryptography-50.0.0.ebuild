# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUSTFLAGS_HARDENED_USE_CASES="crypto security-critical sensitive-data untrusted-data"

CARGO_OPTIONAL="yes"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="maturin"
PYPI_VERIFY_REPO="https://github.com/pyca/cryptography"
PYTHON_COMPAT=( "python3_"{10..14} "pypy3_11" )
PYTHON_REQ_USE="threads(+)"

RUST_MAX_VER="1.93.1"
RUST_MIN_VER="1.93.1" # LLVM 21.1

# Misnomer
DISABLED_CRATES="
cryptography-cffi-0.50.0
cryptography-crypto-0.50.0
cryptography-keepalive-0.50.0
cryptography-key-parsing-0.50.0
cryptography-openssl-0.50.0
cryptography-rust-0.50.0
cryptography-x509-0.50.0
cryptography-x509-verification-0.50.0
"

CRATES="
asn1-0.24.1
asn1_derive-0.24.1
base64-0.23.1
bitflags-2.13.1
cc-1.4.3
cfg-if-1.0.4
find-msvc-tools-0.1.11
foreign-types-0.3.2
foreign-types-shared-0.1.1
heck-0.5.0
itoa-1.0.18
libc-0.2.189
once_cell-1.21.4
openssl-0.10.81
openssl-macros-0.1.1
openssl-sys-0.9.117
pem-4.0.0
pkg-config-0.3.34
portable-atomic-1.15.0
proc-macro2-1.0.107
pyo3-0.29.2
pyo3-build-config-0.29.2
pyo3-ffi-0.29.2
pyo3-macros-0.29.2
pyo3-macros-backend-0.29.2
quote-1.0.47
self_cell-1.3.0
shlex-2.0.1
syn-2.0.119
target-lexicon-0.13.5
unicode-ident-1.0.24
vcpkg-0.2.15
"

CHKL_TIMESTAMPS=(
	"dev-libs/openssl-4.0.9999"
	"dev-libs/openssl-3.6.9999"
	"dev-libs/openssl-3.5.9999"
	"dev-libs/openssl-3.4.9999"
	"dev-libs/openssl-3.0.9999"
)

inherit cargo chkl distutils-r1 flag-o-matic pypi rustflags-hardened secure-version

VEC_P=cryptography_vectors-$(ver_cut 1-3)
DESCRIPTION="Library providing cryptographic recipes and primitives"
HOMEPAGE="
	https://github.com/pyca/cryptography/
	https://pypi.org/project/cryptography/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
	test? (
		$(pypi_sdist_url cryptography_vectors "$(ver_cut 1-3)")
		$(pypi_provenance_url "${VEC_P}.tar.gz" cryptography_vectors "$(ver_cut 1-3)")
			-> ${VEC_P}.tar.gz.provenance
	)
"

LICENSE="
	|| (
		Apache-2.0
		BSD
	)
	PSF-2
"
# Dependent crate licenses
LICENSE+="
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	BSD
	MIT
	Unicode-3.0
"
RESTRICT="mirror" # Speed up and prevent snooping
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE+=" ebuild_revision_2"
RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/cffi-2.0.0:=[${PYTHON_USEDEP}]
	' python3_{10..14})
	$(secure-version_gen_openssl_depends)
"
DEPEND="
	${RDEPEND}
"

BDEPEND="
	${RUST_DEPEND}
	$(python_gen_cond_dep '
		>=dev-python/cffi-2.0.0[${PYTHON_USEDEP}]
	' python3_{10..14})
	$(python_gen_cond_dep '
		>=dev-python/cffi-2.1[${PYTHON_USEDEP}]
	' python3_15)
	>=dev-util/maturin-1.14.1[${PYTHON_USEDEP}]
	<dev-util/maturin-2[${PYTHON_USEDEP}]
	!~dev-python/setuptools-74.0.0[${PYTHON_USEDEP}]
	!~dev-python/setuptools-74.1.0[${PYTHON_USEDEP}]
	!~dev-python/setuptools-74.1.2[${PYTHON_USEDEP}]
	test? (
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/iso8601[${PYTHON_USEDEP}]
		dev-python/pretend[${PYTHON_USEDEP}]
		dev-python/pyasn1-modules[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

# Files built without CFLAGS/LDFLAGS, acceptable for rust
QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/cryptography/hazmat/bindings/_rust.*.so"

EPYTEST_PLUGINS=( "hypothesis" "pytest-subtests" )
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_unpack() {
	if use verify-provenance; then
		pypi_verify_provenance "${DISTDIR}/${P}.tar.gz"{,.provenance}
		use test && pypi_verify_provenance "${DISTDIR}/${VEC_P}.tar.gz"{,.provenance}
	fi

	cargo_src_unpack
	#die
	cp -aT \
		"${FILESDIR}/${PV}"* \
		"${S}" \
		|| die
}

src_prepare() {
	distutils-r1_src_prepare

	sed -i -e 's:--benchmark-disable::' pyproject.toml || die

	# work around availability macros not supported in GCC (yet)
	if [[ ${CHOST} == *-darwin* ]] ; then
		local darwinok=0
		if [[ ${CHOST##*-darwin} -ge 16 ]] ; then
			darwinok=1
		fi
		sed -i -e 's/__builtin_available(macOS 10\.12, \*)/'"${darwinok}"'/' \
			src/_cffi_src/openssl/src/osrandom_engine.c || die
	fi
}

python_configure_all() {
	chkl_check_many_timestamps
	filter-lto # bug #903908
	rustflags-hardened_append
}

python_test() {
	local -x PYTHONPATH="${PYTHONPATH}:${WORKDIR}/${VEC_P}"
	local EPYTEST_IGNORE=(
		tests/bench
	)
	epytest
}
