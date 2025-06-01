# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO:  review the install prefix

AMDGPU_TARGETS_COMPAT=(
	gfx908
	gfx90a
	gfx940
	gfx941
	gfx942
	gfx1030
	gfx1031
	gfx1032
	gfx1100
	gfx1101
	gfx1102
)
AMDGPU_UNTESTED_TARGETS=(
#	gfx908
#	gfx90a
	gfx940
	gfx941
	gfx942
#	gfx1030
	gfx1031
	gfx1032
	gfx1100
#	gfx1101
	gfx1102
)
# See https://github.com/GPUOpen-ProfessionalCompute-Libraries/rpp/blob/rocm-6.2.4/docs/release.md?plain=1#L18
LLVM_COMPAT=( 18 )
LLVM_SLOT=${LLVM_COMPAT[0]}
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit check-compiler-switch cmake flag-o-matic rocm toolchain-funcs

if [[ ${PV} == *"9999" ]] ; then
	EGIT_REPO_URI="https://github.com/GPUOpen-ProfessionalCompute-Libraries/rpp/"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-rocm-${PV}"
	SRC_URI="
https://github.com/GPUOpen-ProfessionalCompute-Libraries/rpp/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="AMD ROCm Performance Primitives (RPP) library is a comprehensive \
high-performance computer vision library for AMD processors with HIP/OpenCL/CPU \
back-ends."
HOMEPAGE="https://github.com/GPUOpen-ProfessionalCompute-Libraries/rpp"
LICENSE="MIT"
RESTRICT="test"
SLOT="${ROCM_SLOT}/${PV}"
IUSE+="
${LLVM_COMPAT/#/llvm_slot_}
${ROCM_IUSE}
cpu opencl rocm test
ebuild_revision_15
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
	^^ (
		rocm
		opencl
		cpu
	)
"

RDEPEND="
	${HIPCC_DEPEND}
	${ROCM_CLANG_DEPEND}
	!sci-libs/rpp:0
	>=dev-libs/boost-1.72:=
	dev-libs/rocm-opencl-runtime:${ROCM_SLOT}
	~sys-libs/llvm-roc-libomp-${PV}:${ROCM_SLOT}[${LLVM_ROC_LIBOMP_6_2_AMDGPU_USEDEP}]
	sys-libs/llvm-roc-libomp:=
	opencl? (
		virtual/opencl
	)
	rocm? (
		dev-libs/rocm-device-libs:${ROCM_SLOT}
		~dev-util/hip-${PV}:${ROCM_SLOT}[rocm]
		dev-util/hip:=
	)
"
DEPEND="
	${RDEPEND}
	>=dev-libs/half-1.12.0:=
"
BDEPEND="
	${HIPCC_DEPEND}
	${ROCM_CLANG_DEPEND}
	>=dev-build/cmake-3.5
	test? (
		>=media-libs/libjpeg-turbo-2.0.6.1
		>=media-libs/opencv-3.4.0[jpeg]
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-6.2.4-hardcoded-paths.patch"
)

warn_untested_gpu() {
	local gpu
	for gpu in ${AMDGPU_UNTESTED_TARGETS[@]} ; do
		if use "amdgpu_targets_${gpu}" ; then
ewarn "${gpu} is not CI tested upstream."
		fi
	done
}

pkg_setup() {
	check-compiler-switch_start
	rocm_pkg_setup
	warn_untested_gpu
}

src_prepare() {
	cmake_src_prepare
	IFS=$'\n'
	sed \
		-i \
		-e "s|half/half.hpp|half.hpp|g" \
		$(grep -l -r -e "half/half.hpp" "${S}") \
		|| die
	IFS=$' \t\n'

	# Unbreak rocm builds:
	sed \
		-i \
		-e "s|-O3||g" \
		"CMakeLists.txt" \
		|| die
	sed \
		-i \
		-e "s|-Ofast||g" \
		"CMakeLists.txt" \
		|| die
#	sed \
#		-i \
#		-e "s|-DNDEBUG||g" \
#		"CMakeLists.txt" \
#		|| die
	rocm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_C_COMPILER="${ESYSROOT}${EROCM_LLVM_PATH}/bin/clang"
		-DCMAKE_CXX_COMPILER="${ESYSROOT}${EROCM_LLVM_PATH}/bin/clang++"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DROCM_PATH="${ESYSROOT}${EROCM_PATH}"
	)

	rocm_set_default_clang

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

ewarn
ewarn "If the build fails, use either -O0 or the systemwide optimization level."
ewarn

	if use opencl ; then
		mycmakeargs+=(
			-DBACKEND="OCL"
		)
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMDGPU_TARGETS=$(get_amdgpu_flags)
			-DBACKEND="HIP"
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)
		append-flags \
			--rocm-path="${ESYSROOT}${EROCM_PATH}" \
			--rocm-device-lib-path="${ESYSROOT}${EROCM_PATH}/$(rocm_get_libdir)/amdgcn/bitcode"

		# Fix:
		# lld: error: undefined symbol: __stack_chk_guard
		append-flags \
			-fno-stack-protector
	elif use cpu ; then
		mycmakeargs+=(
			-DBACKEND="CPU"
		)
	fi

einfo "Using libomp"
	mycmakeargs+=(
		-DOpenMP_CXX_FLAGS="-I${ESYSROOT}${EROCM_LLVM_PATH}/include -fopenmp=libomp -Wno-unused-command-line-argument"
		-DOpenMP_CXX_LIB_NAMES="libomp"
		-DOpenMP_libomp_LIBRARY="${ESYSROOT}${EROCM_LLVM_PATH}/$(rocm_get_libdir)/libomp.so"
	)

	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
