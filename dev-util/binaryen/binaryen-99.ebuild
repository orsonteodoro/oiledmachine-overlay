# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Compiler infrastructure and toolchain library for WebAssembly"
HOMEPAGE="https://github.com/WebAssembly/binaryen"
LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions"
# root directory contains Apache-2.0 but third_party/llvm-project
# contains Apache-2.0-with-LLVM-exceptions
KEYWORDS="~amd64 ~x86"
SLOT_MAJOR="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJOR}/${PV}"
IUSE="doc"
RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"
CMAKE_MIN_VERSION="3.1.3"
CMAKE_BUILD_TYPE="Release"
PYTHON_COMPAT=( python3_{6..9} )
inherit cmake-utils python-any-r1 toolchain-funcs
SRC_URI="\
https://github.com/WebAssembly/binaryen/archive/version_${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-version_${PV}"
RESTRICT="mirror"
DOCS=( CHANGELOG.md README.md )

pkg_setup() {
	CC=$(tc-getCC)
	CXX=$(tc-getCXX)
	echo "CC=${CC} CXX=${CXX}"
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
}

src_prepare() {
	sed -r -i \
		-e '/INSTALL.+src\/binaryen-c\.h/d' \
		CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR=/usr/$(get_libdir)/binaryen/${SLOT_MAJOR}/$(get_libdir)
		-DCMAKE_INSTALL_BINDIR=/usr/$(get_libdir)/binaryen/${SLOT_MAJOR}/bin
		-DCMAKE_INSTALL_INCLUDEDIR=/usr/$(get_libdir)/binaryen/${SLOT_MAJOR}/include
		-DBUILD_STATIC_LIB=OFF
		-DENABLE_WERROR=OFF
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
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
}
