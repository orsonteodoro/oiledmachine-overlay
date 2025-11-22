# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_USE_DIR="${WORKDIR}/${PN}-rocm-${PV}/${PN}/Source"
CXX_STANDARD=17
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
LLVM_SLOT=19
PYTHON_COMPAT=( "python3_12" )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

AMDGPU_TARGETS_COMPAT=(
	"gfx803"
	"gfx900"
	"gfx906_xnack_minus"
	"gfx908_xnack_minus"
	"gfx90a_xnack_minus"
	"gfx1010"
	"gfx1011"
	"gfx1012"
	"gfx1030"
	"gfx1031"
	"gfx1032"
	"gfx1034"
	"gfx1035"
	"gfx1100"
	"gfx1101"
	"gfx1102"
	"gfx1150"
	"gfx1151"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_ROCM_6_4[@]}
)

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
SLOT="0/${ROCM_SLOT}"
IUSE="
+client cuda +opencl +openmp +rocm
ebuild_revision_41
"
REQUIRED_USE="
	${PYTHON_SINGLE_TARGET}
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
	$(python_gen_cond_dep '
		dev-python/joblib[${PYTHON_USEDEP}]
		dev-python/msgpack[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
	>=dev-cpp/msgpack-cxx-6.0.0
	dev-cpp/msgpack-cxx:=
	dev-lang/python-exec
	~dev-util/hip-${PV}:${SLOT}[${LIBSTDCXX_USEDEP},cuda?,numa,rocm?]
	dev-util/hip:=
	virtual/hsa-code-object-version:=
	client? (
		dev-libs/boost[${LIBSTDCXX_USEDEP}]
		dev-libs/boost:=
		~dev-util/rocm-smi-${PV}:${SLOT}[${LIBSTDCXX_USEDEP}]
		dev-util/rocm-smi:=
	)
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
	)
	rocm? (
		~dev-libs/rocm-comgr-${PV}:${SLOT}[${LIBSTDCXX_USEDEP}]
		dev-libs/rocm-comgr:=
		~dev-libs/rocr-runtime-${PV}:${SLOT}[${LIBSTDCXX_USEDEP}]
		dev-libs/rocr-runtime:=
		opencl? (
			dev-libs/rocm-opencl-runtime:${SLOT}[${LIBSTDCXX_USEDEP}]
			dev-libs/rocm-opencl-runtime:=
		)
		openmp? (
			sys-libs/llvm-roc-libomp:${SLOT}[${LIBSTDCXX_USEDEP},${LLVM_ROC_LIBOMP_6_4_AMDGPU_USEDEP}]
			sys-libs/llvm-roc-libomp:=
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
#	"${FILESDIR}/${PN}-5.6.0-output-commands.patch"
	"${FILESDIR}/${PN}-5.4.2-fix-arch-parse.patch"
#	"${FILESDIR}/${PN}-5.4.2-use-ninja.patch"
#	"${FILESDIR}/${PN}-5.7.1-avoid-hipcc-bat.patch"
	"${FILESDIR}/${PN}-6.4.4-link-llvm.patch"
	"${FILESDIR}/${PN}-6.4.4-fix-llvm-default-path.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
	rocm_pkg_setup
	libstdcxx-slot_verify
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

get_hsa_object_code_version() {
	has_version "virtual/hsa-code-object-version" || die "Missing"
	if has_version "virtual/hsa-code-object-version[hsa-code-object-v4]" ; then
		echo "V4"
	elif has_version "virtual/hsa-code-object-version[hsa-code-object-v5]" ; then
		echo "V5"
	else
		echo "V4"
	fi
}

src_configure() {
	rocm_set_default_hipcc

	export TENSILE_ROCM_ASSEMBLER_PATH="${ESYSROOT}${EROCM_LLVM_PATH}/bin/clang++"
	export TENSILE_ROCM_OFFLOAD_BUNDLER_PATH="${ESYSROOT}${EROCM_LLVM_PATH}/bin/clang-offload-bundler"

	distutils-r1_src_configure

	if use client; then
		local mycmakeargs=(
			-DCMAKE_INSTALL_PREFIX="/usr/lib/Tensile"
			-DCMAKE_SKIP_RPATH=ON
			-DROCM_ROOT="${ROCM_PATH}"
			-DTENSILE_BUILD_CLIENT=$(usex client ON OFF)
			-DTensile_CODE_OBJECT_VERSION=$(get_hsa_object_code_version)
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
	python_moduleinto "${PN}"
	cd "${PN}" || die
	python_domodule "Components"
	python_newexe "Utilities/merge.py" "${PN}-merge"
}

src_install() {
	distutils-r1_src_install
	cd "${PN}" || die
	local libdir=$(get_libdir)

	# Force install into /usr/lib/Tensile install prefix for better
	# unintended install to avoid header conflict between Tensile and
	# TensileLite used in hipBLASLt.
	local install_prefix="/usr/lib/${PN}"
	local sitedir="${install_prefix}/lib/${EPYTHON}/site-packages"

	insinto "${sitedir}/${PN}"
	doins -r \
		"Configs" \
		"CustomKernels" \
		"Perf" \
		"Source" \
		"TensileCreateLib" \
		"Utilities"
	insinto "${install_prefix}/${libdir}/cmake/${PN}"
	doins "cmake/"*".cmake"
	if use client ; then
		pushd "${BUILD_DIR}" || die
		exeinto "${install_prefix}/bin"
		doexe "client/tensile_client"
	fi

	use client || ewarn "The symlinks require the client USE flag."
	rocm_fix_rpath

	if [[ -e "${ED}/usr/share" ]] ; then
		mv \
			"${ED}/usr/share" \
			"${ED}${install_prefix}" \
			|| die
	fi

	if [[ -e "${ED}/usr/${libdir}/cmake" ]] ; then
		dodir "${ED}${install_prefix}/${libdir}"
		mv \
			"${ED}/usr/${libdir}/cmake" \
			"${ED}${install_prefix}/${libdir}/cmake" \
			|| die
	fi

	if [[ -e "${ED}/usr/bin" ]] ; then
		dodir "${install_prefix}/bin"
		mv \
			"${ED}/usr/bin/"* \
			"${ED}${install_prefix}/bin" \
			|| die
	fi

	if [[ -e "${ED}/usr/lib/python-exec/${EPYTHON}/Tensile-merge" ]] ; then
		dodir "/usr/lib/Tensile/lib/python-exec/${EPYTHON}"
		mv \
			"${ED}/usr/lib/python-exec/${EPYTHON}/Tensile-merge" \
			"${ED}/usr/lib/Tensile/lib/python-exec/${EPYTHON}/Tensile-merge" \
			|| die
	fi

	if [[ -e "${ED}/usr/lib/${EPYTHON}/site-packages" ]] ; then
		cp -aT \
			"${ED}/usr/lib/${EPYTHON}/site-packages/" \
			"${ED}/usr/lib/Tensile/lib/${EPYTHON}/site-packages/" \
			|| die
		rm -rf "${ED}/usr/lib/${EPYTHON}/site-packages"
	fi
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
