# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

declare -A GRPC_TO_PROTOBUF=(
	["1.49"]="3.21"
	["1.52"]="3.21"
	["1.53"]="3.21"
	["1.54"]="3.21"
)
GRPC_SLOTS=(
	"1.49"
	"1.52"
	"1.53"
	"1.54"
)
PROTOBUF_SLOTS=(
	"3.21"
)
OPENTELEMETRY_PROTO_PV="0.19.0"

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
IUSE="-jaeger -otlp-grpc -otlp-http -prometheus test"
gen_otlp_grpc_rdepend() {
	local s1
	local s2
	for s1 in ${GRPC_SLOTS[@]} ; do
		s2="${GRPC_TO_PROTOBUF[${s1}]}"
		echo  "
			(
				=net-libs/grpc-${s1}*
				dev-libs/protobuf:0/${s2}
			)
		"
	done
}
RDEPEND="
	jaeger? (
		>=dev-libs/thrift-0.14.1
		dev-libs/thrift:=
		dev-libs/boost:=
	)
	otlp-grpc? (
		|| (
			$(gen_otlp_grpc_rdepend)
		)
		dev-libs/protobuf:=
		net-libs/grpc:=
	)
	otlp-http? (
		>=dev-cpp/nlohmann_json-3.11.2
		>=net-misc/curl-7.73.0
		net-misc/curl:=
	)
	prometheus? (
		>=dev-cpp/prometheus-cpp-1.1.0
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
		-DWITH_JAEGER:BOOL=$(usex jaeger)
		-DWITH_OTLP_GRPC=$(usex otlp-grpc)
		-DWITH_OTLP_HTTP=$(usex otlp-http)
		-DWITH_PROMETHEUS:BOOL=$(usex prometheus)
		-DWITH_STL=ON
	)
	if use otlp-grpc || use otlp-http ; then
		mycmakeargs+=(
			-DWITH_OTLP=ON
		)
	fi
	cmake_src_configure
}
