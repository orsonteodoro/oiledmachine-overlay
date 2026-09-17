# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D12, U22, U24

# Contains AI generated synthetic data.

inherit secure-version
#cef_binary_154.0.22+g<CEF_BIN_PV_REV>+chromium-<CEF_BIN_PV_CHROMIUM>_linux64_beta.tar.bz2

#CEF_BIN_PV_CHROMIUM="154.0.8037.17"
#CEF_BIN_PV_CHROMIUM_A="154"
#CEF_BIN_PV_CHROMIUM_B="0"
#CEF_BIN_PV_CHROMIUM_C="8037"
#CEF_BIN_PV_CHROMIUM_D="17"

# Third party licenses:
#
# CEF uses the BSD license
# CEF uses the Chromium source code and internal third party libraries/codecs which may be under additional licenses and copyright notices.
# Additional copyright notices can be obtained from
# CEF (tarball):        https://bitbucket.org/chromiumembedded/cef/get/<CEF_BIN_PV_CHROMIUM_C>.tar.bz2
# Chromium (tarball):   https://gsdview.appspot.com/chromium-browser-official/chromium-<CEF_BIN_PV_CHROMIUM>.tar.xz
# CEF (repo):           https://bitbucket.org/chromiumembedded/cef/src/<CEF_BIN_PV_CHROMIUM_C>
#                       https://github.com/chromiumembedded/cef/tree/<CEF_BIN_PV_CHROMIUM_C>
# Chromium (repo):      https://github.com/chromium/chromium/tree/<CEF_BIN_PV_CHROMIUM>
#
# The repos may not contain all the third party modules.
# Refer to the tarballs for more copyright notices and licenses for the third party packages.

# This ebuild is provided to reduce ebuild security update lag.
# Always update it weekly.

# Builds also the libcef_dll_wrapper
# The -bin in ${PN} comes from the prebuilt chromium

CXX_STANDARD=20
GCC_PV="10.2.1" # Minimum
VIRTUALX_REQUIRED="manual"
WEB_KERNEL_CONFIG_CHECK_YAMA=1

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX20[@]}"
)
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)"

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX20[@]/llvm_slot_}"
)
LIBCXX_USEDEP_LTS="llvm_slot_skip(+)"

CHKL_TIMESTAMPS=(
	"app-accessibility/at-spi2-core-9999"
	"app-crypt/rhash-9999"
	"app-misc/jq-9999"
	"dev-libs/expat-9999"
	"dev-libs/glib-2.90.9999"
	"media-libs/alsa-lib-9999"
	"net-print/cups-9999"
	"sys-apps/dbus-9999"
	"x11-base/xorg-server-9999"
	"x11-libs/cairo-9999"
	"x11-libs/gtk+-3.24.9999"
	"x11-libs/libX11-9999"
	"x11-libs/libxcb-9999"
	"x11-libs/libxkbcommon-9999"
)

inherit chkl chromium-2 cmake flag-o-matic libcxx-slot libstdcxx-slot linux-info sandbox-changes secure-version virtualx web-kernel-config

REQUIRED_USE=""
KEYWORDS="~arm ~arm64 ~amd64"
S="${WORKDIR}" # Dummy
SRC_URI="
	amd64? (
		!minimal? (
https://cef-builds.spotifycdn.com/cef_binary_154.0.22%2Bg${CEF_BIN_PV_REV}%2Bchromium-${CEF_BIN_PV_CHROMIUM}_linux64_beta.tar.bz2
		)
		minimal? (
https://cef-builds.spotifycdn.com/cef_binary_154.0.22%2Bg${CEF_BIN_PV_REV}%2Bchromium-${CEF_BIN_PV_CHROMIUM}_linux64_beta_minimal.tar.bz2
		)
	)
	arm64? (
		!minimal? (
https://cef-builds.spotifycdn.com/cef_binary_154.0.22%2Bg${CEF_BIN_PV_REV}%2Bchromium-${CEF_BIN_PV_CHROMIUM}_linuxarm64_beta.tar.bz2
		)
		minimal? (
https://cef-builds.spotifycdn.com/cef_binary_154.0.22%2Bg${CEF_BIN_PV_REV}%2Bchromium-${CEF_BIN_PV_CHROMIUM}_linuxarm64_beta_minimal.tar.bz2
		)
	)
	arm? (
		!minimal? (
https://cef-builds.spotifycdn.com/cef_binary_154.0.22%2Bg${CEF_BIN_PV_REV}%2Bchromium-${CEF_BIN_PV_CHROMIUM}_linuxarm_beta.tar.bz2
		)
		minimal? (
https://cef-builds.spotifycdn.com/cef_binary_154.0.22%2Bg${CEF_BIN_PV_REV}%2Bchromium-${CEF_BIN_PV_CHROMIUM}_linuxarm_beta_minimal.tar.bz2
		)
	)
"

DESCRIPTION="Chromium Embedded Framework (CEF) is a simple framework for \
embedding Chromium-based browsers in other applications."
LICENSE="
	BSD
	chromium-${CEF_BIN_PV_CHROMIUM%.*}.x.html
"
HOMEPAGE="
https://bitbucket.org/chromiumembedded/cef/src/master/
https://github.com/chromiumembedded/cef
https://cef-builds.spotifycdn.com/index.html
"
RESTRICT="mirror"
SLOT="0/${PV%%.*}"
IUSE+="
cefclient cefsimple debug minimal test wayland X
ebuild_revision_10
"
REQUIRED_USE+="
	cefclient? (
		!minimal
		test
	)
	cefsimple? (
		!minimal
		test
	)
	test? (
		!minimal
	)
	|| (
		wayland
		X
	)
"

# For *DEPENDs see:
# https://github.com/chromium/chromium/tree/154.0.8037.17/build/linux/sysroot_scripts/generated_package_lists				; 20231117
#   alsa-lib, at-spi2-core, bluez (bluetooth), cairo, cups, curl, expat,
#   flac [older], fontconfig [older], freetype [older], gcc, gdk-pixbuf, glib,
#   glibc, gtk+3, gtk4, harfbuzz [older], libdrm [older], libffi, libglvnd,
#   libjpeg-turbo [older], libpng [newer], libva, libwebp [older], libxcb,
#   libxcomposite, libxcursor, libxdamage, libxext, libxfixes, libx11, libxi,
#   libxkbcommon, libxml2 [older], libxrandr, libxrender, libxshmfence,
#   libxslt [older], nspr, nss, opus [older], pango, pciutils, pipewire,
#   libpulse, qt5, qt6, re2 [older], systemd, udev, wayland, zlib [older]
#
#   libunistring, libtasn1, libbsd, gmp, fribidi, nettle, graphite2, libidn,
#   libxau, libXtst, util-linux, pam, libcap, libevdev, sqlite3,
#   speech-dispatcher
#
# https://github.com/chromium/chromium/blob/154.0.8037.17/build/install-build-deps.py
# https://github.com/chromiumembedded/cef/blob/6613/CMakeLists.txt.in   # Same as 3rd component c in a.b.c.d versioning.
#   For version correspondance see https://bitbucket.org/chromiumembedded/cef/wiki/BranchesAndBuilding

#
# Additional *DEPENDs versioning info:
#
# https://github.com/chromium/chromium/blob/154.0.8037.17/tools/clang/scripts/update.py#L42
# https://chromium.googlesource.com/chromium/src.git/+/refs/tags/154.0.8037.17/third_party/

# gnome-keyring, vulkan-loader, gtkglext, libappindicator versioning from U 16.06

# *DEPENDs based on install-build-deps.sh
# libcef alone uses aura not gtk
RDEPEND+="
	>=app-accessibility/at-spi2-core-${AT_SPI2_CORE_PV}
	>=dev-libs/glib-${GLIB_PV}
	>=dev-libs/expat-${EXPAT_PV}
	>=dev-libs/nspr-${NSPR_PV}
	>=dev-libs/nss-${NSS_PV}
	>=media-libs/alsa-lib-${ALSA_LIB_PV}
	>=media-libs/mesa-${MESA_PV}[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS},gbm(+)]
	>=media-libs/libglvnd-${LIBGLVND_PV}
	>=net-print/cups-${CUPS_PV}
	>=sys-apps/dbus-${DBUS_PV}
	>=sys-devel/gcc-${GCC_PV}[cxx(+)]
	>=sys-libs/glibc-${GLIBC_PV}
	>=x11-libs/cairo-${CAIRO_PV}
	>=x11-libs/pango-${PANGO_PV}
	virtual/udev
	>=x11-libs/libX11-${LIBX11_PV}
	>=x11-libs/libxcb-${LIBXCB_PV}
	>=x11-libs/libXcomposite-0.4.5
	>=x11-libs/libXdamage-1.1.5
	>=x11-libs/libXext-${LIBXEXT_PV}
	>=x11-libs/libXfixes-${LIBXFIXES_PV}
	>=x11-libs/libxkbcommon-${LIBXKBCOMMON_PV}
	>=x11-libs/libXrandr-${LIBXRANDR_PV}
	cefclient? (
		>=x11-libs/gtk+-${GTK3_PV}:3
	)
"
DEPEND+="
	${RDEPEND}
"
INTEGRITY_CHECK_BDEPEND="
	>=app-crypt/rhash-${RHASH_PV}
	>=app-misc/jq-${JQ_PV}
" # From ebuild dev
BDEPEND+="
	${INTEGRITY_CHECK_BDEPEND}
	>=dev-build/cmake-3.21
	test? (
		>=x11-base/xorg-server-${XORG_SERVER_PV}[xvfb]
		x11-apps/xhost
	)
"
PATCHES=(
	"${FILESDIR}/cef-bin-145.0.28-disable-test.patch"
)

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
eerror "Your LIBC and/or your ABI are not supported."
		die
	fi
}

get_S_abi() {
	echo "${WORKDIR}/${P}"
}

append_all() {
	append-flags "${@}"
	append-ldflags "${@}"
}

check_thp_kernel_config() {
	if use kernel_linux ; then
		linux-info_pkg_setup

einfo "Kernel version:  ${KV_MAJOR}.${KV_MINOR}"
einfo "CONFIG_PATH being reviewed:  $(linux_config_path)"

	        if ! linux_config_src_exists ; then
eerror "Missing .config in /usr/src/linux"
	        fi

		if ! linux_config_exists ; then
ewarn "Missing kernel .config file."
		fi

	#
	# The history of the commit can be found on
	# https://community.intel.com/t5/Blogs/Tech-Innovation/Client/A-Journey-for-Landing-The-V8-Heap-Layout-Visualization-Tool/post/1368855
	# I've seen this first in the nodejs repo but never understood the benefit.
	# The same article discusses the unintended consequences.
	# In the current build files in the chromium project, they had went against their original decision about supporting THP.
	#
		CONFIG_CHECK="
			~TRANSPARENT_HUGEPAGE
		"

		WARNING_TRANSPARENT_HUGEPAGE="CONFIG_TRANSPARENT_HUGEPAGE could be enabled for V8 [JavaScript engine] memory access time reduction.  For webservers, music production, realtime, it should be kept disabled."

		check_extra_config
	fi
}

# @FUNCTION: has_all_hardening_flags
# @DESCRIPTION:
# Check each package individually for compiler hardening requirements.
has_all_hardening_flags() {
	local pkg="${1}"
	local F
	F=(
		"-O2"
		"-fno-delete-null-pointer-checks"
		"-fstrict-flex-arrays=3"
		"-ftrivial-auto-var-init=zero"
		"-fzero-call-used-regs=all"
		"-fwrapv"
	)

	local found_count=0
	local f
	for f in "${F[@]}" ; do
		if grep -q -e "${f}" "/var/db/pkg/${pkg}-"*"/CFLAGS" 2>/dev/null ; then
			found_count=$(( ${found_count} + 1 ))
		fi
	done

	# Transient execution CPU vulnerability mitigations
	# ID = Information Disclosure
	local found_count_id_mitigation=0
	if [[ "${tags}" =~ "sensitive-data" ]] ; then
		F=(
			"-fcf-protection=full"
			"-fhardened"
			"-mbranch-protection=pac-ret+bti"
			"-mbranch-protection=standard"
			"-mharden-sls=all"
			"-mretpoline"
			"-mindirect-branch=thunk"
			"-mindirect-branch=thunk-extern"
			"-mindirect-branch=thunk-inline"
			"-mfunction-return=thunk"
			"-mfunction-return=thunk-extern"
			"-mfunction-return=thunk-inline"
		)
		for f in "${F[@]}" ; do
			if grep -q -e "${f}" "/var/db/pkg/${pkg}-"*"/CFLAGS" 2>/dev/null ; then
				found_count_id_mitigation=$(( ${found_count_id_mitigation} + 1 ))
			fi
		done
	fi

	if [[ "${tags}" =~ "sensitive-data" ]] ; then
		if (( ${found_count} == 6 && ${found_count_id_mitigation} >= 1 )) ; then
			return 0
		fi
	else
		if (( ${found_count} == 6 )) ; then
			return 0
		fi
	fi
	return 1
}

# @FUNCTION: verify_compiler_flags_hardening
# @DESCRIPTION:
# Check compiler hardening requirements common to all network facing Electron
# apps.
verify_compiler_flags_hardening() {
	local L1=(
	#
	# Packages that are listed:
	#
	# 1.  Security-critical packages
	# 2.  Processes untrusted-data
	# 3.  Processes trusted-data
	# 4.  A shared library loaded during runtime into the following processes - browser, UI, rendering
	# 5.  Attack surface risks (sandbox escape potential, privilege gain, memory corruption potential)
	#
	#	"<use-flag>:<pkg>:<tags>"


	#
	# Understanding the problem of compiler hardening per process, ranked by
	# compiler hardening triage/remediation rank:
	#
	# 1. Browser / Main - not sandboxed, privileged, balanced
	# 2. Renderer - sandboxed, not privileged, security-critical
	# 3. GPU - sandboxed, not privileged, balanced
	# 4. Utility / Network / Helper - sandboxed, not privileged, balanced
	# 5. Plugin / Pepper - sandboxed, not privileged, balanced
	#

	#
	# The best return in security for compiler hardening remediation/triage for streamers:
	#
	# 1. mesa/libglvnd
	# 2. nss
	# 3. libxkbcommon
	# 4. glib
	# 5. glibc
	# 6. gtk+:3
	# 7. at-spi2-core
	# 8. libxcb
	# 9. pango, cairo
	# 10. dbus
	#

	#
	# Manual hardening via per-package flags.
	# No ebuild available on the oiledmachine-overlay.
	#

	"unconditional:app-accessibility/at-spi2-core:manual,attack-surface-risk,sensitive-data,untrusted-data"		# Touches PII
	"unconditional:media-libs/alsa-lib:manual,attack-surface-risk"

	"wayland:dev-libs/wayland:attack-surface-risk,manual"

	#
	# Hardened-by-default ebuilds available on the oiledmachine-overlay.
	#
	# The overlay adds the newer hardening flags which may be missing in the
	# default hardening compiler settings.
	#
	"unconditional:dev-libs/expat:untrusted-data"
	"unconditional:dev-libs/glib:attack-surface-risk,sensitive-data"
	"unconditional:dev-libs/nspr:sensitive-data"
	"unconditional:dev-libs/nss:attack-surface-risk,sensitive-data,untrusted-data"
	"unconditional:dev-util/spirv-tools:untrusted-data"								# RDEPEND of mesa
	"unconditional:media-libs/libglvnd:untrusted-data"								# RDEPEND of mesa
	"unconditional:media-libs/mesa:attack-surface-risk,sensitive-data,untrusted-data"
	"unconditional:net-print/cups:sensitive-data,untrusted-data"							# PII
	"unconditional:sys-apps/dbus:sensitive-data"									# PII, keys to crown jewels
	"unconditional:x11-libs/pango:sensitive-data,untrusted-data"
	"unconditional:x11-libs/cairo:sensitive-data,untrusted-data"

	"cefclient:x11-libs/gtk+:sensitive-data"
	"X:x11-base/xorg-server:sensitive-data"
	"X:x11-libs/libxcb:sensitive-data"
	"X:x11-libs/libxkbcommon:sensitive-data"
	"X:x11-libs/libX11:sensitive-data"
	)

	local row
	for row in "${L1[@]}" ; do
		local u=$(echo "${row}" | cut -f 1 -d ":")
		local p=$(echo "${row}" | cut -f 2 -d ":")
		local tag=$(echo "${row}" | cut -f 3 -d ":")
		if [[ "${tag}" =~ "manual" ]] ; then
			if [[ "${u}" == "unconditional" ]] ; then
ewarn "The package ${p} must be manually security-critical hardened using per-package package.env.  Use the hardening flags from the build log."
			elif use "${u}" && ! has_all_hardening_flags "${p}" ; then
ewarn "The package ${p} must be manually security-critical hardened using per-package package.env.  Use the hardening flags from the build log."
			fi
		elif [[ "${u}" == "unconditional" ]] ; then
			local repo=$(cat "/var/db/pkg/${p}-"*"/repository" | sed -e "/oiledmachine-overlay/d" | head -n 1)
			if ! grep -q -e "oiledmachine-overlay" "${ESYSROOT}/var/db/pkg/${p}-"*"/repository" ; then
ewarn "The package ${p}::${repo} may not be security-critical hardened.  Use the ${p}::oiledmachine-overlay ebuild instead."
			fi
		elif use "${u}" ; then
			if ! grep -q -e "oiledmachine-overlay" "${ESYSROOT}/var/db/pkg/${p}-"*"/repository" ; then
				local repo=$(cat "/var/db/pkg/${p}-"*"/repository" | sed -e "/oiledmachine-overlay/d" | head -n 1)
ewarn "The package ${p}::${repo} may not be security-critical hardened.  Use the ${p}::oiledmachine-overlay ebuild instead."
			fi
		fi
	done

	local L2=(
		"dev-libs/weston"
		"gui-liri/liri-shell"
		"gui-wm/cage"
		"gui-wm/cagebreak"
		"gui-wm/dwl"
		"gui-wm/kiwmi"
		"gui-wm/hyprland"
		"gui-wm/labwc"
		"gui-wm/mangowc"
		"gui-wm/miracle-wm"
		"gui-wm/newm"
		"gui-wm/niri"
		"gui-wm/river"
		"gui-wm/sway"
		"gui-wm/waybox"
		"gui-wm/wayfire"
		"kde-plasma/kwin"
		"x11-wm/enlightenment"
		"x11-wm/mutter"
	)

	if use wayland ; then
		local found_compositor=0
		local x
		for x in "${L2[@]}" ; do
			if has_version "${x}" ; then
				found_compositor=1
ewarn "${x} must use security-critical hardened ebuilds or per-package package.env hardening.  Use the hardening flags from the build log."
			fi
		done

		if (( ${found_compositor} == 0 )) ; then
ewarn "Wayland compositors must use security-critical hardened ebuilds or per-package package.env hardening.  Use the hardening flags from the build log."
		fi
	fi

ewarn "Packages that interact with ${PN} (e.g. password managers, clipboard managers) must use security-critical hardened ebuilds or per-package package.env hardening.  Use the hardening flags from the build log."
}

pkg_setup() {
	web-kernel-config_setup
	check_thp_kernel_config

	if use test ; then
		if has "sandbox" ${FEATURES} ; then
eerror "-sandbox must be added to FEATURES to use the test USE flag."
			die
		fi
ewarn
ewarn "The test is expected to fail.  To install, add test-fail-continue to"
ewarn "FEATURES as a per package envvar."
ewarn
	fi

	if [[ "${PV}" =~ "9999" ]] ; then
		sandbox-changes_no_network_sandbox "To download tarballs from a live source"
	fi

	libcxx-slot_verify
	libstdcxx-slot_verify
	verify_compiler_flags_hardening
}

src_unpack() {
	unpack ${A}
	mv "cef_binary_"* "${P}" || die
}

src_prepare() {
	export CMAKE_USE_DIR="${WORKDIR}/${P}"
einfo "CMAKE_USE_DIR=${CMAKE_USE_DIR}"
	cd "${CMAKE_USE_DIR}" || die
	cmake_src_prepare
	if use minimal ; then
		rm -rf "${CMAKE_USE_DIR}/tests" || die
	fi
	if ! use test ; then
		rm -rf "${CMAKE_USE_DIR}/tests" || die
	fi

	# Avoid missing symbols issues.
	sed -i \
		-e "/-fvisibility=hidden/d" \
		-e "/-fvisibility-inlines-hidden/d" \
		"cmake/cef_variables.cmake" || die
}

src_configure() {
	chkl_check_many_timestamps
	export CMAKE_USE_DIR="${WORKDIR}/${P}"
	export BUILD_DIR="${WORKDIR}/${P}"
	strip-unsupported-flags
	filter-flags \
		"-f*sanitize*" \
		"-f*visibility*" \
		"-march=*" \
		"-O*"

	if has_version "llvm-runtimes/compiler-rt-sanitizers[cfi,ubsan]" ; then
		# Link to UBSan indirectly to avoid missing symbols like these
		# when linking to CFI .so files:
		# undefined reference to __ubsan_handle_cfi_check_fail_abort
		append-ldflags "-Wl,-lubsan"
		:
	fi

	export CMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
	export CMAKE_USE_DIR="${WORKDIR}/${P}"
	export BUILD_DIR="${WORKDIR}/${P}"
	cd "${CMAKE_USE_DIR}" || die
	mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
	)
einfo "DIR="$(pwd)
	cmake_src_configure
einfo "DIR="$(pwd)

	if use test ; then
ewarn "Adding sandbox exceptions for the GPU."
		local d
		for d in "/dev/dri/card"*; do
einfo "addwrite ${d}"
			addwrite "${d}"
		done
		for d in "/dev/dri/render"*; do
einfo "addwrite ${d}"
			addwrite "${d}"
		done
	fi
}

src_compile() {
	export CMAKE_USE_DIR="${WORKDIR}/${P}"
	export BUILD_DIR="${WORKDIR}/${P}"
	cd "${BUILD_DIR}" || die
	cmake_src_compile \
		libcef_dll_wrapper \
		$(usex cefclient "cefclient" "") \
		$(usex cefsimple "cefsimple" "") \
		$(usex test "ceftests" "")
	if [[ -f "${BUILD_DIR}/tests/ceftests/Release/chrome-sandbox" ]] && use test ; then
		chmod 0755 "${BUILD_DIR}/tests/ceftests/Release/chrome-sandbox" \
			|| die
	fi
}

src_test() {
ewarn "This test failed on 87.1.12+g03f9336+chromium-87.0.4280.88"
	export CMAKE_USE_DIR="${WORKDIR}/${P}"
	export BUILD_DIR="${WORKDIR}/${P}"
	cd "${BUILD_DIR}" || die
	local build_type=$(usex debug "Debug" "Release")
	if use test ; then
		cd "${BUILD_DIR}/tests/ceftests/${build_type}" || die
		# If it fails, it is likely an upstream problem
		LD_LIBRARY_PATH="../../../libcef_dll_wrapper:../../../tests/gtest" \
		virtx "./ceftests" "--no-sandbox"
	fi
}

src_install() {
	export CMAKE_USE_DIR="${WORKDIR}/${P}"
	export BUILD_DIR="${WORKDIR}/${P}"
	cd "${BUILD_DIR}" || die
	dodir "/opt/${PN}"
	cp -rT "${BUILD_DIR}" "${ED}/opt/${PN}" || die
	local minimal=$(usex minimal "_minimal" "")
	echo "${MY_PV}+g${CEF_COMMIT}+chromium-${CHROMIUM_PV}_$(get_xrid)${minimal}" \
		> "${ED}/opt/${PN}/.version" || die
	find "${ED}" -name "*.o" -delete
	fperms 0755 "/opt/cef-bin/Release/chrome-sandbox"
	fowners "root:root" "/opt/cef-bin/Release/chrome-sandbox"
}

pkg_postinst() {
ewarn
ewarn "Security notice:"
ewarn
ewarn "This package needs to be updated at the same time as your Chromium web"
ewarn "browser to avoid the same critical vulnerabilities."
ewarn
ewarn "We recommend that this library and every web browser be updated at"
ewarn "least once a month."
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
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) (20230608), build version:  114.2.10+g398e3c3+chromium-114.0.5735.110_linux64_minimal

# USE="-minimal -beta -cefclient -cefsimple (-debug) -test"
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) (20260510), build version:  147.0.10+gd58e84d+chromium-147.0.7727.118_linux64 (stable)
