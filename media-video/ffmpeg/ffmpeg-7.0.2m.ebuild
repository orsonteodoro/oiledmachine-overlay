# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# 7.0.1 -> 7.0.2

#
# Subslot: libavutil_major.libavcodec_major.libavformat_major
#
# Since FFmpeg ships several libraries, subslot is kind of limited here.  Most
# consumers will use those three libraries, if a "less used" library changes its
# soname, consumers will have to be rebuilt the old way (preserve-libs).
#
# If, for example, a package does not link to libavformat and only libavformat
# changes its ABI then this package will be rebuilt needlessly. Hence, such a
# package is free _not_ to := depend on FFmpeg but I would strongly encourage
# doing so since such a case is unlikely.
#

MY_PV="${PV/m/}"
MY_P="${PN}-${MY_PV}"
MY_PVR="${PVR/m/}"

CFLAGS_HARDENED_SSP_LEVEL=3 # SSP all is upstream default
CFLAGS_HARDENED_USE_CASES="network sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE DF HO IO SO"
CUDA_TARGETS_COMPAT=(
	sm_30
	sm_60
)
FFTOOLS=(
	"aviocat"
	"cws2fws"
	"ffescape"
	"ffeval"
	"ffhash"
	"fourcc2pixfmt"
	"graph2dot"
	"ismindex"
	"pktdumper"
	"qt-faststart"
	"sidxindex"
	"trasher"
)
# Same as FFMPEG_FLAG_MAP but for encoders, i.e. they do something only with USE=encode.
FFMPEG_ENCODER_FLAG_MAP=(
	amf
	amrenc:libvo-amrwbenc
	kvazaar:libkvazaar
	libaom
	mp3:libmp3lame
	openh264:libopenh264
	rav1e:librav1e
	snappy:libsnappy
	svt-av1:libsvtav1
	theora:libtheora
	twolame:libtwolame
	webp:libwebp
	x264:libx264
	x265:libx265
	xvid:libxvid
)
# Options to use as use_enable in the foo[:bar] form.
# This will feed configure with $(use_enable foo bar)
# or $(use_enable foo foo) if no :bar is set.
# foo is added to IUSE.
FFMPEG_FLAG_MAP=(
	+bzip2:bzlib
	cpudetection:runtime-cpudetect
	debug
	gcrypt
	+gnutls
	gmp
	hardcoded-tables
	+iconv
	libxml2
	lzma
	+network opencl
	openssl
	+postproc
	rist:librist
	samba:libsmbclient
	sdl:ffplay
	sdl:sdl2
	vaapi
	vdpau
	vulkan
	X:xlib
	X:libxcb
	X:libxcb-shm
	X:libxcb-xfixes
	+zlib

	# libavdevice options
	cdio:libcdio
	iec61883:libiec61883
	ieee1394:libdc1394
	libcaca
	openal
	opengl

	# Indevs
	libv4l:libv4l2
	pulseaudio:libpulse
	libdrm
	jack:libjack

	# Decoders
	amr:libopencore-amrwb
	amr:libopencore-amrnb
	bluray:libbluray
	codec2:libcodec2
	+dav1d:libdav1d
	fdk:libfdk-aac
	jpeg2k:libopenjpeg
	jpegxl:libjxl
	gme:libgme
	gsm:libgsm
	libaribb24
	mmal
	modplug:libmodplug
	opus:libopus
	qsv:libvpl
	libilbc
	librtmp
	ssh:libssh
	speex:libspeex
	srt:libsrt
	svg:librsvg
	nvdec
	nvenc
	vorbis:libvorbis
	vpx:libvpx
	zvbi:libzvbi

	# libavfilter options
	appkit
	bs2b:libbs2b
	chromaprint
	cuda-llvm
	cuda-nvcc
	flite:libflite
	frei0r
	vmaf:libvmaf
	fribidi:libfribidi
	glslang:libglslang
	fontconfig
	ladspa
	lcms:lcms2
	libass
	libplacebo
	libquirc
	libtesseract
	lv2
	truetype:libfreetype
	truetype:libharfbuzz
	vidstab:libvidstab
	rubberband:librubberband
	shaderc:libshaderc
	zeromq:libzmq
	zimg:libzimg

	# libswresample options
	libsoxr

	# Threads.
	# We only support pthread for now but FFmpeg supports more.
	+threads:pthreads
)
FFMPEG_REVISION="${MY_PV#*_p}"
FFMPEG_SUBSLOT="59.61.61"
MULTILIB_WRAPPED_HEADERS=(
	"/usr/include/libavutil/avconfig.h"
)
N_SAMPLES=1
NV_CODEC_HEADERS_PV="9.1.23.1"
PATENT_STATUS=(
	patent_status_nonfree
)
PYTHON_COMPAT=( "python3_"{10..12} )
PYTORCH_VERSIONS=(
	"2.3.0"
	"2.2.2"
	"2.1.2"
	"2.0.1"
	"1.13.1"
)
SCM=""
SOC_PATCH="ffmpeg-rpi-6.1-r3.patch"
TRAINERS=(
	"ffmpeg_trainers_audio_cbr"
	"ffmpeg_trainers_audio_lossless"
	"ffmpeg_trainers_audio_vbr"
	"ffmpeg_trainers_av_streaming"
	"ffmpeg_trainers_video_2_pass_constrained_quality"
	"ffmpeg_trainers_video_2_pass_constrained_quality_quick"
	"ffmpeg_trainers_video_constrained_quality"
	"ffmpeg_trainers_video_constrained_quality_quick"
	"ffmpeg_trainers_video_lossless"
	"ffmpeg_trainers_video_lossless_quick"
)
TRAIN_SANDBOX_EXCEPTION_VAAPI=1
UOPTS_SUPPORT_EBOLT=1
UOPTS_SUPPORT_EPGO=1
UOPTS_SUPPORT_TBOLT=1
UOPTS_SUPPORT_TPGO=1
USE_LICENSES=(
	"gpl"
	"nonfree"
	"version3"
)
USE_GPL_ONLY=(
	"cdio"
	"dvdvideo"
	"frei0r"
	"rubberband"
	"vidstab"
	"x264"
	"x265"
	"xvid"
)
USE_GPL3_ONLY=(
	"samba"
)
USE_NONFREE_ONLY="
	"cuda-nvcc"
	"fdk"
"
USE_VERSION3_ONLY=(
	"amr"
	"gmp"
	"libaribb24"
	"liblensfun"
	"opencl" # opencl-icd-loader is Apache-2.0 but the docs say it needs it.
)
WANT_LTO=0 # Global variable not const

# Strings for CPU features in the useflag[:configure_option] form
# if :configure_option isn't set, it will use 'useflag' as configure option
ARM_CPU_FEATURES=(
	cpu_flags_arm_thumb:armv5te
	cpu_flags_arm_v6:armv6
	cpu_flags_arm_thumb2:armv6t2
	cpu_flags_arm_neon:neon
	cpu_flags_arm_vfp:vfp
	cpu_flags_arm_vfpv3:vfpv3
	cpu_flags_arm_v8:armv8
	cpu_flags_arm_asimddp:dotprod
	cpu_flags_arm_i8mm:i8mm
)
ARM_CPU_REQUIRED_USE="
	arm64? (
		cpu_flags_arm_v8
	)
	cpu_flags_arm_neon? (
		cpu_flags_arm_thumb2
		cpu_flags_arm_vfp
	)
	cpu_flags_arm_thumb2? (
		cpu_flags_arm_v6
	)
	cpu_flags_arm_v6? (
		cpu_flags_arm_thumb
	)
	cpu_flags_arm_v8? (
		cpu_flags_arm_neon
		cpu_flags_arm_vfpv3
	)
	cpu_flags_arm_vfpv3? (
		cpu_flags_arm_vfp
	)
"
MIPS_CPU_FEATURES=(
	mipsdspr1:mipsdsp
	mipsdspr2
	mipsfpu
)
PPC_CPU_FEATURES=(
	cpu_flags_ppc_altivec:altivec
	cpu_flags_ppc_vsx:vsx
	cpu_flags_ppc_vsx2:power8
)
PPC_CPU_REQUIRED_USE="
	cpu_flags_ppc_vsx? (
		cpu_flags_ppc_altivec
	)
	cpu_flags_ppc_vsx2? (
		cpu_flags_ppc_vsx
	)
"
X86_CPU_FEATURES_RAW=(
	3dnow:amd3dnow
	3dnowext:amd3dnowext
	aes:aesni
	avx:avx
	avx2:avx2
	fma3:fma3
	fma4:fma4
	mmx:mmx
	mmxext:mmxext
	sse:sse
	sse2:sse2
	sse3:sse3
	ssse3:ssse3
	sse4_1:sse4
	sse4_2:sse42
	xop:xop
)
X86_CPU_FEATURES=(
	${X86_CPU_FEATURES_RAW[@]/#/cpu_flags_x86_}
)
X86_CPU_REQUIRED_USE="
	cpu_flags_x86_avx2? (
		cpu_flags_x86_avx
	)
	cpu_flags_x86_fma4? (
		cpu_flags_x86_avx
	)
	cpu_flags_x86_fma3? (
		cpu_flags_x86_avx
	)
	cpu_flags_x86_xop?  (
		cpu_flags_x86_avx
	)
	cpu_flags_x86_avx?  (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_aes? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_sse4_2?  (
		cpu_flags_x86_sse4_1
	)
	cpu_flags_x86_sse4_1?  (
		cpu_flags_x86_ssse3
	)
	cpu_flags_x86_ssse3?  (
		cpu_flags_x86_sse3
	)
	cpu_flags_x86_sse3?  (
		cpu_flags_x86_sse2
	)
	cpu_flags_x86_sse2?  (
		cpu_flags_x86_sse
	)
	cpu_flags_x86_sse?  (
		cpu_flags_x86_mmxext
	)
	cpu_flags_x86_mmxext?  (
		cpu_flags_x86_mmx
	)
	cpu_flags_x86_3dnowext?  (
		cpu_flags_x86_3dnow
	)
	cpu_flags_x86_3dnow?  (
		cpu_flags_x86_mmx
	)
"

CPU_FEATURES_MAP=(
	${ARM_CPU_FEATURES[@]}
	${MIPS_CPU_FEATURES[@]}
	${PPC_CPU_FEATURES[@]}
	${X86_CPU_FEATURES[@]}
)
CPU_REQUIRED_USE="
	${ARM_CPU_REQUIRED_USE}
	${PPC_CPU_REQUIRED_USE}
	${X86_CPU_REQUIRED_USE}
"

# The LICENSE_REQUIRED_USE may be incomplete because of the dependency of the
#   dependency problem.  This is why portage should do license dependency tree
#   traversal checks.
# For some license compatibililty notes, see
#   https://github.com/FFmpeg/FFmpeg/blob/master/LICENSE.md#external-libraries
#   https://github.com/FFmpeg/FFmpeg/blob/master/LICENSE.md#incompatible-libraries

# +re-codecs is based on unpatched behavior to prevent breaking changes.

inherit cflags-hardened check-compiler-switch cuda flag-o-matic flag-o-matic-om llvm multilib
inherit multilib-minimal python-single-r1 toolchain-funcs uopts

if [[ "${MY_PV#9999}" == "${MY_PV}" ]] ; then
	KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390
~sparc ~x86
	"
fi
if [[ "${MY_PV#9999}" != "${MY_PV}" ]] ; then
	SCM="git-r3"
	EGIT_MIN_CLONE_TYPE="single"
	EGIT_REPO_URI="https://git.ffmpeg.org/ffmpeg.git"
fi
if [[ "${MY_PV#9999}" != "${MY_PV}" ]] ; then
	SRC_URI=""
elif [[ "${MY_PV%_p*}" != "${MY_PV}" ]] ; then # Snapshot
	SRC_URI="mirror://gentoo/${MY_P}.tar.xz"
else # Release
	VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/ffmpeg.asc"
	inherit verify-sig
	SRC_URI="
		https://ffmpeg.org/releases/${MY_P/_/-}.tar.xz
		soc? (
			https://dev.gentoo.org/~chewi/distfiles/${SOC_PATCH}.asc
		)
		verify-sig? (
			https://ffmpeg.org/releases/${MY_P/_/-}.tar.xz.asc
		)
	"
	BDEPEND+="
		soc? (
			sec-keys/openpgp-keys-gentoo-developers
		)
		verify-sig? (
			sec-keys/openpgp-keys-ffmpeg
		)
	"

	src_unpack() {
		if use verify-sig; then
			verify-sig_verify_detached \
				"${DISTDIR}/${MY_P/_/-}.tar.xz"{"",".asc"} \
				"/usr/share/openpgp-keys/ffmpeg.asc"
			if use soc ; then
				verify-sig_verify_detached \
					"${DISTDIR}/${SOC_PATCH}"{"",".asc"} \
					"/usr/share/openpgp-keys/gentoo-developers.asc"
			fi
		fi
		default
	}
fi
SRC_URI+="
	soc? (
		https://dev.gentoo.org/~chewi/distfiles/${SOC_PATCH}
	)
"
S="${WORKDIR}/${MY_P/_/-}"
S_ORIG="${WORKDIR}/${MY_P/_/-}"

DESCRIPTION="Complete solution to record/convert/stream audio and video. Includes libavcodec"
HOMEPAGE="https://ffmpeg.org/"
RESTRICT="
	!test? (
		test
	)
	fdk? (
		bindist
	)
	openssl? (
		bindist
	)
"
if [[ "${PV}" =~ "m" ]] ; then
	SLOT="${FFMPEG_SUBSLOT}"
else
	SLOT="0/${FFMPEG_SUBSLOT}"
fi
# The project license is LGPL-2.1+
# BSD - libavcodec/ilbcdec.c
LICENSE="
	BSD
	LGPL-2.1+
	gpl? (
		GPL-2+
	)
	nonfree? (
		nonfree-and-unredistributable
	)
	version3? (
		|| (
			GPL-3+
			LGPL-3+
		)
		gpl? (
			GPL-3+
		)
	)
	static-libs? (
		BSD
		BSD-2
		MIT
		ZLIB
		libcaca? (
			GPL-2
			ISC
			LGPL-2.1
			WTFPL-2
		)
		zimg? (
			WTFPL-2
		)
	)
" # This package is actually LGPL-2.1+, but certain dependencies are LGPL-2.1
# The extra licenses are for static-libs.

IUSE+="
${CPU_FEATURES_MAP[@]%:*}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${FFMPEG_ENCODER_FLAG_MAP[@]%:*}
${FFMPEG_FLAG_MAP[@]%:*}
${FFTOOLS[@]/#/+fftools_}
${PATENT_STATUS[@]}
${TRAINERS[@]}
${USE_LICENSES[@]}
alsa chromium -clear-config-first cuda cuda-filters doc dvdvideo +encode gdbm
liblensfun libqrencode mold openvino oss pgo +re-codecs sndio soc sr static-libs
tensorflow test torch v4l wayland
ebuild_revision_46
"

# The distro has frei0r-plugins as GPL-2 only but source is actually GPL-2+, GPL-3+ [baltan.cpp], LGPL-2.1+ [nois0r.cpp].
# The distro has libcdio as GPL-3 only but the source is GPL-3+, LGPL-2.1+.
# The distro has libdvdnav as GPL-2 but the source is LGPL-2.1+, GPL-2+.
# The distro has libdvdread GPL-2 GPL-3 but the source is GPL-2+ except for nav_print.c which is GPL-2.
# The distro has rtmpdump as LGPL-2.1 tools? ( GPL-2 ) but the source is LGPL-2.1+ tools? ( GPL-2+ ).
# The distro has rubberband as GPL-2 only but the source is GPL-2+.
# The distro has samba as GPL-3 only but the source is GPL-3+.
# The distro has twolame as GPL-2 only but the source is LGPL-2.1+.
# The distro has x264 as GPL-2 only but the source is GPL-2+.
# The distro has x265 as GPL-2 only but the source is GPL-2+.
# The distro has xvid as GPL-2 only but the source is GPL-2+.

# configure puts libdvdnav and libdvdread both under GPL-2.

# dav1d is BSD-2
# MPL-2.0 is indirect compatible with the GPL-2, LGPL-2.1 -- with exceptions.  \
#   For details see: https://www.gnu.org/licenses/license-list.html#MPL-2.0
# GPL_REQUIRED_USE moved to LICENSE_REQUIRED_USE
# FIXME: fix missing symbols with -re-codecs

gen_required_use_gpl_only() {
	local u
	for u in ${USE_GPL_ONLY[@]} ; do
		echo "
			${u}? (
				gpl
			)
		"
	done
}
gen_required_use_gpl3_only() {
	local u
	for u in ${USE_GPL3_ONLY[@]} ; do
		echo "
			${u}? (
				gpl
				version3
			)
		"
	done
}
gen_required_use_nonfree_only() {
	local u
	for u in ${USE_NONFREE_ONLY[@]} ; do
		echo "
			${u}? (
				nonfree
			)
		"
	done
}
gen_required_use_version3() {
	local u
	for u in ${USE_VERSION3_ONLY[@]} ; do
		echo "
			${u}? (
				version3
			)
		"
	done
}

REQUIRED_USE_LICENSES="
	$(gen_required_use_gpl_only)
	$(gen_required_use_gpl3_only)
	$(gen_required_use_nonfree_only)
	$(gen_required_use_version3)
"

PATENT_REQUIRED_USE="
	!patent_status_nonfree? (
		!amf
		!cuda
		!fdk
		!kvazaar
		!mmal
		!nvenc
		!nvdec
		!openh264
		!qsv
		!vaapi
		!vdpau
		!vulkan
		!x264
		!x265
	)
	amf? (
		patent_status_nonfree
	)
	cuda? (
		patent_status_nonfree
	)
	fdk? (
		patent_status_nonfree
	)
	kvazaar? (
		patent_status_nonfree
	)
	mmal? (
		patent_status_nonfree
	)
	nvdec? (
		patent_status_nonfree
	)
	nvdec? (
		patent_status_nonfree
	)
	openh264? (
		patent_status_nonfree
	)
	qsv? (
		patent_status_nonfree
	)
	vaapi? (
		patent_status_nonfree
	)
	vdpau? (
		patent_status_nonfree
	)
	vulkan? (
		patent_status_nonfree
	)
	x264? (
		patent_status_nonfree
	)
	x265? (
		patent_status_nonfree
	)
"

REQUIRED_USE+="
	!soc
	${CPU_REQUIRED_USE}
	${PATENT_REQUIRED_USE}
	${REQUIRED_USE_LICENSES}
	!kernel_linux? (
		!ffmpeg_trainers_av_streaming
	)
	chromium? (
		opus
	)
	cuda? (
		|| (
			cuda-filters
			nvdec
			nvenc
		)
	)
	cuda-filters? (
		^^ (
			cuda-llvm
			cuda-nvcc
		)
		cuda
	)
	cuda-llvm? (
		cuda-filters
		cuda_targets_sm_30
	)
	cuda-nvcc? (
		cuda-filters
		cuda_targets_sm_60
	)
	cuda_targets_sm_30? (
		cuda
		cuda-llvm
	)
	cuda_targets_sm_60? (
		cuda
		cuda-nvcc
	)
	fftools_cws2fws? (
		zlib
	)
	glslang? (
		!shaderc
		vulkan
	)
	gnutls? (
		!openssl
	)
	libplacebo? (
		sdl? (
			vulkan
		)
	)
	libv4l? (
		v4l
	)
	shaderc? (
		!glslang
		vulkan
	)
	nvdec? (
		cuda
	)
	nvenc? (
		cuda
	)
	openssl? (
		!gnutls
	)
	pgo? (
		|| (
			ffmpeg_trainers_audio_cbr
			ffmpeg_trainers_audio_lossless
			ffmpeg_trainers_audio_vbr
			ffmpeg_trainers_av_streaming
			ffmpeg_trainers_video_2_pass_constrained_quality
			ffmpeg_trainers_video_2_pass_constrained_quality_quick
			ffmpeg_trainers_video_constrained_quality
			ffmpeg_trainers_video_constrained_quality_quick
			ffmpeg_trainers_video_lossless
			ffmpeg_trainers_video_lossless_quick
		)
	)
	soc? (
		libdrm
	)
	test? (
		encode
	)
	ffmpeg_trainers_audio_cbr? (
		pgo
	)
	ffmpeg_trainers_audio_lossless? (
		pgo
	)
	ffmpeg_trainers_audio_vbr? (
		pgo
	)
	ffmpeg_trainers_av_streaming? (
		encode
		kernel_linux
		pgo
		|| (
			openh264
			opus
			rav1e
			svt-av1
			theora
			vaapi
			vorbis
			vpx
			x264
			x265
		)
	)
	ffmpeg_trainers_video_2_pass_constrained_quality? (
		pgo
	)
	ffmpeg_trainers_video_2_pass_constrained_quality_quick? (
		pgo
	)
	ffmpeg_trainers_video_constrained_quality? (
		pgo
	)
	ffmpeg_trainers_video_constrained_quality_quick? (
		pgo
	)
	ffmpeg_trainers_video_lossless? (
		pgo
	)
	ffmpeg_trainers_video_lossless_quick? (
		pgo
	)
"

gen_pytorch_rdepend() {
	local ver
	for ver in ${PYTORCH_VERSIONS[@]} ; do
		echo "
			(
				sys-devel/gcc[cxx]
				~sci-ml/pytorch-${ver}[${PYTHON_SINGLE_USEDEP}]
				~sci-ml/caffe2-${ver}[${PYTHON_SINGLE_USEDEP}]
			)
		"
	done
}

# Only vaapi_x11 and vaapi_drm checks.  No vaapi_wayland checks in configure.
# Update both !openssl and openssl USE flags.
RDEPEND+="
	virtual/patent-status[patent_status_nonfree=]
	!openssl? (
		gnutls? (
			>=net-libs/gnutls-2.12.23-r6:=[${MULTILIB_USEDEP}]
		)
	)
	alsa? (
		>=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}]
	)
	amf? (
		media-video/amdgpu-pro-amf:=
	)
	amr? (
		>=media-libs/opencore-amr-0.1.3-r1[${MULTILIB_USEDEP}]
	)
	bluray? (
		>=media-libs/libbluray-0.3.0-r1:=[${MULTILIB_USEDEP}]
	)
	bs2b? (
		>=media-libs/libbs2b-3.1.0-r1[${MULTILIB_USEDEP}]
	)
	bzip2? (
		>=app-arch/bzip2-1.0.6-r4[${MULTILIB_USEDEP}]
	)
	cdio? (
		>=dev-libs/libcdio-paranoia-0.90_p1-r1[${MULTILIB_USEDEP}]
	)
	chromaprint? (
		>=media-libs/chromaprint-1.2-r1[${MULTILIB_USEDEP}]
	)
	codec2? (
		media-libs/codec2[${MULTILIB_USEDEP}]
	)
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
		x11-drivers/nvidia-drivers
	)
	cuda-nvcc? (
		cuda_targets_sm_60? (
			|| (
				=dev-util/nvidia-cuda-toolkit-11*:=
				=dev-util/nvidia-cuda-toolkit-12*:=
			)
		)
	)
	dav1d? (
		>=media-libs/dav1d-0.5.0:0=[${MULTILIB_USEDEP}]
	)
	dvdvideo? (
		>=media-libs/libdvdnav-6.1.1[${MULTILIB_USEDEP}]
		>=media-libs/libdvdread-6.1.2[${MULTILIB_USEDEP}]
	)
	encode? (
		amrenc? (
			>=media-libs/vo-amrwbenc-0.1.2-r1[${MULTILIB_USEDEP}]
		)
		kvazaar? (
			>=media-libs/kvazaar-2.0.0[${MULTILIB_USEDEP}]
		)
		mp3? (
			>=media-sound/lame-3.99.5-r1[${MULTILIB_USEDEP}]
		)
		openh264? (
			>=media-libs/openh264-1.3.0:=[${MULTILIB_USEDEP}]
		)
		rav1e? (
			>=media-video/rav1e-0.5:=[capi]
		)
		snappy? (
			>=app-arch/snappy-1.1.2-r1:=[${MULTILIB_USEDEP}]
		)
		theora? (
			>=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}]
			>=media-libs/libtheora-1.1.1[${MULTILIB_USEDEP},encode]
		)
		twolame? (
			>=media-sound/twolame-0.3.13-r1[${MULTILIB_USEDEP}]
		)
		webp? (
			>=media-libs/libwebp-0.3.0:=[${MULTILIB_USEDEP}]
		)
		x264? (
			>=media-libs/x264-0.0.20130506:=[${MULTILIB_USEDEP}]
		)
		x265? (
			>=media-libs/x265-1.6:=[${MULTILIB_USEDEP}]
		)
		xvid? (
			>=media-libs/xvid-1.3.2-r1[${MULTILIB_USEDEP}]
		)
	)
	fdk? (
		>=media-libs/fdk-aac-0.1.3:=[${MULTILIB_USEDEP}]
	)
	flite? (
		>=app-accessibility/flite-1.4-r4[${MULTILIB_USEDEP}]
	)
	fontconfig? (
		>=media-libs/fontconfig-2.10.92[${MULTILIB_USEDEP}]
	)
	frei0r? (
		media-plugins/frei0r-plugins[${MULTILIB_USEDEP}]
	)
	fribidi? (
		>=dev-libs/fribidi-0.19.6[${MULTILIB_USEDEP}]
	)
	gcrypt? (
		>=dev-libs/libgcrypt-1.6:0=[${MULTILIB_USEDEP}]
	)
	glslang? (
		dev-util/glslang:=[${MULTILIB_USEDEP}]
		dev-util/spirv-tools:=[${MULTILIB_USEDEP}]
	)
	gme? (
		>=media-libs/game-music-emu-0.6.0[${MULTILIB_USEDEP}]
	)
	gmp? (
		>=dev-libs/gmp-6:0=[${MULTILIB_USEDEP}]
	)
	gsm? (
		>=media-sound/gsm-1.0.13-r1[${MULTILIB_USEDEP}]
	)
	iconv? (
		>=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
	)
	iec61883? (
		>=media-libs/libiec61883-1.2.0-r1[${MULTILIB_USEDEP}]
		>=sys-libs/libavc1394-0.5.4-r1[${MULTILIB_USEDEP}]
		>=sys-libs/libraw1394-2.1.0-r1[${MULTILIB_USEDEP}]
	)
	ieee1394? (
		>=media-libs/libdc1394-2.2.1:2=[${MULTILIB_USEDEP}]
		>=sys-libs/libraw1394-2.1.0-r1[${MULTILIB_USEDEP}]
	)
	jack? (
		virtual/jack[${MULTILIB_USEDEP}]
	)
	jpeg2k? (
		>=media-libs/openjpeg-2.1:2[${MULTILIB_USEDEP}]
	)
	jpegxl? (
		>=media-libs/libjxl-0.7.0:=[$MULTILIB_USEDEP]
	)
	lcms? (
		>=media-libs/lcms-2.13:2[$MULTILIB_USEDEP]
	)
	libaom? (
		>=media-libs/libaom-1.0.0-r1:=[${MULTILIB_USEDEP}]
	)
	libaribb24? (
		>=media-libs/aribb24-1.0.3-r2[${MULTILIB_USEDEP}]
	)
	libass? (
		>=media-libs/libass-0.11.0:=[${MULTILIB_USEDEP}]
	)
	libcaca? (
		>=media-libs/libcaca-0.99_beta18-r1[${MULTILIB_USEDEP}]
	)
	libdrm? (
		x11-libs/libdrm[${MULTILIB_USEDEP}]
	)
	libilbc? (
		>=media-libs/libilbc-2[${MULTILIB_USEDEP}]
	)
	liblensfun? (
		media-libs/lensfun
	)
	libplacebo? (
		>=media-libs/libplacebo-4.192.0[$MULTILIB_USEDEP,vulkan?]
	)
	libquirc? (
		media-libs/quirc[${MULTILIB_USEDEP}]
	)
	libqrencode? (
		media-gfx/qrencode
	)
	librtmp? (
		>=media-video/rtmpdump-2.4_p20131018[${MULTILIB_USEDEP}]
	)
	libsoxr? (
		>=media-libs/soxr-0.1.0[${MULTILIB_USEDEP}]
	)
	libtesseract? (
		>=app-text/tesseract-4.1.0-r1[${MULTILIB_USEDEP}]
	)
	libv4l? (
		>=media-libs/libv4l-0.9.5[${MULTILIB_USEDEP}]
	)
	libxml2? (
		dev-libs/libxml2:=[${MULTILIB_USEDEP}]
	)
	lv2? (
		media-libs/lilv[${MULTILIB_USEDEP}]
		media-libs/lv2[${MULTILIB_USEDEP}]
	)
	lzma? (
		>=app-arch/xz-utils-5.0.5-r1[${MULTILIB_USEDEP}]
	)
	mmal? (
		media-libs/raspberrypi-userland
	)
	modplug? (
		>=media-libs/libmodplug-0.8.8.4-r1[${MULTILIB_USEDEP}]
	)
	network? (
		elibc_glibc? (
			sys-libs/glibc[nscd]
		)
	)
	openal? (
		>=media-libs/openal-1.15.1[${MULTILIB_USEDEP}]
	)
	opencl? (
		virtual/opencl[${MULTILIB_USEDEP}]
	)
	opengl? (
		media-libs/libglvnd[X,${MULTILIB_USEDEP}]
	)
	openssl? (
		>=dev-libs/openssl-3.0.0_beta2:0=[${MULTILIB_USEDEP}]
	)
	openvino? (
		>=sci-ml/openvino-2020.1[${PYTHON_SINGLE_USEDEP}]
		<sci-ml/openvino-2022[${PYTHON_SINGLE_USEDEP}]
	)
	opus? (
		>=media-libs/opus-1.0.2-r2[${MULTILIB_USEDEP}]
	)
	pulseaudio? (
		media-libs/libpulse[${MULTILIB_USEDEP}]
	)
	qsv? (
		media-libs/oneVPL[${MULTILIB_USEDEP}]
	)
	rist? (
		>=net-libs/librist-0.2.7[${MULTILIB_USEDEP}]
	)
	rubberband? (
		>=media-libs/rubberband-1.8.1-r1[${MULTILIB_USEDEP}]
	)
	samba? (
		>=net-fs/samba-3.6.23-r1[${MULTILIB_USEDEP},client]
	)
	sdl? (
		<media-libs/libsdl2-3[${MULTILIB_USEDEP},sound,threads(+),video,wayland?,X?]
	)
	shaderc? (
		>=media-libs/shaderc-2019.1[${MULTILIB_USEDEP}]
	)
	sndio? (
		media-sound/sndio:=[${MULTILIB_USEDEP}]
	)
	soc? (
		virtual/libudev:=[${MULTILIB_USEDEP}]
	)
	speex? (
		>=media-libs/speex-1.2_rc1-r1[${MULTILIB_USEDEP}]
	)
	srt? (
		>=net-libs/srt-1.3.0:=[${MULTILIB_USEDEP}]
	)
	ssh? (
		>=net-libs/libssh-0.6.0:=[${MULTILIB_USEDEP},sftp]
	)
	svg? (
		gnome-base/librsvg:2=[${MULTILIB_USEDEP}]
		x11-libs/cairo[${MULTILIB_USEDEP}]
	)
	svt-av1? (
		>=media-libs/svt-av1-0.9.0[${MULTILIB_USEDEP}]
	)
	tensorflow? (
		>=sci-ml/tensorflow-2[${PYTHON_SINGLE_USEDEP}]
	)
	torch? (
		|| (
			$(gen_pytorch_rdepend)
		)
	)
	truetype? (
		>=media-libs/freetype-2.5.0.1:2[${MULTILIB_USEDEP}]
		media-libs/harfbuzz:=[${MULTILIB_USEDEP}]
	)
	vaapi? (
		>=media-libs/libva-1.2.1-r1:0=[${MULTILIB_USEDEP},drm(+),X?]
		media-libs/vaapi-drivers[${MULTILIB_USEDEP},patent_status_nonfree=]
	)
	vdpau? (
		>=x11-libs/libvdpau-0.7[${MULTILIB_USEDEP}]
	)
	vidstab? (
		>=media-libs/vidstab-1.1.0[${MULTILIB_USEDEP}]
	)
	vmaf? (
		>=media-libs/libvmaf-2.0.0[${MULTILIB_USEDEP}]
	)
	vorbis? (
		>=media-libs/libvorbis-1.3.3-r1[${MULTILIB_USEDEP}]
		>=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}]
	)
	vpx? (
		>=media-libs/libvpx-1.4.0:=[${MULTILIB_USEDEP}]
	)
	vulkan? (
		>=media-libs/vulkan-loader-1.3.277:=[${MULTILIB_USEDEP}]
		media-libs/vulkan-drivers[${MULTILIB_USEDEP}]
	)
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libxcb-1.4:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXv-1.0.10[${MULTILIB_USEDEP}]
	)
	postproc? (
		!media-libs/libpostproc
	)
	zeromq? (
		>=net-libs/zeromq-4.2.1
	)
	zimg? (
		>=media-libs/zimg-2.7.4:=[${MULTILIB_USEDEP}]
	)
	zlib? (
		>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	)
	zvbi? (
		>=media-libs/zvbi-0.2.35[${MULTILIB_USEDEP}]
	)
"
DEPEND+="
	amf? (
		media-libs/amf-headers
	)
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
		media-libs/nv-codec-headers:=
	)
	ladspa? (
		>=media-libs/ladspa-sdk-1.13-r2[${MULTILIB_USEDEP}]
	)
	v4l? (
		sys-kernel/linux-headers
	)
	vulkan? (
		>=dev-util/vulkan-headers-1.3.255
	)
"
# += for verify-sig above
# >= 2.0 mold is used to avoid licensing/legal issues.
BDEPEND+="
	>=dev-build/make-3.81
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	dev-util/patchelf
	cpu_flags_x86_mmx? (
		|| (
			>=dev-lang/nasm-2.13
			>=dev-lang/yasm-1.3
		)
	)
	cuda-llvm? (
		>=llvm-core/clang-7[llvm_targets_NVPTX]
	)
	doc? (
		sys-apps/texinfo
	)
	mold? (
		>=sys-devel/mold-2.0
	)
	test? (
		app-alternatives/bc
		net-misc/wget
	)
	ffmpeg_trainers_av_streaming? (
		vaapi? (
			>=media-libs/libva-1.2.1-r1:0=[${MULTILIB_USEDEP},drm(+),X]
			media-video/libva-utils[vainfo]
			media-libs/vaapi-drivers[${MULTILIB_USEDEP},patent_status_nonfree?]
		)
	)
"
PDEPEND+="
	pgo? (
		media-video/ffmpeg[encode,${MULTILIB_USEDEP}]
	)
	sr? (
		media-video/sr
	)
"
PATCHES=(
	"${FILESDIR}/chromium-r2.patch"
#	"${FILESDIR}/${PN}-6.1-wint-conversion.patch"
#	"${FILESDIR}/${PN}-6.0-fix-lto-type-mismatch.patch"
	"${FILESDIR}/${PN}-6.1-opencl-parallel-gmake-fix.patch"
##	"${FILESDIR}/${PN}-6.1-gcc-14.patch"
#	"${FILESDIR}/${PN}-6.0.1-alignment.patch"
#	"${FILESDIR}/${PN}-6.1.1-vulkan-rename.patch"
#	"${FILESDIR}/${PN}-6.1.1-memory-leak.patch"
	"${FILESDIR}/extra-patches/${PN}-5.1.2-allow-7regs.patch"			# Added by oiledmachine-overlay
	"${FILESDIR}/extra-patches/${PN}-5.1.2-configure-non-free-options.patch"	# Added by oiledmachine-overlay
	"${FILESDIR}/extra-patches/${PN}-4.4.4-no-m32-or-m64-for-nvcc.patch"
	"${FILESDIR}/extra-patches/${PN}-7.1-add-includes-hwcontext_vulkan.patch"
	"${FILESDIR}/extra-patches/${PN}-7.0.2-glslang-fix-configure-test.patch"
)

get_av_device_ids() {
	local types=(
		AV_DEVICE
		AV_MICROPHONE
	)
	local t
	for t in ${types[@]} ; do
		local i
		for i in $(seq 0 ${FFMPEG_TRAINING_MAX_ASSETS_PER_TYPE}) ; do
			echo "FFMPEG_TRAINING_${t}_${i}"
		done
	done
	if use tensorflow ; then
		insinto "/usr/share/${PN}/scripts"
		local L=(
			"tf_sess_config.py"
		)
		doins ${L[@]}
		fperms 0775 ${L[@]}
	fi
}

get_video_sample_ids() {
	local types=(
		VIDEO_CGI
		VIDEO_FANTASY
		VIDEO_GAMING
		VIDEO_GRAINY
		VIDEO_REALISM
		VIDEO_SCREENCAST
	)
	local t
	for t in ${types[@]} ; do
		local i
		for i in $(seq 0 ${FFMPEG_TRAINING_MAX_ASSETS_PER_TYPE}) ; do
			echo "FFMPEG_TRAINING_${t}_${i}"
		done
	done
}

get_audio_sample_ids() {
	local types=(
		VOICE
		RADIO
		MUSIC_INSTRUMENTAL
		VOCAL_MUSIC
	)
	local t
	for t in ${types[@]} ; do
		local i
		for i in $(seq 0 ${FFMPEG_TRAINING_MAX_ASSETS_PER_TYPE}) ; do
			echo "FFMPEG_TRAINING_AUDIO_${t}_${i}"
		done
	done
}

_pgo_check_video() {
	if [[ -z "${video_sample_path}" ]] ; then
eerror
eerror "${id} is missing the abspath to your video as a per-package environment"
eerror "variable."
eerror
#eerror "The video must be 3840x2160 resolution, 60fps, >= 5 seconds."
#eerror
		die
	fi
	if ffprobe "${video_sample_path}" 2>/dev/null 1>/dev/null ; then
einfo "Verifying asset requirements"
		if false && ! ( \
			ffprobe \
				"${video_sample_path}" \
				2>&1 \
				| grep -q -e "3840x2160" \
			) \
		; then
eerror
eerror "The PGO video sample must be 3840x2160 for ${id}."
eerror
			die
		fi
		if false && ! ( \
			ffprobe \
				"${video_sample_path}" \
				2>&1 \
				| grep -q -E -e ", (59|60)[.0-9]* fps" \
			) \
		; then
eerror
eerror "The PGO video sample must be >=59 fps for ${id}."
eerror
			die
		fi

		local d=$(ffprobe "${video_sample_path}" 2>&1 \
			| grep -E -e "Duration" \
			| cut -f 4 -d " " \
			| sed -e "s|,||g" \
			| cut -f 1 -d ".")
		local h=$(($(echo "${d}" \
			| cut -f 1 -d ":") * 60 * 60))
		local m=$(($(echo "${d}" \
			| cut -f 2 -d ":") * 60))
		local s=$(($(echo "${d}" \
			| cut -f 3 -d ":") * 1))
		local t=$((${h} + ${m} + ${s}))
		if (( ${t} < 5 )) ; then
eerror
eerror "The PGO video sample must be >= 5 seconds for ${id}."
eerror
			die
		else
einfo "${video_sample_path} is accepted as a trainer asset for ${id}."
		fi
	else
eerror
eerror "${video_sample_path} is possibly not a valid video file.  Ensure that"
eerror "the proper codec is supported for that file in ${PN}."
eerror
	fi
}

pgo_check_video() {
	local id
	for id in $(get_video_sample_ids) ; do
		local video_sample_path="${!id}"
		[[ -e "${video_sample_path}" ]] || continue
		if [[ -z "${video_sample_path}" ]] ; then
#ewarn "Skipping ${id}."
			continue
		fi
		if [[ ! -f "${video_sample_path}" ]] ; then
ewarn "Skipping ${id} asset with no asset located at ${video_sample_path}."
			continue
		fi
		_pgo_check_video
	done
}

pgo_check_audio() {
	local id
	for id in $(get_audio_sample_ids) ; do
		local audio_sample_path="${!id}"
		[[ -e "${audio_sample_path}" ]] || continue
		if [[ -z "${audio_sample_path}" ]] ; then
ewarn "Skipping ${id}."
			continue
		fi
		if [[ ! -f "${audio_sample_path}" ]] ; then
ewarn "Skipping ${id} asset with no asset located at ${audio_sample_path}."
			continue
		fi
		if ffprobe "${audio_sample_path}" 2>/dev/null 1>/dev/null ; then
einfo "Verifying asset requirements"
			local d=$(ffprobe "${audio_sample_path}" 2>&1 \
				| grep -E -e "Duration" \
				| cut -f 4 -d " " \
				| sed -e "s|,||g" \
				| cut -f 1 -d ".")
			local h=$(($(echo "${d}" \
				| cut -f 1 -d ":") * 60 * 60))
			local m=$(($(echo "${d}" \
				| cut -f 2 -d ":") * 60))
			local s=$(($(echo "${d}" \
				| cut -f 3 -d ":") * 1))
			local t=$((${h} + ${m} + ${s}))
			if (( ${t} < 30 )) ; then
eerror
eerror "The PGO audio sample must be >= 30 seconds."
eerror
				die
			fi
einfo "${audio_sample_path} is accepted as a trainer asset."
		else
eerror
eerror "${id} is possibly not a valid audio file.  Ensure that"
eerror "the proper codec is supported for that file in ${PN}."
eerror
		fi
	done
}

_pgo_check_av() {
	! use ffmpeg_trainers_av_streaming && return
	if [[ -z "${capture_path}" ]] ; then
eerror
eerror "${id} is missing the abspath to your capture device as a per-package"
eerror "environment variable."
eerror
		die
	fi
	if ! ffprobe "${capture_path}" 2>/dev/null 1>/dev/null ; then
eerror
eerror "Capture device is not working.  Disable or remove ${id}."
eerror
		die
	else
einfo "${capture_path} is accepted as a training device for ${id}."
	fi
	if ! [[ "${capture_path}" =~ "/dev/video" ]] ; then
		:;
	elif grep -q "^video:.*portage" "${EROOT}/etc/group" ; then
		:;
	elif which getfacl 2>/dev/null 1>/dev/null \
		&& getfacl "${capture_path}" \
		| grep -q "user:portage:rw" ; then
		:;
	else
eerror
eerror "A change in permissions is required:"
eerror
eerror "\`gpasswd -a portage video\`                    # to add portage to the video group."
eerror
eerror " or"
eerror
eerror "\`setfacl -m user:portage:rw ${capture_path}\`  # to set ACL permission of file."
eerror
		die
	fi
}

pgo_check_av() {
	local id
	for id in $(get_av_device_ids) ; do
		local capture_path="${!id}"
		[[ -e "${capture_path}" ]] || continue
		if [[ -z "${capture_path}" ]] ; then
#ewarn "Skipping ${id}."
			continue
		fi
		if [[ ! -e "${capture_path}" ]] ; then
ewarn "Skipping ${id} device with no device located at ${capture_path}."
			continue
		fi
		_pgo_check_av
	done
}

eprintf() {
	local format="%30s : %-s"
	printf " \e[32m*\e[0m ${format}\n" "$@"
}

pkg_setup() {
	check-compiler-switch_start
	if [[ "${PV}" =~ "m" ]] ; then
ewarn
ewarn "You are installing a multislot ${PN} designed for indirect use."
ewarn "For direct use with /usr/bin/${PN} use the unislot version."
ewarn
	fi
	python_setup
	FFMPEG_TRAINING_MAX_ASSETS_PER_TYPE=${FFMPEG_TRAINING_MAX_ASSETS_PER_TYPE:-100} # You must update gen_autosample_suffix
	if use pgo && has_version "media-video/ffmpeg" ; then
ewarn "The PGO use flag is a Work In Progress (WIP)"
		if [[ -n "${FFMPEG_TRAINING_VIDEO_CODECS}" ]] ; then
			pgo_check_video
		fi
		if [[ -n "${FFMPEG_TRAINING_AUDIO_CODECS}" ]] ; then
			pgo_check_audio
		fi
		if [[ -n "${FFMPEG_TRAINING_AV_CODECS}" ]] ; then
			pgo_check_av
		fi
	fi
	llvm_pkg_setup
	uopts_setup

	if use ffmpeg_trainers_av_streaming ; then
		if false \
			&& ! grep -q "register_sanitize_hook" \
				$(realpath "${EROOT}/usr/lib/portage/"*"/bashrc-functions.sh") ; then
eerror
eerror "You need to use either:"
eerror
eerror "emerge -1v =sys-apps/portage::oiledmachine-overlay"
eerror
eerror "  or"
eerror
eerror "copy the portage-3.0.30-sanitize-hooks.patch to"
eerror "/etc/portage/patches/${CATEGORY}/portage"
eerror
			die
		fi
ewarn
ewarn "ffmpeg_trainers_av_streaming is WIP"
ewarn "Do not use until hooks for (secure) _wipe_data callbacks are fixed."
ewarn

ewarn
ewarn "Please read"
ewarn
ewarn "metadata.xml in this package folder"
ewarn
ewarn "  or"
ewarn
ewarn "\`epkginfo -x =${CATEGORY}/${P}::oiledmachine-overlay\`"
ewarn
ewarn "to see the security risk/implications involved in this kind of training"
ewarn "and to mitigate against sensitive data leaks."
ewarn
		sleep 15
	fi

	if use ffmpeg_trainers_av_streaming \
		&& ( has pid-sandbox ${FEATURES} || has ipc-sandbox ${FEATURES} ) ; then
eerror
eerror "You must disable the pid-sandbox and ipc-sandbox on a per-package"
eerror "level for the USE=ffmpeg_trainers_av_streaming for screencast PGO/BOLT"
eerror "training."
eerror
eerror "pid-sandbox is required for checking if X11 is being used."
eerror "ipc-sandbox is required for x11grab."
eerror
eerror "Add a per-package environment rule with the following additions or"
eerror "changes..."
eerror
eerror "${EROOT}/etc/portage/env/no-pid-sandbox.conf:"
eerror "FEATURE=\"\${FEATURES} -pid-sandbox\""
eerror
eerror "${EROOT}/etc/portage/env/no-ipc-sandbox.conf:"
eerror "FEATURE=\"\${FEATURES} -ipc-sandbox\""
eerror
eerror "${EROOT}/etc/portage/package.env:"
eerror "${CATEGORY}/${PN} no-pid-sandbox.conf no-ipc-sandbox.conf"
eerror
		die
	fi

	local pid="$$"
eprintf "PID" "${pid}"
	local display=$(grep -z "^DISPLAY=" "/proc/${pid}/environ" \
		| tr -d '\0' \
		| cut -f 2 -d "=")
eprintf "DISPLAY" "${display}"
	if use ffmpeg_trainers_av_streaming \
		&& ( use pgo || use bolt ) \
		&& [[ -z "${display}" ]] ; then
eerror
eerror "You must run X to do GPU based PGO/BOLT training."
eerror
		die
	fi

	if use ffmpeg_trainers_av_streaming \
		&& ( use pgo || use bolt ) \
		&& ! ( DISPLAY="${TRAIN_DISPLAY:-${display}}" xhost \
			| grep -q -e "LOCAL:" ) ; then
eerror
eerror "You must do:  \`xhost +local:root:\` to do GPU based PGO/BOLT training."
eerror
		die
	fi

	# ffmpeg[chromaprint] depends on chromaprint, and chromaprint[tools] depends on ffmpeg.
	# May cause breakage while updating, #862996, #625210, #833821.
	if has_version media-libs/chromaprint[tools] && use chromaprint ; then
ewarn
ewarn "You have media-libs/chromaprint installed with 'tools' USE flag, which "
ewarn "links to ffmpeg, and you have enabled 'chromaprint' USE flag for ffmpeg, "
ewarn "which links to chromaprint. This may cause issues while rebuilding ffmpeg."
ewarn
ewarn "If your build fails to 'ERROR: chromaprint not found', rebuild chromaprint "
ewarn "without the 'tools' use flag first, then rebuild ffmpeg, and then finally enable "
ewarn "'tools' USE flag for chromaprint. See #862996."
ewarn
	fi

#
# BFD LTO with GCC:
#
# ld.lld: warning: multiple common of __gnu_lto_slim
# ld.lld: warning: multiple common of __gnu_lto_slim
# ld.lld: warning: multiple common of __gnu_lto_slim
# ld.lld: error: undefined symbol: main
# >>> referenced by /usr/lib/gcc/x86_64-pc-linux-gnu/11.3.0/../../../../lib/Scrt1.o:(_start)
#
	if is-flagq '-flto*' ; then
ewarn
ewarn "Do not use the BFD linker for LTO.  Use either Gold LTO or"
ewarn "Thin LTO only."
ewarn
	fi
}

# The order does matter with PGO.
get_lib_types() {
	echo "shared"
	use static-libs && echo "static"
}

verify_subslot() {
	local c0=$(grep -e "LIBAVUTIL_VERSION_MAJOR" "${S}/libavutil/version.h" \
		| head -n 1 \
		| awk '{print $3}')
	local c1=$(grep -r -e "LIBAVCODEC_VERSION_MAJOR" "${S}/libavcodec/version_major.h" \
		| head -n 1 \
		| awk '{print $3}')
	local c2=$(grep -r -e "LIBAVFORMAT_VERSION_MAJOR" "${S}/libavformat/version_major.h" \
		| head -n 1 \
		| awk '{print $3}')
	local actual_subslot="${c0}.${c1}.${c2}"
	if [[ "${actual_subslot}" != "${FFMPEG_SUBSLOT}" ]] ; then
eerror
eerror "Subslot inconsistency"
eerror
eerror $(printf "%30s : %-s" "Actual subslot" "${FFMPEG_SUBSLOT}")
eerror $(printf "%30s : %-s" "Expected subslot" "${actual_subslot}")
eerror
		die
	fi
}

src_prepare() {
	verify_subslot
	if [[ "${MY_PV%_p*}" != "${MY_PV}" ]] ; then # Snapshot
		export revision=git-N-${FFMPEG_REVISION}
	fi

	if use soc ; then
		eapply "${DISTDIR}/${SOC_PATCH}"
	fi

	default

	use cuda && cuda_src_prepare

	# -fdiagnostics-color=auto gets appended after user flags which
	# will ignore user's preference.
	sed -i -e '/check_cflags -fdiagnostics-color=auto/d' configure || die

	ln -snf "${FILESDIR}/chromium.c" chromium.c || die
	echo 'include $(SRC_PATH)/ffbuild/libffmpeg.mak' >> Makefile || die

	# Handle *FLAGS here to avoid repeating for each ABI below (bug #923491)
	LTO_FLAG=
	if tc-is-lto ; then
		if [[ "${v}" != "-flto" ]] ; then
			: "$(get-flag flto)" # get -flto=<val> (e.g. =thin)
			LTO_FLAG="--enable-lto=${_#-flto}"
		else
			LTO_FLAG="--enable-lto"
		fi
	fi
	filter-lto

einfo "Copying sources, please wait"
	prepare_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
einfo "Copying sources to ${S_ORIG}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			cp -a "${S_ORIG}" "${S_ORIG}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}" || die
			uopts_src_prepare
		done
	}
	multilib_foreach_abi prepare_abi
}

get_native_abi_use() {
	for p in $(multilib_get_enabled_abi_pairs) ; do
		[[ "${p}" =~ "${DEFAULT_ABI}"$ ]] && echo "${p}" | cut -f 1 -d "."
	done
}

get_multiabi_ffmpeg() {
	local btype="${lib_type/-*}"
	if multilib_is_native_abi && has_version "media-video/ffmpeg[$(get_native_abi_use)]" ; then
		echo "${MY_ED}/usr/bin/ffmpeg-shared"
	elif ! multilib_is_native_abi && has_version "media-video/ffmpeg[${MULTILIB_ABI_FLAG}]" ; then
		echo "${MY_ED}/usr/bin/ffmpeg-shared-${ABI}"
	else
		echo ""
	fi
}

has_ffmpeg() {
	local x=$(get_multiabi_ffmpeg)
	[[ -n "${x}" && -e "${x}" ]] && return 0
	return 1
}

has_codec_requirement() {
	local acodecs_found=1
	local vcodecs_found=1
	local capture_found=1
	local id
	local has_video_samples=0
	local has_audio_samples=0
	local has_capture_device=0
	addpredict /dev/video*
	for id in $(get_audio_sample_ids) ; do
		local audio_sample_path="${!id}"
		[[ -e "${audio_sample_path}" ]] || continue
		[[ -z "${audio_sample_path}" ]] && continue
		if ! ffprobe "${audio_sample_path}" 2>/dev/null 1>/dev/null ; then
			acodecs_found=0
		fi
		has_audio_samples=1
	done
	for id in $(get_video_sample_ids) ; do
		local video_sample_path="${!id}"
		[[ -e "${video_sample_path}" ]] || continue
		[[ -z "${video_sample_path}" ]] && continue
		if ! ffprobe "${video_sample_path}" 2>/dev/null 1>/dev/null ; then
			vcodecs_found=0
		fi
		has_video_samples=1
	done

	for id in $(get_video_sample_ids) ; do
		local capture_path="${!id}"
		[[ -e "${capture_path}" ]] || continue
		[[ -z "${capture_path}" ]] && continue
		addwrite "${capture_path}"
		if ! ffprobe "${capture_path}" 2>/dev/null 1>/dev/null ; then
			capture_found=0
		fi
		has_capture_device=1
	done

eprintf "acodecs_found" "${acodecs_found}"
eprintf "vcodecs_found" "${vcodecs_found}"
eprintf "capture_found" "${capture_found}"
eprintf "has_audio_samples" "${has_audio_samples}"
eprintf "has_video_samples" "${has_video_samples}"
eprintf "has_capture_device" "${has_capture_device}"
	if (( ${has_audio_samples} == 1 && ${acodecs_found} == 1 \
		&& ${has_video_samples} == 1 && ${vcodecs_found} == 1 \
		&& ${has_capture_device} == 1 && ${capture_found} == 1 \
	)) ; then
		return 0
	elif (( ${has_audio_samples} == 1 && ${acodecs_found} == 1 )) ; then
		return 0
	elif (( ${has_video_samples} == 1 && ${vcodecs_found} == 1 )) ; then
		return 0
	elif (( ${has_capture_device} == 1 && ${capture_found} == 1 )) ; then
		return 0
	else
		return 1
	fi
}

train_meets_requirements() {
	local player=0
	local codecs=0
	if has_ffmpeg ; then
		player=1
	fi
	if has_codec_requirement ; then
		codecs=1
	fi
eprintf "has_codec_requirement" "${codecs}"
eprintf "has_ffmpeg" "${player}"
	if has_ffmpeg && has_codec_requirement ; then
		return 0
	fi
	return 1
}

append_all() {
	append-flags ${@}
	append-ldflags ${@}
}

src_configure() { :; }

_src_configure_compiler() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)
}

_src_configure() {
	local i
	local extra_libs=()
	local myconf=()

einfo "Configuring ${lib_type} with PGO_PHASE=${PGO_PHASE}"
ewarn "The tensorflow USE flag requires ffmpeg 4.x.x."

	# Conditional patch options
	if use soc ; then
		myconf+=(
			--enable-v4l2-request
			--enable-libudev
			--enable-sand
		)
	fi

	if use clear-config-first ; then
# The clear-config-pre and clear-config-post are the same.
		if [[ -z "${FFMPEG_CUSTOM_OPTIONS}" ]] ; then
eerror
eerror "The clear-config-first requires FFMPEG_CUSTOM_OPTIONS to be set."
eerror "See metadata.xml for details."
eerror
			die
		fi
		FFMPEG_CLEAR_CONFIG_SETS=${FFMPEG_CLEAR_CONFIG_SETS:-"bsfs decoders demuxers encoders hwaccels indevs muxers outdevs"}
		[[ "${FFMPEG_CLEAR_CONFIG_SETS}" =~ "bsfs" ]] && myconf+=( --disable-bsfs )
		[[ "${FFMPEG_CLEAR_CONFIG_SETS}" =~ "decoders" ]] && myconf+=( --disable-decoders )
		[[ "${FFMPEG_CLEAR_CONFIG_SETS}" =~ "demuxers" ]] && myconf+=( --disable-demuxers )
		[[ "${FFMPEG_CLEAR_CONFIG_SETS}" =~ "encoders" ]] && myconf+=( --disable-encoders )
		[[ "${FFMPEG_CLEAR_CONFIG_SETS}" =~ "filters" ]] && myconf+=( --disable-filters )
		[[ "${FFMPEG_CLEAR_CONFIG_SETS}" =~ "hwaccels" ]] && myconf+=( --disable-hwaccels )
		[[ "${FFMPEG_CLEAR_CONFIG_SETS}" =~ "indevs" ]] && myconf+=( --disable-indevs )
		[[ "${FFMPEG_CLEAR_CONFIG_SETS}" =~ (^| |)"muxers" ]] && myconf+=( --disable-muxers )
		[[ "${FFMPEG_CLEAR_CONFIG_SETS}" =~ "outdevs" ]] && myconf+=( --disable-outdevs )
		[[ "${FFMPEG_CLEAR_CONFIG_SETS}" =~ "parsers" ]] && myconf+=( --disable-parsers )
		[[ "${FFMPEG_CLEAR_CONFIG_SETS}" =~ "protocols" ]] && myconf+=( --disable-protocols )
	fi

einfo
einfo "FFMPEG_CUSTOM_OPTIONS:"
einfo
	export FFMPEG_CUSTOM_OPTIONS=$(echo "${FFMPEG_CUSTOM_OPTIONS}" \
		| tr "\t" "\n" \
		| tr " " "\n" \
		| sort \
		| uniq)
	echo -e "${FFMPEG_CUSTOM_OPTIONS}"
einfo

	if [[ "${FFMPEG_CUSTOM_OPTIONS}" =~ "ffwavesynth_decoder" ]] ; then
ewarn "Adding ffwavesynth_decoder in FFMPEG_CUSTOM_OPTIONS may break functionality"
	fi
	if [[ "${FFMPEG_CUSTOM_OPTIONS}" =~ "vaapi_encode" ]] ; then
ewarn "Adding vaapi_encode in FFMPEG_CUSTOM_OPTIONS may break functionality"
	fi
	if [[ "${FFMPEG_CLEAR_CONFIG_SETS}" =~ "parsers" ]] ; then
eerror
eerror "Adding parsers in FFMPEG_CLEAR_CONFIG_SETS will break functionality.  See metadata.xml for workaround."
eerror
		die
	fi
	if [[ "${FFMPEG_CLEAR_CONFIG_SETS}" =~ "protocols" ]] ; then
eerror
eerror "Adding protocols in FFMPEG_CLEAR_CONFIG_SETS will break functionality.  See metadata.xml for workaround."
eerror
		die
	fi
	if [[ "${FFMPEG_CLEAR_CONFIG_SETS}" =~ "filters" ]] ; then
eerror
eerror "Adding filters in FFMPEG_CLEAR_CONFIG_SETS will break functionality.  See metadata.xml for workaround."
eerror
		die
	fi

	uopts_src_configure

	if is-flagq "-Ofast" ; then
		# Precaution
		append_all $(test-flags -fno-allow-store-data-races)
	fi

	# Fix for when gcc >= -O2 -fprofile-generate -fno-reorder-blocks-and-partition
	# libswscale/x86/rgb2rgb_template.c:1640:9: error: 'asm' operand has impossible constraints
	filter-flags '-DALLOW_7REGS=*'
	if [[ "${ABI}" == "x86" ]] && ( use pgo || use epgo ) ; then
		append-cppflags -DALLOW_7REGS=0
	else
		append-cppflags -DALLOW_7REGS=1
	fi

	if tc-is-clang && ( use pgo || use epgo ) ; then
# The instrumented build with clang will segfault when training.
eerror
eerror "Use gcc for PGO builds."
eerror
		die
	fi

	if tc-is-clang && ( use pgo || use epgo ) ; then
		append-flags -mllvm -vp-counters-per-site=8
	fi

	strip-flag-value "cfi-icall"
	if tc-is-clang && has_version "llvm-runtimes/compiler-rt-sanitizer[cfi]" ; then
		append_all -fno-sanitize=cfi-icall # Prevent illegal instruction with ffprobe
	fi
	cflags-hardened_append
	# Let build scripts apply hardening flags for correct
	# disabling/enablement order.
	filter-flags \
		"-D_FORTIFY_SOURCE=*" \
		"-fstack-protector*" \
		"-pic" \
		"-pie" \
		"-fPIC" \
		"-fPIE" \
		"-no-pie" \
		"-nopie" \
		"-Wl,-z,relro" \
		"-Wl,-z,now"
	myconf+=(
		--toolchain="hardened"
	)

	# Silence ld.lld: error: libavcodec/libavcodec.so: undefined reference to vpx_codec_get_caps
	# Error happens when linking -lvpx and -lopenh264 together to make ffprobe_g.  Removing -lopenh264 fixes it.
	# -lopenh264 has no reference to libvpx, so lld is buggy.
	append-ldflags -Wl,--allow-shlib-undefined

	# Licensing of external packages
	# See https://github.com/FFmpeg/FFmpeg/blob/n4.4/configure#L1735
	if use nonfree ; then
		myconf+=(
			--enable-nonfree
		)
	fi
	if use gpl ; then
		myconf+=(
			--enable-gpl
		)
	fi
	if use version3 ; then
		myconf+=(
			--enable-version3
		)
	fi

	if use cuda-filters || use nvdec || use nvenc ; then
		myconf+=(
			--enable-ffnvcodec
		)
	else
		myconf+=(
			--disable-ffnvcodec
		)
	fi

	local ffuse=(
		"${FFMPEG_FLAG_MAP[@]}"
	)

	# Encoders
	if use encode ; then
		ffuse+=(
			"${FFMPEG_ENCODER_FLAG_MAP[@]}"
		)
	else
		myconf+=(
			--disable-encoders
		)
	fi

	# Indevs
	if ! use v4l ; then
		myconf+=(
			--disable-indev=v4l2
			--disable-outdev=v4l2
		)
	fi
	for i in alsa oss jack sndio ; do
		if ! use ${i} ; then
			myconf+=(
				--disable-indev=${i}
			)
		fi
	done

	# Outdevs
	for i in alsa oss sndio ; do
		if ! use ${i} ; then
			myconf+=(
				--disable-outdev=${i}
			)
		fi
	done

	for i in "${ffuse[@]#+}" ; do
		myconf+=(
			$(use_enable ${i%:*} ${i#*:})
		)
	done

	if use cuda-filters ; then
		myconf+=(
			--enable-filter=bilateral_cuda
			--enable-filter=chromakey_cuda
			--enable-filter=colorspace_cuda
			--enable-filter=overlay_cuda
			--enable-filter=scale_cuda
			--enable-filter=thumbnail_cuda
			--enable-filter=yadif_cuda
		)
	fi

	if use dvdvideo ; then
		myconf+=(
			--enable-libdvdnav
			--enable-libdvdread
		)
	else
		myconf+=(
			--disable-libdvdnav
			--disable-libdvdread
		)
	fi

	if use liblensfun && multilib_is_native_abi ; then
		myconf+=(
			$(use_enable liblensfun liblensfun)
		)
	else
		myconf+=(
			--disable-liblensfun
		)
	fi

	if use libqrencode && multilib_is_native_abi ; then
		myconf+=(
			$(use_enable libqrencode libqrencode)
		)
	else
		myconf+=(
			--disable-libqrencode
		)
	fi

	if use patent_status_nonfree ; then
		myconf+=(
			--enforceability=unenforced
		)
	elif ! use patent_status_nonfree ; then
		myconf+=(
			--enforceability=enforced
			--non-free-patented-codecs=deny
		)
	fi

	if use re-codecs ; then
		myconf+=(
			--re-codecs=allow
		)
	else
		myconf+=(
			--re-codecs=deny
		)
	fi

	if use openssl ; then
		myconf+=(
			--disable-gnutls
		)
	fi

	if use openvino && multilib_is_native_abi ; then
		local arch
		if [[ "${ABI}" == "amd64" ]] ; then
			arch="intel64"
		elif [[ "${ABI}" == "x86" ]] ; then
			arch="ia32"
		elif [[ "${ABI}" == "arm" ]] ; then
			arch="arm"
		elif [[ "${ABI}" == "arm64" ]] ; then
			arch="arm64"
		fi
		myconf+=(
			--extra-cflags="-I/usr/lib64/openvino/deployment_tools/inference_engine/include"
			--extra-ldflags="-L/usr/$(get_libdir)/openvino/deployment_tools/inference_engine/lib/${arch}"
			$(use_enable openvino libopenvino)
		)
	else
		myconf+=(
			--disable-libopenvino
		)
	fi

	if use tensorflow && multilib_is_native_abi ; then
		myconf+=(
			--extra-cflags="-I/usr/include/tensorflow"
			$(use_enable tensorflow libtensorflow)
		)
	else
		myconf+=(
			--disable-libtensorflow
		)
	fi

	if use torch && multilib_is_native_abi ; then
		myconf+=(
			$(use_enable torch libtorch)
		)
	else
		myconf+=(
			--disable-libtorch
		)
	fi

	# (temporarily) disable non-multilib deps
	if ! multilib_is_native_abi; then
		for i in librav1e libmfx libzmq ; do
			myconf+=(
				--disable-${i}
			)
		done
	fi

	# CPU features
	for i in "${CPU_FEATURES_MAP[@]}" ; do
		if ! use ${i%:*} ; then
			myconf+=(
				--disable-${i#*:}
			)
		fi
	done

	# Bug #917277, #917278
	myconf+=(
		--disable-dotprod
		--disable-i8mm
	)

	# Broken on x32 (bug #427004) and not PIC safe on x86 (bug #916067)
	if [[ "${ABI}" == "x32" || "${ABI}" == "x86" ]] ; then
		myconf+=(
			--disable-asm
		)
	fi

	# Try to get cpu type based on CFLAGS.
	# Bug #172723
	# We need to do this so that features of that CPU will be better used
	# If they contain an unknown CPU it will not hurt since ffmpeg's configure
	# will just ignore it.
	for i in $(get-flag mcpu) $(get-flag march) ; do
		[[ ${i} = native ]] && i="host" # bug #273421
		myconf+=(
			--cpu=${i}
		)
		break
	done

	# Disabling LTO is a security risk.  It disables Clang CFI.
	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
		LTO_FLAG=""
	fi

	# Mandatory configuration
	myconf=(
	# libaribcaption is not packaged yet?
		--disable-libaribcaption
		--enable-avfilter
		--enable-pic
		--disable-stripping
	# This is only for hardcoded cflags; those are used in configure checks that may
	# interfere with proper detections, bug #671746 and bug #645778
	# We use optflags, so that overrides them anyway.
		--disable-optimizations
	# bug #664158 \
		--disable-libcelt
		"${myconf[@]}"
	)

	# Cross compile support
	if tc-is-cross-compiler ; then
		myconf+=(
			--enable-cross-compile
			--arch=$(tc-arch-kernel)
			--cross-prefix=${CHOST}-
			--host-cc="$(tc-getBUILD_CC)"
		)
		case ${CHOST} in
			*freebsd*)
				myconf+=(
					--target-os=freebsd
				)
				;;
			*mingw32*)
				myconf+=(
					--target-os=mingw32
				)
				;;
			*linux*)
				myconf+=(
					--target-os=linux
				)
				;;
		esac
	fi

	# Doc
	myconf+=(
		$(multilib_native_use_enable doc)
		$(multilib_native_use_enable doc htmlpages)
		$(multilib_native_enable manpages)
	)

	# Fixed in 5.0.1? Waiting for verification from someone who hit the issue.
	if use arm || use ppc || use mips || [[ ${CHOST} == *i486* ]] ; then
		# bug #782811
		# bug #790590
		extra_libs+=(
			--extra-libs="$(test-flags-CCLD -latomic)"
		)
	fi

	local static_args=()
	if [[ "${lib_type}" == "static" ]] ; then
		static_args=(
			--enable-static
			--disable-shared
		)
	else
		static_args=(
			--disable-static
			--enable-shared
		)
	fi

	if ! use mold && is-flagq '-fuse-ld=mold' ; then
eerror
eerror "-fuse-ld=mold must use the mold USE flag."
eerror
		die
	fi

	if use mold ; then
		filter-flags '-fuse-ld=*'
		append-ldflags '-fuse-ld=mold'
		strip-unsupported-flags
	fi

	if use cuda-nvcc && [[ -n "${FFMPEG_NVCCFLAGS}" ]] ; then
		myconf+=(
			--nvccflags="${FFMPEG_NVCCFLAGS}"
		)
	fi

einfo
eprintf "CC" "${CC}"
eprintf "CXX" "${CXX}"
eprintf "CFLAGS" "${CFLAGS}"
eprintf "CXXFLAGS" "${CXXFLAGS}"
eprintf "LDFLAGS" "${LDFLAGS}"
einfo

	if tc-is-gcc && ( use pgo || use epgo ) ; then
		extra_libs+=(
			--extra-libs="-lgcov"
		)
	fi

	local root
	if [[ "${SLOT%/*}" == "0" ]] ; then
		local root="${EPREFIX}/usr"
	else
		local root="${EPREFIX}/usr/lib/ffmpeg/${FFMPEG_SUBSLOT}"
	fi

	myconf+=(
		--prefix="${root}/"
		--libdir="${root}/$(get_libdir)"
		--shlibdir="${root}/$(get_libdir)"
		--docdir="${root}/share/doc/${PF}/html"
		--mandir="${root}/share/man"
		# Pass option over *FLAGS due to special logic (bug #566282,#754654)
		${LTO_FLAG}
	)

	set -- "${S}/configure" \
		--cc="$(tc-getCC)" \
		--cxx="$(tc-getCXX)" \
		--ar="$(tc-getAR)" \
		--nm="$(tc-getNM)" \
		--strip="$(tc-getSTRIP)" \
		--ranlib="$(tc-getRANLIB)" \
		--pkg-config="$(tc-getPKG_CONFIG)" \
		--optflags="${CFLAGS}" \
		"${extra_libs[@]}" \
		${static_args[@]} \
		"${myconf[@]}" \
		${EXTRA_FFMPEG_CONF}
	echo "${@}"
	"${@}" || die
}

_adecode() {
einfo "Decoding ${1}"
	cmd=( "${FFMPEG}" -c:a ${decoding_codec} -i "${T}/traintemp/test.${extension}" -f null - )
eprintf "Running" "${cmd[@]}"
	"${cmd[@]}" || die
}

_vdecode() {
einfo "Decoding ${1}"
	cmd=( "${FFMPEG}" -c:v ${decoding_codec} -i "${T}/traintemp/test.${extension}" -f null - )
eprintf "Running" "${cmd[@]}"
	"${cmd[@]}" || die
}

_get_resolutions_quick() {
	local L=(
		# Most videos are 24 FPS
		"30;1280;720;sdr"
	)

	local e
	if [[ -n "${FFMPEG_TRAINING_CUSTOM_VOD_RESOLUTIONS_QUICK}" ]] ; then
		for e in ${FFMPEG_TRAINING_CUSTOM_VOD_RESOLUTIONS_QUICK} ; do
			echo "${e}"
		done
	else
		for e in ${L[@]} ; do
			echo "${e}"
		done
	fi
}

_get_resolutions() {
	local L=(
		"30;426;240;sdr"
		"60;426;240;sdr"
		"30;640;360;sdr"
		"60;640;360;sdr"
		"30;854;480;sdr"
		"60;854;480;sdr"
		"30;1280;720;sdr"
		"60;1280;720;sdr"
		"30;1920;1080;sdr"
		"60;1920;1080;sdr"
		"30;2560;1440;sdr"
		"60;2560;1440;sdr"
		"30;3840;2160;sdr"
		"60;3840;2160;sdr"
		"30;7680;4320;sdr"
		"60;7680;4320;sdr"

		"30;1280;720;hdr"
		"60;1280;720;hdr"
		"30;1920;1080;hdr"
		"60;1920;1080;hdr"
		"30;2560;1440;hdr"
		"60;2560;1440;hdr"
		"30;3840;2160;hdr"
		"60;3840;2160;hdr"
		"30;7680;4320;hdr"
		"60;7680;4320;hdr"
	)

	local e
	if [[ -n "${FFMPEG_TRAINING_CUSTOM_VOD_RESOLUTIONS}" ]] ; then
		for e in ${FFMPEG_TRAINING_CUSTOM_VOD_RESOLUTIONS} ; do
			echo "${e}"
		done
	else
		for e in ${L[@]} ; do
			echo "${e}"
		done
	fi
}

# common name for height
_cheight() {
	local height="${1}"
	if [[ "${height}" == "480" ]] ; then
		echo "SD (480p)"
	elif [[ "${height}" == "720" ]] ; then
		echo "HD (720p)"
	elif [[ "${height}" == "1080" ]] ; then
		echo "FHD (1080p)"
	elif [[ "${height}" == "1440" ]] ; then
		echo "QHD (1440p)"
	elif [[ "${height}" == "2160" ]] ; then
		echo "4K"
	elif [[ "${height}" == "4320" ]] ; then
		echo "8K"
	else
		echo "${height}p"
	fi
}

_get_264_level() {
	local fps="${1}"
	local width="${1}"
	local height="${1}"

	# We don't do the full because it is unlikely.
	# Only common resolutions and frame rates.

	if (( \
		   ( ${fps} == 60 && ${width} == 8192 && ${height} == 4320 ) \
		|| ( ${fps} == 60 && ${width} == 7680 && ${height} == 4320 ) \
	)) ; then
		echo "6.1"
	elif (( \
		   ( ${fps} == 30 && ${width} == 8192 && ${height} == 4320 ) \
		|| ( ${fps} == 30 && ${width} == 7680 && ${height} == 4320 ) \
	)) ; then
		echo "6"
	elif (( \
		   ( ${fps} == 60 && ${width} == 3840 && ${height} == 2160 ) \
		|| ( ${fps} == 60 && ${width} == 4096 && ${height} == 2048 ) \
		|| ( ${fps} == 60 && ${width} == 4096 && ${height} == 2160 ) \
	)) ; then
		echo "5.2"
	elif (( \
		   ( ${fps} == 30 && ${width} == 3840 && ${height} == 2160 ) \
		|| ( ${fps} == 30 && ${width} == 4096 && ${height} == 2048 ) \
	)) ; then
		echo "5.1"
	elif (( \
		   ( ${fps} == 30 && ${width} == 2560 && ${height} == 1920 ) \
		   ( ${fps} == 60 && ${width} == 2048 && ${height} == 1080 ) \
	)) ; then
		echo "5"
	elif (( \
		   ( ${fps} == 60 && ${width} == 2048 && ${height} == 1080 ) \
		|| ( ${fps} == 60 && ${width} == 1920 && ${height} == 1080 ) \
	)) ; then
		echo "4.2"
	elif (( \
		   ( ${fps} == 30 && ${width} == 1920 && ${height} == 1080 ) \
		|| ( ${fps} == 30 && ${width} == 2048 && ${height} == 1024 ) \
		|| ( ${fps} == 60 && ${width} == 1280 && ${height} == 720 ) \
	)) ; then
		echo "4.1"
	elif (( \
		   ( ${fps} == 30 && ${width} == 2048 && ${height} == 1024 ) \
		|| ( ${fps} == 30 && ${width} == 1920 && ${height} == 1080 ) \
		|| ( ${fps} == 60 && ${width} == 1280 && ${height} == 720 ) \
	)) ; then
		echo "4"

	elif (( \
		( ${fps} == 60 && ${width} == 1280 && ${height} == 720 ) \
	)) ; then
		echo "3.2"
	elif (( \
		( ${fps} == 30 && ${width} == 1280 && ${height} == 720 ) \
	)) ; then
		echo "3.1"
	elif (( \
		( ${fps} == 30 && ${width} == 720 && ${height} == 480 ) \
		( ${fps} == 60 && ${width} == 352 && ${height} == 480 ) \
	)) ; then
		echo "3"

	elif (( \
		( ${fps} == 30 && ${wdith} == 352 && ${height} == 480 ) \
	)) ; then
		echo "2.2"

	elif (( \
		( ${fps} == 30 && ${width} == 352 && ${height} == 288 ) \
	)) ; then
		echo "1.3"

	elif (( \
		( ${fps} == 30 && ${width} == 176 && ${height} == 144 ) \
	)) ; then
		echo "1.1"

	elif (( \
		( ${fps} == 30 && ${width} == 128  && ${height} == 96 ) \
	)) ; then
		echo "1b" # 128 kbps

	elif (( \
		( ${fps} == 30 && ${width} == 128 && ${height} == 96 ) \
	)) ; then
		echo "1" # 64 kbps
	fi
}

_has_hw_264_level_support() {
	local level="${1}"
	local hw_level
	for hw_level in ${FFMPEG_TRAINING_264_HW_LEVEL_SUPPORTED} ; do
		[[ "${hw_level}" == "${level}" ]] && return 0
	done
	return 1
}

_trainer_plan_video_constrained_quality_training_session() {
	local entry="${1}"
	local duration="${2}"

	local fps=$(echo "${entry}" | cut -f 1 -d ";")
	local width=$(echo "${entry}" | cut -f 2 -d ";")
	local height=$(echo "${entry}" | cut -f 3 -d ";")
	local dynamic_range=$(echo "${entry}" | cut -f 4 -d ";")
	local bits="" # 8 bit

	local m60fps="1"

	[[ "${fps}" == "60" ]] && m60fps="1.5"
	[[ "${dynamic_range}" == "hdr" ]] && return

	local extra_args=()

	local pf=$(ffprobe \
		-show_entries stream=pix_fmt \
		"${video_sample_path}" \
		2>/dev/null \
		| grep "pix_fmt" \
		| cut -f 2 -d "=")

	if [[ "${encoding_codec}" =~ ("openh264") ]] ; then
		if [[ "${ABI}" == "arm" && "${CHOST}" =~ ("arm4"|"arm5"|"arm6") ]] ; then
			extra_args+=( -profile:v constrained_baseline )
		elif [[ "${ABI}" == "arm" ]] ; then
			extra_args+=( -profile:v main ) # armv7
		elif [[ "${ABI}" == "arm64" ]] && (( ${height} <= 1080 )) ; then
			extra_args+=( -profile:v main )
		elif [[ "${ABI}" == "arm64" ]] ; then
			extra_args+=( -profile:v high )
		elif [[ "${ABI}" == "x86" ]] ; then
			extra_args+=( -profile:v high )
		elif [[ "${ABI}" == "x64" ]] ; then
			extra_args+=( -profile:v high )
		else
			extra_args+=( -profile:v main )
		fi
		extra_args+=( -pix_fmt yuv420p )
	elif [[ "${encoding_codec}" =~ ("x264") ]] ; then
		if [[ "${ABI}" == "arm" && "${CHOST}" =~ ("arm4"|"arm5"|"arm6") ]] ; then
			extra_args+=( -profile:v baseline )
		elif [[ "${ABI}" == "arm" ]] ; then
			extra_args+=( -profile:v main ) # armv7
		elif [[ "${ABI}" == "arm64" ]] && (( ${height} <= 1080 )) ; then
			extra_args+=( -profile:v main )
		elif [[ "${ABI}" == "arm64" ]] ; then
			extra_args+=( -profile:v high )
		elif [[ "${ABI}" == "x86" ]] ; then
			extra_args+=( -profile:v high )
		elif [[ "${ABI}" == "x64" ]] ; then
			if [[ "${pf}" =~ "444" ]] ; then
				extra_args+=( -profile:v high444 ) # <= 12 bits
			elif [[ "${pf}" =~ "422" ]] ; then
				extra_args+=( -profile:v high422 ) # <= 10 bits
			elif [[ "${pf}" =~ "p10" ]] ; then
				extra_args+=( -profile:v high10 )  # 4:2:0 <= 10 bits
			else
				extra_args+=( -profile:v high )    # 4:2:0 8 bits
			fi
		else
			extra_args+=( -profile:v main )
		fi
		extra_args+=( -pix_fmt yuv420p )
		local level=$(_get_264_level "${fps}" "${width}" "${height}")
		if [[ -n "${level}" ]] && _has_hw_264_level_support "${level}" ; then
			extra_args+=( -level:v ${level} )
		fi
	fi

	if [[ "${encoding_codec}" =~ ("libvpx-vp9"|"libvpx") \
		&& "${dynamic_range}" == "sdr" ]] ; then
		if [[ "${pf}" =~ ("422"|"444") ]] ; then
			extra_args+=( -profile:v 1 ) # 4:2:2 8 bit chroma subsampling
			extra_args+=( -pix_fmt yuv422p )
		else
			extra_args+=( -profile:v 0 ) # 4:2:0 8 bit chroma subsampling
			extra_args+=( -pix_fmt yuv420p )
		fi
	fi

	if [[ "${encoding_codec}" =~ ("libaom-av1") ]] ; then
		if [[ "${pf}" =~ "444" ]] ; then
			extra_args+=( -profile:v 1 ) # 4:4:4 8/10 bit chroma subsampling
		elif [[ "${pf}" =~ "422" ]] ; then
			extra_args+=( -profile:v 2 ) # 4:2:2 8/10/12 bit chroma subsampling; or 12 bit 4:0:0, 4:4:4
		else
			extra_args+=( -profile:v 0 ) # 4:2:0 or 4:0:0 8/10 bit chroma subsampling
		fi
		extra_args+=( -pix_fmt yuv420p )
	fi

	if [[ "${encoding_codec}" =~ "x264" ]] ; then
		if [[ "${id}" =~ ("CGI"|"FANTASY") ]] ; then
			extra_args+=( -tune animation )
		elif [[ "${id}" =~ "GRAINY" ]] ; then
			extra_args+=( -tune grain )
		elif [[ "${id}" =~ "REALISM" ]] ; then
			extra_args+=( -tune film )
		elif [[ "${id}" =~ "STILL" ]] ; then
			extra_args+=( -tune stillimage )
		fi
	fi

	if [[ "${encoding_codec}" =~ ("libaom-av1"|"libvpx"|"libvpx-vp9") ]] ; then
		if [[ "${id}" =~ ("CGI"|"GAMING"|"SCREENCAST") ]] ; then
			extra_args+=( -tune-content 1 ) # 1=screen
		elif [[ "${id}" =~ "GRAINY" ]] ; then
			extra_args+=( -tune-content 2 ) # 2=film
		fi
	fi

	# Formula based on point slope linear curve fitting.  Drop 1000 for Mbps.
	# Yes 30 for 30 fps is not a mistake, so we scale it later with m60fps.
	local avgrate=$(${EPYTHON} -c "import math;print(abs(4.95*pow(10,-8)*(30*${width}*${height})-0.2412601555) * ${m60fps} * 1000)")
	local maxrate=$(${EPYTHON} -c "print(${avgrate}*1.45)") # moving
	local minrate=$(${EPYTHON} -c "print(${avgrate}*0.5)") # stationary

	local cheight=$(_cheight "${height}")
einfo "Encoding as ${cheight} for ${duration} sec, ${fps} fps"
	local cmd
	cmd=(
		"${FFMPEG}" \
		-y \
		-i "${video_sample_path}" \
		-c:v ${encoding_codec} \
		-maxrate ${maxrate}k -minrate ${minrate}k -b:v ${avgrate}k \
		-vf "scale=w=-1:h=${height}" \
		${training_args} \
		-an \
		-r ${fps} \
		-t ${duration} \
		"${T}/traintemp/test.${extension}"
	)
	local len=$(ffprobe \
		-i "${video_sample_path}" \
		-show_entries format=duration \
		-v quiet \
		-of csv="p=0" \
		| cut -f 1 -d ".")
	(( len < 0 )) && len=0
	local i
	for i in $(seq 1 ${N_SAMPLES}) ; do
		local pos=$(${EPYTHON} -c "print(int(${i}/${N_SAMPLES} * ${len}))")
eprintf "Seek" "${i} / ${N_SAMPLES}"
eprintf "Position" "${pos}"
eprintf "Length" "${len}"
eprintf "Running" "${cmd[@]} -ss ${pos}"
		"${cmd[@]}" -ss ${pos} || die
		_vdecode "${cheight}, ${fps} fps"
	done
}

_trainer_plan_video_constrained_quality() {
	local mode="${1}"
	local video_scenario="${2}"
	local encoding_codec="${3}"
	local decoding_codec="${4}"
	local extension="${5}"
	local tags="${6}"
	local training_args=
	local duration

	if [[ "${encoding_codec}" =~ "vaapi" ]] ; then
eerror
eerror "VA-API training not supported at the moment"
eerror
		return
	fi

	local name="${encoding_codec^^}"
	name="${name//-/_}"
	local envvar="FFMPEG_TRAINING_${name}_ARGS"
	if [[ -n "${!envvar}" ]] ; then
		training_args="${!envvar}"
	fi

	local L=()

	if [[ "${mode}" == "quick" ]] ; then
		L=( $(_get_resolutions_quick) )
		duration="1"
	else
		L=( $(_get_resolutions) )
		duration="3"
	fi

	if train_meets_requirements ; then
		local id
		for id in $(get_video_sample_ids) ; do
			local video_sample_path="${!id}"
			[[ -e "${video_sample_path}" ]] || continue
einfo "Running trainer for ${encoding_codec} for 1 pass constrained quality"
			local e
			for e in ${L[@]} ; do
				_trainer_plan_video_constrained_quality_training_session "${e}" "${duration}"
			done
		done
	fi
}

_trainer_plan_video_2_pass_constrained_quality_training_session() {
	local entry="${1}"
	local duration="${2}"

	local fps=$(echo "${entry}" | cut -f 1 -d ";")
	local width=$(echo "${entry}" | cut -f 2 -d ";")
	local height=$(echo "${entry}" | cut -f 3 -d ";")
	local dynamic_range=$(echo "${entry}" | cut -f 4 -d ";")
	local mhdr="1"
	local m60fps="1"
	local bits=""

	local extra_args=()

	if [[ "${dynamic_range}" == "hdr" ]] ; then
		extra_args+=(
			# See libavfilter/vf_setparams.c
			# Target HDR10
			-color_primaries bt2020
			-color_trc smpte2084
			-colorspace bt2020nc
		)
		if [[ "${encoding_codec}" =~ ("libvpx"|"libvpx-vp9"|"libaom-av1") ]] ; then
			extra_args+=(
				-color_range 0 # limited
			)
		else
			extra_args+=(
				-color_range limited # video
			)
		fi
		mhdr="1.25"
	fi

	local pf=$(ffprobe \
		-show_entries stream=pix_fmt \
		"${video_sample_path}" \
		2>/dev/null \
		| grep "pix_fmt" \
		| cut -f 2 -d "=")

	if [[ "${dynamic_range}" == "hdr" ]] ; then
		if [[ "${pf}" =~ "p12" && "${encoding_codec}" =~ ("libaom-av1") ]] ; then
			bits="12"
		else
			bits="10"
		fi
		bits="${bits}le"
		[[ "${ABI}" =~ "arm" ]] && continue
	else
		bits="" # 8 bits
	fi

	if [[ "${encoding_codec}" =~ ("openh264") ]] ; then
		if [[ "${ABI}" == "arm" && "${CHOST}" =~ ("arm4"|"arm5"|"arm6") ]] ; then
			extra_args+=( -profile:v constrained_baseline )
		elif [[ "${ABI}" == "arm" ]] ; then
			extra_args+=( -profile:v main ) # armv7
		elif [[ "${ABI}" == "arm64" ]] && (( ${height} <= 1080 )) ; then
			extra_args+=( -profile:v main )
		elif [[ "${ABI}" == "arm64" ]] ; then
			extra_args+=( -profile:v high )
		elif [[ "${ABI}" == "x86" ]] ; then
			extra_args+=( -profile:v high )
		elif [[ "${ABI}" == "x64" ]] ; then
			extra_args+=( -profile:v high )
		else
			extra_args+=( -profile:v main )
		fi
		extra_args+=( -pix_fmt yuv420p${bits} )
	elif [[ "${encoding_codec}" =~ ("x264") ]] ; then
		if [[ "${ABI}" == "arm" && "${CHOST}" =~ ("arm4"|"arm5"|"arm6") ]] ; then
			extra_args+=( -profile:v baseline )
		elif [[ "${ABI}" == "arm" ]] ; then
			extra_args+=( -profile:v main ) # armv7
		elif [[ "${ABI}" == "arm64" ]] && (( ${height} <= 1080 )) ; then
			extra_args+=( -profile:v main )
		elif [[ "${ABI}" == "arm64" ]] ; then
			extra_args+=( -profile:v high )
		elif [[ "${ABI}" == "x86" ]] ; then
			extra_args+=( -profile:v high )
		elif [[ "${ABI}" == "x64" ]] ; then
			if [[ "${pf}" =~ "444" ]] ; then
				extra_args+=( -profile:v high444 ) # <= 12 bits
			elif [[ "${pf}" =~ "422" ]] ; then
				extra_args+=( -profile:v high422 ) # <= 10 bits
			elif [[ "${pf}" =~ "p10" ]] ; then
				extra_args+=( -profile:v high10 )  # 4:2:0 <= 10 bits
			else
				extra_args+=( -profile:v high )    # 4:2:0 8 bits
			fi
		else
			extra_args+=( -profile:v main )
		fi
		extra_args+=( -pix_fmt yuv420p${bits} )
	fi

	if [[ "${encoding_codec}" =~ ("libvpx"|"libvpx-vp9") ]] ; then
		if [[ "${dynamic_range}" == "hdr" ]] ; then
			if [[ "${pf}" =~ ("422"|"444") ]] ; then
				extra_args+=( -profile:v 3 ) # 4:2:2 10/12 bit chroma subsampling
				extra_args+=( -pix_fmt yuv422p${bits} )
			else
				extra_args+=( -profile:v 2 ) # 4:2:0 10/12 bit chroma subsampling
				extra_args+=( -pix_fmt yuv420p${bits} )
			fi
		else
			if [[ "${pf}" =~ ("422"|"444") ]] ; then
				extra_args+=( -profile:v 1 ) # 4:2:2 8 bit chroma subsampling
				extra_args+=( -pix_fmt yuv422p${bits} )
			else
				extra_args+=( -profile:v 0 ) # 4:2:0 8 bit chroma subsampling
				extra_args+=( -pix_fmt yuv420p${bits} )
			fi
		fi
	fi

	if [[ "${encoding_codec}" =~ ("libaom-av1") ]] ; then
		if [[ "${pf}" =~ "444" ]] ; then
			extra_args+=( -profile:v 1 ) # 4:4:4 8/10 bit chroma subsampling
			extra_args+=( -pix_fmt yuv422p${bits} )
		elif [[ "${pf}" =~ "422" ]] ; then
			extra_args+=( -profile:v 2 ) # 4:2:2 8/10/12 bit chroma subsampling; or 12 bit 4:0:0, 4:4:4
			extra_args+=( -pix_fmt yuv422p${bits} )
		else
			extra_args+=( -profile:v 0 ) # 4:2:0 or 4:0:0 8/10 bit chroma subsampling
			extra_args+=( -pix_fmt yuv420p${bits} )
		fi
	fi

	[[ "${fps}" == "60" ]] && m60fps="1.5"

	if [[ "${encoding_codec}" =~ "x264" ]] ; then
		if [[ "${id}" =~ ("CGI"|"FANTASY") ]] ; then
			extra_args+=( -tune animation )
		elif [[ "${id}" =~ "GRAINY" ]] ; then
			extra_args+=( -tune grain )
		elif [[ "${id}" =~ "REALISM" ]] ; then
			extra_args+=( -tune film )
		elif [[ "${id}" =~ "STILL" ]] ; then
			extra_args+=( -tune stillimage )
		fi
	fi

	if [[ "${encoding_codec}" =~ ("libaom-av1"|"libvpx"|"libvpx-vp9") ]] ; then
		if [[ "${id}" =~ ("CGI"|"GAMING"|"SCREENCAST") ]] ; then
			extra_args+=( -tune-content 1 ) # 1=screen
		elif [[ "${id}" =~ "GRAINY" ]] ; then
			extra_args+=( -tune-content 2 ) # 2=film
		fi
	fi

	# Formula based on point slope linear curve fitting.  Drop 1000 for Mbps.
	# Yes 30 for 30 fps is not a mistake, so we scale it later with m60fps.
	local avgrate=$(${EPYTHON} -c "import math;print(abs(4.95*pow(10,-8)*(30*${width}*${height})-0.2412601555) * ${mhdr} * ${m60fps} * 1000)")
	local maxrate=$(${EPYTHON} -c "print(${avgrate}*1.45)") # moving
	local minrate=$(${EPYTHON} -c "print(${avgrate}*0.5)") # stationary

	local cmd
	local cheight=$(_cheight "${height}")
einfo "Encoding as ${cheight} for ${duration} sec, ${fps} fps"
	cmd1=(
		"${FFMPEG}" \
		-y \
		-i "${video_sample_path}" \
		-c:v ${encoding_codec} \
		-maxrate ${maxrate}k -minrate ${minrate}k -b:v ${avgrate}k \
		-vf "scale=w=-1:h=${height}" \
		${training_args} \
		-pass 1 \
		${extra_args[@]} \
		-an \
		-r ${fps} \
		-t ${duration} \
		-f null /dev/null
	)
	cmd2=(
		"${FFMPEG}" \
		-y \
		-i "${video_sample_path}" \
		-c:v ${encoding_codec} \
		-maxrate ${maxrate}k -minrate ${minrate}k -b:v ${avgrate}k \
		-vf "scale=w=-1:h=${height}" \
		${training_args} \
		-pass 2 \
		${extra_args[@]} \
		-an \
		-r ${fps} \
		-t ${duration} \
		"${T}/traintemp/test.${extension}"
	)
	local len=$(ffprobe \
		-i "${video_sample_path}" \
		-show_entries format=duration \
		-v quiet \
		-of csv="p=0" \
		| cut -f 1 -d ".")
	(( len < 0 )) && len=0
	local i
	for i in $(seq 1 ${N_SAMPLES}) ; do
		local pos=$(${EPYTHON} -c "print(int(${i}/${N_SAMPLES} * ${len}))")
eprintf "Seek" "${i} / ${N_SAMPLES}"
eprintf "Position" "${pos}"
eprintf "Length" "${len}"
eprintf "Running" "${cmd1[@]} -ss ${pos}"
		"${cmd1[@]}" -ss ${pos} || die
eprintf "Running" "${cmd2[@]} -ss ${pos}"
		"${cmd2[@]}" -ss ${pos} || die
		_vdecode "${cheight}, ${fps} fps"
	done
}

_trainer_plan_video_2_pass_constrained_quality() {
	local mode="${1}"
	local video_scenario="${2}"
	local encoding_codec="${3}"
	local decoding_codec="${4}"
	local extension="${5}"
	local tags="${6}"
	local training_args=
	local duration

	if [[ "${encoding_codec}" =~ "vaapi" ]] ; then
eerror
eerror "VA-API training not supported at the moment"
eerror
		return
	fi

	local name="${encoding_codec^^}"
	name="${name//-/_}"
	local envvar="FFMPEG_TRAINING_${name}_ARGS"
	if [[ -n "${!envvar}" ]] ; then
		training_args="${!envvar}"
	fi

	local L=()

	if [[ "${mode}" == "quick" ]] ; then
		L=( $(_get_resolutions_quick) )
		duration="1"
	else
		L=( $(_get_resolutions) )
		duration="3"
	fi

	if train_meets_requirements ; then
		local id
		for id in $(get_video_sample_ids) ; do
			local video_sample_path="${!id}"
			[[ -e "${video_sample_path}" ]] || continue
einfo "Running trainer for ${encoding_codec} for 2 pass constrained quality"
			local e
			for e in ${L[@]} ; do
				_trainer_plan_video_2_pass_constrained_quality_training_session "${e}" "${duration}"
			done
		done
	fi
}

_trainer_plan_audio_lossless() {
	local audio_scenario="${1}"
	local encoding_codec="${2}"
	local decoding_codec="${3}"
	local extension="${4}"
	local tags="${5}"
	local training_args=

	if [[ "${encoding_codec}" =~ ("flac"|"tta"|"wavpack") ]] ; then
		:;
	else
		return
	fi

	local name="${encoding_codec^^}"
	name="${name//-/_}"
	local envvar="FFMPEG_TRAINING_${name}_ARGS_LOSSLESS"
	if [[ -n "${!envvar}" ]] ; then
		training_args="${!envvar}"
	fi

	if train_meets_requirements ; then
		local id
		for id in $(get_audio_sample_ids) ; do
			local audio_sample_path="${!id}"
			[[ -e "${audio_sample_path}" ]] || continue
			if [[ -z "${audio_sample_path}" || ! -f "${audio_sample_path}" ]] ; then
ewarn "Skipping ${id}"
				continue
			fi
			if ! ffprobe \
				"${audio_sample_path}" \
				2>/dev/null \
				1>/dev/null \
			; then
ewarn "Skipping ${id} with path ${audio_sample_path}.  Decoding not possible or bad file."
				continue
			fi

			if [[ "${audio_scenario}" == "music" && ! ( "${s}" =~ "MUSIC" ) ]] ; then
				continue
			elif [[ "${audio_scenario}" == "radio" && ! ( "${s}" =~ "RADIO" ) ]] ; then
				continue
			elif [[ "${audio_scenario}" == "voice" && ! ( "${s}" =~ "VOICE" ) ]] ; then
				continue
			fi

einfo "Running trainer for ${encoding_codec} for lossless"
einfo "Encoding for lossless audio"
			local cmd
			cmd=(
				"${FFMPEG}" \
				-y \
				-i "${audio_sample_path}" \
				-c:v ${encoding_codec} \
				${training_args} \
				-t 3 \
				"${T}/traintemp/test.${extension}"
			)
			local len=$(ffprobe \
				-i "${audio_sample_path}" \
				-show_entries format=duration \
				-v quiet \
				-of csv="p=0" \
				| cut -f 1 -d ".")
			(( len < 0 )) && len=0
			local i
			for i in $(seq 1 ${N_SAMPLES}) ; do
				local pos=$(${EPYTHON} -c "print(int(${i}/${N_SAMPLES} * ${len}))")
eprintf "Seek" "${i} / ${N_SAMPLES}"
eprintf "Position" "${pos}"
eprintf "Length" "${len}"
eprintf "Running" "${cmd[@]} -ss ${pos}"
				"${cmd[@]}" -ss ${pos} || die
				_adecode "lossless"
			done
		done
	fi
}

_trainer_plan_video_lossless() {
	local mode="${1}"
	local video_scenario="${2}"
	local encoding_codec="${3}"
	local decoding_codec="${4}"
	local extension="${5}"
	local tags="${6}"
	local training_args=
	local codec_args=()
	local duration

	local name="${encoding_codec^^}"
	name="${name//-/_}"
	local envvar="FFMPEG_TRAINING_${name}_ARGS_LOSSLESS"
	if [[ -n "${!envvar}" ]] ; then
		training_args="${!envvar}"
	fi

	[[ "${encoding_codec}" =~ "libvpx-vp9" ]] && codec_args+=( -lossless 1 )

	if [[ "${mode}" == "quick" ]] ; then
		duration="1"
	else
		duration="3"
	fi

	if train_meets_requirements ; then
		local id
		for id in $(get_video_sample_ids) ; do
			local video_sample_path="${!id}"
			[[ -e "${video_sample_path}" ]] || continue
einfo "Running trainer for ${encoding_codec} for lossless"
einfo "Encoding for lossless video"
			local cmd
			cmd=(
				"${FFMPEG}" \
				-y \
				-i "${video_sample_path}" \
				-c:v ${encoding_codec} \
				${codec_args[@]} \
				${training_args} \
				-an \
				-t ${duration} \
				"${T}/traintemp/test.${extension}"
			)
			local len=$(ffprobe \
				-i "${video_sample_path}" \
				-show_entries format=duration \
				-v quiet \
				-of csv="p=0" \
				| cut -f 1 -d ".")
			(( len < 0 )) && len=0
			local i
			for i in $(seq 1 ${N_SAMPLES}) ; do
				local pos=$(${EPYTHON} -c "print(int(${i}/${N_SAMPLES} * ${len}))")
eprintf "Seek" "${i} / ${N_SAMPLES}"
eprintf "Position" "${pos}"
eprintf "Length" "${len}"
eprintf "Running" "${cmd[@]} -ss ${pos}"
				"${cmd[@]}" -ss ${pos} || die
				_vdecode "lossless"
			done
		done
	fi
}

# Full list of hw accelerated image processing
# ffmpeg -filters | grep vaapi
_get_vaapi_postproc_device() {
	local d
	for d in ls "${ESYSROOT}/dev/dri/render"* ; do
		if [[ -n "${d}" ]] && vainfo --display drm --device "${d}" 2>/dev/null 1>/dev/null \
			&& vainfo --display drm --device "${d}" 2>/dev/null \
				| grep -q -e ".*VideoProc" ; then
			echo "${d}"
			return
		fi
	done
}

_get_vaapi_dec_device() {
	local encoding_format="${1}"
	local profile="${2}"
	profile="${profile,,}"
	profile="${profile^}"
	local d
	for d in ls "${ESYSROOT}/dev/dri/render"* ; do
		if [[ -n "${d}" ]] && vainfo --display drm --device "${d}" 2>/dev/null 1>/dev/null \
			&& vainfo --display drm --device "${d}" 2>/dev/null \
				| grep -q -e "${encoding_format^^}${profile}.*VLD" ; then
			echo "${d}"
			return
		fi
	done
}

_get_vaapi_enc_device() {
	local encoding_format="${1}"
	local profile="${2}"
	profile="${profile,,}"
	profile="${profile^}"
	local d
	for d in ls "${ESYSROOT}/dev/dri/render"* ; do
		if [[ -n "${d}" ]] && vainfo --display drm --device "${d}" 2>/dev/null 1>/dev/null \
			&& vainfo --display drm --device "${d}" 2>/dev/null \
				| grep -q -e "${encoding_format^^}${profile}.*EncSlice" ; then
			echo "${d}"
			return
		fi
	done
}

_get_vaapi_enc_dec_device() {
	local encoding_format="${1}"
	local profile="${2}"
	profile="${profile,,}"
	profile="${profile^}"
	local d
	for d in ls "${ESYSROOT}/dev/dri/render"* ; do
		if [[ -n "${d}" ]] && vainfo --display drm --device "${d}" 2>/dev/null 1>/dev/null \
			&& vainfo --display drm --device "${d}" 2>/dev/null \
				| grep -q -e "${encoding_format^^}${profile}.*EncSlice" \
			&& vainfo --display drm --device "${d}" 2>/dev/null \
				| grep -q -e "${encoding_format^^}${profile}.*VLD" ; then
			echo "${d}"
			return
		fi
	done
}

_get_vaapi_enc_dec_pp_device() {
	local encoding_format="${1}"
	local profile="${2}"
	profile="${profile,,}"
	profile="${profile^}"
	local d
	for d in ls "${ESYSROOT}/dev/dri/render"* ; do
		if [[ -n "${d}" ]] && vainfo --display drm --device "${d}" 2>/dev/null 1>/dev/null \
			&& vainfo --display drm --device "${d}" 2>/dev/null \
				| grep -q -e "${encoding_format^^}${profile}.*EncSlice" \
			&& vainfo --display drm --device "${d}" 2>/dev/null \
				| grep -q -e "${encoding_format^^}${profile}.*VLD" \
			&& vainfo --display drm --device "${d}" 2>/dev/null \
				| grep -q -e ".*VideoProc" ; then
			echo "${d}"
			return
		fi
	done
}

_has_camera_resolution() {
	local device="${1}"
	local width="${3}"
	local height="${4}"
	ffmpeg -f v4l2 -list_formats all -i "${device}" 2>&1 \
		| grep -q -e "${width}x${height}"
}

_has_camera_codec_resolution() {
	local device="${1}"
	local codec="${2}"
	local width="${3}"
	local height="${4}"
	if [[ "${codec}" =~ "264" ]] ; then
		ffmpeg -f v4l2 -list_formats all -i "${device}" 2>&1 \
			| grep -E -q -e "H\.264 :.*${width}x${height}"
	elif [[ "${codec}" =~ ("mjpeg"|"mjpg") ]] ; then
		ffmpeg -f v4l2 -list_formats all -i "${device}" 2>&1 \
			| grep -E -q -e "MJPEG :.*${width}x${height}"
	else
		ffmpeg -f v4l2 -list_formats all -i "${device}" 2>&1 \
			| grep -E -q -e "${codec} :.*${width}x${height}"
	fi
}

_has_camera_codec() {
	local device="${1}"
	local codec="${2}"
	if [[ "${codec}" =~ "264" ]] ; then
		ffmpeg -f v4l2 -list_formats all -i "${device}" 2>&1 \
			| grep -E -q -e "H\.264 : [0-9]"
	elif [[ "${codec}" =~ ("mjpeg"|"mjpg") ]] ; then
		ffmpeg -f v4l2 -list_formats all -i "${device}" 2>&1 \
			| grep -E -q -e "MJPEG : [0-9]"
	else
		ffmpeg -f v4l2 -list_formats all -i "${device}" 2>&1 \
			| grep -E -q -e "${codec} : [0-9]"
	fi
}

if ! has ffmpeg_pkg_sanitize ${EBUILD_SANITIZE_HOOKS} ; then
	EBUILD_SANITIZE_HOOKS+=" ffmpeg_pkg_sanitize"
fi

ffmpeg_pkg_sanitize() {
einfo "Called ffmpeg_pkg_sanitize()"
	_wipe_data
}

_wipe_data() {
	# May contain sensitive data
	local p
	for p in $(find "${T}/traintemp" -type f) ; do
		if [[ -e "${p}" ]] ; then
einfo "Wiped sensitive camera/screencast data"
			shred --remove=wipesync "${p}"
		fi
	done
}

_get_x11_display() {
	local pid="$$"
	local display=$(grep -z "^DISPLAY=" "/proc/${pid}/environ" \
		| cut -f 2 -d "=")
	if [[ -n "${display}" ]] ; then
		echo "${display}"
		return
	fi
}

LIVE_STREAMING_REPORT_CARD=""
_trainer_plan_av_streaming_training_session() {
	local entry="${1}"

	local fps=$(echo "${entry}" | cut -f 1 -d ";")
	local width=$(echo "${entry}" | cut -f 2 -d ";")
	local height=$(echo "${entry}" | cut -f 3 -d ";")
	local abitrate=$(echo "${entry}" | cut -f 4 -d ";")
	local asample_rate=$(echo "${entry}" | cut -f 5 -d ";")
	local mic=$(echo "${entry}" | cut -f 6 -d ";")
	local duration="3"

	[[ -z "${abitrate}" ]] && abitrate=0
	[[ -z "${asample_rate}" ]] && asample_rate=0
	[[ -z "${mic}" ]] && mic=0
	local m60fps="1"

	[[ "${fps}" == "60" ]] && m60fps="1.5"

	local vextra_args=()
	local aextra_args=()

	if ! [[ "${vencoding_codec}" =~ ("264"|"265"|"av1"|"theora"|"libvpx-vp9"|"libvpx") ]] ; then
eerror
eerror "Invalid video codec for av-streaming training."
eerror
		return
	fi

	if ! [[ "${aencoding_codec}" =~ ("aac"|"flac"|"mp3"|"none"|"opus") ]] \
		&& [[ "${mic}" =~ ("1") ]] ; then
eerror
eerror "Invalid audio codec for av-streaming training."
eerror
		return
	fi

	[[ -z "${abitrate}" ]] && abitrate="0"

	# Formula based on point slope linear curve fitting.  Drop 1000 for Mbps.
	# Yes 30 for 30 fps is not a mistake, so we scale it later with m60fps.
	local lq_avgrate=$(${EPYTHON} -c "import math;print((4.66*pow(10,-8)*(30*${width}*${height})+0.2780469436) * ${m60fps} * 1000)")
	local hq_avgrate=$(${EPYTHON} -c "import math;print((7.3*pow(10,-8)*(30*${width}*${height})+1.4952679804) * ${m60fps} * 1000)")
	local mq_avgrate=$(${EPYTHON} -c "import math;print((${lq_avgrate}+${hq_avgrate})/2)")

	local bandwidth_limit=$(${EPYTHON} -c "print(${FFMPEG_TRAINING_STREAMING_UPLOAD_BANDWIDTH:-1.05} * 1000)")

	if [[ "${mic}" =~ ("1") ]] ; then
		aextra_args+=(
			-c:a ${aencoding_codec}
			-b:a ${abitrate}k
			-ar $(${EPYTHON} -c "print(int(${asample_rate}*1000))")
		)
	else
		aextra_args+=(
			-an
		)
	fi

	if [[ -z "${container}" ]] ; then
		container="mp4"
	fi

	if [[ "${vencoding_codec}" =~ ("openh264") ]] ; then
		if [[ "${ABI}" == "arm" && "${CHOST}" =~ ("arm4"|"arm5"|"arm6") ]] ; then
			vextra_args+=( -profile:v constrained_baseline )
		elif [[ "${ABI}" == "arm" ]] ; then
			vextra_args+=( -profile:v main ) # armv7
		elif [[ "${ABI}" == "arm64" ]] && (( ${height} <= 1080 )) ; then
			vextra_args+=( -profile:v main )
		elif [[ "${ABI}" == "arm64" ]] ; then
			vextra_args+=( -profile:v high )
		elif [[ "${ABI}" == "x86" ]] ; then
			vextra_args+=( -profile:v high )
		elif [[ "${ABI}" == "x64" ]] ; then
			vextra_args+=( -profile:v high )
		else
			vextra_args+=( -profile:v main )
		fi
		vextra_args+=( -pix_fmt yuv420p )
	elif [[ "${vencoding_codec}" =~ ("x264") ]] ; then
		if [[ "${ABI}" == "arm" && "${CHOST}" =~ ("arm4"|"arm5"|"arm6") ]] ; then
			vextra_args+=( -profile:v baseline )
		elif [[ "${ABI}" == "arm" ]] ; then
			vextra_args+=( -profile:v main ) # armv7
		elif [[ "${ABI}" == "arm64" ]] && (( ${height} <= 1080 )) ; then
			vextra_args+=( -profile:v main )
		elif [[ "${ABI}" == "arm64" ]] ; then
			vextra_args+=( -profile:v high )
		elif [[ "${ABI}" == "x86" ]] ; then
			vextra_args+=( -profile:v high )
		elif [[ "${ABI}" == "x64" ]] ; then
			vextra_args+=( -profile:v high )
		else
			vextra_args+=( -profile:v main )
		fi
		vextra_args+=( -pix_fmt yuv420p )
		if [[ -n "${FFMPEG_TRAINING_256_PRESET}" ]] ; then
			vextra_args+=( -preset ${FFMPEG_TRAINING_256_PRESET} )
		fi
	fi

	if [[ "${vencoding_codec}" =~ ("libvpx-vp9"|"libvpx") ]] ; then
		vextra_args+=( -profile:v 0 ) # 4:2:0 8 bit chroma subsampling
		vextra_args+=( -pix_fmt yuv420p )
	fi

	if [[ "${vencoding_codec}" =~ ("libaom-av1") ]] ; then
		vextra_args+=( -profile:v 0 ) # 4:2:0 8 bit chroma subsampling
		vextra_args+=( -pix_fmt yuv420p )
	fi

	if [[ "${vencoding_codec}" =~ ("libaom-av1") ]] ; then
		vextra_args+=( -usage realtime )
	fi

	if [[ "${vencoding_codec}" =~ "x264" ]] ; then
		vextra_args+=( -tune zerolatency )
	fi

	if [[ "${vencoding_codec}" =~ ("libvpx"|"libvpx-vp9") ]] ; then
		vextra_args+=(
			-deadline realtime
			-quality realtime
		)
	fi

	if [[ "${vencoding_codec}" =~ ("h264_vaapi") ]] ; then
		if (( ${height} < 720 )) ; then
			vextra_args+=( -profile:v main )
		else
			vextra_args+=( -profile:v high )
		fi
	elif [[ "${vencoding_codec}" =~ ("h264_vaapi") ]] ; then
# ...like to add more but lack test hardware.
eerror
eerror "VA_API codec ${vencoding_codec} is not supported on the ebuild level."
eerror "Skipping."
eerror
		continue
	fi

	local input_source=()

	# Use DISPLAY=:0 ffplay test.mp4 -an to check
	local input_source_type=""
	local camera_codec=""

	if [[ "${vencoding_codec}" =~ ("h264") ]] ; then
		camera_codec="h264"
	elif [[ "${vencoding_codec}" =~ ("mjpeg") ]] ; then
		camera_codec="mjpeg"
	fi

	if _has_camera_codec_resolution "${capture_path}" "${camera_codec}" "${width}" "${height}" ; then
		input_source_type="camera-${camera_codec}"
		input_source=(
			-f v4l2
			-input_format ${camera_codec}
			-framerate ${fps}
			-video_size ${width}x${height}
			-i "${capture_path}"
		)
	elif _has_camera_resolution "${capture_path}" "${width}" "${height}" ; then
		input_source_type="camera-raw"
		input_source=(
			-f v4l2
			-framerate ${fps}
			-video_size ${width}x${height}
			-i "${capture_path}"
		)
	else
ewarn
ewarn "Camera does not have resolution skipping."
ewarn "Falling back to screen capture."
ewarn
		input_source_type="screen"
		if pgrep X 2>/dev/null 1>/dev/null ; then
			input_source=(
				-f x11grab
				-i $(_get_x11_display)
			)
		else
			input_source=(
				-f kmsgrab
				-i -
			)
		fi
	fi

	local vquality_i=1
	for avgrate in ${lq_avgrate} ${mq_avgrate} ${hq_avgrate} ; do
		local total_bitrate=$(${EPYTHON} -c "print(${avgrate} + ${abitrate})")
		(( ${vquality_i} == 1 )) && msg_quality="low quality"
		(( ${vquality_i} == 2 )) && msg_quality="mid quality"
		(( ${vquality_i} == 3 )) && msg_quality="high quality"
		local cheight=$(_cheight "${height}")

		local ENC=(
			"av1_vaapi"
			"h264_vaapi"
			"hevc_vaapi"
			"mjpeg_vaapi"
			"mpeg2_vaapi"
			"vp8_vaapi"
			"vp9_vaapi"
		)

		is_vaapi_encoder() {
			local needle="${1}"
			local x
			for x in ${ENC[@]} ; do
				[[ "${x}" == "${needle}" ]] && return 0
			done
			return 1
		}

		local vaapi_codec_name="${vencoding_codec%_*}"
		vaapi_codec_name="${vaapi_codec_name^^}"
		vaapi_dev=$(_get_vaapi_enc_dec_pp_device "${vaapi_codec_name}" "")

		local cmd
		if is_vaapi_encoder "${vencoding_codec}" \
			&& [[ "${input_source_type}" =~ ("camera-mjpeg"|"camera-raw"|"screen") && -n "${vaapi_dev}" ]] ; then
ewarn "VA-API training is WIP"
			local custom_filters=""

			local vaapi_args=()
			local vaapi_codec
			local _vaapi_codec

			local vaapi_scale_alg=${ffmpeg_trainers_VAAPI_SCALE_ALG:-gpu}
			vaapi_args=(
				-init_hw_device
				vaapi=card0:${vaapi_dev}
				-hwaccel vaapi
				-hwaccel_output_format vaapi
				-hwaccel_device card0
			)
			if [[ "${input_source_type}" == "screen" \
				&& "${vaapi_scale_alg,,}" == "cpu" ]] ; then
				custom_filters+="scale=w=${width}:h=${height},"
			fi
			custom_filters+="format=nv12|vaapi,hwupload"
			if [[ "${input_source_type}" == "screen" \
				&& "${vaapi_scale_alg,,}" =~ ("gpu"|"igp") ]] ; then
				vaapi_args+=(
					-filter_hw_device card0
				)
				custom_filters+=",scale_vaapi=w=${width}:h=${height}"
			fi

			cmd=(
				"${FFMPEG}" \
				-y \
				${vaapi_args[@]} \
				${input_source[@]} \
				-vf "${custom_filters}" \
				-c:v ${vencoding_codec} \
				${vextra_args[@]} \
				-r ${fps} \
				${aextra_args[@]} \
				-t ${duration} \
				-f ${container} \
				"${T}/traintemp/test.${container}"
			)
		elif [[ "${input_source_type}" =~ "camera-h264" ]] ; then
			cmd=(
				"${FFMPEG}" \
				-y \
				${input_source[@]} \
				-force_key_frames "expr:gte(t,n_forced*2)" \
				${training_args} \
				-r ${fps} \
				${aextra_args[@]} \
				-t ${duration} \
				-f ${container} \
				"${T}/traintemp/test.${container}"
			)
		else
			cmd=(
				"${FFMPEG}" \
				-y \
				${input_source[@]} \
				-vf "scale=w=-1:h=${height}" \
				-c:v ${vencoding_codec} \
				-maxrate ${avgrate}k -minrate ${avgrate}k -b:v ${avgrate}k \
				-force_key_frames "expr:gte(t,n_forced*2)" \
				-bufsize ${avgrate}k \
				${vextra_args[@]} \
				${training_args} \
				-r ${fps} \
				${aextra_args[@]} \
				-t ${duration} \
				-f ${container} \
				"${T}/traintemp/test.${container}"
			)
		fi

		if ! ${EPYTHON} -c "if ${total_bitrate} > ${bandwidth_limit}: exit(1)" ; then
ewarn
ewarn "Rejected encoder settings exceeding upload rate limits (total_bitrate: ${total_bitrate} kbps, ${bandwidth_limit} kbps)"
ewarn
ewarn "${cmd[@]}"
ewarn
#			continue
		else
einfo
einfo "Encoding ${msg_quality} (${avgrate} kbps) as ${cheight} for ${duration} sec, ${fps} fps"
einfo
einfo "${cmd[@]}"
einfo
		fi

# The initial startup and buffering causes latency issue maybe caused by both
# PGI and the ffmpeg program.
		local lag=15
		timeout $((${duration} * ${lag})) "${cmd[@]}"
		if ! ffprobe \
			-count_frames \
			-show_entries stream=nb_read_frames \
			-i "${T}/traintemp/test.${container}" \
			2>/dev/null \
			1>/dev/null \
		; then
#
# The idea was to have a list of encoding settings considered live stream
# quality that delivered 30/60 fps in 1 second or met the movie quality
# framerate of 24 fps and report it back to the user.  Anything that
# violated that was rejected.
#
eerror
eerror "Rejected.  Encoder settings cannot keep up."
eerror
			_wipe_data
			continue
		fi

		local actual_frames=$(ffprobe \
			-count_frames \
			-show_entries stream=nb_read_frames \
			-i "${T}/traintemp/test.${container}" \
			2>/dev/null \
			| grep "nb_read_frames.*" \
			| cut -f 2 -d "=")
		local expected_frames=$(${EPYTHON} -c "print(int(${fps} * ${duration} * (25/30)))")

		# You can change this as a weighted linear combo so that
		# you prioritize the preference of image quality or FPS.
		# score = w_1*x_1 + w_2*x_2 + ... + w_N*x_N
		local bonus=0
		local vquality=${vquality_i}
		local is_30fps=0
		local is_60fps=0
		(( ${fps} == 30 )) && is_30fps=1
		(( ${fps} == 60 )) && is_60fps=1
		local score
		if [[ -n "${FFMPEG_TRAINING_AV_STREAMING_WS}" ]] ; then
			local t=$(eval "echo ${FFMPEG_TRAINING_AV_STREAMING_WS}")
			score=$(${EPYTHON} -c "print(int(${t}))")
		else
			score=$(${EPYTHON} -c "print(int(${total_bitrate}))")
		fi

		if (( ${actual_frames} >= ${expected_frames}  )) ; then
			LIVE_STREAMING_REPORT_CARD+="${score} ${cmd[@]}\n"
		else
ewarn
ewarn "Encoding is not above frame minimal.  Combo not suitable for live streaming."
ewarn
ewarn "Actual frame count:  ${actual_frames}"
ewarn "Expected frame count:  ${expected_frames}"
ewarn
		fi
		vquality_i=$((${vquality_i} + 1))
		_wipe_data
	done
}

_get_av_level_of_detail() {
	local L=(
		# Only desktop gaming or screencasting for now
		"30;1980;1080;128;44.1;1"
		"64;1980;1080;128;44.1;1"
		"30;1280;720;128;44.1;1"
		"64;1280;720;128;44.1;1"
		"30;854;480;128;44.1;1"
		"30;640;360;128;44.1;1"
	)

	local e
	if [[ -n "${FFMPEG_TRAINING_CUSTOM_STREAMING_RESOLUTIONS}" ]] ; then
		for e in ${FFMPEG_TRAINING_CUSTOM_STREAMING_RESOLUTIONS} ; do
			echo "${e}"
		done
	else
		for e in ${L[@]} ; do
			echo "${e}"
		done
	fi
}

_trainer_plan_av_streaming() {
	local av_scenario="${1}"
	local vencoding_codec="${2}"
	local vdecoding_codec="${3}"
	local aencoding_codec="${4}"
	local adecoding_codec="${5}"
	local container="${6}"
	local tags="${7}"
	local training_args=

ewarn
ewarn "ffmpeg_trainers_av_streaming is a Work In Progress (WIP)"
ewarn

	local name="${encoding_codec^^}"
	name="${name//-/_}"
	local envvar="FFMPEG_TRAINING_${name}_ARGS"
	if [[ -n "${!envvar}" ]] ; then
		training_args="${!envvar}"
	fi

	local L=(
		$(_get_av_level_of_detail)
	)

	if train_meets_requirements ; then
		local id
		for id in $(get_av_device_ids) ; do
			local capture_path="${!id}"
			[[ -e "${capture_path}" ]] || continue
			addwrite "${capture_path}"
			addread "${capture_path}"
einfo "Running streaming trainer for ${capture_path} with ${vencoding_codec}, ${aencoding_codec}, ${container} for CBR"
			local e
			for e in ${L[@]} ; do
				_trainer_plan_av_streaming_training_session "${e}"
			done
		done
	fi
}

_trainer_plan_audio_cbr() {
	local audio_scenario="${1}"
	local encoding_codec="${2}"
	local decoding_codec="${3}"
	local extension="${4}"
	local tags="${5}"
	local training_args=

	if [[ "${encoding_codec}" =~ ("flac"|"tta"|"wavpack") ]] ; then
		return
	fi

	local name="${encoding_codec^^}"
	name="${name//-/_}"
	local envvar="FFMPEG_TRAINING_${name}_ARGS"
	if [[ -n "${!envvar}" ]] ; then
		training_args="${!envvar}"
	fi

	local cbr_suffix="${encoding_codec^^}"
	cbr_suffix="${cbr_suffix//-/_}"
	local cbr_table="FFMPEG_TRAINING_CBR_TABLE_${cbr_suffix}_${audio_scenario^^}"
	if [[ -z "${!cbr_table}" ]] ; then
ewarn "Missing CBR table for ${encoding_codec}"
		return
	fi

	local id
	for id in $(get_audio_sample_ids) ; do
		local audio_sample_path="${!id}"
		[[ -e "${audio_sample_path}" ]] || continue
		if [[ -z "${audio_sample_path}" || ! -f "${audio_sample_path}" ]] ; then
ewarn "Skipping ${id}"
			continue
		fi
		if ! ffprobe \
			"${audio_sample_path}" \
			2>/dev/null \
			1>/dev/null \
		; then
ewarn "Skipping ${id} with path ${audio_sample_path}.  Decoding not possible or bad file."
			continue
		fi

		if [[ "${audio_scenario}" == "music" && ! ( "${s}" =~ "MUSIC" ) ]] ; then
			continue
		elif [[ "${audio_scenario}" == "radio" && ! ( "${s}" =~ "RADIO" ) ]] ; then
			continue
		elif [[ "${audio_scenario}" == "voice" && ! ( "${s}" =~ "VOICE" ) ]] ; then
			continue
		fi

		for bitrate in ${!cbr_table} ; do
einfo "Encoding as CBR for 3 sec, ${bitrate} kbps for ${audio_sample_path}"
			cmd=(
				"${FFMPEG}" \
				-y \
				-i "${audio_sample_path}" \
				-vn \
				-c:a ${encoding_codec} \
				-b:a ${bitrate}k
				${training_args} \
				-t 3 \
				"${T}/traintemp/test.${extension}"
			)
			local len=$(ffprobe \
				-i "${audio_sample_path}" \
				-show_entries format=duration \
				-v quiet \
				-of csv="p=0" \
				| cut -f 1 -d ".")
			(( len < 0 )) && len=0
			local i
			for i in $(seq 1 ${N_SAMPLES}) ; do
				local pos=$(${EPYTHON} -c "print(int(${i}/${N_SAMPLES} * ${len}))")
eprintf "Seek" "${i} / ${N_SAMPLES}"
eprintf "Position" "${pos}"
eprintf "Length" "${len}"
eprintf "Running" "${cmd[@]} -ss ${pos}"
				"${cmd[@]}" -ss ${pos} || die
				_adecode "${bitrate} kbps"
			done
		done
	done
}

_trainer_plan_audio_vbr() {
	local audio_scenario="${1}"
	local encoding_codec="${2}"
	local decoding_codec="${3}"
	local extension="${4}"
	local tags="${5}"
	local training_args=

	if [[ "${encoding_codec}" =~ ("flac"|"tta"|"wavpack") ]] ; then
		return
	fi

	local name="${encoding_codec^^}"
	name="${name//-/_}"
	local envvar="FFMPEG_TRAINING_${name}_ARGS"
	if [[ -n "${!envvar}" ]] ; then
		training_args="${!envvar}"
	fi

	local vbr_suffix="${encoding_codec^^}"
	vbr_suffix="${vbr_suffix//-/_}"

	local vbr_option="FFMPEG_TRAINING_VBR_OPTION_${vbr_suffix}"
	if [[ -z "${!vbr_option}" ]] ; then
ewarn "Missing VBR option for ${encoding_codec}.  Skipping training."
		return
	fi

	local vbr_table="FFMPEG_TRAINING_VBR_TABLE_${vbr_suffix}_${audio_scenario^^}"
eprintf "vbr_table" "${vbr_table}"
	if [[ -z "${!vbr_table}" ]] ; then
ewarn "Missing VBR table for ${encoding_codec}.  Skipping training."
		return
	fi

	local id
	for id in $(get_audio_sample_ids) ; do
		local audio_sample_path="${!id}"
		[[ -e "${audio_sample_path}" ]] || continue
		if [[ -z "${audio_sample_path}" || ! -f "${audio_sample_path}" ]] ; then
ewarn "Skipping ${id}"
			continue
		fi
		if ! ffprobe \
			"${audio_sample_path}" \
			2>/dev/null \
			1>/dev/null \
		; then
ewarn "Skipping ${id} with path ${audio_sample_path}.  Decoding not possible or bad file."
			continue
		fi

		if [[ "${audio_scenario}" == "music" && ! ( "${s}" =~ "MUSIC" ) ]] ; then
			continue
		elif [[ "${audio_scenario}" == "radio" && ! ( "${s}" =~ "RADIO" ) ]] ; then
			continue
		elif [[ "${audio_scenario}" == "voice" && ! ( "${s}" =~ "VOICE" ) ]] ; then
			continue
		fi

		for setting in ${!vbr_table} ; do
einfo "Encoding as VBR for 3 sec with ${setting} setting for ${audio_sample_path}"
			cmd=(
				"${FFMPEG}" \
				-y \
				-i "${audio_sample_path}" \
				-vn \
				-c:a ${encoding_codec} \
				${!vbr_option} ${setting} \
				${training_args} \
				-t 3 \
				"${T}/traintemp/test.${extension}"
			)
			local len=$(ffprobe \
				-i "${audio_sample_path}" \
				-show_entries format=duration \
				-v quiet \
				-of csv="p=0" \
				| cut -f 1 -d ".")
			(( len < 0 )) && len=0
			local i
			for i in $(seq 1 ${N_SAMPLES}) ; do
				local pos=$(${EPYTHON} -c "print(int(${i}/${N_SAMPLES} * ${len}))")
eprintf "Seek" "${i} / ${N_SAMPLES}"
eprintf "Position" "${pos}"
eprintf "Length" "${len}"
eprintf "Running" "${cmd[@]} -ss ${pos}"
				"${cmd[@]}" -ss ${pos} || die
				_adecode "${bitrate} setting"
			done
		done
	done
}

run_trainer_audio_codecs() {
	for codec in ${FFMPEG_TRAINING_AUDIO_CODECS} ; do
		local audio_scenario=$(echo "${codec}" | cut -f 1 -d ":")
		local encode_codec=$(echo "${codec}" | cut -f 2 -d ":")
		local decode_codec=$(echo "${codec}" | cut -f 3 -d ":")
		local container_extension=$(echo "${codec}" | cut -f 4 -d ":")
		local tags=$(echo "${codec}" | cut -f 5 -d ":")
		if use ffmpeg_trainers_audio_cbr ; then
			_trainer_plan_audio_cbr \
				"${audio_scenario}" \
				"${encode_codec}" \
				"${decode_codec}" \
				"${container_extension}" \
				"${tags}"
		fi
		if use ffmpeg_trainers_audio_vbr ; then
			_trainer_plan_audio_vbr \
				"${audio_scenario}" \
				"${encode_codec}" \
				"${decode_codec}" \
				"${container_extension}" \
				"${tags}"
		fi
		if use ffmpeg_trainers_audio_lossless ; then
			_trainer_plan_audio_lossless \
				"${audio_scenario}" \
				"${encode_codec}" \
				"${decode_codec}" \
				"${container_extension}" \
				"${tags}"
		fi
	done
}

run_trainer_video_codecs() {
ewarn
ewarn "The format for environment variables has changed recently."
ewarn "See metadata.xml or \`epkginfo -x =${CATEGORY}/${PN}-${MY_PVR}::oiledmachine-overlay\` for details."
ewarn
	for codec in ${FFMPEG_TRAINING_VIDEO_CODECS} ; do
		local video_scenario=$(echo "${codec}" | cut -f 1 -d ":")
		local encode_codec=$(echo "${codec}" | cut -f 2 -d ":")
		local decode_codec=$(echo "${codec}" | cut -f 3 -d ":")
		local container_extension=$(echo "${codec}" | cut -f 4 -d ":")
		local tags=$(echo "${codec}" | cut -f 5 -d ":")
		if use ffmpeg_trainers_video_2_pass_constrained_quality ; then
			_trainer_plan_video_2_pass_constrained_quality \
				"full" \
				"${video_scenario}" \
				"${encode_codec}" \
				"${decode_codec}" \
				"${container_extension}" \
				"${tags}"
		fi
		if use ffmpeg_trainers_video_2_pass_constrained_quality_quick ; then
			_trainer_plan_video_2_pass_constrained_quality \
				"quick" \
				"${video_scenario}" \
				"${encode_codec}" \
				"${decode_codec}" \
				"${container_extension}" \
				"${tags}"
		fi
		if use ffmpeg_trainers_video_constrained_quality ; then
			_trainer_plan_video_constrained_quality \
				"full" \
				"${video_scenario}" \
				"${encode_codec}" \
				"${decode_codec}" \
				"${container_extension}" \
				"${tags}"
		fi
		if use ffmpeg_trainers_video_constrained_quality_quick ; then
			_trainer_plan_video_constrained_quality \
				"quick" \
				"${video_scenario}" \
				"${encode_codec}" \
				"${decode_codec}" \
				"${container_extension}" \
				"${tags}"
		fi
		if use ffmpeg_trainers_video_lossless ; then
			_trainer_plan_video_lossless \
				"full" \
				"${video_scenario}" \
				"${encode_codec}" \
				"${decode_codec}" \
				"${container_extension}" \
				"${tags}"
		fi
		if use ffmpeg_trainers_video_lossless_quick ; then
			_trainer_plan_video_lossless \
				"quick" \
				"${video_scenario}" \
				"${encode_codec}" \
				"${decode_codec}" \
				"${container_extension}" \
				"${tags}"
		fi
	done
}

run_trainer_av_codecs() {
	for codec in ${FFMPEG_TRAINING_AV_CODECS} ; do
		local av_scenario=$(echo "${codec}" | cut -f 1 -d ":")
		local vencode_codec=$(echo "${codec}" | cut -f 2 -d ":")
		local vdecode_codec=$(echo "${codec}" | cut -f 3 -d ":")
		local aencode_codec=$(echo "${codec}" | cut -f 4 -d ":")
		local adecode_codec=$(echo "${codec}" | cut -f 5 -d ":")
		local container=$(echo "${codec}" | cut -f 6 -d ":")
		local tags=$(echo "${codec}" | cut -f 6 -d ":")
		if use ffmpeg_trainers_av_streaming ; then
			_trainer_plan_av_streaming \
				"${av_scenario}" \
				"${vencode_codec}" \
				"${vdecode_codec}" \
				"${aencode_codec}" \
				"${adecode_codec}" \
				"${container}" \
				"${tags}"
		fi
	done
}

train_trainer_custom() {
	local btype="${lib_type/-*}"
	if multilib_is_native_abi ; then
		export FFMPEG="${ED}/usr/bin/ffmpeg-${btype}"
	else
		export FFMPEG="${ED}/usr/bin/ffmpeg-${btype}-${ABI}"
	fi
	export MY_ED="${ED}"
	# Currently only full codecs supported.
	if [[ -n "${FFMPEG_TRAINING_AUDIO_CODECS}" ]] ; then
		run_trainer_audio_codecs
	fi
	if [[ -n "${FFMPEG_TRAINING_VIDEO_CODECS}" ]] ; then
		run_trainer_video_codecs
	fi
	if [[ -n "${FFMPEG_TRAINING_AV_CODECS}" ]] ; then
		run_trainer_av_codecs
	fi
	unset MY_ED
}

_src_compile() {
	cd "${BUILD_DIR}" || die
	emake V=1

	if multilib_is_native_abi; then
		local i
		for i in "${FFTOOLS[@]}" ; do
			if use fftools_${i} ; then
				emake V=1 tools/${i}$(get_exeext)
			fi
		done

		use chromium &&
			emake V=1 libffmpeg
	fi
}

_src_pre_pgi() {
	export MY_ED=""
}

_src_pre_pgo() {
	export MY_ED=""
}

_src_post_pgo() {
	export PGO_RAN=1
}

_src_pre_train() {
einfo "Installing image into sandbox staging area"
	_install
	export MY_ED="${ED}"
	export FFMPEG=$(get_multiabi_ffmpeg)
	export LD_LIBRARY_PATH="${ED}/usr/$(get_libdir)"
}

_src_post_train() {
einfo "Clearing old sandboxed image"
	rm -rf "${ED}" || die
	unset LD_LIBRARY_PATH
}

src_compile() {
	mkdir -p "${T}/traintemp" || die
	compile_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export S="${S_ORIG}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
einfo "Build type is ${lib_type}"

			if [[ "${lib_type}" == "static" ]] ; then
				uopts_n_training
			else
				uopts_y_training
			fi

			uopts_src_compile
		done
	}
	multilib_foreach_abi compile_abi
	_wipe_data
}

src_test() {
	test_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export S="${S_ORIG}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			export LD_LIBRARY_PATH=\
"${BUILD_DIR}/libpostproc:\
${BUILD_DIR}/libswscale:\
${BUILD_DIR}/libswresample:\
${BUILD_DIR}/libavcodec:\
${BUILD_DIR}/libavdevice:\
${BUILD_DIR}/libavfilter:\
${BUILD_DIR}/libavformat:\
${BUILD_DIR}/libavutil:\
${BUILD_DIR}/libavresample" \
			emake V=1 fate
		done
	}
	multilib_foreach_abi test_abi
}

_install() {
	emake V=1 DESTDIR="${D}" install install-doc

	local root
	if [[ "${SLOT%/*}" == "0" ]] ; then
		local prefix="usr"
	else
		local prefix="usr/lib/ffmpeg/${FFMPEG_SUBSLOT}"
	fi

	# Prevent clobbering so that we can pgo optimize external codecs in different ABIs
	local btype="${lib_type/-*}"
	if ! multilib_is_native_abi ; then
		mv "${ED}/${prefix}/bin/ffmpeg"{"","-${btype}-${ABI}"} || die
		mv "${ED}/${prefix}/bin/ffprobe"{"","-${btype}-${ABI}"} || die
		if [[ -e "${ED}/${prefix}/bin/ffplay" ]] ; then
			mv "${ED}/${prefix}/bin/ffplay"{"","-${btype}-${ABI}"} || die
		fi
	else
		mv "${ED}/${prefix}/bin/ffmpeg"{"","-${btype}"} || die
		mv "${ED}/${prefix}/bin/ffprobe"{"","-${btype}"} || die
		dosym "/${prefix}/bin/ffmpeg-${btype}" "/${prefix}/bin/ffmpeg"
		dosym "/${prefix}/bin/ffprobe-${btype}" "/${prefix}/bin/ffprobe"
		if [[ -e "${ED}/${prefix}/bin/ffplay" ]] ; then
			mv "${ED}/${prefix}/bin/ffplay"{"","-${btype}"} || die
			dosym "/${prefix}/bin/ffplay-${btype}" "/${prefix}/bin/ffplay"
		fi
	fi

	if multilib_is_native_abi ; then
		exeinto "/${prefix}/bin"
		local i
		for i in "${FFTOOLS[@]}" ; do
			if use "fftools_${i}" ; then
einfo "Running dobin tools/${i}$(get_exeext)"
				if [[ "${PGO_PHASE}" == "PGI" ]] ; then
					# Bugged dobin
					mkdir -p "${ED}/${prefix}/bin" || die
					cp -a \
						"tools/${i}$(get_exeext)" \
						"${ED}/${prefix}/bin" \
						|| die
					chmod 0755 "${ED}/${prefix}/bin/${i}$(get_exeext)" || die
				else
					dobin "tools/${i}$(get_exeext)"
				fi
			fi
		done

		use chromium && \
			emake V=1 DESTDIR="${D}" install-libffmpeg
	fi

	if [[ "${lib_type}" == "shared" && "${SLOT%/*}" == "${FFMPEG_SUBSLOT}" ]] ; then
		local x
		for x in $(ls "${ED}/${prefix}/$(get_libdir)/"*".so"* ) ; do
			[[ -L "${x}" ]] && continue
einfo "Adding /${prefix}/$(get_libdir) to rpath for ${x}"
			patchelf --add-rpath "/${prefix}/$(get_libdir)" "${x}" || die
		done
		for x in $(ls "${ED}/${prefix}/bin/"*) ; do
			[[ -L "${x}" ]] && continue
einfo "Adding /${prefix}/$(get_libdir) to rpath for ${x}"
			patchelf --add-rpath "/${prefix}/$(get_libdir)" "${x}" || die
		done
	fi
}

src_install() {
	install_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export S="${S_ORIG}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			_install
			uopts_src_install
		done
		multilib_prepare_wrappers
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
	multilib_install_wrappers
	multilib_src_install_all
	if use tensorflow ; then
		local root
		if [[ "${SLOT%/*}" == "0" ]] ; then
			local prefix="usr"
		else
			local prefix="usr/lib/ffmpeg/${FFMPEG_SUBSLOT}"
		fi

		cd "${S}/tools/python" || die
		insinto "/${prefix}/$(get_libdir)/${PN}/scripts"
		local L=(
			"tf_sess_config.py"
		)
		doins ${L[@]}
		local f
		for f in ${L[@]} ; do
			fperms 0775 "/${prefix}/$(get_libdir)/${PN}/scripts/${f}"
		done
	fi
}

multilib_src_install_all() {
	dodoc "Changelog" "README.md" "CREDITS" "doc/"*".txt" "doc/APIchanges"
	[ -f "RELEASE_NOTES" ] && dodoc "RELEASE_NOTES"
}

pkg_postinst() {
	if use pgo && [[ -z "${PGO_RAN}" ]] ; then
ewarn
ewarn "No PGO optimization performed.  Please re-emerge this package."
ewarn
ewarn "The following package must be installed before PGOing this package:"
ewarn
ewarn "     media-video/mpv[cli]"
ewarn "     media-video/ffmpeg[encode]"
ewarn
	fi

	if use network && use elibc_glibc ; then
# Fixes:
# [ffmpeg] tcp: Failed to resolve hostname <redacted>: Temporary failure in name resolution
ewarn "The nscd service must be enabled and running for proper DNS resolution."
	fi

	if use nonfree ; then
ewarn "You are not allowed to redistribute this binary."
	fi
	uopts_pkg_postinst
	if use ffmpeg_trainers_av_streaming ; then
einfo
einfo "The recommended live streaming settings all of which met deadlines:"
einfo
echo -e "${LIVE_STREAMING_REPORT_CARD}" | sort | sed -e "/^$/d"
einfo
einfo "The top most is the most recommended.  The ones that follow are runner-ups."
ewarn
ewarn
ewarn "The sandbox state should be restored to the default state after training."
ewarn
ewarn "The portage should be removed from the video group after training."
ewarn
ewarn "The /dev/video* should have portage removed from ACL permissions after"
ewarn "training."
ewarn
	fi
	if use ffmpeg_trainers_av_streaming && ( use pgo || use bolt ) ; then
ewarn
ewarn "You must run \`xhost -local:root:\` after PGO training to restore the"
ewarn "security default."
ewarn
	fi
	if use X ; then
einfo
einfo "For X playback use \`ffplay <path>\`"
einfo "For screencasting use \`ffmpeg ... -f x11grab ...\`"
einfo
	fi
	if use wayland ; then
einfo
einfo "For wayland playback use \`SDL_VIDEODRIVER=wayland ffplay <path>\`"
einfo "For screencasting use \`ffmpeg ... -f kmsgrab ...\`"
einfo
	fi
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  pgo, cfi-exceptions, license-compatibility-correctness
