# Copyright 2009-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Monitor
#   https://chromereleases.googleblog.com/search/label/Dev%20updates
# for security updates.  They are announced faster than NVD.
# See https://omahaproxy.appspot.com/ for the latest linux version

EAPI=7
PYTHON_COMPAT=( python3_{8,9} )
PYTHON_REQ_USE="xml"

CHROMIUM_LANGS="am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk vi zh-CN zh-TW"

EPGO_CUSTOM_SIMULATION_TIMEBOX_TIME=${EPGO_CUSTOM_SIMULATION_TIMEBOX_TIME:=120}
EPGO_TEST_SLACK_TIME=${EPGO_TEST_SLACK_TIME:=0} # \
# test duration adjustment for different kinds of hardware.  Increase for slower
# or older hardware
EPGO_WAIT_SLACK_TIME=${EPGO_WAIT_SLACK_TIME:=0} # \
# pause duration adjustment for different kinds of hardware.  Increase for slower
# or older hardware
EPGO_BROWSER_COLD_LAUNCH_TIME=${EPGO_BROWSER_COLD_LAUNCH_TIME:=45} # \
# Length of time it takes to cold launch chromium.  It takes around 22s.
EPGO_BROWSER_CACHED_LAUNCH_TIME=${EPGO_BROWSER_CACHED_LAUNCH_TIME:=2} # \
# Dumped and then immediately launched. It takes around 1s.
EPGO_DESKTOP_COLD_LAUNCH_TIME=${EPGO_DESKTOP_COLD_LAUNCH_TIME:=20} # \
# Length of time it takes to cold launch xserver+dwm.  It takes around 10s.
EPGO_DESKTOP_CACHED_LAUNCH_TIME=${EPGO_DESKTOP_CACHED_LAUNCH_TIME:=4} # \
# Length of time it takes to cold launch xserver+dwm.  It takes around 2s.
EPGO_DESKTOP_CLOSE_TIME=3 # \
# Length of time it takes to close the xserver normally.
EPGO_FCP=${EPGO_FCP:=14} # \
# FCP = First contentful paint (time from pressing enter on URI bar to first
# image that appears).  It takes around 2 seconds.  This has been adjusted
# to double the time for the most essential element or button.
EPGO_LCP=${EPGO_LCP:=20} # \
# LCP = Last contentful paint (time it takes to complete rendering or loading a
# page) assuming average case.  Worst cases are around 70s.

# Cold times are pre run with `sync; echo 3 > /proc/sys/vm/drop_caches`

VIRTUALX_REQUIRED=manual
LLVM_MAX_SLOT=13
inherit check-reqs chromium-2 desktop flag-o-matic llvm multilib ninja-utils pax-utils portability python-any-r1 readme.gentoo-r1 toolchain-funcs xdg-utils
inherit multilib-minimal virtualx

DESCRIPTION="Open-source version of Google Chrome web browser"
HOMEPAGE="https://chromium.org/"
PATCHSET="6"
PATCHSET_NAME="chromium-$(ver_cut 1)-patchset-${PATCHSET}"
SRC_URI="
	https://commondatastorage.googleapis.com/chromium-browser-official/${P}.tar.xz
	https://github.com/stha09/chromium-patches/releases/download/${PATCHSET_NAME}/${PATCHSET_NAME}.tar.xz
	https://dev.gentoo.org/~sultan/distfiles/www-client/${PN}/${PN}-92-glibc-2.33-patch.tar.xz
	arm64? ( https://github.com/google/highway/archive/refs/tags/0.12.1.tar.gz -> highway-0.12.1.tar.gz )"
RESTRICT="mirror"
PROPERTIES="interactive" # for sudo
# The PGO plan: pgo is a non-root account that will start X in another vt and
# run X.  This ebuild will load the browser and run macros pushed to that vt
# and DISPLAY.  This is why this ebuild is interactive.  The other cause
# may be due to elogind explained in
# https://forums.gentoo.org/viewtopic-p-8488777.html#8488777
# which needs to create a session and the X server needs to be the same user
# that started the session.

PGO_EBUILD_GENERATOR_SITE_LICENSES=(
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
PGO_UPSTREAM_GENERATOR_SITE_LICENSES=(
	MIT
	Apache-2.0
)
# search.creativecommons.org CC-BY-4.0 (Content attributed to Creative Commons)
# search.creativecommons.org image search results CC0-1.0
# wiki.gentoo.org CC-BY-SA-3.0 (Content attributed to Gentoo Foundation, Inc)
# www.kevs3d.co.uk MIT with link back clause
# Under the hood of the JetStream 2 benchmark:
#   https://github.com/WebKit/WebKit/tree/main/Websites/browserbench.org/JetStream2.0 \
#     and internal third party dependencies BSD-2, BSD, GPL-2, GPL-2+, \
#     LGPL-2.1, MIT
# Under the hood of the Octane benchmark:
#   https://github.com/chromium/octane and internal third party dependencies \
#     BSD, GPL-2+, MIT, (all rights reserved MIT), ZLIB, Apache-2.0
#   https://github.com/chromium/octane/blob/master/crypto.js \
#     all-rights-reserved MIT (the plain MIT license doesn't contain \
#     all rights reserved)
#   https://github.com/chromium/octane/blob/master/js/bootstrap-collapse.js
# Under the hood of the the Speedometer 2.0 benchmark:
#   https://github.com/WebKit/WebKit/tree/main/PerformanceTests/Speedometer \
#     or internal third party dependencies MIT, Apache-2.0
LICENSE="BSD
	chromium-93.0.4577.x
	APSL-2
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	( all-rights-reserved MIT )
	BSD-2
	BSD-4
	base64
	CC-BY-4.0
	CC-BY-ND-2.5
	FTL
	fft2d
	GPL-2+
	g711
	g722
	IJG
	ISC
	( ISC CC-BY-SA-4.0 )
	Khronos-CLHPP
	LGPL-2
	LGPL-2+
	LGPL-2.1+
	libpng2
	libwebrtc-PATENTS
	MIT
	( MIT CC0-1.0 )
	MPL-1.1
	MPL-2.0
	neon_2_sse
	OFL-1.1
	ooura
	openssl
	PSF-2
	QU-fft
	Unlicense
	UoI-NCSA
	unRAR
	unicode
	SGI-B-2.0
	SunPro
	svgo
	WTFPL-2
	x11proto
	ZLIB
	pgo-ebuild-profile-generator? ( ${PGO_EBUILD_GENERATOR_SITE_LICENSES} )
	pgo-upstream-profile-generator? ( ${PGO_UPSTREAM_GENERATOR_SITE_LICENSES} )
	widevine? ( widevine )"
LICENSE_FINGERPRINT="\
147e32b00489a9b0023d720066a1db648d4104fe81d8e764902a44a2eb650308\
9a6781dfb64901f5460758d17227e5f0e8f1dfb8fe6c14e6afc7374b6f0e028e" # SHA512
# Third Party Licenses:
#
# TODO:  The rows marked custom need to have or be placed a license file or
#        reevaluated.
# TODO:  scan all font files for embedded licenses
#
# ^^ ( FTL GPL-2 ) ZLIB public-domain - third_party/freetype/src/LICENSE.TXT
# ^^ ( GPL-2+ LGPL-2+ MPL-1.1 ) - chrome/utility/importer/nss_decryptor.cc
# ^^ ( GPL-2+ LGPL-2.1+ MPL-1.1 ) BSD BSD-2 - third_party/libgifcodec/LICENSE.md
# || ( WTFPL-2 Apache-2.0 ) - \
#   third_party/catapult/third_party/polymer2/bower_components/sinon-chai/LICENSE.txt ; \
#   the WTFPL is the better choice because Apache-2.0 has more restrictions
# || ( MIT GPL-3 ) third_party/catapult/tracing/third_party/jszip/LICENSE.markdown ; \
#   upstream has more MIT than GPL3 copyright notices, so MIT is assumed
# APSL-2 - third_party/apple_apsl/LICENSE
# APSL-2 Apache-2.0 BSD MIT - third_party/breakpad/LICENSE
# Apache 2.0 - third_party/node/node_modules/typescript/LICENSE.txt
# Apache-2.0-with-LLVM-exceptions UoI-NCSA - \
#   third_party/llvm/debuginfo-tests/dexter/LICENSE.txt
# Apache-2.0-with-LLVM-exceptions UoI-NCSA MIT - third_party/llvm/libclc/LICENSE.TXT
# all-rights-reserved MIT - third_party/xcbproto/LICENSE ; the plain MIT \
#   license doesn't come with all rights reserved in the license template
# BSD - third_party/vulkan-deps/glslang/src/LICENSE.txt
# BSD ^^ ( MPL-1.1 GPL-2+ LGPL-2+ ) - \
#   third_party/openscreen/src/third_party/mozilla/LICENSE.txt
# BSD ISC MIT openssl - third_party/boringssl/src/LICENSE
# BSD MPL-1.1 - url/third_party/mozilla/LICENSE.txt
# BSD-2 - third_party/node/node_modules/eslint-scope/LICENSE
# BSD-2 IJG MIT - third_party/libavif/src/LICENSE
# base64 - third_party/webrtc/rtc_base/third_party/base64/LICENSE
# custom - third_party/llvm/clang-tools-extra/clang-tidy/cert/LICENSE.TXT
# custom - third_party/llvm/clang-tools-extra/clang-tidy/hicpp/LICENSE.TXT
# custom ^^ ( BSD-2 BSD ) - third_party/blink/LICENSE_FOR_ABOUT_CREDITS
# custom Apache-2.0-with-LLVM-exceptions UoI-NCSA third_party/llvm/openmp/LICENSE.TXT
# custom CC-BY-ND-2.5 LGPL-2.1+ GPL-2+ public-domain - \
#   third_party/blink/perf_tests/svg/resources/LICENSES
# custom BSD - third_party/opencv/src/LICENSE
# custom BSD APSL-2 MIT BSD-4 - third_party/breakpad/breakpad/LICENSE
# custom IJG - third_party/iccjpeg/LICENSE
# custom MPL-2.0 BSD GPL-3 LGPL-3 Apache-1.1 - \
#   third_party/tflite/src/third_party/eigen3/LICENSE ; Only MPL-2.0 files are \
#   found
# custom UoI-NCSA - third_party/llvm/llvm/include/llvm/Support/LICENSE.TXT
# custom public-domain - third_party/sqlite/LICENSE
# CC-BY-4.0 - third_party/devtools-frontend/src/node_modules/caniuse-lite/LICENSE
# fft2d - third_party/tflite/src/third_party/fft2d/LICENSE
# GPL-2 - third_party/freetype-testing/LICENSE
# GPL-2+ - third_party/devscripts/licensecheck.pl.vanilla
# ISC - third_party/node/node_modules/rimraf/LICENSE
# ISC - third_party/libaom/source/libaom/third_party/x86inc/LICENSE
# ISC CC-BY-SA-4.0 - third_party/node/node_modules/glob/LICENSE ; no logo \
#   image file found
# ISC MIT - third_party/devtools-frontend/src/node_modules/rollup/LICENSE.md
# Khronos-CLHPP - third_party/vulkan-deps/spirv-headers/src/LICENSE
# LGPL-2 - third_party/blink/renderer/core/LICENSE-LGPL-2
#   third_party/blink/renderer/core/layout/table_layout_algorithm.h
# LGPL-2+ - third_party/blink/renderer/core/svg/svg_set_element.h
# LGPL-2.1 - third_party/blink/renderer/core/LICENSE-LGPL-2.1 ; cannot find a \
#   file that is 2.1 only
# LGPL-2.1+ - third_party/blink/renderer/core/paint/paint_layer.h
# LGPL-2.1+ - third_party/libsecret/LICENSE
# LGPL-2.1+ - third_party/ffmpeg/libavcodec/x86/xvididct.asm
# libpng2 - third_party/pdfium/third_party/libpng16/LICENSE
# MIT CC0-1.0 - third_party/node/node_modules/eslint/node_modules/lodash/LICENSE
# MIT SGI-B-2.0 - third_party/khronos/LICENSE
# MIT unicode - third_party/node/node_modules/typescript/ThirdPartyNoticeText.txt
# MPL-2.0 - third_party/node/node_modules/mdn-data/LICENSE
# neon_2_sse - third_party/neon_2_sse/LICENSE
# OFL-1.1 - third_party/freetype-testing/src/fuzzing/corpora/cff-render-ftengine/bungeman/HangingS.otf
# ooura - third_party/webrtc/common_audio/third_party/ooura/LICENSE
# public-domain - third_party/lzma_sdk/LICENSE
# public-domain - third_party/pdfium/third_party/bigint/LICENSE
# public-domain - \
#   third_party/webrtc/common_audio/third_party/spl_sqrt_floor/LICENSE
# public-domain - third_party/webrtc/modules/third_party/g711/LICENSE
# public-domain - third_party/webrtc/modules/third_party/g722/LICENSE
# public-domain - third_party/webrtc/rtc_base/third_party/sigslot/LICENSE
# PSF-2 - third_party/devtools-frontend/src/node_modules/mocha/node_modules/argparse/LICENSE
# QU-fft - third_party/webrtc/modules/third_party/fft/LICENSE
# SunPro - third_party/fdlibm/LICENSE
# svgo (with russian MIT license translation) - \
#   third_party/node/node_modules/svgo/LICENSE
# Unlicense Apache-2.0 - \
#   third_party/devtools-frontend/src/node_modules/@sinonjs/text-encoding/LICENSE.md
# UoI-NCSA - third_party/swiftshader/third_party/llvm-subzero/LICENSE.TXT
# unRAR - third_party/unrar/LICENSE
# widevine - third_party/widevine/LICENSE
# WTFPL BSD-2 - third_party/catapult/third_party/polymer2/bower_components/sinon-chai/LICENSE.txt
# x11proto - third_party/x11proto/LICENSE
# * The public-domain entry was not added to the LICENSE ebuild variable to not
#   give the wrong impression that the entire software was released in public
#   domain.
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="component-build cups cpu_flags_arm_neon +hangouts headless +js-type-check kerberos official pic +proprietary-codecs pulseaudio screencast selinux +suid +system-ffmpeg +system-icu vaapi wayland widevine"
IUSE+=" +partitionalloc tcmalloc libcmalloc"
# For cfi, cfi-icall defaults status, see \
#   https://github.com/chromium/chromium/blob/93.0.4577.15/build/config/sanitizers/sanitizers.gni
# For cfi-full default status, see \
#   https://github.com/chromium/chromium/blob/93.0.4577.15/build/config/sanitizers/sanitizers.gni#L123
# For pgo default status, see \
#   https://github.com/chromium/chromium/blob/93.0.4577.15/build/config/compiler/pgo/pgo.gni#L15
# For libcxx default, see \
#   https://github.com/chromium/chromium/blob/93.0.4577.15/build/config/c++/c++.gni#L14
# For cdm availability see third_party/widevine/cdm/widevine.gni#L28
# Modding location to remove lto-O0 when lld is being used which is the default,
#   see https://github.com/chromium/chromium/blob/93.0.4577.15/build/config/compiler/BUILD.gn#L502
# Currently clang disabled until clang/ThinLTO bug is resolved.  See bug_notes file for details
# +cfi +cfi-icall +clang should be upstream defaults
IUSE+=" -cfi cfi-full -cfi-icall -clang libcxx lto-opt +pgo pgo-audio pgo-gpu
pgo-custom-script -pgo-ebuild-profile-generator -pgo-native
pgo-upstream-profile-generator -pgo-web"
_ABIS=( abi_x86_32
	abi_x86_64
	abi_x86_x32
	abi_mips_n32
	abi_mips_n64
	abi_mips_o32
	abi_ppc_32
	abi_ppc_64
	abi_s390_32
	abi_s390_64 )
IUSE+=" ${_ABIS[@]}"
REQUIRED_USE="
	^^ ( partitionalloc tcmalloc libcmalloc )
	!clang? ( !cfi )
	cfi? ( clang )
	cfi-full? ( cfi )
	cfi-icall? ( cfi )
	component-build? ( !suid )
	libcxx? ( clang )
	lto-opt? ( clang )
	official? ( amd64? ( cfi cfi-icall ) partitionalloc pgo )
	partitionalloc? ( !component-build )
	pgo? ( clang !pgo-native )
	pgo-audio? ( pgo-native )
	pgo-custom-script? ( pgo-ebuild-profile-generator )
	pgo-ebuild-profile-generator? ( !pgo-upstream-profile-generator )
	pgo-gpu? ( pgo-native )
	pgo-native? ( ^^ ( pgo-ebuild-profile-generator
			   pgo-upstream-profile-generator )
			   clang
			   !pgo )
	pgo-upstream-profile-generator? ( pgo-ebuild-profile-generator )
	pgo-web? ( pgo-native )
	screencast? ( wayland )
	widevine? ( !arm64 !ppc64 )
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
	>=media-libs/freetype-2.11.0:=[${MULTILIB_USEDEP}]
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
# TODO change to !pgo-gpu? ( ${VIRTUALX_DEPEND} )
# >=mesa-21.1 is bumped to compatibile llvm-12
# <=mesa-21.0.x is only llvm-11 compatible
BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
	|| (
		>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config]
		>=dev-util/pkgconfig-0.29.2[${MULTILIB_USEDEP}]
	)
	>=app-arch/gzip-1.7
	dev-lang/perl
	>=dev-util/gn-0.1807
	dev-vcs/git
	>=dev-util/gperf-3.0.3
	>=dev-util/ninja-1.7.2
	>=net-libs/nodejs-7.6.0[inspector]
	sys-apps/hwids[usb(+)]
	>=sys-devel/bison-2.4.3
	sys-devel/flex[${MULTILIB_USEDEP}]
	clang? (
		|| (
			(
				sys-devel/clang:13[${MULTILIB_USEDEP}]
				sys-devel/llvm:13[${MULTILIB_USEDEP}]
				=sys-devel/clang-runtime-13*[${MULTILIB_USEDEP}]
				>=sys-devel/lld-13
			)
			(
				sys-devel/clang:12[${MULTILIB_USEDEP}]
				sys-devel/llvm:12[${MULTILIB_USEDEP}]
				=sys-devel/clang-runtime-12*[${MULTILIB_USEDEP}]
				>=sys-devel/lld-12
			)
			(
				sys-devel/clang:11[${MULTILIB_USEDEP}]
				sys-devel/llvm:11[${MULTILIB_USEDEP}]
				=sys-devel/clang-runtime-11*[${MULTILIB_USEDEP}]
				>=sys-devel/lld-11
			)
		)
		arm64? (
			|| (
				(
					sys-devel/clang:13[${MULTILIB_USEDEP}]
					sys-devel/llvm:13[${MULTILIB_USEDEP}]
					=sys-devel/clang-runtime-13*[${MULTILIB_USEDEP}]
					>=sys-devel/lld-13
				)
				(
					sys-devel/clang:12[${MULTILIB_USEDEP}]
					sys-devel/llvm:12[${MULTILIB_USEDEP}]
					=sys-devel/clang-runtime-12*[${MULTILIB_USEDEP}]
					>=sys-devel/lld-12
				)
			)
		)
		official? (
			sys-devel/clang:13[${MULTILIB_USEDEP}]
			sys-devel/llvm:13[${MULTILIB_USEDEP}]
			=sys-devel/clang-runtime-13*[${MULTILIB_USEDEP}]
			>=sys-devel/lld-13
		)
	)
	js-type-check? ( virtual/jre )
	pgo-ebuild-profile-generator? (
		${VIRTUALX_DEPEND}
		app-admin/sudo
		x11-apps/xrandr
		x11-misc/xdotool
	)
"
# llvm 13 >=media-libs/mesa-9999[gbm,${MULTILIB_USEDEP}] ; only <= 12 is on CI
# llvm 12 >=media-libs/mesa-21.1.4[gbm,${MULTILIB_USEDEP}]
# llvm 11 <media-libs/mesa-21.1[gbm,${MULTILIB_USEDEP}]

# Upstream uses llvm:13
# For the current llvm for this project, see
#   https://github.com/chromium/chromium/blob/93.0.4577.15/tools/clang/scripts/update.py#L42
# Use the same clang for official USE flag because of older llvm bugs which
#   could result in security weaknesses (explained in the llvm:12 note below).
# Used llvm >= 12 for arm64 for the same reason in the Linux kernel CFI comment.
#   Links below from https://github.com/torvalds/linux/commit/cf68fffb66d60d96209446bfc4a15291dc5a5d41
#     https://bugs.llvm.org/show_bug.cgi?id=46258
#     https://bugs.llvm.org/show_bug.cgi?id=47479
# To confirm the hash version match for the reported by CR_CLANG_REVISION, see
#   https://github.com/llvm/llvm-project/blob/98033fdc/llvm/CMakeLists.txt
RDEPEND+="
	libcxx? (
		>=sys-libs/libcxx-12[${MULTILIB_USEDEP}]
		official? ( >=sys-libs/libcxx-13[${MULTILIB_USEDEP}] )
	)"
DEPEND+="
	libcxx? (
		>=sys-libs/libcxx-12[${MULTILIB_USEDEP}]
		official? ( >=sys-libs/libcxx-13[${MULTILIB_USEDEP}] )
	)"
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

if ! has chromium_pkg_die ${EBUILD_DEATH_HOOKS} ; then
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

python_check_deps() {
	has_version -b "dev-python/setuptools[${PYTHON_USEDEP}]"
}

pre_build_checks() {
	if [[ ${MERGE_TYPE} != binary ]] ; then
		local -x CPP="$(tc-getCXX) -E"
		if tc-is-gcc && ! ver_test "$(gcc-version)" -ge 9.2 ; then
			die "At least gcc 9.2 is required"
		fi
		if use clang || tc-is-clang ; then
			CPP="${CHOST}-clang++ -E"
			if ! ver_test "$(clang-major-version)" -ge 12 ; then
				die "At least clang 12 is required"
			fi
		fi
	fi

	# Check build requirements, bug #541816 and bug #471810 .
	CHECKREQS_MEMORY="3G"
	CHECKREQS_DISK_BUILD="8G"
	if ( shopt -s extglob; is-flagq '-g?(gdb)?([1-9])' ) ; then
		if use custom-cflags || use component-build ; then
			CHECKREQS_DISK_BUILD="25G"
		fi
		if ! use component-build ; then
			CHECKREQS_MEMORY="16G"
		fi
	fi
	check-reqs_pkg_setup
}

pkg_pretend() {
	pre_build_checks
}

CR_CLANG_USED="98033fdc50e61273b1d5c77ba5f0f75afe3965c1" # Obtained from \
# https://github.com/chromium/chromium/blob/93.0.4577.15/tools/clang/scripts/update.py#L42
CR_CLANG_USED_UNIX_TIMESTAMP="1626129557" # Cached.  Use below to obtain this. \
# TIMESTAMP=$(wget -q -O - https://github.com/llvm/llvm-project/commit/${CR_CLANG_USED}.patch \
#	| grep -e "Date:" | sed -e "s|Date: ||") ; date -u -d "${TIMESTAMP}" +%s
CR_CLANG_SLOT="13"

contains_slotted_major_version() {
	# For sys-devel/llvm:x slot style
	local live_pkgs_=(
		sys-devel/llvm
		sys-devel/clang
	)
	local x="${1}"
	local p
	for p in ${live_pkgs_[@]} ; do
		[[ "${x}" == "${p}" ]] && return 0
	done
	return 1
}

contains_slotted_triple_version() {
	# For sys-devel/llvm:x.y.z slot style
	local live_pkgs_=(
		sys-libs/compiler-rt
		sys-libs/compiler-rt-sanitizers
	)
	local x="${1}"
	local p
	for p in ${live_pkgs_[@]} ; do
		[[ "${x}" == "${p}" ]] && return 0
	done
	return 1
}

contains_slotted_zero() {
	# For sys-devel/llvm:0 slot style
	local live_pkgs_=(
		sys-libs/libomp
		sys-devel/lld
	)
	local x="${1}"
	local p
	for p in ${live_pkgs_[@]} ; do
		[[ "${x}" == "${p}" ]] && return 0
	done
	return 1
}

_print_timestamps() {
	if [[ -n "${emerged_llvm_timestamp}" ]] ; then
		einfo "System's ${p} timestamp:  "$(date -d "@${emerged_llvm_timestamp}")
		if [[ "${p}" == "sys-devel/llvm" ]] ; then
			einfo "${PN^}'s LLVM timestamp:  "$(date -d "@${CR_CLANG_USED_UNIX_TIMESTAMP}")
		else
			einfo "System's sys-devel/llvm timestamp:  "$(date -d "@${LLVM_TIMESTAMP}")
		fi
	fi
}

_get_release_timestamp() {
	local v="${1}"
	if [[ -z "${cached_release_hashes[${v}]}" ]] ; then
		local hash=$(git --no-pager ls-remote \
			https://github.com/llvm/llvm-project.git \
			llvmorg-${v} \
			| cut -f 1 -d $'\t')
		cached_release_hashes[${v}]="${hash}"
	fi
	echo "${cached_release_hashes[${v}]}"
}

_get_live_llvm_timestamp() {
	if [[ -z "${emerged_llvm_commit}" ]] ; then
		# Should check against the llvm milestone if not live
		emerged_llvm_timestamp=$(_get_release_timestamp $(ver_cut 1-3 "${pv}"))
	fi
	if [[ -z "${emerged_llvm_timestamps[${emerged_llvm_commit}]}" ]] ; then
		einfo "Fetching timestamp for ${emerged_llvm_commit}"
		# Uncached
		local emerged_llvm_time_desc=$(wget -q -O - \
			https://github.com/llvm/llvm-project/commit/${emerged_llvm_commit}.patch \
			| grep -e "Date:" | sed -e "s|Date: ||")
		emerged_llvm_timestamp=$(date -u -d "${emerged_llvm_time_desc}" +%s)
		emerged_llvm_timestamps[${emerged_llvm_commit}]=${emerged_llvm_timestamp}
		einfo "Timestamp comparison for ${p}"
		_print_timestamps
	else
		einfo "Using cached timestamp for ${emerged_llvm_commit}"
		# Cached
		emerged_llvm_timestamp=${emerged_llvm_timestamps[${emerged_llvm_commit}]}
		einfo "Timestamp comparison for ${p}"
		_print_timestamps
	fi
}

_check_live_llvm_updated() {
	local root_pkg_timestamp=""

	if [[ "${p}" == "sys-devel/llvm" ]] ; then
		root_pkg_timestamp="${CR_CLANG_USED_UNIX_TIMESTAMP}"
	else
		root_pkg_timestamp="${LLVM_TIMESTAMP}"
	fi

	[[ -z "${emerged_llvm_timestamp}" ]] && die
	[[ -z "${root_pkg_timestamp}" ]] && die

	if (( ${emerged_llvm_timestamp} < ${root_pkg_timestamp} )) ; then
		needs_emerge=1
		live_packages_status[${p_}]="1" # needs emerge
	else
		live_packages_status[${p_}]="0" # package is okay
	fi
}

_check_live_llvm_updated_triple() {
	[[ -z "${emerged_llvm_timestamp}" ]] && die
	[[ -z "${LLVM_TIMESTAMP}" ]] && die

	if (( ${emerged_llvm_timestamp} < ${LLVM_TIMESTAMP} )) ; then
		needs_emerge=1
		live_packages_status[${p_}]="1" # needs emerge
		old_triple_slot_packages+=( "${category}/${pn}:"$(cat "${mp}/SLOT") )
	else
		live_packages_status[${p_}]="0" # package is okay
	fi
}

print_old_live_llvm_multislot_pkgs() {
	local arg="${1}"
	for x in ${old_triple_slot_packages[@]} ; do
		local pvr=${x/:*}
		if [[ "${arg}" == "${pvr}" ]] ; then
			eerror "emerge -1v ${x}"
		fi
	done
}

verify_llvm_report_card() {
	if (( ${needs_emerge} == 1 )) ; then
eerror
eerror "Detected a old clang/llvm version.  Please re-emerge the clang/LLVM"
eerror "toolchain by doing the following:"
eerror
		for p in ${live_pkgs[@]} ; do
			if [[ "${p}" == "sys-libs/libcxx" ]] && ! use libcxx ; then
				continue
			fi
			local p_=${p//-/_}
			p_=${p_//\//_}
			if (( ${live_packages_status[${p_}]} == 1 )) ; then
				if contains_slotted_major_version "${p}" ; then
					eerror "emerge -1v ${p}:${CR_CLANG_SLOT}"
				elif contains_slotted_triple_version "${p}" ; then
					print_old_live_llvm_multislot_pkgs "${p}"
				elif contains_slotted_zero "${p}" ; then
					eerror "emerge -1v ${p}:0"
				fi
			fi
		done
		die
	else
einfo "The live LLVM ${CR_CLANG_SLOT} toolchain is up-to-date."
	fi
}

LLVM_TIMESTAMP=
verify_llvm_toolchain() {
	[[ "${CLANG_SLOT}" != "${CR_CLANG_SLOT}" ]] && return

	# Everything that inherits the llvm.org must be checked.
	# sys-devel/clang-runtime doesn't need check
	# 3 slot types
	# sys-devel/llvm:x
	# sys-devel/clang:x
	# sys-libs/compiler-rt:x.y.z
	# sys-libs/compiler-rt-sanitizers:x.y.z
	# sys-libs/libomp:0
	# sys-devel/lld:0
	# sys-libs/libcxx:0
	local live_pkgs=(
		# Do not change the order!
		sys-devel/llvm
		sys-libs/libomp
		sys-libs/libcxx
		sys-devel/lld
		sys-devel/clang
		sys-libs/compiler-rt
		sys-libs/compiler-rt-sanitizers
	)

	unset emerged_llvm_timestamps
	declare -A emerged_llvm_timestamps

	unset live_packages_status
	declare -A live_packages_status

	unset cached_release_hashes
	declare -A cached_release_hashes

	local old_triple_slot_packages=()

	local needs_emerge=0
	# The llvm library or llvm-ar doesn't embed the hash info, so scan the /var/db/pkg.
	if has_version "sys-devel/llvm:${CR_CLANG_SLOT}" ; then
		for p in ${live_pkgs[@]} ; do
			if [[ "${p}" == "sys-libs/libcxx" ]] && ! use libcxx ; then
				continue
			fi

			# Check each of the live packages that use llvm.org
			# eclass.  Especially for forgetful types.

			local emerged_llvm_commit

			local p_=${p//-/_}
			p_=${p_//\//_}
			if contains_slotted_major_version "${p}" ; then
				einfo
				einfo "Checking ${p}:${CR_CLANG_SLOT}"
				emerged_llvm_commit=$(bzless \
					"${ESYSROOT}/var/db/pkg/${p}-${CR_CLANG_SLOT}"*"/environment.bz2" \
					| grep EGIT_VERSION | head -n 1 | cut -f 2 -d '"')
				pv=$(cat "${ESYSROOT}/var/db/pkg/${p}-${CR_CLANG_SLOT}"*"/PF" | sed "s|${p}-||")
				_get_live_llvm_timestamp
				[[ "${p}" == "sys-devel/llvm" ]] \
					&& LLVM_TIMESTAMP=${emerged_llvm_timestamp}
				_check_live_llvm_updated
			elif contains_slotted_zero "${p}" ; then
				einfo
				einfo "Checking ${p}:0"
				emerged_llvm_commit=$(bzless \
					"${ESYSROOT}/var/db/pkg/${p}"*"/environment.bz2" \
					| grep EGIT_VERSION | head -n 1 | cut -f 2 -d '"')
				pv=$(cat "${ESYSROOT}/var/db/pkg/${p}"*"/PF" | sed "s|${p}-||")
				_get_live_llvm_timestamp
				_check_live_llvm_updated
			else
				local category=${p/\/*}
				local pn=${p/*\/}
				# Handle multiple slots
				# We shouldn't have to deal with multislot patch versions, but
				# we have to.
				for mp in $(find "${ESYSROOT}/var/db/pkg/${category}" \
					-maxdepth 1 \
					-type d \
					-regextype "posix-extended" \
					-regex ".*${pn}-${CR_CLANG_SLOT}.[0-9.]+") ; do
					einfo
					einfo "Checking ="$(basename ${mp})
					emerged_llvm_commit=$(bzless \
						"${mp}/environment.bz2" \
						| grep EGIT_VERSION \
						| head -n 1 \
						| cut -f 2 -d '"')
					pv=$(cat "${mp}/PF" | sed "s|${p}-||")
					_get_live_llvm_timestamp
					_check_live_llvm_updated_triple
				done
			fi
		done
		verify_llvm_report_card
	else
die "${PN} requires llvm:${CR_CLANG_SLOT}"
	fi
}

check_same_llvm() {
	# Warn about loading multiple LLVM versions which may trigger bug.
	if (( $(clang-major-version) > ${MESA_LLVM_MAX_SLOT} )) ; then
ewarn
ewarn "Mesa's LLVM_MAX_SLOT may not be compatible.  The currently selected"
ewarn "clang has a slot that needs to be <= ${MESA_LLVM_MAX_SLOT}."
ewarn
	fi
	if (( ${MESA_LLVM_MAX_SLOT} == ${CLANG_SLOT} )) ; then
ewarn
ewarn "LLVM/clang may need a Mesa ebuild with LLVM_MAX_SLOT == ${CLANG_SLOT}."
ewarn
	fi
	for f in /usr/$(get_libdir)/dri/* ; do
		if ! ( ldd "${f}" | grep -q -e "libLLVM" ) ; then
			continue
		fi
		local driver_llvm=$(ldd "${f}" \
			| grep -e "libLLVM" \
			| sed -r -e "s|[ \t]+| |g" \
			| cut -f 2 -d " " \
			| grep -o -E "[0-9]+")
		if (( ${driver_llvm} != ${CLANG_SLOT} )) ; then
ewarn
ewarn "LLVM/clang may need Mesa DRI drivers built against ${CLANG_SLOT} for"
ewarn "${f}."
ewarn
		fi
	done
}

pkg_setup() {
	ewarn "The $(ver_cut 1 ${PV}) series is the Dev branch."
	pre_build_checks

	chromium_suid_sandbox_check_kernel_config

	# nvidia-drivers does not work correctly with Wayland due to unsupported EGLStreams
	if use wayland && ! use headless && has_version "x11-drivers/nvidia-drivers" ; then
		ewarn "Proprietary nVidia driver does not work with Wayland. You can disable"
		ewarn "Wayland by setting DISABLE_OZONE_PLATFORM=true in /etc/chromium/default."
	fi

	if ! use amd64 && [[ "${IUSE}" =~ cfi ]] ; then
ewarn
ewarn "All variations of the cfi USE flags are not defaults for this platform."
ewarn "Disable them if problematic."
ewarn
	fi

	if use pgo-native ; then
ewarn
ewarn "The pgo-native USE flag is a Work In Progress (WIP)."
ewarn
	fi

	if use pgo-web ; then
		if has network-sandbox $FEATURES ; then
eerror
eerror "${PN} requires network-sandbox to be disabled in per-package FEATURES"
eerror "in order to access remote websites."
eerror
			die
		fi
	fi

	# The pgo account that will run the simulations for pgo profile
	# creation.  The normal portage account will remain without video and
	# audio permissions maintain the restrictive defaults for the sandbox
	# environment.  The pgo account will allow for accelerated testing.
	#
	# It is possible to run X but it's too dangerous for untrusted uris.
	# This is why it is done though the pgo account.
	#
	if use pgo-ebuild-profile-generator ; then
ewarn
ewarn "The pgo-ebuild-profile-generator USE flag is a Work In Progress (WIP)"
ewarn "and untested.  Do not use at this time.  Try the pgo USE flag first"
ewarn "followed by the pgo-upstream-profile-generator USE flag instead."
ewarn
		if ! id pgo 2>/dev/null 1>/dev/null ; then
eerror
eerror "You must have a pgo system account to run simulations to generate a"
eerror "pgo profile.  You can run the following below to setup the pgo"
eerror "account as follows:"
eerror
eerror "  useradd pgo ; \\"
eerror "    gpasswd -a pgo audio ; \\"
eerror "    gpasswd -a pgo input ; \\"
eerror "    gpasswd -a pgo portage ; \\"
eerror "    gpasswd -a pgo tty ; \\"
eerror "    gpasswd -a pgo video ; \\"
eerror "    usermod -U pgo ; \\"
eerror "    usermod -d /var/lib/portage/pgo/home pgo ; \\"
eerror "    mkdir -p /var/lib/portage/pgo/home ; \\"
eerror "    chown -R pgo:portage /var/lib/portage/pgo/home \\"
eerror "    passwd pgo"
eerror
eerror "You may consider adding targetpw to the sudoers file via visudo to"
eerror "enter passwords for the pgo account as well and extending the"
eerror "timestamp_timeout period."
eerror
			die
		fi
		if ! ( groups pgo | grep -q -e "portage" ) ; then
die "You must add pgo to the portage group."
		fi
		local pw_status=$(passwd --status pgo | cut -f 2 -d " ")
		if [[ "${pw_status}" != "P" ]] ; then
die "The pgo account must have a password."
		fi
		if [[ $(realpath ~pgo) != "/var/lib/portage/pgo/home" ]] ; then
die "The pgo account's home directory must be changed to /var/lib/portage/pgo/home."
		fi

		if ! ( xrandr -q | grep -q -e "1920x1080" ) ; then
eerror
eerror "Currently 1080p is only supported for profile generation through the"
eerror "pgo-ebuild-profile-generator USE flag."
eerror
			die
		fi
	fi
	# Plans may require special pgo system account.
	if use pgo-gpu ; then
# We do not want the xvfb but rather the acclerated X instead.
ewarn
ewarn "The pgo-gpu USE flag is a Work In Progress (WIP)."
ewarn "Do not use at this time."
ewarn
ewarn "Remove USER=${USER} from the video group.  Group permssions should only"
ewarn "apply to the pgo account."
ewarn
		if ! ( groups pgo | grep -q -e "video" ) ; then
			die "You must add pgo to the video group."
		fi

		# From sci-geosciences/grass ebuild
		shopt -s nullglob
		local mesa_cards=$(echo -n /dev/dri/card* /dev/dri/render* | sed 's/ /:/g')
		if test -n "${mesa_cards}" ; then
			addpredict "${mesa_cards}"
		fi
		local ati_cards=$(echo -n /dev/ati/card* | sed 's/ /:/g')
		if test -n "${ati_cards}" ; then
			addpredict "${ati_cards}"
		fi
		shopt -u nullglob
		addpredict /dev/nvidiactl
	fi

	if use pgo-audio ; then
ewarn
ewarn "The pgo-gpu USE flag is a Work In Progress (WIP)."
ewarn "Do not use at this time."
ewarn
ewarn "Remove USER=${USER} from the audio group.  Group permissions should only"
ewarn "apply to the pgo account."
ewarn
		if ! ( groups pgo | grep -q -e "audio" ) ; then
			die "You must add pgo to the audio group."
		fi
	fi

	if use pgo-upstream-profile-generator ; then
ewarn
ewarn "The pgo-upstream-profile-generator USE flag is a Work In Progress (WIP)."
ewarn
	fi

	if use pgo-custom-script ; then
		local f="/etc/portage/pgo-scripts/www-client/chromium/${PV}.sh"
		if [[ ! -f "${f}" ]] ; then
			eerror "Missing ${f}"
			die
		fi
		local group_owner=$(stat -c "%G" "${f}")
		if [[ "${group_owner}" != "portage" ]] ; then
eerror "Inspect ${f} contents for tampering in and change group ownership to"
eerror "portage."
			die
		fi
		local perms=$(stat -c "%a" "${f}" | cut -c 3)
		if [[ "${perms}" != "0" ]] ; then
eerror "Inspect ${f} contents for tampering in and change file permissions to"
eerror "640."
			die
		fi
	fi

	if use official || ( use clang && use cfi && use pgo ) ; then
		# sys-devel/lld-13 was ~20 mins for v8_context_snapshot_generator
		# sys-devel/lld-12 was ~4 hrs for v8_context_snapshot_generator
ewarn
ewarn "Linking times may take longer than usual.  Maybe 1-4+ hour(s)."
ewarn
	fi

	# These checks are a maybe required.
	if use clang ; then
		llvm_pkg_setup
		CC=${CHOST}-clang
		CXX=${CHOST}-clang++
		local MESA_LLVM_MAX_SLOT=$(bzless \
			"${ESYSROOT}/var/db/pkg/media-libs/mesa"*"/environment.bz2" \
			| grep LLVM_MAX_SLOT \
			| head -n 1 \
			| cut -f 2 -d '"')
		local CLANG_SLOT=$(clang-major-version)
		einfo "CLANG_SLOT: ${CLANG_SLOT}"
		einfo "MESA_LLVM_MAX_SLOT: ${MESA_LLVM_MAX_SLOT}"
		check_same_llvm
		verify_llvm_toolchain
	fi
	if [[ -n "${CHROMIUM_EBUILD_MAINTAINER}" ]] ; then
		if [[ -z "${MY_OVERLAY_DIR}" ]] ; then
eerror
eerror "You need to set MY_OVERLAY_DIR as a per-package envvar to the base path"
eerror "of your overlay or local repo.  The base path should contain all the"
eerror "overlay's categories."
eerror
			die
		fi
	fi
	use pgo-ebuild-profile-generator && die "USE flag not ready"
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

	# already applied upstream.
	rm -rf "${WORKDIR}/patches/chromium-93-dawn-raw-string-literal.patch" || die
	rm -rf "${WORKDIR}/patches/chromium-swiftshader-export.patch" || die

	PATCHES+=(
		"${WORKDIR}/sandbox-patches/chromium-syscall_broker.patch"
		"${WORKDIR}/sandbox-patches/chromium-fstatat-crash.patch"
		"${FILESDIR}/chromium-93-EnumTable-crash.patch"
		"${FILESDIR}/chromium-93-InkDropHost-crash.patch"
		"${FILESDIR}/chromium-shim_headers.patch"
	)

	if ! use arm64 ; then
		einfo "Removing aarch64 only patches"
		rm "${WORKDIR}/patches/chromium-91-libyuv-aarch64.patch" || die
	fi

	if use clang ; then
		ceapply "${FILESDIR}/${PN}-92-clang-toolchain-1.patch"
		ceapply "${FILESDIR}/${PN}-92-clang-toolchain-2.patch"
	fi

	default

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

	mkdir -p third_party/node/linux/node-linux-x64/bin || die
	ln -s "${EPREFIX}"/usr/bin/node third_party/node/linux/node-linux-x64/bin/node || die

	# adjust python interpreter version
	sed -i -e "s|\(^script_executable = \).*|\1\"${EPYTHON}\"|g" .gn || die
	sed -i -e "s|/usr/bin/env vpython|/usr/bin/env ${EPYTHON}|g" \
		tools/perf/run_benchmark || die

	# bundled highway library does not support arm64 with GCC
	if use arm64 ; then
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
		third_party/catapult/third_party/beautifulsoup4-4.9.3
		third_party/catapult/third_party/html5lib-1.1
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
		third_party/six
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
	if ! use system-ffmpeg ; then
		keeplibs+=( third_party/ffmpeg third_party/opus )
	fi
	if ! use system-icu ; then
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
		if use system-icu ; then
			keeplibs+=( third_party/icu )
		fi
	fi
	if use arm64 || use ppc64 ; then
		keeplibs+=( third_party/swiftshader/third_party/llvm-10.0 )
	fi
	# we need to generate ppc64 stuff because upstream does not ship it yet
	# it has to be done before unbundling.
	if use ppc64 ; then
		pushd third_party/libvpx >/dev/null || die
		mkdir -p source/config/linux/ppc64 || die
		./generate_gni.sh || die
		popd >/dev/null || die
	fi

	# Remove most bundled libraries. Some are still needed.
	build/linux/unbundle/remove_bundled_libraries.py "${keeplibs[@]}" --do-remove || die

	if use js-type-check ; then
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

	if tc-is-clang ; then
		myconf_gn+=" is_clang=true clang_use_chrome_plugins=false"
	else
		if use libcxx ; then
			die "Compiling with sys-libs/libcxx requires clang."
		fi
		myconf_gn+=" is_clang=false"
	fi

	# Define a custom toolchain for GN
	myconf_gn+=" custom_toolchain=\"//build/toolchain/linux/unbundle:default\""

	if tc-is-cross-compiler ; then
		tc-export BUILD_{AR,CC,CXX,NM}
		myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:host\""
		myconf_gn+=" v8_snapshot_toolchain=\"//build/toolchain/linux/unbundle:host\""
	else
		myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:default\""
	fi

# Debug symbols level 2 is still on when official is on even though is_debug=false:
# See https://github.com/chromium/chromium/blob/93.0.4577.15/build/config/compiler/compiler.gni#L276
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
	if use system-ffmpeg ; then
		gn_system_libraries+=( ffmpeg opus )
	fi
	if use system-icu ; then
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

	# Disable code formating of generated files
	myconf_gn+=" blink_enable_generated_code_formatting=false"

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
	if ! use custom-cflags ; then
		replace-flags "-Os" "-O2"
		strip-flags

		# Debug info section overflows without component build
		# Prevent linker from running out of address space, bug #471810 .
		if ! use component-build || use x86 ; then
			filter-flags "-g*"
		fi

		# Prevent libvpx build failures. Bug 530248, 544702, 546984.
		if [[ ${myarch} == amd64 || ${myarch} == x86 ]] ; then
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

	myconf_gn+=" target_cpu=\"${target_cpu}\""
	myconf_gn+=" v8_current_cpu=\"${target_cpu}\""
	myconf_gn+=" current_cpu=\"${target_cpu}\""
	myconf_gn+=" host_cpu=\"${target_cpu}\""
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

	#if ! use system-ffmpeg ; then
	if false ; then
		local build_ffmpeg_args=""
		if use pic && [[ "${ffmpeg_target_arch}" == "ia32" ]] ; then
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
	if use arm64 && tc-is-gcc ; then
		append-cxxflags -flax-vector-conversions
	fi

	# Disable unknown warning message from clang.
	tc-is-clang && append-flags -Wno-unknown-warning-option

	# Explicitly disable ICU data file support for system-icu builds.
	if use system-icu ; then
		myconf_gn+=" icu_use_data_file=false"
	fi

	# Enable ozone wayland and/or headless support
	myconf_gn+=" use_ozone=true ozone_auto_platforms=false"
	myconf_gn+=" ozone_platform_headless=true"
	if use wayland || use headless ; then
		if use headless ; then
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
		use lto-opt && myconf_gn+=" thin_lto_enable_optimizations=true"
	else
		# gcc doesn't like -fsplit-lto-unit and -fwhole-program-vtables
		myconf_gn+=" use_thin_lto=false "
	fi
	if use official ; then
		# Allow building against system libraries in official builds
		sed -i 's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' \
			tools/generate_shim_headers/generate_shim_headers.py || die
	fi

# See https://github.com/chromium/chromium/blob/93.0.4577.15/build/config/sanitizers/BUILD.gn#L196
	if use cfi ; then
		myconf_gn+=" is_cfi=true"
	else
		myconf_gn+=" is_cfi=false"
	fi

# See https://github.com/chromium/chromium/blob/93.0.4577.15/tools/mb/mb_config.pyl#L2950
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
# See also https://github.com/chromium/chromium/blob/93.0.4577.15/docs/pgo.md
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
	if [[ -f out/Release/build.ninja ]] ; then
		pushd out/Release || popd
			einfo "Cleaning out build"
			eninja -t clean
		popd
	fi
	# Build mksnapshot and pax-mark it.
	local x
	for x in mksnapshot v8_context_snapshot_generator; do
		einfo "Building ${x}"
		if tc-is-cross-compiler ; then
			eninja -C out/Release "host/${x}"
			pax-mark m "out/Release/host/${x}"
		else
			eninja -C out/Release "${x}"
			pax-mark m "out/Release/${x}"
		fi
	done
}

get_vertxl_display() {
	export VIRTXL_DISPLAY=$(ps -aux \
		| grep -F -e "/usr/bin/X" \
		| grep -F -e "pgo" \
		| grep -o -e ":[0-9] " \
		| sed -e "s|[ ]||g")
}

virtxl_init() {
einfo
einfo "Please choose a vt from ctrl+alt+f1 ... ctrl+alt+f12 and login into the"
einfo "pgo account starting X"
einfo
einfo "Press enter to continue"
einfo
	read dummy
	while [[ -z "${VIRTXL_DISPLAY}" ]] ; do
		einfo "Didn't find the Xserver loaded for the pgo account"
		einfo "Press enter to retry"
		read dummy
		get_vertxl_display
	done
	einfo "Found DISPLAY=${VIRTXL_DISPLAY}"
	DISPLAY=${VIRTXL_DISPLAY}

	einfo "Allowing portage account access to pgo account X session which"
	einfo "a sudo prompt may be presented."
	sudo -u pgo -g portage xhost +local:

	einfo "Will push automated macros into DISPLAY=${DISPLAY}"
	einfo "Multiple logins may be required if sudo times out."
}

virtxl() {
	einfo "Running the PGO runner script.  A sudo prompt may be shown."
	sudo -b -u pgo -g portage "${@}"
}

# The most intensive computational parts should be pushed in hot section that
# need boosting that way if you encounter in them again they penalize less.
_javascript_benchmark() {
	[[ ! -f out/Release/chrome ]] && die "Missing out/Release/chrome"

	local have_gpu="false"
	if use pgo-gpu ; then
		have_gpu="true"
	fi

	local benchmark1_duration=$(( 60 + ${EPGO_TEST_SLACK_TIME} ))
	local benchmark1_total_time=$(( 20 + ${EPGO_WAIT_SLACK_TIME} + ${benchmark1_duration} ))
	local benchmark2_duration=$(( 12*60 + ${EPGO_TEST_SLACK_TIME} ))
	local benchmark2_total_time=$(( 90 + ${EPGO_WAIT_SLACK_TIME} + ${benchmark2_duration} ))
	local benchmark3_duration=$(( 2*60 + ${EPGO_TEST_SLACK_TIME} ))
	local benchmark3_total_time=$(( 60 + ${EPGO_WAIT_SLACK_TIME} + ${benchmark3_duration} ))
	local benchmark4_duration=$(( 60 + ${EPGO_TEST_SLACK_TIME} ))
	local benchmark4_total_time=$(( 90 + ${EPGO_WAIT_SLACK_TIME} + ${benchmark4_duration} ))
	local test_duration=$((
		0
		+ 2 + ${EPGO_WAIT_SLACK_TIME}
		+ ${EPGO_BROWSER_CACHED_LAUNCH_TIME}
		+ ${benchmark1_total_time}
		+ ${benchmark2_total_time}
		+ ${benchmark3_total_time}
		+ ${benchmark4_total_time}
	))
einfo
einfo "Running simulation:  metering javascript engine performance... timeboxed"
einfo "to $((${test_duration} / 60)) minutes and $((${test_duration} % 60)) seconds"
einfo
	cat <<EOF > "${BUILD_DIR}/run.sh"
#!/bin/bash
main() {
	cat /dev/null > "${T}/test-retcode.log"
	cd "${BUILD_DIR}"
	sleep ${EPGO_DESKTOP_CACHED_LAUNCH_TIME}
	( timeout ${test_duration} \
		out/Release/chrome ; \
		echo "$?" > "${T}/test-retcode.log" ) &
	sleep $((2 + ${EPGO_WAIT_SLACK_TIME})) # let the window load
	local id=\$(xdotool getwindowfocus)
	xdotool windowmove --sync ${id} 0 0
	xdotool windowsize --sync ${id} 1918 1078
	sleep ${EPGO_BROWSER_CACHED_LAUNCH_TIME}

	# benchmark #1
	# Runs in about 50 seconds
	xdotool key --window ${id} ctrl+l
	xdotool type --window ${id} "https://chromium.github.io/octane/"
	xdotool key Return
	sleep $((20 + ${EPGO_WAIT_SLACK_TIME})) # let the page load.  It takes about 10s.

	xdotool mousemove --sync 912 234
	xdotool click # start

	sleep ${benchmark1_duration}

	# benchmark #2 for WebAssembly also
	# Runs in about 12 minutes
	xdotool key --window ${id} ctrl+l
	xdotool type --window ${id} "https://browserbench.org/JetStream/"
	xdotool key Return
	sleep $((90 + ${EPGO_WAIT_SLACK_TIME})) # let the page load.  it takes some time about 1min and 8s.

	xdotool mousemove --sync 957 339
	xdotool click # start

	sleep ${benchmark2_duration}

	# benchmark #3 for HTML5 Canvas benchmark
	# Runs in about 2 minutes
	if ${have_gpu} ; then
		xdotool key --window ${id} ctrl+l
		xdotool type --window ${id} "https://www.kevs3d.co.uk/dev/canvasmark/"
		xdotool key Return
		sleep $((60 + ${EPGO_WAIT_SLACK_TIME})) # 32s + slack.

		xdotool mousemove --sync 697 462
		xdotool click # start

		sleep ${benchmark3_duration}
	fi

	# benchmark #4 webgl
	if ${have_gpu} ; then
		xdotool key --window ${id} ctrl+l
		xdotool type --window ${id} "https://webglsamples.org/aquarium/aquarium.html"
		xdotool key Return
		sleep $((90 + ${EPGO_WAIT_SLACK_TIME})) # 1 min for LCP (all textures loaded in the scene) + slack
		sleep ${benchmark4_duration}
	fi

	echo -n "\$?" > "${T}/test-retcode.log"
	exit \$(cat "${T}/test-retcode.log")
}
main
EOF
	chmod +x "${BUILD_DIR}/run.sh" || die
	chown pgo:portage "${BUILD_DIR}/run.sh" || die
	if use pgo-gpu ; then
		virtxl "${BUILD_DIR}/run.sh"
	else
		virtx "${BUILD_DIR}/run.sh"
	fi

	sleep ${test_duration}

	if [[ -f "${T}/test-retcode.log" ]] ; then
		die "Missing retcode for ${x}"
	fi
	local test_retcode=$(cat "${T}/test-retcode.log")
	if [[ "${test_retcode}" != "0" ]] ; then
eerror "Test failed for ${x}.  Return code: ${test_retcode}."
		die
	fi
	sleep ${EPGO_DESKTOP_CLOSE_TIME}
}

_load_simulation() {
	[[ ! -f out/Release/chrome ]] && die "Missing out/Release/chrome"
	local load_duration=$((${EPGO_BROWSER_COLD_LAUNCH_TIME} + ${EPGO_WAIT_SLACK_TIME}))
	local test_duration=$((
		0
		+ 2 + ${EPGO_WAIT_SLACK_TIME}
		+ ${load_duration}
	))
einfo
einfo "Running simulation:  metering load-time performance... timeboxed to"
einfo "${test_duration} seconds"
einfo
	cat <<EOF > "${BUILD_DIR}/run.sh"
#!/bin/bash
# Handles a window with 2 checkboxes and an OK
_handle_new_install_window() {
	local id=\$(xdotool getwindowfocus)
	sleep $((2 + ${EPGO_WAIT_SLACK_TIME})) # let the window load
	xdotool windowmove --sync ${id} 0 0
	xdotool windowsize --sync ${id} 1918 1078

	# no making default browser
	xdotool mousemove --sync 25 20
	xdotool click

	# no sending statistics to G
	xdotool mousemove --sync 23 57
	xdotool click

	# OK - close window
	xdotool mousemove --sync 1878 1053
	xdotool click
}

main() {
	cat /dev/null > "${T}/test-retcode.log"
	cd "${BUILD_DIR}"
	sleep ${EPGO_DESKTOP_COLD_LAUNCH_TIME}
	( timeout ${load_duration} \
		out/Release/chrome ; \
		echo "$?" > "${T}/test-retcode.log" ) &
	_handle_new_install_window
	sleep ${load_duration}
	echo -n "\$?" > "${T}/test-retcode.log"
	exit \$(cat "${T}/test-retcode.log")
}
main
EOF
	chmod +x "${BUILD_DIR}/run.sh" || die
	chown pgo:portage "${BUILD_DIR}/run.sh" || die
	if use pgo-gpu ; then
		virtxl "${BUILD_DIR}/run.sh"
	else
		virtx "${BUILD_DIR}/run.sh"
	fi

	sleep ${test_duration}

	if [[ -f "${T}/test-retcode.log" ]] ; then
		die "Missing retcode for ${x}"
	fi
	local test_retcode=$(cat "${T}/test-retcode.log")
	if [[ "${test_retcode}" != "0" ]] ; then
eerror "Test failed for ${x}.  Return code: ${test_retcode}."
		die
	fi
	sleep ${EPGO_DESKTOP_CLOSE_TIME}
}

_tabs_simulation() {
	[[ ! -f out/Release/chrome ]] && die "Missing out/Release/chrome"

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
		)
	else
		uris_=( ${ECHROMIUM_PGO_URIS} )
	fi

	local tab_switch_delay_time="0.3"
	local fcp_time=$((20 + ${EPGO_WAIT_SLACK_TIME}))
	local tabs_load_duration=$(( ${fcp_time} * ${#uris_[@]} ))
	local tabs_switch_duration=180 # 3 min
	local tabs_switch_N=$(( echo "${tabs_switch_duration}/${tab_switch_delay_time}" | bc | cut -f 1 -d "." ))
	local tabs_close_duration=$(( echo "${#uris_[@]} * ${tab_switch_delay_time}" | bc | cut -f 1 -d "." ))
	local test_duration=$((
		0
		+ 2 + ${EPGO_WAIT_SLACK_TIME}
		+ ${EPGO_BROWSER_CACHED_LAUNCH_TIME}
		+ ${tabs_load_duration}
		+ ${tabs_switch_duration}
		+ ${tabs_close_duration}
	))
einfo
einfo "Running simulation:  metering load-time performance... timeboxed to"
einfo "$((${experiment_duration} / 60)) minutes and $((${experiment_duration} % 60))"
einfo
	cat <<EOF > "${BUILD_DIR}/run.sh"
#!/bin/bash
main() {
	cat /dev/null > "${T}/test-retcode.log"
	cd "${BUILD_DIR}"
	sleep ${EPGO_DESKTOP_CACHED_LAUNCH_TIME}
	( timeout ${test_duration} \
		out/Release/chrome ; \
		echo "$?" > "${T}/test-retcode.log" ) &
	sleep $((2 + ${EPGO_WAIT_SLACK_TIME})) # let the window load
	local id=\$(xdotool getwindowfocus)
	xdotool windowmove --sync ${id} 0 0
	xdotool windowsize --sync ${id} 1918 1078
	sleep ${EPGO_BROWSER_CACHED_LAUNCH_TIME}

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
		sleep ${fcp_time}
		if (( ${tab_count} > ${tab_limit} )) ; then
			xdotool key --window ${id} ctrl+1
			xdotool key --window ${id} ctrl+w
			xdotool key --window ${id} ctrl+9
			n_closed=$((${n_closed}+1))
		fi
	done

	# Simulate tab switching in 3 minutes
	for x in $(seq 1 ${tabs_switch_N}) ; do
		xdotool key --window ${id} ctrl+$(($((${RANDOM}  % 9)) + 1))
		sleep ${tab_switch_delay_time}
	done

	for u in $(seq 1 $((${#uris[@]}-${n_closed}))) ; do
		xdotool key --window ${id} ctrl+w
		sleep ${tab_switch_delay_time}
	done

	echo -n "\$?" > "${T}/test-retcode.log"
	exit \$(cat "${T}/test-retcode.log")
}
main
EOF
	chmod +x "${BUILD_DIR}/run.sh" || die
	chown pgo:portage "${BUILD_DIR}/run.sh" || die
	if use pgo-gpu ; then
		virtxl "${BUILD_DIR}/run.sh"
	else
		virtx "${BUILD_DIR}/run.sh"
	fi

	sleep ${test_duration}

	if [[ -f "${T}/test-retcode.log" ]] ; then
		die "Missing retcode for ${x}"
	fi
	local test_retcode=$(cat "${T}/test-retcode.log")
	if [[ "${test_retcode}" != "0" ]] ; then
eerror "Test failed for ${x}.  Return code: ${test_retcode}."
		die
	fi
	sleep ${EPGO_DESKTOP_CLOSE_TIME}
}

_responsiveness_simulation() {
	# Benchmark runs actually in around a minute.
	[[ ! -f out/Release/chrome ]] && die "Missing out/Release/chrome"
	local benchmark_duration=60
	local test_duration=$((
		0
		+ ${EPGO_BROWSER_CACHED_LAUNCH_TIME}
		+ ${EPGO_FCP}
		+ ${benchmark_duration}
	))
einfo
einfo "Running simulation:  metering load-time performance... timeboxed to"
einfo "${test_duration} seconds"
einfo
	cat <<EOF > "${BUILD_DIR}/run.sh"
#!/bin/bash
main() {
	cat /dev/null > "${T}/test-retcode.log"
	cd "${BUILD_DIR}"
	sleep ${EPGO_DESKTOP_CACHED_LAUNCH_TIME}
	( timeout ${test_duration} \
		out/Release/chrome \
			"https://browserbench.org/Speedometer2.0/" ; \
		echo "$?" > "${T}/test-retcode.log" ) &
	local id=\$(xdotool getwindowfocus)
	sleep ${EPGO_FCP} # 2s load + slack
	xdotool windowmove --sync ${id} 0 0
	xdotool windowsize --sync ${id} 1918 1078
	sleep ${EPGO_BROWSER_CACHED_LAUNCH_TIME}

	xdotool mousemove --sync 962 620
	xdotool click
	sleep ${benchmark_duration}
	echo -n "\$?" > "${T}/test-retcode.log"
	exit \$(cat "${T}/test-retcode.log")
}
main
EOF
	chmod +x "${BUILD_DIR}/run.sh" || die
	chown pgo:portage "${BUILD_DIR}/run.sh" || die
	if use pgo-gpu ; then
		virtxl "${BUILD_DIR}/run.sh"
	else
		virtx "${BUILD_DIR}/run.sh"
	fi

	sleep ${test_duration}

	if [[ -f "${T}/test-retcode.log" ]] ; then
		die "Missing retcode for ${x}"
	fi
	local test_retcode=$(cat "${T}/test-retcode.log")
	if [[ "${test_retcode}" != "0" ]] ; then
eerror "Test failed for ${x}.  Return code: ${test_retcode}."
		die
	fi
	sleep ${EPGO_DESKTOP_CLOSE_TIME}
}

_custom_simulation() {
	# It runs actually in around a minute.
	[[ ! -f out/Release/chrome ]] && die "Missing out/Release/chrome"
	local test_duration=$((
		0
		+ 2 + ${EPGO_WAIT_SLACK_TIME}
		+ ${EPGO_BROWSER_CACHED_LAUNCH_TIME}
		+ ${EPGO_CUSTOM_SIMULATION_TIMEBOX_TIME}
	))
einfo
einfo "Running simulation:  metering custom script performance... timeboxed to"
einfo "${test_duration} seconds"
einfo
	sleep ${EPGO_DESKTOP_CACHED_LAUNCH_TIME}
	( timeout ${EPGO_CUSTOM_SIMULATION_TIMEBOX_TIME} \
		out/Release/chrome \
			"https://localhost" ; \
		echo "$?" > "${T}/test-retcode.log" ) &
	sleep $((2 + ${EPGO_WAIT_SLACK_TIME})) # let the window load
	local id=$(xdotool getwindowfocus)
	xdotool windowmove --sync ${id} 0 0
	xdotool windowsize --sync ${id} 1918 1078
	sleep ${EPGO_BROWSER_CACHED_LAUNCH_TIME}
	cat "/etc/portage/pgo-scripts/www-client/chromium/${PV}.sh" \
		> "${T}/run.sh"
	chmod +x "${BUILD_DIR}/run.sh" || die
	chown pgo:portage "${BUILD_DIR}/run.sh" || die
	if use pgo-gpu ; then
		virtxl "${BUILD_DIR}/run.sh"
	else
		virtx "${BUILD_DIR}/run.sh"
	fi

	sleep ${test_duration}

	if [[ -f "${T}/test-retcode.log" ]] ; then
		die "Missing retcode for ${x}"
	fi
	local test_retcode=$(cat "${T}/test-retcode.log")
	if [[ "${test_retcode}" != "0" ]] ; then
eerror "Test failed for ${x}.  Return code: ${test_retcode}."
		die
	fi
	sleep ${EPGO_DESKTOP_CLOSE_TIME}
}

_run_simulation_suite() {
	if use pgo-upstream-profile-generator ; then
# See also https://github.com/chromium/chromium/blob/93.0.4577.15/docs/pgo.md
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
		use pgo-gpu && virtxl_init
		einfo "Running training exercise simulations"
		_load_simulation
		use pgo-web && _tabs_simulation
		use pgo-web && _javascript_benchmark
		use pgo-web && _responsiveness_simulation
		use pgo-custom-script && _custom_simulation
	fi
}

_run_simulations() {
	_run_simulation_suite
	if ! ls *.profraw 2>/dev/null 1>/dev/null ; then
		die "Missing *.profraw files"
	fi
	if use pgo-ebuild-profile-generator ; then
		einfo "Merging PGO profile data.  A sudo prompt may shown."
		sudo -u pgo -g portage \
		llvm-profdata merge *.profraw \
			-o "${BUILD_DIR}/chrome/build/pgo_profiles/custom.profdata" \
			|| die
	else
		llvm-profdata merge *.profraw \
			-o "${BUILD_DIR}/chrome/build/pgo_profiles/custom.profdata" \
			|| die
	fi
}

update_licenses() {
	# Upstream doesn't package PATENTS files
	if [[ -n "${CHROMIUM_EBUILD_MAINTAINER}" ]] ; then
		einfo "Generating license and copyright notice file"
		eninja -C out/Release about_credits
		# It should be updated when the major.minor.build.x changes
		# because of new features.
		local license_file_name=$(echo "${PN}-${PV}" \
			| sed -r -e "s|(${PN}-[0-9]+\.[0-9]+\.[0-9]+\.)[0-9]+|\1x|g")
		local x_license_fingerprint=$(sha512sum \
			"${BUILD_DIR}/out/Release/gen/components/resources/about_credits.html" \
                                        | cut -f 1 -d " ")
		# Check the license fingerprint between point releases.
		if [[ ! ( "${LICENSE}" =~ "${license_file_name}" ) \
			|| ! -f "${MY_OVERLAY_DIR}/licenses/${license_file_name}" \
			|| "${x_license_fingerprint}" != "${LICENSE_FINGERPRINT}"
		]] ; then
einfo
einfo "Please update the LICENSE variable and add the license file to the"
einfo "licenses folder.  Copy license file as follows:"
einfo
einfo "  \`cp -a ${BUILD_DIR}/out/Release/gen/components/resources/about_credits.html \
${MY_OVERLAY_DIR}/licenses/${license_file_name}\`"
einfo
einfo "Update the LICENSE_FINGERPRINT to ${x_license_fingerprint}"
einfo
			die
		fi
	else
		einfo "Generating license and copyright notice file"
		eninja -C out/Release about_credits
		# It should be updated when the major.minor.build.x changes
		# because of new features.
		local license_file_name=$(echo "${PN}-${PV}" \
			| sed -r -e "s|(${PN}-[0-9]+\.[0-9]+\.[0-9]+\.)[0-9]+|\1x|g")
		local x_license_fingerprint=$(sha512sum \
			"${BUILD_DIR}/out/Release/gen/components/resources/about_credits.html" \
			| cut -f 1 -d " ")
		# Check the license fingerprint between point releases.
		# The 93 fingerprints differ from the 92
		einfo "Verifying about:credits fingerprints"
		if [[ "${x_license_fingerprint}" != "${LICENSE_FINGERPRINT}" ]] ; then
einfo
einfo "The about:credits fingerprints do not match.  Send an issue report to the"
einfo "ebuild maintainer."
einfo
			die
		fi
	fi
}

multilib_src_compile() {
	# Final link uses lots of file descriptors.
	ulimit -n 2048

	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	#"${EPYTHON}" tools/clang/scripts/update.py --force-local-build --gcc-toolchain /usr --skip-checkout --use-system-cmake --without-android || die

	if use pgo-native ; then
		if ls *.profraw 2>/dev/null 1>/dev/null ; then
			rm -rf *.profraw || die
		fi
		PGO_PHASE=1
		_configure_pgx # pgi
		update_licenses
		_build_pgx
		_run_simulations
		PGO_PHASE=2
		_configure_pgx # pgo
		_build_pgx
	else
		_configure_pgx # pgo / no-pgo
		update_licenses
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

_install_header_license() {
	local dir_path=$(dirname "${1}")
	local file_name=$(basename "${1}")
	local license_name="${2}"
	local length="${3}"
	d="${dir_path}"
	dl="licenses/${d}"
	docinto "${dl}"
	mkdir -p "${T}/${dl}" || die
	head -n ${length} "${S}/${d}/${file_name}" > \
		"${T}/${dl}/${license_name}" || die
	dodoc "${T}/${dl}/${license_name}"
}

_install_header_license_mid() {
	local dir_path=$(dirname "${1}")
	local file_name=$(basename "${1}")
	local license_name="${2}"
	local start="${3}"
	local length="${4}"
	d="${dir_path}"
	dl="licenses/${d}"
	docinto "${dl}"
	mkdir -p "${T}/${dl}" || die
	tail -n +${start} "${S}/${d}/${file_name}" \
		| head -n ${length} > \
		"${T}/${dl}/${license_name}" || die
	dodoc "${T}/${dl}/${license_name}"
}

# @FUNCTION: _install_licenses
# @DESCRIPTION:
# Installs licenses and copyright notices from packages and other internal
# packages.
_install_licenses() {
	[[ -f "${T}/.copied_licenses" ]] && return

	einfo "Copying third party licenses and copyright notices"
	export IFS=$'\n'
	for f in $(find "${S}" \
	  -iname "*licens*" -type f \
	  -o -iname "*licenc*" \
	  -o -iname "*copyright*" \
	  -o -iname "*copying*" \
	  -o -iname "*patent*" \
	  -o -iname "ofl.txt" \
	  -o -iname "*notice*" \
	  -o -iname "*author*" \
	  -o -iname "*CONTRIBUTORS*" \
	  ) $(grep -i -G -l \
		-e "copyright" \
		-e "licens" \
		-e "licenc" \
		-e "warrant" \
		$(find "${S}" -iname "*readme*")) ; \
	do
		if [[ -f "${f}" ]] ; then
			d=$(dirname "${f}" | sed -e "s|^${S}||")
		else
			d=$(echo "${f}" | sed -e "s|^${S}||")
		fi
		docinto "licenses/${d}"
		dodoc -r "${f}"
	done
	export IFS=$' \t\n'

	# Place _install_header_license or _install_header_license_mid
	# calls here.

	touch "${T}/.copied_licenses"
}

multilib_src_install() {
	local CHROMIUM_HOME="/usr/$(get_libdir)/chromium-browser"
	exeinto "${CHROMIUM_HOME}"
	doexe out/Release/chrome

	if use suid ; then
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

	if ! use system-icu ; then
		doins out/Release/icudtl.dat
	fi

	doins -r out/Release/locales
	doins -r out/Release/resources

	if [[ -d out/Release/swiftshader ]] ; then
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

	# This next pass will copy PATENTS files, *ThirdParty*, and NOTICE files
	# and npm micropackages copyright notices and licenses which may not
	# have been present in the listed the the .html (about:credits) file
	_install_licenses
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	readme.gentoo_print_elog

	if use vaapi ; then
		elog "VA-API is disabled by default at runtime. You have to enable it"
		elog "by adding --enable-features=VaapiVideoDecoder to CHROMIUM_FLAGS"
		elog "in /etc/chromium/default."
	fi
	if use screencast ; then
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
