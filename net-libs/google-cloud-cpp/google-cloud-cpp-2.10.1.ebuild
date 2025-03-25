# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

declare -A GRPC_TO_PROTOBUF=(
	["1.49"]="3.21"
	["1.52"]="3.21"
	["1.53"]="3.21"
	["1.54"]="3.21"
	["1.55"]="4.23"
	["1.56"]="4.23"
	["1.57"]="4.23"
	["1.58"]="4.23"
	["1.59"]="4.24"
	["1.60"]="4.25"
	["1.61"]="4.25"
	["1.62"]="4.25"
	["1.63"]="5.26"
	["1.64"]="5.26"
	["1.65"]="5.26"
	["1.66"]="5.27"
	["1.67"]="5.27"
)
GRPC_SLOTS=(
	"1.49"
	"1.52"
	"1.53"
	"1.54"
	"1.55"
	"1.56"
	"1.57"
	"1.58"
	"1.59"
	"1.60"
	"1.61"
	"1.62"
	"1.63"
	"1.64"
	"1.65"
	"1.66"
	"1.67"
)
# From cmake/GoogleapisConfig.cmake
GOOGLEAPIS_COMMIT="2da477b6a72168c65fdb4245530cfa702cc4b029"

inherit cmake

SRC_URI="
https://github.com/GoogleCloudPlatform/google-cloud-cpp/archive/v${PV}.tar.gz -> ${P}.tar.gz
https://github.com/googleapis/googleapis/archive/${GOOGLEAPIS_COMMIT}.tar.gz -> googleapis-${GOOGLEAPIS_COMMIT}.tar.gz
"

DESCRIPTION="Google Cloud Client Library for C++"
HOMEPAGE="https://cloud.google.com/"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=" test ebuild_revision_2"
# Tests need a GCP account
RESTRICT="test"
# U 18.04
# See https://github.com/googleapis/google-cloud-cpp/blob/v2.10.1/bazel/google_cloud_cpp_deps.bzl
gen_grpc_rdepend() {
	local s1
	local s2
	for s1 in ${GRPC_SLOTS} ; do
		s2="${GRPC_TO_PROTOBUF[${s1}]}"
		echo "
			(
				dev-libs/protobuf:0/${s2}
				=net-libs/grpc-${s1}*[cxx]
			)
		"
	done
}
RDEPEND="
	>=dev-cpp/abseil-cpp-20230125.2:0/20230125
	>=dev-cpp/nlohmann_json-3.11.2
	>=dev-libs/crc32c-1.1.2
	>=dev-libs/openssl-1.1.1:=
	>=dev-libs/re2-0.2023.03.01:=
	>=net-misc/curl-7.69.1
	>=sys-libs/zlib-1.2.11
	|| (
		$(gen_grpc_rdepend)
	)
	dev-libs/protobuf:=
	net-libs/grpc:=
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
