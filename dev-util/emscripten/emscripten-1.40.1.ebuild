# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# For requirements, see
# https://github.com/emscripten-core/emscripten/blob/master/site/source/docs/building_from_source/toolchain_what_is_needed.rst

EAPI=7
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
)
"
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
  libcxx, libcxxabi, libunwind - MIT UoI-NCSA
"
KEYWORDS="~amd64 ~x86"
SLOT="$(ver_cut 1)/${PV}"
CLOSURE_COMPILER_SLOT="0"
PYTHON_COMPAT=( python3_{6,7,8} )
inherit cmake-utils flag-o-matic java-utils-2 npm-secaudit python-single-r1 toolchain-funcs
IUSE="+closure-compiler closure_compiler_java closure_compiler_native \
closure_compiler_nodejs emscripten-fastcomp +native-optimizer \
system-closure-compiler +system-llvm test
"
# See also .circleci/config.yml
# See also tools/shared.py EXPECTED_BINARYEN_VERSION
JAVA_V="1.8"
# See https://github.com/google/closure-compiler-npm/blob/v20200224.0.0/packages/google-closure-compiler/package.json
# They use the latest commit for llvm and clang
RDEPEND="${PYTHON_DEPS}
	app-eselect/eselect-emscripten
	closure-compiler? (
		system-closure-compiler? ( \
>=dev-util/closure-compiler-npm-20200224:${CLOSURE_COMPILER_SLOT}[closure_compiler_java?,closure_compiler_native?,closure_compiler_nodejs?] )
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
	>=dev-util/binaryen-94
	emscripten-fastcomp? ( ~dev-util/emscripten-fastcomp-${PV}:= )
	>=net-libs/nodejs-0.10.17
	system-llvm? (
		>=sys-devel/llvm-11.0.0_rc1:=[llvm_targets_WebAssembly]
		>=sys-devel/clang-11.0.0_rc1:=[llvm_targets_WebAssembly]
	)"
# The java-utils-2 doesn't like nested conditionals.  The eclass needs at least a virtual/jdk
# This package doesn't really need jdk to use closure-compiler because packages are prebuilt.
# If we have closure_compiler_native, we don't need Java.
DEPEND="${RDEPEND}
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
	>=virtual/jdk-${JAVA_V}
"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	closure_compiler_java? ( closure-compiler )
	closure_compiler_native? ( closure-compiler )
	closure_compiler_nodejs? ( closure-compiler )
	system-closure-compiler? (
		closure-compiler
		^^ ( closure_compiler_java closure_compiler_native closure_compiler_nodejs )
	)
	^^ ( emscripten-fastcomp system-llvm )
"
FN_DEST="${P}.tar.gz"
SRC_URI="https://github.com/kripken/${PN}/archive/${PV}.tar.gz -> ${FN_DEST}"
RESTRICT="fetch mirror"
DEST="/usr/share/"
TEST="${WORKDIR}/test/"
DOWNLOAD_SITE="https://github.com/emscripten-core/emscripten/releases"
FN_SRC="${PV}.tar.gz"
_PATCHES=(
	"${FILESDIR}/emscripten-1.39.20-set-wrappers-path.patch"
)
CMAKE_BUILD_TYPE=Release

pkg_nofetch() {
	# no fetch on all-rights-reserved
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	einfo \
"Please download\n\
  ${FN_SRC}\n\
from ${DOWNLOAD_SITE} and rename it to ${FN_DEST} place it in ${distdir}"
}

pkg_setup() {
	if use closure-compiler ; then
		if ! use closure_compiler_native ; then
			java-pkg_init
			if [[ -n "${JAVA_HOME}" && -f "${JAVA_HOME}/bin/java" ]] ; then
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
	if use system-llvm ; then
		HIGHEST_LLVM_VER=$(basename $(find /usr/lib/llvm -maxdepth 1 \
			-regextype 'posix-extended' -regex ".*[0-9]+.*" \
			| sort -V | tail -n 1))
		# You are allowed to set EMSDK_LLVM_VERSION as a per-package
		# environmental variable.
		export EMSDK_LLVM_VERSION=${EMSDK_LLVM_VERSION:=${HIGHEST_LLVM_VER}}
		if [[ -n "${EMSDK_LLVM_VERSION}" \
		&& ! -d "${EROOT}/usr/lib/llvm/${EMSDK_LLVM_VERSION}" ]] ; then
			eerror \
"The path /usr/lib/llvm/${EMSDK_LLVM_VERSION} does not exist.  Did you put\n\
the correct EMSDK_LLVM_VERSION?"
			die
		fi
		CXX=$(tc-getCXX)
		test-flag-CXX -fignore-exceptions
		if [[ "$?" != "0" ]] ; then
			die "You need llvm >=11.0.0_rc1 to use this product."
		fi
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
prepare_file() {
	cp "${FILESDIR}/${1}" "${S}/" || die "could not copy '${1}'"
	sed -i "s/\${PV}/${PV}/g" "${S}/${1}" || \
		die "could not adjust path for '${1}'"
	sed -i -e "s|\${PYTHON_EXE_ABSPATH}|${PYTHON_EXE_ABSPATH}|g" "${S}/${1}" || die
	if use emscripten-fastcomp ; then
		sed -i -e \
"s|__EMSDK_LLVM_ROOT__|/usr/share/emscripten-fastcomp-${PV}/bin|" \
		-e \
"s|__EMCC_WASM_BACKEND__|0|" \
		-e \
"s|__LLVM_BIN_PATH__|/usr/share/emscripten-fastcomp-${PV}/bin|" \
		"${S}/${1}" || die
	elif use system-llvm ; then
		sed -i -e \
"s|__EMSDK_LLVM_ROOT__|/usr/lib/llvm/${EMSDK_LLVM_VERSION}/bin|" \
		-e \
"s|__EMCC_WASM_BACKEND__|1|" \
		-e \
"s|__LLVM_BIN_PATH__|/usr/lib/llvm/${EMSDK_LLVM_VERSION}/bin|" \
		"${S}/${1}" || die
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
	# For examples of environmental variables and paths used in this package, see
	# https://github.com/emscripten-core/emsdk/issues/167#issuecomment-414935332
	prepare_file "99emscripten"
	prepare_file "emscripten.config.1.39.20"
	mv "${S}/emscripten.config"{.1.39.20,} || die
	eapply ${_PATCHES[@]}
	eapply_user
	S="${S}/tools/optimizer" \
	cmake-utils_src_prepare
	if ! use native-optimizer ; then
		sed -i "/EMSCRIPTEN_NATIVE_OPTIMIZER/d" \
			"${S}/99emscripten" || die
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
			sed -i "s|__EMSDK_CLOSURE_COMPILER__|\"${cmd}\"|" \
				"${S}/99emscripten" || die
		else
			# Using defaults
			sed -i "/EMSDK_CLOSURE_COMPILER/d" \
				"${S}/99emscripten" || die
		fi
	else
		sed -i "/EMSDK_CLOSURE_COMPILER/d" \
			"${S}/99emscripten" || die
	fi
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

src_test() {
	cp "${S}/99emscripten" "${T}/99emscripten" || die
	sed -i -e "s|PATH=\"/usr/share/emscripten-1.40.0\"|PATH=\"/usr/share/emscripten-1.40.0:\${PATH}\"|" "${T}/99emscripten" || die
	source "${T}/99emscripten"
	if use system-llvm ; then
		export LLVM_ROOT="${EMSDK_LLVM_ROOT}"
		if [[ "${EMCC_WASM_BACKEND}" != "1" ]] ; then
			die "EMCC_WASM_BACKEND should be 1 with system-llvm"
		fi
	elif use emscripten-fastcomp ; then
		if [[ "${EMCC_WASM_BACKEND}" != "0" ]] ; then
			die "EMCC_WASM_BACKEND should be 0 with emscripten-fastcomp"
		fi
	fi
	if use test ; then
		mkdir "${TEST}" || die "Could not create test directory!"
		cp "${FILESDIR}/hello_world.cpp" "${TEST}" \
			|| die "Could not copy example file"
		cp "${S}/emscripten.config" "${TEST}" \
			|| die "Could not copy config file"
		sed -i -e "/^EMSCRIPTEN_ROOT/s|/usr/share/|${S}|" \
			"${TEST}/emscripten.config" \
			|| die "Could not adjust path for testing"
		export EM_CONFIG="${TEST}/emscripten.config" \
			|| die "Could not export variable"
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
	fi
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
	dosym ../share/${P}/em++ /usr/bin/em++
	dosym ../share/${P}/em-config /usr/bin/em-config
	dosym ../share/${P}/emar /usr/bin/emar
	dosym ../share/${P}/embuilder /usr/bin/embuilder
	dosym ../share/${P}/emcc /usr/bin/emcc
	dosym ../share/${P}/emcmake /usr/bin/emcmake
	dosym ../share/${P}/emconfigure /usr/bin/emconfigure
	dosym ../share/${P}/emmake /usr/bin/emmake
	dosym ../share/${P}/emranlib /usr/bin/emranlib
	dosym ../share/${P}/emrun /usr/bin/emrun
	dosym ../share/${P}/emscons /usr/bin/emscons
	dosym ../share/${P}/emsize /usr/bin/emsize
	doenvd 99emscripten
	. /etc/profile
	if use system-llvm ; then
		export LLVM_ROOT="/usr/lib/llvm/${EMSDK_LLVM_VERSION}/bin"
	fi
	ewarn "If you consider using emscripten in an active shell,"\
		"please execute 'source /etc/profile'"
}

pkg_postinst() {
	if use system-llvm ; then
		if [[ "${EMCC_WASM_BACKEND}" != "1" ]] ; then
			die "EMCC_WASM_BACKEND should be 1 with system-llvm"
		fi
	elif use emscripten-fastcomp ; then
		if [[ "${EMCC_WASM_BACKEND}" != "0" ]] ; then
			die "EMCC_WASM_BACKEND should be 0 with emscripten-fastcomp"
		fi
	fi
	if use closure-compiler && ! use system-closure-compiler ; then
		export NPM_SECAUDIT_INSTALL_PATH="${DEST}/${P}"
		npm-secaudit_pkg_postinst
	fi
	elog "Running emscripten initialization, may take a few seconds..."
	export EM_CONFIG="${DEST}/${P}/emscripten.config" \
		|| die "Could not export variable"
	/usr/bin/emcc -v || die "Could not run emcc initialization"
	einfo \
"\n\
LLVM_ROOT is set to EMSDK_LLVM_ROOT to avoid possible environmental variable\n\
conflict.  Set it manually to LLVM_ROOT=\"\$EMSDK_LLVM_ROOT\" before compiling\n\
with ${P}.\n\
\n"
	einfo \
"\n\
CLOSURE_COMPILER is set to EMSDK_CLOSURE_COMPILER to avoid possible\n\
environmental variable conflict.  Set it manually to\n\
CLOSURE_COMPILER=\"\$EMSDK_CLOSURE_COMPILER\" before compiling with ${P}.\n\
\n"
}
