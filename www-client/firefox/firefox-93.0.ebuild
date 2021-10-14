# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Originally based on the firefox-89.0.ebuild from the gentoo-overlay,
# with update sync updated with 90.0 ebuild.
# Revisions may change in the oiledmachine-overlay.

EAPI="7"

FIREFOX_PATCHSET="firefox-93-patches-01.tar.xz"

LLVM_MAX_SLOT=12

PYTHON_COMPAT=( python3_{8..10} )
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

inherit autotools check-reqs desktop flag-o-matic gnome2-utils linux-info \
	llvm multiprocessing pax-utils python-any-r1 toolchain-funcs \
	virtualx xdg
inherit multilib-minimal rust-toolchain

MOZ_SRC_BASE_URI="https://archive.mozilla.org/pub/${MOZ_PN}/releases/${MOZ_PV}"

if [[ ${PV} == *_rc* ]] ; then
	MOZ_SRC_BASE_URI="https://archive.mozilla.org/pub/${MOZ_PN}/candidates/${MOZ_PV}-candidates/build${PV##*_rc}"
fi

PATCH_URIS=(
	https://dev.gentoo.org/~{axs,polynomial-c,whissi}/mozilla/patchsets/${FIREFOX_PATCHSET}
)

SRC_URI="${MOZ_SRC_BASE_URI}/source/${MOZ_P}.source.tar.xz -> ${MOZ_P_DISTFILES}.source.tar.xz
	${PATCH_URIS[@]}"

DESCRIPTION="Firefox Web Browser"
HOMEPAGE="https://www.mozilla.com/firefox"

KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

SLOT="0/$(ver_cut 1)"
LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
# MPL-2.0 is the mostly used and default
#1234567890123456789012345678901234567890123456789012345678901234567890123456789
LICENSE_FINGERPRINT="\
20eb3b10bf7c7cba8e42edbc8d8ad58a3a753e214b8751fb60eddb827ebff067\
456f77f36e7abe6d06861b1be52011303fa08db8a981937e38733f961c4a39d9" # SHA512
# FF-93.0-THIRD-PARTY-LICENSES should be updated per new feature or if the fingerprint changes.
LICENSE+=" FF-93.0-THIRD-PARTY-LICENSES"
LICENSE+="
	( BSD-2
		BSD
		LGPL-2.1
		( all-rights-reserved || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) )
		( all-rights-reserved || ( MIT AFL-2.1 ) )
		( MIT GPL-2 )
		( all-rights-reserved || ( AFL-2.1 BSD ) ) )
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
	icu
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
	W3C-document
	ZLIB
	pgo? ( ( BSD-2
		  ( all-rights-reserved || ( MIT AFL-2.1 ) )
		  ( MIT GPL-2 )
		  BSD
		  MIT )
		BSD
		BSD-2
		LGPL-2.1
		LGPL-2.1+
		MPL-2.0	)" # \
# emerge does not recognize ^^ for the LICENSE variable.  You must choose
# at most one for some packages when || is present.

# Third party licenses:
#
# build/pgo/** folder:
#   ( BSD-2
#     ( all-rights-reserved || ( MIT AFL-2.1 ) )
#     ( MIT GPL-2 )
#     BSD
#     MIT ) \
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
#   ( MIT GPL-2 )
#   ( all-rights-reserved || ( AFL-2.1 BSD) ) ) \
#     third_party/webkit/PerformanceTests/SunSpider/sunspider-1.0.1/sunspider-1.0.1/sunspider-test-contents.js
# ( all-rights-reserved || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) ) \
#   testing/talos/talos/pageloader/chrome/pageloader.xhtml
# ^^ ( GPL-3? ( FTL ) GPL-2 ) modules/freetype2/LICENSE.TXT - GPL-2 assumed # \
#   since original ebuild cites it
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
# ISC ipc/chromium/src/third_party/libevent/arc4random.c
# libpng media/libpng/pngconf.h
# OFL-1.1 layout/reftests/fonts/Chunkfive-license.txt
# OPENLDAP third_party/rust/lmdb-rkv-sys/lmdb/libraries/liblmdb/mdb.c
# Old-MIT gfx/harfbuzz/
# PSF-2.4 (is a variation of) third_party/python/virtualenv/__virtualenv__/typing-3.7.4.3-py2-none-any/typing-3.7.4.3.dist-info/LICENSE
# PSF-2 third_party/python/virtualenv/__virtualenv__/contextlib2-0.6.0.post1-py2.py3-none-any/contextlib2-0.6.0.post1.dist-info/LICENSE.txt
# M+ FONTS LICENSE_E - layout/reftests/fonts/mplus/mplus-license.txt *
# MIT CC0-1.0 devtools/client/shared/vendor/lodash.js (more details can be \
#   found at https://github.com/lodash/lodash/blob/master/LICENSE)
# MIT UoI-NCSA js/src/jit/arm/llvm-compiler-rt/assembly.h
# UoI-NCSA tools/fuzzing/libfuzzer/LICENSE.TXT
# unicode BSD NAIST-IPADIC intl/icu/source/data/brkitr/dictionaries/cjdict.txt
# unicode icu security/sandbox/chromium/base/third_party/icu/LICENSE
# unicode intl/icu/source/data/unidata/ucdterms.txt
# unicode rust/regex-syntax/src/unicode_tables/LICENSE-UNICODE
# Spencer-94 js/src/editline/README *
# SunPro modules/fdlibm/src/math_private.h
# W3C-document testing/web-platform/tests/css/CSS2/LICENSE-W3CD
# ZLIB gfx/sfntly/cpp/src/test/tinyxml/tinyxml.cpp
# ZLIB media/ffvpx/libavutil/adler32.c
# ZLIB third_party/rust/libz-sys/src/zlib/zlib.h
# ZLIB MIT devtools/client/shared/vendor/jszip.js
# ZLIB all-rights-reserved media/libjpeg/simd/powerpc/jdsample-altivec.c -- \#
#   the vanilla ZLIB lib license doesn't contain all rights reserved

IUSE="+clang cpu_flags_arm_neon dbus debug eme-free geckodriver +gmp-autoupdate
	hardened hwaccel jack lto +openh264 pgo pulseaudio screencast sndio selinux
	+system-av1 +system-harfbuzz +system-icu +system-jpeg +system-libevent
	+system-libvpx +system-webp wayland wifi"
_ABIS="abi_x86_32 abi_x86_64 abi_x86_x32 abi_mips_n32 abi_mips_n64 \
abi_mips_o32 abi_ppc_32 abi_ppc_64 abi_s390_32 abi_s390_64"
IUSE+=" ${_ABIS}"
IUSE+=" -jemalloc"

REQUIRED_USE="debug? ( !system-av1 )
	screencast? ( wayland )"

BDEPEND="${PYTHON_DEPS}
	app-arch/unzip
	app-arch/zip
	>=dev-util/cbindgen-0.19.0
	>=net-libs/nodejs-10.23.1
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	>=virtual/rust-1.51.0[${MULTILIB_USEDEP}]
	|| (
		(
			sys-devel/clang:12[${MULTILIB_USEDEP}]
			sys-devel/llvm:12[${MULTILIB_USEDEP}]
			clang? (
				>=sys-devel/lld-12
				pgo? ( =sys-libs/compiler-rt-sanitizers-12*[profile] )
			)
		)
		(
			sys-devel/clang:11[${MULTILIB_USEDEP}]
			sys-devel/llvm:11[${MULTILIB_USEDEP}]
			clang? (
				>=sys-devel/lld-11
				pgo? ( =sys-libs/compiler-rt-sanitizers-11*[profile] )
			)
		)
		(
			sys-devel/clang:10[${MULTILIB_USEDEP}]
			sys-devel/llvm:10[${MULTILIB_USEDEP}]
			clang? (
				>=sys-devel/lld-10
				pgo? ( =sys-libs/compiler-rt-sanitizers-10*[profile] )
			)
		)
	)
	amd64? ( >=dev-lang/nasm-2.13 )
	x86? ( >=dev-lang/nasm-2.13 )"

CDEPEND="
	>=dev-libs/nss-3.70[${MULTILIB_USEDEP}]
	>=dev-libs/nspr-4.32[${MULTILIB_USEDEP}]
	dev-libs/atk[${MULTILIB_USEDEP}]
	dev-libs/expat[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.10[X,${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-3.4.0:3[X,${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf[${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.22.0[${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.6.35:0=[apng,${MULTILIB_USEDEP}]
	>=media-libs/mesa-10.2:*[${MULTILIB_USEDEP}]
	media-libs/fontconfig[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.4.10[${MULTILIB_USEDEP}]
	kernel_linux? ( !pulseaudio? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] ) )
	virtual/freedesktop-icon-theme
	>=x11-libs/pixman-0.19.2[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.26:2[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.3[${MULTILIB_USEDEP}]
	>=dev-libs/libffi-3.0.10:=[${MULTILIB_USEDEP}]
	media-video/ffmpeg[${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXcomposite[${MULTILIB_USEDEP}]
	x11-libs/libXdamage[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXfixes[${MULTILIB_USEDEP}]
	x11-libs/libXrender[${MULTILIB_USEDEP}]
	dbus? (
		sys-apps/dbus[${MULTILIB_USEDEP}]
		dev-libs/dbus-glib[${MULTILIB_USEDEP}]
	)
	screencast? ( media-video/pipewire:0/0.3 )
	system-av1? (
		>=media-libs/dav1d-0.8.1:=[${MULTILIB_USEDEP}]
		>=media-libs/libaom-1.0.0:=[${MULTILIB_USEDEP}]
	)
	system-harfbuzz? (
		>=media-libs/harfbuzz-2.8.1:0=[${MULTILIB_USEDEP}]
		>=media-gfx/graphite2-1.3.13[${MULTILIB_USEDEP}]
	)
	system-icu? ( >=dev-libs/icu-69.1:=[${MULTILIB_USEDEP}] )
	system-jpeg? ( >=media-libs/libjpeg-turbo-1.2.1[${MULTILIB_USEDEP}] )
	system-libevent? ( >=dev-libs/libevent-2.0:0=[threads,${MULTILIB_USEDEP}] )
	system-libvpx? ( >=media-libs/libvpx-1.8.2:0=[postproc,${MULTILIB_USEDEP}] )
	system-webp? ( >=media-libs/libwebp-1.1.0:0=[${MULTILIB_USEDEP}] )
	wifi? (
		kernel_linux? (
			sys-apps/dbus[${MULTILIB_USEDEP}]
			dev-libs/dbus-glib[${MULTILIB_USEDEP}]
			net-misc/networkmanager[${MULTILIB_USEDEP}]
		)
	)
	jack? ( virtual/jack[${MULTILIB_USEDEP}] )
	selinux? ( sec-policy/selinux-mozilla )
	sndio? ( media-sound/sndio[${MULTILIB_USEDEP}] )"

RDEPEND="${CDEPEND}
	jack? ( virtual/jack[${MULTILIB_USEDEP}] )
	openh264? ( media-libs/openh264:*[plugin,${MULTILIB_USEDEP}] )
	pulseaudio? (
		|| (
			media-sound/pulseaudio[${MULTILIB_USEDEP}]
			>=media-sound/apulse-0.1.12-r4[${MULTILIB_USEDEP}]
		)
	)
	selinux? ( sec-policy/selinux-mozilla )"

DEPEND="${CDEPEND}
	x11-libs/libICE[${MULTILIB_USEDEP}]
	x11-libs/libSM[${MULTILIB_USEDEP}]
	pulseaudio? (
		|| (
			media-sound/pulseaudio[${MULTILIB_USEDEP}]
			>=media-sound/apulse-0.1.12-r4[sdk,${MULTILIB_USEDEP}]
		)
	)
	wayland? ( >=x11-libs/gtk+-3.11:3[wayland,${MULTILIB_USEDEP}] )
	amd64? ( virtual/opengl[${MULTILIB_USEDEP}] )
	x86? ( virtual/opengl[${MULTILIB_USEDEP}] )"

S="${WORKDIR}/${PN}-${PV%_*}"
S_BAK="${WORKDIR}/${PN}-${PV%_*}"

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

	if use clang ; then
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
	ach af an ar ast az be bg bn br bs ca-valencia ca cak cs cy
	da de dsb el en-CA en-GB en-US eo es-AR es-CL es-ES es-MX et eu
	fa ff fi fr fy-NL ga-IE gd gl gn gu-IN he hi-IN hr hsb hu hy-AM
	ia id is it ja ka kab kk km kn ko lij lt lv mk mr ms my
	nb-NO ne-NP nl nn-NO oc pa-IN pl pt-BR pt-PT rm ro ru sco
	si sk sl son sq sr sv-SE szl ta te th tl tr trs uk ur uz vi
	xh zh-CN zh-TW
)

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
			emid=$(sed -n -e '/install-manifest/,$ { /em:id/!d; s/.*[\">]\([^\"<>]*\)[\"<].*/\1/; p; q }' "${xpi_tmp_dir}/install.rdf")
			[[ -z "${emid}" ]] && die "failed to determine extension id from install.rdf"
		elif [[ -f "${xpi_tmp_dir}/manifest.json" ]] ; then
			emid=$(sed -n -e 's/.*"id": "\([^"]*\)".*/\1/p' "${xpi_tmp_dir}/manifest.json")
			[[ -z "${emid}" ]] && die "failed to determine extension id from manifest.json"
		else
			die "failed to determine extension id"
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

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] ; then
		if use pgo ; then
			if ! has usersandbox $FEATURES ; then
				die "You must enable usersandbox as X server can not run as root!"
			fi
		fi

		# Ensure we have enough disk space to compile
		if use pgo || use lto || use debug ; then
			CHECKREQS_DISK_BUILD="13500M"
		else
			CHECKREQS_DISK_BUILD="6400M"
		fi

		check-reqs_pkg_pretend
	fi
}

NABIS=0
pkg_setup() {
	ewarn "This ebuild is a Work In Progress (WIP) / Testing.  It may freeze or lock up for both 32 and 64-bit builds."
	if [[ ${MERGE_TYPE} != binary ]] ; then
		if use pgo ; then
			if ! has userpriv ${FEATURES} ; then
				eerror "Building ${PN} with USE=pgo and FEATURES=-userpriv is not supported!"
			fi
		fi

		# Ensure we have enough disk space to compile
		if use pgo || use lto || use debug ; then
			CHECKREQS_DISK_BUILD="13500M"
		else
			CHECKREQS_DISK_BUILD="6400M"
		fi

		check-reqs_pkg_setup

		llvm_pkg_setup

		if use clang && use lto ; then
			local version_lld=$(ld.lld --version 2>/dev/null | awk '{ print $2 }')
			[[ -n ${version_lld} ]] && version_lld=$(ver_cut 1 "${version_lld}")
			[[ -z ${version_lld} ]] && die "Failed to read ld.lld version!"

			# temp fix for https://bugs.gentoo.org/768543
			# we can assume that rust 1.{49,50}.0 always uses llvm 11
			local version_rust=$(rustc -Vv 2>/dev/null | grep -F -- 'release:' | awk '{ print $2 }')
			[[ -n ${version_rust} ]] && version_rust=$(ver_cut 1-2 "${version_rust}")
			[[ -z ${version_rust} ]] && die "Failed to read version from rustc!"

			if ver_test "${version_rust}" -ge "1.49" && ver_test "${version_rust}" -le "1.50" ; then
				local version_llvm_rust="11"
			else
				local version_llvm_rust=$(rustc -Vv 2>/dev/null | grep -F -- 'LLVM version:' | awk '{ print $3 }')
				[[ -n ${version_llvm_rust} ]] && version_llvm_rust=$(ver_cut 1 "${version_llvm_rust}")
				[[ -z ${version_llvm_rust} ]] && die "Failed to read used LLVM version from rustc!"
			fi

			if ver_test "${version_lld}" -lt "${version_llvm_rust}" ; then
				eerror "Rust is using LLVM version ${version_llvm_rust} but ld.lld version belongs to LLVM version ${version_lld}."
				eerror "You will be unable to link ${CATEGORY}/${PN}. To proceed you have the following options:"
				eerror "  - Manually switch rust version using 'eselect rust' to match used LLVM version"
				eerror "  - Switch to dev-lang/rust[system-llvm] which will guarantee matching version"
				eerror "  - Build ${CATEGORY}/${PN} without USE=lto"
				die "LLVM version used by Rust (${version_llvm_rust}) does not match with ld.lld version (${version_lld})!"
			fi
		fi

		if ! use clang && [[ $(gcc-major-version) -eq 11 ]] \
			&& ! has_version -b ">sys-devel/gcc-11.1.0:11" ; then
			# bug 792705
			eerror "Using GCC 11 to compile firefox is currently known to be broken (see bug #792705)."
			die "Set USE=clang or select <gcc-11 to build ${CATEGORY}/${P}."
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

		if ! mountpoint -q /dev/shm ; then
			# If /dev/shm is not available, configure is known to fail with
			# a traceback report referencing /usr/lib/pythonN.N/multiprocessing/synchronize.py
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
		ewarn "Microphone support may be disabled when pulseaudio is disabled."
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

	for a in $(multilib_get_enabled_abis) ; do
		NABIS=$((${NABIS} + 1))
	done
}

src_unpack() {
	local _lp_dir="${WORKDIR}/language_packs"
	local _src_file

	if [[ ! -d "${_lp_dir}" ]] ; then
		mkdir "${_lp_dir}" || die
	fi

	for _src_file in ${A} ; do
		if [[ ${_src_file} == *.xpi ]]; then
			cp "${DISTDIR}/${_src_file}" "${_lp_dir}" || die "Failed to copy '${_src_file}' to '${_lp_dir}'!"
		else
			# TODO:  Add files with all-rights-reserved or crazy
			# licensing to the exclusion list if possible to
			# simpify LICENSE variable.
			unpack ${_src_file}
		fi
	done
}

verify_license_fingerprint() {
einfo "Verifying about:license fingerprint"
	x_license_fingerprint=$(sha512sum "${S}/toolkit/content/license.html" \
		| cut -f 1 -d " ")
	# Check even between patched versions and/or new features.
	if [[ -n "${FF_EBUILD_MAINTAINER}" ]] ; then
		local license_file_name="FF-$(ver_cut 1-2)-THIRD-PARTY-LICENSES"
		if [[ ! ( "${LICENSE}" =~ "${license_file_name}" ) \
			|| ! -f "${MY_OVERLAY_DIR}/licenses/${license_file_name}" \
			|| "${x_license_fingerprint}" != "${LICENSE_FINGERPRINT}" \
		]] ; then
eerror
eerror "A change in the license was detected.  Please change"
eerror "LICENSE_FINGERPRINT=${x_license_fingerprint} and copy the license file as"
eerror "follows:"
eerror "  \`cp -a ${S}/toolkit/content/license.html \
${MY_OVERLAY_DIR}/licenses/${license_file_name}\`"
eerror
			die
		fi
	else
		if [[ "${x_license_fingerprint}" != "${LICENSE_FINGERPRINT}" ]] ; then
eerror
eerror "A change in the license was detected.  Please notify the ebuild"
eerror "maintainer."
eerror
			die
		fi
	fi
}

src_prepare() {
	use lto && rm -v "${WORKDIR}"/firefox-patches/*-LTO-Only-enable-LTO-*.patch

	# Defer 0028-Make-elfhack-use-toolchain.patch in multilib_foreach_abi
	mv "${WORKDIR}/firefox-patches"/0028-Make-elfhack-use-toolchain.patch{,.bak} || die

	eapply "${WORKDIR}/firefox-patches"
	mv "${WORKDIR}/firefox-patches"/0028-Make-elfhack-use-toolchain.patch{.bak,} || die

	# Only partial patching was done because Gentoo doesn't support multilib
	# Python.  Only native ABI is supported.  This means cbindgen cannot
	# load the 32-bit clang.  It will build the cargo parts.  When it links
	# it, it fails because of cbindings is 64-bit and the dependencies use
	# the build information for 64-bit linking, which should be 32-bit.

	# Allow user to apply any additional patches without modifing ebuild
	eapply_user

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

	# sed-in toolchain prefix patch section was moved to the bottom of this function

	sed -i \
		-e 's/ccache_stats = None/return None/' \
		"${S}"/python/mozbuild/mozbuild/controller/building.py \
		|| die "sed failed to disable ccache stats call"

	einfo "Removing pre-built binaries ..."
	find "${S}"/third_party -type f \( -name '*.so' -o -name '*.o' \) -print -delete || die

	# Clearing checksums where we have applied patches
	moz_clear_vendor_checksums target-lexicon-0.9.0

	# Removed creation of a single build dir

	# Write API keys to disk
	echo -n "${MOZ_API_KEY_GOOGLE//gGaPi/}" > "${S}"/api-google.key || die
	echo -n "${MOZ_API_KEY_LOCATION//gGaPi/}" > "${S}"/api-location.key || die
	echo -n "${MOZ_API_KEY_MOZILLA//m0ap1/}" > "${S}"/api-mozilla.key || die

	xdg_src_prepare

	if [[ "${CFLAGS}" =~ "fast-math" || "${CXXFLAGS}" =~ "fast-math" ]] ; then
		pushd "${S}" || die
		eapply "${FILESDIR}/multiabi/firefox-78.0.2-opus-fast-math.patch"
		popd || die
	fi

	verify_license_fingerprint

	(( ${NABIS} > 1 )) \
		&& multilib_copy_sources

	_src_prepare() {
		if (( ${NABIS} == 1 )) ; then
			export BUILD_DIR="${S}"
		fi

		cd "${BUILD_DIR}" || die
		local chost=$(get_abi_CHOST ${DEFAULT_ABI})
		local ctarget=$(get_abi_CHOST ${ABI})
		if ( tc-is-cross-compiler && test -f "${ESYSROOT}/usr/bin/${ctarget}-objdump" ) \
			|| ( ! tc-is-cross-compiler && test -f "/usr/bin/${ctarget}-objdump" ) ; then
			eapply "${WORKDIR}/firefox-patches/0028-Make-elfhack-use-toolchain.patch"
			# sed-in toolchain prefix
			sed -i \
				-e "s/objdump/${ctarget}-objdump/" \
				"${BUILD_DIR}"/python/mozbuild/mozbuild/configure/check_debug_ranges.py \
				|| die "sed failed to set toolchain prefix"
			einfo "Using ${ctarget}-objdump for ctarget"
		else
			ewarn "Using objdump from chost"
		fi

		if ( tc-is-cross-compiler && test -f "${ESYSROOT}/usr/bin/${ctarget}-readelf" ) \
			|| ( ! tc-is-cross-compiler && test -f "/usr/bin/${ctarget}-readelf" ) ; then
			einfo "Using ${ctarget}-readelf for ctarget"
		else
			eapply "${FILESDIR}/multiabi/${PN}-84.0.1-check_binary-no-prefix-for-readelf.patch"
			eapply "${FILESDIR}/multiabi/${PN}-84.0.1-dependentlibs_py-no-toolchain-prefix-for-readelf.patch"
			ewarn "Using readelf from chost"
		fi
	}

	multilib_foreach_abi _src_prepare
}

# corrections based on the ABI being compiled
_fix_paths() {
	# For proper rust cargo cross-compile for libloading and glslopt
	export PKG_CONFIG=${ctarget}-pkg-config
	export CARGO_CFG_TARGET_ARCH=$(echo ${ctarget} | cut -f 1 -d "-")
	export MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"
	export BUILD_OBJ_DIR="${BUILD_DIR}/ff"

	# Set MOZCONFIG
	export MOZCONFIG="${BUILD_DIR}/.mozconfig"

	# for rust crates libloading and glslopt
	if use clang && ! tc-is-clang ; then
		CC=${ctarget}-clang
		CXX=${ctarget}-clang++
	elif ! use clang && ! tc-is-gcc ; then
		CC=${ctarget}-gcc
		CXX=${ctarget}-g++
	fi
	tc-export CC CXX
}

multilib_src_configure() {
	if (( ${NABIS} == 1 )) ; then
		export BUILD_DIR="${S}"
		cd "${BUILD_DIR}" || die
	fi

	local chost=$(get_abi_CHOST ${DEFAULT_ABI})
	local ctarget=$(get_abi_CHOST ${ABI})
	# Show flags set at the beginning
	einfo "Current BINDGEN_CFLAGS:\t${BINDGEN_CFLAGS:-no value set}"
	einfo "Current CFLAGS:\t\t${CFLAGS:-no value set}"
	einfo "Current CXXFLAGS:\t\t${CXXFLAGS:-no value set}"
	einfo "Current LDFLAGS:\t\t${LDFLAGS:-no value set}"
	einfo "Current RUSTFLAGS:\t\t${RUSTFLAGS:-no value set}"

	einfo "Cross-compile: ctarget=${ctarget}"
	local have_switched_compiler=
	if use clang && ! tc-is-clang ; then
		# Force clang
		einfo "Enforcing the use of clang due to USE=clang ..."
		have_switched_compiler=yes
		AR=llvm-ar
		CC=${ctarget}-clang
		CXX=${ctarget}-clang++
		NM=llvm-nm
		RANLIB=llvm-ranlib
	elif ! use clang && ! tc-is-gcc ; then
		# Force gcc
		have_switched_compiler=yes
		einfo "Enforcing the use of gcc due to USE=-clang ..."
		AR=gcc-ar
		CC=${ctarget}-gcc
		CXX=${ctarget}-g++
		NM=gcc-nm
		RANLIB=gcc-ranlib
	fi

	if [[ -n "${have_switched_compiler}" ]] ; then
		# Because we switched active compiler we have to ensure
		# that no unsupported flags are set
		strip-unsupported-flags
	fi

	# Ensure we use correct toolchain
	export HOST_CC="$(tc-getBUILD_CC)"
	export HOST_CXX="$(tc-getBUILD_CXX)"
	tc-export CC CXX LD AR NM OBJDUMP RANLIB PKG_CONFIG

	_fix_paths

	# Pass the correct toolchain paths through cbindgen
	if tc-is-cross-compiler ; then
		export BINDGEN_CFLAGS="${SYSROOT:+--sysroot=${ESYSROOT}} --host=${chost} --target=${ctarget} ${BINDGEN_CFLAGS-}"
	fi

	# MOZILLA_FIVE_HOME and MOZCONFIG are dynamically generated per ABI

	# python/mach/mach/mixin/process.py fails to detect SHELL
	export SHELL="${EPREFIX}/bin/bash"

	# Initialize MOZCONFIG
	mozconfig_add_options_ac '' --enable-application=browser

	# Set Gentoo defaults
	export MOZILLA_OFFICIAL=1

	mozconfig_add_options_ac 'Gentoo default' \
		--allow-addon-sideload \
		--disable-cargo-incremental \
		--disable-crashreporter \
		--disable-install-strip \
		--disable-strip \
		--disable-updater \
		--enable-official-branding \
		--enable-release \
		--enable-system-ffi \
		--enable-system-pixman \
		--host="${chost}" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--prefix="${EPREFIX}/usr" \
		--target="${ctarget}" \
		--without-ccache \
		--with-intl-api \
		--with-system-nspr \
		--with-system-nss \
		--with-system-png \
		--with-system-zlib \
		--with-toolchain-prefix="${ctarget}-" \
		--with-unsigned-addon-scopes=app,system \
		--x-includes="${SYSROOT}${EPREFIX}/usr/include" \
		--x-libraries="${SYSROOT}${EPREFIX}/usr/$(get_libdir)"

	# mozconfig_add_options_ac '' --with-libclang-path="$(${ctarget}-llvm-config --libdir)"
	#   disabled because Gentoo doesn't support multilib python, so full cross-compile is not supported.

	#   the commented above is mutually exclusive with this line below.
	mozconfig_add_options_ac '' --with-libclang-path="$(llvm-config --libdir)"

	# Set update channel
	local update_channel=release
	[[ -n ${MOZ_ESR} ]] && update_channel=esr
	mozconfig_add_options_ac '' --update-channel=${update_channel}

	if ! use x86 && [[ ${chost} != armv*h* ]] ; then
		mozconfig_add_options_ac '' --enable-rust-simd
	fi

	if [[ -s "${BUILD_DIR}/api-google.key" ]] ; then
		local key_origin="Gentoo default"
		if [[ $(cat "${BUILD_DIR}/api-google.key" | md5sum | awk '{ print $1 }') != 709560c02f94b41f9ad2c49207be6c54 ]] ; then
			key_origin="User value"
		fi

		mozconfig_add_options_ac "${key_origin}" \
			--with-google-safebrowsing-api-keyfile="${BUILD_DIR}/api-google.key"
	else
		einfo "Building without Google API key ..."
	fi

	if [[ -s "${BUILD_DIR}/api-location.key" ]] ; then
		local key_origin="Gentoo default"
		if [[ $(cat "${BUILD_DIR}/api-location.key" | md5sum | awk '{ print $1 }') != ffb7895e35dedf832eb1c5d420ac7420 ]] ; then
			key_origin="User value"
		fi

		mozconfig_add_options_ac "${key_origin}" \
			--with-google-location-service-api-keyfile="${BUILD_DIR}/api-location.key"
	else
		einfo "Building without Location API key ..."
	fi

	if [[ -s "${BUILD_DIR}/api-mozilla.key" ]] ; then
		local key_origin="Gentoo default"
		if [[ $(cat "${BUILD_DIR}/api-mozilla.key" | md5sum | awk '{ print $1 }') != 3927726e9442a8e8fa0e46ccc39caa27 ]] ; then
			key_origin="User value"
		fi

		mozconfig_add_options_ac "${key_origin}" \
			--with-mozilla-api-keyfile="${BUILD_DIR}/api-mozilla.key"
	else
		einfo "Building without Mozilla API key ..."
	fi

	mozconfig_use_with system-av1
	mozconfig_use_with system-harfbuzz
	mozconfig_use_with system-harfbuzz system-graphite2
	mozconfig_use_with system-icu
	mozconfig_use_with system-jpeg
	mozconfig_use_with system-libevent system-libevent "${SYSROOT}${EPREFIX}/usr"
	mozconfig_use_with system-libvpx
	mozconfig_use_with system-webp

	mozconfig_use_enable dbus

	use eme-free && mozconfig_add_options_ac '+eme-free' --disable-eme

	mozconfig_use_enable geckodriver

	if use hardened ; then
		mozconfig_add_options_ac "+hardened" --enable-hardening
		append-ldflags "-Wl,-z,relro -Wl,-z,now"
	fi

	mozconfig_use_enable jack

	mozconfig_use_enable pulseaudio
	# force the deprecated alsa sound code if pulseaudio is disabled
	if use kernel_linux && ! use pulseaudio ; then
		mozconfig_add_options_ac '-pulseaudio' --enable-alsa
	fi

	mozconfig_use_enable sndio

	mozconfig_use_enable wifi necko-wifi

	if use wayland ; then
		mozconfig_add_options_ac '+wayland' --enable-default-toolkit=cairo-gtk3-wayland
	else
		mozconfig_add_options_ac '' --enable-default-toolkit=cairo-gtk3
	fi

	if use lto ; then
		if use clang ; then
			# Upstream only supports lld when using clang
			mozconfig_add_options_ac "forcing ld=lld due to USE=clang and USE=lto" --enable-linker=lld

			mozconfig_add_options_ac '+lto' --enable-lto=cross
		else
			# ThinLTO is currently broken, see bmo#1644409
			mozconfig_add_options_ac '+lto' --enable-lto=full
		fi

		if use pgo ; then
			mozconfig_add_options_ac '+pgo' MOZ_PGO=1

			if use clang ; then
				# Used in build/pgo/profileserver.py
				export LLVM_PROFDATA="llvm-profdata"
			fi
		fi
	else
		# Avoid auto-magic on linker
		if use clang ; then
			# This is upstream's default
			mozconfig_add_options_ac "forcing ld=lld due to USE=clang" --enable-linker=lld
		else
			mozconfig_add_options_ac "linker is set to bfd" --enable-linker=bfd
		fi
	fi

	# LTO flag was handled via configure
	filter-flags '-flto*'

	mozconfig_use_enable debug
	if use debug ; then
		mozconfig_add_options_ac '+debug' --disable-optimize
	else
		if is-flag '-g*' ; then
			if use clang ; then
				mozconfig_add_options_ac 'from CFLAGS' --enable-debug-symbols=$(get-flag '-g*')
			else
				mozconfig_add_options_ac 'from CFLAGS' --enable-debug-symbols
			fi
		else
			mozconfig_add_options_ac 'Gentoo default' --disable-debug-symbols
		fi

		if is-flag '-O0' ; then
			mozconfig_add_options_ac "from CFLAGS" --enable-optimize=-O0
		elif is-flag '-O4' ; then
			mozconfig_add_options_ac "from CFLAGS" --enable-optimize=-O4
		elif is-flag '-O3' ; then
			mozconfig_add_options_ac "from CFLAGS" --enable-optimize=-O3
		elif is-flag '-O1' ; then
			mozconfig_add_options_ac "from CFLAGS" --enable-optimize=-O1
		elif is-flag '-Os' ; then
			mozconfig_add_options_ac "from CFLAGS" --enable-optimize=-Os
		else
			mozconfig_add_options_ac "Gentoo default" --enable-optimize=-O2
		fi
	fi

	# Debug flag was handled via configure
	filter-flags '-g*'

	# Optimization flag was handled via configure
	filter-flags '-O*'

	# Modifications to better support ARM, bug #553364
	if use cpu_flags_arm_neon ; then
		mozconfig_add_options_ac '+cpu_flags_arm_neon' --with-fpu=neon

		if ! tc-is-clang ; then
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
				"${BUILD_DIR}"/media/libvpx/moz.build \
				|| die
		fi
	fi

	if use clang ; then
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
			mozconfig_add_options_ac 'elf-hack is broken when using Clang' --disable-elf-hack
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
			if use clang ; then
				# Nothing to do
				:;
			elif tc-ld-is-gold || use lto ; then
				append-ldflags -Wl,--no-keep-memory
			else
				append-ldflags -Wl,--no-keep-memory -Wl,--reduce-memory-overheads
			fi
			;;
	esac

	if ! use elibc_glibc ; then
		mozconfig_add_options_ac '!elibc_glibc' --disable-jemalloc
	fi

	# Allow elfhack to work in combination with unstripped binaries
	# when they would normally be larger than 2GiB.
	append-ldflags "-Wl,--compress-debug-sections=zlib"

	# Make revdep-rebuild.sh happy; Also required for musl
	append-ldflags -Wl,-rpath="${MOZILLA_FIVE_HOME}",--enable-new-dtags

	# Pass $MAKEOPTS to build system
	export MOZ_MAKE_FLAGS="${MAKEOPTS}"

	# Use system's Python environment
	export MACH_USE_SYSTEM_PYTHON=1

	# Disable notification when build system has finished
	export MOZ_NOSPAM=1

	# Portage sets XARGS environment variable to "xargs -r" by default which
	# breaks build system's check_prog() function which doesn't support arguments
	mozconfig_add_options_ac 'Gentoo default' "XARGS=${EPREFIX}/usr/bin/xargs"

	# Set build dir
	mozconfig_add_options_mk 'Gentoo default' "MOZ_OBJDIR=${BUILD_OBJ_DIR}"

	if ! use jemalloc ; then
		mozconfig_add_options_ac '-jemalloc' --disable-jemalloc
	else
		mozconfig_add_options_ac '+jemalloc' --enable-jemalloc
	fi

	einfo "Cross-compile: ${ABI} CFLAGS=${CFLAGS}"
	einfo "Cross-compile: CC=${CC} CXX=${CXX}"
	echo "export PKG_CONFIG=${ctarget}-pkg-config" >>${MOZCONFIG}
	echo "export PKG_CONFIG_PATH=/usr/$(get_libdir)/pkgconfig:/usr/share/pkgconfig" >>${MOZCONFIG}

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

multilib_src_compile() {
	if (( ${NABIS} == 1 )) ; then
		export BUILD_DIR="${S}"
		cd "${BUILD_DIR}" || die
	fi

	local chost=$(get_abi_CHOST ${DEFAULT_ABI})
	local ctarget=$(get_abi_CHOST ${ABI})
	_fix_paths
	cd "${BUILD_DIR}" || die
	local virtx_cmd=

	if use pgo ; then
		virtx_cmd=virtx

		# Reset and cleanup environment variables used by GNOME/XDG
		gnome2_environment_reset

		addpredict /root
	fi

	local -x GDK_BACKEND=x11

	${virtx_cmd} ./mach build --verbose \
		|| die
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
# Installs licenses and copyright notices from third party rust cargo
# packages and other internal packages.
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

	_install_header_license \
		"modules/fdlibm/src/math_private.h" \
		"SunPro.LICENSE" \
		10
	_install_header_license \
		"js/src/tests/test262/built-ins/RegExp/S15.10.2_A1_T1.js" \
		"S15.10.2_A1_T1.js.LICENSE" \
		17
	_install_header_license \
		"testing/web-platform/tests/css/tools/w3ctestlib/catalog/xhtml11.dtd" \
		"xhtml11.dtd.LICENSE" \
		27

	# Duped because of must not alter clause
	_install_header_license \
		"gfx/sfntly/cpp/src/test/tinyxml/tinyxml.cpp" \
		"tinyxml.LICENSE1" \
		23
	_install_header_license \
		"gfx/sfntly/cpp/src/test/tinyxml/tinyxmlerror.cpp" \
		"tinyxml.LICENSE2" \
		23
	_install_header_license \
		"gfx/sfntly/cpp/src/test/tinyxml/tinyxml.h" \
		"tinyxml.LICENSE3" \
		23
	_install_header_license \
		"gfx/sfntly/cpp/src/test/tinyxml/tinystr.cpp" \
		"tinyxml.LICENSE4" \
		22

	_install_header_license \
		"third_party/msgpack/include/msgpack/predef/compiler/ibm.h" \
		"ibm.h.copyright_notice" \
		6

	_install_header_license \
		"media/ffvpx/libavutil/adler32.c" \
		"adler32.c.LICENSE" \
		22

	_install_header_license \
		"js/src/octane/box2d.js" \
		"box2d.LICENSE" \
		19

	_install_header_license \
		"devtools/client/shared/vendor/jszip.js" \
		"jszip.js.LICENSE1" \
		11
	_install_header_license_mid \
		"devtools/client/shared/vendor/jszip.js" \
		"jszip.js.LICENSE2" \
		5689 \
		18

	# Duped because of must not alter clause
	for f in $(grep -r -l -F -e "origin of this software" \
		media/libjpeg) ; do
		_install_header_license \
			$(echo "${f}" | sed -e "s|^./||g") \
			$(basename "${f}")".LICENSE" \
			32
	done

	_install_header_license \
		"mfbt/Span.h" \
		"Span.h.LICENSE" \
		15

	_install_header_license \
		"media/openmax_dl/dl/api/omxtypes.h" \
		"omxtypes.h.LICENSE" \
		31

	_install_header_license \
		"devtools/client/shared/widgets/CubicBezierWidget.js" \
		"CubicBezierWidget.js.LICENSE" \
		21

	_install_header_license \
		"netwerk/dns/nsIDNKitInterface.h" \
		"nsIDNKitInterface.h.LICENSE" \
		41

	_install_header_license \
		"gfx/qcms/qcms.h" \
		"qcms.h.LICENSE" \
		41

	touch "${T}/.copied_licenses"
}

multilib_src_install() {
	if (( ${NABIS} == 1 )) ; then
		export BUILD_DIR="${S}"
	fi

	local chost=$(get_abi_CHOST ${DEFAULT_ABI})
	local ctarget=$(get_abi_CHOST ${ABI})
	_fix_paths
	cd "${BUILD_DIR}" || die
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
	newins "${FILESDIR}"/gentoo-default-prefs.js all-gentoo.js

	local GENTOO_PREFS="${ED}${PREFS_DIR}/all-gentoo.js"

	# Set dictionary path to use system hunspell
	cat >>"${GENTOO_PREFS}" <<-EOF || die "failed to set spellchecker.dictionary_path pref"
	pref("spellchecker.dictionary_path",       "${EPREFIX}/usr/share/myspell");
	EOF

	# Force hwaccel prefs if USE=hwaccel is enabled
	if use hwaccel ; then
		cat "${FILESDIR}"/gentoo-hwaccel-prefs.js \
		>>"${GENTOO_PREFS}" \
		|| die "failed to add prefs to force hardware-accelerated rendering to all-gentoo.js"
	fi

	if ! use gmp-autoupdate ; then
		local plugin
		for plugin in "${MOZ_GMP_PLUGIN_LIST[@]}" ; do
			einfo "Disabling auto-update for ${plugin} plugin ..."
			cat >>"${GENTOO_PREFS}" <<-EOF || die "failed to disable autoupdate for ${plugin} media plugin"
			pref("media.${plugin}.autoupdate",   false);
			EOF
		done
	fi

	# Force the graphite pref if USE=system-harfbuzz is enabled, since the pref cannot disable it
	if use system-harfbuzz ; then
		cat >>"${GENTOO_PREFS}" <<-EOF || die "failed to set gfx.font_rendering.graphite.enabled pref"
		sticky_pref("gfx.font_rendering.graphite.enabled", true);
		EOF
	fi

	# Install language packs
	local langpacks=( $(find "${WORKDIR}/language_packs" -type f -name '*.xpi') )
	if [[ -n "${langpacks}" ]] ; then
		moz_install_xpi "${MOZILLA_FIVE_HOME}/distribution/extensions" "${langpacks[@]}"
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
	local icon_srcdir="${BUILD_DIR}/browser/branding/official"
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
	local desktop_file="${FILESDIR}/icon/${PN}-r2.desktop"
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
		elog "USE='-gmp-autoupdate' has disabled the following plugins from updating or"
		elog "installing into new profiles:"
		local plugin
		for plugin in "${MOZ_GMP_PLUGIN_LIST[@]}" ; do
			elog "\t ${plugin}"
		done
		elog
	fi

	if use pulseaudio && has_version ">=media-sound/apulse-0.1.12-r4" ; then
		elog "Apulse was detected at merge time on this system and so it will always be"
		elog "used for sound.  If you wish to use pulseaudio instead please unmerge"
		elog "media-sound/apulse."
		elog
	fi

	local show_doh_information show_normandy_information show_shortcut_information

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
		elog "Due to privacy concerns (encrypting DNS might be a good thing, sending all"
		elog "DNS traffic to Cloudflare by default is not a good idea and applications"
		elog "should respect OS configured settings), \"network.trr.mode\" was set to 5"
		elog "(\"Off by choice\") by default."
		elog "You can enable DNS-over-HTTPS in ${PN^}'s preferences."
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
	fi

	if [[ -n "${show_shortcut_information}" ]] ; then
		elog
		elog "Since firefox-91.0 we no longer install multiple shortcuts for"
		elog "each supported display protocol.  Instead we will only install"
		elog "one generic Mozilla Firefox shortcut."
		elog "If you still want to be able to select between running Mozilla Firefox"
		elog "on X11 or Wayland, you have to re-create these shortcuts on your own."
	fi

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
# Reported in bugid 1010527, 1646007, 1449901
einfo "WebGL performance is suboptimal and runs at ~40 FPS.  There is currently"
einfo "no fix for this."
einfo
}
