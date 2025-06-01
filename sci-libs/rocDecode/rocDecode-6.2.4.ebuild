# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx908
	gfx90a
	gfx940
	gfx941
	gfx942
	gfx1030
	gfx1031
	gfx1032
	gfx1100
	gfx1101
	gfx1102
)
AMDGPU_TARGETS_UNTESTED=(
#	gfx908
#	gfx90a
	gfx940
	gfx941
#	gfx942
#	gfx1030
	gfx1031
	gfx1032
	gfx1100
#	gfx1101
	gfx1102
)
LLVM_SLOT=18
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit check-compiler-switch cmake flag-o-matic rocm

KEYWORDS="~amd64"
S="${WORKDIR}/rocDecode-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/${PN}/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="rocDecode is a high performance video decode SDK for AMD hardware"
HOMEPAGE="https://github.com/ROCm/rocDecode"
LICENSE="
	(
		all-rights-reserved
		custom
		MIT
	)
	(
		all-rights-reserved
		MIT
	)
	MIT
"
# all-rights-reserved custom MIT - https://github.com/ROCm/rocDecode/blob/rocm-6.1.2/LICENSE
# all-rights-reserved MIT - test/testScripts/run_rocDecode_Conformance.py
# MIT - CMakeLists.txt
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="
	test
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
samples ebuild_revision_3
"
REQUIRED_USE="
"
RDEPEND="
	~dev-util/hip-${PV}:${ROCM_SLOT}[rocm]
	>=media-libs/libva-2.7.0
	>=media-libs/mesa-24.1.0[vaapi,video_cards_radeonsi]
	samples? (
		|| (
			>=media-video/ffmpeg-4.2.7:56.58.58
			>=media-video/ffmpeg-4.2.7:0/56.58.58
		)
		media-video/ffmpeg:=
	)
"
DEPEND="
	${RDEPEND}
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
"
BDEPEND="
	${ROCM_CLANG_DEPEND}
	>=dev-build/cmake-3.5
	virtual/pkgconfig
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
"
PATCHES=(
	"${FILESDIR}/${PN}-6.1.2-hardcoded-paths.patch"
)

warn_untested_gpu() {
	local gpu
	for gpu in ${AMDGPU_TARGETS_UNTESTED[@]} ; do
		if use "amdgpu_targets_${gpu}" ; then
ewarn "${gpu} is not tested upstream."
		fi
	done
}

pkg_setup() {
	check-compiler-switch_start
	rocm_pkg_setup
	warn_untested_gpu
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	addpredict "/dev/kfd"
	addpredict "/dev/dri/"
	local mycmakeargs=(

	# Fixes:
	# rocrand.cpp:1904:16: error: use of undeclared identifier 'ROCRAND_VERSION'
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF

		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DCMAKE_SKIP_RPATH=ON
	)

	export HIP_PLATFORM="amd"
	mycmakeargs+=(
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_RUNTIME="rocclr"
	)
	rocm_set_default_clang

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if ! check-compiler-switch_is_system_flavor ; then
einfo "Detected GPU compiler switch.  Disabling LTO."
		filter-lto
	fi

	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
