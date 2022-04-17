# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Builds also the libcef_dll_wrapper
# The -bin in ${PN} comes from the prebuilt chromium

EAPI=7

VIRTUALX_REQUIRED="manual"
inherit cmake-utils flag-o-matic multilib-minimal virtualx

DESCRIPTION="Chromium Embedded Framework (CEF). A simple framework for embedding Chromium-based browsers in other applications."
LICENSE="BSD"
HOMEPAGE="https://bitbucket.org/chromiumembedded/cef/src/master/"
KEYWORDS="~arm ~arm64 ~amd64 ~x86"
# The download page can be found at https://cef-builds.spotifycdn.com/index.html

CEF_VERSION_RAW="04/15/2022 - 100.0.23+ga1e2187+chromium-100.0.4896.127 / Chromium 100.0.4896.127"
CHROMIUM_V="${CEF_VERSION_RAW##* }" # same as https://bitbucket.org/chromiumembedded/cef/src/4e5ba66/CHROMIUM_BUILD_COMPATIBILITY.txt?at=4844
CEF_COMMIT="${CEF_VERSION_RAW#*\+}" # same as https://bitbucket.org/chromiumembedded/cef/commits/
CEF_COMMIT="${CEF_COMMIT%\+*}"
CEF_COMMIT="${CEF_COMMIT:1:7}"

TARBALL_SUFFIX="" # can be _beta or "" (stable)
SRC_URI="
	x86? (
		minimal? ( https://cef-builds.spotifycdn.com/cef_binary_${PV}%2Bg${CEF_COMMIT}%2Bchromium-${CHROMIUM_V}_linux32${TARBALL_SUFFIX}_minimal.tar.bz2 )
		!minimal? ( https://cef-builds.spotifycdn.com/cef_binary_${PV}%2Bg${CEF_COMMIT}%2Bchromium-${CHROMIUM_V}_linux32${TARBALL_SUFFIX}.tar.bz2 )
	)
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
	)"
SLOT="0/${PV}"
IUSE+=" cefclient cefsimple debug minimal test"
REQUIRED_USE+="
	cefclient? ( !minimal )
	cefsimple? ( !minimal )
	test? ( !minimal )"
# *DEPENDs based on install-build-deps.sh
# U >=16.04 LTS assumed, supported only in CEF
# The *DEPENDs below assume U 18.04
# For details see:
# Chromium runtime:  https://github.com/chromium/chromium/blob/100.0.4896.127/build/install-build-deps.sh#L237
# Chromium buildtime:  https://github.com/chromium/chromium/blob/100.0.4896.127/build/install-build-deps.sh#L151
# TODO: app-accessibility/speech-dispatcher needs multilib
GLIB_V="2.48"
XI_V="1.7.6"
CHROMIUM_CDEPEND="
	>=app-accessibility/at-spi2-atk-2.18.3[${MULTILIB_USEDEP}]
	>=app-accessibility/speech-dispatcher-0.8.3
	>=dev-db/sqlite-3.11[${MULTILIB_USEDEP}]
	>=dev-libs/glib-${GLIB_V}:2[${MULTILIB_USEDEP}]
	>=dev-libs/libappindicator-12.10[${MULTILIB_USEDEP}]
	>=dev-libs/libevdev-1.4.6[${MULTILIB_USEDEP}]
	>=dev-libs/libffi-3.2.1[${MULTILIB_USEDEP}]
	>=net-print/cups-2.1.3[${MULTILIB_USEDEP}]
	>=sys-apps/pciutils-3.3.1[${MULTILIB_USEDEP}]
	>=sys-libs/libcap-2.24[${MULTILIB_USEDEP}]
	>=sys-libs/pam-1.1.8[${MULTILIB_USEDEP}]
	>=media-libs/alsa-lib-1.1.0[${MULTILIB_USEDEP}]
	>=media-libs/mesa-11.2.0[gbm,${MULTILIB_USEDEP}]
	>=sys-apps/util-linux-2.27.1[${MULTILIB_USEDEP}]
	>=sys-libs/glibc-2.23
	>=x11-libs/cairo-1.14.6[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-3.18.9:3[${MULTILIB_USEDEP}]
	>=x11-libs/libXtst-1.2.2[${MULTILIB_USEDEP}]
	>=x11-libs/libdrm-2.4.67[${MULTILIB_USEDEP}]"
# Unlisted based on ldd inspection not found in common_lib_list
UNLISTED_RDEPEND="
	net-dns/libidn[${MULTILIB_USEDEP}]
	dev-libs/fribidi[${MULTILIB_USEDEP}]
	dev-libs/gmp[${MULTILIB_USEDEP}]
	dev-libs/libbsd[${MULTILIB_USEDEP}]
	dev-libs/libtasn1[${MULTILIB_USEDEP}]
	dev-libs/libunistring[${MULTILIB_USEDEP}]
	>=dev-libs/nss-3.21[${MULTILIB_USEDEP}]
	dev-libs/nettle[${MULTILIB_USEDEP}]
	media-gfx/graphite2[${MULTILIB_USEDEP}]
	media-libs/harfbuzz[${MULTILIB_USEDEP}]
	media-libs/libglvnd[${MULTILIB_USEDEP}]
	>=media-libs/mesa-11.2.0[egl,${MULTILIB_USEDEP}]
	>=x11-libs/libxkbcommon-0.5.0[${MULTILIB_USEDEP}]"
OPTIONAL_RDEPEND="
	>=gnome-base/libgnome-keyring-3.12[${MULTILIB_USEDEP}]
	>=media-libs/vulkan-loader-1.0.8.0[${MULTILIB_USEDEP}]"
CHROMIUM_RDEPEND="
	${CHROMIUM_CDEPEND}
	${UNLISTED_RDEPEND}
	${OPTIONAL_RDEPEND}
	>=sys-devel/gcc-5.4.0[cxx(+)]
	>=dev-libs/atk-2.18.0[${MULTILIB_USEDEP}]
	>=dev-libs/expat-2.1.0[${MULTILIB_USEDEP}]
	>=dev-libs/libpcre-8.38[${MULTILIB_USEDEP}]
	>=dev-libs/nspr-4.11[${MULTILIB_USEDEP}]
	dev-libs/wayland[${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.11.94[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.6.1[${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.6.20[${MULTILIB_USEDEP}]
	>=x11-libs/libX11-1.6.3[${MULTILIB_USEDEP}]
	>=x11-libs/libXau-1.0.8[${MULTILIB_USEDEP}]
	>=x11-libs/libXcomposite-0.4.4[${MULTILIB_USEDEP}]
	>=x11-libs/libXcursor-1.1.14[${MULTILIB_USEDEP}]
	>=x11-libs/libXdamage-1.1.4[${MULTILIB_USEDEP}]
	>=x11-libs/libXdmcp-1.1.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-1.3.3[${MULTILIB_USEDEP}]
	>=x11-libs/libXfixes-5.0.1[${MULTILIB_USEDEP}]
	>=x11-libs/libXi-${XI_V}[${MULTILIB_USEDEP}]
	>=x11-libs/libXinerama-1.1.3[${MULTILIB_USEDEP}]
	>=x11-libs/libXrandr-1.5.0[${MULTILIB_USEDEP}]
	>=x11-libs/libXrender-0.9.9[${MULTILIB_USEDEP}]
	>=x11-libs/libxcb-1.6.3[${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.38.1[${MULTILIB_USEDEP}]
	>=x11-libs/pixman-0.33.6[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8[${MULTILIB_USEDEP}]"
# libcef alone uses aura not gtk
RDEPEND+=" ${CHROMIUM_RDEPEND}
	cefclient? (
		>=dev-libs/glib-${GLIB_V}:2[${MULTILIB_USEDEP}]
		>=x11-libs/gtk+-3:3[${MULTILIB_USEDEP}]
		>=x11-libs/gtkglext-1.2.0[${MULTILIB_USEDEP}]
		>=x11-libs/libXi-${XI_V}[${MULTILIB_USEDEP}]
	)"
DEPEND+="
	test? (
		>=dev-libs/glib-${GLIB_V}:2[${MULTILIB_USEDEP}]
	)"
BDEPEND+="
	test? ( ${VIRTUALX_DEPEND} )
	>=dev-util/cmake-3.10.2"
RESTRICT="mirror"

S="${WORKDIR}"
declare -Ax ABIx=( \
        [x86]="linux32" \
        [amd64]="linux64" \
        [arm]="arm" \
        [arm64]="arm64" \
)

S_abi() {
	local minimal=$(usex minimal "_minimal" "")
	echo "${WORKDIR}/cef_binary_${PV}+g${CEF_COMMIT}+chromium-${CHROMIUM_V}_${ABIx[${ABI}]}${TARBALL_SUFFIX}${minimal}"
}

append_all() {
	append-flags ${@}
	append-ldflags ${@}
}

pkg_setup() {
	if use test ; then
		if [[ "${FEATURES}" =~ sandbox ]] ; then
eerror
eerror "-sandbox must be added to FEATURES to use the test USE flag."
eerror
			die
		fi
		ewarn \
"The test is expected to fail.  To install, add test-fail-continue to\n\
FEATURES as a per package envvar."
	fi
}

src_prepare() {
	prepare_abi() {
		S=$(S_abi)
		cd "${S}" || die
		eapply "${FILESDIR}/cef-bin-93.1.11-visibility-changes.patch"
		CMAKE_USE_DIR="${S}" BUILD_DIR="${S}" \
		cmake-utils_src_prepare
	}
	multilib_foreach_abi prepare_abi
}

src_configure() {
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
	configure_abi() {
		S=$(S_abi)
		cd "${S}" || die
		mycmakeargs=(
			-DBUILD_SHARED_LIBS=ON
		)
		CMAKE_USE_DIR="${S}" BUILD_DIR="${S}" \
		cmake-utils_src_configure
	}
	multilib_foreach_abi configure_abi
	if use test ; then
ewarn
ewarn "Adding sandbox exceptions for the GPU."
ewarn
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
	compile_abi() {
		S=$(S_abi)
		cd "${S}" || die
		CMAKE_USE_DIR="${S}" BUILD_DIR="${S}" \
		cmake-utils_src_compile \
			libcef_dll_wrapper \
			$(usex cefclient cefclient "") \
			$(usex cefsimple cefsimple "") \
			$(usex test ceftests "")
		if [[ -f "${S}/tests/ceftests/Release/chrome-sandbox" ]] && use test ; then
			chmod 4755 "${S}/tests/ceftests/Release/chrome-sandbox"
		fi
	}
	multilib_foreach_abi compile_abi
}

src_test() {
	ewarn "This test failed on 87.1.12+g03f9336+chromium-87.0.4280.88"
	test_abi() {
		S=$(S_abi)
		local build_type=$(usex debug "Debug" "Release")
		if use test ; then
			cd "${S}/tests/ceftests/${build_type}" || die
			# If it fails, it is likely an upstream problem
			LD_LIBRARY_PATH="../../../libcef_dll_wrapper:../../../tests/gtest" \
			virtx ./ceftests --no-sandbox
		fi
	}
	multilib_foreach_abi test_abi
}

src_install() {
	install_abi() {
		dodir "/opt/${PN}/${ABI}"
		S=$(S_abi)
		cp -rT "${S}" "${ED}/opt/${PN}/${ABI}" || die
		echo "cef_binary_${PV}+g${CEF_COMMIT}+chromium-${CHROMIUM_V}_${ABIx[${ABI}]}" \
			> "${ED}/opt/${PN}/${ABI}/.version" || die
	}
	multilib_foreach_abi install_abi
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
