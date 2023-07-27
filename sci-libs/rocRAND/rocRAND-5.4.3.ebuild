# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_OVERRIDE=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
	gfx1100
	gfx1102
)
LLVM_MAX_SLOT=15
ROCM_VERSION="${PV}"

inherit cmake llvm rocm

HIPRAND_COMMIT_HASH="de941a7eb9ede2a862d719cd3ca23234a3692d07"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/${PN}/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/ROCmSoftwarePlatform/hipRAND/archive/${HIPRAND_COMMIT_HASH}.tar.gz
	-> hipRAND-${HIPRAND_COMMIT_HASH}.tar.gz
"

DESCRIPTION="Generate pseudo-random and quasi-random numbers"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocRAND"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="benchmark test"
REQUIRED_USE="
	${ROCM_REQUIRED_USE}
"
RDEPEND="
	~dev-util/hip-${PV}:${SLOT}
"
DEPEND="
	${RDEPEND}
	~dev-util/rocm-cmake-${PV}:${SLOT}
	test? (
		dev-cpp/gtest
	)
"
BDEPEND="
	>=dev-util/cmake-3.22
	~dev-util/rocm-cmake-${PV}:${SLOT}
"

RESTRICT="
	!test? (
		test
	)
"
S="${WORKDIR}/rocRAND-rocm-${PV}"

pkg_setup() {
	llvm_pkg_setup # For LLVM_SLOT init.  Must be explicitly called or it is blank.
}

src_prepare() {
	rmdir hipRAND || die
	mv -v \
		../hipRAND-${HIPRAND_COMMIT_HASH} \
		hipRAND \
		|| die
	#
	# Changed the installed include and lib dir, and avoided the symlink
	# overwrite in  the installed headers.
	#
	# Avoided setting RPATH.
	#
	sed -r \
		-e "s:(hip|roc)rand/lib:\${CMAKE_INSTALL_LIBDIR}:" \
		-e "s:(hip|roc)rand/include:include/\1rand:" \
		-e '/\$\{INSTALL_SYMLINK_COMMAND\}/d' \
		-e "/INSTALL_RPATH/d" \
		-i \
		library/CMakeLists.txt \
		|| die

	# Removed the GIT dependency.
	sed \
		-e "/find_package(Git/,+4d" \
		-i \
		cmake/Dependencies.cmake \
		|| die

	eapply_user
	cmake_src_prepare
}

src_configure() {
	addpredict /dev/kfd
	addpredict /dev/dri/
	local mycmakeargs=(
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_BENCHMARK=$(usex benchmark ON OFF)
		-DBUILD_HIPRAND=ON
		-DBUILD_TEST=$(usex test ON OFF)
		-DCMAKE_SKIP_RPATH=On
	)
	CXX=hipcc \
	cmake_src_configure
}

src_test() {
	check_amdgpu
	export LD_LIBRARY_PATH="${BUILD_DIR}/library"
	MAKEOPTS="-j1" \
	cmake_src_test
}

src_install() {
	cmake_src_install
	if use benchmark; then
		cd "${BUILD_DIR}"/benchmark
		dobin benchmark_rocrand_*
	fi
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
