# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
)
LLVM_MAX_SLOT=14
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"
inherit cmake llvm rocm

SRC_URI="
https://github.com/ROCmSoftwarePlatform/rocPRIM/archive/rocm-${PV}.tar.gz
	-> rocPRIM-${PV}.tar.gz
"

DESCRIPTION="HIP parallel primitives for developing performant GPU-accelerated code on ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocPRIM"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="benchmark hip-cpu +rocm test"
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
		hip-cpu
	)
"
RDEPEND="
	~dev-util/hip-${PV}:${ROCM_SLOT}[rocm]
	benchmark? (
		dev-cpp/benchmark
	)
	hip-cpu? (
		dev-libs/hip-cpu
	)
	test? (
		dev-cpp/gtest
	)
"
BDEPEND="
	>=dev-util/cmake-3.16
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
"
RESTRICT="
	!test? (
		test
	)
"
S="${WORKDIR}/rocPRIM-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/rocPRIM-5.2.3-path-changes.patch"
)

pkg_setup() {
	llvm_pkg_setup # For LLVM_SLOT init.  Must be explicitly called or it is blank.
	rocm_pkg_setup
}

src_prepare() {
	# "hcc" is deprecated.  The new platform is "rocclr".
	sed \
		-e "/HIP_PLATFORM STREQUAL/s,hcc,rocclr," \
		-i \
		cmake/VerifyCompiler.cmake \
		|| die

	# Disable downloading googletest and googlebenchmark
	sed -r \
		-e '/Downloading/{:a;N;/\n *\)$/!ba; d}' \
		-i \
		cmake/Dependencies.cmake \
		|| die

	# Remove GIT dependency
	sed -r \
		-e '/find_package\(Git/{:a;N;/\nendif/!ba; d}' \
		-i \
		cmake/Dependencies.cmake \
		|| die

	# Install benchmark files
	if use benchmark; then
		sed \
			-e "/get_filename_component/s,\${BENCHMARK_SOURCE},${PN}_\${BENCHMARK_SOURCE}," \
			-e "/add_executable/a\  install(TARGETS \${BENCHMARK_TARGET})" \
			-i \
			benchmark/CMakeLists.txt \
			|| die
	fi

	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	addpredict /dev/kfd
	addpredict /dev/dri/

	export CC="${HIP_CC:-hipcc}"
	export CXX="${HIP_CXX:-hipcc}"

	local mycmakeargs=(
		-DBUILD_BENCHMARK=$(usex benchmark ON OFF)
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DBUILD_TEST=$(usex test ON OFF)
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DSKIP_RPATH=ON
		-DUSE_HIP_CPU=$(usex hip-cpu ON OFF)
	)

	if use hip-cpu ; then
		mycmakeargs+=(
			-DBUILD_HIPRAND=OFF
			-Dhip_cpu_rt_DIR="${ESYSROOT}/usr/lib/hip-cpu/share/hip_cpu_rt/cmake"
		)
		export CC="gcc"
		export CXX="g++"
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)
	fi
	cmake_src_configure
}

src_test() {
	check_amdgpu
	MAKEOPTS="-j1" \
	cmake_src_test
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
