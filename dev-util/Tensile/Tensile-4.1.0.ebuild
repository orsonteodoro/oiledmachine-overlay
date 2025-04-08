# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO:
# Fix configure time error

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
#	gfx1031
)
CMAKE_USE_DIR="${WORKDIR}/${PN}-rocm-${PV}/${PN}/Source"
DISTUTILS_USE_PEP517="setuptools"
LLVM_SLOT=12
PYTHON_COMPAT=( "python3_"{9..11} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit check-glibcxx-ver cmake distutils-r1 prefix rocm toolchain-funcs

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/Tensile/archive/rocm-${PV}.tar.gz
	-> rocm-Tensile-${PV}.tar.gz
https://github.com/littlewu2508/littlewu2508.github.io/raw/main/gentoo-distfiles/${PN}-5.0.2-PR1419.patch.gz
"
# #1419 - Remove no longer supported benchmarking steps

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
# MIT - HostLibraryTests/testlib/include/GEMMKernelTest.hpp
# MIT - LICENSE.md
# The distro's MIT license template does not contain all rights reserved.
# Not compatible with recent versions of pytest \
RESTRICT="test"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="client cuda +opencl +openmp +rocm ebuild_revision_18"
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
RDEPEND="
	${PYTHON_DEPS}
	${ROCM_CLANG_DEPEND}
	>=dev-cpp/msgpack-cxx-6.0.0
	dev-lang/python-exec:rocm-${ROCM_SLOT}
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	~dev-util/hip-${PV}:${ROCM_SLOT}[cuda?,rocm?]
	client? (
		dev-libs/boost
		~dev-util/rocm-smi-${PV}:${ROCM_SLOT}
	)
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
	)
	rocm? (
		opencl? (
			dev-libs/rocm-opencl-runtime:${ROCM_SLOT}
		)
		openmp? (
			sys-libs/llvm-roc-libomp:${ROCM_SLOT}[${LLVM_ROC_LIBOMP_4_1_AMDGPU_USEDEP}]
		)
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIPCC_DEPEND}
	>=dev-build/cmake-3.13
"
_PATCHES=(
	"${FILESDIR}/${PN}-4.5.2-change-cmake-name-for-msgpack-cxx-6-release.patch"
	"${FILESDIR}/${PN}-4.1.0-output-commands.patch"
#	"${FILESDIR}/${PN}-4.5.2-gfx1031.patch"
	"${FILESDIR}/${PN}-5.0.2-fix-arch-parse.patch"
	"${FILESDIR}/${PN}-5.0.2-use-ninja.patch"
	"${FILESDIR}/${PN}-4.1.0-hardcoded-paths.patch"
	"${FILESDIR}/${PN}-4.5.2-fix-msgpack-c-linking.patch"
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
			-e "/chmod 755/d" \
			-i \
			"Source/TensileCreateLibrary.cmake" \
			|| die # remove chmod 755 on
		sed \
			-e "/HipClangVersion/s/0,0,0/${PV}/" \
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
	addpredict "/dev/kfd"
	rocm_set_default_hipcc

	if use rocm ; then
		append-ldflags \
			-Wl,-L"/opt/rocm-${ROCM_VERSION}/llvm/$(rocm_get_libdir)" \
			-Wl,-lLLVMSupport
		if has_version "dev-util/hip:${ROCM_SLOT}[rocm]" ; then
			append-ldflags \
				-Wl,-lhsa-runtime64 \
				-Wl,-lamd_comgr
		fi
	fi
	if has_version "dev-util/hip:${ROCM_SLOT}[numa]" ; then
		append-ldflags -Wl,-lnuma
	fi

	export TENSILE_ROCM_ASSEMBLER_PATH="${ESYSROOT}${EROCM_LLVM_PATH}/bin/clang++"
	export TENSILE_ROCM_OFFLOAD_BUNDLER_PATH="${ESYSROOT}${EROCM_LLVM_PATH}/bin/clang-offload-bundler"

	distutils-r1_src_configure

	if use client; then
		check_pkg_glibcxx "dev-libs/boost" "/usr/$(get_libdir)/libboost_program_options.so" "${HIP_4_1_GLIBCXX}"

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
		"ReplacementKernels" \
		"ReplacementKernels-cov3" \
		"Source"
	insinto "${EROCM_PATH}/$(rocm_get_libdir)/cmake/${PN}"
	doins "cmake/"*".cmake"
	rocm_mv_docs

	cp -aT \
		"${ED}/usr/bin" \
		"${ED}/${EROCM_PATH}/bin" \
		|| die
	rm -rf "${ED}/usr/bin" || die
	use client || ewarn "The symlinks require the client USE flag."
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
