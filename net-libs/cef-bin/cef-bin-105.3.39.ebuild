# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Builds also the libcef_dll_wrapper
# The -bin in ${PN} comes from the prebuilt chromium

EAPI=8

VIRTUALX_REQUIRED="manual"
inherit chromium-2 cmake flag-o-matic virtualx

DESCRIPTION="Chromium Embedded Framework (CEF). A simple framework for embedding Chromium-based browsers in other applications."
LICENSE="BSD"
HOMEPAGE="https://bitbucket.org/chromiumembedded/cef/src/master/"
KEYWORDS="~arm ~arm64 ~amd64"
# The download page can be found at https://cef-builds.spotifycdn.com/index.html

CEF_VERSION_RAW="09/15/2022 - 105.3.39+g2ec21f9+chromium-105.0.5195.127 / Chromium 105.0.5195.127"
CHROMIUM_V="${CEF_VERSION_RAW##* }" # same as https://bitbucket.org/chromiumembedded/cef/src/2ec21f9/CHROMIUM_BUILD_COMPATIBILITY.txt?at=5195
CEF_COMMIT="${CEF_VERSION_RAW#*\+}" # same as https://bitbucket.org/chromiumembedded/cef/commits/
CEF_COMMIT="${CEF_COMMIT%\+*}"
CEF_COMMIT="${CEF_COMMIT:1:7}"

TARBALL_SUFFIX="" # can be _beta or "" (stable)
SRC_URI="
	elibc_glibc? (
		amd64? (
			minimal? ( https://cef-builds.spotifycdn.com/cef_binary_${PV}%2Bg${CEF_COMMIT}%2Bchromium-${CHROMIUM_V}_linux64${TARBALL_SUFFIX}_minimal.tar.bz2 )
			!minimal? ( https://cef-builds.spotifycdn.com/cef_binary_${PV}%2Bg${CEF_COMMIT}%2Bchromium-${CHROMIUM_V}_linux64${TARBALL_SUFFIX}.tar.bz2 )
		)
		arm? (
			minimal? ( https://cef-builds.spotifycdn.com/cef_binary_${PV}%2Bg${CEF_COMMIT}%2Bchromium-${CHROMIUM_V}_linuxarm${TARBALL_SUFFIX}_minimal.tar.bz2 )
			!minimal? ( https://cef-builds.spotifycdn.com/cef_binary_${PV}%2Bg${CEF_COMMIT}%2Bchromium-${CHROMIUM_V}_linuxarm${TARBALL_SUFFIX}.tar.bz2 )
		)
		arm64? (
			minimal? ( https://cef-builds.spotifycdn.com/cef_binary_${PV}%2Bg${CEF_COMMIT}%2Bchromium-${CHROMIUM_V}_linuxarm64${TARBALL_SUFFIX}_minimal.tar.bz2 )
			!minimal? ( https://cef-builds.spotifycdn.com/cef_binary_${PV}%2Bg${CEF_COMMIT}%2Bchromium-${CHROMIUM_V}_linuxarm64${TARBALL_SUFFIX}.tar.bz2 )
		)
	)
"

SLOT="0/${PV}"
IUSE+=" cefclient cefsimple debug minimal test"
REQUIRED_USE+="
	cefclient? ( !minimal )
	cefsimple? ( !minimal )
	test? ( !minimal )
"
# *DEPENDs based on install-build-deps.sh
# U >=16.04 LTS assumed, supported only in CEF
# The *DEPENDs below assume U 18.04
# For details see:
# Chromium runtime:  https://github.com/chromium/chromium/blob/105.0.5195.127/build/install-build-deps.sh#L237
# Chromium buildtime:  https://github.com/chromium/chromium/blob/105.0.5195.127/build/install-build-deps.sh#L151
GLIB_V="2.48"
XI_V="1.7.6"
CHROMIUM_CDEPEND="
	>=app-accessibility/at-spi2-atk-2.18.3
	>=app-accessibility/speech-dispatcher-0.8.3
	>=dev-db/sqlite-3.11
	>=dev-libs/glib-${GLIB_V}:2
	>=dev-libs/libappindicator-12.10
	>=dev-libs/libevdev-1.4.6
	>=dev-libs/libffi-3.2.1
	>=media-libs/alsa-lib-1.1.0
	>=media-libs/mesa-11.2.0[gbm(+)]
	>=net-print/cups-2.1.3
	>=sys-apps/pciutils-3.3.1
	>=sys-libs/libcap-2.24
	>=sys-libs/pam-1.1.8
	>=sys-apps/util-linux-2.27.1
	>=sys-libs/glibc-2.23
	>=x11-libs/cairo-1.14.6
	>=x11-libs/gtk+-3.18.9:3
	>=x11-libs/libXtst-1.2.2
	>=x11-libs/libdrm-2.4.67
"
# Unlisted based on ldd inspection not found in common_lib_list
UNLISTED_RDEPEND="
	dev-libs/fribidi
	dev-libs/gmp
	dev-libs/libbsd
	dev-libs/libtasn1
	dev-libs/libunistring
	>=dev-libs/nss-3.21
	dev-libs/nettle
	media-gfx/graphite2
	media-libs/harfbuzz
	media-libs/libglvnd
	>=media-libs/mesa-11.2.0[egl(+)]
	net-dns/libidn
	>=x11-libs/libxkbcommon-0.5.0
"
OPTIONAL_RDEPEND="
	>=gnome-base/gnome-keyring-3.36[pam]
	>=media-libs/vulkan-loader-1.0.8.0
"
CHROMIUM_RDEPEND="
	${CHROMIUM_CDEPEND}
	${UNLISTED_RDEPEND}
	${OPTIONAL_RDEPEND}
	>=dev-libs/atk-2.18.0
	>=dev-libs/expat-2.1.0
	>=dev-libs/libpcre-8.38
	>=dev-libs/nspr-4.11
	  dev-libs/wayland
	>=media-libs/fontconfig-2.11.94
	>=media-libs/freetype-2.6.1
	>=media-libs/libpng-1.6.20
	>=sys-devel/gcc-5.4.0[cxx(+)]
	>=x11-libs/libX11-1.6.3
	>=x11-libs/libXau-1.0.8
	>=x11-libs/libxcb-1.6.3
	>=x11-libs/libXcomposite-0.4.4
	>=x11-libs/libXcursor-1.1.14
	>=x11-libs/libXdamage-1.1.4
	>=x11-libs/libXdmcp-1.1.2
	>=x11-libs/libXext-1.3.3
	>=x11-libs/libXfixes-5.0.1
	>=x11-libs/libXi-${XI_V}
	>=x11-libs/libXinerama-1.1.3
	>=x11-libs/libXrandr-1.5.0
	>=x11-libs/libXrender-0.9.9
	>=x11-libs/pango-1.38.1
	>=x11-libs/pixman-0.33.6
	>=sys-libs/zlib-1.2.8
"
# libcef alone uses aura not gtk
RDEPEND+="
	${CHROMIUM_RDEPEND}
	cefclient? (
		>=dev-libs/glib-${GLIB_V}:2
		>=x11-libs/gtk+-3:3
		>=x11-libs/gtkglext-1.2.0
		>=x11-libs/libXi-${XI_V}
	)
"
DEPEND+="
	test? (
		>=dev-libs/glib-${GLIB_V}:2
	)
"
GCC_PV_MIN="7.5"
CLANG_PV_MIN="12"
BDEPEND+="
	>=dev-util/cmake-3.10.2
	|| (
		>=sys-devel/gcc-${GCC_PV_MIN}
		>=sys-devel/clang-${CLANG_PV_MIN}
	)
	test? (
		x11-base/xorg-server[xvfb]
		x11-apps/xhost
	)
"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/cef-bin-105.3.39-visibility-changes.patch"
)
S="${WORKDIR}" # Dummy

get_xrid() {
	if use elibc_glibc && [[ "${ABI}" == "amd64" ]] ; then
		echo "linux64"
	elif use elibc_glibc && [[ "${ABI}" == "x86" ]] ; then
		echo "linux32"
	elif use elibc_glibc && [[ "${ABI}" == "arm64" ]] ; then
		echo "linuxarm64"
	elif ( use elibc_Darwin || use elibc_Cygwin ) && [[ "${ABI}" == "amd64" ]] ; then
		echo "macos64"
	elif ( use elibc_Darwin || use elibc_Cygwin ) && [[ "${ABI}" == "arm64" ]] ; then
		echo "macosarm64"
	elif ( use elibc_Winnt || use elibc_Cygwin ) && [[ "${ABI}" == "amd64" ]] ; then
		echo "windows64"
	elif ( use elibc_Winnt || use elibc_Cygwin ) && [[ "${ABI}" == "arm64" ]] ; then
		echo "windowsarm64"
	fi
}

S_abi() {
	local minimal=$(usex minimal "_minimal" "")
	echo "${WORKDIR}/cef_binary_${PV}+g${CEF_COMMIT}+chromium-${CHROMIUM_V}_$(get_xrid)${TARBALL_SUFFIX}${minimal}"
}

append_all() {
	append-flags ${@}
	append-ldflags ${@}
}

# See https://bitbucket.org/chromiumembedded/cef/issues/3362/allow-c-17-features-in-cef-binary
CXX_VER="17"
check_compiler() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	einfo "CC=${CC} CXX=${CXX}"
	test-flags-CXX "-std=c++${CXX_VER}" 2>/dev/null 1>/dev/null || die "Switch to a c++${CXX_VER} compatible compiler."
	if tc-is-gcc ; then
		if ver_test $(gcc-major-version) -lt ${GCC_PV_MIN} ; then
			die "${PN} requires GCC >=${GCC_PV_MIN} for c++${CXX_VER} support"
		fi
	elif tc-is-clang ; then
		if ver_test $(clang-version) -lt ${CLANG_PV_MIN} ; then
			die "${PN} requires Clang >=${CLANG_PV_MIN} for c++${CXX_VER} support"
		fi
	else
		die "Compiler is not supported"
	fi
}

pkg_setup() {
	chromium_suid_sandbox_check_kernel_config
	if use test ; then
		if [[ "${FEATURES}" =~ (^| )"sandbox" ]] ; then
eerror
eerror "-sandbox must be added to FEATURES to use the test USE flag."
eerror
			die
		fi
ewarn
ewarn "The test is expected to fail.  To install, add test-fail-continue to"
ewarn "FEATURES as a per package envvar."
ewarn
	fi
}

src_prepare() {
	export CMAKE_USE_DIR=$(S_abi)
	einfo "CMAKE_USE_DIR=${CMAKE_USE_DIR}"
	cd "${CMAKE_USE_DIR}" || die
	cmake_src_prepare
	if use minimal ; then
		rm -rf "${CMAKE_USE_DIR}/tests" || die
	fi
	if ! use test ; then
		rm -rf "${CMAKE_USE_DIR}/tests" || die
	fi
}

src_configure() {
	export CMAKE_USE_DIR=$(S_abi)
	export BUILD_DIR=$(S_abi)
	check_compiler
	strip-unsupported-flags
	filter-flags \
		'-f*sanitize*' \
		'-f*visibility*' \
		'-march=*' \
		'-O*'

	if has_version "sys-libs/compiler-rt-sanitizers[cfi,ubsan]" ; then
		# Link to UBSan indirectly to avoid missing symbols like these
		# when linking to CFI .so files:
		# undefined reference to __ubsan_handle_cfi_check_fail_abort
		append-ldflags -Wl,-lubsan
		:;
	fi

	export CMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
	export CMAKE_USE_DIR=$(S_abi)
	export BUILD_DIR=$(S_abi)
	cd "${CMAKE_USE_DIR}" || die
	mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
	)
einfo "DIR="$(pwd)
	cmake_src_configure
einfo "DIR="$(pwd)

	if use test ; then
ewarn
ewarn "Adding sandbox exceptions for the GPU."
ewarn
		local d
		for d in /dev/dri/card*; do
			einfo "addwrite ${d}"
			addwrite "${d}"
		done
		for d in /dev/dri/render*; do
			einfo "addwrite ${d}"
			addwrite "${d}"
		done
	fi
}

src_compile() {
	export CMAKE_USE_DIR=$(S_abi)
	export BUILD_DIR=$(S_abi)
	cd "${BUILD_DIR}" || die
	cmake_src_compile \
		libcef_dll_wrapper \
		$(usex cefclient "cefclient" "") \
		$(usex cefsimple "cefsimple" "") \
		$(usex test "ceftests" "")
	if [[ -f "${BUILD_DIR}/tests/ceftests/Release/chrome-sandbox" ]] && use test ; then
		chmod 4755 "${BUILD_DIR}/tests/ceftests/Release/chrome-sandbox" || die
	fi
}

src_test() {
	ewarn "This test failed on 87.1.12+g03f9336+chromium-87.0.4280.88"
	export CMAKE_USE_DIR=$(S_abi)
	export BUILD_DIR=$(S_abi)
	cd "${BUILD_DIR}" || die
	local build_type=$(usex debug "Debug" "Release")
	if use test ; then
		cd "${BUILD_DIR}/tests/ceftests/${build_type}" || die
		# If it fails, it is likely an upstream problem
		LD_LIBRARY_PATH="../../../libcef_dll_wrapper:../../../tests/gtest" \
		virtx ./ceftests --no-sandbox
	fi
}

src_install() {
	export CMAKE_USE_DIR=$(S_abi)
	export BUILD_DIR=$(S_abi)
	cd "${BUILD_DIR}" || die
	dodir "/opt/${PN}"
	cp -rT "${BUILD_DIR}" "${ED}/opt/${PN}" || die
	local minimal=$(usex minimal "_minimal" "")
	echo "cef_binary_${PV}+g${CEF_COMMIT}+chromium-${CHROMIUM_V}_$(get_xrid)${minimal}" \
		> "${ED}/opt/${PN}/.version" || die
	find "${ED}" -name "*.o" -delete
}

pkg_postinst() {
ewarn
ewarn "Security notice:"
ewarn
ewarn "This package needs to be updated at the same time as your Chromium web"
ewarn "browser to avoid the same critical vulnerabilities."
ewarn
ewarn "Some parts such as libcef_dll_wrapper.so are not CFI protected and"
ewarn "cannot be Cross-DSO CFI protected at this time."
ewarn
ewarn "But, the prebuilt parts may be CFI Basic protected for the .so files"
ewarn "which may not require CFI symbols."
ewarn
ewarn "Even though problems may be resolved, it will still not get full."
ewarn "protection cfi-icall would be disabled for some parts."
ewarn "shadow-call-stack (backward edge protection) applied to these binaries"
ewarn "is unknown."
ewarn
ewarn "For full protection, use the regular browser bin package instead."
ewarn
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
