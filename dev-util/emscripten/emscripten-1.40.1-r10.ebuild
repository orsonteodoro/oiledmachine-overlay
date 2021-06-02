# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# For requirements, see
# https://github.com/emscripten-core/emscripten/blob/master/site/source/docs/building_from_source/toolchain_what_is_needed.rst

# For the closure-compiler-npm version see:
# https://github.com/emscripten-core/emscripten/blob/1.40.1/package.json

# Keep emscripten.config.x.yy.zz updated if changed from:
# https://github.com/emscripten-core/emscripten/blob/1.40.1/tools/settings_template.py

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake-utils flag-o-matic java-utils-2 npm-secaudit python-single-r1 \
	toolchain-funcs

DESCRIPTION="LLVM-to-JavaScript Compiler"
HOMEPAGE="http://emscripten.org/"
LICENSE="all-rights-reserved UoI-NCSA Apache-2.0 Apache-2.0-with-LLVM-exceptions \
BSD BSD-2 CC-BY-SA-3.0 \
|| ( FTL GPL-2 ) GPL-2+ LGPL-2.1 LGPL-3 MIT MPL-2.0 OFL-1.1 PSF-2.4 Unlicense \
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
)"
LICENSE_NOTES="
Third-party
  ansidecl.h - GPL-2+
  cp-demangle.h - GPL-2+
  demangle.h - GPL-2+
  emjvm - UoI-NCSA MIT
  filelock.py - Unlicense
  gcc_demangler.c - GPL-2+
  jni.h - Apache-2.0
  libiberty.h - GPL-2+
  PLY (Python Lex-Yacc) - all-rights-reserved for cpp.py, BSD for project
  stb_image.c - public domain + no warranty
  WebIDL.py - MPL-2.0
  websockify LGPL-3 MPL-2 BSD BSD-2 MIT
    websockify/include/VT100.js LGPL-2.1

Tools
  acorn - MIT
  terser - BSD-2
  source-map - BSD

Tests
  all-rights-reserved || (MIT UoI-NCSA)
  box2d - ZLIB
    freeglut - MIT LGPL-2
  bullet - ZLIB GPL-2
  closure-compiler/node-externs Apache-2.0
  enet - MIT
  freealut - LGPL-2
    files under src is UoI-NCSA MIT
  freetype - || (FTL GPL-2) MIT ZLIB
    LiberationSansBold - OFL-1.1
  openjpeg - BSD-2
  tests/python - PSF-2.4
  tests/sounds - cc-by-sa-3.0
  poppler - GPL-2
  poppler/cmake - BSD

Package
  Package - UoI-NCSA MIT
    all-rights-reserved (in source) even with MIT license
  compiler-rt - Apache-2.0-with-LLVM-exceptions MIT UoI-NCSA
  sdl - ZLIB
  musl - all-rights-reserved MIT
  libcxx, libcxxabi, libunwind - MIT UoI-NCSA "
KEYWORDS="~amd64 ~x86"
SLOT_MAJOR=$(ver_cut 1-2 ${PV})
SLOT="${SLOT_MAJOR}/${PV}"
CLOSURE_COMPILER_SLOT="0"
IUSE+=" asmjs +closure-compiler closure_compiler_java closure_compiler_native
closure_compiler_nodejs +native-optimizer system-closure-compiler test +wasm"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}
	|| ( asmjs wasm )
	closure_compiler_java? ( closure-compiler )
	closure_compiler_native? ( closure-compiler )
	closure_compiler_nodejs? ( closure-compiler )
	system-closure-compiler? (
		closure-compiler
		^^ ( closure_compiler_java closure_compiler_native \
			closure_compiler_nodejs )
	)"
# See also .circleci/config.yml
# See also tools/shared.py EXPECTED_BINARYEN_VERSION
JAVA_V="1.8"
# See https://github.com/google/closure-compiler-npm/blob/v20200224.0.0/packages/google-closure-compiler/package.json
# They use the latest commit for llvm and clang
# For the required LLVM, see https://github.com/emscripten-core/emscripten/blob/1.40.1/tools/shared.py#L432
# For the required nodejs, see https://github.com/emscripten-core/emscripten/blob/1.40.1/tools/shared.py#L43
LLVM_V="12.0.0"
BINARYEN_V="94"
RDEPEND+=" ${PYTHON_DEPS}
	app-eselect/eselect-emscripten
	asmjs? ( ~dev-util/emscripten-fastcomp-${PV}:= )
	closure-compiler? (
		system-closure-compiler? ( \
			>=dev-util/closure-compiler-npm-20200224:\
${CLOSURE_COMPILER_SLOT}\
[closure_compiler_java?,closure_compiler_native?,closure_compiler_nodejs?] )
		closure_compiler_java? (
			>=virtual/jre-${JAVA_V}
		)
		closure_compiler_nodejs? (
			>=virtual/jre-${JAVA_V}
		)
		!system-closure-compiler? (
			>=virtual/jre-${JAVA_V}
			>=net-libs/nodejs-8
		)
	)
	dev-util/binaryen:${BINARYEN_V}
	>=net-libs/nodejs-4.1.1
	wasm? (
		>=sys-devel/lld-${LLVM_V}
		>=sys-devel/llvm-${LLVM_V}:=[llvm_targets_WebAssembly]
		>=sys-devel/clang-${LLVM_V}:=[llvm_targets_WebAssembly]
	)"
# The java-utils-2 doesn't like nested conditionals.  The eclass needs at least
# a virtual/jdk.  This package doesn't really need jdk to use closure-compiler
# because packages are prebuilt.  If we have closure_compiler_native, we don't
# need Java.
DEPEND+=" ${RDEPEND}
	closure-compiler? (
		closure_compiler_java? (
			>=virtual/jre-${JAVA_V}
		)
		closure_compiler_nodejs? (
			>=virtual/jre-${JAVA_V}
		)
		!system-closure-compiler? (
			>=virtual/jre-${JAVA_V}
		)
	)
	>=virtual/jdk-${JAVA_V}"
FN_DEST="${P}.tar.gz"
SRC_URI="https://github.com/kripken/${PN}/archive/${PV}.tar.gz -> ${FN_DEST}"
RESTRICT="fetch mirror"
DEST="/usr/share/"
TEST="${WORKDIR}/test/"
DOWNLOAD_SITE="https://github.com/emscripten-core/emscripten/releases"
FN_SRC="${PV}.tar.gz"
_PATCHES=(
	"${FILESDIR}/emscripten-1.39.20-set-wrappers-path.patch"
	"${FILESDIR}/emscripten-1.39.6-gentoo-wasm-ld-path.patch"
)
CMAKE_BUILD_TYPE=Release

pkg_nofetch() {
	# No fetch on all-rights-reserved
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	einfo \
"Please download\n\
  ${FN_SRC}\n\
from ${DOWNLOAD_SITE}\n\
and rename it to ${FN_DEST} place it in ${distdir} .\n\
\n\
If you are in a hurry, you can do \`wget -O ${distdir}/${FN_DEST} \
https://github.com/emscripten-core/emscripten/archive/${FN_SRC}\`"
}

pkg_setup() {
	if use closure-compiler ; then
		if ! use closure_compiler_native ; then
			java-pkg_init
			if [[ -n "${JAVA_HOME}" \
				&& -f "${JAVA_HOME}/bin/java" ]] ; then
				export JAVA="${JAVA_HOME}/bin/java"
			elif [[ -z "${JAVA_HOME}" ]] ; then
				die \
"JAVA_HOME is not set.  Use \`eselect java-vm\` to set this up."
			else
				die \
"JAVA_HOME is set to ${JAVA_HOME} but cannot locate ${JAVA_HOME}/bin/java.\n\
Use \`eselect java-vm\` to set this up."
			fi
			java-pkg_ensure-vm-version-ge ${JAVA_V}
		fi
		if ! use system-closure-compiler ; then
			npm-secaudit_pkg_setup
		fi
	fi
	if use test ; then
		if [[ ! "${FEATURES}" =~ test ]] ; then
			die \
"The test USE flag requires the environmental variable test to be added to\n\
FEATURES"
		fi
	fi
	python-single-r1_pkg_setup
	if use wasm ; then
		export HIGHEST_LLVM_SLOT=$(basename $(find "${EROOT}/usr/lib/llvm" -maxdepth 1 \
			-regextype 'posix-extended' -regex ".*[0-9]+.*" \
			| sort -V | tail -n 1))
		for llvm_slot in $(seq $(ver_cut 1 ${LLVM_V}) ${HIGHEST_LLVM_SLOT}) ; do
			if has_version "sys-devel/clang:${llvm_slot}[llvm_targets_WebAssembly]" \
			&& has_version "sys-devel/llvm:${llvm_slot}[llvm_targets_WebAssembly]" ; then
				export LLVM_SLOT="${llvm_slot}"
				CXX="${EROOT}/usr/lib/llvm/${llvm_slot}/bin/clang++"
				einfo "CXX=${CXX}"
				if [[ ! -f "${CXX}" ]] ; then
					die "CXX path is wrong and doesn't exist"
				fi
				lld_slot=$(ver_cut 1 $(wasm-ld --version \
						| sed -e "s|LLD ||"))
# The lld slotting is broken.  See https://bugs.gentoo.org/691900
# ldd lld shows that libLLVM-10.so => /usr/lib64/llvm/10/lib64/libLLVM-10.so but
# but slot 10 doesn't have wasm and one of the other >=${LLVM_V} do have it and
# tricking the RDEPENDs.  We need to make sure that =lld-${lld_slot}*
# with =llvm-${lld_slot}*[llvm_targets_WebAssembly].
				if ! has_version "sys-devel/clang:${lld_slot}[llvm_targets_WebAssembly]" \
				|| ! has_version "sys-devel/llvm:${lld_slot}[llvm_targets_WebAssembly]" ; then
					die \
"lld's corresponding version to clang and llvm versions must have\n\
llvm_targets_WebAssembly.  Either upgrade lld to version ${LLVM_SLOT} or\n\
rebuild with llvm:${lld_slot}[llvm_targets_WebAssembly] and\n\
clang:${lld_slot}[llvm_targets_WebAssembly]"
				fi
				break
			fi
		done
	else
		if [[ ! -f /usr/share/emscripten-fastcomp-${PV}/bin/llc ]] ; then
			die \
"You need to install ~dev-util/emscripten-fastcomp-${PV}.  Only revision\n\
updates acceptable."
		fi
	fi
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
	cp "${FILESDIR}/${source_filename}" "${dest_dir}/" || die "could not copy '${source_filename}'"
	sed -i -e "s/\${PV}/${PV}/g" "${dest_dir}/${source_filename}" || \
		die "could not adjust path for '${source_filename}'"
	sed -i -e "s|\${PYTHON_EXE_ABSPATH}|${PYTHON_EXE_ABSPATH}|g" \
		"${dest_dir}/${source_filename}" || die
	if [[ "${type}" == "asmjs" ]] ; then
		sed -i -e \
"s|__EMSDK_LLVM_ROOT__|/usr/share/emscripten-fastcomp-${PV}/bin|" \
		-e \
"s|__EMCC_WASM_BACKEND__|0|" \
		-e \
"s|__LLVM_BIN_PATH__|/usr/share/emscripten-fastcomp-${PV}/bin|" \
		-e \
"s|\$(get_libdir)|$(get_libdir)|" \
		-e \
"s|\${BINARYEN_SLOT}|${BINARYEN_V}|" \
		"${dest_dir}/${source_filename}" || die
	elif [[ "${type}" == "wasm" ]] ; then
		sed -i -e \
"s|__EMSDK_LLVM_ROOT__|/usr/lib/llvm/${LLVM_SLOT}/bin|" \
		-e \
"s|__EMCC_WASM_BACKEND__|1|" \
		-e \
"s|__LLVM_BIN_PATH__|/usr/lib/llvm/${LLVM_SLOT}/bin|" \
		-e \
"s|\$(get_libdir)|$(get_libdir)|" \
		-e \
"s|\${BINARYEN_SLOT}|${BINARYEN_V}|" \
		"${dest_dir}/${source_filename}" || die
	fi
	if ! use native-optimizer || [[ "${type}" == "wasm" ]] ; then
		sed -i "/EMSCRIPTEN_NATIVE_OPTIMIZER/d" \
			"${dest_dir}/${source_filename}" || die
	fi
	if use closure-compiler ; then
		if use system-closure-compiler ; then
			local cmd
			if use closure_compiler_java ; then
				cmd=\
"/usr/bin/closure-compiler-java"
			elif use closure_compiler_nodejs ; then
				cmd=\
"/usr/bin/closure-compiler-node"
			elif use closure_compiler_native ; then
				cmd=\
"/usr/bin/closure-compiler"
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
	eapply_user
	S="${S}/tools/optimizer" \
	cmake-utils_src_prepare
}

src_configure() {
	S="${S}/tools/optimizer" \
	cmake-utils_src_configure
}

src_compile() {
	if use native-optimizer ; then
		cd "tools/optimizer" || die
		S="${S}/tools/optimizer" \
		cmake-utils_src_compile
	fi
}

npm-secaudit_src_compile() {
	# no need to build
	:;
}

gen_files() {
	local config_v="1.39.20"
	mkdir "${TEST}" || die "Could not create test directory!"
	prepare_file "${t}" "${TEST}" "99emscripten"
	prepare_file "${t}" "${TEST}" "emscripten.config.${config_v}"
	mv "${TEST}/emscripten.config"{.${config_v},} || die
	source "${TEST}/99emscripten"
}

src_test() {
	for t in asmjs wasm ; do
		local enable_test=0
		if [[ "${t}" == "wasm" ]] ; then
			if use wasm ; then
				einfo "Testing ${t}"
				gen_files "${t}"
				if [[ "${EMCC_WASM_BACKEND}" != "1" ]] ; then
					die "EMCC_WASM_BACKEND should be 1 with wasm"
				fi
				enable_test=1
			fi
		fi
		if [[ "${t}" == "asmjs" ]]  ; then
			if use asmjs ; then
				einfo "Testing ${t}"
				gen_files "${t}"
				if [[ "${EMCC_WASM_BACKEND}" != "0" ]] ; then
					die "EMCC_WASM_BACKEND should be 0 with asmjs"
				fi
				enable_test=1
			fi
		fi
		if [[ "${enable_test}" == "1" ]] && use test ; then
			cp "${FILESDIR}/hello_world.cpp" "${TEST}" \
				|| die "Could not copy example file"
			sed -i -e "/^EMSCRIPTEN_ROOT/s|/usr/share/|${S}|" \
				"${TEST}/emscripten.config" \
				|| die "Could not adjust path for testing"
			export EM_CONFIG="${TEST}/emscripten.config" \
				|| die "Could not export variable"
			local cc_cmd
			if use closure_compiler_java ; then
				cc_cmd="${EROOT}/usr/bin/closure-compiler-java"
			elif use closure_compiler_nodejs ; then
				cc_cmd="${EROOT}/usr/bin/closure-compiler-node"
			elif use closure_compiler_native ; then
				cc_cmd="${EROOT}/usr/bin/closure-compiler"
			elif use closure-compiler ; then
				cc_cmd="" # use defaults
			fi
			CLOSURE_COMPILER="${cc_cmd}" \
			LLVM_ROOT="${EMSDK_LLVM_ROOT}" \
			../"${P}/emcc" "${TEST}/hello_world.cpp" \
				-o "${TEST}/hello_world.js" || \
				die "Error during executing emcc!"
			test -f "${TEST}/hello_world.js" \
				|| die "Could not find '${TEST}/hello_world.js'"
			OUT=$(/usr/bin/node "${TEST}/hello_world.js") || \
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
	done
}

src_install() {
	if use native-optimizer ; then
		exeinto "${DEST}/${P}"
		doexe "${BUILD_DIR}/optimizer"
	fi
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
	if use wasm ; then
		eselect emscripten set "emscripten-${PV} llvm-${LLVM_SLOT}"
	elif use asmjs ; then
		eselect emscripten set "emscripten-${PV} emscripten-fastcomp-${PV}"
	fi
	if use closure-compiler && ! use system-closure-compiler ; then
		export NPM_SECAUDIT_INSTALL_PATH="${DEST}/${P}"
		npm-secaudit_pkg_postinst
	fi
	einfo \
"\n\
Set to wasm (llvm) or asm.js (emscripten-fastcomp) output via\n\
app-eselect/eselect-emscripten.
\n"
}
