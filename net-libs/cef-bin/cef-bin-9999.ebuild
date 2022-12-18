# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild is provided to reduce ebuild security update lag.
# Always update it weekly.

# Builds also the libcef_dll_wrapper
# The -bin in ${PN} comes from the prebuilt chromium

VIRTUALX_REQUIRED="manual"
inherit chromium-2 cmake flag-o-matic virtualx

DESCRIPTION="Chromium Embedded Framework (CEF). A simple framework for embedding Chromium-based browsers in other applications."
LICENSE="BSD"
HOMEPAGE="https://bitbucket.org/chromiumembedded/cef/src/master/"
KEYWORDS="~arm ~arm64 ~amd64"
# The download page can be found at https://cef-builds.spotifycdn.com/index.html

SLOT="0/${PV}"
IUSE+=" beta cefclient cefsimple debug minimal test"
REQUIRED_USE+="
	cefclient? ( !minimal )
	cefsimple? ( !minimal )
	test? ( !minimal )
"
# *DEPENDs based on install-build-deps.sh
# U >=16.04 LTS assumed, supported only in CEF
# The *DEPENDs below assume U 18.04
# For details see:
# Chromium runtime:  https://github.com/chromium/chromium/blob/108.0.5359.71/build/install-build-deps.sh#L237
# Chromium buildtime:  https://github.com/chromium/chromium/blob/108.0.5359.71/build/install-build-deps.sh#L151
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
	>=dev-libs/nss-3.21
	>=media-libs/mesa-11.2.0[egl(+)]
	>=x11-libs/libxkbcommon-0.5.0
	dev-libs/fribidi
	dev-libs/gmp
	dev-libs/libbsd
	dev-libs/libtasn1
	dev-libs/libunistring
	dev-libs/nettle
	media-gfx/graphite2
	media-libs/harfbuzz
	media-libs/libglvnd
	net-dns/libidn
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
	dev-libs/wayland
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
INTEGRITY_CHECK_BDEPEND="
	app-crypt/rhash
	app-misc/jq
" # From ebuild dev
BDEPEND+="
	${INTEGRITY_CHECK_BDEPEND}
	>=dev-util/cmake-3.10.2
	test? (
		x11-base/xorg-server[xvfb]
		x11-apps/xhost
	)
	|| (
		>=sys-devel/gcc-${GCC_PV_MIN}
		>=sys-devel/clang-${CLANG_PV_MIN}
	)
"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/cef-bin-105.3.39-visibility-changes.patch"
)
S="${WORKDIR}" # Dummy

get_xrid() {
	if use kernel_linux && use elibc_glibc [[ "${ABI}" == "amd64" ]] ; then
		echo "linux64"
	elif use kernel_linux && use elibc_glibc [[ "${ABI}" == "x86" ]] ; then
		echo "linux32"
	elif use kernel_linux && use elibc_glibc && [[ "${ABI}" == "arm64" ]] ; then
		echo "linuxarm64"
	elif ( use elibc_Darwin || use elibc_Cygwin ) && [[ "${ABI}" == "amd64" ]] ; then
		echo "macos64"
	elif ( use elibc_Darwin || use elibc_Cygwin ) && [[ "${ABI}" == "arm64" ]] ; then
		echo "macosarm64"
	elif ( use elibc_Winnt || use elibc_Cygwin ) && [[ "${ABI}" == "amd64" ]] ; then
		echo "windows64"
	elif ( use elibc_Winnt || use elibc_Cygwin ) && [[ "${ABI}" == "arm64" ]] ; then
		echo "windowsarm64"
	else
		die "LIBC or ABI not supported"
	fi
}

S_abi() {
	local minimal=$(usex minimal "_minimal" "")
	local configuration=$(usex beta "_beta" "")
	local suffix="$(get_xrid)${configuration}${minimal}"
	local version="${MY_PV}+g${CEF_COMMIT}+chromium-${CHROMIUM_PV}"
	echo "${WORKDIR}/cef_binary_${version}_${suffix}"
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
	test-flags-CXX "-std=c++${CXX_VER}" 2>/dev/null 1>/dev/null \
		|| die "Switch to a c++${CXX_VER} compatible compiler."
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
		if has "sandbox" ${FEATURES} ; then
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

	if [[ "${PV}" =~ 9999 ]] \
		&& has "network-sandbox" ${FEATURES} ; then
eerror
eerror "Network access required to download from a live source."
eerror
	fi
}

get_uri_tarball() {
	local minimal=""
	local xrid=$(get_xrid)
	local configuration=""
	use minimal && minimal="_minimal"
	use beta && configuration="_beta"
	local suffix="${xrid}${configuration}${minimal}"
	local version="${MY_PV}%2Bg${CEF_COMMIT}%2Bchromium-${CHROMIUM_PV}"
	local filename="cef_binary_${version}_${suffix}.tar.bz2"
	echo "https://cef-builds.spotifycdn.com/${filename}"
}

get_version_list() {
	# Necessary to get the CEF version.
	wget -O "${WORKDIR}/index.json" \
		"https://cef-builds.spotifycdn.com/index.json" || die
}

check_tarball_integrity() {
	local bn="${1}"
	local fatal="${2}"
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"

	[[ -n "${distdir}/${bn}" ]] || return 1
	[[ -n "${WORKDIR}/index.json" ]] || return 1

	[[ -n "${distdir}/${bn}.sha1" ]] || return 1
	[[ -n "${distdir}/${bn}.blake2b" ]] || return 1
	[[ -n "${distdir}/${bn}.sha512" ]] || return 1
	local actual_fingerprint_size_sha1=$(stat -c "%s" "${distdir}/${bn}.sha1")
	local expected_fingerprint_size_sha1="40"
	[[ "${actual_fingerprint_size_sha1}" != "${expected_fingerprint_size_sha1}" ]] \
		&& return 1

	local actual_fingerprint_size_blake2b=$(stat -c "%s" "${distdir}/${bn}.blake2b")
	local expected_fingerprint_size_blake2b="128"
	[[ "${actual_fingerprint_size_blake2b}" != "${expected_fingerprint_size_blake2b}" ]] \
		&& return 1

	local actual_fingerprint_size_sha512=$(stat -c "%s" "${distdir}/${bn}.sha512")
	local expected_fingerprint_size_sha512="128"
	[[ "${actual_fingerprint_size_sha512}" != "${expected_fingerprint_size_sha512}" ]] \
		&& return 1

	local actual_sha1=$(sha1sum "${distdir}/${bn}" \
		| cut -f 1 -d " ")
	local expected_sha1=$(cat "${distdir}/${bn}.sha1")
	local actual_blake2b=$(rhash --blake2b "${distdir}/${bn}" \
		| cut -f 1 -d " ")
	local actual_sha512=$(sha512sum "${distdir}/${bn}" \
		| cut -f 1 -d " ")
	local expected_blake2b=$(cat "${distdir}/${bn}.blake2b")
	local expected_sha512=$(cat "${distdir}/${bn}.sha512")
	if [[ "${actual_sha1}" != "${expected_sha1}" ]] ; then
eerror
eerror "Fingerprint mismatch"
eerror
eerror "Actual:\t${actual_sha1}"
eerror "Expected:\t${expected_sha1}"
eerror
		return 1
	fi
	if [[ "${actual_blake2b}" != "${expected_blake2b}" ]] ; then
eerror
eerror "Fingerprint mismatch"
eerror
eerror "Actual:\t${actual_blake2b}"
eerror "Expected:\t${expected_blake2b}"
eerror
		return 1
	fi
	if [[ "${actual_sha512}" != "${expected_sha512}" ]] ; then
eerror
eerror "Fingerprint mismatch"
eerror
eerror "Actual:\t${actual_sha512}"
eerror "Expected:\t${expected_sha512}"
eerror
		return 1
	fi

	local xrid=$(get_xrid)
	local expected_tarball_size=$(cat "${WORKDIR}/index.json" \
		| jq '.'${xrid}'.versions[].files | .[] | select(.sha1=="'${expected_sha1}'") | .size')
	local actual_tarball_size=$(stat -c "%s" "${distdir}/${bn}")
	if [[ "${actual_tarball_size}" != "${expected_tarball_size}" ]] ; then
eerror
eerror "Tarball size mismatch"
eerror
eerror "Actual:\t${actual_tarball_size}"
eerror "Expected:\t${expected_tarball_size}"
eerror
		return 1
	fi

	return 0
}

src_unpack() {
	local minimal=$(usex minimal "_minimal" "")
	local configuration=$(usex beta "_beta" "")
	local xrid=$(get_xrid)
	local fsuffix="${xrid}${configuration}${minimal}.tar.bz2"
	local bn=""

	get_version_list

	if use beta ; then
		local unstable_branch=$(git ls-remote https://bitbucket.org/chromiumembedded/cef.git \
			| grep -E -o -e "refs/heads/[0-9]+" \
			| grep -E -o -e "[0-9]+" \
			| sort -V \
			| tail -n 1)
		bn=$(cat "${WORKDIR}/index.json" \
			| grep -E -o -e "cef_binary[^\"]+${unstable_branch}[^\"]+\""  \
			| sort -V \
			| sed -e "s|\"||g" \
			| grep -e "${fsuffix}" \
			| tail -n 1)
	else
		local stable_branch=$(git ls-remote https://bitbucket.org/chromiumembedded/cef.git \
			| grep -E -o -e "refs/heads/[0-9]+" \
			| grep -E -o -e "[0-9]+" \
			| sort -V \
			| tail -n 2 \
			| head -n 1)
		bn=$(cat "${WORKDIR}/index.json" \
			| grep -E -o -e "cef_binary[^\"]+${stable_branch}[^\"]+\""  \
			| sort -V \
			| sed -e "s|\"||g" \
			| grep -e "${fsuffix}" \
			| tail -n 1)
	fi

	export CEF_COMMIT=$(echo "${bn}" \
		| grep -E -o -e "\+g[a-z0-f]{7}" \
		| sed -e "s|\+g||g")
	export CHROMIUM_PV=$(echo "${bn}" \
		| grep -E -o -e "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")
	export MY_PV=$(echo "${bn}" \
		| grep -E -o -e "[0-9]+\.[0-9]+\.[0-9]+\+" \
		| sed -e "s|\+||g")
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	local uri="https://cef-builds.spotifycdn.com/${bn}"
	if check_tarball_integrity "${bn}" ; then
einfo
einfo "Using cached tarball copy"
einfo
	else
		addwrite "${distdir}"
		wget -O "${distdir}/${bn}.sha1" "${uri}.sha1" || die
		wget -O "${distdir}/${bn}" "${uri}" || die
		local blake2b=$(rhash --blake2b "${distdir}/${bn}" \
			| cut -f 1 -d " ")
		local sha512=$(sha512sum "${distdir}/${bn}" \
			| cut -f 1 -d " ")
		echo -n "${blake2b}" > "${distdir}/${bn}.blake2b" || die
		echo -n "${sha512}" > "${distdir}/${bn}.sha512" || die
	fi

	if ! check_tarball_integrity "${bn}" ; then
eerror
eerror "This indicates that the download has either been corrupted,"
eerror "compromised, or is incomplete."
eerror
		die
	fi

	unpack "${distdir}/${bn}"
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
		chmod 4755 "${BUILD_DIR}/tests/ceftests/Release/chrome-sandbox" \
			|| die
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
	echo "${MY_PV}+g${CEF_COMMIT}+chromium-${CHROMIUM_PV}_$(get_xrid)${minimal}" \
		> "${ED}/opt/${PN}/.version" || die
	find "${ED}" -name "*.o" -delete
}

pkg_postinst() {
einfo
einfo "Version installed:  "$(cat "${EROOT}/opt/${PN}/.version")
einfo
ewarn
ewarn "Security notice:"
ewarn
ewarn "This package needs to be updated at the same time as your Chromium web"
ewarn "browser to avoid the same critical vulnerabilities."
ewarn
ewarn "We recommend that this library and every web browser be updated weekly."
ewarn
ewarn
# Weekly release cycle issues with stable.
ewarn "If the PATCH in MAJOR.MINOR.BUILD.PATCH is < 125, it is recommended to"
ewarn "use the beta USE flag for security reasons."
ewarn
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
