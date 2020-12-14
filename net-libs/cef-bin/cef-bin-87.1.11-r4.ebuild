# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Builds also the libcef_dll_wrapper
# The -bin in ${PN} comes from the prebuilt chromium

EAPI=7

inherit cmake-utils flag-o-matic multilib-minimal

DESCRIPTION="Chromium Embedded Framework (CEF). A simple framework for embedding Chromium-based browsers in other applications."
LICENSE="BSD"
HOMEPAGE="https://bitbucket.org/chromiumembedded/cef/src/master/"
CHROMIUM_V="87.0.4280.66"
CEF_COMMIT="g8bb7705"
SRC_URI="
	x86? (
		minimal? ( https://cef-builds.spotifycdn.com/cef_binary_${PV}%2B${CEF_COMMIT}%2Bchromium-${CHROMIUM_V}_linux32_minimal.tar.bz2 )
		!minimal? ( https://cef-builds.spotifycdn.com/cef_binary_${PV}%2B${CEF_COMMIT}%2Bchromium-${CHROMIUM_V}_linux32.tar.bz2 )
	)
	amd64? (
		minimal? ( https://cef-builds.spotifycdn.com/cef_binary_${PV}%2B${CEF_COMMIT}%2Bchromium-${CHROMIUM_V}_linux32_minimal.tar.bz2 )
		!minimal? ( https://cef-builds.spotifycdn.com/cef_binary_${PV}%2B${CEF_COMMIT}%2Bchromium-${CHROMIUM_V}_linux64.tar.bz2 )
	)
	arm? (
		minimal? ( https://cef-builds.spotifycdn.com/cef_binary_${PV}%2B${CEF_COMMIT}%2Bchromium-${CHROMIUM_V}_linuxarm_minimal.tar.bz2 )
		!minimal? ( https://cef-builds.spotifycdn.com/cef_binary_${PV}%2B${CEF_COMMIT}%2Bchromium-${CHROMIUM_V}_linuxarm.tar.bz2 )
	)
	arm64? (
		minimal? ( https://cef-builds.spotifycdn.com/cef_binary_${PV}%2B${CEF_COMMIT}%2Bchromium-${CHROMIUM_V}_linuxarm64_minimal.tar.bz2 )
		!minimal? ( https://cef-builds.spotifycdn.com/cef_binary_${PV}%2B${CEF_COMMIT}%2Bchromium-${CHROMIUM_V}_linuxarm64.tar.bz2 )
	)
"

SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="debug minimal"
# Based on install-build-deps.sh
# U >=16.04 LTS assumed, supported only in cef
# For details see:
# https://chromium.googlesource.com/chromium/src/+/master/build/install-build-deps.sh?format=TEXT
# TODO: app-accessibility/speech-dispatcher needs multilib
CHROMIUM_CDEPEND="
	>=app-accessibility/at-spi2-atk-2.18.3[${MULTILIB_USEDEP}]
	>=app-accessibility/speech-dispatcher-0.8.3
	>=dev-db/sqlite-3.11[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.48:2[${MULTILIB_USEDEP}]
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
	>=x11-libs/libXi-1.7.6[${MULTILIB_USEDEP}]
	>=x11-libs/libXinerama-1.1.3[${MULTILIB_USEDEP}]
	>=x11-libs/libXrandr-1.5.0[${MULTILIB_USEDEP}]
	>=x11-libs/libXrender-0.9.9[${MULTILIB_USEDEP}]
	>=x11-libs/libxcb-1.6.3[${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.38.1[${MULTILIB_USEDEP}]
	>=x11-libs/pixman-0.33.6[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8[${MULTILIB_USEDEP}]"
RDEPEND="${CHROMIUM_RDEPEND}
	>=x11-libs/gtk+-2.24.32:2[${MULTILIB_USEDEP}]
	>=x11-libs/gtkglext-1.2.0[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-util/cmake-3.10.2"
S="${WORKDIR}"

_SUFFIX=""
abi_to_suffix() {
	if [[ "${ABI}" == "x86" ]] ; then
		_SUFFIX="linux32"
	elif [[ "${ABI}" == "amd64" ]] ; then
		_SUFFIX="linux64"
	elif [[ "${ABI}" == "arm" ]] ; then
		_SUFFIX="arm"
	elif [[ "${ABI}" == "arm64" ]] ; then
		_SUFFIX="arm64"
	fi
}

src_prepare() {
	prepare_abi() {
		abi_to_suffix
		local d="cef_binary_${PV}+${CEF_COMMIT}+chromium-${CHROMIUM_V}_${_SUFFIX}"
		cd "${WORKDIR}/${d}" || die
		eapply -p1 "${FILESDIR}/cef-bin-87.1.11-disable-visibility-hidden.patch"
		S="${WORKDIR}/${d}" CMAKE_USE_DIR="${WORKDIR}/${d}" \
		BUILD_DIR="${WORKDIR}/${d}" \
		cmake-utils_src_prepare
	}
	multilib_foreach_abi prepare_abi
}

src_configure() {
	strip-flags
	filter-flags -march=* -O*

	export CMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
	configure_abi() {
		abi_to_suffix
		local d="cef_binary_${PV}+${CEF_COMMIT}+chromium-${CHROMIUM_V}_${_SUFFIX}"
		cd "${WORKDIR}/${d}" || die
		S="${WORKDIR}/${d}" CMAKE_USE_DIR="${WORKDIR}/${d}" \
		BUILD_DIR="${WORKDIR}/${d}" \
		cmake-utils_src_configure
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		abi_to_suffix
		local d="cef_binary_${PV}+${CEF_COMMIT}+chromium-${CHROMIUM_V}_${_SUFFIX}"
		cd "${WORKDIR}/${d}" || die
		S="${WORKDIR}/${d}" CMAKE_USE_DIR="${WORKDIR}/${d}" \
		BUILD_DIR="${WORKDIR}/${d}" \
		cmake-utils_src_compile
	}
	multilib_foreach_abi compile_abi
}

src_install() {
	install_abi() {
		dodir "/opt/${PN}/${ABI}"
		abi_to_suffix
		local d="cef_binary_${PV}+${CEF_COMMIT}+chromium-${CHROMIUM_V}_${_SUFFIX}"
		cp -rT "${WORKDIR}/${d}" "${ED}/opt/${PN}/${ABI}" || die
		echo "${d}" > "${ED}/opt/${PN}/${ABI}/.version" || die
	}
	multilib_foreach_abi install_abi
}

pkg_postinst() {
	ewarn
	ewarn "Security notice:"
	ewarn "This package needs to be updated at the same time as your Chromium web browser"
	ewarn "to avoid the same critical vulnerabilities."
	ewarn
	einfo
	einfo "Packager notes:"
	einfo "Use a LD_LIBRARY_PATH wrapper to use this package."
	einfo
}
