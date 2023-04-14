# Copyright 2008-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib elisp-common flag-o-matic multilib-minimal toolchain-funcs

if [[ "${PV}" == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/protocolbuffers/protobuf.git"
	EGIT_SUBMODULES=()
else
	EGIT_ABSEIL_CPP_COMMIT="78be63686ba732b25052be15f8d6dee891c05749"
	SRC_URI="
https://github.com/protocolbuffers/protobuf/archive/v${PV}.tar.gz -> ${P}.tar.gz
https://github.com/abseil/abseil-cpp/archive/${EGIT_ABSEIL_CPP_COMMIT}.tar.gz
	-> abseil-cpp-${EGIT_ABSEIL_CPP_COMMIT:0:7}.tar.gz
	"
	# KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos" # Test failure, merge conflict
fi

DESCRIPTION="Google's Protocol Buffers - Extensible mechanism for serializing structured data"
HOMEPAGE="
	https://developers.google.com/protocol-buffers/
	https://github.com/protocolbuffers/protobuf
"
LICENSE="BSD"
SLOT="0/22" # Based on highest .so file
IUSE="emacs examples static-libs test zlib"
RESTRICT="!test? ( test )"
ABSEIL_CPP_PV="20230125"
DEPEND="
	=dev-cpp/abseil-cpp-${ABSEIL_CPP_PV}*[${MULTILIB_USEDEP},test-helpers]
	dev-libs/utf8_range[${MULTILIB_USEDEP}]
	test? (
		>=dev-cpp/gtest-1.9[${MULTILIB_USEDEP}]
	)
	zlib? (
		sys-libs/zlib[${MULTILIB_USEDEP}]
	)
"
RDEPEND="
	=dev-cpp/abseil-cpp-${ABSEIL_CPP_PV}*[${MULTILIB_USEDEP},test-helpers]
	dev-libs/utf8_range[${MULTILIB_USEDEP}]
	emacs? (
		app-editors/emacs:*
	)
	zlib? (
		sys-libs/zlib[${MULTILIB_USEDEP}]
	)
"
# Abseil 20230125.rc3
BDEPEND="
	dev-libs/utf8_range[${MULTILIB_USEDEP}]
	emacs? (
		app-editors/emacs:*
	)
"
PATCHES=(
#	"A${FILESDIR}/${PN}-3.19.0-disable_no-warning-test.patch"
#	"A${FILESDIR}/${PN}-3.19.0-system_libraries.patch"
#	"${FILESDIR}/${PN}-3.20.2-protoc_input_output_files.patch"
#	"A${FILESDIR}/${PN}-21.9-disable-32-bit-tests.patch"
	"${FILESDIR}/protobuf-22.3-zero_copy_stream_unittest-mutex-header.patch"
	"${FILESDIR}/protobuf-22.3-utf8_range.patch"
)
DOCS=( CONTRIBUTORS.txt README.md )

get_build_type() {
	echo "shared-libs"
	use static-libs && echo "static-libs"
}

src_unpack() {
	unpack ${A}
	if ! [[ "${PV}" == *9999 ]]; then
		rm -rf "${S}/third_party/abseil-cpp"
		mv \
			"abseil-cpp-${EGIT_ABSEIL_CPP_COMMIT}" \
			"${S}/third_party/abseil-cpp" \
			|| die
	fi
}

src_prepare() {
	cmake_src_prepare
}

src_configure_abi() {
	local mycmakeargs=(
		-DUTF8_RANGE_MODULE_PATH="${ESYSROOT}/usr/$(get_libdir)/cmake/utf8_range"
		-DBUILD_SHARED_LIBS=ON
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
	cmake_src_configure
}

src_configure() {
	local with_ccache=OFF
	if [[ "${FEATURES}" =~ "ccache" ]] ; then
		with_ccache=ON
	fi
	append-cppflags -DGOOGLE_PROTOBUF_NO_RTTI
	if tc-ld-is-gold; then
	# https://sourceware.org/bugzilla/show_bug.cgi?id=24527
		tc-ld-disable-gold
	fi
	multilib_foreach_abi src_configure_abi
}

src_compile() {
	cmake-multilib_src_compile
	if use emacs; then
		elisp-compile editors/protobuf-mode.el
	fi
}

multilib_src_install_all() {
	find "${ED}" -name "*.la" -delete || die
	if [[ ! -f "${ED}/usr/$(get_libdir)/libprotobuf.so.${SLOT#*/}" ]]; then
		local expected_slot="${SLOT#*/}"
		local actual_slot=$(ls "${ED}/usr/$(get_libdir)/libprotobuf.so."*)
		actual_slot=$(basename "${actual_slot}" \
			| cut -f 3 -d ".")
		if [[ "${expected_slot}" != "${actual_slot}" ]] ; then
eerror
eerror "No matching library found with SLOT variable, currently set: ${SLOT}"
eerror
eerror "Expected slot:\t${expected_slot}"
eerror "Actual slot:\t\t${actual_slot}"
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

# OILEDMACHINE-OVERLAY-TESTS:  
