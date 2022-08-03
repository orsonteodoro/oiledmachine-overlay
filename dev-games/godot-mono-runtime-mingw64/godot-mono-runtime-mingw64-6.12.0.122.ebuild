# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="df330ce"
MY_PN="godot-mono-builds"
MY_P="${MY_PN}-${PV}"
STATUS="stable"

EGIT_REPO_URI="https://github.com/godotengine/godot-mono-builds.git"
EGIT_BRANCH="master"

PYTHON_COMPAT=( python3_{8..10} )
inherit eutils flag-o-matic python-any-r1
if [[ ${PV} =~ 9999 ]] ; then
	inherit git-r3
fi

DESCRIPTION="Mono build scripts for Godot (monodroid)"
HOMEPAGE="https://github.com/godotengine/godot-mono-builds"
# Many licenses because of assets (e.g. artwork, fonts) and third party libraries
LICENSE="MIT"

# Extra licenses because it is in source code form and third party external
# modules.
MONO_LICENSE="
	MIT
	Apache-1.1
	Apache-2.0
	BSD-4
	GPL-2+
	GPL-2-with-linking-exception
	GPL-2+-with-libtool-exception
	GPL-3+
	GPL-3+-with-autoconf-exception
	GPL-3+-with-libtool-exception
	IDPL
	LGPL-2.1
	LGPL-2.1-with-linking-exception
	MPL-1.1
	Ms-PL
	openssl
	OSL-3.0
	ZLIB
"
# The GPL-2-with-linking-exception is actually GPL-2+-with-linking-exception"
# since "or later" is present which makes it Apache-2.0 compatible, so the"
# distro license file name is a misnomer.  A GPL-2 only usually will have
# something like "version 2." or "version 2 of the license." without the word
# "later".

# Apache-1.1 - external/ikvm/THIRD_PARTY_README
# GPL-2+-with-libtool-exception external/bdwgc/libtool
# GPL-2+ GPL-3+ GPL-3+-with-libtool-exception external/bdwgc/libtool
# GPL-2+-with-linking-exception mcs/class/ICSharpCode.SharpZipLib/ICSharpCode.SharpZipLib/BZip2/BZip2.cs
# GPL-3+-with-autoconf-exception - external/bdwgc/libatomic_ops/config.guess
# LGPL-2.1 LGPL-2.1-with-linking-exception -- mcs/class/ICSharpCode.SharpZipLib/ICSharpCode.SharpZipLib/BZip2/BZip2.cs (ICSharpCode.SharpZipLib.dll)
# openssl - external/boringssl/crypto/ecdh/ecdh.c
# OSL-3.0 - external/nunit-lite/NUnitLite-1.0.0/src/framework/Internal/StackFilter.cs
# ZLIB - ikvm-native/jni.h
LICENSE+=" ${MONO_LICENSE}"
# See https://github.com/mono/mono/blob/main/LICENSE to resolve license compatibilities.

#KEYWORDS=""
SLOT="0/$(ver_cut 1-2 ${PV})"
TARGETS=" x86_64"
IUSE+=" ${TARGETS}"
REQUIRED_USE+="
	|| ( ${TARGETS} )
"
DEPEND+=""
BDEPEND+="
	${PYTHON_DEPS}
"
S="${WORKDIR}/${MY_PN}-release-${MY_PV}"
PROPERTIES="live"
MONO_PV=$(ver_cut 1-4 "${PV}")
SRC_URI="
https://download.mono-project.com/sources/mono/mono-${MONO_PV}.tar.xz
"
if [[ ! ( ${PV} =~ 9999 ) ]] ; then
	SRC_URI+="
https://github.com/godotengine/godot-mono-builds/archive/refs/tags/release-${MY_PV}.tar.gz
	-> ${MY_PN}-${MY_PV}.tar.gz
	"
fi

src_unpack() {
	unpack ${A}
	if [[ ${PV} =~ 9999 ]] ; then
		git-r3_fetch
		git-r3_checkout
	fi
	local expected_mono_pv=$(grep "Mono:" "${S}/README.md" \
		| grep -o -E -e"[0-9.]+" \
		| sed -e "s|\.$||g")
	local actual_mono_pv="${MONO_PV}"
	if ver_test ${expected_mono_pv} -ne ${actual_mono_pv} ; then
eerror
eerror "Expected Mono version:  ${expected_mono_pv}"
eerror "Actual Mono version:  ${actual_mono_pv}"
eerror
eerror "Bump the ebuild package version"
eerror
		die
	fi
}

src_prepare() {
	export MONO_SOURCE_ROOT="${WORKDIR}/mono-${MONO_PV}"
	[[ -e "${MONO_SOURCE_ROOT}" ]] || die
	${EPYTHON} patch_mono.py || die
}

src_compile() {
	local build_targets=()
	if [[ -z "${MINGW64_SYSROOT}" ]] ; then
eerror
eerror "MINGW64_SYSROOT must be defined as an environment variable."
eerror
		die
	fi
	local build_extras=( --mxe-prefix="${MINGW64_SYSROOT}/usr" )

	local x
	for x in ${TARGETS} ; do
		build_targets+=( --target=${x} )
	done

	${EPYTHON} windows.py configure ${build_targets[@]} \
		${build_extras[@]} || die
	${EPYTHON} windows.py make ${build_targets[@]} \
		${build_extras[@]} || die

	${EPYTHON} bcl.py make --product=desktop || die
}

src_install() {
	ewarn "TODO: src_install()"
	die
}
