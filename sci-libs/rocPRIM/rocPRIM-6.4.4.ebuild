# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx908_xnack_plus # with asan
	gfx90a_xnack_minus
	gfx90a_xnack_plus # with or without asan
	gfx942
	gfx942_xnack_plus # with_asan
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1151
	gfx1200
	gfx1201
)
GCC_COMPAT=(
	"gcc_slot_12_5" # Equivalent to GLIBCXX 3.4.30 in prebuilt binary for U22
	"gcc_slot_13_4" # Equivalent to GLIBCXX 3.4.32 in prebuilt binary for U24
)
LLVM_SLOT=19
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit check-compiler-switch cmake flag-o-matic libstdcxx-slot rocm

KEYWORDS="~amd64"
S="${WORKDIR}/rocPRIM-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/rocPRIM/archive/rocm-${PV}.tar.gz
	-> rocPRIM-${PV}.tar.gz
"

DESCRIPTION="HIP parallel primitives for developing performant GPU-accelerated code on ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocPRIM"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	MIT
"
# The distro's MIT license template does not have All rights reserved.
RESTRICT="
	!test? (
		test
	)
"
SLOT="0/${ROCM_SLOT}"
IUSE="
asan -benchmark hip-cpu +rocm test
ebuild_revision_8
"
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
	>=dev-util/hip-${PV}:${SLOT}[rocm]
	dev-util/hip:=
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
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.16
	>=dev-build/rocm-cmake-${PV}:${SLOT}
	dev-build/rocm-cmake:=
	!hip-cpu? (
		${HIPCC_DEPEND}
	)
"
PATCHES=(
)

pkg_setup() {
	check-compiler-switch_start
	rocm_pkg_setup
	libstdcxx-slot_verify # For hip-cpu
}

src_prepare() {
	# "hcc" is deprecated.  The new platform is "rocclr".
	sed \
		-e "/HIP_PLATFORM STREQUAL/s,hcc,rocclr," \
		-i \
		"cmake/VerifyCompiler.cmake" \
		|| die

	# Disable downloading googletest and googlebenchmark
	sed -r \
		-e '/Downloading/{:a;N;/\n *\)$/!ba; d}' \
		-i \
		"cmake/Dependencies.cmake" \
		|| die

	# Remove GIT dependency
	sed -r \
		-e '/find_package\(Git/{:a;N;/\nendif/!ba; d}' \
		-i \
		"cmake/Dependencies.cmake" \
		|| die

	# Install benchmark files
	if use benchmark; then
		sed \
			-e "/get_filename_component/s,\${BENCHMARK_SOURCE},${PN}_\${BENCHMARK_SOURCE}," \
			-e "/add_executable/a\  install(TARGETS \${BENCHMARK_TARGET})" \
			-i \
			"benchmark/CMakeLists.txt" \
			|| die
	fi

	cmake_src_prepare
	rocm_src_prepare
}

check_asan() {
	local ASAN_GPUS=(
		"gfx908_xnack_plus"
		"gfx90a_xnack_plus"
		"gfx942_xnack_plus"
	)
	local found=0
	local x
	for x in ${ASAN_GPUS[@]} ; do
		if use "amdgpu_targets_${x}" ; then
			found=1
		fi
	done
	if (( ${found} == 0 )) && use asan ; then
ewarn "ASan security mitigations for GPU are disabled."
ewarn "ASan is enabled for CPU HOST side but not GPU side for both older and newer GPUs."
ewarn "Pick one of the following for GPU side ASan:  ${ASAN_GPUS[@]/#/amdgpu_targets_}"
	fi
}

src_configure() {
	addpredict "/dev/kfd"
	addpredict "/dev/dri/"

	check_asan

	local mycmakeargs=(
		-DBUILD_ADDRESS_SANITIZER=$(usex asan ON OFF)
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
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
			-DROCM_ROOT="${EROCM_PATH}"
		)
	fi
	if use hip-cpu ; then
		rocm_set_default_gcc
	else
		rocm_set_default_hipcc
	fi

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

src_test() {
	check_amdgpu
	MAKEOPTS="-j1" \
	cmake_src_test
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  build needs test
