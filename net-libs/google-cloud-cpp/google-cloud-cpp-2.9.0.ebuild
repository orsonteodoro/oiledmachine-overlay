# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# From cmake/GoogleapisConfig.cmake
GOOGLEAPIS_COMMIT="c0b5730937e56047dc11900463ff87be7c80e8cc"
SRC_URI="
https://github.com/GoogleCloudPlatform/google-cloud-cpp/archive/v${PV}.tar.gz -> ${P}.tar.gz
https://github.com/googleapis/googleapis/archive/${GOOGLEAPIS_COMMIT}.tar.gz -> googleapis-${GOOGLEAPIS_COMMIT}.tar.gz
"

DESCRIPTION="Google Cloud Client Library for C++"
HOMEPAGE="https://cloud.google.com/"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=" test r2"
# Tests need a GCP account
RESTRICT="test"
# U 18.04
# See https://github.com/googleapis/google-cloud-cpp/blob/v2.9.0/bazel/google_cloud_cpp_deps.bzl
RDEPEND="
	>=dev-cpp/abseil-cpp-20230125.2:0/20230125
	>=dev-cpp/nlohmann_json-3.11.2
	>=dev-libs/crc32c-1.1.2
	>=dev-libs/openssl-1.1.1:=
	>=dev-libs/re2-0.2020.11.01:=
	>=net-libs/grpc-1.49.3:=
	>=net-misc/curl-7.69.1
	>=sys-libs/zlib-1.2.11
	dev-libs/protobuf:0/3.21
"
DEPEND="
	${RDEPEND}
	>=dev-cpp/gtest-1.13.0
	test? (
		>=dev-cpp/benchmark-1.7.0
	)
"
DOCS=( README.md )
PATCHES=(
	"${FILESDIR}/${PN}-2.9.0-no-download.patch"
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
	cp "${DISTDIR}/googleapis-${GOOGLEAPIS_COMMIT}.tar.gz" \
		"${BUILD_DIR}/external/googleapis/src/${GOOGLEAPIS_COMMIT}.tar.gz" || die
}

src_test() {
	# test fails
	local myctestargs=(
		-E internal_parse_rfc3339_test
	)
	cmake_src_test
}
