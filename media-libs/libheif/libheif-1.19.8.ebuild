# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO"
PATENT_STATUS_USE=(
	"patent_status_nonfree"
)

inherit cflags-hardened cmake-multilib gnome2-utils multilib-minimal xdg

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/strukturag/libheif.git"
	inherit git-r3
else
	SRC_URI="https://github.com/strukturag/libheif/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="A HEIF and AVIF file format decoder and encoder"
HOMEPAGE="https://github.com/strukturag/libheif"
LICENSE="
	GPL-3
	MIT
"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0/$(ver_cut 1-2)"
# non-free off in this ebuild fork
# avc is enabled by default upstream, but disabled by default in ebuild because non-free
# heic is enabled by default upstream, but disabled by default in ebuild because non-free
FFMPEG_HW_ACCEL_DECODE_H265_USE=(
	"amf"
	"cuda"
	"mmal"
	"nvdec"
	"qsv"
	"vaapi"
	"vdpau"
	"vulkan"
)
IUSE="
${FFMPEG_HW_ACCEL_DECODE_H265_USE[@]}
${PATENT_STATUS_USE[@]}
-avc avif +aom -dav1d doc +examples -ffmpeg +gdk-pixbuf jpeg -jpeg2k -kvazaar -heic -htj2k
-libde265 -openh264 -rav1e +libsharpyuv -svt-av1 test +threads -uvg266 -vvc -vvenc -x265
ebuild_revision_16
"
PATENT_STATUS_REQUIRED_USE="
	!patent_status_nonfree? (
		!amf
		!avc
		!cuda
		!ffmpeg
		!heic
		!kvazaar
		!libde265
		!mmal
		!nvdec
		!qsv
		!uvg266
		!vaapi
		!vdpau
		!vulkan
		!vvc
		!x265
	)
"
REQUIRED_USE="
	${PATENT_STATUS_REQUIRED_USE}
	avif? (
		|| (
			aom
			dav1d
		)
		|| (
			aom
			rav1e
			svt-av1
		)
	)
	ffmpeg? (
		|| (
			${FFMPEG_HW_ACCEL_DECODE_H265_USE[@]}
		)
	)
	heic? (
		|| (
			ffmpeg
			libde265
		)
		|| (
			kvazaar
			x265
		)
	)
	vvc? (
		|| (
			uvg266
			vvenc
		)
	)
"
RDEPEND="
	media-libs/libpng:0[${MULTILIB_USEDEP}]
	media-libs/libpng:=[${MULTILIB_USEDEP}]
	media-libs/tiff:=[${MULTILIB_USEDEP}]
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
	virtual/patent-status[patent_status_nonfree?]
	aom? (
		>=media-libs/libaom-2.0.0:=[${MULTILIB_USEDEP}]
	)
	dav1d? (
		media-libs/dav1d:=[${MULTILIB_USEDEP}]
	)
	ffmpeg? (
		media-libs/ffmpeg:=[amf?,cuda?,nvdec?,vaapi?,vdpau?,vulkan?]
	)
	gdk-pixbuf? (
		x11-libs/gdk-pixbuf[${MULTILIB_USEDEP}]
	)
	openh264? (
		media-libs/openh264:=[${MULTILIB_USEDEP}]
	)
	htj2k? (
		media-libs/openjpeg:=[${MULTILIB_USEDEP}]
		media-libs/openjph:=[${MULTILIB_USEDEP}]
	)
	jpeg? (
		media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}]
	)
	jpeg2k? (
		media-libs/openjpeg:=[${MULTILIB_USEDEP}]
	)
	kvazaar? (
		media-libs/kvazaar:=[${MULTILIB_USEDEP}]
	)
	libde265? (
		media-libs/libde265[${MULTILIB_USEDEP}]
	)
	libsharpyuv? (
		media-libs/libwebp:=[${MULTILIB_USEDEP}]
	)
	rav1e? (
		media-video/rav1e:=
	)
	svt-av1? (
		media-libs/svt-av1:=[${MULTILIB_USEDEP}]
	)
	vvc? (
		media-libs/vvdec:=[${MULTILIB_USEDEP}]
	)
	vvenc? (
		media-libs/vvenc:=[${MULTILIB_USEDEP}]
	)
	uvg266? (
		media-libs/uvg266:=[${MULTILIB_USEDEP}]
	)
	x265? (
		media-libs/x265:=[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	doc? (
		app-text/doxygen
	)
"

MULTILIB_WRAPPED_HEADERS=(
	"/usr/include/libheif/heif_version.h"
)

multilib_src_configure() {
	cflags-hardened_append
	local mycmakeargs=(
		$(cmake_use_find_package doc Doxygen)
		-DBUILD_TESTING=$(usex test)
		-DENABLE_PLUGIN_LOADING="true"
		-DWITH_AOM_DECODER=$(usex aom)
		-DWITH_AOM_ENCODER=$(usex aom)
		-DWITH_EXAMPLES=$(usex examples)
		-DWITH_FFMPEG_DECODER=$(usex ffmpeg)
		-DWITH_GDK_PIXBUF=$(usex gdk-pixbuf)
		-DWITH_JPEG_DECODER=$(usex jpeg)
		-DWITH_JPEG_ENCODER=$(usex jpeg)
		-DWITH_LIBDE265=$(usex libde265)
		-DWITH_LIBSHARPYUV=$(usex libsharpyuv)
		-DWITH_KVAZAAR=$(usex kvazaar)
		-DWITH_OpenH264_DECODER=$(usex openh264)
		-DWITH_OpenH264_ENCODER=$(usex openh264)
		-DWITH_RAV1E=$(multilib_native_usex rav1e)
		-DWITH_SvtEnc=$(usex svt-av1)
		-DWITH_UVG266_ENCODER=$(usex uvg266)
		-DWITH_VVENC=$(usex vvenc)
		-DWITH_VVDEC=$(usex vvc)
		-DWITH_X265=$(usex x265)
	)

	if use htj2k ; then
		mycmakeargs+=(
			-DWITH_OpenJPEG_DECODER="true"
			-DWITH_OPENJPH_ENCODER="true"
		)
	fi
	if use jpeg2k ; then
		mycmakeargs+=(
			-DWITH_OpenJPEG_DECODER="true"
			-DWITH_OpenJPEG_ENCODER="true"
		)
	fi

	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	use gdk-pixbuf && multilib_foreach_abi gnome2_gdk_pixbuf_update
}

pkg_postrm() {
	xdg_pkg_postrm
	use gdk-pixbuf && multilib_foreach_abi gnome2_gdk_pixbuf_update
}
