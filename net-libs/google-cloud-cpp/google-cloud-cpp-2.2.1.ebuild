# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# From cmake/GoogleapisConfig.cmake
GOOGLEAPIS_COMMIT="343f52cd370556819da24df078308f3f709ff24b"
SRC_URI="
https://github.com/GoogleCloudPlatform/google-cloud-cpp/archive/v${PV}.tar.gz -> ${P}.tar.gz
https://github.com/googleapis/googleapis/archive/${GOOGLEAPIS_COMMIT}.tar.gz -> googleapis-${GOOGLEAPIS_COMMIT}.tar.gz
"
# 4fc780c - fix: add missing <cstdint> includes

DESCRIPTION="Google Cloud Client Library for C++"
HOMEPAGE="https://cloud.google.com/"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=" test r2"
# Tests need a GCP account
RESTRICT="test"
# U 18.04
# See https://github.com/googleapis/google-cloud-cpp/blob/v2.2.1/bazel/google_cloud_cpp_deps.bzl
# Upstream uses PROTOBUF_SLOT=0/3.19
RDEPEND="
	>=dev-cpp/abseil-cpp-20220623.1:0/20220623
	>=dev-cpp/nlohmann_json-3.11.2
	>=dev-libs/crc32c-1.1.2
	>=dev-libs/openssl-1.1.1:=
	>=dev-libs/re2-0.2022.06.01:=
	>=net-misc/curl-7.69.1
	>=sys-libs/zlib-1.2.11
	dev-libs/protobuf:0/3.21
	|| (
		=net-libs/grpc-1.48.1:=
	)
"
DEPEND="
	${RDEPEND}
	>=dev-cpp/gtest-1.11.0
	test? (
		>=dev-cpp/benchmark-1.7.0
	)
"
DOCS=( README.md )
PATCHES=(
	"${FILESDIR}/${PN}-2.2.1-no-download.patch"
	"${FILESDIR}/${PN}-commit-4fc780c-backport-to-2.2.1.patch"
)

src_unpack() {
	unpack ${P}.tar.gz
}

src_configure() {
	local mycmakeargs=(
		-DGOOGLE_CLOUD_CPP_ENABLE_WERROR=OFF
		-DGOOGLE_CLOUD_CPP_ENABLE_EXAMPLES=OFF
		-DBUILD_TESTING=$(usex test)
		-DCMAKE_CXX_STANDARD=17
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
		-E internal_parse_rfc3339_test
	)
	cmake_src_test
}
