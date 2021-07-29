# Copyright 2009-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Monitor
#   https://chromereleases.googleblog.com/search/label/Beta%20updates
#   https://chromereleases.googleblog.com/search/label/Stable%20updates
# for security updates.  They are announced faster than NVD.
# See https://omahaproxy.appspot.com/ for the latest linux version

EAPI=7
PYTHON_COMPAT=( python3_8 )
PYTHON_REQ_USE="xml"

CHROMIUM_LANGS="am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk vi zh-CN zh-TW"

ECHROMIUM_CUSTOM_TIMEBOX_TIME=${ECHROMIUM_CUSTOM_TIMEBOX_TIME:=2}
VIRTUALX_REQUIRED=manual
inherit check-reqs chromium-2 desktop flag-o-matic multilib ninja-utils pax-utils portability python-any-r1 readme.gentoo-r1 toolchain-funcs xdg-utils
inherit multilib-minimal virtualx

DESCRIPTION="Open-source version of Google Chrome web browser"
HOMEPAGE="https://chromium.org/"
PATCHSET="7"
PATCHSET_NAME="chromium-$(ver_cut 1)-patchset-${PATCHSET}"
PPC64LE_PATCHSET="92-ppc64le-1"
SRC_URI="
	https://commondatastorage.googleapis.com/chromium-browser-official/${P}.tar.xz
	https://files.pythonhosted.org/packages/ed/7b/bbf89ca71e722b7f9464ebffe4b5ee20a9e5c9a555a56e2d3914bb9119a6/setuptools-44.1.0.zip
	https://github.com/stha09/chromium-patches/releases/download/${PATCHSET_NAME}/${PATCHSET_NAME}.tar.xz
	https://dev.gentoo.org/~sultan/distfiles/www-client/${PN}/${PN}-92-glibc-2.33-patch.tar.xz
	arm64? ( https://github.com/google/highway/archive/refs/tags/0.12.1.tar.gz -> highway-0.12.1.tar.gz )
	ppc64? ( https://dev.gentoo.org/~gyakovlev/distfiles/${PN}-${PPC64LE_PATCHSET}.tar.xz )"
RESTRICT="mirror"

PGO_EBUILD_PROFILE_GENERATOR_SITE_LICENSES=(
	CC-BY-4.0
	CC0-1.0
	CC-BY-SA-3.0
	MIT
	all-rights-reserved MIT
	BSD-2
	BSD
	GPL-2
	GPL-2+
	LGPL-2.1
	ZLIB
	Apache-2.0
)
PGO_EBUILD_UPSTREAM_GENERATOR_SITE_LICENSES=(
	MIT
	Apache-2.0
)
# search.creativecommons.org CC-BY-4.0 (Content attributed to Creative Commons)
# search.creativecommons.org image search results CC0-1.0
# wiki.gentoo.org CC-BY-SA-3.0 (Content attributed to Gentoo Foundation, Inc)
# www.kevs3d.co.uk MIT with link back clause
# Under the hood of the JetStream 2 benchmark:
#   https://github.com/WebKit/WebKit/tree/main/Websites/browserbench.org/JetStream2.0 and internal third party dependencies BSD-2, BSD, GPL-2, GPL-2+, LGPL-2.1, MIT
# Under the hood of the the octane benchmark:
#   https://github.com/chromium/octane and internal third party dependencies BSD, GPL-2+, MIT, (all rights reserved MIT), ZLIB, Apache-2.0
#   https://github.com/chromium/octane/blob/master/crypto.js all-rights-reserved MIT (the plain MIT license doesn't contain all rights reserved)
#   https://github.com/chromium/octane/blob/master/js/bootstrap-collapse.js
# Under the hood of the the Speedometer 2.0 benchmark:
#   https://github.com/WebKit/WebKit/tree/main/PerformanceTests/Speedometer or internal third party dependencies MIT, Apache-2.0
LICENSE="BSD
	pgo-ebuild-profile-generator? ( ${PGO_EBUILD_PROFILE_GENERATOR_SITE_LICENSES} )
	pgo-upstream-profile-generator? ( ${PGO_EBUILD_UPSTREAM_GENERATOR_SITE_LICENSES} )"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~x86"
IUSE="component-build cups cpu_flags_arm_neon +hangouts headless +js-type-check kerberos official pic +proprietary-codecs pulseaudio screencast selinux +suid +system-ffmpeg +system-icu vaapi wayland widevine"
IUSE+=" +partitionalloc tcmalloc libcmalloc"
# For cfi, cfi-icall defaults status, see https://github.com/chromium/chromium/blob/92.0.4515.107/build/config/sanitizers/sanitizers.gni
# For cfi-full default status see, https://github.com/chromium/chromium/blob/92.0.4515.107/build/config/sanitizers/sanitizers.gni#L123
# For pgo default status see, https://github.com/chromium/chromium/blob/92.0.4515.107/build/config/compiler/pgo/pgo.gni#L15
# For libcxx default see, https://github.com/chromium/chromium/blob/92.0.4515.107/build/config/c++/c++.gni#L14
IUSE+=" +cfi cfi-full +cfi-icall +clang libcxx pgo -pgo-native -pgo-web pgo-upstream-profile-generator -pgo-ebuild-profile-generator pgo-custom-script pgo-gpu pgo-audio"
_ABIS="abi_x86_32 abi_x86_64 abi_x86_x32 abi_mips_n32 abi_mips_n64 abi_mips_o32 abi_ppc_32 abi_ppc_64 abi_s390_32 abi_s390_64"
IUSE+=" ${_ABIS}"
REQUIRED_USE="
	^^ ( partitionalloc tcmalloc libcmalloc )
	!clang? ( !cfi )
	cfi? ( clang )
	cfi-full? ( cfi )
	cfi-icall? ( cfi )
	component-build? ( !suid )
	libcxx? ( clang )
	official? ( amd64? ( cfi cfi-icall ) libcxx pgo )
	partitionalloc? ( !component-build )
	pgo? ( clang libcxx !pgo-native )
	pgo-native? ( ^^ ( pgo-upstream-profile-generator pgo-ebuild-profile-generator ) clang !pgo )
	pgo-web? ( pgo-native )
	pgo-upstream-profile-generator? ( pgo-ebuild-profile-generator )
	pgo-ebuild-profile-generator? ( !pgo-upstream-profile-generator )
	screencast? ( wayland )
"

COMMON_X_DEPEND="
	media-libs/mesa:=[gbm,${MULTILIB_USEDEP}]
	x11-libs/libX11:=[${MULTILIB_USEDEP}]
	x11-libs/libXcomposite:=[${MULTILIB_USEDEP}]
	x11-libs/libXcursor:=[${MULTILIB_USEDEP}]
	x11-libs/libXdamage:=[${MULTILIB_USEDEP}]
	x11-libs/libXext:=[${MULTILIB_USEDEP}]
	x11-libs/libXfixes:=[${MULTILIB_USEDEP}]
	>=x11-libs/libXi-1.6.0:=[${MULTILIB_USEDEP}]
	x11-libs/libXrandr:=[${MULTILIB_USEDEP}]
	x11-libs/libXrender:=[${MULTILIB_USEDEP}]
	x11-libs/libXtst:=[${MULTILIB_USEDEP}]
	x11-libs/libxcb:=[${MULTILIB_USEDEP}]
	x11-libs/libxshmfence:=[${MULTILIB_USEDEP}]
	vaapi? ( >=x11-libs/libva-2.7:=[X,drm,${MULTILIB_USEDEP}] )
"

COMMON_DEPEND="
	app-arch/bzip2:=[${MULTILIB_USEDEP}]
	cups? ( >=net-print/cups-1.3.11:=[${MULTILIB_USEDEP}] )
	dev-libs/expat:=[${MULTILIB_USEDEP}]
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.4-r3:=[icu,${MULTILIB_USEDEP}]
	dev-libs/nspr:=[${MULTILIB_USEDEP}]
	>=dev-libs/nss-3.26:=[${MULTILIB_USEDEP}]
	>=media-libs/alsa-lib-1.0.19:=[${MULTILIB_USEDEP}]
	media-libs/fontconfig:=[${MULTILIB_USEDEP}]
	media-libs/freetype:=[${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-2.4.0:0=[icu(-),${MULTILIB_USEDEP}]
	media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}]
	media-libs/libpng:=[${MULTILIB_USEDEP}]
	pulseaudio? ( media-sound/pulseaudio:=[${MULTILIB_USEDEP}] )
	system-ffmpeg? (
		>=media-video/ffmpeg-4.3:=[${MULTILIB_USEDEP}]
		|| (
			media-video/ffmpeg[-samba,${MULTILIB_USEDEP}]
			>=net-fs/samba-4.5.10-r1[-debug(-),${MULTILIB_USEDEP}]
		)
		>=media-libs/opus-1.3.1:=[${MULTILIB_USEDEP}]
	)
	net-misc/curl[ssl]
	sys-apps/dbus:=[${MULTILIB_USEDEP}]
	sys-apps/pciutils:=[${MULTILIB_USEDEP}]
	virtual/udev
	x11-libs/cairo:=[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf:2[${MULTILIB_USEDEP}]
	x11-libs/libxkbcommon:=[${MULTILIB_USEDEP}]
	x11-libs/pango:=[${MULTILIB_USEDEP}]
	media-libs/flac:=[${MULTILIB_USEDEP}]
	>=media-libs/libwebp-0.4.0:=[${MULTILIB_USEDEP}]
	sys-libs/zlib:=[minizip,${MULTILIB_USEDEP}]
	kerberos? ( virtual/krb5[${MULTILIB_USEDEP}] )
	!headless? (
		${COMMON_X_DEPEND}
		>=app-accessibility/at-spi2-atk-2.26:2[${MULTILIB_USEDEP}]
		>=app-accessibility/at-spi2-core-2.26:2[${MULTILIB_USEDEP}]
		>=dev-libs/atk-2.26[${MULTILIB_USEDEP}]
		x11-libs/gtk+:3[X,${MULTILIB_USEDEP}]
		wayland? (
			dev-libs/wayland:=[${MULTILIB_USEDEP}]
			screencast? ( media-video/pipewire:0/0.3 )
			x11-libs/gtk+:3[wayland,X,${MULTILIB_USEDEP}]
			x11-libs/libdrm:=[${MULTILIB_USEDEP}]
		)
	)
"
RDEPEND="${COMMON_DEPEND}
	x11-misc/xdg-utils
	virtual/opengl[${MULTILIB_USEDEP}]
	virtual/ttf-fonts
	selinux? ( sec-policy/selinux-chromium )
"
DEPEND="${COMMON_DEPEND}
"
# dev-vcs/git - https://bugs.gentoo.org/593476
BDEPEND="
	${PYTHON_DEPS}
	>=app-arch/gzip-1.7
	app-arch/unzip
	dev-lang/perl
	dev-lang/python:2.7[xml]
	>=dev-util/gn-0.1807
	dev-vcs/git
	>=dev-util/gperf-3.0.3
	>=dev-util/ninja-1.7.2
	>=net-libs/nodejs-7.6.0[inspector]
	sys-apps/hwids[usb(+)]
	>=sys-devel/bison-2.4.3
	sys-devel/flex[${MULTILIB_USEDEP}]
	|| (
		>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config]
		>=dev-util/pkgconfig-0.29.2[${MULTILIB_USEDEP}]
	)
	js-type-check? ( virtual/jre )
	pgo-native? (
		${VIRTUALX_DEPEND}
		x11-misc/xdotool
	)
" # TODO change to !pgo-gpu? ( ${VIRTUALX_DEPEND} )

# >=mesa-21.1 is bumped to compatibile llvm-12
# <=mesa-21.0.x is only llvm-11 compatible
BDEPEND+="
	clang? (
		|| (
			(
				sys-devel/clang:12[${MULTILIB_USEDEP}]
				sys-devel/llvm:12[${MULTILIB_USEDEP}]
				=sys-devel/clang-runtime-12*[${MULTILIB_USEDEP}]
				>=sys-devel/lld-12
				>=media-libs/mesa-21.1.4[gbm,${MULTILIB_USEDEP}]
			)
			(
				sys-devel/clang:11[${MULTILIB_USEDEP}]
				sys-devel/llvm:11[${MULTILIB_USEDEP}]
				=sys-devel/clang-runtime-11*[${MULTILIB_USEDEP}]
				>=sys-devel/lld-11
				<media-libs/mesa-21.1[gbm,${MULTILIB_USEDEP}]
			)
		)
	)"
RDEPEND+=" libcxx? ( >=sys-libs/libcxx-12[${MULTILIB_USEDEP}] )"
DEPEND+=" libcxx? ( >=sys-libs/libcxx-12[${MULTILIB_USEDEP}] )"

COMMON_DEPEND="
	!libcxx? (
		app-arch/snappy:=[${MULTILIB_USEDEP}]
		dev-libs/libxslt:=[${MULTILIB_USEDEP}]
		>=dev-libs/re2-0.2019.08.01:=[${MULTILIB_USEDEP}]
		>=media-libs/openh264-1.6.0:=[${MULTILIB_USEDEP}]
		system-icu? ( >=dev-libs/icu-69.1:=[${MULTILIB_USEDEP}] )
	)
"

RDEPEND+="${COMMON_DEPEND}"
DEPEND+="${COMMON_DEPEND}"

if ! has chromium_pkg_die ${EBUILD_DEATH_HOOKS}; then
	EBUILD_DEATH_HOOKS+=" chromium_pkg_die";
fi

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
Some web pages may require additional fonts to display properly.
Try installing some of the following packages if some characters
are not displayed properly:
- media-fonts/arphicfonts
- media-fonts/droid
- media-fonts/ipamonafont
- media-fonts/noto
- media-fonts/ja-ipafonts
- media-fonts/takao-fonts
- media-fonts/wqy-microhei
- media-fonts/wqy-zenhei

To fix broken icons on the Downloads page, you should install an icon
theme that covers the appropriate MIME types, and configure this as your
GTK+ icon theme.

For native file dialogs in KDE, install kde-apps/kdialog.

To make password storage work with your desktop environment you may
have install one of the supported credentials management applications:
- app-crypt/libsecret (GNOME)
- kde-frameworks/kwallet (KDE)
If you have one of above packages installed, but don't want to use
them in Chromium, then add --password-store=basic to CHROMIUM_FLAGS
in /etc/chromium/default.
"

pre_build_checks() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		local -x CPP="$(tc-getCXX) -E"
		if tc-is-gcc && ! ver_test "$(gcc-version)" -ge 9.2; then
			die "At least gcc 9.2 is required"
		fi
		if use clang || tc-is-clang ; then
			CPP="${CHOST}-clang++ -E"
			if ! ver_test "$(clang-major-version)" -ge 12; then
				die "At least clang 12 is required"
			fi
		fi
	fi

	# Check build requirements, bug #541816 and bug #471810 .
	CHECKREQS_MEMORY="3G"
	CHECKREQS_DISK_BUILD="8G"
	if ( shopt -s extglob; is-flagq '-g?(gdb)?([1-9])' ); then
		if use custom-cflags || use component-build; then
			CHECKREQS_DISK_BUILD="25G"
		fi
		if ! use component-build; then
			CHECKREQS_MEMORY="16G"
		fi
	fi
	check-reqs_pkg_setup
}

pkg_pretend() {
	pre_build_checks
}

pkg_setup() {
	einfo "The $(ver_cut 1 ${PV}) series is the Stable channel."
	pre_build_checks

	chromium_suid_sandbox_check_kernel_config

	# nvidia-drivers does not work correctly with Wayland due to unsupported EGLStreams
	if use wayland && ! use headless && has_version "x11-drivers/nvidia-drivers"; then
		ewarn "Proprietary nVidia driver does not work with Wayland. You can disable"
		ewarn "Wayland by setting DISABLE_OZONE_PLATFORM=true in /etc/chromium/default."
	fi

	if ! use amd64 && [[ "${IUSE}" =~ cfi ]]; then
ewarn
ewarn "All variations of the cfi USE flags are not defaults for this platform."
ewarn "Disable them if problematic."
ewarn
	fi

	if use pgo ; then
ewarn "The pgo USE flag is experimental.  Disable if it fails."

# See also https://clang.llvm.org/docs/UsersManual.html#profile-remapping
#   to address the profile mismatch problem.

# It's better to rebuild the system with libcxx than to build the
# program twice all the time or skip PGO.  The other problem is updating
# and check the mangled remapping every update.  The other problem is
# that non-upstream patches modify the function/method signatures which
# could interfere with PGO.

ewarn
ewarn "The PGO profile may require sys-devel/clang[default-libcxx] and"
ewarn "www-client/chromium[libcxx] and rebuilding dependencies for proper"
ewarn "optimization or to match the upstream PGO profile properly."
ewarn "Upstream may likely assume libc++ instead of libstdc++."
ewarn
	fi

	if use pgo-native ; then
ewarn
ewarn "The pgo-native option is a Work In Progress (WIP)."
ewarn
	fi

	if use pgo-web ; then
		if has network-sandbox $FEATURES ; then
eerror
01234567890123456789012345678901234567890123456789012345678901234567890123456789
eerror "${PN} requires network-sandbox to be disabled in per-package FEATURES"
eerror "in order to access remote websites."
eerror
			die
		fi
	fi

	einfo "USER=${USER}"
	if use pgo-gpu ; then
# We do not want the xvfb but rather the acclerated X instead.
ewarn
ewarn "The pgo-gpu USE flag is a Work In Progress (WIP)."
ewarn
		if ! ( groups ${USER} | grep -q "video" ) ; then
			die "You must add ${USER} to the video group."
		fi

		# From sci-geosciences/grass ebuild
		shopt -s nullglob
		local mesa_cards=$(echo -n /dev/dri/card* /dev/dri/render* | sed 's/ /:/g')
		if test -n "${mesa_cards}"; then
			addpredict "${mesa_cards}"
		fi
		local ati_cards=$(echo -n /dev/ati/card* | sed 's/ /:/g')
		if test -n "${ati_cards}"; then
			addpredict "${ati_cards}"
		fi
		shopt -u nullglob
		addpredict /dev/nvidiactl
	fi

	if use pgo-audio ; then
ewarn
ewarn "The pgo-gpu USE flag is a Work In Progress (WIP)."
ewarn
		if ! ( groups ${USER} | grep -q "audio" ) ; then
			die "You must add ${USER} to the audio group."
		fi
	fi

	if use pgo-upstream-profile-generator ; then
ewarn
ewarn "The pgo-upstream-profile-generator USE flag is a Work In Progress (WIP)."
ewarn
	fi

	if use pgo-ebuild-profile-generator ; then
ewarn
ewarn "The pgo-ebuild-profile-generator USE flag is a Work In Progress (WIP)"
ewarn "and untested and not recommended at this time.  Try the"
ewarn "pgo-upstream-profile-generator USE flag or just the pgo USE flag instead."
ewarn
	fi
}

USED_EAPPLY=0
ceapply() {
	USED_EAPPLY=1
	eapply "${@}"
}

src_prepare() {
	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	local PATCHES=()
	if ( ! use clang ) || ( ! use libcxx ) || use arm64 ; then
		# TODO: split GCC only and libstdc++ only.
		# The patches purpose are not documented well.
		einfo "Applying gcc & libstdc++ compatibility patches"
		PATCHES+=( "${WORKDIR}/patches" )
	fi

	PATCHES+=(
		"${WORKDIR}/sandbox-patches/chromium-syscall_broker.patch"
		"${WORKDIR}/sandbox-patches/chromium-fstatat-crash.patch"
		"${FILESDIR}/chromium-92-EnumTable-crash.patch"
		"${FILESDIR}/chromium-92-GetUsableSize-nullptr.patch"
		"${FILESDIR}/chromium-freetype-2.11.patch"
		"${FILESDIR}/chromium-shim_headers.patch"
	)

	if ! use arm64 ; then
		einfo "Removing aarch64 only patches"
		rm "${WORKDIR}/patches/chromium-91-libyuv-aarch64.patch" || die
		rm "${WORKDIR}/patches/chromium-92-v8-constexpr.patch" || die
	fi

	if use ppc64; then
		ceapply "${WORKDIR}/${PN}-ppc64le/xxx-ppc64le-libvpx.patch"
		ceapply "${WORKDIR}/${PN}-ppc64le/xxx-ppc64le-support.patch"
		ceapply "${WORKDIR}/${PN}-ppc64le/xxx-ppc64le-swiftshader.patch"
	fi

#	ceapply "${FILESDIR}/${PN}-92-clang-toolchain.patch"

	if ( (( ${#PATCHES[@]} > 0 || ${USED_EAPPLY} == 1 )) || [[ -f "${T}/epatch_user.log" ]] ) ; then
		if use official ; then
			ewarn
			ewarn "The use of unofficial patches is not endorsed upstream."
			ewarn
		fi

		if use pgo ; then
			ewarn
			ewarn "The use of patching can interfere with the pregenerated PGO profile."
			ewarn
		fi
	fi

	default

	# this patch needs to be applied after gentoo sandbox patchset
	use ppc64 && eapply "${WORKDIR}/${PN}-ppc64le/xxx-ppc64le-sandbox_kernel_stat.patch"

	mkdir -p third_party/node/linux/node-linux-x64/bin || die
	ln -s "${EPREFIX}"/usr/bin/node third_party/node/linux/node-linux-x64/bin/node || die

	# adjust python interpreter versions
	sed -i -e "s|\(^script_executable = \).*|\1\"${EPYTHON}\"|g" .gn || die
	sed -i -e "s|python2|python2\.7|g" buildtools/linux64/clang-format || die
	sed -i -e "s|/usr/bin/env vpython|/usr/bin/env ${EPYTHON}|g" \
		tools/perf/run_benchmark || die

	# bundled highway library does not support arm64 with GCC
	if use arm64; then
		rm -r third_party/highway/src || die
		ln -s "${WORKDIR}/highway-0.12.1" third_party/highway/src || die
	fi

	local keeplibs=(
		base/third_party/cityhash
		base/third_party/double_conversion
		base/third_party/dynamic_annotations
		base/third_party/icu
		base/third_party/nspr
		base/third_party/superfasthash
		base/third_party/symbolize
		base/third_party/valgrind
		base/third_party/xdg_mime
		base/third_party/xdg_user_dirs
		buildtools/third_party/libc++
		buildtools/third_party/libc++abi
		chrome/third_party/mozilla_security_manager
		courgette/third_party
		net/third_party/mozilla_security_manager
		net/third_party/nss
		net/third_party/quic
		net/third_party/uri_template
		third_party/abseil-cpp
		third_party/angle
		third_party/angle/src/common/third_party/base
		third_party/angle/src/common/third_party/smhasher
		third_party/angle/src/common/third_party/xxhash
		third_party/angle/src/third_party/compiler
		third_party/angle/src/third_party/libXNVCtrl
		third_party/angle/src/third_party/trace_event
		third_party/angle/src/third_party/volk
		third_party/apple_apsl
		third_party/axe-core
		third_party/blink
		third_party/boringssl
		third_party/boringssl/src/third_party/fiat
		third_party/breakpad
		third_party/breakpad/breakpad/src/third_party/curl
		third_party/brotli
		third_party/catapult
		third_party/catapult/common/py_vulcanize/third_party/rcssmin
		third_party/catapult/common/py_vulcanize/third_party/rjsmin
		third_party/catapult/third_party/beautifulsoup4
		third_party/catapult/third_party/html5lib-python
		third_party/catapult/third_party/polymer
		third_party/catapult/third_party/six
		third_party/catapult/tracing/third_party/d3
		third_party/catapult/tracing/third_party/gl-matrix
		third_party/catapult/tracing/third_party/jpeg-js
		third_party/catapult/tracing/third_party/jszip
		third_party/catapult/tracing/third_party/mannwhitneyu
		third_party/catapult/tracing/third_party/oboe
		third_party/catapult/tracing/third_party/pako
		third_party/ced
		third_party/cld_3
		third_party/closure_compiler
		third_party/crashpad
		third_party/crashpad/crashpad/third_party/lss
		third_party/crashpad/crashpad/third_party/zlib
		third_party/crc32c
		third_party/cros_system_api
		third_party/dav1d
		third_party/dawn
		third_party/dawn/third_party/khronos
		third_party/dawn/third_party/tint
		third_party/depot_tools
		third_party/devscripts
		third_party/devtools-frontend
		third_party/devtools-frontend/src/front_end/third_party/acorn
		third_party/devtools-frontend/src/front_end/third_party/axe-core
		third_party/devtools-frontend/src/front_end/third_party/chromium
		third_party/devtools-frontend/src/front_end/third_party/codemirror
		third_party/devtools-frontend/src/front_end/third_party/diff
		third_party/devtools-frontend/src/front_end/third_party/i18n
		third_party/devtools-frontend/src/front_end/third_party/intl-messageformat
		third_party/devtools-frontend/src/front_end/third_party/lighthouse
		third_party/devtools-frontend/src/front_end/third_party/lit-html
		third_party/devtools-frontend/src/front_end/third_party/lodash-isequal
		third_party/devtools-frontend/src/front_end/third_party/marked
		third_party/devtools-frontend/src/front_end/third_party/puppeteer
		third_party/devtools-frontend/src/front_end/third_party/wasmparser
		third_party/devtools-frontend/src/third_party
		third_party/dom_distiller_js
		third_party/eigen3
		third_party/emoji-segmenter
		third_party/farmhash
		third_party/fdlibm
		third_party/fft2d
		third_party/flatbuffers
		third_party/freetype
		third_party/fusejs
		third_party/highway
		third_party/libgifcodec
		third_party/liburlpattern
		third_party/libzip
		third_party/gemmlowp
		third_party/google_input_tools
		third_party/google_input_tools/third_party/closure_library
		third_party/google_input_tools/third_party/closure_library/third_party/closure
		third_party/googletest
		third_party/harfbuzz-ng/utils
		third_party/hunspell
		third_party/iccjpeg
		third_party/inspector_protocol
		third_party/jinja2
		third_party/jsoncpp
		third_party/jstemplate
		third_party/khronos
		third_party/leveldatabase
		third_party/libXNVCtrl
		third_party/libaddressinput
		third_party/libaom
		third_party/libaom/source/libaom/third_party/fastfeat
		third_party/libaom/source/libaom/third_party/vector
		third_party/libaom/source/libaom/third_party/x86inc
		third_party/libavif
		third_party/libgav1
		third_party/libjingle
		third_party/libjxl
		third_party/libphonenumber
		third_party/libsecret
		third_party/libsrtp
		third_party/libsync
		third_party/libudev
		third_party/libva_protected_content
		third_party/libvpx
		third_party/libvpx/source/libvpx/third_party/x86inc
		third_party/libwebm
		third_party/libx11
		third_party/libxcb-keysyms
		third_party/libxml/chromium
		third_party/libyuv
		third_party/llvm
		third_party/lottie
		third_party/lss
		third_party/lzma_sdk
		third_party/mako
		third_party/markupsafe
		third_party/mesa
		third_party/metrics_proto
		third_party/minigbm
		third_party/modp_b64
		third_party/nasm
		third_party/nearby
		third_party/neon_2_sse
		third_party/node
		third_party/node/node_modules/polymer-bundler/lib/third_party/UglifyJS2
		third_party/one_euro_filter
		third_party/opencv
		third_party/openscreen
		third_party/openscreen/src/third_party/mozilla
		third_party/openscreen/src/third_party/tinycbor/src/src
		third_party/ots
		third_party/pdfium
		third_party/pdfium/third_party/agg23
		third_party/pdfium/third_party/base
		third_party/pdfium/third_party/bigint
		third_party/pdfium/third_party/freetype
		third_party/pdfium/third_party/lcms
		third_party/pdfium/third_party/libopenjpeg20
		third_party/pdfium/third_party/libpng16
		third_party/pdfium/third_party/libtiff
		third_party/pdfium/third_party/skia_shared
		third_party/perfetto
		third_party/perfetto/protos/third_party/chromium
		third_party/pffft
		third_party/ply
		third_party/polymer
		third_party/private-join-and-compute
		third_party/private_membership
		third_party/protobuf
		third_party/protobuf/third_party/six
		third_party/pyjson5
		third_party/qcms
		third_party/rnnoise
		third_party/s2cellid
		third_party/securemessage
		third_party/shell-encryption
		third_party/simplejson
		third_party/skia
		third_party/skia/include/third_party/skcms
		third_party/skia/include/third_party/vulkan
		third_party/skia/third_party/skcms
		third_party/skia/third_party/vulkan
		third_party/smhasher
		third_party/sqlite
		third_party/swiftshader
		third_party/swiftshader/third_party/astc-encoder
		third_party/swiftshader/third_party/llvm-subzero
		third_party/swiftshader/third_party/marl
		third_party/swiftshader/third_party/subzero
		third_party/swiftshader/third_party/SPIRV-Headers/include/spirv/unified1
		third_party/tcmalloc
		third_party/tensorflow-text
		third_party/tflite
		third_party/tflite/src/third_party/eigen3
		third_party/tflite/src/third_party/fft2d
		third_party/tflite-support
		third_party/ruy
		third_party/ukey2
		third_party/unrar
		third_party/usrsctp
		third_party/utf
		third_party/vulkan
		third_party/web-animations-js
		third_party/webdriver
		third_party/webgpu-cts
		third_party/webrtc
		third_party/webrtc/common_audio/third_party/ooura
		third_party/webrtc/common_audio/third_party/spl_sqrt_floor
		third_party/webrtc/modules/third_party/fft
		third_party/webrtc/modules/third_party/g711
		third_party/webrtc/modules/third_party/g722
		third_party/webrtc/rtc_base/third_party/base64
		third_party/webrtc/rtc_base/third_party/sigslot
		third_party/widevine
		third_party/woff2
		third_party/wuffs
		third_party/x11proto
		third_party/xcbproto
		third_party/zxcvbn-cpp
		third_party/zlib/google
		tools/grit/third_party/six
		url/third_party/mozilla
		v8/src/third_party/siphash
		v8/src/third_party/valgrind
		v8/src/third_party/utf8-decoder
		v8/third_party/inspector_protocol
		v8/third_party/v8

		# gyp -> gn leftovers
		base/third_party/libevent
		third_party/speech-dispatcher
		third_party/usb_ids
		third_party/xdg-utils
	)
	if ! use system-ffmpeg; then
		keeplibs+=( third_party/ffmpeg third_party/opus )
	fi
	if ! use system-icu; then
		keeplibs+=( third_party/icu )
	fi
	if use wayland && ! use headless ; then
		keeplibs+=( third_party/wayland )
	fi
	if use libcxx ; then
		keeplibs+=( third_party/libxml )
		keeplibs+=( third_party/libxslt )
		keeplibs+=( third_party/openh264 )
		keeplibs+=( third_party/re2 )
		keeplibs+=( third_party/snappy )
		if use system-icu; then
			keeplibs+=( third_party/icu )
		fi
	fi
	if use arm64 || use ppc64 ; then
		keeplibs+=( third_party/swiftshader/third_party/llvm-10.0 )
	fi
	# we need to generate ppc64 stuff because upstream does not ship it yet
	# it has to be done before unbundling.
	if use ppc64; then
		pushd third_party/libvpx >/dev/null || die
		mkdir -p source/config/linux/ppc64 || die
		./generate_gni.sh || die
		popd >/dev/null || die
	fi

	# Remove most bundled libraries. Some are still needed.
	build/linux/unbundle/remove_bundled_libraries.py "${keeplibs[@]}" --do-remove || die

	if use js-type-check; then
		ln -s "${EPREFIX}"/usr/bin/java third_party/jdk/current/bin/java || die
	fi

	# bundled eu-strip is for amd64 only and we don't want to pre-stripped binaries
	mkdir -p buildtools/third_party/eu-strip/bin || die
	ln -s "${EPREFIX}"/bin/true buildtools/third_party/eu-strip/bin/eu-strip || die
	multilib_copy_sources
}

_configure_pgx() {
	local chost=$(get_abi_CHOST ${ABI})
	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	local myconf_gn=""

	# Make sure the build system will use the right tools, bug #340795.
	tc-export AR CC CXX NM READELF STRIP

	if use clang ; then
		# See build/toolchain/linux/unbundle/BUILD.gn for allowed overridable envvars.
		# See build/toolchain/gcc_toolchain.gni#L657 for consistency.
		CC=${chost}-clang
		CXX=${chost}-clang++
		AR=llvm-ar # required for LTO
		NM=llvm-nm
		READELF=llvm-readelf
		STRIP=llvm-strip
		strip-unsupported-flags
		if ! which llvm-ar 2>/dev/null 1>/dev/null ; then
			die "llvm-ar is unreachable"
		fi
	fi

	if ! use clang && tc-is-clang ; then
		if [[ ! ( "${AR}" =~ "llvm-ar" ) ]] ; then
			einfo "Forcing llvm-ar for LTO"
			AR=llvm-ar # required for LTO
			NM=llvm-nm
			READELF=llvm-readelf
			STRIP=llvm-strip
			if ! which llvm-ar 2>/dev/null 1>/dev/null ; then
				die "llvm-ar is unreachable"
			fi
		fi
	fi

	if tc-is-clang; then
		myconf_gn+=" is_clang=true clang_use_chrome_plugins=false"
	else
		if use libcxx ; then
			die "Compiling with sys-libs/libcxx requires clang."
		fi
		myconf_gn+=" is_clang=false"
	fi

	# Define a custom toolchain for GN
	myconf_gn+=" custom_toolchain=\"//build/toolchain/linux/unbundle:default\""

	if tc-is-cross-compiler; then
		tc-export BUILD_{AR,CC,CXX,NM}
		myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:host\""
		myconf_gn+=" v8_snapshot_toolchain=\"//build/toolchain/linux/unbundle:host\""
	else
		myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:default\""
	fi

	# GN needs explicit config for Debug/Release as opposed to inferring it from build directory.
	myconf_gn+=" is_debug=false"

	# Component build isn't generally intended for use by end users. It's mostly useful
	# for development and debugging.
	myconf_gn+=" is_component_build=$(usex component-build true false)"

	# Disable nacl, we can't build without pnacl (http://crbug.com/269560).
	myconf_gn+=" enable_nacl=false"

	if use partitionalloc ; then
		myconf_gn+=" use_allocator=\"partition\""
	elif use tcmalloc ; then
		myconf_gn+=" use_allocator=\"tcmalloc\""
	else
		myconf_gn+=" use_allocator=\"none\""
	fi

	# Use system-provided libraries.
	# TODO: freetype -- remove sources (https://bugs.chromium.org/p/pdfium/issues/detail?id=733).
	# TODO: use_system_hunspell (upstream changes needed).
	# TODO: use_system_libsrtp (bug #459932).
	# TODO: use_system_protobuf (bug #525560).
	# TODO: use_system_ssl (http://crbug.com/58087).
	# TODO: use_system_sqlite (http://crbug.com/22208).

	# libevent: https://bugs.gentoo.org/593458
	local gn_system_libraries=(
		flac
		fontconfig
		freetype
		# Need harfbuzz_from_pkgconfig target
		#harfbuzz-ng
		libdrm
		libjpeg
		libpng
		libwebp
		zlib
	)
	if use system-ffmpeg; then
		gn_system_libraries+=( ffmpeg opus )
	fi
	if use system-icu; then
		gn_system_libraries+=( icu )
	fi
	if ! use libcxx ; then
		# unbundle only without libc++, because libc++ is not fully ABI compatible with libstdc++
		gn_system_libraries+=( libxml )
		gn_system_libraries+=( libxslt )
		gn_system_libraries+=( openh264 )
		gn_system_libraries+=( re2 )
		gn_system_libraries+=( snappy )
	fi
	build/linux/unbundle/replace_gn_files.py --system-libraries "${gn_system_libraries[@]}" || die

	# See dependency logic in third_party/BUILD.gn
	myconf_gn+=" use_system_harfbuzz=true"

	# Disable deprecated libgnome-keyring dependency, bug #713012
	myconf_gn+=" use_gnome_keyring=false"

	# Optional dependencies.
	myconf_gn+=" enable_js_type_check=$(usex js-type-check true false)"
	myconf_gn+=" enable_hangout_services_extension=$(usex hangouts true false)"
	myconf_gn+=" enable_widevine=$(usex widevine true false)"
	myconf_gn+=" use_cups=$(usex cups true false)"
	myconf_gn+=" use_kerberos=$(usex kerberos true false)"
	myconf_gn+=" use_pulseaudio=$(usex pulseaudio true false)"
	myconf_gn+=" use_vaapi=$(usex vaapi true false)"
	myconf_gn+=" rtc_use_pipewire=$(usex screencast true false) rtc_pipewire_version=\"0.3\""

	# TODO: link_pulseaudio=true for GN.

	myconf_gn+=" fieldtrial_testing_like_official_build=true"

	# Never use bundled gold binary. Disable gold linker flags for now.
	# Do not use bundled clang.
	# Trying to use gold results in linker crash.
	myconf_gn+=" use_gold=false use_sysroot=false use_custom_libcxx=false"

	if use clang || tc-is-clang ; then
		filter-flags -fuse-ld=*
		myconf_gn+=" use_lld=true"
	else
		myconf_gn+=" use_lld=false"
	fi

	# Disable pseudolocales, only used for testing
	myconf_gn+=" enable_pseudolocales=false"

	ffmpeg_branding="$(usex proprietary-codecs Chrome Chromium)"
	myconf_gn+=" proprietary_codecs=$(usex proprietary-codecs true false)"
	myconf_gn+=" ffmpeg_branding=\"${ffmpeg_branding}\""

	# Set up Google API keys, see http://www.chromium.org/developers/how-tos/api-keys .
	# Note: these are for Gentoo use ONLY. For your own distribution,
	# please get your own set of keys. Feel free to contact chromium@gentoo.org
	# for more info.
	local google_api_key="AIzaSyDEAOvatFo0eTgsV_ZlEzx0ObmepsMzfAc"
	local google_default_client_id="329227923882.apps.googleusercontent.com"
	local google_default_client_secret="vgKG0NNv7GoDpbtoFNLxCUXu"
	myconf_gn+=" google_api_key=\"${google_api_key}\""
	myconf_gn+=" google_default_client_id=\"${google_default_client_id}\""
	myconf_gn+=" google_default_client_secret=\"${google_default_client_secret}\""
	local myarch="$(tc-arch)"

	# Avoid CFLAGS problems, bug #352457, bug #390147.
	if ! use custom-cflags; then
		replace-flags "-Os" "-O2"
		strip-flags

		# Debug info section overflows without component build
		# Prevent linker from running out of address space, bug #471810 .
		if ! use component-build || use x86; then
			filter-flags "-g*"
		fi

		# Prevent libvpx build failures. Bug 530248, 544702, 546984.
		if [[ ${myarch} == amd64 || ${myarch} == x86 ]]; then
			filter-flags -mno-mmx -mno-sse2 -mno-ssse3 -mno-sse4.1 -mno-avx -mno-avx2 -mno-fma -mno-fma4
		fi
	fi

	if use libcxx ; then
		append-flags -stdlib=libc++
		append-ldflags -stdlib=libc++
	fi

	if [[ $myarch = amd64 ]] ; then
		myconf_gn+=" target_cpu=\"x64\""
		ffmpeg_target_arch=x64
	elif [[ $myarch = x86 ]] ; then
		myconf_gn+=" target_cpu=\"x86\""
		ffmpeg_target_arch=ia32

		# This is normally defined by compiler_cpu_abi in
		# build/config/compiler/BUILD.gn, but we patch that part out.
		append-flags -msse2 -mfpmath=sse -mmmx
	elif [[ $myarch = arm64 ]] ; then
		myconf_gn+=" target_cpu=\"arm64\""
		ffmpeg_target_arch=arm64
	elif [[ $myarch = arm ]] ; then
		myconf_gn+=" target_cpu=\"arm\""
		ffmpeg_target_arch=$(usex cpu_flags_arm_neon arm-neon arm)
	elif [[ $myarch = ppc64 ]] ; then
		myconf_gn+=" target_cpu=\"ppc64\""
		ffmpeg_target_arch=ppc64
	else
		die "Failed to determine target arch, got '$myarch'."
	fi

	local target_cpu=""
	case "${ABI}" in
		amd64*|x64*)
			target_cpu="x64"
			;;
		arm|n32|n64|o32)
			target_cpu="${chost%%-*}"
			;;
		arm64|ppc|ppc64|s390*)
			target_cpu="${ABI}"
			;;
		ppc_aix,ppc_macos)
			target_cpu="ppc"
			;;
		x86*)
			target_cpu="x86"
			;;
		*)
			einfo "${ABI} is not supported"
			;;
	esac

	myconf_gn+=" target_cpu=\"${target_cpu}\" v8_current_cpu=\"${target_cpu}\" current_cpu=\"${target_cpu}\" host_cpu=\"${target_cpu}\" "
	myconf_gyp+=" -Dtarget_arch=${target_arch}"

	# Make sure that -Werror doesn't get added to CFLAGS by the build system.
	# Depending on GCC version the warnings are different and we don't want
	# the build to fail because of that.
	myconf_gn+=" treat_warnings_as_errors=false"

	# Disable fatal linker warnings, bug 506268.
	myconf_gn+=" fatal_linker_warnings=false"

	# Bug 491582.
	export TMPDIR="${WORKDIR}/temp"
	mkdir -p -m 755 "${TMPDIR}" || die

	# https://bugs.gentoo.org/654216
	addpredict /dev/dri/ #nowarn

	#if ! use system-ffmpeg; then
	if false; then
		local build_ffmpeg_args=""
		if use pic && [[ "${ffmpeg_target_arch}" == "ia32" ]]; then
			build_ffmpeg_args+=" --disable-asm"
		fi

		# Re-configure bundled ffmpeg. See bug #491378 for example reasons.
		einfo "Configuring bundled ffmpeg..."
		pushd third_party/ffmpeg > /dev/null || die
		chromium/scripts/build_ffmpeg.py linux ${ffmpeg_target_arch} \
			--branding ${ffmpeg_branding} -- ${build_ffmpeg_args} || die
		chromium/scripts/copy_config.sh || die
		chromium/scripts/generate_gn.py || die
		popd > /dev/null || die
	fi

	# Chromium relies on this, but was disabled in >=clang-10, crbug.com/1042470
	append-cxxflags $(test-flags-CXX -flax-vector-conversions=all)

	# highway/libjxl relies on this with arm64
	if use arm64 && tc-is-gcc; then
		append-cxxflags -flax-vector-conversions
	fi

	# highway/libjxl fail on ppc64 without extra patches, disable for now.
	use ppc64 && myconf_gn+=" enable_jxl_decoder=false"

	# Disable unknown warning message from clang.
	tc-is-clang && append-flags -Wno-unknown-warning-option

	# Explicitly disable ICU data file support for system-icu builds.
	if use system-icu; then
		myconf_gn+=" icu_use_data_file=false"
	fi

	# Enable ozone wayland and/or headless support
	myconf_gn+=" use_ozone=true ozone_auto_platforms=false"
	myconf_gn+=" ozone_platform_headless=true"
	if use wayland || use headless; then
		if use headless; then
			myconf_gn+=" ozone_platform=\"headless\""
			myconf_gn+=" use_x11=false"
		else
			myconf_gn+=" ozone_platform_wayland=true"
			myconf_gn+=" use_system_libdrm=true"
			myconf_gn+=" use_system_minigbm=true"
			myconf_gn+=" use_xkbcommon=true"
			myconf_gn+=" ozone_platform=\"wayland\""
		fi
	fi

	# Enable official builds
	myconf_gn+=" is_official_build=$(usex official true false)"
	if use clang || tc-is-clang ; then
		ewarn "Using ThinLTO"
		myconf_gn+=" use_thin_lto=true "
	else
		# gcc doesn't like -fsplit-lto-unit and -fwhole-program-vtables
		myconf_gn+=" use_thin_lto=false "
	fi
	if use official; then
		# Allow building against system libraries in official builds
		sed -i 's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' \
			tools/generate_shim_headers/generate_shim_headers.py || die
	fi

	# See https://github.com/chromium/chromium/blob/92.0.4515.107/build/config/sanitizers/BUILD.gn#L196
	if use cfi ; then
		myconf_gn+=" is_cfi=true"
	else
		myconf_gn+=" is_cfi=false"
	fi

	# See https://github.com/chromium/chromium/blob/92.0.4515.107/tools/mb/mb_config.pyl#L2950
	if use cfi-full ; then
		myconf_gn+=" use_cfi_cast=true"
	else
		myconf_gn+=" use_cfi_cast=false"
	fi

	if use cfi-icall ; then
		myconf_gn+=" use_cfi_icall=true"
	else
		myconf_gn+=" use_cfi_icall=false"
	fi

	# See also build/config/compiler/pgo/BUILD.gn#L71 for PGO flags.
	# See also https://github.com/chromium/chromium/blob/92.0.4515.107/docs/pgo.md
	# profile-instr-use is clang which that file assumes but gcc doesn't have.
	if use pgo-native ; then
		myconf_gn+=" chrome_pgo_phase=${PGO_PHASE}"
		mkdir -p "${BUILD_DIR}/chrome/build/pgo_profiles" || die
		[[ "${PGO_PHASE}" == "2" ]] && \
		myconf_gn+=" pgo_data_path=\"${BUILD_DIR}/chrome/build/pgo_profiles/custom.profdata\""
	elif use pgo && tc-is-clang && ver_test $(clang-version) -ge 11 ; then
		# The profile data is already shipped so use it.
		# PGO profile location: chrome/build/pgo_profiles/chrome-linux-*.profdata
		myconf_gn+=" chrome_pgo_phase=2"
	else
		# The pregenerated profiles are not GCC compatible.
		myconf_gn+=" chrome_pgo_phase=0"
	fi

	einfo "Configuring Chromium..."
	set -- gn gen --args="${myconf_gn} ${EXTRA_GN}" out/Release
	echo "$@"
	"$@" || die
}

_build_pgx() {
	if [[ -f build.ninja ]] ; then
		einfo "Cleaning out build"
		eninja -t clean
	fi
	# Build mksnapshot and pax-mark it.
	local x
	for x in mksnapshot v8_context_snapshot_generator; do
		einfo "Building ${x}"
		if tc-is-cross-compiler; then
			eninja -C out/Release "host/${x}"
			pax-mark m "out/Release/host/${x}"
		else
			eninja -C out/Release "${x}"
			pax-mark m "out/Release/${x}"
		fi
	done
}

# The most intensive computational parts should be pushed in hot section that
# need boosting that way if you encounter in them again they penalize less.
_javascript_benchmark() {
	einfo "Running simulation:  metering javascript engine performance... timeboxed to 25 minutes"
	[[ ! -f out/Release/chrome ]] && die "Missing out/Release/chrome"

	local have_gpu="false"
	if use pgo-gpu ; then
		have_gpu="true"
	fi

	cat <<EOF > "${BUILD_DIR}/run.sh"
#!/bin/bash
main() {
	cat /dev/null > "${T}/test-retcode.log"
	cd "${BUILD_DIR}"
	( timeout 1465 out/Release/chrome ; echo "$?" > "${T}/test-retcode.log" ) &
	sleep 0.2 # let the app load
	local id=\$(xdotool getwindowfocus)
	sleep 0.2 # let the window load
	xdotool windowsize ${id} 1918 1059
	xdotool windowmove ${id} -3840 19

	_handle_new_install_window

	# benchmark #1
	# Runs in about 50 seconds
	xdotool key --window ${id} ctrl+l
	xdotool type --window ${id} "https://chromium.github.io/octane/"
	xdotool key Return
	sleep 24 # let the page load.  It takes about 12s.

	# click start
	xdotool mousemove 909 267
	xdotool click

	sleep 120 # 1 min run + 1 min slack

	# benchmark #2 for WebAssembly also
	# Runs in about 12 minutes
	xdotool key --window ${id} ctrl+l
	xdotool type --window ${id} "https://browserbench.org/JetStream/"
	xdotool key Return
	sleep 40 # let the page load.  it takes some time about 20s.

	# click start
	xdotool mousemove 948 335
	xdotool click

	sleep 840 # 12 min run + 2 min slack

	# benchmark #3 for HTML5 Canvas benchmark
	# Runs in about 2 minutes
	# Disabled because xvfb is software rendering
	if ${have_gpu} ; then
		xdotool key --window ${id} ctrl+l
		xdotool type --window ${id} "https://www.kevs3d.co.uk/dev/canvasmark/"
		xdotool key Return
		sleep 140 # let the page load.  it takes some time about 70s.

		# click start
		xdotool mousemove 693 493
		xdotool click

		sleep 180 # 2 min run + 1 min slack
	fi

	# benchmark #4 webgl
	if ${have_gpu} ; then
		xdotool key --window ${id} ctrl+l
		xdotool type --window ${id} "https://webglsamples.org/aquarium/aquarium.html"
		xdotool key Return
		sleep 120 # 1 min run + 1 min slack
	fi

	echo -n "\$?" > "${T}/test-retcode.log"
	exit \$(cat "${T}/test-retcode.log")
}
main
EOF
	chmod +x "${BUILD_DIR}/run.sh" || die
	if use pgo-gpu ; then
		ewarn "FIXME:  replace with accelerated X wrapper.  still using xvfb."
		virtx "${BUILD_DIR}/run.sh"
	else
		virtx "${BUILD_DIR}/run.sh"
	fi

	sleep 1465

	if [[ -f "${T}/test-retcode.log" ]] ; then
		die "Missing retcode for ${x}"
	fi
	local test_retcode=$(cat "${T}/test-retcode.log")
	if [[ "${test_retcode}" != "0" ]] ; then
eerror "Test failed for ${x}.  Return code: ${test_retcode}."
		die
	fi
}

_load_simulation() {
	einfo "Running simulation:  metering load-time performance... timeboxed to 3 minutes"
	[[ ! -f out/Release/chrome ]] && die "Missing out/Release/chrome"
	cat <<EOF > "${BUILD_DIR}/run.sh"
#!/bin/bash
# Handles a window with 2 checkboxes and an OK
_handle_new_install_window() {
	local id=\$(xdotool getwindowfocus)
	sleep 0.2 # let the window load
	xdotool windowsize ${id} 1918 1059
	xdotool windowmove ${id} -3840 19

	# no making default browser
	xdotool mousemove 26 22
	xdotool click

	# no sending statistics to G
	xdotool mousemove 26 56
	xdotool click

	# OK - close window
	xdotool mousemove 1870 1052
	xdotool click
}

main() {
	cat /dev/null > "${T}/test-retcode.log"
	cd "${BUILD_DIR}"
	( timeout 180 out/Release/chrome ; echo "$?" > "${T}/test-retcode.log" ) &
	_handle_new_install_window
	sleep 180
	echo -n "\$?" > "${T}/test-retcode.log"
	exit \$(cat "${T}/test-retcode.log")
}
main
EOF
	chmod +x "${BUILD_DIR}/run.sh" || die
	if use pgo-gpu ; then
		ewarn "FIXME:  replace with accelerated X wrapper.  still using xvfb."
		virtx "${BUILD_DIR}/run.sh"
	else
		virtx "${BUILD_DIR}/run.sh"
	fi

	sleep 181

	if [[ -f "${T}/test-retcode.log" ]] ; then
		die "Missing retcode for ${x}"
	fi
	local test_retcode=$(cat "${T}/test-retcode.log")
	if [[ "${test_retcode}" != "0" ]] ; then
eerror "Test failed for ${x}.  Return code: ${test_retcode}."
		die
	fi
}

_tabs_simulation() {
	einfo "Running simulation:  metering load-time performance... timeboxed to 6+ minutes"
	[[ ! -f out/Release/chrome ]] && die "Missing out/Release/chrome"

	local urilen
	local uris_=()
	if [[ -z "${ECHROMIUM_PGO_URIS}" ]] ; then
# This goes through open source or open content websites mostly to make
# sure that image code paths are loaded in the hot section and not
# demoted from optimization.  Hot parts get pushed up the memory
# hierarchy.
# Assume 20 seconds per URI load time.
		uris_=(
'https://search.creativecommons.org/search?q=nature&license=cc0'
'https://search.creativecommons.org/search?q=bugs&license=cc0'
'https://search.creativecommons.org/search?q=waterfalls&license=cc0'
'https://search.creativecommons.org/search?q=clipart&license=cc0&extension=svg'
'https://search.creativecommons.org/search?q=skyline&license=cc0&extension=jpg'
'https://search.creativecommons.org/search?q=fish&license=cc0&extension=png'
'https://search.creativecommons.org/search?q=animated&license=cc0&extension=gif'
'https://wiki.gentoo.org/wiki/Main_Page'
		) # 160s
	else
		uris_=( ${ECHROMIUM_PGO_URIS} )
	fi
	urilen=${#uris_[@]}

	local experiment_duration=$(( ${urilen} * 20 + 150 + ${urilen} ))
	cat <<EOF > "${BUILD_DIR}/run.sh"
#!/bin/bash
main() {
	cat /dev/null > "${T}/test-retcode.log"
	cd "${BUILD_DIR}"
	( timeout ${experiment_duration} out/Release/chrome ; echo "$?" > "${T}/test-retcode.log" ) &
	sleep 0.2 # let the app load
	local id=\$(xdotool getwindowfocus)
	sleep 0.2 # let the window load
	xdotool windowsize ${id} 1918 1059
	xdotool windowmove ${id} -3840 19

	local uris=( ${uris_[@]} )

	# Measure image management, and tab creation
	local tab_limit=20
	local tab_count=1
	local n_closed=0
	for u in ${uris[@]} ; do
		xdotool key --window ${id} ctrl+t
		tab_count=$((${tab_count}+1))
		xdotool key --window ${id} ctrl+l
		xdotool type --window ${id} "${u}"
		xdotool key Return
		sleep 20 # let the page load
		if (( ${tab_count} > ${tab_limit} )) ; then
			xdotool key --window ${id} ctrl+1
			xdotool key --window ${id} ctrl+w
			xdotool key --window ${id} ctrl+9
			n_closed=$((${n_closed}+1))
		fi
	done

	# Simulate tab switching in 2.5 min
	for x in $(seq 1 300) ; do
		xdotool key --window ${id} ctrl+$(($((${RANDOM}  % 9)) + 1))
		sleep 0.5
	done # 150s

	for u in $(seq 1 $((${#uris[@]}-${n_closed}))) ; do
		xdotool key --window ${id} ctrl+w
	done

	echo -n "\$?" > "${T}/test-retcode.log"
	exit \$(cat "${T}/test-retcode.log")
}
main
EOF
	chmod +x "${BUILD_DIR}/run.sh" || die
	if use pgo-gpu ; then
		ewarn "FIXME:  replace with accelerated X wrapper.  still using xvfb."
		virtx "${BUILD_DIR}/run.sh"
	else
		virtx "${BUILD_DIR}/run.sh"
	fi

	sleep ${experiment_duration}

	if [[ -f "${T}/test-retcode.log" ]] ; then
		die "Missing retcode for ${x}"
	fi
	local test_retcode=$(cat "${T}/test-retcode.log")
	if [[ "${test_retcode}" != "0" ]] ; then
eerror "Test failed for ${x}.  Return code: ${test_retcode}."
		die
	fi
}

_responsiveness_simulation() {
	# It runs actually in around a minute.
	einfo "Running simulation:  metering load-time performance... timeboxed to 136 seconds"
	[[ ! -f out/Release/chrome ]] && die "Missing out/Release/chrome"
	cat <<EOF > "${BUILD_DIR}/run.sh"
#!/bin/bash
main() {
	cat /dev/null > "${T}/test-retcode.log"
	cd "${BUILD_DIR}"
	( timeout 136 out/Release/chrome "https://browserbench.org/Speedometer2.0/" ; echo "$?" > "${T}/test-retcode.log" ) &
	sleep 0.2 # let the app load

	local id=\$(xdotool getwindowfocus)

	sleep 0.2 # let the window load
	xdotool windowsize ${id} 1918 1059
	xdotool windowmove ${id} -3840 19

	xdotool mousemove 991 627
	sleep 15 # let the page load
	xdotool click
	sleep 120 # 1 min run + 1 min slack
	echo -n "\$?" > "${T}/test-retcode.log"
	exit \$(cat "${T}/test-retcode.log")
}
main
EOF
	chmod +x "${BUILD_DIR}/run.sh" || die
	if use pgo-gpu ; then
		ewarn "FIXME:  replace with accelerated X wrapper.  still using xvfb."
		virtx "${BUILD_DIR}/run.sh"
	else
		virtx "${BUILD_DIR}/run.sh"
	fi

	sleep 136

	if [[ -f "${T}/test-retcode.log" ]] ; then
		die "Missing retcode for ${x}"
	fi
	local test_retcode=$(cat "${T}/test-retcode.log")
	if [[ "${test_retcode}" != "0" ]] ; then
eerror "Test failed for ${x}.  Return code: ${test_retcode}."
		die
	fi
}

_custom_simulation() {
	# It runs actually in around a minute.
	einfo "Running simulation:  metering custom script performance... timeboxed to ${ECHROMIUM_CUSTOM_TIMEBOX_TIME} seconds"
	[[ ! -f out/Release/chrome ]] && die "Missing out/Release/chrome"
	sleep 0.2 # let the app load
	( timeout ${ECHROMIUM_CUSTOM_TIMEBOX_TIME} out/Release/chrome "https://localhost" ; echo "$?" > "${T}/test-retcode.log" ) &
	cp -a "/etc/portage/pgo-scripts/www-client/chromium/${PV}.sh" \
		"${T}/run.sh"
	chmod +x "${BUILD_DIR}/run.sh" || die
	if use pgo-gpu ; then
		ewarn "FIXME:  replace with accelerated X wrapper.  still using xvfb."
		virtx "${BUILD_DIR}/run.sh"
	else
		virtx "${BUILD_DIR}/run.sh"
	fi

	sleep ${ECHROMIUM_CUSTOM_TIMEBOX_TIME}

	if [[ -f "${T}/test-retcode.log" ]] ; then
		die "Missing retcode for ${x}"
	fi
	local test_retcode=$(cat "${T}/test-retcode.log")
	if [[ "${test_retcode}" != "0" ]] ; then
eerror "Test failed for ${x}.  Return code: ${test_retcode}."
		die
	fi
}

_run_simulation_suite() {
	if use pgo-upstream-profile-generator ; then
		# See also https://github.com/chromium/chromium/blob/92.0.4515.107/docs/pgo.md
		${EPYTHON} tools/perf/run_benchmark \
			system_health.common_desktop \
			--assert-gpu-compositing \
			--run-abridged-story-set \
			--browser=exact \
			--browser-executable=out/Release/chrome || die
		${EPYTHON} tools/perf/run_benchmark \
			speedometer2 \
			--assert-gpu-compositing \
			--browser=exact \
			--browser-executable=out/Release/chrome || die
	elif use pgo-ebuild-profile-generator ; then
		ewarn "_run_simulations(): 🐧 <penguin emoji> please finish me!"
		einfo "Running training exercise simulations"
		_load_simulation
		use pgo-web && _tabs_simulation
		use pgo-web && _javascript_benchmark
		use pgo-web && _responsiveness_simulation
		if use pgo-custom-script ; then
			if [[ ! -f "/etc/portage/pgo-scripts/www-client/chromium/${PV}.sh" ]] ; then
				eerror "Missing /etc/portage/pgo-scripts/www-client/chromium/${PV}.sh"
				die
			fi
			_custom_simulation
		fi
	fi
}

_run_simulations() {
	_run_simulation_suite
	llvm-profdata merge *.profraw -o "${BUILD_DIR}/chrome/build/pgo_profiles/custom.profdata" || die
}

multilib_src_compile() {
	# Final link uses lots of file descriptors.
	ulimit -n 2048

	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	# https://bugs.gentoo.org/717456
	# don't inherit PYTHONPATH from environment, bug #789021
	local -x PYTHONPATH="${WORKDIR}/setuptools-44.1.0"

	#"${EPYTHON}" tools/clang/scripts/update.py --force-local-build --gcc-toolchain /usr --skip-checkout --use-system-cmake --without-android || die

	if use pgo-native ; then
		if ls *.profraw 2>/dev/null 1>/dev/null ; then
			rm -rf *.profraw || die
		fi
		PGO_PHASE=1
		_configure_pgx # pgi
		_build_pgx
		_run_simulations
		PGO_PHASE=2
		_configure_pgx # pgo
		_build_pgx
	else
		_configure_pgx # pgo / no-pgo
		_build_pgx
	fi

	# Even though ninja autodetects number of CPUs, we respect
	# user's options, for debugging with -j 1 or any other reason.
	eninja -C out/Release chrome chromedriver
	use suid && eninja -C out/Release chrome_sandbox

	pax-mark m out/Release/chrome

	mv out/Release/chromedriver{.unstripped,} || die

	# Build manpage; bug #684550
	sed -e 's|@@PACKAGE@@|chromium-browser|g;
		s|@@MENUNAME@@|Chromium|g;' \
		chrome/app/resources/manpage.1.in > \
		out/Release/chromium-browser.1 || die

	# Build desktop file; bug #706786
	sed -e 's|@@PACKAGE@@|chromium-browser|g;
		s|\(^Exec=\)/usr/bin/|\1|g;' \
		chrome/installer/linux/common/desktop.template > \
		out/Release/chromium-browser-chromium.desktop || die
	sed -i -e "s|@@MENUNAME@@|Chromium (${ABI})|g" \
		-e "s|@@USR_BIN_SYMLINK_NAME@@|chromium-browser-${ABI}|g" \
		out/Release/chromium-browser-chromium.desktop || die
}

multilib_src_install() {
	local CHROMIUM_HOME="/usr/$(get_libdir)/chromium-browser"
	exeinto "${CHROMIUM_HOME}"
	doexe out/Release/chrome

	if use suid; then
		newexe out/Release/chrome_sandbox chrome-sandbox
		fperms 4755 "${CHROMIUM_HOME}/chrome-sandbox"
	fi

	newexe out/Release/chromedriver chromedriver-${ABI}
	doexe out/Release/crashpad_handler

	local sedargs=( -e
			"s:/usr/lib/:/usr/$(get_libdir)/:g;
			s:chromium-browser-chromium.desktop:chromium-browser-chromium-${ABI}.desktop:g;
			s:@@OZONE_AUTO_SESSION@@:$(usex wayland true false):g;
			s:@@FORCE_OZONE_PLATFORM@@:$(usex headless true false):g"
	)
	sed "${sedargs[@]}" "${FILESDIR}/chromium-launcher-r6.sh" > chromium-launcher.sh || die
	newexe chromium-launcher.sh chromium-launcher-${ABI}.sh

	# It is important that we name the target "chromium-browser",
	# xdg-utils expect it; bug #355517.
	dosym "${CHROMIUM_HOME}/chromium-launcher-${ABI}.sh" /usr/bin/chromium-browser-${ABI}
	dosym "${CHROMIUM_HOME}/chromium-launcher-${ABI}.sh" /usr/bin/chromium-browser
	# keep the old symlink around for consistency
	dosym "${CHROMIUM_HOME}/chromium-launcher-${ABI}.sh" /usr/bin/chromium-${ABI}
	dosym "${CHROMIUM_HOME}/chromium-launcher-${ABI}.sh" /usr/bin/chromium

	dosym "${CHROMIUM_HOME}/chromedriver-${ABI}" /usr/bin/chromedriver-${ABI}
	dosym "${CHROMIUM_HOME}/chromedriver-${ABI}" /usr/bin/chromedriver

	# Allow users to override command-line options, bug #357629.
	insinto /etc/chromium
	newins "${FILESDIR}/chromium.default" "default"

	pushd out/Release/locales > /dev/null || die
	chromium_remove_language_paks
	popd

	insinto "${CHROMIUM_HOME}"
	doins out/Release/*.bin
	doins out/Release/*.pak
	(
		shopt -s nullglob
		local files=(out/Release/*.so out/Release/*.so.[0-9])
		[[ ${#files[@]} -gt 0 ]] && doins "${files[@]}"
	)

	if ! use system-icu; then
		doins out/Release/icudtl.dat
	fi

	doins -r out/Release/locales
	doins -r out/Release/resources

	if [[ -d out/Release/swiftshader ]]; then
		insinto "${CHROMIUM_HOME}/swiftshader"
		doins out/Release/swiftshader/*.so
	fi

	# Install icons
	local branding size
	for size in 16 24 32 48 64 128 256 ; do
		case ${size} in
			16|32) branding="chrome/app/theme/default_100_percent/chromium" ;;
				*) branding="chrome/app/theme/chromium" ;;
		esac
		newicon -s ${size} "${branding}/product_logo_${size}.png" \
			chromium-browser.png
	done

	# Install desktop entry
	newmenu out/Release/chromium-browser-chromium.desktop chromium-browser-chromium-${ABI}.desktop

	# Install GNOME default application entry (bug #303100).
	insinto /usr/share/gnome-control-center/default-apps
	newins "${FILESDIR}"/chromium-browser.xml chromium-browser.xml

	# Install manpage; bug #684550
	doman out/Release/chromium-browser.1
	dosym chromium-browser.1 /usr/share/man/man1/chromium.1

	readme.gentoo_create_doc
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	readme.gentoo_print_elog

	if use vaapi; then
		elog "VA-API is disabled by default at runtime. You have to enable it"
		elog "by adding --enable-features=VaapiVideoDecoder to CHROMIUM_FLAGS"
		elog "in /etc/chromium/default."
	fi
	if use screencast; then
		elog "Screencast is disabled by default at runtime. Either enable it"
		elog "by navigating to chrome://flags/#enable-webrtc-pipewire-capturer"
		elog "inside Chromium or add --enable-webrtc-pipewire-capturer"
		elog "to CHROMIUM_FLAGS in /etc/chromium/default."
	fi

einfo
einfo "By default, the /usr/bin/chromium and /usr/bin/chromedriver symlinks are"
einfo "set to the last ABI installed.  You must change it manually if you want"
einfo "to run on a different default ABI."
einfo
einfo "Examples:"
einfo
einfo "  ln -sf /usr/lib64/chromium-browser/chromium-launcher-${ABI}.sh /usr/bin/chromium"
einfo "  ln -sf /usr/lib/chromium-browser/chromium-launcher-${ABI}.sh /usr/bin/chromium"
einfo "  ln -sf /usr/lib32/chromium-browser/chromium-launcher-${ABI}.sh /usr/bin/chromium"
einfo "  ln -sf /usr/lib32/chromium-browser/chromedriver-${ABI} /usr/bin/chromedriver"
einfo
}
