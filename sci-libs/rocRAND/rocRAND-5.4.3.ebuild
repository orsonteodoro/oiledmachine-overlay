# Copyright 1999-2025 Gentoo Authors
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
	gfx1100
	gfx1102
)
CUDA_TARGETS_COMPAT=(
	auto

# Same as rocFFT
	sm_60
	sm_70
	sm_75
	compute_60
	compute_70
	compute_75
)
HIPRAND_COMMIT="125d691d3bcc6de5f5d63cf5f5a993c636251208"
HIP_SUPPORT_CUDA=1
LLVM_SLOT=15
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake flag-o-matic rocm

KEYWORDS="~amd64"
S="${WORKDIR}/rocRAND-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/${PN}/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/ROCmSoftwarePlatform/hipRAND/archive/${HIPRAND_COMMIT}.tar.gz
	-> hipRAND-${HIPRAND_COMMIT}.tar.gz
"

DESCRIPTION="Generate pseudo-random and quasi-random numbers"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocRAND"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
"
# The distro's license template does not have All rights reserved.
RESTRICT="
	!test? (
		test
	)
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
benchmark cuda +rocm test ebuild_revision_10
"
gen_cuda_required_use() {
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		echo "
			cuda_targets_${x}? (
				cuda
			)
		"
	done
}
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
	$(gen_cuda_required_use)
	$(gen_rocm_required_use)
	cuda? (
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	rocm? (
		${ROCM_REQUIRED_USE}
	)
	^^ (
		rocm
		cuda
	)
"
RDEPEND="
	~dev-util/hip-${PV}:${ROCM_SLOT}[cuda?,rocm?]
	cuda? (
		${HIP_CUDA_DEPEND}
	)
"
DEPEND="
	${RDEPEND}
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
	test? (
		dev-cpp/gtest
	)
"
BDEPEND="
	${HIPCC_DEPEND}
	>=dev-build/cmake-3.10.2
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
"
PATCHES=(
	"${FILESDIR}/${PN}-5.1.3-hardcoded-paths.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	rmdir hipRAND || die
	mv -v \
		../hipRAND-${HIPRAND_COMMIT} \
		hipRAND \
		|| die

	# Removed the GIT dependency.
	sed \
		-e "/find_package(Git/,+4d" \
		-i \
		cmake/Dependencies.cmake \
		|| die

	if use cuda ; then
		local badflags=(
			"-Wno-unknown-pragmas"
			"-Wall"
			"-Wextra"
		)
		local
		for flag in ${badflags[@]} ; do
			sed -i \
				-e "s|${flag}||g" \
				$(grep -l -r -e "${flag}" "${WORKDIR}") \
				|| die
		done
	fi

	cmake_src_prepare
	rocm_src_prepare
}

get_nvgpu_targets() {
	local list
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		if use cuda_targets_${x} ; then
			list+=";${x#*_}"
		fi
	done
	list="${list:1}"
	echo "${list}"
}

src_configure() {
	addpredict "/dev/kfd"
	addpredict "/dev/dri/"
	local mycmakeargs=(
		-DBUILD_BENCHMARK=$(usex benchmark ON OFF)

	# Fixes:
	# rocrand.cpp:1904:16: error: use of undeclared identifier 'ROCRAND_VERSION'
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF

		-DBUILD_TEST=$(usex test ON OFF)
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DCMAKE_SKIP_RPATH=ON
	)

	if use cuda ; then
		export CUDA_PATH="${ESYSROOT}/opt/cuda"
		export HIP_PLATFORM="nvidia"
		mycmakeargs+=(
			-DBUILD_HIPRAND=ON
			-DDISABLE_WERROR=ON
			-DHIP_COMPILER="nvcc"
			-DHIP_PLATFORM="nvidia"
			-DHIP_RUNTIME="cuda"
		)
		if use cuda_targets_auto ; then
			mycmakeargs+=(
			)
		else
			mycmakeargs+=(
				-DNVGPU_TARGETS=$(get_nvgpu_targets)
			)
		fi
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
			-DBUILD_HIPRAND=ON
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)
	fi
	rocm_set_default_hipcc
	rocm_src_configure
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
		cd "${BUILD_DIR}/benchmark"
		dobin "benchmark_rocrand_"*
	fi
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
