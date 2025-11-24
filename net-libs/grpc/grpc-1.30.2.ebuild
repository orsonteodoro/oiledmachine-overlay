# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# For versioning, see
# https://github.com/grpc/grpc/blob/master/doc/g_stands_for.md
# https://grpc.io/docs/what-is-grpc/faq/#how-long-are-grpc-releases-supported-for

# For supported java versions, see
# https://github.com/grpc/grpc-java/blob/v1.30.2/.github/workflows/testing.yml#L20

# For supported python versions, see
# https://github.com/grpc/grpc/blob/v1.30.2/setup.py#L100

# For supported ruby versions, see
# https://github.com/grpc/grpc/blob/v1.30.2/Rakefile#L147

MY_PV="${PV//_pre/-pre}"

ABSEIL_CPP_PV="20200225.0"
CFLAGS_HARDENED_ASSEMBLERS="inline nasm"
CFLAGS_HARDENED_BUILDFILES_SANITIZERS="asan msan tsan ubsan"
CFLAGS_HARDENED_LANGS="asm c-lang cxx"
CFLAGS_HARDENED_USE_CASES="network untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="DOS HO OOBW PE"
CXX_STANDARD=17 # Originally 11
PROTOBUF_SLOT="3"
PYTHON_COMPAT=( "python3_"{10..11} )
RUBY_OPTIONAL="yes"
USE_RUBY="ruby32"

_CXX_STANDARD=(
	"cxx_standard_cxx11"
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

inherit cflags-hardened cmake flag-o-matic libcxx-slot libstdcxx-slot multilib-minimal python-r1 ruby-ng

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${MY_PV}"
SRC_URI="
https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Modern open source high performance RPC framework"
HOMEPAGE="https://www.grpc.io"
LICENSE="
	Apache-2.0
	BSD
	BSD-2
	GPL-2
	GPL-2+
	MIT
	MPL-2.0
	Unlicense
"
# BSD third_party/address_sorting/LICENSE
# BSD third_party/upb/LICENSE
# GPL-2 third_party/xxhash/tests/bench/LICENSE
# BSD-2 GPL-2 third_party/xxhash/LICENSE
# MIT third_party/upb/third_party/lunit/LICENSE
# Unlicense third_party/upb/third_party/wyhash/LICENSE
# LSRT - language specific runtime
# Upstream enables all LSRT
LSRT_IUSE=(
	csharp
	csharpext
	cxx
	java
	nodejs
	objc
	php
	python
	ruby
)
IUSE+="
${_CXX_STANDARD[@]}
${LSRT_IUSE[@]/#/-}
cxx doc examples test
ebuild_revision_35
"
REQUIRED_USE+="
	^^ (
		${_CXX_STANDARD[@]/+}
	)
	python? (
		${PYTHON_REQUIRED_USE}
	)
"
RESTRICT="test"
SLOT_MAJ="${PROTOBUF_SLOT}"
SLOT="${SLOT_MAJ}/1.30"
# third_party last update: 20200529
RDEPEND+="
	>=dev-cpp/abseil-cpp-${ABSEIL_CPP_PV}:${ABSEIL_CPP_PV%%.*}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP},cxx_standard_cxx11?,cxx_standard_cxx14?,cxx_standard_cxx17?]
	dev-cpp/abseil-cpp:=
	>=dev-libs/openssl-1.1.0g:0[-bindist(-),${MULTILIB_USEDEP}]
	dev-libs/openssl:=
	dev-libs/protobuf:${PROTOBUF_SLOT}/3.12[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP},cxx_standard_cxx11?,cxx_standard_cxx14?,cxx_standard_cxx17?]
	dev-libs/protobuf:=
	>=net-dns/c-ares-1.15.0[${MULTILIB_USEDEP}]
	net-dns/c-ares:=
	>=sys-libs/zlib-1.2.11[${MULTILIB_USEDEP}]
	sys-libs/zlib:=
"
# See also
# third_party/boringssl-with-bazel/src/include/openssl/crypto.h: OPENSSL_VERSION_TEXT
# third_party/boringssl-with-bazel/src/include/openssl/base.h: OPENSSL_VERSION_NUMBER
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.5.1
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	test? (
		>=dev-cpp/benchmark-1.5.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
"
PDEPEND_DISABLE="
	csharp? (
		=dev-dotnet/grpc-dotnet-$(($(ver_cut 1 ${PV})+1)).$(ver_cut 2 ${PV})*
	)
"
PDEPEND+="
	java? (
		=dev-java/grpc-java-${PV%%.*}*
		dev-java/grpc-java:=
		|| (
			(
				virtual/jdk:1.8
				virtual/jre:1.8
			)
		)
	)
	php? (
		~dev-php/grpc-${PV}
		dev-php/grpc:=
	)
	python? (
		~dev-python/grpcio-${PV}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${PYTHON_USEDEP}]
		dev-python/grpcio:=
	)
	ruby? (
		ruby_targets_ruby32? (
			dev-lang/ruby:3.2
			~dev-ruby/grpc-${PV}[ruby_targets_ruby32?]
			dev-ruby/grpc:=
		)
	)
"
DOCS=( "AUTHORS" "CONCEPTS.md" "README.md" "TROUBLESHOOTING.md" "doc/". )

pkg_setup() {
	python_setup
	if use ruby ; then
		ruby-ng_pkg_setup
	fi
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	unpack ${A}
}

src_prepare() {
	cmake_src_prepare
	prepare_abi() {
		export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
		export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_build"
		cp -a "${S}" "${S}-${MULTILIB_ABI_FLAG}.${ABI}" || die
		cd "${CMAKE_USE_DIR}" || die
		# un-hardcode libdir
		sed -i "s@lib/pkgconfig@$(get_libdir)/pkgconfig@" \
			CMakeLists.txt || die
		sed -i "s@/lib@/$(get_libdir)@" \
			cmake/pkg-config-template.pc.in || die
	}
	multilib_foreach_abi prepare_abi
}

src_configure() {
	append-flags -I"${ESYSROOT}/usr/lib/protobuf/${PROTOBUF_SLOT}/include"
	export PATH="${ED}/usr/lib/protobuf/${PROTOBUF_SLOT}/bin:${PATH}"
	cflags-hardened_append
	filter-flags -Wl,--as-needed
	use php && export EXTRA_DEFINES=GRPC_POSIX_FORK_ALLOW_PTHREAD_ATFORK
	configure_abi() {
		export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
		export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_build"
		cd "${CMAKE_USE_DIR}" || die
		local mycmakeargs=(
			$(usex cxx_standard_cxx11 '-DCMAKE_CXX_STANDARD=11' '') # Package default
			$(usex cxx_standard_cxx14 '-DCMAKE_CXX_STANDARD=14' '')
			$(usex cxx_standard_cxx17 '-DCMAKE_CXX_STANDARD=17' '') # Required by bear
			-Dabsl_DIR="${ESYSROOT}/usr/lib/abseil-cpp/${ABSEIL_CPP_PV%%.*}/$(get_libdir)/cmake/absl"
			-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/${PN}/${SLOT_MAJ}"
			-DgRPC_INSTALL=ON
			-DgRPC_ABSL_PROVIDER=package
			-DgRPC_BACKWARDS_COMPATIBILITY_MODE=OFF
			-DgRPC_BUILD_GRPC_CPP_PLUGIN=$(usex cxx)
			-DgRPC_BUILD_GRPC_CSHARP_PLUGIN=$(usex csharp)
			-DgRPC_BUILD_GRPC_NODE_PLUGIN=$(usex nodejs)
			-DgRPC_BUILD_GRPC_OBJECTIVE_C_PLUGIN=$(usex objc)
			-DgRPC_BUILD_GRPC_PHP_PLUGIN=$(usex php)
			-DgRPC_BUILD_GRPC_PYTHON_PLUGIN=$(usex python)
			-DgRPC_BUILD_GRPC_RUBY_PLUGIN=$(usex ruby)
			-DgRPC_BUILD_CSHARP_EXT=$(usex csharpext)
			-DgRPC_CARES_PROVIDER=package
			-DgRPC_INSTALL_CMAKEDIR="$(get_libdir)/cmake/${PN}"
			-DgRPC_INSTALL_LIBDIR="$(get_libdir)"
			-DgRPC_PROTOBUF_PROVIDER=package
			-DgRPC_RE2_PROVIDER=package
			-DgRPC_SSL_PROVIDER=package
			-DgRPC_ZLIB_PROVIDER=package
			-DgRPC_BUILD_TESTS=$(usex test)
			-DProtobuf_DIR="${ESYSROOT}/usr/lib/protobuf/${PROTOBUF_SLOT}/$(get_libdir)/cmake/protobuf"
			-DProtobuf_INCLUDE_DIR="${ESYSROOT}/usr/lib/protobuf/${PROTOBUF_SLOT}/include"
			-DProtobuf_LIBRARIES="${ESYSROOT}/usr/lib/protobuf/${PROTOBUF_SLOT}/$(get_libdir)/libprotobuf.a"
			-DProtobuf_PROTOC_LIBRARY="${ESYSROOT}/usr/lib/protobuf/${PROTOBUF_SLOT}/$(get_libdir)/libprotoc.a"
			-DPROTOBUF_PROTOC_EXECUTABLE="${ESYSROOT}/usr/lib/protobuf/${PROTOBUF_SLOT}/bin/protoc"
			$(usex test '-DgRPC_BENCHMARK_PROVIDER=package' '')
		)
		cmake_src_configure
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
		export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_build"
		cd "${BUILD_DIR}" || die
		cmake_src_compile
	}
	multilib_foreach_abi compile_abi
}

src_install() {
	local prefix="/usr/lib/${PN}/${SLOT_MAJ}"
	install_abi() {
		export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
		export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_build"
		cd "${BUILD_DIR}" || die
		cmake_src_install
		if multilib_is_native_abi ; then
			if use examples; then
				find examples -name '.gitignore' -delete || die
				dodoc -r examples
				docompress -x "${prefix}/share/doc/${PF}/examples"
			fi
			if use doc; then
				find doc -name '.gitignore' -delete || die
			fi
			cd "${S}" || die
			einstalldocs
		fi
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
	multilib_src_install_all
}

fix_rpath() {
	local d
	local L
	local x
	IFS=$'\n'
	L=(
		$(find "${ED}/usr/lib/grpc/${PROTOBUF_SLOT}/bin" -type f)
	)
	IFS=$' \t\n'
	local d1="/usr/lib/abseil-cpp/${ABSEIL_CPP_PV%%.*}/$(get_libdir)"
	local d2="/usr/lib/grpc/${PROTOBUF_SLOT}/$(get_libdir)"
	for x in "${L[@]}" ; do
einfo "Adding ${d1} to RPATH for ${x}"
		patchelf \
			--add-rpath "${d1}" \
			"${x}" \
			|| die
einfo "Adding ${d2} to RPATH for ${x}"
		patchelf \
			--add-rpath "${d2}" \
			"${x}" \
			|| die
	done

	fix_libs_abi() {
		IFS=$'\n'
		L=(
			$(find "${ED}/usr/lib/grpc/${PROTOBUF_SLOT}/$(get_libdir)" -name "*.so*")
		)
		IFS=$' \t\n'
		d="/usr/lib/abseil-cpp/${ABSEIL_CPP_PV%%.*}/$(get_libdir)"
		for x in "${L[@]}" ; do
			[[ -L "${x}" ]] && continue
einfo "Adding ${d} to RPATH for ${x}"
			patchelf \
				--add-rpath "${d}" \
				"${x}" \
				|| die
			patchelf \
				--add-rpath '$ORIGIN' \
				"${x}" \
				|| die
		done

	}

	multilib_foreach_abi fix_libs_abi

}

multilib_src_install_all() {
	cd "${S}" || die
	docinto "licenses"
	dodoc \
		"LICENSE" \
		"NOTICE.txt"
	fix_rpath
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multiabi
