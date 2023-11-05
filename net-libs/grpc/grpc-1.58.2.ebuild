# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# For versioning, see
# https://github.com/grpc/grpc/blob/master/doc/g_stands_for.md
# https://grpc.io/docs/what-is-grpc/faq/#how-long-are-grpc-releases-supported-for

inherit cmake multilib-minimal

MY_PV="${PV//_pre/-pre}"
OPENCENSUS_PROTO_PV="0.3.0"
SRC_URI="
https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/census-instrumentation/opencensus-proto/archive/v${OPENCENSUS_PROTO_PV}.tar.gz
	-> opencensus-proto-${OPENCENSUS_PROTO_PV}.tar.gz
"
S_OPENCENSUS_PROTO="${WORKDIR}/opencensus-proto-${OPENCENSUS_PROTO_PV}"
S="${WORKDIR}/${PN}-${MY_PV}"

DESCRIPTION="Modern open source high performance RPC framework"
HOMEPAGE="https://www.grpc.io"
LICENSE="
	Apache-2.0
	BSD
	BSD-2 GPL-2+
	GPL-2
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
KEYWORDS="~amd64 ~ppc64 ~x86"
# LSRT - language specific runtime
LSRT_IUSE=( csharp cxx csharpext java nodejs objc php python ruby ) # Upstream enables all
IUSE+="
${LSRT_IUSE[@]/#/-}
cxx
doc examples test

r3
"
SLOT_MAJ="0"
SLOT="${SLOT_MAJ}/35.158" # 0/$gRPC_CORE_SOVERSION.$(ver_cut 1-2 $PACKAGE_VERSION | sed -e "s|.||g")
# third_party last update: 20230821
RDEPEND+="
	>=dev-cpp/abseil-cpp-20230802.0:0/20230802[${MULTILIB_USEDEP},cxx17(+)]
	>=dev-libs/openssl-1.1.1g:0=[-bindist(-),${MULTILIB_USEDEP}]
	>=dev-libs/re2-0.2022.04.01:=[${MULTILIB_USEDEP}]
	>=net-dns/c-ares-1.19.1:=[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.13:=[${MULTILIB_USEDEP}]
	dev-libs/protobuf:0/4.23[${MULTILIB_USEDEP}]
"
# See also
# third_party/boringssl-with-bazel/src/include/openssl/crypto.h: OPENSSL_VERSION_TEXT
# third_party/boringssl-with-bazel/src/include/openssl/base.h: OPENSSL_VERSION_NUMBER
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-util/cmake-3.8
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	test? (
		>=dev-cpp/benchmark-1.7.0
	)
"
PDEPEND_DISABLE="
	csharp? (
		=dev-dotnet/grpc-dotnet-$(($(ver_cut 1 ${PV})+1)).$(ver_cut 2 ${PV})*
	)
"
PDEPEND+="
	java? (
		~dev-java/grpc-java-${PV}
	)
	php? (
		~dev-php/grpc-${PV}
	)
	python? (
		~dev-python/grpcio-${PV}
	)
	ruby? (
		>=dev-lang/ruby-2
		~dev-ruby/grpc-${PV}
	)
"
RESTRICT="test"
DOCS=( AUTHORS CONCEPTS.md README.md TROUBLESHOOTING.md doc/. )

soversion_check() {
	local f1=$(grep  "gRPC_CORE_VERSION" "${S}/CMakeLists.txt" | head -n 1 \
		| cut -f 2 -d "\"" | cut -f 1 -d ".")
	local f2=$(grep  "gRPC_CPP_SOVERSION" "${S}/CMakeLists.txt" \
		| head -n 1 | cut -f 2 -d "\"" | sed -e "s|\.||")
	local new_slot="${SLOT_MAJ}/${f1}.${f2}"
	[[ "${SLOT}" != "${new_slot}" ]] \
		&& die "Ebuild QA: Update to SLOT=\"\${SLOT_MAJ}/${f1}.${f2}\""
}

src_unpack() {
	unpack ${A}
	mv "${S_OPENCENSUS_PROTO}" "${S}/third_party/opencensus-proto/src" || die
}

src_prepare() {
	soversion_check
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
	use php && export EXTRA_DEFINES=GRPC_POSIX_FORK_ALLOW_PTHREAD_ATFORK
	configure_abi() {
		export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
		export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_build"
		cd "${CMAKE_USE_DIR}" || die
		local mycmakeargs=(
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
			-DCMAKE_CXX_STANDARD=17
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
	install_abi() {
		export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
		export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_build"
		cd "${BUILD_DIR}" || die
		cmake_src_install
		if multilib_is_native_abi ; then
			if use examples; then
				find examples -name '.gitignore' -delete || die
				dodoc -r examples
				docompress -x /usr/share/doc/${PF}/examples
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
	docinto licenses
	dodoc LICENSE NOTICE.txt
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multiabi
