# Copyright 1999-2023 Gentoo Authors
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
CHECKREQS_DISK_BUILD="7G"
LLVM_MAX_SLOT=15
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
IUSE="benchmark perfscripts test"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	${ROCM_REQUIRED_USE}
	perfscripts? (
		benchmark
	)
"
# RDEPEND: perfscripts? dev-python/plotly[${PYTHON_USEDEP}] # currently masked by arch/amd64/x32/package.mask
RDEPEND="
	${PYTHON_DEPS}
	>=dev-db/sqlite-3.36
	~dev-util/hip-${PV}:${SLOT}
	~sci-libs/rocRAND-${PV}:${SLOT}
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

src_configure() {
	addpredict /dev/kfd
	addpredict /dev/dri/

	# Fix errror for
# local memory (23068672) exceeds limit (65536) in function '_Z17transpose_kernel2I15HIP_vector_typeIfLj2EE6planarIS1_E11interleavedIS1_ELm64ELm16ELb1ELi0ELi1ELb0ELb0ELb0EL12CallbackType1EEvT0_T1_PKT_PmSC_SC_PvSD_jSD_SD_'
	replace-flags '-O0' '-O1'

	local mycmakeargs=(
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_CLIENTS_RIDER=$(usex benchmark ON OFF)
		-DBUILD_CLIENTS_SELFTEST=$(usex test ON OFF)
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocFFT/"
		-DCMAKE_SKIP_RPATH=On
		-DPYTHON3_EXE=${EPYTHON}
		-DSQLITE_USE_SYSTEM_PACKAGE=ON
		-Wno-dev
	)

	CXX=hipcc \
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
