# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO"
PATENT_STATUS_USE=(
	"patent_status_nonfree"
)

inherit cflags-hardened cmake xdg multilib-minimal

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/strukturag/libheif.git"
	inherit git-r3
else
	SRC_URI="https://github.com/strukturag/libheif/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="A HEIF and AVIF file format decoder and encoder"
HOMEPAGE="https://github.com/strukturag/libheif"
LICENSE="GPL-3"
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
-avc avif +aom -dav1d -ffmpeg +gdk-pixbuf go jpeg -jpeg2k -kvazaar -heic -htj2k
-libde265 -rav1e +libsharpyuv -svt-av1 test +threads -uvg266 -vvc -vvenc -x265
ebuild_revision_13
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
	test? (
		go
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
	go? (
		dev-lang/go:=
	)
	htj2k? (
		media-libs/openjpeg:=[${MULTILIB_USEDEP}]
		media-libs/openjph:=[${MULTILIB_USEDEP}]
	)
	jpeg? (
		media-libs/libjpeg-turbo:0[${MULTILIB_USEDEP}]
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
	test? (
		<dev-cpp/catch-3
		dev-lang/go
	)
"

MULTILIB_WRAPPED_HEADERS=(
	"/usr/include/libheif/heif_version.h"
)

src_prepare() {
	if use test ; then
		# bug 865351
		rm "tests/catch.hpp" || die
		ln -s \
			"${ESYSROOT}/usr/include/catch2/catch.hpp" \
			"tests/catch.hpp" \
			|| die
	fi

	sed \
		-i \
		-e '/Werror/d' \
		"CMakeLists.txt" \
		|| die # bug 936466

	cmake_src_prepare

	multilib_copy_sources
}

multilib_src_configure() {
	cflags-hardened_append
	export GO111MODULE=auto
	local mycmakeargs=(
		-DENABLE_PLUGIN_LOADING="true"
		-DWITH_AOM_DECODER=$(usex aom)
		-DWITH_AOM_ENCODER=$(usex aom)
		-DWITH_FFMPEG_DECODER=$(usex ffmpeg)
		-DWITH_GDK_PIXBUF=$(usex gdk-pixbuf)
		-DWITH_JPEG_DECODER=$(usex jpeg)
		-DWITH_JPEG_ENCODER=$(usex jpeg)
		-DWITH_LIBDE265=$(usex libde265)
		-DWITH_LIBSHARPYUV=$(usex libsharpyuv)
		-DWITH_KVAZAAR=$(usex kvazaar)
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

multilib_src_compile() {
	default
	cmake_src_compile
}

multilib_src_test() {
	default
}

multilib_src_install() {
	cmake_src_install
}

multilib_src_install_all() {
	einstalldocs
}
