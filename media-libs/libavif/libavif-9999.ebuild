# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"

CHKL_TIMESTAMPS=(
	"dev-libs/glib-2.89.9999"
	"media-libs/dav1d-9999"
	"media-libs/libaom-9999"
	"media-libs/libjpeg-turbo-9999"
	"media-libs/libpng-9999"
	"media-libs/libyuv-9999"
	"media-libs/svt-av1-9999"
	"media-gfx/imagemagick-9999"
	"media-video/rav1e-9999"
	"x11-libs/gdk-pixbuf-9999"
)

inherit cflags-hardened chkl cmake-multilib gnome2-utils secure-version

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="ea160ac56df44c571cd5781cbc24b2aeb1419b46"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/AOMediaCodec/libavif.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	SLOT="0/${PV}"
	inherit git-r3
else
	# See bug #822336 re subslot
	# See LIBRARY_VERSION_MAJOR, LIBRARY_VERSION_MINOR in CMakeLists.txt
	SLOT="0/16.4"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
	SRC_URI="
https://github.com/AOMediaCodec/libavif/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Library for encoding and decoding .avif files"
HOMEPAGE="https://github.com/AOMediaCodec/libavif"
LICENSE="
	BSD-2
"

IUSE+=" +aom dav1d examples extras gdk-pixbuf rav1e svt-av1 libyuv test"
RESTRICT="!test? ( test )"
REQUIRED_USE="|| ( aom dav1d )"

DEPEND="
	>=media-libs/libjpeg-turbo-${LIBJPEG_TURBO_PV}:=[${MULTILIB_USEDEP}]
	>=media-libs/libpng-${LIBPNG_PV}:=[${MULTILIB_USEDEP}]
	aom? ( >=media-libs/libaom-${LIBAOM_PV}:=[${MULTILIB_USEDEP}] )
	dav1d? ( >=media-libs/dav1d-${DAV1D_PV}:=[${MULTILIB_USEDEP}] )
	gdk-pixbuf? (
		>=dev-libs/glib-${GLIB_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/gdk-pixbuf-${GDK_PIXBUF_PV}:=[${MULTILIB_USEDEP}]
	)
	rav1e? ( >=media-video/rav1e-${RAV1E_PV}:=[capi] )
	svt-av1? ( >=media-libs/svt-av1-${SVT_AV1_PV}:= )
	libyuv? ( >=media-libs/libyuv-${LIBYUV_PV}:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
	extras? (
		test? (
			dev-cpp/gtest
			>=media-gfx/imagemagick-${IMAGEMAGICK_PV}[lcms]
		)
	)
"

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	cmake_src_prepare
}

multilib_src_configure() {
	cflags-hardened_append
	chkl_check_many_timestamps
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DAVIF_CODEC_LIBGAV1=OFF

		# Use system libraries.
		-DAVIF_CODEC_AOM=$(usex aom SYSTEM OFF)
		-DAVIF_CODEC_DAV1D=$(usex dav1d SYSTEM OFF)
		-DAVIF_ZLIBPNG=SYSTEM
		-DAVIF_JPEG=SYSTEM
		-DAVIF_LIBYUV=$(usex libyuv SYSTEM OFF)

		-DAVIF_BUILD_GDK_PIXBUF=$(usex gdk-pixbuf ON OFF)

		-DAVIF_ENABLE_WERROR=OFF
	)

	if multilib_is_native_abi; then
		mycmakeargs+=(
			-DAVIF_CODEC_RAV1E=$(usex rav1e SYSTEM OFF)
			-DAVIF_CODEC_SVT=$(usex svt-av1 SYSTEM OFF)

			-DAVIF_BUILD_EXAMPLES=$(usex examples ON OFF)
			-DAVIF_BUILD_APPS=$(usex extras ON OFF)
			-DAVIF_BUILD_TESTS=$(usex test ON OFF)
			-DAVIF_ENABLE_GTEST=$(usex extras $(usex test ON OFF) OFF)
			-DAVIF_GTEST=$(usex extras $(usex test SYSTEM OFF) OFF)
		)
	else
		mycmakeargs+=(
			-DAVIF_CODEC_RAV1E=OFF
			-DAVIF_CODEC_SVT=OFF

			-DAVIF_BUILD_EXAMPLES=OFF
			-DAVIF_BUILD_APPS=OFF
			-DAVIF_BUILD_TESTS=OFF
			-DAVIF_GTEST=OFF
		)

		if ! use aom ; then
			if use rav1e || use svt-av1 ; then
				ewarn "libavif on ${MULTILIB_ABI_FLAG} will work in read-only mode."
				ewarn "Support for rav1e and/or svt-av1 is is not available on ${MULTILIB_ABI_FLAG}"
				ewarn "Enable aom flag for full support on ${MULTILIB_ABI_FLAG}"
			fi
		fi
	fi

	cmake_src_configure
}

pkg_postinst() {
	if ! use aom && ! use rav1e && ! use svt-av1 ; then
		ewarn "No AV1 encoder is set,"
		ewarn "libavif will work in read-only mode."
		ewarn "Enable aom, rav1e or svt-av1 flag if you want to save .AVIF files."
	fi

	use gdk-pixbuf && multilib_foreach_abi gnome2_gdk_pixbuf_update
}

pkg_postrm() {
	use gdk-pixbuf && multilib_foreach_abi gnome2_gdk_pixbuf_update
}
