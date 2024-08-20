# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {18..15} )

inherit cmake flag-o-matic llvm

if [[ ${PV} == *"9999" ]] ; then
	EGIT_REPO_URI="https://github.com/dyninst/dyninst/"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${P}"
	SRC_URI="
https://github.com/dyninst/dyninst/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="DyninstAPI: Tools for binary instrumentation, analysis, and modification."
HOMEPAGE="https://github.com/dyninst/dyninst"
LICENSE="
	LGPL-2.1+
"
SLOT="0"
IUSE="
${LLVM_COMPAT[@]/#/llvm_slot_}
clang -debuginfod +gcc hip-clang +openmp rocm_6_2 -valgrind
ebuild-revision-2
"
REQUIRED_USE="
	clang? (
		^^ (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
	)
	rocm_6_2? (
		hip-clang
	)
	^^ (
		clang
		gcc
		hip-clang
	)
"
gen_clang_rdepend() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				sys-devel/clang:${s}
				openmp? (
					sys-libs/libomp:${s}
				)
			)
		"
	done
}
RDEPEND="
	>=dev-libs/boost-1.71.0
	>=dev-libs/elfutils-0.186
	=dev-cpp/tbb-2019*
	dev-cpp/tbb:=
	gcc? (
		sys-devel/gcc[openmp?]
	)
	clang? (
		$(gen_clang_rdepend)
	)
	debuginfod? (
		dev-libs/elfutils[debuginfod(-)]
	)
	hip-clang? (
		rocm_6_2? (
			~sys-devel/llvm-roc-6.2.0:6.2
			openmp? (
				~sys-libs/llvm-roc-libomp-6.2.0:6.2
			)
		)
	)
	valgrind? (
		dev-debug/valgrind
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.14
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}/${PN}-13.0.0-disable-exact-version-elfutils.patch"
	"${FILESDIR}/${PN}-13.0.0-use-system-elfutils.patch"
)
DOCS=( "CHANGELOG.md" )

pkg_setup() {
	llvm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	sed -i -e "/set(DYNINST_INSTALL_LIBDIR/d" "cmake/DyninstLibrarySettings.cmake" || die
}

src_configure() {
	strip-flags
	filter-flags '-O0' '-pipe'

	local mycmakeargs=(
		-DADD_VALGRIND_ANNOTATIONS=$(usex valgrind)
		-DCMAKE_INSTALL_PREFIX="/usr"
		-DDYNINST_INSTALL_LIBDIR="$(get_libdir)"
		-DENABLE_DEBUGINFOD=$(usex debuginfod)
		-DUSE_OpenMP=$(usex openmp)
	)

	if use openmp && use clang ; then
		LLVM_SLOT=$(get_llvm_slot)
		append-flags -I"${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}/include" -fopenmp=libomp
		append-flags -Wl,-L"${ESYSROOT}//usr/lib/llvm/${LLVM_SLOT}/$(get_libdir)"
	fi

	if use openmp && use hip-clang ; then
		if use rocm_6_2 ; then
			ROCM_SLOT="6.2"
			ROCM_VERSION="6.2.0"
		fi
		append-flags -I"${ESYSROOT}/opt/rocm-${ROCM_VERSION}/include" -fopenmp=libomp
		append-flags -Wl,-L"${ESYSROOT}/opt/rocm-${ROCM_VERSION}/lib"
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodoc "COPYRIGHT"
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
