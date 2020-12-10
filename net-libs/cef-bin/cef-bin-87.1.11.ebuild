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
RDEPEND="
	>=x11-libs/gtk+-2.24.32:2
	>=x11-libs/gtkglext-1.2.0
"
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
