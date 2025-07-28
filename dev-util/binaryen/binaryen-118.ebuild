# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U20, U23

CMAKE_BUILD_TYPE="Release"
PYTHON_COMPAT=( python3_{8..11} )
SLOT_MAJOR="${PV%%.*}"

inherit cmake python-any-r1 toolchain-funcs

KEYWORDS="~amd64 ~arm64 ~arm64-macos"
S="${WORKDIR}/${PN}-version_${PV}"
SRC_URI="
https://github.com/WebAssembly/binaryen/archive/version_${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Compiler infrastructure and toolchain library for WebAssembly"
HOMEPAGE="https://github.com/WebAssembly/binaryen"
LICENSE="
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
"
# root directory contains Apache-2.0 but third_party/llvm-project
# contains Apache-2.0-with-LLVM-exceptions
RESTRICT="mirror"
SLOT="${SLOT_MAJOR}/${PV}"
IUSE+=" doc"
CDEPEND+="
	|| (
		>=sys-devel/gcc-7
		>=llvm-core/clang-5
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
	>=dev-build/cmake-3.10.2
	dev-util/patchelf
"
DOCS=( "CHANGELOG.md" "README.md" )

pkg_setup() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)
einfo
einfo "CC:\t${CC}"
einfo "CXX:\t${CXX}"
einfo
	test-flags-CXX "-std=c++17" >/dev/null 2>&1 \
		|| die "Switch to a c++17 compatible compiler."
	if tc-is-gcc ; then
		if ver_test $(gcc-major-version) -lt "7" ; then
			die "${PN} requires GCC >=7 for c++17 support"
		fi
	elif tc-is-clang ; then
		if ver_test $(clang-version) -lt "5" ; then
			die "${PN} requires Clang >=5 for c++17 support"
		fi
	else
		die "Compiler is not supported"
	fi
	python-any-r1_pkg_setup
}

src_prepare() {
	sed -r -i \
		-e '/INSTALL.+src\/binaryen-c\.h/d' \
		"CMakeLists.txt" \
		|| die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIB=OFF
		-DBUILD_TESTS=OFF
		-DCMAKE_INSTALL_BINDIR="${EPREFIX}/usr/$(get_libdir)/binaryen/${SLOT_MAJOR}/bin"
		-DCMAKE_INSTALL_INCLUDEDIR="${EPREFIX}/usr/$(get_libdir)/binaryen/${SLOT_MAJOR}/include"
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)/binaryen/${SLOT_MAJOR}/$(get_libdir)"
		-DENABLE_WERROR=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	insinto "/usr/$(get_libdir)/binaryen/${SLOT_MAJOR}/include"
	doins "${S}/src/"*".h"
	local hdir
	for hdir in "asmjs" "emscripten-optimizer" "ir" "support" ; do
		insinto "/usr/$(get_libdir)/binaryen/${SLOT_MAJOR}/include/${hdir}"
		doins "${S}/src/${hdir}/"*".h"
	done
	dosym \
		"/usr/$(get_libdir)/binaryen/${SLOT_MAJOR}/$(get_libdir)" \
		"/usr/$(get_libdir)/binaryen/${SLOT_MAJOR}/lib"
	dodoc "LICENSE"
	cat "third_party/llvm-project/include/llvm/Support/LICENSE.TXT" \
		> "${T}/LICENSE.LLVM_System_Interface_Library.TXT"
	dodoc "${T}/LICENSE.LLVM_System_Interface_Library.TXT"
	cat "third_party/llvm-project/include/llvm/LICENSE.TXT" \
		> "${T}/LICENSE.llvm-project.TXT"
	dodoc "${T}/LICENSE.llvm-project.TXT"
	local f
	for f in $(find "${ED}" -executable) ; do
		if ldd "${f}" 2>/dev/null | grep -q "libbinaryen.so" ; then
			patchelf \
				--set-rpath "${EPREFIX}/usr/$(get_libdir)/binaryen/${SLOT_MAJOR}/$(get_libdir)" \
				"${f}" \
				|| die
		fi
	done
}

