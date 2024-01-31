# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHECKREQS_DISK_BUILD="1721M"
CHECKREQS_DISK_OPT="1721M"
inherit check-reqs

DESCRIPTION="The Android Native Development Kit"
HOMEPAGE="https://developer.android.com/ndk/"
LICENSE="
	android
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	icu-70.1
	ISC
	BSD
	BSD-2
	BSD-4
	MIT
	MPL-2.0
	( PSF-2.4 ( PSF-2 0BSD ) MIT )
	unicode
	UoI-NCSA
"
# Apache-2.0, BSD, BSD-2, BSD-4, ISC, unicode, icu-70.1, MPL-2.0 - toolchains/llvm/prebuilt/linux-x86_64/sysroot/NOTICE # \
#  ; The license contains an older icu version 6x.y because of the http:// and 2018.  \
#  The uvernum.h header says 70.1 which has a https:// and 2020 in the license file.
# Apache-2.0-with-LLVM-exceptions, UoI-NCSA, MIT - toolchains/llvm/prebuilt/linux-x86_64/NOTICE
# Apache-2.0-with-LLVM-exceptions - toolchains/llvm/prebuilt/linux-x86_64/libexec/ccc-analyzer
# BSD - sources/third_party/googletest/LICENSE
# MIT - toolchains/llvm/prebuilt/linux-x86_64/python3/lib/python3.9/site-packages/setuptools-49.2.1.dist-info/LICENSE
# PSF-2.4 ( PSF-2 0BSD ), MIT - toolchains/llvm/prebuilt/linux-x86_64/python3/lib/python3.9/LICENSE.txt
KEYWORDS="~amd64"
IUSE=""
SLOT="0"
RDEPEND="
	  app-arch/bzip2
	  dev-lang/perl
	>=dev-util/android-sdk-update-manager-10
	  sys-devel/gcc
	>=dev-build/make-3.81
	  sys-libs/glibc
	  sys-libs/libxcrypt
	  sys-libs/ncurses-compat:5[abi_x86_32(-),tinfo]
	  sys-libs/zlib
"
DEPEND=""
RESTRICT="mirror strip installsources test"
SRC_URI="
https://dl.google.com/android/repository/${PN}-r${PV}-linux.zip
"
S="${WORKDIR}/${PN}-r${PV}"
ANDROID_NDK_DIR="opt/${PN}"
QA_PREBUILT="*"
PYTHON_UPDATER_IGNORE="1"

pkg_pretend() {
	check-reqs_pkg_pretend
	_check-reqs_disk \
		"${EROOT%/}/opt" \
		"${CHECKREQS_DISK_OPT}"
}

pkg_setup() {
einfo
einfo "This is a LTS version.  Support is up to NDK r26 (Q3 2023)."
einfo
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
	dodir "/${ANDROID_NDK_DIR}"
	cp -pPR * "${ED}/${ANDROID_NDK_DIR}" || die

	dodir "/${ANDROID_NDK_DIR}/out"
	fowners -R root:android "/${ANDROID_NDK_DIR}"
	fperms 0775 "/${ANDROID_NDK_DIR}/"{,build,prebuilt}
	fperms 0775 "/${ANDROID_NDK_DIR}/"{python-packages,sources,toolchains}
	fperms 3775 "/${ANDROID_NDK_DIR}/out"

	ANDROID_PREFIX="${EPREFIX}/${ANDROID_NDK_DIR}"
	ANDROID_PATH="${EPREFIX}/${ANDROID_NDK_DIR}"

	realpath -e toolchains/*/prebuilt/linux-*/bin || die "Missing folder"
	for i in toolchains/*/prebuilt/linux-*/bin
	do
		ANDROID_PATH="${ANDROID_PATH}:${ANDROID_PREFIX}/${i}"
	done

	echo "PATH=\"${ANDROID_PATH}\"" > "${T}/80${PN}" || die
	doenvd "${T}/80${PN}"

	echo "SEARCH_DIRS_MASK=\"${EPREFIX}/${ANDROID_NDK_DIR}\"" > "${T}/80${PN}" || die
	insinto "/etc/revdep-rebuild"
	doins "${T}/80${PN}"
}
