# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHECKREQS_DISK_BUILD="139M"
CHECKREQS_DISK_OPT="139M"
inherit check-reqs

# See
# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=android-sdk-build-tools
# https://salsa.debian.org/google-android-tools-team/google-android-installers
DESCRIPTION="Android SDK Build-Tools"
HOMEPAGE="http://developer.android.com/sdk/index.html"
LICENSE="
	android
	custom
	( MIT all-rights-reserved )
	( BSD BSD-2 Artistic GPL-2 LGPL-2.1 )
	Apache-2.0
	BSD
	BSD-2
	BSD-4
	CPL-1.0
	EPL-1.0
	FTL
	GPL-2
	GPL-2-with-classpath-exception
	HPND
	icu
	IJG
	ISC
	LGPL-2.1
	libpng
	MIT
	openssl
	SunPro
	unicode
	UoI-NCSA
	W3C-Document-Copyright-Notice-and-License
	W3C-Software-and-Document-Notice-and-License
	ZLIB
	|| ( MPL-1.1 GPL-2 LGPL-2.1 )
" # ^^ (mutual exclusion) does not work, || assumes user picks outside computer.
# W3C-Document-Copyright-Notice-and-License - https://www.w3.org/TR/1999/CR-DOM-Level-2-19991210/copyright-notice.html
KEYWORDS="~amd64"
IUSE=""
SLOT="${PV}"
RDEPEND="
"
DEPEND=""
RESTRICT="mirror strip installsources test"
ANDROID_OS_VER="13"
SRC_URI="
kernel_Darwin? (
https://dl.google.com/android/repository/build-tools_r33.0.1-macosx.zip
	-> android-build-tools_r${PV}-macosx.zip
)
kernel_linux? (
https://dl.google.com/android/repository/build-tools_r33.0.1-linux.zip
	-> android-build-tools_r${PV}-linux.zip
)
"
S="${WORKDIR}/android-${ANDROID_OS_VER}"
ANDROID_NDK_DIR="opt/android-ndk"
ANDROID_SDK_DIR="opt/android-sdk-update-manager"
QA_PREBUILT="*"
PYTHON_UPDATER_IGNORE="1"

pkg_pretend() {
	check-reqs_pkg_pretend
	_check-reqs_disk \
		"${EROOT%/}/opt" \
		"${CHECKREQS_DISK_OPT}"
}

pkg_setup() {
	check-reqs_pkg_setup
	_check-reqs_disk \
		"${EROOT%/}/opt" \
		"${CHECKREQS_DISK_OPT}"
}

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	dodir "/${ANDROID_SDK_DIR}/build-tools/${PV}"
	local dest="${ED}/${ANDROID_SDK_DIR}/build-tools/${PV}"
	cp -pPR \
		* \
		"${FILESDIR}/package.xml" \
		"${dest}" \
		|| die
	fowners -R root:android "/${ANDROID_SDK_DIR}"
	local major=$(ver_cut 1 ${PV})
	local minor=$(ver_cut 2 ${PV})
	local micro=$(ver_cut 3 ${PV})
	sed -i -e "s|@major@|${major}|g" \
		"${ED}/${ANDROID_SDK_DIR}/build-tools/${PV}/package.xml" || die
	sed -i -e "s|@minor@|${minor}|g" \
		"${ED}/${ANDROID_SDK_DIR}/build-tools/${PV}/package.xml" || die
	sed -i -e "s|@micro@|${micro}|g" \
		"${ED}/${ANDROID_SDK_DIR}/build-tools/${PV}/package.xml" || die
	dosym d8 "/${ANDROID_SDK_DIR}/build-tools/${PV}/dx"
	dosym d8.jar "/${ANDROID_SDK_DIR}/build-tools/${PV}/lib/dx.jar"
}
