# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
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

# Version announcements can be found here also:
# https://wiki.mozilla.org/Release_Management/Calendar


FIREFOX_PATCHSET="firefox-106-patches-02j.tar.xz"

LLVM_MAX_SLOT=13 # >= 14 causes build time failures with atomics

PYTHON_COMPAT=( python3_{8..11} )
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
	https://dev.gentoo.org/~{juippis,polynomial-c,whissi,slashbeast}/mozilla/patchsets/${FIREFOX_PATCHSET}
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
b3c12f437e5a65cdc12a92193f59c2a01ec04b17066d23dcb44adb86ab1e15de\
79493ff2220bd90c73cccab5e0f367bbae8e42ad7a7fc7ddfc12666f0f4d2571\
" # SHA512
GAPI_KEY_MD5="709560c02f94b41f9ad2c49207be6c54"
GLOCATIONAPI_KEY_MD5="ffb7895e35dedf832eb1c5d420ac7420"
MAPI_KEY_MD5="3927726e9442a8e8fa0e46ccc39caa27"
# FF-XX.YY-THIRD-PARTY-LICENSES should be updated per new feature or if the \
# fingerprint changes.
# Update the license version also.
LICENSE_FILE_NAME="FF-$(ver_cut 1-2 ${PV})-THIRD-PARTY-LICENSES"
LICENSE+=" ${LICENSE_FILE_NAME}"
LICENSE+="
	(
		BSD-2
		BSD
		LGPL-2.1
		( all-rights-reserved || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) )
		( all-rights-reserved || ( MIT AFL-2.1 ) )
		( MIT GPL-2 )
		( all-rights-reserved || ( AFL-2.1 BSD ) )
	)
	( all-rights-reserved || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) )
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	all-rights-reserved
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
			BSD-2
			( all-rights-reserved || ( MIT AFL-2.1 ) )
			( MIT GPL-2 )
			BSD
			MIT
		)
		BSD
		BSD-2
		LGPL-2.1
		LGPL-2.1+
		MPL-2.0
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
#   ( all-rights-reserved ^^ ( MPL-1.1 GPL-2+ LGPL-2.1+ ) )
#   ( all-rights-reserved || ( MIT AFL-2.1 ) )
#   ( all-rights-reserved || ( AFL-2.1 BSD ) )
#   ( all-rights-reserved MIT )
#   ( all-rights-reserved Apache-2.0 )
#   ( MIT GPL-2 )
# ) \
#     third_party/webkit/PerformanceTests/**
# ( all-rights-reserved || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) ) \
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

IUSE+=" cpu_flags_arm_neon dbus debug eme-free +hardened hwaccel jack libproxy"
IUSE+=" +openh264 pgo pulseaudio sndio selinux +system-av1 +system-harfbuzz"
IUSE+=" +system-icu +system-jpeg +system-libevent +system-libvpx system-png"
IUSE+=" system-python-libs +system-webp	wayland wifi"
IUSE+=" -jemalloc +webrtc"

# Firefox-only IUSE
IUSE+=" geckodriver +gmp-autoupdate screencast +X"

REQUIRED_USE="
	debug? ( !system-av1 )
	wayland? ( dbus )
	wifi? ( dbus )
"

# Firefox-only REQUIRED_USE flags
REQUIRED_USE+=" || ( X wayland )"
REQUIRED_USE+=" pgo? ( X )"
REQUIRED_USE+=" screencast? ( wayland )"

LLVM_SLOTS=(14 13)

gen_llvm_bdepends() {
	local o=""
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
		(
			sys-devel/clang:${s}[${MULTILIB_USEDEP}]
			sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
			pgo? (
				=sys-libs/compiler-rt-sanitizers-${s}*[profile,${MULTILIB_USEDEP}]
			)
		)
		"
	done
}

BDEPEND+=" || ( $(gen_llvm_bdepends) )"
FF_ONLY_DEPEND="
	!www-client/firefox:0
	!www-client/firefox:esr
	screencast? ( media-video/pipewire:=[${MULTILIB_USEDEP}] )
	selinux? ( sec-policy/selinux-mozilla )
"
BDEPEND+="
	${PYTHON_DEPS}
	app-arch/unzip
	app-arch/zip
	>=dev-util/cbindgen-0.24.3
	net-libs/nodejs
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	>=virtual/rust-1.61.0[${MULTILIB_USEDEP}]
	amd64? ( >=dev-lang/nasm-2.14 )
	pgo? (
		x11-base/xorg-server[xvfb]
		x11-apps/xhost
	)
	x86? ( >=dev-lang/nasm-2.14 )
"

CDEPEND="
	${FF_ONLY_DEPEND}
	|| (
		>=app-accessibility/at-spi2-core-2.46.0:2
		dev-libs/atk[${MULTILIB_USEDEP}]
	)
	dev-libs/expat[${MULTILIB_USEDEP}]
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	dev-libs/libffi:=[${MULTILIB_USEDEP}]
	>=dev-libs/nss-3.83[${MULTILIB_USEDEP}]
	>=dev-libs/nspr-4.35[${MULTILIB_USEDEP}]
	media-libs/alsa-lib[${MULTILIB_USEDEP}]
	media-libs/fontconfig[${MULTILIB_USEDEP}]
	media-libs/freetype[${MULTILIB_USEDEP}]
	media-libs/mesa[${MULTILIB_USEDEP}]
	media-video/ffmpeg[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	virtual/freedesktop-icon-theme
	x11-libs/cairo[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf[${MULTILIB_USEDEP}]
	x11-libs/pango[${MULTILIB_USEDEP}]
	x11-libs/pixman[${MULTILIB_USEDEP}]
	dbus? (
		dev-libs/dbus-glib[${MULTILIB_USEDEP}]
		sys-apps/dbus[${MULTILIB_USEDEP}]
	)
	jack? ( virtual/jack[${MULTILIB_USEDEP}] )
	libproxy? ( net-libs/libproxy[${MULTILIB_USEDEP}] )
	selinux? ( sec-policy/selinux-mozilla )
	sndio? ( >=media-sound/sndio-1.8.0-r1[${MULTILIB_USEDEP}] )
	screencast? ( media-video/pipewire:= )
	system-av1? (
		>=media-libs/dav1d-1.0.0:=[${MULTILIB_USEDEP},8bit]
		>=media-libs/libaom-1.0.0:=[${MULTILIB_USEDEP}]
	)
	system-harfbuzz? (
		>=media-gfx/graphite2-1.3.13[${MULTILIB_USEDEP}]
		>=media-libs/harfbuzz-2.8.1:0=[${MULTILIB_USEDEP}]
	)
	system-icu? ( >=dev-libs/icu-71.1:=[${MULTILIB_USEDEP}] )
	system-jpeg? ( >=media-libs/libjpeg-turbo-1.2.1[${MULTILIB_USEDEP}] )
	system-libevent? ( >=dev-libs/libevent-2.0:0=[threads,${MULTILIB_USEDEP}] )
	system-libvpx? ( >=media-libs/libvpx-1.8.2:0=[postproc,${MULTILIB_USEDEP}] )
	system-png? ( >=media-libs/libpng-1.6.35:0=[apng,${MULTILIB_USEDEP}] )
	system-webp? ( >=media-libs/libwebp-1.1.0:0=[${MULTILIB_USEDEP}] )
	wayland? (
		>=media-libs/libepoxy-1.5.10-r1[${MULTILIB_USEDEP}]
		x11-libs/gtk+:3[wayland,${MULTILIB_USEDEP}]
		x11-libs/libdrm[${MULTILIB_USEDEP}]
		x11-libs/libxkbcommon[wayland,${MULTILIB_USEDEP}]
	)
	wifi? (
		kernel_linux? (
			dev-libs/dbus-glib[${MULTILIB_USEDEP}]
			net-misc/networkmanager[${MULTILIB_USEDEP}]
			sys-apps/dbus[${MULTILIB_USEDEP}]
		)
	)
	X? (
		virtual/opengl[${MULTILIB_USEDEP}]
		x11-libs/cairo[X,${MULTILIB_USEDEP}]
		x11-libs/gtk+:3[X,${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXcomposite[${MULTILIB_USEDEP}]
		x11-libs/libXdamage[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		x11-libs/libXfixes[${MULTILIB_USEDEP}]
		x11-libs/libxkbcommon[X,${MULTILIB_USEDEP}]
		x11-libs/libXrandr[${MULTILIB_USEDEP}]
		x11-libs/libXtst[${MULTILIB_USEDEP}]
		x11-libs/libxcb:=[${MULTILIB_USEDEP}]
	)
"

RDEPEND="
	${CDEPEND}
	jack? ( virtual/jack[${MULTILIB_USEDEP}] )
	openh264? ( media-libs/openh264:*[plugin,${MULTILIB_USEDEP}] )
	pulseaudio? (
		|| (
			media-sound/pulseaudio[${MULTILIB_USEDEP}]
			>=media-sound/apulse-0.1.12-r4[${MULTILIB_USEDEP}]
		)
	)
"

DEPEND="
	${CDEPEND}
	pulseaudio? (
		|| (
			media-sound/pulseaudio[${MULTILIB_USEDEP}]
			>=media-sound/apulse-0.1.12-r4[sdk,${MULTILIB_USEDEP}]
		)
	)
	X? (
		x11-libs/libICE[${MULTILIB_USEDEP}]
		x11-libs/libSM[${MULTILIB_USEDEP}]
	)
"
RESTRICT="mirror"

S="${WORKDIR}/${PN}-${PV%_*}"
S_BAK="${WORKDIR}/${PN}-${PV%_*}"

# One of the major sources of lag comes from dependencies
# These are strict to match performance to competition or normal builds.
declare -A CFLAGS_RDEPEND=(
	["media-libs/dav1d"]="-O2" # -O0 skippy, -O1 faster but blurry, -Os blurry still, -O2 not blurry
)

MOZILLA_FIVE_HOME=""
BUILD_OBJ_DIR=""

# Allow MOZ_GMP_PLUGIN_LIST to be set in an eclass or
# overridden in the enviromnent (advanced hackers only)
if [[ -z "${MOZ_GMP_PLUGIN_LIST+set}" ]] ; then
	MOZ_GMP_PLUGIN_LIST=( gmp-gmpopenh264 gmp-widevinecdm )
fi

llvm_check_deps() {
	if ! has_version -b "sys-devel/clang:${LLVM_SLOT}" ; then
einfo "sys-devel/clang:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
		return 1
	fi

	if tc-is-clang ; then
		if ! has_version -b ">=sys-devel/lld-${LLVM_SLOT}" ; then
einfo ">=sys-devel/lld-${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
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

MOZ_LANGS=(
	af ar ast be bg br ca cak cs cy da de dsb
	el en-CA en-GB en-US es-AR es-ES et eu
	fi fr fy-NL ga-IE gd gl he hr hsb hu
	id is it ja ka kab kk ko lt lv ms nb-NO nl nn-NO
	pa-IN pl pt-BR pt-PT rm ro ru
	sk sl sq sr sv-SE th tr uk uz vi zh-CN zh-TW
)

# Firefox-only LANGS
MOZ_LANGS+=( ach )
MOZ_LANGS+=( an )
MOZ_LANGS+=( az )
MOZ_LANGS+=( bn )
MOZ_LANGS+=( bs )
MOZ_LANGS+=( ca-valencia )
MOZ_LANGS+=( eo )
MOZ_LANGS+=( es-CL )
MOZ_LANGS+=( es-MX )
MOZ_LANGS+=( fa )
MOZ_LANGS+=( ff )
MOZ_LANGS+=( gn )
MOZ_LANGS+=( gu-IN )
MOZ_LANGS+=( hi-IN )
MOZ_LANGS+=( hy-AM )
MOZ_LANGS+=( ia )
MOZ_LANGS+=( km )
MOZ_LANGS+=( kn )
MOZ_LANGS+=( lij )
MOZ_LANGS+=( mk )
MOZ_LANGS+=( mr )
MOZ_LANGS+=( my )
MOZ_LANGS+=( ne-NP )
MOZ_LANGS+=( oc )
MOZ_LANGS+=( sco )
MOZ_LANGS+=( si )
MOZ_LANGS+=( son )
MOZ_LANGS+=( szl )
MOZ_LANGS+=( ta )
MOZ_LANGS+=( te )
MOZ_LANGS+=( tl )
MOZ_LANGS+=( trs )
MOZ_LANGS+=( ur )
MOZ_LANGS+=( xh )

mozilla_set_globals() {
	# https://bugs.gentoo.org/587334
	local MOZ_TOO_REGIONALIZED_FOR_L10N=(
		fy-NL ga-IE gu-IN hi-IN hy-AM nb-NO ne-NP nn-NO pa-IN sv-SE
	)

	local lang xflag
	for lang in "${MOZ_LANGS[@]}" ; do
		# en and en_US are handled internally
		if [[ ${lang} == en ]] || [[ ${lang} == en-US ]] ; then
			continue
		fi

		# strip region subtag if $lang is in the list
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
		"${S}"/third_party/rust/${1}/.cargo-checksum.json \
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
	mozconfig_add_options_ac "$(use ${1} && echo +${1} || echo -${1})" "${flag}"
}

mozconfig_use_with() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 1 ]] ; then
		die "${FUNCNAME} requires at least one arguments"
	fi

	local flag=$(use_with "${@}")
	mozconfig_add_options_ac "$(use ${1} && echo +${1} || echo -${1})" "${flag}"
}

virtwl() {
	debug-print-function ${FUNCNAME} "$@"

	[[ $# -lt 1 ]] && die "${FUNCNAME} needs at least one argument"
	[[ -n $XDG_RUNTIME_DIR ]] || die "${FUNCNAME} needs XDG_RUNTIME_DIR to be set; try xdg_environment_reset"
	tinywl -h >/dev/null || die 'tinywl -h failed'

	# TODO: don't run addpredict in utility function. WLR_RENDERER=pixman doesn't work
	addpredict /dev/dri
	local VIRTWL VIRTWL_PID
	coproc VIRTWL { WLR_BACKENDS=headless exec tinywl -s 'echo $WAYLAND_DISPLAY; read _; kill $PPID'; }
	local -x WAYLAND_DISPLAY
	read WAYLAND_DISPLAY <&${VIRTWL[0]}

	debug-print "${FUNCNAME}: $@"
	"$@"

	[[ -n $VIRTWL_PID ]] || die "tinywl exited unexpectedly"
	exec {VIRTWL[0]}<&- {VIRTWL[1]}>&-
}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] ; then
		if use pgo ; then
			if ! has usersandbox $FEATURES ; then
# Generally speaking, PGO doesn't require usersandbox dropped.
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
			has_version "sys-devel/lld" \
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
			# Update 105.0: "/proc/self/oom_score_adj" isn't enough anymore with pgo, but not sure
			# whether that's due to better OOM handling by Firefox (bmo#1771712), or portage
			# (PORTAGE_SCHEDULING_POLICY) update...
			addpredict /proc

			# May need a wider addpredict when using wayland+pgo.
			addpredict /dev/dri

			# Allow access to GPU during PGO run
			local ati_cards mesa_cards nvidia_cards render_cards
			shopt -s nullglob

			ati_cards=$(echo -n /dev/ati/card* | sed 's/ /:/g')
			if [[ -n "${ati_cards}" ]] ; then
				addpredict "${ati_cards}"
			fi

			mesa_cards=$(echo -n /dev/dri/card* | sed 's/ /:/g')
			if [[ -n "${mesa_cards}" ]] ; then
				addpredict "${mesa_cards}"
			fi

			nvidia_cards=$(echo -n /dev/nvidia* | sed 's/ /:/g')
			if [[ -n "${nvidia_cards}" ]] ; then
				addpredict "${nvidia_cards}"
			fi

			render_cards=$(echo -n /dev/dri/renderD128* | sed 's/ /:/g')
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
einfo "To set up cross-compile for other ABIs see \`epkginfo -d firefox\` or"
einfo "the metadata.xml"
einfo

	local jobs=$(echo "${MAKEOPTS}" | grep -P -o -e "(-j|--jobs=)\s*[0-9]+" \
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

	if [[ -n "${FF_EBUILD_MAINTAINER}" ]] ; then
		if [[ -z "${MY_OVERLAY_DIR}" ]] ; then
eerror
eerror "You need to set MY_OVERLAY_DIR as a per-package envvar to the base path"
eerror "of your overlay or local repo.  The base path should contain all the"
eerror "overlay's categories."
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

	export MAKEOPTS="-j1" # > -j1 breaks building memchr with sccache
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
	if [[ -n "${FF_EBUILD_MAINTAINER}" ]] ; then
		if [[ ! ( "${LICENSE}" =~ "${LICENSE_FILE_NAME}" ) \
			|| ! -e "${MY_OVERLAY_DIR}/licenses/${LICENSE_FILE_NAME}" \
			|| "${actual_fp}" != "${LICENSE_FINGERPRINT}" \
		]] ; then
		# For ebuild maintainers
eerror
eerror "A change in the license was detected.  Please change"
eerror "LICENSE_FINGERPRINT=${actual_fp} and do a"
eerror
eerror "  \`cp -a ${S}/toolkit/content/license.html \
${MY_OVERLAY_DIR}/licenses/${LICENSE_FILE_NAME}\`"
eerror
			die
		fi
	else
		# For users
		if [[ "${actual_fp}" != "${LICENSE_FINGERPRINT}" ]] ; then
eerror
eerror "Expected license fingerprint:  ${LICENSE_FINGERPRINT}"
eerror "Actual license fingerprint:  ${actual_fp}"
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
		rm -fv "${WORKDIR}"/firefox-patches/*-LTO-Only-enable-LTO-*.patch
	fi
	if ! use ppc64 ; then
		rm -v "${WORKDIR}"/firefox-patches/*bmo-1775202-ppc64*.patch
	fi
	eapply "${WORKDIR}/firefox-patches"

	# Only partial patching was done because Gentoo doesn't support multilib
	# Python.  Only native ABI is supported.  This means cbindgen cannot
	# load the 32-bit clang.  It will build the cargo parts.  When it links
	# it, it fails because of cbindings is 64-bit and the dependencies use
	# the build information for 64-bit linking, which should be 32-bit.

	# Allow user to apply any additional patches without modifing ebuild
	eapply_user

	# Make cargo respect MAKEOPTS
	export CARGO_BUILD_JOBS="$(makeopts_jobs)"

	# Make LTO respect MAKEOPTS
	sed -i \
		-e "s/multiprocessing.cpu_count()/$(makeopts_jobs)/" \
		"${S}"/build/moz.configure/lto-pgo.configure \
		|| die "sed failed to set num_cores"

	# Make ICU respect MAKEOPTS
	sed -i \
		-e "s/multiprocessing.cpu_count()/$(makeopts_jobs)/" \
		"${S}"/intl/icu_sources_data.py \
		|| die "sed failed to set num_cores"

	# sed-in toolchain prefix section was moved to the bottom of function
	#
	# Moved down
	#
	#

	sed -i \
		-e 's/ccache_stats = None/return None/' \
		"${S}"/python/mozbuild/mozbuild/controller/building.py \
		|| die "sed failed to disable ccache stats call"

einfo "Removing pre-built binaries ..."
	find "${S}"/third_party -type f \( -name '*.so' -o -name '*.o' \) \
		-print -delete || die

	# Clearing checksums where we have applied patches
	moz_clear_vendor_checksums bindgen

	# Removed creation of a single build dir
	#
	#

	# Write API keys to disk
	echo -n "${MOZ_API_KEY_GOOGLE//gGaPi/}" > "${S}"/api-google.key || die
	echo -n "${MOZ_API_KEY_LOCATION//gGaPi/}" > "${S}"/api-location.key || die
	echo -n "${MOZ_API_KEY_MOZILLA//m0ap1/}" > "${S}"/api-mozilla.key || die

	verify_license_fingerprint

	(( ${NABIS} > 1 )) && multilib_copy_sources

	_src_prepare() {
		cd $(_get_s) || die
		local cbuild=$(get_abi_CHOST ${DEFAULT_ABI})	# builder machine
		local chost=$(get_abi_CHOST ${ABI})		# target machine
		# Only ${cbuild}-objdump exists because in true multilib
		# logically speaking there should be i686-pc-linux-gnu-objdump
		if [[ -e "${ESYSROOT}/usr/bin/${chost}-objdump" ]] ; then
			# sed-in toolchain prefix
			sed -i \
				-e "s/\"objdump/\"${chost}-objdump/" \
				python/mozbuild/mozbuild/configure/check_debug_ranges.py \
				|| die "sed failed to set toolchain prefix"
einfo "Using ${chost}-objdump for chost"
		else
			[[ -e "${ESYSROOT}/usr/bin/${cbuild}-objdump" ]] || die
			# sed-in toolchain prefix
			sed -i \
				-e "s/\"objdump/\"${cbuild}-objdump/" \
				python/mozbuild/mozbuild/configure/check_debug_ranges.py \
				|| die "sed failed to set toolchain prefix"
ewarn "Using ${cbuild}-objdump for cbuild"
		fi
		uopts_src_prepare
	}

	multilib_foreach_abi _src_prepare
}

# Corrections based on the ABI being compiled
# Preconditions:
#   chost must be defined
#   cwd is ABI's S
_fix_paths() {
	# For proper rust cargo cross-compile for libloading and glslopt
	export PKG_CONFIG=${chost}-pkg-config
	export CARGO_CFG_TARGET_ARCH=$(echo ${chost} | cut -f 1 -d "-")
	export MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"
	export BUILD_OBJ_DIR="$(pwd)/ff"

	# Set MOZCONFIG
	export MOZCONFIG="$(pwd)/.mozconfig"

	# for rust crates libloading and glslopt
	if tc-is-clang ; then
		CC=${chost}-clang
		CXX=${chost}-clang++
	else
		CC=${chost}-gcc
		CXX=${chost}-g++
	fi
	tc-export CC CXX
}

append_all() {
	append-flags ${@}
	append-ldflags ${@}
}

OFLAG=""
LTO_TYPE=""
_src_configure() {
	local s=$(_get_s)
	cd "${s}" || die

	local cbuild=$(get_abi_CHOST ${DEFAULT_ABI})
	local chost=$(get_abi_CHOST ${ABI})
	# Show flags set at the beginning
einfo
einfo "Current BINDGEN_CFLAGS:\t${BINDGEN_CFLAGS:-no value set}"
einfo "Current CFLAGS:\t\t${CFLAGS:-no value set}"
einfo "Current CXXFLAGS:\t\t${CXXFLAGS:-no value set}"
einfo "Current LDFLAGS:\t\t${LDFLAGS:-no value set}"
einfo "Current RUSTFLAGS:\t\t${RUSTFLAGS:-no value set}"
einfo "Cross-compile CHOST:\t\t${chost}"
einfo

	local have_switched_compiler=
	if tc-is-clang ; then
		# Force clang
einfo
einfo "Switching to clang"
einfo
		have_switched_compiler=yes
		AR=llvm-ar
		AS=llvm-as
		CC=${chost}-clang
		CXX=${chost}-clang++
		NM=llvm-nm
		RANLIB=llvm-ranlib
		local s=$(clang-major-version)
		if ! has_version ">=sys-devel/lld-${s}" ; then
eerror
eerror "You need to emerge >=sys-devel/lld-${s}"
eerror
			die
		fi
		if ! has_version "=sys-libs/compiler-rt-sanitizers-${s}*[profile]" ; then
eerror
eerror "You need to emerge =sys-libs/compiler-rt-sanitizers-${s}*[profile]"
eerror
			die
		fi
	else
ewarn
ewarn "GCC is not the upstream default"
ewarn
		# Force gcc
		have_switched_compiler=yes
einfo
einfo "Switching to gcc"
einfo
		AR=gcc-ar
		CC=${chost}-gcc
		CXX=${chost}-g++
		NM=gcc-nm
		RANLIB=gcc-ranlib
	fi

	if [[ -n "${have_switched_compiler}" ]] ; then
		# Because we switched active compiler we have to ensure
		# that no unsupported flags are set
		strip-unsupported-flags
	fi

	uopts_src_configure

	# Ensure we use correct toolchain
	export HOST_CC="$(tc-getBUILD_CC)"
	export HOST_CXX="$(tc-getBUILD_CXX)"
	tc-export CC CXX LD AR NM OBJDUMP RANLIB PKG_CONFIG
	_fix_paths
	# Pass the correct toolchain paths through cbindgen
	if tc-is-cross-compiler ; then
		export BINDGEN_CFLAGS="
			${SYSROOT:+--sysroot=${ESYSROOT}}
			--host=${cbuild}
			--target=${chost} ${BINDGEN_CFLAGS-}
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

	# Set Gentoo defaults
	export MOZILLA_OFFICIAL=1

	mozconfig_add_options_ac 'Gentoo default' \
		--allow-addon-sideload \
		--disable-cargo-incremental \
		--disable-crashreporter \
		--disable-gpsd \
		--disable-install-strip \
		--disable-parental-controls \
		--disable-strip \
		--disable-updater \
		--enable-negotiateauth \
		--enable-new-pass-manager \
		--enable-official-branding \
		--enable-release \
		--enable-system-ffi \
		--enable-system-pixman \
		--enable-system-policies \
		--host="${cbuild}" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--prefix="${EPREFIX}/usr" \
		--target="${chost}" \
		--without-ccache \
		--without-wasm-sandboxed-libraries \
		--with-intl-api \
		\
		--with-system-nspr \
		--with-system-nss \
		--with-system-zlib \
		--with-toolchain-prefix="${chost}-" \
		--with-unsigned-addon-scopes=app,system \
		--x-includes="${ESYSROOT}/usr/include" \
		--x-libraries="${ESYSROOT}/usr/$(get_libdir)"

	# mozconfig_add_options_ac '' --with-libclang-path="$(${chost}-llvm-config --libdir)"
	#   Disabled because Gentoo doesn't support multilib python, so full
	#   cross-compile is not supported.

	#   the commented above is mutually exclusive with this line below.
	mozconfig_add_options_ac '' --with-libclang-path="$(llvm-config --libdir)"

	# Set update channel
	local update_channel=release
	[[ -n ${MOZ_ESR} ]] && update_channel=esr
	mozconfig_add_options_ac '' --update-channel=${update_channel}

	if ! use x86 && [[ ${chost} != armv*h* ]] ; then
		mozconfig_add_options_ac '' --enable-rust-simd
	fi

	# For future keywording: This is currently (97.0) only supported on:
	# amd64, arm, arm64 & x86.
	# Might want to flip the logic around if Firefox is to support more arches.
	if use ppc64; then
		mozconfig_add_options_ac '' --disable-sandbox
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

		mozconfig_add_options_ac "${key_origin}" \
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

		mozconfig_add_options_ac "${key_origin}" \
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

		mozconfig_add_options_ac "${key_origin}" \
			--with-mozilla-api-keyfile="${s}/api-mozilla.key"
	else
einfo "Building without Mozilla API key ..."
	fi

	# To find features, use
	# grep -o -E -r -e "--(with|disable|enable)[^\"]+" ./toolkit/moz.configure | sort | uniq
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
	mozconfig_use_enable webrtc

	use eme-free && mozconfig_add_options_ac '+eme-free' --disable-eme

	mozconfig_use_enable geckodriver

	# The upstream default is hardening on even if unset.
	if use hardened ; then
		mozconfig_add_options_ac "+hardened" --enable-hardening
		append-ldflags "-Wl,-z,relro -Wl,-z,now"
	else
		mozconfig_add_options_ac "-hardened" --disable-hardening
	fi

	local myaudiobackends=""
	use jack && myaudiobackends+="jack,"
	use sndio && myaudiobackends+="sndio,"
	use pulseaudio && myaudiobackends+="pulseaudio,"
	! use pulseaudio && myaudiobackends+="alsa,"

	mozconfig_add_options_ac '--enable-audio-backends' \
		--enable-audio-backends="${myaudiobackends::-1}"

	mozconfig_use_enable wifi necko-wifi

	if use X && use wayland ; then
		mozconfig_add_options_ac '+x11+wayland' \
			--enable-default-toolkit=cairo-gtk3-x11-wayland
	elif ! use X && use wayland ; then
		mozconfig_add_options_ac '+wayland' \
			--enable-default-toolkit=cairo-gtk3-wayland-only
	else
		mozconfig_add_options_ac '+x11' \
			--enable-default-toolkit=cairo-gtk3
	fi

	if [[ -z "${LTO_TYPE}" ]] ; then
		LTO_TYPE=$(check-linker_get_lto_type)
	fi
	if use pgo \
		|| [[ "${LTO_TYPE}" =~ ("thinlto"|"bfdlto") ]] ; then
		if tc-is-clang && [[ "${LTO_TYPE}" == "thinlto" ]] ; then
			# Upstream only supports lld when using clang
			mozconfig_add_options_ac \
				"forcing ld=lld due to USE=clang and USE=lto" \
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
		# Avoid auto-magic on linker
		if tc-is-clang && has_version "sys-devel/lld" ; then
			# This is upstream's default
			mozconfig_add_options_ac \
				"forcing ld=lld due to USE=clang" \
				--enable-linker=lld
		else
			mozconfig_add_options_ac \
				"linker is set to bfd" \
				--enable-linker=bfd
		fi
	fi

	# LTO flag was handled via configure
	filter-flags '-flto*'

	# Default upstream Oflag is -O0, but dav1d is only acceptable at >= -O2.
	mozconfig_use_enable debug
	if use debug ; then
		mozconfig_add_options_ac '+debug' --disable-optimize
	else
		mozconfig_add_options_ac 'Gentoo default' \
			--disable-debug-symbols

		# Fork ebuild or set USE=debug if you want -Og
		if is-flagq '-O4' || [[ "${OFLAG}" == "-O4" ]] ; then
			OFLAG="-O4"
			mozconfig_add_options_ac "from CFLAGS" \
				--enable-optimize=-O4
		elif is-flagq '-O3' \
			|| is-flagq '-Ofast' \
			|| [[ "${OFLAG}" == "-O3" || "${OFLAG}" == "-Ofast" ]] ; then
	# -Ofast bug:
	# Dynamic visual elements on the website associated with the mouse may
	# flicker when GPU acceleration is on.
			OFLAG="-O3"
			mozconfig_add_options_ac "from CFLAGS" \
				--enable-optimize=-O3
		else
			OFLAG="-O2"
			mozconfig_add_options_ac "Gentoo default" \
				--enable-optimize=-O2
		fi
	fi

	if is-flagq '-Ofast' || [[ "${OFLAG}" == "-Ofast" ]] ; then
		# Precaution
		append_all $(test-flags -fno-allow-store-data-races)
	fi

	# Debug flag was handled via configure
	filter-flags '-g*'

	# Optimization flag was handled via configure
	filter-flags '-O*'

	if is-flagq '-ffast-math' || [[ "${OFLAG}" == "-Ofast" ]] ; then
		local pos=$(grep -n "#define OPUS_DEFINES_H" \
			"${s}/media/libopus/include/opus_defines.h" \
			| cut -f 1 -d ":")
		sed -e "${pos}a#define FLOAT_APPROX 1" \
			"${s}/media/libopus/include/opus_defines.h" || die
	fi

	# Modifications to better support ARM, bug #553364
	if use cpu_flags_arm_neon ; then
		mozconfig_add_options_ac '+cpu_flags_arm_neon' --with-fpu=neon

		if tc-is-gcc ; then
			# thumb options aren't supported when using clang, bug 666966
			mozconfig_add_options_ac '+cpu_flags_arm_neon' \
				--with-thumb=yes \
				--with-thumb-interwork=no
		fi
	fi

	if [[ ${chost} == armv*h* ]] ; then
		mozconfig_add_options_ac 'CHOST=armv*h*' --with-float-abi=hard

		if ! use system-libvpx ; then
			sed -i \
				-e "s|softfp|hard|" \
				"${s}"/media/libvpx/moz.build \
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
	elif tc-is-gcc ; then
		if ver_test $(gcc-fullversion) -ge 10 ; then
einfo "Forcing -fno-tree-loop-vectorize to workaround GCC bug, see bug 758446 ..."
			append-cxxflags -fno-tree-loop-vectorize
		fi
	fi

	# Additional ARCH support
	case "${ARCH}" in
		arm)
			# Reduce the memory requirements for linking
			if tc-is-clang ; then
				# Nothing to do
				:;
			elif [[ "${LTO_TYPE}" == "bfdlto" ]] ; then
				append-ldflags \
					-Wl,--no-keep-memory
			else
				append-ldflags \
					-Wl,--no-keep-memory \
					-Wl,--reduce-memory-overheads
			fi
			;;
	esac

	if ! use elibc_glibc ; then
		mozconfig_add_options_ac '!elibc_glibc' --disable-jemalloc
	elif ! use jemalloc ; then
		mozconfig_add_options_ac '-jemalloc' --disable-jemalloc
	else
		mozconfig_add_options_ac '+jemalloc' --enable-jemalloc
	fi

	# Allow elfhack to work in combination with unstripped binaries
	# when they would normally be larger than 2GiB.
	append-ldflags "-Wl,--compress-debug-sections=zlib"

	# Make revdep-rebuild.sh happy; Also required for musl
	append-ldflags -Wl,-rpath="${MOZILLA_FIVE_HOME}",--enable-new-dtags

	# Pass $MAKEOPTS to build system
	export MOZ_MAKE_FLAGS="${MAKEOPTS}"

	# Use system's Python environment
	PIP_NETWORK_INSTALL_RESTRICTED_VIRTUALENVS=mach

	if use system-python-libs; then
		export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE="system"
	else
		export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE="none"
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
echo "export PKG_CONFIG=${chost}-pkg-config" \
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
	grep ^ac_add_options "${MOZCONFIG}" | while read ac opt hash reason; do
		[[ -z ${hash} || ${hash} == \# ]] \
			|| die "error reading mozconfig: ${ac} ${opt} ${hash} ${reason}"
		printf "    %-30s  %s\n" "${opt}" "${reason:-mozilla.org default}"
	done
	echo "=========================================================="
	echo

	./mach configure || die
}

_src_compile() {
	local s=$(_get_s)
	cd "${s}" || die

	local cbuild=$(get_abi_CHOST ${DEFAULT_ABI})
	local chost=$(get_abi_CHOST ${ABI})
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
	local cbuild=$(get_abi_CHOST ${DEFAULT_ABI})
	local chost=$(get_abi_CHOST ${ABI})
	_fix_paths
	# xpcshell is getting called during install
	pax-mark m \
		"${BUILD_OBJ_DIR}"/dist/bin/xpcshell \
		"${BUILD_OBJ_DIR}"/dist/bin/${PN} \
		"${BUILD_OBJ_DIR}"/dist/bin/plugin-container

	DESTDIR="${D}" ./mach install || die

	# Upstream cannot ship symlink but we can (bmo#658850)
	rm "${ED}${MOZILLA_FIVE_HOME}/${PN}-bin" || die
	dosym ${PN} ${MOZILLA_FIVE_HOME}/${PN}-bin

	# Don't install llvm-symbolizer from sys-devel/llvm package
	if [[ -f "${ED}${MOZILLA_FIVE_HOME}/llvm-symbolizer" ]] ; then
		rm -v "${ED}${MOZILLA_FIVE_HOME}/llvm-symbolizer" || die
	fi

	# Install policy (currently only used to disable application updates)
	insinto "${MOZILLA_FIVE_HOME}/distribution"
	newins "${FILESDIR}"/distribution.ini distribution.ini
	newins "${FILESDIR}"/disable-auto-update.policy.json policies.json

	# Install system-wide preferences
	local PREFS_DIR="${MOZILLA_FIVE_HOME}/browser/defaults/preferences"
	insinto "${PREFS_DIR}"
	newins "${FILESDIR}"/gentoo-default-prefs.js gentoo-prefs.js

	local GENTOO_PREFS="${ED}${PREFS_DIR}/gentoo-prefs.js"

	# Set dictionary path to use system hunspell
cat >>"${GENTOO_PREFS}" <<-EOF || die "failed to set spellchecker.dictionary_path pref"
pref("spellchecker.dictionary_path",       "${EPREFIX}/usr/share/myspell");
EOF

	# Force hwaccel prefs if USE=hwaccel is enabled
	if use hwaccel ; then
		cat "${FILESDIR}"/gentoo-hwaccel-prefs.js-r2 \
		>>"${GENTOO_PREFS}" || \
die "failed to add prefs to force hardware-accelerated rendering to all-gentoo.js"

		if use wayland; then
cat >>"${GENTOO_PREFS}" <<-EOF || die "failed to set hwaccel wayland prefs"
pref("gfx.x11-egl.force-enabled",          false);
EOF
		else
cat >>"${GENTOO_PREFS}" <<-EOF || die "failed to set hwaccel x11 prefs"
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
	local langpacks=( $(find "${WORKDIR}/language_packs" -type f -name '*.xpi') )
	if [[ -n "${langpacks}" ]] ; then
		moz_install_xpi \
			"${MOZILLA_FIVE_HOME}/distribution/extensions" \
			"${langpacks[@]}"
	fi

	# Install geckodriver
	if use geckodriver ; then
einfo "Installing geckodriver into ${ED}${MOZILLA_FIVE_HOME} ..."
		pax-mark m "${BUILD_OBJ_DIR}"/dist/bin/geckodriver
		exeinto "${MOZILLA_FIVE_HOME}"
		doexe "${BUILD_OBJ_DIR}"/dist/bin/geckodriver

		dosym ${MOZILLA_FIVE_HOME}/geckodriver /usr/bin/geckodriver
	fi

	# Install icons
	local icon_srcdir="${s}/browser/branding/official"
	local icon_symbolic_file="${FILESDIR}/icon/firefox-symbolic.svg"

	insinto /usr/share/icons/hicolor/symbolic/apps
	newins "${icon_symbolic_file}" ${PN}-symbolic.svg

	local icon size
	for icon in "${icon_srcdir}"/default*.png ; do
		size=${icon%.png}
		size=${size##*/default}

		if [[ ${size} -eq 48 ]] ; then
			newicon "${icon}" ${PN}.png
		fi

		newicon -s ${size} "${icon}" ${PN}.png
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
	newbin "${FILESDIR}/multiabi/${PN}-r1.sh" ${PN}-${ABI}
	dosym /usr/bin/${PN}-${ABI} /usr/bin/${PN}

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
			if [[ ! -L ${lib##*/} ]] ; then
				ln -s "${lib}" ${lib##*/} || die
			fi
		done
		popd &>/dev/null || die
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	if ! use gmp-autoupdate ; then
elog
elog "USE='-gmp-autoupdate' has disabled the following plugins from updating or"
elog "installing into new profiles:"
elog
		local plugin
		for plugin in "${MOZ_GMP_PLUGIN_LIST[@]}" ; do
elog "\t ${plugin}"
		done
elog
	fi

	if use pulseaudio && has_version ">=media-sound/apulse-0.1.12-r4" ; then
elog
elog "Apulse was detected at merge time on this system and so it will always be"
elog "used for sound.  If you wish to use pulseaudio instead please unmerge"
elog "media-sound/apulse."
elog
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
				# Tell user that we no longer install a shortcut
				# per supported display protocol
				show_shortcut_information=yes
			fi
		done
	fi

	if [[ -n "${show_doh_information}" ]] ; then
elog
elog "Note regarding Trusted Recursive Resolver aka DNS-over-HTTPS (DoH):"
elog "Due to privacy concerns (encrypting DNS might be a good thing, sending"
elog "all DNS traffic to Cloudflare by default is not a good idea and"
elog "applications should respect OS configured settings), \"network.trr.mode\""
elog "was set to 5 (\"Off by choice\") by default."
elog "You can enable DNS-over-HTTPS in ${PN^}'s preferences."
elog
	fi

	# bug 713782
	if [[ -n "${show_normandy_information}" ]] ; then
elog
elog "Upstream operates a service named Normandy which allows Mozilla to"
elog "push changes for default settings or even install new add-ons remotely."
elog "While this can be useful to address problems like 'Armagadd-on 2.0' or"
elog "revert previous decisions to disable TLS 1.0/1.1, privacy and security"
elog "concerns prevail, which is why we have switched off the use of this"
elog "service by default."
elog
elog "To re-enable this service set"
elog
elog "    app.normandy.enabled=true"
elog
elog "in about:config."
elog
	fi

	if [[ -n "${show_shortcut_information}" ]] ; then
elog
elog "Since ${PN}-91.0 we no longer install multiple shortcuts for"
elog "each supported display protocol.  Instead we will only install"
elog "one generic Mozilla ${PN^} shortcut."
elog "If you still want to be able to select between running Mozilla ${PN^}"
elog "on X11 or Wayland, you have to re-create these shortcuts on your own."
elog
	fi

	# bug 835078
	if use hwaccel && has_version "x11-drivers/xf86-video-nouveau"; then
ewarn
ewarn "You have nouveau drivers installed in your system and 'hwaccel' enabled"
ewarn "for Firefox. Nouveau / your GPU might not supported the required EGL, so"
ewarn "either disable 'hwaccel' or try the workaround explained in"
ewarn "https://bugs.gentoo.org/835078#c5 if Firefox crashes."
ewarn
	fi

elog
elog "Unfortunately Firefox-100.0 breaks compatibility with some sites using "
elog "useragent checks. To temporarily fix this, enter about:config and modify "
elog "network.http.useragent.forceVersion preference to \"99\"."
elog "Or install an addon to change your useragent."
elog
elog "See:"
elog
elog "  https://support.mozilla.org/en-US/kb/difficulties-opening-or-using-website-firefox-100"
elog

einfo
einfo "By default, the /usr/bin/firefox symlink is set to the last ABI"
einfo "installed.  You must change it manually if you want to run on a"
einfo "different default ABI."
einfo
einfo "Examples"
einfo "ln -sf /usr/lib64/${PN} /usr/bin/firefox"
einfo "ln -sf /usr/lib/${PN} /usr/bin/firefox"
einfo "ln -sf /usr/lib32/${PN} /usr/bin/firefox"
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
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  ebuild, new-patches
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multiabi, license-completness, license-transparency

# = Ebuild fork checklist =
# Bump to latest release every week
# Update *DEPENDs with MULTILIB_USEDEP
# Update *patches
#  Test patches
# Bump gentoo-hwaccel-prefs.js-r2 if changed
# Diff compare ebuilds and code review
# Keep within the 80 character boundary
