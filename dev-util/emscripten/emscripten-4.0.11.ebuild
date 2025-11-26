# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Keep emscripten.config.x.yy.zz updated if changed from:
# https://github.com/emscripten-core/emscripten/blob/4.0.11/tools/config_template.py

# TC = toolchain
BINARYEN_SLOT="123" # Consider using Binaryen as part of SLOT_MAJOR for ABI/TC compatibility.
CLOSURE_COMPILER_SLOT="0"
DEST_FILENAME="${P}.tar.gz"
EMSCRIPTEN_CONFIG_VER="2.0.26"
JAVA_SLOT="11"
LLVM_COMPAT=( "21" )
LLVM_SLOT="21"
LLVM_MAX_SLOT="${LLVM_SLOT}"
EMSCRIPTEN_SLOT="${LLVM_SLOT}-"$(ver_cut "1-2" "${PV}") # After LLVM_SLOT
INSTALL_PREFIX="/usr/lib/emscripten/${EMSCRIPTEN_SLOT}" # After EMSCRIPTEN_SLOT
NODE_SLOT_MIN="16"
PYTHON_COMPAT=( "python3_"{8..12} ) # emsdk lists 3.9
TEST_PATH="${WORKDIR}/test/"
# See also
# https://github.com/emscripten-core/emsdk/blob/4.0.11/.circleci/config.yml#L24
# https://github.com/emscripten-core/emsdk/blob/4.0.11/emsdk#L11
# https://github.com/emscripten-core/emsdk/blob/4.0.11/scripts/update_python.py#L34
# https://github.com/emscripten-core/emscripten/blob/4.0.11/requirements-dev.txt
# flake8 (5.0.4) - <= 3.10
# flake8 (7.1.1) - <= 3.12
# websockify (0.10.0) - <= 3.9
BROWSERS_MIN_VER="Chrome 85, Firefox 79, Safari 15"
# Chrome min version:  https://github.com/emscripten-core/emscripten/blob/4.0.11/src/settings.js#L1904
# Firefox min version:  https://github.com/emscripten-core/emscripten/blob/4.0.11/src/settings.js#L1878
# Safari min version:  https://github.com/emscripten-core/emscripten/blob/4.0.11/src/settings.js#L1893

inherit check-compiler-switch flag-o-matic java-pkg-opt-2 python-single-r1 toolchain-funcs

#KEYWORDS="~amd64 ~amd64-linux ~arm64 ~arm64-macos" # See tests/clang_native.py for supported arches ; needs testing or patch update
SRC_URI="
	https://github.com/kripken/${PN}/archive/${PV}.tar.gz -> ${DEST_FILENAME}
	https://github.com/emscripten-core/emscripten/pull/20930/commits/72dd53cb20f421d7036680319b0e66489378df8e.patch -> emscripten-commit-72dd53c.patch
"

DESCRIPTION="LLVM-to-JavaScript Compiler"
HOMEPAGE="http://emscripten.org/"
LICENSE="
	(
		all-rights-reserved
		|| (
			MIT
			UoI-NCSA
		)
	)
	(
		all-rights-reserved
		MIT
	)
	all-rights-reserved
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	Boost-1.0
	BSD
	BSD-2
	CC-BY-SA-3.0
	freeglut-teapot
	GPL-2+
	LGPL-2.1
	LGPL-3
	MIT
	MPL-2.0
	OFL-1.1
	OG-X11
	Unlicense
	UoI-NCSA
	ZLIB
	closure-compiler? (
		Apache-2.0
		BSD
		CPL-1.0
		GPL-2+
		LGPL-2.1+
		MIT
		MPL-2.0
		NPL-1.1
	)
	|| (
		FTL
		GPL-2
	)
"
#
# LICENSE_NOTES=
#
# Third-party
#   ansidecl.h - GPL-2+
#   cp-demangle.h - GPL-2+
#   demangle.h - GPL-2+
#   emjvm - UoI-NCSA MIT
#   filelock.py - Unlicense
#   gcc_demangler.c - GPL-2+
#   jni.h - Apache-2.0
#   libiberty.h - GPL-2+
#   PLY (Python Lex-Yacc) - all-rights-reserved for cpp.py, BSD for project
#   stb_image.c - public domain + no warranty
#   WebIDL.py - MPL-2.0
#   websockify LGPL-3 MPL-2 BSD BSD-2 MIT
#     websockify/include/VT100.js LGPL-2.1
#   wrtcp.js - all-rights-reserved MIT
#
# Tools
#   acorn - MIT
#   terser - BSD-2
#   source-map - BSD
#
# Tests
#   all-rights-reserved || ( MIT UoI-NCSA )
#   all-rights-reserved MIT - tests/full_es2_sdlproc.c
#   box2d - ZLIB
#     freeglut - MIT LGPL-2
#   bullet - ZLIB GPL-2
#   closure-compiler/node-externs Apache-2.0
#   enet - MIT
#   freealut - LGPL-2
#     files under src is UoI-NCSA MIT
#   freetype - || ( FTL GPL-2 ) MIT ZLIB
#     LiberationSansBold - OFL-1.1
#   openjpeg - BSD-2
#   tests/sounds - CC-BY-SA-3.0
#   tests/third_party/box2d/freeglut/freeglut_teapot_data.h - MIT freeglut-teapot
#   poppler - GPL-2
#   poppler/cmake - BSD
#
# Package
#   Package - UoI-NCSA MIT
#     all-rights-reserved (in source) even with MIT license
#   compiler-rt - Apache-2.0-with-LLVM-exceptions MIT UoI-NCSA
#   sdl - ZLIB
#   musl - all-rights-reserved MIT
#   libcxx, libcxxabi, libunwind - MIT UoI-NCSA
#   system/include/GL/gl.h -- all-rights-reserved MIT
#   system/lib/libcxx/src/ryu/f2s.cpp -- Apache-2.0-with-LLVM-exceptions, Boost-1.0
#
RESTRICT="mirror"
SLOT="${EMSCRIPTEN_SLOT}"
IUSE+="
${LLVM_COMPAT[@]/#/llvm_slot_}
-closure-compiler closure_compiler_java closure_compiler_native
closure_compiler_nodejs java test
ebuild_revision_10
"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	^^ (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
	closure_compiler_java? (
		closure-compiler
		java
	)
	closure_compiler_native? (
		closure-compiler
	)
	closure_compiler_nodejs? (
		closure-compiler
		java
	)
	closure-compiler? (
		^^ (
			closure_compiler_native
			closure_compiler_java
			closure_compiler_nodejs
		)
	)
"
# For DEPENDs:
# See also .circleci/config.yml
# See also https://github.com/emscripten-core/emscripten/blob/4.0.11/site/source/docs/building_from_source/toolchain_what_is_needed.rst
# For the required Binaryen, see also https://github.com/emscripten-core/emscripten/blob/4.0.11/tools/building.py#L41 EXPECTED_BINARYEN_VERSION
# For the required closure-compiler, see https://github.com/emscripten-core/emscripten/blob/4.0.11/package.json
# For the required closure-compiler-nodejs node version, see https://github.com/google/closure-compiler-npm/blob/v20240317.0.0/packages/google-closure-compiler/package.json
# For the required Java, See https://github.com/google/closure-compiler/blob/v20240317/.github/workflows/ci.yaml#L43
# For the required LLVM, see https://github.com/emscripten-core/emscripten/blob/4.0.11/tools/shared.py#L62
# For the required Node.js, see https://github.com/emscripten-core/emscripten/blob/4.0.11/tools/shared.py#L43
RDEPEND+="
	${PYTHON_DEPS}
	app-eselect/eselect-emscripten
	closure-compiler? (
		>=dev-util/closure-compiler-npm-20240317.0.0:${CLOSURE_COMPILER_SLOT}[closure_compiler_java?,closure_compiler_native?,closure_compiler_nodejs?]
		closure_compiler_java? (
			virtual/jre:${JAVA_SLOT}
		)
		closure_compiler_nodejs? (
			virtual/jre:${JAVA_SLOT}
		)
	)
	dev-util/binaryen:${BINARYEN_SLOT}
	>=net-libs/nodejs-18
	(
		>=llvm-core/clang-${LLVM_SLOT}:${LLVM_SLOT}=[llvm_targets_WebAssembly]
		>=llvm-core/lld-${LLVM_SLOT}:${LLVM_SLOT}
		>=llvm-core/llvm-${LLVM_SLOT}:${LLVM_SLOT}=[llvm_targets_WebAssembly]
	)
"
DEPEND+="
	${RDEPEND}
	closure-compiler? (
		closure_compiler_java? (
			virtual/jdk:${JAVA_SLOT}
		)
		closure_compiler_nodejs? (
			virtual/jdk:${JAVA_SLOT}
		)
	)
"
BDEPEND+="
	virtual/jdk:${JAVA_SLOT}
	>=dev-build/cmake-3.4.3
"
# 72dd53c - Define __LONG_MAX in alltypes.h
#   Fix for:
#  /usr/share/emscripten-3.1.51/system/lib/libc/musl/arch/emscripten/bits/alltypes.h:7:9: error: 'LONG_MAX' macro redefined [-Werror,-Wmacro-redefined]
#      7 | #define LONG_MAX  __LONG_MAX__
#        |         ^
#  /usr/share/emscripten-3.1.51/system/lib/libc/musl/include/limits.h:29:9: note: previous definition is here
#     29 | #define LONG_MAX __LONG_MAX
#        |         ^

_PATCHES=(
#	"${DISTDIR}/emscripten-commit-72dd53c.patch"
	"${FILESDIR}/${PN}-4.0.11-set-wrappers-path.patch"
	"${FILESDIR}/${PN}-4.0.11-includes.patch"
	"${FILESDIR}/${PN}-3.1.28-libcxxabi_no_exceptions-already-defined.patch"
)

pkg_setup() {
	check-compiler-switch_start
	java-pkg-opt-2_pkg_setup
	if use test ; then
		if [[ ! "${FEATURES}" =~ "test" ]] ; then
eerror
eerror "The test USE flag requires the environmental variable test to be added to"
eerror "FEATURES"
eerror
			die
		fi
	fi
	use java && java-pkg_ensure-vm-version-eq "${JAVA_SLOT}"
	python-single-r1_pkg_setup

einfo "PATH=${PATH} (before)"
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}/bin|g")
einfo "PATH=${PATH} (after)"

	export CC="${CHOST}-clang-${LLVM_SLOT}"
	export CXX="${CHOST}-clang++-${LLVM_SLOT}"
	export CPP="${CC} -E"
	strip-unsupported-flags

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

einfo "CXX:\t${CXX}"
}

src_prepare() {
	export PYTHON_EXE_ABSPATH="${PYTHON}"
	einfo "PYTHON_EXE_ABSPATH=${PYTHON_EXE_ABSPATH}"
	eapply ${_PATCHES[@]}

	#eapply -R "${FILESDIR}/emscripten-3.1.3-30e3c87.patch" # reverted - reason: Breaks 'Running sanity checks'. # \
	# emcc: error: unexpected metadata key received from wasm-emscripten-finalize: tableSize

	eapply_user
	java-pkg-opt-2_src_prepare
}

src_configure() {
	which ${CC} || die "Missing ${CC}"
}

src_compile() {
	:
}

get_compatible_node_slot() {
	local node_slot=""
	local x=""
	for x in $(eval "echo {${NODE_SLOT_MIN}..25}") ; do
		if [[ -e "/usr/lib/node/${x}/bin/node" ]] ; then
			node_slot="${x}"
			break
		fi
	done
	echo "${node_slot}"
}

get_closure_compiler_provider() {
	if use closure_compiler_java ; then
		cc_cmd="closure-compiler-java"
	elif use closure_compiler_nodejs ; then
		cc_cmd="closure-compiler-node"
	elif use closure_compiler_native ; then
		cc_cmd="closure-compiler"
	elif use closure-compiler ; then
		cc_cmd="" # use defaults
	fi
	echo "${cc_cmd}"
}

setup_test_config() {
	local node_slot=$(get_compatible_node_slot)

cat <<EOF > "${T}/emscripten-${ABI}.config"
EMSCRIPTEN_ROOT = '${S}'
LLVM_ROOT = '/usr/lib/llvm/${LLVM_SLOT}/bin'
BINARYEN_ROOT = '/usr/lib/binaryen/${BINARYEN_SLOT}'
NODE_JS = '/usr/lib/node/${node_slot}/bin/node'
JAVA = 'java'
EOF
}

setup_test_env() {
	local node_slot=$(get_compatible_node_slot)
	local cc_cmd=$(get_closure_compiler_provider)

	export BINARYEN="${ESYSROOT}/usr/lib/binaryen/${BINARYEN_SLOT}"
	export CLOSURE_COMPILER="${cc_cmd}"
	export EM_CONFIG="${T}/emscripten-${ABI}.config"
	export EMCC_WASM_BACKEND=1
	export EMSCRIPTEN="${WORKDIR}/${P}"
	export EMSCRIPTEN_NATIVE_OPTIMIZER=""
	export EMSDK_CLOSURE_COMPILER="${cc_cmd}"
	export EMSDK_LLVM_ROOT="/usr/lib/llvm/${LLVM_SLOT}"
	export EMSDK_NODE="/usr/lib/node/${node_slot}/bin/node"
	export EMSDK_PYTHON="/usr/bin/${EPYTHON}"
	export LLVM_ROOT="${EMSDK_LLVM_ROOT}"
	export PATH="${BINARYEN}/bin:${PATH}"
	export PATH="${S}:${PATH}"
}

src_test() {
	local t="wasm"
	einfo "Testing ${t}"
	setup_test_config
	setup_test_env
	local node_slot=$(get_compatible_node_slot)
	if [[ "${EMCC_WASM_BACKEND}" != "1" ]] ; then
		die "EMCC_WASM_BACKEND should be 1 with wasm"
	fi
	if use test ; then
		mkdir -p "${TEST_PATH}" || die
		"../${P}/emcc" "${FILESDIR}/hello_world.cpp" \
			-o "${TEST_PATH}/hello_world.js" || \
			die "Error during executing emcc!"
		test -f "${TEST_PATH}/hello_world.js" \
			|| die "Could not find '${TEST_PATH}/hello_world.js'"

		OUT=$("${BROOT}/usr/lib/node/${node_slot}/bin/node" "${TEST_PATH}/hello_world.js") || \
			die "Could not execute /usr/lib/node/${node_slot}/bin/node"

		EXP=$(echo -e -n 'Hello World!\n')
		if [[ "${OUT}" != "${EXP}" ]] ; then
			die "Expected '${EXP}' but got '${OUT}'!"
		fi
		rm -r "${TEST_PATH}" \
			|| die "Could not clean-up '${TEST_PATH}'"
		rm -r "${HOME}/.emscripten_cache" \
			|| die "Could not clean up \${HOME}/.emscripten_cache"
	fi
}

# For emscripten.eclass
gen_metadata() {
	local closure_compiler_exe=$(get_closure_compiler_provider)
	dodir "${INSTALL_PREFIX}/etc"

cat <<EOF > "${ED}/${INSTALL_PREFIX}/etc/slot.metadata" || die
BROWSER_MIN_VER="${BROWSERS_MIN_VER}"
BINARYEN_SLOT="${BINARYEN_SLOT}"
CLOSURE_COMPILER_EXE="${closure_compiler_exe}"
EMSCRIPTEN_EPREFIX="${EPREFIX}"
EMSCRIPTEN_PV="${PV}"
EMSCRIPTEN_SLOT="${EMSCRIPTEN_SLOT}"
LLVM_SLOT="${LLVM_SLOT}"
NODE_SLOT_MIN="${NODE_SLOT_MIN}"
PYTHON_SLOT="${EPYTHON/python}"
EOF
}

sanitize_install() {
	# See tools/install.py
	find "${S}" \
	\( \
		-path "*/test/third_party/*" \
		-o -name "site" \
		-o -name "Makefile" \
		-o -name ".git" \
		-o -name "cache" \
		-o -name "cache.lock" \
		-o -name "*.pyc" \
		-o \( \
			     -name ".*" \
			-not -name ".bin" \
		   \) \
		-o -name "__pycache__" \
	\) \
		-exec rm -vrf "{}" \;
	#	-o -name "node_modules" was included but removed for closure-compiler
}

sanitize_permissions() {
einfo "Sanitizing file/folder permissions"
	IFS=$'\n'
	local path
	for path in $(find "${ED}") ; do
		[[ -L "${path}" ]] && continue
		chown "root:root" "${path}" || die
		if file "${path}" | grep -q -e "directory" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "ELF .* shared object" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "POSIX shell script" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "Python script" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "Node.js script executable" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "WebAssembly (wasm) binary" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "symbolic link" ; then
			:
		else
			# Licenses
			chmod 0644 "${path}" || die
		fi
	done
        IFS=$' \t\n'
}

src_install() {
	dodir "${INSTALL_PREFIX}/${P}"
	sanitize_install
	cp -aT "${S}/" "${D}/${INSTALL_PREFIX}" || die "Could not install files"
	gen_metadata
	sanitize_permissions
}

pkg_postinst() {
einfo "Minimum browser version required:  ${BROWSERS_MIN_VER}"
}

# OILEDMACHINE-OVERLAY-TEST:  passed (3.1.51)
# hello world test - passed
