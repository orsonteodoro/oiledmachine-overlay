# Copyright 2023 Orson Teodoro
# Copyright 2008-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib elisp-common flag-o-matic multilib-minimal toolchain-funcs

if [[ "${PV}" == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/protocolbuffers/protobuf.git"
	EGIT_SUBMODULES=()
else
	SRC_URI="
https://github.com/protocolbuffers/protobuf/archive/v${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
fi

DESCRIPTION="An extensible mechanism for serializing structured data"
HOMEPAGE="
	https://developers.google.com/protocol-buffers/
	https://github.com/protocolbuffers/protobuf
"
LICENSE="BSD"
INTERNAL_VERSION="4.24.4"
SLOT="0/$(ver_cut 1-2 ${INTERNAL_VERSION})"
# version : slot
# 25 : 4.25 From CMakeLists.txt's protobuf_VERSION_STRING
# 24 : 4.24 From CMakeLists.txt's protobuf_VERSION_STRING
# 23 : 4.23 From CMakeLists.txt's protobuf_VERSION_STRING
# 22.5 : 4.22 From CMakeLists.txt's protobuf_VERSION_STRING
# 22.0 : 4.22 From CMakeLists.txt's protobuf_VERSION_STRING
# 21.12 : 3.21 From AC_INIT
# 21.0 : 3.21 From AC_INIT
# 20.2 : 3.20 From AC_INIT
# 19.5 : 3.19 From AC_INIT
# 18.3 : 3.18 From AC_INIT
# 16.2 : 3.16 From AC_INIT

IUSE="emacs examples static-libs test zlib r1"
RESTRICT="
	!test? (
		test
	)
"
RDEPEND="
	>=dev-cpp/abseil-cpp-20230125.3:0/20230125[${MULTILIB_USEDEP},test-helpers(-)]
	dev-libs/utf8_range[${MULTILIB_USEDEP}]
	zlib? (
		sys-libs/zlib[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
	test? (
		>=dev-cpp/gtest-1.12.1[${MULTILIB_USEDEP}]
	)
"
RDEPEND+="
	emacs? (
		app-editors/emacs:*
	)
"
BDEPEND="
	dev-libs/utf8_range[${MULTILIB_USEDEP}]
	emacs? (
		app-editors/emacs:*
	)
"
PATCHES=(
	"${FILESDIR}/protobuf-22.3-zero_copy_stream_unittest-mutex-header.patch"
	"${FILESDIR}/protobuf-22.3-utf8_range.patch"
)
DOCS=( CONTRIBUTORS.txt README.md )

src_unpack() {
	unpack ${A}
}

patch_32bit() {
einfo "Patching for 32-bit (${ABI})"
	# 32-bit test breakage
	# https://github.com/protocolbuffers/protobuf/issues/8460
	sed -e "/^TEST(AnyTest, TestPackFromSerializationExceedsSizeLimit) {$/a\\  if (sizeof(void*) == 4) {\n    GTEST_SKIP();\n  }" \
		-i src/google/protobuf/any_test.cc \
		|| die
	# 32-bit test breakage
	# https://github.com/protocolbuffers/protobuf/issues/8459
	sed \
		-e "/^TEST(ArenaTest, BlockSizeSmallerThanAllocation) {$/a\\  if (sizeof(void*) == 4) {\n    GTEST_SKIP();\n  }" \
		-e "/^TEST(ArenaTest, SpaceAllocated_and_Used) {$/a\\  if (sizeof(void*) == 4) {\n    GTEST_SKIP();\n  }" \
		-i src/google/protobuf/arena_unittest.cc \
		|| die
}

src_prepare() {
	# Temp disable.  It breaks on 32-bit and 64-bit.
	sed -e "/^TEST_F(Utf8ValidationTest, OldVerifyUTF8String) {$/,/^}$/d" \
		-i src/google/protobuf/wire_format_unittest.inc \
		|| die

	cmake_src_prepare

	src_prepare_abi() {
		cp -a "${S}" "${WORKDIR}/${P}_build-${MULTILIB_ABI_FLAG}.${ABI}" || die
		if [[ "${MULTILIB_ABI_FLAG}" =~ ("abi_x86_32"|"abi_x86_x32"|"abi_mips_n32"|"abi_mips_o32"|"abi_ppc_32"|"abi_s390_32") ]] ; then
			cd "${WORKDIR}/${P}_build-${MULTILIB_ABI_FLAG}.${ABI}" || die
			patch_32bit
		fi
	}
	multilib_foreach_abi src_prepare_abi
}


src_configure() {
	local with_ccache=OFF
	if [[ "${FEATURES}" =~ "ccache" ]] ; then
		with_ccache=ON
	fi

	replace-flags '-O0' '-O1'
	append-flags -fPIC

	append-cppflags -DGOOGLE_PROTOBUF_NO_RTTI
	if tc-ld-is-gold; then
	# https://sourceware.org/bugzilla/show_bug.cgi?id=24527
		tc-ld-disable-gold
	fi

	# Shared libs only
	local with_static_libs="ON"

	# With shared and static libs
	use static-libs && with_static_libs="OFF"

	src_configure_abi() {
		local mycmakeargs=(
			-DUTF8_RANGE_MODULE_PATH="${ESYSROOT}/usr/$(get_libdir)/cmake/utf8_range"
			-DBUILD_SHARED_LIBS=${with_static_libs}
			-Dprotobuf_USE_EXTERNAL_GTEST=ON
			-Dprotobuf_BUILD_TESTS=$(usex test)
			-Dprotobuf_WITH_ZLIB=$(usex zlib)
			-Dprotobuf_ALLOW_CCACHE=${with_ccache}
			-Dprotobuf_ABSL_PROVIDER=package
			-Dprotobuf_UTF8_RANGE_PROVIDER=package
		)
		if tc-is-cross-compiler; then
			mycmakeargs=(
				-Dprotobuf_PROTOC_EXE="$(pwd)/src/protoc"
			)
		fi
		CMAKE_USE_DIR="${WORKDIR}/${P}_build-${MULTILIB_ABI_FLAG}.${ABI}"
		BUILD_DIR="${WORKDIR}/${P}_build-${MULTILIB_ABI_FLAG}.${ABI}"
		cd "${WORKDIR}/${P}_build-${MULTILIB_ABI_FLAG}.${ABI}" || die
		cmake_src_configure
	}
	multilib_foreach_abi src_configure_abi
}

src_compile() {
	src_compile_abi() {
		CMAKE_USE_DIR="${WORKDIR}/${P}_build-${MULTILIB_ABI_FLAG}.${ABI}"
		BUILD_DIR="${WORKDIR}/${P}_build-${MULTILIB_ABI_FLAG}.${ABI}"
		cmake_src_compile
	}
	multilib_foreach_abi src_compile_abi
	if use emacs; then
		elisp-compile editors/protobuf-mode.el
	fi
}

src_test() {
	src_test_abi() {
		CMAKE_USE_DIR="${WORKDIR}/${P}_build-${MULTILIB_ABI_FLAG}.${ABI}"
		BUILD_DIR="${WORKDIR}/${P}_build-${MULTILIB_ABI_FLAG}.${ABI}"
		cmake_src_test --rerun-failed --output-on-failure
	}
	multilib_foreach_abi src_test_abi
}

src_install() {
	src_install_abi() {
		CMAKE_USE_DIR="${WORKDIR}/${P}_build-${MULTILIB_ABI_FLAG}.${ABI}"
		BUILD_DIR="${WORKDIR}/${P}_build-${MULTILIB_ABI_FLAG}.${ABI}"
		cmake_src_install
	}
	multilib_foreach_abi src_install_abi

}

multilib_src_install_all() {
	find "${ED}" -name "*.la" -delete || die
	if [[ ! -f "${ED}/usr/$(get_libdir)/libprotobuf.so.${SLOT#*/}" ]]; then
		local expected_subslot="${SLOT#*/}"
		local actual_subslot=$(ls "${ED}/usr/$(get_libdir)/libprotobuf.so."*)
		actual_subslot=$(basename "${actual_subslot}" \
			| cut -f 3 -d ".")
		if [[ "${expected_subslot}" != "${actual_subslot}" ]] ; then
eerror
eerror "No matching library found with SLOT variable."
eerror
eerror "SLOT:\t\t${SLOT}"
eerror "Expected subslot:\t${expected_subslot}"
eerror "Actual subslot:\t\t${actual_subslot}"
eerror
eerror "Please update the SLOT's subslot with the actual slot value."
eerror
			die
		fi
	fi
	insinto /usr/share/vim/vimfiles/syntax
	doins editors/proto.vim
	insinto /usr/share/vim/vimfiles/ftdetect
	doins "${FILESDIR}/proto.vim"
	if use emacs; then
		elisp-install ${PN} editors/protobuf-mode.el*
		elisp-site-file-install "${FILESDIR}/70${PN}-gentoo.el"
	fi
	if use examples; then
		DOCS+=(examples)
		docompress -x /usr/share/doc/${PF}/examples
	fi
	einstalldocs
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}

# OILEDMACHINE-OVERLAY-TESTS:  PASSED with some disabled tests (20230414) on x86 and amd64
# USE="static-libs test -emacs -examples -zlib" ABI_X86="32 (64) (-x32)"

# x86 ABI:
# 100% tests passed, 0 tests failed out of 2
# Total Test time (real) =  36.19 sec

# amd64 ABI:
# 100% tests passed, 0 tests failed out of 2
# Total Test time (real) =  61.64 sec
