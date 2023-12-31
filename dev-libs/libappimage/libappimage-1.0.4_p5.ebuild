# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake" # required for downloading in compile phase
inherit cmake linux-info

DESCRIPTION="Implements functionality for dealing with AppImage files"
LICENSE="MIT" # project default license
LICENSE+=" all-rights-reserved" # src/libappimage/libappimage.c ; The vanilla MIT license doesn't have all-rights-reserved
# The below licenses apply to static linking and third-party packages.
LICENSE+=" BSD-2" # for internal squashfuse
LICENSE+=" !system-boost? ( Boost-1.0 )" # copied from the boost ebuild
LICENSE+=" !system-libarchive? ( BSD BSD-2 BSD-4 public-domain )" # copied from the libarchive ebuild
LICENSE+=" !system-xdgutils? ( MIT BSD )" # copied from the dev-libs/xdg-utils-cxx ebuild
LICENSE+=" !system-xz? ( public-domain LGPL-2.1+ GPL-2+ )" # copied from the app-arch/xz-utils ebuild
HOMEPAGE="https://github.com/AppImage/libappimage"
KEYWORDS="~amd64 ~x86"
IUSE="
static-libs system-boost system-libarchive system-squashfuse system-xdgutils
system-xz

r2
"
SLOT="0/$(ver_cut 1-2 ${PV})"
RDEPEND="
	>=dev-libs/glib-2.40:2
	>=gnome-base/librsvg-2
	sys-libs/zlib
	x11-libs/cairo
	system-boost? (
		>=dev-libs/boost-1.69:=[static-libs(+)]
	)
	system-libarchive? (
		app-arch/libarchive:=[static-libs]
	)
	system-squashfuse? (
		sys-fs/squashfuse:=[appimage,static-libs]
	)
	system-xdgutils? (
		dev-libs/xdg-utils-cxx:=[static-libs]
	)
	system-xz? (
		app-arch/xz-utils:=[static-libs]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/cmake-3.4
	dev-util/desktop-file-utils
	dev-util/xxd
	dev-vcs/git
"
EGIT_COMMIT="7acfb43e150e9a55e2602631596258925da167eb" # keep in sync with PV
GOOGLETEST_COMMIT="ec44c6c1675c25b9827aacd08c02433cccde7780"
SRC_URI="
https://github.com/AppImage/libappimage/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT}.tar.gz
	-> ${P}-googletest-${GOOGLETEST_COMMIT:0:7}.tar.gz
"
S="${WORKDIR}/${PN}-${PV/_p/-}"
S_BAK="${WORKDIR}/${PN}-${PV/_p/-}"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/${PN}-1.0.4_p5-use-squashfuse_appimage-for-pkgconfig.patch"
	"${FILESDIR}/${PN}-1.0.2-same-files-static-build.patch"
	"${FILESDIR}/${PN}-1.0.4_p5-complete-pkgconfig.patch"
	"${FILESDIR}/${PN}-1.0.4_p5-tests-use-std-ofstream.patch"
	"${FILESDIR}/${PN}-1.0.4_p5-link-appimage_desktop_integration.patch"
	"${FILESDIR}/${PN}-1.0.4_p5-Thumbnailer-prefixes.patch"
)

pkg_setup() {
	# Forced because we need sources for squashfuse.
	if has network-sandbox $FEATURES ; then
eerror
eerror "${PN} requires network-sandbox to be disabled in FEATURES in order to"
eerror "download internal dependencies."
eerror
		die
	fi

	linux-info_pkg_setup
	linux_config_exists
	if ! linux_chkconfig_builtin INOTIFY_USER ; then
ewarn
ewarn "You need to change your kernel .config to CONFIG_INOTIFY_USER=y"
ewarn
	fi
	if ! use system-boost ; then
ewarn
ewarn "Using the internal boost will have build time failures."
ewarn
	fi
	if use system-squashfuse ; then
		if [[ ! -d "${EROOT}/usr/lib64/squashfuse_appimage" ]] ; then
eerror
eerror "You need the squashfuse package from the oiledmachine-overlay."
eerror
			die
		fi
	fi
}

src_unpack() {
	unpack ${A}
	rm -rf "${S}/lib/gtest" 2>/dev/null 1>/dev/null || die
	ln -s "${WORKDIR}/googletest-${GOOGLETEST_COMMIT}" \
		"${S}/lib/gtest" || die
}

src_configure() {
	local mycmakeargs=(
		-DGIT_COMMIT="${EGIT_COMMIT}"
		-DUSE_SYSTEM_BOOST=$(usex system-boost)
		-DUSE_SYSTEM_LIBARCHIVE=$(usex system-libarchive)
		-DUSE_SYSTEM_SQUASHFUSE=$(usex system-squashfuse)
		-DUSE_SYSTEM_XDGUTILS=$(usex system-xdgutils)
		-DUSE_SYSTEM_XZ=$(usex system-xz)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	insinto /usr/$(get_libdir)
	doins "${BUILD_DIR}/src/xdg-basedir/libxdg-basedir.a" \
		"${BUILD_DIR}/src/libappimage/libappimage_static.a"
	insinto /usr/include/appimage
	doins "${S_BAK}/src/xdg-basedir/xdg-basedir.h"
	docinto licenses
	dodoc LICENSE
	if ! use system-boost ; then
		docinto licenses/third_party/boost
		dodoc "${BUILD_DIR}/boost-EXTERNAL-prefix/src/boost-EXTERNAL/LICENSE_1_0.txt"
	fi
	if ! use system-libarchive ; then
		docinto licenses/third_party/libarchive
		dodoc "${BUILD_DIR}/libarchive-EXTERNAL-prefix/src/libarchive-EXTERNAL/COPYING"
	fi
	if ! use system-xdgutils ; then
		docinto licenses/third_party/xdgutils
		dodoc "${BUILD_DIR}/XdgUtils-EXTERNAL-prefix/src/XdgUtils-EXTERNAL/LICENSE"
	fi
	if ! use system-xz ; then
		docinto licenses/third_party/xz
		dodoc "${BUILD_DIR}/xz-EXTERNAL-prefix/src/xz-EXTERNAL/"{COPYING,COPYING.GPLv2,COPYING.GPLv3,COPYING.LGPLv2.1}
	fi
	if ! use system-squashfuse ; then
		docinto licenses/third_party/squashfuse
		dodoc "${BUILD_DIR}/squashfuse-EXTERNAL-prefix/src/squashfuse-EXTERNAL/LICENSE"
	fi
	insinto /usr/include/libappimage_hashlib
	doins -r src/libappimage_hashlib/include/*
	if ! use system-squashfuse ; then
		insinto /usr/include/appimage
		doins src/patches/squashfuse_dlopen.h
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-REVDEP:  AppImageKit, appimaged
