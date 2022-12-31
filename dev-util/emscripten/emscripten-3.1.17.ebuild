# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# For requirements, see
# https://github.com/emscripten-core/emscripten/blob/3.1.17/site/source/docs/building_from_source/toolchain_what_is_needed.rst

# For the closure-compiler-npm version see:
# https://github.com/emscripten-core/emscripten/blob/3.1.17/package.json

# Keep emscripten.config.x.yy.zz updated if changed from:
# https://github.com/emscripten-core/emscripten/blob/3.1.17/tools/config_template.py

LLVM_PV=15
LLVM_MAX_SLOT=${LLVM_PV}
PYTHON_COMPAT=( python3_{8..11} )
inherit flag-o-matic java-utils-2 llvm npm-secaudit python-single-r1 \
	toolchain-funcs

DESCRIPTION="LLVM-to-JavaScript Compiler"
HOMEPAGE="http://emscripten.org/"
LICENSE="
	( all-rights-reserved || ( MIT UoI-NCSA ) )
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
	( MIT all-rights-reserved )
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
KEYWORDS="~amd64 ~arm64 ~x86" # See tests/clang_native.py for supported arches
SLOT="${LLVM_PV}/${PV}"
CLOSURE_COMPILER_SLOT="0"
IUSE+=" -closure-compiler closure_compiler_java closure_compiler_native
closure_compiler_nodejs system-closure-compiler test"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	closure_compiler_java? ( closure-compiler )
	closure_compiler_native? ( closure-compiler )
	closure_compiler_nodejs? ( closure-compiler )
	system-closure-compiler? (
		closure-compiler
		^^ ( closure_compiler_java closure_compiler_native
			closure_compiler_nodejs )
	)
"
# See also .circleci/config.yml
# See also https://github.com/emscripten-core/emscripten/blob/3.1.17/tools/building.py#L41 EXPECTED_BINARYEN_VERSION
JAVA_PV="11" # See https://github.com/google/closure-compiler/blob/v20220502/.github/workflows/ci.yaml#L43
# See https://github.com/google/closure-compiler-npm/blob/v20220502.0.0/packages/google-closure-compiler/package.json
# They use the latest commit for llvm and clang
# For the required closure-compiler, see https://github.com/emscripten-core/emscripten/blob/3.1.17/package.json
# For the required LLVM, see https://github.com/emscripten-core/emscripten/blob/3.1.17/tools/shared.py#L50
# For the required Node.js, see https://github.com/emscripten-core/emscripten/blob/3.1.17/tools/shared.py#L43
BINARYEN_PV="109"
JDK_DEPEND="
	|| (
		dev-java/openjdk-bin:${JAVA_PV}
		dev-java/openjdk:${JAVA_PV}
	)
"
JRE_DEPEND="
	|| (
		${JDK_DEPEND}
		dev-java/openjdk-jre-bin:${JAVA_PV}
	)
"
#JDK_DEPEND="virtual/jdk:${JAVA_PV}"
#JRE_DEPEND=">=virtual/jre-${JAVA_PV}"
RDEPEND+="
	${PYTHON_DEPS}
	app-eselect/eselect-emscripten
	closure-compiler? (
		!system-closure-compiler? (
			${JRE_DEPEND}
			>=net-libs/nodejs-10
		)
		system-closure-compiler? (
			>=dev-util/closure-compiler-npm-20220502.0.0:\
${CLOSURE_COMPILER_SLOT}\
[closure_compiler_java?,closure_compiler_native?,closure_compiler_nodejs?]
		)
		closure_compiler_java? (
			${JRE_DEPEND}
		)
		closure_compiler_nodejs? (
			${JRE_DEPEND}
		)
	)
	dev-util/binaryen:${BINARYEN_PV}
	>=net-libs/nodejs-4.1.1
	(
		>=sys-devel/clang-${LLVM_PV}:${LLVM_PV}=[llvm_targets_WebAssembly]
		>=sys-devel/lld-${LLVM_PV}:${LLVM_PV}
		>=sys-devel/llvm-${LLVM_PV}:${LLVM_PV}=[llvm_targets_WebAssembly]
	)
"
DEPEND+="
	${RDEPEND}
	closure-compiler? (
		!system-closure-compiler? (
			${JRE_DEPEND}
		)
		closure_compiler_java? (
			${JRE_DEPEND}
		)
		closure_compiler_nodejs? (
			${JRE_DEPEND}
		)
	)
"
BDEPEND+="
	${JDK_DEPEND}
	>=dev-util/cmake-3.4.3
"
FN_DEST="${P}.tar.gz"
SRC_URI="https://github.com/kripken/${PN}/archive/${PV}.tar.gz -> ${FN_DEST}"
RESTRICT="fetch mirror"
DEST="/usr/share/"
TEST="${WORKDIR}/test/"
DOWNLOAD_SITE="https://github.com/emscripten-core/emscripten/releases"
FN_SRC="${PV}.tar.gz"
_PATCHES=(
	"${FILESDIR}/emscripten-3.1.14-set-wrappers-path.patch"
	"${FILESDIR}/emscripten-3.1.28-includes.patch"
	"${FILESDIR}/emscripten-3.1.28-libcxxabi_no_exceptions-already-defined.patch"
)
EMSCRIPTEN_CONFIG_V="2.0.26"

pkg_nofetch() {
	# No fetch on all-rights-reserved
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	local dl_uri="https://github.com/emscripten-core/emscripten/archive/${FN_SRC}"
eerror
eerror "Please download"
eerror
eerror "  ${FN_SRC}"
eerror
eerror "from ${DOWNLOAD_SITE} and rename it to ${FN_DEST} place it in"
eerror "${distdir}."
eerror
eerror "If you are in a hurry, you can do"
eerror
eerror "  wget -O ${distdir}/${FN_DEST} ${dl_uri}"
eerror
}

setup_openjdk() {
	local jdk_bin_basepath
	local jdk_basepath

	if find \
		/usr/$(get_libdir)/openjdk-${JAVA_PV}*/ \
		-maxdepth 1 \
		-type d \
		2>/dev/null 1>/dev/null
	then
		export JAVA_HOME=$(find \
				/usr/$(get_libdir)/openjdk-${JAVA_PV}*/ \
				-maxdepth 1 \
				-type d \
			| sort -V \
			| head -n 1)
		export PATH="${JAVA_HOME}/bin:${PATH}"
	elif find \
		/opt/openjdk-bin-${JAVA_PV}*/ \
		-maxdepth 1 \
		-type d \
		2>/dev/null 1>/dev/null
	then
		export JAVA_HOME=$(find \
				/opt/openjdk-bin-${JAVA_PV}*/ \
				-maxdepth 1 \
				-type d \
			| sort -V \
			| head -n 1)
		export PATH="${JAVA_HOME}/bin:${PATH}"
	else
eerror
eerror "dev-java/openjdk:${JDK_V} or dev-java/openjdk-bin:${JDK_V} is required"
eerror "to be installed"
eerror
		die
	fi
}

pkg_setup() {
	if use closure-compiler ; then
		if ! use closure_compiler_native ; then
			setup_openjdk
			einfo "JAVA_HOME=${JAVA_HOME}"
			einfo "PATH=${PATH}"

			# java-pkg_init # unsets JAVA_HOME

			if [[ -n "${JAVA_HOME}" \
				&& -e "${JAVA_HOME}/bin/java" ]] ; then
				export JAVA="${JAVA_HOME}/bin/java"
			elif [[ -z "${JAVA_HOME}" ]] ; then
eerror
eerror "JAVA_HOME is not set.  Use \`eselect java-vm\` to set this up."
eerror
				die
			else
eerror
eerror "JAVA_HOME is set to ${JAVA_HOME} but cannot locate ${JAVA_HOME}/bin/java."
eerror
				die
			fi
			# java-pkg_ensure-vm-version-ge ${JAVA_PV}
		fi
		if ! use system-closure-compiler ; then
			npm-secaudit_pkg_setup
		fi
	fi
	if use test ; then
		if [[ ! "${FEATURES}" =~ test ]] ; then
eerror
eerror "The test USE flag requires the environmental variable test to be added to"
eerror "FEATURES"
eerror
			die
		fi
	fi
	python-single-r1_pkg_setup
	llvm_pkg_setup
	export CXX="clang++-${LLVM_PV}"
	einfo "CXX=${CXX}"
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
	sed -i -e "s|__EMSDK_LLVM_ROOT__|${EPREFIX}/usr/lib/llvm/${LLVM_PV}/bin|" \
		-e "s|__EMCC_WASM_BACKEND__|1|" \
		-e "s|__LLVM_BIN_PATH__|${EPREFIX}/usr/lib/llvm/${LLVM_PV}/bin|" \
		-e "s|\$(get_libdir)|$(get_libdir)|" \
		-e "s|\${BINARYEN_SLOT}|${BINARYEN_PV}|" \
		"${dest_dir}/${source_filename}" || die
	sed -i "/EMSCRIPTEN_NATIVE_OPTIMIZER/d" \
		"${dest_dir}/${source_filename}" || die
	sed -i "s|\${EPREFIX}|${EPREFIX}|g" \
		"${dest_dir}/${source_filename}" || die
	if use closure-compiler ; then
		if use system-closure-compiler ; then
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
			# Using defaults
			sed -i -e "/EMSDK_CLOSURE_COMPILER/d" \
				"${dest_dir}/${source_filename}" || die
		fi
	else
		sed -i "/EMSDK_CLOSURE_COMPILER/d" \
			"${dest_dir}/${source_filename}" || die
	fi
}

src_unpack() {
	unpack ${A}
	if use closure-compiler && ! use system-closure-compiler ; then
		# Fetches and builds the closure compiler here.
		npm-secaudit_src_unpack
	fi
}

src_prepare() {
	export PYTHON_EXE_ABSPATH=$(which ${PYTHON})
	einfo "PYTHON_EXE_ABSPATH=${PYTHON_EXE_ABSPATH}"
	eapply ${_PATCHES[@]}

	#eapply -R "${FILESDIR}/emscripten-3.1.3-30e3c87.patch" # reverted - reason: Breaks 'Running sanity checks'. # \
	# emcc: error: unexpected metadata key received from wasm-emscripten-finalize: tableSize

	eapply_user
}

src_configure() {
	:;
}

src_compile() {
	:;
}

npm-secaudit_src_compile() {
	# no need to build
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
		BINARYEN="${BROOT}/usr/$(get_libdir)/binaryen/${BINARYEN_PV}" \
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
}

pkg_postinst() {
	eselect emscripten set "emscripten-${PV} llvm-${LLVM_PV}"
	if use closure-compiler && ! use system-closure-compiler ; then
		export NPM_SECAUDIT_INSTALL_PATH="${DEST}/${P}"
		npm-secaudit_pkg_postinst
	fi
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
