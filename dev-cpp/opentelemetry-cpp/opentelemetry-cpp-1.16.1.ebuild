# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

KEYWORDS="~amd64 ~arm64"
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
IUSE="jaeger otlp-grpc otlp-http prometheus test zlib"
RDEPEND="
	dev-libs/boost:=
	otlp-grpc? (
		|| (
			=net-libs/grpc-1.60*
			=net-libs/grpc-1.61*
			=net-libs/grpc-1.62*
		)
		dev-libs/protobuf:0/4.25
		net-libs/grpc:=
	)
	otlp-http? (
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
	# remove tests the need network
	"${FILESDIR}/opentelemetry-cpp-1.5.0-tests.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
		-DBUILD_SHARED_LIBS:BOOL=ON
		-DBUILD_TESTING:BOOL=$(usex test)
		-DWITH_OTLP_GRPC=$(usex otlp-grpc)
		-DWITH_OTLP_HTTP=$(usex otlp-http)
		-DWITH_OTLP_HTTP_COMPRESSION=$(usex zlib)
		-DWITH_PROMETHEUS:BOOL=$(usex prometheus)
	)
	if use otlp-grpc || use otlp-http ; then
		mycmakeargs+=(
			-DWITH_OTLP=ON
		)
	fi
	cmake_src_configure
}
