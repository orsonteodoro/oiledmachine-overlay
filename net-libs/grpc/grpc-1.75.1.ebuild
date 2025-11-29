# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# For versioning, see
# https://github.com/grpc/grpc/blob/master/doc/g_stands_for.md
# https://grpc.io/docs/what-is-grpc/faq/#how-long-are-grpc-releases-supported-for

# For supported java versions, see
# https://github.com/grpc/grpc-java/blob/v1.75.1/.github/workflows/testing.yml#L20

# For supported python versions, see
# https://github.com/grpc/grpc/blob/v1.75.1/setup.py#L100

# For supported ruby versions, see
# https://github.com/grpc/grpc/blob/v1.75.1/Rakefile#L147

MY_PV="${PV//_pre/-pre}"

ABSEIL_CPP_SLOT="20250512"
CFLAGS_HARDENED_ASSEMBLERS="inline nasm"
CFLAGS_HARDENED_BUILDFILES_SANITIZERS="asan msan tsan ubsan"
CFLAGS_HARDENED_LANGS="asm c-lang cxx"
CFLAGS_HARDENED_USE_CASES="network untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="DOS HO OOBW PE"
CXX_STANDARD=17
OPENCENSUS_PROTO_PV="0.3.0"
PROTOBUF_CPP_SLOT="6"
PYTHON_COMPAT=( "python3_"{10..11} )
RE2_SLOT="20240116"
RUBY_OPTIONAL="yes"
USE_RUBY="ruby32 ruby33 ruby34"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

inherit abseil-cpp cflags-hardened cmake flag-o-matic libcxx-slot libstdcxx-slot multilib-minimal protobuf python-r1 re2 ruby-ng

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${MY_PV}"
S_OPENCENSUS_PROTO="${WORKDIR}/opencensus-proto-${OPENCENSUS_PROTO_PV}"
SRC_URI="
https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/census-instrumentation/opencensus-proto/archive/v${OPENCENSUS_PROTO_PV}.tar.gz
	-> opencensus-proto-${OPENCENSUS_PROTO_PV}.tar.gz
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
${LSRT_IUSE[@]/#/-}
cxx doc examples test
ebuild_revision_40
"
REQUIRED_USE+="
	python? (
		${PYTHON_REQUIRED_USE}
	)
"
RESTRICT="test"
GRPC_SLOT="${PROTOBUF_CPP_SLOT}"
SLOT="${GRPC_SLOT}/1.75"
# third_party last update: 20250723
RDEPEND+="
	>=dev-cpp/abseil-cpp-20250512.1:${ABSEIL_CPP_SLOT}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
	dev-cpp/abseil-cpp:=
	>=dev-libs/openssl-1.1.1g:0[-bindist(-),${MULTILIB_USEDEP}]
	dev-libs/openssl:=
	dev-libs/protobuf:${PROTOBUF_CPP_SLOT}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
	dev-libs/protobuf:=
	>=dev-libs/re2-0.2022.04.01:${RE2_SLOT}[${MULTILIB_USEDEP}]
	dev-libs/re2:=
	>=net-dns/c-ares-1.17.2[${MULTILIB_USEDEP}]
	net-dns/c-ares:=
	>=sys-libs/zlib-1.2.13[${MULTILIB_USEDEP}]
	sys-libs/zlib:=
"
# See also
# third_party/boringssl-with-bazel/src/include/openssl/crypto.h: OPENSSL_VERSION_TEXT
# third_party/boringssl-with-bazel/src/include/openssl/base.h: OPENSSL_VERSION_NUMBER
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.16
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	test? (
		>=dev-cpp/benchmark-1.9.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
"
PDEPEND_DISABLE="
	csharp? (
		=dev-dotnet/grpc-dotnet-$(($(ver_cut 1 ${PV})+1)).$(ver_cut 2 ${PV})*
		dev-dotnet/grpc-dotnet:=
	)
"
PDEPEND+="
	java? (
		=dev-java/grpc-java-${PV%%.*}*
		dev-java/grpc-java:=
		|| (
			(
				virtual/jdk:17
				virtual/jre:17
			)
			(
				virtual/jdk:11
				virtual/jre:11
			)
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
		ruby_targets_ruby33? (
			dev-lang/ruby:3.3
			~dev-ruby/grpc-${PV}[ruby_targets_ruby33?]
			dev-ruby/grpc:=
		)
		ruby_targets_ruby34? (
			dev-lang/ruby:3.4
			~dev-ruby/grpc-${PV}[ruby_targets_ruby34?]
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
	mv "${S_OPENCENSUS_PROTO}" "${S}/third_party/opencensus-proto/src" || die
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
	cflags-hardened_append
	filter-flags "-Wl,--as-needed"
	use php && export EXTRA_DEFINES=GRPC_POSIX_FORK_ALLOW_PTHREAD_ATFORK
	configure_abi() {
		append-ldflags "-Wl,-rpath,/usr/lib/grpc/${GRPC_SLOT}/$(get_libdir)"
		abseil-cpp_src_configure
		re2_src_configure
		protobuf_src_configure

		export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
		export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_build"
		cd "${CMAKE_USE_DIR}" || die
		local mycmakeargs=(
			$(abseil-cpp_append_cmake)
			$(protobuf_append_cmake)
			$(re2_append_cmake)
			$(usex test '-DgRPC_BENCHMARK_PROVIDER=package' '')
			-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/${PN}/${GRPC_SLOT}"
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
	local prefix="/usr/lib/${PN}/${GRPC_SLOT}"
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

multilib_src_install_all() {
	cd "${S}" || die
	docinto "licenses"
	dodoc \
		"LICENSE" \
		"NOTICE.txt"
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multiabi
