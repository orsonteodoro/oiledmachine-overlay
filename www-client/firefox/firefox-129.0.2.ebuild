# Copyright 2022-2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# 127.0.1 -> 129.0.2

# Originally based on the firefox-89.0.ebuild from the gentoo-overlay,
# with update sync updated to this version of the ebuild.
# Revisions may change in the oiledmachine-overlay.

# Version announcements can be found here also:
# https://wiki.mozilla.org/Release_Management/Calendar

#
# For dependencies versioning, files listed other than moz.configure have a
# higher weight than the moz.configure file.
#
# For dependency versioning, see also
# https://firefox-source-docs.mozilla.org/setup/linux_build.html
# https://www.mozilla.org/en-US/firefox/129.0.2/system-requirements/
# /var/tmp/portage/www-client/firefox-129.0.2/work/firefox-129.0.2/moz.configure
# /var/tmp/portage/www-client/firefox-129.0.2/work/firefox-129.0.2/dom/media/platforms/ffmpeg//FFmpegRuntimeLinker.cpp L41 [y component in x.y.z subslot in ebuild.  >= n0.8 for 53]
# /var/tmp/portage/www-client/firefox-129.0.2/work/firefox-129.0.2/build/moz.configure/nss.configure L12
# /var/tmp/portage/www-client/firefox-129.0.2/work/firefox-129.0.2/gfx/graphite2/include/graphite2/Font.h L31
# /var/tmp/portage/www-client/firefox-129.0.2/work/firefox-129.0.2/gfx/harfbuzz/configure.ac L3
# /var/tmp/portage/www-client/firefox-129.0.2/work/firefox-129.0.2/intl/icu/source/common/unicode/uvernum.h L63
# /var/tmp/portage/www-client/firefox-129.0.2/work/firefox-129.0.2/ipc/chromium/src/third_party/libevent/configure.ac L8
# /var/tmp/portage/www-client/firefox-129.0.2/work/firefox-129.0.2/media/libaom/config/aom_version.h L7 [old]
# /var/tmp/portage/www-client/firefox-129.0.2/work/firefox-129.0.2/media/libjpeg/jconfig.h L7
# /var/tmp/portage/www-client/firefox-129.0.2/work/firefox-129.0.2/media/libpng/png.h L281
# /var/tmp/portage/www-client/firefox-129.0.2/work/firefox-129.0.2/media/libvpx/config/vpx_version.h L8
# /var/tmp/portage/www-client/firefox-129.0.2/work/firefox-129.0.2/media/libwebp/moz.yaml L16
# /var/tmp/portage/www-client/firefox-129.0.2/work/firefox-129.0.2/modules/freetype2/include/freetype/freetype.h L5223
# /var/tmp/portage/www-client/firefox-129.0.2/work/firefox-129.0.2/nsprpub/pr/include/prinit.h L35
# /var/tmp/portage/www-client/firefox-129.0.2/work/firefox-129.0.2/third_party/dav1d/meson.build L26
# /var/tmp/portage/www-client/firefox-129.0.2/work/firefox-129.0.2/third_party/pipewire/pipewire/version.h L49
# /var/tmp/portage/www-client/firefox-129.0.2/work/firefox-129.0.2/taskcluster/kinds/fetch/toolchains.yml
#   Keyword searches:  cbindgen-, llvm-, pkgconf-, rust-
# /var/tmp/portage/www-client/firefox-129.0.2/work/firefox-129.0.2/taskcluster/kinds/packages/
#   Keyword search:  gtk
# /var/tmp/portage/www-client/firefox-129.0.2/work/firefox-129.0.2/taskcluster/kinds/toolchain/
#   Keyword search:  nasm, nodejs, zlib

# Track http://ftp.mozilla.org/pub/firefox/releases/ for version updates.
# For security advisories, see https://www.mozilla.org/en-US/security/advisories/

# The latest release version can be found with:
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

# To check every minor version or update MOZ_LANGS use the code below:
__='
PV="129.0.2"
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

__='
# For dependency versions, scan also with:
SRC="/var/tmp/portage/www-client/firefox-129.0.2/work/firefox-129.0.2"
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
#   Keyword search:  aom, dbus, fontconfig, pango, perl, pixman, xkbcommon, xrandr

APPLY_OILEDMACHINE_OVERLAY_PATCHSET="0"
BUILD_OBJ_DIR="" # global var not const
DBUS_PV="0.60"
# One of the major sources of lag comes from dependencies.  These are strict to
# match performance to competition or normal builds.
declare -A CFLAGS_RDEPEND=(
	["media-libs/dav1d"]=">=;-O2" # -O0 skippy, -O1 faster but blurry, -Os blurry still, -O2 not blurry
	["media-libs/libvpx"]=">=;-O1" # -O0 causes FPS to lag below 25 FPS.
)
EBUILD_MAINTAINER_MODE=0
FFMPEG_COMPAT=(
	"0/59.61.61" # 7.0
	"0/58.60.60" # 6.0
	"0/57.59.59" # 5.0
	"0/56.58.58" # 4.0
	"0/55.57.57" # 3.0
	"0/54.56.56" # 2.4
	"0/52.55.55" # 2.0
	"0/52.54.54" # 1.1, 1.2
	"0/51.54.54" # 0.11, 1.0
	"0/51.53.53" # 0.10
	"0/50.53.53" # 0.8
)
FIREFOX_PATCHSET="firefox-${PV%%.*}-patches-02.tar.xz"
GAPI_KEY_MD5="709560c02f94b41f9ad2c49207be6c54"
GLOCATIONAPI_KEY_MD5="ffb7895e35dedf832eb1c5d420ac7420"
GTK3_PV="3.14.5"
LICENSE_FILE_NAME="FF-$(ver_cut 1-2 ${PV})-THIRD-PARTY-LICENSES.html"
LICENSE_FINGERPRINT="\
5f4a4f2092ef8c400e625fe4becb533420375298e7fc5b577ac954896348f44f\
514cec962cc574ba62390b266fef34b73a2f3cba805e61d83a0996f95a130989\
" # SHA512
LLVM_COMPAT=( 18 ) # Limited based on virtual/rust
LTO_TYPE="" # Global variable
MAPI_KEY_MD5="3927726e9442a8e8fa0e46ccc39caa27"
MITIGATION_DATE="Aug 6, 2024"
MITIGATION_LAST_UPDATE=1722927600 # From `date +%s -d "2024-08-06"` date from last mitigation date
MITIGATION_URI="https://www.mozilla.org/en-US/security/advisories/mfsa2024-33/"
MOZ_ESR=
MOZ_LANGS=(
ach af an ar ast az be bg bn br bs ca-valencia ca cak cs cy da de dsb el en-CA
en-GB en-US eo es-AR es-CL es-ES es-MX et eu fa ff fi fr fur fy-NL ga-IE gd gl
gn gu-IN he hi-IN hr hsb hu hy-AM ia id is it ja ka kab kk km kn ko lij lt lv
mk mr ms my nb-NO ne-NP nl nn-NO oc pa-IN pl pt-BR pt-PT rm ro ru sat sc sco si
sk skr sl son sq sr sv-SE szl ta te tg th tl tr trs uk ur uz vi xh zh-CN zh-TW
)

MOZ_PV="${PV}"
MOZ_PV_SUFFIX=
if [[ "${PV}" =~ (_(alpha|beta|rc).*)$ ]] ; then
	MOZ_PV_SUFFIX=${BASH_REMATCH[1]}

	# Convert the ebuild version to the upstream Mozilla version
	MOZ_PV="${MOZ_PV/_alpha/a}" # Handle alpha for SRC_URI
	MOZ_PV="${MOZ_PV/_beta/b}"  # Handle beta for SRC_URI
	MOZ_PV="${MOZ_PV%%_rc*}"    # Handle rc for SRC_URI
fi
if [[ -n "${MOZ_ESR}" ]] ; then
	# ESR releases have slightly different version numbers
	MOZ_PV="${MOZ_PV}esr"
	HOMEPAGE="https://www.mozilla.com/firefox https://www.mozilla.org/firefox/enterprise/"
	SLOT="esr"
else
	HOMEPAGE="https://www.mozilla.com/firefox"
	SLOT="rapid"
fi
MOZ_PN="${PN%-bin}"
MOZ_P="${MOZ_PN}-${MOZ_PV}"
MOZ_PV_DISTFILES="${MOZ_PV}${MOZ_PV_SUFFIX}"
MOZ_P_DISTFILES="${MOZ_PN}-${MOZ_PV_DISTFILES}"
MOZILLA_FIVE_HOME="" # Global variable
NABIS=0 # Global variable
NASM_PV="2.14.02"
NODE_VERSION=18
OFLAG="" # Global variable
PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="ncurses,sqlite,ssl"
RUST_PV="1.79.0"
SPEECH_DISPATCHER_PV="0.11.4-r1"
UOPTS_SUPPORT_EBOLT=1
UOPTS_SUPPORT_EPGO=0 # Recheck if allowed
UOPTS_SUPPORT_TBOLT=0
UOPTS_SUPPORT_TPGO=0
WANT_AUTOCONF="2.1"
XKBCOMMON_PV="0.4.1"
VIRTUALX_REQUIRED="pgo"

inherit autotools cflags-depends check-linker check-reqs desktop flag-o-matic
inherit gnome2-utils lcnr linux-info llvm multilib-minimal multiprocessing
inherit pax-utils python-any-r1 readme.gentoo-r1 rust-toolchain toolchain-funcs
inherit uopts virtualx xdg

KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
S="${WORKDIR}/${PN}-${PV%_*}"
S_BAK="${WORKDIR}/${PN}-${PV%_*}"
if [[ "${PV}" == *"_rc"* ]] ; then
	MOZ_SRC_BASE_URI="https://archive.mozilla.org/pub/${MOZ_PN}/candidates/${MOZ_PV}-candidates/build${PV##*_rc}"
else
	MOZ_SRC_BASE_URI="https://archive.mozilla.org/pub/${MOZ_PN}/releases/${MOZ_PV}"
fi
PATCH_URIS=(
	https://dev.gentoo.org/~juippis/mozilla/patchsets/${FIREFOX_PATCHSET}
)
SRC_URI="
	${MOZ_SRC_BASE_URI}/source/${MOZ_P}.source.tar.xz -> ${MOZ_P_DISTFILES}.source.tar.xz
	${PATCH_URIS[@]}
"

DESCRIPTION="Firefox Web Browser"
HOMEPAGE="https://www.mozilla.com/firefox"
# llvm_gen_dep is broken for ${MULTILIB_USEDEP} if inserted directly.
RESTRICT="mirror"
SLOT="rapid"
LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
# MPL-2.0 is the mostly used and default
# FF-XX.YY-THIRD-PARTY-LICENSES should be updated per new feature or if the \
# fingerprint changes.
# Update the license version also.
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
			GPL-2
			MIT
		)
		BSD-2
		BSD
		LGPL-2.1
		|| (
			GPL-2+
			LGPL-2.1+
			MPL-1.1
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
	unicode
	Unicode-DFS-2016
	UoI-NCSA
	ZLIB
	pgo? (
		(
			(
				all-rights-reserved
				|| (
					AFL-2.1
					MIT
				)
			)
			(
				GPL-2
				MIT
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
		GPL-2+
		LGPL-2.1+
		MPL-1.1
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
# Distro enables telemetry by default.
IUSE+="
${CODEC_IUSE}
${LLVM_COMPAT[@]/#/llvm_slot_}
alsa cpu_flags_arm_neon cups +dbus debug eme-free +ffvpx +hardened -hwaccel jack
-jemalloc +jumbo-build libcanberra libnotify libproxy libsecret mold +openh264
+pgo +pulseaudio proprietary-codecs proprietary-codecs-disable
proprietary-codecs-disable-nc-developer proprietary-codecs-disable-nc-user selinux sndio
speech +system-av1 +system-ffmpeg +system-harfbuzz +system-icu
+system-jpeg +system-libevent +system-libvpx system-png +system-webp systemd -telemetry
+vaapi -valgrind +wayland +webrtc wifi webspeech
"
# telemetry disabled for crypto/security reasons

# Firefox-only IUSE
IUSE+="
+gmp-autoupdate screencast +X
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
	^^ (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
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

FF_ONLY_DEPEND="
	!www-client/firefox:0
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
		systemd? (
			>=sys-apps/systemd-217[${MULTILIB_USEDEP}]
		)
		!systemd? (
			>=sys-apps/systemd-utils-217[${MULTILIB_USEDEP},udev]
		)
	)
"

gen_ffmpeg_cdepend0() {
	local s
	for s in ${FFMPEG_COMPAT} ; do
		echo "
			media-video/ffmpeg:${s}[${MULTILIB_USEDEP},dav1d?,opus?,vaapi?,vpx?]
		"
	done
}

gen_ffmpeg_cdepend1() {
	local s
	for s in ${FFMPEG_COMPAT} ; do
		echo "
			(
				!<dev-libs/openssl-3
				media-video/ffmpeg:${s}[${MULTILIB_USEDEP},-amr,-cuda,dav1d?,-fdk,-kvazaar,-openh264,openssl,opus?,proprietary-codecs-disable,vaapi?,vpx?,-x264,-x265,-xvid]
			)
			(
				media-video/ffmpeg:${s}[${MULTILIB_USEDEP},-amr,-cuda,dav1d?,-fdk,-kvazaar,-openh264,-openssl,opus?,proprietary-codecs-disable,vaapi?,vpx?,-x264,-x265,-xvid]
			)
		"
	done
}

gen_ffmpeg_cdepend2() {
	local s
	for s in ${FFMPEG_COMPAT} ; do
		echo "
			(
				!<dev-libs/openssl-3
				media-video/ffmpeg:${s}[${MULTILIB_USEDEP},-amr,-cuda,dav1d?,-fdk,-kvazaar,-openh264,openssl,opus?,proprietary-codecs-disable-nc-developer,vaapi?,vpx?,-x264,-x265,-xvid]
			)
			(
				media-video/ffmpeg:${s}[${MULTILIB_USEDEP},-amr,-cuda,dav1d?,-fdk,-kvazaar,-openh264,-openssl,opus?,proprietary-codecs-disable-nc-developer,vaapi?,vpx?,-x264,-x265,-xvid]
			)
		"
	done
}

gen_ffmpeg_cdepend3() {
	local s
	for s in ${FFMPEG_COMPAT} ; do
		echo "
			(
				!<dev-libs/openssl-3
				media-video/ffmpeg:${s}[${MULTILIB_USEDEP},-amr,-cuda,dav1d?,-fdk,-kvazaar,-openh264,openssl,opus?,proprietary-codecs-disable-nc-user,vaapi?,vpx?,-x264,-x265,-xvid]
			)
			(
				media-video/ffmpeg:${s}[${MULTILIB_USEDEP},-amr,-cuda,dav1d?,-fdk,-kvazaar,-openh264,-openssl,opus?,proprietary-codecs-disable-nc-user,vaapi?,vpx?,-x264,-x265,-xvid]
			)
		"
	done
}

# x86_64 will use ffvpx and system-ffmpeg but others will use system-ffmpeg
NON_FREE_CDEPENDS="
	proprietary-codecs? (
		media-libs/mesa[${MULTILIB_USEDEP},proprietary-codecs]
		system-ffmpeg? (
			|| (
				$(gen_ffmpeg_cdepend0)
			)
		)
		vaapi? (
			media-libs/vaapi-drivers[${MULTILIB_USEDEP}]
		)
	)
	proprietary-codecs-disable? (
		media-libs/mesa[${MULTILIB_USEDEP},-proprietary-codecs]
		system-ffmpeg? (
			|| (
				$(gen_ffmpeg_cdepend1)
			)
		)
	)
	proprietary-codecs-disable-nc-developer? (
		media-libs/mesa[${MULTILIB_USEDEP},-proprietary-codecs]
		system-ffmpeg? (
			|| (
				$(gen_ffmpeg_cdepend2)
			)
		)
	)
	proprietary-codecs-disable-nc-user? (
		media-libs/mesa[${MULTILIB_USEDEP},-proprietary-codecs]
		system-ffmpeg? (
			|| (
				$(gen_ffmpeg_cdepend3)
			)
		)
	)
"
# ZLIB relaxed
CDEPEND="
	${FF_ONLY_DEPEND}
	${NON_FREE_CDEPENDS}
	>=app-accessibility/at-spi2-core-2.46.0:2[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.42:2[${MULTILIB_USEDEP}]
	>=dev-libs/nss-3.102[${MULTILIB_USEDEP}]
	>=dev-libs/nspr-4.35[${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.7.0[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.13.2[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.3.1[${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.22.0[${MULTILIB_USEDEP}]
	>=x11-libs/pixman-0.40.0[${MULTILIB_USEDEP}]
	dev-libs/expat[${MULTILIB_USEDEP}]
	dev-libs/libffi:=[${MULTILIB_USEDEP}]
	media-libs/alsa-lib[${MULTILIB_USEDEP}]
	virtual/freedesktop-icon-theme
	x11-libs/cairo[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf:2[${MULTILIB_USEDEP}]
	dbus? (
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
	system-av1? (
		>=media-libs/dav1d-1.4.2:=[${MULTILIB_USEDEP},8bit]
		>=media-libs/libaom-1.0.0:=[${MULTILIB_USEDEP}]
	)
	system-harfbuzz? (
		>=media-gfx/graphite2-1.3.14[${MULTILIB_USEDEP}]
		>=media-libs/harfbuzz-9.0.0:0=[${MULTILIB_USEDEP}]
	)
	system-icu? (
		>=dev-libs/icu-73.1:=[${MULTILIB_USEDEP}]
	)
	system-jpeg? (
		>=media-libs/libjpeg-turbo-3.0.3[${MULTILIB_USEDEP}]
		media-libs/libjpeg-turbo:=
	)
	system-libevent? (
		>=dev-libs/libevent-2.1.12:0=[${MULTILIB_USEDEP},threads(+)]
	)
	system-libvpx? (
		>=media-libs/libvpx-1.14.1:0=[${MULTILIB_USEDEP},postproc]
	)
	system-png? (
		>=media-libs/libpng-1.6.43:0=[${MULTILIB_USEDEP},apng]
	)
	system-webp? (
		>=media-libs/libwebp-1.4.0:0=[${MULTILIB_USEDEP}]
	)
	valgrind? (
		dev-debug/valgrind
	)
	wayland? (
		>=media-libs/libepoxy-1.5.10-r1[${MULTILIB_USEDEP}]
		>=x11-libs/gtk+-${GTK3_PV}:3[${MULTILIB_USEDEP},wayland]
		>=x11-libs/libdrm-2.4[${MULTILIB_USEDEP}]
	)
	wifi? (
		kernel_linux? (
			|| (
				>=net-misc/networkmanager-0.7[${MULTILIB_USEDEP}]
				net-misc/connman[networkmanager]
			)
			>=sys-apps/dbus-${DBUS_PV}[${MULTILIB_USEDEP}]
		)
	)
	X? (
		>=x11-libs/gtk+-${GTK3_PV}:3[${MULTILIB_USEDEP},X]
		>=x11-libs/libXrandr-1.4.0[${MULTILIB_USEDEP}]
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
	libnotify? (
		x11-libs/libnotify
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

# ESR and rapid dependencies.
if [[ -n ${MOZ_ESR} ]] ; then
	RDEPEND+=" !www-client/firefox:rapid"
else
	RDEPEND+=" !www-client/firefox:esr"
fi

gen_llvm_bdepend() {
	local LLVM_SLOT
	for LLVM_SLOT in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${LLVM_SLOT}? (
				sys-devel/clang:${LLVM_SLOT}[${MULTILIB_USEDEP}]
				sys-devel/lld:${LLVM_SLOT}
				sys-devel/llvm:${LLVM_SLOT}[${MULTILIB_USEDEP}]
				virtual/rust:0/llvm-${LLVM_SLOT}
				pgo? (
					=sys-libs/compiler-rt-sanitizers-${LLVM_SLOT}*:=[${MULTILIB_USEDEP},profile]
				)
			)
		"
	done
}
BDEPEND+="
	$(gen_llvm_bdepend)
	${GAMEPAD_BDEPEND}
	${PYTHON_DEPS}
	=net-libs/nodejs-${NODE_VERSION}*
	>=dev-lang/perl-5.006
	>=dev-util/cbindgen-0.26.0
	>=dev-util/pkgconf-1.8.0[${MULTILIB_USEDEP},pkg-config(+)]
	app-alternatives/awk
	app-arch/unzip
	app-arch/zip
	app-eselect/eselect-nodejs
	!elibc_glibc? (
		dev-lang/rust[${MULTILIB_USEDEP}]
	)
	amd64? (
		>=dev-lang/nasm-${NASM_PV}
	)
	elibc_glibc? (
		>=virtual/rust-${RUST_PV}[${MULTILIB_USEDEP}]
	)
	mold? (
		sys-devel/mold
	)
	pgo? (
		wayland? (
			|| (
				gui-wm/tinywl
				<gui-libs/wlroots-0.17.3[tinywl(-)]
			)
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
"
PDEPEND+="
	screencast? (
		>=media-video/pipewire-0.3.52[${MULTILIB_USEDEP}]
		sys-apps/xdg-desktop-portal
	)
"

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
einfo "=sys-libs/compiler-rt-sanitizers-${LLVM_SLOT}* is missing! Cannot" >&2
einfo "use LLVM slot ${LLVM_SLOT} ..." >&2
				return 1
			fi
		fi
	fi

einfo "Using LLVM slot ${LLVM_SLOT} to build" >&2
}

mozilla_set_globals() {
	# https://bugs.gentoo.org/587334
	local MOZ_TOO_REGIONALIZED_FOR_L10N=(
		"fy-NL"
		"ga-IE"
		"gu-IN"
		"hi-IN"
		"hy-AM"
		"nb-NO"
		"ne-NP"
		"nn-NO"
		"pa-IN"
		"sv-SE"
	)

	local lang
	local xflag
	for lang in "${MOZ_LANGS[@]}" ; do
		if [[ "${lang}" == "en" || "${lang}" == "en-US" ]] ; then
	# Both are handled internally
			continue
		fi

	# Strip region subtag if $lang is in the list
		if has "${lang}" "${MOZ_TOO_REGIONALIZED_FOR_L10N[@]}" ; then
			xflag="${lang%%-*}"
		else
			xflag="${lang}"
		fi

		SRC_URI+="
			l10n_${xflag/[_@]/-}? (
				${MOZ_SRC_BASE_URI}/linux-x86_64/xpi/${lang}.xpi
					-> ${MOZ_P_DISTFILES}-${lang}.xpi
			)
		"
		IUSE+=" l10n_${xflag/[_@]/-}"
	done
}
mozilla_set_globals

moz_clear_vendor_checksums() {
	debug-print-function "${FUNCNAME}" "$@"

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
	debug-print-function "${FUNCNAME}" "$@"

	if (( ${#} < 2 )) ; then
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
	debug-print-function "${FUNCNAME}" "$@"

	if (( ${#} < 2 )) ; then
		die "${FUNCNAME} requires at least two arguments"
	fi

	local reason="${1}"
	shift

	local option
	for option in ${@} ; do
		echo "ac_add_options ${option} # ${reason}" >>${MOZCONFIG}
	done
}

mozconfig_add_options_mk() {
	debug-print-function "${FUNCNAME}" "$@"

	if (( ${#} < 2 )) ; then
		die "${FUNCNAME} requires at least two arguments"
	fi

	local reason="${1}"
	shift

	local option
	for option in ${@} ; do
		echo "mk_add_options ${option} # ${reason}" >>${MOZCONFIG}
	done
}

mozconfig_use_enable() {
	debug-print-function "${FUNCNAME}" "$@"

	if (( ${#} < 1 )) ; then
		die "${FUNCNAME} requires at least one arguments"
	fi

	local flag=$(use_enable "${@}")
	local t=$(use ${1} && echo +${1} || echo -${1})
	mozconfig_add_options_ac "${t}" "${flag}"
}

mozconfig_use_with() {
	debug-print-function "${FUNCNAME}" "$@"

	if (( ${#} < 1 )) ; then
		die "${FUNCNAME} requires at least one arguments"
	fi

	local flag=$(use_with "${@}")
	local t=$(use ${1} && echo +${1} || echo -${1})
	mozconfig_add_options_ac "${t}" "${flag}"
}

virtwl() {
	debug-print-function "${FUNCNAME}" "$@"

	(( ${#} < 1 )) && die "${FUNCNAME} needs at least one argument"
	if [[ -z "${XDG_RUNTIME_DIR}" ]] ; then
eerror
eerror "${FUNCNAME} needs XDG_RUNTIME_DIR to be set; try xdg_environment_reset"
eerror
		die
	fi
	tinywl -h >/dev/null || die 'tinywl -h failed'

	local VIRTWL
	local VIRTWL_PID
	coproc VIRTWL { \
		WLR_BACKENDS="headless" \
		exec tinywl -s 'echo $WAYLAND_DISPLAY; read _; kill $PPID'; \
	}
	local -x WAYLAND_DISPLAY
	read WAYLAND_DISPLAY <&${VIRTWL[0]}

	debug-print "${FUNCNAME}: $@"
	"$@"
	local r=${?}

	[[ -n "$VIRTWL_PID" ]] || die "tinywl exited unexpectedly"
	exec {VIRTWL[0]}<&- {VIRTWL[1]}>&-
	return ${r}
}

pkg_pretend() {
	if [[ "${MERGE_TYPE}" != "binary" ]] ; then
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
		:
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

# @FUNCTION: node_pkg_setup
# @DESCRIPTION:
# Checks node slot required for building
node_pkg_setup() {
	local found=0
	local slot
	local node_pv=$(node --version \
		| sed -e "s|v||g")
	if [[ -n "${NODE_SLOTS}" ]] ; then
		for slot in ${NODE_SLOTS} ; do
			if has_version "=net-libs/nodejs-${slot}*" \
				&& (( ${node_pv%%.*} == ${slot} )) ; then
				export NODE_VERSION=${slot}
				found=1
				break
			fi
		done
		if (( ${found} == 0 )) ; then
eerror
eerror "Did not find the preferred nodejs slot."
eerror "Expected node versions:  ${NODE_SLOTS}"
eerror
eerror "Try one of the following:"
eerror
			local s
			for s in ${NODE_SLOTS} ; do
eerror "  eselect nodejs set node${s}"
			done

eerror
eerror "See eselect nodejs for more details."
eerror
			die
		fi
	elif [[ -n "${NODE_VERSION}" ]] ; then
		if has_version "=net-libs/nodejs-${NODE_VERSION}*" \
			&& (( ${node_pv%%.*} == ${NODE_VERSION} )) ; then
			found=1
		fi
		if (( ${found} == 0 )) ; then
eerror
eerror "Did not find the preferred nodejs slot."
eerror "Expected node version:  ${NODE_VERSION}"
eerror
eerror "Try the following:"
eerror
eerror "  eselect nodejs set node$(ver_cut 1 ${NODE_VERSION})"
eerror
eerror "See eselect nodejs for more details."
eerror
			die
		fi
	fi
}

pkg_setup() {
einfo "Release type:  rapid"
	if [[ -n "${MITIGATION_URI}" ]] ; then
einfo "Security announcement date:  ${MITIGATION_DATE}"
einfo "Security vulnerabilities fixed:  ${MITIGATION_URI}"
	fi
	if [[ "${MERGE_TYPE}" != "binary" ]] ; then
		if use pgo ; then
			if ! has userpriv ${FEATURES} ; then
ewarn "Building ${PN} with USE=pgo and FEATURES=-userpriv is not supported!"
			fi
		fi

	# Ensure we have enough disk space to compile
		if use pgo || is-flagq '-flto*' || use debug ; then
			CHECKREQS_DISK_BUILD="13500M"
		else
			CHECKREQS_DISK_BUILD="6400M"
		fi

		check-reqs_pkg_setup

		local s
		for s in ${LLVM_COMPAT[@]} ; do
			if use "llvm_slot_${s}" ; then
				LLVM_MAX_SLOT="${s}"
				break
			fi
		done
		llvm_pkg_setup

		if tc-is-clang && is-flagq '-flto*' && tc-ld-is-lld ; then
			has_version "sys-devel/lld:$(clang-major-version)" \
				|| die "Clang PGO requires LLD."
			local lld_pv=$(ld.lld --version 2>/dev/null \
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

			local llvm_rust_pv=$(rustc -Vv 2>/dev/null \
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
		addpredict "/proc/self/oom_score_adj"

		if use pgo ; then
	# Update 105.0: "/proc/self/oom_score_adj" isn't enough anymore with
	# pgo, but not sure whether that's due to better OOM handling by Firefox
	# (bmo#1771712), or portage (PORTAGE_SCHEDULING_POLICY) update...
			addpredict "/proc"

	# Clear tons of conditions, since PGO is hardware-dependant.
			addpredict /dev
		fi

		if ! mountpoint -q "/dev/shm" ; then
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
ewarn "Microphone support may be disabled when USE=-pulseaudio."
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
ewarn "Using sccache may randomly fail.  Retry if it fails."
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
ewarn "Speech recognition (USE=webspeech) has not been confirmed working."
	fi
	verify_codecs
	node_pkg_setup
	check_security_expire
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
einfo "Verifying about:license fingerprint"
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

drop_patch() {
	local path="${1}"
ewarn "Dropping broken ${path} because patchset is either already applied or the patchset has not been updated."
	rm -rf "${path}"
}

_eapply_oiledmachine_set() {
	local path="${1}"
	if [[ "${APPLY_OILEDMACHINE_OVERLAY_PATCHSET:-1}" == "1" ]] ; then
		eapply "${path}"
	fi
}

check_security_expire() {
	local _30_days=$((60*60*24*30))
	local _14_days=$((60*60*24*14))
	local _day=$((60*60*24))
	local _hour=$((60*60))
	local _minute=60
	local now=$(date +%s)
	local t
	t=$((${now} - ${MITIGATION_LAST_UPDATE})) # Seconds elapsed
	local days_passed=$(( ${t} / ${_day} ))
	local hours_passed=$(( ${t} % ${_day} ))
	t=${hours_passed}
	hours_passed=$(( ${t} / ${_hour} ))
	local minutes_passed=$(( ${t} % ${_hour} ))
	t=${minutes_passed}
	minutes_passed=$(( ${t} / ${_minute} ))
	local seconds_passed=$(( ${t} % ${_minute} ))
	local dhms_passed="${days_passed} days, ${hours_passed} hrs, ${minutes_passed} mins, ${seconds_passed} secs"
	if (( ${now} > ${MITIGATION_LAST_UPDATE} + ${_30_days} )) ; then
eerror
eerror "This ebuild release period is past 30 days since release."
eerror "It is considered insecure.  As a precaution, this particular point"
eerror "release will not install."
eerror
eerror "Time passed since the last security update:  ${dhms_passed}"
eerror
eerror "Solutions:"
eerror
eerror "1.  Use a newer rapid release from the overlay."
eerror "2.  Use the latest rapid distro release."
eerror "3.  Use the latest www-client/firefox-bin release, temporarily."
eerror
		die
	elif (( ${now} > ${MITIGATION_LAST_UPDATE} + ${_14_days} )) ; then
ewarn
ewarn "This ebuild is more than 2 weeks old and may have a vulnerability."
ewarn "Please consider a newer release."
ewarn
ewarn "Suggestions:"
ewarn
ewarn "1.  Use a newer rapid release from the overlay."
ewarn "2.  Use the latest rapid distro release."
ewarn "3.  Use the latest www-client/firefox-bin release, temporarily."
ewarn
ewarn "Days past last security annoucement:  ${days_passed}"
ewarn "Time passed since the last security update:  ${dhms_passed}"
ewarn
	else
einfo "Time passed since the last security update:  ${dhms_passed}"
	fi
}

src_prepare() {
	if is-flagq '-flto*' ; then
		rm -fv "${WORKDIR}/firefox-patches/"*"-LTO-Only-enable-LTO-"*".patch"
	fi

	# Workaround for bgo#917599
	if has_version ">=dev-libs/icu-74.1" && use system-icu ; then
		eapply "${WORKDIR}/firefox-patches/"*"-bmo-1862601-system-icu-74.patch"
	fi
	rm -v "${WORKDIR}/firefox-patches/"*"-bmo-1862601-system-icu-74.patch" || die

	# Workaround for bgo#915651 on musl
	if use elibc_glibc ; then
		rm -v "${WORKDIR}/firefox-patches/"*"bgo-748849-RUST_TARGET_override.patch" || die
	fi

	if [[ "${APPLY_OILEDMACHINE_OVERLAY_PATCHSET:-1}" != "1" ]] ; then
ewarn "The oiledmachine-overlay patchset is not ready.  Skipping."
	fi

	eapply "${WORKDIR}/firefox-patches"
	_eapply_oiledmachine_set "${FILESDIR}/extra-patches/${PN}-122.0-disallow-store-data-races.patch"

	# Flicker prevention with -Ofast
	_eapply_oiledmachine_set "${FILESDIR}/extra-patches/${PN}-106.0.2-disable-broken-flags-gfx-layers.patch"

	# Prevent YT stall prevention with clang with -Ofast.
	# Prevent audio perma mute with gcc with -Ofast.
	_eapply_oiledmachine_set "${FILESDIR}/extra-patches/${PN}-122.0-disable-broken-flags-js.patch"

	# Only partial patching was done because the distro doesn't support
	# multilib Python.  Only native ABI is supported.  This means cbindgen
	# cannot load the 32-bit clang.  It will build the cargo parts.  When it
	# links it, it fails because of cbindings is 64-bit and the dependencies
	# use the build information for 64-bit linking, which should be 32-bit.

	# Allow to use system-ffmpeg completely.
	_eapply_oiledmachine_set "${FILESDIR}/extra-patches/${PN}-127-allow-ffmpeg-decode-av1.patch"
	_eapply_oiledmachine_set "${FILESDIR}/extra-patches/${PN}-125-disable-ffvpx.patch"

	# Prevent tab crash
	_eapply_oiledmachine_set "${FILESDIR}/extra-patches/${PN}-106.0.2-disable-broken-flags-dom-bindings.patch"

	# Prevent video seek bug
	_eapply_oiledmachine_set "${FILESDIR}/extra-patches/${PN}-122.0-disable-broken-flags-ipc-chromium-chromium-config.patch"

	# Allow user to apply any additional patches without modifing ebuild
	eapply_user

	# Make cargo respect MAKEOPTS
	export CARGO_BUILD_JOBS="$(makeopts_jobs)"

	# Workaround for bgo#915651
	if ! use elibc_glibc ; then
		if use amd64 ; then
			export RUST_TARGET="x86_64-unknown-linux-musl"
		elif use x86 ; then
			export RUST_TARGET="x86-unknown-linux-musl"
		elif use arm64 ; then
			export RUST_TARGET="aarch64-unknown-linux-musl"
		elif use ppc64 ; then
			export RUST_TARGET="powerpc64le-unknown-linux-musl"
		else
			die "Unknown musl chost, please post your rustc -vV along with emerge --info on Gentoo's bug #915651"
		fi
	fi

	# Make LTO respect MAKEOPTS
	# Make ICU respect MAKEOPTS
	# Respect MAKEOPTS all around (maybe some find+sed is better)
	sed -i \
		-e "s/multiprocessing.cpu_count()/$(makeopts_jobs)/" \
		"${S}/build/moz.configure/lto-pgo.configure" \
		"${S}/intl/icu_sources_data.py" \
		"${S}/python/mozbuild/mozbuild/base.py" \
		"${S}/third_party/libwebrtc/build/toolchain/get_cpu_count.py" \
		"${S}/third_party/libwebrtc/build/toolchain/get_concurrent_links.py" \
		"${S}/third_party/python/gyp/pylib/gyp/input.py" \
		"${S}/python/mozbuild/mozbuild/code_analysis/mach_commands.py" \
		|| die "Failed sedding multiprocessing.cpu_count"

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
	find \
		"${S}/third_party" \
		-type f \
		\( \
			   -name '*.so' \
			-o -name '*.o' \
		\) \
		-print -delete \
		|| die

	# Clear checksums from cargo crates we've manually patched.
	# moz_clear_vendor_checksums xyz

	# Respect choice for "jumbo-build"
	# Changing the value for FILES_PER_UNIFIED_FILE may not work, see #905431
	if [[ -n "${FILES_PER_UNIFIED_FILE}" ]] && use jumbo-build ; then
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
		local CDEFAULT=$(get_abi_CHOST "${DEFAULT_ABI}")
	# Only ${CDEFAULT}-objdump exists because in true multilib.
	# Logically speaking, there should be i686-pc-linux-gnu-objdump also.
		if [[ -e "${ESYSROOT}/usr/bin/${CHOST}-objdump" ]] ; then
	# Adds the toolchain prefix.
			sed -i \
				-e "s/\"objdump/\"${CHOST}-objdump/" \
				"python/mozbuild/mozbuild/configure/check_debug_ranges.py" \
				|| die "sed failed to set toolchain prefix"
einfo "Using ${CHOST}-objdump for CHOST"
		else
			[[ -e "${ESYSROOT}/usr/bin/${CDEFAULT}-objdump" ]] || die
	# Adds the toolchain prefix.
			sed -i \
				-e "s/\"objdump/\"${CDEFAULT}-objdump/" \
				"python/mozbuild/mozbuild/configure/check_debug_ranges.py" \
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
	export PKG_CONFIG="${CHOST}-pkg-config"
	export CARGO_CFG_TARGET_ARCH=$(echo "${CHOST}" \
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
		if [[ -n "${version_clang}" ]] ; then
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

_set_cc() {
	local have_switched_compiler=
	if tc-is-clang || use jumbo-build ; then
	# The logic is inverted in the commit below.
	# https://gitweb.gentoo.org/repo/gentoo.git/commit/www-client/firefox?id=bbf20ce6d62985723c948f5dcb5d0d23b975ac01

	# Force clang
einfo "Switching to clang"
		local version_clang=$(clang --version 2>/dev/null \
			| grep -F -- 'clang version' \
			| awk '{ print $3 }')
		if [[ -n "${version_clang}" ]] ; then
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
ewarn "GCC is not the upstream default"
		# Force gcc
		have_switched_compiler="yes"
einfo "Switching to gcc"
		AR="gcc-ar"
		CC="${CHOST}-gcc"
		CXX="${CHOST}-g++"
		NM="gcc-nm"
		RANLIB="gcc-ranlib"
	fi
	if [[ -n "${have_switched_compiler}" ]] ; then
	# Because we switched active compiler we have to ensure that no
	# unsupported flags are set
		strip-unsupported-flags
	fi
}

_src_configure_compiler() {
	_set_cc
}

src_configure() { :; }

_src_configure() {
	local s=$(_get_s)
	cd "${s}" || die

	local CDEFAULT=$(get_abi_CHOST "${DEFAULT_ABI}")
	# Show flags set at the beginning
einfo
einfo "Current BINDGEN_CFLAGS:\t${BINDGEN_CFLAGS:-no value set}"
einfo "Current CFLAGS:\t\t${CFLAGS:-no value set}"
einfo "Current CXXFLAGS:\t\t${CXXFLAGS:-no value set}"
einfo "Current LDFLAGS:\t\t${LDFLAGS:-no value set}"
einfo "Current RUSTFLAGS:\t\t${RUSTFLAGS:-no value set}"
einfo "Cross-compile CHOST:\t\t${CHOST}"
einfo

	_set_cc

	uopts_src_configure
	check_speech_dispatcher

	# Ensure we use correct toolchain
	export HOST_CC="$(tc-getBUILD_CC)"
	export HOST_CXX="$(tc-getBUILD_CXX)"

	# Configuration tests expect llvm-readelf output, bug 913130
	READELF="llvm-readelf"

	tc-export CC CXX LD AR NM OBJDUMP RANLIB READELF PKG_CONFIG
	_fix_paths
	# Pass the correct toolchain paths through cbindgen
	if tc-is-cross-compiler ; then
		export BINDGEN_CFLAGS="
			${SYSROOT:+--sysroot=${ESYSROOT}}
			--host=${CDEFAULT}
			--target=${CHOST}
			${BINDGEN_CFLAGS-}
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
	mozconfig_add_options_ac '' --enable-application="browser"
	mozconfig_add_options_ac '' --enable-project="browser"

	# Set distro defaults
	if use telemetry; then
		export MOZILLA_OFFICIAL=1
	fi

	mozconfig_add_options_ac \
		'Gentoo default' \
		--allow-addon-sideload \
		--disable-cargo-incremental \
		--disable-crashreporter \
		--disable-disk-remnant-avoidance \
		--disable-geckodriver \
		--disable-gpsd \
		--disable-install-strip \
		--disable-legacy-profile-creation \
		--disable-parental-controls \
		--disable-strip \
		--disable-tests \
		--disable-updater \
		--disable-wasm-function-references \
		--disable-wasm-gc \
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
		--with-unsigned-addon-scopes="app,system" \
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
		:
	elif use ffvpx ; then
		mozconfig_add_options_ac \
			'ffvpx=default' \
			--with-ffvpx="default"
	else
		mozconfig_add_options_ac \
			'ffvpx=no' \
			--with-ffvpx="no"
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

	if ! use x86 ; then
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

	# The upstream default is hardening on even if unset.
	if use hardened ; then
		mozconfig_add_options_ac "+hardened" --enable-hardening
		append-ldflags "-Wl,-z,relro -Wl,-z,now" # Full Relro

		# Increase the FORTIFY_SOURCE value, #910071.
		sed \
			-i \
			-e '/-D_FORTIFY_SOURCE=/s:2:3:' \
			"${S}/build/moz.configure/toolchain.configure" \
			|| die
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
			--enable-default-toolkit="cairo-gtk3-x11-wayland"
	elif ! use X && use wayland ; then
		mozconfig_add_options_ac \
			'+wayland' \
			--enable-default-toolkit="cairo-gtk3-wayland-only"
	else
		mozconfig_add_options_ac \
			'+x11' \
			--enable-default-toolkit="cairo-gtk3"
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

	# Upstream only supports lld or mold when using clang.
	if [[ "${LTO_TYPE}" =~ ("bfdlto"|"moldlto"|"thinlto") ]]
	then
	# Mold for gcc works for non-lto but for lto it is likely WIP.
		if tc-is-clang && [[ "${LTO_TYPE}" == "moldlto" ]] ; then
	# Mold expects the -flto line from *FLAGS configuration, bgo#923119
			filter-flags '-flto*'
			append-flags '-flto'
			mozconfig_add_options_ac \
				"forcing ld=mold" \
				--enable-linker="mold"

			mozconfig_add_options_ac \
				'+lto' \
				--enable-lto="cross"

		elif tc-is-clang && [[ "${LTO_TYPE}" == "thinlto" ]] ; then
	# Upstream only supports lld when using clang
			mozconfig_add_options_ac \
				"forcing ld=lld" \
				--enable-linker="lld"

			mozconfig_add_options_ac \
				'+lto' \
				--enable-lto="cross"

		else
	# ThinLTO is currently broken, see bmo#1644409
			mozconfig_add_options_ac \
				'+lto' \
				--enable-lto="full"
			mozconfig_add_options_ac \
				"linker is set to bfd" \
				--enable-linker="bfd"
		fi

		if use pgo ; then
			mozconfig_add_options_ac '+pgo' MOZ_PGO=1

			if tc-is-clang ; then
				# Used in build/pgo/profileserver.py
				export LLVM_PROFDATA="llvm-profdata"
			fi
		fi
	else
		if tc-is-clang && is-flagq '-fuse-ld=mold' || use mold ; then
			filter-flags '-flto*'
			append-flags '-flto'
			mozconfig_add_options_ac \
				"forcing ld=mold" \
				--enable-linker="mold"
		elif tc-is-clang && has_version "sys-devel/lld:$(clang-major-version)" ; then
	# This is upstream's default
			mozconfig_add_options_ac \
				"forcing ld=lld" \
				--enable-linker="lld"
		else
			mozconfig_add_options_ac \
				"linker is set to bfd" \
				--enable-linker="bfd"
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
		mozconfig_add_options_ac '+debug' --enable-jemalloc
		mozconfig_add_options_ac '+debug' --enable-real-time-tracing
	else
		mozconfig_add_options_ac \
			'Gentoo defaults' \
			--disable-real-time-tracing

		if is-flag '-g*' ; then
			if use clang ; then
				mozconfig_add_options_ac 'from CFLAGS' --enable-debug-symbols=$(get-flag '-g*')
			else
				mozconfig_add_options_ac 'from CFLAGS' --enable-debug-symbols
			fi
		else
			mozconfig_add_options_ac 'Gentoo default' --disable-debug-symbols
		fi

		if [[ "${APPLY_OILEDMACHINE_OVERLAY_PATCHSET:-1}" != "1" ]] ; then
ewarn "APPLY_OILEDMACHINE_OVERLAY_PATCHSET is currently disabled."
			if is_flagq_last '-Ofast' ; then
ewarn "-Ofast -> -O3"
				OFLAG="-O3"
			fi
ewarn "-ffast-math is removed"
			filter-flags '-ffast-math'
		fi

		if is_flagq_last '-Ofast' || [[ "${OFLAG}" == "-Ofast" ]] ; then
			OFLAG="-Ofast"
			mozconfig_add_options_ac \
				"from CFLAGS" \
				--enable-optimize="-Ofast"
		elif is_flagq_last '-O4' || [[ "${OFLAG}" == "-O4" ]] ; then
	# O4 is the same as O3.
			OFLAG="-O4"
			mozconfig_add_options_ac \
				"from CFLAGS" \
				--enable-optimize="-O4"
		elif is_flagq_last '-O3' || [[ "${OFLAG}" == "-O3" ]] ; then
	# Repeated for multiple Oflags
			OFLAG="-O3"
			mozconfig_add_options_ac \
				"from CFLAGS" \
				--enable-optimize="-O3"
		elif is_flagq_last '-O2' || [[ "${OFLAG}" == "-O2" ]] ; then
			OFLAG="-O2"
			mozconfig_add_options_ac \
				"from CFLAGS" \
				--enable-optimize="-O2"
		else
			OFLAG="-O3"
			mozconfig_add_options_ac \
				"Upstream default" \
				--enable-optimize="-O3"
		fi
einfo "Using ${OFLAG}"
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

	if [[ "${APPLY_OILEDMACHINE_OVERLAY_PATCHSET:-1}" == "1" ]] ; then
		local f
		for f in ${L[@]} ; do
einfo "Editing ${f}:  __OFLAG_SAFE__ -> ${oflag_safe}"
			sed -i -e "s|__OFLAG_SAFE__|${oflag_safe}|g" \
				"${f}" \
				|| die
		done
	fi

	# Debug flag was handled via configure
	filter-flags '-g*'

	# Optimization flag was handled via configure
	filter-flags '-O*'

	if [[ "${APPLY_OILEDMACHINE_OVERLAY_PATCHSET:-1}" != "1" ]] ; then
		:
	elif is-flagq '-ffast-math' || [[ "${OFLAG}" == "-Ofast" ]] ; then
		local pos=$(grep -n "#define OPUS_DEFINES_H" \
			"${s}/media/libopus/include/opus_defines.h" \
			| cut -f 1 -d ":")
		sed -i -e "${pos}a#define FLOAT_APPROX 1" \
			"${s}/media/libopus/include/opus_defines.h" || die
	fi

	# elf-hack
	# Filter "-z,pack-relative-relocs" and let the build system handle it instead.
	if use amd64 || use x86 ; then
		filter-flags "-z,pack-relative-relocs"
		if tc-ld-is-mold ; then
			# relr-elf-hack is currently broken with mold, bgo#916259
			mozconfig_add_options_ac 'disable elf-hack with mold linker' --disable-elf-hack
		else
			mozconfig_add_options_ac 'relr elf-hack with clang' --enable-elf-hack=relr
		fi
	elif use ppc64 || use riscv ; then
		# '--disable-elf-hack' is not recognized on ppc64/riscv.
		# See bgo #917049, #930046.
		:
	else
		mozconfig_add_options_ac 'disable elf-hack on non-supported arches' --disable-elf-hack
	fi

	if ( is_flagq_last "-O3" || is_flagq_last "-Ofast" ) \
		&& tc-is-gcc \
		&& ver_test $(gcc-fullversion) -lt "11.3.0" ; then
ewarn
ewarn "GCC version detected:\t$(gcc-fullversion)"
ewarn "Expected version:\t>= 11.3"
ewarn
ewarn "The detected version is untested and may result in userscript failure."
ewarn "Use GCC >= 11.3 or Clang to prevent this bug."
ewarn
	fi

	# Use the O(1) algorithm linker algorithm and add more swap instead.
ewarn "Add more swap space if linker causes an out of memory (OOM) condition."

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
	export PIP_NETWORK_INSTALL_RESTRICTED_VIRTUALENVS="mach"

	export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE="none"

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
		>>"${MOZCONFIG}"
	echo "export PKG_CONFIG_PATH=/usr/$(get_libdir)/pkgconfig:/usr/share/pkgconfig" \
		>>"${MOZCONFIG}"

	# Show flags we will use
einfo "Build BINDGEN_CFLAGS:\t${BINDGEN_CFLAGS:-no value set}"
einfo "Build CFLAGS:\t\t${CFLAGS:-no value set}"
einfo "Build CXXFLAGS:\t\t${CXXFLAGS:-no value set}"
einfo "Build LDFLAGS:\t\t${LDFLAGS:-no value set}"
einfo "Build RUSTFLAGS:\t\t${RUSTFLAGS:-no value set}"

	# Handle EXTRA_CONF and show summary
	local ac opt hash reason

	# Apply EXTRA_ECONF entries to $MOZCONFIG
	if [[ -n "${EXTRA_ECONF}" ]] ; then
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
		[[ -z "${hash}" || "${hash}" == \# ]] \
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

	local CDEFAULT=$(get_abi_CHOST "${DEFAULT_ABI}")
	_fix_paths
	local virtx_cmd=

	if use pgo ; then
	# Reset and cleanup environment variables used by GNOME/XDG
		gnome2_environment_reset

		addpredict "/root"

		if ! use X; then
			virtx_cmd="virtwl"
		else
			virtx_cmd="virtx"
		fi
	fi

	if ! use X && use wayland; then
		local -x GDK_BACKEND="wayland"
	else
		local -x GDK_BACKEND="x11"
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
	local CDEFAULT=$(get_abi_CHOST "${DEFAULT_ABI}")
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
pref("spellchecker.dictionary_path", "${EPREFIX}/usr/share/myspell");
EOF

	# Force hwaccel prefs if USE=hwaccel is enabled
	if use hwaccel ; then
		cat "${FILESDIR}/gentoo-hwaccel-prefs.js-r2" \
		>>"${GENTOO_PREFS}" \
|| die "failed to add prefs to force hardware-accelerated rendering to all-gentoo.js"

		if use wayland; then
cat >>"${GENTOO_PREFS}" <<-EOF || die "Failed to set hwaccel wayland prefs"
pref("gfx.x11-egl.force-enabled", false);
EOF
		else
cat >>"${GENTOO_PREFS}" <<-EOF || die "Failed to set hwaccel x11 prefs"
pref("gfx.x11-egl.force-enabled", true);
EOF
		fi

		# Install the vaapitest binary on supported arches (+arm when keyworded)
		exeinto "${MOZILLA_FIVE_HOME}"
		doexe "${BUILD_DIR}"/dist/bin/vaapitest

		# Install the v4l2test on supported arches (+ arm, + riscv64 when keyworded)
		if use arm64 ; then
			exeinto "${MOZILLA_FIVE_HOME}"
			doexe "${BUILD_DIR}"/dist/bin/v4l2test
		fi
	fi

	if ! use gmp-autoupdate ; then
		local plugin
		for plugin in "${MOZ_GMP_PLUGIN_LIST[@]}" ; do
einfo "Disabling auto-update for ${plugin} plugin ..."
cat >>"${GENTOO_PREFS}" <<-EOF || \
die "failed to disable autoupdate for ${plugin} media plugin"
pref("media.${plugin}.autoupdate", false);
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

	# Add telemetry config prefs, just in case something happens in future and telemetry build
	# options stop working.
	if ! use telemetry ; then
		cat >>"${GENTOO_PREFS}" <<-EOF || die "failed to set telemetry prefs"
		sticky_pref("toolkit.telemetry.dap_enabled", false);
		pref("toolkit.telemetry.dap_helper", "");
		pref("toolkit.telemetry.dap_leader", "");
		EOF
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
	local desktop_filename
	local exec_command="${PN}-${ABI}"
	local icon="${PN}"
	local use_wayland="false"

	if use wayland ; then
		use_wayland="true"
	fi

	if [[ -n "${MOZ_ESR}" ]] ; then
		local desktop_filename="${PN}-esr.desktop"
	else
		local desktop_filename="${PN}.desktop"
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

	# Install search provider for Gnome
	insinto "/usr/share/gnome-shell/search-providers/"
	doins "browser/components/shell/search-provider-files/org.mozilla.firefox.search-provider.ini"

	insinto "/usr/share/dbus-1/services/"
	doins "browser/components/shell/search-provider-files/org.mozilla.firefox.SearchProvider.service"

	sed \
		-i \
		-e "s/firefox.desktop/${desktop_filename}/g" \
		"${ED}/usr/share/gnome-shell/search-providers/org.mozilla.firefox.search-provider.ini" \
		|| die "Failed to sed search-provider file."

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
	readme.gentoo_create_doc
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
			for lib in "../apulse/libpulse"{".so"{"",".0"},"-simple.so"{"",".0"}} ; do
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
		show_doh_information="yes"
		show_normandy_information="yes"
		show_shortcut_information="no"
	else
		local replacing_version
		for replacing_version in ${REPLACING_VERSIONS} ; do
			if ver_test "${replacing_version}" -lt "91.0" ; then
	# Tell user that we no longer install a shortcut per supported display
	# protocol
				show_shortcut_information="yes"
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

	readme.gentoo_print_elog

	optfeature_header "Optional programs for extra features:"
	optfeature "desktop notifications" "x11-libs/libnotify"
	optfeature "fallback mouse cursor theme e.g. on WMs" "gnome-base/gsettings-desktop-schemas"
	optfeature "screencasting with pipewire" "sys-apps/xdg-desktop-portal"
	if use hwaccel && has_version "x11-drivers/nvidia-drivers" ; then
		optfeature "hardware acceleration with NVIDIA cards" "media-libs/nvidia-vaapi-driver"
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
