# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} =~ 9999 ]] ; then
IUSE+="
	fallback-commit
"
fi

AMDGPU_TARGETS_COMPAT=(
	gfx700
	gfx701
	gfx801
	gfx803
	gfx900
	gfx902
	gfx906
	gfx908
	gfx90a
	gfx90c
	gfx940
	gfx1010
	gfx1030
	gfx1031
	gfx1032
	gfx1033
	gfx1034
	gfx1035
	gfx1036
	gfx1100
	gfx1101
	gfx1102
	gfx1103
	gfx1150
	gfx1151
)
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
ROCM_SKIP_COMMON_PATHS_PATCHES=1

inherit llvm-ebuilds

_llvm_set_globals() {
	if [[ "${USE}" =~ "fallback-commit" && ${PV} =~ 9999 ]] ; then
einfo "Using fallback commit"
		EGIT_OVERRIDE_COMMIT_LLVM_LLVM_PROJECT="${FALLBACK_LLVM17_COMMIT}"
	fi
}
_llvm_set_globals
unset -f _llvm_set_globals

PYTHON_COMPAT=( python3_{10..12} )

inherit flag-o-matic cmake-multilib linux-info llvm llvm.org python-single-r1
inherit rocm toolchain-funcs

DESCRIPTION="OpenMP runtime library for LLVM/clang compiler"
HOMEPAGE="https://openmp.llvm.org"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	|| (
		UoI-NCSA
		MIT
	)
"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
KEYWORDS=""
IUSE+="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${ROCM_IUSE}
+debug gdb-plugin hwloc offload ompt test llvm_targets_AMDGPU llvm_targets_NVPTX
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
gen_rocm_required_use() {
	local x
	for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		echo "
			amdgpu_targets_${x}? (
				llvm_targets_AMDGPU
			)
		"
	done
}
REQUIRED_USE="
	$(gen_cuda_required_use)
	$(gen_rocm_required_use)
	llvm_targets_AMDGPU? (
		${ROCM_REQUIRED_USE}
	)
	llvm_targets_NVPTX? (
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	gdb-plugin? (
		${PYTHON_REQUIRED_USE}
	)
"
ROCM_SLOTS=(
	"5.6.0"
	"5.5.1"
	"5.4.3"
	"5.3.3"
	"5.1.3"
)
gen_amdgpu_rdepend() {
	local pv
	for pv in ${ROCM_SLOTS[@]} ; do
		local s="0/${pv%.*}"
		echo "
			(
				~dev-libs/rocr-runtime-${pv}:${s}
				~dev-libs/roct-thunk-interface-${pv}:${s}
			)
		"
	done
}
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
	llvm_targets_AMDGPU? (
		|| (
			$(gen_amdgpu_rdepend)
		)
	)
	llvm_targets_NVPTX? (
		<dev-util/nvidia-cuda-toolkit-12.2
	)
	offload? (
		dev-libs/libffi:=[${MULTILIB_USEDEP}]
		~sys-devel/llvm-${PV}[${MULTILIB_USEDEP}]
	)
"
# Tests:
# - dev-python/lit provides the test runner
# - sys-devel/llvm provide test utils (e.g. FileCheck)
# - sys-devel/clang provides the compiler to run tests
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-lang/perl
	offload? (
		llvm_targets_AMDGPU? (
			sys-devel/clang
		)
		llvm_targets_NVPTX? (
			sys-devel/clang
		)
		virtual/pkgconfig
	)
	test? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/lit[${PYTHON_USEDEP}]
		')
		sys-devel/clang
	)
"
RESTRICT="
	!test? (
		test
	)
"
LLVM_COMPONENTS=(
	"openmp"
	"cmake"
	"llvm/include"
)
llvm.org_set_globals

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
	use offload && LLVM_MAX_SLOT="${PV%%.*}" llvm_pkg_setup
	if use gdb-plugin || use test; then
		python-single-r1_pkg_setup
	fi
einfo
einfo "The hardmask for llvm_targets_AMDGPU in ${CATEGORY}/${PN} can be removed by doing..."
einfo
einfo "mkdir -p /etc/portage/profile"
einfo "echo \"sys-libs/libomp -llvm_targets_AMDGPU\" >> /etc/portage/profile/package.use.force"
einfo "echo \"sys-libs/libomp -llvm_targets_AMDGPU\" >> /etc/portage/profile/package.use.mask"
einfo
}

src_prepare() {
	llvm.org_src_prepare # Already calls cmake_src_prepare
	rocm_src_prepare
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
	# LTO causes issues in other packages building, #870127
	filter-lto

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	local libdir="$(get_libdir)"
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"
	# Disable unnecessary hack copying stuff back to srcdir. \
		-DLIBOMP_COPY_EXPORTS=OFF
		-DLIBOMP_HEADERS_INSTALL_PATH="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/include"
	# Do not install libgomp.so & libiomp5.so aliases. \
		-DLIBOMP_INSTALL_ALIASES=OFF
		-DLIBOMP_OMPD_GDB_SUPPORT=$(multilib_native_usex gdb-plugin)
		-DLIBOMP_OMPT_SUPPORT=$(usex ompt)
		-DLIBOMP_USE_HWLOC=$(usex hwloc)
	# Prevent trying to access the GPU. \
		-DLIBOMPTARGET_AMDGPU_ARCH=LIBOMPTARGET_AMDGPU_ARCH-NOTFOUND
		-DOPENMP_LIBDIR_SUFFIX="${libdir#lib}"
	)

	if use offload && has "${CHOST%%-*}" aarch64 powerpc64le x86_64 ; then
		mycmakeargs+=(
			-DLIBOMPTARGET_BUILD_AMDGPU_PLUGIN=$(usex llvm_targets_AMDGPU)
			-DLIBOMPTARGET_BUILD_CUDA_PLUGIN=$(usex llvm_targets_NVPTX)
			-DOPENMP_ENABLE_LIBOMPTARGET=ON
		)
		if use llvm_targets_AMDGPU ; then
			mycmakeargs+=(
				-DLIBOMPTARGET_AMDGCN_GFXLIST=$(get_amdgpu_flags)
			)
		fi
		if use llvm_targets_NVPTX ; then
			mycmakeargs+=(
				-DLIBOMPTARGET_NVPTX_COMPUTE_CAPABILITIES=$(gen_nvptx_list)
			)
		fi
		if use ppc64 && ( use llvm_targets_AMDGPU || use llvm_targets_NVPTX ) ; then
			if ! [[ "${CHOST}" =~ "powerpc64le" ]] ; then
eerror
eerror "Big endian is not supported for ppc64 for offload.  Disable either the"
eerror "offload, llvm_targets_AMDGPU, llvm_targets_NVPTX USE flag(s) to"
eerror "continue."
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
		-DOPENMP_TEST_C_COMPILER="$(type -P "${CHOST}-clang")"
		-DOPENMP_TEST_CXX_COMPILER="$(type -P "${CHOST}-clang++")"
	)
	addpredict /dev/nvidiactl
	cmake_src_configure
}

multilib_src_test() {
	# Respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-libomp
}
