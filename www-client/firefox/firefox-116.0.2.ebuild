# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Originally based on the firefox-89.0.ebuild from the gentoo-overlay,
# with update sync updated to this version of the ebuild.
# Revisions may change in the oiledmachine-overlay.

# Track http://ftp.mozilla.org/pub/firefox/releases/ for version updates.
# For security advisories, see https://www.mozilla.org/en-US/security/advisories/

# The latest can be found with:
__='
curl -l http://ftp.mozilla.org/pub/firefox/releases/ \
	| cut -f 3 -d ">" \
	| cut -f 1 -d "<" \
	| grep -v "esr" \
	| grep -v "b" \
	| sed -e "s|/||g" \
	| grep "^[0-9]" \
	| sort -V \
	| tail -n 1
'
unset __

# Version announcements can be found here also:
# https://wiki.mozilla.org/Release_Management/Calendar

EBUILD_MAINTAINER_MODE=0
FIREFOX_PATCHSET="firefox-${PV%%.*}-patches-02.tar.xz"

LLVM_SLOTS=( 16 14 )
LLVM_MAX_SLOT=16

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="ncurses,sqlite,ssl"

WANT_AUTOCONF="2.1"

VIRTUALX_REQUIRED="pgo"

MOZ_ESR=

MOZ_PV=${PV}
MOZ_PV_SUFFIX=
if [[ ${PV} =~ (_(alpha|beta|rc).*)$ ]] ; then
	MOZ_PV_SUFFIX=${BASH_REMATCH[1]}

	# Convert the ebuild version to the upstream Mozilla version
	MOZ_PV="${MOZ_PV/_alpha/a}" # Handle alpha for SRC_URI
	MOZ_PV="${MOZ_PV/_beta/b}"  # Handle beta for SRC_URI
	MOZ_PV="${MOZ_PV%%_rc*}"    # Handle rc for SRC_URI
fi

if [[ -n ${MOZ_ESR} ]] ; then
	# ESR releases have slightly different version numbers
	MOZ_PV="${MOZ_PV}esr"
fi

MOZ_PN="${PN%-bin}"
MOZ_P="${MOZ_PN}-${MOZ_PV}"
MOZ_PV_DISTFILES="${MOZ_PV}${MOZ_PV_SUFFIX}"
MOZ_P_DISTFILES="${MOZ_PN}-${MOZ_PV_DISTFILES}"

UOPTS_SUPPORT_EPGO=0 # Recheck if allowed
UOPTS_SUPPORT_TBOLT=0
UOPTS_SUPPORT_TPGO=0
inherit autotools check-reqs desktop flag-o-matic gnome2-utils linux-info llvm multiprocessing
inherit pax-utils python-any-r1 toolchain-funcs virtualx xdg
inherit check-linker lcnr multilib-minimal rust-toolchain uopts
inherit cflags-depends

MOZ_SRC_BASE_URI="https://archive.mozilla.org/pub/${MOZ_PN}/releases/${MOZ_PV}"

if [[ ${PV} == *_rc* ]] ; then
	MOZ_SRC_BASE_URI="https://archive.mozilla.org/pub/${MOZ_PN}/candidates/${MOZ_PV}-candidates/build${PV##*_rc}"
fi

PATCH_URIS=(
	https://dev.gentoo.org/~{juippis,whissi,slashbeast}/mozilla/patchsets/${FIREFOX_PATCHSET}
)

SRC_URI="
	${MOZ_SRC_BASE_URI}/source/${MOZ_P}.source.tar.xz -> ${MOZ_P_DISTFILES}.source.tar.xz
	${PATCH_URIS[@]}
"

DESCRIPTION="Firefox Web Browser"
HOMEPAGE="https://www.mozilla.com/firefox"

KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

SLOT="rapid"
LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
# MPL-2.0 is the mostly used and default
LICENSE_FINGERPRINT="\
acfc4d19cb60b6e43e0b2d2d90455eb90256580200a5889cf669a84f07b335c3\
c4ac7996da32c198b4cca63494afbca4c4d085a22105112ac12a09fb3f9bca97\
" # SHA512
GAPI_KEY_MD5="709560c02f94b41f9ad2c49207be6c54"
GLOCATIONAPI_KEY_MD5="ffb7895e35dedf832eb1c5d420ac7420"
MAPI_KEY_MD5="3927726e9442a8e8fa0e46ccc39caa27"
# FF-XX.YY-THIRD-PARTY-LICENSES should be updated per new feature or if the \
# fingerprint changes.
# Update the license version also.
LICENSE_FILE_NAME="FF-$(ver_cut 1-2 ${PV})-THIRD-PARTY-LICENSES"
LICENSE+="
	${LICENSE_FILE_NAME}
	(
		(
			all-rights-reserved
			|| (
				AFL-2.1
				MIT
			)
		)
		(
			all-rights-reserved
			|| (
				AFL-2.1
				BSD
			)
		)
		(
			MIT
			GPL-2
		)
		BSD-2
		BSD
		LGPL-2.1
		|| (
			MPL-1.1
			GPL-2+
			LGPL-2.1+
		)
	)
	all-rights-reserved
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	Boost-1.0
	BSD
	BSD-2
	CC0-1.0
	CC-BY-4.0
	curl
	GPL-2+
	GPL-3+
	HPND
	icu-71.1
	ISC
	Ispell
	libpng
	MIT
	NAIST-IPADIC
	OFL-1.1
	Old-MIT
	OPENLDAP
	PSF-2
	PSF-2.4
	SunPro
	UoI-NCSA
	unicode
	Unicode-DFS-2016
	ZLIB
	pgo? (
		(
			(
				all-rights-reserved
				|| (
					MIT
					AFL-2.1
				)
			)
			(
				MIT
				GPL-2
			)
			BSD
			BSD-2
			MIT
		)
		BSD
		BSD-2
		LGPL-2.1
		LGPL-2.1+
		MPL-2.0
	)
	|| (
		BSD
		W3C-Document-License-2002
	)
	|| (
		MPL-1.1
		GPL-2+
		LGPL-2.1+
	)
" # \
# emerge does not recognize ^^ for the LICENSE variable.  You must choose
# at most one for some packages when || is present.

# Third party licenses:
#
# build/pgo/** folder:
#   ( BSD-2
#     ( all-rights-reserved || ( MIT AFL-2.1 ) )
#     ( MIT GPL-2 )
#     BSD
#     MIT
#   ) \
#     build/pgo/js-input/sunspider/string-unpack-code.html
#   || ( MIT GPL-2 ) build/pgo/blueprint/LICENSE
#   BSD
#   BSD-2
#   LGPL-2.1
#   LGPL-2.1+
#   MPL-2.0
#
# ( BSD-2 BSD LGPL-2.1
#   ( all-rights-reserved || ( AFL-2.1 MIT ) )
#   ( all-rights-reserved || ( AFL-2.1 BSD ) )
#   ( all-rights-reserved Apache-2.0 )
#   ( all-rights-reserved MIT )
#   ( MIT GPL-2 )
#   || ( MPL-1.1 GPL-2+ LGPL-2.1+ )
# ) \
#     third_party/webkit/PerformanceTests/**
# || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) \
#   testing/talos/talos/pageloader/chrome/pageloader.xhtml
# ^^ ( GPL-3? ( FTL ) GPL-2 ) modules/freetype2/LICENSE.TXT - GPL-2 assumed # \
#   since original ebuild cites it
# all-rights-reserved third_party/webkit/PerformanceTests/MotionMark/tests/master/resources/timeline.svg
# all-rights-reserved MIT mfbt/Span.h \
#   The standard MIT license template does not contain all rights reserved.
# all-rights-reserved MIT devtools/client/shared/widgets/CubicBezierWidget.js \
#   The standard MIT license template does not contain all rights reserved.
# Apache-2.0 for files listed in dom/encoding/test/stringencoding-license.txt
# Apache-2.0-with-LLVM-exceptions tools/fuzzing/libfuzzer/FuzzerUtilLinux.cpp
# Boost-1.0 - third_party/msgpack/include/msgpack/predef/compiler/ibm.h
# BSD media/kiss_fft/_kiss_fft_guts.h
# BSD dom/media/webrtc/transport/third_party/nrappkit/src/util/util.c
# BSD-2 ISC third_party/dav1d/tools/compat/getopt.c
# BSD, MIT, ISC nsprpub/pr/src/misc/praton.c
# || ( BSD W3C-Document-License-2002 ) testing/web-platform/tests/css/css-color/LICENSE
# CC-BY-4.0 browser/fonts/TwemojiMozilla.ttf \
#   (See https://github.com/mozilla/twemoji-colr/blob/master/LICENSE.md)
# curl - toolkit/crashreporter/google-breakpad/src/third_party/curl/COPYING
# custom testing/web-platform/tests/css/tools/w3ctestlib/catalog/xhtml11.dtd *
# custom testing/web-platform/tests/css/CSS2/LICENSE-W3CTS *
# custom js/src/tests/test262/built-ins/RegExp/S15.10.2_A1_T1.js *
# FTL modules/freetype2/builds/windows/w32-icc.mk
# GlyphWiki - layout/reftests/fonts/glyphwiki-license.txt *
# GPL-2+ testing/talos/talos/tests/v8_7/deltablue.js
# GPL-3+ js/src/devtools/rootAnalysis/run_complete
# HPND gfx/cairo/cairo/src/cairo-time.c
# ISC ipc/chromium/src/third_party/libevent/arc4random.c
# libpng media/libpng/pngconf.h
# OFL-1.1 layout/reftests/fonts/Chunkfive-license.txt
# OPENLDAP ISC third_party/rust/lmdb-rkv-sys/lmdb/libraries/liblmdb/mdb.c
# Old-MIT gfx/harfbuzz/
# PSF-2.4 (is a variation of) third_party/python/virtualenv/__virtualenv__/typing-3.7.4.3-py2-none-any/typing-3.7.4.3.dist-info/LICENSE
# PSF-2 third_party/python/virtualenv/__virtualenv__/contextlib2-0.6.0.post1-py2.py3-none-any/contextlib2-0.6.0.post1.dist-info/LICENSE.txt
# M+ FONTS LICENSE_E - layout/reftests/fonts/mplus/mplus-license.txt *
# MIT CC0-1.0 devtools/client/shared/vendor/lodash.js (more details can be \
#   found at https://github.com/lodash/lodash/blob/master/LICENSE)
# MIT UoI-NCSA js/src/jit/arm/llvm-compiler-rt/assembly.h
# UoI-NCSA tools/fuzzing/libfuzzer/LICENSE.TXT
# unicode [terms of use] Unicode-DFS-2016 [2 clause from website] BSD NAIST-IPADIC intl/icu/source/data/brkitr/dictionaries/cjdict.txt
# Unicode-DFS-2016 [2 clause] icu security/sandbox/chromium/base/third_party/icu/LICENSE
# Unicode-DFS-2016 [2 clause] third_party/rust/regex-syntax/src/unicode_tables/LICENSE-UNICODE
# unicode [3 clause] intl/icu/source/data/dtd/cldr-40/common/dtd/ldml.dtd
# Spencer-94 js/src/editline/README *
# SunPro modules/fdlibm/src/math_private.h
# ZLIB gfx/sfntly/cpp/src/test/tinyxml/tinyxml.cpp
# ZLIB media/ffvpx/libavutil/adler32.c
# ZLIB third_party/rust/libz-sys/src/zlib/zlib.h
# ZLIB MIT devtools/client/shared/vendor/jszip.js
# ZLIB all-rights-reserved media/libjpeg/simd/powerpc/jdsample-altivec.c -- \#
#   the vanilla ZLIB lib license doesn't contain all rights reserved

# (unforced) -hwaccel, pgo, x11 + wayland are defaults in -bin browser
CODEC_IUSE="
-aac
+dav1d
-h264
+opus
+vpx
"
IUSE+="
${CODEC_IUSE}
alsa cpu_flags_arm_neon cups +dbus debug eme-free +ffvpx +hardened -hwaccel jack
-jemalloc +jumbo-build libcanberra libproxy libsecret mold +openh264 +pgo
+pulseaudio proprietary-codecs proprietary-codecs-disable
proprietary-codecs-disable-nc-developer proprietary-codecs-disable-nc-user sndio
selinux speech +system-av1 +system-ffmpeg +system-harfbuzz +system-icu
+system-jpeg +system-libevent +system-libvpx system-png system-python-libs
+system-webp -telemetry +vaapi -valgrind +wayland +webrtc wifi webspeech
"
# telemetry disabled for crypto/security reasons

# Firefox-only IUSE
IUSE+="
geckodriver +gmp-autoupdate screencast +X
"

# The wayland flag actually allows vaapi, but upstream lazy to make it
# an independent option.
NON_FREE_REQUIRED_USE="
	^^ (
		proprietary-codecs
		proprietary-codecs-disable
		proprietary-codecs-disable-nc-developer
		proprietary-codecs-disable-nc-user
	)
	aac? (
		|| (
			proprietary-codecs
			proprietary-codecs-disable-nc-user
		)
	)
	h264? (
		proprietary-codecs
	)
	mold? (
		proprietary-codecs-disable
	)
	openh264? (
		proprietary-codecs
		system-ffmpeg
	)
	proprietary-codecs-disable? (
		!openh264
		eme-free
	)
	proprietary-codecs-disable-nc-developer? (
		!openh264
		eme-free
	)
	proprietary-codecs-disable-nc-user? (
		!openh264
		eme-free
	)
"
REQUIRED_USE="
	${NON_FREE_REQUIRED_USE}
	aac? (
		system-ffmpeg
	)
	dav1d? (
		|| (
			ffvpx
			system-ffmpeg
		)
	)
	debug? (
		!system-av1
	)
	h264? (
		system-ffmpeg
	)
	libcanberra? (
		|| (
			alsa
			pulseaudio
		)
	)
	opus? (
		|| (
			ffvpx
			system-ffmpeg
		)
	)
	pgo? (
		X
	)
	vaapi? (
		wayland
	)
	vpx? (
		|| (
			ffvpx
			system-ffmpeg
		)
	)
	wayland? (
		dbus
	)
	wifi? (
		dbus
	)
	|| (
		alsa
		pulseaudio
	)
	|| (
		wayland
		X
	)
"

#
# For dependencies versioning, files listed other than moz.configure have a
# higher weight than the moz.configure file.
#
# For dependency versioning, see also
# https://firefox-source-docs.mozilla.org/setup/linux_build.html
# https://www.mozilla.org/en-US/firefox/116.0.2/system-requirements/
# /var/tmp/portage/www-client/firefox-116.0.2/work/firefox-116.0.2/moz.configure
#   perl L589
# /var/tmp/portage/www-client/firefox-116.0.2/work/firefox-116.0.2/dom/media/platforms/ffmpeg//FFmpegRuntimeLinker.cpp L41 [y component in x.y.z subslot]
# /var/tmp/portage/www-client/firefox-116.0.2/work/firefox-116.0.2/build/moz.configure/nss.configure L12
# /var/tmp/portage/www-client/firefox-116.0.2/work/firefox-116.0.2/gfx/graphite2/include/graphite2/Font.h L31
# /var/tmp/portage/www-client/firefox-116.0.2/work/firefox-116.0.2/gfx/harfbuzz/configure.ac L3
# /var/tmp/portage/www-client/firefox-116.0.2/work/firefox-116.0.2/intl/icu/source/common/unicode/uvernum.h L63
# /var/tmp/portage/www-client/firefox-116.0.2/work/firefox-116.0.2/ipc/chromium/src/third_party/libevent/configure.ac L8
# /var/tmp/portage/www-client/firefox-116.0.2/work/firefox-116.0.2/media/libaom/config/aom_version.h L7
# /var/tmp/portage/www-client/firefox-116.0.2/work/firefox-116.0.2/media/libjpeg/jconfig.h L7
# /var/tmp/portage/www-client/firefox-116.0.2/work/firefox-116.0.2/media/libpng/png.h L281
# /var/tmp/portage/www-client/firefox-116.0.2/work/firefox-116.0.2/media/libvpx/config/vpx_version.h L8
# /var/tmp/portage/www-client/firefox-116.0.2/work/firefox-116.0.2/media/libwebp/moz.yaml L16
# /var/tmp/portage/www-client/firefox-116.0.2/work/firefox-116.0.2/modules/freetype2/include/freetype/freetype.h L5223
# /var/tmp/portage/www-client/firefox-116.0.2/work/firefox-116.0.2/nsprpub/pr/include/prinit.h L35
# /var/tmp/portage/www-client/firefox-116.0.2/work/firefox-116.0.2/third_party/dav1d/meson.build L26
# /var/tmp/portage/www-client/firefox-116.0.2/work/firefox-116.0.2/third_party/pipewire/pipewire/version.h L49
# /var/tmp/portage/www-client/firefox-116.0.2/work/firefox-116.0.2/taskcluster/ci/fetch/toolchains.yml
#   Keyword searches:  cbindgen-, llvm-, pkgconf-, rust-
# /var/tmp/portage/www-client/firefox-116.0.2/work/firefox-116.0.2/taskcluster/ci/packages/
#   Keyword search:  gtk
# /var/tmp/portage/www-client/firefox-116.0.2/work/firefox-116.0.2/taskcluster/ci/toolchain/
#   Keyword search:  nasm, nodejs, zlib
__='
# Scan with also:
SRC="/var/tmp/portage/www-client/firefox-116.0.2/work/firefox-116.0.2"
grep -E \
	-e "[0-9]+\.[0-9]+(\.[0-9]+)?" \
	-e "dependency" \
	-e "find_library" \
	-e "find_package" \
	-e "find_program" \
	-e "ExternalProject" \
	-e "PKG_CHECK_MODULES" \
	-e "pkg_check_modules"  \
	-e "REQUIRED" \
	$(find "${SRC}" \
		-name "*.mozbuild" \
		-o -name "moz.build" \
		-o -name "moz.configure" \
	) \
	| grep -v "MPL" \
	| grep -i -v "license" \
	| grep -F -v "/zero/"
'
unset __
#   Keyword search:  aom, dbus, dbus-glib, fontconfig, pango, perl, pixman, xkbcommon

DBUS_PV="0.60"
DBUS_GLIB_PV="0.60"
FFMPEG_PV="4.4.1" # This corresponds to y in x.y.z from the subslot.
GTK3_PV="3.14.5"
NASM_PV="2.14.02"
SPEECH_DISPATCHER_PV="0.11.4-r1"
XKBCOMMON_PV="0.4.1"

gen_llvm_bdepends() {
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
		(
			sys-devel/clang:${s}[${MULTILIB_USEDEP}]
			sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
			pgo? (
				=sys-libs/compiler-rt-sanitizers-${s}*:=[profile,${MULTILIB_USEDEP}]
			)
		)
		"
	done
}

FF_ONLY_DEPEND="
	!www-client/firefox:0
	!www-client/firefox:esr
	screencast? (
		>=media-video/pipewire-0.3.52:=[${MULTILIB_USEDEP}]
	)
	selinux? (
		sec-policy/selinux-mozilla
	)
"
GAMEPAD_BDEPEND="
	kernel_linux? (
		sys-kernel/linux-headers
	)
"

# Same as virtual/udev-217-r5 but with multilib changes.  Udev is required for
# gamepad, or WebAuthn roaming authenticators (e.g. USB security key)
UDEV_RDEPEND="
	kernel_linux? (
		|| (
			>=sys-apps/systemd-217[${MULTILIB_USEDEP}]
			>=sys-fs/eudev-2.1.1[${MULTILIB_USEDEP}]
			sys-apps/systemd-utils[${MULTILIB_USEDEP},udev]
			sys-fs/udev[${MULTILIB_USEDEP}]
		)
	)
"

# x86_64 will use ffvpx and system-ffmpeg but others will use system-ffmpeg
NON_FREE_CDEPENDS="
	proprietary-codecs? (
		media-libs/mesa[${MULTILIB_USEDEP},proprietary-codecs]
		system-ffmpeg? (
			media-video/ffmpeg[${MULTILIB_USEDEP},dav1d?,opus?,vaapi?,vpx?]
		)
		vaapi? (
			media-libs/vaapi-drivers[${MULTILIB_USEDEP}]
		)
	)
	proprietary-codecs-disable? (
		media-libs/mesa[${MULTILIB_USEDEP},-proprietary-codecs]
		system-ffmpeg? (
			|| (
				(
					!<dev-libs/openssl-3
					>=media-video/ffmpeg-${FFMPEG_PV}[${MULTILIB_USEDEP},-amr,-cuda,dav1d?,-fdk,-kvazaar,-openh264,openssl,opus?,proprietary-codecs-disable,vaapi?,vpx?,-x264,-x265,-xvid]
				)
				(
					>=media-video/ffmpeg-${FFMPEG_PV}[${MULTILIB_USEDEP},-amr,-cuda,dav1d?,-fdk,-kvazaar,-openh264,-openssl,opus?,proprietary-codecs-disable,vaapi?,vpx?,-x264,-x265,-xvid]
				)
			)
		)
	)
	proprietary-codecs-disable-nc-developer? (
		media-libs/mesa[${MULTILIB_USEDEP},-proprietary-codecs]
		system-ffmpeg? (
			|| (
				(
					!<dev-libs/openssl-3
					>=media-video/ffmpeg-${FFMPEG_PV}[${MULTILIB_USEDEP},-amr,-cuda,dav1d?,-fdk,-kvazaar,-openh264,openssl,opus?,proprietary-codecs-disable-nc-developer,vaapi?,vpx?,-x264,-x265,-xvid]
				)
				(
					>=media-video/ffmpeg-${FFMPEG_PV}[${MULTILIB_USEDEP},-amr,-cuda,dav1d?,-fdk,-kvazaar,-openh264,-openssl,opus?,proprietary-codecs-disable-nc-developer,vaapi?,vpx?,-x264,-x265,-xvid]
				)
			)
		)
	)
	proprietary-codecs-disable-nc-user? (
		media-libs/mesa[${MULTILIB_USEDEP},-proprietary-codecs]
		system-ffmpeg? (
			|| (
				(
					!<dev-libs/openssl-3
					>=media-video/ffmpeg-${FFMPEG_PV}[${MULTILIB_USEDEP},-amr,-cuda,dav1d?,-fdk,-kvazaar,-openh264,openssl,opus?,proprietary-codecs-disable-nc-user,vaapi?,vpx?,-x264,-x265,-xvid]
				)
				(
					>=media-video/ffmpeg-${FFMPEG_PV}[${MULTILIB_USEDEP},-amr,-cuda,dav1d?,-fdk,-kvazaar,-openh264,-openssl,opus?,proprietary-codecs-disable-nc-user,vaapi?,vpx?,-x264,-x265,-xvid]
				)
			)
		)
	)
"
CDEPEND="
	${FF_ONLY_DEPEND}
	${NON_FREE_CDEPENDS}
	>=app-accessibility/at-spi2-core-2.46.0:2[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.42:2[${MULTILIB_USEDEP}]
	>=dev-libs/nss-3.91.0[${MULTILIB_USEDEP}]
	>=dev-libs/nspr-4.35[${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.7.0[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.13.1[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.13[${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.22.0[${MULTILIB_USEDEP}]
	>=x11-libs/pixman-0.36.0[${MULTILIB_USEDEP}]
	dev-libs/expat[${MULTILIB_USEDEP}]
	dev-libs/libffi:=[${MULTILIB_USEDEP}]
	media-libs/alsa-lib[${MULTILIB_USEDEP}]
	virtual/freedesktop-icon-theme
	x11-libs/cairo[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf[${MULTILIB_USEDEP}]
	dbus? (
		>=dev-libs/dbus-glib-${DBUS_GLIB_PV}[${MULTILIB_USEDEP}]
		>=sys-apps/dbus-${DBUS_PV}[${MULTILIB_USEDEP}]
	)
	jack? (
		virtual/jack[${MULTILIB_USEDEP}]
	)
	pulseaudio? (
		|| (
			media-libs/libpulse[${MULTILIB_USEDEP}]
			>=media-sound/apulse-0.1.12-r4[${MULTILIB_USEDEP},sdk]
		)
	)
	libproxy? (
		>=net-libs/libproxy-1[${MULTILIB_USEDEP}]
	)
	selinux? (
		sec-policy/selinux-mozilla
	)
	sndio? (
		>=media-sound/sndio-1.8.0-r1[${MULTILIB_USEDEP}]
	)
	screencast? (
		media-video/pipewire:=
	)
	system-av1? (
		>=media-libs/dav1d-1.2.1:=[${MULTILIB_USEDEP},8bit]
		>=media-libs/libaom-1.0.0:=[${MULTILIB_USEDEP}]
	)
	system-harfbuzz? (
		>=media-gfx/graphite2-1.3.14[${MULTILIB_USEDEP}]
		>=media-libs/harfbuzz-7.3.0:0=[${MULTILIB_USEDEP}]
	)
	system-icu? (
		>=dev-libs/icu-73.1:=[${MULTILIB_USEDEP}]
	)
	system-jpeg? (
		>=media-libs/libjpeg-turbo-2.1.5.1[${MULTILIB_USEDEP}]
	)
	system-libevent? (
		>=dev-libs/libevent-2.1.12:0=[${MULTILIB_USEDEP},threads(+)]
	)
	system-libvpx? (
		>=media-libs/libvpx-1.13.0:0=[${MULTILIB_USEDEP},postproc]
	)
	system-png? (
		>=media-libs/libpng-1.6.39:0=[${MULTILIB_USEDEP},apng]
	)
	system-webp? (
		>=media-libs/libwebp-1.3.0:0=[${MULTILIB_USEDEP}]
	)
	valgrind? (
		dev-util/valgrind
	)
	wayland? (
		>=media-libs/libepoxy-1.5.10-r1[${MULTILIB_USEDEP}]
		>=x11-libs/gtk+-${GTK3_PV}:3[${MULTILIB_USEDEP},wayland]
		>=x11-libs/libdrm-2.4[${MULTILIB_USEDEP}]
		>=x11-libs/libxkbcommon-${XKBCOMMON_PV}[${MULTILIB_USEDEP},wayland]
	)
	wifi? (
		kernel_linux? (
			>=dev-libs/dbus-glib-${DBUS_GLIB_PV}[${MULTILIB_USEDEP}]
			>=net-misc/networkmanager-0.7[${MULTILIB_USEDEP}]
			>=sys-apps/dbus-${DBUS_PV}[${MULTILIB_USEDEP}]
		)
	)
	X? (
		>=x11-libs/gtk+-${GTK3_PV}:3[${MULTILIB_USEDEP},X]
		>=x11-libs/libxkbcommon-${XKBCOMMON_PV}[${MULTILIB_USEDEP},X]
		>=x11-libs/libXrandr-1.4.0[${MULTILIB_USEDEP}]
		>=x11-libs/libXtst-1.2.3[${MULTILIB_USEDEP}]
		virtual/opengl[${MULTILIB_USEDEP}]
		x11-libs/cairo[${MULTILIB_USEDEP},X]
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXcomposite[${MULTILIB_USEDEP}]
		x11-libs/libXdamage[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		x11-libs/libXfixes[${MULTILIB_USEDEP}]
		x11-libs/libxcb:=[${MULTILIB_USEDEP}]
	)
"

# See also PR_LoadLibrary
# speech-dispatcher-0.11.3 is bugged.
RDEPEND+="
	${CDEPEND}
	${UDEV_RDEPEND}
	cups? (
		net-print/cups[${MULTILIB_USEDEP}]
	)
	jack? (
		virtual/jack[${MULTILIB_USEDEP}]
	)
	libcanberra? (
		!pulseaudio? (
			alsa? (
				media-libs/libcanberra[${MULTILIB_USEDEP},alsa]
			)
		)
		pulseaudio? (
			media-libs/libcanberra[${MULTILIB_USEDEP},pulseaudio]
		)
	)
	libsecret? (
		app-crypt/libsecret[${MULTILIB_USEDEP}]
	)
	openh264? (
		media-libs/openh264:*[${MULTILIB_USEDEP},plugin]
	)
	pulseaudio? (
		|| (
			media-sound/pulseaudio[${MULTILIB_USEDEP}]
			>=media-sound/apulse-0.1.12-r4[${MULTILIB_USEDEP}]
		)
	)
	speech? (
		!pulseaudio? (
			alsa? (
				|| (
					>=app-accessibility/speech-dispatcher-${SPEECH_DISPATCHER_PV}[alsa,espeak]
					>=app-accessibility/speech-dispatcher-${SPEECH_DISPATCHER_PV}[alsa,espeak]
					>=app-accessibility/speech-dispatcher-${SPEECH_DISPATCHER_PV}[alsa,flite]
				)
			)
		)
		pulseaudio? (
			|| (
				>=app-accessibility/speech-dispatcher-${SPEECH_DISPATCHER_PV}[espeak,pulseaudio]
				>=app-accessibility/speech-dispatcher-${SPEECH_DISPATCHER_PV}[espeak,pulseaudio]
				>=app-accessibility/speech-dispatcher-${SPEECH_DISPATCHER_PV}[flite,pulseaudio]
			)
		)
	)
	vaapi? (
		media-libs/libva[${MULTILIB_USEDEP},drm(+),X?,wayland?]
	)
"

DEPEND+="
	${CDEPEND}
	X? (
		x11-base/xorg-proto
		x11-libs/libICE[${MULTILIB_USEDEP}]
		x11-libs/libSM[${MULTILIB_USEDEP}]
	)
"

BDEPEND+="
	${PYTHON_DEPS}
	${GAMEPAD_BDEPEND}
	>=dev-lang/perl-5.006
	>=dev-util/cbindgen-0.24.3
	>=dev-util/pkgconf-1.8.0[${MULTILIB_USEDEP},pkg-config(+)]
	>=net-libs/nodejs-12
	>=virtual/rust-1.69.0[${MULTILIB_USEDEP}]
	app-alternatives/awk
	app-arch/unzip
	app-arch/zip
	amd64? (
		>=dev-lang/nasm-${NASM_PV}
	)
	mold? (
		sys-devel/mold
	)
	pgo? (
		wayland? (
			>=gui-libs/wlroots-0.15.1-r1[tinywl]
			x11-misc/xkeyboard-config
		)
		X? (
			sys-devel/gettext
			x11-base/xorg-server[xvfb]
			x11-apps/xhost
		)
	)
	x86? (
		>=dev-lang/nasm-${NASM_PV}
	)
	|| (
		$(gen_llvm_bdepends)
	)
"

RESTRICT="mirror"

S="${WORKDIR}/${PN}-${PV%_*}"
S_BAK="${WORKDIR}/${PN}-${PV%_*}"

# One of the major sources of lag comes from dependencies.  These are strict to
# match performance to competition or normal builds.
declare -A CFLAGS_RDEPEND=(
	["media-libs/dav1d"]="-O2" # -O0 skippy, -O1 faster but blurry, -Os blurry still, -O2 not blurry
	["media-libs/libvpx"]="-O1" # -O0 causes FPS to lag below 25 FPS.
)

MOZILLA_FIVE_HOME=""
BUILD_OBJ_DIR=""

# Allow MOZ_GMP_PLUGIN_LIST to be set in an eclass or overridden in the
# enviromnent. (For advanced hackers only)
if [[ -z "${MOZ_GMP_PLUGIN_LIST+set}" ]] ; then
	MOZ_GMP_PLUGIN_LIST=(
		gmp-gmpopenh264
		gmp-widevinecdm
	)
fi

llvm_check_deps() {
	if ! has_version -b "sys-devel/clang:${LLVM_SLOT}" ; then
einfo "sys-devel/clang:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
		return 1
	fi

	if tc-is-clang ; then
		if ! has_version -b "sys-devel/lld:${LLVM_SLOT}" ; then
einfo "sys-devel/lld:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
			return 1
		fi

		if use pgo ; then
			if ! has_version -b "=sys-libs/compiler-rt-sanitizers-${LLVM_SLOT}*" ; then
einfo "=sys-libs/compiler-rt-sanitizers-${LLVM_SLOT}* is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
				return 1
			fi
		fi
	fi

einfo "Using LLVM slot ${LLVM_SLOT} to build" >&2
}

# Check every minor version
__='
PV="116.0.2"
wget -q -O - "http://ftp.mozilla.org/pub/firefox/releases/${PV}/linux-x86_64/xpi/" \
	| grep "href.*linux-x86_64"  \
	| cut -f 3 -d ">" \
	| cut -f 1 -d "<" \
	| sed -e "s|/||g" \
	| sed -e "s|.xpi$||g" \
	| sed -e "s|^\.\.$||g" \
	| tr "\n" " " \
	| fold -w 80 -s \
	| sed -e "s|^ ||g" \
	| sed -e "s| $||g"
'
unset __

MOZ_LANGS=(
ach af an ar ast az be bg bn br bs ca-valencia ca cak cs cy da de dsb el en-CA
en-GB en-US eo es-AR es-CL es-ES es-MX et eu fa ff fi fr fur fy-NL ga-IE gd gl
gn gu-IN he hi-IN hr hsb hu hy-AM ia id is it ja ka kab kk km kn ko lij lt lv
mk mr ms my nb-NO ne-NP nl nn-NO oc pa-IN pl pt-BR pt-PT rm ro ru sc sco si sk
sl son sq sr sv-SE szl ta te tg th tl tr trs uk ur uz vi xh zh-CN zh-TW
)

mozilla_set_globals() {
	# https://bugs.gentoo.org/587334
	local MOZ_TOO_REGIONALIZED_FOR_L10N=(
		fy-NL ga-IE gu-IN hi-IN hy-AM nb-NO ne-NP nn-NO pa-IN sv-SE
	)

	local lang xflag
	for lang in "${MOZ_LANGS[@]}" ; do
		if [[ ${lang} == en || ${lang} == en-US ]] ; then
	# Both are handled internally
			continue
		fi

	# Strip region subtag if $lang is in the list
		if has ${lang} "${MOZ_TOO_REGIONALIZED_FOR_L10N[@]}" ; then
			xflag=${lang%%-*}
		else
			xflag=${lang}
		fi

		SRC_URI+=" l10n_${xflag/[_@]/-}? ("
		SRC_URI+=" ${MOZ_SRC_BASE_URI}/linux-x86_64/xpi/${lang}.xpi -> ${MOZ_P_DISTFILES}-${lang}.xpi"
		SRC_URI+=" )"
		IUSE+=" l10n_${xflag/[_@]/-}"
	done
}
mozilla_set_globals

moz_clear_vendor_checksums() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -ne 1 ]] ; then
		die "${FUNCNAME} requires exact one argument"
	fi

einfo "Clearing cargo checksums for ${1} ..."

	sed -i \
		-e 's/\("files":{\)[^}]*/\1/' \
		"${S}/third_party/rust/${1}/.cargo-checksum.json" \
		|| die
}

moz_install_xpi() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 2 ]] ; then
		die "${FUNCNAME} requires at least two arguments"
	fi

	local DESTDIR=${1}
	shift

	insinto "${DESTDIR}"

	local emid xpi_file xpi_tmp_dir
	for xpi_file in "${@}" ; do
		emid=
		xpi_tmp_dir=$(mktemp -d --tmpdir="${T}")

		# Unpack XPI
		unzip -qq "${xpi_file}" -d "${xpi_tmp_dir}" || die

		# Determine extension ID
		if [[ -f "${xpi_tmp_dir}/install.rdf" ]] ; then
			emid=$(sed -n \
-e '/install-manifest/,$ { /em:id/!d; s/.*[\">]\([^\"<>]*\)[\"<].*/\1/; p; q }' \
				"${xpi_tmp_dir}/install.rdf")
			if [[ -z "${emid}" ]] ; then
eerror
eerror "Failed to determine the extension id from install.rdf"
eerror
				die
			fi
		elif [[ -f "${xpi_tmp_dir}/manifest.json" ]] ; then
			emid=$(sed -n \
				-e 's/.*"id": "\([^"]*\)".*/\1/p' \
				"${xpi_tmp_dir}/manifest.json")
			if [[ -z "${emid}" ]] ; then
eerror
eerror "Failed to determine the extension id from manifest.json"
eerror
				die
			fi
		else
eerror
eerror "Failed to determine the extension id"
eerror
			die
		fi

einfo "Installing ${emid}.xpi into ${ED}${DESTDIR} ..."
		newins "${xpi_file}" "${emid}.xpi"
	done
}

mozconfig_add_options_ac() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 2 ]] ; then
		die "${FUNCNAME} requires at least two arguments"
	fi

	local reason=${1}
	shift

	local option
	for option in ${@} ; do
		echo "ac_add_options ${option} # ${reason}" >>${MOZCONFIG}
	done
}

mozconfig_add_options_mk() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 2 ]] ; then
		die "${FUNCNAME} requires at least two arguments"
	fi

	local reason=${1}
	shift

	local option
	for option in ${@} ; do
		echo "mk_add_options ${option} # ${reason}" >>${MOZCONFIG}
	done
}

mozconfig_use_enable() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 1 ]] ; then
		die "${FUNCNAME} requires at least one arguments"
	fi

	local flag=$(use_enable "${@}")
	local t=$(use ${1} && echo +${1} || echo -${1})
	mozconfig_add_options_ac "${t}" "${flag}"
}

mozconfig_use_with() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 1 ]] ; then
		die "${FUNCNAME} requires at least one arguments"
	fi

	local flag=$(use_with "${@}")
	local t=$(use ${1} && echo +${1} || echo -${1})
	mozconfig_add_options_ac "${t}" "${flag}"
}

# Please see:
# https://github.com/gentoo/gentoo/pull/28366 ||
# https://github.com/gentoo/gentoo/pull/28355
tc-ld-is-mold() {
	local out

	# Ensure ld output is in English.
	local -x LC_ALL=C

	# First check the linker directly.
	out=$($(tc-getLD "$@") --version 2>&1)
	if [[ ${out} == *"mold"* ]] ; then
		return 0
	fi

	# Then see if they're selecting mold via compiler flags.
	# Note: We're assuming they're using LDFLAGS to hold the
	# options and not CFLAGS/CXXFLAGS.
	local base="${T}/test-tc-linker"
	cat <<-EOF > "${base}.c"
	int main() { return 0; }
	EOF
	out=$($(tc-getCC "$@") \
		${CFLAGS} \
		${CPPFLAGS} \
		${LDFLAGS} \
		-Wl,--version "${base}.c" \
		-o "${base}" \
		2>&1)
	rm -f "${base}"*
	if [[ ${out} == *"mold"* ]] ; then
		return 0
	fi

	# No mold here!
	return 1
}

virtwl() {
	debug-print-function ${FUNCNAME} "$@"

	[[ $# -lt 1 ]] && die "${FUNCNAME} needs at least one argument"
	if [[ -z $XDG_RUNTIME_DIR ]] ; then
eerror
eerror "${FUNCNAME} needs XDG_RUNTIME_DIR to be set; try xdg_environment_reset"
eerror
		die
	fi
	tinywl -h >/dev/null || die 'tinywl -h failed'

	# TODO: don't run addpredict in utility function. WLR_RENDERER=pixman
	# doesn't work
	addpredict /dev/dri
	local VIRTWL VIRTWL_PID
	coproc VIRTWL { \
		WLR_BACKENDS=headless \
		exec tinywl -s 'echo $WAYLAND_DISPLAY; read _; kill $PPID'; \
	}
	local -x WAYLAND_DISPLAY
	read WAYLAND_DISPLAY <&${VIRTWL[0]}

	debug-print "${FUNCNAME}: $@"
	"$@"
	local r=${?}

	[[ -n $VIRTWL_PID ]] || die "tinywl exited unexpectedly"
	exec {VIRTWL[0]}<&- {VIRTWL[1]}>&-
	return ${r}
}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] ; then
		if use pgo ; then
			if ! has usersandbox $FEATURES ; then
	# PGO doesn't require usersandbox dropped in general.
eerror
eerror "You must enable usersandbox as X server can not run as root!"
eerror
				die
			fi
		fi

	# Ensure we have enough disk space to compile
		if use pgo || is-flagq '-flto*' || use debug ; then
			CHECKREQS_DISK_BUILD="13500M"
		else
			CHECKREQS_DISK_BUILD="6600M"
		fi

		check-reqs_pkg_pretend
	fi
}

verify_codecs() {
	if use proprietary-codecs-disable \
		|| use proprietary-codecs-disable-nc-developer \
		|| use proprietary-codecs-disable-nc-user \
	; then
		:;
	else
		return
	fi
	if has_version "<dev-libs/openssl-3" \
		&& has_version "media-video/ffmpeg[openssl]" ; then
# Version 3 is allowed because of the Grant of Patent Clause in Apache-2.0.
eerror
eerror "Using <dev-libs/openssl-3 is disallowed with the"
eerror "proprietary-codecs-disable* USE flags."
eerror
		die
	fi
	if has_version ">=dev-libs/openssl-3" \
		&& has_version "<media-video/ffmpeg-5[openssl]" ; then
eerror
eerror "Using <media-video/ffmpeg-5 is disallowed with the"
eerror "proprietary-codecs-disable* USE flags.  This may add non-free code paths"
eerror "in FFmpeg."
eerror
		die
	fi
	if has_version "media-video/ffmpeg" ; then
ewarn
ewarn "Use a corrected local copy or the FFmpeg ebuild from the"
ewarn "oiledmachine-overlay to eliminate the possiblity of non-free code paths"
ewarn "and to ensure the package is LGPL/GPL."
ewarn
	fi
}

NABIS=0
pkg_setup() {
einfo
einfo "This is the rapid release."
einfo
	if [[ ${MERGE_TYPE} != binary ]] ; then
		if use pgo ; then
			if ! has userpriv ${FEATURES} ; then
eerror "Building ${PN} with USE=pgo and FEATURES=-userpriv is not supported!"
			fi
		fi

	# Ensure we have enough disk space to compile
		if use pgo || is-flagq '-flto*' || use debug ; then
			CHECKREQS_DISK_BUILD="13500M"
		else
			CHECKREQS_DISK_BUILD="6400M"
		fi

		check-reqs_pkg_setup

		llvm_pkg_setup

		if tc-is-clang && is-flagq '-flto*' ; then
			has_version "sys-devel/lld:$(clang-major-version)" \
				|| die "Clang PGO requires LLD."
			local lld_pv=$(ld.lld \
				--version 2>/dev/null \
				| awk '{ print $2 }')
			if [[ -n ${lld_pv} ]] ; then
				lld_pv=$(ver_cut 1 "${lld_pv}")
			fi
			if [[ -z ${lld_pv} ]] ; then
eerror
eerror "Failed to read ld.lld version!"
eerror
				die
			fi

			local llvm_rust_pv=$(rustc \
				-Vv 2>/dev/null \
				| grep -F -- 'LLVM version:' \
				| awk '{ print $3 }')
			if [[ -n ${llvm_rust_pv} ]] ; then
				llvm_rust_pv=$(ver_cut 1 "${llvm_rust_pv}")
			fi
			if [[ -z ${llvm_rust_pv} ]] ; then
eerror
eerror "Failed to read used LLVM version from rustc!"
eerror
				die
			fi

			if ver_test "${lld_pv}" -lt "${llvm_rust_pv}" ; then
eerror
eerror "Rust is using LLVM version ${llvm_rust_pv} but ld.lld version"
eerror "belongs to LLVM version ${lld_pv}."
eerror
eerror "You will be unable to link ${CATEGORY}/${PN}. To proceed you have the"
eerror "following options:"
eerror
eerror "  - Manually switch rust version using 'eselect rust' to match used"
eerror "    LLVM version"
eerror "  - Switch to dev-lang/rust[system-llvm] which will guarantee the"
eerror "    matching version"
eerror "  - Build ${CATEGORY}/${PN} without USE=lto"
eerror "  - Rebuild lld with llvm that was used to build rust (may need to"
eerror "    rebuild the whole llvm/clang/lld/rust chain depending on your"
eerror "    @world updates)"
eerror
eerror "LLVM version used by Rust (${llvm_rust_pv}) does not match with"
eerror "ld.lld version (${lld_pv})!"
eerror
				die
			fi
		fi

		python-any-r1_pkg_setup

	# Avoid PGO profiling problems due to enviroment leakage
	# These should *always* be cleaned up anyway
		unset \
			DBUS_SESSION_BUS_ADDRESS \
			DISPLAY \
			ORBIT_SOCKETDIR \
			SESSION_MANAGER \
			XAUTHORITY \
			XDG_CACHE_HOME \
			XDG_SESSION_COOKIE

	# Build system is using /proc/self/oom_score_adj, bug #604394
		addpredict /proc/self/oom_score_adj

		if use pgo ; then
	# Update 105.0: "/proc/self/oom_score_adj" isn't enough anymore with
	# pgo, but not sure whether that's due to better OOM handling by Firefox
	# (bmo#1771712), or portage (PORTAGE_SCHEDULING_POLICY) update...
			addpredict /proc

	# We may need a wider addpredict when using wayland+pgo.
			addpredict /dev/dri

	# Allow access to GPU during PGO run
			shopt -s nullglob

			local ati_cards=$(echo -n /dev/ati/card* \
				| sed 's/ /:/g')
			if [[ -n "${ati_cards}" ]] ; then
				addpredict "${ati_cards}"
			fi

			local mesa_cards=$(echo -n /dev/dri/card* \
				| sed 's/ /:/g')
			if [[ -n "${mesa_cards}" ]] ; then
				addpredict "${mesa_cards}"
			fi

			local nvidia_cards=$(echo -n /dev/nvidia* \
				| sed 's/ /:/g')
			if [[ -n "${nvidia_cards}" ]] ; then
				addpredict "${nvidia_cards}"
			fi

			local render_cards=$(echo -n /dev/dri/renderD128* \
				| sed 's/ /:/g')
			if [[ -n "${render_cards}" ]] ; then
				addpredict "${render_cards}"
			fi

			shopt -u nullglob
		fi

		if ! mountpoint -q /dev/shm ; then
	# If /dev/shm is not available, configure is known to fail with
	# a traceback report referencing
	# /usr/lib/pythonN.N/multiprocessing/synchronize.py
ewarn "/dev/shm is not mounted -- expect build failures!"
		fi

	# Google API keys (see http://www.chromium.org/developers/how-tos/api-keys)
	# Note: These are for Gentoo Linux use ONLY. For your own distribution, please
	# get your own set of keys.
		if [[ -z "${MOZ_API_KEY_GOOGLE+set}" ]] ; then
			MOZ_API_KEY_GOOGLE="AIzaSyDEAOvatFogGaPi0eTgsV_ZlEzx0ObmepsMzfAc"
		fi

		if [[ -z "${MOZ_API_KEY_LOCATION+set}" ]] ; then
			MOZ_API_KEY_LOCATION="AIzaSyB2h2OuRgGaPicUgy5N-5hsZqiPW6sH3n_rptiQ"
		fi

	# Mozilla API keys (see https://location.services.mozilla.com/api)
	# Note: These are for Gentoo Linux use ONLY. For your own distribution, please
	# get your own set of keys.
		if [[ -z "${MOZ_API_KEY_MOZILLA+set}" ]] ; then
			MOZ_API_KEY_MOZILLA="edb3d487-3a84-46m0ap1e3-9dfd-92b5efaaa005"
		fi

	# Ensure we use C locale when building, bug #746215
		export LC_ALL=C
	fi

	CONFIG_CHECK="~SECCOMP"
	WARNING_SECCOMP="CONFIG_SECCOMP not set! This system will be unable to play DRM-protected content."
	linux-info_pkg_setup

einfo
einfo "To set up cross-compile for other ABIs,"
einfo "see \`epkginfo -x firefox::oiledmachine-overlay\` or the metadata.xml"
einfo

	local jobs=$(echo "${MAKEOPTS}" \
		| grep -P -o -e "(-j|--jobs=)\s*[0-9]+" \
		| sed -r -e "s#(-j|--jobs=)\s*##g")
	local cores=$(nproc)
	if (( ${jobs} > $((${cores}/2)) )) ; then
ewarn
ewarn "Firefox may lock up or freeze the computer if the N value in"
ewarn "MAKEOPTS=\"-jN\" is greater than \$(nproc)/2"
ewarn
	fi

	if ! use pulseaudio ; then
ewarn
ewarn "Microphone support may be disabled when USE=-pulseaudio."
ewarn
	fi

	if [[ "${EBUILD_MAINTAINER_MODE}" == "1" ]] ; then
		local overlay_path=${MY_OVERLAY_DIR:-"${ESYSROOT}/usr/local/oiledmachine-overlay"}
		if [[ ! -e "${overlay_path}" ]] ; then
eerror
eerror "You need to change MY_OVERLAY_DIR as a per-package envvar to the base"
eerror "path of your overlay or local repo.  The base path should contain all"
eerror "the overlay's categories."
eerror
			die
		fi
	fi

	local a
	for a in $(multilib_get_enabled_abis) ; do
		NABIS=$((${NABIS} + 1))
	done
	uopts_setup

	use system-av1 && cflags-depends_check

	if [[ "${RUSTC_WRAPPER}" =~ "sccache" ]] ; then
ewarn
ewarn "Using sccache may randomly fail.  Retry if it fails."
ewarn
	fi

	if ! use wayland ; then
ewarn
ewarn "Disabling the wayland USE flag has the following consequences:"
ewarn
ewarn "  (1) Degrade WebGL FPS by less than 25 FPS (15 FPS on average)"
ewarn "  (2) Always use software CPU based video decode for VP8, VP9, AV1."
ewarn "      If the wayland USE flag is enabled, it will use GPU accelerated"
ewarn "      decoding if supported."
ewarn
	fi
	if use webspeech ; then
ewarn
ewarn "Speech recognition (USE=webspeech) has not been confirmed working."
ewarn
	fi
	verify_codecs
}

src_unpack() {
	local _lp_dir="${WORKDIR}/language_packs"
	local _src_file

	if [[ ! -d "${_lp_dir}" ]] ; then
		mkdir "${_lp_dir}" || die
	fi

	for _src_file in ${A} ; do
		if [[ ${_src_file} == *.xpi ]]; then
			if ! cp "${DISTDIR}/${_src_file}" "${_lp_dir}" ; then
eerror
eerror "Failed to copy '${_src_file}' to '${_lp_dir}'!"
eerror
				die
			fi
		else
			unpack ${_src_file}
		fi
	done
}

verify_license_fingerprint() {
einfo
einfo "Verifying about:license fingerprint"
einfo
	local actual_fp=$(sha512sum "${S}/toolkit/content/license.html" \
		| cut -f 1 -d " ")
	# Check patched versions and/or new features for differences.
	if [[ "${EBUILD_MAINTAINER_MODE}" == "1" ]] ; then
	# For ebuild maintainers
		if [[ \
			   ! ( "${LICENSE}" =~ "${LICENSE_FILE_NAME}" ) \
			|| ! -e "${MY_OVERLAY_DIR}/licenses/${LICENSE_FILE_NAME}" \
			|| "${actual_fp}" != "${LICENSE_FINGERPRINT}" \
		]] ; then
eerror
eerror "A change in the license was detected.  Please change"
eerror "LICENSE_FINGERPRINT=${actual_fp} and do a"
eerror
eerror "  \`cp -a ${S}/toolkit/content/license.html ${MY_OVERLAY_DIR}/licenses/${LICENSE_FILE_NAME}\`"
eerror
			die
		fi
	else
	# For users
		if [[ "${actual_fp}" != "${LICENSE_FINGERPRINT}" ]] ; then
eerror
eerror "Expected license fingerprint:\t${LICENSE_FINGERPRINT}"
eerror "Actual license fingerprint:\t${actual_fp}"
eerror
eerror "A change in the license was detected.  Please notify the ebuild"
eerror "maintainer."
eerror
			die
		fi
	fi
}

_get_s() {
	if (( ${NABIS} == 1 )) ; then
		echo "${S}"
	else
		echo "${S}-${MULTILIB_ABI_FLAG}.${ABI}"
	fi
}

src_prepare() {
	if is-flagq '-flto*' ; then
		rm -fv "${WORKDIR}/firefox-patches/"*"-LTO-Only-enable-LTO-"*".patch"
	fi
	if ! use ppc64 ; then
		rm -v "${WORKDIR}/firefox-patches/"*"ppc64"*".patch" || die
	fi
	eapply "${WORKDIR}/firefox-patches"
	eapply "${FILESDIR}/extra-patches/${PN}-106.0.2-disallow-store-data-races.patch"

	# Flicker prevention with -Ofast
	eapply "${FILESDIR}/extra-patches/${PN}-106.0.2-disable-broken-flags-gfx-layers.patch"

	# Prevent YT stall prevention with clang with -Ofast.
	# Prevent audio perma mute with gcc with -Ofast.
	eapply "${FILESDIR}/extra-patches/${PN}-106.0.2-disable-broken-flags-js.patch"

	# Only partial patching was done because the distro doesn't support
	# multilib Python.  Only native ABI is supported.  This means cbindgen
	# cannot load the 32-bit clang.  It will build the cargo parts.  When it
	# links it, it fails because of cbindings is 64-bit and the dependencies
	# use the build information for 64-bit linking, which should be 32-bit.

	# Allow to use system-ffmpeg completely.
	eapply "${FILESDIR}/extra-patches/${PN}-115e-allow-ffmpeg-decode-av1.patch"
	eapply "${FILESDIR}/extra-patches/${PN}-115e-disable-ffvpx.patch"

	# Prevent tab crash
	eapply "${FILESDIR}/extra-patches/${PN}-106.0.2-disable-broken-flags-dom-bindings.patch"

	# Prevent video seek bug
	eapply "${FILESDIR}/extra-patches/${PN}-116.0.2-disable-broken-flags-ipc-chromium-chromium-config.patch"

	# Allow user to apply any additional patches without modifing ebuild
	eapply_user

	# Make cargo respect MAKEOPTS
	export CARGO_BUILD_JOBS="$(makeopts_jobs)"

	# Make LTO respect MAKEOPTS
	sed -i \
		-e "s/multiprocessing.cpu_count()/$(makeopts_jobs)/" \
		"${S}/build/moz.configure/lto-pgo.configure" \
		|| die "sed failed to set num_cores"

	# Make ICU respect MAKEOPTS
	sed -i \
		-e "s/multiprocessing.cpu_count()/$(makeopts_jobs)/" \
		"${S}/intl/icu_sources_data.py" \
		|| die "sed failed to set num_cores"

	# sed-in toolchain prefix section was moved to the function below.
	#
	# Moved down
	#
	#

	sed -i \
		-e 's/ccache_stats = None/return None/' \
		"${S}/python/mozbuild/mozbuild/controller/building.py" \
		|| die "sed failed to disable ccache stats call"

einfo "Removing pre-built binaries ..."
	find "${S}/third_party" \
		-type f \
		\( \
			   -name '*.so' \
			-o -name '*.o' \
		\) \
		-print -delete || die

	# Respect choice for "jumbo-build"
	# Changing the value for FILES_PER_UNIFIED_FILE may not work, see #905431
	if [[ ! -z ${FILES_PER_UNIFIED_FILE} ]] && use jumbo-build; then
		local my_files_per_unified_file=${FILES_PER_UNIFIED_FILE:=16}
ewarn
ewarn "jumbo-build defaults modified to ${my_files_per_unified_file}."
ewarn "if you get a build failure, try undefining FILES_PER_UNIFIED_FILE,"
ewarn "if that fails try -jumbo-build before opening a bug report."
ewarn

		sed -i -e "s/\"FILES_PER_UNIFIED_FILE\", 16/\"FILES_PER_UNIFIED_FILE\", "${my_files_per_unified_file}"/" \
			python/mozbuild/mozbuild/frontend/data.py \
			|| die "Failed to adjust FILES_PER_UNIFIED_FILE in python/mozbuild/mozbuild/frontend/data.py"
		sed -i -e "s/FILES_PER_UNIFIED_FILE = 6/FILES_PER_UNIFIED_FILE = "${my_files_per_unified_file}"/" \
			js/src/moz.build \
			|| die "Failed to adjust FILES_PER_UNIFIED_FILE in js/src/moz.build"
	fi

	# Removed creation of a single build dir
	#
	#

	# Write API keys to disk
	echo -n "${MOZ_API_KEY_GOOGLE//gGaPi/}" > "${S}/api-google.key" || die
	echo -n "${MOZ_API_KEY_LOCATION//gGaPi/}" > "${S}/api-location.key" || die
	echo -n "${MOZ_API_KEY_MOZILLA//m0ap1/}" > "${S}/api-mozilla.key" || die

	verify_license_fingerprint

	(( ${NABIS} > 1 )) && multilib_copy_sources

	_src_prepare() {
		cd $(_get_s) || die
		local CDEFAULT=$(get_abi_CHOST ${DEFAULT_ABI})
	# Only ${CDEFAULT}-objdump exists because in true multilib.
	# Logically speaking, there should be i686-pc-linux-gnu-objdump.
		if [[ -e "${ESYSROOT}/usr/bin/${CHOST}-objdump" ]] ; then
	# Adds the toolchain prefix.
			sed -i \
				-e "s/\"objdump/\"${CHOST}-objdump/" \
				python/mozbuild/mozbuild/configure/check_debug_ranges.py \
				|| die "sed failed to set toolchain prefix"
einfo "Using ${CHOST}-objdump for CHOST"
		else
			[[ -e "${ESYSROOT}/usr/bin/${CDEFAULT}-objdump" ]] || die
	# Adds the toolchain prefix.
			sed -i \
				-e "s/\"objdump/\"${CDEFAULT}-objdump/" \
				python/mozbuild/mozbuild/configure/check_debug_ranges.py \
				|| die "sed failed to set toolchain prefix"
ewarn "Using ${CDEFAULT}-objdump for CDEFAULT"
		fi
		uopts_src_prepare
	}

	multilib_foreach_abi _src_prepare
}

# Corrections based on the ABI being compiled
# Preconditions:
#   CHOST must be defined
#   cwd is ABI's S
_fix_paths() {
	# For proper rust cargo cross-compile for libloading and glslopt
	export PKG_CONFIG=${CHOST}-pkg-config
	export CARGO_CFG_TARGET_ARCH=$(echo ${CHOST} \
		| cut -f 1 -d "-")
	export MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"
	export BUILD_OBJ_DIR="$(pwd)/ff"

	# Set MOZCONFIG
	export MOZCONFIG="$(pwd)/.mozconfig"

	# For rust crates libloading and glslopt
	if tc-is-clang ; then
		local version_clang=$(clang --version 2>/dev/null \
			| grep -F -- 'clang version' \
			| awk '{ print $3 }')
		if [[ -n ${version_clang} ]] ; then
			version_clang=$(ver_cut 1 "${version_clang}")
		else
eerror
eerror "Failed to read clang version!"
eerror
			die
		fi
		CC="${CHOST}-clang-${version_clang}"
		CXX="${CHOST}-clang++-${version_clang}"
	else
		CC="${CHOST}-gcc"
		CXX="${CHOST}-g++"
	fi
	tc-export CC CXX
	strip-unsupported-flags
}

append_all() {
	append-flags ${@}
	append-ldflags ${@}
}

is_flagq_last() {
	local flag="${1}"
	local olast=$(echo "${CFLAGS}" \
		| grep -o -E -e "-O(0|g|1|z|s|2|3|4|fast)" \
		| tr " " "\n" \
		| tail -n 1)
einfo "CFLAGS:\t${CFLAGS}"
einfo "olast:\t${olast}"
	[[ "${flag}" == "${olast}" ]] && return 0
	return 1
}

get_olast() {
	local olast=$(echo "${CFLAGS}" \
		| grep -o -E -e "-O(0|g|1|z|s|2|3|4|fast)" \
		| tr " " "\n" \
		| tail -n 1)
	if [[ -n "${olast}" ]] ; then
		echo "${olast}"
	else
		# Upstream default
		echo "-O3"
	fi
}

check_speech_dispatcher() {
	if use speech ; then
		if [[ ! -f "${ESYSROOT}/etc/speech-dispatcher/speechd.conf" ]] ; then
eerror
eerror "Missing ${ESYSROOT}/etc/speech-dispatcher/speechd.conf"
eerror
			die
		fi
		if has_version "app-accessibility/speech-dispatcher[pulseaudio]" ; then
			if ! grep -q -e "^AudioOutputMethod.*\"pulse\"" \
				"${ESYSROOT}/etc/speech-dispatcher/speechd.conf" ; then
eerror
eerror "The following changes are required to"
eerror "${ESYSROOT}/etc/speech-dispatcher/speechd.conf"
eerror
eerror "AudioOutputMethod \"pulse\""
eerror
eerror "The ~/.config/speech-dispatcher/speechd.conf should be removed or have"
eerror "the same settings."
eerror
				die
			fi
		elif has_version "app-accessibility/speech-dispatcher[alsa]" ; then
			if ! grep -q -e "^AudioOutputMethod.*\"alsa\"" \
				"${ESYSROOT}/etc/speech-dispatcher/speechd.conf" ; then
eerror
eerror "The following changes are required to"
eerror "${ESYSROOT}/etc/speech-dispatcher/speechd.conf:"
eerror
eerror "AudioOutputMethod \"alsa\""
eerror
eerror "The ~/.config/speech-dispatcher/speechd.conf should be removed or have"
eerror "the same settings."
eerror
				die
			fi
		fi
		if has_version "app-accessibility/speech-dispatcher[espeak]" ; then
			if ! grep -q -e "^AddModule.*\"espeak-ng\"" \
				"${ESYSROOT}/etc/speech-dispatcher/speechd.conf" ; then
eerror
eerror "The following changes are required to"
eerror "${ESYSROOT}/etc/speech-dispatcher/speechd.conf:"
eerror
eerror "AddModule \"espeak-ng\"                \"sd_espeak-ng\" \"espeak-ng.conf\""
eerror "DefaultModule espeak-ng"
eerror
eerror "The ~/.config/speech-dispatcher/speechd.conf should be removed or have"
eerror "the same settings."
eerror
				die
			fi
			if ! grep -q -e "^DefaultModule.*espeak-ng" \
				"${ESYSROOT}/etc/speech-dispatcher/speechd.conf" ; then
eerror
eerror "The following changes are required to"
eerror "${ESYSROOT}/etc/speech-dispatcher/speechd.conf:"
eerror
eerror "DefaultModule espeak-ng"
eerror
eerror "The ~/.config/speech-dispatcher/speechd.conf should be removed or have"
eerror "the same settings."
eerror
				die
			fi
		elif has_version "app-accessibility/speech-dispatcher[espeak]" ; then
			if ! grep -q -e "^AddModule.*\"espeak\"" \
				"${ESYSROOT}/etc/speech-dispatcher/speechd.conf" ; then
eerror
eerror "The following changes are required to"
eerror "${ESYSROOT}/etc/speech-dispatcher/speechd.conf:"
eerror
eerror "AddModule \"espeak\"                   \"sd_espeak\"    \"espeak.conf\""
eerror "DefaultModule espeak"
eerror
eerror "The ~/.config/speech-dispatcher/speechd.conf should be removed or have"
eerror "the same settings."
eerror
				die
			fi
			if ! grep -q -e "^DefaultModule.*espeak" \
				"${ESYSROOT}/etc/speech-dispatcher/speechd.conf" ; then
eerror
eerror "The following changes are required to"
eerror "${ESYSROOT}/etc/speech-dispatcher/speechd.conf:"
eerror
eerror "DefaultModule espeak"
eerror
eerror "The ~/.config/speech-dispatcher/speechd.conf should be removed or have"
eerror "the same settings."
eerror
				die
			fi
		elif has_version "app-accessibility/speech-dispatcher[flite]" ; then
			if ! grep -q -e "^AddModule.*\"flite\"" \
				"${ESYSROOT}/etc/speech-dispatcher/speechd.conf" ; then
eerror
eerror "The following changes are required to"
eerror "${ESYSROOT}/etc/speech-dispatcher/speechd.conf:"
eerror
eerror "#AddModule \"flite\"                    \"sd_flite\"     \"flite.conf\""
eerror "DefaultModule flite"
eerror
eerror "The ~/.config/speech-dispatcher/speechd.conf should be removed or have"
eerror "the same settings."
eerror
				die
			fi
			if ! grep -q -e "^DefaultModule.*flite" \
				"${ESYSROOT}/etc/speech-dispatcher/speechd.conf" ; then
eerror
eerror "The following changes are required to"
eerror "${ESYSROOT}/etc/speech-dispatcher/speechd.conf:"
eerror
eerror "DefaultModule flite"
eerror
eerror "The ~/.config/speech-dispatcher/speechd.conf should be removed or have"
eerror "the same settings."
eerror
				die
			fi
		fi
	fi
}

OFLAG=""
LTO_TYPE=""
_src_configure() {
	local s=$(_get_s)
	cd "${s}" || die

	local CDEFAULT=$(get_abi_CHOST ${DEFAULT_ABI})
	# Show flags set at the beginning
einfo
einfo "Current BINDGEN_CFLAGS:\t${BINDGEN_CFLAGS:-no value set}"
einfo "Current CFLAGS:\t\t${CFLAGS:-no value set}"
einfo "Current CXXFLAGS:\t\t${CXXFLAGS:-no value set}"
einfo "Current LDFLAGS:\t\t${LDFLAGS:-no value set}"
einfo "Current RUSTFLAGS:\t\t${RUSTFLAGS:-no value set}"
einfo "Cross-compile CHOST:\t\t${CHOST}"
einfo

	local have_switched_compiler=
	if tc-is-clang || use jumbo-build ; then
	# The logic is inverted in the commit below.
	# https://gitweb.gentoo.org/repo/gentoo.git/commit/www-client/firefox?id=bbf20ce6d62985723c948f5dcb5d0d23b975ac01

	# Force clang
einfo
einfo "Switching to clang"
einfo
		local version_clang=$(clang --version 2>/dev/null \
			| grep -F -- 'clang version' \
			| awk '{ print $3 }')
		if [[ -n ${version_clang} ]] ; then
			version_clang=$(ver_cut 1 "${version_clang}")
		else
eerror
eerror "Failed to read clang version!"
eerror
			die
		fi
		have_switched_compiler="yes"
		AR="llvm-ar"
		AS="llvm-as"
		CC="${CHOST}-clang-${version_clang}"
		CXX="${CHOST}-clang++-${version_clang}"
		NM="llvm-nm"
		RANLIB="llvm-ranlib"
		local clang_slot=$(clang-major-version)
		if ! has_version "sys-devel/lld:${clang_slot}" ; then
eerror
eerror "You need to emerge sys-devel/lld:${clang_slot}"
eerror
			die
		fi
		if ! has_version "=sys-libs/compiler-rt-sanitizers-${clang_slot}*[profile]" ; then
eerror
eerror "You need to emerge =sys-libs/compiler-rt-sanitizers-${clang_slot}*[profile]"
eerror
			die
		fi
	else
	# Force gcc
ewarn
ewarn "GCC is not the upstream default"
ewarn
		# Force gcc
		have_switched_compiler=yes
einfo
einfo "Switching to gcc"
einfo
		AR=gcc-ar
		CC=${CHOST}-gcc
		CXX=${CHOST}-g++
		NM=gcc-nm
		RANLIB=gcc-ranlib
	fi

	if [[ -n "${have_switched_compiler}" ]] ; then
	# Because we switched active compiler we have to ensure that no
	# unsupported flags are set
		strip-unsupported-flags
	fi

	uopts_src_configure
	check_speech_dispatcher

	# Ensure we use correct toolchain
	export HOST_CC="$(tc-getBUILD_CC)"
	export HOST_CXX="$(tc-getBUILD_CXX)"
	tc-export CC CXX LD AR NM OBJDUMP RANLIB PKG_CONFIG
	_fix_paths
	# Pass the correct toolchain paths through cbindgen
	if tc-is-cross-compiler ; then
		export BINDGEN_CFLAGS="
			${SYSROOT:+--sysroot=${ESYSROOT}}
			--host=${CDEFAULT}
			--target=${CHOST} ${BINDGEN_CFLAGS-}
		"
	fi

	# MOZILLA_FIVE_HOME is dynamically generated per ABI in _fix_paths().
	#

	# python/mach/mach/mixin/process.py fails to detect SHELL
	export SHELL="${EPREFIX}/bin/bash"

	# Set state path
	export MOZBUILD_STATE_PATH="${s}"

	# MOZCONFIG is dynamically generated per ABI in _fix_paths().
	#

	# Initialize MOZCONFIG
	mozconfig_add_options_ac '' --enable-application=browser
	mozconfig_add_options_ac '' --enable-project=browser

	# Set distro defaults
	if use telemetry; then
		export MOZILLA_OFFICIAL=1
	fi

	mozconfig_add_options_ac 'Gentoo default' \
		--allow-addon-sideload \
		--disable-cargo-incremental \
		--disable-crashreporter \
		--disable-gpsd \
		--disable-install-strip \
		--disable-legacy-profile-creation \
		--disable-parental-controls \
		--disable-strip \
		--disable-tests \
		--disable-updater \
		--disable-wmf \
		--enable-negotiateauth \
		--enable-new-pass-manager \
		--enable-official-branding \
		--enable-release \
		--enable-system-ffi \
		--enable-system-pixman \
		--enable-system-policies \
		--host="${CDEFAULT}" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--prefix="${EPREFIX}/usr" \
		--target="${CHOST}" \
		--without-ccache \
		--without-wasm-sandboxed-libraries \
		--with-intl-api \
		\
		--with-system-nspr \
		--with-system-nss \
		--with-system-zlib \
		--with-toolchain-prefix="${CHOST}-" \
		--with-unsigned-addon-scopes=app,system \
		--x-includes="${ESYSROOT}/usr/include" \
		--x-libraries="${ESYSROOT}/usr/$(get_libdir)"

	if use system-ffmpeg ; then
		mozconfig_add_options_ac \
			'+system-ffmpeg' \
			--enable-ffmpeg
	else
		mozconfig_add_options_ac \
			'-system-ffmpeg' \
			--disable-ffmpeg
	fi

	if true ; then
		:;
	elif use ffvpx ; then
		mozconfig_add_options_ac \
			'ffvpx=default' \
			--with-ffvpx=default
	else
		mozconfig_add_options_ac \
			'ffvpx=no' \
			--with-ffvpx=no
	fi

	# mozconfig_add_options_ac \
	#	'' \
	#	--with-libclang-path="$(${CHOST}-llvm-config --libdir)"
	# Disabled lines above because the distro doesn't support multilib
	# python, so full cross-compile is not supported.

	# The commented lines above are mutually exclusive with this line below.
	mozconfig_add_options_ac \
		'' \
		--with-libclang-path="$(llvm-config --libdir)"

	# Set update channel
	local update_channel=release
	[[ -n ${MOZ_ESR} ]] && update_channel=esr
	mozconfig_add_options_ac '' --update-channel=${update_channel}

	if ! use x86 && [[ ${CHOST} != armv*h* ]] ; then
		mozconfig_add_options_ac '' --enable-rust-simd
	fi

	# For future keywording: This is currently (97.0) only supported on:
	# amd64, arm, arm64, and x86.
	# You might want to flip the logic around if Firefox is to support more
	# arches.
	if use ppc64; then
		mozconfig_add_options_ac '' --disable-sandbox
	elif use valgrind; then
		mozconfig_add_options_ac 'valgrind requirement' --disable-sandbox
	else
		mozconfig_add_options_ac '' --enable-sandbox
	fi

	if [[ -s "${s}/api-google.key" ]] ; then
		local key_origin="Gentoo default"
		if [[ $(cat "${s}/api-google.key" \
			| md5sum \
			| awk '{ print $1 }') != "${GAPI_KEY_MD5}" ]] ; then
			key_origin="User value"
		fi

		mozconfig_add_options_ac \
			"${key_origin}" \
			--with-google-safebrowsing-api-keyfile="${s}/api-google.key"
	else
einfo "Building without Google API key ..."
	fi

	if [[ -s "${s}/api-location.key" ]] ; then
		local key_origin="Gentoo default"
		if [[ $(cat "${s}/api-location.key" \
			| md5sum \
			| awk '{ print $1 }') != "${GLOCATIONAPI_KEY_MD5}" ]] ; then
			key_origin="User value"
		fi

		mozconfig_add_options_ac \
			"${key_origin}" \
			--with-google-location-service-api-keyfile="${s}/api-location.key"
	else
einfo "Building without Location API key ..."
	fi

	if [[ -s "${s}/api-mozilla.key" ]] ; then
		local key_origin="Gentoo default"
		if [[ $(cat "${s}/api-mozilla.key" \
			| md5sum \
			| awk '{ print $1 }') != "${MAPI_KEY_MD5}" ]] ; then
			key_origin="User value"
		fi

		mozconfig_add_options_ac \
			"${key_origin}" \
			--with-mozilla-api-keyfile="${s}/api-mozilla.key"
	else
einfo "Building without Mozilla API key ..."
	fi

	# To find features, use
	# grep -o -E -r \
	#	-e "--(with|disable|enable)[^\"]+" \
	#	./toolkit/moz.configure \
	#	| sort \
	#	| uniq
	mozconfig_use_with system-av1
	mozconfig_use_with system-harfbuzz
	mozconfig_use_with system-harfbuzz system-graphite2
	mozconfig_use_with system-icu
	mozconfig_use_with system-jpeg
	mozconfig_use_with system-libevent
	mozconfig_use_with system-libvpx
	mozconfig_use_with system-png
	mozconfig_use_with system-webp

	mozconfig_use_enable dbus
	mozconfig_use_enable libproxy
	mozconfig_use_enable valgrind
	mozconfig_use_enable cups printing
	multilib_is_native_abi && mozconfig_use_enable speech synth-speechd
	mozconfig_use_enable webrtc
	mozconfig_use_enable webspeech

	use eme-free && mozconfig_add_options_ac '+eme-free' --disable-eme

	mozconfig_use_enable geckodriver

	# The upstream default is hardening on even if unset.
	if use hardened ; then
		mozconfig_add_options_ac "+hardened" --enable-hardening
		append-ldflags "-Wl,-z,relro -Wl,-z,now" # Full Relro
	else
		mozconfig_add_options_ac "-hardened" --disable-hardening
	fi

	local myaudiobackends=""
	use jack && myaudiobackends+="jack,"
	use sndio && myaudiobackends+="sndio,"
	use pulseaudio && myaudiobackends+="pulseaudio,"
	! use pulseaudio && myaudiobackends+="alsa,"

	mozconfig_add_options_ac \
		'--enable-audio-backends' \
		--enable-audio-backends=$(echo "${myaudiobackends}" \
			| sed -e "s|,$||g") # Cannot be empty

	mozconfig_use_enable wifi necko-wifi

	! use jumbo-build && \
		mozconfig_add_options_ac \
			'--disable-unified-build' \
			--disable-unified-build

	if use X && use wayland ; then
		mozconfig_add_options_ac \
			'+x11+wayland' \
			--enable-default-toolkit=cairo-gtk3-x11-wayland
	elif ! use X && use wayland ; then
		mozconfig_add_options_ac \
			'+wayland' \
			--enable-default-toolkit=cairo-gtk3-wayland-only
	else
		mozconfig_add_options_ac \
			'+x11' \
			--enable-default-toolkit=cairo-gtk3
	fi

	if ! use mold && is-flagq '-fuse-ld=mold' ; then
eerror
eerror "-fuse-ld=mold requires the mold USE flag."
eerror
		die
	fi

einfo "PGO/LTO requires per-package -flto in {C,CXX,LD}FLAGS"
	if [[ -z "${LTO_TYPE}" ]] ; then
		LTO_TYPE=$(check-linker_get_lto_type)
	fi

	if use pgo || [[ "${LTO_TYPE}" =~ ("bfdlto"|"moldlto"|"thinlto") ]]
	then
	# Mold for gcc works for non-lto but for lto it is likely WIP.
		if [[ "${LTO_TYPE}" == "moldlto" ]] ; then
			use tc-is-gcc && ewarn "remove -fuse-ld=mold if it breaks on gcc"
			mozconfig_add_options_ac \
				"forcing ld=mold" \
				--enable-linker=mold

			mozconfig_add_options_ac \
				'+lto' \
				--enable-lto=cross

		elif tc-is-clang && [[ "${LTO_TYPE}" == "thinlto" ]] ; then
	# Upstream only supports lld when using clang
			mozconfig_add_options_ac \
				"forcing ld=lld" \
				--enable-linker=lld

			mozconfig_add_options_ac \
				'+lto' \
				--enable-lto=cross

		else
	# ThinLTO is currently broken, see bmo#1644409
			mozconfig_add_options_ac \
				'+lto' \
				--enable-lto=full
			mozconfig_add_options_ac \
				"linker is set to bfd" \
				--enable-linker=bfd
		fi

		if use pgo ; then
			mozconfig_add_options_ac '+pgo' MOZ_PGO=1

			if tc-is-clang ; then
				# Used in build/pgo/profileserver.py
				export LLVM_PROFDATA="llvm-profdata"
			fi
		fi
	else
		if is-flagq '-fuse-ld=mold' || use mold ; then
			mozconfig_add_options_ac \
				"forcing ld=mold" \
				--enable-linker=mold
		elif tc-is-clang && has_version "sys-devel/lld:$(clang-major-version)" ; then
	# This is upstream's default
			mozconfig_add_options_ac \
				"forcing ld=lld" \
				--enable-linker=lld
		else
			mozconfig_add_options_ac \
				"linker is set to bfd" \
				--enable-linker=bfd
		fi
	fi

	if tc-ld-is-mold ; then
		# Increase ulimit with mold+lto, bugs #892641, #907485
		if ! ulimit -n 16384 1>/dev/null 2>&1 ; then
ewarn
ewarn "Unable to modify ulimits - building with mold+lto might fail due to low"
ewarn "ulimit -n resources."
ewarn
ewarn "Please see bugs #892641 & #907485."
ewarn
		else
			ulimit -n 16384
		fi
	fi

	# Set above
	filter-flags '-fuse-ld=*'

	# LTO flag was handled via configure
	filter-flags '-flto*'

	# Filter ldflags after linker switch
	strip-unsupported-flags

	# Default upstream Oflag is -O0 in script, but -bin's default is -O3,
	# but dav1d's FPS + image quality is only acceptable at >= -O2.
	mozconfig_use_enable debug
	if use debug ; then
		mozconfig_add_options_ac '+debug' --disable-optimize
		mozconfig_add_options_ac '+debug' --enable-real-time-tracing
	else
		mozconfig_add_options_ac \
			'Gentoo defaults' \
			--disable-real-time-tracing

	# No -Og beyond this point.
		mozconfig_add_options_ac \
			'Gentoo default' \
			--disable-debug-symbols

	# Fork ebuild, or use distro ebuild, or set USE=debug if you want -Og
		if is_flagq_last '-Ofast' || [[ "${OFLAG}" == "-Ofast" ]] ; then
einfo "Using -Ofast"
			OFLAG="-Ofast"
			mozconfig_add_options_ac \
				"from CFLAGS" \
				--enable-optimize=-Ofast
		elif is_flagq_last '-O4' || [[ "${OFLAG}" == "-O4" ]] ; then
	# O4 is the same as O3.
			OFLAG="-O4"
			mozconfig_add_options_ac \
				"from CFLAGS" \
				--enable-optimize=-O4
		elif is_flagq_last '-O3' || [[ "${OFLAG}" == "-O3" ]] ; then
	# Repeated for multiple Oflags
			OFLAG="-O3"
			mozconfig_add_options_ac \
				"from CFLAGS" \
				--enable-optimize=-O3
		elif is_flagq_last '-O2' || [[ "${OFLAG}" == "-O2" ]] ; then
			OFLAG="-O2"
			mozconfig_add_options_ac \
				"from CFLAGS" \
				--enable-optimize=-O2
		else
			OFLAG="-O3"
			mozconfig_add_options_ac \
				"Upstream default" \
				--enable-optimize=-O3
		fi
	fi

	local oflag_safe
	if [[ -z "${OFLAG}" ]] ; then
		oflag_safe=$(get_olast)
	else
		oflag_safe="${OFLAG}"
	fi
	[[ "${oflag_safe}" == "-Ofast" ]] && oflag_safe="-O3"
einfo "oflag_safe:\t${oflag_safe}"

	local L=(
		"dom/bindings/moz.build"
		"ipc/chromium/chromium-config.mozbuild"
		"gfx/layers/moz.build"
		"js/src/js-cxxflags.mozbuild"
	)

	local f
	for f in ${L[@]} ; do
einfo "Editing ${f}:  __OFLAG_SAFE__ -> ${oflag_safe}"
		sed -i -e "s|__OFLAG_SAFE__|${oflag_safe}|g" \
			"${f}" \
			|| die
	done

	# Debug flag was handled via configure
	filter-flags '-g*'

	# Optimization flag was handled via configure
	filter-flags '-O*'

	if is-flagq '-ffast-math' || [[ "${OFLAG}" == "-Ofast" ]] ; then
		local pos=$(grep -n "#define OPUS_DEFINES_H" \
			"${s}/media/libopus/include/opus_defines.h" \
			| cut -f 1 -d ":")
		sed -i -e "${pos}a#define FLOAT_APPROX 1" \
			"${s}/media/libopus/include/opus_defines.h" || die
	fi

	# Modifications to better support ARM, bug #553364
	if use cpu_flags_arm_neon ; then
		mozconfig_add_options_ac '+cpu_flags_arm_neon' --with-fpu=neon

		if tc-is-gcc ; then
	# Thumb options aren't supported when using clang, bug 666966
			mozconfig_add_options_ac \
				'+cpu_flags_arm_neon' \
				--with-thumb=yes \
				--with-thumb-interwork=no
		fi
	fi

	if [[ ${CHOST} == armv*h* ]] ; then
		mozconfig_add_options_ac 'CHOST=armv*h*' --with-float-abi=hard

		if ! use system-libvpx ; then
			sed -i \
				-e "s|softfp|hard|" \
				"${s}/media/libvpx/moz.build" \
				|| die
		fi
	fi

	if tc-is-clang ; then
	# https://bugzilla.mozilla.org/show_bug.cgi?id=1482204
	# https://bugzilla.mozilla.org/show_bug.cgi?id=1483822
	# toolkit/moz.configure Elfhack section: target.cpu in ('arm', 'x86', 'x86_64')
		local disable_elf_hack=
		if use amd64 ; then
			disable_elf_hack=yes
		elif use x86 ; then
			disable_elf_hack=yes
		elif use arm ; then
			disable_elf_hack=yes
		fi

		if [[ -n ${disable_elf_hack} ]] ; then
			mozconfig_add_options_ac \
				'elf-hack is broken when using Clang' \
				--disable-elf-hack
		fi
	fi

	if (is_flagq_last "-O3" || is_flagq_last "-Ofast") \
		&& tc-is-gcc \
		&& ver_test $(gcc-fullversion) -lt 11.3.0 ; then
ewarn
ewarn "GCC version detected:\t$(gcc-fullversion)"
ewarn "Expected version:\t>= 11.3"
ewarn
ewarn "The detected version is untested and may result in userscript failure."
ewarn "Use GCC >= 11.3 or Clang to prevent this bug."
ewarn
	fi

	# Use the O(1) algorithm linker algorithm and add more swap instead.
ewarn
ewarn "Add more swap space if linker causes an out of memory (OOM) condition."
ewarn

	if ! use elibc_glibc ; then
		mozconfig_add_options_ac '!elibc_glibc' --disable-jemalloc
	elif ! use jemalloc ; then
		mozconfig_add_options_ac '-jemalloc' --disable-jemalloc
	else
		mozconfig_add_options_ac '+jemalloc' --enable-jemalloc
	fi

	if use valgrind ; then
		mozconfig_add_options_ac 'valgrind requirement' --disable-jemalloc
	fi

	# Allow elfhack to work in combination with unstripped binaries
	# when they would normally be larger than 2GiB.
	append-ldflags "-Wl,--compress-debug-sections=zlib"

	# Make revdep-rebuild.sh happy; Also required for musl
	append-ldflags -Wl,-rpath="${MOZILLA_FIVE_HOME}",--enable-new-dtags

	# Pass $MAKEOPTS to build system
	export MOZ_MAKE_FLAGS="${MAKEOPTS}"

	# Use system's Python environment
	export PIP_NETWORK_INSTALL_RESTRICTED_VIRTUALENVS=mach

	if use system-python-libs; then
		export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE="system"
	else
		export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE="none"
	fi

	if ! use telemetry; then
		mozconfig_add_options_mk '-telemetry setting' "MOZ_CRASHREPORTER=0"
		mozconfig_add_options_mk '-telemetry setting' "MOZ_DATA_REPORTING=0"
		mozconfig_add_options_mk '-telemetry setting' "MOZ_SERVICES_HEALTHREPORT=0"
		mozconfig_add_options_mk '-telemetry setting' "MOZ_TELEMETRY_REPORTING=0"
	fi

	# Disable notification when build system has finished
	export MOZ_NOSPAM=1

	# Portage sets XARGS environment variable to "xargs -r" by default which
	# breaks build system's check_prog() function which doesn't support
	# arguments
	mozconfig_add_options_ac \
		'Gentoo default' \
		"XARGS=${EPREFIX}/usr/bin/xargs"

	# Set build dir
	mozconfig_add_options_mk \
		'Gentoo default' \
		"MOZ_OBJDIR=${BUILD_OBJ_DIR}"


einfo "Cross-compile ABI:\t\t${ABI}"
einfo "Cross-compile CFLAGS:\t${CFLAGS}"
einfo "Cross-compile CC:\t\t${CC}"
einfo "Cross-compile CXX:\t\t${CXX}"
	echo "export PKG_CONFIG=${CHOST}-pkg-config" \
		>>${MOZCONFIG}
	echo "export PKG_CONFIG_PATH=/usr/$(get_libdir)/pkgconfig:/usr/share/pkgconfig" \
		>>${MOZCONFIG}

	# Show flags we will use
einfo "Build BINDGEN_CFLAGS:\t${BINDGEN_CFLAGS:-no value set}"
einfo "Build CFLAGS:\t\t${CFLAGS:-no value set}"
einfo "Build CXXFLAGS:\t\t${CXXFLAGS:-no value set}"
einfo "Build LDFLAGS:\t\t${LDFLAGS:-no value set}"
einfo "Build RUSTFLAGS:\t\t${RUSTFLAGS:-no value set}"

	# Handle EXTRA_CONF and show summary
	local ac opt hash reason

	# Apply EXTRA_ECONF entries to $MOZCONFIG
	if [[ -n ${EXTRA_ECONF} ]] ; then
		IFS=\! read -a ac <<<${EXTRA_ECONF// --/\!}
		for opt in "${ac[@]}"; do
			mozconfig_add_options_ac "EXTRA_ECONF" --${opt#--}
		done
	fi

	echo
	echo "=========================================================="
	echo "Building ${PF} with the following configuration"
	grep ^ac_add_options "${MOZCONFIG}" | \
	while read ac opt hash reason; do
		[[ -z ${hash} || ${hash} == \# ]] \
			|| die "error reading mozconfig: ${ac} ${opt} ${hash} ${reason}"
		printf "    %-30s  %s\n" "${opt}" "${reason:-mozilla.org default}"
	done
	echo "=========================================================="
	echo

	if use valgrind; then
		sed -i -e 's/--enable-optimize=-O[0-9s]/--enable-optimize="-g -O2"/' .mozconfig || die
	fi

	./mach configure || die
}

_src_compile() {
	local s=$(_get_s)
	cd "${s}" || die

	local CDEFAULT=$(get_abi_CHOST ${DEFAULT_ABI})
	_fix_paths
	local virtx_cmd=

	if use pgo ; then
	# Reset and cleanup environment variables used by GNOME/XDG
		gnome2_environment_reset

		addpredict /root

		if ! use X; then
			virtx_cmd=virtwl
		else
			virtx_cmd=virtx
		fi
	fi

	if ! use X && use wayland; then
		local -x GDK_BACKEND=wayland
	else
		local -x GDK_BACKEND=x11
	fi

	${virtx_cmd} ./mach build --verbose || die
}

src_compile() {
	compile_abi() {
		uopts_src_compile
	}
	multilib_foreach_abi compile_abi
}

# @FUNCTION: _install_licenses
# @DESCRIPTION:
# Installs licenses and copyright notices from third party rust cargo
# packages and other internal packages.
_install_licenses() {
	[[ "${EBUILD_MAINTAINER_MODE}" == "1" ]] && return
	lcnr_install_files

	lcnr_install_header \
		"modules/fdlibm/src/math_private.h" \
		"SunPro.LICENSE" \
		10
	lcnr_install_header \
		"js/src/tests/test262/built-ins/RegExp/S15.10.2_A1_T1.js" \
		"S15.10.2_A1_T1.js.LICENSE" \
		17
	lcnr_install_header \
		"testing/web-platform/tests/css/tools/w3ctestlib/catalog/xhtml11.dtd" \
		"xhtml11.dtd.LICENSE" \
		27

	# Duped because of must not alter clause
	lcnr_install_header \
		"gfx/sfntly/cpp/src/test/tinyxml/tinyxml.cpp" \
		"tinyxml.LICENSE1" \
		23
	lcnr_install_header \
		"gfx/sfntly/cpp/src/test/tinyxml/tinyxmlerror.cpp" \
		"tinyxml.LICENSE2" \
		23
	lcnr_install_header \
		"gfx/sfntly/cpp/src/test/tinyxml/tinyxml.h" \
		"tinyxml.LICENSE3" \
		23
	lcnr_install_header \
		"gfx/sfntly/cpp/src/test/tinyxml/tinystr.cpp" \
		"tinyxml.LICENSE4" \
		22

	lcnr_install_header \
		"third_party/msgpack/include/msgpack/predef/compiler/ibm.h" \
		"ibm.h.copyright_notice" \
		6

	lcnr_install_header \
		"media/ffvpx/libavutil/adler32.c" \
		"adler32.c.LICENSE" \
		22

	lcnr_install_header \
		"js/src/octane/box2d.js" \
		"box2d.LICENSE" \
		19

	lcnr_install_header \
		"devtools/client/shared/vendor/jszip.js" \
		"jszip.js.LICENSE1" \
		11
	lcnr_install_mid \
		"devtools/client/shared/vendor/jszip.js" \
		"jszip.js.LICENSE2" \
		5689 \
		18

	# Duped because of must not alter clause
	for f in $(grep -r -l -F -e "origin of this software" \
		media/libjpeg) ; do
		lcnr_install_header \
			$(echo "${f}" | sed -e "s|^./||g") \
			$(basename "${f}")".LICENSE" \
			32
	done

	lcnr_install_header \
		"mfbt/Span.h" \
		"Span.h.LICENSE" \
		15

	lcnr_install_header \
		"media/openmax_dl/dl/api/omxtypes.h" \
		"omxtypes.h.LICENSE" \
		31

	lcnr_install_header \
		"devtools/client/shared/widgets/CubicBezierWidget.js" \
		"CubicBezierWidget.js.LICENSE" \
		21

	lcnr_install_header \
		"netwerk/dns/nsIDNKitInterface.h" \
		"nsIDNKitInterface.h.LICENSE" \
		41

	lcnr_install_header \
		"gfx/qcms/qcms.h" \
		"qcms.h.LICENSE" \
		41

	touch "${T}/.copied_licenses"
}

_src_install() {
	local s=$(_get_s)
	cd "${s}" || die
	local CDEFAULT=$(get_abi_CHOST ${DEFAULT_ABI})
	_fix_paths
	# xpcshell is getting called during install
	pax-mark m \
		"${BUILD_OBJ_DIR}/dist/bin/xpcshell" \
		"${BUILD_OBJ_DIR}/dist/bin/${PN}" \
		"${BUILD_OBJ_DIR}/dist/bin/plugin-container"

	DESTDIR="${D}" ./mach install || die

	# Upstream cannot ship symlink but we can (bmo#658850)
	rm "${ED}${MOZILLA_FIVE_HOME}/${PN}-bin" || die
	dosym "${PN}" "${MOZILLA_FIVE_HOME}/${PN}-bin"

	# Don't install llvm-symbolizer from sys-devel/llvm package
	if [[ -f "${ED}${MOZILLA_FIVE_HOME}/llvm-symbolizer" ]] ; then
		rm -v "${ED}${MOZILLA_FIVE_HOME}/llvm-symbolizer" || die
	fi

	# Install policy (currently only used to disable application updates)
	insinto "${MOZILLA_FIVE_HOME}/distribution"
	newins "${FILESDIR}/distribution.ini" "distribution.ini"
	newins "${FILESDIR}/disable-auto-update.policy.json" "policies.json"

	# Install system-wide preferences
	local PREFS_DIR="${MOZILLA_FIVE_HOME}/browser/defaults/preferences"
	insinto "${PREFS_DIR}"
	newins "${FILESDIR}/gentoo-default-prefs.js" "gentoo-prefs.js"

	local GENTOO_PREFS="${ED}${PREFS_DIR}/gentoo-prefs.js"

	# Set dictionary path to use system hunspell
cat >>"${GENTOO_PREFS}" <<-EOF || die "Failed to set spellchecker.dictionary_path pref"
pref("spellchecker.dictionary_path",       "${EPREFIX}/usr/share/myspell");
EOF

	# Force hwaccel prefs if USE=hwaccel is enabled
	if use hwaccel ; then
		cat "${FILESDIR}/gentoo-hwaccel-prefs.js-r2" \
		>>"${GENTOO_PREFS}" \
|| die "failed to add prefs to force hardware-accelerated rendering to all-gentoo.js"

		if use wayland; then
cat >>"${GENTOO_PREFS}" <<-EOF || die "Failed to set hwaccel wayland prefs"
pref("gfx.x11-egl.force-enabled",          false);
EOF
		else
cat >>"${GENTOO_PREFS}" <<-EOF || die "Failed to set hwaccel x11 prefs"
pref("gfx.x11-egl.force-enabled",          true);
EOF
		fi
	fi

	if ! use gmp-autoupdate ; then
		local plugin
		for plugin in "${MOZ_GMP_PLUGIN_LIST[@]}" ; do
einfo "Disabling auto-update for ${plugin} plugin ..."
cat >>"${GENTOO_PREFS}" <<-EOF || \
die "failed to disable autoupdate for ${plugin} media plugin"
pref("media.${plugin}.autoupdate",   false);
EOF
		done
	fi

	# Force the graphite pref if USE=system-harfbuzz is enabled, since the
	# pref cannot disable it
	if use system-harfbuzz ; then
cat >>"${GENTOO_PREFS}" <<-EOF || \
die "failed to set gfx.font_rendering.graphite.enabled pref"
sticky_pref("gfx.font_rendering.graphite.enabled", true);
EOF
	fi

	# Install language packs
	local langpacks=(
		$(find "${WORKDIR}/language_packs" -type f -name '*.xpi')
	)
	if [[ -n "${langpacks}" ]] ; then
		moz_install_xpi \
			"${MOZILLA_FIVE_HOME}/distribution/extensions" \
			"${langpacks[@]}"
	fi

	# Install geckodriver
	if use geckodriver ; then
einfo "Installing geckodriver into ${ED}${MOZILLA_FIVE_HOME} ..."
		pax-mark m "${BUILD_OBJ_DIR}/dist/bin/geckodriver"
		exeinto "${MOZILLA_FIVE_HOME}"
		doexe "${BUILD_OBJ_DIR}/dist/bin/geckodriver"

		dosym "${MOZILLA_FIVE_HOME}/geckodriver" "/usr/bin/geckodriver"
	fi

	# Install icons
	local icon_srcdir="${s}/browser/branding/official"
	local icon_symbolic_file="${FILESDIR}/icon/firefox-symbolic.svg"

	insinto /usr/share/icons/hicolor/symbolic/apps
	newins "${icon_symbolic_file}" "${PN}-symbolic.svg"

	local icon size
	for icon in "${icon_srcdir}/default"*".png" ; do
		size=${icon%.png}
		size=${size##*/default}

		if [[ ${size} -eq 48 ]] ; then
			newicon "${icon}" "${PN}.png"
		fi

		newicon -s ${size} "${icon}" "${PN}.png"
	done

	# Install menu
	local app_name="Mozilla ${MOZ_PN^} (${ABI})"
	local desktop_file="${FILESDIR}/icon/${PN}-r3.desktop"
	local desktop_filename="${PN}-${ABI}.desktop"
	local exec_command="${PN}-${ABI}"
	local icon="${PN}"
	local use_wayland="false"

	if use wayland ; then
		use_wayland="true"
	fi

	cp "${desktop_file}" "${WORKDIR}/${PN}.desktop-template" || die

	sed -i \
		-e "s:@NAME@:${app_name}:" \
		-e "s:@EXEC@:${exec_command}:" \
		-e "s:@ICON@:${icon}:" \
		"${WORKDIR}/${PN}.desktop-template" \
		|| die

	newmenu "${WORKDIR}/${PN}.desktop-template" "${desktop_filename}"

	rm "${WORKDIR}/${PN}.desktop-template" || die

	# Install wrapper script
	[[ -f "${ED}/usr/bin/${PN}" ]] && rm "${ED}/usr/bin/${PN}"
	newbin "${FILESDIR}/extra-patches/${PN}-r1.sh" "${PN}-${ABI}"
	dosym "/usr/bin/${PN}-${ABI}" "/usr/bin/${PN}"

	# Update wrapper
	sed -i \
		-e "s:@PREFIX@:${EPREFIX}/usr:" \
		-e "s:@LIBDIR@:$(get_libdir):" \
		-e "s:@MOZ_FIVE_HOME@:${MOZILLA_FIVE_HOME}:" \
		-e "s:@APULSELIB_DIR@:${apulselib}:" \
		-e "s:@DEFAULT_WAYLAND@:${use_wayland}:" \
		"${ED}/usr/bin/${PN}-${ABI}" \
		|| die
	_install_licenses
	uopts_src_install
}

src_install() {
	install_abi() {
		_src_install
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
}

pkg_preinst() {
	xdg_pkg_preinst

	# If the apulse libs are available in MOZILLA_FIVE_HOME then apulse
	# does not need to be forced into the LD_LIBRARY_PATH
	if use pulseaudio && has_version ">=media-sound/apulse-0.1.12-r4" ; then
einfo "APULSE found; Generating library symlinks for sound support ..."
		local lib
		pushd "${ED}${MOZILLA_FIVE_HOME}" &>/dev/null || die
			for lib in ../apulse/libpulse{.so{,.0},-simple.so{,.0}} ; do
	# A quickpkg rolled by hand will grab symlinks as part of the package,
	# so we need to avoid creating them if they already exist.
				if [[ ! -L "${lib##*/}" ]] ; then
					ln -s "${lib}" "${lib##*/}" || die
				fi
			done
		popd &>/dev/null || die
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	if ! use gmp-autoupdate ; then
einfo
einfo "USE='-gmp-autoupdate' has disabled the following plugins from updating or"
einfo "installing into new profiles:"
einfo
		local plugin
		for plugin in "${MOZ_GMP_PLUGIN_LIST[@]}" ; do
einfo "\t ${plugin}"
		done
einfo
	fi

	if use pulseaudio && has_version ">=media-sound/apulse-0.1.12-r4" ; then
einfo
einfo "Apulse was detected at merge time on this system and so it will always be"
einfo "used for sound.  If you wish to use pulseaudio instead please unmerge"
einfo "media-sound/apulse."
einfo
	fi

	local show_doh_information
	local show_normandy_information
	local show_shortcut_information

	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
	# New install; Tell user that DoH is disabled by default
		show_doh_information=yes
		show_normandy_information=yes
		show_shortcut_information=no
	else
		local replacing_version
		for replacing_version in ${REPLACING_VERSIONS} ; do
			if ver_test "${replacing_version}" -lt 91.0 ; then
	# Tell user that we no longer install a shortcut per supported display
	# protocol
				show_shortcut_information=yes
			fi
		done
	fi

	if [[ -n "${show_doh_information}" ]] ; then
ewarn
ewarn "Note regarding Trusted Recursive Resolver aka DNS-over-HTTPS (DoH):"
ewarn "Due to privacy concerns (encrypting DNS might be a good thing, sending"
ewarn "all DNS traffic to Cloudflare by default is not a good idea and"
ewarn "applications should respect OS configured settings), \"network.trr.mode\""
ewarn "was set to 5 (\"Off by choice\") by default."
ewarn "You can enable DNS-over-HTTPS in ${PN^}'s preferences."
ewarn
	fi

	# Bug 713782
	if [[ -n "${show_normandy_information}" ]] ; then
ewarn
ewarn "Upstream operates a service named Normandy which allows Mozilla to"
ewarn "push changes for default settings or even install new add-ons remotely."
ewarn "While this can be useful to address problems like 'Armagadd-on 2.0' or"
ewarn "revert previous decisions to disable TLS 1.0/1.1, privacy and security"
ewarn "concerns prevail, which is why we have switched off the use of this"
ewarn "service by default."
ewarn
ewarn "To re-enable this service set"
ewarn
ewarn "    app.normandy.enabled=true"
ewarn
ewarn "in about:config."
ewarn
	fi

	if [[ -n "${show_shortcut_information}" ]] ; then
einfo
einfo "Since ${PN}-91.0 we no longer install multiple shortcuts for"
einfo "each supported display protocol.  Instead we will only install"
einfo "one generic Mozilla ${PN^} shortcut."
einfo "If you still want to be able to select between running Mozilla ${PN^}"
einfo "on X11 or Wayland, you have to re-create these shortcuts on your own."
einfo
	fi

	# Bug 835078
	if use hwaccel && has_version "x11-drivers/xf86-video-nouveau"; then
ewarn
ewarn "You have nouveau drivers installed in your system and 'hwaccel' enabled"
ewarn "for Firefox. Nouveau or your GPU might not support the required EGL, so"
ewarn "either disable 'hwaccel' or try the workaround explained in"
ewarn "https://bugs.gentoo.org/835078#c5 if Firefox crashes."
ewarn
	fi

ewarn
ewarn "Unfortunately Firefox-100.0 breaks compatibility with some sites using"
ewarn "useragent checks. To temporarily fix this, modify about:config with"
ewarn
ewarn "  network.http.useragent.forceVersion preference=\"99\","
ewarn
ewarn "or"
ewarn
ewarn "  install an addon to change your useragent."
ewarn
ewarn "See"
ewarn
ewarn "  https://support.mozilla.org/en-US/kb/difficulties-opening-or-using-website-firefox-100"
ewarn

einfo
einfo "By default, the /usr/bin/firefox symlink is set to the last ABI"
einfo "installed.  You must change it manually if you want to run on a"
einfo "different default ABI."
einfo
einfo "Examples"
einfo "ln -sf /usr/lib64/${PN}/${PN} /usr/bin/firefox"
einfo "ln -sf /usr/lib/${PN}/${PN} /usr/bin/firefox"
einfo "ln -sf /usr/lib32/${PN}/${PN} /usr/bin/firefox"
einfo
	# The FPS problem is gone in the -bin package
	uopts_pkg_postinst

	if ! use hwaccel ; then
ewarn
ewarn "You must manually enable \"Use hardware acceleration when available\""
ewarn "for smoother scrolling and >= 25 FPS video playback."
ewarn
ewarn "For details, see https://support.mozilla.org/en-US/kb/performance-settings"
ewarn
	fi

	if use libcanberra ; then
		if has_version "media-libs/libcanberra[-sound]" ; then
ewarn
ewarn "You need a sound theme to hear notifications."
ewarn "The default one can be installed with media-libs/libcanberra[sound]"
ewarn
		fi
	fi

	if use X \
		&& ( \
			   has_version "x11-drivers/xf86-video-amdgpu" \
			|| has_version "x11-drivers/xf86-video-ati" \
			|| has_version "x11-drivers/xf86-video-intel" \
		) ; then
ewarn
ewarn "The following changes are required for /etc/X11/xorg.conf or"
ewarn "/etc/X11/xorg.conf.d/* for reduction or elimination of tearing"
ewarn "(aka split frames) during video playback."
ewarn
ewarn "Section \"Device\""
ewarn "        Identifier  \"...\""
ewarn "        Driver      \"...\""
ewarn "        Option      \"TearFree\"                  \"true\""
ewarn "EndSection"
ewarn
	fi

	if [[ "${OFLAG}" =~ "-Ofast" ]] ; then
ewarn
ewarn "Not all use cases for -Ofast have been tested.  Please send an issue"
ewarn "request to the oiledmachine-overlay describing the bug, steps to"
ewarn "reproduce bug, and the website."
ewarn
ewarn "If a bug has been observed with -Ofast, you may also downgrade to -O3."
ewarn
	fi

	if ! has_version "sys-libs/glibc"; then
ewarn
ewarn "glibc not found! You won't be able to play DRM content."
ewarn "See Gentoo bug #910309 or upstream bug #1843683."
ewarn
	fi
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  ebuild, new-patches
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multiabi, license-completness, license-transparency
# OILEDMACHINE-OVERLAY-TEST:  PASS (INTERACTIVE) 113.0.1 (May 15, 2023)
# USE="X dav1d dbus eme-free jemalloc jumbo-build libcanberra opus
# proprietary-codecs-disable-nc-user pulseaudio speech system-ffmpeg vaapi vpx
# wayland webspeech -aac -alsa -cups (-debug) -ebolt -ffvpx -geckodriver
# -gmp-autoupdate -h264 -hardened -hwaccel -jack -libproxy -libsecret -mold
# -openh264 -pgo -proprietary-codecs -proprietary-codecs-disable
# -proprietary-codecs-disable-nc-developer -screencast (-selinux) -sndio
# -system-av1 -system-harfbuzz -system-icu -system-jpeg -system-libevent
# -system-libvpx -system-png (-system-python-libs) -system-webp (-telemetry)
# -webrtc -wifi"
# L10N="-ach -af -an -ar -ast -az -be -bg -bn -br -bs -ca -ca-valencia -cak -cs
# -cy -da -de -dsb -el -en-CA -en-GB -eo -es-AR -es-CL -es-ES -es-MX -et -eu -fa
# -ff -fi -fr -fur -fy -ga -gd -gl -gn -gu -he -hi -hr -hsb -hu -hy -ia -id -is
# -it -ja -ka -kab -kk -km -kn -ko -lij -lt -lv -mk -mr -ms -my -nb -ne -nl -nn
# -oc -pa -pl -pt-BR -pt-PT -rm -ro -ru -sc -sco -si -sk -sl -son -sq -sr -sv
# -szl -ta -te -th -tl -tr -trs -uk -ur -uz -vi -xh -zh-CN -zh-TW"
# Last build timestamp - 116:59.03 (first run)
# CFLAGS: -O2 -pipe (PASS [interactive testing])
# CFLAGS: -Ofast -pipe (PASS [interactive testing])
# OILEDMACHINE-OVERLAY-TEST-TOOLCHAIN:
#   rust 1.69.0
#   gcc 12.2.1_p20230428-r1
#   sccache 0.3.0
#   gold/binutils - 2.39-r5
# OILEDMACHINE-OVERLAY-TEST-RESULTS:
#   browsing - pass
#   video on demand - pass
#     dav1d - pass
#     video/avc (H.264) - expected fail
#   audio streaming
#     mp3 (shoutcast v1) - pass with random fails
#     aac - expected fail
#   audio on demand
#     mp3 - pass
#     aac - expected fail
#     wav - pass/fail - only one sample played
#  WebGL Aquarium - pass, ~62 FPS
#  CanvasMark 2013 - passed
#  GPU Shader Experiments (https://www.kevs3d.co.uk/dev/shaders) - passed, randomly selected
# TODO: retest with aac USE flag on

# = Ebuild fork checklist =
# Bump to latest release every week
# Update *DEPENDs with MULTILIB_USEDEP
# Update *patches
#  Test patches
# Bump gentoo-hwaccel-prefs.js-r2 if changed
# Diff compare ebuilds and code review
# Keep within the 80 character boundary
