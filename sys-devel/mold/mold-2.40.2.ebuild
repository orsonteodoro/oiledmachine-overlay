# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

inherit cmake toolchain-funcs

if [[ "${PV}" == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/rui314/mold.git"
	inherit git-r3
else
	KEYWORDS="
~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~s390
	"
	SRC_URI="
https://github.com/rui314/mold/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A Modern Linker"
HOMEPAGE="https://github.com/rui314/mold"
LICENSE="
	BSD-2
	CC0-1.0
	MIT
"
# mold (MIT)
#  - xxhash (BSD-2)
#  - siphash ( MIT CC0-1.0 )
SLOT="0"
IUSE="debug test"
RESTRICT="
	!test? (
		test
	)
"
RDEPEND="
	>=app-arch/zstd-1.5.7
	app-arch/zstd:=
	>=dev-cpp/tbb-2022.0.0:0
	dev-cpp/tbb:=
	>=dev-libs/blake3-1.6.1
	dev-libs/blake3:=
	>=sys-libs/zlib-1.3
	sys-libs/zlib:=
	!kernel_Darwin? (
		>=dev-libs/mimalloc-2.2.2
		dev-libs/mimalloc:=
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? (
		>=dev-libs/mimalloc-2.2.2
		dev-libs/mimalloc:=
	)
"

pkg_pretend() {
	# Requires a c++20 compiler, see #831473
	if [[ "${MERGE_TYPE}" != "binary" ]]; then
		if tc-is-gcc && [[ $(gcc-major-version) -lt "10" ]]; then
			die "${PN} needs at least gcc 10"
		elif tc-is-clang && [[ $(clang-major-version) -lt "12" ]]; then
			die "${PN} needs at least clang 12"
		fi
	fi
}

src_prepare() {
	cmake_src_prepare

	local L=(
	# Needs unpackaged dwarfdump
		"test/compress-debug-sections.sh"
		"test/compressed-debug-info.sh"
		"test/dead-debug-sections.sh"

	# Heavy tests, need qemu
		"test/gdb-index-compress-output.sh"
		"test/gdb-index-dwarf2.sh"
		"test/gdb-index-dwarf3.sh"
		"test/gdb-index-dwarf4.sh"
		"test/gdb-index-dwarf5.sh"
		"test/lto-archive.sh"
		"test/lto-dso.sh"
		"test/lto-gcc.sh"
		"test/lto-llvm.sh"
		"test/lto-version-script.sh"

	# Fails if binutils errors out on textrels by default
		"test/textrel.sh"
		"test/textrel2.sh"

	# static-pie tests require glibc built with static-pie support
		""
	)


	# static-pie tests require glibc built with static-pie support
	if ! has_version -d 'sys-libs/glibc[static-pie(+)]' ; then
		L+=(
			rm "test/static-pie.sh"
			rm "test/ifunc-static-pie.sh"
		)
	fi

	local x
	for x in ${L[@]} ; do
		rm "${x}" || die
	done
}

src_configure() {
	use debug || append-cppflags "-DNDEBUG"
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DMOLD_LTO=OFF # Should be up to the user to decide this with CXXFLAGS.
		-DMOLD_USE_MIMALLOC=$(usex !kernel_Darwin)
		-DMOLD_USE_SYSTEM_MIMALLOC=ON
		-DMOLD_USE_SYSTEM_TBB=ON
		-DTBB_DIR="${ESYSROOT}/usr/$(get_libdir)/cmake/TBB"
	)

	if use test ; then
		mycmakeargs+=(
			-DMOLD_ENABLE_QEMU_TESTS=OFF
		)
	fi

	cmake_src_configure
}

src_test() {
	export \
		TEST_CC="$(tc-getCC)" \
		TEST_CXX="$(tc-getCXX)" \
		TEST_GCC="$(tc-getCC)" \
		TEST_GXX="$(tc-getCXX)"
	cmake_src_test
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

src_test() {
	export \
		TEST_CC="$(tc-getCC)" \
		TEST_GCC="$(tc-getCC)" \
		TEST_CXX="$(tc-getCXX)" \
		TEST_GXX="$(tc-getCXX)"
	cmake_src_test
}
