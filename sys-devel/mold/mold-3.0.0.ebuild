# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

RUST_MAX_VER="1.98.1"
RUST_MIN_VER="1.98.1" # LLVM 22.1
CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted"
RUSTFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted"

MODES=(
	"+security-critical"
	"balanced"
	"performance-critical"
)

MIMALLOC_RUST_COMMIT="3979460494f1cd1e7f936cb8e10f41e927c9f698"
MIMALLOC_V2_COMMIT="02a2f5df9d7d46d30263b83832eebeeab62dc5fe"
MIMALLOC_V3_COMMIT="d4881d338125e1cb7c47ba4cfb398d6f7c0c8d45"

declare -A GIT_CRATES=(
[libmimalloc-sys]="https://github.com/rui314/mimalloc_rust;3979460494f1cd1e7f936cb8e10f41e927c9f698;mimalloc_rust-%commit%/libmimalloc-sys" # 0.1.49
[mimalloc]="https://github.com/rui314/mimalloc_rust;3979460494f1cd1e7f936cb8e10f41e927c9f698;mimalloc_rust-%commit%/" # 0.1.52
)

DISABLED_CRATES="
mold-3.0.0
mold-cli-3.0.0
mold-target-arm32-3.0.0
mold-target-arm32be-3.0.0
mold-target-arm64-3.0.0
mold-target-arm64be-3.0.0
mold-target-i386-3.0.0
mold-target-loongarch32-3.0.0
mold-target-loongarch64-3.0.0
mold-target-m68k-3.0.0
mold-target-ppc32-3.0.0
mold-target-ppc64v1-3.0.0
mold-target-ppc64v2-3.0.0
mold-target-riscv32-3.0.0
mold-target-riscv32be-3.0.0
mold-target-riscv64-3.0.0
mold-target-riscv64be-3.0.0
mold-target-s390x-3.0.0
mold-target-sh4-3.0.0
mold-target-sh4be-3.0.0
mold-target-sparc64-3.0.0
mold-target-x86_64-3.0.0
mold-tests-3.0.0
"

# From "./convert-cargo-lock.sh 3.0.0 3.0.0"
CRATES="
allocator-api2-0.2.21
arrayvec-0.7.8
blake3-1.8.7
bstr-1.13.1
cc-1.9.0
cfg-if-1.0.5
constant_time_eq-0.4.2
cpp_demangle-0.4.5
cpufeatures-0.3.1
crc32fast-1.5.2
crossbeam-deque-0.8.8
crossbeam-epoch-0.9.21
crossbeam-utils-0.8.23
either-1.19.0
equivalent-1.0.3
find-msvc-tools-0.1.15
flate2-1.1.10
foldhash-0.2.0
getrandom-0.4.3
hashbrown-0.17.1
jobserver-0.1.35
libc-0.2.191
libz-sys-1.1.30
memchr-2.8.3
memmap2-0.9.11
pkg-config-0.3.34
portable-atomic-1.15.0
proc-macro2-1.0.107
quote-1.0.47
rayon-1.12.0
rayon-core-1.13.0
r-efi-6.0.0
regex-automata-0.4.18
rustc-demangle-0.1.28
serde_core-1.0.229
serde_derive-1.0.229
shlex-2.0.1
syn-3.0.9
unicode-ident-1.0.27
uuid-1.28.0
vcpkg-0.2.15
xxhash-rust-0.8.19
zstd-0.13.3
zstd-safe-7.3.0
zstd-sys-2.1.2+zstd.1.5.7
"

inherit cargo cflags-hardened dep-prepare lcnr rust rustflags-hardened secure-version toolchain-funcs

if [[ "${PV}" == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/rui314/mold.git"
	inherit git-r3
else
	KEYWORDS="
~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~s390
	"
	SRC_URI="
$(cargo_crate_uris ${CRATES})
https://github.com/rui314/mold/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/microsoft/mimalloc/archive/${MIMALLOC_V2_COMMIT}.tar.gz
	-> mimalloc-v2-${MIMALLOC_V2_COMMIT:0:7}.tar.gz
https://github.com/microsoft/mimalloc/archive/${MIMALLOC_V3_COMMIT}.tar.gz
	-> mimalloc-v3-${MIMALLOC_V3_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="A Modern Linker"
HOMEPAGE="https://github.com/rui314/mold"
LICENSE="
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	Boost-1.0
	BSD
	CC0-1.0
	Info-ZIP
	MIT
	MIT-0
	ZLIB
"
SLOT="0"
# Upstream has mimalloc-secure off and runs it as performance-critical by default (+mimalloc).
# The system-toolchain is system-critical according to AI, so secure mode is enabled by default.
# It is assumed that all code is untrusted if unreviewed.
IUSE="
${MODES[@]}
debug +mimalloc -system-mimalloc -system-tbb test
ebuild_revision_4
"
REQUIRED_USE="
	^^ (
		${MODES[@]/+}
	)
	kernel_Darwin? (
		!mimalloc
	)
	performance-critical? (
		mimalloc
	)
	security-critical? (
		mimalloc
	)
"
RESTRICT="
	mirror
	!test? (
		test
	)
" # Speed up downloads and stop snooping
RDEPEND="
	>=virtual/zlib-${ZLIB_PV}:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
"

pkg_setup() {
	rust_pkg_setup
}

src_unpack() {
	unpack ${A}
	cargo_src_unpack
#	die

	# Add missing vendored submodules
	dep_prepare_mv "${WORKDIR}/mimalloc-${MIMALLOC_V2_COMMIT}" "${WORKDIR}/mimalloc_rust-${MIMALLOC_RUST_COMMIT}/libmimalloc-sys/c_src/mimalloc/v2"
	dep_prepare_mv "${WORKDIR}/mimalloc-${MIMALLOC_V3_COMMIT}" "${WORKDIR}/mimalloc_rust-${MIMALLOC_RUST_COMMIT}/libmimalloc-sys/c_src/mimalloc/v3"

	cp -aT \
		"${FILESDIR}/${PV}"* \
		"${S}" \
		|| die
}

src_prepare() {
	default

	pushd "${WORKDIR}/mimalloc_rust-${MIMALLOC_RUST_COMMIT}" >/dev/null 2>&1 || die
		eapply "${FILESDIR}/mold-3.0.0-mimalloc_rust-changes.patch"
	popd || die

	if use mimalloc ; then
einfo "Memory allocator:  mimalloc"
	else
einfo "Memory allocator:  system"
	fi

	if ! use mimalloc ; then
		:
	elif use security-critical ; then
einfo "mimalloc mode:  security-critical"
		sed -i -e "s|@MIMALLOC_MODE@|security_critical|g" "${S}/cli/Cargo.toml" || die
	elif use balanced ; then
einfo "mimalloc mode:  balanced"
		sed -i -e "s|@MIMALLOC_MODE@|balanced|g" "${S}/cli/Cargo.toml" || die
	else
einfo "mimalloc mode:  performance-critical"
		sed -i -e "s|@MIMALLOC_MODE@|performance_critical|g" "${S}/cli/Cargo.toml" || die
	fi
}

src_configure() {
	export CARGO_TERM_VERBOSE="true"

	if use security-critical ; then
		CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted"
		RUSTFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted"
		cflags-hardened_append
		rustflags-hardened_append
	elif use balanced ; then
		CFLAGS_HARDENED_USE_CASES="sensitive-data untrusted"
		RUSTFLAGS_HARDENED_USE_CASES="sensitive-data untrusted"
		cflags-hardened_append
		rustflags-hardened_append
	fi

	local myfeatures=(
		$(usev !mimalloc system-allocator)
	)
	cargo_src_configure
}

src_test() {
	export \
		TEST_CC="$(tc-getCC)" \
		TEST_CXX="$(tc-getCXX)" \
		TEST_GCC="$(tc-getCC)" \
		TEST_GXX="$(tc-getCXX)"
	cmake_src_test
}

src_compile() {
	cargo_src_compile
}

src_install() {
	dobin "${BUILD_DIR}/${PN}"
	# https://bugs.gentoo.org/872773 \
	insinto "/usr/$(get_libdir)/mold"
	doins "${BUILD_DIR}/${PN}-wrapper.so"
	dodoc "docs/"{"design","execstack"}".md"
	doman "docs/${PN}.1"
	dosym \
		"${PN}" \
		"/usr/bin/ld.${PN}"
	dosym \
		"${PN}" \
		"/usr/bin/ld64.${PN}"
	dosym -r \
		"/usr/bin/${PN}" \
		"/usr/libexec/${PN}/ld"
}

src_install() {
	local configuration="release"
	exeinto "/usr/bin"
	doexe "target/${configuration}/${PN}"
	exeinto "/usr/$(get_libdir)"
	doexe "target/${configuration}/mold-wrapper.so"

	dosym "${PN}" "/usr/bin/ld.${PN}"
	dosym "${PN}" "/usr/bin/ld64.${PN}"
	dosym -r "/usr/bin/${PN}" "/usr/libexec/${PN}/ld"

	dodoc "docs/mold.md"
	doman "docs/mold.1"

	docinto "licenses"
	dodoc "LICENSE"

	LCNR_SOURCE="${WORKDIR}/cargo_home/gentoo"
	LCNR_TAG="third_party"
#	lcnr_install_files
}
