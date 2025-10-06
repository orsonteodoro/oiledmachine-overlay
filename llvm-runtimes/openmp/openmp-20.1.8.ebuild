# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Last update:  2024-07-23

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+="
		fallback-commit
	"
fi

# For NVPTX, see https://github.com/llvm/llvm-project/blob/main/openmp/libomptarget/DeviceRTL/CMakeLists.txt#L57C1-L64C1
# For CUDA sdk versions, see https://github.com/llvm/llvm-project/blob/main/clang/include/clang/Basic/Cuda.h#L41
CUDA_TARGETS_COMPAT=(
	auto
	sm_35
	sm_37
	sm_50
	sm_52
	sm_53
	sm_60
	sm_61
	sm_62
	sm_70
	sm_72
	sm_75
	sm_80
	sm_86
	sm_87
	sm_89
	sm_90
)
# For CUDA version see, https://github.com/llvm/llvm-project/blob/llvmorg-20.1.8/clang/include/clang/Basic/Cuda.h
GCC_COMPAT=(
	# Pruned non-GPU slots to simplify GPU offload support.
        "gcc_slot_13_4" # CUDA-12.3 (FC), CUDA-12.4 (PS), CUDA-12.5 (PS), CUDA-12.6 (PS), ROCm-7.0 (U24), U24.04 (GCC default)
        "gcc_slot_12_5" # ROCm-6.2 (U22), ROCm-7.0 (U22)
        "gcc_slot_11_5" # CY2025 is GCC 11.2.1, CUDA-11.8, U22 (GCC default)
)
# FC = Feature Complete
# PS = Partial Support
LLVM_SLOT="${PV%%.*}"
PYTHON_COMPAT=( "python3_12" )

inherit llvm-ebuilds

inherit flag-o-matic cmake-multilib libstdcxx-slot linux-info llvm.org llvm-utils python-single-r1
inherit toolchain-funcs

if [[ "${PV}" =~ "9999" ]] ; then
llvm_ebuilds_message "${PV%%.*}" "_llvm_set_globals"
	EGIT_BRANCH="${LLVM_EBUILDS_LLVM20_BRANCH}"
	if [[ "${USE}" =~ "fallback-commit" ]] ; then
		EGIT_OVERRIDE_COMMIT_LLVM_LLVM_PROJECT="${LLVM_EBUILDS_LLVM20_FALLBACK_COMMIT}"
	fi
else
	KEYWORDS="
amd64 arm arm64 ~loong ~mips ppc64 ~riscv x86 ~amd64-linux ~x64-macos
	"
fi

DESCRIPTION="OpenMP runtime library for LLVM/clang compiler"
HOMEPAGE="https://openmp.llvm.org"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	|| (
		MIT
		UoI-NCSA
	)
"
RESTRICT="
	!test? (
		test
	)
"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
IUSE+="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${LLVM_EBUILDS_LLVM20_REVISION}
debug gdb-plugin hwloc offload ompt test llvm_targets_NVPTX
ebuild_revision_9
"
gen_cuda_required_use() {
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		echo "
			cuda_targets_${x}? (
				llvm_targets_NVPTX
			)
		"
	done
}
REQUIRED_USE="
	$(gen_cuda_required_use)
	gdb-plugin? (
		${PYTHON_REQUIRED_USE}
	)
	llvm_targets_NVPTX? (
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
"
RDEPEND="
	cuda_targets_sm_35? (
		=dev-util/nvidia-cuda-toolkit-11*:=
	)
	cuda_targets_sm_37? (
		=dev-util/nvidia-cuda-toolkit-11*:=
	)
	cuda_targets_sm_50? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12*:=
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_52? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12*:=
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_53? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12*:=
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_60? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12*:=
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_61? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12*:=
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_62? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12*:=
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_70? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12*:=
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_72? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12*:=
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_75? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12*:=
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_80? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12*:=
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_86? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12*:=
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_87? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12*:=
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_89? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12*:=
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_90? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12*:=
			=dev-util/nvidia-cuda-toolkit-11.8*:=
		)
	)
	gdb-plugin? (
		${PYTHON_DEPS}
	)
	hwloc? (
		>=sys-apps/hwloc-2.5:0=[${MULTILIB_USEDEP}]
	)
	llvm_targets_NVPTX? (
		<dev-util/nvidia-cuda-toolkit-12.2
	)
	offload? (
		dev-libs/libffi:=[${MULTILIB_USEDEP}]
		~llvm-core/llvm-${PV}[${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
		llvm-core/llvm:=
	)
"
# Tests:
# - dev-python/lit provides the test runner
# - llvm-core/llvm provide test utils (e.g. FileCheck)
# - llvm-core/clang provides the compiler to run tests
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-lang/perl
	llvm-core/lld:${PV%%.*}
	offload? (
		llvm_targets_NVPTX? (
			llvm-core/clang[${LIBSTDCXX_USEDEP}]
			llvm-core/clang:=
		)
		virtual/pkgconfig
	)
	test? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/lit[${PYTHON_USEDEP}]
		')
		llvm-core/clang
	)
"
LLVM_COMPONENTS=(
	"openmp"
	"cmake"
	"llvm/include"
)
llvm.org_set_globals
PATCHES=(
	"${FILESDIR}/${PN}-17.0.0.9999-sover-suffix.patch"
#	"${FILESDIR}/${PN}-19.0.0.9999-libffi.patch"
)

kernel_pds_check() {
	if use kernel_linux \
		&& kernel_is -lt 4 15 \
		&& kernel_is -ge 4 13 ; then
		local CONFIG_CHECK="~!SCHED_PDS"
		local ERROR_SCHED_PDS="\
PDS scheduler versions >= 0.98c < 0.98i (e.g. used in kernels >= 4.13-pf11
< 4.14-pf9) do not implement sched_yield() call which may result in horrible
performance problems with libomp. If you are using one of the specified
kernel versions, you may want to disable the PDS scheduler."

		check_extra_config
	fi
}

pkg_pretend() {
	kernel_pds_check
}

pkg_setup() {
ewarn "You may need to uninstall =libomp-${PV} first if merge is unsuccessful."
	python-single-r1_pkg_setup
	LLVM_MAX_SLOT="${LLVM_SLOT}"
	llvm_pkg_setup
	libstdcxx-slot_verify
}

src_prepare() {
	llvm.org_src_prepare # Already calls cmake_src_prepare
}

gen_nvptx_list() {
	if use cuda_targets_auto ; then
		echo "auto"
	else
		local list
		local x
		for x in ${CUDA_TARGETS_COMPAT[@]} ; do
			if use "cuda_targets_${x}" ; then
				list+=";${x/sm_}"
			fi
		done
		list="${list:1}"
		echo "${list}"
	fi
}

multilib_src_configure() {
	use offload && llvm_prepend_path "${LLVM_MAJOR}"

	# LTO causes issues in other packages building, #870127
	filter-lto

	# Avoid possible error:
	# ld.bfd: duplicate version tag `VERS1.0'
	filter-flags '-fuse-ld=*'
	append-ldflags -fuse-ld=lld
	strip-unsupported-flags

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	local libdir="$(get_libdir)"
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"
	# Disable unnecessary hack copying stuff back to srcdir. \
		-DLIBOMP_COPY_EXPORTS=OFF
		-DLIBOMP_HEADERS_INSTALL_PATH="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/include"
		-DLIBOMP_INSTALL_ALIASES=ON # For binary packages
		-DLIBOMP_OMPD_GDB_SUPPORT=$(multilib_native_usex gdb-plugin)
		-DLIBOMP_OMPT_SUPPORT=$(usex ompt)
		-DLIBOMP_USE_HWLOC=$(usex hwloc)
		-DLLVM_VERSION_MAJOR="${PV%%.*}"
		-DOPENMP_LIBDIR_SUFFIX="${libdir#lib}"

		-DLIBOMP_HEADERS_INSTALL_PATH="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/include"

		-DPython3_EXECUTABLE="${PYTHON}"
	)

	if use offload && has "${CHOST%%-*}" aarch64 powerpc64le x86_64 ; then
		mycmakeargs+=(
			-DLIBOMPTARGET_BUILD_AMDGPU_PLUGIN=OFF
			-DLIBOMPTARGET_BUILD_CUDA_PLUGIN=$(usex llvm_targets_NVPTX)

	# Prevent trying to access the GPU
			-DLIBOMPTARGET_AMDGPU_ARCH=LIBOMPTARGET_AMDGPU_ARCH-NOTFOUND
			-DLIBOMPTARGET_NVPTX_ARCH=LIBOMPTARGET_NVPTX_ARCH-NOTFOUND

			-DOPENMP_ENABLE_LIBOMPTARGET=ON
		)
		if use llvm_targets_NVPTX ; then
			mycmakeargs+=(
				-DLIBOMPTARGET_NVPTX_COMPUTE_CAPABILITIES=$(gen_nvptx_list)
			)
		fi
		if use ppc64 && ( use llvm_targets_NVPTX ) ; then
			if ! [[ "${CHOST}" =~ "powerpc64le" ]] ; then
eerror
eerror "Big endian is not supported for ppc64 for offload.  Disable either the"
eerror "offload or the llvm_targets_NVPTX USE flag(s) to continue."
eerror
				die
			fi
		fi
	else
		mycmakeargs+=(
			-DCMAKE_DISABLE_FIND_PACKAGE_CUDA=ON
			-DLIBOMPTARGET_BUILD_AMDGPU_PLUGIN=OFF
			-DLIBOMPTARGET_BUILD_CUDA_PLUGIN=OFF
			-DOPENMP_ENABLE_LIBOMPTARGET=OFF
		)
	fi

	use test && mycmakeargs+=(
	# This project does not use standard LLVM cmake macros.
		-DOPENMP_LIT_ARGS="$(get_lit_flags)"
		-DOPENMP_LLVM_LIT_EXECUTABLE="${EPREFIX}/usr/bin/lit"
		-DOPENMP_TEST_C_COMPILER=$(type -P "${CHOST}-clang")
		-DOPENMP_TEST_CXX_COMPILER=$(type -P "${CHOST}-clang++")
	)
	addpredict "/dev/nvidiactl"
	addpredict "/proc/self/task/"
	cmake_src_configure
}

multilib_src_test() {
	# Respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-libomp
}
