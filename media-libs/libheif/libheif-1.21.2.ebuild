# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO"
CXX_STANDARD=20

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX20[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX20[@]/llvm_slot_}"
)

PATENT_STATUS_USE=(
	"patent_status_nonfree"
)

inherit cflags-hardened cmake-multilib gnome2-utils libcxx-slot libstdcxx-slot
inherit multilib-minimal xdg

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
avif +aom -brotli -dav1d doc -doxygen +examples -ffmpeg +gdk-pixbuf -header-compression
jpeg -jpeg2k -kvazaar -heic -htj2k -libde265 -openh264 -rav1e +libsharpyuv
-system-libsharpyuv -svt-av1 test +threads -uncompressed -uvg266 -vvc
-vvenc -webcodecs -x264 -x265
ebuild_revision_27
"
PATENT_STATUS_REQUIRED_USE="
	!patent_status_nonfree? (
		!amf
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
		!x264
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
	brotli? (
		uncompressed
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
	virtual/patent-status[patent_status_nonfree?]
	aom? (
		>=media-libs/libaom-2.0.0:=[${MULTILIB_USEDEP}]
	)
	brotli? (
		app-arch/brotli:=[${MULTILIB_USEDEP}]
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
	header-compression? (
		sys-libs/zlib:=[${MULTILIB_USEDEP}]
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
	openh264? (
		media-libs/openh264:=[${MULTILIB_USEDEP}]
	)
	rav1e? (
		media-video/rav1e:=
	)
	svt-av1? (
		media-libs/svt-av1:=[${MULTILIB_USEDEP}]
	)
	uncompressed? (
		sys-libs/zlib:=[${MULTILIB_USEDEP}]
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
	x264? (
		media-libs/x264:=[${MULTILIB_USEDEP}]
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

warn_use_flag_non_default() {
	# Some codecs are enabled by default upstream, but all non-free are
	# disabled by default in ebuild because the codec has a non-free
	# patent-status.

	local L=(
	# Keep in original order
		"libde265:ON"
		"x265:ON"
		"kvazaar:OFF"
		"uvg266:OFF"
		"vvc:OFF"
		"vvenc:OFF"
		"x264:ON"
		"openh264:ON"
		"dav1d:OFF"
		"aom:ON"
		"svt-av1:OFF"
		"rav1e:OFF"
		"jpeg:OFF"
		"jpeg2k:OFF"
		"ffmpeg:OFF"
		"htj2k:OFF"
	)

# The patent status or recognition of software patents varies per country.
	local x
	for x in "${L[@]}" ; do
		local u="${u%:*}"
		local dv="${u#*:}"
		if ! use "${u}" && [[ "${dv}" == "ON" ]] ; then
ewarn "${u} is default ON upstream but set OFF by default in the ebuild."
		fi
	done
}

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
	warn_use_flag_non_default
}

multilib_src_configure() {
	cflags-hardened_append
	local mycmakeargs=(
		$(cmake_use_find_package doxygen Doxygen)
		-DBUILD_DOCUMENTATION=$(usex doxygen)
		-DBUILD_TESTING=$(usex test)
		-DENABLE_PLUGIN_LOADING="true"
		-DWITH_AOM_DECODER=$(usex aom)
		-DWITH_AOM_ENCODER=$(usex aom)
		-DWITH_EXAMPLES=$(usex examples)
		-DWITH_FFMPEG_DECODER=$(usex ffmpeg)
		-DWITH_GDK_PIXBUF=$(usex gdk-pixbuf)
		-DWITH_HEADER_COMPRESSION=$(usex header-compression)
		-DWITH_JPEG_DECODER=$(usex jpeg)
		-DWITH_JPEG_ENCODER=$(usex jpeg)
		-DWITH_LIBDE265=$(usex libde265)
		-DWITH_LIBSHARPYUV=$(usex libsharpyuv)
		-DWITH_LIBSHARPYUV_INTERNAL=$(usex !system-libsharpyuv)
		-DWITH_KVAZAAR=$(usex kvazaar)
		-DWITH_OpenH264_DECODER=$(usex openh264)
		-DWITH_OpenH264_ENCODER=$(usex openh264)
		-DWITH_RAV1E=$(multilib_native_usex rav1e)
		-DWITH_SvtEnc=$(usex svt-av1)
		-DWITH_UNCOMPRESSED_CODEC=$(usex uncompressed)
		-DWITH_UVG266_ENCODER=$(usex uvg266)
		-DWITH_VVENC=$(usex vvenc)
		-DWITH_VVDEC=$(usex vvc)
		-DWITH_WEBCODECS=$(usex webcodecs)
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
