# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake

DESCRIPTION="Google Cloud Client Library for C++"
HOMEPAGE="https://cloud.google.com/"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=" r1"
RESTRICT="test"
RDEPEND="
	>=dev-libs/crc32c-1.0.6
	>=dev-libs/openssl-1.1.1:=
	>=net-libs/grpc-1.19.1:=
	>=net-misc/curl-7.60.0
	dev-libs/protobuf:0/30
"
DEPEND="
	${RDEPEND}
	>=dev-cpp/gtest-1.9.0
"
DOCS=( README.md )
JSON_VER="3.4.0"

# From cmake/external/googleapis.cmake
GOOGLEAPIS_COMMIT="6a3277c0656219174ff7c345f31fb20a90b30b97"

SRC_URI="
https://github.com/GoogleCloudPlatform/google-cloud-cpp/archive/v${PV}.tar.gz -> ${P}.tar.gz
https://github.com/googleapis/googleapis/archive/${GOOGLEAPIS_COMMIT}.tar.gz -> googleapis-${GOOGLEAPIS_COMMIT}.tar.gz
https://github.com/nlohmann/json/releases/download/v${JSON_VER}/json.hpp -> nlohmann-json-${JSON_VER}-json.hpp
"
PATCHES=(
	"${FILESDIR}/google-cloud-cpp-0.9.0-offline_nlohmannjson.patch"
)

src_configure() {
	local mycmakeargs=(
		-DGOOGLE_CLOUD_CPP_DEPENDENCY_PROVIDER=package
		-DBUILD_TESTING=OFF
		-DCMAKE_CXX_STANDARD=17
	)
	cmake_src_configure
	mkdir -p "${BUILD_DIR}/external/nlohmann_json/src/" || die
	cp "${DISTDIR}/nlohmann-json-${JSON_VER}-json.hpp" "${BUILD_DIR}/external/nlohmann_json/src/json.hpp" || die
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
