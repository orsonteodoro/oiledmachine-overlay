# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="fcf205c"
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

DESCRIPTION="Mono build scripts for Godot on macOS"
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
TARGETS=" arm64 x86_64"
IUSE+="
${TARGETS}
debug
"
REQUIRED_USE+="
	|| ( ${TARGETS} )
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

test_path() {
	local p="${1}"
	if ! realpath -e "${p}" ; then
eerror
eerror "${p} is not reachable"
eerror
	fi
}

src_configure() {
	if use arm64-macos || use x64-macos ; then
		:;
	elif [[ -z "${OSXCROSS_ROOT}" ]] ; then
eerror
eerror "OSXCROSS_ROOT must be defined as an environment variable."
eerror
		die
	fi
	export OSXCROSS_SDK="${OSXCROSS_SDK:-18}"
einfo
einfo "Changeable environment variables:"
einfo
einfo "  OSXCROSS_SDK=${OSXCROSS_SDK}"
einfo
	if [[ -n "${OSXCROSS_ROOT}" ]] ; then
		test_path "${OSXCROSS_ROOT}/target"
		local arch="ARCH_MISSING"
		if use arm64 ; then
			arch="aarch64"
		fi
		if use x86_64 ; then
			arch="x86_64"
		fi
		test_path "${OSXCROSS_ROOT}/target/bin/${arch}-*-darwin${OSXCROSS_SDK}-ar"
		test_path "${OSXCROSS_ROOT}/target/bin/${arch}-*-darwin${OSXCROSS_SDK}-as"
		test_path "${OSXCROSS_ROOT}/target/bin/${arch}-*-darwin${OSXCROSS_SDK}-clang"
		test_path "${OSXCROSS_ROOT}/target/bin/${arch}-*-darwin${OSXCROSS_SDK}-clang++"
		test_path "${OSXCROSS_ROOT}/target/bin/${arch}-*-darwin${OSXCROSS_SDK}-ld"
		test_path "${OSXCROSS_ROOT}/target/bin/${arch}-*-darwin${OSXCROSS_SDK}-ranlib"
		test_path "${OSXCROSS_ROOT}/target/bin/${arch}-*-darwin${OSXCROSS_SDK}-cmake"
		test_path "${OSXCROSS_ROOT}/target/bin/${arch}-*-darwin${OSXCROSS_SDK}-strip"
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
			if use "${x}" ; then
				build_targets+=( --target=${x}  )
			fi
		done
		pargs=(
			${build_targets[@]}
			--configuration=${configuration}
		)
		if use debug && [[ "${configuration}" == "debug" ]] ; then
			pargs+=( --strip-libs=False )
		fi
		${EPYTHON} osx.py configure ${args[@]} ${pargs[@]} || die
		${EPYTHON} osx.py make ${args[@]} ${pargs[@]} || die
		${EPYTHON} bcl.py make --product=desktop ${args[@]} || die
		${EPYTHON} osx.py copy-bcl ${args[@]} ${pargs[@]} || die
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
