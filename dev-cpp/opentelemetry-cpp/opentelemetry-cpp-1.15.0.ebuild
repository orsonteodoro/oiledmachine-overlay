# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit grpc-ver protobuf-ver

GRPC_SLOTS=(
	${GRPC_PROTOBUF_3_SLOTS[@]}
	"1.55"
	"1.56"
	"1.57"
	"1.58"
)
PROTOBUF_SLOTS=(
	${PROTOBUF_3_SLOTS[@]}
	"4.23"
)
OPENTELEMETRY_PROTO_PV="1.2.0"

inherit cmake dep-prepare

KEYWORDS="~amd64 ~arm64"
SRC_URI="
https://github.com/open-telemetry/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/open-telemetry/opentelemetry-proto/archive/v${OPENTELEMETRY_PROTO_PV}.tar.gz
	-> opentelemetry-proto-${OPENTELEMETRY_PROTO_PV}.tar.gz
"

DESCRIPTION="The OpenTelemetry C++ Client"
HOMEPAGE="
	https://opentelemetry.io/
	https://github.com/open-telemetry/opentelemetry-cpp
"
LICENSE="Apache-2.0"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0"
IUSE="-otlp-file -otlp-grpc -otlp-http -prometheus test -zlib"
gen_otlp_grpc_rdepend() {
	local s1
	local s2
	for s1 in ${GRPC_SLOTS[@]} ; do
		s2=$(grpc_get_protobuf_slot "${s1}")
		echo  "
			(
				=net-libs/grpc-${s1}*
				dev-libs/protobuf:0/${s2}
			)
		"
	done
}
RDEPEND="
	dev-libs/boost:=
	otlp-grpc? (
		|| (
			$(gen_otlp_grpc_rdepend)
		)
		dev-libs/protobuf:=
		net-libs/grpc:=
	)
	otlp-file? (
		>=dev-cpp/nlohmann_json-3.11.3
	)
	otlp-http? (
		>=dev-cpp/nlohmann_json-3.11.3
		>=net-misc/curl-8.4.0
		net-misc/curl:=
	)
	prometheus? (
		>=dev-cpp/prometheus-cpp-1.2.4
	)
	zlib? (
		>=sys-libs/zlib-1.2.13
	)
"
DEPEND="
	${RDEPEND}
	test? (
		>=dev-cpp/benchmark-1.8.3
		>=dev-cpp/gtest-1.14.0
	)
"
PATCHES=(
	# Remove tests.  They need network.
	"${FILESDIR}/opentelemetry-cpp-1.5.0-tests.patch"
)

gen_git_tag() {
	local path="${1}"
	local tag_name="${2}"
einfo "Generating tag start for ${path}"
	pushd "${path}" >/dev/null 2>&1 || die
		git init || die
		git config user.email "name@example.com" || die
		git config user.name "John Doe" || die
		touch dummy || die
		git add dummy || die
		#git add -f * || die
		git commit -m "Dummy" || die
		git tag ${tag_name} || die
	popd >/dev/null 2>&1 || die
einfo "Generating tag done"
}

src_unpack() {
	unpack ${A}
	dep_prepare_mv "${WORKDIR}/opentelemetry-proto-${OPENTELEMETRY_PROTO_PV}" "${S}/third_party/opentelemetry-proto"
	gen_git_tag "${S}/third_party/opentelemetry-proto" "v${OPENTELEMETRY_PROTO_PV}"
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS:BOOL=ON
		-DBUILD_TESTING:BOOL=$(usex test)
		-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
		-DWITH_OTLP_FILE=$(usex otlp-file)
		-DWITH_OTLP_GRPC=$(usex otlp-grpc)
		-DWITH_OTLP_HTTP=$(usex otlp-http)
		-DWITH_OTLP_HTTP_COMPRESSION=$(usex zlib)
		-DWITH_PROMETHEUS:BOOL=$(usex prometheus)
	)
	cmake_src_configure
}
