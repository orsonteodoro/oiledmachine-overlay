# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DEPENDS_VERSION="120.0.6099.129"
# DEPENDS_VER_A="120"
# DEPENDS_VER_B="0"
# DEPENDS_VER_C="6099"
# DEPENDS_VER_D="129"

# Third party licenses:
#
# CEF uses the BSD license
# CEF uses the Chromium source code and internal third party libraries/codecs which may be under additional licenses and copyright notices.
# Additional copyright notices can be obtained from
# CEF (tarball):        https://bitbucket.org/chromiumembedded/cef/get/<DEPENDS_VER_C>.tar.bz2
# Chromium (tarball):   https://gsdview.appspot.com/chromium-browser-official/chromium-<DEPENDS_VERSION>.tar.xz
# CEF (repo):           https://bitbucket.org/chromiumembedded/cef/src/<DEPENDS_VER_C>
#                       https://github.com/chromiumembedded/cef/tree/<DEPENDS_VER_C>
# Chromium (repo):      https://github.com/chromium/chromium/tree/<DEPENDS_VERSION>
#
# The repos may not contain all the third party modules.
# Refer to the tarballs for more copyright notices and licenses for the third party packages.

# This ebuild is provided to reduce ebuild security update lag.
# Always update it weekly.

# Builds also the libcef_dll_wrapper
# The -bin in ${PN} comes from the prebuilt chromium

VIRTUALX_REQUIRED="manual"
inherit chromium-2 cmake flag-o-matic virtualx

DESCRIPTION="Chromium Embedded Framework (CEF). A simple framework for \
embedding Chromium-based browsers in other applications."
LICENSE="BSD"
HOMEPAGE="
https://bitbucket.org/chromiumembedded/cef/src/master/
https://github.com/chromiumembedded/cef
https://cef-builds.spotifycdn.com/index.html
"
KEYWORDS="~arm ~arm64 ~amd64"

SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" beta cefclient cefsimple debug minimal test"
REQUIRED_USE+="
	cefclient? (
		!minimal
	)
	cefsimple? (
		!minimal
	)
	test? (
		!minimal
	)
"

# For *DEPENDs see:
# https://github.com/chromium/chromium/tree/120.0.6099.129/build/linux/sysroot_scripts/generated_package_lists				; 20230612
# https://github.com/chromium/chromium/blob/120.0.6099.129/build/install-build-deps.py
# https://github.com/chromiumembedded/cef/blob/5993/CMakeLists.txt.in

#
# Additional *DEPENDs versioning info:
#
# https://github.com/chromium/chromium/blob/120.0.6099.129/third_party/dav1d/version/vcs_version.h#L2					; newer than generated_package_lists
# https://github.com/chromium/chromium/blob/120.0.6099.129/third_party/fontconfig/include/config.h#L290
# https://github.com/chromium/chromium/blob/120.0.6099.129/third_party/libaom/source/config/config/aom_version.h#L19			; newer than generated_package_lists
# https://github.com/chromium/chromium/blob/120.0.6099.129/third_party/libpng/pnglibconf.h
# https://github.com/chromium/chromium/blob/120.0.6099.129/third_party/libxml/linux/config.h#L160					; newer than generated_package_lists
# https://github.com/chromium/chromium/blob/120.0.6099.129/third_party/libxslt/linux/config.h#L116					; newer than generated_package_lists
# https://github.com/chromium/chromium/blob/120.0.6099.129/third_party/node/update_node_binaries#L18
# https://github.com/chromium/chromium/blob/120.0.6099.129/third_party/re2/README.chromium#L4						; newer than generated_package_lists, (live)
# https://github.com/chromium/chromium/blob/120.0.6099.129/third_party/zlib/zlib.h#L40
# https://github.com/chromium/chromium/blob/120.0.6099.129/tools/clang/scripts/update.py#L42
# https://github.com/chromium/chromium/blob/120.0.6099.129/tools/rust/update_rust.py#L35						; commit
#   https://github.com/rust-lang/rust/blob/2e4e2a8f288f642cafcc41fff211955ceddc453d/src/version						; live version
#

# /var/tmp/portage/www-client/chromium-120.0.6099.129/work/chromium-120.0.6099.129/third_party/flac/BUILD.gn			L122	; newer than generated_package_lists
# /var/tmp/portage/www-client/chromium-120.0.6099.129/work/chromium-120.0.6099.129/third_party/freetype/src/CMakeLists.txt	L165	; newer than generated_package_lists
# /var/tmp/portage/www-client/chromium-120.0.6099.129/work/chromium-120.0.6099.129/third_party/harfbuzz-ng/src/configure.ac	L3	; newer than generated_package_lists
# /var/tmp/portage/www-client/chromium-120.0.6099.129/work/chromium-120.0.6099.129/third_party/icu/source/configure		L585	; newer than generated_package_lists
# /var/tmp/portage/www-client/chromium-120.0.6099.129/work/chromium-120.0.6099.129/third_party/libdrm/src/meson.build		L24	; newer than generated_package_lists
# /var/tmp/portage/www-client/chromium-120.0.6099.129/work/chromium-120.0.6099.129/third_party/libjpeg_turbo/jconfig.h		L7	; newer than generated_package_lists
# /var/tmp/portage/www-client/chromium-120.0.6099.129/work/chromium-120.0.6099.129/third_party/libwebp/src/configure.ac		L1	; newer than generated_package_lists
# /var/tmp/portage/www-client/chromium-120.0.6099.129/work/chromium-120.0.6099.129/third_party/openh264/src/meson.build		L2
# /var/tmp/portage/www-client/chromium-120.0.6099.129/work/chromium-120.0.6099.129/third_party/opus/README.chromium		L3	; newer than generated_package_lists, live

# *DEPENDs based on install-build-deps.sh
# U >=16.04 LTS assumed, supported only in CEF
# The *DEPENDs below assume U 18.04
CLANG_PV="18"
FFMPEG_SLOT="0/58.60.60" # Same as 6.0
GLIB_PV="2.66.8"
GCC_PV="10.2.1" # Minimum
GTK3_PV="3.24.24"
GTK4_PV="4.8.3"
LIBXI_PV="1.7.10"
MESA_PV="20.3.5"
CHROMIUM_CDEPEND="
	>=app-accessibility/at-spi2-atk-2.44.1:2
	>=app-accessibility/speech-dispatcher-0.11.4
	>=dev-db/sqlite-3.34.1
	>=dev-libs/glib-${GLIB_PV}:2
	>=dev-libs/libappindicator-12.10
	>=dev-libs/libevdev-1.11.0
	>=dev-libs/libffi-3.3
	>=media-libs/alsa-lib-1.2.4
	>=media-libs/mesa-${MESA_PV}[gbm(+)]
	>=net-print/cups-2.3.3
	>=sys-apps/pciutils-3.7.0
	>=sys-libs/libcap-2.44
	>=sys-libs/pam-1.4.0
	>=sys-apps/util-linux-2.36.1
	>=sys-libs/glibc-2.31
	>=x11-libs/cairo-1.16.0
	>=x11-libs/gtk+-${GTK3_PV}:3
	>=x11-libs/libXtst-1.2.3
	>=x11-libs/libdrm-2.4.115
"
# Unlisted based on ldd inspection not found in common_lib_list
UNLISTED_RDEPEND="
	>=dev-libs/nss-3.61
	>=dev-libs/fribidi-1.0.8
	>=dev-libs/gmp-6.2.1
	>=dev-libs/libbsd-0.11.3
	>=dev-libs/libtasn1-4.16.0
	>=dev-libs/libunistring-0.9.10
	>=dev-libs/nettle-3.7.3
	>=media-gfx/graphite2-1.3.14
	>=media-libs/harfbuzz-8.2.1
	>=media-libs/libglvnd-1.3.2
	>=media-libs/mesa-${MESA_PV}[egl(+)]
	>=net-dns/libidn-1.33
	>=x11-libs/libxkbcommon-1.0.3
"
OPTIONAL_RDEPEND="
	>=gnome-base/gnome-keyring-3.12.0[pam]
	>=media-libs/vulkan-loader-1.3.224.0
"
CHROMIUM_RDEPEND="
	${CHROMIUM_CDEPEND}
	${UNLISTED_RDEPEND}
	${OPTIONAL_RDEPEND}
	>=dev-libs/atk-2.38.0
	>=dev-libs/expat-2.2.10
	>=dev-libs/libpcre-8.39:3
	>=dev-libs/libpcre2-10.36
	>=dev-libs/nspr-4.29
	>=dev-libs/wayland-1.18.0
	>=media-libs/fontconfig-2.14.2
	>=media-libs/freetype-2.13.2
	>=media-libs/libpng-1.6.37
	>=sys-devel/gcc-${GCC_PV}[cxx(+)]
	>=sys-libs/zlib-1.2.13
	>=x11-libs/libX11-1.7.2
	>=x11-libs/libXau-1.0.9
	>=x11-libs/libxcb-1.14
	>=x11-libs/libXcomposite-0.4.5
	>=x11-libs/libXcursor-1.2.0
	>=x11-libs/libXdamage-1.1.5
	>=x11-libs/libXdmcp-1.1.2
	>=x11-libs/libXext-1.3.3
	>=x11-libs/libXfixes-5.0.3
	>=x11-libs/libXi-${LIBXI_PV}
	>=x11-libs/libXinerama-1.1.4
	>=x11-libs/libXrandr-1.5.1
	>=x11-libs/libXrender-0.9.10
	>=x11-libs/pango-1.46.2
	>=x11-libs/pixman-0.40.0
"
# libcef alone uses aura not gtk
RDEPEND+="
	${CHROMIUM_RDEPEND}
	cefclient? (
		>=dev-libs/glib-${GLIB_PV}:2
		>=x11-libs/gtk+-${GTK3_PV}:3
		>=x11-libs/gtkglext-1.2.0
		>=x11-libs/libXi-${LIBXI_PV}
	)
"
DEPEND+="
	test? (
		>=dev-libs/glib-${GLIB_PV}:2
	)
"
INTEGRITY_CHECK_BDEPEND="
	app-crypt/rhash
	app-misc/jq
" # From ebuild dev
BDEPEND+="
	${INTEGRITY_CHECK_BDEPEND}
	>=dev-util/cmake-3.21
	test? (
		x11-base/xorg-server[xvfb]
		x11-apps/xhost
	)
	|| (
		>=sys-devel/gcc-${GCC_PV}
		>=sys-devel/clang-${CLANG_PV}
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
	elif ( use elibc_Darwin ) && [[ "${ABI}" == "amd64" ]] ; then
		echo "macos64"
	elif ( use elibc_Darwin ) && [[ "${ABI}" == "arm64" ]] ; then
		echo "macosarm64"
	else
eerror
eerror "The LIBC or ABI not supported."
eerror
		die
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
einfo "CC:\t${CC}"
einfo "CXX:\t${CXX}"
	if ! test-flags-CXX "-std=c++${CXX_VER}" 2>/dev/null 1>/dev/null ; then
eerror
eerror "Switch to a c++${CXX_VER} compatible compiler."
eerror
		die
	fi
	if tc-is-gcc ; then
		if ver_test $(gcc-major-version) -lt ${GCC_PV} ; then
eerror
eerror "${PN} requires GCC >=${GCC_PV} for c++${CXX_VER} support"
eerror
			die
		fi
	elif tc-is-clang ; then
		if ver_test $(clang-version) -lt ${CLANG_PV} ; then
eerror
eerror "${PN} requires Clang >=${CLANG_PV} for c++${CXX_VER} support"
eerror
			die
		fi
	else
eerror
eerror "Compiler is not supported"
eerror
		die
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

	if ver_test ${CHROMIUM_PV} -lt ${DEPENDS_VERSION} ; then
ewarn
ewarn "You are using a CEF version based on an older chromium version."
ewarn "The *DEPENDs checks assumes newer or later."
ewarn
ewarn "Current version:  ${CHROMIUM_PV}"
ewarn "*DEPENDs version:  ${DEPENDS_VERSION}"
ewarn
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
# USE="minimal -beta -cefclient -cefsimple (-debug) -test"
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) (20230608)
# Build version:  114.2.10+g398e3c3+chromium-114.0.5735.110_linux64_minimal
