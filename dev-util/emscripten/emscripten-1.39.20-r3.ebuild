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
ZLIB"
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
SLOT="0"
PYTHON_COMPAT=( python3_{6,7,8} )
inherit python-single-r1
IUSE="test"
# See also .circleci/config.yml
# See also tools/shared.py EXPECTED_BINARYEN_VERSION
RDEPEND="${PYTHON_DEPS}
	>=dev-util/binaryen-93
	~dev-util/emscripten-fastcomp-${PV}
	>=net-libs/nodejs-0.10.17"
DEPEND="${RDEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
FN_DEST="${P}.tar.gz"
SRC_URI="https://github.com/kripken/${PN}/archive/${PV}.tar.gz -> ${FN_DEST}"
RESTRICT="fetch mirror"
DEST="/usr/share/"
TEST="${WORKDIR}/test/"
DOWNLOAD_SITE="https://github.com/emscripten-core/emscripten/releases"
FN_SRC="${PV}.tar.gz"
PATCHES=(
	"${FILESDIR}/emscripten-1.39.20-em++.patch"
	"${FILESDIR}/emscripten-1.39.20-emcc.patch"
)

pkg_nofetch() {
	# no fetch on all-rights-reserved
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	einfo \
"Please download\n\
  ${FN_SRC}\n\
from ${DOWNLOAD_SITE} and rename it to ${FN_DEST} place it in ${distdir}"
}

pkg_setup() {
	if use test ; then
		if [[ ! "${FEATURES}" =~ test ]] ; then
			die \
"The test USE flag requires the environmental variable test to be added to\n\
FEATURES"
		fi
	fi

	if [[ ! -f /usr/share/emscripten-fastcomp-${PV}/bin/llc ]] ; then
		die \
"You need to install ~dev-util/emscripten-fastcomp-${PV}.  Only revision\n\
updates acceptable."
	fi
}

prepare_file() {
	cp "${FILESDIR}/${1}" "${S}/" || die "could not copy '${1}'"
	sed -i "s/\${PV}/${PV}/g" "${S}/${1}" || \
		die "could not adjust path for '${1}'"
}

src_prepare() {
	prepare_file "99emscripten"
	prepare_file "emscripten.config.1.39.20"
	mv "${S}/emscripten.config"{.1.39.20,} || die
	eapply ${PATCHES[@]}
	eapply_user
}

src_compile() {
	:;
}

src_test() {
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
	dodir "${DEST}/${P}"
	cp -R "${S}/" "${D}/${DEST}" || die "Could not install files"
	dosym ../share/${P}/emcc /usr/bin/emcc
	dosym ../share/${P}/em++ /usr/bin/em++
	dosym ../share/${P}/emcmake /usr/bin/emcmake
	doenvd 99emscripten
	ewarn "If you consider using emscripten in an active shell,"\
		"please execute 'source /etc/profile'"
}

pkg_postinst() {
	elog "Running emscripten initialization, may take a few seconds..."
	export EM_CONFIG="${DEST}/${P}/emscripten.config" \
		|| die "Could not export variable"
	/usr/bin/emcc -v || die "Could not run emcc initialization"
}
