# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D12, U22, U24
# D12 llvm:14, gcc:12, icu-72.1, python:3.11, ruby 3.1, perl 5.36
# U22 llvm:14, gcc:11, icu-70.1, python:3.10, ruby 3.0, perl 5.34
# U24 llvm:18, gcc:13, icu-74.2, python:3.12, ruby 3.2, perl 5.38

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

inherit cmake flag-o-matic python-single-r1 ruby-single toolchain-funcs

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
ebuild_revision_2
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
	>=dev-lang/perl-5.34
	llvm-core/llvm:=
	llvm-core/clang:=
	llvm-core/lld:=
	sys-devel/gcc
"
PATCHES=(
	"${FILESDIR}/${PN}-621.1.11_p20250114-disable-tests.patch"
)

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
	# To delete in next update cycle.
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

	filter-flags '-ffast-math'
	replace-flags '-Ofast' '-O3'
	replace-flags '-O0' '-O1'

	# CE - Code Execution
	# DoS - Denial of Service
	# DT - Data Tamperint
	# ID - Information Disclosure

	# Prevent the sys-devel/gcc[vanilla] unintended consequences.
	if tc-enables-ssp ; then
einfo "SSP is already enabled."
	else
	# As a precaution mitigate CE, DT, ID, DoS
einfo "Adding SSP protection"
		append-flags -fstack-protector
	fi

	if tc-enables-fortify-source ; then
einfo "_FORITIFY_SOURCE is already enabled."
	else
	# A precaution to mitigate CE, DT, ID, DoS (CWE-121).
einfo "Adding _FORITIFY_SOURCE=2"
		append-flags -D_FORTIFY_SOURCE=2
	fi

	if tc-enables-pie ; then
einfo "PIC is already enabled."
	else
	# ASLR (buffer overflow mitigation)
einfo "Adding -fPIC"
		append-flags -fPIC
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
	dodir "/usr/share/${PN}/${SLOT}"
	mv "${WORKDIR}/WebKit-autobuild-${EGIT_COMMIT}_build/"* "${ED}/usr/share/${PN}/${SLOT}" || die
	mv "${WORKDIR}/WebKit-autobuild-${EGIT_COMMIT}_build/.ninja"* "${ED}/usr/share/${PN}/${SLOT}" || die

	# Sanitize permissions
	chown -R "portage:portage" "${ED}/usr/share/${PN}/${SLOT}" || die
	find "${ED}" -type f -print0 | xargs -0 chmod 0644 || die
	find "${ED}" -type d -print0 | xargs -0 chmod 0755 || die
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
