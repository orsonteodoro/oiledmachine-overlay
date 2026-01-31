# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

# TODO:
# Change configure for re2

# For deps, see
# https://github.com/googleapis/google-cloud-cpp/blob/v2.43.0/bazel/workspace0.bzl

ABSEIL_CPP_SLOT="20240722" # Originally 20250127.1, but downgraded for grpc:5 to avoid header alignment issues
CXX_STANDARD=17
CFLAGS_HARDENED_BUILDFILES_SANITIZERS="asan msan tsan ubsan"
CFLAGS_HARDENED_LANGS="cxx"
CFLAGS_HARDENED_USE_CASES="network security-critical sensitive-data untrusted-data"
GRPC_SLOT="5"
PROTOBUF_CPP_SLOT="5"
RE2_SLOT="20250512"

# From cmake/GoogleapisConfig.cmake \
GOOGLEAPIS_COMMIT="2193a2bfcecb92b92aad7a4d81baa428cafd7dfd"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

inherit abseil-cpp cflags-hardened cmake grpc libcxx-slot libstdcxx-slot protobuf re2

SRC_URI="
https://github.com/GoogleCloudPlatform/google-cloud-cpp/archive/v${PV}.tar.gz -> ${P}.tar.gz
https://github.com/googleapis/googleapis/archive/${GOOGLEAPIS_COMMIT}.tar.gz -> googleapis-${GOOGLEAPIS_COMMIT}.tar.gz
"

DESCRIPTION="Google Cloud Client Library for C++"
HOMEPAGE="https://cloud.google.com/"
LICENSE="Apache-2.0"
SLOT="${PROTOBUF_CPP_SLOT}/"$(ver_cut "1-2" "${PV}")
KEYWORDS="~amd64 ~x86"
IUSE="
test
ebuild_revision_13
"
# Tests need a GCP account
RESTRICT="test"
RDEPEND="
	(
		>=dev-cpp/abseil-cpp-20240722.0:${ABSEIL_CPP_SLOT%.*}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},cxx_standard_cxx17]
		dev-cpp/abseil-cpp:=
	)
	(
		>=dev-libs/openssl-1.1.1
		dev-libs/openssl:=
	)
	(
		>=dev-libs/re2-0.2025.07.22:${RE2_SLOT}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-libs/re2:=
	)
	(
		net-libs/grpc:${PROTOBUF_CPP_SLOT}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},cxx]
		net-libs/grpc:=
	)
	(
		dev-libs/protobuf:${PROTOBUF_CPP_SLOT}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-libs/protobuf:=
	)
	>=dev-libs/crc32c-1.1.2[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=net-misc/curl-7.69.1
	>=sys-libs/zlib-1.2.11
"
DEPEND="
	${RDEPEND}
	>=dev-cpp/nlohmann_json-3.11.3
	dev-cpp/nlohmann_json:=
"
BDEPEND="
	>=dev-cpp/gtest-1.16.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=dev-cpp/yaml-cpp-0.7.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	test? (
		>=dev-cpp/benchmark-1.9.2[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
"
DOCS=( README.md )
PATCHES=(
	"${FILESDIR}/${PN}-2.9.0-no-download.patch"
)

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	unpack ${P}.tar.gz
}

src_configure() {
	cflags-hardened_append

	abseil-cpp_src_configure
	protobuf_src_configure
	re2_src_configure
	grpc_src_configure

	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DCMAKE_CXX_STANDARD=17
		-DCMAKE_INSTALL_PREFIX="/usr/lib/${PN}/${PROTOBUF_CPP_SLOT}"
		-DGOOGLE_CLOUD_CPP_ENABLE_EXAMPLES=OFF
		-DGOOGLE_CLOUD_CPP_ENABLE_WERROR=OFF

		$(abseil-cpp_append_cpp)
		$(protobuf_append_cpp)
		$(re2_append_cpp)
		$(grpc_append_cpp)

		-DProtobuf_LIBRARIES="protobuf"
		-DProtobuf_INCLUDE_DIR="${ESYSROOT}/usr/lib/protobuf/${PROTOBUF_CPP_SLOT}/include"
	)
	cmake_src_configure
	mkdir -p "${BUILD_DIR}/external/googleapis/src/" || die
	cp \
		"${DISTDIR}/googleapis-${GOOGLEAPIS_COMMIT}.tar.gz" \
		"${BUILD_DIR}/external/googleapis/src/${GOOGLEAPIS_COMMIT}.tar.gz" \
		|| die
}

src_test() {
	# test fails
	local myctestargs=(
		"-E" "internal_parse_rfc3339_test"
	)
	cmake_src_test
}
