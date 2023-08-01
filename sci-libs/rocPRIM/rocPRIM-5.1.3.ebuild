# Copyright 1999-2022 Gentoo Authors
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
SLOT="0/$(ver_cut 1-2)"
IUSE="benchmark test"
REQUIRED_USE="
	${ROCM_REQUIRED_USE}
"
RDEPEND="
	~dev-util/hip-${PV}:${SLOT}[rocm]
	benchmark? (
		dev-cpp/benchmark
	)
	test? (
		dev-cpp/gtest
	)
"
BDEPEND="
	>=dev-util/cmake-3.16
	~dev-util/rocm-cmake-${PV}:${SLOT}
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

pkg_setup() {
	llvm_pkg_setup # For LLVM_SLOT init.  Must be explicitly called or it is blank.
}

src_prepare() {
	# "hcc" is depcreated, new platform ist "rocclr"
	sed \
		-e "/HIP_PLATFORM STREQUAL/s,hcc,rocclr," \
		-i \
		cmake/VerifyCompiler.cmake \
		|| die

	# Install according to FHS
	sed \
		-e "/PREFIX rocprim/d" \
		-e "/INSTALL_INTERFACE/s,rocprim/include,include/rocprim," \
		-e "/DESTINATION/s,rocprim/include,include," \
		-e "/rocm_install_symlink_subdir(rocprim)/d" \
		-i \
		rocprim/CMakeLists.txt \
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

	eapply_user
	cmake_src_prepare
}

src_configure() {
	addpredict /dev/kfd
	addpredict /dev/dri/

	local mycmakeargs=(
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_BENCHMARK=$(usex benchmark ON OFF)
		-DBUILD_TEST=$(usex test ON OFF)
		-DSKIP_RPATH=On
	)

	CXX=hipcc \
	cmake_src_configure
}

src_test() {
	check_amdgpu
	MAKEOPTS="-j1" \
	cmake_src_test
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
