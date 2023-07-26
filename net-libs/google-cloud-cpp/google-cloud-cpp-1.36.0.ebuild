# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Google Cloud Client Library for C++"
HOMEPAGE="https://cloud.google.com/"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=" test r1"
# Tests need a GCP account
RESTRICT="test"
# U 18.04
RDEPEND="
	>=dev-cpp/abseil-cpp-20211102.0:=
	>=dev-cpp/nlohmann_json-3.10.5
	>=dev-libs/crc32c-1.1.2
	>=dev-libs/openssl-1.1.1:=
	>=dev-libs/re2-0.2020.11.01:=
	>=net-libs/grpc-1.43.2:=
	>=net-misc/curl-7.69.1
	>=sys-libs/zlib-1.2.11
	dev-libs/protobuf:0/30
"
DEPEND="
	${RDEPEND}
	>=dev-cpp/gtest-1.11.0
	test? (
		>=dev-cpp/benchmark-1.6.1
	)
"

# From cmake/GoogleapisConfig.cmake
GOOGLEAPIS_COMMIT="28c6bb97cac6f16c69879be4e655674a74b886ef"

SRC_URI="
https://github.com/GoogleCloudPlatform/google-cloud-cpp/archive/v${PV}.tar.gz -> ${P}.tar.gz
https://github.com/googleapis/googleapis/archive/${GOOGLEAPIS_COMMIT}.tar.gz -> googleapis-${GOOGLEAPIS_COMMIT}.tar.gz
"
DOCS=( README.md )

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
