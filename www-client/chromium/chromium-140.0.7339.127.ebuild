# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2009-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D11, U22, U24

# Monitor
#   https://chromereleases.googleblog.com/search/label/Dev%20updates
# for security updates.  They are announced faster than NVD.
# See https://chromiumdash.appspot.com/releases?platform=Linux for the latest linux version

# Patchsets
# https://github.com/ungoogled-software/ungoogled-chromium
# https://github.com/uazo/cromite

# Ebuild diff or sync update notes:
# 128.0.6613.119 -> 128.0.6613.137
# 129.0.6668.89 -> 129.0.6668.100
# 129.0.6668.100 -> 130.0.6723.91
# 130.0.6723.91 -> 131.0.6778.69
# 131.0.6778.108 -> 131.0.6778.139
# 131.0.6778.139 -> 131.0.6778.264
# 132.0.6834.83 -> 133.0.6943.53
# 133.0.6943.53 -> 134.0.6998.35
# 134.0.6998.35 -> 134.0.6998.88
# 134.0.6998.88 -> 135.0.7049.84
# 135.0.7049.84 -> 135.0.7049.114
# 135.0.7049.114 -> 136.0.7103.59
# 136.0.7103.59 -> 136.0.7103.92
# 136.0.7103.92 -> 137.0.7151.55
# 137.0.7151.55 -> 137.0.7151.68
# 138.0.7204.49 -> 138.0.7204.100
# 138.0.7204.100 -> 139.0.7258.66
# 139.0.7258.66 -> 140.0.7339.80
# 140.0.7339.80 -> 140.0.7339.127

# For depends see:
# https://github.com/chromium/chromium/tree/140.0.7339.127/build/linux/sysroot_scripts/generated_package_lists				; Last update 20240501, D11
#   alsa-lib, at-spi2-core, bluez (bluetooth), cairo, cups, curl, expat,
#   flac [older], fontconfig [older], freetype [older], gcc, gdk-pixbuf, glib,
#   glibc [missing check], gtk+3, gtk4, harfbuzz [older], libdrm [older], libffi, libglvnd,
#   libjpeg-turbo [older], libpng [older], libva, libwebp [older], libxcb,
#   libxcomposite, libxcursor, libxdamage, libxext, libxfixes, libx11, libxi,
#   libxkbcommon, libxml2 [older], libxrandr, libxrender, libxshmfence,
#   libxslt [older], nspr, nss, opus [older], pango, pciutils, pipewire,
#   libpulse, qt5, qt6, re2 [older], systemd, udev, wayland, zlib [older]
# https://github.com/chromium/chromium/blob/140.0.7339.127/build/install-build-deps.py

#
# Additional DEPENDS versioning info:
#
# https://github.com/chromium/chromium/blob/140.0.7339.127/third_party/dav1d/version/vcs_version.h#L2					; newer than generated_package_lists *
# https://github.com/chromium/chromium/blob/140.0.7339.127/third_party/libaom/source/config/config/aom_version.h#L19			; newer than generated_package_lists *
# https://github.com/chromium/chromium/blob/140.0.7339.127/third_party/libpng/png.h#L288							; newer than generated_package_lists
# https://github.com/chromium/chromium/blob/140.0.7339.127/third_party/libxml/linux/config.h#L86						; older than generated_package_lists *
# https://github.com/chromium/chromium/blob/140.0.7339.127/third_party/libxslt/linux/config.h#L116					; newer than generated_package_lists *
# https://github.com/chromium/chromium/blob/140.0.7339.127/third_party/node/update_node_binaries#L18					; *
# https://github.com/chromium/chromium/blob/140.0.7339.127/third_party/re2/README.chromium#L4						; newer than generated_package_lists, (live) [rounded in ebuild]
# https://github.com/chromium/chromium/blob/140.0.7339.127/third_party/zlib/zlib.h#L40
# https://github.com/chromium/chromium/blob/140.0.7339.127/tools/rust/update_rust.py#L35							; commit *
#   https://github.com/rust-lang/rust/blob/c8f94230282a8e8c1148f3e657f0199aad909228/src/version						; live version
# /usr/share/chromium/sources/third_party/flac/BUILD.gn										L122	; newer than generated_package_lists
# /usr/share/chromium/sources/third_party/fontconfig/src/fontconfig/fontconfig.h						L54     ; newer than generated_package_lists
# /usr/share/chromium/sources/third_party/freetype/src/CMakeLists.txt								L165	; newer than generated_package_lists *
# /usr/share/chromium/sources/third_party/harfbuzz-ng/README.chromium									; newer than generated_package_lists *
# /usr/share/chromium/sources/third_party/icu/source/configure									L585	; newer than generated_package_lists
# /usr/share/chromium/sources/third_party/libdrm/src/meson.build								L24	; newer than generated_package_lists *
# /usr/share/chromium/sources/third_party/libjpeg_turbo/src/jconfig.h								L7	; newer than generated_package_lists
# /usr/share/chromium/sources/third_party/libwebp/src/configure.ac								L1	; newer than generated_package_lists *
# /usr/share/chromium/sources/third_party/openh264/src/meson.build								L2
# /usr/share/chromium/sources/third_party/opus/README.chromium									L3	; newer than generated_package_lists, live
#   https://gitlab.xiph.org/xiph/opus/-/commit/55513e81d8f606bd75d0ff773d2144e5f2a732f5							; see tag (live, 20250318) *
# /usr/share/chromium/sources/third_party/zstd/README.chromium										; live version (20250414) *
#   https://github.com/facebook/zstd/commit/d654fca78690fa15cceb8058ac47454d914a0e63							; check if commit part of tag
#   https://github.com/facebook/zstd/blob/d654fca78690fa15cceb8058ac47454d914a0e63/lib/zstd.h#L107					; version
# https://github.com/chromium/chromium/blob/140.0.7339.127/DEPS#L512									; live

ALLOW_SYSTEM_TOOLCHAIN=0
CFI_CAST=0 # Global variable
CFI_ICALL=0 # Global variable
CFI_VCALL=0 # Global variable
CFLAGS_ASSEMBLERS="gas inline nasm"
CFLAGS_HARDENED_BUILDFILES_SANITIZERS="asan cfi hwasan lsan msan scs tsan ubsan"
CFLAGS_HARDENED_LANGS="asm c-lang cxx"
CFLAGS_HARDENED_SANITIZERS="address hwaddress undefined"
#CFLAGS_HARDENED_SANITIZERS_COMPAT="clang"
CFLAGS_HARDENED_SSP_LEVEL="1" # Global variable
CFLAGS_HARDENED_USE_CASES="copy-paste-password jit network scripting sensitive-data untrusted-data web-browser"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE DF HO IO NPD OOBA OOBR OOBW PE RC SO UAF TC"
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
CHROMIUM_TOOLCHAIN=1

CROMITE_COMMIT="63888d58b55fab6873bea02b17bd3c533dfad697" # Based on most recent either tools/under-control/src/RELEASE or build/RELEASE
CROMITE_PV="140.0.7339.128"

# About PGO version compatibility
#
# The answer to the profdata compatibility is answered in
# https://clang.llvm.org/docs/SourceBasedCodeCoverage.html#format-compatibility-guarantees
#
# The profdata (aka indexed profile) version is 10 corresponding from LLVM 16+
# and is after the magic (lprofi - i for index) in the profdata file located in
# chrome/build/pgo_profiles/*.profdata.
#
# Profdata versioning (ProfVersion):
# https://github.com/llvm/llvm-project/blob/7b473dfe/llvm/include/llvm/ProfileData/InstrProf.h#L1116
# LLVM version:
# https://github.com/llvm/llvm-project/blob/7b473dfe/cmake/Modules/LLVMVersion.cmake

# LLVM timestamp can be obtained from \
# https://github.com/chromium/chromium/blob/140.0.7339.127/tools/clang/scripts/update.py#L42 \
# https://github.com/llvm/llvm-project/commit/7b473dfe
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
DISTRIBUTED_BUILD=0 # Global variable
# See also
# third_party/ffmpeg/libavutil/version.h
# third_party/ffmpeg/libavcodec/version*.h
# third_party/ffmpeg/libavformat/version*.h
FFMPEG_SLOT="0/59.61.61" # Same as ffmpeg 7.0 ; 0/libavutil_sover_maj.libavcodec_sover_maj.libformat_sover_maj
FORCE_MKSNAPSHOT=1 # Setting to a value other than 1 is untested.
GCC_COMPAT=( {14..10} )
GCC_PV="10.2.1" # Minimum
GCC_SLOT="" # Global variable
GTK3_PV="3.24.24"
GTK4_PV="4.8.3"
LIBVA_PV="2.17.0"
# SHA512 about_credits.html fingerprint: \
LICENSE_FINGERPRINT="\
68aefe6548277b28cc1c9d3137a42efac54623a1420192bf9ada58dc054f376a\
b94a0e89d1ddf1763bf2172bf49a4818fa1752e95d3491d56b4c898fa200ac86\
"
if [[ "${ALLOW_SYSTEM_TOOLCHAIN}" == "1" ]] ; then
	LLVM_COMPAT=( 22 21 ) # Can use [CURRENT_LLVM_MAJOR_VERSION+1 or CURRENT_LLVM_MAJOR_VERSION] inclusive
	LLVM_MAX_SLOT="${LLVM_COMPAT[0]}" # Max can be is LLVM_OFFICIAL_SLOT+1
	LLVM_MIN_SLOT="${LLVM_COMPAT[-1]}" # Min is both LLVM_OFFICIAL_SLOT and the pregenerated PGO profile needed for INSTR_PROF_INDEX_VERSION version 12 compatibility for the profdata file format.
else
	LLVM_COMPAT=( 21 ) # Forced to match upstream
	LLVM_MAX_SLOT="${LLVM_COMPAT[0]}" # Max can be is LLVM_OFFICIAL_SLOT+1
	LLVM_MIN_SLOT="${LLVM_COMPAT[-1]}" # Min is both LLVM_OFFICIAL_SLOT and the pregenerated PGO profile needed for INSTR_PROF_INDEX_VERSION version 12 compatibility for the profdata file format.
fi
LLVM_OFFICIAL_SLOT="${LLVM_COMPAT[-1]}" # Cr official slot
LLVM_SLOT="" # Global variable
LTO_TYPE="" # Global variable
MESA_PV="20.3.5"
MITIGATION_DATE="Sep 2, 2025" # Official annoucement (blog)
MITIGATION_LAST_UPDATE=1757373660 # From `date +%s -d "2025-09-08 4:21 PM PDT"` From tag in GH
MITIGATION_URI="https://chromereleases.googleblog.com/2025/09/stable-channel-update-for-desktop_9.html"
VULNERABILITIES_FIXED=(
	"CVE-2025-10200;MC, DoS, DT, ID;High"
	"CVE-2025-10201;DoS, DT, ID;High"
)
NABIS=0 # Global variable
NODE_VERSION=22
PATENT_STATUS=(
	"patent_status_nonfree"
	"patent_status_sponsored_ncp_nb"
)
PPC64_HASH="a85b64f07b489b8c6fdb13ecf79c16c56c560fc6"
PATCHSET_PPC64="128.0.6613.84-1raptor0~deb12u1"
PATCH_REVISION=""
PATCH_VER="${PV%%\.*}${PATCH_REVISION}"
PGO_LLVM_SUPPORTED_VERSIONS=(
	"22.0.0.9999"
	"22.0.0"
	"${LLVM_OFFICIAL_SLOT}.0.0.9999"
	"${LLVM_OFFICIAL_SLOT}.0.0"
)
PREGENERATED_PGO_PROFILE_MIN_LLVM_SLOT="${LLVM_MIN_SLOT}"
PYTHON_COMPAT=( "python3_"{9..13} )
PYTHON_REQ_USE="xml(+)"
QT6_PV="6.4.2"
UNGOOGLED_CHROMIUM_PV="140.0.7339.132-1"
USE_LTO=0 # Global variable
# https://github.com/chromium/chromium/blob/140.0.7339.127/tools/clang/scripts/update.py#L38 \
# grep 'CLANG_REVISION = ' ${S}/tools/clang/scripts/update.py -A1 | cut -c 18- # \
LLVM_OFFICIAL_SLOT="21" # Cr official slot
TEST_FONT="a28b222b79851716f8358d2800157d9ffe117b3545031ae51f69b7e1e1b9a969"
# https://github.com/chromium/chromium/blob/140.0.7339.127/tools/rust/update_rust.py#L37 \
# grep 'RUST_REVISION = ' ${S}/tools/rust/update_rust.py -A1 | cut -c 17- # \
RUST_NEEDS_LLVM="yes please"
RUST_OPTIONAL="yes" # Not actually optional, but we don't need system Rust (or LLVM) with USE=bundled-toolchain
RUSTC_VER="" # Global variable
RUST_MAX_VER="9999" # Corresponds to llvm-20.1
RUST_MIN_VER="9999" # Corresponds to llvm-20.1
RUST_PV="${RUST_MIN_VER}"
SHADOW_CALL_STACK=0 # Global variable
S_CROMITE="${WORKDIR}/cromite-${CROMITE_COMMIT}"
S_UNGOOGLED_CHROMIUM="${WORKDIR}/ungoogled-chromium-${UNGOOGLED_CHROMIUM_PV}"
TESTDATA_P="${PN}-${PV}"
# Testing this version to avoid breaking security.  The 13.6 series cause the \
# mksnapshot "Return code is -11" error.  To fix it, it required to either \
# disable v8 sandbox, or pointer compression and DrumBrake.  Before it was \
# possible to use all 3.  The 13.7 series fixes contains the 5c595ad commit \
# to fix a compile error when DrumBrake is enabled. \
#V8_PV="13.7.152.7" # About the same as the latest Chromium beta release.
ZLIB_PV="1.3.1"

inherit cflags-depends cflags-hardened check-compiler-switch check-linker check-reqs chromium-2 dhms
inherit desktop edo flag-o-matic flag-o-matic-om linux-info lcnr
inherit multilib-minimal multiprocessing ninja-utils pax-utils python-any-r1
inherit readme.gentoo-r1 systemd toolchain-funcs vf xdg-utils

if [[ "${ALLOW_SYSTEM_TOOLCHAIN}" == "1" ]] ; then
	inherit llvm rust
fi

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

#if [[ "${CHROMIUM_EBUILD_MAINTAINER}" == "1" ]] ; then
#	:
#elif [[ "${PATCHSET_PPC64%%.*}" == "${PV%%.*}" ]] ; then
#	KEYWORDS="~amd64 ~arm64 ~ppc64"
#else
#	KEYWORDS="~amd64 ~arm64"
#fi

# See https://gsdview.appspot.com/chromium-browser-official/?marker=chromium-137.0.7151.0.tar.x%40
SRC_URI+="
	ppc64? (
https://gitlab.raptorengineering.com/raptor-engineering-public/chromium/openpower-patches/-/archive/${PPC64_HASH}/openpower-patches-${PPC64_HASH}.tar.bz2
	-> chromium-openpower-${PPC64_HASH:0:10}.tar.bz2
	)
	test? (
https://gsdview.appspot.com/chromium-browser-official/chromium-${PV}-testdata.tar.xz
https://chromium-fonts.storage.googleapis.com/${TEST_FONT}
	-> chromium-${PV%%\.*}-testfonts.tar.gz
	)
"
if [[ -n "${V8_PV}" ]] ; then
	SRC_URI+="
https://github.com/v8/v8/archive/refs/tags/${V8_PV}.tar.gz
	-> v8-${V8_PV}.tar.gz
	"
fi
if [[ "${ALLOW_SYSTEM_TOOLCHAIN}" == "1" ]] ; then
	SRC_URI+="
		system-toolchain? (
https://gitlab.com/Matt.Jolly/chromium-patches/-/archive/${PATCH_VER}/chromium-patches-${PATCH_VER}.tar.bz2
		)
	"
fi
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
	chromium-$(ver_cut 1-3 ${PV}).x.html
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
# See https://github.com/chromium/chromium/blob/140.0.7339.127/media/gpu/args.gni#L24
#
# Using the system-ffmpeg or system-icu breaks cfi-icall or cfi-cast which is
#   incompatible as a shared lib.
#
# The suid is built by default upstream but not necessarily used:  \
#   https://github.com/chromium/chromium/blob/140.0.7339.127/sandbox/linux/BUILD.gn
#
CPU_FLAGS_ARM=(
	aes
	armv4
	armv6
	bf16
	bti
	crc32
	dotprod
	edsp
	fp16
	i8mm
	neon
	mte
	neon
	pac
	sme
	sve
	sve_256
	sve2
	sve2_128
	thumb
)
CPU_FLAGS_LOONG=(
	lsx
	lasx
)
CPU_FLAGS_MIPS=(
	dsp
	dspr2
	msa
)
CPU_FLAGS_PPC=(
	altivec
	crypto
	power8-vector
	power9-vector
	power10-vector
	vsx
	vsx3
)
CPU_FLAGS_RISCV=(
	rvv
)
CPU_FLAGS_S390=(
	z15
	z16
)
CPU_FLAGS_X86=(
	3dnow
	aes
	amx-int8
	amx-tile
	avx
	avx2
	avx512bitalg
	avx512bf16
	avx512bw
	avx512cd
	avx512dq
	avx512f
	avx512fp16
	avx512vbmi
	avx512vbmi2
	avx512vl
	avx512vnni
	avx512vpopcntdq
	avxvnni
	avxvnniint8
	bmi
	bmi2
	f16c
	fma
	gfni
	mmx
	pclmul
	popcnt
	sse
	sse2
	sse3
	sse4_1
	sse4_2
	ssse3
	vaes
	vpclmulqdq
)
IUSE_LIBCXX=(
	bundled-libcxx
	system-libstdcxx
)
# CFI Basic (.a) mode requires all third party modules built as static.

# Option defaults based on patent status
IUSE_CODECS=(
	+dav1d
	+libaom
	-openh264
	+opus
	-vaapi
	-vaapi-hevc
	+vorbis
	+vpx
)

# Upstream uses official ON
# Upstream uses proprietary codecs ON

# Most option defaults are based on build files.
IUSE+="
${CPU_FLAGS_ARM[@]/#/cpu_flags_arm_}
${CPU_FLAGS_LOONG[@]/#/cpu_flags_loong_}
${CPU_FLAGS_MIPS[@]/#/cpu_flags_mips_}
${CPU_FLAGS_PPC[@]/#/cpu_flags_ppc_}
${CPU_FLAGS_RISCV[@]/#/cpu_flags_riscv_}
${CPU_FLAGS_S390[@]/#/cpu_flags_s390_}
${CPU_FLAGS_X86[@]/#/cpu_flags_x86_}
${IUSE_CODECS[@]}
${IUSE_LIBCXX[@]}
${PATENT_STATUS[@]}
+accessibility bindist bluetooth +bundled-libcxx +cfi -cet +cups +css-hyphen
-debug -drumbrake +encode +extensions ffmpeg-chromium firejail -gtk4 -gwp-asan
-hangouts -headless +hidpi +jit +js-type-check +kerberos +mdns +miracleptr mold +mpris
-official +partitionalloc pax-kernel +pdf pic +pgo +plugins
+pre-check-vaapi +pulseaudio +reporting-api qt6 +rar +screencast selinux
-system-dav1d +system-ffmpeg -system-flac -system-fontconfig -system-freetype
-system-harfbuzz -system-icu -system-libaom -system-libjpeg-turbo -system-libpng
-system-libwebp -system-libxml -system-libxslt -system-openh264 -system-opus
-system-re2 -system-zlib +system-zstd systemd test +wayland +webassembly
-widevine +X
ebuild_revision_18
"
if [[ "${ALLOW_SYSTEM_TOOLCHAIN}" == "1" ]] ; then
	IUSE+="
		${LLVM_COMPAT[@]/#/llvm_slot_}
		-system-toolchain
	"
fi

# What is considered a proprietary codec can be found at:
#
#   https://github.com/chromium/chromium/blob/140.0.7339.127/media/filters/BUILD.gn#L160
#   https://github.com/chromium/chromium/blob/140.0.7339.127/media/media_options.gni#L38
#   https://github.com/chromium/chromium/blob/140.0.7339.127/media/base/supported_types.cc#L203
#   https://github.com/chromium/chromium/blob/140.0.7339.127/media/base/supported_types.cc#L284
#
# Codec upstream default:
#   https://github.com/chromium/chromium/blob/140.0.7339.127/tools/mb/mb_config_expectations/chromium.linux.json#L89
#

#
# For cfi-vcall, cfi-icall defaults status, see \
#   https://github.com/chromium/chromium/blob/140.0.7339.127/build/config/sanitizers/sanitizers.gni
# For cfi-cast default status, see \
#   https://github.com/chromium/chromium/blob/140.0.7339.127/build/config/sanitizers/sanitizers.gni#L123
# For pgo default status, see \
#   https://github.com/chromium/chromium/blob/140.0.7339.127/build/config/compiler/pgo/pgo.gni#L15
# For libcxx default, see \
#   https://github.com/chromium/chromium/blob/140.0.7339.127/build/config/c++/c++.gni#L14
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

#
# The ffmpeg-chromium ebuild enables aac,h264 unconditionally which the patents have not expired.
#
PATENT_USE_FLAGS="
	!patent_status_nonfree? (
		!official
		!system-openh264
		!vaapi
		!vaapi-hevc
	)
	!patent_status_sponsored_ncp_nb? (
		!system-openh264? (
			!openh264
		)
	)
	ffmpeg-chromium? (
		patent_status_nonfree
	)
	official? (
		patent_status_nonfree
	)
	openh264? (
		!system-openh264? (
			patent_status_sponsored_ncp_nb
		)
		patent_status_sponsored_ncp_nb? (
			!system-openh264
		)
		system-openh264? (
			patent_status_nonfree
		)
	)
	vaapi? (
		patent_status_nonfree
	)
	vaapi-hevc? (
		patent_status_nonfree
	)
	widevine? (
		patent_status_nonfree
	)
"

# Unconditionals
# Retesting disablement
DISTRO_REQUIRE_USE="
	-system-harfbuzz
	system-flac
	system-fontconfig
	system-freetype
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
#  ( sys-devel/rust:${LLVM_OFFICIAL_SLOT}  || sys-devel/rust-bin:${LLVM_OFFICIAL_SLOT} ) && llvm-core/clang:${LLVM_OFFICIAL_SLOT} && llvm-core/llvm:${LLVM_OFFICIAL_SLOT}.
#
# The community prefers only stable versioning.
#
# Upstream uses a customized build where they do not align.  For 128.x.x.x
# release it should be
#
#   dev-lang/rust-cr:${RUST_CR_PV%%.*}-${PV%%.*} && llvm-core/clang:${LLVM_OFFICIAL_SLOT} && llvm-core/llvm:${LLVM_OFFICIAL_SLOT}.
#
# The rust-cr build is actually an older snapshot of 1.79.x that submodules llvm 18.
# The official slot discussed here is llvm 19.  Hypothetical rust-cr, needs to be
# built and link against llvm 19.
#
# We will not consider rust-cr file situation for now because the env file situation.
#
#	extensions
#	!partitionalloc
#
# Dawn needs partition alloc
#ERROR Unresolved dependencies.
#//third_party/dawn/src/dawn/partition_alloc:partition_alloc(//build/toolchain/linux:clang_x64)
#  needs //base/allocator/partition_allocator:partition_alloc(//build/toolchain/linux:clang_x64)
#
if [[ "${ALLOW_SYSTEM_TOOLCHAIN}" == "1" ]] ;then
	REQUIRED_USE+="
		official? (
			llvm_slot_21
		)
		system-toolchain? (
			bundled-libcxx
		)
	"
fi
# Drumbrake is broken in this release and off by default.
REQUIRED_USE+="
	${PATENT_USE_FLAGS}
	!drumbrake
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
	partitionalloc
	amd64? (
		cpu_flags_x86_sse2
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
	bindist? (
		!system-ffmpeg
	)

	cpu_flags_ppc_power8-vector? (
		cpu_flags_ppc_altivec
		cpu_flags_ppc_crypto
	)
	cpu_flags_ppc_power9-vector? (
		cpu_flags_ppc_power8-vector
	)
	cpu_flags_ppc_power10-vector? (
		cpu_flags_ppc_power9-vector
	)
	cpu_flags_ppc_vsx3? (
		cpu_flags_ppc_vsx
	)

	cpu_flags_x86_3dnow? (
		cpu_flags_x86_mmx
	)

	cpu_flags_x86_sse? (
		cpu_flags_x86_mmx
	)
	cpu_flags_x86_sse2? (
		cpu_flags_x86_sse
	)
	cpu_flags_x86_sse3? (
		cpu_flags_x86_sse2
	)
	cpu_flags_x86_ssse3? (
		cpu_flags_x86_sse3
	)
	cpu_flags_x86_aes? (
		cpu_flags_x86_pclmul
	)
	cpu_flags_x86_sse4_1? (
		cpu_flags_x86_ssse3
	)
	cpu_flags_x86_sse4_2? (
		cpu_flags_x86_sse4_1
	)

	cpu_flags_x86_bmi? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_bmi2? (
		cpu_flags_x86_bmi
	)

	cpu_flags_x86_pclmul? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_f16c? (
		cpu_flags_x86_avx
	)
	cpu_flags_x86_popcnt? (
		cpu_flags_x86_sse4_2
	)

	cpu_flags_x86_avx? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_fma? (
		cpu_flags_x86_avx
	)
	cpu_flags_x86_avx2? (
		cpu_flags_x86_avx
		cpu_flags_x86_f16c
		cpu_flags_x86_fma
	)

	cpu_flags_x86_avx512f? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512cd
	)
	cpu_flags_x86_avx512cd? (
		cpu_flags_x86_avx512f
	)
	cpu_flags_x86_avx512bw? (
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512dq? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512vl? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512dq
	)

	cpu_flags_x86_avx512vnni? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_f16c
	)

	cpu_flags_x86_avx512bf16? (
		cpu_flags_x86_avx512vnni
	)

	cpu_flags_x86_vpclmulqdq? (
		cpu_flags_x86_avx2
		cpu_flags_x86_vaes
	)
	cpu_flags_x86_vaes? (
		cpu_flags_x86_aes
		cpu_flags_x86_vpclmulqdq
	)
	cpu_flags_x86_avx512vbmi? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_f16c
		cpu_flags_x86_vpclmulqdq
	)

	cpu_flags_x86_avx512vbmi2? (
		cpu_flags_x86_avx512bitalg
		cpu_flags_x86_avx512vbmi
		cpu_flags_x86_avx512vnni
		cpu_flags_x86_avx512vpopcntdq
	)
	cpu_flags_x86_avx512bitalg? (
		cpu_flags_x86_avx512vbmi2
		cpu_flags_x86_avx512vnni
		cpu_flags_x86_avx512vpopcntdq
	)
	cpu_flags_x86_avx512vpopcntdq? (
		cpu_flags_x86_avx512bitalg
		cpu_flags_x86_avx512vbmi2
		cpu_flags_x86_avx512vnni
	)
	cpu_flags_x86_gfni? (
		cpu_flags_x86_avx512bitalg
		cpu_flags_x86_avx512vbmi2
		cpu_flags_x86_avx512vnni
		cpu_flags_x86_avx512vpopcntdq
	)


	cpu_flags_x86_avx512fp16? (
		cpu_flags_x86_avx512vbmi2
		cpu_flags_x86_avx512bf16
	)

	cpu_flags_x86_amx-tile? (
		cpu_flags_x86_amx-int8
		cpu_flags_x86_avx512fp16
	)

	cpu_flags_x86_amx-int8? (
		cpu_flags_x86_amx-tile
		cpu_flags_x86_avx512fp16
	)
	cpu_flags_x86_avxvnni? (
		cpu_flags_x86_aes
		cpu_flags_x86_bmi2
		cpu_flags_x86_f16c
		cpu_flags_x86_fma
		cpu_flags_x86_vaes
	)

	cups? (
		pdf
	)
	drumbrake? (
		webassembly
	)
	ffmpeg-chromium? (
		bindist
	)
	miracleptr? (
		partitionalloc
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
		mdns
		miracleptr
		mpris
		openh264
		opus
		partitionalloc
		pdf
		pgo
		plugins
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
	# USE=pgo is default ON in Cromite but dropped for user choice.
	# USE=official is default ON in Cromite, but this ebuild reserves it
	# for authentic Chromium.
	#
	# The rest are the same defaults as the patchset.
	#
	# The reason that these USE flags are forced to match the patchset
	# defaults is because I don't know if these were pruned by the scripts.
	#
	# The patchset build scripts say ffmpeg_branding="Chrome" which enables aac.
	#
	REQUIRED_USE+="
		!patent_status_nonfree? (
			!cromite
		)
		cromite? (
			amd64
			patent_status_nonfree
			dav1d
			pdf
			plugins
			!css-hyphen
			!hangouts
			!official
			!openh264
			!mdns
			!reporting-api
			!widevine
		)
		official? (
			!cromite
		)
	"
	if [[ "${ALLOW_SYSTEM_TOOLCHAIN}" == "1" ]] ;then
		REQUIRED_USE+="
			cromite? (
				!system-toolchain
			)
		"
	fi
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
			!pgo
			!reporting-api
		)
		official? (
			!ungoogled-chromium
		)
	"
fi

if [[ "${UNGOOGLED_CHROMIUM_PV%-*}" == "${PV}" ]] && is_cromite_compatible ; then
	REQUIRED_USE+="
		?? (
			cromite
			ungoogled-chromium
		)
	"
fi

LIBVA_DEPEND="
	vaapi? (
		>=media-libs/libva-${LIBVA_PV}[${MULTILIB_USEDEP},drm(+),wayland?,X?]
		media-libs/libva:=
		media-libs/vaapi-drivers[${MULTILIB_USEDEP},patent_status_nonfree=]
		system-ffmpeg? (
			media-video/ffmpeg:${FFMPEG_SLOT}[${MULTILIB_USEDEP},patent_status_nonfree=,vaapi]
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
					=llvm-runtimes/compiler-rt-sanitizers-${s}*[${MULTILIB_USEDEP},cfi]
					llvm-runtimes/compiler-rt-sanitizers:=
				)
			)
			=llvm-runtimes/compiler-rt-${s}*
			llvm-runtimes/compiler-rt:=
			=llvm-runtimes/clang-runtime-${s}*[${MULTILIB_USEDEP},compiler-rt,sanitize]
			llvm-core/clang:${s}[${MULTILIB_USEDEP}]
			llvm-core/lld:${s}
			llvm-core/llvm:${s}[${MULTILIB_USEDEP}]
			pgo? (
				=llvm-runtimes/compiler-rt-sanitizers-${s}*[${MULTILIB_USEDEP},profile]
				llvm-runtimes/compiler-rt-sanitizers:=
			)
			official? (
				amd64? (
					=llvm-runtimes/compiler-rt-sanitizers-${s}*[${MULTILIB_USEDEP},cfi,profile]
					llvm-runtimes/compiler-rt-sanitizers:=
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
	patent_status_nonfree? (
		system-openh264? (
			>=media-libs/openh264-2.6.0[${MULTILIB_USEDEP}]
			media-libs/openh264:=
		)
	)
	system-dav1d? (
		>=media-libs/dav1d-1.5.1[${MULTILIB_USEDEP},8bit]
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
		>=media-libs/harfbuzz-11.0.0:0[${MULTILIB_USEDEP},icu(-)]
		media-libs/harfbuzz:=
	)
	system-icu? (
		>=dev-libs/icu-74.2[${MULTILIB_USEDEP}]
		dev-libs/icu:=
	)
	system-libaom? (
		>=media-libs/libaom-3.12.1[${MULTILIB_USEDEP}]
		media-libs/libaom:=
	)
	system-libjpeg-turbo? (
		>=media-libs/libjpeg-turbo-3.1.0[${MULTILIB_USEDEP}]
		media-libs/libjpeg-turbo:=
	)
	system-libpng? (
		>=media-libs/libpng-1.6.43[${MULTILIB_USEDEP},-apng]
		media-libs/libpng:=
	)
	system-libwebp? (
		>=media-libs/libwebp-1.5.0[${MULTILIB_USEDEP}]
		media-libs/libwebp:=
	)
	system-libxml? (
		>=dev-libs/libxml2-2.14.2[${MULTILIB_USEDEP},icu]
		dev-libs/libxml2:=
	)
	system-libxslt? (
		>=dev-libs/libxslt-1.1.44[${MULTILIB_USEDEP}]
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
		>=app-arch/zstd-1.5.7[${MULTILIB_USEDEP}]
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

# The libva and others are removed to prevent inadvertant encoding to nonfree
# formats due to package/drivers not selectively dropping codecs like the mesa
# package.
PATENT_STATUS_DEPEND="
	!patent_status_nonfree? (
		!media-video/ffmpeg-chromium
	)
	system-ffmpeg? (
		>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP},patent_status_nonfree=]
		patent_status_nonfree? (
			media-video/ffmpeg:${FFMPEG_SLOT}[${MULTILIB_USEDEP},encode?,opus?,patent_status_nonfree,vorbis?,vpx?]
		)
		!patent_status_nonfree? (
			media-video/ffmpeg:${FFMPEG_SLOT}[${MULTILIB_USEDEP},-amf,-cuda,encode?,-fdk,-kvazaar,-mmal,-nvdec,-nvenc,-openh264,opus?,-patent_status_nonfree,-qsv,-vaapi,-vdpau,vorbis?,-vulkan,vpx?,-vulkan,-x264,-x265]
		)
	)
"
COMMON_DEPEND="
	${PATENT_STATUS_DEPEND}
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
	elibc_glibc? (
		>=sys-libs/glibc-2.31
	)
	system-ffmpeg? (
		system-opus? (
			>=media-libs/opus-1.4[${MULTILIB_USEDEP}]
			media-libs/opus:=
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

if [[ "${ALLOW_SYSTEM_TOOLCHAIN}" == "1" ]] ; then
	RDEPEND+="
		${CLANG_RDEPEND}
	"
fi

RDEPEND+="
	${COMMON_DEPEND}
	sys-kernel/mitigate-id
	virtual/ttf-fonts
	virtual/patent-status[patent_status_nonfree=,patent_status_sponsored_ncp_nb=]
	!headless? (
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
	llvm_slot_21? (
		|| (
			=dev-lang/rust-9999
			=dev-lang/rust-bin-9999
		)
	)
	|| (
		dev-lang/rust:=
		dev-lang/rust-bin:=
	)
"
if [[ "${ALLOW_SYSTEM_TOOLCHAIN}" == "1" ]] ; then
	BDEPEND+="
		${CLANG_BDEPEND}
		>=net-libs/nodejs-22.11.0:${NODE_VERSION%%.*}[inspector]
		app-eselect/eselect-nodejs
	"
fi
# Upstream uses live rust.  Rust version is relaxed.
# Mold was relicensed as MIT in 2.0.  >=2.0 was used to avoid legal issues.
BDEPEND+="
	$(python_gen_any_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
	${COMMON_SNAPSHOT_DEPEND}
	${PYTHON_DEPS}
	app-alternatives/ninja
	dev-util/patchutils
	www-client/chromium-sources:0/${PV}
	www-client/chromium-toolchain:0/${PV%.*}.x
	>=app-arch/gzip-1.7
	>=dev-util/gperf-3.2
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	>=sys-devel/bison-2.4.3
	app-alternatives/lex
	dev-lang/perl
	dev-vcs/git
	mold? (
		>=sys-devel/mold-2.38
	)
	vaapi? (
		media-video/libva-utils
	)
"
if [[ "${ALLOW_SYSTEM_TOOLCHAIN}" == "1" ]] ; then
	BDEPEND+="
		system-toolchain? (
			${RUST_BDEPEND}
			>=dev-util/bindgen-0.68.0
		)
	"
fi

# Upstream uses llvm:16
# When CFI + PGO + official was tested, it didn't work well with LLVM12.  Error noted in
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/f0c13049dc89f068370511b4664f7fb111df2d3a/www-client/chromium/bug_notes
# This is why LLVM13 was set as the minimum and did fix the problem.

# For the current llvm for this project, see
#   https://github.com/chromium/chromium/blob/140.0.7339.127/tools/clang/scripts/update.py#L42
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

_use_system_toolchain() {
	if [[ "${ALLOW_SYSTEM_TOOLCHAIN}" == "1" ]] && use system-toolchain ; then
		return 0
	else
		return 1
	fi
}

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
	# https://github.com/chromium/chromium/blob/140.0.7339.127/docs/linux/build_instructions.md#system-requirements
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
	echo "${olast}"
}

pkg_pretend() {
	pre_build_checks
	if [[ "${MERGE_TYPE}" != "binary" ]]; then
	# The pre_build_checks are all about compilation resources, no need to
	# run it for a binpkg
		pre_build_checks
	fi

	if use headless ; then
		local headless_unused_flags=(
			"cups"
			"kerberos"
			"pulseaudio"
			"qt6"
			"vaapi"
			"wayland"
		)
		local myiuse
		for myiuse in ${headless_unused_flags[@]}; do
			if use ${myiuse} ; then
ewarn "Ignoring USE=${myiuse}.  USE=headless is set."
			fi
		done
	fi
	if ! use bindist && use ffmpeg-chromium ; then
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

# Grabs the INSTR_PROF_INDEX_VERSION which is the same as the current ProfVersion for the PGO file format version.
# https://github.com/llvm/llvm-project/blob/7b473dfe/compiler-rt/include/profile/InstrProfData.inc#L713
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
		( ! has_version "~llvm-core/llvm-${compatible_pv}" ) && continue
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
eerror "Missing the llvm-core/llvm version (aka found_ver)"
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
	which node 2>&1 >/dev/null || die "Missing Node.js ${NODE_VERSION%%.*}"
	local node_pv=$(node --version | sed -e "s|v||g")
	if ver_test "${node_pv%%.*}" -ne "${NODE_VERSION%%.*}" ; then
eerror
eerror "Node.js must be installed and selected.  To switch, do"
eerror
eerror "  eselect nodejs set node${NODE_VERSION%%.*}"
eerror
eerror "Expected version:  ${NODE_VERSION}"
eerror "Actual version:    ${node_pv}"
eerror
		die
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
ewarn "This ebuild is under development and the non-production version.  Use ${PV} (without -r1) instead."
ewarn
ewarn "This ebuild is under maintenance."
ewarn "This ebuild may fail to build/link."
ewarn "Dav1d may fail to link."
ewarn "Do one of the following until it is fixed..."
ewarn "(1) disable the dav1d USE flag"
ewarn "(2) use the system-dav1d USE flag"
ewarn "(3) use the distro ebuild"
ewarn "(4) use the prebuilt ebuild"
ewarn
	dhms_start
	check-compiler-switch_start
	# The emerge package system will over prune when it should not when it
	# uses the mv merge technique with sandbox disabled.

	local tc_count_expected=4900
	local tc_count_actual=$(cat "/usr/share/chromium/toolchain/file-count")
	if (( ${tc_count_actual} != ${tc_count_expected} )) ; then
ewarn
ewarn "The emerge package system may have overpruned."
ewarn
ewarn "The chromium-toolchain file count is not the same.  Please re-emerge the chromium-toolchain package."
ewarn "Actual file count:  ${tc_count_actual}"
ewarn "Expected file count:  ${tc_count_expected}"
ewarn
	fi

	local sources_count_expected=538513
	local sources_count_actual=$(cat "/usr/share/chromium/sources/file-count")
	if (( ${sources_count_actual} != ${sources_count_expected} )) ; then
ewarn
ewarn "The emerge package system may have overpruned."
ewarn
ewarn "The chromium-sources file count is not the same.  Please re-emerge the chromium-sources package."
ewarn "Actual file count:  ${sources_count_actual}"
ewarn "Expected file count:  ${sources_count_expected}"
ewarn
	fi

einfo "Release channel:  ${SLOT#*/}"
	if [[ -n "${MITIGATION_URI}" ]] ; then
einfo "Security announcement date:  ${MITIGATION_DATE}"
einfo "Security fixes applied:  ${MITIGATION_URI}"
	fi
	vf_show
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
	export CPP=$(tc-getCPP)

	print_use_flags_using_clang
	if is_using_clang && ! tc-is-clang ; then
		export CC="clang"
		export CXX="clang++"
		export CPP="${CC} -E"
		strip-unsupported-flags
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
	if [[ "${ALLOW_SYSTEM_TOOLCHAIN}" == "1" ]] ; then
		node_pkg_setup
	fi
	check_security_expire
	check_ulimit

	if use official ; then
		CFLAGS_HARDENED_SSP_LEVEL="1"
	elif is-flagq "-fstack-protector" ; then
		CFLAGS_HARDENED_SSP_LEVEL="1"
	elif is-flagq "-fstack-protector-strong" ; then
		CFLAGS_HARDENED_SSP_LEVEL="2"
	elif is-flagq "-fstack-protector-all" ; then
		CFLAGS_HARDENED_SSP_LEVEL="3"
	fi
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

	if _use_system_toolchain ; then
		unpack "chromium-patches-${PATCH_VER}.tar.bz2"
	else
		rm -rf "${S}/third_party/llvm-build/Release+Asserts" || true
		mkdir -p "${S}/third_party/llvm-build"
		ln -s "/usr/share/chromium/toolchain/clang" "${S}/third_party/llvm-build/Release+Asserts" || die

		rm -rf "${S}/third_party/rust-toolchain" || true
		ln -s "/usr/share/chromium/toolchain/rust" "${S}/third_party/rust-toolchain" || die
	fi

	if use ppc64 ; then
		unpack "chromium-openpower-${PPC64_HASH:0:10}.tar.bz2"
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
		unpack "${P}-linux-testdata.tar.xz"
		# This just contains a bunch of font files that need to be unpacked (or moved) to the correct location.
		local testfonts_dir="${WORKDIR}/${P}/third_party/test_fonts"
		local testfonts_tar="${DISTDIR}/chromium-testfonts-${TEST_FONT:0:10}.tar.gz"
		tar xf "${testfonts_tar}" -C "${testfonts_dir}" || die "Failed to unpack testfonts"
	fi

	if [[ -n "${V8_PV}" ]] ; then
einfo "Updating V8 to ${V8_PV}"
		unpack "v8-${V8_PV}.tar.gz"
		rm -rf "${S}/v8" || die
		mv "${WORKDIR}/v8-${V8_PV}" "${S}/v8" || die
	fi
}

is_generating_credits() {
	if [[ "${GEN_ABOUT_CREDITS}" == "1" ]] ; then
		return 0
	else
		return 1
	fi
}

apply_distro_patchset_for_system_toolchain() {
	# We don't need toolchain patches if we're using the official toolchain.
	shopt -s globstar nullglob

	# 130: moved the PPC64 patches into the chromium-patches repo
	local patch
	for patch in "${WORKDIR}/chromium-patches-${PATCH_VER}/"**"/"*".patch" ; do
		if [[ ${patch} == *"ppc64le"* ]]; then
			use ppc64 && PATCHES+=( "${patch}" )
		else
			PATCHES+=( "${patch}" )
		fi
	done

	shopt -u globstar nullglob

	remove_compiler_builtins

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

	if use ppc64 ; then
		local patchset_dir="${WORKDIR}/openpower-patches-${PPC64_HASH}/patches"
	# The patch causes build errors on 4K page systems (https://bugs.gentoo.org/show_bug.cgi?id=940304)
		local page_size_patch="ppc64le/third_party/use-sysconf-page-size-on-ppc64.patch"
		local isa_3_patch="ppc64le/core/baseline-isa-3-0.patch"
	# Apply the OpenPOWER patches (check for page size and isa 3.0)
		openpower_patches=(
			$(grep -E "^ppc64le|^upstream" "${patchset_dir}/series" \
				| grep -v "${page_size_patch}" \
				| grep -v "${isa_3_patch}" \
				|| die) \
			)
		local patch
		for patch in "${openpower_patches[@]}"; do
			PATCHES+=(
				"${patchset_dir}/${patch}"
			)
		done
		if [[ $(getconf PAGESIZE) == "65536" ]]; then
			PATCHES+=(
				"${patchset_dir}/${page_size_patch}"
			)
		fi

	# We use vsx3 as a proxy for 'want isa3.0' (POWER9)
		if use cpu_flags_ppc_vsx3 ; then
			PATCHES+=(
				"${patchset_dir}/${isa_3_patch}"
			)
		fi
	fi

	# Oxidised hacks, let's keep 'em all in one place
	# This is a nightly option that does not exist in older releases
	# https://github.com/rust-lang/rust/commit/389a399a501a626ebf891ae0bb076c25e325ae64
	if ver_test ${RUST_SLOT} -lt "1.83.0" ; then
		sed '/rustflags = \[ "-Zdefault-visibility=hidden" \]/d' -i build/config/gcc/BUILD.gn ||
			die "Failed to remove default visibility nightly option"
	fi

	# Upstream Rust replaced adler with adler2, for older versions of Rust
	# we still need to tell GN that we have the older lib when it tries to
	# copy the Rust sysroot into the bulid directory.
	if ver_test ${RUST_SLOT} -lt "1.86.0" ; then
		sed -i 's/adler2/adler/' "build/rust/std/BUILD.gn" \
			|| die "Failed to tell GN that we have adler and not adler2"
	fi

	if ver_test ${RUST_SLOT} -lt "1.89.0"; then
	# The rust allocator was changed in 1.89.0, so we need to patch sources for older versions
		PATCHES+=(
			"${FILESDIR}/chromium-140-__rust_no_alloc_shim_is_unstable.patch"
		)
	fi
}

apply_distro_patchset() {
einfo "Applying the distro patchset ..."
	PATCHES+=(
		"${FILESDIR}/chromium-cross-compile.patch"
		$(use system-zlib && echo "${FILESDIR}/chromium-109-system-zlib.patch")
		"${FILESDIR}/chromium-111-InkDropHost-crash.patch"
		"${FILESDIR}/chromium-131-unbundle-icu-target.patch"
		"${FILESDIR}/chromium-134-bindgen-custom-toolchain.patch"
		"${FILESDIR}/chromium-135-oauth2-client-switches.patch"
		"${FILESDIR}/chromium-135-map_droppable-glibc.patch"
		"${FILESDIR}/chromium-138-nodejs-version-check.patch"
	)

	# https://issues.chromium.org/issues/442698344
	# Unreleased fontconfig changed magic numbers and google have rolled to this version
	if has_version "<=media-libs/fontconfig-2.17.1" ; then
		PATCHES+=(
			"${FILESDIR}/chromium-140-work-with-old-fontconfig-again.patch"
		)
	fi

	if _use_system_toolchain ; then
		apply_distro_patchset_for_system_toolchain
	fi
}

apply_oiledmachine_overlay_patchset() {
einfo "Applying the oiledmachine-overlay patchset ..."
	if _use_system_toolchain && tc-is-clang ; then
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
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.92-zlib-optionalize-simd.patch"
		"${FILESDIR}/extra-patches/${PN}-133.0.6943.53-disable-speech.patch"
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.59-use-memory-tagging.patch"
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.59-highway-optionalize-simd.patch"
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.59-simd-defaults.patch"
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.59-build-config-compiler-optionalize-simd.patch"
		"${FILESDIR}/extra-patches/${PN}-137.0.7151.68-libaom-optionalize-simd.patch"
		"${FILESDIR}/extra-patches/${PN}-137.0.7151.68-libvpx-optionalize-simd.patch"
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.92-pdfium-optionalize-simd.patch"
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.92-skia-optionalize-simd.patch"
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.92-perfetto-optionalize-simd.patch"
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.92-ruy-optionalize-simd.patch"
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.92-webrtc-optionalize-simd.patch"
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.92-dav1d-optionalize-simd.patch"
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.92-dav1d-pic.patch"
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.92-libjpeg-turbo-optionalize-simd.patch"
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.92-opus-optionalize-simd.patch"
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.92-libwebp-optionalize-simd.patch"
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.92-fuzztest-optionalize-simd.patch"
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.92-crc32c-optionalize-simd.patch"
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.92-blink-optionalize-simd.patch"
		"${FILESDIR}/extra-patches/${PN}-137.0.7151.68-lzma_sdk-optionalize-simd.patch"
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.92-libyuv-optionalize-simd.patch"
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.92-cpuinfo-optionalize-simd.patch"
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.92-opus-inline.patch"
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.92-sanitizers-build-config.patch"
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.92-linker-warn-missing-symbols.patch"
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
			"${FILESDIR}/extra-patches/${PN}-130.0.6723.91-mold.patch"
		)
	fi

	if is-flagq '-Ofast' || is-flagq '-ffast-math' ; then
		PATCHES+=(
			"${FILESDIR}/extra-patches/${PN}-114.0.5735.133-fast-math.patch"
		)
	fi

	if _use_system_toolchain ; then
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
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.92-custom-optimization-level.patch"
		"${FILESDIR}/extra-patches/${PN}-136.0.7103.92-hardening.patch"
		"${FILESDIR}/extra-patches/v8-13.7.152.13-custom-optimization-level.patch"			# Patch for the original version in the Chromium tarball.  Different v8 versions needs forward port.
	)

	if ! use official ; then
	# This section contains significant changes.  The above sections contains minor changes.

		PATCHES+=(
	# FIXME: update perfetto disable patch
	#		"${FILESDIR}/extra-patches/${PN}-128.0.6613.137-disable-perfetto.patch"
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
				"${FILESDIR}/extra-patches/${PN}-133.0.6943.53-partitionalloc-false.patch"
			)
		fi
	fi

	# For v8 13.6.233.8
#	if ( use webassembly || use drumbrake ) && ( [[ -z "${V8_PV}" ]] || ver_test "${V8_PV}" -eq "13.6.233.8" ) ; then
#		PATCHES+=(
#			"${FILESDIR}/extra-patches/${PN}-136.0.7103.59-v8-5c595ad.patch"
#		)
#	fi
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
			-e "/is_debug=false/d" \
			-e "/is_debug = true/d" \
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

prepare_cromite_with_ungoogled_chromium() {
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
#		cromite_patch;ungoogle_chromium_patch
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
			local x="${cromite_patch}"
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
eerror "         Cromite patch:  ${cromite_patch}"
eerror "ungoogle-chromium patch:  ${ungoogle_chromium_patch}"
eerror
			die
		fi
	done

}

remove_compiler_builtins() {
	# We can't use the bundled compiler builtins with the system toolchain
	# We used to `grep` then `sed`, but it was indirect. Combining the two into a single
	# `awk` command is more efficient and lets us document the logic more clearly.

	local pattern='    configs += [ "//build/config/clang:compiler_builtins" ]'
	local target='build/config/compiler/BUILD.gn'

	local tmpfile
	tmpfile=$(mktemp) || die "Failed to create temporary file."

	if awk -v pat="${pattern}" '
	BEGIN {
		match_found = 0
	}

	# If the delete countdown is active, decrement it and skip to the next line.
	d > 0 { d--; next }

	# If the current line matches the pattern...
	$0 == pat {
		match_found = 1   # ...set our flag to true.
		d = 2             # Set delete counter for this line and the next two.
		prev = ""         # Clear the buffered previous line so it is not printed.
		next
	}

	# For any other line, print the buffered previous line.
	NR > 1 { print prev }

	# Buffer the current line to be printed on the next cycle.
	{ prev = $0 }

	END {
		# Print the last line if it was not part of a deleted block.
		if (d == 0) { print prev }

		# If the pattern was never found, exit with a failure code.
		if (match_found == 0) {
		exit 1
		}
	}
	' "${target}" > "${tmpfile}"; then
		# AWK SUCCEEDED (exit code 0): The pattern was found and edited.
		# This is to avoid gawk's `-i inplace` option which users complain about.
		mv "${tmpfile}" "${target}"
	else
		# AWK FAILED (exit code 1): The pattern was not found.
		rm -f "${tmpfile}"
		die "Awk patch failed: Pattern not found in ${target}."
	fi
}

src_prepare() {
	# Calling this here supports resumption via FEATURES=keepwork
	python-any-r1_pkg_setup

	check_deps_cfi_cross_dso

	local PATCHES=()


	if has ungoogled-chromium ${IUSE_EFFECTIVE} && use ungoogled-chromium && has cromite ${IUSE_EFFECTIVE} && use cromite ; then
		prepare_cromite_with_ungoogled_chromium
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

#	if [[ "${APPLY_OILEDMACHINE_OVERLAY_PATCHSET:-1}" == "1" ]] ; then
#		apply_oiledmachine_overlay_patchset
#	else
#ewarn "The oiledmachine-overlay patchset is not ready.  Skipping."
#	fi

	default

	if [[ -e "${S}/tools/slice_string.py" ]] ; then
		chmod +x "${S}/tools/slice_string.py" || die
	fi

	if (( ${#PATCHES[@]} > 0 )) || [[ -f "${T}/epatch_user.log" ]] ; then
		if use official ; then
ewarn "The use of unofficial patches is not endorsed upstream."
		fi

		if use pgo ; then
ewarn "The use of patching can interfere with the pregenerated PGO profile."
		fi
	fi

	if [[ "${LLVM_SLOT}" == "19" ]]; then
	# Upstream now hard depends on a feature that was added in LLVM 20.1,
	# but we don't want to stabilise that yet.
	# Do the temp file shuffle in case someone is using something other than
	# `gawk`
		{
			awk '/config\("clang_warning_suppression"\) \{/	{ print $0 " }"; sub(/clang/, "xclang"); print; next }
				{ print }' "build/config/compiler/BUILD.gn" \
				> \
				"${T}/build.gn" \
				&& \
			mv \
				"${T}/build.gn" \
				"build/config/compiler/BUILD.gn"
		} || die "Unable to disable warning suppression"
	fi

	# Not included in -lite tarballs, but we should check for it anyway.
	if [[ -f "third_party/node/linux/node-linux-x64/bin/node" ]]; then
		rm "third_party/node/linux/node-linux-x64/bin/node" || die
	else
		mkdir -p "third_party/node/linux/node-linux-x64/bin" || die
	fi
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
	# Since M137 atomic is required; we could probably unbundle this as a target of opportunity. \
		third_party/compiler-rt
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
		third_party/devtools-frontend/src/front_end/third_party/legacy-javascript
		third_party/devtools-frontend/src/front_end/third_party/lighthouse
		third_party/devtools-frontend/src/front_end/third_party/lit
		third_party/devtools-frontend/src/front_end/third_party/marked
		third_party/devtools-frontend/src/front_end/third_party/puppeteer
		third_party/devtools-frontend/src/front_end/third_party/puppeteer/package/lib/esm/third_party/mitt
		third_party/devtools-frontend/src/front_end/third_party/puppeteer/package/lib/esm/third_party/parsel-js
		third_party/devtools-frontend/src/front_end/third_party/puppeteer/package/lib/esm/third_party/rxjs
		third_party/devtools-frontend/src/front_end/third_party/source-map-scopes-codec
		third_party/devtools-frontend/src/front_end/third_party/third-party-web
		third_party/devtools-frontend/src/front_end/third_party/vscode.web-custom-data
		third_party/devtools-frontend/src/front_end/third_party/wasmparser
		third_party/devtools-frontend/src/front_end/third_party/web-vitals
		third_party/devtools-frontend/src/third_party
		third_party/dom_distiller_js
		third_party/dragonbox
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
		third_party/khronos
		third_party/lens_server_proto
		third_party/leveldatabase
		third_party/libaddressinput
		#third_party/libc++ # We want the flexibility to one day use gcc again.  We do not want to be cornered into a particular license.
		third_party/libdrm
		third_party/libgav1
		third_party/libjingle
		third_party/libphonenumber
		third_party/libsecret
		third_party/libsrtp
		third_party/libsync
		third_party/libtess2/libtess2
		third_party/libtess2/src/Include
		third_party/libtess2/src/Source
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
		third_party/llvm-libc
		third_party/llvm-libc/src/shared/
		third_party/lottie
		third_party/lss
		third_party/lzma_sdk
		third_party/mako
		third_party/markupsafe
		third_party/material_color_utilities
		third_party/metrics_proto
		third_party/minigbm
		third_party/ml_dtypes
		third_party/modp_b64
		third_party/nasm
		third_party/nearby
		third_party/neon_2_sse
		third_party/node
		third_party/omnibox_proto
		third_party/one_euro_filter
		third_party/openscreen
		third_party/openscreen/src/third_party/
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
		third_party/protobuf/third_party/utf8_range
		third_party/pthreadpool
		third_party/puffin
		third_party/pyjson5
		third_party/pyyaml
		third_party/rapidhash
		third_party/readability
		third_party/rnnoise
		third_party/rust
		third_party/ruy
		third_party/s2cellid
		third_party/search_engines_data
		third_party/securemessage
		third_party/selenium-atoms
		third_party/sentencepiece
		third_party/sentencepiece/src/third_party/darts_clone
		third_party/shell-encryption
		third_party/simdutf
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
		third_party/tflite/src/third_party/fft2d
		third_party/tflite/src/third_party/xla/third_party/tsl
		third_party/tflite/src/third_party/xla/xla/tsl/framework
		third_party/tflite/src/third_party/xla/xla/tsl/lib/random
		third_party/tflite/src/third_party/xla/xla/tsl/platform
		third_party/tflite/src/third_party/xla/xla/tsl/protobuf
		third_party/tflite/src/third_party/xla/xla/tsl/util
		third_party/ukey2
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
		v8/third_party/siphash
		v8/third_party/utf8-decoder
		v8/third_party/glibc
		v8/third_party/inspector_protocol
		v8/third_party/rapidhash-v8
		v8/third_party/v8
		v8/third_party/valgrind

	# gyp -> gn leftovers
		third_party/speech-dispatcher
		third_party/usb_ids
		third_party/xdg-utils

	# Required in both cases
		third_party/ffmpeg

		$(use rar && echo "
			third_party/unrar
		")

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
			third_party/breakpad/breakpad/src/processor
			third_party/fuzztest
			third_party/google_benchmark/src/include/benchmark
			third_party/google_benchmark/src/src
			third_party/perfetto/protos/third_party/pprof
			third_party/test_fonts
			third_party/test_fonts/fontconfig
		")
	)

	if has cromite ${IUSE_EFFECTIVE} && use cromite ; then
		keeplibs+=(
			"cromite_flags/third_party"
	#		"third_party/cromite"
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
		if [[ ! -d "${lib}" ]] && ! has "${lib}" "${whitelist_libs[@]}" ; then
			not_found_libs+=( "${lib}" )
		fi
	done

	if (( ${#not_found_libs[@]} > 0 )) ; then
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

	if ! is_generating_credits ; then
		# Interferes with our bundled clang path; we don't want stripped binaries anyway.
		sed -i -e 's|${clang_base_path}/bin/llvm-strip|/bin/true|g' \
			-e 's|${clang_base_path}/bin/llvm-objcopy|/bin/true|g' \
			"build/linux/strip_binary.gni" || die
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
ewarn "  llvm-core/clang:16::oiledmachine-overlay"
ewarn "  llvm-core/clang:17::oiledmachine-overlay"
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
				if has_version "llvm-core/clang:${s}" ; then
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
			CPP="${CBUILD}-clang-${LLVM_SLOT} -E"
		else
			CPP="${CHOST}-clang-${LLVM_SLOT} -E"
		fi

		export AR="llvm-ar" # Required for LTO
		export NM="llvm-nm"
		export READELF="llvm-readelf"
		export STRIP="llvm-strip"
		if ! which llvm-ar 2>/dev/null 1>/dev/null ; then
			die "llvm-ar is unreachable"
		fi
		if has_version "=llvm-core/llvm-${LLVM_SLOT}.0.9999" ; then
			if \
				has_version "=llvm-core/llvm-${LLVM_SLOT}.0.9999[-fallback-commit]" \
					|| \
				has_version "=llvm-core/clang-${LLVM_SLOT}.0.9999[-fallback-commit]" \
					|| \
				has_version "=llvm-core/lld-${LLVM_SLOT}.0.9999[-fallback-commit]" \
					|| \
				has_version "=llvm-runtimes/compiler-rt-sanitizers-${LLVM_SLOT}.0.9999[-fallback-commit]" \
					|| \
				has_version "=llvm-runtimes/compiler-rt-${LLVM_SLOT}.0.9999[-fallback-commit]" \
					|| \
				has_version "=llvm-runtimes/clang-runtime-${LLVM_SLOT}.0.9999[-fallback-commit]" \
			; then
eerror
eerror "The fallback-commit USE flag is required."
eerror
eerror "emerge =llvm-core/llvm-${LLVM_SLOT}.0.0.9999[fallback-commit] \\"
eerror "       =llvm-core/clang-${LLVM_SLOT}.0.0.9999 \\"
eerror "       =llvm-core/lld-${LLVM_SLOT}.0.0.9999 \\"
eerror "       =llvm-runtimes/compiler-rt-sanitizers-${LLVM_SLOT}.0.0.9999 \\"
eerror "       =llvm-runtimes/compiler-rt-${LLVM_SLOT}.0.0.9999 \\"
eerror "       =llvm-runtimes/clang-runtime-${LLVM_SLOT}.0.0.9999"
eerror
				die
			fi
		fi

		# Get the stdatomic.h from clang not from gcc.
		append-cflags -stdlib=libc++
		append-ldflags -stdlib=libc++
		if ver_test "${LLVM_SLOT}" -ge "16" ; then
			append-cppflags "-isystem/usr/lib/clang/${LLVM_SLOT}/include"
			show_clang_header_warning "${LLVM_SLOT}"
		else
			local clang_pv=$(best_version "llvm-core/clang:${LLVM_SLOT}" \
				| sed -e "s|llvm-core/clang-||")
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
			CPP="${CBUILD}-gcc-${LLVM_SLOT} -E"
		else
			CPP="${CHOST}-gcc-${LLVM_SLOT} -E"
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
	if _use_system_toolchain ; then
		_set_system_cc
	else
		export PATH="${S}/third_party/llvm-build/Release+Asserts/bin:${PATH}"
		export PATH="${S}/third_party/rust-toolchain/bin:${PATH}"
		export CC="clang"
		export CXX="clang++"
		export CPP="${CC} -E"
		export AR="llvm-ar"
		export NM="llvm-nm"
		export OBJCOPY="llvm-objcopy"
		export OBJDUMP="llvm-objdump"
		export READELF="llvm-readelf"
		export STRIP="llvm-strip"
		LLVM_SLOT=$(clang-major-version)
		[[ "${LLVM_OFFICIAL_SLOT}" != "${LLVM_SLOT}" ]] && die "Fix LLVM_OFFICIAL_SLOT"
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

_configure_compiler_common() {
	if _use_system_toolchain ; then
		_configure_system_toolchain
	else
einfo "Using the bundled toolchain"
		myconf_gn+=(
			"is_clang=true"
		)
	fi

	check-compiler-switch_end

	# Strip incompatable linker flags
	strip-unsupported-flags

	# Handled by the build scripts
	filter-flags '-f*visibility*'

	# Avoid CFLAGS problems, bug #352457, bug #390147.
	if ! use custom-cflags ; then
		strip-flags
	fi

	if _use_system_toolchain ; then
		myconf_gn+=(
			"llvm_libdir=\"$(get_libdir)\""
		)
	fi

	if tc-is-clang ; then
		if ver_test $(clang-major-version) -ge 16 ; then
			myconf_gn+=(
				"clang_version=$(clang-major-version)"
			)
		else
			myconf_gn+=(
				"clang_version=$(clang-fullversion)"
			)
		fi
	fi

	# We don't use the same clang version as upstream, and with -Werror
	# we need to make sure that we don't get superfluous warnings.
	append-flags -Wno-unknown-warning-option
	if tc-is-cross-compiler ; then
		export BUILD_CXXFLAGS+=" -Wno-unknown-warning-option"
		export BUILD_CFLAGS+=" -Wno-unknown-warning-option"
	fi

	if ! use custom-cflags ; then
	# Debug info section overflows without component build
	# Prevent linker from running out of address space, bug #471810.
		filter-flags '-g*'
	fi

	myconf_gn+=(
	# The sysroot is the oldest debian image that Chromium supports.  We don't need it.
		"use_sysroot=false"

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
		"clang_use_chrome_plugins=false"
		"clang_use_raw_ptr_plugin=false"
		"enable_check_raw_ptr_fields=false"
		"enable_check_raw_ref_fields=false"

		"treat_warnings_as_errors=false"
	)

}

_configure_build_system() {
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
		myconf_gn+=(
			"use_debug_fission=false"
		)
	fi

	# I noticed that the vendored clang doesn't use ccache.  Let us explicitly use ccache if requested.
	# See https://github.com/chromium/chromium/blob/140.0.7339.127/build/toolchain/cc_wrapper.gni#L36
	if ! _use_system_toolchain ; then
		if [[ "${FEATURES}" =~ "ccache" ]] && has_version "dev-util/ccache" ; then
			myconf_gn+=(
				"cc_wrapper=\"ccache\""
			)
			export CCACHE_BASEDIR="${TMPDIR}"
		fi

		[[ "${FEATURES}" =~ "distcc" ]] && die "FEATURES=distcc with USE=-system-toolchain is not supported by the ebuild."
		[[ "${FEATURES}" =~ "icecream" ]] && die "FEATURES=icecream with USE=-system-toolchain is not supported by the ebuild."
	fi

	if [[ "${FEATURES}" =~ ("distcc"|"icecream") ]] ; then
		export DISTRIBUTED_BUILD=1
	fi
}

_configure_system_toolchain() {
einfo "Using the system toolchain"
	# We already forced the "correct" clang via pkg_setup
	# See _set_system_cc

	if tc-is-clang ; then
		myconf_gn+=(
			"is_clang=true"
			"clang_use_chrome_plugins=false"
		)
	# Workaround for build failure with clang-18 and -march=native without
	# avx512. Does not affect e.g. -march=skylake, only native (bug #931623).
		if \
			   use amd64 \
			&& is-flagq "-march=native" \
			&& [[ $(clang-major-version) -eq "18" ]] \
			&& [[ $(clang-minor-version) -lt "6" ]] \
			&& ! use cpu_flags_x86_avx512f \
		; then
			append-flags $(test-flags-CXX "-mevex512")
		fi
	else
		myconf_gn+=(
			"is_clang=false"
		)
	fi

	if tc-is-clang ; then
	# https://bugs.gentoo.org/918897#c32
		append-ldflags -Wl,--undefined-version
		myconf_gn+=(
			"use_lld=true"
		)
	else
	# This doesn't prevent lld from being used, but rather prevents gn from
	# forcing it.
		myconf_gn+=(
			"use_lld=false"
		)
	fi

	if is-flagq '-flto' || tc-is-clang ; then
		AR="llvm-ar"
		NM="llvm-nm"
		if tc-is-cross-compiler ; then
			BUILD_AR="llvm-ar"
			BUILD_NM="llvm-nm"
		fi
	fi

	if tc-is-clang ; then
		myconf_gn+=(
			"clang_base_path=\"${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}\""
		)
	fi

	if tc-is-cross-compiler ; then
		tc-export BUILD_{AR,CC,CXX,NM}
		myconf_gn+=(
			"host_pkg_config=\"$(tc-getBUILD_PKG_CONFIG)\""
			"host_toolchain=\"//build/toolchain/linux/unbundle:host\""
			"pkg_config=\"$(tc-getPKG_CONFIG)\""
			"v8_snapshot_toolchain=\"//build/toolchain/linux/unbundle:host\""
		)

	# Setup cups-config, build system only uses --libs option
		if use cups ; then
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
		myconf_gn+=(
			"host_toolchain=\"//build/toolchain/linux/unbundle:default\""
		)
	fi

	# We don't want to depend on llvm/llvm-r1 eclasses.

	# Set LLVM_CONFIG to help Meson (bug #907965) but only do it
	# for empty ESYSROOT (as a proxy for "are we cross-compiling?").
	if [[ -z "${ESYSROOT}" ]] ; then
		llvm_fix_tool_path LLVM_CONFIG
	fi

	rust_pkg_setup
	einfo "Using Rust slot ${RUST_SLOT}, ${RUST_TYPE} to build"

	# I hate doing this but upstream Rust have yet to come up with a better
	# solution for us poor packagers. Required for Split LTO units, which
	# are required for CFI.
	export RUSTC_BOOTSTRAP=1

	myconf_gn+=(
	# From M127 we need to provide a location for libclang.
	# We patch this in for gentoo - see chromium-*-bindgen-custom-toolchain.patch
	# rust_bindgen_root = directory with `bin/bindgen` beneath it.
	# We don't need to set 'clang_base_path' for anything in our build
	# and it defaults to the google toolchain location. Instead provide a location
	# to where system clang lives so that bindgen can find system headers (e.g. stddef.h)
		"bindgen_libclang_path=\"$(get_llvm_prefix)/$(get_libdir)\""

		"clang_base_path=\"${EPREFIX}/usr/lib/clang/${LLVM_SLOT}/\""
		"custom_toolchain=\"//build/toolchain/linux/unbundle:default\""
		"rust_bindgen_root=\"${EPREFIX}/usr/\""
		"rust_sysroot_absolute=\"$(get_rust_prefix)\""
		"rustc_version=\"${RUST_SLOT}\""

	# Silence
	# The expected Rust version is [...] but the actual version is None
		#"use_chromium_rust_toolchain=false"

	# Disabled distro choices
		#"use_lld=true"										# Mold is preferred
		#"clang_use_chrome_plugins=false"							# Slows down build.  Should only used for dev builds.
	)
}

_configure_security(){
	if use official ; then
		:
	elif use cpu_flags_arm_bti && use cpu_flags_arm_pac ; then
		:
	elif use cfi ; then
		:
	elif [[ "${ABI}" == "arm64" ]] ; then
ewarn
ewarn "You are missing CFI for execution integrity.  These are associated with"
ewarn "a few top 25 reported vulnerabilities.  Choose one of the following to"
ewarn "mitigate a possible code execution attack."
ewarn
ewarn "The scores:"
ewarn
ewarn "    Mitigation combo                                           | Score     | Security posture     | Upstream default?"
ewarn "--------------------------------------------------------------------------------------------------------------"
ewarn " 1. CFI (icall + vcall + cast) + SCS                           | 0.91285   | Security-critical    |"
ewarn " 2. CFI (icall + vcall + cast) + BTI + PAC                     | 0.9082    | Security-critical    |"
ewarn " 3. CFI (icall + vcall + cast) + PAC                           | 0.8962    | Security-critical    |"
ewarn " 4. CFI (icall + vcall + cast) + BTI                           | 0.8815    | Security-critical    |"
ewarn " 5. CFI (icall + vcall + cast)                                 | 0.87      | Security-critical    |"
ewarn " 6. CFI (icall + vcall) + ShadowCallStack                      | 0.78725   | Balanced             |"
ewarn " 7. BTI + PAC                                                  | 0.775     | Balanced             | Yes for arm64 only"
ewarn " 8. CFI (vcall + icall)                                        | 0.705     | Balanced             | Yes for amd64 official only"
ewarn " 9. CFI (vcall) + ShadowCallStack                              | 0.61175   | Performance-critical |"
ewarn "10. PAC                                                        | 0.601     | Performance-critical |"
ewarn "11. BTI                                                        | 0.544     | Performance-critical |"
ewarn "12. ShadowCallStack                                            | 0.5195    | Performance-critical |"
ewarn "13. CFI (vcall)                                                | 0.51      | Performance-critical |"
ewarn
ewarn "The scores reflect maximizing mitigation coverage, minimizing overhead,"
ewarn "and rewarding more for combos that attack widely reported CFI related"
ewarn "vulnerabilities."
ewarn
	elif [[ "${ABI}" == "amd64" ]] ; then
ewarn
ewarn "You are missing CFI for execution integrity.  These are associated with"
ewarn "a few top 25 reported vulnerabilities.  Choose one of the following to"
ewarn "mitigate a possible code execution attack."
ewarn
ewarn "The scores:"
ewarn
# Do not put ShadowCallStack.  It is broken in amd64.
ewarn "    Mitigation combo                                           | Score     | Security posture     | Upstream default?"
ewarn "--------------------------------------------------------------------------------------------------------------"
ewarn " 1. CFI (icall + vcall + cast)                                 | 0.87      | Security-critical    |"
ewarn " 2. CET                                                        | 0.845     | Balanced             |"
ewarn " 3. CFI (vcall + icall)                                        | 0.705     | Balanced             | Yes for amd64 official only"
ewarn " 4. CFI (vcall)                                                | 0.51      | Performance-critical |"
ewarn
ewarn "The scores reflect maximizing mitigation coverage, minimizing overhead,"
ewarn "and rewarding more for combos that attack widely reported CFI related"
ewarn "vulnerabilities."
ewarn
	else
ewarn
ewarn "You are using an ABI or platform without LLVM CFI (Control Flow Integrity) support."
ewarn "CFI associated attacks are a few of the top 25 reported vulnerabilities list."
ewarn "This increases the attack surface of the build."
ewarn
	fi

	if use official ; then
		CFLAGS_HARDENED_SANITIZERS_DEACTIVATE=1
	fi

	if ! _use_system_toolchain ; then
		export RUSTC="${S}/third_party/rust-toolchain/bin/rustc"
	fi
einfo "RUSTC:  ${RUSTC}"
	if ! ${RUSTC} --version 2>&1 >/dev/null ; then
eerror "QA:  RUSTC is not initialized or missing."
		die
	fi
	${RUSTC} -Z help 2>/dev/null 1>/dev/null
	local is_rust_nightly=$?

	if [[ "${ALLOW_SYSTEM_TOOLCHAIN}" == "0" ]] ; then
		CFLAGS_HARDENED_IGNORE_SANITIZER_CHECK=1
		CFLAGS_HARDENED_NO_COMPILER_SWITCH=1
	fi
	cflags-hardened_append
	# We just want the missing flags (retpoline, -fstack-clash-protection)  flags
	filter-flags \
		"-f*stack-protector" \
		"-ftrivial-auto-var-init=*" \
		"-Wl,-z,now" \
		"-Wl,-z,relro" \
		"-fstack-clash-protection"
	local wants_fc_protection=0
	if \
		   is-flagq "-fcf-protection=all" \
		|| is-flagq "-fcf-protection=branch" \
		|| is-flagq "-fcf-protection=return" \
	; then
		wants_fc_protection=1
	fi
	if ! use cet && (( ${wants_fc_protection} == 1 )) ; then
eerror "Enable the cet USE flag"
		die
	fi

	if use official ; then
ewarn "You are using official settings.  For strong hardening, disable this USE flag."
	else
		if use cet ; then
			myconf_gn+=(
				"use_cf_protection=\"full\""
				"use_rust_cet=true"
			)
		else
			myconf_gn+=(
				"use_cf_protection=\"none\""
			)
		fi
		if [[ "${ARCH}" == "amd64" ]] && is-flagq "-mretpoline" ; then
			myconf_gn+=(
				"use_retpoline=true"
				"use_rust_retpoline=true"
			)
		fi
		myconf_gn+=(
			"use_stack_clash_protection=false"
			"use_rust_stack_clash_protection=false"
		)
		if is-flagq "-ftrapv" ; then
			myconf_gn+=(
				"use_trapv=true"
				"use_rust_overflow_checks=true"
			)
		fi
		if is-flagq "-D_FORITFY_SOURCE=3" ; then
			myconf_gn+=(
				"use_fortify_source=3"
				"use_rust_fortify_source_level=3"
			)
		elif is-flagq "-D_FORITFY_SOURCE=2" ; then
			myconf_gn+=(
				"use_fortify_source=2"
				"use_rust_fortify_source_level=2"
			)
		fi

		# For sanitizers on internal libc++, SSP for Rust
		if is-flagq "-fsanitize=address" ; then
			myconf_gn+=(
				"is_asan=true"
				"use_rust_asan=true"
			)
		fi
		if is-flagq "-fsanitize=hwaddress" ; then
			myconf_gn+=(
				"is_hwasan=true"
				"use_rust_hwasan=true"
			)
		fi
		if is-flagq "-fsanitize=undefined" ; then
			myconf_gn+=(
				"is_ubsan=true"
				"use_rust_ubsan=true"
			)
		fi
		if is-flagq "-fsanitize=address" || is-flagq "-fsanitize=hwaddress" || is-flagq "-fsanitize=undefined" ; then
			myconf_gn+=(
				"use_rust_no_sanitize_recover=true"
			)
		fi
	# It is possible where some compilation units are SSP protected but not
	# ASan protected if both flags are enabled.
		if [[ "${CFLAGS_HARDENED_SSP_LEVEL}" == "0" ]] ; then
			myconf_gn+=(
				"use_stack_protector_level=\"none\""
			)
		elif [[ "${CFLAGS_HARDENED_SSP_LEVEL}" == "1" ]] ; then
			myconf_gn+=(
				"use_stack_protector_level=\"basic\""
			)
		elif [[ "${CFLAGS_HARDENED_SSP_LEVEL}" == "2" ]] ; then
			myconf_gn+=(
				"use_stack_protector_level=\"strong\""
			)
		elif [[ "${CFLAGS_HARDENED_SSP_LEVEL}" == "3" ]] ; then
			myconf_gn+=(
				"use_stack_protector_level=\"all\""
			)
		fi
		if (( ${is_rust_nightly} == 0 )) ; then
			if [[ "${CFLAGS_HARDENED_SSP_LEVEL}" == "0" ]] ; then
				myconf_gn+=(
					"use_rust_stack_protector_level=\"none\""
				)
			elif [[ "${CFLAGS_HARDENED_SSP_LEVEL}" == "1" ]] ; then
				myconf_gn+=(
					"use_rust_stack_protector_level=\"basic\""
				)
			elif [[ "${CFLAGS_HARDENED_SSP_LEVEL}" == "2" ]] ; then
				myconf_gn+=(
					"use_rust_stack_protector_level=\"strong\""
				)
			elif [[ "${CFLAGS_HARDENED_SSP_LEVEL}" == "3" ]] ; then
				myconf_gn+=(
					"use_rust_stack_protector_level=\"all\""
				)
			fi
		fi
	fi

	if is-flagq "-fsanitize=address" || is-flagq "-fsanitize=hwaddress" ; then
einfo "Disabling GWP-ASan which overlaps with ASan or HWASan"
einfo "To deactivate ASan, HWASan, or UBSan sanitizers set CFLAGS_HARDENED_SANITIZERS_DEACTIVATE=1"
		myconf_gn+=(
			"enable_gwp_asan_partitionalloc=false"
			"enable_gwp_asan=false"
		)
	elif tc-is-clang && [[ "${ABI}" == "arm" || "${ABI}" == "ppc" || "${ABI}" == "x86" ]] ; then
einfo "Disabling GWP-ASan for 32-bit"
	# Any 32-bit ABI
		myconf_gn+=(
			"enable_gwp_asan_partitionalloc=false"
			"enable_gwp_asan=false"
		)
	elif tc-is-clang && use gwp-asan && use partitionalloc ; then
einfo "Enabling GWP-ASan for PartitionAlloc"
		myconf_gn+=(
			"enable_gwp_asan_partitionalloc=true"
			"enable_gwp_asan=true"
		)
	elif tc-is-clang && use gwp-asan ; then
einfo "Enabling GWP-ASan for an alternative heap allocator"
		myconf_gn+=(
			"use_allocator_shim=true"
			"enable_gwp_asan=true"
		)
	else
einfo "Disabling GWP-ASan"
		myconf_gn+=(
			"enable_gwp_asan_partitionalloc=false"
			"enable_gwp_asan=false"
		)
	fi

	if use official ; then
		myconf_gn+=(
			"use_memory_tagging=true"
		)
	# It it will be default off.
	elif tc-is-clang && [[ "${ABI}" == "arm64" ]] ; then
		myconf_gn+=(
			"use_memory_tagging=$(usex cpu_flags_arm_mte true false)"
			"use_full_mte=$(usex cpu_flags_arm_mte true false)"
		)
	else
		myconf_gn+=(
			"use_memory_tagging=false"
		)
	fi

	if use official ; then
		:
	elif use partitionalloc && use miracleptr ; then
		:
	elif use cpu_flags_arm_mte ; then
		:
	elif use gwp-asan ; then
		:
	elif [[ "${ABI}" == "arm64" ]] ; then
ewarn
ewarn "You are disabling memory corruption mitigations."
ewarn
ewarn "Enable one of the combos below for increased coverage against memory"
ewarn "corruption attacks."
ewarn
ewarn "    Mitigation combo                                        | Score | Security posture     | Upstream default?"
ewarn "-----------------------------------------------------------------------------------------------------------"
ewarn " 1. PartitionAlloc + MiraclePtr + MTE                       |  17.8 | Security-critical    |"
ewarn " 2. PartitionAlloc + MiraclePtr + GWP-ASan                  |  17.2 | Security-critical    |"
ewarn " 3. MiraclePtr + MTE                                        |  13.6 | Security-critical    |"
ewarn " 4. MiraclePtr + GWP-ASan                                   |  13.0 | Security-critical    |"
ewarn " 5. PartitionAlloc + MTE                                    |  12.6 | Balance              |"
ewarn " 6. PartitionAlloc + GWP-ASan                               |  12.0 | Balance              |"
ewarn " 7. MiraclePtr + PartitionAlloc                             |  11.4 | Balance              | Yes"
ewarn " 8. MTE                                                     |   8.4 | Performance-critical |"
ewarn " 9. GWP-ASan                                                |   7.8 | Security-critical    |"
ewarn "10. MiraclePtr                                              |   7.8 | Balance              |"
ewarn "11. PartitionAlloc                                          |   7.8 | Performance-critical |"
ewarn
ewarn "The scores reflect maximizing mitigation coverage, minimizing overhead,"
ewarn "and rewarding more for combos that attack widely reported memory"
ewarn "corruption related vulnerabilities."
ewarn
	elif [[ "${ABI}" == "arm" || "${ABI}" == "ppc" || "${ABI}" == "x86" ]] ; then
	# 32-bit fallback
ewarn
ewarn "You are disabling memory corruption mitigations."
ewarn
ewarn "Enable one of the combos below for increased coverage against memory"
ewarn "corruption attacks."
ewarn
ewarn "    Mitigation combo                                        | Score | Security posture     | Upstream default?"
ewarn "-----------------------------------------------------------------------------------------------------------"
ewarn " 1. MiraclePtr + PartitionAlloc                             |  11.4 | Balance              | Yes"
ewarn
ewarn "Use 64-bit instead for a more secure build."
ewarn
	else
	# 64-bit fallback
ewarn
ewarn "You are disabling memory corruption mitigations."
ewarn
ewarn "Enable one of the combos below for increased coverage against memory"
ewarn "corruption attacks."
ewarn
ewarn "    Mitigation combo                                        | Score | Security posture     | Upstream default?"
ewarn "-----------------------------------------------------------------------------------------------------------"
ewarn " 1. PartitionAlloc + MiraclePtr + GWP-ASan                  |  17.2 | Security-critical    |"
ewarn " 2. MiraclePtr + GWP-ASan                                   |  13.0 | Security-critical    |"
ewarn " 3. PartitionAlloc + GWP-ASan                               |  12.0 | Balance              |"
ewarn " 4. MiraclePtr + PartitionAlloc                             |  11.4 | Balance              | Yes"
ewarn " 5. GWP-ASan                                                |   7.8 | Security-critical    |"
ewarn " 6. MiraclePtr                                              |   7.8 | Balance              |"
ewarn " 7. PartitionAlloc                                          |   7.8 | Performance-critical |"
ewarn
ewarn "The scores reflect maximizing mitigation coverage, minimizing overhead,"
ewarn "and rewarding more for combos that attack widely reported memory"
ewarn "corruption related vulnerabilities."
ewarn
	fi

	if ! use official ; then
	# The reason why we disable official in this ebuild fork is to drop the
	# lock-in to proprietary settings including proprietary codecs.

	# The MiraclePtr is default enabled on official Linux.
	# MiraclePtr is software based UAF detection.
	# When official is disabled, it reduces the attack surface and adds a
	# UAF critical-high vulnerability.
	# We force MiraclePtr on since GWP-ASan is default off.
	# It may overlap with GWP-ASan's UAF mitigation.
	# See also https://security.googleblog.com/2022/09/use-after-freedom-miracleptr.html
		myconf_gn+=(
			"enable_backup_ref_ptr_support=$(usex miracleptr true false)"
		)
	fi

	# Handled in build scripts.
	filter-flags \
		"-D_FORTIFY_SOURCE" \
		"-U_FORTIFY_SOURCE" \
		"-f*sanitize=*" \
		"-f*sanitize-recover" \
		"-fcf-protection=*" \
		"-fstack-clash-protection" \
		"-ftrapv" \
		"-mretpoline"
# LLVM CFI - forward edge protection
# ShadowCallStack - backward edge protection
# -fcf-protection=branch - forward edge protection
# -fcf-protection=return - backward edge protection
# -fcf-protection=full - forward and backward edge protection
	if use pgo ; then
# The compile flags should be the same as the one to generate the profile.
ewarn "You have enabled PGO, disabling flags that differ from the one used to generate the prebuilt PGO profile"
ewarn "For proper hardening, disable the pgo USE flag."
		filter-flags \
			"-fc-protection=*" \
			"-fstack-clash-protection" \
			"-ftrapv" \
			"-mindirect-branch=*" \
			"-mfunction-return=*" \
			"-mretpoline" \
			"-mretpoline-external-thunk"
	fi

	# See https://github.com/chromium/chromium/blob/140.0.7339.127/build/config/sanitizers/BUILD.gn#L196
	# See https://github.com/chromium/chromium/blob/140.0.7339.127/tools/mb/mb_config.pyl#L2950
	local is_cfi_custom=0
	if use official ; then
	# Forced because it is the final official settings.
		if [[ "${ABI}" == "amd64" ]] ; then
			myconf_gn+=(
				"is_cfi=true"
				"use_cfi_icall=true"
				"use_cfi_cast=false"
			)
		else
			myconf_gn+=(
				"is_cfi=false"
				"use_cfi_cast=false"
				"use_cfi_icall=false"
			)
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
					|| \
				(( ${CFI_VCALL} == 1 )) \
			; then
				myconf_gn+=(
					"is_cfi=true"
				)
				CFI_VCALL=1
			fi

			if \
				has_sanitizer_option "cfi-derived-cast" \
					|| \
				has_sanitizer_option "cfi-unrelated-cast" \
					|| \
				(( ${CFI_CAST} == 1 )) \
			; then
				myconf_gn+=(
					"use_cfi_cast=true"
				)
				CFI_CAST=1
			else
				myconf_gn+=(
					"use_cfi_cast=false"
				)
			fi

			if \
				has_sanitizer_option "cfi-icall" \
					|| \
				(( ${CFI_ICALL} == 1 )) \
			; then
				myconf_gn+=(
					"use_cfi_icall=true"
				)
				CFI_ICALL=1
			else
				myconf_gn+=(
					"use_cfi_icall=false"
				)
			fi
		else
	# Fallback to autoset in non-official
			myconf_gn+=(
				"is_cfi=true"
			)

			local cfi_cast_default="false"
			local cfi_icall_default="false"

			if [[ "${ABI}" == "amd64" ]] ; then
				cfi_icall_default="true"
			fi

	# Allow change by environment variables
			if [[ "${USE_CFI_CAST:-${cfi_cast_default}}" == "1" ]] ; then
				myconf_gn+=(
					"use_cfi_cast=true"
				)
			else
				myconf_gn+=(
					"use_cfi_cast=false"
				)
			fi

			if [[ "${USE_CFI_ICALL:-${cfi_icall_default}}" == "1" ]] ; then
				myconf_gn+=(
					"use_cfi_icall=true"
				)
			else
				myconf_gn+=(
					"use_cfi_icall=false"
				)
			fi
		fi
	else
		myconf_gn+=(
			"is_cfi=false"
			"use_cfi_cast=false"
			"use_cfi_icall=false"
		)
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
		myconf_gn+=(
			"v8_enable_cet_ibt=$(usex cet true false)"
			"v8_enable_cet_shadow_stack=false" # unfinished, windows only
		)
	fi

	if use arm64 ; then
		if use official ; then
			myconf_gn+=(
				"arm_control_flow_integrity=standard"
			)
		else
			if use cpu_flags_arm_pac && use cpu_flags_arm_bti ; then
	# ROP + JOP mitigation
				myconf_gn+=(
					"arm_control_flow_integrity=standard"
				)
			elif use cpu_flags_arm_pac ; then
	# ROP mitigation
				myconf_gn+=(
					"arm_control_flow_integrity=pac"
				)
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
				|| \
			(( ${SHADOW_CALL_STACK} == 1 )) \
		) \
	; then
		myconf_gn+=(
			"use_shadow_call_stack=true"
		)
		strip-flag-value "shadow-call-stack" # Dedupe flag
		SHADOW_CALL_STACK=1
	fi

	if is-flagq "-Ofast" ; then
	# Precaution
		append_all $(test-flags -fno-allow-store-data-races)
	fi

	# There was some discussion that libcxx could be ASan-ed which would be
	# a security advantage over the system's libstdc++.
	#
	# Use in-tree libc++ (buildtools/third_party/libc++ and buildtools/third_party/libc++abi)
	# instead of the system C++ library for C++ standard library support.
	# default: true, but let's be explicit (forced since 120 ; USE removed 127).
	if use official && use cfi || use bundled-libcxx ; then
	# If you didn't do systemwide CFI Cross-DSO, it must be static.
		myconf_gn+=(
			"use_custom_libcxx=true"
		)
	else
		myconf_gn+=(
			"use_custom_libcxx=false"
		)
	fi
}

_configure_performance_pgo(){
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
eerror "Found:\t${CURRENT_PROFDATA_VERSION} for ~llvm-core/llvm-${CURRENT_PROFDATA_LLVM_VERSION}"
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
einfo "Found:\t${CURRENT_PROFDATA_VERSION} for ~llvm-core/llvm-${CURRENT_PROFDATA_LLVM_VERSION}"
einfo
		fi
	fi

	# See also build/config/compiler/pgo/BUILD.gn#L71 for PGO flags.
	# See also https://github.com/chromium/chromium/blob/140.0.7339.127/docs/pgo.md
	# profile-instr-use is clang which that file assumes but gcc doesn't have.
	# chrome_pgo_phase:  0=NOP, 1=PGI, 2=PGO
	if use pgo && tc-is-clang && ver_test "$(clang-major-version)" -ge "${PREGENERATED_PGO_PROFILE_MIN_LLVM_SLOT}" ; then
	# The profile data is already shipped so use it.
	# PGO profile location: chrome/build/pgo_profiles/chrome-linux-*.profdata
		myconf_gn+=(
			"chrome_pgo_phase=2"
		)
	else
	# The pregenerated profiles are not GCC compatible.
		myconf_gn+=(
			"chrome_pgo_phase=0"
		)
	fi
}

_configure_performance_simd(){
	if ! use cpu_flags_arm_dotprod ; then
		sed -r -i \
			-e "s|XNN_ENABLE_ARM_DOTPROD=1|XNN_ENABLE_ARM_DOTPROD=0|g" \
			-e "/:.*[+]dotprod/d" \
			"third_party/xnnpack/BUILD.gn" \
			|| die
	fi
	if ! use cpu_flags_arm_fp16 ; then
		sed -r -i -e "/:.*[+]fp16/d" "third_party/xnnpack/BUILD.gn" || die
	fi
	if ! use cpu_flags_arm_i8mm ; then
		sed -r -i \
			-e "s|XNN_ENABLE_ARM_I8MM=1|XNN_ENABLE_ARM_I8MM=0|g" \
			-e "/:.*[+]i8mm/d" \
			"third_party/xnnpack/BUILD.gn" \
			|| die
	fi
	if ! use cpu_flags_x86_avx ; then
		sed -r -i -e "/:.*_avx-/d" "third_party/xnnpack/BUILD.gn" || die
	fi
	if use cpu_flags_x86_avx2 ; then
		sed -r -i -e "/:.*-no-avx2/d" "third_party/xnnpack/BUILD.gn" || die
	else
		sed -r -i -e "/:.*_avx2/d" "third_party/xnnpack/BUILD.gn" || die
	fi
	if ! use cpu_flags_x86_avx512f ; then
		sed -r -i -e "/:.*_avx512f/d" "third_party/xnnpack/BUILD.gn" || die
	fi
	if ! use cpu_flags_x86_avx512fp16 ; then
		sed -r -i -e "/:.*-avx512fp16/d" "third_party/xnnpack/BUILD.gn" || die
	fi
	if use cpu_flags_x86_f16c ; then
		sed -r -i -e "/:.*-no-f16c/d" "third_party/xnnpack/BUILD.gn" || die
	else
		sed -r -i -e "/:.*_f16c/d" "third_party/xnnpack/BUILD.gn" || die
	fi
	if use cpu_flags_x86_fma ; then
		sed -r -i -e ":/-no-fma/d" "third_party/xnnpack/BUILD.gn" || die
	fi
	if ! use cpu_flags_x86_gfni ; then
		sed -r -i -e "/:.*-gfni/d" "third_party/xnnpack/BUILD.gn" || die
	fi
	if ! use cpu_flags_x86_sse ; then
		sed -r -i -e "/:.*_sse-/d" "third_party/xnnpack/BUILD.gn" || die
	fi
	if use cpu_flags_x86_sse2 ; then
		sed -r -i -e "/:.*-no-sse2/d" "third_party/xnnpack/BUILD.gn" || die
	else
		sed -r -i -e "/:.*_sse2/d" "third_party/xnnpack/BUILD.gn" || die
	fi
	if use cpu_flags_x86_sse3 ; then
		sed -r -i -e "/:.*-no-sse3/d" "third_party/xnnpack/BUILD.gn" || die
	fi
	if use cpu_flags_x86_sse4_1 ; then
		sed -r -i -e "/:.*-no-sse4[.]1/d" "third_party/xnnpack/BUILD.gn" || die
	else
		sed -r -i -e "/:.*_sse4[.]1/d" "third_party/xnnpack/BUILD.gn" || die
	fi
	if use cpu_flags_x86_sse4_2 ; then
		sed -r -i -e "/:.*-no-sse4[.]1/d" "third_party/xnnpack/BUILD.gn" || die
	fi
	if ! use cpu_flags_x86_ssse3 ; then
		sed -r -i -e "/:.*_ssse3/d" "third_party/xnnpack/BUILD.gn" || die
	fi
	if ! use cpu_flags_x86_amx-tile ; then
		sed -r -i -e "/:.*amx-tile/d" "third_party/xnnpack/BUILD.gn" || die
	fi
	if ! use cpu_flags_x86_amx-int8 ; then
		sed -r -i -e "/:.*amx-int8/d" "third_party/xnnpack/BUILD.gn" || die
	fi
	if ! use cpu_flags_x86_avxvnni ; then
		sed -r -i -e "/:.*avxvnni-/d" "third_party/xnnpack/BUILD.gn" || die
	fi
	if ! use cpu_flags_x86_avxvnniint8 ; then
		sed -r -i -e "/:.*avxvnniint8-/d" "third_party/xnnpack/BUILD.gn" || die
	fi

	myconf_gn+=(
	# ARM
		"use_aes=$(usex cpu_flags_arm_aes true false)"
		"use_armv4=$(usex cpu_flags_arm_armv4 true false)"
		"use_armv6=$(usex cpu_flags_arm_armv6 true false)"
		"use_bf16=$(usex cpu_flags_arm_bf16 true false)"
		"use_crc32=$(usex cpu_flags_arm_crc32 true false)"
		"use_dotprod=$(usex cpu_flags_arm_dotprod true false)"
		"use_edsp=$(usex cpu_flags_arm_edsp true false)"
		"use_fp16=$(usex cpu_flags_arm_fp16 true false)"
		"use_i8mm=$(usex cpu_flags_arm_i8mm true false)"
		"use_neon=$(usex cpu_flags_arm_neon true false)"
		"use_sve=$(usex cpu_flags_arm_sve true false)"
		"use_sve_256=$(usex cpu_flags_arm_sve_256 true false)"
		"use_sve2=$(usex cpu_flags_arm_sve2 true false)"
		"use_sve2_128=$(usex cpu_flags_arm_sve2_128 true false)"

	# LOONG
		"use_lsx=$(usex cpu_flags_loong_lsx true false)"
		"use_lasx=$(usex cpu_flags_loong_lasx true false)"

	# MIPS
		"use_dsp=$(usex cpu_flags_mips_dsp true false)"
		"use_dspr2=$(usex cpu_flags_mips_dspr2 true false)"
		"use_msa=$(usex cpu_flags_mips_msa true false)"

	# PPC
		"use_altivec=$(usex cpu_flags_ppc_altivec true false)"
		"use_crypto=$(usex cpu_flags_ppc_crypto true false)"
		"use_ppc8=$(usex cpu_flags_ppc_power8-vector true false)"
		"use_ppc9=$(usex cpu_flags_ppc_power9-vector true false)"
		"use_ppc10=$(usex cpu_flags_ppc_power10-vector true false)"
		"use_vsx=$(usex cpu_flags_ppc_vsx true false)"

	# RISCV
		"use_rvv=$(usex cpu_flags_riscv_rvv true false)"

	# S390
		"use_z15=$(usex cpu_flags_s390_z15 true false)"
		"use_z16=$(usex cpu_flags_s390_z16 true false)"

	# X86
		"use_3dnow=$(usex cpu_flags_x86_3dnow true false)"
		"use_aes=$(usex cpu_flags_x86_aes true false)"
		"use_avx=$(usex cpu_flags_x86_avx true false)"
		"use_avx2=$(usex cpu_flags_x86_avx2 true false)"
		"use_avx512fp16=$(usex cpu_flags_x86_avx512fp16 true false)"		# Sapphire Rapids or better
		"use_avx512bf16=$(usex cpu_flags_x86_avx512bf16 true false)"		# Zen 4 or better
		"use_avxvnni=$(usex cpu_flags_x86_avxvnni true false)"
		"use_avxvnniint8=$(usex cpu_flags_x86_avxvnniint8 true false)"
		"use_bmi=$(usex cpu_flags_x86_bmi true false)"
		"use_bmi2=$(usex cpu_flags_x86_bmi2 true false)"
		"use_f16c=$(usex cpu_flags_x86_f16c true false)"
		"use_fma=$(usex cpu_flags_x86_fma true false)"
		"use_gfni=$(usex cpu_flags_x86_gfni true false)"
		"use_pclmul=$(usex cpu_flags_x86_pclmul true false)"
		"use_popcnt=$(usex cpu_flags_x86_popcnt true false)"
		"use_sse=$(usex cpu_flags_x86_sse true false)"
		"use_sse2=$(usex cpu_flags_x86_sse2 true false)"
		"use_sse3=$(usex cpu_flags_x86_sse3 true false)"
		"use_sse4_1=$(usex cpu_flags_x86_sse4_1 true false)"
		"use_sse4_2=$(usex cpu_flags_x86_sse4_2 true false)"
		"use_ssse3=$(usex cpu_flags_x86_ssse3 true false)"

	# LIBYUV
		"libyuv_disable_rvv=$(usex cpu_flags_riscv_rvv false true)"
		"libyuv_use_lasx=$(usex cpu_flags_loong_lasx true false)"
		"libyuv_use_lsx=$(usex cpu_flags_loong_lsx true false)"
		"libyuv_use_msa=$(usex cpu_flags_mips_msa true false)"
		"libyuv_use_neon=$(usex cpu_flags_arm_neon true false)"
		"libyuv_use_sme=$(usex cpu_flags_arm_sme true false)"
		"libyuv_use_sve=$(usex cpu_flags_arm_sve2 true false)" # This line is not a typo.

	# RTC
		"rtc_enable_avx2=$(usex cpu_flags_x86_avx2 true false)"
		"rtc_build_with_neon=$(usex cpu_flags_arm_neon true false)" # webrtc

	# WASM
		"use_wasm=$(usex webassembly true false)"
	)

	if [[ "${ABI}" == "arm" || "${ABI}" == "arm64" ]] ; then
		myconf_gn+=(
			"arm_use_neon=$(usex cpu_flags_arm_neon true false)" # blink, ffmpeg, libjpeg_turbo, libpng, libvpx, lzma_sdk, opus, pdfium, pffft, skia, webrtc, zlib
			"arm_use_thumb=$(usex cpu_flags_arm_thumb true false)" # compiler
			"arm_optionally_use_neon=false"
		)
	fi

	if [[ "${ARCH}" == "loong" ]] ; then
		myconf_gn+=(
			"loongarch64_use_lasx=$(usex cpu_flags_loong_lasx true false)" # libyuv
			"loongarch64_use_lsx=$(usex cpu_flags_loong_lsx true false)" # libpng, libyuv
		)
	fi

	if [[ "${ABI}" =~ "mips" ]] ; then
		myconf_gn+=(
			"mips_use_msa=$(usex cpu_flags_mips_msa true false)" # libyuv, libpng
		)
	fi

	# This is normally defined by compiler_cpu_abi in
	# build/config/compiler/BUILD.gn, but we patch that part out.
	if use cpu_flags_x86_mmx ; then
		append-flags "-mmmx"
	fi
	if use cpu_flags_x86_sse ; then
		append-flags "-mfpmath=sse"
	fi
	if use cpu_flags_x86_sse2 ; then
		append-flags "-msse2"
	fi

	if false && ! use custom-cflags ; then
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


	# For AVX3, see \
	# https://github.com/google/highway/blob/00fe003dac355b979f36157f9407c7c46448958e/hwy/ops/set_macros-inl.h#L136
	# For AVX3_DL, see \
	# https://github.com/google/highway/blob/00fe003dac355b979f36157f9407c7c46448958e/hwy/ops/set_macros-inl.h#L138

	if \
		   use cpu_flags_x86_avx512vbmi \
		&& use cpu_flags_x86_avx512vbmi2 \
		&& use cpu_flags_x86_avx512vnni \
		&& use cpu_flags_x86_avx512bitalg \
		&& use cpu_flags_x86_avx512vpopcntdq \
		&& use cpu_flags_x86_gfni \
		&& use cpu_flags_x86_vaes \
		&& use cpu_flags_x86_vpclmulqdq \
	; then
	# Ice Lake or better
		myconf_gn+=(
			"use_avx512vbmi2=true"
		)
	else
		myconf_gn+=(
			"use_avx512vbmi2=false"
		)
	fi

	if \
		   use cpu_flags_x86_avx512bw \
		&& use cpu_flags_x86_avx512cd \
		&& use cpu_flags_x86_avx512dq \
		&& use cpu_flags_x86_avx512f  \
		&& use cpu_flags_x86_avx512vl \
	; then
	# The same as AVX512
		myconf_gn+=(
			"use_avx512=true"
		)
	else
		myconf_gn+=(
			"use_avx512=false"
		)
	fi

	if use webassembly ; then
		if [[ "${ABI}" == "x86" || "${ABI}" == "amd64" ]] ; then
			myconf_gn+=(
				"use_wasm_emu256=$(usex cpu_flags_x86_sse2 true false)"
			)
		elif [[ "${ABI}" == "arm" || "${ABI}" == "arm64" ]] ; then
			myconf_gn+=(
				"use_wasm_emu256=$(usex cpu_flags_arm_neon true false)"
			)
		else
			myconf_gn+=(
				"use_wasm_emu256=false"
			)
		fi
	fi

	if use cpu_flags_x86_avx ; then
	# Default on upstream for 64-bit with wasm enabled
		myconf_gn+=(
			"v8_enable_wasm_simd256_revec=true"
		)
	else
		myconf_gn+=(
			"v8_enable_wasm_simd256_revec=false"
		)
	# It will override the config.
		sed -i -e "s|v8_enable_wasm_simd256_revec = true|v8_enable_wasm_simd256_revec = false|g" \
			"v8/BUILD.gn" \
			"v8/test/unittests/BUILD.gn" \
			|| die
	fi
}

_configure_linker() {
	local use_thinlto=0

	if is-flagq '-flto' || is-flagq '-flto=*' ; then
		USE_LTO=1
	fi

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
		filter-lto
		use cfi         && fatal_message_lto_banned "cfi"
		use official    && fatal_message_lto_banned "official"
	fi

	# Already called check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
		USE_LTO=0
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

	if [[ -z "${LTO_TYPE}" ]] ; then
		LTO_TYPE=$(check-linker_get_lto_type)
	fi
	if \
		(( ${USE_LTO} == 1 )) \
					&&
		( \
			( \
				tc-is-clang \
					&& \
				[[ "${LTO_TYPE}" == "thinlto" ]] \
			) \
					|| \
			( \
				use cfi \
			) \
					|| \
			( \
				use official \
					&& \
				[[ "${PGO_PHASE}" != "PGI" ]] \
			) \
		) \
	; then
einfo "Using ThinLTO"
		myconf_gn+=(
			"use_thin_lto=true"
		)
		filter-lto
		filter-flags '-fuse-ld=*'
		filter-flags '-Wl,--lto-O*'
		if [[ "${THINLTO_OPT:-1}" == "1" ]] ; then
			myconf_gn+=(
				"thin_lto_enable_optimizations=true"
			)
		fi
		use_thinlto=1
	else
	# gcc will never use ThinLTO.
	# gcc doesn't like -fsplit-lto-unit and -fwhole-program-vtables
	# We want the faster LLD but without LTO.
		myconf_gn+=(
			"thin_lto_enable_optimizations=false"
			"use_thin_lto=false"
		)
	fi

	if ! use mold && is-flagq '-fuse-ld=mold' && has_version "sys-devel/mold" ; then
eerror "To use mold, enable the mold USE flag."
		die
	fi

	# See https://github.com/rui314/mold/issues/336
	if use mold && (( ${use_thinlto} == 0 && ${USE_LTO} == 1 )) ; then
		if tc-is-clang ; then
einfo "Using Clang MoldLTO"
			myconf_gn+=(
				"use_mold=true"
			)
		else
ewarn "Forcing use of GCC Mold without LTO.  GCC MoldLTO is not supported."
ewarn "To use LTO, use either Clang MoldLTO, Clang ThinLTO, GCC BFDLTO."
			filter-lto
		fi
	elif use mold && (( ${use_thinlto} == 0 && ${USE_LTO} == 0 )) ; then
einfo "Using Mold without LTO"
		myconf_gn+=(
			"use_mold=true"
		)
	fi

	myconf_gn+=(
	# Disable fatal linker warnings, bug 506268.
		"fatal_linker_warnings=false"
	)

	# Handled by build scripts
	filter-flags '-fuse-ld=*'
}

get_target_cpu() {
	local myarch="$(tc-arch)"
	local target_cpu
	if [[ "${myarch}" == "amd64" ]] ; then
		target_cpu="x64"
	elif [[ "${myarch}" == "x86" ]] ; then
		target_cpu="x86"
	elif [[ "${myarch}" == "arm64" ]] ; then
		target_cpu="arm64"
	elif [[ "${myarch}" == "arm" ]] ; then
		target_cpu="arm"
	elif [[ "${myarch}" == "ppc64" ]] ; then
		target_cpu="ppc64"
	else
eerror "Failed to determine target arch, got '${myarch}'."
		die
	fi
	echo "${target_cpu}"
}

# JavaScript engine
_configure_v8() {
	if use official ; then
		: # Automagic
	else
		_jit_level_0() {
			# ~20%/~50% performance similar to light swap, but a feeling of less progress (20-25%)
			myconf_gn+=(
				"v8_enable_drumbrake=false"
				"v8_enable_gdbjit=false"
				"v8_enable_lite_mode=true"
				"v8_enable_maglev=false"
				"v8_enable_sparkplug=false"
				"v8_enable_turbofan=false"
				"v8_enable_webassembly=false"
				"v8_jitless=true"
			)
		}

		_jit_level_1() {
			# 28%/71% performance similar to light swap, but a feeling of more progress (33%)
			myconf_gn+=(
				"v8_enable_drumbrake=$(usex drumbrake true false)"
				"v8_enable_gdbjit=$(usex debug true false)"
				"v8_enable_lite_mode=false"
				"v8_enable_maglev=false" # Requires turbofan
				"v8_enable_sparkplug=true"
				"v8_enable_turbofan=false"
				"v8_enable_webassembly=false"
				"v8_jitless=false"
			)
		}

		_jit_level_2() {
			# > 75% performance
			myconf_gn+=(
				"v8_enable_drumbrake=$(usex drumbrake true false)"
				"v8_enable_gdbjit=$(usex debug true false)"
				"v8_enable_lite_mode=false"
				"v8_enable_maglev=false"
				"v8_enable_sparkplug=false"
				"v8_enable_turbofan=true"
				"v8_enable_webassembly=$(usex webassembly true false)"
				"v8_jitless=false"
			)
		}

		_jit_level_5() {
			# > 90% performance
			myconf_gn+=(
				"v8_enable_drumbrake=$(usex drumbrake true false)"
				"v8_enable_gdbjit=$(usex debug true false)"
				"v8_enable_lite_mode=false"
				"v8_enable_maglev=false"
				"v8_enable_sparkplug=true"
				"v8_enable_turbofan=true"
				"v8_enable_webassembly=$(usex webassembly true false)"
				"v8_jitless=false"
			)
		}

		_jit_level_6() {
			# 100% performance
			myconf_gn+=(
				"v8_enable_drumbrake=$(usex drumbrake true false)"
				"v8_enable_gdbjit=$(usex debug true false)"
				"v8_enable_lite_mode=false"
			)
	# See L553 in /usr/share/chromium/sources/v8/BUILD.gn
			if \
				[[ \
					"${ARCH}"  == "amd64" \
						|| \
					"${ARCH}"  == "arm" \
						|| \
					"${ARCH}"  == "arm64" \
						|| \
					"${CHOST}" =~ "riscv64" \
						|| \
					"${CHOST}" =~ "s390x" \
				]] \
			; then
				myconf_gn+=(
					"v8_enable_maglev=true" # %5 runtime benefit
				)
			else
				myconf_gn+=(
					"v8_enable_maglev=false"
				)
			fi
			myconf_gn+=(
				"v8_enable_sparkplug=true" # 5% benefit
				"v8_enable_turbofan=true" # Subset of -O1, -O2, -O3; 100% performance
				"v8_enable_webassembly=$(usex webassembly true false)" # Requires it turbofan
				"v8_jitless=false"
			)
		}

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

# [15742/26557] python3.11 ../../v8/tools/run.py ./mksnapshot --turbo_instruction_scheduling --stress-turbo-late-spilling --target_os=linux --target_arch=x64 --embedded_src gen/v8/embedded.S --predictable --no-use-ic --turbo-elide-frames --embedded_variant Default --random-seed 314159265 --startup_blob snapshot_blob.bin --no-native-code-counters --concurrent-builtin-generation --concurrent-turbofan-max-threads=0
# FAILED: gen/v8/embedded.S snapshot_blob.bin 
# python3.11 ../../v8/tools/run.py ./mksnapshot --turbo_instruction_scheduling --stress-turbo-late-spilling --target_os=linux --target_arch=x64 --embedded_src gen/v8/embedded.S --predictable --no-use-ic --turbo-elide-frames --embedded_variant Default --random-seed 314159265 --startup_blob snapshot_blob.bin --no-native-code-counters --concurrent-builtin-generation --concurrent-turbofan-max-threads=0
# Return code is -11

# ERROR:
#
# Reported by elfx86exts:
# Instruction set extensions used: AVX, AVX2, AVX512, BMI, BMI2, BWI, CMOV, DQI, MODE64, NOVLX, PCLMUL, SSE1, SSE2, SSE3, SSE41, SSSE3, VLX
#
# It is a mess really
# v8_enable_pointer_compression_shared_cage depends on v8_enable_pointer_compression
# v8_enable_drumbrake depend on v8_enable_pointer_compression
# v8_enable_sandbox depends on v8_enable_external_code_space
# v8_enable_external_code_space depends on v8_enable_pointer_compression
# Disabling pointer compression will disable both v8 sandbox and drumbrake.
#
# To fix disable either v8_enable_sandbox=false or v8_enable_pointer_compression=false

	local target_cpu=$(get_target_cpu)
	myconf_gn+=(
#		"${myconf_gn//v8_enable_drumbrake=true/v8_enable_drumbrake=false}"
	# For Node.js, the v8 sandbox is disabled.  This is temporary until a
	# fix can be found or fixed in the next major version.
	# Disabling pointer compression disables the v8 sandbox.
#		"v8_enable_pointer_compression=false"
#		"v8_enable_pointer_compression_shared_cage=false"

		"v8_current_cpu=\"${target_cpu}\""

	# It's only enabled for Clang, but GCC has endian macros too.
		"v8_use_libm_trig_functions=true"
	)

	if [[ "${ABI}" == "arm" || "${ABI}" == "x86" || "${ABI}" == "ppc" ]] ; then
# Upstream doesn't support it.
ewarn "The v8 sandbox is not supported for 32-bit.  Consider using 64-bit only to avoid high-critical severity memory corruption that leads to code execution."
		myconf_gn+=(
			"v8_enable_sandbox=false"
		)
	fi
}

_configure_optimization_level() {
	#
	# Oflag and or compiler flag requirements:
	#
	# 1. Smooth playback (>=25 FPS) for vendored codecs like dav1d.
	# 2. Fast build time to prevent systemwide vulnerability backlog.
	# 3. Critical vulnerabilities should be fixed in one day, which implies
	#    that the ebuild has to be completely merged within a day.
	# 4. Does not introduce more vulnerabilities or increase the estimated CVSS score.
	#

	replace-flags "-Ofast" "-O2"
	replace-flags "-O4" "-O2"
	replace-flags "-O3" "-O2"
	replace-flags "-Os" "-O2"
	replace-flags "-Oz" "-O2"
	replace-flags "-O1" "-O2"
	replace-flags "-O0" "-O2"
	if ! is-flagq "-O2" ; then
	# Optimize for performance by default.
	# GCC/Clang uses -O0 by default
		append-flags "-O2"
	fi

	if ! _use_system_toolchain ; then
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
	if use official ; then
		replace-flags "-O*" "-O3"
	fi
	local olast=$(get_olast)
	replace-flags "-O*" "${get_olast}"

	local oshit_opt_level_dav1d
	local oshit_opt_level_libaom
	local oshit_opt_level_libvpx
	local oshit_opt_level_openh264
	local oshit_opt_level_opus
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
		oshit_opt_level_opus=${OSHIT_OPT_LEVEL_OPUS:-"2"}
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

	if [[ "${oshit_opt_level_dav1d}" =~ ("2") ]] ; then
		:
	else
		oshit_opt_level_dav1d="2"
	fi

	if [[ "${oshit_opt_level_libaom}" =~ ("1"|"2") ]] ; then
	# If you don't care, then just use -O1.
	# If you have hardware av1 encoding, use -O1.
	# If you have a lot of CPU cores, use Ofast.
		:
	else
		oshit_opt_level_libaom="2" # I don't use, and it is too slow for realtime encoding.
	fi

	if [[ "${oshit_opt_level_libvpx}" =~ ("2") ]] ; then
		:
	else
		oshit_opt_level_libvpx="2"
	fi

	if [[ "${oshit_opt_level_openh264}" =~ ("1"|"2") ]] ; then
	# If you have hardware acceleration or don't use it, then just use -O1.
		:
	else
		oshit_opt_level_openh264="2"
	fi

	if [[ "${oshit_opt_level_opus}" =~ ("1"|"2") ]] ; then
	# If you don't care, then just use -O1.
		:
	else
		oshit_opt_level_opus="1"
	fi

	if [[ "${oshit_opt_level_rnnoise}" =~ ("1"|"2") ]] ; then
	# If you don't care about AI/ML or noise reduction, then just use -O1.
		:
	else
		oshit_opt_level_rnnoise="2"
	fi

	if [[ "${oshit_opt_level_ruy}" =~ ("1"|"2") ]] ; then
	# If you don't care about AI/ML, then just use -O1.
		:
	else
		oshit_opt_level_ruy="2"
	fi

	if [[ "${oshit_opt_level_tflite}" =~ ("1"|"2") ]] ; then
	# If you don't care, then just use -O1.
		:
	else
		oshit_opt_level_tflite="2"
	fi

	if [[ "${oshit_opt_level_v8}" =~ ("2") ]] ; then
		:
	else
		oshit_opt_level_v8="2"
	fi

	if [[ "${oshit_opt_level_xnnpack}" =~ ("1"|"2") ]] ; then
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
einfo "OSHIT_OPT_LEVEL_OPUS=${oshit_opt_level_opus}"
einfo "OSHIT_OPT_LEVEL_RNNOISE=${oshit_opt_level_rnnoise}"
einfo "OSHIT_OPT_LEVEL_RUY=${oshit_opt_level_ruy}"
einfo "OSHIT_OPT_LEVEL_TFLITE=${oshit_opt_level_tflite}"
einfo "OSHIT_OPT_LEVEL_V8=${oshit_opt_level_v8}"
einfo "OSHIT_OPT_LEVEL_XNNPACK=${oshit_opt_level_xnnpack}"
		myconf_gn+=(
			"dav1d_custom_optimization_level=${oshit_opt_level_dav1d}"
			"libaom_custom_optimization_level=${oshit_opt_level_libaom}"
			"libvpx_custom_optimization_level=${oshit_opt_level_libvpx}"
			"openh264_custom_optimization_level=${oshit_opt_level_openh264}"
			"opus_custom_optimization_level=${oshit_opt_level_opus}"
			"rnnoise_custom_optimization_level=${oshit_opt_level_rnnoise}"
			"ruy_custom_optimization_level=${oshit_opt_level_ruy}"
			"tflite_custom_optimization_level=${oshit_opt_level_tflite}"
			"v8_custom_optimization_level=${oshit_opt_level_v8}"
			"xnnpack_custom_optimization_level=${oshit_opt_level_xnnpack}"
		)
	fi

	if use official ; then
		:
	elif is-flagq "-Ofast" ; then
# DO NOT USE
		myconf_gn+=(
			"custom_optimization_level=fast"
		)
	elif is-flagq "-O4" ; then
		myconf_gn+=(
			"custom_optimization_level=4"
		)
	elif is-flagq "-O3" ; then
		myconf_gn+=(
			"custom_optimization_level=3"
		)
	elif is-flagq "-O2" ; then
		myconf_gn+=(
			"custom_optimization_level=2"
		)
	elif is-flagq "-O1" ; then
		myconf_gn+=(
			"custom_optimization_level=1"
		)
	elif is-flagq "-O0" ; then
# DO NOT USE
		myconf_gn+=(
			"custom_optimization_level=0"
		)
	fi

	local target_cpu=$(get_target_cpu)
	myconf_gn+=(
		"current_cpu=\"${target_cpu}\""
		"host_cpu=\"${target_cpu}\""
		"target_cpu=\"${target_cpu}\""
	)
}

_configure_performance_thp() {
	if use debug ; then
		myconf_gn+=(
			"v8_enable_hugepage=false"
		)
	elif use official ; then
		: # Use automagic
	elif use kernel_linux && linux_chkconfig_present "TRANSPARENT_HUGEPAGE" ; then
		myconf_gn+=(
			"v8_enable_hugepage=true"
		)
	else
		myconf_gn+=(
			"v8_enable_hugepage=false"
		)
	fi
}

_configure_debug() {
	myconf_gn+=(
	# Disable profiling/tracing these should not be enabled in production.
#		"rtc_use_perfetto=false"
#		"v8_use_perfetto=false"

	# Disable code formating of generated files
		"blink_enable_generated_code_formatting=false"

	# Enable DCHECK with USE=debug only, increases chrome binary size by 30%, bug #811138.
	# DCHECK is fatal by default, make it configurable at runtime, #bug 807881.
		"dcheck_always_on=$(usex debug true false)"
		"dcheck_is_configurable=$(usex debug true false)"

	# GN needs explicit config for Debug/Release as opposed to inferring it from build directory.
		"is_debug=false"

	# Chromium builds provided by Linux distros should disable the testing config
		"disable_fieldtrial_testing_config=true"

	# Don't need nocompile checks and GN crashes with our config (verify with modern GN)
		"enable_nocompile_tests=false"

	# Pseudolocales are only used for testing
		"enable_pseudolocales=false"

	# Component build isn't generally intended for use by end users. It's mostly useful
	# for development and debugging.
		"is_component_build=false"
	)

	# Skipping typecheck is only supported on amd64, bug #876157
	if ! use amd64 ; then
		myconf_gn+=(
			"devtools_skip_typecheck=false"
		)
	fi

	if ! use debug ; then
		myconf_gn+=(
			"blink_symbol_level=0"
			"symbol_level=0"
			"v8_enable_vtunejit=false"
			"v8_symbol_level=0"
		)
	fi

	if has ungoogled-chromium ${IUSE_EFFECTIVE} && use ungoogled-chromium && has cromite ${IUSE_EFFECTIVE} && use cromite ; then
		TARGET_ISDEBUG=$(usex debug "true" "false")
	elif has cromite ${IUSE_EFFECTIVE} && use cromite ; then
		TARGET_ISDEBUG=$(usex debug "true" "false")
	fi
}


_configure_features() {
	# Bug 491582.
	export TMPDIR="${WORKDIR}/temp"
	mkdir -p -m 755 "${TMPDIR}" || die

	# https://bugs.gentoo.org/654216
	addpredict "/dev/dri/" #nowarn

	if use official ; then
	# Allow building against system libraries in official builds
		sed -i \
			's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' \
			"tools/generate_shim_headers/generate_shim_headers.py" \
			|| die
	fi

	# TODO 131: The above call clobbers `enable_freetype = true` in the freetype gni file
	# drop the last line, then append the freetype line and a new curly brace to end the block
	local freetype_gni="build/config/freetype/freetype.gni"
	sed -i -e '$d' "${freetype_gni}" || die
	echo "  enable_freetype = true" >> "${freetype_gni}" || die
	echo "}" >> "${freetype_gni}" || die

	# Use system-provided libraries.
	# TODO: freetype -- remove sources
	# (https://bugs.chromium.org/p/pdfium/issues/detail?id=733).
	# TODO: use_system_hunspell (upstream changes needed).
	# TODO: use_system_protobuf (bug #525560).
	# TODO: use_system_sqlite (http://crbug.com/22208).

	# libevent: https://bugs.gentoo.org/593458
	# [B] all of gn_system_libraries set
	# List obtained from /usr/share/chromium/sources/build/linux/unbundle/
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
	# We need the harfbuzz_from_pkgconfig target.
		$(use system-harfbuzz && echo "
			harfbuzz-ng
		")
		$(use system-icu && echo "
			icu
		")
		$(use system-libaom && echo "
			libaom
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

	# ld.lld: error: undefined symbol: Cr_z_adler32
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
			|| \
		use cfi \
			|| \
		use official \
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
				|| die "Failed to replace GN files for system libraries"
		fi
	fi

	myconf_gn+=(
		"enable_av1_decoder=$(usex dav1d true false)"
		"enable_dav1d_decoder=$(usex dav1d true false)"
		"enable_chrome_notifications=true"					# Depends on enable_message_center?

	# 131 began laying the groundwork for replacing freetype with
	# "Rust-based Fontations set of libraries plus Skia path rendering"
	# We now need to opt-in
		"enable_freetype=true"

		"enable_hangout_services_extension=$(usex hangouts true false)"
		"enable_hevc_parser_and_hw_decoder=$(usex patent_status_nonfree $(usex vaapi-hevc true false) false)"
		"enable_hidpi=$(usex hidpi true false)"
		"enable_libaom=$(usex libaom $(usex encode true false) false)"
		"enable_mdns=$(usex mdns true false)"
		"enable_message_center=true"						# Required for Linux, but not Fucshia and Android
		"enable_ml_internal=false"						# components/optimization_guide/internal is empty.  It is default disabled for unbranded.
		"enable_openxr=false"							# https://github.com/chromium/chromium/tree/140.0.7339.127/device/vr#platform-support
		"enable_platform_hevc=$(usex patent_status_nonfree $(usex vaapi-hevc true false) false)"
		"enable_plugins=$(usex plugins true false)"
		"enable_ppapi=false"
		"enable_reporting=$(usex reporting-api true false)"

	# Forced because of asserts.  Required by chrome/renderer:renderer
		"enable_screen_ai_service=true"

		"enable_service_discovery=true"						# Required by chrome/browser/extensions/api/BUILD.gn.  mdns may be a dependency.
#		"enable_speech_service=false"						# It is enabled but missing backend either local service or remote service.
		"enable_vr=false"							# https://github.com/chromium/chromium/blob/140.0.7339.127/device/vr/buildflags/buildflags.gni#L32
		"enable_websockets=true"						# requires devtools/devtools_http_handler.cc which is unconditionally added.
		"enable_widevine=$(usex widevine true false)"

	# Set up Google API keys, see http://www.chromium.org/developers/how-tos/api-keys
	# Note: these are for Gentoo use ONLY. For your own distribution,
	# please get your own set of keys. Feel free to contact chromium@gentoo.org for more info.
	# note: OAuth2 is patched in; check patchset for details.
		"google_api_key=\"AIzaSyDEAOvatFo0eTgsV_ZlEzx0ObmepsMzfAc\""

		"is_official_build=$(usex official true false)"

	# Link pulseaudio directly (DT_NEEDED) instead of using dlopen.
	# helps with automated detection of ABI mismatches and prevents silent errors.
		"link_pulseaudio=$(usex pulseaudio true false)"

		"media_use_libvpx=$(usex vpx true false)"
		"media_use_openh264=$(usex patent_status_nonfree $(usex openh264 true false) false)"

	# Enable ozone wayland and/or headless support
		"ozone_auto_platforms=false"

		"ozone_platform_headless=true"
		"use_minikin_hyphenation=$(usex css-hyphen true false)"
		"use_mpris=$(usex mpris true false)"

	# Enable ozone wayland and/or headless support
		"use_ozone=true"

		"use_partition_alloc=$(usex partitionalloc true false)"			# See issue 40277359

	# See dependency logic in third_party/BUILD.gn
		"use_system_harfbuzz=$(usex system-harfbuzz true false)"

		"rtc_include_opus=$(usex opus true false)"
		"rtc_use_h264=$(usex patent_status_nonfree true false)"

	# Enables building without non-free unRAR licence
		"safe_browsing_use_unrar=$(usex rar true false)"
	)

	if is_generating_credits ; then
		myconf_gn+=(
			"generate_about_credits=true"
		)
	fi

	if use headless ; then
		myconf_gn+=(
			"enable_extensions=false"
			"enable_pdf=false"
			"enable_remoting=false"
			"ozone_platform=\"headless\""
			"rtc_use_pipewire=false"
			"use_alsa=false"
			"use_atk=false"
			"use_cups=false"
			"use_gio=false"
			"use_glib=false"
			"use_kerberos=false"
			"use_libpci=false"
			"use_pangocairo=false"
			"use_pulseaudio=false"
			"use_qt5=false"
			"use_qt6=false"
			"use_udev=false"
			"use_vaapi=false"
			"use_xkbcommon=false"
			"toolkit_views=false"
		)
	else
		myconf_gn+=(
			"enable_extensions=$(usex extensions true false)"
			"enable_pdf=true" # required by chrome/browser/ui/lens:browser_tests and toolkit_views=true
			"gtk_version=$(usex gtk4 4 3)"
			"ozone_platform=$(usex wayland \"wayland\" \"x11\")"
			"ozone_platform_x11=$(usex X true false)"
			"ozone_platform_wayland=$(usex wayland true false)"
			"rtc_use_pipewire=$(usex screencast true false)"
			"toolkit_views=true"
			"use_atk=$(usex accessibility true false)"
			"use_cups=$(usex cups true false)"
			"use_kerberos=$(usex kerberos true false)"
			"use_pulseaudio=$(usex pulseaudio true false)"
			"use_qt5=false"
			"use_qt6=$(usex qt6 true false)"
			"use_system_libffi=$(usex wayland true false)"
			"use_system_minigbm=true"
			"use_vaapi=$(usex vaapi true false)"
			"use_xkbcommon=true"
		)
		if use qt6 ; then
			local cbuild_libdir=$(get_libdir)
			if tc-is-cross-compiler ; then
		# Hack to workaround get_libdir not being able to handle CBUILD, bug #794181
				cbuild_libdir="$($(tc-getBUILD_PKG_CONFIG) --keep-system-libs --libs-only-L libxslt)"
				cbuild_libdir="${cbuild_libdir:2}"
				cbuild_libdir="${cbuild_libdir/% }"
			fi
			myconf_gn+=(
				"moc_qt6_path=\"${EPREFIX}/usr/${cbuild_libdir}/qt6/libexec\""
				"use_qt6=true"
			)
		else
			myconf_gn+=(
				"use_qt6=false"
			)
		fi
	fi

	if use pdf || use cups ; then
		if use headless ; then
			myconf_gn+=(
				"enable_print_preview=false"
			)
		else
			local print_preview="${PRINT_PREVIEW:-1}"
			if [[ "${print_preview}" == "1" ]] ; then
				myconf_gn+=(
					"enable_print_preview=true"
				)
			else
				myconf_gn+=(
					"enable_print_preview=false"
				)
			fi
		fi
		myconf_gn+=(
			"enable_printing=true"
		)
	else
		myconf_gn+=(
			"enable_print_preview=false"
			"enable_printing=false"
		)
	fi

	# See https://github.com/chromium/chromium/blob/140.0.7339.127/media/media_options.gni#L19

	if use bindist ; then
	#
	# Distro maintainer notes:
	#
	# If this is set to false Chromium won't be able to load any proprietary codecs
	# even if provided with an ffmpeg capable of H.264/AAC decoding.
	#
	# Build ffmpeg as an external component (libffmpeg.so) that we can remove / substitute
	#
	#
	# oiledmachine-overlay note:
	#
	# Bindist changes are reverted to free codecs only.
	#
		myconf_gn+=(
			"is_component_ffmpeg=false"
			"ffmpeg_branding=\"Chromium\""
			"proprietary_codecs=false"
		)
	else
		ffmpeg_branding="$(usex patent_status_nonfree Chrome Chromium)"
		myconf_gn+=(
			"ffmpeg_branding=\"${ffmpeg_branding}\""
			"proprietary_codecs=$(usex patent_status_nonfree true false)"
		)
	fi

	# Disable external code space for V8 for ppc64. It is disabled for ppc64
	# by default, but cross-compiling on amd64 enables it again.
	if tc-is-cross-compiler ; then
		if ! use amd64 && ! use arm64 ; then
			myconf_gn+=(
				"v8_enable_external_code_space=false"
			)
		fi
	fi

	local myarch="$(tc-arch)"
	if use system-ffmpeg ; then
		local ffmpeg_target_arch
		if [[ "${myarch}" == "amd64" ]] ; then
			ffmpeg_target_arch="x64"
		elif [[ "${myarch}" == "x86" ]] ; then
			ffmpeg_target_arch="ia32"
		elif [[ "${myarch}" == "arm64" ]] ; then
			ffmpeg_target_arch="arm64"
		elif [[ "${myarch}" == "arm" ]] ; then
			ffmpeg_target_arch=$(usex cpu_flags_arm_neon "arm-neon" "arm")
		elif [[ "${myarch}" == "ppc64" ]] ; then
			ffmpeg_target_arch="ppc64"
		else
			die "Failed to determine target arch, got '${myarch}'."
		fi

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

	# Explicitly disable ICU data file support for system-icu/headless builds.
	if use system-icu || use headless ; then
		myconf_gn+=(
			"icu_use_data_file=false"
		)
	fi
}

_src_configure() {
	local s
	s=$(_get_s)
	cd "${s}" || die

	# Calling this here supports resumption via FEATURES=keepwork
	python-any-r1_pkg_setup

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

	local myconf_gn=()

	_configure_compiler_common
	_configure_build_system
	#_configure_linker
	#_configure_optimization_level
	#_configure_performance_pgo
	#_configure_performance_simd
	#_configure_performance_thp
	#_configure_v8
	#_configure_security
	_configure_debug
	_configure_features

	if has ungoogled-chromium ${IUSE_EFFECTIVE} && use ungoogled-chromium && has cromite ${IUSE_EFFECTIVE} && use cromite ; then
einfo "Configuring Cromite + ungoogled-chromium..."
		[[ "${ABI}" == "amd64" ]] || die "Cromite only supports ARCH=${ARCH}"
		myconf_gn+=(
			"target_os =\"linux\" "$(cat "${S_CROMITE}/build/cromite.gn_args")
			""$(cat "${S_UNGOOGLED_CHROMIUM}/flags.gn")
		)
	elif has cromite ${IUSE_EFFECTIVE} && use cromite ; then
einfo "Configuring Cromite..."
		[[ "${ABI}" == "amd64" ]] || die "Cromite only supports ARCH=${ARCH}"
		myconf_gn+=(
			"target_os =\"linux\" "$(cat "${S_CROMITE}/build/cromite.gn_args")
		)
	elif has ungoogled-chromium ${IUSE_EFFECTIVE} && use ungoogled-chromium ; then
einfo "Configuring ungoogled-chromium..."
		myconf_gn+=(
			""$(cat "${S_UNGOOGLED_CHROMIUM}/flags.gn")
		)
	else
einfo "Configuring Chromium..."
	fi
	set -- gn gen --args="${myconf_gn[*]}${EXTRA_GN:+ ${EXTRA_GN}}" "out/Release"

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
	if \
		[[ \
			"${CHROMIUM_EBUILD_MAINTAINER}" == "1" \
				&& \
			"${GEN_ABOUT_CREDITS}" == "1" \
		]] \
	; then
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
	python-any-r1_pkg_setup

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

	# If we find a way to disable mksnapshot, we can cut the build time by
	# half for non-distributed builds.
	#
	# TODO:  completely disable v8_snapshot use
	if [[ "${DISTRIBUTED_BUILD}" == "1" || "${FORCE_MKSNAPSHOT}" == "1" ]] ; then
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
	fi

	# Even though ninja autodetects number of CPUs, we respect user's
	# options, for debugging with -j 1 or any other reason.
	_eninja "out/Release" "chrome" "out/Release/chrome"
	_eninja "out/Release" "chromedriver" ""
	_eninja "out/Release" "chrome_sandbox" ""
	if use test ; then
		_eninja "out/Release" "base_unittests" ""
	fi

	# This codepath does minimal patching, so we're at the mercy of upstream
	# CFLAGS. This is fine - we're not intending to force this on users
	# and we do a lot of flag 'management' anyway.
	if ! _use_system_toolchain ; then
		QA_FLAGS_IGNORED="
			usr/lib64/chromium-browser/chrome
			usr/lib64/chromium-browser/chrome-sandbox
			usr/lib64/chromium-browser/chromedriver
			usr/lib64/chromium-browser/chrome_crashpad_handler
			usr/lib64/chromium-browser/libEGL.so
			usr/lib64/chromium-browser/libGLESv2.so
			usr/lib64/chromium-browser/libVkICD_mock_icd.so
			usr/lib64/chromium-browser/libVkLayer_khronos_validation.so
			usr/lib64/chromium-browser/libqt6_shim.so
			usr/lib64/chromium-browser/libvk_swiftshader.so
			usr/lib64/chromium-browser/libvulkan.so.1
		"
	fi

	mv "out/Release/chromedriver"{".unstripped",""} || die

	rm -f "out/Release/locales/"*".pak.info" || die

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

	# oiledmachine-overlay notes - dropped section.  Bindist is static or vendored.

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

	if ! use system-icu && ! use headless ; then
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
		"ClampTest.Death"
		"OptionalTest.DereferencingNoValueCrashes"
		"PlatformThreadTest.SetCurrentThreadTypeTest"
		"RawPtrTest.TrivialRelocability"
		"SafeNumerics.IntMaxOperations"
		"StackTraceTest.TraceStackFramePointersFromBuffer"
		"StringPieceTest.InvalidLengthDeath"
		"StringPieceTest.OutOfBoundsDeath"
		"ThreadPoolEnvironmentConfig.CanUseBackgroundPriorityForWorker"
		"ValuesUtilTest.FilePath"
		# Gentoo-specific
		"AlternateTestParams/PartitionAllocDeathTest.RepeatedAllocReturnNullDirect/0"
		"AlternateTestParams/PartitionAllocDeathTest.RepeatedAllocReturnNullDirect/1"
		"AlternateTestParams/PartitionAllocDeathTest.RepeatedAllocReturnNullDirect/2"
		"AlternateTestParams/PartitionAllocDeathTest.RepeatedAllocReturnNullDirect/3"
		"AlternateTestParams/PartitionAllocDeathTest.RepeatedReallocReturnNullDirect/0"
		"AlternateTestParams/PartitionAllocDeathTest.RepeatedReallocReturnNullDirect/1"
		"AlternateTestParams/PartitionAllocDeathTest.RepeatedReallocReturnNullDirect/2"
		"AlternateTestParams/PartitionAllocDeathTest.RepeatedReallocReturnNullDirect/3"
		"CharacterEncodingTest.GetCanonicalEncodingNameByAliasName"
		"CheckExitCodeAfterSignalHandlerDeathTest.CheckSIGFPE"
		"CheckExitCodeAfterSignalHandlerDeathTest.CheckSIGILL"
		"CheckExitCodeAfterSignalHandlerDeathTest.CheckSIGSEGV"
		"CheckExitCodeAfterSignalHandlerDeathTest.CheckSIGSEGVNonCanonicalAddress"
		"FilePathTest.FromUTF8Unsafe_And_AsUTF8Unsafe"
		"FileTest.GetInfoForCreationTime"
		"ICUStringConversionsTest.ConvertToUtf8AndNormalize"
		"NumberFormattingTest.FormatPercent"
		"PathServiceTest.CheckedGetFailure"
		"PlatformThreadTest.CanChangeThreadType"
		"RustLogIntegrationTest.CheckAllSeverity"
		"StackCanary.ChangingStackCanaryCrashesOnReturn"
		"StackTraceDeathTest.StackDumpSignalHandlerIsMallocFree"
		"SysStrings.SysNativeMBAndWide"
		"SysStrings.SysNativeMBToWide"
		"SysStrings.SysWideToNativeMB"
		"TestLauncherTools.TruncateSnippetFocusedMatchesFatalMessagesTest"
		"ToolsSanityTest.BadVirtualCallNull"
		"ToolsSanityTest.BadVirtualCallWrongType"
		"CancelableEventTest.BothCancelFailureAndSucceedOccurUnderContention" #new m133: TODO investigate
		"DriveInfoTest.GetFileDriveInfo" # New in M137: TODO investigate

		# Broken since M139 dev
		"CriticalProcessAndThreadSpotChecks/HangWatcherAnyCriticalThreadTests.AnyCriticalThreadHung/RendererProcessIsCritical"
		"CriticalProcessAndThreadSpotChecks/HangWatcherAnyCriticalThreadTests.AnyCriticalThreadHung/UtilityProcessIsCritical"
		"CriticalProcessAndThreadSpotChecks/HangWatcherAnyCriticalThreadTests.AnyCriticalThreadHung/BrowserProcessIsCritical"
		"CriticalProcessAndThreadSpotChecks/HangWatcherAnyCriticalThreadTests.AnyCriticalThreadHung/MainThreadIsCritical"
		"CriticalProcessAndThreadSpotChecks/HangWatcherAnyCriticalThreadTests.AnyCriticalThreadHung/IOThreadIsCritical"
		"CriticalProcessAndThreadSpotChecks/HangWatcherAnyCriticalThreadTests.AnyCriticalThreadHung/CompositorThreadIsCritical"
		"CriticalProcessAndThreadSpotChecks/HangWatcherAnyCriticalThreadTests.AnyCriticalThreadHung/ThreadPoolIsNotCritical"

		# M140
		"CriticalProcessAndThreadSpotChecks/HangWatcherAnyCriticalThreadTests.AnyCriticalThreadHung/GpuProcessIsCritical"
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

	if ! use headless ; then
		if use vaapi; then
	# It says 3 args:
	# https://github.com/chromium/chromium/blob/140.0.7339.127/docs/gpu/vaapi.md#vaapi-on-linux
einfo
einfo "Hardware-accelerated video decoding configuration:"
einfo
einfo "Chromium supports multiple backends for hardware acceleration. To enable one,"
einfo "Add to CHROMIUM_FLAGS in /etc/chromium/default:"
einfo
einfo "1. VA-API with OpenGL (recommended for most users):"
einfo
einfo "   --enable-features=AcceleratedVideoDecodeLinuxGL"
einfo "   VaapiVideoDecoder may need to be added as well, but try without first."
einfo
			if use wayland ; then
einfo "2. Enhanced Wayland/EGL performance:"
einfo
einfo "   --enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL"
einfo
			fi
			if use X ; then
einfo "$(usex wayland "3" "2"). VA-API with Vulkan:"
einfo
einfo "   --enable-features=VaapiVideoDecoder,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
einfo
				if use wayland ; then
einfo "   NOTE: Vulkan acceleration requires X11 and will not work under Wayland sessions."
einfo "   Use OpenGL-based acceleration instead when running under Wayland."
einfo
				fi
			fi
einfo "Additional options:"
einfo
einfo "  To enable hardware-accelerated encoding (if supported)"
einfo "  add 'AcceleratedVideoEncoder' to your feature list"
einfo "  VaapiIgnoreDriverChecks bypasses driver compatibility checks"
einfo "  (may be needed for newer/unsupported hardware)"
einfo
		else
einfo
einfo "This Chromium build was compiled without VA-API support, which provides"
einfo "hardware-accelerated video decoding."
einfo
		fi
		if use screencast; then
einfo
einfo "Screencast is disabled by default at runtime. Either enable it"
einfo "by navigating to chrome://flags/#enable-webrtc-pipewire-capturer"
einfo "inside Chromium or add --enable-features=WebRTCPipeWireCapturer"
einfo "to CHROMIUM_FLAGS in /etc/chromium/default."
einfo
		fi
		if use gtk4; then
einfo
einfo "Chromium prefers GTK3 over GTK4 at runtime. To override this"
einfo "behavior you need to pass --gtk-version=4, e.g. by adding it"
einfo "to CHROMIUM_FLAGS in /etc/chromium/default."
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
einfo "Since the build is done, you may remove /usr/share/chromium folder."
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
# OILEDMACHINE-OVERLAY-TEST: FAILED 136.0.7103.59  (20250502) - build failure
# OILEDMACHINE-OVERLAY-TEST: FAILED 135.0.7049.114 (20250430) - build failure and segfault with running mksnapshot
# OILEDMACHINE-OVERLAY-TEST: FAILED 136.0.7103.59 (20250506) - build failure and segfault with running mksnapshot
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
# -proprietary-codecs-disable-codec-developer -proprietary-codecs-disable-end-user
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
# -proprietary-codecs-disable-codec-developer -proprietary-codecs-disable-end-user
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
# -cet -cfi -css-hyphen -cups (-debug) -drumbrake -ebuild_revision_1 -encode
# -ffmpeg-chromium -firejail -gtk4 -hangouts (-headless) -hidpi -jit
# -js-type-check -kerberos -libaom -mdns -ml -mpris -official -partitionalloc
# -pax-kernel -pgo -pic -pre-check-vaapi -proprietary-codecs-disable
# -proprietary-codecs-disable-codec-developer -proprietary-codecs-disable-end-user
# (-qt5) -reporting-api -screencast (-selinux) -spelling-service -system-dav1d
# -system-ffmpeg -system-flac -system-fontconfig -system-freetype
# -system-harfbuzz -system-icu -system-libaom -system-libdrm
# -system-libjpeg-turbo -system-libpng -system-libstdcxx -system-libwebp
# -system-libxml -system-libxslt -system-openh264 -system-opus -system-re2
# (-system-toolchain) -system-zlib -system-zstd -systemd -vaapi-hevc -vorbis
# -webassembly -widevine"

# OILEDMACHINE-OVERLAY-TEST: FAILED 137.0.7151.68 (20250608) - segfaults when playing videos, browsing without videos works.  distro patches only.  no oiledmachine-overlay settings or patchset.
# CFLAGS:  Same as build scripts (-O3 or -O2).
# USE="X bundled-libcxx custom-cflags dav1d extensions gwp-asan jit miracleptr mold opus
# partitionalloc pdf plugins pulseaudio qt6 vpx wayland webassembly -accessibility -bindist
# -bluetooth -cet -cfi -css-hyphen -cups (-debug) -drumbrake -encode -ffmpeg-chromium -firejail
# -gtk4 -hangouts (-headless) -hidpi -js-type-check -kerberos -libaom -mdns -mpris -official
# -openh264 -pax-kernel -pgo -pic -pre-check-vaapi -rar -reporting-api -screencast (-selinux)
# -system-dav1d -system-ffmpeg -system-flac -system-fontconfig -system-freetype -system-harfbuzz
# (-system-icu) -system-libaom -system-libjpeg-turbo -system-libpng -system-libstdcxx
# -system-libwebp -system-libxml -system-libxslt -system-openh264 -system-opus -system-re2
# -system-zlib -system-zstd -systemd -test -ungoogled-chromium -vaapi -vaapi-hevc -vorbis -widevine"
# ABI_X86="<REDACTED>"
# CPU_FLAGS_LOONG="<REDACTED>" CPU_FLAGS_MIPS="<REDACTED>" CPU_FLAGS_RISCV="<REDACTED>"
# CPU_FLAGS_S390="<REDACTED>"
# CPU_FLAGS_X86="<REDACTED>"
# EBUILD_REVISION="-18"
# L10N="-af -am -ar -bg -bn -ca -cs -da -de -el -en-GB -en-US -es -es-419 -et -fa -fi -fil -fr -gu
# -he -hi -hr -hu -id -it -ja -kn -ko -lt -lv -ml -mr -ms -nb -nl -pl -pt-BR -pt-PT -ro -ru -sk -sl
# -sr -sv -sw -ta -te -th -tr -uk -ur -vi -zh-CN -zh-TW" PATENT_STATUS="-nonfree -sponsored_ncp_nb"
# drumbrake:  off
# pointer-compression: automagic, based on build scripts
# v8-sandbox:  automagic, based on build scripts
#
# Build time for 137.0.7151.68:
# Using distro patches only without oiledmachine-overlay patches:
# * Completion time:  2 days, 7 hrs, 33 mins, 34 secs
#
# The reason why long build time is because mksnapshot should only be enabled for distcc/goma
# builds, but disabled for most users because the costs outweigh the benefits.
#
