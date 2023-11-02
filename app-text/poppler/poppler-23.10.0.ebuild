# Copyright 2005-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic toolchain-funcs xdg-utils

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/poppler/poppler.git"
	SLOT="0/9999"
else
	VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/aacid.asc"
	inherit verify-sig

	TEST_COMMIT="e3cdc82782941a8d7b8112f83b4a81b3d334601a"
	SRC_URI="
https://poppler.freedesktop.org/${P}.tar.xz
		test? (
https://gitlab.freedesktop.org/poppler/test/-/archive/${TEST_COMMIT}/test-${TEST_COMMIT}.tar.bz2
	->
${PN}-test-${TEST_COMMIT}.tar.bz2
		)
		verify-sig? (
https://poppler.freedesktop.org/${P}.tar.xz.sig
		)
	"
	KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390
~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos
~x64-solaris
	"
	SLOT="0/132"   # CHECK THIS WHEN BUMPING!!! SUBSLOT IS libpoppler.so SOVERSION
fi

DESCRIPTION="PDF rendering library based on the xpdf-3.0 code base"
HOMEPAGE="https://poppler.freedesktop.org/"

LICENSE="GPL-2"
IUSE="
+boost cairo cjk gtk +curl +cxx debug -doc +gpgme +introspection +jpeg +jpeg2k
+lcms +nss png +qt5 +qt6 test +tiff +utils

r2
"
REQUIRED_USE+="
	gtk? (
		cairo
	)
	introspection? (
		cairo
	)
	test? (
		|| (
			qt5
			qt6
		)
	)
"

# CI uses U 20.04
QT5_PV="5.12.8"
QT6_PV="6.2.0"
CDEPEND="
	>=media-libs/fontconfig-2.13.1[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.10.1[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.11[${MULTILIB_USEDEP}]
	cairo? (
		>=dev-libs/glib-2.64.6:2[${MULTILIB_USEDEP}]
		>=x11-libs/cairo-1.16[${MULTILIB_USEDEP}]
		gtk? (
			>=x11-libs/gtk+-3.24.20:3[${MULTILIB_USEDEP}]
		)
		introspection? (
			>=dev-libs/gobject-introspection-1.64.1:=
		)
	)
	curl? (
		>=net-misc/curl-7.68.0[${MULTILIB_USEDEP}]
	)
	cxx? (
		virtual/libc
	)
	gpgme? (
		>=app-crypt/gpgme-1.19.0:=[cxx]
	)
	jpeg? (
		>=media-libs/libjpeg-turbo-2.0.3:=[${MULTILIB_USEDEP}]
	)
	jpeg2k? (
		>=media-libs/openjpeg-2.3.1:2=[${MULTILIB_USEDEP}]
	)
	lcms? (
		>=media-libs/lcms-2.9:2[${MULTILIB_USEDEP}]
	)
	nss? (
		>=dev-libs/nss-3.68[${MULTILIB_USEDEP}]
	)
	png? (
		>=media-libs/libpng-1.6.37:0=[${MULTILIB_USEDEP}]
	)
	qt5? (
		>=dev-qt/qtcore-${QT5_PV}:5
		>=dev-qt/qtgui-${QT5_PV}:5
		>=dev-qt/qtxml-${QT5_PV}:5
		>=dev-qt/qtwidgets-${QT5_PV}:5
	)
	qt6? (
		>=dev-qt/qtbase-${QT5_PV}:6[gui,widgets]
	)
	tiff? (
		>=media-libs/tiff-4.1.0:=[${MULTILIB_USEDEP}]
	)
"
RDEPEND="
	${CDEPEND}
	cjk? (
		>=app-text/poppler-data-0.4.9
	)
"
DEPEND="
	${CDEPEND}
	boost? (
		>=dev-libs/boost-1.71.0[${MULTILIB_USEDEP}]
	)
"
BDEPEND="
	>=dev-util/glib-utils-2.64.6
	virtual/pkgconfig
	doc? (
		dev-util/gtk-doc
	)
	test? (
		qt5? (
			>=dev-qt/qttest-${QT5_PV}:5
			>=dev-qt/qtwidgets-${QT5_PV}:5
		)
	)
"

if [[ ${PV} != *9999* ]] ; then
	BDEPEND+="
		verify-sig? (
			>=sec-keys/openpgp-keys-aacid-20230907
		)
	"
fi

DOCS=( AUTHORS NEWS README.md README-XPDF )

PATCHES=(
	"${FILESDIR}/${PN}-23.10.0-qt-deps.patch"
	"${FILESDIR}/${PN}-21.09.0-respect-cflags.patch"
	"${FILESDIR}/${PN}-0.57.0-disable-internal-jpx.patch"
	"${FILESDIR}/${PN}-23.10.0-qt6.patch"
)

MULTILIB_WRAPPED_HEADERS=(
	"/usr/include/poppler/qt6/poppler-annotation.h"
	"/usr/include/poppler/qt6/poppler-export.h"
	"/usr/include/poppler/qt6/poppler-form.h"
	"/usr/include/poppler/qt6/poppler-link.h"
	"/usr/include/poppler/qt6/poppler-media.h"
	"/usr/include/poppler/qt6/poppler-optcontent.h"
	"/usr/include/poppler/qt6/poppler-page-transition.h"
	"/usr/include/poppler/qt6/poppler-qt6.h"
	"/usr/include/poppler/qt6/poppler-version.h"
)

src_unpack() {
	unpack ${A}
	if [[ -e "${WORKDIR}/test-${TEST_COMMIT}" ]] ; then
		mv \
			"${WORKDIR}/test-${TEST_COMMIT}" \
			"${WORKDIR}/test-data" \
			|| die
	fi
}

src_prepare() {
	cmake_src_prepare

	# Clang doesn't grok this flag, the configure nicely tests that, but
	# cmake just uses it, so remove it if we use clang
	if tc-is-clang ; then
		sed \
			-e 's/-fno-check-new//' \
			-i cmake/modules/PopplerMacros.cmake \
			|| die
	fi

	if ! grep -Fq 'cmake_policy(SET CMP0002 OLD)' CMakeLists.txt ; then
		sed -e '/^cmake_minimum_required/acmake_policy(SET CMP0002 OLD)' \
			-i CMakeLists.txt || die
	else
		einfo "policy(SET CMP0002 OLD) - workaround can be removed"
	fi
}

src_configure() {
	append-lfs-flags # bug #898506
	xdg_environment_reset
	local mycmakeargs=(
		$(multilib_is_native_abi || echo "
			-DBUILD_QT5_TESTS=OFF
			-DBUILD_QT6_TESTS=OFF
			-DENABLE_QT5=OFF
			-DENABLE_QT6=OFF
		")
		$(multilib_is_native_abi && echo "
			-DBUILD_QT5_TESTS=$(usex test $(usex qt5))
			-DBUILD_QT6_TESTS=$(usex test $(usex qt6))
			-DENABLE_QT5=$(usex qt5)
			-DENABLE_QT6=$(usex qt6)
		")
		$(use cairo && echo "
			-DWITH_GObjectIntrospection=$(multilib_native_usex introspection)
		")
		-DBUILD_CPP_TESTS=$(usex test)
		-DBUILD_GTK_TESTS=OFF
		-DBUILD_MANUAL_TESTS=$(usex test)
		-DENABLE_BOOST="$(usex boost)"
		-DENABLE_CPP=$(usex cxx)
		-DENABLE_DCTDECODER=$(usex jpeg libjpeg none)
		-DENABLE_GPGME=$(multilib_native_usex gpgme)
		-DENABLE_LIBCURL=$(usex curl)
		-DENABLE_LIBOPENJPEG=$(usex jpeg2k openjpeg2 none)
		-DENABLE_LIBTIFF=$(usex tiff)
		-DENABLE_LCMS=$(usex lcms)
		-DENABLE_NSS3=$(usex nss)
		-DENABLE_UNSTABLE_API_ABI_HEADERS=ON
		-DENABLE_UTILS=$(usex utils)
		-DENABLE_ZLIB_UNCOMPRESS=OFF
		-DRUN_GPERF_IF_PRESENT=OFF
		-DTESTDATADIR="${WORKDIR}/test-data"
		-DUSE_FLOAT=OFF
		-DWITH_Cairo=$(usex cairo)
		-DWITH_JPEG=$(usex jpeg)
		-DWITH_PNG=$(usex png)
	)

	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install
	# The live version doesn't provide html documentation.
	if use cairo && use doc && [[ ${PV} != *9999* ]]; then
		# For now install gtk-doc there
		insinto /usr/share/gtk-doc/html/poppler
		doins -r "${S}/glib/reference/html/"*
	fi
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED 23.06.0 (20230626)
# USE="cairo cxx lcms qt6* test utils -boost -cjk -curl (-debug) -doc -gpgme
# -gtk -introspection -jpeg -jpeg2k -nss -png (-qt5) -tiff -verify-sig"
#
# 100% tests passed, 0 tests failed out of 26
#
# Total Test time (real) =   1.20 sec
#
