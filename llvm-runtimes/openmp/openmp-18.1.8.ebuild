# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+="
		fallback-commit
	"
fi

# For NVPTX, see https://github.com/llvm/llvm-project/blob/release/18.x/openmp/libomptarget/DeviceRTL/CMakeLists.txt#L61
# For CUDA sdk versions, see https://github.com/llvm/llvm-project/blob/release/18.x/clang/include/clang/Basic/Cuda.h
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
	sm_90a
)
inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)

CXX_STANDARD=17
GRPC_SLOT="3"
LLVM_SLOT="${PV%%.*}"
PROTOBUF_SLOT="3"
PYTHON_COMPAT=( "python3_11" )

inherit llvm-ebuilds

inherit flag-o-matic cmake-multilib libstdcxx-slot linux-info llvm.org llvm-utils python-single-r1
inherit toolchain-funcs

if [[ "${PV}" =~ "9999" ]] ; then
llvm_ebuilds_message "${PV%%.*}" "_llvm_set_globals"
	EGIT_BRANCH="${LLVM_EBUILDS_LLVM18_BRANCH}"
	if [[ "${USE}" =~ "fallback-commit" ]] ; then
		EGIT_OVERRIDE_COMMIT_LLVM_LLVM_PROJECT="${LLVM_EBUILDS_LLVM18_FALLBACK_COMMIT}"
	fi
else
	KEYWORDS="
~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86 ~amd64-linux ~x64-macos
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
${LLVM_EBUILDS_LLVM18_REVISION}
cuda +debug gdb-plugin hwloc offload ompt remote-offloading test llvm_targets_NVPTX
ebuild_revision_9
"
gen_cuda_required_use() {
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		echo "
			cuda_targets_${x}? (
				cuda
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
	remote-offloading? (
		offload
	)
"
CUDA_11_8_RDEPEND="
	(
		=dev-util/nvidia-cuda-toolkit-11.8*
		>=dev-util/nvidia-cuda-toolkit-520.61
		virtual/cuda-compiler:0/11.8[${LIBSTDCXX_USEDEP}]
	)
"
CUDA_12_3_RDEPEND="
	(
		=dev-util/nvidia-cuda-toolkit-12.3*
		>=dev-util/nvidia-cuda-toolkit-545.23
		virtual/cuda-compiler:0/12.3[${LIBSTDCXX_USEDEP}]
	)
"
RDEPEND="
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
		virtual/cuda-compiler:=
	)
	cuda_targets_sm_35? (
		${CUDA_11_8_RDEPEND}
	)
	cuda_targets_sm_37? (
		${CUDA_11_8_RDEPEND}
	)
	cuda_targets_sm_50? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
		)
	)
	cuda_targets_sm_52? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
		)
	)
	cuda_targets_sm_53? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
		)
	)
	cuda_targets_sm_60? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
		)
	)
	cuda_targets_sm_61? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
		)
	)
	cuda_targets_sm_62? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
		)
	)
	cuda_targets_sm_70? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
		)
	)
	cuda_targets_sm_72? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
		)
	)
	cuda_targets_sm_75? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
		)
	)
	cuda_targets_sm_80? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
		)
	)
	cuda_targets_sm_86? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
		)
	)
	cuda_targets_sm_87? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
		)
	)
	cuda_targets_sm_89? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
		)
	)
	cuda_targets_sm_90? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
		)
	)
	cuda_targets_sm_90a? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
		)
	)
	gdb-plugin? (
		${PYTHON_DEPS}
	)
	hwloc? (
		>=sys-apps/hwloc-2.5:0[${MULTILIB_USEDEP}]
		sys-apps/hwloc:=
	)
	llvm_targets_NVPTX? (
		|| (
			${CUDA_11_8_RDEPEND}
			${CUDA_12_3_RDEPEND}
		)
		dev-util/nvidia-cuda-toolkit:=
	)
	offload? (
		dev-libs/libffi[${MULTILIB_USEDEP}]
		dev-libs/libffi:=
		~llvm-core/llvm-${PV}[${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
		llvm-core/llvm:=
	)
	remote-offloading? (
		net-libs/grpc:${GRPC_SLOT}[${LIBSTDCXX_USEDEP},cxx]
		net-libs/grpc:=
		virtual/grpc:${GRPC_SLOT}[${LIBSTDCXX_USEDEP}]
		virtual/grpc:=
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
	"${FILESDIR}/${PN}-19.0.0.9999-libffi.patch"
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
	#llvm_pkg_setup
	libstdcxx-slot_verify
}

src_prepare() {
	llvm.org_src_prepare # Already calls cmake_src_prepare
	pushd "${WORKDIR}" || die
		eapply "${FILESDIR}/${PN}-18.1.8-protobuf_install_path.patch"
	popd
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
			-DLIBOMPTARGET_ENABLE_EXPERIMENTAL_REMOTE_PLUGIN=$(usex remote-offloading)

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
			-DLIBOMPTARGET_ENABLE_EXPERIMENTAL_REMOTE_PLUGIN=OFF
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

	if use remote-offloading ; then
		mycmakeargs+=(
			-DGRPC_INSTALL_PATH="${ESYSROOT}/usr/lib/grpc/${GRPC_SLOT}/$(get_libdir)/cmake/grpc"
			-DPROTOBUF_INSTALL_PATH="${ESYSROOT}/usr/lib/protobuf/${PROTOBUF_SLOT}/$(get_libdir)/cmake/protobuf"
		)
	fi

	addpredict "/dev/nvidiactl"
	addpredict "/proc/self/task/"
	cmake_src_configure
}

multilib_src_test() {
	# Respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-libomp
}
