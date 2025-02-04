# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

KEYWORDS="~amd64"
SRC_URI="
https://github.com/open-telemetry/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
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
IUSE="jaeger otlp-grpc otlp-http prometheus test"
RDEPEND="
	jaeger? (
		>=dev-libs/thrift-0.14.1
		dev-libs/thrift:=
		dev-libs/boost:=
	)
	otlp-grpc? (
		|| (
			=net-libs/grpc-1.49*
			=net-libs/grpc-1.52*
			=net-libs/grpc-1.53*
			=net-libs/grpc-1.54*
		)
		dev-libs/protobuf:0/3.21
		net-libs/grpc:=
	)
	otlp-http? (
		>=net-misc/curl-7.73.0
		net-misc/curl:=
	)
	prometheus? (
		>=dev-cpp/prometheus-cpp-1.0.0
	)
"
DEPEND="
	${RDEPEND}
	test? (
		>=dev-cpp/benchmark-1.6.0
		>=dev-cpp/gtest-1.10.0
	)
"
PATCHES=(
	# remove tests the need network
	"${FILESDIR}/opentelemetry-cpp-1.5.0-tests.patch"
	# bug #865029
	"${FILESDIR}/opentelemetry-cpp-1.6.0-dont-install-nosend.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
		-DBUILD_SHARED_LIBS:BOOL=ON
		-DBUILD_TESTING:BOOL=$(usex test)
		-DWITH_JAEGER:BOOL=$(usex jaeger)
		-DWITH_OTLP_GRPC=$(usex otlp-grpc)
		-DWITH_OTLP_HTTP=$(usex otlp-http)
		-DWITH_PROMETHEUS:BOOL=$(usex prometheus)
	)
	if use otlp-grpc || use otlp-http ; then
		mycmakeargs+=(
			-DWITH_OTLP=ON
		)
	fi
	cmake_src_configure
}
