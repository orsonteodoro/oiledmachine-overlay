# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Protobuf version reference:
# https://github.com/open-telemetry/opentelemetry-cpp/blob/v1.23.0/MODULE.bazel

_CXX_STANDARD=(
	"cxx_standard_cxx14"
	"+cxx_standard_cxx17"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}
)

CXX_STANDARD=17
GRPC_SLOT="5"
OPENTELEMETRY_PROTO_PV="1.3.1"
PROTOBUF_SLOT="5"

inherit cmake dep-prepare libcxx-slot libstdcxx-slot

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
SLOT="${PROTOBUF_SLOT}/$(ver_cut 1-2 ${PV})"
IUSE="
${_CXX_STANDARD[@]}
-otlp-file -otlp-grpc -otlp-http -prometheus test -zlib
ebuild_revision_2
"
REQUIRED_USE="
	^^ (
		${_CXX_STANDARD[@]/+}
	)
	otlp-grpc? (
		cxx_standard_cxx17
	)
"
RDEPEND="
	dev-libs/boost[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-libs/boost:=
	otlp-grpc? (
		virtual/grpc:${GRPC_SLOT}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		virtual/grpc:=
		virtual/protobuf:${PROTOBUF_SLOT}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		virtual/protobuf:=
	)
	otlp-http? (
		>=net-misc/curl-8.8.0
		net-misc/curl:=
	)
	prometheus? (
		>=dev-cpp/prometheus-cpp-1.3.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
	zlib? (
		>=sys-libs/zlib-1.3.1
	)
"
DEPEND="
	${RDEPEND}
	otlp-file? (
		>=dev-cpp/nlohmann_json-3.12.0
	)
	otlp-http? (
		>=dev-cpp/nlohmann_json-3.12.0
	)
"
BDEPEND="
	test? (
		>=dev-cpp/benchmark-1.8.4[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		>=dev-cpp/gtest-1.14.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
"
PATCHES=(
	# Remove tests.  They need network.
	"${FILESDIR}/opentelemetry-cpp-1.5.0-tests.patch"
)

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

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

get_abseil_cpp_slot() {
	if has_version "net-libs/grpc:3/1.30" ; then
		echo "20200225"
	elif has_version "net-libs/grpc:3/1.51" ; then
		echo "20220623"
	elif has_version "net-libs/grpc:5/1.71" ; then
		echo "20240722"
	elif has_version "net-libs/grpc:6/1.75" ; then
		echo "20250512"
	fi
}

src_configure() {
	local ABSEIL_CPP_SLOT=$(get_abseil_cpp_slot)
	local mycmakeargs=(
		$(usex cxx_standard_cxx14 '-DCMAKE_CXX_STANDARD=14' '')
		$(usex cxx_standard_cxx17 '-DCMAKE_CXX_STANDARD=17' '')
		-DBUILD_SHARED_LIBS:BOOL=ON
		-DBUILD_TESTING:BOOL=$(usex test)
		-DCMAKE_INSTALL_PREFIX="/usr/lib/${PN}/${PROTOBUF_SLOT}"
		-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
		-DWITH_OTLP_FILE=$(usex otlp-file)
		-DWITH_OTLP_GRPC=$(usex otlp-grpc)
		-DWITH_OTLP_HTTP=$(usex otlp-http)
		-DWITH_OTLP_HTTP_COMPRESSION=$(usex zlib)
		-DWITH_PROMETHEUS:BOOL=$(usex prometheus)
	)
	if use otlp-grpc ; then
		mycmakeargs+=(
			-Dabsl_DIR="${ESYSROOT}/usr/lib/abseil-cpp/${ABSEIL_CPP_SLOT}/$(get_libdir)/cmake/absl"
			-DgRPC_DIR="${ESYSROOT}/usr/lib/grpc/${GRPC_SLOT}/$(get_libdir)/cmake/grpc"
			-DProtobuf_DIR="${ESYSROOT}/usr/lib/protobuf/${PROTOBUF_SLOT}/$(get_libdir)/cmake/protobuf"
		)
	fi
	cmake_src_configure
}
