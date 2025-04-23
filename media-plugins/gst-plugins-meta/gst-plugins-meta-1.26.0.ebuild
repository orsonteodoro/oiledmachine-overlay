# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#
# Usage note:
#
# The idea is that apps depend on this for optional gstreamer plugins.  Then,
# when USE flags change, no app gets rebuilt, and all apps that can make use of
# the new plugin automatically do.
#

# When adding deps here, make sure the keywords on the gst-plugin are valid.

# There is no current way to disable individual codecs like mesa for va,
# vaapi, vulkan.  This is why they are restricted.

# gst-plugins-good/sys/v4l2/meson.build also does not restrict codecs and could
# be restricted like mesa's config flag but there are some webcams that do not
# have H.264, H.265.

PATENT_STATUS=(
	patent_status_nonfree
)
VIDEO_CARDS=(
	video_cards_amdgpu
	video_cards_r600
	video_cards_radeonsi
	video_cards_intel
	video_cards_nouveau
	video_cards_nvidia
)

inherit multilib-build

KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86
~amd64-linux ~arm64-macos ~x86-linux
"

DESCRIPTION="A metapackage to pull in gst plugins for apps"
HOMEPAGE="https://gstreamer.freedesktop.org/"
LICENSE="metapackage"
SLOT="1.0"
IUSE="
${PATENT_STATUS[@]}
${VIDEO_CARDS[@]}
a52 aac aalib alsa aom av1 cdda dash dav1d dts dv dvb dvd fdk ffmpeg flac
fluidsynth gme gsm hls http jack jpeg jpeg2k lame libass libcaca libvisual midi
mp3 modplug mpeg nvcodec ogg openal openh264 opus oss speex png pulseaudio qsv
rav1e rtmp sndio sndfile svg taglib theora v4l va vaapi vcd vorbis vpx vulkan
vvc wavpack wildmidi webp X x264 x265
"
PATENT_REQUIRED_USE="
	!patent_status_nonfree? (
		!aac
		!dash
		!fdk
		!hls
		!nvcodec
		!qsv
		!va
		!vaapi
		!vulkan
		!vvc
		!x264
		!x265
	)
	aac? (
		patent_status_nonfree
	)
	dash? (
		patent_status_nonfree
	)
	fdk? (
		patent_status_nonfree
	)
	hls? (
		patent_status_nonfree
	)
	nvcodec? (
		patent_status_nonfree
	)
	openh264? (
		patent_status_nonfree
	)
	qsv? (
		patent_status_nonfree
	)
	va? (
		patent_status_nonfree
	)
	vaapi? (
		patent_status_nonfree
	)
	vulkan? (
		patent_status_nonfree
	)
	vvc? (
		patent_status_nonfree
	)
	x264? (
		patent_status_nonfree
	)
	x265? (
		patent_status_nonfree
	)
"
REQUIRED_USE="
	${PATENT_REQUIRED_USE}
	av1? (
		|| (
			aom
			rav1e
		)
		|| (
			aom
			dav1d
		)
	)
	midi? (
		|| (
			fluidsynth
			wildmidi
		)
	)
	opus? (
		ogg
	)
	theora? (
		ogg
	)
	vorbis? (
		ogg
	)
"

PATENT_RDEPEND="
	!patent_status_nonfree? (
		media-libs/gst-plugins-bad[-nvcodec,-qsv,-vaapi,-vulkan-video]
	)
	virtual/patent-status[patent_status_nonfree=]
"

RDEPEND="
	${PATENT_RDEPEND}
	~media-libs/gstreamer-${PV}:1.0[${MULTILIB_USEDEP}]
	~media-libs/gst-plugins-base-${PV}:1.0[${MULTILIB_USEDEP},alsa?,ogg?,theora?,vorbis?,X?]
	~media-libs/gst-plugins-good-${PV}:1.0[${MULTILIB_USEDEP}]
	a52? (
		~media-plugins/gst-plugins-a52dec-${PV}:1.0[${MULTILIB_USEDEP}]
        )
	aalib? (
		~media-plugins/gst-plugins-aalib-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	aac? (
		~media-plugins/gst-plugins-faac-${PV}:1.0[${MULTILIB_USEDEP}]
		~media-plugins/gst-plugins-faad-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	aom? (
		~media-plugins/gst-plugins-aom-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	cdda? (
		|| (
			~media-plugins/gst-plugins-cdparanoia-${PV}:1.0[${MULTILIB_USEDEP}]
			~media-plugins/gst-plugins-cdio-${PV}:1.0[${MULTILIB_USEDEP}]
		)
	)
	dav1d? (
		~media-plugins/gst-plugins-rs-${PV}:1.0[${MULTILIB_USEDEP},dav1d]
	)
	dash? (
		~media-plugins/gst-plugins-dash-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	dts? (
		~media-plugins/gst-plugins-dts-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	dv? (
		~media-plugins/gst-plugins-dv-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	dvb? (
		~media-plugins/gst-plugins-dvb-${PV}:1.0[${MULTILIB_USEDEP}]
		~media-libs/gst-plugins-bad-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	dvd? (
		~media-libs/gst-plugins-ugly-${PV}:1.0[${MULTILIB_USEDEP}]
		~media-plugins/gst-plugins-a52dec-${PV}:1.0[${MULTILIB_USEDEP}]
		~media-plugins/gst-plugins-dvdread-${PV}:1.0[${MULTILIB_USEDEP}]
		~media-plugins/gst-plugins-mpeg2dec-${PV}:1.0[${MULTILIB_USEDEP}]
		~media-plugins/gst-plugins-resindvd-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	fdk? (
		~media-plugins/gst-plugins-fdkaac-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	ffmpeg? (
		~media-plugins/gst-plugins-libav-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	flac? (
		~media-plugins/gst-plugins-flac-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	gme? (
		~media-plugins/gst-plugins-gme-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	hls? (
		~media-plugins/gst-plugins-hls-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	http? (
		~media-plugins/gst-plugins-soup-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	jack? (
		~media-plugins/gst-plugins-jack-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	jpeg? (
		~media-plugins/gst-plugins-jpeg-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	jpeg2k? (
		~media-plugins/gst-plugins-openjpeg-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	lame? (
		~media-plugins/gst-plugins-lame-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	libass? (
		~media-plugins/gst-plugins-assrender-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	libcaca? (
		~media-plugins/gst-plugins-libcaca-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	libvisual? (
		~media-plugins/gst-plugins-libvisual-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	midi? (
		fluidsynth? (
			~media-plugins/gst-plugins-fluidsynth-${PV}:1.0[${MULTILIB_USEDEP}]
		)
		wildmidi? (
			~media-plugins/gst-plugins-wildmidi-${PV}:1.0
		)
	)
	modplug? (
		~media-plugins/gst-plugins-modplug-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	mp3? (
		~media-libs/gst-plugins-ugly-${PV}:1.0[${MULTILIB_USEDEP}]
		~media-plugins/gst-plugins-mpg123-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	mpeg? (
		~media-plugins/gst-plugins-mpeg2dec-${PV}:1.0[${MULTILIB_USEDEP}]
		~media-plugins/gst-plugins-mpeg2enc-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	nvcodec? (
		~media-plugins/gst-plugins-bad-${PV}:1.0[${MULTILIB_USEDEP},nvcodec]
	)
	openal? (
		~media-plugins/gst-plugins-openal-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	openh264? (
		~media-plugins/gst-plugins-openh264-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	opus? (
		~media-plugins/gst-plugins-opus-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	oss? (
		~media-plugins/gst-plugins-oss-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	png? (
		~media-plugins/gst-plugins-libpng-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	pulseaudio? (
		~media-plugins/gst-plugins-pulse-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	qsv? (
		~media-plugins/gst-plugins-bad-${PV}:1.0[${MULTILIB_USEDEP},qsv,video_cards_intel?]
	)
	rav1e? (
		~media-plugins/gst-plugins-rs-${PV}:1.0[${MULTILIB_USEDEP},rav1e]
	)
	rtmp? (
		~media-plugins/gst-plugins-rtmp-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	sndfile? (
		~media-plugins/gst-plugins-sndfile-${PV}:0[${MULTILIB_USEDEP}]
	)
	sndio? (
		~media-plugins/gst-plugins-sndio-1.24.0:0[${MULTILIB_USEDEP}]
	)
	speex? (
		~media-plugins/gst-plugins-speex-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	svg? (
		~media-plugins/gst-plugins-rsvg-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	taglib? (
		~media-plugins/gst-plugins-taglib-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	v4l? (
		~media-plugins/gst-plugins-v4l2-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	va? (
		~media-plugins/gst-plugins-bad-${PV}:1.0[${MULTILIB_USEDEP},vaapi,video_cards_amdgpu?,video_cards_r600?,video_cards_radeonsi?,video_cards_intel?,video_cards_nouveau?,video_cards_nvidia?]
	)
	vaapi? (
		~media-plugins/gst-plugins-vaapi-${PV}:1.0[${MULTILIB_USEDEP},video_cards_amdgpu?,video_cards_r600?,video_cards_radeonsi?,video_cards_intel?,video_cards_nouveau?,video_cards_nvidia?]
	)
	vcd? (
		~media-plugins/gst-plugins-mpeg2dec-${PV}:1.0[${MULTILIB_USEDEP}]
		~media-plugins/gst-plugins-mplex-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	vpx? (
		~media-plugins/gst-plugins-vpx-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	vulkan? (
		~media-libs/gst-plugins-bad-${PV}:1.0[vulkan,vulkan-video]
	)
	vvc? (
		~media-plugins/gst-plugins-vvdec-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	wavpack? (
		~media-plugins/gst-plugins-wavpack-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	webp? (
		~media-plugins/gst-plugins-webp-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	x264? (
		~media-plugins/gst-plugins-x264-${PV}:1.0[${MULTILIB_USEDEP}]
	)
	x265? (
		~media-plugins/gst-plugins-x265-${PV}:1.0[${MULTILIB_USEDEP}]
	)
"

