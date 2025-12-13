# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2008-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This abseil-cpp reference was originally 20230802.1 from protobuf, but gRPC
# requires the same abseil-cpp version used in gRPC to avoid inconsistent header
# signatures during the linking of grpc_cpp_plugin.
ABSEIL_CPP_PV="20240116"

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="HO"
CXX_STANDARD=17 # Originally 14 but 17 is required by gRPC
INTERNAL_VERSION="4.${PV}" # From configure.ac L20

_CXX_STANDARD=(
	"cxx_standard_cxx14"
	"+cxx_standard_cxx17"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

inherit cflags-hardened check-compiler-switch cmake-multilib elisp-common flag-o-matic
inherit libcxx-slot libstdcxx-slot multilib-minimal toolchain-funcs

if [[ "${PV}" == *"9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/protocolbuffers/protobuf.git"
	EGIT_SUBMODULES=()
else
	SRC_URI="
https://github.com/protocolbuffers/protobuf/archive/v${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~amd64-linux ~amd64-macos ~arm64 ~ppc64 ~s390 ~x86"
fi

DESCRIPTION="An extensible mechanism for serializing structured data"
HOMEPAGE="
	https://developers.google.com/protocol-buffers/
	https://github.com/protocolbuffers/protobuf
"
LICENSE="BSD"
RESTRICT="
	!test? (
		test
	)
"
SLOT_MAJOR="${INTERNAL_VERSION%%.*}"
SLOT="${SLOT_MAJOR}/"$(ver_cut "1-2" "${INTERNAL_VERSION}")
# version : slot
# 33 : 6.33 From CMakeLists.txt's protobuf_VERSION_STRING
# 32 : 6.32 From CMakeLists.txt's protobuf_VERSION_STRING
# 31 : 6.31 From CMakeLists.txt's protobuf_VERSION_STRING
# 30 : 6.30 From CMakeLists.txt's protobuf_VERSION_STRING
# 29 : 5.29 From CMakeLists.txt's protobuf_VERSION_STRING
# 28 : 5.28 From CMakeLists.txt's protobuf_VERSION_STRING
# 27 : 5.27 From CMakeLists.txt's protobuf_VERSION_STRING
# 26 : 5.26 From CMakeLists.txt's protobuf_VERSION_STRING
# 25 : 4.25 From CMakeLists.txt's protobuf_VERSION_STRING
# 24 : 4.24 From CMakeLists.txt's protobuf_VERSION_STRING
# 23 : 4.23 From CMakeLists.txt's protobuf_VERSION_STRING
# 22.5 : 4.22 From CMakeLists.txt's protobuf_VERSION_STRING
# 22.0 : 4.22 From CMakeLists.txt's protobuf_VERSION_STRING
# 21.12 : 3.21 From configure.ac's AC_INIT
# 21.0 : 3.21 From configure.ac's AC_INIT
# 20.2 : 3.20 From configure.ac's AC_INIT
# 19.5 : 3.19 From configure.ac's AC_INIT
# 18.3 : 3.18 From configure.ac's AC_INIT
# 16.2 : 3.16 From configure.ac's AC_INIT
# 3.19 : 3.19 From configure.ac's AC_INIT
# 3.12 : 3.12 From configure.ac's AC_INIT

# Upstream defaults to C++14
IUSE="
${_CXX_STANDARD[@]}
emacs examples static-libs test zlib
ebuild_revision_37
"
REQUIRED_USE="
	^^ (
		${_CXX_STANDARD[@]/+}
	)
"
# cxx17 is forced for gRPC
RDEPEND="
	!dev-libs/protobuf:0
	dev-cpp/abseil-cpp:${ABSEIL_CPP_PV}[cxx_standard_cxx14?,cxx_standard_cxx17?]
	dev-cpp/abseil-cpp:=
	zlib? (
		>=sys-libs/zlib-1.2.13[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
	test? (
		>=dev-cpp/gtest-1.12.1[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
	)
"
RDEPEND+="
	emacs? (
		app-editors/emacs:*
	)
"
BDEPEND="
	dev-util/patchelf
	emacs? (
		app-editors/emacs:*
	)
"
PATCHES=(
#	"${FILESDIR}/${PN}-3.19.0-disable_no-warning-test.patch"
#	"${FILESDIR}/${PN}-3.19.0-system_libraries.patch"
#	"${FILESDIR}/${PN}-3.20.2-protoc_input_output_files.patch"
#	"${FILESDIR}/${PN}-21.9-disable-32-bit-tests.patch"
)
DOCS=( "CONTRIBUTORS.txt" "README.md" )

pkg_setup() {
	check-compiler-switch_start
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	unpack ${A}
}

patch_32bit() {
einfo "Patching for 32-bit (${ABI})"
	# 32-bit test breakage
	# https://github.com/protocolbuffers/protobuf/issues/8460
	sed -e "/^TEST(AnyTest, TestPackFromSerializationExceedsSizeLimit) {$/a\\  if (sizeof(void*) == 4) {\n    GTEST_SKIP();\n  }" \
		-i "src/google/protobuf/any_test.cc" \
		|| die
	# 32-bit test breakage
	# https://github.com/protocolbuffers/protobuf/issues/8459
	sed \
		-e "/^TEST(ArenaTest, BlockSizeSmallerThanAllocation) {$/a\\  if (sizeof(void*) == 4) {\n    GTEST_SKIP();\n  }" \
		-e "/^TEST(ArenaTest, SpaceAllocated_and_Used) {$/a\\  if (sizeof(void*) == 4) {\n    GTEST_SKIP();\n  }" \
		-i "src/google/protobuf/arena_unittest.cc" \
		|| die
}

src_prepare() {
	# Temp disable.  It breaks on 32-bit and 64-bit.
	sed -e "/^TEST_F(Utf8ValidationTest, OldVerifyUTF8String) {$/,/^}$/d" \
		-i "src/google/protobuf/wire_format_unittest.inc" \
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
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	local with_ccache=OFF
	if [[ "${FEATURES}" =~ "ccache" ]] ; then
		with_ccache=ON
	fi

	# Prevent ICE
#src/google/protobuf/repeated_ptr_field.h:1571:13: internal compiler error: Segmentation fault
# 1571 |   iterator& operator++() {
#      |             ^~~~~~~~
	replace-flags '-O0' '-O1'
	append-flags -fPIC

	append-cppflags -DGOOGLE_PROTOBUF_NO_RTTI
	if tc-ld-is-gold; then
	# https://sourceware.org/bugzilla/show_bug.cgi?id=24527
		tc-ld-disable-gold
	fi
	cflags-hardened_append

	# Shared libs only
	local with_static_libs="ON"

	# With shared and static libs
	use static-libs && with_static_libs="OFF"

	use cxx_standard_cxx14 && append-cxxflags -std=c++14
	use cxx_standard_cxx17 && append-cxxflags -std=c++17

	src_configure_abi() {
		[[ -e "${ESYSROOT}/usr/lib/abseil-cpp/${ABSEIL_CPP_PV%%.*}/$(get_libdir)/cmake/absl" ]] || die "Missing"

		local mycmakeargs=(
			$(usex cxx_standard_cxx14 '-DCMAKE_CXX_STANDARD=14' '') # Default
			$(usex cxx_standard_cxx17 '-DCMAKE_CXX_STANDARD=17' '') # For gRPC
			-Dabsl_DIR="${ESYSROOT}/usr/lib/abseil-cpp/${ABSEIL_CPP_PV}/$(get_libdir)/cmake/absl"
			-DBUILD_SHARED_LIBS=${with_static_libs}
			-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/${PN}/${SLOT_MAJOR}"
			-Dprotobuf_USE_EXTERNAL_GTEST=ON
			-Dprotobuf_BUILD_TESTS=$(usex test)
			-Dprotobuf_WITH_ZLIB=$(usex zlib)
			-Dprotobuf_ALLOW_CCACHE=${with_ccache}
			-Dprotobuf_ABSL_PROVIDER=package
			-Dprotobuf_UTF8_RANGE_PROVIDER=package
			-DUTF8_RANGE_MODULE_PATH="${ESYSROOT}/usr/$(get_libdir)/cmake/utf8_range"
		)
		if tc-is-cross-compiler ; then
			mycmakeargs+=(
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
		elisp-compile "editors/protobuf-mode.el"
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
	_install_all
}

_install_all() {
	find "${ED}" -name "*.la" -delete || die
	local prefix="/usr/lib/protobuf/${SLOT_MAJOR}"
	insinto "${prefix}/share/vim/vimfiles/syntax"
	doins "editors/proto.vim"
	insinto "${prefix}/share/vim/vimfiles/ftdetect"
	doins "${FILESDIR}/proto.vim"
	if use emacs; then
		elisp-install "${PN}" "editors/protobuf-mode.el"*
		elisp-site-file-install "${FILESDIR}/70${PN}-gentoo.el"
	fi
	if use examples; then
		DOCS+=(examples)
		docompress -x "${prefix}/share/doc/${PF}/examples"
	fi
	einstalldocs

	local L=(
		"/usr/lib/protobuf/${SLOT_MAJOR}/bin/protoc-${PV}.0"
	)
	local x
	for x in "${L[@]}" ; do
		local d="/usr/lib/abseil-cpp/${ABSEIL_CPP_PV}/$(get_libdir)"
		[[ -e "${d}" ]] || die
einfo "Adding ${d} to RPATH for ${ED}/${x}"
		patchelf \
			--add-rpath "${d}" \
			"${ED}/${x}" \
			|| die
	done
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}

# OILEDMACHINE-OVERLAY-TESTS:  21.12 (20231021) PASSED test suite with some disabled tests on x86 and amd64
# OILEDMACHINE-OVERLAY-TESTS:  29.5 (20251021) PASSED test suite with some disabled tests on x86 and amd64
# OILEDMACHINE-OVERLAY-TESTS:  33.0 (20251019) PASSED test suite with some disabled tests on x86 and amd64
# USE="static-libs test -emacs -examples -zlib" ABI_X86="32 (64) (-x32)"

# x86 ABI:
# 100% tests passed, 0 tests failed out of 2
# Total Test time (real) =  36.19 sec

# amd64 ABI:
# 100% tests passed, 0 tests failed out of 2
# Total Test time (real) =  61.64 sec
