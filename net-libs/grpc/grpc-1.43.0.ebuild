# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils multilib-minimal

DESCRIPTION="Modern open source high performance RPC framework"
HOMEPAGE="https://www.grpc.io"
LICENSE="Apache-2.0
	BSD
	BSD-2 GPL-2+
	GPL-2
	MIT
	MPL-2.0
	Unlicense"
# BSD third_party/address_sorting/LICENSE
# BSD third_party/upb/LICENSE
# GPL-2 third_party/xxhash/tests/bench/LICENSE
# BSD-2 GPL-2 third_party/xxhash/LICENSE
# MIT third_party/upb/third_party/lunit/LICENSE
# Unlicense third_party/upb/third_party/wyhash/LICENSE
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE+=" doc examples test"
SLOT_MAJ="0"
SLOT="${SLOT_MAJ}/21.143" # 0/$gRPC_CORE_SOVERSION.$(ver_cut 1-2 $PACKAGE_VERSION | sed -e "s|.||g")
# third_party last update: 20211103
RDEPEND+="
	~dev-cpp/abseil-cpp-20211102.0:=[${MULTILIB_USEDEP},cxx17(+)]
	>=dev-libs/openssl-1.1.1:0=[-bindist(-),${MULTILIB_USEDEP}]
	>=dev-libs/protobuf-3.18.1:=[${MULTILIB_USEDEP}]
	>=dev-libs/re2-0.2021.09.01:=[${MULTILIB_USEDEP}]
	>=net-dns/c-ares-1.15.0:=[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.11:=[${MULTILIB_USEDEP}]"
DEPEND+=" ${RDEPEND}
	test? (
		>=dev-cpp/benchmark-1.6.0
		>=dev-cpp/gflags-2.2.0[${MULTILIB_USEDEP}]
	)"
BDEPEND+=" >=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]"
RESTRICT="test"
MY_PV="${PV//_pre/-pre}"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"
DOCS=( AUTHORS CONCEPTS.md README.md TROUBLESHOOTING.md doc/. )

soversion_check() {
	local f1=$(grep  "gRPC_CORE_VERSION" "${S}/CMakeLists.txt" | head -n 1 \
		| cut -f 2 -d "\"" | cut -f 1 -d ".")
	local f2=$(grep  "gRPC_CPP_SOVERSION" "${S}/CMakeLists.txt" \
		| head -n 1 | cut -f 2 -d "\"" | sed -e "s|\.||")
	local new_slot="${SLOT_MAJ}/${f1}.${f2}"
	[[ "${SLOT}" != "${new_slot}" ]] \
		&& die "Ebuild Q/A: Update SLOT=\"\${SLOT_MAJ}/${f1}.${f2}\""
}

src_prepare() {
	soversion_check
	cmake-utils_src_prepare
	prepare_abi() {
		cd "${BUILD_DIR}" || die
		# un-hardcode libdir
		sed -i "s@lib/pkgconfig@$(get_libdir)/pkgconfig@" \
			CMakeLists.txt || die
		sed -i "s@/lib@/$(get_libdir)@" \
			cmake/pkg-config-template.pc.in || die
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
			-DCMAKE_CXX_STANDARD=17
			$(usex test '-DgRPC_GFLAGS_PROVIDER=package' '')
			$(usex test '-DgRPC_BENCHMARK_PROVIDER=package' '')
		)
		CMAKE_USE_DIR="${BUILD_DIR}" \
		BUILD_DIR="${WORKDIR}/${P}_${ABI}_build" \
		cmake-utils_src_configure
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	configure_abi() {
		cd "${BUILD_DIR}" || die
		CMAKE_USE_DIR="${BUILD_DIR}" \
		BUILD_DIR="${WORKDIR}/${P}_${ABI}_build" \
		cmake-utils_src_compile
	}
	multilib_foreach_abi configure_abi
}

src_install() {
	configure_abi() {
		cd "${BUILD_DIR}" || die
		CMAKE_USE_DIR="${BUILD_DIR}" \
		BUILD_DIR="${WORKDIR}/${P}_${ABI}_build" \
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
