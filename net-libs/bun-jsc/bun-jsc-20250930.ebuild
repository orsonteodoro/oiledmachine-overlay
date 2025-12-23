# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U20

CFLAGS_HARDENED_USE_CASES="jit network untrusted-data"

CXX_STANDARD=23
INSTALL_PREFIX="/usr/lib/bun-jsc"
PYTHON_COMPAT=( "python3_"{10..12} )
USE_RUBY=" ruby32 ruby33"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX23[@]}"
)
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)"

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX23[@]/llvm_slot_}"
)
LIBCXX_USEDEP_LTS="llvm_slot_skip(+)"

WEBKIT_COMMIT="6d0f3aac0b817cc01a846b3754b21271adedac12"

inherit cflags-hardened check-compiler-switch cmake dhms flag-o-matic-om git-r3
inherit libcxx-slot libstdcxx-slot python-single-r1 ruby-single sandbox-changes
inherit toolchain-funcs

# The source tarball cannot be downloaded.  Only the prebuilt ones.
EGIT_BRANCH="main"
EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
EGIT_COMMIT="${WEBKIT_COMMIT}"
EGIT_MIN_CLONE_TYPE="single"
EGIT_REPO_URI="https://github.com/oven-sh/WebKit.git"
FALLBACK_COMMIT="${WEBKIT_COMMIT}"
KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${P}"

DESCRIPTION="A Bun fork of JavaScriptCore"
HOMEPAGE="
	https://github.com/oven-sh/WebKit
"
LICENSE="
	BSD-2
	LGPL-2
"
RESTRICT="mirror"
SLOT="0/${PV}"
IUSE+="
clang lto
"

REQUIRED_USE="
	clang
	clang? (
		^^ (
			${LIBCXX_COMPAT_STDCXX23[@]}
		)
	)
"

gen_depend_llvm() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				llvm-core/clang:${s}[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
				llvm-core/clang:=
				llvm-core/llvm:${s}[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
				llvm-core/llvm:=
				llvm-core/lld:${s}[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
				llvm-core/lld:=
			)
		"
	done
}

RDEPEND+="
	>=dev-libs/icu-75.1[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS},static-libs]
	dev-libs/icu:=
	>=dev-libs/libxml2-2.9.13:2
	dev-libs/libxml2:=
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${RUBY_DEPS}
	dev-lang/perl
	sys-apps/gawk
	sys-devel/bison
	clang? (
		$(gen_depend_llvm)
	)
"
DOCS=( "ReadMe.md" )
PATCHES=(
#	"${FILESDIR}/${PN}-20250930-nullptr-arg-to-ExternalStringImpl-create-calls.patch"
)

_set_clang() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		if use "llvm_slot_${s}" ; then
			export CC="${CHOST}-clang-${s}"
			export CXX="${CHOST}-clang++-${s}"
			export LLVM_SLOT="${s}"
			break
		fi
	done
	if [[ -z "${CC}" ]] ; then
eerror "Choose a LLVM slot for C++ standard ${CXX_STANDARD}.  Valid values:  ${LLVM_COMPAT[@]/#/llvm_slot_}"
eerror "Enable a llvm_slot_<x> flag."
		die
	fi

einfo "PATH=${PATH} (before)"
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}/bin|g")
einfo "PATH=${PATH} (after)"

	if ! which "${CC}" ; then
eerror "${CC} is not found.  Emerge the compiler slot."
		die
	fi
	export CPP="${CC} -E"
	export AR="llvm-ar"
	export NM="llvm-nm"
	export OBJCOPY="llvm-objcopy"
	export OBJDUMP="llvm-objdump"
	export READELF="llvm-readelf"
	export STRIP="llvm-strip"
	export GCC_FLAGS=""
	strip-unsupported-flags
	${CC} --version || die
}

_set_gcc() {
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CC} -E"
	export AR="ar"
	export NM="nm"
	export OBJCOPY="objcopy"
	export OBJDUMP="objdump"
	export READELF="readelf"
	export STRIP="strip"
	export GCC_FLAGS="-fno-allow-store-data-races"
	strip-unsupported-flags
}

_set_cxx() {
	if tc-is-clang && ! use clang ; then
eerror "Enable the clang USE flag or remove clang from CC/CXX"
		die
	fi
	if [[ ${MERGE_TYPE} != "binary" ]] ; then
	# See https://docs.webkit.org/Ports/WebKitGTK%20and%20WPE%20WebKit/DependenciesPolicy.html
	# Based on D 12, U 22, U 24
	# D12 - gcc 12.2, clang 14.0
	# U22 - gcc 11.2, clang 14.0
	# U24 - gcc 13.2, clang 18.0
		if use clang ; then
			_set_clang
		else
			_set_gcc
		fi
	fi
}

pkg_setup() {
	dhms_start
	check-compiler-switch_start
	_set_cxx
	sandbox-changes_no_network_sandbox "To download source snapshot"
	libcxx-slot_verify
	libstdcxx-slot_verify
	python-single-r1_pkg_setup
	MAKEOPTS="-j1"
}

src_unpack() {
	git-r3_fetch
	git-r3_checkout
}

src_prepare() {
	cmake_src_prepare
#	touch "Source/JavaScriptCore/wasm/WasmOps.h" || die
}

get_libc() {
	if use elibc_glibc ; then
		echo "gnu"
	elif use elibc_musl ; then
		echo "musl"
	fi
}

configure_ruby() {
	# Ruby situation is a bit complicated. See bug 513888
	local rubyimpl
	local ruby_interpreter=""
	for rubyimpl in ${USE_RUBY} ; do
		if has_version -b "virtual/rubygems[ruby_targets_${rubyimpl}]"; then
			RUBY="$(type -P ${rubyimpl})"
			ruby_interpreter="-DRUBY_EXECUTABLE=${RUBY}"
		fi
	done
	# This will rarely occur. Only a couple of corner cases could lead us to
	# that failure. See bug 513888
	if [[ -z ${ruby_interpreter} ]] ; then
eerror "No suitable ruby interpreter found"
		die
	fi
	# JavaScriptCore/Scripts/postprocess-asm invokes another Ruby script directly
	# so it doesn't respect RUBY_EXECUTABLE, bug #771744.
	sed -i -e "s:#!/usr/bin/env ruby:#!${RUBY}:" $(grep -rl "/usr/bin/env ruby" "Source/JavaScriptCore" || die) || die
}

src_configure() {
	filter-flags "-fuse-ld=*"

einfo "BUILD_DIR:  ${BUILD_DIR}"

	local common_flags=(
		"-mno-omit-leaf-frame-pointer"
		"-g"
		"-fno-omit-frame-pointer"
		"-ffunction-sections"
		"-fdata-sections"
		"-faddrsig"
		"-fno-unwind-tables"
		"-fno-asynchronous-unwind-tables"
		"-ffile-prefix-map=${S}/Source=vendor/WebKit/Source"
		"-ffile-prefix-map=${BUILD_DIR}/=."
		"-DU_STATIC_IMPLEMENTATION=1"
	)

	if use lto ; then
		common_flags+=(
			"-flto=full"
			"-fwhole-program-vtables"
			"-fforce-emit-vtables"
		)
	fi

	append-cflags \
		"${common_flags[@]}"

	append-cxxflags \
		"${common_flags[@]}" \
		"-fno-c++-static-destructors"

	append-ldflags \
		"-fuse-ld=lld"

	cflags-hardened_append

	fix_mb_len_max
	strip-unsupported-flags # Enablement required by GCC

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
		allow_lto=0
	fi

	configure_ruby

	local mycmakeargs=(
		-DALLOW_LINE_AND_COLUMN_NUMBER_IN_BUILTINS=ON
		-DCMAKE_BUILD_TYPE="RelWithDebInfo" # Force -O2 for security
		-DCMAKE_C_FLAGS="${CFLAGS}"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS}"
		-DCMAKE_EXPORT_COMPILE_COMMANDS=ON
		-DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}"
		-DPORT="JSCOnly"
		-DENABLE_BUN_SKIP_FAILING_ASSERTIONS=ON
		-DENABLE_FTL_JIT=ON
		-DENABLE_REMOTE_INSPECTOR=ON
		-DENABLE_STATIC_JSC=ON
		-DENABLE_ASSERTS="AUTO"
		-DUSE_BUN_EVENT_LOOP=ON
		-DUSE_BUN_JSC_ADDITIONS=ON
		-DUSE_THIN_ARCHIVES=OFF
	)

	cmake_src_configure
}

src_compile() {
	pushd "Source/JavaScriptCore/wasm" || die
		${EPYTHON} "generateWasmOpsHeader.py" "wasm.json" "${S}_build/JavaScriptCore/DerivedSources/WasmOps.h"
	popd || die
	cmake_src_compile
}

src_install() {
	WEBKIT_RELEASE_TYPE="RelWithDebInfo" # Force -O2 for security
	local prefix="${INSTALL_PREFIX}"
	dodir "${prefix}"
	dodir "${prefix}/lib"
	dodir "${prefix}/include"
	dodir "${prefix}/include/JavaScriptCore"
	dodir "${prefix}/include/glibc"
	dodir "${prefix}/include/wtf"
	dodir "${prefix}/include/bmalloc"
	dodir "${prefix}/include/unicode"
einfo "BUILD_DIR:  ${BUILD_DIR}"
	cd "${BUILD_DIR}" || die
	cmake --build "${BUILD_DIR}" --config "${WEBKIT_RELEASE_TYPE}" --target "jsc" || die
	cp -r "${BUILD_DIR}/lib/"*".a" "${ED}/${prefix}/lib" || die
	cp "${BUILD_DIR}/"*".h" "${ED}/${prefix}/include" || die
	cp -r "${BUILD_DIR}/bin" "${ED}/${prefix}/bin" || die
	cp "${BUILD_DIR}/"*".json" "${ED}/${prefix}" || die
	find "${BUILD_DIR}/JavaScriptCore/DerivedSources/" -name "*.h" -exec sh -c "cp '\${1}' '${ED}/${prefix}/include/JavaScriptCore/\$(basename '${1}')" sh {} \; || die
	find "${BUILD_DIR}/JavaScriptCore/DerivedSources/" -name "*.json" -exec sh -c "cp '\${1}' '${ED}/${prefix}/$(basename '\${1}')" sh {} \; || die
	find "${BUILD_DIR}/JavaScriptCore/Headers/JavaScriptCore/" -name "*.h" -exec cp {} "${ED}/${prefix}/include/JavaScriptCore/" \; || die
	find "${BUILD_DIR}/JavaScriptCore/PrivateHeaders/JavaScriptCore/" -name "*.h" -exec cp {} "${ED}/${prefix}/include/JavaScriptCore/" \; || die
	cp -r "${BUILD_DIR}/WTF/Headers/wtf/" "${ED}/${prefix}/include" || die
	cp -r "${BUILD_DIR}/bmalloc/Headers/bmalloc/" "${ED}/${prefix}/include" || die
	mkdir -p "${ED}/${prefix}/Source/JavaScriptCore" || die
	cp -r "${S}/Source/JavaScriptCore/Scripts" "${ED}/${prefix}/Source/JavaScriptCore" || die
	cp "${S}/Source/JavaScriptCore/create_hash_table" "${ED}/${prefix}/Source/JavaScriptCore" || die
}

pkg_postinst() {
	dhms_end
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
