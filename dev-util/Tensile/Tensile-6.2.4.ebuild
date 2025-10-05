# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx1010
	gfx1011
	gfx1012
	gfx1030
	gfx1031
	gfx1032
	gfx1034
	gfx1035
	gfx1100
	gfx1101
	gfx1102
)
CMAKE_USE_DIR="${WORKDIR}/${PN}-rocm-${PV}/${PN}/Source"
DISTUTILS_USE_PEP517="setuptools"
GCC_COMPAT=(
	"gcc_slot_9_1" # Equivalent to GLIBCXX 3.4.26 in prebuilt binary for U20
	"gcc_slot_12_5" # Equivalent to GLIBCXX 3.4.30 in prebuilt binary for U22
	"gcc_slot_13_4" # Equivalent to GLIBCXX 3.4.32 in prebuilt binary for U24
)
LLVM_SLOT=18
PYTHON_COMPAT=( "python3_12" )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit cmake distutils-r1 libstdcxx-slot prefix rocm toolchain-funcs

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/Tensile/archive/rocm-${PV}.tar.gz
	-> rocm-Tensile-${PV}.tar.gz
"

DESCRIPTION="Stretching GPU performance for GEMMs and tensor contractions"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/Tensile"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	MIT
"
# all-rights-reserved MIT - Tensile/Utils.py
# all-rights-reserved MIT - HostLibraryTests/testlib/include/GEMMKernelTest.hpp
# MIT - LICENSE.md
# The distro's MIT license template does not contain all rights reserved.
# Not compatible with recent versions of pytest \
RESTRICT="test"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="+client cuda +opencl +openmp +rocm ebuild_revision_18"
REQUIRED_USE="
	client? (
		${ROCM_REQUIRED_USE}
		openmp
	)
	|| (
		cuda
		rocm
	)
"
# dev-util/hip[numa] applied to prevent:
#    ld.lld: error: undefined reference due to --no-allow-shlib-undefined: numa_sched_setaffinity
#    >>> referenced by /opt/rocm-6.2.4/lib/libamdhip64.so
RDEPEND="
	${PYTHON_DEPS}
	${ROCM_CLANG_DEPEND}
	>=dev-cpp/msgpack-cxx-6.0.0
	dev-lang/python-exec:rocm-${ROCM_SLOT}
	dev-python/joblib[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	~dev-util/hip-${PV}:${ROCM_SLOT}[cuda?,numa,rocm?]
	client? (
		dev-libs/boost[${LIBSTDCXX_USEDEP}]
		dev-libs/boost:=
		~dev-util/rocm-smi-${PV}:${ROCM_SLOT}
	)
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
	)
	rocm? (
		~dev-libs/rocm-comgr-${PV}:${ROCM_SLOT}
		~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
		opencl? (
			dev-libs/rocm-opencl-runtime:${ROCM_SLOT}
		)
		openmp? (
			sys-libs/llvm-roc-libomp:${ROCM_SLOT}[${LLVM_ROC_LIBOMP_6_2_AMDGPU_USEDEP}]
		)
	)

	sys-process/numactl
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIPCC_DEPEND}
	>=dev-build/cmake-3.13
"
_PATCHES=(
	"${FILESDIR}/${PN}-5.6.0-output-commands.patch"
	"${FILESDIR}/${PN}-5.4.2-fix-arch-parse.patch"
	"${FILESDIR}/${PN}-5.4.2-use-ninja.patch"
#	"${FILESDIR}/${PN}-5.7.1-avoid-hipcc-bat.patch"
	"${FILESDIR}/${PN}-5.3.3-hardcoded-paths.patch"
)

pkg_setup() {
	python_setup
	rocm_pkg_setup
}

src_prepare() {
	eapply "${_PATCHES[@]}"
	distutils-r1_src_prepare

	pushd "${PN}" || die
		sed \
			-r \
			-e "/TENSILE_USE_LLVM/s/ON/OFF/" \
			-i \
			"Source/CMakeLists.txt" \
			|| die
		sed \
			-e "/HipClangVersion/s/0.0.0/${PV}/" \
			-i \
			"Common.py" \
			|| die
	popd || die

	sed \
		-e "/package_data/d" \
		-e "/data_files/d" \
		-i \
		"setup.py" \
		|| die

	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	rocm_set_default_hipcc

	if ver_test $(gcc-major-version) -ne "13" ; then
ewarn
ewarn "GCC 13 may be required to build ${PN}.  If configure test failure, do"
ewarn
ewarn "eselect gcc set x86_64-pc-linux-gnu-13"
ewarn "source /etc/profile"
ewarn
	fi

	if use rocm ; then
		append-ldflags \
			-Wl,-L"/opt/rocm-${ROCM_VERSION}/llvm/$(rocm_get_libdir)" \
			-Wl,-lLLVMSupport
		if has_version "dev-util/hip:${ROCM_SLOT}[rocm]" ; then
			append-flags -Wl,-lhsa-runtime64
			append-ldflags -Wl,-lhsa-runtime64
		fi
		if has_version "dev-util/hip:${ROCM_SLOT}[lc]" ; then
			append-flags -Wl,-lamd_comgr
			append-ldflags -Wl,-lamd_comgr
		fi
	fi
	if has_version "dev-util/hip:${ROCM_SLOT}[numa]" ; then
		append-flags -Wl,-lnuma
		append-ldflags -Wl,-lnuma
	fi

	export TENSILE_ROCM_ASSEMBLER_PATH="${ESYSROOT}${EROCM_LLVM_PATH}/bin/clang++"
	export TENSILE_ROCM_OFFLOAD_BUNDLER_PATH="${ESYSROOT}${EROCM_LLVM_PATH}/bin/clang-offload-bundler"

	distutils-r1_src_configure

	if use client; then
		local mycmakeargs=(
			-DCMAKE_SKIP_RPATH=ON
			-DROCM_ROOT="${ROCM_PATH}"
			-DTENSILE_BUILD_CLIENT=$(usex client ON OFF)
			-DTENSILE_USE_LLVM=ON
			-DTENSILE_USE_MSGPACK=ON
			-DTENSILE_USE_OPENCL=$(usex opencl ON OFF)
			-DTENSILE_USE_OPENMP=$(usex openmp ON OFF)
			-DTensile_LIBRARY_FORMAT="msgpack"
		)
		if use cuda ; then
			export HIP_PLATFORM="nvidia"
			mycmakeargs+=(
				-DHIP_COMPILER="nvcc"
				-DHIP_PLATFORM="nvidia"
				-DHIP_RUNTIME="cuda"
			)
		elif use rocm ; then
			export HIP_PLATFORM="amd"
			mycmakeargs+=(
				-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
				-DHIP_COMPILER="clang"
				-DHIP_PLATFORM="amd"
				-DHIP_RUNTIME="rocclr"
			)
		fi
		rocm_src_configure
	fi
}

src_compile() {
	distutils-r1_src_compile
	use client && cmake_src_compile
}

python_install() {
	distutils-r1_python_install
	python_moduleinto "Tensile"
	cd "Tensile" || die
	python_domodule "Components"
	python_newexe "Utilities/merge.py" "${PN}-merge"

	dodir "${EROCM_PATH}/lib/python-exec/${EPYTHON}"
	cp -aT \
		"${ED}/usr/lib/python-exec/${EPYTHON}" \
		"${ED}${EROCM_PATH}/lib/python-exec/${EPYTHON}" \
		|| die
	rm -rf "${ED}/usr/lib/python-exec/${EPYTHON}" || die

	dodir "${EROCM_PATH}/lib/${EPYTHON}/site-packages"
	cp -aT \
		"${ED}/usr/lib/${EPYTHON}/site-packages" \
		"${ED}${EROCM_PATH}/lib/${EPYTHON}/site-packages" \
		|| die
	rm -rf "${ED}/usr/lib/${EPYTHON}/site-packages" || die
}

src_install() {
	distutils-r1_src_install
	cd "${PN}" || die
	insinto "${EROCM_PATH}/lib/${EPYTHON}/site-packages/${PN}"
	doins -r \
		"Configs" \
		"CustomKernels" \
		"Perf" \
		"Source"
	insinto "${EROCM_PATH}/$(rocm_get_libdir)/cmake/${PN}"
	doins "cmake/"*".cmake"
	if use client; then
		pushd "${BUILD_DIR}" || die
		dobin "client/tensile_client"
	fi
	rocm_mv_docs

	cp -aT \
		"${ED}/usr/bin" \
		"${ED}/${EROCM_PATH}/bin" \
		|| die
	rm -rf "${ED}/usr/bin" || die
	use client || ewarn "The symlinks require the client USE flag."
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
