# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# For requirements, see
# https://github.com/emscripten-core/emscripten/blob/master/site/source/docs/building_from_source/toolchain_what_is_needed.rst

EAPI=7
DESCRIPTION="Emscripten LLVM backend - Fastcomp is the default compiler core for Emscripten"
HOMEPAGE="http://emscripten.org/"
LICENSE="UoI-NCSA BSD LLVM-Grant MIT rc scanlogd"
# Packages (emscripten-fastcomp, emscripten-fastcomp-clang),
#   LLVM System Interface Library, ClangFormat - UoI-NCSA
# googlemock, Google Test - BSD
# OpenBSD regex - BSD rc
# pyyaml tests - MIT
# ARM contributions - LLVM-Grant
# md5 contributions - public domain + scanlogd (no warranty)
KEYWORDS="~amd64 ~x86"
PYTHON_COMPAT=( python3_{6,7,8} )
inherit python-single-r1
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
MY_DEPEND="${PYTHON_DEPS}
	>=net-libs/nodejs-0.12.6"
RDEPEND="${MY_DEPEND}
	>=virtual/jre-1.5"
DEPEND="${MY_DEPEND}
	>=dev-util/cmake-3.4.3"
BDEPEND="dev-cpp/gtest
	>=dev-util/cmake-3.4.3
	>=net-libs/nodejs-0.12.6"
inherit cmake-utils
SRC_URI="\
https://github.com/kripken/${PN}/archive/${PV}.tar.gz \
	-> ${P}.tar.gz
https://github.com/kripken/${PN}-clang/archive/${PV}.tar.gz \
	-> ${PN}-clang-${PV}.tar.gz"
_PATCHES=(
	"${FILESDIR}/${PN}-1.39.8-cmake.patch"
	"${FILESDIR}/${PN}-1.39.8-version_cpp.patch"
)
RESTRICT="mirror"

src_prepare() {
	pushd "${WORKDIR}" || die
		eapply ${_PATCHES[@]}
		eapply_user
	popd
	CMAKE_USE_DIR="${WORKDIR}/${PN}-${PV}" \
	cmake-utils_src_prepare
}

src_configure() {
	# create symlink to tools/clang
	ln -s "${WORKDIR}/${PN}-clang-${PV}/" "${WORKDIR}/${P}/tools/clang" \
		|| die "Could not create symlink to tools/clang"
	ln -s "${WORKDIR}/${P}/tools/clang/emscripten-version.txt" \
		"${WORKDIR}/${P}/tools/clang/lib/Basic/emscripten-version.txt" \
		|| die "Could not create symlink to tools/clang/emscripten-version.txt"
	local mycmakeargs=(
		-DCLANG_INCLUDE_DOCS=OFF
		-DCLANG_INCLUDE_EXAMPLES=OFF
		-DCLANG_INCLUDE_TESTS=OFF
		# avoid clashes with sys-devel/llvm
		-DCMAKE_INSTALL_PREFIX="/usr/share/${P}"
		-DLLVM_TARGETS_TO_BUILD="X86;JSBackend"
		-DLLVM_INCLUDE_DOCS=OFF
		-DLLVM_INCLUDE_EXAMPLES=OFF
		-DLLVM_INCLUDE_TESTS=OFF
	)
	cmake-utils_src_configure
}
