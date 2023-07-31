# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
ROCM_VERSION="${PV}"

inherit cmake rocm

SRC_URI="
https://github.com/ROCmSoftwarePlatform/hipFFT/archive/refs/tags/rocm-${PV}.tar.gz
	-> hipFFT-rocm-${PV}.tar.gz
"

DESCRIPTION="CU / ROCM agnostic hip FFT implementation"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipFFT"
IUSE+=" cuda +rocm"
gen_rocm_required_use() {
	local x
	for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		echo "
			amdgpu_targets_${x}? (
				rocm
			)
		"
	done
}
REQUIRED_USE="
	$(gen_rocm_required_use)
	rocm? (
		${ROCM_REQUIRED_USE}
	)
	^^ (
		rocm
		cuda
	)
"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
RDEPEND="
	~dev-util/hip-${PV}:${SLOT}
	cuda? (
		dev-util/nvidia-cuda-toolkit
	)
	rocm? (
		~sci-libs/rocFFT-${PV}:${SLOT}
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.5
	~dev-util/rocm-cmake-${PV}:${SLOT}
"
RESTRICT="test"
S="${WORKDIR}/hipFFT-rocm-${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-5.0.2-remove-git-dependency.patch"
	"${FILESDIR}/${PN}-4.3.0-add-complex-header.patch"
)

src_prepare() {
	sed \
		-e "/CMAKE_INSTALL_LIBDIR/d" \
		-i \
		CMakeLists.txt \
		|| die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_CLIENTS_TESTS=OFF
		-DBUILD_CLIENTS_RIDER=OFF
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DCMAKE_INSTALL_INCLUDEDIR="include/hipfft"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_MODULE_PATH="${EPREFIX}/usr/$(get_libdir)/cmake"
		-DCMAKE_MODULE_PATH="${EPREFIX}/usr/$(get_libdir)/cmake/hip"
		-DHIP_ROOT_DIR="${EPREFIX}/usr"
		-DROCM_PATH="${EPREFIX}/usr"
	)
	if use cuda ; then
		export HIP_PLATFORM="nvidia"
		mycmakeargs+=(
			-DBUILD_WITH_LIB="CUDA"
		)
	elif use rocm ; then
		mycmakeargs+=(
			-DBUILD_WITH_LIB="ROCM"
		)
	fi
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
