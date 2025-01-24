# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D12, U22, U24
# D12 llvm:14, gcc:12, icu-72.1, python:3.11, ruby 3.1
# U22 llvm:14, gcc:11, icu-70.1, python:3.10, ruby 3.0
# U24 llvm:18, gcc:13, icu-74.2, python:3.12, ruby 3.2

# For versioning, see
# https://docs.webkit.org/Ports/WebKitGTK%20and%20WPE%20WebKit/DependenciesPolicy.html
# https://github.com/oven-sh/bun/blob/bun-v1.2.0/cmake/tools/SetupWebKit.cmake#L5
# https://github.com/oven-sh/WebKit/blob/9e3b60e4a6438d20ee6f8aa5bec6b71d2b7d213f/Configurations/Version.xcconfig#L26

PYTHON_COMPAT=( "python3_"{10..12} )
LLVM_COMPAT=( 18 14 ) # Only allow tested LTS versions, bun upstream uses llvm:18
WEBKIT_PV="621.1.11"
LOCKFILE_VER="1.2"
USE_RUBY=" ruby31 ruby32"
EGIT_COMMIT="9e3b60e4a6438d20ee6f8aa5bec6b71d2b7d213f"

inherit cmake flag-o-matic python-single-r1 ruby-single

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/WebKit-autobuild-${EGIT_COMMIT}"
SRC_URI="
https://github.com/oven-sh/WebKit/archive/refs/tags/autobuild-${EGIT_COMMIT}.tar.gz
	-> bun-webkit-${EGIT_COMMIT:0:7}.tar.gz
"

DESCRIPTION="WebKit with patches"
HOMEPAGE="
https://bun.sh/
https://github.com/oven-sh/WebKit
"
LICENSE="
	BSD
	BSD-2
	ISC
	LGPL-2+
	LGPL-2.1+
	MIT
	|| (
		GPL-2+
		LGPL-2+
		MPL-1.1
	)
"
# BSD - Source/JavaScriptCore/debugger/DebuggerCallFrame.cpp
# BSD-2 - Source/JavaScriptCore/debugger/Breakpoint.cpp
# ISC - Source/bmalloc/bmalloc/CryptoRandom.cpp
# LGPL-2+ - Source/JavaScriptCore/heap/MarkedSpace.h
# MIT - Source/bmalloc/bmalloc/uv_get_constrained_memory.cpp
# || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) - Source/JavaScriptCore/runtime/JSDateMath.h
RESTRICT="mirror"
SLOT="${LOCKFILE_VER}-${WEBKIT_PV%%.*}"
IUSE+="
${LLVM_COMPAT[@]/#/llvm_slot_}
ebuild_revision_1
"
REQUIRED_USE="
	^^ (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
"
RDEPEND+="
	>=dev-libs/icu-70.1[static-libs]
"
DEPEND+="
	${RDEPEND}
"
gen_llvm_bdepend() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				llvm-core/llvm:${s}
				llvm-core/clang:${s}
				llvm-core/lld:${s}
			)
		"
	done
}
BDEPEND+="
	${PYTHON_DEPS}
	${RUBY_DEPS}
	$(gen_llvm_bdepend)
	>=dev-build/cmake-3.20
	llvm-core/llvm:=
	llvm-core/clang:=
	llvm-core/lld:=
	sys-devel/gcc
"

setup_llvm_path() {
	local llvm_slot
	for llvm_slot in ${LLVM_COMPAT[@]} ; do
		if use "llvm_slot_${llvm_slot}" ; then
			LLVM_SLOT="${llvm_slot}"
			break
		fi
	done
einfo "PATH=${PATH} (before)"
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}/bin|g")
einfo "PATH=${PATH} (after)"
}

pkg_setup() {
	python-single-r1_pkg_setup
	setup_llvm_path
	export CC="${CHOST}-clang-${LLVM_SLOT}"
	export CXX="${CHOST}-clang++-${LLVM_SLOT}"
	export CPP="${CC} -E"
	unset LD
	append-ldflags -fuse-ld=lld
einfo "CC:  ${CC}"
einfo "CXX:  ${CXX}"
einfo "CPP:  ${CPP}"
}

src_unpack() {
	unpack ${A}
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
# Prevent
# Tools/TestWebKitAPI/Tests/WTF/StringImpl.cpp:761:51: error: no matching function for call to 'WTF::ExternalStringImpl::create(<brace-enclosed initializer list>, TestWebKitAPI::WTF_ExternalStringImplCreate8bit_Test::TestBody()::<lambda(WTF::ExternalStringImpl*, void*, unsigned int)>)'
#   761 |         auto external = ExternalStringImpl::create({ buffer, bufferStringLength }, [&freeFunctionCalled](ExternalStringImpl* externalStringImpl, void* buffer, unsigned bufferSize) mutable {
#       |                         ~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   762 |             freeFunctionCalled = true;
#       |             ~~~~~~~~~~~~~~~~~~~~~~~~~~             
#   763 |         });
#       |         ~~
	append-cxxflags $(test-flags-CXX -fno-c++-static-destructors)
einfo "CFLAGS:  ${CFLAGS}"
einfo "CXXFLAGS:  ${CXXFLAGS}"

	# Ruby situation is a bit complicated. See bug 513888
	local rubyimpl
	local ruby_interpreter=""
	for rubyimpl in ${USE_RUBY}; do
		if has_version -b "virtual/rubygems[ruby_targets_${rubyimpl}]"; then
			ruby_interpreter="-DRUBY_EXECUTABLE=$(type -P ${rubyimpl})"
		fi
	done
	# This will rarely occur. Only a couple of corner cases could lead us to
	# that failure. See bug 513888
	if [[ -z $ruby_interpreter ]] ; then
eerror
eerror "No suitable ruby interpreter found"
eerror
		die
	fi

	local mycmakeargs=(
		${ruby_interpreter}
		-DCMAKE_INSTALL_PREFIX="/usr/share/${PN}/${LOCKFILE_VER}-${WEBKIT_PV%%.*}"
		-DPORT="JSCOnly"
		-DENABLE_STATIC_JSC=ON
		-DENABLE_BUN_SKIP_FAILING_ASSERTIONS=ON
		-DCMAKE_BUILD_TYPE="Release"
		-DUSE_THIN_ARCHIVES=OFF
		-DUSE_BUN_JSC_ADDITIONS=ON
		-DUSE_BUN_EVENT_LOOP=ON
		-DENABLE_FTL_JIT=ON
		-DCMAKE_EXPORT_COMPILE_COMMANDS=ON
		-DALLOW_LINE_AND_COLUMN_NUMBER_IN_BUILTINS=ON
		-DENABLE_REMOTE_INSPECTOR=ON
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	insinto "/usr/share/${PN}/${PV}"
	cmake_src_install
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
