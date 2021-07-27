# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils multilib-minimal

DESCRIPTION="Modern open source high performance RPC framework"
HOMEPAGE="https://www.grpc.io"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE+=" doc examples test"
# format is 0/${CORE_SOVERSION//./}.${CPP_SOVERSION//./} , check top level CMakeLists.txt
SLOT="0/18.139"
RDEPEND+="
	 =dev-cpp/abseil-cpp-20210324*:=[${MULTILIB_USEDEP}]
	>=dev-libs/openssl-1.1.1:0=[-bindist,${MULTILIB_USEDEP}]
	>=dev-libs/protobuf-3.15.8:=[${MULTILIB_USEDEP}]
	>=dev-libs/re2-0.2020.06.01:=[${MULTILIB_USEDEP}]
	>=dev-libs/xxhash-0.8.0
	>=net-dns/c-ares-1.15.0:=[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.11:=[${MULTILIB_USEDEP}]"
DEPEND+=" ${RDEPEND}
	test? (
		dev-cpp/benchmark
		dev-cpp/gflags[${MULTILIB_USEDEP}]
	)"
BDEPEND+=" virtual/pkgconfig"
# requires sources of many google tools
RESTRICT="test"
MY_PV="${PV//_pre/-pre}"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"
DOCS=( AUTHORS CONCEPTS.md README.md TROUBLESHOOTING.md doc/. )

soversion_check() {
	local core_sover cpp_sover
	# extract quoted number. line we check looks like this: 'set(gRPC_CPP_SOVERSION    "1.37")'
	core_sover="$(grep 'set(gRPC_CORE_SOVERSION ' CMakeLists.txt  | sed '/.*\"\(.*\)\".*/ s//\1/')"
	cpp_sover="$(grep 'set(gRPC_CPP_SOVERSION ' CMakeLists.txt  | sed '/.*\"\(.*\)\".*/ s//\1/')"
	# remove dots, e.g. 1.37 -> 137
	core_sover="${core_sover//./}"
	cpp_sover="${cpp_sover//./}"
	[[ ${core_sover} -eq $(ver_cut 2 ${SLOT}) ]] || die "fix core sublot! should be ${core_sover}"
	[[ ${cpp_sover} -eq $(ver_cut 3 ${SLOT}) ]] || die "fix cpp sublot! should be ${cpp_sover}"
}

src_prepare() {
	cmake-utils_src_prepare
	prepare_abi() {
		cd "${BUILD_DIR}" || die
		# un-hardcode libdir
		sed -i "s@lib/pkgconfig@$(get_libdir)/pkgconfig@" \
			CMakeLists.txt || die
		sed -i "s@/lib@/$(get_libdir)@" \
			cmake/pkg-config-template.pc.in || die
		soversion_check
	}
	multilib_copy_sources
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
		CMAKE_USE_DIR="${BUILD_DIR}" \
		BUILD_DIR="${P}_${ABI}_build" \
		cmake-utils_src_configure
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	configure_abi() {
		cd "${BUILD_DIR}" || die
		CMAKE_USE_DIR="${BUILD_DIR}" \
		BUILD_DIR="${P}_${ABI}_build" \
		cmake-utils_src_compile
	}
	multilib_foreach_abi configure_abi
}

src_install() {
	configure_abi() {
		cd "${BUILD_DIR}" || die
		CMAKE_USE_DIR="${BUILD_DIR}" \
		BUILD_DIR="${P}_${ABI}_build" \
		cmake-utils_src_install
		if multilib_is_native_abi ; then
			if use examples; then
				find examples -name '.gitignore' -delete || die
				dodoc -r examples
				docompress -x /usr/share/doc/${PF}/examples
			fi
			if use doc; then
				find doc -name '.gitignore' -delete || die
			fi
			einstalldocs
		fi
	}
	multilib_foreach_abi configure_abi
	cd "${S}" || die
	docinto licenses
	dodoc LICENSE NOTICE.txt
}
