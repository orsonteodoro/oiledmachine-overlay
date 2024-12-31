# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 22.04

inherit cmake

KEYWORDS="amd64"
LIBJUICE_COMMIT="0b6f958baba55e1a4eb31ec2137f62b2e07382ae"
LIBSRTP_COMMIT="a566a9cfcd619e8327784aa7cff4a1276dc1e895"
NLOHMANN_JSON_COMMIT="9cca280a4d0ccf0c08f47a99aa71d1b0e52f8d03"
PLOG_COMMIT="e21baecd4753f14da64ede979c5a19302618b752"
USRSCTP_COMMIT="ebb18adac6501bad4501b1f6dccb67a1c85cc299"
SRC_URI="
https://github.com/paullouisageneau/libdatachannel/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	!system-json? (
https://github.com/nlohmann/json/archive/${NLOHMANN_JSON_COMMIT}.tar.gz
	-> nlohmann-json-${NLOHMANN_JSON_COMMIT:0:7}.tar.gz
	)
	!system-juice? (
https://github.com/paullouisageneau/libjuice/archive/${LIBJUICE_COMMIT}.tar.gz
	-> libjuice-${LIBJUICE_COMMIT:0:7}.tar.gz
	)
	!system-plog? (
https://github.com/SergiusTheBest/plog/archive/${PLOG_COMMIT}.tar.gz
	-> plog-${PLOG_COMMIT:0:7}.tar.gz
	)
	!system-srtp? (
https://github.com/cisco/libsrtp/archive/${LIBSRTP_COMMIT}.tar.gz
	-> libsrtp-${LIBSRTP_COMMIT:0:7}.tar.gz
	)
	!system-usrsctp? (
https://github.com/sctplab/usrsctp/archive/${USRSCTP_COMMIT}.tar.gz
	-> usrsctp-${USRSCTP_COMMIT:0:7}.tar.gz
	)
"

DESCRIPTION="C/C++ WebRTC network library featuring Data Channels, Media Transport, and WebSockets"
HOMEPAGE="
	https://libdatachannel.org/
	https://github.com/paullouisageneau/libdatachannel
"

LICENSE="MPL-2.0"
SLOT="0"
IUSE="
debug +examples -gnutls -mbedtls +openssl +media-transport -nettle -nice
-system-json -system-juice -system-plog -system-srtp -system-usrsctp test
+websocket
"
REQUIRED_USE="
	^^ (
		gnutls
		mbedtls
		openssl
	)
"
RDEPEND="
	nice? (
		>=net-libs/libnice-0.1.18
	)
	openssl? (
		>=dev-libs/openssl-1.1.0
	)
	system-plog? (
		>=dev-cpp/plog-1.1.10
	)
	system-srtp? (
		>=net-libs/libsrtp-2.5.0
	)
	system-usrsctp? (
		>=net-libs/usrsctp-0.9.5.0
	)
"
DEPEND="
	${RDEPEND}
	examples? (
		>=dev-cpp/nlohmann_json-3.11.3
	)
"
BDEPEND="
	>=dev-build/cmake-3.12
	virtual/pkgconfig
"

src_unpack() {
	unpack ${A}
	rm -rf "${S}/deps" || die
	mkdir -p "${S}/deps" || die
	if use system-json ; then
		mv -v \
			"${WORKDIR}/json-${NLOHMANN_JSON_COMMIT}" \
			"${S}/deps/json" \
			|| die
	fi
	if use system-juice ; then
		mv -v \
			"${WORKDIR}/libjuice-${LIBJUICE_COMMIT}" \
			"${S}/deps/libjuice" \
			|| die
	fi
	if use system-srtp ; then
		mv -v \
			"${WORKDIR}/libsrtp-${LIBSRTP_COMMIT}" \
			"${S}/deps/libsrtp" \
			|| die
	fi
	if use system-plog ; then
		mv -v \
			"${WORKDIR}/plog-${PLOG_COMMIT}" \
			"${S}/deps/plog" \
			|| die
	fi
	if use system-usrsctp ; then
		mv -v \
			"${WORKDIR}/usrsctp-${USRSCTP_COMMIT}" \
			"${S}/deps/usrsctp" \
			|| die
	fi
}

src_configure() {
	if use gnutls && ! use nettle ; then
ewarn "Upstream has nettle default ON when gnutls is ON"
	fi
	if ! use gnutls && use nettle ; then
ewarn "Upstream has nettle default OFF when gnutls is OFF"
	fi
        local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
		-DPREFER_SYSTEM_LIB=ON
		-DNO_EXAMPLES=$(usex !examples)
		-DNO_TESTS=$(usex !test)
		-DNO_MEDIA=$(usex !media-transport)
		-DNO_WEBSOCKET=$(usex !websocket)
		-DUSE_GNUTLS=$(usex gnutls)
		-DUSE_MBEDTLS=$(usex mbedtls)
		-DUSE_NETTLE=$(usex nettle)
		-DUSE_NICE=ON
		-DUSE_SYSTEM_PLOG=ON
		-DUSE_SYSTEM_SRTP=ON
		-DUSE_SYSTEM_USRSCTP=ON
		-DSCTP_DEBUG=$(usex debug)
        )
        cmake_src_configure
}
