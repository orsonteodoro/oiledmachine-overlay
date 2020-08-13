# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Implements functionality for dealing with AppImage files"
HOMEPAGE="https://github.com/AppImage/libappimage"
LICENSE="MIT" # project default license
LICENSE+=" all-rights-reserved" # src/libappimage/libappimage.c ; The vanilla MIT license doesn't have all-rights-reserved
# The below licenses apply to static linking and third-party packages.
LICENSE+=" BSD-2" # for internal squashefuse
LICENSE+=" !system-boost? ( Boost-1.0 )" # copied from the boost ebuild
LICENSE+=" !system-libarchive? ( BSD BSD-2 BSD-4 public-domain )" # copied from the libarchive ebuild
LICENSE+=" !system-xdgutils? ( MIT BSD )" # copied from the dev-libs/xdg-utils-cxx ebuild
LICENSE+=" !system-xz? ( public-domain LGPL-2.1+ GPL-2+ )" # copied from the app-arch/xz-utils ebuild
KEYWORDS="~amd64 ~x86"
IUSE="cmake-static-libs system-boost system-libarchive system-squashfuse system-xdgutils system-xz"
RDEPEND="
	>=dev-libs/glib-2.40:2
	>=gnome-base/librsvg-2
	sys-libs/zlib
	system-boost? ( >=dev-libs/boost-1.69:=[static-libs] )
	system-libarchive? ( app-arch/libarchive:=[static-libs] )
	system-squashfuse? ( sys-fs/squashfuse:=[libsquashfuse-appimage,static-libs] )
	system-xdgutils? ( dev-libs/xdg-utils-cxx:=[static-libs] )
	system-xz? ( app-arch/xz-utils:=[static-libs] )
	x11-libs/cairo"
DEPEND="${RDEPEND}
	sys-devel/clang"
BDEPEND="
	>=dev-util/cmake-3.4
	dev-util/desktop-file-utils
	dev-util/xxd
	dev-vcs/git"
SLOT="0/${PV}"
EGIT_COMMIT="3682efb71847391f75ce6999e94b01b8b8434748" # keep in sync with PV
GOOGLETEST_COMMIT="ec44c6c1675c25b9827aacd08c02433cccde7780"
SRC_URI=\
"https://github.com/AppImage/libappimage/archive/v${PV}.tar.gz \
	 -> ${P}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT}.tar.gz \
	-> ${P}-googletest.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
S_BAK="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"
CMAKE_MAKEFILE_GENERATOR="emake" # required for downloading in compile phase
inherit cmake-utils linux-info
PATCHES=(
	"${FILESDIR}/${PN}-1.0.2-use-squashfuse_appimage-for-pkgconfig.patch"
	"${FILESDIR}/${PN}-1.0.2-same-files-static-build.patch"
	"${FILESDIR}/${PN}-1.0.2-complete-pkgconfig.patch"
	"${FILESDIR}/${PN}-1.0.3-move-definition-in-cpp-file.patch"
)

pkg_setup() {
	# forced on because we need sources for squashfuse
	if has network-sandbox $FEATURES ; then
		die \
"${PN} requires network-sandbox to be disabled in FEATURES in order to download\n\
internal dependencies."
	fi

	linux-info_pkg_setup
	linux_config_exists
	if ! linux_chkconfig_builtin INOTIFY_USER ; then
		die "You need to change your kernel .config to CONFIG_INOTIFY_USER=y"
	fi
	if ! use system-boost ; then
		ewarn "Using the internal boost will have build time failures."
	fi
	if use system-squashfuse ; then
		if [[ ! -d "${EROOT}/usr/lib64/squashfuse_appimage" ]] ; then
			die "You need the squashfuse package from the oiledmachine-overlay."
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
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
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
