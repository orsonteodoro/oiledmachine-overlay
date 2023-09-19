# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=14
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/rocminfo/"
	inherit git-r3
else
	SRC_URI="
https://github.com/RadeonOpenCompute/rocminfo/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/rocminfo-rocm-${PV}"
fi

DESCRIPTION="ROCm Application for Reporting System Info"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocminfo"
LICENSE="UoI-NCSA"
SLOT="${ROCM_SLOT}/${PV}"
RDEPEND="
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.6.3
"
PATCHES=(
	"${FILESDIR}/${PN}-5.1.3-detect-builtin-amdgpu.patch"
	"${FILESDIR}/${PN}-5.1.3-path-changes.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	sed \
		-e "/CPACK_RESOURCE_FILE_LICENSE/d" \
		-i \
		CMakeLists.txt \
		|| die

	# Fix QA issue on "git not found"
	sed \
		-e "/num_change_since_prev_pkg(/cset(NUM_COMMITS 0)" \
		-i \
		cmake_modules/utils.cmake \
		|| die
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_PREFIX_PATH="${ESYSROOT}/usr/$(get_libdir)/rocm/${ROCM_SLOT}"
		-DROCRTST_BLD_TYPE="Release"
	)
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
