# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx942
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1151
	gfx1200
	gfx1201
)
AMDGPU_TARGETS_AOT=(
	gfx906
	gfx908
	gfx90a
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
CUDA_TARGETS_COMPAT=(
# Likely arbitrary chosen set, not same as upstream, to unbreak selection from ancestor package
	sm_60
	sm_70
	sm_75
	compute_60
	compute_70
	compute_75
)
CHECKREQS_DISK_BUILD="7G"
HIP_SUPPORT_CUDA=1
LLVM_SLOT=19
PYTHON_COMPAT=( "python3_12" )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake check-reqs edo flag-o-matic multiprocessing python-r1 rocm

KEYWORDS="~amd64"
S="${WORKDIR}/rocFFT-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/rocFFT/archive/rocm-${PV}.tar.gz
	-> rocFFT-${PV}.tar.gz
"

DESCRIPTION="Next generation FFT implementation for ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocFFT"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
"
# The distro's MIT license template does not have All rights reserved.
RESTRICT="
	!test? (
		test
	)
"
SLOT="0/${ROCM_SLOT}"
IUSE="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
+aot benchmark cuda perfscripts +rocm test ebuild_revision_13
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
	${PYTHON_REQUIRED_USE}
	aot? (
		rocm
		|| (
			${AMDGPU_TARGETS_AOT[@]/#/amdgpu_targets_}
		)
	)
	cuda? (
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	perfscripts? (
		benchmark
	)
	rocm? (
		${ROCM_REQUIRED_USE}
	)
	^^ (
		rocm
		cuda
	)
"
# RDEPEND: perfscripts? dev-python/plotly[${PYTHON_USEDEP}] # currently masked by arch/amd64/x32/package.mask
RDEPEND="
	${PYTHON_DEPS}
	>=dev-db/sqlite-3.36
	>=dev-util/hip-${PV}:${ROCM_SLOT}[cuda?,rocm?]
	dev-util/hip:=
	>=sci-libs/rocRAND-${PV}:${ROCM_SLOT}[${ROCRAND_7_0_AMDGPU_USEDEP}]
	sci-libs/rocRAND:=
	cuda? (
		${HIP_CUDA_DEPEND}
	)
	perfscripts? (
		>=media-gfx/asymptote-2.61
		dev-tex/latexmk
		dev-texlive/texlive-latex
		sys-apps/texinfo
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/sympy[${PYTHON_USEDEP}]
	)
"
DEPEND="
	${PYTHON_DEPS}
"
BDEPEND="
	${HIPCC_DEPEND}
	>=dev-build/cmake-3.16
	sys-devel/binutils[gold,plugins]
	>=dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
	dev-build/rocm-cmake:=
	test? (
		>=dev-cpp/gtest-1.11.0
		>=sci-libs/fftw-3
		dev-libs/boost
		>=dev-libs/rocm-opencl-runtime-${PV}:${ROCM_SLOT}
		dev-libs/rocm-opencl-runtime:=
		>=sys-libs/llvm-roc-libomp-${PV}:${ROCM_SLOT}[${LLVM_ROC_LIBOMP_7_0_AMDGPU_USEDEP}]
		sys-libs/llvm-roc-libomp:=
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-5.1.3-add-stdexcept-header.patch"
)

required_mem() {
	if use test; then
		echo "52G"
	else
		if [[ -n "${AMDGPU_TARGETS}" ]]; then
	# Count how many archs user specified in ${AMDGPU_TARGETS}
			local NARCH=$(( \
				$(awk -F";" \
					'{print NF-1}' \
					<<< "${AMDGPU_TARGETS}" \
				|| die) + 1 \
			))
		else
	# The number below is the default number of AMDGPU_TARGETS for rocFFT-4.3.0.
	# It may change in the future.
			local NARCH=7
		fi

	# This is a linear function estimating how much memory is required.
		echo "$(($(makeopts_jobs)*${NARCH}*25+2200))M"
	fi
}

pkg_pretend() {
	return # leave the disk space check to pkg_setup phase
}

pkg_setup() {
	export CHECKREQS_MEMORY=$(required_mem)
	check-reqs_pkg_setup
	python_setup
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

get_cuda_arch() {
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		if use cuda_targets_${x} ; then
			echo "cuda_targets_${x}"
			break
		fi
	done
}

src_configure() {
	addpredict "/dev/kfd"
	addpredict "/dev/dri/"

	# Fix errror for
# local memory (23068672) exceeds limit (65536) in function '_Z17transpose_kernel2I15HIP_vector_typeIfLj2EE6planarIS1_E11interleavedIS1_ELm64ELm16ELb1ELi0ELi1ELb0ELb0ELb0EL12CallbackType1EEvT0_T1_PKT_PmSC_SC_PvSD_jSD_SD_'
	replace-flags '-O0' '-O1'

	local mycmakeargs=(
		-DBUILD_CLIENTS_RIDER=$(usex benchmark ON OFF)
		-DBUILD_CLIENTS_SELFTEST=$(usex test ON OFF)
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DCMAKE_INSTALL_INCLUDEDIR="include"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DCMAKE_SKIP_RPATH=ON
		-DPYTHON3_EXE="${EPYTHON}"
		-DSQLITE_USE_SYSTEM_PACKAGE=ON
		-DUSE_CUDA=$(use cuda ON OFF)
		-Wno-dev
	)

	if use cuda ; then
		export CUDA_PATH="${ESYSROOT}/opt/cuda"
		export HIP_PLATFORM="nvidia"
		mycmakeargs+=(
			-DCUDA_PREFIX="${ESYSROOT}/opt/cuda"
			-DCUDA_ARCH=$(get_cuda_arch)
			-DHIP_COMPILER="nvcc"
			-DHIP_PLATFORM="nvidia"
			-DHIP_RUNTIME="cuda"
		)
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
			-DROCFFT_KERNEL_CACHE_ENABLE=$(usex aot ON OFF)
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)
	fi
	rocm_set_default_hipcc

	# Fixes
	# error: undefined reference due to --no-allow-shlib-undefined: numa_sched_setaffinity
	# error: undefined reference due to --no-allow-shlib-undefined: hsa_amd_signal_value_pointer
	# error: undefined reference due to --no-allow-shlib-undefined: amd_comgr_do_action
	# >>> referenced by /opt/rocm-5.7.1/lib/libhiprtc.so
	if has_version "dev-util/hip:0/${ROCM_SLOT}[numa]" ; then
		append-ldflags -lnuma
	fi
	if has_version "dev-util/hip:0/${ROCM_SLOT}[rocm]" ; then
		append-ldflags -lhsa-runtime64
	fi
	if has_version "dev-util/hip:0/${ROCM_SLOT}[lc]" ; then
		append-ldflags -lamd_comgr
	fi

	rocm_src_configure
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}/clients/staging" || die
	export LD_LIBRARY_PATH="${BUILD_DIR}/library/src/:${BUILD_DIR}/library/src/device"
	edob "./${PN,,}-test"
	edob "./${PN,,}-selftest"
}

src_install() {
	cmake_src_install

	if use benchmark ; then
		cd "${BUILD_DIR}/clients/staging" || die
		dobin *"rider"
	fi

	if use perfscripts ; then
		cd "${S}/scripts/perf" || die
		python_foreach_impl \
			python_doexe \
				"rocfft-perf"
		python_moduleinto \
			"${PN}_perflib"
		python_foreach_impl \
			python_domodule \
				"perflib/"*".py"
		insinto "/usr/share/${PN}-perflib"
		doins \
			*".asy" \
			"suites.py"
	fi
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  build-without-problems
