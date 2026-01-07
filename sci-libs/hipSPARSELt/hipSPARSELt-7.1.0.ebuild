# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=17
HIP_SUPPORT_CUDA=1
LLVM_SLOT=19
PYTHON_COMPAT=( "python3_12" )
ROCM_SLOT="${PV%.*}"
ROCM_VERSION="${PV}"
ROCM_DEFAULT_LIBDIR="lib64"

AMDGPU_TARGETS_COMPAT=(
	"gfx942"
	"gfx942_xnack_plus" # with asan
	"gfx950"
	"gfx950_xnack_plus" # with asan
        "gfx1100"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	"gcc_slot_14_3"
)

inherit cmake libstdcxx-slot python-single-r1 rocm

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-rocm-${PV}"
SRC_URI="
https://github.com/ROCm/hipSPARSELt/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${PN}-rocm-${PV}.tar.gz
https://github.com/ROCm/rocm-libraries/archive/refs/tags/rocm-${PV}.tar.gz
	-> rocm-libraries-${PV}.tar.gz
"

DESCRIPTION="hipSPARSELt is a SPARSE marshalling library, with multiple supported backends."
HOMEPAGE="https://github.com/ROCm/hipSPARSELt"
REQUIRED_USE="${ROCM_REQUIRED_USE}"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	MIT
"
# all-rights-reserved MIT - cmake/os-detection.cmake
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="test"
SLOT="0/${ROCM_SLOT}"
IUSE="
-asan -cuda rocm -samples -test -benchmark
ebuild_revision_3
"
REQUIRED_USE="
	^^ (
		cuda
		rocm
	)
"
RDEPEND="
	dev-util/hip:${SLOT}[${LIBSTDCXX_USEDEP},cuda?,rocm?]
	dev-util/hip:=
	benchmark? (
		virtual/blas
		virtual/cblas
	)
	rocm? (
		>=sci-libs/hipSPARSE-${PV}:${SLOT}[${LIBSTDCXX_USEDEP}]
		sci-libs/hipSPARSE:=
		virtual/hsa-code-object-version:=
	)
	test? (
		virtual/blas
		virtual/cblas
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIPCC_DEPEND}
	>=dev-build/cmake-3.10.2
	rocm? (
		dev-cpp/msgpack-cxx
		dev-python/joblib[${PYTHON_SINGLE_USEDEP}]
		dev-python/msgpack[${PYTHON_SINGLE_USEDEP}]
		dev-python/nanobind[${PYTHON_SINGLE_USEDEP}]
		dev-python/pyyaml[${PYTHON_SINGLE_USEDEP}]
		dev-python/setuptools[${PYTHON_SINGLE_USEDEP}]
	)
	test? (
		dev-cpp/gtest[${LIBSTDCXX_USEDEP}]
		dev-cpp/gtest:=
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-7.1.0-system-tensile.patch"
	"${FILESDIR}/${PN}-7.1.0-libdir.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
	rocm_pkg_setup
	libstdcxx-slot_verify
}

src_unpack() {
	unpack "${PN}-rocm-${PV}.tar.gz"
	local hipblaslt_dir="rocm-libraries-rocm-${PV}/projects/hipblaslt"
	local origami_dir="rocm-libraries-rocm-${PV}/shared/origami"
	tar -xzf "${DISTDIR}/rocm-libraries-${PV}.tar.gz" \
		"${hipblaslt_dir}" \
		"${origami_dir}" \
		-C "${WORKDIR}" || die
}

src_prepare() {
	if use rocm ; then
		local hipblaslt_dir="${WORKDIR}/rocm-libraries-rocm-${PV}/projects/hipblaslt"
		local origami_dir="${WORKDIR}/rocm-libraries-rocm-${PV}/shared/origami"

		[[ -d "${hipblaslt_dir}" ]] || die "Missing hipBLASLt sources"

		local shebangs=($(grep -rl "#!/usr/bin/env python3" \
			"${hipblaslt_dir}/tensilelite/Tensile" || die))
		python_fix_shebang -q "${shebangs[@]}"

		sed -e "s:\$(ROCM_PATH)/bin/amdclang++:clang++:g" \
			-i "${hipblaslt_dir}/tensilelite/Makefile" || die

		# Fix compiler validation (just a validation)
		sed -e "s/amdclang++/clang++/g" -e "s/amdclang/clang/g" \
			-i "${hipblaslt_dir}/tensilelite/Tensile/Toolchain/Validators.py" \
			-i "${hipblaslt_dir}/tensilelite/Tensile/Tests/unit/test_MatrixInstructionConversion.py" || die

		pushd "${hipblaslt_dir}" >/dev/null || die
		eapply "${FILESDIR}/hipBLASLt-7.1.0-no-git.patch"
		eapply "${FILESDIR}/hipBLASLt-7.1.0-rocisa-nanobind.patch"
		eapply "${FILESDIR}/hipBLASLt-7.1.0-device-compiler.patch"
		popd >/dev/null || die

		pushd "${origami_dir}" >/dev/null || die
		eapply "${FILESDIR}/origami-7.1.0-fix-project.patch"
		popd >/dev/null || die
	fi

	cmake_src_prepare
	rocm_src_prepare
}

check_asan() {
	local ASAN_GPUS=(
		"gfx942_xnack_plus"
		"gfx950_xnack_plus"
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
	check_asan
	local mycmakeargs=(
		-DBUILD_ADDRESS_SANITIZER=$(usex asan)
		-DBUILD_CLIENTS_BENCHMARKS=$(usex benchmark)
		-DBUILD_CLIENTS_SAMPLES=$(usex samples)
		-DBUILD_CLIENTS_TESTS=$(usex test)
		-DBUILD_CUDA=$(usex cuda)
		-DBUILD_GTEST=OFF
	)
	if use cuda ; then
		mycmakeargs+=(
			-DBUILD_WITH_TENSILE=OFF
			-DHIP_COMPILER="nvcc"
			-DHIP_PLATFORM="nvidia"
			-DHIP_RUNTIME="cuda"
		)
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		export ROCM_PATH="/usr"
		local hipblaslt_dir="${WORKDIR}/rocm-libraries-rocm-${PV}/projects/hipblaslt"
		local hipblaslt_targets="$(get_amdgpu_flags)"
		hipblaslt_targets="${hipblaslt_targets//:xnack+/}"
		hipblaslt_targets="${hipblaslt_targets//:xnack-/}"
		hipblaslt_targets="${hipblaslt_targets%;}"
		mycmakeargs+=(
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
			-DBUILD_USE_LOCAL_TENSILE_HIPBLASLT_NEXT_CMAKE=ON
			-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
			-DBUILD_WITH_TENSILE=ON
			-DHIPSPARSELT_HIPBLASLT_PATH="${hipblaslt_dir}"
			-DGPU_TARGETS="${hipblaslt_targets}"
			-DHIPBLASLT_ENABLE_FETCH=OFF
			-DHIPBLASLT_BUNDLE_PYTHON_DEPS=ON
			-DHIPBLASLT_DEVICE_COMPILER="${HIP_CLANG_PATH}/clang++"
			-Dnanobind_DIR="$(python_get_sitedir)/nanobind/cmake"
			-DPython_EXECUTABLE="${PYTHON}"
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
			-DROCM_SYMLINK_LIBS=OFF
		)
	fi
	rocm_set_default_hipcc
	rocm_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
