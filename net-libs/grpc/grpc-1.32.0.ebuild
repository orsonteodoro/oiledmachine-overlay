# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils multilib-minimal

MY_PV="${PV//_pre/-pre}"

DESCRIPTION="Modern open source high performance RPC framework"
HOMEPAGE="https://www.grpc.io"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="doc examples libressl test"

RDEPEND="
	=dev-cpp/abseil-cpp-20200225*:=[${MULTILIB_USEDEP}]
	dev-libs/re2:=[${MULTILIB_USEDEP}]
	>=dev-libs/protobuf-3.13.0:=[${MULTILIB_USEDEP}]
	>=net-dns/c-ares-1.15.0:=[${MULTILIB_USEDEP}]
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
	!libressl? ( >=dev-libs/openssl-1.1.1:0=[-bindist,${MULTILIB_USEDEP}] )
	libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
"

DEPEND="${RDEPEND}
	test? (
		dev-cpp/benchmark
		dev-cpp/gflags[${MULTILIB_USEDEP}]
	)
"

BDEPEND="virtual/pkgconfig"

# requires sources of many google tools
RESTRICT="test"

S="${WORKDIR}/${PN}-${MY_PV}"

PATCHES=( "${FILESDIR}/use-pkg-config-to-find-re2.patch" )

src_prepare() {
	cmake-utils_src_prepare

	multilib_copy_sources

	prepare_abi() {
		cd "${BUILD_DIR}" || die
		# un-hardcode libdir
		sed -i "s@lib/pkgconfig@$(get_libdir)/pkgconfig@" CMakeLists.txt || die
		sed -i "s@/lib@/$(get_libdir)@" cmake/pkg-config-template.pc.in || die
	}
	multilib_foreach_abi prepare_abi
}

src_configure() {
	configure_abi() {
		cd "${BUILD_DIR}" || die
		local mycmakeargs=(
			-DgRPC_INSTALL=ON
			-DgRPC_ABSL_PROVIDER=package
			-DgRPC_BACKWARDS_COMPATIBILITY_MODE=OFF
			-DgRPC_CARES_PROVIDER=package
			-DgRPC_INSTALL_CMAKEDIR="$(get_libdir)/cmake/${PN}"
			-DgRPC_INSTALL_LIBDIR="$(get_libdir)"
			-DgRPC_PROTOBUF_PROVIDER=package
			-DgRPC_RE2_PROVIDER=package
			-DgRPC_SSL_PROVIDER=package
			-DgRPC_ZLIB_PROVIDER=package
			-DgRPC_BUILD_TESTS=$(usex test)
			$(usex test '-DgRPC_GFLAGS_PROVIDER=package' '')
			$(usex test '-DgRPC_BENCHMARK_PROVIDER=package' '')
		)
		S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
		cmake-utils_src_configure
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	configure_abi() {
		S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
		cmake-utils_src_compile
	}
	multilib_foreach_abi configure_abi
}

src_install() {
	configure_abi() {
		cd "${BUILD_DIR}" || die
		cmake-utils_src_install

		if multilib_is_native_abi ; then
			if use examples; then
				find examples -name '.gitignore' -delete || die
				dodoc -r examples
				docompress -x /usr/share/doc/${PF}/examples
			fi

			if use doc; then
				find doc -name '.gitignore' -delete || die
				local DOCS=( AUTHORS CONCEPTS.md README.md TROUBLESHOOTING.md doc/. )
			fi
			einstalldocs
		fi
	}
	multilib_foreach_abi configure_abi
}
