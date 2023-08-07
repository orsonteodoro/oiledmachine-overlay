# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO:  backport 5.5.0 patches after use-system-mlir

# Design notes, considering using llvm-roc instead with rpath instead.

LLVM_MAX_SLOT=15
PYTHON_COMPAT=( python3_{10..11} )

inherit cmake llvm python-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/rocMLIR/"
	inherit git-r3
else
	SRC_URI="
https://github.com/ROCmSoftwarePlatform/rocMLIR/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-rocm-${PV}"
fi

DESCRIPTION="MLIR-based convolution and GEMM kernel generator for ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocMLIR"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	MIT
"
# Apache-2.0-with-LLVM-exceptions - mlir/LICENSE.TXT
# all rights reserved with MIT - mlir/tools/rocmlir-lib/LICENSE
# The distro MIT license template does not have all rights reserved
SLOT="0/$(ver_cut 1-2)"
IUSE="+llvm-roc"
RDEPEND="
	!llvm-roc? (
		sys-libs/mlir:${LLVM_MAX_SLOT}[llvm_targets_AMDGPU]
		sys-devel/llvm:${LLVM_MAX_SLOT}[llvm_targets_AMDGPU]
	)
	${PYTHON_DEPS}
	>=dev-db/sqlite-3:3
	>=dev-python/pybind11-2.8[${PYTHON_USEDEP}]
	media-libs/vulkan-loader
	llvm-roc? (
		~sys-devel/llvm-roc-${PV}:${PV}
	)
	~dev-util/hip-${PV}:${SLOT}
"
DEPEND="
	${RDEPEND}
	dev-util/vulkan-headers
"
BDEPEND="
	!llvm-roc? (
		sys-devel/clang:${LLVM_MAX_SLOT}
		sys-devel/llvm:${LLVM_MAX_SLOT}
	)
	${PYTHON_DEPS}
	>=dev-util/cmake-3.15.1
	virtual/pkgconfig
	llvm-roc? (
		~sys-devel/llvm-roc-${PV}:${PV}
	)
"
RESTRICT="test"
_LLVM_ROC_PATCHES=(
	"${FILESDIR}/rocMLIR-5.5.0-fix-sover.patch"
)
_LLVM_PROPER_PATCHES=(
	"${FILESDIR}/rocMLIR-5.4.3-fix-bin-linking.patch"
	"${FILESDIR}/rocMLIR-5.5.0-fix-sover-and-rpath.patch"
	"${FILESDIR}/rocMLIR-5.3.3-use-system-mlir.patch"
)

pkg_setup() {
	python_setup
}

src_prepare() {
	if use llvm-roc ;then
		eapply ${_LLVM_ROC_PATCHES[@]}
	else
# The llvm-roc is deprecated on the distro.
ewarn "USE=-llvm-roc is unfinished.  USE=llvm-roc instead."
		sed -i -e "s|LLVM_VERSION_SUFFIX git|LLVM_VERSION_SUFFIX|g" \
			external/llvm-project/llvm/CMakeLists.txt \
			|| die
		rm -rf external || die
		eapply ${_LLVM_PROPER_PATCHES[@]}
	fi
	cmake_src_prepare
}

src_configure() {
	if use llvm-roc ; then
		export ROCM_PATH="${ESYSROOT}/opt/rocm-${PV}/llvm"
	else
		export ROCM_PATH="${ESYSROOT}/usr"
	fi
	export HIP_PLATFORM="amd"
	local mycmakeargs=(
		-DELLVM_VERSION_MAJOR=${LLVM_MAX_SLOT}
		-DELLVM_VERSION_MINOR=0
		-DELLVM_VERSION_PATCH=0
		-DELLVM_VERSION_SUFFIX=

		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_RUNTIME="rocclr"

		# From additional settings in HEAD
		-DLLVM_ENABLE_ZLIB=OFF
		-DLLVM_ENABLE_ZSTD=OFF
	)
	if use llvm-roc ; then
		mycmakeargs+=(
			-DLLVM_CMAKE_DIR="${ESYSROOT}/opt/rocm-${PV}/llvm/$(get_libdir)/cmake/llvm"
			-DMLIR_CMAKE_DIR="${ESYSROOT}/opt/rocm-${PV}/llvm/$(get_libdir)/cmake/mlir"
			-DMLIR_MAIN_INCLUDE_DIR="${ESYSROOT}/opt/rocm-${PV}/llvm/include"
		)
	else
		mycmakeargs+=(
			-DLLVM_CMAKE_DIR="${ESYSROOT}/usr/lib/llvm/${LLVM_MAX_SLOT}/$(get_libdir)/cmake/llvm"
			-DMLIR_CMAKE_DIR="${ESYSROOT}/usr/lib/llvm/${LLVM_MAX_SLOT}/$(get_libdir)/cmake/mlir"
			-DMLIR_MAIN_INCLUDE_DIR="${ESYSROOT}/usr/lib/llvm/${LLVM_MAX_SLOT}/include"
		)
	fi
	if [[ "${HIP_CXX}" =~ "g++" ]] ; then
ewarn "Using clang may result in symbol error."
	fi
	CXX="${HIP_CXX:-g++}"
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  build-failure
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
