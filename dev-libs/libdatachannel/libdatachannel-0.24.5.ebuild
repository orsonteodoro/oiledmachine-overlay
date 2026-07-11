# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 22.04

CFLAGS_HARDENED_USE_CASES="network security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CRSH DP RC UAF"

CXX_STANDARD=17

LIBJUICE_COMMIT="3c40a3545b6b1b62c7adee7f8f2bd58aa290afd6"
LIBSRTP_COMMIT="24b3bf8f19b6f5ab4cd2bcceb4f4064efca86fd5"
NLOHMANN_JSON_COMMIT="55f93686c01528224f448c19128836e7df245f72"
PLOG_COMMIT="94899e0b926ac1b0f4750bfbd495167b4a6ae9ef"
USRSCTP_COMMIT="fec583d54493f879d2ae44a743423bf8a04371ab"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

CHKL_TIMESTAMPS=(
	"dev-libs/openssl-4.0.9999"
	"dev-libs/openssl-3.6.9999"
	"dev-libs/openssl-3.5.9999"
	"dev-libs/openssl-3.4.9999"
	"dev-libs/openssl-3.0.9999"
)

inherit cflags-hardened chkl cmake libcxx-slot libstdcxx-slot secure-version

KEYWORDS="amd64"
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
		>=net-libs/libnice-0.1.18:=
	)
	openssl? (
		$(secure-version_gen_openssl_depends)
	)
	system-plog? (
		>=dev-cpp/plog-1.1.10:=
	)
	system-srtp? (
		>=net-libs/libsrtp-${LIBSRTP_2_PV}:2=
	)
	system-usrsctp? (
		>=net-libs/usrsctp-0.9.5.0:=
	)
"
DEPEND="
	${RDEPEND}
	examples? (
		>=dev-cpp/nlohmann_json-${NLOHMANN_JSON_PV}:=
	)
"
BDEPEND="
	>=dev-build/cmake-3.13
	virtual/pkgconfig
"

pkg_setup() {
	libcxx-slot_append
	libstdcxx-slot_append
}

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
	chkl_check_many_timestamps
	cflags-hardened_append
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
