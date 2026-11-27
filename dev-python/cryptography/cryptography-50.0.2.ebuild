# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="crypto security-critical sensitive-data untrusted-data"
RUSTFLAGS_HARDENED_USE_CASES="crypto security-critical sensitive-data untrusted-data"

CARGO_OPTIONAL="yes"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="maturin"
PYPI_VERIFY_REPO="https://github.com/pyca/cryptography"
PYTHON_COMPAT=( "python3_"{10..15} "pypy3_11" )
PYTHON_REQ_USE="threads(+)"

inherit secure-version

RUST_MAX_VER="${RUST_LLVM_LIVE_PV}"
RUST_MIN_VER="${RUST_LLVM_LIVE_PV}"

# Misnomer
DISABLED_CRATES="
cryptography-cffi-0.50.2
cryptography-crypto-0.50.2
cryptography-keepalive-0.50.2
cryptography-key-parsing-0.50.2
cryptography-openssl-0.50.2
cryptography-rust-0.50.2
cryptography-x509-0.50.2
cryptography-x509-verification-0.50.2
"

CRATES="
asn1-0.24.2
asn1_derive-0.24.2
base64-0.23.1
bitflags-2.13.2
cc-1.12.0
cfg-if-1.0.5
find-msvc-tools-0.1.16
foreign-types-0.3.2
foreign-types-shared-0.1.1
heck-0.5.0
itoa-1.0.19
libc-0.2.191
once_cell-1.21.4
openssl-0.10.82
openssl-macros-0.1.1
openssl-sys-0.9.118
pem-4.0.0
pkg-config-0.3.34
portable-atomic-1.15.0
proc-macro2-1.0.107
pyo3-0.29.3
pyo3-build-config-0.29.3
pyo3-ffi-0.29.3
pyo3-macros-0.29.3
pyo3-macros-backend-0.29.3
quote-1.0.47
self_cell-1.3.0
shlex-2.0.1
syn-2.0.119
syn-3.0.10
target-lexicon-0.13.6
unicode-ident-1.0.27
vcpkg-0.2.15
"

CHKL_TIMESTAMPS=(
	"dev-libs/openssl-4.0.9999"
	"dev-libs/openssl-3.6.9999"
	"dev-libs/openssl-3.5.9999"
)

inherit cargo cflags-hardened chkl distutils-r1 flag-o-matic pypi
inherit rustflags-hardened secure-version secure-version-python

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
IUSE+=" ebuild_revision_4"
RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/cffi-'${PYTHON_CFFI_PV}':=[${PYTHON_USEDEP}]
	' python3_{10..14})
	$(secure-version_gen_openssl_depends)
"
DEPEND="
	${RDEPEND}
"

BDEPEND="
	${RUST_DEPEND}
	$(python_gen_cond_dep '
		>=dev-python/cffi-'${PYTHON_CFFI_PV}'[${PYTHON_USEDEP}]
	' python3_{10..15})
	>=dev-util/maturin-1.14.1[${PYTHON_USEDEP}]
	<dev-util/maturin-2[${PYTHON_USEDEP}]
	!~dev-python/setuptools-74.0.0[${PYTHON_USEDEP}]
	!~dev-python/setuptools-74.1.0[${PYTHON_USEDEP}]
	!~dev-python/setuptools-74.1.2[${PYTHON_USEDEP}]
	test? (
		>=dev-python/certifi-${PYTHON_CERTIFI_PV}[${PYTHON_USEDEP}]
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

verify_rust_nightly() {
	local is_nightly=$("${RUSTC}" --version | grep -q "nightly")
	is_nightly=$(( "${?}" == 0 ? 1 : 0 ))

	if (( ${is_nightly} == 0 )) ; then
eerror "Only nightly Rust is currently supported."
eerror "Switch to live with \`eselect rust\`"
		die
	fi

	if "${RUSTC}" --version | grep -q -e "nightly" ; then
		local compatible_time=$(date --date="${RUST_LLVM_LIVE_TIMESTAMP}" "+%s")

		local merge_time
		local pkg_name
		if [[ "${RUSTC}" =~ "rust-bin" ]] ; then
			pkg_name="rust-bin"
			merge_time=$(cat "/var/db/pkg/dev-lang/rust-bin-9999/BUILD_TIME")
		else
			pkg_name="rust"
			merge_time=$(cat "/var/db/pkg/dev-lang/rust-9999/BUILD_TIME")
		fi
		if (( ${merge_time} < ${compatible_time} )) ; then
eerror
eerror "Detected old live timestamp."
eerror "Re-emerge ${pkg_name} or switch to Rust ${RUST_LLVM_LIVE_INTERNAL_VERSION} or later."
eerror
eerror "Current timestamp:  "$(date --date="@${merge_time}")
eerror "Expected timestamp:  >= "$(date --date="@${compatible_time}")
eerror
			die
		fi
	else
		local actual_pv=$("${RUSTC}" --version | cut -f 2 -d " ")
		if ver_test "${actual_pv}" "-lt" "${RUST_MIN_VER}" ; then
eerror "Switch Rust to >= ${RUST_MIN_VER}"
			die
		fi
	fi
}

pkg_setup() {
	python_setup
	rust_pkg_setup
	verify_rust_nightly
}

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
	cflags-hardened_append		# For *-sys crates
	rustflags-hardened_append
	filter-lto # bug #903908
}

python_test() {
	local -x PYTHONPATH="${PYTHONPATH}:${WORKDIR}/${VEC_P}"
	local EPYTEST_IGNORE=(
		"tests/bench"
	)
	epytest
}
