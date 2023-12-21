# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Keep emscripten.config.x.yy.zz updated if changed from:
# https://github.com/emscripten-core/emscripten/blob/1.39.20/tools/settings_template.py

# TC = toolchain
BINARYEN_SLOT=93 # Consider using Binaryen as part of SLOT_MAJOR for ABI/TC compatibility.
JAVA_SLOT=1.8
LLVM_SLOT=14 # Upstream requires 12 for wasm and 6 for asmjs.
LLVM_MAX_SLOT=${LLVM_SLOT}
NODEJS_SLOT="4"
PYTHON_COMPAT=( python3_{8..11} ) # emsdk lists 3.
# See also
# https://github.com/emscripten-core/emsdk/blob/1.39.20/emsdk#L11
# https://github.com/emscripten-core/emsdk/blob/1.39.20/.circleci/config.yml#L24
# https://github.com/emscripten-core/emscripten/blob/1.39.20/third_party/websockify/setup.py
# flake8 (3.7.8) - <= 3.7
# websockify (0.8.0) - <= 3.4

inherit flag-o-matic java-pkg-opt-2 llvm python-single-r1 toolchain-funcs

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
KEYWORDS="~amd64 ~x86"
SLOT="${LLVM_SLOT}-$(ver_cut 1-2 ${PV})"
CLOSURE_COMPILER_SLOT="0"
IUSE+="
-closure-compiler closure_compiler_java closure_compiler_native
closure_compiler_nodejs java test

r32
"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
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
# See also https://github.com/emscripten-core/emscripten/blob/1.39.20/site/source/docs/building_from_source/toolchain_what_is_needed.rst
# For the required Binaryen, see also https://github.com/emscripten-core/emscripten/blob/1.39.20/tools/building.py#L41 EXPECTED_BINARYEN_VERSION
# For the required closure-compiler, see https://github.com/emscripten-core/emscripten/blob/1.39.20/package.json
# For the required closure-compiler-nodejs node version, see https://github.com/google/closure-compiler-npm/blob/v20200224.0.0/packages/google-closure-compiler/package.json
# For the required Java, See https://github.com/google/closure-compiler/blob/v20200224/.travis.yml#L7
# For the required LLVM, see https://github.com/emscripten-core/emscripten/blob/1.39.20/tools/shared.py#L431
# For the required Node.js, see https://github.com/emscripten-core/emscripten/blob/1.39.20/tools/shared.py#L43
RDEPEND+="
	${PYTHON_DEPS}
	app-eselect/eselect-emscripten
	closure-compiler? (
		>=dev-util/closure-compiler-npm-20200224.0.0:\
${CLOSURE_COMPILER_SLOT}\
[closure_compiler_java?,closure_compiler_native?,closure_compiler_nodejs?]
		closure_compiler_java? (
			virtual/jre:${JAVA_SLOT}
		)
		closure_compiler_nodejs? (
			virtual/jre:${JAVA_SLOT}
		)
	)
	dev-util/binaryen:${BINARYEN_SLOT}
	>=net-libs/nodejs-4.1.1
	(
		>=sys-devel/clang-${LLVM_SLOT}:${LLVM_SLOT}=[llvm_targets_WebAssembly]
		>=sys-devel/lld-${LLVM_SLOT}:${LLVM_SLOT}
		>=sys-devel/llvm-${LLVM_SLOT}:${LLVM_SLOT}=[llvm_targets_WebAssembly]
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
	>=dev-util/cmake-3.4.3
"
FN_DEST="${P}.tar.gz"
SRC_URI="https://github.com/kripken/${PN}/archive/${PV}.tar.gz -> ${FN_DEST}"
RESTRICT="mirror"
DEST="/usr/share/"
TEST="${WORKDIR}/test/"
_PATCHES=(
	"${FILESDIR}/${PN}-1.39.20-set-wrappers-path.patch"
	"${FILESDIR}/${PN}-1.40.1-78a5618.patch"
)
EMSCRIPTEN_CONFIG_V="2.0.26"

pkg_setup() {
	java-pkg-opt-2_pkg_setup
	if use test ; then
		if [[ ! "${FEATURES}" =~ test ]] ; then
eerror
eerror "The test USE flag requires the environmental variable test to be added to"
eerror "FEATURES"
eerror
			die
		fi
	fi
	use java && java-pkg_ensure-vm-version-eq ${JAVA_SLOT}
	python-single-r1_pkg_setup
	llvm_pkg_setup
	export CXX="${CHOST}-clang++-${LLVM_SLOT}"
	strip-unsupported-flags
einfo "CXX:\t${CXX}"
}

# The activated_cfg goes in emscripten.config from the json file.
# The activated_env goes in 99emscripten from the json file.
# https://github.com/emscripten-core/emsdk/blob/1.39.20/emsdk_manifest.json
# For examples of environmental variables and paths used in this package, see
# https://github.com/emscripten-core/emsdk/issues/167#issuecomment-414935332
prepare_file() {
	local type="${1}"
	local dest_dir="${2}"
	local source_filename="${3}"
	cp "${FILESDIR}/${source_filename}" "${dest_dir}/" \
		|| die "could not copy '${source_filename}'"
	sed -i -e "s/\${PV}/${PV}/g" "${dest_dir}/${source_filename}" || \
		die "could not adjust path for '${source_filename}'"
	sed -i -e "s|\${PYTHON_EXE_ABSPATH}|${PYTHON_EXE_ABSPATH}|g" \
		"${dest_dir}/${source_filename}" || die
	sed -i -e "s|__EMSDK_LLVM_ROOT__|${EPREFIX}/usr/lib/llvm/${LLVM_SLOT}/bin|" \
		-e "s|__EMCC_WASM_BACKEND__|1|" \
		-e "s|__LLVM_BIN_PATH__|${EPREFIX}/usr/lib/llvm/${LLVM_SLOT}/bin|" \
		-e "s|\$(get_libdir)|$(get_libdir)|" \
		-e "s|\${BINARYEN_SLOT}|${BINARYEN_SLOT}|" \
		"${dest_dir}/${source_filename}" || die
	sed -i "/EMSCRIPTEN_NATIVE_OPTIMIZER/d" \
		"${dest_dir}/${source_filename}" || die
	sed -i "s|\${EPREFIX}|${EPREFIX}|g" \
		"${dest_dir}/${source_filename}" || die
	if use closure-compiler ; then
		local cmd
		if use closure_compiler_java ; then
			cmd="${EPREFIX}/usr/bin/closure-compiler-java"
		elif use closure_compiler_nodejs ; then
			cmd="${EPREFIX}/usr/bin/closure-compiler-node"
		elif use closure_compiler_native ; then
			cmd="${EPREFIX}/usr/bin/closure-compiler"
		fi
		sed -i -e "s|__EMSDK_CLOSURE_COMPILER__|\"${cmd}\"|" \
			"${dest_dir}/${source_filename}" || die
	else
		sed -i "/EMSDK_CLOSURE_COMPILER/d" \
			"${dest_dir}/${source_filename}" || die
	fi
}

src_prepare() {
	export PYTHON_EXE_ABSPATH=$(which ${PYTHON})
	einfo "PYTHON_EXE_ABSPATH=${PYTHON_EXE_ABSPATH}"
	eapply ${_PATCHES[@]}
	eapply_user
	java-pkg-opt-2_src_prepare
}

src_configure() {
	:;
}

src_compile() {
	:;
}

gen_files() {
	mkdir "${TEST}" || die "Could not create test directory!"
	prepare_file "${t}" "${TEST}" "99emscripten"
	prepare_file "${t}" "${TEST}" "emscripten.config.${EMSCRIPTEN_CONFIG_V}"
	mv "${TEST}/emscripten.config"{.${EMSCRIPTEN_CONFIG_V},} || die
	source "${TEST}/99emscripten"
}

src_test() {
	local t="wasm"
	einfo "Testing ${t}"
	gen_files "${t}"
	if [[ "${EMCC_WASM_BACKEND}" != "1" ]] ; then
		die "EMCC_WASM_BACKEND should be 1 with wasm"
	fi
	if use test ; then
		cp "${FILESDIR}/hello_world.cpp" "${TEST}" \
			|| die "Could not copy example file"
		sed -i -e "/^EMSCRIPTEN_ROOT/s|/usr/share/|${S}|" \
			"${TEST}/emscripten.config" \
			|| die "Could not adjust path for testing"
		export EM_CONFIG="${TEST}/emscripten.config" \
			|| die "Could not export variable"
		local cc_cmd
		if use closure_compiler_java ; then
			cc_cmd="${BROOT}/usr/bin/closure-compiler-java"
		elif use closure_compiler_nodejs ; then
			cc_cmd="${BROOT}/usr/bin/closure-compiler-node"
		elif use closure_compiler_native ; then
			cc_cmd="${BROOT}/usr/bin/closure-compiler"
		elif use closure-compiler ; then
			cc_cmd="" # use defaults
		fi
		BINARYEN="${BROOT}/usr/$(get_libdir)/binaryen/${BINARYEN_SLOT}" \
		CLOSURE_COMPILER="${cc_cmd}" \
		LLVM_ROOT="${EMSDK_LLVM_ROOT}" \
		../"${P}/emcc" "${TEST}/hello_world.cpp" \
			-o "${TEST}/hello_world.js" || \
			die "Error during executing emcc!"
		test -f "${TEST}/hello_world.js" \
			|| die "Could not find '${TEST}/hello_world.js'"
		OUT=$("${BROOT}/usr/bin/node" "${TEST}/hello_world.js") || \
			die "Could not execute /usr/bin/node"
		EXP=$(echo -e -n 'Hello World!\n') \
			|| die "Could not create expected string"
		if [ "${OUT}" != "${EXP}" ]; then
			die "Expected '${EXP}' but got '${OUT}'!"
		fi
		rm -r "${TEST}" || die "Could not clean-up '${TEST}'"
		rm -r "${HOME}/.emscripten_cache" \
			|| die "Could not clean up \${HOME}/.emscripten_cache"
	fi
}

# For eselect-emscripten
gen_metadata() {
cat <<EOF > "${ED}/${DEST}/${P}/eselect.metadata" || die
PV=${PV}
BINARYEN_SLOT=${BINARYEN_SLOT}
LLVM_SLOT=${LLVM_SLOT}
NODE_SLOT=${NODEJS_SLOT}
PYTHON_SLOT=${EPYTHON/python}
EOF
}

src_install() {
	dodir "${DEST}/${P}"
	# See tools/install.py
	find "${S}" \
	\( \
		-path "*/tests/third_party/*" \
		-o -name "site" \
		-o -name "Makefile" \
		-o -name ".git" \
		-o -name "cache" \
		-o -name "cache.lock" \
		-o -name "*.pyc" \
		-o \( -name ".*" -not -name ".bin" \) \
		-o -name "__pycache__" \
	\) \
		-exec rm -vrf "{}" \;
	#	-o -name "node_modules" was included but removed for closure-compiler
	cp -R "${S}/" "${D}/${DEST}" || die "Could not install files"
	gen_metadata
}

pkg_postinst() {
	eselect emscripten set "emscripten-${PV},llvm-${LLVM_SLOT}"
einfo
einfo "You must manually do:"
einfo
einfo "  eselect emscripten set \"emscripten-${PV},llvm-${LLVM_SLOT}\""
einfo
einfo
einfo "Set to wasm (llvm) output via app-eselect/eselect-emscripten."
einfo
	if use closure_compiler_java ; then
ewarn
ewarn "You must manually setup the JAVA_HOME, and PATH when using"
ewarn "closure-compiler for Java."
ewarn
	fi
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED (in production use) 1.39.20 (20230520)
# hello world - passed
# game engine - passed
