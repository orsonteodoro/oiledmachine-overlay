# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U20, U23

CXX_STANDARD=17
CMAKE_BUILD_TYPE="Release"
PYTHON_COMPAT=( "python3_"{8..11} )
SLOT_MAJOR="${PV%%.*}"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_compat_}"
)

inherit cmake libcxx-slot libstdcxx-slot python-any-r1 toolchain-funcs

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
IUSE+="
doc
ebuild_revision_1
"
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
"
DOCS=( "CHANGELOG.md" "README.md" )

pkg_setup() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)
einfo "CC:\t${CC}"
einfo "CXX:\t${CXX}"
	python-any-r1_pkg_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_prepare() {
	sed -r -i \
		-e '/INSTALL.+src\/binaryen-c\.h/d' \
		"CMakeLists.txt" \
		|| die
	cmake_src_prepare
}

src_configure() {
	append-ldflags "-Wl,-rpath,${EPREFIX}/usr/lib/binaryen/${SLOT_MAJOR}/$(get_libdir)"
	local mycmakeargs=(
		-DBUILD_STATIC_LIB=OFF
		-DBUILD_TESTS=OFF
		-DCMAKE_INSTALL_BINDIR="${EPREFIX}/usr/lib/binaryen/${SLOT_MAJOR}/bin"
		-DCMAKE_INSTALL_INCLUDEDIR="${EPREFIX}/usr/lib/binaryen/${SLOT_MAJOR}/include"
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/lib/binaryen/${SLOT_MAJOR}/$(get_libdir)"
		-DENABLE_WERROR=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	insinto "/usr/lib/binaryen/${SLOT_MAJOR}/include"
	doins "${S}/src/"*".h"
	local L=(
		"asmjs"
		"emscripten-optimizer"
		"ir"
		"support"
	)
	local hdir
	for hdir in "${L[@]}" ; do
		insinto "/usr/lib/binaryen/${SLOT_MAJOR}/include/${hdir}"
		doins "${S}/src/${hdir}/"*".h"
	done
	dodoc "LICENSE"
	cat "third_party/llvm-project/include/llvm/Support/LICENSE.TXT" \
		> "${T}/LICENSE.LLVM_System_Interface_Library.TXT"
	dodoc "${T}/LICENSE.LLVM_System_Interface_Library.TXT"
	cat "third_party/llvm-project/include/llvm/LICENSE.TXT" \
		> "${T}/LICENSE.llvm-project.TXT"
	dodoc "${T}/LICENSE.llvm-project.TXT"
}

