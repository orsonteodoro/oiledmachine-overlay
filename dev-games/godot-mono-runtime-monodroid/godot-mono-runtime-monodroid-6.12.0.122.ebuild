# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="df330ce"
MY_PN="godot-mono-builds"
MY_P="${MY_PN}-${PV}"
STATUS="stable"
GODOT_SLOT_MAJOR="3"

PYTHON_COMPAT=( python3_{8..11} )
inherit flag-o-matic git-r3 python-any-r1

MONO_PV=$(ver_cut 1-4 "${PV}")
SRC_URI=""
if ! [[ "${PV}" =~ "9999" ]] ; then
	SRC_URI+="
https://github.com/godotengine/godot-mono-builds/archive/refs/tags/release-${MY_PV}.tar.gz
	-> ${MY_PN}-${MY_PV}.tar.gz
	"
fi
S="${WORKDIR}/${MY_PN}-release-${MY_PV}"

DESCRIPTION="Mono build scripts for Godot on MonoDroid"
HOMEPAGE="https://github.com/godotengine/godot-mono-builds"
# Many licenses because of assets (e.g. artwork, fonts) and third party libraries
LICENSE="MIT"
#KEYWORDS="" # Ebuild not finished

# Extra licenses because it is in source code form and third party external
# modules.  Also, additional licenses for additional files through git not
# found in the tarball.
MONO_LICENSE="
	MIT
	(
		MIT
		UoI-NCSA
	)
	Apache-1.1
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	APSL-2
	BoringSSL-ECC
	BoringSSL-PSK
	BSD
	BSD-2
	BSD-4
	CC-BY-2.5
	CC-BY-4.0
	DOTNET-libraries-and-runtime-components-patents
	gcc-runtime-library-exception-3.1
	GPL-2+
	GPL-2-with-linking-exception
	GPL-2+-with-libtool-exception
	GPL-3+
	GPL-3+-with-autoconf-exception
	GPL-3+-with-libtool-exception
	IDPL
	Info-ZIP
	ISC
	LGPL-2.1
	LGPL-2.1-with-linking-exception
	Mono-gc_allocator.h
	Mono-patents
	MPL-1.1
	Ms-PL
	openssl
	OSL-3.0
	SunPro
	ZLIB
"
# The GPL-2, GPL-2+*, GPL-3* apply to build files and not for binary only
# distribution after install.

# The GPL-2-with-linking-exception is actually GPL-2+-with-linking-exception"
# since "or later" is present which makes it Apache-2.0 compatible, so the"
# distro license file name is a misnomer.  A GPL-2 only usually will have
# something like "version 2." or "version 2 of the license." without the word
# "later".

# Apache-1.1 - external/ikvm/THIRD_PARTY_README
# Apache-2.0-with-LLVM-exceptions - mono/tools/offsets-tool/clang/enumerations.py
# APSL-2 BSD-4 - support/ios/net/route.h
# BSD - mono/utils/bsearch.c
# BSD ISC openssl custom -- boringssl
#   custom - ssl/ssl_lib.c
# BSD-2 - mono/utils/freebsd-elf64.h
# BSD-2 SunPro - support/libm/complex.c
# gcc-runtime-library-exception-3.1
#   https://github.com/mono/mono/blob/mono-6.12.0.122/mono/mini/decompose.c#L966
#   https://github.com/mono/mono/blob/mono-6.12.0.122/THIRD-PARTY-NOTICES.TXT#L69
# GPL-2+-with-libtool-exception external/bdwgc/libtool
# GPL-2+ GPL-3+ GPL-3+-with-libtool-exception external/bdwgc/libtool
# GPL-2+-with-linking-exception mcs/class/ICSharpCode.SharpZipLib/ICSharpCode.SharpZipLib/BZip2/BZip2.cs
# GPL-3+-with-autoconf-exception - external/bdwgc/libatomic_ops/config.guess
# LGPL-2.1 LGPL-2.1-with-linking-exception -- mcs/class/ICSharpCode.SharpZipLib/ICSharpCode.SharpZipLib/BZip2/BZip2.cs (ICSharpCode.SharpZipLib.dll)
# MIT UoI-NCSA - external/llvm-project/libunwind/src/EHHeaderParser.hpp
# openssl - external/boringssl/crypto/ecdh/ecdh.c
# OSL-3.0 - external/nunit-lite/NUnitLite-1.0.0/src/framework/Internal/StackFilter.cs
# ZLIB - external/ikvm ; lists paths/names with different licenses but these files are removed or not present (option disabled by godot-mono-builds)
# ZLIB - ikvm-native/jni.h
LICENSE+=" ${MONO_LICENSE}"
# See https://github.com/mono/mono/blob/main/LICENSE to resolve license compatibilities.

#KEYWORDS=""
SLOT="0/$(ver_cut 1-2 ${PV})"
AOT_CROSS_TARGETS=" cross-arm cross-arm64 cross-x86 cross-x86_64"
#AOT_CROSS_MXE_TARGETS=" cross-arm-win cross-arm64-win cross-x86-win cross-x86_64-win"
RUNTIME_TARGETS=" armeabi-v7a arm64-v8a x86 x86_64"
TARGETS=" ${RUNTIME_TARGETS} ${AOT_CROSS_TARGETS} ${AOT_CROSS_MXE_TARGETS}"
IUSE+="
${TARGETS}
debug
"
REQUIRED_USE+="
	cross-arm? (
		armeabi-v7a
	)
	cross-arm64? (
		arm64-v8a
	)
	cross-x86? (
		x86
	)
	cross-x86_64? (
		x86_64
	)
	|| (
		${TARGETS}
	)
"
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-util/android-ndk-21
	>=dev-util/cmake-3.18.1
	dev-util/android-sdk-update-manager
"
PROPERTIES="live"
RESTRICT="strip"

_unpack_godot_mono_builds() {
	if [[ "${PV}" =~ "9999" ]] ; then
		EGIT_REPO_URI="https://github.com/godotengine/godot-mono-builds.git"
		EGIT_BRANCH="master"
		EGIT_CHECKOUT_DIR="${S}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${MY_PN}-${MY_PV}.tar.gz
	fi
}

_unpack_mono() {
	# The tarball is missing mono/tools/offsets-tool
	EGIT_CLONE_TYPE="${EGIT_CLONE_TYPE:-single}"
	EGIT_REPO_URI="https://github.com/mono/mono.git"
	EGIT_COMMIT="mono-${MONO_PV}"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/mono-${MONO_PV}"
	git-r3_fetch
	git-r3_checkout
}

_verify_mono() {
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

src_unpack() {
	_unpack_godot_mono_builds
	_unpack_mono
	_verify_mono
}

src_prepare() {
	default
	export MONO_SOURCE_ROOT="${WORKDIR}/mono-${MONO_PV}"
	[[ -e "${MONO_SOURCE_ROOT}" ]] || die
	${EPYTHON} patch_mono.py || die
}

src_configure() {
#	Assumptions by distro:
#	export ANDROID_NDK_ROOT="/opt/android-ndk"
#	ANDROID_SDK_DIR="/opt/android-sdk-update-manager"
#	ANDROID_HOME is set by dev-util/android-sdk-update-manager as
#	ANDROID_HOME="${EPREFIX}${ANDROID_SDK_DIR}"

	export ANDROID_SDK_ROOT=${ANDROID_HOME}
	export NDK_VERSION=$(best_version "dev-util/android-ndk" \
		| sed -e "s|dev-util/android-ndk-||g")
	if [[ ! -e "${ANDROID_SDK_ROOT}/ndk/${NDK_VERSION}" ]] ; then
eerror
eerror "${ANDROID_SDK_ROOT}/ndk/${NDK_VERSION} is unreachable"
eerror
		die
	fi
	if [[ ! -e "${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager" ]] ; then
eerror
eerror "${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager is unreachable"
eerror "Missing package."
eerror
		die
	fi
}

src_compile() {
	mkdir -p "${WORKDIR}/build" || die
	local args
	local build_targets
	local configuration
	local pargs
	local x
	for configuration in debug release ; do
		if ! use debug && [[ "${configuration}" == "debug" ]] ; then
			continue
		fi
		args=(
			--install-dir="${WORKDIR}/build"
		)
		build_targets=()
		for x in ${TARGETS} ; do
			build_targets+=( --target=${x} )
		done
		pargs=(
			${build_targets[@]}
			--configuration=${configuration}
			--android_ndk_version=${NDK_VERSION}
		)
		if use debug && [[ "${configuration}" == "debug" ]] ; then
			pargs+=( --strip-libs=False )
		fi
		${EPYTHON} android.py configure ${args[@]} ${pargs[@]} || die
		${EPYTHON} android.py make ${args[@]} ${pargs[@]} || die
		${EPYTHON} bcl.py make --product=android ${args[@]} || die
		rm -rf $(realpath "${WORKDIR}/build/*-bcl") || die
	done
}

src_install() {
	use debug && export STRIP="true" # Don't strip debug builds
	insinto "/usr/lib/godot/${GODOT_SLOT_MAJOR}/mono-runtime"
	doins -r "${WORKDIR}/build/"*
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
