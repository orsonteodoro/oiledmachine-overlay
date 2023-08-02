# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx1030
	gfx1100
	gfx1101
	gfx1102
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
	sm_60
	sm_70
	sm_75
	compute_60
	compute_70
	compute_75
)
CHECKREQS_DISK_BUILD="7G"
LLVM_MAX_SLOT=16
PYTHON_COMPAT=( python3_{9..10} )
ROCM_VERSION="${PV}"

inherit cmake check-reqs edo flag-o-matic llvm multiprocessing python-r1 rocm

SRC_URI="
https://github.com/ROCmSoftwarePlatform/rocFFT/archive/rocm-${PV}.tar.gz
	-> rocFFT-${PV}.tar.gz
"

DESCRIPTION="Next generation FFT implementation for ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocFFT"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
+aot benchmark cuda perfscripts +rocm test
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
	~dev-util/hip-${PV}:${SLOT}[cuda?,rocm?]
	~sci-libs/rocRAND-${PV}:${SLOT}
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
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
	>=dev-util/cmake-3.16
	~dev-util/rocm-cmake-${PV}:${SLOT}
	test? (
		>=dev-cpp/gtest-1.11.0
		>=sci-libs/fftw-3
		>=sys-libs/libomp-${LLVM_MAX_SLOT}
		dev-libs/boost
	)
"
RESTRICT="
	!test? (
		test
	)
"
S="${WORKDIR}/rocFFT-rocm-${PV}"
PATCHES=(
#	"${FILESDIR}/${PN}-4.2.0-add-functional-header.patch"
#	"${FILESDIR}/${PN}-5.0.2-add-math-header.patch"
	"${FILESDIR}/${PN}-5.1.3-add-stdexcept-header.patch"
	"${FILESDIR}/${PN}-5.3.3-lib64-path.patch"
	"${FILESDIR}/${PN}-5.5.1-aot-optional.patch"
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
	llvm_pkg_setup # For LLVM_SLOT init.  Must be explicitly called or it is blank.
}

src_prepare() {
	sed \
		-e "s/PREFIX rocfft//" \
		-e "/rocm_install_symlink_subdir/d" \
		-e "/<INSTALL_INTERFACE/s,include,include/rocFFT," \
		-i \
		library/src/CMakeLists.txt \
		|| die

	sed \
		-e "/rocm_install_symlink_subdir/d" \
		-e "$!N;s:PREFIX\n[ ]*rocfft:# PREFIX rocfft\n:;P;D" \
		-i library/src/device/CMakeLists.txt \
		|| die

	if use perfscripts; then
		pushd scripts/perf || die
		sed \
			-e "/\/opt\/rocm/d" \
			-e "/rocmversion/s,rocm_info.strip(),\"${PV}\"," \
			-i \
			perflib/specs.py \
			|| die
		sed \
			-e "/^top/,+1d" \
			-i \
			rocfft-perf suites.py \
			|| die
		sed \
			-e "s,perflib,${PN}_perflib,g" \
			-i \
			rocfft-perf \
			suites.py \
			perflib/*.py \
			|| die
		sed \
			-e "/^top = /s,__file__).*$,\"${EPREFIX}/usr/share/${PN}-perflib\")," \
			-i \
			perflib/pdf.py \
			perflib/generators.py \
			|| die
		popd
	fi

	cmake_src_prepare
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
	addpredict /dev/kfd
	addpredict /dev/dri/

	# Fix errror for
# local memory (23068672) exceeds limit (65536) in function '_Z17transpose_kernel2I15HIP_vector_typeIfLj2EE6planarIS1_E11interleavedIS1_ELm64ELm16ELb1ELi0ELi1ELb0ELb0ELb0EL12CallbackType1EEvT0_T1_PKT_PmSC_SC_PvSD_jSD_SD_'
	replace-flags '-O0' '-O1'

	local mycmakeargs=(
		-DBUILD_CLIENTS_RIDER=$(usex benchmark ON OFF)
		-DBUILD_CLIENTS_SELFTEST=$(usex test ON OFF)
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocFFT/"
		-DCMAKE_SKIP_RPATH=ON
		-DPYTHON3_EXE="${EPYTHON}"
		-DSQLITE_USE_SYSTEM_PACKAGE=ON
		-DUSE_CUDA=$(use cuda ON OFF)
		-Wno-dev
	)

	if use cuda ; then
		local s=11
		strip-flags
		filter-flags \
			-pipe \
			-Wl,-O1 \
			-Wl,--as-needed \
			-Wno-unknown-pragmas
		if [[ "${HIP_CXX}" == "nvcc" ]] ; then
			append-cxxflags -ccbin "${EPREFIX}/usr/${CHOST}/gcc-bin/${s}/${CHOST}-g++"
		fi
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
			-DBUILD_AOT=$(usex aot ON OFF)
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)
	fi
	CXX="${HIP_CXX:-hipcc}" \
	cmake_src_configure
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}/clients/staging" || die
	export LD_LIBRARY_PATH="${BUILD_DIR}/library/src/:${BUILD_DIR}/library/src/device"
	edob ./${PN,,}-test
	edob ./${PN,,}-selftest
}

src_install() {
	cmake_src_install

	if use benchmark; then
		cd "${BUILD_DIR}/clients/staging" || die
		dobin *rider
	fi

	if use perfscripts; then
		cd "${S}"/scripts/perf || die
		python_foreach_impl \
			python_doexe \
				"rocfft-perf"
		python_moduleinto \
			"${PN}_perflib"
		python_foreach_impl \
			python_domodule \
				perflib/*.py
		insinto "/usr/share/${PN}-perflib"
		doins *.asy suites.py
	fi
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
