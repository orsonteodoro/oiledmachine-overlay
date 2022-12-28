# Copyright 2005-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib toolchain-funcs xdg-utils

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/poppler/poppler.git"
	SLOT="0/9999"
else
	VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/aacid.asc
	inherit verify-sig

	SRC_URI="https://poppler.freedesktop.org/${P}.tar.xz"
	SRC_URI+=" verify-sig? ( https://poppler.freedesktop.org/${P}.tar.xz.sig )"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
	SLOT="0/125"   # CHECK THIS WHEN BUMPING!!! SUBSLOT IS libpoppler.so SOVERSION
fi

DESCRIPTION="PDF rendering library based on the xpdf-3.0 code base"
HOMEPAGE="https://poppler.freedesktop.org/"

LICENSE="GPL-2"
IUSE="boost cairo cjk curl +cxx debug doc +introspection +jpeg +jpeg2k +lcms nss png qt5 tiff +utils"

# No test data provided
RESTRICT="test"

COMMON_DEPEND="
	media-libs/fontconfig[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.8[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	cairo? (
		dev-libs/glib:2[${MULTILIB_USEDEP}]
		x11-libs/cairo[${MULTILIB_USEDEP}]
		introspection? ( dev-libs/gobject-introspection:= )
	)
	curl? ( net-misc/curl[${MULTILIB_USEDEP}] )
	jpeg? ( media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}] )
	jpeg2k? ( >=media-libs/openjpeg-2.3.0-r1:2=[${MULTILIB_USEDEP}] )
	lcms? ( media-libs/lcms:2[${MULTILIB_USEDEP}] )
	nss? ( >=dev-libs/nss-3.19:0[${MULTILIB_USEDEP}] )
	png? ( media-libs/libpng:0=[${MULTILIB_USEDEP}] )
	qt5? (
		dev-qt/qtcore:5[${MULTILIB_USEDEP}]
		dev-qt/qtgui:5[${MULTILIB_USEDEP}]
		dev-qt/qtxml:5[${MULTILIB_USEDEP}]
	)
	tiff? ( media-libs/tiff:=[${MULTILIB_USEDEP}] )
"
RDEPEND="${COMMON_DEPEND}
	cjk? ( app-text/poppler-data )
"
DEPEND="${COMMON_DEPEND}
	boost? ( dev-libs/boost[${MULTILIB_USEDEP}] )
"
BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
"

if [[ ${PV} != *9999* ]] ; then
	BDEPEND+=" verify-sig? ( sec-keys/openpgp-keys-aacid )"
fi

DOCS=( AUTHORS NEWS README.md README-XPDF )

PATCHES=(
	"${FILESDIR}/${PN}-20.12.1-qt5-deps.patch"
	"${FILESDIR}/${PN}-21.09.0-respect-cflags.patch"
	"${FILESDIR}/${PN}-0.57.0-disable-internal-jpx.patch"
)

src_prepare() {
	cmake_src_prepare

	# Clang doesn't grok this flag, the configure nicely tests that, but
	# cmake just uses it, so remove it if we use clang
	if tc-is-clang ; then
		sed -e 's/-fno-check-new//' -i cmake/modules/PopplerMacros.cmake || die
	fi

	if ! grep -Fq 'cmake_policy(SET CMP0002 OLD)' CMakeLists.txt ; then
		sed -e '/^cmake_minimum_required/acmake_policy(SET CMP0002 OLD)' \
			-i CMakeLists.txt || die
	else
		einfo "policy(SET CMP0002 OLD) - workaround can be removed"
	fi
}

src_configure() {
	xdg_environment_reset
	local mycmakeargs=(
		-DBUILD_GTK_TESTS=OFF
		-DBUILD_QT5_TESTS=OFF
		-DBUILD_CPP_TESTS=OFF
		-DBUILD_MANUAL_TESTS=OFF
		-DRUN_GPERF_IF_PRESENT=OFF
		-DENABLE_BOOST="$(usex boost)"
		-DENABLE_ZLIB=ON
		-DENABLE_ZLIB_UNCOMPRESS=OFF
		-DENABLE_UNSTABLE_API_ABI_HEADERS=ON
		-DUSE_FLOAT=OFF
		-DWITH_Cairo=$(usex cairo)
		-DENABLE_LIBCURL=$(usex curl)
		-DENABLE_CPP=$(usex cxx)
		-DWITH_JPEG=$(usex jpeg)
		-DENABLE_DCTDECODER=$(usex jpeg libjpeg none)
		-DENABLE_LIBOPENJPEG=$(usex jpeg2k openjpeg2 none)
		-DENABLE_CMS=$(usex lcms lcms2 none)
		-DWITH_NSS3=$(usex nss)
		-DWITH_PNG=$(usex png)
		$(cmake_use_find_package qt5 Qt5Core)
		-DWITH_TIFF=$(usex tiff)
		-DENABLE_UTILS=$(usex utils)
		-DENABLE_QT6=OFF
	)
	use cairo && mycmakeargs+=( -DWITH_GObjectIntrospection=$(usex introspection) )

	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install

	# live version doesn't provide html documentation
	if use cairo && use doc && [[ ${PV} != *9999* ]]; then
		# For now install gtk-doc there
		insinto /usr/share/gtk-doc/html/poppler
		doins -r "${S}"/glib/reference/html/*
	fi
}
