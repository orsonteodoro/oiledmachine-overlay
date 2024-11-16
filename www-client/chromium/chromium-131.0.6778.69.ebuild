# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2009-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Monitor
#   https://chromereleases.googleblog.com/search/label/Dev%20updates
# for security updates.  They are announced faster than NVD.
# See https://chromiumdash.appspot.com/releases?platform=Linux for the latest linux version

EAPI=8

# Patchsets
# https://github.com/ungoogled-software/ungoogled-chromium
# https://github.com/uazo/cromite

# Ebuild diff or sync update notes:
# 128.0.6613.119 -> 128.0.6613.137
# 129.0.6668.89 -> 129.0.6668.100
# 129.0.6668.100 -> 130.0.6723.91
# 130.0.6723.91 -> 131.0.6778.69

# For depends see:
# https://github.com/chromium/chromium/tree/131.0.6778.69/build/linux/sysroot_scripts/generated_package_lists				; Last update 20240501
#   alsa-lib, at-spi2-core, bluez (bluetooth), cairo, cups, curl, expat,
#   flac [older], fontconfig [older], freetype [older], gcc, gdk-pixbuf, glib,
#   glibc [missing check], gtk+3, gtk4, harfbuzz [older], libdrm [older], libffi, libglvnd,
#   libjpeg-turbo [older], libpng [older], libva, libwebp [older], libxcb,
#   libxcomposite, libxcursor, libxdamage, libxext, libxfixes, libx11, libxi,
#   libxkbcommon, libxml2 [older], libxrandr, libxrender, libxshmfence,
#   libxslt [older], nspr, nss, opus [older], pango, pciutils, pipewire,
#   libpulse, qt5, qt6, re2 [older], systemd, udev, wayland, zlib [older]
# https://github.com/chromium/chromium/blob/131.0.6778.69/build/install-build-deps.py

#
# Additional DEPENDS versioning info:
#
# https://github.com/chromium/chromium/blob/131.0.6778.69/third_party/dav1d/version/vcs_version.h#L2					; newer than generated_package_lists
# https://github.com/chromium/chromium/blob/131.0.6778.69/third_party/libaom/source/config/config/aom_version.h#L19			; newer than generated_package_lists
# https://github.com/chromium/chromium/blob/131.0.6778.69/third_party/libpng/png.h#L288							; newer than generated_package_lists
# https://github.com/chromium/chromium/blob/131.0.6778.69/third_party/libxml/linux/config.h#L160					; older than generated_package_lists
# https://github.com/chromium/chromium/blob/131.0.6778.69/third_party/libxslt/linux/config.h#L116					; newer than generated_package_lists
# https://github.com/chromium/chromium/blob/131.0.6778.69/third_party/node/update_node_binaries#L18
# https://github.com/chromium/chromium/blob/131.0.6778.69/third_party/re2/README.chromium#L4						; newer than generated_package_lists, (live) [rounded in ebuild]
# https://github.com/chromium/chromium/blob/131.0.6778.69/third_party/zlib/zlib.h#L40
# https://github.com/chromium/chromium/blob/131.0.6778.69/tools/rust/update_rust.py#L35							; commit
#   https://github.com/rust-lang/rust/blob/3cf924b934322fd7b514600a7dc84fc517515346/src/version						; live version
# /var/tmp/portage/www-client/chromium-131.0.6778.69/work/chromium-131.0.6778.69/third_party/flac/BUILD.gn			L122	; newer than generated_package_lists
# /var/tmp/portage/www-client/chromium-131.0.6778.69/work/chromium-131.0.6778.69/third_party/fontconfig/src/fontconfig/fontconfig.h L54 ; newer than generated_package_lists
# /var/tmp/portage/www-client/chromium-131.0.6778.69/work/chromium-131.0.6778.69/third_party/freetype/src/CMakeLists.txt	L165	; newer than generated_package_lists *
# /var/tmp/portage/www-client/chromium-131.0.6778.69/work/chromium-131.0.6778.69/third_party/harfbuzz-ng/src/configure.ac	L3	; newer than generated_package_lists
# /var/tmp/portage/www-client/chromium-131.0.6778.69/work/chromium-131.0.6778.69/third_party/icu/source/configure		L585	; newer than generated_package_lists
# /var/tmp/portage/www-client/chromium-131.0.6778.69/work/chromium-131.0.6778.69/third_party/libdrm/src/meson.build		L24	; newer than generated_package_lists *
# /var/tmp/portage/www-client/chromium-131.0.6778.69/work/chromium-131.0.6778.69/third_party/libjpeg_turbo/jconfig.h		L7	; newer than generated_package_lists
# /var/tmp/portage/www-client/chromium-131.0.6778.69/work/chromium-131.0.6778.69/third_party/libwebp/src/configure.ac		L1	; newer than generated_package_lists
# /var/tmp/portage/www-client/chromium-131.0.6778.69/work/chromium-131.0.6778.69/third_party/openh264/src/meson.build		L2
# /var/tmp/portage/www-client/chromium-131.0.6778.69/work/chromium-131.0.6778.69/third_party/opus/README.chromium		L3	; newer than generated_package_lists, live
#   https://gitlab.xiph.org/xiph/opus/-/commit/8cf872a186b96085b1bb3a547afd598354ebeb87							; see tag
# /var/tmp/portage/www-client/chromium-131.0.6778.69/work/chromium-131.0.6778.69/third_party/zstd/README.chromium			; live version
#   https://github.com/facebook/zstd/commit/0ff651dd876823b99fa5c5f53292be28381aee9b							; check if commit part of tag
#   https://github.com/facebook/zstd/blob/0ff651dd876823b99fa5c5f53292be28381aee9b/lib/zstd.h#L107					; version
# https://github.com/chromium/chromium/blob/131.0.6778.69/DEPS#L512									; live
#   git clone https://gn.googlesource.com/gn
#   git checkout <commit-id>
#   v=$(git describe HEAD --abbrev=12 | cut -f 3 -d "-")
#   python -c "print(${v}/10000)" or echo "0.${v}"

CFI_CAST=0 # Global variable
CFI_ICALL=0 # Global variable
CFI_VCALL=0 # Global variable
CHROMIUM_EBUILD_MAINTAINER=0 # See also GEN_ABOUT_CREDITS

#
# Set to 1 below to generate an about_credits.html including bundled internal
# dependencies.
#
GEN_ABOUT_CREDITS=0
#

# One of the major sources of lag comes from dependencies
# These are strict to match performance to competition or normal builds.
declare -A CFLAGS_RDEPEND=(
	["media-libs/dav1d"]=">=;-O2" # -O0 skippy, -O1 faster but blurry, -Os blurry still, -O2 not blurry
)

# LANGS obtainable from:
# src="./build/config/locales.gni"
# s=$(grep -n "all_chrome_locales =" "${src}" | cut -f 1 -d ":") ; \
# f=$(grep -F -n "+ pseudolocales" "${src}" | cut -f 1 -d ":") ; \
# sed -ne "${s},${f}p" "${src}" \
#	| grep "\"" \
#	| cut -f 2 -d "\"" \
#	| tr "\n" " " \
#	| sed -E -e "s/(as|az|be|bs|cy|eu|fr-CA|gl|hy|is|ka|kk|km|ky|lo|mk|mn|my|ne|or|pa|si|sq|sr-Latn|uz|zh-HK|zu)[ ]?//g" \
#	| fold -s -w 80 \
#	| sed -e "s| $||g"

CHROMIUM_LANGS="
af am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi hr
hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv sw ta
te th tr uk ur vi zh-CN zh-TW
"

CROMITE_COMMIT="5a4953031c9c9322dda2d3bba3ef23d33c753005" # Based on most recent either tools/under-control/src/RELEASE or build/RELEASE
CROMITE_PV="129.0.6668.101"

# About PGO version compatibility
#
# The answer to the profdata compatibility is answered in
# https://clang.llvm.org/docs/SourceBasedCodeCoverage.html#format-compatibility-guarantees
#
# The profdata (aka indexed profile) version is 10 corresponding from LLVM 16+
# and is after the magic (lprofi - i for index) in the profdata file located in
# chrome/build/pgo_profiles/*.profdata.
#
# Profdata versioning:
# https://github.com/llvm/llvm-project/blob/ecea8371/llvm/include/llvm/ProfileData/InstrProf.h#L1024
# LLVM version:
# https://github.com/llvm/llvm-project/blob/ecea8371/llvm/CMakeLists.txt#L14

# LLVM 19
# LLVM timestamp can be obtained from \
# https://github.com/chromium/chromium/blob/131.0.6778.69/tools/clang/scripts/update.py#L42 \
# https://github.com/llvm/llvm-project/commit/69c43468
# Change also LLVM_OFFICIAL_SLOT
CURRENT_PROFDATA_VERSION= # Global variable
CURRENT_PROFDATA_LLVM_VERSION= # Global variable
DISABLE_AUTOFORMATTING="yes"
DISK_BASE=24
declare -A DISK_BUILD
DISK_BUILD["debug"]=$((${DISK_BASE} + 13))
DISK_BUILD["pgo"]=$((${DISK_BASE} + 8))
DISK_BUILD["lto"]=$((${DISK_BASE} + 9))
DISK_BUILD["fallback"]=$((${DISK_BASE} + 1))
# See also
# third_party/ffmpeg/libavutil/version.h
# third_party/ffmpeg/libavcodec/version*.h
# third_party/ffmpeg/libavformat/version*.h
FFMPEG_SLOT="0/59.61.61" # Same as ffmpeg 7.0 ; 0/libavutil_sover_maj.libavcodec_sover_maj.libformat_sover_maj
GCC_COMPAT=( {14..10} )
GCC_PV="10.2.1" # Minimum
GCC_SLOT="" # Global variable
GN_PV="0.2198"
GN_COMMIT="20806f79c6b4ba295274e3a589d85db41a02fdaa"
GTK3_PV="3.24.24"
GTK4_PV="4.8.3"
LIBVA_PV="2.17.0"
# SHA512 about_credits.html fingerprint: \
LICENSE_FINGERPRINT="\
bf40306865f31b7115feeab6d767da4b56c812d4e0bb9aa69ed4703c8a9061e0\
886a9fc90f54fe8a500885a315e5917907953649d8cf56c157b73261b55d1814\
"
LLVM_COMPAT=( 20 19 ) # [inclusive, inclusive] high to low ; LLVM_OFFICIAL_SLOT+1 or LLVM_OFFICIAL_SLOT-1 major version allowed.
LLVM_MAX_SLOT="${LLVM_COMPAT[0]}" # Max is the same slot listed in https://github.com/chromium/chromium/blob/131.0.6778.69/tools/clang/scripts/update.py#L42
LLVM_MIN_SLOT="${LLVM_COMPAT[-1]}" # Min is the pregenerated PGO profile needed for INSTR_PROF_INDEX_VERSION version 12 compatibility for the profdata file format.
LLVM_OFFICIAL_SLOT="20" # Cr official slot
LLVM_SLOT="" # Global variable
LTO_TYPE="" # Global variable
MESA_PV="20.3.5"
MITIGATION_DATE="Nov 12, 2024" # Official annoucement (blog)
MITIGATION_LAST_UPDATE=1731354660 # From `date +%s -d "2024-11-11 11:51 AM PST"` From tag in GH
MITIGATION_URI="https://chromereleases.googleblog.com/2024/11/stable-channel-update-for-desktop_12.html"
VULNERABILITIES_FIXED=(
	"CVE-2024-11112;DoS, DT, ID;High"
	"CVE-2024-11113;DoS, DT, ID;High"
	"CVE-2024-11114;DoS, DT, ID;High"
	"CVE-2024-11115;DoS, DT, ID;High"
	"CVE-2024-11110;DT;Medium"
	"CVE-2024-11111;DT;Medium"
	"CVE-2024-11116;DT;Medium"
	"CVE-2024-11117;DT;Medium"
)
NABIS=0 # Global variable
NODE_VERSION=20
PPC64_HASH="a85b64f07b489b8c6fdb13ecf79c16c56c560fc6"
PATCHSET_PPC64="128.0.6613.84-1raptor0~deb12u1"
PATCH_REVISION="-1"
PATCH_VER="${PV%%\.*}${PATCH_REVISION}"
PGO_LLVM_SUPPORTED_VERSIONS=(
	"20.0.0.9999"
	"20.0.0"
	"${LLVM_OFFICIAL_SLOT}.0.0.9999"
	"${LLVM_OFFICIAL_SLOT}.0.0"
)
PREGENERATED_PGO_PROFILE_MIN_LLVM_SLOT="${LLVM_MIN_SLOT}"
PYTHON_COMPAT=( "python3_"{9..13} )
PYTHON_REQ_USE="xml(+)"
QT5_PV="5.15.2"
QT6_PV="6.4.2"
UNGOOGLED_CHROMIUM_PV="130.0.6723.91-1"
USE_LTO=0 # Global variable
# https://github.com/chromium/chromium/blob/131.0.6778.69/tools/clang/scripts/update.py#L38 \
# grep 'CLANG_REVISION = ' ${S}/tools/clang/scripts/update.py -A1 | cut -c 18- # \
LLVM_COMMIT="3dbd929e"
LLVM_N_COMMITS="6794"
LLVM_OFFICIAL_SLOT="20" # Cr official slot
LLVM_SUB_REV="1"
TEST_FONT="f26f29c9d3bfae588207bbc9762de8d142e58935c62a86f67332819b15203b35"
VENDORED_CLANG_VER="llvmorg-${LLVM_OFFICIAL_SLOT}-init-${LLVM_N_COMMITS}-g${LLVM_COMMIT:0:8}-${LLVM_SUB_REV}"
# https://github.com/chromium/chromium/blob/131.0.6778.69/tools/rust/update_rust.py#L37 \
# grep 'RUST_REVISION = ' ${S}/tools/rust/update_rust.py -A1 | cut -c 17- # \
RUST_COMMIT="f5cd2c5888011d4d80311e5b771c6da507d860dd"
RUST_NEEDS_LLVM="yes please"
RUST_SUB_REV="2"
RUST_PV="1.81.0" # See https://github.com/rust-lang/rust/blob/f5cd2c5888011d4d80311e5b771c6da507d860dd/RELEASES.md
RUSTC_VER="" # Global variable
SHADOW_CALL_STACK=0 # Global variable
S_CROMITE="${WORKDIR}/cromite-${CROMITE_COMMIT}"
S_UNGOOGLED_CHROMIUM="${WORKDIR}/ungoogled-chromium-${UNGOOGLED_CHROMIUM_PV}"
TESTDATA_P="${PN}-${PV}"
VENDORED_RUST_VER="${RUST_COMMIT}-${RUST_SUB_REV}"
ZLIB_PV="1.3"

inherit cflags-depends check-linker check-reqs chromium-2 dhms desktop edo
inherit flag-o-matic flag-o-matic-om linux-info lcnr llvm multilib-minimal
inherit multiprocessing ninja-utils pax-utils python-any-r1 qmake-utils
inherit readme.gentoo-r1 rust systemd toolchain-funcs xdg-utils

is_cromite_compatible() {
	local c4_min=$(ver_cut 4 ${PV})
	local c4_max=$(ver_cut 4 ${PV})
	c4_min=$(( ${c4_min} - 10 ))
	c4_max=$(( ${c4_max} + 10 ))

	if ver_test "${PV%.*}.${c4_min}" -le "${CROMITE_PV}" && ver_test "${CROMITE_PV}" -le "${PV%.*}.${c4_max}" ; then
		return 0
	else
		return 1
	fi
}

if [[ "${PATCHSET_PPC64%%.*}" == "${PV%%.*}" ]] ; then
	KEYWORDS="~amd64 ~arm64 ~ppc64"
else
	KEYWORDS="~amd64 ~arm64"
fi
KEYWORDS=""
SRC_URI="
	ppc64? (
		https://gitlab.solidsilicon.io/public-development/open-source/chromium/openpower-patches/-/archive/${PPC64_HASH}/openpower-patches-${PPC64_HASH}.tar.bz2
			-> chromium-openpower-${PPC64_HASH:0:10}.tar.bz2
	)
	system-toolchain? (
		https://gitlab.com/Matt.Jolly/chromium-patches/-/archive/${PATCH_VER}/chromium-patches-${PATCH_VER}.tar.bz2
	)
	test? (
		https://chromium-tarballs.distfiles.gentoo.org/${P}-testdata.tar.xz
			-> ${P}-testdata-gentoo.tar.xz
		https://chromium-fonts.storage.googleapis.com/${TEST_FONT}
			-> chromium-${PV%%\.*}-testfonts.tar.gz
	)
"
if is_cromite_compatible ; then
	IUSE+="
		cromite
	"
	SRC_URI+="
		cromite? (
			https://github.com/uazo/cromite/archive/${CROMITE_COMMIT}.tar.gz
				-> cromite-${CROMITE_COMMIT:0:7}.tar.gz
		)
	"
fi
if [[ "${UNGOOGLED_CHROMIUM_PV%-*}" == "${PV}" ]] ; then
	IUSE+="
		ungoogled-chromium
	"
	SRC_URI+="
		ungoogled-chromium? (
			https://github.com/ungoogled-software/ungoogled-chromium/archive/refs/tags/${UNGOOGLED_CHROMIUM_PV}.tar.gz
				-> ungoogled-chromium-${UNGOOGLED_CHROMIUM_PV}.tar.gz
		)
	"
fi

DESCRIPTION="The open-source version of the Chrome web browser"
HOMEPAGE="https://www.chromium.org/"
# emerge does not understand ^^ in the LICENSE variable and have been replaced
# with ||.  You should choose at most one at some instances.
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	(
		CC-BY-SA-4.0
		ISC
	)
	(
		CC0-1.0
		MIT
	)
	(
		all-rights-reserved
		HPND
	)
	Alliance-for-Open-Media-Patent-License-1.0
	APSL-2
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	base64
	Boost-1.0
	BSD
	BSD-2
	BSD-4
	CC-BY-3.0
	CC-BY-4.0
	CC-BY-ND-2.5
	CC0-1.0
	chromium-$(ver_cut 1-3 ${PV}).x.html
	custom
	fft2d
	FLEX
	FTL
	g711
	g722
	GPL-2+
	HPND
	icu
	IJG
	ILA-OpenCV
	ISC
	Khronos-CLHPP
	LGPL-2
	LGPL-2+
	LGPL-2.1+
	libpng2
	libvpx-PATENTS
	libwebrtc-PATENTS
	MIT
	MPL-1.1
	MPL-2.0
	neon_2_sse
	OFL-1.1
	ooura
	openssl
	PSF-2.4
	QU-fft
	Unlicense
	UoI-NCSA
	unicode
	Unicode-DFS-2016
	unRAR
	SGI-B-2.0
	sigslot
	SunPro
	svgo
	trio
	W3C
	W3C-Document-License-2002
	WTFPL-2
	x11proto
	ZLIB
	widevine? (
		widevine
	)
	|| (
		GPL-2
		LGPL-2.1
		MPL-1.1
	)
	|| (
		(
			GPL-2+
			MPL-2.0
		)
		(
			LGPL-2.1+
			MPL-2.0
		)
		GPL-2.0+
		MPL-2.0
	)
"
if is_cromite_compatible ; then
	LICENSE+="
		cromite? (
			GPL-3
			GPL-2+
		)
	"
fi
if [[ "${UNGOOGLED_CHROMIUM_PV%-*}" == "${PV}" ]] ; then
	LICENSE+="
		ungoogled-chromium? (
			BSD
		)
	"
fi

#
# Benchmark website licenses:
# See the webkit-gtk ebuild
#
# BSD-2 BSD LGPL-2.1 - Kraken benchmark
#   ( ( all-rights-reserved || ( MIT AFL-2.1 ) ) (MIT GPL) BSD MIT )
#   ( all-rights-reserved GPL-3+ ) tests/kraken-1.0/audio-beat-detection-data.js
#   MPL-1.1 tests/kraken-1.0/imaging-desaturate.js
#   public-domain hosted/json2.js
#   || ( MPL-1.1 GPL-2+ LGPL-2.1+ )
#   || ( BSD GPL-2 ) ; for SJCL

# Third Party Licenses:
#
# TODO:  The rows marked custom need to have or be placed a license file or
#        reevaluated.
# TODO:  scan all font files for embedded licenses
#
# Alliance-for-Open-Media-Patent-License-1.0 third_party/libaom/source/libaom/PATENTS
# APSL-2 - third_party/apple_apsl/LICENSE
# APSL-2 Apache-2.0 BSD MIT - third_party/breakpad/LICENSE
# Apache-2.0 - CIPD - https://chromium.googlesource.com/infra/luci/luci-go/+/refs/heads/main/cipd
# Apache-2.0 - third_party/node/node_modules/typescript/LICENSE.txt
# Apache-2.0-with-LLVM-exceptions UoI-NCSA - \
#   third_party/llvm/debuginfo-tests/dexter/LICENSE.txt
# Apache-2.0-with-LLVM-exceptions UoI-NCSA MIT - third_party/llvm/libclc/LICENSE.TXT
# all-rights-reserved MIT - third_party/xcbproto/LICENSE ; the plain MIT \
#   license doesn't come with all rights reserved in the license template
# BSD - third_party/vulkan-deps/glslang/src/LICENSE.txt
# BSD || ( MPL-1.1 GPL-2+ LGPL-2+ ) - \
#   third_party/openscreen/src/third_party/mozilla/LICENSE.txt
# BSD CC-BY-3.0 CC-BY-4.0 MIT public-domain - third_party/snappy/src/COPYING
# BSD HPND (modified) - native_client_sdk/src/libraries/third_party/newlib-extras/netdb.h
# BSD ISC MIT openssl - third_party/boringssl/src/LICENSE
# BSD || ( MPL-1.1 GPL-2+ LGPL-2+ ) - url/third_party/mozilla/LICENSE.txt
# BSD-2 - third_party/node/node_modules/eslint-scope/LICENSE
# BSD-2 IJG MIT - third_party/libavif/src/LICENSE
# BSD-2 - third_party/libaom/source/libaom/LICENSE
# base64 - third_party/webrtc/rtc_base/third_party/base64/LICENSE
# custom - out/Release/gen/components/resources/about_credits.html [Same as chromium-121.0.6167.x.html license file]
#   keyword search: "venue in the state and federal courts"
# custom - third_party/llvm/clang-tools-extra/clang-tidy/cert/LICENSE.TXT
# custom - third_party/llvm/clang-tools-extra/clang-tidy/hicpp/LICENSE.TXT
# custom ^^ ( BSD-2 BSD ) - third_party/blink/LICENSE_FOR_ABOUT_CREDITS
# custom Apache-2.0-with-LLVM-exceptions UoI-NCSA third_party/llvm/openmp/LICENSE.TXT
# custom CC-BY-ND-2.5 LGPL-2.1+ GPL-2+ public-domain - \
#   third_party/blink/perf_tests/svg/resources/LICENSES
# custom BSD APSL-2 MIT BSD-4 - third_party/breakpad/breakpad/LICENSE
# custom Boost-1.0 BSD BSD-2 BSD-4 gcc-runtime-library-exception-3.1 FDL-1.1 \
#   GPL-2 GPL-2+ GPL-2-with-classpath-exception GPL-3 HPND icu LIBGLOSS LGPL-2
#   LGPL-2.1 LGPL-2.1+ LGPL-3 MIT NEWLIB PSF-2.4 rc UoI-NCSA ZLIB \
#   || ( MPL-1.1 GPL-2.0+ LGPL-2.1+ ) - native_client/NOTICE
#   NSIS: BZIP2 CPL-1.0 libpng ZLIB
#   (Some third_party modules do not exist like NSIS)
# custom, W3C-IPR, BSD, MIT, GPL-2, LPGL-2.1, PSF-2.4, BSD-2, SunPro, \
#   GPL-2+, ZLIB, LGPL-2.1+, NEWLIB, LIBGLOSS, GPL-2-with-classpath-exception, \
#   SAX-PD, GPL-2-with-classpath-exception, UoI-NCSA, FDL-1.1, Boost-1.0, \
#   CPL-1.0, BZIP2, ZLIB, LGPL-3, GPL-3, gcc-runtime-library-exception-3.1, \
#   W3C-SOFTWARE-NOTICE-AND-LICENSE-2004 (LICENSE.DOM), HPND, BSD-4, \
#   || ( MPL-1.1 GPL-2+ LGPL-2.1+ ),    - native_client/NOTICE \
#   Not all folders present so not all licenses will apply.
# custom IJG - third_party/iccjpeg/LICENSE
# custom MPL-2.0 BSD GPL-3 LGPL-3 Apache-1.1 - \
#   third_party/tflite/src/third_party/eigen3/LICENSE ; Only MPL-2.0 files are \
#   found
# custom UoI-NCSA - third_party/llvm/llvm/include/llvm/Support/LICENSE.TXT
# custom public-domain - third_party/sqlite/LICENSE
# CC-BY-3.0 https://peach.blender.org/download/ # avi is mp4 and h264 is mov
#   (c) copyright 2008, Blender Foundation / www.bigbuckbunny.org
# CC-BY-4.0 - third_party/devtools-frontend/src/node_modules/caniuse-lite/LICENSE
# CC0-1.0 - tools/perf/page_sets/trivial_sites/trivial_fullscreen_video.html
# fft2d - third_party/tflite/src/third_party/fft2d/LICENSE
# g711 - third_party/webrtc/modules/third_party/g711/LICENSE
# g722 - third_party/webrtc/modules/third_party/g722/LICENSE
# GPL-2 - third_party/freetype-testing/LICENSE
# GPL-2+ - third_party/devscripts/licensecheck.pl.vanilla
# HPND PSF-2.4 - v8/third_party/v8/builtins/LICENSE
# ILA-OpenCV (BSD with additional clauses) - third_party/opencv/src/LICENSE
# icu Unicode-DFS-2016 - base/third_party/icu/LICENSE
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
# libpng2 - third_party/pdfium/third_party/libpng16/LICENSE
# libvpx-PATENTS - third_party/libvpx/source/libvpx/PATENTS
# MIT CC0-1.0 - third_party/node/node_modules/eslint/node_modules/lodash/LICENSE
# MIT SGI-B-2.0 - third_party/khronos/LICENSE
# MIT Unicode-DFS-2016 CC-BY-4.0 W3C W3C-Community-Final-Specification-Agreement - third_party/node/node_modules/typescript/ThirdPartyNoticeText.txt
# MPL-2.0 - third_party/node/node_modules/mdn-data/LICENSE
# neon_2_sse - third_party/neon_2_sse/LICENSE
# OFL-1.1 - third_party/freetype-testing/src/fuzzing/corpora/cff-render-ftengine/bungeman/HangingS.otf
# ooura - third_party/webrtc/common_audio/third_party/ooura/LICENSE
# PATENTS - third_party/dav1d/libdav1d/doc/PATENTS
# PATENTS - third_party/libaom/source/libaom/PATENTS
# PATENTS - third_party/libaom/source/libaom/third_party/libwebm/PATENTS.TXT
# PATENTS - third_party/libjxl/src/PATENTS
# PATENTS - third_party/libvpx/source/libvpx/PATENTS
# PATENTS - third_party/libvpx/source/libvpx/third_party/libwebm/PATENTS.TXT
# PATENTS - third_party/libwebm/source/PATENTS.TXT
# PATENTS - third_party/libwebp/src/PATENTS
# PATENTS - third_party/libyuv/PATENTS
# PATENTS - third_party/webrtc/PATENTS
# public-domain - third_party/lzma_sdk/LICENSE
# public-domain with no warranty - third_party/pdfium/third_party/bigint/LICENSE
# public-domain - \
#   third_party/webrtc/common_audio/third_party/spl_sqrt_floor/LICENSE
# PSF-2 - third_party/devtools-frontend/src/node_modules/mocha/node_modules/argparse/LICENSE
# QU-fft - third_party/webrtc/modules/third_party/fft/LICENSE
# sigslot - third_party/webrtc/rtc_base/third_party/sigslot/LICENSE
# SunPro - third_party/fdlibm/LICENSE
# svgo (with russian MIT license translation) - \
#   third_party/node/node_modules/svgo/LICENSE
# Unlicense Apache-2.0 - \
#   third_party/devtools-frontend/src/node_modules/@sinonjs/text-encoding/LICENSE.md
# unicode [3 clause DFS] - third_party/icu4j/LICENSE
# Unicode-DFS-2016 [2 clause DFS] - third_party/cldr/LICENSE
# unRAR - third_party/unrar/LICENSE
# UoI-NCSA - third_party/swiftshader/third_party/llvm-subzero/LICENSE.TXT
# W3C-Document-License-2002, MIT, Unicode-DFS-2016, CC-BY-4.0, W3C-Community-Final-Specification-Agreement - third_party/node/node_modules/typescript/ThirdPartyNoticeText.txt
# widevine - third_party/widevine/LICENSE
# WTFPL BSD-2 - third_party/catapult/third_party/polymer2/bower_components/sinon-chai/LICENSE.txt
# x11proto - third_party/x11proto/LICENSE
# ^^ ( FTL GPL-2 ) ZLIB public-domain - third_party/freetype/src/LICENSE.TXT
# || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) - chrome/utility/importer/nss_decryptor.cc
# || ( WTFPL-2 Apache-2.0 ) - \
#   third_party/catapult/third_party/polymer2/bower_components/sinon-chai/LICENSE.txt ; \
#   the WTFPL is the better choice because Apache-2.0 has more restrictions
# || ( MIT GPL-3 ) third_party/catapult/tracing/third_party/jszip/LICENSE.markdown ; \
#   upstream has more MIT than GPL3 copyright notices, so MIT is assumed
# * The public-domain entry was not added to the LICENSE ebuild variable to not
#   give the wrong impression that the entire software was released in public
#   domain.
#
RESTRICT="
	mirror
	!bindist? (
		bindist
	)
	!test? (
		test
	)
"
SLOT="0/stable"
#
# vaapi is enabled by default upstream for some arches \
# See https://github.com/chromium/chromium/blob/131.0.6778.69/media/gpu/args.gni#L24
#
# Using the system-ffmpeg or system-icu breaks cfi-icall or cfi-cast which is
#   incompatible as a shared lib.
#
# The suid is built by default upstream but not necessarily used:  \
#   https://github.com/chromium/chromium/blob/131.0.6778.69/sandbox/linux/BUILD.gn
#
CPU_FLAGS_ARM=(
	bti
	neon
	pac
)
CPU_FLAGS_X86=(
	avx2
	sse2
	sse4_2
	ssse3
)
IUSE_LIBCXX=(
	bundled-libcxx
	system-libstdcxx
)
# CFI Basic (.a) mode requires all third party modules built as static.

# Option defaults based on build files.
IUSE_CODECS=(
	+dav1d
	+libaom
	+openh264
	+opus
	+vaapi-hevc
	+vorbis
	+vpx
)

# Option defaults based on build files.
IUSE+="
${CPU_FLAGS_ARM[@]/#/cpu_flags_arm_}
${CPU_FLAGS_X86[@]/#/cpu_flags_x86_}
${IUSE_CODECS[@]}
${IUSE_LIBCXX[@]}
${LLVM_COMPAT[@]/#/llvm_slot_}
+accessibility bindist bluetooth +bundled-libcxx +cfi -cet +cups
+css-hyphen -debug +drumbrake +encode +extensions ffmpeg-chromium firejail
-gtk4 -hangouts -headless +hidpi +jit +js-type-check +kerberos +mdns +ml mold
+mpris +official +partitionalloc pax-kernel +pdf pic +pgo +plugins +pointer-compression
+pre-check-vaapi +proprietary-codecs proprietary-codecs-disable
proprietary-codecs-disable-nc-developer proprietary-codecs-disable-nc-user
+pulseaudio +reporting-api qt5 qt6 +screencast selinux
-system-dav1d +system-ffmpeg -system-flac -system-fontconfig
-system-freetype -system-harfbuzz -system-icu -system-libaom -system-libdrm
-system-libjpeg-turbo -system-libpng -system-libwebp -system-libxml
-system-libxslt -system-openh264 -system-opus -system-re2 -system-toolchain
-system-zlib +system-zstd systemd test +vaapi +wayland +webassembly
-widevine +X
ebuild-revision-1
"

# What is considered a proprietary codec can be found at:
#
#   https://github.com/chromium/chromium/blob/131.0.6778.69/media/filters/BUILD.gn#L160
#   https://github.com/chromium/chromium/blob/131.0.6778.69/media/media_options.gni#L38
#   https://github.com/chromium/chromium/blob/131.0.6778.69/media/base/supported_types.cc#L203
#   https://github.com/chromium/chromium/blob/131.0.6778.69/media/base/supported_types.cc#L284
#
# Codec upstream default:
#   https://github.com/chromium/chromium/blob/131.0.6778.69/tools/mb/mb_config_expectations/chromium.linux.json#L89
#

#
# For cfi-vcall, cfi-icall defaults status, see \
#   https://github.com/chromium/chromium/blob/131.0.6778.69/build/config/sanitizers/sanitizers.gni
# For cfi-cast default status, see \
#   https://github.com/chromium/chromium/blob/131.0.6778.69/build/config/sanitizers/sanitizers.gni#L123
# For pgo default status, see \
#   https://github.com/chromium/chromium/blob/131.0.6778.69/build/config/compiler/pgo/pgo.gni#L15
# For libcxx default, see \
#   https://github.com/chromium/chromium/blob/131.0.6778.69/build/config/c++/c++.gni#L14
# For cdm availability see third_party/widevine/cdm/widevine.gni#L28
#

#
# vaapi is not conditioned on proprietary-codecs upstream, but should
# be or by case-by-case (i.e. h264_vaapi, vp9_vaapi, av1_vaapi)
# with additional USE flags.
# The system-ffmpeg comes with aac which is unavoidable.  This is why
# there is a block with !proprietary-codecs.
# cfi-icall, cfi-cast requires static linking.  See
#   https://clang.llvm.org/docs/ControlFlowIntegrity.html#indirect-function-call-checking
#   https://clang.llvm.org/docs/ControlFlowIntegrity.html#bad-cast-checking
#
DISABLED_NON_FREE_USE_FLAGS="
	^^ (
		proprietary-codecs
		proprietary-codecs-disable
		proprietary-codecs-disable-nc-developer
		proprietary-codecs-disable-nc-user
	)
	openh264? (
		proprietary-codecs
	)
	proprietary-codecs-disable? (
		!openh264
		!vaapi-hevc
		!widevine
		system-ffmpeg
	)
	proprietary-codecs-disable-nc-developer? (
		!openh264
		!vaapi-hevc
		!widevine
		system-ffmpeg
	)
	proprietary-codecs-disable-nc-user? (
		!openh264
		!vaapi-hevc
		!widevine
		system-ffmpeg
	)
	vaapi-hevc? (
		proprietary-codecs
	)
	widevine? (
		proprietary-codecs
	)
"

# Unconditionals
# Retesting disablement
DISTRO_REQUIRE_USE="
	-system-harfbuzz
	system-flac
	system-fontconfig
	system-freetype
	system-libdrm
	system-libjpeg-turbo
	system-libwebp
	system-libxml
	system-libxslt
	system-openh264
	system-zlib
"
#
# Generally, the availability of the system-toolchain USE flag is.
#
#  ( sys-devel/rust:${LLVM_OFFICIAL_SLOT}  || sys-devel/rust-bin:${LLVM_OFFICIAL_SLOT} ) && sys-devel/clang:${LLVM_OFFICIAL_SLOT} && sys-devel/llvm:${LLVM_OFFICIAL_SLOT}.
#
# The community prefers only stable versioning.
#
# Upstream uses a customized build where they do not align.  For 128.x.x.x
# release it should be
#
#   dev-lang/rust-cr:${RUST_CR_PV%%.*}-${PV%%.*} && sys-devel/clang:${LLVM_OFFICIAL_SLOT} && sys-devel/llvm:${LLVM_OFFICIAL_SLOT}.
#
# The rust-cr build is actually an older snapshot of 1.79.x that submodules llvm 18.
# The official slot discussed here is llvm 19.  Hypothetical rust-cr, needs to be
# built and link against llvm 19.
#
# We will not consider rust-cr file situation for now because the env file situation.
#
#	extensions
#	!partitionalloc
REQUIRED_USE+="
	${DISABLED_NON_FREE_USE_FLAGS}
	!headless (
		extensions
		pdf
		plugins
		|| (
			wayland
			X
		)
	)
	^^ (
		${IUSE_LIBCXX[@]}
	)
	cfi? (
		!mold
		!system-dav1d
		!system-ffmpeg
		!system-flac
		!system-fontconfig
		!system-harfbuzz
		!system-icu
		!system-libaom
		!system-libdrm
		!system-libjpeg-turbo
		!system-libpng
		!system-libstdcxx
		!system-libwebp
		!system-libxml
		!system-libxslt
		!system-openh264
		!system-opus
		!system-re2
		!system-zlib
		!system-zstd
		bundled-libcxx
	)
	cups? (
		pdf
	)
	drumbrake? (
		webassembly
	)
	ffmpeg-chromium? (
		bindist
		proprietary-codecs
	)
	!headless? (
		pdf
	)
	official? (
		!cet
		!debug
		!drumbrake
		!hangouts
		!mold
		!system-dav1d
		!system-ffmpeg
		!system-flac
		!system-fontconfig
		!system-harfbuzz
		!system-icu
		!system-libaom
		!system-libdrm
		!system-libjpeg-turbo
		!system-libpng
		!system-libstdcxx
		!system-libwebp
		!system-libxml
		!system-libxslt
		!system-openh264
		!system-opus
		!system-re2
		!system-zlib
		!system-zstd
		accessibility
		bundled-libcxx
		css-hyphen
		cups
		dav1d
		encode
		extensions
		hidpi
		jit
		kerberos
		libaom
		llvm_slot_19
		mdns
		ml
		mpris
		openh264
		opus
		partitionalloc
		pdf
		pgo
		plugins
		proprietary-codecs
		reporting-api
		screencast
		vaapi
		vaapi-hevc
		vorbis
		vpx
		wayland
		webassembly
		X
		!amd64? (
			!cfi
		)
		amd64? (
			pulseaudio
			cfi
		)
		arm64? (
			cpu_flags_arm_bti
			cpu_flags_arm_pac
		)
	)
	pdf? (
		plugins
	)
	pre-check-vaapi? (
		vaapi
	)
	screencast? (
		wayland
	)
	system-libstdcxx? (
		!cfi
	)
	system-toolchain? (
		bundled-libcxx
	)
	test? (
		cfi
	)
	vaapi-hevc? (
		vaapi
	)
	webassembly? (
		jit
	)
	widevine? (
		!arm64
		!ppc64
	)
"
if is_cromite_compatible ; then
	# USE=pgo is default ON in Chromite but dropped for user choice.
	# USE=official is default ON in Chromite, but this ebuild reserves it
	# for authentic Chromium.
	#
	# The rest are the same defaults as the patchset.
	#
	# The reason that these USE flags are forced to match the patchset
	# defaults is because I don't know if these were pruned by the scripts.
	REQUIRED_USE+="
		cromite? (
			amd64
			proprietary-codecs
			dav1d
			pdf
			plugins
			!css-hyphen
			!hangouts
			!official
			!openh264
			!mdns
			!ml
			!reporting-api
			!system-toolchain
			!widevine
		)
		official? (
			!cromite
		)
	"
fi
if [[ "${UNGOOGLED_CHROMIUM_PV%-*}" == "${PV}" ]] ; then
	# USE=widevine is default ON, implying that it is allowed, in
	# ungoogled-chromium but dropped from being forced ON to allow the user
	# to decide.
	#
	# The rest are the same defaults as the patchset.
	#
	# The reason that these USE flags are forced to match the patchset
	# defaults is because I don't know if these were pruned by the scripts.
	REQUIRED_USE+="
		ungoogled-chromium? (
			!hangouts
			!mdns
			!ml
			!pgo
			!reporting-api
		)
		official? (
			!ungoogled-chromium
		)
	"
fi

LIBVA_DEPEND="
	vaapi? (
		>=media-libs/libva-${LIBVA_PV}[${MULTILIB_USEDEP},drm(+),wayland?,X?]
		media-libs/libva:=
		media-libs/vaapi-drivers[${MULTILIB_USEDEP}]
		system-ffmpeg? (
			media-video/ffmpeg:${FFMPEG_SLOT}[${MULTILIB_USEDEP},vaapi]
		)
	)
"

gen_depend_llvm() {
	local o_all=""
	local t=""
	local o_official=""
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		t="
			!official? (
				cfi? (
					=sys-libs/compiler-rt-sanitizers-${s}*[${MULTILIB_USEDEP},cfi]
					sys-libs/compiler-rt-sanitizers:=
				)
			)
			=sys-libs/compiler-rt-${s}*
			sys-libs/compiler-rt:=
			=sys-devel/clang-runtime-${s}*[${MULTILIB_USEDEP},compiler-rt,sanitize]
			sys-devel/clang:${s}[${MULTILIB_USEDEP}]
			sys-devel/lld:${s}
			sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
			pgo? (
				=sys-libs/compiler-rt-sanitizers-${s}*[${MULTILIB_USEDEP},profile]
				sys-libs/compiler-rt-sanitizers:=
			)
			official? (
				amd64? (
					=sys-libs/compiler-rt-sanitizers-${s}*[${MULTILIB_USEDEP},cfi,profile]
					sys-libs/compiler-rt-sanitizers:=
				)
			)
		"
		o_all+="
			(
				${t}
			)
		"
		(( ${s} == ${LLVM_OFFICIAL_SLOT} )) && o_official=" ${t} "
	done
	echo -e "
		official? (
			${o_official}
		)
		|| (
			${o_all}
		)
	"
}

COMMON_X_DEPEND="
	>=x11-libs/libXi-1.7.10[${MULTILIB_USEDEP}]
	x11-libs/libXi:=
	>=x11-libs/libXcomposite-0.4.5[${MULTILIB_USEDEP}]
	x11-libs/libXcomposite:=
	>=x11-libs/libXcursor-1.2.0[${MULTILIB_USEDEP}]
	x11-libs/libXcursor:=
	>=x11-libs/libXdamage-1.1.5[${MULTILIB_USEDEP}]
	x11-libs/libXdamage:=
	>=x11-libs/libXfixes-5.0.3[${MULTILIB_USEDEP}]
	x11-libs/libXfixes:=
	>=x11-libs/libXrandr-1.5.1[${MULTILIB_USEDEP}]
	x11-libs/libXrandr:=
	>=x11-libs/libXrender-0.9.10[${MULTILIB_USEDEP}]
	x11-libs/libXrender:=
	>=x11-libs/libxshmfence-1.3[${MULTILIB_USEDEP}]
	x11-libs/libxshmfence:=
	>=x11-libs/libXtst-1.2.3[${MULTILIB_USEDEP}]
	x11-libs/libXtst:=
"

COMMON_SNAPSHOT_DEPEND="
	!headless? (
		${LIBVA_DEPEND}
		>=dev-libs/glib-2.66.8:2[${MULTILIB_USEDEP}]
		>=media-libs/alsa-lib-1.2.4[${MULTILIB_USEDEP}]
		media-libs/alsa-lib:=
		>=sys-apps/pciutils-3.7.0[${MULTILIB_USEDEP}]
		sys-apps/pciutils:=
		>=x11-libs/libxkbcommon-1.0.3[${MULTILIB_USEDEP}]
		x11-libs/libxkbcommon:=
		kerberos? (
			virtual/krb5[${MULTILIB_USEDEP}]
		)
		pulseaudio? (
			>=media-libs/libpulse-14.2[${MULTILIB_USEDEP}]
			media-libs/libpulse:=
		)
		vaapi? (
			>=media-libs/libva-${LIBVA_PV}[${MULTILIB_USEDEP},wayland?,X?]
			media-libs/libva:=
		)
		wayland? (
			>=dev-libs/libffi-3.3[${MULTILIB_USEDEP}]
			dev-libs/libffi:=
			>=dev-libs/wayland-1.18.0[${MULTILIB_USEDEP}]
			dev-libs/wayland:=
			screencast? (
				>=media-video/pipewire-0.3.65[${MULTILIB_USEDEP}]
				media-video/pipewire:=
			)
		)
		X? (
			>=x11-libs/libX11-1.7.2[${MULTILIB_USEDEP}]
			x11-libs/libX11:=
			>=x11-libs/libxcb-1.14[${MULTILIB_USEDEP}]
			x11-libs/libxcb:=
			>=x11-libs/libXext-1.3.3[${MULTILIB_USEDEP}]
			x11-libs/libXext:=
		)
	)
	>=dev-libs/nss-3.61[${MULTILIB_USEDEP}]
	dev-libs/nss:=
	>=dev-libs/nspr-4.29[${MULTILIB_USEDEP}]
	dev-libs/nspr:=
	>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP},gbm(+)]
	media-libs/mesa:=
	proprietary-codecs? (
		system-openh264? (
			>=media-libs/openh264-2.4.1[${MULTILIB_USEDEP}]
			media-libs/openh264:=
		)
	)
	system-dav1d? (
		>=media-libs/dav1d-1.4.2[${MULTILIB_USEDEP},8bit]
		media-libs/dav1d:=
	)
	system-fontconfig? (
		>=media-libs/fontconfig-2.15.0[${MULTILIB_USEDEP}]
		media-libs/fontconfig:=
	)
	system-freetype? (
		>=media-libs/freetype-2.13.3[${MULTILIB_USEDEP}]
		media-libs/freetype:=
	)
	system-harfbuzz? (
		>=media-libs/harfbuzz-8.5.0:0[${MULTILIB_USEDEP},icu(-)]
		media-libs/harfbuzz:=
	)
	system-icu? (
		>=dev-libs/icu-74.2[${MULTILIB_USEDEP}]
		dev-libs/icu:=
	)
	system-libaom? (
		>=media-libs/libaom-3.9.1[${MULTILIB_USEDEP}]
		media-libs/libaom:=
	)
	system-libdrm? (
		>=x11-libs/libdrm-2.4.122[${MULTILIB_USEDEP}]
		x11-libs/libdrm:=
	)
	system-libjpeg-turbo? (
		>=media-libs/libjpeg-turbo-2.1.5.1[${MULTILIB_USEDEP}]
		media-libs/libjpeg-turbo:=
	)
	system-libpng? (
		>=media-libs/libpng-1.6.43[${MULTILIB_USEDEP},-apng]
		media-libs/libpng:=
	)
	system-libwebp? (
		>=media-libs/libwebp-1.4.0[${MULTILIB_USEDEP}]
		media-libs/libwebp:=
	)
	system-libxml? (
		>=dev-libs/libxml2-2.13.0[${MULTILIB_USEDEP},icu]
		dev-libs/libxml2:=
	)
	system-libxslt? (
		>=dev-libs/libxslt-1.1.42[${MULTILIB_USEDEP}]
		dev-libs/libxslt:=
	)
	system-re2? (
		>=dev-libs/re2-0.2023.06.01:0/11[${MULTILIB_USEDEP}]
		dev-libs/re2:=
	)
	system-zlib? (
		>=sys-libs/zlib-${ZLIB_PV}[${MULTILIB_USEDEP}]
		sys-libs/zlib:=
	)
	system-zstd? (
		>=app-arch/zstd-1.5.6[${MULTILIB_USEDEP}]
		app-arch/zstd:=
	)
"

# No multilib for this virtual/udev when it should be.
VIRTUAL_UDEV="
	systemd? (
		>=sys-apps/systemd-252.5[${MULTILIB_USEDEP}]
	)
	!systemd? (
		>=sys-apps/systemd-utils-252.5[${MULTILIB_USEDEP},udev]
	)
"

COMMON_DEPEND="
	!headless? (
		${VIRTUAL_UDEV}
		(
			>=media-libs/libglvnd-1.3.2[${MULTILIB_USEDEP},X?]
			>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP},wayland?,X?]
			media-libs/mesa:=
		)
		>=x11-libs/cairo-1.16.0[${MULTILIB_USEDEP}]
		x11-libs/cairo:=
		>=x11-libs/gdk-pixbuf-2.42.2:2[${MULTILIB_USEDEP}]
		>=x11-libs/pango-1.46.2[${MULTILIB_USEDEP}]
		x11-libs/pango:=
		accessibility? (
			>=app-accessibility/at-spi2-core-2.44.1:2[${MULTILIB_USEDEP}]
		)
		cups? (
			>=net-print/cups-2.3.3[${MULTILIB_USEDEP}]
			net-print/cups:=
		)
		qt5? (
			>=dev-qt/qtcore-${QT5_PV}:5
			>=dev-qt/qtwidgets-${QT5_PV}:5[X?]
		)
		qt6? (
			>=dev-qt/qtbase-${QT6_PV}:6[widgets,X?]
		)
		X? (
			${COMMON_X_DEPEND}
		)
	)
	${COMMON_SNAPSHOT_DEPEND}
	>=dev-libs/expat-2.2.10[${MULTILIB_USEDEP}]
	dev-libs/expat:=
	>=net-misc/curl-7.88.1[${MULTILIB_USEDEP},ssl]
	>=sys-apps/dbus-1.12.24[${MULTILIB_USEDEP}]
	sys-apps/dbus:=
	>=sys-devel/gcc-${GCC_PV}
	>=sys-libs/zlib-${ZLIB_PV}[${MULTILIB_USEDEP},minizip]
	sys-libs/zlib:=
	app-arch/bzip2[${MULTILIB_USEDEP}]
	app-arch/bzip2:=
	virtual/libc
	bluetooth? (
		>=net-wireless/bluez-5.55[${MULTILIB_USEDEP}]
	)
	system-ffmpeg? (
		system-opus? (
			>=media-libs/opus-1.4[${MULTILIB_USEDEP}]
			media-libs/opus:=
		)
		proprietary-codecs? (
			media-video/ffmpeg:${FFMPEG_SLOT}[${MULTILIB_USEDEP},encode?,opus?,vorbis?,vpx?]
		)
		proprietary-codecs-disable? (
			media-video/ffmpeg:${FFMPEG_SLOT}[${MULTILIB_USEDEP},-amr,-cuda,encode?,-fdk,-kvazaar,-openh264,opus?,proprietary-codecs-disable,vaapi?,vorbis?,vpx?,-x264,-x265,-xvid]
		)
		proprietary-codecs-disable-nc-developer? (
			media-video/ffmpeg:${FFMPEG_SLOT}[${MULTILIB_USEDEP},-amr,-cuda,encode?,-fdk,-kvazaar,-openh264,opus?,proprietary-codecs-disable-nc-developer,vaapi?,vorbis?,vpx?,-x264,-x265,-xvid]
		)
		proprietary-codecs-disable-nc-user? (
			media-video/ffmpeg:${FFMPEG_SLOT}[${MULTILIB_USEDEP},-amr,-cuda,encode?,-fdk,-kvazaar,-openh264,opus?,proprietary-codecs-disable-nc-user,vaapi?,vorbis?,vpx?,-x264,-x265,-xvid]
		)
		|| (
			media-video/ffmpeg:${FFMPEG_SLOT}[${MULTILIB_USEDEP},-samba]
			>=net-fs/samba-4.5.10-r1[${MULTILIB_USEDEP},-debug(-)]
		)
	)
	system-flac? (
		>=media-libs/flac-1.4.2[${MULTILIB_USEDEP}]
		media-libs/flac:=
	)
"
CLANG_RDEPEND="
	bundled-libcxx? (
		$(gen_depend_llvm)
	)
	cfi? (
		$(gen_depend_llvm)
	)
	official? (
		$(gen_depend_llvm)
	)
"

RDEPEND+="
	${COMMON_DEPEND}
	${CLANG_RDEPEND}
	sys-kernel/mitigate-id
	virtual/ttf-fonts
	!headless? (
		qt5? (
			>=dev-qt/qtgui-${QT5_PV}:5[wayland?,X?]
		)
		qt6? (
			>=dev-qt/qtbase-${QT6_PV}:6[gui,wayland?,X?]
			wayland? (
				>=dev-qt/qtdeclarative-${QT6_PV}:6[opengl]
				>=dev-qt/qtwayland-${QT6_PV}:6
			)
		)
		|| (
			>=gui-libs/gtk-${GTK4_PV}:4[wayland?,X?]
			>=x11-libs/gtk+-${GTK3_PV}:3[${MULTILIB_USEDEP},wayland?,X?]
		)
	)
	selinux? (
		>=sys-libs/libselinux-3.1[${MULTILIB_USEDEP}]
		sec-policy/selinux-chromium
	)
	bindist? (
		!ffmpeg-chromium? (
			>=media-video/ffmpeg-6.1-r1:${FFMPEG_SLOT}[chromium]
		)
		ffmpeg-chromium? (
			media-video/ffmpeg-chromium:${PV%%\.*}
		)
	)
"
DEPEND+="
	${COMMON_DEPEND}
	!headless? (
		!gtk4? (
			>=x11-libs/gtk+-${GTK3_PV}:3[${MULTILIB_USEDEP},wayland?,X?]
		)
		gtk4? (
			>=gui-libs/gtk-${GTK4_PV}:4[wayland?,X?]
		)
	)
"
PDEPEND+="
	firejail? (
		sys-apps/firejail[X?,firejail_profiles_chromium]
	)
"
CLANG_BDEPEND="
	bundled-libcxx? (
		$(gen_depend_llvm)
	)
	cfi? (
		$(gen_depend_llvm)
	)
	official? (
		$(gen_depend_llvm)
	)
	pgo? (
		$(gen_depend_llvm)
	)
"
RUST_BDEPEND="
	llvm_slot_19? (
		|| (
			=dev-lang/rust-1.82*
			=dev-lang/rust-bin-1.82*
		)
	)
	|| (
		dev-lang/rust:=
		dev-lang/rust-bin:=
	)
"
# Upstream uses live rust.  Rust version is relaxed.
# Mold was relicensed as MIT in 2.0.  >=2.0 was used to avoid legal issues.
BDEPEND+="
	$(python_gen_any_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
	${CLANG_BDEPEND}
	${COMMON_SNAPSHOT_DEPEND}
	${PYTHON_DEPS}
	dev-util/patchutils
	www-client/chromium-sources:0/${PV}
	www-client/chromium-toolchain:0/llvm${LLVM_OFFICIAL_SLOT}-rust$(ver_cut 1-2 ${RUST_PV})-gn${GN_PV}[clang,gn,rust]
	>=app-arch/gzip-1.7
	>=dev-build/ninja-1.7.2
	>=dev-util/gperf-3.0.3
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	>=net-libs/nodejs-20.11.0:${NODE_VERSION}[inspector]
	>=sys-devel/bison-2.4.3
	app-alternatives/lex
	app-eselect/eselect-nodejs
	dev-lang/perl
	dev-vcs/git
	mold? (
		>=sys-devel/mold-2.0
	)
	system-toolchain? (
		${RUST_BDEPEND}
		>=dev-util/bindgen-0.68.0
	)
	vaapi? (
		media-video/libva-utils
	)
"

# Upstream uses llvm:16
# When CFI + PGO + official was tested, it didn't work well with LLVM12.  Error noted in
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/f0c13049dc89f068370511b4664f7fb111df2d3a/www-client/chromium/bug_notes
# This is why LLVM13 was set as the minimum and did fix the problem.

# For the current llvm for this project, see
#   https://github.com/chromium/chromium/blob/131.0.6778.69/tools/clang/scripts/update.py#L42
# Use the same clang for official USE flag because of older llvm bugs which
#   could result in security weaknesses (explained in the llvm:12 note below).
# Used llvm >= 12 for arm64 for the same reason in the Linux kernel CFI comment.
#   Links below from https://github.com/torvalds/linux/commit/cf68fffb66d60d96209446bfc4a15291dc5a5d41
#     https://bugs.llvm.org/show_bug.cgi?id=46258
#     https://bugs.llvm.org/show_bug.cgi?id=47479
# To confirm the hash version match for the reported by CR_CLANG_REVISION, see
#   https://github.com/llvm/llvm-project/blob/98033fdc/llvm/CMakeLists.txt

# The preference now is CFI Cross-DSO if one prefers unbundled libs.
# CFI Cross-DSO is preferred to reduce duplicate pages at the cost of some
# security usually cfi-icall.  This is why CFI Basic mode (.a) is preferred
# and better security quality because cfi-icall is less buggy.  Using
# CFI Basic mode require more ebuild modding to isolate both .so/.a
# builds for -fvisibility changes.  Most ebuilds combine both, so for now
# only CFI Cross-DSO is the only practical recourse.

# Some libs here cannot be CFIed in @system due to IR incompatibility because
# gcc cannot use LLVM bitcode in .a files.  This is why the internal zlib is
# preferred over systemwide zlib in systems without CFI hardware implementation.

# Some require CFI flags because they support both CFI Cross-DSO mode (.so) and
# CFI Basic mode (.a).  Some should have the CFI flag so that CFI packages
# are properly prioritized in *DEPENDs to avoid missing symbols problems.

if ! has chromium_pkg_die ${EBUILD_DEATH_HOOKS} ; then
	EBUILD_DEATH_HOOKS+=" chromium_pkg_die";
fi

DOC_CONTENTS="

Some web pages may require additional fonts to display properly.  Try installing
some of the following packages if some characters are not displayed properly:

  - media-fonts/arphicfonts
  - media-fonts/droid
  - media-fonts/ipamonafont
  - media-fonts/ja-ipafonts
  - media-fonts/noto
  - media-fonts/takao-fonts
  - media-fonts/wqy-microhei
  - media-fonts/wqy-zenhei


To fix broken icons on the Downloads page, you should install an icon theme that
covers the appropriate MIME types, and configure this as your GTK+ icon theme.


For native file dialogs in KDE, install kde-apps/kdialog.


To make password storage work with your desktop environment you may have install
one of the supported credentials management applications:

  - app-crypt/libsecret    (GNOME)
  - kde-frameworks/kwallet (KDE)

If you have one of above packages installed, but don't want to use them in
Chromium, then add --password-store=basic to CHROMIUM_FLAGS in
/etc/chromium/default.

"

python_check_deps() {
	python_has_version "dev-python/setuptools[${PYTHON_USEDEP}]"
}

# needs_clang() ~ is_using_clang()
# needs_lld() ~ is_using_lld()

is_using_lld() {
	# #641556: Force lld for lto and pgo builds, otherwise disable
	# #918897: Temporary hack w/ use arm64
	# oiledmachine-overlay:  dropped use lto
	use pgo || use arm64
}

_system_toolchain_checks() {
	if [[ "${MERGE_TYPE}" != "binary" ]]; then
	# The pre_build_checks are all about compilation resources, no need to
	# run it for a binpkg.
		pre_build_checks

		if tc-is-gcc && ! ver_test "$(gcc-version)" -ge "${GCC_PV}" ; then
eerror "At least gcc ${GCC_PV} is required"
			die
		fi

		if use pgo && tc-is-cross-compiler; then
eerror "The pgo USE flag cannot be used when cross-compiling"
			die
		fi

		if is_using_clang || tc-is-clang ; then
			local clang_min
			local clang_max
			if use official ; then
				clang_min="${LLVM_OFFICIAL_SLOT}"
				clang_max="${LLVM_OFFICIAL_SLOT}"
			else
				clang_min="${LLVM_MIN_SLOT}"
				clang_max="${LLVM_MAX_SLOT}"
			fi

	# Ideally we never see this, but it should help prevent bugs like 927154
			if \
				ver_test "$(clang-major-version)" -lt ${clang_min} \
					|| \
				ver_test "$(clang-major-version)" -gt ${clang_max} \
			; then
eerror
eerror "Your chosen clang does not meet requirements."
eerror
eerror "Actual slot:\t${slot}"
eerror "Expected slots:\t $(seq ${clang_min} ${clang_max})"
eerror
				clang --version
eerror
				die
			fi
		fi
	fi
}

has_zswap() {
	# 2.1875 is the average compression ratio
	# (or ratio of uncompressed:compressed)
	if grep -q -e "Y" "${BROOT}/sys/module/zswap/parameters/enabled" ; then
		return 0
	fi
	return 1
}

is_debug_flags() {
	is-flagq '-g?(gdb)?([1-9])'
}

pre_build_checks() {
	# Check build requirements: bugs #471810, #541816, #914220
	if use official ; then
	# https://github.com/chromium/chromium/blob/131.0.6778.69/docs/linux/build_instructions.md#system-requirements
		CHECKREQS_DISK_BUILD="100G"
		CHECKREQS_MEMORY="16G"
	else
		if is_debug_flags ; then
			CHECKREQS_DISK_BUILD="${DISK_BUILD[debug]}G"
			CHECKREQS_MEMORY="16G" # Same as above link
		elif use pgo ; then
			CHECKREQS_DISK_BUILD="${DISK_BUILD[pgo]}G"
			CHECKREQS_MEMORY="12G"
		elif is-flagq '-flto*' ; then
			CHECKREQS_DISK_BUILD="${DISK_BUILD[lto]}G"
			CHECKREQS_MEMORY="12G"
		else
			CHECKREQS_DISK_BUILD="${DISK_BUILD[fallback]}G"
			CHECKREQS_MEMORY="12G"
		fi
		if ! has_zswap ; then
	# Calculate uncompressed memory requirements
local python_script=\
"import math ; "\
"v=${CHECKREQS_MEMORY/G}*2.1875 ; "\
"print( math.ceil(v/4) * 4 )"
				total_memory_without_zswap=$(python -c "${python_script}")"G"
einfo
einfo "Detected zswap off.  Total memory required:"
einfo
einfo "With zswap:\t${CHECKREQS_MEMORY}"
einfo "Without zswap:\t${total_memory_without_zswap}"
einfo
			CHECKREQS_MEMORY="${total_memory_without_zswap}"
		fi
	fi

	# This is a nice idea but doesn't help noobs.
ewarn "Set CHECKREQS_DONOTHING=1 to bypass build requirements not met check"
	check-reqs_pkg_setup
	APPLY_OILEDMACHINE_OVERLAY_PATCHSET=${APPLY_OILEDMACHINE_OVERLAY_PATCHSET:-1}
}

get_olast() {
	local olast=$(echo "${CFLAGS}" \
		| grep -o -E -e "-O(0|1|z|s|2|3|4|fast)" \
		| tr " " "\n" \
		| tail -n 1)
	if [[ -n "${olast}" ]] ; then
		echo "${olast}"
	else
		# Upstream default
		echo "-O3"
	fi
}

pkg_pretend() {
	pre_build_checks
	if [[ "${MERGE_TYPE}" != "binary" ]]; then
	# The pre_build_checks are all about compilation resources, no need to
	# run it for a binpkg
		pre_build_checks
	fi

	if use headless; then
		local headless_unused_flags=(
			"cups"
			"kerberos"
			"pulseaudio"
			"qt5"
			"qt6"
			"vaapi"
			"wayland"
		)
		for myiuse in ${headless_unused_flags[@]}; do
			if use ${myiuse} ; then
ewarn "Ignoring USE=${myiuse}.  USE=headless is set."
			fi
		done
	fi
	if ! use bindist && use ffmpeg-chromium; then
ewarn "Ignoring USE=ffmpeg-chromium.  USE=bindist is not set."
	fi
}

get_pregenerated_profdata_index_version()
{
	local s
	s=$(_get_s)
	test -e "${s}/chrome/build/pgo_profiles/chrome-linux-"*".profdata" \
		|| die
	echo $(od -An -j 8 -N 1 -t d1 \
		"${s}/chrome/build/pgo_profiles/chrome-linux-"*".profdata" \
		| grep -E -o -e "[0-9]+")
}

# Grabs the INSTR_PROF_INDEX_VERSION in the pgo profile.
# https://github.com/llvm/llvm-project/blob/76ea5feb/compiler-rt/include/profile/InstrProfData.inc#L653
get_llvm_profdata_version_info()
{
	[[ -z "${LLVM_SLOT}" ]] && die "LLVM_SLOT is empty"
	local profdata_index_version=0
	local compatible_pv
	local found_ver
	# The live versions can have different profdata versions over time.

	local PKGDB_PATH="${ESYSROOT}/var/db/pkg"
	for compatible_pv in ${PGO_LLVM_SUPPORTED_VERSIONS[@]} ; do
		(( ${compatible_pv%%.*} != ${LLVM_SLOT} )) && continue
		( ! has_version "~sys-devel/llvm-${compatible_pv}" ) && continue
		found_ver=${compatible_pv}
		profdata_index_version=$(cat \
"${ESYSROOT}/usr/lib/llvm/$(ver_cut 1 ${found_ver})/include/llvm/ProfileData/InstrProfData.inc" \
			| grep "INSTR_PROF_INDEX_VERSION" \
			| head -n 1 \
			| grep -E -o -e "[0-9]+")
		break
	done
	if [[ -z "${profdata_index_version}" ]] ; then
eerror "Missing INSTR_PROF_INDEX_VERSION (aka profdata_index_version)"
		die
	fi
	if (( ${profdata_index_version} == 0 )) ; then
eerror
eerror "The profdata_index_version should not be 0.  Install one of these clang"
eerror "slots:"
eerror
eerror "Supported llvm/clang slots for PGO:  ${LLVM_COMPAT[@]}"
eerror
		die
	fi
	if [[ -z "${found_ver}" ]] ; then
eerror "Missing the sys-devel/llvm version (aka found_ver)"
		die
	fi
	echo "${profdata_index_version}:${found_ver}"
}

is_profdata_compatible() {
	local a=$(get_pregenerated_profdata_index_version)
	local b=${CURRENT_PROFDATA_VERSION}
	if (( ${b} >= ${a} )) ; then
		return 0
	else
		return 1
	fi
}

# Generated from:
# for x in $(equery f chromium) ; do \
#	objdump -p ${x} 2>/dev/null | grep NEEDED ; \
# done \
# | sort \
# | uniq
PKG_LIBS=(
#ld-linux-x86-64.so.2
libX11.so.6
libXcomposite.so.1
libXdamage.so.1
libXext.so.6
libXfixes.so.3
libXrandr.so.2
libasound.so.2
libatk-1.0.so.0
libatk-bridge-2.0.so.0
libatspi.so.0
#libc.so.6
libcairo.so.2
libdbus-1.so.3
libdrm.so.2
libexpat.so.1
libffi.so.8
libgbm.so.1
#libgcc_s.so.1
libgio-2.0.so.0
libglib-2.0.so.0
libgobject-2.0.so.0
libm.so.6
libnspr4.so
libnss3.so
libnssutil3.so
libpango-1.0.so.0
libsmime3.so
libxcb.so.1
libxkbcommon.so.0
)

# Check the system for security weaknesses.
check_deps_cfi_cross_dso() {
	if ! use cfi ; then
einfo "Skipping CFI Cross-DSO checks"
		return
	fi
	# These are libs required by the prebuilt bin version.
	# This list was generated from the _maintainer_notes/get_package_libs script.
	# TODO:  Update list for source build.

	# TODO: check dependency n levels deep.
	# We are assuming CFI Cross-DSO.
einfo
einfo "Evaluating system for possible weaknesses."
einfo "Assuming systemwide CFI Cross-DSO."
einfo
	local f
	for f in ${PKG_LIBS[@]} ; do
		local paths=(
$(realpath "${EPREFIX}/usr/lib/gcc/"*"/"*"/${f}" 2>/dev/null)
$(realpath "${EPREFIX}/usr/lib/gcc/"*"/"*"/32/${f}" 2>/dev/null)
$(realpath "${EPREFIX}/lib"*"/${f}" 2>/dev/null)
$(realpath "${EPREFIX}/usr/lib"*"/${f}" 2>/dev/null)
		)
		if (( "${#paths[@]}" == 0 )) ; then
ewarn "${f} does not exist."
			continue
		fi
		local path
		path=$(echo "${paths[@]}" \
			| tr " " "\n" \
			| tail -n 1)
		local real_path=$(realpath "${path}")
		if "${BROOT}/usr/bin/readelf" -Ws "${real_path}" 2>/dev/null \
			| grep -E -q -e "(cfi_bad_type|cfi_check_fail|__cfi_init)" ; then
einfo "${f} is CFI protected."
		else
ewarn "${f} is NOT CFI protected."
		fi
	done
einfo
einfo "The information presented is a draft report that may not represent your"
einfo "configuration.  Some libraries listed may not be be able to be CFI"
einfo "Cross-DSOed."
einfo
einfo "An estimated >= 37.7% (26/69) of the libraries listed should be"
einfo "marked CFI protected."
einfo
}

print_use_flags_using_clang() {
	local U=(
		"bundled-libcxx"
		"cfi"
		"official"
		"pgo"
	)

	local u
	for u in ${U} ; do
		if use "${u}" ; then
einfo "Using ${u} USE flag which is forcing clang."
		fi
	done
}

is_using_clang() {
	# oiledmachine-overlay:  dropped lto check
	local U=(
		"bundled-libcxx"
		"cfi"
		"official"
		"pgo"
	)

	local u
	for u in ${U} ; do
		use "${u}" && return 0
	done
	return 1
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

check_security_expire() {
	local safe_period
	local now=$(date +%s)
	local dhms_passed=$(dhms_get ${MITIGATION_LAST_UPDATE} ${now})
	local channel="${SLOT#*/}"

	local desc=""
	local mitigation_use_case="${MITIGATION_USE_CASE:-socials}"
	if [[ "${mitigation_use_case}" =~ ("donations"|"email"|"legal"|"money"|"shopping") ]] ; then
		safe_period=$((60*60*24*7))
		desc="1 week"
	elif [[ "${mitigation_use_case}" =~ "socials" ]] ; then
		safe_period=$((60*60*24*14))
		desc="2 weeks"
	else
		safe_period=$((60*60*24*30))
		desc="30 days"
	fi

	if (( ${now} > ${MITIGATION_LAST_UPDATE} + ${safe_period} )) ; then
eerror
eerror "This ebuild release period is past ${desc} since release."
eerror "It is considered insecure.  As a precaution, this particular point"
eerror "release will not (re-)install."
eerror
eerror "Time passed since the last security update:  ${dhms_passed}"
eerror "Assumed use case(s):  ${mitigation_use_case}"
eerror
eerror "Solutions:"
eerror
eerror "1.  Use a newer ${channel} release from the overlay."
eerror "2.  Use the latest ${channel} distro release."
eerror "3.  Use the latest www-client/google-chrome release, temporarily."
eerror
eerror "See metadata.xml for details to adjust MITIGATION_USE_CASE."
eerror
		die
	else
einfo "Time passed since the last security update:  ${dhms_passed}"
	fi
}

check_ulimit() {
	local current_ulimit=$(ulimit -n)
	local ulimit
	if use mold ; then
	# See issue #336 in the mold repo.
		ulimit=${ULIMIT:-16384}
	else
	# The final link uses lots of file descriptors.
		ulimit=${ULIMIT:-2048}
	fi

	if (( ${current_ulimit} < ${ulimit} )) ; then
eerror
eerror "The ulimit is too low and must be ${ulimit} or higher."
eerror
eerror "Expected ulimit:  ${ulimit}"
eerror "Actual ulimit:  ${current_ulimit}"
eerror
eerror "To fix, follow exactly these steps."
eerror
eerror "1.  Add/change /etc/security/limits.conf with the following lines:"
eerror "portage         soft    nofile      ${ulimit}"
eerror "portage         hard    nofile      ${ulimit}"
eerror "2.  Run \`ulimit -n ${ulimit}\`"
eerror "3.  Run \`emerge =${CATEGORY}/${PN}-${PVR}\`"
eerror
		die
	fi
}

pkg_setup() {
	# The emerge package system will over prune when it should not when it
	# uses the mv merge technique with sandbox disabled.

	local tc_count_expected=4577
	local tc_count_actual=$(find "/usr/share/chromium/toolchain" -type f | wc -l)
	if (( ${tc_count_actual} != ${tc_count_expected} )) ; then
ewarn
ewarn "The emerge package system may have overpruned."
ewarn
ewarn "The chromium-toolchain file count is not the same.  Please re-emerge the chromium-toolchain package."
ewarn "Actual file count:  ${tc_count_actual}"
ewarn "Expected file count:  ${tc_count_expected}"
ewarn
	fi

	local sources_count_expected=738491
	local sources_count_actual=$(find "/usr/share/chromium/sources" -type f | wc -l)
	if (( ${sources_count_actual} != ${sources_count_expected} )) ; then
ewarn
ewarn "The emerge package system may have overpruned."
ewarn
ewarn "The chromium-sources file count is not the same.  Please re-emerge the chromium-sources package."
ewarn "Actual file count:  ${sources_count_actual}"
ewarn "Expected file count:  ${sources_count_expected}"
ewarn
	fi


	dhms_start
einfo "Release channel:  ${SLOT#*/}"
	if [[ -n "${MITIGATION_URI}" ]] ; then
einfo "Security announcement date:  ${MITIGATION_DATE}"
einfo "Security fixes applied:  ${MITIGATION_URI}"
einfo "Patched vulnerabilities:"
		IFS=$'\n'
		local x
		for x in ${VULNERABILITIES_FIXED[@]} ; do
			local cve=$(echo "${x}" | cut -f 1 -d ";")
			local vulnerability_classes=$(echo "${x}" | cut -f 2 -d ";")
			local severity=$(echo "${x}" | cut -f 3 -d ";")
einfo "${cve}:  ${vulnerability_classes} (CVSS 3.1 ${severity})"
		done
		IFS=$' \t\n'
einfo
einfo "DoS = Denial of Service"
einfo "DT = Data Tampering"
einfo "ID = Information Disclosure"
einfo
	fi
	pre_build_checks

	if is-flagq '-Oshit' && ! use official ; then
einfo "Detected -Oshit in cflags."
		OSHIT_OPTIMIZED=1
		replace-flags '-Oshit' '-O1'
	else
		if use official ; then
eerror "-Oshit is only available for official USE flag disabled."
eerror "Either remove the official USE flag or remove the -Oshit CFLAG."
			die
		fi
ewarn "-Oshit is missing in cflags for build speed optimized build.  See metadata.xml or \`epkginfo -x =${CATEGORY}/${P}::oiledmachine-overlay\` for details."
		OSHIT_OPTIMIZED=0
	fi

	if use official ; then
		filter-flags '-Oshit'
	fi

	if use kernel_linux ; then
		chromium_suid_sandbox_check_kernel_config
		CONFIG_CHECK="
			~SYSFS
			~MULTIUSER
			~SECURITY
			~SECURITY_YAMA
		"
		WARNING_SYSFS="CONFIG_SYSFS could be added for ptrace sandbox protection"
		WARNING_MULTIUSER="CONFIG_MULTIUSER could be added for ptrace sandbox protection"
		WARNING_SECURITY="CONFIG_SECURITY could be added for ptrace sandbox protection"
		WARNING_SECURITY_YAMA="CONFIG_SECURITY_YAMA could be added for ptrace sandbox protection to mitigate against credential theft"
		check_extra_config

		if ! linux_config_exists ; then
ewarn "Missing kernel .config file."
		fi

		if linux_chkconfig_present "SECURITY_YAMA" ; then
			local lsm=$(linux_chkconfig_string LSM)
			if [[ "${lsm}" =~ "yama" ]] ; then
				:
			else
ewarn "Missing yama in CONFIG_LSM.  Add yama to CONFIG_LSM for ptrace sandbox protection."
			fi
		fi

	# The history of the commit can be found on
	# https://community.intel.com/t5/Blogs/Tech-Innovation/Client/A-Journey-for-Landing-The-V8-Heap-Layout-Visualization-Tool/post/1368855
	# I've seen this first in the nodejs repo but never understood the benefit.
	# The same article discusses the unintended consequences.
		CONFIG_CHECK="
			~TRANSPARENT_HUGEPAGE
		"
		WARNING_TRANSPARENT_HUGEPAGE="CONFIG_TRANSPARENT_HUGEPAGE could be enabled for V8 [JavaScript engine] memory access time reduction.  For webservers, music production, realtime, it should be kept disabled."
		check_extra_config
	# In the current build files, they had went against their original decision.
	fi

	if ! use amd64 && [[ "${USE}" =~ "cfi" ]] ; then
ewarn
ewarn "All variations of the cfi USE flags are not defaults for this platform."
ewarn "Disable them if problematic."
ewarn
	fi

	local cprefix
	if tc-is-cross-compiler ; then
		cprefix="${CBUILD}"
	else
		cprefix="${CHOST}"
	fi

	# Do checks here because of references to tc-is-clang in src_prepare.
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP="$(tc-getCXX) -E"

	print_use_flags_using_clang
	if is_using_clang && ! tc-is-clang ; then
		export CC="clang"
		export CXX="clang++"
		export CPP="clang++ -E"
	fi

	if ver_test ${PV%%.*} -ne ${PATCH_VER%%-*} ; then # This line is always false, deadcode
		if tc-is-gcc ; then
eerror
eerror "GCC is disallowed.  Still waiting for the GCC patchset."
eerror
eerror "Switch to clang, or use the older ebuild if GCC is preferred at the"
eerror "cost of security."
eerror
eerror "Using GCC will be allowed for this build when minor version is"
eerror "== expected."
eerror
eerror "Current minor version:   ${PV##*.}"
eerror "Expected minor version:  == ${PATCH_VER%%.*}"
eerror
			die
		fi
	fi
	if ver_test ${PV%%.*} -lt ${PATCHSET_PPC64%%.*} ; then
		if use ppc64 ; then
eerror
eerror "PPC64 is disallowed.  Still waiting for the PPC64 patchset."
eerror
eerror "Use the older ebuild if GCC is preferred at the cost of security."
eerror
eerror "Using PPC64 will be allowed for this build when minor version is"
eerror ">= expected."
eerror
eerror "Current minor version:   ${PV##*.}"
eerror "Expected minor version:  >= ${PATCHSET_PPC64%%.*}"
eerror
		fi
	fi

	if [[ "${CHROMIUM_EBUILD_MAINTAINER}" == "1" ]] ; then
		if [[ -z "${MY_OVERLAY_DIR}" ]] ; then
eerror
eerror "You need to set MY_OVERLAY_DIR as a per-package envvar to the base path"
eerror "of your overlay or local repo.  The base path should contain all the"
eerror "overlay's categories."
eerror
			die
		fi
	fi

	if use vaapi && ( use x86 || use amd64 ) ; then
		:
	elif use vaapi ; then
ewarn
ewarn "VA-API is not enabled by default for this arch.  Please disable it if"
ewarn "problems are encountered."
ewarn
	fi

	if use system-libstdcxx ; then
ewarn
ewarn "The system's libstdcxx may weaken the security.  Consider using only the"
ewarn "bundled-libcxx instead."
ewarn
	fi

einfo
einfo "To remove the hard USE mask for the builtin pgo profile:"
einfo
einfo "  mkdir -p \"${EROOT}/etc/portage/profile\""
einfo "  echo \"www-client/chromium -pgo\" >> \"${EROOT}/etc/portage/profile/package.use.mask\""
einfo

einfo
einfo "To override the distro hard mask for ffmpeg5 do the following:"
einfo
einfo "  mkdir -p \"${EROOT}/etc/portage/profile\""
einfo "  echo \"www-client/chromium -system-ffmpeg\" >> \"${EROOT}/etc/portage/profile/package.use.mask\""
einfo

	local a
	for a in $(multilib_get_enabled_abis) ; do
		NABIS=$((${NABIS} + 1))
	done

	( use system-dav1d || use system-libaom ) && cflags-depends_check
	node_pkg_setup
	check_security_expire
	check_ulimit
}

src_unpack() {
	# In Chromium 126, upstream decided to change the way that the rust
	# toolchain is packaged, so now we get a fancy src_unpack function to
	# ensure that we don't accidentally unpack one toolchain over the other.
	# The addtional control over over unpacking also helps us ensure that GN
	# doesn't try and use some bundled tool (like bindgen) instead of the
	# system package by just not unpacking it unless we're using the bundled
	# toolchain.
	mkdir -p "${S}" || die
	cp -aT "/usr/share/chromium/sources" "${S}" || die
	export PATH="/usr/share/chromium/toolchain/gn/out:${PATH}"

	if use system-toolchain ; then
		unpack "chromium-patches-${PATCH_VER}.tar.bz2"
	else
		rm -rf "${S}/third_party/llvm-build/Release+Asserts" || true
		ln -s "/usr/share/chromium/toolchain/clang" "${S}/third_party/llvm-build/Release+Asserts" || die

		rm -rf "${S}/third_party/rust-toolchain" || true
		ln -s "/usr/share/chromium/toolchain/rust" "${S}/third_party/rust-toolchain" || die
	fi

	if use ppc64 ; then
		unpack "chromium_${PATCHSET_PPC64}.debian.tar.xz"
		unpack "chromium-ppc64le-gentoo-patches-1.tar.xz"
	fi

	if has cromite ${IUSE_EFFECTIVE} && use cromite ; then
		unpack "cromite-${CROMITE_COMMIT:0:7}.tar.gz"
	fi

	if has ungoogled-chromium ${IUSE_EFFECTIVE} && use ungoogled-chromium ; then
		unpack "ungoogled-chromium-${UNGOOGLED_CHROMIUM_PV}.tar.gz"
	fi

	if use test ; then
		# A new testdata tarball is available for each release; but testfonts tend to remain stable
		# for the duration of a release.
		# This unpacks directly into/over ${WORKDIR}/${P} so we can just use `unpack`.
		unpack "${P}-testdata-gentoo.tar.xz"
		# This just contains a bunch of font files that need to be unpacked (or moved) to the correct location.
		local testfonts_dir="${WORKDIR}/${P}/third_party/test_fonts"
		local testfonts_tar="${DISTDIR}/chromium-testfonts-${TEST_FONT:0:10}.tar.gz"
		tar xf "${testfonts_tar}" -C "${testfonts_dir}" || die "Failed to unpack testfonts"
	fi
}

is_generating_credits() {
	if [[ "${GEN_ABOUT_CREDITS}" == "1" ]] ; then
		return 0
	else
		return 1
	fi
}

apply_distro_patchset() {
einfo "Applying the distro patchset ..."
	if use system-libstdcxx ; then
	# Disable global media controls, crashes with libstdc++
		sed -i \
			-e "/\"GlobalMediaControlsCastStartStop\"/,+4{s/ENABLED/DISABLED/;}" \
			"chrome/browser/media/router/media_router_feature.cc" \
			|| true
	fi

	PATCHES+=(
		"${FILESDIR}/chromium-cross-compile.patch"
		$(use system-zlib && echo "${FILESDIR}/chromium-109-system-zlib.patch")
		"${FILESDIR}/chromium-111-InkDropHost-crash.patch"
		"${FILESDIR}/chromium-127-bindgen-custom-toolchain.patch"
		"${FILESDIR}/chromium-131-unbundle-icu-target.patch"
		"${FILESDIR}/chromium-131-oauth2-client-switches.patch"
		"${FILESDIR}/chromium-131-const-atomicstring-conversion.patch"
	)

	if use system-toolchain ; then
	# system-toolchain means system-clang, system-rust
	# The patchset is really only required if we're using the
	# system-toolchain.
		PATCHES+=(
			"${WORKDIR}/chromium-patches-${PATCH_VER}"
		)

		# We can't use the bundled compiler builtins with the system toolchain
		# `grep` is a development convenience to ensure we fail early when google changes something.
		local builtins_match="if (is_clang && !is_nacl && !is_cronet_build) {"
		grep -q \
			-e "${builtins_match}" \
			"build/config/compiler/BUILD.gn" \
			|| die "Failed to disable bundled compiler builtins"
		sed -i \
			-e "/${builtins_match}/,+2d" \
			"build/config/compiler/BUILD.gn" \
			|| true
	fi



	if use ppc64 ; then
		IFS=$'\n'
		local rows=(
			$(grep -v "^#" "${WORKDIR}/debian/patches/series" \
				| grep "^ppc64le" \
				|| die)
		)
		local p
		for p in ${rows[@]} ; do
			if [[ ! "${p}" =~ "fix-breakpad-compile.patch" ]] ; then
				eapply "${WORKDIR}/debian/patches/${p}"
			fi
		done
		IFS=$' \r\n'
		PATCHES+=(
			"${WORKDIR}/ppc64le"
			"${WORKDIR}/debian/patches/fixes/rust-clanglib.patch"
		)
	fi
}

apply_oiledmachine_overlay_patchset() {
einfo "Applying the oiledmachine-overlay patchset ..."
	if use system-toolchain && tc-is-clang ; then
	# Using gcc with these patches results in this error:
	# Two or more targets generate the same output:
	#   lib.unstripped/libEGL.so
		PATCHES+=(
			"${FILESDIR}/extra-patches/${PN}-92-clang-toolchain-1.patch"
			"${FILESDIR}/extra-patches/${PN}-92-clang-toolchain-2.patch"
		)
	fi

	if use arm64 && has_sanitizer_option "shadow-call-stack" ; then
		PATCHES+=(
			"${FILESDIR}/extra-patches/${PN}-94-arm64-shadow-call-stack.patch"
		)
	fi

	PATCHES+=(
		"${FILESDIR}/extra-patches/${PN}-123.0.6312.58-zlib-selective-simd.patch"
		"${FILESDIR}/extra-patches/${PN}-129.0.6668.70-qt6-split.patch"
		"${FILESDIR}/extra-patches/${PN}-128.0.6613.137-include-historgram-functions.patch"
		"${FILESDIR}/extra-patches/${PN}-129.0.6668.58-disable-speech.patch"
	)

	if has ungoogled-chromium ${IUSE_EFFECTIVE} && use ungoogled-chromium ; then
	# Same as USE="ungoogled-chromium cromite" or USE=ungoogled-chromium
		PATCHES+=(
			"${FILESDIR}/extra-patches/${PN}-130.0.6723.91-mold-ungoogled-chromium.patch"
		)
	elif has cromite ${IUSE_EFFECTIVE} && use cromite ; then
		PATCHES+=(
			"${FILESDIR}/extra-patches/${PN}-130.0.6723.91-mold.patch"
		)
	else
		PATCHES+=(
			"${FILESDIR}/extra-patches/${PN}-128.0.6613.137-numeric_h-for-iota.patch"
			"${FILESDIR}/extra-patches/${PN}-129.0.6668.58-include-thread-pool.patch"
			"${FILESDIR}/extra-patches/${PN}-130.0.6723.91-mold.patch"
		)
	fi

	if is-flagq '-Ofast' || is-flagq '-ffast-math' ; then
		PATCHES+=(
			"${FILESDIR}/extra-patches/${PN}-114.0.5735.133-fast-math.patch"
		)
	fi

	if use system-toolchain ; then
		# Slot 16 is selected but it spits out 17.
#
# Fixes:
#
# Returned 1 and printed out:
#
# The expected clang version is llvmorg-17-init-4759-g547e3456-1 but the actual version is
# Did you run "gclient sync"?
#
		sed -i \
			-e "/verify-version/d" \
			"build/config/compiler/BUILD.gn" \
			|| die

		PATCHES+=(
#
# Fixes:
#
# The expected Rust version is 17c11672167827b0dd92c88ef69f24346d1286dd-1-llvmorg-17-init-8029-g27f27d15-3 (or fallback 17c11672167827b0dd92c88ef69f24346d1286dd-1-llvmorg-17-init-8029-g27f27d15-1 but the actual version is None
# Did you run "gclient sync"?
			"${FILESDIR}/extra-patches/${PN}-117.0.5938.92-skip-rust-check.patch"

			"${FILESDIR}/extra-patches/${PN}-128.0.6613.84-clang-paths.patch"
		)
	fi

	PATCHES+=(
		"${FILESDIR}/extra-patches/${PN}-130.0.6723.91-custom-optimization-level.patch"
	)
	if ! use official ; then
	# This section contains significant changes.  The above sections contains minor changes.

		if has ungoogled-chromium ${IUSE_EFFECTIVE} && use ungoogled-chromium ; then
			PATCHES+=(
				"${FILESDIR}/extra-patches/${PN}-129.0.6668.70-disable-tflite-ungoogled-chromium.patch"
			)
		else
			PATCHES+=(
				"${FILESDIR}/extra-patches/${PN}-128.0.6613.137-disable-tflite.patch"
			)
		fi

		PATCHES+=(
			"${FILESDIR}/extra-patches/${PN}-128.0.6613.137-disable-perfetto.patch"
			"${FILESDIR}/extra-patches/${PN}-128.0.6613.137-disable-icu-tracing.patch"
		)

	#	Disabling async-dns causes debug crash/spam.
		if has async-dns ${IUSE_EFFECTIVE} && ! use async-dns ; then
			PATCHES+=(
				"${FILESDIR}/extra-patches/${PN}-128.0.6613.137-disable-built-in-dns.patch"
			)
		fi

		if has screen-capture ${IUSE_EFFECTIVE} && ! use screen-capture ; then
			PATCHES+=(
				"${FILESDIR}/extra-patches/${PN}-128.0.6613.137-disable-screen-capture.patch"
			)
		fi
		if ! use partitionalloc ; then
			PATCHES+=(
				"${FILESDIR}/extra-patches/${PN}-129.0.6668.58-partitionalloc-false.patch"
			)
		fi
	fi
}

is_cromite_patch_non_fatal() {
	local arg="${1}"
	local L=(
		"Add-support-to-jxl.patch"
	)
	local x
	for x in ${L[@]} ; do
		[[ "${arg}" == "${x}" ]] && return 0
	done
	return 1
}

apply_cromite_patchset() {
einfo "Applying the Cromite patchset ..."
	pushd "${S_CROMITE}" >/dev/null 2>&1 || die
		if [[ -n "${CROMITE_PATCH_BLACKLIST}" ]] ; then
			local x
			for x in ${CROMITE_PATCH_BLACKLIST} ; do
einfo "Removing ${x} from cromite"
				if [[ -e "build/cromite_patches_list_new.txt" ]] ; then
					sed -i -e "/${x}/d" "build/cromite_patches_list_new.txt" || die
				else
					sed -i -e "/${x}/d" "build/cromite_patches_list.txt" || die
				fi
			done
		fi

		# We don't hijack official.
		sed -i \
			-e "/is_official_build/d" \
			"${S_CROMITE}/build/cromite.gn_args" \
			|| die

		# Remove or dedupe debug
		sed -i \
			-e "/blink_symbol_level/d" \
			-e "/dcheck_always_on/d" \
			-e "/is_debug/d" \
			-e "/symbol_level/d" \
			"${S_CROMITE}/build/cromite.gn_args" \
			|| die

		# Use previous working choice
		sed -i \
			-e "/use_sysroot/d" \
			"${S_CROMITE}/build/cromite.gn_args" \
			|| die

		# Unforce optional
		sed -i \
			-e "/chrome_pgo_phase/d" \
			"${S_CROMITE}/build/cromite.gn_args" \
			|| die

		local L=()
		if [[ -e "build/cromite_patches_list_new.txt" ]] ; then
			L+=(
				$(cat "build/cromite_patches_list_new.txt" | sed -e "/^#/d")
			)
		else
			L+=(
				$(cat "build/cromite_patches_list.txt" | sed -e "/^#/d")
			)
		fi
		pushd "${S}" >/dev/null 2>&1 || die
			local x
			for x in ${L[@]} ; do
				[[ "${x}" =~ "Automated-domain-substitution" && "${CROMITE_SKIP_AUTOGENERATED:-1}" == "1" ]] && continue

				if is_cromite_patch_non_fatal "${x}" && grep -q -e "GIT binary patch" "${S_CROMITE}/build/patches/${x}" ; then
einfo "Applying ${x} ..."
					git apply --reject --whitespace=fix "${S_CROMITE}/build/patches/${x}" >/dev/null 2>&1 || true
					#git apply --reject --whitespace=fix "${S_CROMITE}/build/patches/${x}" || true
				elif is_cromite_patch_non_fatal "${x}" ; then
einfo "Applying ${x} ..."
					patch -p1 -i "${S_CROMITE}/build/patches/${x}" >/dev/null 2>&1 || true
					#edo patch -p1 -i "${S_CROMITE}/build/patches/${x}" >/dev/null 2>&1
				elif grep -q -e "GIT binary patch" "${S_CROMITE}/build/patches/${x}" ; then
einfo "Applying ${x} ..."
					git apply --reject --whitespace=fix "${S_CROMITE}/build/patches/${x}" >/dev/null 2>&1 || die
					#git apply --reject --whitespace=fix "${S_CROMITE}/build/patches/${x}" || die
				else
					eapply "${S_CROMITE}/build/patches/${x}"
				fi
			done
		popd >/dev/null 2>&1 || die
	popd >/dev/null 2>&1 || die
}

_apply_ungoogled_chromium_patches() {
	pushd "${S}" >/dev/null 2>&1 || die
		local x
		for x in $(cat "${S_UNGOOGLED_CHROMIUM}/patches/series") ; do
#			[[ "${x}" =~ "0001-fix-building-without-safebrowsing.patch" ]] && die
			eapply "${S_UNGOOGLED_CHROMIUM}/patches/${x}"
		done
	popd >/dev/null 2>&1 || die
}

apply_ungoogled_chromium_patchset() {
einfo "Applying the ungoogled-chromium patchset ..."
	pushd "${S_UNGOOGLED_CHROMIUM}" >/dev/null 2>&1 || die
		if [[ -n "${UNGOOGLED_CHROMIUM_PATCH_BLACKLIST}" ]] ; then
			local x
			for x in ${UNGOOGLED_CHROMIUM_PATCH_BLACKLIST} ; do
einfo "Removing ${x} from ungoogled-chromium"
				sed -i -e "/${x}/d" "patches/series" || die
			done
		fi

	# Don't touch the cached toolchain
		sed -i \
			-e "/llvm-build/d" \
			-e "/rust-toolchain/d" \
			-e "/node\/linux/d" \
			"utils/prune_binaries.py" \
			|| die

	# Allow the user to decide since it is allowed.
		sed -i \
			-e "/enable_widevine/d" \
			"utils/prune_binaries.py" || die

		edo "utils/prune_binaries.py" \
			"${S}" \
			"pruning.list" \
			|| die

	# Use this instead of utils/patches.py for more control
		_apply_ungoogled_chromium_patches

		edo "utils/domain_substitution.py" \
			"apply" \
			-r "domain_regex.list" \
			-f "domain_substitution.list" \
			-c "${WORKDIR}/domsubcache.tar.gz" \
			"${S}" \
			|| die
	popd >/dev/null 2>&1 || die
}

prepare_chromite_with_ungoogled_chromium() {
	# Fix hunk collisions.
	filterdiff \
		-x '*/chrome/browser/ui/browser_commands.cc' \
		-x '*/chrome/browser/ui/lens/lens_overlay_controller.cc' \
		-x '*/components/component_updater/installer_policies/BUILD.gn' \
		"${S_CROMITE}/build/patches/Fix-chromium-build-bugs.patch" \
		> \
		"${S_CROMITE}/build/patches/Fix-chromium-build-bugs.patch.t" \
		|| die
	mv \
		"${S_CROMITE}/build/patches/Fix-chromium-build-bugs.patch"{".t",""} \
		|| die


	# Fixed patches
	local L=(
		# source;dest
		"${FILESDIR}/ungoogled-chromium/129.0.6668.70-1/patches/core/inox-patchset/0001-fix-building-without-safebrowsing.patch;${WORKDIR}/ungoogled-chromium-${UNGOOGLED_CHROMIUM_PV}/patches/core/inox-patchset"
	)
	local x
	for x in ${L[@]} ; do
		cp -a "${x%;*}" "${x#*;}" || die
	done

	# Listed below are patch conflicts.
	#
	# Using a list generator for this will produce false positives or a
	# eager result.
	#
	# It is possible to do a dry run but it may report failure.  You still
	# can get a hunk dependency within the same patch which it doesn't
	# handle well.
	local rows=(
#		chromite_patch;ungoogle_chromium_patch
		"autofill-miscellaneous.patch;0003-disable-autofill-download-manager.patch"
		"ungoogled-chromium-no-special-hosts-domains.patch;disable-google-host-detection.patch"
		"ungoogled-chromium-Disable-untraceable-URLs.patch;all-add-trk-prefixes-to-possibly-evil-connections.patch"
		"ungoogled-chromium-Disable-untraceable-URLs.patch;disable-untraceable-urls.patch"
		"Disable-crash-reporting.patch;disable-crash-reporter.patch"
		"translate-disable-fetching-of-languages-from-server.patch;toggle-translation-via-switch.patch"
		"Remove-binary-blob-integrations.patch;disable-gcm.patch"
		"ungoogled-chromium-no-special-hosts-domains.patch;disable-domain-reliability.patch"
		"Block-qjz9zk-or-trk-requests.patch;block-trk-and-subdomains.patch"
		"Disable-references-to-fonts.googleapis.com.patch;disable-fonts-googleapis-references.patch"
		"Chrome-web-store-protection.patch;disable-webstore-urls.patch"
		"ungoogled-chromium-Disable-webRTC-log-uploader.patch;disable-webrtc-log-uploader.patch"
		"Fix-chromium-build-bugs.patch;fix-building-with-prunned-binaries.patch"
		"Fix-chromium-build-bugs.patch;disable-mei-preload.patch"
		"ungoogled-chromium-Disable-Network-Time-Tracker.patch;disable-network-time-tracker.patch"
		"ungoogled-chromium-Disable-intranet-detector.patch;disable-intranet-redirect-detector.patch"
		"Enable-native-Android-autofill.patch;fix-building-without-safebrowsing.patch"
		"Modify-default-preferences.patch;remove-unused-preferences-fields.patch"
		"Disable-privacy-sandbox.patch;disable-privacy-sandbox.patch"
		"Replace-DoH-probe-domain-with-RIPE-domain.patch;doh-changes.patch"
		"Disable-fetching-of-all-field-trials.patch;disable-fetching-field-trials.patch"
		"Modify-default-preferences.patch;0006-modify-default-prefs.patch"
		"Restore-classic-new-tab-page.patch;0008-restore-classic-ntp.patch"
		"disable-battery-status-updater.patch;0019-disable-battery-status-service.patch"
		"Do-not-build-API-keys-infobar.patch;google-api-warning.patch"
		"mime_util-force-text-x-suse-ymp-to-be-downloaded.patch;mime_util-force-text-x-suse-ymp-to-be-downloaded.patch"
		"prefs-always-prompt-for-download-directory.patch;prefs-always-prompt-for-download-directory-by-defaul.patch"
		"Remove-EV-certificates.patch;Remove-EV-certificates.patch"
		"Multiple-fingerprinting-mitigations.patch;fingerprinting-flags-client-rects-and-measuretext.patch"
		"Multiple-fingerprinting-mitigations.patch;flag-max-connections-per-host.patch"
		"Multiple-fingerprinting-mitigations.patch;flag-fingerprinting-canvas-image-data-noise.patch"
		"Disable-omission-of-URL-elements.patch;disable-formatting-in-omnibox.patch"
		"dns-send-IPv6-connectivity-probes-to-RIPE-DNS.patch;add-ipv6-probing-option.patch"
		"dns-send-IPv6-connectivity-probes-to-RIPE-DNS.patch;add-flag-to-configure-extension-downloading.patch"
		"dns-send-IPv6-connectivity-probes-to-RIPE-DNS.patch;add-flag-for-search-engine-collection.patch"
		"dns-send-IPv6-connectivity-probes-to-RIPE-DNS.patch;add-flag-to-disable-beforeunload.patch"
	)

	# C_VS_UC_PREFERENCE - space separated list in the format of which patch you prefer.
	# C_VS_UC_PREFERENCE="Chrome-web-store-protection.patch autofill-miscellaneous.patch ..."

	if [[ -z "${C_VS_UC_PREFERENCE}" ]] ; then
einfo "Preferring Cromite over ungoogled-chromium"
# TODO: remove comment
		#C_VS_UC_PREFERENCE=${C_VS_UC_PREFERENCE:-"cromite"}
	fi

	is_user_choice_cromite() {
		local user_choices="${C_VS_UC_PREFERENCE}"
		local user_choice
		for user_choice in ${user_choices} ; do
			local row
			for row in ${rows[@]} ; do
				local cromite_patch="${row%;*}"
				[[ "${user_choice}" == "${cromite_patch}" ]] && return 0
			done
		done

		[[ "${user_choices,,}" == "cromite" ]] && return 0

		return 1
	}

	is_user_choice_ungoogled_chromium() {
		local user_choices="${C_VS_UC_PREFERENCE}"
		local user_choice
		for user_choice in ${user_choices} ; do
			local row
			for row in ${rows[@]} ; do
				local ungoogled_chromium_patch="${row#*;}"
				[[ "${user_choice}" == "${ungoogled_chromium_patch}" ]] && return 0
			done
		done

		[[ "${user_choices,,}" == "ungoogled-chromium" ]] && return 0

		return 1
	}

	local row
	for row in ${rows[@]} ; do
		local cromite_patch=$(echo "${row}" | cut -f 1 -d ";")
		local ungoogle_chromium_patch=$(echo "${row}" | cut -f 2 -d ";")
		if is_user_choice_cromite ; then
			local x="${ungoogle_chromium_patch}"
			sed -i -e "/${x}/d" "${S_UNGOOGLED_CHROMIUM}/patches/series" || die
		elif is_user_choice_ungoogled_chromium ; then
			local x="${chromite_patch}"
			if [[ -e "build/cromite_patches_list_new.txt" ]] ; then
				sed -i -e "/${x}/d" "${S_CROMITE}/build/cromite_patches_list_new.txt" || die
			else
				sed -i -e "/${x}/d" "${S_CROMITE}/build/cromite_patches_list.txt" || die
			fi
		else
eerror
eerror "Invalid choice.  You must choose on of the patches on the right to resolve this conflict."
eerror
eerror "Valid values:"
eerror
eerror "         Chromite patch:  ${chromite_patch}"
eerror "ungoogle-chromium patch:  ${ungoogle_chromium_patch}"
eerror
			die
		fi
	done

}

src_prepare() {
	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	check_deps_cfi_cross_dso

	local PATCHES=()


	if has ungoogled-chromium ${IUSE_EFFECTIVE} && use ungoogled-chromium && has cromite ${IUSE_EFFECTIVE} && use cromite ; then
		prepare_chromite_with_ungoogled_chromium
	fi

	if has cromite ${IUSE_EFFECTIVE} && use cromite ; then
		apply_cromite_patchset
	fi
	if has ungoogled-chromium ${IUSE_EFFECTIVE} && use ungoogled-chromium ; then
		apply_ungoogled_chromium_patchset
	fi

	# Proper CFI requires static linkage.
	# You can use Cross DSO CFI (aka dynamic .so linkage) but the attack
	# surface would increase.
	# cfi-icall with static linkage may have less breakage than dynamic,
	# which will force user to disable cfi-icall in Cross DSO CFI unvendored
	# lib.
	apply_distro_patchset

	if [[ "${APPLY_OILEDMACHINE_OVERLAY_PATCHSET:-1}" == "1" ]] ; then
		apply_oiledmachine_overlay_patchset
	else
ewarn "The oiledmachine-overlay patchset is not ready.  Skipping."
	fi

	default

	if (( ${#PATCHES[@]} > 0 )) || [[ -f "${T}/epatch_user.log" ]] ; then
		if use official ; then
ewarn "The use of unofficial patches is not endorsed upstream."
		fi

		if use pgo ; then
ewarn "The use of patching can interfere with the pregenerated PGO profile."
		fi
	fi

	rm "third_party/node/linux/node-linux-x64/bin/node" || die
	ln -s \
		"${EPREFIX}/usr/bin/node" \
		"third_party/node/linux/node-linux-x64/bin/node" \
		|| die

	# Adjust the python interpreter version
	sed -i -e "s|\(^script_executable = \).*|\1\"${EPYTHON}\"|g" ".gn" || die

	#
	# remove_bundled_libraries.py walks the source tree and looks for paths
	# containing the substring 'third_party'.
	#
	# The whitelist uses the right-most matching path component, so we need
	# to whitelist from that point down.
	#
	local keeplibs=(
		base/third_party/cityhash
		base/third_party/double_conversion
		base/third_party/icu
		base/third_party/nspr
		base/third_party/superfasthash
		base/third_party/symbolize
		base/third_party/xdg_user_dirs
		buildtools/third_party/libc++
		buildtools/third_party/libc++abi
		chrome/third_party/mozilla_security_manager
		net/third_party/mozilla_security_manager
		net/third_party/nss
		net/third_party/quic
		net/third_party/uri_template
		third_party/abseil-cpp
		third_party/angle
		third_party/angle/src/common/third_party/xxhash
		third_party/angle/src/third_party/ceval
		third_party/angle/src/third_party/libXNVCtrl
		third_party/angle/src/third_party/volk
		third_party/anonymous_tokens
		third_party/apple_apsl
		third_party/axe-core
		third_party/bidimapper
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
		third_party/content_analysis_sdk
		third_party/cpuinfo
		third_party/crabbyavif
		third_party/crashpad
		third_party/crashpad/crashpad/third_party/lss
		third_party/crashpad/crashpad/third_party/zlib
		third_party/crc32c
		third_party/cros_system_api
		third_party/d3
		third_party/dawn
		third_party/dawn/third_party/gn/webgpu-cts
		third_party/dawn/third_party/khronos
		third_party/depot_tools
		third_party/devscripts
		third_party/devtools-frontend
		third_party/devtools-frontend/src/front_end/third_party/acorn
		third_party/devtools-frontend/src/front_end/third_party/additional_readme_paths.json
		third_party/devtools-frontend/src/front_end/third_party/axe-core
		third_party/devtools-frontend/src/front_end/third_party/chromium
		third_party/devtools-frontend/src/front_end/third_party/codemirror
		third_party/devtools-frontend/src/front_end/third_party/csp_evaluator
		third_party/devtools-frontend/src/front_end/third_party/diff
		third_party/devtools-frontend/src/front_end/third_party/i18n
		third_party/devtools-frontend/src/front_end/third_party/intl-messageformat
		third_party/devtools-frontend/src/front_end/third_party/json5
		third_party/devtools-frontend/src/front_end/third_party/lighthouse
		third_party/devtools-frontend/src/front_end/third_party/lit
		third_party/devtools-frontend/src/front_end/third_party/marked
		third_party/devtools-frontend/src/front_end/third_party/puppeteer
		third_party/devtools-frontend/src/front_end/third_party/puppeteer/package/lib/esm/third_party/mitt
		third_party/devtools-frontend/src/front_end/third_party/puppeteer/package/lib/esm/third_party/parsel-js
		third_party/devtools-frontend/src/front_end/third_party/puppeteer/package/lib/esm/third_party/rxjs
		third_party/devtools-frontend/src/front_end/third_party/third-party-web
		third_party/devtools-frontend/src/front_end/third_party/vscode.web-custom-data
		third_party/devtools-frontend/src/front_end/third_party/wasmparser
		third_party/devtools-frontend/src/front_end/third_party/web-vitals
		third_party/devtools-frontend/src/third_party
		third_party/distributed_point_functions
		third_party/dom_distiller_js
		third_party/eigen3
		third_party/emoji-segmenter
		third_party/farmhash
		third_party/fast_float
		third_party/fdlibm
		third_party/fft2d
		third_party/flatbuffers
		third_party/fp16
		third_party/freetype
		third_party/fusejs
		third_party/fxdiv
		third_party/gemmlowp
		third_party/google_input_tools
		third_party/google_input_tools/third_party/closure_library
		third_party/google_input_tools/third_party/closure_library/third_party/closure
		third_party/googletest
		third_party/highway
		third_party/hunspell
		third_party/iccjpeg
		third_party/ink_stroke_modeler/src/ink_stroke_modeler
		third_party/ink_stroke_modeler/src/ink_stroke_modeler/internal
		third_party/ink/src/ink/brush
		third_party/ink/src/ink/color
		third_party/ink/src/ink/geometry
		third_party/ink/src/ink/rendering
		third_party/ink/src/ink/rendering/skia/common_internal
		third_party/ink/src/ink/rendering/skia/native
		third_party/ink/src/ink/rendering/skia/native/internal
		third_party/ink/src/ink/strokes
		third_party/ink/src/ink/types
		third_party/inspector_protocol
		third_party/ipcz
		third_party/jinja2
		third_party/jsoncpp
		third_party/jstemplate
		third_party/khronos
		third_party/lens_server_proto
		third_party/leveldatabase
		third_party/libaddressinput
		third_party/libavif
		#third_party/libc++ # We want the flexibility to one day use gcc again.  We do not want to be cornered into a particular license.
		third_party/libevent
		third_party/libgav1
		third_party/libjingle
		third_party/libphonenumber
		third_party/libsecret
		third_party/libsrtp
		third_party/libsync
		third_party/liburlpattern
		third_party/libva_protected_content
		third_party/libvpx
		third_party/libvpx/source/libvpx/third_party/x86inc
		third_party/libwebm
		third_party/libx11
		third_party/libxcb-keysyms
		third_party/libxml/chromium
		third_party/libyuv
		third_party/libzip
		third_party/lit
		third_party/lottie
		third_party/lss
		third_party/lzma_sdk
		third_party/mako
		third_party/markupsafe
		third_party/material_color_utilities
		third_party/mesa
		third_party/metrics_proto
		third_party/minigbm
		third_party/modp_b64
		third_party/nasm
		third_party/nearby
		third_party/neon_2_sse
		third_party/node
		third_party/omnibox_proto
		third_party/one_euro_filter
		third_party/openscreen
		third_party/openscreen/src/third_party
		third_party/openscreen/src/third_party/tinycbor/src/src
		third_party/ots
		third_party/pdfium
		third_party/pdfium/third_party/agg23
		third_party/pdfium/third_party/bigint
		third_party/pdfium/third_party/freetype
		third_party/pdfium/third_party/lcms
		third_party/pdfium/third_party/libopenjpeg
		third_party/pdfium/third_party/libtiff
		third_party/perfetto
		third_party/perfetto/protos/third_party/chromium
		third_party/perfetto/protos/third_party/simpleperf
		third_party/pffft
		third_party/ply
		third_party/polymer
		third_party/private_membership
		third_party/private-join-and-compute
		third_party/protobuf
		third_party/pthreadpool
		third_party/puffin
		third_party/pyjson5
		third_party/pyyaml
		third_party/qcms
		third_party/rapidhash
		third_party/rnnoise
		third_party/rust
		third_party/ruy
		third_party/s2cellid
		third_party/securemessage
		third_party/selenium-atoms
		third_party/sentencepiece
		third_party/sentencepiece/src/third_party/darts_clone
		third_party/shell-encryption
		third_party/simplejson
		third_party/six
		third_party/skia
		third_party/skia/include/third_party/vulkan
		third_party/skia/third_party/vulkan
		third_party/smhasher
		third_party/snappy
		third_party/spirv-headers
		third_party/spirv-tools
		third_party/sqlite
		third_party/swiftshader
		third_party/swiftshader/third_party/astc-encoder
		third_party/swiftshader/third_party/llvm-subzero
		third_party/swiftshader/third_party/marl
		third_party/swiftshader/third_party/SPIRV-Headers/include/spirv
		third_party/swiftshader/third_party/SPIRV-Tools
		third_party/swiftshader/third_party/subzero
		third_party/tensorflow_models
		third_party/tensorflow-text
		third_party/tflite
		third_party/tflite/src/third_party/eigen3
		third_party/tflite/src/third_party/fft2d
		third_party/tflite/src/third_party/xla/third_party/tsl
		third_party/tflite/src/third_party/xla/xla/tsl/framework
		third_party/tflite/src/third_party/xla/xla/tsl/lib/random
		third_party/tflite/src/third_party/xla/xla/tsl/protobuf
		third_party/tflite/src/third_party/xla/xla/tsl/util
		third_party/ukey2
		third_party/unrar
		third_party/utf
		third_party/vulkan
		third_party/wayland
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
		third_party/xnnpack
		third_party/zlib/google
		third_party/zxcvbn-cpp
		url/third_party/mozilla
		v8/src/third_party/siphash
		v8/src/third_party/utf8-decoder
		v8/src/third_party/valgrind
		v8/third_party/glibc
		v8/third_party/inspector_protocol
		v8/third_party/v8

	# gyp -> gn leftovers
		third_party/speech-dispatcher
		third_party/usb_ids
		third_party/xdg-utils

	# Required in both cases
		third_party/ffmpeg

		$(use !system-dav1d && echo "
			third_party/dav1d
		")
		$(use !system-flac && echo "
			third_party/flac
		")
		$(use !system-fontconfig && echo "
			third_party/fontconfig
		")
		$(use !system-harfbuzz && echo "
			third_party/harfbuzz-ng
		")
		$(use !system-icu && echo "
			third_party/icu
		")
		$(use !system-libaom && echo "
			third_party/libaom
			third_party/libaom/source/libaom/third_party/fastfeat
			third_party/libaom/source/libaom/third_party/SVT-AV1
			third_party/libaom/source/libaom/third_party/vector
			third_party/libaom/source/libaom/third_party/x86inc
		")
		$(use !system-libdrm && echo "
			third_party/libdrm
		")
		$(use !system-libjpeg-turbo && echo "
			third_party/libjpeg_turbo
		")
		$(use !system-libpng && echo "
			third_party/libpng
		")
		$(use !system-libstdcxx && echo "
			third_party/libc++
		")
		$(use !system-libwebp && echo "
			third_party/libwebp
		")
		$(use !system-libxml && echo "
			third_party/libxml
		")
		$(use !system-libxslt && echo "
			third_party/libxslt
		")
		$(use !system-openh264 && echo "
			third_party/openh264
		")
		$(use !system-opus && echo "
			third_party/opus
		")
		$(use !system-re2 && echo "
			third_party/re2
		")
		$(use !system-zlib && echo "
			third_party/zlib
		")
		$(use !system-zlib && echo "
			third_party/zstd
		")
	#
	# Do not remove the third_party/zlib below. \
	#
	# Error:  ninja: error: '../../third_party/zlib/adler32_simd.c', \
	# needed by 'obj/third_party/zlib/zlib_adler32_simd/adler32_simd.o', \
	# missing and no known rule to make it
	#
	# third_party/zlib is already kept but may use system no need split \
	# conditional for CFI or official builds.
	#
		$(use !system-zlib && echo "
			third_party/zlib
		")
	# Arch-specific
		$((use arm64 || use ppc64) && echo "
			third_party/swiftshader/third_party/llvm-10.0
		")

	# tar tvf /var/cache/distfiles/${P}-testdata.tar.xz \
	#	| grep '^d' \
	#	| grep 'third_party' \
	#	| awk '{print $NF}'
		$(use test && echo "
			third_party/google_benchmark/src/include/benchmark
			third_party/google_benchmark/src/src
			third_party/perfetto/protos/third_party/pprof
			third_party/test_fonts
			third_party/test_fonts/fontconfig
		")
	)

	if has cromite ${IUSE_EFFECTIVE} && use cromite ; then
		keeplibs+=(
			cromite_flags/third_party
			third_party/chromite
		)
	fi

	# We need to generate ppc64 stuff because upstream does not ship it yet
	# it has to be done before unbundling.
	if use ppc64 ; then
		pushd "third_party/libvpx" >/dev/null 2>&1 || die
			mkdir -p "source/config/linux/ppc64" || die
	# The script requires git and clang, bug #832803
	# Revert https://chromium.googlesource.com/chromium/src/+/b463d0f40b08b4e896e7f458d89ae58ce2a27165%5E%21/third_party/libvpx/generate_gni.sh
	# and https://chromium.googlesource.com/chromium/src/+/71ebcbce867dd31da5f8b405a28fcb0de0657d91%5E%21/third_party/libvpx/generate_gni.sh
	# since we're not in a git repo
			sed -i \
				-e "s|^update_readme||g"
				-e "s|clang-format|${EPREFIX}/bin/true|g"
				-e "/^git -C/d"
				-e "/git cl/d"
				-e "/cd \$BASE_DIR\/\$LIBVPX_SRC_DIR/ign format --in-place \$BASE_DIR\/BUILD.gn\ngn format --in-place \$BASE_DIR\/libvpx_srcs.gni" \
				"generate_gni.sh" \
				|| die
			"./generate_gni.sh" || die
		popd >/dev/null 2>&1 || die

		pushd "third_party/ffmpeg" >/dev/null 2>&1 || die
			cp \
				"libavcodec/ppc/h264dsp.c" \
				"libavcodec/ppc/h264dsp_ppc.c" \
				|| die
			cp \
				"libavcodec/ppc/h264qpel.c" \
				"libavcodec/ppc/h264qpel_ppc.c" \
				|| die
		popd >/dev/null 2>&1 || die
	fi

	# Sanity check keeplibs, on major version bumps it is often necessary to update this list
	# and this enables us to hit them all at once.
	# There are some entries that need to be whitelisted (TODO: Why? The file is understandable, the rest seem odd)
	whitelist_libs=(
		"net/third_party/quic"
		"third_party/devtools-frontend/src/front_end/third_party/additional_readme_paths.json"
		"third_party/libjingle"
		"third_party/mesa"
		"third_party/skia/third_party/vulkan"
		"third_party/vulkan"
	)
	local not_found_libs=()
	for lib in "${keeplibs[@]}"; do
		if [[ ! -d "${lib}" ]] && ! has "${lib}" "${whitelist_libs[@]}"; then
			not_found_libs+=( "${lib}" )
		fi
	done

	if (( ${#not_found_libs[@]} > 0 )); then
eerror "The following \`keeplibs\` directories were not found in the source tree:"
		local lib
		for lib in "${not_found_libs[@]}"; do
			eerror "  ${lib}"
		done
eerror "Please update the ebuild."
		die
	fi

	if ! is_generating_credits ; then
einfo "Unbundling third party internal libraries and packages"
	# Remove most bundled libraries. Some are still needed.
		"build/linux/unbundle/remove_bundled_libraries.py" \
			"${keeplibs[@]}" \
			--do-remove \
			|| die
	fi

	# TODO: From 127, chromium includes a bunch of binaries? Unbundle them.
	# They're not needed.

	if ! is_generating_credits ; then
	# The bundled eu-strip is for amd64 only and we don't want to pre-strip
	# binaries.
		mkdir -p "buildtools/third_party/eu-strip/bin" || die
		ln -s \
			"${BROOT}/bin/true" \
			"buildtools/third_party/eu-strip/bin/eu-strip" \
			|| die
	fi

	(( ${NABIS} > 1 )) && multilib_copy_sources
}

has_sanitizer_option() {
	local needle="${1}"
	local haystack
	for haystack in $(echo "${CFLAGS}" \
		| grep -E -e "-fsanitize=[a-z,]+( |$)" \
		| sed -e "s|-fsanitize||g" | tr "," "\n") ; do
		[[ "${haystack}" == "${needle}" ]] && return 0
	done
	return 1
}

append_all() {
	append-flags ${@}
	append-ldflags ${@}
}

# Same as:
# portageq metadata "${repo_root}" installed "${atom}" repository
get_repo() {
	local repo_root="${1}"
	local atom="${2}"
	# This is much faster than portageq
	local f="${repo_root}/var/db/pkg/www-client/google-chrome-120.0.6099.109/repository"
	if [[ -e "${f}" ]] ; then
		local repo=$(cat "${repo_root}/var/db/pkg/www-client/google-chrome-120.0.6099.109/repository")
		echo "${repo}"
	else
		echo ""
	fi
}

show_clang_header_warning() {
	local clang_slot="${1}"
	grep -q -r \
		-e "FORCE_CLANG_STDATOMIC_H" \
		"${ESYSROOT}/usr/lib/clang/${clang_slot}/include/stdatomic.h" \
		&& return
ewarn
ewarn "${ESYSROOT}/usr/lib/clang/${clang_slot}/include/stdatomic.h requires header"
ewarn "modifications.  Solutions..."
ewarn
ewarn "Solution 1 - Manual edit:"
ewarn
ewarn "  See ebuild for details with keyword search atomic_load."
ewarn
ewarn "Solution 2 - Emerge either:"
ewarn
ewarn "  sys-devel/clang:16::oiledmachine-overlay"
ewarn "  sys-devel/clang:17::oiledmachine-overlay"
ewarn
ewarn "Solution 3 - Emerge this package with gcc."
ewarn
#
# The problem:
#
#../../third_party/boringssl/src/crypto/refcount_c11.c:37:23: error: address argument to atomic operation must be a pointer to a trivially-copyable type ('_Atomic(CRYPTO_refcount_t) *' invalid)
#  uint32_t expected = atomic_load(count);
#                      ^~~~~~~~~~~~~~~~~~
#/usr/lib/gcc/xxx-pc-linux-gnu/12/include/stdatomic.h:142:27: note: expanded from macro 'atomic_load'
##define atomic_load(PTR)  atomic_load_explicit (PTR, __ATOMIC_SEQ_CST)
#                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#/usr/lib/gcc/xxx-pc-linux-gnu/12/include/stdatomic.h:138:5: note: expanded from macro 'atomic_load_explicit'
#    __atomic_load (__atomic_load_ptr, &__atomic_load_tmp, (MO));        \
#    ^              ~~~~~~~~~~~~~~~~~
#
# The solution:
#
# Change /usr/lib/clang/17/include/stdatomic.h as follows:
#
##if __STDC_HOSTED__ &&                                                          \
#    __has_include_next(<stdatomic.h>) &&                                        \
#    (!defined(_MSC_VER) || (defined(__cplusplus) && __cplusplus >= 202002L)) && \
#    (!defined(FORCE_CLANG_STDATOMIC_H))
#
# "and emerge with clang:17."
#
}

_set_system_cc() {
	# Final CC selected
	LLVM_SLOT=""
	local clang_allowed=1
	[[ "${FEATURES}" =~ "icecream" ]] && clang_allowed=0
	if (( ${clang_allowed} == 1 )) && ( tc-is-clang || is_using_clang ) ; then # Force clang either way
einfo "Switching to clang."
	# See build/toolchain/linux/unbundle/BUILD.gn for allowed overridable envvars.
	# See build/toolchain/gcc_toolchain.gni#L657 for consistency.

		local slot
		if use official ; then
			slot="${LLVM_OFFICIAL_SLOT}"
		elif tc-is-clang ; then
			slot="$(clang-major-version)"
		else
			local s
			for s in ${LLVM_COMPAT[@]} ; do
				if has_version "sys-devel/clang:${s}" ; then
					slot="${s}"
					break
				fi
			done
		fi

		LLVM_SLOT="${slot}"
einfo "PATH=${PATH} (before)"
		export PATH=$(echo "${PATH}" \
			| tr ":" "\n" \
			| sed -e "/llvm/d" \
			| tr "\n" ":" \
			| sed -e "s|/opt/bin|/opt/bin:${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}/bin:${PWD}/install/bin|g")
einfo "PATH=${PATH} (after)"

		if [[ -z "${LLVM_SLOT}" ]] ; then
			die "LLVM_SLOT should not be empty"
		fi

		if tc-is-cross-compiler ; then
			export CC="${CBUILD}-clang-${LLVM_SLOT} -target ${CHOST} --sysroot ${ESYSROOT} $(get_abi_CFLAGS ${ABI})"
			export CXX="${CBUILD}-clang++-${LLVM_SLOT} -target ${CHOST} --sysroot ${ESYSROOT} $(get_abi_CFLAGS ${ABI})"
			export BUILD_CC="${CBUILD}-clang-${LLVM_SLOT}"
			export BUILD_CXX="${CBUILD}-clang++-${LLVM_SLOT}"
			export BUILD_AR="llvm-ar"
			export BUILD_NM="llvm-nm"
		else
			export CC="${CHOST}-clang-${LLVM_SLOT} $(get_abi_CFLAGS ${ABI})"
			export CXX="${CHOST}-clang++-${LLVM_SLOT} $(get_abi_CFLAGS ${ABI})"
		fi

		if tc-is-cross-compiler ; then
			CPP="${CBUILD}-clang++-${LLVM_SLOT} -E"
		else
			CPP="${CHOST}-clang++-${LLVM_SLOT} -E"
		fi

		export AR="llvm-ar" # Required for LTO
		export NM="llvm-nm"
		export READELF="llvm-readelf"
		export STRIP="llvm-strip"
		if ! which llvm-ar 2>/dev/null 1>/dev/null ; then
			die "llvm-ar is unreachable"
		fi
		if has_version "=sys-devel/llvm-${LLVM_SLOT}.0.9999" ; then
			if \
				   has_version "=sys-devel/llvm-${LLVM_SLOT}.0.9999[-fallback-commit]" \
				|| has_version "=sys-devel/clang-${LLVM_SLOT}.0.9999[-fallback-commit]" \
				|| has_version "=sys-devel/lld-${LLVM_SLOT}.0.9999[-fallback-commit]" \
				|| has_version "=sys-libs/compiler-rt-sanitizers-${LLVM_SLOT}.0.9999[-fallback-commit]" \
				|| has_version "=sys-libs/compiler-rt-${LLVM_SLOT}.0.9999[-fallback-commit]" \
				|| has_version "=sys-devel/clang-runtime-${LLVM_SLOT}.0.9999[-fallback-commit]" \
			; then
eerror
eerror "The fallback-commit USE flag is required."
eerror
eerror "emerge =sys-devel/llvm-${LLVM_SLOT}.0.0.9999[fallback-commit] \\"
eerror "       =sys-devel/clang-${LLVM_SLOT}.0.0.9999 \\"
eerror "       =sys-devel/lld-${LLVM_SLOT}.0.0.9999 \\"
eerror "       =sys-libs/compiler-rt-sanitizers-${LLVM_SLOT}.0.0.9999 \\"
eerror "       =sys-libs/compiler-rt-${LLVM_SLOT}.0.0.9999 \\"
eerror "       =sys-devel/clang-runtime-${LLVM_SLOT}.0.0.9999"
eerror
				die
			fi
		fi

		# Get the stdatomic.h from clang not from gcc.
		append-cflags -stdlib=libc++
		append-ldflags -stdlib=libc++
		if ver_test ${LLVM_SLOT} -ge 16 ; then
			append-cppflags "-isystem/usr/lib/clang/${LLVM_SLOT}/include"
			show_clang_header_warning "${LLVM_SLOT}"
		else
			local clang_pv=$(best_version "sys-devel/clang:${LLVM_SLOT}" \
				| sed -e "s|sys-devel/clang-||")
			clang_pv=$(ver_cut 1-3 "${clang_pv}")
			append-cppflags "-isystem/usr/lib/clang/${clang_pv}/include"
			show_clang_header_warning "${clang_pv}"
		fi
		append-cppflags -DFORCE_CLANG_STDATOMIC_H
	else
einfo "Switching to GCC"
		unset GCC_SLOT
		local s
		for s in ${GCC_COMPAT[@]} ; do
			if has_version "sys-devel/gcc:${s}" ; then
				GCC_SLOT="${s}"
				break
			fi
		done

		if tc-is-cross-compiler ; then
			export CC="${CBUILD}-gcc-${GCC_SLOT} $(get_abi_CFLAGS ${ABI})"
			export CXX="${CBUILD}-g++-${GCC_SLOT} $(get_abi_CFLAGS ${ABI})"
			export BUILD_CC="${CBUILD}-gcc-${GCC_SLOT}"
			export BUILD_CXX="${CBUILD}-g++-${GCC_SLOT}"
			export BUILD_AR="ar"
			export BUILD_NM="nm"
		else
			export CC="${CHOST}-gcc-${GCC_SLOT} $(get_abi_CFLAGS ${ABI})"
			export CXX="${CHOST}-g++-${GCC_SLOT} $(get_abi_CFLAGS ${ABI})"
		fi

		if tc-is-cross-compiler ; then
			CPP="${CBUILD}-g++-${LLVM_SLOT} -E"
		else
			CPP="${CHOST}-g++-${LLVM_SLOT} -E"
		fi

		export AR="ar"
		export NM="nm"
		export READELF="readelf"
		export STRIP="strip"
		export LD="ld.bfd"

		if ! use system-libstdcxx ; then
eerror "The system-libstdcxx USE flag must be enabled for GCC builds."
			die
		fi
	fi
	# Check for missing symbols bug.
	if ! ${CC} --version ; then
eerror
eerror "Failed sanity check.  Rebuild the entire compiler toolchain or unemerge"
eerror "this slot."
eerror
		die
	fi
	_system_toolchain_checks

	# Make sure the build system will use the right tools, bug #340795.
	tc-export AR CC CXX NM READELF STRIP

	strip-unsupported-flags
}

_src_configure_compiler() {
	if use system-toolchain ; then
		_set_system_cc
	else
		export PATH="${S}/third_party/llvm-build/Release+Asserts/bin:${PATH}"
		export PATH="${S}/third_party/rust-toolchain/bin:${PATH}"
		export CC="clang"
		export CXX="clang++"
		export CPP="${CXX} -E"
		export AR="llvm-ar"
		export NM="llvm-nm"
		export OBJCOPY="llvm-objcopy"
		export OBJDUMP="llvm-objdump"
		export READELF="llvm-readelf"
		export STRIP="llvm-strip"
		LLVM_SLOT=$(clang-major-version)
		[[ "${LLVM_OFFICIAL_SLOT}" != "${LLVM_SLOT}" ]] && die "Fix LLVM_OFFICIAL_SLOT or VENDORED_CLANG_VER"
	fi
	strip-unsupported-flags
	if use official ; then
		filter-flags '-march=*'
		filter-flags '-O*'
		strip-flags
	fi
	${CC} --version || die
}

src_configure() {
	:
}

_src_configure() {
	local s
	s=$(_get_s)
	cd "${s}" || die

	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	local total_ram=$(free | grep "Mem:" | sed -E -e "s|[ ]+| |g" | cut -f 2 -d " ")
	local total_ram_gib=$(( ${total_ram} / (1024*1024) ))
	local total_swap=$(free | grep "Swap:" | sed -E -e "s|[ ]+| |g" | cut -f 2 -d " ")
	[[ -z "${total_swap}" ]] && total_swap=0
	local total_swap_gib=$(( ${total_swap} / (1024*1024) ))
	local total_mem=$(free -t | grep "Total:" | sed -E -e "s|[ ]+| |g" | cut -f 2 -d " ")
	local total_mem_gib=$(( ${total_mem} / (1024*1024) ))

	local jobs=$(get_makeopts_jobs)
	local nprocs=$(get_nproc) # It is the same as the number of cores.

	local minimal_gib_per_core=4
	local actual_gib_per_core=$(python -c "print(${total_mem_gib} / ${nprocs})")

	if (( ${actual_gib_per_core%.*} >= ${minimal_gib_per_core} )) ; then
einfo "Minimal GiB per core:  >= ${minimal_gib_per_core} GiB"
einfo "Actual GiB per core:  ${actual_gib_per_core} GiB"
	else
ewarn "Minimal GiB per core:  >= ${minimal_gib_per_core} GiB"
ewarn "Actual GiB per core:  ${actual_gib_per_core} GiB"
	fi

	local myconf_gn=""

if use system-toolchain ; then #################################################
einfo "Using the system toolchain"
	# See _set_system_cc

	# Handled by the build scripts
	filter-flags \
		'-f*sanitize*' \
		'-f*visibility*'

	if tc-is-clang ; then
		myconf_gn+=" is_clang=true"
		myconf_gn+=" clang_use_chrome_plugins=false"
	# Workaround for build failure with clang-18 and -march=native without
	# avx512. Does not affect e.g. -march=skylake, only native (bug #931623).
		use amd64 && is-flagq -march=native &&
			[[ $(clang-major-version) -eq "18" ]] && [[ $(clang-minor-version) -lt "6" ]] &&
			tc-cpp-is-true "!defined(__AVX512F__)" ${CXXFLAGS} &&
			append-flags -mevex512
	else
		myconf_gn+=" is_clang=false"
	fi

	# Handled by build scripts
	filter-flags '-fuse-ld=*'

	if tc-is-clang ; then
	# https://bugs.gentoo.org/918897#c32
		append-ldflags -Wl,--undefined-version
		myconf_gn+=" use_lld=true"
	else
	# This doesn't prevent lld from being used, but rather prevents gn from
	# forcing it.
		myconf_gn+=" use_lld=false"
	fi

	# Strip incompatable linker flags
	strip-unsupported-flags

	if is-flagq '-flto' || tc-is-clang ; then
		AR="llvm-ar"
		NM="llvm-nm"
		if tc-is-cross-compiler ; then
			BUILD_AR="llvm-ar"
			BUILD_NM="llvm-nm"
		fi
	fi

	# Define a custom toolchain for GN
	myconf_gn+=" custom_toolchain=\"//build/toolchain/linux/unbundle:default\""

	if tc-is-clang ; then
		myconf_gn+=" clang_base_path=\"${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}\""
	fi

	if tc-is-cross-compiler ; then
		tc-export BUILD_{AR,CC,CXX,NM}
		myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:host\""
		myconf_gn+=" v8_snapshot_toolchain=\"//build/toolchain/linux/unbundle:host\""
		myconf_gn+=" pkg_config=\"$(tc-getPKG_CONFIG)\""
		myconf_gn+=" host_pkg_config=\"$(tc-getBUILD_PKG_CONFIG)\""

	# Setup cups-config, build system only uses --libs option
		if use cups; then
			mkdir "${T}/cups-config" || die
			cp \
				"${ESYSROOT}/usr/bin/${CHOST}-cups-config" \
				"${T}/cups-config/cups-config" \
				|| die
			export PATH="${PATH}:${T}/cups-config"
		fi

	# Don't inherit PKG_CONFIG_PATH from environment
		local -x PKG_CONFIG_PATH=
	else
		myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:default\""
	fi

	# Silence
	# The expected Rust version is [...] but the actual version is None
	#myconf_gn+=" use_chromium_rust_toolchain=false"

	# We don't want to depend on llvm/llvm-r1 eclasses.

	# Set LLVM_CONFIG to help Meson (bug #907965) but only do it
	# for empty ESYSROOT (as a proxy for "are we cross-compiling?").
	if [[ -z ${ESYSROOT} ]] ; then
		llvm_fix_tool_path LLVM_CONFIG
	fi

	rust_pkg_setup
	einfo "Using Rust slot ${RUST_SLOT}, ${RUST_TYPE} to build"

	# I hate doing this but upstream Rust have yet to come up with a better
	# solution for us poor packagers. Required for Split LTO units, which
	# are required for CFI.
	export RUSTC_BOOTSTRAP=1

	# bindgen settings
	# From 127, to make bindgen work, we need to provide a location for libclang.
	# We patch this in for gentoo - see chromium-*-bindgen-custom-toolchain.patch
	# rust_bindgen_root = directory with `bin/bindgen` beneath it.
	myconf_gn+=" rust_bindgen_root=\"${EPREFIX}/usr/\""

	myconf_gn+=" bindgen_libclang_path=\"$(get_llvm_prefix)/$(get_libdir)\""
	# We don't need to set 'clang_base_bath' for anything in our build
	# and it defaults to the google toolchain location. Instead provide a location
	# to where system clang lives sot that bindgen can find system headers (e.g. stddef.h)
	myconf_gn+=" clang_base_path=\"${EPREFIX}/usr/lib/clang/${LLVM_SLOT}/\""

	myconf_gn+=" rust_sysroot_absolute=\"$(get_rust_prefix)\""
	myconf_gn+=" rustc_version=\"${RUST_SLOT}\""

else
einfo "Using the bundled toolchain"
fi #############################################################################

	# Debug symbols level 2 is still on when official is on even though
	# is_debug=false.
	#
	# See https://github.com/chromium/chromium/blob/131.0.6778.69/build/config/compiler/compiler.gni#L276
	#
	# GN needs explicit config for Debug/Release as opposed to inferring it
	# from the build directory.
	myconf_gn+=" is_debug=false"
	if ! use debug ; then
		myconf_gn+=" symbol_level=0"
		myconf_gn+=" blink_symbol_level=0"
		myconf_gn+=" v8_symbol_level=0"
	fi

	# Disable profiling/tracing these should not be enabled in production.
	myconf_gn+=" v8_use_perfetto=false"
	myconf_gn+=" rtc_use_perfetto=false"

	# Enable DCHECK with USE=debug only, increases chrome binary size by 30%, bug #811138.
	# DCHECK is fatal by default, make it configurable at runtime, #bug 807881.
	myconf_gn+=" dcheck_always_on=$(usex debug true false)"
	myconf_gn+=" dcheck_is_configurable=$(usex debug true false)"

	# Component build isn't generally intended for use by end users. It's mostly useful
	# for development and debugging.
	myconf_gn+=" is_component_build=false"

	# Disable nacl, we can't build without pnacl (http://crbug.com/269560).
	myconf_gn+=" enable_nacl=false"

	# Use system-provided libraries.
	# TODO: freetype -- remove sources
	# (https://bugs.chromium.org/p/pdfium/issues/detail?id=733).
	# TODO: use_system_hunspell (upstream changes needed).
	# TODO: use_system_protobuf (bug #525560).
	# TODO: use_system_sqlite (http://crbug.com/22208).

	# libevent: https://bugs.gentoo.org/593458
	# [B] all of gn_system_libraries set
	# List obtained from /var/tmp/portage/www-client/chromium-131.0.6778.69/work/chromium-131.0.6778.69/build/linux/unbundle/
	local gn_system_libraries=(
		$(use system-dav1d && echo "
			dav1d
		")
		$(use system-ffmpeg && echo "
			ffmpeg
		")
		$(use system-flac && echo "
			flac
		")
		$(use system-freetype && echo "
			freetype
		")
		$(use system-fontconfig && echo "
			fontconfig
		")
	# harfbuzz_from_pkgconfig target is needed.
		$(use system-harfbuzz && echo "
			harfbuzz-ng
		")
		$(use system-icu && echo "
			icu
		")
		$(use system-libaom && echo "
			libaom
		")
		$(use system-libdrm && echo "
			libdrm
		")
		$(use system-libjpeg-turbo && echo "
			libjpeg
		")
		$(use system-libpng && echo "
			libpng
		")
		$(use system-libwebp && echo "
			libwebp
		")
		$(use system-libxml && echo "
			libxml
		")
		$(use system-libxslt && echo "
			libxslt
		")
		$(use system-openh264 && echo "
			openh264
		")
		$(use system-opus && echo "
			opus
		")
		$(use system-re2 && echo "
			re2
		")

	#
	# ld.lld: error: undefined symbol: Cr_z_adler32
	#
		$(use system-zlib && echo "
			zlib
		")

		$(use system-zstd && echo "
			zstd
		")

	)
	# [C]
	if \
		   use bundled-libcxx \
		|| use cfi \
		|| use official \
	; then
	# Unbundling breaks cfi-icall and cfi-cast.
	# Unbundling weakens the security because it removes noexecstack,
	# full RELRO, SSP.
einfo
einfo "Forcing use of internal libs to maintain upstream security expectations"
einfo "and requirements."
einfo
	else
		if ! is_generating_credits ; then
ewarn
ewarn "Unbundling libs and disabling hardening (CFI, SSP, noexecstack,"
ewarn "Full RELRO)."
ewarn
			"build/linux/unbundle/replace_gn_files.py" \
				--system-libraries \
				"${gn_system_libraries[@]}" \
				|| die
		fi
	fi

	if is_generating_credits ; then
		myconf_gn+=" generate_about_credits=true"
	fi

	# TODO 131: The above call clobbers `enable_freetype = true` in the freetype gni file
	# drop the last line, then append the freetype line and a new curly brace to end the block
	local freetype_gni="build/config/freetype/freetype.gni"
	sed -i -e '$d' "${freetype_gni}" || die
	echo "  enable_freetype = true" >> "${freetype_gni}" || die
	echo "}" >> "${freetype_gni}" || die

	# See dependency logic in third_party/BUILD.gn
	myconf_gn+=" use_system_harfbuzz=$(usex system-harfbuzz true false)"

	# Optional dependencies.
	myconf_gn+=" enable_chrome_notifications=true" # Depends on enable_message_center?
	myconf_gn+=" enable_hangout_services_extension=$(usex hangouts true false)"
	myconf_gn+=" enable_hidpi=$(usex hidpi true false)"
	myconf_gn+=" enable_mdns=$(usex mdns true false)"
	myconf_gn+=" enable_message_center=true" # Required for linux, but not Fucshia and Android
	myconf_gn+=" enable_ml_internal=false"	# components/optimization_guide/internal is empty.  It is default disabled for unbranded.
	myconf_gn+=" enable_plugins=$(usex plugins true false)"
	myconf_gn+=" enable_ppapi=false"
	myconf_gn+=" enable_reporting=$(usex reporting-api true false)"
	myconf_gn+=" enable_service_discovery=true" # Required by chrome/browser/extensions/api/BUILD.gn.  mdns may be a dependency.
	myconf_gn+=" enable_speech_service=false" # It is enabled but missing backend either local service or remote service.
	myconf_gn+=" enable_widevine=$(usex widevine true false)"
	myconf_gn+=" enable_openxr=false"	# https://github.com/chromium/chromium/tree/131.0.6778.69/device/vr#platform-support
	myconf_gn+=" enable_vr=false"		# https://github.com/chromium/chromium/blob/131.0.6778.69/device/vr/buildflags/buildflags.gni#L32
	myconf_gn+=" enable_websockets=true"	# requires devtools/devtools_http_handler.cc which is unconditionally added.
	myconf_gn+=" use_minikin_hyphenation=$(usex css-hyphen true false)"
	myconf_gn+=" use_mpris=$(usex mpris true false)"
	myconf_gn+=" use_partition_alloc=$(usex partitionalloc true false)" # See issue 40277359
	if use official ; then
		: # Automagic
	else
		_jit_level_0() {
			# ~20%/~50% performance similar to light swap, but a feeling of less progress (20-25%)
			myconf_gn+=" v8_enable_drumbrake=false"
			myconf_gn+=" v8_enable_gdbjit=false"
			myconf_gn+=" v8_enable_lite_mode=true"
			myconf_gn+=" v8_enable_maglev=false"
			myconf_gn+=" v8_enable_sparkplug=false"
			myconf_gn+=" v8_enable_turbofan=false"
			myconf_gn+=" v8_enable_webassembly=false"
			myconf_gn+=" v8_jitless=true"
		}

		_jit_level_1() {
			# 28%/71% performance similar to light swap, but a feeling of more progress (33%)
			myconf_gn+=" v8_enable_drumbrake=$(usex drumbrake true false)"
			myconf_gn+=" v8_enable_gdbjit=$(usex debug true false)"
			myconf_gn+=" v8_enable_lite_mode=false"
			myconf_gn+=" v8_enable_maglev=false" # Requires turbofan
			myconf_gn+=" v8_enable_sparkplug=true"
			myconf_gn+=" v8_enable_turbofan=false"
			myconf_gn+=" v8_enable_webassembly=false"
			myconf_gn+=" v8_jitless=false"
		}

		_jit_level_2() {
			# > 75% performance
			myconf_gn+=" v8_enable_drumbrake=$(usex drumbrake true false)"
			myconf_gn+=" v8_enable_gdbjit=$(usex debug true false)"
			myconf_gn+=" v8_enable_lite_mode=false"
			myconf_gn+=" v8_enable_maglev=false"
			myconf_gn+=" v8_enable_sparkplug=false"
			myconf_gn+=" v8_enable_turbofan=true"
			myconf_gn+=" v8_enable_webassembly=$(usex webassembly true false)"
			myconf_gn+=" v8_jitless=false"
		}

		_jit_level_5() {
			# > 90% performance
			myconf_gn+=" v8_enable_drumbrake=$(usex drumbrake true false)"
			myconf_gn+=" v8_enable_gdbjit=$(usex debug true false)"
			myconf_gn+=" v8_enable_lite_mode=false"
			myconf_gn+=" v8_enable_maglev=false"
			myconf_gn+=" v8_enable_sparkplug=true"
			myconf_gn+=" v8_enable_turbofan=true"
			myconf_gn+=" v8_enable_webassembly=$(usex webassembly true false)"
			myconf_gn+=" v8_jitless=false"
		}

		_jit_level_6() {
			# 100% performance
			myconf_gn+=" v8_enable_drumbrake=$(usex drumbrake true false)"
			myconf_gn+=" v8_enable_gdbjit=$(usex debug true false)"
			myconf_gn+=" v8_enable_lite_mode=false"
			myconf_gn+=" v8_enable_maglev=true" # %5 runtime benefit
			myconf_gn+=" v8_enable_sparkplug=true" # 5% benefit
			myconf_gn+=" v8_enable_turbofan=true" # Subset of -O1, -O2, -O3; 100% performance
			myconf_gn+=" v8_enable_webassembly=$(usex webassembly true false)" # Requires it turbofan
			myconf_gn+=" v8_jitless=false"
		}

		local olast=$(get_olast)
		if [[ "${olast}" =~ "-Ofast" ]] ; then
			jit_level=7
		elif [[ "${olast}" =~ "-O3" ]] ; then
			jit_level=6
		elif [[ "${olast}" =~ "-O2" ]] ; then
			jit_level=5
		elif [[ "${olast}" =~ "-Os" ]] ; then
			jit_level=4
		elif [[ "${olast}" =~ "-Oz" ]] ; then
			jit_level=3
		elif [[ "${olast}" =~ "-O1" ]] ; then
			jit_level=2
		elif [[ "${olast}" =~ "-O0" ]] && use jit ; then
			jit_level=1
		elif [[ "${olast}" =~ "-O0" ]] ; then
			jit_level=0
		fi

		if use webassembly && (( ${jit_level} < 2 )) ; then
einfo "Changing jit_level=${jit_level} to jit_level=2 for WebAssembly."
			jit_level=2
		fi

		if [[ -n "${JIT_LEVEL_OVERRIDE}" ]] ; then
			jit_level=${JIT_LEVEL_OVERRIDE}
		fi

		# Place hardware limits here
		# Disable the more powerful JIT for older machines to speed up build time.
		use jit || jit_level=0

		local jit_level_desc
		if (( ${jit_level} == 7 )) ; then
			jit_level_desc="fast" # 100%
		elif (( ${jit_level} == 6 )) ; then
			jit_level_desc="3" # 95%
		elif (( ${jit_level} == 5 )) ; then
			jit_level_desc="2" # 90%
		elif (( ${jit_level} == 4 )) ; then
			jit_level_desc="s" # 75%
		elif (( ${jit_level} == 3 )) ; then
			jit_level_desc="z"
		elif (( ${jit_level} == 2 )) ; then
			jit_level_desc="1" # 60 %
		elif (( ${jit_level} == 1 )) ; then
			jit_level_desc="0"
		elif (( ${jit_level} == 0 )) ; then
			jit_level_desc="0" # 5%
		fi

		if (( ${jit_level} >= 6 )) ; then
einfo "JIT is similar to -O${jit_level_desc}."
			_jit_level_6
		elif (( ${jit_level} >= 3 )) ; then
einfo "JIT is similar to -O${jit_level_desc}."
			_jit_level_5
		elif (( ${jit_level} >= 2 )) ; then
einfo "JIT is similar to -O${jit_level_desc}."
			_jit_level_2
		elif (( ${jit_level} >= 1 )) ; then
einfo "JIT is similar to -O${jit_level_desc} best case."
			_jit_level_1
		else
einfo "JIT off is similar to -O${jit_level_desc} worst case."
			_jit_level_0
		fi
	fi
	myconf_gn+=" v8_enable_vtunejit=false"
	if use official ; then
		: # Use automagic
	elif use kernel_linux && linux_chkconfig_present "TRANSPARENT_HUGEPAGE" ; then
		myconf_gn+=" v8_enable_hugepage=true"
	else
		myconf_gn+=" v8_enable_hugepage=false"
	fi

	if use official ; then
		: # Use automagic
	else
		# The V8 Sandbox needs pointer compression.
		if [[ "${ARCH}" =~ ("amd64"|"arm64") ]] ; then
			myconf_gn+=" v8_enable_pointer_compression=$(usex pointer-compression true false)"
			if (( ${total_ram_gib} >= 8 )) ; then
				myconf_gn+=" v8_enable_pointer_compression_8gb=$(usex pointer-compression true false)"
			else
				myconf_gn+=" v8_enable_pointer_compression_8gb=false"
			fi
		else
ewarn "The new V8 Sandbox [for the JavaScript engine] (2024) will be turned off.  Consider enabling the pointer-compression USE flag to enable the sandbox."
			myconf_gn+=" v8_enable_pointer_compression=false"
			myconf_gn+=" v8_enable_pointer_compression_8gb=false"
		fi
	fi

	# Still testing when pointer compression is off
	if ! [[ "${ARCH}" =~ ("amd64"|"arm64") ]] ; then
ewarn "The new V8 Sandbox [for the JavaScript engine] (2024) will be automagic off.  Consider using 64-bit only."
	fi

	# Forced because of asserts
	myconf_gn+=" enable_screen_ai_service=true" # Required by chrome/renderer:renderer

	if use headless ; then
		myconf_gn+=" build_with_tflite_lib=false"
		myconf_gn+=" enable_extensions=false"
		myconf_gn+=" enable_pdf=false"
		myconf_gn+=" use_atk=false"
		myconf_gn+=" use_cups=false"
		myconf_gn+=" use_kerberos=false"
		myconf_gn+=" use_pulseaudio=false"
		myconf_gn+=" use_vaapi=false"
		myconf_gn+=" rtc_use_pipewire=false"
		myconf_gn+=" toolkit_views=false"
	else
		myconf_gn+=" build_with_tflite_lib=$(usex ml true false)"
		myconf_gn+=" enable_extensions=$(usex extensions true false)"
		myconf_gn+=" enable_pdf=true" # required by chrome/browser/ui/lens:browser_tests and toolkit_views=true
		myconf_gn+=" gtk_version=$(usex gtk4 4 3)"
		myconf_gn+=" use_atk=$(usex accessibility true false)"
		myconf_gn+=" use_cups=$(usex cups true false)"
		myconf_gn+=" use_kerberos=$(usex kerberos true false)"
		myconf_gn+=" use_pulseaudio=$(usex pulseaudio true false)"
		myconf_gn+=" use_vaapi=$(usex vaapi true false)"
		myconf_gn+=" rtc_use_pipewire=$(usex screencast true false)"
		myconf_gn+=" toolkit_views=true"
	fi

	if use pdf || use cups ; then
		if use headless ; then
			myconf_gn+=" enable_print_preview=false"
		else
			local print_preview="${PRINT_PREVIEW:-1}"
			if [[ "${print_preview}" == "1" ]] ; then
				myconf_gn+=" enable_print_preview=true"
			else
				myconf_gn+=" enable_print_preview=false"
			fi
		fi
		myconf_gn+=" enable_printing=true"
	else
		myconf_gn+=" enable_print_preview=false"
		myconf_gn+=" enable_printing=false"
	fi

	# Allows distributions to link pulseaudio directly (DT_NEEDED) instead of
	# using dlopen. This helps with automated detection of ABI mismatches and
	# prevents silent errors.
	if use pulseaudio; then
		myconf_gn+=" link_pulseaudio=true"
	fi

	# Non-developer builds of Chromium (for example, non-Chrome browsers, or
	# Chromium builds provided by Linux distros) should disable the testing config.
	myconf_gn+=" disable_fieldtrial_testing_config=true"

	# The sysroot is the oldest debian image that chromium supports, we don't need it.
	myconf_gn+=" use_sysroot=false"

	# This determines whether or not GN uses the bundled libcxx
	# default: true
	if use official && use cfi || use bundled-libcxx ; then
		# If you didn't do systemwide CFI Cross-DSO, it must be static.
		myconf_gn+=" use_custom_libcxx=true"
	else
		myconf_gn+=" use_custom_libcxx=false"
	fi

	# Disable pseudolocales, only used for testing
	myconf_gn+=" enable_pseudolocales=false"

	# Disable code formating of generated files
	myconf_gn+=" blink_enable_generated_code_formatting=false"

	# See https://github.com/chromium/chromium/blob/131.0.6778.69/media/media_options.gni#L19

	if use bindist ; then
	# The proprietary_codecs USE flag just forces Chromium to say that it
	# can use h264/aac, the work is still done by ffmpeg.  If this is set to
	# no, Chromium won't be able to load the codec even if the library can
	# handle it.
		myconf_gn+=" proprietary_codecs=true"
		myconf_gn+=" ffmpeg_branding=\"Chrome\""
	# Build ffmpeg as an external component (libffmpeg.so) that we can
	# remove / substitute
		myconf_gn+=" is_component_ffmpeg=true"
	else
		ffmpeg_branding="$(usex proprietary-codecs Chrome Chromium)"
		myconf_gn+=" proprietary_codecs=$(usex proprietary-codecs true false)"
		myconf_gn+=" ffmpeg_branding=\"${ffmpeg_branding}\""
	fi

	myconf_gn+=" enable_av1_decoder=$(usex dav1d true false)"
	myconf_gn+=" enable_dav1d_decoder=$(usex dav1d true false)"
	myconf_gn+=" enable_hevc_parser_and_hw_decoder=$(usex proprietary-codecs $(usex vaapi-hevc true false) false)"
	myconf_gn+=" enable_libaom=$(usex libaom $(usex encode true false) false)"
	myconf_gn+=" enable_platform_hevc=$(usex proprietary-codecs $(usex vaapi-hevc true false) false)"
	myconf_gn+=" media_use_libvpx=$(usex vpx true false)"
	myconf_gn+=" media_use_openh264=$(usex proprietary-codecs $(usex openh264 true false) false)"
	myconf_gn+=" rtc_include_opus=$(usex opus true false)"
	myconf_gn+=" rtc_use_h264=$(usex proprietary-codecs true false)"
	if ! use system-ffmpeg ; then
	# The internal/vendored ffmpeg enables non-free codecs.
		local _media_use_ffmpeg="true"
		if \
			   use proprietary-codecs-disable-nc-developer \
			|| use proprietary-codecs-disable ; then
			_media_use_ffmpeg="false"
		fi
		myconf_gn+=" media_use_ffmpeg=${_media_use_ffmpeg}"
	fi

	#
	# Set up Google API keys, see http://www.chromium.org/developers/how-tos/api-keys .
	# Note: these are for Gentoo use ONLY. For your own distribution,
	# please get your own set of keys. Feel free to contact chromium@gentoo.org
	# for more info. The OAuth2 credentials, however, have been left out.
	# Those OAuth2 credentials have been broken for quite some time anyway.
	# Instead we apply a patch to use the --oauth2-client-id= and
	# --oauth2-client-secret= switches for setting GOOGLE_DEFAULT_CLIENT_ID and
	# GOOGLE_DEFAULT_CLIENT_SECRET at runtime. This allows signing into
	# Chromium without baked-in values.
	#
	local google_api_key="AIzaSyDEAOvatFo0eTgsV_ZlEzx0ObmepsMzfAc"
	myconf_gn+=" google_api_key=\"${google_api_key}\""
	local myarch="$(tc-arch)"

	# Avoid CFLAGS problems, bug #352457, bug #390147.
	if ! use custom-cflags ; then
		strip-flags

	# Debug info section overflows without component build
	# Prevent linker from running out of address space, bug #471810.
		filter-flags '-g*'

	# Prevent libvpx/xnnpack build failures. Bug 530248, 544702,
	# 546984, 853646.
		if [[ "${myarch}" == "amd64" || "${myarch}" == "x86" ]] ; then
			filter-flags \
				'-mno-avx*' \
				'-mno-fma*' \
				'-mno-mmx*' \
				'-mno-sse*' \
				'-mno-ssse*' \
				'-mno-xop'
		fi
	fi

	if is-flagq "-Ofast" ; then
	# Precaution
		append_all $(test-flags -fno-allow-store-data-races)
	fi

	local oshit_opt_level_dav1d
	local oshit_opt_level_libaom
	local oshit_opt_level_libvpx
	local oshit_opt_level_openh264
	local oshit_opt_level_rnnoise
	local oshit_opt_level_ruy
	local oshit_opt_level_tflite
	local oshit_opt_level_v8
	local oshit_opt_level_xnnpack
	if use official ; then
		:
	else
		oshit_opt_level_dav1d=${OSHIT_OPT_LEVEL_DAV1D:-"2"}
		oshit_opt_level_libaom=${OSHIT_OPT_LEVEL_LIBAOM:-"2"}
		oshit_opt_level_libvpx=${OSHIT_OPT_LEVEL_LIBVPX:-"2"}
		oshit_opt_level_openh264=${OSHIT_OPT_LEVEL_OPENH264:-"2"}
		oshit_opt_level_rnnoise=${OSHIT_OPT_LEVEL_RNNOISE:-"2"}
		oshit_opt_level_ruy=${OSHIT_OPT_LEVEL_RUY:-"2"}
		oshit_opt_level_tflite=${OSHIT_OPT_LEVEL_TFLITE:-"2"}
		oshit_opt_level_v8=${OSHIT_OPT_LEVEL_V8:-"2"}
		oshit_opt_level_xnnpack=${OSHIT_OPT_LEVEL_XNNPACK:-"2"}
	fi
# For more subprojects to optimize, see also
# IMO, some are premature-optimized.
# grep -E -e "build/config/compiler:(optimize_max|optimize_speed)" $(find . -name "*.gn*")

# gemmlowp ML (not used)
# xnnpack ML (used in amd64)
# ruy ML (used in arm64)
# sentencepiece ML
# rnnoise ML
# eigen3 3D
# libgav1 av1 parsing for webrtc

	# Safety/sanity checks

	if [[ "${oshit_opt_level_dav1d}" =~ ("2"|"3"|"fast") ]] ; then
		:
	else
		oshit_opt_level_dav1d="2"
	fi

	if [[ "${oshit_opt_level_libaom}" =~ ("1"|"2"|"3"|"fast") ]] ; then
	# If you don't care, then just use -O1.
	# If you have hardware av1 encoding, use -O1.
	# If you have a lot of CPU cores, use Ofast.
		:
	else
		oshit_opt_level_libaom="2" # I don't use, and it is too slow for realtime encoding.
	fi

	if [[ "${oshit_opt_level_libvpx}" =~ ("2"|"3"|"fast") ]] ; then
		:
	else
		oshit_opt_level_libvpx="2"
	fi

	if [[ "${oshit_opt_level_openh264}" =~ ("1"|"2"|"3"|"fast") ]] ; then
	# If you have hardware acceleration or don't use it, then just use -O1.
		:
	else
		oshit_opt_level_openh264="2"
	fi

	if [[ "${oshit_opt_level_rnnoise}" =~ ("1"|"2"|"3"|"fast") ]] ; then
	# If you don't care about AI/ML or noise reduction, then just use -O1.
		:
	else
		oshit_opt_level_rnnoise="2"
	fi

	if [[ "${oshit_opt_level_ruy}" =~ ("1"|"2"|"3"|"fast") ]] ; then
	# If you don't care about AI/ML, then just use -O1.
		:
	else
		oshit_opt_level_ruy="2"
	fi

	if [[ "${oshit_opt_level_tflite}" =~ ("1"|"2"|"3") ]] ; then
	# If you don't care, then just use -O1.
		:
	else
		oshit_opt_level_tflite="2"
	fi

	if [[ "${oshit_opt_level_v8}" =~ ("2"|"3") ]] ; then
		:
	else
		oshit_opt_level_v8="2"
	fi

	if [[ "${oshit_opt_level_xnnpack}" =~ ("1"|"2"|"3") ]] ; then
	# If you don't care, then just use -O1.
		:
	else
		oshit_opt_level_xnnpack="2"
	fi

	if use official ; then
		:
	elif (( ${OSHIT_OPTIMIZED} == 1 )) ; then
einfo "OSHIT_OPT_LEVEL_DAV1D=${oshit_opt_level_dav1d}"
einfo "OSHIT_OPT_LEVEL_LIBAOM=${oshit_opt_level_libaom}"
einfo "OSHIT_OPT_LEVEL_LIBVPX=${oshit_opt_level_libvpx}"
einfo "OSHIT_OPT_LEVEL_OPENH264=${oshit_opt_level_openh264}"
einfo "OSHIT_OPT_LEVEL_RNNOISE=${oshit_opt_level_rnnoise}"
einfo "OSHIT_OPT_LEVEL_RUY=${oshit_opt_level_ruy}"
einfo "OSHIT_OPT_LEVEL_TFLITE=${oshit_opt_level_tflite}"
einfo "OSHIT_OPT_LEVEL_V8=${oshit_opt_level_v8}"
einfo "OSHIT_OPT_LEVEL_XNNPACK=${oshit_opt_level_xnnpack}"
		myconf_gn+=" dav1d_custom_optimization_level=${oshit_opt_level_dav1d}"
		myconf_gn+=" libaom_custom_optimization_level=${oshit_opt_level_libaom}"
		myconf_gn+=" libvpx_custom_optimization_level=${oshit_opt_level_libvpx}"
		myconf_gn+=" openh264_custom_optimization_level=${oshit_opt_level_openh264}"
		myconf_gn+=" rnnoise_custom_optimization_level=${oshit_opt_level_rnnoise}"
		myconf_gn+=" ruy_custom_optimization_level=${oshit_opt_level_ruy}"
		myconf_gn+=" tflite_custom_optimization_level=${oshit_opt_level_tflite}"
		myconf_gn+=" v8_custom_optimization_level=${oshit_opt_level_v8}"
		myconf_gn+=" xnnpack_custom_optimization_level=${oshit_opt_level_xnnpack}"
	fi

	#
	# Oflag and or compiler flag requirements:
	#
	# 1. Smooth playback (>=25 FPS) for vendored codecs like dav1d.
	# 2. Fast build time to prevent systemwide vulnerability backlog.
	# 3. Critical vulnerabilities should be fixed in one day, which implies
	#    that the ebuild has to be completely merged within a day.
	#

	replace-flags "-O0" "-O2"
	replace-flags "-O1" "-O2"
	replace-flags "-Os" "-O2"
	replace-flags "-Oz" "-O2"
	replace-flags "-Ofast" "-O3" # -Ofast is broken.  TODO: fix crashes by using O3 in some *.gn* files
	replace-flags "-O4" "-O3" # -O4 is the same as -O3

	if ! use system-toolchain ; then
	# The vendored clang/rust is likely built for portability not performance
	# that is why it is very slow.
		replace-flags "-O*" "-O2"
	fi
	if (( ${nprocs} <= 4 )) ; then
		replace-flags "-O*" "-O2"
	fi

	# Prevent crash for now
	filter-flags "-ffast-math"

	if (( ${OSHIT_OPTIMIZED} == 1 )) ; then
		replace-flags "-O*" "-O1"
	fi

	#
	# Turn off all the static checker stuff, linter stuff, style formatting
	# stuff that is supposed to be only enabled in upstream and dev
	# branches.
	#
	# These are assumed to only do fatal checks but do not actually
	# fix/modify anything.
	#
	# See
	# build/config/clang/BUILD.gn
	# build/config/clang/clang.gni
	#
	myconf_gn+=" clang_use_chrome_plugins=false"
	myconf_gn+=" clang_use_raw_ptr_plugin=false"
	myconf_gn+=" enable_check_raw_ptr_fields=false"
	myconf_gn+=" enable_check_raw_ref_fields=false"

	if use official ; then
		:
	elif is-flagq "-Ofast" ; then
# DO NOT USE
		myconf_gn+=" custom_optimization_level=fast"
	elif is-flagq "-O4" ; then
		myconf_gn+=" custom_optimization_level=4"
	elif is-flagq "-O3" ; then
		myconf_gn+=" custom_optimization_level=3"
	elif is-flagq "-O2" ; then
		myconf_gn+=" custom_optimization_level=2"
	elif is-flagq "-O1" ; then
		myconf_gn+=" custom_optimization_level=1"
	elif is-flagq "-O0" ; then
# DO NOT USE
		myconf_gn+=" custom_optimization_level=0"
	fi

	local ffmpeg_target_arch
	local target_cpu
	if [[ "${myarch}" == "amd64" ]] ; then
		target_cpu="x64"
		ffmpeg_target_arch="x64"
	elif [[ "${myarch}" == "x86" ]] ; then
		target_cpu="x86"
		ffmpeg_target_arch="ia32"
	# This is normally defined by compiler_cpu_abi in
	# build/config/compiler/BUILD.gn, but we patch that part out.
		append-flags -msse2 -mfpmath=sse -mmmx
	elif [[ "${myarch}" == "arm64" ]] ; then
		target_cpu="arm64"
		ffmpeg_target_arch="arm64"
	elif [[ "${myarch}" == "arm" ]] ; then
		target_cpu="arm"
		ffmpeg_target_arch=$(usex cpu_flags_arm_neon arm-neon arm)
	elif [[ "${myarch}" == "ppc64" ]] ; then
		target_cpu="ppc64"
		ffmpeg_target_arch="ppc64"
	else
		die "Failed to determine target arch, got '${myarch}'."
	fi

	myconf_gn+=" current_cpu=\"${target_cpu}\""
	myconf_gn+=" host_cpu=\"${target_cpu}\""
	myconf_gn+=" target_cpu=\"${target_cpu}\""
	myconf_gn+=" v8_current_cpu=\"${target_cpu}\""

	if ! use cpu_flags_arm_neon ; then
		myconf_gn+=" use_neon=false"
	fi

	if ! use cpu_flags_x86_sse2 ; then
		myconf_gn+=" use_sse2=false"
	fi

	if ! use cpu_flags_x86_sse4_2 ; then
		myconf_gn+=" use_sse4_2=false"
	fi

	if ! use cpu_flags_x86_ssse3 ; then
		myconf_gn+=" use_ssse3=false"
	fi

	if use cpu_flags_x86_avx2 ; then
		myconf_gn+=" rtc_enable_avx2=true"
	else
		myconf_gn+=" rtc_enable_avx2=false"
	fi

	myconf_gn+=" treat_warnings_as_errors=false"

	# Disable fatal linker warnings, bug 506268.
	myconf_gn+=" fatal_linker_warnings=false"

	# Disable external code space for V8 for ppc64. It is disabled for ppc64
	# by default, but cross-compiling on amd64 enables it again.
	if tc-is-cross-compiler ; then
		if ! use amd64 && ! use arm64 ; then
			myconf_gn+=" v8_enable_external_code_space=false"
		fi
	fi

	# Only enabled for clang, but gcc has endian macros too
	myconf_gn+=" v8_use_libm_trig_functions=true"

	# Bug 491582.
	export TMPDIR="${WORKDIR}/temp"
	mkdir -p -m 755 "${TMPDIR}" || die

	# https://bugs.gentoo.org/654216
	addpredict "/dev/dri/" #nowarn

	if use system-ffmpeg ; then
		local build_ffmpeg_args=""
		if use pic && [[ "${ffmpeg_target_arch}" == "ia32" ]] ; then
			build_ffmpeg_args+=" --disable-asm"
		fi

	# Re-configure bundled ffmpeg. See bug #491378 for example reasons.
einfo "Configuring bundled ffmpeg..."
		pushd "third_party/ffmpeg" >/dev/null 2>&1 || die
			"chromium/scripts/build_ffmpeg.py" \
				linux ${ffmpeg_target_arch} \
				--branding ${ffmpeg_branding} \
				-- \
				${build_ffmpeg_args} \
				|| die
			"chromium/scripts/copy_config.sh" || die
			"chromium/scripts/generate_gn.py" || die
		popd >/dev/null 2>&1 || die
	fi

	# We don't use the same clang version as upstream, and with -Werror
	# we need to make sure that we don't get superfluous warnings.
	append-flags -Wno-unknown-warning-option
	if tc-is-cross-compiler; then
		export BUILD_CXXFLAGS+=" -Wno-unknown-warning-option"
		export BUILD_CFLAGS+=" -Wno-unknown-warning-option"
	fi

	# Explicitly disable ICU data file support for system-icu/headless builds.
	if use system-icu || use headless ; then
		myconf_gn+=" icu_use_data_file=false"
	fi

	# Don't need nocompile checks and GN crashes with our config
	myconf_gn+=" enable_nocompile_tests=false"

	# 131 began laying the groundwork for replacing freetype with
	# "Rust-based Fontations set of libraries plus Skia path rendering"
	# We now need to opt-in
	myconf_gn+=" enable_freetype=true"

	# Enable ozone wayland and/or headless support
	myconf_gn+=" use_ozone=true"
	myconf_gn+=" ozone_auto_platforms=false"
	myconf_gn+=" ozone_platform_headless=true"
	if use headless ; then
		myconf_gn+=" ozone_platform=\"headless\""
		myconf_gn+=" use_xkbcommon=false"
		myconf_gn+=" use_gtk=false"
		myconf_gn+=" use_qt5=false"
		myconf_gn+=" use_qt6=false"
		myconf_gn+=" use_glib=false"
		myconf_gn+=" use_gio=false"
		myconf_gn+=" use_pangocairo=false"
		myconf_gn+=" use_alsa=false"
		myconf_gn+=" use_libpci=false"
		myconf_gn+=" use_udev=false"
		myconf_gn+=" enable_remoting=false"
	else
		myconf_gn+=" use_system_libdrm=true"
		myconf_gn+=" use_system_minigbm=true"
		myconf_gn+=" use_xkbcommon=true"
		if use qt5 || use qt6 ; then
			local cbuild_libdir=$(get_libdir)
			if tc-is-cross-compiler; then
	# Hack to workaround get_libdir not being able to handle CBUILD, bug
	# #794181
				local cbuild_libdir=$($(tc-getBUILD_PKG_CONFIG) \
					--keep-system-libs \
					--libs-only-L \
					libxslt)
				cbuild_libdir=${cbuild_libdir/% }
			fi
			if use qt6 ; then
				myconf_gn+=" moc_qt6_path=\"${EPREFIX}/usr/${cbuild_libdir}/qt6/libexec\""
			elif use qt5 ; then
				if tc-is-cross-compiler; then
					myconf_gn+=" moc_qt5_path=\"${EPREFIX}/${cbuild_libdir}/qt5/bin\""
				else
					myconf_gn+=" moc_qt5_path=\"$(qt5_get_bindir)\""
				fi
			fi
		fi
		myconf_gn+=" use_qt5=$(usex qt5 true false)"
		myconf_gn+=" use_qt6=$(usex qt6 true false)"
		myconf_gn+=" ozone_platform_x11=$(usex X true false)"
		myconf_gn+=" ozone_platform_wayland=$(usex wayland true false)"
		myconf_gn+=" ozone_platform=$(usex wayland \"wayland\" \"x11\")"
		use wayland && myconf_gn+=" use_system_libffi=true"
	fi

	#
	#
	#
	#

	local use_thinlto=0

	if is-flagq '-flto' || is-flagq '-flto=*' ; then
		USE_LTO=1
	fi

	fatal_message_lto_banned() {
# Critical vulnerabilities must be fixed within 24 hrs, which implies the ebuild
# must be completely installed in that time.
		local flag="${1}"
# A LTO required flag
eerror
eerror "The ${flag} USE flag is not supported for older machines."
eerror
eerror "Workarounds:"
eerror
eerror "1.  Replace this package with www-client/google-chrome"
eerror "2.  Build this ebuild on a faster machine and install it with a local -bin ebuild you created"
eerror
eerror "https://wiki.gentoo.org/wiki/Binary_package_guide#Creating_binary_packages"
eerror
		die
	}

	if (( ${actual_gib_per_core%.*} <= 3 || ${nprocs} <= 4 )) ; then
	#
	# This section assumes 4 core and 4 GiB total with 8 GiB swap as
	# disqualified for LTO treatment.  LTO could increase build times by
	# 5 times.
	#
	# One of the goals is to prevent a systemwide vulnerability backlog or
	# a ebuild update backlog that lasts 6 months.
	#
ewarn "Disabling LTO for older machines."
		USE_LTO=0
		filter-flags '-flto*'
		use cfi         && fatal_message_lto_banned "cfi"
		use official    && fatal_message_lto_banned "official"
	fi

	if ! use mold && is-flagq '-fuse-ld=mold' && has_version "sys-devel/mold" ; then
eerror "To use mold, enable the mold USE flag."
		die
	fi

	if use mold ; then
	# Handled by build scripts
		filter-flags '-fuse-ld=*'
	fi

	myconf_gn+=" is_official_build=$(usex official true false)"

	if [[ -z "${LTO_TYPE}" ]] ; then
		LTO_TYPE=$(check-linker_get_lto_type)
	fi
	if \
		(( ${USE_LTO} == 1 )) \
			&&
		( \
			( \
				tc-is-clang && [[ "${LTO_TYPE}" == "thinlto" ]] \
			) \
				|| \
			( \
				use cfi \
			) \
				|| \
			( \
				use official && [[ "${PGO_PHASE}" != "PGI" ]] \
			) \
		) \
	; then
einfo "Using ThinLTO"
		myconf_gn+=" use_thin_lto=true "
		filter-flags '-flto*'
		filter-flags '-fuse-ld=*'
		filter-flags '-Wl,--lto-O*'
		if [[ "${THINLTO_OPT:-1}" == "1" ]] ; then
			myconf_gn+=" thin_lto_enable_optimizations=true"
		fi
		use_thinlto=1
	else
	# gcc will never use ThinLTO.
	# gcc doesn't like -fsplit-lto-unit and -fwhole-program-vtables
	# We want the faster LLD but without LTO.
		myconf_gn+=" thin_lto_enable_optimizations=false"
		myconf_gn+=" use_thin_lto=false"
	fi

	# See https://github.com/rui314/mold/issues/336
	if use mold && (( ${use_thinlto} == 0 && ${USE_LTO} == 1 )) ; then
		if tc-is-clang ; then
einfo "Using Clang MoldLTO"
			myconf_gn+=" use_mold=true"
		else
ewarn "Forcing use of GCC Mold without LTO.  GCC MoldLTO is not supported."
ewarn "To use LTO, use either Clang MoldLTO, Clang ThinLTO, GCC BFDLTO."
			filter-flags '-flto*'
		fi
	elif use mold && (( ${use_thinlto} == 0 && ${USE_LTO} == 0 )) ; then
einfo "Using Mold without LTO"
		myconf_gn+=" use_mold=true"
	fi

	if use official ; then
	# Allow building against system libraries in official builds
		sed -i \
			's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' \
			"tools/generate_shim_headers/generate_shim_headers.py" \
			|| die
	fi

	# Skipping typecheck is only supported on amd64, bug #876157
	if ! use amd64; then
		myconf_gn+=" devtools_skip_typecheck=false"
	fi

	# See https://github.com/chromium/chromium/blob/131.0.6778.69/build/config/sanitizers/BUILD.gn#L196
	# See https://github.com/chromium/chromium/blob/131.0.6778.69/tools/mb/mb_config.pyl#L2950
	local is_cfi_custom=0
	if use official ; then
	# Forced because it is the final official settings.
		if [[ "${ABI}" == "amd64" ]] ; then
			myconf_gn+=" is_cfi=true"
			myconf_gn+=" use_cfi_icall=true"
			myconf_gn+=" use_cfi_cast=false"
		else
			myconf_gn+=" is_cfi=false"
			myconf_gn+=" use_cfi_cast=false"
			myconf_gn+=" use_cfi_icall=false"
		fi
	elif use cfi ; then
		local f
		local F=(
			"cfi-derived-cast"
			"cfi-icall"
			"cfi-underived-cast"
			"cfi-vcall"
		)
		for f in ${F[@]} ; do
			if has_sanitizer_option "${f}" ; then
				is_cfi_custom=1
			fi
		done
		(( ${CFI_VCALL} == 1 )) && is_cfi_custom=1
		(( ${CFI_CAST} == 1 )) && is_cfi_custom=1
		(( ${CFI_ICALL} == 1 )) && is_cfi_custom=1

		if (( ${is_cfi_custom} == 1 )) ; then
	# Change by CFLAGS
			if \
				   has_sanitizer_option "cfi-vcall" \
				|| (( ${CFI_VCALL} == 1 )) \
			; then
				myconf_gn+=" is_cfi=true"
				CFI_VCALL=1
			fi

			if \
				   has_sanitizer_option "cfi-derived-cast" \
				|| has_sanitizer_option "cfi-unrelated-cast" \
				|| (( ${CFI_CAST} == 1 )) \
			; then
				myconf_gn+=" use_cfi_cast=true"
				CFI_CAST=1
			else
				myconf_gn+=" use_cfi_cast=false"
			fi

			if \
				   has_sanitizer_option "cfi-icall" \
				|| (( ${CFI_ICALL} == 1 )) \
			; then
				myconf_gn+=" use_cfi_icall=true"
				CFI_ICALL=1
			else
				myconf_gn+=" use_cfi_icall=false"
			fi
		else
	# Fallback to autoset in non-official
			myconf_gn+=" is_cfi=true"

			local cfi_cast_default="false"
			local cfi_icall_default="false"

			if [[ "${ABI}" == "amd64" ]] ; then
				cfi_icall_default="true"
			fi

	# Allow change by environment variables
			if [[ "${USE_CFI_CAST:-${cfi_cast_default}}" == "1" ]] ; then
				myconf_gn+=" use_cfi_cast=true"
			else
				myconf_gn+=" use_cfi_cast=false"
			fi

			if [[ "${USE_CFI_ICALL:-${cfi_icall_default}}" == "1" ]] ; then
				myconf_gn+=" use_cfi_icall=true"
			else
				myconf_gn+=" use_cfi_icall=false"
			fi
		fi
	else
		myconf_gn+=" is_cfi=false"
		myconf_gn+=" use_cfi_cast=false"
		myconf_gn+=" use_cfi_icall=false"
	fi

	# Dedupe flags which are already added by build scripts
	strip-flag-value "cfi-vcall"
	strip-flag-value "cfi-icall"
	strip-flag-value "cfi-derived-cast"
	strip-flag-value "cfi-unrelated-cast"

	local expected_lto_type="thinlto"
	if [[ "${myconf_gn}" =~ "is_cfi=true" ]] ; then
		if ! [[ "${LTO_TYPE}" =~ ("${expected_lto_type}") ]] ; then
		# Build scripts can only use ThinLTO for CFI.
eerror
eerror "CFI requires ThinLTO."
eerror
eerror "Contents of ${ESYSROOT}/etc/portage/env/thinlto.conf:"
eerror
eerror "CFLAGS=\"\${CFLAGS} -flto=thin\""
eerror "CXXFLAGS=\"\${CXXFLAGS} -flto=thin\""
eerror "LDFLAGS=\"\${LDFLAGS} -fuse-ld=lld\""
eerror
eerror
eerror "You must apply one of the above linkers to the following file:"
eerror
eerror "Contents of ${ESYSROOT}/etc/portage/package.env"
eerror "www-client/chromium thinlto.conf"
eerror
eerror "Expected LTO type:  ${expected_lto_type}"
eerror "Actual LTO type:    ${LTO_TYPE}"
eerror
			die
		fi
	fi

	if use cet ; then
		myconf_gn+=" v8_enable_cet_ibt=$(usex cet true false)"
		myconf_gn+=" v8_enable_cet_shadow_stack=false" # unfinished, windows only
	fi

	if use arm64 ; then
		if use official ; then
			myconf_gn+=" arm_control_flow_integrity=standard"
		else
			if use cpu_flags_arm_pac && use cpu_flags_arm_bti ; then
	# ROP + JOP mitigation
				myconf_gn+=" arm_control_flow_integrity=standard"
			elif use cpu_flags_arm_pac ; then
	# ROP mitigation
				myconf_gn+=" arm_control_flow_integrity=pac"
			fi
		fi
	# Dedupe flags
		filter-flags '-mbranch-protection=*'
		if use cpu_flags_arm_bti || use official ; then
			filter-flags '-Wl,-z,force-bti'
		fi
	fi

	if \
		use arm64 \
			&& \
		( \
			   has_sanitizer_option "shadow-call-stack" \
			|| (( ${SHADOW_CALL_STACK} == 1 )) \
		) \
	; then
		myconf_gn+=" use_shadow_call_stack=true"
		strip-flag-value "shadow-call-stack" # Dedupe flag
		SHADOW_CALL_STACK=1
	fi

	if [[ "${CHROMIUM_EBUILD_MAINTAINER}" == "1" ]] ; then # Disable annoying check
		:
	elif use pgo ; then

		if ! tc-is-clang ; then
			die "The prebuilt PGO profile requires clang."
		fi

		local profdata_index_version=$(get_llvm_profdata_version_info)
		CURRENT_PROFDATA_VERSION=$(echo "${profdata_index_version}" \
			| cut -f 1 -d ":")
		CURRENT_PROFDATA_LLVM_VERSION=$(echo "${profdata_index_version}" \
			| cut -f 2 -d ":")
		if ! is_profdata_compatible ; then
eerror
eerror "Profdata compatibility:"
eerror
eerror "The PGO profile is not compatible with this version of LLVM."
eerror
eerror "Expected:\t$(get_pregenerated_profdata_index_version)"
eerror "Found:\t${CURRENT_PROFDATA_VERSION} for ~sys-devel/llvm-${CURRENT_PROFDATA_LLVM_VERSION}"
eerror
eerror "The solution is to rebuild using a newer/older commit or tag."
eerror
eerror "The mapping between INSTR_PROF_INDEX_VERSION and the commit or tag can be"
eerror "found in InstrProfData.inc in the LLVM repo."
eerror
			die
		else
einfo
einfo "Profdata compatibility:"
einfo
einfo "Expected:\t$(get_pregenerated_profdata_index_version)"
einfo "Found:\t${CURRENT_PROFDATA_VERSION} for ~sys-devel/llvm-${CURRENT_PROFDATA_LLVM_VERSION}"
einfo
		fi
	fi

	# See also build/config/compiler/pgo/BUILD.gn#L71 for PGO flags.
	# See also https://github.com/chromium/chromium/blob/131.0.6778.69/docs/pgo.md
	# profile-instr-use is clang which that file assumes but gcc doesn't have.
	# chrome_pgo_phase:  0=NOP, 1=PGI, 2=PGO
	if use pgo && tc-is-clang && ver_test $(clang-major-version) -ge ${PREGENERATED_PGO_PROFILE_MIN_LLVM_SLOT} ; then
	# The profile data is already shipped so use it.
	# PGO profile location: chrome/build/pgo_profiles/chrome-linux-*.profdata
		myconf_gn+=" chrome_pgo_phase=2"
	else
	# The pregenerated profiles are not GCC compatible.
		myconf_gn+=" chrome_pgo_phase=0"
	fi

	if use system-toolchain ; then
		myconf_gn+=" llvm_libdir=\"$(get_libdir)\""
	fi

	if tc-is-clang ; then
		if ver_test $(clang-major-version) -ge 16 ; then
			myconf_gn+=" clang_version=$(clang-major-version)"
		else
			myconf_gn+=" clang_version=$(clang-fullversion)"
		fi
	fi

	if \
		( \
			   use bundled-libcxx \
			|| use cfi \
			|| use official \
			|| use pgo \
		) \
			&& \
		[[ "${FEATURES}" =~ "icecream" ]] \
	; then
eerror
eerror "FEATURES=icecream can only use GCC.  It can't use USE flags that depend"
eerror "on clang."
eerror
eerror "Solutions"
eerror
eerror "1.  Replace this package with www-client/google-chrome."
eerror "2.  Disable bundled-libcxx, cfi, official, pgo USE flags."
eerror "3.  Disable icecream in FEATURES."
eerror
		die
	fi

	if [[ "${FEATURES}" =~ "icecream" ]] && has_version "sys-devel/icecream" ; then
		myconf_gn+=" use_debug_fission=false"
	fi

	# I noticed that the vendored clang doesn't use ccache.  Let us explicitly use ccache if requested.
	# See https://github.com/chromium/chromium/blob/131.0.6778.69/build/toolchain/cc_wrapper.gni#L36
	if ! use system-toolchain ; then
		if [[ "${FEATURES}" =~ "ccache" ]] && has_version "dev-util/ccache" ; then
			myconf_gn+=" cc_wrapper=\"ccache\""
			export CCACHE_BASEDIR="${TMPDIR}"
		fi

		[[ "${FEATURES}" =~ "distcc" ]] && die "FEATURES=distcc with USE=-system-toolchain is not supported by the ebuild."
		[[ "${FEATURES}" =~ "icecream" ]] && die "FEATURES=icecream with USE=-system-toolchain is not supported by the ebuild."
	fi

	if has ungoogled-chromium ${IUSE_EFFECTIVE} && use ungoogled-chromium && has cromite ${IUSE_EFFECTIVE} && use cromite ; then
einfo "Configuring Cromite + ungoogled-chromium..."
		[[ "${ABI}" == "amd64" ]] || die "Cromite only supports ARCH=${ARCH}"
		TARGET_ISDEBUG=$(usex debug "true" "false")
		myconf_gn+=" target_os =\"linux\" "$(cat "${S_CROMITE}/build/cromite.gn_args")
		myconf_gn+=" "$(cat "${S_UNGOOGLED_CHROMIUM}/flags.gn")
		set -- gn gen --args="${myconf_gn} ${EXTRA_GN}" "out/Release"
	elif has cromite ${IUSE_EFFECTIVE} && use cromite ; then
einfo "Configuring Cromite..."
		[[ "${ABI}" == "amd64" ]] || die "Cromite only supports ARCH=${ARCH}"
		TARGET_ISDEBUG=$(usex debug "true" "false")
		myconf_gn+=" target_os =\"linux\" "$(cat "${S_CROMITE}/build/cromite.gn_args")
		set -- gn gen --args="${myconf_gn} ${EXTRA_GN}" "out/Release"
	elif has ungoogled-chromium ${IUSE_EFFECTIVE} && use ungoogled-chromium ; then
einfo "Configuring ungoogled-chromium..."
		myconf_gn+=" "$(cat "${S_UNGOOGLED_CHROMIUM}/flags.gn")
		set -- gn gen --args="${myconf_gn} ${EXTRA_GN}" "out/Release"
	else
einfo "Configuring Chromium..."
		set -- gn gen --args="${myconf_gn} ${EXTRA_GN}" "out/Release"
	fi


	echo "$@"
	"$@" || die
}

_eninja() {
	local ninja_into="${1}"
	local target_id="${2}"
	local pax_path="${3}"
	local file_name=$(basename "${2}")

einfo "Building ${file_name}"
	eninja -C "${ninja_into}" "${target_id}"

	if [[ -n "${pax_path}" ]] ; then
		pax-mark m "${pax_path}"
	fi
}

_update_licenses() {
	# Upstream doesn't package PATENTS files
	if [[ \
		   "${CHROMIUM_EBUILD_MAINTAINER}" == "1" \
		&& "${GEN_ABOUT_CREDITS}" == "1" \
	]] ; then
einfo "Generating license and copyright notice file"
		eninja -C "out/Release" "about_credits"
		# It should be updated when the major.minor.build.x changes
		# because of new features.
		local license_file_name="${PN}-"$(ver_cut 1-3 "${PV}")".x.html"
		local fp=$(sha512sum \
"${s}/out/Release/gen/components/resources/about_credits.html" \
			| cut -f 1 -d " ")
einfo
einfo "Update the license file with"
einfo
einfo "  \`cp -a ${s}/out/Release/gen/components/resources/about_credits.html ${MY_OVERLAY_DIR}/licenses/${license_file_name}\`"
einfo
einfo "Update ebuild with"
einfo
einfo "  LICENSE_FINGERPRINT=\"${fp}\""
einfo
einfo "and with LICENSE variable updates.  When you are done updating, comment"
einfo "out GEN_ABOUT_CREDITS."
einfo
		die
	fi
}

__clean_build() {
	if [[ -f "out/Release/chromedriver" ]] ; then
		rm -f "out/Release/chromedriver" \
			|| die
	fi
	if [[ -f "out/Release/chromedriver.unstripped" ]] ; then
		rm -f "out/Release/chromedriver.unstripped" \
			|| die
	fi
	if [[ -f "out/Release/build.ninja" ]] ; then
		pushd "out/Release" >/dev/null 2>&1 || die
einfo "Cleaning out build"
			eninja -t clean
		popd >/dev/null 2>&1 || die
	fi
}

_get_s() {
	if (( ${NABIS} == 1 )) ; then
		echo "${S}"
	else
		echo "${S}-${MULTILIB_ABI_FLAG}.${ABI}"
	fi
}

_src_compile() {
	export s=$(_get_s)
	cd "${s}" || die

	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	# Don't inherit PYTHONPATH from environment, bug #789021, #812689
	local -x PYTHONPATH=

	#"${EPYTHON}" tools/clang/scripts/update.py \
	#	--force-local-build \
	#	--gcc-toolchain /usr \
	#	--skip-checkout \
	#	--use-system-cmake \
	#	--without-android || die

	_update_licenses
	__clean_build

	# Build mksnapshot and pax-mark it.
	local x
	for x in "mksnapshot" "v8_context_snapshot_generator" ; do
		if tc-is-cross-compiler ; then
			_eninja \
				"out/Release" \
				"host/${x}" \
				"out/Release/host/${x}"
		else
			_eninja \
				"out/Release" \
				"${x}" \
				"out/Release/${x}"
		fi
	done

	# Even though ninja autodetects number of CPUs, we respect user's
	# options, for debugging with -j 1 or any other reason.
	_eninja "out/Release" "chrome" "out/Release/chrome"
	_eninja "out/Release" "chromedriver" ""
	_eninja "out/Release" "chrome_sandbox" ""
	if use test ; then
		_eninja "out/Release" "base_unittests" ""
	fi

	if ! use system-toolchain ; then
		QA_FLAGS_IGNORED="
			usr/lib64/chromium-browser/chrome
			usr/lib64/chromium-browser/chrome-sandbox
			usr/lib64/chromium-browser/chromedriver
			usr/lib64/chromium-browser/chrome_crashpad_handler
			usr/lib64/chromium-browser/libEGL.so
			usr/lib64/chromium-browser/libGLESv2.so
			usr/lib64/chromium-browser/libVkICD_mock_icd.so
			usr/lib64/chromium-browser/libVkLayer_khronos_validation.so
			usr/lib64/chromium-browser/libqt5_shim.so
			usr/lib64/chromium-browser/libvk_swiftshader.so
			usr/lib64/chromium-browser/libvulkan.so.1
		"
	fi

	mv out/Release/chromedriver{.unstripped,} || die

	rm -f out/Release/locales/*.pak.info || die

	# Build manpage; bug #684550
	sed -e  '
		s|@@PACKAGE@@|chromium-browser|g;
		s|@@MENUNAME@@|Chromium|g;
		' \
		"chrome/app/resources/manpage.1.in" \
		> \
		"out/Release/chromium-browser.1" \
		|| die

	# Build desktop file; bug #706786
	local suffix
	(( ${NABIS} > 1 )) && suffix=" (${ABI})"
	sed -e  "
		s|@@MENUNAME@@|Chromium${suffix}|g;
		s|@@USR_BIN_SYMLINK_NAME@@|chromium-browser-${ABI}|g;
		"'
		s|@@PACKAGE@@|chromium-browser|g;
		s|\(^Exec=\)/usr/bin/|\1|g;
		' \
		"chrome/installer/linux/common/desktop.template" \
		> \
		"out/Release/chromium-browser-chromium.desktop" \
		|| die

	# Build vk_swiftshader_icd.json; bug #827861
	sed -e 's|${ICD_LIBRARY_PATH}|./libvk_swiftshader.so|g' \
		"third_party/swiftshader/src/Vulkan/vk_swiftshader_icd.json.tmpl" \
		> \
		"out/Release/vk_swiftshader_icd.json" \
		|| die
}

_src_install() {
	local CHROMIUM_HOME="/usr/$(get_libdir)/chromium-browser"
	exeinto "${CHROMIUM_HOME}"
	doexe "out/Release/chrome"

	newexe \
		"out/Release/chrome_sandbox" \
		"chrome-sandbox"
	fperms 4755 "${CHROMIUM_HOME}/chrome-sandbox"

	newexe \
		"out/Release/chromedriver" \
		"chromedriver-${ABI}"
	doexe "out/Release/chrome_crashpad_handler"

	ozone_auto_session=$(\
		 ! use headless \
		&& use wayland \
		&& use X \
		&& echo "true" \
		|| echo "false")
	sed -e  "
		s:/usr/lib/:/usr/$(get_libdir)/:g;
		s:chromium-browser-chromium.desktop:chromium-browser-chromium-${ABI}.desktop:g;
		s:@@OZONE_AUTO_SESSION@@:${ozone_auto_session}:g;
		" \
		"${FILESDIR}/chromium-launcher-r7.sh" \
		> \
		"chromium-launcher.sh" \
		|| die
	newexe \
		"chromium-launcher.sh" \
		"chromium-launcher-${ABI}.sh"

	# It is important that we name the target "chromium-browser",
	# xdg-utils expect it; bug #355517.
	dosym \
		"${CHROMIUM_HOME}/chromium-launcher-${ABI}.sh" \
		"/usr/bin/chromium-browser-${ABI}"
	dosym \
		"${CHROMIUM_HOME}/chromium-launcher-${ABI}.sh" \
		"/usr/bin/chromium-browser"
	# Keep the old symlink around for consistency
	dosym \
		"${CHROMIUM_HOME}/chromium-launcher-${ABI}.sh" \
		"/usr/bin/chromium-${ABI}"
	dosym \
		"${CHROMIUM_HOME}/chromium-launcher-${ABI}.sh" \
		"/usr/bin/chromium"

	dosym \
		"${CHROMIUM_HOME}/chromedriver-${ABI}" \
		"/usr/bin/chromedriver-${ABI}"
	dosym \
		"${CHROMIUM_HOME}/chromedriver-${ABI}" \
		"/usr/bin/chromedriver"

	# Allow users to override command-line options, bug #357629.
	insinto "/etc/chromium"
	newins "${FILESDIR}/chromium.default" "default"

	pushd "out/Release/locales" >/dev/null 2>&1 || die
		chromium_remove_language_paks
	popd >/dev/null 2>&1 || die

	insinto "${CHROMIUM_HOME}"
	doins "out/Release/"*".bin"
	doins "out/Release/"*".pak"

	if use bindist; then
	# We built libffmpeg as a component library, but we can't distribute it
	# with proprietary codec support.  Remove it and make a symlink to the
	# requested system library.
		if ! rm -f out/Release/libffmpeg.so ; then \
eerror "Failed to remove bundled libffmpeg.so (with proprietary codecs)"
			die
		fi
	# Symlink the libffmpeg.so from either ffmpeg-chromium or
	# ffmpeg[chromium].
	local symlink_loc=$(usex ffmpeg-chromium "ffmpeg-chromium" "ffmpeg[chromium]")
einfo "Creating symlink to libffmpeg.so from ${symlink_loc}..."
		dosym \
			"../chromium/libffmpeg.so"$(usex ffmpeg-chromium ".${PV%%\.*}" "") \
			"/usr/$(get_libdir)/chromium-browser/libffmpeg.so"
	fi

	(
		shopt -s nullglob
		local files=(
			"out/Release/"*".so"
			"out/Release/"*".so."[0-9]
		)
		(( ${#files[@]} > 0 )) && doins "${files[@]}"
	)

	# Install bundled xdg-utils, avoids installing X11 libraries with
	# USE="-X wayland"
	doins "out/Release/xdg-"{"settings","mime"}

	if ! use system-icu && ! use headless; then
		doins "out/Release/icudtl.dat"
	fi

	doins -r "out/Release/locales"
	doins -r "out/Release/MEIPreload"

	# Install vk_swiftshader_icd.json; bug #827861
	doins "out/Release/vk_swiftshader_icd.json"

	if [[ -d "out/Release/swiftshader" ]] ; then
		insinto "${CHROMIUM_HOME}/swiftshader"
		doins "out/Release/swiftshader/"*".so"
	fi

	# Install icons
	local branding size
	for size in 16 24 32 48 64 128 256 ; do
		case ${size} in
			16|32) branding="chrome/app/theme/default_100_percent/chromium" ;;
			*)     branding="chrome/app/theme/chromium" ;;
		esac
		newicon \
			-s ${size} \
			"${branding}/product_logo_${size}.png" \
			"chromium-browser.png"
	done

	# Install desktop entry
	newmenu \
		"out/Release/chromium-browser-chromium.desktop" \
		"chromium-browser-chromium-${ABI}.desktop"

	# Install GNOME default application entry (bug #303100).
	insinto "/usr/share/gnome-control-center/default-apps"
	newins \
		"${FILESDIR}/chromium-browser.xml" \
		"chromium-browser.xml"

	# Install manpage; bug #684550
	doman "out/Release/chromium-browser.1"
	dosym \
		"chromium-browser.1" \
		"/usr/share/man/man1/chromium.1"

	readme.gentoo_create_doc

	# This next pass will copy PATENTS, *ThirdParty*, NOTICE files;
	# and npm micropackages copyright notices and licenses which may not
	# have been present in the listed the the .html (about:credits) file.
	lcnr_install_files

	if has cromite ${IUSE_EFFECTIVE} && use cromite ; then
		insinto "/usr/share/cromite/docs"
		doins \
			"${S_CROMITE}/docs/FEATURES.md" \
			"${S_CROMITE}/docs/PRIVACY_POLICY.md" \
			"${S_CROMITE}/README.md"
		insinto "/usr/share/cromite/licenses"
		doins \
			"${S_CROMITE}/docs/PATCHES.md" \
			"${S_CROMITE}/LICENSE"
	fi

	if has ungoogled-chromium ${IUSE_EFFECTIVE} && use ungoogled-chromium ; then
		insinto "/usr/share/ungoogle-chromium/docs"
		doins \
			"${S_UNGOOGLED_CHROMIUM}/README.md" \
			"${S_UNGOOGLED_CHROMIUM}/docs/flags.md" \
			"${S_UNGOOGLED_CHROMIUM}/docs/default_settings.md" \
			"${S_UNGOOGLED_CHROMIUM}/docs/platforms.md"
		insinto "/usr/share/ungoogle-chromium/licenses"
		doins \
			"${S_UNGOOGLED_CHROMIUM}/LICENSE"
	fi
}

src_compile() {
	compile_abi() {
		_src_configure_compiler
		_src_configure
		_src_compile
	}
	multilib_foreach_abi compile_abi
}

src_test() {
	# The initial list of tests to skip pulled from Alpine. Thanks Lauren!
	# https://issues.chromium.org/issues/40939315
	local skip_tests=(
		'MessagePumpLibeventTest.NestedNotification*'
		ClampTest.Death
		OptionalTest.DereferencingNoValueCrashes
		PlatformThreadTest.SetCurrentThreadTypeTest
		RawPtrTest.TrivialRelocability
		SafeNumerics.IntMaxOperations
		StackTraceTest.TraceStackFramePointersFromBuffer
		StringPieceTest.InvalidLengthDeath
		StringPieceTest.OutOfBoundsDeath
		ThreadPoolEnvironmentConfig.CanUseBackgroundPriorityForWorker
		ValuesUtilTest.FilePath
		# Gentoo-specific
		AlternateTestParams/PartitionAllocDeathTest.RepeatedAllocReturnNullDirect/0
		AlternateTestParams/PartitionAllocDeathTest.RepeatedAllocReturnNullDirect/1
		AlternateTestParams/PartitionAllocDeathTest.RepeatedAllocReturnNullDirect/2
		AlternateTestParams/PartitionAllocDeathTest.RepeatedAllocReturnNullDirect/3
		AlternateTestParams/PartitionAllocDeathTest.RepeatedReallocReturnNullDirect/0
		AlternateTestParams/PartitionAllocDeathTest.RepeatedReallocReturnNullDirect/1
		AlternateTestParams/PartitionAllocDeathTest.RepeatedReallocReturnNullDirect/2
		AlternateTestParams/PartitionAllocDeathTest.RepeatedReallocReturnNullDirect/3
		CharacterEncodingTest.GetCanonicalEncodingNameByAliasName
		CheckExitCodeAfterSignalHandlerDeathTest.CheckSIGFPE
		CheckExitCodeAfterSignalHandlerDeathTest.CheckSIGILL
		CheckExitCodeAfterSignalHandlerDeathTest.CheckSIGSEGV
		CheckExitCodeAfterSignalHandlerDeathTest.CheckSIGSEGVNonCanonicalAddress
		FilePathTest.FromUTF8Unsafe_And_AsUTF8Unsafe
		FileTest.GetInfoForCreationTime
		ICUStringConversionsTest.ConvertToUtf8AndNormalize
		NumberFormattingTest.FormatPercent
		PathServiceTest.CheckedGetFailure
		PlatformThreadTest.CanChangeThreadType
		StackCanary.ChangingStackCanaryCrashesOnReturn
		StackTraceDeathTest.StackDumpSignalHandlerIsMallocFree
		SysStrings.SysNativeMBAndWide
		SysStrings.SysNativeMBToWide
		SysStrings.SysWideToNativeMB
		TestLauncherTools.TruncateSnippetFocusedMatchesFatalMessagesTest
		ToolsSanityTest.BadVirtualCallNull
		ToolsSanityTest.BadVirtualCallWrongType
	)
	local test_filter="-$(IFS=:; printf '%s' "${skip_tests[*]}")"
	# test-launcher-bot-mode enables parallelism and plain output.
	./out/Release/base_unittests \
		--test-launcher-bot-mode \
		--test-launcher-jobs="$(makeopts_jobs)" \
		--gtest_filter="${test_filter}" \
		|| die "Tests failed!"
}

src_install() {
	install_abi() {
		cd $(_get_s) || die
		_src_install
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postinst() {
	dhms_end
	xdg_icon_cache_update
	xdg_desktop_database_update
	readme.gentoo_print_elog

	if ! use headless; then
		if use vaapi ; then
	# It says 3 args:
	# https://github.com/chromium/chromium/blob/131.0.6778.69/docs/gpu/vaapi.md#vaapi-on-linux
einfo
einfo "VA-API is disabled by default at runtime.  You have to enable it by"
einfo "adding --enable-features=VaapiVideoDecoder --ignore-gpu-blocklist with"
einfo "either --use-gl=desktop or --use-gl=egl to the CHROMIUM_FLAGS in"
einfo "/etc/chromium/default."
einfo
		fi
		if use screencast ; then
einfo
einfo "Screencast is disabled by default at runtime. Either enable it by"
einfo "navigating to chrome://flags/#enable-webrtc-pipewire-capturer inside"
einfo "Chromium or add --enable-features=WebRTCPipeWireCapturer to"
einfo "CHROMIUM_FLAGS in /etc/chromium/default."
einfo
		fi
		if use gtk4; then
einfo
einfo "Chromium prefers GTK3 over GTK4 at runtime. To override this behavior"
einfo "you need to pass --gtk-version=4, e.g. by adding it to CHROMIUM_FLAGS in"
einfo "/etc/chromium/default."
einfo
		fi
		if use qt5 || use qt6 ; then
einfo
einfo "Chromium automatically selects Qt5 or Qt6 based on your desktop"
einfo "environment. To override you need to pass --qt-version=5 or"
einfo "--qt-version=6, e.g. by adding it to CHROMIUM_FLAGS in"
einfo "/etc/chromium/default."
einfo
		fi
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

einfo
einfo "See metadata.xml or \`epkginfo -x =${CATEGORY}/${P}::oiledmachine-overlay\`"
einfo "for proper building with PGO+BOLT"
einfo

	if systemd_is_booted && ! [[ -f "/etc/machine-id" ]] ; then
ewarn
ewarn "The lack of an '/etc/machine-id' file on this system booted with systemd"
ewarn "indicates that the Gentoo handbook was not followed to completion."
ewarn
ewarn "Chromium is known to behave unpredictably with this system configuration;"
ewarn "please complete the configuration of this system before logging any bugs."
ewarn
	fi
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multiabi, build-32-bit-on-64-bit, license-completeness, license-transparency, prebuilt-pgo-access, shadowcallstack-option-access, disable-simd-on-old-microarches-with-zlib, allow-cfi-with-official-build-settings, branch-protection-access
# OILEDMACHINE-OVERLAY-META-WIP: event-based-full-pgo

#
# = Ebuild fork maintainer checklist =
#
# Update to latest stable every week
# Sync update patch section
#   Check for patch failure
#   Fix patches
# Sync update depends section
# Update license files
#   Set GEN_ABOUT_CREDITS=1
#   Copy license to license folder
# Update the llvm commit details
#  Update LLVM_COMPAT
# Sync update keeplibs, gn_system_libraries
# Sync update CHROMIUM_LANGS in every major version
# Bump chromium-launcher-rX.sh if changed
#
# *Sync update means to keep it updated with the distro ebuild.
#

# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  YES
# OILEDMACHINE-OVERLAY-TEST: PASSED (interactive) 128.0.6613.119 (20240907)
# Oflag = -O2
# Build Completion time:  1 days, 17 hrs, 11 mins, 53 secs - fail, did not pass 24 hrs fix standard for critical vulnerabilities.  Package not built and installed within 24 hrs.
# Tests performed:
#   video playback - pass
#     opus - pass
#     av1 - pass
#     vpx - pass
#     h264 - pass
#   audio streaming - pass
#     US radio website(s) - pass
#     UK websites - pass
#     aac streams (shoutcast v1 / HTTP 0.9) - pass, expected fail, some links will work with v2
#     mp3 streams (shoutcast v1 / HTTP 0.9) - pass, expected fail, some links will work with v2
#   audio on demand - pass
#     aac - pass
#     mp3 - pass
#     vorbis - pass
#     wav - pass
#   browsing - pass
#     vertical scrolling - smooth and fast
#   WebGL Aquarium - pass, ~60 fps with default settings
#   CanvasMark 2013 (html5 canvas tests) - pass (Score: 12854)
#   GPU Shader Experiments (https://www.kevs3d.co.uk/dev/shaders/) - pass, randomly selected
#   HTML5 test - 523/555
#   sandbox - passed
#     pid - passed
#     network - passed
#     seccomp-bpf - passed
#     ptrace protection - no
# Custom patches/edits:
# v8 Custom Oflag level - pass
# Qt6 without Qt5 - pass
# Mold linking - pass (mold 2.33.0)
# Ccache with vendored clang - pass
# USE="X bundled-libcxx custom-cflags dav1d mold openh264 opus pgo
# proprietary-codecs pulseaudio qt6 vaapi vpx wayland -bindist
# -bluetooth -branch-protection -cfi -cups (-debug) -encode -ffmpeg-chromium
# -gtk4 -hangouts (-headless) -js-type-check -kerberos -libaom -official
# -pax-kernel -pic -pre-check-vaapi -proprietary-codecs-disable
# -proprietary-codecs-disable-nc-developer -proprietary-codecs-disable-nc-user
# (-qt5) -screencast (-selinux) -system-dav1d -system-ffmpeg -system-flac
# -system-fontconfig -system-freetype -system-harfbuzz -system-icu
# -system-libaom -system-libdrm -system-libjpeg-turbo -system-libpng
# -system-libstdcxx -system-libwebp -system-libxml -system-libxslt
# -system-openh264 -system-opus -system-re2 (-system-toolchain) -system-zlib
# -system-zstd -systemd -thinlto-opt -vaapi-hevc -widevine -vorbis"
# LLVM_SLOT="(-19) -20"

# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 114.0.5735.90 (20230601)
# Tests performed:
#   video playback - pass
#     opus - pass
#     av1 - pass
#     vpx - pass
#     h264 - pass
#   audio streaming - pass
#     US radio website(s) - pass
#     UK websites - pass
#     aac streams (shoutcast v1 / HTTP 0.9) - expected fail, some links will work with v2
#     mp3 streams (shoutcast v1 / HTTP 0.9) - expected fail, some links will work with v2
#   audio on demand - pass
#     aac - pass
#     mp3 - pass
#     vorbis - pass
#     wav - pass
#   browsing - pass
#   WebGL Aquarium - pass, ~60 fps with default settings
#   CanvasMark 2013 (html5 canvas tests) - pass
#   GPU Shader Experiments (https://www.kevs3d.co.uk/dev/shaders/) - pass, randomly selected
# Test comments:  Built with clang 17.0.0, Python 3.11.  64-bit ABI only
# USE="X bundled-libcxx cfi custom-cflags dav1d openh264 opus pgo (pic)
# CFLAGS:  -O2 -pipe (after conversion)
# TODO:  Retest -Ofast in 115
# proprietary-codecs pulseaudio vpx wayland -bluetooth -branch-protection
# (-component-build) -cups (-debug) -ebolt -encode -epgo -gtk4 -hangouts
# (-headless) -js-type-check -kerberos -libaom -official -pax-kernel
# -pre-check-vaapi -proprietary-codecs-disable
# -proprietary-codecs-disable-nc-developer -proprietary-codecs-disable-nc-user
# -qt5 (-qt6) -r1 -screencast (-selinux) (-suid) -system-dav1d -system-ffmpeg
# -system-flac -system-fontconfig -system-freetype -system-harfbuzz -system-icu
# -system-libaom -system-libdrm -system-libjpeg-turbo -system-libpng
# -system-libstdcxx -system-libwebp -system-libxml -system-libxslt
# -system-openh264 -system-opus -system-re2 -system-zlib -thinlto-opt -vaapi
# -vaapi-hevc -vorbis -widevine"
# OILEDMACHINE-OVERLAY-TEST:  FAILED (interactive) 115.0.5790.40 (20230601)
# C{,XX}FLAGS:  -Ofast -pipe ; TODO:  Fix -Ofast crashes
# LDFLAGS:  -fuse-ld=thin
# gl-aquarium test - stuck non-moving fishes
# tab crash when watching music videos

# OILEDMACHINE-OVERLAY-TEST:  129.0.6668.58 (build test passed)
# Tests performed:
#   browsing - pass
#   GPU Shader Experiments (https://www.kevs3d.co.uk/dev/shaders/) - pass, randomly selected
#   sandbox check - passed
#   video playback - pass
#     av1 - pass
#     h264 - pass
#     opus - pass
#     vpx - pass
#   WebGL Aquarium - pass, ~60 fps with default settings
# Oflag = -Oshit
# OSHIT_OPT_LEVEL_DAV1D="2"
# OSHIT_OPT_LEVEL_LIBAOM="1"
# OSHIT_OPT_LEVEL_LIBVPX="2"
# OSHIT_OPT_LEVEL_OPENH264="1"
# OSHIT_OPT_LEVEL_RNNOISE="1"
# OSHIT_OPT_LEVEL_RUY="1"
# OSHIT_OPT_LEVEL_TFLITE="1"
# OSHIT_OPT_LEVEL_V8="2"
# OSHIT_OPT_LEVEL_XNNPACK="1"
# USE="X async-dns bundled-libcxx custom-cflags dav1d extensions mold openh264
# opus pdf plugins pointer-compression proprietary-codecs pulseaudio qt6
# screen-capture vaapi vpx wayland -accessibility -bindist -bluetooth
# -cet -cfi -css-hyphen -cups (-debug) -drumbrake -ebuild-revision-1 -encode
# -ffmpeg-chromium -firejail -gtk4 -hangouts (-headless) -hidpi -jit
# -js-type-check -kerberos -libaom -mdns -ml -mpris -official -partitionalloc
# -pax-kernel -pgo -pic -pre-check-vaapi -proprietary-codecs-disable
# -proprietary-codecs-disable-nc-developer -proprietary-codecs-disable-nc-user
# (-qt5) -reporting-api -screencast (-selinux) -spelling-service -system-dav1d
# -system-ffmpeg -system-flac -system-fontconfig -system-freetype
# -system-harfbuzz -system-icu -system-libaom -system-libdrm
# -system-libjpeg-turbo -system-libpng -system-libstdcxx -system-libwebp
# -system-libxml -system-libxslt -system-openh264 -system-opus -system-re2
# (-system-toolchain) -system-zlib -system-zstd -systemd -vaapi-hevc -vorbis
# -webassembly -widevine"
