# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=17
PYTHON_COMPAT=( "python3_"{10..12} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake flag-o-matic python-single-r1 rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/rocminfo/"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/rocminfo-rocm-${PV}"
	SRC_URI="
https://github.com/RadeonOpenCompute/rocminfo/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="ROCm Application for Reporting System Info"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocminfo"
LICENSE="UoI-NCSA"
SLOT="${ROCM_SLOT}/${PV}"
IUSE+=" ebuild-revision-2"
RDEPEND="
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.6.3
"
PATCHES=(
)

pkg_setup() {
	python-single-r1_pkg_setup
	rocm_pkg_setup
}

src_prepare() {
	sed \
		-e "/CPACK_RESOURCE_FILE_LICENSE/d" \
		-i \
		CMakeLists.txt \
		|| die
	sed \
		-e "/num_change_since_prev_pkg(/cset(NUM_COMMITS 0)" \
		-i \
		cmake_modules/utils.cmake \
		|| die # Fix QA issue on "git not found"
	cmake_src_prepare
	rocm_src_prepare
	python_fix_shebang ./
}

src_configure() {
	export CC="clang"
	export CXX="clang++"
	append-ldflags -fuse-ld=lld # Breaks with bfd
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DCMAKE_PREFIX_PATH="${ESYSROOT}${EROCM_PATH}"
		-DROCRTST_BLD_TYPE="Release"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  needs install test
