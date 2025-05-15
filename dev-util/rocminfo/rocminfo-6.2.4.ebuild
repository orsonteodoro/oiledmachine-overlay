# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=18
PYTHON_COMPAT=( "python3_12" )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake flag-o-matic python-single-r1 rocm

if [[ "${PV}" == *"9999" ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/rocminfo/"
	EGIT_BRANCH="amd-staging"
	FALLBACK_COMMIT="rocm-6.2.4"
	IUSE+=" fallback-commit"
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
LICENSE="NCSA-AMD"
SLOT="${ROCM_SLOT}/${PV}"
IUSE+=" ebuild_revision_5"
RDEPEND="
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
	sys-apps/pciutils
	|| (
		virtual/kfd-ub:6.2
		virtual/kfd:6.1
		virtual/kfd-lb:6.0
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${ROCM_CLANG_DEPEND}
	>=dev-build/cmake-3.6.3
"
PATCHES=(
)

pkg_setup() {
	python-single-r1_pkg_setup
	rocm_pkg_setup
}

src_unpack() {
	if [[ "${PV}" == *"9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
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
	rocm_set_default_clang
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
