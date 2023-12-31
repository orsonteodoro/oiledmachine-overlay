# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHECKREQS_DISK_BUILD="141M"
CHECKREQS_DISK_OPT="141M"
inherit check-reqs

ANDROID_OS_VER="13"
ANDROID_API_LEVEL=$(ver_cut 1 ${PV})
ANDROID_API_LEVEL_REV="r"$(printf "%02d" $(ver_cut 3))

# See
# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=android-platform
# https://salsa.debian.org/google-android-tools-team/google-android-installers
DESCRIPTION="Android SDK Platform"
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
"
# W3C-Document-Copyright-Notice-and-License - https://www.w3.org/TR/1999/CR-DOM-Level-2-19991210/copyright-notice.html
# all-rights-reserved - in android.jar at NOTICES/ojluni-NOTICE ; # \
#   copyright notice is assumed to be the ICU package which has
#   all rights reserved and the same copyright holder.
# unicode - 3 clause
KEYWORDS="~amd64"
IUSE=""
SLOT="${ANDROID_API_LEVEL}"
RDEPEND="
"
DEPEND=""
RESTRICT="mirror strip installsources test"
SRC_URI="
kernel_Darwin? (
	https://dl.google.com/android/repository/platform-tools_r${PV}-darwin.zip
		-> android-platform-r${PV}-darwin.zip
)
kernel_linux? (
	https://dl.google.com/android/repository/platform-tools_r${PV}-linux.zip
		-> android-platform-r${PV}-linux.zip
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
	dodir "/${ANDROID_SDK_DIR}/platforms/android-${ANDROID_API_LEVEL}"
	local dest="${ED}/${ANDROID_SDK_DIR}/platforms/android-${ANDROID_API_LEVEL}"
	cp -pPR \
		* \
		"${FILESDIR}/package.xml" \
		"${dest}" \
		|| die
	fowners -R root:android "/${ANDROID_SDK_DIR}"
	sed -i -e "s|@api-level@|${ANDROID_API_LEVEL}|g" \
		"${ED}/${ANDROID_SDK_DIR}/platforms/android-${ANDROID_API_LEVEL}/package.xml" || die
}
