# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
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

DESCRIPTION="Mono build scripts for Godot on MonoTouch"
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
AOT_CROSS_TARGETS=" cross-armv7 cross-arm64"
DEV_TARGETS=" armv7 arm64"
SIM_TARGETS=" i386 x86_64 arm64-sim"
TARGETS=" ${AOT_CROSS_TARGETS} ${DEV_TARGETS} ${SIM_TARGETS}"
IUSE+="
${TARGETS}
debug
"
REQUIRED_USE+="
	cross-armv7? (
		armv7
	)
	cross-arm64? (
		arm64
	)
	|| (
		${TARGETS}
	)
"
BDEPEND+="
	${PYTHON_DEPS}
	sys-devel/osxcross
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

check_cross_compiler_paths() {
	# TODO:  normalize variable names
	if [[ -z "${IPHONEPATH}" ]] ; then
eerror
eerror "IPHONEPATH must be defined as per-package environment variable."
eerror "It is the path to the toolchain"
eerror
		die
	fi
	[[ -e "${IPHONEPATH}/usr/bin" ]] || die "${IPHONEPATH}/usr/bin is unreachable"
	if [[ -z "${IPHONESDK}" ]] ; then
eerror
eerror "IPHONESDK must be defined as per-package environment variable."
eerror "It is the path to the sdk"
eerror
		die
	fi
	[[ -e "${IPHONESDK}/usr/include" ]] || die "${IPHONESDK}/usr/include is unreachable"

	if [[ -z "${OSXCROSS_IOS}" ]] ; then
ewarn
ewarn "OSXCROSS_IOS must be defined as per-package environment variable."
ewarn "It is set to the path of OSXCross if you are using OSXCross."
ewarn
	fi
}

src_configure() {
	check_cross_compiler_paths
}

src_compile() {
	if use cross-armv7 || use cross-arm64 ; then
		# Works on arm64-macos or x64-macos prefixes?
ewarn
ewarn "AOT cross-compiler compilation may fail with OSXCross."
ewarn "Disable cross-armv7 and cross-arm64 if it fails."
ewarn
	fi
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
			if use "${x}" ; then
				build_targets+=( --target=${x}  )
			fi
		done
		pargs=(
			${build_targets[@]}
			--configuration=${configuration}
			--ios-toolchain="${IPHONEPATH}"
			--ios-sdk="${IPHONESDK}"
		)
		if use debug && [[ "${configuration}" == "debug" ]] ; then
			pargs+=( --strip-libs=False )
		fi
		${EPYTHON} ios.py configure ${args[@]} ${pargs[@]} || die
		${EPYTHON} ios.py make ${args[@]} ${pargs[@]} || die
		${EPYTHON} bcl.py make --product=ios ${args[@]} || die
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
