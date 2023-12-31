# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
PYTHON_COMPAT=( python3_{8..11} )
inherit cmake python-any-r1 toolchain-funcs

DESCRIPTION="Compiler infrastructure and toolchain library for WebAssembly"
HOMEPAGE="https://github.com/WebAssembly/binaryen"
LICENSE="
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
"
# root directory contains Apache-2.0 but third_party/llvm-project
# contains Apache-2.0-with-LLVM-exceptions
KEYWORDS="~amd64 ~x86"
SLOT_MAJOR="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJOR}/${PV}"
IUSE+=" doc"
CDEPEND+="
	|| (
		>=sys-devel/gcc-5
		>=sys-devel/clang-3.4
	)
"
RDEPEND+="
	${PYTHON_DEPS}
	${CDEPEND}
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	${CDEPEND}
	>=dev-util/cmake-3.1.3
	dev-util/patchelf
"
SRC_URI="
https://github.com/WebAssembly/binaryen/archive/version_${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-version_${PV}"
RESTRICT="mirror"
DOCS=( CHANGELOG.md README.md )
PATCHES=(
	"${FILESDIR}/${P}-e4d1e20.patch"
)

pkg_setup() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
einfo
einfo "CC:\t${CC}"
einfo "CXX:\t${CXX}"
einfo
	test-flags-CXX "-std=c++14" 2>/dev/null 1>/dev/null \
		|| die "Switch to a c++14 compatible compiler."
	if tc-is-gcc ; then
		if ver_test $(gcc-major-version) -lt 5 ; then
			die "${PN} requires GCC >=5.x for c++14 support"
		fi
	elif tc-is-clang ; then
		if ver_test $(clang-version) -lt 3.4 ; then
			die "${PN} requires Clang >=3.4.x for c++14 support"
		fi
	else
		die "Compiler is not supported"
	fi
	python-any-r1_pkg_setup
}

src_prepare() {
	sed -r -i \
		-e '/INSTALL.+src\/binaryen-c\.h/d' \
		CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)/binaryen/${SLOT_MAJOR}/$(get_libdir)"
		-DCMAKE_INSTALL_BINDIR="${EPREFIX}/usr/$(get_libdir)/binaryen/${SLOT_MAJOR}/bin"
		-DCMAKE_INSTALL_INCLUDEDIR="${EPREFIX}/usr/$(get_libdir)/binaryen/${SLOT_MAJOR}/include"
		-DBUILD_STATIC_LIB=OFF
		-DENABLE_WERROR=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	insinto "/usr/$(get_libdir)/binaryen/${SLOT_MAJOR}/include"
	doins "${S}/src/"*.h
	for hdir in asmjs emscripten-optimizer ir support; do
		insinto "/usr/$(get_libdir)/binaryen/${SLOT_MAJOR}/include/${hdir}"
		doins "${S}/src/${hdir}/"*.h
	done
	dosym /usr/$(get_libdir)/binaryen/${SLOT_MAJOR}/$(get_libdir) \
		/usr/$(get_libdir)/binaryen/${SLOT_MAJOR}/lib
	dodoc LICENSE
	cat third_party/llvm-project/include/llvm/Support/LICENSE.TXT \
		> "${T}/LICENSE.LLVM_System_Interface_Library.TXT"
	dodoc "${T}/LICENSE.LLVM_System_Interface_Library.TXT"
	cat third_party/llvm-project/include/llvm/LICENSE.TXT \
		> "${T}/LICENSE.llvm-project.TXT"
	dodoc "${T}/LICENSE.llvm-project.TXT"
	for f in $(find "${ED}" -executable) ; do
		if ldd "${f}" 2>/dev/null | grep -q "libbinaryen.so" ; then
			patchelf --set-rpath "${EPREFIX}/usr/$(get_libdir)/binaryen/${SLOT_MAJOR}/$(get_libdir)" "${f}" || die
		fi
	done
}

