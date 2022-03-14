# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Subslot: libavutil major.libavcodec major.libavformat major
# Since FFmpeg ships several libraries, subslot is kind of limited here.
# Most consumers will use those three libraries, if a "less used" library
# changes its soname, consumers will have to be rebuilt the old way
# (preserve-libs).
# If, for example, a package does not link to libavformat and only libavformat
# changes its ABI then this package will be rebuilt needlessly. Hence, such a
# package is free _not_ to := depend on FFmpeg but I would strongly encourage
# doing so since such a case is unlikely.
FFMPEG_SUBSLOT=56.58.58

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_MIN_CLONE_TYPE="single"
	EGIT_REPO_URI="https://git.ffmpeg.org/ffmpeg.git"
fi

inherit flag-o-matic multilib multilib-minimal toolchain-funcs ${SCM}
inherit llvm

DESCRIPTION="Complete solution to record/convert/stream audio and video. Includes libavcodec"
HOMEPAGE="https://ffmpeg.org/"
if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
elif [ "${PV%_p*}" != "${PV}" ] ; then # Snapshot
	SRC_URI="mirror://gentoo/${P}.tar.bz2"
else # Release
	SRC_URI="https://ffmpeg.org/releases/${P/_/-}.tar.bz2"
fi
FFMPEG_REVISION="${PV#*_p}"

SLOT="0/${FFMPEG_SUBSLOT}"
LICENSE="
	lgpl2_1? ( LGPL-2.1 )
	lgpl2? ( LGPL-2 )
	lgpl2x? ( LGPL-2+ )
	lgpl2_1? ( LGPL-2.1 )
	lgpl2_1x? ( LGPL-2.1+ )
	lgpl3? ( LGPL-3 )
	lgpl3x? ( LGPL-3+ )
	gpl2? ( GPL-2 )
	gpl2x? ( GPL-2+ )
	gpl3? ( GPL-3 )
	gpl3x? ( GPL-3+ )
	static-libs? (
		MIT
		BSD
		BSD-2
		ZLIB
		cfi? ( Apache-2.0-with-LLVM-exceptions MIT )
		libcaca? ( GPL-2 ISC LGPL-2.1 WTFPL-2 )
		zimg? ( WTFPL-2 )
	)
" # This package is actually LGPL-2.1+, but certain dependencies are LGPL-2.1
# The extra licenses are for static-libs.
if [ "${PV#9999}" = "${PV}" ] ; then
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"
fi

# Options to use as use_enable in the foo[:bar] form.
# This will feed configure with $(use_enable foo bar)
# or $(use_enable foo foo) if no :bar is set.
# foo is added to IUSE.
FFMPEG_FLAG_MAP=(
		+bzip2:bzlib cpudetection:runtime-cpudetect debug gcrypt +gnutls gmp
		+gpl hardcoded-tables +iconv libxml2 lzma +network opencl
		openssl +postproc samba:libsmbclient sdl:ffplay sdl:sdl2 vaapi vdpau vulkan
		X:xlib X:libxcb X:libxcb-shm X:libxcb-xfixes +zlib
		# libavdevice options
		cdio:libcdio iec61883:libiec61883 ieee1394:libdc1394 libcaca openal
		opengl
		# indevs
		libv4l:libv4l2 pulseaudio:libpulse libdrm jack:libjack
		# decoders
		amr:libopencore-amrwb amr:libopencore-amrnb codec2:libcodec2 +dav1d:libdav1d fdk:libfdk-aac
		jpeg2k:libopenjpeg bluray:libbluray gme:libgme gsm:libgsm
		libaribb24 mmal modplug:libmodplug opus:libopus libilbc librtmp ssh:libssh
		speex:libspeex srt:libsrt svg:librsvg video_cards_nvidia:ffnvcodec
		vorbis:libvorbis vpx:libvpx zvbi:libzvbi
		# libavfilter options
		appkit
		bs2b:libbs2b chromaprint cuda:cuda-llvm flite:libflite frei0r
		fribidi:libfribidi fontconfig ladspa libass libtesseract lv2 truetype:libfreetype vidstab:libvidstab
		rubberband:librubberband zeromq:libzmq zimg:libzimg
		# libswresample options
		libsoxr
		# Threads; we only support pthread for now but ffmpeg supports more
		+threads:pthreads
)

# Same as above but for encoders, i.e. they do something only with USE=encode.
FFMPEG_ENCODER_FLAG_MAP=(
	amrenc:libvo-amrwbenc mp3:libmp3lame
	kvazaar:libkvazaar libaom
	openh264:libopenh264 rav1e:librav1e snappy:libsnappy theora:libtheora twolame:libtwolame
	webp:libwebp x264:libx264 x265:libx265 xvid:libxvid
)

IUSE+=" alsa chromium doc +encode oss pic sndio static-libs test v4l
	${FFMPEG_FLAG_MAP[@]%:*}
	${FFMPEG_ENCODER_FLAG_MAP[@]%:*}
"
# The LICENSE_REQUIRED_USE may be incomplete because of the dependency of the
#   dependency problem.  This is why portage should do license dependency tree
#   traversal checks.
# For some license compatibililty notes, see
#   https://github.com/FFmpeg/FFmpeg/blob/master/LICENSE.md#external-libraries
#   https://github.com/FFmpeg/FFmpeg/blob/master/LICENSE.md#incompatible-libraries
IUSE+=" apache2_0 +gpl2 gpl2x gpl3 gpl3x lgpl2 lgpl2x lgpl2_1 lgpl2_1x lgpl3 lgpl3x mpl2_0 nonfree version3"
IUSE+=" gdbm jack2 jack-audio-connection-kit opencl-icd-loader pipewire" # deep dependencies
IUSE+="
	gpl2x_to_gpl3
	lgpl2_1_to_gpl2
	lgpl2_1_to_gpl2x
	lgpl2_1_to_gpl3
	lgpl2_1x_to_gpl2
	lgpl2_1x_to_gpl2x
	lgpl2_1x_to_gpl3
	lgpl2_1x_to_lgpl3
	lgpl2_1x_to_lgpl3x
	lgpl2x_to_gpl2
	lgpl2x_to_gpl3
	lgpl2x_to_lgpl3x
	lgpl3_to_gpl3
	lgpl3x_to_gpl3
"

# x means plus.  There is a bug in the USE flag system where + is not recognized.
# You can't go backwards if you relicense.  This is why it is mutex.
#	^^ ( gpl2 lgpl2_1 )
# The relicense covers copying the headers which may contain inline code.
# The linking should be about the same.
# See also https://www.gnu.org/licenses/gpl-faq.html#AllCompatibility
gen_relicense() {
	local in_license="${1}"
	case ${in_license} in
		lgpl2x)
			echo "
				lgpl2x_to_gpl2? ( gpl2 )
				lgpl2x_to_gpl3? ( gpl3 )
				lgpl2x_to_lgpl3x? ( lgpl3x )
				!lgpl2x_to_gpl2? ( !lgpl2x_to_gpl3? ( !lgpl2x_to_lgpl3x? ( lgpl2x ) ) )
			"
			;;
		lgpl2_1)
			echo "
				lgpl2_1_to_gpl2? ( gpl2 )
				lgpl2_1_to_gpl2x? ( gpl2x )
				lgpl2_1_to_gpl3? ( gpl3 )
				!lgpl2_1_to_gpl2? ( !lgpl2_1_to_gpl2x ( !lgpl2_1_to_gpl3? ( lgpl2_1 ) ) )
			"
			;;
		lgpl2_1x)
			echo "
				lgpl2_1x_to_gpl2? ( gpl2 )
				lgpl2_1x_to_gpl2x? ( gpl2x )
				lgpl2_1x_to_gpl3? ( gpl3 )
				lgpl2_1x_to_lgpl3? ( lgpl3 )
				lgpl2_1x_to_lgpl3x? ( lgpl3x )
				lgpl2_1x_to_gpl2? ( !lgpl2_1x_to_gpl2x? ( !lgpl2_1x_to_gpl3? ( !lgpl2_1x_to_lgpl3? ( !lgpl2_1x_to_lgpl3x? ( lgpl2_1x ) ) ) ) )
			"
			;;
		lgpl3)
			echo "
				!gpl2
				lgpl3_to_gpl3? ( gpl3 )
				!lgpl3_to_gpl3? ( lgpl3 )
			"
			;;
		lgpl3x)
			echo "
				!gpl2
				lgpl3x_to_gpl3? ( gpl3 )
				!lgpl3x_to_gpl3? ( lgpl3x )
			"
			;;
		gpl2x)
			echo "
				gpl2x_to_gpl3? ( gpl3 )
				!gpl2x_to_gpl3? ( gpl2x )
			"
			;;
	esac
}

# The gpl USE flag is for compatibility for other ebuilds.  It should be
# replaced because of ambiguity (GPL-2 vs GPL-3) needs to be sorted for the
# Apache-2.0 license.
CONFIGURE_LICENSES_RECOGNIZED="
	!debug? ( ^^ ( gpl3x lgpl3x gpl2x lgpl2_1x ) )
	debug? ( || ( nonfree gpl3x lgpl3x gpl2x lgpl2_1x ) )
" # in the configure it is mutex but this ebuild treats as inclusive OR which
# was the same behavior as the original ebuild.
LICENSE_REQUIRED_USE="
	${CONFIGURE_LICENSES_RECOGNIZED}
	!gpl? ( $(gen_relicense lgpl2_1) )
	apache2_0? ( ^^ ( gpl3 lgpl3 ) !gpl2 !lgpl2_1 )
	amr? ( apache2_0 version3 )
	cdio? ( gpl3x $(gen_relicense gpl2x) $(gen_relicense lgpl2_1) )
	codec2? ( $(gen_relicense lgpl2_1) )
	chromaprint? ( $(gen_relicense lgpl2_1) )
	encode? (
		amrenc? ( apache2_0 version3 )
		kvazaar? ( $(gen_relicense lgpl2_1) )
		mp3? ( $(gen_relicense lgplx2_1) )
		twolame? ( gpl2 )
		x264? ( gpl2 )
		x265? ( gpl2 )
		xvid? ( gpl2 )
	)
	fdk? ( !gpl2 !gpl3 nonfree )
	frei0r? ( gpl2 )
	fribidi? ( $(gen_relicense lgpl2_1x) )
	gcrypt? ( $(gen_relicense lgpl2_1) )
	gme? ( $(gen_relicense lgpl2_1) )
	gmp? ( || ( $(gen_relicense gpl2x) $(gen_relicense lgpl3x) ) version3 )
	gpl? ( || ( gpl2 gpl2x ) )
	gpl2? ( !lgpl3 !lgpl3x !gpl3 gpl )
	gpl3? ( !gpl2 )
	gpl3x? ( !gpl2 )
	jack? (
		jack2? ( gpl2 )
		jack-audio-connection-kit? ( gpl2 $(gen_relicense lgpl2_1) )
		pipewire? ( gpl2 $(gen_relicense lgpl2_1x) )
	)
	iec61883? ( || ( $(gen_relicense lgpl2_1) gpl2 ) $(gen_relicense lgpl2_1) )
	ieee1394? ( $(gen_relicense lgpl2_1) )
	lgpl3? ( !gpl2 )
	libaribb24? ( $(gen_relicense lgpl3) version3 )
	libcaca? ( gpl2 $(gen_relicense lgpl2_1) )
	librtmp? ( gpl2 $(gen_relicense lgpl2_1) )
	libsoxr? ( $(gen_relicense lgpl2_1) )
	libtesseract? ( apache2_0 )
	libv4l? ( $(gen_relicense lgpl2_1x) )
	lzma? ( $(gen_relicense lgpl2_1x) $(gen_relicense gpl2x) )
	nonfree? ( !gpl2 !gpl3 )
	openal? ( $(gen_relicense lgpl2x) )
	openssl? (
		nonfree
		!apache2_0? ( !gpl2 !gpl2x !gpl3 !gpl3x )
		apache2_0? ( !gpl2 )
	)
	opencl? (
		opencl-icd-loader? ( apache2_0 )
	)
	postproc? ( gpl2 )
	pulseaudio? (
		!gdbm? ( gpl2 )
		gdbm? ( $(gen_relicense lgpl2_1) )
	)
	rav1e? ( apache2_0 )
	rubberband? ( gpl2 )
	samba? ( gpl3 )
	srt? ( mpl2_0 )
	ssh? ( $(gen_relicense lgpl2_1) )
	svg? ( $(gen_relicense lgpl2x) )
	truetype? ( $(gen_relicense gpl2x) )
	version3? ( ^^ ( gpl3 gpl3x lgpl3 lgpl3x ) )
	vidstab? ( $(gen_relicense gpl2x) )
	vulkan? ( apache2_0 )
	zeromq? ( $(gen_relicense lgpl3) )
	zvbi? ( gpl2 $(gen_relicense gpl2x) $(gen_relicense lgpl2x) )
"
RDEPEND+="
	gpl2? (
		opencl-icd-loader? ( !dev-libs/opencl-icd-loader )
	)
	lgpl2_1? (
		opencl-icd-loader? ( !dev-libs/opencl-icd-loader )
	)
" # License incompatible
REQUIRED_USE+=" ${LICENSE_REQUIRED_USE}"
# dav1d is BSD-2
# MPL-2.0 is indirect compatible with the GPL-2, LGPL-2.1 -- with exceptions.  \
#   For details see: https://www.gnu.org/licenses/license-list.html#MPL-2.0

IUSE+=" pgo
	pgo-custom-audio
	pgo-custom-video
	pgo-trainer-audio-cbr
	pgo-trainer-audio-vbr
	pgo-trainer-audio-lossless
	pgo-trainer-video-2-pass-constrained-quality
	pgo-trainer-video-constrained-quality
	pgo-trainer-video-lossless
"
IUSE+=" cfi cfi-cast cfi-icall cfi-vcall clang cfi-cross-dso hardened lto shadowcallstack"

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
)
ARM_CPU_REQUIRED_USE="
	arm64? ( cpu_flags_arm_v8 )
	cpu_flags_arm_v8? (  cpu_flags_arm_vfpv3 cpu_flags_arm_neon )
	cpu_flags_arm_neon? ( cpu_flags_arm_thumb2 cpu_flags_arm_vfp )
	cpu_flags_arm_vfpv3? ( cpu_flags_arm_vfp )
	cpu_flags_arm_thumb2? ( cpu_flags_arm_v6 )
	cpu_flags_arm_v6? ( cpu_flags_arm_thumb )
"
MIPS_CPU_FEATURES=( mipsdspr1:mipsdsp mipsdspr2 mipsfpu )
PPC_CPU_FEATURES=( cpu_flags_ppc_altivec:altivec cpu_flags_ppc_vsx:vsx cpu_flags_ppc_vsx2:power8 )
PPC_CPU_REQUIRED_USE="
	cpu_flags_ppc_vsx? ( cpu_flags_ppc_altivec )
	cpu_flags_ppc_vsx2? ( cpu_flags_ppc_vsx )
"
X86_CPU_FEATURES_RAW=( 3dnow:amd3dnow 3dnowext:amd3dnowext aes:aesni avx:avx avx2:avx2 fma3:fma3 fma4:fma4 mmx:mmx mmxext:mmxext sse:sse sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4 sse4_2:sse42 xop:xop )
X86_CPU_FEATURES=( ${X86_CPU_FEATURES_RAW[@]/#/cpu_flags_x86_} )
X86_CPU_REQUIRED_USE="
	cpu_flags_x86_avx2? ( cpu_flags_x86_avx )
	cpu_flags_x86_fma4? ( cpu_flags_x86_avx )
	cpu_flags_x86_fma3? ( cpu_flags_x86_avx )
	cpu_flags_x86_xop?  ( cpu_flags_x86_avx )
	cpu_flags_x86_avx?  ( cpu_flags_x86_sse4_2 )
	cpu_flags_x86_aes? ( cpu_flags_x86_sse4_2 )
	cpu_flags_x86_sse4_2?  ( cpu_flags_x86_sse4_1 )
	cpu_flags_x86_sse4_1?  ( cpu_flags_x86_ssse3 )
	cpu_flags_x86_ssse3?  ( cpu_flags_x86_sse3 )
	cpu_flags_x86_sse3?  ( cpu_flags_x86_sse2 )
	cpu_flags_x86_sse2?  ( cpu_flags_x86_sse )
	cpu_flags_x86_sse?  ( cpu_flags_x86_mmxext )
	cpu_flags_x86_mmxext?  ( cpu_flags_x86_mmx )
	cpu_flags_x86_3dnowext?  ( cpu_flags_x86_3dnow )
	cpu_flags_x86_3dnow?  ( cpu_flags_x86_mmx )
"

CPU_FEATURES_MAP=(
	${ARM_CPU_FEATURES[@]}
	${MIPS_CPU_FEATURES[@]}
	${PPC_CPU_FEATURES[@]}
	${X86_CPU_FEATURES[@]}
)
IUSE+=" ${CPU_FEATURES_MAP[@]%:*}"

CPU_REQUIRED_USE="
	${ARM_CPU_REQUIRED_USE}
	${PPC_CPU_REQUIRED_USE}
	${X86_CPU_REQUIRED_USE}
"

FFTOOLS=( aviocat cws2fws ffescape ffeval ffhash fourcc2pixfmt graph2dot ismindex pktdumper qt-faststart sidxindex trasher )
IUSE+=" ${FFTOOLS[@]/#/+fftools_}"

RDEPEND+="
	alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	amr? ( >=media-libs/opencore-amr-0.1.3-r1[${MULTILIB_USEDEP}] )
	bluray? ( >=media-libs/libbluray-0.3.0-r1:=[${MULTILIB_USEDEP}] )
	bs2b? ( >=media-libs/libbs2b-3.1.0-r1[${MULTILIB_USEDEP}] )
	bzip2? ( >=app-arch/bzip2-1.0.6-r4[${MULTILIB_USEDEP}] )
	cdio? ( >=dev-libs/libcdio-paranoia-0.90_p1-r1[${MULTILIB_USEDEP}] )
	chromaprint? ( >=media-libs/chromaprint-1.2-r1[${MULTILIB_USEDEP}] )
	codec2? ( media-libs/codec2[${MULTILIB_USEDEP}] )
	dav1d? ( >=media-libs/dav1d-0.4.0:0=[${MULTILIB_USEDEP}] )
	encode? (
		amrenc? ( >=media-libs/vo-amrwbenc-0.1.2-r1[${MULTILIB_USEDEP}] )
		kvazaar? ( >=media-libs/kvazaar-1.2.0[${MULTILIB_USEDEP}] )
		mp3? ( >=media-sound/lame-3.99.5-r1[${MULTILIB_USEDEP}] )
		openh264? ( >=media-libs/openh264-1.4.0-r1:=[${MULTILIB_USEDEP}] )
		rav1e? ( >=media-video/rav1e-0.4:=[capi] )
		snappy? ( >=app-arch/snappy-1.1.2-r1:=[${MULTILIB_USEDEP}] )
		theora? (
			>=media-libs/libtheora-1.1.1[encode,${MULTILIB_USEDEP}]
			>=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}]
		)
		twolame? ( >=media-sound/twolame-0.3.13-r1[${MULTILIB_USEDEP}] )
		webp? ( >=media-libs/libwebp-0.3.0:=[${MULTILIB_USEDEP}] )
		x264? ( >=media-libs/x264-0.0.20130506:=[${MULTILIB_USEDEP}] )
		x265? ( >=media-libs/x265-1.6:=[${MULTILIB_USEDEP}] )
		xvid? ( >=media-libs/xvid-1.3.2-r1[${MULTILIB_USEDEP}] )
	)
	fdk? ( >=media-libs/fdk-aac-0.1.3:=[${MULTILIB_USEDEP}] )
	flite? ( >=app-accessibility/flite-1.4-r4[${MULTILIB_USEDEP}] )
	fontconfig? ( >=media-libs/fontconfig-2.10.92[${MULTILIB_USEDEP}] )
	frei0r? ( media-plugins/frei0r-plugins[${MULTILIB_USEDEP}] )
	fribidi? ( >=dev-libs/fribidi-0.19.6[${MULTILIB_USEDEP}] )
	gcrypt? ( >=dev-libs/libgcrypt-1.6:0=[${MULTILIB_USEDEP}] )
	gme? ( >=media-libs/game-music-emu-0.6.0[${MULTILIB_USEDEP}] )
	gmp? ( >=dev-libs/gmp-6:0=[${MULTILIB_USEDEP}] )
	gsm? ( >=media-sound/gsm-1.0.13-r1[${MULTILIB_USEDEP}] )
	iconv? ( >=virtual/libiconv-0-r1[${MULTILIB_USEDEP}] )
	iec61883? (
		>=media-libs/libiec61883-1.2.0-r1[${MULTILIB_USEDEP}]
		>=sys-libs/libraw1394-2.1.0-r1[${MULTILIB_USEDEP}]
		>=sys-libs/libavc1394-0.5.4-r1[${MULTILIB_USEDEP}]
	)
	ieee1394? (
		>=media-libs/libdc1394-2.2.1:2=[${MULTILIB_USEDEP}]
		>=sys-libs/libraw1394-2.1.0-r1[${MULTILIB_USEDEP}]
	)
	jack? ( virtual/jack[${MULTILIB_USEDEP}] )
	jpeg2k? ( >=media-libs/openjpeg-2:2[${MULTILIB_USEDEP}] )
	libaom? ( >=media-libs/libaom-1.0.0-r1:=[cfi?,cfi-cast?,cfi-cross-dso?,cfi-icall?,cfi-vcall?,clang?,hardened?,shadowcallstack?,${MULTILIB_USEDEP}] )
	libaribb24? ( >=media-libs/aribb24-1.0.3-r2[${MULTILIB_USEDEP}] )
	libass? ( >=media-libs/libass-0.10.2:=[${MULTILIB_USEDEP}] )
	libcaca? ( >=media-libs/libcaca-0.99_beta18-r1[${MULTILIB_USEDEP}] )
	libdrm? ( x11-libs/libdrm[${MULTILIB_USEDEP}] )
	libilbc? ( >=media-libs/libilbc-2[${MULTILIB_USEDEP}] )
	librtmp? ( >=media-video/rtmpdump-2.4_p20131018[${MULTILIB_USEDEP}] )
	libsoxr? ( >=media-libs/soxr-0.1.0[${MULTILIB_USEDEP}] )
	libtesseract? ( >=app-text/tesseract-4.1.0-r1[${MULTILIB_USEDEP}] )
	libv4l? ( >=media-libs/libv4l-0.9.5[${MULTILIB_USEDEP}] )
	libxml2? ( dev-libs/libxml2:=[${MULTILIB_USEDEP}] )
	lv2? ( media-libs/lv2[${MULTILIB_USEDEP}] media-libs/lilv[${MULTILIB_USEDEP}] )
	lzma? ( >=app-arch/xz-utils-5.0.5-r1[${MULTILIB_USEDEP}] )
	mmal? ( media-libs/raspberrypi-userland )
	modplug? ( >=media-libs/libmodplug-0.8.8.4-r1[${MULTILIB_USEDEP}] )
	openal? ( >=media-libs/openal-1.15.1[${MULTILIB_USEDEP}] )
	opencl? ( virtual/opencl[${MULTILIB_USEDEP}] )
	opengl? ( >=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}] )
	opus? ( >=media-libs/opus-1.0.2-r2[${MULTILIB_USEDEP}] )
	pulseaudio? ( >=media-sound/pulseaudio-2.1-r1[gdbm?,${MULTILIB_USEDEP}] )
	rubberband? ( >=media-libs/rubberband-1.8.1-r1[${MULTILIB_USEDEP}] )
	samba? ( >=net-fs/samba-3.6.23-r1[client,${MULTILIB_USEDEP}] )
	sdl? ( media-libs/libsdl2[sound,video,${MULTILIB_USEDEP}] )
	sndio? ( media-sound/sndio:=[${MULTILIB_USEDEP}] )
	speex? ( >=media-libs/speex-1.2_rc1-r1[${MULTILIB_USEDEP}] )
	srt? ( >=net-libs/srt-1.3.0:=[${MULTILIB_USEDEP}] )
	ssh? ( >=net-libs/libssh-0.5.5[${MULTILIB_USEDEP}] )
	svg? (
		gnome-base/librsvg:2=[${MULTILIB_USEDEP}]
		x11-libs/cairo[${MULTILIB_USEDEP}]
	)
	truetype? ( >=media-libs/freetype-2.5.0.1:2[${MULTILIB_USEDEP}] )
	vaapi? ( >=x11-libs/libva-1.2.1-r1:0=[${MULTILIB_USEDEP}] )
	video_cards_nvidia? ( >=media-libs/nv-codec-headers-9.1.23.1[${MULTILIB_USEDEP}] )
	vdpau? ( >=x11-libs/libvdpau-0.7[${MULTILIB_USEDEP}] )
	vidstab? ( >=media-libs/vidstab-1.1.0[${MULTILIB_USEDEP}] )
	vorbis? (
		>=media-libs/libvorbis-1.3.3-r1[${MULTILIB_USEDEP}]
		>=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}]
	)
	vpx? ( >=media-libs/libvpx-1.4.0:=[cfi?,cfi-cast?,cfi-cross-dso?,cfi-icall?,cfi-vcall?,clang?,hardened?,shadowcallstack?,${MULTILIB_USEDEP}] )
	vulkan? ( >=media-libs/vulkan-loader-1.1.97:=[${MULTILIB_USEDEP}] )
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXv-1.0.10[${MULTILIB_USEDEP}]
		>=x11-libs/libxcb-1.4[${MULTILIB_USEDEP}]
	)
	zeromq? ( >=net-libs/zeromq-4.1.6 )
	zimg? ( >=media-libs/zimg-2.7.4:=[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[hardened?,${MULTILIB_USEDEP}] )
	zvbi? ( >=media-libs/zvbi-0.2.35[${MULTILIB_USEDEP}] )
	postproc? ( !media-libs/libpostproc )
" # CFI is optional for systemwide zlib CFI because it only works on clang only linux
#	zlib? ( >=sys-libs/zlib-1.2.8-r1[cfi?,cfi-icall?,cfi-cast?,cfi-vcall?,hardened?,shadowcallstack?,${MULTILIB_USEDEP}] )

RDEPEND+="
		openssl? (
			apache2_0? ( >=dev-libs/openssl-3.0.0_beta2:0=[${MULTILIB_USEDEP}] )
			!apache2_0? (
				>=dev-libs/openssl-1.0.1h-r2:0=[${MULTILIB_USEDEP}]
				<dev-libs/openssl-3:=[${MULTILIB_USEDEP}]
			)
		)
		!openssl? ( gnutls? ( >=net-libs/gnutls-2.12.23-r6:=[${MULTILIB_USEDEP}] ) )
"

_seq() {
	local min=${1}
	local max=${2}
	local i=${min}
	while (( ${i} <= ${max} )) ; do
		echo "${i}"
		i=$(( ${i} + 1 ))
	done
}

gen_cfi_bdepend() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}[${MULTILIB_USEDEP}]
			sys-devel/llvm:${v}[${MULTILIB_USEDEP}]
			=sys-devel/clang-runtime-${v}*[${MULTILIB_USEDEP},compiler-rt,sanitize]
			>=sys-devel/lld-${v}
			=sys-libs/compiler-rt-${v}*
			=sys-libs/compiler-rt-sanitizers-${v}*:=[cfi]
		)
		     "
	done
}

gen_shadowcallstack_bdepend() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}[${MULTILIB_USEDEP}]
			sys-devel/llvm:${v}[${MULTILIB_USEDEP}]
			=sys-devel/clang-runtime-${v}*[${MULTILIB_USEDEP},compiler-rt,sanitize]
			>=sys-devel/lld-${v}
			=sys-libs/compiler-rt-${v}*
			=sys-libs/compiler-rt-sanitizers-${v}*:=[shadowcallstack?]
		)
		     "
	done
}

gen_lto_bdepend() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}[${MULTILIB_USEDEP}]
			sys-devel/llvm:${v}[${MULTILIB_USEDEP}]
			=sys-devel/clang-runtime-${v}*[${MULTILIB_USEDEP}]
			>=sys-devel/lld-${v}
		)
		"
	done
}

gen_libcxx_depend() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/llvm:${v}[${MULTILIB_USEDEP}]
			libcxx? (
				>=sys-libs/libcxx-${v}:=[cfi?,cfi-cast?,cfi-cross-dso?,cfi-icall?,cfi-vcall?,clang?,hardened?,shadowcallstack?,static-libs?,${MULTILIB_USEDEP}]
			)
		)
		"
	done
}

DEPEND+="
	ladspa? ( >=media-libs/ladspa-sdk-1.13-r2[${MULTILIB_USEDEP}] )
	v4l? ( sys-kernel/linux-headers )
"

BDEPEND+=" cfi? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" cfi-vcall? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" cfi-cast? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" cfi-icall? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" clang? ( || ( $(gen_lto_bdepend 10 14) ) )"
BDEPEND+=" lto? ( clang? ( || ( $(gen_lto_bdepend 11 14) ) ) )"
BDEPEND+=" shadowcallstack? ( arm64? ( || ( $(gen_shadowcallstack_bdepend 10 14) ) ) )"

BDEPEND+="
	>=sys-devel/make-3.81
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	cpu_flags_x86_mmx? ( || ( >=dev-lang/nasm-2.13 >=dev-lang/yasm-1.3 ) )
	cuda? ( >=sys-devel/clang-7[llvm_targets_NVPTX] )
	doc? ( sys-apps/texinfo )
	test? ( net-misc/wget sys-devel/bc )
"

PDEPEND+="
	pgo? (
		media-video/ffmpeg[encode,${MULTILIB_USEDEP}]
	)
"

# GPL_REQUIRED_USE moved to LICENSE_REQUIRED_USE
REQUIRED_USE+="
	cuda? ( video_cards_nvidia )
	libv4l? ( v4l )
	fftools_cws2fws? ( zlib )
	test? ( encode )
	${GPL_REQUIRED_USE}
	${CPU_REQUIRED_USE}"
# Linking utils with only CFI Cross-DSO (.so).
REQUIRED_USE+="
	cfi? ( clang lto )
	cfi-cast? ( clang cfi-vcall lto static-libs )
	cfi-cross-dso? ( || ( cfi cfi-vcall ) )
	cfi-icall? ( clang cfi-vcall lto static-libs )
	cfi-vcall? ( clang lto static-libs )
	pgo? (
		|| (
			pgo-custom-audio
			pgo-custom-video
			pgo-trainer-audio-cbr
			pgo-trainer-audio-vbr
			pgo-trainer-audio-lossless
			pgo-trainer-video-2-pass-constrained-quality
			pgo-trainer-video-constrained-quality
			pgo-trainer-video-lossless
		)
	)
	pgo-custom-video? ( pgo )
	pgo-trainer-audio-cbr? ( pgo )
	pgo-trainer-audio-vbr? ( pgo )
	pgo-trainer-audio-lossless? ( pgo )
	pgo-trainer-video-2-pass-constrained-quality? ( pgo )
	pgo-trainer-video-constrained-quality? ( pgo )
	pgo-trainer-video-lossless? ( pgo )
	shadowcallstack? ( clang )
"
RESTRICT="
	!test? ( test )
	fdk? ( bindist )
	openssl? ( bindist )
"

S="${WORKDIR}/${P/_/-}"
S_orig="${WORKDIR}/${P/_/-}"

PATCHES=(
	"${FILESDIR}"/chromium-r1.patch
)

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/libavutil/avconfig.h
)

build_separate_libffmpeg() {
	use opencl
}

pgo_check_video() {
	if [[ -z "${FFMPEG_PGO_VIDEO}" ]] ; then
eerror
eerror "FFMPEG_PGO_VIDEO is missing the abspath to your video as a"
eerror "per-package envvar.  The video must be 3840x2160 resolution,"
eerror "60fps, >= 3 seconds."
eerror
		die
	fi
	if ffprobe "${FFMPEG_PGO_VIDEO}" 2>/dev/null 1>/dev/null ; then
		einfo "Verifying asset requirements"
		if ! ( ffprobe "${FFMPEG_PGO_VIDEO}" 2>&1 \
			| grep -q -e "3840x2160" ) ; then
eerror
eerror "The PGO video sample must be 3840x2160."
eerror
			die
		fi
		if ! ( ffprobe "${FFMPEG_PGO_VIDEO}" 2>&1 \
			| grep -q -E -e ", (59|60)[.0-9]* fps" ) ; then
eerror
eerror "The PGO video sample must be >=59 fps."
eerror
			die
		fi

		local d=$(ffprobe "${FFMPEG_PGO_VIDEO}" 2>&1 \
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
		if (( ${t} < 3 )) ; then
eerror
eerror "The PGO video sample must be >= 3 seconds."
eerror
			die
		else
einfo "${FFMPEG_PGO_VIDEO} is accepted as a PGO trainer asset."
		fi
	else
eerror
eerror "${FFMPEG_PGO_VIDEO} is possibly not a valid video file.  Ensure that"
eerror "the proper codec is supported for that file in ${PN}."
eerror
	fi
}

AUDIO_SAMPLES_SUFFIX=(
	VOICE_00
	VOICE_01
	VOICE_02
	VOICE_03
	VOICE_04
	VOICE_05
	VOICE_06
	VOICE_07
	VOICE_08
	VOICE_09
	VOICE_10
	RADIO_00
	RADIO_01
	RADIO_02
	RADIO_03
	RADIO_04
	RADIO_05
	RADIO_06
	RADIO_07
	RADIO_08
	RADIO_09
	RADIO_10
	MUSIC_INSTRUMENTAL_00
	MUSIC_INSTRUMENTAL_01
	MUSIC_INSTRUMENTAL_02
	MUSIC_INSTRUMENTAL_03
	MUSIC_INSTRUMENTAL_04
	MUSIC_INSTRUMENTAL_05
	MUSIC_INSTRUMENTAL_06
	MUSIC_INSTRUMENTAL_07
	MUSIC_INSTRUMENTAL_08
	MUSIC_INSTRUMENTAL_09
	MUSIC_INSTRUMENTAL_10
	VOCAL_MUSIC_00
	VOCAL_MUSIC_01
	VOCAL_MUSIC_02
	VOCAL_MUSIC_03
	VOCAL_MUSIC_04
	VOCAL_MUSIC_05
	VOCAL_MUSIC_06
	VOCAL_MUSIC_07
	VOCAL_MUSIC_08
	VOCAL_MUSIC_09
	VOCAL_MUSIC_10
)

pgo_check_audio() {
	for s in ${AUDIO_SAMPLES_SUFFIX[@]} ; do
		local t="FFMPEG_PGO_AUDIO_${s}"
		local audio_sample="${!t}"
		if [[ -z "${audio_sample}" ]] ; then
			ewarn "Skipping ${t}."
			continue
		fi
		if [[ ! -f "${audio_sample}" ]] ; then
			ewarn "Skipping ${t} asset with no asset located at ${audio_sample}."
			continue
		fi
		if ffprobe "${audio_sample}" 2>/dev/null 1>/dev/null ; then
			einfo "Verifying asset requirements"
			local d=$(ffprobe "${audio_sample}" 2>&1 \
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
einfo "${audio_sample} is accepted as a PGO trainer asset."
		else
eerror
eerror "${t} is possibly not a valid audio file.  Ensure that"
eerror "the proper codec is supported for that file in ${PN}."
eerror
		fi
	done
}

pkg_setup() {
	if use pgo && has_version "media-video/ffmpeg" ; then
		ewarn "The PGO use flag is a Work In Progress (WIP)"
		if [[ -n "${FFMPEG_PGO_VIDEO_CODECS}" ]] ; then
			pgo_check_video
		fi
		if [[ -n "${FFMPEG_PGO_AUDIO_CODECS}" ]] ; then
			pgo_check_audio
		fi
	fi
	llvm_pkg_setup
}

get_build_types() {
	echo "shared-libs"
	use static-libs && echo "static-libs"
}

has_cfi() {
	local name="${1}"
	local ldflags_lib="${2}"
	if has_version "${1}[cfi]" \
		|| has_version "${1}[cfi-icall]" \
		|| has_version "${1}[cfi-vcall]" \
		|| has_version "${1}[cfi-cast]" \
		|| has_cfi_lib "${ldflags_lib}" ; then
		return 0
	fi
	return 1
}

src_prepare() {
	if [[ "${PV%_p*}" != "${PV}" ]] ; then # Snapshot
		export revision=git-N-${FFMPEG_REVISION}
	fi
	default
	echo 'include $(SRC_PATH)/ffbuild/libffmpeg.mak' >> Makefile || die

	einfo "Copying sources, please wait"
	prepare_abi() {
		for build_type in $(get_build_types) ; do
			einfo "Copying sources to ${S_orig}.${ABI}_${build_type/-*}"
			cp -a "${S_orig}" "${S_orig}.${ABI}_${build_type/-*}" || die

		done
	}
	multilib_foreach_abi prepare_abi
}

get_abi_use() {
	for p in $(multilib_get_enabled_abi_pairs) ; do
		[[ "${p}" =~ "${ABI}"$ ]] && echo "${p}" | cut -f 1 -d "."
	done
}

get_native_abi_use() {
	for p in $(multilib_get_enabled_abi_pairs) ; do
		[[ "${p}" =~ "${DEFAULT_ABI}"$ ]] && echo "${p}" | cut -f 1 -d "."
	done
}

get_multiabi_ffmpeg() {
	local btype="${build_type/-*}"
	if multilib_is_native_abi && has_version "media-video/ffmpeg[$(get_native_abi_use)]" ; then
		echo "${MY_ED}/usr/bin/ffmpeg-shared"
	elif ! multilib_is_native_abi && has_version "media-video/ffmpeg[$(get_abi_use ${ABI})]" ; then
		echo "${MY_ED}/usr/bin/ffmpeg-shared-${ABI}"
	else
		echo ""
	fi
}

has_ffmpeg() {
	local x=$(get_multiabi_ffmpeg)
	if [[ -n "${x}" && -e "${x}" ]] ; then
		return 0
	else
		return 1
	fi
}

has_codec_requirement() {
	codecs_found=1
	for s in ${AUDIO_SAMPLES_SUFFIX[@]} ; do
		local t="FFMPEG_PGO_AUDIO_${s}"
		local audio_sample="${!t}"
		if [[ -z "${audio_sample}" ]] ; then
			continue
		fi
		if [[ ! -f "${audio_sample}" ]] ; then
			continue
		fi
		if ffprobe "${audio_sample}" 2>/dev/null 1>/dev/null ; then
			codecs_found=0
		fi
	done
	return ${codecs_found}
}

has_pgo_requirement() {
	if has_ffmpeg && has_codec_requirement ; then
		return 0
	else
		return 1
	fi
}

append_all() {
	append-flags ${@}
	append-ldflags ${@}
}

append_lto() {
	filter-flags '-flto=*' '-fuse-ld=*'
	if tc-is-clang ; then
		append-flags -flto=thin
		append-ldflags -fuse-ld=lld -flto=thin
		[[ "${build_type}" == "static-libs" ]] \
			&& append_all -fsplit-lto-unit
	else
		append-flags -flto
		append-ldflags -flto
	fi
}

is_hardened_clang() {
	if tc-is-clang && clang --version 2>/dev/null | grep -q -e "Hardened:" ; then
		return 0
	fi
	return 1
}

is_hardened_gcc() {
	if tc-is-gcc && gcc --version 2>/dev/null | grep -q -e "Hardened" ; then
		return 0
	fi
	return 1
}

is_cfi_supported() {
	[[ "${USE}" =~ "cfi" ]] || return 1
	if [[ "${build_type}" == "static-libs" ]] ; then
		return 0
	elif use cfi-cross-dso && [[ "${build_type}" == "shared-libs" ]] ; then
		return 0
	fi
	return 1
}

configure_pgx() {
	local myconf=( )
	local extra_libs=( )

	einfo "configure_pgx is ${build_type} with PGO_PHASE=${PGO_PHASE}"

	if use clang ; then
		CC="clang $(get_abi_CFLAGS ${ABI})"
		CXX="clang++ $(get_abi_CFLAGS ${ABI})"
		AR=llvm-ar
		AS=llvm-as
		NM=llvm-nm
		RANLIB=llvm-ranlib
		READELF=llvm-readelf
		LD="${CC}"
	fi
	if tc-is-clang && ! use clang ; then
		die "You must enable the clang USE flag or remove clang/clang++ from CC/CXX."
	fi

	export CC CXX AR AS NM RANDLIB READELF LD

	filter-flags \
		'--param=ssp-buffer-size=*' \
		'-f*sanitize*' \
		'-f*stack*' \
		'-f*visibility*' \
		'-fprofile*' \
		'-fsplit-lto-unit' \
		'-lubsan' \
		'-stdlib=libc++' \
		'-Wl,--allow-shlib-undefined' \
		'-Wl,-lubsan' \
		'-Wl,-z,noexecstack' \
		'-Wl,-z,now' \
		'-Wl,-z,relro'

	autofix_flags

	set_cfi() {
		# The cfi enables all cfi schemes, but the selective tries to balance
		# performance and security while maintaining a performance limit.
		if tc-is-clang && is_cfi_supported ; then
			if [[ "${build_type}" == "static-libs" ]] ; then
				append_all -fvisibility=hidden
			elif use cfi-cross-dso && [[ "${build_type}" == "shared-libs" ]] ; then
				append_all -fvisibility=default
			fi
			if use cfi ; then
				append_all -fsanitize=cfi
			else
				use cfi-cast && append_all \
							-fsanitize=cfi-derived-cast \
							-fsanitize=cfi-unrelated-cast
				#use cfi-icall && append_all \
				#			-fsanitize=cfi-icall
				use cfi-vcall && append_all \
							-fsanitize=cfi-vcall
			fi
			[[ "${USE}" =~ "cfi" ]] && append-ldflags -Wl,-lubsan
			append_all -fno-sanitize=cfi-icall # Prevent illegal instruction with ffprobe
			use cfi-cross-dso \
				&& [[ "${build_type}" == "shared-libs" ]] \
				&& append_all -fsanitize-cfi-cross-dso
		fi
		use shadowcallstack && append-flags -fno-sanitize=safe-stack \
						-fsanitize=shadow-call-stack
	}

	# Silence ld.lld: error: libavcodec/libavcodec.so: undefined reference to vpx_codec_get_caps
	# Error happens when linking -lvpx and -lopenh264 together to make ffprobe_g.  Removing -lopenh264 fixes it.
	# -lopenh264 has no reference to libvpx, so lld is buggy.
	append-ldflags -Wl,--allow-shlib-undefined

	use hardened && append-ldflags -Wl,-z,noexecstack
	use lto && append_lto
	if is_hardened_gcc ; then
		:;
	elif is_hardened_clang ; then
		set_cfi
	else
		set_cfi
		# The cfi enables all cfi schemes, but the selective tries to balance
		# performance and security while maintaining a performance limit.
		# Use -fno-sanitize-trap= for debugging
		if use hardened ; then
			if [[ -n "${USE_HARDENED_PROFILE_DEFAULTS}" \
				&& "${USE_HARDENED_PROFILE_DEFAULTS}" == "1" ]] ; then
				append-cppflags -D_FORTIFY_SOURCE=2
				append-flags $(test-flags-CC -fstack-clash-protection)
				append-flags --param=ssp-buffer-size=4 \
						-fstack-protector-strong
				append-flags -fPIE
				myconf+=(
					--extra-ldexeflags="-fPIE"
					--extra-ldexeflags="-pie"
				)
			elif [[ -n "${USE_HARDENED_PACKAGE_DEFAULTS}" \
				&& "${USE_HARDENED_PACKAGE_DEFAULTS}" == "1" ]] ; then
				# Package settings (PIE (-fPIE -pie), SSP (-fstack-protector-all), Full RELRO,
				# _FORITIFY_SOURCE=2, -fno-strict-overflow)
				myconf+=( --hardened )
			else
				# Browser equivalent security settings
				append-ldflags -Wl,-z,relro -Wl,-z,now
				append-ldflags --param=ssp-buffer-size=4 \
						-fstack-protector
				append-flags -fPIE
				myconf+=(
					--extra-ldexeflags="-fPIE"
					--extra-ldexeflags="-pie"
				)
			fi
		fi
	fi

	if use hardened ; then
		# Fixes:
# ld.lld: error: can't create dynamic relocation R_386_32 against local symbol \
# in readonly segment; recompile object files with -fPIC or pass \
# '-Wl,-z,notext' to allow text relocations in the output
		append-ldflags -fPIC
#		append-ldflags -Wl,-z,notext
		#append-cppflags -DBROKEN_RELOCATIONS=1 # https://trac.ffmpeg.org/ticket/7878
		use clang && append-ldflags -Wl,-error-limit=0
	fi

	export FFMPEG=$(get_multiabi_ffmpeg)
	if use pgo && [[ "${PGO_PHASE}" == "pgi" ]] \
		&& has_pgo_requirement ; then
		einfo "Setting up PGI"
		if tc-is-clang ; then
			append-flags -fprofile-generate="${T}/pgo-${ABI}"
			append-ldflags -fprofile-generate="${T}/pgo-${ABI}" # It needs to link to libclang_rt.profile-xxx.a
		else
			append-flags -fprofile-generate -fprofile-dir="${T}/pgo-${ABI}"
		fi
	elif use pgo && [[ "${PGO_PHASE}" == "pgo" ]] \
		&& has_pgo_requirement ; then
		einfo "Setting up PGO"
		if tc-is-clang ; then
			llvm-profdata merge -output="${T}/pgo-${ABI}/code.profdata" \
				"${T}/pgo-${ABI}" || die
			append-flags -fprofile-use="${T}/pgo-${ABI}/code.profdata"
			append-ldflags -fprofile-use="${T}/pgo-${ABI}/code.profdata"
		else
			append-flags -fprofile-use -fprofile-correction -fprofile-dir="${T}/pgo-${ABI}"
		fi
	fi

	# Licensing of external packages
	# See https://github.com/FFmpeg/FFmpeg/blob/n4.4/configure#L1735
	use nonfree && myconf+=( --enable-nonfree )

	# See https://github.com/FFmpeg/FFmpeg/blob/n4.4/configure#L1742
	# Allow external Apache-2.0, GPL-3, LGPL-3 packages together under GPL-3 or LGPL-3.
	# Linking to a GPL-3 will upgrade LGPL-2.1 to GPL-3/GPL-3+.
	# Linking to a non GPL package will upgrade LGPL-2.1 to LGPL-3/LGPL-3+.
	use version3 && myconf+=( --enable-version3 )

	if use gpl3 || use gpl3x ; then
		:;
	elif use gpl2 || use gpl2x ; then
		# See https://github.com/FFmpeg/FFmpeg/blob/n4.4/configure#L1721
		myconf+=( --enable-gpl ) # gpl in --enable-gpl refers to gpl2 or gpl2x
	fi

	original_licensing_enablement() {
		use openssl && myconf+=( --enable-nonfree )
		use samba && myconf+=( --enable-version3 )

		# Encoders
		if use encode ; then
			# Licensing.
			if use amrenc ; then
				myconf+=( --enable-version3 )
			fi
		fi

		# Decoders
		use amr && myconf+=( --enable-version3 )
		use gmp && myconf+=( --enable-version3 )
		use libaribb24 && myconf+=( --enable-version3 )
		use fdk && use gpl && myconf+=( --enable-nonfree )
	}
	# original_licensing_enablement

	local ffuse=( "${FFMPEG_FLAG_MAP[@]}" )

	# Encoders
	if use encode ; then
		ffuse+=( "${FFMPEG_ENCODER_FLAG_MAP[@]}" )
	else
		myconf+=( --disable-encoders )
	fi

	# Indevs
	use v4l || myconf+=( --disable-indev=v4l2 --disable-outdev=v4l2 )
	for i in alsa oss jack sndio ; do
		use ${i} || myconf+=( --disable-indev=${i} )
	done

	# Outdevs
	for i in alsa oss sndio ; do
		use ${i} || myconf+=( --disable-outdev=${i} )
	done

	for i in "${ffuse[@]#+}" ; do
		myconf+=( $(use_enable ${i%:*} ${i#*:}) )
	done

	if use openssl ; then
		myconf+=( --disable-gnutls )
	fi

	# (temporarily) disable non-multilib deps
	if ! multilib_is_native_abi; then
		for i in librav1e libzmq ; do
			myconf+=( --disable-${i} )
		done
	fi

	# CPU features
	for i in "${CPU_FEATURES_MAP[@]}" ; do
		use ${i%:*} || myconf+=( --disable-${i#*:} )
	done

	if use pic ; then
		myconf+=( --enable-pic )
		# disable asm code if PIC is required
		# as the provided asm decidedly is not PIC for x86.
		[[ ${ABI} == x86 ]] && myconf+=( --disable-asm )
	fi
	[[ ${ABI} == x32 ]] && myconf+=( --disable-asm ) #427004

	# Try to get cpu type based on CFLAGS.
	# Bug #172723
	# We need to do this so that features of that CPU will be better used
	# If they contain an unknown CPU it will not hurt since ffmpeg's configure
	# will just ignore it.
	for i in $(get-flag mcpu) $(get-flag march) ; do
		[[ ${i} = native ]] && i="host" # bug #273421
		myconf+=( --cpu=${i} )
		break
	done

	if use lto && tc-is-clang ; then
		:;
	elif use lto && ! tc-is-clang ; then
		# LTO support, bug #566282, bug #754654
		is-flagq "-flto*" && myconf+=( "--enable-lto" )
		filter-flags "-flto*"
	fi

	# Mandatory configuration
	myconf=(
		--enable-avfilter
		--enable-avresample
		--disable-stripping
		# This is only for hardcoded cflags; those are used in configure checks that may
		# interfere with proper detections, bug #671746 and bug #645778
		# We use optflags, so that overrides them anyway.
		--disable-optimizations
		--disable-libcelt # bug #664158
		"${myconf[@]}"
	)

	# cross compile support
	if tc-is-cross-compiler ; then
		myconf+=( --enable-cross-compile --arch=$(tc-arch-kernel) --cross-prefix=${CHOST}- --host-cc="$(tc-getBUILD_CC)" )
		case ${CHOST} in
			*freebsd*)
				myconf+=( --target-os=freebsd )
				;;
			*mingw32*)
				myconf+=( --target-os=mingw32 )
				;;
			*linux*)
				myconf+=( --target-os=linux )
				;;
		esac
	fi

	# doc
	myconf+=(
		$(multilib_native_use_enable doc)
		$(multilib_native_use_enable doc htmlpages)
		$(multilib_native_enable manpages)
	)

	if use arm || use ppc ; then
		# bug #782811
		# bug #790590
		extra_libs+=( --extra-libs="$(test-flags-CCLD -latomic)" )
	fi

	local static_args=()
	if [[ "${build_type}" == "static-libs" ]] ; then
		static_args=( --enable-static --disable-shared )
	else
		static_args=( --disable-static --enable-shared )
	fi

	set -- "${S}/configure" \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--shlibdir="${EPREFIX}/usr/$(get_libdir)" \
		--docdir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--mandir="${EPREFIX}/usr/share/man" \
		--cc="$(tc-getCC)" \
		--cxx="$(tc-getCXX)" \
		--ar="$(tc-getAR)" \
		--nm="$(tc-getNM)" \
		--ranlib="$(tc-getRANLIB)" \
		--pkg-config="$(tc-getPKG_CONFIG)" \
		--optflags="${CFLAGS}" \
		"${extra_libs[@]}" \
		${static_args[@]} \
		"${myconf[@]}" \
		${EXTRA_FFMPEG_CONF}
	echo "${@}"
	"${@}" || die

	if [[ -f Makefile && "${PGO_PHASE}" == "pgo" ]] ; then
		einfo "Cleaning build"
		emake clean
	fi

	if multilib_is_native_abi && use chromium && build_separate_libffmpeg; then
		einfo "Configuring for Chromium"
		mkdir -p ../chromium || die
		pushd ../chromium >/dev/null || die
		set -- "${@}" \
			--disable-shared \
			--enable-static \
			--enable-pic \
			--disable-opencl
		echo "${@}"
		"${@}" || die
		popd >/dev/null || die
	fi
}

_adecode() {
	einfo "Decoding ${1}"
	cmd=( "${FFMPEG}" -i "${T}/test.${extension}" -f null - )
	einfo "LD_LIBRARY_PATH=\"${ED}/usr/$(get_libdir)\" ${cmd[@]}"
	LD_LIBRARY_PATH="${ED}/usr/$(get_libdir)" \
	"${cmd[@]}" || die
}

_vdecode() {
	einfo "Decoding ${1}"
	cmd=( "${FFMPEG}" -i "${T}/test.${extension}" -f null - )
	einfo "LD_LIBRARY_PATH=\"${ED}/usr/$(get_libdir)\" ${cmd[@]}"
	LD_LIBRARY_PATH="${ED}/usr/$(get_libdir)" \
	"${cmd[@]}" || die
}

_trainer_plan_audio_custom() {
	local audio_scenario="${1}"
	local encoding_codec="${2}"
	local decoding_codec="${3}"
	local extension="${4}"
	local tags="${5}"
	local training_args=
	local training_args_lossless=

	local name="${encoding_codec^^}"
	name="${name//-/_}"
	local envvar="FFMPEG_PGO_${name}_ARGS"
	if [[ -n "${!envvar}" ]] ; then
		training_args="${!envvar}"
	fi
	local envvar="FFMPEG_PGO_${name}_ARGS_LOSSLESS"
	if [[ -n "${!envvar}" ]] ; then
		training_args_lossless="${!envvar}"
	fi

	if use pgo-custom-audio && [[ -e "pgo-custom-audio.sh" ]] ; then
		chown portage:portage pgo-custom-audio.sh || die
		chmod +x pgo-custom-audio || die
		./pgo-custom-audio.sh || die
	elif use pgo-custom-audio && [[ ! -e "pgo-custom-audio.sh" ]] ; then
eerror
eerror "Could not find pgo-custom-audio.sh in ${S}"
eerror
		die
	fi
}

_trainer_plan_video_custom() {
	local encoding_codec="${1}"
	local decoding_codec="${2}"
	local ext="${3}"
	local tags="${4}"
	local training_args=
	local training_args_lossless=

	local name="${encoding_codec^^}"
	name="${name//-/_}"
	local envvar="FFMPEG_PGO_${name}_ARGS"
	if [[ -n "${!envvar}" ]] ; then
		training_args="${!envvar}"
	fi
	local envvar="FFMPEG_PGO_${name}_ARGS_LOSSLESS"
	if [[ -n "${!envvar}" ]] ; then
		training_args_lossless="${!envvar}"
	fi

	if use pgo-custom-video && [[ -e "pgo-custom-video.sh" ]] ; then
		chown portage:portage pgo-custom-video.sh || die
		chmod +x pgo-custom-video || die
		./pgo-custom-video.sh || die
	elif use pgo-custom-video && [[ ! -e "pgo-custom-video.sh" ]] ; then
eerror
eerror "Could not find pgo-custom-video.sh in ${S}"
eerror
		die
	fi
}

_trainer_plan_video_constrained_quality() {
	local encoding_codec="${1}"
	local decoding_codec="${2}"
	local extension="${3}"
	local training_args=

	local name="${encoding_codec^^}"
	name="${name//-/_}"
	local envvar="FFMPEG_PGO_${name}_ARGS"
	if [[ -n "${!envvar}" ]] ; then
		training_args="${!envvar}"
	fi

	if use pgo \
		&& has_pgo_requirement ; then
		einfo "Running PGO trainer for ${encoding_codec} for 1 pass constrained quality"
		local cmd
		einfo "Encoding as 720p for 3 sec, 30 fps"
		cmd=( "${FFMPEG}" \
			-y \
			-i "${FFMPEG_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 1485k -minrate 512k -b:v 1024k \
			-vf scale=w=-1:h=720 \
			${training_args} \
			-an \
			-r 30 \
			-t 3 \
			"${T}/test.${extension}" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd[@]}" || die
		_vdecode "720p, 30 fps"

		einfo "Encoding as 720p for 3 sec, 60 fps"
		cmd=( "${FFMPEG}" \
			-y \
			-i "${FFMPEG_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 2610k -minrate 900k -b:v 1800k \
			-vf scale=w=-1:h=720 \
			${training_args} \
			-an \
			-r 60 \
			-t 3 \
			"${T}/test.${extension}" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd[@]}" || die
		_vdecode "720p, 60 fps"

		einfo "Encoding as 1080p for 3 sec, 30 fps"
		cmd=( "${FFMPEG}" \
			-y \
			-i "${FFMPEG_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 2610k -minrate 900k -b:v 1800k \
			-vf scale=w=-1:h=1080 \
			${training_args} \
			-an \
			-r 30 \
			-t 3 \
			"${T}/test.${extension}" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd[@]}" || die
		_vdecode "1080p, 30 fps"

		einfo "Encoding as 1080p for 3 sec, 60 fps"
		cmd=( "${FFMPEG}" \
			-y \
			-i "${FFMPEG_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 4350k -minrate 1500k -b:v 3000k \
			-vf scale=w=-1:h=1080 \
			${training_args} \
			-an \
			-r 60 \
			-t 3 \
			"${T}/test.${extension}" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd[@]}" || die
		_vdecode "1080p, 60 fps"

		einfo "Encoding as 4k for 3 sec, 30 fps"
		cmd=( "${FFMPEG}" \
			-y \
			-i "${FFMPEG_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 17400k -minrate 6000k -b:v 12000k \
			-vf scale=w=-1:h=2160 \
			${training_args} \
			-an \
			-r 30 \
			-t 3 \
			"${T}/test.${extension}" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd[@]}" || die
		_vdecode "4k, 30 fps"

		einfo "Encoding as 4k for 3 sec, 60 fps"
		cmd=( "${FFMPEG}" \
			-y \
			-i "${FFMPEG_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 26100k -minrate 9000k -b:v 18000k \
			-vf scale=w=-1:h=2160 \
			${training_args} \
			-an \
			-r 60 \
			-t 3 \
			"${T}/test.${extension}" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd[@]}" || die
		_vdecode "4k, 60 fps"
	fi
}

_trainer_plan_video_2_pass_constrained_quality() {
	local encoding_codec="${1}"
	local decoding_codec="${2}"
	local extension="${3}"
	local training_args=

	local name="${encoding_codec^^}"
	name="${name//-/_}"
	local envvar="FFMPEG_PGO_${name}_ARGS"
	if [[ -n "${!envvar}" ]] ; then
		training_args="${!envvar}"
	fi

	if use pgo \
		&& has_pgo_requirement ; then
		einfo "Running PGO trainer for ${encoding_codec} for 2 pass constrained quality"
		local cmd
		einfo "Encoding as 720p for 3 sec, 30 fps"
		cmd1=( "${FFMPEG}" \
			-y \
			-i "${FFMPEG_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 1485k -minrate 512k -b:v 1024k \
			-vf scale=w=-1:h=720 \
			${training_args} \
			-pass 1 \
			-an \
			-r 30 \
			-t 3 \
			-f null /dev/null )
		cmd2=( "${FFMPEG}" \
			-y \
			-i "${FFMPEG_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 1485k -minrate 512k -b:v 1024k \
			-vf scale=w=-1:h=720 \
			${training_args} \
			-pass 2 \
			-an \
			-r 30 \
			-t 3 \
			"${T}/test.${extension}" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd1[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd1[@]}" || die
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd2[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd2[@]}" || die
		_vdecode "720p, 30 fps"

		einfo "Encoding as 720p for 3 sec, 60 fps"
		cmd1=( "${FFMPEG}" \
			-y \
			-i "${FFMPEG_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 2610k -minrate 900k -b:v 1800k \
			-vf scale=w=-1:h=720 \
			${training_args} \
			-pass 1 \
			-an \
			-r 60 \
			-t 3 \
			-f null /dev/null )
		cmd2=( "${FFMPEG}" \
			-y \
			-i "${FFMPEG_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 2610k -minrate 900k -b:v 1800k \
			-vf scale=w=-1:h=720 \
			${training_args} \
			-pass 2 \
			-an \
			-r 60 \
			-t 3 \
			"${T}/test.${extension}" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd1[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd1[@]}" || die
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd2[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd2[@]}" || die
		_vdecode "720p, 60 fps"

		einfo "Encoding as 1080p for 3 sec, 30 fps"
		cmd1=( "${FFMPEG}" \
			-y \
			-i "${FFMPEG_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 2610k -minrate 900k -b:v 1800k \
			-vf scale=w=-1:h=1080 \
			${training_args} \
			-pass 1 \
			-an \
			-r 30 \
			-t 3 \
			-f null /dev/null )
		cmd2=( "${FFMPEG}" \
			-y \
			-i "${FFMPEG_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 2610k -minrate 900k -b:v 1800k \
			-vf scale=w=-1:h=1080 \
			${training_args} \
			-pass 2 \
			-an \
			-r 30 \
			-t 3 \
			"${T}/test.${extension}" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd1[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd1[@]}" || die
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd2[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd2[@]}" || die
		_vdecode "1080p, 30 fps"

		einfo "Encoding as 1080p for 3 sec, 60 fps"
		cmd1=( "${FFMPEG}" \
			-y \
			-i "${FFMPEG_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 4350k -minrate 1500k -b:v 3000k \
			-vf scale=w=-1:h=1080 \
			${training_args} \
			-pass 1 \
			-an \
			-r 60 \
			-t 3 \
			-f null /dev/null )
		cmd2=( "${FFMPEG}" \
			-y \
			-i "${FFMPEG_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 4350k -minrate 1500k -b:v 3000k \
			-vf scale=w=-1:h=1080 \
			${training_args} \
			-pass 2 \
			-an \
			-r 60 \
			-t 3 \
			"${T}/test.${extension}" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd1[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd1[@]}" || die
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd2[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd2[@]}" || die
		_vdecode "1080p, 60 fps"

		einfo "Encoding as 4k for 3 sec, 30 fps"
		cmd1=( "${FFMPEG}" \
			-y \
			-i "${FFMPEG_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 17400k -minrate 6000k -b:v 12000k \
			-vf scale=w=-1:h=2160 \
			${training_args} \
			-pass 1 \
			-an \
			-r 30 \
			-t 3 \
			-f null /dev/null )
		cmd2=( "${FFMPEG}" \
			-y \
			-i "${FFMPEG_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 17400k -minrate 6000k -b:v 12000k \
			-vf scale=w=-1:h=2160 \
			${training_args} \
			-pass 2 \
			-an \
			-r 30 \
			-t 3 \
			"${T}/test.${extension}" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd1[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd1[@]}" || die
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd2[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd2[@]}" || die
		_vdecode "4k, 30 fps"

		einfo "Encoding as 4k for 3 sec, 60 fps"
		cmd1=( "${FFMPEG}" \
			-y \
			-i "${FFMPEG_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 26100k -minrate 9000k -b:v 18000k \
			-vf scale=w=-1:h=2160 \
			${training_args} \
			-pass 1 \
			-an \
			-r 60 \
			-t 3 \
			-f null /dev/null )
		cmd2=( "${FFMPEG}" \
			-y \
			-i "${FFMPEG_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 26100k -minrate 9000k -b:v 18000k \
			-vf scale=w=-1:h=2160 \
			${training_args} \
			-pass 2 \
			-an \
			-r 60 \
			-t 3 \
			"${T}/test.${extension}" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd1[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd1[@]}" || die
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd2[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd2[@]}" || die
		_vdecode "4k, 60 fps"
	fi
}

_trainer_plan_audio_lossless() {
	local audio_scenario="${1}"
	local encoding_codec="${2}"
	local decoding_codec="${3}"
	local extension="${4}"
	local training_args=

	if [[ "${encoding_codec}" =~ ("flac"|"tta"|"wavpack") ]] ; then
		:;
	else
		return
	fi

	local name="${encoding_codec^^}"
	name="${name//-/_}"
	local envvar="FFMPEG_PGO_${name}_ARGS_LOSSLESS"
	if [[ -n "${!envvar}" ]] ; then
		training_args="${!envvar}"
	fi

	if use pgo \
		&& has_pgo_requirement ; then
		for s in ${AUDIO_SAMPLES_SUFFIX[@]} ; do
			local t="FFMPEG_PGO_AUDIO_${s}"
			local audio_sample="${!t}"
			if [[ -z "${audio_sample}" || ! -f "${audio_sample}" ]] ; then
				ewarn "Skipping ${t}"
				continue
			fi
			if ! ffprobe "${audio_sample}" 2>/dev/null 1>/dev/null ; then
				ewarn "Skipping ${t} with path ${audio_sample}.  Decoding not possible or bad file."
				continue
			fi

			if [[ "${audio_scenario}" == "music" && ! ( "${s}" =~ "MUSIC" ) ]] ; then
				continue
			elif [[ "${audio_scenario}" == "radio" && ! ( "${s}" =~ "RADIO" ) ]] ; then
				continue
			elif [[ "${audio_scenario}" == "voice" && ! ( "${s}" =~ "VOICE" ) ]] ; then
				continue
			fi

			einfo "Running PGO trainer for ${encoding_codec} for lossless"
			einfo "Encoding for lossless audio"
			local cmd
			cmd=( "${FFMPEG}" \
				-y \
				-i "${audio_sample}" \
				-c:v ${encoding_codec} \
				${training_args} \
				-t 3 \
				"${T}/test.${extension}" )
			einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd[@]}"
			LD_LIBRARY_PATH="${BUILD_DIR}" \
			"${cmd[@]}" || die
			_adecode "lossless"
		done
	fi
}

_trainer_plan_video_lossless() {
	local encoding_codec="${1}"
	local decoding_codec="${2}"
	local extension="${3}"
	local training_args=
	local codec_args=()

	local name="${encoding_codec^^}"
	name="${name//-/_}"
	local envvar="FFMPEG_PGO_${name}_ARGS_LOSSLESS"
	if [[ -n "${!envvar}" ]] ; then
		training_args="${!envvar}"
	fi

	[[ "${encoding_codec}" =~ "vp9" ]] && codec_args+=( -lossless 1 )

	if use pgo \
		&& has_pgo_requirement ; then
		einfo "Running PGO trainer for ${encoding_codec} for lossless"
		einfo "Encoding for lossless video"
		local cmd
		cmd=( "${FFMPEG}" \
			-y \
			-i "${FFMPEG_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			${codec_args[@]} \
			${training_args} \
			-an \
			-t 3 \
			"${T}/test.${extension}" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd[@]}" || die
		_vdecode "lossless"
	fi
}

_trainer_plan_audio_cbr() {
	local audio_scenario="${1}"
	local encoding_codec="${2}"
	local decoding_codec="${3}"
	local extension="${4}"
	local training_args=

	if [[ "${encoding_codec}" =~ ("flac"|"tta"|"wavpack") ]] ; then
		return
	fi

	local name="${encoding_codec^^}"
	name="${name//-/_}"
	local envvar="FFMPEG_PGO_${name}_ARGS"
	if [[ -n "${!envvar}" ]] ; then
		training_args="${!envvar}"
	fi

	local cbr_suffix="${encoding_codec^^}"
	cbr_suffix="${cbr_suffix//-/_}"
	local cbr_table="FFMPEG_PGO_CBR_TABLE_${cbr_suffix}_${audio_scenario^^}"
	if [[ -z "${!cbr_table}" ]] ; then
		ewarn "Missing CBR table for ${encoding_codec}"
		return
	fi

	for s in ${AUDIO_SAMPLES_SUFFIX[@]} ; do
		local t="FFMPEG_PGO_AUDIO_${s}"
		local audio_sample="${!t}"
		if [[ -z "${audio_sample}" || ! -f "${audio_sample}" ]] ; then
			ewarn "Skipping ${t}"
			continue
		fi
		if ! ffprobe "${audio_sample}" 2>/dev/null 1>/dev/null ; then
			ewarn "Skipping ${t} with path ${audio_sample}.  Decoding not possible or bad file."
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
			einfo "Encoding as CBR for 3 sec, ${bitrate} kbps for ${audio_sample}"
			cmd=( "${FFMPEG}" \
				-y \
				-i "${audio_sample}" \
				-vn \
				-c:a ${encoding_codec} \
				-b:a ${bitrate}k
				${training_args} \
				-t 3 \
				"${T}/test.${extension}" )
			einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd[@]}"
			LD_LIBRARY_PATH="${BUILD_DIR}" \
			"${cmd[@]}" || die
			_adecode "${bitrate} kbps"
		done
	done
}

_trainer_plan_audio_vbr() {
	local audio_scenario="${1}"
	local encoding_codec="${2}"
	local decoding_codec="${3}"
	local extension="${4}"
	local training_args=

	if [[ "${encoding_codec}" =~ ("flac"|"tta"|"wavpack") ]] ; then
		return
	fi

	local name="${encoding_codec^^}"
	name="${name//-/_}"
	local envvar="FFMPEG_PGO_${name}_ARGS"
	if [[ -n "${!envvar}" ]] ; then
		training_args="${!envvar}"
	fi

	local vbr_suffix="${encoding_codec^^}"
	vbr_suffix="${vbr_suffix//-/_}"

	local vbr_option="FFMPEG_PGO_VBR_OPTION_${vbr_suffix}"
	if [[ -z "${!vbr_option}" ]] ; then
		ewarn "Missing VBR option for ${encoding_codec}.  Skipping PGO training."
		return
	fi

	local vbr_table="FFMPEG_PGO_VBR_TABLE_${vbr_suffix}_${audio_scenario^^}"
	einfo "vbr_table=${vbr_table}"
	if [[ -z "${!vbr_table}" ]] ; then
		ewarn "Missing VBR table for ${encoding_codec}.  Skipping PGO training."
		return
	fi

	for s in ${AUDIO_SAMPLES_SUFFIX[@]} ; do
		local t="FFMPEG_PGO_AUDIO_${s}"
		local audio_sample="${!t}"
		if [[ -z "${audio_sample}" || ! -f "${audio_sample}" ]] ; then
			ewarn "Skipping ${t}"
			continue
		fi
		if ! ffprobe "${audio_sample}" 2>/dev/null 1>/dev/null ; then
			ewarn "Skipping ${t} with path ${audio_sample}.  Decoding not possible or bad file."
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
			einfo "Encoding as VBR for 3 sec with ${setting} setting for ${audio_sample}"
			cmd=( "${FFMPEG}" \
				-y \
				-i "${audio_sample}" \
				-vn \
				-c:a ${encoding_codec} \
				${!vbr_option} ${setting} \
				${training_args} \
				-t 3 \
				"${T}/test.${extension}" )
			einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd[@]}"
			LD_LIBRARY_PATH="${BUILD_DIR}" \
			"${cmd[@]}" || die
			_adecode "${bitrate} setting"
		done
	done
}

run_trainer_audio_codecs() {
	for codec in ${FFMPEG_PGO_AUDIO_CODECS} ; do
		local audio_scenario=$(echo "${codec}" | cut -f 1 -d ":")
		local encode_codec=$(echo "${codec}" | cut -f 2 -d ":")
		local decode_codec=$(echo "${codec}" | cut -f 3 -d ":")
		local container_extension=$(echo "${codec}" | cut -f 4 -d ":")
		local tags=$(echo "${codec}" | cut -f 5 -d ":")
		if use pgo-trainer-audio-cbr ; then
			_trainer_plan_audio_cbr \
				"${audio_scenario}" \
				"${encode_codec}" \
				"${decode_codec}" \
				"${container_extension}"
		fi
		if use pgo-trainer-audio-vbr ; then
			_trainer_plan_audio_vbr \
				"${audio_scenario}" \
				"${encode_codec}" \
				"${decode_codec}" \
				"${container_extension}"
		fi
		if use pgo-trainer-audio-lossless ; then
			_trainer_plan_audio_lossless \
				"${audio_scenario}" \
				"${encode_codec}" \
				"${decode_codec}" \
				"${container_extension}"
		fi
		if use pgo-custom-audio ; then
			_trainer_plan_audio_custom \
				"${audio_scenario}" \
				"${encode_codec}" \
				"${decode_codec}" \
				"${container_extension}" \
				"${tags}"
		fi
	done
}

run_trainer_video_codecs() {
	for codec in ${FFMPEG_PGO_VIDEO_CODECS} ; do
		local encode_codec=$(echo "${codec}" | cut -f 1 -d ":")
		local decode_codec=$(echo "${codec}" | cut -f 2 -d ":")
		local container_extension=$(echo "${codec}" | cut -f 3 -d ":")
		if use pgo-trainer-video-constrained-quality ; then
			_trainer_plan_video_constrained_quality \
				"${encode_codec}" \
				"${decode_codec}" \
				"${container_extension}"
		fi
		if use pgo-trainer-video-2-pass-constrained-quality ; then
			_trainer_plan_video_2_pass_constrained_quality \
				"${encode_codec}" \
				"${decode_codec}" \
				"${container_extension}"
		fi
		if use pgo-trainer-video-lossless ; then
			_trainer_plan_video_lossless \
				"${encode_codec}" \
				"${decode_codec}" \
				"${container_extension}"
		fi
		if use pgo-custom-video ; then
			_trainer_plan_video_custom \
				"${encode_codec}" \
				"${decode_codec}" \
				"${container_extension}"
		fi
	done
}

run_trainer() {
	# Currently only full codecs supported.
	if [[ -n "${FFMPEG_PGO_AUDIO_CODECS}" ]] ; then
		run_trainer_audio_codecs
	fi
	if [[ -n "${FFMPEG_PGO_VIDEO_CODECS}" ]] ; then
		run_trainer_video_codecs
	fi
}

compile_pgx() {
	cd "${BUILD_DIR}" || die
	emake V=1

	if multilib_is_native_abi; then
		for i in "${FFTOOLS[@]}" ; do
			if use fftools_${i} ; then
				emake V=1 tools/${i}$(get_exeext)
			fi
		done

		if use chromium; then
			if build_separate_libffmpeg; then
				einfo "Compiling for Chromium"
				pushd ../chromium >/dev/null || die
				emake V=1 libffmpeg
				popd >/dev/null || die
			else
				emake V=1 libffmpeg
			fi
		fi
	fi
}

clean_pgx() {
	einfo "Clearing old sandboxed image"
	rm -rf "${ED}" || die
}

src_compile() {
	compile_abi() {
		for build_type in $(get_build_types) ; do
			export S="${S_orig}.${ABI}_${build_type/-*}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			einfo "Build type is ${build_type}"
			if use pgo \
				&& has_pgo_requirement ; then
				export MY_ED=""
				PGO_PHASE="pgi"
				configure_pgx
				compile_pgx
				install_pgx
				local btype="${build_type/-*}"
				if multilib_is_native_abi ; then
					export FFMPEG="${ED}/usr/bin/ffmpeg-${btype}"
				else
					export FFMPEG="${ED}/usr/bin/ffmpeg-${btype}-${ABI}"
				fi
				export MY_ED="${ED}"
				run_trainer
				clean_pgx
				PGO_PHASE="pgo"
				configure_pgx
				compile_pgx
				export PGO_RAN=1
			else
				PGO_PHASE="pg0"
				configure_pgx
				compile_pgx
			fi
		done
	}
	multilib_foreach_abi compile_abi
}

src_test() {
	test_abi() {
		for build_type in $(get_build_types) ; do
			export S="${S_orig}.${ABI}_${build_type/-*}"
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

install_pgx() {
	einfo "Installing image into sandbox staging area"
	_install
}

_install() {
	emake V=1 DESTDIR="${D}" install install-doc

	# Prevent clobbering so that we can pgo optimize external codecs in different ABIs
	local btype="${build_type/-*}"
	if ! multilib_is_native_abi ; then
		mv "${ED}/usr/bin/ffmpeg"{,-${btype}-${ABI}} || die
		mv "${ED}/usr/bin/ffprobe"{,-${btype}-${ABI}} || die
		[[ -e "${ED}/usr/bin/ffplay" ]] && \
		mv "${ED}/usr/bin/ffplay"{,-${btype}-${ABI}} || die
	else
		mv "${ED}/usr/bin/ffmpeg"{,-${btype}} || die
		mv "${ED}/usr/bin/ffprobe"{,-${btype}} || die
		dosym "/usr/bin/ffmpeg-${btype}" /usr/bin/ffmpeg
		dosym "/usr/bin/ffprobe-${btype}" /usr/bin/ffprobe
		if [[ -e "${ED}/usr/bin/ffplay" ]] ; then
			mv "${ED}/usr/bin/ffplay"{,-${btype}} || die
			dosym "/usr/bin/ffplay-${btype}" /usr/bin/ffplay
		fi
	fi

	if multilib_is_native_abi; then
		exeinto /usr/bin
		for i in "${FFTOOLS[@]}" ; do
			if use fftools_${i} ; then
				einfo "Running dobin tools/${i}$(get_exeext)"
				if [[ "${PGO_PHASE}" == "pgi" ]] ; then
					# Bugged dobin
					mkdir -p "${ED}/usr/bin" || die
					cp -a "tools/${i}$(get_exeext)" \
						"${ED}/usr/bin" || die
					chmod 0755 "${ED}/usr/bin/${i}$(get_exeext)" || die
				else
					dobin tools/${i}$(get_exeext)
				fi
			fi
		done

		if use chromium; then
			if build_separate_libffmpeg; then
				einfo "Installing for Chromium"
				pushd ../chromium >/dev/null || die
				emake V=1 DESTDIR="${D}" install-libffmpeg
				popd >/dev/null || die
			else
				emake V=1 DESTDIR="${D}" install-libffmpeg

				# When not built separately, libffmpeg has no code of
				# its own so this QA check raises a false positive.
				QA_FLAGS_IGNORED+=" usr/$(get_libdir)/chromium/.*"
			fi
		fi
	fi
}

src_install() {
	install_abi() {
		for build_type in $(get_build_types) ; do
			export S="${S_orig}.${ABI}_${build_type/-*}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			_install
		done
	}
	multilib_foreach_abi install_abi

	dodoc Changelog README.md CREDITS doc/*.txt doc/APIchanges
	[ -f "RELEASE_NOTES" ] && dodoc "RELEASE_NOTES"
}

pkg_postinst() {
	if use pgo && [[ -z "${PGO_RAN}" ]] ; then
elog "No PGO optimization performed.  Please re-emerge this package."
elog "The following package must be installed before PGOing this package:"
elog "  media-video/mpv[cli]"
elog "  media-video/ffmpeg[encode]"
	fi

	if use nonfree ; then
ewarn
ewarn "You are not allowed to redistribute this binary."
ewarn
	fi

	if use cfi-cross-dso ; then
ewarn "Using cfi-cross-dso requires a rebuild of the app with only the clang"
ewarn "compiler."
	fi

	if [[ "${USE}" =~ "cfi" ]] && use static-libs ; then
ewarn "Using cfi with static-libs requires the app be built with only the clang"
ewarn "compiler."
	fi

	if use lto && use static-libs ; then
		if tc-is-clang ; then
ewarn "You are only allowed to static link this library with clang."
		elif tc-is-gcc ; then
ewarn "You are only allowed to static link this library with gcc."
		else
ewarn "You are only allowed to static link this library with CC=${CC}"
ewarn "CXX=${CXX}."
		fi
	fi
}
