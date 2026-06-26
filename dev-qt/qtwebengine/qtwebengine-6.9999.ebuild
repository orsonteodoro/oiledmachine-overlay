# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild contains AI synthetic data.

# See also /var/tmp/portage/dev-qt/qtwebengine-<VER>/work/qtwebengine-everywhere-src-<VER>/src/3rdparty/chromium/chrome/VERSION

CFLAGS_ASSEMBLERS="inline nasm"
CFLAGS_HARDENED_LANGS="asm c-lang cxx"
CFLAGS_HARDENED_USE_CASES="copy-paste-password jit network security-critical sensitive-data untrusted-data web-browser"
CFLAGS_HARDENED_VTABLE_VERIFY=1
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE DF HO IO NPD OOBA OOBR OOBW PE RC SO UAF TC" # Based on Chromium
CXX_STANDARD=17
WEB_KERNEL_CONFIG_CHECK_YAMA=1
PYTHON_COMPAT=( python3_{10..14} )

FALLBACK_COMMIT="68848f491fda502dad2f06bda57cb99b595591e3"

# See https://github.com/qt/qtwebengine/tree/dev/src for submodule ID
# See https://github.com/qt/qtwebengine-chromium/blob/2a0509e9310c9766abd231aad5b1708c8a56539a/chromium/chrome/VERSION
CHROMIUM_VENDORED_VER="140.0.7339.225"
CHROMIUM_VENDORED_TIMESTAMP="Wed, 24 Sep 2025 16:45:28 -0700"

# See https://chromiumdash.appspot.com/releases?platform=Linux
CHROMIUM_BROWSER_VER="149.0.7827.114"
CHROMIUM_BROWSER_TIMESTAMP="Wed, 10 Jun 2026 10:58:03 -0700"

# For current commit, see https://github.com/qt/qtwebengine/tree/dev/src
# For version https://github.com/qt/qtwebengine-chromium/blob/2a0509e9310c9766abd231aad5b1708c8a56539a/chromium/third_party/node/README.chromium
NODE_SLOT="22"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

CHKL_TIMESTAMPS=(
	"app-arch/snappy-9999"
	"dev-libs/expat-9999"
	"dev-libs/glib-2.89.9999"
	"dev-libs/icu-79.0.9999"
	"dev-libs/libxml2-9999"
	"dev-libs/libxslt-9999"
	"dev-qt/qtbase-6.9999"
	"dev-qt/qtdeclarative-6.9999"
	"media-libs/fontconfig-9999"
	"media-libs/harfbuzz-9999"
	"media-libs/lcms-9999"
	"media-libs/libjpeg-turbo-9999"
	"media-libs/libpng-9999"
	"media-libs/libpulse-9999"
	"media-libs/libva-9999"
	"media-libs/libwebp-9999"
	"media-libs/mesa-9999"
	"media-libs/openh264-9999"
	"media-libs/opus-9999"
	"media-libs/tiff-9999"
	"media-video/pipewire-9999"
	"x11-libs/libX11-9999"
	"x11-libs/libxcb-9999"
	"x11-libs/libXcursor-9999"
	"x11-libs/libxkbcommon-9999"
)

inherit cflags-hardened check-reqs chkl flag-o-matic libcxx-slot libstdcxx-slot multiprocessing optfeature
inherit prefix python-any-r1 qt6-build secure-version toolchain-funcs web-kernel-config

DESCRIPTION="Library for rendering dynamic web content in Qt6 C++ and QML applications"
SRC_URI+="
	https://distfiles.gentoo.org/pub/dev/ionen@gentoo.org/${PN}-6.11-patchset-3.tar.xz
"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm64"
fi

IUSE+="
	accessibility +alsa clang bindist custom-cflags designer gcc geolocation
	+jumbo-build kerberos opengl +pdfium pulseaudio qml screencast
	+system-icu vaapi vulkan webdriver +widgets
	ebuild_revision_1
"
REQUIRED_USE="
	^^ (
		gcc
		clang
	)
	designer? ( qml widgets )
	test? ( widgets )
"

# dlopen: krb5, libva, pciutils
RDEPEND="
	>=app-arch/snappy-${SNAPPY_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=dev-libs/expat-${EXPAT_PV}:=
	>=dev-libs/libxml2-${LIBXML2_PV}:=[icu]
	>=dev-libs/libxslt-${LIBXSLT_PV}:=
	>=dev-libs/nspr-${NSPR_PV}:=
	>=dev-libs/nss-${NSS_PV}:=
	~dev-qt/qtbase-${PV}:6=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},accessibility=,gui,opengl=,ssl,vulkan?,widgets?]
	~dev-qt/qtdeclarative-${PV}:6=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},widgets?]
	~dev-qt/qtwebchannel-${PV}:6=[qml?]
	>=media-libs/fontconfig-${FONTCONFIG_PV}:=
	>=media-libs/freetype-${FREETYPE_PV}:=
	>=media-libs/harfbuzz-${HARFBUZZ_PV}:=
	>=media-libs/lcms-${LCMS_PV}:=
	>=media-libs/libjpeg-turbo-${LIBJPEG_TURBO_PV}:=
	>=media-libs/libpng-${LIBPNG_PV}:=
	>=media-libs/libwebp-${LIBWEBP_PV}:=
	>=media-libs/mesa-${MESA_PV}:=[gbm(+)]
	>=media-libs/openjpeg-${OPENJPEG_PV}:=
	>=media-libs/opus-${OPUS_PV}:=
	>=media-libs/tiff-${TIFF_PV}:=
	sys-apps/dbus:=
	sys-apps/pciutils:=
	virtual/libudev:=
	virtual/minizip:=
	>=virtual/zlib-${ZLIB_PV}:=
	>=x11-libs/libX11-${LIBX11_PV}:=
	x11-libs/libXcomposite:=
	x11-libs/libXdamage:=
	>=x11-libs/libXext-${LIBXEXT_PV}:=
	>=x11-libs/libXfixes-${LIBXFIXES_PV}:=
	>=x11-libs/libXrandr-${LIBXRANDR_PV}:=
	>=x11-libs/libXtst-${LIBXTST_PV}:=
	>=x11-libs/libdrm-${LIBDRM_PV}:=
	>=x11-libs/libxcb-${LIBXCB_PV}:=
	>=x11-libs/libxkbcommon-${LIBXKBCOMMON_PV}:=
	>=x11-libs/libxkbfile-${LIBXKBFILE_PV}:=
	alsa? ( >=media-libs/alsa-lib-${ALSA_LIB_PV}:= )
	!bindist? ( >=media-libs/openh264-${OPENH264_PV}:= )
	designer? (
		~dev-qt/qttools-${PV}:6=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},designer]
	)
	elibc_glibc? (
		>=sys-libs/glibc-${GLIBC_PV}:=
	)
	elibc_musl? (
		>=sys-libs/musl-${MUSL_PV}:=
	)
	geolocation? ( ~dev-qt/qtpositioning-${PV}:6= )
	kerberos? ( virtual/krb5:* )
	opengl? ( media-libs/libglvnd:=[X] )
	pulseaudio? ( >=media-libs/libpulse-${LIBPULSE_PV}:=[glib] )
	screencast? (
		>=dev-libs/glib-${GLIB_PV}:=
		>=media-video/pipewire-${PIPEWIRE_PV}:=
	)
	system-icu? (
		>=dev-libs/icu-${ICU_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
	vaapi? ( >=media-libs/libva-${LIBVA_PV}:=[X] )
"
DEPEND="
	${RDEPEND}
	media-libs/libglvnd:=
	x11-base/xorg-proto:=
	>=x11-libs/libXcursor-${LIBXCURSOR_PV}:=
	>=x11-libs/libXi-${LIBXI_PV}:=
	>=x11-libs/libxshmfence-${LIBXSHMFENCE_PV}:=
	clang? (
		llvm-runtimes/libatomic-stub:=
	)
	elibc_musl? ( sys-libs/queue-standalone:= )
	gcc? (
		sys-devel/gcc:=
	)
	screencast? ( media-libs/libepoxy:=[egl(+)] )
	vaapi? (
		vulkan? ( dev-util/vulkan-headers:= )
	)
"
BDEPEND="
	$(python_gen_any_dep '
		dev-python/html5lib[${PYTHON_USEDEP}]
	')
	dev-util/gperf
	net-libs/nodejs:${NODE_SLOT}[icu,ssl]
	sys-devel/bison
	sys-devel/flex
"

PATCHES=( "${WORKDIR}"/patches/${PN} )
[[ ${PV} == 6.9999 ]] || # too fragile for 6.9999, but keep for 6.x.9999
	PATCHES+=( "${WORKDIR}"/patches/chromium )

PATCHES+=(
	# add extras as needed here, may merge in set if carries across versions
	"${FILESDIR}"/${PN}-6.10.3-climits.patch
	"${FILESDIR}"/${PN}-6.11.0-gcc17.patch
)

python_check_deps() {
	python_has_version "dev-python/html5lib[${PYTHON_USEDEP}]"
}

qtwebengine_check-reqs() {
	[[ ${MERGE_TYPE} == binary ]] && return

	if is-flagq '-g?(gdb)?([1-9])'; then #307861
		ewarn
		ewarn "Used CFLAGS/CXXFLAGS seem to enable debug info (-g or -ggdb), which"
		ewarn "is non-trivial with ${PN}. May experience extended compilation"
		ewarn "times, increased disk/memory usage, and potentially link failure."
		ewarn
		ewarn "If run into issues, please try disabling before reporting a bug."
	fi

	local CHECKREQS_DISK_BUILD=11G
	local CHECKREQS_DISK_USR=400M

	if ! has distcc ${FEATURES}; then #830661
		# on average this does not use *that* much ram but then poor
		# luck may lead to several 3.9+GB jobs happening at same time
		# (less of an issue for users with 32+GB ram given they have
		# room to handle a few spikes), try to find a balance but it
		# won't be right for everyone (CHECKREQS_DONOTHING=1 to ignore)
		tc-is-clang && : 17 || : 25 # clang:1.7GB/job, gcc:2.5GB/job
		local CHECKREQS_MEMORY=$(($(makeopts_jobs)*_/10))G
	fi

	check-reqs_${EBUILD_PHASE_FUNC} #570534
}

pkg_pretend() {
	qtwebengine_check-reqs
}

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

# @FUNCTION: _verify_compiler_flags_hardening
# @DESCRIPTION:
# Check compiler hardening requirements common to all network facing qtwebengine
# apps.
_verify_compiler_flags_hardening() {
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
	# 1. Renderer - sandboxed - security-critical
	# 2. Network - sandboxed - security-critical
	# 3. Utility - sandboxed - balanced
	# 4. GPU - partially sandboxed - balanced
	# 5. Browser - no sandbox, privileged - balanced or security-critical
	#

	#
	# Ranked best return in security for compiler hardening remediation/triage
	# of dependencies for embedded web content inside Qt desktop applications
	# (e.g help/documentation, hybrid apps, media streaming, video
	# conferencing, e-mail client, custom web browser or kiosk):
	#
	# 1. nss
	# 2. ffmpeg
	# 3. icu
	# 4. libwebp/opus
	# 5. libxslt/libxml2
	# 6. pipewire/alsa
	# 7. harfbuzz/freetype
	#

	#
	# Manual hardening via per-package flags.
	# No ebuild available on the oiledmachine-overlay.
	#

	#"unconditional:app-accessibility/at-spi2-core:manual,attack-surface-risk,sensitive-data,untrusted-data"		# PII
	"alsa:media-libs/alsa-lib:manual,attack-surface-risk"

	#
	# Hardened-by-default ebuilds available on the oiledmachine-overlay.
	#
	# The overlay adds the newer hardening flags which may be missing in the
	# default hardening compiler settings.
	#
	# The hardening below assumes web browser USE case only.
	#
	"unconditional:app-arch/snappy:sensitive-data,untrusted-data"
	"unconditional:dev-libs/expat:untrusted-data"
	"unconditional:dev-libs/libxml2:untrusted-data"
	"unconditional:dev-libs/libxslt:untrusted-data"
	"unconditional:dev-libs/nss:attack-surface-risk,sensitive-data,untrusted-data"
	"unconditional:dev-libs/nspr:sensitive-data"
	"unconditional:dev-qt/qtbase:sensitive-data"
	"unconditional:dev-qt/qtdeclarative:untrusted-data"
	"unconditional:dev-qt/qtwebchannel:untrusted-data"
	"unconditional:dev-util/spirv-tools:untrusted-data"								# RDEPEND of mesa
	"unconditional:media-libs/fontconfig:untrusted-data"
	"unconditional:media-libs/freetype:sensitive-data,untrusted-data"
	"unconditional:media-libs/harfbuzz:sensitive-data,untrusted-data"
	"unconditional:media-libs/lcms:untrusted-data"
	"unconditional:media-libs/libglvnd:untrusted-data"								# RDEPEND of mesa
	"unconditional:media-libs/libjpeg-turbo:sensitive-data,untrusted-data"						# PII
	"unconditional:media-libs/libpng:sensitive-data,untrusted-data"							# PII
	"unconditional:media-libs/libwebp:sensitive-data,untrusted-data"						# PII
	"unconditional:media-libs/mesa:attack-surface-risk,sensitive-data,untrusted-data"
	"unconditional:media-libs/openjpeg:untrusted-data"
	"unconditional:media-libs/opus:sensitive-data,untrusted-data"
	"unconditional:media-libs/tiff:untrusted-data"
	#"unconditional:net-print/cups:sensitive-data,untrusted-data"
	"unconditional:sys-apps/dbus:sensitive-data,untrusted-data"							# PII, Crown Jewel Keys
	"unconditional:virtual/zlib:untrusted-data"
	#"unconditional:x11-libs/pango:sensitive-data,untrusted-data"
	#"unconditional:x11-libs/cairo:sensitive-data,untrusted-data"
	"unconditional:x11-libs/libX11:sensitive-data"
	"unconditional:x11-libs/libxcb:sensitive-data"
	"unconditional:x11-libs/libxkbcommon:sensitive-data"
	"unconditional:x11-base/xorg-server:sensitive-data"

	"geolocation:dev-qt/qtpositioning:sensitive-data"								# PII
	"opengl:media-libs/libglvnd:untrusted-data"									# RDEPEND of mesa
	"screencast:dev-libs/glib:attack-surface-risk,sensitive-data"
	"screencast:media-video/pipewire:untrusted-data"
	"system-icu:dev-libs/icu:sensitive-data,untrusted-data"								# PII
	"vaapi:media-libs/libva:untrusted-data"
	)

	if has wayland ${IUSE_EFFECTIVE} && use wayland ; then
		L1+=(
			"wayland:dev-libs/wayland:attack-surface-risk,manual"
		)
	fi

	local row
	for row in "${L1[@]}" ; do
		local u=$(echo "${row}" | cut -f 1 -d ":")
		local p=$(echo "${row}" | cut -f 2 -d ":")
		local tag=$(echo "${row}" | cut -f 3 -d ":")
		if [[ "${tag}" =~ "manual" ]] ; then
			if [[ "${u}" == "unconditional" ]] ; then
ewarn "The package ${p} must be manually security-critical hardened using per-package package.env.  Use the hardening flags from the build log."
			elif use "${u}" && ! _electron-app_has_all_hardening_flags "${p}" ; then
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

	if has wayland ${IUSE_EFFECTIVE} && use wayland ; then
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
	qtwebengine_check-reqs
	python-any-r1_pkg_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
	web-kernel-config_setup
	_verify_compiler_flags_hardening
}

src_prepare() {
	qt6-build_src_prepare

	# for www-plugins/chrome-binary-plugins (widevine) search paths on prefix
	hprefixify -w /Gentoo/ src/core/content_client_qt.cpp

	# store chromium versions, only used in postinst for a warning
	local chromium
	mapfile -t chromium < CHROMIUM_VERSION || die
	[[ ${chromium[0]} =~ ^Based.*:[^0-9]+([0-9.]+$) ]] &&
		QT6_CHROMIUM_VER=${BASH_REMATCH[1]} || die
	[[ ${chromium[1]} =~ ^Patched.+:[^0-9]+([0-9.]+$) ]] &&
		QT6_CHROMIUM_PATCHES_VER=${BASH_REMATCH[1]} || die
ewarn
ewarn "${PN}'s Chromium version:  ${QT6_CHROMIUM_VER} (${QT6_CHROMIUM_TIMESTAMP})"
ewarn "Latest Chromium version:  ${CHROMIUM_BROWSER_VER} (${CHROMIUM_VENDORED_TIMESTAMP})"
ewarn
ewarn "This package is behind in security updates."
ewarn "Find a way to remove it or stop it from being added."
ewarn
}

src_configure() {
	chkl_check_many_timestamps
	export PATH="/usr/lib/node/${NODE_SLOT}/bin:${PATH}"
einfo "PATH:  ${PATH}"
	node --version || die

	if tc-is-clang ; then
		use clang || die "Enable the clang USE flag."
	fi
	if tc-is-gcc ; then
		use gcc || die "Enable the gcc USE flag."
	fi

	local mycmakeargs=(
		$(qt_feature pdfium qtpdf_build)
		$(use pdfium && qt_feature qml qtpdf_quick_build)
		$(use pdfium && qt_feature widgets qtpdf_widgets_build)
		$(usev pdfium -DQT_FEATURE_pdf_v8=ON)

		# TODO?: since 6.9.0, dependency checks have been adjusted to make it
		# easier for webengine to be optional which could be useful if *only*
		# need QtPdf (rare at the moment), would require all revdeps to depend
		# on qtwebengine[webengine(+)]
		-DQT_FEATURE_qtwebengine_build=ON
		$(qt_feature qml qtwebengine_quick_build)
		$(qt_feature webdriver webenginedriver)
		$(qt_feature widgets qtwebengine_widgets_build)

		$(cmake_use_find_package designer Qt6Designer)

		$(qt_feature alsa webengine_system_alsa)
		$(qt_feature !bindist webengine_proprietary_codecs)
		$(qt_feature !bindist webengine_system_openh264) # no bundled either
		$(qt_feature geolocation webengine_geolocation)
		$(qt_feature jumbo-build webengine_jumbo_build)
		$(qt_feature kerberos webengine_kerberos)
		$(qt_feature pulseaudio webengine_system_pulseaudio)
		$(qt_feature screencast webengine_webrtc_pipewire)
		$(qt_feature system-icu webengine_system_icu)
		$(qt_feature vaapi webengine_vaapi)
		$(qt_feature vulkan webengine_vulkan)
		-DQT_FEATURE_webengine_embedded_build=OFF
		-DQT_FEATURE_webengine_extensions=ON
		# TODO: it may be possible to make x11 optional since 6.8+
		-DQT_FEATURE_webengine_ozone_x11=ON
		-DQT_FEATURE_webengine_pass_extra_flags=ON
		-DQT_FEATURE_webengine_pepper_plugins=ON
		-DQT_FEATURE_webengine_printing_and_pdf=ON
		-DQT_FEATURE_webengine_spellchecker=ON
		-DQT_FEATURE_webengine_webchannel=ON
		-DQT_FEATURE_webengine_webrtc=ON

		# needs a modified ffmpeg to be usable (bug #831487), and even then
		# it is picky about codecs/version and system's can lead to unexpected
		# issues (e.g. builds but some files don't play even with support)
		-DQT_FEATURE_webengine_system_ffmpeg=OFF

		# use bundled re2 to avoid complications, Qt has also disabled
		# this by default in 6.7.3+ (bug #913923)
		-DQT_FEATURE_webengine_system_re2=OFF

		# system_libvpx=ON is intentionally ignored with USE=vaapi which leads
		# to using system's being less tested, prefer disabling for now until
		# vaapi can use it as well
		-DQT_FEATURE_webengine_system_libvpx=OFF

		# not necessary to pass these (default), but in case detection fails
		# given qtbase's force_system_libs does not affect these right now
		$(printf -- '-DQT_FEATURE_webengine_system_%s=ON ' \
			freetype gbm glib harfbuzz lcms2 libjpeg libopenjpeg2 \
			libpci libpng libtiff libudev libwebp libxml minizip \
			opus snappy zlib)

		# TODO: fixup gn cross, or package dev-qt/qtwebengine-gn with =ON
		# (see also BUILD_ONLY_GN option added in 6.8+ for the latter)
		-DINSTALL_GN=OFF
	)

	local mygnargs=(
		# prefer no dlopen where possible
		$(usev pulseaudio link_pulseaudio=true)
		$(usev screencast rtc_link_pipewire=true)
		# reduce default disk space usage
		symbol_level=0
	)

	if use !custom-cflags; then
		# qtwebengine can be rather fragile with *FLAGS
		filter-lto
		strip-flags

		if is-flagq '-g?(gdb)?([2-9])'; then #914475
			replace-flags '-g?(gdb)?([2-9])' -g1
			ewarn "-g2+/-ggdb* *FLAGS replaced with -g1 (enable USE=custom-cflags to keep)"
		fi

		# gcc-16 with -O3 is known to cause runtime issues (bug #968755)
		tc-is-gcc && [[ $(gcc-major-version) -ge 16 ]] &&
			replace-flags '-O[3-9]' -O2

		# Qt normally ignores users *FLAGS specifically for qtwebengine, and
		# does not really support passing -march -- qt6-build.eclass has some
		# checks to ensure working flags with amd64, but that does not exist
		# for arm64 and can lead to problems (bug #920555,#920568,#970048)
		use arm64 && filter-flags '-march=*' '-mcpu=*'
	fi

	# chromium passes this by default, but qtwebengine does not and it may
	# "possibly" get enabled by some paths and cause issues (bug #953111)
	append-ldflags -Wl,-z,noexecstack

	cflags-hardened_append

	# Remove hardening flags that may slow things down
	filter-flags "-fno-inline"

	export NINJAFLAGS=$(get_NINJAOPTS)
	[[ ${NINJA_VERBOSE^^} == OFF ]] || NINJAFLAGS+=" -v"

	local -x EXTRA_GN="${mygnargs[*]} ${EXTRA_GN}"
	einfo "Extra Gn args: ${EXTRA_GN}"

	qt6-build_src_configure
}

src_test() {
	if [[ ${EUID} == 0 ]]; then
		# almost every tests fail, so skip entirely
		ewarn "Skipping tests due to running as root (chromium refuses this configuration)."
		return
	fi

	local CMAKE_SKIP_TESTS=(
		# fails with *-sandbox
		tst_certificateerror
		tst_inspectorserver
		tst_loadsignals
		tst_qquickwebengineview
		tst_qwebengineglobalsettings
		tst_qwebenginepermission
		tst_qwebengineview
		# fails with offscreen rendering, may be worth retrying if the issue
		# persist given these are rather major tests (or consider virtx)
		tst_qmltests
		tst_qwebenginepage
		# certs verfication seems flaky and gives expiration warnings
		tst_qwebengineclientcertificatestore
		# test is misperformed when qtbase is built USE=-test?
		tst_touchinput
		# currently requires webenginedriver to be already installed
		tst_webenginedriver
	)

	# prevent using the system's qtwebengine
	# (use glob to avoid unnecessary complications with arch dir)
	local resources=( "${BUILD_DIR}/src/core/${CMAKE_BUILD_TYPE}/"* )
	[[ -d ${resources[0]} ]] || die "invalid resources path: ${resources[0]}"
	local -x QTWEBENGINEPROCESS_PATH=${BUILD_DIR}${QT6_LIBEXECDIR#"${QT6_PREFIX}"}/QtWebEngineProcess
	local -x QTWEBENGINE_LOCALES_PATH=${resources[0]}/qtwebengine_locales
	local -x QTWEBENGINE_RESOURCES_PATH=${resources[0]}

	# random failures in several tests without -j1
	qt6-build_src_test -j1
}

src_install() {
	qt6-build_src_install

	[[ -e ${D}${QT6_LIBDIR}/libQt6WebEngineCore.so ]] || #601472
		die "${CATEGORY}/${PF} failed to build anything. Please report to https://bugs.gentoo.org/"

	# exact cause unknown, but >=qtwebengine-6.9.2 started to act as if
	# QtWebEngineProcess is marked USER_FACING despite not set anywhere
	# and this creates a user_facing_tool_links.txt with a broken symlink
	if [[ -L ${ED}/usr/bin/QtWebEngineProcess6 ]] &&
		[[ ! -e ${ED}/usr/bin/QtWebEngineProcess6 ]]
	then
		rm -- "${ED}"/usr/bin/QtWebEngineProcess6 || die
	else
		# eqawarn rather than die to avoid failing a long build over this
		eqawarn "QA Notice: symlink workaround may be obsolete"
	fi

	if use test; then
		local delete=( # sigh
			"${D}${QT6_ARCHDATADIR}"/metatypes/*testmockdelegates*
			"${D}${QT6_ARCHDATADIR}"/modules/*TestMockDelegates*
			"${D}${QT6_BINDIR}"/testbrowser
			"${D}${QT6_LIBDIR}"/{,cmake,pkgconfig}/*TestMockDelegates*
			"${D}${QT6_MKSPECSDIR}"/modules/*testmockdelegates*
			"${D}${QT6_QMLDIR}"/QtWebEngine/TestMockDelegates
		)
		# using -f given not tracking which tests may be skipped or not
		rm -rf -- "${delete[@]}" || die
	fi
}

pkg_postinst() {
	# plugin may also be found in $HOME if provided by chrome or firefox
	use amd64 &&
		optfeature "Widevine DRM support (protected media playback)" \
			www-plugins/chrome-binary-plugins

elog
elog "${PN} is behind in security updates.  Do not use at all."
elog "${PN} may still miss internal fixes that may not be fully disclosed."
elog "Please remove the package after use from the system to avoid"
elog "weaponization or misuse."
elog
elog "${PN}'s Chromium version:  ${CHROMIUM_VENDORED_VER} (${CHROMIUM_VENDORED_TIMESTAMP})"
elog "Latest Chromium version:  ${CHROMIUM_BROWSER_VER} (${CHROMIUM_BROWSER_TIMESTAMP})"
elog
}
